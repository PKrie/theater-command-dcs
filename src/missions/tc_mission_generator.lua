-- Theater Command DCS
-- File: src/missions/tc_mission_generator.lua
--
-- Purpose:
-- Generate and manage dynamic campaign missions from the current Theater
-- Command campaign state.
--
-- Current focus:
-- F10 Menu v0.2.0 can now activate Mission 1 to Mission 10 directly.
-- The Mission Generator therefore needs stronger mission records:
-- objectives, briefings, progress data, activation metadata and reserved
-- spawn hooks for later MOOSE, CTLD and Skynet integration.
--
-- Version:
-- 0.2.2
--
-- Responsibilities:
-- - build mission candidates from classified campaign zones
-- - build FOB support candidates from planned and under-construction FOBs
-- - reserve mission pool space for FOB support when FOBs require support
-- - prioritize missions by owner, zone class, FOB need and strategic relevance
-- - avoid medical pads, single helipads and unknown objects as strike targets
-- - prevent duplicate missions for the same target/type combination
-- - enrich missions with objectives, briefing, progress and activation state
-- - prepare future execution hooks without triggering real spawns
-- - keep mission state compatible with later persistence, AI and F10 UI systems
--
-- Vendor note:
-- This file does not directly call MIST, MOOSE, CTLD or Skynet IADS.
-- It consumes Theater Command state produced by World, Campaign, Logistics,
-- FOB and AI systems. Framework-specific execution will be added later in
-- dedicated systems.

TC = TC or {}
TC.modules = TC.modules or {}
TC.Missions = TC.Missions or {}
TC.missions = TC.missions or TC.Missions

local MissionGenerator = {}

MissionGenerator.name = "tc_mission_generator"
MissionGenerator.displayName = "Mission Generator"
MissionGenerator.path = "src/missions/tc_mission_generator.lua"
MissionGenerator.version = "0.2.2"

MissionGenerator.loaded = true
MissionGenerator.started = false
MissionGenerator.finished = false
MissionGenerator.failed = false

MissionGenerator.lastGenerationTime = 0
MissionGenerator.lastCandidateCount = 0
MissionGenerator.lastCreatedCount = 0
MissionGenerator.lastSkippedDuplicateCount = 0
MissionGenerator.lastSkippedLimitCount = 0
MissionGenerator.lastReservedCreatedCount = 0
MissionGenerator.lastFobCandidateCount = 0
MissionGenerator.lastActivationTime = 0
MissionGenerator.lastActivatedMissionKey = nil

MissionGenerator.defaultGenerationLimit = 10
MissionGenerator.minimumFobSupportMissions = 1

MissionGenerator.types = {
    RECON = "RECON",
    STRIKE = "STRIKE",
    SEAD = "SEAD",
    DEAD = "DEAD",
    CAS = "CAS",
    INTERDICTION = "INTERDICTION",
    ESCORT = "ESCORT",
    CAP = "CAP",
    LOGISTICS = "LOGISTICS",
    FOB_SUPPORT = "FOB_SUPPORT",
    AIRBASE_ATTACK = "AIRBASE_ATTACK",
    IADS_SUPPRESSION = "IADS_SUPPRESSION"
}

MissionGenerator.status = {
    AVAILABLE = "AVAILABLE",
    ACTIVE = "ACTIVE",
    COMPLETED = "COMPLETED",
    FAILED = "FAILED",
    EXPIRED = "EXPIRED",
    CANCELLED = "CANCELLED"
}

MissionGenerator.progressStage = {
    PLANNED = "PLANNED",
    SELECTED = "SELECTED",
    ACTIVE = "ACTIVE",
    IN_PROGRESS = "IN_PROGRESS",
    EFFECT_PENDING = "EFFECT_PENDING",
    COMPLETED = "COMPLETED",
    FAILED = "FAILED",
    EXPIRED = "EXPIRED",
    CANCELLED = "CANCELLED"
}

MissionGenerator.executionMode = {
    STATE_ONLY = "STATE_ONLY",
    RESERVED = "RESERVED",
    LIVE = "LIVE"
}

MissionGenerator.defaultPriorities = {
    RECON = 30,
    STRIKE = 60,
    SEAD = 75,
    DEAD = 80,
    CAS = 55,
    INTERDICTION = 50,
    ESCORT = 35,
    CAP = 45,
    LOGISTICS = 50,
    FOB_SUPPORT = 92,
    AIRBASE_ATTACK = 85,
    IADS_SUPPRESSION = 75
}

MissionGenerator.maxPerGenerationByType = {
    RECON = 1,
    STRIKE = 3,
    SEAD = 2,
    DEAD = 1,
    CAS = 2,
    INTERDICTION = 2,
    ESCORT = 1,
    CAP = 1,
    LOGISTICS = 2,
    FOB_SUPPORT = 2,
    AIRBASE_ATTACK = 4,
    IADS_SUPPRESSION = 1
}

MissionGenerator.zoneClasses = {
    STRATEGIC_AIRBASE_ZONE = "STRATEGIC_AIRBASE_ZONE",
    SECONDARY_AIRBASE_ZONE = "SECONDARY_AIRBASE_ZONE",
    HELIPORT_ZONE = "HELIPORT_ZONE",
    FARP_ZONE = "FARP_ZONE",
    TACTICAL_PAD_ZONE = "TACTICAL_PAD_ZONE",
    MISSION_EDITOR_CAPTURE_ZONE = "MISSION_EDITOR_CAPTURE_ZONE",
    MISSION_EDITOR_ZONE = "MISSION_EDITOR_ZONE",
    UNKNOWN_ZONE = "UNKNOWN_ZONE"
}

MissionGenerator.airbaseClassifications = {
    STRATEGIC_AIRFIELD = "STRATEGIC_AIRFIELD",
    SECONDARY_AIRFIELD = "SECONDARY_AIRFIELD",
    HELIPORT = "HELIPORT",
    HELIPAD = "HELIPAD",
    MEDICAL_PAD = "MEDICAL_PAD",
    FARP = "FARP",
    TACTICAL_PAD = "TACTICAL_PAD",
    UNKNOWN = "UNKNOWN"
}

MissionGenerator.fobStatus = {
    PLANNED = "PLANNED",
    UNDER_CONSTRUCTION = "UNDER_CONSTRUCTION",
    ACTIVE = "ACTIVE",
    DAMAGED = "DAMAGED",
    OUT_OF_SUPPLY = "OUT_OF_SUPPLY",
    DESTROYED = "DESTROYED"
}

local function getConfig()
    return TC.config or TC.Config or {}
end

local function getLogger()
    return TC.Logger or TC.logger
end

local function getState()
    return TC.State or TC.state
end

local function getUtils()
    return TC.Utils or TC.utils
end

local function rawLog(level, message)
    local formatted = "[TC][MISSION_GENERATOR] " .. tostring(message)

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
        logger.info("[MissionGenerator] " .. tostring(message))
        return
    end

    rawLog("INFO", message)
end

local function logWarn(message)
    local logger = getLogger()

    if logger ~= nil and logger.warn ~= nil then
        logger.warn("[MissionGenerator] " .. tostring(message))
        return
    end

    rawLog("WARN", message)
end

local function logError(message)
    local logger = getLogger()

    if logger ~= nil and logger.error ~= nil then
        logger.error("[MissionGenerator] " .. tostring(message))
        return
    end

    rawLog("ERROR", message)
end

local function logDebug(message)
    local logger = getLogger()

    if logger ~= nil and logger.debug ~= nil then
        logger.debug("[MissionGenerator] " .. tostring(message))
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

local function copyValue(value, visited)
    if type(value) ~= "table" then
        return value
    end

    visited = visited or {}

    if visited[value] ~= nil then
        return nil
    end

    visited[value] = true

    local result = {}

    for key, childValue in pairs(value) do
        if type(childValue) ~= "function"
            and type(childValue) ~= "userdata"
            and type(childValue) ~= "thread" then
            result[copyValue(key, visited)] = copyValue(childValue, visited)
        end
    end

    visited[value] = nil

    return result
end

local function clamp(value, minimum, maximum)
    local numeric = tonumber(value)

    if numeric == nil then
        numeric = minimum or 0
    end

    if type(minimum) == "number" and numeric < minimum then
        return minimum
    end

    if type(maximum) == "number" and numeric > maximum then
        return maximum
    end

    return numeric
end

local function getConstant(categoryName, keyName, fallback)
    local config = getConfig()

    if config.constants == nil then
        return fallback
    end

    if config.constants[categoryName] == nil then
        return fallback
    end

    if config.constants[categoryName][keyName] == nil then
        return fallback
    end

    return config.constants[categoryName][keyName]
end

local function getOwnerBlue()
    return getConstant("ownership", "BLUE", "BLUE")
end

local function getOwnerRed()
    return getConstant("ownership", "RED", "RED")
end

local function getOwnerNeutral()
    return getConstant("ownership", "NEUTRAL", "NEUTRAL")
end

local function getOwnerContested()
    return getConstant("ownership", "CONTESTED", "CONTESTED")
end

local function getOwnerUnknown()
    return getConstant("ownership", "UNKNOWN", "UNKNOWN")
end

local function getStatusAvailable()
    return getConstant("missionStatus", "AVAILABLE", MissionGenerator.status.AVAILABLE)
end

local function getStatusActive()
    return getConstant("missionStatus", "ACTIVE", MissionGenerator.status.ACTIVE)
end

local function getStatusCompleted()
    return getConstant("missionStatus", "COMPLETED", MissionGenerator.status.COMPLETED)
end

local function getStatusFailed()
    return getConstant("missionStatus", "FAILED", MissionGenerator.status.FAILED)
end

local function getStatusExpired()
    return getConstant("missionStatus", "EXPIRED", MissionGenerator.status.EXPIRED)
end

local function getStatusCancelled()
    return getConstant("missionStatus", "CANCELLED", MissionGenerator.status.CANCELLED)
end

local function getRecordOwner(record)
    if type(record) ~= "table" then
        return getOwnerUnknown()
    end

    return record.currentOwner or record.initialOwner or record.owner or getOwnerUnknown()
end

local function isValidMissionType(missionType)
    if missionType == nil then
        return false
    end

    for _, allowedType in pairs(MissionGenerator.types) do
        if missionType == allowedType then
            return true
        end
    end

    return false
end

local function isValidStatus(status)
    if status == nil then
        return false
    end

    if status == getStatusAvailable()
        or status == getStatusActive()
        or status == getStatusCompleted()
        or status == getStatusFailed()
        or status == getStatusExpired()
        or status == getStatusCancelled() then
        return true
    end

    for _, allowedStatus in pairs(MissionGenerator.status) do
        if status == allowedStatus then
            return true
        end
    end

    return false
