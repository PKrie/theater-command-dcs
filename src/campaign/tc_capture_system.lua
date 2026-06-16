-- Theater Command DCS
-- File: src/campaign/tc_capture_system.lua
-- Purpose: Strategic ownership and capture state management.

TC = TC or {}

TC.modules = TC.modules or {}
TC.Campaign = TC.Campaign or {}
TC.campaign = TC.campaign or TC.Campaign

local CaptureSystem = {}

CaptureSystem.name = "tc_capture_system"
CaptureSystem.path = "src/campaign/tc_capture_system.lua"
CaptureSystem.version = TC.version or "0.1.0"
CaptureSystem.loaded = true
CaptureSystem.started = false
CaptureSystem.finished = false
CaptureSystem.failed = false

CaptureSystem.lastUpdateTime = 0
CaptureSystem.captureEvents = {}

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

local function isValidOwner(owner)
  if owner == getOwnerBlue() then
    return true
  end

  if owner == getOwnerRed() then
    return true
  end

  if owner == getOwnerNeutral() then
    return true
  end

  if owner == getOwnerContested() then
    return true
  end

  if owner == getOwnerUnknown() then
    return true
  end

  return false
end

local function ensureCampaignTables()
  local state = getState()

  TC.Campaign = TC.Campaign or {}
  TC.campaign = TC.Campaign

  if state == nil then
    return nil
  end

  state.Campaign = state.Campaign or {}
  state.Bases = state.Bases or {}
  state.Zones = state.Zones or {}
  state.Persistence = state.Persistence or {}

  state.Bases.registry = state.Bases.registry or {}
  state.Zones.registry = state.Zones.registry or {}

  return state
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

local function updateOwnerCounters(container)
  if container == nil or type(container) ~= "table" then
    return false
  end

  container.total = 0
  container.blue = 0
  container.red = 0
  container.neutral = 0
  container.contested = 0
  container.unknown = 0

  if type(container.registry) ~= "table" then
    container.registry = {}
  end

  for _, record in pairs(container.registry) do
    local owner = record.currentOwner or record.initialOwner or getOwnerUnknown()

    container.total = container.total + 1

    if owner == getOwnerBlue() then
      container.blue = container.blue + 1
    elseif owner == getOwnerRed() then
      container.red = container.red + 1
    elseif owner == getOwnerNeutral() then
      container.neutral = container.neutral + 1
    elseif owner == getOwnerContested() then
      container.contested = container.contested + 1
    else
      container.unknown = container.unknown + 1
    end
  end

  return true
end

local function markDirty(reason)
  local state = getState()

  if state ~= nil and state.markDirty ~= nil then
    state.markDirty(reason or "capture_state_changed")
    return true
  end

  if state ~= nil then
    state.Persistence = state.Persistence or {}
    state.Persistence.dirty = true
    state.Persistence.dirtyReason = reason or "capture_state_changed"
    state.Persistence.dirtyAt = getCurrentTime()
    return true
  end

  return false
end

local function addCaptureEvent(eventData)
  if type(eventData) ~= "table" then
    return false
  end

  eventData.id = #CaptureSystem.captureEvents + 1
  eventData.time = eventData.time or getCurrentTime()

  table.insert(CaptureSystem.captureEvents, eventData)

  return true
end

local function syncWorldBase(record)
  if record == nil or record.key == nil then
    return false
  end

  if TC.World == nil then
    return false
  end

  TC.World.Airbases = TC.World.Airbases or {}
  TC.World.Airbases[record.key] = record

  return true
end

local function syncWorldZone(record)
  if record == nil or record.key == nil then
    return false
  end

  if TC.World == nil then
    return false
  end

  TC.World.Zones = TC.World.Zones or {}
  TC.World.Zones[record.key] = record

  return true
end

local function findRecordByKeyOrName(registry, keyOrName)
  if registry == nil or keyOrName == nil then
    return nil
  end

  if registry[keyOrName] ~= nil then
    return registry[keyOrName], keyOrName
  end

  local normalizedSearch = normalizeName(keyOrName)

  if normalizedSearch == nil then
    return nil
  end

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

  return nil
end

