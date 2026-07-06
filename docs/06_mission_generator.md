# Mission Generator

Diese Datei beschreibt den Mission Generator von **Theater Command DCS**.

Erste Kampagne:

- **Operation Levant Reclamation**

Map:

- **Syria**

Ausgangslage:

- Blue startet auf **Akrotiri / Zypern**
- das syrische Festland ist zu Beginn rot kontrolliert
- Red hält zu Beginn den Großteil der strategischen Flugplätze
- Blue soll sich vom Brückenkopf Zypern aus auf das syrische Festland vorarbeiten
- Spieler sollen sich in eine laufende Kampagnenlage einklinken, nicht jede Aktion allein auslösen
- Blue und Red sollen perspektivisch eigene Operationen planen und durchführen

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
- Capture Ready
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

- Missionen werden aus State-Daten erzeugt.
- Missionen werden im F10-Menü angezeigt.
- Missionen können über F10 aktiviert werden.
- Missionen können state-only abgeschlossen werden.
- Missionen bereiten Effects state-only vor.
- Es werden noch keine echten DCS-Spawns ausgelöst.

---

## 2. Aktueller technischer Stand

Stand: **2026-07-06**

Aktive Datei:

```text
src/missions/tc_mission_generator.lua
```

Getestete Version:

```text
v0.2.3
```

Status:

- **bestanden**

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
- MissionGenerator erzeugt Outcome State.
- MissionGenerator erzeugt Effect State.
- MissionGenerator reserviert Spawn-Hooks.
- F10Menu kann Missionen anzeigen.
- F10Menu kann Mission Details anzeigen.
- F10Menu kann Missionen direkt aktivieren.
- F10Menu kann Active Mission Outcome Status anzeigen.
- F10Menu kann aktive Mission 1 auf `COMPLETED` setzen.
- MissionGenerator setzt aktivierte Missionen auf `ACTIVE`.
- MissionGenerator setzt abgeschlossene Missionen auf `COMPLETED`.
- MissionGenerator bereitet Mission Effects state-only vor.
- CaptureSystem verarbeitet abgeschlossene Mission Effects state-only in Capture Pressure.
- Aktivierung bleibt state-only.
- Completion bleibt state-only.
- Es gab keinen Theater-Command-Lua-Fehler.
- Es gab keinen Lua-Stacktrace.

---

## 3. Aktuelle bestätigte Werte

Aktuell bestätigte MissionGenerator-Werte:

```text
mission candidates: 78
fobSupportCandidates: 2
generated missions: 10
reservedCreated: 1
duplicatesSkipped: 1
typeLimitSkipped: 68
```

Aktuelle F10-Bestätigung:

```text
F10 Commands: 32
Mission Details Slot 1 bestätigt
Mission Slot 1 aktiviert
Active Mission Outcome Status bestätigt
Complete Active Mission 1 bestätigt
Capture Status bestätigt
Capture Ready Zones bestätigt
Pressure Contested Zones bestätigt
```

Bestätigte Aktivierungs- und Outcome-Marker:

```text
[TC] [MissionGenerator] Loaded src/missions/tc_mission_generator.lua v0.2.3
[TC] [MissionGenerator] Mission candidate summary: candidates=78, fobSupportCandidates=2, availableBefore=0, generationSlots=10
[TC] [MissionGenerator] Mission generation completed: 10 new missions from 78 candidates (fobSupportCandidates=2, reservedCreated=1, duplicatesSkipped=1, typeLimitSkipped=68)
[TC] [MissionGenerator] Mission status changed: MISSION_2 [ACTIVE]
[TC] [MissionGenerator] Mission activation prepared: MISSION_2 stateOnly=true spawnHooks=reserved
[TC] [MissionGenerator] Mission effects prepared state-only: MISSION_2 status=COMPLETED
[TC] [MissionGenerator] Mission outcome prepared: MISSION_2 [COMPLETED] stateOnly=true effects=prepared
```

Bewertung:

- MissionGenerator `v0.2.3` ist bestanden.
- Missionen sind fachlich deutlich stärker modelliert als im ersten Stand.
- Missionen können über F10 direkt ausgewählt, aktiviert und abgeschlossen werden.
- Mission Completion erzeugt vorbereitete Mission Effects.
- CaptureSystem kann diese Mission Effects verarbeiten.
- Missionen lösen weiterhin keine echten Spawns aus.

