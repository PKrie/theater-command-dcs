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

- Blue startet auf **Akrotiri / Zypern**.
- Das syrische Festland ist zu Beginn rot kontrolliert.
- Blue soll sich vom Brückenkopf Zypern aus auf das syrische Festland vorarbeiten.
- Red hält zu Beginn den Großteil der strategischen Flugplätze.
- Spieler sollen sich in eine laufende Kampagne einklinken, nicht jede Aktion allein auslösen.
- Perspektivisch sollen Blue und Red eigene Operationen durchführen.

Grundprinzip:

- **Mission Editor = Bühne**
- **Lua = Kampagnensystem**
- **GitHub = Projektgedächtnis**

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
- Das F10-Menü unterstützt Mission Outcome Controls für die erste aktive Mission.
- Das F10-Menü zeigt Campaign-, Capture-, Pressure-, Logistics-, FOB- und AI-CAP-Statusinformationen an.
- Das F10-Menü zeigt Capture Ready Zones nach Mission Completion an.
- Das F10-Menü kann Capture Ready Zone 1 bewusst state-only anwenden.
- Der MissionGenerator erzeugt erweiterte Mission Records mit Objectives, Briefing, Progress, Activation Metadata, Outcome State, Effect State und reservierten Spawn-Hooks.
- Missionen können state-only aktiviert werden.
- Missionen können state-only auf `COMPLETED` gesetzt werden.
- Mission Effects werden state-only vorbereitet.
- Das CaptureSystem erzeugt Capture-Pressure- und Capture-Progress-Records für capture-fähige Zonen.
- Abgeschlossene Mission Effects werden durch das CaptureSystem state-only in Capture Pressure übernommen.
- Mission Completion kann Capture Progress erzeugen.
- Capture Ready kann dynamisch entstehen.
- Capture Ready ist über F10 sichtbar und nach Mission Completion bestätigt.
- Capture Ready kann bewusst über F10 angewendet werden.
- Beim bestätigten Capture-Apply wurde Zone Ownership state-only aktualisiert.
- Beim bestätigten Capture-Apply wurde die linked Airbase Ownership state-only synchronisiert.
- Capture Pressure wurde nach erfolgreichem Ownership-Wechsel durch das CaptureSystem zurückgesetzt.
- Main und Loader starten sauber durch.

Aktuelle Einschränkungen:

- Das Projekt ist noch keine fertige spielbare dynamische Kampagne.
- Echte MOOSE-Spawns sind noch nicht aktiv.
- CTLD ist geladen, aber noch nicht produktiv mit Theater Command verbunden.
- Skynet IADS ist geladen, aber noch nicht über ein eigenes Theater-Command-IADS-Modul integriert.
- Persistenz ist vorbereitet, aber noch nicht praktisch im DCS-Dateisystem getestet.
- AI Director für beidseitige Blue-vs-Red-Kampagnenlogik ist noch nicht implementiert.
- Missionserfolg und Missionsfehlschlag werden noch nicht automatisch aus DCS-Events ausgewertet.
- Mission Effects werden bisher produktiv nur auf Capture Pressure angewendet.
- Mission Effects werden noch nicht produktiv auf Logistics, AI oder IADS angewendet.
- Ownership-Wechsel erfolgen aktuell nur kontrolliert state-only über F10 oder vorbereitete Debug-/Systemfunktionen.
- Es gibt noch keinen automatischen produktiven Ownership-Wechsel ohne bewusste Bestätigung.
- Capture-Druck führt noch nicht automatisch produktiv zu realen DCS-Weltfolgen.

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
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden |

---

## Added

### F10 Capture Ready Apply bestätigt

Dateien:

- `src/ui/tc_f10_menu.lua`
- `src/campaign/tc_capture_system.lua`
- `src/missions/tc_mission_generator.lua`

Bestätigter Status:

- `F10Menu v0.2.3`
- `CaptureSystem v0.2.2`
- `MissionGenerator v0.2.3`

