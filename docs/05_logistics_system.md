# Logistics System

## Verbindlicher Stand — 2026-09-29

Diese Datei beschreibt den aktuellen Logistik-Layer von **Theater Command DCS**.

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

Der Logistik-Layer ist state-first aufgebaut.

Produktiver Theater-Command-State und reale DCS-/CTLD-Nebenwirkungen bleiben bewusst getrennt.

Aktueller Kernstand:

- LogisticsDelivery `v0.2.1` ist state-first funktional bestanden.
- FobSystem `v0.2.1` ist state-first funktional bestanden.
- LogisticsDelivery Read-Neutrality ist bestanden.
- FobSystem Read-Neutrality ist bestanden.
- Logistics-/FOB-State ist Bestandteil der Persistence-Snapshots.
- PersistenceSystem `v0.2.6` arbeitet dirty-aware im Hintergrund.
- `productiveRestore=false` bleibt bewusst gesetzt.
- MissionGenerator `v0.2.3` nutzt Logistics-/FOB-State bereits für Missionskandidaten.
- AICapManager `v0.2.1` ist state-first aktiv.
- CTLD `1.6.1` ist als unverändertes Vendor-Framework geladen.
- Die technische CTLD-Zonenregistrierung wurde praktisch bestätigt.
- Ein vollständiger automatischer CTLD-KI-Truppentransport wurde am 2026-09-29 praktisch bestätigt.
- Die produktive Theater-Command-CTLD-Integration existiert noch nicht.
- Crate-/Cargo-Logistik ist noch nicht praktisch bestätigt.
- Der CTLD-Fehler `RepackCommandsPath` bei einem registrierten KI-Transporter wurde beim Grounded-Übergang beobachtet und muss vor produktiver Integration berücksichtigt werden.

Der erfolgreiche CTLD-Test ist ein **Framework-Proof-of-Concept**.

Er bedeutet nicht, dass Theater Command bereits produktiv CTLD-Transporte plant, erzeugt oder steuert.

---

## 1. Zweck des Logistiksystems

Das Logistiksystem soll langfristig Versorgung, Transport, FOB-Aufbau und operative Reichweite der Kampagne steuern.

Logistik soll keine rein dekorative Schicht sein.

Sie soll später Einfluss haben auf:

- FOB-Aufbau
- FOB-Versorgung
- Capture-Fähigkeit
- Missionsverfügbarkeit
- Reparaturfähigkeit
- Nachschub
- Operationsradius
- AI-Entscheidungen
- Persistence
- CTLD-Transporte
- Cargo-Flüge
- Engineering
- Fuel
- Ammo
- Repair
- Supply

Die Architektur bleibt:

    State
    -> Sichtbarkeit
    -> isolierter Framework-Test
    -> kontrollierte Integration
    -> Persistence-/Restore-Absicherung
    -> produktive Kampagnenwirkung

---

## 2. Aktive Theater-Command-Dateien

Aktive eigene Logik:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

Getestete Versionen:

    LogisticsDelivery: v0.2.1
    FobSystem: v0.2.1

Weitere beteiligte Systeme:

    MissionGenerator: v0.2.3
    AICapManager: v0.2.1
    PersistenceSystem: v0.2.6
    F10Menu: v0.2.3

Vendor-Framework:

    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua

CTLD-Version:

    1.6.1

Vendor-Regel:

    vendor/ wird für Theater Command nicht verändert.

Nicht gewünscht sind generische Framework-Dateien wie:

    tc_ctld.lua
    tc_ctld_all_in_one.lua
    tc_all_in_one.lua

Eigene Integration wird weiterhin nach fachlicher Aufgabe unter `src/` organisiert.

---

## 3. Bestätigter state-first Logistikstand

LogisticsDelivery:

    logistics hubs: 46
    blue hubs: 7
    red hubs: 24
    neutral hubs: 15
    active hubs: 31
    limited hubs: 15
    locked hubs: 0

FobSystem:

    FOB candidates: 6
    stored candidates: 6
    auto-planned FOBs: 2
    skipped candidates: 4
    Blue FOBs: 2

Erzeugte Blue-FOBs:

    FOB Ercan
    FOB Gecitkale

Status:

    UNDER_CONSTRUCTION

MissionGenerator-Verknüpfung:

    fobSupportCandidates: 2
    reservedCreated: 1

Damit ist bestätigt:

- LogisticsDelivery lädt und startet.
- LogisticsDelivery erzeugt Logistics Hubs.
- LogisticsDelivery-Reads sind persistence-neutral.
- FobSystem lädt und startet.
- FobSystem erzeugt FOB-Kandidaten.
- FobSystem-Reads sind persistence-neutral.
- zwei Blue-FOBs werden state-only erzeugt.
- MissionGenerator erkennt FOB-Support-Kandidaten.
- F10Menu kann Logistics-/FOB-State anzeigen.
- Logistics-/FOB-State ist Teil des persistierbaren Theater-Command-State.

---

## 4. Dirty-Coverage des Logistik-Layers

Priority 3 wurde am:

    2026-09-21

im dokumentierten Umfang abgeschlossen.

### LogisticsDelivery

Version:

    v0.2.1

Bestätigte read-neutrale Pfade:

    getStatistics()
    getHubSummary()
    summary()

Diese Reads verändern keinen persistierten Logistics-State und erzeugen kein unnötiges Dirty.

Positive Gegenprobe:

    createDelivery()

setzt weiterhin:

    dirtyReason=logistics_delivery_created

### FobSystem

Version:

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

setzt weiterhin:

    dirtyReason=fob_created

Damit ist die allgemeine Priority-3-Dirty-Coverage dieser beiden aktiven Logistikmodule abgeschlossen.

Neue beziehungsweise später verdrahtete Lifecycle-Pfade müssen weiterhin separat geprüft werden.

---

## 5. Beziehung zu Airbase Scanner und ZoneFactory

LogisticsDelivery nutzt Daten aus:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

Vorgelagerter bestätigter Stand:

    Airbase-like Objects: 225
    relevante Kampagnenzonen: 46
    logisticsCandidates: 46
    logisticsZones: 46

Daraus erzeugt LogisticsDelivery:

    logistics hubs: 46

Damit basiert die Logistik nicht direkt auf allen DCS-Airbase-like Objects.

Sie verwendet die durch Theater Command klassifizierten und gefilterten Kampagnenzonen.

---

## 6. Logistics Hubs

Logistics Hubs sind persistierbare logistische Knoten des Theater-Command-State.

Ein Hub kann langfristig unter anderem enthalten:

- Owner
- Status
- Supply
- Fuel
- Ammo
- Engineering
- Repair Capacity
- Cargo Demand
- Cargo Delivered
- Build Progress
- Linked Zone
- Linked Base
- CTLD Pickup Capability
- CTLD Dropoff Capability
- FOB Support Capability
- Damage State

Aktuell:

    total: 46
    Blue: 7
    Red: 24
    Neutral: 15

Status:

    ACTIVE: 31
    LIMITED: 15
    LOCKED: 0

Diese Werte sind Theater-Command-State.

Sie erzeugen noch nicht automatisch reale CTLD-Operationen.

---

## 7. Blue Logistics

Blue besitzt aktuell sieben state-first Logistics Hubs.

Wichtigster Ausgangsknoten:

    Akrotiri

Akrotiri ist perspektivisch:

- Main Logistics Base
- Supply-Knoten
- Ausgangspunkt für Transportmissionen
- Ausgangspunkt für FOB-Aufbau
- Engineering-/Repair-Quelle
- CTLD-Pickup-Hub

Für den isolierten CTLD-Test wurde Akrotiri bereits erfolgreich als technischer Ausgangspunkt eines KI-Truppentransports verwendet.

Diese Testfähigkeit ist noch nicht automatisch mit dem produktiven LogisticsDelivery-State verdrahtet.

---

## 8. Red und Neutral Logistics

Red:

    24 Hubs

Neutral:

    15 Hubs

Perspektivische Red-Rollen:

- Versorgungsknoten
- Operationsbasis
- Interdiction-Ziel
- Strike-Ziel
- Missionsquelle
- Verstärkungsknoten
- AI-Director-Eingang

Perspektivische Neutral-Rollen:

- Capture-Ziel
- Forward Location
- logistischer Zwischenknoten
- zukünftiger FOB-/LZ-Kandidat
- nach Capture aktivierbare Infrastruktur

Diese Wirkungen sind noch nicht produktiv automatisiert.

---

## 9. FOB-System

Aktive Datei:

    src/logistics/tc_fob_system.lua

Version:

    v0.2.1

Aufgaben:

- FOB-Kandidaten aus Logistics Hubs ableiten
- geeignete Blue-FOBs planen
- FOB-State erzeugen
- Baufortschritt vorbereiten
- Versorgung vorbereiten
- MissionGenerator mit FOB-Support-Daten versorgen
- spätere reale DCS-/CTLD-Integration vorbereiten

Bestätigt:

    FOB candidates: 6
    Blue FOBs: 2

