# Theater Command Skill

This skill contains project-specific implementation knowledge for AI development agents working on **Theater Command DCS**.

The global development rules are defined in:

    AGENTS.md

This file supplements those rules with current Theater Command architecture, workflow and implementation context.

Current authoritative project state:

    2026-09-29

---

# 1. Project Purpose

Theater Command DCS is a modular, dynamic and later persistent campaign framework for DCS World.

First campaign:

    Operation Levant Reclamation

Map:

    Syria

Initial campaign situation:

    Blue starts from Akrotiri / Cyprus.
    The Syrian mainland begins under Red control.

The long-term objective is a living battlefield where the player is one participant inside a larger autonomous military system.

---

# 2. Core Project Principle

Always preserve:

    Mission Editor = Stage
    Lua = Campaign System
    GitHub = Project Memory / Source of Truth
    DCS Runtime = Authoritative Behaviour Proof

Mission Editor provides the physical environment.

Lua provides dynamic campaign logic.

GitHub contains the authoritative source and documentation state.

DCS itself determines whether actual simulator behaviour works.

---

# 3. Current Development State

Current development phase:

    Priority 4

Priority 3:

    completed within documented scope on 2026-09-21

Current focus:

    prepare productive CTLD integration

Current confirmed CTLD status:

    CTLD 1.6.1
    isolated AI troop transport proof-of-concept passed

Confirmed tested path:

    runtime zone registration
    -> AI transport registration
    -> automatic pickup
    -> autonomous flight
    -> off-airfield landing
    -> automatic CTLD dropoff
    -> real Blue ground group

This is:

    framework capability proof

It is not yet:

    productive Theater Command CTLD orchestration

---

# 4. Required Reading

Before implementation, always read the current GitHub state.

Minimum:

    README.md
    ROADMAP.md
    TASKS.md
    ARCHITECTURE.md
    CHANGELOG.md
    MISSION_EDITOR_SETUP.md
    NAMING_CONVENTIONS.md
    LUA_STYLEGUIDE.md

Also read:

    relevant docs/
    relevant src/.../README.md
    relevant mission_editor/ documentation

For CTLD / logistics work additionally read:

    docs/05_logistics_system.md
    docs/09_persistence.md
    docs/10_testing.md
    mission_editor/ctld_start_zones.md
    src/logistics/README.md

Never continue only from memory or an old handover prompt.

GitHub is authoritative.

---

# 5. One Task Rule

Always work on:

    one concrete task
    one technical step
    preferably one file
    one commit

Do not redesign multiple systems simultaneously.

Do not create broad parallel work packages.

Do not perform unrelated cleanup while solving another task.

---

# 6. File Delivery Rule

When preparing a file for manual GitHub editing, always provide:

    exact file path
    complete file content
    exactly one contiguous code block
    exact commit text

Never provide:

    partial files
    continuation blocks
    omitted sections
    ellipses instead of content
    multiple blocks for one file

---

# 7. Repository Architecture

External frameworks:

    vendor/

Own Theater Command logic:

    src/

Project documentation:

    docs/
    mission_editor/

Vendor code and project code must remain separated.

---

# 8. Vendor Framework Rule

Vendor frameworks are immutable.

Current frameworks:

    MIST
    MOOSE
    CTLD
    Skynet IADS

Allowed:

    read vendor source
    inspect vendor APIs
    call vendor APIs
    test vendor behaviour
    build own integration logic

Forbidden:

    patch vendor code
    rename vendor files
    move vendor files
    copy modified vendor versions
    hide project fixes inside vendor code

Especially:

    vendor/ctld/CTLD.lua

must remain unchanged.

---

# 9. Own Source Structure

Own code is organized by Theater Command responsibility.

Current areas:

    src/core/
    src/world/
    src/campaign/
    src/logistics/
    src/missions/
    src/ai/
    src/iads/
    src/ui/
    src/debug/

Do not organize own code by framework name.

