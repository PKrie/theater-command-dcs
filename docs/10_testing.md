# Testing

Diese Datei beschreibt die aktuelle Teststrategie für **Theater Command DCS**.

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

## 1. Zweck dieser Datei

Diese Datei dokumentiert, wie Theater Command DCS aktuell getestet wird.

Sie soll sicherstellen, dass jede neue Datei, jedes neue System und jede neue Systemverknüpfung in DCS nachvollziehbar geprüft wird.

Das Projekt wird bewusst schrittweise getestet.

Grundregel:

```text
Eine konkrete Aufgabe.
Eine Datei.
Ein Test.
Eine Logauswertung.
Eine Dokumentationsaktualisierung.
```

---

## 2. Testgrundsatz

Theater Command DCS folgt aktuell dem Prinzip:

```text
erst laden
dann State erzeugen
dann State sichtbar machen
dann einzelne Wirkungen testen
dann kontrollierte State-Änderungen testen
dann Persistenz testen
dann Framework-Ausführung aktivieren
```

Aktuell gilt:

- State-first vor echten Spawns
- F10-/Debug-Sichtbarkeit vor produktiven Kampagnenfolgen
- einzelne Module vor Systemketten
- Systemketten erst state-only bestätigen
- DCS-Logauswertung vor weiteren Code-Schritten
- keine großen parallelen Änderungen
- keine Vendor-Dateien verändern
- kein automatischer produktiver Ownership-Wechsel ohne kontrollierten Testpfad
- keine echten MOOSE-, CTLD- oder Skynet-Aktionen ohne vorbereitete Templates/Zonen

---

## 3. Aktueller Teststand

Stand: **2026-07-06**

Aktueller Gesamtstatus:

- **State-first Runtime-Grundlage bestanden**
- **Mission Outcome to Capture Pressure Pipeline bestanden**
- **Capture Ready über F10 sichtbar bestätigt**

Bestätigte Systeme:

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

Aktuelle bestätigte Fähigkeit:

- DCS lädt Vendor-Frameworks.
- Theater Command lädt.
- Main startet.
- Loader beendet sauber.
- Runtime-Systeme initialisieren.
- Airbase Scanner klassifiziert Syria-Airbase-Daten.
- ZoneFactory erzeugt relevante Kampagnenzonen.
- CaptureSystem erzeugt Capture-Eligibility, Capture-Pressure und Capture-Progress.
- CaptureSystem verarbeitet abgeschlossene Mission Effects state-only in Capture Pressure.
- LogisticsDelivery erzeugt Logistics Hubs.
- FobSystem erzeugt FOB-Kandidaten und Blue-FOBs.
- MissionGenerator erzeugt Missionen inklusive FOB-Support.
- MissionGenerator erzeugt Objectives, Briefings, Progress-Daten, Activation Metadata, Outcome State und Effect State.
- F10Menu ist sichtbar und navigierbar.
- F10Menu erlaubt direkte Missionsauswahl.
- F10Menu erlaubt direkte Missionsaktivierung.
- F10Menu erlaubt Mission Outcome Controls.
- F10Menu zeigt Capture-/Pressure-Status.
- F10Menu zeigt Capture Ready Zones.
- AICapManager erzeugt CAP-State.
- Es werden keine echten Spawns ausgelöst.

---

## 4. Aktuelle DEV-Mission

Aktuelle technische Entwicklungsmission:

```text
Operation_Levant_Reclamation_DEV.miz
```

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
- automatische Missionserfolgsauswertung
- automatischer Capture-Ownership-Wechsel

Bewertung:

Die DEV-Mission ist ein technischer Testträger.

Sie ist noch keine fertige spielbare Kampagnenmission.

---

## 5. Testumgebung

DCS:

```text
DCS World
```

Map:

```text
Syria
```

Lokales Repository:

```text
C:\Users\Paul\Documents\GitHub\theater-command-dcs\
```

DCS-Logs:

```text
C:\Users\Paul\Saved Games\DCS\Logs\dcs.log
```

Möglicher Open-Beta-/Standalone-Pfad:

```text
C:\Users\Paul\Saved Games\DCS.openbeta\Logs\dcs.log
```

Schneller Zugriff:

```text
%USERPROFILE%\Saved Games
```

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

Ohne frische Logdatei können alte Fehler, alte Versionen oder alte Marker falsch bewertet werden.

Ein weitergeführter Log kann für gezielte Regressionen ausreichen, wenn der neue Testabschnitt zeitlich klar abgegrenzt ist.

Dann muss bei der Auswertung klar benannt werden:

- ab welcher Uhrzeit der neue Abschnitt beginnt
- welche alten Marker ignoriert werden
- welche neuen Marker zum Test gehören

---

## 8. Aktive Ladefolge

Aktuelle getestete Ladefolge im Mission Editor:

1. `vendor/mist/mist.lua`
2. `vendor/moose/Moose.lua`
3. `vendor/ctld/CTLD-i18n.lua`
4. `vendor/ctld/CTLD.lua`
5. `vendor/skynet-iads/SkynetIADS.lua`
6. `src/core/tc_config.lua`
7. `src/core/tc_logger.lua`
8. `src/core/tc_state.lua`
9. `src/core/tc_utils.lua`
10. `src/core/tc_scheduler.lua`
11. `src/world/tc_airbase_scanner.lua`
12. `src/world/tc_zone_factory.lua`
13. `src/campaign/tc_capture_system.lua`
14. `src/campaign/tc_persistence_system.lua`
15. `src/logistics/tc_logistics_delivery.lua`
16. `src/logistics/tc_fob_system.lua`
17. `src/missions/tc_mission_generator.lua`
18. `src/ai/tc_ai_cap_manager.lua`
19. `src/ui/tc_f10_menu.lua`
20. `src/main.lua`
21. `src/loader.lua`

Wichtig:

- `src/ui/tc_f10_menu.lua` wird nach `src/ai/tc_ai_cap_manager.lua` und vor `src/main.lua` geladen.
- `src/main.lua` initialisiert Runtime-Systeme.
- `src/loader.lua` bleibt aktuell die letzte eigene Datei.

---

## 9. Starttest Variante A

Status:

- **bestanden**

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
- Loader sauber beendet
- F10Menu sichtbar ist

---

## 10. Starttest Variante B

Status:

- **offen**

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

```text
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
```

---

## 12. Erwartete Modul-Logmarker

Aktueller getesteter Stand:

```text
[TC] [AirbaseScanner] Loaded src/world/tc_airbase_scanner.lua v0.2.2
[TC] [ZoneFactory] Loaded src/world/tc_zone_factory.lua v0.2.0
[TC] [CaptureSystem] Loaded src/campaign/tc_capture_system.lua v0.2.2
[TC] [LogisticsDelivery] Loaded src/logistics/tc_logistics_delivery.lua v0.2.0
[TC] [FobSystem] Loaded src/logistics/tc_fob_system.lua v0.2.0
[TC] [MissionGenerator] Loaded src/missions/tc_mission_generator.lua v0.2.3
[TC] [AICapManager] Loaded src/ai/tc_ai_cap_manager.lua v0.2.0
[TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.2
```

Diese Marker zeigen, dass die richtigen Versionen in der `.miz` eingebettet und durch DCS geladen wurden.

Wenn eine alte Version erscheint, wurde die geänderte Datei wahrscheinlich nicht im Mission Editor neu ausgewählt oder die Mission nicht gespeichert.

---

## 13. Erwartete Airbase-Scanner-Werte

Aktueller bestandener Stand:

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

Bewertung:

- 225 airbase-like objects sind auf Syria erwartbar.
- Das ist kein Fehler.
- Entscheidend ist die Klassifizierung.
- Akrotiri muss als Blue-Startbasis erkannt werden.

---

## 14. Erwartete ZoneFactory-Werte

Aktueller bestandener Stand:

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

Bewertung:

- ZoneFactory soll nicht 225 ungefilterte Zonen erzeugen.
- 46 relevante Kampagnenzonen sind der aktuell bestandene Zielwert.
- 179 übersprungene Airbase-like Objects sind erwartbar.

---

## 15. Erwartete CaptureSystem-Werte im Startzustand

Aktueller bestandener Startstand:

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

Erwartete Start-Logmarker:

```text
[TC] [CaptureSystem] Capture progress updated: zones=32, ready=0, contested=0, appliedMissionEffects=0
[TC] [CaptureSystem] Capture eligibility summary: bases=32, zones=32, nonCaptureBases=193, nonCaptureZones=14
[TC] [CaptureSystem] Capture pressure summary: pressureRecords=32, progressRecords=32, appliedMissionEffects=0
```

Bewertung:

- CaptureSystem soll nur auf 32 capture-fähigen Zielen arbeiten.
- Capture-Pressure und Capture-Progress müssen 32 Records erzeugen.
- `appliedMissionEffects=0` ist im reinen Startzustand korrekt.

---

## 16. Erwartete CaptureSystem-Werte nach Mission Completion

Aktueller bestandener Completion-Test:

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

Erwartete Logmarker nach Completion:

```text
[TC] [MissionGenerator] Mission outcome prepared: MISSION_2 [COMPLETED] stateOnly=true effects=prepared
[TC] [CaptureSystem] Capture pressure added: zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE amount=105 progress=100%
[TC] [CaptureSystem] Mission effect applied to capture: mission=MISSION_2 zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE pressure=105
[TC] [CaptureSystem] Completed mission effects processed: applied=1, skipped=0, failed=0, appliedMissionEffects=1
[TC] [CaptureSystem] Capture progress updated: zones=32, ready=1, contested=0, appliedMissionEffects=1
```

Bewertung:

- Mission Completion erzeugt Capture Pressure.
- Capture Progress wird aktualisiert.
- Capture Ready kann dynamisch entstehen.
- Mission Effects dürfen nicht doppelt angewendet werden.
- Bei erneutem Statusaufruf ist `skipped=1` für bereits angewendete Effects korrekt.

---

## 17. Erwartete LogisticsDelivery-Werte

Aktueller bestandener Stand:

```text
logistics hubs: 46
blue hubs: 7
red hubs: 24
neutral hubs: 15
active hubs: 31
limited hubs: 15
locked hubs: 0
```

Bewertung:

- LogisticsDelivery soll 46 Logistics Hubs erzeugen.
- CTLD wird noch nicht produktiv aufgerufen.
- Keine echten Cargo-Aktionen sind erwartbar.

---

## 18. Erwartete FobSystem-Werte

Aktueller bestandener Stand:

```text
FOB candidates: 6
stored candidates: 6
auto-planned FOBs: 2
skipped candidates: 4
Blue FOBs: 2
```

Erwartete FOBs:

```text
FOB Ercan
FOB Gecitkale
```

Erwarteter Status:

```text
UNDER_CONSTRUCTION
```

Bewertung:

- FOBs sind state-only.
- Es werden noch keine echten CTLD-FOBs erzeugt.
- `planned=0` in älteren Zusammenfassungen ist kein Fehler, wenn FOBs direkt in `UNDER_CONSTRUCTION` wechseln.

---

## 19. Erwartete MissionGenerator-Werte

Aktueller bestandener Stand:

```text
mission candidates: 78
fobSupportCandidates: 2
generated missions: 10
reservedCreated: 1
duplicatesSkipped: 1
typeLimitSkipped: 68
```

Erwartete Logmarker:

```text
[TC] [MissionGenerator] Mission candidate summary: candidates=78, fobSupportCandidates=2, availableBefore=0, generationSlots=10
[TC] [MissionGenerator] Mission generation completed: 10 new missions from 78 candidates (fobSupportCandidates=2, reservedCreated=1, duplicatesSkipped=1, typeLimitSkipped=68)
```

Bewertung:

- 10 verfügbare Missionen sind aktuell erwartbar.
- Mindestens eine FOB-Support-Mission soll reserviert werden.
- Missionen bleiben state-only.
- Die alte Kandidatenzahl 69 ist veraltet.
- Die aktuelle Kandidatenzahl 78 ist im bestätigten Teststand korrekt.

---

## 20. Erwartete Mission Activation Marker

Aktuell bestätigt:

```text
[TC] [F10Menu] Mission details shown through F10: slot=1 key=MISSION_2
[TC] [F10Menu] Mission activated through F10: slot=1 key=MISSION_2
[TC] [MissionGenerator] Mission status changed: MISSION_2 [ACTIVE]
[TC] [MissionGenerator] Mission activation prepared: MISSION_2 stateOnly=true spawnHooks=reserved
```