FOBs:

    FOB Ercan
    FOB Gecitkale

Status:

    UNDER_CONSTRUCTION

Die FOBs existieren aktuell als Theater-Command-State.

Sie sind keine automatisch durch CTLD gebauten realen FOBs.

---

## 10. FOB-Support und MissionGenerator

MissionGenerator nutzt den FOB-State bereits.

Bestätigt:

    fobSupportCandidates: 2
    reservedCreated: 1

MissionGenerator:

    v0.2.3

Mission Records:

    10

Bestandene Funktionen:

- Mission Details
- Activation
- Completion
- Failure
- Mission Effects
- FOB Support Candidate Integration

Der frühere Verdacht eines Mission-Record-Verlusts wurde widerlegt.

Die Mission-Collections sind String-keyed Lua-Dictionaries und werden über `pairs()` beziehungsweise pairs-basierte Hilfsfunktionen gezählt.

FOB-Support kann bereits als Kampagnenauftrag im State existieren.

Eine solche Mission löst aber noch nicht automatisch einen realen CTLD-Transport aus.

---

## 11. CTLD-Rolle

CTLD ist das Vendor-Framework für reale Transport- und Logistikinteraktion.

Aktuelle Vendor-Dateien:

    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua

CTLD:

    Version 1.6.1
    geladen
    initialisiert
    Vendor-Code unverändert

Perspektivische Aufgaben:

- Truppentransport
- Cargo aufnehmen
- Cargo transportieren
- Cargo absetzen
- FOB-Bau
- FOB-Versorgung
- Engineering
- Repair
- Supply
- Fuel
- Ammo
- Transporthelikopter
- spätere KI-Logistikoperationen

Wichtig:

    CTLD ist technisch in einem isolierten Truppentransport getestet,
    aber noch nicht produktiv durch Theater Command orchestriert.

---

## 12. CTLD-Zonenregistrierung

Die nachträgliche CTLD-Zonenregistrierung wurde praktisch bestätigt.

CTLD `1.6.1` war im erfolgreichen Test bereits initialisiert.

Danach wurden normalisierte Einträge ergänzt in:

    ctld.pickupZones
    ctld.dropOffZones

Eine erneute Ausführung von:

    ctld.initialize()

war dafür nicht erforderlich und wurde im Test nicht durchgeführt.

Im erfolgreichen Test wurden registriert:

Pickup:

    CTLD_PICKUP_BLUE_AKROTIRI_01

Dropoff:

    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01

Getesteter Pickup-Eintrag:

    { "CTLD_PICKUP_BLUE_AKROTIRI_01", -1, 10000, 1, 2 }

Getesteter Dropoff-Eintrag:

    { "CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01", -1, 2, 1 }

Die Einträge wurden aus dem CTLD-Live-State zurückgelesen und anschließend tatsächlich vom Framework verwendet.

Damit ist die grundsätzliche Runtime-Zonenregistrierung praktisch bestätigt.

Details:

    mission_editor/ctld_start_zones.md

---

## 13. KI-Transporter und `transportPilotNames`

Der Test vom 2026-09-29 bestätigte eine zusätzliche CTLD-Voraussetzung.

Der verwendete KI-Transporter musste für den getesteten CTLD-AI-Pfad in:

    ctld.transportPilotNames

registriert sein.

Getestete Unit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Vor Registrierung:

    108 Einträge
    Testunit nicht enthalten

Nach temporärer idempotenter Registrierung:

    109 Einträge
    Testunit genau einmal enthalten

Die Registrierung erfolgte über den exakten Unit-Namen.

Source-Audit:

    ctld.checkAIStatus()

iteriert über:

    ctld.transportPilotNames

Konsequenz:

Eine spätere produktive Theater-Command-Integration muss vorgesehene KI-Transporter automatisch und idempotent registrieren.

Dabei gilt:

- keine Duplikate
- exakte Unit-Namen
- keine Vendor-Modifikation
- keine direkte Manipulation des Onboard-State
- Lifecycle von Aktivierung, möglichem Spawn und Despawn berücksichtigen

---

## 14. Bestätigter CTLD-KI-Truppentransport

Testdatum:

    2026-09-29

Testmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz

SHA-256 vor dem Test:

    5F0D89DF744A7083401E36713B148BD21813FF187CC36EC1F088507163458C57

Testgruppe:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01

Testunit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Luftfahrzeug:

    Mi-8