Explicitly unwanted filenames include:

    tc_all_in_one.lua
    tc_moose.lua
    tc_mist.lua
    tc_ctld.lua
    tc_ctld_all_in_one.lua
    tc_ctld_bridge.lua
    tc_logistics_all_in_one.lua

A functional module may internally use CTLD, MOOSE, MIST or DCS APIs.

Its filename must still describe the Theater Command task.

---

# 10. Current Active Modules

Confirmed current versions:

    Airbase Scanner      v0.2.2
    ZoneFactory          v0.2.0
    CaptureSystem        v0.2.2
    PersistenceSystem    v0.2.6
    LogisticsDelivery    v0.2.1
    FobSystem            v0.2.1
    MissionGenerator     v0.2.3
    AICapManager         v0.2.1
    F10Menu              v0.2.3
    CTLD                 1.6.1

If repository documentation, embedded mission resources or runtime output disagree:

    verify the actual current state

Do not guess.

---

# 11. State-First Architecture

Campaign state is owned by Theater Command.

Framework runtime is not the long-term campaign source of truth.

Development order:

    define state
    -> create state
    -> expose state
    -> test state
    -> verify dirty semantics
    -> prove framework capability in isolation
    -> integrate framework
    -> validate result
    -> update Theater Command state
    -> mark dirty
    -> persist

Do not activate large real DCS side effects before the state path is understood.

---

# 12. Framework Boundary

The central architecture boundary is:

    Theater Command
    =
    Campaign Logic
    Decision Layer
    State Owner

Frameworks:

    CTLD
    MOOSE
    Skynet IADS
    MIST

are:

    Execution Layer / technical infrastructure

Example:

Theater Command decides:

    a transport is required

CTLD performs:

    transport execution

Then Theater Command validates:

    result

and updates:

    TC.State

---

# 13. Persistence Model

Persistence belongs to Theater Command.

Current PersistenceSystem:

    v0.2.6

Confirmed:

    Save
    Read-back
    Compile
    Evaluate
    Validation
    controlled Import
    dirty-aware Background Autosave
    SAVED
    SKIPPED
    controlled FAILED
    Retry

Mandatory current setting:

    productiveRestore=false

Technical import capability does not mean productive mission-start restore is enabled.

Never document the campaign as automatically surviving mission restarts yet.

---

# 14. Dirty State

Persistence-related state is tracked under:

    TC.State.Persistence

Relevant values:

    dirty
    dirtyReason
    dirtyAt

Rules:

    real persistent mutation
    -> dirty

    pure read
    -> no dirty

    true no-op
    -> no dirty

Priority 3 verified this for the currently relevant active paths.

---

# 15. Priority 3

Priority 3 is complete within documented scope.

Confirmed:

    Capture Getter Read-Neutrality
    Capture Ownership No-Op
    LogisticsDelivery Read-Neutrality
    FobSystem Read-Neutrality
    MissionGenerator Dirty-Coverage Audit
    AICapManager Read-Neutrality

Do not restart the entire Priority 3 audit without a new technical reason.

Newly connected lifecycle paths still require targeted testing.

Example:

    AICapManager.reactToActiveMissions()

currently has no productive call site.

Recheck it only when it becomes part of the active lifecycle.

---

# 16. Mission State Counting

Mission status collections are string-keyed Lua dictionaries.

Relevant collections include:

    available
    active
    completed
    failed
    expired
    cancelled

Do not use:

    #table

as authoritative count for these dictionaries.

Use:

    pairs()

or project helpers based on `pairs()`.

The historical Mission Record loss diagnosis was disproven.

There is no confirmed Mission Record data loss.

---

# 17. Mission Editor Role

Mission Editor provides:

    terrain
    coalitions
    client slots
    groups
    templates
    trigger zones
    waypoints
    native DCS tasks
    statics
    FARPs
    embedded Lua resources