---

## 4. Designprinzip

Der Mission Generator folgt dem Projektprinzip:

```text
erst State
dann Sichtbarkeit
dann Tests
dann echte Framework-Aktionen
```

Aktuell gilt:

- Missionen entstehen aus State-Daten.
- Missionen werden im State gespeichert.
- Missionen können über F10 angezeigt werden.
- Missionen können über F10 aktiviert werden.
- Missionen können über F10 auf `COMPLETED` gesetzt werden.
- Aktivierung verändert den Mission-State.
- Completion verändert den Mission-State.
- Completion bereitet Mission Effects vor.
- Mission Effects werden von Empfängersystemen verarbeitet.
- Der erste bestätigte Empfänger ist CaptureSystem.
- Aktivierung löst keine MOOSE-Spawns aus.
- Aktivierung löst keine CTLD-Aktionen aus.
- Aktivierung löst keine Skynet-Aktionen aus.
- Completion löst keine echten Framework-Aktionen aus.

Grund:

Der Kampagnenzustand muss zuerst stabil, sichtbar und testbar sein.

Echte DCS-Aktionen werden erst später angebunden.

---

## 5. Datenquellen

Der Mission Generator nutzt aktuell Daten aus mehreren Systemen.

Wichtige vorgelagerte Systeme:

```text
src/world/tc_airbase_scanner.lua
src/world/tc_zone_factory.lua
src/campaign/tc_capture_system.lua
src/logistics/tc_logistics_delivery.lua
src/logistics/tc_fob_system.lua
src/ai/tc_ai_cap_manager.lua
```

Aktuell bestätigte vorgelagerte Werte:

```text
Airbase-like Objects: 225
relevante Kampagnenzonen: 46
capture-fähige Ziele: 32
Capture-Pressure-Records: 32
Capture-Progress-Records: 32
Logistics Hubs: 46
FOB-Kandidaten: 6
Blue FOBs: 2
CAP-Zonen-Kandidaten: 31
```

Wichtig:

Missionen werden nicht aus allen 225 DCS-Airbase-like Objects erzeugt.

Missionen werden aus gefilterten und klassifizierten Kampagnendaten erzeugt.

---

## 6. Verhältnis zu Airbase Scanner

Airbase Scanner liefert die klassifizierte Objektbasis.

Aktuelle Airbase-Werte:

```text
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
```

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

```text
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
```

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

Aktuelle CaptureSystem-Startwerte:

```text
eligibleBases: 32
eligibleZones: 32
nonCaptureBases: 193
nonCaptureZones: 14
pressureRecords: 32
progressRecords: 32
appliedMissionEffects: 0
ready: 0
contested: 0
```

Bestätigte Werte nach Mission Completion:

```text
completed mission: MISSION_2
target zone: ZONE_AIRBASE_ABU_AL_DUHUR
capture pressure owner: BLUE
applied pressure: 105
progress: 100 %
appliedMissionEffects: 1
ready: 1
contested: 0
```

MissionGenerator liefert dafür:

- Mission Status
- Mission Outcome
- Mission Effect State
- Zielzone
- Zielbasis
- Missionstyp
- vorbereitete Capture Pressure

CaptureSystem verarbeitet daraus:

- Capture Pressure
- Capture Progress
- Capture Ready
- angewendete Mission Effects

Aktueller Stand:

- MissionGenerator erzeugt Mission Effects.
- CaptureSystem verarbeitet abgeschlossene Mission Effects.
- Mission Completion kann Capture Pressure erzeugen.
- Capture Progress kann durch Mission Completion steigen.
- Capture Ready kann durch Mission Completion entstehen.
- Capture Ready ist über F10 sichtbar.

Noch nicht aktiv:

- automatischer produktiver Ownership-Wechsel
- automatische produktive Capture-Auswertung ohne F10-/Debug-Bestätigung

---

## 9. Verhältnis zu LogisticsDelivery

LogisticsDelivery liefert Logistics Hubs.

Aktuelle LogisticsDelivery-Werte:

```text
logistics hubs: 46
blue hubs: 7
red hubs: 24
neutral hubs: 15
active hubs: 31
limited hubs: 15
locked hubs: 0
```

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

