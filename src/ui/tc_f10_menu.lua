-- Theater Command DCS
-- File: src/ui/tc_f10_menu.lua
--
-- Purpose:
-- Provide the player-facing F10 menu for Theater Command DCS.
--
-- Current focus:
-- F10Menu v0.2.3 keeps the proven Mission/Logistics/FOB/AI/Capture
-- status functions from v0.2.2 and adds a controlled state-only
-- Capture Ready apply command for Capture Ready Zone 1.
--
-- Version:
-- 0.2.3
--
-- Responsibilities:
-- - create a Blue coalition Theater Command F10 menu
-- - show available missions
-- - show active missions
-- - show mission details for Mission 1 to Mission 10
-- - activate Mission 1 to Mission 10 directly
-- - show campaign, capture, logistics, FOB and AI CAP status summaries
-- - show Capture Ready zones
-- - show Pressure Contested zones
-- - show active mission outcome status
-- - complete Active Mission 1 state-only
-- - fail Active Mission 1 state-only
-- - apply Capture Ready Zone 1 state-only through CaptureSystem
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
F10Menu.version = "0.2.3"
F10Menu.loaded = true
F10Menu.started = false
F10Menu.finished = false
F10Menu.failed = false

F10Menu.menuRootCreated = false
F10Menu.commandCount = 0
F10Menu.lastUpdateTime = 0
F10Menu.lastMessage = nil

F10Menu.lastSelectedMissionKey = nil
F10Menu.lastOutcomeMissionKey = nil
F10Menu.lastOutcomeAction = nil

F10Menu.lastAppliedCaptureZoneKey = nil
F10Menu.lastAppliedCaptureZoneName = nil
F10Menu.lastAppliedCaptureOwner = nil
F10Menu.lastAppliedCaptureStatus = nil

F10Menu.outputDuration = 20
F10Menu.maxMissionListItems = 10
F10Menu.maxMissionSelectionItems = 10
F10Menu.maxActiveMissionSelectionItems = 10
F10Menu.maxCaptureListItems = 10
F10Menu.maxCaptureApplyItems = 1

