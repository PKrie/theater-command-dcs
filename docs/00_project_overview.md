# Project Overview

Diese Datei gibt eine Gesamtübersicht über das Projekt **Theater Command DCS**.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut.

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## Projektidee

**Theater Command DCS** soll ein modulares, dynamisches und später persistentes Kampagnensystem für DCS World werden.

Es soll keine einzelne statische Mission entstehen.

Ziel ist ein Kampagnensystem, das aus einem zentralen Zustand heraus folgende Bereiche steuert:

- Airbase-Erkennung
- strategische Airbase-Klassifizierung
- virtuelle Zonen
- Capture-System
- Logistiksystem
- CTLD-Anbindung
- FOB-Aufbau
- dynamische Missionsgenerierung
- AI-Reaktionen
- CAP- und GCI-Management
- Skynet-IADS-Anbindung
- F10-Menüs
- Debug-Werkzeuge
- Persistenz

---

## Grundprinzip

Das zentrale Arbeitsprinzip lautet:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der DCS Mission Editor stellt die physische Umgebung bereit.

Lua übernimmt die dynamische Kampagnenlogik.

GitHub dokumentiert Struktur, Entscheidungen, Versionen, Aufgabenstand und Testergebnisse.

---

## Aktueller Projektstand

Stand: 2026-06-16

Aktuell abgeschlossen:

- Repository erstellt
- zentrale Projektdokumentation angelegt
- `docs/`-Grundblock erstellt
- `mission_editor/`-Dokumentation angelegt
- `vendor/`-Frameworkstruktur erstellt
- MIST importiert
- MOOSE importiert
- CTLD importiert
- Skynet IADS importiert
- MIST auf CTLD-kompatible Version gesetzt
- Vendor-Dokumentation aktualisiert
- `src/`-Grundstruktur angelegt
- erste eigene Lua-Module erstellt
- Core-System angelegt
- World-System angelegt
- Campaign-System angelegt
- Logistics-System angelegt
- Missions-System angelegt
- AI-CAP-System angelegt
- IADS-, UI- und Debug-Bereiche dokumentiert
- Loader erstellt
- Main-Initialisierung erstellt
- lokale Repository-Kopie auf dem DCS-PC eingerichtet
- minimale Syria-DEV-Mission im DCS Mission Editor erstellt
- erster blauer F/A-18C-Client-Slot auf Akrotiri angelegt
- Framework-Lade-Trigger im Mission Editor angelegt
- Source-Lade-Trigger für Starttest-Variante A im Mission Editor angelegt
- erster realer DCS-Starttest durchgeführt
- `dcs.log` ausgewertet
- Theater-Command-Startkette in DCS erfolgreich bestätigt

Aktueller Teststatus:

    Starttest-Variante A bestanden.

---

## Aktueller technischer Befund

Der erste reale DCS-Test hat bestätigt:

- MIST wird geladen
- MOOSE wird geladen
- CTLD-i18n wird geladen
- CTLD wird geladen
- Skynet IADS wird geladen
- Theater Command Loader startet
- Frameworks werden durch den Loader erkannt
- Core wird geladen
- World wird geladen
- Campaign wird geladen
- Logistics wird geladen
- Missions wird geladen
- AI wird geladen
- Main wird gestartet
- Runtime-Systeme werden initialisiert
- Airbase-Scanner läuft
- Zone-Factory läuft
- Loader beendet sauber

Wichtiger World-Befund:

    Airbase-Scanner registrierte 225 Airbase-/Helipad-Objekte.
    Zone-Factory registrierte 225 Zonen.

Bewertung:

    Die technische Startkette funktioniert.
    Die hohe Zahl erkannter Objekte ist kein Startfehler.
    Das aktuelle Syria-Update liefert sehr viele Airbase-ähnliche Objekte.
    Der nächste technische Schwerpunkt ist die fachliche Klassifizierung und Filterung dieser Objekte.

---

## Aktuelle DEV-Mission

Aktuelle technische Entwicklungsmission:

    Operation_Levant_Reclamation_DEV.miz

Aktueller Inhalt:

    Map: Syria
    Koalitionspreset: Modern
    Blue Start: Akrotiri / Zypern
    erster blauer Client-Slot: F/A-18C Lot 20 auf Akrotiri
    Trigger: Starttest-Variante A vollständig angelegt
    keine rote Frontlinie
    keine IADS-Stellungen
    keine CTLD-Zonen
    keine Template-Gruppen
    keine F10-Menüs

Diese Mission ist aktuell nur ein technischer Testträger.

Sie ist noch keine spielbare Kampagnenmission.

---

## Hauptstruktur

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

## Dokumentationsstruktur

Der Ordner `docs/` enthält die fachliche und technische Projektdokumentation.

Aktuelle Dateien:

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

Aktuell bereits nach dem ersten DCS-Starttest aktualisiert:

    docs/03_mission_editor_basics.md
    docs/04_airbase_system.md
    docs/10_testing.md

Diese Datei dokumentiert die Gesamtübersicht und den aktuellen Projektstand.

---

## Mission-Editor-Dokumentation

Der Ordner `mission_editor/` dokumentiert Arbeiten, die direkt im DCS Mission Editor vorbereitet werden müssen.

Aktuelle Dateien:

    mission_editor/README.md
    mission_editor/trigger_setup.md

Aktueller Status:

    Starttest-Variante A ist dokumentiert und erfolgreich getestet.

---

## Source-Struktur

Eigene Theater-Command-Logik liegt unter:

    src/

Aktuelle Source-Struktur:

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

---

## Aktive Source-Module

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

Aktuell nur dokumentiert:

    src/iads/
    src/ui/
    src/debug/