Ablauf:

    CTLD-Zonen registrieren
    -> KI-Transporter in transportPilotNames registrieren
    -> Gruppe nativ aktivieren
    -> automatischer CTLD-Pickup
    -> Taxi
    -> Takeoff
    -> Transit
    -> Off-Airfield-Anflug
    -> Landung
    -> automatischer CTLD-Dropoff
    -> erzeugte Blue-Bodengruppe

Pickup:

    16 Soldaten

Pickup-Counter:

    10000 -> 9999

Der Pickup erfolgte automatisch durch CTLD.

Nicht verwendet wurden:

- manuelles CTLD-Loading
- direkte Manipulation von `ctld.inTransitTroops`
- Teleport
- Runtime-Routenänderung

Damit ist der CTLD-AI-Pickup für den getesteten Aufbau praktisch bestätigt.

---

## 15. Off-Airfield-Landung

Frühere Tests mit einem ungebundenen Wegpunkt vom Typ:

    Land / Landing

führten nicht zu einem vollständigen erfolgreichen Transportzyklus.

Der erfolgreiche Test verwendete:

    normaler Turning Point
    +
    DCS-native Perform Task Land

Zielposition:

    x = -29249.110954281
    z = -271836.070539260

Wegpunkthöhe:

    100 m BARO

Wegpunktgeschwindigkeit:

    30 m/s

Land-Task:

    duration = 300
    durationFlag = true

Der Mi-8 führte den Flug und den Off-Airfield-Anflug selbständig über die gespeicherte DCS-Route aus.

Bestätigte minimale Entfernung zum vorgesehenen Dropoff-Zentrum:

    ungefähr 1.06 m

Ein Invisible FARP war für diesen getesteten Transportpfad nicht erforderlich.

Damit ist für den getesteten Mi-8-Aufbau:

    Turning Point + Perform Task Land

praktisch bestätigt.

Das ist keine allgemeine Garantie für jeden Luftfahrzeugtyp, jede Route oder jede Geländeart.

Die genaue Ursache des früheren Turnback-Verhaltens ist dadurch nicht abschließend bewiesen.

---

## 16. Automatischer CTLD-Dropoff

Nach der Landung erfolgte der CTLD-Dropoff automatisch.

Bestätigt:

- der `troops`-Inhalt verschwand aus dem In-Transit-State der Testunit,
- `ctld.droppedTroopsBLUE` erhielt genau einen neuen Eintrag,
- eine neue Blue-Bodengruppe wurde erzeugt.

Erzeugte Gruppe:

    Dropped Group 2

Group-ID:

    70001

Einheiten:

    16

Typ:

    Soldier M249

Die Bodengruppe wurde anschließend durch die normale DCS-AI weitergeführt.

Nicht verwendet wurden:

- manuelles CTLD-Unload
- direkte Bordzustandsmanipulation
- Teleport
- Runtime-Routenänderung
- Runtime-Taskänderung

Damit ist der technische Zyklus bestätigt:

    Pickup
    -> Transport
    -> Off-Airfield-Landung
    -> Dropoff
    -> Bodengruppe

---

## 17. Was der erfolgreiche Test beweist

Der Test beweist für den getesteten Aufbau:

- CTLD `1.6.1` kann nach der Initialisierung zusätzliche normalisierte Pickup-Zonen verwenden.
- CTLD kann nach der Initialisierung zusätzliche normalisierte Dropoff-Zonen verwenden.
- eine erneute `ctld.initialize()`-Ausführung war dafür nicht erforderlich.
- der getestete KI-Transporter kann über `ctld.transportPilotNames` in den relevanten CTLD-AI-Pfad eingebunden werden.
- CTLD kann den registrierten KI-Transporter automatisch beladen.
- die DCS-AI kann den gespeicherten Transportflug durchführen.
- `Perform Task -> Land` kann für den getesteten Mi-8 eine geeignete Off-Airfield-Landung ermöglichen.
- CTLD kann nach der Landung automatisch entladen.
- CTLD kann daraus eine reale Bodengruppe erzeugen.
- für diesen Truppentransport war kein FARP erforderlich.

Der Test beweist ausdrücklich noch nicht:

- automatische Theater-Command-Auftragserzeugung
- produktive LogisticsDelivery-CTLD-Kopplung
- produktive FobSystem-CTLD-Kopplung
- Crate-Spawn
- Crate-Loading
- Sling Load
- Crate-Drop
- FOB-Bau aus CTLD-Crates
- Supply-Effekt aus Cargo
- Capture-Effekt aus Cargo
- AI-Director-Integration
- CTLD-Runtime-State Restore
- Multiplayer-Verhalten

---

## 18. `RepackCommandsPath`-Fehler

