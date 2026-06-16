# Tasks

Diese Datei enthält die aktuellen Aufgaben für das Projekt **Theater Command DCS**.

Ziel ist, das Projekt Schritt für Schritt aufzubauen und nicht mehrere große Baustellen gleichzeitig zu beginnen.

---

## Projekt

Projektname: **Theater Command DCS**

Erste Kampagne: **Operation Levant Reclamation**

Map: **Syria**

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

Grundprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

---

## Aktueller Stand

Stand: 2026-06-16

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
- zentrale Dokumentation nach Vendor-Abschluss aktualisiert
- `src/README.md` erstellt
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
- Core-Module erstellt
- World-Module erstellt
- Campaign-Module erstellt
- Logistics-Module erstellt
- Missions-Modul erstellt
- AI-CAP-Modul erstellt
- Loader schrittweise auf Core, World, Campaign, Logistics, Missions und AI erweitert
- `src/main.lua` gegen aktuelle Modulnamen geprüft und angepasst
- Loader- und Main-Startkette logisch geprüft
- `src/README.md` nach Source-Ausbau aktualisiert
- `TASKS.md` nach Source-Ausbau aktualisiert
- `CHANGELOG.md` nach Source-Ausbau aktualisiert
- `ROADMAP.md` nach Source-Ausbau aktualisiert
- `ARCHITECTURE.md` nach Source-Ausbau aktualisiert
- Root-`README.md` nach Source-Ausbau aktualisiert
- `CHANGELOG.md` nach Main-Aktualisierung aktualisiert
- `TASKS.md` nach Loader-/Main-Startkettenprüfung aktualisiert
- `MISSION_EDITOR_SETUP.md` für Source-Ladetest und `dofile`-Prüfstrategie aktualisiert

Aktueller Projektzustand:

    Phase 0 ist fachlich abgeschlossen.
    Vendor ist funktional abgeschlossen.
    Die Source-Grundstruktur ist angelegt.
    Erste eigene Lua-Module sind erstellt.
    Loader und Main sind auf die aktuellen Module ausgerichtet.
    Die Loader-/Main-Startkette ist logisch geprüft.
    Die Mission-Editor-Dokumentation beschreibt jetzt eine sichere erste Source-Ladevariante ohne dofile-Abhängigkeit.
    Der aktuelle Fokus liegt auf der Vorbereitung des ersten realen DCS-Starttests.

Noch nicht erledigt:

- `TASKS.md` nach Mission-Editor-Setup-Aktualisierung abschließend aktualisieren
- Start aller geladenen Module technisch in DCS verifizieren
- DCS-Sandbox-Verhalten für `dofile` praktisch testen
- erster realer DCS-Mission-Starttest durchführen
- DCS-Mission-Editor-Test vorbereiten
- DEV-Mission im DCS Mission Editor erstellen
- IADS-Implementierung beginnen
- UI-Implementierung beginnen
- Debug-Implementierung beginnen

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

## DCS-Lade-Reihenfolge

Die geplante Lade-Reihenfolge im DCS Mission Editor lautet:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua

Danach folgt für den ersten realen DEV-Test zunächst die sichere Einzeldatei-Ladung der aktiven Theater-Command-Module.

---

## Sichere erste Source-Ladevariante

Für den ersten DCS-Test wird nicht vorausgesetzt, dass `dofile` zuverlässig funktioniert.

Empfohlen wird zuerst:

    Starttest-Variante A — sichere Einzeldatei-Ladung

Dabei werden alle aktiven Source-Dateien einzeln im Mission Editor per `DO SCRIPT FILE` geladen.

Danach wird `src/loader.lua` zuletzt geladen.

Ziel:

    Module im DCS-Kontext testen
    dofile-Abhängigkeit vermeiden
    Framework-Ladung prüfen
    Theater-Command-Startkette prüfen
    dcs.log auf Fehler prüfen

---

## Geplante Trigger-Reihenfolge für Starttest-Variante A

