# Trigger Setup

Diese Datei beschreibt die konkrete Trigger-Struktur im DCS Mission Editor für **Theater Command DCS**.

Die erste technische Entwicklungsmission heißt:

    Operation_Levant_Reclamation_DEV.miz

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut.

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## Zweck dieser Datei

Diese Datei dokumentiert, welche Trigger im DCS Mission Editor angelegt werden müssen, damit Theater Command DCS technisch startet.

Der Mission Editor ist dabei nur die Bühne.

Die eigentliche Kampagnenlogik liegt in Lua.

Grundprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

---

## Aktueller Teststatus

Stand: 2026-06-16

Der erste reale DCS-Starttest wurde durchgeführt.

Test:

    Starttest-Variante A — sichere Einzeldatei-Ladung

Ergebnis:

    Bestanden

Bestätigt wurde:

- MIST wird geladen
- MOOSE wird geladen
- CTLD-i18n wird geladen
- CTLD wird geladen
- Skynet IADS wird geladen
- eigene Theater-Command-Dateien werden geladen
- `src/main.lua` wird geladen
- `src/loader.lua` wird zuletzt geladen
- Loader startet
- Frameworks werden erkannt
- Main startet
- Runtime-Systeme werden initialisiert
- Airbase-Scanner läuft
- Zone-Factory läuft
- Loader beendet sauber

Wichtiger Befund:

    Airbase-Scanner registrierte 225 Airbase-/Helipad-Objekte.
    Zone-Factory registrierte 225 Zonen.

Bewertung:

    Die Triggerkette funktioniert.
    Die technische Startkette ist in DCS lauffähig.
    Der nächste technische Schwerpunkt liegt im Code: Airbase-Klassifizierung.

---

## Aktuelle DEV-Mission

Aktuelle Mission:

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

## Lokaler Projektpfad

Die lokale Repository-Kopie auf dem DCS-PC liegt aktuell unter:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\

Aus diesem Repository-Pfad werden die Lua-Dateien im Mission Editor per `DO SCRIPT FILE` geladen.

---

## Grundregel für Trigger

Jeder Trigger der aktuellen Starttest-Variante nutzt:

    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT
    Bedingung: MEHR ZEIT / TIME MORE
    Aktion: SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Die Trigger werden zeitversetzt ausgelöst.

Dadurch bleibt die Lade-Reihenfolge eindeutig und Fehler können in `dcs.log` besser zugeordnet werden.

---

## Warum Einzeldatei-Ladung?

Die aktuelle erfolgreiche Variante lädt jede Datei einzeln.

Vorteile:

- keine harte Abhängigkeit von `dofile`
- kein sofortiges Problem mit DCS-Sandbox-Dateizugriff
- jede Datei wird direkt im Mission Scripting Environment getestet
- klare Fehlereingrenzung
- gut geeignet für frühe technische Tests
- `dcs.log` zeigt, welche Datei zuletzt geladen wurde

Diese Variante ist nicht zwingend die spätere finale Ladeform.

Sie ist aber aktuell die sichere Entwicklungsvariante.

---

## Starttest-Variante A

Status:

    Bestanden

Ziel:

    sichere Einzeldatei-Ladung im Mission Editor

Diese Variante lädt:

1. externe Frameworks
2. eigene Core-Dateien
3. eigene World-Dateien
4. eigene Campaign-Dateien
5. eigene Logistics-Dateien
6. eigene Missions-Dateien
7. eigene AI-Dateien
8. `src/main.lua`
9. `src/loader.lua`

Wichtig:

    src/main.lua wird vor src/loader.lua geladen.
    src/loader.lua wird zuletzt geladen.

Grund:

    main.lua definiert TC.Main.
    loader.lua prüft danach Frameworks und startet Main.

---

## Triggerliste Starttest-Variante A

### 1. MIST laden

Name:

    TC_LOAD_MIST

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 1

Aktion:

    SKRIPTDATEI AUSFÜHREN

Datei:

    vendor/mist/mist.lua

---

### 2. MOOSE laden

Name:

    TC_LOAD_MOOSE

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 2

Aktion:

    SKRIPTDATEI AUSFÜHREN

Datei:

    vendor/moose/Moose.lua

---

### 3. CTLD-i18n laden

Name:

    TC_LOAD_CTLD_I18N

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 3

Aktion:

    SKRIPTDATEI AUSFÜHREN

Datei:

    vendor/ctld/CTLD-i18n.lua

---

### 4. CTLD laden

Name:

    TC_LOAD_CTLD

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 4

Aktion:

    SKRIPTDATEI AUSFÜHREN

Datei:

    vendor/ctld/CTLD.lua

---

### 5. Skynet IADS laden

