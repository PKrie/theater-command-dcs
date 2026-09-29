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

---

## 1. Zweck dieser Datei

Diese Datei dokumentiert die technische Startkette der DCS-Mission.

Sie beschreibt insbesondere:

- Vendor-Ladereihenfolge
- Theater-Command-Ladereihenfolge
- Triggernamen
- Triggerzeiten
- eingebettete Lua-Ressourcen
- aktuelle technische Startstrategie
- bekannte Mission-Editor-Besonderheiten
- Prüfworkflow nach Änderungen

Der Mission Editor ist dabei nur die Bühne.

Grundprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis / Source of Truth

Die Trigger starten die Lua-Komponenten.

Sie bilden nicht selbst die Kampagnenlogik ab.

---

## 2. Aktueller Trigger-Status

Aktuelle Strategie:

    Starttest-Variante A
    sichere Einzeldatei-Ladung über DO SCRIPT FILE

Status:

    BESTANDEN
    weiterhin aktueller Standard

Die Triggerkette wurde über zahlreiche Runtime-Tests hinweg bestätigt.

Aktuell werden geladen:

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

Der ursprüngliche reine Starttest ist inzwischen zu einer stabilen technischen Runtime-Ladekette geworden.

---

## 3. Warum weiterhin Einzeldatei-Ladung?

Aktuell werden die aktiven Lua-Dateien einzeln über:

    DO SCRIPT FILE

geladen.

Vorteile:

- eindeutige Ladefolge
- einzelne Ressourcen separat prüfbar
- klare Fehlereingrenzung
- gute `dcs.log`-Diagnose
- keine zusätzliche `dofile`-Abhängigkeit
- Embedded-Ressourcen können separat geprüft werden
- im realen DCS-Betrieb bestätigt

Eine spätere Loader-only- oder Build-Variante ist möglich.

Sie ist aktuell kein Entwicklungsblocker und kein nächster Schritt.

---

## 4. Grundregel für aktive Trigger

Die aktuelle Startkette verwendet grundsätzlich:

    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT
    Bedingung: MEHR ZEIT / TIME MORE
    Aktion: SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Die Trigger werden zeitversetzt ausgelöst.

Dadurch bleibt die Abhängigkeitenreihenfolge eindeutig.

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

Funktion:

- MIST Runtime bereitstellen
- Voraussetzung für aktuelle CTLD-Ladekette

---

## 7. Trigger 2 – MOOSE

Name:

    TC_LOAD_MOOSE

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 2

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    vendor/moose/Moose.lua

Aktueller Stand:

- Framework geladen
- Framework erkannt
- noch keine produktiven MOOSE-CAP-Spawns

---

## 8. Trigger 3 – CTLD-i18n

Name:

    TC_LOAD_CTLD_I18N

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 3

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    vendor/ctld/CTLD-i18n.lua

Wichtig:

    CTLD-i18n muss vor CTLD.lua geladen werden.

---

## 9. Trigger 4 – CTLD

Name:

    TC_LOAD_CTLD

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 4

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    vendor/ctld/CTLD.lua

Version:

    1.6.1

Status:

- geladen
- initialisiert
- Vendor unverändert
- KI-Truppentransport-Proof-of-Concept bestanden

Wichtig:

    ctld.initialize()

wird nach dem normalen CTLD-Start nicht erneut ausgeführt.

Theater-Command-seitige CTLD-Runtime-Konfiguration erfolgt später außerhalb des Vendor-Codes.

---

## 10. Trigger 5 – Skynet IADS

Name:

    TC_LOAD_SKYNET_IADS

Typ:

    EINMALIG / ONCE

Ereignis:

    KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT 5

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    vendor/skynet-iads/SkynetIADS.lua

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

- zentrale Theater-Command-Konfiguration bereitstellen

---

## 12. Trigger 7 – Logger

Name:

    TC_LOAD_TC_LOGGER

Bedingung:

    MEHR ZEIT 8

Datei:

    src/core/tc_logger.lua

Aufgabe:

- Theater-Command-Logging bereitstellen

---

## 13. Trigger 8 – State

Name:

    TC_LOAD_TC_STATE

Bedingung:

    MEHR ZEIT 9

Datei:

    src/core/tc_state.lua

Aufgabe:

- zentralen `TC.State` bereitstellen
- Kampagnenstate halten
- Persistence Dirty-State verwalten

Wichtig:

Mission-Collections sind String-keyed Dictionaries.

Für deren Anzahl ist:

    #

nicht autoritativ.

Es wird pairs-basiert gezählt.

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

Bestätigter Stand:

    Airbase-like Objects: 225

Unter anderem:

    strategic: 19
    secondary: 13
    heliports: 1
    helipads: 95
    medical: 40
    tactical: 13
    unknown: 44

Capture Candidates:

    32

Logistics Candidates:

    46

Die frühere Annahme, alle 225 Objekte müssten direkt Kampagnenzonen sein, ist veraltet.

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

Bestätigter Stand:

    relevante Kampagnenzonen: 46

Davon:

    captureZones: 32
    missionZones: 32
    logisticsZones: 46
    startBaseZones: 1

Übersprungen:

    179 nicht geeignete Airbase-like Objects

Die alte Dokumentation mit:

    225 zones registered

ist historisch und nicht mehr der aktuelle Fachstand.

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

Aktuelle aktive Embedded-Ressource:

    tc_persistence_system_v0_2_6.lua

Bestätigt:

- Sandbox-Prüfung
- Save
- Read-back
- Compile
- Evaluate
- Validation
- Dirty-aware Background Autosave
- `SAVED`
- `SKIPPED`
- kontrollierter `FAILED`
- Retry

Verbindlich:

    productiveRestore=false

Historische verwaiste Ressource:

    ResKey_Action_55
    tc_persistence_system.lua

Stand des letzten Audits:

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

Aktuelle state-only FOBs:

    FOB Ercan
    FOB Gecitkale

Read-Neutrality:

    bestanden

Diese FOBs sind noch keine realen CTLD-FOBs.

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

Funktional bestanden:

- Generation
- Activation
- Completion
- Failure
- Mission Effects

Noch nicht produktiv:

- reale DCS-Execution
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

Noch nicht produktiv:

    reale MOOSE-CAP-Flüge

Read-Neutrality:

    bestanden

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

Wichtig:

    F10Menu muss vor Main geladen sein.

Die alte Trigger-Dokumentation ohne F10Menu ist nicht mehr gültig.

---

## 25. Trigger 20 – Main

Name:

    TC_LOAD_TC_MAIN

Bedingung:

    MEHR ZEIT 21

Datei:

    src/main.lua

Aufgabe:

- Runtime-Systeme starten
- zentrale Theater-Command-Initialisierung durchführen

Wichtig:

    Main wird nach allen aktiven Fachmodulen geladen.

---

## 26. Trigger 21 – Loader

Name:

    TC_LOAD_TC_LOADER

Bedingung:

    MEHR ZEIT 22

Datei:

    src/loader.lua

Aufgabe:

- Frameworks prüfen
- Module prüfen
- Main-/Runtime-Start validieren
- Startkette abschließen

Loader bleibt aktuell die letzte eigene Datei der Triggerkette.

---

## 27. Kompakte Referenzliste

Aktuelle verbindliche Triggerfolge:

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
- FOB-System initialisiert
- MissionGenerator initialisiert
- AICapManager initialisiert
- F10Menu initialisiert
- Main gestartet
- Loader abgeschlossen

Keine erwarteten Fehler:

- `[TC][ERROR]`
- `SCRIPTING ERROR`
- `Mission script error`
- `stack traceback`
- `attempt to index`
- `attempt to call`
- unerwarteter `nil value`

---

## 29. Bestätigter state-first Runtime-Stand

Bestätigt ist inzwischen weit mehr als der ursprüngliche Starttest.

Kampagnenpfad:

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

Mission Failure:

    Mission Failure
    -> Failure Effects
    -> kein Capture Pressure

