-- Theater Command DCS
-- File: src/loader.lua
-- Purpose: Main loader for the Theater Command DCS Lua system.

TC = TC or {}

TC.version = TC.version or "0.1.0"
TC.modules = TC.modules or {}
TC.loader = TC.loader or {}

local Loader = {}

Loader.name = "loader"
Loader.path = "src/loader.lua"
Loader.version = TC.version
Loader.loaded = true
Loader.started = false
Loader.finished = false
Loader.failed = false

Loader.scriptRoot = TC.scriptRoot or ""

Loader.coreFiles = {
  {
    key = "config",
    name = "tc_config",
    path = "src/core/tc_config.lua",
    required = true,
    isLoaded = function()
      return TC.config ~= nil or TC.Config ~= nil
    end
  },
  {
    key = "logger",
    name = "tc_logger",
    path = "src/core/tc_logger.lua",
    required = true,
    isLoaded = function()
      return TC.Logger ~= nil or TC.logger ~= nil
    end
  },
  {
    key = "state",
    name = "tc_state",
    path = "src/core/tc_state.lua",
    required = true,
    isLoaded = function()
      return TC.State ~= nil or TC.state ~= nil
    end
  },
  {
    key = "utils",
    name = "tc_utils",
    path = "src/core/tc_utils.lua",
    required = true,
    isLoaded = function()
      return TC.Utils ~= nil or TC.utils ~= nil
    end
  },
  {
    key = "scheduler",
    name = "tc_scheduler",
    path = "src/core/tc_scheduler.lua",
    required = true,
    isLoaded = function()
      return TC.Scheduler ~= nil or TC.scheduler ~= nil
    end
  }
}

Loader.worldFiles = {
  {
    key = "airbaseScanner",
    name = "tc_airbase_scanner",
    path = "src/world/tc_airbase_scanner.lua",
    required = true,
    isLoaded = function()
      return TC.World ~= nil and TC.World.AirbaseScanner ~= nil
    end
  },
  {
    key = "zoneFactory",
    name = "tc_zone_factory",
    path = "src/world/tc_zone_factory.lua",
    required = true,
    isLoaded = function()
      return TC.World ~= nil and TC.World.ZoneFactory ~= nil
    end
  }
}

Loader.campaignFiles = {
  {
    key = "captureSystem",
    name = "tc_capture_system",
    path = "src/campaign/tc_capture_system.lua",
    required = true,
    isLoaded = function()
      return TC.Campaign ~= nil and TC.Campaign.CaptureSystem ~= nil
    end
  },
  {
    key = "persistenceSystem",
    name = "tc_persistence_system",
    path = "src/campaign/tc_persistence_system.lua",
    required = true,
    isLoaded = function()
      return TC.Campaign ~= nil and TC.Campaign.PersistenceSystem ~= nil
    end
  }
}

Loader.logisticsFiles = {
  {
    key = "logisticsDelivery",
    name = "tc_logistics_delivery",
    path = "src/logistics/tc_logistics_delivery.lua",
    required = true,
    isLoaded = function()
      return TC.Logistics ~= nil and TC.Logistics.Delivery ~= nil
    end
  },
  {
    key = "fobSystem",
    name = "tc_fob_system",
    path = "src/logistics/tc_fob_system.lua",
    required = true,
    isLoaded = function()
      return TC.Logistics ~= nil and TC.Logistics.FobSystem ~= nil
    end
  }
}

Loader.missionFiles = {
  {
    key = "missionGenerator",
    name = "tc_mission_generator",
    path = "src/missions/tc_mission_generator.lua",
    required = true,
    isLoaded = function()
      return TC.Missions ~= nil and TC.Missions.Generator ~= nil
    end
  }
}

Loader.aiFiles = {
  {
    key = "aiCapManager",
    name = "tc_ai_cap_manager",
    path = "src/ai/tc_ai_cap_manager.lua",
    required = true,
    isLoaded = function()
      return TC.AI ~= nil and TC.AI.CapManager ~= nil
    end
  }
}

Loader.mainFile = {
  key = "main",
  name = "main",
  path = "src/main.lua",
  required = true,
  isLoaded = function()
    return TC.Main ~= nil or TC.main ~= nil
  end
}

