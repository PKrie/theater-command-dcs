-- Theater Command DCS
-- File: src/world/tc_airbase_scanner.lua
-- Purpose: Scan DCS airbases and register them in Theater Command state.

TC = TC or {}

TC.modules = TC.modules or {}
TC.World = TC.World or {}
TC.world = TC.world or TC.World

local AirbaseScanner = {}

AirbaseScanner.name = "tc_airbase_scanner"
AirbaseScanner.path = "src/world/tc_airbase_scanner.lua"
AirbaseScanner.version = TC.version or "0.1.0"
AirbaseScanner.loaded = true
AirbaseScanner.started = false
AirbaseScanner.finished = false
AirbaseScanner.failed = false

AirbaseScanner.registry = {}
AirbaseScanner.lastScanTime = 0

AirbaseScanner.cyprusKeywords = {
  "AKROTIRI",
  "RAF_AKROTIRI",
  "PAPHOS",
  "LARNACA",
  "ERCAN",
  "GECITKALE",
  "NICOSIA",
  "KINGSFIELD"
}

AirbaseScanner.syrianMainlandKeywords = {
  "ABU_AL_DUHUR",
  "ABU_DUHUR",
  "AD_DUMAYR",
  "AL_DUMAYR",
  "ALEPPO",
  "BASSEL",
  "BASSAL",
  "DAMASCUS",
  "DEIR",
  "DZOR",
  "HAMA",
  "JIRAH",
  "KHALKHALAH",
  "KHMEIMIM",
  "KUWEIRES",
  "MARJ",
  "MEZZEH",
  "MINAKH",
  "PALMYRA",
  "QABR",
  "RASIN",
  "RUHAYYIL",
  "SAYQAL",
  "SHAYRAT",
  "TABQA",
  "TAFTANAZ",
  "TIYAS"
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

local function containsKeyword(normalizedName, keyword)
  if type(normalizedName) ~= "string" or type(keyword) ~= "string" then
    return false
  end

  return string.find(normalizedName, keyword, 1, true) ~= nil
end

local function containsAnyKeyword(normalizedName, keywords)
  if type(keywords) ~= "table" then
    return false
  end

  for _, keyword in ipairs(keywords) do
    if containsKeyword(normalizedName, keyword) == true then
      return true
    end
  end

  return false
end

local function safeMethodCall(object, methodName)
  if object == nil or methodName == nil then
    return false, nil
  end

  if object[methodName] == nil or type(object[methodName]) ~= "function" then
    return false, nil
  end

  local success, result = pcall(function()
    return object[methodName](object)
  end)

  if success ~= true then
    return false, nil
  end

  return true, result
end

local function getAirbaseName(airbaseObject)
  local success, result = safeMethodCall(airbaseObject, "getName")

  if success == true and result ~= nil then
    return result
  end

  return "UNKNOWN_AIRBASE"
end

local function getAirbasePoint(airbaseObject)
  local success, result = safeMethodCall(airbaseObject, "getPoint")

  if success == true and type(result) == "table" then
    return {
      x = result.x or 0,
      y = result.y or 0,
      z = result.z or 0
    }
  end

  return {
    x = 0,
    y = 0,
    z = 0
  }
end

local function getAirbaseCoalitionId(airbaseObject)
  local success, result = safeMethodCall(airbaseObject, "getCoalition")

  if success == true then
    return result
  end

  return nil
end

local function getCoalitionName(coalitionId)
  local utils = getUtils()

  if utils ~= nil and utils.getCoalitionName ~= nil then
    return utils.getCoalitionName(coalitionId)
  end

  if coalition ~= nil and coalition.side ~= nil then
    if coalitionId == coalition.side.BLUE then
      return "BLUE"
    end

    if coalitionId == coalition.side.RED then
      return "RED"
    end

    if coalitionId == coalition.side.NEUTRAL then
      return "NEUTRAL"
    end
  end

  if coalitionId == 2 then
    return "BLUE"
  end

  if coalitionId == 1 then
    return "RED"
  end

  if coalitionId == 0 then
    return "NEUTRAL"
  end

  return "UNKNOWN"
end

local function getAirbaseCategory(airbaseObject)
  local successCategory, categoryResult = safeMethodCall(airbaseObject, "getCategory")

  if successCategory == true and categoryResult ~= nil then
    return categoryResult
  end

  local successDesc, descResult = safeMethodCall(airbaseObject, "getDesc")

  if successDesc == true and type(descResult) == "table" then
    return descResult.category
  end

  return nil
end

local function getCategoryName(categoryId)
  if Airbase ~= nil and Airbase.Category ~= nil then
    if categoryId == Airbase.Category.AIRDROME then
      return "AIRDROME"
    end

    if categoryId == Airbase.Category.HELIPAD then
      return "HELIPAD"
    end

    if categoryId == Airbase.Category.SHIP then
      return "SHIP"
    end
  end

  if categoryId == 0 then
    return "AIRDROME"
  end

  if categoryId == 1 then
    return "HELIPAD"
  end

  if categoryId == 2 then
    return "SHIP"
  end

  return "UNKNOWN"
end

local function getTheatreArea(normalizedName)
  if containsAnyKeyword(normalizedName, AirbaseScanner.cyprusKeywords) == true then
    return "CYPRUS"
  end

  if containsAnyKeyword(normalizedName, AirbaseScanner.syrianMainlandKeywords) == true then
    return "SYRIAN_MAINLAND"
  end

  return "OTHER"
end

local function isStartBase(normalizedName)
  local config = getConfig()
  local campaignConfig = config.campaign or {}
  local configuredStartBase = normalizeName(campaignConfig.blueStartBase or "AKROTIRI")

  if configuredStartBase ~= nil and containsKeyword(normalizedName, configuredStartBase) == true then
    return true
  end

  if containsKeyword(normalizedName, "AKROTIRI") == true then
    return true
  end

  return false
end

local function determineInitialOwner(normalizedName, theatreArea, coalitionName)
  local blueOwnership = getConstant("ownership", "BLUE", "BLUE")
  local redOwnership = getConstant("ownership", "RED", "RED")
  local neutralOwnership = getConstant("ownership", "NEUTRAL", "NEUTRAL")
  local unknownOwnership = getConstant("ownership", "UNKNOWN", "UNKNOWN")

  if isStartBase(normalizedName) == true then
    return blueOwnership
  end

  if theatreArea == "CYPRUS" then
    return blueOwnership
  end

  if theatreArea == "SYRIAN_MAINLAND" then
    return redOwnership
  end

  if coalitionName == "BLUE" then
    return blueOwnership
  end

  if coalitionName == "RED" then
    return redOwnership
  end

  if coalitionName == "NEUTRAL" then
    return neutralOwnership
  end

  return unknownOwnership
end

local function buildRegistryKey(normalizedName)
  local baseKey = normalizedName or "UNKNOWN_AIRBASE"
  local key = baseKey
  local index = 2

  while AirbaseScanner.registry[key] ~= nil do
    key = baseKey .. "_" .. index
    index = index + 1
  end

  return key
end

local function ensureStateTables()
  local state = getState()

  if state == nil then
    return nil
  end

  state.World = state.World or {}
  state.Bases = state.Bases or {}

  state.Bases.total = 0
  state.Bases.blue = 0
  state.Bases.red = 0
  state.Bases.neutral = 0
  state.Bases.contested = 0
  state.Bases.unknown = 0
  state.Bases.registry = {}

  return state
end

local function countOwner(owner)
  local state = getState()

  if state == nil or state.Bases == nil then
    return
  end

  if owner == "BLUE" then
    state.Bases.blue = (state.Bases.blue or 0) + 1
    return
  end

  if owner == "RED" then
    state.Bases.red = (state.Bases.red or 0) + 1
    return
  end

  if owner == "NEUTRAL" then
    state.Bases.neutral = (state.Bases.neutral or 0) + 1
    return
  end

  if owner == "CONTESTED" then
    state.Bases.contested = (state.Bases.contested or 0) + 1
    return
  end

  state.Bases.unknown = (state.Bases.unknown or 0) + 1
end

local function registerAirbase(record)
  if record == nil or record.key == nil then
    return false
  end

  local state = getState()

  AirbaseScanner.registry[record.key] = record

  TC.World.Airbases = TC.World.Airbases or {}
  TC.World.Airbases[record.key] = record

  if state ~= nil and state.Bases ~= nil and state.Bases.registry ~= nil then
    state.Bases.registry[record.key] = record
    state.Bases.total = (state.Bases.total or 0) + 1
    countOwner(record.currentOwner)
  end

  return true
end

local function createAirbaseRecord(airbaseObject)
  local rawName = getAirbaseName(airbaseObject)
  local normalizedName = normalizeName(rawName) or "UNKNOWN_AIRBASE"
  local point = getAirbasePoint(airbaseObject)
  local coalitionId = getAirbaseCoalitionId(airbaseObject)
  local coalitionName = getCoalitionName(coalitionId)
  local categoryId = getAirbaseCategory(airbaseObject)
  local categoryName = getCategoryName(categoryId)
  local theatreArea = getTheatreArea(normalizedName)
  local initialOwner = determineInitialOwner(normalizedName, theatreArea, coalitionName)
  local activeStatus = getConstant("status", "ACTIVE", "ACTIVE")
  local registryKey = buildRegistryKey(normalizedName)

  return {
    key = registryKey,
    name = rawName,
    displayName = rawName,
    normalizedName = normalizedName,
    categoryId = categoryId,
    categoryName = categoryName,
    coalitionId = coalitionId,
    coalitionName = coalitionName,
    theatreArea = theatreArea,
    initialOwner = initialOwner,
    currentOwner = initialOwner,
    status = activeStatus,
    position = point,
    isStartBase = isStartBase(normalizedName),
    isCyprus = theatreArea == "CYPRUS",
    isSyrianMainland = theatreArea == "SYRIAN_MAINLAND",
    source = "DCS_WORLD",
    scannedAt = getCurrentTime()
  }
end

local function getDcsAirbases()
  if world == nil or world.getAirbases == nil then
    return false, "world_getAirbases_unavailable"
  end

  local success, result = pcall(function()
    return world.getAirbases()
  end)

  if success ~= true then
    return false, result
  end

  if type(result) ~= "table" then
    return false, "world_getAirbases_returned_non_table"
  end

  return true, result
end

function AirbaseScanner.reset()
  AirbaseScanner.registry = {}

  TC.World.Airbases = {}

  local state = ensureStateTables()

  if state ~= nil then
    state.World.scanned = false
    state.World.airbaseScanComplete = false
  end

  return true
end

function AirbaseScanner.scan()
  AirbaseScanner.started = true
  AirbaseScanner.finished = false
  AirbaseScanner.failed = false
  AirbaseScanner.lastScanTime = getCurrentTime()

  logInfo("Airbase scan started")

  AirbaseScanner.reset()

  local success, airbasesOrReason = getDcsAirbases()

  if success ~= true then
    AirbaseScanner.failed = true

    local reason = tostring(airbasesOrReason)

    logError("Airbase scan failed: " .. reason)

    local state = getState()

    if state ~= nil and state.setModuleStatus ~= nil then
      state.setModuleStatus("airbaseScanner", "FAILED")
    end

    return false
  end

  for _, airbaseObject in ipairs(airbasesOrReason) do
    local record = createAirbaseRecord(airbaseObject)

    registerAirbase(record)

    logDebug("Airbase registered: " .. record.name .. " [" .. record.currentOwner .. "]")
  end

  local state = getState()

  if state ~= nil then
    state.World = state.World or {}
    state.World.scanned = true
    state.World.airbaseScanComplete = true
    state.World.status = getConstant("status", "ACTIVE", "ACTIVE")

    if state.setFeatureStatus ~= nil then
      state.setFeatureStatus("airbaseScanner", true)
    end

    if state.setModuleStatus ~= nil then
      state.setModuleStatus("airbaseScanner", "SCANNED")
    end

    if state.markDirty ~= nil then
      state.markDirty("airbase_scan_completed")
    end
  end

  AirbaseScanner.finished = true

  logInfo("Airbase scan completed: " .. AirbaseScanner.getCount() .. " airbases registered")

  return true
end

function AirbaseScanner.start()
  return AirbaseScanner.scan()
end

function AirbaseScanner.stop()
  AirbaseScanner.started = false

  logInfo("Airbase scanner stopped")

  return true
end

function AirbaseScanner.getRegistry()
  return AirbaseScanner.registry
end

function AirbaseScanner.getAirbase(key)
  if key == nil then
    return nil
  end

  return AirbaseScanner.registry[key]
end

function AirbaseScanner.getAirbaseByName(name)
  local normalizedName = normalizeName(name)

  if normalizedName == nil then
    return nil
  end

  for _, record in pairs(AirbaseScanner.registry) do
    if record.normalizedName == normalizedName then
      return record
    end

    if containsKeyword(record.normalizedName, normalizedName) == true then
      return record
    end
  end

  return nil
end

function AirbaseScanner.getStartBase()
  for _, record in pairs(AirbaseScanner.registry) do
    if record.isStartBase == true then
      return record
    end
  end

  return nil
end

function AirbaseScanner.getCount()
  local count = 0

  for _ in pairs(AirbaseScanner.registry) do
    count = count + 1
  end

  return count
end

function AirbaseScanner.getByOwner(owner)
  local result = {}

  if owner == nil then
    return result
  end

  for key, record in pairs(AirbaseScanner.registry) do
    if record.currentOwner == owner then
      result[key] = record
    end
  end

  return result
end

function AirbaseScanner.getByTheatreArea(theatreArea)
  local result = {}

  if theatreArea == nil then
    return result
  end

  for key, record in pairs(AirbaseScanner.registry) do
    if record.theatreArea == theatreArea then
      result[key] = record
    end
  end

  return result
end

function AirbaseScanner.summary()
  local state = getState()
  local bases = nil

  if state ~= nil then
    bases = state.Bases
  end

  return {
    name = AirbaseScanner.name,
    path = AirbaseScanner.path,
    version = AirbaseScanner.version,
    loaded = AirbaseScanner.loaded,
    started = AirbaseScanner.started,
    finished = AirbaseScanner.finished,
    failed = AirbaseScanner.failed,
    lastScanTime = AirbaseScanner.lastScanTime,
    registeredAirbases = AirbaseScanner.getCount(),
    stateBases = bases
  }
end

TC.World.AirbaseScanner = AirbaseScanner

TC.modules.airbaseScanner = {
  name = AirbaseScanner.name,
  path = AirbaseScanner.path,
  loaded = true,
  version = AirbaseScanner.version
}

local state = getState()

if state ~= nil and state.setModuleStatus ~= nil then
  state.setModuleStatus("airbaseScanner", "LOADED")
end

logInfo("Airbase scanner loaded")

return AirbaseScanner
