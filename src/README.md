# Source – Theater Command DCS

## Verbindlicher Stand — 2026-09-29

Dieser Ordner enthält die eigene Lua-Logik von **Theater Command DCS**.

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

## 1. Grundprinzip

Theater Command DCS folgt der Trennung:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis / Source of Truth
    DCS Runtime = autoritativer Verhaltensbeweis

Der Ordner:

    src/

enthält ausschließlich eigene Theater-Command-Logik.

Externe Frameworks liegen unter:

    vendor/

Frameworks werden nicht verändert.

Eigene Logik wird nach fachlicher Aufgabe organisiert und nicht nach Framework.

---

## 2. Architekturregel

Nicht gewünscht:

    tc_moose.lua
    tc_mist.lua
    tc_ctld.lua
    tc_ctld_bridge.lua
    tc_ctld_all_in_one.lua
    tc_skynet.lua
    tc_frameworks.lua
    tc_all_in_one.lua

Gewünscht sind fachlich benannte Module wie:

    tc_airbase_scanner.lua
    tc_zone_factory.lua
    tc_capture_system.lua
    tc_logistics_delivery.lua
    tc_fob_system.lua
    tc_mission_generator.lua
    tc_ai_cap_manager.lua
    tc_persistence_system.lua
    tc_f10_menu.lua

Ein fachliches Modul darf intern ein Vendor-Framework verwenden.

Beispiel:

    LogisticsDelivery
    -> kann später CTLD als Execution Layer nutzen

Dadurch wird das Modul nicht zu einem generischen CTLD-Wrapper.

---

## 3. Aktuelle Source-Struktur

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

Aktiv:

    core
    world
    campaign
    logistics
    missions
    ai
    ui

Vorbereitet, aber noch ohne produktives eigenes Lua-Modul:

    iads
    debug

---

## 4. Aktuelle Modulversionen

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

Vendor-relevant:

    CTLD 1.6.1
    MOOSE 2.9.17
    Skynet IADS 3.3.0
    MIST 4.5.128-DYNSLOTS-02

---

## 5. Aktive Ladefolge

Die DEV-Mission verwendet weiterhin die sichere Einzeldatei-Ladung über:

    DO SCRIPT FILE

Theater-Command-Ladefolge:

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

Vendor-Frameworks werden vorher geladen.

Loader-only per `dofile` ist weiterhin nicht der produktive Standard.

---

## 6. Core

Pfad:

    src/core/

Aufgaben:

- Konfiguration
- Logging
- gemeinsamer State
- Utilities
- Scheduler-Grundlage
- Modulstatus
- Featurestatus
- gemeinsame Konstanten

Core stellt Infrastruktur bereit.

Core soll keine fachlichen Kampagnenentscheidungen erzwingen.

Zentraler State:

    TC.State

Persistence-relevante Mutationen verwenden:

    TC.State.markDirty(reason)

Reads und echte No-Ops sollen keinen Dirty-State erzeugen.

---

## 7. World

Pfad:

    src/world/

Aktive Dateien:

    tc_airbase_scanner.lua
    tc_zone_factory.lua

Bestätigt:

    Airbase-like Objects: 225
    Strategic Airfields: 19
    Secondary Airfields: 13
    Capture Candidates: 32
    Mission Candidates: 32
    Logistics Candidates: 46
    relevante Kampagnenzonen: 46

ZoneFactory reduziert die DCS-Rohdaten bewusst auf fachlich relevante Kampagnenobjekte.

Nicht alle 225 Airbase-like Objects werden zu Kampagnenzonen.

---

## 8. Campaign

Pfad:

    src/campaign/

Aktive Dateien:

    tc_capture_system.lua
    tc_persistence_system.lua

CaptureSystem:

    v0.2.2

Bestätigt:

- Capture Eligibility
- Capture Pressure
- Capture Progress
- Capture Ready
- Mission Effects
- Ownership Apply
- linked Airbase Ownership
- Read-Neutrality
- same-owner No-Op

Bestätigter Pfad:

    Mission Completion
    -> Capture Pressure
    -> Capture Progress
    -> Capture Ready
    -> Apply
    -> Ownership
    -> Persistence

Mission Failure:

    erzeugt aktuell bewusst keinen Capture Pressure

---

## 9. Persistence

PersistenceSystem:

    v0.2.6

Bestätigt:

- Save
- Read-back
- Compile
- Evaluate
- Validation
- kontrollierter Import
- Background Autosave
- `SAVED`
- `SKIPPED`
- kontrollierter `FAILED`
- Retry
- Dirty-Clear erst nach erfolgreicher Verifikation

Autosave:

    initialDelay=20s
    interval=120s

