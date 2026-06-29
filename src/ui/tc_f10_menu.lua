-- Theater Command DCS
-- File: src/ui/tc_f10_menu.lua
--
-- Purpose:
-- Provide the player-facing F10 menu for Theater Command DCS.
--
-- Current focus:
-- Mission Generator v0.2.1 creates a stable available mission pool,
-- including reserved FOB_SUPPORT missions. This UI exposes the first
-- ten available missions directly through F10 commands.
--
-- Version:
-- 0.2.0
--
-- Responsibilities:
-- - create a Blue coalition Theater Command F10 menu
-- - show available missions
-- - show active missions
-- - show mission details for Mission 1 to Mission 10
-- - activate Mission 1 to Mission 10 directly
-- - show campaign, logistics, FOB and AI CAP status summaries
-- - keep all UI logic state-only
-- - do not trigger real MOOSE, CTLD or Skynet execution
--
-- Vendor note:
-- This file uses native DCS missionCommands and trigger.action functions.
-- It does not directly call MIST, MOOSE, CTLD or Skynet IADS.

TC = TC or {}
TC.modules = TC.modules or {}
TC.UI = TC.UI or {}
TC.ui = TC.ui or TC.UI

local F10Menu = {}

F10Menu.name = "tc_f10_menu"
F10Menu.displayName = "F10 Menu"
F10Menu.path = "src/ui/tc_f10_menu.lua"
F10Menu.version = "0.2.0"

F10Menu.loaded = true
F10Menu.started = false
F10Menu.finished = false
F10Menu.failed = false

F10Menu.menuRootCreated = false
F10Menu.commandCount = 0
F10Menu.lastUpdateTime = 0
F10Menu.lastMessage = nil
F10Menu.lastSelectedMissionKey = nil

F10Menu.outputDuration = 20
F10Menu.maxMissionListItems = 10
F10Menu.maxMissionSelectionItems = 10

F10Menu.menu = {
    root = nil,
    missions = nil,
    missionDetails = nil,
    missionActivation = nil,
    status = nil,
    logistics = nil,
    ai = nil
}

local function getLogger()
    return TC.Logger or TC.logger
end

local function getState()
    return TC.State or TC.state
end

local function getUtils()
    return TC.Utils or TC.utils
end

local function getMissionGenerator()
    if TC.Missions == nil then
        return nil
    end

    return TC.Missions.Generator
end

local function getLogisticsDelivery()
    if TC.Logistics == nil then
        return nil
    end

    return TC.Logistics.Delivery
end

local function getFobSystem()
    if TC.Logistics == nil then
        return nil
    end

    return TC.Logistics.FobSystem
end

local function getAiCapManager()
    if TC.AI == nil then
        return nil
    end

    return TC.AI.CapManager
end

local function rawLog(level, message)
    local formatted = "[TC][F10_MENU] " .. tostring(message)

    if env ~= nil then
        if level == "ERROR" and env.error ~= nil then
            env.error(formatted)
            return
        end

        if level == "WARN" and env.warning ~= nil then
            env.warning(formatted)
            return
        end

        if env.info ~= nil then
            env.info(formatted)
            return
        end
    end

    if print ~= nil then
        print(formatted)
    end
end

local function logInfo(message)
    local logger = getLogger()

    if logger ~= nil and logger.info ~= nil then
        logger.info("[F10Menu] " .. tostring(message))
        return
    end

    rawLog("INFO", message)
end

local function logWarn(message)
    local logger = getLogger()

    if logger ~= nil and logger.warn ~= nil then
        logger.warn("[F10Menu] " .. tostring(message))
        return
    end

    rawLog("WARN", message)
end

local function logError(message)
    local logger = getLogger()

    if logger ~= nil and logger.error ~= nil then
        logger.error("[F10Menu] " .. tostring(message))
        return
    end

    rawLog("ERROR", message)
end

local function logDebug(message)
    local logger = getLogger()

    if logger ~= nil and logger.debug ~= nil then
        logger.debug("[F10Menu] " .. tostring(message))
    end
end