Bewertung:

- Mission Activation bedeutet aktuell Statuswechsel im State.
- Es werden keine echten Spawns erwartet.
- `stateOnly=true` und `spawnHooks=reserved` sind korrekt.

---

## 21. Erwartete Mission Outcome Marker

Aktuell bestätigt:

```text
[TC] [F10Menu] Active mission outcome status shown through F10
[TC] [F10Menu] Mission completed through F10: slot=1 key=MISSION_2 stateOnly=true effects=prepared
[TC] [MissionGenerator] Mission effects prepared state-only: MISSION_2 status=COMPLETED
[TC] [MissionGenerator] Mission outcome prepared: MISSION_2 [COMPLETED] stateOnly=true effects=prepared
```

Bewertung:

- `Complete Active Mission 1` ist praktisch bestätigt.
- `Fail Active Mission 1` ist vorhanden, aber noch nicht praktisch bestätigt.
- Completion bleibt state-only.
- Effects bleiben state-only vorbereitet, bis Fachsysteme sie verarbeiten.
- Der erste bestätigte Empfänger ist CaptureSystem.

---

## 22. Erwartete AICapManager-Werte

Aktueller bestandener Stand:

```text
cap zone candidates: 31
auto-registered CAP zones: 12
CAP requests: 12
reactionState: AIR_REACTION_REQUESTED
threatLevel: HIGH
```

Bewertung:

- AI CAP Manager erzeugt CAP-State.
- MOOSE-CAP-Spawns sind noch nicht aktiv.
- `spawn=MOOSE_PENDING` ist erwartbar.

---

## 23. Erwartete F10Menu-Werte

Aktueller bestandener Stand:

```text
F10Menu version: v0.2.2
commands: 32
```

Bestätigte F10-Funktionen:

- F10-Menü sichtbar
- F10-Menü navigierbar
- Show Available Missions
- Show Active Missions
- Show Mission 1 Details
- Activate Mission 1
- Show Active Mission Outcome Status
- Complete Active Mission 1
- Show Campaign Status
- Show Capture Status
- Show Capture Ready Zones
- Show Pressure Contested Zones
- Show Logistics Status
- Show FOB Status
- Show AI CAP Status

Erwartete Logmarker:

```text
[TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.2
[TC] [F10Menu] F10 menu started
[TC] [F10Menu] F10 menu initialized: commands=32
[TC] System started: F10 Menu
[TC] [F10Menu] Mission details shown through F10: slot=1 key=MISSION_2
[TC] [F10Menu] Mission activated through F10: slot=1 key=MISSION_2
[TC] [F10Menu] Active mission outcome status shown through F10
[TC] [F10Menu] Mission completed through F10: slot=1 key=MISSION_2 stateOnly=true effects=prepared
[TC] [F10Menu] Capture status shown through F10
[TC] [F10Menu] Capture ready zones shown through F10
[TC] [F10Menu] Pressure contested zones shown through F10
```

Bewertung:

- F10Menu ist bestanden.
- F10Menu ist die aktuelle Test- und Sichtbarkeitsschicht.
- Der nächste sinnvolle UI-Schritt ist nicht mehr Capture-/Pressure-Anzeige, sondern kontrollierter Capture-Apply.

---

## 24. Fehler, die echte Blocker sind

Als Blocker gelten:

- `stack traceback` in Theater-Command-Dateien
- `attempt to index nil value` in Theater-Command-Dateien
- `attempt to call nil value` in Theater-Command-Dateien
- `[TC][ERROR]` mit Startabbruch
- `[TC] [ERROR]` mit Startabbruch
- fehlender Main-Start
- fehlender Loader-Abschluss
- fehlendes Framework, obwohl es geladen werden soll
- F10Menu startet nicht
- MissionGenerator erzeugt keine Missionen
- CaptureSystem bricht ab
- ZoneFactory erzeugt keine relevanten Zonen
- geänderte Datei zeigt im Log noch alte Version
- Mission Activation erzeugt unerwartete echte Spawns
- Mission Completion wendet Effects mehrfach an
- Capture Ready entsteht nicht, obwohl 100 % Capture Progress erreicht wird

