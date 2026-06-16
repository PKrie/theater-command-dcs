-- Theater Command DCS
-- File: src/world/tc_zone_factory.lua
--
-- Purpose:
--   Create virtual Theater Command campaign zones from classified airbase data
--   and optional Mission Editor zones.
--
-- Current focus:
--   The Airbase Scanner now classifies Syria airbase-like objects. The Zone
--   Factory must no longer create equal campaign zones for all 225 detected
--   DCS airbase-like objects. It should only create useful campaign zones and
--   preserve classification data for later capture, mission, logistics and
--   persistence systems.
--
-- Version:
--   0.2.0
--
-- Direct dependencies:
--   - DCS runtime: env, timer
--   - Theater Command: TC.State, TC.Logger, TC.Utils, TC.World.AirbaseScanner
--   - MIST: optional Mission Editor zone import via mist.DBs.zonesByName/zones
--
-- Vendor note:
--   MOOSE, CTLD and Skynet IADS are not modified or directly used here.

TC = TC or {}
TC.modules = TC.modules or {}
TC.World = TC.World or {}
TC.world = TC.world or TC.World

local ZoneFactory = {}

ZoneFactory.name = "tc_zone_factory"
ZoneFactory.displayName = "Zone Factory"
ZoneFactory.path = "src/world/tc_zone_factory.lua"
ZoneFactory.version = "0.2.0"

ZoneFactory.loaded = true
ZoneFactory.started = false
ZoneFactory.finished = false
ZoneFactory.failed = false

ZoneFactory.registry = {}
ZoneFactory.lastBuildTime = 0
ZoneFactory.lastAirbaseZonesCreated = 0
ZoneFactory.lastMissionEditorZonesCreated = 0
ZoneFactory.lastAirbaseObjectsSkipped = 0

ZoneFactory.zoneClasses = {
    STRATEGIC_AIRBASE_ZONE = "STRATEGIC_AIRBASE_ZONE",
    SECONDARY_AIRBASE_ZONE = "SECONDARY_AIRBASE_ZONE",
    HELIPORT_ZONE = "HELIPORT_ZONE",
    FARP_ZONE = "FARP_ZONE",
    TACTICAL_PAD_ZONE = "TACTICAL_PAD_ZONE",
    MISSION_EDITOR_CAPTURE_ZONE = "MISSION_EDITOR_CAPTURE_ZONE",
    MISSION_EDITOR_ZONE = "MISSION_EDITOR_ZONE",
    UNKNOWN_ZONE = "UNKNOWN_ZONE"
}

ZoneFactory.airbaseClassifications = {
    STRATEGIC_AIRFIELD = "STRATEGIC_AIRFIELD",
    SECONDARY_AIRFIELD = "SECONDARY_AIRFIELD",
    HELIPORT = "HELIPORT",
    HELIPAD = "HELIPAD",
    MEDICAL_PAD = "MEDICAL_PAD",
    FARP = "FARP",
    TACTICAL_PAD = "TACTICAL_PAD",
    UNKNOWN = "UNKNOWN"
}

ZoneFactory.defaultRadii = {
    STRATEGIC_AIRFIELD = 12000,
    SECONDARY_AIRFIELD = 8000,
    HELIPORT = 4000,
    FARP = 3500,
    TACTICAL_PAD = 2500,
    HELIPAD = 2000,
    MEDICAL_PAD = 1500,
    UNKNOWN = 1000,

    AIRDROME = 8000,
    SHIP = 12000,
    START_BASE = 15000,
    MISSION_EDITOR = 10000
}