local function getCurrentTime()
    local utils = getUtils()

    if utils ~= nil and utils.getCurrentTime ~= nil then
        return utils.getCurrentTime()
    end

    if timer ~= nil and timer.getTime ~= nil then
        return timer.getTime()
    end

    return 0
end

local function normalizeName(value)
    local utils = getUtils()

    if utils ~= nil and utils.normalizeName ~= nil then
        local normalizedByUtils = utils.normalizeName(value)

        if normalizedByUtils ~= nil and normalizedByUtils ~= "" then
            return normalizedByUtils
        end
    end

    if value == nil then
        return "UNKNOWN"
    end

    local normalized = tostring(value)

    normalized = string.upper(normalized)
    normalized = string.gsub(normalized, "^%s*(.-)%s*$", "%1")
    normalized = string.gsub(normalized, "[%-/]+", "_")
    normalized = string.gsub(normalized, "%s+", "_")
    normalized = string.gsub(normalized, "[^A-Z0-9_]", "_")
    normalized = string.gsub(normalized, "_+", "_")
    normalized = string.gsub(normalized, "^_+", "")
    normalized = string.gsub(normalized, "_+$", "")

    if normalized == "" then
        return "UNKNOWN"
    end

    return normalized
end

local function countTableKeys(targetTable)
    local utils = getUtils()

    if utils ~= nil and utils.countTableKeys ~= nil then
        return utils.countTableKeys(targetTable)
    end

    if type(targetTable) ~= "table" then
        return 0
    end

    local count = 0

    for _ in pairs(targetTable) do
        count = count + 1
    end

    return count
end

local function ensureUiState()
    local state = getState()

    TC.UI = TC.UI or {}
    TC.ui = TC.UI

    if state == nil then
        return nil
    end

    state.UI = state.UI or {}
    state.UI.enabled = true
    state.UI.f10Enabled = true
    state.UI.statusDisplayEnabled = true
    state.UI.menuRootCreated = state.UI.menuRootCreated == true
    state.UI.commandCount = state.UI.commandCount or 0
    state.UI.lastUpdate = state.UI.lastUpdate or 0
    state.UI.lastMessage = state.UI.lastMessage
    state.UI.lastSelectedMissionKey = state.UI.lastSelectedMissionKey
    state.UI.availableMissionCount = state.UI.availableMissionCount or 0
    state.UI.availableMissionSlots = state.UI.availableMissionSlots or {}
    state.UI.menuItems = state.UI.menuItems or {}

    return state
end

local function markDirty(reason)
    local state = getState()

    if state ~= nil and state.markDirty ~= nil then
        state.markDirty(reason or "ui_state_changed")
        return true
    end

    if state ~= nil then
        state.Persistence = state.Persistence or {}
        state.Persistence.dirty = true
        state.Persistence.dirtyReason = reason or "ui_state_changed"
        state.Persistence.dirtyAt = getCurrentTime()
        return true
    end

    return false
end

local function setModuleStatus(status)
    local state = getState()

    if state ~= nil and state.setModuleStatus ~= nil then
        state.setModuleStatus("f10Menu", status)
    end
end

local function setFeatureStatus(enabled)
    local state = getState()

    if state ~= nil and state.setFeatureStatus ~= nil then
        state.setFeatureStatus("f10Menu", enabled == true)
    end
end

local function getBlueCoalition()
    if coalition ~= nil and coalition.side ~= nil and coalition.side.BLUE ~= nil then
        return coalition.side.BLUE
    end

    return 2
end

local function outputToBlue(message, duration)
    local outputDuration = duration or F10Menu.outputDuration
    local text = tostring(message or "")

    F10Menu.lastMessage = text
    F10Menu.lastUpdateTime = getCurrentTime()

    local state = ensureUiState()

    if state ~= nil then
        state.UI.lastMessage = text
        state.UI.lastUpdate = F10Menu.lastUpdateTime
    end

    if trigger ~= nil and trigger.action ~= nil then
        if trigger.action.outTextForCoalition ~= nil then
            local success = pcall(function()
                trigger.action.outTextForCoalition(getBlueCoalition(), text, outputDuration)
            end)

            if success == true then
                return true
            end
        end

        if trigger.action.outText ~= nil then
            local success = pcall(function()
                trigger.action.outText(text, outputDuration)
            end)

            if success == true then
                return true
            end
        end
    end

    logInfo(text)
    return false
