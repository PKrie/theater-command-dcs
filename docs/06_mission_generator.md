# Mission Generator

Diese Datei beschreibt den Mission Generator von **Theater Command DCS**.

## Verbindlicher Diagnose-Stand — 2026-09-12

MissionGenerator `v0.2.3` erzeugt 10 Mission Records. Die Collections `available`, `active`, `completed`, `failed`, `expired` und `cancelled` sind String-keyed Lua-Dictionaries mit Keys wie `MISSION_1`, `MISSION_2`, ... Der Lua-Längenoperator `#table` ist für diese Dictionaries NICHT autoritativ.

Live bestätigt:

- `TC.State.Missions.statistics.available = 10`
- `pairs()`-Count von `available` = `10`
- `#TC.State.Missions.available = 0`

Damit wurde der am 2026-08-04 angenommene Mission-Record-Verlust widerlegt. Die Mission Records waren vorhanden. Der tatsächliche Source-Bug lag in `src/core/tc_state.lua` -> `State.summary()`, wo Mission-Dictionaries teilweise mit `#` gezählt wurden. Fix: pairs-basierte Hilfsfunktion `countEntries()`. Commit: `Fix mission dictionary counts in state summary` (SHA siehe `git log`). Der Fix wurde committed, gepusht, neu eingebettet und live getestet. Eine repo-weite READ-ONLY Prüfung fand keine weiteren entsprechenden falschen `#`-Counts auf Mission-State-Dictionaries. MissionGenerator selbst verwendet in seinen relevanten Dictionary-Zählungen bereits pairs-basierte Logik.

Das Offline Embedded Mission Resource Audit ist abgeschlossen: DEV und MCP_TEST waren beim Audit byte-identisch, 13/13 relevante aktive Theater-Command-Ressourcen waren `EXACT_MATCH` zum Repository, keine aktive Embedded-Runtime-Drift — MissionGenerator-Runtime-Drift ist damit als Ursache ausgeschlossen. Eine bekannte Altressource (`ResKey_Action_55` / `tc_persistence_system.lua`) liegt weiterhin verwaist in der `.miz`, ist nicht referenziert, nicht geladen, nicht ursächlich und eine separate spätere Cleanup-Aufgabe — sie ist kein MissionGenerator-Blocker.

### Historischer Befund vom 2026-08-04 — am 2026-09-12 widerlegt

Der folgende Befund war der damalige Wissensstand und führte zum Offline-Audit. Er wird als historische Evidenz erhalten, gilt aber nicht mehr als aktueller Defekt.

- Der erste Persistence-Snapshot enthielt zehn verfügbare Missionen, eine `generationHistory`-Entry, `lastMissionId=10` und `lastGenerationTime=22.801`.
- Spätere Runtime-Inspektionen fanden `available`, `active`, `completed`, `failed`, `expired` und `cancelled` leer.
- `lastMissionId` blieb `10`; Statistiken blieben stale mit `total=10`, `available=10`.
- Der Verlust wurde in einem zweiten normalen Missionslauf reproduziert: Ein Gate sah zehn Missionen, eine spätere Baseline null.
- Eine Diagnoseabfrage meldete zugleich `pairs=0` und `#=1` für History.

Damalige statische Klassifikation:

```text
PROJECT SOURCE HAS NO MATCHING WRITE SITE
```

Damaliger Verdacht auf Runtime-/Embedded-Ursache und damaliger nächster Schritt: offline/read-only Audit der in `Operation_Levant_Reclamation_DEV.miz` eingebetteten Theater-Command-Ressourcen.

### Auflösung am 2026-09-12

