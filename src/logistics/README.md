# Logistics

## Verbindlicher Stand — 2026-09-29

Dieser Ordner enthält die eigene logistische Kampagnenlogik von **Theater Command DCS**.

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue startet auf Akrotiri / Zypern.
    Das syrische Festland ist zu Kampagnenbeginn rot kontrolliert.

Grundprinzip:

    Theater Command = Campaign Logic / State Owner
    CTLD = Execution Layer

Eigene Logik liegt unter:

    src/

Vendor-Frameworks liegen unter:

    vendor/

Vendor-Dateien werden nicht verändert.

Aktueller Entwicklungsbereich:

    Priority 4 – produktive CTLD-Integration vorbereiten

Verbindlich:

    productiveRestore=false

---

## 1. Aktive Dateien

Aktuell aktiv:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

Aktuelle Versionen:

    LogisticsDelivery v0.2.1
    FobSystem v0.2.1

Beide Systeme sind für den aktuellen state-first Stand funktional und bezüglich der dokumentierten Read-Neutrality-Regressionen bestanden.

---

## 2. Aufgabe des Logistics-Bereichs

`src/logistics/` verwaltet die logistische Kampagnenebene.

Langfristig soll Logistik unter anderem beeinflussen:

- Versorgung
- FOB-Aufbau
- FOB-Versorgung
- Operationsradius
- Missionsverfügbarkeit
- Engineering
- Repair
- Fuel
- Ammo
- Capture
- AI-Entscheidungen
- IADS-Reparatur
- Persistence

Aktuell liegt der Schwerpunkt auf:

- Logistics State
- FOB State
- MissionGenerator-Verknüpfung
- Persistence-Semantik
- Vorbereitung der produktiven CTLD-Integration

---

## 3. Architekturregel

Dateien werden nach fachlicher Aufgabe benannt.

Nicht nach Framework.

Verbindlich nicht gewünscht:

    tc_moose.lua
    tc_mist.lua
    tc_ctld.lua
    tc_ctld_all_in_one.lua
    tc_ctld_bridge.lua
    tc_all_in_one.lua
    tc_logistics_all_in_one.lua

Aktuell korrekt:

    tc_logistics_delivery.lua
    tc_fob_system.lua

Falls später eine weitere Datei erforderlich wird, muss ihr Name die konkrete Theater-Command-Aufgabe beschreiben.

Eine Datei wird nicht vorsorglich angelegt, nur weil CTLD verwendet wird.

---

## 4. LogisticsDelivery

Datei:

    src/logistics/tc_logistics_delivery.lua

Version:

    v0.2.1

Status:

    state-first bestanden
    Read-Neutrality bestanden

Aktuelle Aufgaben:

- Logistics Hubs aus relevanten Kampagnenzonen ableiten
- Hub Owner verwalten
- Hub Status verwalten
- Logistics State bereitstellen
- Delivery State vorbereiten
- FobSystem mit logistischen Daten versorgen
- MissionGenerator mit logistischen Daten versorgen
- F10-Status bereitstellen
- Persistence-relevante Mutationen markieren

Noch nicht Aufgabe des Moduls:

- Airbases selbst scannen
- Kampagnenzonen selbst erzeugen
- Ownership direkt erzwingen
- reale CTLD-Flüge unmittelbar ohne Orchestrierung starten
- Vendor-Code verändern

---

## 5. Aktuelle Logistics-Werte

Bestätigt:

    logistics hubs: 46
    blue hubs: 7
    red hubs: 24
    neutral hubs: 15
    active hubs: 31
    limited hubs: 15
    locked hubs: 0

Die 46 Logistics Hubs stammen aus den durch ZoneFactory gefilterten relevanten Kampagnenzonen.

Sie stammen nicht direkt aus allen:

    225

DCS-Airbase-like Objects.

---

## 6. Logistics-Hub-State

Aktuelle Statuswerte:

    ACTIVE
    LIMITED
    LOCKED

Aktuell sind diese Werte primär Campaign State.

Später können daraus unter anderem abgeleitet werden:

- Supply-Verfügbarkeit
- Transportbedarf
- FOB-Support
- Reparaturfähigkeit
- Missionspriorität
- AI-Reaktion