Im DCS Mission Editor werden die Dateien zeitversetzt geladen:

    TIME MORE 1
    DO SCRIPT FILE: vendor/mist/mist.lua

    TIME MORE 2
    DO SCRIPT FILE: vendor/moose/Moose.lua

    TIME MORE 3
    DO SCRIPT FILE: vendor/ctld/CTLD-i18n.lua

    TIME MORE 4
    DO SCRIPT FILE: vendor/ctld/CTLD.lua

    TIME MORE 5
    DO SCRIPT FILE: vendor/skynet-iads/SkynetIADS.lua

    TIME MORE 7
    DO SCRIPT FILE: src/core/tc_config.lua

    TIME MORE 8
    DO SCRIPT FILE: src/core/tc_logger.lua

    TIME MORE 9
    DO SCRIPT FILE: src/core/tc_state.lua

    TIME MORE 10
    DO SCRIPT FILE: src/core/tc_utils.lua

    TIME MORE 11
    DO SCRIPT FILE: src/core/tc_scheduler.lua

    TIME MORE 12
    DO SCRIPT FILE: src/world/tc_airbase_scanner.lua

    TIME MORE 13
    DO SCRIPT FILE: src/world/tc_zone_factory.lua

    TIME MORE 14
    DO SCRIPT FILE: src/campaign/tc_capture_system.lua

    TIME MORE 15
    DO SCRIPT FILE: src/campaign/tc_persistence_system.lua

    TIME MORE 16
    DO SCRIPT FILE: src/logistics/tc_logistics_delivery.lua

    TIME MORE 17
    DO SCRIPT FILE: src/logistics/tc_fob_system.lua

    TIME MORE 18
    DO SCRIPT FILE: src/missions/tc_mission_generator.lua

    TIME MORE 19
    DO SCRIPT FILE: src/ai/tc_ai_cap_manager.lua

    TIME MORE 20
    DO SCRIPT FILE: src/main.lua

    TIME MORE 22
    DO SCRIPT FILE: src/loader.lua

---

## Interne Source-Lade-Reihenfolge

Die interne Theater-Command-Lade-Reihenfolge ist:

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

Aktuell lädt `src/loader.lua`:

- Core
- World
- Campaign
- Logistics
- Missions
- AI
- Main

IADS, UI und Debug besitzen aktuell nur README-Dateien und noch keine aktiven Lua-Module.

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

## Phase 1 — Source-Grundstruktur und Core-System

### Source-Unterstruktur

- [x] `src/README.md`
- [x] `src/core/`
- [x] `src/world/`
- [x] `src/campaign/`
- [x] `src/logistics/`
- [x] `src/missions/`
- [x] `src/ai/`
- [x] `src/iads/`
- [x] `src/ui/`
- [x] `src/debug/`

### Src-README-Dateien

- [x] `src/core/README.md`
- [x] `src/world/README.md`
- [x] `src/campaign/README.md`
- [x] `src/logistics/README.md`
- [x] `src/missions/README.md`
- [x] `src/ai/README.md`
- [x] `src/iads/README.md`
- [x] `src/ui/README.md`
- [x] `src/debug/README.md`

### Core-Dateien

- [x] `src/loader.lua`
- [x] `src/main.lua`
- [x] `src/core/tc_config.lua`
- [x] `src/core/tc_logger.lua`
- [x] `src/core/tc_state.lua`
- [x] `src/core/tc_utils.lua`
- [x] `src/core/tc_scheduler.lua`

### Core-Aufgaben

- [x] globale `TC`-Tabelle initialisieren
- [x] Framework-Verfügbarkeit prüfen
- [x] Lade-Reihenfolge der eigenen Dateien definieren
- [x] Core-Dateien laden
- [x] `main.lua` laden
- [x] `main.lua` starten
- [x] Debug-Ausgabe beim Start vorbereiten
- [x] Fehlerausgabe für fehlende Frameworks vorbereiten
- [x] erste sichtbare Ausgabe in `dcs.log` vorbereiten
- [x] `src/main.lua` gegen aktuelle Modulnamen prüfen und anpassen
- [x] Loader- und Main-Startkette logisch prüfen

### Noch zu prüfen

- [ ] Start aller geladenen Module technisch in DCS verifizieren
- [ ] DCS-Sandbox-Verhalten für `dofile` praktisch testen
- [ ] erster realer DCS-Mission-Starttest durchführen

---

## Phase 2 — Airbase-System

### Geplante Dateien

- [x] `src/world/tc_airbase_scanner.lua`
- [ ] `src/debug/tc_debug_airbase_report.lua`

### Aufgaben

- [x] Airbase-Scanner bauen
- [x] Airbases über DCS-API erfassbar machen
- [x] Akrotiri als blaue Startbasis vorbereiten
- [x] syrisches Festland initial rot bewerten
- [x] Base-Datensätze erzeugen
- [x] Airbase-Koalitionsstatus erfassen
- [x] Airbase-Daten für Capture-System vorbereiten
- [ ] Airbase-Debugausgabe vorbereiten
- [ ] realen Syria-Airbase-Scan in DCS testen

