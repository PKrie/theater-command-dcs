# Technical Architecture

## Verbindliches Update — 2026-09-12

MissionGenerator `v0.2.3` erzeugt 10 Mission Records. Die sechs Mission-Status-Collections sind String-keyed Lua-Dictionaries; `#` ist dafür kein autoritativer Count. Live bestätigt: `statistics.available=10`, `pairs()`-Count `=10`, `#available=0`. Der frühere Mission-Record-Loss war eine Fehldiagnose. Der tatsächliche Source-Bug lag in `src/core/tc_state.lua` -> `State.summary()`: `active` und `completed` wurden mit `#` gezählt. Die pairs-basierte Funktion `countEntries()` behebt dies; der Fix wurde committed, gepusht, neu eingebettet und live getestet. Eine repo-weite READ-ONLY Prüfung fand keine weiteren entsprechenden falschen `#`-Counts auf Mission-State-Dictionaries. Die frühere Klassifikation `PROJECT SOURCE HAS NO MATCHING WRITE SITE` ist ausschließlich historischer, inzwischen widerlegter Diagnosekontext.

Der Offline Embedded Mission Resource Audit ist abgeschlossen und bestanden: DEV und MCP_TEST waren beim Audit byte-identisch; 13/13 relevante aktive Theater-Command-Ressourcen waren `EXACT_MATCH` zum Repository, bei 0 relevanten aktiven Byte-Mismatches. Es gab keine aktive Embedded-Runtime-Drift; sie ist als Ursache der früheren Mission-Diagnose ausgeschlossen. Bei `ResKey_Action_55` / `tc_persistence_system.lua` wurde nur der alte Trigger-Verweis entfernt. Die Ressource liegt weiterhin verwaist in der `.miz`, ist nicht referenziert, nicht geladen, nicht ursächlich und eine separate spätere Cleanup-Aufgabe. Aktiv geladen wird `tc_persistence_system_v0_2_6.lua`.

DCS-SMS ist Entwicklungs-/Mission-Editor-/Diagnose-Tooling, kein Theater-Command-Runtime-Framework. Bestätigter Stand: `v0.27.2`, Hook `me-bridge-0.27.2`; Auto-Routing per `dcs-sms exec --code "..."` erreicht das Mission Environment und `TC`. Nach einem DCS-Update musste der MissionScripting-Hook erneut installiert/repariert werden. Die Sandbox ist mit `os=true`, `io=true`, `lfs=true`, `require=false` bestätigt. Persistence benötigt direkt `io`/`lfs`, die aktuelle Bridge `os`/`io`/`lfs`. DCS-Updates können `MissionScripting.lua` überschreiben.

Mission Completion, Mission Failure, Capture Ready Apply und ihre Background-Autosaves sind bestanden; zusätzlich Capture Getter Dirty-Neutralität und Capture Ownership No-Op. PersistenceSystem `v0.2.6` bleibt dirty-aware mit `productiveRestore=false`. Priority 3 ist noch offen; nächster technischer Einzelschritt ist der READ-ONLY Dirty-Coverage-Audit von `src/logistics/tc_logistics_delivery.lua`.

Referenzstand: `README.md`, `ROADMAP.md`, `TASKS.md`, `ARCHITECTURE.md`, `CHANGELOG.md`, `MISSION_EDITOR_SETUP.md`, `docs/00_project_overview.md`, `docs/06_mission_generator.md`, `docs/09_persistence.md` und `docs/10_testing.md`.

Diese Datei beschreibt die technische Architektur von **Theater Command DCS**.

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

## 1. Grundprinzip

Das zentrale Architekturprinzip lautet:

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

## 2. Architekturziel

Theater Command DCS soll langfristig eine dynamische und später persistente DCS-Kampagne ermöglichen.

Ziel ist keine einzelne statische Mission, sondern eine modulare Kampagnenruntime.

Langfristig sollen folgende Systeme zusammenarbeiten:

- World Layer
- Campaign Layer
- Capture System
- Logistics System
- FOB System
- Mission Generator
- AI CAP Manager
- AI Director
- IADS System
- F10 UI
- Debug System
- Persistence System

Spieler sollen sich über Client-Slots und F10-Menüs in die laufende Kampagne einklinken.

Die Kampagne soll perspektivisch auch ohne ständige Spielerentscheidung weiterlaufen.

Blue und Red sollen später eigene Operationen planen und durchführen.

---

## 3. Aktueller technischer Stand

Historische Baseline: **2026-07-06**. Verbindlicher aktueller Stand: **2026-09-12**.

Aktueller Status:

- **State-first Runtime-Grundlage stabil getestet**
- **Mission Outcome to Capture Pressure Pipeline bestanden**
- **Capture Ready über F10 sichtbar bestätigt**
- MissionGenerator state-first funktional bestätigt; Activation, Completion, Failure und Effects bestanden.
- Completion -> Capture Pressure und Failure -> kein Capture Pressure bestanden.
- Capture Ready Apply, Zone Ownership Update und linked Airbase Ownership Sync bestanden.
- dirty-aware Background Autosave und Embedded Resource Audit bestanden.
- Capture Getter Dirty-Neutralität und Capture Ownership No-Op bestanden.
- `productiveRestore=false`; Priority 3 bleibt offen.

Aktuell vorhanden:

- Repository-Grundstruktur
- zentrale Projektdokumentation
- `docs/`-Dokumentation
- `mission_editor/`-Dokumentation
- `vendor/`-Frameworkstruktur
- MIST
- MOOSE
- CTLD
- Skynet IADS
- `src/`-Grundstruktur
- Loader
- Main-Initialisierung
- Core-System
- World-System
- Campaign-System
- CaptureSystem
- PersistenceSystem `v0.2.6` mit dirty-aware Background-Autosave
- LogisticsDelivery
- FobSystem
- MissionGenerator
- AICapManager
- F10Menu
- IADS- und Debug-Bereiche vorbereitet
- minimale Syria-DEV-Mission
- erster blauer F/A-18C-Client-Slot auf Akrotiri
- sichere Einzeldatei-Ladung im Mission Editor
- reale DCS-Starttests
- erfolgreiche `dcs.log`-Auswertungen

