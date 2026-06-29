# src/logistics/README.md

Diese Datei beschreibt den Logistics-Bereich von **Theater Command DCS**.

Der Logistics-Bereich enthält eigene Lua-Logik für Versorgung, Logistics Hubs, FOB-Kandidaten, FOB-Aufbau und spätere CTLD-Anbindung.

---

## 1. Zweck des Logistics-Bereichs

`src/logistics/` ist für die logistische Kampagnenebene zuständig.

Langfristig soll dieser Bereich ermöglichen, dass Versorgung, FOB-Aufbau und Transportmissionen echte strategische Bedeutung haben.

Logistik soll später Einfluss haben auf:

- Capture-Pressure
- Capture-Progress
- FOB-Aufbau
- FOB-Versorgung
- Missionsverfügbarkeit
- Operationsradius
- AI-Entscheidungen
- IADS-Reparatur
- Ressourcenlage
- Persistenz

Aktuell ist der Logistics-Bereich nicht mehr nur geplant.

LogisticsDelivery und FobSystem sind aktiv und getestet.

---

## 2. Kampagnenkontext

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

Grundannahme:

    Akrotiri ist initial der wichtigste blaue Logistikhub.
    Zypern ist initial sicherer blauer Ausgangsraum.
    Syrische Festlandzonen sind initial rot oder neutral.
    Blue muss Logistik und FOBs nutzen, um dauerhaft auf das Festland zu wirken.

---

## 3. Aktueller technischer Stand

Stand:

    2026-06-29

Aktive Dateien:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

Getesteter Stand:

    LogisticsDelivery: v0.2.0 bestanden
    FobSystem: v0.2.0 bestanden

Bestätigt durch DCS-Logtests:

- LogisticsDelivery lädt.
- LogisticsDelivery startet.
- LogisticsDelivery erzeugt Logistics Hubs.
- LogisticsDelivery erzeugt Hub-Status.
- FobSystem lädt.
- FobSystem startet.
- FobSystem erkennt FOB-Kandidaten.
- FobSystem plant Blue-FOBs state-only.
- MissionGenerator erkennt FOB-Support-Kandidaten.
- F10Menu zeigt Logistics Status.
- F10Menu zeigt FOB Status.
- Es gab keinen Theater-Command-Lua-Fehler.
- Es gab keinen Lua-Stacktrace.

---

## 4. Aktuelle bestätigte Logistics-Werte

LogisticsDelivery v0.2.0:

    logistics hubs: 46
    blue hubs: 7
    red hubs: 24
    neutral hubs: 15
    active hubs: 31
    limited hubs: 15
    locked hubs: 0

Bewertung:

    LogisticsDelivery arbeitet auf den 46 relevanten Kampagnenzonen.
    LogisticsDelivery arbeitet nicht auf allen 225 DCS-Airbase-like Objects.
    CTLD ist geladen, aber noch nicht produktiv angebunden.
    Logistics Hubs sind aktuell state-only.

---

## 5. Aktuelle bestätigte FOB-Werte

FobSystem v0.2.0:

    FOB candidates: 6
    stored candidates: 6
    auto-planned FOBs: 2
    skipped candidates: 4
    Blue FOBs: 2

Erzeugte Blue-FOBs:

    FOB Ercan
    FOB Gecitkale

Aktueller Status:

    UNDER_CONSTRUCTION

Bewertung:

    FobSystem ist state-first bestanden.
    FOBs existieren im Theater-Command-State.
    Es werden noch keine echten CTLD-FOBs erzeugt.
    MissionGenerator erkennt die FOBs bereits als FOB-Support-Kandidaten.

---

## 6. Architekturregel

Externe Frameworks liegen unter:

    vendor/

Eigene Theater-Command-Logik liegt unter:

    src/

Der Logistics-Bereich gehört zur eigenen Theater-Command-Logik.

Frameworks werden nicht verändert.

Dateien in `src/logistics/` werden nach Theater-Command-Aufgaben benannt, nicht nach Frameworks.

