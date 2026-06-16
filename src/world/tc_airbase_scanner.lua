-- Theater Command DCS
-- File: src/world/tc_airbase_scanner.lua
--
-- Purpose:
--   Scans all DCS airbase-like objects on the active map and converts them
--   into Theater Command world records.
--
-- Current focus:
--   Syria returns many Airbase objects, including airfields, heliports,
--   helipads, medical pads, FARPs and other tactical pads. These objects must
--   not all be treated as strategic campaign airfields.
--
-- Responsibilities:
--   - scan DCS world airbases safely
--   - classify every detected object
--   - identify Akrotiri as the Blue strategic start base
--   - prepare Syrian mainland major airfields as potential strategic Red bases
--   - calculate strategic relevance
--   - store separate classified lists in TC.State.Bases
--   - keep compatibility with ZoneFactory and later campaign systems

TC = TC or {}
TC.modules = TC.modules or {}
TC.World = TC.World or {}
TC.world = TC.world or TC.World

local AirbaseScanner = {}

AirbaseScanner.name = "TC_AirbaseScanner"
AirbaseScanner.path = "src/world/tc_airbase_scanner.lua"
AirbaseScanner.version = "0.2.0"

AirbaseScanner.loaded = false
AirbaseScanner.started = false
AirbaseScanner.finished = false
AirbaseScanner.failed = false

AirbaseScanner.registry = {}
AirbaseScanner.lastScanTime = nil
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
    "DAMASCUS",
    "ALEPPO",
    "LATAKIA",
    "LATAKIA",
    "HMEIMIM",
    "KHMEIMIM",
    "BASSEL",
    "HAMA",
    "HOMS",
    "PALMYRA",
    "TADMUR",
    "TIYAS",
    "T-4",
    "T4",
    "SHAYRAT",
    "DUMAYR",
    "AL-DUMAYR",
    "AD DUMAYR",
    "SAYQAL",
    "MEZZEH",
    "ABU AL-DUHUR",
    "ABU DUHUR",
    "KUWEIRES",
    "JIRAH",
    "TABQA",
    "DEIR",
    "DEIR EZ-ZOR",
    "DEIR EZZOR",
    "DEIR ZOR",
    "MINAKH",
    "MENAGH",
    "TAFTANAZ",
    "KHALKHALAH",
    "MARJ",
    "RUHAYYIL",
    "RAYAK",
    "NAJAB"
}

AirbaseScanner.strategicAirfieldKeywords = {
    "AKROTIRI",
    "DAMASCUS",
    "ALEPPO",
    "LATAKIA",
    "HMEIMIM",
    "KHMEIMIM",
    "BASSEL",
    "HAMA",
    "PALMYRA",
    "TADMUR",
    "TIYAS",
    "T-4",
    "T4",
    "SHAYRAT",
    "DUMAYR",
    "AL-DUMAYR",
    "AD DUMAYR",
    "SAYQAL",
    "MEZZEH",
    "ABU AL-DUHUR",
    "ABU DUHUR",
    "KUWEIRES",
    "JIRAH",
    "TABQA",
    "DEIR EZ-ZOR",
    "DEIR EZZOR",
    "DEIR ZOR",
    "MINAKH",
    "MENAGH",
    "TAFTANAZ",
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
    "MARJ",
    "RAYAK",
    "NAJAB",
    "RUHAYYIL"
}

AirbaseScanner.medicalPadKeywords = {
    "MEDICAL",
    "MEDEVAC",
    "CASEVAC",
    "HOSPITAL",
    "FIELD HOSPITAL",
    "MASH",
    "AID STATION",
    "MED PAD",
    "MEDICAL PAD"
}

AirbaseScanner.farpKeywords = {
    "FARP",
    "FORWARD ARMING",
    "FORWARD REFUELING",
    "FORWARD REFUELLING",
    "FORWARD OPERATING"
}

AirbaseScanner.heliportKeywords = {
    "HELIPORT",
    "HELI PORT",
    "HELISTATION",
    "HELI STATION",
    "HELIBASE",
    "HELI BASE"
}

AirbaseScanner.helipadKeywords = {
    "HELIPAD",
    "HELI PAD",
    "PAD",
    "LANDING PAD"
}

AirbaseScanner.tacticalPadKeywords = {
    "FOB",
    "OUTPOST",
    "TACTICAL",
    "LZ",
    "LANDING ZONE",
    "ROADBASE",
    "ROAD BASE",
    "CHECKPOINT",
    "PATROL BASE",
    "COMBAT OUTPOST"
}

