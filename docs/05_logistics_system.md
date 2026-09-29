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

- LogisticsDelivery `v0.2.0` ist state-first funktional bestanden.
- FobSystem `v0.2.0` ist state-first funktional bestanden.
- Logistics-/FOB-State ist Bestandteil der Persistence-Snapshots.
- PersistenceSystem `v0.2.6` arbeitet dirty-aware im Hintergrund.
- `productiveRestore=false` bleibt bewusst gesetzt.
- MissionGenerator `v0.2.3` nutzt Logistics-/FOB-State bereits für Missionskandidaten.
- CTLD `1.6.1` ist als unverändertes Vendor-Framework geladen.
- Die technische CTLD-Zonenregistrierung wurde praktisch bestätigt.
- Ein vollständiger automatischer CTLD-KI-Truppentransport wurde am 2026-09-29 praktisch bestätigt.
- Die produktive Theater-Command-CTLD-Bridge existiert noch nicht.
- Crate-/Cargo-Logistik ist noch nicht praktisch bestätigt.
- Der CTLD-Fehler `RepackCommandsPath` bei KI-Transportern ist reproduziert und vor produktiver Integration zu berücksichtigen.

Der erfolgreiche CTLD-Test ist ein **Proof-of-Concept der Framework-Integration**.

Er bedeutet nicht, dass Theater Command bereits produktiv CTLD-Transporte erzeugt oder steuert.

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

    LogisticsDelivery: v0.2.0
    FobSystem: v0.2.0

Vendor-Framework:

    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua

CTLD-Version:

    1.6.1

Vendor-Regel:

    vendor/ wird nicht für Theater Command verändert.

Es wird insbesondere keine eigene Logik in Dateien wie:

    tc_ctld.lua
    tc_ctld_all_in_one.lua

gebündelt.

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

- LogisticsDelivery lädt.
- LogisticsDelivery startet.
- LogisticsDelivery erzeugt Logistics Hubs.
- FobSystem lädt.
- FobSystem startet.
- FobSystem erzeugt FOB-Kandidaten.
- zwei Blue-FOBs werden state-only erzeugt.
- MissionGenerator erkennt FOB-Support-Kandidaten.
- F10Menu kann Logistics-/FOB-State anzeigen.
- Logistics-/FOB-State ist persistence-fähig.

---

## 4. Beziehung zu Airbase Scanner und ZoneFactory

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

## 5. Logistics Hubs

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

## 6. Blue Logistics

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

## 7. Red und Neutral Logistics

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

## 8. FOB-System

Aktive Datei:

    src/logistics/tc_fob_system.lua

Version:

    v0.2.0

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

## 9. FOB-Support und MissionGenerator

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

FOB-Support kann damit bereits als Kampagnenauftrag im State existieren.

Eine Mission löst aber noch nicht automatisch einen realen CTLD-Transport aus.

---

## 10. CTLD-Rolle

CTLD ist das Vendor-Framework für reale Transport- und Logistikinteraktion.

Aktuelle Vendor-Dateien:

    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua

CTLD:

    Version 1.6.1
    geladen
    initialisiert
    vom Theater-Command-Loader erkannt
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

    CTLD ist technisch getestet,
    aber noch nicht produktiv durch Theater Command orchestriert.

---

## 11. CTLD-Zonenregistrierung

Die technische Annahme zur nachträglichen CTLD-Zonenregistrierung ist inzwischen praktisch bestätigt.

CTLD 1.6.1 initialisiert sich beim Laden selbst.

Nach der Initialisierung können bereits normalisierte Theater-Command-Zonen in die Live-Tabellen ergänzt werden:

    ctld.pickupZones
    ctld.dropOffZones

Eine erneute Ausführung von:

    ctld.initialize()

ist dafür nicht erforderlich und nicht Teil der Integrationsstrategie.

Im erfolgreichen Test wurden temporär registriert:

Pickup:

    CTLD_PICKUP_BLUE_AKROTIRI_01

Dropoff:

    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01