Neu bestätigt:

- Der neue F10-Befehl `Apply Capture Ready Zone 1` ist verfügbar.
- Capture Ready Zone 1 kann bewusst über F10 angewendet werden.
- Der Ownership-Wechsel bleibt state-only.
- Es wird kein automatischer Ownership-Wechsel ohne F10-Bestätigung ausgelöst.
- Die Zone Ownership wird über das bestehende CaptureSystem aktualisiert.
- Die linked Airbase Ownership wird über das bestehende CaptureSystem synchronisiert.
- Capture Pressure wird nach erfolgreichem Ownership-Wechsel durch das CaptureSystem zurückgesetzt.
- Capture Ready wird nach Anwendung sauber entfernt.
- Die bisherige Mission Completion Pipeline bleibt funktionsfähig.
- Es werden keine echten MOOSE-Spawns ausgelöst.
- Es werden keine echten CTLD-Aktionen ausgelöst.
- Es werden keine echten Skynet-Aktionen ausgelöst.

Bestätigter Testpfad:

1. Mission 1 Details über F10 angezeigt.
2. Mission 1 über F10 aktiviert.
3. Active Mission Outcome Status über F10 angezeigt.
4. Active Mission 1 über F10 auf `COMPLETED` gesetzt.
5. CaptureSystem verarbeitet abgeschlossene Mission Effects.
6. Capture Pressure wird erzeugt.
7. Capture Progress wird auf 100 % aktualisiert.
8. Capture Ready entsteht.
9. Capture Status über F10 angezeigt.
10. Capture Ready Zones über F10 angezeigt.
11. `Apply Capture Ready Zone 1` über F10 ausgelöst.
12. Zone Ownership state-only auf `BLUE` gesetzt.
13. Linked Airbase Ownership state-only auf `BLUE` gesetzt.
14. Capture Pressure wird zurückgesetzt.
15. Capture Status erneut über F10 angezeigt.

Bestätigte Testwerte:

- completed mission: `MISSION_2`
- target zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- capture pressure owner: `BLUE`
- applied pressure: 105
- progress vor Apply: 100 %
- appliedMissionEffects: 1
- ready vor Apply: 1
- contested: 0
- applied zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- applied owner: `BLUE`
- linked airbase: `Abu al-Duhur`
- ready nach Apply: 0

Bestätigte F10-Command-Zahl:

- vorher: 32 Commands
- jetzt: 33 Commands

Bestätigte Logmarker:

- `[TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.3`
- `[TC] [F10Menu] F10 menu initialized: commands=33`
- `[TC] [F10Menu] Mission details shown through F10: slot=1 key=MISSION_2`
- `[TC] [F10Menu] Mission activated through F10: slot=1 key=MISSION_2`
- `[TC] [F10Menu] Active mission outcome status shown through F10`
- `[TC] [F10Menu] Mission completed through F10: slot=1 key=MISSION_2 stateOnly=true effects=prepared`
- `[TC] [CaptureSystem] Capture pressure added: zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE amount=105 progress=100%`
- `[TC] [CaptureSystem] Capture progress updated: zones=32, ready=1, contested=0, appliedMissionEffects=1`
- `[TC] [F10Menu] Capture ready zones shown through F10`
- `[TC] [CaptureSystem] Zone captured: ZONE_AIRBASE_ABU_AL_DUHUR [BLUE]`
- `[TC] [CaptureSystem] Base captured: Abu al-Duhur [BLUE]`
- `[TC] [F10Menu] Capture ready zone applied through F10: slot=1 zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE stateOnly=true`
- `[TC] [CaptureSystem] Capture progress updated: zones=32, ready=0, contested=0, appliedMissionEffects=1`
- `[TC] [F10Menu] Capture status shown through F10`

Bewertung:

- F10Menu `v0.2.3` ist bestanden.
- Der kontrollierte state-only Ownership-Wechsel aus Capture Ready ist bestätigt.
- Die erste vollständige State-Kette ist technisch bestätigt:
  - Mission anzeigen
  - Mission aktivieren
  - Mission abschließen
  - Mission Effect vorbereiten
  - Capture Pressure erzeugen
  - Capture Progress erzeugen
  - Capture Ready erzeugen
  - Capture Ready über F10 anzeigen
  - Capture Ready über F10 anwenden
  - Zone Ownership aktualisieren
  - linked Airbase Ownership synchronisieren
  - Capture Pressure zurücksetzen
- Es gab keine Lua-Scripting-Fehler.
- Es gab keine Theater-Command-Fehler.
- Es gab keinen Lua-Stacktrace.
- Es wurden keine echten MOOSE-, CTLD- oder Skynet-Aktionen ausgelöst.

---

### Capture Ready Zones nach Mission Completion bestätigt

Dateien:

- `src/ui/tc_f10_menu.lua`
- `src/campaign/tc_capture_system.lua`
- `src/missions/tc_mission_generator.lua`

Bestätigter Status:

- `F10Menu v0.2.2`
- `CaptureSystem v0.2.2`
- `MissionGenerator v0.2.3`

Neu bestätigt:

- `Show Capture Ready Zones` wurde nach Mission Completion gezielt ausgelöst.
- Capture Ready Zone ist nach Mission Completion über F10 sichtbar.
- Der F10-Pfad für Capture Ready ist nicht mehr nur vorhanden, sondern praktisch bestätigt.
- Die Pipeline von Mission Completion bis F10-Capture-Ready-Anzeige ist bestätigt.

Bestätigter Testpfad:

1. Mission 1 Details über F10 angezeigt.
2. Mission 1 über F10 aktiviert.
3. Active Mission Outcome Status über F10 angezeigt.
4. Active Mission 1 über F10 auf `COMPLETED` gesetzt.
5. CaptureSystem verarbeitet abgeschlossene Mission Effects.
6. Capture Pressure wird erzeugt.
7. Capture Progress wird auf 100 % aktualisiert.
8. Capture Ready entsteht.
9. Capture Status über F10 angezeigt.
10. Capture Ready Zones über F10 angezeigt.
11. Pressure Contested Zones über F10 angezeigt.

Bestätigte Testwerte:

- completed mission: `MISSION_2`
- target zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- capture pressure owner: `BLUE`
- applied pressure: 105
- progress: 100 %
- appliedMissionEffects: 1
- ready: 1
- contested: 0

Bestätigte Logmarker:

- `[TC] [F10Menu] Mission details shown through F10: slot=1 key=MISSION_2`
- `[TC] [F10Menu] Mission activated through F10: slot=1 key=MISSION_2`
- `[TC] [F10Menu] Active mission outcome status shown through F10`
- `[TC] [F10Menu] Mission completed through F10: slot=1 key=MISSION_2 stateOnly=true effects=prepared`
- `[TC] [MissionGenerator] Mission outcome prepared: MISSION_2 [COMPLETED] stateOnly=true effects=prepared`
- `[TC] [CaptureSystem] Capture pressure added: zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE amount=105 progress=100%`
- `[TC] [CaptureSystem] Mission effect applied to capture: mission=MISSION_2 zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE pressure=105`
- `[TC] [CaptureSystem] Completed mission effects processed: applied=1, skipped=0, failed=0, appliedMissionEffects=1`
- `[TC] [CaptureSystem] Capture progress updated: zones=32, ready=1, contested=0, appliedMissionEffects=1`
- `[TC] [F10Menu] Capture status shown through F10`
- `[TC] [F10Menu] Capture ready zones shown through F10`
- `[TC] [F10Menu] Pressure contested zones shown through F10`

Bewertung:

- Der bisher offene Regressionstest `Show Capture Ready Zones nach Mission Completion` ist bestanden.
- Capture Ready ist nicht nur im State vorhanden, sondern über F10 sichtbar.
- Der nachfolgende kontrollierte state-only Ownership-Wechsel wurde inzwischen mit `F10Menu v0.2.3` bestätigt.

