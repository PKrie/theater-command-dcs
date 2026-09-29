# ROADMAP – Theater Command DCS

Diese Roadmap beschreibt den geplanten Entwicklungsweg von **Theater Command DCS**.

Das Projekt ist modular aufgebaut. Jede Entwicklungsstufe soll einzeln nachvollziehbar und testbar sein, bevor die nächste Stufe produktiv angebunden wird.

Projekt:

- Theater Command DCS

Erste Kampagne:

- Operation Levant Reclamation

Map:

- Syria

Grundprinzip:

- Mission Editor = Bühne
- Lua = Kampagnensystem
- GitHub = Projektgedächtnis / Source of Truth
- DCS Runtime = autoritativer Verhaltensbeweis

Aktueller verbindlicher Stand:

- 2026-09-29

---

# 1. Verbindlicher Projektstand – 2026-09-29

Der state-first Kampagnenkern ist für den aktuellen Entwicklungsstand funktionsfähig.

Bestätigt sind:

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
- isolierter CTLD-KI-Truppentransport-PoC für den getesteten Aufbau

Priority 3 wurde am:

- 2026-09-21

im dokumentierten Umfang abgeschlossen.

Dabei wurden aktive Read-Neutrality-Probleme in:

- LogisticsDelivery
- FobSystem
- AICapManager

behoben und regressionsgetestet.

MissionGenerator benötigte im Priority-3-Audit keinen aktiven Code-Fix.

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

Der aktuelle Entwicklungsbereich ist:

- Priority 4 – produktive CTLD-Integration vorbereiten

Am 2026-09-29 wurde für den getesteten Aufbau folgender vollständiger CTLD-KI-Truppentransportzyklus praktisch bestätigt:

- automatischer Pickup
- Taxi
- Takeoff
- Transit
- Off-Airfield-Landung
- automatischer Dropoff
- reale Blue-Bodengruppe

Der isolierte Proof-of-Concept ist damit bestanden.

Eine produktive Theater-Command-CTLD-Integration existiert noch nicht.

---

# 2. Zielbild

Theater Command DCS soll ein dynamisches und später persistentes Kampagnensystem für DCS World werden.

Ausgangslage:

- Blue startet auf Akrotiri / Zypern.
- Das syrische Festland ist zu Beginn rot kontrolliert.
- Red hält zu Beginn den Großteil der strategischen Flugplätze.
- Blue soll sich vom Brückenkopf Zypern aus auf das syrische Festland vorarbeiten.

Der Spieler soll nicht der einzige Motor der Kampagne sein.

Langfristig sollen Blue und Red möglichst eigenständig:

- Missionen erzeugen
- CAP bereitstellen
- Strike durchführen
- SEAD / DEAD durchführen
- Bodentruppen bewegen
- CAS anfordern
- Logistik durchführen
- Transporte durchführen
- FOBs aufbauen
- Nachschub transportieren
- IADS betreiben
- auf Verluste reagieren
- Gebiete erobern und verlieren

Der Spieler soll sich in diese laufende Kampagnenlage einklinken können.

---

# 3. Langfristige Systemziele

Theater Command DCS soll perspektivisch enthalten:

- dynamische Blue-vs-Red-Kampagne
- Airbases und relevante Zonen als Kampagnenobjekte
- persistente Ownership
- MissionGenerator
- AI Director
- Logistics Layer
- CTLD-Transport und Cargo
- FOB-System
- MOOSE AI-Spawns
- CAP
- Strike
- SEAD
- DEAD
- CAS
- Ground Operations
- Convoys
- Bodentruppen-CAS-Anforderungen
- Skynet IADS
- Supercarrier
- Carrier Task Group
- Carrier Air Wing
- F/A-18C
- F-14
- weitere Carrier-fähige Assets
- langfristige Persistence
- produktiver Restore
- Multiplayer-Fähigkeit

Diese Punkte sind Zielarchitektur und nicht als bereits implementiert zu verstehen.

---

# 4. Entwicklungsprinzip

Die technische Reihenfolge bleibt:

1. State aufbauen.
2. State sichtbar machen.
3. State testen.
4. Dirty-/Persistence-Semantik absichern.
5. Framework-Funktion isoliert testen.
6. Framework kontrolliert integrieren.
7. Framework-Ergebnis validieren.
8. Ergebnis zurück in Theater-Command-State führen.
9. relevante Mutation Dirty markieren.
10. Ergebnis persistieren.
11. erst danach Automatisierung erweitern.

Frameworks dienen als:

- Execution Layer

Theater Command bleibt:

- Campaign Logic
- Decision Layer
- State Owner

---

# 5. Phase 0 – Projektgrundlage

Status:

- abgeschlossen

Erledigt:

- Repository erstellt
- Dokumentationsstruktur angelegt
- Vendor-Struktur definiert
- Source-Struktur definiert
- Mission-Editor-Arbeitsweise definiert
- Naming-Konventionen definiert
- Lua-Styleguide angelegt
- Testing-Dokumentation angelegt
- GitHub als Source of Truth etabliert

