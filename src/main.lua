-- Theater Command DCS
-- File: src/main.lua
-- Purpose: Main initialization coordinator for Theater Command DCS.

TC = TC or {}

TC.modules = TC.modules or {}
TC.Main = TC.Main or {}
TC.main = TC.main or TC.Main

local Main = {}

Main.name = "main"
Main.path = "src/main.lua"
Main.version = TC.version or "0.1.0"
Main.loaded = true
Main.started = false
Main.finished = false
Main.failed = false

Main.startupPhase = "PHASE_1_SOURCE_FOUNDATION"

Main.namespaces = {
  "Core",
  "World",
  "Campaign",
  "Logistics",
  "Missions",
  "AI",
  "IADS",
  "UI",
  "Debug"
}

Main.runtimeSystems = {
  {
    key = "airbaseScanner",
    name = "Airbase Scanner",
    namespace = "World",
    moduleName = "AirbaseScanner",
    required = true
  },
  {
    key = "zoneFactory",
    name = "Zone Factory",
    namespace = "World",
    moduleName = "ZoneFactory",
    required = true
  },
  {
    key = "captureSystem",
    name = "Capture System",
    namespace = "Campaign",
    moduleName = "CaptureSystem",
    required = true
  },
  {
    key = "persistenceSystem",
    name = "Persistence System",
    namespace = "Campaign",
    moduleName = "PersistenceSystem",
    required = true
  },
  {
    key = "logisticsDelivery",
    name = "Logistics Delivery",
    namespace = "Logistics",
    moduleName = "Delivery",
    required = true
  },
  {
    key = "fobSystem",
    name = "FOB System",
    namespace = "Logistics",
    moduleName = "FobSystem",
    required = true
  },
  {
    key = "missionGenerator",
    name = "Mission Generator",
    namespace = "Missions",
    moduleName = "Generator",
    required = true
  },
  {
    key = "aiCapManager",
    name = "AI CAP Manager",
    namespace = "AI",
    moduleName = "CapManager",
    required = true
  },
  {
    key = "iadsIntegration",
    name = "IADS Integration",
    namespace = "IADS",
    moduleName = "Network",
    required = false
  },
  {
    key = "f10Menu",
    name = "F10 Menu",
    namespace = "UI",
    moduleName = "F10Menu",
    required = false
  },
  {
    key = "debugTools",
    name = "Debug Tools",
    namespace = "Debug",
    moduleName = "Tools",
    required = false
  }
}

Main.startedSystems = {}
Main.failedSystems = {}
Main.skippedSystems = {}

local function getConfig()
  return TC.config or TC.Config
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

local function getScheduler()
  return TC.Scheduler or TC.scheduler
end

local function rawToString(value)
  if value == nil then
    return "nil"
  end

  return tostring(value)
end

local function writeRawLog(level, message)
  local formattedMessage = "[TC][MAIN] " .. rawToString(message)

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

local function logInfo(message)
  local logger = getLogger()

  if logger ~= nil and logger.info ~= nil then
    return logger.info(message)
  end

  return writeRawLog("INFO", message)
end

local function logWarn(message)
  local logger = getLogger()

  if logger ~= nil and logger.warn ~= nil then
    return logger.warn(message)
  end

  return writeRawLog("WARN", message)
end

local function logError(message)
  local logger = getLogger()

  if logger ~= nil and logger.error ~= nil then
    return logger.error(message)
  end

  return writeRawLog("ERROR", message)
end

local function logDebug(message)
  local logger = getLogger()

  if logger ~= nil and logger.debug ~= nil then
    return logger.debug(message)
  end

  return nil
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

local function setModuleStatus(moduleKey, status)
  local state = getState()

  if state ~= nil and state.setModuleStatus ~= nil then
    state.setModuleStatus(moduleKey, status)
  end
end

local function setFeatureStatus(featureKey, enabled)
  local state = getState()

  if state ~= nil and state.setFeatureStatus ~= nil then
    state.setFeatureStatus(featureKey, enabled == true)
  end
end

local function getNestedModule(namespaceName, moduleName)
  if namespaceName == nil or moduleName == nil then
    return nil
  end

  if TC[namespaceName] == nil then
    return nil
  end

  return TC[namespaceName][moduleName]
end

local function hasStartFunction(module)
  return module ~= nil and type(module.start) == "function"
end

local function hasStopFunction(module)
  return module ~= nil and type(module.stop) == "function"
end

