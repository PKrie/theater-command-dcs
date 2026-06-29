# CHANGELOG.md

Alle relevanten Änderungen am Projekt **Theater Command DCS** werden in dieser Datei dokumentiert.

Das Projekt befindet sich weiterhin in der frühen Aufbauphase. Die erste vollständig spielbare dynamische Kampagne ist noch nicht fertig, aber die technische Runtime-Grundlage läuft inzwischen stabil im DCS Mission Scripting Environment.

---

## Unreleased

### Projektstand

Stand: **2026-06-29**

Erste Kampagne:

- **Operation Levant Reclamation**
- Map: **Syria**
- Blue startet auf **Akrotiri / Zypern**
- Das syrische Festland ist zu Beginn rot kontrolliert

Aktueller technischer Stand:

- Vendor-Frameworks werden im DCS Mission Scripting Environment geladen.
- Theater-Command-Source-Dateien werden per sicherer Einzeldatei-Ladung im Mission Editor geladen.
- `src/main.lua` initialisiert die aktiven Runtime-Systeme.
- `src/loader.lua` prüft Framework-Verfügbarkeit und startet Main.
- Die Kernsysteme laufen in DCS ohne Theater-Command-Lua-Abbruch.
- Die Syria-Airbase-Daten werden fachlich klassifiziert.
- ZoneFactory, CaptureSystem, LogisticsDelivery, FobSystem, MissionGenerator, AICapManager und F10Menu nutzen inzwischen den klassifizierten Kampagnenzustand.
- Das F10-Menü unterstützt jetzt direkte Missionsauswahl für Mission 1 bis Mission 10.
- Der MissionGenerator erzeugt erweiterte Mission Records mit Objectives, Briefing, Progress, Activation Metadata und reservierten Spawn-Hooks.
- Das CaptureSystem erzeugt Capture-Pressure- und Progress-Records für capture-fähige Zonen.
- Missionseffekte können vorbereitet state-only auf Capture-Druck abgebildet werden.
- Main und Loader starten sauber durch.

Aktuelle Einschränkung:

- Das Projekt ist noch keine fertige spielbare dynamische Kampagne.
- Echte MOOSE-Spawns sind noch nicht aktiv.
- CTLD ist geladen, aber noch nicht produktiv mit Theater Command verbunden.
- Skynet IADS ist geladen, aber noch nicht über ein eigenes Theater-Command-IADS-Modul integriert.
- Persistenz ist vorbereitet, aber noch nicht praktisch im DCS-Dateisystem getestet.
- AI Director für beidseitige Blue-vs-Red-Kampagnenlogik ist noch nicht implementiert.
- Missionserfolg und Missionsfehlschlag werden noch nicht automatisch aus DCS-Events ausgewertet.
- Capture-Druck führt noch nicht automatisch produktiv zu realen Kampagnenfolgen.

---

## Aktueller getesteter Systemstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.1` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | Grundstruktur | lädt/startet |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.2` | bestanden |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.0` | bestanden |

---

## Added

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

- CaptureSystem verwaltet jetzt Capture-Pressure-Records.
- CaptureSystem verwaltet jetzt Capture-Progress-Records.
- Capture-Pressure wird pro capture-fähiger Zone vorbereitet.
- Capture-Progress wird pro capture-fähiger Zone vorbereitet.
- Missionseffekte können state-only als Capture-Druck verarbeitet werden.
- Capture-Ready-Zustände werden vorbereitet.
- Pressure-Contested-Zustände werden vorbereitet.
- Completion-Hooks werden vorbereitet, aber nicht produktiv ausgeführt.
- Automatischer produktiver Ownership-Wechsel durch Missionseffekte bleibt noch deaktiviert.
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
- Missionen, Capture, Logistics, FOBs, AI und UI sind als State-Systeme miteinander vorbereitend verbunden.

---

## Fixed

### F10-Menü war nur Top-Mission-fähig

Vorher:

- F10 konnte nur die Top-Mission aktivieren.
- Einzelne Missionen konnten nicht direkt ausgewählt werden.
- Missionsdetails waren nicht pro Slot abrufbar.

Jetzt:

- Mission 1 bis Mission 10 können direkt ausgewählt werden.
- Mission 1 bis Mission 10 können direkt aktiviert werden.
- Missionsdetails sind pro Slot abrufbar.
- F10Menu erzeugt 26 Commands.
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
- echte Capture-Auswertung aus Missionsresultaten
- echte Logistik-Auswirkungen auf Capture und Missionen
- eigene Debug-Reports
- eigenes Debug-F10-Menü
- Loader-only-Ladung über `dofile`
- automatische `.miz`-Generierung

---

## Nächster sinnvoller technischer Schritt

Empfohlene nächste Datei:

- `src/ui/tc_f10_menu.lua`

Empfohlenes Ziel:

- Capture-/Pressure-Status im F10-Menü sichtbar machen
- `Show Capture Status`
- `Show Capture Ready Zones`
- `Show Pressure Contested Zones`
- weiterhin state-only bleiben
- keine echten MOOSE-/CTLD-/Skynet-Aktionen auslösen

Alternativ danach:

- Mission completed/failed über F10 oder Debug vorbereiten
- `MissionGenerator.completeMission()` testbar machen
- `CaptureSystem.applyMissionEffect()` gezielt über F10/Debug auslösen
- Persistence-Sandbox-Test vorbereiten