end

local function missionCommandsAvailable()
    return missionCommands ~= nil
end

local function addSubMenu(name, parentPath)
    if missionCommandsAvailable() ~= true then
        return nil
    end

    if missionCommands.addSubMenuForCoalition ~= nil then
        local success, result = pcall(function()
            return missionCommands.addSubMenuForCoalition(getBlueCoalition(), name, parentPath)
        end)

        if success == true then
            return result
        end
    end

    if missionCommands.addSubMenu ~= nil then
        local success, result = pcall(function()
            return missionCommands.addSubMenu(name, parentPath)
        end)

        if success == true then
            return result
        end
    end

    return nil
end

local function addCommand(name, parentPath, callback)
    if missionCommandsAvailable() ~= true then
        return nil
    end

    if type(callback) ~= "function" then
        return nil
    end

    if missionCommands.addCommandForCoalition ~= nil then
        local success, result = pcall(function()
            return missionCommands.addCommandForCoalition(getBlueCoalition(), name, parentPath, callback, nil)
        end)

        if success == true then
            F10Menu.commandCount = F10Menu.commandCount + 1
            return result
        end
    end

    if missionCommands.addCommand ~= nil then
        local success, result = pcall(function()
            return missionCommands.addCommand(name, parentPath, callback, nil)
        end)

        if success == true then
            F10Menu.commandCount = F10Menu.commandCount + 1
            return result
        end
    end

    return nil
end

local function getMissionTargetText(missionRecord)
    if type(missionRecord) ~= "table" then
        return "UNKNOWN"
    end

    return missionRecord.targetFobName
        or missionRecord.targetZoneName
        or missionRecord.targetBaseName
        or missionRecord.targetZoneKey
        or missionRecord.targetBaseKey
        or missionRecord.targetFobKey
        or "UNKNOWN"
end

local function getMissionSortName(missionRecord)
    if type(missionRecord) ~= "table" then
        return "UNKNOWN"
    end

    return tostring(
        missionRecord.name
        or missionRecord.displayName
        or missionRecord.key
        or "UNKNOWN"
    )
end

local function getMissionSortKey(missionRecord)
    if type(missionRecord) ~= "table" then
        return "UNKNOWN"
    end

    return tostring(missionRecord.key or getMissionSortName(missionRecord))
end

local function getSortedMissionList(container)
    local result = {}

    if type(container) ~= "table" then
        return result
    end

    for _, missionRecord in pairs(container) do
        if type(missionRecord) == "table" then
            table.insert(result, missionRecord)
        end
    end

    table.sort(result, function(left, right)
        local leftPriority = tonumber(left.priority) or 0
        local rightPriority = tonumber(right.priority) or 0

        if leftPriority ~= rightPriority then
            return leftPriority > rightPriority
        end

        local leftRelevance = tonumber(left.strategicRelevance) or 0
        local rightRelevance = tonumber(right.strategicRelevance) or 0

        if leftRelevance ~= rightRelevance then
            return leftRelevance > rightRelevance
        end

        local leftType = tostring(left.type or "UNKNOWN")
        local rightType = tostring(right.type or "UNKNOWN")

        if leftType ~= rightType then
            return leftType < rightType
        end

        local leftTarget = tostring(getMissionTargetText(left))
        local rightTarget = tostring(getMissionTargetText(right))

        if leftTarget ~= rightTarget then
            return leftTarget < rightTarget
        end

        local leftName = getMissionSortName(left)
        local rightName = getMissionSortName(right)

        if leftName ~= rightName then
            return leftName < rightName
        end

        return getMissionSortKey(left) < getMissionSortKey(right)
    end)

    return result
end

