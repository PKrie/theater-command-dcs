# Mission Editor Basics

## Verbindlicher Stand — 2026-09-29

Diese Datei beschreibt die grundlegende Rolle des DCS Mission Editors im Projekt **Theater Command DCS**.

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    syrisches Festland zu Kampagnenbeginn rot kontrolliert

Grundprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis / Source of Truth
    DCS Runtime = autoritativer Verhaltensbeweis

---

## 1. Rolle des Mission Editors

Der Mission Editor ist nicht das eigentliche Kampagnensystem.

Er stellt die physische DCS-Welt und technische Startumgebung bereit.

Dazu gehören insbesondere:

- Karte
- Koalitionen
- Client-Slots
- Startpositionen
- Gruppen
- Template-Gruppen
- Trigger
- Trigger-Zonen
- Wegpunkte
- native DCS-Tasks
- statische Objekte
- FARPs
- eingebettete Lua-Ressourcen
- technische Testobjekte

Die eigentliche dynamische Kampagnenlogik liegt unter:

    src/

Der Mission Editor soll nicht übernehmen:

- strategische Kampagnenentscheidungen
- komplexe Capture-Logik
- Missionsgenerierung als Triggerkette
- AI-Entscheidungslogik
- Logistikentscheidungen
- Persistence-Lifecycle
- große dynamische Triggerketten

Verbindlich:

    Der Mission Editor bleibt Bühne.
    Theater Command bleibt Kampagnensystem.

---

## 2. Aktuelle Missionen

Technische Hauptmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_DEV.miz

Isolierte erfolgreiche CTLD-Testmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz

SHA-256 der CTLD-Testmission vor dem erfolgreichen Runtime-Test:

    5F0D89DF744A7083401E36713B148BD21813FF187CC36EC1F088507163458C57

Grundregel:

    Testmission != DEV-Mission

Isolierte Framework-Experimente werden nicht automatisch in die DEV-Mission übernommen.

---

## 3. Aktueller Mission-Editor-Stand

Stand:

    2026-09-29

Aktuell vorhanden beziehungsweise bestätigt:

- Syria Map
- Koalitionspreset Modern
- Akrotiri als Blue-Ausgangspunkt
- F/A-18C Blue Client-Slot
- Vendor-Ladekette
- Theater-Command-Ladekette
- PersistenceSystem `v0.2.6`
- F10Menu `v0.2.3`
- 33 F10 Commands
- Mission Details
- Mission Activation
- Mission Completion
- Mission Failure
- Capture Status
- Capture Ready
- Capture Ready Apply
- Pressure Contested
- Logistics Status
- FOB Status
- AI CAP Status
- dirty-aware Background Persistence
- CTLD-Pickup-Testzone
- CTLD-Dropoff-Testzone
- KI-Mi-8-Testtransporter
- Late Activation
- erfolgreicher Off-Airfield-Landepfad
- automatischer CTLD-Pickup
- automatischer CTLD-Dropoff

Noch nicht produktiv vollständig vorhanden:

- Frontlinie
- vollständige Red-IADS-Struktur
- produktive CTLD-Transportaufträge
- CTLD-Crate-Wirtschaft
- reale CTLD-FOBs
- reale MOOSE-CAP-Flüge
- AI Director
- Ground Campaign
- CAS-Automatisierung
- Carrier Operations
- produktiver Startup-Restore
- vollständige Multiplayer-Validierung

Die DEV-Mission bleibt technischer Entwicklungs- und Testträger.

Sie ist noch keine fertige dynamische Kampagne.

---

## 4. Aktueller technischer Systemstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | Background Persistence bestanden |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.1` | bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.1` | bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | bestanden |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.1` | bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` | KI-Truppentransport-PoC bestanden |

Priority 3:

    abgeschlossen im dokumentierten Umfang

Abschlussdatum:

    2026-09-21

Aktueller Entwicklungsbereich:

    Priority 4 – produktive CTLD-Integration vorbereiten

---

## 5. Koalitionen

Aktuelles DCS-Koalitionspreset:

    Modern

Fachliche Vorgabe:

    Blue startet auf Akrotiri / Zypern.
    Das syrische Festland ist zu Kampagnenbeginn rot kontrolliert.

Diese Konfiguration ist für den aktuellen Entwicklungsstand ausreichend.