local function setRecordOwner(record, newOwner, reason)
  if record == nil then
    return false, "record_missing"
  end

  if isValidOwner(newOwner) ~= true then
    return false, "invalid_owner"
  end

  local previousOwner = record.currentOwner or record.initialOwner or getOwnerUnknown()

  if previousOwner == newOwner then
    record.lastOwnerCheckAt = getCurrentTime()
    return true, "owner_unchanged"
  end

  record.previousOwner = previousOwner
  record.currentOwner = newOwner
  record.captureReason = reason or "manual_capture_update"
  record.capturedAt = getCurrentTime()
  record.updatedAt = getCurrentTime()

  return true, previousOwner
end

function CaptureSystem.refreshCounters()
  local state = ensureCampaignTables()

  if state == nil then
    return false
  end

  updateOwnerCounters(state.Bases)
  updateOwnerCounters(state.Zones)

  CaptureSystem.lastUpdateTime = getCurrentTime()

  return true
end

function CaptureSystem.getBase(keyOrName)
  local registry = getBaseRegistry()
  local record = findRecordByKeyOrName(registry, keyOrName)

  return record
end

function CaptureSystem.getZone(keyOrName)
  local registry = getZoneRegistry()
  local record = findRecordByKeyOrName(registry, keyOrName)

  return record
end

function CaptureSystem.getBaseOwner(keyOrName)
  local record = CaptureSystem.getBase(keyOrName)

  if record == nil then
    return nil
  end

  return record.currentOwner or record.initialOwner or getOwnerUnknown()
end

function CaptureSystem.getZoneOwner(keyOrName)
  local record = CaptureSystem.getZone(keyOrName)

  if record == nil then
    return nil
  end

  return record.currentOwner or record.initialOwner or getOwnerUnknown()
end

function CaptureSystem.setBaseOwner(keyOrName, newOwner, reason)
  local state = ensureCampaignTables()

  if state == nil then
    return false, "state_unavailable"
  end

  local record, registryKey = findRecordByKeyOrName(state.Bases.registry, keyOrName)

  if record == nil then
    return false, "base_not_found"
  end

  local success, result = setRecordOwner(record, newOwner, reason)

  if success ~= true then
    return false, result
  end

  state.Bases.registry[registryKey] = record
  syncWorldBase(record)
  CaptureSystem.refreshCounters()

  addCaptureEvent({
    type = "BASE_OWNER_CHANGED",
    key = record.key,
    name = record.name,
    previousOwner = result,
    newOwner = newOwner,
    reason = reason or "manual_capture_update"
  })

  markDirty("base_owner_changed")

  if result == "owner_unchanged" then
    logDebug("Base owner unchanged: " .. record.name .. " [" .. newOwner .. "]")
  else
    logInfo("Base captured: " .. record.name .. " [" .. newOwner .. "]")
  end

  return true, record
end

function CaptureSystem.setZoneOwner(keyOrName, newOwner, reason)
  local state = ensureCampaignTables()

  if state == nil then
    return false, "state_unavailable"
  end

  local record, registryKey = findRecordByKeyOrName(state.Zones.registry, keyOrName)

  if record == nil then
    return false, "zone_not_found"
  end

  local success, result = setRecordOwner(record, newOwner, reason)

  if success ~= true then
    return false, result
  end

  state.Zones.registry[registryKey] = record
  syncWorldZone(record)
  CaptureSystem.refreshCounters()

  addCaptureEvent({
    type = "ZONE_OWNER_CHANGED",
    key = record.key,
    name = record.name,
    previousOwner = result,
    newOwner = newOwner,
    reason = reason or "manual_capture_update"
  })

  markDirty("zone_owner_changed")

  if result == "owner_unchanged" then
    logDebug("Zone owner unchanged: " .. record.name .. " [" .. newOwner .. "]")
  else
    logInfo("Zone captured: " .. record.name .. " [" .. newOwner .. "]")
  end

  return true, record
end

