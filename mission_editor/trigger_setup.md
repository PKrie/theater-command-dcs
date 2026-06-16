# Trigger Setup

Diese Datei beschreibt die konkrete Trigger-Struktur für den ersten Mission-Editor-Starttest von **Theater Command DCS**.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die erste technische Entwicklungsmission heißt:

    Operation_Levant_Reclamation_DEV.miz

---

## Zweck dieser Datei

Diese Datei legt fest, welche Trigger im DCS Mission Editor für den ersten technischen Starttest angelegt werden.

Der Fokus liegt ausschließlich auf:

- Framework-Ladung
- Source-Ladung
- Loader-Start
- Main-Start
- `dcs.log`-Kontrolle

Es wird noch keine spielbare Kampagne gebaut.

Es wird noch keine vollständige Frontlinie gebaut.

Es wird noch keine IADS-Struktur gebaut.

Es wird noch keine CTLD-Logistik getestet.

---

## Grundprinzip

Für den ersten realen DCS-Test wird die sichere Einzeldatei-Ladung genutzt.

Name:

    Starttest-Variante A

Grund:

`src/loader.lua` kann grundsätzlich Dateien per `dofile` nachladen.

Im ersten praktischen DCS-Test wird aber nicht vorausgesetzt, dass `dofile` im DCS Mission Scripting Environment zuverlässig mit Projektpfaden funktioniert.

Deshalb werden zuerst alle aktiven Source-Dateien einzeln per Mission Editor geladen.

Danach wird `src/loader.lua` zuletzt geladen.

Ziel:

    keine harte dofile-Abhängigkeit im ersten Test
    Frameworks laden
    aktive Source-Dateien laden
    main.lua verfügbar machen
    loader.lua zuletzt starten
    dcs.log prüfen

---

## Trigger-Typ

Für den ersten Test werden einfache zeitversetzte Trigger genutzt.

Empfohlener Trigger-Typ:

    ONCE

Empfohlene Bedingung:

    TIME MORE

Empfohlene Aktion:

    DO SCRIPT FILE

Keine komplexen Bedingungen.

Keine Flags.

Keine Randomisierung.

Keine Wiederholtrigger.

---

## Allgemeine Trigger-Regeln

Für jeden Lua-Ladeschritt wird ein eigener Trigger angelegt.

Jeder Trigger hat:

- eindeutigen Namen
- eine `TIME MORE`-Bedingung
- genau eine `DO SCRIPT FILE`-Aktion
- keine zusätzliche Logik

Die Trigger werden zeitlich versetzt, damit Fehler im `dcs.log` leichter einer Datei zugeordnet werden können.

---

## Trigger-Namensschema

Trigger für Theater Command DCS beginnen mit:

    TC_LOAD_

Beispiele:

    TC_LOAD_MIST
    TC_LOAD_MOOSE
    TC_LOAD_TC_CONFIG
    TC_LOAD_TC_LOADER

Das Namensschema soll klar lesbar sein.

Nicht verwenden:

    Trigger 1
    Load Script
    Script Test
    Lua Start
    Test Trigger

---

## Starttest-Variante A — Gesamtreihenfolge

Die erste sichere Ladevariante lautet:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua
    6. src/core/tc_config.lua
    7. src/core/tc_logger.lua
    8. src/core/tc_state.lua
    9. src/core/tc_utils.lua
    10. src/core/tc_scheduler.lua
    11. src/world/tc_airbase_scanner.lua
    12. src/world/tc_zone_factory.lua
    13. src/campaign/tc_capture_system.lua
    14. src/campaign/tc_persistence_system.lua
    15. src/logistics/tc_logistics_delivery.lua
    16. src/logistics/tc_fob_system.lua
    17. src/missions/tc_mission_generator.lua
    18. src/ai/tc_ai_cap_manager.lua
    19. src/main.lua
    20. src/loader.lua

Wichtig:

`src/loader.lua` wird in dieser Testvariante bewusst zuletzt geladen.

---

## Trigger-Liste für Starttest-Variante A

### 1. MIST laden

Trigger-Name:

    TC_LOAD_MIST

Typ:

    ONCE

Bedingung:

    TIME MORE 1

Aktion:

    DO SCRIPT FILE

Datei:

    vendor/mist/mist.lua

Zweck:

    MIST als technische Grundlage laden.

---

### 2. MOOSE laden

Trigger-Name:

    TC_LOAD_MOOSE

Typ:

    ONCE

Bedingung:

    TIME MORE 2

Aktion:

    DO SCRIPT FILE

Datei:

    vendor/moose/Moose.lua

Zweck:

    MOOSE als objektorientierte DCS-Framework-Schicht laden.

---

### 3. CTLD-i18n laden

Trigger-Name:

    TC_LOAD_CTLD_I18N

Typ:

    ONCE

Bedingung:

    TIME MORE 3

Aktion:

    DO SCRIPT FILE

Datei:

    vendor/ctld/CTLD-i18n.lua

Zweck:

    CTLD-Sprachdatei vor CTLD laden.

---

### 4. CTLD laden

Trigger-Name:

    TC_LOAD_CTLD

Typ:

    ONCE

Bedingung:

    TIME MORE 4

Aktion:

    DO SCRIPT FILE

Datei:

    vendor/ctld/CTLD.lua

Zweck:

    CTLD als Logistik-Framework laden.

---

### 5. Skynet IADS laden

Trigger-Name:

    TC_LOAD_SKYNET_IADS

Typ:

    ONCE

Bedingung:

    TIME MORE 5

Aktion:

    DO SCRIPT FILE

Datei:

    vendor/skynet-iads/SkynetIADS.lua

Zweck:

    Skynet IADS als spätere IADS-Grundlage laden.

---

### 6. Core Config laden

Trigger-Name:

    TC_LOAD_TC_CONFIG

Typ:

    ONCE

Bedingung:

    TIME MORE 7

Aktion:

    DO SCRIPT FILE

Datei:

    src/core/tc_config.lua

Zweck:

    zentrale Theater-Command-Konfiguration laden.

---

### 7. Core Logger laden

Trigger-Name:

    TC_LOAD_TC_LOGGER

Typ:

    ONCE

Bedingung:

    TIME MORE 8

Aktion:

    DO SCRIPT FILE

Datei:

    src/core/tc_logger.lua

Zweck:

    Logging für Theater Command DCS laden.

---

### 8. Core State laden

Trigger-Name:

    TC_LOAD_TC_STATE

Typ:

    ONCE

Bedingung:

    TIME MORE 9

Aktion:

    DO SCRIPT FILE

Datei:

    src/core/tc_state.lua

Zweck:

    zentralen Theater-Command-State laden.

---

### 9. Core Utils laden

Trigger-Name:

    TC_LOAD_TC_UTILS

Typ:

    ONCE

Bedingung:

    TIME MORE 10

Aktion:

    DO SCRIPT FILE

Datei:

    src/core/tc_utils.lua

Zweck:

    Utility-Funktionen laden.

---

### 10. Core Scheduler laden

Trigger-Name:

    TC_LOAD_TC_SCHEDULER

Typ:

    ONCE

Bedingung:

    TIME MORE 11

Aktion:

    DO SCRIPT FILE

Datei:

    src/core/tc_scheduler.lua

Zweck:

    Scheduler-Grundfunktionen laden.

---

### 11. Airbase Scanner laden

Trigger-Name:

    TC_LOAD_TC_AIRBASE_SCANNER

Typ:

    ONCE

Bedingung:

    TIME MORE 12

Aktion:

    DO SCRIPT FILE

Datei:

    src/world/tc_airbase_scanner.lua

Zweck:

    Airbase-Scanner laden.

---

### 12. Zone Factory laden

