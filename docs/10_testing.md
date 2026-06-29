# Testing

Diese Datei beschreibt die aktuelle Teststrategie für **Theater Command DCS**.

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## 1. Zweck dieser Datei

Diese Datei dokumentiert, wie Theater Command DCS aktuell getestet wird.

Sie soll sicherstellen, dass jede neue Datei und jedes neue System in DCS nachvollziehbar geprüft wird.

Das Projekt wird bewusst schrittweise getestet.

Grundregel:

    Eine konkrete Aufgabe.
    Eine Datei.
    Ein Test.
    Eine Logauswertung.

---

## 2. Testgrundsatz

Theater Command DCS folgt aktuell dem Prinzip:

    erst laden
    dann State erzeugen
    dann State sichtbar machen
    dann einzelne Wirkungen testen
    dann Framework-Ausführung aktivieren

Aktuell gilt:

- State-first vor echten Spawns
- F10-/Debug-Sichtbarkeit vor Mission Effects
- einzelne Module vor Systemketten
- DCS-Logauswertung vor weiteren Code-Schritten
- keine großen parallelen Änderungen
- keine Vendor-Dateien verändern

---

## 3. Aktueller Teststand

Stand:

    2026-06-29

Aktueller Gesamtstatus:

    State-first Runtime-Grundlage bestanden.

Bestätigte Systeme:

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

Aktuelle bestätigte Fähigkeit:

- DCS lädt Vendor-Frameworks.
- Theater Command lädt.
- Main startet.
- Loader beendet sauber.
- Runtime-Systeme initialisieren.
- Airbase Scanner klassifiziert Syria-Airbase-Daten.
- ZoneFactory erzeugt relevante Kampagnenzonen.
- CaptureSystem erzeugt Capture-Eligibility, Capture-Pressure und Capture-Progress.
- LogisticsDelivery erzeugt Logistics Hubs.
- FobSystem erzeugt FOB-Kandidaten und Blue-FOBs.
- MissionGenerator erzeugt Missionen inklusive FOB-Support.
- MissionGenerator erzeugt Objectives, Briefings, Progress-Daten und Activation Metadata.
- F10Menu ist sichtbar und navigierbar.
- F10Menu erlaubt direkte Missionsauswahl.
- F10Menu erlaubt direkte Missionsaktivierung.
- AICapManager erzeugt CAP-State.
- Es werden keine echten Spawns ausgelöst.

---

## 4. Aktuelle DEV-Mission

Aktuelle technische Entwicklungsmission:

    Operation_Levant_Reclamation_DEV.miz

Aktueller Inhalt:

    Map: Syria
    Koalitionspreset: Modern
    Blue Start: Akrotiri / Zypern
    erster blauer Client-Slot: F/A-18C Lot 20 auf Akrotiri
    sichere Einzeldatei-Ladung per DO SCRIPT FILE
    Vendor-Frameworks geladen
    Theater-Command-Source-Dateien geladen
    F10-Menü aktiv
    direkte Missionsauswahl aktiv
    direkte Missionsaktivierung aktiv

Noch nicht produktiv enthalten:

- rote Frontlinie
- produktive IADS-Stellungen
- CTLD-Zonen
- FOB-Zonen
- MOOSE-Template-Gruppen
- CTLD-Crates
- echte MOOSE-Spawns
- echte CTLD-FOBs
- produktive Persistenz

Bewertung:

    Die DEV-Mission ist ein technischer Testträger.
    Sie ist noch keine fertige spielbare Kampagnenmission.

---

## 5. Testumgebung

DCS:

    DCS World

Map:

    Syria

Repository lokal:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\

DCS-Logs:

    C:\Users\Paul\Saved Games\DCS\Logs\dcs.log

Möglicher Open-Beta-/Standalone-Pfad:

    C:\Users\Paul\Saved Games\DCS.openbeta\Logs\dcs.log

Schneller Zugriff:

    %USERPROFILE%\Saved Games

---

## 6. Wichtiger DCS-Hinweis

Eine per `DO SCRIPT FILE` geladene Lua-Datei wird in die `.miz` eingebettet.

Deshalb gilt nach jeder Lua-Änderung:

1. Datei auf GitHub aktualisieren
2. lokal per GitHub Desktop fetchen/pullen
3. DCS Mission Editor öffnen
4. geänderte Datei in der passenden `DO SCRIPT FILE`-Aktion neu auswählen
5. Mission speichern
6. Mission testen
7. frische `dcs.log` prüfen

Wenn dieser Schritt vergessen wird, testet DCS möglicherweise eine alte eingebettete Lua-Version.

---

## 7. Sauberer Logtest

Für jeden relevanten Test:

1. DCS beenden
2. alte `dcs.log` löschen oder umbenennen
3. DCS neu starten
4. Mission starten
5. gewünschte F10-/Runtime-Aktion ausführen
6. Mission beenden
7. DCS beenden
8. frische `dcs.log` hochladen oder auswerten

Warum:

    Alte Logs enthalten alte Testläufe.
    Ohne frische Logdatei können alte Fehler oder alte Versionen falsch bewertet werden.

---

## 8. Aktive Ladefolge

Aktuelle getestete Ladefolge im Mission Editor:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua
    6. src/core/tc_config.lua
    7. src/core/tc_logger.lua
    8. src/core/tc_state.lua
    9. src/core/tc_utils.lua
    10. src/core/tc_scheduler.lua
    11. src/world/tc_airbase_scanner.lua
    12. src/world/tc_zone_factory.lua
    13. src/campaign/tc_capture_system.lua
    14. src/campaign/tc_persistence_system.lua
    15. src/logistics/tc_logistics_delivery.lua
    16. src/logistics/tc_fob_system.lua
    17. src/missions/tc_mission_generator.lua
    18. src/ai/tc_ai_cap_manager.lua
    19. src/ui/tc_f10_menu.lua
    20. src/main.lua
    21. src/loader.lua

Wichtig:

    src/ui/tc_f10_menu.lua wird nach src/ai/tc_ai_cap_manager.lua und vor src/main.lua geladen.
    src/main.lua initialisiert Runtime-Systeme.
    src/loader.lua bleibt aktuell die letzte eigene Datei.

---

## 9. Starttest Variante A

Status:

    bestanden

Methode:

    sichere Einzeldatei-Ladung per DO SCRIPT FILE

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
- Loader sauber beendet

---

## 10. Starttest Variante B

Status:

    offen

Methode:

    Loader-only mit dofile

Ziel:

    Der Mission Editor lädt nur Frameworks und src/loader.lua.
    loader.lua lädt danach die eigenen Source-Dateien selbst.

Noch zu prüfen:

- funktioniert `dofile` im DCS Mission Scripting Environment?
- kann `loader.lua` Dateien aus dem lokalen Repository lesen?
- wie verhält sich die DCS-Sandbox?
- braucht das Projekt später eine Build-Datei?
- bleibt Einzeldatei-Ladung für Entwicklung besser?

Aktuelle Entscheidung:

    Variante A bleibt Standard, bis Variante B praktisch getestet ist.

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

---

## 12. Erwartete Modul-Logmarker

