# Mission Generator

## Verbindlicher Stand — 2026-09-29

Diese Datei beschreibt den Mission Generator von **Theater Command DCS**.

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

MissionGenerator:

    v0.2.3

Status:

    bestanden für den aktuellen state-first Funktionsumfang

---

## 1. Zweck des Mission Generators

Der Mission Generator erzeugt Missionen aus dem aktuellen Kampagnenzustand.

Missionen sollen langfristig nicht als starre, voneinander unabhängige Mission-Editor-Aufgaben entstehen.

Sie sollen aus der aktuellen Kampagnenlage abgeleitet werden.

Relevante Einflussfaktoren sind beziehungsweise sollen später sein:

- Airbase-Klassifizierung
- Zonenstatus
- Ownership
- Capture Eligibility
- Capture Pressure
- Capture Progress
- Capture Ready
- Logistics Hubs
- FOB-State
- AI-State
- IADS-State
- Kampagnenphase
- Missionshistorie
- verfügbare Assets
- Spieleraktivität
- Persistence

Der Mission Generator ist damit Teil des:

    Decision / Intent Layer

Er führt reale DCS-Aktionen aktuell noch nicht selbst aus.

---

## 2. Architekturprinzip

Der Mission Generator folgt dem allgemeinen Theater-Command-Prinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis / Source of Truth
    DCS Runtime = autoritativer Verhaltensbeweis

Zusätzlich gilt:

    Theater Command = Campaign Logic / State Owner
    Frameworks = Execution Layer

MissionGenerator entscheidet beziehungsweise beschreibt:

    was getan werden soll

Frameworks sollen später ausführen:

    wie es in DCS geschieht

Beispiele:

    CAP Intent
    -> MOOSE Execution

    Transport Intent
    -> CTLD / DCS Execution

    IADS Suppression Intent
    -> Skynet-/DCS-bezogene Execution

MissionGenerator bleibt Eigentümer des Missionsobjekts, nicht des Framework-Runtime-State.

---

## 3. Aktive Datei

Datei:

    src/missions/tc_mission_generator.lua

Version:

    v0.2.3

Status:

    state-first funktional bestanden

Bestätigt:

- MissionGenerator lädt.
- MissionGenerator startet.
- MissionGenerator erzeugt Mission Candidates.
- MissionGenerator erzeugt zehn Mission Records.
- MissionGenerator berücksichtigt FOB-Support.
- MissionGenerator erzeugt Objectives.
- MissionGenerator erzeugt Briefings.
- MissionGenerator erzeugt Progress-Strukturen.
- MissionGenerator erzeugt Activation Metadata.
- MissionGenerator erzeugt Outcome State.
- MissionGenerator erzeugt Effect State.
- MissionGenerator reserviert Framework Hooks.
- Mission Details funktionieren.
- Mission Activation funktioniert.
- Mission Completion funktioniert.
- Mission Failure funktioniert.
- Mission Effects funktionieren.
- Completion kann Capture Pressure erzeugen.
- Failure erzeugt aktuell bewusst keinen Capture Pressure.
- MissionGenerator bleibt state-only.
- Priority-3-Audit ist abgeschlossen.
- aus Priority 3 war kein MissionGenerator-Code-Fix erforderlich.

---

## 4. Bestätigte Kernwerte

Aktuell bestätigt:

    mission candidates: 78
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 68

Mission Records:

    10

F10Menu:

    v0.2.3

F10 Commands:

    33

---

## 5. Mission-Collections sind Dictionaries

Die Mission-Status-Collections sind String-keyed Lua-Dictionaries.

Dazu gehören:

    State.Missions.available
    State.Missions.active
    State.Missions.completed
    State.Missions.failed
    State.Missions.expired
    State.Missions.cancelled

Keys sehen beispielsweise aus wie:

    MISSION_1
    MISSION_2
    MISSION_3

Deshalb ist:

    #table

für diese Collections nicht autoritativ.

Korrekte Zählung erfolgt über:

    pairs()

beziehungsweise pairs-basierte Hilfsfunktionen.

---

## 6. Auflösung des früheren Mission-Record-Loss-Verdachts

Am 2026-08-04 wurde zeitweise angenommen, Mission Records würden während der Runtime verschwinden.

