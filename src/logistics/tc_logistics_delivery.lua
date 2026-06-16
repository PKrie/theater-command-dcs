-- Theater Command DCS
-- File: src/logistics/tc_logistics_delivery.lua
--
-- Purpose:
--   Manage Theater Command logistics hubs and delivery state.
--
-- Current focus:
--   Airbase Scanner, Zone Factory and Capture System now provide filtered,
--   classified and capture-eligible campaign objectives. Logistics must use
--   these campaign zones instead of raw DCS airbase objects.
--
-- Version:
--   0.2.0
--
-- Responsibilities:
--   - build logistics hubs from classified campaign zones
--   - identify Akrotiri as initial Blue main logistics hub
--   - prepare Red strategic airfields as enemy logistics hubs
--   - exclude helipads, medical pads and unknown objects from strategic hubs
--   - manage state-only logistics deliveries
--   - support later CTLD cargo integration without calling CTLD yet
--   - expose logistics state for missions, FOBs, capture, AI and persistence
--
-- Vendor note:
--   CTLD is loaded by the mission, but this file does not directly call CTLD yet.
--   Real CTLD pickup/dropoff logic will be connected later after Mission Editor
--   CTLD zones and template groups exist.

TC = TC or {}
TC.modules = TC.modules or {}
TC.Logistics = TC.Logistics or {}
TC.logistics = TC.logistics or TC.Logistics

local DeliverySystem = {}

DeliverySystem.name = "tc_logistics_delivery"
DeliverySystem.displayName = "Logistics Delivery"
DeliverySystem.path = "src/logistics/tc_logistics_delivery.lua"
DeliverySystem.version = "0.2.0"

DeliverySystem.loaded = true
DeliverySystem.started = false
DeliverySystem.finished = false
DeliverySystem.failed = false

DeliverySystem.lastUpdateTime = 0
DeliverySystem.lastHubBuildTime = 0
DeliverySystem.lastHubCount = 0
DeliverySystem.lastDeliveryCount = 0

DeliverySystem.status = {
    PLANNED = "PLANNED",
    READY = "READY",
    IN_TRANSIT = "IN_TRANSIT",
    DELIVERED = "DELIVERED",
    FAILED = "FAILED",
    CANCELLED = "CANCELLED"
}

DeliverySystem.hubStatus = {
    ACTIVE = "ACTIVE",
    LIMITED = "LIMITED",
    LOCKED = "LOCKED",
    DISABLED = "DISABLED"
}

DeliverySystem.deliveryTypes = {
    SUPPLY = "SUPPLY",
    FUEL = "FUEL",
    AMMUNITION = "AMMUNITION",
    ENGINEERING = "ENGINEERING",
    FOB_PACKAGE = "FOB_PACKAGE",
    MIXED = "MIXED"
}

DeliverySystem.hubTypes = {
    MAIN_OPERATING_BASE = "MAIN_OPERATING_BASE",
    STRATEGIC_AIRBASE_HUB = "STRATEGIC_AIRBASE_HUB",
    SECONDARY_AIRBASE_HUB = "SECONDARY_AIRBASE_HUB",
    HELIPORT_HUB = "HELIPORT_HUB",
    FARP_HUB = "FARP_HUB",
    TACTICAL_HUB = "TACTICAL_HUB",
    UNKNOWN_HUB = "UNKNOWN_HUB"
}

DeliverySystem.zoneClasses = {
    STRATEGIC_AIRBASE_ZONE = "STRATEGIC_AIRBASE_ZONE",
    SECONDARY_AIRBASE_ZONE = "SECONDARY_AIRBASE_ZONE",
    HELIPORT_ZONE = "HELIPORT_ZONE",
    FARP_ZONE = "FARP_ZONE",
    TACTICAL_PAD_ZONE = "TACTICAL_PAD_ZONE",
    UNKNOWN_ZONE = "UNKNOWN_ZONE"
}

DeliverySystem.airbaseClassifications = {
    STRATEGIC_AIRFIELD = "STRATEGIC_AIRFIELD",
    SECONDARY_AIRFIELD = "SECONDARY_AIRFIELD",
    HELIPORT = "HELIPORT",
    HELIPAD = "HELIPAD",
    MEDICAL_PAD = "MEDICAL_PAD",
    FARP = "FARP",
    TACTICAL_PAD = "TACTICAL_PAD",
    UNKNOWN = "UNKNOWN"
}

DeliverySystem.defaultResourceLevels = {
    BLUE_MAIN = {
        supply = 1000,
        fuel = 1000,
        ammunition = 1000,
        engineering = 500
    },
    BLUE_FORWARD = {
        supply = 300,
        fuel = 300,
        ammunition = 250,
        engineering = 150
    },
    RED_STRATEGIC = {
        supply = 800,
        fuel = 800,
        ammunition = 800,
        engineering = 250
    },
    RED_SECONDARY = {
        supply = 450,
        fuel = 450,
        ammunition = 450,
        engineering = 120
    },
    NEUTRAL = {
        supply = 100,
        fuel = 100,
        ammunition = 100,
        engineering = 50
    },
    UNKNOWN = {
        supply = 0,
        fuel = 0,
        ammunition = 0,
        engineering = 0
    }
}

