-- Theater Command DCS
-- File: src/logistics/tc_fob_system.lua
--
-- Purpose:
--   Manage Forward Operating Bases as strategic Theater Command logistics objects.
--
-- Current focus:
--   Logistics Delivery v0.2.0 now creates classified Logistics Hubs from campaign
--   zones. The FOB system must use those hubs and zones as its state basis.
--
-- Version:
--   0.2.0
--
-- Responsibilities:
--   - build FOB candidates from friendly or contested logistics hubs
--   - auto-plan a small number of initial Blue FOBs as state-only objects
--   - keep FOB records linked to zones, bases and logistics hubs
--   - support FOB construction, supply, damage, repair and destruction state
--   - prepare FOB support deliveries through Logistics Delivery
--   - expose FOB state for Mission Generator, AI, F10 UI and Persistence
--
-- Vendor note:
--   CTLD is loaded by the mission, but this file does not directly call CTLD yet.
--   Real CTLD FOB construction will be connected later after CTLD pickup/dropoff
--   zones and template objects exist in the Mission Editor.

TC = TC or {}
TC.modules = TC.modules or {}
TC.Logistics = TC.Logistics or {}
TC.logistics = TC.logistics or TC.Logistics

local FobSystem = {}

FobSystem.name = "tc_fob_system"
FobSystem.displayName = "FOB System"
FobSystem.path = "src/logistics/tc_fob_system.lua"
FobSystem.version = "0.2.0"

FobSystem.loaded = true
FobSystem.started = false
FobSystem.finished = false
FobSystem.failed = false

FobSystem.lastUpdateTime = 0
FobSystem.lastCandidateCount = 0
FobSystem.lastPlannedCount = 0
FobSystem.lastSkippedCount = 0

FobSystem.defaultCandidateLimit = 12
FobSystem.defaultAutoPlanLimit = 2

FobSystem.status = {
    PLANNED = "PLANNED",
    UNDER_CONSTRUCTION = "UNDER_CONSTRUCTION",
    ACTIVE = "ACTIVE",
    DAMAGED = "DAMAGED",
    OUT_OF_SUPPLY = "OUT_OF_SUPPLY",
    DESTROYED = "DESTROYED"
}

FobSystem.candidateStatus = {
    CANDIDATE = "CANDIDATE",
    PLANNED = "PLANNED",
    REJECTED = "REJECTED"
}

FobSystem.hubTypes = {
    MAIN_OPERATING_BASE = "MAIN_OPERATING_BASE",
    STRATEGIC_AIRBASE_HUB = "STRATEGIC_AIRBASE_HUB",
    SECONDARY_AIRBASE_HUB = "SECONDARY_AIRBASE_HUB",
    HELIPORT_HUB = "HELIPORT_HUB",
    FARP_HUB = "FARP_HUB",
    TACTICAL_HUB = "TACTICAL_HUB",
    UNKNOWN_HUB = "UNKNOWN_HUB"
}

FobSystem.zoneClasses = {
    STRATEGIC_AIRBASE_ZONE = "STRATEGIC_AIRBASE_ZONE",
    SECONDARY_AIRBASE_ZONE = "SECONDARY_AIRBASE_ZONE",
    HELIPORT_ZONE = "HELIPORT_ZONE",
    FARP_ZONE = "FARP_ZONE",
    TACTICAL_PAD_ZONE = "TACTICAL_PAD_ZONE",
    MISSION_EDITOR_CAPTURE_ZONE = "MISSION_EDITOR_CAPTURE_ZONE",
    MISSION_EDITOR_ZONE = "MISSION_EDITOR_ZONE",
    UNKNOWN_ZONE = "UNKNOWN_ZONE"
}

FobSystem.airbaseClassifications = {
    STRATEGIC_AIRFIELD = "STRATEGIC_AIRFIELD",
    SECONDARY_AIRFIELD = "SECONDARY_AIRFIELD",
    HELIPORT = "HELIPORT",
    HELIPAD = "HELIPAD",
    MEDICAL_PAD = "MEDICAL_PAD",
    FARP = "FARP",
    TACTICAL_PAD = "TACTICAL_PAD",
    UNKNOWN = "UNKNOWN"
}

FobSystem.defaultValues = {
    supplyLevel = 0,
    fuelLevel = 0,
    ammunitionLevel = 0,
    engineeringLevel = 0,
    airDefenseLevel = 0,
    repairLevel = 0,
    constructionProgress = 0,

    activationSupplyRequired = 50,
    activationConstructionRequired = 100,

    plannedSupplyLevel = 10,
    plannedFuelLevel = 0,
    plannedAmmunitionLevel = 0,
    plannedEngineeringLevel = 10,
    plannedConstructionProgress = 10
}