Nicht gewünscht:

    src/logistics/tc_ctld.lua
    src/logistics/tc_moose_logistics.lua
    src/logistics/tc_logistics_all_in_one.lua
    src/logistics/tc_ctld_all_in_one.lua

Gewünscht:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

Eine Logistics-Datei darf später intern CTLD, MIST, MOOSE oder DCS-API nutzen.

Der Dateiname richtet sich aber immer nach der Theater-Command-Aufgabe.

---

## 7. Aktive Dateien

Aktuell aktive Dateien:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

`tc_logistics_delivery.lua`:

    aktives Logistics-Hub-Modul
    Version v0.2.0
    bestanden

`tc_fob_system.lua`:

    aktives FOB-State-Modul
    Version v0.2.0
    bestanden

Mögliche spätere Dateien:

    src/logistics/tc_logistics_hub.lua
    src/logistics/tc_supply_network.lua
    src/logistics/tc_convoy_delivery.lua
    src/logistics/tc_ctld_bridge.lua

Diese Zusatzdateien werden erst angelegt, wenn sie wirklich benötigt werden.

---

## 8. LogisticsDelivery

Datei:

    src/logistics/tc_logistics_delivery.lua

Getestete Version:

    v0.2.0

Status:

    bestanden

Aktuelle Aufgaben:

- Logistics Hubs aus Kampagnenzonen ableiten
- Hub-Besitzer bestimmen
- Hub-Status bestimmen
- Blue Hubs zählen
- Red Hubs zählen
- Neutral Hubs zählen
- Active Hubs zählen
- Limited Hubs zählen
- Locked Hubs zählen
- State für F10 und spätere Missionen bereitstellen
- CTLD-Anbindung vorbereiten

Wichtig:

    LogisticsDelivery führt aktuell keine echten CTLD-Aktionen aus.
    LogisticsDelivery erzeugt state-only Logistics Hubs.
    LogisticsDelivery verändert keinen Besitzstatus direkt.
    LogisticsDelivery erzeugt keine Zonen selbst.

---

## 9. Logistics Hubs

Logistics Hubs sind die logistischen Knoten der Kampagne.

Ein Logistics Hub kann später enthalten:

- Besitzer
- Status
- Supply
- Fuel
- Ammo
- Engineering
- Repair Capacity
- Cargo Demand
- Cargo Delivered
- Linked Zone
- Linked Base
- CTLD Pickup Capability
- CTLD Dropoff Capability
- FOB Support Capability

Aktuell bestätigt:

    46 Logistics Hubs

Hub-Verteilung:

    blue hubs: 7
    red hubs: 24
    neutral hubs: 15

Hub-Status:

    active hubs: 31
    limited hubs: 15
    locked hubs: 0

---

## 10. Hub-Status

Aktuelle Statuswerte:

    ACTIVE
    LIMITED
    LOCKED

Bedeutung:

`ACTIVE`:

    Hub ist grundsätzlich nutzbar.

`LIMITED`:

    Hub ist eingeschränkt oder noch nicht voll nutzbar.

`LOCKED`:

    Hub ist nicht nutzbar.

Aktueller Stand:

    Statuswerte sind state-only.
    Sie haben noch keine produktive CTLD- oder Capture-Wirkung.

Spätere Wirkung:

- nur aktive Hubs können Supply senden
- limited Hubs haben reduzierte Wirkung
- locked Hubs erzeugen keine Logistikmissionen
- Hub-Status beeinflusst FOB-Aufbau
- Hub-Status beeinflusst MissionGenerator
- Hub-Status beeinflusst AI Director
- Hub-Status beeinflusst Persistenz

---

## 11. FobSystem

Datei:

    src/logistics/tc_fob_system.lua

Getestete Version:

    v0.2.0

Status:

    bestanden

Aktuelle Aufgaben:

- FOB-Kandidaten aus Logistics Hubs ableiten
- geeignete Blue-FOBs state-only planen
- FOB-State erzeugen
- FOB-Status setzen
- FOB-Support-Daten für MissionGenerator bereitstellen
- spätere CTLD-FOB-Anbindung vorbereiten