Wichtige Dateien:

- `README.md`
- `ROADMAP.md`
- `TASKS.md`
- `CHANGELOG.md`
- `ARCHITECTURE.md`
- `MISSION_EDITOR_SETUP.md`
- `NAMING_CONVENTIONS.md`
- `LUA_STYLEGUIDE.md`
- `docs/`
- `mission_editor/`
- `src/`
- `vendor/`

---

# 6. Phase 1 – Vendor- und Runtime-Grundlage

Status:

- für den aktuellen Entwicklungsstand ausreichend abgeschlossen

Vendor:

| Framework | Pfad | Stand |
|---|---|---:|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD-i18n | `vendor/ctld/CTLD-i18n.lua` | geladen |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Verbindlich:

- Vendor-Dateien werden nicht verändert.

Aktive Core-Dateien:

- `src/core/tc_config.lua`
- `src/core/tc_logger.lua`
- `src/core/tc_state.lua`
- `src/core/tc_utils.lua`
- `src/core/tc_scheduler.lua`
- `src/main.lua`
- `src/loader.lua`

Erledigt:

- Frameworks laden.
- Core lädt.
- Main startet.
- Loader startet.
- Framework-Verfügbarkeit wird geprüft.
- Theater Command startet ohne Lua-Abbruch.
- sichere Einzeldatei-Ladung ist etabliert.

Später optional:

- Loader-only-`dofile`-Variante
- zusätzliche Fehlerisolierung
- kompakter Debug-Startreport

Diese Punkte sind aktuell keine Blocker.

---

# 7. Phase 2 – World Layer

Status:

- abgeschlossen für den aktuellen state-first Stand

Aktive Dateien:

- `src/world/tc_airbase_scanner.lua`
- `src/world/tc_zone_factory.lua`

## 7.1 Airbase Scanner

Version:

- `v0.2.2`

Status:

- bestanden

Bestätigte Werte:

- total: `225`
- strategic: `19`
- secondary: `13`
- heliports: `1`
- helipads: `95`
- medical: `40`
- farps: `0`
- tactical: `13`
- unknown: `44`
- captureCandidates: `32`
- missionCandidates: `32`
- logisticsCandidates: `46`
- blueStartBases: `1`
- redStrategicCandidates: `18`

Ergebnis:

- Syria-Airbase-like Objects werden klassifiziert.
- Akrotiri wird als Blue-Startbasis erkannt.
- Medical Pads und einfache Helipads werden nicht als strategische Kampagnenziele behandelt.

## 7.2 ZoneFactory

Version:

- `v0.2.0`

Status:

- bestanden

Bestätigte Werte:

- relevante Kampagnenzonen: `46`
- skipped airbase-like objects: `179`
- strategic zones: `19`
- secondary zones: `13`
- heliport zones: `1`
- tactical zones: `13`
- captureZones: `32`
- missionZones: `32`
- logisticsZones: `46`
- startBaseZones: `1`

Ergebnis:

- nicht alle 225 DCS-Airbase-like Objects werden zu Kampagnenzonen.
- 46 relevante Zonen bilden die Grundlage für weitere Systeme.

---

# 8. Phase 3 – Campaign State und Capture

Status:

- bestanden für den aktuellen state-first Stand

Aktive Datei:

- `src/campaign/tc_capture_system.lua`

Version:

- `v0.2.2`

Bestätigt:

- Ownership
- Capture Eligibility
- Capture Pressure
- Capture Progress
- Capture Ready
- Mission Effect Integration
- Capture Apply
- linked Airbase Sync
- Pressure Reset nach Capture
- Read-Neutrality
- Ownership-No-Op-Neutralität

Bestätigte Startwerte:

- eligibleBases: `32`
- eligibleZones: `32`
- nonCaptureBases: `193`
- nonCaptureZones: `14`
- pressureRecords: `32`
- progressRecords: `32`

Bestätigte Kampagnenkette:

`Mission Completion -> Mission Effects -> Capture Pressure -> Capture Progress -> Capture Ready -> Apply -> Ownership -> Persistence`

Mission Failure:

- erzeugt aktuell bewusst keinen Capture Pressure

Noch offen für spätere Phasen:

- reale Unit-Auswertung in Capture-Zonen
- automatische produktive Ownership-Regeln
- Logistics-Einfluss
- Ground-Campaign-Einfluss
- AI-Reaktionen

---

# 9. Phase 4 – Logistics und FOB State

Status:

- state-first bestanden

Aktive Dateien:

- `src/logistics/tc_logistics_delivery.lua`
- `src/logistics/tc_fob_system.lua`

## 9.1 LogisticsDelivery

Version:

- `v0.2.1`

Status:

- bestanden
- Read-Neutrality bestanden

Bestätigte Werte:

- logistics hubs: `46`
- blue hubs: `7`
- red hubs: `24`
- neutral hubs: `15`
- active hubs: `31`
- limited hubs: `15`
- locked hubs: `0`

Bestätigt:

