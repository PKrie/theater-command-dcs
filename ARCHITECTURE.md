# ARCHITECTURE – Theater Command DCS

## Verbindlicher Architekturstand — 2026-09-29

Dieses Dokument beschreibt die technische Gesamtarchitektur von **Theater Command DCS**.

Repository:

    https://github.com/PKrie/theater-command-dcs

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Kampagnenausgangslage:

    Blue startet auf Zypern / Akrotiri.
    Das syrische Festland ist zu Beginn rot kontrolliert.

Aktueller Entwicklungsbereich:

    Priority 4 – produktive CTLD-Integration vorbereiten

Priority 3:

    abgeschlossen im dokumentierten Umfang seit 2026-09-21

Verbindlich:

    productiveRestore=false

---

# 1. Architekturgrundsatz

Theater Command DCS folgt vier zentralen Grundsätzen:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis / Source of Truth
    DCS Runtime = autoritativer Verhaltensbeweis

Der Mission Editor stellt die konkrete DCS-Welt bereit.

Dazu gehören unter anderem:

- Karte
- Koalitionen
- Client-Slots
- KI-Gruppen
- Templates
- Trigger
- Trigger-Zonen
- Wegpunkte
- native Tasks
- Statics
- Airbases
- FARPs
- eingebettete Lua-Ressourcen

Die eigene Lua-Logik unter:

    src/

bildet das eigentliche Kampagnensystem.

GitHub enthält den verbindlichen Projektstand.

DCS selbst entscheidet letztlich, ob Simulator- und Framework-Verhalten tatsächlich funktionieren.

---

# 2. Langfristiges Zielbild

Theater Command DCS soll langfristig eine dynamische und persistente Kampagne ermöglichen.

Der Spieler soll Teil des Systems sein und nicht dessen alleiniger Auslöser.

Blue und Red sollen perspektivisch möglichst autonom:

- Missionen erzeugen
- Luftoperationen durchführen
- CAP bereitstellen
- Strike fliegen
- SEAD / DEAD durchführen
- Bodentruppen bewegen
- CAS anfordern
- Transporte durchführen
- FOBs aufbauen
- Versorgung durchführen
- Nachschubwege schützen
- gegnerische Logistik angreifen
- IADS betreiben
- auf Verluste reagieren
- Gebiete erobern und verlieren

Der Spieler kann:

- Missionen übernehmen
- in laufende Operationen eingreifen
- die Kampagnenlage beeinflussen

Die Kampagne soll langfristig nicht davon abhängen, dass der Spieler jede Hintergrundoperation manuell auslöst.

---

# 3. Modulprinzip

Eigene Logik wird nach fachlicher Aufgabe organisiert.

Nicht nach Framework.

Gewünschte Beispiele:

    tc_airbase_scanner.lua
    tc_zone_factory.lua
    tc_capture_system.lua
    tc_logistics_delivery.lua
    tc_fob_system.lua
    tc_mission_generator.lua
    tc_ai_cap_manager.lua
    tc_persistence_system.lua

Nicht gewünscht:

    tc_moose.lua
    tc_mist.lua
    tc_ctld.lua
    tc_ctld_all_in_one.lua
    tc_ctld_bridge.lua
    tc_all_in_one.lua

Ein fachliches Modul darf intern ein Framework verwenden.

Beispiel:

    tc_logistics_delivery.lua

darf später CTLD als Execution Layer verwenden.

Es wird deshalb nicht zu einem generischen:

    tc_ctld.lua

umgebaut.

---

# 4. Vendor-Prinzip

Externe Frameworks liegen unter:

    vendor/

Aktuell:

    vendor/mist/
    vendor/moose/
    vendor/ctld/
    vendor/skynet-iads/

Verbindliche Regel:

    vendor/ ist unverändert zu lassen.

Aktive Frameworks:

    MIST
    MOOSE
    CTLD
    Skynet IADS

Bestätigte Versionen:

    MIST            4.5.128-DYNSLOTS-02
    MOOSE           2.9.17
    CTLD            1.6.1
    Skynet IADS     3.3.0

Framework-Anpassungen erfolgen über eigene Theater-Command-Logik unter:

    src/

Nicht über Vendor-Patches.

---

# 5. Framework-Grenze

Verbindliche Trennung:

    Theater Command
    =
    Campaign Logic
    Decision Layer
    State Owner

Frameworks:

    MIST
    MOOSE
    CTLD
    Skynet IADS

sind:

    Execution Layer
    technische Werkzeuge

