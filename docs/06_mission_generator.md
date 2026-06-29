# Mission Generator

Diese Datei beschreibt den Mission Generator von **Theater Command DCS**.

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## 1. Zweck des Mission Generators

Der Mission Generator erzeugt Missionen aus dem aktuellen Kampagnenzustand.

Er soll langfristig verhindern, dass Missionen statisch und unabhängig von der Lage entstehen.

Missionen sollen abhängig sein von:

- Airbase-Klassifizierung
- Zonenstatus
- Capture-Eligibility
- Capture-Pressure
- Capture-Progress
- Logistics Hubs
- FOB-Status
- IADS-Zustand
- AI-Reaktionen
- Besitzstatus
- Kampagnenphase
- Spielerinteraktion
- späterer Persistenz

Aktuell arbeitet der Mission Generator bewusst state-first.

Das bedeutet:

    Missionen werden erzeugt, angezeigt und aktiviert.
    Es werden noch keine echten DCS-Spawns ausgelöst.

---

## 2. Aktueller technischer Stand

Stand:

    2026-06-29

Aktive Datei:

    src/missions/tc_mission_generator.lua

Getestete Version:

    v0.2.2

Status:

    bestanden

Bestätigt durch DCS-Logtests:

- MissionGenerator lädt.
- MissionGenerator startet.
- MissionGenerator nutzt Airbase-, Zone-, Capture-, Logistics- und FOB-Daten.
- MissionGenerator erzeugt verfügbare Missionen.
- MissionGenerator berücksichtigt FOB-Support.
- MissionGenerator reserviert mindestens eine FOB-Support-Mission.
- MissionGenerator erzeugt erweiterte Mission Records.
- MissionGenerator erzeugt Objectives.
- MissionGenerator erzeugt Briefings.
- MissionGenerator erzeugt Progress-Daten.
- MissionGenerator erzeugt Activation Metadata.
- MissionGenerator reserviert Spawn-Hooks.
- F10Menu kann Missionen anzeigen.
- F10Menu kann Mission Details anzeigen.
- F10Menu kann Missionen direkt aktivieren.
- MissionGenerator setzt aktivierte Missionen auf ACTIVE.
- Aktivierung bleibt state-only.
- Es gab keinen Theater-Command-Lua-Fehler.
- Es gab keinen Lua-Stacktrace.

---

## 3. Aktuelle bestätigte Werte

Aktuell bestätigte MissionGenerator-Werte:

    mission candidates: 69
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 30

Aktuelle F10-Bestätigung:

    F10 Commands: 26
    Mission Details Slot 1 bestätigt
    Mission Details Slot 2 bestätigt
    Mission Details Slot 5 bestätigt
    Mission Slot 1 aktiviert
    Mission Slot 5 aktiviert

Bestätigte Aktivierungsmarker:

    Mission status changed: MISSION_1 [ACTIVE]
    Mission status changed: MISSION_4 [ACTIVE]
    Mission activation prepared: stateOnly=true spawnHooks=reserved

Bewertung:

    MissionGenerator v0.2.2 ist bestanden.
    Missionen sind fachlich deutlich stärker modelliert als im ersten Stand.
    Missionen können über F10 direkt ausgewählt und aktiviert werden.
    Missionen lösen weiterhin keine echten Spawns aus.

---

## 4. Designprinzip

Der Mission Generator folgt dem Projektprinzip:

    erst State
    dann Sichtbarkeit
    dann Tests
    dann echte Framework-Aktionen

Aktuell gilt:

- Missionen entstehen aus State-Daten.
- Missionen werden im State gespeichert.
- Missionen können über F10 angezeigt werden.
- Missionen können über F10 aktiviert werden.
- Aktivierung verändert den Mission-State.
- Aktivierung löst keine MOOSE-Spawns aus.
- Aktivierung löst keine CTLD-Aktionen aus.
- Aktivierung löst keine Skynet-Aktionen aus.
- Mission Effects sind vorbereitet, aber noch nicht produktiv auf andere Systeme angewendet.

Grund:

    Der Kampagnenzustand muss zuerst stabil, sichtbar und testbar sein.
    Echte DCS-Aktionen werden erst später angebunden.

---

## 5. Datenquellen

Der Mission Generator nutzt aktuell Daten aus mehreren Systemen.

Wichtige vorgelagerte Systeme:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua
    src/campaign/tc_capture_system.lua
    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua
    src/ai/tc_ai_cap_manager.lua