- Logistics Hubs entstehen aus ZoneFactory-State.
- Akrotiri ist Blue Logistics Hub.
- Reads verändern keinen persistierten State.
- echte Delivery-Mutationen markieren weiterhin Dirty.

Noch offen:

- produktive CTLD-Anbindung
- Supply-Verbrauch
- Cargo-Werte
- Logistics -> Capture
- Logistics -> AI
- reale Transportaufträge

## 9.2 FobSystem

Version:

- `v0.2.1`

Status:

- bestanden
- Read-Neutrality bestanden

Bestätigte Werte:

- FOB candidates: `6`
- stored candidates: `6`
- auto-planned FOBs: `2`
- skipped candidates: `4`

Blue FOBs:

- `FOB Ercan`
- `FOB Gecitkale`

Status:

- `UNDER_CONSTRUCTION`

Bestätigt:

- FOBs existieren als Theater-Command-State.
- Reads verändern keinen persistierten State.
- echte FOB-Mutationen markieren weiterhin Dirty.

Noch offen:

- realer CTLD-FOB-Bau
- Cargo -> FOB Build Progress
- Versorgung
- Reparatur
- Beschädigung
- operative DCS-Funktion des FOB

---

# 10. Phase 5 – Mission Generator

Status:

- state-first bestanden

Aktive Datei:

- `src/missions/tc_mission_generator.lua`

Version:

- `v0.2.3`

Bestätigte Werte:

- mission candidates: `78`
- fobSupportCandidates: `2`
- generated missions: `10`
- reservedCreated: `1`
- duplicatesSkipped: `1`
- typeLimitSkipped: `68`

Bestätigt:

- Mission Candidates
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
- FOB Support Candidate Integration

Der frühere Mission-Record-Loss-Verdacht wurde widerlegt.

Ursache der Fehldiagnose:

- String-keyed Lua-Dictionaries wurden über `#` beurteilt.

Korrekte Zählung:

- `pairs()`

Priority-3-Audit:

- abgeschlossen
- kein aktiver Missing-Dirty-Bug gefunden
- kein zusätzlicher Code-Fix erforderlich

Noch offen:

- reale Mission Execution
- automatische DCS-Outcome-Auswertung
- `CANCELLED`
- `EXPIRED`
- Logistics Effects
- AI Effects
- IADS Effects

---

# 11. Phase 6 – AI CAP State

Status:

- state-first bestanden

Aktive Datei:

- `src/ai/tc_ai_cap_manager.lua`

Version:

- `v0.2.1`

Bestätigte Werte:

- cap zone candidates: `31`
- auto-registered CAP zones: `12`
- CAP requests: `12`

Bestätigt:

- CAP-State
- Blue-/Red-CAP-Anforderungen
- Read-Neutrality
- echte State-Mutation setzt weiterhin Dirty

Noch nicht aktiv:

- reale MOOSE-CAP-Flüge

Bekannter latenter Punkt:

- `reactToActiveMissions()` besitzt aktuell keine produktive Call-Site.
- deshalb aktuell kein Runtime-Persistence-Bug.
- bei späterer Verdrahtung erneut prüfen.

Noch offen:

- CAP Templates
- MOOSE Spawn
- geeignete MOOSE-Ausführung
- CAP Lifecycle
- Losses
- Success
- Mission-Reaktion
- Ground-/Logistics-Reaktion

---

# 12. Phase 7 – F10 UI

Status:

- bestanden

Aktive Datei:

- `src/ui/tc_f10_menu.lua`

Version:

- `v0.2.3`

Bestätigt:

- `33` Commands
- Mission Details
- Mission Activation
- Completion Test
- Failure Test
- Capture Status
- Capture Ready
- Pressure Contested
- Capture Apply
- Logistics Status
- FOB Status
- AI CAP Status

Architekturentscheidung:

- F10 ist nicht die Hauptsteuerung der Kampagne.
- Persistence bekommt kein normales Spieler-Save-/Load-Menü.

Langfristig sollen Spieler-UI und Debug-/Admin-UI klarer voneinander getrennt werden.

---

# 13. Phase 8 – Persistence

Status:

- technische Persistence bestanden
- Background Autosave bestanden
- produktiver Restore noch deaktiviert

Aktive Datei:

- `src/campaign/tc_persistence_system.lua`

Version:

- `v0.2.6`

Bestätigt:

- Sandbox-Prüfung
- Dateischreiben
- Dateilesen
- Campaign Snapshot
- Compile
- Evaluate
- Validation
- kontrollierter Import
- Background Autosave
- Dirty Awareness
- `SAVED`
- `SKIPPED`
- kontrollierter `FAILED`
- Retry

Autosave:

- initial nach `20s`
- danach alle `120s`

Verbindlich:

- `productiveRestore=false`

Priority 3 ist inzwischen abgeschlossen.

Der produktive Restore bleibt dennoch deaktiviert, weil zusätzlich noch geklärt werden müssen:

- Restore-/Initialisierungsreihenfolge
- Save-Versionierung
- Save-Kompatibilität
- Modul-Lifecycle
- Framework-Nebenwirkungen
- kontrollierter Restore-Test

## 13.1 Produktive Save-Datei

Pfad:

`C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua`

Letzter bestätigter Stand nach dem CTLD-Test vom 2026-09-29:

- Größe: `3094967` Bytes
- Änderungszeit: `2026-09-21 15:00:00.5926451`

SHA-256:

`C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596`

Der isolierte CTLD-Test hat diesen Save nicht verändert.

---

# 14. Phase 9 – Priority 3 Dirty-Coverage

Status:

- abgeschlossen im dokumentierten Umfang

Abschluss:

- 2026-09-21

Geprüft:

- CaptureSystem
- LogisticsDelivery
- FobSystem
- MissionGenerator
- AICapManager

Ergebnis:

### CaptureSystem

- Read-Dirty-Problem behoben.
- Ownership-No-Op-Problem behoben.

### LogisticsDelivery

- Read-Neutrality-Bug behoben.
- `v0.2.1`
- Runtime-Regression bestanden.

### FobSystem

- Read-Neutrality-Bug behoben.
- `v0.2.1`
- Runtime-Regression bestanden.

### MissionGenerator

- kein aktiver Missing-Dirty-Bug.
- kein Code-Fix erforderlich.

### AICapManager

- Read-Neutrality-Bug behoben.
- `v0.2.1`
- Runtime-Regression bestanden.

Latente Lifecycle-Punkte bleiben dokumentiert.

Priority 3 wird ohne neuen technischen Anlass nicht erneut vollständig durchgeführt.

---

# 15. Phase 10 – CTLD Framework-Proof-of-Concept

Status:

- KI-Truppentransport-PoC für den getesteten Aufbau bestanden
- produktive TC-Integration offen

Testdatum:

- 2026-09-29

CTLD:

- `1.6.1`

## 15.1 Zonenregistrierung

Für den getesteten Runtime-Pfad bestätigt:

Nach bestehender CTLD-Initialisierung können normalisierte Einträge ergänzt werden in:

- `ctld.pickupZones`
- `ctld.dropOffZones`

Getesteter Pickup:

- `CTLD_PICKUP_BLUE_AKROTIRI_01`

Getesteter technischer Dropoff:

- `CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01`

Reservierter späterer FOB-Dropoff:

- `CTLD_DROPOFF_BLUE_ERCAN_FOB_01`

CTLD verwendete die ergänzten Einträge im Test tatsächlich.

Für diese getestete Runtime-Ergänzung war keine erneute Ausführung von:

- `ctld.initialize()`

erforderlich.

Daraus wird nicht abgeleitet, dass `ctld.initialize()` generell niemals erneut aufgerufen werden dürfte.

## 15.2 KI-Transporterregistrierung

Für den getesteten CTLD-AI-Pfad bestätigt:

Ein KI-Transporter muss in:

- `ctld.transportPilotNames`

registriert sein.

Getestete Unit:

- `TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01`

Vor Registrierung:

- `108` Einträge

Danach:

- `109` Einträge

Unit:

- genau einmal vorhanden

Produktive TC-Integration muss dies später automatisch, idempotent und lifecycle-sicher durchführen.

## 15.3 Erfolgreicher Transport

Testmission:

`C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz`

SHA-256 vor Runtime-Test:

`5F0D89DF744A7083401E36713B148BD21813FF187CC36EC1F088507163458C57`

Transportgruppe:

- `TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01`

Transportunit:

- `TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01`

Typ:

- Mi-8

Für den getesteten Aufbau bestätigter Ablauf:

`Pickup -> Taxi -> Takeoff -> Transit -> Off-Airfield-Landung -> automatischer Dropoff -> Bodengruppe`

Pickup:

- `16` Soldaten

Pickup-Zähler:

- `10000 -> 9999`

Erzeugte Bodengruppe:

- `Dropped Group 2`

Group-ID:

- `70001`

Einheiten:

- `16 x Soldier M249`

Nicht verwendet wurden:

- manuelles CTLD-Loading
- manuelles CTLD-Unload
- direkte Manipulation von `ctld.inTransitTroops`
- Teleport
- Runtime-Routenänderung
- Runtime-Taskänderung

Der Test bestätigt diesen isolierten Framework-Pfad.

Er bestätigt noch keine produktive Theater-Command-Orchestrierung.

## 15.4 Off-Airfield-Landung

Für den getesteten Aufbau bestätigter Ansatz:

- normaler Turning Point
- DCS-native Perform Task `Land`

Dropoff-Zentrum:

- x / North: `-29249.110954281`
- z / East: `-271836.070539260`

Wegpunkt:

- Höhe: `100 m BARO`
- Geschwindigkeit: `30 m/s`

Land Task:

- `duration=300`
- `durationFlag=true`

Touchdown:

- ungefähr `1.06 m` vom Zentrum entfernt

Für diesen getesteten Truppentransport war kein Invisible FARP erforderlich.

