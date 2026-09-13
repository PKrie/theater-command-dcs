# Logistics System

## Verbindliches Update — 2026-09-12

LogisticsDelivery `v0.2.0` und FobSystem `v0.2.0` sind state-first funktional bestanden. CTLD ist geladen und erkannt, aber weiterhin nicht produktiv angebunden. PersistenceSystem `v0.2.6` nimmt Logistics- und FOB-State als Teil des Snapshots über dirty-aware Background Autosave auf; `productiveRestore=false`. MissionGenerator `v0.2.3` erzeugt 10 Mission Records; der frühere Record-Loss-Verdacht ist widerlegt. Der Offline Embedded Resource Audit ist abgeschlossen: 13/13 relevante aktive Ressourcen `EXACT_MATCH`, keine aktive Embedded-Runtime-Drift. Priority 3 bleibt offen; nächster technischer Schritt ist der READ-ONLY Dirty-Coverage-Audit von `src/logistics/tc_logistics_delivery.lua`. Nicht mehr aktuell: ein reproduzierbarer Mission-Record-Loss, der Embedded Audit als offener nächster Schritt, sowie die Annahme, ein Logistics-Code-Fix sei bereits notwendig — das ist erst Ergebnis des Audits. Ältere Statusangaben sind historische Snapshots.

Diese Datei beschreibt das Logistiksystem von **Theater Command DCS**.

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## 1. Zweck des Logistiksystems

Das Logistiksystem soll langfristig Versorgung, FOB-Aufbau, Transportmissionen und operative Reichweite der Kampagne steuern.

Logistik soll nicht nur Dekoration sein.

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
- CTLD-Cargo-Flüge

Aktuell ist das System bewusst state-first aufgebaut.

Das bedeutet:

    Logistikdaten werden im Theater-Command-State erzeugt.
    Es werden noch keine echten CTLD-Aktionen ausgelöst.

Bereits vorhanden:

- Logistics Hubs
- FOB-State
- MissionGenerator-Verknüpfung
- F10 Logistics-/FOB-Status
- Persistence Snapshot

Noch nicht produktiv:

- CTLD-Cargo
- echte FOB-Bauten
- Supply-Verbrauch
- Logistics-Capture-Wirkung
- AI-Logistics-Wirkung

---

## 2. Aktueller technischer Stand

Stand:

    2026-09-12

Aktive Dateien:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

Getestete Versionen:

    LogisticsDelivery: v0.2.0
    FobSystem: v0.2.0

Status:

    state-first funktional bestanden

Bestätigt durch DCS-Logtests:

- LogisticsDelivery lädt.
- LogisticsDelivery startet.
- LogisticsDelivery erzeugt Logistics Hubs.
- FobSystem lädt.
- FobSystem startet.
- FobSystem erzeugt FOB-Kandidaten.
- FobSystem plant erste Blue-FOBs.
- FOBs werden state-only erzeugt.
- MissionGenerator erkennt FOB-Support-Kandidaten.
- F10Menu kann Logistik- und FOB-Status anzeigen.
- Es gab keinen Theater-Command-Lua-Fehler.
- Es gab keinen Lua-Stacktrace.

Ergänzend gültig:

- LogisticsDelivery ist der nächste Priority-3-Dirty-Coverage-Audit.
- FobSystem-Dirty-Coverage folgt danach separat.
- Ein konkreter Logistics-Bug ist derzeit nicht vorab bewiesen.
- Keine Codeänderung ohne Audit-Befund.

---

## 3. Aktuelle bestätigte Werte

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

Status der erzeugten FOBs:

    UNDER_CONSTRUCTION

MissionGenerator-Verknüpfung:

    fobSupportCandidates: 2
    reservedCreated: 1

Bewertung:

    LogisticsDelivery und FobSystem sind state-first funktionsfähig.
    CTLD ist geladen, aber noch nicht produktiv mit diesen Systemen verbunden.
    FOB-Support ist bereits im MissionGenerator sichtbar.

---

## 4. Designprinzip

Das Logistiksystem folgt dem gleichen Grundprinzip wie die restliche Architektur:

    erst State
    dann Sichtbarkeit
    dann Tests
    dann echte Framework-Aktionen

Aktuell gilt:

- keine echten CTLD-Crates
- keine echten CTLD-Pickup-Zonen
- keine echten CTLD-Dropoff-Zonen
- keine echten CTLD-FOBs
- keine echten Cargo-Flüge
- kein echter Supply-Verbrauch

Richtig statt "keine produktive Persistenz" (pauschal):

- Background Persistence ist aktiv
- Logistics-/FOB-State wird gespeichert
- produktiver Startup-Restore ist deaktiviert
- CTLD-Runtime-State ist noch nicht produktiv integriert

Grund:

    CTLD erzeugt in DCS echte Nebenwirkungen.
    Diese Nebenwirkungen sollen erst aktiviert werden, wenn State, UI und Debug ausreichend stabil sind.

---

## 5. Beziehung zu Airbase Scanner und ZoneFactory

LogisticsDelivery nutzt Daten aus:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

Aktuelle vorgelagerte Werte:

    Airbase-like Objects: 225
    relevante Kampagnenzonen: 46
    logisticsCandidates: 46

ZoneFactory erzeugt aktuell:

    logisticsZones: 46

LogisticsDelivery erzeugt daraus:

    logistics hubs: 46

Bedeutung:

    Logistik basiert nicht auf allen 225 DCS-Airbase-like Objects.
    Logistik nutzt die 46 relevanten Kampagnenzonen.
    Diese Filterung verhindert fehlerhafte Logistikhubs auf ungeeigneten DCS-Sonderobjekten.

---

## 6. Logistics Hubs

Logistics Hubs sind die zentralen logistischen Knoten im Theater-Command-State.

Ein Logistics Hub kann später enthalten:

- Supply
- Fuel
- Ammo
- Engineering
- Repair Capacity
- Cargo Demand
- Cargo Delivered
- Build Progress
- Owner
- Status
- Linked Zone
- Linked Base
- CTLD Pickup Capability
- CTLD Dropoff Capability
- FOB Support Capability

Aktuell werden Logistics Hubs state-only erzeugt.

Bestätigte Werte:

    total hubs: 46
    blue hubs: 7
    red hubs: 24
    neutral hubs: 15

---

## 7. Hub Status

Aktuelle Hub-Statuswerte:

    active hubs: 31
    limited hubs: 15
    locked hubs: 0

Bedeutung:

- `ACTIVE` bedeutet: Hub ist grundsätzlich nutzbar.
- `LIMITED` bedeutet: Hub ist eingeschränkt oder noch nicht voll nutzbar.
- `LOCKED` bedeutet: Hub ist nicht nutzbar.

Aktuelle Bewertung:

    Die Hub-Statuslogik ist vorbereitet.
    Sie hat noch keine produktiven Auswirkungen auf echte CTLD- oder MOOSE-Aktionen.

Spätere mögliche Auswirkungen:

- nur aktive Hubs können Cargo senden
- eingeschränkte Hubs senden reduzierte Versorgung
- locked Hubs erzeugen keine Logistikmissionen
- Hub-Status beeinflusst FOB-Bau
- Hub-Status beeinflusst Capture-Fähigkeit
- Hub-Status beeinflusst AI-Director-Entscheidungen

---

## 8. Blue Hubs

Aktuell bestätigt:

    blue hubs: 7

Blue Hubs bilden die frühe blaue Versorgungsbasis.

Wichtigster Blue Hub:

    Akrotiri

Mögliche Rollen:

- Main Logistics Base
- erster Supply-Knoten
- Ausgangspunkt für Transportmissionen
- Quelle für FOB-Aufbau
- Quelle für Engineering und Repair
- Quelle für spätere CTLD-Cargo-Operationen

Aktuelle Einschränkung:

    Blue Hubs erzeugen noch keine echten CTLD-Cargo-Aufträge.
    Blue Hubs sind State-Daten.

---

## 9. Red Hubs

Aktuell bestätigt:

    red hubs: 24

Red Hubs bilden die rote Logistikstruktur auf dem syrischen Festland.

Mögliche spätere Rollen:

- rote Versorgungsknoten
- rote Operationsbasis
- rote Missionsquellen
- Ziele für Interdiction
- Ziele für Strike
- Ziele für SEAD/DEAD im Umfeld
- Ziele für AI-Director-Logik
- Ziele für Capture-Vorbereitung