Verbindlich:

    productiveRestore=false

Technische Importfähigkeit ist vorhanden.

Produktiver Startup-Restore ist noch nicht freigegeben.

---

## 10. Logistics

Pfad:

    src/logistics/

Aktive Dateien:

    tc_logistics_delivery.lua
    tc_fob_system.lua

LogisticsDelivery:

    v0.2.1

Bestätigt:

    Logistics Hubs: 46
    Blue: 7
    Red: 24
    Neutral: 15
    Active: 31
    Limited: 15
    Locked: 0

FobSystem:

    v0.2.1

Bestätigt:

    FOB Candidates: 6
    Blue FOBs: 2

FOBs:

    FOB Ercan
    FOB Gecitkale

Status:

    UNDER_CONSTRUCTION

Beide Systeme haben ihre Priority-3-Read-Neutrality-Regression bestanden.

Die FOBs sind weiterhin Theater-Command-State und noch keine real durch CTLD gebauten DCS-FOBs.

---

## 11. Missions

Pfad:

    src/missions/

Aktive Datei:

    tc_mission_generator.lua

Version:

    v0.2.3

Bestätigt:

    Mission Candidates: 78
    FOB Support Candidates: 2
    Mission Records: 10

Bestätigte Statuswechsel:

    AVAILABLE -> ACTIVE
    ACTIVE -> COMPLETED
    ACTIVE -> FAILED

Mission Collections sind:

    String-keyed Lua-Dictionaries

Deshalb ist:

    #table

für ihre Anzahl nicht autoritativ.

Korrekte Zählung erfolgt über:

    pairs()

Der frühere Verdacht eines Mission-Record-Verlusts wurde am 2026-09-12 widerlegt.

Es gingen keine Mission Records verloren.

Der damalige Fehler lag in einer falschen Count-Auswertung in:

    src/core/tc_state.lua

MissionGenerator selbst benötigte dafür keinen Record-Loss-Fix.

---

## 12. AI

Pfad:

    src/ai/

Aktive Datei:

    tc_ai_cap_manager.lua

Version:

    v0.2.1

Bestätigt:

    CAP Zone Candidates: 31
    CAP Zones: 12
    CAP Requests: 12

Status:

    state-first bestanden
    Read-Neutrality bestanden

Noch nicht vorhanden:

    reale MOOSE-CAP-Flüge
    vollständiger AI Director

Latenter Lifecycle-Punkt:

    reactToActiveMissions()

besitzt aktuell keine produktive Call-Site.

Er wird bei einer späteren Verdrahtung erneut geprüft.

---

## 13. UI

Pfad:

    src/ui/

Aktive Datei:

    tc_f10_menu.lua

Version:

    v0.2.3

Bestätigt:

    33 Commands

F10 dient aktuell hauptsächlich:

- Status
- Sichtbarkeit
- Debug
- kontrollierten Tests

Unter anderem verfügbar:

- Missionen anzeigen
- Missionen aktivieren
- Mission Completion
- Mission Failure
- Campaign Status
- Capture Status
- Capture Ready
- Capture Apply
- Pressure Contested
- Logistics Status
- FOB Status
- AI CAP Status

Die spätere Kampagne soll nicht davon abhängen, dass der Spieler Hintergrundprozesse manuell über F10 auslöst.

---

## 14. IADS

Pfad:

    src/iads/

Aktuell:

    README vorhanden
    kein produktives eigenes IADS-Lua-Modul

Vendor:

    vendor/skynet-iads/SkynetIADS.lua
    Version 3.3.0

Skynet ist geladen.

Theater-Command-IADS-State und produktive Skynet-Kampagnenintegration sind noch nicht implementiert.

---

## 15. Debug

Pfad:

    src/debug/

Aktuell:

    README vorhanden
    kein produktives eigenes Debug-Modul

Perspektivisch möglich:

- State Dumps
- Airbase Reports
- Zone Reports
- Capture Reports
- Logistics Reports
- Mission Reports
- AI Reports
- IADS Reports

Debug darf produktiven State nicht versteckt verändern.

---

## 16. Main und Loader

Main:

    src/main.lua

Aufgabe:

- Runtime initialisieren
- Module starten
- Core-Prüfungen durchführen
- Runtime-Systeme koordinieren

Loader:

    src/loader.lua

Aufgabe:

- Framework-Verfügbarkeit prüfen
- Theater-Command-Startkette abschließen
- Main-Start bestätigen
- Fehler sichtbar machen

Beide sind im aktuellen Starttest bestanden.

---

## 17. Priority 3

Priority 3 wurde am:

    2026-09-21

im dokumentierten Umfang abgeschlossen.