Loader.frameworks = {
  {
    key = "mist",
    name = "MIST",
    required = true,
    isLoaded = function()
      return mist ~= nil
    end
  },
  {
    key = "moose",
    name = "MOOSE",
    required = true,
    isLoaded = function()
      return BASE ~= nil
    end
  },
  {
    key = "ctld",
    name = "CTLD",
    required = true,
    isLoaded = function()
      return ctld ~= nil
    end
  },
  {
    key = "skynetIads",
    name = "Skynet IADS",
    required = true,
    isLoaded = function()
      return SkynetIADS ~= nil
    end
  }
}

local function rawToString(value)
  if value == nil then
    return "nil"
  end

  return tostring(value)
end

local function getLogger()
  return TC.Logger or TC.logger
end

local function writeRawLog(level, message)
  local prefix = "[TC][LOADER]"
  local formattedMessage = prefix .. " " .. rawToString(message)

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

local function getState()
  return TC.State or TC.state
end

local function markModuleStatus(moduleKey, moduleName, modulePath, loaded, reason)
  TC.modules = TC.modules or {}

  TC.modules[moduleKey] = {
    name = moduleName or moduleKey,
    path = modulePath or "unknown_path",
    loaded = loaded == true,
    reason = reason,
    version = TC.version
  }

  local state = getState()

  if state ~= nil and state.setModuleStatus ~= nil then
    if loaded == true then
      state.setModuleStatus(moduleKey, "LOADED")
    else
      state.setModuleStatus(moduleKey, "FAILED")
    end
  end
end

local function buildScriptPath(path)
  if path == nil then
    return nil
  end

  if Loader.scriptRoot == nil or Loader.scriptRoot == "" then
    return path
  end

  return Loader.scriptRoot .. path
end

local function canUseDofile()
  return dofile ~= nil and type(dofile) == "function"
end

local function safeDofile(path)
  if path == nil then
    return false, "missing_path"
  end

  if canUseDofile() ~= true then
    return false, "dofile_unavailable"
  end

  local fullPath = buildScriptPath(path)
  local success, result = pcall(dofile, fullPath)

  if success ~= true then
    return false, result
  end

  return true, result
end

local function checkItemLoaded(item)
  if item == nil then
    return false
  end

  if type(item.isLoaded) ~= "function" then
    return false
  end

  local success, result = pcall(item.isLoaded)

  if success ~= true then
    return false
  end

  return result == true
end

local function loadFile(item)
  if item == nil then
    return false
  end

  if checkItemLoaded(item) == true then
    markModuleStatus(item.key, item.name, item.path, true, nil)
    logDebug("Already loaded: " .. item.name)
    return true
  end

  logInfo("Loading file: " .. item.path)

  local success, result = safeDofile(item.path)

  if success ~= true then
    local reason = rawToString(result)

    markModuleStatus(item.key, item.name, item.path, false, reason)

    if item.required == true then
      logError("Required file failed: " .. item.path .. " - " .. reason)
    else
      logWarn("Optional file failed: " .. item.path .. " - " .. reason)
    end

    return false
  end

  if checkItemLoaded(item) ~= true then
    local reason = "file_executed_but_module_not_detected"

    markModuleStatus(item.key, item.name, item.path, false, reason)

    if item.required == true then
      logError("Required module not detected after load: " .. item.name)
    else
      logWarn("Optional module not detected after load: " .. item.name)
    end

    return false
  end

  markModuleStatus(item.key, item.name, item.path, true, nil)
  logInfo("Loaded file: " .. item.path)

  return true
end

local function loadFileGroup(groupName, fileList)
  local allRequiredLoaded = true

  logInfo(groupName .. " loading started")

  for _, fileDefinition in ipairs(fileList) do
    local loaded = loadFile(fileDefinition)

    if loaded ~= true and fileDefinition.required == true then
      allRequiredLoaded = false
    end
  end

  if allRequiredLoaded == true then
    logInfo(groupName .. " loading finished")
  else
    logError(groupName .. " loading failed")
  end

  return allRequiredLoaded
end

function Loader.setScriptRoot(scriptRoot)
  Loader.scriptRoot = scriptRoot or ""
  TC.scriptRoot = Loader.scriptRoot

  return Loader.scriptRoot
end

function Loader.checkFrameworks()
  local allRequiredAvailable = true

  for _, framework in ipairs(Loader.frameworks) do
    local available = checkItemLoaded(framework)

    if available == true then
      markModuleStatus(framework.key, framework.name, "vendor", true, nil)
      logInfo("Framework available: " .. framework.name)
    else
      markModuleStatus(framework.key, framework.name, "vendor", false, "framework_missing")

      if framework.required == true then
        allRequiredAvailable = false
        logError("Required framework missing: " .. framework.name)
      else
        logWarn("Optional framework missing: " .. framework.name)
      end
    end
  end

  return allRequiredAvailable