Die Einträge wurden aus dem CTLD-Live-State zurückgelesen und anschließend tatsächlich vom Framework verwendet.

Damit ist die grundsätzliche Runtime-Zonenregistrierung praktisch bestätigt.

Die Details und verbindlichen Namen stehen in:

    mission_editor/ctld_start_zones.md

---

## 12. KI-Transporter und `transportPilotNames`

Der Test vom 2026-09-29 hat eine zusätzliche CTLD-Voraussetzung bestätigt.

Ein KI-Transporter muss für den von CTLD verwendeten AI-Pfad in:

    ctld.transportPilotNames

registriert sein.

Getestete Unit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Vor Registrierung:

    108 Einträge
    getestete Mi-8 nicht enthalten

Nach temporärer Registrierung:

    109 Einträge
    Mi-8 genau einmal enthalten

Die Registrierung erfolgte über den exakten Unit-Namen.

Danach konnte `ctld.checkAIStatus()` die Unit nach ihrer Aktivierung verarbeiten.

Konsequenz:

Eine spätere produktive Theater-Command-Integration muss vorgesehene KI-Transporter automatisch und idempotent bei CTLD registrieren.

Dabei gilt:

- keine Duplikate
- exakte Unit-Namen
- keine Vendor-Modifikation
- keine direkte Manipulation des Bordzustands
- Lifecycle von Spawn/Aktivierung/Despawn berücksichtigen

---

## 13. Bestätigter CTLD-KI-Truppentransport

Am 2026-09-29 wurde erstmals der vollständige technische CTLD-KI-Transportzyklus praktisch bestätigt.

Testgruppe:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01

Testunit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Typ:

    Mi-8MT

Start:

    Akrotiri
    Parking H4
    TakeOffParkingHot
    Late Activation

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

Es erfolgte:

- kein manuelles Laden
- keine direkte Manipulation von `ctld.inTransitTroops`
- kein Teleport
- kein DCS-native Embarking
- keine Runtime-Routenänderung

Damit ist der CTLD-KI-Pickup praktisch bestätigt.

---

## 14. Off-Airfield-Landung

Frühere Tests mit einem ungebundenen Wegpunkt vom Typ:

    Land / Landing

führten nicht zum gewünschten vollständigen Transportzyklus.

Der erfolgreiche Test verwendete stattdessen:

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

Die Mi-8 flog die Route selbständig und landete off-airfield.

Bestätigte Entfernung zum vorgesehenen Dropoff-Zentrum beim Touchdown:

    ungefähr 1.06 m

Es war dafür kein Invisible FARP erforderlich.

Damit gilt für den getesteten Mi-8-Pfad:

    Turning Point + Perform Task Land

als praktisch bestätigtes Off-Airfield-Landeverfahren.

Das ist ein technischer Proof-of-Concept und noch keine allgemeine Garantie für jeden DCS-Luftfahrzeugtyp oder jede Geländeart.

---

## 15. Automatischer CTLD-Dropoff

Nach der Landung erfolgte der CTLD-Dropoff automatisch.

Bestätigt:

- die 16 Soldaten wurden aus dem CTLD-Bordzustand entfernt,
- der `troops`-Eintrag im In-Transit-State verschwand,
- `ctld.droppedTroopsBLUE` erhielt einen neuen Eintrag,
- eine neue Blue-Bodengruppe wurde erzeugt.

Erzeugte Gruppe:

    Dropped Group 2

Group-ID:

    70001

Einheiten:

    16

Typ:

    Soldier M249

Nicht verwendet wurden:

- manuelles Unload
- direkte Bordzustandsmanipulation
- DCS-native Disembarking
- Teleport
- Runtime-Routenänderung
- Runtime-Taskänderung

Damit ist der vollständige technische Zyklus bestätigt:

    Pickup
    -> Transport
    -> Off-Airfield-Landung
    -> Dropoff
    -> Bodengruppe

---

## 16. Was der erfolgreiche Test beweist

Der Test beweist für den getesteten Aufbau:

- CTLD 1.6.1 kann nach der Initialisierung zusätzliche normalisierte Pickup-Zonen verwenden.
- CTLD kann nach der Initialisierung zusätzliche normalisierte Dropoff-Zonen verwenden.
- `ctld.initialize()` muss dafür nicht erneut aufgerufen werden.
- KI-Transporter können über `ctld.transportPilotNames` in den CTLD-AI-Pfad eingebunden werden.
- CTLD kann einen solchen KI-Transporter automatisch beladen.
- die DCS-KI kann den Transport selbständig durchführen.
- ein Perform Task `Land` kann eine geeignete Off-Airfield-Landung ermöglichen.
- CTLD kann nach der Landung automatisch entladen.
- CTLD kann daraus eine reale Bodengruppe erzeugen.

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

## 17. `RepackCommandsPath`-Fehler

Beim Grounded-Übergang der KI-Mi-8 wurde erneut der CTLD-Fehler reproduziert:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Stack-Kontext:

    updateRepackMenu
    updateRepackMenuOnlanding

Die Quelltext- und Runtime-Analyse deutet darauf hin:

- `updateRepackMenuOnlanding()` verarbeitet Namen aus `ctld.transportPilotNames`,
- ein reiner KI-Transporter besitzt nicht zwangsläufig einen Player-/F10-Command-Pfad,
- `ctld.vehicleCommandsPath[_unitName]` kann deshalb `nil` sein,
- der Repack-Menüpfad behandelt diesen Zustand nicht robust.

Im erfolgreichen Test wurden Pickup und Dropoff trotzdem abgeschlossen.

Daraus wird **nicht** abgeleitet, dass der Fehler langfristig harmlos ist.

Insbesondere muss vor produktiver Integration geprüft werden, ob der unbehandelte Fehler einen Scheduler beziehungsweise spätere Repack-Menü-Aktualisierungen beendet.

Vendor-Regel:

    vendor/ctld/CTLD.lua wird dafür nicht verändert.

Eine Lösung muss außerhalb des Vendor-Codes beziehungsweise durch eine sauber definierte Integrationsstrategie erfolgen.

---

## 18. Crate-/Cargo-Logistik

Der erfolgreiche Test war ein:

    KI-Truppentransport

Er war kein:

    Crate-/Cargo-Test

Eine funktionierende Pickup-Zone bedeutet nicht automatisch, dass CTLD-Crates gespawnt und transportiert werden können.

Noch nicht bestätigt:

- Crate-Spawn
- Logistics-/Logistic-Unit-Voraussetzungen
- Crate-Loading
- Sling Load
- Crate-Unloading
- Engineering-Crates
- Repair-Crates
- Supply-Crates
- Fuel-Crates
- Ammo-Crates
- FOB-Core-Crates

Diese Funktionen müssen später separat und isoliert geprüft werden.

---

## 19. FOB-Bau und CTLD

Die vorhandenen Theater-Command-FOBs:

    FOB Ercan
    FOB Gecitkale

sind weiterhin state-only.

CTLD hat im erfolgreichen Test keinen dieser FOBs gebaut.

Perspektivischer Pfad:

    MissionGenerator
    -> Logistics Auftrag
    -> realer CTLD-Transport
    -> Cargo Delivery
    -> Theater-Command-Validierung
    -> LogisticsDelivery
    -> FobSystem
    -> Build Progress
    -> Persistence

Dieser Pfad ist noch nicht implementiert.

Der reservierte spätere Ercan-Dropoff-Name lautet:

    CTLD_DROPOFF_BLUE_ERCAN_FOB_01

Der technische Test-Dropoff:

    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01

ist kein produktiver FOB-Dropoff.

---

## 20. Logistik und Capture

CaptureSystem besitzt bereits Pressure- und Progress-State.

LogisticsDelivery besitzt Logistics-State.

FobSystem besitzt FOB-State.

Eine produktive Kopplung ist noch nicht aktiv.

Perspektivisch möglich:

- Supply Delivery erhöht operative Fähigkeit.
- FOB-Aktivierung beeinflusst Blue-Reichweite.
- Engineering ermöglicht Ausbau.
- Logistikverlust schwächt Verteidigung.
- Interdiction schwächt gegnerische Versorgung.
- FOBs können Capture Pressure unterstützen.

Der bereits bestätigte Capture-Pfad bleibt davon unabhängig:

    Mission Completion
    -> Capture Pressure
    -> Capture Progress
    -> Capture Ready
    -> Apply
    -> Ownership Update
    -> linked Airbase Sync
    -> Persistence

---

## 21. Logistik und AI

AICapManager:

    v0.2.0

Aktueller Stand:

    state-first bestanden
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

Der erfolgreiche CTLD-KI-Transport zeigt, dass ein technischer Transportpfad grundsätzlich möglich ist.

Die operative Entscheidungsschicht dafür existiert noch nicht.

---

## 22. Logistik und Persistence

Logistics-/FOB-State ist bereits Teil des Persistence-Snapshots.

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

Produktiver Startup-Restore bleibt deaktiviert.

CTLD-Runtime-State wird noch nicht produktiv persistiert oder restored.

Der isolierte CTLD-Test vom 2026-09-29 durfte die produktive Persistence nicht verändern.

Produktive Save-Datei:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Vor und nach dem Test bestätigter SHA-256:

    C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596

Größe:

    3094967 Bytes

Damit ist bestätigt:

    Der isolierte CTLD-Test hat den produktiven Kampagnen-Save nicht verändert.

Vor weiteren isolierten Tests mit möglicher Persistence-Wirkung bleibt die Sicherungsstrategie verpflichtend:

    Hash prüfen
    -> Backup
    -> produktive Save-Datei temporär ReadOnly
    -> Test
    -> DCS vollständig beenden
    -> Hash erneut prüfen
    -> erst danach ReadOnly entfernen

---

## 23. F10-Status

F10Menu:

    v0.2.3

Bestätigt:

    33 Commands

Im Logistikbereich vorhanden:

    Show Logistics Status
    Show FOB Status

Capture-/Pressure-Sichtbarkeit ist ebenfalls bereits umgesetzt.

Perspektivische Erweiterungen:

- Show Logistics Hubs
- Show FOB Construction
- Show FOB Supply
- Show Cargo Requests
- Show Delivery Queue
- Request Cargo Mission
- Request FOB Support

Die eigentliche Hintergrundlogistik soll langfristig jedoch nicht davon abhängen, dass der Spieler über F10 Prozesse manuell auslöst.

F10 dient primär:

- Sichtbarkeit
- Debug
- Status
- kontrollierten Testaktionen

Autonome Kampagnenlogik soll im Hintergrund arbeiten.

---

## 24. Entwicklungswerkzeuge für die Logistikintegration

Der aktuelle Entwicklungsworkflow unterscheidet strikt zwischen Projektlogik, `.miz`-Bearbeitung und Live-Runtime-Diagnose.

### ChatGPT

Rolle:

- Projektkoordination
- Architektur
- Testplanung
- Ergebnisbewertung
- GitHub-Audit
- Dokumentationsführung
- Definition des jeweils nächsten Einzelschritts

ChatGPT ersetzt nicht die lokale DCS-Runtime.

### Claude + dcs-mcp

Aktuell verwendete dcs-mcp-Version:

    0.9.11

Rolle:

- strukturierte `.miz`-Analyse
- Mission-Editor-Inhalte untersuchen
- Gruppen/Units/Zonen prüfen
- Wegpunkte und Tasks prüfen
- gespeicherte `.miz` gezielt bearbeiten
- Mission vor dem Runtime-Test auditieren

Installierte Terrain-Daten umfassen unter anderem:

    Syria

dcs-mcp arbeitet auf der Missionsdatei beziehungsweise deren strukturierter Darstellung.

Es ist kein Live-DCS-Runtime-Framework.

### Claude Code + DCS-SMS