Ergebnisse:

    LogisticsDelivery v0.2.1
    -> Read-Neutrality bestanden

    FobSystem v0.2.1
    -> Read-Neutrality bestanden

    MissionGenerator v0.2.3
    -> kein aktiver Missing-Dirty-Bug gefunden

    AICapManager v0.2.1
    -> Read-Neutrality bestanden

Priority 3 ist nicht mehr der aktuelle Entwicklungsbereich.

---

## 18. CTLD-Stand

CTLD:

    1.6.1

Vendor:

    unverändert

Am 2026-09-29 wurde für einen isolierten getesteten Aufbau ein vollständiger KI-Truppentransport praktisch bestätigt.

Getestete Unit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Luftfahrzeug:

    Mi-8

Bestätigter Pfad:

    Runtime-Zonenregistrierung
    -> Transporterregistrierung
    -> automatischer Pickup
    -> Taxi
    -> Takeoff
    -> Transit
    -> Off-Airfield-Landung
    -> automatischer Dropoff
    -> reale Blue-Bodengruppe

Pickup:

    16 Soldaten

Erzeugte Gruppe:

    Dropped Group 2
    Group-ID 70001
    16 x Soldier M249

---

## 19. CTLD Runtime-Konfiguration

Für den getesteten Runtime-Pfad bestätigt:

Nach bestehender CTLD-Initialisierung konnten normalisierte Einträge ergänzt werden in:

    ctld.pickupZones
    ctld.dropOffZones

Eine erneute Ausführung von:

    ctld.initialize()

war für diesen getesteten Pfad nicht erforderlich.

Daraus wird nicht abgeleitet, dass eine erneute Initialisierung grundsätzlich verboten wäre.

Der getestete AI-Transporter musste zusätzlich in:

    ctld.transportPilotNames

registriert werden.

Diese Registrierung muss später durch Theater Command automatisch und idempotent erfolgen.

---

## 20. CTLD-Off-Airfield-Landung

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

Bestätigte minimale Entfernung zum Dropoff-Zentrum:

    ungefähr 1.06 m

Für diesen getesteten Truppentransport war kein Invisible FARP erforderlich.

Das ist keine allgemeine Aussage für andere:

- Luftfahrzeuge
- Cargo-Pfade
- FOBs
- Missionstypen

---

## 21. CTLD `RepackCommandsPath`

Beim Touchdown des registrierten KI-Transporters wurde genau einmal beobachtet:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Kontext:

    updateRepackMenu
    updateRepackMenuOnlanding

Pickup und Dropoff wurden trotzdem erfolgreich abgeschlossen.

Nicht bewiesen:

- dass der Fehler harmlos ist
- dass spätere Repack-Menü-Aktualisierungen funktionieren
- dass der betreffende Scheduler-Pfad weiterlief
- dass er beendet wurde

Ein möglicher Scheduler-Abbruch bleibt technische Inferenz und kein direkter Runtime-Beweis.

Verbindlich:

    vendor/ctld/CTLD.lua wird nicht gepatcht.

---

## 22. Grenze des CTLD-PoC

Bestanden für den getesteten Aufbau:

- Runtime-Zonenregistrierung
- Transporterregistrierung
- Pickup
- Transport
- Landung
- Dropoff
- Bodengruppenerzeugung

Noch nicht produktiv:

- Theater-Command-Transportauftrag
- automatische CTLD-Orchestrierung
- LogisticsDelivery-Rückkopplung
- FobSystem-Rückkopplung
- Crate Spawn
- Crate Loading
- Sling Load
- Cargo Drop
- Supply Cargo
- Engineering Cargo
- Repair Cargo
- Fuel Cargo
- Ammo Cargo
- realer FOB-Bau
- CTLD-Restore
- Multiplayer

Der erfolgreiche Test war:

    KI-Truppentransport

und kein:

    Cargo-/Crate-PoC

---

## 23. State-first bleibt verbindlich

Aktuelle Theater-Command-Systeme erzeugen zuerst nachvollziehbaren Kampagnenstate.

Framework-Execution wird erst kontrolliert ergänzt.

Grundfluss:

    Campaign State
    -> Intent
    -> Execution
    -> Result Validation
    -> State Mutation
    -> Dirty
    -> Persistence

Framework-Runtime darf nicht zum alleinigen Kampagnenstate werden.

---

## 24. Aktuelle Systempipeline

Bestätigte state-first Pipeline:

    AirbaseScanner
    -> ZoneFactory
    -> CaptureSystem

    ZoneFactory
    -> LogisticsDelivery
    -> FobSystem

    World / Capture / Logistics / FOB
    -> MissionGenerator

    World / Campaign
    -> AICapManager

    MissionGenerator Completion
    -> CaptureSystem
    -> Ownership
    -> Persistence

    F10Menu
    -> kontrollierte State-Funktionen