---

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

Bestätigte Testwerte nach Mission Completion:

- completed mission: `MISSION_2`
- target zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- capture pressure owner: `BLUE`
- applied pressure: 105
- progress: 100 %
- appliedMissionEffects: 1
- ready: 1
- contested: 0

Bewertung:

- CaptureSystem `v0.2.2` ist bestanden.
- Die Verbindung `Mission Outcome -> Mission Effect -> Capture Pressure -> Capture Progress -> Capture Ready` funktioniert.
- Mission Completion erzeugt jetzt einen beobachtbaren Capture-Effekt.
- Der Effekt bleibt state-only.
- Es gab keine Lua-Scripting-Fehler.
- Es gab keine Theater-Command-Fehler.
- Es gab keinen Lua-Stacktrace.
- Es wurden keine echten MOOSE-, CTLD- oder Skynet-Aktionen ausgelöst.

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
- `[TC] [F10Menu] Capture ready zones shown through F10`
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
- Capture Ready Zones sind nach Mission Completion über F10 bestätigt.
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

- Mission Details Slot 1 bestätigt
- Mission Slot 1 aktiviert
- MissionGenerator setzt Mission Slot 1 auf `ACTIVE`
- Aktivierung erzeugt `stateOnly=true`
- Aktivierung erzeugt `spawnHooks=reserved`
- aktive Mission 1 wurde über F10 auf `COMPLETED` gesetzt
- MissionGenerator erzeugt `Mission effects prepared state-only`
- MissionGenerator erzeugt `Mission outcome prepared`
- Outcome bleibt `stateOnly=true`
- Effects bleiben zunächst `prepared`
- CaptureSystem v0.2.2 übernimmt den vorbereiteten Effekt anschließend state-only in Capture Pressure

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

Bewertung:

- F10Menu `v0.2.1` ist für die Capture-/Pressure-Erweiterung bestanden.
- Die drei neuen Capture-/Pressure-Funktionen wurden im DCS-Test ausgelöst.
- Der spätere Regressionstest mit Mission Completion hat bestätigt, dass Capture Ready Zones auch nach erzeugtem Capture Ready über F10 sichtbar sind.

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

Erzeugte FOBs:

- `FOB Ercan`
- `FOB Gecitkale`

Status:

- `UNDER_CONSTRUCTION`

Weitere Werte:

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

Erstellt oder aktualisiert wurden im bisherigen Projektverlauf:

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

### Sessionabschluss-Dokumentation 2026-07-06

Aktualisiert wurden zum Sessionabschluss:

- `README.md`
- `ROADMAP.md`
- `ARCHITECTURE.md`
- `MISSION_EDITOR_SETUP.md`
- `LUA_STYLEGUIDE.md`
- `NAMING_CONVENTIONS.md`
- `docs/00_project_overview.md`
- `docs/02_technical_architecture.md`
- `docs/06_mission_generator.md`
- `docs/10_testing.md`
- `src/README.md`
- `src/campaign/README.md`
- `src/missions/README.md`
- `src/ui/README.md`
- `TASKS.md`
- `CHANGELOG.md`

Ziel der Aktualisierung:

- alle zentralen Root-Dokumente auf den Stand `2026-07-06` bringen
- die bestätigte Mission Outcome to Capture Pressure Pipeline dokumentieren
- Capture Ready Visibility nach Mission Completion dokumentieren
- den nächsten Code-Schritt eindeutig auf kontrollierten Capture Ready Apply setzen
- veraltete Prioritäten entfernen

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

### F10-Menü von 32 auf 33 Commands erweitert

Vorher:

- F10Menu `v0.2.2`
- 32 Commands
- Missionsanzeige
- Missionsdetails
- Missionsaktivierung
- Mission Outcome Controls
- Kampagnenstatus
- Capture-/Pressure-Status
- Logistikstatus
- FOB-Status
- AI-CAP-Status
- Capture Ready Anzeige

