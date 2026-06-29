# Technical Architecture

Diese Datei beschreibt die technische Architektur von **Theater Command DCS**.

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## 1. Grundprinzip

Das zentrale Architekturprinzip lautet:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der DCS Mission Editor stellt die physische Umgebung bereit.

Lua übernimmt die dynamische Kampagnenlogik.

GitHub dokumentiert Struktur, Entscheidungen, Versionen, Aufgabenstand und Testergebnisse.

---

## 2. Architekturziel

Theater Command DCS soll langfristig eine dynamische und später persistente DCS-Kampagne ermöglichen.

Ziel ist keine einzelne statische Mission, sondern eine modulare Kampagnenruntime.

Langfristig sollen folgende Systeme zusammenarbeiten:

- World Layer
- Campaign Layer
- Capture System
- Logistics System
- FOB System
- Mission Generator
- AI CAP Manager
- AI Director
- IADS System
- F10 UI
- Debug System
- Persistence System

Spieler sollen sich über Client-Slots und F10-Menüs in die laufende Kampagne einklinken.

Die Kampagne soll perspektivisch auch ohne ständige Spielerentscheidung weiterlaufen.

Blue und Red sollen später eigene Operationen planen und durchführen.

---

## 3. Aktueller technischer Stand

Stand:

    2026-06-29

Aktueller Status:

    State-first Runtime-Grundlage stabil getestet.

Aktuell vorhanden:

- Repository-Grundstruktur
- zentrale Projektdokumentation
- `docs/`-Dokumentation
- `mission_editor/`-Dokumentation
- `vendor/`-Frameworkstruktur
- MIST
- MOOSE
- CTLD
- Skynet IADS
- `src/`-Grundstruktur
- Loader
- Main-Initialisierung
- Core-System
- World-System
- Campaign-System
- CaptureSystem
- PersistenceSystem-Grundstruktur
- LogisticsDelivery
- FobSystem
- MissionGenerator
- AICapManager
- F10Menu
- IADS- und Debug-Bereiche vorbereitet
- minimale Syria-DEV-Mission
- erster blauer F/A-18C-Client-Slot auf Akrotiri
- sichere Einzeldatei-Ladung im Mission Editor
- reale DCS-Starttests
- erfolgreiche `dcs.log`-Auswertungen

Aktuell bestätigt:

- Vendor-Frameworks werden durch DCS geladen.
- Frameworks werden durch Theater Command erkannt.
- eigene Source-Dateien werden geladen.
- Loader startet.
- Main startet.
- Runtime-Systeme werden initialisiert.
- Airbase Scanner läuft.
- ZoneFactory läuft.
- CaptureSystem läuft.
- PersistenceSystem lädt/startet als Grundstruktur.
- LogisticsDelivery läuft.
- FobSystem läuft.
- MissionGenerator läuft.
- AICapManager läuft.
- F10Menu läuft.
- Loader beendet sauber.

Wichtiger technischer Befund:

    DCS Syria liefert 225 airbase-like objects.
    Airbase Scanner klassifiziert diese Objekte.
    ZoneFactory erzeugt daraus 46 relevante Kampagnenzonen.
    CaptureSystem arbeitet auf 32 capture-fähigen Zielen.
    CaptureSystem erzeugt 32 Pressure-Records und 32 Progress-Records.
    LogisticsDelivery erzeugt 46 Logistics Hubs.
    FobSystem erzeugt 6 FOB-Kandidaten und 2 Blue-FOBs.
    MissionGenerator erzeugt 10 verfügbare Missionen aus 69 Kandidaten.
    F10Menu erzeugt 26 Commands und erlaubt direkte Missionsaktivierung.

Bewertung:

    Die technische Startkette funktioniert.
    Die state-first Runtime-Grundlage ist stabil.
    Das Projekt ist noch keine fertige spielbare dynamische Kampagne.
    Echte MOOSE-, CTLD- und Skynet-Ausführung sind bewusst noch nicht aktiv.

---

## 4. Hauptstruktur