- Mission Records waren nie verloren.
- `#` war das falsche Diagnoseinstrument für diese String-keyed Dictionaries.
- `pairs()` bestätigte 10 Records.
- Der `State.summary()`-Bug wurde gefunden und behoben.
- Embedded Resource Audit: 13/13 `EXACT_MATCH`, keine aktive Embedded-Runtime-Drift.
- Die ursprüngliche Klassifikation `PROJECT SOURCE HAS NO MATCHING WRITE SITE` bleibt nur historischer Diagnosekontext, nicht aktueller Projektstatus.
- Ursache/Writer/Mechanismus sind nicht mehr "ungeklärt", weil kein echter Record-Loss existierte.

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

Historischer Baseline-Stand: **2026-07-06**. Der verbindliche aktuelle Stand steht oben (2026-09-12).

Aktive Datei:

```text
src/missions/tc_mission_generator.lua
```

Getestete Version:

```text
v0.2.3
```

Status:

- **bestanden für den aktuellen state-first Funktionsumfang**

Bestätigt durch DCS-Logtests:

- MissionGenerator lädt.
- MissionGenerator startet.
- MissionGenerator nutzt Airbase-, Zone-, Capture-, Logistics- und FOB-Daten.
- MissionGenerator erzeugt 10 Mission Records.
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
- Mission Details funktionieren.
- Mission Activation funktioniert.
- Mission Completion funktioniert.
- Mission Failure funktioniert.
- Mission Effects funktionieren.
- Completed Mission Effects können Capture Pressure erzeugen.
- Failed Mission Effects erzeugen aktuell bewusst keinen Capture Pressure.
- Aktivierung bleibt state-only.
- Completion bleibt state-only.
- Es gab keinen Theater-Command-Lua-Fehler.
- Es gab keinen Lua-Stacktrace.

Allgemeine MissionGenerator-Dirty-Coverage bleibt in Priority 3 noch offen (siehe Abschnitt 42).

---

## 3. Bestätigte Werte

MissionGenerator-Werte:

```text
mission candidates: 78
fobSupportCandidates: 2
generated missions: 10
reservedCreated: 1
duplicatesSkipped: 1
typeLimitSkipped: 68
```

Aktuelle Dictionary-Bestätigung (2026-09-12):

```text
statistics.available=10
pairs available=10
#available=0
```

Aktuelle F10-Bestätigung:

```text
F10 Commands: 33
Mission Details Slots 1–10 bestätigt
Mission Activation Slots 1–10 bestätigt
Active Mission Outcome Status bestätigt
Complete Active Mission 1 bestätigt
Fail Active Mission 1 bestätigt
Capture Status bestätigt
Capture Ready Zones bestätigt
Apply Capture Ready Zone 1 bestätigt
Pressure Contested Zones bestätigt
```

F10Menu: `v0.2.3`.

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

### Mission Completion Regression — 2026-09-12

Nach Activation + Completion:

```text
available=9
active=0
completed=1
failed=0
statistics.available=9
statistics.active=0
statistics.completed=1
total=10
```

Persistence: `SAVED`, `dirtyReason=f10_active_mission_1_completed`, `dirtyCleared=true`, `productiveRestore=false`.

Diese Werte bestätigen, dass Status-Transition und Dictionary-Move korrekt funktionieren.

### Mission Failure Regression — 2026-09-12

Nach Failure:

```text
available=8
active=0
completed=1
failed=1
statistics.available=8
statistics.active=0
statistics.completed=1
statistics.failed=1
total=10
```

Persistence: `SAVED`, `dirtyReason=f10_active_mission_1_failed`, `dirtyCleared=true`, `productiveRestore=false`.

Mission Failure: Outcome `FAILED`, Effects `prepared`, CaptureSystem `applied=0`, kein Capture Pressure. Damit ist der Failure-Pfad bestätigt.

### Capture Ready Apply als nachgelagerter Mission-Effekt

Kette: Completion von MissionGenerator -> Mission Effects -> CaptureSystem -> Capture Pressure -> Capture Ready -> Capture Ready Apply.