local function getLogger()
    if TC and TC.Core and TC.Core.Logger then
        return TC.Core.Logger
    end

    if TC and TC.Logger then
        return TC.Logger
    end

    return nil
end

local function logInfo(message)
    local logger = getLogger()

    if logger and logger.info then
        logger.info(AirbaseScanner.name, message)
    else
        env.info("[" .. AirbaseScanner.name .. "] " .. message)
    end
end

local function logWarn(message)
    local logger = getLogger()

    if logger and logger.warn then
        logger.warn(AirbaseScanner.name, message)
    else
        env.warning("[" .. AirbaseScanner.name .. "] " .. message)
    end
end

local function logError(message)
    local logger = getLogger()

    if logger and logger.error then
        logger.error(AirbaseScanner.name, message)
    else
        env.error("[" .. AirbaseScanner.name .. "] " .. message)
    end
end

local function logDebug(message)
    local logger = getLogger()

    if logger and logger.debug then
        logger.debug(AirbaseScanner.name, message)
    end
end

local function getConfig()
    if TC and TC.Core and TC.Core.Config then
        return TC.Core.Config
    end

    if TC and TC.Config then
        return TC.Config
    end

    return nil
end

local function getState()
    if TC and TC.Core and TC.Core.State then
        return TC.Core.State
    end

    if TC and TC.State then
        return TC.State
    end

    return nil
end

local function getUtils()
    if TC and TC.Core and TC.Core.Utils then
        return TC.Core.Utils
    end

    if TC and TC.Utils then
        return TC.Utils
    end

    return nil
end

local function getCurrentTime()
    local utils = getUtils()

    if utils and utils.getCurrentTime then
        return utils.getCurrentTime()
    end

    if timer and timer.getTime then
        return timer.getTime()
    end

    return 0
end

local function normalizeName(value)
    local utils = getUtils()

    if utils and utils.normalizeName then
        return utils.normalizeName(value)
    end

    if value == nil then
        return "UNKNOWN"
    end

    local text = tostring(value)
    text = string.upper(text)
    text = string.gsub(text, "%s+", "_")
    text = string.gsub(text, "[^A-Z0-9_%-]", "_")
    text = string.gsub(text, "_+", "_")
    return text
end

local function readableName(value)
    if value == nil then
        return "UNKNOWN"
    end

    return tostring(value)
end

local function tableCount(source)
    local count = 0

    if source then
        for _ in pairs(source) do
            count = count + 1
        end
    end

    return count
end

local function containsKeyword(normalizedNameValue, keyword)
    if normalizedNameValue == nil or keyword == nil then
        return false
    end

    local nameValue = tostring(normalizedNameValue)
    local normalizedKeyword = normalizeName(keyword)

    return string.find(nameValue, normalizedKeyword, 1, true) ~= nil
end

local function containsAnyKeyword(normalizedNameValue, keywords)
    if normalizedNameValue == nil or keywords == nil then
        return false
    end

    for _, keyword in ipairs(keywords) do
        if containsKeyword(normalizedNameValue, keyword) then
            return true, keyword
        end
    end

    return false, nil
end

local function safeMethodCall(object, methodName)
    if object == nil or methodName == nil then
        return nil
    end

    local method = object[methodName]

    if type(method) ~= "function" then
        return nil
    end

    local success, result = pcall(method, object)

    if success then
        return result
    end

    return nil
end

local function getAirbaseName(airbaseObject)
    local name = safeMethodCall(airbaseObject, "getName")

    if name ~= nil and name ~= "" then
        return tostring(name)
    end

    return "UNKNOWN_AIRBASE"
end

local function getAirbasePoint(airbaseObject)
    local point = safeMethodCall(airbaseObject, "getPoint")

    if point ~= nil then
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
    local coalitionId = safeMethodCall(airbaseObject, "getCoalition")

    if coalitionId ~= nil then
        return coalitionId
    end

    return 0
end

local function getCoalitionName(coalitionId)
    local utils = getUtils()

    if utils and utils.getCoalitionName then
        return utils.getCoalitionName(coalitionId)
    end

    if coalition and coalition.side then
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

local function getAirbaseDesc(airbaseObject)
    local desc = safeMethodCall(airbaseObject, "getDesc")

    if type(desc) == "table" then
        return desc
    end

    return {}
