# Campaign Design

## Verbindlicher Stand — 2026-09-29

Diese Datei beschreibt das Kampagnendesign der ersten Theater-Command-DCS-Kampagne.

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

## 1. Grundidee der Kampagne

**Operation Levant Reclamation** soll keine lineare Einzelmission werden.

Ziel ist eine dynamische Kampagne, in der:

- Spieler
- KI
- Missionen
- Capture
- Logistik
- FOBs
- Luftüberlegenheit
- SEAD / DEAD
- CAS
- Ground Operations
- IADS
- spätere Carrier Operations

den Kampagnenzustand beeinflussen.

Die Kampagne soll aus einem zentralen Theater-Command-State heraus arbeiten.

Dieser Zustand enthält beziehungsweise soll langfristig enthalten:

- Besitzstatus von Airbases
- Besitzstatus von Zonen
- Capture Eligibility
- Capture Pressure
- Capture Progress
- Capture Ready
- Mission Records
- Logistics Hubs
- Deliveries
- FOB-State
- AI-State
- IADS-State
- Persistence-State
- operative Kampagnenereignisse

Der Spieler soll Teil einer laufenden militärischen Lage sein.

Er soll nicht jeden Hintergrundprozess selbst über F10 auslösen müssen.

Langfristig sollen Blue und Red möglichst eigenständig Operationen planen und durchführen.

---

## 2. Architekturprinzip

Das zentrale Prinzip lautet:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis / Source of Truth
    DCS Runtime = autoritativer Verhaltensbeweis

Der DCS Mission Editor stellt die physische Welt bereit.

Dazu gehören unter anderem:

- Karte
- Koalitionen
- Flugplätze
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

Lua übernimmt die Kampagnenlogik.

GitHub dokumentiert:

- Source
- Architektur
- Entscheidungen
- Versionen
- Aufgabenstand
- Testergebnisse
- bekannte Grenzen

DCS selbst ist für tatsächliches Simulator- und Framework-Verhalten die autoritative Runtime.

---

## 3. State-first-Design

Die Kampagne wird weiterhin nach dem:

    state-first

Prinzip entwickelt.

Reihenfolge:

    Kampagnenstate definieren
    -> State erzeugen
    -> State sichtbar machen
    -> State testen
    -> Dirty-Semantik absichern
    -> Persistence absichern
    -> Framework-Funktion isoliert beweisen
    -> Framework anbinden
    -> Ergebnis validieren
    -> Theater-Command-State aktualisieren
    -> Dirty markieren
    -> persistieren

Damit bleiben:

- strategische Entscheidungen
- Kampagnenstate
- Framework-Ausführung

voneinander getrennt.

---

## 4. Theater Command und Frameworks

Theater Command ist:

    Campaign Logic
    Decision Layer
    State Owner
    Persistence Owner

Vendor-Frameworks sind:

    Execution Layer

Aktuelle Frameworks:

- MIST
- MOOSE
- CTLD
- Skynet IADS

Beispiel:

Theater Command entscheidet später:

    Ein Transport wird benötigt.

CTLD führt technisch aus:

    Pickup
    -> Flug
    -> Landung
    -> Dropoff

Danach validiert Theater Command:

    Ergebnis

und aktualisiert:

    TC.State

Framework-Runtime darf nicht zum alleinigen langfristigen Kampagnenstate werden.

---

## 5. Aktueller Projektstand

Der state-first Kampagnenkern ist für den aktuellen Entwicklungsstand bestätigt.

Aktuelle Versionen:

| System | Version |
|---|---:|
| Airbase Scanner | `v0.2.2` |
| ZoneFactory | `v0.2.0` |
| CaptureSystem | `v0.2.2` |
| PersistenceSystem | `v0.2.6` |
| LogisticsDelivery | `v0.2.1` |
| FobSystem | `v0.2.1` |
| MissionGenerator | `v0.2.3` |
| AICapManager | `v0.2.1` |
| F10Menu | `v0.2.3` |
| CTLD | `1.6.1` |