Sie kann später erweitert werden, wenn Kampagnendesign oder technische Anforderungen dies notwendig machen.

---

## 6. Spieler-Slot

Aktueller erster Blue-Client-Slot:

    CLIENT_BLUE_FA18C_AKROTIRI_01

Eigenschaften:

    Flugzeug: F/A-18C Lot 20
    Koalition: Blue
    Land: USA
    Startbasis: Akrotiri
    Skill: Client

Da es sich um einen Client-Slot handelt, wird beim manuellen Runtime-Test:

    Mission starten
    -> Client-Slot auswählen
    -> bestätigen
    -> Briefing
    -> Fly

verwendet.

Der Slot dient aktuell vor allem:

- Runtime-Start
- F10-Tests
- State-Tests
- Persistence-Tests
- Log-Auswertung

Er ist noch kein finaler Kampagnen-Slot.

Perspektivisch können unter anderem hinzukommen:

- F/A-18C
- F-14
- F-15E
- A-10C II
- AH-64D
- weitere Module nach Bedarf

---

## 7. Lokales Repository

Lokaler Repository-Pfad auf dem DCS-PC:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\

GitHub bleibt:

    Source of Truth

Die lokale Repository-Kopie muss vor Mission-Editor-Arbeit aktuell sein.

---

## 8. Embedded Lua Resources

Bei:

    DO SCRIPT FILE

wird die ausgewählte Lua-Datei in die `.miz` eingebettet.

Deshalb gilt:

    GitHub Source geändert
    !=
    Embedded-Ressource in der .miz automatisch geändert

Nach Source-Änderungen muss die betroffene Missionsressource gezielt aktualisiert und die Mission gespeichert werden.

---

## 9. Embedded Resource Audit

Auditdatum:

    2026-09-12

Ergebnis:

    13/13 relevante aktive Theater-Command-Ressourcen EXACT_MATCH

Zusätzlich bestätigt:

- keine relevanten aktiven Byte-Mismatches
- keine aktive Embedded-Runtime-Drift
- DEV und damalige Testkopie beim Audit byte-identisch

Der Audit beweist den Zustand zum Auditzeitpunkt.

Er bedeutet nicht, dass spätere GitHub-Änderungen automatisch in die `.miz` übernommen werden.

---

## 10. Persistence-Ressource

Aktiver Trigger:

    TC_LOAD_TC_PERSISTENCE_SYSTEM

Typ:

    ONCE

Bedingung:

    TIME MORE 15

Aktive Persistence-Version:

    v0.2.6

Aktive Embedded-Ressource:

    tc_persistence_system_v0_2_6.lua

Bekannte historische Altressource:

    ResKey_Action_55
    tc_persistence_system.lua

Letzter bestätigter Status:

- alter Trigger-Verweis entfernt
- Ressource noch als verwaister Eintrag vorhanden
- von keinem aktiven Trigger referenziert
- nicht geladen
- kein aktueller Runtime-Blocker

Ein späteres Cleanup ist möglich.

Es ist derzeit kein Entwicklungsblocker.

---

## 11. Vendor-Frameworks

Externe Frameworks liegen unter:

    vendor/

Aktuelle Basis:

| Framework | Pfad | Stand |
|---|---|---:|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD-i18n | `vendor/ctld/CTLD-i18n.lua` | geladen |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Verbindlich:

    Vendor-Dateien werden nicht verändert.

---

## 12. Framework-Ladefolge

Getestete Reihenfolge:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua

Wichtig:

    MIST vor CTLD
    CTLD-i18n vor CTLD.lua
    Theater Command nach Vendor-Frameworks

---

## 13. Eigene Source-Ladung

Aktiv:

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
    src/ui/tc_f10_menu.lua
    src/main.lua
    src/loader.lua

Vorbereitet, aber noch nicht produktiv:

    src/iads/
    src/debug/

Eigene Logik bleibt nach fachlicher Aufgabe organisiert.

Nicht gewünscht:

    tc_moose.lua
    tc_mist.lua
    tc_ctld.lua
    tc_ctld_all_in_one.lua
    tc_ctld_bridge.lua
    tc_all_in_one.lua

---

## 14. Sichere Einzeldatei-Ladung