Dieser Verdacht wurde am:

    2026-09-12

widerlegt.

Live bestätigt:

    TC.State.Missions.statistics.available = 10
    pairs()-Count von available = 10
    #TC.State.Missions.available = 0

Die Mission Records waren vorhanden.

Der Fehler lag in der Diagnose beziehungsweise in:

    src/core/tc_state.lua
    State.summary()

Dort wurden String-keyed Mission-Dictionaries teilweise mit:

    #

gezählt.

Der Fix führte eine pairs-basierte Zählung ein.

Ergebnis:

    kein bestätigter Mission-Record-Datenverlust

MissionGenerator selbst benötigte für dieses Problem keinen Fix.

---

## 7. Embedded Resource Audit

Der Offline Embedded Resource Audit vom 2026-09-12 schloss eine aktive Embedded-Runtime-Drift als Ursache des damaligen Mission-Record-Verdachts aus.

Bestätigt:

    13/13 relevante aktive Theater-Command-Ressourcen EXACT_MATCH

Zusätzlich:

- DEV und damalige Testkopie waren beim Audit byte-identisch.
- keine aktive relevante Embedded-Source-Drift.
- keine fehlende aktive MissionGenerator-Ressource.

Bekannte historische Altressource:

    ResKey_Action_55
    tc_persistence_system.lua

Diese Ressource ist:

- verwaist
- nicht durch einen aktiven Trigger referenziert
- nicht geladen
- kein MissionGenerator-Problem

---

## 8. Datenquellen des Mission Generators

MissionGenerator verwendet Daten aus mehreren vorgelagerten Theater-Command-Systemen.

Wichtige Systeme:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua
    src/campaign/tc_capture_system.lua
    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua
    src/ai/tc_ai_cap_manager.lua

Bestätigte vorgelagerte Größen:

    Airbase-like Objects: 225
    relevante Kampagnenzonen: 46
    Capture Candidates: 32
    Capture Pressure Records: 32
    Capture Progress Records: 32
    Logistics Hubs: 46
    FOB Candidates: 6
    Blue FOBs: 2
    CAP Zone Candidates: 31
    CAP Requests: 12

Missionen werden damit nicht ungefiltert aus allen DCS-Objekten erzeugt.

---

## 9. Verhältnis zu Airbase Scanner

Airbase Scanner:

    v0.2.2

liefert die klassifizierte Airbase-Grundlage.

Bestätigt:

    total: 225
    strategic: 19
    secondary: 13
    heliports: 1
    helipads: 95
    medical: 40
    farps: 0
    tactical: 13
    unknown: 44
    captureCandidates: 32
    missionCandidates: 32
    logisticsCandidates: 46
    blueStartBases: 1
    redStrategicCandidates: 18

MissionGenerator verwendet nur fachlich geeignete Kampagnenziele.

Nicht automatisch als Standardziele verwendet werden beispielsweise:

- einfache Helipads
- Medical Pads
- Tactical Pads
- Unknown Objects

---

## 10. Verhältnis zu ZoneFactory

ZoneFactory:

    v0.2.0

erzeugt aus der World-Grundlage relevante Kampagnenzonen.

Bestätigt:

    total zones: 46
    strategic zones: 19
    secondary zones: 13
    heliport zones: 1
    tactical zones: 13
    captureZones: 32
    missionZones: 32
    logisticsZones: 46
    startBaseZones: 1
    skipped airbase-like objects: 179

MissionGenerator kann diese Zonen als strukturierte Missionsgrundlage verwenden.

---

## 11. Verhältnis zu CaptureSystem

CaptureSystem:

    v0.2.2

liefert und verarbeitet unter anderem:

- Ownership
- Capture Eligibility
- Capture Pressure
- Capture Progress
- Capture Ready
- Mission Effects

Bestätigter Wirkungspfad:

    MissionGenerator
    -> Mission Completion
    -> Mission Effects
    -> CaptureSystem
    -> Capture Pressure
    -> Capture Progress
    -> Capture Ready

Bestätigter Test:

    MISSION_2
    -> ZONE_AIRBASE_ABU_AL_DUHUR
    -> BLUE pressure 105
    -> progress 100 %
    -> captureReady=true