Der ältere ungebundene `Land / Landing`-Waypoint-Ansatz führte nicht zu einem vollständigen erfolgreichen Transportzyklus.

Die genaue Ursache des früheren Turnback-Verhaltens ist dadurch nicht abschließend bewiesen.

## 15.5 Bekannter CTLD-Fehler

Beim Grounded-Übergang trat im erfolgreichen Test genau einmal auf:

`CTLD.lua:6150: attempt to get length of local 'RepackCommandsPath' (a nil value)`

Kontext:

- `updateRepackMenu`
- `updateRepackMenuOnlanding`

Der Pickup-/Dropoff-Pfad wurde trotzdem abgeschlossen.

Nicht bewiesen:

- dass der Fehler langfristig harmlos ist
- dass der betreffende Scheduler danach dauerhaft beendet wurde

Dass der unbehandelte Fehler den betreffenden Scheduler-Pfad beendet haben könnte, ist eine source-basierte technische Inferenz und kein direkter Runtime-Beweis.

Verbindlich:

- kein Patch an `vendor/ctld/CTLD.lua`

Vor produktiver Integration muss eine Theater-Command-seitige beziehungsweise konfigurationsbasierte Lösung oder saubere Isolation bewertet werden.

---

# 16. Phase 11 – Produktive CTLD-Integration

Status:

- nächster Entwicklungsbereich
- noch nicht implementiert

Ziel:

Den bestandenen CTLD-PoC kontrolliert mit dem Theater-Command-State verbinden.

Zu definieren:

- fachliche Integrationskomponente unter `src/`
- idempotente Pickup-Zonenregistrierung
- idempotente Dropoff-Zonenregistrierung
- idempotente KI-Transporterregistrierung
- Transporter-Lifecycle
- Spawn/Aktivierung/Despawn
- Umgang mit `RepackCommandsPath`
- Transportauftrag
- Auftragserfolg
- Auftragsfehler
- Ergebnisvalidierung
- Rückkopplung in LogisticsDelivery
- Rückkopplung in FobSystem
- Dirty-Markierung
- Persistence-Grenze

Verbindlich:

- keine generische `tc_ctld.lua`
- keine generische `tc_ctld_bridge.lua`
- Vendor unverändert

---

# 17. Phase 12 – CTLD Cargo und Crates

Status:

- noch nicht begonnen

Der erfolgreiche Test vom 2026-09-29 war:

- KI-Truppentransport

Er war kein:

- Crate-/Cargo-Test

Separat zu prüfen:

- Crate Spawn
- Logistics-Zone-/Logistic-Unit-Voraussetzungen
- Crate Loading
- Sling Load
- Crate Drop
- Supply
- Engineering
- Repair
- Fuel
- Ammo
- FOB Core
- Cargo Delivery Validation

Erst nach diesen Tests darf ein echter Cargo-/FOB-Pfad als bestanden gelten.

---

# 18. Phase 13 – Reale FOB-Integration

Status:

- noch nicht begonnen

Aktuelle FOBs:

- FOB Ercan
- FOB Gecitkale

Aktuell:

- state-only
- `UNDER_CONSTRUCTION`

Späterer Zielpfad:

`MissionGenerator -> Logistics Auftrag -> CTLD Cargo -> Delivery Validation -> LogisticsDelivery -> FobSystem -> Build Progress -> FOB Activation -> Persistence`

Mögliche spätere Funktionen:

- FARP
- Rearm
- Refuel
- Spawn-/Parking-Funktion
- Defense
- Logistics
- Repair
- Communications

Invisible FARPs können für echte FOB-Infrastruktur später sinnvoll sein.

Für den getesteten KI-Truppentransport-PoC war kein Invisible FARP erforderlich.

---

# 19. Phase 14 – MOOSE AI-Spawns

Status:

- noch nicht produktiv begonnen

Ziele:

- reale CAP-Spawns
- Strike
- SEAD
- DEAD
- CAS
- Escort
- Transport Support
- Carrier Air Wing

AICapManager bleibt:

- State / Intent Layer

MOOSE wird:

- Execution Layer

Nächste Voraussetzungen:

- Templates
- Naming
- Spawn-Zonen
- Lifecycle
- Event-Auswertung
- State-Rückkopplung
- Persistence-Grenze

---

# 20. Phase 15 – AI Director

Status:

- noch nicht implementiert

Langfristige Aufgaben:

- Operationslage bewerten
- Missionsbedarf erkennen
- verfügbare Assets berücksichtigen
- Capture berücksichtigen
- Logistics berücksichtigen
- FOBs berücksichtigen
- CAP berücksichtigen
- IADS berücksichtigen
- Verluste berücksichtigen
- Ground Operations berücksichtigen

AI Director soll später für Blue und Red operative Entscheidungen erzeugen.

---

# 21. Phase 16 – Ground Operations und CAS

Status:

- Zukunftsphase

Ziele:

- Bodentruppen bewegen
- Ground Objectives
- Angriffe
- Verteidigung
- Gegenangriffe
- Support Requests
- CAS Requests