Mission Editor does not own:

    campaign decisions
    capture logic
    mission generation logic
    AI commander logic
    persistence lifecycle
    logistics decision logic

Large campaign behaviour belongs in Lua.

---

# 18. Current Missions

Main development mission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_DEV.miz

Successful isolated CTLD test mission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz

Pre-test SHA-256:

    5F0D89DF744A7083401E36713B148BD21813FF187CC36EC1F088507163458C57

Rule:

    test mission != DEV mission

Do not silently copy experimental changes into DEV.

---

# 19. Embedded Resource Rule

DCS `DO SCRIPT FILE` embeds the selected Lua file into the `.miz`.

Therefore:

    repository source changed
    !=
    embedded mission source changed automatically

After relevant source changes:

    update embedded resource
    save mission
    verify saved mission
    perform embedded audit when needed

The 2026-09-12 embedded resource audit confirmed:

    13/13 relevant active Theater Command resources EXACT_MATCH

That result applies to the audited version only.

---

# 20. Current CTLD Architecture

CTLD version:

    1.6.1

Current role:

    Execution Layer

Current proven capability:

    isolated AI troop transport

Not yet productive:

    Theater Command transport orchestration
    crate economy
    cargo flow
    FOB construction
    LogisticsDelivery result bridge
    FobSystem result bridge
    persistence restore integration

---

# 21. CTLD Runtime Zones

Confirmed pickup:

    CTLD_PICKUP_BLUE_AKROTIRI_01

Confirmed technical test dropoff:

    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01

Reserved later FOB dropoff:

    CTLD_DROPOFF_BLUE_ERCAN_FOB_01

Confirmed runtime tables:

    ctld.pickupZones
    ctld.dropOffZones

Tested pickup entry:

    { "CTLD_PICKUP_BLUE_AKROTIRI_01", -1, 10000, 1, 2 }

Tested dropoff entry:

    { "CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01", -1, 2, 1 }

A new call to:

    ctld.initialize()

was not required for the tested runtime append path.

Do not rewrite this as:

    ctld.initialize() must never be called again

That stronger claim is not established.

---

# 22. CTLD AI Transport Registration

Test unit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Aircraft:

    Mi-8

For the tested AI path the exact unit name had to be present in:

    ctld.transportPilotNames

Before temporary registration:

    108 entries

After registration:

    109 entries

The test unit existed exactly once.

Productive integration must later provide:

    automatic registration
    idempotence
    duplicate prevention
    lifecycle handling

Do not manipulate onboard troop state directly as a substitute for the real framework path.

---

# 23. CTLD Pickup Proof

Confirmed:

    16 soldiers automatically loaded

Pickup count:

    10000 -> 9999

The pickup was performed by CTLD.

Not used:

    manual CTLD loading
    direct inTransitTroops mutation
    teleport
    runtime route manipulation

---

# 24. CTLD Landing Proof

Successful stored DCS route:

    normal Turning Point
    +
    Perform Task -> Land

Waypoint:

    100 m BARO
    30 m/s

Land task:

    duration=300
    durationFlag=true

The tested Mi-8 reached the intended dropoff area and landed approximately:

    1.06 m

from the dropoff centre.

No FARP was required for this tested troop transport path.

A previous unbound:

    Land / Landing

waypoint did not produce the complete successful transport cycle.

Do not claim the exact previous failure cause is proven.

---

# 25. CTLD Dropoff Proof

Confirmed after landing:

    transported troops removed from onboard CTLD state
    new ctld.droppedTroopsBLUE entry
    real Blue ground group created

Created group:

    Dropped Group 2

Group ID:

    70001

Strength:

    16 x Soldier M249

Confirmed tested path:

    pickup
    -> transport
    -> off-airfield landing
    -> automatic dropoff
    -> ground group

---

# 26. CTLD RepackCommandsPath

At the grounded transition, exactly one error was observed:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Context:

    updateRepackMenu
    updateRepackMenuOnlanding

