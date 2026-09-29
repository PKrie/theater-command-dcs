# Airbase System

## Verbindlicher Stand — 2026-09-29

Diese Datei beschreibt das Airbase-System von **Theater Command DCS**.

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

## 1. Zweck des Airbase-Systems

Das Airbase-System bildet eine zentrale Grundlage für die Kampagne.

Es erkennt, klassifiziert und bewertet DCS-Airbase-like Objects und stellt daraus strukturierte Daten für nachgelagerte Theater-Command-Systeme bereit.

Der Airbase Scanner entscheidet nicht selbst über:

- Capture
- Mission Outcomes
- Logistics Deliveries
- FOB-Bau
- AI-Operationen
- CTLD-Ausführung
- MOOSE-Spawns
- IADS-Aktionen

Er liefert die Datenbasis für:

- ZoneFactory
- CaptureSystem
- LogisticsDelivery
- FobSystem
- MissionGenerator
- AICapManager
- spätere IADS-Integration
- spätere AI-Director-Logik
- Persistence

---

## 2. Architekturrolle

Das Airbase-System folgt dem allgemeinen Theater-Command-Prinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis / Source of Truth
    DCS Runtime = autoritativer Verhaltensbeweis

AirbaseScanner ist:

    Discovery / Classification Layer

Er ist nicht:

    Decision Layer
    Execution Layer

Nachgelagerte Systeme verwenden die klassifizierten Daten.

Framework-Aktionen bleiben außerhalb des Airbase Scanners.

---

## 3. Aktive Datei

Datei:

    src/world/tc_airbase_scanner.lua

Version:

    v0.2.2

Status:

    bestanden
    state-first stabil

Bestätigt:

- Airbase Scanner lädt.
- Airbase Scanner startet.
- Syria-Airbase-like Objects werden erkannt.
- erkannte Objekte werden klassifiziert.
- Kampagnenkandidaten werden erzeugt.
- nachgelagerte Systeme können die Daten verwenden.
- keine produktive Framework-Ausführung erfolgt direkt im Scanner.

Aktuell besteht kein Grund für eine AirbaseScanner-Codeänderung.

---

## 4. Grundproblem auf der Syria Map

DCS liefert auf der Syria Map nicht nur klassische Flugplätze.

Die Airbase-API liefert eine große Zahl unterschiedlicher Airbase-like Objects.

Dazu gehören unter anderem:

- große Flugplätze
- kleinere Airfields
- Heliports
- Helipads
- Medical Pads
- Tactical Pads
- Sonderobjekte

Bestätigt erkannt:

    225 Airbase-like Objects

Wichtig:

    225 erkannte Objekte
    !=
    225 strategische Kampagnenziele

Ein ungefiltertes Übernehmen aller DCS-Airbase-like Objects würde zu fachlich falschen:

- Capture-Zielen
- Missionen
- Logistics Hubs
- AI-Reaktionen

führen.

---

## 5. Klassifikationsziel

Der Airbase Scanner klassifiziert die DCS-Airbase-like Objects in fachliche Kategorien.

Aktuelle Kategorien:

- Strategic Airfield
- Secondary Airfield
- Heliport
- Helipad
- Medical Pad
- Tactical Pad
- FARP
- Unknown

Bestätigte Verteilung:

    total: 225
    strategic: 19
    secondary: 13
    heliports: 1
    helipads: 95
    medical: 40
    farps: 0
    tactical: 13
    unknown: 44

Die Klassifikation ist bewusst konservativ.

Nicht jede erkannte Klasse wird automatisch:

- Capture-Ziel
- Missionsziel
- Logistics Hub
- AI-Basis

---

## 6. Strategic Airfields

Bestätigt:

    strategic: 19

Strategic Airfields sind zentrale Kampagnenobjekte.

Mögliche beziehungsweise teilweise bereits state-first genutzte Rollen:

- Ownership
- Capture
- Mission Target
- Logistics Hub
- AI-Basis
- Spawn-/Startpunkt
- IADS-Bezug
- Persistence

Akrotiri wird als Strategic Airfield erkannt.

Akrotiri ist zugleich die bestätigte Blue Start Base.

---

## 7. Secondary Airfields

Bestätigt:

    secondary: 13

Secondary Airfields sind kleinere beziehungsweise weniger zentrale Flugplätze.

Sie können dennoch kampagnenrelevant sein.

Mögliche Rollen:

- Capture-Ziel
- Missionsziel
- Forward Operating Location
- logistischer Zwischenpunkt
- regionaler Stützpunkt
- Helikopterstützpunkt

Strategic und Secondary Airfields bilden aktuell gemeinsam die zentrale capture-/mission-fähige Airbase-Zielmenge.

---

## 8. Heliports

Bestätigt:

    heliports: 1

Heliports sind nicht automatisch strategische Hauptbasen.

Mögliche spätere Rollen:

- Helikopterstützpunkt
- CTLD-Unterstützung
- Transport
- CSAR
- Sonderlogistik
- Forward Support

Eine automatische Gleichstellung mit Strategic Airfields erfolgt nicht.

---

## 9. Helipads

Bestätigt:

    helipads: 95

Helipads sind auf der Syria Map zahlreich vorhanden.

Sie sind nicht automatisch strategische Kampagnenziele.

Mögliche spätere Rollen:

- taktische Landezone
- CSAR
- MEDEVAC
- CTLD-Ziel
- FOB-Unterstützung
- Forward Logistics

Aktuell:

    keine Standard-Capture-Ziele

---

## 10. Medical Pads

Bestätigt:

    medical: 40

Medical Pads werden nicht als reguläre strategische Airfields behandelt.

Sie sind aktuell nicht:

- Standard-Capture-Ziele
- Standard-Airbase-Attack-Ziele
- strategische Hauptbasen

Mögliche spätere Rollen:

- MEDEVAC
- CSAR
- medizinische Evakuierung
- Sondermissionen

---

## 11. Tactical Pads

Bestätigt:

    tactical: 13

Tactical Pads sind kleinere taktische beziehungsweise technische Airbase-like Objects.

Mögliche spätere Rollen:

- taktische Landezonen
- Helikopteroperationen
- CTLD-Außenpunkte
- Forward Support
- Spezialmissionen

Sie sind aktuell nicht automatisch strategische Capture-Ziele.

---

## 12. FARPs

Bestätigt:

    farps: 0

Im aktuellen AirbaseScanner-Teststand wurden keine FARPs als Airbase-Klasse erkannt.

Das bedeutet nicht, dass FARPs für Theater Command grundsätzlich irrelevant sind.

Perspektivisch können sie wichtig sein für:

- AH-64D
- Transporthelikopter
- CTLD
- Rearm
- Refuel
- FOBs
- Forward Operations

Der erfolgreiche CTLD-KI-Truppentransport vom 2026-09-29 benötigte für den getesteten Transportpfad keinen Invisible FARP.

Daraus wird nicht abgeleitet, dass spätere reale FOB-Infrastruktur ohne FARP auskommen muss.

---

## 13. Unknown Objects

Bestätigt:

    unknown: 44

Unknown Objects werden konservativ behandelt.

Sie werden nicht automatisch:

- strategisch
- capture-fähig
- Mission Target
- Logistics Hub

Optional später:

- manuelle Prüfung
- Nachklassifikation
- Override-System

Designregel:

    lieber einen Sonderfall zunächst nicht strategisch verwenden,
    als ein ungeeignetes DCS-Objekt fälschlich zum Kampagnenziel zu machen.

---

## 14. Blue Start Base

Bestätigt:

    blueStartBases: 1

Blue Start Base:

    Akrotiri

Fachliche Rolle:

- Blue Main Operating Base
- Spielerstartpunkt
- erster Blue Logistics Hub
- Ausgangspunkt für Luftoperationen
- Ausgangspunkt für spätere Transportoperationen
- späterer Knoten einer See-/Luftbrücke

