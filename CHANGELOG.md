# CHANGELOG.md

Alle relevanten Änderungen am Projekt **Theater Command DCS** werden in dieser Datei dokumentiert.

Das Projekt befindet sich weiterhin in der frühen Aufbauphase. Die erste vollständig spielbare dynamische Kampagne ist noch nicht fertig, aber die technische Runtime-Grundlage läuft inzwischen stabil im DCS Mission Scripting Environment.

---

## Unreleased

### Projektstand

Stand: **2026-07-06**

Erste Kampagne:

- **Operation Levant Reclamation**

Map:

- **Syria**

Ausgangslage:

- Blue startet auf **Akrotiri / Zypern**
- Das syrische Festland ist zu Beginn rot kontrolliert
- Blue soll sich vom Brückenkopf Zypern aus auf das syrische Festland vorarbeiten
- Red hält zu Beginn den Großteil der strategischen Flugplätze
- Spieler sollen sich in eine laufende Kampagne einklinken, nicht jede Aktion allein auslösen
- Perspektivisch sollen Blue und Red eigene Operationen durchführen

Aktueller technischer Stand:

- Vendor-Frameworks werden im DCS Mission Scripting Environment geladen.
- Theater-Command-Source-Dateien werden per sicherer Einzeldatei-Ladung im Mission Editor geladen.
- `src/main.lua` initialisiert die aktiven Runtime-Systeme.
- `src/loader.lua` prüft Framework-Verfügbarkeit und startet Main.
- Die Kernsysteme laufen in DCS ohne Theater-Command-Lua-Abbruch.
- Die Syria-Airbase-Daten werden fachlich klassifiziert.
- ZoneFactory, CaptureSystem, LogisticsDelivery, FobSystem, MissionGenerator, AICapManager und F10Menu nutzen inzwischen den klassifizierten Kampagnenzustand.
- Das F10-Menü unterstützt direkte Missionsauswahl für Mission 1 bis Mission 10.
- Das F10-Menü unterstützt direkte Missionsaktivierung für Mission 1 bis Mission 10.
- Das F10-Menü zeigt Capture-/Pressure-Statusinformationen an.
- Das F10-Menü unterstützt Mission Outcome Controls für die erste aktive Mission.
- Der MissionGenerator erzeugt erweiterte Mission Records mit Objectives, Briefing, Progress, Activation Metadata, Outcome State, Effect State und reservierten Spawn-Hooks.
- Missionen können state-only aktiviert werden.
- Missionen können state-only auf `COMPLETED` gesetzt werden.
- Mission Effects werden state-only vorbereitet.
- Das CaptureSystem erzeugt Capture-Pressure- und Progress-Records für capture-fähige Zonen.
- Abgeschlossene Mission Effects werden durch das CaptureSystem state-only in Capture Pressure übernommen.
- Mission Completion kann jetzt Capture Progress erzeugen.
- Capture Ready kann dynamisch entstehen.
- Main und Loader starten sauber durch.

Aktuelle Einschränkung:

- Das Projekt ist noch keine fertige spielbare dynamische Kampagne.
- Echte MOOSE-Spawns sind noch nicht aktiv.
- CTLD ist geladen, aber noch nicht produktiv mit Theater Command verbunden.
- Skynet IADS ist geladen, aber noch nicht über ein eigenes Theater-Command-IADS-Modul integriert.
- Persistenz ist vorbereitet, aber noch nicht praktisch im DCS-Dateisystem getestet.
- AI Director für beidseitige Blue-vs-Red-Kampagnenlogik ist noch nicht implementiert.
- Missionserfolg und Missionsfehlschlag werden noch nicht automatisch aus DCS-Events ausgewertet.
- Mission Effects werden bisher nur auf Capture Pressure angewendet.
- Mission Effects werden noch nicht produktiv auf Logistics, AI oder IADS angewendet.
- Capture Ready führt noch nicht automatisch produktiv zu Ownership-Wechseln.
- Capture-Druck führt noch nicht automatisch produktiv zu realen Kampagnenfolgen.

---

## Aktueller getesteter Systemstand

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

## Added

### CaptureSystem verarbeitet abgeschlossene Mission Effects

Datei:

- `src/campaign/tc_capture_system.lua`

Version:

- `v0.2.2`

Neu:

- abgeschlossene Missionen aus dem MissionGenerator werden erkannt
- vorbereitete Mission Effects werden state-only in Capture Pressure übernommen
- `applyCompletedMissionEffects()` verarbeitet abgeschlossene Missionen
- `applyMissionEffect()` überträgt Mission Pressure auf die Zielzone
- `updateCaptureProgress()` verarbeitet abgeschlossene Mission Effects automatisch, sofern nicht deaktiviert
- `getCaptureSummary()` zeigt angewendete Mission Effects
- `getPressureSummary()` aktualisiert Mission Effects und Capture Progress
- `getCaptureReadyZones()` kann nach Mission Completion dynamisch Capture Ready Zones sichtbar machen
- `getPressureContestedZones()` kann dynamisch Pressure Contested Zones sichtbar machen
- Mission Effects werden als angewendet markiert, damit sie nicht mehrfach verarbeitet werden
- `appliedMissionEffects` wird hochgezählt
- Capture Ready bleibt state-only
- produktiver Ownership-Wechsel bleibt deaktiviert, solange `autoCapture` nicht ausdrücklich aktiviert wird
- keine echten MOOSE-Spawns
- keine CTLD-Aktion
- keine Skynet-Aktion