Diese späteren Wirkungen sind noch nicht vollständig produktiv implementiert.

---

## 7. LogisticsDelivery Read-Neutrality

Priority-3-Audit:

    abgeschlossen

Fix-Version:

    v0.2.1

Bestätigte read-neutrale Pfade:

    getStatistics()
    getHubSummary()
    summary()

Diese Reads verändern keinen persistierten Logistics-State mehr.

Positive Gegenprobe:

    createDelivery()

setzt bei echter Mutation weiterhin:

    dirtyReason=logistics_delivery_created

Damit gilt:

    Read
    -> kein Dirty

und:

    echte Delivery-Mutation
    -> Dirty

---

## 8. FobSystem

Datei:

    src/logistics/tc_fob_system.lua

Version:

    v0.2.1

Status:

    state-first bestanden
    Read-Neutrality bestanden

Aufgaben:

- FOB-Kandidaten aus Logistics State ableiten
- geeignete Blue-FOBs planen
- FOB-State verwalten
- FOB-Status verwalten
- MissionGenerator mit FOB-Support-Daten versorgen
- spätere reale CTLD-/DCS-Ausführung vorbereiten

Aktuell erzeugt FobSystem keine realen CTLD-FOBs.

---

## 9. Aktuelle FOB-Werte

Bestätigt:

    FOB candidates: 6
    stored candidates: 6
    auto-planned FOBs: 2
    skipped candidates: 4
    Blue FOBs: 2

Aktuelle Blue-FOBs:

    FOB Ercan
    FOB Gecitkale

Status:

    UNDER_CONSTRUCTION

Diese FOBs existieren aktuell als Theater-Command-State.

Sie sind noch keine real gebauten DCS-/CTLD-FOBs.

---

## 10. FobSystem Read-Neutrality

Priority-3-Audit:

    abgeschlossen

Fix-Version:

    v0.2.1

Bestätigte read-neutrale Pfade umfassen unter anderem:

    getStatistics()
    summary()
    get()
    getAll()
    getCandidates()
    getByStatus()
    getByOwner()
    getBlueFobs()

Positive Gegenprobe:

    FobSystem.create()

setzt bei echter Mutation weiterhin:

    dirtyReason=fob_created

Damit gilt auch hier:

    Read
    -> kein Dirty

und:

    echte FOB-Mutation
    -> Dirty

---

## 11. Priority 3

Priority 3 wurde am:

    2026-09-21

im dokumentierten Umfang abgeschlossen.

Für den Logistics-Bereich relevant:

    LogisticsDelivery v0.2.1
    FobSystem v0.2.1

Beide aktiven Read-Neutrality-Probleme wurden behoben und regressionsgetestet.

Priority 3 ist nicht mehr der aktuelle Arbeitsbereich.

Ein erneuter vollständiger Audit erfolgt nur bei neuem technischem Anlass.

---

## 12. Beziehung zu World

Vorgelagerte Systeme:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

Bestätigte World-Werte:

    Syria airbase-like objects: 225
    relevante Kampagnenzonen: 46
    logisticsCandidates: 46
    logisticsZones: 46

Logistics verwendet diese Daten für:

- Logistics Hubs
- Hub Owner
- Hub Status
- FOB Candidates
- spätere Transportquellen
- spätere Transportziele

Logistics scannt Airbases nicht selbst.

Logistics erzeugt die grundlegenden Kampagnenzonen nicht selbst.

---

## 13. Beziehung zu CaptureSystem

CaptureSystem:

    v0.2.2

Bestätigt:

    eligibleBases: 32
    eligibleZones: 32
    pressureRecords: 32
    progressRecords: 32

Aktuell produktiv bestätigt ist:

    Mission Completion
    -> Capture Pressure
    -> Capture Progress
    -> Capture Ready
    -> Ownership

Eine direkte produktive:

    Logistics
    -> Capture

Kopplung existiert noch nicht.

Perspektivisch kann Logistik beispielsweise Einfluss haben auf:

- Capture-Fähigkeit
- Verteidigungsfähigkeit
- Operationsradius
- FOB-Unterstützung
- Verstärkung

Diese Wirkungen sind noch Zukunftsarchitektur.

---

## 14. Beziehung zu MissionGenerator

