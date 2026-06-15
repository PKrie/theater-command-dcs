# Tasks

Diese Datei enthält die aktuellen Aufgaben für das Projekt **Theater Command DCS**.

Ziel ist, das Projekt Schritt für Schritt aufzubauen und nicht mehrere große Baustellen gleichzeitig zu beginnen.

---

## Projekt

Projektname:

**Theater Command DCS**

Erste Kampagne:

**Operation Levant Reclamation**

Map:

**Syria**

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

Grundprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

---

## Aktueller Stand

Stand:

    2026-06-15

Aktuell erledigt:

- Repository erstellt
- zentrale Projektdokumentation angelegt
- `docs/`-Grundblock erstellt
- `vendor/`-Grundstruktur erstellt
- MIST hinterlegt
- MOOSE hinterlegt
- CTLD hinterlegt
- Skynet IADS hinterlegt
- MIST auf CTLD-kompatible Version ersetzt
- alle Vendor-README-Dateien nach Framework-Import aktualisiert
- `src/README.md` erstellt
- falsch platzierte Root-`Moose.lua` entfernt
- Root-`README.md` aktualisiert
- `ROADMAP.md` aktualisiert
- `TASKS.md` aktualisiert
- `CHANGELOG.md` aktualisiert
- `ARCHITECTURE.md` aktualisiert
- `MISSION_EDITOR_SETUP.md` aktualisiert
- `NAMING_CONVENTIONS.md` aktualisiert
- `LUA_STYLEGUIDE.md` aktualisiert
- alle vorhandenen `docs/`-Dateien nach Vendor-Import aktualisiert
- `vendor/README.md` aktualisiert

Aktueller Projektzustand:

    Phase 0 ist fachlich abgeschlossen.
    Vendor ist funktional abgeschlossen.
    Dokumentation ist auf dem aktuellen Stand.
    Eigene Lua-Implementierung ist noch nicht begonnen.

Nächster technischer Fokus:

    src-Unterordner und README-Dateien erstellen

Danach:

    src/loader.lua
    src/main.lua
    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua

---

## Aktueller Framework-Stand

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Wichtig:

Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket.

Grund:

CTLD weist darauf hin, dass für korrektes dynamisches Spawning die mit CTLD gelieferte MIST-Version verwendet werden soll.

---

## Geplante Lade-Reihenfolge

Die geplante Lade-Reihenfolge im DCS Mission Editor lautet:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua
    6. src/loader.lua

Wichtig:

- MIST muss vor CTLD geladen werden.
- `CTLD-i18n.lua` muss vor `CTLD.lua` geladen werden.
- Skynet IADS muss nach MIST geladen werden.
- Eigene Theater-Command-Logik startet erst nach den externen Frameworks.

---

## Arbeitsregel

Es wird immer nur ein sinnvoller Schritt nach dem anderen umgesetzt.

Keine parallelen Großbaustellen.

Jede neue Datei wird vollständig vorbereitet.

Eigene Theater-Command-Logik gehört nach:

    src/

Externe Frameworks gehören nach:

    vendor/

Externe Frameworks werden nicht verändert.

Die eigene Lua-Struktur wird nach Aufgaben sortiert, nicht nach Frameworks.

---

## Phase 0 — Repository-Grundstruktur

### Repository-Grunddateien

- [x] GitHub-Repository `theater-command-dcs` erstellen
- [x] `README.md` anlegen
- [x] `ROADMAP.md` anlegen
- [x] `TASKS.md` anlegen
- [x] `CHANGELOG.md` anlegen
- [x] `ARCHITECTURE.md` anlegen
- [x] `MISSION_EDITOR_SETUP.md` anlegen
- [x] `NAMING_CONVENTIONS.md` anlegen
- [x] `LUA_STYLEGUIDE.md` anlegen
- [x] `.gitignore` anlegen

---

## Phase 0 — Dokumentationsgrundlage

### Docs-Grundblock

- [x] `docs/00_project_overview.md`
- [x] `docs/01_campaign_design.md`
- [x] `docs/02_technical_architecture.md`
- [x] `docs/03_mission_editor_basics.md`
- [x] `docs/04_airbase_system.md`
- [x] `docs/05_logistics_system.md`
- [x] `docs/06_mission_generator.md`
- [x] `docs/07_ai_director.md`
- [x] `docs/08_iads_system.md`
- [x] `docs/09_persistence.md`
- [x] `docs/10_testing.md`