Persistence:

    dirty-aware
    SAVED
    SKIPPED
    FAILED
    Retry

Priority 3:

    abgeschlossen im dokumentierten Umfang

---

## 30. CTLD und Triggerkette

CTLD wird weiterhin als Vendor-Ressource bei:

    TIME MORE 4

geladen.

Der erfolgreiche CTLD-KI-Truppentransport vom 2026-09-29 benötigte keine Änderung der Vendor-Triggerkette.

Wichtig:

Die temporäre CTLD-Runtime-Konfiguration des Proof-of-Concepts war noch keine produktive Theater-Command-Ladekomponente.

Dazu gehörten:

- Registrierung der Pickup-Zone
- Registrierung der Dropoff-Zone
- Registrierung des KI-Transporters in `ctld.transportPilotNames`

Diese Schritte müssen später durch eigene Theater-Command-Logik automatisiert werden.

Sie werden nicht in:

    vendor/ctld/CTLD.lua

eingebaut.

---

## 31. CTLD-Testzonen

Praktisch verwendeter Pickup:

    CTLD_PICKUP_BLUE_AKROTIRI_01

Praktisch verwendeter technischer Dropoff:

    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01

Reservierter späterer Ercan-Dropoff:

    CTLD_DROPOFF_BLUE_ERCAN_FOB_01

Details:

    mission_editor/ctld_start_zones.md

---

## 32. CTLD-KI-Transport-PoC

Testdatum:

    2026-09-29

Testgruppe:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01

Testunit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

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

Dropoff-Gruppe:

    Dropped Group 2

Group-ID:

    70001

Stärke:

    16 x Soldier M249

---

## 33. Off-Airfield-Landung

Erfolgreiche Mission-Editor-Konfiguration:

    normaler Turning Point
    +
    Perform Task Land

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

Touchdown:

    ungefähr 1.06 m vom Dropoff-Zentrum entfernt

Ein Invisible FARP war dafür nicht erforderlich.

---

## 34. Bekannter CTLD-Runtime-Fehler

Beim Grounded-Übergang wurde reproduziert:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Kontext:

    updateRepackMenu
    updateRepackMenuOnlanding

Der automatische Pickup-/Dropoff-Pfad wurde trotzdem abgeschlossen.

Nicht bewiesen:

- dass der Fehler dauerhaft harmlos ist
- dass der betroffene Scheduler danach weiterläuft

Verbindlich:

    kein Vendor-Patch

Dieser Punkt gehört in die Architektur der späteren produktiven CTLD-Integration.

---

## 35. `.miz`-Einbettung

Bei:

    DO SCRIPT FILE

wird eine Lua-Datei in die `.miz` eingebettet.

Deshalb gilt:

    Repository-Datei geändert
    !=
    Embedded-Ressource automatisch geändert

Nach einer Source-Änderung muss die Mission gezielt aktualisiert und gespeichert werden.

Vor kritischen Runtime-Tests sollte überprüft werden, ob die erwartete Version tatsächlich in der `.miz` liegt.

---

## 36. Embedded Resource Audit

Am 2026-09-12 wurde ein vollständiger relevanter Embedded Resource Audit durchgeführt.

Ergebnis:

    13/13 relevante aktive Theater-Command-Ressourcen EXACT_MATCH

Zusätzlich:

- keine aktiven Byte-Mismatches
- keine aktive Source Drift
- keine fehlenden aktiven Ressourcen im geprüften Bereich

Dieser Audit widerlegte den damaligen Verdacht auf eine veraltete Embedded-Runtime.

Embedded Audits bleiben ein geeignetes Kontrollinstrument.

---

## 37. Lokaler Projektpfad

Lokale Repository-Kopie:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\

GitHub ist Source of Truth.

Die lokale Repository-Kopie muss vor Re-Embed beziehungsweise Mission-Editor-Arbeit aktuell sein.

---

## 38. Entwicklungswerkzeuge