Bestätigter Testpfad:

1. Mission 1 Details über F10 angezeigt
2. Mission 1 über F10 aktiviert
3. Active Mission Outcome Status über F10 angezeigt
4. Active Mission 1 über F10 auf `COMPLETED` gesetzt
5. Capture Status über F10 angezeigt
6. Pressure Contested Zones über F10 angezeigt
7. CaptureSystem verarbeitet abgeschlossene Mission Effects
8. Capture Progress wird aktualisiert

Bestätigte Testwerte nach Mission Completion:

- completed mission: `MISSION_2`
- target zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- capture pressure owner: `BLUE`
- applied pressure: 105
- progress: 100 %
- appliedMissionEffects: 1
- ready: 1
- contested: 0

Bestätigte Logmarker:

- `[TC] [CaptureSystem] Loaded src/campaign/tc_capture_system.lua v0.2.2`
- `[TC] [MissionGenerator] Mission outcome prepared: MISSION_2 [COMPLETED] stateOnly=true effects=prepared`
- `[TC] [CaptureSystem] Capture pressure added: zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE amount=105 progress=100%`
- `[TC] [CaptureSystem] Mission effect applied to capture: mission=MISSION_2 zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE pressure=105`
- `[TC] [CaptureSystem] Completed mission effects processed: applied=1, skipped=0, failed=0, appliedMissionEffects=1`
- `[TC] [CaptureSystem] Capture progress updated: zones=32, ready=1, contested=0, appliedMissionEffects=1`
- `[TC] [F10Menu] Capture status shown through F10`
- `[TC] [F10Menu] Pressure contested zones shown through F10`

Bewertung:

- CaptureSystem `v0.2.2` ist bestanden.
- Die Verbindung `Mission Outcome -> Mission Effect -> Capture Pressure -> Capture Progress` funktioniert.
- `Capture Ready` wird erstmals dynamisch sichtbar.
- Mission Completion erzeugt jetzt einen beobachtbaren Capture-Effekt.
- Der Effekt bleibt state-only.
- Es gab keine Lua-Scripting-Fehler.
- Es gab keine Theater-Command-Fehler.
- Es gab keinen Lua-Stacktrace.
- Es wurden keine echten MOOSE-, CTLD- oder Skynet-Aktionen ausgelöst.

Hinweis:

- Im Test wurde `Show Capture Ready Zones` nach Mission Completion noch nicht gezielt ausgelöst.
- `ready=1` ist im Capture Progress bestätigt.
- Der F10-Pfad für Capture Ready Zones existiert bereits und sollte im nächsten Regressionstest gezielt geprüft werden.

---

### F10 Mission Outcome Controls

Datei:

- `src/ui/tc_f10_menu.lua`

Version:

- `v0.2.2`

Neu:

- neues F10-Untermenü `Mission Outcome`
- `Show Active Mission Outcome Status`
- `Complete Active Mission 1`
- `Fail Active Mission 1`
- Anzeige aktiver Missionen bleibt erhalten
- Missionsdetails zeigen zusätzlich Progress-, Outcome- und Effect-State-Daten
- Mission Completion kann über F10 praktisch getestet werden
- Mission Effects werden nach Completion state-only vorbereitet
- F10Menu schreibt Outcome-relevante UI-Daten in `TC.State.UI`
- F10Menu bleibt weiterhin state-first
- F10Menu löst keine echten MOOSE-Spawns aus
- F10Menu löst keine echten CTLD-Aktionen aus
- F10Menu löst keine echten Skynet-Aktionen aus

Bestätigte neue F10-Funktionen:

- `Theater Command > Missions > Mission Outcome > Show Active Mission Outcome Status`
- `Theater Command > Missions > Mission Outcome > Complete Active Mission 1`
- `Theater Command > Missions > Mission Outcome > Fail Active Mission 1`

Bestätigte F10-Command-Zahl:

- vorher: 29 Commands
- jetzt: 32 Commands

Bestätigte Logmarker:

- `[TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.2`
- `[TC] [F10Menu] F10 menu started`
- `[TC] [F10Menu] F10 menu initialized: commands=32`
- `[TC] [F10Menu] Mission details shown through F10: slot=1 key=MISSION_2`
- `[TC] [F10Menu] Mission activated through F10: slot=1 key=MISSION_2`
- `[TC] [F10Menu] Active mission outcome status shown through F10`
- `[TC] [F10Menu] Mission completed through F10: slot=1 key=MISSION_2 stateOnly=true effects=prepared`
- `[TC] [F10Menu] Capture status shown through F10`
- `[TC] [F10Menu] Pressure contested zones shown through F10`
- `[TC] System started: F10 Menu`

Bewertung:

- F10Menu `v0.2.2` ist bestanden.
- Das F10-Menü ist sichtbar und initialisiert sauber.
- Die direkte Missionsauswahl funktioniert weiterhin.
- Die direkte Missionsaktivierung funktioniert weiterhin.
- Mission Completion ist über F10 praktisch getestet.
- Mission Effects werden state-only vorbereitet.
- Capture-Effekt nach Mission Completion ist über F10 beobachtbar.
- Es gab keine Lua-Scripting-Fehler.
- Es gab keine Theater-Command-Fehler.
- Es gab keinen Lua-Stacktrace.
- Es wurden keine echten Spawns oder externen Framework-Aktionen ausgelöst.

