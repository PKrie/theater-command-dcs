-- Theater Command DCS
-- File: src/ai/tc_ai_cap_manager.lua
-- Purpose: Manage strategic Combat Air Patrol requests and state.

TC = TC or {}

TC.modules = TC.modules or {}
TC.AI = TC.AI or {}
TC.ai = TC.ai or TC.AI

local CapManager = {}

CapManager.name = "tc_ai_cap_manager"
CapManager.path = "src/ai/tc_ai_cap_manager.lua"
CapManager.version = TC.version or "0.1.0"
CapManager.loaded = true
CapManager.started = false
CapManager.finished = false
CapManager.failed = false

CapManager.lastUpdateTime = 0
CapManager.defaultCapLimit = 12
CapManager.defaultMaxActivePerZone = 1

CapManager.sides = {
  BLUE = "BLUE",
  RED = "RED",
  NEUTRAL = "NEUTRAL"
}

CapManager.status = {
  REGISTERED = "REGISTERED",
  REQUESTED = "REQUESTED",
  ACTIVE = "ACTIVE",
  COMPLETED = "COMPLETED",
  FAILED = "FAILED",
  CANCELLED = "CANCELLED"
}

CapManager.defaultPriorities = {
  BLUE_HOME = 50,
  BLUE_FRONTLINE = 65,
  RED_DEFENSIVE = 60,
  RED_FRONTLINE = 70,
  CONTESTED = 80,
  MISSION_REACTION = 75
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
    if type(childValue) ~= "function" and type(childValue) ~= "userdata" and type(childValue) ~= "thread" then
      result[copyValue(key, visited)] = copyValue(childValue, visited)
    end
  end

  visited[value] = nil

  return result
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
  if record == nil then
    return getOwnerUnknown()
  end

  return record.currentOwner or record.initialOwner or record.owner or getOwnerUnknown()
end

local function ensureAiState()
  local state = getState()

  TC.AI = TC.AI or {}
  TC.ai = TC.AI

  if state == nil then
    return nil
  end

  state.AI = state.AI or {}
  state.AI.enabled = true
  state.AI.directorEnabled = state.AI.directorEnabled == true
  state.AI.capManagerEnabled = true
  state.AI.lastUpdate = state.AI.lastUpdate or 0
  state.AI.threatLevel = state.AI.threatLevel or "UNKNOWN"
  state.AI.reactionState = state.AI.reactionState or "STANDBY"
  state.AI.escalationLevel = state.AI.escalationLevel or 0
  state.AI.lastCapId = state.AI.lastCapId or 0
  state.AI.capZones = state.AI.capZones or {}
  state.AI.capRequests = state.AI.capRequests or {}
  state.AI.activeCaps = state.AI.activeCaps or {}
  state.AI.completedCaps = state.AI.completedCaps or {}
  state.AI.failedCaps = state.AI.failedCaps or {}
  state.AI.cancelledCaps = state.AI.cancelledCaps or {}
  state.AI.capStatistics = state.AI.capStatistics or {
    zones = 0,
    requested = 0,
    active = 0,
    completed = 0,
    failed = 0,
    cancelled = 0
  }

  return state
end

local function markDirty(reason)
  local state = getState()

  if state ~= nil and state.markDirty ~= nil then
    state.markDirty(reason or "ai_cap_state_changed")
    return true
  end

  if state ~= nil then
    state.Persistence = state.Persistence or {}
    state.Persistence.dirty = true
    state.Persistence.dirtyReason = reason or "ai_cap_state_changed"
    state.Persistence.dirtyAt = getCurrentTime()
    return true
  end

  return false
end

local function setModuleStatus(status)
  local state = getState()

  if state ~= nil and state.setModuleStatus ~= nil then
    state.setModuleStatus("aiCapManager", status)
  end
end

local function setFeatureStatus(enabled)
  local state = getState()

  if state ~= nil and state.setFeatureStatus ~= nil then
    state.setFeatureStatus("aiCapManager", enabled == true)
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

local function getMissionState()
  local state = getState()

  if state ~= nil and state.Missions ~= nil then
    return state.Missions
  end

  return nil
end

local function findZoneByKeyOrName(keyOrName)
  if keyOrName == nil then
    return nil
  end

  local registry = getZoneRegistry()

  if registry[keyOrName] ~= nil then
    return registry[keyOrName]
  end

  local normalizedSearch = normalizeName(keyOrName)

  for _, zoneRecord in pairs(registry) do
    if zoneRecord.normalizedName == normalizedSearch then
      return zoneRecord
    end

    if normalizeName(zoneRecord.name) == normalizedSearch then
      return zoneRecord
    end

    if normalizeName(zoneRecord.displayName) == normalizedSearch then
      return zoneRecord
    end
  end

  return nil
end

local function findBaseByKeyOrName(keyOrName)
  if keyOrName == nil then
    return nil
  end

  local registry = getBaseRegistry()

  if registry[keyOrName] ~= nil then
    return registry[keyOrName]
  end

  local normalizedSearch = normalizeName(keyOrName)

  for _, baseRecord in pairs(registry) do
    if baseRecord.normalizedName == normalizedSearch then
      return baseRecord
    end

    if normalizeName(baseRecord.name) == normalizedSearch then
      return baseRecord
    end

    if normalizeName(baseRecord.displayName) == normalizedSearch then
      return baseRecord
    end
  end

  return nil
end

local function findPreferredBaseForSide(side, zoneRecord)
  if zoneRecord ~= nil and zoneRecord.linkedAirbaseKey ~= nil then
    local linkedBase = findBaseByKeyOrName(zoneRecord.linkedAirbaseKey)

    if linkedBase ~= nil and getRecordOwner(linkedBase) == side then
      return linkedBase
    end
  end

  for _, baseRecord in pairs(getBaseRegistry()) do
    if getRecordOwner(baseRecord) == side then
      if side == CapManager.sides.BLUE and baseRecord.isStartBase == true then
        return baseRecord
      end
    end
  end

  for _, baseRecord in pairs(getBaseRegistry()) do
    if getRecordOwner(baseRecord) == side then
      return baseRecord
    end
  end

  return nil
end

local function isValidSide(side)
  if side == CapManager.sides.BLUE then
    return true
  end

  if side == CapManager.sides.RED then
    return true
  end

  if side == CapManager.sides.NEUTRAL then
    return true
  end

  return false
end

local function isValidStatus(status)
  if status == nil then
    return false
  end

  for _, allowedStatus in pairs(CapManager.status) do
    if status == allowedStatus then
      return true
    end
  end

  return false
end

local function createCapId()
  local state = ensureAiState()

  if state == nil then
    return nil
  end

  state.AI.lastCapId = (state.AI.lastCapId or 0) + 1

  return state.AI.lastCapId
end

local function buildCapKey(capId)
  return "CAP_" .. tostring(capId)
end

local function buildCapZoneKey(side, zoneRecord)
  local zoneKey = "UNKNOWN_ZONE"

  if zoneRecord ~= nil and zoneRecord.key ~= nil then
    zoneKey = zoneRecord.key
  elseif zoneRecord ~= nil and zoneRecord.name ~= nil then
    zoneKey = normalizeName(zoneRecord.name) or "UNKNOWN_ZONE"
  end

  return "CAP_ZONE_" .. tostring(side or "UNKNOWN") .. "_" .. tostring(zoneKey)
end

local function buildCapSignature(side, zoneKey)
  return tostring(side or "UNKNOWN") .. "::" .. tostring(zoneKey or "UNKNOWN_ZONE")
end

local function capRequestExists(signature)
  if signature == nil then
    return false
  end

  local state = ensureAiState()

  if state == nil then
    return false
  end

  for _, capRecord in pairs(state.AI.capRequests) do
    if capRecord.signature == signature then
      return true
    end
  end

  for _, capRecord in pairs(state.AI.activeCaps) do
    if capRecord.signature == signature then
      return true
    end
  end

  return false
end

local function getCapContainerForStatus(state, status)
  if status == CapManager.status.REQUESTED then
    return state.AI.capRequests
  end

  if status == CapManager.status.ACTIVE then
    return state.AI.activeCaps
  end

  if status == CapManager.status.COMPLETED then
    return state.AI.completedCaps
  end

  if status == CapManager.status.FAILED then
    return state.AI.failedCaps
  end

  if status == CapManager.status.CANCELLED then
    return state.AI.cancelledCaps
  end

  return state.AI.capRequests
end

local function removeCapFromAllContainers(state, capKey)
  if state == nil or state.AI == nil or capKey == nil then
    return false
  end

  state.AI.capRequests[capKey] = nil
  state.AI.activeCaps[capKey] = nil
  state.AI.completedCaps[capKey] = nil
  state.AI.failedCaps[capKey] = nil
  state.AI.cancelledCaps[capKey] = nil

  return true
end

local function updateStatistics()
  local state = ensureAiState()

  if state == nil then
    return false
  end

  state.AI.capStatistics = {
    zones = countTableKeys(state.AI.capZones),
    requested = countTableKeys(state.AI.capRequests),
    active = countTableKeys(state.AI.activeCaps),
    completed = countTableKeys(state.AI.completedCaps),
    failed = countTableKeys(state.AI.failedCaps),
    cancelled = countTableKeys(state.AI.cancelledCaps)
  }

  state.AI.lastUpdate = getCurrentTime()
  CapManager.lastUpdateTime = state.AI.lastUpdate

  return true
end

local function addCapToContainer(capRecord)
  local state = ensureAiState()

  if state == nil then
    return false, "state_unavailable"
  end

  if capRecord == nil or capRecord.key == nil then
    return false, "cap_record_invalid"
  end

  removeCapFromAllContainers(state, capRecord.key)

  local container = getCapContainerForStatus(state, capRecord.status)

  container[capRecord.key] = capRecord

  updateStatistics()
  markDirty("ai_cap_record_changed")

  return true, capRecord
end

local function getCapFromContainer(container, capKeyOrName)
  if type(container) ~= "table" or capKeyOrName == nil then
    return nil
  end

  if container[capKeyOrName] ~= nil then
    return container[capKeyOrName]
  end

  local normalizedSearch = normalizeName(capKeyOrName)

  for _, capRecord in pairs(container) do
    if capRecord.normalizedName == normalizedSearch then
      return capRecord
    end

    if normalizeName(capRecord.name) == normalizedSearch then
      return capRecord
    end
  end

  return nil
end

local function activeCapCountForZone(zoneKey, side)
  local state = ensureAiState()

  if state == nil then
    return 0
  end

  local count = 0

  for _, capRecord in pairs(state.AI.activeCaps) do
    if capRecord.zoneKey == zoneKey then
      if side == nil or capRecord.side == side then
        count = count + 1
      end
    end
  end

  for _, capRecord in pairs(state.AI.capRequests) do
    if capRecord.zoneKey == zoneKey then
      if side == nil or capRecord.side == side then
        count = count + 1
      end
    end
  end

  return count
end

local function calculateZonePriority(side, zoneRecord)
  if zoneRecord == nil then
    return 10
  end

  local owner = getRecordOwner(zoneRecord)

  if owner == getOwnerContested() then
    return CapManager.defaultPriorities.CONTESTED
  end

  if side == CapManager.sides.BLUE then
    if zoneRecord.isStartBaseZone == true then
      return CapManager.defaultPriorities.BLUE_HOME
    end

    return CapManager.defaultPriorities.BLUE_FRONTLINE
  end

  if side == CapManager.sides.RED then
    if owner == getOwnerRed() then
      return CapManager.defaultPriorities.RED_DEFENSIVE
    end

    return CapManager.defaultPriorities.RED_FRONTLINE
  end

  return 20
end

local function shouldRegisterBlueCapZone(zoneRecord)
  if zoneRecord == nil then
    return false
  end

  local owner = getRecordOwner(zoneRecord)

  if owner == getOwnerBlue() then
    return true
  end

  if owner == getOwnerContested() then
    return true
  end

  return false
end

local function shouldRegisterRedCapZone(zoneRecord)
  if zoneRecord == nil then
    return false
  end

  local owner = getRecordOwner(zoneRecord)

  if owner == getOwnerRed() then
    return true
  end

  if owner == getOwnerContested() then
    return true
  end

  return false
end

local function buildCapZoneRecord(side, zoneRecord, options)
  local zoneOptions = options or {}
  local sourceBase = nil

  if zoneOptions.sourceBase ~= nil then
    sourceBase = findBaseByKeyOrName(zoneOptions.sourceBase)
  end

  if sourceBase == nil then
    sourceBase = findPreferredBaseForSide(side, zoneRecord)
  end

  local zoneKey = buildCapZoneKey(side, zoneRecord)

  return {
    key = zoneKey,
    name = zoneOptions.name or zoneKey,
    normalizedName = normalizeName(zoneOptions.name or zoneKey),
    side = side,
    status = CapManager.status.REGISTERED,
    zoneKey = zoneRecord and zoneRecord.key or zoneOptions.zone,
    zoneName = zoneRecord and zoneRecord.name or nil,
    sourceBaseKey = sourceBase and sourceBase.key or zoneOptions.sourceBase,
    sourceBaseName = sourceBase and sourceBase.name or nil,
    priority = zoneOptions.priority or calculateZonePriority(side, zoneRecord),
    radius = zoneOptions.radius or (zoneRecord and zoneRecord.radius) or 25000,
    center = copyValue(zoneRecord and zoneRecord.center or nil),
    maxActiveCaps = zoneOptions.maxActiveCaps or CapManager.defaultMaxActivePerZone,
    createdAt = getCurrentTime(),
    updatedAt = getCurrentTime(),
    source = zoneOptions.source or "CAP_MANAGER",
    notes = zoneOptions.notes
  }
end

local function registerCapZoneIfMissing(side, zoneRecord, options)
  local state = ensureAiState()

  if state == nil then
    return false, "state_unavailable"
  end

  if zoneRecord == nil then
    return false, "zone_missing"
  end

  local zoneKey = buildCapZoneKey(side, zoneRecord)

  if state.AI.capZones[zoneKey] ~= nil then
    return false, "cap_zone_already_registered"
  end

  local capZoneRecord = buildCapZoneRecord(side, zoneRecord, options)

  state.AI.capZones[capZoneRecord.key] = capZoneRecord

  updateStatistics()
  markDirty("ai_cap_zone_registered")

  logDebug("CAP zone registered: " .. capZoneRecord.name)

  return true, capZoneRecord
end

local function createCapRequestFromZone(capZoneRecord, reason)
  if capZoneRecord == nil then
    return false, "cap_zone_missing"
  end

  if activeCapCountForZone(capZoneRecord.zoneKey, capZoneRecord.side) >= (capZoneRecord.maxActiveCaps or 1) then
    return false, "cap_limit_reached"
  end

  local signature = buildCapSignature(capZoneRecord.side, capZoneRecord.zoneKey)

  if capRequestExists(signature) == true then
    return false, "cap_already_requested"
  end

  return CapManager.requestCap(capZoneRecord.side, capZoneRecord.zoneKey, {
    name = "CAP " .. capZoneRecord.side .. " - " .. tostring(capZoneRecord.zoneName or capZoneRecord.zoneKey),
    sourceBase = capZoneRecord.sourceBaseKey,
    priority = capZoneRecord.priority,
    radius = capZoneRecord.radius,
    center = capZoneRecord.center,
    reason = reason or "cap_zone_need",
    source = "CAP_ZONE"
  })
end

local function updateReactionState()
  local state = ensureAiState()

  if state == nil then
    return false
  end

  local activeMissions = 0
  local missionState = getMissionState()

  if missionState ~= nil and missionState.active ~= nil then
    activeMissions = countTableKeys(missionState.active)
  end

  local activeCaps = countTableKeys(state.AI.activeCaps)
  local requestedCaps = countTableKeys(state.AI.capRequests)

  if activeCaps > 0 then
    state.AI.reactionState = "AIR_REACTION_ACTIVE"
  elseif requestedCaps > 0 then
    state.AI.reactionState = "AIR_REACTION_REQUESTED"
  elseif activeMissions > 0 then
    state.AI.reactionState = "MISSION_MONITORING"
  else
    state.AI.reactionState = "STANDBY"
  end

  if activeCaps + requestedCaps >= 6 then
    state.AI.threatLevel = "HIGH"
  elseif activeCaps + requestedCaps >= 3 then
    state.AI.threatLevel = "MEDIUM"
  elseif activeCaps + requestedCaps > 0 then
    state.AI.threatLevel = "LOW"
  else
    state.AI.threatLevel = "UNKNOWN"
  end

  return true
end

function CapManager.registerCapZone(zoneKeyOrName, side, options)
  if isValidSide(side) ~= true then
    return false, "invalid_side"
  end

  local zoneRecord = findZoneByKeyOrName(zoneKeyOrName)

  if zoneRecord == nil then
    return false, "zone_not_found"
  end

  return registerCapZoneIfMissing(side, zoneRecord, options)
end

function CapManager.autoRegisterCapZones(options)
  local state = ensureAiState()

  if state == nil then
    return false, "state_unavailable"
  end

  local registerOptions = options or {}
  local limit = registerOptions.limit or CapManager.defaultCapLimit
  local created = 0

  for _, zoneRecord in pairs(getZoneRegistry()) do
    if created >= limit then
      break
    end

    if shouldRegisterBlueCapZone(zoneRecord) == true then
      local success = registerCapZoneIfMissing(CapManager.sides.BLUE, zoneRecord, {
        source = "AUTO_BLUE_ZONE"
      })

      if success == true then
        created = created + 1
      end
    end

    if created >= limit then
      break
    end

    if shouldRegisterRedCapZone(zoneRecord) == true then
      local success = registerCapZoneIfMissing(CapManager.sides.RED, zoneRecord, {
        source = "AUTO_RED_ZONE"
      })

      if success == true then
        created = created + 1
      end
    end
  end

  updateStatistics()

  logInfo("CAP zones auto-registered: " .. tostring(created))

  return true, created
end

function CapManager.requestCap(side, zoneKeyOrName, options)
  local state = ensureAiState()

  if state == nil then
    return false, "state_unavailable"
  end

  if isValidSide(side) ~= true then
    return false, "invalid_side"
  end

  local capOptions = options or {}
  local zoneRecord = findZoneByKeyOrName(zoneKeyOrName)

  if zoneRecord == nil then
    return false, "zone_not_found"
  end

  local capId = createCapId()

  if capId == nil then
    return false, "cap_id_failed"
  end

  local sourceBase = nil

  if capOptions.sourceBase ~= nil then
    sourceBase = findBaseByKeyOrName(capOptions.sourceBase)
  end

  if sourceBase == nil then
    sourceBase = findPreferredBaseForSide(side, zoneRecord)
  end

  local capKey = buildCapKey(capId)
  local signature = buildCapSignature(side, zoneRecord.key)

  if capRequestExists(signature) == true then
    return false, "cap_already_requested"
  end

  local capRecord = {
    id = capId,
    key = capKey,
    name = capOptions.name or ("CAP " .. side .. " - " .. tostring(zoneRecord.name or zoneRecord.key)),
    normalizedName = normalizeName(capOptions.name or capKey),
    side = side,
    status = CapManager.status.REQUESTED,
    zoneKey = zoneRecord.key,
    zoneName = zoneRecord.name,
    sourceBaseKey = sourceBase and sourceBase.key or capOptions.sourceBase,
    sourceBaseName = sourceBase and sourceBase.name or nil,
    priority = capOptions.priority or calculateZonePriority(side, zoneRecord),
    radius = capOptions.radius or zoneRecord.radius or 25000,
    center = copyValue(capOptions.center or zoneRecord.center),
    spawnedGroupName = nil,
    mooseSpawnAlias = capOptions.mooseSpawnAlias,
    signature = signature,
    reason = capOptions.reason or "manual_cap_request",
    source = capOptions.source or "CAP_MANAGER",
    createdAt = getCurrentTime(),
    activatedAt = nil,
    completedAt = nil,
    failedAt = nil,
    cancelledAt = nil,
    updatedAt = getCurrentTime(),
    notes = capOptions.notes
  }

  local added, result = addCapToContainer(capRecord)

  if added ~= true then
    return false, result
  end

  updateReactionState()

  logInfo("CAP requested: " .. capRecord.name)

  return true, capRecord
end

function CapManager.getCap(capKeyOrName)
  local state = ensureAiState()

  if state == nil then
    return nil
  end

  local capRecord = getCapFromContainer(state.AI.capRequests, capKeyOrName)

  if capRecord ~= nil then
    return capRecord
  end

  capRecord = getCapFromContainer(state.AI.activeCaps, capKeyOrName)

  if capRecord ~= nil then
    return capRecord
  end

  capRecord = getCapFromContainer(state.AI.completedCaps, capKeyOrName)

  if capRecord ~= nil then
    return capRecord
  end

  capRecord = getCapFromContainer(state.AI.failedCaps, capKeyOrName)

  if capRecord ~= nil then
    return capRecord
  end

  return getCapFromContainer(state.AI.cancelledCaps, capKeyOrName)
end

function CapManager.setCapStatus(capKeyOrName, status, reason)
  local state = ensureAiState()

  if state == nil then
    return false, "state_unavailable"
  end

  if isValidStatus(status) ~= true then
    return false, "invalid_status"
  end

  local capRecord = CapManager.getCap(capKeyOrName)

  if capRecord == nil then
    return false, "cap_not_found"
  end

  capRecord.previousStatus = capRecord.status
  capRecord.status = status
  capRecord.statusReason = reason or "manual_status_update"
  capRecord.updatedAt = getCurrentTime()

  if status == CapManager.status.ACTIVE then
    capRecord.activatedAt = capRecord.activatedAt or getCurrentTime()
  elseif status == CapManager.status.COMPLETED then
    capRecord.completedAt = capRecord.completedAt or getCurrentTime()
  elseif status == CapManager.status.FAILED then
    capRecord.failedAt = capRecord.failedAt or getCurrentTime()
  elseif status == CapManager.status.CANCELLED then
    capRecord.cancelledAt = capRecord.cancelledAt or getCurrentTime()
  end

  addCapToContainer(capRecord)
  updateReactionState()

  logInfo("CAP status changed: " .. capRecord.key .. " [" .. status .. "]")

  return true, capRecord
end

function CapManager.activateCap(capKeyOrName, spawnedGroupName, reason)
  local capRecord = CapManager.getCap(capKeyOrName)

  if capRecord == nil then
    return false, "cap_not_found"
  end

  capRecord.spawnedGroupName = spawnedGroupName or capRecord.spawnedGroupName

  return CapManager.setCapStatus(capRecord.key, CapManager.status.ACTIVE, reason or "cap_activated")
end

function CapManager.completeCap(capKeyOrName, reason)
  return CapManager.setCapStatus(capKeyOrName, CapManager.status.COMPLETED, reason or "cap_completed")
end

function CapManager.failCap(capKeyOrName, reason)
  return CapManager.setCapStatus(capKeyOrName, CapManager.status.FAILED, reason or "cap_failed")
end

function CapManager.cancelCap(capKeyOrName, reason)
  return CapManager.setCapStatus(capKeyOrName, CapManager.status.CANCELLED, reason or "cap_cancelled")
end

function CapManager.evaluateCapNeeds(options)
  local state = ensureAiState()

  if state == nil then
    return false, "state_unavailable"
  end

  local evaluateOptions = options or {}
  local limit = evaluateOptions.limit or CapManager.defaultCapLimit
  local requested = 0

  logInfo("CAP need evaluation started")

  for _, capZoneRecord in pairs(state.AI.capZones) do
    if requested >= limit then
      break
    end

    if activeCapCountForZone(capZoneRecord.zoneKey, capZoneRecord.side) < (capZoneRecord.maxActiveCaps or 1) then
      local success = createCapRequestFromZone(capZoneRecord, "cap_need_evaluation")

      if success == true then
        requested = requested + 1
      end
    end
  end

  updateReactionState()
  updateStatistics()
  markDirty("ai_cap_needs_evaluated")

  logInfo("CAP need evaluation completed: " .. tostring(requested) .. " CAPs requested")

  return true, requested
end

function CapManager.reactToActiveMissions(options)
  local state = ensureAiState()

  if state == nil then
    return false, "state_unavailable"
  end

  local missionState = getMissionState()

  if missionState == nil or missionState.active == nil then
    return true, 0
  end

  local reactionOptions = options or {}
  local limit = reactionOptions.limit or CapManager.defaultCapLimit
  local requested = 0

  for _, missionRecord in pairs(missionState.active) do
    if requested >= limit then
      break
    end

    if missionRecord.targetZoneKey ~= nil then
      local side = CapManager.sides.RED

      if missionRecord.owner == getOwnerRed() then
        side = CapManager.sides.BLUE
      end

      local success = CapManager.requestCap(side, missionRecord.targetZoneKey, {
        name = "CAP reaction - " .. tostring(missionRecord.key),
        sourceBase = nil,
        priority = CapManager.defaultPriorities.MISSION_REACTION,
        reason = "active_mission_reaction",
        source = "MISSION_REACTION",
        notes = "Generated in reaction to active mission " .. tostring(missionRecord.key)
      })

      if success == true then
        requested = requested + 1
      end
    end
  end

  updateReactionState()
  updateStatistics()

  return true, requested
end

function CapManager.getCapZones()
  local state = ensureAiState()

  if state == nil then
    return {}
  end

  return state.AI.capZones
end

function CapManager.getRequestedCaps()
  local state = ensureAiState()

  if state == nil then
    return {}
  end

  return state.AI.capRequests
end

function CapManager.getActiveCaps()
  local state = ensureAiState()

  if state == nil then
    return {}
  end

  return state.AI.activeCaps
end

function CapManager.getCompletedCaps()
  local state = ensureAiState()

  if state == nil then
    return {}
  end

  return state.AI.completedCaps
end

function CapManager.getFailedCaps()
  local state = ensureAiState()

  if state == nil then
    return {}
  end

  return state.AI.failedCaps
end

function CapManager.getCapsBySide(side)
  local result = {}
  local state = ensureAiState()

  if state == nil then
    return result
  end

  local containers = {
    state.AI.capRequests,
    state.AI.activeCaps,
    state.AI.completedCaps,
    state.AI.failedCaps,
    state.AI.cancelledCaps
  }

  for _, container in ipairs(containers) do
    for key, capRecord in pairs(container) do
      if capRecord.side == side then
        result[key] = capRecord
      end
    end
  end

  return result
end

function CapManager.getBlueCaps()
  return CapManager.getCapsBySide(CapManager.sides.BLUE)
end

function CapManager.getRedCaps()
  return CapManager.getCapsBySide(CapManager.sides.RED)
end

function CapManager.clearRequestedCaps()
  local state = ensureAiState()

  if state == nil then
    return false, "state_unavailable"
  end

  state.AI.capRequests = {}

  updateReactionState()
  updateStatistics()
  markDirty("ai_cap_requests_cleared")

  logInfo("CAP requests cleared")

  return true
end

function CapManager.start()
  CapManager.started = true
  CapManager.finished = false
  CapManager.failed = false

  logInfo("AI CAP manager started")

  local state = ensureAiState()

  if state == nil then
    CapManager.failed = true
    setModuleStatus("FAILED")
    logError("AI CAP manager failed: state_unavailable")
    return false
  end

  setFeatureStatus(true)
  setModuleStatus("RUNNING")

  CapManager.autoRegisterCapZones({
    limit = CapManager.defaultCapLimit
  })

  CapManager.evaluateCapNeeds({
    limit = CapManager.defaultCapLimit
  })

  updateReactionState()
  updateStatistics()

  CapManager.finished = true

  logInfo("AI CAP manager initialized")

  return true
end

function CapManager.stop()
  CapManager.started = false

  setModuleStatus("STOPPED")

  logInfo("AI CAP manager stopped")

  return true
end

function CapManager.summary()
  local state = getState()
  local aiState = nil

  if state ~= nil then
    aiState = state.AI
  end

  return {
    name = CapManager.name,
    path = CapManager.path,
    version = CapManager.version,
    loaded = CapManager.loaded,
    started = CapManager.started,
    finished = CapManager.finished,
    failed = CapManager.failed,
    lastUpdateTime = CapManager.lastUpdateTime,
    statistics = aiState and aiState.capStatistics or nil,
    reactionState = aiState and aiState.reactionState or nil,
    threatLevel = aiState and aiState.threatLevel or nil,
    state = aiState
  }
end

TC.AI.CapManager = CapManager

TC.modules.aiCapManager = {
  name = CapManager.name,
  path = CapManager.path,
  loaded = true,
  version = CapManager.version
}

local state = getState()

if state ~= nil and state.setModuleStatus ~= nil then
  state.setModuleStatus("aiCapManager", "LOADED")
end

logInfo("AI CAP manager loaded")

return CapManager