Bestätigt sind unter anderem:

- World State
- Kampagnenzonen
- Capture State
- Capture Pressure
- Capture Progress
- Capture Ready
- Logistics State
- FOB State
- Mission State
- AI CAP State
- F10-Testbed
- dirty-aware Background Persistence
- Mission Completion
- Mission Failure
- Capture Ready Apply
- Priority-3-Dirty-Coverage im dokumentierten Umfang
- CTLD-KI-Truppentransport-PoC für den getesteten Aufbau

Noch nicht produktiv:

- Theater-Command-CTLD-Orchestrierung
- CTLD Crate-/Cargo-Wirtschaft
- reale CTLD-FOBs
- reale MOOSE-CAP-Flüge
- AI Director
- Ground Campaign
- CAS-Automatisierung
- Skynet-IADS-Kampagnenintegration
- Carrier Operations
- produktiver Startup-Restore
- Multiplayer

---

## 6. Bestätigte technische Kernwerte

Aktuell bestätigt:

    Syria airbase-like objects: 225
    relevante Kampagnenzonen: 46
    capture-fähige Basen: 32
    capture-fähige Zonen: 32
    Logistics Hubs: 46
    FOB-Kandidaten: 6
    Blue FOBs: 2
    Missionskandidaten: 78
    FOB-Support-Kandidaten: 2
    Mission Records: 10
    F10 Commands: 33
    Capture-Pressure-Records: 32
    Capture-Progress-Records: 32
    CAP-Zonen-Kandidaten: 31
    CAP Requests: 12

Wichtige Designfolgerung:

    Nicht jedes von DCS erkannte Airbase-like Object ist ein strategisches Kampagnenobjekt.

Von den:

    225

erkannten Airbase-like Objects werden aktuell:

    46

als relevante Kampagnenzonen behandelt.

Davon sind:

    32

capture-fähige strategische oder sekundäre Ziele.

---

## 7. Mission Records

MissionGenerator:

    v0.2.3

erzeugt:

    10 Mission Records

Die Mission-Status-Collections sind String-keyed Lua-Dictionaries.

Deshalb ist:

    #table

für deren Anzahl nicht autoritativ.

Autoritative Zählung erfolgt über:

    pairs()

beziehungsweise pairs-basierte Hilfsfunktionen.

Der frühere Verdacht eines Mission-Record-Verlusts wurde widerlegt.

Es gibt keinen bestätigten Mission-Record-Datenverlust.

---

## 8. Strategische Ausgangslage

Zu Kampagnenbeginn kontrolliert Blue den Startbereich auf Zypern.

Blauer Startpunkt:

    Akrotiri

Roter Ausgangsraum:

    syrisches Festland

Die Kampagne beginnt bewusst asymmetrisch.

Blue besitzt:

- eine sichere Ausgangsbasis
- Zugang zum östlichen Mittelmeer
- Luftstreitkräfte
- perspektivisch See- und Carrier-Unterstützung

Red besitzt:

- strategische Tiefe auf dem Festland
- zahlreiche Airbases
- spätere IADS-Strukturen
- spätere Ground Forces
- spätere Logistics-Strukturen

Blue muss schrittweise Operationsfreiheit aufbauen.

---

## 9. Kampagnenrahmen

Die konkrete Hintergrundgeschichte kann später weiter ausgearbeitet werden.

Aktueller Rahmen:

    Eine internationale Koalition operiert von Akrotiri aus gegen einen rot kontrollierten syrischen Operationsraum.

Der Kampagnenfokus liegt technisch auf:

- dynamischer Operationsentwicklung
- Airbase Control
- Capture
- Logistics
- FOB-Aufbau
- Air Operations
- Ground Operations
- IADS
- Persistence

Die technische Architektur hat Vorrang vor einer starren narrativen Missionskette.