FobSystem.defaultSupportPayload = {
    supply = 25,
    fuel = 10,
    ammunition = 10,
    engineering = 25
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
    local formatted = "[TC][FOB_SYSTEM] " .. tostring(message)

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
        logger.info("[FobSystem] " .. tostring(message))
        return
    end

    rawLog("INFO", message)
end

local function logWarn(message)
    local logger = getLogger()

    if logger ~= nil and logger.warn ~= nil then
        logger.warn("[FobSystem] " .. tostring(message))
        return
    end

    rawLog("WARN", message)
end

local function logError(message)
    local logger = getLogger()

    if logger ~= nil and logger.error ~= nil then
        logger.error("[FobSystem] " .. tostring(message))
        return
    end

    rawLog("ERROR", message)
end

local function logDebug(message)
    local logger = getLogger()

    if logger ~= nil and logger.debug ~= nil then
        logger.debug("[FobSystem] " .. tostring(message))
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

local function clamp(value, minimum, maximum)
    local utils = getUtils()

    if utils ~= nil and utils.clamp ~= nil then
        return utils.clamp(value, minimum, maximum)
    end

    if type(value) ~= "number" then
        return minimum or 0
    end

    if type(minimum) == "number" and value < minimum then
        return minimum
    end

    if type(maximum) == "number" and value > maximum then
        return maximum
    end

    return value
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

local function isValidStatus(status)
    if status == nil then
        return false
    end

    for _, allowedStatus in pairs(FobSystem.status) do
        if status == allowedStatus then
            return true
        end
    end

    return false
end

local function ensureLogisticsState()
    local state = getState()

    TC.Logistics = TC.Logistics or {}
    TC.logistics = TC.Logistics

    if state == nil then
        return nil
    end

    state.Logistics = state.Logistics or {}
    state.Logistics.enabled = true

    state.Logistics.hubs = state.Logistics.hubs or {}
    state.Logistics.deliveries = state.Logistics.deliveries or {}
    state.Logistics.deliveryHistory = state.Logistics.deliveryHistory or {}
    state.Logistics.fobs = state.Logistics.fobs or {}
    state.Logistics.fobCandidates = state.Logistics.fobCandidates or {}

    state.Logistics.lastFobId = state.Logistics.lastFobId or 0
    state.Logistics.lastFobCandidateBuildTime = state.Logistics.lastFobCandidateBuildTime or 0
    state.Logistics.lastFobUpdateTime = state.Logistics.lastFobUpdateTime or 0

    state.Logistics.fobStatistics = state.Logistics.fobStatistics or {
        total = 0,
        candidates = 0,
        planned = 0,
        underConstruction = 0,
        active = 0,
        damaged = 0,
        outOfSupply = 0,
        destroyed = 0,
        blue = 0,
        red = 0,
        neutral = 0,
        contested = 0,
        unknown = 0
    }

    TC.Logistics.Fobs = state.Logistics.fobs

    return state
end

local function markDirty(reason)
    local state = getState()

    if state ~= nil and state.markDirty ~= nil then
        state.markDirty(reason or "fob_state_changed")
        return true
    end

    if state ~= nil then
        state.Persistence = state.Persistence or {}
        state.Persistence.dirty = true
        state.Persistence.dirtyReason = reason or "fob_state_changed"
        state.Persistence.dirtyAt = getCurrentTime()
        return true
    end

    return false
end

local function setModuleStatus(status)
    local state = getState()

    if state ~= nil and state.setModuleStatus ~= nil then
        state.setModuleStatus("fobSystem", status)
    end
end

local function setFeatureStatus(enabled)
    local state = getState()

    if state ~= nil and state.setFeatureStatus ~= nil then
        state.setFeatureStatus("fobSystem", enabled == true)
    end
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

local function getHubRegistry()
    local state = ensureLogisticsState()

    if state ~= nil and state.Logistics ~= nil and state.Logistics.hubs ~= nil then
        return state.Logistics.hubs
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
        return nil, nil
    end

    if registry[keyOrName] ~= nil then
        return registry[keyOrName], keyOrName
    end

    local normalizedSearch = normalizeName(keyOrName)

    for key, record in pairs(registry) do
        if record.key == keyOrName then
            return record, key
        end

        if record.normalizedName == normalizedSearch then
            return record, key
        end

        if normalizeName(record.name) == normalizedSearch then
            return record, key
        end

        if normalizeName(record.displayName) == normalizedSearch then
            return record, key
        end
    end

    return nil, nil
end

local function getZoneByKeyOrName(keyOrName)
    local zoneRecord = findRecordByKeyOrName(getZoneRegistry(), keyOrName)

    return zoneRecord
end

local function getBaseByKeyOrName(keyOrName)
    local baseRecord = findRecordByKeyOrName(getBaseRegistry(), keyOrName)

    return baseRecord
end

local function getHubByKeyOrName(keyOrName)
    local hubRecord = findRecordByKeyOrName(getHubRegistry(), keyOrName)

    return hubRecord
end

local function getHubByZoneKey(zoneKey)
    if zoneKey == nil then
        return nil
    end

    for _, hubRecord in pairs(getHubRegistry()) do
        if hubRecord.zoneKey == zoneKey then
            return hubRecord
        end
    end

    return nil
end

local function getDelivery(deliveryKey)
    if deliveryKey == nil then
        return nil
    end

    local deliverySystem = getDeliverySystem()

    if deliverySystem ~= nil and deliverySystem.getDelivery ~= nil then
        return deliverySystem.getDelivery(deliveryKey)
    end

    local state = getState()

    if state ~= nil and state.Logistics ~= nil and state.Logistics.deliveries ~= nil then
        return state.Logistics.deliveries[deliveryKey]
    end

    return nil
end

local function getAirbaseClassification(record)
    if type(record) ~= "table" then
        return FobSystem.airbaseClassifications.UNKNOWN
    end

    if record.airbaseClassification ~= nil then
        return record.airbaseClassification
    end

    if record.classification ~= nil then
        return record.classification
    end

    if record.isStrategicAirbaseZone == true then
        return FobSystem.airbaseClassifications.STRATEGIC_AIRFIELD
    end

    if record.isSecondaryAirbaseZone == true then
        return FobSystem.airbaseClassifications.SECONDARY_AIRFIELD
    end

    if record.isHeliportZone == true then
        return FobSystem.airbaseClassifications.HELIPORT
    end

    if record.isFarpZone == true then
        return FobSystem.airbaseClassifications.FARP
    end

    if record.isTacticalPadZone == true then
        return FobSystem.airbaseClassifications.TACTICAL_PAD
    end

    return FobSystem.airbaseClassifications.UNKNOWN
end

local function getZoneClass(record)
    if type(record) ~= "table" then
        return FobSystem.zoneClasses.UNKNOWN_ZONE
    end

    return record.zoneClass or record.recommendedZoneClass or FobSystem.zoneClasses.UNKNOWN_ZONE
end

local function isExcludedFobCandidateZone(zoneRecord)
    local classification = getAirbaseClassification(zoneRecord)
    local zoneClass = getZoneClass(zoneRecord)

    if classification == FobSystem.airbaseClassifications.HELIPAD then
        return true
    end

    if classification == FobSystem.airbaseClassifications.MEDICAL_PAD then
        return true
    end

    if classification == FobSystem.airbaseClassifications.UNKNOWN then
        return true
    end

    if zoneClass == FobSystem.zoneClasses.UNKNOWN_ZONE then
        return true
    end

    return false
end

local function isUsefulFobCandidateZone(zoneRecord)
    if type(zoneRecord) ~= "table" then
        return false
    end

    if isExcludedFobCandidateZone(zoneRecord) == true then
        return false
    end

    if zoneRecord.isStartBaseZone == true then
        return false
    end

    local owner = getRecordOwner(zoneRecord)

    if owner ~= getOwnerBlue() and owner ~= getOwnerContested() then
        return false
    end

    if zoneRecord.isLogisticsZone == true then
        return true
    end

    local zoneClass = getZoneClass(zoneRecord)

    if zoneClass == FobSystem.zoneClasses.SECONDARY_AIRBASE_ZONE then
        return true
    end

    if zoneClass == FobSystem.zoneClasses.HELIPORT_ZONE then
        return true
    end

    if zoneClass == FobSystem.zoneClasses.FARP_ZONE then
        return true
    end

    if zoneClass == FobSystem.zoneClasses.TACTICAL_PAD_ZONE then
        return true
    end

    return false
end

local function getFobCandidatePriority(zoneRecord, hubRecord)
    local priority = 0

    if zoneRecord ~= nil and type(zoneRecord.strategicRelevance) == "number" then
        priority = priority + math.floor(zoneRecord.strategicRelevance / 2)
    end

    if hubRecord ~= nil and type(hubRecord.priority) == "number" then
        priority = priority + math.floor(hubRecord.priority / 2)
    end

    local zoneClass = getZoneClass(zoneRecord)

    if zoneClass == FobSystem.zoneClasses.SECONDARY_AIRBASE_ZONE then
        priority = priority + 30
    elseif zoneClass == FobSystem.zoneClasses.HELIPORT_ZONE then
        priority = priority + 25
    elseif zoneClass == FobSystem.zoneClasses.FARP_ZONE then
        priority = priority + 25
    elseif zoneClass == FobSystem.zoneClasses.TACTICAL_PAD_ZONE then
        priority = priority + 20
    elseif zoneClass == FobSystem.zoneClasses.STRATEGIC_AIRBASE_ZONE then
        priority = priority + 10
    end

    local owner = getRecordOwner(zoneRecord)

    if owner == getOwnerContested() then
        priority = priority + 20
    elseif owner == getOwnerBlue() then
        priority = priority + 10
    end

    return priority
end

local function createFobId()
    local state = ensureLogisticsState()

    if state == nil then
        return nil
    end

    state.Logistics.lastFobId = (state.Logistics.lastFobId or 0) + 1

    return state.Logistics.lastFobId
end

local function buildFobKey(fobId)
    return "FOB_" .. tostring(fobId)
end

local function buildCandidateKey(zoneRecord)
    local name = "UNKNOWN_ZONE"

    if type(zoneRecord) == "table" then
        name = zoneRecord.linkedAirbaseName
            or zoneRecord.displayName
            or zoneRecord.name
            or zoneRecord.key
            or "UNKNOWN_ZONE"
    end

    return "FOB_CANDIDATE_" .. normalizeName(name)
end

local function findContainingZone(point)
    if type(point) ~= "table" then
        return nil
    end

    if TC.World ~= nil and TC.World.ZoneFactory ~= nil and TC.World.ZoneFactory.findContainingZone ~= nil then
        local zoneRecord = TC.World.ZoneFactory.findContainingZone(point)

        if zoneRecord ~= nil then
            return zoneRecord
        end
    end

    return nil
end

local function resolveZoneBaseHub(options)
    local fobOptions = options or {}

    local targetZone = nil
    local targetBase = nil
    local targetHub = nil

    if fobOptions.linkedZone ~= nil then
        targetZone = getZoneByKeyOrName(fobOptions.linkedZone)
    end

    if fobOptions.linkedZoneKey ~= nil and targetZone == nil then
        targetZone = getZoneByKeyOrName(fobOptions.linkedZoneKey)
    end

    if fobOptions.linkedBase ~= nil then
        targetBase = getBaseByKeyOrName(fobOptions.linkedBase)
    end

    if fobOptions.linkedBaseKey ~= nil and targetBase == nil then
        targetBase = getBaseByKeyOrName(fobOptions.linkedBaseKey)
    end

    if fobOptions.linkedHub ~= nil then
        targetHub = getHubByKeyOrName(fobOptions.linkedHub)
    end

    if fobOptions.linkedHubKey ~= nil and targetHub == nil then
        targetHub = getHubByKeyOrName(fobOptions.linkedHubKey)
    end

    if targetZone == nil and type(fobOptions.position) == "table" then
        targetZone = findContainingZone(fobOptions.position)
    end

    if targetZone ~= nil and targetBase == nil and targetZone.linkedAirbaseKey ~= nil then
        targetBase = getBaseByKeyOrName(targetZone.linkedAirbaseKey)
    end

    if targetZone ~= nil and targetHub == nil then
        targetHub = getHubByZoneKey(targetZone.key)
    end

    return targetZone, targetBase, targetHub
end

local function addOwnerCount(statistics, owner)
    if owner == getOwnerBlue() then
        statistics.blue = statistics.blue + 1
    elseif owner == getOwnerRed() then
        statistics.red = statistics.red + 1
    elseif owner == getOwnerNeutral() then
        statistics.neutral = statistics.neutral + 1
    elseif owner == getOwnerContested() then
        statistics.contested = statistics.contested + 1
    else
        statistics.unknown = statistics.unknown + 1
    end
end

local function updateStatistics()
    local state = ensureLogisticsState()

    if state == nil then
        return false
    end

    local statistics = {
        total = 0,
        candidates = countTableKeys(state.Logistics.fobCandidates),
        planned = 0,
        underConstruction = 0,
        active = 0,
        damaged = 0,
        outOfSupply = 0,
        destroyed = 0,
        blue = 0,
        red = 0,
        neutral = 0,
        contested = 0,
        unknown = 0
    }

    for _, fobRecord in pairs(state.Logistics.fobs) do
        statistics.total = statistics.total + 1
        addOwnerCount(statistics, fobRecord.owner)

        if fobRecord.status == FobSystem.status.PLANNED then
            statistics.planned = statistics.planned + 1
        elseif fobRecord.status == FobSystem.status.UNDER_CONSTRUCTION then
            statistics.underConstruction = statistics.underConstruction + 1
        elseif fobRecord.status == FobSystem.status.ACTIVE then
            statistics.active = statistics.active + 1
        elseif fobRecord.status == FobSystem.status.DAMAGED then
            statistics.damaged = statistics.damaged + 1
        elseif fobRecord.status == FobSystem.status.OUT_OF_SUPPLY then
            statistics.outOfSupply = statistics.outOfSupply + 1
        elseif fobRecord.status == FobSystem.status.DESTROYED then
            statistics.destroyed = statistics.destroyed + 1
        end
    end

    state.Logistics.fobStatistics = statistics
    state.Logistics.lastFobUpdateTime = getCurrentTime()

    FobSystem.lastUpdateTime = state.Logistics.lastFobUpdateTime

    return true
end

local function updateLinkedZoneFobData(fobRecord)
    if fobRecord == nil or fobRecord.linkedZoneKey == nil then
        return false
    end

    local zoneRecord = getZoneByKeyOrName(fobRecord.linkedZoneKey)

    if zoneRecord == nil then
        return false
    end

    zoneRecord.fob = zoneRecord.fob or {}
    zoneRecord.fob.key = fobRecord.key
    zoneRecord.fob.name = fobRecord.name
    zoneRecord.fob.status = fobRecord.status
    zoneRecord.fob.owner = fobRecord.owner
    zoneRecord.fob.linkedHubKey = fobRecord.linkedHubKey
    zoneRecord.fob.supplyLevel = fobRecord.supplyLevel
    zoneRecord.fob.fuelLevel = fobRecord.fuelLevel
    zoneRecord.fob.ammunitionLevel = fobRecord.ammunitionLevel
    zoneRecord.fob.engineeringLevel = fobRecord.engineeringLevel
    zoneRecord.fob.constructionProgress = fobRecord.constructionProgress
    zoneRecord.fob.updatedAt = getCurrentTime()
    zoneRecord.updatedAt = getCurrentTime()

    local state = getState()

    if state ~= nil and state.Zones ~= nil and state.Zones.registry ~= nil and zoneRecord.key ~= nil then
        state.Zones.registry[zoneRecord.key] = zoneRecord
    end

    if TC.World ~= nil and TC.World.Zones ~= nil and zoneRecord.key ~= nil then
        TC.World.Zones[zoneRecord.key] = zoneRecord
    end

    return true
end

local function updateLinkedBaseFobData(fobRecord)
    if fobRecord == nil or fobRecord.linkedBaseKey == nil then
        return false
    end

    local baseRecord = getBaseByKeyOrName(fobRecord.linkedBaseKey)

    if baseRecord == nil then
        return false
    end

    baseRecord.fobs = baseRecord.fobs or {}
    baseRecord.fobs[fobRecord.key] = {
        key = fobRecord.key,
        name = fobRecord.name,
        status = fobRecord.status,
        owner = fobRecord.owner,
        linkedHubKey = fobRecord.linkedHubKey,
        updatedAt = getCurrentTime()
    }

    local state = getState()

    if state ~= nil and state.Bases ~= nil and state.Bases.registry ~= nil and baseRecord.key ~= nil then
        state.Bases.registry[baseRecord.key] = baseRecord
    end

    if TC.World ~= nil and TC.World.Airbases ~= nil and baseRecord.key ~= nil then
        TC.World.Airbases[baseRecord.key] = baseRecord
    end

    return true
end

local function updateLinkedHubFobData(fobRecord)
    if fobRecord == nil or fobRecord.linkedHubKey == nil then
        return false
    end

    local hubRecord = getHubByKeyOrName(fobRecord.linkedHubKey)

    if hubRecord == nil then
        return false
    end

    hubRecord.fobs = hubRecord.fobs or {}
    hubRecord.fobs[fobRecord.key] = {
        key = fobRecord.key,
        name = fobRecord.name,
        status = fobRecord.status,
        owner = fobRecord.owner,
        constructionProgress = fobRecord.constructionProgress,
        supplyLevel = fobRecord.supplyLevel,
        updatedAt = getCurrentTime()
    }

    hubRecord.updatedAt = getCurrentTime()

    local state = ensureLogisticsState()

    if state ~= nil and state.Logistics ~= nil and state.Logistics.hubs ~= nil and hubRecord.key ~= nil then
        state.Logistics.hubs[hubRecord.key] = hubRecord
    end

    return true
end

local function syncFob(fobRecord)
    if fobRecord == nil or fobRecord.key == nil then
        return false
    end

    local state = ensureLogisticsState()

    if state == nil then
        return false
    end

    state.Logistics.fobs[fobRecord.key] = fobRecord

    TC.Logistics.Fobs = TC.Logistics.Fobs or {}
    TC.Logistics.Fobs[fobRecord.key] = fobRecord

    updateLinkedZoneFobData(fobRecord)
    updateLinkedBaseFobData(fobRecord)
    updateLinkedHubFobData(fobRecord)
    updateStatistics()

    return true
end

local function canActivateFob(fobRecord)
    if fobRecord == nil then
        return false
    end

    if fobRecord.status == FobSystem.status.DESTROYED then
        return false
    end

    if (fobRecord.constructionProgress or 0) < FobSystem.defaultValues.activationConstructionRequired then
        return false
    end

    if (fobRecord.supplyLevel or 0) < FobSystem.defaultValues.activationSupplyRequired then
        return false
    end

    return true
end

local function maybeUpdateStatusFromResources(fobRecord)
    if fobRecord == nil then
        return nil
    end

    if fobRecord.status == FobSystem.status.DESTROYED then
        return fobRecord
    end

    if canActivateFob(fobRecord) == true then
        fobRecord.status = FobSystem.status.ACTIVE
        fobRecord.activatedAt = fobRecord.activatedAt or getCurrentTime()
        return fobRecord
    end

    if (fobRecord.constructionProgress or 0) > 0 then
        if fobRecord.status == FobSystem.status.PLANNED then
            fobRecord.status = FobSystem.status.UNDER_CONSTRUCTION
        end
    end

    if (fobRecord.supplyLevel or 0) <= 0 and fobRecord.status == FobSystem.status.ACTIVE then
        fobRecord.status = FobSystem.status.OUT_OF_SUPPLY
    end

    return fobRecord
end

local function getDeliveryPayload(deliveryRecord)
    if type(deliveryRecord) ~= "table" then
        return {}
    end

    if type(deliveryRecord.payload) == "table" then
        return deliveryRecord.payload
    end

    if type(deliveryRecord.effect) == "table" then
        return deliveryRecord.effect
    end

    return {}
end

local function applyPayloadToFob(fobRecord, payload)
    if fobRecord == nil or type(payload) ~= "table" then
        return false, "invalid_payload"
    end

    fobRecord.supplyLevel = clamp((fobRecord.supplyLevel or 0) + (payload.supply or 0), 0, 100)
    fobRecord.fuelLevel = clamp((fobRecord.fuelLevel or 0) + (payload.fuel or 0), 0, 100)
    fobRecord.ammunitionLevel = clamp((fobRecord.ammunitionLevel or 0) + (payload.ammunition or 0), 0, 100)
    fobRecord.engineeringLevel = clamp((fobRecord.engineeringLevel or 0) + (payload.engineering or 0), 0, 100)
    fobRecord.airDefenseLevel = clamp((fobRecord.airDefenseLevel or 0) + (payload.airDefense or 0), 0, 10)
    fobRecord.repairLevel = clamp((fobRecord.repairLevel or 0) + (payload.repair or 0), 0, 100)

    if payload.fobConstruction ~= nil then
        fobRecord.constructionProgress = clamp(
            (fobRecord.constructionProgress or 0) + (payload.fobConstruction * 50),
            0,
            100
        )
    end

    if payload.engineering ~= nil and payload.engineering > 0 then
        fobRecord.constructionProgress = clamp(
            (fobRecord.constructionProgress or 0) + payload.engineering,
            0,
            100
        )
    end

    fobRecord.updatedAt = getCurrentTime()

    maybeUpdateStatusFromResources(fobRecord)

    return true, fobRecord
end

local function fobExistsForZone(zoneKey)
    if zoneKey == nil then
        return false
    end

    local state = ensureLogisticsState()

    if state == nil then
        return false
    end

    for _, fobRecord in pairs(state.Logistics.fobs) do
        if fobRecord.linkedZoneKey == zoneKey then
            if fobRecord.status ~= FobSystem.status.DESTROYED then
                return true
            end
        end
    end

    return false
end

local function buildCandidateFromZone(zoneRecord)
    if type(zoneRecord) ~= "table" then
        return nil
    end

    if isUsefulFobCandidateZone(zoneRecord) ~= true then
        return nil
    end

    if fobExistsForZone(zoneRecord.key) == true then
        return nil
    end

    local hubRecord = getHubByZoneKey(zoneRecord.key)

    if hubRecord == nil then
        return nil
    end

    local owner = getRecordOwner(zoneRecord)
    local key = buildCandidateKey(zoneRecord)

    return {
        key = key,
        name = key,
        normalizedName = normalizeName(key),
        status = FobSystem.candidateStatus.CANDIDATE,

        owner = owner,
        zoneKey = zoneRecord.key,
        zoneName = zoneRecord.name,
        zoneDisplayName = zoneRecord.linkedAirbaseName or zoneRecord.displayName or zoneRecord.name,
        zoneClass = getZoneClass(zoneRecord),
        airbaseClassification = getAirbaseClassification(zoneRecord),
        theatreArea = zoneRecord.theatreArea,

        linkedBaseKey = zoneRecord.linkedAirbaseKey,
        linkedBaseName = zoneRecord.linkedAirbaseName,

        linkedHubKey = hubRecord.key,
        linkedHubName = hubRecord.displayName or hubRecord.name,
        hubType = hubRecord.hubType,

        position = copyValue(zoneRecord.center),
        radius = zoneRecord.radius,

        priority = getFobCandidatePriority(zoneRecord, hubRecord),
        strategicRelevance = zoneRecord.strategicRelevance or 0,

        reason = "friendly_or_contested_logistics_zone",
        source = "LOGISTICS_HUBS",
        createdAt = getCurrentTime(),
        updatedAt = getCurrentTime()
    }
end

local function buildFobNameFromCandidate(candidate)
    local baseName = candidate.zoneDisplayName or candidate.zoneName or candidate.key or "UNKNOWN"

    return "FOB " .. tostring(baseName)
end

local function sortCandidates(candidates)
    table.sort(candidates, function(left, right)
        if (left.priority or 0) ~= (right.priority or 0) then
            return (left.priority or 0) > (right.priority or 0)
        end

        if (left.strategicRelevance or 0) ~= (right.strategicRelevance or 0) then
            return (left.strategicRelevance or 0) > (right.strategicRelevance or 0)
        end

        return tostring(left.zoneDisplayName or left.zoneName or left.key)
            < tostring(right.zoneDisplayName or right.zoneName or right.key)
    end)

    return candidates
end

function FobSystem.buildCandidates(options)
    local state = ensureLogisticsState()

    if state == nil then
        return false, "state_unavailable"
    end

    local candidateOptions = options or {}
    local limit = candidateOptions.limit or FobSystem.defaultCandidateLimit

    state.Logistics.fobCandidates = {}

    local candidates = {}

    for _, zoneRecord in pairs(getZoneRegistry()) do
        local candidate = buildCandidateFromZone(zoneRecord)

        if candidate ~= nil then
            table.insert(candidates, candidate)
        end
    end

    sortCandidates(candidates)

    local stored = 0
    local skipped = 0

    for _, candidate in ipairs(candidates) do
        if stored >= limit then
            skipped = skipped + 1
        else
            candidate.rank = stored + 1
            state.Logistics.fobCandidates[candidate.key] = candidate
            stored = stored + 1
        end
    end

    state.Logistics.lastFobCandidateBuildTime = getCurrentTime()

    FobSystem.lastCandidateCount = #candidates
    FobSystem.lastSkippedCount = skipped

    updateStatistics()
    markDirty("fob_candidates_built")

    logInfo(
        "FOB candidate summary: candidates="
        .. tostring(#candidates)
        .. ", stored="
        .. tostring(stored)
        .. ", skipped="
        .. tostring(skipped)
    )

    return true, stored
end

function FobSystem.create(options)
    local state = ensureLogisticsState()

    if state == nil then
        return false, "state_unavailable"
    end

    local fobOptions = options or {}

    local fobId = createFobId()

    if fobId == nil then
        return false, "fob_id_failed"
    end

    local linkedZone, linkedBase, linkedHub = resolveZoneBaseHub(fobOptions)
    local fobKey = buildFobKey(fobId)
    local fobName = fobOptions.name or fobKey
    local owner = fobOptions.owner or (linkedZone and getRecordOwner(linkedZone)) or getOwnerUnknown()
    local status = fobOptions.status or FobSystem.status.PLANNED

    if isValidStatus(status) ~= true then
        status = FobSystem.status.PLANNED
    end

    local fobRecord = {
        id = fobId,
        key = fobKey,
        name = fobName,
        displayName = fobName,
        normalizedName = normalizeName(fobName),

        status = status,
        owner = owner,
        initialOwner = owner,
        currentOwner = owner,

        linkedZoneKey = linkedZone and linkedZone.key or fobOptions.linkedZone or fobOptions.linkedZoneKey,
        linkedZoneName = linkedZone and linkedZone.name or nil,
        linkedZoneClass = linkedZone and getZoneClass(linkedZone) or nil,

        linkedBaseKey = linkedBase and linkedBase.key or fobOptions.linkedBase or fobOptions.linkedBaseKey,
        linkedBaseName = linkedBase and linkedBase.name or nil,

        linkedHubKey = linkedHub and linkedHub.key or fobOptions.linkedHub or fobOptions.linkedHubKey,
        linkedHubName = linkedHub and linkedHub.displayName or nil,
        linkedHubType = linkedHub and linkedHub.hubType or nil,

        theatreArea = linkedZone and linkedZone.theatreArea or fobOptions.theatreArea,
        position = copyValue(fobOptions.position or (linkedZone and linkedZone.center) or (linkedHub and linkedHub.center)),
        radius = fobOptions.radius or 2500,

        supplyLevel = fobOptions.supplyLevel or FobSystem.defaultValues.supplyLevel,
        fuelLevel = fobOptions.fuelLevel or FobSystem.defaultValues.fuelLevel,
        ammunitionLevel = fobOptions.ammunitionLevel or FobSystem.defaultValues.ammunitionLevel,
        engineeringLevel = fobOptions.engineeringLevel or FobSystem.defaultValues.engineeringLevel,
        airDefenseLevel = fobOptions.airDefenseLevel or FobSystem.defaultValues.airDefenseLevel,
        repairLevel = fobOptions.repairLevel or FobSystem.defaultValues.repairLevel,
        constructionProgress = fobOptions.constructionProgress or FobSystem.defaultValues.constructionProgress,

        activationSupplyRequired = fobOptions.activationSupplyRequired or FobSystem.defaultValues.activationSupplyRequired,
        activationConstructionRequired = fobOptions.activationConstructionRequired or FobSystem.defaultValues.activationConstructionRequired,

        source = fobOptions.source or "THEATER_COMMAND",
        planningReason = fobOptions.planningReason,
        candidateKey = fobOptions.candidateKey,

        ctldEnabled = false,
        ctldGroupName = fobOptions.ctldGroupName,
        ctldUnitName = fobOptions.ctldUnitName,
        ctldZoneName = fobOptions.ctldZoneName,

        createdAt = getCurrentTime(),
        updatedAt = getCurrentTime(),
        activatedAt = nil,
        destroyedAt = nil,
        lastDeliveryKey = nil,
        lastDeliveryAt = nil,

        notes = fobOptions.notes
    }

    maybeUpdateStatusFromResources(fobRecord)

    syncFob(fobRecord)
    markDirty("fob_created")

    logInfo("FOB created: " .. tostring(fobRecord.name) .. " [" .. tostring(fobRecord.status) .. "]")

    return true, fobRecord
end

function FobSystem.planFromCandidate(candidateKeyOrRecord, options)
    local state = ensureLogisticsState()

    if state == nil then
        return false, "state_unavailable"
    end

    local candidate = nil

    if type(candidateKeyOrRecord) == "table" then
        candidate = candidateKeyOrRecord
    elseif candidateKeyOrRecord ~= nil then
        candidate = state.Logistics.fobCandidates[candidateKeyOrRecord]
    end

    if candidate == nil then
        return false, "candidate_not_found"
    end

    if fobExistsForZone(candidate.zoneKey) == true then
        return false, "fob_already_exists_for_zone"
    end

    local planOptions = options or {}

    local created, fobRecordOrReason = FobSystem.create({
        name = planOptions.name or buildFobNameFromCandidate(candidate),
        owner = planOptions.owner or candidate.owner or getOwnerBlue(),
        status = planOptions.status or FobSystem.status.PLANNED,

        linkedZone = candidate.zoneKey,
        linkedBase = candidate.linkedBaseKey,
        linkedHub = candidate.linkedHubKey,
        position = candidate.position,
        theatreArea = candidate.theatreArea,

        supplyLevel = planOptions.supplyLevel or FobSystem.defaultValues.plannedSupplyLevel,
        fuelLevel = planOptions.fuelLevel or FobSystem.defaultValues.plannedFuelLevel,
        ammunitionLevel = planOptions.ammunitionLevel or FobSystem.defaultValues.plannedAmmunitionLevel,
        engineeringLevel = planOptions.engineeringLevel or FobSystem.defaultValues.plannedEngineeringLevel,
        constructionProgress = planOptions.constructionProgress or FobSystem.defaultValues.plannedConstructionProgress,

        source = "FOB_CANDIDATE",
        planningReason = candidate.reason or "candidate_planning",
        candidateKey = candidate.key,
        notes = planOptions.notes or "State-only FOB plan. CTLD construction is pending."
    })

    if created ~= true then
        return false, fobRecordOrReason
    end

    candidate.status = FobSystem.candidateStatus.PLANNED
    candidate.plannedFobKey = fobRecordOrReason.key
    candidate.updatedAt = getCurrentTime()

    state.Logistics.fobCandidates[candidate.key] = candidate

    updateStatistics()
    markDirty("fob_planned_from_candidate")

    return true, fobRecordOrReason
end

function FobSystem.autoPlanFobs(options)
    local state = ensureLogisticsState()

    if state == nil then
        return false, "state_unavailable"
    end

    local planOptions = options or {}
    local limit = planOptions.limit or FobSystem.defaultAutoPlanLimit

    local candidates = {}

    for _, candidate in pairs(state.Logistics.fobCandidates) do
        if candidate.status == FobSystem.candidateStatus.CANDIDATE then
            table.insert(candidates, candidate)
        end
    end

    sortCandidates(candidates)

    local planned = 0
    local skipped = 0

    for _, candidate in ipairs(candidates) do
        if planned >= limit then
            skipped = skipped + 1
        else
            local success = FobSystem.planFromCandidate(candidate, {
                status = FobSystem.status.PLANNED
            })

            if success == true then
                planned = planned + 1
            else
                skipped = skipped + 1
            end
        end
    end

    FobSystem.lastPlannedCount = planned
    FobSystem.lastSkippedCount = skipped

    updateStatistics()

    logInfo(
        "FOBs auto-planned: "
        .. tostring(planned)
        .. " from "
        .. tostring(#candidates)
        .. " candidates (skipped="
        .. tostring(skipped)
        .. ")"
    )

    return true, planned
end

function FobSystem.get(fobKeyOrName)
    local state = ensureLogisticsState()

    if state == nil or fobKeyOrName == nil then
        return nil
    end

    local fobRecord = findRecordByKeyOrName(state.Logistics.fobs, fobKeyOrName)

    return fobRecord
end

function FobSystem.getAll()
    local state = ensureLogisticsState()

    if state == nil then
        return {}
    end

    return state.Logistics.fobs
end

function FobSystem.getCandidates()
    local state = ensureLogisticsState()

    if state == nil then
        return {}
    end

    return state.Logistics.fobCandidates
end

function FobSystem.setStatus(fobKeyOrName, status, reason)
    local fobRecord = FobSystem.get(fobKeyOrName)

    if fobRecord == nil then
        return false, "fob_not_found"
    end

    if isValidStatus(status) ~= true then
        return false, "invalid_status"
    end

    fobRecord.previousStatus = fobRecord.status
    fobRecord.status = status
    fobRecord.statusReason = reason or "manual_status_update"
    fobRecord.updatedAt = getCurrentTime()

    if status == FobSystem.status.ACTIVE then
        fobRecord.activatedAt = fobRecord.activatedAt or getCurrentTime()
    elseif status == FobSystem.status.DESTROYED then
        fobRecord.destroyedAt = fobRecord.destroyedAt or getCurrentTime()
    end

    syncFob(fobRecord)
    markDirty("fob_status_changed")

    logInfo("FOB status changed: " .. tostring(fobRecord.name) .. " [" .. tostring(status) .. "]")

    return true, fobRecord
end

function FobSystem.setOwner(fobKeyOrName, owner, reason)
    local fobRecord = FobSystem.get(fobKeyOrName)

    if fobRecord == nil then
        return false, "fob_not_found"
    end

    fobRecord.previousOwner = fobRecord.owner
    fobRecord.owner = owner or getOwnerUnknown()
    fobRecord.currentOwner = fobRecord.owner
    fobRecord.ownerReason = reason or "manual_owner_update"
    fobRecord.updatedAt = getCurrentTime()

    syncFob(fobRecord)
    markDirty("fob_owner_changed")

    logInfo("FOB owner changed: " .. tostring(fobRecord.name) .. " [" .. tostring(fobRecord.owner) .. "]")

    return true, fobRecord
end

function FobSystem.addSupply(fobKeyOrName, amount, reason)
    local fobRecord = FobSystem.get(fobKeyOrName)

    if fobRecord == nil then
        return false, "fob_not_found"
    end

    fobRecord.supplyLevel = clamp((fobRecord.supplyLevel or 0) + (amount or 0), 0, 100)
    fobRecord.supplyReason = reason or "manual_supply_update"
    fobRecord.updatedAt = getCurrentTime()

    maybeUpdateStatusFromResources(fobRecord)
    syncFob(fobRecord)
    markDirty("fob_supply_changed")

    return true, fobRecord
end

function FobSystem.addConstructionProgress(fobKeyOrName, amount, reason)
    local fobRecord = FobSystem.get(fobKeyOrName)

    if fobRecord == nil then
        return false, "fob_not_found"
    end

    fobRecord.constructionProgress = clamp((fobRecord.constructionProgress or 0) + (amount or 0), 0, 100)
    fobRecord.constructionReason = reason or "manual_construction_update"
    fobRecord.updatedAt = getCurrentTime()

    maybeUpdateStatusFromResources(fobRecord)
    syncFob(fobRecord)
    markDirty("fob_construction_changed")

    return true, fobRecord
end

function FobSystem.applyPayload(fobKeyOrName, payload, reason)
    local fobRecord = FobSystem.get(fobKeyOrName)

    if fobRecord == nil then
        return false, "fob_not_found"
    end

    local success, result = applyPayloadToFob(fobRecord, payload or {})

    if success ~= true then
        return false, result
    end

    fobRecord.lastPayloadReason = reason or "manual_payload"
    fobRecord.updatedAt = getCurrentTime()

    syncFob(fobRecord)
    markDirty("fob_payload_applied")

    return true, fobRecord
end

function FobSystem.applyDelivery(fobKeyOrName, deliveryKey)
    local fobRecord = FobSystem.get(fobKeyOrName)

    if fobRecord == nil then
        return false, "fob_not_found"
    end

    local deliveryRecord = getDelivery(deliveryKey)

    if deliveryRecord == nil then
        return false, "delivery_not_found"
    end

    local payload = getDeliveryPayload(deliveryRecord)
    local success, result = applyPayloadToFob(fobRecord, payload)

    if success ~= true then
        return false, result
    end

    fobRecord.lastDeliveryKey = deliveryRecord.key
    fobRecord.lastDeliveryType = deliveryRecord.type
    fobRecord.lastDeliveryAt = getCurrentTime()
    fobRecord.updatedAt = getCurrentTime()

    syncFob(fobRecord)
    markDirty("fob_delivery_applied")

    logInfo("FOB delivery applied: " .. tostring(fobRecord.name) .. " <- " .. tostring(deliveryRecord.key))

    return true, fobRecord
end

function FobSystem.requestSupportDelivery(fobKeyOrName, options)
    local fobRecord = FobSystem.get(fobKeyOrName)

    if fobRecord == nil then
        return false, "fob_not_found"
    end

    local deliverySystem = getDeliverySystem()

    if deliverySystem == nil or deliverySystem.createFobPackageDelivery == nil then
        return false, "delivery_system_unavailable"
    end

    local supportOptions = options or {}

    local created, deliveryRecordOrReason = deliverySystem.createFobPackageDelivery({
        name = supportOptions.name or ("FOB support - " .. tostring(fobRecord.name)),
        owner = supportOptions.owner or fobRecord.owner or getOwnerBlue(),
        targetFob = fobRecord.key,
        targetZone = fobRecord.linkedZoneKey,
        targetHub = fobRecord.linkedHubKey,
        targetBase = fobRecord.linkedBaseKey,
        payload = supportOptions.payload or FobSystem.defaultSupportPayload,
        reason = supportOptions.reason or "fob_support_requested",
        source = "FOB_SYSTEM",
        notes = supportOptions.notes or "State-only FOB support delivery. CTLD cargo is pending."
    })

    if created ~= true then
        return false, deliveryRecordOrReason
    end

    fobRecord.lastSupportDeliveryKey = deliveryRecordOrReason.key
    fobRecord.updatedAt = getCurrentTime()

    syncFob(fobRecord)
    markDirty("fob_support_delivery_requested")

    return true, deliveryRecordOrReason
end

function FobSystem.createFromDelivery(deliveryKey, options)
    local deliveryRecord = getDelivery(deliveryKey)

    if deliveryRecord == nil then
        return false, "delivery_not_found"
    end

    local fobOptions = options or {}

    fobOptions.name = fobOptions.name or ("FOB " .. tostring(deliveryRecord.targetZoneName or deliveryRecord.targetZoneKey or deliveryRecord.key))
    fobOptions.owner = fobOptions.owner or deliveryRecord.owner
    fobOptions.linkedZone = fobOptions.linkedZone or deliveryRecord.targetZoneKey
    fobOptions.linkedBase = fobOptions.linkedBase or deliveryRecord.targetBaseKey
    fobOptions.linkedHub = fobOptions.linkedHub or deliveryRecord.targetHubKey
    fobOptions.position = fobOptions.position or deliveryRecord.position
    fobOptions.source = "LOGISTICS_DELIVERY"
    fobOptions.notes = fobOptions.notes or ("Created from delivery " .. tostring(deliveryRecord.key))

    local created, fobRecordOrReason = FobSystem.create(fobOptions)

    if created ~= true then
        return false, fobRecordOrReason
    end

    FobSystem.applyDelivery(fobRecordOrReason.key, deliveryRecord.key)

    return true, fobRecordOrReason
end

function FobSystem.tryActivate(fobKeyOrName, reason)
    local fobRecord = FobSystem.get(fobKeyOrName)

    if fobRecord == nil then
        return false, "fob_not_found"
    end

    if canActivateFob(fobRecord) ~= true then
        return false, "activation_requirements_not_met"
    end

    return FobSystem.setStatus(fobRecord.key, FobSystem.status.ACTIVE, reason or "activation_requirements_met")
end

function FobSystem.activate(fobKeyOrName, reason)
    local fobRecord = FobSystem.get(fobKeyOrName)

    if fobRecord == nil then
        return false, "fob_not_found"
    end

    fobRecord.constructionProgress = 100

    if (fobRecord.supplyLevel or 0) < FobSystem.defaultValues.activationSupplyRequired then
        fobRecord.supplyLevel = FobSystem.defaultValues.activationSupplyRequired
    end

    syncFob(fobRecord)

    return FobSystem.setStatus(fobRecord.key, FobSystem.status.ACTIVE, reason or "manual_activation")
end

function FobSystem.damage(fobKeyOrName, reason)
    return FobSystem.setStatus(fobKeyOrName, FobSystem.status.DAMAGED, reason or "fob_damaged")
end

function FobSystem.markOutOfSupply(fobKeyOrName, reason)
    return FobSystem.setStatus(fobKeyOrName, FobSystem.status.OUT_OF_SUPPLY, reason or "fob_out_of_supply")
end

function FobSystem.destroy(fobKeyOrName, reason)
    return FobSystem.setStatus(fobKeyOrName, FobSystem.status.DESTROYED, reason or "fob_destroyed")
end

function FobSystem.repair(fobKeyOrName, amount, reason)
    local fobRecord = FobSystem.get(fobKeyOrName)

    if fobRecord == nil then
        return false, "fob_not_found"
    end

    local repairAmount = amount or 25

    fobRecord.repairLevel = clamp((fobRecord.repairLevel or 0) + repairAmount, 0, 100)
    fobRecord.repairReason = reason or "fob_repair"
    fobRecord.updatedAt = getCurrentTime()

    if fobRecord.status == FobSystem.status.DAMAGED and fobRecord.repairLevel >= 50 then
        fobRecord.status = FobSystem.status.ACTIVE
    end

    syncFob(fobRecord)
    markDirty("fob_repaired")

    logInfo("FOB repaired: " .. tostring(fobRecord.name))

    return true, fobRecord
end

function FobSystem.getByStatus(status)
    local result = {}
    local state = ensureLogisticsState()

    if state == nil then
        return result
    end

    for key, fobRecord in pairs(state.Logistics.fobs) do
        if fobRecord.status == status then
            result[key] = fobRecord
        end
    end

    return result
end

function FobSystem.getByOwner(owner)
    local result = {}
    local state = ensureLogisticsState()

    if state == nil then
        return result
    end

    for key, fobRecord in pairs(state.Logistics.fobs) do
        if fobRecord.owner == owner then
            result[key] = fobRecord
        end
    end

    return result
end

function FobSystem.getByZone(zoneKey)
    local result = {}
    local state = ensureLogisticsState()

    if state == nil then
        return result
    end

    for key, fobRecord in pairs(state.Logistics.fobs) do
        if fobRecord.linkedZoneKey == zoneKey then
            result[key] = fobRecord
        end
    end

    return result
end

function FobSystem.getByBase(baseKey)
    local result = {}
    local state = ensureLogisticsState()

    if state == nil then
        return result
    end

    for key, fobRecord in pairs(state.Logistics.fobs) do
        if fobRecord.linkedBaseKey == baseKey then
            result[key] = fobRecord
        end
    end

    return result
end

function FobSystem.getByHub(hubKey)
    local result = {}
    local state = ensureLogisticsState()

    if state == nil then
        return result
    end

    for key, fobRecord in pairs(state.Logistics.fobs) do
        if fobRecord.linkedHubKey == hubKey then
            result[key] = fobRecord
        end
    end

    return result
end

function FobSystem.getPlanned()
    return FobSystem.getByStatus(FobSystem.status.PLANNED)
end

function FobSystem.getUnderConstruction()
    return FobSystem.getByStatus(FobSystem.status.UNDER_CONSTRUCTION)
end

function FobSystem.getActive()
    return FobSystem.getByStatus(FobSystem.status.ACTIVE)
end

function FobSystem.getDamaged()
    return FobSystem.getByStatus(FobSystem.status.DAMAGED)
end

function FobSystem.getOutOfSupply()
    return FobSystem.getByStatus(FobSystem.status.OUT_OF_SUPPLY)
end

function FobSystem.getDestroyed()
    return FobSystem.getByStatus(FobSystem.status.DESTROYED)
end

function FobSystem.getBlueFobs()
    return FobSystem.getByOwner(getOwnerBlue())
end

function FobSystem.getRedFobs()
    return FobSystem.getByOwner(getOwnerRed())
end

function FobSystem.delete(fobKeyOrName)
    local state = ensureLogisticsState()

    if state == nil then
        return false, "state_unavailable"
    end

    local fobRecord = FobSystem.get(fobKeyOrName)

    if fobRecord == nil then
        return false, "fob_not_found"
    end

    state.Logistics.fobs[fobRecord.key] = nil

    if TC.Logistics ~= nil and TC.Logistics.Fobs ~= nil then
        TC.Logistics.Fobs[fobRecord.key] = nil
    end

    updateStatistics()
    markDirty("fob_deleted")

    logInfo("FOB deleted: " .. tostring(fobRecord.name))

    return true
end

function FobSystem.getStatistics()
    updateStatistics()

    local state = ensureLogisticsState()

    if state == nil then
        return {}
    end

    return state.Logistics.fobStatistics
end

function FobSystem.start()
    if FobSystem.started == true and FobSystem.finished == true and FobSystem.failed ~= true then
        logDebug("FOB system already started")
        return true
    end

    FobSystem.started = true
    FobSystem.finished = false
    FobSystem.failed = false
    FobSystem.lastUpdateTime = getCurrentTime()

    setModuleStatus("STARTING")
    setFeatureStatus(false)

    logInfo("FOB system started")

    local state = ensureLogisticsState()

    if state == nil then
        FobSystem.failed = true
        setModuleStatus("FAILED")
        setFeatureStatus(false)
        logError("FOB system failed: state_unavailable")
        return false
    end

    local candidatesBuilt, candidateResult = FobSystem.buildCandidates({
        limit = FobSystem.defaultCandidateLimit
    })

    if candidatesBuilt ~= true then
        FobSystem.failed = true
        setModuleStatus("FAILED")
        setFeatureStatus(false)
        logError("FOB system failed during candidate build: " .. tostring(candidateResult))
        return false
    end

    local autoPlanned, autoPlanResult = FobSystem.autoPlanFobs({
        limit = FobSystem.defaultAutoPlanLimit
    })

    if autoPlanned ~= true then
        FobSystem.failed = true
        setModuleStatus("FAILED")
        setFeatureStatus(false)
        logError("FOB system failed during auto planning: " .. tostring(autoPlanResult))
        return false
    end

    updateStatistics()

    FobSystem.finished = true
    FobSystem.failed = false

    setModuleStatus("READY")
    setFeatureStatus(true)

    local statistics = FobSystem.getStatistics()

    logInfo(
        "FOB system initialized: fobs="
        .. tostring(statistics.total or 0)
        .. ", candidates="
        .. tostring(statistics.candidates or 0)
        .. ", planned="
        .. tostring(statistics.planned or 0)
        .. ", active="
        .. tostring(statistics.active or 0)
        .. ", blue="
        .. tostring(statistics.blue or 0)
    )

    return true
end

function FobSystem.stop()
    FobSystem.started = false
    setModuleStatus("STOPPED")
    logInfo("FOB system stopped")
    return true
end

function FobSystem.summary()
    local state = getState()
    local logisticsState = nil

    if state ~= nil then
        logisticsState = state.Logistics
    end

    updateStatistics()

    return {
        name = FobSystem.name,
        displayName = FobSystem.displayName,
        path = FobSystem.path,
        version = FobSystem.version,
        loaded = FobSystem.loaded,
        started = FobSystem.started,
        finished = FobSystem.finished,
        failed = FobSystem.failed,
        lastUpdateTime = FobSystem.lastUpdateTime,
        lastCandidateCount = FobSystem.lastCandidateCount,
        lastPlannedCount = FobSystem.lastPlannedCount,
        lastSkippedCount = FobSystem.lastSkippedCount,
        fobCount = logisticsState and countTableKeys(logisticsState.fobs) or 0,
        candidateCount = logisticsState and countTableKeys(logisticsState.fobCandidates) or 0,
        statistics = logisticsState and logisticsState.fobStatistics or nil,
        state = logisticsState
    }
end

TC.Logistics.FobSystem = FobSystem
TC.logistics.FobSystem = FobSystem

TC.modules.fobSystem = {
    name = FobSystem.name,
    path = FobSystem.path,
    loaded = true,
    version = FobSystem.version
}

setModuleStatus("LOADED")
logInfo("Loaded " .. FobSystem.path .. " v" .. FobSystem.version)

return FobSystem
