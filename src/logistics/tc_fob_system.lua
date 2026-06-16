-- Theater Command DCS
-- File: src/logistics/tc_fob_system.lua
-- Purpose: Manage Forward Operating Bases as strategic Theater Command objects.

TC = TC or {}

TC.modules = TC.modules or {}
TC.Logistics = TC.Logistics or {}
TC.logistics = TC.logistics or TC.Logistics

local FobSystem = {}

FobSystem.name = "tc_fob_system"
FobSystem.path = "src/logistics/tc_fob_system.lua"
FobSystem.version = TC.version or "0.1.0"
FobSystem.loaded = true
FobSystem.started = false
FobSystem.finished = false
FobSystem.failed = false

FobSystem.status = {
  PLANNED = "PLANNED",
  UNDER_CONSTRUCTION = "UNDER_CONSTRUCTION",
  ACTIVE = "ACTIVE",
  DAMAGED = "DAMAGED",
  OUT_OF_SUPPLY = "OUT_OF_SUPPLY",
  DESTROYED = "DESTROYED"
}

FobSystem.defaultValues = {
  supplyLevel = 0,
  fuelLevel = 0,
  ammunitionLevel = 0,
  engineeringLevel = 0,
  airDefenseLevel = 0,
  repairLevel = 0,
  constructionProgress = 0,
  activationSupplyRequired = 50,
  activationConstructionRequired = 100
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

local function clamp(value, minimum, maximum)
  local utils = getUtils()

  if utils ~= nil and utils.clamp ~= nil then
    return utils.clamp(value, minimum, maximum)
  end

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

local function getOwnerUnknown()
  return getConstant("ownership", "UNKNOWN", "UNKNOWN")
end

local function getOwnerBlue()
  return getConstant("ownership", "BLUE", "BLUE")
end

local function getOwnerRed()
  return getConstant("ownership", "RED", "RED")
end

local function isValidStatus(status)
  if status == nil then
    return false
  end

  for _, allowedStatus in pairs(FobSystem.status) do
    if status == allowedStatus then
      return true
    end
  end

  return false
end

local function ensureLogisticsState()
  local state = getState()

  TC.Logistics = TC.Logistics or {}
  TC.logistics = TC.Logistics

  if state == nil then
    return nil
  end

  state.Logistics = state.Logistics or {}
  state.Logistics.enabled = true
  state.Logistics.hubs = state.Logistics.hubs or {}
  state.Logistics.deliveries = state.Logistics.deliveries or {}
  state.Logistics.fobs = state.Logistics.fobs or {}
  state.Logistics.lastDeliveryId = state.Logistics.lastDeliveryId or 0
  state.Logistics.lastFobId = state.Logistics.lastFobId or 0
  state.Logistics.fobStatistics = state.Logistics.fobStatistics or {
    total = 0,
    planned = 0,
    underConstruction = 0,
    active = 0,
    damaged = 0,
    outOfSupply = 0,
    destroyed = 0
  }

  return state
end

local function markDirty(reason)
  local state = getState()

  if state ~= nil and state.markDirty ~= nil then
    state.markDirty(reason or "fob_state_changed")
    return true
  end

  if state ~= nil then
    state.Persistence = state.Persistence or {}
    state.Persistence.dirty = true
    state.Persistence.dirtyReason = reason or "fob_state_changed"
    state.Persistence.dirtyAt = getCurrentTime()
    return true
  end

  return false
end

local function setModuleStatus(status)
  local state = getState()

  if state ~= nil and state.setModuleStatus ~= nil then
    state.setModuleStatus("fobSystem", status)
  end
end

local function setFeatureStatus(enabled)
  local state = getState()

  if state ~= nil and state.setFeatureStatus ~= nil then
    state.setFeatureStatus("fobSystem", enabled == true)
  end
end

local function getZoneFactory()
  if TC.World == nil then
    return nil
  end

  return TC.World.ZoneFactory
end

local function getDeliverySystem()
  if TC.Logistics == nil then
    return nil
  end

  return TC.Logistics.Delivery
end

local function getZoneByKeyOrName(keyOrName)
  if keyOrName == nil then
    return nil
  end

  local state = getState()

  if state ~= nil and state.Zones ~= nil and state.Zones.registry ~= nil then
    if state.Zones.registry[keyOrName] ~= nil then
      return state.Zones.registry[keyOrName]
    end

    local normalizedSearch = normalizeName(keyOrName)

    for _, zoneRecord in pairs(state.Zones.registry) do
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
  end

  local zoneFactory = getZoneFactory()

  if zoneFactory ~= nil and zoneFactory.getZoneByName ~= nil then
    return zoneFactory.getZoneByName(keyOrName)
  end

  return nil
end

local function getBaseByKeyOrName(keyOrName)
  if keyOrName == nil then
    return nil
  end

  local state = getState()

  if state ~= nil and state.Bases ~= nil and state.Bases.registry ~= nil then
    if state.Bases.registry[keyOrName] ~= nil then
      return state.Bases.registry[keyOrName]
    end

    local normalizedSearch = normalizeName(keyOrName)

    for _, baseRecord in pairs(state.Bases.registry) do
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
  end

  return nil
end

local function findContainingZone(point)
  local zoneFactory = getZoneFactory()

  if zoneFactory ~= nil and zoneFactory.findContainingZone ~= nil then
    local zoneRecord = zoneFactory.findContainingZone(point)

    if zoneRecord ~= nil then
      return zoneRecord
    end
  end

  return nil
end

local function createFobId()
  local state = ensureLogisticsState()

  if state == nil then
    return nil
  end

  state.Logistics.lastFobId = (state.Logistics.lastFobId or 0) + 1

  return state.Logistics.lastFobId
end

local function buildFobKey(fobId)
  return "FOB_" .. tostring(fobId)
end

local function resolveZoneAndBase(options)
  local targetZone = nil
  local targetBase = nil

  if options.linkedZone ~= nil then
    targetZone = getZoneByKeyOrName(options.linkedZone)
  end

  if options.linkedBase ~= nil then
    targetBase = getBaseByKeyOrName(options.linkedBase)
  end

  if targetZone == nil and type(options.position) == "table" then
    targetZone = findContainingZone(options.position)
  end

  if targetZone ~= nil and targetBase == nil and targetZone.linkedAirbaseKey ~= nil then
    targetBase = getBaseByKeyOrName(targetZone.linkedAirbaseKey)
  end

  return targetZone, targetBase
end

local function updateStatistics()
  local state = ensureLogisticsState()

  if state == nil then
    return false
  end

  local statistics = {
    total = 0,
    planned = 0,
    underConstruction = 0,
    active = 0,
    damaged = 0,
    outOfSupply = 0,
    destroyed = 0
  }

  for _, fobRecord in pairs(state.Logistics.fobs) do
    statistics.total = statistics.total + 1

    if fobRecord.status == FobSystem.status.PLANNED then
      statistics.planned = statistics.planned + 1
    elseif fobRecord.status == FobSystem.status.UNDER_CONSTRUCTION then
      statistics.underConstruction = statistics.underConstruction + 1
    elseif fobRecord.status == FobSystem.status.ACTIVE then
      statistics.active = statistics.active + 1
    elseif fobRecord.status == FobSystem.status.DAMAGED then
      statistics.damaged = statistics.damaged + 1
    elseif fobRecord.status == FobSystem.status.OUT_OF_SUPPLY then
      statistics.outOfSupply = statistics.outOfSupply + 1
    elseif fobRecord.status == FobSystem.status.DESTROYED then
      statistics.destroyed = statistics.destroyed + 1
    end
  end

  state.Logistics.fobStatistics = statistics

  return true
end

local function updateLinkedZoneFobData(fobRecord)
  if fobRecord == nil or fobRecord.linkedZoneKey == nil then
    return false
  end

  local zoneRecord = getZoneByKeyOrName(fobRecord.linkedZoneKey)

  if zoneRecord == nil then
    return false
  end

  zoneRecord.fob = zoneRecord.fob or {}
  zoneRecord.fob.key = fobRecord.key
  zoneRecord.fob.name = fobRecord.name
  zoneRecord.fob.status = fobRecord.status
  zoneRecord.fob.owner = fobRecord.owner
  zoneRecord.fob.supplyLevel = fobRecord.supplyLevel
  zoneRecord.fob.constructionProgress = fobRecord.constructionProgress
  zoneRecord.fob.updatedAt = getCurrentTime()

  local state = getState()

  if state ~= nil and state.Zones ~= nil and state.Zones.registry ~= nil then
    state.Zones.registry[zoneRecord.key] = zoneRecord
  end

  if TC.World ~= nil and TC.World.Zones ~= nil then
    TC.World.Zones[zoneRecord.key] = zoneRecord
  end

  return true
end

local function updateLinkedBaseFobData(fobRecord)
  if fobRecord == nil or fobRecord.linkedBaseKey == nil then
    return false
  end

  local baseRecord = getBaseByKeyOrName(fobRecord.linkedBaseKey)

  if baseRecord == nil then
    return false
  end

  baseRecord.fobs = baseRecord.fobs or {}
  baseRecord.fobs[fobRecord.key] = {
    key = fobRecord.key,
    name = fobRecord.name,
    status = fobRecord.status,
    owner = fobRecord.owner,
    updatedAt = getCurrentTime()
  }

  local state = getState()

  if state ~= nil and state.Bases ~= nil and state.Bases.registry ~= nil then
    state.Bases.registry[baseRecord.key] = baseRecord
  end

  if TC.World ~= nil and TC.World.Airbases ~= nil then
    TC.World.Airbases[baseRecord.key] = baseRecord
  end

  return true
end

local function syncFob(fobRecord)
  if fobRecord == nil or fobRecord.key == nil then
    return false
  end

  local state = ensureLogisticsState()

  if state == nil then
    return false
  end

  state.Logistics.fobs[fobRecord.key] = fobRecord

  TC.Logistics.Fobs = TC.Logistics.Fobs or {}
  TC.Logistics.Fobs[fobRecord.key] = fobRecord

  updateLinkedZoneFobData(fobRecord)
  updateLinkedBaseFobData(fobRecord)
  updateStatistics()

  return true
end

local function getDelivery(deliveryKey)
  local deliverySystem = getDeliverySystem()

  if deliverySystem ~= nil and deliverySystem.get ~= nil then
    return deliverySystem.get(deliveryKey)
  end

  local state = getState()

  if state ~= nil and state.Logistics ~= nil and state.Logistics.deliveries ~= nil then
    return state.Logistics.deliveries[deliveryKey]
  end

  return nil
end

local function applyDeliveryEffectToFob(fobRecord, deliveryRecord)
  if fobRecord == nil then
    return false, "fob_missing"
  end

  if deliveryRecord == nil then
    return false, "delivery_missing"
  end

  local effect = deliveryRecord.effect or {}

  fobRecord.supplyLevel = clamp((fobRecord.supplyLevel or 0) + (effect.supply or 0), 0, 100)
  fobRecord.fuelLevel = clamp((fobRecord.fuelLevel or 0) + (effect.fuel or 0), 0, 100)
  fobRecord.ammunitionLevel = clamp((fobRecord.ammunitionLevel or 0) + (effect.ammunition or 0), 0, 100)
  fobRecord.engineeringLevel = clamp((fobRecord.engineeringLevel or 0) + (effect.engineering or 0), 0, 100)
  fobRecord.airDefenseLevel = clamp((fobRecord.airDefenseLevel or 0) + (effect.airDefense or 0), 0, 10)
  fobRecord.repairLevel = clamp((fobRecord.repairLevel or 0) + (effect.repair or 0), 0, 100)

  if effect.fobConstruction ~= nil then
    fobRecord.constructionProgress = clamp(
      (fobRecord.constructionProgress or 0) + (effect.fobConstruction * 50),
      0,
      100
    )
  end

  if effect.engineering ~= nil and effect.engineering > 0 then
    fobRecord.constructionProgress = clamp(
      (fobRecord.constructionProgress or 0) + effect.engineering,
      0,
      100
    )
  end

  fobRecord.lastDeliveryKey = deliveryRecord.key
  fobRecord.lastDeliveryType = deliveryRecord.type
  fobRecord.lastDeliveryAt = getCurrentTime()
  fobRecord.updatedAt = getCurrentTime()

  return true, fobRecord
end

local function canActivateFob(fobRecord)
  if fobRecord == nil then
    return false
  end

  if fobRecord.status == FobSystem.status.DESTROYED then
    return false
  end

  if (fobRecord.constructionProgress or 0) < FobSystem.defaultValues.activationConstructionRequired then
    return false
  end

  if (fobRecord.supplyLevel or 0) < FobSystem.defaultValues.activationSupplyRequired then
    return false
  end

  return true
end

function FobSystem.create(options)
  local state = ensureLogisticsState()

  if state == nil then
    return false, "state_unavailable"
  end

  local fobOptions = options or {}
  local fobId = createFobId()

  if fobId == nil then
    return false, "fob_id_failed"
  end

  local linkedZone, linkedBase = resolveZoneAndBase(fobOptions)
  local fobKey = buildFobKey(fobId)
  local fobName = fobOptions.name or fobKey
  local owner = fobOptions.owner or getOwnerUnknown()
  local status = fobOptions.status or FobSystem.status.PLANNED

  if isValidStatus(status) ~= true then
    status = FobSystem.status.PLANNED
  end

  local fobRecord = {
    id = fobId,
    key = fobKey,
    name = fobName,
    displayName = fobName,
    normalizedName = normalizeName(fobName),
    status = status,
    owner = owner,
    linkedZoneKey = linkedZone and linkedZone.key or fobOptions.linkedZone,
    linkedZoneName = linkedZone and linkedZone.name or nil,
    linkedBaseKey = linkedBase and linkedBase.key or fobOptions.linkedBase,
    linkedBaseName = linkedBase and linkedBase.name or nil,
    position = copyValue(fobOptions.position),
    supplyLevel = fobOptions.supplyLevel or FobSystem.defaultValues.supplyLevel,
    fuelLevel = fobOptions.fuelLevel or FobSystem.defaultValues.fuelLevel,
    ammunitionLevel = fobOptions.ammunitionLevel or FobSystem.defaultValues.ammunitionLevel,
    engineeringLevel = fobOptions.engineeringLevel or FobSystem.defaultValues.engineeringLevel,
    airDefenseLevel = fobOptions.airDefenseLevel or FobSystem.defaultValues.airDefenseLevel,
    repairLevel = fobOptions.repairLevel or FobSystem.defaultValues.repairLevel,
    constructionProgress = fobOptions.constructionProgress or FobSystem.defaultValues.constructionProgress,
    source = fobOptions.source or "THEATER_COMMAND",
    ctldGroupName = fobOptions.ctldGroupName,
    ctldUnitName = fobOptions.ctldUnitName,
    createdAt = getCurrentTime(),
    updatedAt = getCurrentTime(),
    activatedAt = nil,
    destroyedAt = nil,
    notes = fobOptions.notes
  }

  syncFob(fobRecord)
  markDirty("fob_created")

  logInfo("FOB created: " .. fobRecord.name .. " [" .. fobRecord.status .. "]")

  return true, fobRecord
end

function FobSystem.get(fobKeyOrName)
  local state = ensureLogisticsState()

  if state == nil or fobKeyOrName == nil then
    return nil
  end

  if state.Logistics.fobs[fobKeyOrName] ~= nil then
    return state.Logistics.fobs[fobKeyOrName]
  end

  local normalizedSearch = normalizeName(fobKeyOrName)

  for _, fobRecord in pairs(state.Logistics.fobs) do
    if fobRecord.normalizedName == normalizedSearch then
      return fobRecord
    end

    if normalizeName(fobRecord.name) == normalizedSearch then
      return fobRecord
    end

    if normalizeName(fobRecord.displayName) == normalizedSearch then
      return fobRecord
    end
  end

  return nil
end

function FobSystem.getAll()
  local state = ensureLogisticsState()

  if state == nil then
    return {}
  end

  return state.Logistics.fobs
end

function FobSystem.setStatus(fobKeyOrName, status, reason)
  local fobRecord = FobSystem.get(fobKeyOrName)

  if fobRecord == nil then
    return false, "fob_not_found"
  end

  if isValidStatus(status) ~= true then
    return false, "invalid_status"
  end

  fobRecord.previousStatus = fobRecord.status
  fobRecord.status = status
  fobRecord.statusReason = reason or "manual_status_update"
  fobRecord.updatedAt = getCurrentTime()

  if status == FobSystem.status.ACTIVE then
    fobRecord.activatedAt = fobRecord.activatedAt or getCurrentTime()
  elseif status == FobSystem.status.DESTROYED then
    fobRecord.destroyedAt = fobRecord.destroyedAt or getCurrentTime()
  end

  syncFob(fobRecord)
  markDirty("fob_status_changed")

  logInfo("FOB status changed: " .. fobRecord.name .. " [" .. status .. "]")

  return true, fobRecord
end

function FobSystem.setOwner(fobKeyOrName, owner, reason)
  local fobRecord = FobSystem.get(fobKeyOrName)

  if fobRecord == nil then
    return false, "fob_not_found"
  end

  fobRecord.previousOwner = fobRecord.owner
  fobRecord.owner = owner or getOwnerUnknown()
  fobRecord.ownerReason = reason or "manual_owner_update"
  fobRecord.updatedAt = getCurrentTime()

  syncFob(fobRecord)
  markDirty("fob_owner_changed")

  logInfo("FOB owner changed: " .. fobRecord.name .. " [" .. fobRecord.owner .. "]")

  return true, fobRecord
end

function FobSystem.addSupply(fobKeyOrName, amount, reason)
  local fobRecord = FobSystem.get(fobKeyOrName)

  if fobRecord == nil then
    return false, "fob_not_found"
  end

  local supplyAmount = amount or 0

  fobRecord.supplyLevel = clamp((fobRecord.supplyLevel or 0) + supplyAmount, 0, 100)
  fobRecord.updatedAt = getCurrentTime()
  fobRecord.supplyReason = reason or "manual_supply_update"

  if fobRecord.supplyLevel <= 0 and fobRecord.status == FobSystem.status.ACTIVE then
    fobRecord.status = FobSystem.status.OUT_OF_SUPPLY
  end

  syncFob(fobRecord)
  markDirty("fob_supply_changed")

  return true, fobRecord
end

function FobSystem.addConstructionProgress(fobKeyOrName, amount, reason)
  local fobRecord = FobSystem.get(fobKeyOrName)

  if fobRecord == nil then
    return false, "fob_not_found"
  end

  local progressAmount = amount or 0

  fobRecord.constructionProgress = clamp((fobRecord.constructionProgress or 0) + progressAmount, 0, 100)
  fobRecord.updatedAt = getCurrentTime()
  fobRecord.constructionReason = reason or "manual_construction_update"

  if fobRecord.status == FobSystem.status.PLANNED and fobRecord.constructionProgress > 0 then
    fobRecord.status = FobSystem.status.UNDER_CONSTRUCTION
  end

  syncFob(fobRecord)
  markDirty("fob_construction_changed")

  return true, fobRecord
end

function FobSystem.tryActivate(fobKeyOrName, reason)
  local fobRecord = FobSystem.get(fobKeyOrName)

  if fobRecord == nil then
    return false, "fob_not_found"
  end

  if canActivateFob(fobRecord) ~= true then
    return false, "activation_requirements_not_met"
  end

  return FobSystem.setStatus(fobRecord.key, FobSystem.status.ACTIVE, reason or "activation_requirements_met")
end

function FobSystem.activate(fobKeyOrName, reason)
  local fobRecord = FobSystem.get(fobKeyOrName)

  if fobRecord == nil then
    return false, "fob_not_found"
  end

  fobRecord.constructionProgress = 100

  if (fobRecord.supplyLevel or 0) < FobSystem.defaultValues.activationSupplyRequired then
    fobRecord.supplyLevel = FobSystem.defaultValues.activationSupplyRequired
  end

  syncFob(fobRecord)

  return FobSystem.setStatus(fobRecord.key, FobSystem.status.ACTIVE, reason or "manual_activation")
end

function FobSystem.damage(fobKeyOrName, reason)
  return FobSystem.setStatus(fobKeyOrName, FobSystem.status.DAMAGED, reason or "fob_damaged")
end

function FobSystem.markOutOfSupply(fobKeyOrName, reason)
  return FobSystem.setStatus(fobKeyOrName, FobSystem.status.OUT_OF_SUPPLY, reason or "fob_out_of_supply")
end

function FobSystem.destroy(fobKeyOrName, reason)
  return FobSystem.setStatus(fobKeyOrName, FobSystem.status.DESTROYED, reason or "fob_destroyed")
end

function FobSystem.repair(fobKeyOrName, amount, reason)
  local fobRecord = FobSystem.get(fobKeyOrName)

  if fobRecord == nil then
    return false, "fob_not_found"
  end

  local repairAmount = amount or 25

  fobRecord.repairLevel = clamp((fobRecord.repairLevel or 0) + repairAmount, 0, 100)
  fobRecord.updatedAt = getCurrentTime()
  fobRecord.repairReason = reason or "fob_repair"

  if fobRecord.status == FobSystem.status.DAMAGED and fobRecord.repairLevel >= 50 then
    fobRecord.status = FobSystem.status.ACTIVE
  end

  syncFob(fobRecord)
  markDirty("fob_repaired")

  logInfo("FOB repaired: " .. fobRecord.name)

  return true, fobRecord
end

function FobSystem.applyDelivery(fobKeyOrName, deliveryKey)
  local fobRecord = FobSystem.get(fobKeyOrName)

  if fobRecord == nil then
    return false, "fob_not_found"
  end

  local deliveryRecord = getDelivery(deliveryKey)

  if deliveryRecord == nil then
    return false, "delivery_not_found"
  end

  local success, result = applyDeliveryEffectToFob(fobRecord, deliveryRecord)

  if success ~= true then
    return false, result
  end

  if fobRecord.status == FobSystem.status.PLANNED and fobRecord.constructionProgress > 0 then
    fobRecord.status = FobSystem.status.UNDER_CONSTRUCTION
  end

  syncFob(fobRecord)

  if canActivateFob(fobRecord) == true then
    FobSystem.setStatus(fobRecord.key, FobSystem.status.ACTIVE, "delivery_completed_activation")
  end

  markDirty("fob_delivery_applied")

  logInfo("FOB delivery applied: " .. fobRecord.name .. " <- " .. deliveryRecord.key)

  return true, fobRecord
end

function FobSystem.createFromDelivery(deliveryKey, options)
  local deliveryRecord = getDelivery(deliveryKey)

  if deliveryRecord == nil then
    return false, "delivery_not_found"
  end

  local fobOptions = options or {}

  fobOptions.name = fobOptions.name or ("FOB_" .. tostring(deliveryRecord.targetZoneName or deliveryRecord.targetZoneKey or deliveryRecord.key))
  fobOptions.owner = fobOptions.owner or deliveryRecord.owner
  fobOptions.linkedZone = fobOptions.linkedZone or deliveryRecord.targetZoneKey
  fobOptions.linkedBase = fobOptions.linkedBase or deliveryRecord.targetBaseKey
  fobOptions.position = fobOptions.position or deliveryRecord.position
  fobOptions.source = "LOGISTICS_DELIVERY"
  fobOptions.notes = fobOptions.notes or ("Created from delivery " .. deliveryRecord.key)

  local created, fobRecordOrReason = FobSystem.create(fobOptions)

  if created ~= true then
    return false, fobRecordOrReason
  end

  FobSystem.applyDelivery(fobRecordOrReason.key, deliveryRecord.key)

  return true, fobRecordOrReason
end

function FobSystem.getByStatus(status)
  local result = {}
  local state = ensureLogisticsState()

  if state == nil then
    return result
  end

  for key, fobRecord in pairs(state.Logistics.fobs) do
    if fobRecord.status == status then
      result[key] = fobRecord
    end
  end

  return result
end

function FobSystem.getByOwner(owner)
  local result = {}
  local state = ensureLogisticsState()

  if state == nil then
    return result
  end

  for key, fobRecord in pairs(state.Logistics.fobs) do
    if fobRecord.owner == owner then
      result[key] = fobRecord
    end
  end

  return result
end

function FobSystem.getByZone(zoneKey)
  local result = {}
  local state = ensureLogisticsState()

  if state == nil then
    return result
  end

  for key, fobRecord in pairs(state.Logistics.fobs) do
    if fobRecord.linkedZoneKey == zoneKey then
      result[key] = fobRecord
    end
  end

  return result
end

function FobSystem.getByBase(baseKey)
  local result = {}
  local state = ensureLogisticsState()

  if state == nil then
    return result
  end

  for key, fobRecord in pairs(state.Logistics.fobs) do
    if fobRecord.linkedBaseKey == baseKey then
      result[key] = fobRecord
    end
  end

  return result
end

function FobSystem.getPlanned()
  return FobSystem.getByStatus(FobSystem.status.PLANNED)
end

function FobSystem.getUnderConstruction()
  return FobSystem.getByStatus(FobSystem.status.UNDER_CONSTRUCTION)
end

function FobSystem.getActive()
  return FobSystem.getByStatus(FobSystem.status.ACTIVE)
end

function FobSystem.getDamaged()
  return FobSystem.getByStatus(FobSystem.status.DAMAGED)
end

function FobSystem.getOutOfSupply()
  return FobSystem.getByStatus(FobSystem.status.OUT_OF_SUPPLY)
end

function FobSystem.getDestroyed()
  return FobSystem.getByStatus(FobSystem.status.DESTROYED)
end

function FobSystem.getBlueFobs()
  return FobSystem.getByOwner(getOwnerBlue())
end

function FobSystem.getRedFobs()
  return FobSystem.getByOwner(getOwnerRed())
end

function FobSystem.delete(fobKeyOrName)
  local state = ensureLogisticsState()

  if state == nil then
    return false, "state_unavailable"
  end

  local fobRecord = FobSystem.get(fobKeyOrName)

  if fobRecord == nil then
    return false, "fob_not_found"
  end

  state.Logistics.fobs[fobRecord.key] = nil

  if TC.Logistics ~= nil and TC.Logistics.Fobs ~= nil then
    TC.Logistics.Fobs[fobRecord.key] = nil
  end

  updateStatistics()
  markDirty("fob_deleted")

  logInfo("FOB deleted: " .. fobRecord.name)

  return true
end

function FobSystem.start()
  FobSystem.started = true
  FobSystem.finished = false
  FobSystem.failed = false

  logInfo("FOB system started")

  local state = ensureLogisticsState()

  if state == nil then
    FobSystem.failed = true
    setModuleStatus("FAILED")
    logError("FOB system failed: state_unavailable")
    return false
  end

  TC.Logistics.Fobs = TC.Logistics.Fobs or state.Logistics.fobs

  setFeatureStatus(true)
  setModuleStatus("RUNNING")
  updateStatistics()

  FobSystem.finished = true

  logInfo("FOB system initialized")

  return true
end

function FobSystem.stop()
  FobSystem.started = false

  setModuleStatus("STOPPED")

  logInfo("FOB system stopped")

  return true
end

function FobSystem.summary()
  local state = getState()
  local logisticsState = nil

  if state ~= nil then
    logisticsState = state.Logistics
  end

  return {
    name = FobSystem.name,
    path = FobSystem.path,
    version = FobSystem.version,
    loaded = FobSystem.loaded,
    started = FobSystem.started,
    finished = FobSystem.finished,
    failed = FobSystem.failed,
    fobCount = logisticsState and countTableKeys(logisticsState.fobs) or 0,
    statistics = logisticsState and logisticsState.fobStatistics or nil,
    state = logisticsState
  }
end

TC.Logistics.FobSystem = FobSystem

TC.modules.fobSystem = {
  name = FobSystem.name,
  path = FobSystem.path,
  loaded = true,
  version = FobSystem.version
}

local state = getState()

if state ~= nil and state.setModuleStatus ~= nil then
  state.setModuleStatus("fobSystem", "LOADED")
end

logInfo("FOB system loaded")

return FobSystem