---

## 10. Kampagnenverlauf

Der Kampagnenverlauf soll nicht als feste Missionsfolge gebaut werden.

Er soll aus dem Kampagnenstate entstehen.

Perspektivische Eskalationslogik:

1. Aufklärung und Orientierung
2. Luftüberlegenheitsoperationen
3. SEAD / DEAD
4. Logistikaufbau
5. FOB-Aufbau
6. strategische Angriffe
7. Capture-Operationen
8. Ausweitung der Blue Operations Area
9. Red Gegenreaktionen
10. IADS-Anpassungen
11. Ground Operations
12. langfristige persistente Kampagnenentwicklung

Die tatsächliche Reihenfolge soll später dynamisch von der Lage abhängen.

---

## 11. Kampagnenstart auf Akrotiri

Akrotiri ist die zentrale Blue Main Operating Base der ersten Kampagne.

Fachliche Rolle:

- sicherer Startpunkt
- Main Operating Base
- erster Blue Logistics Hub
- Ausgangspunkt für Luftoperationen
- Ausgangspunkt für Transportoperationen
- späterer Ausgangspunkt für See-/Luftbrücke

Aktuell bestätigt:

    Akrotiri wird als Blue-Startbasis erkannt.
    Akrotiri wird als STRATEGIC_AIRFIELD klassifiziert.
    ein F/A-18C Lot 20 Client-Slot ist vorhanden.

---

## 12. Airbase-Design

Airbases werden nicht ausschließlich nach DCS-Objekttyp bewertet.

Airbase Scanner klassifiziert:

    strategic
    secondary
    heliport
    helipad
    medical
    tactical
    unknown

Aktuelle Werte:

    strategic: 19
    secondary: 13
    heliports: 1
    helipads: 95
    medical: 40
    tactical: 13
    unknown: 44

Strategische Airfields sind zentrale Kampagnenobjekte.

Perspektivische Rollen:

- Ownership
- Capture
- Logistics
- Missionsziel
- AI-Basis
- Spawn-/Startbasis
- IADS-Bezug
- Persistence

---

## 13. Secondary Airfields

Secondary Airfields erhalten eine reduzierte, aber reale Kampagnenrolle.

Mögliche Rollen:

- Zwischenziel
- Forward Operating Location
- logistischer Zwischenpunkt
- Helikopterstützpunkt
- begrenztes Missionsziel
- Capture-Ziel

Aktuell:

    13 Secondary Airfields

Sie sind Teil der aktuellen capture-/mission-fähigen Zielmenge.

---

## 14. Heliports, Helipads und Medical Pads

Diese Objekte werden nicht ignoriert.

Sie sind jedoch nicht automatisch strategische Kampagnenbasen.

Mögliche spätere Rollen:

- CTLD-Zonen
- taktische Landezonen
- CSAR
- MEDEVAC
- Helikoptermissionen
- FOB-Unterstützung
- Forward Logistics

Sie sind standardmäßig nicht gedacht als:

- strategische Haupt-Capture-Ziele
- Hauptlogistikhubs
- CAP-Zentren
- zufällige strategische Strike-Ziele

---

## 15. Capture-Design

CaptureSystem:

    v0.2.2

verwaltet:

- Ownership
- Capture Eligibility
- Capture Pressure
- Capture Progress
- Capture Ready
- Mission Effects
- kontrollierten Capture Apply

Aktuell bestätigt:

    eligibleBases: 32
    eligibleZones: 32
    pressureRecords: 32
    progressRecords: 32

Bestätigter Wirkungspfad:

    Mission Completion
    -> Capture Pressure
    -> Capture Progress
    -> Capture Ready

Mission Failure:

    kein Capture Pressure

Kontrollierter Apply:

    Capture Ready
    -> Ownership Update
    -> linked Airbase Ownership Sync
    -> Progress Reset
    -> Persistence