DCS-SMS:

    0.27.2

Hook:

    me-bridge-0.27.2

Lokale Installation:

    C:\Tools\dcs-sms\dcs-sms.exe

Rolle:

- Mission-Editor-Status prüfen
- laufende DCS-Runtime prüfen
- Runtime-Lua ausführen
- CTLD-Live-State untersuchen
- Unit-State beobachten
- Logdaten auswerten
- kontrollierte Runtime-Tests durchführen

DCS-SMS ist ausschließlich Entwicklungs-/Diagnosewerkzeug.

Es ist keine Theater-Command-Runtime-Abhängigkeit.

### GitHub

GitHub ist das Projektgedächtnis und die Source of Truth für:

- eigene Lua-Dateien
- Dokumentation
- Architektur
- Tasks
- Roadmap
- Naming
- Vendor-Versionen
- Entwicklungsstand

### DCS

DCS selbst bleibt die maßgebliche Runtime-Instanz.

Nur ein realer DCS-Test kann bestätigen, ob eine DCS-/Framework-Funktion tatsächlich im Simulator funktioniert.

---

## 25. Testmissionen und Trennung vom produktiven State

DEV-Mission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_DEV.miz

Für riskantere CTLD-Tests wurden separate Testmissionen verwendet.

Erfolgreicher Teststand vom 2026-09-29:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz

SHA-256 vor dem Test:

    5F0D89DF744A7083401E36713B148BD21813FF187CC36EC1F088507163458C57

Der Test wurde nicht als produktive Kampagnenmission behandelt.

Grundprinzip:

    DEV und produktiver Save dürfen durch isolierte Framework-Experimente nicht unbeabsichtigt verändert werden.

---

## 26. Aktueller Systemstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | state-first funktional bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | funktional bestanden; Read-Dirty-/Ownership-No-Op-Regressionen bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | Background Persistence bestanden; `productiveRestore=false` |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | state-first funktional bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | state-first funktional bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | 10 Mission Records; Activation/Completion/Failure/Effects bestanden |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | state-first bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden; 33 Commands |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` | Vendor geladen; KI-Truppentransport-PoC bestanden; keine produktive TC-Bridge |

---

## 27. CTLD-Akzeptanzstand

Praktisch bestanden:

- CTLD lädt.
- CTLD initialisiert.
- CTLD bleibt unverändert unter `vendor/`.
- nachträgliche normalisierte Pickup-Zonenregistrierung funktioniert.
- nachträgliche normalisierte Dropoff-Zonenregistrierung funktioniert.
- keine erneute CTLD-Initialisierung erforderlich.
- KI-Transporter kann in `ctld.transportPilotNames` registriert werden.
- CTLD erkennt den registrierten aktiven KI-Transporter.
- automatischer Truppen-Pickup funktioniert.
- 16 Soldaten werden transportiert.
- Off-Airfield-Landung über DCS-native Perform Task `Land` funktioniert.
- CTLD erkennt den gelandeten Transporter in der Dropoff-Zone.
- automatischer Dropoff funktioniert.
- 16-Mann-Bodengruppe wird erzeugt.
- produktiver Kampagnen-Save bleibt bei isoliertem Test unverändert.

Bekannter Fehler:

    RepackCommandsPath bei KI-Grounded-Transition

Noch offen:

- produktive Theater-Command-CTLD-Bridge
- automatische Zonenregistrierung durch TC-Code
- automatische Transporterregistrierung durch TC-Code
- Lifecycle der Transporter
- Behandlung des Repack-Menü-Problems
- Crate-/Cargo-Pfad
- FOB-Bau
- Supply-Wirkung
- Capture-Kopplung
- AI-Director-Kopplung
- CTLD-Persistence/Restore
- Multiplayer

---

## 28. Architekturgrenze

Die wichtigste Grenze nach dem Proof-of-Concept lautet:

    Framework-Fähigkeit bestätigt
    !=
    Theater-Command-Feature produktiv implementiert

CTLD kann den getesteten Transport durchführen.

