-- Theater Command DCS
-- File: src/logistics/tc_logistics_delivery.lua
-- Purpose: Manage strategic logistics deliveries for Theater Command DCS.

TC = TC or {}

TC.modules = TC.modules or {}
TC.Logistics = TC.Logistics or {}
TC.logistics = TC.logistics or TC.Logistics

local Delivery = {}

Delivery.name = "tc_logistics_delivery"
Delivery.path = "src/logistics/tc_logistics_delivery.lua"
Delivery.version = TC.version or "0.1.0"
Delivery.loaded = true
Delivery.started = false
Delivery.finished = false
Delivery.failed = false

Delivery.deliveryTypes = {
  SUPPLY = "SUPPLY",
  FUEL = "FUEL",
  AMMUNITION = "AMMUNITION",
  ENGINEERS = "ENGINEERS",
  AIR_DEFENSE = "AIR_DEFENSE",
  FOB_PACKAGE = "FOB_PACKAGE",
  REPAIR_PACKAGE = "REPAIR_PACKAGE"
}

Delivery.deliveryStatus = {
  PLANNED = "PLANNED",
  AVAILABLE = "AVAILABLE",
  IN_TRANSIT = "IN_TRANSIT",
  DELIVERED = "DELIVERED",
  LOST = "LOST",
  CANCELLED = "CANCELLED",
  EXPIRED = "EXPIRED"
}