Beim Grounded-Übergang des registrierten KI-Transporters trat auf:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Stack-Kontext:

    updateRepackMenu
    updateRepackMenuOnlanding

Der Fehler trat im erfolgreichen Test am Bodenübergang auf.

Source-Analyse legt nahe:

- der registrierte KI-Transporter gelangt über `ctld.transportPilotNames` in einen CTLD-Landing-/Menüpfad,
- `ctld.vehicleCommandsPath[_unitName]` ist für reine KI-Units nicht zwangsläufig vorhanden,
- ein daraus abgeleiteter `RepackCommandsPath` kann `nil` sein,
- der Vendor-Code behandelt diesen Zustand an dieser Stelle nicht robust.

Pickup und Dropoff wurden im Test trotzdem erfolgreich abgeschlossen.

Daraus wird nicht abgeleitet, dass der Fehler harmlos ist.

Insbesondere ist vor produktiver Integration zu prüfen, ob der unbehandelte Fehler den betreffenden Scheduler beziehungsweise spätere Repack-Menü-Aktualisierungen beendet.

Diese Schedulerwirkung ist derzeit eine begründete technische Vermutung und kein direkt bewiesener Befund.

Vendor-Regel:

    vendor/ctld/CTLD.lua wird nicht verändert.

Eine Lösung muss außerhalb des Vendor-Codes beziehungsweise durch eine sauber definierte Theater-Command-Integrationsstrategie erfolgen.

---

## 19. Crate-/Cargo-Logistik

Der erfolgreiche Test war:

    KI-Truppentransport

Er war kein:

    Crate-/Cargo-Test

Eine funktionierende Pickup-/Dropoff-Zonenregistrierung bedeutet nicht automatisch, dass CTLD-Crates bereits produktiv funktionieren.

Noch nicht praktisch bestätigt:

- Crate Spawn
- Logistic-Unit-/Crate-Voraussetzungen
- Crate Loading
- Sling Load
- Crate Drop
- Supply Crates
- Engineering Crates
- Repair Crates
- Fuel Crates
- Ammo Crates
- FOB Core
- FOB Build Crates

Diese Funktionen müssen separat und isoliert geprüft werden.

---

## 20. FOB-Bau und CTLD

Die vorhandenen Theater-Command-FOBs:

    FOB Ercan
    FOB Gecitkale

sind weiterhin state-only.

CTLD hat im erfolgreichen Test keinen dieser FOBs gebaut.

Perspektivischer Pfad:

    MissionGenerator
    -> Logistics Auftrag
    -> realer CTLD-Transport
    -> Delivery Validation
    -> LogisticsDelivery
    -> FobSystem
    -> Build Progress
    -> Persistence

Dieser Pfad ist noch nicht implementiert.

Reservierter späterer Ercan-Dropoff:

    CTLD_DROPOFF_BLUE_ERCAN_FOB_01

Technischer Test-Dropoff:

    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01

Der technische Test-Dropoff ist kein produktiver FOB-Dropoff.

---

## 21. Logistik und Capture

CaptureSystem besitzt bereits Pressure- und Progress-State.

LogisticsDelivery besitzt Logistics-State.

FobSystem besitzt FOB-State.

Eine produktive Kopplung ist noch nicht aktiv.

Perspektivisch denkbar:

- Supply Delivery erhöht operative Fähigkeit.
- FOB-Aktivierung erweitert Blue-Reichweite.
- Engineering ermöglicht Ausbau.
- Logistikverlust schwächt Verteidigung.
- Interdiction schwächt gegnerische Versorgung.
- FOB-Unterstützung kann Kampagnenoperationen beeinflussen.

Der aktuell bestätigte Capture-Pfad bleibt davon getrennt:

    Mission Completion
    -> Capture Pressure
    -> Capture Progress
    -> Capture Ready
    -> Apply
    -> Ownership Update
    -> linked Airbase Sync
    -> Persistence

---

## 22. Logistik und AI

AICapManager:

    v0.2.1

Aktueller Stand:

    state-first bestanden
    Read-Neutrality bestanden
    12 CAP Requests
    keine realen CAP-Flüge

Ein umfassender AI Director ist noch nicht implementiert.

Perspektivische Logistik-/AI-Wirkungen:

- Hubs verteidigen
- FOBs angreifen
- Transportaufträge planen
- schwache Hubs priorisieren
- Nachschubwege schützen
- Interdiction durchführen
- Verstärkung transportieren
- CAP für Transportoperationen bereitstellen
- CAS anfordern
- Gegenangriffe unterstützen

