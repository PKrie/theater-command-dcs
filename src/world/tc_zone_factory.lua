-- Theater Command DCS
-- File: src/world/tc_zone_factory.lua
-- Purpose: Create virtual campaign zones from airbases and optional Mission Editor zones.

TC = TC or {}

TC.modules = TC.modules or {}
TC.World = TC.World or {}
TC.world = TC.world or TC.World

local ZoneFactory = {}

ZoneFactory.name = "tc_zone_factory"
ZoneFactory.path = "src/world/tc_zone_factory.lua"
ZoneFactory.version = TC.version or "0.1.0"
ZoneFactory.loaded = true
ZoneFactory.started = false
ZoneFactory.finished = false
ZoneFactory.failed = false

ZoneFactory.registry = {}
ZoneFactory.lastBuildTime = 0

ZoneFactory.defaultRadii = {
  AIRDROME = 25000,
  HELIPAD = 8000,
  SHIP = 12000,
  UNKNOWN = 15000,
  START_BASE = 35000,
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

local function logInfo(message)
  local logger = getLogger()

  if logger ~= nil and logger.info ~= nil then
    logger.info(message)
  end
end

local function logWarn(message)
  local logger = getLogger()

  if logger ~= nil and logger.warn ~= nil then
    logger.warn(message)
  end
end

local function logError(message)
  local logger = getLogger()

  if logger ~= nil and logger.error ~= nil then
    logger.error(message)
  end
end

local function logDebug(message)
  local logger = getLogger()

  if logger ~= nil and logger.debug ~= nil then
    logger.debug(message)
  end
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
    return utils.normalizeName(value)
  end

  if type(value) ~= "string" then
    return nil
  end

  local normalized = string.upper(value)

  normalized = string.gsub(normalized, "^%s*(.-)%s*$", "%1")
  normalized = string.gsub(normalized, "%s+", "_")
  normalized = string.gsub(normalized, "%-", "_")
  normalized = string.gsub(normalized, "[^A-Z0-9_]", "")
  normalized = string.gsub(normalized, "_+", "_")

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

  return state
end

local function countOwner(owner)
  local state = getState()

  if state == nil or state.Zones == nil then
    return
  end

  if owner == "BLUE" then
    state.Zones.blue = (state.Zones.blue or 0) + 1
    return
  end

  if owner == "RED" then
    state.Zones.red = (state.Zones.red or 0) + 1
    return
  end

  if owner == "NEUTRAL" then
    state.Zones.neutral = (state.Zones.neutral or 0) + 1
    return
  end

  if owner == "CONTESTED" then
    state.Zones.contested = (state.Zones.contested or 0) + 1
    return
  end

  state.Zones.unknown = (state.Zones.unknown or 0) + 1
end

local function buildZoneKey(prefix, normalizedName)
  local baseKey = prefix .. "_" .. (normalizedName or "UNKNOWN_ZONE")
  local key = baseKey
  local index = 2

  while ZoneFactory.registry[key] ~= nil do
    key = baseKey .. "_" .. index
    index = index + 1
  end

  return key
end

local function getRadiusForAirbase(airbaseRecord)
  if airbaseRecord == nil then
    return ZoneFactory.defaultRadii.UNKNOWN
  end

  if airbaseRecord.isStartBase == true then
    return ZoneFactory.defaultRadii.START_BASE
  end

  if airbaseRecord.categoryName == "AIRDROME" then
    return ZoneFactory.defaultRadii.AIRDROME
  end

  if airbaseRecord.categoryName == "HELIPAD" then
    return ZoneFactory.defaultRadii.HELIPAD
  end

  if airbaseRecord.categoryName == "SHIP" then
    return ZoneFactory.defaultRadii.SHIP
  end

  return ZoneFactory.defaultRadii.UNKNOWN
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

local function extractPoint(zoneData)
  if type(zoneData) ~= "table" then
    return {
      x = 0,
      y = 0,
      z = 0
    }
  end

  local point = zoneData.point or zoneData.center or zoneData.position

  if type(point) == "table" then
    local x = point.x or point[1] or 0
    local y = point.y or 0
    local z = point.z or point[2] or point.y or 0

    if point.z == nil then
      y = 0
    end

    return {
      x = x,
      y = y,
      z = z
    }
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

  local normalizedName = airbaseRecord.normalizedName or normalizeName(airbaseRecord.name) or "UNKNOWN_AIRBASE"
  local zoneName = "ZONE_AIRBASE_" .. normalizedName
  local zoneKey = buildZoneKey("ZONE_AIRBASE", normalizedName)
  local activeStatus = getConstant("status", "ACTIVE", "ACTIVE")
  local owner = airbaseRecord.currentOwner or airbaseRecord.initialOwner or getConstant("ownership", "UNKNOWN", "UNKNOWN")

  return {
    key = zoneKey,
    name = zoneName,
    displayName = zoneName,
    normalizedName = normalizeName(zoneName),
    type = "AIRBASE_ZONE",
    source = "AIRBASE_REGISTRY",
    status = activeStatus,
    initialOwner = owner,
    currentOwner = owner,
    theatreArea = airbaseRecord.theatreArea or "UNKNOWN",
    center = airbaseRecord.position or {
      x = 0,
      y = 0,
      z = 0
    },
    radius = getRadiusForAirbase(airbaseRecord),
    linkedAirbaseKey = airbaseRecord.key,
    linkedAirbaseName = airbaseRecord.name,
    isStartBaseZone = airbaseRecord.isStartBase == true,
    isVirtual = true,
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

  return {
    key = zoneKey,
    name = rawName,
    displayName = rawName,
    normalizedName = normalizedName,
    type = "MISSION_EDITOR_ZONE",
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
    isStartBaseZone = false,
    isVirtual = false,
    createdAt = getCurrentTime()
  }
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
    countOwner(zoneRecord.currentOwner)
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

function ZoneFactory.reset()
  ZoneFactory.registry = {}

  TC.World.Zones = {}

  local state = ensureStateTables()

  if state ~= nil then
    state.World.zoneFactoryComplete = false
  end

  return true
end

function ZoneFactory.buildAirbaseZones()
  local airbases = getAirbaseRegistry()
  local created = 0

  for _, airbaseRecord in pairs(airbases) do
    local zoneRecord = createAirbaseZoneRecord(airbaseRecord)

    if zoneRecord ~= nil then
      if registerZone(zoneRecord) == true then
        created = created + 1
        logDebug("Airbase zone created: " .. zoneRecord.name .. " [" .. zoneRecord.currentOwner .. "]")
      end
    end
  end

  return created
end

function ZoneFactory.buildMissionEditorZones()
  local success, zonesOrReason = getMistZones()

  if success ~= true then
    logDebug("Mission Editor zone import skipped: " .. tostring(zonesOrReason))
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
        logDebug("Mission Editor zone registered: " .. zoneRecord.name .. " [" .. zoneRecord.currentOwner .. "]")
      end
    end
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

  logInfo(
    "Zone factory completed: "
      .. totalZonesCreated
      .. " zones registered ("
      .. airbaseZonesCreated
      .. " airbase zones, "
      .. missionEditorZonesCreated
      .. " Mission Editor zones)"
  )

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

function ZoneFactory.getStartBaseZone()
  for _, zoneRecord in pairs(ZoneFactory.registry) do
    if zoneRecord.isStartBaseZone == true then
      return zoneRecord
    end
  end

  return nil
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

function ZoneFactory.summary()
  local state = getState()
  local zones = nil

  if state ~= nil then
    zones = state.Zones
  end

  return {
    name = ZoneFactory.name,
    path = ZoneFactory.path,
    version = ZoneFactory.version,
    loaded = ZoneFactory.loaded,
    started = ZoneFactory.started,
    finished = ZoneFactory.finished,
    failed = ZoneFactory.failed,
    lastBuildTime = ZoneFactory.lastBuildTime,
    registeredZones = ZoneFactory.getCount(),
    stateZones = zones
  }
end

TC.World.ZoneFactory = ZoneFactory

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

logInfo("Zone factory loaded")

return ZoneFactory