---

## Phase 0 — Vendor-Grundstruktur

### Vendor-Ordner

- [x] `vendor/README.md`
- [x] `vendor/mist/`
- [x] `vendor/moose/`
- [x] `vendor/ctld/`
- [x] `vendor/skynet-iads/`

### Vendor-README-Dateien

- [x] `vendor/mist/README.md`
- [x] `vendor/moose/README.md`
- [x] `vendor/ctld/README.md`
- [x] `vendor/skynet-iads/README.md`

---

## Phase 0 — Vendor-Frameworks

### MIST

- [x] `vendor/mist/mist.lua` hinterlegen
- [x] MIST-Handbuch hinterlegen
- [x] `vendor/mist/Mist guide.pdf` hinterlegen
- [x] `vendor/mist/Example_DBs/` anlegen
- [x] MIST-Beispiel-Datenbanken hinterlegen
- [x] MIST-Datei auf CTLD-kompatible Version ersetzen
- [x] `vendor/mist/README.md` nach Framework-Import aktualisieren
- [x] MIST-Version dokumentieren

Aktiver Stand:

    MIST 4.5.128-DYNSLOTS-02

---

### MOOSE

- [x] `vendor/moose/Moose.lua` hinterlegen
- [x] `vendor/moose/MOOSE_DOCS.md` anlegen
- [x] `vendor/moose/README.md` nach Framework-Import aktualisieren
- [x] MOOSE-Version dokumentieren
- [x] falsch platzierte Root-`Moose.lua` entfernen

Aktiver Stand:

    MOOSE 2.9.17

---

### CTLD

- [x] `vendor/ctld/CTLD-i18n.lua` hinterlegen
- [x] `vendor/ctld/CTLD.lua` hinterlegen
- [x] CTLD-MIST-Hinweis prüfen
- [x] MIST-Datei passend zu CTLD ersetzen
- [x] `vendor/ctld/README.md` nach Framework-Import aktualisieren
- [x] CTLD-Version dokumentieren

Aktiver Stand:

    CTLD 1.6.1

Nicht hinterlegt:

    vendor/ctld/beacon.ogg
    vendor/ctld/beaconsilent.ogg

Hinweis:

Diese Sounddateien werden erst ergänzt, wenn CTLD-Radio-Beacons aktiv genutzt werden sollen.

---

### Skynet IADS

- [x] `vendor/skynet-iads/SkynetIADS.lua` hinterlegen
- [x] kompilierte Skynet-IADS-Datei verwenden
- [x] Datei stabil als `SkynetIADS.lua` ablegen
- [x] `vendor/skynet-iads/README.md` nach Framework-Import aktualisieren
- [x] Skynet-IADS-Version dokumentieren

Aktiver Stand:

    Skynet IADS 3.3.0

---

## Phase 0 — Dokumentation nach Vendor-Abschluss

### Zentrale Dateien

- [x] `README.md` aktualisieren
- [x] `ROADMAP.md` aktualisieren
- [x] `TASKS.md` aktualisieren
- [x] `CHANGELOG.md` aktualisieren
- [x] `ARCHITECTURE.md` aktualisieren
- [x] `MISSION_EDITOR_SETUP.md` aktualisieren
- [x] `NAMING_CONVENTIONS.md` aktualisieren
- [x] `LUA_STYLEGUIDE.md` aktualisieren

### Vendor-Dokumentation

- [x] `vendor/README.md` aktualisieren
- [x] `vendor/mist/README.md` aktualisieren
- [x] `vendor/moose/README.md` aktualisieren
- [x] `vendor/ctld/README.md` aktualisieren
- [x] `vendor/skynet-iads/README.md` aktualisieren

### Docs-Dokumentation

- [x] `docs/00_project_overview.md` aktualisieren
- [x] `docs/01_campaign_design.md` aktualisieren
- [x] `docs/02_technical_architecture.md` aktualisieren
- [x] `docs/03_mission_editor_basics.md` aktualisieren
- [x] `docs/04_airbase_system.md` aktualisieren
- [x] `docs/05_logistics_system.md` aktualisieren
- [x] `docs/06_mission_generator.md` aktualisieren
- [x] `docs/07_ai_director.md` aktualisieren
- [x] `docs/08_iads_system.md` aktualisieren
- [x] `docs/09_persistence.md` aktualisieren
- [x] `docs/10_testing.md` aktualisieren

---