MissionGenerator:

    src/missions/tc_mission_generator.lua
    v0.2.3

Bestätigte Werte:

    mission candidates: 78
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 68

MissionGenerator erkennt die beiden state-first FOB-Projekte bereits als Support-Kandidaten.

Damit besteht bereits die State-Verbindung:

    Logistics / FOB
    -> MissionGenerator Candidate State

Noch nicht vorhanden ist:

    MissionGenerator
    -> realer CTLD-Transport

Missionen bleiben für diesen Bereich noch state-first.

---

## 15. Mission-Record-Diagnose

Der frühere Verdacht, dass Mission Records verloren gehen, ist widerlegt.

MissionGenerator erzeugt:

    10 Mission Records

Die Mission-Status-Collections sind String-keyed Lua-Dictionaries.

Deshalb ist:

    #table

für deren Anzahl nicht autoritativ.

Korrekt ist eine pairs-basierte Zählung.

Es gibt keinen bestätigten Mission-Record-Datenverlust.

Die alte Klassifikation:

    PROJECT SOURCE HAS NO MATCHING WRITE SITE

ist nur historischer, inzwischen widerlegter Diagnosekontext und kein aktueller Logistics-Blocker.

---

## 16. Beziehung zu AI

AICapManager:

    src/ai/tc_ai_cap_manager.lua
    v0.2.1

Bestätigt:

    cap zone candidates: 31
    CAP zones: 12
    CAP requests: 12

Read-Neutrality:

    bestanden

Noch keine:

    realen MOOSE-CAP-Flüge

Perspektivisch kann Logistics AI beeinflussen durch:

- Schutz von Logistics Hubs
- Schutz von Transporten
- FOB-Verteidigung
- Interdiction
- Supply-Priorisierung
- CAP über Logistikkorridoren

AI Director ist noch nicht produktiv implementiert.

---

## 17. Beziehung zu IADS

Skynet IADS:

    3.3.0

ist als Vendor-Framework geladen.

Eine produktive Theater-Command-IADS-Schicht existiert noch nicht.

Perspektivisch kann Logistik relevant sein für:

- Reparatur beschädigter SAM-Systeme
- Nachschub
- Engineering
- Ersatz
- Missionspriorisierung
- Interdiction

Aktuell besteht keine produktive Logistics-IADS-Kopplung.

---

## 18. Beziehung zu F10

F10Menu:

    v0.2.3

Bestätigt:

    33 Commands

Im Logistics-Bereich verfügbar:

    Show Logistics Status
    Show FOB Status

Zusätzlich sind unter anderem vorhanden:

- Mission Details
- Mission Activation
- Mission Completion
- Mission Failure
- Campaign Status
- Capture Status
- Capture Ready
- Capture Ready Apply
- Pressure Contested
- AI CAP Status

F10 ist aktuell vor allem:

- Statuszugang
- Debugzugang
- kontrollierter Testzugang

Es ist nicht der langfristige Motor der Logistik.

---

## 19. Beziehung zu Persistence

PersistenceSystem:

    v0.2.6

Status:

    dirty-aware Background Persistence bestanden

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

Verbindlich:

    productiveRestore=false

Logistics- und FOB-State sind Bestandteil des persistierbaren Theater-Command-State.

Richtig ist:

- Background Persistence funktioniert.
- relevante echte Logistics-/FOB-Mutationen können Dirty setzen.
- produktiver Startup-Restore ist weiterhin deaktiviert.
- reale CTLD-Ergebnisse sind noch nicht produktiv in Logistics-/FOB-State zurückgeführt.

---

## 20. CTLD

Vendor:

    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua

Version:

    CTLD 1.6.1

Vendor-Regel:

    unverändert lassen

CTLD ist der vorgesehene Execution Layer für reale Transport- und Cargo-Funktionen.

Perspektivisch:

- Truppentransport
- Cargo
- Engineering
- Repair
- Supply
- Fuel
- Ammo
- FOB-Aufbau
- FOB-Versorgung

---

## 21. CTLD-Status seit 2026-09-29

Am 2026-09-29 wurde für einen isolierten getesteten Aufbau ein vollständiger KI-Truppentransport praktisch bestätigt.

