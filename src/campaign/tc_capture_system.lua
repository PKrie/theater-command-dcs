-- Theater Command DCS
-- File: src/campaign/tc_capture_system.lua
--
-- Purpose:
-- Strategic ownership, capture pressure and capture state management.
--
-- Current focus:
-- MissionGenerator v0.2.2 can activate missions state-only and stores
-- mission effects, progress and reserved execution hooks. The Capture System
-- now accepts mission effects as capture pressure and tracks zone progress
-- without triggering real MOOSE, CTLD, Skynet or persistence execution.
--
-- Version:
-- 0.2.1
--
-- Responsibilities:
-- - manage base and zone ownership
-- - restrict capture logic to strategic and secondary campaign objectives
-- - prevent medical pads, helipads, tactical pads and unknown objects from
--   becoming strategic capture targets
-- - keep linked airbase and zone ownership synchronized
-- - store capture events for persistence, debug and later AI reactions
-- - expose filtered capture target lists for missions, AI and UI
-- - store capture pressure per zone and owner
-- - convert completed mission effects into state-only capture pressure
-- - track capture progress and contested zones
-- - prepare completion hooks without executing live spawns
--
-- Vendor note:
-- This file does not directly call MIST, MOOSE, CTLD or Skynet IADS.
-- It consumes Theater Command state produced by World, Mission and Logistics
-- systems. All capture changes remain state-only.

TC = TC or {}
TC.modules = TC.modules or {}
TC.Campaign = TC.Campaign or {}
TC.campaign = TC.campaign or TC.Campaign

local CaptureSystem = {}

CaptureSystem.name = "tc_capture_system"
CaptureSystem.displayName = "Capture System"
CaptureSystem.path = "src/campaign/tc_capture_system.lua"
CaptureSystem.version = "0.2.1"

CaptureSystem.loaded = true
CaptureSystem.started = false
CaptureSystem.finished = false
CaptureSystem.failed = false

CaptureSystem.lastUpdateTime = 0
CaptureSystem.captureEvents = {}
CaptureSystem.lastEligibilitySummary = nil
CaptureSystem.lastPressureSummary = nil
CaptureSystem.lastMissionEffectSummary = nil

CaptureSystem.defaultCaptureThreshold = 100
CaptureSystem.defaultContestedThreshold = 25
CaptureSystem.defaultDecayPerUpdate = 0

CaptureSystem.captureClasses = {
    STRATEGIC_AIRFIELD = "STRATEGIC_AIRFIELD",
    SECONDARY_AIRFIELD = "SECONDARY_AIRFIELD",
    STRATEGIC_AIRBASE_ZONE = "STRATEGIC_AIRBASE_ZONE",
    SECONDARY_AIRBASE_ZONE = "SECONDARY_AIRBASE_ZONE",
    MISSION_EDITOR_CAPTURE_ZONE = "MISSION_EDITOR_CAPTURE_ZONE"
}

CaptureSystem.excludedAirbaseClassifications = {
    HELIPORT = true,
    HELIPAD = true,
    MEDICAL_PAD = true,
    FARP = true,
    TACTICAL_PAD = true,
    UNKNOWN = true
}

CaptureSystem.excludedZoneClasses = {
    HELIPORT_ZONE = true,
    HELIPAD_ZONE = true,
    MEDICAL_PAD_ZONE = true,
    FARP_ZONE = true,
    TACTICAL_PAD_ZONE = true,
    UNKNOWN_ZONE = true,
    UNKNOWN_AIRBASE_OBJECT_ZONE = true
}

