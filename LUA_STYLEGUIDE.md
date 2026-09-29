# Lua Styleguide

## Verbindlicher Stand — 2026-09-29

Diese Datei beschreibt die Lua-Programmier- und Architekturregeln für **Theater Command DCS**.

Projekt:

    Theater Command DCS

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue startet auf Akrotiri / Zypern.
    Das syrische Festland ist zu Kampagnenbeginn rot kontrolliert.

Aktueller Entwicklungsbereich:

    Priority 4 – produktive CTLD-Integration vorbereiten

Priority 3:

    abgeschlossen im dokumentierten Umfang seit 2026-09-21

Verbindlich:

    productiveRestore=false

---

## 1. Grundsatz

Theater Command DCS wird modular und task-orientiert entwickelt.

Grundprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis / Source of Truth
    DCS Runtime = autoritativer Verhaltensbeweis

Jede eigene Lua-Datei besitzt eine klar abgegrenzte fachliche Aufgabe.

Nicht gewünscht:

- All-in-one-Dateien
- Framework-Sammeldateien
- unnötige globale Variablen
- vermischte Framework- und Kampagnenlogik
- versteckte State-Mutationen
- Reads mit Persistence-Nebenwirkungen
- produktive DCS-Aktionen ohne vorher getesteten State-Pfad
- große parallele Umbauten ohne Einzeltest

---

## 2. Aktueller technischer Stand

Aktive eigene Dateien:

    src/loader.lua
    src/main.lua
    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
    src/core/tc_utils.lua
    src/core/tc_scheduler.lua
    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua
    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua
    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua
    src/missions/tc_mission_generator.lua
    src/ai/tc_ai_cap_manager.lua
    src/ui/tc_f10_menu.lua

Vorbereitet, aber noch ohne produktives eigenes Lua-Modul:

    src/iads/
    src/debug/