- Logistikdaten sind im State vorhanden.
- MissionGenerator nutzt Logistikdaten bereits als Teil der Missionskandidaten.
- Echte CTLD-Cargo-Aktionen sind noch nicht aktiv.
- Mission Effects wirken noch nicht produktiv auf Logistics.

---

## 10. Verhältnis zu FobSystem

FobSystem liefert FOB-Kandidaten und geplante FOBs.

Aktuelle FobSystem-Werte:

```text
FOB candidates: 6
stored candidates: 6
auto-planned FOBs: 2
skipped candidates: 4
Blue FOBs: 2
```

Aktuelle Blue-FOBs:

```text
FOB Ercan
FOB Gecitkale
```

Status:

```text
UNDER_CONSTRUCTION
```

MissionGenerator nutzt diese Daten bereits.

Aktuell bestätigt:

```text
fobSupportCandidates: 2
reservedCreated: 1
```

Bedeutung:

- FOB-Support wird im Mission Pool berücksichtigt.
- Mindestens eine FOB-Support-Mission wird reserviert.
- FOB-Support wird nicht durch andere Missionstypen verdrängt.

Aktuelle Einschränkung:

- FOB-Support-Missionen sind state-only.
- Sie lösen noch keine CTLD-Cargo-Aktionen aus.
- Sie erhöhen noch nicht praktisch den FOB-Baufortschritt.

---

## 11. Verhältnis zu AICapManager

AICapManager liefert CAP-State.

Aktuelle AICapManager-Werte:

```text
cap zone candidates: 31
auto-registered CAP zones: 12
CAP requests: 12
reactionState: AIR_REACTION_REQUESTED
threatLevel: HIGH
```

MissionGenerator kann daraus später ableiten:

- CAP-Missionen
- Escort-Missionen
- Fighter Sweep
- Defensive Counter Air
- Offensive Counter Air
- Reaktion auf Bedrohungslage
- Priorisierung von CAP über kritischen Zonen

Aktueller Stand:

- CAP-State ist vorhanden.
- echte MOOSE-CAP-Flüge sind noch nicht aktiv.
- MissionGenerator erzeugt weiterhin state-only Missionen.

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

- Aufklärung eines relevanten Ziels oder Gebiets

Mögliche spätere Wirkung:

- Zielinformationen verbessern
- Missionen freischalten
- IADS-Informationen sichtbar machen
- Capture-Pressure vorbereiten
- AI-Reaktionslage verbessern

Aktueller Stand:

- state-only Missionstyp
- keine echte Aufklärungslogik
- keine automatische Sensor- oder DCS-Event-Auswertung

---

## 14. STRIKE

Zweck:

- Angriff auf relevante Infrastruktur oder militärische Ziele

Mögliche spätere Wirkung:

- Ziel schwächen
- Logistikstatus verschlechtern
- Capture-Pressure erhöhen
- IADS-Schutz indirekt reduzieren
- Missionserfolg in Campaign State schreiben

Aktueller Stand:

- state-only Missionstyp
- keine echten MOOSE-Strike-Spawns
- keine automatische Zielzerstörungsprüfung

---

## 15. SEAD

Zweck:

- Unterdrückung feindlicher Luftverteidigung

Mögliche spätere Wirkung:

- IADS-Druck reduzieren
- SAM-Risiko senken
- Folgeoperationen ermöglichen
- CAP-/Strike-Missionen erleichtern
- IADS_SUPPRESSION vorbereiten

Aktueller Stand:

- state-only Missionstyp
- Skynet-Hooks vorbereitet
- keine echte Skynet-Wirkung
- keine DCS-Event-Auswertung

---

## 16. DEAD

Zweck:

- Zerstörung feindlicher Luftverteidigung

Mögliche spätere Wirkung:

- SAM-Sites dauerhaft beschädigen oder zerstören
- IADS-Sektoren schwächen
- Missionen gegen tieferliegende Ziele ermöglichen
- Red AI-Reaktion verändern

Aktueller Stand:

- state-only Missionstyp
- keine echte Skynet-IADS-Kopplung
- keine automatische Kill-Auswertung

---

## 17. CAS

Zweck:

- Close Air Support für spätere Bodenoperationen oder Capture-Lagen

Mögliche spätere Wirkung:

- Capture-Pressure erhöhen
- gegnerische Verteidigung senken
- FOB oder Logistics schützen
- AI-Gegenangriffe stoppen

Aktueller Stand:

- state-only Missionstyp
- keine produktiven Bodentruppen
- keine echte CAS-Event-Auswertung

---

## 18. INTERDICTION

Zweck:

- Unterbrechung gegnerischer Bewegung oder Logistik

Mögliche spätere Wirkung:

- Red Logistics schwächen
- Verstärkung verzögern
- Hub-Status senken
- AI Director beeinflussen
- Capture-Erfolg erleichtern

Aktueller Stand:

- state-only Missionstyp
- keine realen Konvois
- keine automatische Interdiction-Auswertung

---

## 19. ESCORT

Zweck:

- Schutz eigener Missionen oder späterer Transport-/Logistikoperationen

Mögliche spätere Wirkung:

- Überlebenswahrscheinlichkeit anderer Missionen erhöhen
- CAP-/Strike-Pakete absichern
- Cargo-Flüge schützen
- AI-Bedrohung reduzieren

Aktueller Stand:

- state-only Missionstyp
- keine echten Mission Packages
- keine echte Escort-Auswertung

---

## 20. CAP

Zweck:

- Luftüberlegenheit über wichtigen Zonen oder Korridoren sichern

Mögliche spätere Wirkung:

- Blue/Red Air Presence erhöhen
- AI-Reaktion beeinflussen
- gegnerische Missionen erschweren
- Mission Generator priorisiert weitere Aufgaben

Aktueller Stand:

- state-only Missionstyp
- AICapManager erzeugt CAP-State
- MOOSE-CAP-Spawns noch nicht aktiv

---

## 21. LOGISTICS

Zweck:

- Versorgung, Transport oder Unterstützung logistischer Hubs

Mögliche spätere Wirkung:

- Hub-Status verbessern
- Supply erhöhen
- FOB-Aufbau ermöglichen
- Capture-Fähigkeit unterstützen
- Reparaturen ermöglichen

Aktueller Stand:

- state-only Missionstyp
- CTLD noch nicht produktiv angebunden
- Logistics Effects noch nicht produktiv angewendet

---

## 22. FOB_SUPPORT

Zweck:

- Unterstützung geplanter oder im Bau befindlicher FOBs

Aktuell besonders wichtig, weil FobSystem bereits zwei Blue-FOBs erzeugt:

```text
FOB Ercan
FOB Gecitkale
```

Aktuell bestätigt:

```text
fobSupportCandidates: 2
mindestens eine FOB-Support-Mission reserviert
```

Mögliche spätere Wirkung:

- Baufortschritt erhöhen
- Supply liefern
- Engineering liefern
- FOB aktivieren
- Forward Operations ermöglichen

Aktueller Stand:

- state-only Missionstyp
- keine echte CTLD-Cargo-Aktion
- keine echte FOB-Bauwirkung

---

## 23. AIRBASE_ATTACK

Zweck:

- Angriff auf Airbase-Ziele

Mögliche spätere Wirkung:

- Airbase beschädigen
- Runway-Zustand beeinflussen
- Logistikstatus senken
- Capture vorbereiten
- Red AI einschränken

Aktueller Stand:

- state-only Missionstyp
- keine echte Runway- oder Infrastrukturprüfung
- keine automatische DCS-Schadensauswertung
- kann bereits Capture Pressure vorbereiten
- bestätigter Testeffekt auf `ZONE_AIRBASE_ABU_AL_DUHUR`

---

## 24. IADS_SUPPRESSION

Zweck:

- gezielte Unterdrückung eines IADS-Bereichs

Mögliche spätere Wirkung:

- Skynet-IADS-Sektor schwächen
- SAM-/EWR-Fähigkeit reduzieren
- SEAD-/DEAD-Kampagne abbilden
- sichere Korridore schaffen

Aktueller Stand:

- state-only Missionstyp
- Skynet-Hooks sind reserviert
- eigenes Theater-Command-IADS-Modul ist noch nicht aktiv

---

## 25. Mission Record

MissionGenerator `v0.2.3` erzeugt erweiterte Mission Records.

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
- Outcome State
- Effect State
- Execution Plan
- Effects
- reserved MOOSE Hook
- reserved CTLD Hook
- reserved Skynet Hook

Bedeutung:

- Missionen sind nicht mehr nur einfache Einträge.
- Sie sind vorbereitete Kampagnenobjekte.
- Sie können mit Capture, Logistics, AI, IADS und Persistence verbunden werden.
- Der erste bestätigte Empfänger ist CaptureSystem.