Aktuell bestätigte vorgelagerte Werte:

    Airbase-like Objects: 225
    relevante Kampagnenzonen: 46
    capture-fähige Ziele: 32
    Logistics Hubs: 46
    FOB-Kandidaten: 6
    Blue FOBs: 2
    CAP-Zonen-Kandidaten: 31

Wichtig:

    Missionen werden nicht aus allen 225 DCS-Airbase-like Objects erzeugt.
    Missionen werden aus gefilterten und klassifizierten Kampagnendaten erzeugt.

---

## 6. Verhältnis zu Airbase Scanner

Airbase Scanner liefert die klassifizierte Objektbasis.

Aktuelle Airbase-Werte:

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

MissionGenerator nutzt daraus vor allem:

- strategic Airfields
- secondary Airfields
- missionCandidates
- logisticsCandidates
- blueStartBases
- redStrategicCandidates

Nicht automatisch genutzt als Standard-Missionsziele:

- einfache Helipads
- Medical Pads
- Tactical Pads
- Unknown Objects

Diese Filterung verhindert unsinnige Missionen gegen irrelevante DCS-Sonderobjekte.

---

## 7. Verhältnis zu ZoneFactory

ZoneFactory erzeugt relevante Kampagnenzonen.

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

MissionGenerator nutzt daraus:

- Mission Zones
- Capture Zones
- Logistics Zones
- strategische Zonen
- sekundäre Zonen
- Startbase-Zonen
- spätere Mission-Editor-Zonen

Wichtig:

    ZoneFactory erzeugt aktuell 46 relevante Kampagnenzonen.
    Die frühere Annahme, dass alle 225 Airbase-like Objects als Zonen genutzt werden, ist veraltet.

---

## 8. Verhältnis zu CaptureSystem

CaptureSystem liefert strategischen Besitz, Capture-Eligibility, Capture-Pressure und Capture-Progress.

Aktuelle CaptureSystem-Werte:

    eligibleBases: 32
    eligibleZones: 32
    nonCaptureBases: 193
    nonCaptureZones: 14
    pressureRecords: 32
    progressRecords: 32
    appliedMissionEffects: 0
    ready: 0
    contested: 0

MissionGenerator kann daraus später ableiten:

- welche Ziele militärisch relevant sind
- welche Ziele unter Druck stehen
- welche Zonen kurz vor Capture stehen
- welche Missionen Capture vorbereiten
- welche Missionen Capture abschließen
- welche Missionen gegnerischen Fortschritt stoppen
- welche Missionseffekte an CaptureSystem gemeldet werden

Aktueller Stand:

    MissionGenerator erzeugt Mission Effects vorbereitet.
    CaptureSystem kann Mission Effects state-only vorbereiten.
    Produktive Missionserfolg-zu-Capture-Kopplung ist noch nicht aktiv.

Nächster notwendiger Zwischenschritt:

    Capture-/Pressure-Status im F10-Menü sichtbar machen.

---

## 9. Verhältnis zu LogisticsDelivery

LogisticsDelivery liefert Logistics Hubs.

Aktuelle LogisticsDelivery-Werte:

    logistics hubs: 46
    blue hubs: 7
    red hubs: 24
    neutral hubs: 15
    active hubs: 31
    limited hubs: 15
    locked hubs: 0

MissionGenerator kann daraus erzeugen:

- Logistics Missions
- Supply Missions
- Interdiction Missions
- Hub Attack Missions
- Repair Missions
- Engineering Missions
- spätere Cargo Missions
- spätere Convoy Missions

Aktueller Stand:

    Logistikdaten sind im State vorhanden.
    MissionGenerator nutzt Logistikdaten bereits als Teil der Missionskandidaten.
    Echte CTLD-Cargo-Aktionen sind noch nicht aktiv.

---

## 10. Verhältnis zu FobSystem

FobSystem liefert FOB-Kandidaten und geplante FOBs.

Aktuelle FobSystem-Werte:

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

MissionGenerator nutzt diese Daten bereits.

Aktuell bestätigt:

    fobSupportCandidates: 2
    reservedCreated: 1

Bedeutung:

    FOB-Support wird im Mission Pool berücksichtigt.
    Mindestens eine FOB-Support-Mission wird reserviert.
    FOB-Support wird nicht durch andere Missionstypen verdrängt.

Aktuelle Einschränkung:

    FOB-Support-Missionen sind state-only.
    Sie lösen noch keine CTLD-Cargo-Aktionen aus.

---

