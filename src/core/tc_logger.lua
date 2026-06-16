-- Theater Command DCS
-- File: src/core/tc_logger.lua
-- Purpose: Central logging module.

TC = TC or {}

TC.modules = TC.modules or {}

local Logger = {}

Logger.name = "tc_logger"
Logger.path = "src/core/tc_logger.lua"
Logger.version = TC.version or "0.1.0"
Logger.loaded = true

local function getConfig()
  return TC.config or TC.Config or {}
end

local function getLoggingConfig()
  local config = getConfig()

  return config.logging or config.Logging or {}
end

local function getDebugConfig()
  local config = getConfig()

  return config.debug or config.Debug or {}
end

local function toString(value)
  if value == nil then
    return "nil"
  end

  if type(value) == "string" then
    return value
  end

  if type(value) == "boolean" then
    if value then
      return "true"
    end

    return "false"
  end

  return tostring(value)
end

local function getPrefix(level)
  local loggingConfig = getLoggingConfig()

  if level == "INFO" then
    return loggingConfig.infoPrefix or loggingConfig.prefix or "[TC]"
  end

  if level == "WARN" then
    return loggingConfig.warnPrefix or "[TC][WARN]"
  end

  if level == "ERROR" then
    return loggingConfig.errorPrefix or "[TC][ERROR]"
  end

  if level == "DEBUG" then
    return loggingConfig.debugPrefix or "[TC][DEBUG]"
  end

  return loggingConfig.prefix or "[TC]"
end

local function writeToDcsLog(level, message)
  local formattedMessage = Logger.format(level, message)

  if env ~= nil then
    if level == "ERROR" and env.error ~= nil then
      env.error(formattedMessage)
      return formattedMessage
    end

    if level == "WARN" and env.warning ~= nil then
      env.warning(formattedMessage)
      return formattedMessage
    end

    if env.info ~= nil then
      env.info(formattedMessage)
      return formattedMessage
    end
  end

  if print ~= nil then
    print(formattedMessage)
  end

  return formattedMessage
end

function Logger.format(level, message)
  local prefix = getPrefix(level)

  return prefix .. " " .. toString(message)
end

function Logger.info(message)
  return writeToDcsLog("INFO", message)
end

function Logger.warn(message)
  return writeToDcsLog("WARN", message)
end

function Logger.error(message)
  return writeToDcsLog("ERROR", message)
end

function Logger.debug(message)
  local debugConfig = getDebugConfig()

  if debugConfig.enabled ~= true then
    return nil
  end

  return writeToDcsLog("DEBUG", message)
end

function Logger.moduleLoaded(moduleName, modulePath)
  local debugConfig = getDebugConfig()

  if debugConfig.showModuleLoading ~= true then
    return nil
  end

  local name = moduleName or "unknown_module"
  local path = modulePath or "unknown_path"

  return Logger.debug("Module loaded: " .. name .. " (" .. path .. ")")
end

function Logger.moduleSkipped(moduleName, reason)
  local name = moduleName or "unknown_module"
  local skipReason = reason or "no reason provided"

  return Logger.warn("Module skipped: " .. name .. " - " .. skipReason)
end

function Logger.moduleFailed(moduleName, reason)
  local name = moduleName or "unknown_module"
  local failReason = reason or "unknown error"

  return Logger.error("Module failed: " .. name .. " - " .. failReason)
end

function Logger.startup(message)
  local debugConfig = getDebugConfig()

  if debugConfig.showStartupMessages ~= true then
    return nil
  end

  return Logger.info(message)
end

function Logger.frameworkCheck(frameworkName, isAvailable)
  local debugConfig = getDebugConfig()

  if debugConfig.showFrameworkChecks ~= true then
    return nil
  end

  local name = frameworkName or "unknown_framework"

  if isAvailable == true then
    return Logger.info("Framework available: " .. name)
  end

  return Logger.warn("Framework missing: " .. name)
end

function Logger.state(message)
  local debugConfig = getDebugConfig()

  if debugConfig.showStateInitialization ~= true then
    return nil
  end

  return Logger.debug(message)
end

function Logger.separator()
  return Logger.info("----------------------------------------")
end

function Logger.header(title)
  local headerTitle = title or "Theater Command DCS"

  Logger.separator()
  Logger.info(headerTitle)
  return Logger.separator()
end

TC.Logger = Logger
TC.logger = Logger

TC.modules.logger = {
  name = Logger.name,
  path = Logger.path,
  loaded = true,
  version = Logger.version
}

Logger.startup("Logger initialized")

return Logger
