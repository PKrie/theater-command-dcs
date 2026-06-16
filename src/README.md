# Source

Dieser Ordner enthält die eigene Lua-Logik von **Theater Command DCS**.

Externe Frameworks liegen nicht in diesem Ordner.

Externe Frameworks liegen unter:

    vendor/

Eigene Theater-Command-Logik liegt unter:

    src/

---

## Projekt

Projektname:

    Theater Command DCS

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## Grundprinzip

Das zentrale Arbeitsprinzip lautet:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der DCS Mission Editor stellt die physische Umgebung bereit.

Lua übernimmt die eigentliche Kampagnenlogik.

GitHub dokumentiert Struktur, Entscheidungen, Versionen, Aufgabenstand und Testergebnisse.

---

## Architekturregel

Die eigene Lua-Struktur wird nach Aufgaben sortiert, nicht nach Frameworks.

Nicht gewünscht sind eigene Sammeldateien wie:

    src/tc_moose.lua
    src/tc_mist.lua
    src/tc_ctld.lua
    src/tc_skynet.lua
    src/tc_all_in_one.lua
    src/tc_iads_all_in_one.lua

Gewünscht ist eine fachliche Modulstruktur nach Aufgabenbereichen.

---

## Aktueller technischer Stand

Stand: 2026-06-16

Aktuell vorhanden:

- `src/loader.lua`
- `src/main.lua`
- Core-System
- World-System
- Campaign-System
- Logistics-System
- Missions-System
- AI-CAP-System
- IADS-Bereich dokumentiert
- UI-Bereich dokumentiert
- Debug-Bereich dokumentiert

Der erste reale DCS-Starttest wurde durchgeführt.

Test:

    Starttest-Variante A — sichere Einzeldatei-Ladung

Ergebnis:

    Bestanden

Bestätigt wurde:

- externe Frameworks werden geladen
- externe Frameworks werden durch Theater Command erkannt
- aktive eigene Source-Dateien werden geladen
- `src/main.lua` wird geladen
- `src/loader.lua` wird zuletzt geladen
- Loader startet
- Main startet
- Runtime-Systeme werden initialisiert
- Airbase-Scanner läuft
- Zone-Factory läuft
- Loader beendet sauber

Wichtiger Befund:

    Airbase-Scanner registrierte 225 Airbase-/Helipad-Objekte.
    Zone-Factory registrierte 225 Zonen.

Bewertung:

    Die Source-Grundstruktur ist im DCS Mission Scripting Environment lauffähig.
    Die hohe Zahl erkannter Airbase-/Helipad-Objekte ist kein Startfehler.
    Der nächste technische Schwerpunkt ist die fachliche Klassifizierung und Filterung dieser Objekte.

---

## Aktuelle Source-Struktur

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

---

## Aktive Lua-Dateien

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

## Externe Frameworks

Externe Frameworks werden aus `vendor/` geladen.

Aktuelle Framework-Basis:

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Frameworks werden nicht verändert.

Eigene Logik wird nicht in Framework-Dateien geschrieben.

---

## DCS-Lade-Reihenfolge

Die externe Framework-Lade-Reihenfolge lautet:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua

Danach folgt die eigene Theater-Command-Logik.

---

## Erfolgreich getestete Source-Ladung

Der erste erfolgreiche DCS-Test nutzte:

    Starttest-Variante A — sichere Einzeldatei-Ladung

Dabei wurden alle aktiven Dateien einzeln per `DO SCRIPT FILE` im Mission Editor geladen.

Reihenfolge:

    Frameworks
    Core
    World
    Campaign
    Logistics
    Missions
    AI
    Main
    Loader

Wichtig:

    src/main.lua wurde vor src/loader.lua geladen.
    src/loader.lua wurde als letzte eigene Datei geladen.

Grund:

    main.lua definiert TC.Main.
    loader.lua prüft danach Frameworks und startet Main.

---

## `src/loader.lua`