Jetzt:

- F10Menu `v0.2.3`
- 33 Commands
- zusätzlicher Befehl `Apply Capture Ready Zone 1`
- kontrollierter state-only Ownership-Wechsel aus Capture Ready
- Zone Ownership wird über CaptureSystem aktualisiert
- linked Airbase Ownership wird über CaptureSystem synchronisiert
- Capture Pressure wird nach erfolgreichem Capture Apply zurückgesetzt
- Capture Ready wird nach erfolgreicher Anwendung entfernt

Bewertung:

- Das F10-Menü kann jetzt nicht nur Capture Ready anzeigen, sondern Capture Ready Zone 1 bewusst anwenden.
- Der Schritt bleibt kontrolliert, manuell und state-only.
- Es gibt weiterhin keinen automatischen produktiven Ownership-Wechsel ohne F10-/Debug-Bestätigung.

---

### Capture Ready Apply ist nicht mehr offen

Vorher:

- Capture Ready konnte nach Mission Completion entstehen.
- Capture Ready konnte über F10 angezeigt werden.
- Der kontrollierte Ownership-Wechsel aus Capture Ready war noch der nächste offene Code-Schritt.
- Zone Ownership und linked Airbase Ownership wurden noch nicht praktisch über diesen F10-Pfad geändert.

Jetzt:

- `Apply Capture Ready Zone 1` wurde über F10 ausgelöst.
- `ZONE_AIRBASE_ABU_AL_DUHUR` wurde state-only auf `BLUE` gesetzt.
- Die linked Airbase `Abu al-Duhur` wurde state-only auf `BLUE` gesetzt.
- Capture Pressure wurde durch das CaptureSystem zurückgesetzt.
- Capture Ready fiel nach Apply von `ready=1` auf `ready=0`.

Bewertung:

- Der erste kontrollierte State-Ownership-Wechsel der Kampagne ist bestätigt.
- Die bestehende CaptureSystem-Funktionalität reicht für den Apply-Schritt aus.
- Es war keine Änderung an `src/campaign/tc_capture_system.lua` notwendig.
- Die Änderung blieb auf `src/ui/tc_f10_menu.lua` beschränkt.

---

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
- Capture Ready Zones sind über F10 nach Mission Completion sichtbar.
- Ownership-Wechsel bleibt standardmäßig deaktiviert und wird nur bei ausdrücklichem `autoCapture=true` ausgeführt.

Bewertung:

- Der erste echte Kampagnenzusammenhang ist technisch bestätigt:
  - Mission auswählen
  - Mission aktivieren
  - Mission abschließen
  - Mission Effect vorbereiten
  - Capture Pressure anwenden
  - Capture Progress aktualisieren
  - Capture Ready erzeugen
  - Capture Ready über F10 anzeigen
  - Capture Ready über F10 anwenden

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
- Capture Ready Zones sind nach Completion über F10 sichtbar.
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
- Capture Ready Zones sind über F10 nach Mission Completion sichtbar.
- Capture Ready Zone 1 kann state-only über F10 angewendet werden.
- Mission Outcomes sind über F10 testbar.
- Mission Effects werden vorbereitet.
- Abgeschlossene Mission Effects werden inzwischen state-only auf Capture Pressure angewendet.
- Ein bestätigter Capture Ready Apply kann Ownership state-only ändern.
- Der Ownership-Wechsel wird nicht automatisch produktiv ausgelöst.

---

## Fixed

### Kontrollierter Capture Ready Apply war noch offen

Vorher:

- Capture Ready konnte entstehen.
- Capture Ready konnte über F10 angezeigt werden.
- Der konkrete Apply-Schritt war noch nicht praktisch getestet.
- Der bisherige nächste Code-Schritt war `Apply Capture Ready Zone 1` oder `Confirm Capture Ready Zone 1`.
- Es war noch nicht bestätigt, ob der F10-Pfad die bestehende CaptureSystem-Funktion sauber nutzen kann.