end

local function getAirbaseCategory(airbaseObject)
    local categoryId = safeMethodCall(airbaseObject, "getCategory")

    if categoryId ~= nil then
        return categoryId
    end

    local desc = getAirbaseDesc(airbaseObject)

    if desc and desc.category ~= nil then
        return desc.category
    end

    return -1
end

local function getDcsCategoryName(categoryId)
    if AirbaseScanner.dcsCategoryNames[categoryId] then
        return AirbaseScanner.dcsCategoryNames[categoryId]
    end

    return "UNKNOWN"
end

local function getTheatreArea(normalizedNameValue)
    if containsAnyKeyword(normalizedNameValue, AirbaseScanner.cyprusKeywords) then
        return "CYPRUS"
    end

    if containsAnyKeyword(normalizedNameValue, AirbaseScanner.syrianMainlandKeywords) then
        return "SYRIAN_MAINLAND"
    end

    return "UNKNOWN"
end

local function isStartBase(normalizedNameValue)
    local config = getConfig()
    local configuredStartBase = "AKROTIRI"

    if config and config.campaign and config.campaign.blueStartBase then
        configuredStartBase = config.campaign.blueStartBase
    end

    return containsKeyword(normalizedNameValue, configuredStartBase)
end

local function determineInitialOwner(normalizedNameValue, theatreArea, coalitionName)
    if isStartBase(normalizedNameValue) then
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

local function classifyAirbase(normalizedNameValue, dcsCategoryName, theatreArea)
    local matched = nil
    local isConfiguredStartBase = isStartBase(normalizedNameValue)

    if isConfiguredStartBase then
        return {
            category = AirbaseScanner.Categories.STRATEGIC_AIRFIELD,
            reason = "configured_blue_start_base",
            matchedKeyword = "AKROTIRI"
        }
    end

    if dcsCategoryName == "AIRDROME" then
        local isStrategic, strategicKeyword = containsAnyKeyword(normalizedNameValue, AirbaseScanner.strategicAirfieldKeywords)

        if isStrategic then
            return {
                category = AirbaseScanner.Categories.STRATEGIC_AIRFIELD,
                reason = "strategic_airfield_keyword",
                matchedKeyword = strategicKeyword
            }
        end

        local isSecondary, secondaryKeyword = containsAnyKeyword(normalizedNameValue, AirbaseScanner.secondaryAirfieldKeywords)

        if isSecondary then
            return {
                category = AirbaseScanner.Categories.SECONDARY_AIRFIELD,
                reason = "secondary_airfield_keyword",
                matchedKeyword = secondaryKeyword
            }
        end

        return {
            category = AirbaseScanner.Categories.SECONDARY_AIRFIELD,
            reason = "dcs_airdrome_default",
            matchedKeyword = nil
        }
    end

    matched = nil
    local isMedical, medicalKeyword = containsAnyKeyword(normalizedNameValue, AirbaseScanner.medicalPadKeywords)

    if isMedical then
        return {
            category = AirbaseScanner.Categories.MEDICAL_PAD,
            reason = "medical_pad_keyword",
            matchedKeyword = medicalKeyword
        }
    end

    local isFarp, farpKeyword = containsAnyKeyword(normalizedNameValue, AirbaseScanner.farpKeywords)

    if isFarp then
        return {
            category = AirbaseScanner.Categories.FARP,
            reason = "farp_keyword",
            matchedKeyword = farpKeyword
        }
    end

    local isHeliport, heliportKeyword = containsAnyKeyword(normalizedNameValue, AirbaseScanner.heliportKeywords)

    if isHeliport then
        return {
            category = AirbaseScanner.Categories.HELIPORT,
            reason = "heliport_keyword",
            matchedKeyword = heliportKeyword
        }
    end

    local isTactical, tacticalKeyword = containsAnyKeyword(normalizedNameValue, AirbaseScanner.tacticalPadKeywords)

    if isTactical then
        return {
            category = AirbaseScanner.Categories.TACTICAL_PAD,
            reason = "tactical_pad_keyword",
            matchedKeyword = tacticalKeyword
        }
    end

    local isHelipad, helipadKeyword = containsAnyKeyword(normalizedNameValue, AirbaseScanner.helipadKeywords)

    if dcsCategoryName == "HELIPAD" or isHelipad then
        return {
            category = AirbaseScanner.Categories.HELIPAD,
            reason = "dcs_helipad_default",
            matchedKeyword = helipadKeyword
        }
    end

    if dcsCategoryName == "SHIP" then
        return {
            category = AirbaseScanner.Categories.UNKNOWN,
            reason = "dcs_ship_category_not_campaign_airbase",
            matchedKeyword = nil
        }
    end

    if theatreArea == "SYRIAN_MAINLAND" then
        return {
            category = AirbaseScanner.Categories.UNKNOWN,
            reason = "unknown_syrian_mainland_airbase_like_object",
            matchedKeyword = nil
        }
    end

    return {
        category = AirbaseScanner.Categories.UNKNOWN,
        reason = "unknown_airbase_like_object",
        matchedKeyword = nil
    }
