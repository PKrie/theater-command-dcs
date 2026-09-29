# Project Overview

## Verbindlicher Projektstand — 2026-09-29

Diese Datei gibt eine Gesamtübersicht über das Projekt **Theater Command DCS**.

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue startet auf Akrotiri / Zypern.
    Das syrische Festland ist zu Kampagnenbeginn rot kontrolliert.

Aktueller Entwicklungsbereich:

    Priority 4 – produktive CTLD-Integration vorbereiten

Priority 3:

    abgeschlossen im dokumentierten Umfang seit 2026-09-21

Verbindlich:

    productiveRestore=false

---

## 1. Projektidee

**Theater Command DCS** soll ein modulares, dynamisches und später persistentes Kampagnensystem für DCS World werden.

Es soll keine einzelne statische Mission entstehen.

Ziel ist ein Kampagnensystem, das aus einem zentralen Zustand heraus unter anderem folgende Bereiche steuert:

- Airbase-Erkennung
- strategische Airbase-Klassifizierung
- Kampagnenzonen
- Ownership
- Capture Pressure
- Capture Progress
- Capture Ready
- Logistik
- Transportaufträge
- FOB-Aufbau
- dynamische Missionsgenerierung
- AI-Reaktionen
- CAP
- Strike
- SEAD / DEAD
- CAS
- Ground Operations
- IADS
- Carrier Operations
- Persistence
- Restore
- Spielerinformation
- Debug-/Admin-Werkzeuge

Der Spieler soll Teil einer laufenden militärischen Lage sein.

Langfristig sollen Blue und Red möglichst eigenständig:

- Missionen erzeugen
- Luftoperationen durchführen
- Bodentruppen bewegen
- Logistik betreiben
- FOBs errichten und versorgen
- CAS anfordern
- Gebiete angreifen und verteidigen
- IADS betreiben
- auf Verluste und Lageveränderungen reagieren

---

## 2. Grundprinzip

Das zentrale Architekturprinzip lautet:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis / Source of Truth
    DCS Runtime = autoritativer Verhaltensbeweis

Der DCS Mission Editor stellt die physische Umgebung bereit.

Dazu gehören unter anderem:

- Karte
- Koalitionen
- Airbases
- Client-Slots
- KI-Gruppen
- Templates
- Trigger
- Trigger-Zonen
- Wegpunkte
- native DCS-Tasks
- Statics
- FARPs
- eingebettete Lua-Ressourcen

Lua übernimmt die dynamische Kampagnenlogik.

GitHub dokumentiert:

- Source
- Architektur
- Entscheidungen
- Versionen
- Aufgabenstand
- Roadmap
- Testergebnisse
- Naming
- bekannte Einschränkungen
- Übergaben zwischen Sessions

DCS selbst entscheidet letztlich, ob tatsächliches Simulator- oder Framework-Verhalten funktioniert.

---

## 3. State-first-Architektur

Die aktuelle Entwicklung folgt bewusst einem:

    state-first

Ansatz.

Reihenfolge:

    State definieren
    -> State erzeugen
    -> State sichtbar machen
    -> State testen
    -> Dirty-Semantik prüfen
    -> Persistence absichern
    -> Framework-Funktion isoliert beweisen
    -> Framework kontrolliert integrieren
    -> Ergebnis validieren
    -> Theater-Command-State aktualisieren
    -> Dirty markieren
    -> persistieren

Frameworks werden nicht zum Eigentümer des Kampagnenzustands.

Theater Command bleibt:

    Campaign Logic
    Decision Layer
    State Owner
    Persistence Owner

Frameworks sind:

    Execution Layer

---

## 4. Aktueller Gesamtstatus

Der state-first Kampagnenkern ist für den aktuellen Entwicklungsstand funktionsfähig.

Bestätigt sind:

- Airbase Scanner
- ZoneFactory
- CaptureSystem
- LogisticsDelivery
- FobSystem
- MissionGenerator
- AICapManager
- F10Menu
- dirty-aware Background Persistence
- Mission Activation
- Mission Completion
- Mission Failure
- Mission Effects
- Capture Pressure
- Capture Progress
- Capture Ready
- Capture Ready Apply
- Zone Ownership
- linked Airbase Ownership
- Logistics State
- FOB State
- AI CAP State
- Persistence Save-/Skip-/Failed-/Retry-Pfade
- Priority-3-Dirty-Coverage im dokumentierten Umfang
- isolierter CTLD-KI-Truppentransport-PoC für den getesteten Aufbau

Noch nicht produktiv vollständig umgesetzt sind insbesondere:

- produktive Theater-Command-CTLD-Orchestrierung
- CTLD Crate-/Cargo-Wirtschaft
- reale CTLD-FOBs
- reale MOOSE-CAP-Flüge
- AI Director
- Ground Campaign
- CAS-Automatisierung
- produktive Skynet-IADS-Kampagnenintegration
- Carrier Operations
- produktiver Startup-Restore
- vollständige Multiplayer-Validierung
- vollständige Blue-/Red-Autonomie

Das Projekt ist damit noch keine fertige Kampagne.

Die technische Grundlage ist jedoch inzwischen weit über einen reinen Starttest hinaus.

---