Der erfolgreiche CTLD-KI-Transport zeigt, dass ein realer Transportpfad für den getesteten Aufbau grundsätzlich möglich ist.

Die operative Theater-Command-Entscheidungsschicht dafür existiert noch nicht.

---

## 23. Logistik und Persistence

Logistics-/FOB-State ist Teil des Theater-Command-Persistence-Snapshots.

PersistenceSystem:

    v0.2.6

Bestätigte Eigenschaften:

- dirty-aware Background Autosave
- `SAVED`
- `SKIPPED`
- kontrollierter `FAILED`-Pfad
- Retry
- Read-back
- Compile
- Evaluate
- Validation
- `productiveRestore=false`

Priority 3:

    abgeschlossen im dokumentierten Umfang

Produktiver Startup-Restore bleibt deaktiviert.

CTLD-Runtime-State wird nicht als vollständig autoritativer Kampagnenstate persistiert oder restored.

Langfristig soll gelten:

    CTLD Runtime Result
    -> Ergebnis validieren
    -> Theater-Command-State mutieren
    -> Dirty markieren
    -> Persistence

Nicht:

    komplette Vendor-Runtime blind serialisieren

---

## 24. Persistence-Schutz während des CTLD-Tests

Der isolierte CTLD-Test vom 2026-09-29 durfte die produktive Persistence nicht verändern.

Produktive Save-Datei:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Backup:

    C:\Users\Paul\Documents\TC_miz_backups\operation_levant_reclamation_save__pre_landtask_test_2026-09-29_100813.lua

Referenz-SHA-256:

    C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596

Größe:

    3094967 Bytes

Änderungszeit:

    2026-09-21 15:00:00.5926451

Vor Test:

- Backup erstellt.
- Hash verglichen.
- produktive Save-Datei ReadOnly gesetzt.

Nach Test:

- DCS vollständig beendet.
- Save erneut geprüft.
- Größe unverändert.
- Änderungszeit unverändert.
- SHA-256 unverändert.

Danach wurde der Schreibschutz entfernt.

Final:

    ReadOnly=False

SHA-256 blieb unverändert.

Ergebnis:

    Der isolierte CTLD-Test hat den produktiven Kampagnen-Save nicht verändert.

---

## 25. Verbindlicher Persistence-Schutz für Framework-Tests

Vor weiteren isolierten Tests mit möglicher Persistence-Wirkung:

    aktuellen Hash prüfen
    -> Backup erzeugen
    -> Backup-Hash prüfen
    -> produktive Save-Datei temporär ReadOnly setzen
    -> ReadOnly bestätigen
    -> Test durchführen
    -> DCS vollständig beenden
    -> Hash erneut prüfen
    -> mit Referenz vergleichen
    -> nur bei Match ReadOnly entfernen
    -> final erneut prüfen

Der ReadOnly-Schutz wird nicht entfernt, solange DCS beziehungsweise die Testmission noch läuft.

---

## 26. F10-Status

F10Menu:

    v0.2.3

Bestätigt:

    33 Commands

Im Logistikbereich vorhanden:

    Show Logistics Status
    Show FOB Status

F10 dient aktuell primär:

- Sichtbarkeit
- Debug
- Status
- kontrollierten Testaktionen

Die spätere Hintergrundlogistik soll nicht davon abhängen, dass der Spieler Prozesse manuell über F10 auslöst.

Perspektivische Funktionen können sein:

- detaillierte Logistics-Hub-Anzeige
- FOB Construction Status
- FOB Supply Status
- Cargo Requests
- Delivery Queue
- optionale Spieler-Transportaufträge

Diese Funktionen sind nicht als bereits implementiert zu verstehen.

---

## 27. Entwicklungswerkzeuge für die Logistikintegration

Der Entwicklungsworkflow trennt Projektlogik, Missionsdatei und Runtime-Diagnose.

### ChatGPT

Rolle:

- Projektkoordination
- Architektur
- Testplanung
- Ergebnisbewertung
- GitHub-Audit
- Dokumentationsführung
- Definition des nächsten Einzelschritts

### Claude + dcs-mcp

Version:

    dcs-mcp 0.9.11

Rolle:

- strukturierte `.miz`-Analyse
- Mission-Editor-Inhalte untersuchen
- Gruppen, Units und Zonen prüfen
- Wegpunkte und Tasks prüfen
- gespeicherte `.miz` gezielt bearbeiten
- Mission vor Runtime-Tests auditieren

Terrain Store:

    C:\Users\Paul\AppData\Local\dcs-mcp\terrain

Syria-Terrain-Daten:

    installiert

