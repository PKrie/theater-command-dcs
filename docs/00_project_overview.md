# Project Overview

## Verbindliches Update — 2026-09-12

MissionGenerator `v0.2.3` erzeugt 10 Mission Records. Die Collections sind String-keyed Lua-Dictionaries; `#` ist dafür kein autoritativer Count. Live bestätigt: `statistics.available=10`, `pairs()`-Count `=10`, `#available=0`. Der am 2026-08-04 angenommene Mission-Record-Verlust ist damit widerlegt. Der tatsächliche Bug lag in `src/core/tc_state.lua` -> `State.summary()` und wurde mit einer pairs-basierten `countEntries()`-Funktion behoben und live getestet.

Das Offline Embedded Mission Resource Audit ist abgeschlossen: DEV und MCP_TEST waren byte-identisch, 13/13 relevante aktive Theater-Command-Ressourcen waren `EXACT_MATCH` zum Repository, keine aktive Embedded-Runtime-Drift. Eine Altressource (`ResKey_Action_55` / `tc_persistence_system.lua`) liegt weiterhin verwaist in der `.miz` — der Trigger-Verweis ist entfernt, die Ressource selbst ist nicht referenziert, nicht geladen, nicht ursächlich und eine separate spätere Cleanup-Aufgabe (nicht "vollständig entfernt").

PersistenceSystem `v0.2.6`: Embedded Start bestanden, `20s`/`120s`-Scheduler bestanden, `SAVED` bestanden, `SKIPPED` bestanden, kontrollierter `FAILED`-Pfad bestanden, Retry bestanden, `productiveRestore=false`.

Am 2026-09-12 erneut live bestanden: Mission Completion, Mission Failure, Capture Ready Apply. Zusätzlich bestanden: Capture Getter Dirty-Neutralität, Capture Ownership No-Op.

Priority 3 (allgemeine Dirty-Coverage der übrigen aktiven State-Systeme) bleibt offen. Nächster technischer Einzelschritt nach Dokumentationsabschluss: READ-ONLY Dirty-Coverage-Audit von `src/logistics/tc_logistics_delivery.lua`.

Ältere als „aktuell“ bezeichnete Abschnitte in dieser Datei sind historische Entwicklungs-Snapshots und werden durch dieses Update übersteuert.

Diese Datei gibt eine Gesamtübersicht über das Projekt **Theater Command DCS**.

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

## 1. Projektidee

**Theater Command DCS** soll ein modulares, dynamisches und später persistentes Kampagnensystem für DCS World werden.

Es soll keine einzelne statische Mission entstehen.

Ziel ist ein Kampagnensystem, das aus einem zentralen Zustand heraus folgende Bereiche steuert:

- Airbase-Erkennung
- strategische Airbase-Klassifizierung
- virtuelle Kampagnenzonen
- Capture-System
- Capture-Pressure
- Capture-Progress
- Capture Ready
- Logistiksystem
- CTLD-Anbindung
- FOB-Aufbau
- dynamische Missionsgenerierung
- Missionsauswahl über F10
- Missionsaktivierung über F10
- Mission Outcome Controls über F10
- Mission Effects
- AI-Reaktionen
- CAP- und GCI-Management
- spätere AI-Director-Logik
- Skynet-IADS-Anbindung
- F10-Menüs
- Debug-Werkzeuge
- Persistenz

Spieler sollen sich in eine laufende Kampagnenlage einklinken.

Die Kampagne soll langfristig nicht ausschließlich durch Spielerhandlungen angetrieben werden.

Blue und Red sollen perspektivisch eigene Operationen planen und ausführen.

---

## 2. Grundprinzip

Das zentrale Arbeitsprinzip lautet:

- **Mission Editor = Bühne**
- **Lua = Kampagnensystem**
- **GitHub = Projektgedächtnis**

Der DCS Mission Editor stellt die physische Umgebung bereit.

Lua übernimmt die dynamische Kampagnenlogik.

GitHub dokumentiert:

- Struktur
- Entscheidungen
- Versionen
- Aufgabenstand
- Testergebnisse
- bekannte Einschränkungen
- Übergaben zwischen Sessions

---

## 3. Aktueller Projektstand

Historischer Stand: **2026-07-06**. Der verbindliche aktuelle Stand steht oben (2026-09-12).

Aktueller Gesamtstatus:

- **State-first Runtime-Grundlage stabil**
- **MissionGenerator state-first funktional bestätigt**
- Mission Activation bestanden
- Mission Completion bestanden
- Mission Failure bestanden
- Mission Effects bestanden
- Completion -> Capture Pressure bestanden
- Failure -> kein Capture Pressure bestanden
- Capture Ready bestanden
- Capture Ready Apply bestanden
- Zone Ownership Sync bestanden
- linked Airbase Ownership Sync bestanden
- dirty-aware Background Autosave bestanden
- Embedded Resource Audit bestanden
- Capture Read-Dirty Regression bestanden
- Ownership-No-Op Regression bestanden
- `productiveRestore=false`
- Priority 3 noch offen

Das Projekt ist weiterhin:

- keine fertige spielbare dynamische Kampagne
- kein produktiver AI Director
- keine produktive Framework-Ausführung

Es besitzt aber inzwischen eine tragfähige Runtime-Grundlage, auf der die nächsten UI-, Debug-, Persistence-, CTLD-, MOOSE- und IADS-Schritte aufbauen können.

Aktuell abgeschlossen oder bestätigt:

- Repository erstellt
- zentrale Projektdokumentation angelegt
- `docs/`-Grundblock erstellt
- `mission_editor/`-Dokumentation angelegt
- `vendor/`-Frameworkstruktur erstellt
- MIST importiert
- MOOSE importiert
- CTLD importiert
- Skynet IADS importiert
- MIST auf CTLD-kompatible Version gesetzt
- Vendor-Dokumentation aktualisiert
- `src/`-Grundstruktur angelegt
- Core-System angelegt
- World-System angelegt
- Campaign-System angelegt
- Logistics-System angelegt
- Missions-System angelegt
- AI-CAP-System angelegt
- UI-System angelegt
- IADS- und Debug-Bereiche vorbereitet
- Loader erstellt
- Main-Initialisierung erstellt
- lokale Repository-Kopie auf dem DCS-PC eingerichtet
- minimale Syria-DEV-Mission im DCS Mission Editor erstellt
- erster blauer F/A-18C-Client-Slot auf Akrotiri angelegt
- Framework-Lade-Trigger im Mission Editor angelegt
- Source-Lade-Trigger für sichere Einzeldatei-Ladung im Mission Editor angelegt
- reale DCS-Starttests durchgeführt
- `dcs.log` mehrfach erfolgreich ausgewertet
- Theater-Command-Startkette in DCS erfolgreich bestätigt
- F10-Menü in DCS sichtbar und navigierbar bestätigt
- direkte Missionsauswahl über F10 bestätigt
- direkte Missionsaktivierung über F10 bestätigt
- Mission Completion über F10 bestätigt
- Mission Effects state-only vorbereitet
- abgeschlossene Mission Effects durch CaptureSystem verarbeitet
- Capture Pressure durch Mission Completion erzeugt
- Capture Progress durch Mission Completion aktualisiert
- Capture Ready dynamisch erzeugt
- Capture Ready Zones über F10 bestätigt
- Mission Failure über F10 bestätigt
- Capture Ready Apply über F10 bestätigt
- Zone Ownership Update bestätigt
- linked Airbase Ownership Sync bestätigt
- Persistence Background Autosave bestätigt
- Completion Persistence Regression bestätigt
- Failure Persistence Regression bestätigt
- Capture Apply Persistence Regression bestätigt
- Embedded Resource Audit 13/13 `EXACT_MATCH` bestätigt
- Capture Getter Dirty-Neutralität bestätigt
- Capture Ownership No-Op bestätigt

Priority 3 (allgemeine Dirty-Coverage der übrigen aktiven State-Systeme) ist NICHT vollständig abgeschlossen.

---

## 4. Aktueller technischer Befund

Der aktuelle DCS-Teststand bestätigt:

- MIST wird geladen
- MOOSE wird geladen
- CTLD-i18n wird geladen
- CTLD wird geladen
- Skynet IADS wird geladen
- Theater Command Loader startet
- Frameworks werden durch den Loader erkannt
- Core wird geladen
- World wird geladen
- Campaign wird geladen
- Logistics wird geladen
- Missions wird geladen
- AI wird geladen
- UI wird geladen
- Main wird gestartet
- Runtime-Systeme werden initialisiert
- Airbase Scanner läuft
- ZoneFactory läuft
- CaptureSystem läuft
- PersistenceSystem `v0.2.6` läuft dirty-aware als getesteter Background-Autosave; Restore bleibt deaktiviert
- LogisticsDelivery läuft
- FobSystem läuft
- MissionGenerator läuft
- AICapManager läuft
- F10Menu läuft
- Loader beendet sauber

Wichtige bestätigte Werte:

- Syria airbase-like objects: **225**
- relevante Kampagnenzonen: **46**
- übersprungene nicht geeignete airbase-like objects: **179**
- capture-fähige Ziele: **32**
- Capture-Pressure-Records: **32**
- Capture-Progress-Records: **32**
- Logistics Hubs: **46**
- FOB-Kandidaten: **6**
- geplante Blue-FOBs: **2**
- Missionskandidaten: **78**
- FOB-Support-Kandidaten: **2**
- Mission Records: **10**
- F10 Commands: **33**
- angewendete Mission Effects nach Completion-Test: **1**
- Capture Ready nach Completion-Test: **1**
- Pressure Contested nach Completion-Test: **0**

Mission Records: 10 Mission Records liegen als String-keyed Dictionaries vor; `pairs()`-Count bestätigt `10`, `#` liefert `0` und ist für diese Collections nicht autoritativ.

Bewertung:

- Die technische Startkette funktioniert.
- Die hohe Zahl erkannter Airbase-like Objects ist kein Startfehler.
- Die aktuelle Filterung ist fachlich deutlich besser als im ersten Starttest.
- ZoneFactory erzeugt nicht mehr 225 ungefilterte Zonen, sondern 46 relevante Kampagnenzonen.
- CaptureSystem arbeitet nicht auf allen Airbase-like Objects, sondern auf 32 sinnvollen Capture-Zielen.
- F10Menu ist der erste bestätigte Spielerzugang zur Kampagne.
- MissionGenerator ist für den aktuellen state-first Funktionsumfang bestätigt.
- Missionen können state-only aktiviert werden.
- Missionen können state-only abgeschlossen werden.
- Mission Failure funktioniert.
- Mission Completion erzeugt inzwischen einen sichtbaren Capture-Effekt.
- Capture Ready kann über F10 angezeigt werden.
- Capture Ready Apply funktioniert.
- dirty-aware Persistence reagiert auf echte State-Änderungen.
- reine Capture Reads erzeugen kein falsches Dirty.
- Ownership-No-Op erzeugt kein Dirty.
- Echte Spawns sind bewusst noch nicht aktiv.

---

## 5. Bestätigte modulübergreifende Pipeline

Aktuell ist erstmals eine vollständige modulübergreifende Kampagnenkette bestätigt.

Bestätigte End-to-End-Kette:

1. Mission Details
2. Mission Activation
3. Mission Completion
4. Mission Effects
5. Capture Pressure
6. Capture Progress
7. Capture Ready
8. Capture Ready Apply
9. Zone Ownership Update
10. linked Airbase Ownership Sync
11. Background Autosave

Bestätigter Testfall (Mission Completion):

- completed mission: `MISSION_2`
- target zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- capture pressure owner: `BLUE`
- applied pressure: **105**
- progress: **100 %**
- appliedMissionEffects: **1**
- ready: **1**
- contested: **0**

Capture Ready Apply:

Zone `ZONE_AIRBASE_ABU_AL_DUHUR`. Vor Apply: `RED -> BLUE`, Progress `100 %`. Danach: `zoneOwner=BLUE`, `previousOwner=RED`, `baseOwner=BLUE`, `progress=0`, `status=STABLE`, `captureReady=false`. Persistence: `SAVED`, `dirtyReason=f10_capture_ready_zone_1_applied`, `dirtyCleared=true`, `productiveRestore=false`.

Zusätzlich bestätigte Failure-Pipeline:

Mission Activation -> `FAILED` -> Failure Effects prepared -> CaptureSystem verarbeitet -> kein Capture Pressure -> Persistence `SAVED` (`dirtyReason=f10_active_mission_1_failed`).

Diese Pipeline bleibt bewusst:

- state-only
- ohne echte MOOSE-Spawns
- ohne echte CTLD-Aktionen
- ohne echte Skynet-Aktionen
- mit getesteter dirty-aware Background-Persistence, aber ohne produktiven Startup-Restore
- ohne automatischen produktiven Ownership-Wechsel ohne bewusste Testaktion

---

## 6. Aktuelle DEV-Mission

Aktuelle technische Entwicklungsmission:

- `Operation_Levant_Reclamation_DEV.miz`

Aktueller Inhalt:

- Map: Syria
- Koalitionspreset: Modern
- Blue Start: Akrotiri / Zypern
- erster blauer Client-Slot: F/A-18C Lot 20 auf Akrotiri
- Trigger: sichere Einzeldatei-Ladung
- Vendor-Frameworks werden geladen
- Theater-Command-Source-Dateien werden geladen
- F10-Menü ist sichtbar und testbar
- Missionen sind über F10 sichtbar
- Missionen können über F10 aktiviert werden
- Mission Completion kann über F10 ausgelöst werden
- Mission Failure ist testbar und bestanden
- Capture Ready Apply ist testbar und bestanden
- Capture-/Pressure-Status ist über F10 sichtbar
- Capture Ready Zones sind über F10 sichtbar
- PersistenceSystem `v0.2.6` ist eingebettet
- dirty-aware Background Autosave ist aktiv
- F10Menu `v0.2.3` / 33 Commands

Noch nicht produktiv enthalten:

- produktive rote Frontlinie
- produktive IADS-Stellungen
- produktive CTLD-Zonen
- produktive Template-Gruppen
- echte MOOSE-Spawns
- echte CTLD-FOBs
- echte CTLD-Cargo-Flüge
- kein produktiver automatischer Startup-Restore
- keine automatische Kampagnenfortsetzung aus Save beim Missionsstart
- automatische Missionserfolgsauswertung
- automatische Capture-Auswertung mit Besitzwechsel

Diese Mission ist aktuell ein technischer Testträger.

Sie ist noch keine fertige spielbare Kampagnenmission.

---

## 7. Hauptstruktur

Aktuelle Hauptstruktur:

```text
docs/
mission_editor/
src/
vendor/
README.md
ROADMAP.md
TASKS.md
CHANGELOG.md
ARCHITECTURE.md
MISSION_EDITOR_SETUP.md
NAMING_CONVENTIONS.md
LUA_STYLEGUIDE.md
```

---

## 8. Dokumentationsstruktur

Der Ordner `docs/` enthält die fachliche und technische Projektdokumentation.

Aktuelle Dateien:

```text
docs/00_project_overview.md
docs/01_campaign_design.md
docs/02_technical_architecture.md
docs/03_mission_editor_basics.md
docs/04_airbase_system.md
docs/05_logistics_system.md
docs/06_mission_generator.md
docs/07_ai_director.md
docs/08_iads_system.md
docs/09_persistence.md
docs/10_testing.md
```

Wichtiger aktueller Hinweis:

- Die Projektdokumentation wurde auf den verifizierten Stand **2026-09-12** synchronisiert.
- Synchronisiert sind insbesondere: `README.md`, `ROADMAP.md`, `TASKS.md`, `ARCHITECTURE.md`, `CHANGELOG.md`, `MISSION_EDITOR_SETUP.md`, `LUA_STYLEGUIDE.md`, `docs/00_project_overview.md`, `docs/01_campaign_design.md`, `docs/02_technical_architecture.md`, `docs/03_mission_editor_basics.md`, `docs/04_airbase_system.md`, `docs/05_logistics_system.md`, `docs/06_mission_generator.md`, `docs/07_ai_director.md`, `docs/08_iads_system.md`, `docs/09_persistence.md`, `docs/10_testing.md`.
- Die geplante Dokumentationssynchronisierung ist abgeschlossen. Es gibt keine noch ausstehende Fachdoc-Liste aus dieser Synchronisierungsrunde.
- Künftige Dokumentationsänderungen erfolgen wieder nur aufgrund neuer technischer Änderungen oder neuer verifizierter Tests.
- Priority 3 bleibt technisch offen. Der nächste technische Schritt bleibt: READ-ONLY Dirty-Coverage-Audit von `src/logistics/tc_logistics_delivery.lua`.

---

## 9. Mission-Editor-Dokumentation

Der Ordner `mission_editor/` dokumentiert Arbeiten, die direkt im DCS Mission Editor vorbereitet werden müssen.

Aktuelle Dateien:

```text
mission_editor/README.md
mission_editor/trigger_setup.md
```

Aktueller Status:

- Die sichere Einzeldatei-Ladung ist dokumentiert und erfolgreich getestet.
- Per `DO SCRIPT FILE` geladene Lua-Dateien werden in die `.miz` eingebettet.
- Nach jeder Lua-Änderung muss die jeweilige Datei im Mission Editor erneut ausgewählt und die Mission gespeichert werden.
- Die aktive Ladefolge ist weiterhin Einzeldatei-Ladung.
- Loader-only per `dofile` ist noch nicht praktisch getestet.
- F10Menu ist aktiv und Teil der Ladefolge.

---

## 10. Source-Struktur

Eigene Theater-Command-Logik liegt unter:

```text
src/
```

Aktuelle Source-Struktur:

```text
src/
├── README.md
├── loader.lua
├── main.lua
├── core/
├── world/
├── campaign/
├── logistics/
├── missions/
├── ai/
├── iads/
├── ui/
└── debug/
```

