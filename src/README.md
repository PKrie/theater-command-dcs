# src/README.md

Diese Datei beschreibt die eigene Lua-Source-Struktur von **Theater Command DCS**.

Externe Frameworks liegen unter `vendor/`.

Eigene Kampagnenlogik liegt unter `src/`.

---

## 1. Grundsatz

Theater Command DCS folgt dem Prinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Ordner `src/` enthält ausschließlich eigene Theater-Command-Logik.

Frameworks werden nicht in `src/` abgelegt.

Frameworks werden nicht verändert.

---

## 2. Architekturregel

Eigene Lua-Dateien werden nach Aufgabenbereichen sortiert, nicht nach Frameworks.

Nicht gewünscht:

    tc_moose.lua
    tc_mist.lua
    tc_ctld.lua
    tc_all_in_one.lua

Gewünscht:

    tc_airbase_scanner.lua
    tc_zone_factory.lua
    tc_capture_system.lua
    tc_logistics_delivery.lua
    tc_fob_system.lua
    tc_mission_generator.lua
    tc_ai_cap_manager.lua
    tc_persistence_system.lua
    tc_f10_menu.lua

Grund:

    Theater Command soll fachlich modular bleiben.
    MOOSE, MIST, CTLD und Skynet IADS sind Werkzeuge.
    Die Kampagnenlogik gehört in eigene Module.

---

## 3. Aktueller Stand

Stand:

    2026-06-29

Aktueller Gesamtstatus:

    State-first Runtime-Grundlage stabil getestet.

Das Projekt ist noch keine fertige dynamische Kampagne.

Die eigene Lua-Runtime startet aber inzwischen sauber im DCS Mission Scripting Environment.

Bestätigt:

- Core-Dateien laden.
- World-Dateien laden.
- Campaign-Dateien laden.
- Logistics-Dateien laden.
- Missions-Dateien laden.
- AI-Dateien laden.
- UI-Datei lädt.
- Main startet.
- Loader beendet sauber.
- F10-Menü ist sichtbar.
- Missionen können über F10 angezeigt werden.
- Missionen können über F10 aktiviert werden.
- Capture-Pressure und Capture-Progress werden erzeugt.
- Logistics Hubs werden erzeugt.
- FOBs werden state-only erzeugt.
- AI-CAP-State wird erzeugt.

Noch nicht produktiv:

- echte MOOSE-Spawns
- echte CTLD-Aktionen
- echte CTLD-FOBs
- echte Skynet-IADS-Kampagnenlogik
- produktive Persistenz
- AI Director
- automatische Missionserfolgsauswertung
- automatische Capture-Auswertung aus Missionsergebnissen

---

## 4. Aktuelle Ordnerstruktur

Aktuelle Source-Struktur:

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

---

## 5. Aktive Lua-Dateien

Aktuell aktive eigene Lua-Dateien:

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
    src/main.lua
    src/loader.lua

Aktuell vorbereitet, aber noch nicht produktiv implementiert:

    src/iads/
    src/debug/

Wichtige Korrektur gegenüber älteren Dokumentationsständen:

    src/ui/ ist inzwischen aktiv.
    src/ui/tc_f10_menu.lua ist geladen, sichtbar, navigierbar und getestet.

---

## 6. Aktuelle Ladefolge

Die aktuelle DEV-Mission nutzt weiterhin sichere Einzeldatei-Ladung über `DO SCRIPT FILE`.

Aktive Theater-Command-Ladefolge:

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

    src/ui/tc_f10_menu.lua wird nach src/ai/tc_ai_cap_manager.lua und vor src/main.lua geladen.
    src/main.lua initialisiert die Runtime-Systeme.
    src/loader.lua bleibt aktuell die letzte eigene Datei.

---

## 7. Core

Pfad:

    src/core/

Aktive Dateien:

    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
    src/core/tc_utils.lua
    src/core/tc_scheduler.lua

Aufgaben:

- zentrale Konfiguration
- Logging
- globaler State
- Utility-Funktionen
- Scheduler-Grundfunktionen
- Modulstatus
- Featurestatus
- gemeinsame Konstanten

Regel:

    Core stellt Infrastruktur bereit.
    Core soll keine fachlichen Kampagnenentscheidungen treffen.

---

## 8. World

Pfad:

    src/world/

Aktive Dateien:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

Aufgaben:

