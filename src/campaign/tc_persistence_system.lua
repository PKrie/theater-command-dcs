-- Theater Command DCS
-- File: src/campaign/tc_persistence_system.lua
-- Purpose: Prepare campaign state export, import and in-memory persistence.

TC = TC or {}

TC.modules = TC.modules or {}
TC.Campaign = TC.Campaign or {}
TC.campaign = TC.campaign or TC.Campaign

local PersistenceSystem = {}

PersistenceSystem.name = "tc_persistence_system"
PersistenceSystem.path = "src/campaign/tc_persistence_system.lua"
PersistenceSystem.version = TC.version or "0.1.0"
PersistenceSystem.loaded = true
PersistenceSystem.started = false
PersistenceSystem.finished = false
PersistenceSystem.failed = false

PersistenceSystem.memorySaves = {}
PersistenceSystem.lastExport = nil
PersistenceSystem.lastImport = nil
PersistenceSystem.lastSaveName = nil
PersistenceSystem.lastError = nil

PersistenceSystem.sections = {
  "Campaign",
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
  state.Persistence.saveName = state.Persistence.saveName or getDefaultSaveName()
  state.Persistence.exportCount = state.Persistence.exportCount or 0
  state.Persistence.importCount = state.Persistence.importCount or 0

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

  for key, childValue in pairs(value) do
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
      version = TC.version or PersistenceSystem.version,
      campaign = campaignConfig.name or "Operation Levant Reclamation",
      map = campaignConfig.map or "Syria",
      createdAt = getCurrentTime(),
      format = "TC_LUA_TABLE_V1"
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
  end

  clearDirty()

  logInfo("Campaign state saved to memory: " .. name)

  return true, name
end

function PersistenceSystem.loadFromMemory(saveName)
  local name = saveName or PersistenceSystem.lastSaveName or getDefaultSaveName()
  local snapshot = PersistenceSystem.memorySaves[name]

  if snapshot == nil then
    PersistenceSystem.lastError = "memory_save_not_found"
    logWarn("Campaign memory save not found: " .. name)
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
  end

  logInfo("Campaign state loaded from memory: " .. name)

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

  logInfo("Campaign memory save deleted: " .. name)

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
  PersistenceSystem.started = true
  PersistenceSystem.finished = false
  PersistenceSystem.failed = false
  PersistenceSystem.lastError = nil

  logInfo("Persistence system started")

  local state = ensurePersistenceState()

  if state == nil then
    PersistenceSystem.failed = true
    PersistenceSystem.lastError = "state_unavailable"
    setModuleStatus("FAILED")
    logError("Persistence system failed: state_unavailable")
    return false
  end

  setFeatureStatus(true)
  setModuleStatus("RUNNING")

  PersistenceSystem.finished = true

  logInfo("Persistence system initialized")

  return true
end

function PersistenceSystem.stop()
  PersistenceSystem.started = false

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
    state = persistenceState
  }
end

TC.Campaign.PersistenceSystem = PersistenceSystem

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

logInfo("Persistence system loaded")

return PersistenceSystem