Automatische DCS-Bodenlage-Auswertung und autonome Capture-Entscheidungen sind noch nicht produktiv.

---

## 16. Capture und Logistik

Langfristig soll Capture nicht nur von Mission Completion abhängen.

Perspektivisch können einfließen:

- Ground Presence
- Logistics
- FOB Support
- Supply
- AI Resistance
- IADS-Zustand
- Kampagnenphase
- Missionswirkungen

Diese Kopplungen sind noch nicht produktiv implementiert.

Aktuell bleibt Capture bewusst kontrolliert und state-first.

---

## 17. Mission Design

Missionen entstehen aus dem Kampagnenzustand.

Aktuelle beziehungsweise vorgesehene Missionstypen:

- Recon
- CAP
- SEAD
- DEAD
- Strike
- CAS
- Interdiction
- Escort
- Logistics
- FOB Support
- Airbase Attack
- IADS Suppression

Missionen werden nicht zufällig aus allen DCS-Objekten erzeugt.

Geeignete Ziele stammen unter anderem aus:

- strategischen Airfields
- Secondary Airfields
- Capture-Zonen
- Logistics-Zonen
- FOBs
- später IADS-Zielen
- später Ground Operations

---

## 18. MissionGenerator

MissionGenerator:

    v0.2.3

Aktuelle Werte:

    mission candidates: 78
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 68

Mission Records enthalten unter anderem:

- Objective
- Briefing
- Progress
- Activation Metadata
- Outcome State
- Effect State
- Execution Plan
- reservierte Framework Hooks

Bestätigt:

    AVAILABLE -> ACTIVE
    ACTIVE -> COMPLETED
    ACTIVE -> FAILED

Noch nicht produktiv:

- reale Framework-Missionsausführung
- automatische DCS-Outcome-Erkennung
- vollständige CANCELLED-/EXPIRED-Integration

---

## 19. Spielerinteraktion

F10Menu:

    v0.2.3

Commands:

    33

Aktuelle Spieler-/Testfunktionen umfassen unter anderem:

- verfügbare Missionen
- aktive Missionen
- Mission Details
- Mission Activation
- Mission Completion Test
- Mission Failure Test
- Campaign Status
- Capture Status
- Capture Ready
- Capture Apply
- Pressure Contested
- Logistics Status
- FOB Status
- AI CAP Status

Designregel:

    F10 ist nicht der langfristige Motor der Kampagne.

Es dient aktuell hauptsächlich:

- Spielerinformation
- Status
- Debug
- kontrollierten Tests

Hintergrundsysteme sollen später autonom arbeiten.

---

## 20. Logistics Design

LogisticsDelivery:

    v0.2.1

Aktuell:

    Logistics Hubs: 46
    Blue Hubs: 7
    Red Hubs: 24
    Neutral Hubs: 15
    Active Hubs: 31
    Limited Hubs: 15
    Locked Hubs: 0

Logistik soll später beeinflussen:

- FOB-Aufbau
- Versorgung
- Operationsreichweite
- Missionsverfügbarkeit
- Capture-Fähigkeit
- Verteidigungsfähigkeit
- AI-Reaktionen
- Repair
- Fuel
- Ammo
- Engineering

Priority-3-Read-Neutrality:

    bestanden

Noch nicht produktiv:

- reale CTLD-Auftragserzeugung
- Cargo-Wirtschaft
- Supply-Verbrauch
- Logistics -> Capture
- Logistics -> AI

---

## 21. FOB Design

FobSystem:

    v0.2.1

Aktuell:

    FOB Candidates: 6
    Blue FOBs: 2

State-only FOBs:

    FOB Ercan
    FOB Gecitkale

Status:

    UNDER_CONSTRUCTION

Diese FOBs sind aktuell Theater-Command-State.

Sie sind noch keine real durch CTLD gebauten DCS-FOBs.

Langfristig sollen FOBs unter anderem ermöglichen:

- Forward Logistics
- Helikopteroperationen
- Rearm
- Refuel
- Engineering
- Defense
- Missionsunterstützung
- Operationsraumerweiterung

---

## 22. CTLD-Rolle

CTLD:

    1.6.1

ist der vorgesehene Execution Layer für reale Logistik- und Transportfunktionen.

Perspektivisch relevant für:

- Truppentransport
- Supply
- Engineering
- Repair
- Fuel
- Ammo
- Cargo
- FOB-Aufbau

Am 2026-09-29 wurde erstmals ein vollständiger isolierter KI-Truppentransportpfad für den getesteten Aufbau praktisch bestätigt.

Das ist ein:

    Framework-Proof-of-Concept

und noch keine:

    produktive Theater-Command-CTLD-Integration

---

## 23. CTLD-Testaufbau

Testmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz

Testgruppe:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01

Testunit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Luftfahrzeug:

    Mi-8

Pickup:

    CTLD_PICKUP_BLUE_AKROTIRI_01

Technischer Dropoff:

    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01

Reservierter späterer FOB-Dropoff:

    CTLD_DROPOFF_BLUE_ERCAN_FOB_01

---

## 24. CTLD-KI-Truppentransport

Für den getesteten Aufbau bestätigt:

    Pickup
    -> Taxi
    -> Takeoff
    -> Transit
    -> Off-Airfield-Landung
    -> automatischer Dropoff
    -> reale Blue-Bodengruppe

Pickup:

    16 Soldaten

Pickup-Zähler:

    10000 -> 9999

Dropoff:

    Dropped Group 2
    Group-ID 70001
    16 x Soldier M249

Nicht verwendet:

- manuelles CTLD-Loading
- manuelles CTLD-Unload
- direkte Manipulation von `ctld.inTransitTroops`
- Teleport
- Runtime-Routenänderung
- Runtime-Taskänderung

---

## 25. CTLD-Zonenregistrierung

Für den getesteten Runtime-Pfad bestätigt:

Normalisierte Zonen konnten nach der bestehenden CTLD-Initialisierung ergänzt werden in:

    ctld.pickupZones
    ctld.dropOffZones

Getesteter Pickup-Eintrag:

    { "CTLD_PICKUP_BLUE_AKROTIRI_01", -1, 10000, 1, 2 }

Getesteter Dropoff-Eintrag:

    { "CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01", -1, 2, 1 }

Eine erneute Ausführung von:

    ctld.initialize()

war für diesen getesteten Runtime-Pfad nicht erforderlich.

Daraus wird nicht abgeleitet, dass ein erneuter Aufruf grundsätzlich verboten wäre.

---

## 26. CTLD-KI-Transporterregistrierung

Der getestete Transporter musste im relevanten CTLD-AI-Pfad in:

    ctld.transportPilotNames

registriert sein.

Vor temporärer Registrierung:

    108 Einträge

Danach:

    109 Einträge

Die Testunit war genau einmal vorhanden.

Eine spätere produktive Integration muss dies:

- automatisch
- idempotent
- duplikatfrei
- lifecycle-sicher

durchführen.

---

## 27. Off-Airfield-Landung

Erfolgreicher Aufbau:

    normaler Turning Point
    +
    Perform Task -> Land

Zielposition:

    x / North = -29249.110954281
    z / East  = -271836.070539260

Wegpunkt:

    100 m BARO
    30 m/s

Land Task:

    duration=300
    durationFlag=true

Bestätigte minimale Entfernung zum Dropoff-Zentrum:

    ungefähr 1.06 m

Für diesen getesteten Truppentransport war kein Invisible FARP erforderlich.

Der vorherige ungebundene:

    Land / Landing

Waypoint lieferte keinen vollständigen erfolgreichen Transportzyklus.

Die genaue Ursache des früheren Turnbacks ist dadurch nicht abschließend bewiesen.

---