Der nachgelagerte Capture Apply wird von CaptureSystem ausgeführt.

MissionGenerator ändert Airbase- oder Zone-Ownership nicht selbst.

---

## 12. Mission Completion Regression

Am 2026-09-12 wurde Mission Completion erneut praktisch bestätigt.

Nach Activation und Completion:

    available=9
    active=0
    completed=1
    failed=0
    statistics.available=9
    statistics.active=0
    statistics.completed=1
    total=10

Persistence:

    SAVED
    dirtyReason=f10_active_mission_1_completed
    dirtyCleared=true
    productiveRestore=false

Damit sind Statuswechsel und Dictionary-Move für diesen getesteten Pfad bestätigt.

---

## 13. Mission Failure Regression

Mission Failure wurde ebenfalls praktisch bestätigt.

Nach einem weiteren Failure:

    available=8
    active=0
    completed=1
    failed=1
    statistics.available=8
    statistics.active=0
    statistics.completed=1
    statistics.failed=1
    total=10

Persistence:

    SAVED
    dirtyReason=f10_active_mission_1_failed
    dirtyCleared=true
    productiveRestore=false

CaptureSystem:

    applied=0

Damit gilt aktuell:

    FAILED
    -> kein Capture Pressure

---

## 14. Capture Ready Apply als nachgelagerter Effekt

Bestätigter Testbereich:

    ZONE_AIRBASE_ABU_AL_DUHUR

Vor Apply:

    previous owner: RED
    target owner: BLUE
    progress: 100 %

Nach Apply:

    zoneOwner=BLUE
    previousOwner=RED
    baseOwner=BLUE
    progress=0
    status=STABLE
    captureReady=false

Persistence:

    SAVED
    dirtyReason=f10_capture_ready_zone_1_applied
    dirtyCleared=true

Architekturgrenze:

    MissionGenerator erzeugt Outcome und Effects.
    CaptureSystem verarbeitet Capture-Wirkung und Ownership.

---

## 15. Verhältnis zu LogisticsDelivery

LogisticsDelivery:

    v0.2.1

Bestätigt:

    logistics hubs: 46
    blue hubs: 7
    red hubs: 24
    neutral hubs: 15
    active hubs: 31
    limited hubs: 15
    locked hubs: 0

Priority-3-Ergebnis:

    Read-Neutrality bestanden

MissionGenerator kann daraus perspektivisch unter anderem ableiten:

- Supply Missions
- Logistics Missions
- Interdiction
- Hub Support
- Hub Attack
- Engineering
- Repair
- Transport

Aktuell:

    MissionGenerator kann Logistics-bezogene Missionen state-only modellieren.

Noch nicht produktiv:

    Mission Effect
    -> LogisticsDelivery Mutation
    -> reale CTLD-Ausführung

---

## 16. Verhältnis zu FobSystem

FobSystem:

    v0.2.1

Bestätigt:

    FOB candidates: 6
    stored candidates: 6
    auto-planned FOBs: 2
    skipped candidates: 4
    Blue FOBs: 2

Blue FOBs:

    FOB Ercan
    FOB Gecitkale

Status:

    UNDER_CONSTRUCTION

MissionGenerator:

    fobSupportCandidates: 2
    reservedCreated: 1

Damit wird FOB-Support bereits in der Missionserzeugung berücksichtigt.

Aktuell noch nicht vorhanden:

    FOB_SUPPORT Mission
    -> realer CTLD-Cargo-Transport
    -> FobSystem Build Progress

---

## 17. Verhältnis zu AICapManager

AICapManager:

    v0.2.1

Bestätigt:

    cap zone candidates: 31
    auto-registered CAP zones: 12
    CAP requests: 12

Priority-3-Ergebnis:

    Read-Neutrality bestanden

Aktuell:

    CAP-State vorhanden
    keine realen MOOSE-CAP-Flüge

MissionGenerator kann später auf CAP- und Threat-State reagieren.

Die reale Air-Execution bleibt jedoch getrennt.

---

## 18. Verhältnis zu CTLD

CTLD:

    1.6.1

ist ein zukünftiger Execution Layer für Transport- und Logistikmissionen.