Trigger-Name:

    TC_LOAD_TC_ZONE_FACTORY

Typ:

    ONCE

Bedingung:

    TIME MORE 13

Aktion:

    DO SCRIPT FILE

Datei:

    src/world/tc_zone_factory.lua

Zweck:

    Zone-Factory laden.

---

### 13. Capture System laden

Trigger-Name:

    TC_LOAD_TC_CAPTURE_SYSTEM

Typ:

    ONCE

Bedingung:

    TIME MORE 14

Aktion:

    DO SCRIPT FILE

Datei:

    src/campaign/tc_capture_system.lua

Zweck:

    strategisches Capture-System laden.

---

### 14. Persistence System laden

Trigger-Name:

    TC_LOAD_TC_PERSISTENCE_SYSTEM

Typ:

    ONCE

Bedingung:

    TIME MORE 15

Aktion:

    DO SCRIPT FILE

Datei:

    src/campaign/tc_persistence_system.lua

Zweck:

    In-Memory-Persistenzsystem laden.

---

### 15. Logistics Delivery laden

Trigger-Name:

    TC_LOAD_TC_LOGISTICS_DELIVERY

Typ:

    ONCE

Bedingung:

    TIME MORE 16

Aktion:

    DO SCRIPT FILE

Datei:

    src/logistics/tc_logistics_delivery.lua

Zweck:

    Logistiklieferungssystem laden.

---

### 16. FOB System laden

Trigger-Name:

    TC_LOAD_TC_FOB_SYSTEM

Typ:

    ONCE

Bedingung:

    TIME MORE 17

Aktion:

    DO SCRIPT FILE

Datei:

    src/logistics/tc_fob_system.lua

Zweck:

    FOB-System laden.

---

### 17. Mission Generator laden

Trigger-Name:

    TC_LOAD_TC_MISSION_GENERATOR

Typ:

    ONCE

Bedingung:

    TIME MORE 18

Aktion:

    DO SCRIPT FILE

Datei:

    src/missions/tc_mission_generator.lua

Zweck:

    Missionsgenerator laden.

---

### 18. AI CAP Manager laden

Trigger-Name:

    TC_LOAD_TC_AI_CAP_MANAGER

Typ:

    ONCE

Bedingung:

    TIME MORE 19

Aktion:

    DO SCRIPT FILE

Datei:

    src/ai/tc_ai_cap_manager.lua

Zweck:

    AI-CAP-Manager laden.

---

### 19. Main laden

Trigger-Name:

    TC_LOAD_TC_MAIN

Typ:

    ONCE

Bedingung:

    TIME MORE 20

Aktion:

    DO SCRIPT FILE

Datei:

    src/main.lua

Zweck:

    Main-Initialisierung verfügbar machen.

Wichtig:

`src/main.lua` soll durch das Laden noch nicht selbst starten.

Der Start erfolgt später durch `src/loader.lua`.

---

### 20. Loader laden

Trigger-Name:

    TC_LOAD_TC_LOADER

Typ:

    ONCE

Bedingung:

    TIME MORE 22

Aktion:

    DO SCRIPT FILE

Datei:

    src/loader.lua

Zweck:

    Theater-Command-Loader starten.

Der Loader soll:

- Frameworks prüfen
- bereits geladene Module erkennen
- Main starten
- Startstatus protokollieren
- Fehler sichtbar machen

---

## Kompakte Übersicht als Tabelle