Hinweis:

- `Fail Active Mission 1` ist im Code vorbereitet, aber noch nicht praktisch logbestätigt.
- Der Completion-Pfad ist praktisch bestanden.
- Der Failure-Pfad sollte in einem späteren Regressionstest gezielt geprüft werden.

---

### Mission Generator State-only Outcomes

Datei:

- `src/missions/tc_mission_generator.lua`

Version:

- `v0.2.3`

Neu:

- Mission Records enthalten Outcome-Daten.
- Mission Records enthalten Effect-State-Daten.
- Missionen können state-only auf `COMPLETED` gesetzt werden.
- Missionen können state-only auf `FAILED` gesetzt werden.
- Missionen können state-only auf `CANCELLED` gesetzt werden.
- Missionen können state-only auf `EXPIRED` gesetzt werden.
- `completeMission()` ist praktisch über F10 getestet.
- `failMission()` ist vorbereitet.
- `cancelMission()` ist vorbereitet.
- `expireMission()` ist vorbereitet.
- `prepareMissionEffects()` ist vorbereitet.
- `applyMissionCompletionEffect()` bleibt state-only vorbereitet.
- Mission Outcome History wird im State vorbereitet.
- Effect History wird im State vorbereitet.
- vorbereitete Effekte enthalten Zielbezüge für Capture, Logistics, AI und IADS.
- echte Framework-Ausführung bleibt deaktiviert.

Bestätigte Testwerte:

- mission candidates: 78
- fobSupportCandidates: 2
- generated missions: 10
- reservedCreated: 1
- duplicatesSkipped: 1
- typeLimitSkipped: 68

Bestätigte MissionGenerator-/F10-Interaktion:

- Mission Details Slot 1 bestätigt.
- Mission Slot 1 aktiviert.
- MissionGenerator setzt Mission Slot 1 auf `ACTIVE`.
- Aktivierung erzeugt `stateOnly=true`.
- Aktivierung erzeugt `spawnHooks=reserved`.
- aktive Mission 1 wurde über F10 auf `COMPLETED` gesetzt.
- MissionGenerator erzeugt `Mission effects prepared state-only`.
- MissionGenerator erzeugt `Mission outcome prepared`.
- Outcome bleibt `stateOnly=true`.
- Effects bleiben zunächst `prepared`.
- CaptureSystem v0.2.2 übernimmt den vorbereiteten Effekt anschließend state-only in Capture Pressure.

Bestätigte Logmarker:

- `[TC] [MissionGenerator] Loaded src/missions/tc_mission_generator.lua v0.2.3`
- `[TC] [MissionGenerator] Mission generator started`
- `[TC] [MissionGenerator] Mission candidate summary: candidates=78, fobSupportCandidates=2, availableBefore=0, generationSlots=10`
- `[TC] [MissionGenerator] Mission generation completed: 10 new missions from 78 candidates (fobSupportCandidates=2, reservedCreated=1, duplicatesSkipped=1, typeLimitSkipped=68)`
- `[TC] [MissionGenerator] Mission generator ready`
- `[TC] [MissionGenerator] Mission status changed: MISSION_2 [ACTIVE]`
- `[TC] [MissionGenerator] Mission activation prepared: MISSION_2 stateOnly=true spawnHooks=reserved`
- `[TC] [MissionGenerator] Mission effects prepared state-only: MISSION_2 status=COMPLETED`
- `[TC] [MissionGenerator] Mission outcome prepared: MISSION_2 [COMPLETED] stateOnly=true effects=prepared`

Bewertung:

- MissionGenerator `v0.2.3` ist bestanden.
- Mission Activation ist weiterhin stabil.
- Mission Completion ist state-only praktisch getestet.
- Mission Effects werden vorbereitet.
- Mission Effects können jetzt vom CaptureSystem verarbeitet werden.
- Es werden weiterhin keine echten DCS-Spawns ausgelöst.
- Es gab keinen Theater-Command-Lua-Fehler und keinen Lua-Stacktrace.

Hinweis:

- Die Kandidatenzahl ist von 69 auf 78 gestiegen.
- Das ist aktuell kein Fehler, weil weiter nur 10 Missionen erzeugt werden.
- Die höhere Kandidatenzahl entsteht durch die erweiterte Missions- und Outcome-Struktur und muss weiter beobachtet werden.

---

### F10 Menu Capture-/Pressure-Status

Datei:

- `src/ui/tc_f10_menu.lua`

Version:

- `v0.2.1`

Neu:

- `Show Capture Status` wurde im F10-Menü ergänzt.
- `Show Capture Ready Zones` wurde im F10-Menü ergänzt.
- `Show Pressure Contested Zones` wurde im F10-Menü ergänzt.
- Capture-/Pressure-Status wird aus dem vorhandenen CaptureSystem-State gelesen.
- Capture Ready Zones können über F10 angezeigt werden.
- Pressure Contested Zones können über F10 angezeigt werden.
- F10Menu schreibt UI-relevante Capture-Informationen weiterhin in `TC.State.UI`.
- F10Menu bleibt weiterhin state-first.
- F10Menu löst keine echten MOOSE-Spawns aus.
- F10Menu löst keine echten CTLD-Aktionen aus.
- F10Menu löst keine echten Skynet-Aktionen aus.