Am 2026-09-29 wurde für einen isolierten getesteten Aufbau ein vollständiger KI-Truppentransport praktisch bestätigt:

    automatischer Pickup
    -> Taxi
    -> Takeoff
    -> Transit
    -> Off-Airfield-Landung
    -> automatischer Dropoff
    -> reale Blue-Bodengruppe

Dieser Test zeigt eine technische Framework-Fähigkeit.

Er bedeutet nicht:

    MissionGenerator erzeugt bereits produktive CTLD-Aufträge.

Die produktive Verbindung zwischen Mission Intent und CTLD Execution ist noch offen.

---

## 19. CTLD-PoC als Grundlage für spätere Mission Execution

Für den getesteten CTLD-Aufbau bestätigt:

Testgruppe:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01

Testunit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Luftfahrzeug:

    Mi-8

Pickup:

    CTLD_PICKUP_BLUE_AKROTIRI_01

Test-Dropoff:

    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01

Pickup:

    16 Soldaten

Dropoff:

    Dropped Group 2
    Group-ID 70001
    16 x Soldier M249

Der Test verwendete keine direkte Manipulation des CTLD-Onboard-State und keine Runtime-Routen- oder Taskänderung.

Für diesen getesteten Truppentransport war kein Invisible FARP erforderlich.

---

## 20. Grenze des CTLD-PoC

Der CTLD-PoC bestätigt nicht automatisch:

- Logistics-Missionen als reale CTLD-Aufträge
- FOB_SUPPORT als reale Cargo-Mission
- Crate Spawn
- Crate Loading
- Sling Load
- Crate Drop
- Supply Cargo
- Engineering Cargo
- Repair Cargo
- Fuel Cargo
- Ammo Cargo
- realen FOB-Bau
- MissionGenerator-Erfolgserkennung für CTLD
- automatische Logistics Effects
- Multiplayer-Verhalten
- CTLD-Restore

Diese Bereiche benötigen separate Integrationsschritte.

---

## 21. Aktuelle Missionstypen

MissionGenerator unterstützt beziehungsweise modelliert aktuell folgende Missionstypen:

- `RECON`
- `STRIKE`
- `SEAD`
- `DEAD`
- `CAS`
- `INTERDICTION`
- `ESCORT`
- `CAP`
- `LOGISTICS`
- `FOB_SUPPORT`
- `AIRBASE_ATTACK`
- `IADS_SUPPRESSION`

Diese Liste ist nicht endgültig.

Mögliche spätere Erweiterungen sind unter anderem:

- `CSAR`
- `MEDEVAC`
- `TRANSPORT`
- `CONVOY_ESCORT`
- `BASE_REPAIR`
- `RUNWAY_ATTACK`
- `ANTI_SHIP`
- `TARCAP`
- `BARCAP`
- `FIGHTER_SWEEP`
- `OCA`
- `DCA`

---

## 22. RECON

Zweck:

    Aufklärung eines relevanten Ziels oder Gebiets

Perspektivische Wirkungen:

- Zielinformationen verbessern
- Missionen freischalten
- IADS-Informationen verfügbar machen
- weitere Operationen vorbereiten

Aktuell:

    state-only
    keine reale Sensor-/Event-Auswertung

---

## 23. STRIKE

Zweck:

    Angriff auf relevante Infrastruktur oder militärische Ziele

Perspektivische Wirkungen:

- Ziel schwächen
- Logistics beeinträchtigen
- Capture vorbereiten
- IADS indirekt schwächen
- weitere Operationen ermöglichen

Aktuell:

    state-only
    keine realen MOOSE-Strike-Spawns
    keine automatische Zielzerstörungsprüfung

---

## 24. SEAD und DEAD

SEAD:

    Suppression of Enemy Air Defenses

DEAD:

    Destruction of Enemy Air Defenses

Perspektivische Wirkungen:

- SAM-Risiko reduzieren
- IADS schwächen
- sichere Korridore erzeugen
- Folgeoperationen ermöglichen

Aktuell:

    state-only
    keine produktive Skynet-Kopplung
    keine automatische Kill-/Suppression-Auswertung

---

## 25. CAS

Zweck:

    Close Air Support

Perspektivisch soll CAS aus realen Ground-Operation-Bedarfen entstehen können.