## 11. Verhältnis zu AICapManager

AICapManager liefert CAP-State.

Aktuelle AICapManager-Werte:

    cap zone candidates: 31
    auto-registered CAP zones: 12
    CAP requests: 12
    reactionState: AIR_REACTION_REQUESTED
    threatLevel: HIGH

MissionGenerator kann daraus später ableiten:

- CAP-Missionen
- Escort-Missionen
- Fighter Sweep
- Defensive Counter Air
- Offensive Counter Air
- Reaktion auf Bedrohungslage
- Priorisierung von CAP über kritischen Zonen

Aktueller Stand:

    CAP-State ist vorhanden.
    echte MOOSE-CAP-Flüge sind noch nicht aktiv.
    MissionGenerator erzeugt weiterhin state-only Missionen.

---

## 12. Aktuelle Missionstypen

Aktuelle Missionstypen:

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

Diese Liste ist noch nicht final.

Sie dient aktuell dazu, unterschiedliche Kampagnenbedarfe abzubilden.

Spätere Erweiterungen:

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

## 13. RECON

Zweck:

    Aufklärung eines relevanten Ziels oder Gebiets.

Mögliche spätere Wirkung:

- Zielinformationen verbessern
- Missionen freischalten
- IADS-Informationen sichtbar machen
- Capture-Pressure vorbereiten
- AI-Reaktionslage verbessern

Aktueller Stand:

    state-only Missionstyp
    keine echte Aufklärungslogik
    keine automatische Sensor- oder DCS-Event-Auswertung

---

## 14. STRIKE

Zweck:

    Angriff auf relevante Infrastruktur oder militärische Ziele.

Mögliche spätere Wirkung:

- Ziel schwächen
- Logistikstatus verschlechtern
- Capture-Pressure erhöhen
- IADS-Schutz indirekt reduzieren
- Missionserfolg in Campaign State schreiben

Aktueller Stand:

    state-only Missionstyp
    keine echten MOOSE-Strike-Spawns
    keine automatische Zielzerstörungsprüfung

---

## 15. SEAD

Zweck:

    Unterdrückung feindlicher Luftverteidigung.

Mögliche spätere Wirkung:

- IADS-Druck reduzieren
- SAM-Risiko senken
- Folgeoperationen ermöglichen
- CAP-/Strike-Missionen erleichtern
- IADS_SUPPRESSION vorbereiten

Aktueller Stand:

    state-only Missionstyp
    Skynet-Hooks vorbereitet
    keine echte Skynet-Wirkung
    keine DCS-Event-Auswertung

---

## 16. DEAD

Zweck:

    Zerstörung feindlicher Luftverteidigung.

Mögliche spätere Wirkung:

- SAM-Sites dauerhaft beschädigen oder zerstören
- IADS-Sektoren schwächen
- Missionen gegen tieferliegende Ziele ermöglichen
- Red AI-Reaktion verändern

Aktueller Stand:

    state-only Missionstyp
    keine echte Skynet-IADS-Kopplung
    keine automatische Kill-Auswertung

---

## 17. CAS

Zweck:

    Close Air Support für spätere Bodenoperationen oder Capture-Lagen.

Mögliche spätere Wirkung:

- Capture-Pressure erhöhen
- gegnerische Verteidigung senken
- FOB oder Logistics schützen
- AI-Gegenangriffe stoppen

Aktueller Stand:

    state-only Missionstyp
    keine produktiven Bodentruppen
    keine echte CAS-Event-Auswertung

---

## 18. INTERDICTION

Zweck:

    Unterbrechung gegnerischer Bewegung oder Logistik.

Mögliche spätere Wirkung:

- Red Logistics schwächen
- Verstärkung verzögern
- Hub-Status senken
- AI Director beeinflussen
- Capture-Erfolg erleichtern

Aktueller Stand:

    state-only Missionstyp
    keine realen Konvois
    keine automatische Interdiction-Auswertung

---

## 19. ESCORT

Zweck:

    Schutz eigener Missionen oder späterer Transport-/Logistikoperationen.

Mögliche spätere Wirkung:

- Überlebenswahrscheinlichkeit anderer Missionen erhöhen
- CAP-/Strike-Pakete absichern
- Cargo-Flüge schützen
- AI-Bedrohung reduzieren

Aktueller Stand:

    state-only Missionstyp
    keine echten Mission Packages
    keine echte Escort-Auswertung

---

## 20. CAP

Zweck:

    Luftüberlegenheit über wichtigen Zonen oder Korridoren sichern.