Perspektivischer Pfad:

`Ground Operation -> Enemy Contact -> CAS Need -> MissionGenerator / AI Director -> verfügbare Air Assets -> CAS Mission -> Ergebnis -> Ground State`

Unter anderem relevant:

- A-10C II
- F/A-18C
- andere CAS-fähige Assets

---

# 22. Phase 17 – Skynet IADS

Status:

- vorbereitet
- noch nicht produktiv integriert

Vendor:

- `vendor/skynet-iads/SkynetIADS.lua`

Ziele:

- SAM-Gruppen
- EWR
- IADS-Netz
- Shutdown-Verhalten
- Threat Reactions
- MissionGenerator-Ziele
- SEAD
- DEAD
- State
- Persistence

Skynet bleibt Vendor und wird nicht verändert.

---

# 23. Phase 18 – Carrier Operations

Status:

- Zukunftsphase

Vorgesehen:

- Supercarrier
- Carrier Task Group
- F/A-18C
- F-14
- weitere Carrier-fähige Flugzeuge
- Carrier CAP
- Fleet Defense
- Strike
- Escort
- Logistics

Der Carrier soll Teil der operativen Kampagne werden und nicht nur statische Kulisse sein.

---

# 24. Phase 19 – Produktiver Restore

Status:

- bewusst deaktiviert

Aktuell:

- technische Importfähigkeit vorhanden
- `productiveRestore=false`

Priority 3 ist nicht mehr der offene Blocker.

Vor Freigabe sind weiterhin notwendig:

- Restore-/Initialisierungsreihenfolge
- Save-Versionierung
- Kompatibilitätsstrategie
- Modul-Lifecycle
- Schutz vor doppelten Framework-Nebenwirkungen
- Umgang mit CTLD-/MOOSE-/Skynet-Runtime-State
- kontrollierter Restore-Test

Späterer Ablauf:

1. Mission startet.
2. Persistence prüft Sandbox.
3. Save-Datei wird gefunden.
4. Save wird gelesen.
5. Save wird validiert.
6. Version wird geprüft.
7. Snapshot wird importiert.
8. State-Systeme übernehmen restored State.
9. Runtime-Frameworks werden kontrolliert aus diesem State rekonstruiert.
10. Restore wird eindeutig geloggt.

Noch nicht aktiv:

- automatischer Startup-Restore
- Restore realer CTLD-Objekte
- Restore realer MOOSE-Gruppen
- Restore realer Skynet-IADS-Zustände

---

# 25. Phase 20 – Dynamische persistente Kampagne

Status:

- Zielphase

Ziel:

- Blue und Red handeln weitgehend autonom.
- Spieler nehmen als Teil der Kampagne teil.
- Missionen entstehen aus der Lage.
- Capture verändert Front und Operationsraum.
- Logistics beeinflusst Kampffähigkeit.
- FOBs erweitern Reichweite.
- Ground Operations verändern Gelände.
- IADS reagiert dynamisch.
- Air Operations reagieren auf Lage und Verluste.
- Fortschritt bleibt nach späterer Freigabe des produktiven Restore über Missionsstarts hinweg erhalten.

Benötigt:

- produktive Framework-Integration
- Event-Auswertung
- AI Director
- Ground Campaign
- Logistics
- FOBs
- IADS
- Persistence Restore
- Multiplayer-Validierung

---

# 26. Aktuelle Entwicklungswerkzeuge

Die Werkzeugtrennung ist seit 2026-09-29 verbindlich.

Diese Werkzeuge sind Entwicklungswerkzeuge und keine Runtime-Abhängigkeiten der fertigen Kampagne.

## 26.1 ChatGPT

Rolle:

- Projektkoordination
- Architektur
- Testplanung
- Ergebnisbewertung
- GitHub-Audit
- Dokumentationspflege
- Definition des nächsten Arbeitsschritts
- Vorbereitung präziser Claude-Aufträge

## 26.2 Claude + dcs-mcp

Aktuell:

- `dcs-mcp 0.9.11`

Terrain Store:

- `C:\Users\Paul\AppData\Local\dcs-mcp\terrain`

Syria:

- installiert

Verwendung:

- `.miz` analysieren
- Mission-Editor-Struktur prüfen
- Mission Editor bearbeiten
- Gruppen
- Units
- Trigger Zones
- Wegpunkte
- Tasks
- Airbase-Zuordnungen
- Terrain
- gespeicherte Missionsänderungen

Für `.miz`-/Mission-Editor-Arbeit ist dieser Pfad aktuell bevorzugt.

## 26.3 Claude Code + DCS-SMS

DCS-SMS:

- `0.27.2`

Hook:

- `me-bridge-0.27.2`

Verifiziertes Installationsverzeichnis:

`C:\Tools\dcs-sms`

Claude-Code-Skill:

`C:\Users\Paul\.claude\skills\dcs-sms\SKILL.md`

Verwendung:

- Mission-Editor-Status
- laufende DCS-Runtime
- Runtime-Lua
- Theater-Command-Live-State
- CTLD-Live-State
- Units
- Positionen
- Flugzustände
- Aktivierung
- Logs
- Runtime-Regressionen

DCS-SMS ist kein Theater-Command-Runtime-Framework.

Aus dem bestätigten Stand wird kein exakter Executable-Pfad abgeleitet.

## 26.4 DCS

DCS ist die autoritative Runtime.

Ein Offline-Tool kann Struktur und gespeicherte Konfiguration prüfen.

Nur die reale DCS-Runtime kann unter anderem beweisen:

- AI-Verhalten
- Taxi
- Takeoff
- Landung
- CTLD-Runtime-Reaktion
- Spawn
- Dropoff
- Scheduler-Verhalten

---

# 27. Verbindlicher Entwicklungsworkflow

Für Mission-Editor-/Framework-Arbeit:

`ChatGPT -> Claude + dcs-mcp -> Missionsdatei -> Claude Code + DCS-SMS -> DCS Runtime -> Ergebnisbewertung -> GitHub`

Dabei:

- ChatGPT koordiniert Architektur und Projektstand.
- Claude + dcs-mcp bearbeitet beziehungsweise prüft `.miz`.
- Claude Code + DCS-SMS prüft lokale ME-/DCS-Runtime.
- DCS liefert den tatsächlichen Laufzeitbeweis.
- GitHub hält den bestätigten Stand fest.

---

# 28. Aktuelle Meilensteine

## Erreicht

- Projektgrundlage
- Vendor-Struktur
- Core Layer
- World Layer
- Airbase Scanner
- ZoneFactory
- CaptureSystem
- LogisticsDelivery
- FobSystem
- MissionGenerator
- AICapManager
- F10Menu
- Background Persistence
- Mission Completion Pipeline
- Mission Failure Pipeline
- Capture Ready Apply
- Embedded Resource Audit
- Mission-Dictionary-Diagnose korrigiert
- Capture Read-Neutrality
- Capture Ownership-No-Op
- LogisticsDelivery Read-Neutrality
- FobSystem Read-Neutrality
- AICapManager Read-Neutrality
- Priority 3 im dokumentierten Umfang abgeschlossen
- CTLD Runtime-Zonenregistrierung für getesteten Pfad bestätigt
- CTLD KI-Transporterregistrierung für getesteten Pfad bestätigt
- automatischer CTLD-KI-Pickup für getesteten Aufbau bestätigt
- Off-Airfield-Landung für getesteten Mi-8-Aufbau bestätigt
- automatischer CTLD-Dropoff für getesteten Aufbau bestätigt
- reale Bodengruppe nach Dropoff bestätigt
- Persistence während isoliertem CTLD-Test unverändert bestätigt

## Aktueller Meilenstein

**Priority 4 – produktive CTLD-Integration vorbereiten**

Der technische Transport-PoC für den getesteten Aufbau ist abgeschlossen.

Jetzt muss aus dem isolierten Test eine saubere Theater-Command-Architektur entstehen.

## Nächster technischer Meilenstein

Noch keine vorschnelle Code-Datei festlegen.

Zuerst:

- aktuelle Source-Struktur prüfen
- CTLD-Integrationsgrenze entwerfen
- `RepackCommandsPath`-Problem source-backed bewerten
- fachliche Zuständigkeit festlegen

Danach:

- exakt eine konkrete Datei beziehungsweise Integrationsaufgabe bestimmen

---

# 29. Nächster konkreter Entwicklungsschritt

Der nächste Schritt ist nicht:

- erneut Priority 3 auditieren
- erneut denselben Mi-8-PoC durchführen
- CTLD-Vendor patchen
- sofort Crates implementieren
- sofort produktiven Restore aktivieren
- sofort Invisible FARP bauen
- sofort MOOSE CAP integrieren

Der nächste Schritt ist:

**Architekturprüfung für die erste produktive Theater-Command-CTLD-Integration.**

Zu klären:

- welche fachliche Komponente die CTLD-Konfiguration verwaltet
- welche bestehende Datei erweitert wird oder ob eine fachlich klar benannte neue Datei erforderlich ist
- wie Zonen idempotent registriert werden
- wie Transporter idempotent registriert werden
- wie Transporter-Lifecycle verwaltet wird
- wie ein Auftrag repräsentiert wird
- wie Erfolg erkannt wird
- wie Fehler erkannt wird
- wie `RepackCommandsPath` ohne Vendor-Patch behandelt wird
- wie Resultate in `TC.State` zurückgeführt werden
- welche Resultate Dirty setzen
- welche Daten persistiert werden
- welche CTLD-Daten runtime-only bleiben
- was später nach Restore rekonstruiert werden muss

---

# 30. Was aktuell ausdrücklich nicht als fertig gilt

Noch nicht produktiv:

- Theater-Command-CTLD-Integration
- CTLD Cargo Economy
- CTLD Crates
- reale CTLD-FOBs
- Supply-Verbrauch
- Logistics -> Capture
- Logistics -> AI
- reale MOOSE-Spawns
- AI Director
- Ground Campaign
- CAS Automation
- Skynet-Kampagnenintegration
- Carrier Operations
- produktiver Restore
- Multiplayer
- vollständige Blue-/Red-Autonomie

---

# 31. Aktuelle Risiken

## CTLD Repack-Menü

Beim erfolgreichen Test genau einmal beobachteter Fehler:

`CTLD.lua:6150: attempt to get length of local 'RepackCommandsPath' (a nil value)`

Risiko:

- Scheduler-/Menüpfad könnte nach dem unbehandelten Fehler beeinträchtigt sein.

Nicht direkt bewiesen:

- ob der betreffende Scheduler dauerhaft beendet wurde

Maßnahme:

- Source-backed prüfen.
- keinen Vendor-Patch vornehmen.
- Theater-Command-seitige beziehungsweise konfigurationsbasierte Isolation oder Lösung bewerten.

## CTLD State vs. TC State

Risiko:

- Framework-Runtime und Kampagnenstate können auseinanderlaufen.

Maßnahme:

- klare Eigentümerschaft der Daten
- Result Validation
- idempotente Operationen
- definierte Dirty-/Persistence-Grenze

## MissionScripting.lua

Für Persistence und DCS-SMS sind lokale Sandbox-Anpassungen relevant.

Risiko:

- DCS-Updates können `MissionScripting.lua` überschreiben.

Danach müssen die lokalen Freigaben erneut geprüft werden.

## Save-Kompatibilität

Risiko:

- spätere State-Strukturen können ältere Saves inkompatibel machen.

Später notwendig:

- Save-Versionierung
- Migrations-/Kompatibilitätsstrategie
- Backup
- Rotation
- Fallback

## Framework-Integration

Risiko:

- reale CTLD-, MOOSE- und Skynet-Aktionen erzeugen starke DCS-Nebenwirkungen.

Maßnahme:

- ein Framework-Pfad pro Schritt
- isolierte Tests
- Runtime-Beweis
- erst danach produktive Integration

---

# 32. Historischer Stand 2026-07-06

Der Stand vom 2026-07-06 bleibt historisch relevant.

Zu diesem Zeitpunkt standen bereits:

- World State
- Zone State
- Capture State
- Logistics State
- FOB State
- Mission State
- AI CAP State
- F10-Testbed
- frühe Background Persistence

Seitdem zusätzlich erreicht:

- PersistenceSystem `v0.2.6`
- MissionGenerator-Diagnose korrigiert
- Mission-/Capture-Regressions bestätigt
- Priority 3 im dokumentierten Umfang abgeschlossen
- drei Read-Neutrality-Fixes
- CTLD-KI-Transport-PoC für den getesteten Aufbau

Der historische Stand ist kein aktueller Arbeitsauftrag mehr.

---

# 33. Startpunkt für die nächste Session

Jede neue Session beginnt mit einem aktuellen GitHub-Audit.

Mindestens prüfen:

- `README.md`
- `ROADMAP.md`
- `TASKS.md`
- `CHANGELOG.md`
- `ARCHITECTURE.md`

Für den aktuellen CTLD-Bereich zusätzlich:

- `AGENTS.md`
- `.agents/skills/theater-command/SKILL.md`
- `MISSION_EDITOR_SETUP.md`
- `docs/02_technical_architecture.md`
- `docs/03_mission_editor_basics.md`
- `docs/05_logistics_system.md`
- `docs/09_persistence.md`
- `docs/10_testing.md`
- `mission_editor/README.md`
- `mission_editor/ctld_start_zones.md`
- `mission_editor/trigger_setup.md`
- `src/logistics/README.md`
- `src/logistics/tc_logistics_delivery.lua`
- `src/logistics/tc_fob_system.lua`
- `src/missions/tc_mission_generator.lua`

Danach nicht aus älteren Chatständen weiterarbeiten.

Nächster technischer Ausgangspunkt:

**Priority 4 – produktive CTLD-Integration aus dem bestandenen PoC ableiten.**

---

# 34. Roadmap-Leitsatz

Diese Roadmap ist kein starres Releaseversprechen.

Sie beschreibt die technische Reihenfolge, in der Theater Command DCS kontrolliert wachsen soll.

Aktueller Leitsatz:

- State zuerst.
- Persistence sauber halten.
- Frameworks isoliert beweisen.
- Frameworks als Execution Layer behandeln.
- Vendor unverändert lassen.
- reale DCS-Runtime als Verhaltensbeweis verwenden.
- immer nur eine konkrete Aufgabe pro Schritt.
- erst nach bestandenem Test produktiv weiterbauen.

Aktueller Übergang:

**state-first Kampagnenkern + dirty-aware Persistence + abgeschlossene Priority-3-Dirty-Coverage + bestandener CTLD-KI-Truppentransport-PoC für den getesteten Aufbau -> kontrollierte produktive CTLD-Integration**