- DCS-Airbase-Daten erfassen
- Airbase-like Objects klassifizieren
- relevante Kampagnenobjekte erkennen
- virtuelle Kampagnenzonen erzeugen
- World-State für andere Module bereitstellen

Aktueller getesteter Stand:

    Airbase Scanner: v0.2.2
    ZoneFactory: v0.2.0

Bestätigte Werte:

    Syria airbase-like objects: 225
    relevante Kampagnenzonen: 46
    captureCandidates: 32
    missionCandidates: 32
    logisticsCandidates: 46
    skipped airbase-like objects: 179

Bewertung:

    World Layer ist für den aktuellen state-first Stand bestanden.
    Die Filterung von 225 Airbase-like Objects auf 46 relevante Kampagnenzonen ist korrekt und gewollt.

---

## 9. Campaign

Pfad:

    src/campaign/

Aktive Dateien:

    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua

Aufgaben:

- strategischen Kampagnenzustand verwalten
- Ownership verwalten
- Capture-Eligibility verwalten
- Capture-Pressure vorbereiten
- Capture-Progress vorbereiten
- Mission Effects vorbereiten
- Persistenz vorbereiten

Aktueller getesteter Stand:

    CaptureSystem: v0.2.1
    PersistenceSystem: Grundstruktur lädt/startet

Bestätigte Capture-Werte:

    eligibleBases: 32
    eligibleZones: 32
    nonCaptureBases: 193
    nonCaptureZones: 14
    pressureRecords: 32
    progressRecords: 32
    appliedMissionEffects: 0
    ready: 0
    contested: 0

Bewertung:

    CaptureSystem ist bestanden.
    PersistenceSystem ist vorbereitet, aber noch nicht produktiv im DCS-Dateisystem getestet.

---

## 10. Logistics

Pfad:

    src/logistics/

Aktive Dateien:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

Aufgaben:

- Logistics Hubs erzeugen
- Supply-/Fuel-/Ammo-/Engineering-State vorbereiten
- Deliveries vorbereiten
- FOB-Kandidaten ableiten
- Blue-FOBs state-only planen
- spätere CTLD-Integration vorbereiten

Aktueller getesteter Stand:

    LogisticsDelivery: v0.2.0
    FobSystem: v0.2.0

Bestätigte Logistics-Werte:

    logistics hubs: 46
    blue hubs: 7
    red hubs: 24
    neutral hubs: 15
    active hubs: 31
    limited hubs: 15
    locked hubs: 0

Bestätigte FOB-Werte:

    FOB candidates: 6
    stored candidates: 6
    auto-planned FOBs: 2
    skipped candidates: 4
    Blue FOBs: 2

Erzeugte Blue-FOBs:

    FOB Ercan
    FOB Gecitkale

Status:

    UNDER_CONSTRUCTION

Bewertung:

    Logistics und FOBs sind state-first bestanden.
    CTLD ist geladen, aber noch nicht produktiv angebunden.

---

## 11. Missions

Pfad:

    src/missions/

Aktive Datei:

    src/missions/tc_mission_generator.lua

Aufgaben:

- Missionen aus Kampagnenzustand erzeugen
- Missionen priorisieren
- Missionen im State speichern
- FOB-Support berücksichtigen
- Mission Records fachlich anreichern
- Mission Activation vorbereiten
- Mission Effects vorbereiten
- MOOSE-/CTLD-/Skynet-Hooks reservieren

Aktueller getesteter Stand:

    MissionGenerator: v0.2.2

Bestätigte Werte:

    mission candidates: 69
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 30

Aktuelle Mission Records enthalten:

- ID
- Key
- Name
- Type
- Status
- Owner
- Target Zone
- Target Base
- Target FOB
- Priority
- Strategic Relevance
- Objective
- Briefing
- Progress
- Activation Metadata
- Execution Plan
- Effects
- reserved MOOSE hook
- reserved CTLD hook
- reserved Skynet hook

Bewertung:

    MissionGenerator ist bestanden.
    Missionen können über F10 direkt ausgewählt und aktiviert werden.
    Missionen bleiben state-only.
    Spawn-Hooks bleiben reserved.

---

## 12. AI

Pfad:

    src/ai/

Aktive Datei:

    src/ai/tc_ai_cap_manager.lua

Geplante spätere Datei:

    src/ai/tc_ai_director.lua