Status:

    Framework-Proof-of-Concept für den getesteten Aufbau bestanden

Noch nicht:

    produktive Theater-Command-CTLD-Integration

Der bestandene PoC darf nicht auf nicht getestete Cargo-, Crate-, FOB- oder Multiplayer-Pfade verallgemeinert werden.

---

## 22. CTLD-Testmission

Testmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz

SHA-256 vor dem erfolgreichen Runtime-Test:

    5F0D89DF744A7083401E36713B148BD21813FF187CC36EC1F088507163458C57

Testgruppe:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01

Testunit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Luftfahrzeug:

    Mi-8

---

## 23. CTLD-Zonen

Verwendeter Pickup:

    CTLD_PICKUP_BLUE_AKROTIRI_01

Verwendeter technischer Dropoff:

    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01

Reservierter späterer FOB-Dropoff:

    CTLD_DROPOFF_BLUE_ERCAN_FOB_01

Details:

    mission_editor/ctld_start_zones.md

Der technische Test-Dropoff westlich Akrotiri ist kein produktiver FOB-Dropoff.

---

## 24. CTLD Runtime-Zonenregistrierung

Für den getesteten Runtime-Pfad bestätigt:

Nach bestehender CTLD-Initialisierung konnten normalisierte Einträge ergänzt werden in:

    ctld.pickupZones
    ctld.dropOffZones

Getesteter Pickup-Eintrag:

    { "CTLD_PICKUP_BLUE_AKROTIRI_01", -1, 10000, 1, 2 }

Getesteter Dropoff-Eintrag:

    { "CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01", -1, 2, 1 }

Eine erneute Ausführung von:

    ctld.initialize()

war für den getesteten Pfad nicht erforderlich.

Daraus wird nicht abgeleitet, dass ein erneuter Aufruf grundsätzlich verboten wäre.

---

## 25. CTLD KI-Transporterregistrierung

Wichtiger Befund:

Der verwendete KI-Transporter musste für den getesteten CTLD-AI-Pfad in:

    ctld.transportPilotNames

registriert sein.

Testunit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Vor Registrierung:

    108 Einträge

Nach temporärer idempotenter Registrierung:

    109 Einträge

Die Testunit war genau einmal vorhanden.

Eine produktive Theater-Command-Integration muss diese Registrierung später automatisch und idempotent durchführen.

---

## 26. Bestätigter CTLD-Pickup

Für den getesteten Aufbau bestätigt:

Nach nativer Aktivierung der Gruppe:

    16 Soldaten automatisch aufgenommen

Pickup-Counter:

    10000 -> 9999

Nicht verwendet:

- manuelles CTLD-Loading
- direkte Manipulation des Onboard-State
- Teleport
- Runtime-Routenänderung
- Runtime-Taskänderung

Der Pickup wurde durch CTLD ausgeführt.

---

## 27. Bestätigter Transportflug

Für den getesteten Aufbau bestätigte DCS-AI selbständig:

- Taxi
- Takeoff
- Transit
- Descent
- Off-Airfield-Anflug

Die Route und der Land Task waren in der Mission gespeichert.

Es war keine Runtime-Routen- oder Taskmanipulation erforderlich.

---

## 28. Off-Airfield-Landung

Für den getesteten Mi-8-Aufbau erfolgreicher Aufbau:

    normaler Turning Point
    +
    Perform Task -> Land

Dropoff-Zentrum:

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

Der Mi-8 blieb nach dem Touchdown mindestens ungefähr:

    220 Sekunden

am Boden.

Der volle konfigurierte Zeitraum von 300 Sekunden musste für den Dropoff-Nachweis nicht abgewartet werden, da der automatische CTLD-Dropoff vorher bereits eindeutig erfolgt war.

Für diesen getesteten KI-Truppentransport war kein Invisible FARP erforderlich.

Daraus wird nicht abgeleitet, dass ein FARP für:

- andere Luftfahrzeuge
- Cargo-/Crate-Pfade
- reale FOB-Infrastruktur
- andere CTLD-Funktionen

grundsätzlich unnötig wäre.

Der zuvor verwendete ungebundene `Land / Landing`-Waypoint hatte keinen vollständigen erfolgreichen Transportzyklus geliefert.

