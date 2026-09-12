# Testing

Diese Datei beschreibt die aktuelle Teststrategie für **Theater Command DCS**.

Projekt:

- Theater Command DCS

Erste Kampagne:

- Operation Levant Reclamation

Map:

- Syria

Grundprinzip:

- Mission Editor = Bühne
- Lua = Kampagnensystem
- GitHub = Projektgedächtnis

---

## 1. Zweck dieser Datei

Diese Datei dokumentiert, wie Theater Command DCS aktuell getestet wird.

Sie soll sicherstellen, dass jede neue Datei, jedes neue System und jede neue Systemverknüpfung in DCS nachvollziehbar geprüft wird.

Das Projekt wird bewusst schrittweise getestet.

Grundregel:

    Eine konkrete Aufgabe.
    Eine Datei.
    Ein Test.
    Eine Logauswertung.
    Eine Dokumentationsaktualisierung.

Wichtig:

- Keine großen parallelen Änderungen.
- Keine Framework-Dateien verändern.
- Keine All-in-one-Lua-Dateien erstellen.
- Keine produktiven Framework-Aktionen aktivieren, bevor der State stabil ist.
- Neue Lua-Dateien nach GitHub-Pull im Mission Editor neu auswählen.
- Nach jedem relevanten Test eine frische `dcs.log` prüfen.

---

## 2. Testgrundsatz

Theater Command DCS folgt aktuell dem Prinzip:

    erst laden
    dann State erzeugen
    dann State sichtbar machen
    dann einzelne Wirkungen testen
    dann kontrollierte State-Änderungen testen
    dann Persistenz testen
    dann State-Änderungen persistenzrelevant markieren
    dann produktiven Restore vorbereiten
    dann Framework-Ausführung aktivieren

Aktuell gilt:

- State-first vor echten Spawns.
- F10-/Debug-Sichtbarkeit vor produktiven Kampagnenfolgen.
- einzelne Module vor Systemketten.
- Systemketten erst state-only bestätigen.
- DCS-Logauswertung vor weiteren Code-Schritten.
- keine großen parallelen Änderungen.
- keine Vendor-Dateien verändern.
- kein automatischer produktiver Ownership-Wechsel ohne kontrollierten Testpfad.
- keine echten MOOSE-, CTLD- oder Skynet-Aktionen ohne vorbereitete Templates/Zonen.
- Persistence läuft als Hintergrundsystem, nicht als Spieler-F10-Workflow.
- Produktiver Restore bleibt deaktiviert, bis (1) Priority 3 allgemeine Dirty-Coverage abgeschlossen ist, (2) die Restore-/Initialisierungsreihenfolge definiert ist, (3) die Save-Kompatibilitäts-/Versionsstrategie festgelegt ist und (4) ein separater kontrollierter Restore-Test durchgeführt wird. Die Completion-/Failure-/Capture-Apply-Regressionen sind bereits bestanden.

---

## 3. Aktueller Teststand

Stand:

- 2026-09-12

Aktueller Gesamtstatus:

- State-first Runtime-Grundlage bestanden.
- Mission Activation bestanden.
- Mission Completion bestanden.
- Mission Failure bestanden.
- Mission Effects bestanden.
- Mission Completion -> Capture Pressure bestanden.
- Capture Ready über F10 sichtbar bestätigt.
- Capture Ready Apply state-only bestanden.
- Zone Ownership state-only update bestanden.
- linked Airbase Ownership state-only sync bestanden.
- Persistence Save/Read/Compile/Evaluate/Validation technisch bestanden.
- kontrollierter Import technisch möglich.
- PersistenceSystem `v0.2.6` Embedded Start bestanden.
- normaler `20s`-/`120s`-Scheduler bestanden.
- `SAVED` bestanden.
- `SKIPPED` bestanden.
- kontrollierter `FAILED`-Pfad bestanden.
- Retry bestanden.
- Mission Completion Persistence Regression bestanden.
- Mission Failure Persistence Regression bestanden.
- Capture Ready Apply Persistence Regression bestanden.
- Capture Getter Dirty-Neutralität bestanden.
- Ownership-No-Op Dirty-Neutralität bestanden.
- Embedded Resource Audit 13/13 `EXACT_MATCH` bestanden.
- `productiveRestore=false`.
- Priority 3 (allgemeine Dirty-Coverage der übrigen aktiven State-Systeme) bleibt offen.

Bestätigte Systeme:

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | funktional bestanden; Capture Read-Dirty- und Ownership-No-Op-Regressionen bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | Embedded Start, `SAVED`, `SKIPPED`, `FAILED`, Retry und die drei Campaign-Persistence-Regressionen bestanden; `productiveRestore=false` |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | funktional bestanden; Dirty-Coverage ist nächster Priority-3-Audit |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | funktional bestanden; Dirty-Coverage noch offen |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | 10 Mission Records vorhanden; Activation, Completion, Failure und Effects bestanden; Record-Loss-Verdacht widerlegt; allgemeine Dirty-Coverage noch offen |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | state-first bestanden; `reactToActiveMissions()`-Sonderfall bewertet; allgemeine Dirty-Coverage noch offen |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden |

Aktuelle bestätigte Fähigkeiten:

Mission Records sind vorhanden. MissionGenerator erzeugt 10 String-keyed Mission Records; live bestätigt `statistics.available=10`, `pairs()`-Count `available=10`, `#available=0`. Der frühere Record-Loss-Befund war eine Fehldiagnose (siehe Abschnitt 25A). Die Fähigkeiten Activation, Completion, Failure und Capture Apply sind am 2026-09-12 erneut bestätigt.

- DCS lädt Vendor-Frameworks.
- Theater Command lädt.
- Main startet.
- Loader beendet sauber.
- Runtime-Systeme initialisieren.
- Airbase Scanner klassifiziert Syria-Airbase-Daten.
- ZoneFactory erzeugt relevante Kampagnenzonen.
- CaptureSystem erzeugt Capture-Eligibility, Capture-Pressure und Capture-Progress.
- CaptureSystem verarbeitet abgeschlossene Mission Effects state-only in Capture Pressure.
- CaptureSystem verarbeitet Failed Missions korrekt ohne Capture Pressure.
- CaptureSystem kann Capture Ready state-only anwenden.
- CaptureSystem kann Zone Ownership und linked Airbase Ownership state-only synchronisieren.
- LogisticsDelivery erzeugt Logistics Hubs.
- FobSystem erzeugt FOB-Kandidaten und Blue-FOBs.
- MissionGenerator erzeugt Missionen inklusive FOB-Support.
- MissionGenerator erzeugt Objectives, Briefings, Progress-Daten, Activation Metadata, Outcome State und Effect State.
- MissionGenerator kann Missionen state-only aktivieren.
- MissionGenerator kann Missionen state-only auf `COMPLETED` setzen.
- MissionGenerator kann Missionen state-only auf `FAILED` setzen.
- F10Menu ist sichtbar und navigierbar.
- F10Menu erlaubt direkte Missionsauswahl.
- F10Menu erlaubt direkte Missionsaktivierung.
- F10Menu erlaubt Mission Outcome Controls.
- F10Menu zeigt Capture-/Pressure-Status.
- F10Menu zeigt Capture Ready Zones.
- F10Menu kann Capture Ready Zone 1 bewusst state-only anwenden.
- AICapManager erzeugt CAP-State.
- PersistenceSystem schreibt, liest, validiert und importiert Save-Dateien technisch.
- PersistenceSystem speichert Dirty-Campaign-State automatisch im Hintergrund.
- PersistenceSystem überspringt unveränderte periodische Ticks ohne die Save-Datei zu schreiben.
- PersistenceSystem behält produktiven Startup-Restore bewusst deaktiviert.
- Es werden keine echten MOOSE-, CTLD- oder Skynet-Aktionen ausgelöst.

