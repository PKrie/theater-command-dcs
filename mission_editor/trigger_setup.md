# Trigger Setup

Diese Datei beschreibt die verbindliche Trigger- und Lua-Ladestruktur im DCS Mission Editor für **Theater Command DCS**.

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Aktueller verbindlicher Stand:

    2026-09-29

Technische Hauptmission:

    Operation_Levant_Reclamation_DEV.miz

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland rot kontrolliert

Grundprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis / Source of Truth
    DCS Runtime = autoritativer Verhaltensbeweis

---

## 1. Zweck dieser Datei

Diese Datei dokumentiert die technische Startkette der DCS-Mission.

Sie beschreibt insbesondere:

- Vendor-Ladereihenfolge
- Theater-Command-Ladereihenfolge
- Triggernamen
- Triggerzeiten
- eingebettete Lua-Ressourcen
- technische Startstrategie
- aktuelle Runtime-Voraussetzungen
- Prüfworkflow nach Änderungen

Die Trigger starten die Lua-Komponenten.

Sie bilden nicht selbst die Kampagnenlogik ab.

---

## 2. Aktuelle Trigger-Strategie

Aktuelle Variante:

    sichere Einzeldatei-Ladung über DO SCRIPT FILE

Status:

    BESTANDEN
    weiterhin aktueller Standard

Geladen werden:

- MIST
- MOOSE
- CTLD-i18n
- CTLD
- Skynet IADS
- Theater-Command Core
- World
- Campaign
- Persistence
- Logistics
- Missions
- AI
- UI
- Main
- Loader

Die ursprüngliche Starttest-Struktur ist inzwischen die bestätigte technische Runtime-Ladekette der DEV-Mission.

---

## 3. Warum weiterhin Einzeldatei-Ladung?

Aktive Lua-Dateien werden einzeln über:

    DO SCRIPT FILE

geladen.

Vorteile:

- eindeutige Ladefolge
- separate Ressourcenprüfung
- klare Fehlereingrenzung
- gute `dcs.log`-Diagnose
- keine zusätzliche `dofile`-Abhängigkeit
- kontrollierbare Embedded-Ressourcen
- in DCS praktisch bestätigt

Eine spätere Loader-only- oder Build-Variante bleibt möglich.

Sie ist aktuell kein Entwicklungsblocker und kein nächster Arbeitsschritt.

---

## 4. Grundregel für aktive Lade-Trigger

Die technische Startkette verwendet grundsätzlich:

    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT
    Bedingung: MEHR ZEIT / TIME MORE
    Aktion: SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Die zeitliche Staffelung stellt die gewünschte Abhängigkeitsreihenfolge her.

---

## 5. Verbindliche Gesamtreihenfolge

Vendor:

    TIME MORE 1
    vendor/mist/mist.lua

    TIME MORE 2
    vendor/moose/Moose.lua

    TIME MORE 3
    vendor/ctld/CTLD-i18n.lua

    TIME MORE 4
    vendor/ctld/CTLD.lua

    TIME MORE 5
    vendor/skynet-iads/SkynetIADS.lua

Theater Command:

    TIME MORE 7
    src/core/tc_config.lua

    TIME MORE 8
    src/core/tc_logger.lua

    TIME MORE 9
    src/core/tc_state.lua

    TIME MORE 10
    src/core/tc_utils.lua

    TIME MORE 11
    src/core/tc_scheduler.lua

    TIME MORE 12
    src/world/tc_airbase_scanner.lua

    TIME MORE 13
    src/world/tc_zone_factory.lua

    TIME MORE 14
    src/campaign/tc_capture_system.lua

    TIME MORE 15
    src/campaign/tc_persistence_system.lua

    TIME MORE 16
    src/logistics/tc_logistics_delivery.lua

    TIME MORE 17
    src/logistics/tc_fob_system.lua

    TIME MORE 18
    src/missions/tc_mission_generator.lua

    TIME MORE 19
    src/ai/tc_ai_cap_manager.lua

    TIME MORE 20
    src/ui/tc_f10_menu.lua

    TIME MORE 21
    src/main.lua

    TIME MORE 22
    src/loader.lua

Diese Reihenfolge ist der aktuelle Referenzstand.

---

## 6. Trigger 1 – MIST

