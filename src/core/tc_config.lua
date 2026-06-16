-- Theater Command DCS
-- File: src/core/tc_config.lua
-- Purpose: Central project and campaign configuration.

TC = TC or {}

TC.version = "0.1.0"

TC.config = {
  project = {
    name = "Theater Command DCS",
    version = TC.version,
    namespace = "TC",
    repository = "https://github.com/PKrie/theater-command-dcs"
  },

  campaign = {
    name = "Operation Levant Reclamation",
    map = "Syria",
    blueStartRegion = "CYPRUS",
    blueStartBase = "AKROTIRI",
    initialRedTerritory = "SYRIAN_MAINLAND",
    initialBlueTerritory = "CYPRUS",
    initialFrontlineState = "RED_MAINLAND_CONTROL"
  },

  debug = {
    enabled = true,
    showStartupMessages = true,
    showFrameworkChecks = true,
    showModuleLoading = true,
    showStateInitialization = true,
    showSchedulerMessages = false
  },

  logging = {
    prefix = "[TC]",
    infoPrefix = "[TC]",
    warnPrefix = "[TC][WARN]",
    errorPrefix = "[TC][ERROR]",
    debugPrefix = "[TC][DEBUG]"
  },

  constants = {
    sides = {
      BLUE = "BLUE",
      RED = "RED",
      NEUTRAL = "NEUTRAL",
      UNKNOWN = "UNKNOWN"
    },

    status = {
      ACTIVE = "ACTIVE",
      INACTIVE = "INACTIVE",
      DESTROYED = "DESTROYED",
      DISABLED = "DISABLED",
      UNKNOWN = "UNKNOWN"
    },

    ownership = {
      BLUE = "BLUE",
      RED = "RED",
      NEUTRAL = "NEUTRAL",
      CONTESTED = "CONTESTED",
      UNKNOWN = "UNKNOWN"
    },

    missionStatus = {
      AVAILABLE = "AVAILABLE",
      ACTIVE = "ACTIVE",
      COMPLETED = "COMPLETED",
      FAILED = "FAILED",
      EXPIRED = "EXPIRED"
    },

    logisticsStatus = {
      AVAILABLE = "AVAILABLE",
      IN_TRANSIT = "IN_TRANSIT",
      DELIVERED = "DELIVERED",
      LOST = "LOST"
    }
  },

  paths = {
    loader = "src/loader.lua",
    main = "src/main.lua",

    core = {
      config = "src/core/tc_config.lua",
      logger = "src/core/tc_logger.lua",
      state = "src/core/tc_state.lua",
      utils = "src/core/tc_utils.lua",
      scheduler = "src/core/tc_scheduler.lua"
    },

    world = {
      airbaseScanner = "src/world/tc_airbase_scanner.lua",
      zoneFactory = "src/world/tc_zone_factory.lua"
    },

    campaign = {
      captureSystem = "src/campaign/tc_capture_system.lua",
      persistenceSystem = "src/campaign/tc_persistence_system.lua"
    },

    logistics = {
      logisticsDelivery = "src/logistics/tc_logistics_delivery.lua",
      fobSystem = "src/logistics/tc_fob_system.lua"
    },

    missions = {
      missionGenerator = "src/missions/tc_mission_generator.lua"
    },

    ai = {
      capManager = "src/ai/tc_ai_cap_manager.lua"
    },

    iads = {
      iadsNetwork = "src/iads/tc_iads_network.lua"
    }
  },

  frameworks = {
    mist = {
      name = "MIST",
      required = true,
      expectedGlobal = "mist",
      path = "vendor/mist/mist.lua",
      version = "4.5.128-DYNSLOTS-02"
    },

    moose = {
      name = "MOOSE",
      required = true,
      expectedGlobal = "BASE",
      path = "vendor/moose/Moose.lua",
      version = "2.9.17"
    },

    ctldI18n = {
      name = "CTLD i18n",
      required = true,
      expectedGlobal = nil,
      path = "vendor/ctld/CTLD-i18n.lua",
      version = "1.6.1"
    },

    ctld = {
      name = "CTLD",
      required = true,
      expectedGlobal = "ctld",
      path = "vendor/ctld/CTLD.lua",
      version = "1.6.1"
    },

    skynetIads = {
      name = "Skynet IADS",
      required = true,
      expectedGlobal = "SkynetIADS",
      path = "vendor/skynet-iads/SkynetIADS.lua",
      version = "3.3.0"
    }
  },

  loadOrder = {
    external = {
      "vendor/mist/mist.lua",
      "vendor/moose/Moose.lua",
      "vendor/ctld/CTLD-i18n.lua",
      "vendor/ctld/CTLD.lua",
      "vendor/skynet-iads/SkynetIADS.lua",
      "src/loader.lua"
    },

    core = {
      "src/core/tc_config.lua",
      "src/core/tc_logger.lua",
      "src/core/tc_state.lua",
      "src/core/tc_utils.lua",
      "src/core/tc_scheduler.lua"
    },

    internal = {
      "core",
      "world",
      "campaign",
      "logistics",
      "missions",
      "ai",
      "iads",
      "ui",
      "debug",
      "main"
    }
  },

  features = {
    airbaseScanner = false,
    zoneFactory = false,
    captureSystem = false,
    logisticsDelivery = false,
    fobSystem = false,
    missionGenerator = false,
    aiCapManager = false,
    iadsIntegration = false,
    persistence = false,
    f10Menu = false,
    debugTools = false
  }
}

TC.modules = TC.modules or {}

TC.modules.config = {
  name = "tc_config",
  path = "src/core/tc_config.lua",
  loaded = true,
  version = TC.version
}

return TC.config