Aktueller Standard:

    Starttest-Variante A

Methode:

    DO SCRIPT FILE

Status:

    bestanden

Vorteile:

- klare Ladefolge
- klare Fehlereingrenzung
- einfache Embedded-Ressourcenprüfung
- keine zusätzliche `dofile`-Abhängigkeit
- im realen DCS-Betrieb bestätigt

Eine Loader-only-Variante ist aktuell kein Projektblocker.

---

## 15. Trigger-Grundstruktur

Die aktive Ladevariante verwendet grundsätzlich:

    Typ: ONCE
    Ereignis: NO EVENT
    Bedingung: TIME MORE
    Aktion: DO SCRIPT FILE

Die einzelnen Trigger werden zeitlich versetzt ausgelöst.

---

## 16. Aktuelle Trigger-Reihenfolge

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

Details:

    mission_editor/trigger_setup.md

---

## 17. Aktueller Starttest

Status:

    BESTANDEN

Bestätigt:

- MIST geladen
- MOOSE geladen
- CTLD-i18n geladen
- CTLD geladen
- Skynet IADS geladen
- Theater-Command-Core geladen
- Airbase Scanner geladen
- ZoneFactory geladen
- CaptureSystem geladen
- PersistenceSystem geladen
- LogisticsDelivery geladen
- FobSystem geladen
- MissionGenerator geladen
- AICapManager geladen
- F10Menu geladen
- Main gestartet
- Runtime-Systeme initialisiert
- Loader sauber beendet

---

## 18. World-Ergebnis

Airbase Scanner:

    total: 225
    strategic: 19
    secondary: 13
    heliports: 1
    helipads: 95
    medical: 40
    tactical: 13
    unknown: 44
    captureCandidates: 32
    missionCandidates: 32
    logisticsCandidates: 46
    blueStartBases: 1
    redStrategicCandidates: 18

ZoneFactory:

    relevante Kampagnenzonen: 46
    skipped airbase-like objects: 179
    captureZones: 32
    missionZones: 32
    logisticsZones: 46
    startBaseZones: 1

Die frühere Interpretation, dass alle 225 Airbase-like Objects direkt Kampagnenzonen werden müssten, ist nicht mehr gültig.

---

## 19. Campaign- und Logistics-Ergebnis

CaptureSystem:

    eligibleBases: 32
    eligibleZones: 32
    pressureRecords: 32
    progressRecords: 32

LogisticsDelivery:

    Version: v0.2.1
    Logistics Hubs: 46
    Blue: 7
    Red: 24
    Neutral: 15
    Active: 31
    Limited: 15

FobSystem:

    Version: v0.2.1
    FOB Candidates: 6
    Blue FOBs: 2

Blue FOBs:

    FOB Ercan
    FOB Gecitkale

Diese FOBs sind aktuell state-only.

---

## 20. Mission- und AI-Ergebnis

MissionGenerator:

    Version: v0.2.3
    Mission Candidates: 78
    FOB Support Candidates: 2
    Mission Records: 10

AICapManager:

    Version: v0.2.1
    CAP Candidates: 31
    CAP Zones: 12
    CAP Requests: 12

Noch keine:

    realen MOOSE-CAP-Flüge

---

## 21. Mission-State-Dictionaries

Die Mission-Collections sind String-keyed Lua-Dictionaries.

Dazu gehören:

    available
    active
    completed
    failed
    expired
    cancelled

Deshalb ist:

    #table

für diese Collections kein autoritativer Count.

Korrekte Zählung erfolgt über:

    pairs()

beziehungsweise pairs-basierte Hilfsfunktionen.

Der frühere Mission-Record-Loss-Verdacht wurde am 2026-09-12 widerlegt.

Es gingen keine Mission Records verloren.

---

## 22. F10Menu

Version:

    v0.2.3

Commands:

    33

Bestätigt:

- Show Available Missions
- Show Active Missions
- Mission Details 1–10
- Mission Activation 1–10
- Active Mission Outcome Status
- Complete Active Mission 1
- Fail Active Mission 1
- Campaign Status
- Capture Status
- Capture Ready Zones
- Apply Capture Ready Zone 1
- Pressure Contested Zones
- Logistics Status
- FOB Status
- AI CAP Status

F10 ist aktuell vor allem:

- Statuszugang
- Debugzugang
- kontrollierter Testzugang

Die spätere Kampagne soll nicht davon abhängen, dass Spieler jeden Hintergrundprozess manuell über F10 auslösen.

---

## 23. Bestätigte Kampagnenpipeline

Bestätigt:

    Mission Details
    -> Mission Activation
    -> Mission Completion
    -> Mission Effects
    -> Capture Pressure
    -> Capture Progress
    -> Capture Ready
    -> Capture Ready Apply
    -> Zone Ownership
    -> linked Airbase Ownership
    -> Background Autosave

Failure-Pfad:

    Mission Activation
    -> Mission Failure
    -> Failure Effects
    -> kein Capture Pressure
    -> Background Autosave

---

## 24. Persistence

PersistenceSystem:

    v0.2.6

Bestätigt:

- Save
- Read-back
- Compile
- Evaluate
- Validation
- kontrollierter Import
- Background Autosave
- `SAVED`
- `SKIPPED`
- kontrollierter `FAILED`
- Retry

Autosave:

    initialDelay=20s
    interval=120s

Verbindlich:

    productiveRestore=false

Persistence ist ein Hintergrundsystem.

Es existiert kein normales Spieler-F10-Save-/Load-Menü.

---

## 25. Priority 3

Status:

    ABGESCHLOSSEN IM DOKUMENTIERTEN UMFANG

Abschluss:

    2026-09-21

Bestätigt:

- Capture Getter Read-Neutrality
- Capture Ownership No-Op
- LogisticsDelivery Read-Neutrality
- FobSystem Read-Neutrality
- MissionGenerator Audit ohne aktiven Missing-Dirty-Bug
- AICapManager Read-Neutrality

Aktuelle Versionen:

    LogisticsDelivery v0.2.1
    FobSystem v0.2.1
    AICapManager v0.2.1

Priority 3 ist nicht mehr der aktuelle Entwicklungsbereich.

---

## 26. CTLD-Zonen

Die frühere Aussage:

    keine CTLD-Zonen

ist nicht mehr korrekt.

Praktisch verwendeter Pickup:

    CTLD_PICKUP_BLUE_AKROTIRI_01

Radius:

    250 m

Technischer Test-Dropoff:

    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01

Zentrum:

    x / North = -29249.110954281
    z / East  = -271836.070539260

Radius:

    60 m

Reservierter späterer Ercan-Dropoff:

    CTLD_DROPOFF_BLUE_ERCAN_FOB_01

Details:

    mission_editor/ctld_start_zones.md

---

## 27. CTLD Runtime-Zonenregistrierung

CTLD:

    1.6.1

Praktisch bestätigt:

Nach der bestehenden CTLD-Initialisierung können normalisierte Einträge ergänzt werden in:

    ctld.pickupZones
    ctld.dropOffZones

Getesteter Pickup-Eintrag:

    { "CTLD_PICKUP_BLUE_AKROTIRI_01", -1, 10000, 1, 2 }

Getesteter Dropoff-Eintrag:

    { "CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01", -1, 2, 1 }

Eine erneute Ausführung von:

    ctld.initialize()

war für diesen getesteten Pfad nicht erforderlich.

---

## 28. CTLD KI-Transporter

Erfolgreiche Testgruppe:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01

Testunit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Luftfahrzeug:

    Mi-8

Startkonfiguration im Test:

- Akrotiri
- H4
- Hot Start
- Late Activation

Wichtiger CTLD-Befund:

Der exakte Unit-Name musste im getesteten CTLD-AI-Pfad in:

    ctld.transportPilotNames

registriert sein.

Vor Registrierung:

    108 Einträge

Danach:

    109 Einträge

Die Testunit war genau einmal vorhanden.

Eine produktive Theater-Command-Integration muss diese Registrierung später automatisch und idempotent durchführen.

---

## 29. CTLD automatischer Pickup

Status:

    BESTANDEN

Nach nativer Aktivierung:

- 16 Soldaten automatisch aufgenommen
- Pickup-Counter `10000 -> 9999`

Nicht verwendet:

- manuelles CTLD-Loading
- direkte Manipulation von `ctld.inTransitTroops`
- Teleport
- Runtime-Routenänderung