Name:

    TC_LOAD_MIST

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 1

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    vendor/mist/mist.lua

Stand:

    4.5.128-DYNSLOTS-02

Aufgabe:

- MIST Runtime bereitstellen
- Voraussetzung für die aktuelle CTLD-Ladekette

---

## 7. Trigger 2 – MOOSE

Name:

    TC_LOAD_MOOSE

Bedingung:

    MEHR ZEIT 2

Datei:

    vendor/moose/Moose.lua

Stand:

    2.9.17

Aktuell:

- Framework geladen
- Framework erkannt
- noch keine produktiven MOOSE-CAP-Spawns

---

## 8. Trigger 3 – CTLD-i18n

Name:

    TC_LOAD_CTLD_I18N

Bedingung:

    MEHR ZEIT 3

Datei:

    vendor/ctld/CTLD-i18n.lua

Wichtig:

    CTLD-i18n vor CTLD.lua

---

## 9. Trigger 4 – CTLD

Name:

    TC_LOAD_CTLD

Bedingung:

    MEHR ZEIT 4

Datei:

    vendor/ctld/CTLD.lua

Version:

    1.6.1

Status:

- geladen
- initialisiert
- Vendor unverändert
- KI-Truppentransport-PoC für den getesteten Aufbau bestanden

Wichtig:

Für den am 2026-09-29 getesteten Runtime-Pfad konnten normalisierte Pickup-/Dropoff-Zonen nach der bestehenden CTLD-Initialisierung ergänzt werden.

Eine erneute Ausführung von:

    ctld.initialize()

war für diese getestete Runtime-Ergänzung nicht erforderlich.

Daraus wird nicht abgeleitet, dass ein erneuter Aufruf von `ctld.initialize()` grundsätzlich verboten wäre.

Produktive Theater-Command-CTLD-Konfiguration erfolgt später außerhalb des Vendor-Codes.

---

## 10. Trigger 5 – Skynet IADS

Name:

    TC_LOAD_SKYNET_IADS

Bedingung:

    MEHR ZEIT 5

Datei:

    vendor/skynet-iads/SkynetIADS.lua

Stand:

    3.3.0

Status:

- Framework geladen
- noch keine produktive Theater-Command-IADS-Integration

---

## 11. Trigger 6 – Config

Name:

    TC_LOAD_TC_CONFIG

Bedingung:

    MEHR ZEIT 7

Datei:

    src/core/tc_config.lua

Aufgabe:

- zentrale Theater-Command-Konfiguration

---

## 12. Trigger 7 – Logger

Name:

    TC_LOAD_TC_LOGGER

Bedingung:

    MEHR ZEIT 8

Datei:

    src/core/tc_logger.lua

Aufgabe:

- Theater-Command-Logging

---

## 13. Trigger 8 – State

Name:

    TC_LOAD_TC_STATE

Bedingung:

    MEHR ZEIT 9

Datei:

    src/core/tc_state.lua

Aufgaben:

- zentralen `TC.State` bereitstellen
- Kampagnenstate halten
- Persistence Dirty-State verwalten

Wichtig:

Mission-Collections sind String-keyed Dictionaries.

Für deren Anzahl ist:

    #

nicht autoritativ.

Gezählt wird pairs-basiert.

---

## 14. Trigger 9 – Utils

Name:

    TC_LOAD_TC_UTILS

Bedingung:

    MEHR ZEIT 10

Datei:

    src/core/tc_utils.lua

Aufgabe:

- gemeinsame Hilfsfunktionen

---

## 15. Trigger 10 – Scheduler

Name:

    TC_LOAD_TC_SCHEDULER

Bedingung:

    MEHR ZEIT 11

Datei:

    src/core/tc_scheduler.lua

Aufgabe:

- Theater-Command-Scheduling bereitstellen

---

## 16. Trigger 11 – Airbase Scanner

Name:

    TC_LOAD_TC_AIRBASE_SCANNER

Bedingung:

    MEHR ZEIT 12

Datei:

    src/world/tc_airbase_scanner.lua

Version:

    v0.2.2

Bestätigt:

    Airbase-like Objects: 225
    Capture Candidates: 32
    Logistics Candidates: 46