Aktuell bestätigt:

- Vendor-Frameworks werden durch DCS geladen.
- Frameworks werden durch Theater Command erkannt.
- eigene Source-Dateien werden geladen.
- Loader startet.
- Main startet.
- Runtime-Systeme werden initialisiert.
- Airbase Scanner läuft.
- ZoneFactory läuft.
- CaptureSystem läuft.
- PersistenceSystem `v0.2.6` lädt/startet und führt verifizierte dirty-aware Autosaves aus; Restore bleibt deaktiviert.
- LogisticsDelivery läuft.
- FobSystem läuft.
- MissionGenerator läuft.
- AICapManager läuft.
- F10Menu läuft.
- Loader beendet sauber.
- Missionen sind über F10 sichtbar.
- Missionen können über F10 aktiviert werden.
- aktive Mission 1 kann über F10 auf `COMPLETED` gesetzt werden.
- Mission Effects werden state-only vorbereitet.
- CaptureSystem verarbeitet abgeschlossene Mission Effects.
- Capture Pressure wird durch Mission Completion erzeugt.
- Capture Progress wird durch Mission Completion aktualisiert.
- Capture Ready entsteht dynamisch.
- Capture Ready Zones sind über F10 sichtbar.

Wichtiger technischer Befund:

- DCS Syria liefert **225 airbase-like objects**.
- Airbase Scanner klassifiziert diese Objekte.
- ZoneFactory erzeugt daraus **46 relevante Kampagnenzonen**.
- ZoneFactory überspringt **179 nicht geeignete airbase-like objects**.
- CaptureSystem arbeitet auf **32 capture-fähigen Zielen**.
- CaptureSystem erzeugt **32 Pressure-Records**.
- CaptureSystem erzeugt **32 Progress-Records**.
- LogisticsDelivery erzeugt **46 Logistics Hubs**.
- FobSystem erzeugt **6 FOB-Kandidaten** und **2 Blue-FOBs**.
- MissionGenerator erzeugt **10 Mission Records** aus **78 Mission Candidates**, darunter **2 FOB-Support Candidates**.
- F10Menu erzeugt **33 Commands**.
- Mission Completion erzeugt einen Capture Effect.
- `appliedMissionEffects=1` wurde bestätigt.
- `ready=1` wurde bestätigt.
- `contested=0` wurde bestätigt.

Bewertung:

- Die technische Startkette funktioniert.
- Die state-first Runtime-Grundlage ist stabil.
- Die erste modulübergreifende Kampagnenpipeline ist bestätigt.
- Das Projekt ist noch keine fertige spielbare dynamische Kampagne.
- Echte MOOSE-, CTLD- und Skynet-Ausführung sind bewusst noch nicht aktiv.

---

## 4. Hauptstruktur

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

## 5. Source-Struktur

Eigene Theater-Command-Logik liegt unter:

```text
src/
```

Aktuelle Struktur:

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

Die Struktur ist nach Aufgaben sortiert, nicht nach Frameworks.

Nicht gewünscht sind Dateien wie:

```text
tc_moose.lua
tc_mist.lua
tc_ctld.lua
tc_all_in_one.lua
```

---

## 6. Aktive Source-Dateien

Aktuell aktive eigene Lua-Dateien:

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

## 7. Vendor-Struktur

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

Regeln:

- Frameworks werden nicht verändert.
- Eigene Logik wird nicht in Framework-Dateien geschrieben.
- Frameworks werden nur geladen und später über eigene Module gekapselt genutzt.
- Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket.

Aktueller Stand:

- MIST wird geladen.
- MOOSE wird geladen.
- CTLD wird geladen.
- Skynet IADS wird geladen.
- Produktive Framework-Ausführung ist noch nicht aktiv.

---

## 8. DCS-Lade-Reihenfolge

Die externe Framework-Lade-Reihenfolge lautet:

1. `vendor/mist/mist.lua`
2. `vendor/moose/Moose.lua`
3. `vendor/ctld/CTLD-i18n.lua`
4. `vendor/ctld/CTLD.lua`
5. `vendor/skynet-iads/SkynetIADS.lua`

Danach wird die eigene Theater-Command-Logik geladen.

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

- `src/ui/tc_f10_menu.lua` wird nach `src/ai/tc_ai_cap_manager.lua` und vor `src/main.lua` geladen.
- `src/main.lua` initialisiert die Runtime-Systeme.
- `src/loader.lua` bleibt aktuell die letzte eigene Datei.

---

## 9. Starttest-Variante A

Aktuell verwendete Methode:

- Starttest-Variante A — sichere Einzeldatei-Ladung

Dabei werden alle aktiven Dateien einzeln per `DO SCRIPT FILE` geladen.

Reihenfolge:

```text
Frameworks
Core
World
Campaign
Logistics
Missions
AI
UI
Main
Loader
```

Ergebnis:

- **Bestanden**

Wichtig:

Eine per `DO SCRIPT FILE` geladene Lua-Datei wird in die `.miz` eingebettet.

Nach jeder Lua-Änderung muss die jeweilige Datei im Mission Editor erneut ausgewählt und die Mission gespeichert werden.

---

## 10. Geprüfte Logik im aktuellen DCS-Teststand

Bestätigt wurde:

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
- F10Menu geladen
- Main gestartet
- Runtime-Systeme initialisiert
- Loader beendet

Wichtige positive Log-Einträge:

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

Aktuelle Runtime-Ergebnisse:

```text
[TC] [AirbaseScanner] Loaded src/world/tc_airbase_scanner.lua v0.2.2
[TC] [ZoneFactory] Loaded src/world/tc_zone_factory.lua v0.2.0
[TC] [CaptureSystem] Loaded src/campaign/tc_capture_system.lua v0.2.2
[TC] [LogisticsDelivery] Loaded src/logistics/tc_logistics_delivery.lua v0.2.0
[TC] [FobSystem] Loaded src/logistics/tc_fob_system.lua v0.2.0
[TC] [MissionGenerator] Loaded src/missions/tc_mission_generator.lua v0.2.3
[TC] [AICapManager] Loaded src/ai/tc_ai_cap_manager.lua v0.2.0
[TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.3
[TC] [F10Menu] F10 menu initialized: commands=33
```

