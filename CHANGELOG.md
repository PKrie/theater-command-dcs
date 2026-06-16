# Changelog

Alle relevanten Änderungen am Projekt **Theater Command DCS** werden in dieser Datei dokumentiert.

Das Projekt befindet sich aktuell in der frühen Aufbauphase.

Aktueller Fokus:

    Source-Grundstruktur, erste Lua-Module, Loader-Kette, Main-Initialisierung, Mission-Editor-Ladestrategie und Vorbereitung des ersten DCS-Starttests

---

## Unreleased

### Added

- `src/core/README.md` erstellt
- `src/world/README.md` erstellt
- `src/campaign/README.md` erstellt
- `src/logistics/README.md` erstellt
- `src/missions/README.md` erstellt
- `src/ai/README.md` erstellt
- `src/iads/README.md` erstellt
- `src/ui/README.md` erstellt
- `src/debug/README.md` erstellt
- `src/loader.lua` erstellt
- `src/main.lua` erstellt
- Core-Konfigurationsmodul erstellt:
  - `src/core/tc_config.lua`
- Core-Loggingmodul erstellt:
  - `src/core/tc_logger.lua`
- Core-State-Modul erstellt:
  - `src/core/tc_state.lua`
- Core-Utility-Modul erstellt:
  - `src/core/tc_utils.lua`
- Core-Scheduler-Modul erstellt:
  - `src/core/tc_scheduler.lua`
- World-Airbase-Scanner erstellt:
  - `src/world/tc_airbase_scanner.lua`
- World-Zone-Factory erstellt:
  - `src/world/tc_zone_factory.lua`
- Campaign-Capture-System erstellt:
  - `src/campaign/tc_capture_system.lua`
- Campaign-Persistence-System erstellt:
  - `src/campaign/tc_persistence_system.lua`
- Logistics-Delivery-System erstellt:
  - `src/logistics/tc_logistics_delivery.lua`
- Logistics-FOB-System erstellt:
  - `src/logistics/tc_fob_system.lua`
- Missionsgenerator erstellt:
  - `src/missions/tc_mission_generator.lua`
- AI-CAP-Manager erstellt:
  - `src/ai/tc_ai_cap_manager.lua`
- IADS-Bereich dokumentiert:
  - `src/iads/README.md`
- UI-Bereich dokumentiert:
  - `src/ui/README.md`
- Debug-Bereich dokumentiert:
  - `src/debug/README.md`

### Changed

- `src/README.md` nach Source-Ausbau aktualisiert
- `TASKS.md` nach Source-Ausbau aktualisiert
- `ROADMAP.md` nach Source-Ausbau aktualisiert
- `ARCHITECTURE.md` nach Source-Ausbau aktualisiert
- Root-`README.md` nach Source-Ausbau aktualisiert
- `src/loader.lua` schrittweise erweitert:
  - Core-Ladung ergänzt
  - World-Ladung ergänzt
  - Campaign-Ladung ergänzt
  - Logistics-Ladung ergänzt
  - Missions-Ladung ergänzt
  - AI-Ladung ergänzt
- `src/main.lua` an die aktuellen Modulnamen angepasst:
  - `TC.World.AirbaseScanner`
  - `TC.World.ZoneFactory`
  - `TC.Campaign.CaptureSystem`
  - `TC.Campaign.PersistenceSystem`
  - `TC.Logistics.Delivery`
  - `TC.Logistics.FobSystem`
  - `TC.Missions.Generator`
  - `TC.AI.CapManager`
- `src/main.lua` von Zukunftssystem-Liste auf Runtime-System-Liste umgestellt
- `src/main.lua` unterscheidet jetzt zwischen erforderlichen und optionalen Systemen
- `src/main.lua` behandelt IADS, UI und Debug als optionale spätere Systeme
- `src/main.lua` protokolliert gestartete, fehlgeschlagene und übersprungene Systeme
- `src/main.lua` kann Runtime-Systeme geordnet stoppen
- Loader- und Main-Startkette logisch geprüft
- `MISSION_EDITOR_SETUP.md` für den ersten Source-Ladetest aktualisiert
- `MISSION_EDITOR_SETUP.md` um DCS-Sandbox- und `dofile`-Prüfstrategie erweitert
- `MISSION_EDITOR_SETUP.md` um sichere Starttest-Variante A ergänzt:
  - Frameworks per `DO SCRIPT FILE` laden
  - aktive Source-Dateien einzeln per `DO SCRIPT FILE` laden
  - `src/main.lua` laden
  - `src/loader.lua` zuletzt laden
  - keine harte `dofile`-Abhängigkeit im ersten Test
- `MISSION_EDITOR_SETUP.md` um spätere Starttest-Variante B ergänzt:
  - Frameworks laden
  - nur `src/loader.lua` laden
  - `dofile`-Nachladen durch den Loader praktisch prüfen
- `TASKS.md` nach Mission-Editor-Source-Ladeplanung aktualisiert
- interne Theater-Command-Lade-Reihenfolge konkretisiert:
  - Core
  - World
  - Campaign
  - Logistics
  - Missions
  - AI
  - IADS
  - UI
  - Debug
  - Main
