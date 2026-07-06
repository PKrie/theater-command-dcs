-- Theater Command DCS
-- File: src/missions/tc_mission_generator.lua
--
-- Purpose:
-- Generate, activate and manage dynamic campaign missions from the current
-- Theater Command campaign state.
--
-- Current focus:
-- Mission Generator v0.2.3 keeps the proven v0.2.2 mission generation and
-- activation model and adds state-only mission outcome handling.
--
-- Version:
-- 0.2.3
--
-- Responsibilities:
-- - build mission candidates from classified campaign zones
-- - build FOB support candidates from planned and under-construction FOBs
-- - reserve mission pool space for FOB support when FOBs require support
-- - prioritize missions by owner, zone class, FOB need and strategic relevance
-- - avoid medical pads, single helipads and unknown objects as strike targets
-- - prevent duplicate missions for the same target/type combination
-- - enrich missions with objectives, briefing, progress and activation state
-- - activate missions state-only from F10 or later AI/Debug systems
-- - complete, fail, cancel or expire missions state-only
-- - prepare mission outcome effects for Capture, Logistics, AI and IADS
-- - keep all execution hooks reserved until real framework integration exists
--
-- Vendor note:
-- This file does not directly call MIST, MOOSE, CTLD or Skynet IADS.
-- It consumes Theater Command state produced by World, Campaign, Logistics,
-- FOB and AI systems. Framework-specific execution will be added later in
-- dedicated systems.

TC = TC or {}
TC.modules = TC.modules or {}
TC.Missions = TC.Missions or {}
TC.missions = TC.missions or TC.Missions

local MissionGenerator = {}

MissionGenerator.name = "tc_mission_generator"
MissionGenerator.displayName = "Mission Generator"
MissionGenerator.path = "src/missions/tc_mission_generator.lua"
MissionGenerator.version = "0.2.3"
MissionGenerator.loaded = true
MissionGenerator.started = false
MissionGenerator.finished = false
MissionGenerator.failed = false

MissionGenerator.lastGenerationTime = 0
MissionGenerator.lastCandidateCount = 0
MissionGenerator.lastCreatedCount = 0
MissionGenerator.lastSkippedDuplicateCount = 0
MissionGenerator.lastSkippedLimitCount = 0
MissionGenerator.lastReservedCreatedCount = 0
MissionGenerator.lastFobCandidateCount = 0
MissionGenerator.lastActivationTime = 0
MissionGenerator.lastActivatedMissionKey = nil
MissionGenerator.lastOutcomeTime = 0
MissionGenerator.lastCompletedMissionKey = nil
MissionGenerator.lastFailedMissionKey = nil
MissionGenerator.lastEffectPreparationTime = 0
MissionGenerator.lastPreparedEffectMissionKey = nil

MissionGenerator.defaultGenerationLimit = 10
MissionGenerator.minimumFobSupportMissions = 1

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

MissionGenerator.progressStage = {
  PLANNED = "PLANNED",
  SELECTED = "SELECTED",
  ACTIVE = "ACTIVE",
  IN_PROGRESS = "IN_PROGRESS",
  EFFECT_PENDING = "EFFECT_PENDING",
  EFFECT_PREPARED = "EFFECT_PREPARED",
  COMPLETED = "COMPLETED",
  FAILED = "FAILED",
  EXPIRED = "EXPIRED",
  CANCELLED = "CANCELLED"
}

MissionGenerator.executionMode = {
  STATE_ONLY = "STATE_ONLY",
  RESERVED = "RESERVED",
  LIVE = "LIVE"
}

MissionGenerator.outcome = {
  NONE = "NONE",
  SUCCESS = "SUCCESS",
  FAILURE = "FAILURE",
  CANCELLED = "CANCELLED",
  EXPIRED = "EXPIRED"
}

MissionGenerator.effectStatus = {
  NONE = "NONE",
  PREPARED = "PREPARED",
  APPLIED_STATE_ONLY = "APPLIED_STATE_ONLY",
  RESERVED = "RESERVED",
  SKIPPED = "SKIPPED"
}

MissionGenerator.defaultPriorities = {
  RECON = 30,
  STRIKE = 60,
  SEAD = 75,
  DEAD = 80,
  CAS = 55,
  INTERDICTION = 50,
  ESCORT = 35,
  CAP = 45,
  LOGISTICS = 50,
  FOB_SUPPORT = 92,
  AIRBASE_ATTACK = 85,
  IADS_SUPPRESSION = 75
}

MissionGenerator.maxPerGenerationByType = {
  RECON = 1,
  STRIKE = 3,
  SEAD = 2,
  DEAD = 1,
  CAS = 2,
  INTERDICTION = 2,
  ESCORT = 1,
  CAP = 1,
  LOGISTICS = 2,
  FOB_SUPPORT = 2,
  AIRBASE_ATTACK = 4,
  IADS_SUPPRESSION = 1
}

MissionGenerator.zoneClasses = {
  STRATEGIC_AIRBASE_ZONE = "STRATEGIC_AIRBASE_ZONE",
  SECONDARY_AIRBASE_ZONE = "SECONDARY_AIRBASE_ZONE",
  HELIPORT_ZONE = "HELIPORT_ZONE",
  FARP_ZONE = "FARP_ZONE",
  TACTICAL_PAD_ZONE = "TACTICAL_PAD_ZONE",
  MISSION_EDITOR_CAPTURE_ZONE = "MISSION_EDITOR_CAPTURE_ZONE",
  MISSION_EDITOR_ZONE = "MISSION_EDITOR_ZONE",
  UNKNOWN_ZONE = "UNKNOWN_ZONE"
}

MissionGenerator.airbaseClassifications = {
  STRATEGIC_AIRFIELD = "STRATEGIC_AIRFIELD",
  SECONDARY_AIRFIELD = "SECONDARY_AIRFIELD",
  HELIPORT = "HELIPORT",
  HELIPAD = "HELIPAD",
  MEDICAL_PAD = "MEDICAL_PAD",
  FARP = "FARP",
  TACTICAL_PAD = "TACTICAL_PAD",
  UNKNOWN = "UNKNOWN"
}