ZoneFactory.allowedMissionEditorPrefixes = {
    "CAPTURE_",
    "TC_ZONE_"
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
    local formatted = "[TC][ZONE_FACTORY] " .. tostring(message)

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
        logger.info("[ZoneFactory] " .. tostring(message))
        return
    end

    rawLog("INFO", message)
end

local function logWarn(message)
    local logger = getLogger()

    if logger ~= nil and logger.warn ~= nil then
        logger.warn("[ZoneFactory] " .. tostring(message))
        return
    end

    rawLog("WARN", message)
end

local function logError(message)
    local logger = getLogger()

    if logger ~= nil and logger.error ~= nil then
        logger.error("[ZoneFactory] " .. tostring(message))
        return
    end

    rawLog("ERROR", message)
end

local function logDebug(message)
    local logger = getLogger()

    if logger ~= nil and logger.debug ~= nil then
        logger.debug("[ZoneFactory] " .. tostring(message))
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

local function startsWith(value, prefix)
    local utils = getUtils()

    if utils ~= nil and utils.startsWith ~= nil then
        return utils.startsWith(value, prefix)
    end

    if type(value) ~= "string" or type(prefix) ~= "string" then
        return false
    end

    return string.sub(value, 1, string.len(prefix)) == prefix
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

local function distance2d(pointA, pointB)
    local utils = getUtils()

    if utils ~= nil and utils.distance2d ~= nil then
        return utils.distance2d(pointA, pointB)
    end

    if type(pointA) ~= "table" or type(pointB) ~= "table" then
        return nil
    end

    local ax = pointA.x or pointA[1]
    local az = pointA.z or pointA.y or pointA[2]
    local bx = pointB.x or pointB[1]
    local bz = pointB.z or pointB.y or pointB[2]

    if type(ax) ~= "number" or type(az) ~= "number" then
        return nil
    end

    if type(bx) ~= "number" or type(bz) ~= "number" then
        return nil
    end

    local deltaX = ax - bx
    local deltaZ = az - bz

    return math.sqrt(deltaX * deltaX + deltaZ * deltaZ)
end

local function getAirbaseScanner()
    if TC.World == nil then
        return nil
    end

    return TC.World.AirbaseScanner
end

local function getAirbaseRegistry()
    local airbaseScanner = getAirbaseScanner()

    if airbaseScanner ~= nil and airbaseScanner.getRegistry ~= nil then
        return airbaseScanner.getRegistry()
    end

    local state = getState()

    if state ~= nil and state.Bases ~= nil and state.Bases.registry ~= nil then
        return state.Bases.registry
    end

    return {}
end

local function ensureAirbaseData()
    local registry = getAirbaseRegistry()

    if countTableKeys(registry) > 0 then
        return true
    end

    local airbaseScanner = getAirbaseScanner()

    if airbaseScanner ~= nil and airbaseScanner.scan ~= nil then
        logInfo("Zone factory requested airbase scan because no airbases were registered yet")

        local success = airbaseScanner.scan()

        if success == true then
            return true
        end
    end

    return false
end

local function createEmptyZoneTables()
    return {
        registry = {},
        byZoneClass = {},
        byAirbaseClassification = {},

        strategicAirbaseZones = {},
        secondaryAirbaseZones = {},
        heliportZones = {},
        farpZones = {},
        tacticalPadZones = {},
        missionEditorZones = {},

        captureZones = {},
        missionZones = {},
        logisticsZones = {},
        startBaseZones = {},

        excludedAirbaseObjects = {}
    }
end

local function ensureStateTables()
    local state = getState()

    if state == nil then
        return nil
    end

    state.World = state.World or {}
    state.Zones = state.Zones or {}

    state.Zones.total = 0
    state.Zones.blue = 0
    state.Zones.red = 0
    state.Zones.neutral = 0
    state.Zones.contested = 0
    state.Zones.unknown = 0

    state.Zones.registry = {}
    state.Zones.byZoneClass = {}
    state.Zones.byAirbaseClassification = {}

    state.Zones.strategicAirbaseZones = {}
    state.Zones.secondaryAirbaseZones = {}
    state.Zones.heliportZones = {}
    state.Zones.farpZones = {}
    state.Zones.tacticalPadZones = {}
    state.Zones.missionEditorZones = {}

    state.Zones.captureZones = {}
    state.Zones.missionZones = {}
    state.Zones.logisticsZones = {}
    state.Zones.startBaseZones = {}

    state.Zones.excludedAirbaseObjects = {}

    state.Zones.statistics = {
        airbaseObjectsEvaluated = 0,
        airbaseZonesCreated = 0,
        missionEditorZonesCreated = 0,
        airbaseObjectsSkipped = 0,
        totalZonesCreated = 0
    }

    return state
end

local function incrementOwnerCounter(state, owner)
    if state == nil or state.Zones == nil then
        return
    end

    if owner == "BLUE" then
        state.Zones.blue = (state.Zones.blue or 0) + 1
    elseif owner == "RED" then
        state.Zones.red = (state.Zones.red or 0) + 1
    elseif owner == "NEUTRAL" then
        state.Zones.neutral = (state.Zones.neutral or 0) + 1
    elseif owner == "CONTESTED" then
        state.Zones.contested = (state.Zones.contested or 0) + 1
    else
        state.Zones.unknown = (state.Zones.unknown or 0) + 1
    end
end

local function addRecordToList(targetList, key, record)
    if type(targetList) ~= "table" then
        return false
    end

    if key == nil or record == nil then
        return false
    end

    targetList[key] = record
    return true
end

local function buildZoneKey(prefix, normalizedName)
    local baseKey = tostring(prefix or "ZONE") .. "_" .. tostring(normalizedName or "UNKNOWN_ZONE")
    local key = baseKey
    local index = 2

    while ZoneFactory.registry[key] ~= nil do
        key = baseKey .. "_" .. tostring(index)
        index = index + 1
    end

    return key
end

local function getAirbaseClassification(airbaseRecord)
    if type(airbaseRecord) ~= "table" then
        return ZoneFactory.airbaseClassifications.UNKNOWN
    end

    if airbaseRecord.classification ~= nil then
        return airbaseRecord.classification
    end

    if airbaseRecord.airbaseType ~= nil then
        return airbaseRecord.airbaseType
    end

    if airbaseRecord.isStrategicAirfield == true then
        return ZoneFactory.airbaseClassifications.STRATEGIC_AIRFIELD
    end

    if airbaseRecord.isSecondaryAirfield == true then
        return ZoneFactory.airbaseClassifications.SECONDARY_AIRFIELD
    end

    if airbaseRecord.isHeliport == true then
        return ZoneFactory.airbaseClassifications.HELIPORT
    end

    if airbaseRecord.isFarp == true then
        return ZoneFactory.airbaseClassifications.FARP
    end

    if airbaseRecord.isTacticalPad == true then
        return ZoneFactory.airbaseClassifications.TACTICAL_PAD
    end

    if airbaseRecord.isHelipad == true then
        return ZoneFactory.airbaseClassifications.HELIPAD
    end

    if airbaseRecord.isMedicalPad == true then
        return ZoneFactory.airbaseClassifications.MEDICAL_PAD
    end

    if airbaseRecord.categoryName == "AIRDROME" then
        return ZoneFactory.airbaseClassifications.SECONDARY_AIRFIELD
    end

    if airbaseRecord.categoryName == "HELIPAD" then
        return ZoneFactory.airbaseClassifications.HELIPAD
    end

    return ZoneFactory.airbaseClassifications.UNKNOWN
end

local function getZoneClassForAirbase(airbaseRecord)
    local classification = getAirbaseClassification(airbaseRecord)

    if airbaseRecord ~= nil then
        if airbaseRecord.recommendedZoneClass ~= nil then
            return airbaseRecord.recommendedZoneClass
        end

        if type(airbaseRecord.zoneProfile) == "table" and airbaseRecord.zoneProfile.zoneClass ~= nil then
            return airbaseRecord.zoneProfile.zoneClass
        end
    end

    if classification == ZoneFactory.airbaseClassifications.STRATEGIC_AIRFIELD then
        return ZoneFactory.zoneClasses.STRATEGIC_AIRBASE_ZONE
    end

    if classification == ZoneFactory.airbaseClassifications.SECONDARY_AIRFIELD then
        return ZoneFactory.zoneClasses.SECONDARY_AIRBASE_ZONE
    end

    if classification == ZoneFactory.airbaseClassifications.HELIPORT then
        return ZoneFactory.zoneClasses.HELIPORT_ZONE
    end

    if classification == ZoneFactory.airbaseClassifications.FARP then
        return ZoneFactory.zoneClasses.FARP_ZONE
    end

    if classification == ZoneFactory.airbaseClassifications.TACTICAL_PAD then
        return ZoneFactory.zoneClasses.TACTICAL_PAD_ZONE
    end

    return ZoneFactory.zoneClasses.UNKNOWN_ZONE
end

local function getRadiusForAirbase(airbaseRecord)
    if type(airbaseRecord) ~= "table" then
        return ZoneFactory.defaultRadii.UNKNOWN
    end

    if type(airbaseRecord.recommendedZoneRadius) == "number" then
        return airbaseRecord.recommendedZoneRadius
    end

    if type(airbaseRecord.zoneProfile) == "table" and type(airbaseRecord.zoneProfile.recommendedRadius) == "number" then
        return airbaseRecord.zoneProfile.recommendedRadius
    end

    if airbaseRecord.isStartBase == true then
        return ZoneFactory.defaultRadii.START_BASE
    end

    local classification = getAirbaseClassification(airbaseRecord)

    if ZoneFactory.defaultRadii[classification] ~= nil then
        return ZoneFactory.defaultRadii[classification]
    end

    if airbaseRecord.categoryName ~= nil and ZoneFactory.defaultRadii[airbaseRecord.categoryName] ~= nil then
        return ZoneFactory.defaultRadii[airbaseRecord.categoryName]
    end

    return ZoneFactory.defaultRadii.UNKNOWN
end

local function shouldCreateAirbaseZone(airbaseRecord)
    if type(airbaseRecord) ~= "table" then
        return false, "invalid_airbase_record"
    end

    if airbaseRecord.isStartBase == true then
        return true, "blue_start_base"
    end

    if airbaseRecord.canCreateCaptureZone == true then
        return true, "capture_candidate"
    end

    if airbaseRecord.canCreateMissionZone == true then
        return true, "mission_candidate"
    end

    if airbaseRecord.canCreateLogisticsZone == true then
        return true, "logistics_candidate"
    end

    if airbaseRecord.isCaptureCandidate == true then
        return true, "capture_candidate"
    end

    if airbaseRecord.isMissionCandidate == true then
        return true, "mission_candidate"
    end

    if airbaseRecord.isLogisticsCandidate == true then
        return true, "logistics_candidate"
    end

    local classification = getAirbaseClassification(airbaseRecord)

    if classification == ZoneFactory.airbaseClassifications.STRATEGIC_AIRFIELD then
        return true, "strategic_airfield"
    end

    if classification == ZoneFactory.airbaseClassifications.SECONDARY_AIRFIELD then
        return true, "secondary_airfield"
    end

    if classification == ZoneFactory.airbaseClassifications.HELIPORT then
        return true, "heliport"
    end

    if classification == ZoneFactory.airbaseClassifications.FARP then
        return true, "farp"
    end

    if classification == ZoneFactory.airbaseClassifications.TACTICAL_PAD then
        return true, "tactical_pad"
    end

    return false, "not_campaign_zone_candidate"
end

local function determineAirbaseZonePurpose(airbaseRecord)
    local classification = getAirbaseClassification(airbaseRecord)

    local canCapture =
        airbaseRecord.canCreateCaptureZone == true
        or airbaseRecord.isCaptureCandidate == true
        or classification == ZoneFactory.airbaseClassifications.STRATEGIC_AIRFIELD
        or classification == ZoneFactory.airbaseClassifications.SECONDARY_AIRFIELD

    local canMission =
        airbaseRecord.canCreateMissionZone == true
        or airbaseRecord.isMissionCandidate == true
        or classification == ZoneFactory.airbaseClassifications.STRATEGIC_AIRFIELD
        or classification == ZoneFactory.airbaseClassifications.SECONDARY_AIRFIELD

    local canLogistics =
        airbaseRecord.canCreateLogisticsZone == true
        or airbaseRecord.isLogisticsCandidate == true
        or airbaseRecord.isStartBase == true
        or classification == ZoneFactory.airbaseClassifications.STRATEGIC_AIRFIELD
        or classification == ZoneFactory.airbaseClassifications.SECONDARY_AIRFIELD
        or classification == ZoneFactory.airbaseClassifications.HELIPORT
        or classification == ZoneFactory.airbaseClassifications.FARP
        or classification == ZoneFactory.airbaseClassifications.TACTICAL_PAD

    return canCapture, canMission, canLogistics
end

local function determineOwnerFromZoneName(normalizedName, fallbackOwner)
    local blueOwnership = getConstant("ownership", "BLUE", "BLUE")
    local redOwnership = getConstant("ownership", "RED", "RED")
    local neutralOwnership = getConstant("ownership", "NEUTRAL", "NEUTRAL")
    local contestedOwnership = getConstant("ownership", "CONTESTED", "CONTESTED")

    if startsWith(normalizedName, "CAPTURE_BLUE_") == true then
        return blueOwnership
    end

    if startsWith(normalizedName, "CAPTURE_RED_") == true then
        return redOwnership
    end

    if startsWith(normalizedName, "CAPTURE_NEUTRAL_") == true then
        return neutralOwnership
    end

    if startsWith(normalizedName, "CAPTURE_CONTESTED_") == true then
        return contestedOwnership
    end

    if startsWith(normalizedName, "TC_ZONE_BLUE_") == true then
        return blueOwnership
    end

    if startsWith(normalizedName, "TC_ZONE_RED_") == true then
        return redOwnership
    end

    if startsWith(normalizedName, "TC_ZONE_NEUTRAL_") == true then
        return neutralOwnership
    end

    return fallbackOwner or getConstant("ownership", "UNKNOWN", "UNKNOWN")
end

local function isAllowedMissionEditorZone(normalizedName)
    if type(normalizedName) ~= "string" then
        return false
    end

    for _, prefix in ipairs(ZoneFactory.allowedMissionEditorPrefixes) do
        if startsWith(normalizedName, prefix) == true then
            return true
        end
    end

    return false
end

local function getMissionEditorZoneClass(normalizedName)
    if startsWith(normalizedName, "CAPTURE_") == true then
        return ZoneFactory.zoneClasses.MISSION_EDITOR_CAPTURE_ZONE
    end

    return ZoneFactory.zoneClasses.MISSION_EDITOR_ZONE
end

local function extractPoint(zoneData)
    if type(zoneData) ~= "table" then
        return { x = 0, y = 0, z = 0 }
    end

    local point = zoneData.point or zoneData.center or zoneData.position

    if type(point) == "table" then
        local x = point.x or point[1] or 0
        local y = point.y or 0
        local z = point.z or point[2] or point.y or 0

        if point.z == nil then
            y = 0
        end

        return { x = x, y = y, z = z }
    end

    return {
        x = zoneData.x or 0,
        y = zoneData.y or 0,
        z = zoneData.z or zoneData.y or 0
    }
end

local function extractRadius(zoneData)
    if type(zoneData) ~= "table" then
        return ZoneFactory.defaultRadii.MISSION_EDITOR
    end

    if type(zoneData.radius) == "number" then
        return zoneData.radius
    end

    if type(zoneData.r) == "number" then
        return zoneData.r
    end

    return ZoneFactory.defaultRadii.MISSION_EDITOR
end

local function findNearestAirbase(point)
    local airbases = getAirbaseRegistry()
    local nearestRecord = nil
    local nearestDistance = nil

    for _, airbaseRecord in pairs(airbases) do
        if type(airbaseRecord) == "table" and airbaseRecord.position ~= nil then
            local distance = distance2d(point, airbaseRecord.position)

            if distance ~= nil then
                if nearestDistance == nil or distance < nearestDistance then
                    nearestDistance = distance
                    nearestRecord = airbaseRecord
                end
            end
        end
    end

    return nearestRecord, nearestDistance
end

local function createAirbaseZoneRecord(airbaseRecord)
    if type(airbaseRecord) ~= "table" then
        return nil
    end

    local shouldCreate, creationReason = shouldCreateAirbaseZone(airbaseRecord)

    if shouldCreate ~= true then
        return nil, creationReason
    end

    local normalizedName = airbaseRecord.normalizedName or normalizeName(airbaseRecord.name) or "UNKNOWN_AIRBASE"
    local zoneName = "ZONE_AIRBASE_" .. normalizedName
    local zoneKey = buildZoneKey("ZONE_AIRBASE", normalizedName)
    local activeStatus = getConstant("status", "ACTIVE", "ACTIVE")
    local owner = airbaseRecord.currentOwner or airbaseRecord.initialOwner or getConstant("ownership", "UNKNOWN", "UNKNOWN")

    local classification = getAirbaseClassification(airbaseRecord)
    local zoneClass = getZoneClassForAirbase(airbaseRecord)
    local canCapture, canMission, canLogistics = determineAirbaseZonePurpose(airbaseRecord)

    return {
        key = zoneKey,
        name = zoneName,
        displayName = zoneName,
        normalizedName = normalizeName(zoneName),

        type = "AIRBASE_ZONE",
        zoneClass = zoneClass,
        source = "AIRBASE_REGISTRY",
        creationReason = creationReason,

        status = activeStatus,
        initialOwner = owner,
        currentOwner = owner,

        theatreArea = airbaseRecord.theatreArea or "UNKNOWN",
        center = airbaseRecord.position or { x = 0, y = 0, z = 0 },
        radius = getRadiusForAirbase(airbaseRecord),

        linkedAirbaseKey = airbaseRecord.key,
        linkedAirbaseName = airbaseRecord.name,

        airbaseClassification = classification,
        airbaseCategoryName = airbaseRecord.categoryName,
        airbaseCategoryId = airbaseRecord.categoryId,
        airbaseClassificationReason = airbaseRecord.classificationReason,
        airbaseClassificationKeyword = airbaseRecord.classificationKeyword,

        strategicRelevance = airbaseRecord.strategicRelevance or 0,

        isStartBaseZone = airbaseRecord.isStartBase == true,
        isVirtual = true,

        isCaptureZone = canCapture == true,
        isMissionZone = canMission == true,
        isLogisticsZone = canLogistics == true,

        isStrategicAirbaseZone = classification == ZoneFactory.airbaseClassifications.STRATEGIC_AIRFIELD,
        isSecondaryAirbaseZone = classification == ZoneFactory.airbaseClassifications.SECONDARY_AIRFIELD,
        isHeliportZone = classification == ZoneFactory.airbaseClassifications.HELIPORT,
        isFarpZone = classification == ZoneFactory.airbaseClassifications.FARP,
        isTacticalPadZone = classification == ZoneFactory.airbaseClassifications.TACTICAL_PAD,

        createdAt = getCurrentTime()
    }
end

local function createMissionEditorZoneRecord(rawName, zoneData)
    local normalizedName = normalizeName(rawName) or "UNKNOWN_ZONE"
    local center = extractPoint(zoneData)
    local nearestAirbase, nearestDistance = findNearestAirbase(center)

    local fallbackOwner = getConstant("ownership", "UNKNOWN", "UNKNOWN")
    local theatreArea = "UNKNOWN"

    if nearestAirbase ~= nil then
        fallbackOwner = nearestAirbase.currentOwner or nearestAirbase.initialOwner or fallbackOwner
        theatreArea = nearestAirbase.theatreArea or theatreArea
    end

    local owner = determineOwnerFromZoneName(normalizedName, fallbackOwner)
    local activeStatus = getConstant("status", "ACTIVE", "ACTIVE")
    local zoneKey = buildZoneKey("ZONE_ME", normalizedName)
    local zoneClass = getMissionEditorZoneClass(normalizedName)

    return {
        key = zoneKey,
        name = rawName,
        displayName = rawName,
        normalizedName = normalizedName,

        type = "MISSION_EDITOR_ZONE",
        zoneClass = zoneClass,
        source = "MIST_ZONE_DATABASE",

        status = activeStatus,
        initialOwner = owner,
        currentOwner = owner,

        theatreArea = theatreArea,
        center = center,
        radius = extractRadius(zoneData),

        linkedAirbaseKey = nearestAirbase and nearestAirbase.key or nil,
        linkedAirbaseName = nearestAirbase and nearestAirbase.name or nil,
        linkedAirbaseDistance = nearestDistance,

        airbaseClassification = nearestAirbase and getAirbaseClassification(nearestAirbase) or nil,

        isStartBaseZone = false,
        isVirtual = false,

        isCaptureZone = zoneClass == ZoneFactory.zoneClasses.MISSION_EDITOR_CAPTURE_ZONE,
        isMissionZone = true,
        isLogisticsZone = startsWith(normalizedName, "TC_ZONE_LOGISTICS_") == true,

        createdAt = getCurrentTime()
    }
end

local function registerZoneInStateLists(state, zoneRecord)
    if state == nil or state.Zones == nil or zoneRecord == nil then
        return
    end

    state.Zones.byZoneClass[zoneRecord.zoneClass] = state.Zones.byZoneClass[zoneRecord.zoneClass] or {}
    addRecordToList(state.Zones.byZoneClass[zoneRecord.zoneClass], zoneRecord.key, zoneRecord)

    if zoneRecord.airbaseClassification ~= nil then
        state.Zones.byAirbaseClassification[zoneRecord.airbaseClassification] =
            state.Zones.byAirbaseClassification[zoneRecord.airbaseClassification] or {}

        addRecordToList(
            state.Zones.byAirbaseClassification[zoneRecord.airbaseClassification],
            zoneRecord.key,
            zoneRecord
        )
    end

    if zoneRecord.isStrategicAirbaseZone == true then
        addRecordToList(state.Zones.strategicAirbaseZones, zoneRecord.key, zoneRecord)
    end

    if zoneRecord.isSecondaryAirbaseZone == true then
        addRecordToList(state.Zones.secondaryAirbaseZones, zoneRecord.key, zoneRecord)
    end

    if zoneRecord.isHeliportZone == true then
        addRecordToList(state.Zones.heliportZones, zoneRecord.key, zoneRecord)
    end

    if zoneRecord.isFarpZone == true then
        addRecordToList(state.Zones.farpZones, zoneRecord.key, zoneRecord)
    end

    if zoneRecord.isTacticalPadZone == true then
        addRecordToList(state.Zones.tacticalPadZones, zoneRecord.key, zoneRecord)
    end

    if zoneRecord.type == "MISSION_EDITOR_ZONE" then
        addRecordToList(state.Zones.missionEditorZones, zoneRecord.key, zoneRecord)
    end

    if zoneRecord.isCaptureZone == true then
        addRecordToList(state.Zones.captureZones, zoneRecord.key, zoneRecord)
    end

    if zoneRecord.isMissionZone == true then
        addRecordToList(state.Zones.missionZones, zoneRecord.key, zoneRecord)
    end

    if zoneRecord.isLogisticsZone == true then
        addRecordToList(state.Zones.logisticsZones, zoneRecord.key, zoneRecord)
    end

    if zoneRecord.isStartBaseZone == true then
        addRecordToList(state.Zones.startBaseZones, zoneRecord.key, zoneRecord)
    end
end

local function registerZone(zoneRecord)
    if zoneRecord == nil or zoneRecord.key == nil then
        return false
    end

    local state = getState()

    ZoneFactory.registry[zoneRecord.key] = zoneRecord

    TC.World.Zones = TC.World.Zones or {}
    TC.World.Zones[zoneRecord.key] = zoneRecord

    if state ~= nil and state.Zones ~= nil and state.Zones.registry ~= nil then
        state.Zones.registry[zoneRecord.key] = zoneRecord
        state.Zones.total = (state.Zones.total or 0) + 1
        incrementOwnerCounter(state, zoneRecord.currentOwner)
        registerZoneInStateLists(state, zoneRecord)
    end

    return true
end

local function getMistZones()
    if mist == nil then
        return false, "mist_unavailable"
    end

    if mist.DBs == nil then
        return false, "mist_DBs_unavailable"
    end

    if type(mist.DBs.zonesByName) == "table" then
        return true, mist.DBs.zonesByName
    end

    if type(mist.DBs.zones) == "table" then
        return true, mist.DBs.zones
    end

    return false, "mist_zone_database_unavailable"
end

local function registerExcludedAirbase(state, airbaseRecord, reason)
    if state == nil or state.Zones == nil then
        return
    end

    if type(airbaseRecord) ~= "table" then
        return
    end

    local key = airbaseRecord.key or airbaseRecord.normalizedName or airbaseRecord.name

    if key == nil then
        key = "UNKNOWN_EXCLUDED_AIRBASE_" .. tostring(countTableKeys(state.Zones.excludedAirbaseObjects) + 1)
    end

    state.Zones.excludedAirbaseObjects[key] = {
        key = key,
        name = airbaseRecord.name,
        normalizedName = airbaseRecord.normalizedName,
        classification = getAirbaseClassification(airbaseRecord),
        categoryName = airbaseRecord.categoryName,
        theatreArea = airbaseRecord.theatreArea,
        owner = airbaseRecord.currentOwner or airbaseRecord.initialOwner,
        reason = reason or "not_campaign_zone_candidate"
    }
end

local function buildZoneSummary()
    local state = getState()
    local zones = state and state.Zones or {}

    return {
        total = ZoneFactory.getCount(),
        strategicAirbaseZones = countTableKeys(zones.strategicAirbaseZones),
        secondaryAirbaseZones = countTableKeys(zones.secondaryAirbaseZones),
        heliportZones = countTableKeys(zones.heliportZones),
        farpZones = countTableKeys(zones.farpZones),
        tacticalPadZones = countTableKeys(zones.tacticalPadZones),
        missionEditorZones = countTableKeys(zones.missionEditorZones),
        captureZones = countTableKeys(zones.captureZones),
        missionZones = countTableKeys(zones.missionZones),
        logisticsZones = countTableKeys(zones.logisticsZones),
        startBaseZones = countTableKeys(zones.startBaseZones),
        excludedAirbaseObjects = countTableKeys(zones.excludedAirbaseObjects)
    }
end

local function buildZoneSummaryText(summary)
    return "total=" .. tostring(summary.total)
        .. ", strategic=" .. tostring(summary.strategicAirbaseZones)
        .. ", secondary=" .. tostring(summary.secondaryAirbaseZones)
        .. ", heliports=" .. tostring(summary.heliportZones)
        .. ", farps=" .. tostring(summary.farpZones)
        .. ", tactical=" .. tostring(summary.tacticalPadZones)
        .. ", missionEditor=" .. tostring(summary.missionEditorZones)
        .. ", captureZones=" .. tostring(summary.captureZones)
        .. ", missionZones=" .. tostring(summary.missionZones)
        .. ", logisticsZones=" .. tostring(summary.logisticsZones)
        .. ", startBaseZones=" .. tostring(summary.startBaseZones)
        .. ", excludedAirbaseObjects=" .. tostring(summary.excludedAirbaseObjects)
end

function ZoneFactory.reset()
    ZoneFactory.registry = {}
    ZoneFactory.lastAirbaseZonesCreated = 0
    ZoneFactory.lastMissionEditorZonesCreated = 0
    ZoneFactory.lastAirbaseObjectsSkipped = 0

    TC.World.Zones = {}

    local state = ensureStateTables()

    if state ~= nil then
        state.World.zoneFactoryComplete = false
    end

    return true
end

function ZoneFactory.buildAirbaseZones()
    local airbases = getAirbaseRegistry()
    local state = getState()
    local created = 0
    local skipped = 0
    local evaluated = 0

    for _, airbaseRecord in pairs(airbases) do
        evaluated = evaluated + 1

        local zoneRecord, skipReason = createAirbaseZoneRecord(airbaseRecord)

        if zoneRecord ~= nil then
            if registerZone(zoneRecord) == true then
                created = created + 1
                logDebug(
                    "Airbase zone created: "
                    .. tostring(zoneRecord.name)
                    .. " ["
                    .. tostring(zoneRecord.zoneClass)
                    .. ", "
                    .. tostring(zoneRecord.currentOwner)
                    .. "]"
                )
            end
        else
            skipped = skipped + 1
            registerExcludedAirbase(state, airbaseRecord, skipReason)
        end
    end

    ZoneFactory.lastAirbaseZonesCreated = created
    ZoneFactory.lastAirbaseObjectsSkipped = skipped

    if state ~= nil and state.Zones ~= nil and state.Zones.statistics ~= nil then
        state.Zones.statistics.airbaseObjectsEvaluated = evaluated
        state.Zones.statistics.airbaseZonesCreated = created
        state.Zones.statistics.airbaseObjectsSkipped = skipped
    end

    return created
end

function ZoneFactory.buildMissionEditorZones()
    local success, zonesOrReason = getMistZones()

    if success ~= true then
        logDebug("Mission Editor zone import skipped: " .. tostring(zonesOrReason))
        ZoneFactory.lastMissionEditorZonesCreated = 0
        return 0
    end

    local created = 0

    for zoneName, zoneData in pairs(zonesOrReason) do
        local rawName = zoneName

        if type(zoneData) == "table" and type(zoneData.name) == "string" then
            rawName = zoneData.name
        end

        local normalizedName = normalizeName(rawName)

        if isAllowedMissionEditorZone(normalizedName) == true then
            local zoneRecord = createMissionEditorZoneRecord(rawName, zoneData)

            if registerZone(zoneRecord) == true then
                created = created + 1
                logDebug(
                    "Mission Editor zone registered: "
                    .. tostring(zoneRecord.name)
                    .. " ["
                    .. tostring(zoneRecord.currentOwner)
                    .. "]"
                )
            end
        end
    end

    ZoneFactory.lastMissionEditorZonesCreated = created

    local state = getState()

    if state ~= nil and state.Zones ~= nil and state.Zones.statistics ~= nil then
        state.Zones.statistics.missionEditorZonesCreated = created
    end

    return created
end

function ZoneFactory.build()
    ZoneFactory.started = true
    ZoneFactory.finished = false
    ZoneFactory.failed = false
    ZoneFactory.lastBuildTime = getCurrentTime()

    logInfo("Zone factory started")

    ZoneFactory.reset()

    local airbaseDataAvailable = ensureAirbaseData()

    if airbaseDataAvailable ~= true then
        ZoneFactory.failed = true
        logError("Zone factory failed because no airbase data is available")

        local state = getState()

        if state ~= nil and state.setModuleStatus ~= nil then
            state.setModuleStatus("zoneFactory", "FAILED")
        end

        return false
    end

    local airbaseZonesCreated = ZoneFactory.buildAirbaseZones()
    local missionEditorZonesCreated = ZoneFactory.buildMissionEditorZones()
    local totalZonesCreated = ZoneFactory.getCount()

    local state = getState()

    if state ~= nil then
        state.World = state.World or {}
        state.World.zoneFactoryComplete = true

        if state.Zones ~= nil and state.Zones.statistics ~= nil then
            state.Zones.statistics.totalZonesCreated = totalZonesCreated
        end

        if state.setFeatureStatus ~= nil then
            state.setFeatureStatus("zoneFactory", true)
        end

        if state.setModuleStatus ~= nil then
            state.setModuleStatus("zoneFactory", "BUILT")
        end

        if state.markDirty ~= nil then
            state.markDirty("zone_factory_completed")
        end
    end

    ZoneFactory.finished = true

    local summary = buildZoneSummary()

    logInfo(
        "Zone factory completed: "
        .. tostring(totalZonesCreated)
        .. " zones registered ("
        .. tostring(airbaseZonesCreated)
        .. " classified airbase zones, "
        .. tostring(missionEditorZonesCreated)
        .. " Mission Editor zones, "
        .. tostring(ZoneFactory.lastAirbaseObjectsSkipped)
        .. " airbase-like objects skipped)"
    )

    logInfo("Zone classification summary: " .. buildZoneSummaryText(summary))

    return true
end

function ZoneFactory.start()
    return ZoneFactory.build()
end

function ZoneFactory.stop()
    ZoneFactory.started = false
    logInfo("Zone factory stopped")
    return true
end

function ZoneFactory.getRegistry()
    return ZoneFactory.registry
end

function ZoneFactory.getZone(key)
    if key == nil then
        return nil
    end

    return ZoneFactory.registry[key]
end

function ZoneFactory.getZoneByName(name)
    local normalizedName = normalizeName(name)

    if normalizedName == nil then
        return nil
    end

    for _, zoneRecord in pairs(ZoneFactory.registry) do
        if zoneRecord.normalizedName == normalizedName then
            return zoneRecord
        end

        if normalizeName(zoneRecord.name) == normalizedName then
            return zoneRecord
        end

        if normalizeName(zoneRecord.displayName) == normalizedName then
            return zoneRecord
        end
    end

    return nil
end

function ZoneFactory.getCount()
    return countTableKeys(ZoneFactory.registry)
end

function ZoneFactory.getByOwner(owner)
    local result = {}

    if owner == nil then
        return result
    end

    for key, zoneRecord in pairs(ZoneFactory.registry) do
        if zoneRecord.currentOwner == owner then
            result[key] = zoneRecord
        end
    end

    return result
end

function ZoneFactory.getByType(zoneType)
    local result = {}

    if zoneType == nil then
        return result
    end

    for key, zoneRecord in pairs(ZoneFactory.registry) do
        if zoneRecord.type == zoneType then
            result[key] = zoneRecord
        end
    end

    return result
end

function ZoneFactory.getByZoneClass(zoneClass)
    local result = {}

    if zoneClass == nil then
        return result
    end

    for key, zoneRecord in pairs(ZoneFactory.registry) do
        if zoneRecord.zoneClass == zoneClass then
            result[key] = zoneRecord
        end
    end

    return result
end

function ZoneFactory.getByAirbaseClassification(classification)
    local result = {}

    if classification == nil then
        return result
    end

    for key, zoneRecord in pairs(ZoneFactory.registry) do
        if zoneRecord.airbaseClassification == classification then
            result[key] = zoneRecord
        end
    end

    return result
end

function ZoneFactory.getByTheatreArea(theatreArea)
    local result = {}

    if theatreArea == nil then
        return result
    end

    for key, zoneRecord in pairs(ZoneFactory.registry) do
        if zoneRecord.theatreArea == theatreArea then
            result[key] = zoneRecord
        end
    end

    return result
end

function ZoneFactory.getCaptureZones()
    local result = {}

    for key, zoneRecord in pairs(ZoneFactory.registry) do
        if zoneRecord.isCaptureZone == true then
            result[key] = zoneRecord
        end
    end

    return result
end

function ZoneFactory.getMissionZones()
    local result = {}

    for key, zoneRecord in pairs(ZoneFactory.registry) do
        if zoneRecord.isMissionZone == true then
            result[key] = zoneRecord
        end
    end

    return result
end

function ZoneFactory.getLogisticsZones()
    local result = {}

    for key, zoneRecord in pairs(ZoneFactory.registry) do
        if zoneRecord.isLogisticsZone == true then
            result[key] = zoneRecord
        end
    end

    return result
end

function ZoneFactory.getStartBaseZone()
    for _, zoneRecord in pairs(ZoneFactory.registry) do
        if zoneRecord.isStartBaseZone == true then
            return zoneRecord
        end
    end

    return nil
end

function ZoneFactory.getStartBaseZones()
    local result = {}

    for key, zoneRecord in pairs(ZoneFactory.registry) do
        if zoneRecord.isStartBaseZone == true then
            result[key] = zoneRecord
        end
    end

    return result
end

function ZoneFactory.findZonesNearPoint(point, maxDistance)
    local result = {}

    if type(point) ~= "table" then
        return result
    end

    local distanceLimit = maxDistance or 0

    for key, zoneRecord in pairs(ZoneFactory.registry) do
        local distance = distance2d(point, zoneRecord.center)

        if distance ~= nil then
            if distanceLimit <= 0 or distance <= distanceLimit then
                result[key] = {
                    zone = zoneRecord,
                    distance = distance
                }
            end
        end
    end

    return result
end

function ZoneFactory.findContainingZone(point)
    if type(point) ~= "table" then
        return nil
    end

    local bestZone = nil
    local bestDistance = nil

    for _, zoneRecord in pairs(ZoneFactory.registry) do
        local distance = distance2d(point, zoneRecord.center)

        if distance ~= nil and zoneRecord.radius ~= nil then
            if distance <= zoneRecord.radius then
                if bestDistance == nil or distance < bestDistance then
                    bestZone = zoneRecord
                    bestDistance = distance
                end
            end
        end
    end

    return bestZone, bestDistance
end

function ZoneFactory.getClassificationSummary()
    return buildZoneSummary()
end

function ZoneFactory.summary()
    local state = getState()
    local zones = nil

    if state ~= nil then
        zones = state.Zones
    end

    return {
        name = ZoneFactory.name,
        displayName = ZoneFactory.displayName,
        path = ZoneFactory.path,
        version = ZoneFactory.version,
        loaded = ZoneFactory.loaded,
        started = ZoneFactory.started,
        finished = ZoneFactory.finished,
        failed = ZoneFactory.failed,
        lastBuildTime = ZoneFactory.lastBuildTime,
        registeredZones = ZoneFactory.getCount(),
        airbaseZonesCreated = ZoneFactory.lastAirbaseZonesCreated,
        missionEditorZonesCreated = ZoneFactory.lastMissionEditorZonesCreated,
        airbaseObjectsSkipped = ZoneFactory.lastAirbaseObjectsSkipped,
        classification = buildZoneSummary(),
        stateZones = zones
    }
end

TC.World.ZoneFactory = ZoneFactory
TC.world.ZoneFactory = ZoneFactory

TC.modules.zoneFactory = {
    name = ZoneFactory.name,
    path = ZoneFactory.path,
    loaded = true,
    version = ZoneFactory.version
}

local state = getState()

if state ~= nil and state.setModuleStatus ~= nil then
    state.setModuleStatus("zoneFactory", "LOADED")
end

logInfo("Zone factory loaded v" .. ZoneFactory.version)

return ZoneFactory