Bestätigte Pipeline-Logik:

```text
[TC] [F10Menu] Mission details shown through F10: slot=1 key=MISSION_2
[TC] [F10Menu] Mission activated through F10: slot=1 key=MISSION_2
[TC] [F10Menu] Active mission outcome status shown through F10
[TC] [F10Menu] Mission completed through F10: slot=1 key=MISSION_2 stateOnly=true effects=prepared
[TC] [MissionGenerator] Mission outcome prepared: MISSION_2 [COMPLETED] stateOnly=true effects=prepared
[TC] [CaptureSystem] Capture pressure added: zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE amount=105 progress=100%
[TC] [CaptureSystem] Mission effect applied to capture: mission=MISSION_2 zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE pressure=105
[TC] [CaptureSystem] Completed mission effects processed: applied=1, skipped=0, failed=0, appliedMissionEffects=1
[TC] [CaptureSystem] Capture progress updated: zones=32, ready=1, contested=0, appliedMissionEffects=1
[TC] [F10Menu] Capture ready zones shown through F10
```

Bewertung:

- Die Startarchitektur funktioniert.
- Die technische Grundlage ist stabil genug für weitere State-, UI- und Debug-Schritte.
- Die Mission Outcome to Capture Pressure Pipeline ist bestätigt.

PersistenceSystem `v0.2.6` gehört zum bestandenen Runtime-Stand: Embedded Start, normaler `20s`-/`120s`-Scheduler, `SAVED`, `SKIPPED`, kontrollierter `FAILED`-Pfad und Retry.

Bestätigte vollständige Pipeline:

```text
Mission Details -> Mission Activation -> Mission Completion -> Mission Effects
-> Capture Pressure -> Capture Progress -> Capture Ready -> Capture Ready Apply
-> Zone Ownership Update -> linked Airbase Ownership Sync -> Background Autosave
```

Zusätzlich bestätigt:

```text
Mission Activation -> FAILED -> Failure Effects prepared
-> CaptureSystem verarbeitet (applied=0) -> kein Capture Pressure -> Persistence SAVED
```

---

## 11. Aktueller getesteter Systemstand

Stand: **2026-09-12**.

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | funktional bestanden; Read-Dirty- und Ownership-No-Op-Regressionen bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | Embedded Start, SAVED, SKIPPED, FAILED, Retry und Campaign-Persistence-Regressionen bestanden; productiveRestore=false |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | funktional bestanden; Dirty-Coverage ist nächster Priority-3-Audit |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | funktional bestanden; allgemeine Dirty-Coverage offen |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | 10 Mission Records; Activation, Completion, Failure und Effects bestanden; Record-Loss widerlegt; allgemeine Dirty-Coverage offen |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | state-first bestanden; reactToActiveMissions()-Sonderfall bewertet; allgemeine Dirty-Coverage offen |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden; 33 Commands |

---

## 12. Core-Schicht

Pfad:

```text
src/core/
```

Aktuelle Dateien:

```text
src/core/tc_config.lua
src/core/tc_logger.lua
src/core/tc_state.lua
src/core/tc_utils.lua
src/core/tc_scheduler.lua
```

Aufgaben:

- zentrale Konfiguration
- Logging
- globaler Theater-Command-State
- Hilfsfunktionen
- Scheduler-Grundfunktionen
- technische Start- und Laufzeitunterstützung
- Modulstatus
- Featurestatus
- Konstanten

Regel:

- Core darf von allen Systemen genutzt werden.
- Core soll keine fachliche Kampagnenentscheidung erzwingen.

---

## 13. State-Modell

Zentraler Zustand:

```text
TC.State
TC.state
```

Aktuelle State-Bereiche:

```text
State.Core
State.Modules
State.Features
State.Bases
State.Zones
State.Campaign
State.Logistics
State.Missions
State.AI
State.UI
State.Persistence
```

Grundregeln:

- Module schreiben ihren fachlichen Zustand in den State.
- Andere Module lesen diesen Zustand über definierte Tabellen oder Funktionen.
- Framework-Ausführung wird später aus dem State abgeleitet.
- Der State soll persistierbar bleiben.
- State-first kommt vor echten Spawns.
- Mission Effects werden zuerst state-only vorbereitet.
- Mission Effects werden durch Fachsysteme verarbeitet.
- Capture Pressure und Capture Progress sind State-Daten.
- Ownership-Wechsel dürfen nicht unkontrolliert automatisch passieren.

Aktuell im State vorhanden oder vorbereitet:

- klassifizierte Airbases
- Kampagnenzonen
- Capture-Eligibility
- Capture-Pressure
- Capture-Progress
- Capture Ready
- angewendete Mission Effects
- Logistics Hubs
- FOB-Kandidaten
- geplante FOBs
- verfügbare Missionen
- aktive Missionen
- abgeschlossene Missionen
- Mission Objectives
- Mission Briefings
- Mission Progress
- Mission Activation Metadata
- Mission Outcome State
- Mission Effect State
- AI-CAP-State
- F10-UI-State

Mission-State-Invariante:

- `State.Missions.available`, `.active`, `.completed`, `.failed`, `.expired` und `.cancelled` sind String-keyed Dictionaries.
- Autoritative Zählung erfolgt mit `pairs()` bzw. pairs-basierten Helfern wie `countEntries()`/`countTableKeys()`.
- `#table` und `ipairs()` sind für diese Dictionaries nicht autoritativ.
- Echte Arrays, History-Arrays und temporär sortierte Listen sind davon nicht betroffen.

Dirty-State-Architektur:

- Zentrale Persistence-Felder liegen unter `TC.State.Persistence`: `dirty`, `dirtyReason`, `dirtyAt`.
- Fachsysteme markieren persistenzrelevante Mutationen über den zentralen State-Mechanismus (`markDirty()`).
- Reads und echte No-Ops dürfen keinen künstlichen Dirty-State erzeugen.
- Jede persistierte fachliche Mutation muss zuverlässig Dirty markieren; die allgemeine Abdeckung ist Gegenstand der offenen Priority 3 (Abschnitt 38).