Mögliche spätere Wirkung:

- Blue/Red Air Presence erhöhen
- AI-Reaktion beeinflussen
- gegnerische Missionen erschweren
- Mission Generator priorisiert weitere Aufgaben

Aktueller Stand:

    state-only Missionstyp
    AICapManager erzeugt CAP-State
    MOOSE-CAP-Spawns noch nicht aktiv

---

## 21. LOGISTICS

Zweck:

    Versorgung, Transport oder Unterstützung logistischer Hubs.

Mögliche spätere Wirkung:

- Hub-Status verbessern
- Supply erhöhen
- FOB-Aufbau ermöglichen
- Capture-Fähigkeit unterstützen
- Reparaturen ermöglichen

Aktueller Stand:

    state-only Missionstyp
    CTLD noch nicht produktiv angebunden

---

## 22. FOB_SUPPORT

Zweck:

    Unterstützung geplanter oder im Bau befindlicher FOBs.

Aktuell besonders wichtig, weil FobSystem bereits zwei Blue-FOBs erzeugt:

    FOB Ercan
    FOB Gecitkale

Aktuell bestätigt:

    fobSupportCandidates: 2
    mindestens eine FOB-Support-Mission reserviert

Mögliche spätere Wirkung:

- Baufortschritt erhöhen
- Supply liefern
- Engineering liefern
- FOB aktivieren
- Forward Operations ermöglichen

Aktueller Stand:

    state-only Missionstyp
    keine echte CTLD-Cargo-Aktion
    keine echte FOB-Bauwirkung

---

## 23. AIRBASE_ATTACK

Zweck:

    Angriff auf Airbase-Ziele.

Mögliche spätere Wirkung:

- Airbase beschädigen
- Runway-Zustand beeinflussen
- Logistikstatus senken
- Capture vorbereiten
- Red AI einschränken

Aktueller Stand:

    state-only Missionstyp
    keine echte Runway- oder Infrastrukturprüfung
    keine automatische DCS-Schadensauswertung

---

## 24. IADS_SUPPRESSION

Zweck:

    gezielte Unterdrückung eines IADS-Bereichs.

Mögliche spätere Wirkung:

- Skynet-IADS-Sektor schwächen
- SAM-/EWR-Fähigkeit reduzieren
- SEAD-/DEAD-Kampagne abbilden
- sichere Korridore schaffen

Aktueller Stand:

    state-only Missionstyp
    Skynet-Hooks sind reserviert
    eigenes Theater-Command-IADS-Modul ist noch nicht aktiv

---

## 25. Mission Record

MissionGenerator v0.2.2 erzeugt erweiterte Mission Records.

Ein Mission Record kann aktuell enthalten:

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
- Execution Plan
- Effects
- reserved MOOSE Hook
- reserved CTLD Hook
- reserved Skynet Hook

Bedeutung:

    Missionen sind nicht mehr nur einfache Einträge.
    Sie sind vorbereitete Kampagnenobjekte.
    Sie können später mit Capture, Logistics, AI, IADS und Persistence verbunden werden.

---

## 26. Mission Status

Mögliche oder vorbereitete Mission Status:

- AVAILABLE
- ACTIVE
- COMPLETED
- FAILED
- CANCELLED
- EXPIRED

Aktueller bestätigter Statuswechsel:

    AVAILABLE -> ACTIVE

Bestätigt über F10:

    Mission Slot 1 aktiviert
    Mission Slot 5 aktiviert

Noch offen:

- Mission manuell abschließen
- Mission manuell fehlschlagen lassen
- Mission abbrechen
- Mission automatisch durch DCS-Events abschließen
- Missionserfolg auf Capture oder Logistics anwenden

---

## 27. Mission Activation

Missionen können aktuell über F10 aktiviert werden.

F10Menu v0.2.0 bietet:

- Show Available Missions
- Show Active Missions
- Show Mission 1 Details bis Show Mission 10 Details
- Activate Mission 1 bis Activate Mission 10

Bestätigt:

    MissionGenerator setzt aktivierte Missionen auf ACTIVE.
    Aktivierung erzeugt stateOnly=true.
    Aktivierung erzeugt spawnHooks=reserved.

Aktuelle Einschränkung:

    Mission Activation bedeutet noch nicht, dass DCS-Einheiten gespawnt werden.
    Mission Activation ist aktuell eine State-Änderung.

---

## 28. Mission Details

Mission Details sind über F10 abrufbar.