## Phase 0 — Source-Grundstruktur

### Bereits vorhanden

- [x] `src/README.md`

### Noch offen

- [ ] `src/loader.lua`
- [ ] `src/main.lua`
- [ ] `src/core/`
- [ ] `src/world/`
- [ ] `src/campaign/`
- [ ] `src/logistics/`
- [ ] `src/missions/`
- [ ] `src/ai/`
- [ ] `src/iads/`
- [ ] `src/ui/`
- [ ] `src/debug/`

### Src-README-Dateien

- [ ] `src/core/README.md`
- [ ] `src/world/README.md`
- [ ] `src/campaign/README.md`
- [ ] `src/logistics/README.md`
- [ ] `src/missions/README.md`
- [ ] `src/ai/README.md`
- [ ] `src/iads/README.md`
- [ ] `src/ui/README.md`
- [ ] `src/debug/README.md`

---

## Phase 1 — Core-System

Diese Phase beginnt erst nach Abschluss der `src/`-Unterordner und ihrer README-Dateien.

### Geplante Dateien

- [ ] `src/loader.lua`
- [ ] `src/main.lua`
- [ ] `src/core/tc_config.lua`
- [ ] `src/core/tc_logger.lua`
- [ ] `src/core/tc_state.lua`
- [ ] `src/core/tc_utils.lua`
- [ ] `src/core/tc_scheduler.lua`

### Aufgaben

- [ ] globale `TC`-Tabelle initialisieren
- [ ] Framework-Verfügbarkeit prüfen
- [ ] Lade-Reihenfolge der eigenen Dateien definieren
- [ ] Core-Dateien laden
- [ ] `main.lua` starten
- [ ] Debug-Ausgabe beim Start vorbereiten
- [ ] Fehlerausgabe für fehlende Frameworks vorbereiten
- [ ] erste sichtbare Ausgabe in `dcs.log` erzeugen

---

## Phase 2 — Airbase-System

### Geplante Dateien

- [ ] `src/world/tc_airbase_scanner.lua`
- [ ] `src/world/tc_airbase_registry.lua`
- [ ] `src/world/tc_airbase_overrides.lua`
- [ ] `src/world/tc_region_classifier.lua`
- [ ] `src/debug/tc_debug_airbases.lua`

### Aufgaben

- [ ] Airbase-Scanner bauen
- [ ] alle DCS-Airbases der Syria Map erfassen
- [ ] Akrotiri als blaue Startbasis erkennen
- [ ] syrisches Festland initial rot bewerten
- [ ] BaseNodes erzeugen
- [ ] Airbase-Koalitionsstatus erfassen
- [ ] Airbase-Daten für Capture-System vorbereiten
- [ ] Airbase-Debugausgabe vorbereiten

---

## Phase 3 — Zonen-System

### Geplante Dateien

- [ ] `src/world/tc_zone_factory.lua`
- [ ] `src/world/tc_zone_registry.lua`
- [ ] `src/debug/tc_debug_zones.lua`

### Aufgaben

- [ ] virtuelle Capture-Zonen erzeugen
- [ ] virtuelle Logistik-Zonen erzeugen
- [ ] virtuelle Defense-Zonen erzeugen
- [ ] Debug-Anzeige für Zonen vorbereiten
- [ ] Zonen mit Airbases verknüpfen
- [ ] Zonen für spätere Missionen nutzbar machen

---

## Phase 4 — Capture-System

### Geplante Dateien

- [ ] `src/campaign/tc_capture_system.lua`
- [ ] `src/campaign/tc_base_ownership.lua`
- [ ] `src/campaign/tc_campaign_state.lua`
- [ ] `src/campaign/tc_frontline_system.lua`

### Aufgaben

- [ ] Besitzerstatus für Basen vorbereiten
- [ ] Besitzerstatus für Zonen vorbereiten
- [ ] Blau/Rot/Neutral-Status definieren
- [ ] Capture-Bedingungen definieren
- [ ] Garnisonen auswerten
- [ ] Supply-Status auswerten
- [ ] Verbindung zum Airbase-System vorbereiten
- [ ] Verbindung zum Logistiksystem vorbereiten
- [ ] Capture-Debugausgabe vorbereiten

---

## Phase 5 — Logistics und CTLD-Anbindung

### Geplante Dateien

