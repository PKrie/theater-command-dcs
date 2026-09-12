# Mission Editor Setup

Diese Datei beschreibt, was im DCS Mission Editor für **Theater Command DCS** vorbereitet werden muss.

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

## Verbindlicher Mission-Editor-Stand — 2026-09-12

DEV-Mission:

```text
C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_DEV.miz
```

Für das Offline Embedded Mission Resource Audit wurde zusätzlich eine MCP_TEST-Kopie der DEV-Mission herangezogen; ein eigener fester Dateiname/Pfad für diese Kopie ist im Projektstand nicht dokumentiert.

Persistence-Trigger (aktiv):

- Name: `TC_LOAD_TC_PERSISTENCE_SYSTEM`
- Typ: `once`
- Bedingung: `time-after 15 seconds`
- Resource Key: `ResKey_advancedFile_56`
- Embedded Filename: `tc_persistence_system_v0_2_6.lua`
- Der aktive Embedded-Inhalt war beim Audit vom 2026-09-12 byte-identisch mit `src/campaign/tc_persistence_system.lua`.

Altressource `ResKey_Action_55` / `tc_persistence_system.lua` (präzisiert):

- Der alte TRIGGER-VERWEIS auf diese Ressource wurde entfernt.
- Die alte Ressource selbst liegt weiterhin verwaist in der `.miz`.
- Sie wird von keinem Trigger referenziert.
- Sie wird nicht geladen.
- Sie ist nicht byte-identisch zur aktuellen Persistence-Quelle.
- Sie war nicht Ursache der früheren Symptome.
- Sie ist eine separate, spätere Cleanup-Aufgabe.
- Die Aussage "`ResKey_Action_55` ist vollständig aus der `.miz` entfernt" ist nach aktuellem Audit falsch und wird hier nicht mehr verwendet.

Offline READ-ONLY Embedded Mission Resource Audit vom 2026-09-12:

- DEV und MCP_TEST waren beim Audit byte-identisch.
- 13/13 für den damaligen Blocker relevante aktive Theater-Command-Ressourcen waren `EXACT_MATCH` zum Repository.
- 0 aktive Byte-Mismatches.
- 0 fehlende bzw. Mapping-fehlerhafte aktive Ressourcen.
- keine aktive Embedded-Runtime-Drift.
- Damit ist der frühere Verdacht widerlegt, Embedded Source Drift könnte den (ebenfalls widerlegten) Mission-Record-Verlust verursacht haben.

Mission-Record-Diagnose (kompakt; vollständige Herleitung siehe `TASKS.md`):

- Mission Records gingen zu keinem Zeitpunkt verloren.
- Mission-State-Collections sind String-keyed Dictionaries; `#` ist kein gültiger autoritativer Count.
- Live bestätigt: `statistics.available=10`, `pairs()`-Count `available=10`, `#available=0`.
- Der Source-Bug lag in `src/core/tc_state.lua` -> `State.summary()`; Fix mit pairs-basierter `countEntries()`-Funktion, live bestanden.

DCS-SMS stellt Entwicklungs-/Mission-Editor-/Diagnosewerkzeug bereit, kein Theater-Command-Runtime-Framework. Aktueller Stand:

- DCS-SMS `v0.27.2`, Hook `me-bridge-0.27.2`.
- Nach einem DCS-Update wurde der MissionScripting-Hook erneut installiert/repariert.
- Auto-Routing per `dcs-sms exec --code "..."` erreicht das Mission Environment; `TC` ist darüber als Table erreichbar.

Der Spieler-Slot `CLIENT_BLUE_FA18C_AKROTIRI_01` ist `CLIENT`, nicht `PLAYER`. Normaler Teststart:

1. Mission aus dem Mission Editor starten.
2. `CLIENT_BLUE_FA18C_AKROTIRI_01` in der Client-Slotauswahl wählen.
3. Slot bestätigen.
4. Im Simulator-Briefing `Fly` drücken.

PersistenceSystem `v0.2.6` startet auf diesem Weg normal. Am 2026-09-12 erneut bestätigt:

- Mission Completion erneut bestanden.
- Mission Failure erneut bestanden.
- Capture Ready Apply erneut bestanden.
- Background Persistence `SAVED` für diese echten State-Änderungen bestätigt.
- `productiveRestore=false`.

Priority 3 (allgemeine Dirty-Coverage der restlichen aktiven State-Systeme) bleibt trotzdem offen.

Die aktive DCS-SMS-Bridge benötigt `os=true`, `io=true`, `lfs=true`; `require=false` bleibt bestehen. DCS-Updates können `MissionScripting.lua` sowie Bridge-/Sandbox-Änderungen überschreiben.

---

## 1. Grundsatz

Der DCS Mission Editor ist in **Theater Command DCS** nicht das eigentliche Kampagnensystem.

Der Mission Editor stellt die physische Bühne bereit.

Die dynamische Kampagne wird durch Lua gesteuert.

Grundprinzip:

- **Mission Editor = Bühne**
- **Lua = Kampagnensystem**
- **GitHub = Projektgedächtnis**

Der Mission Editor soll möglichst schlank bleiben.

Alles, was sinnvoll durch Lua erkannt, berechnet oder gesteuert werden kann, soll nicht als große Triggerkette im Mission Editor gebaut werden.

---

## 2. Aktueller Projektstand

Historischer Baseline-Stand: **2026-07-06**. Der verbindliche aktuelle Stand steht oben.

Aktueller technischer Status:

- sichere Einzeldatei-Ladung über `DO SCRIPT FILE` ist aktiv
- Vendor-Frameworks laden
- eigene Theater-Command-Dateien laden
- Main startet die Runtime-Systeme
- Loader prüft die Umgebung und beendet sauber
- F10-Menü ist sichtbar und navigierbar
- Missionen können über F10 angezeigt und aktiviert werden
- Mission 1 bis Mission 10 sind vorhanden und auswählbar
- Mission Activation funktioniert
- aktive Mission kann über F10 state-only auf `COMPLETED` gesetzt werden
- aktive Mission kann über F10 state-only auf `FAILED` gesetzt werden
- Mission Effects werden state-only vorbereitet
- CaptureSystem übernimmt abgeschlossene Mission Effects state-only in Capture Pressure (Mission Completion -> Capture Pressure funktioniert)
- Capture Ready entsteht dynamisch
- Capture Ready Zones sind über F10 sichtbar
- Capture Ready Apply funktioniert
- Zone Ownership und linked Airbase Ownership wurden state-only aktualisiert
- Background Autosave reagiert auf echte Dirty-State-Änderungen
- Capture Read-/Getter-Pfade erzeugen nach Fix kein falsches Dirty mehr
- Ownership-No-Op verändert keinen persistierten State

Weiterhin nicht behauptet:

- automatische echte Capture-Auswertung
- produktiver Restore
- echte Framework-Spawns

Aktuelle getestete Systeme:

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | bestanden; Read-Dirty- und Ownership-No-Op-Regressions bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | Embedded-Start, `SAVED`, `SKIPPED`, `FAILED` und Retry bestanden; `productiveRestore=false` |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | funktional bestanden; Dirty-Coverage als nächster Priority-3-Audit ausstehend |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | funktional bestanden; Dirty-Coverage noch ausstehend |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | state-only Activation, Completion, Failure und Effects bestanden; Record-Loss-Verdacht widerlegt; allgemeine Dirty-Coverage noch ausstehend |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | state-first bestanden; `reactToActiveMissions`-Sonderfall bewertet; allgemeine Dirty-Coverage noch ausstehend |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden, 33 Commands |

Aktueller wichtiger Befund:

- DCS Syria liefert **225 airbase-like objects**
- Airbase Scanner klassifiziert diese Objekte
- ZoneFactory erzeugt **46 relevante Kampagnenzonen**
- ZoneFactory überspringt **179 nicht geeignete airbase-like objects**
- CaptureSystem arbeitet auf **32 capture-fähigen Zielen**
- MissionGenerator erzeugt **78 Missionskandidaten**
- MissionGenerator erzeugt **10 Mission Records**; die Collections sind String-keyed Dictionaries
- `pairs()`-Count bestätigt 10 verfügbare Missionen; `#` liefert dort `0` und ist nicht autoritativ
- der frühere Record-Loss-Verdacht ist widerlegt
- F10Menu erzeugt **33 Commands**

