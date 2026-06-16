-- Theater Command DCS
-- File: src/core/tc_scheduler.lua
-- Purpose: Central scheduler helper module.

TC = TC or {}

TC.modules = TC.modules or {}

local Scheduler = {}

Scheduler.name = "tc_scheduler"
Scheduler.path = "src/core/tc_scheduler.lua"
Scheduler.version = TC.version or "0.1.0"
Scheduler.loaded = true

Scheduler.tasks = {}
Scheduler.nextTaskId = 0
Scheduler.running = true
Scheduler.initialized = false

local function getLogger()
  return TC.Logger or TC.logger
end

local function getState()
  return TC.State or TC.state
end

local function getUtils()
  return TC.Utils or TC.utils
end

local function getConfig()
  return TC.config or TC.Config or {}
end

local function getDebugConfig()
  local config = getConfig()

  return config.debug or config.Debug or {}
end

local function shouldShowSchedulerMessages()
  local debugConfig = getDebugConfig()

  return debugConfig.showSchedulerMessages == true
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

  if shouldShowSchedulerMessages() ~= true then
    return
  end

  if logger ~= nil and logger.debug ~= nil then
    logger.debug(message)
  end
end

local function toString(value)
  local utils = getUtils()

  if utils ~= nil and utils.toString ~= nil then
    return utils.toString(value)
  end

  if value == nil then
    return "nil"
  end

  return tostring(value)
end

local function getCurrentTime()
  if timer ~= nil and timer.getTime ~= nil then
    return timer.getTime()
  end

  local utils = getUtils()

  if utils ~= nil and utils.getCurrentTime ~= nil then
    return utils.getCurrentTime()
  end

  return 0
end

local function hasDcsTimer()
  return timer ~= nil and timer.scheduleFunction ~= nil and timer.getTime ~= nil
end

local function safeCall(callback, task)
  local utils = getUtils()

  if utils ~= nil and utils.safeCall ~= nil then
    return utils.safeCall(callback, task)
  end

  if type(callback) ~= "function" then
    return false, "callback_not_function"
  end

  local success, result = pcall(callback, task)

  if success ~= true then
    return false, result
  end

  return true, result
end

local function markStateModuleStatus(status)
  local state = getState()

  if state ~= nil and state.setModuleStatus ~= nil then
    state.setModuleStatus("scheduler", status)
  end
end

local function markStateFeatureStatus(isEnabled)
  local state = getState()

  if state ~= nil and state.setFeatureStatus ~= nil then
    state.setFeatureStatus("scheduler", isEnabled == true)
  end
end

local function normalizeDelay(delaySeconds)
  if type(delaySeconds) ~= "number" then
    return 1
  end

  if delaySeconds < 0 then
    return 0
  end

  return delaySeconds
end

local function normalizeInterval(intervalSeconds)
  if type(intervalSeconds) ~= "number" then
    return 1
  end

  if intervalSeconds <= 0 then
    return 1
  end

  return intervalSeconds
end

local function createTaskId()
  Scheduler.nextTaskId = Scheduler.nextTaskId + 1

  return Scheduler.nextTaskId
end