end

local function calculateStrategicRelevance(classificationCategory, normalizedNameValue, theatreArea, currentOwner, isConfiguredStartBase)
    local relevance = 0

    if classificationCategory == AirbaseScanner.Categories.STRATEGIC_AIRFIELD then
        relevance = 85
    elseif classificationCategory == AirbaseScanner.Categories.SECONDARY_AIRFIELD then
        relevance = 60
    elseif classificationCategory == AirbaseScanner.Categories.HELIPORT then
        relevance = 45
    elseif classificationCategory == AirbaseScanner.Categories.FARP then
        relevance = 40
    elseif classificationCategory == AirbaseScanner.Categories.TACTICAL_PAD then
        relevance = 25
    elseif classificationCategory == AirbaseScanner.Categories.HELIPAD then
        relevance = 20
    elseif classificationCategory == AirbaseScanner.Categories.MEDICAL_PAD then
        relevance = 10
    else
        relevance = 0
    end

    if isConfiguredStartBase then
        relevance = 100
    elseif theatreArea == "SYRIAN_MAINLAND" and classificationCategory == AirbaseScanner.Categories.STRATEGIC_AIRFIELD then
        relevance = relevance + 10
    elseif theatreArea == "CYPRUS" and currentOwner == "BLUE" and classificationCategory == AirbaseScanner.Categories.SECONDARY_AIRFIELD then
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

local function getZoneProfile(classificationCategory)
    if classificationCategory == AirbaseScanner.Categories.STRATEGIC_AIRFIELD then
        return {
            zoneClass = "STRATEGIC_AIRBASE_ZONE",
            recommendedRadius = 12000,
            createCaptureZone = true,
            createMissionZone = true,
            createLogisticsZone = true
        }
    end

    if classificationCategory == AirbaseScanner.Categories.SECONDARY_AIRFIELD then
        return {
            zoneClass = "SECONDARY_AIRBASE_ZONE",
            recommendedRadius = 8000,
            createCaptureZone = true,
            createMissionZone = true,
            createLogisticsZone = true
        }
    end

    if classificationCategory == AirbaseScanner.Categories.HELIPORT then
        return {
            zoneClass = "HELIPORT_ZONE",
            recommendedRadius = 4000,
            createCaptureZone = false,
            createMissionZone = false,
            createLogisticsZone = true
        }
    end

    if classificationCategory == AirbaseScanner.Categories.FARP then
        return {
            zoneClass = "FARP_ZONE",
            recommendedRadius = 3500,
            createCaptureZone = false,
            createMissionZone = false,
            createLogisticsZone = true
        }
    end

    if classificationCategory == AirbaseScanner.Categories.TACTICAL_PAD then
        return {
            zoneClass = "TACTICAL_PAD_ZONE",
            recommendedRadius = 2500,
            createCaptureZone = false,
            createMissionZone = false,
            createLogisticsZone = true
        }
    end

    if classificationCategory == AirbaseScanner.Categories.HELIPAD then
        return {
            zoneClass = "HELIPAD_ZONE",
            recommendedRadius = 2000,
            createCaptureZone = false,
            createMissionZone = false,
            createLogisticsZone = false
        }
    end

    if classificationCategory == AirbaseScanner.Categories.MEDICAL_PAD then
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

    for _, categoryName in ipairs(AirbaseScanner.categoryOrder) do
        state.Bases.byClassification[categoryName] = {}
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

    for _, categoryName in ipairs(AirbaseScanner.categoryOrder) do
        state.Bases.classificationCounts[categoryName] = 0
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