local function countTableKeys(targetTable)
  if type(targetTable) ~= "table" then
    return 0
  end

  local count = 0

  for _ in pairs(targetTable) do
    count = count + 1
  end

  return count
end

function Main.prepareNamespaces()
  for _, namespaceName in ipairs(Main.namespaces) do
    TC[namespaceName] = TC[namespaceName] or {}
  end

  TC.Core.Config = TC.config or TC.Config
  TC.Core.Logger = TC.Logger or TC.logger
  TC.Core.State = TC.State or TC.state
  TC.Core.Utils = TC.Utils or TC.utils
  TC.Core.Scheduler = TC.Scheduler or TC.scheduler

  return true
end

function Main.checkCore()
  local missing = {}

  if getConfig() == nil then
    table.insert(missing, "Config")
  end

  if getLogger() == nil then
    table.insert(missing, "Logger")
  end

  if getState() == nil then
    table.insert(missing, "State")
  end

  if getUtils() == nil then
    table.insert(missing, "Utils")
  end

  if getScheduler() == nil then
    table.insert(missing, "Scheduler")
  end

  if #missing > 0 then
    for _, moduleName in ipairs(missing) do
      logError("Core module missing: " .. moduleName)
    end

    return false
  end

  logInfo("Core check passed")

  return true
end

function Main.applyInitialState()
  local state = getState()

  if state == nil then
    return false
  end

  if state.setCampaignPhase ~= nil then
    state.setCampaignPhase(Main.startupPhase)
  end

  if state.setCampaignRunning ~= nil then
    state.setCampaignRunning(true)
  end

  if state.setCampaignPaused ~= nil then
    state.setCampaignPaused(false)
  end

  if state.setFeatureStatus ~= nil then
    state.setFeatureStatus("core", true)
    state.setFeatureStatus("main", true)
  end

  if state.setModuleStatus ~= nil then
    state.setModuleStatus("main", "LOADED")
  end

  logDebug("Initial state applied")

  return true
end

function Main.printStartupSummary()
  local config = getConfig() or {}
  local campaign = config.campaign or {}
  local project = config.project or {}

  logInfo("Theater Command DCS main initialization")
  logInfo("Project: " .. rawToString(project.name or "Theater Command DCS"))
  logInfo("Version: " .. rawToString(TC.version or Main.version))
  logInfo("Campaign: " .. rawToString(campaign.name or "Operation Levant Reclamation"))
  logInfo("Map: " .. rawToString(campaign.map or "Syria"))
  logInfo("Blue start base: " .. rawToString(campaign.blueStartBase or "AKROTIRI"))
  logInfo("Initial red territory: " .. rawToString(campaign.initialRedTerritory or "SYRIAN_MAINLAND"))

  return true
end

function Main.resetRuntimeTracking()
  Main.startedSystems = {}
  Main.failedSystems = {}
  Main.skippedSystems = {}

  return true
end

function Main.markRuntimeSystemsInactive()
  for _, systemDefinition in ipairs(Main.runtimeSystems) do
    setFeatureStatus(systemDefinition.key, false)
  end

  return true
end

function Main.startRuntimeSystem(systemDefinition)
  if systemDefinition == nil then
    return false
  end

  local module = getNestedModule(systemDefinition.namespace, systemDefinition.moduleName)

  if hasStartFunction(module) ~= true then
    if systemDefinition.required == true then
      logError("Required system not available: " .. systemDefinition.name)
      setFeatureStatus(systemDefinition.key, false)

      Main.failedSystems[systemDefinition.key] = {
        name = systemDefinition.name,
        reason = "module_or_start_function_missing"
      }

      return false
    end

    logDebug("Optional system not available yet: " .. systemDefinition.name)
    setFeatureStatus(systemDefinition.key, false)

    Main.skippedSystems[systemDefinition.key] = {
      name = systemDefinition.name,
      reason = "optional_system_not_available"
    }

    return true
  end

  local success, result = pcall(module.start)

  if success ~= true then
    logError("System start failed: " .. systemDefinition.name .. " - " .. rawToString(result))
    setFeatureStatus(systemDefinition.key, false)

    Main.failedSystems[systemDefinition.key] = {
      name = systemDefinition.name,
      reason = rawToString(result)
    }

    if systemDefinition.required == true then
      return false
    end

    return true
  end

  logInfo("System started: " .. systemDefinition.name)
  setFeatureStatus(systemDefinition.key, true)

  Main.startedSystems[systemDefinition.key] = {
    name = systemDefinition.name,
    namespace = systemDefinition.namespace,
    moduleName = systemDefinition.moduleName
  }

  return true