CaptureSystem.pressureSources = {
    MANUAL = "MANUAL",
    MISSION_EFFECT = "MISSION_EFFECT",
    MISSION_COMPLETED = "MISSION_COMPLETED",
    AI_DIRECTOR = "AI_DIRECTOR",
    LOGISTICS = "LOGISTICS",
    SYSTEM = "SYSTEM"
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
    local formatted = "[TC][CAPTURE_SYSTEM] " .. tostring(message)

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
        logger.info("[CaptureSystem] " .. tostring(message))
        return
    end

    rawLog("INFO", message)
end

local function logWarn(message)
    local logger = getLogger()

    if logger ~= nil and logger.warn ~= nil then
        logger.warn("[CaptureSystem] " .. tostring(message))
        return
    end

    rawLog("WARN", message)
end

local function logError(message)
    local logger = getLogger()

    if logger ~= nil and logger.error ~= nil then
        logger.error("[CaptureSystem] " .. tostring(message))
        return
    end

    rawLog("ERROR", message)
end

local function logDebug(message)
    local logger = getLogger()

    if logger ~= nil and logger.debug ~= nil then
        logger.debug("[CaptureSystem] " .. tostring(message))
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

local function isValidOwner(owner)
    return owner == getOwnerBlue()
        or owner == getOwnerRed()
        or owner == getOwnerNeutral()
        or owner == getOwnerContested()
        or owner == getOwnerUnknown()
end

local function getRecordOwner(record)
    if type(record) ~= "table" then
        return getOwnerUnknown()
    end

    return record.currentOwner or record.initialOwner or record.owner or getOwnerUnknown()
end

local function ensureCampaignTables()
    local state = getState()

    TC.Campaign = TC.Campaign or {}
    TC.campaign = TC.Campaign

    if state == nil then
        return nil
    end

    state.Campaign = state.Campaign or {}
    state.Campaign.capture = state.Campaign.capture or {}

    state.Campaign.capture.enabled = true
    state.Campaign.capture.initialized = state.Campaign.capture.initialized == true
    state.Campaign.capture.lastUpdateTime = state.Campaign.capture.lastUpdateTime or 0

    state.Campaign.capture.captureEligibleBases = state.Campaign.capture.captureEligibleBases or {}
    state.Campaign.capture.captureEligibleZones = state.Campaign.capture.captureEligibleZones or {}
    state.Campaign.capture.nonCaptureBases = state.Campaign.capture.nonCaptureBases or {}
    state.Campaign.capture.nonCaptureZones = state.Campaign.capture.nonCaptureZones or {}

    state.Campaign.capture.events = state.Campaign.capture.events or {}
    state.Campaign.capture.statistics = state.Campaign.capture.statistics or {}

    state.Campaign.capture.pressure = state.Campaign.capture.pressure or {}
    state.Campaign.capture.progress = state.Campaign.capture.progress or {}
    state.Campaign.capture.missionEffects = state.Campaign.capture.missionEffects or {}
    state.Campaign.capture.appliedMissionEffects = state.Campaign.capture.appliedMissionEffects or {}
    state.Campaign.capture.completionHooks = state.Campaign.capture.completionHooks or {}

    state.Campaign.capture.thresholds = state.Campaign.capture.thresholds or {}
    state.Campaign.capture.thresholds.capture = state.Campaign.capture.thresholds.capture or CaptureSystem.defaultCaptureThreshold
    state.Campaign.capture.thresholds.contested = state.Campaign.capture.thresholds.contested or CaptureSystem.defaultContestedThreshold
    state.Campaign.capture.thresholds.decayPerUpdate = state.Campaign.capture.thresholds.decayPerUpdate or CaptureSystem.defaultDecayPerUpdate

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

local function getMissionGenerator()
    if TC.Missions == nil then
        return nil
    end

    return TC.Missions.Generator
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

local function setModuleStatus(status)
    local state = getState()

    if state ~= nil and state.setModuleStatus ~= nil then
        state.setModuleStatus("captureSystem", status)
    end
end

local function setFeatureStatus(enabled)
    local state = getState()

    if state ~= nil and state.setFeatureStatus ~= nil then
        state.setFeatureStatus("captureSystem", enabled == true)
    end
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
    if type(registry) ~= "table" or keyOrName == nil then
        return nil, nil
    end

    if registry[keyOrName] ~= nil then
        return registry[keyOrName], keyOrName
    end

    local normalizedSearch = normalizeName(keyOrName)

    for key, record in pairs(registry) do
        if type(record) == "table" then
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
    end

    return nil, nil
end

local function getAirbaseClassification(record)
    if type(record) ~= "table" then
        return "UNKNOWN"
    end

    if record.classification ~= nil then
        return record.classification
    end

    if record.airbaseType ~= nil then
        return record.airbaseType
    end

    if record.airbaseClassification ~= nil then
        return record.airbaseClassification
    end

    if record.isStrategicAirfield == true then
        return "STRATEGIC_AIRFIELD"
    end

    if record.isSecondaryAirfield == true then
        return "SECONDARY_AIRFIELD"
    end

    if record.isHeliport == true then
        return "HELIPORT"
    end

    if record.isHelipad == true then
        return "HELIPAD"
    end

    if record.isMedicalPad == true then
        return "MEDICAL_PAD"
    end

    if record.isFarp == true then
        return "FARP"
    end

    if record.isTacticalPad == true then
        return "TACTICAL_PAD"
    end

    return "UNKNOWN"
end

local function getZoneClass(record)
    if type(record) ~= "table" then
        return "UNKNOWN_ZONE"
    end

    return record.zoneClass or record.recommendedZoneClass or "UNKNOWN_ZONE"
end

local function isStrategicOrSecondaryAirbase(record)
    local classification = getAirbaseClassification(record)

    return classification == "STRATEGIC_AIRFIELD"
        or classification == "SECONDARY_AIRFIELD"
end

local function isStrategicOrSecondaryZone(record)
    local zoneClass = getZoneClass(record)
    local classification = getAirbaseClassification(record)

    if zoneClass == CaptureSystem.captureClasses.STRATEGIC_AIRBASE_ZONE then
        return true
    end

    if zoneClass == CaptureSystem.captureClasses.SECONDARY_AIRBASE_ZONE then
        return true
    end

    if classification == CaptureSystem.captureClasses.STRATEGIC_AIRFIELD then
        return true
    end

    if classification == CaptureSystem.captureClasses.SECONDARY_AIRFIELD then
        return true
    end

    return false
end

local function isExcludedBaseCaptureTarget(record)
    local classification = getAirbaseClassification(record)

    if CaptureSystem.excludedAirbaseClassifications[classification] == true then
        return true
    end

    if record.isHelipad == true
        or record.isMedicalPad == true
        or record.isFarp == true
        or record.isTacticalPad == true
        or record.isUnknownAirbaseObject == true then
        return true
    end

    return false
end

local function isExcludedZoneCaptureTarget(record)
    local zoneClass = getZoneClass(record)
    local classification = getAirbaseClassification(record)

    if CaptureSystem.excludedZoneClasses[zoneClass] == true then
        return true
    end

    if CaptureSystem.excludedAirbaseClassifications[classification] == true then
        return true
    end

    return false
end

local function canCaptureBaseRecord(record)
    if type(record) ~= "table" then
        return false, "invalid_base_record"
    end

    if isExcludedBaseCaptureTarget(record) == true then
        return false, "excluded_airbase_classification"
    end

    if record.isCaptureCandidate == true then
        return true, "airbase_capture_candidate"
    end

    if record.canCreateCaptureZone == true then
        return true, "airbase_capture_zone_capable"
    end

    if isStrategicOrSecondaryAirbase(record) == true then
        return true, "strategic_or_secondary_airbase"
    end

    return false, "not_a_campaign_capture_base"
end

local function canCaptureZoneRecord(record)
    if type(record) ~= "table" then
        return false, "invalid_zone_record"
    end

    if isExcludedZoneCaptureTarget(record) == true then
        return false, "excluded_zone_classification"
    end

    if record.isCaptureZone == true then
        return true, "zone_capture_candidate"
    end

    if record.canCreateCaptureZone == true then
        return true, "zone_capture_capable"
    end

    if getZoneClass(record) == CaptureSystem.captureClasses.MISSION_EDITOR_CAPTURE_ZONE then
        return true, "mission_editor_capture_zone"
    end

    if isStrategicOrSecondaryZone(record) == true then
        return true, "strategic_or_secondary_zone"
    end

    return false, "not_a_campaign_capture_zone"
end

local function addOwnerCount(summary, owner)
    if owner == getOwnerBlue() then
        summary.blue = summary.blue + 1
    elseif owner == getOwnerRed() then
        summary.red = summary.red + 1
    elseif owner == getOwnerNeutral() then
        summary.neutral = summary.neutral + 1
    elseif owner == getOwnerContested() then
        summary.contested = summary.contested + 1
    else
        summary.unknown = summary.unknown + 1
    end
end

local function createOwnerSummary()
    return {
        total = 0,
        blue = 0,
        red = 0,
        neutral = 0,
        contested = 0,
        unknown = 0
    }
end

local function updateOwnerCounters(container)
    if type(container) ~= "table" then
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
        local owner = getRecordOwner(record)

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

local function ensureZonePressureRecord(zoneKey)
    local state = ensureCampaignTables()

    if state == nil or zoneKey == nil then
        return nil
    end

    state.Campaign.capture.pressure[zoneKey] = state.Campaign.capture.pressure[zoneKey] or {
        zoneKey = zoneKey,
        blue = 0,
        red = 0,
        neutral = 0,
        contested = 0,
        total = 0,
        dominantOwner = getOwnerUnknown(),
        lastSource = nil,
        lastMissionKey = nil,
        updatedAt = getCurrentTime()
    }

    return state.Campaign.capture.pressure[zoneKey]
end

local function ensureZoneProgressRecord(zoneKey)
    local state = ensureCampaignTables()

    if state == nil or zoneKey == nil then
        return nil
    end

    state.Campaign.capture.progress[zoneKey] = state.Campaign.capture.progress[zoneKey] or {
        zoneKey = zoneKey,
        owner = getOwnerUnknown(),
        previousOwner = getOwnerUnknown(),
        dominantOwner = getOwnerUnknown(),
        percent = 0,
        bluePressure = 0,
        redPressure = 0,
        neutralPressure = 0,
        contestedPressure = 0,
        threshold = state.Campaign.capture.thresholds.capture or CaptureSystem.defaultCaptureThreshold,
        contestedThreshold = state.Campaign.capture.thresholds.contested or CaptureSystem.defaultContestedThreshold,
        status = "STABLE",
        captureReady = false,
        updatedAt = getCurrentTime()
    }

    return state.Campaign.capture.progress[zoneKey]
end

local function getPressureValueForOwner(pressureRecord, owner)
    if pressureRecord == nil then
        return 0
    end

    if owner == getOwnerBlue() then
        return pressureRecord.blue or 0
    end

    if owner == getOwnerRed() then
        return pressureRecord.red or 0
    end

    if owner == getOwnerNeutral() then
        return pressureRecord.neutral or 0
    end

    if owner == getOwnerContested() then
        return pressureRecord.contested or 0
    end

    return 0
end

local function setPressureValueForOwner(pressureRecord, owner, value)
    if pressureRecord == nil then
        return false
    end

    local safeValue = clamp(value, 0, nil)

    if owner == getOwnerBlue() then
        pressureRecord.blue = safeValue
        return true
    end

    if owner == getOwnerRed() then
        pressureRecord.red = safeValue
        return true
    end

    if owner == getOwnerNeutral() then
        pressureRecord.neutral = safeValue
        return true
    end

    if owner == getOwnerContested() then
        pressureRecord.contested = safeValue
        return true
    end

    return false
end

local function updatePressureDerivedValues(zoneKey)
    local state = ensureCampaignTables()

    if state == nil or zoneKey == nil then
        return nil
    end

    local zoneRecord = state.Zones.registry[zoneKey]
    local pressureRecord = ensureZonePressureRecord(zoneKey)
    local progressRecord = ensureZoneProgressRecord(zoneKey)

    if pressureRecord == nil or progressRecord == nil then
        return nil
    end

    local bluePressure = pressureRecord.blue or 0
    local redPressure = pressureRecord.red or 0
    local neutralPressure = pressureRecord.neutral or 0
    local contestedPressure = pressureRecord.contested or 0
    local dominantOwner = getOwnerUnknown()
    local dominantPressure = 0

    if bluePressure > dominantPressure then
        dominantOwner = getOwnerBlue()
        dominantPressure = bluePressure
    end

    if redPressure > dominantPressure then
        dominantOwner = getOwnerRed()
        dominantPressure = redPressure
    end

    if neutralPressure > dominantPressure then
        dominantOwner = getOwnerNeutral()
        dominantPressure = neutralPressure
    end

    if contestedPressure > dominantPressure then
        dominantOwner = getOwnerContested()
        dominantPressure = contestedPressure
    end

    local currentOwner = zoneRecord and getRecordOwner(zoneRecord) or getOwnerUnknown()
    local threshold = state.Campaign.capture.thresholds.capture or CaptureSystem.defaultCaptureThreshold
    local contestedThreshold = state.Campaign.capture.thresholds.contested or CaptureSystem.defaultContestedThreshold
    local percent = clamp(math.floor((dominantPressure / threshold) * 100), 0, 100)

    pressureRecord.total = bluePressure + redPressure + neutralPressure + contestedPressure
    pressureRecord.dominantOwner = dominantOwner
    pressureRecord.updatedAt = getCurrentTime()

    progressRecord.owner = currentOwner
    progressRecord.previousOwner = progressRecord.previousOwner or currentOwner
    progressRecord.dominantOwner = dominantOwner
    progressRecord.percent = percent
    progressRecord.bluePressure = bluePressure
    progressRecord.redPressure = redPressure
    progressRecord.neutralPressure = neutralPressure
    progressRecord.contestedPressure = contestedPressure
    progressRecord.threshold = threshold
    progressRecord.contestedThreshold = contestedThreshold
    progressRecord.captureReady = dominantPressure >= threshold and dominantOwner ~= currentOwner
    progressRecord.updatedAt = getCurrentTime()

    if progressRecord.captureReady == true then
        progressRecord.status = "CAPTURE_READY"
    elseif dominantOwner ~= getOwnerUnknown()
        and dominantOwner ~= currentOwner
        and dominantPressure >= contestedThreshold then
        progressRecord.status = "CONTESTED"
    elseif pressureRecord.total > 0 then
        progressRecord.status = "PRESSURED"
    else
        progressRecord.status = "STABLE"
    end

    if zoneRecord ~= nil then
        zoneRecord.capturePressure = copyValue(pressureRecord)
        zoneRecord.captureProgress = copyValue(progressRecord)
        zoneRecord.updatedAt = getCurrentTime()
        syncWorldZone(zoneRecord)
    end

    return progressRecord
end

local function updateCaptureEligibility()
    local state = ensureCampaignTables()

    if state == nil then
        return nil
    end

    state.Campaign.capture.captureEligibleBases = {}
    state.Campaign.capture.captureEligibleZones = {}
    state.Campaign.capture.nonCaptureBases = {}
    state.Campaign.capture.nonCaptureZones = {}

    local baseOwnerSummary = createOwnerSummary()
    local zoneOwnerSummary = createOwnerSummary()

    for key, baseRecord in pairs(getBaseRegistry()) do
        local eligible, reason = canCaptureBaseRecord(baseRecord)

        if eligible == true then
            state.Campaign.capture.captureEligibleBases[key] = baseRecord
            baseOwnerSummary.total = baseOwnerSummary.total + 1
            addOwnerCount(baseOwnerSummary, getRecordOwner(baseRecord))
        else
            state.Campaign.capture.nonCaptureBases[key] = {
                key = baseRecord.key or key,
                name = baseRecord.name,
                classification = getAirbaseClassification(baseRecord),
                reason = reason
            }
        end
    end

    for key, zoneRecord in pairs(getZoneRegistry()) do
        local eligible, reason = canCaptureZoneRecord(zoneRecord)

        if eligible == true then
            state.Campaign.capture.captureEligibleZones[key] = zoneRecord
            zoneOwnerSummary.total = zoneOwnerSummary.total + 1
            addOwnerCount(zoneOwnerSummary, getRecordOwner(zoneRecord))
            ensureZonePressureRecord(key)
            ensureZoneProgressRecord(key)
            updatePressureDerivedValues(key)
        else
            state.Campaign.capture.nonCaptureZones[key] = {
                key = zoneRecord.key or key,
                name = zoneRecord.name,
                zoneClass = getZoneClass(zoneRecord),
                airbaseClassification = getAirbaseClassification(zoneRecord),
                reason = reason
            }
        end
    end

    state.Campaign.capture.statistics = state.Campaign.capture.statistics or {}
    state.Campaign.capture.statistics.bases = baseOwnerSummary
    state.Campaign.capture.statistics.zones = zoneOwnerSummary
    state.Campaign.capture.statistics.allBases = countTableKeys(getBaseRegistry())
    state.Campaign.capture.statistics.allZones = countTableKeys(getZoneRegistry())
    state.Campaign.capture.statistics.eligibleBases = baseOwnerSummary.total
    state.Campaign.capture.statistics.eligibleZones = zoneOwnerSummary.total
    state.Campaign.capture.statistics.nonCaptureBases = countTableKeys(state.Campaign.capture.nonCaptureBases)
    state.Campaign.capture.statistics.nonCaptureZones = countTableKeys(state.Campaign.capture.nonCaptureZones)
    state.Campaign.capture.statistics.pressureRecords = countTableKeys(state.Campaign.capture.pressure)
    state.Campaign.capture.statistics.progressRecords = countTableKeys(state.Campaign.capture.progress)
    state.Campaign.capture.statistics.appliedMissionEffects = countTableKeys(state.Campaign.capture.appliedMissionEffects)
    state.Campaign.capture.statistics.updatedAt = getCurrentTime()

    CaptureSystem.lastEligibilitySummary = state.Campaign.capture.statistics

    return state.Campaign.capture.statistics
end

local function refreshAllCounters()
    local state = ensureCampaignTables()

    if state == nil then
        return false
    end

    updateOwnerCounters(state.Bases)
    updateOwnerCounters(state.Zones)
    updateCaptureEligibility()

    CaptureSystem.lastUpdateTime = getCurrentTime()
    state.Campaign.capture.lastUpdateTime = CaptureSystem.lastUpdateTime

    return true
end

local function addCaptureEvent(eventData)
    if type(eventData) ~= "table" then
        return false
    end

    local state = ensureCampaignTables()

    eventData.id = #CaptureSystem.captureEvents + 1
    eventData.time = eventData.time or getCurrentTime()

    table.insert(CaptureSystem.captureEvents, eventData)

    if state ~= nil then
        state.Campaign.capture.events = state.Campaign.capture.events or {}
        table.insert(state.Campaign.capture.events, copyValue(eventData))
    end

    return true
end

local function setRecordOwner(record, newOwner, reason)
    if record == nil then
        return false, "record_missing", false
    end

    if isValidOwner(newOwner) ~= true then
        return false, "invalid_owner", false
    end

    local previousOwner = getRecordOwner(record)

    if previousOwner == newOwner then
        record.lastOwnerCheckAt = getCurrentTime()
        record.updatedAt = getCurrentTime()
        return true, previousOwner, false
    end

    record.previousOwner = previousOwner
    record.currentOwner = newOwner
    record.owner = newOwner
    record.captureReason = reason or "manual_capture_update"
    record.capturedAt = getCurrentTime()
    record.updatedAt = getCurrentTime()

    return true, previousOwner, true
end

local function getLinkedBaseFromZone(zoneRecord)
    if type(zoneRecord) ~= "table" then
        return nil, nil
    end

    if zoneRecord.linkedAirbaseKey == nil and zoneRecord.linkedAirbaseName == nil then
        return nil, nil
    end

    local registry = getBaseRegistry()

    if zoneRecord.linkedAirbaseKey ~= nil and registry[zoneRecord.linkedAirbaseKey] ~= nil then
        return registry[zoneRecord.linkedAirbaseKey], zoneRecord.linkedAirbaseKey
    end

    if zoneRecord.linkedAirbaseName ~= nil then
        return findRecordByKeyOrName(registry, zoneRecord.linkedAirbaseName)
    end

    return nil, nil
end

local function getLinkedZonesFromBase(baseRecord)
    local result = {}

    if type(baseRecord) ~= "table" or baseRecord.key == nil then
        return result
    end

    for key, zoneRecord in pairs(getZoneRegistry()) do
        if zoneRecord.linkedAirbaseKey == baseRecord.key then
            result[key] = zoneRecord
        end
    end

    return result
end

local function getMissionTargetZoneKey(missionRecord)
    if type(missionRecord) ~= "table" then
        return nil
    end

    if missionRecord.targetZoneKey ~= nil then
        return missionRecord.targetZoneKey
    end

    if missionRecord.targetZone ~= nil then
        return missionRecord.targetZone
    end

    if missionRecord.targetBaseKey ~= nil then
        for key, zoneRecord in pairs(getZoneRegistry()) do
            if zoneRecord.linkedAirbaseKey == missionRecord.targetBaseKey then
                return key
            end
        end
    end

    return nil
end

local function getCapturePressureFromMission(missionRecord)
    if type(missionRecord) ~= "table" then
        return 0
    end

    local effect = missionRecord.effect or {}
    local pressure = 0

    if type(effect.capturePressure) == "number" then
        pressure = pressure + effect.capturePressure
    end

    if type(effect.airbasePressure) == "number" then
        pressure = pressure + effect.airbasePressure
    end

    if type(effect.friendlyGroundSupport) == "number" then
        pressure = pressure + math.floor(effect.friendlyGroundSupport / 2)
    end

    if type(effect.logisticsDisruption) == "number" then
        pressure = pressure + math.floor(effect.logisticsDisruption / 2)
    end

    if type(effect.iadsSuppressionPressure) == "number" then
        pressure = pressure + math.floor(effect.iadsSuppressionPressure / 2)
    end

    if pressure <= 0 then
        if missionRecord.type == "AIRBASE_ATTACK" then
            pressure = 20
        elseif missionRecord.type == "STRIKE" then
            pressure = 12
        elseif missionRecord.type == "CAS" then
            pressure = 15
        elseif missionRecord.type == "SEAD" or missionRecord.type == "DEAD" or missionRecord.type == "IADS_SUPPRESSION" then
            pressure = 10
        elseif missionRecord.type == "INTERDICTION" then
            pressure = 10
        elseif missionRecord.type == "RECON" then
            pressure = 5
        elseif missionRecord.type == "FOB_SUPPORT" or missionRecord.type == "LOGISTICS" then
            pressure = 5
        end
    end

    return clamp(pressure, 0, nil)
end

local function getMissionPressureOwner(missionRecord)
    if type(missionRecord) ~= "table" then
        return getOwnerBlue()
    end

    if isValidOwner(missionRecord.owner) == true then
        return missionRecord.owner
    end

    return getOwnerBlue()
end

local function registerCompletionHook(hookData)
    local state = ensureCampaignTables()

    if state == nil or type(hookData) ~= "table" then
        return false
    end

    local hookKey = hookData.key
        or hookData.missionKey
        or ("HOOK_" .. tostring(countTableKeys(state.Campaign.capture.completionHooks) + 1))

    state.Campaign.capture.completionHooks[hookKey] = {
        key = hookKey,
        missionKey = hookData.missionKey,
        zoneKey = hookData.zoneKey,
        owner = hookData.owner,
        pressure = hookData.pressure or 0,
        stateOnly = true,
        spawnTriggered = false,
        status = hookData.status or "RESERVED",
        reason = hookData.reason or "capture_completion_hook_reserved",
        createdAt = getCurrentTime(),
        updatedAt = getCurrentTime()
    }

    return true
end

function CaptureSystem.refreshCounters()
    return refreshAllCounters()
end

function CaptureSystem.refreshEligibility()
    return updateCaptureEligibility()
end

function CaptureSystem.canCaptureBase(keyOrRecord)
    if type(keyOrRecord) == "table" then
        return canCaptureBaseRecord(keyOrRecord)
    end

    local record = CaptureSystem.getBase(keyOrRecord)

    return canCaptureBaseRecord(record)
end

function CaptureSystem.canCaptureZone(keyOrRecord)
    if type(keyOrRecord) == "table" then
        return canCaptureZoneRecord(keyOrRecord)
    end

    local record = CaptureSystem.getZone(keyOrRecord)

    return canCaptureZoneRecord(record)
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

    return getRecordOwner(record)
end

function CaptureSystem.getZoneOwner(keyOrName)
    local record = CaptureSystem.getZone(keyOrName)

    if record == nil then
        return nil
    end

    return getRecordOwner(record)
end

function CaptureSystem.setBaseOwner(keyOrName, newOwner, reason, options)
    local state = ensureCampaignTables()

    if state == nil then
        return false, "state_unavailable"
    end

    local record, registryKey = findRecordByKeyOrName(state.Bases.registry, keyOrName)

    if record == nil then
        return false, "base_not_found"
    end

    local captureOptions = options or {}

    if captureOptions.force ~= true then
        local eligible, eligibilityReason = canCaptureBaseRecord(record)

        if eligible ~= true then
            return false, eligibilityReason
        end
    end

    local success, previousOwner, changed = setRecordOwner(record, newOwner, reason)

    if success ~= true then
        return false, previousOwner
    end

    state.Bases.registry[registryKey] = record
    syncWorldBase(record)
    refreshAllCounters()

    if changed == true then
        addCaptureEvent({
            type = "BASE_OWNER_CHANGED",
            targetType = "BASE",
            key = record.key,
            name = record.name,
            previousOwner = previousOwner,
            newOwner = newOwner,
            reason = reason or "manual_capture_update",
            captureEligible = true
        })

        markDirty("base_owner_changed")
        logInfo("Base captured: " .. tostring(record.name) .. " [" .. tostring(newOwner) .. "]")
    else
        logDebug("Base owner unchanged: " .. tostring(record.name) .. " [" .. tostring(newOwner) .. "]")
    end

    return true, record
end

function CaptureSystem.setZoneOwner(keyOrName, newOwner, reason, options)
    local state = ensureCampaignTables()

    if state == nil then
        return false, "state_unavailable"
    end

    local record, registryKey = findRecordByKeyOrName(state.Zones.registry, keyOrName)

    if record == nil then
        return false, "zone_not_found"
    end

    local captureOptions = options or {}

    if captureOptions.force ~= true then
        local eligible, eligibilityReason = canCaptureZoneRecord(record)

        if eligible ~= true then
            return false, eligibilityReason
        end
    end

    local success, previousOwner, changed = setRecordOwner(record, newOwner, reason)

    if success ~= true then
        return false, previousOwner
    end

    state.Zones.registry[registryKey] = record
    syncWorldZone(record)

    local progressRecord = ensureZoneProgressRecord(record.key or registryKey)

    if progressRecord ~= nil then
        progressRecord.previousOwner = previousOwner
        progressRecord.owner = newOwner
        progressRecord.status = "OWNER_CHANGED"
        progressRecord.captureReady = false
        progressRecord.updatedAt = getCurrentTime()
    end

    refreshAllCounters()

    if changed == true then
        addCaptureEvent({
            type = "ZONE_OWNER_CHANGED",
            targetType = "ZONE",
            key = record.key,
            name = record.name,
            previousOwner = previousOwner,
            newOwner = newOwner,
            reason = reason or "manual_capture_update",
            captureEligible = true
        })

        markDirty("zone_owner_changed")
        logInfo("Zone captured: " .. tostring(record.name) .. " [" .. tostring(newOwner) .. "]")
    else
        logDebug("Zone owner unchanged: " .. tostring(record.name) .. " [" .. tostring(newOwner) .. "]")
    end

    return true, record
end

function CaptureSystem.setLinkedBaseOwnerFromZone(zoneKeyOrName, reason)
    local zoneRecord = CaptureSystem.getZone(zoneKeyOrName)

    if zoneRecord == nil then
        return false, "zone_not_found"
    end

    local zoneEligible, zoneReason = canCaptureZoneRecord(zoneRecord)

    if zoneEligible ~= true then
        return false, zoneReason
    end

    local baseRecord = nil
    local baseKey = nil

    baseRecord, baseKey = getLinkedBaseFromZone(zoneRecord)

    if baseRecord == nil then
        return false, "zone_has_no_linked_airbase"
    end

    local baseEligible, baseReason = canCaptureBaseRecord(baseRecord)

    if baseEligible ~= true then
        return false, baseReason
    end

    local owner = getRecordOwner(zoneRecord)

    return CaptureSystem.setBaseOwner(
        baseKey or baseRecord.key,
        owner,
        reason or "linked_zone_owner_changed"
    )
end

function CaptureSystem.setLinkedZoneOwnerFromBase(baseKeyOrName, reason)
    local baseRecord = CaptureSystem.getBase(baseKeyOrName)

    if baseRecord == nil then
        return false, "base_not_found"
    end

    local baseEligible, baseReason = canCaptureBaseRecord(baseRecord)

    if baseEligible ~= true then
        return false, baseReason
    end

    local owner = getRecordOwner(baseRecord)
    local zones = getLinkedZonesFromBase(baseRecord)
    local changed = 0
    local skipped = 0

    for _, zoneRecord in pairs(zones) do
        local zoneEligible = canCaptureZoneRecord(zoneRecord)

        if zoneEligible == true then
            local success = CaptureSystem.setZoneOwner(
                zoneRecord.key,
                owner,
                reason or "linked_base_owner_changed"
            )

            if success == true then
                changed = changed + 1
            else
                skipped = skipped + 1
            end
        else
            skipped = skipped + 1
        end
    end

    return true, {
        changed = changed,
        skipped = skipped
    }
end

function CaptureSystem.addCapturePressure(zoneKeyOrName, owner, amount, source, options)
    local state = ensureCampaignTables()

    if state == nil then
        return false, "state_unavailable"
    end

    local zoneRecord, zoneRegistryKey = findRecordByKeyOrName(state.Zones.registry, zoneKeyOrName)

    if zoneRecord == nil then
        return false, "zone_not_found"
    end

    local eligible, eligibilityReason = canCaptureZoneRecord(zoneRecord)

    if eligible ~= true then
        return false, eligibilityReason
    end

    local pressureOwner = owner or getOwnerBlue()

    if isValidOwner(pressureOwner) ~= true then
        return false, "invalid_owner"
    end

    local pressureAmount = clamp(amount or 0, 0, nil)

    if pressureAmount <= 0 then
        return false, "invalid_pressure_amount"
    end

    local pressureRecord = ensureZonePressureRecord(zoneRecord.key or zoneRegistryKey)

    if pressureRecord == nil then
        return false, "pressure_record_unavailable"
    end

    local previousPressure = getPressureValueForOwner(pressureRecord, pressureOwner)
    setPressureValueForOwner(pressureRecord, pressureOwner, previousPressure + pressureAmount)

    pressureRecord.lastSource = source or CaptureSystem.pressureSources.MANUAL
    pressureRecord.lastMissionKey = options and options.missionKey or nil
    pressureRecord.lastReason = options and options.reason or "capture_pressure_added"
    pressureRecord.updatedAt = getCurrentTime()

    local progressRecord = updatePressureDerivedValues(zoneRecord.key or zoneRegistryKey)

    addCaptureEvent({
        type = "CAPTURE_PRESSURE_ADDED",
        targetType = "ZONE",
        key = zoneRecord.key,
        name = zoneRecord.name,
        owner = pressureOwner,
        amount = pressureAmount,
        previousPressure = previousPressure,
        newPressure = getPressureValueForOwner(pressureRecord, pressureOwner),
        source = source or CaptureSystem.pressureSources.MANUAL,
        missionKey = options and options.missionKey or nil,
        progressPercent = progressRecord and progressRecord.percent or 0,
        progressStatus = progressRecord and progressRecord.status or "UNKNOWN",
        stateOnly = true
    })

    markDirty("capture_pressure_added")

    logInfo(
        "Capture pressure added: zone="
        .. tostring(zoneRecord.name or zoneRecord.key)
        .. " owner="
        .. tostring(pressureOwner)
        .. " amount="
        .. tostring(pressureAmount)
        .. " progress="
        .. tostring(progressRecord and progressRecord.percent or 0)
        .. "%"
    )

    return true, {
        zone = zoneRecord,
        pressure = pressureRecord,
        progress = progressRecord
    }
end

function CaptureSystem.setCapturePressure(zoneKeyOrName, owner, amount, source, options)
    local state = ensureCampaignTables()

    if state == nil then
        return false, "state_unavailable"
    end

    local zoneRecord, zoneRegistryKey = findRecordByKeyOrName(state.Zones.registry, zoneKeyOrName)

    if zoneRecord == nil then
        return false, "zone_not_found"
    end

    local eligible, eligibilityReason = canCaptureZoneRecord(zoneRecord)

    if eligible ~= true then
        return false, eligibilityReason
    end

    local pressureOwner = owner or getOwnerBlue()

    if isValidOwner(pressureOwner) ~= true then
        return false, "invalid_owner"
    end

    local pressureRecord = ensureZonePressureRecord(zoneRecord.key or zoneRegistryKey)

    if pressureRecord == nil then
        return false, "pressure_record_unavailable"
    end

    setPressureValueForOwner(pressureRecord, pressureOwner, clamp(amount or 0, 0, nil))

    pressureRecord.lastSource = source or CaptureSystem.pressureSources.MANUAL
    pressureRecord.lastMissionKey = options and options.missionKey or nil
    pressureRecord.lastReason = options and options.reason or "capture_pressure_set"
    pressureRecord.updatedAt = getCurrentTime()

    local progressRecord = updatePressureDerivedValues(zoneRecord.key or zoneRegistryKey)

    markDirty("capture_pressure_set")

    return true, {
        zone = zoneRecord,
        pressure = pressureRecord,
        progress = progressRecord
    }
end

function CaptureSystem.clearCapturePressure(zoneKeyOrName, reason)
    local state = ensureCampaignTables()

    if state == nil then
        return false, "state_unavailable"
    end

    local zoneRecord, zoneRegistryKey = findRecordByKeyOrName(state.Zones.registry, zoneKeyOrName)

    if zoneRecord == nil then
        return false, "zone_not_found"
    end

    local zoneKey = zoneRecord.key or zoneRegistryKey

    state.Campaign.capture.pressure[zoneKey] = {
        zoneKey = zoneKey,
        blue = 0,
        red = 0,
        neutral = 0,
        contested = 0,
        total = 0,
        dominantOwner = getOwnerUnknown(),
        lastSource = "CLEAR",
        lastMissionKey = nil,
        updatedAt = getCurrentTime()
    }

    state.Campaign.capture.progress[zoneKey] = {
        zoneKey = zoneKey,
        owner = getRecordOwner(zoneRecord),
        previousOwner = getRecordOwner(zoneRecord),
        dominantOwner = getOwnerUnknown(),
        percent = 0,
        bluePressure = 0,
        redPressure = 0,
        neutralPressure = 0,
        contestedPressure = 0,
        threshold = state.Campaign.capture.thresholds.capture or CaptureSystem.defaultCaptureThreshold,
        contestedThreshold = state.Campaign.capture.thresholds.contested or CaptureSystem.defaultContestedThreshold,
        status = "STABLE",
        captureReady = false,
        updatedAt = getCurrentTime()
    }

    zoneRecord.capturePressure = copyValue(state.Campaign.capture.pressure[zoneKey])
    zoneRecord.captureProgress = copyValue(state.Campaign.capture.progress[zoneKey])
    zoneRecord.updatedAt = getCurrentTime()

    syncWorldZone(zoneRecord)

    addCaptureEvent({
        type = "CAPTURE_PRESSURE_CLEARED",
        targetType = "ZONE",
        key = zoneRecord.key,
        name = zoneRecord.name,
        reason = reason or "manual_capture_pressure_clear",
        stateOnly = true
    })

    markDirty("capture_pressure_cleared")

    return true, state.Campaign.capture.progress[zoneKey]
end

function CaptureSystem.getCapturePressure(zoneKeyOrName)
    local state = ensureCampaignTables()

    if state == nil then
        return nil
    end

    local zoneRecord, zoneRegistryKey = findRecordByKeyOrName(state.Zones.registry, zoneKeyOrName)

    if zoneRecord == nil then
        return nil
    end

    return ensureZonePressureRecord(zoneRecord.key or zoneRegistryKey)
end

function CaptureSystem.getCaptureProgress(zoneKeyOrName)
    local state = ensureCampaignTables()

    if state == nil then
        return nil
    end

    local zoneRecord, zoneRegistryKey = findRecordByKeyOrName(state.Zones.registry, zoneKeyOrName)

    if zoneRecord == nil then
        return nil
    end

    return updatePressureDerivedValues(zoneRecord.key or zoneRegistryKey)
end

function CaptureSystem.evaluateZoneCapture(zoneKeyOrName, options)
    local state = ensureCampaignTables()

    if state == nil then
        return false, "state_unavailable"
    end

    local zoneRecord, zoneRegistryKey = findRecordByKeyOrName(state.Zones.registry, zoneKeyOrName)

    if zoneRecord == nil then
        return false, "zone_not_found"
    end

    local zoneKey = zoneRecord.key or zoneRegistryKey
    local progressRecord = updatePressureDerivedValues(zoneKey)

    if progressRecord == nil then
        return false, "progress_unavailable"
    end

    local evaluationOptions = options or {}

    if progressRecord.captureReady ~= true then
        return true, {
            captured = false,
            contested = progressRecord.status == "CONTESTED",
            progress = progressRecord
        }
    end

    if evaluationOptions.autoCapture ~= true then
        registerCompletionHook({
            key = "CAPTURE_READY_" .. tostring(zoneKey),
            zoneKey = zoneKey,
            owner = progressRecord.dominantOwner,
            pressure = progressRecord.percent,
            status = "READY",
            reason = "capture_ready_state_only"
        })

        addCaptureEvent({
            type = "CAPTURE_READY",
            targetType = "ZONE",
            key = zoneRecord.key,
            name = zoneRecord.name,
            owner = progressRecord.dominantOwner,
            progressPercent = progressRecord.percent,
            stateOnly = true
        })

        markDirty("capture_ready")

        return true, {
            captured = false,
            ready = true,
            progress = progressRecord
        }
    end

    local success, result = CaptureSystem.setZoneOwner(
        zoneKey,
        progressRecord.dominantOwner,
        evaluationOptions.reason or "capture_pressure_threshold_reached",
        {
            force = evaluationOptions.force == true
        }
    )

    if success == true then
        CaptureSystem.setLinkedBaseOwnerFromZone(zoneKey, "linked_zone_capture_pressure_threshold")
        CaptureSystem.clearCapturePressure(zoneKey, "capture_completed_pressure_reset")

        addCaptureEvent({
            type = "ZONE_CAPTURED_BY_PRESSURE",
            targetType = "ZONE",
            key = result.key,
            name = result.name,
            newOwner = progressRecord.dominantOwner,
            progressPercent = progressRecord.percent,
            stateOnly = true
        })
    end

    return success, {
        captured = success == true,
        zone = result,
        progress = progressRecord
    }
end

function CaptureSystem.applyMissionEffect(missionKeyOrRecord, options)
    local state = ensureCampaignTables()

    if state == nil then
        return false, "state_unavailable"
    end

    local missionRecord = nil

    if type(missionKeyOrRecord) == "table" then
        missionRecord = missionKeyOrRecord
    else
        local missionGenerator = getMissionGenerator()

        if missionGenerator ~= nil and missionGenerator.getMission ~= nil then
            missionRecord = missionGenerator.getMission(missionKeyOrRecord)
        end
    end

    if type(missionRecord) ~= "table" then
        return false, "mission_not_found"
    end

    if missionRecord.key == nil then
        return false, "mission_key_missing"
    end

    if state.Campaign.capture.appliedMissionEffects[missionRecord.key] == true then
        return false, "mission_effect_already_applied"
    end

    local zoneKey = getMissionTargetZoneKey(missionRecord)

    if zoneKey == nil then
        return false, "mission_target_zone_missing"
    end

    local zoneRecord = CaptureSystem.getZone(zoneKey)

    if zoneRecord == nil then
        return false, "target_zone_not_found"
    end

    local eligible, eligibilityReason = canCaptureZoneRecord(zoneRecord)

    if eligible ~= true then
        return false, eligibilityReason
    end

    local amount = getCapturePressureFromMission(missionRecord)

    if amount <= 0 then
        return false, "mission_has_no_capture_pressure"
    end

    local owner = getMissionPressureOwner(missionRecord)
    local applyOptions = options or {}

    local success, result = CaptureSystem.addCapturePressure(
        zoneKey,
        owner,
        amount,
        CaptureSystem.pressureSources.MISSION_EFFECT,
        {
            missionKey = missionRecord.key,
            reason = applyOptions.reason or "mission_effect_applied_to_capture"
        }
    )

    if success ~= true then
        return false, result
    end

    state.Campaign.capture.appliedMissionEffects[missionRecord.key] = true
    state.Campaign.capture.missionEffects[missionRecord.key] = {
        missionKey = missionRecord.key,
        missionType = missionRecord.type,
        zoneKey = zoneKey,
        owner = owner,
        amount = amount,
        stateOnly = true,
        appliedAt = getCurrentTime(),
        autoCapture = applyOptions.autoCapture == true
    }

    registerCompletionHook({
        key = "MISSION_EFFECT_" .. tostring(missionRecord.key),
        missionKey = missionRecord.key,
        zoneKey = zoneKey,
        owner = owner,
        pressure = amount,
        status = "APPLIED_STATE_ONLY",
        reason = "mission_effect_capture_hook"
    })

    if applyOptions.autoEvaluate ~= false then
        CaptureSystem.evaluateZoneCapture(zoneKey, {
            autoCapture = applyOptions.autoCapture == true,
            reason = "mission_effect_capture_evaluation"
        })
    end

    CaptureSystem.lastMissionEffectSummary = state.Campaign.capture.missionEffects[missionRecord.key]

    addCaptureEvent({
        type = "MISSION_EFFECT_APPLIED_TO_CAPTURE",
        targetType = "ZONE",
        key = zoneRecord.key,
        name = zoneRecord.name,
        missionKey = missionRecord.key,
        missionType = missionRecord.type,
        owner = owner,
        amount = amount,
        stateOnly = true
    })

    markDirty("mission_effect_applied_to_capture")

    logInfo(
        "Mission effect applied to capture: mission="
        .. tostring(missionRecord.key)
        .. " zone="
        .. tostring(zoneRecord.name or zoneRecord.key)
        .. " owner="
        .. tostring(owner)
        .. " pressure="
        .. tostring(amount)
    )

    return true, result
end

function CaptureSystem.applyCompletedMissionEffects(options)
    local state = ensureCampaignTables()

    if state == nil then
        return false, "state_unavailable"
    end

    local missionGenerator = getMissionGenerator()

    if missionGenerator == nil or missionGenerator.getCompletedMissions == nil then
        return false, "mission_generator_unavailable"
    end

    local completedMissions = missionGenerator.getCompletedMissions()
    local applied = 0
    local skipped = 0
    local failed = 0

    for _, missionRecord in pairs(completedMissions) do
        if type(missionRecord) == "table" then
            local success, reason = CaptureSystem.applyMissionEffect(missionRecord, options)

            if success == true then
                applied = applied + 1
            elseif reason == "mission_effect_already_applied" then
                skipped = skipped + 1
            else
                failed = failed + 1
            end
        end
    end

    CaptureSystem.lastMissionEffectSummary = {
        applied = applied,
        skipped = skipped,
        failed = failed,
        updatedAt = getCurrentTime()
    }

    logInfo(
        "Completed mission effects processed: applied="
        .. tostring(applied)
        .. ", skipped="
        .. tostring(skipped)
        .. ", failed="
        .. tostring(failed)
    )

    return true, CaptureSystem.lastMissionEffectSummary
end

function CaptureSystem.updateCaptureProgress(options)
    local state = ensureCampaignTables()

    if state == nil then
        return false, "state_unavailable"
    end

    local updateOptions = options or {}
    local updated = 0
    local ready = 0
    local contested = 0

    updateCaptureEligibility()

    for zoneKey, _ in pairs(state.Campaign.capture.captureEligibleZones) do
        local progressRecord = updatePressureDerivedValues(zoneKey)

        if progressRecord ~= nil then
            updated = updated + 1

            if progressRecord.captureReady == true then
                ready = ready + 1

                if updateOptions.autoEvaluate == true then
                    CaptureSystem.evaluateZoneCapture(zoneKey, {
                        autoCapture = updateOptions.autoCapture == true,
                        reason = "capture_progress_update"
                    })
                end
            elseif progressRecord.status == "CONTESTED" then
                contested = contested + 1
            end
        end
    end

    CaptureSystem.lastPressureSummary = {
        updated = updated,
        ready = ready,
        contested = contested,
        pressureRecords = countTableKeys(state.Campaign.capture.pressure),
        progressRecords = countTableKeys(state.Campaign.capture.progress),
        updatedAt = getCurrentTime()
    }

    state.Campaign.capture.statistics.pressureUpdated = updated
    state.Campaign.capture.statistics.captureReady = ready
    state.Campaign.capture.statistics.contestedByPressure = contested
    state.Campaign.capture.statistics.pressureRecords = countTableKeys(state.Campaign.capture.pressure)
    state.Campaign.capture.statistics.progressRecords = countTableKeys(state.Campaign.capture.progress)

    markDirty("capture_progress_updated")

    logInfo(
        "Capture progress updated: zones="
        .. tostring(updated)
        .. ", ready="
        .. tostring(ready)
        .. ", contested="
        .. tostring(contested)
    )

    return true, CaptureSystem.lastPressureSummary
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
    local success, zoneRecordOrReason = CaptureSystem.setZoneOwner(keyOrName, getOwnerBlue(), reason or "capture_for_blue")

    if success == true then
        CaptureSystem.setLinkedBaseOwnerFromZone(zoneRecordOrReason.key, "linked_zone_capture_for_blue")
    end

    return success, zoneRecordOrReason
end

function CaptureSystem.captureZoneForRed(keyOrName, reason)
    local success, zoneRecordOrReason = CaptureSystem.setZoneOwner(keyOrName, getOwnerRed(), reason or "capture_for_red")

    if success == true then
        CaptureSystem.setLinkedBaseOwnerFromZone(zoneRecordOrReason.key, "linked_zone_capture_for_red")
    end

    return success, zoneRecordOrReason
end

function CaptureSystem.captureZoneForNeutral(keyOrName, reason)
    local success, zoneRecordOrReason = CaptureSystem.setZoneOwner(keyOrName, getOwnerNeutral(), reason or "capture_for_neutral")

    if success == true then
        CaptureSystem.setLinkedBaseOwnerFromZone(zoneRecordOrReason.key, "linked_zone_capture_for_neutral")
    end

    return success, zoneRecordOrReason
end

function CaptureSystem.contestZone(keyOrName, reason)
    local success, zoneRecordOrReason = CaptureSystem.setZoneOwner(keyOrName, getOwnerContested(), reason or "zone_contested")

    if success == true then
        CaptureSystem.setLinkedBaseOwnerFromZone(zoneRecordOrReason.key, "linked_zone_contested")
    end

    return success, zoneRecordOrReason
end

function CaptureSystem.getBasesByOwner(owner, options)
    local result = {}
    local queryOptions = options or {}
    local registry = getBaseRegistry()

    for key, record in pairs(registry) do
        local recordOwner = getRecordOwner(record)

        if recordOwner == owner then
            if queryOptions.captureEligibleOnly == true then
                local eligible = canCaptureBaseRecord(record)

                if eligible == true then
                    result[key] = record
                end
            else
                result[key] = record
            end
        end
    end

    return result
end

function CaptureSystem.getZonesByOwner(owner, options)
    local result = {}
    local queryOptions = options or {}
    local registry = getZoneRegistry()

    for key, record in pairs(registry) do
        local recordOwner = getRecordOwner(record)

        if recordOwner == owner then
            if queryOptions.captureEligibleOnly == true then
                local eligible = canCaptureZoneRecord(record)

                if eligible == true then
                    result[key] = record
                end
            else
                result[key] = record
            end
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

function CaptureSystem.getCaptureEligibleBases(owner)
    local state = ensureCampaignTables()

    if state == nil then
        return {}
    end

    updateCaptureEligibility()

    if owner == nil then
        return state.Campaign.capture.captureEligibleBases
    end

    local result = {}

    for key, record in pairs(state.Campaign.capture.captureEligibleBases) do
        if getRecordOwner(record) == owner then
            result[key] = record
        end
    end

    return result
end

function CaptureSystem.getCaptureEligibleZones(owner)
    local state = ensureCampaignTables()

    if state == nil then
        return {}
    end

    updateCaptureEligibility()

    if owner == nil then
        return state.Campaign.capture.captureEligibleZones
    end

    local result = {}

    for key, record in pairs(state.Campaign.capture.captureEligibleZones) do
        if getRecordOwner(record) == owner then
            result[key] = record
        end
    end

    return result
end

function CaptureSystem.getBlueCaptureZones()
    return CaptureSystem.getCaptureEligibleZones(getOwnerBlue())
end

function CaptureSystem.getRedCaptureZones()
    return CaptureSystem.getCaptureEligibleZones(getOwnerRed())
end

function CaptureSystem.getNeutralCaptureZones()
    return CaptureSystem.getCaptureEligibleZones(getOwnerNeutral())
end

function CaptureSystem.getContestedCaptureZones()
    return CaptureSystem.getCaptureEligibleZones(getOwnerContested())
end

function CaptureSystem.getCaptureReadyZones()
    local state = ensureCampaignTables()
    local result = {}

    if state == nil then
        return result
    end

    CaptureSystem.updateCaptureProgress({
        autoEvaluate = false
    })

    for key, progressRecord in pairs(state.Campaign.capture.progress) do
        if progressRecord.captureReady == true then
            result[key] = progressRecord
        end
    end

    return result
end

function CaptureSystem.getPressureContestedZones()
    local state = ensureCampaignTables()
    local result = {}

    if state == nil then
        return result
    end

    CaptureSystem.updateCaptureProgress({
        autoEvaluate = false
    })

    for key, progressRecord in pairs(state.Campaign.capture.progress) do
        if progressRecord.status == "CONTESTED" then
            result[key] = progressRecord
        end
    end

    return result
end

function CaptureSystem.restoreInitialOwnership()
    local state = ensureCampaignTables()

    if state == nil then
        return false, "state_unavailable"
    end

    for _, baseRecord in pairs(state.Bases.registry) do
        baseRecord.currentOwner = baseRecord.initialOwner or getOwnerUnknown()
        baseRecord.owner = baseRecord.currentOwner
        baseRecord.previousOwner = nil
        baseRecord.captureReason = "restore_initial_ownership"
        baseRecord.updatedAt = getCurrentTime()
        syncWorldBase(baseRecord)
    end

    for _, zoneRecord in pairs(state.Zones.registry) do
        zoneRecord.currentOwner = zoneRecord.initialOwner or getOwnerUnknown()
        zoneRecord.owner = zoneRecord.currentOwner
        zoneRecord.previousOwner = nil
        zoneRecord.captureReason = "restore_initial_ownership"
        zoneRecord.updatedAt = getCurrentTime()
        syncWorldZone(zoneRecord)
    end

    state.Campaign.capture.pressure = {}
    state.Campaign.capture.progress = {}
    state.Campaign.capture.appliedMissionEffects = {}
    state.Campaign.capture.missionEffects = {}
    state.Campaign.capture.completionHooks = {}

    refreshAllCounters()
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

    refreshAllCounters()

    local summary = state.Campaign.capture.statistics or {}

    if (summary.eligibleZones or 0) == 0 then
        logWarn("Capture system validation warning: no capture-eligible zones registered")
    end

    return true, {
        baseCount = baseCount,
        zoneCount = zoneCount,
        eligibleBases = summary.eligibleBases or 0,
        eligibleZones = summary.eligibleZones or 0,
        nonCaptureBases = summary.nonCaptureBases or 0,
        nonCaptureZones = summary.nonCaptureZones or 0,
        pressureRecords = summary.pressureRecords or 0,
        progressRecords = summary.progressRecords or 0,
        appliedMissionEffects = summary.appliedMissionEffects or 0
    }
end

function CaptureSystem.getEvents()
    return CaptureSystem.captureEvents
end

function CaptureSystem.clearEvents()
    CaptureSystem.captureEvents = {}

    local state = ensureCampaignTables()

    if state ~= nil then
        state.Campaign.capture.events = {}
    end

    return true
end

function CaptureSystem.getEligibilitySummary()
    local state = ensureCampaignTables()

    if state == nil then
        return {}
    end

    updateCaptureEligibility()

    return state.Campaign.capture.statistics or {}
end

function CaptureSystem.getPressureSummary()
    local state = ensureCampaignTables()

    if state == nil then
        return {}
    end

    CaptureSystem.updateCaptureProgress({
        autoEvaluate = false
    })

    return CaptureSystem.lastPressureSummary or {
        pressureRecords = countTableKeys(state.Campaign.capture.pressure),
        progressRecords = countTableKeys(state.Campaign.capture.progress),
        appliedMissionEffects = countTableKeys(state.Campaign.capture.appliedMissionEffects)
    }
end

function CaptureSystem.getCaptureSummary()
    local summary = CaptureSystem.getEligibilitySummary()
    local pressureSummary = CaptureSystem.getPressureSummary()

    return {
        name = CaptureSystem.name,
        version = CaptureSystem.version,
        eligibleBases = summary.eligibleBases or 0,
        eligibleZones = summary.eligibleZones or 0,
        nonCaptureBases = summary.nonCaptureBases or 0,
        nonCaptureZones = summary.nonCaptureZones or 0,
        pressureRecords = pressureSummary.pressureRecords or 0,
        progressRecords = pressureSummary.progressRecords or 0,
        captureReady = pressureSummary.ready or 0,
        pressureContested = pressureSummary.contested or 0,
        appliedMissionEffects = summary.appliedMissionEffects or 0,
        baseOwners = summary.bases,
        zoneOwners = summary.zones,
        eventCount = #CaptureSystem.captureEvents
    }
end

function CaptureSystem.start()
    if CaptureSystem.started == true
        and CaptureSystem.finished == true
        and CaptureSystem.failed ~= true then
        logDebug("Capture system already started")
        return true
    end

    CaptureSystem.started = true
    CaptureSystem.finished = false
    CaptureSystem.failed = false
    CaptureSystem.lastUpdateTime = getCurrentTime()

    setModuleStatus("STARTING")
    setFeatureStatus(false)

    logInfo("Capture system started")

    local state = ensureCampaignTables()

    if state == nil then
        CaptureSystem.failed = true

        setModuleStatus("FAILED")
        setFeatureStatus(false)

        logError("Capture system failed: state_unavailable")

        return false
    end

    local valid, result = CaptureSystem.validateState()

    if valid ~= true then
        CaptureSystem.failed = true

        setModuleStatus("FAILED")
        setFeatureStatus(false)

        logError("Capture system validation failed: " .. tostring(result))

        return false
    end

    CaptureSystem.updateCaptureProgress({
        autoEvaluate = false
    })

    state.Campaign.capture.initialized = true
    state.Campaign.capture.lastUpdateTime = getCurrentTime()

    CaptureSystem.finished = true
    CaptureSystem.failed = false

    setFeatureStatus(true)
    setModuleStatus("READY")

    logInfo(
        "Capture eligibility summary: bases="
        .. tostring(result.eligibleBases)
        .. ", zones="
        .. tostring(result.eligibleZones)
        .. ", nonCaptureBases="
        .. tostring(result.nonCaptureBases)
        .. ", nonCaptureZones="
        .. tostring(result.nonCaptureZones)
    )

    logInfo(
        "Capture pressure summary: pressureRecords="
        .. tostring(result.pressureRecords)
        .. ", progressRecords="
        .. tostring(result.progressRecords)
        .. ", appliedMissionEffects="
        .. tostring(result.appliedMissionEffects)
    )

    logInfo("Capture system initialized")

    return true
end

function CaptureSystem.stop()
    CaptureSystem.started = false

    setModuleStatus("STOPPED")

    logInfo("Capture system stopped")

    return true
end

function CaptureSystem.summary()
    local state = getState()
    local bases = nil
    local zones = nil
    local capture = nil

    if state ~= nil then
        bases = state.Bases
        zones = state.Zones
        capture = state.Campaign and state.Campaign.capture or nil
    end

    return {
        name = CaptureSystem.name,
        displayName = CaptureSystem.displayName,
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
        eligibleBases = capture and capture.statistics and capture.statistics.eligibleBases or 0,
        eligibleZones = capture and capture.statistics and capture.statistics.eligibleZones or 0,
        pressureRecords = capture and capture.statistics and capture.statistics.pressureRecords or 0,
        progressRecords = capture and capture.statistics and capture.statistics.progressRecords or 0,
        appliedMissionEffects = capture and capture.statistics and capture.statistics.appliedMissionEffects or 0,
        lastPressureSummary = CaptureSystem.lastPressureSummary,
        lastMissionEffectSummary = CaptureSystem.lastMissionEffectSummary,
        bases = bases,
        zones = zones,
        capture = capture
    }
end

TC.Campaign.CaptureSystem = CaptureSystem
TC.campaign.CaptureSystem = CaptureSystem

TC.modules.captureSystem = {
    name = CaptureSystem.name,
    path = CaptureSystem.path,
    loaded = true,
    version = CaptureSystem.version
}

setModuleStatus("LOADED")
logInfo("Loaded " .. CaptureSystem.path .. " v" .. CaptureSystem.version)

return CaptureSystem
