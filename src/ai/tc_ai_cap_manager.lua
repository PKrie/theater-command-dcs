-- Theater Command DCS
-- File: src/ai/tc_ai_cap_manager.lua
--
-- Purpose:
--   Manage strategic Combat Air Patrol requirements and AI air reaction state.
--
-- Current focus:
--   Airbase Scanner and Zone Factory now provide classified campaign zones.
--   The CAP Manager must therefore derive CAP requirements from meaningful
--   strategic/secondary airbase zones instead of relying on unordered raw zone
--   iteration.
--
-- Version:
--   0.2.0
--
-- Responsibilities:
--   - register CAP zones from classified campaign zones
--   - prioritize Blue home defense and Red strategic airbase defense
--   - avoid medical pads, helipads, unknown objects and tactical pads as
--     automatic CAP centers
--   - create deterministic CAP requests
--   - store CAP state for later MOOSE spawning
--   - keep state compatible with later AI Director, F10 UI and persistence
--
-- Vendor note:
--   This file does not yet spawn real MOOSE AI_A2A_DISPATCHER or SPAWN groups.
--   It only prepares the Theater Command AI state. Real MOOSE execution will be
--   added later after template groups exist in the Mission Editor.

TC = TC or {}
TC.modules = TC.modules or {}
TC.AI = TC.AI or {}
TC.ai = TC.ai or TC.AI

local CapManager = {}

CapManager.name = "tc_ai_cap_manager"
CapManager.displayName = "AI CAP Manager"
CapManager.path = "src/ai/tc_ai_cap_manager.lua"
CapManager.version = "0.2.0"

CapManager.loaded = true
CapManager.started = false
CapManager.finished = false
CapManager.failed = false

CapManager.lastUpdateTime = 0
CapManager.lastCandidateCount = 0
CapManager.lastRegisteredCount = 0
CapManager.lastRequestedCount = 0
CapManager.lastSkippedCount = 0

CapManager.defaultCapZoneLimit = 12
CapManager.defaultRequestLimit = 12
CapManager.defaultMaxActivePerZone = 1

CapManager.sides = {
    BLUE = "BLUE",
    RED = "RED",
    NEUTRAL = "NEUTRAL"
}

CapManager.status = {
    REGISTERED = "REGISTERED",
    REQUESTED = "REQUESTED",
    ACTIVE = "ACTIVE",
    COMPLETED = "COMPLETED",
    FAILED = "FAILED",
    CANCELLED = "CANCELLED"
}

CapManager.zoneClasses = {
    STRATEGIC_AIRBASE_ZONE = "STRATEGIC_AIRBASE_ZONE",
    SECONDARY_AIRBASE_ZONE = "SECONDARY_AIRBASE_ZONE",
    HELIPORT_ZONE = "HELIPORT_ZONE",
    FARP_ZONE = "FARP_ZONE",
    TACTICAL_PAD_ZONE = "TACTICAL_PAD_ZONE",
    MISSION_EDITOR_CAPTURE_ZONE = "MISSION_EDITOR_CAPTURE_ZONE",
    MISSION_EDITOR_ZONE = "MISSION_EDITOR_ZONE",
    UNKNOWN_ZONE = "UNKNOWN_ZONE"
}

CapManager.airbaseClassifications = {
    STRATEGIC_AIRFIELD = "STRATEGIC_AIRFIELD",
    SECONDARY_AIRFIELD = "SECONDARY_AIRFIELD",
    HELIPORT = "HELIPORT",
    HELIPAD = "HELIPAD",
    MEDICAL_PAD = "MEDICAL_PAD",
    FARP = "FARP",
    TACTICAL_PAD = "TACTICAL_PAD",
    UNKNOWN = "UNKNOWN"
}

CapManager.defaultPriorities = {
    BLUE_START_BASE = 95,
    BLUE_SECONDARY_BASE = 65,
    BLUE_CONTESTED = 85,
    RED_STRATEGIC_BASE = 90,
    RED_SECONDARY_BASE = 72,
    RED_CONTESTED = 86,
    MISSION_REACTION = 80,
    MANUAL = 75
}

