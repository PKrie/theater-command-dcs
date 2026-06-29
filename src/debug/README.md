# src/debug/README.md

Diese Datei beschreibt den Debug-Bereich von **Theater Command DCS**.

Der Debug-Bereich enthält spätere eigene Lua-Logik für Testhilfen, State-Reports, Diagnosefunktionen und kontrollierte Entwicklungswerkzeuge.

---

## 1. Zweck des Debug-Bereichs

`src/debug/` ist für technische Kontrolle, Testausgaben und Entwicklungswerkzeuge zuständig.

Debug ist kein eigenes Kampagnen-Hauptsystem.

Debug soll helfen, den Zustand anderer Systeme sichtbar und nachvollziehbar zu machen.

Langfristig soll Debug anzeigen können:

- Core-Status
- Airbase-Status
- Zone-Status
- Capture-Status
- Capture-Pressure
- Capture-Progress
- Logistics-Status
- FOB-Status
- Mission-Status
- AI-Status
- IADS-Status
- Persistence-Status
- State-Dumps
- Testausgaben
- spätere Admin- oder Entwicklerfunktionen

Aktuell ist noch kein eigenes Debug-Lua-Modul implementiert.

Die wichtigste aktuelle Sichtbarkeitsfläche ist `src/ui/tc_f10_menu.lua`.

---

## 2. Kampagnenkontext

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

Grundprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

---

## 3. Aktueller technischer Stand

Stand:

    2026-06-29

Aktueller Debug-Ordner:

    src/debug/

Aktuell vorhanden:

    src/debug/README.md

Noch nicht vorhanden:

    src/debug/tc_debug_console.lua
    src/debug/tc_debug_state_dump.lua
    src/debug/tc_debug_airbase_report.lua
    src/debug/tc_debug_zone_report.lua
    src/debug/tc_debug_capture_report.lua
    src/debug/tc_debug_mission_report.lua
    src/debug/tc_debug_logistics_report.lua
    src/debug/tc_debug_ai_report.lua
    src/debug/tc_debug_iads_report.lua

Aktuelle Entscheidung:

    Kein eigenes Debug-Lua-Modul, solange F10Menu die unmittelbar nötige Sichtbarkeit noch erweitern kann.

Nächster Sichtbarkeitsschritt:

    Capture-/Pressure-Status im F10-Menü sichtbar machen.

---

## 4. Aktueller getesteter Gesamtstand

Der aktuelle state-first Runtime-Stand ist bestanden.

Bestätigte Systeme:

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

Aktuelle bestätigte Werte:

    Syria airbase-like objects: 225
    relevante Kampagnenzonen: 46
    capture-fähige Ziele: 32
    Capture-Pressure-Records: 32
    Capture-Progress-Records: 32
    Logistics Hubs: 46
    FOB-Kandidaten: 6
    Blue FOBs: 2
    Mission candidates: 69
    verfügbare Missionen: 10
    F10 Commands: 26
    CAP Requests: 12

---

## 5. Architekturregel

Externe Frameworks liegen unter:

    vendor/

Eigene Theater-Command-Logik liegt unter:

    src/

Der Debug-Bereich gehört zur eigenen Theater-Command-Logik.

Frameworks werden nicht verändert.

Dateien in `src/debug/` werden nach Debug-Aufgaben benannt, nicht nach Frameworks.

Nicht gewünscht:

    src/debug/tc_mist_debug.lua
    src/debug/tc_moose_debug.lua
    src/debug/tc_ctld_debug.lua
    src/debug/tc_skynet_debug.lua
    src/debug/tc_debug_all_in_one.lua
    src/debug/tc_everything_debug.lua

Mögliche spätere Dateien:

    src/debug/tc_debug_console.lua
    src/debug/tc_debug_state_dump.lua
    src/debug/tc_debug_airbase_report.lua
    src/debug/tc_debug_zone_report.lua
    src/debug/tc_debug_capture_report.lua
    src/debug/tc_debug_mission_report.lua
    src/debug/tc_debug_logistics_report.lua
    src/debug/tc_debug_ai_report.lua
    src/debug/tc_debug_iads_report.lua

Diese Dateien werden erst angelegt, wenn sie wirklich benötigt werden.

---

## 6. Verhältnis zu F10Menu

Aktuell übernimmt F10Menu einen Teil der Debug- und Sichtbarkeitsfunktion.

Aktive UI-Datei:

    src/ui/tc_f10_menu.lua

Getestete Version:

    v0.2.0

Aktuelle F10-Funktionen:

- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Mission Details anzeigen
- Missionen aktivieren
- Kampagnenstatus anzeigen
- Logistics Status anzeigen
- FOB Status anzeigen
- AI CAP Status anzeigen