dcs-mcp arbeitet auf der Missionsstruktur.

Es ersetzt keinen realen Runtime-Test.

### Claude Code + DCS-SMS

DCS-SMS:

    0.27.2

Hook:

    me-bridge-0.27.2

Verifiziertes Installationsverzeichnis:

    C:\Tools\dcs-sms

Claude-Code-Skill:

    C:\Users\Paul\.claude\skills\dcs-sms\SKILL.md

Rolle:

- Mission-Editor-Status prüfen
- laufende DCS-Runtime prüfen
- Runtime-Lua ausführen
- CTLD-Live-State untersuchen
- Unit-State beobachten
- Logs auswerten
- kontrollierte Runtime-Regressionen durchführen

DCS-SMS ist ausschließlich Entwicklungs-/Diagnosewerkzeug.

Es ist keine Theater-Command-Runtime-Abhängigkeit.

### GitHub

GitHub ist Source of Truth für:

- eigene Lua-Dateien
- Dokumentation
- Architektur
- Tasks
- Roadmap
- Naming
- Vendor-Versionen
- bestätigten Entwicklungsstand

### DCS

DCS selbst bleibt die autoritative Instanz für tatsächliches Simulatorverhalten.

---

## 28. Testmissionen und Trennung vom produktiven State

DEV-Mission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_DEV.miz

Erfolgreiche isolierte CTLD-Testmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz

SHA-256 vor dem Test:

    5F0D89DF744A7083401E36713B148BD21813FF187CC36EC1F088507163458C57

Der CTLD-Test wurde nicht als produktive Kampagnenmission behandelt.

Grundprinzip:

    Testmission != DEV-Mission

und:

    isolierte Framework-Experimente dürfen produktiven State nicht unbeabsichtigt verändern.

---

## 29. Aktueller Systemstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | state-first funktional bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | funktional bestanden; Read-Neutrality und Ownership-No-Op bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | Background Persistence bestanden; `productiveRestore=false` |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.1` | state-first und Read-Neutrality bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.1` | state-first und Read-Neutrality bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | 10 Mission Records; Activation/Completion/Failure/Effects bestanden |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.1` | state-first und Read-Neutrality bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden; 33 Commands |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` | KI-Truppentransport-PoC bestanden; keine produktive TC-Integration |

---

## 30. CTLD-Akzeptanzstand

Praktisch bestanden:

- CTLD lädt und initialisiert.
- CTLD bleibt unverändert unter `vendor/`.
- nachträgliche normalisierte Pickup-Zonenregistrierung funktioniert.
- nachträgliche normalisierte Dropoff-Zonenregistrierung funktioniert.
- eine erneute `ctld.initialize()`-Ausführung war nicht erforderlich.
- der getestete KI-Transporter kann in `ctld.transportPilotNames` registriert werden.
- CTLD verarbeitet den registrierten aktiven Transporter im getesteten AI-Pfad.
- automatischer Truppen-Pickup funktioniert.
- 16 Soldaten werden transportiert.
- Off-Airfield-Landung über `Perform Task -> Land` funktioniert für den getesteten Mi-8.
- CTLD erkennt die Landung im vorgesehenen Dropoff-Bereich.
- automatischer Dropoff funktioniert.
- eine 16-Mann-Bodengruppe wird erzeugt.
- produktiver Kampagnen-Save bleibt bei isoliertem Test unverändert.

Bekannter Integrationspunkt:

    RepackCommandsPath bei Grounded-Transition

Noch offen:

- produktive Theater-Command-CTLD-Integration
- automatische Zonenregistrierung durch TC-Code
- automatische Transporterregistrierung durch TC-Code
- Transporter-Lifecycle
- Umgang mit dem Repack-Menü-Fehler
- Crate-/Cargo-Pfad
- FOB-Bau
- Supply-Wirkung
- Capture-Kopplung
- AI-Director-Kopplung
- CTLD-Persistence-/Restore-Grenze
- Multiplayer

---

## 31. Architekturgrenze

Die wichtigste Grenze nach dem Proof-of-Concept lautet:

    Framework-Fähigkeit bestätigt
    !=
    Theater-Command-Feature produktiv implementiert

CTLD kann den getesteten Transport ausführen.

Theater Command erzeugt und orchestriert diesen Transport noch nicht selbständig.

Die produktive Architektur muss mindestens unterscheiden zwischen:

    Kampagnenentscheidung
    -> Mission-/Transportauftrag
    -> Transporter auswählen
    -> CTLD-Konfiguration
    -> DCS-Route / Task
    -> Pickup
    -> Transport
    -> Landung
    -> Dropoff
    -> Ergebnis validieren
    -> Theater-Command-State aktualisieren
    -> Dirty markieren
    -> Persistence