Wichtig:

    FobSystem erzeugt aktuell keine echten CTLD-FOBs.
    FobSystem spawnt keine DCS-Objekte.
    FobSystem arbeitet state-only.

---

## 12. FOB Candidates

Aktuell bestätigt:

    FOB candidates: 6
    stored candidates: 6
    skipped candidates: 4

Mögliche Kriterien:

- geeigneter Logistics Hub
- geeignete Zone
- geeigneter Besitzerstatus
- sinnvolle Position für Blue
- operative Nähe zum Festland
- möglicher Nutzen für Capture oder Missionen
- später CTLD-/Landeplatz-Eignung

Aktuell:

    FOB Candidates werden state-only erzeugt.
    Mission Editor-Zonen sind noch nicht produktiv angebunden.

---

## 13. Blue FOBs

Aktuell bestätigt:

    Blue FOBs: 2

Erzeugte FOBs:

    FOB Ercan
    FOB Gecitkale

Status:

    UNDER_CONSTRUCTION

Bedeutung:

    Blue besitzt zwei state-only FOB-Projekte.
    Diese FOBs sind noch nicht aktiv.
    Diese FOBs benötigen später Versorgung, Engineering oder Missionserfolge.
    MissionGenerator erkennt sie bereits als FOB-Support-Ziele.

---

## 14. FOB-Status

Aktueller Status:

    UNDER_CONSTRUCTION

Mögliche spätere Statuswerte:

- PLANNED
- UNDER_CONSTRUCTION
- ACTIVE
- DAMAGED
- SUPPLY_LOW
- OUT_OF_SUPPLY
- ABANDONED
- DESTROYED

Aktuelle Bedeutung:

    FOB existiert als Kampagnen-State.
    FOB ist noch nicht produktiv einsatzbereit.
    FOB ist noch kein echtes CTLD-FOB.

---

## 15. Beziehung zu CTLD

CTLD liegt extern unter:

    vendor/ctld/

CTLD wird nicht verändert.

Theater Command nutzt CTLD später als Transport- und Logistikframework.

Geplante CTLD-Rollen:

- Cargo aufnehmen
- Cargo transportieren
- Cargo absetzen
- Crates erzeugen
- FOBs bauen
- FOBs versorgen
- Engineering liefern
- Repair liefern
- Supply liefern
- Fuel/Ammo später abbilden

Aktueller Stand:

    CTLD wird geladen.
    LogisticsDelivery ruft CTLD noch nicht produktiv auf.
    FobSystem ruft CTLD noch nicht produktiv auf.
    Es gibt noch keine echten CTLD-Cargo-Operationen.

---

## 16. Warum CTLD noch nicht produktiv ist

CTLD wird bewusst noch nicht produktiv ausgelöst.

Gründe:

- Logistics Hubs mussten zuerst stabil erzeugt werden.
- FOB-State musste zuerst stabil erzeugt werden.
- MissionGenerator musste FOB-Support erkennen.
- F10Menu musste Logistics und FOB Status anzeigen.
- CTLD-Zonen im Mission Editor sind noch nicht produktiv definiert.
- echte CTLD-Aktionen erzeugen DCS-Nebenwirkungen.
- Fehlerdiagnose mit echten Cargo-Objekten ist komplexer.

Aktuelle Entscheidung:

    CTLD bleibt geladen und vorbereitet.
    Produktive CTLD-Integration folgt später.

---

## 17. Verhältnis zum Core

`src/logistics/` nutzt den Core.

Erlaubte Core-Abhängigkeiten:

- `TC.Config`
- `TC.Logger`
- `TC.State`
- `TC.Utils`
- `TC.Scheduler`

Der Logistics-Bereich darf davon ausgehen, dass der Core bereits geladen ist.

Aktuelle Ladeposition:

    nach Core, World und Campaign
    vor Missions, AI, UI, Main und Loader

---

## 18. Verhältnis zum World-Bereich