---

## 4. Aktuelle DEV-Mission

Aktuelle technische Entwicklungsmission:

    Operation_Levant_Reclamation_DEV.miz

Aktueller Inhalt:

- Map: Syria
- Koalitionspreset: Modern
- Blue Start: Akrotiri / Zypern
- erster blauer Client-Slot: `CLIENT_BLUE_FA18C_AKROTIRI_01`, F/A-18C Lot 20 auf Akrotiri
- sichere Einzeldatei-Ladung per `DO SCRIPT FILE`
- Vendor-Frameworks geladen
- Theater-Command-Source-Dateien geladen
- F10-Menü aktiv
- direkte Missionsauswahl aktiv
- direkte Missionsaktivierung aktiv
- Mission Outcome Controls aktiv
- Capture-/Pressure-Status aktiv
- Capture Ready Zones sichtbar
- Capture Ready Zone 1 Apply testbar
- PersistenceSystem `v0.2.6` über `TC_LOAD_TC_PERSISTENCE_SYSTEM` eingebettet
- Persistence Background Autosave dirty-aware aktiv

Bestätigte Persistence-Einbettung:

- Trigger-Typ: `once`
- Bedingung: `time-after 15 seconds`
- Resource Key: `ResKey_advancedFile_56`
- eingebetteter Dateiname: `tc_persistence_system_v0_2_6.lua`
- eingebettete Bytes entsprechen exakt `src/campaign/tc_persistence_system.lua`
- gespeicherte `.miz` enthält den neuen Key und die neue Ressource
- der alte Trigger-Verweis `ResKey_Action_55` ist im gespeicherten Mission-Trigger nicht mehr vorhanden; die Ressource selbst liegt weiterhin verwaist in der `.miz` (nicht referenziert, nicht geladen, nicht ursächlich, separate spätere Cleanup-Aufgabe) — nicht als vollständig entfernt darstellen

Offline READ-ONLY Embedded Mission Resource Audit vom 2026-09-12 (abgeschlossen):

- DEV und MCP_TEST waren beim Audit byte-identisch.
- 13/13 relevante aktive Theater-Command-Ressourcen waren `EXACT_MATCH` zum Repository.
- keine aktive Embedded-Runtime-Drift.

Finaler CaptureSystem-Embed nach dem letzten Fix:

- `l10n/DEFAULT/tc_capture_system.lua`
- `91160` Bytes
- SHA-256: `06326C028388C6737BDB01C8C29C8F029375D612D72ADC1A02F49BFD9DAE9DCE`
- `MATCH=True`

Noch nicht produktiv enthalten:

- rote Frontlinie als echte Mission-Editor-Front
- produktive IADS-Stellungen
- CTLD-Zonen
- echte FOB-Zonen
- MOOSE-Template-Gruppen
- CTLD-Crates
- echte MOOSE-Spawns
- echte CTLD-FOBs
- echte CTLD-Cargo-Aktionen
- produktiver automatischer Restore beim Missionsstart
- automatische Missionserfolgsauswertung
- automatische Capture-Auswertung aus realen DCS-Einheiten/Zonen
- automatische Blue-/Red-KI-Operationen

Bewertung:

Die DEV-Mission ist ein technischer Testträger.

Sie ist noch keine fertige spielbare Kampagnenmission.

---

## 5. Testumgebung

DCS:

    DCS World

Map:

    Syria

Lokales Repository:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\

DCS-Logs:

    C:\Users\Paul\Saved Games\DCS\Logs\dcs.log

Möglicher Open-Beta-/Standalone-Pfad:

    C:\Users\Paul\Saved Games\DCS.openbeta\Logs\dcs.log

Bestätigter Persistence-Speicherordner:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS

Bestätigte Persistence-Save-Datei:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Schneller Zugriff:

    %USERPROFILE%\Saved Games

---

## 6. Wichtiger DCS-Hinweis

Eine per `DO SCRIPT FILE` geladene Lua-Datei wird in die `.miz` eingebettet.

Deshalb gilt nach jeder Lua-Änderung:

1. Datei auf GitHub aktualisieren.
2. Lokal per GitHub Desktop fetchen/pullen.
3. DCS Mission Editor öffnen.
4. Geänderte Datei in der passenden `DO SCRIPT FILE`-Aktion neu auswählen.
5. Mission speichern.
6. Alte `dcs.log` löschen oder umbenennen.
7. Mission testen.
8. Frische `dcs.log` prüfen.

Wenn dieser Schritt vergessen wird, testet DCS möglicherweise eine alte eingebettete Lua-Version.

Wichtig bei Versionstests:

- Immer im Log prüfen, welche Modulversion tatsächlich geladen wurde.
- GitHub-Stand allein reicht nicht.
- DCS-Log ist die Wahrheit für den getesteten Runtime-Stand.

Der Offline Embedded Resource Audit vom 2026-09-12 hat bestätigt, dass der Byte-/SHA-256-Vergleich zwischen `.miz` und Repository ein geeignetes Verfahren ist, um Repository-/Embedded-Runtime-Drift auszuschließen. Dieser Audit selbst ist abgeschlossen und ist kein nächster Schritt mehr.

---

## 7. Sauberer Logtest

Für jeden relevanten Test:

1. DCS beenden.
2. Alte `dcs.log` löschen oder umbenennen.
3. DCS neu starten.
4. Mission starten.
5. gewünschte F10-/Runtime-Aktion ausführen.
6. Mission beenden.
7. DCS beenden.
8. Frische `dcs.log` hochladen oder auswerten.

Warum:

Alte Logs enthalten alte Testläufe.

Ohne frische Logdatei können alte Fehler, alte Versionen oder alte Marker falsch bewertet werden.

Ein weitergeführter Log kann für gezielte Regressionen ausreichen, wenn der neue Testabschnitt zeitlich klar abgegrenzt ist.

Dann muss bei der Auswertung klar benannt werden:

- ab welcher Uhrzeit der neue Abschnitt beginnt
- welche alten Marker ignoriert werden
- welche neuen Marker zum Test gehören

---

## 8. Aktive Ladefolge

Aktuelle getestete Ladefolge im Mission Editor:

Vendor:

1. `vendor/mist/mist.lua`
2. `vendor/moose/Moose.lua`
3. `vendor/ctld/CTLD-i18n.lua`
4. `vendor/ctld/CTLD.lua`
5. `vendor/skynet-iads/SkynetIADS.lua`

Theater Command:

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

- `src/campaign/tc_capture_system.lua` wird vor Persistence geladen.
- `src/campaign/tc_persistence_system.lua` wird vor Main geladen.
- `src/ui/tc_f10_menu.lua` wird nach AI CAP Manager und vor Main geladen.
- `src/main.lua` initialisiert Runtime-Systeme.
- `src/loader.lua` bleibt aktuell die letzte eigene Datei.