---

## 14. World-Schicht

Pfad:

```text
src/world/
```

Aktuelle Dateien:

```text
src/world/tc_airbase_scanner.lua
src/world/tc_zone_factory.lua
```

Aufgaben:

- DCS-Airbases erfassen
- Airbase-like Objects klassifizieren
- Koalitionsstatus erkennen
- Positionen erfassen
- relevante virtuelle Kampagnenzonen erzeugen
- Daten für Campaign, Logistics, Missions und AI bereitstellen

Regel:

- World erkennt und klassifiziert.
- World entscheidet nicht allein über Capture oder Kampagnenfortschritt.

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

Architekturrolle:

- Grundlage für ZoneFactory
- Grundlage für CaptureSystem
- Grundlage für LogisticsDelivery
- Grundlage für MissionGenerator
- Grundlage für AICapManager
- spätere Grundlage für IADS und AI Director

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

Architekturrolle:

- übersetzt Airbase-Klassifizierung in Kampagnenzonen
- erzeugt die zentrale Raumstruktur der Kampagne
- trennt strategisch relevante und nicht relevante Objekte
- verhindert, dass alle 225 Airbase-like Objects ungefiltert als Kampagnenzonen wirken

---

## 17. Campaign-Schicht

Pfad:

```text
src/campaign/
```

Aktuelle Dateien:

```text
src/campaign/tc_capture_system.lua
src/campaign/tc_persistence_system.lua
```

Aufgaben:

- Besitzstatus verwalten
- Zonenstatus verwalten
- Capture-Zustände verwalten
- Capture-Events speichern
- Capture-Pressure verwalten
- Capture-Progress verwalten
- Mission Effects auswerten
- Kampagnenzustand vorbereiten
- Background Save unterstützen; produktiven Startup-Restore später integrieren

Regel:

- Campaign entscheidet über strategischen Besitz.
- Campaign spawnt keine DCS-Objekte direkt.
- Automatische Besitzwechsel dürfen erst nach kontrolliertem Testpfad produktiv werden.

---

## 18. CaptureSystem

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

Aufgaben:

- Ownership von Basen und Zonen verwalten
- Capture-Eligibility bestimmen
- ungeeignete Objekte ausschließen
- Linked Airbase/Zone Ownership synchronisieren
- Capture Events speichern
- Capture Pressure erzeugen
- Capture Progress erzeugen
- abgeschlossene Mission Effects state-only als Capture-Druck anwenden
- Capture Ready und Pressure Contested erkennen
- Capture Ready Zones für F10 bereitstellen

Aktuelle Architektur:

- Capture ist noch nicht automatisch produktiv.
- Capture Pressure wird state-only verarbeitet.
- Capture Progress wird state-only verarbeitet.
- Missionseffekte können vorbereitet und angewendet werden.
- Capture Ready kann dynamisch entstehen.
- Capture Ready ist über F10 sichtbar.
- Ownership-Wechsel bleiben kontrolliert.
- Kein automatischer produktiver Ownership-Wechsel ohne F10-/Debug-Bestätigung.

Am 2026-09-12 erneut bestätigt:

- Mission Completion -> Capture Pressure.
- Mission Failure -> CaptureSystem verarbeitet mit `applied=0`, kein Capture Pressure.
- Capture Ready Apply -> Zone Ownership Update -> linked Airbase Ownership Sync.
- Apply auf `ZONE_AIRBASE_ABU_AL_DUHUR`: `RED -> BLUE`, danach `zoneOwner=BLUE`, `previousOwner=RED`, `baseOwner=BLUE`, `progress=0`, `status=STABLE`, `captureReady=false`.

Capture Dirty Regression nach Fix: Die unveränderten Read-/Derived-Abfragen `getCaptureReadyZones`, `getPressureContestedZones`, `getPressureSummary`, `getCaptureEligibleBases`, `getCaptureEligibleZones`, `getEligibilitySummary` und `getCaptureProgress` liefern jeweils `dirty=false`, `reason=nil`. Eine echte Pressure-Mutation setzt weiterhin `dirty=true`, `reason=capture_pressure_set`.

Ownership-No-Op nach Fix: `setZoneOwner(zone,currentOwner,...)` bzw. der entsprechende `setBaseOwner()`-Pfad verändert bei identischem Owner keinen persistierten State. Es gibt keinen unnötigen Timestamp-/Progress-/Counter-Write, keinen World-Sync, kein Event und kein Dirty (`dirty=false`, `reason=nil`). Historische Owner-Information bleibt erhalten.

Architekturregel: Reads und fachliche No-Ops dürfen keine Persistence-Arbeit erzwingen.

---

## 19. PersistenceSystem

Datei: `src/campaign/tc_persistence_system.lua`, getestete Version: `v0.2.6`.

Persistence ist ein internes Hintergrundsystem mit dirty-aware Autosave, kein Spieler-F10-Workflow. Background Save ist real aktiv und getestet; `productiveRestore=false`.

Bestanden:

- DCS-Dateisystemzugriff, Save, Read-back, Compile, Evaluate und Validation.
- Kontrollierter Import ist technisch möglich.
- Embedded Start mit `initialDelay=20s`, `interval=120s`.
- `SAVED`, `SKIPPED`, kontrollierter `FAILED`-Pfad und Retry.

Save-Sicherheitsinvariante:

```text
Write -> Read-back -> Compile -> Evaluate -> Validation -> Dirty löschen
```

Bei Fehler bleibt Dirty erhalten. Ein während eines laufenden Saves neu entstandener Dirty-State darf nicht durch den Abschluss eines älteren Saves gelöscht werden.

Campaign-Persistence-Regressionen vom 2026-09-12:

| Fachlicher Pfad | Ergebnis | dirtyReason | dirtyCleared |
|---|---|---|---|
| Mission Completion | `SAVED` | `f10_active_mission_1_completed` | `true` |
| Mission Failure | `SAVED` | `f10_active_mission_1_failed` | `true` |
| Capture Ready Apply | `SAVED` | `f10_capture_ready_zone_1_applied` | `true` |

In allen Fällen blieb `productiveRestore=false`. Technische Importfähigkeit ist keine Freigabe für produktiven Startup-Restore; Voraussetzungen stehen in Abschnitt 30.

---

## 20. Logistics-Schicht

Pfad:

```text
src/logistics/
```

Aktuelle Dateien:

```text
src/logistics/tc_logistics_delivery.lua
src/logistics/tc_fob_system.lua
```

Aufgaben:

- Logistics Hubs aus Kampagnenzonen erzeugen
- Supply-/Fuel-/Ammo-/Engineering-Zustände vorbereiten
- Deliveries vorbereiten
- FOB-Kandidaten erzeugen
- FOBs state-only planen
- spätere CTLD-Anbindung vorbereiten

Regel:

- Logistics entscheidet nicht allein über Besitz.
- Logistics beeinflusst Campaign, Missions und AI über Zustandsdaten.

---

## 21. LogisticsDelivery

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

Aktuelle Architektur:

- Logistics Hubs sind State-only.
- CTLD wird noch nicht aktiv aufgerufen.
- Keine echten Cargo-Flüge.
- Keine echten Dropoffs.
- Keine echten Supply-Verbräuche.
- Mission Effects wirken noch nicht produktiv auf Logistics.

LogisticsDelivery ist funktional bestanden. Die allgemeine Dirty-Coverage dieses Moduls wurde noch nicht systematisch auditiert und ist der nächste Priority-3-Schritt: zunächst READ ONLY, kein Code-Fix ohne konkreten Befund. Aus dem offenen Audit wird kein Missing-Dirty-Bug abgeleitet.

---

## 22. FobSystem

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

Aktuelle Architektur:

- FOBs sind State-only.
- Es werden noch keine CTLD-FOBs erzeugt.
- Baufortschritt wird noch nicht durch echte Cargo-Lieferungen beeinflusst.
- FOBs können bereits vom MissionGenerator für FOB-Support genutzt werden.

Es werden keine echten Crates erzeugt. Die allgemeine FOB-Dirty-Coverage bleibt offen; daraus allein folgt kein konkreter Missing-Dirty-Bug.

---

## 23. Missions-Schicht

Pfad:

```text
src/missions/
```

Aktuelle Datei:

```text
src/missions/tc_mission_generator.lua
```

Regel:

- Missions erzeugt Aufträge aus State-Daten.
- Missions verändert strategischen Besitz nicht direkt.
- Missionsergebnisse liefern Effects für Empfängersysteme; Logistics-, AI- und IADS-Verarbeitung sind noch nicht produktiv angebunden.
- Der erste bestätigte Empfänger ist CaptureSystem.

---

## 24. MissionGenerator

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

Aktuelle Missionstypen:

- `RECON`
- `STRIKE`
- `SEAD`
- `DEAD`
- `CAS`
- `INTERDICTION`
- `ESCORT`
- `CAP`
- `LOGISTICS`
- `FOB_SUPPORT`
- `AIRBASE_ATTACK`
- `IADS_SUPPRESSION`

Aktuelle Mission Records enthalten:

- ID
- Key
- Name
- Type
- Status
- Owner
- Source Base
- Target Zone
- Target Base
- Target FOB
- Priority
- Strategic Relevance
- Objective
- Briefing
- Recommended Aircraft
- Recommended Payload
- Progress
- Activation Metadata
- Outcome State
- Effect State
- Execution Plan
- Effects
- reserved MOOSE hook
- reserved CTLD hook
- reserved Skynet hook

Aktuelle Architektur:

- Missionen sind State-only.
- Aktivierung setzt Missionen auf `ACTIVE`.
- Aktivierung triggert keine echten Spawns.
- Spawn-Hooks bleiben reserviert.
- Missionen können auf `COMPLETED` gesetzt werden.
- Mission Completion bereitet Mission Effects vor.
- CaptureSystem kann abgeschlossene Mission Effects verarbeiten.
- Die Statuswechsel `AVAILABLE -> ACTIVE`, `ACTIVE -> COMPLETED` und `ACTIVE -> FAILED` sind praktisch bestätigt.
- Completion -> Capture Pressure und Failure -> kein Capture Pressure sind bestätigt.
- Mission-State-Collections sind String-keyed Dictionaries; der Record-Loss-Verdacht ist widerlegt (siehe Kopf und Abschnitt 13).
- Completion und Failure mit Dirty/`SAVED` sind bestätigt; dies ist keine vollständig auditierte allgemeine MissionGenerator-Dirty-Coverage.

Noch offen:

- `CANCELLED` und `EXPIRED` praktisch testen.
- automatische DCS-Event-Auswertung.
- allgemeine MissionGenerator-Dirty-Coverage.
- Effects auf Logistics/AI/IADS.
- echte Framework-Ausführung; MOOSE-/CTLD-/Skynet-Hooks bleiben reserviert.

---

## 25. AI-Schicht

Pfad:

```text
src/ai/
```

Aktive Datei:

```text
src/ai/tc_ai_cap_manager.lua
```

Geplante spätere Dateien:

```text
src/ai/tc_ai_director.lua
src/ai/tc_ai_gci_manager.lua
src/ai/tc_ai_counterattack.lua
```

Regel:

- AI reagiert auf den Kampagnenzustand.
- AI darf später MOOSE für reale Spawns nutzen.
- AI trifft keine strategischen Besitzentscheidungen allein.

---

## 26. AICapManager

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

Aktuelle Architektur:

- CAP ist State-only.
- MOOSE wird noch nicht produktiv genutzt.
- `spawn=MOOSE_PENDING` ist erwartetes Verhalten.

`reactToActiveMissions(options)` wurde READ-ONLY auditiert. Es gibt aktuell keine produktive Call-Site: weder `start()`, Scheduler/Timer, `main.lua`, `loader.lua`, F10 noch andere produktive `src/`-Pfade rufen die Funktion auf.