end

function Main.startRuntimeSystems()
  local allRequiredStarted = true

  for _, systemDefinition in ipairs(Main.runtimeSystems) do
    local systemStarted = Main.startRuntimeSystem(systemDefinition)

    if systemStarted ~= true and systemDefinition.required == true then
      allRequiredStarted = false
    end
  end

  if allRequiredStarted == true then
    logInfo("Runtime systems initialized")
  else
    logError("Runtime system initialization failed")
  end

  return allRequiredStarted
end

function Main.startSchedulerHeartbeat()
  local scheduler = getScheduler()

  if scheduler == nil or scheduler.scheduleRepeating == nil then
    logDebug("Scheduler heartbeat skipped because Scheduler is not available")
    return false
  end

  local function heartbeatTask()
    local state = getState()

    if state ~= nil and state.incrementTick ~= nil then
      state.incrementTick()
    end

    return true
  end

  scheduler.scheduleRepeating(
    "tc_main_heartbeat",
    heartbeatTask,
    60,
    60
  )

  logDebug("Main heartbeat scheduled")

  return true
end

function Main.start()
  if Main.started == true then
    logWarn("Main already started")
    return true
  end

  Main.started = true
  Main.finished = false
  Main.failed = false
  Main.startedAt = getCurrentTime()

  TC.Main = Main
  TC.main = Main

  setModuleStatus("main", "STARTING")

  logInfo("Main start requested")

  Main.prepareNamespaces()

  if Main.checkCore() ~= true then
    Main.failed = true
    setModuleStatus("main", "FAILED")
    logError("Main start stopped because core check failed")
    return false
  end

  Main.applyInitialState()
  Main.printStartupSummary()
  Main.resetRuntimeTracking()
  Main.markRuntimeSystemsInactive()

  if Main.startRuntimeSystems() ~= true then
    Main.failed = true
    setModuleStatus("main", "FAILED")
    logError("Main start stopped because required runtime systems failed")
    return false
  end

  Main.startSchedulerHeartbeat()

  Main.finished = true
  Main.finishedAt = getCurrentTime()

  setModuleStatus("main", "RUNNING")

  logInfo("Main initialized")

  return true
end

function Main.stopRuntimeSystems()
  for _, systemDefinition in ipairs(Main.runtimeSystems) do
    local module = getNestedModule(systemDefinition.namespace, systemDefinition.moduleName)

    if hasStopFunction(module) == true then
      local success, result = pcall(module.stop)

      if success ~= true then
        logWarn("System stop failed: " .. systemDefinition.name .. " - " .. rawToString(result))
      else
        logDebug("System stopped: " .. systemDefinition.name)
      end
    end
  end

  return true
end

function Main.stop()
  local state = getState()

  Main.stopRuntimeSystems()

  if state ~= nil and state.setCampaignRunning ~= nil then
    state.setCampaignRunning(false)
  end

  Main.started = false
  Main.finished = false

  setModuleStatus("main", "STOPPED")

  logInfo("Main stopped")

  return true
end

function Main.pause()
  local state = getState()

  if state ~= nil and state.setCampaignPaused ~= nil then
    state.setCampaignPaused(true)
  end

  logInfo("Main paused")

  return true
end

function Main.resume()
  local state = getState()

  if state ~= nil and state.setCampaignPaused ~= nil then
    state.setCampaignPaused(false)
  end

  logInfo("Main resumed")

  return true
end

function Main.summary()
  local state = getState()
  local stateSummary = nil

  if state ~= nil and state.summary ~= nil then
    stateSummary = state.summary()
  end

  return {
    name = Main.name,
    path = Main.path,
    version = Main.version,
    loaded = Main.loaded,
    started = Main.started,
    finished = Main.finished,
    failed = Main.failed,
    startupPhase = Main.startupPhase,
    startedAt = Main.startedAt,
    finishedAt = Main.finishedAt,
    startedSystemCount = countTableKeys(Main.startedSystems),
    failedSystemCount = countTableKeys(Main.failedSystems),
    skippedSystemCount = countTableKeys(Main.skippedSystems),
    startedSystems = Main.startedSystems,
    failedSystems = Main.failedSystems,
    skippedSystems = Main.skippedSystems,
    state = stateSummary
  }
end

TC.Main = Main
TC.main = Main

TC.modules.main = {
  name = Main.name,
  path = Main.path,
  loaded = true,
  version = Main.version
}

return Main