function CaptureSystem.setLinkedBaseOwnerFromZone(zoneKeyOrName, reason)
  local zoneRecord = CaptureSystem.getZone(zoneKeyOrName)

  if zoneRecord == nil then
    return false, "zone_not_found"
  end

  if zoneRecord.linkedAirbaseKey == nil then
    return false, "zone_has_no_linked_airbase"
  end

  local owner = zoneRecord.currentOwner or zoneRecord.initialOwner or getOwnerUnknown()

  return CaptureSystem.setBaseOwner(
    zoneRecord.linkedAirbaseKey,
    owner,
    reason or "linked_zone_owner_changed"
  )
end

function CaptureSystem.setLinkedZoneOwnerFromBase(baseKeyOrName, reason)
  local baseRecord = CaptureSystem.getBase(baseKeyOrName)

  if baseRecord == nil then
    return false, "base_not_found"
  end

  local owner = baseRecord.currentOwner or baseRecord.initialOwner or getOwnerUnknown()
  local zones = getZoneRegistry()
  local changed = 0

  for _, zoneRecord in pairs(zones) do
    if zoneRecord.linkedAirbaseKey == baseRecord.key then
      local success = CaptureSystem.setZoneOwner(
        zoneRecord.key,
        owner,
        reason or "linked_base_owner_changed"
      )

      if success == true then
        changed = changed + 1
      end
    end
  end

  return true, changed
end

function CaptureSystem.captureBaseForBlue(keyOrName, reason)
  return CaptureSystem.setBaseOwner(keyOrName, getOwnerBlue(), reason or "capture_for_blue")
end

function CaptureSystem.captureBaseForRed(keyOrName, reason)
  return CaptureSystem.setBaseOwner(keyOrName, getOwnerRed(), reason or "capture_for_red")
end

function CaptureSystem.captureBaseForNeutral(keyOrName, reason)
  return CaptureSystem.setBaseOwner(keyOrName, getOwnerNeutral(), reason or "capture_for_neutral")
end

function CaptureSystem.contestBase(keyOrName, reason)
  return CaptureSystem.setBaseOwner(keyOrName, getOwnerContested(), reason or "base_contested")
end

function CaptureSystem.captureZoneForBlue(keyOrName, reason)
  return CaptureSystem.setZoneOwner(keyOrName, getOwnerBlue(), reason or "capture_for_blue")
end

function CaptureSystem.captureZoneForRed(keyOrName, reason)
  return CaptureSystem.setZoneOwner(keyOrName, getOwnerRed(), reason or "capture_for_red")
end

function CaptureSystem.captureZoneForNeutral(keyOrName, reason)
  return CaptureSystem.setZoneOwner(keyOrName, getOwnerNeutral(), reason or "capture_for_neutral")
end

function CaptureSystem.contestZone(keyOrName, reason)
  return CaptureSystem.setZoneOwner(keyOrName, getOwnerContested(), reason or "zone_contested")
end

function CaptureSystem.getBasesByOwner(owner)
  local result = {}
  local registry = getBaseRegistry()

  for key, record in pairs(registry) do
    local recordOwner = record.currentOwner or record.initialOwner or getOwnerUnknown()

    if recordOwner == owner then
      result[key] = record
    end
  end

  return result
end

function CaptureSystem.getZonesByOwner(owner)
  local result = {}
  local registry = getZoneRegistry()

  for key, record in pairs(registry) do
    local recordOwner = record.currentOwner or record.initialOwner or getOwnerUnknown()

    if recordOwner == owner then
      result[key] = record
    end
  end

  return result
end

function CaptureSystem.getBlueBases()
  return CaptureSystem.getBasesByOwner(getOwnerBlue())
end

function CaptureSystem.getRedBases()
  return CaptureSystem.getBasesByOwner(getOwnerRed())
end

function CaptureSystem.getNeutralBases()
  return CaptureSystem.getBasesByOwner(getOwnerNeutral())
end

function CaptureSystem.getContestedBases()
  return CaptureSystem.getBasesByOwner(getOwnerContested())
end

function CaptureSystem.getBlueZones()
  return CaptureSystem.getZonesByOwner(getOwnerBlue())
end

function CaptureSystem.getRedZones()
  return CaptureSystem.getZonesByOwner(getOwnerRed())
end

function CaptureSystem.getNeutralZones()
  return CaptureSystem.getZonesByOwner(getOwnerNeutral())
end

function CaptureSystem.getContestedZones()
  return CaptureSystem.getZonesByOwner(getOwnerContested())
