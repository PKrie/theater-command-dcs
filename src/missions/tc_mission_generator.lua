-- Theater Command DCS
-- File: src/missions/tc_mission_generator.lua
-- Purpose: Generate and manage dynamic campaign missions.

TC = TC or {}

TC.modules = TC.modules or {}
TC.Missions = TC.Missions or {}
TC.missions = TC.missions or TC.Missions

local MissionGenerator = {}

MissionGenerator.name = "tc_mission_generator"
MissionGenerator.path = "src/missions/tc_mission_generator.lua"
MissionGenerator.version = TC.version or "0.1.0"
MissionGenerator.loaded = true
MissionGenerator.started = false
MissionGenerator.finished = false
MissionGenerator.failed = false

MissionGenerator.lastGenerationTime = 0
MissionGenerator.defaultGenerationLimit = 10

MissionGenerator.types = {
  RECON = "RECON",
  STRIKE = "STRIKE",
  SEAD = "SEAD",
  DEAD = "DEAD",
  CAS = "CAS",
  INTERDICTION = "INTERDICTION",
  ESCORT = "ESCORT",
  CAP = "CAP",
  LOGISTICS = "LOGISTICS",
  FOB_SUPPORT = "FOB_SUPPORT",
  AIRBASE_ATTACK = "AIRBASE_ATTACK",
  IADS_SUPPRESSION = "IADS_SUPPRESSION"
}

MissionGenerator.status = {
  AVAILABLE = "AVAILABLE",
  ACTIVE = "ACTIVE",
  COMPLETED = "COMPLETED",
  FAILED = "FAILED",
  EXPIRED = "EXPIRED",
  CANCELLED = "CANCELLED"
}