---

## 9. Starttest Variante A

Status:

- bestanden

Methode:

- sichere Einzeldatei-Ladung per `DO SCRIPT FILE`

Erwartetes Ergebnis:

- Frameworks laden
- Core-Dateien laden
- World-Dateien laden
- Campaign-Dateien laden
- Logistics-Dateien laden
- Mission-Dateien laden
- AI-Dateien laden
- UI-Dateien laden
- Main startet
- Loader beendet sauber

Bestanden, wenn:

- keine Theater-Command-Lua-Fehler auftreten
- keine Theater-Command-Stacktraces auftreten
- Frameworks erkannt werden
- Main startet
- Runtime-Systeme initialisiert werden
- PersistenceSystem Autosave plant
- F10Menu sichtbar ist
- Loader sauber beendet

---

## 10. Starttest Variante B

Status:

- offen

Methode:

- Loader-only mit `dofile`

Ziel:

Der Mission Editor lädt nur Frameworks und `src/loader.lua`.

`loader.lua` lädt danach die eigenen Source-Dateien selbst.

Noch zu prüfen:

- funktioniert `dofile` im DCS Mission Scripting Environment?
- kann `loader.lua` Dateien aus dem lokalen Repository lesen?
- wie verhält sich die DCS-Sandbox?
- braucht das Projekt später eine Build-Datei?
- bleibt Einzeldatei-Ladung für Entwicklung besser?

Aktuelle Entscheidung:

- Variante A bleibt Standard, bis Variante B praktisch getestet ist.

---

## 11. Erwartete Grund-Logmarker

Bei einem erfolgreichen vollständigen Starttest sollten unter anderem diese Marker erscheinen:

    [TC] Theater Command loader started
    [TC] Framework available: MIST
    [TC] Framework available: MOOSE
    [TC] Framework available: CTLD
    [TC] Framework available: Skynet IADS
    [TC] Main start requested
    [TC] Core check passed
    [TC] Runtime systems initialized
    [TC] Main initialized
    [TC] Main started
    [TC] Theater Command loader finished

Zusätzlich wichtig:

    [TC] [PersistenceSystem] Persistence autosave scheduled
    [TC] [F10Menu] F10 menu initialized

---

## 12. Erwartete Modul-Logmarker