Beispiel:

    Theater Command entscheidet:
    Transport erforderlich

    CTLD führt aus:
    Transport

    Theater Command validiert:
    Ergebnis

    Theater Command aktualisiert:
    TC.State

---

# 6. State-first-Architektur

Der Entwicklungsansatz ist bewusst:

    state-first

Grundfluss:

    State
    -> Intent
    -> Execution
    -> Result Validation
    -> State Mutation
    -> Dirty
    -> Persistence

Neue Systeme werden grundsätzlich in dieser Reihenfolge entwickelt:

1. Domain-State definieren.
2. State erzeugen.
3. State sichtbar machen.
4. State testen.
5. Dirty-Semantik prüfen.
6. Persistence prüfen.
7. Framework-Fähigkeit isoliert testen.
8. Framework kontrolliert anbinden.
9. Ergebnis validieren.
10. Theater-Command-State aktualisieren.

Framework-Runtime ist nicht automatisch Campaign State.

---

# 7. Aktive Systemarchitektur

Aktuelle bestätigte Module:

| Layer | System | Datei | Version |
|---|---|---|---:|
| Core | Config | `src/core/tc_config.lua` | aktiv |
| Core | Logger | `src/core/tc_logger.lua` | aktiv |
| Core | State | `src/core/tc_state.lua` | aktiv |
| Core | Utils | `src/core/tc_utils.lua` | aktiv |
| Core | Scheduler | `src/core/tc_scheduler.lua` | aktiv |
| World | Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` |
| World | ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` |
| Campaign | CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` |
| Campaign | PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` |
| Logistics | LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.1` |
| Logistics | FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.1` |
| Missions | MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` |
| AI | AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.1` |
| UI | F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` |

Zusätzlich aktiv:

    src/main.lua
    src/loader.lua

Vorbereitet, aber noch ohne produktives eigenes Lua-Modul:

    src/iads/
    src/debug/

---

# 8. Core Layer

Pfad:

    src/core/

Aufgaben:

- Konfiguration
- Logging
- globaler Theater-Command-State
- Utility-Funktionen
- Scheduling
- gemeinsame Infrastruktur
- Dirty-State-Grundlage

Core enthält keine fachliche:

- Capture-Logik
- Logistics-Logik
- MissionGenerator-Logik
- AI-Entscheidung
- CTLD-Orchestrierung
- IADS-Strategie

---

## 8.1 State

Zentrale Runtime-Struktur:

    TC.State

Der State ist die autoritative Kampagnenrepräsentation innerhalb einer laufenden Mission.

Wichtige Bereiche:

    World
    Campaign
    Missions
    Logistics
    AI
    Persistence
    Meta

String-keyed Lua-Dictionaries dürfen nicht autoritativ mit:

    #

gezählt werden.

Korrekt:

    pairs()

beziehungsweise eine pairs-basierte Count-Hilfe.

Der frühere vermeintliche Mission-Record-Verlust wurde am 2026-09-12 als Count-Fehler widerlegt.

Es gingen keine Mission Records verloren.

---

# 9. World Layer

Pfad:

    src/world/

Aktive Systeme:

    tc_airbase_scanner.lua
    tc_zone_factory.lua

---

## 9.1 Airbase Scanner

Version:

    v0.2.2

Aufgabe:

- DCS-Airbase-like Objects erfassen
- klassifizieren
- für Kampagnensysteme bereitstellen

Bestätigt:

    Airbase-like Objects: 225

Nicht jedes dieser Objekte ist ein strategischer Kampagnenflugplatz.

---

## 9.2 ZoneFactory

Version:

    v0.2.0

Aufgabe:

- relevante Kampagnenzonen erzeugen
- World-Daten fachlich filtern
- Mission-Editor-Zonen integrieren

Bestätigt:

    relevante Kampagnenzonen: 46
    Capture Candidates: 32
    Mission Candidates: 32
    Logistics Candidates: 46

ZoneFactory bildet die Grenze zwischen:

    rohen DCS-Weltobjekten

und:

    relevanten Theater-Command-Zonen

---

# 10. Campaign Layer

Pfad:

    src/campaign/

Aktive Systeme:

    tc_capture_system.lua
    tc_persistence_system.lua

---

# 11. CaptureSystem

Version:

    v0.2.2

Aufgaben:

- Zone Ownership
- Base Ownership
- Capture Eligibility
- Capture Pressure
- Capture Progress
- Capture Ready
- Mission Effects
- Ownership Apply
- linked Airbase Synchronisation

Bestätigter Pfad:

    Mission Completion
    -> Mission Effects
    -> Capture Pressure
    -> Capture Progress
    -> Capture Ready
    -> Capture Apply
    -> Zone Ownership
    -> Airbase Ownership
    -> Persistence

Mission Failure erzeugt aktuell bewusst:

    keinen Capture Pressure

Bestätigt:

    eligibleBases: 32
    eligibleZones: 32
    pressureRecords: 32
    progressRecords: 32

---

## 11.1 Capture Dirty-Semantik

Bestätigt:

- Getter bleiben dirty-neutral.
- echte Capture-Mutationen setzen Dirty.
- same-owner Ownership-Aufrufe sind echte No-Ops.
- redundante Ownership-Aufrufe verändern keinen persistenten State.

Damit sind sowohl Read-Neutrality als auch Ownership-No-Op für den getesteten Umfang bestätigt.

---

# 12. PersistenceSystem

Version:

    v0.2.6

Persistence ist ein internes Hintergrundsystem.

Sie ist kein normaler Spieler-F10-Workflow.

Bestätigt:

- Save
- Read-back
- Compile
- Evaluate
- Validation
- kontrollierter Import
- dirty-aware Background Autosave
- `SAVED`
- `SKIPPED`
- kontrollierter `FAILED`
- Retry

Scheduler:

    Initial Delay: 20 s
    Intervall: 120 s

Verbindlich:

    productiveRestore=false

---

## 12.1 Save-Datei

Produktive Datei:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Nach dem isolierten CTLD-Test bestätigt:

    Größe: 3094967 Bytes

SHA-256:

    C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596

Änderungszeit:

    2026-09-21 15:00:00.5926451

Der CTLD-Test vom 2026-09-29 veränderte die produktive Save-Datei nicht.

---

## 12.2 Produktiver Restore

Technische Importfähigkeit ist vorhanden.

Produktiver Startup-Restore bleibt deaktiviert.

Vor:

    productiveRestore=true

müssen mindestens geklärt und getestet werden:

- Restore-/Initialisierungsreihenfolge
- Save-Versionierung
- Save-Kompatibilität
- Modul-Lifecycle
- Framework-Rekonstruktion
- Schutz vor doppelten Framework-Aktionen
- kontrollierter End-to-End-Restore

---

# 13. Dirty-State-Architektur

Persistence speichert nicht blind jeden Scheduler-Tick.

Prinzip:

    State-Mutation
    -> markDirty(reason)
    -> Autosave
    -> Write
    -> Read-back
    -> Compile
    -> Evaluate
    -> Validation
    -> Dirty löschen

Regeln:

    echte persistierbare Mutation
    -> Dirty

    reiner Read
    -> kein Dirty

    echter No-Op
    -> kein Dirty

Ein fehlgeschlagener Save darf Dirty nicht löschen.

---

## 13.1 Priority 3

Priority 3 wurde am:

    2026-09-21

im dokumentierten Umfang abgeschlossen.

Bestätigt beziehungsweise behoben:

    Capture Read-Neutrality
    Capture Ownership No-Op
    LogisticsDelivery Read-Neutrality
    FobSystem Read-Neutrality
    AICapManager Read-Neutrality
    MissionGenerator Dirty-Coverage ohne aktiven Missing-Dirty-Fund

Aktuelle Versionen:

    LogisticsDelivery v0.2.1
    FobSystem v0.2.1
    MissionGenerator v0.2.3
    AICapManager v0.2.1

Latente Lifecycle-Punkte werden erst bei tatsächlicher Verdrahtung erneut geprüft.

---

# 14. Logistics Layer

Pfad:

    src/logistics/

Aktive Systeme:

    tc_logistics_delivery.lua
    tc_fob_system.lua

---

## 14.1 LogisticsDelivery

Version:

    v0.2.1

Bestätigt:

    Hubs: 46
    Blue: 7
    Red: 24
    Neutral: 15
    Active: 31
    Limited: 15
    Locked: 0

Aufgaben:

- Logistics Hubs
- Delivery State
- spätere Supply-Logik
- Daten für FOB
- Daten für MissionGenerator
- Daten für AI
- spätere CTLD-Integration
- Persistence

Read-Neutrality:

    bestanden

Echte Mutation:

    createDelivery()

setzt weiterhin einen fachlichen Dirty-State.

---

## 14.2 FobSystem

Version:

    v0.2.1

Bestätigt:

    FOB Candidates: 6
    Blue FOBs: 2

FOBs:

    FOB Ercan
    FOB Gecitkale

Status:

    UNDER_CONSTRUCTION

Diese FOBs existieren aktuell als:

    Theater-Command-State

und noch nicht als:

    real durch CTLD gebaute DCS-FOBs

Read-Neutrality:

    bestanden

---

# 15. Mission Layer

Pfad:

    src/missions/

Aktiv:

    tc_mission_generator.lua

Version:

    v0.2.3

Bestätigt:

    Mission Candidates: 78
    Mission Records: 10
    FOB Support Candidates: 2

Statuswechsel:

    AVAILABLE -> ACTIVE
    ACTIVE -> COMPLETED
    ACTIVE -> FAILED

Aufgaben:

- Mission Candidates
- Mission Records
- Objectives
- Briefings
- Activation
- Completion
- Failure
- Cancellation
- Expiry
- Effect State
- reservierte Framework Hooks

Noch nicht produktiv:

- reale Missionsausführung über Frameworks
- automatische Outcome-Erkennung über DCS Events

---

## 15.1 Mission-Record-Diagnose

Mission-Status-Collections sind:

    String-keyed Lua-Dictionaries

Deshalb gilt:

    pairs()

statt:

    #

für autoritative Counts.

Am 2026-09-12 bestätigt:

    statistics.available = 10
    pairs()-Count = 10
    #available = 0

Der frühere Mission-Record-Loss war eine Fehldiagnose.

---

# 16. AI Layer

Pfad:

    src/ai/

Aktiv:

    tc_ai_cap_manager.lua

Version:

    v0.2.1

Bestätigt:

    CAP Candidates: 31
    CAP Zones: 12
    CAP Requests: 12

Status:

    state-first
    Read-Neutrality bestanden

Noch nicht produktiv:

    reale MOOSE CAP-Spawns
    vollständiger AI Director

`reactToActiveMissions()` besitzt aktuell keine produktive Call-Site.

Der Pfad wird erst bei tatsächlicher Verdrahtung erneut geprüft.

---

# 17. UI Layer

Pfad:

    src/ui/

Aktiv:

    tc_f10_menu.lua

Version:

    v0.2.3

Bestätigt:

    33 Commands

Unter anderem verfügbar:

- Missionen anzeigen
- Mission Details
- Mission Activation
- Mission Completion
- Mission Failure
- Campaign Status
- Capture Status
- Capture Ready
- Pressure Contested
- Capture Apply
- Logistics Status
- FOB Status
- AI CAP Status

F10 dient aktuell hauptsächlich:

- Spielerinformation
- Debug
- Entwicklung
- kontrollierten Testaktionen

F10 ist nicht der langfristige Motor der Kampagne.

---

# 18. Main und Loader

Aktiv:

    src/main.lua
    src/loader.lua

Aufgaben:

- Framework-Verfügbarkeit prüfen
- Theater-Command-Systeme starten
- Fehler sichtbar machen
- Runtime-Status registrieren

Aktuelle Mission-Editor-Ladekette:

## Vendor

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua

## Theater Command

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

Die sichere Einzeldatei-Ladekette bleibt aktuell der Standard.

---

# 19. CTLD-Integrationsarchitektur

CTLD:

    Version 1.6.1

Rolle:

    Execution Layer

Am 2026-09-29 wurde erstmals ein vollständiger realer CTLD-KI-Truppentransport für einen isolierten getesteten Aufbau bestätigt.

Status:

    Framework-Proof-of-Concept bestanden

Noch nicht:

    produktive Theater-Command-CTLD-Integration

---

## 19.1 Testmission

Erfolgreiche isolierte Testmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz

SHA-256 vor dem Test:

    5F0D89DF744A7083401E36713B148BD21813FF187CC36EC1F088507163458C57

Getesteter Transporter:

    Mi-8

Gruppe:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01

Unit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

---

## 19.2 CTLD-Zonen

Bestätigter Pickup:

    CTLD_PICKUP_BLUE_AKROTIRI_01

Technische Test-Dropoff-Zone:

    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01

Reservierter späterer FOB-Dropoff:

    CTLD_DROPOFF_BLUE_ERCAN_FOB_01

Für den getesteten Runtime-Pfad konnten nach bestehender CTLD-Initialisierung normalisierte Einträge ergänzt werden in:

    ctld.pickupZones
    ctld.dropOffZones

Getesteter Pickup-Eintrag:

    { "CTLD_PICKUP_BLUE_AKROTIRI_01", -1, 10000, 1, 2 }

Getesteter Dropoff-Eintrag:

    { "CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01", -1, 2, 1 }

Eine erneute Ausführung von:

    ctld.initialize()

war für diesen getesteten Pfad nicht erforderlich.

Daraus wird nicht abgeleitet, dass ein erneuter Aufruf grundsätzlich verboten wäre.

---

## 19.3 KI-Transporterregistrierung

Der getestete KI-Transporter musste für den relevanten CTLD-AI-Pfad in:

    ctld.transportPilotNames

registriert sein.

Vor Registrierung:

    108 Einträge

Danach:

    109 Einträge

Testunit:

    genau einmal vorhanden

Eine produktive Integration muss diese Registrierung:

- automatisch
- idempotent
- duplikatfrei
- lifecycle-sicher

durchführen.

---

# 20. CTLD-KI-Truppentransport-PoC

Für den getesteten Aufbau bestätigt:

    Runtime-Zonenregistrierung
    -> Transporterregistrierung
    -> automatischer Pickup
    -> Taxi
    -> Takeoff
    -> Transit
    -> Off-Airfield-Anflug
    -> Landung
    -> automatischer CTLD-Dropoff
    -> reale Blue-Bodengruppe

Pickup:

    16 x Soldier M249

Pickup Counter:

    10000 -> 9999

Dropoff erzeugte:

    Dropped Group 2
    Group-ID 70001
    16 x Soldier M249

Nicht verwendet:

- manuelles CTLD-Loading
- direkte Onboard-State-Manipulation
- Teleport
- Runtime-Routenänderung
- Runtime-Taskänderung

Der Test bestätigt Framework-Fähigkeit.

Er bestätigt noch keine produktive Theater-Command-Orchestrierung.

---

# 21. Off-Airfield-Landearchitektur

Erfolgreicher getesteter Aufbau:

    normaler Turning Point
    +
    DCS-native Perform Task -> Land

Ziel:

    x / North = -29249.110954281
    z / East  = -271836.070539260

Wegpunkt:

    100 m BARO
    30 m/s

Land Task:

    duration=300
    durationFlag=true

Touchdown:

    ungefähr 1.06 m vom Dropoff-Zentrum

Der Mi-8 blieb danach mindestens ungefähr:

    220 Sekunden

am Boden.

Der volle konfigurierte 300-Sekunden-Zeitraum musste nicht abgewartet werden, da der CTLD-Dropoff vorher eindeutig abgeschlossen war.

Für diesen getesteten KI-Truppentransport war:

    kein Invisible FARP erforderlich

Daraus wird nicht abgeleitet, dass ein FARP für:

- Cargo-/Crate-Pfade
- andere Luftfahrzeuge
- reale FOB-Infrastruktur
- andere CTLD-Funktionen

grundsätzlich unnötig wäre.

Ein früherer ungebundener:

    Land / Landing

Waypoint führte nicht zu einem vollständigen erfolgreichen Transportzyklus.

Die genaue Ursache dieses früheren Verhaltens ist nicht abschließend bewiesen.

---

# 22. CTLD `RepackCommandsPath`

Genau einmal beim **Touchdown** des registrierten KI-Transporters wurde beobachtet:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Stack-Kontext:

    updateRepackMenu
    updateRepackMenuOnlanding

Während der anschließenden ungefähr:

    220 Sekunden

Bodenbeobachtung trat der Fehler nicht erneut auf.

Source-basierte Einordnung:

- die KI-Unit befindet sich in `ctld.transportPilotNames`
- dadurch erreicht sie einen CTLD-Landing-/Menüpfad
- `ctld.vehicleCommandsPath[_unitName]` ist für reine KI-Units nicht zwingend vorhanden
- daraus kann `RepackCommandsPath=nil` entstehen

Pickup und Dropoff wurden trotzdem erfolgreich abgeschlossen.

Nicht bewiesen:

- dass der Fehler harmlos ist
- dass spätere Repack-Menü-Updates funktionieren
- dass der betreffende Scheduler weiterlief
- dass der betreffende Scheduler beendet wurde

Ein möglicher Scheduler-Abbruch ist:

    technische Source-Inferenz

und kein:

    direkter Runtime-Beweis

Verbindlich:

    vendor/ctld/CTLD.lua wird nicht gepatcht.

Die spätere Integrationsstrategie muss den Fall außerhalb des Vendor-Codes behandeln oder isolieren.

---

# 23. CTLD-Testgrenze

Der erfolgreiche PoC war:

    KI-Truppentransport

Nicht damit bewiesen:

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
- produktive LogisticsDelivery-Kopplung
- produktive FobSystem-Kopplung
- CTLD-Restore
- Multiplayer
- beliebige andere Transportflugzeuge
- beliebige andere Landezonen

Truppentransport-PoC und Cargo-/Crate-PoC bleiben getrennte Testbereiche.

---

# 24. Theater Command ↔ CTLD Grenze

Aktuell:

    Theater Command State

und:

    CTLD Runtime

sind noch nicht produktiv gekoppelt.

Zielarchitektur:

    Kampagnenentscheidung
    -> Transportauftrag
    -> Transporter auswählen
    -> CTLD-Zonen registrieren
    -> Transporter registrieren
    -> Route / Task
    -> Pickup
    -> Transport
    -> Landung
    -> Dropoff
    -> Ergebnis validieren
    -> TC.State aktualisieren
    -> Dirty
    -> Persistence

Theater Command bleibt:

    Campaign Logic
    Decision Layer
    State Owner

CTLD bleibt:

    Execution Layer

---

# 25. Cargo-/Crate-Architektur

Cargo und Crates sind noch nicht praktisch bestätigt.

Separat zu testen:

- Crate Spawn
- Crate Loading
- Sling Load
- Crate Drop
- Supply
- Engineering
- Repair
- Fuel
- Ammo
- FOB Core

Ein erfolgreicher Truppentransport ist kein Beleg für diese Pfade.

---

# 26. FOB-Zielarchitektur

Aktuelle state-first FOBs:

    FOB Ercan
    FOB Gecitkale

Status:

    UNDER_CONSTRUCTION

Perspektivischer Pfad:

    MissionGenerator
    -> Logistics Auftrag
    -> CTLD Execution
    -> Delivery Validation
    -> LogisticsDelivery
    -> FobSystem
    -> Build Progress
    -> FOB Activation
    -> Dirty
    -> Persistence

Dieser Pfad ist noch nicht produktiv implementiert.

---

# 27. MOOSE-Zielarchitektur

MOOSE soll später reale AI-Air-Assets bereitstellen.

Unter anderem:

- CAP
- GCI
- Strike
- SEAD
- DEAD
- CAS
- Escort
- Carrier Air Wing

AICapManager beziehungsweise später AI Director bleiben:

    Decision / State Layer

MOOSE wird:

    Execution Layer

Aktuell gibt es noch keine produktiven Theater-Command-MOOSE-CAP-Flüge.

---

# 28. IADS-Zielarchitektur

Vendor:

    Skynet IADS 3.3.0

Später soll Skynet unter anderem technische:

- SAM-Steuerung
- EWR
- Netzwerkverhalten
- Abschaltlogik
- Bedrohungsreaktion

übernehmen.

Theater Command soll dagegen fachlich verwalten:

- Besitz
- Site-State
- Beschädigung
- Missionswirkungen
- Repair
- Persistence
- AI-Entscheidungen

Aktuell existiert noch kein produktives eigenes Theater-Command-IADS-Modul.

---

# 29. AI Director

Ein vollständiger AI Director existiert noch nicht.

Später soll er unter anderem auswerten:

- Ownership
- Capture Pressure
- Frontlage
- Logistics
- FOBs
- Missionsstate
- CAP-State
- Verluste
- IADS
- Bedrohungsniveau
- verfügbare Ressourcen

und daraus operative Entscheidungen erzeugen.

Die aktuellen State-Systeme bilden dafür die Grundlage.

---

# 30. Bodentruppen und CAS

Langfristiger Datenfluss:

    Ground Operation
    -> Gegnerkontakt
    -> Unterstützungsbedarf
    -> CAS Request
    -> MissionGenerator / AI Director
    -> verfügbare Luftfahrzeuge
    -> reale Mission
    -> Ergebnis
    -> Ground State

Dieses System ist noch Zukunftsarchitektur.

---

# 31. Carrier Operations

Perspektivisch vorgesehen:

- Supercarrier
- F/A-18C
- F-14
- weitere Carrier-fähige Module
- Carrier CAP
- Strike
- Escort
- Fleet Defense
- Carrier Logistics

Der Carrier soll operativer Bestandteil der Kampagne werden.

Nicht lediglich statische Kulisse.

Noch nicht implementiert.

---

# 32. Entwicklungswerkzeuge

Die Entwicklungswerkzeuge sind keine Runtime-Abhängigkeiten der fertigen Kampagne.

---

## 32.1 ChatGPT

Rolle:

- Projektkoordination
- Architektur
- GitHub-Audit
- Dokumentationsführung
- Testplanung
- Ergebnisbewertung
- Definition des nächsten Einzelschritts
- Vorbereitung präziser Arbeitsaufträge

---

## 32.2 Claude + dcs-mcp

Version:

    dcs-mcp 0.9.11

Terrain Store:

    C:\Users\Paul\AppData\Local\dcs-mcp\terrain

Syria:

    installiert

Rolle:

- `.miz` analysieren
- Mission-Editor-Struktur prüfen
- Gruppen
- Units
- Zonen
- Wegpunkte
- Tasks
- Ressourcen
- gezielte Missionsänderungen
- gespeicherte Mission auditieren

dcs-mcp beweist gespeicherte Missionsstruktur.

Es ersetzt nicht den DCS-Runtime-Test.

---

## 32.3 Claude Code + DCS-SMS

DCS-SMS:

    0.27.2

Hook:

    me-bridge-0.27.2

Verifiziertes Installationsverzeichnis:

    C:\Tools\dcs-sms

Claude-Code-Skill:

    C:\Users\Paul\.claude\skills\dcs-sms\SKILL.md

Rolle:

- DCS-/ME-Status
- Runtime-Lua
- Theater-Command-Live-State
- CTLD-Live-State
- Unit-/Group-State
- Position
- Geschwindigkeit
- Airborne/Grounded
- Logs
- Runtime-Regressionen

Aus dem bestätigten Stand wird kein exakter Executable-Pfad wie:

    C:\Tools\dcs-sms\dcs-sms.exe

als verifiziert abgeleitet.

---

## 32.4 DCS

DCS selbst ist der autoritative Runtime-Beweis.

Nur reale Runtime-Beobachtung kann zuverlässig beweisen:

- Taxi
- Takeoff
- Navigation
- Landung
- Pickup
- Dropoff
- Spawn
- Scheduler-Verhalten
- tatsächliche AI-Reaktion

---

## 32.5 GitHub

GitHub bleibt:

    Source of Truth
    Projektgedächtnis

Neue Sessions beginnen mit dem aktuellen Repository-Stand.

Nicht mit einem alten Chatstand.

---

# 33. Evidenzklassen

Unterschiedliche Evidenzarten werden getrennt behandelt.

## Source-Befund

Beweist:

- vorhandene Logik
- Call-Sites
- Datenpfade
- mögliche Fehlerpfade

## Gespeicherte Missionsstruktur

Beweist:

- Gruppen
- Units
- Zonen
- Wegpunkte
- Tasks
- Trigger
- Embedded Resources

## Runtime-Beobachtung

Beweist:

- tatsächliches DCS-Verhalten
- AI-Bewegung
- Pickup
- Takeoff
- Landung
- Dropoff
- Spawns
- Live-State

## Technische Inferenz

Ist eine begründete Schlussfolgerung.

Sie darf nicht als direkter Runtime-Beweis formuliert werden.

---

# 34. Missionsdatei-Trennung

Produktive Entwicklungsmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_DEV.miz

Isolierte erfolgreiche CTLD-Testmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz

Grundsatz:

    Testmission != DEV-Mission

Erkenntnisse aus Testmissionen werden erst kontrolliert in die DEV-Architektur übernommen.

---

# 35. Embedded Resources

`DO SCRIPT FILE` bettet Lua-Dateien in die `.miz` ein.

Deshalb:

    GitHub Source geändert
    !=
    Embedded Mission Resource automatisch geändert

Nach relevanten Source-Änderungen:

- Embedded-Ressource aktualisieren
- Mission speichern
- gespeicherte Mission prüfen
- bei Bedarf Source-/Embedded-Match auditieren

Letzter dokumentierter vollständiger Audit:

    2026-09-12

Ergebnis:

    13/13 relevante aktive Theater-Command-Ressourcen EXACT_MATCH

Der Audit gilt nur für den damals geprüften Missionsstand.

---

# 36. Persistence-Schutz bei isolierten Tests

Wenn ein Framework-Test den produktiven Campaign-State beeinflussen könnte:

    Save-Hash prüfen
    -> Backup
    -> Backup-Hash prüfen
    -> produktiven Save ReadOnly setzen
    -> ReadOnly bestätigen
    -> Test durchführen
    -> DCS vollständig beenden
    -> Save erneut hashen
    -> Hash vergleichen
    -> nur bei Match ReadOnly entfernen
    -> final erneut prüfen

Dieses Verfahren wurde beim CTLD-Test vom 2026-09-29 erfolgreich verwendet.

---

# 37. Verbindlicher Entwicklungsworkflow

Für `.miz`-/Framework-Arbeit:

    GitHub prüfen
    -> eine konkrete Aufgabe definieren
    -> Akzeptanzkriterium definieren
    -> aktuelle Mission lesen
    -> nur erforderliche Änderung durchführen
    -> Mission speichern
    -> gespeicherte Mission erneut auditieren
    -> Runtime-Test vorbereiten
    -> DCS-Runtime beobachten
    -> Ergebnis bewerten
    -> Dokumentation aktualisieren

Grundregel:

    eine Aufgabe
    eine Datei
    ein Test
    eine klare Bewertung

---

# 38. Aktueller Datenfluss

Aktuell bestätigt:

    DCS World
    -> AirbaseScanner
    -> ZoneFactory
    -> Capture / Logistics
    -> FOB
    -> MissionGenerator
    -> AICapManager
    -> F10 / Persistence

Mission Outcome:

    MissionGenerator
    -> Mission Effect
    -> CaptureSystem
    -> Capture Pressure
    -> Capture Ready
    -> Ownership
    -> Persistence

CTLD technisch bestätigt für den getesteten Aufbau:

    CTLD Runtime Configuration
    -> AI Transporter
    -> Pickup
    -> Flight
    -> Land
    -> Dropoff
    -> Ground Group

Noch fehlend:

    Theater Command State
    -> Transport Intent
    -> CTLD Execution
    -> Result Validation
    -> Theater Command State

Diese Rückkopplung ist der zentrale Architekturpunkt von Priority 4.

---

# 39. Bewusst noch nicht produktiv

Noch nicht produktiv:

- Startup Restore
- MOOSE-Spawns
- Theater-Command-CTLD-Orchestrierung
- CTLD Crate Economy
- CTLD FOB Build
- Skynet-Kampagnenintegration
- AI Director
- automatische Missionserfolgsauswertung
- Ground Campaign
- CAS-Automatisierung
- Carrier Operations
- Multiplayer

Diese Bereiche dürfen nicht als bereits implementiert dokumentiert werden.

---

# 40. Priority 4

Aktueller Entwicklungsbereich:

    produktive CTLD-Integration vorbereiten

Vor dem ersten produktiven CTLD-Code-Schritt ist zu entscheiden:

1. Welche fachliche Komponente besitzt den Transportauftrag?
2. Welche Komponente registriert CTLD-Zonen?
3. Welche Komponente registriert Transporter?
4. Wann erfolgt die Registrierung?
5. Wie bleibt sie idempotent?
6. Wie wird der Transporter-Lifecycle behandelt?
7. Wie wird Pickup erkannt?
8. Wie wird Erfolg erkannt?
9. Wie wird Fehler erkannt?
10. Wie wird `RepackCommandsPath` behandelt oder isoliert?
11. Wie werden Ergebnisse in Theater Command zurückgeführt?
12. Welche Mutationen setzen Dirty?
13. Welche Daten werden persistiert?
14. Welche CTLD-Daten bleiben runtime-only?
15. Was wird nach Restore rekonstruiert?

Erst danach wird eine konkrete neue Source-Datei festgelegt.

Keine vorschnelle generische:

    tc_ctld.lua
    tc_ctld_bridge.lua
    tc_ctld_all_in_one.lua

---

# 41. Neue Sessions

Neue Sessions beginnen mit einem GitHub-Audit.

Mindestens:

    README.md
    ROADMAP.md
    TASKS.md
    CHANGELOG.md
    ARCHITECTURE.md

Je nach Thema zusätzlich:

    AGENTS.md
    .agents/skills/theater-command/SKILL.md
    MISSION_EDITOR_SETUP.md
    LUA_STYLEGUIDE.md
    docs/
    mission_editor/
    src/*/README.md

GitHub ist autoritativ.

---

# 42. Architekturleitsatz

Theater Command DCS folgt weiterhin:

    State zuerst.
    Frameworks als Execution Layer.
    Vendor unverändert.
    Kleine isolierte Schritte.
    DCS Runtime entscheidet über tatsächliches Simulatorverhalten.
    GitHub hält den bestätigten Projektstand fest.

Aktueller Übergang:

    stabiler state-first Kampagnenkern
    +
    dirty-aware Persistence
    +
    abgeschlossene Priority-3-Dirty-Coverage
    +
    bestandener CTLD-KI-Truppentransport-PoC für den getesteten Aufbau
    ->
    kontrollierte produktive CTLD-Integration
