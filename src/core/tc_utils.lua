-- Theater Command DCS
-- File: src/core/tc_utils.lua
-- Purpose: Shared utility functions for Theater Command DCS.

TC = TC or {}

TC.modules = TC.modules or {}

local Utils = {}

Utils.name = "tc_utils"
Utils.path = "src/core/tc_utils.lua"
Utils.version = TC.version or "0.1.0"
Utils.loaded = true

local function getLogger()
  return TC.Logger or TC.logger
end

local function logDebug(message)
  local logger = getLogger()

  if logger ~= nil and logger.debug ~= nil then
    logger.debug(message)
  end
end

function Utils.isNil(value)
  return value == nil
end

function Utils.isString(value)
  return type(value) == "string"
end

function Utils.isNumber(value)
  return type(value) == "number"
end

function Utils.isBoolean(value)
  return type(value) == "boolean"
end

function Utils.isTable(value)
  return type(value) == "table"
end

function Utils.isFunction(value)
  return type(value) == "function"
end

function Utils.isEmptyString(value)
  if type(value) ~= "string" then
    return false
  end

  return value == ""
end

function Utils.isNilOrEmpty(value)
  if value == nil then
    return true
  end

  if type(value) == "string" and value == "" then
    return true
  end

  if type(value) == "table" and next(value) == nil then
    return true
  end

  return false
end

function Utils.default(value, fallback)
  if value == nil then
    return fallback
  end

  return value
end

function Utils.toString(value)
  if value == nil then
    return "nil"
  end

  if type(value) == "string" then
    return value
  end

  if type(value) == "boolean" then
    if value == true then
      return "true"
    end

    return "false"
  end

  return tostring(value)
end

function Utils.trim(value)
  if type(value) ~= "string" then
    return value
  end

  return string.match(value, "^%s*(.-)%s*$")
end

function Utils.toUpper(value)
  if type(value) ~= "string" then
    return value
  end

  return string.upper(value)
end

function Utils.toLower(value)
  if type(value) ~= "string" then
    return value
  end

  return string.lower(value)
end

function Utils.normalizeName(value)
  if type(value) ~= "string" then
    return nil
  end

  local normalized = Utils.trim(value)

  normalized = string.upper(normalized)
  normalized = string.gsub(normalized, "%s+", "_")
  normalized = string.gsub(normalized, "%-", "_")
  normalized = string.gsub(normalized, "[^A-Z0-9_]", "")
  normalized = string.gsub(normalized, "_+", "_")

  return normalized
end

function Utils.startsWith(value, prefix)
  if type(value) ~= "string" or type(prefix) ~= "string" then
    return false
  end

  return string.sub(value, 1, string.len(prefix)) == prefix
end

function Utils.endsWith(value, suffix)
  if type(value) ~= "string" or type(suffix) ~= "string" then
    return false
  end

  if suffix == "" then
    return true
  end

  return string.sub(value, -string.len(suffix)) == suffix
end

function Utils.split(value, separator)
  local result = {}

  if type(value) ~= "string" then
    return result
  end

  if separator == nil or separator == "" then
    separator = "%s"
  end

  for item in string.gmatch(value, "([^" .. separator .. "]+)") do
    table.insert(result, item)
  end

  return result
end

function Utils.tableContains(targetTable, expectedValue)
  if type(targetTable) ~= "table" then
    return false
  end

  for _, value in pairs(targetTable) do
    if value == expectedValue then
      return true
    end
  end

  return false
end

function Utils.tableHasKey(targetTable, expectedKey)
  if type(targetTable) ~= "table" then
    return false
  end

  return targetTable[expectedKey] ~= nil
end

function Utils.countTableKeys(targetTable)
  if type(targetTable) ~= "table" then
    return 0
  end

  local count = 0

  for _ in pairs(targetTable) do
    count = count + 1
  end

  return count
end

function Utils.shallowCopy(targetTable)
  if type(targetTable) ~= "table" then
    return targetTable
  end

  local result = {}

  for key, value in pairs(targetTable) do
    result[key] = value
  end

  return result
end

function Utils.deepCopy(value)
  if type(value) ~= "table" then
    return value
  end

  local result = {}

  for key, childValue in pairs(value) do
    result[Utils.deepCopy(key)] = Utils.deepCopy(childValue)
  end

  return result
end

function Utils.mergeTables(baseTable, overrideTable)
  local result = {}

  if type(baseTable) == "table" then
    for key, value in pairs(baseTable) do
      result[key] = Utils.deepCopy(value)
    end
  end

  if type(overrideTable) == "table" then
    for key, value in pairs(overrideTable) do
      result[key] = Utils.deepCopy(value)
    end
  end

  return result
end

function Utils.safeGet(targetTable, keyName, fallback)
  if type(targetTable) ~= "table" then
    return fallback
  end

  if keyName == nil then
    return fallback
  end

  if targetTable[keyName] == nil then
    return fallback
  end

  return targetTable[keyName]