Unter anderem:

    strategic: 19
    secondary: 13
    heliports: 1
    helipads: 95
    medical: 40
    tactical: 13
    unknown: 44

Nicht alle 225 Airbase-like Objects sind Kampagnenzonen.

---

## 17. Trigger 12 – ZoneFactory

Name:

    TC_LOAD_TC_ZONE_FACTORY

Bedingung:

    MEHR ZEIT 13

Datei:

    src/world/tc_zone_factory.lua

Version:

    v0.2.0

Bestätigt:

    relevante Kampagnenzonen: 46
    captureZones: 32
    missionZones: 32
    logisticsZones: 46
    startBaseZones: 1

Übersprungen:

    179 Airbase-like Objects

---

## 18. Trigger 13 – CaptureSystem

Name:

    TC_LOAD_TC_CAPTURE_SYSTEM

Bedingung:

    MEHR ZEIT 14

Datei:

    src/campaign/tc_capture_system.lua

Version:

    v0.2.2

Bestätigt:

- Ownership
- Capture Pressure
- Capture Progress
- Capture Ready
- Mission Effects
- Capture Apply
- linked Airbase Sync
- Read-Neutrality
- Ownership-No-Op

---

## 19. Trigger 14 – PersistenceSystem

Name:

    TC_LOAD_TC_PERSISTENCE_SYSTEM

Bedingung:

    MEHR ZEIT 15

Datei:

    src/campaign/tc_persistence_system.lua

Version:

    v0.2.6

Aktive Embedded-Ressource:

    tc_persistence_system_v0_2_6.lua

Bestätigt:

- Save
- Read-back
- Compile
- Evaluate
- Validation
- dirty-aware Background Autosave
- `SAVED`
- `SKIPPED`
- kontrollierter `FAILED`
- Retry

Verbindlich:

    productiveRestore=false

Historische verwaiste Ressource:

    ResKey_Action_55
    tc_persistence_system.lua

Letzter bestätigter Stand:

- kein aktiver Trigger referenziert sie
- sie wird nicht geladen
- kein aktueller Blocker
- späterer Cleanup möglich

---

## 20. Trigger 15 – LogisticsDelivery

Name:

    TC_LOAD_TC_LOGISTICS_DELIVERY

Bedingung:

    MEHR ZEIT 16

Datei:

    src/logistics/tc_logistics_delivery.lua

Version:

    v0.2.1

Bestätigt:

    Logistics Hubs: 46
    Blue: 7
    Red: 24
    Neutral: 15
    Active: 31
    Limited: 15

Read-Neutrality:

    bestanden

---

## 21. Trigger 16 – FobSystem

Name:

    TC_LOAD_TC_FOB_SYSTEM

Bedingung:

    MEHR ZEIT 17

Datei:

    src/logistics/tc_fob_system.lua

Version:

    v0.2.1

Bestätigt:

    FOB Candidates: 6
    Blue FOBs: 2

State-only FOBs:

    FOB Ercan
    FOB Gecitkale

Read-Neutrality:

    bestanden

Diese FOBs sind noch keine real durch CTLD aufgebauten FOBs.

---

## 22. Trigger 17 – MissionGenerator

Name:

    TC_LOAD_TC_MISSION_GENERATOR

Bedingung:

    MEHR ZEIT 18

Datei:

    src/missions/tc_mission_generator.lua

Version:

    v0.2.3

Bestätigt:

    Mission Records: 10

Funktional bestätigt:

- Generation
- Activation
- Completion
- Failure
- Mission Effects

Noch nicht produktiv:

- reale Framework-Missionsausführung
- automatische DCS-Outcome-Erkennung

---

## 23. Trigger 18 – AICapManager

Name:

    TC_LOAD_TC_AI_CAP_MANAGER

Bedingung:

    MEHR ZEIT 19

Datei:

    src/ai/tc_ai_cap_manager.lua

Version:

    v0.2.1

Bestätigt:

    CAP Candidates: 31
    CAP Zones: 12
    CAP Requests: 12

Aktuell:

    state-first

Read-Neutrality:

    bestanden

Noch nicht produktiv:

    reale MOOSE-CAP-Flüge

---

## 24. Trigger 19 – F10Menu

Name:

    TC_LOAD_TC_F10_MENU