Aktuelle getestete Versionen:

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | dirty-aware Persistence bestanden |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.1` | Read-Neutrality bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.1` | Read-Neutrality bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | bestanden |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.1` | Read-Neutrality bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden; 33 Commands |

---

## 3. Externe Frameworks

Externe Frameworks liegen ausschließlich unter:

    vendor/

Aktueller Stand:

| Framework | Projektpfad | Version |
|---|---|---:|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD-i18n | `vendor/ctld/CTLD-i18n.lua` | geladen |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Verbindliche Regeln:

- Vendor-Dateien werden nicht verändert.
- Projektfixes werden nicht als lokale Vendor-Patches versteckt.
- Eigene Theater-Command-Logik wird nicht in Vendor-Dateien geschrieben.
- Frameworks sind Execution Layer.
- Theater Command bleibt Campaign Logic und State Owner.

Nicht erstellen:

    src/tc_moose.lua
    src/tc_mist.lua
    src/tc_ctld.lua
    src/tc_ctld_bridge.lua
    src/tc_ctld_all_in_one.lua
    src/tc_skynet.lua
    src/tc_all_in_one.lua

---

## 4. Lade-Reihenfolge

Aktuell wird die sichere Einzeldatei-Ladung über:

    DO SCRIPT FILE

verwendet.

Vendor:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua

Theater Command:

    1. src/core/tc_config.lua
    2. src/core/tc_logger.lua
    3. src/core/tc_state.lua
    4. src/core/tc_utils.lua
    5. src/core/tc_scheduler.lua
    6. src/world/tc_airbase_scanner.lua
    7. src/world/tc_zone_factory.lua
    8. src/campaign/tc_capture_system.lua
    9. src/campaign/tc_persistence_system.lua
    10. src/logistics/tc_logistics_delivery.lua
    11. src/logistics/tc_fob_system.lua
    12. src/missions/tc_mission_generator.lua
    13. src/ai/tc_ai_cap_manager.lua
    14. src/ui/tc_f10_menu.lua
    15. src/main.lua
    16. src/loader.lua

Wichtig:

- MIST vor CTLD.
- CTLD-i18n vor CTLD.
- eigene Dateien erst nach Vendor.
- F10Menu vor Main.
- Loader bleibt aktuell letzte eigene Datei.
- Loader-only über `dofile` ist nicht der produktive Standard.

---

## 5. Source-Struktur

Eigene Lua-Logik liegt unter:

    src/

Aktuelle Struktur:

    src/
    ├── README.md
    ├── loader.lua
    ├── main.lua
    ├── core/
    │   ├── README.md
    │   ├── tc_config.lua
    │   ├── tc_logger.lua
    │   ├── tc_state.lua
    │   ├── tc_utils.lua
    │   └── tc_scheduler.lua
    ├── world/
    │   ├── README.md
    │   ├── tc_airbase_scanner.lua
    │   └── tc_zone_factory.lua
    ├── campaign/
    │   ├── README.md
    │   ├── tc_capture_system.lua
    │   └── tc_persistence_system.lua
    ├── logistics/
    │   ├── README.md
    │   ├── tc_logistics_delivery.lua
    │   └── tc_fob_system.lua
    ├── missions/
    │   ├── README.md
    │   └── tc_mission_generator.lua
    ├── ai/
    │   ├── README.md
    │   └── tc_ai_cap_manager.lua
    ├── iads/
    │   └── README.md
    ├── ui/
    │   ├── README.md
    │   └── tc_f10_menu.lua
    └── debug/
        └── README.md

Regel:

    Struktur nach Aufgabe.
    Nicht nach Framework.

---

## 6. Dateinamen

Eigene Lua-Dateien beginnen mit:

    tc_

Schreibweise:

    kleinbuchstaben_mit_unterstrich.lua

Beispiele:

    tc_config.lua
    tc_logger.lua
    tc_state.lua
    tc_airbase_scanner.lua
    tc_zone_factory.lua
    tc_capture_system.lua
    tc_logistics_delivery.lua
    tc_fob_system.lua
    tc_mission_generator.lua
    tc_ai_cap_manager.lua
    tc_persistence_system.lua
    tc_f10_menu.lua

Dateinamen beschreiben die Theater-Command-Aufgabe.

Richtig:

    tc_ai_cap_manager.lua

Falsch:

    tc_moose_cap.lua

---

## 7. Globale Projekttabelle

Die eigene Projektlogik verwendet:

    TC

Nicht verwenden:

    TheaterCommand
    theaterCommand
    tc_global
    _G_TC

Grundform:

    TC = TC or {}
    TC.modules = TC.modules or {}
    TC.State = TC.State or {}
    TC.state = TC.state or TC.State

Regeln:

- `TC` ist die zentrale eigene globale Projektstruktur.
- unnötige eigene Einzel-Globals vermeiden.
- Framework-Globals nicht überschreiben.
- Module unter fachlich passenden `TC`-Bereichen registrieren.

Beispiele:

    TC.Campaign = TC.Campaign or {}
    TC.Campaign.CaptureSystem = CaptureSystem

    TC.Missions = TC.Missions or {}
    TC.Missions.Generator = MissionGenerator

    TC.UI = TC.UI or {}
    TC.UI.F10Menu = F10Menu

---

## 8. Lokale Variablen und Funktionen

Hilfsfunktionen grundsätzlich lokal halten, sofern keine öffentliche API benötigt wird.

Beispiel:

    local function getState()
        return TC.State or TC.state
    end

Lokale Konstanten sind erwünscht:

    local DEFAULT_CAPTURE_THRESHOLD = 100

Nicht unnötig global:

    campaignState = {}
    debugMode = true
    airbaseList = {}

Stattdessen:

    TC.State.Campaign = TC.State.Campaign or {}
    TC.State.Debug = TC.State.Debug or {}
    TC.State.Bases = TC.State.Bases or {}

---

## 9. Modulstruktur

Jede eigene Datei soll eine klar erkennbare Modulstruktur besitzen.

Beispiel:

    TC = TC or {}
    TC.modules = TC.modules or {}

    local ModuleName = {}

    ModuleName.name = "tc_module_name"
    ModuleName.version = "0.1.0"
    ModuleName.loaded = true
    ModuleName.started = false
    ModuleName.finished = false
    ModuleName.failed = false

    function ModuleName.start()
        return true
    end

    function ModuleName.summary()
        return {
            name = ModuleName.name,
            version = ModuleName.version,
            loaded = ModuleName.loaded,
            started = ModuleName.started,
            finished = ModuleName.finished,
            failed = ModuleName.failed
        }
    end

    return ModuleName

Regeln:

- Modulname und Datei fachlich konsistent halten.
- Version bei relevantem Verhalten ändern.
- Lifecycle-Flags konsistent führen.
- öffentliche Funktionen klar benennen.
- keine versteckten Seiteneffekte außerhalb der Modulaufgabe.

---

## 10. `start()`-Funktionen

Runtime-Module sollen nach Möglichkeit eine klare:

    start()

Funktion besitzen.

Beispiel:

    function CaptureSystem.start()
        CaptureSystem.started = true
        CaptureSystem.failed = false

        local state = ensureCampaignTables()

        if state == nil then
            CaptureSystem.failed = true
            return false, "state_unavailable"
        end

        return true
    end

Regeln:

- `start()` soll defensive Initialisierung verwenden.
- wiederholter Aufruf darf State nicht unkontrolliert zerstören.
- klare Rückgabewerte verwenden.
- echte Framework-Ausführung nicht beiläufig aus `start()` auslösen.
- Restore-/Init-Lifecycle später ausdrücklich definieren.

---

## 11. Summary-Funktionen

Größere Module sollen eine:

    summary()

Funktion bereitstellen.

Ziel:

- Debug
- F10
- Logauswertung
- Runtime-Diagnose
- Regression
- Persistence-Prüfung

Beispiel:

    function MissionGenerator.summary()
        return {
            name = MissionGenerator.name,
            version = MissionGenerator.version,
            missionCount = countTableKeys(MissionGenerator.availableMissions),
            activeCount = countTableKeys(MissionGenerator.activeMissions)
        }
    end

Wichtig:

    summary()

ist ein Read.

Eine Summary-Funktion darf nicht allein durch das Lesen von Daten persistenten State verändern.

---

## 12. Funktionsnamen

Funktionsnamen:

    camelCase

Beispiele:

    scanAirbases()
    createZones()
    updateCaptureProgress()
    applyMissionEffect()
    generateMissions()
    activateMission()
    completeMission()
    showCaptureStatus()

Interne Funktionen:

    local function normalizeName(value)
    end

    local function countTableKeys(targetTable)
    end

Unklare Namen vermeiden:

    doStuff()
    handleIt()
    runAll()

Funktionen sollen ihren fachlichen Zweck erkennen lassen.

---

## 13. Tabellen und Records

Records sollen sprechende und stabile Felder besitzen.

Gut:

    local missionRecord = {
        key = "MISSION_2",
        type = "AIRBASE_ATTACK",
        status = "ACTIVE",
        targetZoneKey = "ZONE_AIRBASE_ABU_AL_DUHUR",
        stateOnly = true
    }

Nicht:

    local m = {
        k = "MISSION_2",
        t = "AIRBASE_ATTACK"
    }

Regeln:

- stabile Keys
- klare Feldnamen
- persistierbare Daten bevorzugen
- keine Funktionen in Persistence-State
- keine Userdata in Persistence-State
- keine Threads in Persistence-State
- zyklische Persistenzstrukturen vermeiden

---

## 14. Dictionary- und Array-Semantik

Lua-Tabellen müssen entsprechend ihrer tatsächlichen Verwendung behandelt werden.

Mission-Status-Collections sind String-keyed Dictionaries:

    TC.State.Missions.available[missionKey] = missionRecord

Dazu gehören:

    available
    active
    completed
    failed
    expired
    cancelled

Für diese Dictionaries gilt:

    pairs()

oder eine pairs-basierte Count-Hilfe.

Nicht autoritativ:

    #table
    ipairs()

Diese bleiben korrekt für echte Arrays.

Beispiel:

    local count = 0

    for _ in pairs(targetTable) do
        count = count + 1
    end

Der frühere Mission-Record-Loss-Verdacht wurde am 2026-09-12 genau durch diese Unterscheidung widerlegt.

Live bestätigt:

    statistics.available = 10
    pairs()-Count = 10
    #available = 0

Es gingen keine Mission Records verloren.

---

## 15. State-first-Regel

Theater Command bleibt grundsätzlich state-first.

Grundfolge:

    State
    -> Intent
    -> Execution
    -> Result Validation
    -> State Mutation
    -> Dirty
    -> Persistence

Nicht:

    Framework Runtime
    =
    Campaign State

Neue Systeme sollen zunächst:

1. Domain-State definieren,
2. State erzeugen,
3. State sichtbar machen,
4. State testen,
5. Dirty-Semantik prüfen,
6. Persistence prüfen,
7. Framework-Fähigkeit isoliert testen,
8. Execution anbinden,
9. Ergebnis validieren,
10. Ergebnis in Theater-Command-State zurückführen.

---

## 16. Dirty-State-Regel

Persistierter Theater-Command-State benötigt klare Dirty-Semantik.

Verbindlich:

    echte persistierbare Mutation
    -> Dirty

    reiner Read
    -> kein Dirty

    semantischer No-Op
    -> kein Dirty

Mutation:

    TC.State.markDirty(reason)

Regeln:

- Dirty Reason fachlich benennen.
- Reads dürfen keine Timestamps oder persistierten Tabellen unnötig neu schreiben.
- No-Ops dürfen State nicht künstlich verändern.
- Dirty bei Save-Fehler erhalten.
- Dirty erst nach erfolgreicher Save-Verifikation löschen.
- neuere Mutation darf nicht durch Abschluss eines älteren Saves gelöscht werden.

---

## 17. Priority 3

Priority 3 ist abgeschlossen.

Abschluss:

    2026-09-21

Ergebnisse:

    LogisticsDelivery v0.2.1
    -> Read-Neutrality bestanden

    FobSystem v0.2.1
    -> Read-Neutrality bestanden

    MissionGenerator v0.2.3
    -> kein aktiver Missing-Dirty-Bug gefunden

    AICapManager v0.2.1
    -> Read-Neutrality bestanden

Daraus folgt:

- Priority 3 ist kein aktueller nächster Schritt.
- die gleichen vollständigen Audits werden ohne neuen Anlass nicht wiederholt.
- neu aktivierte Lifecycle-Pfade werden gezielt erneut geprüft.

---

## 18. Capture-Regeln

CaptureSystem:

    v0.2.2

Bestätigt:

- Capture Pressure
- Capture Progress
- Capture Ready
- Mission Effects
- Ownership Apply
- linked Airbase Ownership
- Getter Read-Neutrality
- same-owner No-Op

Bestätigter Test:

    MISSION_2
    -> ZONE_AIRBASE_ABU_AL_DUHUR
    -> BLUE pressure 105
    -> progress 100 %
    -> captureReady=true

Capture Apply:

    vorher:
    RED
    100 %
    captureReady=true

    nachher:
    zoneOwner=BLUE
    previousOwner=RED
    baseOwner=BLUE
    progress=0
    status=STABLE
    captureReady=false

Regeln:

- Ownership über Fachfunktion ändern.
- linked Zone/Base Ownership kontrolliert synchronisieren.
- Pressure nach Capture sauber zurücksetzen.
- Reads bleiben dirty-neutral.
- same-owner-Operation bleibt echter No-Op.

---

## 19. Missions-Regeln

MissionGenerator:

    v0.2.3

Bestätigt:

    Mission Candidates: 78
    Mission Records: 10
    FOB Support Candidates: 2

Statuswechsel:

    AVAILABLE -> ACTIVE
    ACTIVE -> COMPLETED
    ACTIVE -> FAILED

Regeln:

- Missionen entstehen aus Campaign State.
- stabile Mission Keys verwenden.
- Objectives und Briefings klar halten.
- Activation Metadata getrennt halten.
- Outcome State getrennt halten.
- Effects explizit repräsentieren.
- Framework Hooks bleiben von Campaign State unterscheidbar.
- Mission Completion bereitet Effects vor.
- Empfängersystem verarbeitet seinen Effect.
- Mission Failure erzeugt aktuell keinen Capture Pressure.
- `#` nicht für Mission Dictionaries verwenden.