end

local function ensureMissionState()
    local state = getState()

    TC.Missions = TC.Missions or {}
    TC.missions = TC.Missions

    if state == nil then
        return nil
    end

    state.Missions = state.Missions or {}
    state.Missions.enabled = true
    state.Missions.available = state.Missions.available or {}
    state.Missions.active = state.Missions.active or {}
    state.Missions.completed = state.Missions.completed or {}
    state.Missions.failed = state.Missions.failed or {}
    state.Missions.expired = state.Missions.expired or {}
    state.Missions.cancelled = state.Missions.cancelled or {}
    state.Missions.lastMissionId = state.Missions.lastMissionId or 0
    state.Missions.lastGenerationTime = state.Missions.lastGenerationTime or 0
    state.Missions.lastActivationTime = state.Missions.lastActivationTime or 0
    state.Missions.lastActivatedMissionKey = state.Missions.lastActivatedMissionKey
    state.Missions.generationHistory = state.Missions.generationHistory or {}
    state.Missions.activationHistory = state.Missions.activationHistory or {}
    state.Missions.statistics = state.Missions.statistics or {
        total = 0,
        available = 0,
        active = 0,
        completed = 0,
        failed = 0,
        expired = 0,
        cancelled = 0,
        lastCreated = 0,
        lastCandidates = 0,
        lastFobCandidates = 0,
        lastReservedCreated = 0,
        lastDuplicatesSkipped = 0,
        lastLimitSkipped = 0,
        lastActivatedMissionKey = nil,
        lastActivationTime = 0
    }

    return state
end

local function markDirty(reason)
    local state = getState()

    if state ~= nil and state.markDirty ~= nil then
        state.markDirty(reason or "mission_state_changed")
        return true
    end

    if state ~= nil then
        state.Persistence = state.Persistence or {}
        state.Persistence.dirty = true
        state.Persistence.dirtyReason = reason or "mission_state_changed"
        state.Persistence.dirtyAt = getCurrentTime()
        return true
    end

    return false
end

local function setModuleStatus(status)
    local state = getState()

    if state ~= nil and state.setModuleStatus ~= nil then
        state.setModuleStatus("missionGenerator", status)
    end
end

local function setFeatureStatus(enabled)
    local state = getState()

    if state ~= nil and state.setFeatureStatus ~= nil then
        state.setFeatureStatus("missionGenerator", enabled == true)
    end
end

local function getBaseRegistry()
    local state = getState()

    if state ~= nil and state.Bases ~= nil and state.Bases.registry ~= nil then
        return state.Bases.registry
    end

    if TC.World ~= nil and TC.World.Airbases ~= nil then
        return TC.World.Airbases
    end

    return {}
end

local function getZoneRegistry()
    local state = getState()

    if state ~= nil and state.Zones ~= nil and state.Zones.registry ~= nil then
        return state.Zones.registry
    end

    if TC.World ~= nil and TC.World.Zones ~= nil then
        return TC.World.Zones
    end

    return {}
end

local function getFobRegistry()
    local state = getState()

    if state ~= nil and state.Logistics ~= nil and state.Logistics.fobs ~= nil then
        return state.Logistics.fobs
    end

    if TC.Logistics ~= nil and TC.Logistics.Fobs ~= nil then
        return TC.Logistics.Fobs
    end

    return {}
end

local function getDeliverySystem()
    if TC.Logistics == nil then
        return nil
    end

    return TC.Logistics.Delivery
end

local function findRecordByKeyOrName(registry, keyOrName)
    if type(registry) ~= "table" or keyOrName == nil then
        return nil
    end

    if registry[keyOrName] ~= nil then
        return registry[keyOrName]
    end

    local normalizedSearch = normalizeName(keyOrName)

    for _, record in pairs(registry) do
        if type(record) == "table" then
            if record.key == keyOrName then
                return record
            end

            if record.normalizedName == normalizedSearch then
                return record
            end

            if normalizeName(record.name) == normalizedSearch then
                return record
            end

            if normalizeName(record.displayName) == normalizedSearch then
                return record
            end
        end
    end

    return nil
end

local function findBaseByKeyOrName(keyOrName)
    return findRecordByKeyOrName(getBaseRegistry(), keyOrName)
end

local function findZoneByKeyOrName(keyOrName)
    return findRecordByKeyOrName(getZoneRegistry(), keyOrName)
end

local function getBlueStartBase()
    local config = getConfig()
    local campaignConfig = config.campaign or {}
    local configuredStartBase = campaignConfig.blueStartBase or "AKROTIRI"
    local startBase = findBaseByKeyOrName(configuredStartBase)

    if startBase ~= nil then
        return startBase
    end

    for _, baseRecord in pairs(getBaseRegistry()) do
        if baseRecord.isStartBase == true then
            return baseRecord
        end
    end

    for _, baseRecord in pairs(getBaseRegistry()) do
        if getRecordOwner(baseRecord) == getOwnerBlue() then
            return baseRecord
        end
    end

    return nil
end

local function getBlueStartZone()
    for _, zoneRecord in pairs(getZoneRegistry()) do
        if zoneRecord.isStartBaseZone == true then
            return zoneRecord
        end
    end

    for _, zoneRecord in pairs(getZoneRegistry()) do
        if getRecordOwner(zoneRecord) == getOwnerBlue() then
            return zoneRecord
        end
    end

    return nil
end

local function getMissionContainerForStatus(state, status)
    if status == getStatusAvailable() or status == MissionGenerator.status.AVAILABLE then
        return state.Missions.available
    end

    if status == getStatusActive() or status == MissionGenerator.status.ACTIVE then
        return state.Missions.active
    end

    if status == getStatusCompleted() or status == MissionGenerator.status.COMPLETED then
        return state.Missions.completed
    end

    if status == getStatusFailed() or status == MissionGenerator.status.FAILED then
        return state.Missions.failed
    end

    if status == getStatusExpired() or status == MissionGenerator.status.EXPIRED then
        return state.Missions.expired
    end

    if status == getStatusCancelled() or status == MissionGenerator.status.CANCELLED then
        return state.Missions.cancelled
    end

    return state.Missions.available
end

local function removeMissionFromAllContainers(state, missionKey)
    if state == nil or state.Missions == nil or missionKey == nil then
        return false
    end

    state.Missions.available[missionKey] = nil
    state.Missions.active[missionKey] = nil
    state.Missions.completed[missionKey] = nil
    state.Missions.failed[missionKey] = nil
    state.Missions.expired[missionKey] = nil
    state.Missions.cancelled[missionKey] = nil

    return true
end

local function updateStatistics()
    local state = ensureMissionState()

    if state == nil then
        return false
    end

    state.Missions.statistics.total =
        countTableKeys(state.Missions.available)
        + countTableKeys(state.Missions.active)
        + countTableKeys(state.Missions.completed)
        + countTableKeys(state.Missions.failed)
        + countTableKeys(state.Missions.expired)
        + countTableKeys(state.Missions.cancelled)

    state.Missions.statistics.available = countTableKeys(state.Missions.available)
    state.Missions.statistics.active = countTableKeys(state.Missions.active)
    state.Missions.statistics.completed = countTableKeys(state.Missions.completed)
    state.Missions.statistics.failed = countTableKeys(state.Missions.failed)
    state.Missions.statistics.expired = countTableKeys(state.Missions.expired)
    state.Missions.statistics.cancelled = countTableKeys(state.Missions.cancelled)
    state.Missions.statistics.lastActivatedMissionKey = state.Missions.lastActivatedMissionKey
    state.Missions.statistics.lastActivationTime = state.Missions.lastActivationTime or 0

    return true
end

local function createMissionId()
    local state = ensureMissionState()

    if state == nil then
        return nil
    end

    state.Missions.lastMissionId = (state.Missions.lastMissionId or 0) + 1

    return state.Missions.lastMissionId
end

local function buildMissionKey(missionId)
    return "MISSION_" .. tostring(missionId)
end

local function buildMissionSignature(missionType, targetZoneKey, targetBaseKey, targetFobKey)
    return table.concat({
        missionType or "UNKNOWN",
        targetZoneKey or "NO_ZONE",
        targetBaseKey or "NO_BASE",
        targetFobKey or "NO_FOB"
    }, "::")
end

local function missionSignatureExists(signature)
    if signature == nil then
        return false
    end

    local state = ensureMissionState()

    if state == nil then
        return false
    end

    for _, missionRecord in pairs(state.Missions.available) do
        if missionRecord.signature == signature then
            return true
        end
    end

    for _, missionRecord in pairs(state.Missions.active) do
        if missionRecord.signature == signature then
            return true
        end
    end

    return false
end

local function getPriority(missionType, overridePriority)
    if type(overridePriority) == "number" then
        return overridePriority
    end

    return MissionGenerator.defaultPriorities[missionType] or 10
end

local function getZoneDisplayName(zoneRecord)
    if zoneRecord == nil then
        return "UNKNOWN_ZONE"
    end

    return zoneRecord.linkedAirbaseName
        or zoneRecord.displayName
        or zoneRecord.name
        or zoneRecord.key
        or "UNKNOWN_ZONE"
end

local function getFobDisplayName(fobRecord)
    if fobRecord == nil then
        return "UNKNOWN_FOB"
    end

    return fobRecord.displayName or fobRecord.name or fobRecord.key or "UNKNOWN_FOB"
end

local function getMissionTargetName(targetZone, targetBase, targetFob)
    if targetFob ~= nil then
        return getFobDisplayName(targetFob)
    end

    if targetBase ~= nil and targetBase.name ~= nil then
        return targetBase.name
    end

    if targetZone ~= nil then
        return getZoneDisplayName(targetZone)
    end

    return "UNKNOWN_TARGET"
end

local function getMissionName(missionType, targetZone, targetBase, targetFob)
    return tostring(missionType) .. " - " .. tostring(getMissionTargetName(targetZone, targetBase, targetFob))
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