---

## 26. Mission Status

Mögliche oder vorbereitete Mission Status:

- `AVAILABLE`
- `ACTIVE`
- `COMPLETED`
- `FAILED`
- `CANCELLED`
- `EXPIRED`

Aktuell bestätigte Statuswechsel:

```text
AVAILABLE -> ACTIVE
ACTIVE -> COMPLETED
```

Bestätigt über F10:

- Mission Slot 1 aktiviert
- Active Mission 1 abgeschlossen

Noch offen:

- Mission manuell fehlschlagen lassen
- Mission abbrechen
- Mission ablaufen lassen
- Mission automatisch durch DCS-Events abschließen
- Missionserfolg auf Logistics oder AI anwenden
- Missionserfolg auf IADS anwenden

---

## 27. Mission Activation

Missionen können aktuell über F10 aktiviert werden.

F10Menu `v0.2.2` bietet:

- `Show Available Missions`
- `Show Active Missions`
- `Show Mission 1 Details` bis `Show Mission 10 Details`
- `Activate Mission 1` bis `Activate Mission 10`

Bestätigt:

- MissionGenerator setzt aktivierte Missionen auf `ACTIVE`.
- Aktivierung erzeugt `stateOnly=true`.
- Aktivierung erzeugt `spawnHooks=reserved`.

Aktuelle Einschränkung:

- Mission Activation bedeutet noch nicht, dass DCS-Einheiten gespawnt werden.
- Mission Activation ist aktuell eine State-Änderung.

---

## 28. Mission Outcome

Mission Outcome Controls sind seit F10Menu `v0.2.2` praktisch testbar.

Aktuelle F10-Funktionen:

- `Show Active Mission Outcome Status`
- `Complete Active Mission 1`
- `Fail Active Mission 1`

Bestätigt:

- `Show Active Mission Outcome Status`
- `Complete Active Mission 1`
- MissionGenerator setzt aktive Mission 1 auf `COMPLETED`.
- MissionGenerator bereitet Mission Effects state-only vor.
- CaptureSystem verarbeitet abgeschlossene Mission Effects.

Noch offen:

- `Fail Active Mission 1` praktisch testen
- Failure Effects definieren
- Cancelled/Expired später testbar machen

---

## 29. Mission Details

Mission Details sind über F10 abrufbar.

Bestätigt:

- Mission Details Slot 1

Mission Details sollen enthalten:

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
- Outcome State
- Effect State
- Hinweise zu Bedrohungen

Aktueller Stand:

- grundlegende Details sind über F10 sichtbar
- Outcome- und Effect-State-Daten sind vorbereitet
- Darstellung kann später erweitert und formatiert werden

---

## 30. Mission Briefing

MissionGenerator `v0.2.3` bereitet Briefings vor.

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

- Briefing-Daten sind im Mission Record vorbereitet
- F10-Anzeige ist noch nicht final gestaltet

---

## 31. Mission Objectives

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

- Objectives sind im Mission Record vorbereitet
- automatische Objective-Erfüllung ist noch nicht aktiv

---

## 32. Mission Progress

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

- Progress-Daten sind vorbereitet
- `updateMissionProgress()` ist vorbereitet
- automatische DCS-Event-Auswertung ist noch nicht aktiv

---

## 33. Mission Effects

Mission Effects sollen die Kampagne beeinflussen.

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

- Mission Effects werden vorbereitet.
- Mission Effects werden state-only gespeichert.
- CaptureSystem verarbeitet abgeschlossene Mission Effects.
- Der erste bestätigte praktische Effekt ist Capture Pressure.
- Mission Effects auf Logistics, AI und IADS sind noch nicht produktiv aktiv.

Bestätigter Capture-Effekt:

```text
MISSION_2 -> ZONE_AIRBASE_ABU_AL_DUHUR -> BLUE pressure 105 -> progress 100% -> ready=1
```

---

## 34. Spawn Hooks

MissionGenerator `v0.2.3` reserviert Spawn-Hooks.

Reservierte Hook-Bereiche:

- MOOSE
- CTLD
- Skynet IADS

Bedeutung:

- Missionen wissen bereits, welche Framework-Schicht später zuständig sein könnte.
- Es wird aber noch nichts ausgeführt.

Aktueller Stand:

```text
spawnHooks=reserved
stateOnly=true
```

Wichtig:

- Keine echten MOOSE-Spawns.
- Keine echten CTLD-Aktionen.
- Keine echten Skynet-Aktionen.

---

## 35. F10-Integration

F10Menu `v0.2.2` ist der aktuelle Spielerzugang zum Mission Generator.

Bestätigte F10-Funktionen:

- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Mission 1 Details anzeigen
- Mission 1 aktivieren
- Active Mission Outcome Status anzeigen
- aktive Mission 1 auf `COMPLETED` setzen
- Capture Status anzeigen
- Capture Ready Zones anzeigen
- Pressure Contested Zones anzeigen

Aktuelle Menüstruktur:

```text
F10
└── Theater Command
    ├── Missions
    │   ├── Show Available Missions
    │   ├── Show Active Missions
    │   ├── Mission Details
    │   │   ├── Show Mission 1 Details
    │   │   ├── ...
    │   │   └── Show Mission 10 Details
    │   ├── Activate Mission
    │   │   ├── Activate Mission 1
    │   │   ├── ...
    │   │   └── Activate Mission 10
    │   └── Mission Outcome
    │       ├── Show Active Mission Outcome Status
    │       ├── Complete Active Mission 1
    │       └── Fail Active Mission 1
    ├── Status
    │   ├── Show Campaign Status
    │   ├── Show Capture Status
    │   ├── Show Capture Ready Zones
    │   └── Show Pressure Contested Zones
    ├── Logistics
    │   ├── Show Logistics Status
    │   └── Show FOB Status
    └── AI
        └── Show AI CAP Status
```

Bewertung:

- F10-Integration ist bestanden.
- Mission Generator und UI sind erfolgreich verbunden.
- MissionGenerator und CaptureSystem sind erfolgreich über Mission Effects verbunden.
- Capture Ready ist über F10 sichtbar.

---

## 36. Warum Missionen noch state-only sind

Missionen bleiben bewusst state-only.

Gründe:

- echte Spawns erhöhen Fehlerkomplexität stark
- MOOSE-Templates sind noch nicht definiert
- CTLD-Zonen sind noch nicht produktiv angelegt
- IADS-System ist noch nicht Theater-Command-seitig angebunden
- Missionserfolg muss zuerst sauber modelliert werden
- Capture-Pressure und Mission Effects müssen sichtbar sein
- Debug- und F10-Sichtbarkeit müssen weiter wachsen
- Ownership-Wechsel müssen kontrolliert getestet werden
- Persistence muss vor produktiver Nutzung technisch geprüft werden

Aktuelle Entscheidung:

State-first bleibt vor echter Framework-Ausführung.

---

## 37. Nächster MissionGenerator-Schritt

Der nächste direkte MissionGenerator-Test wäre:

```text
Fail Active Mission 1
```

Ziel:

- `MissionGenerator.failMission()` praktisch bestätigen
- Failure Outcome prüfen
- Failure Effects prüfen
- entscheiden, ob Failure neutral, gegnerisch oder negativ auf Kampagnenstate wirken soll

Aber:

Der aktuell empfohlene nächste Code-Schritt betrifft nicht direkt MissionGenerator, sondern UI/Capture.

Grund:

- Completion funktioniert.
- Capture Pressure funktioniert.
- Capture Ready ist sichtbar.
- Der nächste logische Schritt ist ein kontrollierter state-only Ownership-Wechsel aus Capture Ready.

---

## 38. Nächster Gesamtprojektschritt

Empfohlene nächste Datei:

```text
src/ui/tc_f10_menu.lua
```

Ziel:

```text
kontrollierter state-only Ownership-Wechsel aus Capture Ready Zone 1
```

Mögliche neue F10-Funktion:

```text
Apply Capture Ready Zone 1
```

Akzeptanzkriterien:

- F10Menu lädt als neue Version.
- bisherige 32 Commands bleiben funktionsfähig.
- neuer Capture-Apply-Command wird ergänzt.
- Capture Ready Zone 1 kann bewusst angewendet werden.
- Zone Ownership wird state-only aktualisiert.
- linked Airbase Ownership wird kontrolliert über bestehende CaptureSystem-Funktion synchronisiert.
- Capture Pressure wird nach erfolgreichem Ownership-Wechsel zurückgesetzt oder sauber markiert.
- Logmarker zeigen eindeutig den Ownership-Wechsel.
- keine echten Spawns
- keine CTLD-Aktion
- keine Skynet-Aktion
- keine Lua-Fehler
- keine Theater-Command-Fehler