## 28. CTLD `RepackCommandsPath`

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

---

## 29. Truppentransport ist nicht gleich Cargo

Der erfolgreiche CTLD-Test betrifft:

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
- realer FOB-Bau
- LogisticsDelivery-Rückkopplung
- FobSystem-Rückkopplung
- CTLD-Restore
- Multiplayer

Diese Funktionen benötigen eigene Tests.

---

## 30. Zukünftiger produktiver Logistics-Pfad

Langfristiger Zielpfad:

    Kampagnenlage
    -> Logistics Need
    -> Mission / Transport Intent
    -> Transportauftrag
    -> CTLD-Ausführung
    -> Pickup
    -> Transport
    -> Delivery
    -> Ergebnisvalidierung
    -> LogisticsDelivery
    -> FobSystem
    -> Campaign Effect
    -> Dirty
    -> Persistence

Theater Command bleibt dabei State Owner.

CTLD bleibt Execution Layer.

---

## 31. AI Design

AICapManager:

    v0.2.1

Aktuell:

    CAP Candidates: 31
    CAP Zones: 12
    CAP Requests: 12

Priority-3-Read-Neutrality:

    bestanden

AICapManager erzeugt aktuell:

    State / Intent

Noch nicht produktiv:

    reale MOOSE CAP Flights

Langfristig soll AI unter anderem reagieren auf:

- Mission State
- Capture State
- Logistics
- FOBs
- Ground Situation
- IADS
- verfügbare Assets
- Verluste

---

## 32. AI Director

Ein umfassender AI Director existiert noch nicht.

Langfristig soll er:

- Lage bewerten
- Prioritäten setzen
- Missionsbedarf erkennen
- Assets auswählen
- Ressourcen berücksichtigen
- Ground Operations koordinieren
- Logistics berücksichtigen
- Capture berücksichtigen
- IADS berücksichtigen
- auf Verluste reagieren

Blue und Red sollen jeweils eigene operative Entscheidungen treffen können.

---

## 33. Ground Operations

Bodentruppen sollen langfristig ein vollwertiger Teil der Kampagne werden.

Perspektivisch:

    Ground Operation
    -> Bewegung
    -> Gegnerkontakt
    -> Unterstützungsbedarf
    -> CAS Request
    -> MissionGenerator / AI Director
    -> verfügbare Luftunterstützung
    -> Mission
    -> Ergebnis
    -> Ground State

Ground Operations sind noch nicht produktiv implementiert.

---

## 34. CAS Design

CAS soll später nicht ausschließlich als manuell erstellte Mission existieren.

Perspektivisch können Bodentruppen beziehungsweise Ground Operations Unterstützungsbedarf erzeugen.

Relevante Assets können unter anderem sein:

- A-10C II
- F/A-18C
- weitere CAS-fähige Flugzeuge
- Helikopter

Die konkrete Dispatch-/Request-Architektur ist noch nicht implementiert.

---

## 35. IADS Design

Skynet IADS ist als Vendor-Framework geladen.

Theater Command soll später die Kampagnenebene darüber verwalten.

Perspektivische Themen:

- IADS-Sektoren
- EWR
- SAM Sites
- Damage State
- Repair
- Supply
- Missionsziele
- SEAD / DEAD
- Persistence
- AI-Reaktionen

Aktuell:

    keine produktive Theater-Command-IADS-Integration

---

## 36. Carrier Operations

Perspektivisch soll ein Carrier Task Group Bestandteil der Kampagne werden.

Vorgesehen:

- Supercarrier
- F/A-18C
- F-14
- weitere Carrier-fähige Flugzeuge
- Carrier CAP
- Fleet Defense
- Strike
- Escort
- Logistics

Der Carrier soll operativ in das Kampagnensystem eingebunden werden.

Er soll nicht nur statische Kulisse sein.

Carrier Operations sind noch nicht implementiert.

---

## 37. Persistence Design