MissionGenerator.defaultPriorities = {
  RECON = 20,
  STRIKE = 50,
  SEAD = 60,
  DEAD = 65,
  CAS = 55,
  INTERDICTION = 45,
  ESCORT = 35,
  CAP = 40,
  LOGISTICS = 45,
  FOB_SUPPORT = 55,
  AIRBASE_ATTACK = 70,
  IADS_SUPPRESSION = 65
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

local function getStatusAvailable()
  return getConstant("missionStatus", "AVAILABLE", MissionGenerator.status.AVAILABLE)
end

local function getStatusActive()
  return getConstant("missionStatus", "ACTIVE", MissionGenerator.status.ACTIVE)
end

local function getStatusCompleted()
  return getConstant("missionStatus", "COMPLETED", MissionGenerator.status.COMPLETED)
end

local function getStatusFailed()
  return getConstant("missionStatus", "FAILED", MissionGenerator.status.FAILED)
end

local function getStatusExpired()
  return getConstant("missionStatus", "EXPIRED", MissionGenerator.status.EXPIRED)
end

local function isValidMissionType(missionType)
  if missionType == nil then
    return false
  end

  for _, allowedType in pairs(MissionGenerator.types) do
    if missionType == allowedType then
      return true
    end
  end

  return false
end

local function isValidStatus(status)
  if status == nil then
    return false
  end

  for _, allowedStatus in pairs(MissionGenerator.status) do
    if status == allowedStatus then
      return true
    end
  end

  if status == getStatusAvailable() then
    return true
  end

  if status == getStatusActive() then
    return true
  end

  if status == getStatusCompleted() then
    return true
  end

  if status == getStatusFailed() then
    return true
  end

  if status == getStatusExpired() then
    return true
  end

  return false
end

local function ensureMissionState()
  local state = getState()

  TC.Missions = TC.Missions or {}
  TC.missions = TC.Missions

  if state == nil then
    return nil
  end

  state.Missions = state.Missions or {}
  state.Missions.enabled = true
  state.Missions.available = state.Missions.available or {}
  state.Missions.active = state.Missions.active or {}
  state.Missions.completed = state.Missions.completed or {}
  state.Missions.failed = state.Missions.failed or {}
  state.Missions.expired = state.Missions.expired or {}
  state.Missions.cancelled = state.Missions.cancelled or {}
  state.Missions.lastMissionId = state.Missions.lastMissionId or 0
  state.Missions.statistics = state.Missions.statistics or {
    total = 0,
    available = 0,
    active = 0,
    completed = 0,
    failed = 0,
    expired = 0,
    cancelled = 0
  }

  return state
end

local function markDirty(reason)
  local state = getState()

  if state ~= nil and state.markDirty ~= nil then
    state.markDirty(reason or "mission_state_changed")
    return true
  end

  if state ~= nil then
    state.Persistence = state.Persistence or {}
    state.Persistence.dirty = true
    state.Persistence.dirtyReason = reason or "mission_state_changed"
    state.Persistence.dirtyAt = getCurrentTime()
    return true
  end

  return false
end

local function setModuleStatus(status)
  local state = getState()

  if state ~= nil and state.setModuleStatus ~= nil then
    state.setModuleStatus("missionGenerator", status)
  end
end

local function setFeatureStatus(enabled)
  local state = getState()

  if state ~= nil and state.setFeatureStatus ~= nil then
    state.setFeatureStatus("missionGenerator", enabled == true)
  end
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

local function getFobRegistry()
  local state = getState()

  if state ~= nil and state.Logistics ~= nil and state.Logistics.fobs ~= nil then
    return state.Logistics.fobs
  end

  if TC.Logistics ~= nil and TC.Logistics.Fobs ~= nil then
    return TC.Logistics.Fobs
  end

  return {}
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

local function getRecordOwner(record)
  if record == nil then
    return getOwnerUnknown()
  end

  return record.currentOwner or record.initialOwner or record.owner or getOwnerUnknown()
end

local function getBlueStartBase()
  local config = getConfig()
  local campaignConfig = config.campaign or {}
  local configuredStartBase = campaignConfig.blueStartBase or "AKROTIRI"

  local startBase = findBaseByKeyOrName(configuredStartBase)

  if startBase ~= nil then
    return startBase
  end

  for _, baseRecord in pairs(getBaseRegistry()) do
    if baseRecord.isStartBase == true then
      return baseRecord
    end
  end

  for _, baseRecord in pairs(getBaseRegistry()) do
    if getRecordOwner(baseRecord) == getOwnerBlue() then
      return baseRecord
    end
  end

  return nil
end

local function getBlueZones()
  local result = {}

  for key, zoneRecord in pairs(getZoneRegistry()) do
    if getRecordOwner(zoneRecord) == getOwnerBlue() then
      result[key] = zoneRecord
    end
  end

  return result
end

local function getRedZones()
  local result = {}

  for key, zoneRecord in pairs(getZoneRegistry()) do
    if getRecordOwner(zoneRecord) == getOwnerRed() then
      result[key] = zoneRecord
    end
  end

  return result
end

local function getContestedZones()
  local result = {}

  for key, zoneRecord in pairs(getZoneRegistry()) do
    if getRecordOwner(zoneRecord) == getOwnerContested() then
      result[key] = zoneRecord
    end
  end

  return result
end

local function getBlueBases()
  local result = {}

  for key, baseRecord in pairs(getBaseRegistry()) do
    if getRecordOwner(baseRecord) == getOwnerBlue() then
      result[key] = baseRecord
    end
  end

  return result
end

local function getRedBases()
  local result = {}

  for key, baseRecord in pairs(getBaseRegistry()) do
    if getRecordOwner(baseRecord) == getOwnerRed() then
      result[key] = baseRecord
    end
  end

  return result
end

local function getMissionContainerForStatus(state, status)
  if status == getStatusAvailable() or status == MissionGenerator.status.AVAILABLE then
    return state.Missions.available
  end

  if status == getStatusActive() or status == MissionGenerator.status.ACTIVE then
    return state.Missions.active
  end

  if status == getStatusCompleted() or status == MissionGenerator.status.COMPLETED then
    return state.Missions.completed
  end

  if status == getStatusFailed() or status == MissionGenerator.status.FAILED then
    return state.Missions.failed
  end

  if status == getStatusExpired() or status == MissionGenerator.status.EXPIRED then
    return state.Missions.expired
  end

  if status == MissionGenerator.status.CANCELLED then
    return state.Missions.cancelled
  end

  return state.Missions.available
end

local function removeMissionFromAllContainers(state, missionKey)
  if state == nil or state.Missions == nil or missionKey == nil then
    return false
  end

  state.Missions.available[missionKey] = nil
  state.Missions.active[missionKey] = nil
  state.Missions.completed[missionKey] = nil
  state.Missions.failed[missionKey] = nil
  state.Missions.expired[missionKey] = nil
  state.Missions.cancelled[missionKey] = nil

  return true
end

local function updateStatistics()
  local state = ensureMissionState()

  if state == nil then
    return false
  end

  state.Missions.statistics = {
    total = countTableKeys(state.Missions.available)
      + countTableKeys(state.Missions.active)
      + countTableKeys(state.Missions.completed)
      + countTableKeys(state.Missions.failed)
      + countTableKeys(state.Missions.expired)
      + countTableKeys(state.Missions.cancelled),
    available = countTableKeys(state.Missions.available),
    active = countTableKeys(state.Missions.active),
    completed = countTableKeys(state.Missions.completed),
    failed = countTableKeys(state.Missions.failed),
    expired = countTableKeys(state.Missions.expired),
    cancelled = countTableKeys(state.Missions.cancelled)
  }

  return true
end

local function createMissionId()
  local state = ensureMissionState()

  if state == nil then
    return nil
  end

  state.Missions.lastMissionId = (state.Missions.lastMissionId or 0) + 1

  return state.Missions.lastMissionId
end

local function buildMissionKey(missionId)
  return "MISSION_" .. tostring(missionId)
end

local function buildMissionSignature(missionType, targetZoneKey, targetBaseKey, targetFobKey)
  return table.concat({
    missionType or "UNKNOWN",
    targetZoneKey or "NO_ZONE",
    targetBaseKey or "NO_BASE",
    targetFobKey or "NO_FOB"
  }, "::")
end

local function missionSignatureExists(signature)
  if signature == nil then
    return false
  end

  local state = ensureMissionState()

  if state == nil then
    return false
  end

  for _, missionRecord in pairs(state.Missions.available) do
    if missionRecord.signature == signature then
      return true
    end
  end

  for _, missionRecord in pairs(state.Missions.active) do
    if missionRecord.signature == signature then
      return true
    end
  end

  return false
end

local function getPriority(missionType, overridePriority)
  if type(overridePriority) == "number" then
    return overridePriority
  end

  return MissionGenerator.defaultPriorities[missionType] or 10
end

local function getMissionName(missionType, targetZone, targetBase, targetFob)
  local targetName = "UNKNOWN_TARGET"

  if targetFob ~= nil and targetFob.name ~= nil then
    targetName = targetFob.name
  elseif targetBase ~= nil and targetBase.name ~= nil then
    targetName = targetBase.name
  elseif targetZone ~= nil and targetZone.name ~= nil then
    targetName = targetZone.name
  elseif targetZone ~= nil and targetZone.key ~= nil then
    targetName = targetZone.key
  end

  return missionType .. " - " .. targetName
end

local function buildMissionRecord(missionType, options)
  local missionOptions = options or {}

  if isValidMissionType(missionType) ~= true then
    return nil, "invalid_mission_type"
  end

  local missionId = createMissionId()

  if missionId == nil then
    return nil, "mission_id_failed"
  end

  local targetZone = nil
  local targetBase = nil
  local targetFob = nil

  if missionOptions.targetZone ~= nil then
    targetZone = findZoneByKeyOrName(missionOptions.targetZone)
  end

  if missionOptions.targetBase ~= nil then
    targetBase = findBaseByKeyOrName(missionOptions.targetBase)
  end

  if missionOptions.targetFob ~= nil then
    targetFob = missionOptions.targetFob
  end

  if targetZone == nil and type(missionOptions.targetZoneRecord) == "table" then
    targetZone = missionOptions.targetZoneRecord
  end

  if targetBase == nil and type(missionOptions.targetBaseRecord) == "table" then
    targetBase = missionOptions.targetBaseRecord
  end

  if targetFob == nil and type(missionOptions.targetFobRecord) == "table" then
    targetFob = missionOptions.targetFobRecord
  end

  if targetZone ~= nil and targetBase == nil and targetZone.linkedAirbaseKey ~= nil then
    targetBase = findBaseByKeyOrName(targetZone.linkedAirbaseKey)
  end

  local sourceBase = nil

  if missionOptions.sourceBase ~= nil then
    sourceBase = findBaseByKeyOrName(missionOptions.sourceBase)
  end

  if sourceBase == nil then
    sourceBase = getBlueStartBase()
  end

  local missionKey = buildMissionKey(missionId)
  local targetZoneKey = targetZone and targetZone.key or missionOptions.targetZone
  local targetBaseKey = targetBase and targetBase.key or missionOptions.targetBase
  local targetFobKey = targetFob and targetFob.key or missionOptions.targetFob
  local signature = buildMissionSignature(missionType, targetZoneKey, targetBaseKey, targetFobKey)

  local missionRecord = {
    id = missionId,
    key = missionKey,
    name = missionOptions.name or getMissionName(missionType, targetZone, targetBase, targetFob),
    normalizedName = normalizeName(missionOptions.name or missionKey),
    type = missionType,
    status = missionOptions.status or getStatusAvailable(),
    owner = missionOptions.owner or getOwnerBlue(),
    sourceBaseKey = sourceBase and sourceBase.key or missionOptions.sourceBase,
    sourceBaseName = sourceBase and sourceBase.name or nil,
    targetZoneKey = targetZoneKey,
    targetZoneName = targetZone and targetZone.name or nil,
    targetBaseKey = targetBaseKey,
    targetBaseName = targetBase and targetBase.name or nil,
    targetFobKey = targetFobKey,
    targetFobName = targetFob and targetFob.name or nil,
    targetIadsSiteKey = missionOptions.targetIadsSite,
    priority = getPriority(missionType, missionOptions.priority),
    signature = signature,
    description = missionOptions.description,
    objective = missionOptions.objective,
    recommendedAircraft = copyValue(missionOptions.recommendedAircraft or {}),
    effect = copyValue(missionOptions.effect or {}),
    effectApplied = false,
    createdAt = getCurrentTime(),
    activatedAt = nil,
    completedAt = nil,
    failedAt = nil,
    expiredAt = nil,
    cancelledAt = nil,
    updatedAt = getCurrentTime(),
    source = missionOptions.source or "MISSION_GENERATOR",
    notes = missionOptions.notes
  }

  return missionRecord
end

local function addMissionToContainer(missionRecord)
  local state = ensureMissionState()

  if state == nil then
    return false, "state_unavailable"
  end

  if missionRecord == nil or missionRecord.key == nil then
    return false, "mission_record_invalid"
  end

  removeMissionFromAllContainers(state, missionRecord.key)

  local container = getMissionContainerForStatus(state, missionRecord.status)

  container[missionRecord.key] = missionRecord

  updateStatistics()
  markDirty("mission_record_changed")

  return true, missionRecord
end

local function getMissionFromContainer(container, missionKeyOrName)
  if type(container) ~= "table" or missionKeyOrName == nil then
    return nil
  end

  if container[missionKeyOrName] ~= nil then
    return container[missionKeyOrName]
  end

  local normalizedSearch = normalizeName(missionKeyOrName)

  for _, missionRecord in pairs(container) do
    if missionRecord.normalizedName == normalizedSearch then
      return missionRecord
    end

    if normalizeName(missionRecord.name) == normalizedSearch then
      return missionRecord
    end
  end

  return nil
end

local function createMissionIfMissing(missionType, options)
  local previewOptions = options or {}
  local targetZoneKey = previewOptions.targetZone
  local targetBaseKey = previewOptions.targetBase
  local targetFobKey = previewOptions.targetFob

  if targetZoneKey == nil and type(previewOptions.targetZoneRecord) == "table" then
    targetZoneKey = previewOptions.targetZoneRecord.key
  end

  if targetBaseKey == nil and type(previewOptions.targetBaseRecord) == "table" then
    targetBaseKey = previewOptions.targetBaseRecord.key
  end

  if targetFobKey == nil and type(previewOptions.targetFobRecord) == "table" then
    targetFobKey = previewOptions.targetFobRecord.key
  end

  local signature = buildMissionSignature(missionType, targetZoneKey, targetBaseKey, targetFobKey)

  if missionSignatureExists(signature) == true then
    return false, "mission_already_exists"
  end

  return MissionGenerator.createMission(missionType, options)
end

local function createReconMissionForZone(zoneRecord)
  return createMissionIfMissing(MissionGenerator.types.RECON, {
    targetZoneRecord = zoneRecord,
    priority = 25,
    objective = "Recon enemy-controlled zone",
    description = "Collect information about enemy activity in " .. tostring(zoneRecord.name or zoneRecord.key),
    recommendedAircraft = {
      "F/A-18C",
      "F-14B",
      "F-15E"
    }
  })
end

local function createStrikeMissionForZone(zoneRecord)
  return createMissionIfMissing(MissionGenerator.types.STRIKE, {
    targetZoneRecord = zoneRecord,
    priority = 50,
    objective = "Strike enemy assets in target zone",
    description = "Attack enemy military infrastructure in " .. tostring(zoneRecord.name or zoneRecord.key),
    recommendedAircraft = {
      "F/A-18C",
      "F-15E",
      "A-10C"
    },
    effect = {
      capturePressure = 10
    }
  })
end

local function createAirbaseAttackMissionForBase(baseRecord)
  return createMissionIfMissing(MissionGenerator.types.AIRBASE_ATTACK, {
    targetBaseRecord = baseRecord,
    priority = 70,
    objective = "Attack enemy airbase infrastructure",
    description = "Degrade enemy air operations at " .. tostring(baseRecord.name or baseRecord.key),
    recommendedAircraft = {
      "F/A-18C",
      "F-15E",
      "F-14B"
    },
    effect = {
      airbasePressure = 15
    }
  })
end

local function createCasMissionForZone(zoneRecord)
  return createMissionIfMissing(MissionGenerator.types.CAS, {
    targetZoneRecord = zoneRecord,
    priority = 55,
    objective = "Support friendly forces in contested zone",
    description = "Provide close air support in " .. tostring(zoneRecord.name or zoneRecord.key),
    recommendedAircraft = {
      "A-10C",
      "F/A-18C",
      "AH-64D"
    },
    effect = {
      capturePressure = 15
    }
  })
end

local function createLogisticsMissionForZone(zoneRecord)
  return createMissionIfMissing(MissionGenerator.types.LOGISTICS, {
    targetZoneRecord = zoneRecord,
    priority = 45,
    objective = "Deliver supplies to friendly zone",
    description = "Support logistics buildup in " .. tostring(zoneRecord.name or zoneRecord.key),
    recommendedAircraft = {
      "UH-1H",
      "Mi-8",
      "CH-47F"
    },
    effect = {
      logisticsSupport = 25
    }
  })
end

local function createFobSupportMissionForFob(fobRecord)
  return createMissionIfMissing(MissionGenerator.types.FOB_SUPPORT, {
    targetFobRecord = fobRecord,
    targetZone = fobRecord.linkedZoneKey,
    targetBase = fobRecord.linkedBaseKey,
    priority = 55,
    objective = "Support FOB construction or sustainment",
    description = "Deliver support to FOB " .. tostring(fobRecord.name or fobRecord.key),
    recommendedAircraft = {
      "UH-1H",
      "Mi-8",
      "CH-47F"
    },
    effect = {
      fobSupport = 25
    }
  })
end

local function createCapMissionForBlueZone(zoneRecord)
  return createMissionIfMissing(MissionGenerator.types.CAP, {
    targetZoneRecord = zoneRecord,
    priority = 40,
    objective = "Protect friendly-controlled airspace",
    description = "Conduct defensive counter-air patrol over " .. tostring(zoneRecord.name or zoneRecord.key),
    recommendedAircraft = {
      "F-14B",
      "F/A-18C",
      "F-15C"
    }
  })
end

local function shouldCreateLogisticsMission(zoneRecord)
  if zoneRecord == nil then
    return false
  end

  if getRecordOwner(zoneRecord) ~= getOwnerBlue() then
    return false
  end

  local logistics = zoneRecord.logistics or {}
  local supply = logistics.supply or 0
  local ammunition = logistics.ammunition or 0
  local fuel = logistics.fuel or 0

  if supply < 50 then
    return true
  end

  if ammunition < 25 then
    return true
  end

  if fuel < 25 then
    return true
  end

  return false
end

local function shouldCreateFobSupportMission(fobRecord)
  if fobRecord == nil then
    return false
  end

  if fobRecord.status == nil then
    return false
  end

  if fobRecord.status == "DESTROYED" then
    return false
  end

  if fobRecord.status == "PLANNED" then
    return true
  end

  if fobRecord.status == "UNDER_CONSTRUCTION" then
    return true
  end

  if fobRecord.status == "OUT_OF_SUPPLY" then
    return true
  end

  if (fobRecord.supplyLevel or 0) < 50 then
    return true
  end

  return false
end

local function generateFromRedZones(limit, created)
  local createdCount = created or 0

  for _, zoneRecord in pairs(getRedZones()) do
    if createdCount >= limit then
      return createdCount
    end

    local createdRecon = createReconMissionForZone(zoneRecord)

    if createdRecon == true then
      createdCount = createdCount + 1
    end

    if createdCount >= limit then
      return createdCount
    end

    local createdStrike = createStrikeMissionForZone(zoneRecord)

    if createdStrike == true then
      createdCount = createdCount + 1
    end
  end

  return createdCount
end

local function generateFromRedBases(limit, created)
  local createdCount = created or 0

  for _, baseRecord in pairs(getRedBases()) do
    if createdCount >= limit then
      return createdCount
    end

    local createdMission = createAirbaseAttackMissionForBase(baseRecord)

    if createdMission == true then
      createdCount = createdCount + 1
    end
  end

  return createdCount
end

local function generateFromContestedZones(limit, created)
  local createdCount = created or 0

  for _, zoneRecord in pairs(getContestedZones()) do
    if createdCount >= limit then
      return createdCount
    end

    local createdMission = createCasMissionForZone(zoneRecord)

    if createdMission == true then
      createdCount = createdCount + 1
    end
  end

  return createdCount
end

local function generateFromBlueZones(limit, created)
  local createdCount = created or 0

  for _, zoneRecord in pairs(getBlueZones()) do
    if createdCount >= limit then
      return createdCount
    end

    if shouldCreateLogisticsMission(zoneRecord) == true then
      local createdMission = createLogisticsMissionForZone(zoneRecord)

      if createdMission == true then
        createdCount = createdCount + 1
      end
    end

    if createdCount >= limit then
      return createdCount
    end

    local createdCap = createCapMissionForBlueZone(zoneRecord)

    if createdCap == true then
      createdCount = createdCount + 1
    end
  end

  return createdCount
end

local function generateFromFobs(limit, created)
  local createdCount = created or 0

  for _, fobRecord in pairs(getFobRegistry()) do
    if createdCount >= limit then
      return createdCount
    end

    if shouldCreateFobSupportMission(fobRecord) == true then
      local createdMission = createFobSupportMissionForFob(fobRecord)

      if createdMission == true then
        createdCount = createdCount + 1
      end
    end
  end

  return createdCount
end

local function applyMissionCompletionEffect(missionRecord)
  if missionRecord == nil then
    return false, "mission_missing"
  end

  if missionRecord.effectApplied == true then
    return true, "effect_already_applied"
  end

  missionRecord.effectApplied = true
  missionRecord.effectAppliedAt = getCurrentTime()

  if missionRecord.type == MissionGenerator.types.LOGISTICS then
    local deliverySystem = TC.Logistics and TC.Logistics.Delivery or nil

    if deliverySystem ~= nil and deliverySystem.createSupplyDelivery ~= nil then
      deliverySystem.createSupplyDelivery({
        name = "Supply from " .. missionRecord.key,
        owner = missionRecord.owner,
        source = "MISSION_COMPLETION",
        targetZone = missionRecord.targetZoneKey,
        targetBase = missionRecord.targetBaseKey,
        effect = {
          supply = missionRecord.effect and missionRecord.effect.logisticsSupport or 25
        },
        notes = "Generated by completed logistics mission"
      })
    end
  end

  if missionRecord.type == MissionGenerator.types.FOB_SUPPORT then
    local deliverySystem = TC.Logistics and TC.Logistics.Delivery or nil

    if deliverySystem ~= nil and deliverySystem.createFobPackageDelivery ~= nil then
      deliverySystem.createFobPackageDelivery({
        name = "FOB support from " .. missionRecord.key,
        owner = missionRecord.owner,
        source = "MISSION_COMPLETION",
        targetZone = missionRecord.targetZoneKey,
        targetBase = missionRecord.targetBaseKey,
        targetFob = missionRecord.targetFobKey,
        effect = {
          supply = 25,
          engineering = 25,
          fobConstruction = 1
        },
        notes = "Generated by completed FOB support mission"
      })
    end
  end

  return true, missionRecord
end

function MissionGenerator.createMission(missionType, options)
  local state = ensureMissionState()

  if state == nil then
    return false, "state_unavailable"
  end

  local missionRecord, reason = buildMissionRecord(missionType, options)

  if missionRecord == nil then
    return false, reason
  end

  if missionSignatureExists(missionRecord.signature) == true then
    return false, "mission_already_exists"
  end

  local added, addedResult = addMissionToContainer(missionRecord)

  if added ~= true then
    return false, addedResult
  end

  logInfo("Mission created: " .. missionRecord.type .. " [" .. missionRecord.key .. "]")

  return true, missionRecord
end

function MissionGenerator.getMission(missionKeyOrName)
  local state = ensureMissionState()

  if state == nil then
    return nil
  end

  local missionRecord = getMissionFromContainer(state.Missions.available, missionKeyOrName)

  if missionRecord ~= nil then
    return missionRecord
  end

  missionRecord = getMissionFromContainer(state.Missions.active, missionKeyOrName)

  if missionRecord ~= nil then
    return missionRecord
  end

  missionRecord = getMissionFromContainer(state.Missions.completed, missionKeyOrName)

  if missionRecord ~= nil then
    return missionRecord
  end

  missionRecord = getMissionFromContainer(state.Missions.failed, missionKeyOrName)

  if missionRecord ~= nil then
    return missionRecord
  end

  missionRecord = getMissionFromContainer(state.Missions.expired, missionKeyOrName)

  if missionRecord ~= nil then
    return missionRecord
  end

  return getMissionFromContainer(state.Missions.cancelled, missionKeyOrName)
end

function MissionGenerator.setMissionStatus(missionKeyOrName, status, reason)
  local state = ensureMissionState()

  if state == nil then
    return false, "state_unavailable"
  end

  if isValidStatus(status) ~= true then
    return false, "invalid_status"
  end

  local missionRecord = MissionGenerator.getMission(missionKeyOrName)

  if missionRecord == nil then
    return false, "mission_not_found"
  end

  missionRecord.previousStatus = missionRecord.status
  missionRecord.status = status
  missionRecord.statusReason = reason or "manual_status_update"
  missionRecord.updatedAt = getCurrentTime()

  if status == getStatusActive() or status == MissionGenerator.status.ACTIVE then
    missionRecord.activatedAt = missionRecord.activatedAt or getCurrentTime()
  elseif status == getStatusCompleted() or status == MissionGenerator.status.COMPLETED then
    missionRecord.completedAt = missionRecord.completedAt or getCurrentTime()
  elseif status == getStatusFailed() or status == MissionGenerator.status.FAILED then
    missionRecord.failedAt = missionRecord.failedAt or getCurrentTime()
  elseif status == getStatusExpired() or status == MissionGenerator.status.EXPIRED then
    missionRecord.expiredAt = missionRecord.expiredAt or getCurrentTime()
  elseif status == MissionGenerator.status.CANCELLED then
    missionRecord.cancelledAt = missionRecord.cancelledAt or getCurrentTime()
  end

  addMissionToContainer(missionRecord)

  logInfo("Mission status changed: " .. missionRecord.key .. " [" .. status .. "]")

  return true, missionRecord
end

function MissionGenerator.activateMission(missionKeyOrName, reason)
  return MissionGenerator.setMissionStatus(missionKeyOrName, getStatusActive(), reason or "mission_activated")
end

function MissionGenerator.completeMission(missionKeyOrName, reason)
  local statusChanged, missionRecordOrReason = MissionGenerator.setMissionStatus(
    missionKeyOrName,
    getStatusCompleted(),
    reason or "mission_completed"
  )

  if statusChanged ~= true then
    return false, missionRecordOrReason
  end

  applyMissionCompletionEffect(missionRecordOrReason)
  addMissionToContainer(missionRecordOrReason)
  markDirty("mission_completed")

  logInfo("Mission completed: " .. missionRecordOrReason.type .. " [" .. missionRecordOrReason.key .. "]")

  return true, missionRecordOrReason
end

function MissionGenerator.failMission(missionKeyOrName, reason)
  return MissionGenerator.setMissionStatus(missionKeyOrName, getStatusFailed(), reason or "mission_failed")
end

function MissionGenerator.expireMission(missionKeyOrName, reason)
  return MissionGenerator.setMissionStatus(missionKeyOrName, getStatusExpired(), reason or "mission_expired")
end

function MissionGenerator.cancelMission(missionKeyOrName, reason)
  return MissionGenerator.setMissionStatus(missionKeyOrName, MissionGenerator.status.CANCELLED, reason or "mission_cancelled")
end

function MissionGenerator.deleteMission(missionKeyOrName)
  local state = ensureMissionState()

  if state == nil then
    return false, "state_unavailable"
  end

  local missionRecord = MissionGenerator.getMission(missionKeyOrName)

  if missionRecord == nil then
    return false, "mission_not_found"
  end

  removeMissionFromAllContainers(state, missionRecord.key)
  updateStatistics()
  markDirty("mission_deleted")

  logInfo("Mission deleted: " .. missionRecord.key)

  return true
end

function MissionGenerator.getAvailableMissions()
  local state = ensureMissionState()

  if state == nil then
    return {}
  end

  return state.Missions.available
end

function MissionGenerator.getActiveMissions()
  local state = ensureMissionState()

  if state == nil then
    return {}
  end

  return state.Missions.active
end

function MissionGenerator.getCompletedMissions()
  local state = ensureMissionState()

  if state == nil then
    return {}
  end

  return state.Missions.completed
end

function MissionGenerator.getFailedMissions()
  local state = ensureMissionState()

  if state == nil then
    return {}
  end

  return state.Missions.failed
end

function MissionGenerator.getMissionsByType(missionType)
  local result = {}
  local state = ensureMissionState()

  if state == nil then
    return result
  end

  local containers = {
    state.Missions.available,
    state.Missions.active,
    state.Missions.completed,
    state.Missions.failed,
    state.Missions.expired,
    state.Missions.cancelled
  }

  for _, container in ipairs(containers) do
    for key, missionRecord in pairs(container) do
      if missionRecord.type == missionType then
        result[key] = missionRecord
      end
    end
  end

  return result
end

function MissionGenerator.getMissionsByTargetZone(targetZoneKey)
  local result = {}
  local state = ensureMissionState()

  if state == nil then
    return result
  end

  local containers = {
    state.Missions.available,
    state.Missions.active,
    state.Missions.completed,
    state.Missions.failed,
    state.Missions.expired,
    state.Missions.cancelled
  }

  for _, container in ipairs(containers) do
    for key, missionRecord in pairs(container) do
      if missionRecord.targetZoneKey == targetZoneKey then
        result[key] = missionRecord
      end
    end
  end

  return result
end

function MissionGenerator.getMissionsByTargetBase(targetBaseKey)
  local result = {}
  local state = ensureMissionState()

  if state == nil then
    return result
  end

  local containers = {
    state.Missions.available,
    state.Missions.active,
    state.Missions.completed,
    state.Missions.failed,
    state.Missions.expired,
    state.Missions.cancelled
  }

  for _, container in ipairs(containers) do
    for key, missionRecord in pairs(container) do
      if missionRecord.targetBaseKey == targetBaseKey then
        result[key] = missionRecord
      end
    end
  end

  return result
end

function MissionGenerator.clearAvailableMissions()
  local state = ensureMissionState()

  if state == nil then
    return false, "state_unavailable"
  end

  state.Missions.available = {}

  updateStatistics()
  markDirty("available_missions_cleared")

  logInfo("Available missions cleared")

  return true
end

function MissionGenerator.generateAvailableMissions(options)
  local state = ensureMissionState()

  if state == nil then
    return false, "state_unavailable"
  end

  local generationOptions = options or {}
  local limit = generationOptions.limit or MissionGenerator.defaultGenerationLimit
  local created = 0

  MissionGenerator.lastGenerationTime = getCurrentTime()

  logInfo("Mission generation started")

  if generationOptions.clearExisting == true then
    MissionGenerator.clearAvailableMissions()
  end

  created = generateFromContestedZones(limit, created)

  if created < limit then
    created = generateFromRedBases(limit, created)
  end

  if created < limit then
    created = generateFromRedZones(limit, created)
  end

  if created < limit then
    created = generateFromFobs(limit, created)
  end

  if created < limit then
    created = generateFromBlueZones(limit, created)
  end

  updateStatistics()
  markDirty("missions_generated")

  logInfo("Mission generation completed: " .. tostring(created) .. " new missions")

  return true, created
end

function MissionGenerator.start()
  MissionGenerator.started = true
  MissionGenerator.finished = false
  MissionGenerator.failed = false

  logInfo("Mission generator started")

  local state = ensureMissionState()

  if state == nil then
    MissionGenerator.failed = true
    setModuleStatus("FAILED")
    logError("Mission generator failed: state_unavailable")
    return false
  end

  setFeatureStatus(true)
  setModuleStatus("RUNNING")
  updateStatistics()

  MissionGenerator.generateAvailableMissions({
    limit = MissionGenerator.defaultGenerationLimit,
    clearExisting = false
  })

  MissionGenerator.finished = true

  logInfo("Mission generator initialized")

  return true
end

function MissionGenerator.stop()
  MissionGenerator.started = false

  setModuleStatus("STOPPED")

  logInfo("Mission generator stopped")

  return true
end

function MissionGenerator.summary()
  local state = getState()
  local missionState = nil

  if state ~= nil then
    missionState = state.Missions
  end

  return {
    name = MissionGenerator.name,
    path = MissionGenerator.path,
    version = MissionGenerator.version,
    loaded = MissionGenerator.loaded,
    started = MissionGenerator.started,
    finished = MissionGenerator.finished,
    failed = MissionGenerator.failed,
    lastGenerationTime = MissionGenerator.lastGenerationTime,
    statistics = missionState and missionState.statistics or nil,
    state = missionState
  }
end

TC.Missions.Generator = MissionGenerator

TC.modules.missionGenerator = {
  name = MissionGenerator.name,
  path = MissionGenerator.path,
  loaded = true,
  version = MissionGenerator.version
}

local state = getState()

if state ~= nil and state.setModuleStatus ~= nil then
  state.setModuleStatus("missionGenerator", "LOADED")
end

logInfo("Mission generator loaded")

return MissionGenerator