Die genaue Ursache des früheren Turnbacks ist dadurch nicht abschließend bewiesen.

---

## 29. Bestätigter CTLD-Dropoff

Für den getesteten Aufbau führte CTLD nach der Landung den Dropoff automatisch aus.

Bestätigt:

- transportierte Truppen wurden aus dem In-Transit-State der Unit entfernt
- `ctld.droppedTroopsBLUE` erhielt genau einen neuen Eintrag
- reale Blue-Bodengruppe wurde erzeugt

Gruppe:

    Dropped Group 2

Group-ID:

    70001

Stärke:

    16 x Soldier M249

Damit ist für den getesteten Aufbau bestätigt:

    Pickup
    -> Flug
    -> Off-Airfield-Landung
    -> Dropoff
    -> Bodengruppe

---

## 30. Grenze des CTLD-Proof-of-Concept

Der Test bestätigt die technische Framework-Fähigkeit für den dokumentierten Aufbau.

Er bestätigt noch nicht:

- automatische Theater-Command-Auftragserzeugung
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
- realen FOB-Bau
- Capture-Wirkung aus Logistik
- AI-Director-Verknüpfung
- CTLD-Restore
- Multiplayer
- Verhalten beliebiger anderer Transporter oder Landezonen

Der bestandene Test war:

    KI-Truppentransport

und kein:

    Cargo-/Crate-PoC

---

## 31. Bekannter CTLD-Integrationspunkt

Beim **Touchdown** des registrierten KI-Transporters wurde genau einmal beobachtet:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Kontext:

    updateRepackMenu
    updateRepackMenuOnlanding

Während der anschließenden ungefähr 220 Sekunden Bodenbeobachtung wurde der Fehler nicht erneut beobachtet.

Source-Analyse legt nahe:

- die KI-Unit wird über `ctld.transportPilotNames` vom relevanten CTLD-Pfad verarbeitet
- `ctld.vehicleCommandsPath[_unitName]` ist für eine reine KI-Unit nicht zwingend vorhanden
- der daraus abgeleitete Repack-Menüpfad kann deshalb `nil` sein

Pickup und Dropoff wurden dennoch erfolgreich abgeschlossen.

Nicht bewiesen:

- dass der Fehler harmlos ist
- dass spätere Repack-Menü-Aktualisierungen funktionieren
- dass der betroffene Scheduler danach vollständig weiterläuft
- dass der betroffene Scheduler danach beendet wurde

Ein möglicher Scheduler-Abbruch bleibt:

    source-basierte technische Inferenz

und ist kein:

    direkter Runtime-Beweis

Verbindlich:

    vendor/ctld/CTLD.lua wird nicht gepatcht.

Der Fall muss vor produktiver Integration source-backed behandelt beziehungsweise sauber isoliert werden.

---

## 32. State-first vs. Execution Layer

Der entscheidende Architekturübergang lautet:

    Theater-Command-State
    -> Auftrag
    -> CTLD-Ausführung
    -> Ergebnisvalidierung
    -> Theater-Command-State
    -> Dirty
    -> Persistence

Nicht:

    CTLD-interne Runtime-Tabellen
    =
    langfristiger Campaign-State

Theater Command bleibt State Owner.

CTLD bleibt Execution Layer.

---

## 33. FOB-Zielarchitektur

Aktuelle state-first FOBs:

    FOB Ercan
    FOB Gecitkale

Perspektivischer Pfad:

    MissionGenerator
    -> Logistics Auftrag
    -> reale CTLD-Ausführung
    -> Delivery Validation
    -> LogisticsDelivery
    -> FobSystem
    -> Build Progress
    -> FOB Activation
    -> Persistence

Dieser Pfad ist noch nicht produktiv implementiert.

---

## 34. Cargo-/Crate-Bereich

Noch separat zu testen:

- Crate Spawn
- Crate Loading
- Sling Load
- Crate Drop
- Logistics-Zone-Voraussetzungen
- Supply
- Engineering
- Repair
- Fuel
- Ammo
- FOB Core

Ein erfolgreicher Truppentransport wird nicht als Beleg für diese Funktionen verwendet.

---

## 35. Namespace

Der Logistics-Bereich nutzt den zentralen Theater-Command-Namespace.