## 5. Aktuelle Systemversionen

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
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` | KI-Truppentransport-PoC für getesteten Aufbau bestanden |

---

## 6. World Layer

Aktive Dateien:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

### Airbase Scanner

Bestätigte Werte:

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

Bewertung:

- Akrotiri wird als Blue-Startbasis erkannt.
- relevante strategische Airbases werden vorbereitet.
- Medical Pads und einfache Helipads werden nicht als strategische Kampagnenziele behandelt.

### ZoneFactory

Bestätigt:

    relevante Kampagnenzonen: 46
    skipped airbase-like objects: 179

Davon:

    strategic zones: 19
    secondary zones: 13
    heliport zones: 1
    tactical zones: 13
    captureZones: 32
    missionZones: 32
    logisticsZones: 46
    startBaseZones: 1

Nicht alle 225 DCS-Airbase-like Objects werden zu Kampagnenzonen.

---

## 7. CaptureSystem

Datei:

    src/campaign/tc_capture_system.lua

Version:

    v0.2.2

Bestätigt:

- Ownership
- Capture Eligibility
- Capture Pressure
- Capture Progress
- Capture Ready
- Mission Effect Integration
- Capture Apply
- linked Airbase Ownership Sync
- Capture Getter Read-Neutrality
- Ownership No-Op-Neutralität

Bestätigte Grundwerte:

    eligibleBases: 32
    eligibleZones: 32
    pressureRecords: 32
    progressRecords: 32

Bestätigte Pipeline:

    Mission Completion
    -> Mission Effects
    -> Capture Pressure
    -> Capture Progress
    -> Capture Ready
    -> Capture Apply
    -> Zone Ownership
    -> linked Airbase Ownership
    -> Persistence

Mission Failure:

    kein Capture Pressure

---

## 8. LogisticsDelivery

Datei:

    src/logistics/tc_logistics_delivery.lua

Version:

    v0.2.1

Bestätigte Werte:

    Logistics Hubs: 46
    Blue: 7
    Red: 24
    Neutral: 15
    Active: 31
    Limited: 15
    Locked: 0

Priority-3-Ergebnis:

    Read-Neutrality bestanden

Bestätigte read-neutrale Pfade:

    getStatistics()
    getHubSummary()
    summary()

Echte Mutation über:

    createDelivery()

setzt weiterhin spezifischen Dirty-State.

Noch nicht produktiv:

- realer CTLD-Transportauftrag
- Supply-Verbrauch
- Cargo-Wirtschaft
- Logistics -> Capture
- Logistics -> AI

---

## 9. FobSystem

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

Status:

    UNDER_CONSTRUCTION

Priority-3-Ergebnis:

    Read-Neutrality bestanden

Echte Mutation über:

    FobSystem.create()

setzt weiterhin spezifischen Dirty-State.

Die aktuellen FOBs sind Theater-Command-State.

Sie sind noch keine real durch CTLD aufgebauten DCS-FOBs.

---

## 10. MissionGenerator

Datei:

    src/missions/tc_mission_generator.lua

Version:

    v0.2.3

Bestätigte Werte:

    Mission Candidates: 78
    FOB Support Candidates: 2
    Mission Records: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 68

Bestätigt:

- Mission Records
- Objectives
- Briefings
- Progress
- Activation Metadata
- Outcome State
- Effect State
- Activation
- Completion
- Failure
- Capture Effects
- FOB Support Candidates

Missionstatus-Collections sind String-keyed Lua-Dictionaries.

Deshalb ist:

    #table

kein autoritativer Count.

Korrekt ist:

    pairs()

Der frühere Mission-Record-Loss-Verdacht wurde am 2026-09-12 widerlegt.

Es ging kein Mission Record verloren.

Priority-3-Audit:

    kein aktiver Missing-Dirty-Bug
    kein Code-Fix erforderlich

Noch nicht produktiv:

- reale Framework-Missionsausführung
- automatische DCS-Outcome-Erkennung
- vollständige CANCELLED-/EXPIRED-Lifecycle-Integration

---

## 11. AICapManager

Datei:

    src/ai/tc_ai_cap_manager.lua

Version:

    v0.2.1

Bestätigt:

    CAP Candidates: 31
    CAP Zones: 12
    CAP Requests: 12

Priority-3-Ergebnis:

    Read-Neutrality bestanden

Echte Mutation über:

    setCapStatus()

setzt weiterhin:

    dirtyReason=ai_cap_record_changed

Noch nicht aktiv:

    reale MOOSE-CAP-Flüge

Bekannter latenter Punkt:

    reactToActiveMissions()

besitzt aktuell keine produktive Call-Site.

Dieser Pfad wird bei späterer Verdrahtung erneut geprüft.

---

## 12. F10Menu

Datei:

    src/ui/tc_f10_menu.lua

Version:

    v0.2.3

Bestätigt:

    33 Commands

Unter anderem:

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

F10 ist aktuell hauptsächlich:

- Spielerinformation
- Debug
- Status
- kontrollierter Testzugang

F10 soll langfristig nicht alle Hintergrundprozesse manuell auslösen.

---

## 13. PersistenceSystem

Datei:

    src/campaign/tc_persistence_system.lua

Version:

    v0.2.6

Status:

    technisch bestanden
    dirty-aware Background Autosave aktiv
    productiveRestore=false

Bestätigt:

- Dateisystemzugriff
- Campaign Snapshot
- Save
- Read-back
- Compile
- Evaluate
- Validation
- kontrollierter Import
- Embedded Start
- Background Autosave
- `SAVED`
- `SKIPPED`
- kontrollierter `FAILED`
- Retry
- Mission Completion Persistence
- Mission Failure Persistence
- Capture Apply Persistence

Autosave:

    initialDelay=20s
    interval=120s

Persistence ist ein Hintergrundsystem.

Es existiert kein normaler Spieler-F10-Save-/Load-Workflow.

---

## 14. Priority 3 – Dirty-Coverage

Status:

    ABGESCHLOSSEN IM DOKUMENTIERTEN UMFANG

Abschlussdatum:

    2026-09-21

Geprüft beziehungsweise behoben:

- Capture Getter Read-Neutrality
- Capture Ownership No-Op
- LogisticsDelivery Read-Neutrality
- FobSystem Read-Neutrality
- MissionGenerator Dirty-Coverage-Audit
- AICapManager Read-Neutrality

Aktuelle daraus resultierende Versionen:

    LogisticsDelivery v0.2.1
    FobSystem v0.2.1
    AICapManager v0.2.1

Priority 3 ist nicht mehr der aktuelle Entwicklungsbereich.

Latente Lifecycle-Punkte bleiben erhalten und werden erst bei tatsächlicher Verdrahtung gezielt geprüft.

---

## 15. Framework-Basis

Externe Frameworks liegen unter:

    vendor/

Aktuelle Basis:

| Framework | Projektpfad | Stand |
|---|---|---:|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD-i18n | `vendor/ctld/CTLD-i18n.lua` | geladen |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Verbindlich:

    Vendor-Dateien werden nicht verändert.

Aktuell:

- MIST wird verwendet.
- MOOSE ist geladen, aber noch nicht produktiv als Execution Layer angebunden.
- CTLD wurde inzwischen praktisch für einen isolierten KI-Truppentransport getestet.
- Skynet IADS ist geladen, aber noch nicht produktiv als Kampagnensystem angebunden.

---

## 16. CTLD – aktueller Stand

CTLD:

    1.6.1

Status:

    Framework-PoC für KI-Truppentransport bestanden
    produktive Theater-Command-Integration offen

Testdatum:

    2026-09-29

Testmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz

SHA-256 vor Runtime-Test:

    5F0D89DF744A7083401E36713B148BD21813FF187CC36EC1F088507163458C57

Testgruppe:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01

Testunit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Luftfahrzeug:

    Mi-8

---

## 17. CTLD-Zonen

Praktisch verwendeter Pickup:

    CTLD_PICKUP_BLUE_AKROTIRI_01

Technischer Test-Dropoff:

    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01

Reservierter späterer Ercan-Dropoff:

    CTLD_DROPOFF_BLUE_ERCAN_FOB_01

Für den getesteten Runtime-Pfad bestätigt:

Nach bestehender CTLD-Initialisierung konnten normalisierte Einträge ergänzt werden in:

    ctld.pickupZones
    ctld.dropOffZones

Getesteter Pickup:

    { "CTLD_PICKUP_BLUE_AKROTIRI_01", -1, 10000, 1, 2 }

Getesteter Dropoff:

    { "CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01", -1, 2, 1 }

Eine erneute Ausführung von:

    ctld.initialize()

war für diese getestete Runtime-Ergänzung nicht erforderlich.

Daraus wird nicht abgeleitet, dass ein erneuter Aufruf grundsätzlich verboten wäre.

---

## 18. CTLD-KI-Transporterregistrierung

Der Test zeigte:

Der exakte Unit-Name des KI-Transporters musste im relevanten getesteten CTLD-AI-Pfad in:

    ctld.transportPilotNames

registriert sein.

Vor temporärer Registrierung:

    108 Einträge

Danach:

    109 Einträge

Die Testunit war genau einmal vorhanden.

Eine produktive Theater-Command-Integration muss diese Registrierung später:

- automatisch
- idempotent
- duplikatfrei
- lifecycle-sicher

durchführen.

---

## 19. CTLD-KI-Truppentransport-PoC

Für den getesteten Aufbau praktisch bestätigt:

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

Pickup Counter:

    10000 -> 9999

Nicht verwendet:

- manuelles CTLD-Loading
- manuelles CTLD-Unload
- direkte Manipulation des Onboard-State
- Teleport
- Runtime-Routenänderung
- Runtime-Taskänderung

Dropoff erzeugte:

    Dropped Group 2
    Group-ID 70001
    16 x Soldier M249

Dieser Pfad ist ein Framework-Fähigkeitsnachweis für den getesteten Aufbau.

Er ist noch keine produktive Theater-Command-Transportoperation.

---

## 20. CTLD Off-Airfield-Landung

Erfolgreiche gespeicherte Konfiguration:

    normaler Turning Point
    +
    DCS-native Perform Task -> Land

Ziel:

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

Für diesen getesteten Truppentransport war kein Invisible FARP erforderlich.

Der zuvor verwendete ungebundene:

    Land / Landing

Waypoint führte nicht zu einem vollständigen erfolgreichen Transportzyklus.

Die genaue Ursache dieses früheren Verhaltens ist dadurch nicht abschließend bewiesen.

---

## 21. CTLD `RepackCommandsPath`

Beim Touchdown des registrierten KI-Transporters wurde genau einmal beobachtet:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Kontext:

    updateRepackMenu
    updateRepackMenuOnlanding

Während der anschließenden ungefähr 220 Sekunden Bodenbeobachtung wurde der Fehler nicht erneut beobachtet.

Der automatische Pickup-/Dropoff-Pfad wurde trotzdem abgeschlossen.

Nicht bewiesen:

- dass der Fehler harmlos ist
- dass spätere Repack-Menü-Aktualisierungen funktionieren
- dass der betreffende Scheduler definitiv weiterlief
- dass der betreffende Scheduler definitiv beendet wurde

Ein mögliches Ende des Scheduler-Pfads bleibt eine technische Inferenz.

Verbindlich:

    vendor/ctld/CTLD.lua wird nicht gepatcht.

Der Fall muss vor produktiver Integration außerhalb des Vendor-Codes behandelt oder sauber isoliert werden.

---

## 22. Grenze des CTLD-PoC

Der erfolgreiche Test betrifft:

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
- realer CTLD-FOB-Bau
- LogisticsDelivery-Rückkopplung
- FobSystem-Rückkopplung
- Capture-Rückkopplung
- CTLD-Restore
- Multiplayer

Truppentransport und Cargo-/Crate-Integration bleiben getrennte Testbereiche.

---

## 23. Produktive CTLD-Zielarchitektur

Der nächste Architekturübergang lautet:

    Theater-Command-State
    -> Transportauftrag
    -> CTLD-Konfiguration
    -> CTLD-/DCS-Ausführung
    -> Ergebnisvalidierung
    -> Theater-Command-State
    -> Dirty
    -> Persistence

Noch zu klären:

- welche fachliche `src/`-Komponente den Transportauftrag besitzt
- welche Komponente CTLD-Zonen registriert
- welche Komponente Transporter registriert
- wie die Registrierung idempotent bleibt
- wie Transporter-Lifecycle behandelt wird
- wie `RepackCommandsPath` behandelt wird
- wie Erfolg und Fehler erkannt werden
- wie LogisticsDelivery und FobSystem angebunden werden
- welche Resultate persistiert werden
- welche CTLD-Daten runtime-only bleiben
- was später nach Restore rekonstruiert werden muss

Keine generische Datei wie:

    tc_ctld.lua
    tc_ctld_bridge.lua

wird vorschnell angelegt.

---

## 24. Aktuelle DEV-Mission

Technische Entwicklungsmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_DEV.miz

Aktuell enthalten beziehungsweise bestätigt:

- Syria Map
- Modern Coalition Setup
- Akrotiri als Blue-Ausgangspunkt
- F/A-18C Client-Slot
- Vendor-Ladekette
- Theater-Command-Ladekette
- F10Menu
- state-first Campaign Runtime
- Background Persistence

Die DEV-Mission bleibt ein Entwicklungs- und Testträger.

Sie ist noch keine fertige spielbare Kampagne.

Riskante oder isolierte Framework-Experimente können weiterhin in separaten Missionskopien stattfinden.

---

## 25. Mission-Editor-Ladekette

Vendor:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua

Theater Command:

    1. src/core/tc_config.lua
    2. src/core/tc_logger.lua
    3. src/core/tc_state.lua
    4. src/core/tc_utils.lua
    5. src/core/tc_scheduler.lua
    6. src/world/tc_airbase_scanner.lua
    7. src/world/tc_zone_factory.lua
    8. src/campaign/tc_capture_system.lua
    9. src/campaign/tc_persistence_system.lua
    10. src/logistics/tc_logistics_delivery.lua
    11. src/logistics/tc_fob_system.lua
    12. src/missions/tc_mission_generator.lua
    13. src/ai/tc_ai_cap_manager.lua
    14. src/ui/tc_f10_menu.lua
    15. src/main.lua
    16. src/loader.lua

Die sichere Einzeldatei-Ladung über:

    DO SCRIPT FILE

bleibt aktueller Standard.

---

## 26. Embedded Resources

Per:

    DO SCRIPT FILE

geladene Lua-Dateien werden in die `.miz` eingebettet.

Deshalb gilt:

    GitHub-Source geändert
    !=
    Embedded-Ressource automatisch aktualisiert

Nach Source-Änderungen muss die jeweilige Ressource gezielt in der Mission aktualisiert werden.

Embedded Resource Audit vom 2026-09-12:

    13/13 relevante aktive Theater-Command-Ressourcen EXACT_MATCH

Zusätzlich:

- keine relevante aktive Embedded-Source-Drift
- DEV und damalige Testkopie byte-identisch

Historische Altressource:

    ResKey_Action_55
    tc_persistence_system.lua

Status:

- nicht von aktivem Trigger referenziert
- nicht geladen
- kein aktueller Blocker
- späterer Cleanup möglich

---

## 27. Produktive Save-Datei

Produktive Persistence-Datei:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Nach dem isolierten CTLD-Test vom 2026-09-29 bestätigt:

    Größe: 3094967 Bytes

SHA-256:

    C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596

Änderungszeit:

    2026-09-21 15:00:00.5926451

Der isolierte CTLD-Test hat diesen produktiven Save nicht verändert.

Verbindlich:

    productiveRestore=false

---

## 28. Entwicklungswerkzeuge

Seit 2026-09-29 ist die Werkzeugtrennung verbindlich dokumentiert.

Diese Werkzeuge sind Entwicklungs- und Diagnosewerkzeuge.

Sie sind keine Runtime-Abhängigkeiten der fertigen Kampagne.

### ChatGPT

Rolle:

- Projektkoordination
- Architektur
- GitHub-Audit
- Dokumentationsführung
- Testplanung
- Ergebnisbewertung
- Definition des nächsten Einzelschritts

### Claude + dcs-mcp

Version:

    dcs-mcp 0.9.11

Terrain Store:

    C:\Users\Paul\AppData\Local\dcs-mcp\terrain

Syria:

    installiert

Bevorzugt für:

- `.miz`-Analyse
- Mission-Editor-Strukturanalyse
- Gruppen
- Units
- Zonen
- Wegpunkte
- Tasks
- Ressourcen
- gezielte `.miz`-Änderungen
- gespeicherten Missionsaudit

### Claude Code + DCS-SMS

Version:

    DCS-SMS 0.27.2

Hook:

    me-bridge-0.27.2

Verifiziertes Installationsverzeichnis:

    C:\Tools\dcs-sms

Claude-Code-Skill:

    C:\Users\Paul\.claude\skills\dcs-sms\SKILL.md

Bevorzugt für:

- lokale Runtime-Diagnose
- Runtime-Lua
- Theater-Command-State
- CTLD-State
- Unit-/Group-State
- Position
- Geschwindigkeit
- Grounded/Airborne
- Logs
- Runtime-Regressionen

Aus dem bestätigten Stand wird kein exakter DCS-SMS-Executable-Pfad abgeleitet.

---

## 29. Verbindlicher Entwicklungsworkflow

Für Mission-Editor-/Framework-Arbeit:

    GitHub prüfen
    -> eine konkrete Aufgabe definieren
    -> aktuelle .miz mit Claude + dcs-mcp lesen
    -> betroffenen Bereich auditieren
    -> nur konkrete Änderung durchführen
    -> Mission speichern
    -> gespeicherte Mission erneut prüfen
    -> Runtime-Test vorbereiten
    -> Claude Code + DCS-SMS verwenden
    -> reales DCS-Verhalten prüfen
    -> Ergebnis bewerten
    -> bestätigten Stand in GitHub dokumentieren

Pro Schritt:

    eine konkrete Aufgabe
    möglichst eine Datei
    ein klarer Test

---

## 30. Repository-Struktur

Aktuelle Hauptstruktur:

    theater-command-dcs/
    ├── .agents/
    ├── AGENTS.md
    ├── README.md
    ├── ROADMAP.md
    ├── TASKS.md
    ├── CHANGELOG.md
    ├── ARCHITECTURE.md
    ├── MISSION_EDITOR_SETUP.md
    ├── NAMING_CONVENTIONS.md
    ├── LUA_STYLEGUIDE.md
    ├── docs/
    ├── mission_editor/
    ├── src/
    ├── tools/
    └── vendor/

Eigene Lua-Logik liegt unter:

    src/

Vendor-Frameworks liegen unter:

    vendor/

---

## 31. Dokumentationsstruktur

Der Ordner:

    docs/

enthält die fachliche und technische Projektdokumentation.

Aktuelle Fachdocs:

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

Mission-Editor-nahe Dokumentation liegt unter:

    mission_editor/

Aktuell:

    mission_editor/README.md
    mission_editor/trigger_setup.md
    mission_editor/ctld_start_zones.md

Die Dokumentation wird aktuell auf den bestätigten Stand vom 2026-09-29 synchronisiert.

---

## 32. Architekturregeln

Eigene Lua-Logik wird nach Aufgaben sortiert, nicht nach Frameworks.

Nicht gewünscht:

    tc_moose.lua
    tc_mist.lua
    tc_ctld.lua
    tc_ctld_all_in_one.lua
    tc_ctld_bridge.lua
    tc_all_in_one.lua

Gewünscht sind fachliche Module wie:

    tc_airbase_scanner.lua
    tc_zone_factory.lua
    tc_capture_system.lua
    tc_logistics_delivery.lua
    tc_fob_system.lua
    tc_mission_generator.lua
    tc_ai_cap_manager.lua
    tc_persistence_system.lua

Vendor-Dateien werden nicht verändert.

---

## 33. Noch nicht produktiv

Noch nicht produktiv vollständig implementiert:

- reale MOOSE-Spawns
- reale MOOSE-CAP-Flüge
- Strike-/SEAD-/DEAD-Ausführung
- produktive CTLD-Transportaufträge
- CTLD Crate-/Cargo-Wirtschaft
- reale CTLD-FOBs
- Skynet-IADS-Kampagnenintegration
- AI Director
- Ground Campaign
- CAS-Automatisierung
- Carrier Operations
- automatische vollständige Missionserfolgsauswertung
- produktiver Startup-Restore
- Multiplayer
- autonome vollständige Blue-/Red-Kampagnenoperationen

---

## 34. Aktueller nächster Entwicklungsbereich

Priority 3 ist abgeschlossen.

Der CTLD-KI-Truppentransport-PoC ist für den getesteten Aufbau bestanden.

Der nächste technische Bereich ist:

    Priority 4 – produktive CTLD-Integration vorbereiten

Der nächste Schritt ist nicht:

- erneut Priority 3 vollständig auditieren
- denselben Mi-8-PoC erneut durchführen
- CTLD-Vendor patchen
- sofort Crates implementieren
- sofort MOOSE CAP integrieren
- produktiven Restore aktivieren

Zuerst wird die Integrationsarchitektur source-backed geklärt.

Danach wird exakt eine konkrete Integrationsaufgabe beziehungsweise Datei festgelegt.

---

## 35. Aktueller Abschluss

Stand:

    2026-09-29

Bestätigt:

    state-first Kampagnenkern funktioniert.
    Priority 3 ist im dokumentierten Umfang abgeschlossen.
    LogisticsDelivery steht auf v0.2.1.
    FobSystem steht auf v0.2.1.
    AICapManager steht auf v0.2.1.
    MissionGenerator steht auf v0.2.3.
    PersistenceSystem steht auf v0.2.6.
    F10Menu steht auf v0.2.3.
    Mission-Record-Loss-Verdacht ist widerlegt.
    dirty-aware Background Persistence funktioniert.
    productiveRestore=false.
    CTLD 1.6.1 ist geladen und unverändert.
    CTLD-Zonenregistrierung funktioniert für den getesteten Aufbau.
    CTLD-KI-Transporterregistrierung funktioniert für den getesteten Aufbau.
    automatischer CTLD-Pickup funktioniert für den getesteten Aufbau.
    autonomer Mi-8-Transportflug funktioniert für den getesteten Aufbau.
    Off-Airfield-Landung über Perform Task Land funktioniert für den getesteten Aufbau.
    automatischer CTLD-Dropoff funktioniert für den getesteten Aufbau.
    reale Blue-Bodengruppe wurde erzeugt.
    CTLD RepackCommandsPath bleibt bekannter Integrationspunkt.
    Crate-/Cargo-Pfad ist separat ungetestet.
    GitHub bleibt Source of Truth.
    DCS bleibt autoritativer Runtime-Beweis.

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