---

## Phase 3 — Zonen-System

### Geplante Dateien

- [x] `src/world/tc_zone_factory.lua`
- [ ] `src/debug/tc_debug_zone_overlay.lua`

### Aufgaben

- [x] virtuelle Kampagnenzonen vorbereiten
- [x] virtuelle Airbase-Zonen vorbereiten
- [x] Mission-Editor-Zonen optional über MIST einlesbar machen
- [x] Zonen mit Airbases verknüpfen
- [x] Zonen für spätere Missionen nutzbar machen
- [ ] Debug-Anzeige für Zonen vorbereiten
- [ ] reale Zonenprüfung in DCS testen

---

## Phase 4 — Capture-System

### Geplante Dateien

- [x] `src/campaign/tc_capture_system.lua`
- [ ] `src/debug/tc_debug_capture_report.lua`

### Aufgaben

- [x] Besitzerstatus für Basen vorbereiten
- [x] Besitzerstatus für Zonen vorbereiten
- [x] Blau/Rot/Neutral/Contested/Unknown-Status vorbereiten
- [x] Besitzstatus lesen
- [x] Besitzstatus ändern
- [x] Capture-Events speichern
- [x] State als dirty markieren
- [x] Verbindung zum Airbase-System vorbereiten
- [x] Verbindung zum Zonen-System vorbereiten
- [ ] Capture-Bedingungen fachlich definieren
- [ ] Garnisonen später auswerten
- [ ] Supply-Status später auswerten
- [ ] Capture-Debugausgabe vorbereiten
- [ ] Capture-System in DCS testen

---

## Phase 5 — Logistics und CTLD-Anbindung

### Geplante Dateien

- [x] `src/logistics/tc_logistics_delivery.lua`
- [x] `src/logistics/tc_fob_system.lua`
- [ ] `src/ui/tc_logistics_menu.lua`
- [ ] `src/debug/tc_debug_logistics_report.lua`

### Aufgaben

- [x] Logistik-State vorbereiten
- [x] Lieferungen anlegen
- [x] Lieferstatus verwalten
- [x] Lieferungen als abgeschlossen markieren
- [x] Lieferungen als verloren markieren
- [x] Lieferungen abbrechen oder löschen
- [x] logistische Effekte auf Zonen vorbereiten
- [x] logistische Effekte auf Basen vorbereiten
- [x] FOB-System vorbereiten
- [x] FOBs anlegen
- [x] FOB-Zustände verwalten
- [x] FOB-Versorgung verwalten
- [x] FOB-Baufortschritt verwalten
- [ ] CTLD-Grundkonfiguration vorbereiten
- [ ] Akrotiri als Start-Logistikhub definieren
- [ ] erste Pickup-Zonen für Akrotiri vorbereiten
- [ ] erste Dropoff-Zonen vorbereiten
- [ ] CTLD-Lieferungen mit Theater Command verbinden
- [ ] eroberte Basen als neue Logistikhubs freischalten
- [ ] Logistiksystem in DCS testen

---

## Phase 6 — Missionsgenerator

### Geplante Dateien

- [x] `src/missions/tc_mission_generator.lua`
- [ ] `src/ui/tc_mission_menu.lua`
- [ ] `src/debug/tc_debug_mission_report.lua`

### Aufgaben

- [x] Missionsarten vorbereiten
- [x] Missionsstatus vorbereiten
- [x] Missionen aus Kampagnenzustand erzeugen
- [x] Missionen im State speichern
- [x] verfügbare Missionen verwalten
- [x] aktive Missionen verwalten
- [x] abgeschlossene Missionen verwalten
- [x] fehlgeschlagene Missionen verwalten
- [x] Logistikmissionen mit Logistics verbinden
- [x] FOB-Support-Missionen vorbereiten
- [ ] Spielerflugzeug erkennen
- [ ] Missionen nach Flugzeugtyp filtern
- [ ] erste einfache Missionsliste über F10 anzeigen
- [ ] Airbase-Ziele aus Kampagnenzustand verfeinern
- [ ] SEAD/DEAD-Ziele aus IADS-Zustand ableiten
- [ ] Missionserfolg real auswertbar machen
- [ ] Missionsgenerator in DCS testen

---

## Phase 7 — AI Director / CAP Manager

### Geplante Dateien

- [x] `src/ai/tc_ai_cap_manager.lua`
- [ ] `src/ai/tc_ai_director.lua`
- [ ] `src/ai/tc_ai_gci_manager.lua`
- [ ] `src/ai/tc_ai_counterattack.lua`
- [ ] `src/debug/tc_debug_ai_report.lua`