---

## 20. UI-Regeln

F10Menu:

    v0.2.3

Bestätigt:

    33 Commands

Aktuell vorhanden:

- Available Missions
- Active Missions
- Mission Details 1–10
- Mission Activation 1–10
- Mission Outcome Status
- Complete Active Mission 1
- Fail Active Mission 1
- Campaign Status
- Capture Status
- Capture Ready Zones
- Apply Capture Ready Zone 1
- Pressure Contested Zones
- Logistics Status
- FOB Status
- AI CAP Status

Regeln:

- UI liest Fachstate.
- UI ruft definierte Fachfunktionen auf.
- UI implementiert keine Framework-Orchestrierung.
- UI mutiert Campaign State nicht direkt, wenn eine Fachfunktion existiert.
- UI-Aktionen klar loggen.
- Spieler-UI und spätere Debug-/Admin-Funktionen konzeptionell trennen.

Aktuell kein weiterer UI-Ausbau als Priority-4-Schritt.

---

## 21. Logging

Log-Ausgaben möglichst über den eigenen Logger.

Prefix:

    [TC]

Beispiele:

    [TC] [CaptureSystem] Loaded src/campaign/tc_capture_system.lua v0.2.2

    [TC] [MissionGenerator] Mission outcome prepared: MISSION_2 [COMPLETED] stateOnly=true effects=prepared

    [TC] [F10Menu] F10 menu initialized: commands=33