DeliverySystem.defaultCapacities = {
    MAIN_OPERATING_BASE = {
        supply = 2000,
        fuel = 2000,
        ammunition = 2000,
        engineering = 1000
    },
    STRATEGIC_AIRBASE_HUB = {
        supply = 1500,
        fuel = 1500,
        ammunition = 1500,
        engineering = 750
    },
    SECONDARY_AIRBASE_HUB = {
        supply = 900,
        fuel = 900,
        ammunition = 900,
        engineering = 400
    },
    HELIPORT_HUB = {
        supply = 500,
        fuel = 500,
        ammunition = 300,
        engineering = 250
    },
    FARP_HUB = {
        supply = 400,
        fuel = 400,
        ammunition = 300,
        engineering = 250
    },
    TACTICAL_HUB = {
        supply = 300,
        fuel = 300,
        ammunition = 250,
        engineering = 200
    },
    UNKNOWN_HUB = {
        supply = 100,
        fuel = 100,
        ammunition = 100,
        engineering = 100
    }
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
    local formatted = "[TC][LOGISTICS_DELIVERY] " .. tostring(message)

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
        logger.info("[LogisticsDelivery] " .. tostring(message))
        return
    end

    rawLog("INFO", message)
end

local function logWarn(message)
    local logger = getLogger()

    if logger ~= nil and logger.warn ~= nil then
        logger.warn("[LogisticsDelivery] " .. tostring(message))
        return
    end

    rawLog("WARN", message)
end

local function logError(message)
    local logger = getLogger()

    if logger ~= nil and logger.error ~= nil then
        logger.error("[LogisticsDelivery] " .. tostring(message))
        return
    end

    rawLog("ERROR", message)
end

local function logDebug(message)
    local logger = getLogger()

    if logger ~= nil and logger.debug ~= nil then
        logger.debug("[LogisticsDelivery] " .. tostring(message))
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

    for _, allowedStatus in pairs(DeliverySystem.status) do
        if status == allowedStatus then
            return true
        end
    end

    return false
end

local function isValidDeliveryType(deliveryType)
    if deliveryType == nil then
        return false
    end

    for _, allowedType in pairs(DeliverySystem.deliveryTypes) do
        if deliveryType == allowedType then
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

    state.Logistics.lastDeliveryId = state.Logistics.lastDeliveryId or 0
    state.Logistics.lastHubBuildTime = state.Logistics.lastHubBuildTime or 0
    state.Logistics.lastUpdateTime = state.Logistics.lastUpdateTime or 0

    state.Logistics.statistics = state.Logistics.statistics or {
        hubs = 0,
        blueHubs = 0,
        redHubs = 0,
        neutralHubs = 0,
        contestedHubs = 0,
        activeHubs = 0,
        lockedHubs = 0,
        deliveries = 0,
        planned = 0,
        ready = 0,
        inTransit = 0,
        delivered = 0,
        failed = 0,
        cancelled = 0
    }

    return state
end

local function markDirty(reason)
    local state = getState()

    if state ~= nil and state.markDirty ~= nil then
        state.markDirty(reason or "logistics_state_changed")
        return true
    end

    if state ~= nil then
        state.Persistence = state.Persistence or {}
        state.Persistence.dirty = true
        state.Persistence.dirtyReason = reason or "logistics_state_changed"
        state.Persistence.dirtyAt = getCurrentTime()
        return true
    end

    return false
end

local function setModuleStatus(status)
    local state = getState()

    if state ~= nil and state.setModuleStatus ~= nil then
        state.setModuleStatus("logisticsDelivery", status)
    end
end

local function setFeatureStatus(enabled)
    local state = getState()

    if state ~= nil and state.setFeatureStatus ~= nil then
        state.setFeatureStatus("logisticsDelivery", enabled == true)
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

local function findZoneByKeyOrName(keyOrName)
    return findRecordByKeyOrName(getZoneRegistry(), keyOrName)
end

local function findBaseByKeyOrName(keyOrName)
    return findRecordByKeyOrName(getBaseRegistry(), keyOrName)
end

local function getAirbaseClassification(zoneRecord)
    if type(zoneRecord) ~= "table" then
        return DeliverySystem.airbaseClassifications.UNKNOWN
    end

    if zoneRecord.airbaseClassification ~= nil then
        return zoneRecord.airbaseClassification
    end

    if zoneRecord.classification ~= nil then
        return zoneRecord.classification
    end

    if zoneRecord.isStrategicAirbaseZone == true then
        return DeliverySystem.airbaseClassifications.STRATEGIC_AIRFIELD
    end

    if zoneRecord.isSecondaryAirbaseZone == true then
        return DeliverySystem.airbaseClassifications.SECONDARY_AIRFIELD
    end

    if zoneRecord.isHeliportZone == true then
        return DeliverySystem.airbaseClassifications.HELIPORT
    end

    if zoneRecord.isFarpZone == true then
        return DeliverySystem.airbaseClassifications.FARP
    end

    if zoneRecord.isTacticalPadZone == true then
        return DeliverySystem.airbaseClassifications.TACTICAL_PAD
    end

    return DeliverySystem.airbaseClassifications.UNKNOWN
end

local function getZoneClass(zoneRecord)
    if type(zoneRecord) ~= "table" then
        return DeliverySystem.zoneClasses.UNKNOWN_ZONE
    end

    return zoneRecord.zoneClass or zoneRecord.recommendedZoneClass or DeliverySystem.zoneClasses.UNKNOWN_ZONE
end

local function isExcludedLogisticsZone(zoneRecord)
    local classification = getAirbaseClassification(zoneRecord)
    local zoneClass = getZoneClass(zoneRecord)

    if classification == DeliverySystem.airbaseClassifications.HELIPAD then
        return true
    end

    if classification == DeliverySystem.airbaseClassifications.MEDICAL_PAD then
        return true
    end

    if classification == DeliverySystem.airbaseClassifications.UNKNOWN then
        return true
    end

    if zoneClass == DeliverySystem.zoneClasses.UNKNOWN_ZONE then
        return true
    end

    return false
end

local function isLogisticsZone(zoneRecord)
    if type(zoneRecord) ~= "table" then
        return false
    end

    if isExcludedLogisticsZone(zoneRecord) == true then
        return false
    end

    if zoneRecord.isLogisticsZone == true then
        return true
    end

    local zoneClass = getZoneClass(zoneRecord)

    if zoneClass == DeliverySystem.zoneClasses.STRATEGIC_AIRBASE_ZONE then
        return true
    end

    if zoneClass == DeliverySystem.zoneClasses.SECONDARY_AIRBASE_ZONE then
        return true
    end

    if zoneClass == DeliverySystem.zoneClasses.HELIPORT_ZONE then
        return true
    end

    if zoneClass == DeliverySystem.zoneClasses.FARP_ZONE then
        return true
    end

    if zoneClass == DeliverySystem.zoneClasses.TACTICAL_PAD_ZONE then
        return true
    end

    return false
end

local function getHubTypeForZone(zoneRecord)
    if type(zoneRecord) ~= "table" then
        return DeliverySystem.hubTypes.UNKNOWN_HUB
    end

    if zoneRecord.isStartBaseZone == true then
        return DeliverySystem.hubTypes.MAIN_OPERATING_BASE
    end

    local zoneClass = getZoneClass(zoneRecord)
    local classification = getAirbaseClassification(zoneRecord)

    if zoneClass == DeliverySystem.zoneClasses.STRATEGIC_AIRBASE_ZONE
        or classification == DeliverySystem.airbaseClassifications.STRATEGIC_AIRFIELD
    then
        return DeliverySystem.hubTypes.STRATEGIC_AIRBASE_HUB
    end

    if zoneClass == DeliverySystem.zoneClasses.SECONDARY_AIRBASE_ZONE
        or classification == DeliverySystem.airbaseClassifications.SECONDARY_AIRFIELD
    then
        return DeliverySystem.hubTypes.SECONDARY_AIRBASE_HUB
    end

    if zoneClass == DeliverySystem.zoneClasses.HELIPORT_ZONE
        or classification == DeliverySystem.airbaseClassifications.HELIPORT
    then
        return DeliverySystem.hubTypes.HELIPORT_HUB
    end

    if zoneClass == DeliverySystem.zoneClasses.FARP_ZONE
        or classification == DeliverySystem.airbaseClassifications.FARP
    then
        return DeliverySystem.hubTypes.FARP_HUB
    end

    if zoneClass == DeliverySystem.zoneClasses.TACTICAL_PAD_ZONE
        or classification == DeliverySystem.airbaseClassifications.TACTICAL_PAD
    then
        return DeliverySystem.hubTypes.TACTICAL_HUB
    end

    return DeliverySystem.hubTypes.UNKNOWN_HUB
end

local function getHubCapacity(hubType)
    local capacity = DeliverySystem.defaultCapacities[hubType]

    if capacity == nil then
        capacity = DeliverySystem.defaultCapacities.UNKNOWN_HUB
    end

    return copyValue(capacity)
end

local function getDefaultResourcesForZone(zoneRecord, hubType)
    local owner = getRecordOwner(zoneRecord)

    if zoneRecord ~= nil and zoneRecord.isStartBaseZone == true then
        return copyValue(DeliverySystem.defaultResourceLevels.BLUE_MAIN)
    end

    if owner == getOwnerBlue() then
        return copyValue(DeliverySystem.defaultResourceLevels.BLUE_FORWARD)
    end

    if owner == getOwnerRed() then
        if hubType == DeliverySystem.hubTypes.STRATEGIC_AIRBASE_HUB then
            return copyValue(DeliverySystem.defaultResourceLevels.RED_STRATEGIC)
        end

        return copyValue(DeliverySystem.defaultResourceLevels.RED_SECONDARY)
    end

    if owner == getOwnerNeutral() or owner == getOwnerContested() then
        return copyValue(DeliverySystem.defaultResourceLevels.NEUTRAL)
    end

    return copyValue(DeliverySystem.defaultResourceLevels.UNKNOWN)
end

local function getHubStatusForZone(zoneRecord)
    local owner = getRecordOwner(zoneRecord)

    if owner == getOwnerBlue() or owner == getOwnerRed() then
        return DeliverySystem.hubStatus.ACTIVE
    end

    if owner == getOwnerNeutral() or owner == getOwnerContested() then
        return DeliverySystem.hubStatus.LIMITED
    end

    return DeliverySystem.hubStatus.LOCKED
end

local function getLogisticsRole(zoneRecord, hubType)
    local owner = getRecordOwner(zoneRecord)

    if zoneRecord ~= nil and zoneRecord.isStartBaseZone == true then
        return "BLUE_MAIN_OPERATING_BASE"
    end

    if owner == getOwnerBlue() then
        if hubType == DeliverySystem.hubTypes.STRATEGIC_AIRBASE_HUB then
            return "BLUE_STRATEGIC_HUB"
        end

        return "BLUE_FORWARD_HUB"
    end

    if owner == getOwnerRed() then
        if hubType == DeliverySystem.hubTypes.STRATEGIC_AIRBASE_HUB then
            return "RED_STRATEGIC_HUB"
        end

        return "RED_FORWARD_HUB"
    end

    if owner == getOwnerNeutral() then
        return "NEUTRAL_LOCAL_HUB"
    end

    if owner == getOwnerContested() then
        return "CONTESTED_HUB"
    end

    return "UNKNOWN_HUB"
end

local function getHubPriority(zoneRecord, hubType)
    local relevance = 0

    if type(zoneRecord) == "table" and type(zoneRecord.strategicRelevance) == "number" then
        relevance = zoneRecord.strategicRelevance
    end

    if zoneRecord ~= nil and zoneRecord.isStartBaseZone == true then
        return 100
    end

    if hubType == DeliverySystem.hubTypes.STRATEGIC_AIRBASE_HUB then
        return 80 + math.floor(relevance / 10)
    end

    if hubType == DeliverySystem.hubTypes.SECONDARY_AIRBASE_HUB then
        return 60 + math.floor(relevance / 10)
    end

    if hubType == DeliverySystem.hubTypes.HELIPORT_HUB then
        return 45 + math.floor(relevance / 10)
    end

    if hubType == DeliverySystem.hubTypes.FARP_HUB then
        return 40 + math.floor(relevance / 10)
    end

    if hubType == DeliverySystem.hubTypes.TACTICAL_HUB then
        return 30 + math.floor(relevance / 10)
    end

    return 10
end

local function buildHubKey(zoneRecord)
    local baseName = "UNKNOWN"

    if type(zoneRecord) == "table" then
        baseName = zoneRecord.linkedAirbaseName
            or zoneRecord.displayName
            or zoneRecord.name
            or zoneRecord.key
            or "UNKNOWN"
    end

    return "LOG_HUB_" .. normalizeName(baseName)
end

local function updateZoneLogisticsFromHub(hubRecord)
    if type(hubRecord) ~= "table" then
        return false
    end

    if hubRecord.zoneKey == nil then
        return false
    end

    local zoneRecord = findZoneByKeyOrName(hubRecord.zoneKey)

    if zoneRecord == nil then
        return false
    end

    zoneRecord.logistics = zoneRecord.logistics or {}
    zoneRecord.logistics.hubKey = hubRecord.key
    zoneRecord.logistics.hubType = hubRecord.hubType
    zoneRecord.logistics.role = hubRecord.role
    zoneRecord.logistics.status = hubRecord.status
    zoneRecord.logistics.supply = hubRecord.resources.supply or 0
    zoneRecord.logistics.fuel = hubRecord.resources.fuel or 0
    zoneRecord.logistics.ammunition = hubRecord.resources.ammunition or 0
    zoneRecord.logistics.engineering = hubRecord.resources.engineering or 0
    zoneRecord.logistics.capacity = copyValue(hubRecord.capacity)
    zoneRecord.logistics.updatedAt = getCurrentTime()
    zoneRecord.updatedAt = getCurrentTime()

    if TC.World ~= nil and TC.World.Zones ~= nil and zoneRecord.key ~= nil then
        TC.World.Zones[zoneRecord.key] = zoneRecord
    end

    return true
end

local function buildHubRecord(zoneRecord)
    if type(zoneRecord) ~= "table" then
        return nil
    end

    if isLogisticsZone(zoneRecord) ~= true then
        return nil
    end

    local hubType = getHubTypeForZone(zoneRecord)
    local capacity = getHubCapacity(hubType)
    local resources = getDefaultResourcesForZone(zoneRecord, hubType)
    local owner = getRecordOwner(zoneRecord)

    resources.supply = clamp(resources.supply or 0, 0, capacity.supply or 0)
    resources.fuel = clamp(resources.fuel or 0, 0, capacity.fuel or 0)
    resources.ammunition = clamp(resources.ammunition or 0, 0, capacity.ammunition or 0)
    resources.engineering = clamp(resources.engineering or 0, 0, capacity.engineering or 0)

    local key = buildHubKey(zoneRecord)

    return {
        key = key,
        name = key,
        displayName = zoneRecord.linkedAirbaseName or zoneRecord.displayName or zoneRecord.name or key,
        normalizedName = normalizeName(key),

        status = getHubStatusForZone(zoneRecord),
        owner = owner,
        initialOwner = owner,
        currentOwner = owner,

        hubType = hubType,
        role = getLogisticsRole(zoneRecord, hubType),
        priority = getHubPriority(zoneRecord, hubType),

        zoneKey = zoneRecord.key,
        zoneName = zoneRecord.name,
        zoneDisplayName = zoneRecord.displayName,
        zoneClass = getZoneClass(zoneRecord),
        airbaseClassification = getAirbaseClassification(zoneRecord),
        theatreArea = zoneRecord.theatreArea or "UNKNOWN",

        linkedAirbaseKey = zoneRecord.linkedAirbaseKey,
        linkedAirbaseName = zoneRecord.linkedAirbaseName,

        center = copyValue(zoneRecord.center),
        radius = zoneRecord.radius,

        resources = resources,
        capacity = capacity,

        canSourceBlue = owner == getOwnerBlue(),
        canReceiveBlue = owner == getOwnerBlue() or owner == getOwnerNeutral() or owner == getOwnerContested(),
        canSourceRed = owner == getOwnerRed(),
        canReceiveRed = owner == getOwnerRed() or owner == getOwnerNeutral() or owner == getOwnerContested(),

        ctldEnabled = false,
        ctldPickupZoneName = nil,
        ctldDropoffZoneName = nil,
        ctldCargoTypes = {},

        createdAt = getCurrentTime(),
        updatedAt = getCurrentTime(),
        source = "CLASSIFIED_ZONE_FACTORY"
    }
end

local function createDeliveryId()
    local state = ensureLogisticsState()

    if state == nil then
        return nil
    end

    state.Logistics.lastDeliveryId = (state.Logistics.lastDeliveryId or 0) + 1

    return state.Logistics.lastDeliveryId
end

local function buildDeliveryKey(deliveryId)
    return "DELIVERY_" .. tostring(deliveryId)
end

local function findHubByKeyOrName(keyOrName)
    local state = ensureLogisticsState()

    if state == nil or keyOrName == nil then
        return nil, nil
    end

    return findRecordByKeyOrName(state.Logistics.hubs, keyOrName)
end

local function findHubByZoneKey(zoneKey)
    local state = ensureLogisticsState()

    if state == nil or zoneKey == nil then
        return nil, nil
    end

    for key, hubRecord in pairs(state.Logistics.hubs) do
        if hubRecord.zoneKey == zoneKey then
            return hubRecord, key
        end
    end

    return nil, nil
end

local function findBestSourceHub(owner)
    local state = ensureLogisticsState()

    if state == nil then
        return nil
    end

    local bestHub = nil

    for _, hubRecord in pairs(state.Logistics.hubs) do
        if hubRecord.owner == owner and hubRecord.status == DeliverySystem.hubStatus.ACTIVE then
            local canSource = false

            if owner == getOwnerBlue() and hubRecord.canSourceBlue == true then
                canSource = true
            elseif owner == getOwnerRed() and hubRecord.canSourceRed == true then
                canSource = true
            end

            if canSource == true then
                if bestHub == nil then
                    bestHub = hubRecord
                elseif (hubRecord.priority or 0) > (bestHub.priority or 0) then
                    bestHub = hubRecord
                end
            end
        end
    end

    return bestHub
end

local function getDeliveryContainer(status)
    local state = ensureLogisticsState()

    if state == nil then
        return nil
    end

    state.Logistics.deliveries = state.Logistics.deliveries or {}

    return state.Logistics.deliveries
end

local function updateStatistics()
    local state = ensureLogisticsState()

    if state == nil then
        return false
    end

    local statistics = {
        hubs = 0,
        blueHubs = 0,
        redHubs = 0,
        neutralHubs = 0,
        contestedHubs = 0,
        unknownHubs = 0,
        activeHubs = 0,
        limitedHubs = 0,
        lockedHubs = 0,
        disabledHubs = 0,
        deliveries = 0,
        planned = 0,
        ready = 0,
        inTransit = 0,
        delivered = 0,
        failed = 0,
        cancelled = 0
    }

    for _, hubRecord in pairs(state.Logistics.hubs) do
        statistics.hubs = statistics.hubs + 1

        if hubRecord.owner == getOwnerBlue() then
            statistics.blueHubs = statistics.blueHubs + 1
        elseif hubRecord.owner == getOwnerRed() then
            statistics.redHubs = statistics.redHubs + 1
        elseif hubRecord.owner == getOwnerNeutral() then
            statistics.neutralHubs = statistics.neutralHubs + 1
        elseif hubRecord.owner == getOwnerContested() then
            statistics.contestedHubs = statistics.contestedHubs + 1
        else
            statistics.unknownHubs = statistics.unknownHubs + 1
        end

        if hubRecord.status == DeliverySystem.hubStatus.ACTIVE then
            statistics.activeHubs = statistics.activeHubs + 1
        elseif hubRecord.status == DeliverySystem.hubStatus.LIMITED then
            statistics.limitedHubs = statistics.limitedHubs + 1
        elseif hubRecord.status == DeliverySystem.hubStatus.LOCKED then
            statistics.lockedHubs = statistics.lockedHubs + 1
        elseif hubRecord.status == DeliverySystem.hubStatus.DISABLED then
            statistics.disabledHubs = statistics.disabledHubs + 1
        end
    end

    for _, deliveryRecord in pairs(state.Logistics.deliveries) do
        statistics.deliveries = statistics.deliveries + 1

        if deliveryRecord.status == DeliverySystem.status.PLANNED then
            statistics.planned = statistics.planned + 1
        elseif deliveryRecord.status == DeliverySystem.status.READY then
            statistics.ready = statistics.ready + 1
        elseif deliveryRecord.status == DeliverySystem.status.IN_TRANSIT then
            statistics.inTransit = statistics.inTransit + 1
        elseif deliveryRecord.status == DeliverySystem.status.DELIVERED then
            statistics.delivered = statistics.delivered + 1
        elseif deliveryRecord.status == DeliverySystem.status.FAILED then
            statistics.failed = statistics.failed + 1
        elseif deliveryRecord.status == DeliverySystem.status.CANCELLED then
            statistics.cancelled = statistics.cancelled + 1
        end
    end

    state.Logistics.statistics = statistics
    state.Logistics.lastUpdateTime = getCurrentTime()

    DeliverySystem.lastUpdateTime = state.Logistics.lastUpdateTime
    DeliverySystem.lastHubCount = statistics.hubs
    DeliverySystem.lastDeliveryCount = statistics.deliveries

    return true
end

local function applyPayloadToHub(hubRecord, payload)
    if type(hubRecord) ~= "table" or type(payload) ~= "table" then
        return false
    end

    hubRecord.resources = hubRecord.resources or {}
    hubRecord.capacity = hubRecord.capacity or getHubCapacity(hubRecord.hubType or DeliverySystem.hubTypes.UNKNOWN_HUB)

    hubRecord.resources.supply = clamp(
        (hubRecord.resources.supply or 0) + (payload.supply or 0),
        0,
        hubRecord.capacity.supply or 0
    )

    hubRecord.resources.fuel = clamp(
        (hubRecord.resources.fuel or 0) + (payload.fuel or 0),
        0,
        hubRecord.capacity.fuel or 0
    )

    hubRecord.resources.ammunition = clamp(
        (hubRecord.resources.ammunition or 0) + (payload.ammunition or 0),
        0,
        hubRecord.capacity.ammunition or 0
    )

    hubRecord.resources.engineering = clamp(
        (hubRecord.resources.engineering or 0) + (payload.engineering or 0),
        0,
        hubRecord.capacity.engineering or 0
    )

    hubRecord.updatedAt = getCurrentTime()

    updateZoneLogisticsFromHub(hubRecord)

    return true
end

local function applyPayloadToZone(zoneRecord, payload)
    if type(zoneRecord) ~= "table" or type(payload) ~= "table" then
        return false
    end

    zoneRecord.logistics = zoneRecord.logistics or {}
    zoneRecord.logistics.supply = (zoneRecord.logistics.supply or 0) + (payload.supply or 0)
    zoneRecord.logistics.fuel = (zoneRecord.logistics.fuel or 0) + (payload.fuel or 0)
    zoneRecord.logistics.ammunition = (zoneRecord.logistics.ammunition or 0) + (payload.ammunition or 0)
    zoneRecord.logistics.engineering = (zoneRecord.logistics.engineering or 0) + (payload.engineering or 0)
    zoneRecord.logistics.lastDeliveryAt = getCurrentTime()
    zoneRecord.updatedAt = getCurrentTime()

    if TC.World ~= nil and TC.World.Zones ~= nil and zoneRecord.key ~= nil then
        TC.World.Zones[zoneRecord.key] = zoneRecord
    end

    return true
end

local function applyPayloadToFob(fobRecord, payload)
    if type(fobRecord) ~= "table" or type(payload) ~= "table" then
        return false
    end

    fobRecord.supplyLevel = (fobRecord.supplyLevel or 0) + (payload.supply or 0)
    fobRecord.fuelLevel = (fobRecord.fuelLevel or 0) + (payload.fuel or 0)
    fobRecord.ammunitionLevel = (fobRecord.ammunitionLevel or 0) + (payload.ammunition or 0)
    fobRecord.engineeringLevel = (fobRecord.engineeringLevel or 0) + (payload.engineering or 0)

    if payload.engineering ~= nil and payload.engineering > 0 then
        fobRecord.constructionProgress = clamp(
            (fobRecord.constructionProgress or 0) + payload.engineering,
            0,
            100
        )
    end

    fobRecord.lastDeliveryAt = getCurrentTime()
    fobRecord.updatedAt = getCurrentTime()

    if (fobRecord.supplyLevel or 0) >= 50 and (fobRecord.constructionProgress or 0) >= 100 then
        if fobRecord.status == "PLANNED" or fobRecord.status == "UNDER_CONSTRUCTION" then
            fobRecord.status = "ACTIVE"
        end
    end

    return true
end

local function getFobByKey(keyOrName)
    local state = ensureLogisticsState()

    if state == nil or keyOrName == nil then
        return nil, nil
    end

    return findRecordByKeyOrName(state.Logistics.fobs, keyOrName)
end

function DeliverySystem.buildHubsFromZones()
    local state = ensureLogisticsState()

    if state == nil then
        return false, "state_unavailable"
    end

    state.Logistics.hubs = {}

    local created = 0
    local skipped = 0

    for _, zoneRecord in pairs(getZoneRegistry()) do
        local hubRecord = buildHubRecord(zoneRecord)

        if hubRecord ~= nil then
            state.Logistics.hubs[hubRecord.key] = hubRecord
            updateZoneLogisticsFromHub(hubRecord)
            created = created + 1

            logDebug(
                "Logistics hub created: "
                .. tostring(hubRecord.displayName)
                .. " ["
                .. tostring(hubRecord.hubType)
                .. ", "
                .. tostring(hubRecord.owner)
                .. "]"
            )
        else
            skipped = skipped + 1
        end
    end

    state.Logistics.lastHubBuildTime = getCurrentTime()
    DeliverySystem.lastHubBuildTime = state.Logistics.lastHubBuildTime
    DeliverySystem.lastHubCount = created

    updateStatistics()
    markDirty("logistics_hubs_built")

    logInfo(
        "Logistics hubs built: "
        .. tostring(created)
        .. " hubs from classified campaign zones (skipped="
        .. tostring(skipped)
        .. ")"
    )

    return true, created
end

function DeliverySystem.refreshHubs()
    return DeliverySystem.buildHubsFromZones()
end

function DeliverySystem.getHubs()
    local state = ensureLogisticsState()

    if state == nil then
        return {}
    end

    return state.Logistics.hubs
end

function DeliverySystem.getHub(keyOrName)
    local hubRecord = findHubByKeyOrName(keyOrName)

    return hubRecord
end

function DeliverySystem.getHubByZone(zoneKeyOrName)
    local zoneRecord = findZoneByKeyOrName(zoneKeyOrName)

    if zoneRecord == nil then
        return nil
    end

    local hubRecord = findHubByZoneKey(zoneRecord.key)

    return hubRecord
end

function DeliverySystem.getHubsByOwner(owner)
    local result = {}
    local state = ensureLogisticsState()

    if state == nil then
        return result
    end

    for key, hubRecord in pairs(state.Logistics.hubs) do
        if hubRecord.owner == owner then
            result[key] = hubRecord
        end
    end

    return result
end

function DeliverySystem.getBlueHubs()
    return DeliverySystem.getHubsByOwner(getOwnerBlue())
end

function DeliverySystem.getRedHubs()
    return DeliverySystem.getHubsByOwner(getOwnerRed())
end

function DeliverySystem.getNeutralHubs()
    return DeliverySystem.getHubsByOwner(getOwnerNeutral())
end

function DeliverySystem.getAvailableSourceHubs(owner)
    local result = {}
    local state = ensureLogisticsState()

    if state == nil then
        return result
    end

    for key, hubRecord in pairs(state.Logistics.hubs) do
        if hubRecord.owner == owner and hubRecord.status == DeliverySystem.hubStatus.ACTIVE then
            if owner == getOwnerBlue() and hubRecord.canSourceBlue == true then
                result[key] = hubRecord
            elseif owner == getOwnerRed() and hubRecord.canSourceRed == true then
                result[key] = hubRecord
            end
        end
    end

    return result
end

function DeliverySystem.getBestSourceHub(owner)
    return findBestSourceHub(owner or getOwnerBlue())
end

function DeliverySystem.createDelivery(options)
    local state = ensureLogisticsState()

    if state == nil then
        return false, "state_unavailable"
    end

    local deliveryOptions = options or {}
    local deliveryType = deliveryOptions.type or DeliverySystem.deliveryTypes.MIXED

    if isValidDeliveryType(deliveryType) ~= true then
        return false, "invalid_delivery_type"
    end

    local owner = deliveryOptions.owner or getOwnerBlue()
    local sourceHub = nil
    local targetHub = nil
    local targetZone = nil
    local targetFob = nil

    if deliveryOptions.sourceHub ~= nil then
        sourceHub = findHubByKeyOrName(deliveryOptions.sourceHub)
    end

    if sourceHub == nil then
        sourceHub = findBestSourceHub(owner)
    end

    if deliveryOptions.targetHub ~= nil then
        targetHub = findHubByKeyOrName(deliveryOptions.targetHub)
    end

    if deliveryOptions.targetZone ~= nil then
        targetZone = findZoneByKeyOrName(deliveryOptions.targetZone)
    end

    if deliveryOptions.targetZoneRecord ~= nil then
        targetZone = deliveryOptions.targetZoneRecord
    end

    if targetHub == nil and targetZone ~= nil then
        targetHub = findHubByZoneKey(targetZone.key)
    end

    if deliveryOptions.targetFob ~= nil then
        targetFob = getFobByKey(deliveryOptions.targetFob)
    end

    if deliveryOptions.targetFobRecord ~= nil then
        targetFob = deliveryOptions.targetFobRecord
    end

    local deliveryId = createDeliveryId()

    if deliveryId == nil then
        return false, "delivery_id_failed"
    end

    local payload = copyValue(deliveryOptions.payload or deliveryOptions.effect or {})

    payload.supply = payload.supply or 0
    payload.fuel = payload.fuel or 0
    payload.ammunition = payload.ammunition or 0
    payload.engineering = payload.engineering or 0

    local key = buildDeliveryKey(deliveryId)
    local name = deliveryOptions.name or (deliveryType .. " " .. key)

    local deliveryRecord = {
        id = deliveryId,
        key = key,
        name = name,
        normalizedName = normalizeName(name),

        type = deliveryType,
        status = deliveryOptions.status or DeliverySystem.status.PLANNED,
        owner = owner,

        sourceHubKey = sourceHub and sourceHub.key or deliveryOptions.sourceHub,
        sourceHubName = sourceHub and sourceHub.displayName or nil,

        targetHubKey = targetHub and targetHub.key or deliveryOptions.targetHub,
        targetHubName = targetHub and targetHub.displayName or nil,

        targetZoneKey = targetZone and targetZone.key or deliveryOptions.targetZone,
        targetZoneName = targetZone and targetZone.name or nil,

        targetBaseKey = deliveryOptions.targetBase,
        targetFobKey = targetFob and targetFob.key or deliveryOptions.targetFob,
        targetFobName = targetFob and targetFob.name or nil,

        payload = payload,

        source = deliveryOptions.source or "LOGISTICS_DELIVERY",
        reason = deliveryOptions.reason or "manual_delivery_created",
        notes = deliveryOptions.notes,

        ctldEnabled = false,
        ctldCargoSpawned = false,
        ctldCargoName = nil,

        createdAt = getCurrentTime(),
        updatedAt = getCurrentTime(),
        dispatchedAt = nil,
        deliveredAt = nil,
        failedAt = nil,
        cancelledAt = nil
    }

    state.Logistics.deliveries[key] = deliveryRecord

    updateStatistics()
    markDirty("logistics_delivery_created")

    logInfo(
        "Delivery created: "
        .. tostring(deliveryRecord.key)
        .. " type="
        .. tostring(deliveryRecord.type)
        .. " target="
        .. tostring(deliveryRecord.targetHubName or deliveryRecord.targetZoneName or deliveryRecord.targetFobName or "UNKNOWN")
    )

    return true, deliveryRecord
end

function DeliverySystem.createFobPackageDelivery(options)
    local deliveryOptions = copyValue(options or {})

    deliveryOptions.type = DeliverySystem.deliveryTypes.FOB_PACKAGE
    deliveryOptions.payload = deliveryOptions.payload or deliveryOptions.effect or {
        supply = 25,
        fuel = 0,
        ammunition = 0,
        engineering = 25
    }

    deliveryOptions.reason = deliveryOptions.reason or "fob_package_delivery"
    deliveryOptions.source = deliveryOptions.source or "FOB_SUPPORT"

    return DeliverySystem.createDelivery(deliveryOptions)
end

function DeliverySystem.getDelivery(keyOrName)
    local state = ensureLogisticsState()

    if state == nil or keyOrName == nil then
        return nil
    end

    local deliveryRecord = findRecordByKeyOrName(state.Logistics.deliveries, keyOrName)

    return deliveryRecord
end

function DeliverySystem.getDeliveries()
    local state = ensureLogisticsState()

    if state == nil then
        return {}
    end

    return state.Logistics.deliveries
end

function DeliverySystem.getDeliveriesByStatus(status)
    local result = {}
    local state = ensureLogisticsState()

    if state == nil then
        return result
    end

    for key, deliveryRecord in pairs(state.Logistics.deliveries) do
        if deliveryRecord.status == status then
            result[key] = deliveryRecord
        end
    end

    return result
end

function DeliverySystem.setDeliveryStatus(keyOrName, status, reason)
    local state = ensureLogisticsState()

    if state == nil then
        return false, "state_unavailable"
    end

    if isValidStatus(status) ~= true then
        return false, "invalid_status"
    end

    local deliveryRecord, key = findRecordByKeyOrName(state.Logistics.deliveries, keyOrName)

    if deliveryRecord == nil then
        return false, "delivery_not_found"
    end

    deliveryRecord.previousStatus = deliveryRecord.status
    deliveryRecord.status = status
    deliveryRecord.statusReason = reason or "status_changed"
    deliveryRecord.updatedAt = getCurrentTime()

    if status == DeliverySystem.status.IN_TRANSIT then
        deliveryRecord.dispatchedAt = deliveryRecord.dispatchedAt or getCurrentTime()
    elseif status == DeliverySystem.status.DELIVERED then
        deliveryRecord.deliveredAt = deliveryRecord.deliveredAt or getCurrentTime()
    elseif status == DeliverySystem.status.FAILED then
        deliveryRecord.failedAt = deliveryRecord.failedAt or getCurrentTime()
    elseif status == DeliverySystem.status.CANCELLED then
        deliveryRecord.cancelledAt = deliveryRecord.cancelledAt or getCurrentTime()
    end

    state.Logistics.deliveries[key] = deliveryRecord

    updateStatistics()
    markDirty("logistics_delivery_status_changed")

    logInfo("Delivery status changed: " .. tostring(deliveryRecord.key) .. " [" .. tostring(status) .. "]")

    return true, deliveryRecord
end

function DeliverySystem.dispatchDelivery(keyOrName, reason)
    return DeliverySystem.setDeliveryStatus(keyOrName, DeliverySystem.status.IN_TRANSIT, reason or "delivery_dispatched")
end

function DeliverySystem.completeDelivery(keyOrName, reason)
    local state = ensureLogisticsState()

    if state == nil then
        return false, "state_unavailable"
    end

    local deliveryRecord, key = findRecordByKeyOrName(state.Logistics.deliveries, keyOrName)

    if deliveryRecord == nil then
        return false, "delivery_not_found"
    end

    local payload = deliveryRecord.payload or {}
    local applied = false

    if deliveryRecord.targetHubKey ~= nil then
        local hubRecord, hubKey = findHubByKeyOrName(deliveryRecord.targetHubKey)

        if hubRecord ~= nil then
            applyPayloadToHub(hubRecord, payload)
            state.Logistics.hubs[hubKey] = hubRecord
            applied = true
        end
    end

    if deliveryRecord.targetZoneKey ~= nil then
        local zoneRecord = findZoneByKeyOrName(deliveryRecord.targetZoneKey)

        if zoneRecord ~= nil then
            applyPayloadToZone(zoneRecord, payload)
            applied = true
        end
    end

    if deliveryRecord.targetFobKey ~= nil then
        local fobRecord, fobKey = getFobByKey(deliveryRecord.targetFobKey)

        if fobRecord ~= nil then
            applyPayloadToFob(fobRecord, payload)
            state.Logistics.fobs[fobKey] = fobRecord
            applied = true
        end
    end

    deliveryRecord.status = DeliverySystem.status.DELIVERED
    deliveryRecord.statusReason = reason or "delivery_completed"
    deliveryRecord.deliveredAt = getCurrentTime()
    deliveryRecord.updatedAt = getCurrentTime()
    deliveryRecord.payloadApplied = applied

    state.Logistics.deliveries[key] = deliveryRecord

    table.insert(state.Logistics.deliveryHistory, copyValue(deliveryRecord))

    updateStatistics()
    markDirty("logistics_delivery_completed")

    logInfo(
        "Delivery completed: "
        .. tostring(deliveryRecord.key)
        .. " payloadApplied="
        .. tostring(applied)
    )

    return true, deliveryRecord
end

function DeliverySystem.failDelivery(keyOrName, reason)
    return DeliverySystem.setDeliveryStatus(keyOrName, DeliverySystem.status.FAILED, reason or "delivery_failed")
end

function DeliverySystem.cancelDelivery(keyOrName, reason)
    return DeliverySystem.setDeliveryStatus(keyOrName, DeliverySystem.status.CANCELLED, reason or "delivery_cancelled")
end

function DeliverySystem.getStatistics()
    updateStatistics()

    local state = ensureLogisticsState()

    if state == nil then
        return {}
    end

    return state.Logistics.statistics
end

function DeliverySystem.getHubSummary()
    local state = ensureLogisticsState()

    if state == nil then
        return {}
    end

    updateStatistics()

    return {
        total = countTableKeys(state.Logistics.hubs),
        blue = state.Logistics.statistics.blueHubs or 0,
        red = state.Logistics.statistics.redHubs or 0,
        neutral = state.Logistics.statistics.neutralHubs or 0,
        contested = state.Logistics.statistics.contestedHubs or 0,
        active = state.Logistics.statistics.activeHubs or 0,
        limited = state.Logistics.statistics.limitedHubs or 0,
        locked = state.Logistics.statistics.lockedHubs or 0
    }
end

function DeliverySystem.start()
    if DeliverySystem.started == true and DeliverySystem.finished == true and DeliverySystem.failed ~= true then
        logDebug("Logistics delivery system already started")
        return true
    end

    DeliverySystem.started = true
    DeliverySystem.finished = false
    DeliverySystem.failed = false
    DeliverySystem.lastUpdateTime = getCurrentTime()

    setModuleStatus("STARTING")
    setFeatureStatus(false)

    logInfo("Logistics delivery system started")

    local state = ensureLogisticsState()

    if state == nil then
        DeliverySystem.failed = true
        setModuleStatus("FAILED")
        setFeatureStatus(false)
        logError("Logistics delivery system failed: state_unavailable")
        return false
    end

    local built, result = DeliverySystem.buildHubsFromZones()

    if built ~= true then
        DeliverySystem.failed = true
        setModuleStatus("FAILED")
        setFeatureStatus(false)
        logError("Logistics delivery system failed during hub build: " .. tostring(result))
        return false
    end

    updateStatistics()

    DeliverySystem.finished = true
    DeliverySystem.failed = false

    setModuleStatus("READY")
    setFeatureStatus(true)

    local summary = DeliverySystem.getHubSummary()

    logInfo(
        "Logistics hub summary: total="
        .. tostring(summary.total)
        .. ", blue="
        .. tostring(summary.blue)
        .. ", red="
        .. tostring(summary.red)
        .. ", neutral="
        .. tostring(summary.neutral)
        .. ", active="
        .. tostring(summary.active)
        .. ", limited="
        .. tostring(summary.limited)
        .. ", locked="
        .. tostring(summary.locked)
    )

    logInfo("Logistics delivery system initialized")

    return true
end

function DeliverySystem.stop()
    DeliverySystem.started = false
    setModuleStatus("STOPPED")
    logInfo("Logistics delivery system stopped")
    return true
end

function DeliverySystem.summary()
    local state = ensureLogisticsState()
    local logistics = nil

    if state ~= nil then
        logistics = state.Logistics
    end

    updateStatistics()

    return {
        name = DeliverySystem.name,
        displayName = DeliverySystem.displayName,
        path = DeliverySystem.path,
        version = DeliverySystem.version,
        loaded = DeliverySystem.loaded,
        started = DeliverySystem.started,
        finished = DeliverySystem.finished,
        failed = DeliverySystem.failed,
        lastUpdateTime = DeliverySystem.lastUpdateTime,
        lastHubBuildTime = DeliverySystem.lastHubBuildTime,
        lastHubCount = DeliverySystem.lastHubCount,
        lastDeliveryCount = DeliverySystem.lastDeliveryCount,
        statistics = logistics and logistics.statistics or nil,
        logistics = logistics
    }
end

TC.Logistics.Delivery = DeliverySystem
TC.logistics.Delivery = DeliverySystem

TC.modules.logisticsDelivery = {
    name = DeliverySystem.name,
    path = DeliverySystem.path,
    loaded = true,
    version = DeliverySystem.version
}

setModuleStatus("LOADED")
logInfo("Loaded " .. DeliverySystem.path .. " v" .. DeliverySystem.version)

return DeliverySystem