Aktuelle Einschränkung:

    Red Hubs erzeugen noch keine echten roten Operationen.
    Red Hubs sind State-Daten.

---

## 10. Neutral Hubs

Aktuell bestätigt:

    neutral hubs: 15

Neutral Hubs sind noch nicht eindeutig einer Seite als aktive operative Logistikbasis zugeordnet.

Mögliche Rollen:

- spätere Capture-Ziele
- spätere Forward Locations
- logistische Zwischenräume
- durch Missionen aktivierbare Knoten
- neutrale Infrastruktur
- zukünftige FOB-/LZ-Kandidaten

Aktuelle Einschränkung:

    Neutral Hubs beeinflussen die Kampagne noch nicht produktiv.

---

## 11. FOB-System

Das FOB-System ist Teil des Logistics Layers.

Aktive Datei:

    src/logistics/tc_fob_system.lua

Getestete Version:

    v0.2.0

Aufgaben:

- FOB-Kandidaten aus Logistics Hubs ableiten
- geeignete Blue-FOBs automatisch planen
- FOB-State erzeugen
- Baufortschritt vorbereiten
- Versorgung vorbereiten
- CTLD-Hooks vorbereiten
- MissionGenerator mit FOB-Support-Daten versorgen

Aktuelle Bewertung:

    Das FOB-System ist state-first funktionsfähig.
    FOBs existieren im Theater-Command-State.
    Es werden noch keine echten CTLD-FOBs erzeugt.
    Es werden keine echten Bau-Crates verwendet.
    Die allgemeine FobSystem-Dirty-Coverage ist noch offen.

---

## 12. FOB Candidates

Aktuell bestätigt:

    FOB candidates: 6
    stored candidates: 6
    skipped candidates: 4

FOB Candidates entstehen aus geeigneten Logistics Hubs.

Mögliche Kriterien:

- geeigneter Besitzerstatus
- geeignete Zone
- geeignete Lage
- logistischer Bedarf
- Nähe zur Operationsrichtung
- zukünftige Relevanz für Blue
- Eignung als Vorwärtsbasis

Aktuelle Einschränkung:

    Die Auswahl ist state-only.
    Mission Editor, CTLD-Zonen und echte Cargo-Mechanik sind noch nicht angebunden.

---

## 13. Automatisch geplante FOBs

Aktuell bestätigt:

    auto-planned FOBs: 2
    Blue FOBs: 2

Erzeugte FOBs:

    FOB Ercan
    FOB Gecitkale

Status:

    UNDER_CONSTRUCTION

Wichtig:

    `planned=0` in älteren Statuszusammenfassungen ist kein Fehler.
    Automatisch geplante FOBs wechseln direkt in UNDER_CONSTRUCTION, sobald initialer Baufortschritt gesetzt wurde.

Bewertung:

    Blue besitzt jetzt zwei state-only FOB-Projekte.
    Diese können bereits für Missionslogik genutzt werden.
    CTLD-Bau ist noch nicht aktiv.

---

## 14. FOB Status

Aktuelle FOBs stehen auf:

    UNDER_CONSTRUCTION

Mögliche spätere Statuswerte:

- PLANNED
- UNDER_CONSTRUCTION
- ACTIVE
- DAMAGED
- SUPPLY_LOW
- ABANDONED
- DESTROYED

Aktuelle Bedeutung von UNDER_CONSTRUCTION:

    FOB existiert als geplanter logistischer State.
    FOB ist noch nicht produktiv einsatzbereit.
    FOB benötigt später Cargo, Engineering oder Missionserfolg.

---

## 15. FOB Support Missions

MissionGenerator nutzt den FOB-State bereits.

Aktuell bestätigt:

    fobSupportCandidates: 2
    reservedCreated: 1

MissionGenerator `v0.2.3` erzeugt 10 Mission Records.

Bedeutung:

    FOB-Support wird im Missionspool berücksichtigt.
    Mindestens eine FOB-Support-Mission wird reserviert.
    FOB-Support wird nicht durch andere Missionstypen verdrängt.
    Keine echten CTLD-Aktionen.

Mögliche spätere FOB-Support-Missionen:

- Cargo Delivery
- Engineering Support
- Convoy Escort
- Helicopter Lift
- FOB Defense
- Repair Support
- Fuel Delivery
- Ammo Delivery