Regeln:

- Version beim Laden loggen.
- wichtige Lifecycle-Übergänge loggen.
- relevante State-Mutationen loggen.
- Dirty Reason bei gezielten Persistence-Tests nachvollziehbar halten.
- Framework Execution später eindeutig kennzeichnen.
- Fehler nicht verschlucken.

---

## 22. Fehlerbehandlung

Fehler sollen eindeutig sichtbar werden.

Typische Suchbegriffe:

    SCRIPTING ERROR
    Mission script error
    stack traceback
    attempt to
    nil value
    [TC][ERROR]
    [TC] [ERROR]
    cannot open

Regeln:

- Fehler nicht still ignorieren.
- `failed=true` setzen, wenn ein Modul nicht starten kann.
- Fehlergrund loggen.
- `true/false` plus Grund zurückgeben, wenn sinnvoll.
- bei unsicherem State keine produktive Aktion starten.
- Diagnose und Recovery nicht mit stiller Datenmutation vermischen.

Beispiel:

    if state == nil then
        CaptureSystem.failed = true
        logError("Capture system failed: state_unavailable")
        return false, "state_unavailable"
    end

---

## 23. Core-Regeln

`src/core/` enthält ausschließlich allgemeine technische Infrastruktur.

Aktiv:

    tc_config.lua
    tc_logger.lua
    tc_state.lua
    tc_utils.lua
    tc_scheduler.lua