Bestätigte neue F10-Funktionen:

- `Theater Command > Status > Show Capture Status`
- `Theater Command > Status > Show Capture Ready Zones`
- `Theater Command > Status > Show Pressure Contested Zones`

Bestätigte Capture-Statusfelder:

- `eligibleBases`
- `eligibleZones`
- `pressureRecords`
- `progressRecords`
- `captureReady`
- `pressureContested`
- `appliedMissionEffects`

Bestätigte Testwerte im ursprünglichen Startzustand:

- eligibleBases: 32
- eligibleZones: 32
- pressureRecords: 32
- progressRecords: 32
- captureReady: 0
- pressureContested: 0
- appliedMissionEffects: 0

Bestätigte F10-Command-Zahl:

- vorher: 26 Commands
- jetzt: 29 Commands

Bestätigte Logmarker:

- `[TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.1`
- `[TC] [F10Menu] F10 menu started`
- `[TC] [F10Menu] F10 menu initialized: commands=29`
- `[TC] [F10Menu] Capture status shown through F10`
- `[TC] [F10Menu] Capture ready zones shown through F10`
- `[TC] [F10Menu] Pressure contested zones shown through F10`
- `[TC] System started: F10 Menu`

Bewertung:

- F10Menu `v0.2.1` ist für die Capture-/Pressure-Erweiterung bestanden.
- Das F10-Menü ist sichtbar und initialisiert sauber.
- Die drei neuen Capture-/Pressure-Funktionen wurden im DCS-Test ausgelöst.
- Es gab keine Lua-Scripting-Fehler.
- Es gab keine Theater-Command-Fehler.
- Es gab keinen Lua-Stacktrace.
- Es wurden keine echten Spawns oder externen Framework-Aktionen ausgelöst.

---

### F10 Menu direkte Missionsauswahl

Datei:

- `src/ui/tc_f10_menu.lua`

Version:

- `v0.2.0`

Neu:

- direkte Missionsauswahl für Mission 1 bis Mission 10 über F10
- direkte Aktivierung von Mission 1 bis Mission 10 über F10
- Missionsdetails für Mission 1 bis Mission 10
- stabile Sortierung der verfügbaren Missionen
- Anzeige verfügbarer Missionen bleibt erhalten
- Anzeige aktiver Missionen bleibt erhalten
- Kampagnenstatus bleibt erhalten
- Logistikstatus bleibt erhalten
- FOB-Status bleibt erhalten
- AI-CAP-Status bleibt erhalten
- F10-State wird in `TC.State.UI` gespiegelt
- direkte Aktivierung bleibt state-only
- keine echten MOOSE-, CTLD- oder Skynet-Aktionen werden durch das F10-Menü ausgelöst

Bestätigte F10-Menüstruktur:

- `Theater Command`
- `Missions`
- `Mission Details`
- `Activate Mission`
- `Status`
- `Logistics`
- `AI`

Bestätigte Commands:

- 26 F10 Commands erzeugt
- `Show Available Missions`
- `Show Active Missions`
- `Show Mission 1 Details` bis `Show Mission 10 Details`
- `Activate Mission 1` bis `Activate Mission 10`
- `Show Campaign Status`
- `Show Logistics Status`
- `Show FOB Status`
- `Show AI CAP Status`

Bestätigte Logmarker:

- `[TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.0`
- `[TC] [F10Menu] F10 menu started`
- `[TC] [F10Menu] F10 menu initialized: commands=26`
- `[TC] System started: F10 Menu`
- `[TC] [F10Menu] Mission details shown through F10: slot=1 key=MISSION_1`
- `[TC] [F10Menu] Mission activated through F10: slot=1 key=MISSION_1`

Bewertung:

- F10Menu `v0.2.0` ist bestanden.
- Die direkte Missionsauswahl funktioniert.
- Die direkte Missionsaktivierung funktioniert.
- Das Menü bleibt state-only.
- Es gab keinen Theater-Command-Lua-Fehler und keinen Lua-Stacktrace.

---

### Mission Generator Activation State, Objectives und Spawn-Hooks

Datei:

- `src/missions/tc_mission_generator.lua`

Version:

- `v0.2.2`

Neu:

- Mission Records wurden fachlich erweitert.
- Missionen enthalten Objectives.
- Missionen enthalten Briefing-Texte.
- Missionen enthalten Progress-Daten.
- Missionen enthalten Activation Metadata.
- Missionen enthalten Execution Plans.
- MOOSE-, CTLD- und Skynet-Hooks werden reserviert, aber nicht ausgeführt.
- Aktivierte Missionen erhalten `stateOnly=true`.
- Aktivierte Missionen erhalten `spawnHooks=reserved`.
- Missionserfolg kann später in Richtung Capture, Logistics, AI und IADS weiterverarbeitet werden.
- Completion-/Failure-/Cancel-/Expire-Status sind vorbereitet.
- `getMissionBriefing()` ist vorbereitet.
- `getMissionProgress()` ist vorbereitet.
- `updateMissionProgress()` ist vorbereitet.
- `completeMission()` ist vorbereitet.
- `applyMissionCompletionEffect()` ist state-only vorbereitet.

Bestätigte Testwerte:

- mission candidates: 69
- fobSupportCandidates: 2
- generated missions: 10
- reservedCreated: 1
- duplicatesSkipped: 1
- typeLimitSkipped: 30

Bestätigte F10-/MissionGenerator-Interaktion:

- Mission Details Slot 1 bestätigt
- Mission Details Slot 2 bestätigt
- Mission Details Slot 5 bestätigt
- Mission Slot 5 aktiviert
- MissionGenerator setzt Mission Slot 5 auf `ACTIVE`
- Aktivierung erzeugt `stateOnly=true`
- Aktivierung erzeugt `spawnHooks=reserved`

Bestätigte Logmarker:

- `[TC] [MissionGenerator] Loaded src/missions/tc_mission_generator.lua v0.2.2`
- `[TC] [MissionGenerator] Mission generator started`
- `[TC] [MissionGenerator] Mission candidate summary: candidates=69, fobSupportCandidates=2, availableBefore=0, generationSlots=10`
- `[TC] [MissionGenerator] Mission generation completed: 10 new missions from 69 candidates (fobSupportCandidates=2, reservedCreated=1, duplicatesSkipped=1, typeLimitSkipped=30)`
- `[TC] [MissionGenerator] Mission generator ready`
- `[TC] [MissionGenerator] Mission status changed: MISSION_4 [ACTIVE]`
- `[TC] [MissionGenerator] Mission activation prepared: MISSION_4 stateOnly=true spawnHooks=reserved`

Bewertung:

- MissionGenerator `v0.2.2` ist bestanden.
- Missionsaktivierung ist technisch sauber vorbereitet.
- Missionen bleiben state-only.
- Es werden weiterhin keine echten DCS-Spawns ausgelöst.
- Es gab keinen Theater-Command-Lua-Fehler und keinen Lua-Stacktrace.

---

### Capture Pressure und Mission Effects

Datei:

- `src/campaign/tc_capture_system.lua`

Version:

- `v0.2.1`

Neu:

- CaptureSystem verwaltet Capture-Pressure-Records.
- CaptureSystem verwaltet Capture-Progress-Records.
- Capture-Pressure wird pro capture-fähiger Zone vorbereitet.
- Capture-Progress wird pro capture-fähiger Zone vorbereitet.
- Missionseffekte können state-only als Capture-Druck verarbeitet werden.
- Capture-Ready-Zustände werden vorbereitet.
- Pressure-Contested-Zustände werden vorbereitet.
- Completion-Hooks werden vorbereitet, aber nicht produktiv ausgeführt.
- Automatischer produktiver Ownership-Wechsel durch Missionseffekte bleibt deaktiviert.
- Linked Base/Zone Ownership bleibt weiterhin kontrolliert über bestehende State-Funktionen.

Bestätigte Testwerte:

- eligibleBases: 32
- eligibleZones: 32
- nonCaptureBases: 193
- nonCaptureZones: 14
- pressureRecords: 32
- progressRecords: 32
- appliedMissionEffects: 0
- ready: 0
- contested: 0

Bestätigte Logmarker:

- `[TC] [CaptureSystem] Loaded src/campaign/tc_capture_system.lua v0.2.1`
- `[TC] [CaptureSystem] Capture system started`
- `[TC] [CaptureSystem] Capture progress updated: zones=32, ready=0, contested=0`
- `[TC] [CaptureSystem] Capture eligibility summary: bases=32, zones=32, nonCaptureBases=193, nonCaptureZones=14`
- `[TC] [CaptureSystem] Capture pressure summary: pressureRecords=32, progressRecords=32, appliedMissionEffects=0`
- `[TC] [CaptureSystem] Capture system initialized`

Bewertung:

- CaptureSystem `v0.2.1` ist bestanden.
- Capture-Eligibility bleibt stabil.
- Capture wirkt weiterhin nur auf sinnvolle strategische und sekundäre Kampagnenziele.
- Pressure- und Progress-Daten werden sauber erzeugt.
- Missionseffekte sind für spätere Capture-Auswertung vorbereitet.
- Es gab keinen Theater-Command-Lua-Fehler und keinen Lua-Stacktrace.

---

### FOB-System-Anbindung

Datei:

- `src/logistics/tc_fob_system.lua`

Version:

- `v0.2.0`

Neu:

- FOB-System nutzt die Logistics-Hub-Struktur.
- FOB-Kandidaten werden aus freundlichen oder umkämpften Logistics-Hubs abgeleitet.
- automatisch geplante Blue-FOBs werden als State-only-Objekte erzeugt.
- FOBs werden mit Zonen, Basen und Logistics-Hubs verknüpft.
- FOB-Status, Baufortschritt, Versorgung und Support-Delivery-Vorbereitung sind vorhanden.
- spätere CTLD-FOB-Erstellung ist vorbereitet, aber noch nicht aktiv.

Bestätigte Testwerte:

- FOB candidates: 6
- stored candidates: 6
- auto-planned FOBs: 2
- skipped candidates: 4
- erzeugte FOBs:
  - `FOB Ercan`
  - `FOB Gecitkale`
- Status:
  - `UNDER_CONSTRUCTION`
- Blue FOBs: 2

Bewertung:

- FOB-System ist erfolgreich an die Logistics-Hubs angebunden.
- `planned=0` im Summary ist kein Fehler, weil automatisch geplante FOBs durch initialen Baufortschritt direkt in `UNDER_CONSTRUCTION` wechseln.
- Es werden noch keine echten CTLD-FOBs gespawnt.