### Aufgaben

- [x] einfache CAP-Logik vorbereiten
- [x] CAP-Zonen registrieren
- [x] CAP-Bedarf aus State-Daten ableiten
- [x] CAP-Anforderungen speichern
- [x] aktive CAPs verwalten
- [x] abgeschlossene CAPs verwalten
- [x] fehlgeschlagene CAPs verwalten
- [x] AI-Reaktionsstatus vorbereiten
- [x] Bedrohungsniveau vorbereiten
- [ ] MOOSE-Anbindung für reale CAP-Spawns vorbereiten
- [ ] einfache GCI-Logik vorbereiten
- [ ] KI-Reaktionen auf Spielerfortschritt vorbereiten
- [ ] KI-Reaktionen auf Capture-Ereignisse vorbereiten
- [ ] KI-Reaktionen auf IADS-Schäden vorbereiten
- [ ] KI-Gegenangriffe vorbereiten
- [ ] AI-System in DCS testen

---

## Phase 8 — IADS-System

### Geplante Dateien

- [x] `src/iads/README.md`
- [ ] `src/iads/tc_iads_network.lua`
- [ ] `src/iads/tc_iads_sector_manager.lua`
- [ ] `src/iads/tc_iads_site_registry.lua`
- [ ] `src/iads/tc_iads_mission_bridge.lua`
- [ ] `src/debug/tc_debug_iads_report.lua`

### Aufgaben

- [x] IADS-Bereich dokumentieren
- [ ] rote IADS-Sektoren vorbereiten
- [ ] SAM-Stellungen als Kampagnenobjekte definieren
- [ ] Radarstellungen als Kampagnenobjekte definieren
- [ ] zerstörte IADS-Objekte kampagnenlogisch speichern
- [ ] Missionsgenerator mit IADS-Zielen verbinden
- [ ] AI Director mit IADS-Zustand verbinden
- [ ] Skynet-IADS-Anbindung kapseln
- [ ] IADS-System in DCS testen

---

## Phase 9 — UI / F10-Menüs

### Geplante Dateien

- [x] `src/ui/README.md`
- [ ] `src/ui/tc_f10_menu.lua`
- [ ] `src/ui/tc_status_display.lua`
- [ ] `src/ui/tc_mission_menu.lua`
- [ ] `src/ui/tc_logistics_menu.lua`
- [ ] `src/ui/tc_debug_menu.lua`

### Aufgaben

- [x] UI-Bereich dokumentieren
- [ ] F10-Menü-Grundstruktur vorbereiten
- [ ] Kampagnenstatus anzeigen
- [ ] verfügbare Missionen anzeigen
- [ ] aktive Missionen anzeigen
- [ ] Logistikstatus anzeigen
- [ ] FOB-Status anzeigen
- [ ] AI-Status anzeigen
- [ ] IADS-Status anzeigen
- [ ] Spielerkommandos vorbereiten
- [ ] Debug-Menü klar getrennt vorbereiten
- [ ] UI in DCS testen

---

## Phase 10 — Debug-System

### Geplante Dateien

- [x] `src/debug/README.md`
- [ ] `src/debug/tc_debug_console.lua`
- [ ] `src/debug/tc_debug_state_dump.lua`
- [ ] `src/debug/tc_debug_zone_overlay.lua`
- [ ] `src/debug/tc_debug_airbase_report.lua`
- [ ] `src/debug/tc_debug_mission_report.lua`
- [ ] `src/debug/tc_debug_logistics_report.lua`
- [ ] `src/debug/tc_debug_ai_report.lua`
- [ ] `src/debug/tc_debug_iads_report.lua`

### Aufgaben

- [x] Debug-Bereich dokumentieren
- [ ] Debug-State vorbereiten
- [ ] State-Dumps vorbereiten
- [ ] Airbase-Reports vorbereiten
- [ ] Zonen-Reports vorbereiten
- [ ] Capture-Reports vorbereiten
- [ ] Logistik-Reports vorbereiten
- [ ] Missions-Reports vorbereiten
- [ ] AI-Reports vorbereiten
- [ ] IADS-Reports vorbereiten
- [ ] Debug deaktivierbar machen
- [ ] Debug in DCS testen

---

## Phase 11 — Persistenz

### Geplante Dateien

- [x] `src/campaign/tc_persistence_system.lua`
- [ ] `save/README.md`
- [ ] `save/example_state.lua`

### Aufgaben

