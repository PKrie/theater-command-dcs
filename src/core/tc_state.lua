-- Theater Command DCS
-- File: src/core/tc_state.lua
-- Purpose: Central strategic campaign state.

TC = TC or {}

TC.modules = TC.modules or {}

local State = {}

State.name = "tc_state"
State.path = "src/core/tc_state.lua"
State.version = TC.version or "0.1.0"
State.loaded = true

local stateSections = {
  "Meta",
  "Campaign",
  "World",
  "Bases",
  "Zones",
  "Logistics",
  "Missions",
  "AI",
  "IADS",
  "Persistence",
  "Debug"
}

local function getConfig()
  return TC.config or TC.Config or {}
end

local function getLogger()
  return TC.Logger or TC.logger
end

local function getCurrentTime()
  if timer ~= nil and timer.getTime ~= nil then
    return timer.getTime()
  end

  return 0
end

local function logDebug(message)
  local logger = getLogger()

  if logger ~= nil and logger.state ~= nil then
    logger.state(message)
    return
  end

  if logger ~= nil and logger.debug ~= nil then
    logger.debug(message)
  end
end

local function logInfo(message)
  local logger = getLogger()

  if logger ~= nil and logger.info ~= nil then
    logger.info(message)
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

local function copyValue(value)
  if type(value) ~= "table" then
    return value
  end

  local result = {}

  for key, childValue in pairs(value) do
    result[key] = copyValue(childValue)
  end

  return result
end

local function createDefaultState()
  local config = getConfig()
  local campaignConfig = config.campaign or {}

  local redOwnership = getConstant("ownership", "RED", "RED")
  local blueOwnership = getConstant("ownership", "BLUE", "BLUE")
  local unknownStatus = getConstant("status", "UNKNOWN", "UNKNOWN")

  return {
    Meta = {
      initialized = false,
      createdAt = getCurrentTime(),
      updatedAt = getCurrentTime(),
      version = State.version,
      projectName = "Theater Command DCS"
    },

    Campaign = {
      name = campaignConfig.name or "Operation Levant Reclamation",
      map = campaignConfig.map or "Syria",
      phase = "PHASE_1_CORE_SETUP",
      blueStartRegion = campaignConfig.blueStartRegion or "CYPRUS",
      blueStartBase = campaignConfig.blueStartBase or "AKROTIRI",
      initialBlueTerritory = campaignConfig.initialBlueTerritory or "CYPRUS",
      initialRedTerritory = campaignConfig.initialRedTerritory or "SYRIAN_MAINLAND",
      initialFrontlineState = campaignConfig.initialFrontlineState or "RED_MAINLAND_CONTROL",
      isRunning = false,
      isPaused = false,
      tick = 0
    },

    World = {
      map = campaignConfig.map or "Syria",
      scanned = false,
      airbaseScanComplete = false,
      zoneFactoryComplete = false,
      status = unknownStatus
    },

    Bases = {
      blueStartBase = campaignConfig.blueStartBase or "AKROTIRI",
      total = 0,
      blue = 0,
      red = 0,
      neutral = 0,
      contested = 0,
      registry = {}
    },

    Zones = {
      total = 0,
      blue = 0,
      red = 0,
      neutral = 0,
      contested = 0,
      registry = {}
    },

    Logistics = {
      enabled = false,
      hubs = {},
      deliveries = {},
      fobs = {},
      lastDeliveryId = 0
    },

    Missions = {
      enabled = false,
      available = {},
      active = {},
      completed = {},
      failed = {},
      lastMissionId = 0
    },

    AI = {
      enabled = false,
      directorEnabled = false,
      capManagerEnabled = false,
      lastUpdate = 0,
      threatLevel = "UNKNOWN"
    },

    IADS = {
      enabled = false,
      networks = {},
      sectors = {},
      sites = {},
      status = unknownStatus
    },

    Persistence = {
      enabled = false,
      dirty = false,
      lastSaveTime = 0,
      lastLoadTime = 0,
      saveName = "operation_levant_reclamation"
    },

    Debug = {
      enabled = true,
      flags = {},
      moduleStatus = {},
      featureStatus = {
        core = true,
        airbaseScanner = false,
        zoneFactory = false,
        captureSystem = false,
        logisticsDelivery = false,
        fobSystem = false,
        missionGenerator = false,
        aiCapManager = false,
        iadsIntegration = false,
        persistence = false,
        f10Menu = false,
        debugTools = false
      }
    }
  }
end

local function applyState(defaultState)
  for _, sectionName in ipairs(stateSections) do
    State[sectionName] = defaultState[sectionName] or {}
  end
end

local function updateTimestamp()
  if State.Meta == nil then
    return
  end

  State.Meta.updatedAt = getCurrentTime()
end

function State.createDefault()
  return createDefaultState()
end

function State.init()
  local defaultState = createDefaultState()

  applyState(defaultState)

  State.Meta.initialized = true
  State.Meta.updatedAt = getCurrentTime()

  TC.State = State
  TC.state = State

  logDebug("State initialized")

  return State
end