Bedingung:

    MEHR ZEIT 20

Datei:

    src/ui/tc_f10_menu.lua

Version:

    v0.2.3

Bestätigt:

    33 Commands

Unter anderem:

- Mission Details
- Mission Activation
- Mission Completion Test
- Mission Failure Test
- Capture Status
- Capture Ready
- Pressure Contested
- Capture Apply
- Logistics Status
- FOB Status
- AI CAP Status

F10Menu wird vor Main geladen.

F10 bleibt überwiegend:

- Statuszugang
- Debugzugang
- kontrollierter Testzugang

---

## 25. Trigger 20 – Main

Name:

    TC_LOAD_TC_MAIN

Bedingung:

    MEHR ZEIT 21

Datei:

    src/main.lua

Aufgaben:

- Runtime-Systeme starten
- zentrale Theater-Command-Initialisierung durchführen

Main wird nach den aktiven Fachmodulen geladen.

---

## 26. Trigger 21 – Loader

Name:

    TC_LOAD_TC_LOADER

Bedingung:

    MEHR ZEIT 22

Datei:

    src/loader.lua

Aufgaben:

- Frameworks prüfen
- Module prüfen
- Runtime-Start validieren
- Startkette abschließen

Loader bleibt aktuell die letzte eigene Datei der Triggerkette.

---

## 27. Kompakte Triggerreferenz

    01  TIME MORE 1   TC_LOAD_MIST
        vendor/mist/mist.lua

    02  TIME MORE 2   TC_LOAD_MOOSE
        vendor/moose/Moose.lua

    03  TIME MORE 3   TC_LOAD_CTLD_I18N
        vendor/ctld/CTLD-i18n.lua

    04  TIME MORE 4   TC_LOAD_CTLD
        vendor/ctld/CTLD.lua

    05  TIME MORE 5   TC_LOAD_SKYNET_IADS
        vendor/skynet-iads/SkynetIADS.lua

    06  TIME MORE 7   TC_LOAD_TC_CONFIG
        src/core/tc_config.lua

    07  TIME MORE 8   TC_LOAD_TC_LOGGER
        src/core/tc_logger.lua

    08  TIME MORE 9   TC_LOAD_TC_STATE
        src/core/tc_state.lua

    09  TIME MORE 10  TC_LOAD_TC_UTILS
        src/core/tc_utils.lua

    10  TIME MORE 11  TC_LOAD_TC_SCHEDULER
        src/core/tc_scheduler.lua

    11  TIME MORE 12  TC_LOAD_TC_AIRBASE_SCANNER
        src/world/tc_airbase_scanner.lua

    12  TIME MORE 13  TC_LOAD_TC_ZONE_FACTORY
        src/world/tc_zone_factory.lua

    13  TIME MORE 14  TC_LOAD_TC_CAPTURE_SYSTEM
        src/campaign/tc_capture_system.lua

    14  TIME MORE 15  TC_LOAD_TC_PERSISTENCE_SYSTEM
        src/campaign/tc_persistence_system.lua

    15  TIME MORE 16  TC_LOAD_TC_LOGISTICS_DELIVERY
        src/logistics/tc_logistics_delivery.lua

    16  TIME MORE 17  TC_LOAD_TC_FOB_SYSTEM
        src/logistics/tc_fob_system.lua

    17  TIME MORE 18  TC_LOAD_TC_MISSION_GENERATOR
        src/missions/tc_mission_generator.lua

    18  TIME MORE 19  TC_LOAD_TC_AI_CAP_MANAGER
        src/ai/tc_ai_cap_manager.lua

    19  TIME MORE 20  TC_LOAD_TC_F10_MENU
        src/ui/tc_f10_menu.lua

    20  TIME MORE 21  TC_LOAD_TC_MAIN
        src/main.lua

    21  TIME MORE 22  TC_LOAD_TC_LOADER
        src/loader.lua

---

## 28. Erwarteter Startzustand

Nach vollständiger Startkette wird erwartet:

- Vendor-Frameworks verfügbar
- Core verfügbar
- World-Systeme initialisiert
- Campaign-Systeme initialisiert
- Persistence aktiv
- Logistics initialisiert
- FobSystem initialisiert
- MissionGenerator initialisiert
- AICapManager initialisiert
- F10Menu initialisiert
- Main gestartet
- Loader abgeschlossen

