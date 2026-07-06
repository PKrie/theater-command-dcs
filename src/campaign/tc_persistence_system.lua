-- Theater Command DCS
-- File: src/campaign/tc_persistence_system.lua
--
-- Purpose:
-- Prepare campaign state export, import, in-memory persistence and a controlled
-- DCS file-system sandbox test.
--
-- Current focus:
-- PersistenceSystem v0.2.0 keeps the existing state-first memory persistence
-- foundation and adds a safe startup sandbox test for os/io/lfs availability
-- and minimal write/read verification.
--
-- Version:
-- 0.2.0
--
-- Responsibilities:
-- - keep campaign persistence state under TC.State.Persistence
-- - export a serializable campaign snapshot
-- - import a campaign snapshot back into TC.State
-- - support in-memory save/load for early tests
-- - test DCS mission scripting file-system availability
-- - log os/io/lfs availability clearly
-- - attempt one minimal file write/read test only when safe path access exists
-- - do not require productive persistence to pass for the module to start
--
-- Important:
-- This module remains state-first.
-- It does not yet perform productive campaign save/load automatically.

TC = TC or {}
TC.modules = TC.modules or {}
TC.Campaign = TC.Campaign or {}
TC.campaign = TC.campaign or TC.Campaign

local PersistenceSystem = {}

PersistenceSystem.name = "tc_persistence_system"
PersistenceSystem.displayName = "Persistence System"
PersistenceSystem.path = "src/campaign/tc_persistence_system.lua"
PersistenceSystem.version = "0.2.0"
PersistenceSystem.loaded = true
PersistenceSystem.started = false
PersistenceSystem.finished = false
PersistenceSystem.failed = false

PersistenceSystem.memorySaves = {}
PersistenceSystem.lastExport = nil
PersistenceSystem.lastImport = nil
PersistenceSystem.lastSaveName = nil
PersistenceSystem.lastError = nil
PersistenceSystem.lastSandboxResult = nil

PersistenceSystem.sandboxDirectoryName = "TheaterCommandDCS"
PersistenceSystem.sandboxFileName = "tc_persistence_sandbox_test.lua"
PersistenceSystem.sandboxMarker = "TC_PERSISTENCE_SANDBOX_TEST"