---

## 25. Fehler, die nicht automatisch Blocker sind

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

## 26. Versionstest

Jeder Lua-Test muss prüfen, ob die richtige Dateiversion geladen wurde.

Aktuelle Beispiele:

```text
[TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.2
[TC] [MissionGenerator] Loaded src/missions/tc_mission_generator.lua v0.2.3
[TC] [CaptureSystem] Loaded src/campaign/tc_capture_system.lua v0.2.2
```

Wenn eine alte Version erscheint:

1. lokale GitHub-Kopie prüfen
2. GitHub Desktop Pull prüfen
3. Datei im Mission Editor neu auswählen
4. Mission speichern
5. DCS neu starten
6. frischen Logtest durchführen

---

## 27. F10-Testverfahren

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
- Activate Mission 1
- Show Active Mission Outcome Status
- Complete Active Mission 1
- Show Campaign Status
- Show Capture Status
- Show Capture Ready Zones
- Show Pressure Contested Zones
- Show Logistics Status
- Show FOB Status
- Show AI CAP Status

Noch nicht praktisch bestätigt:

- Fail Active Mission 1

Nächster geplanter F10-Code-Schritt:

- Apply Capture Ready Zone 1

---

## 28. Mission Activation Testverfahren

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

- F10Menu meldet Aktivierung.
- MissionGenerator setzt Mission auf `ACTIVE`.
- MissionGenerator meldet `stateOnly=true`.
- MissionGenerator meldet `spawnHooks=reserved`.
- keine echten Spawns.

Nicht erwartet:

- echte MOOSE-Flüge
- echte CTLD-Aktionen
- echte Skynet-Aktionen
- DCS-Einheitenspawn durch Mission Activation

---

## 29. Mission Completion Testverfahren

Für Mission Completion:

1. Mission starten
2. F10 öffnen
3. Theater Command öffnen
4. Missions öffnen
5. Mission Details prüfen
6. Mission aktivieren
7. Active Mission Outcome Status anzeigen
8. Complete Active Mission 1 auswählen
9. Capture Status anzeigen
10. Capture Ready Zones anzeigen
11. Log prüfen

Erwartet:

- F10Menu meldet Completion.
- MissionGenerator setzt Mission auf `COMPLETED`.
- MissionGenerator bereitet Mission Effects vor.
- CaptureSystem verarbeitet abgeschlossene Mission Effects.
- CaptureSystem erhöht Capture Pressure.
- CaptureSystem aktualisiert Capture Progress.
- Capture Ready entsteht.
- Capture Ready Zones sind über F10 sichtbar.
- keine echten Spawns.
- keine CTLD-Aktionen.
- keine Skynet-Aktionen.

Bestandener Testfall:

```text
MISSION_2 -> ZONE_AIRBASE_ABU_AL_DUHUR -> BLUE pressure 105 -> progress 100% -> ready=1
```

---

## 30. Capture Testverfahren

Aktueller Stand:

- CaptureSystem erzeugt Capture-Eligibility, Pressure und Progress.
- Capture Effects werden state-only praktisch getestet.
- Mission Completion kann Capture Pressure erzeugen.
- Capture Ready kann entstehen.
- Capture Ready Zones sind über F10 sichtbar.

Im Startzustand zu prüfen:

- CaptureSystem lädt
- eligibleBases = 32
- eligibleZones = 32
- pressureRecords = 32
- progressRecords = 32
- appliedMissionEffects = 0
- ready = 0
- contested = 0

Nach Mission Completion zu prüfen:

- Mission Effects werden verarbeitet
- appliedMissionEffects = 1
- ready = 1
- target zone ist sichtbar
- Capture Ready Zones F10-Command wurde ausgelöst
- kein doppeltes Anwenden bei erneutem Statusaufruf

Nächster Capture-Test:

- kontrollierter state-only Ownership-Wechsel aus Capture Ready Zone 1

---

## 31. Capture Ready Apply Testverfahren

Status:

- **geplant**
- noch nicht implementiert

Geplanter F10-Befehl:

```text
Apply Capture Ready Zone 1
```

Empfohlene Testsequenz nach Umsetzung:

1. frische `dcs.log` erzeugen
2. Mission starten
3. F10 öffnen
4. Show Mission 1 Details
5. Activate Mission 1
6. Complete Active Mission 1
7. Show Capture Status
8. Show Capture Ready Zones
9. Apply Capture Ready Zone 1
10. Show Capture Status erneut
11. Log prüfen

Erwartet nach Umsetzung:

- F10Menu lädt als neue Version.
- bisherige 32 Commands bleiben funktionsfähig.
- neuer Apply-Command wird erzeugt.
- Capture Ready Zone 1 wird erkannt.
- Zone Ownership wird state-only geändert.
- linked Airbase Ownership wird kontrolliert synchronisiert.
- Capture Pressure wird zurückgesetzt oder sauber markiert.
- Logmarker zeigen den Ownership-Wechsel eindeutig.
- keine echten Spawns.
- keine CTLD-Aktion.
- keine Skynet-Aktion.
- keine Lua-Fehler.

---

## 32. Logistics Testverfahren

Aktuell zu prüfen:

- LogisticsDelivery lädt
- LogisticsDelivery startet
- 46 Logistics Hubs werden erzeugt
- Hub-Verteilung stimmt
- FobSystem lädt
- FobSystem startet
- 6 FOB-Kandidaten werden erkannt
- 2 Blue-FOBs werden erzeugt
- FOBs stehen auf `UNDER_CONSTRUCTION`
- MissionGenerator erkennt FOB-Support-Kandidaten

Nicht erwartet:

- echte CTLD-Cargo-Aktionen
- echte CTLD-FOBs
- Cargo-Verbrauch
- echte Pickup-/Dropoff-Zonen

---

## 33. AI Testverfahren

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

## 34. Persistence Testverfahren

Aktueller Stand:

- PersistenceSystem lädt/startet als Grundstruktur.
- produktiver Dateischreibtest offen.

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

Empfohlen:

- Persistence erst nach kontrolliertem Capture-Ownership-Test praktisch weiterführen.

---

## 35. IADS Testverfahren

Aktueller Stand:

- Skynet IADS wird als Vendor geladen.
- Theater-Command-IADS-Modul ist noch nicht aktiv.

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

## 36. Testcheckliste nach jeder Lua-Änderung

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

## 37. Testcheckliste für neue Module

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

## 38. Aktuelle nächste Testaufgabe

Nächste empfohlene Code-Datei:

```text
src/ui/tc_f10_menu.lua
```

Ziel:

```text
kontrollierter state-only Ownership-Wechsel aus Capture Ready Zone 1
```

Geplanter neuer Command:

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

Erwartete neue Logmarker nach Umsetzung:

```text
[TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.3
[TC] [F10Menu] F10 menu initialized:
[TC] [F10Menu] Capture ready zones shown through F10
[TC] [F10Menu] Capture ready zone applied through F10:
[TC] [CaptureSystem] Zone captured:
```

---

## 39. Wann ein Test als bestanden gilt

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
- state-only-Grenzen eingehalten werden
- keine unerwarteten Framework-Aktionen ausgelöst werden

---

## 40. Wann ein Test nicht bestanden ist

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
- Mission Effects doppelt angewendet werden
- echte Spawns unerwartet ausgelöst werden
- CTLD unerwartet produktiv ausgelöst wird
- Skynet unerwartet produktiv ausgelöst wird

---

## 41. Aktueller Abschlussstatus

Die aktuelle Testbasis ist ausreichend stabil für den nächsten kontrollierten UI-/Capture-Schritt.

Bestätigt ist:

```text
F10 Mission Selection
Mission Activation
Mission Completion
Mission Effect Preparation
CaptureSystem Effect Processing
Capture Pressure Update
Capture Progress Update
Capture Ready Detection
F10 Capture Ready Visibility
```

Nächster sinnvoller Test nach Code-Erweiterung:

```text
Capture Ready Zone 1 bewusst über F10 anwenden
```

Danach sinnvoll:

- Failure-Pfad praktisch testen
- Persistence-Sandbox-Test vorbereiten
- Debug-/State-Dump verbessern
- CTLD- und MOOSE-Integration später vorbereiten