Aktueller getesteter Stand:

    [TC] [AirbaseScanner] Loaded src/world/tc_airbase_scanner.lua v0.2.2
    [TC] [ZoneFactory] Loaded src/world/tc_zone_factory.lua v0.2.0
    [TC] [CaptureSystem] Loaded src/campaign/tc_capture_system.lua v0.2.1
    [TC] [LogisticsDelivery] Loaded src/logistics/tc_logistics_delivery.lua v0.2.0
    [TC] [FobSystem] Loaded src/logistics/tc_fob_system.lua v0.2.0
    [TC] [MissionGenerator] Loaded src/missions/tc_mission_generator.lua v0.2.2
    [TC] [AICapManager] Loaded src/ai/tc_ai_cap_manager.lua v0.2.0
    [TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.0

Diese Marker zeigen, dass die richtigen Versionen in der `.miz` eingebettet und durch DCS geladen wurden.

Wenn eine alte Version erscheint, wurde die geänderte Datei wahrscheinlich nicht im Mission Editor neu ausgewählt oder die Mission nicht gespeichert.

---

## 13. Erwartete Airbase-Scanner-Werte

Aktueller bestandener Stand:

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

Bewertung:

    225 airbase-like objects sind auf Syria erwartbar.
    Das ist kein Fehler.
    Entscheidend ist die Klassifizierung.
    Akrotiri muss als Blue-Startbasis erkannt werden.

---

## 14. Erwartete ZoneFactory-Werte

Aktueller bestandener Stand:

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

Bewertung:

    ZoneFactory soll nicht 225 ungefilterte Zonen erzeugen.
    46 relevante Kampagnenzonen sind der aktuell bestandene Zielwert.
    179 übersprungene Airbase-like Objects sind erwartbar.

---

## 15. Erwartete CaptureSystem-Werte

Aktueller bestandener Stand:

    eligibleBases: 32
    eligibleZones: 32
    nonCaptureBases: 193
    nonCaptureZones: 14
    pressureRecords: 32
    progressRecords: 32
    appliedMissionEffects: 0
    ready: 0
    contested: 0

Erwartete Logmarker:

    [TC] [CaptureSystem] Capture progress updated: zones=32, ready=0, contested=0
    [TC] [CaptureSystem] Capture eligibility summary: bases=32, zones=32, nonCaptureBases=193, nonCaptureZones=14
    [TC] [CaptureSystem] Capture pressure summary: pressureRecords=32, progressRecords=32, appliedMissionEffects=0

Bewertung:

    CaptureSystem soll nur auf 32 capture-fähigen Zielen arbeiten.
    Capture-Pressure und Capture-Progress müssen 32 Records erzeugen.
    appliedMissionEffects=0 ist aktuell erwartbar, solange keine Mission Effects produktiv angewendet werden.

---

## 16. Erwartete LogisticsDelivery-Werte

Aktueller bestandener Stand:

    logistics hubs: 46
    blue hubs: 7
    red hubs: 24
    neutral hubs: 15
    active hubs: 31
    limited hubs: 15
    locked hubs: 0

Bewertung:

    LogisticsDelivery soll 46 Logistics Hubs erzeugen.
    CTLD wird noch nicht produktiv aufgerufen.
    Keine echten Cargo-Aktionen sind erwartbar.

---

## 17. Erwartete FobSystem-Werte

Aktueller bestandener Stand:

    FOB candidates: 6
    stored candidates: 6
    auto-planned FOBs: 2
    skipped candidates: 4
    Blue FOBs: 2

Erwartete FOBs:

    FOB Ercan
    FOB Gecitkale

Erwarteter Status:

    UNDER_CONSTRUCTION

Bewertung:

    FOBs sind state-only.
    Es werden noch keine echten CTLD-FOBs erzeugt.
    planned=0 in älteren Zusammenfassungen ist kein Fehler, wenn FOBs direkt in UNDER_CONSTRUCTION wechseln.

---

## 18. Erwartete MissionGenerator-Werte

Aktueller bestandener Stand:

    mission candidates: 69
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 30

Erwartete Logmarker:

    [TC] [MissionGenerator] Mission candidate summary: candidates=69, fobSupportCandidates=2, availableBefore=0, generationSlots=10
    [TC] [MissionGenerator] Mission generation completed: 10 new missions from 69 candidates (fobSupportCandidates=2, reservedCreated=1, duplicatesSkipped=1, typeLimitSkipped=30)

Bewertung:

    10 verfügbare Missionen sind aktuell erwartbar.
    Mindestens eine FOB-Support-Mission soll reserviert werden.
    Missionen bleiben state-only.

---

## 19. Erwartete Mission Activation Marker

Aktuell bestätigt:

    [TC] [MissionGenerator] Mission status changed: MISSION_1 [ACTIVE]
    [TC] [MissionGenerator] Mission status changed: MISSION_4 [ACTIVE]
    [TC] [MissionGenerator] Mission activation prepared: MISSION_4 stateOnly=true spawnHooks=reserved
    [TC] [F10Menu] Mission activated through F10: slot=1 key=MISSION_1
    [TC] [F10Menu] Mission activated through F10: slot=5 key=MISSION_4

Bewertung:

    Mission Activation bedeutet aktuell Statuswechsel im State.
    Es werden keine echten Spawns erwartet.
    stateOnly=true und spawnHooks=reserved sind korrekt.

---

## 20. Erwartete AICapManager-Werte

Aktueller bestandener Stand:

    cap zone candidates: 31
    auto-registered CAP zones: 12
    CAP requests: 12
    reactionState: AIR_REACTION_REQUESTED
    threatLevel: HIGH

Bewertung:

    AI CAP Manager erzeugt CAP-State.
    MOOSE-CAP-Spawns sind noch nicht aktiv.
    spawn=MOOSE_PENDING ist erwartbar.

---

## 21. Erwartete F10Menu-Werte

Aktueller bestandener Stand:

    F10Menu version: v0.2.0
    commands: 26

Bestätigte F10-Funktionen:

- F10-Menü sichtbar
- F10-Menü navigierbar
- Show Available Missions
- Show Active Missions
- Mission Details Slot 1
- Mission Details Slot 2
- Mission Details Slot 5
- Activate Mission 1
- Activate Mission 5
- Show Campaign Status
- Show Logistics Status
- Show FOB Status
- Show AI CAP Status

Erwartete Logmarker:

    [TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.0
    [TC] [F10Menu] F10 menu started
    [TC] [F10Menu] F10 menu initialized: commands=26
    [TC] System started: F10 Menu
    [TC] [F10Menu] Mission details shown through F10: slot=1 key=MISSION_1
    [TC] [F10Menu] Mission activated through F10: slot=1 key=MISSION_1

Bewertung:

    F10Menu ist bestanden.
    Der nächste Testschritt soll Capture-/Pressure-Sichtbarkeit im F10-Menü ergänzen.

---

## 22. Fehler, die echte Blocker sind

Als Blocker gelten:

- `stack traceback` in Theater-Command-Dateien
- `attempt to index nil value` in Theater-Command-Dateien
- `attempt to call nil value` in Theater-Command-Dateien
- `[TC][ERROR]` mit Startabbruch
- fehlender Main-Start
- fehlender Loader-Abschluss
- fehlendes Framework, obwohl es geladen werden soll
- F10Menu startet nicht
- MissionGenerator erzeugt keine Missionen
- CaptureSystem bricht ab
- ZoneFactory erzeugt keine relevanten Zonen
- geänderte Datei zeigt im Log noch alte Version

---

## 23. Fehler, die nicht automatisch Blocker sind

DCS kann viele interne Meldungen erzeugen.

Nicht automatisch Theater-Command-Blocker:

- `INVALID ATC`
- `missing object declaration`
- `texture not found`
- `DTC_MANAGER`
- `Window pointer is null`
- `getObjectPosition: object is not exists`
- `Destruction shape not found`
- Rendering-Meldungen
- Terrain-Meldungen
- Sound-Meldungen
- einzelne DCS-interne Warnings ohne Theater-Command-Bezug

Diese Meldungen sind nur dann relevant, wenn sie klar mit Theater-Command-Lua oder einem aktiven Framework-Schritt zusammenhängen.

---

## 24. Versionstest

Jeder Lua-Test muss prüfen, ob die richtige Dateiversion geladen wurde.

Beispiele:

    [TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.0
    [TC] [MissionGenerator] Loaded src/missions/tc_mission_generator.lua v0.2.2
    [TC] [CaptureSystem] Loaded src/campaign/tc_capture_system.lua v0.2.1

Wenn eine alte Version erscheint:

1. lokale GitHub-Kopie prüfen
2. Datei im Mission Editor neu auswählen
3. Mission speichern
4. DCS neu starten
5. frischen Logtest durchführen

---

## 25. F10-Testverfahren

Für F10-Tests:

1. Mission starten
2. Spieler-Slot betreten
3. F10-Menü öffnen
4. `Theater Command` prüfen
5. Untermenüs prüfen
6. erwartete Commands prüfen
7. relevante Commands auslösen
8. Log prüfen

Aktuell getestete F10-Kommandos:

- Show Available Missions
- Show Active Missions
- Show Mission 1 Details
- Show Mission 2 Details
- Show Mission 5 Details
- Activate Mission 1
- Activate Mission 5
- Show Campaign Status
- Show Logistics Status
- Show FOB Status
- Show AI CAP Status

Nächste geplante F10-Kommandos:

- Show Capture Status
- Show Capture Ready Zones
- Show Pressure Contested Zones

---

## 26. Mission Activation Testverfahren

Für Mission Activation:

1. Mission starten
2. F10 öffnen
3. Theater Command öffnen
4. Missions öffnen
5. Mission Details prüfen
6. Activate Mission auswählen
7. gewünschte Mission aktivieren
8. Log prüfen

Erwartet:

    F10Menu meldet Aktivierung.
    MissionGenerator setzt Mission auf ACTIVE.
    MissionGenerator meldet stateOnly=true.
    MissionGenerator meldet spawnHooks=reserved.
    keine echten Spawns.

Nicht erwartet:

    echte MOOSE-Flüge
    echte CTLD-Aktionen
    echte Skynet-Aktionen
    DCS-Einheitenspawn durch Mission Activation

---

## 27. Capture Testverfahren

Aktueller Stand:

    CaptureSystem erzeugt Capture-Eligibility, Pressure und Progress.
    Capture Effects werden noch nicht produktiv getestet.

Aktuell zu prüfen:

- CaptureSystem lädt
- eligibleBases = 32
- eligibleZones = 32
- pressureRecords = 32
- progressRecords = 32
- appliedMissionEffects = 0
- ready = 0
- contested = 0

Nächster Capture-Test:

    Capture-/Pressure-Status über F10 anzeigen.

Erwartet nach nächster F10-Erweiterung:

- Show Capture Status funktioniert
- Show Capture Ready Zones funktioniert
- Show Pressure Contested Zones funktioniert
- Logmarker bestätigen F10-Aufruf
- keine echten Spawns
- keine CTLD-Aktionen
- keine Skynet-Aktionen

---

## 28. Logistics Testverfahren

Aktuell zu prüfen:

- LogisticsDelivery lädt
- LogisticsDelivery startet
- 46 Logistics Hubs werden erzeugt
- Hub-Verteilung stimmt
- FobSystem lädt
- FobSystem startet
- 6 FOB-Kandidaten werden erkannt
- 2 Blue-FOBs werden erzeugt
- FOBs stehen auf UNDER_CONSTRUCTION
- MissionGenerator erkennt FOB-Support-Kandidaten

Nicht erwartet:

- echte CTLD-Cargo-Aktionen
- echte CTLD-FOBs
- Cargo-Verbrauch
- echte Pickup-/Dropoff-Zonen

---

## 29. AI Testverfahren

Aktuell zu prüfen:

- AICapManager lädt
- AICapManager startet
- CAP-Zonen-Kandidaten werden erkannt
- CAP-Zonen werden registriert
- CAP Requests werden erzeugt
- reactionState wird gesetzt
- threatLevel wird gesetzt

Nicht erwartet:

- echte MOOSE-CAP-Flüge
- AI_A2A_DISPATCHER-Aktivität
- echte GCI-Reaktionen
- echte Red-/Blue-Operationen

---

## 30. Persistence Testverfahren

Aktueller Stand:

    PersistenceSystem lädt/startet als Grundstruktur.
    produktiver Dateischreibtest offen.

Vor produktiver Persistenz zu prüfen:

- darf DCS in der aktuellen Umgebung Dateien schreiben?
- welcher Pfad ist geeignet?
- kann eine Testdatei erzeugt werden?
- kann eine Testdatei gelesen werden?
- bleibt der Test robust bei fehlender Datei?
- wird eine defekte Datei sicher behandelt?

Aktuell nicht testen:

- vollständige Kampagnenpersistenz
- Save/Load aller Systeme
- automatische Persistenz nach Mission Events

---

## 31. IADS Testverfahren

Aktueller Stand:

    Skynet IADS wird als Vendor geladen.
    Theater-Command-IADS-Modul ist noch nicht aktiv.

Aktuell zu prüfen:

- Skynet IADS wird geladen
- Loader erkennt Skynet IADS
- keine Skynet-bezogenen Startabbrüche

Nicht erwartet:

- echte IADS-Sektoren
- echte SAM-Netzwerke
- IADS-Status im Theater-Command-State
- SEAD-/DEAD-Wirkung auf Skynet
- IADS-Persistenz

---

## 32. Testcheckliste nach jeder Lua-Änderung

Nach jeder Lua-Änderung:

1. vollständige Datei auf GitHub ersetzen
2. Commit durchführen
3. lokal fetchen/pullen
4. geänderte Datei im Mission Editor neu auswählen
5. Mission speichern
6. alte `dcs.log` löschen oder umbenennen
7. DCS starten
8. Mission starten
9. relevante Funktion testen
10. DCS beenden
11. `dcs.log` prüfen
12. richtige Version prüfen
13. Fehler prüfen
14. Ergebnis dokumentieren

---

## 33. Testcheckliste für neue Module

Bei neuen Modulen:

1. Datei nach `src/` in passenden Fachordner legen
2. keine Vendor-Dateien ändern
3. Modulversion im Log ausgeben
4. defensive Checks einbauen
5. State sicher initialisieren
6. keine echten Framework-Aktionen im ersten Schritt
7. Ladefolge dokumentieren
8. Mission Editor Trigger ergänzen
9. Testlauf durchführen
10. Logmarker prüfen
11. Ergebnis in `TASKS.md` und `CHANGELOG.md` dokumentieren

---

## 34. Aktuelle nächste Testaufgabe

Nächste empfohlene Datei:

    src/ui/tc_f10_menu.lua

Ziel:

    Capture-/Pressure-Status im F10-Menü sichtbar machen.

Geplante neue Commands:

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

Erwartete neue Logmarker nach Umsetzung:

    [TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.1
    [TC] [F10Menu] F10 menu initialized:
    [TC] [F10Menu] Capture status shown through F10
    [TC] [F10Menu] Capture ready zones shown through F10
    [TC] [F10Menu] Pressure contested zones shown through F10

---

## 35. Wann ein Test als bestanden gilt

Ein Test gilt als bestanden, wenn:

- richtige Datei-Version geladen wird
- erwartete Logmarker erscheinen
- erwartete State-Werte erzeugt werden
- keine Theater-Command-Fehler auftreten
- keine Lua-Stacktraces auftreten
- Main startet
- Loader beendet sauber
- bestehende Funktionen nicht regressieren
- neue Funktion im Log und/oder F10 sichtbar ist

---

## 36. Wann ein Test nicht bestanden ist

Ein Test ist nicht bestanden, wenn:

- falsche Dateiversion geladen wird
- Datei offenbar nicht neu in `.miz` eingebettet wurde
- Theater-Command-Start abbricht
- Main nicht startet
- Loader nicht beendet
- F10Menu nicht erscheint
- MissionGenerator keine Missionen erzeugt
- CaptureSystem abbricht
- neue Funktion im F10 nicht erscheint
- neue Funktion keine Logmarker erzeugt
- Lua-Stacktrace auftritt
- State-Werte offensichtlich fehlen oder leer sind

---

## 37. Aktueller Abschlussstatus

Die aktuelle Testbasis ist ausreichend stabil für den nächsten UI-/Debug-Schritt.

Bestanden:

- Framework-Ladung
- Core-Ladung
- World-Ladung
- Campaign-Ladung
- Logistics-Ladung
- Missions-Ladung
- AI-Ladung
- UI-Ladung
- Main-Start
- Loader-Abschluss
- Airbase-Klassifizierung
- relevante Zonenbildung
- Capture-Pressure-Grundlage
- Capture-Progress-Grundlage
- Logistics-Hub-Erzeugung
- FOB-State-Erzeugung
- Missionserzeugung
- Mission Activation über F10
- AI-CAP-State
- F10-Spieleroberfläche

Noch nicht bestanden, weil noch nicht gebaut:

- echte MOOSE-Spawns
- echte CTLD-Aktionen
- echte Skynet-IADS-Wirkung
- produktive Persistenz
- Mission completed/failed
- automatische Missionserfolgsauswertung
- automatische Capture-Auswertung
- AI Director
- Loader-only-dofile-Test

Nächster Testschritt:

    F10Menu v0.2.1 mit Capture-/Pressure-Sichtbarkeit.