CapManager.defaultRadii = {
    BLUE_START_BASE = 60000,
    BLUE_SECONDARY_BASE = 40000,
    RED_STRATEGIC_BASE = 50000,
    RED_SECONDARY_BASE = 35000,
    CONTESTED = 45000,
    DEFAULT = 30000
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
    local formatted = "[TC][AI_CAP_MANAGER] " .. tostring(message)

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
        logger.info("[AICapManager] " .. tostring(message))
        return
    end

    rawLog("INFO", message)
end

local function logWarn(message)
    local logger = getLogger()

    if logger ~= nil and logger.warn ~= nil then
        logger.warn("[AICapManager] " .. tostring(message))
        return
    end

    rawLog("WARN", message)
end

local function logError(message)
    local logger = getLogger()

    if logger ~= nil and logger.error ~= nil then
        logger.error("[AICapManager] " .. tostring(message))
        return
    end

    rawLog("ERROR", message)
end

local function logDebug(message)
    local logger = getLogger()

    if logger ~= nil and logger.debug ~= nil then
        logger.debug("[AICapManager] " .. tostring(message))
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
            and type(childValue) ~= "thread"
        then
            result[copyValue(key, visited)] = copyValue(childValue, visited)
        end
    end

    visited[value] = nil

    return result
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

local function getRecordOwner(record)
    if type(record) ~= "table" then
        return getOwnerUnknown()
    end

    return record.currentOwner or record.initialOwner or record.owner or getOwnerUnknown()
end

local function isValidSide(side)
    return side == CapManager.sides.BLUE
        or side == CapManager.sides.RED
        or side == CapManager.sides.NEUTRAL
end

local function isValidStatus(status)
    if status == nil then
        return false
    end

    for _, allowedStatus in pairs(CapManager.status) do
        if status == allowedStatus then
            return true
        end
    end

    return false
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

local function getMissionState()
    local state = getState()

    if state ~= nil and state.Missions ~= nil then
        return state.Missions
    end

    return nil
end

local function ensureAiState()
    local state = getState()

    TC.AI = TC.AI or {}
    TC.ai = TC.AI

    if state == nil then
        return nil
    end

    state.AI = state.AI or {}
    state.AI.enabled = true
    state.AI.directorEnabled = state.AI.directorEnabled == true
    state.AI.capManagerEnabled = true

    state.AI.lastUpdate = state.AI.lastUpdate or 0
    state.AI.threatLevel = state.AI.threatLevel or "UNKNOWN"
    state.AI.reactionState = state.AI.reactionState or "STANDBY"
    state.AI.escalationLevel = state.AI.escalationLevel or 0

    state.AI.lastCapId = state.AI.lastCapId or 0
    state.AI.capZones = state.AI.capZones or {}
    state.AI.capZoneCandidates = state.AI.capZoneCandidates or {}
    state.AI.capRequests = state.AI.capRequests or {}
    state.AI.activeCaps = state.AI.activeCaps or {}
    state.AI.completedCaps = state.AI.completedCaps or {}
    state.AI.failedCaps = state.AI.failedCaps or {}
    state.AI.cancelledCaps = state.AI.cancelledCaps or {}

    state.AI.capStatistics = state.AI.capStatistics or {
        candidates = 0,
        zones = 0,
        requested = 0,
        active = 0,
        completed = 0,
        failed = 0,
        cancelled = 0,
        blueZones = 0,
        redZones = 0,
        blueRequests = 0,
        redRequests = 0
    }

    return state
end

local function markDirty(reason)
    local state = getState()

    if state ~= nil and state.markDirty ~= nil then
        state.markDirty(reason or "ai_cap_state_changed")
        return true
    end

    if state ~= nil then
        state.Persistence = state.Persistence or {}
        state.Persistence.dirty = true
        state.Persistence.dirtyReason = reason or "ai_cap_state_changed"
        state.Persistence.dirtyAt = getCurrentTime()
        return true
    end

    return false
end

local function setModuleStatus(status)
    local state = getState()

    if state ~= nil and state.setModuleStatus ~= nil then
        state.setModuleStatus("aiCapManager", status)
    end
end

local function setFeatureStatus(enabled)
    local state = getState()

    if state ~= nil and state.setFeatureStatus ~= nil then
        state.setFeatureStatus("aiCapManager", enabled == true)
    end
end

local function findZoneByKeyOrName(keyOrName)
    if keyOrName == nil then
        return nil
    end

    local registry = getZoneRegistry()

    if registry[keyOrName] ~= nil then
        return registry[keyOrName]
    end

    local normalizedSearch = normalizeName(keyOrName)

    for _, zoneRecord in pairs(registry) do
        if zoneRecord.normalizedName == normalizedSearch then
            return zoneRecord
        end

        if normalizeName(zoneRecord.name) == normalizedSearch then
            return zoneRecord
        end

        if normalizeName(zoneRecord.displayName) == normalizedSearch then
            return zoneRecord
        end
    end

    return nil
end

local function findBaseByKeyOrName(keyOrName)
    if keyOrName == nil then
        return nil
    end

    local registry = getBaseRegistry()

    if registry[keyOrName] ~= nil then
        return registry[keyOrName]
    end

    local normalizedSearch = normalizeName(keyOrName)

    for _, baseRecord in pairs(registry) do
        if baseRecord.normalizedName == normalizedSearch then
            return baseRecord
        end

        if normalizeName(baseRecord.name) == normalizedSearch then
            return baseRecord
        end

        if normalizeName(baseRecord.displayName) == normalizedSearch then
            return baseRecord
        end
    end

    return nil
end

local function findBlueStartBase()
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

local function findPreferredBaseForSide(side, zoneRecord)
    if side == CapManager.sides.BLUE then
        local blueStartBase = findBlueStartBase()

        if blueStartBase ~= nil then
            return blueStartBase
        end
    end

    if type(zoneRecord) == "table" and zoneRecord.linkedAirbaseKey ~= nil then
        local linkedBase = findBaseByKeyOrName(zoneRecord.linkedAirbaseKey)

        if linkedBase ~= nil and getRecordOwner(linkedBase) == side then
            return linkedBase
        end
    end

    for _, baseRecord in pairs(getBaseRegistry()) do
        if getRecordOwner(baseRecord) == side then
            if side == CapManager.sides.BLUE and baseRecord.isStartBase == true then
                return baseRecord
            end

            if side == CapManager.sides.RED and baseRecord.isStrategicAirfield == true then
                return baseRecord
            end
        end
    end

    for _, baseRecord in pairs(getBaseRegistry()) do
        if getRecordOwner(baseRecord) == side then
            return baseRecord
        end
    end

    return nil
end

local function getAirbaseClassification(zoneRecord)
    if type(zoneRecord) ~= "table" then
        return CapManager.airbaseClassifications.UNKNOWN
    end

    if zoneRecord.airbaseClassification ~= nil then
        return zoneRecord.airbaseClassification
    end

    if zoneRecord.targetAirbaseClassification ~= nil then
        return zoneRecord.targetAirbaseClassification
    end

    if zoneRecord.isStrategicAirbaseZone == true then
        return CapManager.airbaseClassifications.STRATEGIC_AIRFIELD
    end

    if zoneRecord.isSecondaryAirbaseZone == true then
        return CapManager.airbaseClassifications.SECONDARY_AIRFIELD
    end

    if zoneRecord.isHeliportZone == true then
        return CapManager.airbaseClassifications.HELIPORT
    end

    if zoneRecord.isFarpZone == true then
        return CapManager.airbaseClassifications.FARP
    end

    if zoneRecord.isTacticalPadZone == true then
        return CapManager.airbaseClassifications.TACTICAL_PAD
    end

    return CapManager.airbaseClassifications.UNKNOWN
end

local function isStrategicAirbaseZone(zoneRecord)
    if type(zoneRecord) ~= "table" then
        return false
    end

    if zoneRecord.isStrategicAirbaseZone == true then
        return true
    end

    if zoneRecord.zoneClass == CapManager.zoneClasses.STRATEGIC_AIRBASE_ZONE then
        return true
    end

    return getAirbaseClassification(zoneRecord) == CapManager.airbaseClassifications.STRATEGIC_AIRFIELD
end

local function isSecondaryAirbaseZone(zoneRecord)
    if type(zoneRecord) ~= "table" then
        return false
    end

    if zoneRecord.isSecondaryAirbaseZone == true then
        return true
    end

    if zoneRecord.zoneClass == CapManager.zoneClasses.SECONDARY_AIRBASE_ZONE then
        return true
    end

    return getAirbaseClassification(zoneRecord) == CapManager.airbaseClassifications.SECONDARY_AIRFIELD
end

local function isExcludedAutomaticCapZone(zoneRecord)
    local classification = getAirbaseClassification(zoneRecord)

    if classification == CapManager.airbaseClassifications.HELIPAD then
        return true
    end

    if classification == CapManager.airbaseClassifications.MEDICAL_PAD then
        return true
    end

    if classification == CapManager.airbaseClassifications.TACTICAL_PAD then
        return true
    end

    if classification == CapManager.airbaseClassifications.FARP then
        return true
    end

    if classification == CapManager.airbaseClassifications.UNKNOWN then
        return true
    end

    if zoneRecord.zoneClass == CapManager.zoneClasses.UNKNOWN_ZONE then
        return true
    end

    return false
end

local function getZoneStrategicRelevance(zoneRecord)
    if type(zoneRecord) ~= "table" then
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

    return 0
end

local function getZoneDisplayName(zoneRecord)
    if type(zoneRecord) ~= "table" then
        return "UNKNOWN_ZONE"
    end

    return zoneRecord.linkedAirbaseName
        or zoneRecord.displayName
        or zoneRecord.name
        or zoneRecord.key
        or "UNKNOWN_ZONE"
end

local function getCapRadius(side, zoneRecord)
    local owner = getRecordOwner(zoneRecord)

    if owner == getOwnerContested() then
        return CapManager.defaultRadii.CONTESTED
    end

    if side == CapManager.sides.BLUE then
        if zoneRecord.isStartBaseZone == true then
            return CapManager.defaultRadii.BLUE_START_BASE
        end

        return CapManager.defaultRadii.BLUE_SECONDARY_BASE
    end

    if side == CapManager.sides.RED then
        if isStrategicAirbaseZone(zoneRecord) == true then
            return CapManager.defaultRadii.RED_STRATEGIC_BASE
        end

        return CapManager.defaultRadii.RED_SECONDARY_BASE
    end

    return CapManager.defaultRadii.DEFAULT
end

local function calculateCapPriority(side, zoneRecord)
    local owner = getRecordOwner(zoneRecord)
    local relevanceBonus = math.floor(getZoneStrategicRelevance(zoneRecord) / 10)

    if owner == getOwnerContested() then
        if side == CapManager.sides.BLUE then
            return CapManager.defaultPriorities.BLUE_CONTESTED + relevanceBonus
        end

        if side == CapManager.sides.RED then
            return CapManager.defaultPriorities.RED_CONTESTED + relevanceBonus
        end
    end

    if side == CapManager.sides.BLUE then
        if zoneRecord.isStartBaseZone == true then
            return CapManager.defaultPriorities.BLUE_START_BASE + relevanceBonus
        end

        return CapManager.defaultPriorities.BLUE_SECONDARY_BASE + relevanceBonus
    end

    if side == CapManager.sides.RED then
        if isStrategicAirbaseZone(zoneRecord) == true then
            return CapManager.defaultPriorities.RED_STRATEGIC_BASE + relevanceBonus
        end

        return CapManager.defaultPriorities.RED_SECONDARY_BASE + relevanceBonus
    end

    return CapManager.defaultPriorities.MANUAL
end

local function shouldCreateBlueCapCandidate(zoneRecord)
    if type(zoneRecord) ~= "table" then
        return false
    end

    if isExcludedAutomaticCapZone(zoneRecord) == true then
        return false
    end

    local owner = getRecordOwner(zoneRecord)

    if owner == getOwnerContested() then
        return true
    end

    if owner ~= getOwnerBlue() then
        return false
    end

    if zoneRecord.isStartBaseZone == true then
        return true
    end

    if isStrategicAirbaseZone(zoneRecord) == true then
        return true
    end

    if isSecondaryAirbaseZone(zoneRecord) == true and zoneRecord.theatreArea == "CYPRUS" then
        return true
    end

    return false
end

local function shouldCreateRedCapCandidate(zoneRecord)
    if type(zoneRecord) ~= "table" then
        return false
    end

    if isExcludedAutomaticCapZone(zoneRecord) == true then
        return false
    end

    local owner = getRecordOwner(zoneRecord)

    if owner == getOwnerContested() then
        return true
    end

    if owner ~= getOwnerRed() then
        return false
    end

    if isStrategicAirbaseZone(zoneRecord) == true then
        return true
    end

    if isSecondaryAirbaseZone(zoneRecord) == true then
        return true
    end

    return false
end

local function buildCapZoneKey(side, zoneRecord)
    local zoneKey = "UNKNOWN_ZONE"

    if type(zoneRecord) == "table" and zoneRecord.key ~= nil then
        zoneKey = zoneRecord.key
    elseif type(zoneRecord) == "table" and zoneRecord.name ~= nil then
        zoneKey = normalizeName(zoneRecord.name)
    end

    return "CAP_ZONE_" .. tostring(side or "UNKNOWN") .. "_" .. tostring(zoneKey)
end

local function buildCapSignature(side, zoneKey)
    return tostring(side or "UNKNOWN") .. "::" .. tostring(zoneKey or "UNKNOWN_ZONE")
end

local function createCapId()
    local state = ensureAiState()

    if state == nil then
        return nil
    end

    state.AI.lastCapId = (state.AI.lastCapId or 0) + 1

    return state.AI.lastCapId
end

local function buildCapKey(capId)
    return "CAP_" .. tostring(capId)
end

local function getCapContainerForStatus(state, status)
    if status == CapManager.status.REQUESTED then
        return state.AI.capRequests
    end

    if status == CapManager.status.ACTIVE then
        return state.AI.activeCaps
    end

    if status == CapManager.status.COMPLETED then
        return state.AI.completedCaps
    end

    if status == CapManager.status.FAILED then
        return state.AI.failedCaps
    end

    if status == CapManager.status.CANCELLED then
        return state.AI.cancelledCaps
    end

    return state.AI.capRequests
end

local function removeCapFromAllContainers(state, capKey)
    if state == nil or state.AI == nil or capKey == nil then
        return false
    end

    state.AI.capRequests[capKey] = nil
    state.AI.activeCaps[capKey] = nil
    state.AI.completedCaps[capKey] = nil
    state.AI.failedCaps[capKey] = nil
    state.AI.cancelledCaps[capKey] = nil

    return true
end

local function capRequestExists(signature)
    if signature == nil then
        return false
    end

    local state = ensureAiState()

    if state == nil then
        return false
    end

    for _, capRecord in pairs(state.AI.capRequests) do
        if capRecord.signature == signature then
            return true
        end
    end

    for _, capRecord in pairs(state.AI.activeCaps) do
        if capRecord.signature == signature then
            return true
        end
    end

    return false
end

local function activeCapCountForZone(zoneKey, side)
    local state = ensureAiState()

    if state == nil then
        return 0
    end

    local count = 0

    for _, capRecord in pairs(state.AI.activeCaps) do
        if capRecord.zoneKey == zoneKey then
            if side == nil or capRecord.side == side then
                count = count + 1
            end
        end
    end

    for _, capRecord in pairs(state.AI.capRequests) do
        if capRecord.zoneKey == zoneKey then
            if side == nil or capRecord.side == side then
                count = count + 1
            end
        end
    end

    return count
end

local function countCapRecordsBySide(container, side)
    if type(container) ~= "table" then
        return 0
    end

    local count = 0

    for _, capRecord in pairs(container) do
        if capRecord.side == side then
            count = count + 1
        end
    end

    return count
end

local function updateStatistics()
    local state = ensureAiState()

    if state == nil then
        return false
    end

    state.AI.capStatistics = {
        candidates = countTableKeys(state.AI.capZoneCandidates),
        zones = countTableKeys(state.AI.capZones),
        requested = countTableKeys(state.AI.capRequests),
        active = countTableKeys(state.AI.activeCaps),
        completed = countTableKeys(state.AI.completedCaps),
        failed = countTableKeys(state.AI.failedCaps),
        cancelled = countTableKeys(state.AI.cancelledCaps),
        blueZones = countCapRecordsBySide(state.AI.capZones, CapManager.sides.BLUE),
        redZones = countCapRecordsBySide(state.AI.capZones, CapManager.sides.RED),
        blueRequests = countCapRecordsBySide(state.AI.capRequests, CapManager.sides.BLUE),
        redRequests = countCapRecordsBySide(state.AI.capRequests, CapManager.sides.RED)
    }

    state.AI.lastUpdate = getCurrentTime()
    CapManager.lastUpdateTime = state.AI.lastUpdate

    return true
end

local function updateReactionState()
    local state = ensureAiState()

    if state == nil then
        return false
    end

    local missionState = getMissionState()
    local activeMissions = 0

    if missionState ~= nil and missionState.active ~= nil then
        activeMissions = countTableKeys(missionState.active)
    end

    local activeCaps = countTableKeys(state.AI.activeCaps)
    local requestedCaps = countTableKeys(state.AI.capRequests)
    local totalAirReactions = activeCaps + requestedCaps

    if activeCaps > 0 then
        state.AI.reactionState = "AIR_REACTION_ACTIVE"
    elseif requestedCaps > 0 then
        state.AI.reactionState = "AIR_REACTION_REQUESTED"
    elseif activeMissions > 0 then
        state.AI.reactionState = "MISSION_MONITORING"
    else
        state.AI.reactionState = "STANDBY"
    end

    if totalAirReactions >= 10 then
        state.AI.threatLevel = "HIGH"
    elseif totalAirReactions >= 5 then
        state.AI.threatLevel = "MEDIUM"
    elseif totalAirReactions > 0 then
        state.AI.threatLevel = "LOW"
    else
        state.AI.threatLevel = "UNKNOWN"
    end

    return true
end

local function addCapToContainer(capRecord)
    local state = ensureAiState()

    if state == nil then
        return false, "state_unavailable"
    end

    if capRecord == nil or capRecord.key == nil then
        return false, "cap_record_invalid"
    end

    removeCapFromAllContainers(state, capRecord.key)

    local container = getCapContainerForStatus(state, capRecord.status)
    container[capRecord.key] = capRecord

    updateReactionState()
    updateStatistics()
    markDirty("ai_cap_record_changed")

    return true, capRecord
end

local function getCapFromContainer(container, capKeyOrName)
    if type(container) ~= "table" or capKeyOrName == nil then
        return nil
    end

    if container[capKeyOrName] ~= nil then
        return container[capKeyOrName]
    end

    local normalizedSearch = normalizeName(capKeyOrName)

    for _, capRecord in pairs(container) do
        if capRecord.normalizedName == normalizedSearch then
            return capRecord
        end

        if normalizeName(capRecord.name) == normalizedSearch then
            return capRecord
        end
    end

    return nil
end

local function buildCapZoneCandidate(side, zoneRecord, reason)
    if type(zoneRecord) ~= "table" then
        return nil
    end

    local sourceBase = findPreferredBaseForSide(side, zoneRecord)
    local owner = getRecordOwner(zoneRecord)

    local candidate = {
        key = buildCapZoneKey(side, zoneRecord),
        side = side,
        zoneKey = zoneRecord.key,
        zoneName = zoneRecord.name,
        zoneDisplayName = getZoneDisplayName(zoneRecord),
        zoneClass = zoneRecord.zoneClass,
        airbaseClassification = getAirbaseClassification(zoneRecord),
        owner = owner,
        theatreArea = zoneRecord.theatreArea or "UNKNOWN",
        priority = calculateCapPriority(side, zoneRecord),
        strategicRelevance = getZoneStrategicRelevance(zoneRecord),
        radius = getCapRadius(side, zoneRecord),
        center = copyValue(zoneRecord.center),
        sourceBaseKey = sourceBase and sourceBase.key or nil,
        sourceBaseName = sourceBase and sourceBase.name or nil,
        maxActiveCaps = CapManager.defaultMaxActivePerZone,
        reason = reason or "classified_zone_cap_candidate",
        source = "CLASSIFIED_ZONE_FACTORY"
    }

    return candidate
end

local function collectCapZoneCandidates()
    local candidates = {}

    for _, zoneRecord in pairs(getZoneRegistry()) do
        if shouldCreateBlueCapCandidate(zoneRecord) == true then
            local candidate = buildCapZoneCandidate(CapManager.sides.BLUE, zoneRecord, "blue_defensive_cap_candidate")

            if candidate ~= nil then
                table.insert(candidates, candidate)
            end
        end

        if shouldCreateRedCapCandidate(zoneRecord) == true then
            local candidate = buildCapZoneCandidate(CapManager.sides.RED, zoneRecord, "red_defensive_cap_candidate")

            if candidate ~= nil then
                table.insert(candidates, candidate)
            end
        end
    end

    table.sort(candidates, function(left, right)
        if left.priority ~= right.priority then
            return left.priority > right.priority
        end

        if left.strategicRelevance ~= right.strategicRelevance then
            return left.strategicRelevance > right.strategicRelevance
        end

        if left.side ~= right.side then
            return left.side < right.side
        end

        return tostring(left.zoneDisplayName or left.zoneKey) < tostring(right.zoneDisplayName or right.zoneKey)
    end)

    return candidates
end

local function buildCapZoneRecord(candidate)
    if type(candidate) ~= "table" then
        return nil
    end

    return {
        key = candidate.key,
        name = candidate.key,
        normalizedName = normalizeName(candidate.key),

        side = candidate.side,
        status = CapManager.status.REGISTERED,

        zoneKey = candidate.zoneKey,
        zoneName = candidate.zoneName,
        zoneDisplayName = candidate.zoneDisplayName,
        zoneClass = candidate.zoneClass,
        airbaseClassification = candidate.airbaseClassification,
        theatreArea = candidate.theatreArea,
        owner = candidate.owner,

        sourceBaseKey = candidate.sourceBaseKey,
        sourceBaseName = candidate.sourceBaseName,

        priority = candidate.priority,
        strategicRelevance = candidate.strategicRelevance,
        radius = candidate.radius,
        center = copyValue(candidate.center),
        maxActiveCaps = candidate.maxActiveCaps or CapManager.defaultMaxActivePerZone,

        canSpawn = false,
        spawnSystem = "MOOSE_PENDING",
        spawnedGroupName = nil,
        mooseDispatcherName = nil,
        mooseSpawnAlias = nil,
        templateGroupName = nil,

        createdAt = getCurrentTime(),
        updatedAt = getCurrentTime(),
        source = candidate.source or "CAP_MANAGER",
        reason = candidate.reason
    }
end

local function registerCapZoneRecord(capZoneRecord)
    local state = ensureAiState()

    if state == nil then
        return false, "state_unavailable"
    end

    if capZoneRecord == nil or capZoneRecord.key == nil then
        return false, "cap_zone_invalid"
    end

    if state.AI.capZones[capZoneRecord.key] ~= nil then
        return false, "cap_zone_already_registered"
    end

    state.AI.capZones[capZoneRecord.key] = capZoneRecord

    updateStatistics()
    markDirty("ai_cap_zone_registered")

    logDebug(
        "CAP zone registered: "
        .. tostring(capZoneRecord.key)
        .. " side="
        .. tostring(capZoneRecord.side)
        .. " class="
        .. tostring(capZoneRecord.zoneClass)
        .. " priority="
        .. tostring(capZoneRecord.priority)
    )

    return true, capZoneRecord
end

local function getSortedCapZones()
    local state = ensureAiState()
    local sorted = {}

    if state == nil then
        return sorted
    end

    for _, capZoneRecord in pairs(state.AI.capZones) do
        table.insert(sorted, capZoneRecord)
    end

    table.sort(sorted, function(left, right)
        if left.priority ~= right.priority then
            return left.priority > right.priority
        end

        if (left.strategicRelevance or 0) ~= (right.strategicRelevance or 0) then
            return (left.strategicRelevance or 0) > (right.strategicRelevance or 0)
        end

        if left.side ~= right.side then
            return left.side < right.side
        end

        return tostring(left.zoneDisplayName or left.zoneName or left.zoneKey)
            < tostring(right.zoneDisplayName or right.zoneName or right.zoneKey)
    end)

    return sorted
end

local function createCapRequestFromZone(capZoneRecord, reason)
    if capZoneRecord == nil then
        return false, "cap_zone_missing"
    end

    if activeCapCountForZone(capZoneRecord.zoneKey, capZoneRecord.side) >= (capZoneRecord.maxActiveCaps or 1) then
        return false, "cap_limit_reached"
    end

    local signature = buildCapSignature(capZoneRecord.side, capZoneRecord.zoneKey)

    if capRequestExists(signature) == true then
        return false, "cap_already_requested"
    end

    return CapManager.requestCap(capZoneRecord.side, capZoneRecord.zoneKey, {
        name = "CAP " .. tostring(capZoneRecord.side) .. " - " .. tostring(capZoneRecord.zoneDisplayName or capZoneRecord.zoneName or capZoneRecord.zoneKey),
        sourceBase = capZoneRecord.sourceBaseKey,
        priority = capZoneRecord.priority,
        radius = capZoneRecord.radius,
        center = capZoneRecord.center,
        reason = reason or "cap_zone_need",
        source = "CAP_ZONE",
        zoneClass = capZoneRecord.zoneClass,
        airbaseClassification = capZoneRecord.airbaseClassification,
        strategicRelevance = capZoneRecord.strategicRelevance,
        canSpawn = false,
        spawnSystem = "MOOSE_PENDING",
        notes = "CAP request prepared by Theater Command. Real MOOSE spawning is not active yet."
    })
end

function CapManager.registerCapZone(zoneKeyOrName, side, options)
    if isValidSide(side) ~= true then
        return false, "invalid_side"
    end

    local zoneRecord = findZoneByKeyOrName(zoneKeyOrName)

    if zoneRecord == nil then
        return false, "zone_not_found"
    end

    local candidate = buildCapZoneCandidate(side, zoneRecord, "manual_cap_zone_registration")

    if candidate == nil then
        return false, "candidate_failed"
    end

    if options ~= nil then
        if options.priority ~= nil then
            candidate.priority = options.priority
        end

        if options.radius ~= nil then
            candidate.radius = options.radius
        end

        if options.sourceBase ~= nil then
            local sourceBase = findBaseByKeyOrName(options.sourceBase)

            candidate.sourceBaseKey = sourceBase and sourceBase.key or options.sourceBase
            candidate.sourceBaseName = sourceBase and sourceBase.name or nil
        end

        if options.maxActiveCaps ~= nil then
            candidate.maxActiveCaps = options.maxActiveCaps
        end

        if options.notes ~= nil then
            candidate.notes = options.notes
        end
    end

    local capZoneRecord = buildCapZoneRecord(candidate)

    return registerCapZoneRecord(capZoneRecord)
end

function CapManager.autoRegisterCapZones(options)
    local state = ensureAiState()

    if state == nil then
        return false, "state_unavailable"
    end

    local registerOptions = options or {}
    local limit = registerOptions.limit or CapManager.defaultCapZoneLimit

    local candidates = collectCapZoneCandidates()
    local created = 0
    local skipped = 0

    state.AI.capZoneCandidates = {}

    for index, candidate in ipairs(candidates) do
        state.AI.capZoneCandidates[candidate.key] = {
            rank = index,
            key = candidate.key,
            side = candidate.side,
            zoneKey = candidate.zoneKey,
            zoneName = candidate.zoneName,
            zoneClass = candidate.zoneClass,
            airbaseClassification = candidate.airbaseClassification,
            owner = candidate.owner,
            theatreArea = candidate.theatreArea,
            priority = candidate.priority,
            strategicRelevance = candidate.strategicRelevance,
            reason = candidate.reason
        }
    end

    CapManager.lastCandidateCount = #candidates

    logInfo(
        "CAP zone candidate summary: candidates="
        .. tostring(#candidates)
        .. ", registrationLimit="
        .. tostring(limit)
    )

    for _, candidate in ipairs(candidates) do
        if created >= limit then
            skipped = skipped + 1
        else
            local capZoneRecord = buildCapZoneRecord(candidate)
            local success = registerCapZoneRecord(capZoneRecord)

            if success == true then
                created = created + 1
            else
                skipped = skipped + 1
            end
        end
    end

    CapManager.lastRegisteredCount = created
    CapManager.lastSkippedCount = skipped

    updateStatistics()

    logInfo(
        "CAP zones auto-registered: "
        .. tostring(created)
        .. " from "
        .. tostring(#candidates)
        .. " candidates (skipped="
        .. tostring(skipped)
        .. ")"
    )

    return true, created
end

function CapManager.requestCap(side, zoneKeyOrName, options)
    local state = ensureAiState()

    if state == nil then
        return false, "state_unavailable"
    end

    if isValidSide(side) ~= true then
        return false, "invalid_side"
    end

    local capOptions = options or {}
    local zoneRecord = findZoneByKeyOrName(zoneKeyOrName)

    if zoneRecord == nil then
        return false, "zone_not_found"
    end

    local signature = buildCapSignature(side, zoneRecord.key)

    if capRequestExists(signature) == true then
        return false, "cap_already_requested"
    end

    local capId = createCapId()

    if capId == nil then
        return false, "cap_id_failed"
    end

    local sourceBase = nil

    if capOptions.sourceBase ~= nil then
        sourceBase = findBaseByKeyOrName(capOptions.sourceBase)
    end

    if sourceBase == nil then
        sourceBase = findPreferredBaseForSide(side, zoneRecord)
    end

    local capKey = buildCapKey(capId)
    local capName = capOptions.name or ("CAP " .. tostring(side) .. " - " .. tostring(getZoneDisplayName(zoneRecord)))

    local capRecord = {
        id = capId,
        key = capKey,
        name = capName,
        normalizedName = normalizeName(capName),

        side = side,
        status = CapManager.status.REQUESTED,

        zoneKey = zoneRecord.key,
        zoneName = zoneRecord.name,
        zoneDisplayName = getZoneDisplayName(zoneRecord),
        zoneClass = capOptions.zoneClass or zoneRecord.zoneClass,
        airbaseClassification = capOptions.airbaseClassification or getAirbaseClassification(zoneRecord),
        theatreArea = zoneRecord.theatreArea,
        owner = getRecordOwner(zoneRecord),

        sourceBaseKey = sourceBase and sourceBase.key or capOptions.sourceBase,
        sourceBaseName = sourceBase and sourceBase.name or nil,

        priority = capOptions.priority or calculateCapPriority(side, zoneRecord),
        strategicRelevance = capOptions.strategicRelevance or getZoneStrategicRelevance(zoneRecord),
        radius = capOptions.radius or getCapRadius(side, zoneRecord),
        center = copyValue(capOptions.center or zoneRecord.center),

        signature = signature,
        reason = capOptions.reason or "manual_cap_request",
        source = capOptions.source or "CAP_MANAGER",

        canSpawn = capOptions.canSpawn == true,
        spawnSystem = capOptions.spawnSystem or "MOOSE_PENDING",
        spawnedGroupName = nil,
        mooseDispatcherName = capOptions.mooseDispatcherName,
        mooseSpawnAlias = capOptions.mooseSpawnAlias,
        templateGroupName = capOptions.templateGroupName,

        createdAt = getCurrentTime(),
        activatedAt = nil,
        completedAt = nil,
        failedAt = nil,
        cancelledAt = nil,
        updatedAt = getCurrentTime(),

        notes = capOptions.notes or "CAP request is state-only. Real MOOSE spawning is pending."
    }

    local added, result = addCapToContainer(capRecord)

    if added ~= true then
        return false, result
    end

    logInfo(
        "CAP requested: "
        .. tostring(capRecord.name)
        .. " priority="
        .. tostring(capRecord.priority)
        .. " spawn="
        .. tostring(capRecord.spawnSystem)
    )

    return true, capRecord
end

function CapManager.evaluateCapNeeds(options)
    local state = ensureAiState()

    if state == nil then
        return false, "state_unavailable"
    end

    local evaluateOptions = options or {}
    local limit = evaluateOptions.limit or CapManager.defaultRequestLimit
    local requested = 0
    local skipped = 0

    logInfo("CAP need evaluation started")

    local sortedCapZones = getSortedCapZones()

    for _, capZoneRecord in ipairs(sortedCapZones) do
        if requested >= limit then
            skipped = skipped + 1
        else
            if activeCapCountForZone(capZoneRecord.zoneKey, capZoneRecord.side) < (capZoneRecord.maxActiveCaps or 1) then
                local success = createCapRequestFromZone(capZoneRecord, "cap_need_evaluation")

                if success == true then
                    requested = requested + 1
                else
                    skipped = skipped + 1
                end
            else
                skipped = skipped + 1
            end
        end
    end

    CapManager.lastRequestedCount = requested

    updateReactionState()
    updateStatistics()
    markDirty("ai_cap_needs_evaluated")

    logInfo(
        "CAP need evaluation completed: "
        .. tostring(requested)
        .. " CAPs requested (skipped="
        .. tostring(skipped)
        .. ")"
    )

    return true, requested
end

function CapManager.reactToActiveMissions(options)
    local state = ensureAiState()

    if state == nil then
        return false, "state_unavailable"
    end

    local missionState = getMissionState()

    if missionState == nil or missionState.active == nil then
        return true, 0
    end

    local reactionOptions = options or {}
    local limit = reactionOptions.limit or CapManager.defaultRequestLimit
    local requested = 0

    for _, missionRecord in pairs(missionState.active) do
        if requested >= limit then
            break
        end

        if missionRecord.targetZoneKey ~= nil then
            local side = CapManager.sides.RED

            if missionRecord.owner == getOwnerRed() then
                side = CapManager.sides.BLUE
            end

            local success = CapManager.requestCap(side, missionRecord.targetZoneKey, {
                name = "CAP reaction - " .. tostring(missionRecord.key),
                sourceBase = nil,
                priority = CapManager.defaultPriorities.MISSION_REACTION,
                reason = "active_mission_reaction",
                source = "MISSION_REACTION",
                canSpawn = false,
                spawnSystem = "MOOSE_PENDING",
                notes = "Generated in reaction to active mission " .. tostring(missionRecord.key)
            })

            if success == true then
                requested = requested + 1
            end
        end
    end

    updateReactionState()
    updateStatistics()

    return true, requested
end

function CapManager.getCap(capKeyOrName)
    local state = ensureAiState()

    if state == nil then
        return nil
    end

    local capRecord = getCapFromContainer(state.AI.capRequests, capKeyOrName)

    if capRecord ~= nil then
        return capRecord
    end

    capRecord = getCapFromContainer(state.AI.activeCaps, capKeyOrName)

    if capRecord ~= nil then
        return capRecord
    end

    capRecord = getCapFromContainer(state.AI.completedCaps, capKeyOrName)

    if capRecord ~= nil then
        return capRecord
    end

    capRecord = getCapFromContainer(state.AI.failedCaps, capKeyOrName)

    if capRecord ~= nil then
        return capRecord
    end

    return getCapFromContainer(state.AI.cancelledCaps, capKeyOrName)
end

function CapManager.setCapStatus(capKeyOrName, status, reason)
    local state = ensureAiState()

    if state == nil then
        return false, "state_unavailable"
    end

    if isValidStatus(status) ~= true then
        return false, "invalid_status"
    end

    local capRecord = CapManager.getCap(capKeyOrName)

    if capRecord == nil then
        return false, "cap_not_found"
    end

    capRecord.previousStatus = capRecord.status
    capRecord.status = status
    capRecord.statusReason = reason or "manual_status_update"
    capRecord.updatedAt = getCurrentTime()

    if status == CapManager.status.ACTIVE then
        capRecord.activatedAt = capRecord.activatedAt or getCurrentTime()
    elseif status == CapManager.status.COMPLETED then
        capRecord.completedAt = capRecord.completedAt or getCurrentTime()
    elseif status == CapManager.status.FAILED then
        capRecord.failedAt = capRecord.failedAt or getCurrentTime()
    elseif status == CapManager.status.CANCELLED then
        capRecord.cancelledAt = capRecord.cancelledAt or getCurrentTime()
    end

    addCapToContainer(capRecord)
    updateReactionState()

    logInfo("CAP status changed: " .. tostring(capRecord.key) .. " [" .. tostring(status) .. "]")

    return true, capRecord
end

function CapManager.activateCap(capKeyOrName, spawnedGroupName, reason)
    local capRecord = CapManager.getCap(capKeyOrName)

    if capRecord == nil then
        return false, "cap_not_found"
    end

    capRecord.spawnedGroupName = spawnedGroupName or capRecord.spawnedGroupName
    capRecord.canSpawn = true

    return CapManager.setCapStatus(capRecord.key, CapManager.status.ACTIVE, reason or "cap_activated")
end

function CapManager.completeCap(capKeyOrName, reason)
    return CapManager.setCapStatus(capKeyOrName, CapManager.status.COMPLETED, reason or "cap_completed")
end

function CapManager.failCap(capKeyOrName, reason)
    return CapManager.setCapStatus(capKeyOrName, CapManager.status.FAILED, reason or "cap_failed")
end

function CapManager.cancelCap(capKeyOrName, reason)
    return CapManager.setCapStatus(capKeyOrName, CapManager.status.CANCELLED, reason or "cap_cancelled")
end

function CapManager.clearRequestedCaps()
    local state = ensureAiState()

    if state == nil then
        return false, "state_unavailable"
    end

    state.AI.capRequests = {}

    updateReactionState()
    updateStatistics()
    markDirty("ai_cap_requests_cleared")

    logInfo("CAP requests cleared")

    return true
end

function CapManager.clearCapZones()
    local state = ensureAiState()

    if state == nil then
        return false, "state_unavailable"
    end

    state.AI.capZones = {}
    state.AI.capZoneCandidates = {}

    updateStatistics()
    markDirty("ai_cap_zones_cleared")

    logInfo("CAP zones cleared")

    return true
end

function CapManager.getCapZones()
    local state = ensureAiState()

    if state == nil then
        return {}
    end

    return state.AI.capZones
end

function CapManager.getCapZoneCandidates()
    local state = ensureAiState()

    if state == nil then
        return {}
    end

    return state.AI.capZoneCandidates
end

function CapManager.getRequestedCaps()
    local state = ensureAiState()

    if state == nil then
        return {}
    end

    return state.AI.capRequests
end

function CapManager.getActiveCaps()
    local state = ensureAiState()

    if state == nil then
        return {}
    end

    return state.AI.activeCaps
end

function CapManager.getCompletedCaps()
    local state = ensureAiState()

    if state == nil then
        return {}
    end

    return state.AI.completedCaps
end

function CapManager.getFailedCaps()
    local state = ensureAiState()

    if state == nil then
        return {}
    end

    return state.AI.failedCaps
end

function CapManager.getCancelledCaps()
    local state = ensureAiState()

    if state == nil then
        return {}
    end

    return state.AI.cancelledCaps
end

function CapManager.getCapsBySide(side)
    local result = {}
    local state = ensureAiState()

    if state == nil then
        return result
    end

    local containers = {
        state.AI.capRequests,
        state.AI.activeCaps,
        state.AI.completedCaps,
        state.AI.failedCaps,
        state.AI.cancelledCaps
    }

    for _, container in ipairs(containers) do
        for key, capRecord in pairs(container) do
            if capRecord.side == side then
                result[key] = capRecord
            end
        end
    end

    return result
end

function CapManager.getBlueCaps()
    return CapManager.getCapsBySide(CapManager.sides.BLUE)
end

function CapManager.getRedCaps()
    return CapManager.getCapsBySide(CapManager.sides.RED)
end

function CapManager.getStatistics()
    local state = ensureAiState()

    if state == nil then
        return {}
    end

    updateStatistics()

    return state.AI.capStatistics
end

function CapManager.start()
    if CapManager.started == true and CapManager.finished == true and CapManager.failed ~= true then
        logDebug("AI CAP manager already started")
        return true
    end

    CapManager.started = true
    CapManager.finished = false
    CapManager.failed = false

    logInfo("AI CAP manager started")

    local state = ensureAiState()

    if state == nil then
        CapManager.failed = true
        setModuleStatus("FAILED")
        setFeatureStatus(false)
        logError("AI CAP manager failed: state_unavailable")
        return false
    end

    setFeatureStatus(false)
    setModuleStatus("STARTING")

    state.AI.capZones = {}
    state.AI.capRequests = {}

    local autoRegistered, autoRegisteredResult = CapManager.autoRegisterCapZones({
        limit = CapManager.defaultCapZoneLimit
    })

    if autoRegistered ~= true then
        CapManager.failed = true
        setModuleStatus("FAILED")
        setFeatureStatus(false)
        logError("AI CAP manager failed during auto registration: " .. tostring(autoRegisteredResult))
        return false
    end

    local evaluated, evaluatedResult = CapManager.evaluateCapNeeds({
        limit = CapManager.defaultRequestLimit
    })

    if evaluated ~= true then
        CapManager.failed = true
        setModuleStatus("FAILED")
        setFeatureStatus(false)
        logError("AI CAP manager failed during need evaluation: " .. tostring(evaluatedResult))
        return false
    end

    updateReactionState()
    updateStatistics()

    CapManager.finished = true

    setModuleStatus("READY")
    setFeatureStatus(true)

    logInfo(
        "AI CAP manager ready: zones="
        .. tostring(countTableKeys(state.AI.capZones))
        .. ", requested="
        .. tostring(countTableKeys(state.AI.capRequests))
        .. ", reactionState="
        .. tostring(state.AI.reactionState)
        .. ", threatLevel="
        .. tostring(state.AI.threatLevel)
    )

    return true
end

function CapManager.stop()
    CapManager.started = false
    setModuleStatus("STOPPED")
    logInfo("AI CAP manager stopped")
    return true
end

function CapManager.summary()
    local state = getState()
    local aiState = nil

    if state ~= nil then
        aiState = state.AI
    end

    return {
        name = CapManager.name,
        displayName = CapManager.displayName,
        path = CapManager.path,
        version = CapManager.version,
        loaded = CapManager.loaded,
        started = CapManager.started,
        finished = CapManager.finished,
        failed = CapManager.failed,
        lastUpdateTime = CapManager.lastUpdateTime,
        lastCandidateCount = CapManager.lastCandidateCount,
        lastRegisteredCount = CapManager.lastRegisteredCount,
        lastRequestedCount = CapManager.lastRequestedCount,
        lastSkippedCount = CapManager.lastSkippedCount,
        statistics = aiState and aiState.capStatistics or nil,
        reactionState = aiState and aiState.reactionState or nil,
        threatLevel = aiState and aiState.threatLevel or nil,
        state = aiState
    }
end

TC.AI.CapManager = CapManager
TC.ai.CapManager = CapManager

TC.modules.aiCapManager = {
    name = CapManager.name,
    path = CapManager.path,
    loaded = true,
    version = CapManager.version
}

setModuleStatus("LOADED")
logInfo("Loaded " .. CapManager.path .. " v" .. CapManager.version)

return CapManager