local function countOwner(state, owner)
    if state == nil or state.Bases == nil then
        return
    end

    if owner == "BLUE" then
        state.Bases.blue = state.Bases.blue + 1
    elseif owner == "RED" then
        state.Bases.red = state.Bases.red + 1
    elseif owner == "NEUTRAL" then
        state.Bases.neutral = state.Bases.neutral + 1
    elseif owner == "CONTESTED" then
        state.Bases.contested = state.Bases.contested + 1
    else
        state.Bases.unknown = state.Bases.unknown + 1
    end
end

local function getClassificationListName(classificationCategory)
    if classificationCategory == AirbaseScanner.Categories.STRATEGIC_AIRFIELD then
        return "strategicAirfields"
    end

    if classificationCategory == AirbaseScanner.Categories.SECONDARY_AIRFIELD then
        return "secondaryAirfields"
    end

    if classificationCategory == AirbaseScanner.Categories.HELIPORT then
        return "heliports"
    end

    if classificationCategory == AirbaseScanner.Categories.HELIPAD then
        return "helipads"
    end

    if classificationCategory == AirbaseScanner.Categories.MEDICAL_PAD then
        return "medicalPads"
    end

    if classificationCategory == AirbaseScanner.Categories.FARP then
        return "farps"
    end

    if classificationCategory == AirbaseScanner.Categories.TACTICAL_PAD then
        return "tacticalPads"
    end

    return "unknown"
end

local function addRecordToList(list, key, record)
    if list ~= nil and key ~= nil and record ~= nil then
        list[key] = record
    end
end

local function registerClassification(state, record)
    local listName = getClassificationListName(record.classification)

    addRecordToList(AirbaseScanner.classificationLists.all, record.key, record)
    addRecordToList(AirbaseScanner.classificationLists[listName], record.key, record)

    if state and state.Bases then
        addRecordToList(state.Bases.byClassification[record.classification], record.key, record)
        addRecordToList(state.Bases[listName], record.key, record)

        state.Bases.classificationCounts.total = state.Bases.classificationCounts.total + 1
        state.Bases.classificationCounts[record.classification] = state.Bases.classificationCounts[record.classification] + 1
        state.Bases.classificationCounts[listName] = state.Bases.classificationCounts[listName] + 1
    end

    if record.isCaptureCandidate then
        addRecordToList(AirbaseScanner.classificationLists.captureCandidates, record.key, record)

        if state and state.Bases then
            addRecordToList(state.Bases.captureCandidates, record.key, record)
        end
    end

    if record.isMissionCandidate then
        addRecordToList(AirbaseScanner.classificationLists.missionCandidates, record.key, record)

        if state and state.Bases then
            addRecordToList(state.Bases.missionCandidates, record.key, record)
        end
    end

    if record.isLogisticsCandidate then
        addRecordToList(AirbaseScanner.classificationLists.logisticsCandidates, record.key, record)

        if state and state.Bases then
            addRecordToList(state.Bases.logisticsCandidates, record.key, record)
        end
    end

    if record.isStartBase then
        addRecordToList(AirbaseScanner.classificationLists.blueStartBases, record.key, record)

        if state and state.Bases then
            addRecordToList(state.Bases.blueStartBases, record.key, record)
            state.Bases.blueStartBase = record
        end
    end

    if record.isPotentialRedStrategicBase then
        addRecordToList(AirbaseScanner.classificationLists.potentialRedStrategicBases, record.key, record)

        if state and state.Bases then
            addRecordToList(state.Bases.potentialRedStrategicBases, record.key, record)
        end
    end
end