Source analysis suggests the registered AI unit reaches a CTLD landing/menu path where a player-oriented command path may not exist.

Do not state as proven:

    the error is harmless

Do not state as proven:

    the scheduler definitely dies

The latter is only an inference from the uncaught error path.

Vendor CTLD must not be patched.

A Theater Command-side integration strategy must address or isolate this path before productive use.

---

# 27. CTLD Proof Limits

The successful proof-of-concept tested:

    AI troop transport

It did not test:

    Crate Spawn
    Crate Loading
    Sling Load
    Crate Drop
    Supply Cargo
    Engineering Cargo
    Repair Cargo
    Fuel Cargo
    Ammo Cargo
    FOB Core
    real CTLD FOB construction
    productive LogisticsDelivery integration
    productive FobSystem integration
    CTLD restore
    multiplayer

Never extrapolate from troop transport to cargo functionality without testing.

---

# 28. Current Priority 4 Questions

Before productive CTLD code is created, determine:

    transport order ownership
    CTLD zone registration ownership
    transport pilot registration ownership
    registration timing
    idempotence
    transport lifecycle
    pickup detection
    success detection
    failure detection
    RepackCommandsPath handling
    Theater Command state updates
    dirty reasons
    runtime-only CTLD data
    restore reconstruction requirements

Only after this architecture is clear should the next source file be selected.

---

# 29. No Generic CTLD Bridge

There is currently no approved generic CTLD integration file.

Do not create:

    tc_ctld.lua
    tc_ctld_bridge.lua

or equivalent framework-named wrappers.

If a new file becomes necessary:

    define responsibility first

then:

    choose a task-oriented name

---

# 30. Development Tool Roles

Development tooling is separate from runtime architecture.

Tools must not become campaign dependencies.

---

# 31. ChatGPT Role

ChatGPT is primarily used for:

    project coordination
    architecture
    GitHub audit
    test planning
    result evaluation
    documentation leadership
    next-step definition
    preparation of precise work instructions

Project-wide conclusions should be checked against the current GitHub state.

---

# 32. Claude + dcs-mcp

Preferred tool for structured `.miz` and Mission Editor work.

Current version:

    dcs-mcp 0.9.11

Terrain store:

    C:\Users\Paul\AppData\Local\dcs-mcp\terrain

Syria terrain:

    installed

Use for:

    mission inspection
    groups
    units
    trigger zones
    waypoints
    tasks
    resources
    airbase relationships
    controlled .miz edits
    saved mission audit

Always inspect the current mission before modifying it.

Do not rebuild the mission blindly.

---

# 33. Claude Code + DCS-SMS

Preferred tool for local runtime diagnostics.

Current DCS-SMS version:

    0.27.2

Hook:

    me-bridge-0.27.2

Verified installation directory:

    C:\Tools\dcs-sms

Claude Code skill:

    C:\Users\Paul\.claude\skills\dcs-sms\SKILL.md

Use for:

    Mission Editor status
    runtime Lua
    Theater Command live state
    CTLD live state
    group state
    unit state
    position
    speed
    grounded / airborne state
    logs
    runtime regressions

Do not claim an exact executable path is verified when only the installation directory is known.

---

# 34. DCS Runtime

DCS itself remains the authoritative proof for actual simulator behaviour.

Only runtime observation can prove:

    taxi
    takeoff
    navigation
    landing
    CTLD pickup
    CTLD dropoff
    real spawn
    scheduler behaviour
    AI reaction

Stored mission structure and actual runtime behaviour are different evidence categories.

---

# 35. Evidence Categories

Always distinguish:

    source finding
    stored mission structure
    runtime observation
    inference

Example:

    Perform Task -> Land exists
    =
    stored mission structure

    Mi-8 actually lands
    =
    runtime observation

    uncaught error may terminate scheduler path
    =
    inference

Never silently promote inference into fact.

---