Keine erwarteten Theater-Command-/Scripting-Fehler:

    [TC][ERROR]
    SCRIPTING ERROR
    Mission script error
    stack traceback
    attempt to index
    attempt to call
    unerwarteter nil value

---

## 29. Bestätigter state-first Runtime-Stand

Bestätigter Kampagnenpfad:

    Mission Details
    -> Mission Activation
    -> Mission Completion
    -> Mission Effects
    -> Capture Pressure
    -> Capture Progress
    -> Capture Ready
    -> Capture Apply
    -> Zone Ownership
    -> Linked Airbase Ownership
    -> Background Autosave

Bestätigter Failure-Pfad:

    Mission Activation
    -> Mission Failure
    -> Failure Effects
    -> kein Capture Pressure
    -> Background Autosave

Persistence:

    dirty-aware
    SAVED
    SKIPPED
    FAILED
    Retry

Priority 3:

    abgeschlossen im dokumentierten Umfang seit 2026-09-21

---

## 30. CTLD und Haupt-Triggerkette

CTLD wird als Vendor-Ressource bei:

    TIME MORE 4

geladen.

Der erfolgreiche KI-Truppentransport-PoC vom 2026-09-29 erforderte keine Änderung der bestehenden Vendor-Triggerkette.

Die temporäre CTLD-Konfiguration des Tests war noch keine produktive Theater-Command-Ladekomponente.

Dazu gehörten:

- normalisierte Pickup-Zonenregistrierung
- normalisierte Dropoff-Zonenregistrierung
- Registrierung des KI-Transporters in `ctld.transportPilotNames`

Diese Aufgaben müssen später kontrolliert durch Theater-Command-eigene Logik übernommen werden.

Sie werden nicht in:

    vendor/ctld/CTLD.lua

eingebaut.

---

## 31. CTLD-Testzonen

Verwendeter Pickup:

    CTLD_PICKUP_BLUE_AKROTIRI_01

Verwendeter technischer Dropoff:

    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01

Reservierter späterer Ercan-Dropoff:

    CTLD_DROPOFF_BLUE_ERCAN_FOB_01

Der Ercan-Name ist für eine mögliche spätere FOB-/Logistiknutzung reserviert.

Der erfolgreiche Test fand nicht dort statt.

Details:

    mission_editor/ctld_start_zones.md

---

## 32. CTLD-Zonenregistrierung

Für den getesteten Runtime-Pfad bestätigt:

Nach bestehender CTLD-Initialisierung konnten normalisierte Einträge ergänzt werden in:

    ctld.pickupZones
    ctld.dropOffZones

Pickup:

    { "CTLD_PICKUP_BLUE_AKROTIRI_01", -1, 10000, 1, 2 }

Dropoff:

    { "CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01", -1, 2, 1 }

CTLD verwendete beide Einträge anschließend tatsächlich.

Eine erneute Ausführung von:

    ctld.initialize()

war für diese getestete Runtime-Ergänzung nicht erforderlich.

Eine produktive Theater-Command-Lösung muss die Registrierung später:

- automatisch
- idempotent
- duplikatfrei
- lifecycle-sicher

durchführen.

---

## 33. CTLD-KI-Transporter

Getestete Gruppe:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01

Getestete Unit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Luftfahrzeug:

    Mi-8

Der exakte Unit-Name musste im getesteten CTLD-AI-Pfad in:

    ctld.transportPilotNames

registriert sein.

Vor temporärer Registrierung:

    108 Einträge

Danach:

    109 Einträge

Die Testunit war genau einmal vorhanden.

Der spätere Theater-Command-Pfad muss diese Registrierung automatisieren.

---

## 34. CTLD-KI-Truppentransport-PoC

Testdatum:

    2026-09-29

Testmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz

SHA-256 vor Runtime-Test:

    5F0D89DF744A7083401E36713B148BD21813FF187CC36EC1F088507163458C57

Bestätigter Ablauf:

    Aktivierung
    -> automatischer CTLD-Pickup
    -> Taxi
    -> Takeoff
    -> Transit
    -> Off-Airfield-Landung
    -> automatischer CTLD-Dropoff
    -> reale Blue-Bodengruppe