local function sortMissionList(missionList)
    table.sort(missionList, function(left, right)
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

    return missionList
end

local function tableToSortedList(container)
    local result = {}

    if type(container) ~= "table" then
        return result
    end

    for _, missionRecord in pairs(container) do
        if type(missionRecord) == "table" then
            table.insert(result, missionRecord)
        end
    end

    return sortMissionList(result)
end

local function buildObjectiveText(missionType, targetName)
    if missionType == MissionGenerator.types.AIRBASE_ATTACK then
        return "Attack enemy airbase infrastructure at " .. tostring(targetName) .. "."
    end

    if missionType == MissionGenerator.types.SEAD then
        return "Suppress air defenses around " .. tostring(targetName) .. "."
    end

    if missionType == MissionGenerator.types.DEAD then
        return "Destroy identified air defense assets near " .. tostring(targetName) .. "."
    end

    if missionType == MissionGenerator.types.STRIKE then
        return "Strike enemy military infrastructure at " .. tostring(targetName) .. "."
    end

    if missionType == MissionGenerator.types.RECON then
        return "Recon enemy activity and defensive posture near " .. tostring(targetName) .. "."
    end

    if missionType == MissionGenerator.types.INTERDICTION then
        return "Interdict enemy movement and logistics near " .. tostring(targetName) .. "."
    end

    if missionType == MissionGenerator.types.CAS then
        return "Support friendly forces around " .. tostring(targetName) .. "."
    end

    if missionType == MissionGenerator.types.CAP then
        return "Protect friendly airspace over " .. tostring(targetName) .. "."
    end

    if missionType == MissionGenerator.types.LOGISTICS then
        return "Move supplies and equipment to " .. tostring(targetName) .. "."
    end

    if missionType == MissionGenerator.types.FOB_SUPPORT then
        return "Support FOB construction or sustainment at " .. tostring(targetName) .. "."
    end

    if missionType == MissionGenerator.types.IADS_SUPPRESSION then
        return "Suppress integrated air defense activity near " .. tostring(targetName) .. "."
    end

    return "Execute assigned mission at " .. tostring(targetName) .. "."
end

local function buildSuccessCriteria(missionType)
    if missionType == MissionGenerator.types.FOB_SUPPORT then
        return {
            "FOB support package delivered or marked complete.",
            "FOB supply, engineering or construction state can be updated.",
            "Mission can be closed without live CTLD execution."
        }
    end

    if missionType == MissionGenerator.types.LOGISTICS then
        return {
            "Logistics support reaches the intended campaign zone.",
            "Target zone logistics state can be updated.",
            "Mission can be closed as a state-only logistics effect."
        }
    end

    if missionType == MissionGenerator.types.CAP then
        return {
            "Friendly airspace is protected for the mission window.",
            "No real AI spawn is required in this version.",
            "Mission can be completed through future AI or player result handling."
        }
    end

    if missionType == MissionGenerator.types.SEAD or missionType == MissionGenerator.types.IADS_SUPPRESSION then
        return {
            "Air defense pressure is reduced in the target area.",
            "Follow-on strike missions are easier to justify.",
            "No Skynet IADS state is modified directly yet."
        }
    end

    return {
        "Mission objective is achieved by player or future AI result handling.",
        "Campaign state can receive the configured mission effect.",
        "No real MOOSE spawn is required in this version."
    }
end

local function buildFailureCriteria(missionType)
    if missionType == MissionGenerator.types.FOB_SUPPORT or missionType == MissionGenerator.types.LOGISTICS then
        return {
            "Support package does not reach the intended target.",
            "The mission is manually failed, expired or cancelled."
        }
    end

    return {
        "Mission is manually failed, expired or cancelled.",
        "Future result handling determines that the objective was not achieved."
    }
end

local function buildInitialProgress()
    return {
        stage = MissionGenerator.progressStage.PLANNED,
        current = 0,
        target = 100,
        percent = 0,
        lastStep = "mission_created",
        updatedAt = getCurrentTime()
    }
end

local function buildExecutionPlan(missionType)
    local plan = {
        mode = MissionGenerator.executionMode.STATE_ONLY,
        stateOnly = true,
        spawnAllowed = false,
        spawnTriggered = false,
        spawnHookStatus = "RESERVED",
        resultHandling = "MANUAL_OR_FUTURE_SYSTEM",
        updatedAt = getCurrentTime(),
        notes = "State-only mission. No MOOSE, CTLD or Skynet action is executed by MissionGenerator v0.2.2.",
        moose = {
            reserved = true,
            enabled = false,
            templateName = nil,
            spawnName = nil
        },
        ctld = {
            reserved = true,
            enabled = false,
            deliveryKey = nil,
            crateType = nil
        },
        skynet = {
            reserved = true,
            enabled = false,
            siteKey = nil,
            networkKey = nil
        }
    }

    if missionType == MissionGenerator.types.FOB_SUPPORT or missionType == MissionGenerator.types.LOGISTICS then
        plan.ctld.intent = "future_logistics_execution"
    elseif missionType == MissionGenerator.types.SEAD
        or missionType == MissionGenerator.types.DEAD
        or missionType == MissionGenerator.types.IADS_SUPPRESSION then
        plan.skynet.intent = "future_iads_pressure_or_site_result"
        plan.moose.intent = "future_strike_package_spawn"
    elseif missionType == MissionGenerator.types.CAP then
        plan.moose.intent = "future_cap_package_spawn"
    else
        plan.moose.intent = "future_mission_package_spawn"
    end

    return plan
end

local function buildObjectives(missionType, targetName, missionOptions)
    return {
        primary = missionOptions.objective or buildObjectiveText(missionType, targetName),
        secondary = copyValue(missionOptions.secondaryObjectives or {}),
        successCriteria = copyValue(missionOptions.successCriteria or buildSuccessCriteria(missionType)),
        failureCriteria = copyValue(missionOptions.failureCriteria or buildFailureCriteria(missionType)),
        stateOnly = true,
        updatedAt = getCurrentTime()
    }
end

local function buildBriefingFromRecord(missionRecord)
    if type(missionRecord) ~= "table" then
        return "Mission briefing unavailable."
    end

    local lines = {
        "Mission: " .. tostring(missionRecord.name or missionRecord.key or "UNKNOWN"),
        "Type: " .. tostring(missionRecord.type or "UNKNOWN"),
        "Target: " .. tostring(getMissionTargetText(missionRecord)),
        "Priority: " .. tostring(missionRecord.priority or 0),
        "Status: " .. tostring(missionRecord.status or "UNKNOWN"),
        "",
        "Objective:",
        tostring(missionRecord.objective or "No objective defined."),
        "",
        "Execution:",
        "State-only mission. No real MOOSE, CTLD or Skynet spawn is executed by this generator."
    }

    if type(missionRecord.recommendedAircraft) == "table" and #missionRecord.recommendedAircraft > 0 then
        table.insert(lines, "")
        table.insert(lines, "Recommended aircraft:")

        for _, aircraftName in ipairs(missionRecord.recommendedAircraft) do
            table.insert(lines, "- " .. tostring(aircraftName))
        end
    end

    if type(missionRecord.recommendedPayload) == "table" and #missionRecord.recommendedPayload > 0 then
        table.insert(lines, "")
        table.insert(lines, "Recommended payload:")

        for _, payloadName in ipairs(missionRecord.recommendedPayload) do
            table.insert(lines, "- " .. tostring(payloadName))
        end
    end

    return table.concat(lines, "\n")
end

local function refreshMissionBriefing(missionRecord)
    if type(missionRecord) ~= "table" then
        return nil
    end

    missionRecord.briefing = buildBriefingFromRecord(missionRecord)
    missionRecord.updatedAt = getCurrentTime()

    return missionRecord.briefing
end

local function buildMissionRecord(missionType, options)
    local missionOptions = options or {}

    if isValidMissionType(missionType) ~= true then
        return nil, "invalid_mission_type"
    end

    local missionId = createMissionId()

    if missionId == nil then
        return nil, "mission_id_failed"
    end

    local targetZone = missionOptions.targetZoneRecord
    local targetBase = missionOptions.targetBaseRecord
    local targetFob = missionOptions.targetFobRecord

    if targetZone == nil and missionOptions.targetZone ~= nil then
        targetZone = findZoneByKeyOrName(missionOptions.targetZone)
    end

    if targetBase == nil and missionOptions.targetBase ~= nil then
        targetBase = findBaseByKeyOrName(missionOptions.targetBase)
    end

    if targetZone ~= nil and targetBase == nil and targetZone.linkedAirbaseKey ~= nil then
        targetBase = findBaseByKeyOrName(targetZone.linkedAirbaseKey)
    end

    local sourceBase = nil

    if missionOptions.sourceBase ~= nil then
        sourceBase = findBaseByKeyOrName(missionOptions.sourceBase)
    end

    if sourceBase == nil then
        sourceBase = getBlueStartBase()
    end

    local missionKey = buildMissionKey(missionId)
    local targetZoneKey = targetZone and targetZone.key or missionOptions.targetZone
    local targetBaseKey = targetBase and targetBase.key or missionOptions.targetBase
    local targetFobKey = targetFob and targetFob.key or missionOptions.targetFob
    local signature = buildMissionSignature(missionType, targetZoneKey, targetBaseKey, targetFobKey)
    local targetName = getMissionTargetName(targetZone, targetBase, targetFob)
    local missionName = missionOptions.name or getMissionName(missionType, targetZone, targetBase, targetFob)
    local objectives = buildObjectives(missionType, targetName, missionOptions)

    local missionRecord = {
        id = missionId,
        key = missionKey,
        name = missionName,
        normalizedName = normalizeName(missionName),

        type = missionType,
        status = missionOptions.status or getStatusAvailable(),
        owner = missionOptions.owner or getOwnerBlue(),

        sourceBaseKey = sourceBase and sourceBase.key or missionOptions.sourceBase,
        sourceBaseName = sourceBase and sourceBase.name or nil,

        targetZoneKey = targetZoneKey,
        targetZoneName = targetZone and targetZone.name or nil,
        targetZoneClass = targetZone and targetZone.zoneClass or nil,
        targetZoneOwner = targetZone and getRecordOwner(targetZone) or nil,
        targetTheatreArea = targetZone and targetZone.theatreArea or nil,

        targetBaseKey = targetBaseKey,
        targetBaseName = targetBase and targetBase.name or nil,
        targetAirbaseClassification = targetZone and targetZone.airbaseClassification or targetBase and targetBase.classification or nil,

        targetFobKey = targetFobKey,
        targetFobName = targetFob and getFobDisplayName(targetFob) or nil,
        targetFobStatus = targetFob and targetFob.status or nil,
        targetFobLinkedHubKey = targetFob and targetFob.linkedHubKey or nil,

        targetIadsSiteKey = missionOptions.targetIadsSite,

        priority = getPriority(missionType, missionOptions.priority),
        strategicRelevance = missionOptions.strategicRelevance
            or targetZone and targetZone.strategicRelevance
            or targetBase and targetBase.strategicRelevance
            or 0,

        signature = signature,

        description = missionOptions.description,
        objective = objectives.primary,
        objectives = objectives,
        briefing = nil,

        recommendedAircraft = copyValue(missionOptions.recommendedAircraft or {}),
        recommendedPayload = copyValue(missionOptions.recommendedPayload or {}),
        packageRole = missionOptions.packageRole,

        generationReason = missionOptions.generationReason,
        effect = copyValue(missionOptions.effect or {}),
        effectApplied = false,

        progress = copyValue(missionOptions.progress or buildInitialProgress()),
        activation = nil,
        execution = copyValue(missionOptions.execution or buildExecutionPlan(missionType)),

        currentTask = nil,
        selectedBy = nil,
        activatedBy = nil,

        createdAt = getCurrentTime(),
        activatedAt = nil,
        completedAt = nil,
        failedAt = nil,
        expiredAt = nil,
        cancelledAt = nil,
        updatedAt = getCurrentTime(),

        source = missionOptions.source or "MISSION_GENERATOR",
        reservedSlot = missionOptions.reservedSlot == true,
        notes = missionOptions.notes
    }

    refreshMissionBriefing(missionRecord)

    return missionRecord
end

local function addMissionToContainer(missionRecord)
    local state = ensureMissionState()

    if state == nil then
        return false, "state_unavailable"
    end

    if missionRecord == nil or missionRecord.key == nil then
        return false, "mission_record_invalid"
    end

    removeMissionFromAllContainers(state, missionRecord.key)

    local container = getMissionContainerForStatus(state, missionRecord.status)
    container[missionRecord.key] = missionRecord

    updateStatistics()
    markDirty("mission_record_changed")

    return true, missionRecord
end

local function getMissionFromContainer(container, missionKeyOrName)
    if type(container) ~= "table" or missionKeyOrName == nil then
        return nil
    end

    if container[missionKeyOrName] ~= nil then
        return container[missionKeyOrName]
    end

    local normalizedSearch = normalizeName(missionKeyOrName)

    for _, missionRecord in pairs(container) do
        if missionRecord.normalizedName == normalizedSearch then
            return missionRecord
        end

        if normalizeName(missionRecord.name) == normalizedSearch then
            return missionRecord
        end
    end

    return nil
end

local function createMissionIfMissing(missionType, options)
    local previewOptions = options or {}
    local targetZoneKey = previewOptions.targetZone
    local targetBaseKey = previewOptions.targetBase
    local targetFobKey = previewOptions.targetFob

    if targetZoneKey == nil and type(previewOptions.targetZoneRecord) == "table" then
        targetZoneKey = previewOptions.targetZoneRecord.key
    end

    if targetBaseKey == nil and type(previewOptions.targetBaseRecord) == "table" then
        targetBaseKey = previewOptions.targetBaseRecord.key
    end

    if targetFobKey == nil and type(previewOptions.targetFobRecord) == "table" then
        targetFobKey = previewOptions.targetFobRecord.key
    end

    local signature = buildMissionSignature(missionType, targetZoneKey, targetBaseKey, targetFobKey)

    if missionSignatureExists(signature) == true then
        return false, "mission_already_exists"
    end

    return MissionGenerator.createMission(missionType, options)
end

local function isRedZone(zoneRecord)
    return getRecordOwner(zoneRecord) == getOwnerRed()
end

local function isBlueZone(zoneRecord)
    return getRecordOwner(zoneRecord) == getOwnerBlue()
end

local function isContestedZone(zoneRecord)
    return getRecordOwner(zoneRecord) == getOwnerContested()
end

local function isStrategicAirbaseZone(zoneRecord)
    if zoneRecord == nil then
        return false
    end

    return zoneRecord.isStrategicAirbaseZone == true
        or zoneRecord.zoneClass == MissionGenerator.zoneClasses.STRATEGIC_AIRBASE_ZONE
        or zoneRecord.airbaseClassification == MissionGenerator.airbaseClassifications.STRATEGIC_AIRFIELD
end

local function isSecondaryAirbaseZone(zoneRecord)
    if zoneRecord == nil then
        return false
    end

    return zoneRecord.isSecondaryAirbaseZone == true
        or zoneRecord.zoneClass == MissionGenerator.zoneClasses.SECONDARY_AIRBASE_ZONE
        or zoneRecord.airbaseClassification == MissionGenerator.airbaseClassifications.SECONDARY_AIRFIELD
end

local function isHeliportZone(zoneRecord)
    if zoneRecord == nil then
        return false
    end

    return zoneRecord.isHeliportZone == true
        or zoneRecord.zoneClass == MissionGenerator.zoneClasses.HELIPORT_ZONE
        or zoneRecord.airbaseClassification == MissionGenerator.airbaseClassifications.HELIPORT
end

local function isFarpZone(zoneRecord)
    if zoneRecord == nil then
        return false
    end

    return zoneRecord.isFarpZone == true
        or zoneRecord.zoneClass == MissionGenerator.zoneClasses.FARP_ZONE
        or zoneRecord.airbaseClassification == MissionGenerator.airbaseClassifications.FARP
end

local function isTacticalPadZone(zoneRecord)
    if zoneRecord == nil then
        return false
    end

    return zoneRecord.isTacticalPadZone == true
        or zoneRecord.zoneClass == MissionGenerator.zoneClasses.TACTICAL_PAD_ZONE
        or zoneRecord.airbaseClassification == MissionGenerator.airbaseClassifications.TACTICAL_PAD
end

local function isValidMissionTargetZone(zoneRecord)
    if type(zoneRecord) ~= "table" then
        return false
    end

    if zoneRecord.airbaseClassification == MissionGenerator.airbaseClassifications.MEDICAL_PAD then
        return false
    end

    if zoneRecord.airbaseClassification == MissionGenerator.airbaseClassifications.HELIPAD then
        return false
    end

    if zoneRecord.airbaseClassification == MissionGenerator.airbaseClassifications.UNKNOWN then
        return false
    end

    if zoneRecord.zoneClass == MissionGenerator.zoneClasses.UNKNOWN_ZONE then
        return false
    end

    if zoneRecord.isMissionZone == true or zoneRecord.isCaptureZone == true or zoneRecord.isLogisticsZone == true then
        return true
    end

    return false
end

local function getZoneStrategicRelevance(zoneRecord)
    if zoneRecord == nil then
        return 0
    end

    if type(zoneRecord.strategicRelevance) == "number" then
        return zoneRecord.strategicRelevance
    end

    if isStrategicAirbaseZone(zoneRecord) == true then
        return 90
    end

    if isSecondaryAirbaseZone(zoneRecord) == true then
        return 60
    end

    if isHeliportZone(zoneRecord) == true then
        return 45
    end

    if isFarpZone(zoneRecord) == true then
        return 40
    end

    if isTacticalPadZone(zoneRecord) == true then
        return 25
    end

    return 0
end

local function getPriorityBonusFromZone(zoneRecord)
    return math.floor(getZoneStrategicRelevance(zoneRecord) / 10)
end

local function getLinkedBaseForZone(zoneRecord)
    if zoneRecord == nil then
        return nil
    end

    if zoneRecord.linkedAirbaseKey ~= nil then
        return findBaseByKeyOrName(zoneRecord.linkedAirbaseKey)
    end

    if zoneRecord.linkedAirbaseName ~= nil then
        return findBaseByKeyOrName(zoneRecord.linkedAirbaseName)
    end

    return nil
end

local function getLinkedZoneForFob(fobRecord)
    if type(fobRecord) ~= "table" then
        return nil
    end

    if fobRecord.linkedZoneKey ~= nil then
        return findZoneByKeyOrName(fobRecord.linkedZoneKey)
    end

    if fobRecord.linkedZoneName ~= nil then
        return findZoneByKeyOrName(fobRecord.linkedZoneName)
    end

    return nil
end

local function shouldSupportFob(fobRecord)
    if type(fobRecord) ~= "table" then
        return false
    end

    if fobRecord.status == MissionGenerator.fobStatus.DESTROYED then
        return false
    end

    if fobRecord.status == MissionGenerator.fobStatus.PLANNED then
        return true
    end

    if fobRecord.status == MissionGenerator.fobStatus.UNDER_CONSTRUCTION then
        return true
    end

    if fobRecord.status == MissionGenerator.fobStatus.OUT_OF_SUPPLY then
        return true
    end

    if fobRecord.status == MissionGenerator.fobStatus.DAMAGED then
        return true
    end

    if (fobRecord.supplyLevel or 0) < 50 then
        return true
    end

    if (fobRecord.constructionProgress or 0) < 100 then
        return true
    end

    return false
end

local function getFobSupportPriority(fobRecord)
    local priority = MissionGenerator.defaultPriorities.FOB_SUPPORT

    if fobRecord.status == MissionGenerator.fobStatus.UNDER_CONSTRUCTION then
        priority = priority + 8
    elseif fobRecord.status == MissionGenerator.fobStatus.PLANNED then
        priority = priority + 6
    elseif fobRecord.status == MissionGenerator.fobStatus.OUT_OF_SUPPLY then
        priority = priority + 10
    elseif fobRecord.status == MissionGenerator.fobStatus.DAMAGED then
        priority = priority + 7
    end

    if (fobRecord.constructionProgress or 0) < 50 then
        priority = priority + 4
    end

    if (fobRecord.supplyLevel or 0) < 25 then
        priority = priority + 4
    end

    return priority
end

local function createCandidate(missionType, zoneRecord, options)
    if missionType == nil then
        return nil
    end

    local candidateOptions = options or {}
    local linkedBase = candidateOptions.targetBaseRecord

    if linkedBase == nil and zoneRecord ~= nil then
        linkedBase = getLinkedBaseForZone(zoneRecord)
    end

    local targetFob = candidateOptions.targetFobRecord
    local targetZoneKey = zoneRecord and zoneRecord.key or candidateOptions.targetZone
    local targetBaseKey = linkedBase and linkedBase.key or candidateOptions.targetBase
    local targetFobKey = targetFob and targetFob.key or candidateOptions.targetFob
    local priority = getPriority(missionType, candidateOptions.priority)
    local signature = buildMissionSignature(missionType, targetZoneKey, targetBaseKey, targetFobKey)

    return {
        missionType = missionType,
        targetZoneRecord = zoneRecord,
        targetBaseRecord = linkedBase,
        targetFobRecord = targetFob,
        targetZone = targetZoneKey,
        targetBase = targetBaseKey,
        targetFob = targetFobKey,
        priority = priority,
        strategicRelevance = candidateOptions.strategicRelevance
            or zoneRecord and getZoneStrategicRelevance(zoneRecord)
            or 0,
        signature = signature,
        objective = candidateOptions.objective,
        secondaryObjectives = candidateOptions.secondaryObjectives,
        successCriteria = candidateOptions.successCriteria,
        failureCriteria = candidateOptions.failureCriteria,
        description = candidateOptions.description,
        recommendedAircraft = candidateOptions.recommendedAircraft or {},
        recommendedPayload = candidateOptions.recommendedPayload or {},
        packageRole = candidateOptions.packageRole,
        generationReason = candidateOptions.generationReason,
        effect = candidateOptions.effect or {},
        source = "MISSION_GENERATOR",
        reservedSlot = candidateOptions.reservedSlot == true,
        sortName = candidateOptions.sortName
            or zoneRecord and getZoneDisplayName(zoneRecord)
            or targetFob and getFobDisplayName(targetFob)
            or signature
    }
end

local function addCandidate(candidates, candidate)
    if type(candidates) ~= "table" or type(candidate) ~= "table" then
        return false
    end

    table.insert(candidates, candidate)

    return true
end

local function buildAirbaseAttackCandidate(zoneRecord)
    local bonus = getPriorityBonusFromZone(zoneRecord)
    local targetName = getZoneDisplayName(zoneRecord)

    return createCandidate(MissionGenerator.types.AIRBASE_ATTACK, zoneRecord, {
        priority = 88 + bonus,
        objective = "Attack enemy airbase infrastructure at " .. tostring(targetName) .. ".",
        description = "Degrade enemy air operations at "
            .. tostring(targetName)
            .. ". Primary effects target runway availability, parked aircraft, fuel storage and command infrastructure.",
        recommendedAircraft = { "F/A-18C", "F-15E", "F-14B" },
        recommendedPayload = { "Precision strike", "Runway attack", "Stand-off weapons" },
        packageRole = "STRIKE_PACKAGE",
        generationReason = "red_strategic_airbase_zone",
        effect = {
            airbasePressure = 20,
            capturePressure = 10,
            enemyAirActivityReduction = 10
        }
    })
end

local function buildSeadCandidate(zoneRecord)
    local bonus = getPriorityBonusFromZone(zoneRecord)
    local targetName = getZoneDisplayName(zoneRecord)

    return createCandidate(MissionGenerator.types.SEAD, zoneRecord, {
        priority = 76 + bonus,
        objective = "Suppress air defenses around " .. tostring(targetName) .. ".",
        description = "Prepare follow-on strike operations near "
            .. tostring(targetName)
            .. " by suppressing radar-guided and local air defense threats.",
        recommendedAircraft = { "F/A-18C", "F-16C", "F-15E" },
        recommendedPayload = { "AGM-88", "Stand-off munitions", "ECM support" },
        packageRole = "SUPPRESSION_PACKAGE",
        generationReason = "red_strategic_airbase_defense_belt",
        effect = {
            iadsSuppressionPressure = 15,
            missionUnlockPressure = 10
        }
    })
end

local function buildStrikeCandidate(zoneRecord)
    local bonus = getPriorityBonusFromZone(zoneRecord)
    local targetName = getZoneDisplayName(zoneRecord)

    return createCandidate(MissionGenerator.types.STRIKE, zoneRecord, {
        priority = 64 + bonus,
        objective = "Strike enemy military infrastructure at " .. tostring(targetName) .. ".",
        description = "Attack operational infrastructure at "
            .. tostring(targetName)
            .. " to reduce enemy sustainment and operational reach.",
        recommendedAircraft = { "F/A-18C", "F-15E", "A-10C" },
        recommendedPayload = { "Precision bombs", "Stand-off attack", "Rocket or gun attack if permissive" },
        packageRole = "STRIKE_PACKAGE",
        generationReason = "red_secondary_airbase_zone",
        effect = {
            capturePressure = 12,
            logisticsDisruption = 10
        }
    })
end

local function buildReconCandidate(zoneRecord)
    local bonus = getPriorityBonusFromZone(zoneRecord)
    local targetName = getZoneDisplayName(zoneRecord)

    return createCandidate(MissionGenerator.types.RECON, zoneRecord, {
        priority = 48 + bonus,
        objective = "Recon enemy-controlled target zone near " .. tostring(targetName) .. ".",
        description = "Collect information about enemy activity, defenses and infrastructure near "
            .. tostring(targetName)
            .. ".",
        recommendedAircraft = { "F/A-18C", "F-14B", "F-15E" },
        recommendedPayload = { "TGP", "Camera pod", "Light self-defense" },
        packageRole = "RECON_PACKAGE",
        generationReason = "red_zone_recon_required",
        effect = {
            intelligenceGain = 15,
            missionUnlockPressure = 5
        }
    })
end

local function buildInterdictionCandidate(zoneRecord)
    local bonus = getPriorityBonusFromZone(zoneRecord)
    local targetName = getZoneDisplayName(zoneRecord)

    return createCandidate(MissionGenerator.types.INTERDICTION, zoneRecord, {
        priority = 50 + bonus,
        objective = "Interdict enemy tactical movement and logistics near " .. tostring(targetName) .. ".",
        description = "Disrupt enemy movement, forward staging or tactical logistics near "
            .. tostring(targetName)
            .. ".",
        recommendedAircraft = { "F/A-18C", "F-15E", "A-10C", "AH-64D" },
        recommendedPayload = { "Rockets", "Maverick", "Precision bombs", "Gun" },
        packageRole = "INTERDICTION_PACKAGE",
        generationReason = "red_tactical_or_logistics_zone",
        effect = {
            logisticsDisruption = 15,
            enemyGroundActivityReduction = 10
        }
    })
end

local function buildCapCandidate(zoneRecord)
    local bonus = getPriorityBonusFromZone(zoneRecord)
    local targetName = getZoneDisplayName(zoneRecord)

    return createCandidate(MissionGenerator.types.CAP, zoneRecord, {
        priority = 58 + bonus,
        objective = "Protect friendly airspace over " .. tostring(targetName) .. ".",
        description = "Establish defensive counter-air patrol over "
            .. tostring(targetName)
            .. " to protect the blue starting area and outbound packages.",
        recommendedAircraft = { "F-14B", "F/A-18C", "F-15C" },
        recommendedPayload = { "AIM-54/AIM-120", "AIM-9", "External tanks" },
        packageRole = "AIR_SUPERIORITY_PACKAGE",
        generationReason = "blue_start_area_defense",
        effect = {
            blueAirSecurity = 15
        }
    })
end

local function buildLogisticsCandidate(zoneRecord)
    local bonus = getPriorityBonusFromZone(zoneRecord)
    local targetName = getZoneDisplayName(zoneRecord)

    return createCandidate(MissionGenerator.types.LOGISTICS, zoneRecord, {
        priority = 52 + bonus,
        objective = "Support friendly logistics buildup at " .. tostring(targetName) .. ".",
        description = "Move supplies and equipment to support operations from "
            .. tostring(targetName)
            .. ".",
        recommendedAircraft = { "UH-1H", "Mi-8", "CH-47F" },
        recommendedPayload = { "CTLD cargo", "Fuel", "Ammunition", "Engineering material" },
        packageRole = "LOGISTICS_PACKAGE",
        generationReason = "blue_logistics_zone",
        effect = {
            logisticsSupport = 25,
            supply = 25
        }
    })
end

local function buildCasCandidate(zoneRecord)
    local bonus = getPriorityBonusFromZone(zoneRecord)
    local targetName = getZoneDisplayName(zoneRecord)

    return createCandidate(MissionGenerator.types.CAS, zoneRecord, {
        priority = 55 + bonus,
        objective = "Support friendly forces in contested zone around " .. tostring(targetName) .. ".",
        description = "Provide close air support around "
            .. tostring(targetName)
            .. ".",
        recommendedAircraft = { "A-10C", "F/A-18C", "AH-64D" },
        recommendedPayload = { "Rockets", "Maverick", "Laser-guided bombs", "Gun" },
        packageRole = "CAS_PACKAGE",
        generationReason = "contested_zone_support",
        effect = {
            capturePressure = 15,
            friendlyGroundSupport = 15
        }
    })
end

local function buildFobSupportCandidate(fobRecord)
    if type(fobRecord) ~= "table" then
        return nil
    end

    local targetZone = getLinkedZoneForFob(fobRecord)

    if targetZone == nil then
        targetZone = getBlueStartZone()
    end

    if targetZone == nil then
        return nil
    end

    local supportFocus = "construction"

    if fobRecord.status == MissionGenerator.fobStatus.OUT_OF_SUPPLY or (fobRecord.supplyLevel or 0) < 25 then
        supportFocus = "supply"
    elseif fobRecord.status == MissionGenerator.fobStatus.DAMAGED then
        supportFocus = "repair"
    end

    local payload = {
        supply = 25,
        fuel = 10,
        ammunition = 10,
        engineering = 25,
        fobConstruction = 1
    }

    if supportFocus == "supply" then
        payload.supply = 50
        payload.engineering = 10
    elseif supportFocus == "repair" then
        payload.repair = 25
        payload.engineering = 25
    end

    local candidate = createCandidate(MissionGenerator.types.FOB_SUPPORT, targetZone, {
        priority = getFobSupportPriority(fobRecord),
        targetFobRecord = fobRecord,
        objective = "Support FOB construction or sustainment at " .. tostring(getFobDisplayName(fobRecord)) .. ".",
        description = "Deliver material, supply and engineering support to "
            .. tostring(getFobDisplayName(fobRecord))
            .. ". Current FOB status is "
            .. tostring(fobRecord.status or "UNKNOWN")
            .. ".",
        recommendedAircraft = { "UH-1H", "Mi-8", "CH-47F" },
        recommendedPayload = { "CTLD cargo", "Engineering material", "Fuel", "Ammunition" },
        packageRole = "FOB_SUPPORT_PACKAGE",
        generationReason = "fob_requires_support",
        reservedSlot = true,
        effect = payload,
        sortName = getFobDisplayName(fobRecord),
        strategicRelevance = 60
    })

    if candidate ~= nil then
        candidate.targetFobRecord = fobRecord
        candidate.targetFob = fobRecord.key
        candidate.signature = buildMissionSignature(
            MissionGenerator.types.FOB_SUPPORT,
            targetZone.key,
            fobRecord.linkedBaseKey,
            fobRecord.key
        )
    end

    return candidate
end

local function shouldCreateLogisticsMission(zoneRecord)
    if zoneRecord == nil then
        return false
    end

    if isBlueZone(zoneRecord) ~= true then
        return false
    end

    if zoneRecord.isStartBaseZone == true then
        return false
    end

    if zoneRecord.isLogisticsZone ~= true then
        return false
    end

    local logistics = zoneRecord.logistics or {}
    local supply = logistics.supply or 0
    local ammunition = logistics.ammunition or 0
    local fuel = logistics.fuel or 0

    if supply < 50 or ammunition < 25 or fuel < 25 then
        return true
    end

    return false
end

local function collectMissionCandidates()
    local candidates = {}
    local fobCandidateCount = 0

    for _, zoneRecord in pairs(getZoneRegistry()) do
        if isValidMissionTargetZone(zoneRecord) == true then
            if isRedZone(zoneRecord) == true then
                if isStrategicAirbaseZone(zoneRecord) == true then
                    addCandidate(candidates, buildAirbaseAttackCandidate(zoneRecord))
                    addCandidate(candidates, buildSeadCandidate(zoneRecord))
                    addCandidate(candidates, buildReconCandidate(zoneRecord))
                elseif isSecondaryAirbaseZone(zoneRecord) == true then
                    addCandidate(candidates, buildStrikeCandidate(zoneRecord))
                    addCandidate(candidates, buildReconCandidate(zoneRecord))
                elseif isHeliportZone(zoneRecord) == true
                    or isFarpZone(zoneRecord) == true
                    or isTacticalPadZone(zoneRecord) == true then
                    addCandidate(candidates, buildInterdictionCandidate(zoneRecord))
                    addCandidate(candidates, buildReconCandidate(zoneRecord))
                end
            elseif isContestedZone(zoneRecord) == true then
                addCandidate(candidates, buildCasCandidate(zoneRecord))
                addCandidate(candidates, buildReconCandidate(zoneRecord))
            elseif isBlueZone(zoneRecord) == true then
                if zoneRecord.isStartBaseZone == true then
                    addCandidate(candidates, buildCapCandidate(zoneRecord))
                end

                if shouldCreateLogisticsMission(zoneRecord) == true then
                    addCandidate(candidates, buildLogisticsCandidate(zoneRecord))
                end
            end
        end
    end

    for _, fobRecord in pairs(getFobRegistry()) do
        if shouldSupportFob(fobRecord) == true then
            local candidate = buildFobSupportCandidate(fobRecord)

            if addCandidate(candidates, candidate) == true then
                fobCandidateCount = fobCandidateCount + 1
            end
        end
    end

    table.sort(candidates, function(left, right)
        if (left.reservedSlot == true) ~= (right.reservedSlot == true) then
            return left.reservedSlot == true
        end

        if left.priority ~= right.priority then
            return left.priority > right.priority
        end

        if left.strategicRelevance ~= right.strategicRelevance then
            return left.strategicRelevance > right.strategicRelevance
        end

        return tostring(left.sortName or left.signature) < tostring(right.sortName or right.signature)
    end)

    MissionGenerator.lastFobCandidateCount = fobCandidateCount

    return candidates, fobCandidateCount
end

local function countAvailableMissions()
    local state = ensureMissionState()

    if state == nil then
        return 0
    end

    return countTableKeys(state.Missions.available)
end

local function candidateToMissionOptions(candidate)
    return {
        targetZoneRecord = candidate.targetZoneRecord,
        targetBaseRecord = candidate.targetBaseRecord,
        targetFobRecord = candidate.targetFobRecord,
        targetZone = candidate.targetZone,
        targetBase = candidate.targetBase,
        targetFob = candidate.targetFob,
        priority = candidate.priority,
        strategicRelevance = candidate.strategicRelevance,
        objective = candidate.objective,
        secondaryObjectives = candidate.secondaryObjectives,
        successCriteria = candidate.successCriteria,
        failureCriteria = candidate.failureCriteria,
        description = candidate.description,
        recommendedAircraft = candidate.recommendedAircraft,
        recommendedPayload = candidate.recommendedPayload,
        packageRole = candidate.packageRole,
        generationReason = candidate.generationReason,
        effect = candidate.effect,
        reservedSlot = candidate.reservedSlot == true,
        source = candidate.source or "MISSION_GENERATOR"
    }
end

local function getTypeLimit(missionType)
    return MissionGenerator.maxPerGenerationByType[missionType] or MissionGenerator.defaultGenerationLimit
end

local function createCandidateMission(candidate, createdByType)
    if candidate == nil then
        return false, "candidate_missing"
    end

    if missionSignatureExists(candidate.signature) == true then
        return false, "mission_already_exists"
    end

    local currentTypeCount = createdByType[candidate.missionType] or 0
    local typeLimit = getTypeLimit(candidate.missionType)

    if currentTypeCount >= typeLimit then
        return false, "type_limit_reached"
    end

    local createdMission, missionRecordOrReason = createMissionIfMissing(
        candidate.missionType,
        candidateToMissionOptions(candidate)
    )

    if createdMission == true then
        createdByType[candidate.missionType] = currentTypeCount + 1
        return true, missionRecordOrReason
    end

    return false, missionRecordOrReason
end

local function createReservedFobSupportMissions(candidates, limit, createdByType)
    local created = 0
    local duplicateSkipped = 0
    local limitSkipped = 0
    local minimum = MissionGenerator.minimumFobSupportMissions or 0

    if minimum <= 0 or limit <= 0 then
        return 0, 0, 0
    end

    for _, candidate in ipairs(candidates) do
        if created >= minimum or created >= limit then
            break
        end

        if candidate.missionType == MissionGenerator.types.FOB_SUPPORT then
            local success, missionRecordOrReason = createCandidateMission(candidate, createdByType)

            if success == true then
                created = created + 1

                logInfo(
                    "Reserved FOB support mission created: "
                    .. tostring(missionRecordOrReason.key)
                    .. " target="
                    .. tostring(missionRecordOrReason.targetFobName or missionRecordOrReason.targetZoneName or "UNKNOWN")
                )
            elseif missionRecordOrReason == "mission_already_exists" then
                duplicateSkipped = duplicateSkipped + 1
            elseif missionRecordOrReason == "type_limit_reached" then
                limitSkipped = limitSkipped + 1
            end
        end
    end

    return created, duplicateSkipped, limitSkipped
end

local function createCandidatesWithTypeLimits(candidates, limit, alreadyCreated, createdByType)
    local created = alreadyCreated or 0
    local duplicateSkipped = 0
    local limitSkipped = 0

    for _, candidate in ipairs(candidates) do
        if created >= limit then
            break
        end

        local success, missionRecordOrReason = createCandidateMission(candidate, createdByType)

        if success == true then
            created = created + 1

            logDebug(
                "Generated mission candidate accepted: "
                .. tostring(missionRecordOrReason.key)
                .. " "
                .. tostring(missionRecordOrReason.type)
                .. " priority="
                .. tostring(missionRecordOrReason.priority)
            )
        elseif missionRecordOrReason == "mission_already_exists" then
            duplicateSkipped = duplicateSkipped + 1
        elseif missionRecordOrReason == "type_limit_reached" then
            limitSkipped = limitSkipped + 1
        end
    end

    return created - (alreadyCreated or 0), duplicateSkipped, limitSkipped
end

local function fillRemainingCandidates(candidates, limit, alreadyCreated)
    local created = alreadyCreated or 0
    local duplicateSkipped = 0

    if created >= limit then
        return 0, 0
    end

    local createdByFillType = {}

    for _, candidate in ipairs(candidates) do
        if created >= limit then
            break
        end

        if missionSignatureExists(candidate.signature) == true then
            duplicateSkipped = duplicateSkipped + 1
        else
            local currentTypeCount = createdByFillType[candidate.missionType] or 0

            if currentTypeCount < 1 then
                local createdMission, missionRecordOrReason = createMissionIfMissing(
                    candidate.missionType,
                    candidateToMissionOptions(candidate)
                )

                if createdMission == true then
                    created = created + 1
                    createdByFillType[candidate.missionType] = currentTypeCount + 1

                    logDebug(
                        "Generated fill mission: "
                        .. tostring(missionRecordOrReason.key)
                        .. " "
                        .. tostring(missionRecordOrReason.type)
                        .. " priority="
                        .. tostring(missionRecordOrReason.priority)
                    )
                elseif missionRecordOrReason == "mission_already_exists" then
                    duplicateSkipped = duplicateSkipped + 1
                end
            end
        end
    end

    return created - (alreadyCreated or 0), duplicateSkipped
end

local function updateGenerationStatistics(candidateCount, fobCandidateCount, createdCount, duplicateSkipped, limitSkipped, reservedCreated)
    local state = ensureMissionState()

    if state == nil then
        return
    end

    state.Missions.lastGenerationTime = getCurrentTime()
    state.Missions.statistics.lastCreated = createdCount
    state.Missions.statistics.lastCandidates = candidateCount
    state.Missions.statistics.lastFobCandidates = fobCandidateCount
    state.Missions.statistics.lastReservedCreated = reservedCreated
    state.Missions.statistics.lastDuplicatesSkipped = duplicateSkipped
    state.Missions.statistics.lastLimitSkipped = limitSkipped

    table.insert(state.Missions.generationHistory, {
        time = state.Missions.lastGenerationTime,
        candidateCount = candidateCount,
        fobCandidateCount = fobCandidateCount,
        createdCount = createdCount,
        duplicateSkipped = duplicateSkipped,
        limitSkipped = limitSkipped,
        reservedCreated = reservedCreated,
        availableAfterGeneration = countAvailableMissions()
    })
end

local function updateMissionProgressRecord(missionRecord, percent, stage, reason)
    if type(missionRecord) ~= "table" then
        return false, "mission_missing"
    end

    missionRecord.progress = missionRecord.progress or buildInitialProgress()
    missionRecord.progress.percent = clamp(percent, 0, 100)
    missionRecord.progress.current = missionRecord.progress.percent
    missionRecord.progress.target = 100
    missionRecord.progress.stage = stage or missionRecord.progress.stage or MissionGenerator.progressStage.IN_PROGRESS
    missionRecord.progress.lastStep = reason or "progress_updated"
    missionRecord.progress.updatedAt = getCurrentTime()
    missionRecord.updatedAt = getCurrentTime()

    refreshMissionBriefing(missionRecord)

    return true, missionRecord
end

local function prepareMissionActivation(missionRecord, reason)
    if type(missionRecord) ~= "table" then
        return false, "mission_missing"
    end

    local now = getCurrentTime()

    missionRecord.activation = missionRecord.activation or {}
    missionRecord.activation.reason = reason or "mission_activated"
    missionRecord.activation.stateOnly = true
    missionRecord.activation.activatedAt = now
    missionRecord.activation.spawnTriggered = false
    missionRecord.activation.executionMode = MissionGenerator.executionMode.STATE_ONLY
    missionRecord.activation.message = "Mission activated in state only. No real spawn was triggered."

    missionRecord.activatedAt = missionRecord.activatedAt or now
    missionRecord.activatedBy = reason or "mission_activated"
    missionRecord.selectedBy = reason or "mission_activated"

    missionRecord.execution = missionRecord.execution or buildExecutionPlan(missionRecord.type)
    missionRecord.execution.mode = MissionGenerator.executionMode.STATE_ONLY
    missionRecord.execution.stateOnly = true
    missionRecord.execution.spawnAllowed = false
    missionRecord.execution.spawnTriggered = false
    missionRecord.execution.spawnHookStatus = "RESERVED"
    missionRecord.execution.updatedAt = now

    missionRecord.currentTask = missionRecord.objective or buildObjectiveText(missionRecord.type, getMissionTargetText(missionRecord))
    missionRecord.updatedAt = now

    updateMissionProgressRecord(
        missionRecord,
        0,
        MissionGenerator.progressStage.ACTIVE,
        "mission_activated_state_only"
    )

    refreshMissionBriefing(missionRecord)

    return true, missionRecord
end

local function applyMissionCompletionEffect(missionRecord)
    if missionRecord == nil then
        return false, "mission_missing"
    end

    if missionRecord.effectApplied == true then
        return true, "effect_already_applied"
    end

    missionRecord.effectApplied = true
    missionRecord.effectAppliedAt = getCurrentTime()

    local targetZone = nil

    if missionRecord.targetZoneKey ~= nil then
        targetZone = findZoneByKeyOrName(missionRecord.targetZoneKey)
    end

    if targetZone ~= nil then
        targetZone.missionEffects = targetZone.missionEffects or {}

        if missionRecord.effect ~= nil then
            for effectKey, effectValue in pairs(missionRecord.effect) do
                if type(effectValue) == "number" then
                    targetZone.missionEffects[effectKey] = (targetZone.missionEffects[effectKey] or 0) + effectValue
                else
                    targetZone.missionEffects[effectKey] = effectValue
                end
            end
        end

        targetZone.updatedAt = getCurrentTime()
    end

    if missionRecord.type == MissionGenerator.types.LOGISTICS then
        if targetZone ~= nil then
            targetZone.logistics = targetZone.logistics or {}
            targetZone.logistics.supply = (targetZone.logistics.supply or 0) + (missionRecord.effect and missionRecord.effect.supply or 25)
            targetZone.logistics.lastSupportMission = missionRecord.key
            targetZone.logistics.updatedAt = getCurrentTime()
        end
    end

    if missionRecord.type == MissionGenerator.types.FOB_SUPPORT then
        local deliverySystem = getDeliverySystem()

        if deliverySystem ~= nil and deliverySystem.createFobPackageDelivery ~= nil then
            deliverySystem.createFobPackageDelivery({
                name = "FOB support from " .. tostring(missionRecord.key),
                owner = missionRecord.owner,
                source = "MISSION_COMPLETION_STATE_ONLY",
                targetZone = missionRecord.targetZoneKey,
                targetBase = missionRecord.targetBaseKey,
                targetFob = missionRecord.targetFobKey,
                effect = missionRecord.effect or {
                    supply = 25,
                    engineering = 25,
                    fobConstruction = 1
                },
                notes = "Generated by completed FOB support mission. State-only; no CTLD crate spawned here."
            })
        end
    end

    updateMissionProgressRecord(
        missionRecord,
        100,
        MissionGenerator.progressStage.COMPLETED,
        "mission_effect_applied"
    )

    markDirty("mission_effect_applied")

    return true, missionRecord
end

function MissionGenerator.createMission(missionType, options)
    local state = ensureMissionState()

    if state == nil then
        return false, "state_unavailable"
    end

    local missionRecord, reason = buildMissionRecord(missionType, options)

    if missionRecord == nil then
        return false, reason
    end

    if missionSignatureExists(missionRecord.signature) == true then
        return false, "mission_already_exists"
    end

    local added, addedResult = addMissionToContainer(missionRecord)

    if added ~= true then
        return false, addedResult
    end

    logInfo(
        "Mission created: "
        .. tostring(missionRecord.type)
        .. " ["
        .. tostring(missionRecord.key)
        .. "] target="
        .. tostring(missionRecord.targetFobName or missionRecord.targetZoneName or missionRecord.targetBaseName or "UNKNOWN")
        .. " priority="
        .. tostring(missionRecord.priority)
    )

    return true, missionRecord
end

function MissionGenerator.getMission(missionKeyOrName)
    local state = ensureMissionState()

    if state == nil then
        return nil
    end

    local containers = {
        state.Missions.available,
        state.Missions.active,
        state.Missions.completed,
        state.Missions.failed,
        state.Missions.expired,
        state.Missions.cancelled
    }

    for _, container in ipairs(containers) do
        local missionRecord = getMissionFromContainer(container, missionKeyOrName)

        if missionRecord ~= nil then
            return missionRecord
        end
    end

    return nil
end

function MissionGenerator.setMissionStatus(missionKeyOrName, status, reason)
    local state = ensureMissionState()

    if state == nil then
        return false, "state_unavailable"
    end

    if isValidStatus(status) ~= true then
        return false, "invalid_status"
    end

    local missionRecord = MissionGenerator.getMission(missionKeyOrName)

    if missionRecord == nil then
        return false, "mission_not_found"
    end

    missionRecord.previousStatus = missionRecord.status
    missionRecord.status = status
    missionRecord.statusReason = reason or "manual_status_update"
    missionRecord.updatedAt = getCurrentTime()

    if status == getStatusActive() or status == MissionGenerator.status.ACTIVE then
        prepareMissionActivation(missionRecord, reason or "mission_activated")
        MissionGenerator.lastActivationTime = getCurrentTime()
        MissionGenerator.lastActivatedMissionKey = missionRecord.key
        state.Missions.lastActivationTime = MissionGenerator.lastActivationTime
        state.Missions.lastActivatedMissionKey = missionRecord.key

        table.insert(state.Missions.activationHistory, {
            time = MissionGenerator.lastActivationTime,
            key = missionRecord.key,
            type = missionRecord.type,
            target = getMissionTargetText(missionRecord),
            reason = reason or "mission_activated",
            stateOnly = true
        })
    elseif status == getStatusCompleted() or status == MissionGenerator.status.COMPLETED then
        missionRecord.completedAt = missionRecord.completedAt or getCurrentTime()
        updateMissionProgressRecord(missionRecord, 100, MissionGenerator.progressStage.EFFECT_PENDING, reason or "mission_completed")
    elseif status == getStatusFailed() or status == MissionGenerator.status.FAILED then
        missionRecord.failedAt = missionRecord.failedAt or getCurrentTime()
        updateMissionProgressRecord(missionRecord, missionRecord.progress and missionRecord.progress.percent or 0, MissionGenerator.progressStage.FAILED, reason or "mission_failed")
    elseif status == getStatusExpired() or status == MissionGenerator.status.EXPIRED then
        missionRecord.expiredAt = missionRecord.expiredAt or getCurrentTime()
        updateMissionProgressRecord(missionRecord, missionRecord.progress and missionRecord.progress.percent or 0, MissionGenerator.progressStage.EXPIRED, reason or "mission_expired")
    elseif status == getStatusCancelled() or status == MissionGenerator.status.CANCELLED then
        missionRecord.cancelledAt = missionRecord.cancelledAt or getCurrentTime()
        updateMissionProgressRecord(missionRecord, missionRecord.progress and missionRecord.progress.percent or 0, MissionGenerator.progressStage.CANCELLED, reason or "mission_cancelled")
    end

    addMissionToContainer(missionRecord)

    logInfo(
        "Mission status changed: "
        .. tostring(missionRecord.key)
        .. " ["
        .. tostring(status)
        .. "]"
    )

    if status == getStatusActive() or status == MissionGenerator.status.ACTIVE then
        logInfo(
            "Mission activation prepared: "
            .. tostring(missionRecord.key)
            .. " stateOnly=true spawnHooks=reserved"
        )
    end

    return true, missionRecord
end

function MissionGenerator.activateMission(missionKeyOrName, reason)
    return MissionGenerator.setMissionStatus(
        missionKeyOrName,
        getStatusActive(),
        reason or "mission_activated"
    )
end

function MissionGenerator.completeMission(missionKeyOrName, reason)
    local statusChanged, missionRecordOrReason = MissionGenerator.setMissionStatus(
        missionKeyOrName,
        getStatusCompleted(),
        reason or "mission_completed"
    )

    if statusChanged ~= true then
        return false, missionRecordOrReason
    end

    applyMissionCompletionEffect(missionRecordOrReason)
    addMissionToContainer(missionRecordOrReason)
    markDirty("mission_completed")

    logInfo(
        "Mission completed: "
        .. tostring(missionRecordOrReason.type)
        .. " ["
        .. tostring(missionRecordOrReason.key)
        .. "]"
    )

    return true, missionRecordOrReason
end

function MissionGenerator.failMission(missionKeyOrName, reason)
    return MissionGenerator.setMissionStatus(
        missionKeyOrName,
        getStatusFailed(),
        reason or "mission_failed"
    )
end

function MissionGenerator.expireMission(missionKeyOrName, reason)
    return MissionGenerator.setMissionStatus(
        missionKeyOrName,
        getStatusExpired(),
        reason or "mission_expired"
    )
end

function MissionGenerator.cancelMission(missionKeyOrName, reason)
    return MissionGenerator.setMissionStatus(
        missionKeyOrName,
        getStatusCancelled(),
        reason or "mission_cancelled"
    )
end

function MissionGenerator.deleteMission(missionKeyOrName)
    local state = ensureMissionState()

    if state == nil then
        return false, "state_unavailable"
    end

    local missionRecord = MissionGenerator.getMission(missionKeyOrName)

    if missionRecord == nil then
        return false, "mission_not_found"
    end

    removeMissionFromAllContainers(state, missionRecord.key)
    updateStatistics()
    markDirty("mission_deleted")

    logInfo("Mission deleted: " .. tostring(missionRecord.key))

    return true, missionRecord
end

function MissionGenerator.clearAvailableMissions()
    local state = ensureMissionState()

    if state == nil then
        return false, "state_unavailable"
    end

    state.Missions.available = {}

    updateStatistics()
    markDirty("available_missions_cleared")

    logInfo("Available missions cleared")

    return true
end

function MissionGenerator.generateAvailableMissions(limit)
    local state = ensureMissionState()

    if state == nil then
        MissionGenerator.failed = true

        setModuleStatus("FAILED")
        setFeatureStatus(false)

        logError("Mission generation failed because state is unavailable")

        return false, "state_unavailable"
    end

    local generationLimit = limit or MissionGenerator.defaultGenerationLimit
    local currentAvailable = countTableKeys(state.Missions.available)

    if currentAvailable >= generationLimit then
        MissionGenerator.lastCandidateCount = 0
        MissionGenerator.lastCreatedCount = 0
        MissionGenerator.lastSkippedDuplicateCount = 0
        MissionGenerator.lastSkippedLimitCount = 0
        MissionGenerator.lastReservedCreatedCount = 0

        updateGenerationStatistics(0, 0, 0, 0, 0, 0)

        logInfo(
            "Mission generation skipped: available mission pool already contains "
            .. tostring(currentAvailable)
            .. " missions"
        )

        return true, 0
    end

    local remainingLimit = generationLimit - currentAvailable
    local candidates, fobCandidateCount = collectMissionCandidates()
    local candidateCount = #candidates
    local createdByType = {}

    MissionGenerator.lastCandidateCount = candidateCount
    MissionGenerator.lastFobCandidateCount = fobCandidateCount

    logInfo(
        "Mission candidate summary: candidates="
        .. tostring(candidateCount)
        .. ", fobSupportCandidates="
        .. tostring(fobCandidateCount)
        .. ", availableBefore="
        .. tostring(currentAvailable)
        .. ", generationSlots="
        .. tostring(remainingLimit)
    )

    local reservedCreated, reservedDuplicates, reservedTypeLimit = createReservedFobSupportMissions(
        candidates,
        remainingLimit,
        createdByType
    )

    local createdWithLimits, duplicatesWithLimits, skippedByTypeLimit = createCandidatesWithTypeLimits(
        candidates,
        remainingLimit,
        reservedCreated,
        createdByType
    )

    local createdAfterLimits = reservedCreated + createdWithLimits
    local createdByFill, duplicatesByFill = fillRemainingCandidates(candidates, remainingLimit, createdAfterLimits)

    local createdTotal = reservedCreated + createdWithLimits + createdByFill
    local duplicateTotal = reservedDuplicates + duplicatesWithLimits + duplicatesByFill
    local limitSkippedTotal = reservedTypeLimit + skippedByTypeLimit

    MissionGenerator.lastGenerationTime = getCurrentTime()
    MissionGenerator.lastCreatedCount = createdTotal
    MissionGenerator.lastSkippedDuplicateCount = duplicateTotal
    MissionGenerator.lastSkippedLimitCount = limitSkippedTotal
    MissionGenerator.lastReservedCreatedCount = reservedCreated

    updateGenerationStatistics(
        candidateCount,
        fobCandidateCount,
        createdTotal,
        duplicateTotal,
        limitSkippedTotal,
        reservedCreated
    )

    updateStatistics()
    markDirty("missions_generated")

    logInfo(
        "Mission generation completed: "
        .. tostring(createdTotal)
        .. " new missions from "
        .. tostring(candidateCount)
        .. " candidates (fobSupportCandidates="
        .. tostring(fobCandidateCount)
        .. ", reservedCreated="
        .. tostring(reservedCreated)
        .. ", duplicatesSkipped="
        .. tostring(duplicateTotal)
        .. ", typeLimitSkipped="
        .. tostring(limitSkippedTotal)
        .. ")"
    )

    return true, createdTotal
end

function MissionGenerator.generate(limit)
    return MissionGenerator.generateAvailableMissions(limit)
end

function MissionGenerator.start()
    if MissionGenerator.started == true
        and MissionGenerator.finished == true
        and MissionGenerator.failed ~= true then
        logDebug("Mission generator already started")
        return true
    end

    MissionGenerator.started = true
    MissionGenerator.finished = false
    MissionGenerator.failed = false

    setModuleStatus("STARTING")
    setFeatureStatus(false)

    logInfo("Mission generator started")

    local success, result = MissionGenerator.generateAvailableMissions(MissionGenerator.defaultGenerationLimit)

    if success ~= true then
        MissionGenerator.failed = true

        setModuleStatus("FAILED")
        setFeatureStatus(false)

        logError("Mission generator failed: " .. tostring(result))

        return false
    end

    MissionGenerator.finished = true

    setModuleStatus("READY")
    setFeatureStatus(true)

    logInfo("Mission generator ready")

    return true
end

function MissionGenerator.stop()
    MissionGenerator.started = false

    logInfo("Mission generator stopped")

    return true
end

function MissionGenerator.getAvailableMissions()
    local state = ensureMissionState()

    if state == nil then
        return {}
    end

    return state.Missions.available
end

function MissionGenerator.getActiveMissions()
    local state = ensureMissionState()

    if state == nil then
        return {}
    end

    return state.Missions.active
end

function MissionGenerator.getCompletedMissions()
    local state = ensureMissionState()

    if state == nil then
        return {}
    end

    return state.Missions.completed
end

function MissionGenerator.getFailedMissions()
    local state = ensureMissionState()

    if state == nil then
        return {}
    end

    return state.Missions.failed
end

function MissionGenerator.getExpiredMissions()
    local state = ensureMissionState()

    if state == nil then
        return {}
    end

    return state.Missions.expired
end

function MissionGenerator.getCancelledMissions()
    local state = ensureMissionState()

    if state == nil then
        return {}
    end

    return state.Missions.cancelled
end

function MissionGenerator.getSortedAvailableMissions()
    local state = ensureMissionState()

    if state == nil then
        return {}
    end

    return tableToSortedList(state.Missions.available)
end

function MissionGenerator.getSortedActiveMissions()
    local state = ensureMissionState()

    if state == nil then
        return {}
    end

    return tableToSortedList(state.Missions.active)
end

function MissionGenerator.getMissionsByType(missionType)
    local result = {}
    local state = ensureMissionState()

    if state == nil then
        return result
    end

    local containers = {
        state.Missions.available,
        state.Missions.active,
        state.Missions.completed,
        state.Missions.failed,
        state.Missions.expired,
        state.Missions.cancelled
    }

    for _, container in ipairs(containers) do
        for key, missionRecord in pairs(container) do
            if missionRecord.type == missionType then
                result[key] = missionRecord
            end
        end
    end

    return result
end

function MissionGenerator.getMissionsForZone(zoneKeyOrName)
    local result = {}
    local zoneRecord = findZoneByKeyOrName(zoneKeyOrName)

    if zoneRecord == nil then
        return result
    end

    local state = ensureMissionState()

    if state == nil then
        return result
    end

    local containers = {
        state.Missions.available,
        state.Missions.active,
        state.Missions.completed,
        state.Missions.failed,
        state.Missions.expired,
        state.Missions.cancelled
    }

    for _, container in ipairs(containers) do
        for key, missionRecord in pairs(container) do
            if missionRecord.targetZoneKey == zoneRecord.key then
                result[key] = missionRecord
            end
        end
    end

    return result
end

function MissionGenerator.getMissionsForFob(fobKeyOrName)
    local result = {}

    if fobKeyOrName == nil then
        return result
    end

    local state = ensureMissionState()

    if state == nil then
        return result
    end

    local normalizedSearch = normalizeName(fobKeyOrName)
    local containers = {
        state.Missions.available,
        state.Missions.active,
        state.Missions.completed,
        state.Missions.failed,
        state.Missions.expired,
        state.Missions.cancelled
    }

    for _, container in ipairs(containers) do
        for key, missionRecord in pairs(container) do
            if missionRecord.targetFobKey == fobKeyOrName
                or normalizeName(missionRecord.targetFobName) == normalizedSearch then
                result[key] = missionRecord
            end
        end
    end

    return result
end

function MissionGenerator.getTopAvailableMission()
    local sorted = MissionGenerator.getSortedAvailableMissions()

    return sorted[1]
end

function MissionGenerator.getGenerationCandidates()
    local candidates = collectMissionCandidates()

    return candidates
end

function MissionGenerator.getMissionBriefing(missionKeyOrName)
    local missionRecord = MissionGenerator.getMission(missionKeyOrName)

    if missionRecord == nil then
        return nil, "mission_not_found"
    end

    return refreshMissionBriefing(missionRecord), missionRecord
end

function MissionGenerator.getMissionProgress(missionKeyOrName)
    local missionRecord = MissionGenerator.getMission(missionKeyOrName)

    if missionRecord == nil then
        return nil, "mission_not_found"
    end

    missionRecord.progress = missionRecord.progress or buildInitialProgress()

    return missionRecord.progress, missionRecord
end

function MissionGenerator.updateMissionProgress(missionKeyOrName, percent, stage, reason)
    local missionRecord = MissionGenerator.getMission(missionKeyOrName)

    if missionRecord == nil then
        return false, "mission_not_found"
    end

    local success, result = updateMissionProgressRecord(missionRecord, percent, stage, reason)

    if success ~= true then
        return false, result
    end

    addMissionToContainer(missionRecord)
    markDirty("mission_progress_updated")

    logInfo(
        "Mission progress updated: "
        .. tostring(missionRecord.key)
        .. " percent="
        .. tostring(missionRecord.progress and missionRecord.progress.percent or 0)
        .. " stage="
        .. tostring(missionRecord.progress and missionRecord.progress.stage or "UNKNOWN")
    )

    return true, result
end

function MissionGenerator.getStatistics()
    local state = ensureMissionState()

    if state == nil then
        return {}
    end

    updateStatistics()

    return state.Missions.statistics
end

function MissionGenerator.summary()
    local state = ensureMissionState()
    local statistics = {}

    if state ~= nil then
        updateStatistics()
        statistics = state.Missions.statistics
    end

    return {
        name = MissionGenerator.name,
        displayName = MissionGenerator.displayName,
        path = MissionGenerator.path,
        version = MissionGenerator.version,
        loaded = MissionGenerator.loaded,
        started = MissionGenerator.started,
        finished = MissionGenerator.finished,
        failed = MissionGenerator.failed,
        defaultGenerationLimit = MissionGenerator.defaultGenerationLimit,
        minimumFobSupportMissions = MissionGenerator.minimumFobSupportMissions,
        lastGenerationTime = MissionGenerator.lastGenerationTime,
        lastActivationTime = MissionGenerator.lastActivationTime,
        lastActivatedMissionKey = MissionGenerator.lastActivatedMissionKey,
        lastCandidateCount = MissionGenerator.lastCandidateCount,
        lastFobCandidateCount = MissionGenerator.lastFobCandidateCount,
        lastCreatedCount = MissionGenerator.lastCreatedCount,
        lastReservedCreatedCount = MissionGenerator.lastReservedCreatedCount,
        lastSkippedDuplicateCount = MissionGenerator.lastSkippedDuplicateCount,
        lastSkippedLimitCount = MissionGenerator.lastSkippedLimitCount,
        statistics = statistics
    }
end

TC.Missions.Generator = MissionGenerator
TC.missions.Generator = MissionGenerator

TC.modules.missionGenerator = {
    name = MissionGenerator.name,
    path = MissionGenerator.path,
    loaded = true,
    version = MissionGenerator.version
}

setModuleStatus("LOADED")
logInfo("Loaded " .. MissionGenerator.path .. " v" .. MissionGenerator.version)

return MissionGenerator