Jetzt:

- `Apply Capture Ready Zone 1` wurde in `F10Menu v0.2.3` ergänzt.
- Der Befehl wurde im DCS-Test ausgelöst.
- Die bestehende CaptureSystem-Funktion `evaluateZoneCapture()` wurde genutzt.
- Es war keine Änderung an `tc_capture_system.lua` notwendig.
- Zone Ownership wurde state-only geändert.
- Linked Airbase Ownership wurde state-only synchronisiert.
- Capture Pressure wurde zurückgesetzt.
- Die neue F10-Command-Zahl `commands=33` ist bestätigt.

Bewertung:

- Der kontrollierte Capture Ready Apply ist bestanden.
- Die Capture-Kette ist nun nicht nur sichtbar, sondern state-only anwendbar.

---

### Capture Ready Zones nach Mission Completion waren noch nicht bestätigt

Vorher:

- Capture Ready konnte durch Mission Completion entstehen.
- `ready=1` war im Capture Progress bestätigt.
- Der F10-Pfad `Show Capture Ready Zones` existierte bereits.
- Die gezielte Prüfung von `Show Capture Ready Zones` nach Mission Completion war aber noch offen.

Jetzt:

- `Show Capture Ready Zones` wurde nach Mission Completion gezielt ausgelöst.
- Der Logmarker `[TC] [F10Menu] Capture ready zones shown through F10` ist bestätigt.
- Capture Ready ist im State vorhanden und über F10 sichtbar.
- Die offene Regression ist erledigt.

Bewertung:

- Die Pipeline ist jetzt vollständig sichtbar:
  - Mission Completion
  - Mission Effect
  - Capture Pressure
  - Capture Progress
  - Capture Ready
  - F10 Capture Ready Anzeige

---

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
- Die Capture Ready Anzeige wurde zusätzlich nach Mission Completion bestätigt.

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
- produktive automatische Capture-Auswertung aus Missionsresultaten
- automatischer produktiver Ownership-Wechsel ohne manuelle F10-/Debug-Bestätigung
- Anwendung vorbereiteter Mission Effects auf Logistics, AI und IADS
- echte Logistik-Auswirkungen auf Capture und Missionen
- eigene Debug-Reports
- eigenes Debug-F10-Menü
- Loader-only-Ladung über `dofile`
- automatische `.miz`-Generierung

Nicht mehr offen:

- gezielte Prüfung von `Show Capture Ready Zones` nach Mission Completion
- kontrollierter state-only Ownership-Wechsel aus Capture Ready Zone 1
- `Apply Capture Ready Zone 1` als F10-Befehl
- F10Menu `v0.2.3` Regressionstest
- Capture Ready Apply ohne Änderung an `tc_capture_system.lua`

---

## Nächster sinnvoller technischer Schritt

Vor dem nächsten Code-Schritt sollte zuerst die notwendige Projektdokumentation minimal synchronisiert werden.

Nächste Dokumentationsdatei:

- `TASKS.md`

Ziel:

- `Apply Capture Ready Zone 1` als erledigt markieren
- F10Menu `v0.2.3` als bestanden dokumentieren
- den nächsten offenen praktischen Test auf `Fail Active Mission 1` setzen
- Persistence-Sandbox-Test weiterhin als nächstes größeres Thema vorbereiten
- keine vollständige Dokumentationsrunde während aktiver Arbeit auslösen

Danach sinnvoll:

1. `Fail Active Mission 1` praktisch testen.
2. Persistence-Sandbox-Test vorbereiten.
3. kontrollierte Save-/Load-Grundlage testen.
4. Debug-F10-Menü getrennt entwickeln.
5. CTLD-Integration vorbereiten.
6. MOOSE-CAP-Templates vorbereiten.
7. AI Director state-only entwerfen.
8. IADS-System mit Skynet vorbereiten.