Pickup:

    16 Soldaten
    Pickup-Counter 10000 -> 9999

Dropoff-Gruppe:

    Dropped Group 2

Group-ID:

    70001

Stärke:

    16 x Soldier M249

Dieser Befund gilt für den getesteten Aufbau.

Er ist noch keine produktive Theater-Command-CTLD-Orchestrierung.

---

## 35. Off-Airfield-Landung

Erfolgreiche gespeicherte Mission-Editor-Konfiguration:

    normaler Turning Point
    +
    Perform Task -> Land

Ziel:

    x / North = -29249.110954281
    z / East  = -271836.070539260

Wegpunkthöhe:

    100 m BARO

Wegpunktgeschwindigkeit:

    30 m/s

Land-Task:

    duration=300
    durationFlag=true

Runtime:

    Touchdown ungefähr t=1405.9 bis 1426.0 s
    minimale Entfernung zum Dropoff-Zentrum ungefähr 1.06 m
    Bodengeschwindigkeit anschließend ungefähr 0.01 m/s
    mindestens ungefähr 220 s Bodenbeobachtung

Der volle 300-Sekunden-Wert musste für den Dropoff-Nachweis nicht abgewartet werden.

Für diesen getesteten Truppentransport war kein Invisible FARP erforderlich.

Der zuvor verwendete ungebundene:

    Land / Landing

Waypoint hatte keinen vollständigen erfolgreichen Transportzyklus ergeben.

Der erfolgreiche neue Aufbau zeigt einen relevanten Unterschied in der Landemethode.

Die genaue Ursache des früheren Turnbacks ist nicht abschließend bewiesen.

---

## 36. Bekannter CTLD-Runtime-Fehler

Beim Touchdown des registrierten KI-Transporters wurde genau einmal beobachtet:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Kontext:

    updateRepackMenu
    updateRepackMenuOnlanding

Während der anschließenden ungefähr 220 Sekunden Bodenbeobachtung wurde der Fehler nicht erneut beobachtet.

Source-basierte Einordnung:

- der KI-Transporter war in `ctld.transportPilotNames` registriert
- damit konnte er einen CTLD-Landing-/Menüpfad erreichen
- `ctld.vehicleCommandsPath[_unitName]` ist für reine KI-Units nicht zwangsläufig vorhanden
- daraus kann ein `RepackCommandsPath` von `nil` entstehen

Der automatische Pickup-/Dropoff-Pfad wurde trotzdem erfolgreich abgeschlossen.

Nicht bewiesen:

- dass der Fehler harmlos ist
- dass spätere Repack-Menü-Aktualisierungen funktionieren
- dass der betreffende Scheduler definitiv weiterlief
- dass der betreffende Scheduler definitiv beendet wurde

Ein mögliches Ende des Scheduler-Pfads bleibt eine technische Inferenz.

Verbindlich:

    vendor/ctld/CTLD.lua wird nicht gepatcht.

---

## 37. CTLD-Truppentransport ist nicht gleich Cargo

Der bestandene Test betrifft:

    KI-Truppentransport

Noch nicht praktisch bestätigt:

- Crate Spawn
- Crate Loading
- Sling Load
- Crate Drop
- Supply Cargo
- Engineering Cargo
- Repair Cargo
- Fuel Cargo
- Ammo Cargo
- FOB Core
- produktiver FOB-Bau
- LogisticsDelivery-Rückkopplung
- FobSystem-Rückkopplung
- CTLD-Restore
- Multiplayer

Diese Funktionen benötigen eigene Tests.

---

## 38. `.miz`-Einbettung

Bei:

    DO SCRIPT FILE

wird eine Lua-Datei in die `.miz` eingebettet.

Deshalb gilt:

    Repository-Datei geändert
    !=
    Embedded-Ressource automatisch geändert

Nach einer Source-Änderung muss die betroffene Missionsressource aktualisiert und die Mission gespeichert werden.

Vor kritischen Runtime-Tests soll geprüft werden, ob die erwartete Version tatsächlich in der `.miz` liegt.

---

## 39. Embedded Resource Audit

Am 2026-09-12 wurde ein relevanter Embedded Resource Audit durchgeführt.