Aktuelle Einschränkung:

    FOB-Support-Missionen sind state-only.
    Sie lösen noch keine CTLD-Cargo-Aktion aus.

---

## 16. CTLD-Rolle

CTLD ist das geplante Framework für echte Logistikinteraktion.

Aktuelle Vendor-Dateien:

    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua

CTLD ist aktuell:

    geladen
    vom Loader erkannt
    noch nicht produktiv angebunden

Geplante CTLD-Aufgaben:

- Cargo aufnehmen
- Cargo transportieren
- Cargo absetzen
- FOBs bauen
- FOBs versorgen
- Engineering-Crates transportieren
- Repair-Crates transportieren
- Supply-Crates transportieren
- Fuel-/Ammo-Logik vorbereiten
- Transporthelikopter einbinden

Aktuelle Einschränkung:

    Keine CTLD-Zonen im Mission Editor produktiv definiert.
    Keine CTLD-Crates produktiv definiert.
    Keine Theater-Command-CTLD-Brücke aktiv.

---

## 17. Warum CTLD noch nicht produktiv ist

CTLD wird bewusst noch nicht aktiv ausgelöst.

F10-/Debug-Sichtbarkeit für Logistik und FOBs ist bereits vorhanden und kein offener Blocker mehr.

Vor produktiver CTLD-Integration müssen insbesondere:

- Priority 3 Dirty-Coverage abgeschlossen werden
- Logistics-State-Mutationen sauber abgesichert sein
- CTLD-Zonen konkret geplant werden
- Theater-Command-State und CTLD-Runtime-State synchronisiert werden
- Persistenz-/Restore-Verhalten für CTLD geklärt werden
- kleine isolierte CTLD-Regressionen vorbereitet werden

Zusätzlich gilt weiterhin:

- echte Cargo-Aktionen erzeugen DCS-Nebenwirkungen
- DCS-Fehlerdiagnose wird mit echten Framework-Aktionen komplexer

Aktuelle Entscheidung:

    CTLD bleibt geladen und vorbereitet.
    Produktive CTLD-Integration folgt später.

---

## 18. Spätere CTLD-Zonen

Später im Mission Editor anzulegen:

- CTLD Pickup Zones
- CTLD Dropoff Zones
- FOB Build Zones
- FOB Supply Zones
- Forward Logistics Zones
- Helicopter Loading Zones
- Helicopter Unloading Zones

Mögliche Namenskonvention:

    CTLD_PICKUP_BLUE_AKROTIRI
    CTLD_DROPOFF_FOB_ERCAN
    CTLD_DROPOFF_FOB_GECITKALE
    CTLD_BUILD_FOB_ERCAN
    CTLD_BUILD_FOB_GECITKALE

Diese Namen sind noch nicht final.

Sie müssen später mit `NAMING_CONVENTIONS.md` und der CTLD-Konfiguration abgestimmt werden.

---

## 19. Spätere Cargo-Typen

Mögliche Theater-Command-Cargo-Typen:

- SUPPLY
- FUEL
- AMMO
- ENGINEERING
- REPAIR
- FOB_CORE
- FOB_DEFENSE
- FOB_COMMS
- FOB_MEDICAL
- FOB_AIR_DEFENSE

Diese Typen sind konzeptionell.

Sie sind noch nicht produktiv in CTLD umgesetzt.

Spätere Zuordnung:

- Cargo-Typ zu CTLD-Crate
- Gewicht
- Transportfähigkeit
- Baufortschritt
- Versorgungseffekt
- Persistenzwirkung

---

## 20. Logistik und Capture

Logistik soll später Capture beeinflussen.

Mögliche Logistik-Auswirkungen auf Capture:

- gut versorgte Zonen sind schwerer zu erobern
- unterversorgte Zonen verlieren Verteidigungsfähigkeit
- FOBs erhöhen Blue Capture Pressure
- Supply Delivery erhöht Capture Progress
- Engineering Delivery ermöglicht FOB-Aktivierung
- zerstörte Logistik senkt rote Reaktionsfähigkeit
- Interdiction kann rote Hubs schwächen