Mögliche Wirkungen:

- eigene Bodentruppen unterstützen
- gegnerische Verteidigung schwächen
- Capture unterstützen
- FOBs schützen
- Gegenangriffe stoppen

Aktuell:

    state-only
    keine produktive Ground Campaign
    keine automatische CAS-Erfolgsauswertung

---

## 26. INTERDICTION

Zweck:

    gegnerische Bewegung oder Logistik unterbrechen

Perspektivische Wirkungen:

- Logistics schwächen
- Convoys bekämpfen
- Verstärkung verzögern
- Capture unterstützen
- AI-Reaktionen verändern

Aktuell:

    state-only
    keine realen Convoys
    keine automatische Interdiction-Auswertung

---

## 27. ESCORT

Zweck:

    Schutz anderer eigener Operationen

Perspektivisch relevant für:

- Strike Packages
- Transport
- Logistics
- SEAD/DEAD
- Carrier Operations

Aktuell:

    state-only
    keine realen Mission Packages

---

## 28. CAP

Zweck:

    Luftüberlegenheit über wichtigen Zonen oder Korridoren

AICapManager erzeugt bereits CAP-State.

Aktuell:

    Mission Intent vorhanden
    CAP State vorhanden
    keine reale MOOSE-CAP-Execution

---

## 29. LOGISTICS

Zweck:

    Versorgung oder Unterstützung logistischer Knoten

Perspektivische Wirkungen:

- Hub Supply erhöhen
- Fuel liefern
- Ammo liefern
- Engineering liefern
- Repair ermöglichen
- Operationsfähigkeit verbessern

Aktuell:

    state-only
    keine produktive CTLD-Auftragserzeugung
    keine produktiven Logistics Effects

---

## 30. FOB_SUPPORT

Zweck:

    Unterstützung eines geplanten oder im Bau befindlichen FOB

Bestätigt:

    fobSupportCandidates: 2
    reservedCreated: 1

State-only FOBs:

    FOB Ercan
    FOB Gecitkale

Perspektivischer Pfad:

    FOB_SUPPORT Mission
    -> Transportauftrag
    -> CTLD Cargo
    -> Delivery Validation
    -> FobSystem
    -> Build Progress
    -> Persistence

Dieser Pfad ist noch nicht implementiert.

---

## 31. AIRBASE_ATTACK

Zweck:

    Angriff auf Airbase-Ziele

Mögliche spätere Wirkungen:

- Infrastruktur beschädigen
- Operationsfähigkeit reduzieren
- Logistics schwächen
- Capture vorbereiten
- gegnerische AI einschränken

Aktuell:

    state-only
    keine automatische Runway-/Infrastrukturauswertung

Ein Capture-Effekt wurde state-first praktisch bestätigt.

---

## 32. IADS_SUPPRESSION

Zweck:

    gezielte Unterdrückung eines IADS-Bereichs

Perspektivisch:

- Skynet-IADS-Sektor beeinflussen
- EWR-/SAM-Fähigkeiten reduzieren
- Folgeoperationen ermöglichen

Aktuell:

    state-only
    reservierte Framework Hooks
    keine produktive Theater-Command-IADS-Integration

---

## 33. Mission Record

MissionGenerator erzeugt strukturierte Mission Records.

Ein Record kann unter anderem enthalten:

- ID
- Key
- Name
- Type
- Status
- Owner
- Source Base
- Target Zone
- Target Base
- Target FOB
- Priority
- Strategic Relevance
- Objective
- Briefing
- Recommended Aircraft
- Recommended Payload
- Progress
- Activation Metadata
- Outcome State
- Effect State
- Execution Plan
- Effects
- reserved MOOSE Hook
- reserved CTLD Hook
- reserved Skynet Hook

Mission Records sind damit vorbereitete Kampagnenobjekte und nicht nur einfache Textaufträge.

---

## 34. Mission Status

Vorbereitete beziehungsweise mögliche Status:

    AVAILABLE
    ACTIVE
    COMPLETED
    FAILED
    CANCELLED
    EXPIRED

Praktisch bestätigt:

    AVAILABLE -> ACTIVE
    ACTIVE -> COMPLETED
    ACTIVE -> FAILED