---

### FOB-Support-Missionen

Datei:

- `src/missions/tc_mission_generator.lua`

Version:

- `v0.2.1`

Neu:

- Mission Generator erkennt FOBs aus dem Logistics-State.
- Mission Generator erzeugt FOB-Support-Kandidaten für geplante oder im Bau befindliche FOBs.
- mindestens eine FOB-Support-Mission wird im verfügbaren Missionspool reserviert.
- FOB-Support wird nicht mehr durch Airbase-Attack-, SEAD-, Strike- oder CAP-Missionen verdrängt.
- Mission Generator unterscheidet weiterhin State-Missionen von echter DCS-Ausführung.

Bestätigte Testwerte:

- mission candidates: 69
- fobSupportCandidates: 2
- generated missions: 10
- reservedCreated: 1
- duplicatesSkipped: 1
- typeLimitSkipped: 30

Bestätigte Missionen:

- `FOB_SUPPORT` für `FOB Ercan`
- `FOB_SUPPORT` für `FOB Gecitkale`

Bewertung:

- FOB-Support ist im Missionssystem sichtbar und priorisiert.
- Mission Generator liefert eine stabilere Grundlage für F10-Missionsauswahl.
- Missionen sind weiterhin State-only und lösen noch keine echten Spawns aus.

---

### Source-Grundstruktur

Erstellt wurden im bisherigen Projektverlauf:

- `src/loader.lua`
- `src/main.lua`
- `src/core/tc_config.lua`
- `src/core/tc_logger.lua`
- `src/core/tc_state.lua`
- `src/core/tc_utils.lua`
- `src/core/tc_scheduler.lua`
- `src/world/tc_airbase_scanner.lua`
- `src/world/tc_zone_factory.lua`
- `src/campaign/tc_capture_system.lua`
- `src/campaign/tc_persistence_system.lua`
- `src/logistics/tc_logistics_delivery.lua`
- `src/logistics/tc_fob_system.lua`
- `src/missions/tc_mission_generator.lua`
- `src/ai/tc_ai_cap_manager.lua`
- `src/ui/tc_f10_menu.lua`

Dokumentierte, aber noch nicht aktiv implementierte Bereiche:

- `src/iads/`
- `src/debug/`

---

### Source-Dokumentation

Erstellt wurden im bisherigen Projektverlauf:

- `src/README.md`
- `src/core/README.md`
- `src/world/README.md`
- `src/campaign/README.md`
- `src/logistics/README.md`
- `src/missions/README.md`
- `src/ai/README.md`
- `src/iads/README.md`
- `src/ui/README.md`
- `src/debug/README.md`

---

### Mission-Editor-Dokumentation

Erstellt wurden:

- `mission_editor/README.md`
- `mission_editor/trigger_setup.md`

Dokumentiert wurde:

- sichere Starttest-Variante A
- spätere Loader-only-Variante B
- DCS-`DO SCRIPT FILE`-Verhalten
- manuelles Neuauswählen geänderter Lua-Dateien im Mission Editor
- Framework-Ladefolge
- Source-Ladefolge für den sicheren Test

---

## Changed

### CaptureSystem von v0.2.1 auf v0.2.2 erweitert

Vorher:

- Capture Pressure und Capture Progress wurden vorbereitet.
- Mission Effects waren strukturell vorhanden.
- `appliedMissionEffects` blieb im Startzustand bei 0.
- Mission Completion erzeugte noch keinen praktisch sichtbaren Capture Progress.

Jetzt:

- abgeschlossene Mission Effects werden automatisch state-only verarbeitet.
- Mission Completion erzeugt Capture Pressure.
- Capture Progress wird nach Mission Completion aktualisiert.
- `appliedMissionEffects` steigt nach dem getesteten Abschluss auf 1.
- `ready` steigt nach dem getesteten Abschluss auf 1.
- Capture Ready ist dynamisch sichtbar.
- Ownership-Wechsel bleibt weiterhin deaktiviert.

Bewertung:

- Der erste echte Kampagnenzusammenhang ist technisch bestätigt:
  - Mission auswählen
  - Mission aktivieren
  - Mission abschließen
  - Mission Effect vorbereiten
  - Capture Pressure anwenden
  - Capture Progress aktualisieren
  - Capture Ready erzeugen

---

### F10-Menü von 29 auf 32 Commands erweitert

Vorher:

- F10Menu `v0.2.1`
- 29 Commands
- Missionsanzeige
- Missionsdetails
- Missionsaktivierung
- Kampagnenstatus
- Capture-/Pressure-Status
- Logistikstatus
- FOB-Status
- AI-CAP-Status

Jetzt:

- F10Menu `v0.2.2`
- 32 Commands
- zusätzliches Untermenü `Mission Outcome`
- `Show Active Mission Outcome Status`
- `Complete Active Mission 1`
- `Fail Active Mission 1`

Bewertung:

- Die UI kann jetzt Mission Outcomes praktisch auslösen.
- Der Completion-Pfad ist praktisch bestätigt.
- Das ist die Grundlage für kontrollierte Capture- und Persistence-Tests.

---

### MissionGenerator von v0.2.2 auf v0.2.3 erweitert

Vorher:

- Missionen konnten aktiviert werden.
- Mission Records enthielten Objectives, Briefing, Progress und Activation Metadata.
- Completion-/Failure-Funktionen waren vorbereitet, aber nicht praktisch über F10 getestet.

Jetzt:

- Missionen enthalten Outcome State.
- Missionen enthalten Effect State.
- Mission Completion ist praktisch über F10 getestet.
- Mission Effects werden state-only vorbereitet.
- Outcome History und Effect History werden vorbereitet.
- Kandidatenzahl steigt auf 78.
- Missionspool bleibt auf 10 erzeugte Missionen begrenzt.
- CaptureSystem kann vorbereitete Mission Effects verarbeiten.

Bewertung:

- Der MissionGenerator ist jetzt ausreichend vorbereitet, um Missionsergebnisse an Kampagnensysteme weiterzugeben.
- Der erste Empfänger ist CaptureSystem.
- Logistics, AI und IADS sind spätere Empfänger.

---

### Aktive Mission-Editor-Ladefolge

Die aktive Ladefolge bleibt die sichere Einzeldatei-Ladung über `DO SCRIPT FILE`.

Vendor-Ladefolge:

1. `vendor/mist/mist.lua`
2. `vendor/moose/Moose.lua`
3. `vendor/ctld/CTLD-i18n.lua`
4. `vendor/ctld/CTLD.lua`
5. `vendor/skynet-iads/SkynetIADS.lua`

Aktive Theater-Command-Ladefolge:

1. `src/core/tc_config.lua`
2. `src/core/tc_logger.lua`
3. `src/core/tc_state.lua`
4. `src/core/tc_utils.lua`
5. `src/core/tc_scheduler.lua`
6. `src/world/tc_airbase_scanner.lua`
7. `src/world/tc_zone_factory.lua`
8. `src/campaign/tc_capture_system.lua`
9. `src/campaign/tc_persistence_system.lua`
10. `src/logistics/tc_logistics_delivery.lua`
11. `src/logistics/tc_fob_system.lua`
12. `src/missions/tc_mission_generator.lua`
13. `src/ai/tc_ai_cap_manager.lua`
14. `src/ui/tc_f10_menu.lua`
15. `src/main.lua`
16. `src/loader.lua`

Wichtig:

- `src/campaign/tc_capture_system.lua` wird vor MissionGenerator, AI CAP Manager, F10Menu und Main geladen.
- `src/ui/tc_f10_menu.lua` wird nach dem AI CAP Manager und vor `src/main.lua` geladen.
- `src/main.lua` bleibt der Runtime-Startpunkt.
- `src/loader.lua` bleibt aktuell die letzte eigene Datei.
- Starttest-Variante B mit Loader-only-`dofile` ist weiterhin offen.

---

### State-first-Architektur bestätigt

Bestätigt wurde erneut:

- Die aktuellen Systeme erzeugen Kampagnenzustand.
- Die aktuellen Systeme lösen noch keine echten DCS-Spawns aus.
- MOOSE, CTLD und Skynet IADS sind geladen, aber noch nicht produktiv über eigene Theater-Command-Brücken angebunden.
- F10-Aktionen beeinflussen aktuell nur den Theater-Command-State.
- Missionen, Capture, Logistics, FOBs, AI und UI sind als State-Systeme miteinander verbunden.
- Capture-/Pressure-Daten sind über F10 beobachtbar.
- Mission Outcomes sind über F10 testbar.
- Mission Effects werden vorbereitet.
- Abgeschlossene Mission Effects werden inzwischen state-only auf Capture Pressure angewendet.

---

## Fixed

### Mission Effects wirkten noch nicht praktisch auf Capture Pressure

Vorher:

- MissionGenerator konnte Mission Effects vorbereiten.
- CaptureSystem konnte Capture Pressure grundsätzlich verwalten.
- Der praktische Übergang von Mission Completion zu Capture Progress war noch nicht bestätigt.

Jetzt:

- Mission Completion erzeugt vorbereitete Mission Effects.
- CaptureSystem verarbeitet abgeschlossene Mission Effects.
- Capture Pressure wird für die Zielzone erhöht.
- Capture Progress wird aktualisiert.
- Capture Ready kann dynamisch entstehen.
- `appliedMissionEffects` steigt auf 1.
- Der Effekt bleibt state-only.

Bewertung:

- Die zentrale Kampagnenkette funktioniert erstmals über mehrere Module hinweg:
  - F10Menu
  - MissionGenerator
  - CaptureSystem
  - State
  - F10 Statusanzeige

---

### Mission Outcomes waren nicht praktisch über F10 testbar

Vorher:

- MissionGenerator konnte Mission Outcome-Funktionen vorbereiten.
- Es gab aber keinen praktischen F10-Testpfad für Completion.
- Mission Effects konnten noch nicht im laufenden DCS-Test sichtbar vorbereitet werden.

Jetzt:

- `Complete Active Mission 1` ist über F10 verfügbar.
- `Show Active Mission Outcome Status` ist über F10 verfügbar.
- aktive Mission 1 wurde praktisch auf `COMPLETED` gesetzt.
- Mission Effects wurden state-only vorbereitet.
- Completion-Logmarker sind bestätigt.

Bewertung:

- Mission Outcome ist jetzt praktisch testbar.
- Der Completion-Pfad ist als Grundlage für Capture-Effekt-Tests geeignet.