Aktive eigene Lua-Dateien:

```text
src/loader.lua
src/main.lua
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
```

Aktuell vorbereitet, aber noch nicht produktiv implementiert:

```text
src/iads/
src/debug/
```

Wichtige Korrektur gegenüber älteren Dokumenten:

- `src/ui/` ist nicht mehr nur dokumentiert.
- `src/ui/tc_f10_menu.lua` ist aktiv und getestet.
- `src/campaign/tc_capture_system.lua` ist inzwischen `v0.2.2`.
- `src/missions/tc_mission_generator.lua` ist inzwischen `v0.2.3`.
- `src/ui/tc_f10_menu.lua` ist inzwischen `v0.2.3`.

---

## 11. Framework-Basis

Externe Frameworks liegen unter:

```text
vendor/
```

Aktuelle Framework-Basis:

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD-i18n | `vendor/ctld/CTLD-i18n.lua` | geladen |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Wichtig:

- Frameworks werden nicht verändert.
- Eigene Logik wird nicht in Framework-Dateien geschrieben.
- Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket.
- MOOSE ist geladen, aber noch nicht produktiv angebunden.
- CTLD ist geladen, aber noch nicht produktiv angebunden.
- Skynet IADS ist geladen, aber noch nicht produktiv angebunden.

---

## 12. Externe DCS-Lade-Reihenfolge

Die Frameworks werden im DCS Mission Editor in dieser Reihenfolge geladen:

1. `vendor/mist/mist.lua`
2. `vendor/moose/Moose.lua`
3. `vendor/ctld/CTLD-i18n.lua`
4. `vendor/ctld/CTLD.lua`
5. `vendor/skynet-iads/SkynetIADS.lua`

Danach folgt die eigene Theater-Command-Logik.

---

## 13. Aktive Theater-Command-Lade-Reihenfolge

Aktive Ladefolge der eigenen Dateien:

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

- `src/ui/tc_f10_menu.lua` wird nach `src/ai/tc_ai_cap_manager.lua` und vor `src/main.lua` geladen.
- `src/main.lua` initialisiert die Runtime-Systeme.
- `src/loader.lua` bleibt aktuell die letzte eigene Datei.

---

## 14. Aktueller getesteter Systemstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | funktional bestanden; Read-Dirty- und Ownership-No-Op-Regressionen bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | Embedded Start, `SAVED`, `SKIPPED`, `FAILED`, Retry und Campaign-Persistence-Regressionen bestanden; `productiveRestore=false` |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | funktional bestanden; Dirty-Coverage ist nächster Priority-3-Audit |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | funktional bestanden; Dirty-Coverage noch offen |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | 10 Mission Records; Activation / Completion / Failure / Effects bestanden; Record-Loss-Verdacht widerlegt; allgemeine Dirty-Coverage noch offen |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | state-first bestanden; `reactToActiveMissions()`-Sonderfall bewertet; allgemeine Dirty-Coverage noch offen |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden; 33 Commands |

---

## 15. Airbase Scanner

Datei:

```text
src/world/tc_airbase_scanner.lua
```

Getestete Version:

```text
v0.2.2
```

Status:

- bestanden

Bestätigte Werte:

- total: 225
- strategic: 19
- secondary: 13
- heliports: 1
- helipads: 95
- medical: 40
- farps: 0
- tactical: 13
- unknown: 44
- captureCandidates: 32
- missionCandidates: 32
- logisticsCandidates: 46
- blueStartBases: 1
- redStrategicCandidates: 18

Bewertung:

- Akrotiri wird korrekt als Blue-Startbasis erkannt.
- Akrotiri wird als `STRATEGIC_AIRFIELD` klassifiziert.
- Syrische Hauptflugplätze werden als Red Strategic Candidates vorbereitet.
- Medical Pads und einfache Helipads werden nicht als strategische Kampagnenziele behandelt.

---

## 16. ZoneFactory

Datei:

```text
src/world/tc_zone_factory.lua
```

Getestete Version:

```text
v0.2.0
```

Status:

- bestanden

Bestätigte Werte:

- total zones: 46
- classified airbase zones: 46
- Mission Editor zones: 0
- skipped airbase-like objects: 179
- strategic zones: 19
- secondary zones: 13
- heliport zones: 1
- farp zones: 0
- tactical zones: 13
- captureZones: 32
- missionZones: 32
- logisticsZones: 46
- startBaseZones: 1

Bewertung:

- ZoneFactory erzeugt 46 relevante Kampagnenzonen.
- 179 nicht relevante Airbase-like Objects werden übersprungen.
- Die frühere Aussage „ZoneFactory registriert 225 Zonen“ ist veraltet.

---

## 17. CaptureSystem

Datei:

```text
src/campaign/tc_capture_system.lua
```

Getestete Version:

```text
v0.2.2
```

Status:

- bestanden

Bestätigte Startwerte:

- eligibleBases: 32
- eligibleZones: 32
- nonCaptureBases: 193
- nonCaptureZones: 14
- pressureRecords: 32
- progressRecords: 32
- appliedMissionEffects: 0
- ready: 0
- contested: 0

Bestätigte Werte nach Mission Completion:

- completed mission: `MISSION_2`
- target zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- capture pressure owner: `BLUE`
- applied pressure: 105
- progress: 100 %
- appliedMissionEffects: 1
- ready: 1
- contested: 0

2026-09-12 bestätigt:

- Mission Completion -> Capture Pressure
- Mission Failure -> kein Capture Pressure
- Capture Ready Apply
- Zone Ownership Update
- linked Airbase Ownership Sync

Capture Dirty Tracking: 7 Getter getestet (`getCaptureReadyZones`, `getPressureContestedZones`, `getPressureSummary`, `getCaptureEligibleBases`, `getCaptureEligibleZones`, `getEligibilitySummary`, `getCaptureProgress`) — alle `dirty=false`, `reason=nil`. Positive Mutation: `capture_pressure_set` -> `dirty=true`.

Ownership No-Op: identischer Owner -> keine persistierte Mutation -> `dirty=false`.

Diese Ergebnisse gelten für die heute geprüften Read-/Pressure-/Ownership-No-Op-Pfade; die gesamte projektweite Dirty-Coverage (Priority 3) ist damit nicht abgeschlossen.

Bewertung:

- CaptureSystem ist nicht mehr nur Ownership-Verwaltung.
- CaptureSystem erzeugt Capture-Pressure und Capture-Progress.
- Missionseffekte können state-only als Capture-Druck verarbeitet werden.
- Abgeschlossene Mission Effects werden automatisch verarbeitet.
- Capture Ready entsteht dynamisch.
- Capture Ready ist über F10 sichtbar.
- Automatische produktive Capture-Folgen bleiben deaktiviert.

---

## 18. LogisticsDelivery

Datei:

```text
src/logistics/tc_logistics_delivery.lua
```

Getestete Version:

```text
v0.2.0
```

Status:

- bestanden

Bestätigte Werte:

- logistics hubs: 46
- blue hubs: 7
- red hubs: 24
- neutral hubs: 15
- active hubs: 31
- limited hubs: 15
- locked hubs: 0

Bewertung:

- LogisticsDelivery erzeugt 46 Logistics Hubs.
- CTLD ist geladen, aber noch nicht produktiv verbunden.
- Logistics ist aktuell State-only.
- Die allgemeine Dirty-Coverage dieses Moduls ist noch nicht systematisch auditiert; es ist der nächste Priority-3-Prüfschritt, zunächst READ ONLY, kein Code-Fix ohne konkreten Befund.

---

## 19. FobSystem

Datei:

```text
src/logistics/tc_fob_system.lua
```

Getestete Version:

```text
v0.2.0
```

Status:

- bestanden

Bestätigte Werte:

- FOB candidates: 6
- stored candidates: 6
- auto-planned FOBs: 2
- skipped candidates: 4
- Blue FOBs: 2

Erzeugte FOBs:

- `FOB Ercan`
- `FOB Gecitkale`

Status:

- `UNDER_CONSTRUCTION`

Bewertung:

- FOBs sind aktuell State-only.
- Es werden noch keine echten CTLD-FOBs erzeugt.
- FOB-Support ist aber bereits Grundlage für MissionGenerator.
- Die allgemeine FOB-Dirty-Coverage steht noch aus; ein konkreter Missing-Dirty-Bug ist damit nicht automatisch bewiesen.

---

## 20. MissionGenerator

Datei:

```text
src/missions/tc_mission_generator.lua
```

Getestete Version:

```text
v0.2.3
```

Status:

- bestanden

Bestätigte Werte:

- mission candidates: 78
- fobSupportCandidates: 2
- generated missions: 10
- reservedCreated: 1
- duplicatesSkipped: 1
- typeLimitSkipped: 68

Bestätigt:

- 78 candidates, 2 FOB Support candidates, 10 Mission Records.
- Mission Records sind String-keyed Dictionaries (siehe oben, Verbindliches Update).
- Missionen enthalten Objectives.
- Missionen enthalten Briefings.
- Missionen enthalten Progress-Daten.
- Missionen enthalten Activation Metadata.
- Missionen enthalten Outcome State.
- Missionen enthalten Effect State.
- MOOSE-, CTLD- und Skynet-Hooks sind reserviert (reserved Framework Hooks).
- Aktivierte Missionen bleiben `stateOnly=true`.
- Spawn-Hooks bleiben `reserved`.
- Activation, Completion, Failure und Effects sind bestanden.
- Completion -> Capture Pressure funktioniert.
- Failure -> kein Capture Pressure funktioniert.
- vorbereitete Mission Effects können vom CaptureSystem verarbeitet werden.

Record-Loss-Verdacht: widerlegt (siehe Verbindliches Update oben und `docs/06_mission_generator.md`).

Persistence: Completion setzt Dirty, `SAVED`; Failure setzt Dirty, `SAVED`. Noch offen: allgemeine MissionGenerator-Dirty-Coverage, `CANCELLED`, `EXPIRED`, automatische DCS-Event-Auswertung.

Bewertung:

- MissionGenerator ist deutlich über „technisch ladbar“ hinaus.
- Missionen sind im F10-Menü sichtbar und aktivierbar.
- Mission Completion und Mission Failure sind über F10 praktisch getestet.
- Echte DCS-Spawns werden weiterhin nicht ausgelöst.

---

## 21. AICapManager

Datei:

```text
src/ai/tc_ai_cap_manager.lua
```

Getestete Version:

```text
v0.2.0
```

Status:

- bestanden

Bestätigte Werte:

- cap zone candidates: 31
- auto-registered CAP zones: 12
- CAP requests: 12
- reactionState: `AIR_REACTION_REQUESTED`
- threatLevel: `HIGH`

`reactToActiveMissions(options)`: READ-ONLY auditiert, aktuell keine produktive Call-Site — nicht durch `start()`, Scheduler, `main.lua`, `loader.lua` oder F10 aufgerufen. Latenter Missing-Dirty-Randfall für spätere Verdrahtung; aktuell kein Runtime-Persistence-Bug, kein Fix jetzt. Die allgemeine AICapManager-Dirty-Coverage bleibt davon unabhängig offen (Priority 3).

Bewertung:

- AI CAP Manager bereitet CAP-State vor.
- MOOSE-CAP-Spawns sind noch nicht aktiv.
- `spawn=MOOSE_PENDING` ist erwartetes Verhalten.
- keine echten MOOSE-CAP-Spawns.

---

## 22. F10Menu

Datei:

```text
src/ui/tc_f10_menu.lua
```

Getestete Version:

```text
v0.2.3
```

Status:

- bestanden

Bestätigt:

- F10-Menü ist in DCS sichtbar.
- F10-Menü ist navigierbar.
- 33 Commands werden erzeugt.
- Mission Details 1–10.
- Mission Activation 1–10.
- Active Mission Outcome Status.
- Complete Active Mission 1.
- Fail Active Mission 1.
- Capture Status.
- Capture Ready Zones.
- Apply Capture Ready Zone 1.
- Pressure Contested Zones.
- Logistics Status.
- FOB Status.
- AI CAP Status.
- MissionGenerator setzt aktivierte Missionen auf `ACTIVE`.
- MissionGenerator setzt abgeschlossene bzw. fehlgeschlagene Missionen auf `COMPLETED`/`FAILED`.
- CaptureSystem verarbeitet abgeschlossene Mission Effects.
- Aktivierung bleibt state-only.
- Completion bleibt state-only.
- Es werden keine echten Spawns ausgelöst.

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

- F10Menu ist die erste bestätigte Spieleroberfläche.
- Missionen können state-only gesteuert werden.
- Capture Ready ist über F10 sichtbar.
- Capture Ready Apply ist bereits bestanden (kein offener nächster Schritt mehr für F10Menu).

---

## 23. PersistenceSystem

Datei:

```text
src/campaign/tc_persistence_system.lua
```

Version:

```text
v0.2.6
```

Status:

- technisch bestanden
- internes Background-System
- dirty-aware Autosave aktiv
- kein Spieler-F10-Workflow
- `productiveRestore=false`

Bestätigt:

- DCS-Dateisystemzugriff
- Save
- Read-back
- Compile
- Evaluate
- Validation
- kontrollierter Import
- normaler Embedded Start
- `20s`-/`120s`-Scheduler
- `SAVED`
- `SKIPPED`
- `FAILED`
- Retry
- Completion Persistence Regression
- Failure Persistence Regression
- Capture Apply Persistence Regression