CTLD bleibt:

    Execution Layer

Theater Command bleibt:

    Campaign Logic / Decision Layer

---

## 32. Risiken

Aktuell relevante Risiken:

- CTLD-Zonen müssen exakt und idempotent registriert werden.
- Transporter müssen korrekt in `ctld.transportPilotNames` registriert werden.
- Unit-Namen müssen stabil sein.
- AI-Landing-Verhalten kann von Luftfahrzeugtyp, Route und Gelände abhängen.
- der `RepackCommandsPath`-Fehler darf nicht ungeprüft produktiv übernommen werden.
- Crate-Logik besitzt zusätzliche Voraussetzungen gegenüber dem getesteten Truppentransport.
- CTLD-Runtime-State und Theater-Command-State dürfen nicht auseinanderlaufen.
- reale DCS-Nebenwirkungen müssen mit Persistence konsistent bleiben.
- Multiplayer muss separat geprüft werden.
- Restore darf Framework-Nebenwirkungen nicht doppelt auslösen.

Gegenmaßnahmen:

- kleine isolierte Tests
- keine Vendor-Modifikation
- idempotente Registrierung
- klare Namenskonventionen
- State-first
- Runtime-Validierung
- Persistence-Backup und Hash-Schutz
- eine konkrete Aufgabe pro Schritt

---

## 33. Nächster produktiver Logistikschritt

Der manuelle CTLD-KI-Truppentransport-Proof-of-Concept ist abgeschlossen.

Ein weiterer identischer manueller Test ist derzeit nicht der nächste sinnvolle Schritt.

Vor produktiver Implementierung muss die Integrationsgrenze entworfen werden.

Zu definieren sind insbesondere:

- welche fachliche eigene `src/`-Komponente die CTLD-Runtime-Konfiguration übernimmt,
- ob dafür eine bestehende fachliche Datei erweitert wird oder eine neue aufgabenorientierte Datei erforderlich ist,
- wie Pickup-/Dropoff-Zonen idempotent registriert werden,
- wie KI-Transporter idempotent registriert werden,
- wie Transporter-Lifecycle behandelt wird,
- wie der `RepackCommandsPath`-Fall ohne Vendor-Patch behandelt wird,
- wie ein Transportauftrag aus Theater-Command-State entsteht,
- wie Erfolg und Fehler erkannt werden,
- wie der erfolgreiche Dropoff in LogisticsDelivery und FobSystem zurückgeführt wird,
- welche CTLD-Daten runtime-only bleiben,
- welche Resultate persistiert werden.

Es wird nicht vorschnell eine generische Framework-Datei wie:

    tc_ctld.lua

oder:

    tc_ctld_bridge.lua

festgelegt.

Die eigene Logik bleibt nach fachlicher Aufgabe organisiert.

---

## 34. Aktueller Abschlussstand

Das Logistiksystem besitzt aktuell zwei klar getrennte Ebenen.

### Theater-Command-State

Bestanden:

- LogisticsDelivery `v0.2.1`
- FobSystem `v0.2.1`
- Logistics Read-Neutrality
- FOB Read-Neutrality
- 46 Logistics Hubs
- 7 Blue Hubs
- 24 Red Hubs
- 15 Neutral Hubs
- 31 Active Hubs
- 15 Limited Hubs
- 6 FOB-Kandidaten
- 2 Blue-FOBs
- FOB Ercan
- FOB Gecitkale
- FOB-Support im MissionGenerator
- F10 Logistics-/FOB-Status
- Persistence Snapshot

### CTLD-Framework-Proof-of-Concept

Bestanden:

- Runtime-Zonenregistrierung
- KI-Transporterregistrierung
- automatischer Pickup
- 16 transportierte Soldaten
- autonomer Flug
- Off-Airfield-Landung
- automatischer Dropoff
- erzeugte 16-Mann-Bodengruppe

Noch nicht produktiv verbunden:

    Theater Command State
    <->
    CTLD Runtime

Genau diese kontrollierte Verbindung ist die nächste Integrationsphase.

Verbindlich:

    productiveRestore=false
    vendor/ bleibt unverändert

Der erfolgreiche CTLD-Test vom 2026-09-29 ist technische Grundlage für die nächste Integrationsphase.

Er ist kein Beleg dafür, dass noch nicht implementierte Cargo-, FOB-, AI- oder Persistence-Funktionen bereits produktiv vorhanden sind.