Name:

    TC_LOAD_SKYNET_IADS

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 5

Aktion:

    SKRIPTDATEI AUSFÜHREN

Datei:

    vendor/skynet-iads/SkynetIADS.lua

---

### 6. Config laden

Name:

    TC_LOAD_TC_CONFIG

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 7

Aktion:

    SKRIPTDATEI AUSFÜHREN

Datei:

    src/core/tc_config.lua

---

### 7. Logger laden

Name:

    TC_LOAD_TC_LOGGER

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 8

Aktion:

    SKRIPTDATEI AUSFÜHREN

Datei:

    src/core/tc_logger.lua

---

### 8. State laden

Name:

    TC_LOAD_TC_STATE

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 9

Aktion:

    SKRIPTDATEI AUSFÜHREN

Datei:

    src/core/tc_state.lua

---

### 9. Utils laden

Name:

    TC_LOAD_TC_UTILS

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 10

Aktion:

    SKRIPTDATEI AUSFÜHREN

Datei:

    src/core/tc_utils.lua

---

### 10. Scheduler laden

Name:

    TC_LOAD_TC_SCHEDULER

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 11

Aktion:

    SKRIPTDATEI AUSFÜHREN

Datei:

    src/core/tc_scheduler.lua

---

### 11. Airbase Scanner laden

Name:

    TC_LOAD_TC_AIRBASE_SCANNER

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 12

Aktion:

    SKRIPTDATEI AUSFÜHREN

Datei:

    src/world/tc_airbase_scanner.lua

---

### 12. Zone Factory laden

Name:

    TC_LOAD_TC_ZONE_FACTORY

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 13

Aktion:

    SKRIPTDATEI AUSFÜHREN

Datei:

    src/world/tc_zone_factory.lua

---

### 13. Capture System laden

Name:

    TC_LOAD_TC_CAPTURE_SYSTEM

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 14

Aktion:

    SKRIPTDATEI AUSFÜHREN

Datei:

    src/campaign/tc_capture_system.lua

---

### 14. Persistence System laden

Name:

    TC_LOAD_TC_PERSISTENCE_SYSTEM

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 15

Aktion:

    SKRIPTDATEI AUSFÜHREN

Datei:

    src/campaign/tc_persistence_system.lua

---

### 15. Logistics Delivery laden

Name:

    TC_LOAD_TC_LOGISTICS_DELIVERY

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 16

Aktion:

    SKRIPTDATEI AUSFÜHREN

Datei:

    src/logistics/tc_logistics_delivery.lua

---

### 16. FOB System laden

Name:

    TC_LOAD_TC_FOB_SYSTEM

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 17

Aktion:

    SKRIPTDATEI AUSFÜHREN

Datei:

    src/logistics/tc_fob_system.lua

---

### 17. Mission Generator laden

Name:

    TC_LOAD_TC_MISSION_GENERATOR

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 18

Aktion:

    SKRIPTDATEI AUSFÜHREN

Datei:

    src/missions/tc_mission_generator.lua

---

### 18. AI CAP Manager laden

Name:

    TC_LOAD_TC_AI_CAP_MANAGER

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 19

Aktion:

    SKRIPTDATEI AUSFÜHREN

Datei:

    src/ai/tc_ai_cap_manager.lua

---

### 19. Main laden

Name:

    TC_LOAD_TC_MAIN

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 20

Aktion:

    SKRIPTDATEI AUSFÜHREN

Datei:

    src/main.lua

---

### 20. Loader laden

Name:

    TC_LOAD_TC_LOADER

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 22

Aktion:

    SKRIPTDATEI AUSFÜHREN

Datei:

    src/loader.lua

---

## Kompakte Ladeübersicht

Die erfolgreiche Ladeübersicht lautet:

    TIME MORE 1  -> vendor/mist/mist.lua
    TIME MORE 2  -> vendor/moose/Moose.lua
    TIME MORE 3  -> vendor/ctld/CTLD-i18n.lua
    TIME MORE 4  -> vendor/ctld/CTLD.lua
    TIME MORE 5  -> vendor/skynet-iads/SkynetIADS.lua
    TIME MORE 7  -> src/core/tc_config.lua
    TIME MORE 8  -> src/core/tc_logger.lua
    TIME MORE 9  -> src/core/tc_state.lua
    TIME MORE 10 -> src/core/tc_utils.lua
    TIME MORE 11 -> src/core/tc_scheduler.lua
    TIME MORE 12 -> src/world/tc_airbase_scanner.lua
    TIME MORE 13 -> src/world/tc_zone_factory.lua
    TIME MORE 14 -> src/campaign/tc_capture_system.lua
    TIME MORE 15 -> src/campaign/tc_persistence_system.lua
    TIME MORE 16 -> src/logistics/tc_logistics_delivery.lua
    TIME MORE 17 -> src/logistics/tc_fob_system.lua
    TIME MORE 18 -> src/missions/tc_mission_generator.lua
    TIME MORE 19 -> src/ai/tc_ai_cap_manager.lua
    TIME MORE 20 -> src/main.lua
    TIME MORE 22 -> src/loader.lua