end

function Loader.loadCore()
  return loadFileGroup("Core", Loader.coreFiles)
end

function Loader.loadWorld()
  return loadFileGroup("World", Loader.worldFiles)
end

function Loader.loadCampaign()
  return loadFileGroup("Campaign", Loader.campaignFiles)
end

function Loader.loadLogistics()
  return loadFileGroup("Logistics", Loader.logisticsFiles)
end

function Loader.loadMissions()
  return loadFileGroup("Missions", Loader.missionFiles)
end

function Loader.loadAI()
  return loadFileGroup("AI", Loader.aiFiles)
end

function Loader.loadMain()
  if Loader.mainFile == nil then
    return false
  end

  if checkItemLoaded(Loader.mainFile) == true then
    markModuleStatus(Loader.mainFile.key, Loader.mainFile.name, Loader.mainFile.path, true, nil)
    logInfo("Main already loaded")
    return true
  end

  local loaded = loadFile(Loader.mainFile)

  if loaded ~= true then
    logError("Main loading failed")
    return false
  end

  return true
end

function Loader.startMain()
  local main = TC.Main or TC.main

  if main == nil then
    logError("Main start failed because main module is not available")
    return false
  end

  if type(main.start) ~= "function" then
    logError("Main start failed because main.start is not available")
    return false
  end

  local success, result = pcall(main.start)

  if success ~= true then
    logError("Main start failed: " .. rawToString(result))
    return false
  end

  logInfo("Main started")

  return true
end

function Loader.start()
  Loader.started = true
  Loader.finished = false
  Loader.failed = false

  TC.Loader = Loader
  TC.loader = Loader

  markModuleStatus("loader", Loader.name, Loader.path, true, nil)

  logInfo("Theater Command loader started")

  local frameworksAvailable = Loader.checkFrameworks()

  if frameworksAvailable ~= true then
    Loader.failed = true
    logError("Theater Command loader stopped because required frameworks are missing")
    return false
  end

  local coreLoaded = Loader.loadCore()

  if coreLoaded ~= true then
    Loader.failed = true
    logError("Theater Command loader stopped because core loading failed")
    return false
  end

  local worldLoaded = Loader.loadWorld()

  if worldLoaded ~= true then
    Loader.failed = true
    logError("Theater Command loader stopped because world loading failed")
    return false
  end

  local campaignLoaded = Loader.loadCampaign()

  if campaignLoaded ~= true then
    Loader.failed = true
    logError("Theater Command loader stopped because campaign loading failed")
    return false
  end

  local logisticsLoaded = Loader.loadLogistics()

  if logisticsLoaded ~= true then
    Loader.failed = true
    logError("Theater Command loader stopped because logistics loading failed")
    return false
  end

  local missionsLoaded = Loader.loadMissions()

  if missionsLoaded ~= true then
    Loader.failed = true
    logError("Theater Command loader stopped because missions loading failed")
    return false
  end

  local aiLoaded = Loader.loadAI()

  if aiLoaded ~= true then
    Loader.failed = true
    logError("Theater Command loader stopped because AI loading failed")
    return false
  end

  local mainLoaded = Loader.loadMain()

  if mainLoaded ~= true then
    Loader.failed = true
    logError("Theater Command loader stopped because main loading failed")
    return false
  end

  local mainStarted = Loader.startMain()

  if mainStarted ~= true then
    Loader.failed = true
    logError("Theater Command loader stopped because main start failed")
    return false
  end

  Loader.finished = true

  logInfo("Theater Command loader finished")

  return true
end

function Loader.summary()
  return {
    name = Loader.name,
    path = Loader.path,
    version = Loader.version,
    started = Loader.started,
    finished = Loader.finished,
    failed = Loader.failed,
    scriptRoot = Loader.scriptRoot,
    coreFileCount = #Loader.coreFiles,
    worldFileCount = #Loader.worldFiles,
    campaignFileCount = #Loader.campaignFiles,
    logisticsFileCount = #Loader.logisticsFiles,
    missionFileCount = #Loader.missionFiles,
    aiFileCount = #Loader.aiFiles
  }
end

TC.Loader = Loader
TC.loader = Loader

TC.modules.loader = {
  name = Loader.name,
  path = Loader.path,
  loaded = true,
  version = Loader.version
}

Loader.start()

return Loader