Bewertung:

- Die technische Startkette funktioniert.
- Die hohe Zahl von 225 Syria-Airbase-like-Objects ist kein Fehler.
- Die aktuelle Filterung ist fachlich deutlich besser als der erste Starttest.
- Die Mission ist weiterhin ein technischer Testträger und noch keine fertige Kampagnenmission.

---

## 3. Aktuelle DEV-Mission

Aktueller Dateiname:

- `Operation_Levant_Reclamation_DEV.miz`

Aktueller Inhalt:

- Map: Syria
- Koalitionspreset: Modern
- Blue Start: Akrotiri / Zypern
- erster blauer Client-Slot: F/A-18C Lot 20 auf Akrotiri
- sichere Einzeldatei-Ladung über `DO SCRIPT FILE`
- Vendor-Frameworks werden geladen
- Theater-Command-Source-Dateien werden geladen
- F10-Menü ist sichtbar und testbar

Noch nicht produktiv enthalten:

- rote Frontlinie
- produktive IADS-Stellungen
- produktive CTLD-Zonen
- produktive Template-Gruppen
- echte MOOSE-Spawns
- echte CTLD-FOBs
- echte CTLD-Cargo-Flüge
- produktiver automatischer Startup-Restore
- automatische Kampagnenfortsetzung aus Save beim Missionsstart
- automatische Missionserfolgsauswertung
- automatische Capture-Auswertung mit Besitzwechsel

Background Autosave selbst ist bereits aktiv und getestet (siehe Verbindlicher Mission-Editor-Stand oben); nur der produktive Startup-Restore bleibt deaktiviert.

Diese Mission ist aktuell ein technischer Testträger.

Sie ist noch keine fertige spielbare Kampagnenmission.

---

## 4. Koalitionen

Für die DEV-Mission wurde das DCS-Koalitionspreset verwendet:

- **Modern**

Diese Entscheidung ist für den aktuellen Entwicklungsstand passend.

Grund:

- moderne Koalitionslogik
- USA als Blue verfügbar
- Syrien als Red verfügbar
- passend für einen modernen Syria-Kontext
- keine unnötige Sonderkonfiguration zu Beginn

Aktuelle fachliche Vorgabe:

- Blue startet auf Akrotiri / Zypern
- Red kontrolliert zu Beginn das syrische Festland

Die Koalitionsauswahl kann später bei Bedarf angepasst werden.

Für den aktuellen technischen Test ist sie ausreichend.

---

## 5. Spieler-Slot

Aktueller erster Client-Slot:

- Flugzeug: F/A-18C Lot 20
- Koalition: Blue
- Land: USA
- Startort: Akrotiri
- Starttyp: Start vom Parkplatz
- Skill: Client
- Gruppen-/Slotname: `CLIENT_BLUE_FA18C_AKROTIRI_01`

Dieser Slot dient aktuell dazu, die Mission starten und in der Simulation laufen lassen zu können.

Da der Slot `CLIENT` ist, erscheint vor dem Briefing die Client-Slotauswahl. Automatisierte und manuelle Tests müssen diesen zusätzlichen Schritt berücksichtigen.

Er ist noch kein finaler Kampagnenslot.

Später geplante Client-Slots:

- F/A-18C
- F-14B
- F-15E
- A-10C
- AH-64D
- weitere Module nach Bedarf

---

## 6. Externe Framework-Ladung

Die externen Frameworks liegen unter:

- `vendor/`

Frameworks werden nicht verändert.

Aktive Vendor-Dateien:

| Framework | Pfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD-i18n | `vendor/ctld/CTLD-i18n.lua` | geladen |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Vendor-Ladefolge:

1. `vendor/mist/mist.lua`
2. `vendor/moose/Moose.lua`
3. `vendor/ctld/CTLD-i18n.lua`
4. `vendor/ctld/CTLD.lua`
5. `vendor/skynet-iads/SkynetIADS.lua`

Wichtig:

- MIST muss vor CTLD geladen werden.
- CTLD-i18n muss vor CTLD.lua geladen werden.
- Skynet IADS wird nach MIST geladen.
- Eigene Theater-Command-Logik startet erst nach den externen Frameworks.
- Vendor-Dateien werden nicht verändert.

---

## 7. Aktive eigene Source-Dateien

Eigene Lua-Dateien liegen unter:

- `src/`

Aktuell aktive eigene Lua-Dateien:

```text
src/core/tc_config.lua
src/core/tc_logger.lua
src/core/tc_state.lua
src/core/tc_utils.lua
src/core/tc_scheduler.lua
src/world/tc_airbase_scanner.lua
src/world/tc_zone_factory.lua
src/campaign/tc_capture_system.lua
src/campaign/tc_persistence_system.lua
src/logistics/tc_logistics_delivery.lua
src/logistics/tc_fob_system.lua
src/missions/tc_mission_generator.lua
src/ai/tc_ai_cap_manager.lua
src/ui/tc_f10_menu.lua
src/main.lua
src/loader.lua
```

Vorbereitet, aber noch nicht produktiv implementiert:

```text
src/iads/
src/debug/
```

---

## 8. Starttest-Variante A

Status:

- **bestanden**

Ziel:

- sichere Einzeldatei-Ladung im DCS Mission Editor

Diese Variante lädt alle aktiven Dateien einzeln per `DO SCRIPT FILE`.

Grund:

- keine harte Abhängigkeit von `dofile`
- klare Fehlereingrenzung
- jede Datei wird im DCS-Kontext getestet
- Fehler lassen sich über `dcs.log` klar zuordnen
- besonders geeignet für die frühe Entwicklungsphase

Aktuelle Entscheidung:

- Variante A bleibt Standard, bis Loader-only praktisch getestet ist.

---

## 9. Aktive Trigger-Reihenfolge für Starttest-Variante A

Im DCS Mission Editor werden folgende Trigger angelegt.

Jeder Trigger ist:

- Typ: `EINMALIG / ONCE`
- Ereignis: `KEIN EVENT / NO EVENT`
- Bedingung: `MEHR ZEIT / TIME MORE`
- Aktion: `SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE`

Aktive Reihenfolge:

```text
TIME MORE 1
DO SCRIPT FILE: vendor/mist/mist.lua

TIME MORE 2
DO SCRIPT FILE: vendor/moose/Moose.lua

TIME MORE 3
DO SCRIPT FILE: vendor/ctld/CTLD-i18n.lua

TIME MORE 4
DO SCRIPT FILE: vendor/ctld/CTLD.lua

TIME MORE 5
DO SCRIPT FILE: vendor/skynet-iads/SkynetIADS.lua

TIME MORE 7
DO SCRIPT FILE: src/core/tc_config.lua

TIME MORE 8
DO SCRIPT FILE: src/core/tc_logger.lua

TIME MORE 9
DO SCRIPT FILE: src/core/tc_state.lua

TIME MORE 10
DO SCRIPT FILE: src/core/tc_utils.lua

TIME MORE 11
DO SCRIPT FILE: src/core/tc_scheduler.lua

TIME MORE 12
DO SCRIPT FILE: src/world/tc_airbase_scanner.lua

TIME MORE 13
DO SCRIPT FILE: src/world/tc_zone_factory.lua

TIME MORE 14
DO SCRIPT FILE: src/campaign/tc_capture_system.lua

TIME MORE 15
DO SCRIPT FILE: src/campaign/tc_persistence_system.lua

TIME MORE 16
DO SCRIPT FILE: src/logistics/tc_logistics_delivery.lua

TIME MORE 17
DO SCRIPT FILE: src/logistics/tc_fob_system.lua

TIME MORE 18
DO SCRIPT FILE: src/missions/tc_mission_generator.lua

TIME MORE 19
DO SCRIPT FILE: src/ai/tc_ai_cap_manager.lua

TIME MORE 20
DO SCRIPT FILE: src/ui/tc_f10_menu.lua

TIME MORE 21
DO SCRIPT FILE: src/main.lua

TIME MORE 22
DO SCRIPT FILE: src/loader.lua
```