- `src/README.md` korrigiert:
  - Source-Implementierung ist nicht mehr nur geplant
  - erste aktive Lua-Module sind vorhanden
  - IADS, UI und Debug sind aktuell dokumentiert, aber noch nicht aktiv implementiert
- `TASKS.md` korrigiert:
  - Phase 1 bis Phase 7 teilweise erledigt
  - Phase 8 bis Phase 10 dokumentarisch vorbereitet
  - Starttest-Variante A als nächster praktischer Prüfpfad dokumentiert

### Current Source Modules

Aktuell vorhandene aktive eigene Lua-Module:

- `src/loader.lua`
- `src/main.lua`
- `src/core/tc_config.lua`
- `src/core/tc_logger.lua`
- `src/core/tc_state.lua`
- `src/core/tc_utils.lua`
- `src/core/tc_scheduler.lua`
- `src/world/tc_airbase_scanner.lua`
- `src/world/tc_zone_factory.lua`
- `src/campaign/tc_capture_system.lua`
- `src/campaign/tc_persistence_system.lua`
- `src/logistics/tc_logistics_delivery.lua`
- `src/logistics/tc_fob_system.lua`
- `src/missions/tc_mission_generator.lua`
- `src/ai/tc_ai_cap_manager.lua`

Aktuell vorhandene Source-Dokumentationen:

- `src/README.md`
- `src/core/README.md`
- `src/world/README.md`
- `src/campaign/README.md`
- `src/logistics/README.md`
- `src/missions/README.md`
- `src/ai/README.md`
- `src/iads/README.md`
- `src/ui/README.md`
- `src/debug/README.md`

### Current Framework Versions

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

### Current DCS Load Order

Die externe Framework-Lade-Reihenfolge im DCS Mission Editor bleibt:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua

Danach folgt für den ersten realen DEV-Test die sichere Einzeldatei-Ladung der aktiven Theater-Command-Module.

### Current Recommended Start Test

Empfohlene erste Testvariante:

    Starttest-Variante A — sichere Einzeldatei-Ladung

Dabei werden zuerst die Frameworks geladen.

Danach werden die aktiven Source-Dateien einzeln im Mission Editor geladen.

Danach wird `src/main.lua` geladen.

Zuletzt wird `src/loader.lua` geladen.

Ziel:

    keine harte dofile-Abhängigkeit im ersten Test
    alle Module im DCS-Kontext laden
    Framework-Verfügbarkeit prüfen
    Loader-/Main-Startkette prüfen
    dcs.log auf Lua-Fehler prüfen

### Current Internal Source Load Order

Die interne Source-Lade-Reihenfolge lautet:

    1. Core
    2. World
    3. Campaign
    4. Logistics
    5. Missions
    6. AI
    7. IADS
    8. UI
    9. Debug
    10. Main

Aktuell aktiv vom Loader geladen:

- Core
- World
- Campaign
- Logistics
- Missions
- AI
- Main

Noch nicht aktiv vom Loader geladen:

- IADS
- UI
- Debug

Grund:

Diese Bereiche besitzen aktuell nur README-Dateien und noch keine konkreten Lua-Implementierungen.

### Not Yet Implemented

Noch nicht umgesetzt:

- praktische DCS-Prüfung der Starttest-Variante A
- praktische DCS-Prüfung der Loader-only-Variante mit `dofile`
- konkrete IADS-Lua-Implementierung
- konkrete UI-/F10-Lua-Implementierung
- konkrete Debug-Lua-Implementierung
- reale MOOSE-CAP-Spawns
- reale CTLD-Ereignisauswertung
- reale Skynet-IADS-Kampagnenbrücke
- DCS-Dateipersistenz
- DCS-Sandbox-Prüfung für Dateizugriff
- DEV-Mission im DCS Mission Editor
- erster realer DCS-Starttest
- Debug-Menüs
- Mission-Editor-Dokumentation
- Mission-Ordnerstruktur
- Save-Ordnerstruktur
- Tools-Ordnerstruktur
- Assets-Ordnerstruktur

### Status

Diese Version ist noch keine spielbare DCS-Mission.

Der technische Source-Grundaufbau ist begonnen und enthält bereits erste eigene Theater-Command-Lua-Module.

`src/main.lua` ist an die aktuell vorhandenen Module angepasst.

Die Loader- und Main-Startkette ist logisch geprüft.

Die Mission-Editor-Ladestrategie für den ersten sicheren Source-Test ist dokumentiert.

Der nächste praktische Prüfpunkt ist:

    DEV-Testvariante A im DCS Mission Editor vorbereiten

Danach:

    dcs.log prüfen
    Loader-only-Variante mit dofile praktisch testen

---

## Version 0.1.0 — Source Foundation Baseline

### Added

