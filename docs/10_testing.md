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
- produktiver Restore bleibt deaktiviert, bis Dirty-/Change-Hooks stabil getestet sind.

---

## 3. Aktueller Teststand

Stand:

- 2026-07-06

Aktueller Gesamtstatus:

- State-first Runtime-Grundlage bestanden.
- Mission Outcome to Capture Pressure Pipeline bestanden.
- Mission Failure Pipeline bestanden.
- Capture Ready über F10 sichtbar bestätigt.
- Capture Ready Apply state-only bestanden.
- Zone Ownership state-only update bestanden.
- linked Airbase Ownership state-only sync bestanden.
- Persistence File Save/Read/Validate/Import technisch bestanden.
- Persistence Background Autosave bestanden.
- produktiver Auto-Restore bewusst noch deaktiviert.

Bestätigte Systeme:

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.5` | bestanden |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | bestanden |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden |

Aktuelle bestätigte Fähigkeiten:

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
- PersistenceSystem speichert Campaign-State automatisch im Hintergrund.
- Es werden keine echten MOOSE-, CTLD- oder Skynet-Aktionen ausgelöst.

---

## 4. Aktuelle DEV-Mission

Aktuelle technische Entwicklungsmission:

    Operation_Levant_Reclamation_DEV.miz

Aktueller Inhalt:

- Map: Syria
- Koalitionspreset: Modern
- Blue Start: Akrotiri / Zypern
- erster blauer Client-Slot: F/A-18C Lot 20 auf Akrotiri
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
- Persistence Background Autosave aktiv

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
    [TC] [PersistenceSystem] Loaded src/campaign/tc_persistence_system.lua v0.2.5
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

---

## 19. Erwartete Persistence-Logmarker

PersistenceSystem Start:

    [TC] [PersistenceSystem] Loaded src/campaign/tc_persistence_system.lua v0.2.5
    [TC] [PersistenceSystem] Persistence system started

Sandbox-Verfügbarkeit:

    [TC] [PersistenceSystem] Persistence sandbox availability: os=false, io=true, lfs=true, require=false, load=true, loadstring=true, loadfile=true, lfsFromRequire=false

Sandbox-Test:

    [TC] [PersistenceSystem] Persistence sandbox file test passed:

Autosave-Planung:

    [TC] [PersistenceSystem] Persistence autosave scheduled: initialDelay=20s interval=120s productiveRestore=false

Initialisierung:

    [TC] [PersistenceSystem] Persistence system initialized: sandboxStatus=PASSED, fileSystemAvailable=true, autosaveScheduled=true, autosaveInterval=120s, productiveRestore=false

Autosave:

    [TC] [PersistenceSystem] Campaign state autosaved:

Erwartete Werte:

- `fileSystemAvailable=true`
- `autosaveScheduled=true`
- `productiveRestore=false`
- erster Autosave nach etwa 20 Sekunden
- danach Autosave alle 120 Sekunden
- letzter bestätigter Autosave-Test: `autosaveCount=1`

Wichtig:

Diese alten Testmarker sollen bei `v0.2.5` nicht mehr erscheinen:

    Persistence file save test scheduled
    Persistence file validation test scheduled
    Persistence file load test scheduled
    Campaign state file load test passed

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

Erwarteter Zustand:

- `io` entsperrt
- `lfs` entsperrt
- `os` gesperrt
- `require` gesperrt

Erwarteter Logstatus:

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

---

## 21. End-to-End-Test: Mission Completion zu Capture Ready

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

---

## 22. End-to-End-Test: Capture Ready Apply

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

---

## 23. End-to-End-Test: Mission Failure

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

---

## 24. End-to-End-Test: Persistence Background Autosave

Ziel:

Prüfen, ob Persistence ohne Spieler-F10-Aktion automatisch speichert.

Ablauf:

1. DCS mit frischem Log starten.
2. DEV-Mission starten.
3. keine Persistence-F10-Aktion ausführen.
4. Mission mindestens 30 Sekunden laufen lassen.
5. DCS beenden.
6. Log prüfen.

Bestanden, wenn:

- PersistenceSystem `v0.2.5` geladen wurde.
- Sandbox-Test bestanden ist.
- Autosave geplant wurde.
- Autosave automatisch ausgeführt wurde.
- `productiveRestore=false` bestätigt ist.
- kein alter Save-/Validate-/Load-Testtimer erscheint.
- kein Lua-Fehler auftritt.

Erwartete Marker:

    Loaded src/campaign/tc_persistence_system.lua v0.2.5
    Persistence sandbox availability: os=false, io=true, lfs=true
    Persistence sandbox file test passed
    Persistence autosave scheduled: initialDelay=20s interval=120s productiveRestore=false
    Persistence system initialized: sandboxStatus=PASSED, fileSystemAvailable=true, autosaveScheduled=true, autosaveInterval=120s, productiveRestore=false
    Campaign state autosaved

Nicht erwartete Marker:

    Persistence file save test scheduled
    Persistence file validation test scheduled
    Persistence file load test scheduled
    Campaign state file load test passed

---

## 25. Nächster geplanter Test: Capture Dirty-/Persistence-Hook

Nächste Datei:

- `src/campaign/tc_capture_system.lua`

Geplante Version:

- `v0.2.3`

Ziel:

- CaptureSystem soll bei erfolgreichem Capture Ready Apply den Kampagnenzustand als persistenzrelevant markieren.
- Persistence Autosave soll danach den geänderten State sichern.
- Kein Persistence-F10-Menü.
- Kein produktiver Restore.
- Keine echten MOOSE-/CTLD-/Skynet-Aktionen.

Geplanter Ablauf:

1. DCS mit frischem Log starten.
2. DEV-Mission starten.
3. Mission über F10 aktivieren.
4. Mission über F10 abschließen.
5. Capture Ready Zone 1 über F10 anwenden.
6. CaptureSystem loggt persistenzrelevante State-Änderung.
7. Persistence autosaved automatisch.
8. Log bestätigt Dirty-/Autosave-Zusammenhang.

Geplante Erfolgsmarker:

    [TC] [CaptureSystem] Zone captured:
    [TC] [CaptureSystem] Base captured:
    [TC] [CaptureSystem] Persistence dirty mark:
    [TC] [PersistenceSystem] Campaign state autosaved:

Akzeptanzkriterien:

- CaptureSystem lädt als neue Version.
- Mission Completion Pipeline bleibt stabil.
- Mission Failure Pipeline bleibt stabil.
- Capture Ready Apply bleibt stabil.
- Dirty-/Persistence-Hook wird geloggt.
- Autosave läuft weiterhin automatisch.
- kein `SCRIPTING ERROR`
- kein `Mission script error`
- kein `stack traceback`
- kein `[TC][ERROR]`
- keine echten Framework-Aktionen

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

    Datum: 2026-07-06
    getestete Datei: src/campaign/tc_persistence_system.lua
    erwartete Version: v0.2.5
    tatsächliche Version im Log: v0.2.5
    Testziel: Background Autosave ohne F10-Spieleraktion prüfen
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
- reservedCreated: `1`
- duplicatesSkipped: `1`
- typeLimitSkipped: `68`

### AICapManager

- cap zone candidates: `31`
- auto-registered CAP zones: `12`
- CAP requests: `12`
- reactionState: `AIR_REACTION_REQUESTED`
- threatLevel: `HIGH`

### F10Menu

- commands: `33`

### PersistenceSystem

- fileSystemAvailable: `true`
- io: `true`
- lfs: `true`
- os: `false`
- require: `false`
- load: `true`
- loadstring: `true`
- loadfile: `true`
- autosaveScheduled: `true`
- autosaveInterval: `120s`
- letzter bestätigter autosaveCount: `1`
- productiveRestore: `false`

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

## 32. Abschlussstand 2026-07-06

Bestanden:

- Starttest Variante A
- Airbase Scanner
- ZoneFactory
- CaptureSystem
- LogisticsDelivery
- FobSystem
- MissionGenerator
- AICapManager
- F10Menu
- Mission Completion Pipeline
- Mission Failure Pipeline
- Capture Ready Apply
- Persistence Sandbox Test
- Persistence File Save
- Persistence File Validation
- Persistence Controlled Import
- Persistence Background Autosave

Aktuelle wichtigste offene Testaufgabe:

- CaptureSystem Dirty-/Persistence-Hook testen

Nächste Datei:

- `src/campaign/tc_capture_system.lua`

Nächste geplante Version:

- `v0.2.3`

---

## 33. Startpunkt für die nächste Session

Neue Sessions sollen zuerst den aktuellen GitHub-Stand prüfen.

Besonders prüfen:

- `README.md`
- `ROADMAP.md`
- `TASKS.md`
- `CHANGELOG.md`
- `ARCHITECTURE.md`
- `docs/09_persistence.md`
- `docs/10_testing.md`
- `src/campaign/tc_capture_system.lua`
- `src/campaign/tc_persistence_system.lua`
- `src/ui/tc_f10_menu.lua`

Danach nicht aus Erinnerung arbeiten.

Nächster technischer Startpunkt:

- `src/campaign/tc_capture_system.lua`

Konkretes Ziel:

- `CaptureSystem v0.2.3`
- Dirty-/Persistence-Hook bei erfolgreichem Capture Ready Apply
- Background Autosave soll geänderten State sichern
- kein Persistence-F10-Menü
- kein produktiver Restore
- keine echten MOOSE-/CTLD-/Skynet-Aktionen

Erwarteter Test:

1. Mission starten.
2. Mission über F10 aktivieren.
3. Mission über F10 abschließen.
4. Capture Ready Zone 1 über F10 anwenden.
5. CaptureSystem markiert State als persistenzrelevant.
6. Persistence autosaved automatisch.
7. DCS-Log bestätigt Dirty-/Autosave-Zusammenhang.

---

## Footer

Testing bleibt der Sicherheitsrahmen des Projekts.

Aktueller Leitsatz:

- Eine Datei.
- Ein Test.
- Ein Log.
- Eine klare Bewertung.

Der nächste Testschritt ist:

- CaptureSystem an Persistence anbinden, ohne produktiven Restore und ohne echte Framework-Aktionen.