Noch nicht vollständig praktisch bestätigt:

    CANCELLED
    EXPIRED

Automatische DCS-Event-basierte Statusübergänge existieren noch nicht.

---

## 35. Mission Activation

Missionen können über F10 aktiviert werden.

F10Menu:

    v0.2.3

Bestätigt:

- Mission Slots 1–10 sind auswählbar.
- Missionen können aktiviert werden.
- Status wird auf `ACTIVE` gesetzt.
- `stateOnly=true`.
- `spawnHooks=reserved`.

Wichtig:

    Mission Activation
    !=
    realer DCS Spawn

Activation ist aktuell eine Kampagnenstate-Transition.

---

## 36. Mission Outcome

Über F10 sind aktuell kontrollierte Outcome-Tests möglich.

Bestätigt:

    Complete Active Mission 1
    Fail Active Mission 1

Completion:

    ACTIVE -> COMPLETED

Failure:

    ACTIVE -> FAILED

Effects werden vorbereitet.

CaptureSystem kann Completion-Effects verarbeiten.

Failure erzeugt aktuell bewusst keinen Capture Pressure.

---

## 37. Mission Details

Mission Details sind über F10 verfügbar.

Sie können unter anderem enthalten:

- Mission Name
- Type
- Status
- Ziel
- Owner
- Priority
- Briefing
- Objectives
- Recommended Aircraft
- Recommended Payload
- Progress
- Outcome State
- Effect State

Die Darstellung ist noch nicht als endgültige Spieleroberfläche zu verstehen.

---

## 38. Mission Briefing und Objectives

Mission Records enthalten vorbereitete Briefing- und Objective-Strukturen.

Briefings sollen langfristig verständlich darstellen:

- Lage
- Ziel
- Auftrag
- Bedrohung
- empfohlene Assets
- erwartete Wirkung

Objectives beschreiben die fachliche Missionsanforderung.

Automatische Objective-Erfüllung aus DCS-Events ist noch nicht produktiv aktiv.

---

## 39. Mission Progress

Mission Progress kann beziehungsweise soll langfristig Daten enthalten wie:

- Startzustand
- Objective Completion
- Partial Success
- Failure
- Damage
- Cargo Delivery
- Destroyed Units
- Capture Effects
- Active Time
- Timeout

Aktuell sind Progress-Strukturen vorbereitet.

Automatische Runtime-Auswertung ist noch nicht vollständig angebunden.

---

## 40. Mission Effects

Mission Effects bilden die Brücke vom Mission Outcome zum Kampagnenstate.

Mögliche Zielsysteme:

- CaptureSystem
- LogisticsDelivery
- FobSystem
- AICapManager
- IADS
- spätere AI-Director-Systeme
- Persistence

Aktuell praktisch bestätigt:

    Mission Completion
    -> Capture Effect
    -> Capture Pressure

Noch nicht produktiv:

    Mission Effect
    -> Logistics
    Mission Effect
    -> FOB Build
    Mission Effect
    -> AI
    Mission Effect
    -> IADS

---

## 41. Spawn Hooks

MissionGenerator reserviert Framework Hooks.

Aktuell:

    spawnHooks=reserved
    stateOnly=true

Reservierte Bereiche:

- MOOSE
- CTLD
- Skynet IADS

Diese Hooks zeigen mögliche spätere Execution-Zuständigkeit an.

Sie führen aktuell keine realen Framework-Aktionen aus.

---

## 42. F10-Integration

F10Menu `v0.2.3` besitzt insgesamt:

    33 Commands

Mission-bezogene Funktionen umfassen:

- Available Missions
- Active Missions
- Mission Details 1–10
- Activate Mission 1–10
- Active Mission Outcome Status
- Complete Active Mission 1
- Fail Active Mission 1

Zusätzlich sichtbar:

- Campaign Status
- Capture Status
- Capture Ready
- Pressure Contested
- Logistics Status
- FOB Status
- AI CAP Status

Es gibt kein normales Spieler-F10-Menü für Persistence Save/Load.

---

## 43. Warum Missionen weiterhin state-only sind

State-only ist weiterhin eine bewusste Architekturentscheidung.

Nicht mehr der Grund ist:

    vermeintlicher Mission-Record-Verlust