- Source-Grundstruktur begonnen
- `src/loader.lua` als zentrale Einstiegdatei erstellt
- `src/main.lua` als Hauptinitialisierung erstellt
- Core-Bereich erstellt
- World-Bereich erstellt
- Campaign-Bereich erstellt
- Logistics-Bereich erstellt
- Missions-Bereich erstellt
- AI-Bereich erstellt
- IADS-Bereich dokumentiert
- UI-Bereich dokumentiert
- Debug-Bereich dokumentiert
- erste Core-Module erstellt
- erste World-Module erstellt
- erste Campaign-Module erstellt
- erste Logistics-Module erstellt
- erster Missionsgenerator erstellt
- erster AI-CAP-Manager erstellt

### Changed

- Projektstatus von reiner Dokumentations- und Vendor-Basis auf begonnene Source-Implementierung erweitert
- Loader auf modulare Source-Struktur ausgerichtet
- Source-Dokumentation an die tatsächliche Ordnerstruktur angepasst
- Tasks an den aktuellen Implementierungsstand angepasst
- Main-Initialisierung an aktuelle Runtime-Module angepasst
- Mission-Editor-Setup an die Source-Ladeteststrategie angepasst

### Status

Diese Version ist noch keine spielbare DCS-Mission.

Sie stellt die erste eigene Lua-Grundstruktur für Theater Command DCS bereit.

---

## Version 0.0.2 — Vendor Framework Baseline

### Added

- MIST als externes Framework unter `vendor/mist/` hinterlegt
- MOOSE als externes Framework unter `vendor/moose/` hinterlegt
- CTLD als externes Framework unter `vendor/ctld/` hinterlegt
- Skynet IADS als externes Framework unter `vendor/skynet-iads/` hinterlegt
- MIST-Handbuch als lokale Referenz hinterlegt
- MIST Example-DBs als Referenzmaterial hinterlegt
- MOOSE-Dokumentationsreferenz als Markdown-Datei hinterlegt
- Vendor-README-Dateien an den tatsächlichen Framework-Import angepasst
- `src/README.md` als Einstieg in die spätere eigene Lua-Struktur erstellt

### Changed

- MIST-Version auf die mit CTLD gelieferte Variante ersetzt
- MIST-Version in `vendor/mist/README.md` dokumentiert
- CTLD-Version in `vendor/ctld/README.md` dokumentiert
- MOOSE-Version in `vendor/moose/README.md` dokumentiert
- Skynet-IADS-Version in `vendor/skynet-iads/README.md` dokumentiert
- Root-`README.md` auf den aktuellen Vendor-Stand gebracht
- `ROADMAP.md` auf den aktuellen Vendor-Stand gebracht
- `TASKS.md` auf den aktuellen Vendor-Stand gebracht
- zentrale Lade-Reihenfolge dokumentiert

Aktive MIST-Version:

    MIST 4.5.128-DYNSLOTS-02

Grund:

CTLD weist darauf hin, dass für korrektes dynamisches Spawning die mit CTLD gelieferte MIST-Version verwendet werden soll.

### Removed

- falsch platzierte Root-`Moose.lua` entfernt

### Status

Diese Version ist noch keine spielbare DCS-Mission.

Sie stellt die lokale Framework-Basis für die weitere Entwicklung bereit.

---

## Version 0.0.1 — Initial Project Setup

### Added

- erste Projektidee dokumentiert
- GitHub-Grundstruktur begonnen
- Projektname **Theater Command DCS** festgelegt
- erste Kampagne als **Operation Levant Reclamation** definiert
- Syria Map als primärer Kampagnenraum festgelegt
- Akrotiri als blaue Startbasis definiert
- syrisches Festland als vollständig rot kontrollierter Ausgangszustand definiert
- Grundidee einer persistenten dynamischen DCS-Kampagne dokumentiert
- Leitprinzip festgelegt:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

- erste zentrale Projektdateien angelegt:
  - `README.md`
  - `ROADMAP.md`
  - `TASKS.md`
  - `CHANGELOG.md`
  - `ARCHITECTURE.md`
  - `MISSION_EDITOR_SETUP.md`
  - `NAMING_CONVENTIONS.md`
  - `LUA_STYLEGUIDE.md`
  - `.gitignore`
- Dokumentationsordner `docs/` angelegt
- Docs-Grundblock erstellt:
  - `docs/00_project_overview.md`
  - `docs/01_campaign_design.md`
  - `docs/02_technical_architecture.md`
  - `docs/03_mission_editor_basics.md`
  - `docs/04_airbase_system.md`
  - `docs/05_logistics_system.md`
  - `docs/06_mission_generator.md`
  - `docs/07_ai_director.md`
  - `docs/08_iads_system.md`
  - `docs/09_persistence.md`
  - `docs/10_testing.md`
- Vendor-Grundstruktur angelegt
- `vendor/README.md` erstellt
- MIST-Vendor-Ordner erstellt
- MOOSE-Vendor-Ordner erstellt
- CTLD-Vendor-Ordner erstellt
- Skynet-IADS-Vendor-Ordner erstellt
- Vendor-README-Dateien erstellt:
  - `vendor/mist/README.md`
  - `vendor/moose/README.md`
  - `vendor/ctld/README.md`
  - `vendor/skynet-iads/README.md`

### Status

Diese Version ist noch keine spielbare DCS-Mission.

Sie dient ausschließlich der Projektanlage, Dokumentation und Architekturplanung.