`src/loader.lua` ist der zentrale technische Einstiegspunkt von Theater Command DCS.

Aufgaben:

- globale Theater-Command-Struktur prüfen
- Framework-Verfügbarkeit prüfen
- aktive Source-Module prüfen
- Main-Initialisierung starten
- Startstatus protokollieren
- Fehler sichtbar machen

Aktueller Teststatus:

    In Starttest-Variante A erfolgreich in DCS gestartet.

Wichtig:

    Loader-only mit dofile ist noch nicht getestet.

---

## `src/main.lua`

`src/main.lua` ist die zentrale Main-Initialisierung.

Aufgaben:

- Runtime-Systeme prüfen
- erforderliche Systeme starten
- optionale Systeme überspringen, wenn noch nicht vorhanden
- Startstatus protokollieren
- Runtime-Systeme geordnet initialisieren

Aktuell erforderliche Runtime-Systeme:

- Core
- World
- Campaign
- Logistics
- Missions
- AI

Aktuell optionale spätere Systeme:

- IADS
- UI
- Debug

Aktueller Teststatus:

    In Starttest-Variante A erfolgreich in DCS gestartet.

---

## Core

Pfad:

    src/core/

Aktuelle Dateien:

    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
    src/core/tc_utils.lua
    src/core/tc_scheduler.lua

Aufgaben:

- Konfiguration
- Logging
- globaler State
- Hilfsfunktionen
- Scheduler-Grundfunktionen

Teststatus:

    Core wurde im ersten DCS-Starttest erfolgreich geladen.

---

## World

Pfad:

    src/world/

Aktuelle Dateien:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

Aufgaben:

- DCS-Airbases erkennen
- Airbase-Daten vorbereiten
- Koalitionsstatus erfassen
- virtuelle Zonen vorbereiten
- Airbase-Daten für Campaign, Logistics, Missions und AI bereitstellen

Teststatus:

    World wurde im ersten DCS-Starttest erfolgreich geladen.
    Airbase-Scanner registrierte 225 Airbase-/Helipad-Objekte.
    Zone-Factory registrierte 225 Zonen.

Nächster Schwerpunkt:

    Airbase-Klassifizierung und Filterung.

---

## Campaign

Pfad:

    src/campaign/

Aktuelle Dateien:

    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua

Aufgaben:

- Besitzstatus vorbereiten
- Capture-Zustände vorbereiten
- Capture-Events vorbereiten
- In-Memory-Persistenz vorbereiten
- State-Snapshots vorbereiten

Teststatus:

    Campaign wurde im ersten DCS-Starttest erfolgreich geladen.

Wichtig:

    Capture darf später nur auf geeignete strategische Kampagnenbasen angewendet werden.

---

## Logistics

Pfad:

    src/logistics/

Aktuelle Dateien:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

Aufgaben:

- Lieferungen vorbereiten
- Lieferstatus verwalten
- FOB-Zustände vorbereiten
- spätere CTLD-Anbindung vorbereiten

Teststatus:

    Logistics wurde im ersten DCS-Starttest erfolgreich geladen.

---

## Missions

Pfad:

    src/missions/

Aktuelle Datei:

    src/missions/tc_mission_generator.lua

Aufgaben:

- Missionsarten vorbereiten
- Missionsstatus vorbereiten
- Missionen im State verwalten
- spätere dynamische Missionsgenerierung vorbereiten

Teststatus:

    Missions wurde im ersten DCS-Starttest erfolgreich geladen.

Wichtig:

    Missions dürfen später nicht ungefiltert alle 225 Airbase-/Helipad-Objekte als Ziele verwenden.

---

## AI

Pfad:

    src/ai/

Aktuelle Datei:

    src/ai/tc_ai_cap_manager.lua

Aufgaben:

- CAP-Anforderungen vorbereiten
- CAP-Zonen vorbereiten
- aktive CAPs verwalten
- spätere MOOSE-Anbindung vorbereiten