Theater Command erzeugt und orchestriert diesen Transport noch nicht selbständig.

Die produktive Architektur muss später mindestens unterscheiden zwischen:

1. Kampagnenentscheidung
2. Mission-/Transportauftrag
3. Auswahl eines realen Transporters
4. CTLD-Konfiguration
5. DCS-Routing
6. Pickup
7. Transport
8. Landung
9. Dropoff
10. Validierung des Ergebnisses
11. Rückführung in Theater-Command-State
12. Dirty-Markierung
13. Persistence

CTLD bleibt dabei Ausführungsframework.

Theater Command bleibt die Kampagnen- und Entscheidungsschicht.

---

## 29. Risiken

Aktuell relevante Risiken:

- CTLD-Zonen müssen exakt und idempotent registriert werden.
- Transporter müssen korrekt in `ctld.transportPilotNames` registriert werden.
- Unit-Namen müssen stabil sein.
- AI-Landing-Verhalten kann von Luftfahrzeugtyp und Gelände abhängen.
- der `RepackCommandsPath`-Fehler darf nicht ungeprüft produktiv übernommen werden.
- Crate-Logik hat zusätzliche Voraussetzungen gegenüber Truppentransport.
- CTLD-Runtime-State und Theater-Command-State dürfen nicht auseinanderlaufen.
- echte DCS-Nebenwirkungen müssen mit Persistence konsistent bleiben.
- Multiplayer muss separat geprüft werden.
- Restore darf keine Framework-Nebenwirkungen doppelt auslösen.

Gegenmaßnahmen:

- kleine isolierte Tests
- keine Vendor-Modifikation
- idempotente Registrierung
- klare Namenskonventionen
- State-first
- Runtime-Validierung
- Hash-/Backup-Schutz bei Persistence-Tests
- ein System beziehungsweise eine konkrete Aufgabe pro Schritt

---

## 30. Nächster produktiver Logistikschritt

Der manuelle Proof-of-Concept des CTLD-KI-Truppentransports ist abgeschlossen.

Ein weiterer identischer manueller Test ist derzeit nicht der nächste sinnvolle Schritt.

Vor produktiver Implementierung muss die Integrationsgrenze entworfen werden.

Zu definieren sind insbesondere:

- wo die CTLD-Zonenregistrierung in eigener `src/`-Logik erfolgt,
- wie KI-Transporter idempotent registriert werden,
- wie Transporter-Lifecycle behandelt wird,
- wie der `RepackCommandsPath`-Fehler TC-seitig abgefangen beziehungsweise vermieden wird,
- wie ein Transportauftrag aus dem Kampagnen-State entsteht,
- wie der erfolgreiche Dropoff zurück in LogisticsDelivery/FobSystem gelangt,
- welche CTLD-Daten runtime-only bleiben,
- welche Resultate persistiert werden.

Dabei wird keine generische Framework-Datei wie:

    tc_ctld.lua

eingeführt.

Die eigene Logik bleibt nach fachlicher Aufgabe organisiert.

---

## 31. Aktueller Abschlussstand

Das Logistiksystem besitzt inzwischen zwei klar getrennte Ebenen.

### Theater-Command-State

Bestanden:

- 46 Logistics Hubs
- 7 Blue
- 24 Red
- 15 Neutral
- 31 Active
- 15 Limited
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
- 16 Soldaten onboard
- autonomer Flug
- Off-Airfield-Landung
- automatischer Dropoff
- erzeugte 16-Mann-Bodengruppe

Noch nicht produktiv verbunden:

    Theater Command State
    <->
    CTLD Runtime

Genau diese kontrollierte Verbindung ist die nächste Integrationsphase.

`productiveRestore=false` bleibt unverändert.

Vendor-Dateien bleiben unverändert.

Der erfolgreiche CTLD-Test vom 2026-09-29 wird als technische Grundlage verwendet, nicht als Begründung dafür, bereits nicht implementierte Kampagnenfunktionen als fertig zu betrachten.
