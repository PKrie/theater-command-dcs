-- Theater Command DCS
-- File: src/world/tc_airbase_scanner.lua
--
-- Purpose:
--   Scan all DCS airbase-like objects on the active map and convert them into
--   Theater Command world records.
--
-- Current focus:
--   Syria returns many airbase-like objects, including airfields, heliports,
--   helipads, medical pads, oil pads and other tactical pads. These objects
--   must not all be treated as strategic campaign airfields.
--
-- Version:
--   0.2.2
--
-- Fixes:
--   - Keeps the fixed unknown-classification state conflict from v0.2.1.
--   - Classifies strategic and secondary airfields by normalized name before
--     relying on DCS category data.
--   - Correctly prepares Syrian mainland strategic airfields as potential Red
--     strategic bases even when DCS category data is not AIRDROME.
--   - Adds prefix-based classification for Syria helipad-like objects such as
--     HMED, H_MED_ORIG, HI, HS, HC, HL, HJ, HT, HOIL and HSTAD.
--   - Keeps ZoneFactory compatibility through getRegistry(), categoryName,
--     currentOwner and position.

TC = TC or {}
TC.modules = TC.modules or {}
TC.World = TC.World or {}
TC.world = TC.world or TC.World

local AirbaseScanner = {}

AirbaseScanner.name = "tc_airbase_scanner"
AirbaseScanner.displayName = "Airbase Scanner"
AirbaseScanner.path = "src/world/tc_airbase_scanner.lua"
AirbaseScanner.version = "0.2.2"

AirbaseScanner.loaded = true
AirbaseScanner.started = false
AirbaseScanner.finished = false
AirbaseScanner.failed = false

AirbaseScanner.registry = {}
AirbaseScanner.lastScanTime = 0
AirbaseScanner.lastScanCount = 0

AirbaseScanner.Categories = {
    STRATEGIC_AIRFIELD = "STRATEGIC_AIRFIELD",
    SECONDARY_AIRFIELD = "SECONDARY_AIRFIELD",
    HELIPORT = "HELIPORT",
    HELIPAD = "HELIPAD",
    MEDICAL_PAD = "MEDICAL_PAD",
    FARP = "FARP",
    TACTICAL_PAD = "TACTICAL_PAD",
    UNKNOWN = "UNKNOWN"
}

AirbaseScanner.categoryOrder = {
    AirbaseScanner.Categories.STRATEGIC_AIRFIELD,
    AirbaseScanner.Categories.SECONDARY_AIRFIELD,
    AirbaseScanner.Categories.HELIPORT,
    AirbaseScanner.Categories.HELIPAD,
    AirbaseScanner.Categories.MEDICAL_PAD,
    AirbaseScanner.Categories.FARP,
    AirbaseScanner.Categories.TACTICAL_PAD,
    AirbaseScanner.Categories.UNKNOWN
}

AirbaseScanner.dcsCategoryNames = {
    [0] = "AIRDROME",
    [1] = "HELIPAD",
    [2] = "SHIP"
}

AirbaseScanner.cyprusKeywords = {
    "AKROTIRI",
    "PAPHOS",
    "LARNACA",
    "ERCAN",
    "GECITKALE",
    "GEÇITKALE",
    "KINGSFIELD",
    "NICOSIA",
    "CYPRUS"
}

AirbaseScanner.syrianMainlandKeywords = {
    "ABU_AL_DUHUR",
    "ABU AL-DUHUR",
    "ABU AL DUHUR",
    "AL_QUSAYR",
    "AL QUSAYR",
    "AN_NASIRIYAH",
    "AN NASIRIYAH",
    "THA_LAH",
    "THA'LAH",
    "THALAH",
    "MARJ_AS_SULTAN",
    "MARJ AS SULTAN",
    "MARJ_RUHAYYIL",
    "MARJ RUHAYYIL",
    "AL_DUMAYR",
    "AL-DUMAYR",
    "AD_DUMAYR",
    "DUMAYR",
    "DAMASCUS",
    "MEZZEH",
    "SAYQAL",
    "SHAYRAT",
    "TIYAS",
    "T_4",
    "T-4",
    "T4",
    "PALMYRA",
    "TADMUR",
    "KUWEIRES",
    "KUWAIRES",
    "JIRAH",
    "ALEPPO",
    "MINAKH",
    "MENAGH",
    "TAFTANAZ",
    "HAMA",
    "HOMS",
    "LATAKIA",
    "LATTAKIA",
    "BASSEL",
    "BASSEL_AL_ASSAD",
    "BASSEL AL-ASSAD",
    "HMEIMIM",
    "KHMEIMIM",
    "DEIR_EZ_ZOR",
    "DEIR EZ-ZOR",
    "DEIR_EZZOR",
    "DEIR EZZOR",
    "DEIR_ZOR",
    "DEIR ZOR",
    "TABQA",
    "KHALKHALAH",
    "QABR_AS_SITT",
    "QABR AS SITT",
    "TAL_SIMAN",
    "TAL SIMAN",
    "KHARAB_ISHK",
    "KHARAB ISHK"
}