Aktuelle F10-Werte:

    commands: 26

Bestätigt:

    F10-Menü ist sichtbar.
    F10-Menü ist navigierbar.
    Mission Details funktionieren.
    Mission Activation funktioniert.
    Mission Activation bleibt state-only.

Nächster UI-/Debug-Schritt:

    Capture-/Pressure-Status im F10-Menü sichtbar machen.

---

## 7. Warum noch kein eigenes Debug-Modul existiert

Ein eigenes Debug-Modul ist sinnvoll, aber noch nicht der unmittelbare nächste Schritt.

Gründe:

- F10Menu ist bereits aktiv und kann die nächste Sichtbarkeit direkt bereitstellen.
- CaptureSystem erzeugt neue Daten, die zuerst über F10 sichtbar werden sollen.
- Ein separates Debug-Menü würde aktuell zusätzliche Struktur erzeugen.
- Die nächsten Tests benötigen nur Capture-/Pressure-Zusammenfassungen.
- Produktive Debug-Funktionen sollen später klar vom Spieler-UI getrennt werden.

Aktuelle Entscheidung:

    Erst F10Menu v0.2.1 mit Capture-/Pressure-Sichtbarkeit.
    Danach bei Bedarf eigener Debug-Bereich.

---

## 8. Verhältnis zum Core

`src/debug/` nutzt später den Core.

Erlaubte Core-Abhängigkeiten:

- `TC.Config`
- `TC.Logger`
- `TC.State`
- `TC.Utils`
- `TC.Scheduler`

Der Debug-Bereich darf davon ausgehen, dass der Core geladen ist.

Aktuelle Core-Dateien:

    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
    src/core/tc_utils.lua
    src/core/tc_scheduler.lua

Debug soll Core-Daten anzeigen können, aber keine Core-Hauptlogik ersetzen.

---

## 9. Verhältnis zum World-Bereich

Debug soll später Daten aus `src/world/` anzeigen.

Aktive World-Dateien:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

Aktuelle World-Werte:

    Syria airbase-like objects: 225
    strategic: 19
    secondary: 13
    captureCandidates: 32
    missionCandidates: 32
    logisticsCandidates: 46
    relevante Kampagnenzonen: 46
    skipped airbase-like objects: 179

Mögliche spätere Debug-Ausgaben:

- Airbase Summary
- Airbase Classification Report
- Strategic Airbases
- Secondary Airbases
- Unknown Objects
- Zone Summary
- Capture Zones
- Mission Zones
- Logistics Zones
- Startbase Zones

Debug soll nicht selbst Airbases scannen.

Debug soll nicht selbst Kampagnenzonen erzeugen.

---

## 10. Verhältnis zum Campaign-Bereich

Debug soll später Daten aus `src/campaign/` anzeigen.

Aktive Campaign-Dateien:

    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua

Aktuelle Capture-Werte:

    eligibleBases: 32
    eligibleZones: 32
    nonCaptureBases: 193
    nonCaptureZones: 14
    pressureRecords: 32
    progressRecords: 32
    appliedMissionEffects: 0
    ready: 0
    contested: 0

Mögliche spätere Debug-Ausgaben:

- Capture Summary
- Capture-Eligibility Report
- Pressure Records
- Progress Records
- Ready Zones
- Contested Zones
- Mission Effects
- Ownership Changes
- Persistence Status

Aktuell nächster Schritt:

    Capture-/Pressure-Daten über F10 sichtbar machen.

---

## 11. Verhältnis zum Logistics-Bereich

Debug soll später Daten aus `src/logistics/` anzeigen.

Aktive Logistics-Dateien:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

Aktuelle Logistics-Werte:

    logistics hubs: 46
    blue hubs: 7
    red hubs: 24
    neutral hubs: 15
    active hubs: 31
    limited hubs: 15
    locked hubs: 0

Aktuelle FOB-Werte:

    FOB candidates: 6
    stored candidates: 6
    auto-planned FOBs: 2
    skipped candidates: 4
    Blue FOBs: 2
    FOB Ercan
    FOB Gecitkale
    Status: UNDER_CONSTRUCTION

Mögliche spätere Debug-Ausgaben:

- Logistics Hub Summary
- Blue Hubs
- Red Hubs
- Neutral Hubs
- FOB Candidates
- FOB Status
- FOB Build Progress
- Cargo Requests
- CTLD Hook Status

Debug soll keine CTLD-Logik direkt ausführen.

---

## 12. Verhältnis zum Missionsbereich

Debug soll später Daten aus `src/missions/` anzeigen.

Aktive Missions-Datei:

    src/missions/tc_mission_generator.lua

Getestete Version:

    v0.2.2

Aktuelle MissionGenerator-Werte:

    mission candidates: 69
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 30