Bei späterer Verdrahtung könnten im `requested==0`-Pfad `reactionState`, `threatLevel`, `capStatistics` und `lastUpdate` verändert werden, ohne zwingenden eigenen Dirty-Call. Klassifikation: latenter Missing-Dirty-Fall in derzeit nicht verdrahtetem Code, aktuell kein Runtime-Persistence-Bug. Jetzt kein Fix; bei späterer Verdrahtung erneut prüfen.

Die allgemeine AICapManager-Dirty-Coverage bleibt offen.

---

## 27. IADS-Schicht

Pfad:

```text
src/iads/
```

Aktueller Stand:

- Vendor geladen.
- Eigenes Theater-Command-IADS-Modul noch nicht aktiv implementiert.

Geplante Module:

```text
src/iads/tc_iads_system.lua
src/iads/tc_iads_network.lua
src/iads/tc_iads_sector_manager.lua
src/iads/tc_iads_site_registry.lua
src/iads/tc_iads_mission_bridge.lua
```

Aufgaben:

- Skynet-IADS-Anbindung kapseln
- IADS-Netzwerke vorbereiten
- IADS-Sektoren definieren
- SAM-Standorte verwalten
- Radar-Standorte verwalten
- IADS-Zustand im Kampagnen-State speichern
- IADS-Zustand mit MissionGenerator verbinden
- SEAD- und DEAD-Ziele vorbereiten

Regel:

- Skynet IADS bleibt Framework.
- Theater Command bewertet und speichert den Kampagnenzustand darüber.

Aktueller Stand:

- MissionGenerator reserviert bereits Skynet-Hooks.
- Keine echte IADS-Kampagnenlogik aktiv.

---

## 28. UI-Schicht

Pfad:

```text
src/ui/
```

Aktive Datei:

```text
src/ui/tc_f10_menu.lua
```

Getestete Version:

```text
v0.2.3
```

Status:

- bestanden; 33 Commands

Aufgaben:

- F10-Menüs bereitstellen
- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Mission 1 bis Mission 10 Details anzeigen
- Mission 1 bis Mission 10 aktivieren
- Mission Outcome Controls bereitstellen
- Kampagnenstatus anzeigen
- Capture Status anzeigen
- Capture Ready Zones anzeigen
- Pressure Contested Zones anzeigen
- Logistikstatus anzeigen
- FOB-Status anzeigen
- AI-CAP-Status anzeigen

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
    │   ├── Apply Capture Ready Zone 1
    │   └── Show Pressure Contested Zones
    ├── Logistics
    │   ├── Show Logistics Status
    │   └── Show FOB Status
    └── AI
        └── Show AI CAP Status