F10Menu.menu = {
    root = nil,
    missions = nil,
    missionDetails = nil,
    missionActivation = nil,
    missionOutcome = nil,
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

local function getCaptureSystem()
    if TC.Campaign ~= nil and TC.Campaign.CaptureSystem ~= nil then
        return TC.Campaign.CaptureSystem
    end

    if TC.campaign ~= nil and TC.campaign.CaptureSystem ~= nil then
        return TC.campaign.CaptureSystem
    end

    return nil
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

local function shallowCopy(source)
    local result = {}

    if type(source) ~= "table" then
        return result
    end

    for key, value in pairs(source) do
        if type(value) ~= "function" and type(value) ~= "userdata" and type(value) ~= "thread" then
            result[key] = value
        end
    end

    return result
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
    state.UI.lastOutcomeMissionKey = state.UI.lastOutcomeMissionKey
    state.UI.lastOutcomeAction = state.UI.lastOutcomeAction
    state.UI.lastAppliedCaptureZoneKey = state.UI.lastAppliedCaptureZoneKey
    state.UI.lastAppliedCaptureZoneName = state.UI.lastAppliedCaptureZoneName
    state.UI.lastAppliedCaptureOwner = state.UI.lastAppliedCaptureOwner
    state.UI.lastAppliedCaptureStatus = state.UI.lastAppliedCaptureStatus
    state.UI.availableMissionCount = state.UI.availableMissionCount or 0
    state.UI.availableMissionSlots = state.UI.availableMissionSlots or {}
    state.UI.activeMissionCount = state.UI.activeMissionCount or 0
    state.UI.activeMissionSlots = state.UI.activeMissionSlots or {}
    state.UI.menuItems = state.UI.menuItems or {}
    state.UI.captureStatus = state.UI.captureStatus or {}
    state.UI.captureReadyZones = state.UI.captureReadyZones or {}
    state.UI.pressureContestedZones = state.UI.pressureContestedZones or {}
    state.UI.captureApply = state.UI.captureApply or {}
    state.UI.missionOutcome = state.UI.missionOutcome or {}

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

    return tostring(missionRecord.name or missionRecord.displayName or missionRecord.key or "UNKNOWN")
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

local function updateActiveMissionSlots(activeMissions)
    local state = ensureUiState()

    if state == nil then
        return
    end

    state.UI.activeMissionSlots = {}
    state.UI.activeMissionCount = #activeMissions
    state.UI.lastUpdate = getCurrentTime()

    local maxItems = math.min(#activeMissions, F10Menu.maxActiveMissionSelectionItems)

    for index = 1, maxItems do
        local missionRecord = activeMissions[index]

        if missionRecord ~= nil then
            state.UI.activeMissionSlots[index] = missionRecord.key
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

local function getActiveMissionList()
    local missionGenerator = getMissionGenerator()

    if missionGenerator == nil or missionGenerator.getActiveMissions == nil then
        return {}, "mission_generator_unavailable"
    end

    local activeMissions = getSortedMissionList(missionGenerator.getActiveMissions())

    updateActiveMissionSlots(activeMissions)

    return activeMissions, nil
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

local function getActiveMissionByIndex(index)
    local activeMissions, reason = getActiveMissionList()

    if reason ~= nil then
        return nil, reason
    end

    if #activeMissions == 0 then
        return nil, "no_active_missions"
    end

    if index == nil or index < 1 or index > F10Menu.maxActiveMissionSelectionItems then
        return nil, "active_mission_index_out_of_range"
    end

    if index > #activeMissions then
        return nil, "active_mission_slot_empty"
    end

    return activeMissions[index], nil
end

local function formatMissionLine(index, missionRecord)
    local missionType = missionRecord.type or "UNKNOWN"
    local priority = missionRecord.priority or 0
    local target = getMissionTargetText(missionRecord)
    local status = missionRecord.status or "UNKNOWN"

    return tostring(index) .. ". "
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

    if type(missionRecord.progress) == "table" then
        table.insert(lines, "")
        table.insert(lines, "Progress:")
        addLineIfValue(lines, " Stage", missionRecord.progress.stage)
        addLineIfValue(lines, " Percent", missionRecord.progress.percent)
        addLineIfValue(lines, " State-only", missionRecord.progress.stateOnly)
    end

    if type(missionRecord.outcome) == "table" then
        table.insert(lines, "")
        table.insert(lines, "Outcome:")
        addLineIfValue(lines, " Status", missionRecord.outcome.status)
        addLineIfValue(lines, " Reason", missionRecord.outcome.reason)
        addLineIfValue(lines, " State-only", missionRecord.outcome.stateOnly)
    end

    if type(missionRecord.effectState) == "table" then
        table.insert(lines, "")
        table.insert(lines, "Effect State:")
        addLineIfValue(lines, " Status", missionRecord.effectState.status)
        addLineIfValue(lines, " Prepared", missionRecord.effectState.prepared)
        addLineIfValue(lines, " Applied", missionRecord.effectState.applied)
        addLineIfValue(lines, " State-only", missionRecord.effectState.stateOnly)
    end

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
        addLineIfValue(lines, " Capture Pressure", missionRecord.effect.capturePressure)
        addLineIfValue(lines, " Airbase Pressure", missionRecord.effect.airbasePressure)
        addLineIfValue(lines, " IADS Suppression Pressure", missionRecord.effect.iadsSuppressionPressure)
    end

    table.insert(lines, "")
    table.insert(lines, "State-only: no MOOSE/CTLD/Skynet action executed.")

    return table.concat(lines, "\n")
end

local function buildMissionSlotUnavailableText(index, reason)
    local reasonText = tostring(reason or "unknown_reason")

    if reason == "mission_generator_unavailable" then
        reasonText = "Mission Generator ist nicht verfügbar."
    elseif reason == "no_available_missions" then
        reasonText = "Keine verfügbaren Missionen."
    elseif reason == "no_active_missions" then
        reasonText = "Keine aktive Mission."
    elseif reason == "mission_slot_empty" then
        reasonText = "Mission " .. tostring(index) .. " ist aktuell nicht belegt."
    elseif reason == "active_mission_slot_empty" then
        reasonText = "Aktive Mission " .. tostring(index) .. " ist aktuell nicht belegt."
    elseif reason == "mission_index_out_of_range" then
        reasonText = "Mission Index außerhalb des erlaubten Bereichs."
    elseif reason == "active_mission_index_out_of_range" then
        reasonText = "Aktive Mission Index außerhalb des erlaubten Bereichs."
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
    local activeMissions, reason = getActiveMissionList()

    if reason ~= nil then
        return buildMissionSlotUnavailableText(nil, reason)
    end

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

local function buildMissionOutcomeStatusText()
    local missionGenerator = getMissionGenerator()

    if missionGenerator == nil then
        return "Theater Command\n\nMission Generator ist nicht verfügbar."
    end

    local activeMissions, reason = getActiveMissionList()

    if reason ~= nil then
        return buildMissionSlotUnavailableText(nil, reason)
    end

    local statistics = {}

    if missionGenerator.getStatistics ~= nil then
        local success, result = pcall(function()
            return missionGenerator.getStatistics()
        end)

        if success == true and type(result) == "table" then
            statistics = result
        end
    end

    local lines = {
        "Theater Command",
        "Mission Outcome Status:",
        "",
        "available: " .. tostring(statistics.available or 0),
        "active: " .. tostring(statistics.active or #activeMissions),
        "completed: " .. tostring(statistics.completed or 0),
        "failed: " .. tostring(statistics.failed or 0),
        "expired: " .. tostring(statistics.expired or 0),
        "cancelled: " .. tostring(statistics.cancelled or 0),
        "preparedEffects: " .. tostring(statistics.preparedEffects or 0),
        ""
    }

    if #activeMissions == 0 then
        table.insert(lines, "Keine aktive Mission.")
        table.insert(lines, "")
        table.insert(lines, "Ablauf:")
        table.insert(lines, "1. Mission aktivieren")
        table.insert(lines, "2. Outcome-Funktion erneut testen")
    else
        table.insert(lines, "Aktive Mission 1:")
        table.insert(lines, formatMissionLine(1, activeMissions[1]))

        local missionRecord = activeMissions[1]

        if type(missionRecord.progress) == "table" then
            table.insert(lines, "Progress: " .. tostring(missionRecord.progress.stage) .. " / " .. tostring(missionRecord.progress.percent or 0) .. "%")
        end

        if type(missionRecord.effectState) == "table" then
            table.insert(lines, "EffectState: " .. tostring(missionRecord.effectState.status or "UNKNOWN"))
        end
    end

    table.insert(lines, "")
    table.insert(lines, "State-only: no MOOSE/CTLD/Skynet action executed.")

    local state = ensureUiState()

    if state ~= nil then
        state.UI.missionOutcome.lastShownAt = getCurrentTime()
        state.UI.missionOutcome.activeMissionCount = #activeMissions
        state.UI.missionOutcome.statistics = shallowCopy(statistics)
        state.UI.lastUpdate = getCurrentTime()
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

local function getCaptureSummaryFallback()
    local state = getState()

    if state == nil or state.Campaign == nil or state.Campaign.capture == nil then
        return nil
    end

    local capture = state.Campaign.capture
    local statistics = capture.statistics or {}

    return {
        eligibleBases = statistics.eligibleBases or countTableKeys(capture.captureEligibleBases),
        eligibleZones = statistics.eligibleZones or countTableKeys(capture.captureEligibleZones),
        pressureRecords = statistics.pressureRecords or countTableKeys(capture.pressure),
        progressRecords = statistics.progressRecords or countTableKeys(capture.progress),
        captureReady = statistics.captureReady or statistics.ready or 0,
        pressureContested = statistics.contestedByPressure or statistics.pressureContested or statistics.contested or 0,
        appliedMissionEffects = statistics.appliedMissionEffects or countTableKeys(capture.appliedMissionEffects),
        eventCount = countTableKeys(capture.events)
    }
end

local function getCaptureSummary()
    local captureSystem = getCaptureSystem()
    local summary = nil

    if captureSystem ~= nil and captureSystem.getCaptureSummary ~= nil then
        local success, result = pcall(function()
            return captureSystem.getCaptureSummary()
        end)

        if success == true and type(result) == "table" then
            summary = result
        else
            logWarn("Capture summary unavailable through CaptureSystem.getCaptureSummary")
        end
    end

    if summary == nil and captureSystem ~= nil and captureSystem.summary ~= nil then
        local success, result = pcall(function()
            return captureSystem.summary()
        end)

        if success == true and type(result) == "table" then
            summary = {
                eligibleBases = result.eligibleBases or 0,
                eligibleZones = result.eligibleZones or 0,
                pressureRecords = result.pressureRecords or 0,
                progressRecords = result.progressRecords or 0,
                captureReady = result.lastPressureSummary and result.lastPressureSummary.ready or 0,
                pressureContested = result.lastPressureSummary and result.lastPressureSummary.contested or 0,
                appliedMissionEffects = result.appliedMissionEffects or 0,
                eventCount = result.captureEventCount or 0
            }
        end
    end

    if summary == nil then
        summary = getCaptureSummaryFallback()
    end

    return summary
end

local function buildCaptureStatusText()
    local summary = getCaptureSummary()

    if summary == nil then
        return "Theater Command\n\nCaptureSystem ist nicht verfügbar."
    end

    local captureReady = summary.captureReady or summary.ready or 0
    local pressureContested = summary.pressureContested or summary.contested or summary.contestedByPressure or 0

    local lines = {
        "Theater Command",
        "Capture-/Pressure-Status:",
        "",
        "eligibleBases: " .. tostring(summary.eligibleBases or 0),
        "eligibleZones: " .. tostring(summary.eligibleZones or 0),
        "pressureRecords: " .. tostring(summary.pressureRecords or 0),
        "progressRecords: " .. tostring(summary.progressRecords or 0),
        "captureReady: " .. tostring(captureReady),
        "pressureContested: " .. tostring(pressureContested),
        "appliedMissionEffects: " .. tostring(summary.appliedMissionEffects or 0),
        "",
        "State-only: no automatic ownership change executed."
    }

    if summary.eventCount ~= nil then
        table.insert(lines, "captureEvents: " .. tostring(summary.eventCount))
    end

    local state = ensureUiState()

    if state ~= nil then
        state.UI.captureStatus = shallowCopy(summary)
        state.UI.captureStatus.lastShownAt = getCurrentTime()
        state.UI.lastUpdate = getCurrentTime()
    end

    return table.concat(lines, "\n")
end

local function getZoneRecord(zoneKey, progressRecord)
    local state = getState()

    if state ~= nil and state.Zones ~= nil and state.Zones.registry ~= nil then
        if zoneKey ~= nil and state.Zones.registry[zoneKey] ~= nil then
            return state.Zones.registry[zoneKey]
        end

        if type(progressRecord) == "table" and progressRecord.zoneKey ~= nil and state.Zones.registry[progressRecord.zoneKey] ~= nil then
            return state.Zones.registry[progressRecord.zoneKey]
        end
    end

    return nil
end

local function getProgressZoneName(zoneKey, progressRecord)
    if type(progressRecord) ~= "table" then
        return tostring(zoneKey or "UNKNOWN")
    end

    if progressRecord.zoneName ~= nil then
        return tostring(progressRecord.zoneName)
    end

    if progressRecord.name ~= nil then
        return tostring(progressRecord.name)
    end

    if progressRecord.displayName ~= nil then
        return tostring(progressRecord.displayName)
    end

    local zoneRecord = getZoneRecord(zoneKey, progressRecord)

    if zoneRecord ~= nil then
        return tostring(zoneRecord.displayName or zoneRecord.name or zoneRecord.key or zoneKey or "UNKNOWN")
    end

    return tostring(progressRecord.zoneKey or zoneKey or "UNKNOWN")
end

local function getProgressSortOwner(progressRecord)
    if type(progressRecord) ~= "table" then
        return "UNKNOWN"
    end

    return tostring(progressRecord.dominantOwner or progressRecord.owner or "UNKNOWN")
end

local function getSortedProgressList(container)
    local result = {}

    if type(container) ~= "table" then
        return result
    end

    for zoneKey, progressRecord in pairs(container) do
        if type(progressRecord) == "table" then
            table.insert(result, {
                key = zoneKey,
                record = progressRecord,
                name = getProgressZoneName(zoneKey, progressRecord)
            })
        end
    end

    table.sort(result, function(left, right)
        local leftPercent = tonumber(left.record.percent) or 0
        local rightPercent = tonumber(right.record.percent) or 0

        if leftPercent ~= rightPercent then
            return leftPercent > rightPercent
        end

        local leftOwner = getProgressSortOwner(left.record)
        local rightOwner = getProgressSortOwner(right.record)

        if leftOwner ~= rightOwner then
            return leftOwner < rightOwner
        end

        if left.name ~= right.name then
            return left.name < right.name
        end

        return tostring(left.key or "") < tostring(right.key or "")
    end)

    return result
end

local function getCaptureReadyZones()
    local captureSystem = getCaptureSystem()

    if captureSystem ~= nil and captureSystem.getCaptureReadyZones ~= nil then
        local success, result = pcall(function()
            return captureSystem.getCaptureReadyZones()
        end)

        if success == true and type(result) == "table" then
            return result
        end

        logWarn("Capture ready zones unavailable through CaptureSystem.getCaptureReadyZones")
    end

    local state = getState()
    local result = {}

    if state ~= nil and state.Campaign ~= nil and state.Campaign.capture ~= nil then
        local progress = state.Campaign.capture.progress or {}

        for key, progressRecord in pairs(progress) do
            if type(progressRecord) == "table" and progressRecord.captureReady == true then
                result[key] = progressRecord
            end
        end
    end

    return result
end

local function getPressureContestedZones()
    local captureSystem = getCaptureSystem()

    if captureSystem ~= nil and captureSystem.getPressureContestedZones ~= nil then
        local success, result = pcall(function()
            return captureSystem.getPressureContestedZones()
        end)

        if success == true and type(result) == "table" then
            return result
        end

        logWarn("Pressure contested zones unavailable through CaptureSystem.getPressureContestedZones")
    end

    local state = getState()
    local result = {}

    if state ~= nil and state.Campaign ~= nil and state.Campaign.capture ~= nil then
        local progress = state.Campaign.capture.progress or {}

        for key, progressRecord in pairs(progress) do
            if type(progressRecord) == "table" and progressRecord.status == "CONTESTED" then
                result[key] = progressRecord
            end
        end
    end

    return result
end

local function formatProgressLine(index, item)
    local progressRecord = item.record or {}
    local percent = tonumber(progressRecord.percent) or 0
    local owner = progressRecord.owner or "UNKNOWN"
    local dominantOwner = progressRecord.dominantOwner or "UNKNOWN"
    local status = progressRecord.status or "UNKNOWN"
    local threshold = progressRecord.threshold or 0
    local bluePressure = progressRecord.bluePressure or 0
    local redPressure = progressRecord.redPressure or 0
    local contestedPressure = progressRecord.contestedPressure or 0

    return tostring(index) .. ". "
        .. tostring(item.name or item.key or "UNKNOWN")
        .. " | "
        .. tostring(status)
        .. " | "
        .. tostring(owner)
        .. " -> "
        .. tostring(dominantOwner)
        .. " | "
        .. tostring(percent)
        .. "%"
        .. " | B/R/C "
        .. tostring(bluePressure)
        .. "/"
        .. tostring(redPressure)
        .. "/"
        .. tostring(contestedPressure)
        .. " | T"
        .. tostring(threshold)
end

local function buildCaptureProgressListText(title, emptyText, container, uiStateKey)
    local sorted = getSortedProgressList(container)
    local state = ensureUiState()

    if state ~= nil then
        state.UI[uiStateKey] = {}
        state.UI[uiStateKey .. "Count"] = #sorted
        state.UI[uiStateKey .. "LastShownAt"] = getCurrentTime()
        state.UI.lastUpdate = getCurrentTime()
    end

    if #sorted == 0 then
        return "Theater Command\n\n" .. tostring(emptyText)
    end

    local lines = {
        "Theater Command",
        tostring(title),
        ""
    }

    local maxItems = math.min(#sorted, F10Menu.maxCaptureListItems)

    for index = 1, maxItems do
        local item = sorted[index]
        table.insert(lines, formatProgressLine(index, item))

        if state ~= nil then
            state.UI[uiStateKey][index] = item.key
        end
    end

    if #sorted > maxItems then
        table.insert(lines, "")
        table.insert(lines, "Weitere Einträge: " .. tostring(#sorted - maxItems))
    end

    table.insert(lines, "")
    table.insert(lines, "State-only: no capture execution triggered.")

    return table.concat(lines, "\n")
end

local function buildCaptureReadyZonesText()
    return buildCaptureProgressListText(
        "Capture Ready Zones:",
        "Keine Capture Ready Zones.",
        getCaptureReadyZones(),
        "captureReadyZones"
    )
end

local function buildPressureContestedZonesText()
    return buildCaptureProgressListText(
        "Pressure Contested Zones:",
        "Keine Pressure Contested Zones.",
        getPressureContestedZones(),
        "pressureContestedZones"
    )
end

local function getCaptureReadyZoneByIndex(index)
    local readyZones = getSortedProgressList(getCaptureReadyZones())

    if #readyZones == 0 then
        return nil, "no_capture_ready_zones"
    end

    if index == nil or index < 1 or index > F10Menu.maxCaptureApplyItems then
        return nil, "capture_ready_index_out_of_range"
    end

    if index > #readyZones then
        return nil, "capture_ready_slot_empty"
    end

    return readyZones[index], nil
end

local function buildCaptureReadyApplyUnavailableText(index, reason)
    local reasonText = tostring(reason or "unknown_reason")

    if reason == "capture_system_unavailable" then
        reasonText = "CaptureSystem ist nicht verfügbar."
    elseif reason == "capture_apply_function_unavailable" then
        reasonText = "CaptureSystem.evaluateZoneCapture ist nicht verfügbar."
    elseif reason == "no_capture_ready_zones" then
        reasonText = "Keine Capture Ready Zone verfügbar."
    elseif reason == "capture_ready_slot_empty" then
        reasonText = "Capture Ready Zone " .. tostring(index) .. " ist aktuell nicht belegt."
    elseif reason == "capture_ready_index_out_of_range" then
        reasonText = "Capture Ready Index außerhalb des erlaubten Bereichs."
    elseif reason == "capture_ready_zone_not_captured" then
        reasonText = "Capture Ready Zone wurde nicht übernommen. Zone ist möglicherweise nicht mehr capture-ready."
    end

    return "Theater Command\n\n" .. reasonText
end

local function buildCaptureReadyApplySuccessText(index, item, result)
    local progressRecord = item.record or {}
    local zoneResult = nil

    if type(result) == "table" then
        zoneResult = result.zone
    end

    local zoneName = tostring(item.name or item.key or "UNKNOWN")
    local zoneKey = tostring(item.key or progressRecord.zoneKey or "UNKNOWN")
    local previousOwner = tostring(progressRecord.owner or "UNKNOWN")
    local newOwner = tostring(progressRecord.dominantOwner or (zoneResult and zoneResult.owner) or "UNKNOWN")
    local percent = tostring(progressRecord.percent or 0)

    local lines = {
        "Theater Command",
        "Capture Ready Zone angewendet:",
        "",
        "Slot: " .. tostring(index),
        "Zone: " .. zoneName,
        "Key: " .. zoneKey,
        "Owner: " .. previousOwner .. " -> " .. newOwner,
        "Progress: " .. percent .. "%",
        "",
        "State-only Ownership-Wechsel ausgeführt.",
        "Linked Airbase Ownership wurde über CaptureSystem synchronisiert, falls verknüpft.",
        "Capture Pressure wurde durch CaptureSystem zurückgesetzt.",
        "",
        "Keine MOOSE-Spawns.",
        "Keine CTLD-Aktion.",
        "Keine Skynet-Aktion."
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

local function showActiveMissionOutcomeStatus()
    outputToBlue(buildMissionOutcomeStatusText())
    logInfo("Active mission outcome status shown through F10")
    return true
end

local function showCampaignStatus()
    outputToBlue(buildCampaignStatusText())
    return true
end

local function showCaptureStatus()
    outputToBlue(buildCaptureStatusText())
    logInfo("Capture status shown through F10")
    return true
end

local function showCaptureReadyZones()
    outputToBlue(buildCaptureReadyZonesText())
    logInfo("Capture ready zones shown through F10")
    return true
end

local function showPressureContestedZones()
    outputToBlue(buildPressureContestedZonesText())
    logInfo("Pressure contested zones shown through F10")
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

    logInfo("Mission activated through F10: slot=" .. tostring(index) .. " key=" .. tostring(F10Menu.lastSelectedMissionKey))

    return true
end

local function completeActiveMissionByIndex(index)
    local missionGenerator = getMissionGenerator()

    if missionGenerator == nil or missionGenerator.completeMission == nil then
        outputToBlue("Theater Command\n\nMission Generator completeMission ist nicht verfügbar.")
        return false
    end

    local missionRecord, reason = getActiveMissionByIndex(index)

    if missionRecord == nil then
        outputToBlue(buildMissionSlotUnavailableText(index, reason))
        return false
    end

    local success, missionRecordOrReason = missionGenerator.completeMission(
        missionRecord.key,
        "f10_active_mission_" .. tostring(index) .. "_completed"
    )

    if success ~= true then
        outputToBlue(
            "Theater Command\n\nAktive Mission "
                .. tostring(index)
                .. " konnte nicht abgeschlossen werden: "
                .. tostring(missionRecordOrReason)
        )

        return false
    end

    F10Menu.lastOutcomeMissionKey = missionRecordOrReason.key or missionRecord.key
    F10Menu.lastOutcomeAction = "COMPLETED"
    F10Menu.lastUpdateTime = getCurrentTime()

    local state = ensureUiState()

    if state ~= nil then
        state.UI.lastOutcomeMissionKey = F10Menu.lastOutcomeMissionKey
        state.UI.lastOutcomeAction = F10Menu.lastOutcomeAction
        state.UI.lastOutcomeIndex = index
        state.UI.lastUpdate = F10Menu.lastUpdateTime
    end

    markDirty("f10_active_mission_" .. tostring(index) .. "_completed")

    outputToBlue(
        buildMissionDetailsText(
            index,
            missionRecordOrReason,
            "Aktive Mission " .. tostring(index) .. " abgeschlossen:"
        )
    )

    logInfo(
        "Mission completed through F10: slot="
            .. tostring(index)
            .. " key="
            .. tostring(F10Menu.lastOutcomeMissionKey)
            .. " stateOnly=true effects=prepared"
    )

    return true
end

local function failActiveMissionByIndex(index)
    local missionGenerator = getMissionGenerator()

    if missionGenerator == nil or missionGenerator.failMission == nil then
        outputToBlue("Theater Command\n\nMission Generator failMission ist nicht verfügbar.")
        return false
    end

    local missionRecord, reason = getActiveMissionByIndex(index)

    if missionRecord == nil then
        outputToBlue(buildMissionSlotUnavailableText(index, reason))
        return false
    end

    local success, missionRecordOrReason = missionGenerator.failMission(
        missionRecord.key,
        "f10_active_mission_" .. tostring(index) .. "_failed"
    )

    if success ~= true then
        outputToBlue(
            "Theater Command\n\nAktive Mission "
                .. tostring(index)
                .. " konnte nicht als fehlgeschlagen gesetzt werden: "
                .. tostring(missionRecordOrReason)
        )

        return false
    end

    F10Menu.lastOutcomeMissionKey = missionRecordOrReason.key or missionRecord.key
    F10Menu.lastOutcomeAction = "FAILED"
    F10Menu.lastUpdateTime = getCurrentTime()

    local state = ensureUiState()

    if state ~= nil then
        state.UI.lastOutcomeMissionKey = F10Menu.lastOutcomeMissionKey
        state.UI.lastOutcomeAction = F10Menu.lastOutcomeAction
        state.UI.lastOutcomeIndex = index
        state.UI.lastUpdate = F10Menu.lastUpdateTime
    end

    markDirty("f10_active_mission_" .. tostring(index) .. "_failed")

    outputToBlue(
        buildMissionDetailsText(
            index,
            missionRecordOrReason,
            "Aktive Mission " .. tostring(index) .. " fehlgeschlagen:"
        )
    )

    logInfo(
        "Mission failed through F10: slot="
            .. tostring(index)
            .. " key="
            .. tostring(F10Menu.lastOutcomeMissionKey)
            .. " stateOnly=true effects=prepared"
    )

    return true
end

local function applyCaptureReadyZoneByIndex(index)
    local captureSystem = getCaptureSystem()

    if captureSystem == nil then
        outputToBlue(buildCaptureReadyApplyUnavailableText(index, "capture_system_unavailable"))
        return false
    end

    if captureSystem.evaluateZoneCapture == nil then
        outputToBlue(buildCaptureReadyApplyUnavailableText(index, "capture_apply_function_unavailable"))
        return false
    end

    local item, reason = getCaptureReadyZoneByIndex(index)

    if item == nil then
        outputToBlue(buildCaptureReadyApplyUnavailableText(index, reason))
        return false
    end

    local zoneKey = item.key or (item.record and item.record.zoneKey)

    if zoneKey == nil then
        outputToBlue(buildCaptureReadyApplyUnavailableText(index, "capture_ready_slot_empty"))
        return false
    end

    local success, resultOrReason = captureSystem.evaluateZoneCapture(
        zoneKey,
        {
            autoCapture = true,
            reason = "f10_capture_ready_zone_" .. tostring(index) .. "_applied",
            force = false
        }
    )

    if success ~= true then
        outputToBlue(
            "Theater Command\n\nCapture Ready Zone "
                .. tostring(index)
                .. " konnte nicht angewendet werden: "
                .. tostring(resultOrReason)
        )

        logWarn(
            "Capture ready zone apply failed through F10: slot="
                .. tostring(index)
                .. " zone="
                .. tostring(zoneKey)
                .. " reason="
                .. tostring(resultOrReason)
        )

        return false
    end

    if type(resultOrReason) ~= "table" or resultOrReason.captured ~= true then
        outputToBlue(buildCaptureReadyApplyUnavailableText(index, "capture_ready_zone_not_captured"))

        logWarn(
            "Capture ready zone apply did not capture through F10: slot="
                .. tostring(index)
                .. " zone="
                .. tostring(zoneKey)
        )

        return false
    end

    local progressRecord = item.record or {}
    local zoneName = tostring(item.name or zoneKey)
    local newOwner = tostring(progressRecord.dominantOwner or "UNKNOWN")

    F10Menu.lastAppliedCaptureZoneKey = tostring(zoneKey)
    F10Menu.lastAppliedCaptureZoneName = zoneName
    F10Menu.lastAppliedCaptureOwner = newOwner
    F10Menu.lastAppliedCaptureStatus = "APPLIED"
    F10Menu.lastUpdateTime = getCurrentTime()

    local state = ensureUiState()

    if state ~= nil then
        state.UI.lastAppliedCaptureZoneKey = F10Menu.lastAppliedCaptureZoneKey
        state.UI.lastAppliedCaptureZoneName = F10Menu.lastAppliedCaptureZoneName
        state.UI.lastAppliedCaptureOwner = F10Menu.lastAppliedCaptureOwner
        state.UI.lastAppliedCaptureStatus = F10Menu.lastAppliedCaptureStatus
        state.UI.captureApply.lastAppliedAt = F10Menu.lastUpdateTime
        state.UI.captureApply.lastAppliedSlot = index
        state.UI.captureApply.lastAppliedZoneKey = F10Menu.lastAppliedCaptureZoneKey
        state.UI.captureApply.lastAppliedZoneName = F10Menu.lastAppliedCaptureZoneName
        state.UI.captureApply.lastAppliedOwner = F10Menu.lastAppliedCaptureOwner
        state.UI.lastUpdate = F10Menu.lastUpdateTime
    end

    markDirty("f10_capture_ready_zone_" .. tostring(index) .. "_applied")

    outputToBlue(buildCaptureReadyApplySuccessText(index, item, resultOrReason))

    logInfo(
        "Capture ready zone applied through F10: slot="
            .. tostring(index)
            .. " zone="
            .. tostring(zoneKey)
            .. " owner="
            .. tostring(newOwner)
            .. " stateOnly=true"
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

local function createMissionOutcomeCommands()
    local outcomeParent = F10Menu.menu.missionOutcome or F10Menu.menu.missions

    addCommand("Show Active Mission Outcome Status", outcomeParent, showActiveMissionOutcomeStatus)

    addCommand(
        "Complete Active Mission 1",
        outcomeParent,
        function()
            return completeActiveMissionByIndex(1)
        end
    )

    addCommand(
        "Fail Active Mission 1",
        outcomeParent,
        function()
            return failActiveMissionByIndex(1)
        end
    )
end

local function createCaptureCommands()
    local statusParent = F10Menu.menu.status or F10Menu.menu.root

    addCommand("Show Capture Status", statusParent, showCaptureStatus)
    addCommand("Show Capture Ready Zones", statusParent, showCaptureReadyZones)

    addCommand(
        "Apply Capture Ready Zone 1",
        statusParent,
        function()
            return applyCaptureReadyZoneByIndex(1)
        end
    )

    addCommand("Show Pressure Contested Zones", statusParent, showPressureContestedZones)
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
    F10Menu.menu.missionOutcome = addSubMenu("Mission Outcome", F10Menu.menu.missions or F10Menu.menu.root)
    F10Menu.menu.status = addSubMenu("Status", F10Menu.menu.root)
    F10Menu.menu.logistics = addSubMenu("Logistics", F10Menu.menu.root)
    F10Menu.menu.ai = addSubMenu("AI", F10Menu.menu.root)

    addCommand("Show Available Missions", F10Menu.menu.missions, showAvailableMissions)
    addCommand("Show Active Missions", F10Menu.menu.missions, showActiveMissions)

    createMissionSelectionCommands()
    createMissionOutcomeCommands()

    addCommand("Show Campaign Status", F10Menu.menu.status, showCampaignStatus)
    createCaptureCommands()

    addCommand("Show Logistics Status", F10Menu.menu.logistics, showLogisticsStatus)
    addCommand("Show FOB Status", F10Menu.menu.logistics, showFobStatus)
    addCommand("Show AI CAP Status", F10Menu.menu.ai, showAiStatus)

    F10Menu.menuRootCreated = true

    local state = ensureUiState()

    if state ~= nil then
        state.UI.menuRootCreated = true
        state.UI.commandCount = F10Menu.commandCount
        state.UI.directMissionSlots = F10Menu.maxMissionSelectionItems
        state.UI.activeMissionSlotsMax = F10Menu.maxActiveMissionSelectionItems
        state.UI.captureListSlots = F10Menu.maxCaptureListItems
        state.UI.captureApplySlots = F10Menu.maxCaptureApplyItems
        state.UI.menuItems = {
            root = "Theater Command",
            missions = "Missions",
            missionDetails = "Mission Details",
            missionActivation = "Activate Mission",
            missionOutcome = "Mission Outcome",
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

function F10Menu.showActiveMissionOutcomeStatus()
    return showActiveMissionOutcomeStatus()
end

function F10Menu.showCampaignStatus()
    return showCampaignStatus()
end

function F10Menu.showCaptureStatus()
    return showCaptureStatus()
end

function F10Menu.showCaptureReadyZones()
    return showCaptureReadyZones()
end

function F10Menu.showPressureContestedZones()
    return showPressureContestedZones()
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

function F10Menu.completeActiveMission(index)
    return completeActiveMissionByIndex(index or 1)
end

function F10Menu.failActiveMission(index)
    return failActiveMissionByIndex(index or 1)
end

function F10Menu.applyCaptureReadyZone(index)
    return applyCaptureReadyZoneByIndex(index or 1)
end

function F10Menu.applyCaptureReadyZone1()
    return applyCaptureReadyZoneByIndex(1)
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
        maxActiveMissionSelectionItems = F10Menu.maxActiveMissionSelectionItems,
        maxCaptureListItems = F10Menu.maxCaptureListItems,
        maxCaptureApplyItems = F10Menu.maxCaptureApplyItems,
        lastUpdateTime = F10Menu.lastUpdateTime,
        lastSelectedMissionKey = F10Menu.lastSelectedMissionKey,
        lastOutcomeMissionKey = F10Menu.lastOutcomeMissionKey,
        lastOutcomeAction = F10Menu.lastOutcomeAction,
        lastAppliedCaptureZoneKey = F10Menu.lastAppliedCaptureZoneKey,
        lastAppliedCaptureZoneName = F10Menu.lastAppliedCaptureZoneName,
        lastAppliedCaptureOwner = F10Menu.lastAppliedCaptureOwner,
        lastAppliedCaptureStatus = F10Menu.lastAppliedCaptureStatus,
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