Aktuelle Hauptstruktur:

    docs/
    mission_editor/
    src/
    vendor/
    README.md
    ROADMAP.md
    TASKS.md
    CHANGELOG.md
    ARCHITECTURE.md
    MISSION_EDITOR_SETUP.md
    NAMING_CONVENTIONS.md
    LUA_STYLEGUIDE.md

---

## 5. Source-Struktur

Eigene Theater-Command-Logik liegt unter:

    src/

Aktuelle Struktur:

    src/
    ├── README.md
    ├── loader.lua
    ├── main.lua
    ├── core/
    ├── world/
    ├── campaign/
    ├── logistics/
    ├── missions/
    ├── ai/
    ├── iads/
    ├── ui/
    └── debug/

Die Struktur ist nach Aufgaben sortiert, nicht nach Frameworks.

Nicht gewünscht sind Dateien wie:

    tc_moose.lua
    tc_mist.lua
    tc_ctld.lua
    tc_all_in_one.lua

---

## 6. Aktive Source-Dateien

Aktuell aktive eigene Lua-Dateien:

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

Aktuell vorbereitet, aber noch nicht produktiv implementiert:

    src/iads/
    src/debug/

Wichtige Korrektur gegenüber älteren Dokumenten:

    src/ui/ ist nicht mehr nur dokumentiert.
    src/ui/tc_f10_menu.lua ist aktiv und getestet.

---

## 7. Vendor-Struktur

Externe Frameworks liegen unter:

    vendor/

Aktuelle Framework-Basis:

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD-i18n | `vendor/ctld/CTLD-i18n.lua` | geladen |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Regeln:

- Frameworks werden nicht verändert.
- Eigene Logik wird nicht in Framework-Dateien geschrieben.
- Frameworks werden nur geladen und später über eigene Module gekapselt genutzt.
- Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket.

Aktueller Stand:

- MIST wird geladen.
- MOOSE wird geladen.
- CTLD wird geladen.
- Skynet IADS wird geladen.
- Produktive Framework-Ausführung ist noch nicht aktiv.

---

## 8. DCS-Lade-Reihenfolge

Die externe Framework-Lade-Reihenfolge lautet:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua

Danach wird die eigene Theater-Command-Logik geladen.

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

## 9. Starttest-Variante A

Aktuell verwendete Methode:

    Starttest-Variante A — sichere Einzeldatei-Ladung

Dabei werden alle aktiven Dateien einzeln per `DO SCRIPT FILE` geladen.

Reihenfolge:

    Frameworks
    Core
    World
    Campaign
    Logistics
    Missions
    AI
    UI
    Main
    Loader

Ergebnis:

    Bestanden.

Wichtig:

    Eine per DO SCRIPT FILE geladene Lua-Datei wird in die .miz eingebettet.
    Nach jeder Lua-Änderung muss die jeweilige Datei im Mission Editor erneut ausgewählt und die Mission gespeichert werden.

---

## 10. Geprüfte Logik im aktuellen DCS-Teststand

Bestätigt wurde:

    MIST erkannt
    MOOSE erkannt
    CTLD erkannt
    Skynet IADS erkannt
    Core geladen
    World geladen
    Campaign geladen
    Logistics geladen
    Missions geladen
    AI geladen
    UI geladen
    F10Menu geladen
    Main gestartet
    Runtime-Systeme initialisiert
    Loader beendet

Wichtige positive Log-Einträge:

    [TC] Theater Command loader started
    [TC] Framework available: MIST
    [TC] Framework available: MOOSE
    [TC] Framework available: CTLD
    [TC] Framework available: Skynet IADS
    [TC] Main start requested
    [TC] Core check passed
    [TC] Runtime systems initialized
    [TC] Main initialized
    [TC] Main started
    [TC] Theater Command loader finished