Der Logistics-Bereich nutzt Daten aus:

    src/world/

Besonders wichtig:

- `TC.World.AirbaseScanner`
- `TC.World.ZoneFactory`
- `TC.State.Bases`
- `TC.State.Zones`

Aktuelle World-Werte:

    Syria airbase-like objects: 225
    relevante Kampagnenzonen: 46
    logisticsCandidates: 46

Logistics nutzt diese Daten für:

- Logistics Hubs
- Hub Owner
- Hub Status
- FOB Candidates
- spätere Cargo-Zielräume

Logistics soll nicht selbst Airbases scannen.

Logistics soll nicht selbst Kampagnenzonen erzeugen.

---

## 19. Verhältnis zum Campaign-Bereich

Der Logistics-Bereich soll später Campaign-Daten beeinflussen.

Aktuelle Capture-Werte:

    eligibleBases: 32
    eligibleZones: 32
    pressureRecords: 32
    progressRecords: 32
    appliedMissionEffects: 0
    ready: 0
    contested: 0

Mögliche spätere Kopplung:

- FOB-Support erhöht Capture-Pressure.
- Logistics Support erhöht Capture-Progress.
- Supply-Mangel senkt Verteidigungsfähigkeit.
- Engineering ermöglicht FOB-Aktivierung.
- Logistics Hubs können Capture-Bedingung sein.
- zerstörte Hubs können Fortschritt bremsen.

Aktuell:

    Logistics und Capture sind noch nicht produktiv gekoppelt.
    Mission Effects auf Capture sind noch nicht aktiv.
    Capture-/Pressure-Sichtbarkeit im F10 ist der nächste Zwischenschritt.

---

## 20. Verhältnis zum Missionsbereich

MissionGenerator nutzt Logistics- und FOB-Daten bereits.

Aktuelle MissionGenerator-Datei:

    src/missions/tc_mission_generator.lua

Getestete Version:

    v0.2.2

Aktuelle MissionGenerator-Werte:

    mission candidates: 69
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 30

Aktuelle Kopplung:

    MissionGenerator erkennt 2 FOB-Support-Kandidaten.
    MissionGenerator reserviert mindestens eine FOB-Support-Mission.

Spätere Missionstypen aus Logistik:

- LOGISTICS
- FOB_SUPPORT
- CARGO_DELIVERY
- ENGINEERING_SUPPORT
- REPAIR_SUPPORT
- FUEL_DELIVERY
- AMMO_DELIVERY
- CONVOY_ESCORT
- SUPPLY_INTERDICTION

Aktuell:

    Missionen bleiben state-only.
    Es werden keine echten CTLD-Cargo-Aktionen ausgelöst.

---

## 21. Verhältnis zum AI-Bereich

AI soll später Logistics-Daten nutzen.

Aktuelle AI-Datei:

    src/ai/tc_ai_cap_manager.lua

Getestete Version:

    v0.2.0

Aktuelle AI-Werte:

    cap zone candidates: 31
    auto-registered CAP zones: 12
    CAP requests: 12
    reactionState: AIR_REACTION_REQUESTED
    threatLevel: HIGH

Spätere AI-Nutzung:

- FOBs schützen
- FOBs angreifen
- Supply Push priorisieren
- Logistics Hubs verteidigen
- Red Logistics Interdiction planen
- CAP über Logistikkorridoren anfordern
- Blue-/Red-Operationsfähigkeit aus Versorgung ableiten

Aktuell:

    AI Director ist noch nicht implementiert.
    Logistics beeinflusst AI noch nicht produktiv.

---

## 22. Verhältnis zum IADS-Bereich

IADS soll später Logistics-Daten nutzen.

Aktueller IADS-Stand:

    Skynet IADS wird geladen.
    eigenes Theater-Command-IADS-Modul ist noch nicht implementiert.
    MissionGenerator reserviert Skynet-Hooks.

Spätere IADS-Nutzung:

- SAM-Sites benötigen Supply oder Repair.
- beschädigte IADS-Sites brauchen Engineering.
- Red Logistics beeinflusst IADS-Reparaturfähigkeit.
- Blue Logistics ermöglicht SEAD-/DEAD-Operationsdruck.
- FOBs erweitern Reichweite gegen IADS-Ziele.

Aktuell:

    IADS ist noch nicht mit Logistics gekoppelt.

---

## 23. Verhältnis zum UI-Bereich

F10Menu zeigt Logistics- und FOB-Status bereits an.

Aktive UI-Datei:

    src/ui/tc_f10_menu.lua

Getestete Version:

    v0.2.0

Aktuelle F10-Funktionen:

    Show Logistics Status
    Show FOB Status

F10Menu zeigt außerdem:

- verfügbare Missionen
- aktive Missionen
- Missionsdetails
- Mission Activation
- Campaign Status
- AI CAP Status

Bewertung:

    Logistics und FOBs sind bereits über F10 sichtbar.
    Die Darstellung kann später erweitert werden.
    Nächster F10-Ausbau ist Capture-/Pressure-Sichtbarkeit.

---

## 24. Verhältnis zu Persistence

Persistence soll später Logistics und FOBs speichern.

Aktuelle Persistence-Datei:

    src/campaign/tc_persistence_system.lua

Status:

    Grundstruktur lädt/startet
    produktiver Dateischreibtest offen

Zu speichernde Logistics-Daten:

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
- Delivery History
- Cargo Required
- Cargo Delivered

Zu speichernde FOB-Daten:

- FOB-ID
- FOB-Name
- Besitzer
- Status
- Build Progress
- Linked Hub
- Linked Zone
- Supply
- Fuel
- Ammo
- Engineering
- Cargo Delivered
- Cargo Required
- Damage State

Aktuell:

    keine produktive Logistics-Persistenz
    keine produktive FOB-Persistenz
    kein DCS-Dateischreibtest

---

## 25. State-first-Regel

Der Logistics-Bereich folgt aktuell strikt der state-first-Architektur.

Das bedeutet:

- Logistics Hubs werden im State erzeugt.
- FOBs werden im State erzeugt.
- F10 zeigt Logistics-/FOB-State.
- MissionGenerator nutzt FOB-State.
- CTLD-Hooks bleiben vorbereitet.
- echte CTLD-Aktionen bleiben deaktiviert.

Nicht aktiv:

- echte CTLD-Crates
- echte CTLD-FOBs
- echte Cargo-Flüge
- echter Supply-Verbrauch
- echte FOB-Aktivierung
- automatische Capture-Wirkung
- Logistics-Persistenz

Grund:

    Logistik erzeugt viele DCS-Nebenwirkungen.
    Vor echter CTLD-Anbindung müssen State und UI stabil sein.

---

## 26. Geplanter Namespace

Der Logistics-Bereich nutzt den zentralen Theater-Command-Namespace:

    TC.Logistics

Aktuelle oder geplante Unterbereiche:

    TC.Logistics.Delivery
    TC.Logistics.FobSystem
    TC.State.Logistics
    TC.State.Logistics.Hubs
    TC.State.Logistics.FOBs
    TC.State.Logistics.Deliveries

Nicht verwenden:

    TheaterCommandLogistics
    LogisticsTC
    tc_logistics_global
    _G_TC_LOGISTICS

---

## 27. Testziele

LogisticsDelivery v0.2.0 gilt aktuell als bestanden, wenn:

- Datei lädt.
- Version wird im Log angezeigt.
- LogisticsDelivery startet.
- 46 Logistics Hubs erzeugt werden.
- 7 Blue Hubs erkannt werden.
- 24 Red Hubs erkannt werden.
- 15 Neutral Hubs erkannt werden.
- 31 Active Hubs erkannt werden.
- 15 Limited Hubs erkannt werden.
- 0 Locked Hubs erkannt werden.
- keine CTLD-Aktionen ausgelöst werden.
- keine Theater-Command-Lua-Fehler auftreten.
- keine Lua-Stacktraces auftreten.

FobSystem v0.2.0 gilt aktuell als bestanden, wenn:

- Datei lädt.
- Version wird im Log angezeigt.
- FobSystem startet.
- 6 FOB-Kandidaten erkannt werden.
- 2 Blue-FOBs erzeugt werden.
- FOB Ercan erzeugt wird.
- FOB Gecitkale erzeugt wird.
- FOBs auf UNDER_CONSTRUCTION stehen.
- MissionGenerator FOB-Support erkennt.
- keine echten CTLD-FOBs erzeugt werden.
- keine Theater-Command-Lua-Fehler auftreten.
- keine Lua-Stacktraces auftreten.

---

## 28. Erwartete Logmarker

Aktuelle erwartete Logistics-Logmarker:

    [TC] [LogisticsDelivery] Loaded src/logistics/tc_logistics_delivery.lua v0.2.0
    [TC] [LogisticsDelivery] Logistics hubs summary:
    [TC] [LogisticsDelivery] Logistics hubs created:
    [TC] System started: Logistics Delivery

Aktuelle erwartete FOB-Logmarker:

    [TC] [FobSystem] Loaded src/logistics/tc_fob_system.lua v0.2.0
    [TC] [FobSystem] FOB candidates:
    [TC] [FobSystem] Blue FOBs:
    [TC] [FobSystem] FOB planned:
    [TC] System started: FOB System

Zusätzlich über MissionGenerator:

    [TC] [MissionGenerator] Mission candidate summary: candidates=69, fobSupportCandidates=2, availableBefore=0, generationSlots=10
    [TC] [MissionGenerator] Mission generation completed: 10 new missions from 69 candidates (fobSupportCandidates=2, reservedCreated=1, duplicatesSkipped=1, typeLimitSkipped=30)

Der genaue Wortlaut einzelner Summary-Logs kann je nach Implementierung variieren.

Wichtig ist:

    Version korrekt.
    Werte korrekt.
    keine echten CTLD-Aktionen.
    keine Fehler.

---

## 29. Abgrenzung

Nicht Aufgabe von `src/logistics/`:

- Airbases aus DCS auslesen
- Zonen geometrisch erzeugen
- strategischen Besitz direkt festlegen
- Missionen generieren
- Missionen im F10 anzeigen
- CAPs starten
- IADS-Netzwerke aufbauen
- Save-Dateien schreiben
- Debug-Zeichnungen erzeugen
- Vendor-Dateien verändern

Diese Aufgaben gehören in andere Bereiche.

Logistics verwaltet Versorgung, Logistics Hubs, FOBs und spätere Lieferungen.

---

## 30. Nächster sinnvoller Schritt

Der nächste sinnvolle Schritt liegt nicht direkt im Logistics-Bereich.

Empfohlene nächste Datei:

    src/ui/tc_f10_menu.lua

Ziel:

    Capture-/Pressure-Status im F10-Menü sichtbar machen.

Geplante neue F10-Funktionen:

    Show Capture Status
    Show Capture Ready Zones
    Show Pressure Contested Zones

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
- Capture Ready Zones können angezeigt werden.
- Pressure Contested Zones können angezeigt werden.
- keine echten Spawns
- keine CTLD-Aktion
- keine Skynet-Aktion
- keine Lua-Fehler
- keine Theater-Command-Fehler

---

## 31. Zielbild

`src/logistics/` ist die Versorgungsschicht von Theater Command DCS.

Der Logistics-Bereich verbindet:

- World-Daten
- Campaign-State
- Missionsergebnisse
- FOB-Aufbau
- CTLD
- AI
- IADS
- Persistenz
- UI

Aktueller Status:

    LogisticsDelivery v0.2.0 ist state-first bestanden.
    FobSystem v0.2.0 ist state-first bestanden.
    Logistics Status ist über F10 sichtbar.
    FOB Status ist über F10 sichtbar.
    echte CTLD-Aktionen folgen später.

Nächster notwendiger Zwischenschritt im Gesamtprojekt:

    F10Menu v0.2.1 mit Capture-/Pressure-Sichtbarkeit.
