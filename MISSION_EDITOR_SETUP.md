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

Stand: **2026-07-06**

Aktueller technischer Status:

- sichere Einzeldatei-Ladung über `DO SCRIPT FILE` ist aktiv
- Vendor-Frameworks laden
- eigene Theater-Command-Dateien laden
- Main startet die Runtime-Systeme
- Loader prüft die Umgebung und beendet sauber
- F10-Menü ist sichtbar und navigierbar
- Missionen können über F10 angezeigt und aktiviert werden
- aktive Mission 1 kann über F10 auf `COMPLETED` gesetzt werden
- Mission Effects werden state-only vorbereitet
- CaptureSystem übernimmt abgeschlossene Mission Effects state-only in Capture Pressure
- Capture Ready entsteht dynamisch
- Capture Ready Zones sind über F10 sichtbar

Aktuelle getestete Systeme:

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

Aktueller wichtiger Befund:

- DCS Syria liefert **225 airbase-like objects**
- Airbase Scanner klassifiziert diese Objekte
- ZoneFactory erzeugt **46 relevante Kampagnenzonen**
- ZoneFactory überspringt **179 nicht geeignete airbase-like objects**
- CaptureSystem arbeitet auf **32 capture-fähigen Zielen**
- MissionGenerator erzeugt **78 Missionskandidaten**
- MissionGenerator erzeugt **10 verfügbare Missionen**
- F10Menu erzeugt **32 Commands**

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
- produktive Persistenz
- automatische Missionserfolgsauswertung
- automatische Capture-Auswertung mit Besitzwechsel

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

Dieser Slot dient aktuell dazu, die Mission starten und in der Simulation laufen lassen zu können.

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

- Zuerst muss der State weiter stabil, sichtbar und kontrollierbar sein.
- Danach folgen Persistenz, Debug und echte Framework-Ausführung.

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

Aktuell wird keine neue große Mission-Editor-Struktur gebaut.

Nächster technischer Schwerpunkt liegt weiter im Code/F10-State:

- kontrollierten state-only Ownership-Wechsel aus `Capture Ready Zone 1` vorbereiten

Möglicher F10-Pfad:

```text
Theater Command > Status > Show Capture Ready Zones
Theater Command > Status > Apply Capture Ready Zone 1
```

Danach kann geprüft werden:

- ob die Zone Ownership sauber state-only wechselt
- ob Linked Airbase Ownership kontrolliert synchronisiert wird
- ob Capture Pressure danach sauber zurückgesetzt oder markiert wird
- ob der Ownership-Wechsel später persistiert werden kann

Erst danach werden größere Mission-Editor-Elemente empfohlen:

- CTLD-Zonen
- MOOSE-Templates
- IADS-Objekte
- echte Target-Templates
- komplexere Client-Slot-Struktur

---

## 20. Aktueller Status

Die DEV-Mission ist als technischer Testträger funktionsfähig.

Starttest-Variante A ist bestanden.

F10Menu ist aktiv und bestätigt.

Mission Activation ist bestätigt.

Mission Completion ist bestätigt.

Capture Effect Processing ist bestätigt.

Capture Ready Visibility ist bestätigt.

Die nächste Entwicklungsentscheidung betrifft nicht den Mission Editor, sondern den kontrollierten state-only Ownership-Wechsel aus einer Capture Ready Zone.