Aufgaben aktuell:

- CAP-Zonen aus Kampagnenlage ableiten
- CAP-State vorbereiten
- Blue-/Red-CAP-Bedarf vorbereiten
- spätere MOOSE-Anbindung vorbereiten

Aktueller getesteter Stand:

    AICapManager: v0.2.0

Bestätigte Werte:

    cap zone candidates: 31
    auto-registered CAP zones: 12
    CAP requests: 12
    reactionState: AIR_REACTION_REQUESTED
    threatLevel: HIGH

Bewertung:

    AICapManager ist state-first bestanden.
    Es werden noch keine echten MOOSE-CAP-Flüge gespawnt.
    spawn=MOOSE_PENDING ist erwartetes Verhalten.

---

## 13. IADS

Pfad:

    src/iads/

Aktueller Stand:

    Ordner vorbereitet.
    README vorhanden.
    eigenes Theater-Command-IADS-Modul noch nicht implementiert.

Vendor:

    vendor/skynet-iads/SkynetIADS.lua

Geplante Aufgaben:

- Skynet-IADS-Anbindung kapseln
- IADS-Sites erfassen
- IADS-Sektoren modellieren
- SAM-/EWR-/Command-Struktur abbilden
- IADS-State im Theater-Command-State speichern
- MissionGenerator mit IADS-Zielen verbinden
- SEAD-/DEAD-/IADS_SUPPRESSION-Wirkung vorbereiten
- IADS-Zustand persistieren

Aktueller Stand:

    Skynet IADS wird geladen und erkannt.
    MissionGenerator reserviert bereits Skynet-Hooks.
    Es gibt noch keine produktive Theater-Command-IADS-Kampagnenlogik.

---

## 14. UI

Pfad:

    src/ui/

Aktive Datei:

    src/ui/tc_f10_menu.lua

Aufgaben:

- F10-Menü bereitstellen
- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Mission 1 bis Mission 10 Details anzeigen
- Mission 1 bis Mission 10 aktivieren
- Kampagnenstatus anzeigen
- Logistikstatus anzeigen
- FOB-Status anzeigen
- AI-CAP-Status anzeigen

Aktueller getesteter Stand:

    F10Menu: v0.2.0

Bestätigte Werte:

    commands: 26

Bestätigte Funktionen:

- F10-Menü sichtbar
- F10-Menü navigierbar
- Mission Details Slot 1 bestätigt
- Mission Details Slot 2 bestätigt
- Mission Details Slot 5 bestätigt
- Mission Slot 1 aktiviert
- Mission Slot 5 aktiviert
- MissionGenerator setzt aktivierte Missionen auf ACTIVE
- Aktivierung bleibt state-only

Aktuelle Menüstruktur:

    F10
    └── Theater Command
        ├── Missions
        │   ├── Show Available Missions
        │   ├── Show Active Missions
        │   ├── Mission Details
        │   │   ├── Show Mission 1 Details
        │   │   ├── ...
        │   │   └── Show Mission 10 Details
        │   └── Activate Mission
        │       ├── Activate Mission 1
        │       ├── ...
        │       └── Activate Mission 10
        ├── Status
        │   └── Show Campaign Status
        ├── Logistics
        │   ├── Show Logistics Status
        │   └── Show FOB Status
        └── AI
            └── Show AI CAP Status

Bewertung:

    F10Menu ist bestanden.
    Das UI ist die aktuell wichtigste Sichtbarkeits- und Testfläche.

Nächster UI-Schritt:

    Capture-/Pressure-Status im F10-Menü sichtbar machen.

---

## 15. Debug

Pfad:

    src/debug/

Aktueller Stand:

    Ordner vorbereitet.
    README vorhanden.
    eigenes Debug-System noch nicht implementiert.

Geplante Aufgaben:

- State Dump
- Airbase Report
- Zone Report
- Capture Report
- Logistics Report
- FOB Report
- Mission Report
- AI Report
- IADS Report
- Debug-F10-Menü

Aktuelle Entscheidung:

    Debug wird später ausgebaut.
    Kurzfristig wird das bestehende F10-Menü um notwendige Capture-/Pressure-Sichtbarkeit erweitert.

---

## 16. Main

Datei:

    src/main.lua

Aufgabe:

- Theater-Command-Runtime initialisieren
- Systemstart koordinieren
- Runtime-Systeme starten
- Core-Prüfungen auslösen
- Startstatus loggen