Dieser Verdacht ist widerlegt.

Auch Priority 3 ist inzwischen abgeschlossen.

Die verbleibenden Gründe sind unter anderem:

- reale MOOSE-Execution noch nicht angebunden
- produktive CTLD-Orchestrierung noch nicht angebunden
- Skynet-IADS-Kampagnenintegration noch nicht vorhanden
- automatische Outcome-Erkennung noch nicht vorhanden
- AI Director noch nicht vorhanden
- Ground Campaign noch nicht vorhanden
- Restore-/Framework-Lifecycle noch nicht freigegeben

State-first erlaubt, diese Bereiche einzeln zu integrieren und zu testen.

---

## 44. Priority 3 – MissionGenerator-Ergebnis

Priority 3 wurde am:

    2026-09-21

im dokumentierten Umfang abgeschlossen.

MissionGenerator wurde dabei systematisch auf Dirty-Coverage geprüft.

Ergebnis:

    kein aktuell aktiver Missing-Dirty-Bug gefunden

Deshalb:

    kein MissionGenerator-Code-Fix erforderlich

Das bedeutet nicht, dass jeder zukünftige, derzeit unverdrahtete Lifecycle-Pfad automatisch als geprüft gilt.

Neue Mutations- oder Framework-Pfade müssen bei ihrer Einführung erneut gezielt geprüft werden.

---

## 45. Aktuelle Persistence-Grenze

Bestätigt:

    Completion
    -> Dirty
    -> SAVED
    -> dirtyCleared=true

Bestätigt:

    Failure
    -> Dirty
    -> SAVED
    -> dirtyCleared=true

Verbindlich:

    productiveRestore=false

Mission State kann gespeichert werden.

Produktiver Startup-Restore und vollständige Runtime-Rekonstruktion sind noch nicht freigegeben.

---

## 46. Verhältnis zu produktiver CTLD-Integration

Der aktuelle Projektbereich ist:

    Priority 4 – produktive CTLD-Integration vorbereiten

MissionGenerator wird dabei relevant, weil zukünftige Logistics-/FOB-Missionen Transportbedarf erzeugen können.

Eine mögliche spätere Kette lautet:

    MissionGenerator
    -> Logistics / FOB Support Intent
    -> Transportauftrag
    -> CTLD Execution
    -> Result Validation
    -> LogisticsDelivery / FobSystem
    -> Mission Outcome
    -> Dirty
    -> Persistence

Diese Kette ist noch nicht produktiv implementiert.

Vorher muss die CTLD-Integrationsgrenze fachlich festgelegt werden.

---

## 47. Kein vorschnelles Framework-Modul

Die produktive CTLD-Anbindung wird nicht über eine generische Framework-Datei organisiert.

Nicht gewünscht:

    tc_ctld.lua
    tc_ctld_bridge.lua
    tc_ctld_all_in_one.lua

Die eigene Logik bleibt nach fachlicher Aufgabe gegliedert.

Ob MissionGenerator selbst später einen Transportauftrag erzeugt oder lediglich einen Bedarf an ein anderes fachliches System übergibt, ist vor dem nächsten Code-Schritt source-backed zu entscheiden.

---

## 48. Aktuelle Risiken

Weiterhin relevante MissionGenerator-Risiken:

- ungeeignete Ziele werden Mission Candidates
- Missionen werden doppelt erzeugt
- Mission Effects werden doppelt angewendet
- Missionen bleiben unbegrenzt `ACTIVE`
- automatische DCS-Events werden falsch interpretiert
- Framework-Execution und Mission State laufen auseinander
- Logistics-/FOB-Erfolg wird falsch rückgemeldet
- Restore erzeugt doppelte Runtime-Nebenwirkungen
- `CANCELLED` und `EXPIRED` erhalten unsaubere Lifecycle-Regeln
- zukünftige Framework-Integration verletzt Dirty-Semantik

Aktuelle Gegenmaßnahmen:

- konservative Zielauswahl
- klassifizierte World-Daten
- Missionstyp-Limits
- FOB-Support-Reservierung
- state-only Execution
- reservierte Hooks
- getrennte Result Validation
- `appliedMissionEffects`
- pairs-basierte Dictionary-Zählung
- dirty-aware Persistence
- isolierte Framework-Tests
- eine konkrete Aufgabe pro Schritt