AirbaseScanner.strategicAirfieldKeywords = {
    "AKROTIRI",
    "DAMASCUS",
    "MEZZEH",
    "AL_DUMAYR",
    "AL-DUMAYR",
    "AD_DUMAYR",
    "DUMAYR",
    "SAYQAL",
    "SHAYRAT",
    "TIYAS",
    "T_4",
    "T-4",
    "T4",
    "PALMYRA",
    "TADMUR",
    "HAMA",
    "ALEPPO",
    "LATAKIA",
    "LATTAKIA",
    "BASSEL",
    "BASSEL_AL_ASSAD",
    "BASSEL AL-ASSAD",
    "HMEIMIM",
    "KHMEIMIM",
    "DEIR_EZ_ZOR",
    "DEIR EZ-ZOR",
    "DEIR_EZZOR",
    "DEIR EZZOR",
    "DEIR_ZOR",
    "DEIR ZOR",
    "KUWEIRES",
    "KUWAIRES",
    "TABQA",
    "ABU_AL_DUHUR",
    "ABU AL-DUHUR",
    "ABU AL DUHUR",
    "MINAKH",
    "MENAGH",
    "TAFTANAZ",
    "JIRAH",
    "KHALKHALAH"
}

AirbaseScanner.secondaryAirfieldKeywords = {
    "PAPHOS",
    "LARNACA",
    "ERCAN",
    "GECITKALE",
    "GEÇITKALE",
    "KINGSFIELD",
    "NICOSIA",
    "AL_QUSAYR",
    "AL QUSAYR",
    "AN_NASIRIYAH",
    "AN NASIRIYAH",
    "THA_LAH",
    "THA'LAH",
    "THALAH",
    "MARJ_AS_SULTAN",
    "MARJ AS SULTAN",
    "MARJ_RUHAYYIL",
    "MARJ RUHAYYIL",
    "RAYAK"
}

AirbaseScanner.medicalPadKeywords = {
    "MEDICAL",
    "MEDEVAC",
    "CASEVAC",
    "HOSPITAL",
    "FIELD_HOSPITAL",
    "FIELD HOSPITAL",
    "MASH",
    "AID_STATION",
    "AID STATION",
    "MED_PAD",
    "MED PAD",
    "MEDICAL_PAD",
    "MEDICAL PAD",
    "HMED",
    "H_MED"
}

AirbaseScanner.farpKeywords = {
    "FARP",
    "FORWARD_ARMING",
    "FORWARD ARMING",
    "FORWARD_REFUELING",
    "FORWARD REFUELING",
    "FORWARD_REFUELLING",
    "FORWARD REFUELLING",
    "FORWARD_OPERATING",
    "FORWARD OPERATING"
}

AirbaseScanner.heliportKeywords = {
    "HELIPORT",
    "HELI_PORT",
    "HELI PORT",
    "HELISTATION",
    "HELI_STATION",
    "HELI STATION",
    "HELIBASE",
    "HELI_BASE",
    "HELI BASE"
}

AirbaseScanner.helipadKeywords = {
    "HELIPAD",
    "HELI_PAD",
    "HELI PAD",
    "LANDING_PAD",
    "LANDING PAD"
}

AirbaseScanner.tacticalPadKeywords = {
    "FOB",
    "OUTPOST",
    "TACTICAL",
    "LZ",
    "LANDING_ZONE",
    "LANDING ZONE",
    "ROADBASE",
    "ROAD_BASE",
    "ROAD BASE",
    "CHECKPOINT",
    "PATROL_BASE",
    "PATROL BASE",
    "COMBAT_OUTPOST",
    "COMBAT OUTPOST",
    "HOIL",
    "OIL",
    "EMERGENCY"
}

AirbaseScanner.medicalPadPatterns = {
    "^HMED%d+",
    "^H_MED",
    "^H_MED_ORIG"
}

AirbaseScanner.tacticalPadPatterns = {
    "^HOIL%d+",
    "^H%d$",
    "^H%d_",
    "^T%d$",
    "^T%d_"
}