Delivery.defaultEffects = {
  SUPPLY = {
    supply = 25
  },
  FUEL = {
    fuel = 25
  },
  AMMUNITION = {
    ammunition = 25
  },
  ENGINEERS = {
    engineering = 25
  },
  AIR_DEFENSE = {
    airDefense = 1
  },
  FOB_PACKAGE = {
    fobConstruction = 1
  },
  REPAIR_PACKAGE = {
    repair = 25
  }
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

local function getOwnerUnknown()
  return getConstant("ownership", "UNKNOWN", "UNKNOWN")
end

local function getStatusAvailable()
  return getConstant("logisticsStatus", "AVAILABLE", "AVAILABLE")
end

local function getStatusInTransit()
  return getConstant("logisticsStatus", "IN_TRANSIT", "IN_TRANSIT")
end

local function getStatusDelivered()
  return getConstant("logisticsStatus", "DELIVERED", "DELIVERED")
end

local function getStatusLost()
  return getConstant("logisticsStatus", "LOST", "LOST")
end

local function isValidDeliveryType(deliveryType)
  if deliveryType == nil then
    return false
  end

  for _, allowedType in pairs(Delivery.deliveryTypes) do
    if deliveryType == allowedType then
      return true
    end
  end

  return false
end

local function isValidStatus(status)
  if status == nil then
    return false
  end

  for _, allowedStatus in pairs(Delivery.deliveryStatus) do
    if status == allowedStatus then
      return true
    end
  end

  if status == getStatusAvailable() then
    return true
  end

  if status == getStatusInTransit() then
    return true
  end

  if status == getStatusDelivered() then
    return true
  end

  if status == getStatusLost() then
    return true
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
  state.Logistics.statistics = state.Logistics.statistics or {
    created = 0,
    inTransit = 0,
    delivered = 0,
    lost = 0,
    cancelled = 0
  }

  return state
end

local function markDirty(reason)
  local state = getState()

  if state ~= nil and state.markDirty ~= nil then
    state.markDirty(reason or "logistics_state_changed")
    return true
  end

  if state ~= nil then
    state.Persistence = state.Persistence or {}
    state.Persistence.dirty = true
    state.Persistence.dirtyReason = reason or "logistics_state_changed"
    state.Persistence.dirtyAt = getCurrentTime()
    return true
  end

  return false
end

local function setModuleStatus(status)
  local state = getState()

  if state ~= nil and state.setModuleStatus ~= nil then
    state.setModuleStatus("logisticsDelivery", status)
  end
end

local function setFeatureStatus(enabled)
  local state = getState()

  if state ~= nil and state.setFeatureStatus ~= nil then
    state.setFeatureStatus("logisticsDelivery", enabled == true)
  end
end

local function getZoneFactory()
  if TC.World == nil then
    return nil
  end

  return TC.World.ZoneFactory
end

local function getCaptureSystem()
  if TC.Campaign == nil then
    return nil
  end

  return TC.Campaign.CaptureSystem
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

local function updateStatistics()
  local state = ensureLogisticsState()

  if state == nil then
    return false
  end

  local statistics = {
    created = 0,
    available = 0,
    inTransit = 0,
    delivered = 0,
    lost = 0,
    cancelled = 0,
    expired = 0
  }

  for _, deliveryRecord in pairs(state.Logistics.deliveries) do
    statistics.created = statistics.created + 1

    if deliveryRecord.status == getStatusAvailable() or deliveryRecord.status == Delivery.deliveryStatus.AVAILABLE then
      statistics.available = statistics.available + 1
    elseif deliveryRecord.status == getStatusInTransit() or deliveryRecord.status == Delivery.deliveryStatus.IN_TRANSIT then
      statistics.inTransit = statistics.inTransit + 1
    elseif deliveryRecord.status == getStatusDelivered() or deliveryRecord.status == Delivery.deliveryStatus.DELIVERED then
      statistics.delivered = statistics.delivered + 1
    elseif deliveryRecord.status == getStatusLost() or deliveryRecord.status == Delivery.deliveryStatus.LOST then
      statistics.lost = statistics.lost + 1
    elseif deliveryRecord.status == Delivery.deliveryStatus.CANCELLED then
      statistics.cancelled = statistics.cancelled + 1
    elseif deliveryRecord.status == Delivery.deliveryStatus.EXPIRED then
      statistics.expired = statistics.expired + 1
    end
  end

  state.Logistics.statistics = statistics

  return true
end

local function createDeliveryId()
  local state = ensureLogisticsState()

  if state == nil then
    return nil
  end

  state.Logistics.lastDeliveryId = (state.Logistics.lastDeliveryId or 0) + 1

  return state.Logistics.lastDeliveryId
end

local function buildDeliveryKey(deliveryId)
  return "DELIVERY_" .. tostring(deliveryId)
end

local function getDefaultEffect(deliveryType)
  if deliveryType == nil then
    return {}
  end

  return copyValue(Delivery.defaultEffects[deliveryType] or {})
end

local function resolveTargetData(options)
  local targetZone = nil
  local targetBase = nil

  if options.targetZone ~= nil then
    targetZone = getZoneByKeyOrName(options.targetZone)
  end

  if options.targetBase ~= nil then
    targetBase = getBaseByKeyOrName(options.targetBase)
  end

  if targetZone == nil and type(options.position) == "table" then
    targetZone = findContainingZone(options.position)
  end

  if targetZone ~= nil and targetBase == nil and targetZone.linkedAirbaseKey ~= nil then
    targetBase = getBaseByKeyOrName(targetZone.linkedAirbaseKey)
  end

  return targetZone, targetBase
end

local function applyZoneLogisticsEffect(deliveryRecord)
  if deliveryRecord == nil then
    return false, "delivery_missing"
  end

  if deliveryRecord.targetZoneKey == nil then
    return false, "target_zone_missing"
  end

  local zoneRecord = getZoneByKeyOrName(deliveryRecord.targetZoneKey)

  if zoneRecord == nil then
    return false, "target_zone_not_found"
  end

  zoneRecord.logistics = zoneRecord.logistics or {}
  zoneRecord.logistics.supply = zoneRecord.logistics.supply or 0
  zoneRecord.logistics.fuel = zoneRecord.logistics.fuel or 0
  zoneRecord.logistics.ammunition = zoneRecord.logistics.ammunition or 0
  zoneRecord.logistics.engineering = zoneRecord.logistics.engineering or 0
  zoneRecord.logistics.airDefense = zoneRecord.logistics.airDefense or 0
  zoneRecord.logistics.fobConstruction = zoneRecord.logistics.fobConstruction or 0
  zoneRecord.logistics.repair = zoneRecord.logistics.repair or 0
  zoneRecord.logistics.lastDeliveryId = deliveryRecord.id
  zoneRecord.logistics.lastDeliveryAt = getCurrentTime()

  for effectKey, effectValue in pairs(deliveryRecord.effect or {}) do
    if type(effectValue) == "number" then
      zoneRecord.logistics[effectKey] = (zoneRecord.logistics[effectKey] or 0) + effectValue
    else
      zoneRecord.logistics[effectKey] = effectValue
    end
  end

  local state = getState()

  if state ~= nil and state.Zones ~= nil and state.Zones.registry ~= nil then
    state.Zones.registry[zoneRecord.key] = zoneRecord
  end

  if TC.World ~= nil and TC.World.Zones ~= nil then
    TC.World.Zones[zoneRecord.key] = zoneRecord
  end

  return true, zoneRecord
end

local function applyBaseLogisticsEffect(deliveryRecord)
  if deliveryRecord == nil then
    return false, "delivery_missing"
  end

  if deliveryRecord.targetBaseKey == nil then
    return false, "target_base_missing"
  end

  local baseRecord = getBaseByKeyOrName(deliveryRecord.targetBaseKey)

  if baseRecord == nil then
    return false, "target_base_not_found"
  end

  baseRecord.logistics = baseRecord.logistics or {}
  baseRecord.logistics.supply = baseRecord.logistics.supply or 0
  baseRecord.logistics.fuel = baseRecord.logistics.fuel or 0
  baseRecord.logistics.ammunition = baseRecord.logistics.ammunition or 0
  baseRecord.logistics.engineering = baseRecord.logistics.engineering or 0
  baseRecord.logistics.airDefense = baseRecord.logistics.airDefense or 0
  baseRecord.logistics.repair = baseRecord.logistics.repair or 0
  baseRecord.logistics.lastDeliveryId = deliveryRecord.id
  baseRecord.logistics.lastDeliveryAt = getCurrentTime()

  for effectKey, effectValue in pairs(deliveryRecord.effect or {}) do
    if type(effectValue) == "number" then
      baseRecord.logistics[effectKey] = (baseRecord.logistics[effectKey] or 0) + effectValue
    else
      baseRecord.logistics[effectKey] = effectValue
    end
  end

  local state = getState()

  if state ~= nil and state.Bases ~= nil and state.Bases.registry ~= nil then
    state.Bases.registry[baseRecord.key] = baseRecord
  end

  if TC.World ~= nil and TC.World.Airbases ~= nil then
    TC.World.Airbases[baseRecord.key] = baseRecord
  end

  return true, baseRecord
end

function Delivery.create(deliveryType, options)
  local state = ensureLogisticsState()

  if state == nil then
    return false, "state_unavailable"
  end

  if isValidDeliveryType(deliveryType) ~= true then
    return false, "invalid_delivery_type"
  end

  local deliveryOptions = options or {}
  local deliveryId = createDeliveryId()

  if deliveryId == nil then
    return false, "delivery_id_failed"
  end

  local targetZone, targetBase = resolveTargetData(deliveryOptions)
  local owner = deliveryOptions.owner or getOwnerUnknown()
  local status = deliveryOptions.status or getStatusAvailable()
  local deliveryKey = buildDeliveryKey(deliveryId)

  if isValidStatus(status) ~= true then
    status = getStatusAvailable()
  end

  local deliveryRecord = {
    id = deliveryId,
    key = deliveryKey,
    name = deliveryOptions.name or deliveryKey,
    normalizedName = normalizeName(deliveryOptions.name or deliveryKey),
    type = deliveryType,
    status = status,
    owner = owner,
    source = deliveryOptions.source or "THEATER_COMMAND",
    sourceBaseKey = deliveryOptions.sourceBase,
    targetZoneKey = targetZone and targetZone.key or deliveryOptions.targetZone,
    targetZoneName = targetZone and targetZone.name or nil,
    targetBaseKey = targetBase and targetBase.key or deliveryOptions.targetBase,
    targetBaseName = targetBase and targetBase.name or nil,
    targetFobKey = deliveryOptions.targetFob,
    position = copyValue(deliveryOptions.position),
    cargoGroupName = deliveryOptions.cargoGroupName,
    cargoUnitName = deliveryOptions.cargoUnitName,
    effect = deliveryOptions.effect or getDefaultEffect(deliveryType),
    effectApplied = false,
    createdAt = getCurrentTime(),
    updatedAt = getCurrentTime(),
    startedAt = nil,
    deliveredAt = nil,
    lostAt = nil,
    notes = deliveryOptions.notes
  }

  state.Logistics.deliveries[deliveryKey] = deliveryRecord

  updateStatistics()
  markDirty("logistics_delivery_created")

  logInfo("Delivery created: " .. deliveryRecord.type .. " [" .. deliveryRecord.key .. "]")

  return true, deliveryRecord
end

function Delivery.get(deliveryKey)
  local state = ensureLogisticsState()

  if state == nil or deliveryKey == nil then
    return nil
  end

  if state.Logistics.deliveries[deliveryKey] ~= nil then
    return state.Logistics.deliveries[deliveryKey]
  end

  for _, deliveryRecord in pairs(state.Logistics.deliveries) do
    if deliveryRecord.name == deliveryKey then
      return deliveryRecord
    end

    if deliveryRecord.normalizedName == normalizeName(deliveryKey) then
      return deliveryRecord
    end
  end

  return nil
end

function Delivery.getAll()
  local state = ensureLogisticsState()

  if state == nil then
    return {}
  end

  return state.Logistics.deliveries
end

function Delivery.setStatus(deliveryKey, status, reason)
  local state = ensureLogisticsState()

  if state == nil then
    return false, "state_unavailable"
  end

  if isValidStatus(status) ~= true then
    return false, "invalid_status"
  end

  local deliveryRecord = Delivery.get(deliveryKey)

  if deliveryRecord == nil then
    return false, "delivery_not_found"
  end

  deliveryRecord.previousStatus = deliveryRecord.status
  deliveryRecord.status = status
  deliveryRecord.statusReason = reason or "manual_status_update"
  deliveryRecord.updatedAt = getCurrentTime()

  if status == getStatusInTransit() or status == Delivery.deliveryStatus.IN_TRANSIT then
    deliveryRecord.startedAt = deliveryRecord.startedAt or getCurrentTime()
  elseif status == getStatusDelivered() or status == Delivery.deliveryStatus.DELIVERED then
    deliveryRecord.deliveredAt = deliveryRecord.deliveredAt or getCurrentTime()
  elseif status == getStatusLost() or status == Delivery.deliveryStatus.LOST then
    deliveryRecord.lostAt = deliveryRecord.lostAt or getCurrentTime()
  end

  state.Logistics.deliveries[deliveryRecord.key] = deliveryRecord

  updateStatistics()
  markDirty("logistics_delivery_status_changed")

  logInfo("Delivery status changed: " .. deliveryRecord.key .. " [" .. status .. "]")

  return true, deliveryRecord
end

function Delivery.startTransit(deliveryKey, reason)
  return Delivery.setStatus(deliveryKey, getStatusInTransit(), reason or "delivery_in_transit")
end

function Delivery.applyEffect(deliveryKey)
  local state = ensureLogisticsState()

  if state == nil then
    return false, "state_unavailable"
  end

  local deliveryRecord = Delivery.get(deliveryKey)

  if deliveryRecord == nil then
    return false, "delivery_not_found"
  end

  if deliveryRecord.effectApplied == true then
    return true, "effect_already_applied"
  end

  local zoneApplied = false
  local baseApplied = false

  if deliveryRecord.targetZoneKey ~= nil then
    zoneApplied = applyZoneLogisticsEffect(deliveryRecord) == true
  end

  if deliveryRecord.targetBaseKey ~= nil then
    baseApplied = applyBaseLogisticsEffect(deliveryRecord) == true
  end

  if zoneApplied ~= true and baseApplied ~= true then
    return false, "no_valid_target_for_effect"
  end

  deliveryRecord.effectApplied = true
  deliveryRecord.effectAppliedAt = getCurrentTime()
  deliveryRecord.updatedAt = getCurrentTime()

  state.Logistics.deliveries[deliveryRecord.key] = deliveryRecord

  markDirty("logistics_delivery_effect_applied")

  logInfo("Delivery effect applied: " .. deliveryRecord.key)

  return true, deliveryRecord
end

function Delivery.markDelivered(deliveryKey, reason)
  local statusChanged, deliveryRecordOrReason = Delivery.setStatus(
    deliveryKey,
    getStatusDelivered(),
    reason or "delivery_completed"
  )

  if statusChanged ~= true then
    return false, deliveryRecordOrReason
  end

  local effectApplied, effectResult = Delivery.applyEffect(deliveryRecordOrReason.key)

  if effectApplied ~= true then
    logWarn("Delivery completed without effect: " .. deliveryRecordOrReason.key .. " - " .. tostring(effectResult))
  end

  return true, deliveryRecordOrReason
end

function Delivery.markLost(deliveryKey, reason)
  return Delivery.setStatus(deliveryKey, getStatusLost(), reason or "delivery_lost")
end

function Delivery.cancel(deliveryKey, reason)
  return Delivery.setStatus(deliveryKey, Delivery.deliveryStatus.CANCELLED, reason or "delivery_cancelled")
end

function Delivery.expire(deliveryKey, reason)
  return Delivery.setStatus(deliveryKey, Delivery.deliveryStatus.EXPIRED, reason or "delivery_expired")
end

function Delivery.delete(deliveryKey)
  local state = ensureLogisticsState()

  if state == nil then
    return false, "state_unavailable"
  end

  local deliveryRecord = Delivery.get(deliveryKey)

  if deliveryRecord == nil then
    return false, "delivery_not_found"
  end

  state.Logistics.deliveries[deliveryRecord.key] = nil

  updateStatistics()
  markDirty("logistics_delivery_deleted")

  logInfo("Delivery deleted: " .. deliveryRecord.key)

  return true
end

function Delivery.getByStatus(status)
  local result = {}
  local state = ensureLogisticsState()

  if state == nil then
    return result
  end

  for key, deliveryRecord in pairs(state.Logistics.deliveries) do
    if deliveryRecord.status == status then
      result[key] = deliveryRecord
    end
  end

  return result
end

function Delivery.getByType(deliveryType)
  local result = {}
  local state = ensureLogisticsState()

  if state == nil then
    return result
  end

  for key, deliveryRecord in pairs(state.Logistics.deliveries) do
    if deliveryRecord.type == deliveryType then
      result[key] = deliveryRecord
    end
  end

  return result
end

function Delivery.getByOwner(owner)
  local result = {}
  local state = ensureLogisticsState()

  if state == nil then
    return result
  end

  for key, deliveryRecord in pairs(state.Logistics.deliveries) do
    if deliveryRecord.owner == owner then
      result[key] = deliveryRecord
    end
  end

  return result
end

function Delivery.getByTargetZone(targetZoneKey)
  local result = {}
  local state = ensureLogisticsState()

  if state == nil then
    return result
  end

  for key, deliveryRecord in pairs(state.Logistics.deliveries) do
    if deliveryRecord.targetZoneKey == targetZoneKey then
      result[key] = deliveryRecord
    end
  end

  return result
end

function Delivery.getByTargetBase(targetBaseKey)
  local result = {}
  local state = ensureLogisticsState()

  if state == nil then
    return result
  end

  for key, deliveryRecord in pairs(state.Logistics.deliveries) do
    if deliveryRecord.targetBaseKey == targetBaseKey then
      result[key] = deliveryRecord
    end
  end

  return result
end

function Delivery.getAvailable()
  return Delivery.getByStatus(getStatusAvailable())
end

function Delivery.getInTransit()
  return Delivery.getByStatus(getStatusInTransit())
end

function Delivery.getDelivered()
  return Delivery.getByStatus(getStatusDelivered())
end

function Delivery.getLost()
  return Delivery.getByStatus(getStatusLost())
end

function Delivery.createSupplyDelivery(options)
  return Delivery.create(Delivery.deliveryTypes.SUPPLY, options)
end

function Delivery.createFuelDelivery(options)
  return Delivery.create(Delivery.deliveryTypes.FUEL, options)
end

function Delivery.createAmmunitionDelivery(options)
  return Delivery.create(Delivery.deliveryTypes.AMMUNITION, options)
end

function Delivery.createEngineerDelivery(options)
  return Delivery.create(Delivery.deliveryTypes.ENGINEERS, options)
end

function Delivery.createAirDefenseDelivery(options)
  return Delivery.create(Delivery.deliveryTypes.AIR_DEFENSE, options)
end

function Delivery.createFobPackageDelivery(options)
  return Delivery.create(Delivery.deliveryTypes.FOB_PACKAGE, options)
end

function Delivery.createRepairPackageDelivery(options)
  return Delivery.create(Delivery.deliveryTypes.REPAIR_PACKAGE, options)
end

function Delivery.registerCtldDelivery(cargoData)
  if type(cargoData) ~= "table" then
    return false, "cargo_data_not_table"
  end

  local deliveryType = cargoData.deliveryType or cargoData.type or Delivery.deliveryTypes.SUPPLY

  if isValidDeliveryType(deliveryType) ~= true then
    deliveryType = Delivery.deliveryTypes.SUPPLY
  end

  local options = {
    name = cargoData.name or cargoData.cargoName,
    owner = cargoData.owner,
    source = "CTLD",
    sourceBase = cargoData.sourceBase,
    targetZone = cargoData.targetZone,
    targetBase = cargoData.targetBase,
    targetFob = cargoData.targetFob,
    position = cargoData.position or cargoData.point,
    cargoGroupName = cargoData.cargoGroupName,
    cargoUnitName = cargoData.cargoUnitName,
    effect = cargoData.effect,
    notes = cargoData.notes
  }

  return Delivery.create(deliveryType, options)
end

function Delivery.evaluatePositionDelivery(deliveryKey, position)
  local deliveryRecord = Delivery.get(deliveryKey)

  if deliveryRecord == nil then
    return false, "delivery_not_found"
  end

  if type(position) ~= "table" then
    return false, "position_missing"
  end

  local zoneRecord = findContainingZone(position)

  if zoneRecord == nil then
    return false, "no_zone_at_position"
  end

  deliveryRecord.position = copyValue(position)
  deliveryRecord.targetZoneKey = zoneRecord.key
  deliveryRecord.targetZoneName = zoneRecord.name

  if zoneRecord.linkedAirbaseKey ~= nil then
    local baseRecord = getBaseByKeyOrName(zoneRecord.linkedAirbaseKey)

    if baseRecord ~= nil then
      deliveryRecord.targetBaseKey = baseRecord.key
      deliveryRecord.targetBaseName = baseRecord.name
    end
  end

  local state = ensureLogisticsState()

  if state ~= nil then
    state.Logistics.deliveries[deliveryRecord.key] = deliveryRecord
  end

  return Delivery.markDelivered(deliveryRecord.key, "position_delivery_evaluated")
end

function Delivery.start()
  Delivery.started = true
  Delivery.finished = false
  Delivery.failed = false

  logInfo("Logistics delivery system started")

  local state = ensureLogisticsState()

  if state == nil then
    Delivery.failed = true
    setModuleStatus("FAILED")
    logError("Logistics delivery system failed: state_unavailable")
    return false
  end

  setFeatureStatus(true)
  setModuleStatus("RUNNING")
  updateStatistics()

  Delivery.finished = true

  logInfo("Logistics delivery system initialized")

  return true
end

function Delivery.stop()
  Delivery.started = false

  setModuleStatus("STOPPED")

  logInfo("Logistics delivery system stopped")

  return true
end

function Delivery.summary()
  local state = getState()
  local logisticsState = nil

  if state ~= nil then
    logisticsState = state.Logistics
  end

  return {
    name = Delivery.name,
    path = Delivery.path,
    version = Delivery.version,
    loaded = Delivery.loaded,
    started = Delivery.started,
    finished = Delivery.finished,
    failed = Delivery.failed,
    deliveryCount = logisticsState and countTableKeys(logisticsState.deliveries) or 0,
    statistics = logisticsState and logisticsState.statistics or nil,
    state = logisticsState
  }
end

TC.Logistics.Delivery = Delivery

TC.modules.logisticsDelivery = {
  name = Delivery.name,
  path = Delivery.path,
  loaded = true,
  version = Delivery.version
}

local state = getState()

if state ~= nil and state.setModuleStatus ~= nil then
  state.setModuleStatus("logisticsDelivery", "LOADED")
end

logInfo("Logistics delivery loaded")

return Delivery