local function runTask(task, scheduledTime)
  if task == nil then
    return nil
  end

  if task.cancelled == true then
    task.status = "CANCELLED"
    task.active = false
    return nil
  end

  if Scheduler.running ~= true then
    task.status = "WAITING"
    return getCurrentTime() + 1
  end

  if task.paused == true then
    task.status = "PAUSED"
    return getCurrentTime() + 1
  end

  if type(task.callback) ~= "function" then
    task.status = "FAILED"
    task.active = false
    task.lastError = "callback_not_function"
    logError("Scheduler task failed: " .. task.name .. " - callback_not_function")
    return nil
  end

  task.status = "RUNNING"
  task.lastRunTime = getCurrentTime()
  task.lastScheduledTime = scheduledTime or task.lastRunTime
  task.runCount = task.runCount + 1

  logDebug("Scheduler running task: " .. task.name)

  local success, result = safeCall(task.callback, task)

  task.lastResult = result
  task.lastFinishedTime = getCurrentTime()

  if success ~= true then
    task.lastError = toString(result)
    task.status = "FAILED"

    logError("Scheduler task failed: " .. task.name .. " - " .. task.lastError)

    if task.repeating == true and task.continueOnError == true then
      task.status = "SCHEDULED"
      return getCurrentTime() + task.interval
    end

    task.active = false
    return nil
  end

  task.lastError = nil

  if task.repeating == true then
    if task.maxRuns > 0 and task.runCount >= task.maxRuns then
      task.status = "COMPLETED"
      task.active = false
      logDebug("Scheduler task completed: " .. task.name)
      return nil
    end

    task.status = "SCHEDULED"
    return getCurrentTime() + task.interval
  end

  task.status = "COMPLETED"
  task.active = false
  logDebug("Scheduler task completed: " .. task.name)

  return nil
end

local function scheduledCallback(task, scheduledTime)
  return runTask(task, scheduledTime)
end

local function scheduleTask(task)
  if task == nil then
    return false
  end

  if hasDcsTimer() ~= true then
    task.status = "TIMER_UNAVAILABLE"
    task.active = false

    logWarn("Scheduler could not schedule task because DCS timer is unavailable: " .. task.name)

    return false
  end

  local startTime = getCurrentTime() + task.delay

  task.active = true
  task.status = "SCHEDULED"
  task.scheduledStartTime = startTime

  timer.scheduleFunction(scheduledCallback, task, startTime)

  logDebug("Scheduler task scheduled: " .. task.name)

  return true
end

function Scheduler.init()
  Scheduler.tasks = Scheduler.tasks or {}
  Scheduler.running = true
  Scheduler.initialized = true

  markStateModuleStatus("LOADED")
  markStateFeatureStatus(true)

  logInfo("Scheduler initialized")

  return Scheduler
end

function Scheduler.isInitialized()
  return Scheduler.initialized == true
end

function Scheduler.isTimerAvailable()
  return hasDcsTimer()
end

function Scheduler.start()
  Scheduler.running = true

  logDebug("Scheduler started")

  return true
end

function Scheduler.stop()
  Scheduler.running = false

  logDebug("Scheduler stopped")

  return true
end

function Scheduler.createTask(name, callback, options)
  local taskOptions = options or {}
  local taskId = createTaskId()

  local task = {
    id = taskId,
    name = name or ("task_" .. taskId),
    callback = callback,
    args = taskOptions.args or {},
    delay = normalizeDelay(taskOptions.delay),
    interval = normalizeInterval(taskOptions.interval),
    repeating = taskOptions.repeating == true,
    continueOnError = taskOptions.continueOnError == true,
    maxRuns = taskOptions.maxRuns or 0,
    runCount = 0,
    createdAt = getCurrentTime(),
    scheduledStartTime = nil,
    lastScheduledTime = nil,
    lastRunTime = nil,
    lastFinishedTime = nil,
    lastResult = nil,
    lastError = nil,
    status = "CREATED",
    active = false,
    paused = false,
    cancelled = false
  }

  Scheduler.tasks[taskId] = task

  return task
end

function Scheduler.scheduleOnce(name, callback, delaySeconds, args)
  local task = Scheduler.createTask(name, callback, {
    delay = delaySeconds,
    interval = 0,
    repeating = false,
    args = args or {},
    continueOnError = false,
    maxRuns = 1
  })

  scheduleTask(task)

  return task
end

function Scheduler.scheduleRepeating(name, callback, intervalSeconds, startDelaySeconds, args)
  local task = Scheduler.createTask(name, callback, {
    delay = startDelaySeconds or intervalSeconds,
    interval = intervalSeconds,
    repeating = true,
    args = args or {},
    continueOnError = true,
    maxRuns = 0
  })

  scheduleTask(task)

  return task