Aktueller Stand:

    CaptureSystem erzeugt Pressure- und Progress-Records.
    LogisticsDelivery erzeugt Hubs.
    FobSystem erzeugt FOBs.
    Eine produktive Logistik-Capture-Kopplung ist noch nicht aktiv.

Aktuell bestätigter Capture-Pfad (unabhängig von Logistik):

    Mission Completion -> Capture Pressure -> Capture Progress -> Capture Ready
    Mission Failure -> kein Capture Pressure
    Capture Ready Apply -> Ownership Update -> linked Airbase Sync -> Background Save

Nicht mehr aktuell: "Nächster logischer Zwischenschritt: Capture-/Pressure im F10 sichtbar machen" — das ist abgeschlossen.

Neuer technischer Zwischenschritt:

    READ-ONLY Dirty-Coverage-Audit von LogisticsDelivery.

---

## 21. Logistik und MissionGenerator

MissionGenerator nutzt Logistikdaten bereits teilweise.

Aktuelle Nutzung:

- Logistics Hubs als Missionsgrundlage
- FOBs als FOB-Support-Ziele
- FOB-Support-Kandidaten
- Reservierung mindestens einer FOB-Support-Mission

Aktuelle Werte:

    mission candidates: 78
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 68

MissionGenerator `v0.2.3`.

Bestätigt:

- Mission Details
- Mission Activation
- Mission Completion
- Mission Failure
- Mission Effects
- FOB Support Candidate Integration

Spätere Missionsarten aus Logistik:

- LOGISTICS
- FOB_SUPPORT
- CONVOY_ESCORT
- SUPPLY_INTERDICTION
- HELICOPTER_TRANSPORT
- BASE_REPAIR
- ENGINEERING_SUPPORT
- FUEL_DELIVERY
- AMMO_DELIVERY

Aktuelle Einschränkung:

    Missionen lösen noch keine echten Cargo-, Spawn- oder CTLD-Aktionen aus.

---

## 22. Logistik und AI

AI soll später Logistikdaten nutzen.

Mögliche AI-Entscheidungen:

- rote Hubs verteidigen
- blaue FOBs angreifen
- schwache Hubs priorisieren
- CAP über logistisch wichtigen Zonen anfordern
- Interdiction gegen Nachschubrouten planen
- Verstärkung zu bedrohten Hubs senden
- Rückzug bei Versorgungsausfall
- Gegenangriff auf aktive FOBs

Aktueller Stand:

    AICapManager v0.2.0, state-first, erzeugt CAP-State, 12 CAP Requests, keine echten CAP-Flüge.
    AI Director ist noch nicht implementiert.
    Logistik beeinflusst AI noch nicht produktiv.
    Keine autonome Hub-Verteidigung oder Interdiction ist aktiv.

---

## 23. Logistik und Persistenz

Logistics- und FOB-State sind bereits Teil des Persistence-Snapshots.

Zu speichern:

- Hub-ID
- Hub-Name
- Besitzer
- Status
- Supply
- Fuel
- Ammo
- Engineering
- Repair Capacity
- Linked Zone
- Linked Base
- Cargo Delivered
- Cargo Required
- FOB Links
- Delivery History
- Last Update
- Damage State

FOB-Persistenz:

- FOB-ID
- FOB-Name
- Besitzer
- Status
- Build Progress
- Supply
- Fuel
- Ammo
- Engineering
- Linked Hub
- Linked Zone
- CTLD Build State
- Active Facilities
- Damage State

PersistenceSystem `v0.2.6`:

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

Klarstellung: Das Speichern ist aktiv.

Nicht aktiv:

- produktiver Startup-Restore
- CTLD-Runtime-State Restore
- produktive Kampagnenfortsetzung aus Save

Vor Restore zu klären:

- Priority 3 abschließen
- Restore-/Init-Reihenfolge definieren
- Save-Kompatibilität/Versionierung
- kontrollierter Restore-Test
- Framework-Hooks absichern

Wichtig: Die allgemeine Dirty-Coverage von LogisticsDelivery und FobSystem ist noch offen. Genau deshalb ist produktiver Restore noch nicht freigegeben.

---

## 24. F10-Status für Logistik

F10Menu `v0.2.3` kann aktuell Logistikstatus und FOB-Status anzeigen.