local function createAirbaseRecord(airbaseObject, index)
    local name = getAirbaseName(airbaseObject)
    local normalizedNameValue = normalizeName(name)
    local key = normalizedNameValue

    if key == nil or key == "" or key == "UNKNOWN" or key == "UNKNOWN_AIRBASE" then
        key = "UNKNOWN_AIRBASE_" .. tostring(index or 0)
    end

    local point = getAirbasePoint(airbaseObject)
    local coalitionId = getAirbaseCoalitionId(airbaseObject)
    local coalitionName = getCoalitionName(coalitionId)
    local dcsCategoryId = getAirbaseCategory(airbaseObject)
    local dcsCategoryName = getDcsCategoryName(dcsCategoryId)
    local desc = getAirbaseDesc(airbaseObject)
    local theatreArea = getTheatreArea(normalizedNameValue)
    local configuredStartBase = isStartBase(normalizedNameValue)
    local initialOwner = determineInitialOwner(normalizedNameValue, theatreArea, coalitionName)
    local classification = classifyAirbase(normalizedNameValue, dcsCategoryName, theatreArea)
    local strategicRelevance = calculateStrategicRelevance(
        classification.category,
        normalizedNameValue,
        theatreArea,
        initialOwner,
        configuredStartBase
    )
    local zoneProfile = getZoneProfile(classification.category)

    local isStrategicAirfield = classification.category == AirbaseScanner.Categories.STRATEGIC_AIRFIELD
    local isSecondaryAirfield = classification.category == AirbaseScanner.Categories.SECONDARY_AIRFIELD
    local isHeliport = classification.category == AirbaseScanner.Categories.HELIPORT
    local isHelipad = classification.category == AirbaseScanner.Categories.HELIPAD
    local isMedicalPad = classification.category == AirbaseScanner.Categories.MEDICAL_PAD
    local isFarp = classification.category == AirbaseScanner.Categories.FARP
    local isTacticalPad = classification.category == AirbaseScanner.Categories.TACTICAL_PAD
    local isUnknown = classification.category == AirbaseScanner.Categories.UNKNOWN

    local isCaptureCandidate = isStrategicAirfield or isSecondaryAirfield
    local isMissionCandidate = isStrategicAirfield or isSecondaryAirfield
    local isLogisticsCandidate = configuredStartBase or isStrategicAirfield or isSecondaryAirfield or isHeliport or isFarp or isTacticalPad
    local isPotentialRedStrategicBase = theatreArea == "SYRIAN_MAINLAND" and initialOwner == "RED" and isStrategicAirfield

    return {
        key = key,
        name = name,
        displayName = readableName(name),
        normalizedName = normalizedNameValue,

        source = "DCS_WORLD_AIRBASE_SCAN",
        index = index or 0,
        scannedAt = getCurrentTime(),

        dcsObject = airbaseObject,
        dcsDescription = desc,
        dcsCategoryId = dcsCategoryId,
        dcsCategoryName = dcsCategoryName,

        -- Backward-compatible fields used by the current ZoneFactory.
        categoryId = dcsCategoryId,
        categoryName = dcsCategoryName,
        coalitionId = coalitionId,
        coalitionName = coalitionName,
        position = point,

        -- Theater Command classification.
        classification = classification.category,
        classificationReason = classification.reason,
        classificationKeyword = classification.matchedKeyword,
        airbaseType = classification.category,
        strategicRelevance = strategicRelevance,
        zoneProfile = zoneProfile,

        theatreArea = theatreArea,
        initialOwner = initialOwner,
        currentOwner = initialOwner,
        owner = initialOwner,
        status = "ACTIVE",

        isStartBase = configuredStartBase,
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

local function registerAirbase(state, record)
    if record == nil then
        return
    end

    AirbaseScanner.registry[record.key] = record
    TC.World.Airbases[record.key] = record

    if state and state.Bases then
        state.Bases.registry[record.key] = record
        state.Bases.total = state.Bases.total + 1
        countOwner(state, record.currentOwner)
    end

    registerClassification(state, record)
end

local function markStateDirty()
    local state = getState()

    if state and state.markDirty then
        state.markDirty(AirbaseScanner.name)
    end
end

local function setModuleStatus(status, details)
    local state = getState()

    if state and state.setModuleStatus then
        state.setModuleStatus(AirbaseScanner.name, status, details)
    end
end

local function setFeatureStatus(status, details)
    local state = getState()

    if state and state.setFeatureStatus then
        state.setFeatureStatus("world.airbaseScanner", status, details)
    end
end

local function buildClassificationSummary()
    local lists = AirbaseScanner.classificationLists

    return {
        total = tableCount(lists.all),
        strategicAirfields = tableCount(lists.strategicAirfields),
        secondaryAirfields = tableCount(lists.secondaryAirfields),
        heliports = tableCount(lists.heliports),
        helipads = tableCount(lists.helipads),
        medicalPads = tableCount(lists.medicalPads),
        farps = tableCount(lists.farps),
        tacticalPads = tableCount(lists.tacticalPads),
        unknown = tableCount(lists.unknown),
        captureCandidates = tableCount(lists.captureCandidates),
        missionCandidates = tableCount(lists.missionCandidates),
        logisticsCandidates = tableCount(lists.logisticsCandidates),
        blueStartBases = tableCount(lists.blueStartBases),
        potentialRedStrategicBases = tableCount(lists.potentialRedStrategicBases)
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
        .. ", redStrategicCandidates=" .. tostring(summary.potentialRedStrategicBases)
end

local function updateWorldScanState(state, scanCount)
    if state == nil then
        return
    end

    state.World = state.World or {}
    state.World.airbaseScan = state.World.airbaseScan or {}

    state.World.airbaseScan.completed = true
    state.World.airbaseScan.scannedAt = AirbaseScanner.lastScanTime
    state.World.airbaseScan.totalDetected = scanCount
    state.World.airbaseScan.classificationReady = true
    state.World.airbaseScan.summary = buildClassificationSummary()
end

function AirbaseScanner.scan()
    if world == nil or world.getAirbases == nil then
        AirbaseScanner.failed = true
        setModuleStatus("FAILED", "DCS world.getAirbases unavailable")
        setFeatureStatus("FAILED", "DCS world.getAirbases unavailable")
        logError("Cannot scan airbases: world.getAirbases is unavailable")
        return false
    end

    local state = ensureStateTables()

    resetScannerTables()

    local success, airbases = pcall(world.getAirbases)

    if not success or type(airbases) ~= "table" then
        AirbaseScanner.failed = true
        setModuleStatus("FAILED", "DCS world.getAirbases call failed")
        setFeatureStatus("FAILED", "DCS world.getAirbases call failed")
        logError("Cannot scan airbases: DCS world.getAirbases call failed")
        return false
    end

    local scanCount = 0

    for index, airbaseObject in ipairs(airbases) do
        local recordSuccess, record = pcall(createAirbaseRecord, airbaseObject, index)

        if recordSuccess and record ~= nil then
            registerAirbase(state, record)
            scanCount = scanCount + 1
        else
            logWarn("Skipped airbase-like object at index " .. tostring(index) .. " because record creation failed")
        end
    end

    AirbaseScanner.lastScanTime = getCurrentTime()
    AirbaseScanner.lastScanCount = scanCount
    AirbaseScanner.finished = true
    AirbaseScanner.failed = false

    updateWorldScanState(state, scanCount)
    markStateDirty()

    local summary = buildClassificationSummary()

    logInfo("Airbase scan completed: " .. tostring(scanCount) .. " airbase-like objects registered")
    logInfo("Airbase classification summary: " .. buildClassificationSummaryText(summary))

    local startBase = AirbaseScanner.getStartBase()

    if startBase then
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

    setModuleStatus("READY", "Registered and classified " .. tostring(scanCount) .. " airbase-like objects")
    setFeatureStatus("READY", "Airbase classification ready")

    return true
end

function AirbaseScanner.start()
    if AirbaseScanner.started then
        logDebug("Airbase scanner already started")
        return true
    end

    AirbaseScanner.started = true
    AirbaseScanner.failed = false

    setModuleStatus("STARTING", "Scanning DCS world airbases")
    setFeatureStatus("STARTING", "Scanning and classifying DCS world airbases")

    logInfo("Starting airbase scanner")

    local success = AirbaseScanner.scan()

    if success then
        logInfo("Airbase scanner started successfully")
        return true
    end

    AirbaseScanner.failed = true
    logError("Airbase scanner failed")
    return false
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

    local normalizedKey = normalizeName(key)

    if AirbaseScanner.registry[normalizedKey] then
        return AirbaseScanner.registry[normalizedKey]
    end

    return AirbaseScanner.registry[key]
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

        if containsKeyword(record.normalizedName, normalizedSearchName) then
            return record
        end
    end

    return nil
end

function AirbaseScanner.getStartBase()
    for _, record in pairs(AirbaseScanner.registry) do
        if record.isStartBase then
            return record
        end
    end

    return nil
end

function AirbaseScanner.getCount()
    return tableCount(AirbaseScanner.registry)
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

function AirbaseScanner.getByClassification(classificationCategory)
    local result = {}

    if classificationCategory == nil then
        return result
    end

    local normalizedClassification = string.upper(tostring(classificationCategory))

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

AirbaseScanner.loaded = true

TC.World.AirbaseScanner = AirbaseScanner
TC.world.AirbaseScanner = AirbaseScanner
TC.modules.airbaseScanner = AirbaseScanner

logInfo("Loaded " .. AirbaseScanner.path .. " v" .. AirbaseScanner.version)