Ergebnis:

    13/13 relevante aktive Theater-Command-Ressourcen EXACT_MATCH

Zusätzlich:

- keine aktiven Byte-Mismatches
- keine aktive Source Drift
- keine fehlenden aktiven Ressourcen im geprüften Bereich

Dieser Befund gilt für den damaligen Auditzeitpunkt.

Spätere Source-Änderungen müssen bei Bedarf erneut geprüft werden.

---

## 40. Lokaler Projektpfad

Lokale Repository-Kopie:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\

GitHub bleibt Source of Truth.

Vor Re-Embed- oder Mission-Editor-Arbeit muss die lokale Repository-Kopie dem gewünschten GitHub-Stand entsprechen.

---

## 41. Entwicklungswerkzeuge

Die Entwicklungswerkzeuge sind keine Runtime-Abhängigkeit der Kampagne.

Rollen:

    ChatGPT
    -> Projektkoordination / Architektur / Dokumentation

    Claude + dcs-mcp
    -> .miz / Mission Editor

    Claude Code + DCS-SMS
    -> lokale Runtime-Diagnose

    DCS
    -> autoritativer Runtime-Beweis

    GitHub
    -> Source of Truth

---

## 42. Claude + dcs-mcp

Version:

    dcs-mcp 0.9.11

Terrain Store:

    C:\Users\Paul\AppData\Local\dcs-mcp\terrain

Syria:

    installiert

Bevorzugte Aufgaben:

- `.miz` analysieren
- Trigger prüfen
- Gruppen prüfen
- Units prüfen
- Trigger-Zonen prüfen
- Wegpunkte prüfen
- Tasks prüfen
- eingebettete Ressourcen prüfen
- gezielte Mission-Editor-Änderungen
- gespeicherte Mission auditieren

Vor Änderungen wird die aktuelle Mission zuerst gelesen.

---

## 43. Claude Code + DCS-SMS

Version:

    DCS-SMS 0.27.2

Hook:

    me-bridge-0.27.2

Verifiziertes Installationsverzeichnis:

    C:\Tools\dcs-sms

Claude-Code-Skill:

    C:\Users\Paul\.claude\skills\dcs-sms\SKILL.md

Verwendung:

- Mission-Editor-Status
- Runtime-Lua
- Theater-Command-State
- CTLD-State
- Unit-/Group-State
- Position
- Geschwindigkeit
- Grounded/Airborne
- kontrollierte Aktivierung
- Logs
- Runtime-Regressionen

Aus dem aktuellen bestätigten Stand wird kein exakter Executable-Pfad abgeleitet.

---

## 44. Verbindlicher Arbeitsablauf

Bei Mission-Editor-/`.miz`-Arbeit:

    GitHub prüfen
    -> konkrete Aufgabe definieren
    -> aktuelle .miz mit Claude + dcs-mcp öffnen
    -> betroffenen Bereich auditieren
    -> nur konkrete Änderung durchführen
    -> Mission speichern
    -> gespeicherte Mission erneut prüfen
    -> Runtime-Test vorbereiten
    -> Claude Code + DCS-SMS verwenden
    -> Verhalten in DCS praktisch prüfen
    -> Ergebnis auswerten
    -> bestätigten Stand in GitHub dokumentieren

Pro Schritt:

    eine konkrete Aufgabe

---

## 45. Persistence-Schutz bei Tests

Produktive Save-Datei:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Bestätigter SHA-256:

    C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596

Bestätigte Größe:

    3094967 Bytes

Wenn ein isolierter Test den produktiven Kampagnenstate beeinflussen könnte:

    Hash prüfen
    -> Backup erzeugen
    -> Backup verifizieren
    -> Save ReadOnly setzen
    -> ReadOnly bestätigen
    -> Test
    -> DCS vollständig beenden
    -> Hash erneut prüfen
    -> nur bei Match ReadOnly entfernen
    -> final erneut prüfen

Der CTLD-Test vom 2026-09-29 hat den produktiven Save nicht verändert.

Verbindlich:

    productiveRestore=false

---

## 46. MissionScripting.lua

Persistence und DCS-SMS benötigen eine geeignete lokale Mission-Scripting-Umgebung.

DCS-Updates können lokale Änderungen an:

    MissionScripting.lua