PersistenceSystem:

    v0.2.6

läuft aktuell dirty-aware im Hintergrund.

Bestätigt:

- Save
- Read-back
- Compile
- Evaluate
- Validation
- kontrollierter Import
- `SAVED`
- `SKIPPED`
- kontrollierter `FAILED`
- Retry

Scheduler:

    initial nach 20 s
    danach alle 120 s

Verbindlich:

    productiveRestore=false

Die Kampagne wird beim Missionsstart noch nicht automatisch aus dem produktiven Save fortgesetzt.

---

## 38. Persistenter Kampagnenumfang

Langfristig sollen unter anderem gespeichert werden:

- Base Ownership
- Zone Ownership
- Capture Pressure
- Capture Progress
- Missionsstatus
- Logistics State
- Delivery State
- FOB State
- AI State
- IADS State
- wichtige Kampagnenereignisse

Framework-spezifischer Runtime-State soll nur persistiert werden, wenn er wirklich Teil des fachlichen Kampagnenzustands sein muss.

---

## 39. Produktiver Restore

Technische Importfähigkeit existiert.

Produktiver Restore bleibt trotzdem deaktiviert.

Vor Freigabe müssen mindestens geklärt werden:

- Restore-/Initialisierungsreihenfolge
- Save-Versionierung
- Save-Kompatibilität
- Modul-Lifecycle
- Framework-Rekonstruktion
- Schutz vor doppelten Framework-Nebenwirkungen
- kontrollierter End-to-End-Restore-Test

Priority 3 ist inzwischen abgeschlossen und nicht mehr der offene Restore-Blocker.

---

## 40. Priority 3

Priority 3 – Dirty-Coverage – ist seit:

    2026-09-21

im dokumentierten Umfang abgeschlossen.

Bestätigt:

- Capture Getter Read-Neutrality
- Capture Ownership No-Op
- LogisticsDelivery Read-Neutrality
- FobSystem Read-Neutrality
- MissionGenerator Dirty-Coverage-Audit
- AICapManager Read-Neutrality

Latente Lifecycle-Punkte bleiben erhalten.

Sie werden bei tatsächlicher späterer Verdrahtung gezielt erneut geprüft.

---

## 41. Aktuelle DEV-Mission

Technische Entwicklungsmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_DEV.miz

Aktuell bestätigt beziehungsweise enthalten:

- Syria
- Modern Coalition Setup
- Akrotiri als Blue-Ausgangspunkt
- F/A-18C Client-Slot
- Vendor-Ladekette
- Theater-Command-Ladekette
- F10Menu
- state-first Runtime
- Background Persistence

Die DEV-Mission bleibt ein Entwicklungs- und Testträger.

Sie ist noch keine fertige Kampagne.

---

## 42. Entwicklungswerkzeuge

Die Werkzeugtrennung ist seit 2026-09-29 verbindlich.

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
- Mission Editor
- Gruppen
- Units
- Zonen
- Wegpunkte
- Tasks
- Ressourcen
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
- CTLD-Live-State
- Unit-/Group-State
- Position
- Geschwindigkeit
- Grounded/Airborne
- Logs
- Runtime-Regressionen

Aus dem bestätigten Stand wird kein exakter Executable-Pfad abgeleitet.

---

## 43. Entwicklungsworkflow

Für Mission-Editor-/Framework-Arbeit:

    GitHub prüfen
    -> konkrete Aufgabe definieren
    -> Testkriterium definieren
    -> aktuelle .miz mit Claude + dcs-mcp prüfen
    -> nur notwendige Änderung durchführen
    -> Mission speichern
    -> gespeicherte .miz erneut auditieren
    -> Runtime-Test vorbereiten
    -> Claude Code + DCS-SMS
    -> reales DCS-Verhalten prüfen
    -> Ergebnis bewerten
    -> GitHub synchronisieren

Dabei gilt:

    eine konkrete Aufgabe pro Schritt