Nicht in Core:

- Capture-Fachlogik
- MissionGenerator
- Logistics-Fachlogik
- CTLD-Orchestrierung
- IADS-Fachlogik
- AI Director
- konkrete F10-Menüs

Core bleibt möglichst stabil.

---

## 24. World-Regeln

`src/world/` enthält Welt- und Kartenlogik.

Aktiv:

    tc_airbase_scanner.lua
    tc_zone_factory.lua

World:

- erkennt
- klassifiziert
- strukturiert

World entscheidet nicht eigenständig über strategischen Kampagnenfortschritt.

Aktuell bestätigt:

    225 Airbase-like Objects
    46 relevante Kampagnenzonen

---

## 25. Campaign-Regeln

`src/campaign/` enthält strategischen Kampagnenstate.

Aktiv:

    tc_capture_system.lua
    tc_persistence_system.lua

Campaign verantwortet unter anderem:

- Ownership
- Capture
- Persistence

PersistenceSystem:

    v0.2.6

Verbindlich:

    productiveRestore=false

Produktiver Restore wird nicht aktiviert, bevor Restore-/Init-Reihenfolge, Versionierung, Framework-Rekonstruktion und End-to-End-Test geklärt sind.

---

## 26. Logistics-Regeln

`src/logistics/` enthält:

    tc_logistics_delivery.lua
    tc_fob_system.lua