# 36. Standard Mission / Framework Workflow

For `.miz` or framework work:

    check GitHub
    -> define one concrete goal
    -> define acceptance criteria
    -> inspect current .miz with Claude + dcs-mcp
    -> make only the required mission change
    -> save
    -> inspect saved .miz
    -> prepare runtime test
    -> use Claude Code + DCS-SMS
    -> observe real DCS behaviour
    -> evaluate result
    -> document confirmed state in GitHub

---

# 37. Persistence Protection During Tests

If an isolated framework test could affect productive campaign state:

    check current save hash
    -> create backup
    -> verify backup hash
    -> set productive save ReadOnly
    -> confirm ReadOnly
    -> perform test
    -> fully stop DCS
    -> hash productive save again
    -> compare reference hash
    -> only then remove ReadOnly
    -> perform final verification

This process was successfully used during the CTLD test on 2026-09-29.

---

# 38. Current Productive Save Reference

Productive save:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Confirmed reference SHA-256 after the isolated CTLD test:

    C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596

The CTLD proof-of-concept did not modify this productive save.

---

# 39. Git Workflow

Before modification:

    read current repository state
    inspect affected file
    inspect relevant documentation

After modification:

    review the change
    prepare one commit message
    wait for user confirmation in the GitHub web workflow

Do not silently:

    commit
    push
    modify several files

unless explicitly instructed.

---

# 40. Documentation Discipline

Documentation is part of the architecture.

After a confirmed milestone, check whether these require synchronization:

    README.md
    ROADMAP.md
    TASKS.md
    ARCHITECTURE.md
    CHANGELOG.md
    relevant docs/
    relevant src/.../README.md
    relevant mission_editor/

Do not update every document after every tiny edit.

At the end of a development phase, documentation must be consistent with implementation and runtime evidence.

---

# 41. Naming Discipline

Follow:

    NAMING_CONVENTIONS.md
    MISSION_EDITOR_SETUP.md

Do not invent new naming schemes.

Keep existing:

    namespaces
    prefixes
    task-oriented filenames

---

# 42. Lua Style

Follow:

    LUA_STYLEGUIDE.md

Prefer:

    small modules
    clear ownership
    defensive validation
    explicit state mutation
    idempotent operations
    structured logging
    readable control flow

Avoid:

    monolithic files
    hidden side effects
    duplicate state
    framework-dependent architecture
    unnecessary global variables

---

# 43. Logging

Logging should support:

    state visibility
    test verification
    failure diagnosis
    lifecycle tracking

Prefer:

    clear module prefixes
    IDs
    state transitions
    meaningful reasons

Avoid unnecessary spam.

---

# 44. Performance

Avoid:

    unnecessary polling
    repeated full scans
    expensive loops without state changes
    constant framework polling

Prefer:

    event-driven updates
    cached data
    incremental state changes
    targeted schedulers
    idempotent registration

---

# 45. Definition of Done

A task is complete only when the relevant parts are satisfied.

Depending on the task:

    architecture understood
    source changed
    syntax checked
    mission structure checked
    runtime tested
    logs checked
    state checked
    dirty semantics checked
    persistence impact checked
    cleanup completed
    documentation synchronized
    user confirmed
    commit prepared

Do not mark untested runtime behaviour as complete.

---

# 46. Current Transition

Current confirmed base:

    stable state-first campaign core
    +
    dirty-aware PersistenceSystem v0.2.6
    +
    Priority 3 completed
    +
    CTLD AI troop transport proof-of-concept passed

Current transition:

    controlled productive CTLD integration

Architecture remains:

    Theater Command = Decision / State Layer
    CTLD = Execution Layer

---

# 47. Final Principle

Protect the architecture first.

Do not solve today's problem by damaging tomorrow's system.

Every implementation should move Theater Command toward:

    modular
    autonomous
    testable
    persistent
    maintainable
    vendor-safe
    framework-aware

campaign operation.