---

### Capture-/Pressure-State war über F10 noch nicht sichtbar

Vorher:

- CaptureSystem erzeugte bereits Pressure- und Progress-Records.
- Capture Ready und Pressure Contested waren im State vorbereitet.
- Der Spieler konnte diese Daten aber noch nicht über F10 anzeigen.

Jetzt:

- Capture-/Pressure-Status ist über F10 sichtbar.
- Capture Ready Zones sind über F10 sichtbar.
- Pressure Contested Zones sind über F10 sichtbar.
- F10Menu erzeugt seit v0.2.1 mindestens 29 Commands.
- Die Capture-/Pressure-Statusfunktionen sind logbestätigt.

Bewertung:

- Die UI ist jetzt ausreichend vorbereitet, um Missionsergebnisse und Capture-Effekte direkt im laufenden Test sichtbar zu machen.

---

### F10-Menü war nur Top-Mission-fähig

Vorher:

- F10 konnte nur die Top-Mission aktivieren.
- Einzelne Missionen konnten nicht direkt ausgewählt werden.
- Missionsdetails waren nicht pro Slot abrufbar.

Jetzt:

- Mission 1 bis Mission 10 können direkt ausgewählt werden.
- Mission 1 bis Mission 10 können direkt aktiviert werden.
- Missionsdetails sind pro Slot abrufbar.
- F10Menu erzeugt seit v0.2.0 mindestens 26 Commands.
- Aktivierung schreibt sauber in den MissionGenerator-State.

---

### MissionGenerator hatte noch schwache Aktivierungsdaten

Vorher:

- Missionen konnten aktiv gesetzt werden.
- Aktivierungsdaten, Progress, Objectives und spätere Spawn-Hooks waren noch nicht ausreichend ausmodelliert.

Jetzt:

- Aktivierte Missionen enthalten Activation Metadata.
- Aktivierte Missionen enthalten Progress-Daten.
- Aktivierte Missionen enthalten Execution Plans.
- MOOSE-/CTLD-/Skynet-Hooks sind reserviert.
- Missionen bleiben state-only.
- Missionen enthalten Outcome State.
- Missionen enthalten Effect State.

---

### CaptureSystem hatte noch keine Capture-Pressure-Struktur

Vorher:

- CaptureSystem verwaltete Ownership und Capture-Eligibility.
- Missionseffekte wurden noch nicht als Capture-Druck vorbereitet.
- Capture-Progress war noch nicht pro Zone modelliert.

Jetzt:

- 32 Pressure-Records werden erzeugt.
- 32 Progress-Records werden erzeugt.
- Capture Ready und Pressure Contested sind vorbereitet.
- Missionseffekte können state-only auf Capture-Druck abgebildet werden.
- abgeschlossene Mission Effects können seit v0.2.2 automatisch in Capture Pressure übernommen werden.

---

## Known limitations

Noch offen:

- echte MOOSE-Spawns
- echte CTLD-FOBs
- echte CTLD-Cargo-Flüge
- echte Skynet-IADS-Kampagnenlogik
- produktive Persistenz im DCS-Dateisystem
- AI Director für Blue-vs-Red-Kampagnenentscheidungen
- automatische Missionsauswertung über DCS-Events
- automatische Missionserfolge und Fehlschläge
- praktische Prüfung von `Fail Active Mission 1`
- gezielte Prüfung von `Show Capture Ready Zones` nach Mission Completion
- produktive automatische Capture-Auswertung aus Missionsresultaten
- kontrollierter Ownership-Wechsel aus Capture Ready
- Anwendung vorbereiteter Mission Effects auf Logistics, AI und IADS
- echte Logistik-Auswirkungen auf Capture und Missionen
- eigene Debug-Reports
- eigenes Debug-F10-Menü
- Loader-only-Ladung über `dofile`
- automatische `.miz`-Generierung

---

## Nächster sinnvoller technischer Schritt

Empfohlener nächster Test ohne Codeänderung:

- vorhandenen F10-Pfad nutzen:
  - `Show Mission 1 Details`
  - `Activate Mission 1`
  - `Complete Active Mission 1`
  - `Show Capture Status`
  - `Show Capture Ready Zones`

Ziel:

- bestätigen, dass die Capture Ready Zone nach Mission Completion über F10 sichtbar ist
- erwarteter Zustand:
  - `appliedMissionEffects=1`
  - `ready=1`
  - Zielzone erscheint in Capture Ready Zones

Danach empfohlene nächste Code-Entscheidung:

- entweder kontrollierten Capture-Ownership-Wechsel state-only vorbereiten
- oder `Fail Active Mission 1` praktisch testen und Failure-Effects definieren

Mögliche nächste Code-Datei für kontrollierten Ownership-Wechsel:

- `src/ui/tc_f10_menu.lua`

Mögliches Ziel:

- `Apply Capture Ready Zone 1`
- oder `Confirm Capture Ready Zone 1`
- bewusst state-only
- kein automatischer Ownership-Wechsel ohne F10-/Debug-Bestätigung
- keine echten Spawns
- keine CTLD-Aktion
- keine Skynet-Aktion

Später sinnvoll:

- Persistence-Sandbox-Test vorbereiten
- Debug-F10-Menü getrennt entwickeln
- CTLD-Integration vorbereiten