Noch nicht produktiv verbunden:

    MissionGenerator
    -> CTLD

    CTLD
    -> LogisticsDelivery

    CTLD
    -> FobSystem

    MissionGenerator
    -> MOOSE

    AICapManager
    -> MOOSE CAP

    MissionGenerator
    -> Skynet

    AI Director
    -> Gesamtstrategie

---

## 25. Persistence-Grenze zu Frameworks

Langfristiger Campaign-State gehört Theater Command.

Framework-Runtime wird nicht blind serialisiert.

Beispiel CTLD:

Später persistierbar können sein:

- Transportauftrag
- Empfänger
- Cargo-Typ
- Menge
- Erfolg
- State-Effekt
- Zeitpunkt

Nicht zwangsläufig persistierbar:

- komplette interne CTLD-Tabellen
- Scheduler
- Menüpfade
- temporäre DCS-Objektreferenzen

Nach einem späteren Restore muss Framework-Runtime kontrolliert aus Theater-Command-State rekonstruiert werden.

---

## 26. Aktueller nächster Entwicklungsbereich

Aktuell:

    Priority 4 – produktive CTLD-Integration vorbereiten

Vor dem ersten produktiven CTLD-Code muss geklärt werden:

1. welche fachliche Komponente den Transportauftrag besitzt,
2. welche Komponente Pickup-/Dropoff-Zonen registriert,
3. welche Komponente KI-Transporter registriert,
4. wie diese Registrierung idempotent bleibt,
5. wie Transporter-Lifecycle behandelt wird,
6. wie Erfolg und Fehler erkannt werden,
7. wie `RepackCommandsPath` ohne Vendor-Patch behandelt oder isoliert wird,
8. welche Ergebnisse in LogisticsDelivery zurückgeführt werden,
9. welche Ergebnisse in FobSystem zurückgeführt werden,
10. welche Mutationen Dirty setzen,
11. welche Daten persistiert werden,
12. welche Daten runtime-only bleiben,
13. was später bei Restore rekonstruiert werden muss.

Die konkrete nächste Source-Datei wird erst nach dieser Architekturentscheidung festgelegt.

---

## 27. Entwicklungswerkzeuge

Aktuelle Werkzeugrollen:

### ChatGPT

    Projektkoordination
    Architektur
    GitHub-Audit
    Testplanung
    Ergebnisbewertung
    Dokumentationsführung

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
    CTLD-Live-State
    Logs
    Runtime-Regressionen

Aus dem bestätigten Stand wird kein exakter DCS-SMS-Executable-Pfad abgeleitet.

### DCS

    autoritativer Runtime-Verhaltensbeweis

### GitHub

    Source of Truth

---

## 28. Arbeitsregel

Vor jeder neuen Implementierung:

1. aktuellen GitHub-Stand lesen,
2. relevante Source lesen,
3. relevante Dokumentation lesen,
4. genau eine konkrete Aufgabe definieren,
5. möglichst genau eine Datei ändern,
6. Commit durchführen,
7. lokal aktualisieren,
8. falls erforderlich `.miz` aktualisieren,
9. exakt den betroffenen Pfad testen,
10. Ergebnis dokumentieren.

Keine parallelen Großumbauten.

---

## 29. Aktueller Abschlussstand

Stand:

    2026-09-29

Bestanden:

    Core
    World
    Capture
    Persistence
    Logistics
    FOB
    MissionGenerator
    AI CAP State
    F10 UI
    Priority 3
    isolierter CTLD-KI-Truppentransport-PoC für den getesteten Aufbau

Aktuelle Versionen:

    AirbaseScanner v0.2.2
    ZoneFactory v0.2.0
    CaptureSystem v0.2.2
    PersistenceSystem v0.2.6
    LogisticsDelivery v0.2.1
    FobSystem v0.2.1
    MissionGenerator v0.2.3
    AICapManager v0.2.1
    F10Menu v0.2.3

Verbindlich:

    productiveRestore=false

Noch offen:

    produktive CTLD-Integration
    Cargo-/Crate-Pfad
    reale CTLD-FOBs
    reale MOOSE-Flüge
    AI Director
    IADS-Integration
    Ground Campaign
    produktiver Restore
    Carrier Operations
    Multiplayer

Aktueller Übergang:

    stabiler state-first Kampagnenkern
    +
    abgeschlossene Priority-3-Dirty-Coverage
    +
    bestandener CTLD-KI-Truppentransport-PoC
    ->
    kontrollierte produktive CTLD-Integration