MissionGenerator.fobStatus = {
  PLANNED = "PLANNED",
  UNDER_CONSTRUCTION = "UNDER_CONSTRUCTION",
  ACTIVE = "ACTIVE",
  DAMAGED = "DAMAGED",
  OUT_OF_SUPPLY = "OUT_OF_SUPPLY",
  DESTROYED = "DESTROYED"
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

local function rawLog(level, message)
  local formatted = "[TC][MISSION_GENERATOR] " .. tostring(message)

  if env ~= nil then
    if level == "ERROR" and env.error ~= nil then
      env.error(formatted)
      return
    end
    if level == "WARN" and env.warning ~= nil then
      env.warning(formatted)
      return
    end
    if env.info ~= nil then
      env.info(formatted)
      return
    end
  end

  if print ~= nil then
    print(formatted)
  end
end

local function logInfo(message)
  local logger = getLogger()
  if logger ~= nil and logger.info ~= nil then
    logger.info("[MissionGenerator] " .. tostring(message))
    return
  end
  rawLog("INFO", message)
end

local function logWarn(message)
  local logger = getLogger()
  if logger ~= nil and logger.warn ~= nil then
    logger.warn("[MissionGenerator] " .. tostring(message))
    return
  end
  rawLog("WARN", message)
end

local function logError(message)
  local logger = getLogger()
  if logger ~= nil and logger.error ~= nil then
    logger.error("[MissionGenerator] " .. tostring(message))
    return
  end
  rawLog("ERROR", message)
end

local function logDebug(message)
  local logger = getLogger()
  if logger ~= nil and logger.debug ~= nil then
    logger.debug("[MissionGenerator] " .. tostring(message))
  end
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

local function normalizeName(value)
  local utils = getUtils()
  if utils ~= nil and utils.normalizeName ~= nil then
    local normalizedByUtils = utils.normalizeName(value)
    if normalizedByUtils ~= nil and normalizedByUtils ~= "" then
      return normalizedByUtils
    end
  end

  if value == nil then
    return "UNKNOWN"
  end

  local normalized = tostring(value)
  normalized = string.upper(normalized)
  normalized = string.gsub(normalized, "^%s*(.-)%s*$", "%1")
  normalized = string.gsub(normalized, "[%-/]+", "_")
  normalized = string.gsub(normalized, "%s+", "_")
  normalized = string.gsub(normalized, "[^A-Z0-9_]", "_")
  normalized = string.gsub(normalized, "_+", "_")
  normalized = string.gsub(normalized, "^_+", "")
  normalized = string.gsub(normalized, "_+$", "")

  if normalized == "" then
    return "UNKNOWN"
  end

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
    if type(childValue) ~= "function"
      and type(childValue) ~= "userdata"
      and type(childValue) ~= "thread" then
      result[copyValue(key, visited)] = copyValue(childValue, visited)
    end
  end

  visited[value] = nil

  return result
end

local function clamp(value, minimum, maximum)
  local numeric = tonumber(value)

  if numeric == nil then
    numeric = minimum or 0
  end

  if type(minimum) == "number" and numeric < minimum then
    return minimum
  end

  if type(maximum) == "number" and numeric > maximum then
    return maximum
  end

  return numeric
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

local function getStatusCancelled()
  return getConstant("missionStatus", "CANCELLED", MissionGenerator.status.CANCELLED)
end

local function getRecordOwner(record)
  if type(record) ~= "table" then
    return getOwnerUnknown()
  end

  return record.currentOwner
    or record.initialOwner
    or record.owner
    or record.side
    or getOwnerUnknown()
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

local function isFinalStatus(status)
  return status == getStatusCompleted()
    or status == MissionGenerator.status.COMPLETED
    or status == getStatusFailed()
    or status == MissionGenerator.status.FAILED
    or status == getStatusExpired()
    or status == MissionGenerator.status.EXPIRED
    or status == getStatusCancelled()
    or status == MissionGenerator.status.CANCELLED
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
  state.Missions.lastGenerationTime = state.Missions.lastGenerationTime or 0
  state.Missions.lastActivationTime = state.Missions.lastActivationTime or 0
  state.Missions.lastActivatedMissionKey = state.Missions.lastActivatedMissionKey
  state.Missions.lastOutcomeTime = state.Missions.lastOutcomeTime or 0
  state.Missions.lastCompletedMissionKey = state.Missions.lastCompletedMissionKey
  state.Missions.lastFailedMissionKey = state.Missions.lastFailedMissionKey
  state.Missions.generationHistory = state.Missions.generationHistory or {}
  state.Missions.activationHistory = state.Missions.activationHistory or {}
  state.Missions.outcomeHistory = state.Missions.outcomeHistory or {}
  state.Missions.effectHistory = state.Missions.effectHistory or {}
  state.Missions.statistics = state.Missions.statistics or {}

  local statistics = state.Missions.statistics
  statistics.total = statistics.total or 0
  statistics.available = statistics.available or 0
  statistics.active = statistics.active or 0
  statistics.completed = statistics.completed or 0
  statistics.failed = statistics.failed or 0
  statistics.expired = statistics.expired or 0
  statistics.cancelled = statistics.cancelled or 0
  statistics.lastCreated = statistics.lastCreated or 0
  statistics.lastCandidates = statistics.lastCandidates or 0
  statistics.lastFobCandidates = statistics.lastFobCandidates or 0
  statistics.lastReservedCreated = statistics.lastReservedCreated or 0
  statistics.lastDuplicatesSkipped = statistics.lastDuplicatesSkipped or 0
  statistics.lastLimitSkipped = statistics.lastLimitSkipped or 0
  statistics.lastActivatedMissionKey = statistics.lastActivatedMissionKey
  statistics.lastActivationTime = statistics.lastActivationTime or 0
  statistics.lastCompletedMissionKey = statistics.lastCompletedMissionKey
  statistics.lastFailedMissionKey = statistics.lastFailedMissionKey
  statistics.lastOutcomeTime = statistics.lastOutcomeTime or 0
  statistics.lastPreparedEffectMissionKey = statistics.lastPreparedEffectMissionKey
  statistics.lastEffectPreparationTime = statistics.lastEffectPreparationTime or 0
  statistics.preparedEffects = statistics.preparedEffects or 0

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

local function findRecordByKeyOrName(registry, keyOrName)
  if type(registry) ~= "table" or keyOrName == nil then
    return nil
  end

  if registry[keyOrName] ~= nil then
    return registry[keyOrName]
  end

  local normalizedSearch = normalizeName(keyOrName)

  for _, record in pairs(registry) do
    if type(record) == "table" then
      if record.key == keyOrName then
        return record
      end
      if record.normalizedName == normalizedSearch then
        return record
      end
      if normalizeName(record.name) == normalizedSearch then
        return record
      end
      if normalizeName(record.displayName) == normalizedSearch then
        return record
      end
    end
  end

  return nil
end

local function findBaseByKeyOrName(keyOrName)
  return findRecordByKeyOrName(getBaseRegistry(), keyOrName)
end

local function getZoneName(zoneRecord)
  if type(zoneRecord) ~= "table" then
    return "UNKNOWN"
  end

  return zoneRecord.displayName
    or zoneRecord.name
    or zoneRecord.zoneName
    or zoneRecord.key
    or zoneRecord.normalizedName
    or "UNKNOWN"
end

local function getZoneKey(zoneRecord)
  if type(zoneRecord) ~= "table" then
    return "UNKNOWN_ZONE"
  end

  return zoneRecord.key
    or zoneRecord.zoneKey
    or normalizeName(getZoneName(zoneRecord))
end

local function getBaseName(baseRecord)
  if type(baseRecord) ~= "table" then
    return "UNKNOWN"
  end

  return baseRecord.displayName
    or baseRecord.name
    or baseRecord.airbaseName
    or baseRecord.key
    or baseRecord.normalizedName
    or "UNKNOWN"
end

local function getFobName(fobRecord)
  if type(fobRecord) ~= "table" then
    return "UNKNOWN"
  end

  return fobRecord.displayName
    or fobRecord.name
    or fobRecord.fobName
    or fobRecord.key
    or fobRecord.normalizedName
    or "UNKNOWN"
end

local function getZoneClass(zoneRecord)
  if type(zoneRecord) ~= "table" then
    return MissionGenerator.zoneClasses.UNKNOWN_ZONE
  end

  return zoneRecord.zoneClass
    or zoneRecord.classification
    or zoneRecord.type
    or MissionGenerator.zoneClasses.UNKNOWN_ZONE
end

local function getAirbaseClassification(record)
  if type(record) ~= "table" then
    return MissionGenerator.airbaseClassifications.UNKNOWN
  end

  return record.airbaseClassification
    or record.classification
    or record.baseClassification
    or MissionGenerator.airbaseClassifications.UNKNOWN
end

local function isStrategicZone(zoneRecord)
  local zoneClass = getZoneClass(zoneRecord)
  return zoneClass == MissionGenerator.zoneClasses.STRATEGIC_AIRBASE_ZONE
    or zoneClass == MissionGenerator.zoneClasses.MISSION_EDITOR_CAPTURE_ZONE
end

local function isSecondaryZone(zoneRecord)
  local zoneClass = getZoneClass(zoneRecord)
  return zoneClass == MissionGenerator.zoneClasses.SECONDARY_AIRBASE_ZONE
end

local function isExcludedZone(zoneRecord)
  local zoneClass = getZoneClass(zoneRecord)
  local airbaseClassification = getAirbaseClassification(zoneRecord)

  if zoneClass == MissionGenerator.zoneClasses.HELIPORT_ZONE then
    return true
  end
  if zoneClass == MissionGenerator.zoneClasses.FARP_ZONE then
    return true
  end
  if zoneClass == MissionGenerator.zoneClasses.TACTICAL_PAD_ZONE then
    return true
  end
  if zoneClass == MissionGenerator.zoneClasses.UNKNOWN_ZONE then
    return true
  end

  if airbaseClassification == MissionGenerator.airbaseClassifications.HELIPORT then
    return true
  end
  if airbaseClassification == MissionGenerator.airbaseClassifications.HELIPAD then
    return true
  end
  if airbaseClassification == MissionGenerator.airbaseClassifications.MEDICAL_PAD then
    return true
  end
  if airbaseClassification == MissionGenerator.airbaseClassifications.FARP then
    return true
  end
  if airbaseClassification == MissionGenerator.airbaseClassifications.TACTICAL_PAD then
    return true
  end
  if airbaseClassification == MissionGenerator.airbaseClassifications.UNKNOWN then
    return true
  end

  return false
end

local function isMissionZone(zoneRecord)
  if type(zoneRecord) ~= "table" then
    return false
  end

  if isExcludedZone(zoneRecord) == true then
    return false
  end

  if zoneRecord.isMissionZone == true
    or zoneRecord.missionZone == true
    or zoneRecord.missionCandidate == true
    or zoneRecord.isMissionCandidate == true
    or zoneRecord.missionEligible == true then
    return true
  end

  local state = getState()
  local zoneKey = getZoneKey(zoneRecord)

  if state ~= nil and state.Zones ~= nil and type(state.Zones.missionZones) == "table" then
    if state.Zones.missionZones[zoneKey] ~= nil then
      return true
    end
  end

  if isStrategicZone(zoneRecord) == true or isSecondaryZone(zoneRecord) == true then
    return true
  end

  return false
end

local function getStrategicRelevance(zoneRecord)
  if type(zoneRecord) ~= "table" then
    return 0
  end

  if tonumber(zoneRecord.strategicRelevance) ~= nil then
    return tonumber(zoneRecord.strategicRelevance)
  end

  if isStrategicZone(zoneRecord) == true then
    return 90
  end

  if isSecondaryZone(zoneRecord) == true then
    return 65
  end

  return 25
end

local function getDistancePriorityModifier(zoneRecord)
  if type(zoneRecord) ~= "table" then
    return 0
  end

  if zoneRecord.isStartBaseZone == true or zoneRecord.isStartBase == true then
    return -50
  end

  local owner = getRecordOwner(zoneRecord)
  if owner == getOwnerRed() then
    return 10
  end

  if owner == getOwnerContested() then
    return 20
  end

  if owner == getOwnerNeutral() then
    return 5
  end

  return 0
end

local function getTargetBaseForZone(zoneRecord)
  if type(zoneRecord) ~= "table" then
    return nil
  end

  local baseKey = zoneRecord.baseKey
    or zoneRecord.airbaseKey
    or zoneRecord.linkedBaseKey
    or zoneRecord.sourceAirbaseKey

  if baseKey ~= nil then
    return findBaseByKeyOrName(baseKey)
  end

  local baseName = zoneRecord.baseName
    or zoneRecord.airbaseName
    or zoneRecord.sourceAirbaseName

  if baseName ~= nil then
    return findBaseByKeyOrName(baseName)
  end

  return nil
end

local function buildCandidateKey(missionType, targetKey)
  return normalizeName(tostring(missionType or "MISSION") .. "_" .. tostring(targetKey or "UNKNOWN"))
end

local function buildObjective(missionType, targetName)
  if missionType == MissionGenerator.types.FOB_SUPPORT then
    return "Support forward base construction and sustainment at " .. tostring(targetName) .. "."
  end

  if missionType == MissionGenerator.types.AIRBASE_ATTACK then
    return "Attack and disrupt enemy airbase operations at " .. tostring(targetName) .. "."
  end

  if missionType == MissionGenerator.types.STRIKE then
    return "Strike operational targets around " .. tostring(targetName) .. "."
  end

  if missionType == MissionGenerator.types.SEAD then
    return "Suppress air defense threats protecting " .. tostring(targetName) .. "."
  end

  if missionType == MissionGenerator.types.DEAD then
    return "Destroy priority air defense assets around " .. tostring(targetName) .. "."
  end

  if missionType == MissionGenerator.types.CAP then
    return "Provide combat air patrol coverage over " .. tostring(targetName) .. "."
  end

  if missionType == MissionGenerator.types.LOGISTICS then
    return "Move supplies and sustain operations around " .. tostring(targetName) .. "."
  end

  if missionType == MissionGenerator.types.INTERDICTION then
    return "Interdict enemy movement and logistics around " .. tostring(targetName) .. "."
  end

  if missionType == MissionGenerator.types.RECON then
    return "Reconnoiter enemy activity around " .. tostring(targetName) .. "."
  end

  return "Execute " .. tostring(missionType or "mission") .. " tasking at " .. tostring(targetName) .. "."
end

local function buildBriefing(missionType, targetName, owner)
  local lines = {
    "Operation Levant Reclamation",
    "",
    "Mission Type: " .. tostring(missionType or "UNKNOWN"),
    "Target: " .. tostring(targetName or "UNKNOWN"),
    "Current Owner: " .. tostring(owner or "UNKNOWN"),
    "",
    "Intent:",
    buildObjective(missionType, targetName),
    "",
    "Execution:",
    "This mission is currently state-only. Real MOOSE, CTLD and Skynet execution hooks are reserved but not executed."
  }

  return table.concat(lines, "\n")
end

local function buildDefaultEffect(missionType)
  if missionType == MissionGenerator.types.FOB_SUPPORT then
    return {
      supply = 25,
      engineering = 25,
      fobConstruction = 25,
      capturePressure = 0,
      logisticsSupport = 25
    }
  end

  if missionType == MissionGenerator.types.AIRBASE_ATTACK then
    return {
      capturePressure = 35,
      airbasePressure = 35,
      logisticsPressure = 10,
      aiPressure = 10
    }
  end

  if missionType == MissionGenerator.types.STRIKE then
    return {
      capturePressure = 25,
      airbasePressure = 20,
      logisticsPressure = 15
    }
  end

  if missionType == MissionGenerator.types.SEAD then
    return {
      capturePressure = 10,
      iadsSuppressionPressure = 30,
      airDefenseSuppression = 30
    }
  end

  if missionType == MissionGenerator.types.DEAD then
    return {
      capturePressure = 15,
      iadsSuppressionPressure = 45,
      airDefenseDestruction = 45
    }
  end

  if missionType == MissionGenerator.types.CAP then
    return {
      airControl = 25,
      aiPressure = 15,
      capturePressure = 5
    }
  end

  if missionType == MissionGenerator.types.LOGISTICS then
    return {
      supply = 25,
      logisticsSupport = 25,
      capturePressure = 5
    }
  end

  if missionType == MissionGenerator.types.INTERDICTION then
    return {
      capturePressure = 15,
      logisticsPressure = 25,
      aiPressure = 10
    }
  end

  if missionType == MissionGenerator.types.RECON then
    return {
      intelligence = 20,
      capturePressure = 5
    }
  end

  return {
    capturePressure = 10
  }
end

local function buildReservedExecutionHooks(missionType)
  return {
    moose = {
      status = "reserved",
      module = "MOOSE",
      intendedUse = "future AI package spawning",
      executed = false
    },
    ctld = {
      status = "reserved",
      module = "CTLD",
      intendedUse = missionType == MissionGenerator.types.FOB_SUPPORT and "future cargo or FOB support" or "future logistics support",
      executed = false
    },
    skynet = {
      status = "reserved",
      module = "Skynet IADS",
      intendedUse = "future IADS state influence",
      executed = false
    }
  }
end

local function buildExecutionPlan(missionType)
  return {
    mode = MissionGenerator.executionMode.STATE_ONLY,
    stateOnly = true,
    spawnHooks = "reserved",
    liveExecution = false,
    frameworkExecution = false,
    hooks = buildReservedExecutionHooks(missionType)
  }
end

local function buildProgress(stage, percent)
  return {
    stage = stage or MissionGenerator.progressStage.PLANNED,
    percent = clamp(percent or 0, 0, 100),
    startedAt = nil,
    updatedAt = getCurrentTime(),
    completedAt = nil,
    failedAt = nil,
    stateOnly = true
  }
end

local function buildZoneCandidate(missionType, zoneRecord, priorityModifier)
  local zoneKey = getZoneKey(zoneRecord)
  local zoneName = getZoneName(zoneRecord)
  local baseRecord = getTargetBaseForZone(zoneRecord)
  local baseKey = nil
  local baseName = nil

  if baseRecord ~= nil then
    baseKey = baseRecord.key or baseRecord.normalizedName or normalizeName(getBaseName(baseRecord))
    baseName = getBaseName(baseRecord)
  else
    baseKey = zoneRecord.baseKey or zoneRecord.airbaseKey or zoneRecord.linkedBaseKey
    baseName = zoneRecord.baseName or zoneRecord.airbaseName or zoneName
  end

  local owner = getRecordOwner(zoneRecord)
  local basePriority = MissionGenerator.defaultPriorities[missionType] or 50
  local strategicRelevance = getStrategicRelevance(zoneRecord)
  local priority = basePriority + math.floor(strategicRelevance / 10) + (priorityModifier or 0) + getDistancePriorityModifier(zoneRecord)
  local targetName = baseName or zoneName
  local targetKey = baseKey or zoneKey

  return {
    candidateKey = buildCandidateKey(missionType, targetKey),
    type = missionType,
    owner = owner,
    targetKey = targetKey,
    targetName = targetName,
    targetZoneKey = zoneKey,
    targetZoneName = zoneName,
    targetBaseKey = baseKey,
    targetBaseName = baseName,
    zoneClass = getZoneClass(zoneRecord),
    airbaseClassification = getAirbaseClassification(zoneRecord),
    priority = priority,
    strategicRelevance = strategicRelevance,
    source = "zone",
    objective = buildObjective(missionType, targetName),
    briefing = buildBriefing(missionType, targetName, owner),
    effect = buildDefaultEffect(missionType)
  }
end

local function buildFobCandidate(fobRecord)
  local fobKey = fobRecord.key or fobRecord.fobKey or normalizeName(getFobName(fobRecord))
  local fobName = getFobName(fobRecord)
  local owner = getRecordOwner(fobRecord)
  local status = fobRecord.status or MissionGenerator.fobStatus.PLANNED
  local priority = MissionGenerator.defaultPriorities.FOB_SUPPORT

  if status == MissionGenerator.fobStatus.UNDER_CONSTRUCTION then
    priority = priority + 8
  elseif status == MissionGenerator.fobStatus.DAMAGED then
    priority = priority + 12
  elseif status == MissionGenerator.fobStatus.OUT_OF_SUPPLY then
    priority = priority + 14
  end

  return {
    candidateKey = buildCandidateKey(MissionGenerator.types.FOB_SUPPORT, fobKey),
    type = MissionGenerator.types.FOB_SUPPORT,
    owner = owner,
    targetKey = fobKey,
    targetName = fobName,
    targetFobKey = fobKey,
    targetFobName = fobName,
    targetZoneKey = fobRecord.zoneKey,
    targetZoneName = fobRecord.zoneName,
    targetBaseKey = fobRecord.baseKey,
    targetBaseName = fobRecord.baseName,
    fobStatus = status,
    priority = priority,
    strategicRelevance = 80,
    source = "fob",
    objective = buildObjective(MissionGenerator.types.FOB_SUPPORT, fobName),
    briefing = buildBriefing(MissionGenerator.types.FOB_SUPPORT, fobName, owner),
    effect = buildDefaultEffect(MissionGenerator.types.FOB_SUPPORT)
  }
end

local function addCandidate(candidates, candidate)
  if type(candidates) ~= "table" or type(candidate) ~= "table" then
    return false
  end

  if candidate.candidateKey == nil then
    candidate.candidateKey = buildCandidateKey(candidate.type, candidate.targetKey)
  end

  table.insert(candidates, candidate)
  return true
end

local function buildZoneCandidates()
  local candidates = {}

  for _, zoneRecord in pairs(getZoneRegistry()) do
    if isMissionZone(zoneRecord) == true then
      local owner = getRecordOwner(zoneRecord)

      if owner == getOwnerRed() or owner == getOwnerContested() or owner == getOwnerNeutral() then
        addCandidate(candidates, buildZoneCandidate(MissionGenerator.types.AIRBASE_ATTACK, zoneRecord, 0))
        addCandidate(candidates, buildZoneCandidate(MissionGenerator.types.STRIKE, zoneRecord, -8))

        if isStrategicZone(zoneRecord) == true then
          addCandidate(candidates, buildZoneCandidate(MissionGenerator.types.SEAD, zoneRecord, -4))
        end

        if owner == getOwnerContested() then
          addCandidate(candidates, buildZoneCandidate(MissionGenerator.types.CAS, zoneRecord, -12))
        end
      elseif owner == getOwnerBlue() then
        if zoneRecord.isStartBaseZone == true or zoneRecord.isStartBase == true then
          addCandidate(candidates, buildZoneCandidate(MissionGenerator.types.CAP, zoneRecord, 4))
          addCandidate(candidates, buildZoneCandidate(MissionGenerator.types.LOGISTICS, zoneRecord, -6))
        else
          addCandidate(candidates, buildZoneCandidate(MissionGenerator.types.LOGISTICS, zoneRecord, -10))
        end
      else
        addCandidate(candidates, buildZoneCandidate(MissionGenerator.types.RECON, zoneRecord, -15))
      end
    end
  end

  return candidates
end

local function fobNeedsSupport(fobRecord)
  if type(fobRecord) ~= "table" then
    return false
  end

  local status = fobRecord.status
  if status == MissionGenerator.fobStatus.PLANNED
    or status == MissionGenerator.fobStatus.UNDER_CONSTRUCTION
    or status == MissionGenerator.fobStatus.DAMAGED
    or status == MissionGenerator.fobStatus.OUT_OF_SUPPLY then
    return true
  end

  if tonumber(fobRecord.constructionProgress) ~= nil and tonumber(fobRecord.constructionProgress) < 100 then
    return true
  end

  if tonumber(fobRecord.supplyLevel) ~= nil and tonumber(fobRecord.supplyLevel) < 50 then
    return true
  end

  return false
end

local function buildFobCandidates()
  local candidates = {}

  for _, fobRecord in pairs(getFobRegistry()) do
    if fobNeedsSupport(fobRecord) == true then
      addCandidate(candidates, buildFobCandidate(fobRecord))
    end
  end

  return candidates
end

local function sortCandidates(candidates)
  table.sort(candidates, function(left, right)
    local leftPriority = tonumber(left.priority) or 0
    local rightPriority = tonumber(right.priority) or 0
    if leftPriority ~= rightPriority then
      return leftPriority > rightPriority
    end

    local leftRelevance = tonumber(left.strategicRelevance) or 0
    local rightRelevance = tonumber(right.strategicRelevance) or 0
    if leftRelevance ~= rightRelevance then
      return leftRelevance > rightRelevance
    end

    local leftType = tostring(left.type or "UNKNOWN")
    local rightType = tostring(right.type or "UNKNOWN")
    if leftType ~= rightType then
      return leftType < rightType
    end

    local leftTarget = tostring(left.targetName or left.targetKey or "UNKNOWN")
    local rightTarget = tostring(right.targetName or right.targetKey or "UNKNOWN")
    if leftTarget ~= rightTarget then
      return leftTarget < rightTarget
    end

    return tostring(left.candidateKey or "") < tostring(right.candidateKey or "")
  end)

  return candidates
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
  if status == getStatusCancelled() or status == MissionGenerator.status.CANCELLED then
    return state.Missions.cancelled
  end

  return state.Missions.available
end

local function removeMissionFromAllContainers(state, missionKey)
  if state == nil or state.Missions == nil or missionKey == nil then
    return false
  end

  if state.Missions.available ~= nil then
    state.Missions.available[missionKey] = nil
  end
  if state.Missions.active ~= nil then
    state.Missions.active[missionKey] = nil
  end
  if state.Missions.completed ~= nil then
    state.Missions.completed[missionKey] = nil
  end
  if state.Missions.failed ~= nil then
    state.Missions.failed[missionKey] = nil
  end
  if state.Missions.expired ~= nil then
    state.Missions.expired[missionKey] = nil
  end
  if state.Missions.cancelled ~= nil then
    state.Missions.cancelled[missionKey] = nil
  end

  return true
end

local function updateStatistics()
  local state = ensureMissionState()
  if state == nil then
    return false
  end

  local statistics = state.Missions.statistics

  statistics.available = countTableKeys(state.Missions.available)
  statistics.active = countTableKeys(state.Missions.active)
  statistics.completed = countTableKeys(state.Missions.completed)
  statistics.failed = countTableKeys(state.Missions.failed)
  statistics.expired = countTableKeys(state.Missions.expired)
  statistics.cancelled = countTableKeys(state.Missions.cancelled)
  statistics.total = statistics.available
    + statistics.active
    + statistics.completed
    + statistics.failed
    + statistics.expired
    + statistics.cancelled

  statistics.lastActivatedMissionKey = state.Missions.lastActivatedMissionKey
  statistics.lastActivationTime = state.Missions.lastActivationTime or 0
  statistics.lastCompletedMissionKey = state.Missions.lastCompletedMissionKey
  statistics.lastFailedMissionKey = state.Missions.lastFailedMissionKey
  statistics.lastOutcomeTime = state.Missions.lastOutcomeTime or 0
  statistics.lastPreparedEffectMissionKey = state.Missions.lastPreparedEffectMissionKey
  statistics.lastEffectPreparationTime = state.Missions.lastEffectPreparationTime or 0

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

local function buildMissionRecord(candidate)
  local missionId = createMissionId()
  if missionId == nil then
    return nil
  end

  local missionKey = buildMissionKey(missionId)
  local now = getCurrentTime()

  local missionRecord = {
    id = missionId,
    key = missionKey,
    name = missionKey,
    displayName = tostring(candidate.type or "MISSION") .. " - " .. tostring(candidate.targetName or candidate.targetKey or "UNKNOWN"),
    candidateKey = candidate.candidateKey,
    type = candidate.type,
    status = getStatusAvailable(),
    owner = candidate.owner or getOwnerUnknown(),
    targetKey = candidate.targetKey,
    targetName = candidate.targetName,
    targetZoneKey = candidate.targetZoneKey,
    targetZoneName = candidate.targetZoneName,
    targetBaseKey = candidate.targetBaseKey,
    targetBaseName = candidate.targetBaseName,
    targetFobKey = candidate.targetFobKey,
    targetFobName = candidate.targetFobName,
    zoneClass = candidate.zoneClass,
    airbaseClassification = candidate.airbaseClassification,
    fobStatus = candidate.fobStatus,
    source = candidate.source,
    priority = candidate.priority or MissionGenerator.defaultPriorities[candidate.type] or 50,
    strategicRelevance = candidate.strategicRelevance or 0,
    objective = candidate.objective,
    briefing = candidate.briefing,
    effect = copyValue(candidate.effect),
    progress = buildProgress(MissionGenerator.progressStage.PLANNED, 0),
    activation = {
      activated = false,
      activatedAt = nil,
      activatedBy = nil,
      activationReason = nil,
      stateOnly = true
    },
    outcome = {
      status = MissionGenerator.outcome.NONE,
      reason = nil,
      completedAt = nil,
      failedAt = nil,
      cancelledAt = nil,
      expiredAt = nil,
      stateOnly = true
    },
    effectState = {
      status = MissionGenerator.effectStatus.NONE,
      prepared = false,
      applied = false,
      stateOnly = true,
      preparedAt = nil,
      appliedAt = nil,
      notes = "Effects are prepared state-only and do not execute live framework actions."
    },
    executionPlan = buildExecutionPlan(candidate.type),
    executionHooks = buildReservedExecutionHooks(candidate.type),
    stateOnly = true,
    spawnHooks = "reserved",
    createdAt = now,
    updatedAt = now
  }

  return missionRecord
end

local function candidateHasDuplicateMission(state, candidate)
  if state == nil or state.Missions == nil or type(candidate) ~= "table" then
    return false
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
    if type(container) == "table" then
      for _, missionRecord in pairs(container) do
        if type(missionRecord) == "table" then
          if missionRecord.candidateKey == candidate.candidateKey then
            return true
          end

          if missionRecord.type == candidate.type
            and missionRecord.targetKey ~= nil
            and missionRecord.targetKey == candidate.targetKey then
            return true
          end
        end
      end
    end
  end

  return false
end

local function addMissionToContainer(state, missionRecord, status)
  if state == nil or missionRecord == nil then
    return false
  end

  local container = getMissionContainerForStatus(state, status or missionRecord.status)
  removeMissionFromAllContainers(state, missionRecord.key)
  container[missionRecord.key] = missionRecord

  return true
end

local function collectCandidates()
  local zoneCandidates = buildZoneCandidates()
  local fobCandidates = buildFobCandidates()
  local candidates = {}

  for _, candidate in ipairs(zoneCandidates) do
    table.insert(candidates, candidate)
  end

  for _, candidate in ipairs(fobCandidates) do
    table.insert(candidates, candidate)
  end

  sortCandidates(candidates)

  MissionGenerator.lastCandidateCount = #candidates
  MissionGenerator.lastFobCandidateCount = #fobCandidates

  return candidates, fobCandidates
end

local function createMissionsFromCandidates(candidates, fobCandidates, generationLimit)
  local state = ensureMissionState()
  if state == nil then
    return false, "state_unavailable"
  end

  local limit = generationLimit or MissionGenerator.defaultGenerationLimit
  local created = 0
  local duplicateSkipped = 0
  local limitSkipped = 0
  local reservedCreated = 0
  local createdByType = {}
  local reservedKeys = {}

  if #fobCandidates > 0 and MissionGenerator.minimumFobSupportMissions > 0 then
    sortCandidates(fobCandidates)

    for _, fobCandidate in ipairs(fobCandidates) do
      if reservedCreated >= MissionGenerator.minimumFobSupportMissions then
        break
      end
      if created >= limit then
        break
      end

      if candidateHasDuplicateMission(state, fobCandidate) == true then
        duplicateSkipped = duplicateSkipped + 1
      else
        local missionRecord = buildMissionRecord(fobCandidate)
        if missionRecord ~= nil then
          addMissionToContainer(state, missionRecord, getStatusAvailable())
          created = created + 1
          reservedCreated = reservedCreated + 1
          createdByType[fobCandidate.type] = (createdByType[fobCandidate.type] or 0) + 1
          reservedKeys[fobCandidate.candidateKey] = true
        end
      end
    end
  end

  for _, candidate in ipairs(candidates) do
    if created >= limit then
      limitSkipped = limitSkipped + 1
    else
      local typeCount = createdByType[candidate.type] or 0
      local typeLimit = MissionGenerator.maxPerGenerationByType[candidate.type] or limit

      if reservedKeys[candidate.candidateKey] == true then
        duplicateSkipped = duplicateSkipped + 1
      elseif candidateHasDuplicateMission(state, candidate) == true then
        duplicateSkipped = duplicateSkipped + 1
      elseif typeCount >= typeLimit then
        limitSkipped = limitSkipped + 1
      else
        local missionRecord = buildMissionRecord(candidate)
        if missionRecord ~= nil then
          addMissionToContainer(state, missionRecord, getStatusAvailable())
          created = created + 1
          createdByType[candidate.type] = typeCount + 1
        end
      end
    end
  end

  local now = getCurrentTime()

  MissionGenerator.lastCreatedCount = created
  MissionGenerator.lastSkippedDuplicateCount = duplicateSkipped
  MissionGenerator.lastSkippedLimitCount = limitSkipped
  MissionGenerator.lastReservedCreatedCount = reservedCreated
  MissionGenerator.lastGenerationTime = now

  state.Missions.lastGenerationTime = now
  state.Missions.statistics.lastCreated = created
  state.Missions.statistics.lastCandidates = MissionGenerator.lastCandidateCount
  state.Missions.statistics.lastFobCandidates = MissionGenerator.lastFobCandidateCount
  state.Missions.statistics.lastReservedCreated = reservedCreated
  state.Missions.statistics.lastDuplicatesSkipped = duplicateSkipped
  state.Missions.statistics.lastLimitSkipped = limitSkipped

  table.insert(state.Missions.generationHistory, {
    time = now,
    candidates = MissionGenerator.lastCandidateCount,
    fobCandidates = MissionGenerator.lastFobCandidateCount,
    created = created,
    reservedCreated = reservedCreated,
    duplicateSkipped = duplicateSkipped,
    limitSkipped = limitSkipped,
    stateOnly = true
  })

  updateStatistics()
  markDirty("mission_generation")

  return true
end

local function getMissionFromContainer(container, missionKey)
  if type(container) ~= "table" or missionKey == nil then
    return nil
  end

  if container[missionKey] ~= nil then
    return container[missionKey]
  end

  for _, missionRecord in pairs(container) do
    if type(missionRecord) == "table" then
      if missionRecord.key == missionKey then
        return missionRecord
      end
      if missionRecord.name == missionKey then
        return missionRecord
      end
      if missionRecord.displayName == missionKey then
        return missionRecord
      end
    end
  end

  return nil
end

local function findMissionByKey(missionKey)
  local state = ensureMissionState()
  if state == nil then
    return nil, nil
  end

  local containers = {
    { status = getStatusAvailable(), container = state.Missions.available },
    { status = getStatusActive(), container = state.Missions.active },
    { status = getStatusCompleted(), container = state.Missions.completed },
    { status = getStatusFailed(), container = state.Missions.failed },
    { status = getStatusExpired(), container = state.Missions.expired },
    { status = getStatusCancelled(), container = state.Missions.cancelled }
  }

  for _, entry in ipairs(containers) do
    local missionRecord = getMissionFromContainer(entry.container, missionKey)
    if missionRecord ~= nil then
      return missionRecord, entry.status
    end
  end

  return nil, nil
end

local function prepareMissionEffectState(missionRecord, finalStatus, reason)
  if type(missionRecord) ~= "table" then
    return nil
  end

  local now = getCurrentTime()
  local effect = copyValue(missionRecord.effect or {})

  local preparedEffects = {
    status = MissionGenerator.effectStatus.PREPARED,
    prepared = true,
    applied = false,
    stateOnly = true,
    preparedAt = now,
    appliedAt = nil,
    finalStatus = finalStatus,
    reason = reason,
    sourceMissionKey = missionRecord.key,
    sourceMissionType = missionRecord.type,
    targetKey = missionRecord.targetKey,
    targetZoneKey = missionRecord.targetZoneKey,
    targetBaseKey = missionRecord.targetBaseKey,
    targetFobKey = missionRecord.targetFobKey,
    capture = {
      status = "PREPARED",
      stateOnly = true,
      applied = false,
      pressure = effect.capturePressure or effect.captureProgress or effect.airbasePressure or 0,
      targetZoneKey = missionRecord.targetZoneKey,
      targetBaseKey = missionRecord.targetBaseKey
    },
    logistics = {
      status = "PREPARED",
      stateOnly = true,
      applied = false,
      supply = effect.supply or 0,
      fuel = effect.fuel or 0,
      ammunition = effect.ammunition or 0,
      engineering = effect.engineering or 0,
      fobConstruction = effect.fobConstruction or 0,
      targetFobKey = missionRecord.targetFobKey,
      targetZoneKey = missionRecord.targetZoneKey
    },
    ai = {
      status = "PREPARED",
      stateOnly = true,
      applied = false,
      airControl = effect.airControl or 0,
      aiPressure = effect.aiPressure or 0,
      targetZoneKey = missionRecord.targetZoneKey
    },
    iads = {
      status = "PREPARED",
      stateOnly = true,
      applied = false,
      suppressionPressure = effect.iadsSuppressionPressure or effect.airDefenseSuppression or 0,
      destructionPressure = effect.airDefenseDestruction or 0,
      targetZoneKey = missionRecord.targetZoneKey
    },
    rawEffect = effect,
    notes = "Prepared only. No real MOOSE, CTLD or Skynet action executed."
  }

  missionRecord.effectState = preparedEffects
  missionRecord.effectsPrepared = true
  missionRecord.updatedAt = now

  MissionGenerator.lastEffectPreparationTime = now
  MissionGenerator.lastPreparedEffectMissionKey = missionRecord.key

  local state = ensureMissionState()
  if state ~= nil then
    state.Missions.lastEffectPreparationTime = now
    state.Missions.lastPreparedEffectMissionKey = missionRecord.key
    state.Missions.statistics.preparedEffects = (state.Missions.statistics.preparedEffects or 0) + 1
    state.Missions.statistics.lastPreparedEffectMissionKey = missionRecord.key
    state.Missions.statistics.lastEffectPreparationTime = now

    table.insert(state.Missions.effectHistory, {
      time = now,
      missionKey = missionRecord.key,
      missionType = missionRecord.type,
      finalStatus = finalStatus,
      targetKey = missionRecord.targetKey,
      targetZoneKey = missionRecord.targetZoneKey,
      targetBaseKey = missionRecord.targetBaseKey,
      targetFobKey = missionRecord.targetFobKey,
      status = MissionGenerator.effectStatus.PREPARED,
      stateOnly = true
    })
  end

  logInfo("Mission effects prepared state-only: " .. tostring(missionRecord.key) .. " status=" .. tostring(finalStatus))

  return preparedEffects
end

local function transitionMissionToStatus(missionKey, finalStatus, outcomeStatus, reason)
  local state = ensureMissionState()
  if state == nil then
    return false, "state_unavailable"
  end

  local missionRecord = nil
  local currentStatus = nil

  missionRecord, currentStatus = findMissionByKey(missionKey)

  if missionRecord == nil then
    return false, "mission_not_found"
  end

  if isFinalStatus(currentStatus) == true or isFinalStatus(missionRecord.status) == true then
    return false, "mission_already_final"
  end

  local now = getCurrentTime()

  missionRecord.status = finalStatus
  missionRecord.updatedAt = now
  missionRecord.progress = missionRecord.progress or buildProgress()
  missionRecord.progress.updatedAt = now
  missionRecord.progress.stateOnly = true

  missionRecord.outcome = missionRecord.outcome or {}
  missionRecord.outcome.status = outcomeStatus
  missionRecord.outcome.reason = reason or "manual_state_only_outcome"
  missionRecord.outcome.stateOnly = true

  if finalStatus == getStatusCompleted() or finalStatus == MissionGenerator.status.COMPLETED then
    missionRecord.progress.stage = MissionGenerator.progressStage.COMPLETED
    missionRecord.progress.percent = 100
    missionRecord.progress.completedAt = now
    missionRecord.outcome.completedAt = now
    MissionGenerator.lastCompletedMissionKey = missionRecord.key
    state.Missions.lastCompletedMissionKey = missionRecord.key
  elseif finalStatus == getStatusFailed() or finalStatus == MissionGenerator.status.FAILED then
    missionRecord.progress.stage = MissionGenerator.progressStage.FAILED
    missionRecord.progress.failedAt = now
    missionRecord.outcome.failedAt = now
    MissionGenerator.lastFailedMissionKey = missionRecord.key
    state.Missions.lastFailedMissionKey = missionRecord.key
  elseif finalStatus == getStatusCancelled() or finalStatus == MissionGenerator.status.CANCELLED then
    missionRecord.progress.stage = MissionGenerator.progressStage.CANCELLED
    missionRecord.outcome.cancelledAt = now
  elseif finalStatus == getStatusExpired() or finalStatus == MissionGenerator.status.EXPIRED then
    missionRecord.progress.stage = MissionGenerator.progressStage.EXPIRED
    missionRecord.outcome.expiredAt = now
  end

  prepareMissionEffectState(missionRecord, finalStatus, reason)

  removeMissionFromAllContainers(state, missionRecord.key)
  addMissionToContainer(state, missionRecord, finalStatus)

  MissionGenerator.lastOutcomeTime = now
  state.Missions.lastOutcomeTime = now

  table.insert(state.Missions.outcomeHistory, {
    time = now,
    missionKey = missionRecord.key,
    previousStatus = currentStatus,
    finalStatus = finalStatus,
    outcome = outcomeStatus,
    reason = reason or "manual_state_only_outcome",
    stateOnly = true,
    effectsPrepared = true
  })

  updateStatistics()
  markDirty("mission_outcome_" .. tostring(finalStatus))

  logInfo("Mission outcome prepared: " .. tostring(missionRecord.key) .. " [" .. tostring(finalStatus) .. "] stateOnly=true effects=prepared")

  return true, missionRecord
end

function MissionGenerator.generateMissions(generationLimit)
  local state = ensureMissionState()
  if state == nil then
    return false, "state_unavailable"
  end

  local availableBefore = countTableKeys(state.Missions.available)
  local candidates, fobCandidates = collectCandidates()

  logInfo(
    "Mission candidate summary: candidates="
      .. tostring(#candidates)
      .. ", fobSupportCandidates="
      .. tostring(#fobCandidates)
      .. ", availableBefore="
      .. tostring(availableBefore)
      .. ", generationSlots="
      .. tostring(generationLimit or MissionGenerator.defaultGenerationLimit)
  )

  local success, reason = createMissionsFromCandidates(candidates, fobCandidates, generationLimit)
  if success ~= true then
    return false, reason
  end

  logInfo(
    "Mission generation completed: "
      .. tostring(MissionGenerator.lastCreatedCount)
      .. " new missions from "
      .. tostring(MissionGenerator.lastCandidateCount)
      .. " candidates (fobSupportCandidates="
      .. tostring(MissionGenerator.lastFobCandidateCount)
      .. ", reservedCreated="
      .. tostring(MissionGenerator.lastReservedCreatedCount)
      .. ", duplicatesSkipped="
      .. tostring(MissionGenerator.lastSkippedDuplicateCount)
      .. ", typeLimitSkipped="
      .. tostring(MissionGenerator.lastSkippedLimitCount)
      .. ")"
  )

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

function MissionGenerator.getMissionByKey(missionKey)
  local missionRecord = nil
  missionRecord = findMissionByKey(missionKey)
  return missionRecord
end

function MissionGenerator.getTopAvailableMission()
  local state = ensureMissionState()
  if state == nil then
    return nil
  end

  local topMission = nil

  for _, missionRecord in pairs(state.Missions.available) do
    if type(missionRecord) == "table" then
      if topMission == nil then
        topMission = missionRecord
      else
        local missionPriority = tonumber(missionRecord.priority) or 0
        local topPriority = tonumber(topMission.priority) or 0
        local missionRelevance = tonumber(missionRecord.strategicRelevance) or 0
        local topRelevance = tonumber(topMission.strategicRelevance) or 0

        if missionPriority > topPriority then
          topMission = missionRecord
        elseif missionPriority == topPriority and missionRelevance > topRelevance then
          topMission = missionRecord
        elseif missionPriority == topPriority
          and missionRelevance == topRelevance
          and tostring(missionRecord.key or "") < tostring(topMission.key or "") then
          topMission = missionRecord
        end
      end
    end
  end

  return topMission
end

function MissionGenerator.activateMission(missionKey, activationReason)
  local state = ensureMissionState()
  if state == nil then
    return false, "state_unavailable"
  end

  local missionRecord = getMissionFromContainer(state.Missions.available, missionKey)
  if missionRecord == nil then
    return false, "mission_not_available"
  end

  local now = getCurrentTime()

  missionRecord.status = getStatusActive()
  missionRecord.updatedAt = now
  missionRecord.progress = missionRecord.progress or buildProgress()
  missionRecord.progress.stage = MissionGenerator.progressStage.ACTIVE
  missionRecord.progress.percent = clamp(missionRecord.progress.percent or 0, 0, 100)
  missionRecord.progress.startedAt = missionRecord.progress.startedAt or now
  missionRecord.progress.updatedAt = now
  missionRecord.progress.stateOnly = true

  missionRecord.activation = missionRecord.activation or {}
  missionRecord.activation.activated = true
  missionRecord.activation.activatedAt = now
  missionRecord.activation.activatedBy = "F10_OR_SYSTEM"
  missionRecord.activation.activationReason = activationReason or "manual_state_only_activation"
  missionRecord.activation.stateOnly = true

  missionRecord.executionPlan = missionRecord.executionPlan or buildExecutionPlan(missionRecord.type)
  missionRecord.executionPlan.mode = MissionGenerator.executionMode.STATE_ONLY
  missionRecord.executionPlan.stateOnly = true
  missionRecord.executionPlan.liveExecution = false
  missionRecord.executionPlan.frameworkExecution = false

  missionRecord.stateOnly = true
  missionRecord.spawnHooks = "reserved"

  removeMissionFromAllContainers(state, missionRecord.key)
  state.Missions.active[missionRecord.key] = missionRecord

  MissionGenerator.lastActivationTime = now
  MissionGenerator.lastActivatedMissionKey = missionRecord.key
  state.Missions.lastActivationTime = now
  state.Missions.lastActivatedMissionKey = missionRecord.key

  table.insert(state.Missions.activationHistory, {
    time = now,
    missionKey = missionRecord.key,
    missionType = missionRecord.type,
    reason = activationReason or "manual_state_only_activation",
    stateOnly = true,
    spawnHooks = "reserved"
  })

  updateStatistics()
  markDirty("mission_activated")

  logInfo("Mission status changed: " .. tostring(missionRecord.key) .. " [ACTIVE]")
  logInfo("Mission activation prepared: " .. tostring(missionRecord.key) .. " stateOnly=true spawnHooks=reserved")

  return true, missionRecord
end

function MissionGenerator.updateMissionProgress(missionKey, percent, stage, reason)
  local missionRecord = nil
  missionRecord = findMissionByKey(missionKey)

  if missionRecord == nil then
    return false, "mission_not_found"
  end

  local now = getCurrentTime()

  missionRecord.progress = missionRecord.progress or buildProgress()
  missionRecord.progress.percent = clamp(percent or missionRecord.progress.percent or 0, 0, 100)
  missionRecord.progress.stage = stage or missionRecord.progress.stage or MissionGenerator.progressStage.IN_PROGRESS
  missionRecord.progress.updatedAt = now
  missionRecord.progress.reason = reason or missionRecord.progress.reason
  missionRecord.progress.stateOnly = true
  missionRecord.updatedAt = now

  updateStatistics()
  markDirty("mission_progress_updated")

  logInfo(
    "Mission progress updated: "
      .. tostring(missionRecord.key)
      .. " percent="
      .. tostring(missionRecord.progress.percent)
      .. " stage="
      .. tostring(missionRecord.progress.stage)
  )

  return true, missionRecord
end

function MissionGenerator.completeMission(missionKey, reason)
  return transitionMissionToStatus(
    missionKey,
    getStatusCompleted(),
    MissionGenerator.outcome.SUCCESS,
    reason or "manual_state_only_completion"
  )
end

function MissionGenerator.failMission(missionKey, reason)
  return transitionMissionToStatus(
    missionKey,
    getStatusFailed(),
    MissionGenerator.outcome.FAILURE,
    reason or "manual_state_only_failure"
  )
end

function MissionGenerator.cancelMission(missionKey, reason)
  return transitionMissionToStatus(
    missionKey,
    getStatusCancelled(),
    MissionGenerator.outcome.CANCELLED,
    reason or "manual_state_only_cancelled"
  )
end

function MissionGenerator.expireMission(missionKey, reason)
  return transitionMissionToStatus(
    missionKey,
    getStatusExpired(),
    MissionGenerator.outcome.EXPIRED,
    reason or "manual_state_only_expired"
  )
end

function MissionGenerator.prepareMissionEffects(missionKey, reason)
  local missionRecord = nil
  missionRecord = findMissionByKey(missionKey)

  if missionRecord == nil then
    return false, "mission_not_found"
  end

  local effectState = prepareMissionEffectState(
    missionRecord,
    missionRecord.status or "UNKNOWN",
    reason or "manual_state_only_effect_preparation"
  )

  updateStatistics()
  markDirty("mission_effects_prepared")

  return true, effectState
end

function MissionGenerator.applyMissionCompletionEffect(missionKey, reason)
  local missionRecord = nil
  missionRecord = findMissionByKey(missionKey)

  if missionRecord == nil then
    return false, "mission_not_found"
  end

  local effectState = prepareMissionEffectState(
    missionRecord,
    missionRecord.status or "UNKNOWN",
    reason or "manual_state_only_effect_preparation"
  )

  missionRecord.effectState = missionRecord.effectState or effectState
  missionRecord.effectState.status = MissionGenerator.effectStatus.PREPARED
  missionRecord.effectState.applied = false
  missionRecord.effectState.stateOnly = true
  missionRecord.effectState.notes = "Prepared by applyMissionCompletionEffect. No CaptureSystem, CTLD, MOOSE or Skynet live action executed."

  updateStatistics()
  markDirty("mission_completion_effect_prepared")

  return true, missionRecord.effectState
end

function MissionGenerator.getMissionBriefing(missionKey)
  local missionRecord = nil
  missionRecord = findMissionByKey(missionKey)

  if missionRecord == nil then
    return nil
  end

  return missionRecord.briefing
end

function MissionGenerator.getMissionProgress(missionKey)
  local missionRecord = nil
  missionRecord = findMissionByKey(missionKey)

  if missionRecord == nil then
    return nil
  end

  return missionRecord.progress
end

function MissionGenerator.getMissionOutcome(missionKey)
  local missionRecord = nil
  missionRecord = findMissionByKey(missionKey)

  if missionRecord == nil then
    return nil
  end

  return missionRecord.outcome
end

function MissionGenerator.getStatistics()
  updateStatistics()

  local state = ensureMissionState()
  if state == nil then
    return {}
  end

  return state.Missions.statistics
end

function MissionGenerator.start()
  if MissionGenerator.started == true and MissionGenerator.finished == true and MissionGenerator.failed ~= true then
    logDebug("Mission generator already started")
    return true
  end

  MissionGenerator.started = true
  MissionGenerator.finished = false
  MissionGenerator.failed = false

  setModuleStatus("STARTING")
  setFeatureStatus(false)

  logInfo("Mission generator started")

  local state = ensureMissionState()
  if state == nil then
    MissionGenerator.failed = true
    setModuleStatus("FAILED")
    setFeatureStatus(false)
    logError("Mission generator failed: state_unavailable")
    return false
  end

  local success, reason = MissionGenerator.generateMissions(MissionGenerator.defaultGenerationLimit)
  if success ~= true then
    MissionGenerator.failed = true
    setModuleStatus("FAILED")
    setFeatureStatus(false)
    logError("Mission generator failed: " .. tostring(reason))
    return false
  end

  MissionGenerator.finished = true
  MissionGenerator.failed = false

  setModuleStatus("READY")
  setFeatureStatus(true)

  logInfo("Mission generator ready")

  return true
end

function MissionGenerator.stop()
  MissionGenerator.started = false
  MissionGenerator.finished = false

  setModuleStatus("STOPPED")
  setFeatureStatus(false)

  logInfo("Mission generator stopped")

  return true
end

function MissionGenerator.summary()
  local state = ensureMissionState()
  local statistics = {}
  local missionState = nil

  if state ~= nil then
    updateStatistics()
    statistics = copyValue(state.Missions.statistics)
    missionState = {
      available = countTableKeys(state.Missions.available),
      active = countTableKeys(state.Missions.active),
      completed = countTableKeys(state.Missions.completed),
      failed = countTableKeys(state.Missions.failed),
      expired = countTableKeys(state.Missions.expired),
      cancelled = countTableKeys(state.Missions.cancelled),
      lastMissionId = state.Missions.lastMissionId,
      lastActivatedMissionKey = state.Missions.lastActivatedMissionKey,
      lastCompletedMissionKey = state.Missions.lastCompletedMissionKey,
      lastFailedMissionKey = state.Missions.lastFailedMissionKey,
      lastPreparedEffectMissionKey = state.Missions.lastPreparedEffectMissionKey
    }
  end

  return {
    name = MissionGenerator.name,
    displayName = MissionGenerator.displayName,
    path = MissionGenerator.path,
    version = MissionGenerator.version,
    loaded = MissionGenerator.loaded,
    started = MissionGenerator.started,
    finished = MissionGenerator.finished,
    failed = MissionGenerator.failed,
    lastGenerationTime = MissionGenerator.lastGenerationTime,
    lastCandidateCount = MissionGenerator.lastCandidateCount,
    lastCreatedCount = MissionGenerator.lastCreatedCount,
    lastSkippedDuplicateCount = MissionGenerator.lastSkippedDuplicateCount,
    lastSkippedLimitCount = MissionGenerator.lastSkippedLimitCount,
    lastReservedCreatedCount = MissionGenerator.lastReservedCreatedCount,
    lastFobCandidateCount = MissionGenerator.lastFobCandidateCount,
    lastActivationTime = MissionGenerator.lastActivationTime,
    lastActivatedMissionKey = MissionGenerator.lastActivatedMissionKey,
    lastOutcomeTime = MissionGenerator.lastOutcomeTime,
    lastCompletedMissionKey = MissionGenerator.lastCompletedMissionKey,
    lastFailedMissionKey = MissionGenerator.lastFailedMissionKey,
    lastEffectPreparationTime = MissionGenerator.lastEffectPreparationTime,
    lastPreparedEffectMissionKey = MissionGenerator.lastPreparedEffectMissionKey,
    statistics = statistics,
    state = missionState
  }
end

TC.Missions.Generator = MissionGenerator
TC.missions.Generator = MissionGenerator

TC.modules.missionGenerator = {
  name = MissionGenerator.name,
  path = MissionGenerator.path,
  loaded = true,
  version = MissionGenerator.version
}

setModuleStatus("LOADED")
logInfo("Loaded " .. MissionGenerator.path .. " v" .. MissionGenerator.version)

return MissionGenerator