local function updateAvailableMissionSlots(availableMissions)
    local state = ensureUiState()

    if state == nil then
        return
    end

    state.UI.availableMissionSlots = {}
    state.UI.availableMissionCount = #availableMissions
    state.UI.lastUpdate = getCurrentTime()

    local maxItems = math.min(#availableMissions, F10Menu.maxMissionSelectionItems)

    for index = 1, maxItems do
        local missionRecord = availableMissions[index]

        if missionRecord ~= nil then
            state.UI.availableMissionSlots[index] = missionRecord.key
        end
    end
end

local function getAvailableMissionList()
    local missionGenerator = getMissionGenerator()

    if missionGenerator == nil or missionGenerator.getAvailableMissions == nil then
        return {}, "mission_generator_unavailable"
    end

    local availableMissions = getSortedMissionList(missionGenerator.getAvailableMissions())

    updateAvailableMissionSlots(availableMissions)

    return availableMissions, nil
end

local function getAvailableMissionByIndex(index)
    local availableMissions, reason = getAvailableMissionList()

    if reason ~= nil then
        return nil, reason
    end

    if #availableMissions == 0 then
        return nil, "no_available_missions"
    end

    if index == nil or index < 1 or index > F10Menu.maxMissionSelectionItems then
        return nil, "mission_index_out_of_range"
    end

    if index > #availableMissions then
        return nil, "mission_slot_empty"
    end

    return availableMissions[index], nil
end

local function formatMissionLine(index, missionRecord)
    local missionType = missionRecord.type or "UNKNOWN"
    local priority = missionRecord.priority or 0
    local target = getMissionTargetText(missionRecord)
    local status = missionRecord.status or "UNKNOWN"

    return tostring(index)
        .. ". "
        .. tostring(missionType)
        .. " | "
        .. tostring(target)
        .. " | P"
        .. tostring(priority)
        .. " | "
        .. tostring(status)
end

local function addLineIfValue(lines, label, value)
    if value == nil then
        return
    end

    table.insert(lines, tostring(label) .. ": " .. tostring(value))
end

local function buildMissionDetailsText(index, missionRecord, headline)
    if type(missionRecord) ~= "table" then
        return "Theater Command\n\nMission ist nicht verfügbar."
    end

    local lines = {
        "Theater Command",
        tostring(headline or ("Mission " .. tostring(index or "?") .. " Details:")),
        ""
    }

    addLineIfValue(lines, "Slot", index)
    addLineIfValue(lines, "Type", missionRecord.type or "UNKNOWN")
    addLineIfValue(lines, "Status", missionRecord.status or "UNKNOWN")
    addLineIfValue(lines, "Target", getMissionTargetText(missionRecord))
    addLineIfValue(lines, "Owner", missionRecord.owner)
    addLineIfValue(lines, "Priority", missionRecord.priority or 0)
    addLineIfValue(lines, "Strategic Relevance", missionRecord.strategicRelevance or 0)
    addLineIfValue(lines, "Key", missionRecord.key)

    if missionRecord.objective ~= nil then
        table.insert(lines, "")
        table.insert(lines, "Objective:")
        table.insert(lines, tostring(missionRecord.objective))
    end

    if missionRecord.briefing ~= nil then
        table.insert(lines, "")
        table.insert(lines, "Briefing:")
        table.insert(lines, tostring(missionRecord.briefing))
    end

    if type(missionRecord.effect) == "table" then
        table.insert(lines, "")
        table.insert(lines, "Effect:")
        addLineIfValue(lines, " Supply", missionRecord.effect.supply)
        addLineIfValue(lines, " Engineering", missionRecord.effect.engineering)
        addLineIfValue(lines, " FOB Construction", missionRecord.effect.fobConstruction)
        addLineIfValue(lines, " Capture Progress", missionRecord.effect.captureProgress)
    end

    table.insert(lines, "")
    table.insert(lines, "State-only: no MOOSE/CTLD spawn executed.")

    return table.concat(lines, "\n")
end

local function buildMissionSlotUnavailableText(index, reason)
    local reasonText = tostring(reason or "unknown_reason")

    if reason == "mission_generator_unavailable" then
        reasonText = "Mission Generator ist nicht verfügbar."
    elseif reason == "no_available_missions" then
        reasonText = "Keine verfügbaren Missionen."
    elseif reason == "mission_slot_empty" then
        reasonText = "Mission " .. tostring(index) .. " ist aktuell nicht belegt."
    elseif reason == "mission_index_out_of_range" then
        reasonText = "Mission Index außerhalb des erlaubten Bereichs."
    end

    return "Theater Command\n\n" .. reasonText
end

local function buildAvailableMissionsText()
    local availableMissions, reason = getAvailableMissionList()

    if reason ~= nil then
        return buildMissionSlotUnavailableText(nil, reason)
    end

    if #availableMissions == 0 then
        return buildMissionSlotUnavailableText(nil, "no_available_missions")
    end

    local lines = {
        "Theater Command",
        "Verfügbare Missionen:",
        ""
    }

    local maxItems = math.min(#availableMissions, F10Menu.maxMissionListItems)

    for index = 1, maxItems do
        table.insert(lines, formatMissionLine(index, availableMissions[index]))
    end

    table.insert(lines, "")
    table.insert(lines, "Direkte Auswahl:")
    table.insert(lines, "F10 > Theater Command > Missions > Activate Mission > Mission 1-10")
    table.insert(lines, "")
    table.insert(lines, "Details:")
    table.insert(lines, "F10 > Theater Command > Missions > Mission Details > Mission 1-10")

    return table.concat(lines, "\n")
end

local function buildActiveMissionsText()
    local missionGenerator = getMissionGenerator()

    if missionGenerator == nil or missionGenerator.getActiveMissions == nil then
        return "Theater Command\n\nMission Generator ist nicht verfügbar."
    end

    local activeMissions = getSortedMissionList(missionGenerator.getActiveMissions())

    if #activeMissions == 0 then
        return "Theater Command\n\nKeine aktive Mission."
    end

    local lines = {
        "Theater Command",
        "Aktive Missionen:",
        ""
    }

    for index, missionRecord in ipairs(activeMissions) do
        table.insert(lines, formatMissionLine(index, missionRecord))
    end

    return table.concat(lines, "\n")
end

local function buildCampaignStatusText()
    local state = getState()

    if state == nil then
        return "Theater Command\n\nState ist nicht verfügbar."
    end

    local bases = state.Bases or {}
    local zones = state.Zones or {}
    local campaign = state.Campaign or {}
    local phase = campaign.phase or state.campaignPhase or "UNKNOWN"

    local lines = {
        "Theater Command",
        "Kampagnenstatus:",
        "",
        "Phase: " .. tostring(phase),
        "",
        "Basen:",
        " Total: " .. tostring(bases.total or countTableKeys(bases.registry)),
        " Blue: " .. tostring(bases.blue or 0),
        " Red: " .. tostring(bases.red or 0),
        " Neutral: " .. tostring(bases.neutral or 0),
        " Contested: " .. tostring(bases.contested or 0),
        "",
        "Zonen:",
        " Total: " .. tostring(zones.total or countTableKeys(zones.registry)),
        " Blue: " .. tostring(zones.blue or 0),
        " Red: " .. tostring(zones.red or 0),
        " Neutral: " .. tostring(zones.neutral or 0),
        " Contested: " .. tostring(zones.contested or 0)
    }

    return table.concat(lines, "\n")
end

local function buildLogisticsStatusText()
    local logisticsDelivery = getLogisticsDelivery()
    local statistics = nil

    if logisticsDelivery ~= nil and logisticsDelivery.getStatistics ~= nil then
        statistics = logisticsDelivery.getStatistics()
    end

    local state = getState()

    if statistics == nil and state ~= nil and state.Logistics ~= nil then
        statistics = state.Logistics.statistics
    end

    statistics = statistics or {}

    local lines = {
        "Theater Command",
        "Logistikstatus:",
        "",
        "Hubs total: " .. tostring(statistics.hubs or 0),
        "Blue Hubs: " .. tostring(statistics.blueHubs or 0),
        "Red Hubs: " .. tostring(statistics.redHubs or 0),
        "Neutral Hubs: " .. tostring(statistics.neutralHubs or 0),
        "Active Hubs: " .. tostring(statistics.activeHubs or 0),
        "Limited Hubs: " .. tostring(statistics.limitedHubs or 0),
        "",
        "Deliveries: " .. tostring(statistics.deliveries or 0),
        "Planned: " .. tostring(statistics.planned or 0),
        "In Transit: " .. tostring(statistics.inTransit or 0),
        "Delivered: " .. tostring(statistics.delivered or 0)
    }

    return table.concat(lines, "\n")
end

local function buildFobStatusText()
    local fobSystem = getFobSystem()
    local statistics = nil

    if fobSystem ~= nil and fobSystem.getStatistics ~= nil then
        statistics = fobSystem.getStatistics()
    end

    local state = getState()

    if statistics == nil and state ~= nil and state.Logistics ~= nil then
        statistics = state.Logistics.fobStatistics
    end

    statistics = statistics or {}

    local lines = {
        "Theater Command",
        "FOB-Status:",
        "",
        "FOBs total: " .. tostring(statistics.total or 0),
        "Candidates: " .. tostring(statistics.candidates or 0),
        "Planned: " .. tostring(statistics.planned or 0),
        "Under Construction: " .. tostring(statistics.underConstruction or 0),
        "Active: " .. tostring(statistics.active or 0),
        "Damaged: " .. tostring(statistics.damaged or 0),
        "Out of Supply: " .. tostring(statistics.outOfSupply or 0),
        "Destroyed: " .. tostring(statistics.destroyed or 0),
        "",
        "Blue FOBs: " .. tostring(statistics.blue or 0)
    }

    return table.concat(lines, "\n")
end

local function buildAiStatusText()
    local aiCapManager = getAiCapManager()
    local statistics = nil

    if aiCapManager ~= nil and aiCapManager.getStatistics ~= nil then
        statistics = aiCapManager.getStatistics()
    end

    local state = getState()
    local aiState = nil

    if state ~= nil then
        aiState = state.AI
    end

    statistics = statistics or (aiState and aiState.capStatistics) or {}

    local lines = {
        "Theater Command",
        "AI / CAP Status:",
        "",
        "Reaction State: " .. tostring(aiState and aiState.reactionState or "UNKNOWN"),
        "Threat Level: " .. tostring(aiState and aiState.threatLevel or "UNKNOWN"),
        "",
        "CAP Zones: " .. tostring(statistics.zones or 0),
        "Requested CAPs: " .. tostring(statistics.requested or 0),
        "Active CAPs: " .. tostring(statistics.active or 0),
        "Blue Requests: " .. tostring(statistics.blueRequests or 0),
        "Red Requests: " .. tostring(statistics.redRequests or 0)
    }

    return table.concat(lines, "\n")
end

local function showAvailableMissions()
    outputToBlue(buildAvailableMissionsText())
    return true
end

local function showActiveMissions()
    outputToBlue(buildActiveMissionsText())
    return true
end

local function showMissionDetailsByIndex(index)
    local missionRecord, reason = getAvailableMissionByIndex(index)

    if missionRecord == nil then
        outputToBlue(buildMissionSlotUnavailableText(index, reason))
        return false
    end

    outputToBlue(buildMissionDetailsText(index, missionRecord, "Mission " .. tostring(index) .. " Details:"))
    logInfo("Mission details shown through F10: slot=" .. tostring(index) .. " key=" .. tostring(missionRecord.key))

    return true
end

local function showCampaignStatus()
    outputToBlue(buildCampaignStatusText())
    return true
end

local function showLogisticsStatus()
    outputToBlue(buildLogisticsStatusText())
    return true
end

local function showFobStatus()
    outputToBlue(buildFobStatusText())
    return true
end

local function showAiStatus()
    outputToBlue(buildAiStatusText())
    return true
end

local function activateMissionByIndex(index)
    local missionGenerator = getMissionGenerator()

    if missionGenerator == nil or missionGenerator.activateMission == nil then
        outputToBlue("Theater Command\n\nMission Generator ist nicht verfügbar.")
        return false
    end

    local missionRecord, reason = getAvailableMissionByIndex(index)

    if missionRecord == nil then
        outputToBlue(buildMissionSlotUnavailableText(index, reason))
        return false
    end

    local missionKey = missionRecord.key

    if missionKey == nil then
        outputToBlue("Theater Command\n\nMission " .. tostring(index) .. " besitzt keinen gültigen Key.")
        return false
    end

    local success, missionRecordOrReason = missionGenerator.activateMission(
        missionKey,
        "f10_mission_" .. tostring(index) .. "_selected"
    )

    if success ~= true then
        outputToBlue(
            "Theater Command\n\nMission "
            .. tostring(index)
            .. " konnte nicht aktiviert werden: "
            .. tostring(missionRecordOrReason)
        )

        return false
    end

    F10Menu.lastSelectedMissionKey = missionRecordOrReason.key or missionKey
    F10Menu.lastUpdateTime = getCurrentTime()

    local state = ensureUiState()

    if state ~= nil then
        state.UI.lastSelectedMissionKey = F10Menu.lastSelectedMissionKey
        state.UI.lastSelectedMissionIndex = index
        state.UI.lastUpdate = F10Menu.lastUpdateTime
    end

    markDirty("f10_mission_" .. tostring(index) .. "_activated")

    outputToBlue(
        buildMissionDetailsText(
            index,
            missionRecordOrReason,
            "Mission " .. tostring(index) .. " aktiviert:"
        )
    )

    logInfo(
        "Mission activated through F10: slot="
        .. tostring(index)
        .. " key="
        .. tostring(F10Menu.lastSelectedMissionKey)
    )

    return true
end

local function activateTopMission()
    local missionGenerator = getMissionGenerator()

    if missionGenerator == nil or missionGenerator.getTopAvailableMission == nil then
        outputToBlue("Theater Command\n\nMission Generator ist nicht verfügbar.")
        return false
    end

    local topMission = missionGenerator.getTopAvailableMission()

    if topMission == nil then
        outputToBlue("Theater Command\n\nKeine verfügbare Mission zum Aktivieren.")
        return false
    end

    local availableMissions = getSortedMissionList(missionGenerator.getAvailableMissions())
    local topIndex = 1

    for index, missionRecord in ipairs(availableMissions) do
        if missionRecord.key == topMission.key then
            topIndex = index
            break
        end
    end

    return activateMissionByIndex(topIndex)
end

local function createMissionSelectionCommands()
    local detailsParent = F10Menu.menu.missionDetails or F10Menu.menu.missions
    local activationParent = F10Menu.menu.missionActivation or F10Menu.menu.missions

    for index = 1, F10Menu.maxMissionSelectionItems do
        local missionIndex = index

        addCommand(
            "Show Mission " .. tostring(missionIndex) .. " Details",
            detailsParent,
            function()
                return showMissionDetailsByIndex(missionIndex)
            end
        )
    end

    for index = 1, F10Menu.maxMissionSelectionItems do
        local missionIndex = index

        addCommand(
            "Activate Mission " .. tostring(missionIndex),
            activationParent,
            function()
                return activateMissionByIndex(missionIndex)
            end
        )
    end
end

local function createMenuStructure()
    if missionCommandsAvailable() ~= true then
        return false, "missionCommands_unavailable"
    end

    F10Menu.menu.root = addSubMenu("Theater Command")

    if F10Menu.menu.root == nil then
        return false, "root_menu_failed"
    end

    F10Menu.menu.missions = addSubMenu("Missions", F10Menu.menu.root)
    F10Menu.menu.missionDetails = addSubMenu("Mission Details", F10Menu.menu.missions or F10Menu.menu.root)
    F10Menu.menu.missionActivation = addSubMenu("Activate Mission", F10Menu.menu.missions or F10Menu.menu.root)
    F10Menu.menu.status = addSubMenu("Status", F10Menu.menu.root)
    F10Menu.menu.logistics = addSubMenu("Logistics", F10Menu.menu.root)
    F10Menu.menu.ai = addSubMenu("AI", F10Menu.menu.root)

    addCommand("Show Available Missions", F10Menu.menu.missions, showAvailableMissions)
    addCommand("Show Active Missions", F10Menu.menu.missions, showActiveMissions)

    createMissionSelectionCommands()

    addCommand("Show Campaign Status", F10Menu.menu.status, showCampaignStatus)
    addCommand("Show Logistics Status", F10Menu.menu.logistics, showLogisticsStatus)
    addCommand("Show FOB Status", F10Menu.menu.logistics, showFobStatus)
    addCommand("Show AI CAP Status", F10Menu.menu.ai, showAiStatus)

    F10Menu.menuRootCreated = true

    local state = ensureUiState()

    if state ~= nil then
        state.UI.menuRootCreated = true
        state.UI.commandCount = F10Menu.commandCount
        state.UI.directMissionSlots = F10Menu.maxMissionSelectionItems
        state.UI.menuItems = {
            root = "Theater Command",
            missions = "Missions",
            missionDetails = "Mission Details",
            missionActivation = "Activate Mission",
            status = "Status",
            logistics = "Logistics",
            ai = "AI"
        }
        state.UI.lastUpdate = getCurrentTime()
    end

    return true
end

function F10Menu.showAvailableMissions()
    return showAvailableMissions()
end

function F10Menu.showActiveMissions()
    return showActiveMissions()
end

function F10Menu.showMissionDetails(index)
    return showMissionDetailsByIndex(index)
end

function F10Menu.showCampaignStatus()
    return showCampaignStatus()
end

function F10Menu.showLogisticsStatus()
    return showLogisticsStatus()
end

function F10Menu.showFobStatus()
    return showFobStatus()
end

function F10Menu.showAiStatus()
    return showAiStatus()
end

function F10Menu.activateMission(index)
    return activateMissionByIndex(index)
end

function F10Menu.activateTopMission()
    return activateTopMission()
end

function F10Menu.start()
    if F10Menu.started == true and F10Menu.finished == true and F10Menu.failed ~= true then
        logDebug("F10 menu already started")
        return true
    end

    F10Menu.started = true
    F10Menu.finished = false
    F10Menu.failed = false
    F10Menu.commandCount = 0
    F10Menu.lastUpdateTime = getCurrentTime()

    setModuleStatus("STARTING")
    setFeatureStatus(false)

    logInfo("F10 menu started")

    local state = ensureUiState()

    if state == nil then
        F10Menu.failed = true

        setModuleStatus("FAILED")
        setFeatureStatus(false)

        logError("F10 menu failed: state_unavailable")
        return false
    end

    local created, reason = createMenuStructure()

    if created ~= true then
        F10Menu.failed = true

        setModuleStatus("FAILED")
        setFeatureStatus(false)

        logError("F10 menu failed: " .. tostring(reason))
        return false
    end

    F10Menu.finished = true
    F10Menu.failed = false

    setModuleStatus("READY")
    setFeatureStatus(true)

    logInfo("F10 menu initialized: commands=" .. tostring(F10Menu.commandCount))

    return true
end

function F10Menu.stop()
    F10Menu.started = false
    F10Menu.finished = false

    setModuleStatus("STOPPED")
    setFeatureStatus(false)

    logInfo("F10 menu stopped")

    return true
end

function F10Menu.summary()
    local state = getState()
    local uiState = nil

    if state ~= nil then
        uiState = state.UI
    end

    return {
        name = F10Menu.name,
        displayName = F10Menu.displayName,
        path = F10Menu.path,
        version = F10Menu.version,
        loaded = F10Menu.loaded,
        started = F10Menu.started,
        finished = F10Menu.finished,
        failed = F10Menu.failed,
        menuRootCreated = F10Menu.menuRootCreated,
        commandCount = F10Menu.commandCount,
        maxMissionSelectionItems = F10Menu.maxMissionSelectionItems,
        lastUpdateTime = F10Menu.lastUpdateTime,
        lastSelectedMissionKey = F10Menu.lastSelectedMissionKey,
        lastMessage = F10Menu.lastMessage,
        state = uiState
    }
end

TC.UI.F10Menu = F10Menu
TC.ui.F10Menu = F10Menu

TC.modules.f10Menu = {
    name = F10Menu.name,
    path = F10Menu.path,
    loaded = true,
    version = F10Menu.version
}

setModuleStatus("LOADED")
logInfo("Loaded " .. F10Menu.path .. " v" .. F10Menu.version)

return F10Menu