Mögliche spätere Debug-Ausgaben:

- verfügbare Missionen
- aktive Missionen
- abgeschlossene Missionen
- fehlgeschlagene Missionen
- Missionstypen
- Missionsziele
- Missionsprioritäten
- Mission Effects
- Activation Metadata
- reserved MOOSE Hooks
- reserved CTLD Hooks
- reserved Skynet Hooks

Mögliche spätere Debug-Funktionen:

- Mission neu generieren
- Mission manuell aktivieren
- Mission als completed markieren
- Mission als failed markieren
- Mission Effects testweise anwenden

Diese Funktionen müssen klar als Debug markiert sein.

---

## 13. Verhältnis zum AI-Bereich

Debug soll später Daten aus `src/ai/` anzeigen.

Aktive AI-Datei:

    src/ai/tc_ai_cap_manager.lua

Getestete Version:

    v0.2.0

Aktuelle AI-Werte:

    cap zone candidates: 31
    auto-registered CAP zones: 12
    CAP requests: 12
    reactionState: AIR_REACTION_REQUESTED
    threatLevel: HIGH

Mögliche spätere Debug-Ausgaben:

- CAP Zones
- CAP Requests
- CAP State
- Threat Level
- Reaction State
- AI Director Status
- Blue Intent
- Red Intent
- AI Priority Zones
- AI Operation Queue

Debug soll keine dauerhafte AI-Logik enthalten.

---

## 14. Verhältnis zum IADS-Bereich

Debug soll später Daten aus `src/iads/` anzeigen.

Aktueller IADS-Stand:

    Skynet IADS wird geladen.
    Loader erkennt Skynet IADS.
    MissionGenerator reserviert Skynet-Hooks.
    eigenes Theater-Command-IADS-Modul ist noch nicht implementiert.

Mögliche spätere Debug-Ausgaben:

- IADS Status
- IADS Networks
- IADS Sectors
- SAM Sites
- EWR Sites
- Command Centers
- Suppressed Sites
- Damaged Sites
- Destroyed Sites
- SEAD Targets
- DEAD Targets
- Skynet Hook Status

Debug soll keine Skynet-IADS-Dateien verändern.

Debug soll IADS-Zustand anzeigen und später gezielte Testfunktionen bereitstellen.

---

## 15. Verhältnis zu Persistence

Debug soll später Persistence-Status anzeigen.

Aktive Persistence-Datei:

    src/campaign/tc_persistence_system.lua

Status:

    Grundstruktur lädt/startet
    produktiver Dateischreibtest offen

Mögliche spätere Debug-Ausgaben:

- Persistence Status
- Save Path
- Last Save
- Last Load
- Save Version
- Schema Version
- Dirty State
- Save Test Result
- Load Test Result
- Sandbox Write Test

Mögliche spätere Debug-Funktionen:

- Debug Save Test
- Debug Load Test
- Debug Show Save Status
- Debug Print Persistence State

Aktuell:

    Persistenz ist noch nicht produktiv.
    Kein Save-/Load-Debug aktiv.

---

## 16. Geplanter Namespace

Der Debug-Bereich soll später unter der zentralen Projekttabelle liegen.

Geplante Struktur:

    TC.Debug
    ├── Console
    ├── StateDump
    ├── AirbaseReport
    ├── ZoneReport
    ├── CaptureReport
    ├── MissionReport
    ├── LogisticsReport
    ├── AIReport
    ├── IADSReport
    └── PersistenceReport

State-Bereich:

    TC.State.Debug

Nicht verwenden:

    TheaterCommandDebug
    DebugTC
    tc_debug_global
    _G_TC_DEBUG

---

## 17. Geplanter Debug-State

Mögliche spätere Daten in `TC.State.Debug`:

- enabled
- verbose
- showZones
- showAirbases
- showCapture
- showLogistics
- showMissions
- showAI
- showIADS
- showPersistence
- lastReportTime
- lastCommand
- lastResult
- lastError
- reportCounter

Aktuell:

    Debug-State ist noch nicht produktiv implementiert.

---

## 18. State-first-Regel

Auch Debug folgt der state-first-Architektur.

Das bedeutet:

- Debug liest Theater-Command-State.
- Debug zeigt Theater-Command-State.
- Debug löst keine echten Framework-Aktionen aus, außer es ist später ausdrücklich als Debug-Testfunktion markiert.
- Debug verändert keine Vendor-Dateien.
- Debug ersetzt keine Kampagnenlogik.
- Debug bleibt abschaltbar.

Nicht aktiv:

- produktives Debug-Menü
- Debug-State-Dump
- Debug-Save-Test
- Debug-Capture-Test
- Debug-Mission-Completion
- Debug-IADS-Test