Damit ist der automatische CTLD-KI-Pickup für den getesteten Aufbau bestätigt.

---

## 30. Off-Airfield-Landung

Der erfolgreiche Mission-Editor-Aufbau war:

    normaler Turning Point
    +
    Perform Task -> Land

Dropoff-Zentrum:

    x / North = -29249.110954281
    z / East  = -271836.070539260

Wegpunkt:

    Höhe: 100 m BARO
    Geschwindigkeit: 30 m/s

Land Task:

    duration=300
    durationFlag=true

Bestätigte minimale Entfernung zum Dropoff-Zentrum:

    ungefähr 1.06 m

Ein Invisible FARP war für diesen getesteten Truppentransport nicht erforderlich.

Der vorherige ungebundene:

    Land / Landing

Waypoint hatte keinen vollständigen erfolgreichen Transportzyklus ergeben.

Die genaue Ursache des damaligen Turnbacks ist damit nicht abschließend bewiesen.

---

## 31. CTLD automatischer Dropoff

Status:

    BESTANDEN

Nach der Landung:

- transportierte Truppen wurden aus dem In-Transit-State entfernt
- `ctld.droppedTroopsBLUE` erhielt einen neuen Eintrag
- reale Blue-Bodengruppe wurde erzeugt

Gruppe:

    Dropped Group 2

Group-ID:

    70001

Stärke:

    16 x Soldier M249

Bestätigter technischer Pfad:

    Pickup
    -> Taxi
    -> Takeoff
    -> Transit
    -> Off-Airfield-Landung
    -> Dropoff
    -> Bodengruppe

---

## 32. Grenze des CTLD-PoC

Der Test bestätigt:

    Framework-Fähigkeit

Er bestätigt noch nicht:

    produktive Theater-Command-CTLD-Orchestrierung

Noch offen:

- automatischer Transportauftrag aus TC-State
- produktive LogisticsDelivery-Kopplung
- produktive FobSystem-Kopplung
- Crate Spawn
- Crate Loading
- Sling Load
- Crate Drop
- Supply Cargo
- Engineering Cargo
- Repair Cargo
- Fuel Cargo
- Ammo Cargo
- realer FOB-Bau
- CTLD-Restore
- Multiplayer

Der bestandene Test war:

    KI-Truppentransport

und kein:

    Cargo-/Crate-PoC

---

## 33. Bekannter CTLD-Integrationspunkt

Beim Grounded-Übergang wurde beobachtet:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Kontext:

    updateRepackMenu
    updateRepackMenuOnlanding

Pickup und Dropoff wurden trotzdem erfolgreich abgeschlossen.

Nicht bewiesen:

- dass der Fehler langfristig harmlos ist
- dass der betroffene Scheduler danach vollständig weiterläuft

Verbindlich:

    vendor/ctld/CTLD.lua wird nicht gepatcht.

Die Lösung muss außerhalb des Vendor-Codes liegen.

---

## 34. Produktive Save-Datei beim CTLD-Test

Produktive Save-Datei:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Bestätigter SHA-256:

    C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596

Größe:

    3094967 Bytes

Beim CTLD-Test wurde die Datei temporär geschützt.

Nach dem Test bestätigt:

- Größe unverändert
- Änderungszeit unverändert
- SHA-256 unverändert
- produktiver Campaign-State unverändert

Final:

    ReadOnly=False

---

## 35. Was aktuell nicht im Mission Editor produktiv gebaut wird

Noch nicht produktiv vollständig gebaut:

- komplette Frontlinie
- vollständige Syria-Befüllung
- produktive IADS-Großstruktur
- produktive CTLD-FOB-Infrastruktur
- CTLD-Crate-Wirtschaft
- produktive MOOSE-Templates
- reale MOOSE-CAP-Flüge
- Ground-Operation-Templates
- Carrier Task Group
- vollständige Client-Slot-Struktur
- automatischer Startup-Restore

Wichtig:

CTLD-Testzonen und der Mi-8-Testtransporter existieren beziehungsweise wurden in der isolierten Testmission verwendet.

Daher ist die ältere pauschale Aussage:

    keine CTLD-Zonen

nicht mehr gültig.

---

## 36. Spätere Mission-Editor-Elemente

Perspektivisch können benötigt werden:

- zusätzliche Client-Slots
- produktive Pickup-Zonen
- produktive Dropoff-Zonen
- FOB-Bauzonen
- Late-Activation-Templates
- MOOSE-Air-Templates
- Red-SAM-Gruppen
- Red-EWR-Gruppen
- Skynet-IADS-Sites
- statische Missionsziele
- Logistikobjekte
- Ground-Operation-Templates
- Carrier-Gruppe
- Debug-Testobjekte

Diese Elemente werden erst angelegt, wenn ein konkreter Entwicklungsschritt sie erfordert.

---

## 37. Starttest-Variante B

Konzept:

    Loader-only mit dofile

Status:

    nicht aktueller Standard

Mögliche spätere Prüfung:

- funktioniert `dofile` robust im DCS Mission Scripting Environment?
- ist ein reduziertes Trigger-Setup sinnvoll?
- wird eine Build-Datei benötigt?
- wie verhält sich die Sandbox?

Bis dahin bleibt:

    sichere Einzeldatei-Ladung

der bestätigte Standard.

---

## 38. Entwicklungswerkzeuge

Seit 2026-09-29 ist die Werkzeugtrennung verbindlich.

Diese Werkzeuge sind:

    Entwicklungs- und Diagnosewerkzeuge

Sie sind keine:

    Runtime-Abhängigkeiten der fertigen Kampagne

---

## 39. ChatGPT

Rolle:

- Projektkoordination
- Architektur
- GitHub-Audit
- Dokumentationspflege
- Testplanung
- Ergebnisbewertung
- Definition des nächsten Einzelschritts
- Vorbereitung präziser Claude-Aufträge

ChatGPT ersetzt keinen realen DCS-Runtime-Test.

---

## 40. Claude + dcs-mcp

Bevorzugtes Werkzeug für:

- `.miz`-Analyse
- Mission-Editor-Strukturanalyse
- Gruppen
- Units
- Trigger-Zonen
- Wegpunkte
- Tasks
- Airbase-Zuordnungen
- gezielte Missionsänderungen
- gespeicherten Missionsaudit

Version:

    dcs-mcp 0.9.11

Terrain Store:

    C:\Users\Paul\AppData\Local\dcs-mcp\terrain

Syria-Terrain:

    installiert

Grundregel:

Vor einer Mission-Editor-Änderung wird die aktuelle `.miz` zuerst gelesen.

Es wird keine Mission blind neu aufgebaut.

---

## 41. Claude Code + DCS-SMS

Bevorzugtes Werkzeug für lokale Runtime-Diagnose.

DCS-SMS:

    0.27.2

Hook:

    me-bridge-0.27.2

Verifiziertes Installationsverzeichnis:

    C:\Tools\dcs-sms

Claude-Code-Skill:

    C:\Users\Paul\.claude\skills\dcs-sms\SKILL.md

Verwendung:

- Mission-Editor-Status
- Mission Environment
- Runtime-Lua
- Theater-Command-Live-State
- CTLD-Live-State
- Gruppen-State
- Unit-State
- Position
- Geschwindigkeit
- Grounded-/Airborne-State
- Logs
- Runtime-Regressionen

DCS-SMS ist kein Theater-Command-Framework.

---

## 42. Verbindlicher Mission-Editor-Workflow

Für `.miz`-/Mission-Editor-Arbeit:

    GitHub aktuellen Stand prüfen
    -> konkrete Aufgabe definieren
    -> aktuelle .miz mit Claude + dcs-mcp lesen
    -> betroffenen Bereich auditieren
    -> nur die konkrete Änderung durchführen
    -> Mission speichern
    -> gespeicherte Mission erneut prüfen
    -> Runtime-Test vorbereiten
    -> Claude Code + DCS-SMS für Live-Diagnose verwenden
    -> DCS-Verhalten praktisch prüfen
    -> Ergebnis bewerten
    -> bestätigten Stand in GitHub dokumentieren

Pro Schritt:

    eine konkrete Aufgabe

Keine großen parallelen Mission-Editor-Umbauten.

---

## 43. DCS als Runtime-Beweis

Offline-Strukturanalyse kann beweisen:

- gespeicherte Gruppen
- Units
- Zonen
- Wegpunkte
- Tasks
- Trigger
- eingebettete Ressourcen

Sie beweist allein nicht:

- AI-Taxi
- Takeoff
- Navigation
- Landung
- CTLD-Pickup
- CTLD-Dropoff
- reale Spawns
- Scheduler-Verhalten

Diese Punkte werden in DCS selbst bestätigt.

---

## 44. MissionScripting.lua

Persistence und DCS-SMS benötigen lokale Sandbox-Freigaben.

Aktuell dokumentierte Entwicklungsumgebung:

    os=true
    io=true
    lfs=true
    require=false

Persistence benötigt direkt insbesondere:

    io
    lfs

DCS-Updates können lokale Anpassungen an:

    MissionScripting.lua

überschreiben.

Nach DCS-Updates müssen deshalb Persistence- und DCS-SMS-Voraussetzungen erneut geprüft werden.

---

## 45. DCS-Log

Typische Pfade:

    C:\Users\Paul\Saved Games\DCS.openbeta\Logs\dcs.log

oder:

    C:\Users\Paul\Saved Games\DCS\Logs\dcs.log

Wichtige Suchbegriffe:

    [TC]
    [TC][ERROR]
    ERROR
    FAILED
    stack traceback
    attempt to index
    attempt to call
    nil value
    MIST
    MOOSE
    CTLD
    Skynet
    PersistenceSystem
    CaptureSystem
    MissionGenerator
    F10Menu

Ein einzelner DCS-interner Warnhinweis ist nicht automatisch ein Theater-Command-Fehler.

Der Zusammenhang zum getesteten System ist entscheidend.

---

## 46. Aktueller nächster Mission-Editor-Bereich

Priority 3 ist abgeschlossen.

Der CTLD-KI-Truppentransport-PoC ist bestanden.

Der nächste Entwicklungsschritt ist nicht:

- Mission Editor großflächig ausbauen
- denselben Mi-8-Test wiederholen
- CTLD-Vendor patchen
- sofort Crates einbauen
- sofort MOOSE CAP parallel integrieren
- produktiven Restore aktivieren

Der nächste Projektbereich ist:

    Priority 4 – produktive CTLD-Integration vorbereiten

Vor weiteren Mission-Editor-Änderungen muss die Integrationsarchitektur definiert werden.

Zu klären:

- welche fachliche `src/`-Komponente CTLD-Konfiguration übernimmt
- wie Zonen idempotent registriert werden
- wie KI-Transporter idempotent registriert werden
- wie Transporter-Lifecycle behandelt wird
- wie `RepackCommandsPath` ohne Vendor-Patch behandelt wird
- wie Transportaufträge entstehen
- wie Erfolg und Fehler validiert werden
- wie Ergebnisse in LogisticsDelivery und FobSystem zurückgeführt werden
- welche Resultate Dirty setzen
- welche Daten persistiert werden
- welche CTLD-Daten runtime-only bleiben

Erst danach ergibt sich die nächste konkrete `.miz`-Änderung.

---

## 47. Aktueller Abschlussstand

Stand:

    2026-09-29

Mission-Editor-Grundlage:

    ausreichend und bestanden

Starttest Variante A:

    bestanden

State-first Kampagnenkern:

    bestanden

Priority 3:

    abgeschlossen im dokumentierten Umfang

Persistence:

    v0.2.6
    dirty-aware
    productiveRestore=false

CTLD:

    1.6.1
    KI-Truppentransport-PoC bestanden
    produktive Theater-Command-Integration offen

Bestätigter CTLD-Pfad:

    Runtime-Zonenregistrierung
    -> Transporterregistrierung
    -> Pickup
    -> Taxi
    -> Takeoff
    -> Transit
    -> Off-Airfield-Landung
    -> automatischer Dropoff
    -> reale Bodengruppe

Werkzeugrollen:

    ChatGPT
    -> Projektkoordination / Architektur

    Claude + dcs-mcp
    -> .miz / Mission Editor

    Claude Code + DCS-SMS
    -> lokale Runtime-Diagnose

    DCS
    -> autoritativer Runtime-Beweis

    GitHub
    -> Source of Truth

Aktueller Übergang:

    state-first Kampagnenkern
    +
    abgeschlossene Dirty-Coverage
    +
    bestandener CTLD-KI-Transport-PoC
    ->
    kontrollierte produktive CTLD-Integration