Bestätigter Zielpfad: `ZONE_AIRBASE_ABU_AL_DUHUR`. Vor Apply: `RED -> BLUE`, Progress `100 %`. Danach: `zoneOwner=BLUE`, `previousOwner=RED`, `baseOwner=BLUE`, `progress=0`, `status=STABLE`, `captureReady=false`. Persistence: `SAVED`, `dirtyReason=f10_capture_ready_zone_1_applied`, `dirtyCleared=true`.

Damit ist die MissionGenerator -> CaptureSystem-Wirkungskette erneut bestätigt. Der Ownership-Wechsel selbst wird von CaptureSystem ausgeführt, nicht von MissionGenerator (siehe Abschnitt 8).

Bewertung:

- MissionGenerator `v0.2.3` ist für den aktuellen state-first Funktionsumfang bestätigt; der frühere Record-Loss-Verdacht ist widerlegt.
- Missionen sind fachlich deutlich stärker modelliert als im ersten Stand.
- Missionen können über F10 direkt ausgewählt, aktiviert, abgeschlossen und fehlgeschlagen werden.
- Mission Completion erzeugt vorbereitete Mission Effects.
- CaptureSystem kann diese Mission Effects verarbeiten.
- Missionen lösen weiterhin keine echten Spawns aus.
- Allgemeine MissionGenerator-Dirty-Coverage ist noch nicht abgeschlossen (Priority 3).

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
- Mission Completion ist am 2026-09-12 erneut live bestätigt.
- Mission Failure ist am 2026-09-12 erneut live bestätigt.
- Capture Ready Apply ist am 2026-09-12 erneut live bestätigt.
- Completed Mission Effects -> Capture Pressure funktioniert.
- Failed Mission Effects -> kein Capture Pressure funktioniert.

Architekturgrenze:

- MissionGenerator erzeugt Outcome und Effects.
- CaptureSystem verarbeitet die Capture-Wirkung und führt den Ownership-Wechsel selbst aus. MissionGenerator führt den Ownership-Wechsel nicht selbst durch.

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
ACTIVE -> FAILED
```

Bestätigt über F10:

- Mission aktiviert
- Mission abgeschlossen
- Mission fehlgeschlagen

Noch offen:

- `CANCELLED`
- `EXPIRED`
- automatische DCS-Event-Auswertung
- Missionserfolg auf Logistics oder AI anwenden
- Missionserfolg auf IADS anwenden

---

## 27. Mission Activation

Missionen können aktuell über F10 aktiviert werden.

F10Menu `v0.2.3` bietet:

- `Show Available Missions`
- `Show Active Missions`
- `Show Mission 1 Details` bis `Show Mission 10 Details`
- `Activate Mission 1` bis `Activate Mission 10`

Bestätigt:

- Slots 1 bis 10 sind direkt aktivierbar.
- MissionGenerator setzt aktivierte Missionen auf `ACTIVE`.
- Aktivierung erzeugt `stateOnly=true`.
- Aktivierung erzeugt `spawnHooks=reserved`.
- Activation ist funktional bestätigt.

Aktuelle Einschränkung:

- Mission Activation bedeutet noch nicht, dass DCS-Einheiten gespawnt werden.
- Mission Activation ist aktuell eine State-Änderung.
- Mission Activation wird hier nur dann als Dirty-persistence-validiert dargestellt, wenn dafür explizite Evidenz in `TASKS.md`/den übrigen Docs vorliegt; aus der funktionalen Activation allein wird kein Dirty-Testergebnis abgeleitet.

---

## 28. Mission Outcome

Mission Outcome Controls sind seit F10Menu `v0.2.3` praktisch testbar.

Aktuelle F10-Funktionen:

- `Show Active Mission Outcome Status`
- `Complete Active Mission 1`
- `Fail Active Mission 1`

Bestätigt:

- `Show Active Mission Outcome Status`
- `Complete Active Mission 1` -> `COMPLETED`, Effects `prepared`
- `Fail Active Mission 1` -> `FAILED`, Effects `prepared`
- MissionGenerator setzt aktive Mission 1 auf `COMPLETED` bzw. `FAILED`.
- MissionGenerator bereitet Mission Effects state-only vor.
- CaptureSystem verarbeitet abgeschlossene Mission Effects.
- `FAILED` erzeugt aktuell bewusst keinen Capture Pressure.

Noch offen:

- `CANCELLED`
- `EXPIRED`
- automatische Outcome-Erkennung aus DCS-Events

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

F10Menu `v0.2.3` ist der aktuelle Spielerzugang zum Mission Generator.

Commands: `33`.

Bestätigte F10-Funktionen:

- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Mission Details 1–10 anzeigen
- Activation 1–10
- Active Mission Outcome Status anzeigen
- aktive Mission 1 auf `COMPLETED` setzen (Complete Active Mission 1)
- aktive Mission 1 auf `FAILED` setzen (Fail Active Mission 1)
- Capture Status anzeigen
- Capture Ready Zones anzeigen
- Apply Capture Ready Zone 1
- Pressure Contested Zones anzeigen
- Logistics Status anzeigen
- FOB Status anzeigen
- AI CAP Status anzeigen

Keine Persistence Save/Load Controls im F10-Menü.

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
- dirty-aware Persistence ist technisch bestanden; Priority 3 allgemeine Dirty-Coverage ist noch nicht abgeschlossen
- produktiver Restore bleibt deaktiviert
- echte Framework-Ausführung bleibt weiterhin ein späterer Schritt

Aktuelle Entscheidung:

State-first bleibt vor echter Framework-Ausführung. MissionGenerator bleibt aus Architekturgründen state-only, nicht wegen eines Record-Loss-Defekts.

---

## 37. Nächster MissionGenerator-Schritt

Kein MissionGenerator-Code-Fix ist aktuell aus dem widerlegten Record-Loss abzuleiten. MissionGenerator ist funktional für den aktuellen state-first Stand bestätigt.

Allgemeine MissionGenerator-Dirty-Coverage bleibt in Priority 3 offen. Die Reihenfolge von Priority 3 ist:

1. `src/logistics/tc_logistics_delivery.lua`
2. `src/logistics/tc_fob_system.lua`
3. `src/missions/tc_mission_generator.lua`
4. `src/ai/tc_ai_cap_manager.lua`

Damit ist MissionGenerator NICHT der nächste technische Arbeitsschritt. Wenn MissionGenerator später an der Reihe ist: zuerst ein READ-ONLY Dirty-Coverage-Audit, keine Codeänderung ohne konkreten belegten Befund.

---

## 38. Nächster Gesamtprojektschritt

Priority 3 fortsetzen. Der nächste einzelne technische Schritt ist ein READ-ONLY Dirty-Coverage-Audit von `src/logistics/tc_logistics_delivery.lua`. MissionGenerator folgt erst später, gemäß der Priority-3-Reihenfolge (siehe Abschnitt 37).

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
- Failure Effects werden falsch interpretiert
- falsche Dictionary-Zählung bei String-keyed State-Collections

Persistence-Risiko: Solange die MissionGenerator-Dirty-Coverage noch nicht vollständig auditiert ist (Priority 3), bleibt "Persistence speichert inkonsistente Mission States" ein allgemeines Risiko — es ist kein belegter aktueller Fehler.

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
- `pairs()`-basierte Counts für Mission-State-Dictionaries; `#` wird für diese Collections nicht verwendet

---

## 40. Aktuelle Akzeptanzkriterien

Bestanden:

- MissionGenerator lädt.
- MissionGenerator startet.
- 78 Mission Candidates.
- 2 FOB-Support-Candidates.
- 10 Mission Records.
- mindestens eine FOB-Support-Mission reserviert.
- Mission Details.
- Mission Activation.
- `AVAILABLE -> ACTIVE`.
- `ACTIVE -> COMPLETED`.
- `ACTIVE -> FAILED`.
- `stateOnly`.
- reserved Spawn Hooks.
- Effects prepared.
- Completion -> Capture Pressure.
- Failure -> kein Capture Pressure.
- Capture Ready entsteht.
- Capture Ready sichtbar.
- Capture Ready Apply nachgelagert bestanden.
- keine Lua-/TC-Fehler.

Noch offen:

- `CANCELLED`
- `EXPIRED`
- automatische DCS-Event-Auswertung
- Mission Effects auf Logistics
- Mission Effects auf AI
- Mission Effects auf IADS
- echte MOOSE-/CTLD-/Skynet-Ausführung
- allgemeine MissionGenerator-Dirty-Coverage
- produktiver Restore von Mission State

Der Embedded Resource Audit ist NICHT mehr offen. Der Record-Loss-Verdacht ist NICHT mehr offen.

---

## 41. Aktueller getesteter Systemstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | Read-Dirty und Ownership-No-Op bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | `SAVED`/`SKIPPED`/`FAILED`/Retry + Campaign-Persistence-Regressionen bestanden; `productiveRestore=false` |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | funktional bestanden; nächster Priority-3-Audit |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | funktional bestanden; Dirty-Coverage noch offen |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | state-only Activation, Completion, Failure und Effects bestanden; Record-Loss-Verdacht widerlegt; allgemeine Dirty-Coverage noch offen |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | state-first bestanden; `reactToActiveMissions` Sonderfall bewertet; allgemeine Dirty-Coverage offen |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden, 33 Commands |

---

## 42. Aktueller Status

MissionGenerator `v0.2.3` ist für den aktuellen state-first Funktionsumfang bestätigt. Der frühere Record-Loss-Verdacht ist widerlegt (siehe Verbindlicher Diagnose-Stand oben).

Aktuelle Fähigkeiten:

- erzeugt 10 Mission Records
- String-keyed Dictionary-Struktur korrekt bestätigt (`pairs()`-Count `10`, `#` nicht autoritativ)
- Objectives
- Briefings
- Progress
- Activation Metadata
- Outcome State
- Effect State
- FOB Support
- Mission Details
- Activation
- Completion
- Failure
- Effects
- Completion -> Capture Pressure
- Failure -> kein Capture Pressure
- reserved Framework Hooks
- keine echten Framework-Spawns

Allgemeine MissionGenerator-Dirty-Coverage: noch offen (Priority 3).

### Priority 3

Priority 3 Dirty-Coverage ist NICHT abgeschlossen.

Bereits geklärt:

- Capture Getter/Derived Dirty
- Capture Ownership No-Op
- `reactToActiveMissions()` Sonderfall

Noch zu prüfen:

1. `src/logistics/tc_logistics_delivery.lua`
2. `src/logistics/tc_fob_system.lua`
3. `src/missions/tc_mission_generator.lua`
4. `src/ai/tc_ai_cap_manager.lua`

Für MissionGenerator bedeutet das: funktional bestätigt ist NICHT dasselbe wie vollständige Dirty-Coverage bestätigt.

### Persistence-Grenze (MissionGenerator)

Bestätigt:

- Completion setzt Dirty.
- Failure setzt Dirty.
- jeweiliger Autosave `SAVED`.
- spezifische `dirtyReason`.
- `dirtyCleared=true`.

Noch NICHT vollständig bestätigt:

- allgemeine MissionGenerator-Dirty-Coverage
- alle möglichen Mutationspfade
- `CANCELLED`
- `EXPIRED`
- zukünftige automatische DCS-Event-Transitions

Die gesamte MissionGenerator-Persistence gilt damit nicht als vollständig auditiert.

Nächster Projektschritt:

NICHT MissionGenerator, sondern der READ-ONLY Dirty-Coverage-Audit von `src/logistics/tc_logistics_delivery.lua` (siehe Abschnitt 38).