---

## 49. Aktuelle Akzeptanzkriterien

Bestanden:

- MissionGenerator `v0.2.3` lädt.
- MissionGenerator startet.
- 78 Mission Candidates.
- 2 FOB-Support-Candidates.
- 10 Mission Records.
- mindestens eine FOB-Support-Mission reserviert.
- Dictionary-Struktur korrekt verstanden.
- kein bestätigter Mission-Record-Verlust.
- Mission Details.
- Mission Activation.
- `AVAILABLE -> ACTIVE`.
- `ACTIVE -> COMPLETED`.
- `ACTIVE -> FAILED`.
- `stateOnly=true`.
- Framework Hooks reserviert.
- Mission Effects vorbereitet.
- Completion -> Capture Pressure.
- Failure -> kein Capture Pressure.
- Capture Ready entsteht.
- Capture Ready ist sichtbar.
- Capture Ready Apply nachgelagert bestanden.
- Priority-3-Audit abgeschlossen.
- kein MissionGenerator-Code-Fix aus Priority 3 erforderlich.

Noch offen:

- `CANCELLED`
- `EXPIRED`
- automatische DCS-Event-Auswertung
- Mission Effects auf Logistics
- Mission Effects auf FOB Build
- Mission Effects auf AI
- Mission Effects auf IADS
- reale MOOSE-Execution
- produktive CTLD-Execution
- produktiver Restore
- Multiplayer

---

## 50. Aktueller Systemstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | Background Persistence bestanden; `productiveRestore=false` |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.1` | Read-Neutrality bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.1` | Read-Neutrality bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | Priority-3-Audit ohne erforderlichen Code-Fix abgeschlossen |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.1` | Read-Neutrality bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden; 33 Commands |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` | KI-Truppentransport-PoC für getesteten Aufbau bestanden |

---

## 51. Nächster MissionGenerator-Schritt

Aktuell ist kein isolierter MissionGenerator-Code-Fix erforderlich.

Der MissionGenerator ist nicht der nächste eigenständige technische Arbeitsbereich.

Der nächste Gesamtprojektbereich ist:

    Priority 4 – produktive CTLD-Integration vorbereiten

Für MissionGenerator wird erst dann wieder konkrete Arbeit notwendig, wenn die fachliche Integrationsgrenze zeigt, wie Logistics-/FOB-Missionsbedarf in reale Transportaufträge übersetzt werden soll.

Dann muss exakt geprüft werden:

    MissionGenerator
    -> erzeugt Transportauftrag selbst?

oder:

    MissionGenerator
    -> erzeugt nur Mission Intent
    -> anderes fachliches Logistics-Modul besitzt Transportauftrag?

Diese Entscheidung wird nicht vorweggenommen.

---

## 52. Aktueller Abschluss

Stand:

    2026-09-29

MissionGenerator:

    v0.2.3
    state-first bestanden

Bestätigt:

    78 Mission Candidates
    2 FOB-Support-Candidates
    10 Mission Records
    String-keyed Dictionaries korrekt gezählt
    Record-Loss-Verdacht widerlegt
    Activation
    Completion
    Failure
    Mission Effects
    Completion -> Capture Pressure
    Failure -> kein Capture Pressure
    Capture Ready als nachgelagerte Wirkung
    F10-Integration
    Persistence für getestete Completion-/Failure-Pfade
    Priority-3-Audit abgeschlossen
    kein aktiver MissionGenerator-Missing-Dirty-Bug

Noch nicht produktiv:

    reale MOOSE-Missionen
    reale CTLD-Missionsausführung
    Logistics Effects
    FOB Build Effects
    AI Effects
    IADS Effects
    automatische DCS-Outcome-Auswertung
    CANCELLED
    EXPIRED
    produktiver Restore
    Multiplayer

Aktueller Übergang:

    state-first Mission Intent
    +
    stabile Mission Records
    +
    getestete Outcome-/Capture-Wirkung
    +
    abgeschlossene Priority-3-Dirty-Coverage
    +
    isolierter CTLD-KI-Truppentransport-PoC
    ->
    kontrollierte produktive Framework-Integration