Für Mission-Editor-Arbeit gilt seit 2026-09-29 eine klare Werkzeugtrennung.

Diese Werkzeuge sind Entwicklungswerkzeuge.

Sie sind keine Kampagnen-Runtime-Abhängigkeit.

---

## 39. ChatGPT

ChatGPT übernimmt:

- Projektkoordination
- Architektur
- GitHub-Audit
- Testplanung
- Ergebnisbewertung
- Dokumentationspflege
- Definition der nächsten konkreten Aufgabe
- Erstellung präziser Claude-Prompts

---

## 40. Claude + dcs-mcp

Bevorzugtes Werkzeug für:

- `.miz`-Analyse
- Triggerprüfung
- Gruppenprüfung
- Unit-Prüfung
- Trigger-Zonen
- Wegpunkte
- Tasks
- eingebettete Ressourcen
- gezielte Mission-Editor-Änderungen
- gespeicherten Missionsaudit

Aktuelle Version:

    dcs-mcp 0.9.11

Terrain:

    Syria installiert

Vor Änderungen wird immer zuerst die aktuelle Mission gelesen.

Keine blinde Neuanlage der Mission.

---

## 41. Claude Code + DCS-SMS

Bevorzugtes Werkzeug für lokale Runtime-Diagnose.

Version:

    DCS-SMS 0.27.2

Hook:

    me-bridge-0.27.2

Lokaler Pfad:

    C:\Tools\dcs-sms\dcs-sms.exe

Claude-Code-Skill:

    C:\Users\Paul\.claude\skills\dcs-sms\SKILL.md

Verwendung:

- Mission-Editor-Status
- Runtime-Lua
- Theater-Command-State
- CTLD-State
- Unit-State
- Gruppe
- Position
- Geschwindigkeit
- Grounded/Airborne
- native Aktivierung
- Logs
- Runtime-Regressionen

---

## 42. Verbindlicher Arbeitsablauf

Bei Mission-Editor-/`.miz`-Arbeit:

    1. GitHub aktuellen Stand prüfen
    2. konkrete Aufgabe definieren
    3. aktuelle .miz mit Claude + dcs-mcp öffnen
    4. betroffenen Bereich auditieren
    5. nur die konkrete Änderung durchführen
    6. Mission speichern
    7. gespeicherte Mission erneut prüfen
    8. Runtime-Test vorbereiten
    9. Claude Code + DCS-SMS für lokale Diagnose verwenden
    10. Verhalten in DCS praktisch prüfen
    11. Ergebnis auswerten
    12. bestätigten Stand in GitHub dokumentieren

Pro Schritt:

    eine konkrete Aufgabe

---

## 43. Persistence-Schutz bei Tests

Produktive Save-Datei:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Aktuell bestätigter SHA-256:

    C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596

Wenn ein isolierter Test den produktiven Kampagnenstate beeinflussen könnte:

    Hash prüfen
    -> Backup
    -> Backup prüfen
    -> Save ReadOnly
    -> ReadOnly prüfen
    -> Test
    -> DCS beenden
    -> Hash prüfen
    -> nur bei Match ReadOnly entfernen

Der CTLD-Test vom 2026-09-29 hat den produktiven Save nicht verändert.

---

## 44. DCS-Log

Typische Pfade:

    C:\Users\Paul\Saved Games\DCS\Logs\dcs.log

oder:

    C:\Users\Paul\Saved Games\DCS.openbeta\Logs\dcs.log

Relevante Suchbegriffe:

    [TC]
    [TC][ERROR]
    SCRIPTING ERROR
    Mission script error
    stack traceback
    attempt to index
    attempt to call
    nil value
    MIST
    MOOSE
    CTLD
    Skynet

Nicht jede DCS-Warnung ist ein Theater-Command-Fehler.

---

## 45. MissionScripting.lua

Die lokale Entwicklungsumgebung für Persistence und DCS-SMS benötigt angepasste Sandbox-Freigaben.

Aktuell bestätigte DCS-SMS-Umgebung:

    os=true
    io=true
    lfs=true
    require=false