Versionen:

    LogisticsDelivery v0.2.1
    FobSystem v0.2.1

Grundsatz:

    Theater Command = State Owner
    CTLD = Execution Layer

Aktuell:

- Logistics State bestanden.
- FOB State bestanden.
- Read-Neutrality bestanden.
- CTLD noch nicht produktiv angebunden.
- isolierter CTLD-KI-Truppentransport-PoC für den getesteten Aufbau bestanden.

Keine generische CTLD-Wrapper-Datei anlegen.

---

## 27. CTLD-Regeln

CTLD:

    1.6.1

Vendor bleibt unverändert.

Für den getesteten Aufbau bestätigt:

    Runtime-Zonenregistrierung
    -> Transporterregistrierung
    -> automatischer Pickup
    -> Taxi
    -> Takeoff
    -> Transit
    -> Off-Airfield-Landung
    -> automatischer Dropoff
    -> reale Bodengruppe

Luftfahrzeug:

    Mi-8

Pickup:

    16 Soldaten

Dropoff-Gruppe:

    Dropped Group 2
    Group-ID 70001
    16 x Soldier M249

Dieser Nachweis gilt:

    für den getesteten Aufbau

Er gilt nicht automatisch für:

- Crates
- Cargo
- Sling Load
- FOB-Bau
- andere Luftfahrzeuge
- andere Landezonen
- Multiplayer

---

## 28. CTLD-Konfigurationsregeln

Für den getesteten Runtime-Pfad konnten nach bestehender Initialisierung Einträge ergänzt werden in:

    ctld.pickupZones
    ctld.dropOffZones

Eine erneute:

    ctld.initialize()

Ausführung war dafür nicht erforderlich.

Daraus folgt nicht, dass ein erneuter Aufruf grundsätzlich verboten wäre.

KI-Transporter des getesteten Pfads mussten in:

    ctld.transportPilotNames

registriert sein.

Produktive Theater-Command-Registrierung muss später:

- automatisch
- idempotent
- duplikatfrei
- lifecycle-sicher

sein.

---

## 29. CTLD-Landeregel

Für den getesteten Mi-8-Aufbau erfolgreich:

    normaler Turning Point
    +
    Perform Task -> Land

Wegpunkt:

    100 m BARO
    30 m/s

Land Task:

    duration=300
    durationFlag=true

Touchdown erfolgte ungefähr:

    1.06 m

vom Dropoff-Zentrum entfernt.

Für diesen getesteten KI-Truppentransport war kein Invisible FARP erforderlich.

Dieser Befund darf nicht auf andere CTLD-Funktionsbereiche verallgemeinert werden.

---

## 30. `RepackCommandsPath`

Beim Touchdown des registrierten KI-Transporters wurde genau einmal beobachtet:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Kontext:

    updateRepackMenu
    updateRepackMenuOnlanding

Pickup und Dropoff wurden trotzdem erfolgreich abgeschlossen.

Nicht bewiesen:

- Fehler ist harmlos.
- Scheduler lief danach weiter.
- Scheduler wurde danach beendet.

Ein möglicher Scheduler-Abbruch bleibt:

    source-basierte technische Inferenz

Vendor-Code wird nicht gepatcht.

Eine Lösung oder Isolation muss an der Theater-Command-Integrationsgrenze erfolgen.

---

## 31. AI-Regeln

`src/ai/` enthält aktuell:

    tc_ai_cap_manager.lua
    v0.2.1

Bestätigt:

    CAP Zone Candidates: 31
    CAP Zones: 12
    CAP Requests: 12

AICapManager bleibt:

    state-first

MOOSE übernimmt später reale Air-Execution.

Ein vollständiger:

    tc_ai_director.lua

existiert noch nicht.

`reactToActiveMissions()` besitzt aktuell keine produktive Call-Site und bleibt ein latenter Lifecycle-Prüfpunkt.