Aktueller Status:

    lädt
    startet
    initialisiert Runtime-Systeme
    beendet sauber

Wichtige bestätigte Logik:

    Main start requested
    Core check passed
    Runtime systems initialized
    Main initialized
    Main started

---

## 17. Loader

Datei:

    src/loader.lua

Aufgabe:

- Theater-Command-Startkette abschließen
- Framework-Verfügbarkeit prüfen
- Main-Start auslösen oder bestätigen
- Startstatus loggen
- Fehler sichtbar machen

Aktueller Status:

    lädt als letzte eigene Datei
    erkennt Frameworks
    beendet sauber

Wichtige bestätigte Logik:

    Theater Command loader started
    Framework available: MIST
    Framework available: MOOSE
    Framework available: CTLD
    Framework available: Skynet IADS
    Theater Command loader finished

Wichtig:

    Loader-only-dofile ist noch nicht getestet.
    Aktuell bleibt sichere Einzeldatei-Ladung Standard.

---

## 18. State-first Runtime

Die aktuelle Runtime ist state-first.

Das bedeutet:

- Systeme erzeugen Daten im State.
- F10 zeigt State-Daten.
- Mission Activation verändert State.
- Capture Pressure ist State.
- Capture Progress ist State.
- Logistics Hubs sind State.
- FOBs sind State.
- AI CAP ist State.
- Framework-Hooks sind vorbereitet.
- echte Framework-Aktionen bleiben deaktiviert.

Nicht aktiv:

- echte MOOSE-Spawns
- echte CTLD-Aktionen
- echte Skynet-Aktionen
- produktive Persistenz
- automatische Missionserfolgsauswertung

Grund:

    DCS-Fehlerdiagnose ist komplex.
    Zuerst muss der Kampagnenzustand korrekt, sichtbar und testbar sein.
    Danach können echte Framework-Aktionen kontrolliert aktiviert werden.

---

## 19. Abhängigkeiten zwischen Modulen

Vereinfachter Datenfluss:

    AirbaseScanner
        -> ZoneFactory
        -> CaptureSystem
        -> LogisticsDelivery
        -> FobSystem
        -> MissionGenerator
        -> AICapManager
        -> F10Menu

Main startet die Runtime.

Loader prüft die Umgebung.

Aktuelle wichtigste Integrationen:

- Airbase Scanner liefert klassifizierte Airbase-Daten.
- ZoneFactory erzeugt relevante Kampagnenzonen.
- CaptureSystem erzeugt Eligibility, Pressure und Progress.
- LogisticsDelivery erzeugt Logistics Hubs.
- FobSystem erzeugt Blue-FOBs.
- MissionGenerator erzeugt Missionen inklusive FOB-Support.
- AICapManager erzeugt CAP-State.
- F10Menu zeigt Missionen, Campaign, Logistics, FOB und AI an.
- F10Menu aktiviert Missionen state-only.

Noch nicht vollständig integriert:

- Mission Completion zu Capture Effects
- Mission Completion zu Logistics Effects
- Mission Completion zu AI Effects
- Mission Completion zu IADS Effects
- CTLD zu Logistics/FOB
- MOOSE zu Missionen/CAP
- Skynet zu IADS-State
- Persistence zu vollständigem State
- AI Director zu Gesamtstrategie

---

## 20. Aktueller getesteter Systemstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.1` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | Grundstruktur | lädt/startet |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.2` | bestanden |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.0` | bestanden |

---

## 21. Erwartete Logmarker