Diese Bereiche besitzen aktuell README-Dateien, aber noch keine aktiven Lua-Module.

---

## Framework-Basis

Externe Frameworks liegen unter:

    vendor/

Aktuelle Framework-Basis:

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Wichtig:

Frameworks werden nicht verändert.

Eigene Logik wird nicht in Framework-Dateien geschrieben.

Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket.

---

## Externe DCS-Lade-Reihenfolge

Die Frameworks werden im DCS Mission Editor in dieser Reihenfolge geladen:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua

Danach folgt die eigene Theater-Command-Logik.

---

## Erfolgreiche Starttest-Variante A

Der erste reale DCS-Test wurde mit folgender Methode durchgeführt:

    Starttest-Variante A — sichere Einzeldatei-Ladung

Dabei wurden zuerst alle Frameworks geladen.

Danach wurden alle aktiven eigenen Source-Dateien einzeln per `DO SCRIPT FILE` geladen.

Danach wurde geladen:

    src/main.lua

Zuletzt wurde geladen:

    src/loader.lua

Ergebnis:

    Bestanden.

Diese Variante vermeidet im ersten Test eine harte Abhängigkeit von `dofile`.

---

## Noch offener Loader-only-Test

Noch nicht getestet:

    Starttest-Variante B — Loader-only mit dofile

Ziel:

- Frameworks im Mission Editor laden
- nur `src/loader.lua` im Mission Editor laden
- prüfen, ob `src/loader.lua` die übrigen Source-Dateien per `dofile` nachladen kann
- DCS-Sandbox-Verhalten praktisch bewerten
- spätere Lade- und Deployment-Strategie festlegen

Diese Variante wird erst nach der Airbase-Klassifizierung oder als gezielter separater Test vorbereitet.

---

## Aktuelle Kernsysteme

### Core

Zuständig für:

- Konfiguration
- Logging
- globalen State
- Hilfsfunktionen
- Scheduler-Grundfunktionen

Aktuelle Dateien:

    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
    src/core/tc_utils.lua
    src/core/tc_scheduler.lua

---

### World

Zuständig für:

- DCS-Airbase-Erfassung
- Airbase-Daten
- virtuelle Zonen
- spätere Airbase-Klassifizierung

Aktuelle Dateien:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

Aktueller Schwerpunkt:

    Airbase-Klassifizierung nach dem Syria-Update.

---

### Campaign

Zuständig für:

- Besitzstatus
- Capture-Zustände
- Kampagnenzustand
- In-Memory-Persistenz

Aktuelle Dateien:

    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua

---

### Logistics

Zuständig für:

- Lieferungen
- Versorgung
- FOB-Aufbau
- spätere CTLD-Anbindung

Aktuelle Dateien:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

---

### Missions

Zuständig für:

- Missionsarten
- Missionsstatus
- dynamische Missionsgenerierung

Aktuelle Datei:

    src/missions/tc_mission_generator.lua

---

### AI

Zuständig für:

- CAP-Anforderungen
- CAP-Zonen
- spätere MOOSE-Anbindung
- spätere AI-Reaktionen

Aktuelle Datei:

    src/ai/tc_ai_cap_manager.lua

---

### IADS

Zuständig für spätere Theater-Command-Logik über Skynet IADS.

Aktueller Stand:

    Dokumentiert, noch nicht aktiv implementiert.

---

### UI

Zuständig für spätere F10-Menüs und Spielerinteraktion.

Aktueller Stand:

    Dokumentiert, noch nicht aktiv implementiert.

---

### Debug

Zuständig für spätere technische Prüfberichte und Debug-Werkzeuge.

Aktueller Stand:

    Dokumentiert, noch nicht aktiv implementiert.

---

## Wichtigster aktueller Befund

Der Airbase-Scanner erkennt aktuell:

    225 Airbase-/Helipad-Objekte

Das ist für DCS/Syria technisch plausibel, aber kampagnenlogisch zu breit.

Diese Objekte müssen künftig unterschieden werden in:

- strategische Airfields
- Secondary Airfields
- Heliports
- Helipads
- Medical Pads
- FARPs
- Tactical Pads
- Unknown

Erst nach dieser Klassifizierung dürfen Capture-System, Missionsgenerator, Logistics und AI produktiv mit Airbase-Daten arbeiten.

---

## Nächster technischer Schwerpunkt

Der nächste technische Schwerpunkt ist:

    src/world/tc_airbase_scanner.lua erweitern

Ziel:

- Airbase-Kategorien einführen
- Airbase-Klassifizierung ergänzen
- strategische Relevanz berechnen
- getrennte Listen speichern
- Summary-Logausgabe erzeugen
- ZoneFactory später darauf vorbereiten

Nicht als nächstes:

- keine rote Frontlinie
- keine IADS-Großstruktur
- keine CTLD-Zonen
- keine F10-Menüs
- keine produktive Persistenz
- keine weitere große Mission-Editor-Struktur

---

## Arbeitsweise

Es wird immer nur ein sinnvoller Schritt nach dem anderen umgesetzt.

Keine parallelen Großbaustellen.

Neue Dateien werden vollständig vorbereitet.

Eigene Theater-Command-Logik gehört nach:

    src/

Externe Frameworks gehören nach:

    vendor/

Frameworks werden nicht verändert.

Die eigene Lua-Struktur wird nach Aufgaben sortiert, nicht nach Frameworks.

---

## Aktueller Status

Theater Command DCS ist noch keine spielbare dynamische Kampagne.

Der technische Grundaufbau ist jedoch erfolgreich im DCS Mission Scripting Environment gestartet.

Der erste reale DCS-Starttest ist bestanden.

Die nächste Entwicklungsarbeit betrifft die fachliche Airbase-Klassifizierung im World-System.