---

## 39. Risiken

Wichtige Risiken im Mission Generator:

- zu viele Missionen aus falschen Zielen
- irrelevante DCS-Objekte als Missionsziele
- FOB-Support wird durch andere Missionen verdrängt
- Missionen ohne klare Objective-Struktur
- Mission Activation löst zu früh echte Spawns aus
- Mission Effects verändern Capture ohne Sichtbarkeit
- Mission Effects werden doppelt angewendet
- DCS-Events werden falsch interpretiert
- aktive Missionen bleiben dauerhaft hängen
- Missionen werden doppelt erzeugt
- Persistence speichert inkonsistente Mission States
- Failure Effects werden falsch interpretiert

Aktuelle Gegenmaßnahmen:

- konservative Zielauswahl
- Airbase-/Zone-Filterung
- Missionstyp-Limits
- FOB-Support-Reservierung
- stateOnly-Aktivierung
- stateOnly-Completion
- reserved Spawn-Hooks
- Capture-Pressure-Sichtbarkeit
- Capture Ready Visibility
- `appliedMissionEffects` verhindert doppelte Anwendung
- F10-Sichtbarkeit
- Logmarker pro Aktivierung und Outcome

---

## 40. Aktuelle Akzeptanzkriterien

Aktuell bestanden:

- MissionGenerator lädt.
- MissionGenerator startet.
- 78 Missionskandidaten werden erkannt.
- 2 FOB-Support-Kandidaten werden erkannt.
- 10 verfügbare Missionen werden erzeugt.
- mindestens eine FOB-Support-Mission wird reserviert.
- Mission Details sind über F10 abrufbar.
- Missionen können über F10 direkt aktiviert werden.
- MissionGenerator setzt aktivierte Missionen auf `ACTIVE`.
- Aktivierung bleibt state-only.
- Spawn-Hooks bleiben reserved.
- aktive Mission 1 kann über F10 auf `COMPLETED` gesetzt werden.
- MissionGenerator bereitet Mission Effects vor.
- CaptureSystem verarbeitet abgeschlossene Mission Effects.
- Capture Pressure wird erhöht.
- Capture Progress wird aktualisiert.
- Capture Ready entsteht.
- Capture Ready Zones sind über F10 sichtbar.
- keine Lua-Fehler.
- keine Theater-Command-Fehler.

Noch offen:

- `Fail Active Mission 1` praktisch testen
- Mission Effects auf Logistics anwenden
- Mission Effects auf AI anwenden
- Mission Effects auf IADS anwenden
- automatische DCS-Event-Auswertung
- echte MOOSE-Spawns
- echte CTLD-Aktionen
- echte Skynet-IADS-Wirkung
- Mission-State persistieren

---

## 41. Aktueller getesteter Systemstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | Grundstruktur | lädt/startet |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | bestanden |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.2` | bestanden |

---

## 42. Aktueller Status

MissionGenerator ist für den aktuellen state-first Entwicklungsstand bestanden.

Aktuelle Fähigkeit:

- Missionen entstehen aus klassifizierten Kampagnendaten.
- FOB-Support wird berücksichtigt.
- 10 verfügbare Missionen werden erzeugt.
- Missionen enthalten Objectives, Briefings, Progress, Activation Metadata, Outcome State und Effect State.
- Missionen können über F10 direkt angezeigt werden.
- Missionen können über F10 direkt aktiviert werden.
- Missionen können über F10 state-only abgeschlossen werden.
- aktivierte Missionen bleiben state-only.
- abgeschlossene Missionen bleiben state-only.
- Spawn-Hooks bleiben reserved.
- Mission Effects werden vorbereitet.
- CaptureSystem verarbeitet abgeschlossene Mission Effects.
- Capture Ready kann entstehen und über F10 angezeigt werden.

Nächster sinnvoller Schritt:

```text
kontrollierter state-only Ownership-Wechsel aus Capture Ready Zone 1
```

Danach:

- Failure-Pfad praktisch testen
- Persistence-Sandbox-Test vorbereiten
- Logistics-/AI-/IADS-Effects später schrittweise anbinden