- [x] In-Memory-Persistenz vorbereiten
- [x] State-Snapshot vorbereiten
- [x] State-Export vorbereiten
- [x] State-Import vorbereiten
- [x] Lua-String-Export vorbereiten
- [ ] Speicherstruktur im Repository definieren
- [ ] Beispiel-Save-State erstellen
- [ ] DCS-Dateizugriff gesondert prüfen
- [ ] Kampagnenzustand in Datei serialisieren
- [ ] Kampagnenzustand aus Datei laden
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
- [ ] Framework-Lade-Trigger vorbereiten
- [ ] Source-Lade-Trigger für Starttest-Variante A vorbereiten
- [ ] `src/loader.lua` als letzte eigene Datei laden
- [ ] erster Starttest mit `dcs.log`-Kontrolle durchführen
- [ ] danach Loader-only-Variante mit `dofile` prüfen

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
- [ ] keine produktive Persistenz ohne DCS-Sandbox-Prüfung bauen
- [ ] keine dynamische Großkampagne bauen, bevor der Starttest stabil ist

---

## Nicht gewünschte eigene Lua-Dateien

Diese Dateien sollen nicht erstellt werden:

- [ ] `src/tc_moose.lua`
- [ ] `src/tc_mist.lua`
- [ ] `src/tc_ctld.lua`
- [ ] `src/tc_skynet.lua`
- [ ] `src/tc_all_in_one.lua`
- [ ] `src/tc_iads_all_in_one.lua`
- [ ] `src/core/tc_all_in_one.lua`
- [ ] `src/world/tc_all_in_one.lua`
- [ ] `src/campaign/tc_all_in_one.lua`
- [ ] `src/logistics/tc_all_in_one.lua`
- [ ] `src/missions/tc_all_in_one.lua`
- [ ] `src/ai/tc_all_in_one.lua`

---

## Gewünschte aufgabenorientierte Lua-Dateien

Diese Dateien sind aktuell vorhanden oder perspektivisch erwünscht:

- [x] `src/world/tc_airbase_scanner.lua`
- [x] `src/world/tc_zone_factory.lua`
- [x] `src/campaign/tc_capture_system.lua`
- [x] `src/campaign/tc_persistence_system.lua`
- [x] `src/logistics/tc_logistics_delivery.lua`
- [x] `src/logistics/tc_fob_system.lua`
- [x] `src/missions/tc_mission_generator.lua`
- [x] `src/ai/tc_ai_cap_manager.lua`
- [ ] `src/iads/tc_iads_network.lua`
- [ ] `src/ui/tc_f10_menu.lua`
- [ ] `src/debug/tc_debug_state_dump.lua`

---

## Aktuell nächster sinnvoller Einzelschritt

Als nächster Schritt wird `CHANGELOG.md` aktualisiert, damit die Mission-Editor-Setup-Aktualisierung und die `dofile`-Prüfstrategie dokumentiert sind.

Nächste Datei:

    CHANGELOG.md

Danach:

    DEV-Testvariante A im DCS Mission Editor vorbereiten

Prüffokus für DEV-Testvariante A:

    Frameworks laden
    aktive Source-Dateien einzeln laden
    main.lua laden
    loader.lua zuletzt laden
    dcs.log prüfen
    keine dofile-Abhängigkeit im ersten Test

Grund:

Die Mission-Editor-Dokumentation ist jetzt auf den Source-Ladetest vorbereitet. Das Changelog muss diesen Stand ebenfalls abbilden, bevor praktisch im Mission Editor weitergearbeitet wird.

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
    Dann Logistik.
    Dann Missionen.
    Dann KI.
    Dann IADS.
    Dann UI.
    Dann Debug.
    Dann Starttest.
    Dann DEV-Mission.
    Dann Persistenz vertiefen.
    Dann Testing.
    Dann Release-Struktur.

Aktueller Stand in dieser Reihenfolge:

    Dokumentation: auf Source-Grundstand aktualisiert
    Vendor: abgeschlossen
    src-Struktur: angelegt
    Core: erste Version vorhanden
    Airbases: erste Version vorhanden
    Zonen: erste Version vorhanden
    Capture: erste Version vorhanden
    Logistik: erste Version vorhanden
    Missionen: erste Version vorhanden
    KI: erste CAP-Version vorhanden
    IADS: dokumentiert
    UI: dokumentiert
    Debug: dokumentiert
    Startkette: logisch geprüft
    DCS-Sandbox-Prüfstrategie: dokumentiert
    Starttest: noch offen