- [ ] `src/logistics/tc_logistics_delivery.lua`
- [ ] `src/logistics/tc_fob_system.lua`
- [ ] `src/logistics/tc_logistics_state.lua`
- [ ] `src/logistics/tc_logistics_hubs.lua`
- [ ] `src/logistics/tc_supply_routes.lua`
- [ ] `src/ui/tc_f10_menu.lua`
- [ ] `src/debug/tc_debug_logistics.lua`

### Aufgaben

- [ ] CTLD-Grundkonfiguration vorbereiten
- [ ] Akrotiri als Start-Logistikhub definieren
- [ ] erste Pickup-Zonen für Akrotiri vorbereiten
- [ ] erste Dropoff-Zonen vorbereiten
- [ ] Logistiklieferungen kampagnenlogisch auswerten
- [ ] CTLD-Lieferungen mit Theater Command verbinden
- [ ] FOB-System vorbereiten
- [ ] eroberte Basen als neue Logistikhubs freischalten

---

## Phase 6 — Missionsgenerator

### Geplante Dateien

- [ ] `src/missions/tc_mission_generator.lua`
- [ ] `src/missions/tc_mission_registry.lua`
- [ ] `src/missions/tc_mission_types.lua`
- [ ] `src/missions/tc_mission_filter_by_aircraft.lua`

### Aufgaben

- [ ] Spielerflugzeug erkennen
- [ ] Missionen nach Flugzeugtyp filtern
- [ ] erste einfache Missionsliste über F10 anzeigen
- [ ] Airbase-Ziele aus Kampagnenzustand ableiten
- [ ] SEAD/DEAD-Ziele aus IADS-Zustand ableiten
- [ ] Logistikmissionen aus Logistikzustand ableiten
- [ ] Missionserfolg später auswertbar machen

---

## Phase 7 — AI Director

### Geplante Dateien

- [ ] `src/ai/tc_ai_director.lua`
- [ ] `src/ai/tc_ai_cap_manager.lua`
- [ ] `src/ai/tc_ai_gci_manager.lua`
- [ ] `src/ai/tc_ai_counterattack.lua`

### Aufgaben

- [ ] einfache CAP-Logik vorbereiten
- [ ] einfache GCI-Logik vorbereiten
- [ ] KI-Reaktionen auf Spielerfortschritt vorbereiten
- [ ] KI-Reaktionen auf Capture-Ereignisse vorbereiten
- [ ] KI-Reaktionen auf IADS-Schäden vorbereiten
- [ ] KI-Gegenangriffe vorbereiten

---

## Phase 8 — IADS-System

### Geplante Dateien

- [ ] `src/iads/tc_iads_network.lua`
- [ ] `src/iads/tc_iads_sites.lua`
- [ ] `src/iads/tc_iads_sectors.lua`
- [ ] `src/iads/tc_iads_state.lua`
- [ ] `src/iads/tc_iads_config.lua`
- [ ] `src/debug/tc_debug_iads.lua`

### Aufgaben

- [ ] rote IADS-Sektoren vorbereiten
- [ ] SAM-Stellungen als Kampagnenobjekte definieren
- [ ] Radarstellungen als Kampagnenobjekte definieren
- [ ] zerstörte IADS-Objekte kampagnenlogisch speichern
- [ ] Missionsgenerator mit IADS-Zielen verbinden
- [ ] AI Director mit IADS-Zustand verbinden

---

## Phase 9 — Persistenz

### Geplante Dateien

- [ ] `src/campaign/tc_persistence_system.lua`
- [ ] `save/README.md`
- [ ] `save/example_state.lua`

### Aufgaben

- [ ] Speicherstruktur definieren
- [ ] Beispiel-Save-State erstellen
- [ ] Kampagnenzustand serialisieren
- [ ] Kampagnenzustand laden
- [ ] Airbase-Besitz speichern
- [ ] Logistikstatus speichern
- [ ] IADS-Zustand speichern
- [ ] Missionsfortschritt speichern

---

## Mission-Editor-Grundlage

Diese Aufgaben werden später im DCS Mission Editor erledigt.

### DEV-Mission

- [ ] Syria Map als neue Mission öffnen
- [ ] Mission speichern als `Operation_Levant_Reclamation_DEV.miz`
- [ ] Mission unter `mission/dev/` ablegen
- [ ] Koalitionen festlegen
- [ ] Akrotiri als blaue Startbasis nutzen
- [ ] syrisches Festland initial rot kontrolliert anlegen
- [ ] erste Spieler-Slots auf Akrotiri anlegen
- [ ] erste CTLD-Pickup-Zonen auf Akrotiri anlegen
- [ ] erste Template-Gruppen mit Late Activation anlegen
- [ ] erste Framework-Lade-Trigger vorbereiten