Bewertung:

- Persistenz ist ein funktionierender Hintergrunddienst, kein theoretisches Konzept mehr.
- Save/Load ist im DCS-Dateisystem getestet und bestanden.
- Weiter offen: Priority 3 Dirty-Coverage, Restore-/Initialisierungsreihenfolge, Save-Kompatibilitäts-/Versionsstrategie, separater produktiver Restore-Test.

---

## 24. Noch nicht produktiv

Noch nicht produktiv implementiert:

- echte MOOSE-Spawns
- echte MOOSE-CAP-Flüge
- echte Strike-/SEAD-/DEAD-Spawns
- echte CTLD-Cargo-Flüge
- echte CTLD-FOBs
- echte Skynet-IADS-Kampagnenlogik
- AI Director
- automatische Missionserfolgsauswertung über DCS-Events
- automatische reale Capture-Auswertung
- produktiver Startup-Restore
- automatische `.miz`-Generierung
- autonome Blue-/Red-Kampagnenoperationen

Background Autosave ist bereits aktiv und getestet; nur der produktive Startup-Restore bleibt deaktiviert.

---

## 25. Architekturregeln

Eigene Lua-Logik wird nach Aufgaben sortiert, nicht nach Frameworks.

Nicht gewünscht:

```text
tc_moose.lua
tc_mist.lua
tc_ctld.lua
tc_all_in_one.lua
```

Gewünscht:

```text
tc_airbase_scanner.lua
tc_zone_factory.lua
tc_capture_system.lua
tc_logistics_delivery.lua
tc_fob_system.lua
tc_mission_generator.lua
tc_ai_cap_manager.lua
tc_persistence_system.lua
tc_f10_menu.lua
```

Vendor-Dateien werden nicht verändert.

Eigene Integrationslogik gehört nach `src/`.

---

## 26. Aktuelle Arbeitsweise

Es wird immer nur eine konkrete Aufgabe oder eine Datei pro Schritt bearbeitet.

Bei neuen oder ersetzten Dateien gilt:

- exakten Dateipfad angeben
- vollständigen Dateiinhalt liefern
- einen einzigen vollständigen Codeblock liefern
- passenden Commit-Text angeben
- keine halben Dateien
- keine parallelen Aufgabenlisten
- keine Vendor-Dateien verändern

Wichtig für DCS:

Eine per `DO SCRIPT FILE` geladene Lua-Datei wird in die `.miz` eingebettet.

Nach jeder Lua-Änderung muss die Datei im Mission Editor erneut ausgewählt und die Mission gespeichert werden.

---

## 27. Nächster technischer Schritt

Priority 3 ist NICHT abgeschlossen.

Bereits geklärt:

- Capture Getter/Derived Dirty
- Capture Ownership No-Op
- `reactToActiveMissions()` Sonderfall

Noch systematisch zu prüfen:

1. `src/logistics/tc_logistics_delivery.lua`
2. `src/logistics/tc_fob_system.lua`
3. `src/missions/tc_mission_generator.lua`
4. `src/ai/tc_ai_cap_manager.lua`

Nächster technischer Schritt:

Priority 3 — READ-ONLY Dirty-Coverage-Audit von `src/logistics/tc_logistics_delivery.lua`.

Ziele:

- alle persistierten Logistics-State-Writes erfassen
- alle `markDirty()`-Pfade erfassen
- echte Mutationen vs. Reads/No-Ops prüfen
- Dirty Reasons bewerten
- Call-Sites erfassen
- keine Codeänderung ohne belegten Befund

Keine Mission-Editor-Änderung ist dafür zunächst erforderlich. Kein paralleler Audit von FOB, MissionGenerator oder AI.

---

## 28. Noch zu prüfende Detaildokumentation

`docs/06_mission_generator.md`, `docs/10_testing.md` und `docs/09_persistence.md` sind bereits auf den Stand 2026-09-12 synchronisiert und nicht mehr offen.

Nächste einzelne Dokumentdatei nach `docs/00_project_overview.md`:

```text
docs/02_technical_architecture.md
```

Danach folgen später einzeln:

```text
docs/07_ai_director.md
docs/01_campaign_design.md
docs/03_mission_editor_basics.md
docs/04_airbase_system.md
docs/05_logistics_system.md
docs/08_iads_system.md
LUA_STYLEGUIDE.md (punktuell)
```

Diese werden in diesem Schritt nicht bearbeitet.