---

## 19. Sicherheitsregel

Debug-Funktionen können später starken Einfluss auf die Kampagne haben.

Deshalb gilt:

- Debug-Funktionen müssen klar gekennzeichnet sein.
- Debug-Funktionen müssen abschaltbar sein.
- Debug-Funktionen dürfen normale Kampagnenlogik nicht ersetzen.
- Debug-Funktionen dürfen keine Vendor-Dateien verändern.
- Debug-Funktionen dürfen keine All-in-one-Logik enthalten.
- Debug-Funktionen dürfen keine echten Spawns auslösen, wenn sie nicht ausdrücklich dafür gebaut und getestet wurden.
- Debug-Funktionen müssen klare Logmarker erzeugen.

Später kann über `TC.Config` gesteuert werden, ob Debug aktiv ist.

---

## 20. Mögliche spätere Debug-Menüs

Später kann Debug über F10 sichtbar werden.

Mögliche Menüstruktur:

    F10
    └── Theater Command Debug
        ├── State
        │   ├── Show State Summary
        │   └── Dump State
        ├── World
        │   ├── Show Airbase Report
        │   └── Show Zone Report
        ├── Campaign
        │   ├── Show Capture Report
        │   └── Show Pressure Report
        ├── Missions
        │   ├── Show Mission Report
        │   ├── Complete Active Mission
        │   └── Fail Active Mission
        ├── Logistics
        │   └── Show Logistics Report
        ├── AI
        │   └── Show AI Report
        ├── IADS
        │   └── Show IADS Report
        └── Persistence
            └── Test Save File

Diese Struktur ist noch nicht final.

Normale Spieler-UI und Debug-UI sollen getrennt bleiben.

---

## 21. Testziele für spätere erste Debug-Datei

Eine spätere erste Debug-Datei gilt als bestanden, wenn:

- Datei lädt.
- Version wird im Log angezeigt.
- `TC.Debug` wird initialisiert.
- `TC.State.Debug` wird initialisiert.
- mindestens ein State-Report kann erzeugt werden.
- keine echten Framework-Aktionen ausgelöst werden.
- keine Vendor-Dateien verändert werden.
- keine Theater-Command-Lua-Fehler auftreten.
- keine Lua-Stacktraces auftreten.
- Main und Loader bleiben sauber.

Mögliche erste Datei:

    src/debug/tc_debug_state_dump.lua

Oder:

    src/debug/tc_debug_console.lua

Diese Entscheidung ist noch offen.

---

## 22. Erwartete spätere Logmarker

Mögliche spätere Logmarker:

    [TC] [Debug] Loaded src/debug/tc_debug_state_dump.lua v0.1.0
    [TC] [Debug] Debug state initialized
    [TC] [Debug] State summary requested
    [TC] [Debug] Airbase report generated
    [TC] [Debug] Zone report generated
    [TC] [Debug] Capture report generated
    [TC] System started: Debug

Diese Marker sind noch nicht aktiv.

Sie beschreiben nur den erwarteten Umfang einer späteren Debug-Datei.

---

## 23. Abgrenzung

Nicht Aufgabe von `src/debug/`:

- Airbases aus DCS auslesen
- Zonen geometrisch erzeugen
- Basenbesitz regulär festlegen
- Zonenbesitz regulär festlegen
- Capture-Pressure regulär berechnen
- Logistics Hubs regulär erzeugen
- CTLD-Lieferungen regulär auswerten
- FOBs regulär bauen
- Missionen regulär generieren
- Missionen regulär aktivieren
- CAPs dauerhaft verwalten
- IADS-Netzwerke regulär aufbauen
- Save-Dateien produktiv schreiben
- normale Spieler-UI ersetzen
- Framework-Dateien verändern

Diese Aufgaben gehören in andere Bereiche.

Debug prüft, zeigt an und testet gezielt.

---

## 24. Nächster sinnvoller Schritt

Der nächste sinnvolle Schritt liegt nicht direkt im Debug-Bereich.

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

---

## 25. Zielbild

`src/debug/` wird später die Test- und Diagnoseschicht von Theater Command DCS.

Der Debug-Bereich verbindet später:

- Core
- World
- Campaign
- Logistics
- Missions
- AI
- IADS
- UI
- Persistence

Aktueller Status:

    Noch kein eigenes Debug-Lua-Modul aktiv.
    F10Menu übernimmt aktuell die wichtigste Sichtbarkeit.
    DCS-Logauswertung bleibt die wichtigste technische Prüfstelle.
    Debug-Ordner ist vorbereitet.

Nächster notwendiger Zwischenschritt im Gesamtprojekt:

    F10Menu v0.2.1 mit Capture-/Pressure-Sichtbarkeit.