---

## 44. Nicht-Ziele des aktuellen Entwicklungsstands

Aktuell wird bewusst noch nicht gleichzeitig umgesetzt:

- vollständige rote Frontlinie
- komplette Syria-Befüllung
- produktive IADS-Struktur
- vollständige CTLD-Cargo-Wirtschaft
- reale CTLD-FOBs
- reale MOOSE-Spawns
- autonomer AI Director
- komplette Ground Campaign
- Carrier Operations
- produktiver Startup-Restore
- Multiplayer
- vollständige Blue-/Red-Autonomie

Grund:

    bestehende Architektur kontrolliert und testbar erweitern,
    statt viele Framework-Pfade gleichzeitig einzuführen.

---

## 45. Aktueller Kampagnenfortschritt

Bereits praktisch bestätigt:

    Mission Completion
    -> Mission Effect
    -> Capture Pressure
    -> Capture Progress
    -> Capture Ready
    -> kontrollierter Apply
    -> Ownership Update
    -> linked Airbase Sync
    -> Background Save

Separat bestätigt:

    Mission Failure
    -> kein Capture Pressure
    -> Background Save

Zusätzlich als isolierter Framework-Pfad bestätigt:

    CTLD Pickup
    -> Mi-8 Transport
    -> Off-Airfield-Landung
    -> automatischer Dropoff
    -> reale Blue-Bodengruppe

Die beiden Bereiche sind noch nicht produktiv miteinander gekoppelt.

---

## 46. Nächster Kampagnendesign-Schritt

Der nächste technische Bereich ist:

    Priority 4 – produktive CTLD-Integration vorbereiten

Nicht erneut notwendig:

- vollständiger Priority-3-Audit
- identischer Mi-8-PoC
- Vendor-CTLD-Patch

Zuerst muss geklärt werden:

- welche fachliche Komponente Transportaufträge besitzt
- wie CTLD-Zonen registriert werden
- wie Transporter registriert werden
- wie die Registrierung idempotent bleibt
- wie Transporter-Lifecycle behandelt wird
- wie Erfolg und Fehler erkannt werden
- wie `RepackCommandsPath` behandelt wird
- wie Ergebnisse in LogisticsDelivery und FobSystem zurückfließen
- welche Mutationen Dirty setzen
- welche Daten persistiert werden
- welche CTLD-Daten runtime-only bleiben
- was später bei Restore rekonstruiert werden muss

Erst danach wird eine konkrete Source-Datei beziehungsweise Integrationsaufgabe festgelegt.

---

## 47. Aktueller Status

Stand:

    2026-09-29

Das Kampagnendesign bleibt auf ein dynamisches System ausgerichtet, in dem Spieler Teilnehmer sind und Blue-/Red-Autonomie langfristiges Ziel ist.

Bestätigt:

- Airbases werden klassifiziert.
- relevante Kampagnenzonen werden erzeugt.
- Capture Pressure und Progress funktionieren state-first.
- Mission Completion beeinflusst Capture.
- Mission Failure erzeugt aktuell keinen Capture Pressure.
- Capture Ready und kontrollierter Apply funktionieren.
- Zone-/Airbase-Ownership-Sync funktioniert.
- Logistics Hubs existieren.
- FOB-State existiert.
- 10 Mission Records existieren.
- F10Menu besitzt 33 Commands.
- AI-CAP-State existiert.
- dirty-aware Background Persistence funktioniert.
- Priority 3 ist im dokumentierten Umfang abgeschlossen.
- CTLD-KI-Truppentransport funktioniert für den getesteten Aufbau.
- produktiver Restore bleibt deaktiviert.

Weiterhin offen:

- produktive CTLD-Orchestrierung
- CTLD Cargo
- reale FOBs
- MOOSE Execution
- AI Director
- Ground Campaign
- IADS
- Carrier Operations
- produktiver Restore
- Multiplayer

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