Aktuelle Runtime-Ergebnisse:

    [TC] [AirbaseScanner] Loaded src/world/tc_airbase_scanner.lua v0.2.2
    [TC] [ZoneFactory] Loaded src/world/tc_zone_factory.lua v0.2.0
    [TC] [CaptureSystem] Loaded src/campaign/tc_capture_system.lua v0.2.1
    [TC] [LogisticsDelivery] Loaded src/logistics/tc_logistics_delivery.lua v0.2.0
    [TC] [FobSystem] Loaded src/logistics/tc_fob_system.lua v0.2.0
    [TC] [MissionGenerator] Loaded src/missions/tc_mission_generator.lua v0.2.2
    [TC] [AICapManager] Loaded src/ai/tc_ai_cap_manager.lua v0.2.0
    [TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.0
    [TC] [F10Menu] F10 menu initialized: commands=26

Bewertung:

    Die Startarchitektur funktioniert.
    Die technische Grundlage ist stabil genug für weitere State-, UI- und Debug-Schritte.

---

## 11. Aktueller getesteter Systemstand

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

## 12. Core-Schicht

Pfad:

    src/core/

Aktuelle Dateien:

    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
    src/core/tc_utils.lua
    src/core/tc_scheduler.lua

Aufgaben:

- zentrale Konfiguration
- Logging
- globaler Theater-Command-State
- Hilfsfunktionen
- Scheduler-Grundfunktionen
- technische Start- und Laufzeitunterstützung
- Modulstatus
- Featurestatus
- Konstanten

Regel:

    Core darf von allen Systemen genutzt werden.
    Core soll keine fachliche Kampagnenentscheidung erzwingen.

---

## 13. State-Modell

Zentraler Zustand:

    TC.State
    TC.state

Aktuelle State-Bereiche:

    State.Core
    State.Modules
    State.Features
    State.Bases
    State.Zones
    State.Campaign
    State.Logistics
    State.Missions
    State.AI
    State.UI
    State.Persistence

Grundregeln:

- Module schreiben ihren fachlichen Zustand in den State.
- Andere Module lesen diesen Zustand über definierte Tabellen oder Funktionen.
- Framework-Ausführung wird später aus dem State abgeleitet.
- Der State soll persistierbar bleiben.
- State-first kommt vor echten Spawns.

Aktuell im State vorhanden oder vorbereitet:

- klassifizierte Airbases
- Kampagnenzonen
- Capture-Eligibility
- Capture-Pressure
- Capture-Progress
- Logistics Hubs
- FOB-Kandidaten
- geplante FOBs
- verfügbare Missionen
- aktive Missionen
- Mission Objectives
- Mission Briefings
- Mission Progress
- Mission Activation Metadata
- AI-CAP-State
- F10-UI-State

---

## 14. World-Schicht

Pfad:

    src/world/

Aktuelle Dateien:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

Aufgaben:

- DCS-Airbases erfassen
- Airbase-like Objects klassifizieren
- Koalitionsstatus erkennen
- Positionen erfassen
- relevante virtuelle Kampagnenzonen erzeugen
- Daten für Campaign, Logistics, Missions und AI bereitstellen

Regel:

    World erkennt und klassifiziert.
    World entscheidet nicht allein über Capture oder Kampagnenfortschritt.

---

## 15. Airbase Scanner

Datei:

    src/world/tc_airbase_scanner.lua

Getestete Version:

    v0.2.2

Status:

    bestanden

Bestätigte Werte:

    total: 225
    strategic: 19
    secondary: 13
    heliports: 1
    helipads: 95
    medical: 40
    farps: 0
    tactical: 13
    unknown: 44
    captureCandidates: 32
    missionCandidates: 32
    logisticsCandidates: 46
    blueStartBases: 1
    redStrategicCandidates: 18

Architekturrolle:

- Grundlage für ZoneFactory
- Grundlage für CaptureSystem
- Grundlage für LogisticsDelivery
- Grundlage für MissionGenerator
- Grundlage für AICapManager
- spätere Grundlage für IADS und AI Director

---

## 16. ZoneFactory

Datei:

    src/world/tc_zone_factory.lua

Getestete Version:

    v0.2.0

Status:

    bestanden

Bestätigte Werte:

    total zones: 46
    classified airbase zones: 46
    Mission Editor zones: 0
    skipped airbase-like objects: 179
    strategic zones: 19
    secondary zones: 13
    heliport zones: 1
    farp zones: 0
    tactical zones: 13
    captureZones: 32
    missionZones: 32
    logisticsZones: 46
    startBaseZones: 1

Architekturrolle:

- übersetzt Airbase-Klassifizierung in Kampagnenzonen
- erzeugt die zentrale Raumstruktur der Kampagne
- trennt strategisch relevante und nicht relevante Objekte
- verhindert, dass alle 225 Airbase-like Objects ungefiltert als Kampagnenzonen wirken

---

## 17. Campaign-Schicht

Pfad:

    src/campaign/

Aktuelle Dateien:

    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua

Aufgaben:

- Besitzstatus verwalten
- Zonenstatus verwalten
- Capture-Zustände verwalten
- Capture-Events speichern
- Capture-Pressure verwalten
- Capture-Progress verwalten
- Kampagnenzustand vorbereiten
- spätere Save-/Load-Logik unterstützen

Regel:

    Campaign entscheidet über strategischen Besitz.
    Campaign spawnt keine DCS-Objekte direkt.

---

## 18. CaptureSystem

Datei:

    src/campaign/tc_capture_system.lua

Getestete Version:

    v0.2.1

Status:

    bestanden

Bestätigte Werte:

    eligibleBases: 32
    eligibleZones: 32
    nonCaptureBases: 193
    nonCaptureZones: 14
    pressureRecords: 32
    progressRecords: 32
    appliedMissionEffects: 0
    ready: 0
    contested: 0

Aufgaben:

- Ownership von Basen und Zonen verwalten
- Capture-Eligibility bestimmen
- ungeeignete Objekte ausschließen
- Linked Airbase/Zone Ownership synchronisieren
- Capture Events speichern
- Capture Pressure erzeugen
- Capture Progress erzeugen
- Missionseffekte state-only als Capture-Druck vorbereiten
- Capture Ready und Pressure Contested vorbereiten

Aktuelle Architektur:

    Capture ist noch nicht automatisch produktiv.
    Capture Pressure wird vorbereitet.
    Capture Progress wird vorbereitet.
    Missionseffekte können vorbereitet angewendet werden.
    Ownership-Wechsel bleiben kontrolliert.

---

## 19. PersistenceSystem

Datei:

    src/campaign/tc_persistence_system.lua

Status:

    Grundstruktur vorhanden
    lädt/startet
    produktiver Dateitest noch offen

Aufgaben:

- Kampagnenzustand speichern
- Kampagnenzustand laden
- DCS-Sandbox-Dateizugriff prüfen
- Save-Datei definieren
- Load-Reihenfolge definieren

Aktuelle Architekturentscheidung:

    Keine produktive Persistenz ohne vorherigen DCS-Sandbox-Test.

---

## 20. Logistics-Schicht

Pfad:

    src/logistics/

Aktuelle Dateien:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

Aufgaben:

- Logistics Hubs aus Kampagnenzonen erzeugen
- Supply-/Fuel-/Ammo-/Engineering-Zustände vorbereiten
- Deliveries vorbereiten
- FOB-Kandidaten erzeugen
- FOBs state-only planen
- spätere CTLD-Anbindung vorbereiten

Regel:

    Logistics entscheidet nicht allein über Besitz.
    Logistics beeinflusst Campaign, Missions und AI über Zustandsdaten.

---

## 21. LogisticsDelivery

Datei:

    src/logistics/tc_logistics_delivery.lua

Getestete Version:

    v0.2.0

Status:

    bestanden

Bestätigte Werte:

    logistics hubs: 46
    blue hubs: 7
    red hubs: 24
    neutral hubs: 15
    active hubs: 31
    limited hubs: 15
    locked hubs: 0

Aktuelle Architektur:

    Logistics Hubs sind State-only.
    CTLD wird noch nicht aktiv aufgerufen.
    Keine echten Cargo-Flüge.
    Keine echten Dropoffs.
    Keine echten Supply-Verbräuche.

---

## 22. FobSystem

Datei:

    src/logistics/tc_fob_system.lua

Getestete Version:

    v0.2.0

Status:

    bestanden

Bestätigte Werte:

    FOB candidates: 6
    stored candidates: 6
    auto-planned FOBs: 2
    skipped candidates: 4
    Blue FOBs: 2

Erzeugte FOBs:

    FOB Ercan
    FOB Gecitkale

Status:

    UNDER_CONSTRUCTION

Aktuelle Architektur:

    FOBs sind State-only.
    Es werden noch keine CTLD-FOBs erzeugt.
    Baufortschritt wird noch nicht durch echte Cargo-Lieferungen beeinflusst.
    FOBs können bereits vom MissionGenerator für FOB-Support genutzt werden.

---

## 23. Missions-Schicht

Pfad:

    src/missions/

Aktuelle Datei:

    src/missions/tc_mission_generator.lua

Regel:

    Missions erzeugt Aufträge aus State-Daten.
    Missions verändert strategischen Besitz nicht direkt.
    Missionsergebnisse werden später an Campaign, Logistics, AI und IADS gemeldet.

---

## 24. MissionGenerator

Datei:

    src/missions/tc_mission_generator.lua

Getestete Version:

    v0.2.2

Status:

    bestanden

Bestätigte Werte:

    mission candidates: 69
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 30

Aktuelle Missionstypen:

- `RECON`
- `STRIKE`
- `SEAD`
- `DEAD`
- `CAS`
- `INTERDICTION`
- `ESCORT`
- `CAP`
- `LOGISTICS`
- `FOB_SUPPORT`
- `AIRBASE_ATTACK`
- `IADS_SUPPRESSION`

Aktuelle Mission Records enthalten:

- ID
- Key
- Name
- Type
- Status
- Owner
- Source Base
- Target Zone
- Target Base
- Target FOB
- Priority
- Strategic Relevance
- Objective
- Briefing
- Recommended Aircraft
- Recommended Payload
- Progress
- Activation Metadata
- Execution Plan
- Effects
- reserved MOOSE hook
- reserved CTLD hook
- reserved Skynet hook

Aktuelle Architektur:

    Missionen sind State-only.
    Aktivierung setzt Missionen auf ACTIVE.
    Aktivierung triggert keine echten Spawns.
    Spawn-Hooks bleiben reserviert.
    Missionserfolg und Fehlschlag sind vorbereitet, aber noch nicht automatisch angebunden.

---

## 25. AI-Schicht

Pfad:

    src/ai/

Aktuelle Datei:

    src/ai/tc_ai_cap_manager.lua

Geplante spätere Dateien:

    src/ai/tc_ai_director.lua
    src/ai/tc_ai_gci_manager.lua
    src/ai/tc_ai_counterattack.lua

Regel:

    AI reagiert auf den Kampagnenzustand.
    AI darf später MOOSE für reale Spawns nutzen.
    AI trifft keine strategischen Besitzentscheidungen allein.

---

## 26. AICapManager

Datei:

    src/ai/tc_ai_cap_manager.lua

Getestete Version:

    v0.2.0

Status:

    bestanden

Bestätigte Werte:

    cap zone candidates: 31
    auto-registered CAP zones: 12
    CAP requests: 12
    reactionState: AIR_REACTION_REQUESTED
    threatLevel: HIGH

Aktuelle Architektur:

    CAP ist State-only.
    MOOSE wird noch nicht produktiv genutzt.
    spawn=MOOSE_PENDING ist erwartetes Verhalten.

---

## 27. IADS-Schicht

Pfad:

    src/iads/

Aktueller Stand:

    Vendor geladen.
    Eigenes Theater-Command-IADS-Modul noch nicht aktiv implementiert.

Geplante Module:

    src/iads/tc_iads_system.lua
    src/iads/tc_iads_network.lua
    src/iads/tc_iads_sector_manager.lua
    src/iads/tc_iads_site_registry.lua
    src/iads/tc_iads_mission_bridge.lua

Aufgaben:

- Skynet-IADS-Anbindung kapseln
- IADS-Netzwerke vorbereiten
- IADS-Sektoren definieren
- SAM-Standorte verwalten
- Radar-Standorte verwalten
- IADS-Zustand im Kampagnen-State speichern
- IADS-Zustand mit MissionGenerator verbinden
- SEAD- und DEAD-Ziele vorbereiten

Regel:

    Skynet IADS bleibt Framework.
    Theater Command bewertet und speichert den Kampagnenzustand darüber.

Aktueller Stand:

    MissionGenerator reserviert bereits Skynet-Hooks.
    Keine echte IADS-Kampagnenlogik aktiv.

---

## 28. UI-Schicht

Pfad:

    src/ui/

Aktive Datei:

    src/ui/tc_f10_menu.lua

Getestete Version:

    v0.2.0

Status:

    bestanden

Aufgaben:

- F10-Menüs bereitstellen
- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Mission 1 bis Mission 10 Details anzeigen
- Mission 1 bis Mission 10 aktivieren
- Kampagnenstatus anzeigen
- Logistikstatus anzeigen
- FOB-Status anzeigen
- AI-CAP-Status anzeigen

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

Regel:

    UI zeigt Daten und nimmt Spielerkommandos entgegen.
    UI entscheidet nicht selbst über Kampagnenlogik.
    UI triggert aktuell keine echten Spawns.

Nächster UI-Schritt:

    Capture-/Pressure-Status anzeigen.
    Capture Ready Zones anzeigen.
    Pressure Contested Zones anzeigen.

---

## 29. Debug-Schicht

Pfad:

    src/debug/

Aktueller Stand:

    Dokumentiert, noch nicht aktiv implementiert.

Geplante Module:

    src/debug/tc_debug_console.lua
    src/debug/tc_debug_state_dump.lua
    src/debug/tc_debug_zone_overlay.lua
    src/debug/tc_debug_airbase_report.lua
    src/debug/tc_debug_mission_report.lua
    src/debug/tc_debug_logistics_report.lua
    src/debug/tc_debug_ai_report.lua
    src/debug/tc_debug_iads_report.lua

Aufgaben:

- Debug-Ausgaben bündeln
- State-Dumps erzeugen
- Airbase-Reports erzeugen
- Zonen-Reports erzeugen
- Capture-Reports erzeugen
- Logistik-Reports erzeugen
- Missions-Reports erzeugen
- AI-Reports erzeugen
- IADS-Reports erzeugen

Regel:

    Debug macht Daten sichtbar.
    Debug ersetzt keine produktive Kampagnenlogik.

---

## 30. Persistenz-Architektur

Aktuelle Datei:

    src/campaign/tc_persistence_system.lua

Aktueller Stand:

    Grundstruktur vorhanden.
    Produktiver Dateischreibtest offen.

Spätere Aufgaben:

- State-Snapshot erzeugen
- State exportieren
- State importieren
- Airbase-Besitz speichern
- Zonenstatus speichern
- Capture-Pressure speichern
- Capture-Progress speichern
- Capture-Events speichern
- Logistikstatus speichern
- FOB-Status speichern
- Missionsfortschritt speichern
- AI-Zustand speichern
- IADS-Zustand speichern
- Dateien schreiben
- Dateien lesen

Wichtig:

    DCS-Dateizugriff und DCS-Sandbox-Verhalten müssen vor echter Dateipersistenz praktisch getestet werden.

---

## 31. Mission-Editor-Architektur

Aktuelle DEV-Mission:

    Operation_Levant_Reclamation_DEV.miz

Aktueller Inhalt:

    Map: Syria
    Koalitionspreset: Modern
    Blue Start: Akrotiri / Zypern
    erster blauer Client-Slot: F/A-18C Lot 20 auf Akrotiri
    Trigger: Starttest-Variante A vollständig angelegt
    Vendor-Frameworks geladen
    Theater-Command-Source-Dateien geladen
    F10-Menü aktiv
    keine produktive rote Frontlinie
    keine produktiven IADS-Stellungen
    keine produktiven CTLD-Zonen
    keine produktiven Template-Gruppen
    keine echten MOOSE-Spawns
    keine echten CTLD-FOBs
    keine produktive Persistenz

Regel:

    Der Mission Editor bleibt schlank.
    Große dynamische Logik gehört nach Lua.
    Der Mission Editor liefert Bühne, Slots, Templates, Zonen und statische Objekte.

---

## 32. Loader-only-Architektur

Noch nicht getestet:

    Starttest-Variante B — Loader-only mit dofile

Ziel:

- Frameworks im Mission Editor laden
- nur `src/loader.lua` laden
- prüfen, ob `src/loader.lua` weitere Source-Dateien per `dofile` nachladen kann
- DCS-Sandbox-Verhalten bewerten
- spätere Deployment-Strategie entscheiden

Mögliche Ergebnisse:

- Loader-only funktioniert
- Einzeldatei-Ladung bleibt für Entwicklung notwendig
- spätere Build-Datei wird benötigt
- DCS-Sandbox muss gezielt berücksichtigt werden

Diese Entscheidung wird erst nach einem praktischen Test getroffen.

---

## 33. Abhängigkeitsregeln

Grundregel:

    Niedrige Schichten dürfen nicht von höheren Schichten abhängen.

Vereinfachte Richtung:

    Core -> World -> Campaign -> Logistics -> Missions -> AI -> IADS -> UI -> Debug

Praktische Regeln:

- Core darf von allen genutzt werden.
- World liefert DCS-Weltdaten.
- Campaign verwaltet strategischen Zustand.
- Logistics liefert Versorgungszustände.
- Missions erzeugt Aufträge aus State-Daten.
- AI reagiert auf State-Daten.
- IADS liefert Luftverteidigungszustände.
- UI zeigt Daten und nimmt Spielerbefehle an.
- Debug liest Daten und erzeugt Prüfberichte.

Keine Datei soll heimlich große Nebenlogik aus fremden Bereichen übernehmen.

---

## 34. Aktuelle wichtigste Architekturentscheidung

Die heutige Architekturentscheidung lautet:

    State-first bleibt vor echter Framework-Ausführung.

Begründung:

- DCS ist schwer zu debuggen.
- MOOSE-, CTLD- und Skynet-Ausführung erzeugen komplexe Nebenwirkungen.
- Vor echten Spawns muss der State sichtbar und testbar sein.
- Capture-Pressure und Mission Effects müssen zuerst über UI/Debug geprüft werden.
- Persistence darf erst nach DCS-Sandbox-Test produktiv werden.

Aktuell gilt:

- keine echten MOOSE-Spawns
- keine echten CTLD-Aktionen
- keine echten Skynet-Aktionen
- keine produktive Persistenz
- keine automatischen Kampagnenfolgen ohne Test

---

## 35. Nächster technischer Schritt

Der nächste technische Schritt ist:

    src/ui/tc_f10_menu.lua erweitern

Ziel:

- Capture-/Pressure-Status im F10-Menü sichtbar machen
- Capture Ready Zones anzeigen
- Pressure Contested Zones anzeigen
- Capture-Pressure und Capture-Progress lesbar machen

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
- keine echten Spawns
- keine CTLD-Aktion
- keine Skynet-Aktion
- keine Lua-Fehler
- keine Theater-Command-Fehler

---

## 36. Aktueller Status

Die technische Grundarchitektur ist angelegt und state-first stabil getestet.

Aktuell bestanden:

| System | Version | Status |
|---|---:|---|
| Airbase Scanner | `v0.2.2` | bestanden |
| ZoneFactory | `v0.2.0` | bestanden |
| CaptureSystem | `v0.2.1` | bestanden |
| LogisticsDelivery | `v0.2.0` | bestanden |
| FobSystem | `v0.2.0` | bestanden |
| MissionGenerator | `v0.2.2` | bestanden |
| AICapManager | `v0.2.0` | bestanden |
| F10Menu | `v0.2.0` | bestanden |

Aktuelle Fähigkeit:

- Theater Command startet in DCS.
- Airbases werden klassifiziert.
- relevante Kampagnenzonen werden erzeugt.
- Capture-Ziele werden erkannt.
- Capture-Pressure und Capture-Progress werden vorbereitet.
- Logistics Hubs werden erzeugt.
- FOB-Kandidaten und erste Blue-FOBs werden erzeugt.
- Missionen inklusive FOB-Support werden erzeugt.
- Missionen können über F10 direkt ausgewählt und aktiviert werden.
- AI-CAP-State wird vorbereitet.
- Main und Loader starten sauber.

Nächster notwendiger Schritt:

    Capture-/Pressure-Sichtbarkeit im F10-Menü.