end

function CaptureSystem.restoreInitialOwnership()
  local state = ensureCampaignTables()

  if state == nil then
    return false
  end

  for _, baseRecord in pairs(state.Bases.registry) do
    baseRecord.currentOwner = baseRecord.initialOwner or getOwnerUnknown()
    baseRecord.previousOwner = nil
    baseRecord.captureReason = "restore_initial_ownership"
    baseRecord.updatedAt = getCurrentTime()
    syncWorldBase(baseRecord)
  end

  for _, zoneRecord in pairs(state.Zones.registry) do
    zoneRecord.currentOwner = zoneRecord.initialOwner or getOwnerUnknown()
    zoneRecord.previousOwner = nil
    zoneRecord.captureReason = "restore_initial_ownership"
    zoneRecord.updatedAt = getCurrentTime()
    syncWorldZone(zoneRecord)
  end

  CaptureSystem.refreshCounters()
  markDirty("initial_ownership_restored")

  addCaptureEvent({
    type = "INITIAL_OWNERSHIP_RESTORED",
    reason = "restore_initial_ownership"
  })

  logInfo("Initial ownership restored")

  return true
end

function CaptureSystem.validateState()
  local state = ensureCampaignTables()

  if state == nil then
    return false, "state_unavailable"
  end

  local baseCount = countTableKeys(state.Bases.registry)
  local zoneCount = countTableKeys(state.Zones.registry)

  if baseCount == 0 then
    logWarn("Capture system validation warning: no bases registered")
  end

  if zoneCount == 0 then
    logWarn("Capture system validation warning: no zones registered")
  end

  CaptureSystem.refreshCounters()

  return true, {
    baseCount = baseCount,
    zoneCount = zoneCount
  }
end

function CaptureSystem.start()
  CaptureSystem.started = true
  CaptureSystem.finished = false
  CaptureSystem.failed = false
  CaptureSystem.lastUpdateTime = getCurrentTime()

  logInfo("Capture system started")

  ensureCampaignTables()

  local valid, result = CaptureSystem.validateState()

  if valid ~= true then
    CaptureSystem.failed = true
    logError("Capture system validation failed: " .. tostring(result))
    return false
  end

  local state = getState()

  if state ~= nil then
    if state.setFeatureStatus ~= nil then
      state.setFeatureStatus("captureSystem", true)
    end

    if state.setModuleStatus ~= nil then
      state.setModuleStatus("captureSystem", "RUNNING")
    end
  end

  CaptureSystem.finished = true

  logInfo("Capture system initialized")

  return true
end

function CaptureSystem.stop()
  CaptureSystem.started = false

  local state = getState()

  if state ~= nil and state.setModuleStatus ~= nil then
    state.setModuleStatus("captureSystem", "STOPPED")
  end

  logInfo("Capture system stopped")

  return true
end

function CaptureSystem.getEvents()
  return CaptureSystem.captureEvents
end

function CaptureSystem.clearEvents()
  CaptureSystem.captureEvents = {}

  return true
end

function CaptureSystem.summary()
  local state = getState()
  local bases = nil
  local zones = nil

  if state ~= nil then
    bases = state.Bases
    zones = state.Zones
  end

  return {
    name = CaptureSystem.name,
    path = CaptureSystem.path,
    version = CaptureSystem.version,
    loaded = CaptureSystem.loaded,
    started = CaptureSystem.started,
    finished = CaptureSystem.finished,
    failed = CaptureSystem.failed,
    lastUpdateTime = CaptureSystem.lastUpdateTime,
    captureEventCount = #CaptureSystem.captureEvents,
    baseCount = bases and bases.total or 0,
    zoneCount = zones and zones.total or 0,
    bases = bases,
    zones = zones
  }
end

TC.Campaign.CaptureSystem = CaptureSystem

TC.modules.captureSystem = {
  name = CaptureSystem.name,
  path = CaptureSystem.path,
  loaded = true,
  version = CaptureSystem.version
}

local state = getState()

if state ~= nil and state.setModuleStatus ~= nil then
  state.setModuleStatus("captureSystem", "LOADED")
end

logInfo("Capture system loaded")

return CaptureSystem