Wichtig:

- `src/ui/tc_f10_menu.lua` ist aktiv und muss vor Main geladen werden.
- `src/main.lua` wird vor `src/loader.lua` geladen.
- `src/loader.lua` wird als letzte eigene Datei geladen.
- `src/main.lua` stellt die Main-Tabelle und Runtime-Systemlogik bereit.
- `src/loader.lua` prüft anschließend Frameworks, Module und startet beziehungsweise validiert die Main-Initialisierung.

---

## 10. Lokaler Dateipfad

Die lokale Repository-Kopie auf dem DCS-PC liegt aktuell unter:

```text
C:\Users\Paul\Documents\GitHub\theater-command-dcs\
```

Beispielhafte Source-Pfade:

```text
C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\core\tc_config.lua
C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\core\tc_logger.lua
C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\core\tc_state.lua
C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\core\tc_utils.lua
C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\core\tc_scheduler.lua
C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\world\tc_airbase_scanner.lua
C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\world\tc_zone_factory.lua
C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\campaign\tc_capture_system.lua
C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\campaign\tc_persistence_system.lua
C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\logistics\tc_logistics_delivery.lua
C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\logistics\tc_fob_system.lua
C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\missions\tc_mission_generator.lua
C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\ai\tc_ai_cap_manager.lua
C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\ui\tc_f10_menu.lua
C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\main.lua
C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\loader.lua
```

---

## 11. DCS-Einbettungsverhalten

Wichtig:

Eine per `DO SCRIPT FILE` geladene Lua-Datei wird in die `.miz` eingebettet.

Das bedeutet:

- GitHub-Änderung allein reicht nicht.
- GitHub Desktop Pull allein reicht nicht.
- Die geänderte Datei muss im Mission Editor in der passenden Trigger-Aktion neu ausgewählt werden.
- Danach muss die Mission gespeichert werden.
- Erst danach ist die neue Lua-Version in der `.miz` enthalten.

Arbeitsablauf nach jeder Lua-Änderung:

1. Datei auf GitHub aktualisieren
2. Commit erstellen
3. GitHub Desktop öffnen
4. fetch/pull ausführen
5. DCS Mission Editor öffnen
6. betroffene `DO SCRIPT FILE`-Aktion öffnen
7. geänderte Lua-Datei neu auswählen
8. Mission speichern
9. alte `dcs.log` löschen oder umbenennen
10. DCS starten
11. Mission testen
12. DCS beenden
13. frische `dcs.log` auswerten

Der Embedded Audit vom 2026-09-12 hat bestätigt, dass die relevanten aktiv geladenen Ressourcen byte-identisch zu den Repository-Dateien sein können und dass diese Prüfung ein geeignetes Mittel gegen Runtime-Drift ist.

---

## 12. Aktueller erfolgreicher Teststand

Bestätigte Logik:

- MIST erkannt
- MOOSE erkannt
- CTLD erkannt
- Skynet IADS erkannt
- Core geladen
- World geladen
- Campaign geladen
- Logistics geladen
- Missions geladen
- AI geladen
- UI geladen
- Main gestartet
- Loader beendet

Bestätigte Runtime-Systeme:

- Airbase Scanner
- ZoneFactory
- CaptureSystem
- PersistenceSystem
- LogisticsDelivery
- FobSystem
- MissionGenerator
- AICapManager
- F10Menu

Wichtige positive Log-Einträge:

```text
[TC] Runtime systems initialized
[TC] Main initialized
[TC] Main started
[TC] Theater Command loader finished
```

Bestätigte modulübergreifende Pipeline:

```text
Mission Details
Mission Activation
Mission Completion
Mission Effects
Capture Pressure
Capture Progress
Capture Ready
Capture Ready Apply
Zone Ownership Update
Linked Airbase Ownership Sync
Background Autosave
```

Zusätzlich separat bestätigt, Mission Failure:

```text
Mission Failure -> Failure Effects prepared -> CaptureSystem verarbeitet -> kein Capture Pressure
```

Am 2026-09-12 erneut live bestätigt:

- Mission Completion
- Mission Failure
- Capture Ready Apply

Persistence dabei: `SAVED`, spezifische `dirtyReason`, `dirtyCleared=true`. Keine echten MOOSE-/CTLD-/Skynet-Aktionen.

Final bestätigter CaptureSystem-Embed nach dem letzten Fix (Capture Dirty Tracking Fix und Ownership No-Op Fix):

- MIZ Entry: `l10n/DEFAULT/tc_capture_system.lua`
- Bytes: `91160`
- SHA-256: `06326C028388C6737BDB01C8C29C8F029375D612D72ADC1A02F49BFD9DAE9DCE`
- Repository-SHA-256 identisch, `MATCH=True`

Dieser Embedded-Stand deckt die Capture-Dirty-Tracking- und Ownership-No-Op-Korrekturen ab. Damit ist Priority 3 insgesamt nicht abgeschlossen — die übrigen State-Systeme sind separat zu prüfen.

Bestätigter Capture-Test:

```text
[TC] [MissionGenerator] Mission outcome prepared: MISSION_2 [COMPLETED] stateOnly=true effects=prepared
[TC] [CaptureSystem] Capture pressure added: zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE amount=105 progress=100%
[TC] [CaptureSystem] Mission effect applied to capture: mission=MISSION_2 zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE pressure=105
[TC] [CaptureSystem] Completed mission effects processed: applied=1, skipped=0, failed=0, appliedMissionEffects=1
[TC] [CaptureSystem] Capture progress updated: zones=32, ready=1, contested=0, appliedMissionEffects=1
[TC] [F10Menu] Capture ready zones shown through F10
```

Bewertung:

- Theater Command startet technisch korrekt.
- Die State-first Runtime funktioniert.
- Die erste modulübergreifende Kampagnenkette ist bestätigt.
- Es gab keine Theater-Command-Lua-Fehler.
- Es gab keine `SCRIPTING ERROR`.
- Es gab keine `Mission script error`.
- Es gab keinen `stack traceback`.
- Es gab kein `attempt to`.

Priority 3 / Dirty-Coverage (Status, ausführlicher Audit siehe `TASKS.md`):

Bereits geklärt:

- Capture Getter/Derived Dirty
- Capture Ownership No-Op
- `reactToActiveMissions()` Sonderfall

Noch offen:

- `src/logistics/tc_logistics_delivery.lua`
- `src/logistics/tc_fob_system.lua`
- `src/missions/tc_mission_generator.lua`
- `src/ai/tc_ai_cap_manager.lua`

Nächster technischer Schritt nach Dokumentationsabschluss: READ-ONLY Dirty-Coverage-Audit von `src/logistics/tc_logistics_delivery.lua`. Dafür ist zunächst keine Mission-Editor-Änderung erforderlich.

---

## 13. Bekannte DCS-/Syria-Logmeldungen

Im DCS-Log können zusätzliche Meldungen auftauchen, die nicht durch Theater Command verursacht werden.

Beispiele:

- `INVALID ATC`
- `missing object declaration`
- `texture not found`
- `DTC_MANAGER`
- `Window pointer is null`
- Terrain-/Asset-/Render-/Payload-Meldungen

Bewertung:

- Diese Meldungen stammen aus DCS, der Syria Map, Assets oder DCS-internen Systemen.
- Sie sind für den Theater-Command-Test aktuell kein Blocker.
- Entscheidend sind Theater-Command-Fehler, Lua-Abbrüche oder Stack Tracebacks mit TC-Bezug.

Wichtige Suchbegriffe für echte Theater-Command-Probleme:

```text
[TC]
[TC][ERROR]
SCRIPTING ERROR
Mission script error
stack traceback
attempt to
nil value
cannot open
```

