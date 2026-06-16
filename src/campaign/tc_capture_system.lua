-- Theater Command DCS
-- File: src/campaign/tc_capture_system.lua
--
-- Purpose:
--   Strategic ownership and capture state management.
--
-- Current focus:
--   Airbase Scanner and Zone Factory now distinguish strategic campaign zones
--   from helipads, medical pads, tactical pads and unknown airbase-like objects.
--   The Capture System must therefore only allow capture logic on proper
--   campaign objectives.
--
-- Version:
--   0.2.0
--
-- Responsibilities:
--   - manage base and zone ownership
--   - restrict capture logic to strategic and secondary campaign objectives
--   - prevent medical pads, helipads, tactical pads and unknown objects from
--     becoming strategic capture targets
--   - keep linked airbase and zone ownership synchronized
--   - store capture events for persistence, debug and later AI reactions
--   - expose filtered capture target lists for missions, AI and UI
--
-- Vendor note:
--   This file does not directly call MIST, MOOSE, CTLD or Skynet IADS.
--   It consumes Theater Command state produced by the World systems.

TC = TC or {}
TC.modules = TC.modules or {}
TC.Campaign = TC.Campaign or {}
TC.campaign = TC.campaign or TC.Campaign

local CaptureSystem = {}

CaptureSystem.name = "tc_capture_system"
CaptureSystem.displayName = "Capture System"
CaptureSystem.path = "src/campaign/tc_capture_system.lua"
CaptureSystem.version = "0.2.0"

CaptureSystem.loaded = true
CaptureSystem.started = false
CaptureSystem.finished = false
CaptureSystem.failed = false

CaptureSystem.lastUpdateTime = 0
CaptureSystem.captureEvents = {}
CaptureSystem.lastEligibilitySummary = nil

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
            and type(childValue) ~= "thread"
        then
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
        or record.isUnknownAirbaseObject == true
    then
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

    state.Campaign.capture.statistics = {
        bases = baseOwnerSummary,
        zones = zoneOwnerSummary,
        allBases = countTableKeys(getBaseRegistry()),
        allZones = countTableKeys(getZoneRegistry()),
        eligibleBases = baseOwnerSummary.total,
        eligibleZones = zoneOwnerSummary.total,
        nonCaptureBases = countTableKeys(state.Campaign.capture.nonCaptureBases),
        nonCaptureZones = countTableKeys(state.Campaign.capture.nonCaptureZones),
        updatedAt = getCurrentTime()
    }

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
        nonCaptureZones = summary.nonCaptureZones or 0
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

function CaptureSystem.getCaptureSummary()
    local summary = CaptureSystem.getEligibilitySummary()

    return {
        name = CaptureSystem.name,
        version = CaptureSystem.version,
        eligibleBases = summary.eligibleBases or 0,
        eligibleZones = summary.eligibleZones or 0,
        nonCaptureBases = summary.nonCaptureBases or 0,
        nonCaptureZones = summary.nonCaptureZones or 0,
        baseOwners = summary.bases,
        zoneOwners = summary.zones,
        eventCount = #CaptureSystem.captureEvents
    }
end

function CaptureSystem.start()
    if CaptureSystem.started == true and CaptureSystem.finished == true and CaptureSystem.failed ~= true then
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
