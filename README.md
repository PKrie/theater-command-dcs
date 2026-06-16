# Theater Command DCS

**Theater Command DCS** ist ein modulares, dynamisches und später persistentes DCS-World-Kampagnensystem.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Das Projekt wird auf der **Syria Map** aufgebaut.

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## Grundidee

Theater Command DCS soll keine einzelne statische Mission werden.

Ziel ist ein dynamisches Kampagnensystem, das aus einem zentralen Kampagnenzustand heraus Missionen, Logistik, KI-Reaktionen, Luftverteidigung und Persistenz verwaltet.

Grundprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der DCS Mission Editor stellt die physische Bühne bereit.

Lua übernimmt die eigentliche Kampagnenlogik.

GitHub dokumentiert Struktur, Entscheidungen, Versionen und Aufgabenstand.

---

## Aktueller Projektstand

Stand: 2026-06-16

Aktuell abgeschlossen:

- Repository erstellt
- zentrale Projektdokumentation angelegt
- `docs/`-Grundblock erstellt
- `vendor/`-Grundstruktur erstellt
- MIST importiert
- MOOSE importiert
- CTLD importiert
- Skynet IADS importiert
- MIST auf CTLD-kompatible Version gesetzt
- Vendor-Dokumentation aktualisiert
- zentrale Dokumentation nach Vendor-Abschluss aktualisiert
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
- Mission-Editor-Dokumentation für ersten Source-Test erweitert
- lokale Repository-Kopie auf dem DCS-PC eingerichtet
- minimale Syria-DEV-Mission im DCS Mission Editor erstellt
- erster blauer F/A-18C-Client-Slot auf Akrotiri angelegt
- Framework-Lade-Trigger im Mission Editor angelegt
- Source-Lade-Trigger für Starttest-Variante A im Mission Editor angelegt
- erster realer DCS-Starttest durchgeführt
- `dcs.log` ausgewertet
- Theater-Command-Startkette in DCS erfolgreich bestätigt

Aktuelles Testergebnis:

    Starttest-Variante A bestanden.

Bestätigt wurde:

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

Wichtiger Befund aus dem ersten DCS-Test:

    Airbase-Scanner registrierte 225 Airbase-/Helipad-Objekte.
    Zone-Factory registrierte 225 Zonen.

Bewertung:

    Die technische Startkette funktioniert.
    Die hohe Zahl erkannter Objekte ist kein Startfehler.
    Das aktuelle Syria-Update liefert sehr viele Airbase-ähnliche Objekte.
    Der Airbase-Scanner muss als nächster technischer Schwerpunkt fachlich filtern und klassifizieren.

---

## Aktuelle Projektstruktur

Aktueller Hauptaufbau:

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

## Eigene Lua-Struktur

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

Aktuell vorhandene aktive Lua-Dateien:

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

Aktuell nur dokumentiert, aber noch nicht aktiv implementiert:

    src/iads/
    src/ui/
    src/debug/

---

## Externe Frameworks

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

Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket.

Grund:

CTLD weist darauf hin, dass für korrektes dynamisches Spawning die mit CTLD gelieferte MIST-Version verwendet werden soll.

Frameworks werden nicht verändert.

Eigene Logik wird nicht in Framework-Dateien geschrieben.

---

## DCS-Lade-Reihenfolge

Die externe Framework-Lade-Reihenfolge im DCS Mission Editor lautet:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua

Danach folgt die eigene Theater-Command-Logik.

Für den ersten erfolgreichen DCS-Test wurde die sichere Einzeldatei-Ladung verwendet.

---

## Erfolgreiche Starttest-Variante A

Der erste reale DCS-Test wurde mit folgender Methode durchgeführt:

    Starttest-Variante A — sichere Einzeldatei-Ladung

Dabei wurden zuerst die Frameworks per `DO SCRIPT FILE` geladen.

Danach wurden alle aktiven eigenen Source-Dateien einzeln per `DO SCRIPT FILE` geladen.

Danach wurde `src/main.lua` geladen.

Zuletzt wurde `src/loader.lua` geladen.

Ergebnis:

    Bestanden.

Diese Variante vermeidet im ersten Test eine harte Abhängigkeit von `dofile`.

---

## Getestete Source-Ladereihenfolge

Die getestete Trigger-Reihenfolge im DCS Mission Editor war:

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

## Interne Theater-Command-Ladereihenfolge

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

Aktuell aktiv geladen:

- Core
- World
- Campaign
- Logistics
- Missions
- AI
- Main

Noch nicht aktiv geladen:

- IADS
- UI
- Debug

Grund:

Diese Bereiche besitzen aktuell nur README-Dateien und noch keine aktiven Lua-Module.

---

## Aktuelle DEV-Mission

Aktuelle technische Entwicklungsmission:

    Operation_Levant_Reclamation_DEV.miz

Bisheriger Inhalt:

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

Diese Mission dient aktuell nur als technischer Testträger.

Sie ist noch keine spielbare Kampagnenmission.

---

## Aktuelle Kernsysteme

### Core

Zuständig für:

- zentrale Konfiguration
- Logging
- globalen State
- Hilfsfunktionen
- Scheduler-Grundfunktionen
- Start- und Systeminitialisierung

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
- Airbase-Registrierung
- virtuelle Zonen
- spätere Verknüpfung von Basen, Zonen und Missionen

Aktuelle Dateien:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

Wichtiger aktueller Befund:

    Syria liefert aktuell 225 Airbase-/Helipad-Objekte zurück.

Nächster Schwerpunkt:

    Klassifizierung und Filterung dieser Objekte.

---

### Campaign

Zuständig für:

- Besitzstatus
- Capture-Zustände
- Kampagnenfortschritt
- In-Memory-Persistenz
- State-Snapshots
- spätere Save-/Load-Logik

Aktuelle Dateien:

    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua

---

### Logistics

Zuständig für:

- Lieferungen
- Versorgungsstatus
- FOB-Aufbau
- spätere CTLD-Anbindung
- spätere logistische Auswirkungen auf Basen und Zonen

Aktuelle Dateien:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

---

### Missions

Zuständig für:

- Missionsarten
- Missionsstatus
- dynamische Missionsgenerierung
- spätere F10-Missionsauswahl
- spätere Verknüpfung mit Campaign, Logistics, AI und IADS

Aktuelle Datei:

    src/missions/tc_mission_generator.lua

---

### AI

Zuständig für:

- CAP-Anforderungen
- CAP-Status
- spätere MOOSE-Anbindung
- spätere GCI- und Counterattack-Logik

Aktuelle Datei:

    src/ai/tc_ai_cap_manager.lua

---

### IADS

Zuständig für spätere Theater-Command-Logik über Skynet IADS.

Aktueller Stand:

    Dokumentiert, noch nicht aktiv implementiert.

---

### UI

Zuständig für spätere Spielerinteraktion, Statusanzeigen und F10-Menüs.

Aktueller Stand:

    Dokumentiert, noch nicht aktiv implementiert.

---

### Debug

Zuständig für spätere technische Kontrolle, Reports und Entwicklungswerkzeuge.

Aktueller Stand:

    Dokumentiert, noch nicht aktiv implementiert.

---

## Nächster technischer Schwerpunkt

Der nächste technische Schwerpunkt ist:

    Airbase-Scanner nach dem Syria-Update fachlich filtern

Warum:

Der erste DCS-Test hat gezeigt, dass aktuell 225 Airbase-/Helipad-Objekte erkannt werden.

Diese dürfen nicht ungefiltert als strategische Kampagnenbasen verwendet werden.

Ziel:

- strategische Airfields identifizieren
- Heliports erkennen
- Helipads erkennen
- Medical Pads erkennen
- sonstige taktische Pads erkennen
- Airbase-Scanner um Klassifizierung erweitern
- Zone-Factory an diese Klassifizierung koppeln
- Capture-System nur auf strategische Basen anwenden
- Missionsgenerator nur geeignete Ziele verwenden lassen
- Airbase-Debugreport vorbereiten

---

## Danach geplanter technischer Schritt

Nach der Airbase-Klassifizierung:

    Starttest-Variante B vorbereiten und testen

Ziel:

- Frameworks im Mission Editor laden
- nur `src/loader.lua` im Mission Editor laden
- prüfen, ob `src/loader.lua` die übrigen Source-Dateien per `dofile` nachladen kann
- DCS-Sandbox-Verhalten praktisch bewerten
- spätere Lade- und Deployment-Strategie festlegen

---

## Dokumentation

Wichtige Projektdateien:

| Datei | Zweck |
|---|---|
| `README.md` | Projektübersicht |
| `ROADMAP.md` | Entwicklungsphasen |
| `TASKS.md` | aktueller Aufgabenstand |
| `CHANGELOG.md` | Änderungsverlauf |
| `ARCHITECTURE.md` | technische Architektur |
| `MISSION_EDITOR_SETUP.md` | Mission-Editor-Vorgaben |
| `NAMING_CONVENTIONS.md` | Namensregeln |
| `LUA_STYLEGUIDE.md` | Lua-Stilregeln |

Dokumentationsordner:

    docs/

Mission-Editor-Dokumentation:

    mission_editor/

---

## Arbeitsweise

Es wird immer nur ein sinnvoller Schritt nach dem anderen umgesetzt.

Keine parallelen Großbaustellen.

Neue Dateien werden vollständig vorbereitet.

Eigene Lua-Logik gehört nach:

    src/

Externe Frameworks gehören nach:

    vendor/

Frameworks werden nicht verändert.

Die eigene Lua-Struktur wird nach Aufgaben sortiert, nicht nach Frameworks.

---

## Aktueller Status

Diese Version ist noch keine spielbare dynamische DCS-Kampagne.

Der technische Grundaufbau ist aber erfolgreich im DCS Mission Scripting Environment gestartet.

Der erste reale DCS-Starttest ist bestanden.

Der nächste Entwicklungsschritt ist die fachliche Klassifizierung der durch DCS erkannten Airbase-/Helipad-Objekte.
