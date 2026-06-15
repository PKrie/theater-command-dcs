# Changelog

Alle relevanten Änderungen am Projekt **Theater Command DCS** werden in dieser Datei dokumentiert.

Das Projekt befindet sich aktuell in der frühen Aufbauphase.

Aktueller Fokus:

    Projektgrundlage, Vendor-Frameworks und Dokumentation

---

## Unreleased

### Added

- GitHub-Repository `theater-command-dcs` erstellt
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

- zentrale Projektdateien angelegt:

    README.md
    ROADMAP.md
    TASKS.md
    CHANGELOG.md
    ARCHITECTURE.md
    MISSION_EDITOR_SETUP.md
    NAMING_CONVENTIONS.md
    LUA_STYLEGUIDE.md
    .gitignore

- Dokumentationsordner `docs/` angelegt
- Docs-Grundblock erstellt:

    docs/00_project_overview.md
    docs/01_campaign_design.md
    docs/02_technical_architecture.md
    docs/03_mission_editor_basics.md
    docs/04_airbase_system.md
    docs/05_logistics_system.md
    docs/06_mission_generator.md
    docs/07_ai_director.md
    docs/08_iads_system.md
    docs/09_persistence.md
    docs/10_testing.md

- Vendor-Grundstruktur angelegt
- `vendor/README.md` erstellt
- MIST-Vendor-Ordner erstellt
- MOOSE-Vendor-Ordner erstellt
- CTLD-Vendor-Ordner erstellt
- Skynet-IADS-Vendor-Ordner erstellt
- Vendor-README-Dateien erstellt:

    vendor/mist/README.md
    vendor/moose/README.md
    vendor/ctld/README.md
    vendor/skynet-iads/README.md

- MIST-Framework hinterlegt:

    vendor/mist/mist.lua

- MIST-Handbuch hinterlegt:

    vendor/mist/Mist guide.pdf

- MIST-Beispiel-Datenbanken hinterlegt:

    vendor/mist/Example_DBs/

- MOOSE-Framework hinterlegt:

    vendor/moose/Moose.lua

- MOOSE-Dokumentationsreferenz erstellt:

    vendor/moose/MOOSE_DOCS.md

- CTLD-Framework-Dateien hinterlegt:

    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua

- Skynet-IADS-Framework-Datei hinterlegt:

    vendor/skynet-iads/SkynetIADS.lua

- `src/README.md` erstellt
- Root-`README.md` nach Vendor-Import aktualisiert
- `ROADMAP.md` nach Vendor-Import aktualisiert
- `TASKS.md` nach Vendor-Import aktualisiert

---

### Changed

- MIST wurde auf die CTLD-kompatible Version ersetzt.

Aktiver Stand:

    MIST 4.5.128-DYNSLOTS-02

Grund:

CTLD weist darauf hin, dass für korrektes dynamisches Spawning die mit CTLD gelieferte MIST-Version verwendet werden soll.

- Vendor-Dokumentation wurde nach dem tatsächlichen Framework-Import aktualisiert.
- MOOSE wird im Projekt als stabile Datei unter folgendem Pfad geführt:

    vendor/moose/Moose.lua

- Skynet IADS wird im Projekt als stabile Datei unter folgendem Pfad geführt:

    vendor/skynet-iads/SkynetIADS.lua

- Die Framework-Dateien werden unter stabilen Projektnamen geführt, damit die spätere Mission-Editor-Ladefolge nicht bei jedem Versionswechsel angepasst werden muss.
- Die Dokumentation wurde auf die aktuelle geplante Lade-Reihenfolge ausgerichtet:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua
    6. src/loader.lua

---

### Removed

- falsch platzierte Root-Datei entfernt:

    Moose.lua

Grund:

MOOSE gehört ausschließlich unter:

    vendor/moose/Moose.lua

---

### Current Framework Versions

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

---

### Not Yet Implemented

Noch nicht begonnen:

- eigene Lua-Core-Dateien
- `src/loader.lua`
- `src/main.lua`
- `src/core/`
- `src/world/`
- `src/campaign/`
- `src/logistics/`
- `src/missions/`
- `src/ai/`
- `src/iads/`
- `src/ui/`
- `src/debug/`
- Airbase-Scanner
- virtuelles Zonen-System
- Capture-System
- CTLD-Anbindung an Theater-Command-Logik
- Missionsgenerator
- AI Director
- IADS-Anbindung an Theater-Command-Logik
- Persistenz
- DEV-Mission im DCS Mission Editor

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
- Projektziel definiert:

    persistente dynamische Kampagne
    automatische Airbase-Erkennung
    virtuelle Capture- und Logistikzonen
    CTLD-gestütztes Logistiksystem
    dynamische Missionsauswahl nach Flugzeugtyp
    KI-gesteuerte Reaktionen
    langfristige Persistenz

- erste zentrale Projektdateien angelegt
- erste Architekturregeln definiert
- erste Aufgabenstruktur vorbereitet
- erste Roadmap vorbereitet

### Status

Diese Version ist noch keine spielbare DCS-Mission.

Sie dient ausschließlich der Projektanlage, Dokumentation und Architekturplanung.

---

## Aktueller nächster Dokumentationsschritt

Nach dieser Aktualisierung:

    ARCHITECTURE.md aktualisieren

Danach:

    vendor/README.md aktualisieren
    docs/02_technical_architecture.md aktualisieren
    docs/03_mission_editor_basics.md aktualisieren
    docs/05_logistics_system.md aktualisieren
    docs/08_iads_system.md aktualisieren