---

## 14. `dcs.log` prüfen

Die Log-Datei liegt normalerweise hier:

```text
C:\Users\Paul\Saved Games\DCS\Logs\dcs.log
```

Oder bei älterer Open-Beta-/Standalone-Struktur:

```text
C:\Users\Paul\Saved Games\DCS.openbeta\Logs\dcs.log
```

Schneller Explorer-Pfad:

```text
%USERPROFILE%\Saved Games
```

Danach prüfen:

```text
DCS\Logs\dcs.log
```

oder:

```text
DCS.openbeta\Logs\dcs.log
```

Empfohlene Testlogik:

- alte `dcs.log` vor einem Test löschen oder umbenennen
- DCS neu starten
- Mission testen
- DCS beenden
- frische `dcs.log` hochladen oder auswerten

Ein weitergeführter Log kann für gezielte Regressionen ausreichen.

Dann muss aber klar sein, ab welchem Zeitpunkt der neue Testabschnitt beginnt.

---

## 15. Starttest-Variante B

Status:

- **noch nicht durchgeführt**

Ziel:

- Loader-only-Test mit `dofile`

Idee:

Im Mission Editor werden nur die Frameworks und danach `src/loader.lua` geladen.

Der Loader soll dann prüfen, ob er die restlichen eigenen Source-Dateien über `dofile` nachladen kann.

Geplante Reihenfolge für Variante B:

```text
TIME MORE 1
DO SCRIPT FILE: vendor/mist/mist.lua

TIME MORE 2
DO SCRIPT FILE: vendor/moose/Moose.lua

TIME MORE 3
DO SCRIPT FILE: vendor/ctld/CTLD-i18n.lua

TIME MORE 4
DO SCRIPT FILE: vendor/ctld/CTLD.lua

TIME MORE 5
DO SCRIPT FILE: vendor/skynet-iads/SkynetIADS.lua

TIME MORE 7
DO SCRIPT FILE: src/loader.lua
```

Prüffokus:

- Funktioniert `dofile` im DCS Mission Scripting Environment?
- Kennt `loader.lua` seinen Script-Root?
- Können lokale Dateien aus dem Repository-Pfad nachgeladen werden?
- Blockiert die DCS-Sandbox den Zugriff?
- Muss weiter mit Einzeldatei-Ladung gearbeitet werden?
- Brauchen wir später eine Build-Datei für den Mission Editor?

Aktuelle Entscheidung:

- Variante B wird nicht vorgezogen.
- Die sichere Einzeldatei-Ladung bleibt Standard, bis die State-first Systeme weiter stabil sind.

---

## 16. Mission-Editor-Elemente, die aktuell noch fehlen

Noch nicht produktiv angelegt:

- rote Frontlinie
- rote IADS-Stellungen
- rote SAM-Sites
- rote EWR-/Radarstellungen
- CTLD-Pickup-Zonen
- CTLD-Dropoff-Zonen
- FOB-Bauzonen
- Template-Gruppen
- Late-Activation-Gruppen
- echte MOOSE-CAP-Templates
- echte Strike-/SEAD-/DEAD-Templates
- echte CTLD-Cargo-Templates
- statische Zielobjekte
- Logistikobjekte

Bereits vorhanden:

- DEV-Mission als Testträger
- Blue F/A-18C Client-Slot
- Vendor-Ladetrigger
- Source-Ladetrigger
- F10-Menü durch Lua

Diese Elemente werden bewusst noch nicht alle gebaut.

Grund:

- Der State bleibt zuerst stabil/testbar.
- Priority 3 Dirty-Coverage wird abgeschlossen.
- Produktiver Restore folgt später separat.
- Danach folgt echte Framework-Ausführung schrittweise.

---

## 17. Mission-Editor-Namensregeln

Für Trigger:

```text
TC_LOAD_
```

Beispiele:

```text
TC_LOAD_MIST
TC_LOAD_MOOSE
TC_LOAD_CTLD_I18N
TC_LOAD_CTLD
TC_LOAD_SKYNET_IADS
TC_LOAD_TC_CONFIG
TC_LOAD_TC_LOGGER
TC_LOAD_TC_STATE
TC_LOAD_TC_UTILS
TC_LOAD_TC_SCHEDULER
TC_LOAD_TC_AIRBASE_SCANNER
TC_LOAD_TC_ZONE_FACTORY
TC_LOAD_TC_CAPTURE_SYSTEM
TC_LOAD_TC_PERSISTENCE_SYSTEM
TC_LOAD_TC_LOGISTICS_DELIVERY
TC_LOAD_TC_FOB_SYSTEM
TC_LOAD_TC_MISSION_GENERATOR
TC_LOAD_TC_AI_CAP_MANAGER
TC_LOAD_TC_F10_MENU
TC_LOAD_TC_MAIN
TC_LOAD_TC_LOADER
```

Für Zonen später:

```text
TC_ZONE_<TYPE>_<LOCATION>_<NUMBER>
```

Beispiele:

```text
TC_ZONE_PICKUP_AKROTIRI_01
TC_ZONE_DROPOFF_AKROTIRI_01
TC_ZONE_FOB_SITE_01
```

Für Template-Gruppen später:

```text
TC_TEMPLATE_<SIDE>_<ROLE>_<TYPE>_<NUMBER>
```

Beispiele:

```text
TC_TEMPLATE_RED_CAP_MIG29_01
TC_TEMPLATE_BLUE_LOGISTICS_UH60_01
TC_TEMPLATE_RED_SAM_SA6_01
```

---

## 18. Was im Mission Editor vermieden wird

Nicht gewünscht:

- große Kampagnenlogik über Triggerketten
- Capture-Logik rein im Mission Editor
- Missionsgenerator rein im Mission Editor
- Logistiklogik rein im Mission Editor
- KI-Reaktionslogik rein im Mission Editor
- Persistenzlogik rein im Mission Editor
- unstrukturierte Triggernamen
- Dateien aus zufälligen lokalen Ordnern
- direkte Änderungen an Framework-Dateien
- echte Spawns ohne Templates
- CTLD-Integration ohne definierte Zonen
- automatische Ownership-Wechsel ohne kontrollierten Testpfad

Der Mission Editor bleibt Bühne.

Die Kampagnenlogik bleibt Lua.

---

## 19. Aktueller nächster Mission-Editor-Schritt

Aktuell ist KEINE neue Mission-Editor-Bauaufgabe als nächster Schritt freigegeben.

Grund: Der nächste technische Schritt liegt im Lua-/State-Audit — READ-ONLY Dirty-Coverage-Audit von `src/logistics/tc_logistics_delivery.lua`. Dafür ist zunächst:

- keine neue Zone
- kein neues Template
- kein Triggerumbau
- kein Re-Embed
- keine `.miz`-Änderung

notwendig. Der Embedded Resource Audit ist bereits bestanden (siehe Verbindlicher Mission-Editor-Stand oben).

Größere Mission-Editor-Arbeiten bleiben später:

- CTLD-Zonen
- MOOSE-Templates
- IADS-Objekte
- echte Target-Templates
- komplexere Client-Slot-Struktur

---

## 20. Aktueller Status

Bestätigt:

- DEV-Mission als technischer Testträger funktionsfähig
- Starttest-Variante A bestanden
- F10Menu aktiv und bestätigt
- Mission Activation bestanden
- Mission Completion bestanden
- Mission Failure bestanden
- Capture Effect Processing bestanden
- Capture Ready Visibility bestanden
- Capture Ready Apply bestanden
- Zone Ownership Update bestanden
- Linked Airbase Ownership Sync bestanden
- dirty-aware Background Autosave bestanden
- Embedded Resource Audit bestanden
- CaptureSystem final re-embedded und byte-identisch zum Repository

Nächster technischer Schritt:

Priority 3 fortsetzen mit READ-ONLY Dirty-Coverage-Audit von `src/logistics/tc_logistics_delivery.lua`. Keine Mission-Editor-Änderung erforderlich.