Bestätigt:

    Mission Details Slot 1
    Mission Details Slot 2
    Mission Details Slot 5

Mission Details sollen später enthalten:

- Missionsname
- Missionstyp
- Status
- Ziel
- Besitzer
- Priorität
- Briefing
- Objectives
- empfohlene Flugzeuge
- empfohlene Bewaffnung
- Fortschritt
- Effekte
- Hinweise zu Bedrohungen

Aktueller Stand:

    grundlegende Details sind über F10 sichtbar.
    Darstellung kann später erweitert und formatiert werden.

---

## 29. Mission Briefing

MissionGenerator v0.2.2 bereitet Briefings vor.

Briefings sollen später den Spieler verständlich informieren über:

- taktische Lage
- Ziel
- Auftrag
- erwartete Bedrohung
- empfohlene Flugzeuge
- empfohlene Waffen
- erwartete Wirkung
- Folgewirkung im Kampagnenzustand

Aktueller Stand:

    Briefing-Daten sind im Mission Record vorbereitet.
    F10-Anzeige ist noch nicht final gestaltet.

---

## 30. Mission Objectives

Mission Objectives beschreiben, was eine Mission erreichen soll.

Mögliche Objectives:

- Ziel aufklären
- Ziel angreifen
- Luftverteidigung unterdrücken
- Luftverteidigung zerstören
- FOB versorgen
- Logistikhub unterstützen
- Capture-Pressure erzeugen
- Airbase schwächen
- CAP über Zone aufbauen
- Konvoi schützen
- Transport durchführen

Aktueller Stand:

    Objectives sind im Mission Record vorbereitet.
    Automatische Objective-Erfüllung ist noch nicht aktiv.

---

## 31. Mission Progress

Mission Progress soll später Fortschritt und Erfolg abbilden.

Mögliche Progress-Daten:

- started
- objectiveCompleted
- partialSuccess
- failed
- damageReported
- cargoDelivered
- unitsDestroyed
- zonePressureApplied
- captureProgressApplied
- timeActive
- timeout

Aktueller Stand:

    Progress-Daten sind vorbereitet.
    `updateMissionProgress()` ist vorbereitet.
    automatische DCS-Event-Auswertung ist noch nicht aktiv.

---

## 32. Mission Effects

Mission Effects sollen später die Kampagne beeinflussen.

Mögliche Zielsysteme:

- CaptureSystem
- LogisticsDelivery
- FobSystem
- AICapManager
- AI Director
- IADS System
- PersistenceSystem

Mögliche Effekte:

- Capture-Pressure erhöhen
- Capture-Progress erhöhen
- Hub-Status verändern
- FOB-Baufortschritt erhöhen
- IADS schwächen
- AI-Reaktion auslösen
- Missionen freischalten
- Missionen blockieren
- Ressourcenverbrauch erzeugen

Aktueller Stand:

    Mission Effects sind vorbereitet.
    CaptureSystem kann Mission Effects state-only vorbereiten.
    Produktive MissionEffect-Anwendung ist noch nicht aktiv.

---

## 33. Spawn Hooks

MissionGenerator v0.2.2 reserviert Spawn-Hooks.

Reservierte Hook-Bereiche:

- MOOSE
- CTLD
- Skynet IADS

Bedeutung:

    Missionen wissen bereits, welche Framework-Schicht später zuständig sein könnte.
    Es wird aber noch nichts ausgeführt.

Aktueller Stand:

    spawnHooks=reserved
    stateOnly=true

Wichtig:

    Keine echten MOOSE-Spawns.
    Keine echten CTLD-Aktionen.
    Keine echten Skynet-Aktionen.

---

## 34. F10-Integration

F10Menu v0.2.0 ist der aktuelle Spielerzugang zum Mission Generator.

Bestätigte F10-Funktionen:

- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Mission 1 Details anzeigen
- Mission 2 Details anzeigen
- Mission 5 Details anzeigen
- Mission 1 aktivieren
- Mission 5 aktivieren

Aktuelle Menüstruktur:

    F10
    └── Theater Command
        ├── Missions
        │   ├── Show Available Missions
        │   ├── Show Active Missions
        │   ├── Mission Details
        │   │   ├── Show Mission 1 Details
        │   │   ├── ...
        │   │   └── Show Mission 10 Details
        │   └── Activate Mission
        │       ├── Activate Mission 1
        │       ├── ...
        │       └── Activate Mission 10