function State.reset()
  local defaultState = createDefaultState()

  applyState(defaultState)

  State.Meta.initialized = true
  State.Meta.updatedAt = getCurrentTime()

  logDebug("State reset")

  return State
end

function State.isInitialized()
  if State.Meta == nil then
    return false
  end

  return State.Meta.initialized == true
end

function State.getSection(sectionName)
  if sectionName == nil then
    return nil
  end

  return State[sectionName]
end

function State.ensureSection(sectionName)
  if sectionName == nil then
    return nil
  end

  if State[sectionName] == nil then
    State[sectionName] = {}
    updateTimestamp()
  end

  return State[sectionName]
end

function State.setValue(sectionName, keyName, value)
  if sectionName == nil or keyName == nil then
    return false
  end

  local section = State.ensureSection(sectionName)

  if section == nil then
    return false
  end

  section[keyName] = value
  updateTimestamp()

  return true
end

function State.getValue(sectionName, keyName, fallback)
  if sectionName == nil or keyName == nil then
    return fallback
  end

  local section = State.getSection(sectionName)

  if section == nil then
    return fallback
  end

  if section[keyName] == nil then
    return fallback
  end

  return section[keyName]
end

function State.setCampaignRunning(isRunning)
  State.Campaign = State.Campaign or {}
  State.Campaign.isRunning = isRunning == true
  updateTimestamp()

  return State.Campaign.isRunning
end

function State.setCampaignPaused(isPaused)
  State.Campaign = State.Campaign or {}
  State.Campaign.isPaused = isPaused == true
  updateTimestamp()

  return State.Campaign.isPaused
end

function State.setCampaignPhase(phaseName)
  if phaseName == nil then
    return false
  end

  State.Campaign = State.Campaign or {}
  State.Campaign.phase = phaseName
  updateTimestamp()

  return true
end

function State.incrementTick()
  State.Campaign = State.Campaign or {}
  State.Campaign.tick = (State.Campaign.tick or 0) + 1
  updateTimestamp()

  return State.Campaign.tick
end

function State.setFeatureStatus(featureName, isEnabled)
  if featureName == nil then
    return false
  end

  State.Debug = State.Debug or {}
  State.Debug.featureStatus = State.Debug.featureStatus or {}
  State.Debug.featureStatus[featureName] = isEnabled == true
  updateTimestamp()

  return true
end

function State.getFeatureStatus(featureName)
  if featureName == nil then
    return false
  end

  if State.Debug == nil or State.Debug.featureStatus == nil then
    return false
  end

  return State.Debug.featureStatus[featureName] == true
end

function State.setModuleStatus(moduleName, status)
  if moduleName == nil then
    return false
  end

  State.Debug = State.Debug or {}
  State.Debug.moduleStatus = State.Debug.moduleStatus or {}

  State.Debug.moduleStatus[moduleName] = {
    status = status or "UNKNOWN",
    updatedAt = getCurrentTime()
  }

  updateTimestamp()

  return true
end

function State.setFlag(flagName, value)
  if flagName == nil then
    return false
  end

  State.Debug = State.Debug or {}
  State.Debug.flags = State.Debug.flags or {}
  State.Debug.flags[flagName] = value
  updateTimestamp()

  return true
end

function State.getFlag(flagName, fallback)
  if flagName == nil then
    return fallback
  end

  if State.Debug == nil or State.Debug.flags == nil then
    return fallback
  end

  if State.Debug.flags[flagName] == nil then
    return fallback
  end

  return State.Debug.flags[flagName]
end

function State.markDirty(reason)
  State.Persistence = State.Persistence or {}
  State.Persistence.dirty = true
  State.Persistence.dirtyReason = reason or "state_changed"
  State.Persistence.dirtyAt = getCurrentTime()
  updateTimestamp()

  return true
end

function State.clearDirty()
  State.Persistence = State.Persistence or {}
  State.Persistence.dirty = false
  State.Persistence.dirtyReason = nil
  State.Persistence.dirtyAt = nil
  updateTimestamp()

  return true
end

function State.snapshot()
  local snapshot = {}

  for _, sectionName in ipairs(stateSections) do
    snapshot[sectionName] = copyValue(State[sectionName])
  end

  return snapshot
end

function State.summary()
  State.Campaign = State.Campaign or {}
  State.Bases = State.Bases or {}
  State.Zones = State.Zones or {}
  State.Missions = State.Missions or {}
  State.Logistics = State.Logistics or {}
  State.IADS = State.IADS or {}

  return {
    campaign = State.Campaign.name,
    phase = State.Campaign.phase,
    map = State.Campaign.map,
    tick = State.Campaign.tick,
    basesTotal = State.Bases.total,
    zonesTotal = State.Zones.total,
    activeMissions = #State.Missions.active,
    completedMissions = #State.Missions.completed,
    logisticsEnabled = State.Logistics.enabled,
    iadsEnabled = State.IADS.enabled
  }
end

TC.State = State
TC.state = State

TC.modules.state = {
  name = State.name,
  path = State.path,
  loaded = true,
  version = State.version
}

State.init()

logInfo("State module loaded")

return State