| Reihenfolge | Trigger | TIME MORE | Datei |
|---|---|---:|---|
| 1 | `TC_LOAD_MIST` | 1 | `vendor/mist/mist.lua` |
| 2 | `TC_LOAD_MOOSE` | 2 | `vendor/moose/Moose.lua` |
| 3 | `TC_LOAD_CTLD_I18N` | 3 | `vendor/ctld/CTLD-i18n.lua` |
| 4 | `TC_LOAD_CTLD` | 4 | `vendor/ctld/CTLD.lua` |
| 5 | `TC_LOAD_SKYNET_IADS` | 5 | `vendor/skynet-iads/SkynetIADS.lua` |
| 6 | `TC_LOAD_TC_CONFIG` | 7 | `src/core/tc_config.lua` |
| 7 | `TC_LOAD_TC_LOGGER` | 8 | `src/core/tc_logger.lua` |
| 8 | `TC_LOAD_TC_STATE` | 9 | `src/core/tc_state.lua` |
| 9 | `TC_LOAD_TC_UTILS` | 10 | `src/core/tc_utils.lua` |
| 10 | `TC_LOAD_TC_SCHEDULER` | 11 | `src/core/tc_scheduler.lua` |
| 11 | `TC_LOAD_TC_AIRBASE_SCANNER` | 12 | `src/world/tc_airbase_scanner.lua` |
| 12 | `TC_LOAD_TC_ZONE_FACTORY` | 13 | `src/world/tc_zone_factory.lua` |
| 13 | `TC_LOAD_TC_CAPTURE_SYSTEM` | 14 | `src/campaign/tc_capture_system.lua` |
| 14 | `TC_LOAD_TC_PERSISTENCE_SYSTEM` | 15 | `src/campaign/tc_persistence_system.lua` |
| 15 | `TC_LOAD_TC_LOGISTICS_DELIVERY` | 16 | `src/logistics/tc_logistics_delivery.lua` |
| 16 | `TC_LOAD_TC_FOB_SYSTEM` | 17 | `src/logistics/tc_fob_system.lua` |
| 17 | `TC_LOAD_TC_MISSION_GENERATOR` | 18 | `src/missions/tc_mission_generator.lua` |
| 18 | `TC_LOAD_TC_AI_CAP_MANAGER` | 19 | `src/ai/tc_ai_cap_manager.lua` |
| 19 | `TC_LOAD_TC_MAIN` | 20 | `src/main.lua` |
| 20 | `TC_LOAD_TC_LOADER` | 22 | `src/loader.lua` |

---

## Erwartete erfolgreiche Startkette

Bei erfolgreichem Test soll die Startkette logisch so ablaufen:

    MIST lädt
    MOOSE lädt
    CTLD-i18n lädt
    CTLD lädt
    Skynet IADS lädt
    Core-Dateien laden
    World-Dateien laden
    Campaign-Dateien laden
    Logistics-Dateien laden
    Missions-Dateien laden
    AI-Dateien laden
    main.lua lädt
    loader.lua lädt
    loader.lua prüft Frameworks
    loader.lua erkennt geladene Module
    loader.lua startet main.lua
    main.lua startet Runtime-Systeme
    dcs.log zeigt keine schweren Lua-Fehler

---

## Erwartete Pflichtmodule

Der erste Test erwartet diese Theater-Command-Module als Pflichtmodule:

- `TC.Config`
- `TC.Logger`
- `TC.State`
- `TC.Utils`
- `TC.Scheduler`
- `TC.World.AirbaseScanner`
- `TC.World.ZoneFactory`
- `TC.Campaign.CaptureSystem`
- `TC.Campaign.PersistenceSystem`
- `TC.Logistics.Delivery`
- `TC.Logistics.FobSystem`
- `TC.Missions.Generator`
- `TC.AI.CapManager`
- `TC.Main`

Wenn eines dieser Module fehlt, muss zuerst die Ursache geprüft werden.

---

## Optionale Systeme

Diese Systeme sind für den ersten Test noch optional:

- IADS
- UI
- Debug

Grund:

Diese Bereiche besitzen aktuell README-Dateien, aber noch keine aktiven Lua-Module.

Sie dürfen im ersten Test nicht als Fehler gewertet werden.

---

## Erwartete Log-Suche

Nach dem Starttest muss `dcs.log` geprüft werden.