Akrotiri wird als:

    STRATEGIC_AIRFIELD

klassifiziert.

---

## 15. Red Strategic Candidates

Bestätigt:

    redStrategicCandidates: 18

Diese Objekte bilden die erste strategische Grundlage für Red auf dem Festland.

Mögliche Rollen:

- Red Main Bases
- Missionsziele
- Capture-Ziele
- Logistics Hubs
- AI-Ausgangspunkte
- IADS-nahe Knoten

Noch nicht produktiv:

- komplette Red Front
- Red AI Director
- reale MOOSE-Flüge
- Ground Campaign
- produktive IADS-Struktur

---

## 16. Capture Candidates

Bestätigt:

    captureCandidates: 32

Capture Candidates sind Airbase-Objekte, die grundsätzlich als Capture-Ziele geeignet sind.

Aktuell relevant:

- Strategic Airfields
- Secondary Airfields

Nicht automatisch capture-fähig:

- Helipads
- Medical Pads
- Tactical Pads
- Unknown Objects
- rein technische Sonderobjekte

Diese Filterung verhindert, dass alle 225 Airbase-like Objects zu Capture-Zielen werden.

---

## 17. Mission Candidates

Bestätigt:

    missionCandidates: 32

Mission Candidates bilden eine Airbase-basierte Zielmenge für den MissionGenerator.

Mögliche Missionstypen:

- Recon
- Strike
- Airbase Attack
- SEAD
- DEAD
- Interdiction
- CAP im Umfeld
- Logistics Support

Der Airbase Scanner entscheidet nicht, welche konkrete Mission erzeugt wird.

Diese Entscheidung liegt beim MissionGenerator.

---

## 18. Logistics Candidates

Bestätigt:

    logisticsCandidates: 46

Logistics Candidates bilden die Grundlage für LogisticsDelivery.

Logistik ist breiter als Capture.

Deshalb:

    46 Logistics Candidates
    >
    32 Capture Candidates

Mögliche Rollen:

- Supply Hub
- Fuel Hub
- Ammo Hub
- Engineering Hub
- Transportziel
- Forward Support
- FOB-Bezug

LogisticsDelivery erzeugt daraus aktuell:

    46 Logistics Hubs

---

## 19. Verhältnis zu ZoneFactory

Airbase Scanner:

    erkennt und klassifiziert DCS-Airbase-like Objects

ZoneFactory:

    erzeugt daraus Kampagnenzonen

Aktuelle ZoneFactory-Werte:

    total zones: 46
    classified airbase zones: 46
    Mission Editor zones: 0
    skipped airbase-like objects: 179
    strategic zones: 19
    secondary zones: 13
    heliport zones: 1
    farp zones: 0
    tactical zones: 13
    captureZones: 32
    missionZones: 32
    logisticsZones: 46
    startBaseZones: 1

Wichtig:

    225 erkannte Airbase-like Objects
    -> 46 relevante Kampagnenzonen

Das ist korrekt und gewollt.

---

## 20. Verhältnis zu CaptureSystem

CaptureSystem:

    src/campaign/tc_capture_system.lua
    v0.2.2

nutzt Airbase- und Zonendaten.

Bestätigt:

    eligibleBases: 32
    eligibleZones: 32
    nonCaptureBases: 193
    nonCaptureZones: 14
    pressureRecords: 32
    progressRecords: 32

Bestätigter Wirkungspfad:

    Mission Completion
    -> Capture Pressure
    -> Capture Progress
    -> Capture Ready

Mission Failure:

    kein Capture Pressure

Capture Ready Apply kann:

- Zone Ownership ändern
- linked Airbase Ownership synchronisieren
- Progress zurücksetzen
- Capture Ready beenden
- Persistence Dirty setzen

