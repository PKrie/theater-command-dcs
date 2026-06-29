# Logistics System

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
- Persistenz
- CTLD-Cargo-Flüge

Aktuell ist das System bewusst state-first aufgebaut.

Das bedeutet:

    Logistikdaten werden im Theater-Command-State erzeugt.
    Es werden noch keine echten CTLD-Aktionen ausgelöst.

---

## 2. Aktueller technischer Stand

Stand:

    2026-06-29

Aktive Dateien:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

Getestete Versionen:

    LogisticsDelivery: v0.2.0
    FobSystem: v0.2.0

Status:

    bestanden

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
- keine produktive Persistenz

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

Bedeutung:

    FOB-Support wird im Missionspool berücksichtigt.
    Mindestens eine FOB-Support-Mission wird reserviert.
    FOB-Support wird nicht durch andere Missionstypen verdrängt.

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

Gründe:

- zuerst müssen Logistics Hubs stabil sein
- zuerst muss FOB-State stabil sein
- zuerst muss F10-/Debug-Sichtbarkeit vorhanden sein
- zuerst müssen CTLD-Zonen im Mission Editor sauber definiert werden
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

Nächster logischer Zwischenschritt:

    Capture-/Pressure-Daten im F10-Menü sichtbar machen.

---

## 21. Logistik und MissionGenerator

MissionGenerator nutzt Logistikdaten bereits teilweise.

Aktuelle Nutzung:

- Logistics Hubs als Missionsgrundlage
- FOBs als FOB-Support-Ziele
- FOB-Support-Kandidaten
- Reservierung mindestens einer FOB-Support-Mission

Aktuelle Werte:

    mission candidates: 69
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1

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

    AICapManager erzeugt CAP-State.
    AI Director ist noch nicht implementiert.
    Logistik beeinflusst AI noch nicht produktiv.

---

## 23. Logistik und Persistenz

Logistik muss später persistent werden.

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

Aktueller Stand:

    PersistenceSystem-Grundstruktur existiert.
    Produktiver Dateischreibtest ist offen.

---

## 24. F10-Status für Logistik

F10Menu `v0.2.0` kann aktuell Logistikstatus und FOB-Status anzeigen.

Aktuelle F10-Funktionen im Bereich Logistik:

    Show Logistics Status
    Show FOB Status

Bestätigt:

    F10Menu ist sichtbar.
    F10Menu ist navigierbar.
    F10Menu erzeugt 26 Commands.
    Missionen können angezeigt und aktiviert werden.
    Logistik- und FOB-Status sind Bestandteil der UI-Struktur.

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

Aktuell nächster F10-Schritt:

    nicht Logistics, sondern Capture-/Pressure-Status sichtbar machen.

Grund:

    CaptureSystem v0.2.1 erzeugt neue Pressure-/Progress-Daten, die vor Missionseffekt-Tests sichtbar sein müssen.

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
- Logistik persistieren

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

Noch offen:

- CTLD-Zonen definieren
- CTLD-Cargo produktiv anbinden
- FOB-Baufortschritt durch Cargo verändern
- Logistik mit Capture koppeln
- Logistik mit AI koppeln
- Logistik persistieren

---

## 28. Aktueller getesteter Systemstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.1` | bestanden |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.2` | bestanden |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.0` | bestanden |

---

## 29. Nächster sinnvoller Schritt aus Sicht des Logistiksystems

Der nächste technische Schritt liegt nicht direkt in `src/logistics/`.

Empfohlene nächste Datei:

    src/ui/tc_f10_menu.lua

Ziel:

    Capture-/Pressure-Status im F10-Menü sichtbar machen.

Warum:

    Logistics und FOBs sind state-first stabil.
    MissionGenerator nutzt FOB-Support bereits.
    CaptureSystem erzeugt jetzt Pressure- und Progress-Daten.
    Vor echter Logistik-Capture-Kopplung müssen diese Daten sichtbar werden.

Akzeptanzkriterien:

- F10Menu lädt als neue Version.
- bisherige 26 Commands bleiben funktionsfähig.
- neue Capture-Commands werden ergänzt.
- Capture Status zeigt mindestens:
  - eligibleBases
  - eligibleZones
  - pressureRecords
  - progressRecords
  - captureReady
  - pressureContested
  - appliedMissionEffects
- keine echten Spawns
- keine CTLD-Aktion
- keine Skynet-Aktion
- keine Lua-Fehler
- keine Theater-Command-Fehler

---

## 30. Aktueller Status

Das Logistiksystem ist für den aktuellen state-first Entwicklungsstand bestanden.

Aktuelle Fähigkeit:

- 46 Logistics Hubs werden erzeugt.
- 6 FOB-Kandidaten werden erkannt.
- 2 Blue-FOBs werden geplant.
- FOBs stehen auf UNDER_CONSTRUCTION.
- FOB-Support wird im MissionGenerator berücksichtigt.
- F10Menu kann Logistics- und FOB-Status anzeigen.
- CTLD ist geladen und vorbereitet.

Noch nicht vorhanden:

- produktive CTLD-Anbindung
- echte CTLD-Crates
- echte CTLD-FOBs
- echter Cargo-Fluss
- Logistikverbrauch
- Logistik-Persistenz

Nächster sinnvoller Schritt:

    Capture-/Pressure-Sichtbarkeit im F10-Menü.