überschreiben.

Nach DCS-Updates müssen die für Persistence und DCS-SMS benötigten lokalen Voraussetzungen erneut geprüft werden.

Konkrete Sandbox-Werte werden nur dann als aktueller Stand behandelt, wenn sie für die betreffende lokale Umgebung erneut verifiziert wurden.

---

## 47. Was nicht über Trigger gebaut wird

Die Triggerkette wird nicht verwendet, um Kampagnenlogik in den Mission Editor zu verlagern.

Nicht gewünscht:

- Capture-Logik als Triggerkette
- Missionsgenerator als Triggerkette
- Logistiksteuerung als Triggerkette
- AI Director als Triggerkette
- Persistence als Spieler-Triggerworkflow
- CTLD-Orchestrierung als große Triggerkette
- Framework-Patches über Mission-Editor-Skripte

Trigger dienen primär:

- Initialisierung
- technischen Ladeabhängigkeiten
- klar definierten Testfällen

---

## 48. Aktueller nächster Trigger-bezogener Schritt

Aktuell ist keine Änderung an der bestehenden Haupt-Ladekette freigegeben.

Die aktuelle Ladefolge ist funktional.

Der nächste Entwicklungsbereich ist:

    Priority 4 – produktive Theater-Command-CTLD-Integration vorbereiten

Erst nach Architekturentscheidung wird festgelegt, ob dafür:

- ein neues fachlich benanntes Modul
- die Erweiterung eines bestehenden Moduls
- und gegebenenfalls ein zusätzlicher Lade-Trigger

erforderlich ist.

Keine neue Trigger-Ressource wird vor dieser Entscheidung erfunden.

Keine generische Datei wie:

    tc_ctld.lua
    tc_ctld_bridge.lua

wird angelegt.

---

## 49. Aktueller Projektstand

Priority 3:

    abgeschlossen im dokumentierten Umfang seit 2026-09-21

CTLD-KI-Truppentransport-PoC:

    bestanden für den getesteten Aufbau

Produktiver Restore:

    deaktiviert
    productiveRestore=false

Aktueller Entwicklungsbereich:

    Priority 4 – produktive CTLD-Integration vorbereiten

Zu klären:

- fachliche Zuständigkeit unter `src/`
- idempotente CTLD-Zonenregistrierung
- idempotente Transporterregistrierung
- Transporter-Lifecycle
- `RepackCommandsPath`
- Transportauftrag
- Erfolgs-/Fehlererkennung
- Ergebnisvalidierung
- Rückkopplung in Theater-Command-State
- Dirty-Semantik
- Persistence-Grenze
- runtime-only CTLD-Daten
- spätere Restore-Rekonstruktion

---

## 50. Aktueller Abschluss

Stand:

    2026-09-29

Bestätigt:

    Triggerkette ist funktional.
    Vendor-Ladefolge ist funktional.
    Theater-Command-Ladefolge ist funktional.
    F10Menu ist Teil der aktiven Ladekette.
    Airbase Scanner klassifiziert 225 Airbase-like Objects.
    ZoneFactory erzeugt 46 relevante Kampagnenzonen.
    Background Persistence funktioniert.
    Priority 3 ist im dokumentierten Umfang abgeschlossen.
    CTLD 1.6.1 ist geladen.
    CTLD-KI-Truppentransport-PoC ist für den getesteten Aufbau bestanden.
    kein zusätzlicher CTLD-Vendor-Trigger war für den PoC erforderlich.
    Vendor-Dateien bleiben unverändert.
    Crate-/Cargo-Pfad ist separat ungetestet.
    Claude + dcs-mcp ist der bevorzugte .miz-/Mission-Editor-Pfad.
    Claude Code + DCS-SMS ist der bevorzugte lokale Runtime-Diagnosepfad.
    DCS bleibt autoritativer Runtime-Beweis.
    GitHub bleibt Source of Truth.

Die Triggerstruktur ist aktuell kein Blocker.

Aktueller Übergang:

    state-first Kampagnenkern
    +
    dirty-aware Persistence
    +
    abgeschlossene Priority-3-Dirty-Coverage
    +
    bestandener CTLD-KI-Truppentransport-PoC
    ->
    kontrollierte produktive CTLD-Integration