---

## 32. IADS-Regeln

`src/iads/` besitzt aktuell kein produktives eigenes Lua-Modul.

Vendor:

    Skynet IADS 3.3.0

MissionGenerator kennt bereits:

    SEAD
    DEAD
    IADS_SUPPRESSION

Regeln:

- Skynet Vendor nicht verändern.
- IADS-State zuerst fachlich modellieren.
- nicht vorsorglich vollständige Syria-IADS-Struktur bauen.
- Skynet-Runtime später kontrolliert aus Theater-Command-State rekonstruieren.
- kein generisches `tc_skynet.lua`.

IADS ist aktuell nicht der nächste Projektbereich.

---

## 33. Debug-Regeln

`src/debug/` ist vorbereitet.

Aktuell existiert kein produktives eigenes Debug-Modul.

Debug darf später:

- State lesen
- State sichtbar machen
- Reports erzeugen
- klar gekennzeichnete Testpfade bereitstellen

Debug darf nicht versteckt:

- Campaign State mutieren
- Dirty erzeugen
- Framework-Aktionen auslösen
- Vendor-Dateien verändern

Aktuelle Diagnose erfolgt über:

    F10Menu
    dcs.log
    dcs-mcp
    DCS-SMS

---

## 34. Persistence-Regeln

PersistenceSystem:

    v0.2.6

Bestätigt:

- Initial Delay 20s
- Intervall 120s
- Dirty Awareness
- `SAVED`
- `SKIPPED`
- kontrollierter `FAILED`
- Retry
- Read-back
- Compile
- Evaluate
- Validation
- kontrollierter Import

Verbindlich:

    productiveRestore=false

Persistenzdaten dürfen keine:

- Userdata
- Funktionen
- Threads
- zyklischen Tabellen

enthalten.

Langfristiger Campaign State gehört Theater Command.

Vendor-Runtime wird nicht blind serialisiert.

Vor produktivem Restore weiterhin notwendig:

- Restore-/Init-Reihenfolge
- Save-Versionierung
- Kompatibilitätsstrategie
- Framework-Rekonstruktionsregeln
- kontrollierter End-to-End-Test

Priority 3 ist kein offener Restore-Blocker mehr.

---

## 35. Versionierung

Jede aktive eigene Lua-Datei führt eine Version.

Beispiel:

    CaptureSystem.version = "0.2.2"

Regeln:

- fachliche Verhaltensänderung -> Version prüfen/erhöhen
- Version im Log sichtbar machen
- nach bestandenem Test Dokumentation aktualisieren
- zentrale Versionsangaben synchron halten
- keine Versionsänderung nur aus kosmetischem Grund erzwingen

---

## 36. Framework-Integration

Neue Framework-Integration folgt:

    Theater-Command-Intent
    -> Framework Execution
    -> Result Validation
    -> Theater-Command-State

Nicht:

    Framework interne Tabelle verändert sich
    -> automatisch Kampagnenerfolg

Ergebnis muss fachlich validiert werden.

Erst danach:

    State Mutation
    -> Dirty
    -> Persistence

---

## 37. Runtime-Evidenz

Unterschiedliche Evidenzarten nicht vermischen.

### Source-Befund

Beweist:

- vorhandene Logik
- Call-Sites
- Datenpfade
- mögliche Fehlerursachen

### `.miz`-/Mission-Editor-Audit

Beweist:

- gespeicherte Gruppen
- Units
- Zonen
- Wegpunkte
- Tasks
- Trigger
- Embedded Resources

### Runtime-Beobachtung

Beweist:

- tatsächliches DCS-Verhalten
- AI-Bewegung
- Pickup
- Takeoff
- Landung
- Dropoff
- Spawn
- State-Verhalten

### Technische Inferenz

Ist eine begründete Schlussfolgerung.

Sie darf nicht als direkter Runtime-Beweis formuliert werden.

---

## 38. Commit- und Testregel

Nach Lua-Änderungen:

1. Datei auf GitHub aktualisieren.
2. Commit erstellen.
3. lokal fetchen/pullen.
4. betroffene Embedded-Ressource in der `.miz` aktualisieren.
5. Mission speichern.
6. Test vorbereiten.
7. DCS starten.
8. konkreten Pfad testen.
9. DCS-Log prüfen.
10. Ergebnis dokumentieren.

Ein weitergeführter `dcs.log` ist zulässig, wenn der relevante neue Abschnitt eindeutig identifizierbar ist.

---

## 39. Embedded Resources

Bei:

    DO SCRIPT FILE

wird die Datei in die `.miz` eingebettet.

Deshalb:

    GitHub Source geändert
    !=
    .miz automatisch aktualisiert

Letzter dokumentierter Embedded Resource Audit:

    2026-09-12

Ergebnis:

    13/13 relevante aktive Theater-Command-Ressourcen EXACT_MATCH

Dieser Audit ist abgeschlossen und kein aktueller nächster Schritt.

---

## 40. Entwicklungswerkzeuge

Aktuelle Rollen:

### ChatGPT

    Projektkoordination
    Architektur
    GitHub-Audit
    Testplanung
    Bewertung
    Dokumentation

### Claude + dcs-mcp

Version:

    dcs-mcp 0.9.11

Rolle:

    .miz
    Mission Editor
    Gruppen
    Units
    Zonen
    Wegpunkte
    Tasks
    gespeicherte Missionsstruktur

### Claude Code + DCS-SMS

Version:

    DCS-SMS 0.27.2

Hook:

    me-bridge-0.27.2

Verifiziertes Installationsverzeichnis:

    C:\Tools\dcs-sms

Rolle:

    lokale DCS-Runtime
    Runtime-Lua
    Theater-Command-State
    Framework-Live-State
    Logs
    Runtime-Regressionen

Aus dem bestätigten Stand wird kein exakter DCS-SMS-Executable-Pfad abgeleitet.

### DCS

    autoritativer Runtime-Verhaltensbeweis

### GitHub

    Source of Truth

Diese Werkzeuge sind Entwicklungs- und Diagnosewerkzeuge.

Sie sind keine Runtime-Abhängigkeiten der fertigen Kampagne.

---

## 41. Aktuelle technische Leitlinie

Priority 3 ist abgeschlossen.

Der CTLD-KI-Truppentransport-PoC ist für den getesteten Aufbau bestanden.

Aktueller Entwicklungsbereich:

    Priority 4 – produktive CTLD-Integration vorbereiten

Vor dem ersten produktiven CTLD-Code muss source-backed geklärt werden:

- welche fachliche Komponente den Transportauftrag besitzt
- welche Komponente CTLD-Zonen registriert
- welche Komponente KI-Transporter registriert
- wie Registrierungen idempotent bleiben
- wie der Transporter-Lifecycle behandelt wird
- wie `RepackCommandsPath` behandelt oder isoliert wird
- wie Pickup und Dropoff als fachliche Ergebnisse validiert werden
- wie LogisticsDelivery aktualisiert wird
- wie FobSystem aktualisiert wird
- welche Mutationen Dirty setzen
- welche Daten persistiert werden
- welche CTLD-Daten runtime-only bleiben
- was bei Restore rekonstruiert werden muss

Erst danach wird die konkrete nächste Source-Datei festgelegt.

---

## 42. Abschlussregel

Bei jeder neuen Implementierung:

    eine konkrete Aufgabe
    -> möglichst eine Datei
    -> ein klarer Test
    -> eindeutiges Ergebnis
    -> Dokumentation

Keine Parallelentwicklung mehrerer Framework-Integrationen.

Nicht parallel zu Priority 4:

- MOOSE CAP produktiv integrieren
- AI Director beginnen
- IADS produktiv integrieren
- produktiven Restore aktivieren
- Cargo-/Crate-System ohne separaten Test einführen

Aktueller Übergang:

    stabiler state-first Kampagnenkern
    +
    dirty-aware Persistence
    +
    abgeschlossene Priority-3-Dirty-Coverage
    +
    bestandener CTLD-KI-Truppentransport-PoC für den getesteten Aufbau
    ->
    kontrollierte produktive CTLD-Integration