Aktuelle F10-Funktionen im Bereich Logistik:

    Show Logistics Status
    Show FOB Status

Bestätigt:

    F10Menu ist sichtbar.
    F10Menu ist navigierbar.
    F10Menu v0.2.3 erzeugt 33 Commands.
    Missionen können angezeigt und aktiviert werden.
    Logistik- und FOB-Status sind Bestandteil der UI-Struktur.
    Capture-/Pressure-Sichtbarkeit ist zusätzlich bereits vorhanden.

Spätere F10-Erweiterungen für Logistik:

- Show Logistics Hubs
- Show Blue Logistics Hubs
- Show Red Logistics Hubs
- Show FOB Construction
- Show FOB Supply
- Show Cargo Requests
- Show Delivery Queue
- Request FOB Support
- Request Cargo Mission

Nicht mehr aktuell: "nächster F10-Schritt: Capture-/Pressure-Status sichtbar machen" — das ist abgeschlossen.

Logistics-spezifische weitere F10-Ausgaben (siehe Liste oben) bleiben Zukunftsideen.

---

## 25. Nicht-Ziele des aktuellen Logistiksystems

Aktuell nicht vorgesehen:

- CTLD direkt aus LogisticsDelivery produktiv auslösen
- echte Crates automatisch spawnen
- echte Cargo-Flüge starten
- echte FOBs im DCS-Sinn bauen
- Supply-Verbrauch automatisch berechnen
- rote Logistik automatisch bewegen
- Blue-Logistik automatisch bewegen
- AI-Director-Entscheidungen aus Logistik ableiten

Nicht mehr "komplett fehlend": Logistics-/FOB-State wird bereits gespeichert. Weiterhin nicht vorhanden:

- kein produktiver Startup-Restore
- kein CTLD-Runtime-State Restore

Grund:

    Die State-Grundlage ist zuerst aufgebaut worden.
    Produktive Framework-Aktionen folgen später.

---

## 26. Risiken

Wichtige Risiken bei späterer Logistikintegration:

- CTLD-Konfiguration ist empfindlich gegenüber Zonen- und Gruppenbenennung
- falsche Zonen führen zu nicht funktionierenden Cargo-Aktionen
- echte CTLD-FOBs können schwer zu debuggen sein
- Cargo-Zustand und Theater-Command-State müssen synchron bleiben
- Multiplayer-Verhalten muss später separat geprüft werden
- Persistenz muss sauber mit CTLD-Zustand umgehen
- DCS-Sandbox kann Dateizugriffe einschränken

Aktuelles Risiko: Die Dirty-Coverage muss vor produktiver Logistics-/Restore-Integration vollständig geprüft werden. Kernrisiko ist eine fachliche State-Mutation ohne Dirty oder ein unnötiger Dirty bei Reads/No-Ops. Vor dem Audit wird kein konkreter Bug behauptet.

Gegenmaßnahmen:

- CTLD erst nach stabiler State- und UI-Schicht aktivieren
- Mission-Editor-Zonen klar benennen
- kleine Einzeltests durchführen
- Logausgaben pro Cargo-Aktion erzeugen
- State-Dumps vorbereiten
- keine großen CTLD-Schritte parallel bauen

---

## 27. Aktuelle Akzeptanzkriterien für das Logistiksystem

Aktuell bestanden:

- LogisticsDelivery lädt.
- LogisticsDelivery startet.
- 46 Logistics Hubs werden erzeugt.
- Hub-Verteilung wird geloggt.
- FobSystem lädt.
- FobSystem startet.
- 6 FOB-Kandidaten werden erkannt.
- 2 Blue-FOBs werden state-only erzeugt.
- FOBs stehen auf UNDER_CONSTRUCTION.
- MissionGenerator erkennt 2 FOB-Support-Kandidaten.
- mindestens eine FOB-Support-Mission wird reserviert.
- keine CTLD-Fehler durch Theater Command.
- keine Lua-Stacktraces.
- Logistics-/FOB-State wird vom Persistence Snapshot erfasst.
- F10 Logistics-/FOB-Status vorhanden.

Noch offen:

- LogisticsDelivery Dirty-Coverage Audit
- FobSystem Dirty-Coverage Audit
- CTLD-Zonen definieren
- CTLD-Cargo produktiv anbinden
- FOB-Baufortschritt durch Cargo verändern (Cargo -> FOB Build Progress)
- Logistik mit Capture koppeln
- Logistik mit AI koppeln
- produktiver Restore

Nicht mehr aktuell: "Logistik persistieren" als pauschal offener Punkt.

---

## 28. Aktueller getesteter Systemstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | state-first funktional bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | funktional bestanden; Read-Dirty-/Ownership-No-Op-Regressionen bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | Embedded Start, `SAVED`, `SKIPPED`, `FAILED`, Retry und Campaign-Persistence-Regressionen bestanden; `productiveRestore=false` |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | funktional bestanden; Dirty-Coverage ist nächster Priority-3-Audit |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | funktional bestanden; Dirty-Coverage offen |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | 10 Mission Records; Activation/Completion/Failure/Effects bestanden; Record-Loss widerlegt; Dirty-Coverage offen |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | state-first bestanden; `reactToActiveMissions()`-Sonderfall bewertet; Dirty-Coverage offen |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden; 33 Commands |

Priority 3 ist **NICHT abgeschlossen**. Bereits geklärt: Capture Getter-/Derived-Dirty, Capture Ownership No-Op, `reactToActiveMissions()`-Sonderfall. Noch systematisch zu prüfen, jeweils einzeln:

1. `src/logistics/tc_logistics_delivery.lua`
2. `src/logistics/tc_fob_system.lua`
3. `src/missions/tc_mission_generator.lua`
4. `src/ai/tc_ai_cap_manager.lua`

Nächster Schritt ist exakt `src/logistics/tc_logistics_delivery.lua`, READ ONLY. Noch kein Code-Fix vor Audit.

Offline Embedded Resource Audit: abgeschlossen. DEV und MCP_TEST waren beim Audit byte-identisch. 13/13 relevante aktive Theater-Command-Ressourcen waren `EXACT_MATCH`. Keine aktive Embedded-Runtime-Drift. Die aktive LogisticsDelivery-/FobSystem-Runtime entsprach damit zum Auditzeitpunkt dem Repository. Das bedeutet nicht, dass spätere Source-Änderungen automatisch in der `.miz` landen.

---

## 29. Nächster sinnvoller Schritt aus Sicht des Logistiksystems

Nicht mehr aktuell: `src/ui/tc_f10_menu.lua` / Capture-/Pressure-Sichtbarkeit als nächster Schritt — das ist abgeschlossen.

Neuer nächster technischer Schritt:

    Priority 3
    READ-ONLY Dirty-Coverage-Audit von src/logistics/tc_logistics_delivery.lua

Audit-Ziele:

- alle persistierten Logistics-State-Writes erfassen
- alle `markDirty()`-Pfade erfassen
- Call-Sites erfassen
- echte Mutationen identifizieren
- Reads/No-Ops identifizieren
- Timestamp-/Table-Rewrites prüfen
- Dirty Reasons bewerten
- runtime-only vs. persistierten State unterscheiden
- Missing Dirty klassifizieren
- Excessive Dirty klassifizieren

Keine Codeänderung ohne belegten Befund.

Nur LogisticsDelivery. FobSystem wird NICHT parallel auditiert.

---

## 30. Aktueller Status

Das Logistiksystem bleibt bestanden und stabil für den state-first Entwicklungsstand.

Aktuelle Fähigkeit:

- 46 Logistics Hubs (7 Blue, 24 Red, 15 Neutral, 31 Active, 15 Limited, 0 Locked)
- 6 FOB-Kandidaten
- 2 Blue-FOBs (FOB Ercan, FOB Gecitkale)
- FOBs stehen auf UNDER_CONSTRUCTION
- 2 FOB-Support-Kandidaten
- reservierte FOB-Support-Mission
- F10 Logistics Status
- F10 FOB Status
- Logistics-/FOB-State im Persistence Snapshot
- CTLD geladen und vorbereitet

Weiterhin nicht produktiv:

- echte CTLD-Crates
- echte CTLD-FOBs
- echter Cargo-Fluss
- Supply-Verbrauch
- Logistics -> Capture
- Logistics -> AI
- produktiver Startup-Restore

Nächster Schritt:

    LogisticsDelivery Dirty-Coverage READ ONLY.