Aktuell relevant:

    TC.Logistics
    TC.Logistics.Delivery
    TC.Logistics.FobSystem
    TC.State.Logistics

Weitere Namespace-Strukturen werden nur bei tatsächlichem Implementierungsbedarf ergänzt.

Keine zusätzlichen globalen Parallel-Namespaces einführen.

---

## 36. Ladeposition

Aktuelle Theater-Command-Ladereihenfolge im relevanten Abschnitt:

    CaptureSystem
    -> PersistenceSystem
    -> LogisticsDelivery
    -> FobSystem
    -> MissionGenerator
    -> AICapManager
    -> F10Menu
    -> Main
    -> Loader

Logistics kann davon ausgehen, dass:

- Core geladen ist
- World geladen ist
- CaptureSystem geladen ist
- PersistenceSystem geladen ist

---

## 37. Persistence-Schutz beim CTLD-Test

Produktive Save-Datei:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Bestätigter SHA-256:

    C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596

Backup vor dem Test:

    C:\Users\Paul\Documents\TC_miz_backups\operation_levant_reclamation_save__pre_landtask_test_2026-09-29_100813.lua

Der produktive Save wurde während des isolierten Tests geschützt.

Nach vollständig beendetem DCS bestätigt:

- Größe unverändert
- Änderungszeit unverändert
- SHA-256 unverändert
- Campaign-State unverändert

Final:

    ReadOnly=False

---

## 38. Aktuelle Architekturgrenze

Aktuell bewiesen:

    Logistics State
    FOB State
    MissionGenerator FOB-Support
    Persistence Dirty-Semantik
    CTLD Framework-Truppentransport für den getesteten Aufbau

Noch nicht produktiv verbunden:

    Theater Command Logistics
    <->
    CTLD Runtime

Diese Verbindung ist der nächste technische Architekturbereich.

---

## 39. Nächster Entwicklungsbereich

Aktueller Projektbereich:

    Priority 4 – produktive CTLD-Integration vorbereiten

Der nächste Schritt ist nicht:

- erneut Priority 3 auditieren
- denselben Mi-8-Test wiederholen
- `tc_ctld.lua` anlegen
- `tc_ctld_bridge.lua` anlegen
- CTLD-Vendor patchen
- sofort Crates implementieren
- parallel MOOSE CAP integrieren
- produktiven Restore aktivieren

Zuerst muss source-backed geklärt werden:

- welche fachliche Komponente den Transportauftrag besitzt
- welche Komponente CTLD-Zonen registriert
- welche Komponente Transporter registriert
- wie die Registrierung idempotent bleibt
- wie Transporter-Lifecycle behandelt wird
- wie der `RepackCommandsPath`-Fall behandelt oder isoliert wird
- wie Erfolg und Fehler erkannt werden
- welche Ergebnisse in `TC.State` geschrieben werden
- welche Änderungen Dirty setzen
- welche CTLD-Daten runtime-only bleiben
- was später nach Restore rekonstruiert werden muss

Erst danach wird eine konkrete Source-Datei festgelegt.

---

## 40. Aktueller Abschlussstand

Stand:

    2026-09-29

LogisticsDelivery:

    v0.2.1
    state-first bestanden
    Read-Neutrality bestanden

FobSystem:

    v0.2.1
    state-first bestanden
    Read-Neutrality bestanden

MissionGenerator:

    v0.2.3
    78 Candidates
    10 Mission Records
    2 FOB-Support Candidates

AICapManager:

    v0.2.1
    12 CAP Requests

Persistence:

    v0.2.6
    dirty-aware
    productiveRestore=false

CTLD:

    1.6.1
    KI-Truppentransport-PoC für den getesteten Aufbau bestanden
    produktive Theater-Command-Integration offen
    Cargo-/Crate-Pfad separat ungetestet
    RepackCommandsPath-Fehler genau einmal beim Touchdown beobachtet

Aktueller Übergang:

    stabiler Logistics-/FOB-State
    +
    abgeschlossene Priority-3-Dirty-Coverage
    +
    bestandener CTLD-KI-Transport-PoC für den getesteten Aufbau
    ->
    kontrollierte produktive CTLD-Integration