---

## Erwartetes Ergebnis

Nach Missionsstart soll DCS mindestens bis nach `TIME MORE 22` laufen.

Erwartet wird:

- keine Lua-Fehlermeldung mit Theater-Command-Bezug
- keine TC-bezogenen Stack Tracebacks
- Frameworks werden erkannt
- Main startet
- Runtime-Systeme werden initialisiert
- Airbase-Scanner läuft
- Zone-Factory läuft
- Loader beendet sauber

---

## Bestätigtes Ergebnis

Starttest-Variante A wurde bestanden.

Wichtige positive Logausgaben:

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

World-Ergebnis:

    Airbase scan completed: 225 airbases registered
    Zone factory completed: 225 zones registered

Bewertung:

    Triggerstruktur funktioniert.
    Frameworks und eigene Source-Dateien werden korrekt geladen.
    Theater Command startet in DCS.
    Der nächste Schritt liegt im World-Code.

---

## `dcs.log` prüfen

Nach jedem Test wird die `dcs.log` geprüft.

Standardpfad:

    C:\Users\Paul\Saved Games\DCS\Logs\dcs.log

Möglicher älterer Open-Beta-/Standalone-Pfad:

    C:\Users\Paul\Saved Games\DCS.openbeta\Logs\dcs.log

Schneller Explorer-Pfad:

    %USERPROFILE%\Saved Games

Wichtige Suchbegriffe:

    TC
    Theater Command
    ERROR
    error
    stack traceback
    attempt to index
    nil value
    cannot open
    MIST
    MOOSE
    CTLD
    Skynet

---

## DCS-/Syria-interne Meldungen

Im ersten Test traten auch DCS-/Syria-interne Meldungen auf.

Beispiele:

    INVALID ATC HI08
    missing object declaration
    texture not found
    DTC_MANAGER Window pointer is null

Bewertung:

    Diese Meldungen sind aktuell kein Theater-Command-Blocker.

Entscheidend sind:

- TC-bezogene Lua-Fehler
- TC-bezogene Stack Tracebacks
- fehlgeschlagene Framework-Erkennung
- fehlgeschlagener Main-Start
- fehlgeschlagene Runtime-Initialisierung

---

## Starttest-Variante B

Status:

    Noch nicht durchgeführt

Ziel:

    Loader-only-Test mit dofile

Geplante Idee:

Der Mission Editor lädt nur:

    vendor/mist/mist.lua
    vendor/moose/Moose.lua
    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua
    vendor/skynet-iads/SkynetIADS.lua
    src/loader.lua

Der Loader soll dann selbst versuchen, die übrigen Theater-Command-Dateien nachzuladen.

Prüffragen:

- funktioniert `dofile` im DCS Mission Scripting Environment?
- kennt `loader.lua` den lokalen Script-Root?
- kann aus dem Repository-Pfad gelesen werden?
- blockiert die DCS-Sandbox?
- bleibt Einzeldatei-Ladung für Entwicklung sinnvoller?
- wird später eine Build-Datei benötigt?

Diese Variante wird erst später als eigener Test vorbereitet.

---

## Was aktuell nicht per Trigger gebaut wird

Aktuell nicht angelegt:

- keine rote Frontlinie
- keine IADS-Stellungen
- keine CTLD-Zonen
- keine FOB-Zonen
- keine Template-Gruppen
- keine F10-Menüs
- keine Debug-Menüs
- keine Missionsziel-Trigger
- keine Capture-Trigger
- keine Logistik-Trigger

Grund:

    Die Trigger dienen aktuell nur dem technischen Starttest.
    Die nächste Arbeit liegt im Airbase-Scanner, nicht im Mission Editor.

---

## Nächster technischer Schritt

Der nächste technische Schritt ist:

    src/world/tc_airbase_scanner.lua erweitern

Ziel:

- Airbase-Kategorien einführen
- Airbase-Klassifizierung ergänzen
- strategische Relevanz berechnen
- getrennte Listen speichern
- Summary-Logausgabe erzeugen
- ZoneFactory später darauf vorbereiten

---

## Aktueller Status

Die Triggerstruktur für Starttest-Variante A ist angelegt und erfolgreich getestet.

Die DEV-Mission bleibt als technischer Testträger bestehen.

Der nächste Schritt betrifft den Code im World-System.