Suchen nach:

    TC
    Theater Command
    ERROR
    error
    stack traceback
    attempt to index
    nil value
    cannot open
    dofile
    MIST
    MOOSE
    CTLD
    Skynet

Wichtig:

Ein erfolgreicher Test bedeutet nicht, dass die Kampagne spielbar ist.

Ein erfolgreicher Test bedeutet nur:

    Die aktuelle Source-Struktur lädt im DCS Mission Scripting Environment ohne schwere Fehler.

---

## Häufige Fehlerbilder

### Datei nicht gefunden

Mögliche Meldungen:

    cannot open
    file not found
    no such file

Mögliche Ursachen:

- Datei wurde im Mission Editor falsch ausgewählt
- falsche Repository-Struktur lokal verwendet
- Datei liegt nicht im Missionspaket
- Pfad im Trigger stimmt nicht zur lokalen Datei

---

### Modulname fehlt

Mögliche Meldungen:

    Required system not available
    module_or_start_function_missing

Mögliche Ursachen:

- Datei wurde nicht geladen
- Datei wurde in falscher Reihenfolge geladen
- Modul registriert sich unter anderem Namen
- Startfunktion fehlt
- Lua-Fehler hat Dateiausführung vorher abgebrochen

---

### Framework fehlt

Mögliche Meldungen:

    Framework missing
    MIST missing
    MOOSE missing
    CTLD missing
    Skynet IADS missing

Mögliche Ursachen:

- Framework-Datei nicht geladen
- falsche Reihenfolge
- Framework-Dateiname falsch
- Framework-Datei im Mission Editor nicht korrekt eingebunden

---

### Lua-Syntaxfehler

Mögliche Meldungen:

    unexpected symbol
    near
    expected
    stack traceback

Mögliche Ursachen:

- Kopierfehler
- unvollständige Datei
- falsche Zeichen
- versehentlich beschädigte Lua-Datei

---

## Wenn der Test erfolgreich ist

Wenn Starttest-Variante A erfolgreich ist, wird danach Starttest-Variante B vorbereitet.

Variante B lädt nur:

    vendor/mist/mist.lua
    vendor/moose/Moose.lua
    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua
    vendor/skynet-iads/SkynetIADS.lua
    src/loader.lua

Ziel von Variante B:

    prüfen, ob src/loader.lua die restlichen Source-Dateien per dofile selbst nachladen kann

---

## Wenn der Test fehlschlägt

Wenn Starttest-Variante A fehlschlägt:

1. Nicht weiterbauen.
2. `dcs.log` sichern.
3. Fehlermeldung vollständig prüfen.
4. Fehler einer konkreten Datei oder Ladephase zuordnen.
5. Erst die Startkette stabilisieren.
6. Danach erneut testen.

Keine weiteren Systeme bauen, solange die Startkette nicht stabil ist.

---

## Nicht in diesem Schritt bauen

In diesem Schritt nicht bauen:

- keine CTLD-Pickup-Logik
- keine FOB-Logik im Mission Editor
- keine IADS-Netzwerke
- keine CAP-Spawns
- keine Missionsauswahl
- keine F10-Menüs
- keine Debug-Menüs
- keine Persistenzdateien
- keine vollständige Frontlinie
- keine große rote Ausgangsbesetzung

Der Trigger-Test prüft ausschließlich die technische Ladefähigkeit.

---

## Nächster Schritt nach dieser Datei

Nach dieser Datei wird `TASKS.md` aktualisiert.

Ziel:

- `mission_editor/trigger_setup.md` als erledigt markieren
- nächsten praktischen Schritt festlegen
- Vorbereitung der DEV-Mission als nächsten Arbeitspunkt setzen

Danach beginnt die praktische Mission-Editor-Arbeit.

Erster praktischer Schritt:

    minimale Syria-DEV-Mission erstellen und Framework-/Source-Ladetrigger nach dieser Datei anlegen