Aktueller getesteter Stand:

    [TC] [AirbaseScanner] Loaded src/world/tc_airbase_scanner.lua v0.2.2
    [TC] [ZoneFactory] Loaded src/world/tc_zone_factory.lua v0.2.0
    [TC] [CaptureSystem] Loaded src/campaign/tc_capture_system.lua v0.2.2
    [TC] [PersistenceSystem] Loaded src/campaign/tc_persistence_system.lua v0.2.6
    [TC] [LogisticsDelivery] Loaded src/logistics/tc_logistics_delivery.lua v0.2.0
    [TC] [FobSystem] Loaded src/logistics/tc_fob_system.lua v0.2.0
    [TC] [MissionGenerator] Loaded src/missions/tc_mission_generator.lua v0.2.3
    [TC] [AICapManager] Loaded src/ai/tc_ai_cap_manager.lua v0.2.0
    [TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.3

Wenn eine ältere Version erscheint:

- Mission Editor hat vermutlich noch eine alte eingebettete Datei.
- Betroffene Datei in `DO SCRIPT FILE` neu auswählen.
- Mission speichern.
- DCS neu starten.
- frische `dcs.log` prüfen.

---

## 13. Erwartete World-Logmarker

Airbase Scanner:

    [TC] [AirbaseScanner] Scan complete:
    [TC] [AirbaseScanner] Airbase classification complete:

Erwartete Werte:

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

ZoneFactory:

    [TC] [ZoneFactory] Zone factory initialized:

Erwartete Werte:

- total zones: `46`
- classified airbase zones: `46`
- skipped airbase-like objects: `179`
- captureZones: `32`
- missionZones: `32`
- logisticsZones: `46`
- startBaseZones: `1`

---

## 14. Erwartete Capture-Logmarker

Startzustand:

    [TC] [CaptureSystem] Capture system initialized:

Erwartete Startwerte:

- eligibleBases: `32`
- eligibleZones: `32`
- nonCaptureBases: `193`
- nonCaptureZones: `14`
- pressureRecords: `32`
- progressRecords: `32`
- appliedMissionEffects: `0`
- ready: `0`
- contested: `0`

Mission Completion zu Capture Pressure:

    [TC] [MissionGenerator] Mission effects prepared state-only:
    [TC] [MissionGenerator] Mission outcome prepared:
    [TC] [CaptureSystem] Capture pressure added:
    [TC] [CaptureSystem] Mission effect applied to capture:
    [TC] [CaptureSystem] Completed mission effects processed:
    [TC] [CaptureSystem] Capture progress updated:

Erwarteter bestätigter Fall:

- Mission: `MISSION_2`
- Zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- Owner: `BLUE`
- Pressure: `105`
- Progress: `100%`
- appliedMissionEffects: `1`
- ready: `1`
- contested: `0`

Capture Ready Apply:

    [TC] [CaptureSystem] Zone captured:
    [TC] [CaptureSystem] Base captured:
    [TC] [F10Menu] Capture ready zone applied through F10:

Erwarteter bestätigter Fall:

- applied zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- applied owner: `BLUE`
- linked airbase: `Abu al-Duhur`
- ready danach: `0`
- contested danach: `0`

Am 2026-09-12 bestätigte Persistence-/Dirty-Aspekte:

Mission Completion:

- `dirtyReason=f10_active_mission_1_completed`
- `SAVED`
- `dirtyCleared=true`

Capture Ready Apply:

- `dirtyReason=f10_capture_ready_zone_1_applied`
- `SAVED`
- `dirtyCleared=true`

Finaler Zustand nach Capture Ready Apply:

- `zoneOwner=BLUE`
- `previousOwner=RED`
- `baseOwner=BLUE`
- `progress=0`
- `status=STABLE`
- `captureReady=false`

Kosmetische F10-Auffälligkeit: Die Anzeige zeigte beim Apply zeitweise `BLUE -> BLUE`; der Runtime-State bestätigte korrekt `RED -> BLUE`. Kein CaptureSystem-Fehler.

---

## 15. Erwartete Mission-Logmarker

MissionGenerator Start:

    [TC] [MissionGenerator] Mission generator initialized:

Erwartete Werte:

- mission candidates: `78`
- fobSupportCandidates: `2`
- generated missions: `10`
- reservedCreated: `1`
- duplicatesSkipped: `1`
- typeLimitSkipped: `68`

Mission Details:

    [TC] [F10Menu] Mission details shown through F10:

Mission Activation:

    [TC] [MissionGenerator] Mission status changed:
    [TC] [MissionGenerator] Mission activation prepared:
    [TC] [F10Menu] Mission activated through F10:

Erwartung:

- Status: `ACTIVE`
- `stateOnly=true`
- `spawnHooks=reserved`

Mission Completion:

    [TC] [MissionGenerator] Mission effects prepared state-only:
    [TC] [MissionGenerator] Mission outcome prepared:
    [TC] [F10Menu] Mission completed through F10:

Erwartung:

- Status: `COMPLETED`
- Effects: `prepared`
- `stateOnly=true`

Mission Failure:

    [TC] [MissionGenerator] Mission effects prepared state-only:
    [TC] [MissionGenerator] Mission outcome prepared:
    [TC] [F10Menu] Mission failed through F10:

Erwartung:

- Status: `FAILED`
- Effects: `prepared`
- CaptureSystem applied: `0`
- ready: `0`
- contested: `0`

Mission Records (bestätigt, 2026-09-12):

- 10 Mission Records vorhanden
- String-keyed Dictionaries (Schlüssel wie `MISSION_1`)
- korrekte Zählung nur über `pairs()`; `#` ist nicht autoritativ

Mission Completion Regression 2026-09-12:

- `available=9`
- `active=0`
- `completed=1`
- `failed=0`
- `statistics.available=9`
- `statistics.active=0`
- `statistics.completed=1`
- `total=10`

Mission Failure Regression danach:

- `available=8`
- `active=0`
- `completed=1`
- `failed=1`
- `statistics.available=8`
- `statistics.active=0`
- `statistics.completed=1`
- `statistics.failed=1`
- `total=10`

Eine Record-Loss-Aussage ist hier kein aktueller Befund mehr (siehe Abschnitt 25A).

---

## 16. Erwartete F10-Logmarker

F10Menu Start:

    [TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.3
    [TC] [F10Menu] F10 menu initialized: commands=33

Erwartete F10-Testmarker:

    [TC] [F10Menu] Available missions shown through F10
    [TC] [F10Menu] Mission details shown through F10
    [TC] [F10Menu] Mission activated through F10
    [TC] [F10Menu] Active mission outcome status shown through F10
    [TC] [F10Menu] Mission completed through F10
    [TC] [F10Menu] Mission failed through F10
    [TC] [F10Menu] Capture status shown through F10
    [TC] [F10Menu] Capture ready zones shown through F10
    [TC] [F10Menu] Capture ready zone applied through F10
    [TC] [F10Menu] Pressure contested zones shown through F10
    [TC] [F10Menu] Logistics status shown through F10
    [TC] [F10Menu] FOB status shown through F10

Bestätigt:

- F10Menu erzeugt `33` Commands.
- Mission 1 bis Mission 10 können Details anzeigen.
- Mission 1 bis Mission 10 können aktiviert werden.
- aktive Mission 1 kann auf `COMPLETED` gesetzt werden.
- aktive Mission 1 kann auf `FAILED` gesetzt werden.
- Capture Ready Zone 1 kann bewusst angewendet werden.

Nicht vorgesehen:

- Persistence Save/Load als Spieler-F10-Menü

Begründung:

- Persistence ist Hintergrundsystem.
- Spieler sollen nicht manuell speichern/laden müssen.

---

## 17. Erwartete Logistics-Logmarker

LogisticsDelivery Start:

    [TC] [LogisticsDelivery] Logistics delivery initialized:

Erwartete Werte:

- logistics hubs: `46`
- blue hubs: `7`
- red hubs: `24`
- neutral hubs: `15`
- active hubs: `31`
- limited hubs: `15`
- locked hubs: `0`

FobSystem Start:

    [TC] [FobSystem] FOB system initialized:

Erwartete Werte:

- FOB candidates: `6`
- stored candidates: `6`
- auto-planned FOBs: `2`
- skipped candidates: `4`

Erwartete FOBs:

- `FOB Ercan`
- `FOB Gecitkale`

Erwarteter Status:

- `UNDER_CONSTRUCTION`

---

## 18. Erwartete AI-Logmarker

AICapManager Start:

    [TC] [AICapManager] AI CAP manager initialized:

Erwartete Werte:

- cap zone candidates: `31`
- auto-registered CAP zones: `12`
- CAP requests: `12`
- reactionState: `AIR_REACTION_REQUESTED`
- threatLevel: `HIGH`

Erwartung:

- keine echten MOOSE-Spawns
- `MOOSE_PENDING` ist im aktuellen Stand kein Fehler

`reactToActiveMissions(options)` (READ-ONLY auditiert, 2026-09-12):

- keine produktive Call-Site
- nicht durch `start()`, Scheduler, `main.lua`, `loader.lua` oder F10 aufgerufen
- latenter Missing-Dirty-Randfall bei späterer Verdrahtung
- aktuell kein Runtime-Persistence-Bug
- jetzt kein Code-Fix; bei späterer Verdrahtung erneut testen

Die allgemeine AICapManager-Dirty-Coverage bleibt davon unabhängig im Rahmen von Priority 3 offen.

---

## 19. Erwartete Persistence-Logmarker

PersistenceSystem Start:

    [TC] [PersistenceSystem] Loaded src/campaign/tc_persistence_system.lua v0.2.6
    [TC] [PersistenceSystem] Persistence system started

Sandbox-Verfügbarkeit:

    [TC] [PersistenceSystem] Persistence sandbox availability: os=true, io=true, lfs=true, require=false, load=true, loadstring=true, loadfile=true, lfsFromRequire=false

Sandbox-Test:

    [TC] [PersistenceSystem] Persistence sandbox file test passed:

Autosave-Planung:

    [TC] [PersistenceSystem] Persistence autosave scheduled: initialDelay=20s interval=120s productiveRestore=false

Initialisierung:

    [TC] [PersistenceSystem] Persistence system initialized: sandboxStatus=PASSED, fileSystemAvailable=true, autosaveScheduled=true, autosaveInterval=120s, productiveRestore=false

Periodische Autosave-Entscheidungen:

    [TC] [PersistenceSystem] Periodic autosave decision: SAVED dirtyReason=<reason> detail=<detail> productiveRestore=false
    [TC] [PersistenceSystem] Periodic autosave decision: SKIPPED detail=state_unchanged productiveRestore=false
    [TC] [PersistenceSystem] Periodic autosave decision: FAILED dirtyReason=<reason> detail=<failure> productiveRestore=false

Erwartete Werte:

- `fileSystemAvailable=true`
- `autosaveScheduled=true`
- `productiveRestore=false`
- erster Autosave nach etwa 20 Sekunden
- danach Autosave alle 120 Sekunden
- Dirty-State erzeugt `SAVED` und erhöht `autosaveCount`
- unveränderter State erzeugt `SKIPPED`, schreibt keine Save-Datei und erhöht `autosaveCount` nicht
- ein fehlgeschlagener Save erzeugt `FAILED` und behält `dirty`, `dirtyReason` und `dirtyAt`
- bestätigter Embedded-Teststand: `autosaveCount=1` nach einem `SAVED` und drei folgenden `SKIPPED`-Ticks

Am 2026-09-12 zusätzlich bestätigt:

Mission Completion:

    Periodic autosave decision: SAVED dirtyReason=f10_active_mission_1_completed

Mission Failure:

    Periodic autosave decision: SAVED dirtyReason=f10_active_mission_1_failed

Capture Ready Apply:

    Periodic autosave decision: SAVED dirtyReason=f10_capture_ready_zone_1_applied

In allen drei Fällen: `dirtyCleared=true`, `productiveRestore=false`.

Wichtig:

Diese historischen Testmarker sollen bei `v0.2.6` nicht erscheinen:

    Persistence file save test scheduled
    Persistence file validation test scheduled
    Persistence file load test scheduled
    Campaign state file load test passed
    Campaign state autosaved:

Wenn diese Marker wieder erscheinen:

- vermutlich läuft eine alte `tc_persistence_system.lua`
- Datei im Mission Editor neu auswählen
- Mission speichern
- frischen Logtest durchführen

---

## 20. Persistence-Testvoraussetzung

Für Persistence muss die lokale DCS-Sandbox angepasst sein.

Lokale Datei:

    ...\DCS World\Scripts\MissionScripting.lua

Anforderung des Theater-Command-PersistenceSystems:

- `io` entsperrt
- `lfs` entsperrt
- keine direkte Abhängigkeit von `os`
- keine direkte Abhängigkeit von `require`

Aktueller Zustand der DCS-SMS-Entwicklungsumgebung:

- `os=true`
- `io=true`
- `lfs=true`
- `require=false`

Die installierten DCS-SMS-Bridge-Kommandos `exec`, `status` und `tail-log` benötigen `os`, `io` und `lfs` unsanitized in `MissionScripting.lua`. `os=true` stammt aus der Installation dieser Bridge und nicht aus dem PersistenceSystem-`v0.2.6`-Hotload. Solange die DCS-SMS-Runtime-Bridge verwendet wird, darf `os` nicht wieder gesperrt werden. Eine erneute Sanitization von `os` ist erst möglich, wenn die Runtime-Bridge entfernt oder nicht mehr benötigt wird.

Historischer Zustand vor der DCS-SMS-Installation:

- `os=false`
- `io=true`
- `lfs=true`
- `require=false`

Wenn der Log zeigt:

- `io=false`
- `lfs=false`
- `Persistence sandbox blocked`

dann wurde die lokale Sandbox-Freigabe vermutlich zurückgesetzt.

Wahrscheinliche Ursache:

- DCS-Update
- Reparaturinstallation
- geänderte DCS-Installation
- falscher DCS-Installationspfad

Warnung:

- DCS-Updates können `MissionScripting.lua` überschreiben.

---

## 21. End-to-End-Test: Mission Completion zu Capture Ready

Status:

- BESTANDEN / 2026-09-12 erneut bestätigt.

Ziel:

Prüfen, ob Mission Completion state-only in Capture Pressure und Capture Ready übergeht.

Ablauf:

1. DCS mit frischem Log starten.
2. DEV-Mission starten.
3. F10-Menü öffnen.
4. `Show Mission 1 Details` ausführen.
5. `Activate Mission 1` ausführen.
6. `Show Active Mission Outcome Status` ausführen.
7. `Complete Active Mission 1` ausführen.
8. `Show Capture Status` ausführen.
9. `Show Capture Ready Zones` ausführen.
10. Log prüfen.

Bestanden, wenn:

- Mission Details angezeigt wurden.
- Mission aktiviert wurde.
- Mission auf `COMPLETED` gesetzt wurde.
- Mission Effects vorbereitet wurden.
- CaptureSystem Mission Effects verarbeitet hat.
- Capture Pressure erzeugt wurde.
- Capture Progress auf `100%` steht.
- Capture Ready auf `1` steht.
- kein Lua-Fehler auftritt.

Erwartete Marker:

    Mission details shown through F10
    Mission activated through F10
    Mission completed through F10
    Mission effects prepared state-only
    Capture pressure added
    Mission effect applied to capture
    Completed mission effects processed
    Capture progress updated
    Capture ready zones shown through F10

Bestätigte State Counts (2026-09-12): `available=9`, `active=0`, `completed=1`, `failed=0`, `statistics.available=9`, `statistics.active=0`, `statistics.completed=1`, `total=10`.

Persistence: `SAVED`, `dirtyReason=f10_active_mission_1_completed`, `dirtyCleared=true`, `productiveRestore=false`.

---

## 22. End-to-End-Test: Capture Ready Apply

Status:

- BESTANDEN / 2026-09-12 erneut bestätigt.

Ziel:

Prüfen, ob Capture Ready state-only angewendet werden kann.

Ablauf:

1. Mission Completion zu Capture Ready durchführen.
2. `Show Capture Ready Zones` ausführen.
3. `Apply Capture Ready Zone 1` ausführen.
4. `Show Capture Status` ausführen.
5. Log prüfen.

Bestanden, wenn:

- Capture Ready Zone 1 angewendet wurde.
- Zone Ownership state-only geändert wurde.
- linked Airbase Ownership state-only geändert wurde.
- Capture Pressure zurückgesetzt wurde.
- ready danach `0` ist.
- kein Lua-Fehler auftritt.

Erwartete Marker:

    Capture ready zones shown through F10
    Zone captured:
    Base captured:
    Capture ready zone applied through F10
    Capture status shown through F10

Bestätigter Fall:

- Zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- Owner: `BLUE`
- linked Airbase: `Abu al-Duhur`

Vor Apply: `RED -> BLUE`, Progress `100 %`.

Danach: `zoneOwner=BLUE`, `previousOwner=RED`, `baseOwner=BLUE`, `progress=0`, `status=STABLE`, `captureReady=false`.

Persistence: `SAVED`, `dirtyReason=f10_capture_ready_zone_1_applied`, `dirtyCleared=true`, `productiveRestore=false`.

F10 zeigte beim Apply zeitweise `BLUE -> BLUE` — das ist nur eine kosmetische Anzeigeauffälligkeit; der Runtime-State bestätigte korrekt `RED -> BLUE`.

---

## 23. End-to-End-Test: Mission Failure

Status:

- BESTANDEN / 2026-09-12 erneut bestätigt.

Ziel:

Prüfen, ob ein Mission Failure keinen Capture Pressure erzeugt.

Ablauf:

1. DCS mit frischem Log starten.
2. DEV-Mission starten.
3. F10-Menü öffnen.
4. `Show Mission 1 Details` ausführen.
5. `Activate Mission 1` ausführen.
6. `Show Active Mission Outcome Status` ausführen.
7. `Fail Active Mission 1` ausführen.
8. `Show Capture Status` ausführen.
9. Log prüfen.

Bestanden, wenn:

- Mission aktiviert wurde.
- Mission auf `FAILED` gesetzt wurde.
- Failure Effects vorbereitet wurden.
- CaptureSystem abgeschlossene Mission Effects verarbeitet.
- `applied=0` bleibt.
- `ready=0` bleibt.
- `contested=0` bleibt.
- kein Capture Pressure erzeugt wird.
- kein Lua-Fehler auftritt.

Erwartete Marker:

    Mission failed through F10
    Mission effects prepared state-only:
    Mission outcome prepared:
    Completed mission effects processed: applied=0
    Capture progress updated:

Bestätigte State Counts (2026-09-12): `available=8`, `active=0`, `completed=1`, `failed=1`, `statistics.available=8`, `statistics.active=0`, `statistics.completed=1`, `statistics.failed=1`, `total=10`.

Persistence: `SAVED`, `dirtyReason=f10_active_mission_1_failed`, `dirtyCleared=true`, `productiveRestore=false`.

---

## 24. End-to-End-Test: Embedded PersistenceSystem v0.2.6 Scheduler

Testdatum:

- 2026-08-04

Ziel:

Prüfen, ob das in die gespeicherte DEV-Mission eingebettete PersistenceSystem `v0.2.6` nach einem normalen Missionsstart selbständig einen Dirty-State speichert und folgende unveränderte Scheduler-Ticks ohne Dateischreibzugriff überspringt.

Bestätigte Mission und Einbettung:

- Mission: `Operation_Levant_Reclamation_DEV.miz`
- Trigger: `TC_LOAD_TC_PERSISTENCE_SYSTEM`
- Trigger-Typ: `once`
- Bedingung: `time-after 15 seconds`
- finale Ressource: `ResKey_advancedFile_56`
- eingebetteter Dateiname: `tc_persistence_system_v0_2_6.lua`
- eingebettete Bytes entsprachen exakt `src/campaign/tc_persistence_system.lua`
- die gespeicherte `.miz` enthielt den neuen Key und die neue Ressource
- der alte Trigger-Verweis `ResKey_Action_55` war im gespeicherten Mission-Trigger nicht mehr vorhanden; die Ressource selbst blieb verwaist in der `.miz` (nicht referenziert, nicht geladen, nicht ursächlich)

Normaler Missionsstart:

Die Mission wurde über den normalen Mission-Editor- und Simulator-Workflow gestartet. Das Spielerflugzeug ist als `CLIENT`, nicht als `PLAYER`, konfiguriert. Der manuelle Standardablauf lautet deshalb:

1. Mission im Mission Editor starten.
2. In der Client-Slotauswahl `CLIENT_BLUE_FA18C_AKROTIRI_01` auswählen.
3. Slot bestätigen.
4. Im Simulator-Briefing `Fly` drücken.

Dieser zusätzliche Client-Slot-Schritt muss bei künftigen automatisierten Mission-Editor-Tests berücksichtigt werden.

Bestätigte Runtime-Initialisierung:

- `TC.Campaign.PersistenceSystem.version == "0.2.6"`
- `loaded == true`
- `started == true`
- `autosaveEnabled == true`
- `autosaveScheduled == true`
- `autosaveRunning == true`
- `productiveRestore == false`

Bestätigter Scheduler-Marker:

    Persistence autosave scheduled: initialDelay=20s interval=120s productiveRestore=false

Erster realer geplanter Dirty-Save:

- Der erste vollständig initialisierte Campaign-State war bereits dirty.
- Dirty-Grund: `ai_cap_needs_evaluated`
- Dieser reale Campaign-System-Grund wurde weder ersetzt noch vor dem Scheduler-Tick gelöscht.
- `PersistenceSystem.autosave()` wurde nicht manuell aufgerufen.
- es war keine Persistence-F10- oder andere Spieleraktion erforderlich
- Der Scheduler protokollierte selbständig:

      Periodic autosave decision: SAVED dirtyReason=ai_cap_needs_evaluated

- `autosaveCount` wechselte von `0` auf `1`.
- `dirty` wechselte von `true` auf `false`.
- `dirtyReason` und `dirtyAt` wurden erst nach erfolgreicher Schreib-, Read-back- und Validierungsprüfung gelöscht.
- `lastAutosaveStatus == "SAVED"`
- `lastAutosaveReason == "autosave_completed"`
- `lastAutosaveDirtyReason == "ai_cap_needs_evaluated"`
- die Campaign-Save-Datei wurde erfolgreich aktualisiert

Erster und weitere reale unveränderte Scheduler-Ticks:

- Der erste folgende unveränderte 120-Sekunden-Tick protokollierte:

      Periodic autosave decision: SKIPPED detail=state_unchanged productiveRestore=false

- Zwei weitere unveränderte geplante Ticks erzeugten dieselbe `SKIPPED`-Entscheidung.
- `lastAutosaveStatus == "SKIPPED"`
- `lastAutosaveReason == "state_unchanged"`
- `dirty == false`
- `dirtyReason == nil`
- `dirtyAt == nil`
- `autosaveCount` blieb exakt `1`
- die Campaign-Save-Datei blieb über den `SKIPPED`-Tick unverändert:
  - gleiche Dateigröße
  - gleiche Änderungszeit
  - gleiche SHA-256-Prüfsumme

Fehlerprüfung:

- kein neuer `SCRIPTING ERROR`
- kein neuer `Mission script error`
- kein neuer `stack traceback`
- kein neuer `[TC][ERROR]`
- kein neuer `[TC][WARN]`

Gesamtbewertung:

- Embedded PersistenceSystem `v0.2.6` Normal-Load: **BESTANDEN**
- realer geplanter Dirty-Save: **BESTANDEN**
- realer geplanter unveränderter Skip: **BESTANDEN**
- Save-Datei-Nichtschreiben bei `SKIPPED`: **BESTANDEN**
- die frühere Hotload-only-Einschränkung für den Scheduler ist damit behoben
- der künstliche Testgrund `embedded_v0_2_6_scheduled_autosave_test` war nicht erforderlich, weil bereits ein gültiger realer Dirty-Grund vorlag

Historischer Kontext:

- Der Background-Autosave von `v0.2.5` war zuvor grundsätzlich bestanden.
- Die `SAVED`-, `SKIPPED`-, `FAILED`- und Retry-Pfade von `v0.2.6` waren zuvor per kontrolliertem Hotload geprüft worden.
- Der Test vom 2026-08-04 bestätigte zusätzlich den normalen Embedded-Start und die echten periodischen `v0.2.6`-Scheduler-Ticks.

Dieser Test bleibt weiterhin bestanden; die `SAVED`-/`SKIPPED`-Grundlage bleibt gültig, der kontrollierte `FAILED`-/Retry-Pfad ist ebenfalls bestanden. Die nachfolgenden Campaign-Persistence-Regressionen (Mission Completion, Mission Failure, Capture Ready Apply) sind inzwischen am 2026-09-12 ebenfalls bestanden (siehe Abschnitt 25).

---

## 25. Embedded-v0.2.6-Campaign-Regressionen — 2026-09-12

Alle drei ehemals ausstehenden Tests sind BESTANDEN:

1. Mission Completion Regression — `SAVED`, `dirtyReason=f10_active_mission_1_completed`, `dirtyCleared=true`, `productiveRestore=false`.
2. Mission Failure Regression — `SAVED`, `dirtyReason=f10_active_mission_1_failed`, `dirtyCleared=true`, `productiveRestore=false`.
3. Capture Ready Apply Regression — `SAVED`, `dirtyReason=f10_capture_ready_zone_1_applied`, `dirtyCleared=true`, `productiveRestore=false`.

Zusätzlich:

Capture Read Dirty Regression: 7 Getter getestet (`getCaptureReadyZones`, `getPressureContestedZones`, `getPressureSummary`, `getCaptureEligibleBases`, `getCaptureEligibleZones`, `getEligibilitySummary`, `getCaptureProgress`) — alle `dirty=false`, `reason=nil`.

Positive Mutation: eine echte Capture-Pressure-Mutation ergibt `reason=capture_pressure_set` -> `dirty=true`.

Ownership No-Op: `dirty=false`, keine relevanten Timestamp-/Progress-/lastUpdate-Änderungen.

Priority 3 ist damit NICHT abgeschlossen, weil noch vier allgemeine Modul-Audits ausstehen (Logistics, FOB, MissionGenerator, AICapManager).

Testgrundsätze:

- vorhandene reale Dirty-Gründe nicht ersetzen oder vorzeitig löschen
- keinen manuellen Autosave verwenden, wenn Scheduler-Verhalten geprüft wird
- keine Persistence-F10-Steuerung ergänzen
- keine echten MOOSE-, CTLD- oder Skynet-Aktionen auslösen
- nach jedem Test neue Logzeilen und den Save-Dateistand prüfen

---

## 25A. Historische MissionGenerator-Diagnose — am 2026-09-12 widerlegt

Der folgende Befund war der Wissensstand vom 2026-08-04 und führte zum Offline-Audit. Er wird hier als historische Evidenz erhalten, gilt aber nicht mehr als aktueller Projektstatus (siehe “Auflösung am 2026-09-12” unten).

Bestätigter Lauf am 2026-08-04:

- MissionGenerator `v0.2.3` wurde geladen und gestartet.
- `MissionGenerator.start()` erzeugte den initialen Pool mit zehn Missionen.
- `lastMissionId` erreichte `10`; die Generation-Statistik blieb ebenfalls auf zehn erzeugten Missionen.
- In einem späteren read-only Runtime-Befund waren `available`, `active`, `completed`, `failed`, `expired` und `cancelled` alle leer.
- Die sechs Status-Collections sind Dictionaries nach Mission Key.
- F10 und die öffentliche Available-Abfrage fanden deshalb keine auswählbare Mission.
- Ein zweiter normaler Lauf reproduzierte die Abfolge „zehn erzeugt, später alle sechs Collections leer”.
- Eine Diagnoseabfrage meldete zugleich `pairs=0` und `#=1` für History.

Damalige statische Klassifikation:

```text
PROJECT SOURCE HAS NO MATCHING WRITE SITE
```

Damaliger nächster Schritt: `Operation_Levant_Reclamation_DEV.miz` offline und strikt read-only auditieren (Offline Embedded Mission Resource Audit).

### Auflösung am 2026-09-12

- Mission Records waren nie verloren.
- `State.Missions.*` sind String-keyed Dictionaries.
- `#` war als Diagnoseinstrument ungeeignet — es liefert auf diesen Dictionaries keinen autoritativen Count.
- Live bestätigt: `statistics.available=10`, `pairs()`-Count `=10`, `#available=0`.
- Der Source-Bug lag in `src/core/tc_state.lua` -> `State.summary()`.
- Fix: pairs-basierte `countEntries()`-Funktion, implementiert und live bestätigt.
- Eine repo-weite Prüfung fand keine weiteren entsprechenden `#`-Bugs auf Mission-State-Dictionaries.
- Das Offline Embedded Audit ist bestanden: 13/13 `EXACT_MATCH`, keine aktive Runtime-Drift.
- Die ursprüngliche Klassifikation `PROJECT SOURCE HAS NO MATCHING WRITE SITE` bleibt nur historische Diagnose, nicht aktueller Projektstatus.

Die Aussage “Ursache, Writer und Mechanismus bleiben unbekannt” gilt nicht mehr als aktueller Stand — vollständige Herleitung siehe `TASKS.md`.

---

## 25B. Capture Dirty Read/Mutation Regression — 2026-09-12

Vor Fix:

    clearDirty()
    getCaptureReadyZones()

    -> dirty=true
    -> reason=capture_progress_updated

Nach Fix, alle sieben geprüften Getter:

    getCaptureReadyZones
    getPressureContestedZones
    getPressureSummary
    getCaptureEligibleBases
    getCaptureEligibleZones
    getEligibilitySummary
    getCaptureProgress

Ergebnis für alle sieben:

- `dirty=false`
- `reason=nil`

Positive Gegenprobe:

- `before=0`
- `changed=1`
- `dirty=true`
- `reason=capture_pressure_set`

Rollback:

- `restored=0`
- `finalDirty=false`

Status:

- BESTANDEN.

---

## 25C. Capture Ownership No-Op Regression — 2026-09-12

Zone:

- `ZONE_AIRBASE_ABU_AL_DUHUR`

Ergebnis:

- `ok=true`
- `owner=RED`
- `zonePrevBefore=nil`
- `zonePrevAfter=nil`
- `progressPrevBefore=UNKNOWN`
- `progressPrevAfter=UNKNOWN`
- `zoneUpdatedSame=true`
- `lastOwnerCheckSame=true`
- `progressUpdatedSame=true`
- `captureLastUpdateSame=true`
- `dirty=false`
- `reason=nil`

Status:

- BEHOBEN / LIVE BESTANDEN.

---

## 26. Fehlerindikatoren

Folgende Marker sind kritisch:

- `[TC][ERROR]`
- `SCRIPTING ERROR`
- `Mission script error`
- `stack traceback`
- `attempt to index`
- `attempt to call`
- `nil value`
- `protected call failed`

Bei diesen Markern:

1. betroffene Datei identifizieren
2. Version im Log prüfen
3. Stacktrace prüfen
4. letzte Änderung isolieren
5. keine weitere Datei ändern, bis der Fehler behoben ist

---

## 27. Nicht automatisch Theater-Command-Fehler

Folgende DCS-Meldungen sind aktuell nicht automatisch als Theater-Command-Fehler zu werten, solange keine Theater-Command-Fehlermarker im direkten Zusammenhang auftreten:

- `DTC_MANAGER Window pointer is null`
- `LUA-TERRAIN getObjectPosition`
- `DX11BACKEND ... render target ... not found`
- `INVALID ATC`
- `ModelTimeQuantizer`
- `Destruction shape not found`
- negative drag / weapon drag warnings
- vereinzelte DCS-Grafik-/Terrain-/ATC-Warnings

Bewertung:

- Diese Meldungen können im DCS-Log vorkommen.
- Sie sind nur relevant, wenn sie direkt mit Theater-Command-Funktionalität korrelieren.
- Primär zählen Theater-Command-Marker und Lua-Scripting-Fehler.

---

## 28. Testauswertung

Bei jeder Logauswertung prüfen:

1. Welche Modulversionen wurden geladen?
2. Wurde die erwartete Datei wirklich in DCS eingebettet?
3. Sind alle erwarteten Startmarker vorhanden?
4. Sind alle erwarteten Runtime-Marker vorhanden?
5. Gibt es `[TC][ERROR]`?
6. Gibt es `SCRIPTING ERROR`?
7. Gibt es `Mission script error`?
8. Gibt es `stack traceback`?
9. Gibt es `attempt to`?
10. Stimmen die erwarteten Zählwerte?
11. Wurden alte Testmarker versehentlich erneut geladen?
12. Ist das beobachtete Verhalten state-only oder wurde versehentlich ein Framework produktiv ausgelöst?

---

## 29. Testprotokoll-Vorlage

Für neue Tests kann diese Struktur verwendet werden:

    Datum:
    DCS-Version:
    Mission:
    getestete Datei:
    erwartete Version:
    tatsächliche Version im Log:
    Testziel:
    Testablauf:
    erwartete Marker:
    gefundene Marker:
    Fehlerindikatoren:
    Ergebnis:
    Nächster Schritt:

Beispiel:

    Datum: 2026-08-04
    Mission: Operation_Levant_Reclamation_DEV.miz
    getestete Datei: src/campaign/tc_persistence_system.lua
    erwartete Version: v0.2.6
    tatsächliche Version im Log: v0.2.6
    Testziel: Embedded-Scheduler für Dirty-Save und unveränderten Skip prüfen
    Ergebnis: bestanden

---

## 30. Aktuelle bestätigte Testwerte

### Airbase Scanner

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

### ZoneFactory

- total zones: `46`
- skipped airbase-like objects: `179`
- captureZones: `32`
- missionZones: `32`
- logisticsZones: `46`
- startBaseZones: `1`

### CaptureSystem

- eligibleBases: `32`
- eligibleZones: `32`
- nonCaptureBases: `193`
- nonCaptureZones: `14`
- pressureRecords: `32`
- progressRecords: `32`
- Read Dirty Regression: 7 Getter, alle `dirty=false`/`reason=nil` (siehe Abschnitt 25B)
- Ownership No-Op Regression: `dirty=false`, keine relevanten Mutationen (siehe Abschnitt 25C)

### LogisticsDelivery

- logistics hubs: `46`
- blue hubs: `7`
- red hubs: `24`
- neutral hubs: `15`
- active hubs: `31`
- limited hubs: `15`
- locked hubs: `0`

### FobSystem

- FOB candidates: `6`
- stored candidates: `6`
- auto-planned FOBs: `2`
- skipped candidates: `4`

### MissionGenerator

- mission candidates: `78`
- fobSupportCandidates: `2`
- generated missions: `10`
- Mission Records vorhanden: `statistics.available=10`, `pairs()`-Count `available=10`, `#available=0` (String-keyed Dictionary)
- reservedCreated: `1`
- duplicatesSkipped: `1`
- typeLimitSkipped: `68`
- lastMissionId: `10`
- Record-Loss-Verdacht widerlegt (siehe Abschnitt 25A)
- Activation / Completion / Failure / Effects bestanden

### AICapManager

- cap zone candidates: `31`
- auto-registered CAP zones: `12`
- CAP requests: `12`
- reactionState: `AIR_REACTION_REQUESTED`
- threatLevel: `HIGH`

### F10Menu

- commands: `33`

### PersistenceSystem

- version: `v0.2.6`
- fileSystemAvailable: `true`
- io: `true`
- lfs: `true`
- os: `true`
- require: `false`
- load: `true`
- loadstring: `true`
- loadfile: `true`
- autosaveEnabled: `true`
- autosaveScheduled: `true`
- autosaveRunning: `true`
- autosaveInitialDelay: `20s`
- autosaveInterval: `120s`
- letzter bestätigter lastAutosaveStatus: `SKIPPED`
- letzter bestätigter lastAutosaveReason: `state_unchanged`
- letzter bestätigter autosaveCount: `1` nach einem `SAVED` und drei `SKIPPED`-Ticks
- letzter bestätigter dirty-State: `false`
- productiveRestore: `false`
- `FAILED` bestanden
- Retry bestanden
- Mission Completion Persistence Regression bestanden
- Mission Failure Persistence Regression bestanden
- Capture Ready Apply Persistence Regression bestanden

---

## 31. Aktuelle Einschränkungen

Noch nicht testbar beziehungsweise noch nicht produktiv:

- echte MOOSE-Spawns
- echte CTLD-Logistikaktionen
- echte CTLD-FOBs
- echte CTLD-Crates
- echte Skynet-IADS-Kampagnenlogik
- produktiver AI Director
- automatische Missionserfolgserkennung über DCS-Events
- automatische Capture-Auswertung über reale DCS-Einheiten/Zonen
- produktiver automatischer Restore beim Missionsstart
- automatische `.miz`-Generierung
- Blue-/Red-KI-Kampagnenoperationen
- allgemeine Priority-3-Dirty-Coverage noch offen für: LogisticsDelivery, FobSystem, MissionGenerator, AICapManager

Aktuell bewusst state-only:

- Mission Activation
- Mission Completion
- Mission Failure
- Mission Effects
- Capture Pressure
- Capture Ready Apply
- Zone Ownership Update
- Airbase Ownership Sync
- Persistence Snapshot Save

---

## 32. Abschlussstand 2026-09-12

Bestanden:

- Starttest Variante A
- Airbase Scanner
- ZoneFactory
- CaptureSystem
- LogisticsDelivery funktional
- FobSystem funktional
- MissionGenerator `v0.2.3`: Activation / Completion / Failure / Effects bestanden; Record-Loss-Verdacht widerlegt
- AICapManager state-first
- F10Menu
- Mission Completion Pipeline
- Mission Failure Pipeline
- Capture Ready Apply
- Persistence Sandbox Test
- Save / Read / Compile / Evaluate / Validation
- Controlled Import
- PersistenceSystem `v0.2.6` Embedded Start
- Scheduler (`20s`/`120s`)
- `SAVED`
- `SKIPPED`
- `FAILED`
- Retry
- Mission Completion Persistence Regression
- Mission Failure Persistence Regression
- Capture Ready Apply Persistence Regression
- Capture Getter Dirty-Neutralität
- Capture Ownership No-Op
- Embedded Resource Audit 13/13 `EXACT_MATCH`

Bewusste Grenze:

- `productiveRestore=false`

Priority 3:

- NICHT abgeschlossen.

Nächster Test-/Audit-Schritt:

- READ-ONLY Dirty-Coverage-Audit von `src/logistics/tc_logistics_delivery.lua`

---

## 33. Startpunkt für die nächste Session

Neue Sessions sollen zuerst den aktuellen GitHub-Stand prüfen.

Besonders prüfen:

- `README.md`
- `ROADMAP.md`
- `TASKS.md`
- `CHANGELOG.md`
- `ARCHITECTURE.md`
- `MISSION_EDITOR_SETUP.md`
- `docs/09_persistence.md`
- `docs/10_testing.md`

Für den nächsten technischen Audit:

- `src/logistics/tc_logistics_delivery.lua`
- `src/core/tc_state.lua`
- `src/campaign/tc_persistence_system.lua`

Danach nicht aus Erinnerung arbeiten.

Nächster Schwerpunkt:

- Priority 3
- READ-ONLY Dirty-Coverage-Audit
- `src/logistics/tc_logistics_delivery.lua`

Audit-Ziele:

1. Alle persistierten Logistics-State-Writes identifizieren.
2. Alle `markDirty()`-Pfade erfassen.
3. Prüfen, ob echte State-Mutationen zuverlässig dirty setzen.
4. Prüfen, ob Reads/No-Ops unnötig dirty setzen.
5. Dirty Reasons bewerten.
6. Call-Sites erfassen.
7. Keine Codeänderung ohne belegten Befund.
8. Kein paralleler Audit von FOB/MissionGenerator/AI.

Nicht mehr Gegenstand dieses Schritts:

- Offline Embedded Resource Audit (bereits bestanden)
- Mission-Record-Loss-Untersuchung (widerlegt)
- blockierte Completion-/Failure-/Capture-Regressionen (bestanden)

---

## Footer

Testing bleibt der Sicherheitsrahmen des Projekts.

Aktueller Leitsatz:

- Eine Datei.
- Ein Test.
- Ein Log.
- Eine klare Bewertung.

Der nächste Testschritt ist:

- READ-ONLY Dirty-Coverage-Audit von `src/logistics/tc_logistics_delivery.lua`.

Priority 3 bleibt offen und wird weiterhin ein System pro Schritt abgearbeitet.