end

function Scheduler.scheduleRepeatingLimited(name, callback, intervalSeconds, startDelaySeconds, maxRuns, args)
  local task = Scheduler.createTask(name, callback, {
    delay = startDelaySeconds or intervalSeconds,
    interval = intervalSeconds,
    repeating = true,
    args = args or {},
    continueOnError = true,
    maxRuns = maxRuns or 1
  })

  scheduleTask(task)

  return task
end

function Scheduler.cancel(taskId)
  local task = Scheduler.tasks[taskId]

  if task == nil then
    return false
  end

  task.cancelled = true
  task.active = false
  task.status = "CANCELLED"

  logDebug("Scheduler task cancelled: " .. task.name)

  return true
end

function Scheduler.pause(taskId)
  local task = Scheduler.tasks[taskId]

  if task == nil then
    return false
  end

  task.paused = true
  task.status = "PAUSED"

  logDebug("Scheduler task paused: " .. task.name)

  return true
end

function Scheduler.resume(taskId)
  local task = Scheduler.tasks[taskId]

  if task == nil then
    return false
  end

  if task.cancelled == true then
    return false
  end

  task.paused = false

  if task.active == true then
    task.status = "SCHEDULED"
  else
    scheduleTask(task)
  end

  logDebug("Scheduler task resumed: " .. task.name)

  return true
end

function Scheduler.getTask(taskId)
  return Scheduler.tasks[taskId]
end

function Scheduler.getTaskByName(taskName)
  if taskName == nil then
    return nil
  end

  for _, task in pairs(Scheduler.tasks) do
    if task.name == taskName then
      return task
    end
  end

  return nil
end

function Scheduler.getTasks()
  return Scheduler.tasks
end

function Scheduler.getActiveTasks()
  local activeTasks = {}

  for taskId, task in pairs(Scheduler.tasks) do
    if task.active == true then
      activeTasks[taskId] = task
    end
  end

  return activeTasks
end

function Scheduler.getTaskCount()
  local count = 0

  for _ in pairs(Scheduler.tasks) do
    count = count + 1
  end

  return count
end

function Scheduler.getActiveTaskCount()
  local count = 0

  for _, task in pairs(Scheduler.tasks) do
    if task.active == true then
      count = count + 1
    end
  end

  return count
end

function Scheduler.clearCompleted()
  local removed = 0

  for taskId, task in pairs(Scheduler.tasks) do
    if task.status == "COMPLETED" or task.status == "CANCELLED" or task.status == "FAILED" then
      Scheduler.tasks[taskId] = nil
      removed = removed + 1
    end
  end

  logDebug("Scheduler cleared completed tasks: " .. removed)

  return removed
end

function Scheduler.clearAll()
  for taskId, task in pairs(Scheduler.tasks) do
    task.cancelled = true
    task.active = false
    task.status = "CANCELLED"
    Scheduler.tasks[taskId] = nil
  end

  Scheduler.tasks = {}

  logDebug("Scheduler cleared all tasks")

  return true
end

function Scheduler.runNow(taskId)
  local task = Scheduler.tasks[taskId]

  if task == nil then
    return false
  end

  runTask(task, getCurrentTime())

  return true
end

function Scheduler.summary()
  return {
    initialized = Scheduler.initialized,
    running = Scheduler.running,
    timerAvailable = Scheduler.isTimerAvailable(),
    taskCount = Scheduler.getTaskCount(),
    activeTaskCount = Scheduler.getActiveTaskCount()
  }
end

TC.Scheduler = Scheduler
TC.scheduler = Scheduler

TC.modules.scheduler = {
  name = Scheduler.name,
  path = Scheduler.path,
  loaded = true,
  version = Scheduler.version
}

Scheduler.init()

return Scheduler