Bestätigter Regressionstest:

    ZONE_AIRBASE_ABU_AL_DUHUR
    RED -> BLUE
    linked Airbase -> BLUE
    progress -> 0
    status -> STABLE
    captureReady -> false

AirbaseScanner selbst führt keinen Ownership-Wechsel aus.

---

## 21. Capture Read-Neutrality

CaptureSystem wurde hinsichtlich Read-Neutrality geprüft.

Bestätigt:

- Capture Getter erzeugen bei unverändertem State keinen unnötigen Dirty-State.
- same-owner Ownership-Aufrufe sind No-Ops.
- echte Ownership-Mutationen können Dirty markieren.

AirbaseScanner benötigt daraus aktuell keinen eigenen Fix.

Priority 3 ist im dokumentierten Umfang abgeschlossen.

---

## 22. Verhältnis zu LogisticsDelivery

LogisticsDelivery:

    src/logistics/tc_logistics_delivery.lua
    v0.2.1

nutzt die aus Airbase-/Zone-Daten erzeugten Logistics Hubs.

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

CTLD ist inzwischen für einen isolierten KI-Truppentransport praktisch getestet.

Noch nicht produktiv verbunden ist jedoch:

    Airbase / Logistics State
    -> Theater-Command-Transportauftrag
    -> CTLD-Ausführung
    -> LogisticsDelivery-Ergebnis

Diese produktive Kopplung gehört zu Priority 4.

---

## 23. Verhältnis zu FobSystem

FobSystem:

    src/logistics/tc_fob_system.lua
    v0.2.1

nutzt Logistics-/Zone-Daten, die auf der Airbase-Klassifikation aufbauen.

Bestätigt:

    FOB candidates: 6
    stored candidates: 6
    auto-planned FOBs: 2
    skipped candidates: 4
    Blue FOBs: 2

State-only FOBs:

    FOB Ercan
    FOB Gecitkale

Status:

    UNDER_CONSTRUCTION

Priority-3-Ergebnis:

    Read-Neutrality bestanden

Die FOBs sind noch keine real durch CTLD aufgebauten DCS-FOBs.

---

## 24. Verhältnis zu MissionGenerator

MissionGenerator:

    src/missions/tc_mission_generator.lua
    v0.2.3

nutzt unter anderem:

- Airbase-Daten
- Zonen
- Capture-State
- Logistics
- FOBs

Aktuelle Werte:

    mission candidates: 78
    fobSupportCandidates: 2
    generated missions: 10

Bestätigt:

- Mission Details
- Mission Activation
- Mission Completion
- Mission Failure
- Mission Effects
- Completion -> Capture Pressure
- Failure -> kein Capture Pressure

MissionGenerator entscheidet nicht direkt über Airbase Ownership.

AirbaseScanner liefert lediglich einen Teil der Zielgrundlage.

Der frühere Mission-Record-Loss-Verdacht wurde widerlegt.

---

## 25. Verhältnis zu AICapManager

AICapManager:

    src/ai/tc_ai_cap_manager.lua
    v0.2.1

nutzt Airbase- und Zonendaten für CAP-State.

Bestätigt:

    cap zone candidates: 31
    auto-registered CAP zones: 12
    CAP requests: 12

Aktuell:

    state-first
    keine realen MOOSE-CAP-Flüge

Priority-3-Ergebnis:

    Read-Neutrality bestanden

Bekannter latenter Punkt:

    reactToActiveMissions()

besitzt aktuell keine produktive Call-Site.

Er wird bei späterer Verdrahtung erneut geprüft.

---

## 26. Verhältnis zu CTLD

CTLD:

    1.6.1

ist für Theater Command ein Execution Layer für spätere reale Transport- und Logistics-Aktionen.

Am 2026-09-29 wurde für den getesteten Aufbau ein isolierter KI-Truppentransport bestätigt:

    Pickup
    -> Mi-8 Transport
    -> Off-Airfield-Landung
    -> automatischer Dropoff
    -> reale Blue-Bodengruppe