Bei einem erfolgreichen aktuellen Testlauf sollten unter anderem diese Marker erscheinen:

    [TC] [AirbaseScanner] Loaded src/world/tc_airbase_scanner.lua v0.2.2
    [TC] [ZoneFactory] Loaded src/world/tc_zone_factory.lua v0.2.0
    [TC] [CaptureSystem] Loaded src/campaign/tc_capture_system.lua v0.2.1
    [TC] [CaptureSystem] Capture progress updated: zones=32, ready=0, contested=0
    [TC] [CaptureSystem] Capture pressure summary: pressureRecords=32, progressRecords=32, appliedMissionEffects=0
    [TC] [LogisticsDelivery] Loaded src/logistics/tc_logistics_delivery.lua v0.2.0
    [TC] [FobSystem] Loaded src/logistics/tc_fob_system.lua v0.2.0
    [TC] [MissionGenerator] Loaded src/missions/tc_mission_generator.lua v0.2.2
    [TC] [MissionGenerator] Mission candidate summary: candidates=69, fobSupportCandidates=2, availableBefore=0, generationSlots=10
    [TC] [MissionGenerator] Mission generation completed: 10 new missions from 69 candidates (fobSupportCandidates=2, reservedCreated=1, duplicatesSkipped=1, typeLimitSkipped=30)
    [TC] [MissionGenerator] Mission activation prepared: MISSION_4 stateOnly=true spawnHooks=reserved
    [TC] [AICapManager] Loaded src/ai/tc_ai_cap_manager.lua v0.2.0
    [TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.0
    [TC] [F10Menu] F10 menu initialized: commands=26
    [TC] [F10Menu] Mission details shown through F10: slot=1 key=MISSION_1
    [TC] [F10Menu] Mission activated through F10: slot=1 key=MISSION_1
    [TC] System started: F10 Menu
    [TC] Runtime systems initialized
    [TC] Main initialized
    [TC] Main started
    [TC] Theater Command loader finished

---

## 22. Nach jeder Lua-Änderung

Wichtig für DCS:

    Eine per DO SCRIPT FILE geladene Datei wird in die .miz eingebettet.

Nach jeder Lua-Änderung:

1. Datei auf GitHub aktualisieren
2. Commit durchführen
3. lokal per GitHub Desktop fetchen/pullen
4. DCS Mission Editor öffnen
5. geänderte Datei in der passenden DO SCRIPT FILE-Aktion neu auswählen
6. Mission speichern
7. alte dcs.log löschen oder umbenennen
8. DCS starten
9. Mission testen
10. dcs.log prüfen

Wenn im Log eine alte Version erscheint, wurde die Datei wahrscheinlich nicht neu in die `.miz` eingebettet.

---

## 23. Nächster sinnvoller Schritt

Empfohlene nächste Datei:

    src/ui/tc_f10_menu.lua

Ziel:

    Capture-/Pressure-Status im F10-Menü sichtbar machen.

Geplante neue F10-Funktionen:

    Show Capture Status
    Show Capture Ready Zones
    Show Pressure Contested Zones

Akzeptanzkriterien:

- F10Menu lädt als neue Version.
- bisherige 26 Commands bleiben funktionsfähig.
- neue Capture-Commands werden ergänzt.
- Capture Status zeigt mindestens:
  - eligibleBases
  - eligibleZones
  - pressureRecords
  - progressRecords
  - captureReady
  - pressureContested
  - appliedMissionEffects
- Capture Ready Zones können angezeigt werden.
- Pressure Contested Zones können angezeigt werden.
- keine echten Spawns
- keine CTLD-Aktion
- keine Skynet-Aktion
- keine Lua-Fehler
- keine Theater-Command-Fehler

Erwartete neue Logmarker nach Umsetzung:

    [TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.1
    [TC] [F10Menu] F10 menu initialized:
    [TC] [F10Menu] Capture status shown through F10
    [TC] [F10Menu] Capture ready zones shown through F10
    [TC] [F10Menu] Pressure contested zones shown through F10

---

## 24. Aktueller Abschlussstatus

Die Source-Struktur ist für den aktuellen Entwicklungsstand sauber angelegt.

Aktuell bestanden:

- Airbase Scanner
- ZoneFactory
- CaptureSystem
- LogisticsDelivery
- FobSystem
- MissionGenerator
- AICapManager
- F10Menu
- Main
- Loader

Aktuelle Fähigkeit:

- DCS lädt Theater Command.
- Airbases werden klassifiziert.
- relevante Kampagnenzonen werden erzeugt.
- Capture-Ziele werden erkannt.
- Capture-Pressure wird vorbereitet.
- Capture-Progress wird vorbereitet.
- Logistics Hubs werden erzeugt.
- FOBs werden geplant.
- Missionen werden erzeugt.
- Missionen können über F10 direkt ausgewählt werden.
- Missionen können über F10 direkt aktiviert werden.
- AI-CAP-State wird vorbereitet.
- F10-Menü ist sichtbar und nutzbar.

Nächster Entwicklungsschritt:

    src/ui/tc_f10_menu.lua
    Capture-/Pressure-Status im F10-Menü sichtbar machen.