```

Regel:

- UI zeigt Daten und nimmt Spielerkommandos entgegen.
- UI entscheidet nicht selbst über Kampagnenlogik.
- UI triggert aktuell keine echten Spawns.
- UI triggert keine CTLD-Aktion.
- UI triggert keine Skynet-Aktion.
- UI ruft sichere State-Funktionen auf.

`Apply Capture Ready Zone 1` ist implementiert und bestanden. Mission Details und Activation 1–10, Active Mission Outcome Status, Complete/Fail Active Mission 1 sowie die aufgeführten Campaign-/Capture-/Logistics-/FOB-/AI-Statusfunktionen sind bestätigt. UI ruft kontrollierte State-Funktionen auf, führt aber keine direkte MOOSE-/CTLD-/Skynet-Ausführung aus.

---

## 29. Debug-Schicht

Pfad:

```text
src/debug/
```

Aktueller Stand:

- Dokumentiert, noch nicht aktiv implementiert.

Geplante Module:

```text
src/debug/tc_debug_console.lua
src/debug/tc_debug_state_dump.lua
src/debug/tc_debug_zone_overlay.lua
src/debug/tc_debug_airbase_report.lua
src/debug/tc_debug_mission_report.lua
src/debug/tc_debug_logistics_report.lua
src/debug/tc_debug_ai_report.lua
src/debug/tc_debug_iads_report.lua
```

Aufgaben:

- Debug-Ausgaben bündeln
- State-Dumps erzeugen
- Airbase-Reports erzeugen
- Zonen-Reports erzeugen
- Capture-Reports erzeugen
- Logistik-Reports erzeugen
- Missions-Reports erzeugen
- AI-Reports erzeugen
- IADS-Reports erzeugen

Regel:

- Debug macht Daten sichtbar.
- Debug ersetzt keine produktive Kampagnenlogik.
- Debug darf keine produktiven Aktionen versteckt auslösen.

---

## 30. Persistenz-Architektur

Aktive Datei: `src/campaign/tc_persistence_system.lua`, Version `v0.2.6`.

Persistence beobachtet und serialisiert Kampagnen-State als Querschnittssystem. Save/Read-back/Compile/Evaluate/Validation, kontrollierter Import und dirty-aware Background Autosave sind technisch bestanden (Abschnitt 19). Die Save-Datei ist eine Lua-Return-Datei; persistierter State muss ohne Funktionen, Userdata oder zyklische Tabellen serialisierbar bleiben. Die Sandbox ist geprüft: Persistence benötigt direkt `io` und `lfs`.

Background Save sichert die getesteten fachlichen State-Änderungen automatisch. Das ersetzt weder die noch offene vollständige Dirty-Coverage noch produktiven Startup-Restore. Es gibt keine automatische Kampagnenfortsetzung aus einem Save beim Missionstart; `productiveRestore=false`.

Bereits erfüllte Restore-Vorarbeiten: Embedded Start von `v0.2.6`, normaler Scheduler, `SAVED`, `SKIPPED`, `FAILED`, Retry sowie Mission-Completion-, Mission-Failure- und Capture-Ready-Apply-Regressionen.

Vor Freigabe von produktivem Restore noch erforderlich:

1. Priority 3 allgemeine Dirty-Coverage abschließen.
2. Restore-/Initialisierungsreihenfolge definieren.
3. Save-Kompatibilitäts-/Versionsstrategie festlegen.
4. Einen separaten kontrollierten produktiven Restore-Test durchführen.
5. Sicherstellen, dass Framework-Hooks beim Restore keine unbeabsichtigten Aktionen auslösen.

Die Save-Invarianten aus Abschnitt 19 gelten unverändert: Dirty erst nach erfolgreicher vollständiger Verifikation löschen; bei Fehler erhalten; neuen Dirty-State nicht durch einen älteren Save-Abschluss löschen.

---

## 31. Mission-Editor-Architektur

Aktuelle DEV-Mission:

```text
Operation_Levant_Reclamation_DEV.miz
```

Aktueller Inhalt:

- Map: Syria
- Koalitionspreset: Modern
- Blue Start: Akrotiri / Zypern
- erster blauer Client-Slot: F/A-18C Lot 20 auf Akrotiri
- Trigger: Starttest-Variante A vollständig angelegt
- Vendor-Frameworks geladen
- Theater-Command-Source-Dateien geladen
- F10-Menü aktiv
- keine produktive rote Frontlinie
- keine produktiven IADS-Stellungen
- keine produktiven CTLD-Zonen
- keine produktiven Template-Gruppen
- keine echten MOOSE-Spawns
- keine echten CTLD-FOBs
- kein produktiver Startup-Restore

Regel:

- Der Mission Editor bleibt schlank.
- Große dynamische Logik gehört nach Lua.
- Der Mission Editor liefert Bühne, Slots, Templates, Zonen und statische Objekte.

Bestätigter Stand vom 2026-09-12: PersistenceSystem `v0.2.6` ist eingebettet, dirty-aware Background Autosave aktiv; F10Menu `v0.2.3` bietet 33 Commands. Capture Ready Apply ist testbar und bestanden. Es gibt noch keine automatische Kampagnenfortsetzung aus einem Save beim Missionstart.

---

## 32. Loader-only-Architektur

Noch nicht getestet:

- Starttest-Variante B — Loader-only mit `dofile`

Ziel:

- Frameworks im Mission Editor laden
- nur `src/loader.lua` laden
- prüfen, ob `src/loader.lua` weitere Source-Dateien per `dofile` nachladen kann
- DCS-Sandbox-Verhalten bewerten
- spätere Deployment-Strategie entscheiden

Mögliche Ergebnisse:

- Loader-only funktioniert
- Einzeldatei-Ladung bleibt für Entwicklung notwendig
- spätere Build-Datei wird benötigt
- DCS-Sandbox muss gezielt berücksichtigt werden

Diese Entscheidung wird erst nach einem praktischen Test getroffen.

---

## 33. Abhängigkeitsregeln

Grundregel: Fachliche Verantwortlichkeiten bleiben getrennt; gemeinsame Grundlagen sollen keine Abhängigkeit von höherer Fachlogik erhalten.

Grobe Schichtung, keine harte lineare technische Dependency-Kette:

```text
Core -> World -> Campaign -> Logistics -> Missions -> AI -> IADS -> UI -> Debug
```

Praktische Regeln:

- Core darf von allen genutzt werden.
- World liefert DCS-Weltdaten.
- Campaign verwaltet strategischen Zustand.
- Logistics liefert Versorgungszustände.
- Missions erzeugt Aufträge aus State-Daten.
- AI reagiert auf State-Daten.
- IADS liefert Luftverteidigungszustände.
- UI macht State sichtbar und löst sichere State-Aktionen aus.
- Debug macht State sichtbar.
- Framework-Ausführung erfolgt später über eigene Fachmodule.

Wichtige Ausnahme:

- UI darf sichere Funktionen aus Campaign und Missions aufrufen.
- Diese Funktionen müssen state-only oder klar kontrolliert sein.
- UI darf keine direkte Framework-Ausführung verstecken.

Reale Modulbeziehungen:

- Fachmodule interagieren über gemeinsamen State und definierte APIs.
- MissionGenerator liefert Outcome/Effects an Empfängersysteme; CaptureSystem verarbeitet Capture Effects.
- UI darf kontrollierte Campaign-/Mission-Funktionen aufrufen.
- Persistence beobachtet/serialisiert State als Querschnittssystem und ist keine fachlich höhere Schicht.
- Vendor Frameworks sind Werkzeuge außerhalb dieser fachlichen Layerordnung.

---

## 34. Aktuelle modulübergreifende Pipeline

Aktuell bestätigt:

```text
Mission Details
Mission Activation
Mission Completion
Mission Effect Preparation
CaptureSystem Effect Processing
Capture Pressure Update
Capture Progress Update
Capture Ready Detection
F10 Capture Ready Visibility
Capture Ready Apply
Zone Ownership Update
Linked Airbase Ownership Sync
Background Autosave
```

Bestätigter Testfall:

```text
MISSION_2 -> ZONE_AIRBASE_ABU_AL_DUHUR -> BLUE pressure 105 -> progress 100% -> ready=1
```

Architekturbedeutung:

- Das ist der erste bestätigte Kampagnenzusammenhang über mehrere Module hinweg.
- MissionGenerator erzeugt einen Effekt.
- CaptureSystem verarbeitet diesen Effekt.
- F10Menu macht das Ergebnis sichtbar.
- Die fachlichen Mission-/Capture-Aktionen bleiben state-only; Background Autosave sichert den State im Dateisystem.
- Keine echte Framework-Aktion wird ausgelöst.

Zusätzlich bestätigter Failure-Pfad:

```text
Mission Activation
Mission Failure
Failure Effects prepared
CaptureSystem applied=0
kein Capture Pressure
Background Autosave
```

MissionGenerator erzeugt Outcome/Effects, CaptureSystem verarbeitet Capture-Wirkungen, UI stellt den kontrollierten Test-/Spielerzugang bereit und Persistence sichert fachliche State-Änderungen. Die Verantwortlichkeiten bleiben getrennt; state-only bezieht sich auf die fachlichen Aktionen, Background Save schreibt tatsächlich Dateien.

---

## 35. Aktuell nicht verbunden

Bereits verbunden und bestätigt:

- Mission Failure zu CaptureSystem mit `applied=0`, ohne Capture Pressure.
- Capture Ready zu kontrolliertem Ownership-Wechsel.
- Zone/Airbase Ownership Sync.
- Background Persistence für die getesteten State-Änderungen.

Weiterhin nicht produktiv verbunden:

- Mission Effects zu Logistics.
- Mission Effects zu AI.
- Mission Effects zu IADS.
- CTLD zu Logistics/FOB.
- MOOSE zu CAP/Mission Packages.
- Skynet zu produktivem IADS-State.
- AI Director zu Gesamtstrategie.
- produktiver Startup-Restore.
- autonome Kampagnenoperationen.

---

## 36. Framework-Integrationsstrategie

Theater Command nutzt Frameworks nicht direkt als Architekturordnung.

Frameworks sind Werkzeuge.

Eigene Logik bleibt fachlich sortiert.

Geplante Zuordnung:

| Funktion | Framework |
|---|---|
| Airbase/Utility/DB/Events | MIST nach Bedarf |
| CAP/Strike/SEAD/DEAD/CAS | MOOSE |
| Cargo/Transport/FOB | CTLD |
| IADS/SAM/EWR | Skynet IADS |
| Kampagnenlogik | eigene Lua-Module |
| State/Persistence | eigene Lua-Module |
| F10/UI | native DCS-Funktionen und eigene Lua-Module |

Aktueller Stand:

- Frameworks sind geladen.
- Produktive Ausführung folgt später.
- State-Systeme werden zuerst stabilisiert.
- Keine echten Framework-Aktionen ohne vorherige Templates, Zonen und Testpfade.

---

## 37. Sicherheitsprinzip der aktuellen Runtime

Aktuell gilt:

- keine echten MOOSE-Spawns
- keine echte CTLD-Aktion
- keine echte Skynet-Aktion
- kein produktiver Startup-Restore
- keine unkontrollierten Ownership-Wechsel
- keine automatischen Kampagnenfolgen ohne Test
- keine Änderung an Vendor-Dateien
- keine All-in-one-Dateien

Grund:

- DCS-Missionen sind schwer zu debuggen.
- Jede Schicht muss einzeln stabil sein.
- State muss sichtbar und testbar sein.
- Framework-Ausführung wird erst später aktiviert.
- Die getesteten Ownership-Wechsel sind kontrolliert und werden im Hintergrund gespeichert; autonome AI-Director-Operationen bleiben ein späterer Schritt.

Background Persistence ist aktiv und getestet. Weiterhin ausgeschlossen sind automatische Framework-Ausführung durch Restore und versteckte produktive Aktionen in UI/Debug. Vendor-Dateien bleiben unverändert.

---

## 38. Nächster architektonischer Schritt

Priority 3 (Dirty-Coverage) ist **nicht abgeschlossen**.

Bereits geklärt:

- Capture Getter-/Derived-Dirty.
- Capture Ownership No-Op.
- `reactToActiveMissions()`-Sonderfall in derzeit nicht verdrahtetem Code.

Noch systematisch zu prüfen, jeweils ein Modul pro Schritt:

1. `src/logistics/tc_logistics_delivery.lua`
2. `src/logistics/tc_fob_system.lua`
3. `src/missions/tc_mission_generator.lua`
4. `src/ai/tc_ai_cap_manager.lua`

Architekturziel: Jede persistierte fachliche Mutation muss zuverlässig Dirty markieren. Reads und echte No-Ops sollen keinen unnötigen Dirty-State erzeugen.

Nächster einzelner technischer/architektonischer Schritt: **READ-ONLY Dirty-Coverage-Audit von `src/logistics/tc_logistics_delivery.lua`**.

Audit-Ziele:

- alle persistierten Logistics-State-Writes identifizieren.
- alle `markDirty()`-Pfade identifizieren.
- Call-Sites erfassen.
- echte Mutationen auf Dirty-Coverage prüfen.
- Reads/No-Ops auf unnötiges Dirty prüfen.
- Dirty Reasons bewerten.
- runtime-only und persistierten State unterscheiden.
- keine Codeänderung ohne belegten Befund.

Zunächst ist keine Mission-Editor-Änderung erforderlich. FOB, MissionGenerator und AI werden nicht parallel auditiert. Der Audit ist der nächste technische Schritt; diese Dokumentationssynchronisierung führt ihn nicht vorweg.

---

## 39. Architekturabschlussstand

Stand: **2026-09-12**.

| System | Version | Status |
|---|---:|---|
| Airbase Scanner | `v0.2.2` | bestanden |
| ZoneFactory | `v0.2.0` | bestanden |
| CaptureSystem | `v0.2.2` | funktional bestanden; Read-Dirty- und Ownership-No-Op-Regressionen bestanden |
| PersistenceSystem | `v0.2.6` | Embedded Start, SAVED, SKIPPED, FAILED, Retry und Campaign-Persistence-Regressionen bestanden; productiveRestore=false |
| LogisticsDelivery | `v0.2.0` | funktional bestanden; Dirty-Coverage ist nächster Priority-3-Audit |
| FobSystem | `v0.2.0` | funktional bestanden; allgemeine Dirty-Coverage offen |
| MissionGenerator | `v0.2.3` | 10 Mission Records; Activation, Completion, Failure und Effects bestanden; Record-Loss widerlegt; allgemeine Dirty-Coverage offen |
| AICapManager | `v0.2.0` | state-first bestanden; reactToActiveMissions()-Sonderfall bewertet; allgemeine Dirty-Coverage offen |
| F10Menu | `v0.2.3` | bestanden; 33 Commands |

Die state-first Architektur ist tragfähig. Mission/Capture/Persistence-Kernpfade sind bestätigt, der Record-Loss-Verdacht ist widerlegt und aktive Embedded Drift als Ursache ausgeschlossen. Priority 3 bleibt offen. Produktiver Restore und produktive Framework-Ausführung bleiben deaktiviert.

Nächster technischer Einzelschritt: LogisticsDelivery Dirty-Coverage READ ONLY in `src/logistics/tc_logistics_delivery.lua`.