Dieser Test beweist:

    CTLD kann diesen getesteten Transportpfad technisch ausführen.

Er beweist nicht:

    AirbaseScanner steuert CTLD.
    LogisticsDelivery steuert CTLD bereits produktiv.
    FOBs werden bereits real gebaut.

AirbaseScanner bleibt reine World-/Klassifikationslogik.

---

## 27. CTLD-Bezug zu Akrotiri

Praktisch verwendete CTLD-Pickup-Zone:

    CTLD_PICKUP_BLUE_AKROTIRI_01

Sie liegt im Bereich Akrotiri.

Der erfolgreiche Testtransport nahm dort automatisch:

    16 Soldaten

auf.

Der technische Test-Dropoff war:

    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01

Dieser Test bestätigt einen möglichen realen Transportpfad aus dem Blue-Ausgangsraum.

Er ist noch keine produktive Kampagnenoperation.

---

## 28. Airbase-State und Persistence

PersistenceSystem:

    src/campaign/tc_persistence_system.lua
    v0.2.6

speichert Campaign-State dirty-aware.

Bestätigt:

- Snapshot
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

Airbase-/World-/Ownership-Daten sind Teil des Kampagnenstates.

Bestätigter Ownership-Persistence-Pfad:

    Capture Ready Apply
    -> Ownership Update
    -> Dirty
    -> Background Autosave
    -> SAVED

Verbindlich:

    productiveRestore=false

Speichern ist technisch bestätigt.

Produktive Kampagnenfortsetzung aus dem Save beim Missionsstart ist noch nicht freigegeben.

---

## 29. Produktiver Restore

Priority 3 ist inzwischen abgeschlossen und damit nicht mehr der offene Restore-Blocker.

Vor produktivem Restore bleiben unter anderem zu klären:

- Restore-/Initialisierungsreihenfolge
- Save-Versionierung
- Save-Kompatibilität
- Modul-Lifecycle
- Framework-Rekonstruktion
- Schutz vor doppelten Nebenwirkungen
- kontrollierter Restore-End-to-End-Test

AirbaseScanner darf beim späteren Restore nicht unkontrolliert einen bereits importierten Kampagnenzustand überschreiben.

Die genaue Restore-Architektur bleibt separat zu definieren.

---

## 30. Datenqualität

Die aktuelle Airbase-Datenqualität ist für den bestehenden state-first Stand ausreichend.

Bestätigt:

- Akrotiri korrekt erkannt
- Strategic und Secondary Airfields getrennt
- Helipads getrennt
- Medical Pads getrennt
- Tactical Pads getrennt
- Unknown Objects konservativ behandelt
- Capture Candidates sinnvoll reduziert
- Mission Candidates sinnvoll reduziert
- Logistics Candidates breiter, aber kontrolliert
- ZoneFactory nutzt diese Daten
- CaptureSystem nutzt diese Daten
- LogisticsDelivery nutzt diese Daten
- FobSystem nutzt diese Daten
- MissionGenerator nutzt diese Daten
- AICapManager nutzt diese Daten

Später optional:

- einzelne Syria-Namen manuell prüfen
- Unknown Objects analysieren
- Override-Liste einführen
- erweiterten Debug-Report erzeugen

Diese Punkte sind aktuell keine Blocker.

---

## 31. Konservative Klassifikation

Theater Command verwendet bewusst konservative Klassifikationsregeln.

Grundsatz:

    Falsch positive strategische Ziele sind problematischer
    als zunächst nicht verwendete Sonderobjekte.

Vorteile:

- weniger fehlerhafte Missionen
- sinnvollere Capture-Ziele
- stabilere Logistics-Struktur
- klarere AI-Grundlage
- weniger Sonderfallfehler
- besser kontrollierbarer Persistence-State

---

## 32. Debug

Aktueller technischer Debug-Pfad:

    dcs.log