Bewertung:

    F10-Integration ist bestanden.
    Mission Generator und UI sind erfolgreich verbunden.

---

## 35. Warum Missionen noch state-only sind

Missionen bleiben bewusst state-only.

Gründe:

- echte Spawns erhöhen Fehlerkomplexität stark
- MOOSE-Templates sind noch nicht definiert
- CTLD-Zonen sind noch nicht produktiv angelegt
- IADS-System ist noch nicht Theater-Command-seitig angebunden
- Missionserfolg muss zuerst sauber modelliert werden
- Capture-Pressure und Mission Effects müssen sichtbar werden
- Debug- und F10-Sichtbarkeit müssen wachsen

Aktuelle Entscheidung:

    State-first bleibt vor echter Framework-Ausführung.

---

## 36. Nächster MissionGenerator-Schritt

Der nächste direkte MissionGenerator-Schritt wäre:

    Mission completed/failed testbar machen.

Mögliche Funktionen:

- active mission complete
- active mission failed
- active mission cancelled
- MissionGenerator.completeMission()
- MissionGenerator.failMission()
- MissionGenerator.cancelMission()
- Mission Effects anwenden
- CaptureSystem.applyMissionEffect() praktisch testen

Aber:

    Vorher sollte Capture-/Pressure-Status im F10-Menü sichtbar werden.

Grund:

    Ohne Sichtbarkeit ist schwer zu bewerten, ob Mission Effects später korrekt auf Capture Pressure wirken.

---

## 37. Nächster Gesamtprojektschritt

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
- keine echten Spawns
- keine CTLD-Aktion
- keine Skynet-Aktion
- keine Lua-Fehler
- keine Theater-Command-Fehler

---

## 38. Risiken

Wichtige Risiken im Mission Generator:

- zu viele Missionen aus falschen Zielen
- irrelevante DCS-Objekte als Missionsziele
- FOB-Support wird durch andere Missionen verdrängt
- Missionen ohne klare Objective-Struktur
- Mission Activation löst zu früh echte Spawns aus
- Mission Effects verändern Capture ohne Sichtbarkeit
- DCS-Events werden falsch interpretiert
- aktive Missionen bleiben dauerhaft hängen
- Missionen werden doppelt erzeugt
- Persistence speichert inkonsistente Mission States

Aktuelle Gegenmaßnahmen:

- konservative Zielauswahl
- Airbase-/Zone-Filterung
- Missionstyp-Limits
- FOB-Support-Reservierung
- stateOnly-Aktivierung
- reserved Spawn-Hooks
- F10-Sichtbarkeit
- Logmarker pro Aktivierung

---

## 39. Aktuelle Akzeptanzkriterien

Aktuell bestanden:

- MissionGenerator lädt.
- MissionGenerator startet.
- 69 Missionskandidaten werden erkannt.
- 2 FOB-Support-Kandidaten werden erkannt.
- 10 verfügbare Missionen werden erzeugt.
- mindestens eine FOB-Support-Mission wird reserviert.
- Mission Details sind über F10 abrufbar.
- Missionen können über F10 direkt aktiviert werden.
- MissionGenerator setzt aktivierte Missionen auf ACTIVE.
- Aktivierung bleibt state-only.
- Spawn-Hooks bleiben reserved.
- keine Lua-Fehler.
- keine Theater-Command-Fehler.

Noch offen:

- Mission completed/failed
- Mission Effects produktiv anwenden
- automatische DCS-Event-Auswertung
- echte MOOSE-Spawns
- echte CTLD-Aktionen
- echte Skynet-IADS-Wirkung
- Mission-State persistieren

---

## 40. Aktueller getesteter Systemstand

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

## 41. Aktueller Status

MissionGenerator ist für den aktuellen state-first Entwicklungsstand bestanden.

Aktuelle Fähigkeit:

- Missionen entstehen aus klassifizierten Kampagnendaten.
- FOB-Support wird berücksichtigt.
- 10 verfügbare Missionen werden erzeugt.
- Missionen enthalten Objectives, Briefings, Progress und Activation Metadata.
- Missionen können über F10 direkt angezeigt werden.
- Missionen können über F10 direkt aktiviert werden.
- aktivierte Missionen bleiben state-only.
- Spawn-Hooks bleiben reserved.

Nächster sinnvoller Schritt:

    Capture-/Pressure-Sichtbarkeit im F10-Menü.

Danach:

    Mission completed/failed testbar machen.
    Mission Effects kontrolliert auf CaptureSystem anwenden.