end

function Utils.safeSet(targetTable, keyName, value)
  if type(targetTable) ~= "table" then
    return false
  end

  if keyName == nil then
    return false
  end

  targetTable[keyName] = value

  return true
end

function Utils.safeCall(callback, ...)
  if type(callback) ~= "function" then
    return false, "callback_not_function"
  end

  local success, result = pcall(callback, ...)

  if success ~= true then
    return false, result
  end

  return true, result
end

function Utils.getNestedValue(targetTable, path, fallback)
  if type(targetTable) ~= "table" then
    return fallback
  end

  if type(path) ~= "table" then
    return fallback
  end

  local currentValue = targetTable

  for _, keyName in ipairs(path) do
    if type(currentValue) ~= "table" then
      return fallback
    end

    if currentValue[keyName] == nil then
      return fallback
    end

    currentValue = currentValue[keyName]
  end

  return currentValue
end

function Utils.setNestedValue(targetTable, path, value)
  if type(targetTable) ~= "table" then
    return false
  end

  if type(path) ~= "table" then
    return false
  end

  if #path == 0 then
    return false
  end

  local currentTable = targetTable

  for index = 1, #path - 1 do
    local keyName = path[index]

    if currentTable[keyName] == nil then
      currentTable[keyName] = {}
    end

    if type(currentTable[keyName]) ~= "table" then
      return false
    end

    currentTable = currentTable[keyName]
  end

  currentTable[path[#path]] = value

  return true
end

function Utils.round(value, decimals)
  if type(value) ~= "number" then
    return value
  end

  local precision = decimals or 0
  local multiplier = 10 ^ precision

  return math.floor(value * multiplier + 0.5) / multiplier
end

function Utils.clamp(value, minimum, maximum)
  if type(value) ~= "number" then
    return value
  end

  if type(minimum) == "number" and value < minimum then
    return minimum
  end

  if type(maximum) == "number" and value > maximum then
    return maximum
  end

  return value
end

function Utils.distance2d(pointA, pointB)
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

function Utils.distance3d(pointA, pointB)
  if type(pointA) ~= "table" or type(pointB) ~= "table" then
    return nil
  end

  local ax = pointA.x or pointA[1]
  local ay = pointA.y or pointA[2]
  local az = pointA.z or pointA[3]
  local bx = pointB.x or pointB[1]
  local by = pointB.y or pointB[2]
  local bz = pointB.z or pointB[3]

  if type(ax) ~= "number" or type(ay) ~= "number" or type(az) ~= "number" then
    return nil
  end

  if type(bx) ~= "number" or type(by) ~= "number" or type(bz) ~= "number" then
    return nil
  end

  local deltaX = ax - bx
  local deltaY = ay - by
  local deltaZ = az - bz

  return math.sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ)
end

function Utils.getCoalitionName(coalitionId)
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

function Utils.getCoalitionId(coalitionName)
  local normalizedName = Utils.normalizeName(coalitionName)

  if normalizedName == "BLUE" then
    if coalition ~= nil and coalition.side ~= nil and coalition.side.BLUE ~= nil then
      return coalition.side.BLUE
    end

    return 2
  end

  if normalizedName == "RED" then
    if coalition ~= nil and coalition.side ~= nil and coalition.side.RED ~= nil then
      return coalition.side.RED
    end

    return 1
  end

  if normalizedName == "NEUTRAL" then
    if coalition ~= nil and coalition.side ~= nil and coalition.side.NEUTRAL ~= nil then
      return coalition.side.NEUTRAL
    end

    return 0
  end

  return nil
end

function Utils.getCurrentTime()
  if timer ~= nil and timer.getTime ~= nil then
    return timer.getTime()
  end

  return 0
end

function Utils.getCurrentAbsoluteTime()
  if timer ~= nil and timer.getAbsTime ~= nil then
    return timer.getAbsTime()
  end

  return 0
end

function Utils.markModuleLoaded(moduleKey, moduleName, modulePath)
  if moduleKey == nil then
    return false
  end

  TC.modules = TC.modules or {}

  TC.modules[moduleKey] = {
    name = moduleName or moduleKey,
    path = modulePath or "unknown_path",
    loaded = true,
    version = TC.version or "0.1.0"
  }

  return true
end

function Utils.markModuleFailed(moduleKey, moduleName, modulePath, reason)
  if moduleKey == nil then
    return false
  end

  TC.modules = TC.modules or {}

  TC.modules[moduleKey] = {
    name = moduleName or moduleKey,
    path = modulePath or "unknown_path",
    loaded = false,
    reason = reason or "unknown_error",
    version = TC.version or "0.1.0"
  }

  return true
end

TC.Utils = Utils
TC.utils = Utils

TC.modules.utils = {
  name = Utils.name,
  path = Utils.path,
  loaded = true,
  version = Utils.version
}

logDebug("Utils module loaded")

return Utils