Relevante Suchbegriffe:

    AirbaseScanner
    Airbase scan completed
    classification
    strategic
    secondary
    captureCandidates
    missionCandidates
    logisticsCandidates
    blueStartBases
    redStrategicCandidates

Perspektivisch möglich:

- Airbase Summary
- Airbase Detail Report
- Liste Strategic
- Liste Secondary
- Liste Unknown
- Liste ausgeschlossener Objekte
- F10-Debug
- Text-/CSV-Dump

Keine dieser Komfortfunktionen ist aktuell für den nächsten Projektfortschritt erforderlich.

---

## 33. Nicht-Ziele des Airbase Scanners

Der Airbase Scanner soll nicht:

- alle 225 Objekte zu Capture-Zielen machen
- alle 225 Objekte zu Mission Targets machen
- Medical Pads zu Strategic Airfields machen
- Helipads pauschal strategisch behandeln
- Unknown Objects automatisch aufwerten
- MOOSE-Spawns ausführen
- CTLD-Operationen ausführen
- IADS initialisieren
- Missionsentscheidungen treffen
- Logistics Deliveries auslösen
- FOBs bauen

Diese Verantwortlichkeiten gehören in andere fachliche Systeme.

---

## 34. Aktueller getesteter Systemstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | Background Persistence bestanden |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.1` | Read-Neutrality bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.1` | Read-Neutrality bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | bestanden |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.1` | Read-Neutrality bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` | KI-Truppentransport-PoC für getesteten Aufbau bestanden |

Priority 3:

    abgeschlossen im dokumentierten Umfang seit 2026-09-21

---

## 35. Aktueller Entwicklungsbereich

Der nächste technische Schritt liegt nicht im Airbase Scanner.

AirbaseScanner bleibt:

    v0.2.2
    bestanden
    aktuell ohne notwendigen Code-Fix

Aktueller Entwicklungsbereich:

    Priority 4 – produktive CTLD-Integration vorbereiten

Dabei muss unter anderem geklärt werden:

- wie Logistics Needs zu Transportaufträgen werden
- wie CTLD-Zonen idempotent registriert werden
- wie KI-Transporter registriert werden
- wie Transporter-Lifecycle verwaltet wird
- wie CTLD-Ergebnisse validiert werden
- wie Ergebnisse in LogisticsDelivery beziehungsweise FobSystem zurückgeführt werden
- welche Änderungen Dirty markieren
- welche Daten persistiert werden
- welche Framework-Daten runtime-only bleiben

Das Airbase-System liefert dafür weiterhin die stabile World-Grundlage.

---

## 36. Aktueller Status

Stand:

    2026-09-29

Das Airbase-System ist für den aktuellen state-first Entwicklungsstand bestanden.

Bestätigte Grundlage:

    225 Airbase-like Objects erkannt
    19 Strategic Airfields
    13 Secondary Airfields
    1 Heliport
    95 Helipads
    40 Medical Pads
    13 Tactical Pads
    44 Unknown Objects
    0 FARPs
    32 Capture Candidates
    32 Mission Candidates
    46 Logistics Candidates
    1 Blue Start Base
    18 Red Strategic Candidates
    46 relevante Kampagnenzonen

Nachgelagerte Systeme nutzen diese Grundlage erfolgreich.

Zusätzlich bestätigt:

- linked Airbase Ownership Sync
- dirty-aware Persistence
- Priority 3 abgeschlossen
- CTLD-KI-Truppentransport-PoC für den getesteten Aufbau bestanden

Weiterhin offen:

- produktive CTLD-Orchestrierung
- reale CTLD-FOBs
- reale MOOSE-Flüge
- AI Director
- IADS-Integration
- Ground Campaign
- produktiver Restore
- Multiplayer

Aktueller Übergang:

    stabiler Airbase-/World-State
    +
    stabiler state-first Kampagnenkern
    +
    abgeschlossene Dirty-Coverage
    +
    bestandener isolierter CTLD-Transport-PoC
    ->
    kontrollierte produktive CTLD-Integration