DCS-Updates können:

    MissionScripting.lua

überschreiben.

Nach DCS-Updates muss die lokale Entwicklungsumgebung erneut geprüft werden.

---

## 46. Loader-only-Variante

Eine alternative Loader-only-Variante mit:

    dofile

wurde bisher nicht als neuer Standard eingeführt.

Sie ist kein aktueller Projektblocker.

Aktuell bleibt:

    sichere Einzeldatei-Ladung

die verbindliche Startstrategie.

---

## 47. Was nicht über Trigger gebaut wird

Die Triggerkette soll nicht erweitert werden, um Kampagnenlogik in den Mission Editor zu verlagern.

Nicht gewünscht:

- Capture-Logik als Triggerkette
- Missionsgenerator als Triggerkette
- Logistiksteuerung als Triggerkette
- AI Director als Triggerkette
- Persistence als Spieler-Triggerworkflow
- CTLD-Orchestrierung als große Triggerkette
- Framework-Patches über Mission-Editor-Skripte

Die Trigger dienen:

- Initialisierung
- technischen Ladeabhängigkeiten
- klar definierten Testfällen

---

## 48. Nächster Trigger-bezogener Schritt

Aktuell ist keine Änderung an der bestehenden Haupt-Ladekette freigegeben.

Die Ladefolge:

    MIST
    -> MOOSE
    -> CTLD-i18n
    -> CTLD
    -> Skynet
    -> Core
    -> World
    -> Campaign
    -> Persistence
    -> Logistics
    -> Missions
    -> AI
    -> UI
    -> Main
    -> Loader

funktioniert.

Der nächste Entwicklungsbereich ist:

    produktive Theater-Command-CTLD-Integration

Erst nach Architekturentscheidung wird festgelegt, ob dafür:

- ein neues fachliches Modul
- eine Erweiterung eines bestehenden Moduls
- und gegebenenfalls ein zusätzlicher Lade-Trigger

notwendig ist.

Keine neue Trigger-Ressource wird vor dieser Entscheidung erfunden.

---

## 49. Aktueller nächster Projektstand

Priority 3:

    abgeschlossen

CTLD-KI-Truppentransport-PoC:

    bestanden

Produktiver Restore:

    weiterhin deaktiviert

Aktueller Entwicklungsbereich:

    Priority 4 – produktive CTLD-Integration vorbereiten

Dabei zu klären:

- fachliche Zuständigkeit unter `src/`
- idempotente CTLD-Zonenregistrierung
- idempotente Transporterregistrierung
- Transporter-Lifecycle
- `RepackCommandsPath`
- Transportauftrag
- Ergebnisvalidierung
- Rückkopplung in Theater-Command-State
- Dirty-Semantik
- Persistence-Grenze

---

## 50. Aktueller Abschluss

Stand:

    2026-09-29

Bestätigt:

- Triggerkette ist funktional.
- Vendor-Ladefolge ist funktional.
- Theater-Command-Ladefolge ist funktional.
- F10Menu ist Bestandteil der aktiven Ladekette.
- Airbase Scanner klassifiziert 225 Airbase-like Objects.
- ZoneFactory erzeugt 46 relevante Kampagnenzonen.
- Background Persistence funktioniert.
- Priority 3 ist abgeschlossen.
- CTLD 1.6.1 ist geladen und praktisch getestet.
- CTLD-KI-Truppentransport-PoC ist bestanden.
- kein neuer CTLD-Vendor-Trigger erforderlich.
- Vendor-Dateien bleiben unverändert.
- Claude + dcs-mcp ist der bevorzugte `.miz`-/Mission-Editor-Pfad.
- Claude Code + DCS-SMS ist der bevorzugte lokale Runtime-Pfad.
- DCS bleibt autoritativer Runtime-Beweis.
- GitHub bleibt Source of Truth.

Die Triggerstruktur ist aktuell kein Blocker.

Der nächste Projektfortschritt liegt in der kontrollierten fachlichen Integration von CTLD in Theater Command.