Teststatus:

    AI wurde im ersten DCS-Starttest erfolgreich geladen.

---

## IADS

Pfad:

    src/iads/

Aktueller Stand:

    Dokumentiert, noch nicht aktiv implementiert.

Geplante Dateien:

    src/iads/tc_iads_network.lua
    src/iads/tc_iads_sector_manager.lua
    src/iads/tc_iads_site_registry.lua
    src/iads/tc_iads_mission_bridge.lua

Framework:

    vendor/skynet-iads/SkynetIADS.lua

Skynet IADS wurde im ersten Starttest erfolgreich geladen.

Die Theater-Command-IADS-Schicht ist noch offen.

---

## UI

Pfad:

    src/ui/

Aktueller Stand:

    Dokumentiert, noch nicht aktiv implementiert.

Geplante Dateien:

    src/ui/tc_f10_menu.lua
    src/ui/tc_status_display.lua
    src/ui/tc_mission_menu.lua
    src/ui/tc_logistics_menu.lua
    src/ui/tc_debug_menu.lua

---

## Debug

Pfad:

    src/debug/

Aktueller Stand:

    Dokumentiert, noch nicht aktiv implementiert.

Geplante Dateien:

    src/debug/tc_debug_console.lua
    src/debug/tc_debug_state_dump.lua
    src/debug/tc_debug_zone_overlay.lua
    src/debug/tc_debug_airbase_report.lua
    src/debug/tc_debug_mission_report.lua
    src/debug/tc_debug_logistics_report.lua
    src/debug/tc_debug_ai_report.lua
    src/debug/tc_debug_iads_report.lua

Nächster sinnvoller Debug-Schritt:

    Airbase-Debugreport nach Airbase-Klassifizierung.

---

## Airbase-Klassifizierung als nächster Code-Schritt

Der nächste technische Schritt betrifft:

    src/world/tc_airbase_scanner.lua

Warum:

DCS liefert auf der aktuellen Syria Map 225 Airbase-/Helipad-Objekte.

Diese dürfen nicht ungefiltert als strategische Kampagnenbasen verwendet werden.

Geplante Klassen:

    STRATEGIC_AIRFIELD
    SECONDARY_AIRFIELD
    HELIPORT
    HELIPAD
    MEDICAL_PAD
    FARP
    TACTICAL_PAD
    UNKNOWN

Ziel:

- Airbase-Kategorien einführen
- Klassifizierungsfunktion ergänzen
- strategische Relevanz berechnen
- getrennte Listen speichern
- Summary-Logausgabe erzeugen
- ZoneFactory später darauf vorbereiten

---

## Loader-only-Test

Noch nicht getestet:

    Starttest-Variante B — Loader-only mit dofile

Ziel:

- Frameworks im Mission Editor laden
- nur `src/loader.lua` im Mission Editor laden
- prüfen, ob der Loader die restlichen Source-Dateien per `dofile` nachladen kann
- DCS-Sandbox-Verhalten bewerten
- spätere Lade- und Deployment-Strategie festlegen

Dieser Test wird später separat vorbereitet.

---

## Nicht-Ziele im aktuellen Stand

Aktuell wird bewusst nicht umgesetzt:

- keine vollständige Kampagnenlogik
- keine vollständige Airbase-Balance
- keine roten IADS-Systeme
- keine CTLD-Anbindung
- keine F10-Menüs
- keine Debug-Menüs
- keine produktive Persistenz
- keine automatische `.miz`-Generierung
- keine Multiplayer-Synchronisation
- keine All-in-one-Datei
- keine Framework-Änderungen

---

## Aktueller Status

Die Source-Grundstruktur ist angelegt.

Die erste aktive Source-Kette wurde erfolgreich im DCS Mission Scripting Environment getestet.

Der nächste technische Schritt ist die Airbase-Klassifizierung in:

    src/world/tc_airbase_scanner.lua