AirbaseScanner.helipadPatterns = {
    "^HI%d+",
    "^HS%d+",
    "^HC%d+",
    "^HL%d+",
    "^HJ%d+",
    "^HT%d+",
    "^HSTAD%d+"
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
    local prefix = "[TC][AIRBASE_SCANNER]"
    local formatted = prefix .. " " .. tostring(message)

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
        logger.info("[AirbaseScanner] " .. tostring(message))
        return
    end

    rawLog("INFO", message)
end

local function logWarn(message)
    local logger = getLogger()

    if logger ~= nil and logger.warn ~= nil then
        logger.warn("[AirbaseScanner] " .. tostring(message))
        return
    end

    rawLog("WARN", message)
end

local function logError(message)
    local logger = getLogger()

    if logger ~= nil and logger.error ~= nil then
        logger.error("[AirbaseScanner] " .. tostring(message))
        return
    end

    rawLog("ERROR", message)
end

local function logDebug(message)
    local logger = getLogger()

    if logger ~= nil and logger.debug ~= nil then
        logger.debug("[AirbaseScanner] " .. tostring(message))
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

local function containsKeyword(normalizedName, keyword)
    if type(normalizedName) ~= "string" or keyword == nil then
        return false
    end

    local normalizedKeyword = normalizeName(keyword)

    if normalizedKeyword == nil or normalizedKeyword == "" then
        return false
    end

    return string.find(normalizedName, normalizedKeyword, 1, true) ~= nil
end

local function containsAnyKeyword(normalizedName, keywords)
    if type(keywords) ~= "table" then
        return false, nil
    end

    for _, keyword in ipairs(keywords) do
        if containsKeyword(normalizedName, keyword) == true then
            return true, keyword
        end
    end

    return false, nil
end

local function matchesAnyPattern(normalizedName, patterns)
    if type(normalizedName) ~= "string" or type(patterns) ~= "table" then
        return false, nil
    end

    for _, pattern in ipairs(patterns) do
        if string.find(normalizedName, pattern) ~= nil then
            return true, pattern
        end
    end

    return false, nil
end

local function safeCall(object, methodName)
    if object == nil or methodName == nil then
        return nil
    end

    local method = object[methodName]

    if type(method) ~= "function" then
        return nil
    end

    local success, result = pcall(method, object)

    if success == true then
        return result
    end

    return nil
end

local function getDcsCategoryName(categoryId)
    if AirbaseScanner.dcsCategoryNames[categoryId] ~= nil then
        return AirbaseScanner.dcsCategoryNames[categoryId]
    end

    return "UNKNOWN"
end

local function getCoalitionName(coalitionId)
    if coalition ~= nil and coalition.side ~= nil then
        if coalitionId == coalition.side.BLUE then
            return "BLUE"
        end

        if coalitionId == coalition.side.RED then
            return "RED"
        end

        if coalitionId == coalition.side.NEUTRAL then
            return "NEUTRAL"
        end
    end

    if coalitionId == 2 then
        return "BLUE"
    end

    if coalitionId == 1 then
        return "RED"
    end

    if coalitionId == 0 then
        return "NEUTRAL"
    end

    return "UNKNOWN"
end

local function getConfiguredBlueStartBase()
    local config = getConfig()

    if config.campaign ~= nil and config.campaign.blueStartBase ~= nil then
        return tostring(config.campaign.blueStartBase)
    end

    return "AKROTIRI"
end

local function isConfiguredStartBase(normalizedName)
    return containsKeyword(normalizedName, getConfiguredBlueStartBase())
end

local function determineTheatreArea(normalizedName)
    if containsAnyKeyword(normalizedName, AirbaseScanner.cyprusKeywords) == true then
        return "CYPRUS"
    end

    if containsAnyKeyword(normalizedName, AirbaseScanner.syrianMainlandKeywords) == true then
        return "SYRIAN_MAINLAND"
    end

    return "UNKNOWN"
end

local function determineInitialOwner(normalizedName, theatreArea, coalitionName)
    if isConfiguredStartBase(normalizedName) == true then
        return "BLUE"
    end

    if theatreArea == "CYPRUS" then
        return "BLUE"
    end

    if theatreArea == "SYRIAN_MAINLAND" then
        return "RED"
    end

    if coalitionName == "BLUE" or coalitionName == "RED" or coalitionName == "NEUTRAL" then
        return coalitionName
    end

    return "UNKNOWN"
end

local function classifyAirbase(normalizedName, dcsCategoryName)
    if isConfiguredStartBase(normalizedName) == true then
        return AirbaseScanner.Categories.STRATEGIC_AIRFIELD, "configured_blue_start_base", getConfiguredBlueStartBase()
    end

    local isStrategic, strategicKeyword = containsAnyKeyword(normalizedName, AirbaseScanner.strategicAirfieldKeywords)

    if isStrategic == true then
        return AirbaseScanner.Categories.STRATEGIC_AIRFIELD, "strategic_airfield_keyword", strategicKeyword
    end

    local isSecondary, secondaryKeyword = containsAnyKeyword(normalizedName, AirbaseScanner.secondaryAirfieldKeywords)

    if isSecondary == true then
        return AirbaseScanner.Categories.SECONDARY_AIRFIELD, "secondary_airfield_keyword", secondaryKeyword
    end

    local isMedical, medicalKeyword = containsAnyKeyword(normalizedName, AirbaseScanner.medicalPadKeywords)

    if isMedical == true then
        return AirbaseScanner.Categories.MEDICAL_PAD, "medical_pad_keyword", medicalKeyword
    end

    local isMedicalPattern, medicalPattern = matchesAnyPattern(normalizedName, AirbaseScanner.medicalPadPatterns)

    if isMedicalPattern == true then
        return AirbaseScanner.Categories.MEDICAL_PAD, "medical_pad_pattern", medicalPattern
    end

    local isFarp, farpKeyword = containsAnyKeyword(normalizedName, AirbaseScanner.farpKeywords)

    if isFarp == true then
        return AirbaseScanner.Categories.FARP, "farp_keyword", farpKeyword
    end

    local isHeliport, heliportKeyword = containsAnyKeyword(normalizedName, AirbaseScanner.heliportKeywords)

    if isHeliport == true then
        return AirbaseScanner.Categories.HELIPORT, "heliport_keyword", heliportKeyword
    end

    local isTactical, tacticalKeyword = containsAnyKeyword(normalizedName, AirbaseScanner.tacticalPadKeywords)

    if isTactical == true then
        return AirbaseScanner.Categories.TACTICAL_PAD, "tactical_pad_keyword", tacticalKeyword
    end

    local isTacticalPattern, tacticalPattern = matchesAnyPattern(normalizedName, AirbaseScanner.tacticalPadPatterns)

    if isTacticalPattern == true then
        return AirbaseScanner.Categories.TACTICAL_PAD, "tactical_pad_pattern", tacticalPattern
    end

    local isHelipad, helipadKeyword = containsAnyKeyword(normalizedName, AirbaseScanner.helipadKeywords)

    if isHelipad == true then
        return AirbaseScanner.Categories.HELIPAD, "helipad_keyword", helipadKeyword
    end

    local isHelipadPattern, helipadPattern = matchesAnyPattern(normalizedName, AirbaseScanner.helipadPatterns)

    if isHelipadPattern == true then
        return AirbaseScanner.Categories.HELIPAD, "helipad_pattern", helipadPattern
    end

    if dcsCategoryName == "AIRDROME" then
        return AirbaseScanner.Categories.SECONDARY_AIRFIELD, "dcs_airdrome_default", nil
    end

    if dcsCategoryName == "HELIPAD" then
        return AirbaseScanner.Categories.HELIPAD, "dcs_helipad_default", nil
    end

    return AirbaseScanner.Categories.UNKNOWN, "unknown_airbase_like_object", nil
end

local function calculateStrategicRelevance(classification, theatreArea, currentOwner, startBase)
    local relevance = 0

    if classification == AirbaseScanner.Categories.STRATEGIC_AIRFIELD then
        relevance = 85
    elseif classification == AirbaseScanner.Categories.SECONDARY_AIRFIELD then
        relevance = 60
    elseif classification == AirbaseScanner.Categories.HELIPORT then
        relevance = 45
    elseif classification == AirbaseScanner.Categories.FARP then
        relevance = 40
    elseif classification == AirbaseScanner.Categories.TACTICAL_PAD then
        relevance = 25
    elseif classification == AirbaseScanner.Categories.HELIPAD then
        relevance = 20
    elseif classification == AirbaseScanner.Categories.MEDICAL_PAD then
        relevance = 10
    else
        relevance = 0
    end

    if startBase == true then
        relevance = 100
    elseif theatreArea == "SYRIAN_MAINLAND" and classification == AirbaseScanner.Categories.STRATEGIC_AIRFIELD then
        relevance = relevance + 10
    elseif theatreArea == "CYPRUS" and currentOwner == "BLUE" then
        relevance = relevance + 5
    end

    if relevance > 100 then
        relevance = 100
    end

    if relevance < 0 then
        relevance = 0
    end

    return relevance
end

local function getZoneProfile(classification)
    if classification == AirbaseScanner.Categories.STRATEGIC_AIRFIELD then
        return {
            zoneClass = "STRATEGIC_AIRBASE_ZONE",
            recommendedRadius = 12000,
            createCaptureZone = true,
            createMissionZone = true,
            createLogisticsZone = true
        }
    end

    if classification == AirbaseScanner.Categories.SECONDARY_AIRFIELD then
        return {
            zoneClass = "SECONDARY_AIRBASE_ZONE",
            recommendedRadius = 8000,
            createCaptureZone = true,
            createMissionZone = true,
            createLogisticsZone = true
        }
    end

    if classification == AirbaseScanner.Categories.HELIPORT then
        return {
            zoneClass = "HELIPORT_ZONE",
            recommendedRadius = 4000,
            createCaptureZone = false,
            createMissionZone = false,
            createLogisticsZone = true
        }
    end

    if classification == AirbaseScanner.Categories.FARP then
        return {
            zoneClass = "FARP_ZONE",
            recommendedRadius = 3500,
            createCaptureZone = false,
            createMissionZone = false,
            createLogisticsZone = true
        }
    end

    if classification == AirbaseScanner.Categories.TACTICAL_PAD then
        return {
            zoneClass = "TACTICAL_PAD_ZONE",
            recommendedRadius = 2500,
            createCaptureZone = false,
            createMissionZone = false,
            createLogisticsZone = true
        }
    end

    if classification == AirbaseScanner.Categories.HELIPAD then
        return {
            zoneClass = "HELIPAD_ZONE",
            recommendedRadius = 2000,
            createCaptureZone = false,
            createMissionZone = false,
            createLogisticsZone = false
        }
    end

    if classification == AirbaseScanner.Categories.MEDICAL_PAD then
        return {
            zoneClass = "MEDICAL_PAD_ZONE",
            recommendedRadius = 1500,
            createCaptureZone = false,
            createMissionZone = false,
            createLogisticsZone = false
        }
    end

    return {
        zoneClass = "UNKNOWN_AIRBASE_OBJECT_ZONE",
        recommendedRadius = 1000,
        createCaptureZone = false,
        createMissionZone = false,
        createLogisticsZone = false
    }
end

local function createEmptyClassificationLists()
    return {
        all = {},
        strategicAirfields = {},
        secondaryAirfields = {},
        heliports = {},
        helipads = {},
        medicalPads = {},
        farps = {},
        tacticalPads = {},
        unknown = {},
        captureCandidates = {},
        missionCandidates = {},
        logisticsCandidates = {},
        blueStartBases = {},
        potentialRedStrategicBases = {}
    }
end

AirbaseScanner.classificationLists = createEmptyClassificationLists()

local function ensureStateTables()
    local state = getState()

    if state == nil then
        return nil
    end

    state.World = state.World or {}
    state.Bases = state.Bases or {}

    state.Bases.total = 0
    state.Bases.blue = 0
    state.Bases.red = 0
    state.Bases.neutral = 0
    state.Bases.contested = 0
    state.Bases.unknown = 0

    state.Bases.registry = {}
    state.Bases.byClassification = {}

    for _, category in ipairs(AirbaseScanner.categoryOrder) do
        state.Bases.byClassification[category] = {}
    end

    state.Bases.strategicAirfields = {}
    state.Bases.secondaryAirfields = {}
    state.Bases.heliports = {}
    state.Bases.helipads = {}
    state.Bases.medicalPads = {}
    state.Bases.farps = {}
    state.Bases.tacticalPads = {}

    state.Bases.unknownAirbaseObjects = {}

    state.Bases.captureCandidates = {}
    state.Bases.missionCandidates = {}
    state.Bases.logisticsCandidates = {}
    state.Bases.blueStartBases = {}
    state.Bases.potentialRedStrategicBases = {}

    state.Bases.classificationCounts = {
        total = 0,
        strategicAirfields = 0,
        secondaryAirfields = 0,
        heliports = 0,
        helipads = 0,
        medicalPads = 0,
        farps = 0,
        tacticalPads = 0,
        unknown = 0
    }

    for _, category in ipairs(AirbaseScanner.categoryOrder) do
        state.Bases.classificationCounts[category] = 0
    end

    state.World.airbaseScan = {
        completed = false,
        scannedAt = nil,
        totalDetected = 0,
        classificationReady = false
    }

    return state
end

local function resetScannerTables()
    AirbaseScanner.registry = {}
    AirbaseScanner.classificationLists = createEmptyClassificationLists()

    TC.World.Airbases = {}
    TC.World.AirbaseClassifications = AirbaseScanner.classificationLists
end

local function getScannerListName(classification)
    if classification == AirbaseScanner.Categories.STRATEGIC_AIRFIELD then
        return "strategicAirfields"
    end

    if classification == AirbaseScanner.Categories.SECONDARY_AIRFIELD then
        return "secondaryAirfields"
    end

    if classification == AirbaseScanner.Categories.HELIPORT then
        return "heliports"
    end

    if classification == AirbaseScanner.Categories.HELIPAD then
        return "helipads"
    end

    if classification == AirbaseScanner.Categories.MEDICAL_PAD then
        return "medicalPads"
    end

    if classification == AirbaseScanner.Categories.FARP then
        return "farps"
    end

    if classification == AirbaseScanner.Categories.TACTICAL_PAD then
        return "tacticalPads"
    end

    return "unknown"
end

local function getStateListName(classification)
    if classification == AirbaseScanner.Categories.UNKNOWN then
        return "unknownAirbaseObjects"
    end

    return getScannerListName(classification)
end

local function addRecordToList(targetList, key, record)
    if type(targetList) ~= "table" then
        return false
    end

    if key == nil or record == nil then
        return false
    end

    targetList[key] = record
    return true
end

local function incrementOwnerCounter(state, owner)
    if state == nil or state.Bases == nil then
        return
    end

    if owner == "BLUE" then
        state.Bases.blue = (state.Bases.blue or 0) + 1
    elseif owner == "RED" then
        state.Bases.red = (state.Bases.red or 0) + 1
    elseif owner == "NEUTRAL" then
        state.Bases.neutral = (state.Bases.neutral or 0) + 1
    elseif owner == "CONTESTED" then
        state.Bases.contested = (state.Bases.contested or 0) + 1
    else
        state.Bases.unknown = (state.Bases.unknown or 0) + 1
    end
end

local function incrementClassificationCounter(state, classification, scannerListName)
    if state == nil or state.Bases == nil or state.Bases.classificationCounts == nil then
        return
    end

    state.Bases.classificationCounts.total = (state.Bases.classificationCounts.total or 0) + 1
    state.Bases.classificationCounts[classification] = (state.Bases.classificationCounts[classification] or 0) + 1
    state.Bases.classificationCounts[scannerListName] = (state.Bases.classificationCounts[scannerListName] or 0) + 1
end

local function markStateDirty(reason)
    local state = getState()

    if state ~= nil and state.markDirty ~= nil then
        state.markDirty(reason or "airbase_scanner")
    end
end

local function setModuleStatus(status)
    local state = getState()

    if state ~= nil and state.setModuleStatus ~= nil then
        state.setModuleStatus("airbaseScanner", status)
    end
end

local function setFeatureStatus(enabled)
    local state = getState()

    if state ~= nil and state.setFeatureStatus ~= nil then
        state.setFeatureStatus("airbaseScanner", enabled)
    end
end

local function makeUniqueKey(baseKey, index)
    local key = baseKey or ("UNKNOWN_AIRBASE_" .. tostring(index or 0))

    if key == "" or key == "UNKNOWN" or key == "UNKNOWN_AIRBASE" then
        key = "UNKNOWN_AIRBASE_" .. tostring(index or 0)
    end

    if AirbaseScanner.registry[key] == nil then
        return key
    end

    local suffix = 2
    local candidate = key .. "_" .. tostring(suffix)

    while AirbaseScanner.registry[candidate] ~= nil do
        suffix = suffix + 1
        candidate = key .. "_" .. tostring(suffix)
    end

    return candidate
end

local function getAirbaseName(airbaseObject)
    local name = safeCall(airbaseObject, "getName")

    if name == nil or name == "" then
        return "UNKNOWN_AIRBASE"
    end

    return tostring(name)
end

local function getAirbasePosition(airbaseObject)
    local point = safeCall(airbaseObject, "getPoint")

    if type(point) == "table" then
        return {
            x = point.x or 0,
            y = point.y or 0,
            z = point.z or 0
        }
    end

    return {
        x = 0,
        y = 0,
        z = 0
    }
end

local function getAirbaseCoalitionId(airbaseObject)
    local coalitionId = safeCall(airbaseObject, "getCoalition")

    if coalitionId ~= nil then
        return coalitionId
    end

    return 0
end

local function getAirbaseDescription(airbaseObject)
    local description = safeCall(airbaseObject, "getDesc")

    if type(description) == "table" then
        return description
    end

    return {}
end

local function getAirbaseCategoryId(airbaseObject)
    local categoryId = safeCall(airbaseObject, "getCategory")

    if categoryId ~= nil then
        return categoryId
    end

    local description = getAirbaseDescription(airbaseObject)

    if description.category ~= nil then
        return description.category
    end

    return -1
end

local function createAirbaseRecord(airbaseObject, index)
    local name = getAirbaseName(airbaseObject)
    local normalizedName = normalizeName(name)
    local key = makeUniqueKey(normalizedName, index)

    local position = getAirbasePosition(airbaseObject)
    local coalitionId = getAirbaseCoalitionId(airbaseObject)
    local coalitionName = getCoalitionName(coalitionId)
    local dcsCategoryId = getAirbaseCategoryId(airbaseObject)
    local dcsCategoryName = getDcsCategoryName(dcsCategoryId)
    local description = getAirbaseDescription(airbaseObject)

    local theatreArea = determineTheatreArea(normalizedName)
    local startBase = isConfiguredStartBase(normalizedName)
    local initialOwner = determineInitialOwner(normalizedName, theatreArea, coalitionName)

    local classification, classificationReason, classificationKeyword = classifyAirbase(normalizedName, dcsCategoryName)
    local strategicRelevance = calculateStrategicRelevance(classification, theatreArea, initialOwner, startBase)
    local zoneProfile = getZoneProfile(classification)

    local isStrategicAirfield = classification == AirbaseScanner.Categories.STRATEGIC_AIRFIELD
    local isSecondaryAirfield = classification == AirbaseScanner.Categories.SECONDARY_AIRFIELD
    local isHeliport = classification == AirbaseScanner.Categories.HELIPORT
    local isHelipad = classification == AirbaseScanner.Categories.HELIPAD
    local isMedicalPad = classification == AirbaseScanner.Categories.MEDICAL_PAD
    local isFarp = classification == AirbaseScanner.Categories.FARP
    local isTacticalPad = classification == AirbaseScanner.Categories.TACTICAL_PAD
    local isUnknown = classification == AirbaseScanner.Categories.UNKNOWN

    local isCaptureCandidate = isStrategicAirfield == true or isSecondaryAirfield == true
    local isMissionCandidate = isStrategicAirfield == true or isSecondaryAirfield == true
    local isLogisticsCandidate =
        startBase == true
        or isStrategicAirfield == true
        or isSecondaryAirfield == true
        or isHeliport == true
        or isFarp == true
        or isTacticalPad == true

    local isPotentialRedStrategicBase =
        theatreArea == "SYRIAN_MAINLAND"
        and initialOwner == "RED"
        and isStrategicAirfield == true

    return {
        key = key,
        name = name,
        displayName = name,
        normalizedName = normalizedName,

        source = "DCS_WORLD_AIRBASE_SCAN",
        index = index or 0,
        scannedAt = getCurrentTime(),

        dcsObject = airbaseObject,
        dcsDescription = description,
        dcsCategoryId = dcsCategoryId,
        dcsCategoryName = dcsCategoryName,

        categoryId = dcsCategoryId,
        categoryName = dcsCategoryName,
        coalitionId = coalitionId,
        coalitionName = coalitionName,
        position = position,

        classification = classification,
        classificationReason = classificationReason,
        classificationKeyword = classificationKeyword,
        airbaseType = classification,
        strategicRelevance = strategicRelevance,
        zoneProfile = zoneProfile,

        theatreArea = theatreArea,
        initialOwner = initialOwner,
        currentOwner = initialOwner,
        owner = initialOwner,
        status = "ACTIVE",

        isStartBase = startBase,
        isCyprus = theatreArea == "CYPRUS",
        isSyrianMainland = theatreArea == "SYRIAN_MAINLAND",

        isStrategicAirfield = isStrategicAirfield,
        isSecondaryAirfield = isSecondaryAirfield,
        isHeliport = isHeliport,
        isHelipad = isHelipad,
        isMedicalPad = isMedicalPad,
        isFarp = isFarp,
        isTacticalPad = isTacticalPad,
        isUnknownAirbaseObject = isUnknown,

        isCaptureCandidate = isCaptureCandidate,
        isMissionCandidate = isMissionCandidate,
        isLogisticsCandidate = isLogisticsCandidate,
        isPotentialRedStrategicBase = isPotentialRedStrategicBase,

        canCreateCaptureZone = zoneProfile.createCaptureZone,
        canCreateMissionZone = zoneProfile.createMissionZone,
        canCreateLogisticsZone = zoneProfile.createLogisticsZone,
        recommendedZoneRadius = zoneProfile.recommendedRadius,
        recommendedZoneClass = zoneProfile.zoneClass
    }
end

local function registerClassification(state, record)
    local scannerListName = getScannerListName(record.classification)
    local stateListName = getStateListName(record.classification)

    addRecordToList(AirbaseScanner.classificationLists.all, record.key, record)
    addRecordToList(AirbaseScanner.classificationLists[scannerListName], record.key, record)

    if state ~= nil and state.Bases ~= nil then
        addRecordToList(state.Bases.byClassification[record.classification], record.key, record)
        addRecordToList(state.Bases[stateListName], record.key, record)
        incrementClassificationCounter(state, record.classification, scannerListName)
    end

    if record.isCaptureCandidate == true then
        addRecordToList(AirbaseScanner.classificationLists.captureCandidates, record.key, record)

        if state ~= nil and state.Bases ~= nil then
            addRecordToList(state.Bases.captureCandidates, record.key, record)
        end
    end

    if record.isMissionCandidate == true then
        addRecordToList(AirbaseScanner.classificationLists.missionCandidates, record.key, record)

        if state ~= nil and state.Bases ~= nil then
            addRecordToList(state.Bases.missionCandidates, record.key, record)
        end
    end

    if record.isLogisticsCandidate == true then
        addRecordToList(AirbaseScanner.classificationLists.logisticsCandidates, record.key, record)

        if state ~= nil and state.Bases ~= nil then
            addRecordToList(state.Bases.logisticsCandidates, record.key, record)
        end
    end

    if record.isStartBase == true then
        addRecordToList(AirbaseScanner.classificationLists.blueStartBases, record.key, record)

        if state ~= nil and state.Bases ~= nil then
            addRecordToList(state.Bases.blueStartBases, record.key, record)
            state.Bases.blueStartBase = record
        end
    end

    if record.isPotentialRedStrategicBase == true then
        addRecordToList(AirbaseScanner.classificationLists.potentialRedStrategicBases, record.key, record)

        if state ~= nil and state.Bases ~= nil then
            addRecordToList(state.Bases.potentialRedStrategicBases, record.key, record)
        end
    end
end

local function registerAirbase(state, record)
    if record == nil or record.key == nil then
        return false
    end

    AirbaseScanner.registry[record.key] = record
    TC.World.Airbases[record.key] = record

    if state ~= nil and state.Bases ~= nil then
        state.Bases.registry[record.key] = record
        state.Bases.total = (state.Bases.total or 0) + 1
        incrementOwnerCounter(state, record.currentOwner)
    end

    registerClassification(state, record)

    return true
end

local function buildClassificationSummary()
    local lists = AirbaseScanner.classificationLists

    return {
        total = countTableKeys(lists.all),
        strategicAirfields = countTableKeys(lists.strategicAirfields),
        secondaryAirfields = countTableKeys(lists.secondaryAirfields),
        heliports = countTableKeys(lists.heliports),
        helipads = countTableKeys(lists.helipads),
        medicalPads = countTableKeys(lists.medicalPads),
        farps = countTableKeys(lists.farps),
        tacticalPads = countTableKeys(lists.tacticalPads),
        unknown = countTableKeys(lists.unknown),
        captureCandidates = countTableKeys(lists.captureCandidates),
        missionCandidates = countTableKeys(lists.missionCandidates),
        logisticsCandidates = countTableKeys(lists.logisticsCandidates),
        blueStartBases = countTableKeys(lists.blueStartBases),
        potentialRedStrategicBases = countTableKeys(lists.potentialRedStrategicBases)
    }
end

local function buildClassificationSummaryText(summary)
    return "total=" .. tostring(summary.total)
        .. ", strategic=" .. tostring(summary.strategicAirfields)
        .. ", secondary=" .. tostring(summary.secondaryAirfields)
        .. ", heliports=" .. tostring(summary.heliports)
        .. ", helipads=" .. tostring(summary.helipads)
        .. ", medical=" .. tostring(summary.medicalPads)
        .. ", farps=" .. tostring(summary.farps)
        .. ", tactical=" .. tostring(summary.tacticalPads)
        .. ", unknown=" .. tostring(summary.unknown)
        .. ", captureCandidates=" .. tostring(summary.captureCandidates)
        .. ", missionCandidates=" .. tostring(summary.missionCandidates)
        .. ", logisticsCandidates=" .. tostring(summary.logisticsCandidates)
        .. ", blueStartBases=" .. tostring(summary.blueStartBases)
        .. ", redStrategicCandidates=" .. tostring(summary.potentialRedStrategicBases)
end

local function updateWorldScanState(state, detectedCount)
    if state == nil then
        return
    end

    state.World = state.World or {}
    state.World.airbaseScan = state.World.airbaseScan or {}

    state.World.airbaseScan.completed = true
    state.World.airbaseScan.scannedAt = AirbaseScanner.lastScanTime
    state.World.airbaseScan.totalDetected = detectedCount
    state.World.airbaseScan.classificationReady = true
    state.World.airbaseScan.summary = buildClassificationSummary()
end

function AirbaseScanner.scan()
    if world == nil or world.getAirbases == nil then
        AirbaseScanner.failed = true
        setModuleStatus("FAILED")
        setFeatureStatus(false)
        logError("Cannot scan airbases: world.getAirbases is unavailable")
        return false
    end

    local state = ensureStateTables()
    resetScannerTables()

    local success, airbases = pcall(world.getAirbases)

    if success ~= true or type(airbases) ~= "table" then
        AirbaseScanner.failed = true
        setModuleStatus("FAILED")
        setFeatureStatus(false)
        logError("Cannot scan airbases: world.getAirbases call failed")
        return false
    end

    local detectedCount = 0

    for index, airbaseObject in ipairs(airbases) do
        local recordSuccess, record = pcall(createAirbaseRecord, airbaseObject, index)

        if recordSuccess == true and record ~= nil then
            if registerAirbase(state, record) == true then
                detectedCount = detectedCount + 1
            end
        else
            logWarn("Skipped airbase-like object at index " .. tostring(index) .. " because record creation failed")
        end
    end

    AirbaseScanner.lastScanTime = getCurrentTime()
    AirbaseScanner.lastScanCount = detectedCount
    AirbaseScanner.finished = true
    AirbaseScanner.failed = false

    updateWorldScanState(state, detectedCount)
    markStateDirty("airbase_scan_completed")

    local summary = buildClassificationSummary()

    logInfo("Airbase scan completed: " .. tostring(detectedCount) .. " airbase-like objects registered")
    logInfo("Airbase classification summary: " .. buildClassificationSummaryText(summary))

    local startBase = AirbaseScanner.getStartBase()

    if startBase ~= nil then
        logInfo(
            "Blue start base confirmed: "
            .. tostring(startBase.name)
            .. " classified as "
            .. tostring(startBase.classification)
            .. " with strategicRelevance="
            .. tostring(startBase.strategicRelevance)
        )
    else
        logWarn("Blue start base was not found during airbase scan")
    end

    setModuleStatus("READY")
    setFeatureStatus(true)

    return true
end

function AirbaseScanner.start()
    if AirbaseScanner.started == true and AirbaseScanner.finished == true and AirbaseScanner.failed ~= true then
        logDebug("Airbase scanner already started")
        return true
    end

    AirbaseScanner.started = true
    AirbaseScanner.finished = false
    AirbaseScanner.failed = false

    setModuleStatus("STARTING")
    setFeatureStatus(false)

    logInfo("Starting airbase scanner")

    local success = AirbaseScanner.scan()

    if success == true then
        logInfo("Airbase scanner started successfully")
        return true
    end

    AirbaseScanner.failed = true
    logError("Airbase scanner failed")
    return false
end

function AirbaseScanner.stop()
    AirbaseScanner.started = false
    logInfo("Airbase scanner stopped")
    return true
end

function AirbaseScanner.getRegistry()
    return AirbaseScanner.registry
end

function AirbaseScanner.getClassificationLists()
    return AirbaseScanner.classificationLists
end

function AirbaseScanner.getClassificationSummary()
    return buildClassificationSummary()
end

function AirbaseScanner.getAirbase(key)
    if key == nil then
        return nil
    end

    local direct = AirbaseScanner.registry[key]

    if direct ~= nil then
        return direct
    end

    local normalizedKey = normalizeName(key)

    return AirbaseScanner.registry[normalizedKey]
end

function AirbaseScanner.getAirbaseByName(name)
    if name == nil then
        return nil
    end

    local normalizedSearchName = normalizeName(name)

    for _, record in pairs(AirbaseScanner.registry) do
        if record.normalizedName == normalizedSearchName then
            return record
        end

        if containsKeyword(record.normalizedName, normalizedSearchName) == true then
            return record
        end
    end

    return nil
end

function AirbaseScanner.getStartBase()
    for _, record in pairs(AirbaseScanner.registry) do
        if record.isStartBase == true then
            return record
        end
    end

    return nil
end

function AirbaseScanner.getCount()
    return countTableKeys(AirbaseScanner.registry)
end

function AirbaseScanner.getByOwner(owner)
    local result = {}

    if owner == nil then
        return result
    end

    local normalizedOwner = string.upper(tostring(owner))

    for key, record in pairs(AirbaseScanner.registry) do
        if record.currentOwner == normalizedOwner then
            result[key] = record
        end
    end

    return result
end

function AirbaseScanner.getByTheatreArea(theatreArea)
    local result = {}

    if theatreArea == nil then
        return result
    end

    local normalizedArea = string.upper(tostring(theatreArea))

    for key, record in pairs(AirbaseScanner.registry) do
        if record.theatreArea == normalizedArea then
            result[key] = record
        end
    end

    return result
end

function AirbaseScanner.getByClassification(classification)
    local result = {}

    if classification == nil then
        return result
    end

    local normalizedClassification = string.upper(tostring(classification))

    for key, record in pairs(AirbaseScanner.registry) do
        if record.classification == normalizedClassification then
            result[key] = record
        end
    end

    return result
end

function AirbaseScanner.getStrategicAirfields()
    return AirbaseScanner.classificationLists.strategicAirfields
end

function AirbaseScanner.getSecondaryAirfields()
    return AirbaseScanner.classificationLists.secondaryAirfields
end

function AirbaseScanner.getHeliports()
    return AirbaseScanner.classificationLists.heliports
end

function AirbaseScanner.getHelipads()
    return AirbaseScanner.classificationLists.helipads
end

function AirbaseScanner.getMedicalPads()
    return AirbaseScanner.classificationLists.medicalPads
end

function AirbaseScanner.getFarps()
    return AirbaseScanner.classificationLists.farps
end

function AirbaseScanner.getTacticalPads()
    return AirbaseScanner.classificationLists.tacticalPads
end

function AirbaseScanner.getUnknownAirbaseObjects()
    return AirbaseScanner.classificationLists.unknown
end

function AirbaseScanner.getCaptureCandidates()
    return AirbaseScanner.classificationLists.captureCandidates
end

function AirbaseScanner.getMissionCandidates()
    return AirbaseScanner.classificationLists.missionCandidates
end

function AirbaseScanner.getLogisticsCandidates()
    return AirbaseScanner.classificationLists.logisticsCandidates
end

function AirbaseScanner.getPotentialRedStrategicBases()
    return AirbaseScanner.classificationLists.potentialRedStrategicBases
end

function AirbaseScanner.summary()
    local summary = buildClassificationSummary()

    return {
        name = AirbaseScanner.name,
        displayName = AirbaseScanner.displayName,
        path = AirbaseScanner.path,
        version = AirbaseScanner.version,
        loaded = AirbaseScanner.loaded,
        started = AirbaseScanner.started,
        finished = AirbaseScanner.finished,
        failed = AirbaseScanner.failed,
        lastScanTime = AirbaseScanner.lastScanTime,
        lastScanCount = AirbaseScanner.lastScanCount,
        total = summary.total,
        classification = summary
    }
end

TC.World.AirbaseScanner = AirbaseScanner
TC.world.AirbaseScanner = AirbaseScanner

TC.modules.airbaseScanner = {
    name = AirbaseScanner.name,
    path = AirbaseScanner.path,
    loaded = true,
    version = AirbaseScanner.version
}

setModuleStatus("LOADED")
logInfo("Loaded " .. AirbaseScanner.path .. " v" .. AirbaseScanner.version)

return AirbaseScanner