---

## Mission-Editor-Dokumentation

Diese Dateien werden später unter `mission_editor/` angelegt.

- [ ] `mission_editor/README.md`
- [ ] `mission_editor/client_slots.md`
- [ ] `mission_editor/template_groups.md`
- [ ] `mission_editor/trigger_setup.md`
- [ ] `mission_editor/ctld_start_zones.md`
- [ ] `mission_editor/static_targets.md`

---

## Mission-Ordner

Diese Ordner werden später für konkrete Missionsdateien genutzt.

- [ ] `mission/README.md`
- [ ] `mission/dev/README.md`
- [ ] `mission/test/README.md`
- [ ] `mission/release/README.md`

---

## Assets

Dieser Ordner wird später für nicht-Lua-Projektmaterial genutzt.

- [ ] `assets/README.md`

Mögliche spätere Inhalte:

- Briefing-Bilder
- Kartenbilder
- Logos
- Funktexte
- Audio-Dateien
- PDF-Briefings

---

## Save

Dieser Ordner wird später für Persistenz genutzt.

- [ ] `save/README.md`
- [ ] `save/example_state.lua`

---

## Tools

Dieser Ordner wird später für Entwicklungs- und Release-Hilfen genutzt.

- [ ] `tools/README.md`
- [ ] `tools/build_notes.md`
- [ ] `tools/test_plan.md`
- [ ] `tools/release_checklist.md`

---

## Was aktuell bewusst nicht gemacht wird

Diese Punkte werden noch nicht begonnen:

- [ ] keine vollständige Frontlinie bauen
- [ ] keine komplette Syria Map manuell mit Einheiten füllen
- [ ] keine 69 Airbase-Zonen im Mission Editor anlegen
- [ ] keine riesigen Triggerketten im Mission Editor bauen
- [ ] keine große Sammeldatei für MOOSE erstellen
- [ ] keine große Sammeldatei für MIST erstellen
- [ ] keine große Sammeldatei für CTLD erstellen
- [ ] keine All-in-one-Lua-Datei erstellen
- [ ] keine Persistenz vor dem Airbase- und Capture-System bauen
- [ ] keine dynamische Großkampagne bauen, bevor die Core-Struktur steht

---

## Nicht gewünschte eigene Lua-Dateien

Diese Dateien sollen nicht erstellt werden:

- [ ] `src/tc_moose.lua`
- [ ] `src/tc_mist.lua`
- [ ] `src/tc_ctld.lua`
- [ ] `src/tc_all_in_one.lua`
- [ ] `src/tc_skynet.lua`
- [ ] `src/tc_iads_all_in_one.lua`

---

## Gewünschte aufgabenorientierte Lua-Dateien

Diese Dateien sind perspektivisch erwünscht:

- [ ] `src/world/tc_airbase_scanner.lua`
- [ ] `src/world/tc_zone_factory.lua`
- [ ] `src/campaign/tc_capture_system.lua`
- [ ] `src/logistics/tc_logistics_delivery.lua`
- [ ] `src/logistics/tc_fob_system.lua`
- [ ] `src/missions/tc_mission_generator.lua`
- [ ] `src/ai/tc_ai_cap_manager.lua`
- [ ] `src/campaign/tc_persistence_system.lua`

---

## Aktuell nächster sinnvoller Einzelschritt

Als nächster technischer Schritt wird die `src/`-Unterstruktur vorbereitet.

Nächste Datei:

    src/core/README.md

Danach folgen einzeln:

    src/world/README.md
    src/campaign/README.md
    src/logistics/README.md
    src/missions/README.md
    src/ai/README.md
    src/iads/README.md
    src/ui/README.md
    src/debug/README.md

Erst danach werden echte Lua-Dateien begonnen.

---

## Arbeitsreihenfolge

Grundsatz:

    Erst Dokumentation.
    Dann Vendor abschließen.
    Dann src-Struktur.
    Dann Core.
    Dann Airbases.
    Dann Zonen.
    Dann Capture.
    Dann CTLD-Anbindung.
    Dann Missionen.
    Dann KI.
    Dann IADS.
    Dann Persistenz.
    Dann DEV-Mission.
    Dann Testing.
    Dann Release-Struktur.