PersistenceSystem.sections = {
    "Meta",
    "Campaign",
    "World",
    "Bases",
    "Zones",
    "Logistics",
    "Missions",
    "AI",
    "IADS",
    "Persistence"
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
    local formatted = "[TC][PERSISTENCE] " .. tostring(message)

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
        logger.info("[PersistenceSystem] " .. tostring(message))
        return
    end

    rawLog("INFO", message)
end

local function logWarn(message)
    local logger = getLogger()

    if logger ~= nil and logger.warn ~= nil then
        logger.warn("[PersistenceSystem] " .. tostring(message))
        return
    end

    rawLog("WARN", message)
end

local function logError(message)
    local logger = getLogger()

    if logger ~= nil and logger.error ~= nil then
        logger.error("[PersistenceSystem] " .. tostring(message))
        return
    end

    rawLog("ERROR", message)
end

local function logDebug(message)
    local logger = getLogger()

    if logger ~= nil and logger.debug ~= nil then
        logger.debug("[PersistenceSystem] " .. tostring(message))
    end
end

local function boolText(value)
    if value == true then
        return "true"
    end

    return "false"
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
        return nil
    end

    local normalized = string.upper(tostring(value))
    normalized = string.gsub(normalized, "^%s*(.-)%s*$", "%1")
    normalized = string.gsub(normalized, "[%-/]+", "_")
    normalized = string.gsub(normalized, "%s+", "_")
    normalized = string.gsub(normalized, "[^A-Z0-9_]", "_")
    normalized = string.gsub(normalized, "_+", "_")
    normalized = string.gsub(normalized, "^_+", "")
    normalized = string.gsub(normalized, "_+$", "")

    if normalized == "" then
        return nil
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
        local keyType = type(key)
        local childType = type(childValue)

        if keyType ~= "function"
            and keyType ~= "userdata"
            and keyType ~= "thread"
            and childType ~= "function"
            and childType ~= "userdata"
            and childType ~= "thread" then

            local copiedKey = copyValue(key, visited)
            local copiedValue = copyValue(childValue, visited)

            if copiedKey ~= nil then
                result[copiedKey] = copiedValue
            end
        end
    end

    visited[value] = nil

    return result
end

local function getDefaultSaveName()
    local config = getConfig()

    if config.campaign ~= nil and config.campaign.name ~= nil then
        local normalizedCampaignName = normalizeName(config.campaign.name)

        if normalizedCampaignName ~= nil then
            return string.lower(normalizedCampaignName)
        end
    end

    local state = getState()

    if state ~= nil and state.Persistence ~= nil and state.Persistence.saveName ~= nil then
        return state.Persistence.saveName
    end

    return "operation_levant_reclamation"
end

local function ensurePersistenceState()
    local state = getState()

    if state == nil then
        return nil
    end

    state.Persistence = state.Persistence or {}
    state.Persistence.enabled = true
    state.Persistence.dirty = state.Persistence.dirty == true
    state.Persistence.lastSaveTime = state.Persistence.lastSaveTime or 0
    state.Persistence.lastLoadTime = state.Persistence.lastLoadTime or 0
    state.Persistence.lastExportTime = state.Persistence.lastExportTime or 0
    state.Persistence.lastImportTime = state.Persistence.lastImportTime or 0
    state.Persistence.saveName = state.Persistence.saveName or getDefaultSaveName()
    state.Persistence.exportCount = state.Persistence.exportCount or 0
    state.Persistence.importCount = state.Persistence.importCount or 0
    state.Persistence.memorySaveCount = state.Persistence.memorySaveCount or 0
    state.Persistence.fileSystemAvailable = state.Persistence.fileSystemAvailable == true
    state.Persistence.sandbox = state.Persistence.sandbox or {}

    return state
end

local function markDirty(reason)
    local state = getState()

    if state ~= nil and state.markDirty ~= nil then
        state.markDirty(reason or "persistence_state_changed")
        return true
    end

    if state ~= nil then
        state.Persistence = state.Persistence or {}
        state.Persistence.dirty = true
        state.Persistence.dirtyReason = reason or "persistence_state_changed"
        state.Persistence.dirtyAt = getCurrentTime()
        return true
    end

    return false
end

local function clearDirty()
    local state = getState()

    if state ~= nil and state.clearDirty ~= nil then
        state.clearDirty()
        return true
    end

    if state ~= nil then
        state.Persistence = state.Persistence or {}
        state.Persistence.dirty = false
        state.Persistence.dirtyReason = nil
        state.Persistence.dirtyAt = nil
        return true
    end

    return false
end

local function setModuleStatus(status)
    local state = getState()

    if state ~= nil and state.setModuleStatus ~= nil then
        state.setModuleStatus("persistenceSystem", status)
    end
end

local function setFeatureStatus(enabled)
    local state = getState()

    if state ~= nil and state.setFeatureStatus ~= nil then
        state.setFeatureStatus("persistence", enabled == true)
    end
end

local function getSerializableState()
    local state = getState()

    if state == nil then
        return nil
    end

    local exportData = {}

    for _, sectionName in ipairs(PersistenceSystem.sections) do
        exportData[sectionName] = copyValue(state[sectionName])
    end

    return exportData
end

local function applyImportedState(importedData)
    local state = getState()

    if state == nil then
        return false, "state_unavailable"
    end

    if type(importedData) ~= "table" then
        return false, "imported_data_not_table"
    end

    for _, sectionName in ipairs(PersistenceSystem.sections) do
        if importedData[sectionName] ~= nil then
            state[sectionName] = copyValue(importedData[sectionName])
        end
    end

    state.Persistence = state.Persistence or {}
    state.Persistence.enabled = true
    state.Persistence.lastLoadTime = getCurrentTime()
    state.Persistence.importCount = (state.Persistence.importCount or 0) + 1

    return true
end

local function serializePrimitive(value)
    if value == nil then
        return "nil"
    end

    if type(value) == "number" then
        return tostring(value)
    end

    if type(value) == "boolean" then
        if value == true then
            return "true"
        end

        return "false"
    end

    if type(value) == "string" then
        return string.format("%q", value)
    end

    return "nil"
end

local function serializeKey(key)
    if type(key) == "string" then
        if string.match(key, "^[%a_][%w_]*$") ~= nil then
            return key
        end

        return "[" .. string.format("%q", key) .. "]"
    end

    if type(key) == "number" then
        return "[" .. tostring(key) .. "]"
    end

    return nil
end

local function getSortedKeys(targetTable)
    local keys = {}

    if type(targetTable) ~= "table" then
        return keys
    end

    for key, _ in pairs(targetTable) do
        if serializeKey(key) ~= nil then
            table.insert(keys, key)
        end
    end

    table.sort(keys, function(left, right)
        local leftType = type(left)
        local rightType = type(right)

        if leftType ~= rightType then
            return leftType < rightType
        end

        return tostring(left) < tostring(right)
    end)

    return keys
end

local function serializeValue(value, indentLevel, visited)
    indentLevel = indentLevel or 0
    visited = visited or {}

    local valueType = type(value)

    if valueType ~= "table" then
        return serializePrimitive(value)
    end

    if visited[value] ~= nil then
        return "nil"
    end

    visited[value] = true

    local indent = string.rep("  ", indentLevel)
    local childIndent = string.rep("  ", indentLevel + 1)
    local lines = {}

    table.insert(lines, "{")

    local keys = getSortedKeys(value)

    for _, key in ipairs(keys) do
        local childValue = value[key]
        local serializedKey = serializeKey(key)

        if serializedKey ~= nil then
            local childType = type(childValue)

            if childType ~= "function" and childType ~= "userdata" and childType ~= "thread" then
                local serializedValue = serializeValue(childValue, indentLevel + 1, visited)
                table.insert(lines, childIndent .. serializedKey .. " = " .. serializedValue .. ",")
            end
        end
    end

    table.insert(lines, indent .. "}")

    visited[value] = nil

    return table.concat(lines, "\n")
end

local function detectFileSystemAvailability()
    local availability = {
        osAvailable = type(os) == "table",
        ioAvailable = type(io) == "table",
        lfsAvailable = type(lfs) == "table",
        requireAvailable = type(require) == "function",
        lfsFromRequire = false,
        lfsRef = nil
    }

    if availability.lfsAvailable == true then
        availability.lfsRef = lfs
        return availability
    end

    if availability.requireAvailable == true then
        local success, requiredLfs = pcall(function()
            return require("lfs")
        end)

        if success == true and type(requiredLfs) == "table" then
            availability.lfsAvailable = true
            availability.lfsFromRequire = true
            availability.lfsRef = requiredLfs
            return availability
        end
    end

    return availability
end

local function ensureTrailingSeparator(pathValue)
    if type(pathValue) ~= "string" or pathValue == "" then
        return nil
    end

    local lastChar = string.sub(pathValue, -1)

    if lastChar == "/" or lastChar == "\\" then
        return pathValue
    end

    return pathValue .. "/"
end

local function getWritableRoot(availability)
    if type(availability) ~= "table" then
        return nil, "availability_missing"
    end

    local lfsRef = availability.lfsRef

    if type(lfsRef) ~= "table" then
        return nil, "lfs_unavailable"
    end

    if type(lfsRef.writedir) ~= "function" then
        return nil, "lfs_writedir_unavailable"
    end

    local success, writableRoot = pcall(function()
        return lfsRef.writedir()
    end)

    if success ~= true then
        return nil, "lfs_writedir_failed"
    end

    if type(writableRoot) ~= "string" or writableRoot == "" then
        return nil, "lfs_writedir_empty"
    end

    return ensureTrailingSeparator(writableRoot), nil
end

local function ensureDirectory(pathValue, availability)
    if type(pathValue) ~= "string" or pathValue == "" then
        return false, "directory_path_invalid"
    end

    if type(availability) ~= "table" or type(availability.lfsRef) ~= "table" then
        return false, "lfs_unavailable"
    end

    local lfsRef = availability.lfsRef

    if type(lfsRef.attributes) == "function" then
        local attrSuccess, attributes = pcall(function()
            return lfsRef.attributes(pathValue)
        end)

        if attrSuccess == true and type(attributes) == "table" then
            return true, "directory_exists"
        end
    end

    if type(lfsRef.mkdir) ~= "function" then
        return false, "lfs_mkdir_unavailable"
    end

    local mkdirSuccess, mkdirResult = pcall(function()
        return lfsRef.mkdir(pathValue)
    end)

    if mkdirSuccess ~= true then
        return false, "lfs_mkdir_failed"
    end

    if mkdirResult == true then
        return true, "directory_created"
    end

    if type(lfsRef.attributes) == "function" then
        local attrSuccess, attributes = pcall(function()
            return lfsRef.attributes(pathValue)
        end)

        if attrSuccess == true and type(attributes) == "table" then
            return true, "directory_exists_after_mkdir"
        end
    end

    return false, "lfs_mkdir_returned_false"
end

local function writeTextFile(pathValue, content)
    if type(io) ~= "table" or type(io.open) ~= "function" then
        return false, "io_open_unavailable"
    end

    local openSuccess, fileHandle = pcall(function()
        return io.open(pathValue, "w")
    end)

    if openSuccess ~= true or fileHandle == nil then
        return false, "file_open_write_failed"
    end

    local writeSuccess, writeResult = pcall(function()
        return fileHandle:write(content)
    end)

    local closeSuccess = pcall(function()
        fileHandle:close()
    end)

    if writeSuccess ~= true then
        return false, "file_write_failed"
    end

    if closeSuccess ~= true then
        return false, "file_close_after_write_failed"
    end

    if writeResult == nil then
        return false, "file_write_returned_nil"
    end

    return true
end

local function readTextFile(pathValue)
    if type(io) ~= "table" or type(io.open) ~= "function" then
        return nil, "io_open_unavailable"
    end

    local openSuccess, fileHandle = pcall(function()
        return io.open(pathValue, "r")
    end)

    if openSuccess ~= true or fileHandle == nil then
        return nil, "file_open_read_failed"
    end

    local readSuccess, content = pcall(function()
        return fileHandle:read("*a")
    end)

    local closeSuccess = pcall(function()
        fileHandle:close()
    end)

    if readSuccess ~= true then
        return nil, "file_read_failed"
    end

    if closeSuccess ~= true then
        return nil, "file_close_after_read_failed"
    end

    return content, nil
end

local function buildSandboxFileContent(result)
    local createdAt = getCurrentTime()
    local saveName = getDefaultSaveName()

    local payload = {
        marker = PersistenceSystem.sandboxMarker,
        project = "Theater Command DCS",
        campaign = "Operation Levant Reclamation",
        map = "Syria",
        module = PersistenceSystem.name,
        version = PersistenceSystem.version,
        saveName = saveName,
        createdAt = createdAt,
        osAvailable = result.osAvailable == true,
        ioAvailable = result.ioAvailable == true,
        lfsAvailable = result.lfsAvailable == true,
        lfsFromRequire = result.lfsFromRequire == true
    }

    return "return " .. serializeValue(payload, 0, {})
end

local function storeSandboxResult(result)
    PersistenceSystem.lastSandboxResult = copyValue(result)

    local state = ensurePersistenceState()

    if state == nil then
        return false
    end

    state.Persistence.sandbox = copyValue(result)
    state.Persistence.lastSandboxStatus = result.status
    state.Persistence.lastSandboxReason = result.reason
    state.Persistence.lastSandboxAt = result.finishedAt or result.startedAt or getCurrentTime()
    state.Persistence.fileSystemAvailable = result.fileSystemAvailable == true
    state.Persistence.fileWriteAllowed = result.writeAllowed == true
    state.Persistence.fileReadAllowed = result.readAllowed == true
    state.Persistence.lastSandboxPath = result.filePath

    return true
end

function PersistenceSystem.runSandboxTest()
    local startedAt = getCurrentTime()
    local availability = detectFileSystemAvailability()

    local result = {
        name = "persistence_sandbox_test",
        status = "STARTED",
        reason = nil,
        startedAt = startedAt,
        finishedAt = 0,
        osAvailable = availability.osAvailable == true,
        ioAvailable = availability.ioAvailable == true,
        lfsAvailable = availability.lfsAvailable == true,
        requireAvailable = availability.requireAvailable == true,
        lfsFromRequire = availability.lfsFromRequire == true,
        writableRoot = nil,
        directoryPath = nil,
        filePath = nil,
        directoryReady = false,
        writeAllowed = false,
        readAllowed = false,
        fileSystemAvailable = false
    }

    logInfo(
        "Persistence sandbox availability: os="
            .. boolText(result.osAvailable)
            .. ", io="
            .. boolText(result.ioAvailable)
            .. ", lfs="
            .. boolText(result.lfsAvailable)
            .. ", require="
            .. boolText(result.requireAvailable)
            .. ", lfsFromRequire="
            .. boolText(result.lfsFromRequire)
    )

    if result.ioAvailable ~= true then
        result.status = "BLOCKED"
        result.reason = "io_unavailable"
        result.finishedAt = getCurrentTime()
        storeSandboxResult(result)
        logWarn("Persistence sandbox blocked: io_unavailable")
        return result
    end

    if result.lfsAvailable ~= true then
        result.status = "BLOCKED"
        result.reason = "lfs_unavailable"
        result.finishedAt = getCurrentTime()
        storeSandboxResult(result)
        logWarn("Persistence sandbox blocked: lfs_unavailable")
        return result
    end

    local writableRoot, rootReason = getWritableRoot(availability)

    if writableRoot == nil then
        result.status = "BLOCKED"
        result.reason = rootReason or "writable_root_unavailable"
        result.finishedAt = getCurrentTime()
        storeSandboxResult(result)
        logWarn("Persistence sandbox blocked: " .. tostring(result.reason))
        return result
    end

    result.writableRoot = writableRoot
    result.directoryPath = writableRoot .. PersistenceSystem.sandboxDirectoryName
    result.filePath = result.directoryPath .. "/" .. PersistenceSystem.sandboxFileName

    local directoryReady, directoryReason = ensureDirectory(result.directoryPath, availability)

    if directoryReady ~= true then
        result.status = "FAILED"
        result.reason = directoryReason or "directory_not_ready"
        result.finishedAt = getCurrentTime()
        storeSandboxResult(result)
        logWarn("Persistence sandbox directory failed: " .. tostring(result.reason))
        return result
    end

    result.directoryReady = true

    local fileContent = buildSandboxFileContent(result)
    local writeOk, writeReason = writeTextFile(result.filePath, fileContent)

    if writeOk ~= true then
        result.status = "FAILED"
        result.reason = writeReason or "write_failed"
        result.finishedAt = getCurrentTime()
        storeSandboxResult(result)
        logWarn("Persistence sandbox write failed: " .. tostring(result.reason) .. " path=" .. tostring(result.filePath))
        return result
    end

    result.writeAllowed = true

    local readContent, readReason = readTextFile(result.filePath)

    if readContent == nil then
        result.status = "FAILED"
        result.reason = readReason or "read_failed"
        result.finishedAt = getCurrentTime()
        storeSandboxResult(result)
        logWarn("Persistence sandbox read failed: " .. tostring(result.reason) .. " path=" .. tostring(result.filePath))
        return result
    end

    if string.find(readContent, PersistenceSystem.sandboxMarker, 1, true) == nil then
        result.status = "FAILED"
        result.reason = "sandbox_marker_missing"
        result.finishedAt = getCurrentTime()
        storeSandboxResult(result)
        logWarn("Persistence sandbox read failed: sandbox_marker_missing path=" .. tostring(result.filePath))
        return result
    end

    result.readAllowed = true
    result.fileSystemAvailable = true
    result.status = "PASSED"
    result.reason = "write_read_verified"
    result.finishedAt = getCurrentTime()

    storeSandboxResult(result)

    logInfo("Persistence sandbox file test passed: path=" .. tostring(result.filePath))

    return result
end

function PersistenceSystem.getSandboxResult()
    return PersistenceSystem.lastSandboxResult
end

function PersistenceSystem.isFilePersistenceAvailable()
    if PersistenceSystem.lastSandboxResult == nil then
        return false
    end

    return PersistenceSystem.lastSandboxResult.fileSystemAvailable == true
end

function PersistenceSystem.createSnapshot()
    local stateData = getSerializableState()

    if stateData == nil then
        return nil, "state_unavailable"
    end

    local config = getConfig()
    local campaignConfig = config.campaign or {}

    local snapshot = {
        meta = {
            project = "Theater Command DCS",
            module = PersistenceSystem.name,
            moduleVersion = PersistenceSystem.version,
            version = TC.version or PersistenceSystem.version,
            campaign = campaignConfig.name or "Operation Levant Reclamation",
            map = campaignConfig.map or "Syria",
            createdAt = getCurrentTime(),
            format = "TC_LUA_TABLE_V1",
            stateOnly = true
        },
        data = stateData
    }

    return snapshot
end

function PersistenceSystem.exportState()
    local snapshot, reason = PersistenceSystem.createSnapshot()

    if snapshot == nil then
        PersistenceSystem.lastError = reason
        logError("Persistence export failed: " .. tostring(reason))
        return nil, reason
    end

    PersistenceSystem.lastExport = copyValue(snapshot)

    local state = ensurePersistenceState()

    if state ~= nil then
        state.Persistence.lastExportTime = getCurrentTime()
        state.Persistence.exportCount = (state.Persistence.exportCount or 0) + 1
    end

    logInfo("Campaign state exported")

    return snapshot
end

function PersistenceSystem.importState(snapshot)
    if type(snapshot) ~= "table" then
        PersistenceSystem.lastError = "snapshot_not_table"
        logError("Persistence import failed: snapshot_not_table")
        return false, "snapshot_not_table"
    end

    local importedData = snapshot.data or snapshot

    if type(importedData) ~= "table" then
        PersistenceSystem.lastError = "snapshot_data_missing"
        logError("Persistence import failed: snapshot_data_missing")
        return false, "snapshot_data_missing"
    end

    local success, reason = applyImportedState(importedData)

    if success ~= true then
        PersistenceSystem.lastError = reason
        logError("Persistence import failed: " .. tostring(reason))
        return false, reason
    end

    PersistenceSystem.lastImport = copyValue(snapshot)

    clearDirty()

    logInfo("Campaign state imported")

    return true
end

function PersistenceSystem.exportAsLuaString()
    local snapshot, reason = PersistenceSystem.exportState()

    if snapshot == nil then
        return nil, reason
    end

    local serialized = "return " .. serializeValue(snapshot, 0, {})

    return serialized
end

function PersistenceSystem.saveToMemory(saveName)
    local name = saveName or getDefaultSaveName()
    local snapshot, reason = PersistenceSystem.exportState()

    if snapshot == nil then
        return false, reason
    end

    PersistenceSystem.memorySaves[name] = copyValue(snapshot)
    PersistenceSystem.lastSaveName = name

    local state = ensurePersistenceState()

    if state ~= nil then
        state.Persistence.saveName = name
        state.Persistence.lastSaveTime = getCurrentTime()
        state.Persistence.memorySaveCount = countTableKeys(PersistenceSystem.memorySaves)
    end

    clearDirty()

    logInfo("Campaign state saved to memory: " .. tostring(name))

    return true, name
end

function PersistenceSystem.loadFromMemory(saveName)
    local name = saveName or PersistenceSystem.lastSaveName or getDefaultSaveName()
    local snapshot = PersistenceSystem.memorySaves[name]

    if snapshot == nil then
        PersistenceSystem.lastError = "memory_save_not_found"
        logWarn("Campaign memory save not found: " .. tostring(name))
        return false, "memory_save_not_found"
    end

    local success, reason = PersistenceSystem.importState(snapshot)

    if success ~= true then
        return false, reason
    end

    PersistenceSystem.lastSaveName = name

    local state = ensurePersistenceState()

    if state ~= nil then
        state.Persistence.saveName = name
        state.Persistence.lastLoadTime = getCurrentTime()
        state.Persistence.memorySaveCount = countTableKeys(PersistenceSystem.memorySaves)
    end

    logInfo("Campaign state loaded from memory: " .. tostring(name))

    return true, name
end

function PersistenceSystem.hasMemorySave(saveName)
    local name = saveName or getDefaultSaveName()

    return PersistenceSystem.memorySaves[name] ~= nil
end

function PersistenceSystem.deleteMemorySave(saveName)
    local name = saveName or getDefaultSaveName()

    if PersistenceSystem.memorySaves[name] == nil then
        return false
    end

    PersistenceSystem.memorySaves[name] = nil

    local state = ensurePersistenceState()

    if state ~= nil then
        state.Persistence.memorySaveCount = countTableKeys(PersistenceSystem.memorySaves)
    end

    logInfo("Campaign memory save deleted: " .. tostring(name))

    return true
end

function PersistenceSystem.listMemorySaves()
    local result = {}

    for saveName, snapshot in pairs(PersistenceSystem.memorySaves) do
        result[saveName] = {
            name = saveName,
            campaign = snapshot.meta and snapshot.meta.campaign or "UNKNOWN",
            map = snapshot.meta and snapshot.meta.map or "UNKNOWN",
            createdAt = snapshot.meta and snapshot.meta.createdAt or 0,
            version = snapshot.meta and snapshot.meta.version or "UNKNOWN"
        }
    end

    return result
end

function PersistenceSystem.getLastExport()
    return PersistenceSystem.lastExport
end

function PersistenceSystem.getLastImport()
    return PersistenceSystem.lastImport
end

function PersistenceSystem.getLastError()
    return PersistenceSystem.lastError
end

function PersistenceSystem.markDirty(reason)
    return markDirty(reason or "manual_dirty_mark")
end

function PersistenceSystem.clearDirty()
    return clearDirty()
end

function PersistenceSystem.isDirty()
    local state = getState()

    if state == nil or state.Persistence == nil then
        return false
    end

    return state.Persistence.dirty == true
end

function PersistenceSystem.validateSnapshot(snapshot)
    if type(snapshot) ~= "table" then
        return false, "snapshot_not_table"
    end

    if type(snapshot.data) ~= "table" then
        return false, "snapshot_data_missing"
    end

    if type(snapshot.data.Campaign) ~= "table" then
        return false, "campaign_section_missing"
    end

    if type(snapshot.data.Bases) ~= "table" then
        return false, "bases_section_missing"
    end

    if type(snapshot.data.Zones) ~= "table" then
        return false, "zones_section_missing"
    end

    return true
end

function PersistenceSystem.start()
    if PersistenceSystem.started == true and PersistenceSystem.finished == true and PersistenceSystem.failed ~= true then
        logDebug("Persistence system already started")
        return true
    end

    PersistenceSystem.started = true
    PersistenceSystem.finished = false
    PersistenceSystem.failed = false
    PersistenceSystem.lastError = nil

    setModuleStatus("STARTING")
    setFeatureStatus(false)

    logInfo("Persistence system started")

    local state = ensurePersistenceState()

    if state == nil then
        PersistenceSystem.failed = true
        PersistenceSystem.lastError = "state_unavailable"
        setModuleStatus("FAILED")
        setFeatureStatus(false)
        logError("Persistence system failed: state_unavailable")
        return false
    end

    local sandboxResult = PersistenceSystem.runSandboxTest()

    if sandboxResult ~= nil and sandboxResult.fileSystemAvailable == true then
        setFeatureStatus(true)
    else
        setFeatureStatus(false)
    end

    setModuleStatus("RUNNING")

    PersistenceSystem.finished = true
    PersistenceSystem.failed = false

    logInfo(
        "Persistence system initialized: sandboxStatus="
            .. tostring(sandboxResult and sandboxResult.status or "UNKNOWN")
            .. ", fileSystemAvailable="
            .. boolText(sandboxResult ~= nil and sandboxResult.fileSystemAvailable == true)
    )

    return true
end

function PersistenceSystem.stop()
    PersistenceSystem.started = false
    PersistenceSystem.finished = false

    setModuleStatus("STOPPED")

    logInfo("Persistence system stopped")

    return true
end

function PersistenceSystem.summary()
    local state = getState()
    local persistenceState = nil

    if state ~= nil then
        persistenceState = state.Persistence
    end

    return {
        name = PersistenceSystem.name,
        displayName = PersistenceSystem.displayName,
        path = PersistenceSystem.path,
        version = PersistenceSystem.version,
        loaded = PersistenceSystem.loaded,
        started = PersistenceSystem.started,
        finished = PersistenceSystem.finished,
        failed = PersistenceSystem.failed,
        lastSaveName = PersistenceSystem.lastSaveName,
        lastError = PersistenceSystem.lastError,
        memorySaveCount = countTableKeys(PersistenceSystem.memorySaves),
        dirty = PersistenceSystem.isDirty(),
        sandbox = PersistenceSystem.lastSandboxResult,
        fileSystemAvailable = PersistenceSystem.isFilePersistenceAvailable(),
        state = persistenceState
    }
end

TC.Campaign.PersistenceSystem = PersistenceSystem
TC.campaign.PersistenceSystem = PersistenceSystem

TC.modules.persistenceSystem = {
    name = PersistenceSystem.name,
    path = PersistenceSystem.path,
    loaded = true,
    version = PersistenceSystem.version
}

local state = getState()

if state ~= nil and state.setModuleStatus ~= nil then
    state.setModuleStatus("persistenceSystem", "LOADED")
end

logInfo("Loaded " .. PersistenceSystem.path .. " v" .. PersistenceSystem.version)

return PersistenceSystem
