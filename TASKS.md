# Tasks

Diese Datei enthält die aktuellen Aufgaben für das Projekt **Theater Command DCS**.

Ziel ist, das Projekt Schritt für Schritt aufzubauen und nicht mehrere große Baustellen gleichzeitig zu beginnen.

---

## Aktueller Projektstand

Repository erstellt  
README.md angelegt  
ROADMAP.md angelegt  
Projekt befindet sich in Phase 0 — Projektgrundlage

---

## Phase 0 — Projektgrundlage

### GitHub-Grundstruktur

- [x] GitHub-Repository `theater-command-dcs` erstellen
- [x] README.md anlegen
- [x] ROADMAP.md anlegen
- [x] TASKS.md anlegen
- [x] CHANGELOG.md anlegen
- [x] ARCHITECTURE.md anlegen
- [x] MISSION_EDITOR_SETUP.md anlegen
- [x] NAMING_CONVENTIONS.md anlegen
- [x] LUA_STYLEGUIDE.md anlegen
- [x] .gitignore anlegen

---

## Dokumentationsordner vorbereiten

Diese Dateien werden später im Ordner `docs/` angelegt:

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

## Projektordner vorbereiten

Folgende Hauptordner sollen im Repository angelegt werden:

- [x] `docs/`
- [x] `vendor/`
- [ ] `src/`
- [ ] `mission/`
- [ ] `mission_editor/`
- [ ] `assets/`
- [ ] `save/`
- [ ] `tools/`

---

## Framework-Ordner vorbereiten

Diese Ordner sind für externe Frameworks vorgesehen:

- [ ] `vendor/mist/`
- [ ] `vendor/moose/`
- [ ] `vendor/ctld/`
- [ ] `vendor/skynet-iads/`

Hinweis:

Die Frameworks werden nicht verändert. Sie werden nur als externe Bibliotheken eingebunden.

---

## Lua-Quellstruktur vorbereiten

Folgende Ordner werden unter `src/` angelegt:

- [ ] `src/core/`
- [ ] `src/world/`
- [ ] `src/campaign/`
- [ ] `src/logistics/`
- [ ] `src/missions/`
- [ ] `src/ai/`
- [ ] `src/iads/`
- [ ] `src/ui/`
- [ ] `src/debug/`

---

## Erste Lua-Dateien

Diese Dateien werden später als erste technische Basis angelegt:

- [ ] `src/loader.lua`
- [ ] `src/main.lua`
- [ ] `src/core/tc_config.lua`
- [ ] `src/core/tc_logger.lua`
- [ ] `src/core/tc_state.lua`
- [ ] `src/core/tc_utils.lua`
- [ ] `src/core/tc_scheduler.lua`

---

## Mission-Editor-Grundlage

Diese Aufgaben werden im DCS Mission Editor erledigt:

- [ ] Syria Map als neue Mission öffnen
- [ ] Mission speichern als `Operation_Levant_Reclamation_DEV.miz`
- [ ] Mission unter `mission/dev/` ablegen
- [ ] Koalitionen festlegen
- [ ] Akrotiri als blaue Startbasis nutzen
- [ ] erste Spieler-Slots auf Akrotiri anlegen
- [ ] erste CTLD-Pickup-Zonen auf Akrotiri anlegen
- [ ] erste Template-Gruppen mit Late Activation anlegen
- [ ] erste Framework-Lade-Trigger vorbereiten

---

## Erste empfohlene Client-Slots

Diese Slots sollen in der ersten DEV-Mission auf Akrotiri angelegt werden:

CLIENT_BLUE_FA18C_AKROTIRI_01  
CLIENT_BLUE_FA18C_AKROTIRI_02  
CLIENT_BLUE_F16C_AKROTIRI_01  
CLIENT_BLUE_F16C_AKROTIRI_02  
CLIENT_BLUE_F15E_AKROTIRI_01  
CLIENT_BLUE_F15E_AKROTIRI_02  
CLIENT_BLUE_F14B_AKROTIRI_01  
CLIENT_BLUE_F14B_AKROTIRI_02  
CLIENT_BLUE_UH1H_AKROTIRI_01  
CLIENT_BLUE_MI8_AKROTIRI_01  

---

## Erste technische Entwicklungsaufgaben

Nach Abschluss der GitHub-Grundstruktur beginnen die ersten Lua-Systeme.

### Core

- [ ] globale `TC`-Tabelle initialisieren
- [ ] Logger erstellen
- [ ] zentrale Konfiguration erstellen
- [ ] globalen State vorbereiten
- [ ] Loader-Reihenfolge definieren

### Airbase-System

- [ ] Airbase-Scanner bauen
- [ ] Airbase-Debugausgabe bauen
- [ ] Akrotiri erkennen
- [ ] Khmeimim erkennen
- [ ] alle Airbases der Syria Map auflisten
- [ ] BaseNodes erzeugen

### Zonen-System

- [ ] virtuelle Capture-Zonen erzeugen
- [ ] virtuelle Logistik-Zonen erzeugen
- [ ] virtuelle Defense-Zonen erzeugen
- [ ] Debug-Anzeige für Zonen vorbereiten

### CTLD

- [ ] CTLD-Grundkonfiguration vorbereiten
- [ ] Akrotiri als Start-Logistikhub definieren
- [ ] CTLD-Lieferungen später mit Theater Command verbinden

### Missionsgenerator

- [ ] Spielerflugzeug erkennen
- [ ] Missionen nach Flugzeugtyp filtern
- [ ] erste einfache Missionsliste über F10 anzeigen

---

## Was aktuell nicht gemacht wird

Diese Punkte werden bewusst noch nicht begonnen:

- [ ] keine vollständige Frontlinie bauen
- [ ] keine komplette Syria Map manuell mit Einheiten füllen
- [ ] keine 69 Airbase-Zonen im Mission Editor anlegen
- [ ] keine riesigen Triggerketten im Mission Editor bauen
- [ ] keine große Sammeldatei für MOOSE erstellen
- [ ] keine große Sammeldatei für CTLD erstellen
- [ ] keine Persistenz vor dem Airbase- und Capture-System bauen

---

## Arbeitsregel

Es wird immer nur ein sinnvoller Schritt nach dem anderen umgesetzt.

Erst Dokumentation.  
Dann Grundstruktur.  
Dann Mission-Editor-Basis.  
Dann Lua-Core.  
Dann Airbase-Scanner.  
Dann Zonen.  
Dann Capture.  
Dann CTLD.  
Dann Missionsgenerator.  

Keine parallelen Großbaustellen.
