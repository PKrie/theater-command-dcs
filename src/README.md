# src/README.md

## Autoritativer Source-Stand — 2026-08-04

- Aktive Versionen: AirbaseScanner `v0.2.2`, ZoneFactory `v0.2.0`, CaptureSystem `v0.2.2`, PersistenceSystem `v0.2.6`, LogisticsDelivery `v0.2.0`, FobSystem `v0.2.0`, MissionGenerator `v0.2.3`, AICapManager `v0.2.0`, F10Menu `v0.2.3`, Loader `v0.1.0`.
- Persistence `v0.2.6` läuft dirty-aware mit `SAVED`/`SKIPPED`/`FAILED`; Embedded-Start und echte 20-/120-Sekunden-Scheduler-Ticks sind bestanden. Produktiver Restore bleibt deaktiviert.
- F10Menu hat 33 Befehle und keine Persistence-Steuerung.
- MissionGenerator erzeugte in zwei normalen Läufen zunächst zehn Missionen; später waren alle sechs Status-Dictionaries leer. Ursache und Writer sind unbekannt. Statische Klassifikation: `PROJECT SOURCE HAS NO MATCHING WRITE SITE`.
- Nächster Schritt ist der strikt read-only Offline-Audit der 13 in `TASKS.md` genannten eingebetteten `.miz`-Ressourcen. Mission-/Capture-Regressionen bleiben bis dahin blockiert.

Alle abweichenden Versions-, Befehls- oder Fertigkeitsaussagen in den folgenden älteren Abschnitten sind historische Entwicklungsstände, keine aktuelle Freigabe.

---

Diese Datei beschreibt die eigene Lua-Source-Struktur von **Theater Command DCS**.

Externe Frameworks liegen unter `vendor/`.

Eigene Kampagnenlogik liegt unter `src/`.

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
- Blue und Red sollen später eigene Operationen durchführen

---

## 1. Grundsatz

Theater Command DCS folgt dem Prinzip:

```text
Mission Editor = Bühne
Lua = Kampagnensystem
GitHub = Projektgedächtnis
```

Der Ordner `src/` enthält ausschließlich eigene Theater-Command-Logik.

Frameworks werden nicht in `src/` abgelegt.

Frameworks werden nicht verändert.

Eigene Lua-Logik wird nach Aufgabenbereichen sortiert, nicht nach Frameworks.

---

## 2. Architekturregel

Nicht gewünscht:

```text
tc_moose.lua
tc_mist.lua
tc_ctld.lua
tc_all_in_one.lua
tc_skynet.lua
tc_frameworks.lua
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

Grund:

Theater Command soll fachlich modular bleiben.

MOOSE, MIST, CTLD und Skynet IADS sind Werkzeuge.

Die Kampagnenlogik gehört in eigene Module.

---

## 3. Aktueller Stand

Historischer Stand: **2026-07-06**

Aktueller Gesamtstatus:

- **State-first Runtime-Grundlage stabil getestet**
- **Mission Outcome to Capture Pressure Pipeline bestanden**
- **Capture Ready über F10 sichtbar bestätigt**

Das Projekt ist noch keine fertige dynamische Kampagne.

Die eigene Lua-Runtime startet aber inzwischen sauber im DCS Mission Scripting Environment und besitzt eine bestätigte modulübergreifende Kampagnenkette.

Bestätigt:

- Core-Dateien laden.
- World-Dateien laden.
- Campaign-Dateien laden.
- Logistics-Dateien laden.
- Missions-Dateien laden.
- AI-Dateien laden.
- UI-Datei lädt.
- Main startet.
- Loader beendet sauber.
- F10-Menü ist sichtbar.
- Missionen können über F10 angezeigt werden.
- Missionen können über F10 aktiviert werden.
- aktive Mission 1 kann über F10 auf `COMPLETED` gesetzt werden.
- Mission Effects werden state-only vorbereitet.
- CaptureSystem verarbeitet abgeschlossene Mission Effects.
- Capture Pressure wird durch Mission Completion erzeugt.
- Capture Progress wird durch Mission Completion aktualisiert.
- Capture Ready entsteht dynamisch.
- Capture Ready Zones sind über F10 sichtbar.
- Logistics Hubs werden erzeugt.
- FOBs werden state-only erzeugt.
- AI-CAP-State wird erzeugt.

Noch nicht produktiv:

- echte MOOSE-Spawns
- echte CTLD-Aktionen
- echte CTLD-FOBs
- echte Skynet-IADS-Kampagnenlogik
- produktive Persistenz
- AI Director
- automatische Missionserfolgsauswertung
- automatische Capture-Auswertung aus Missionsergebnissen
- kontrollierter produktiver Ownership-Wechsel aus Capture Ready
- automatische `.miz`-Generierung

---

## 4. Aktuelle Ordnerstruktur

Aktuelle Source-Struktur:

```text
src/
├── README.md
├── loader.lua
├── main.lua
├── core/
│   ├── README.md
│   ├── tc_config.lua
│   ├── tc_logger.lua
│   ├── tc_state.lua
│   ├── tc_utils.lua
│   └── tc_scheduler.lua
├── world/
│   ├── README.md
│   ├── tc_airbase_scanner.lua
│   └── tc_zone_factory.lua
├── campaign/
│   ├── README.md
│   ├── tc_capture_system.lua
│   └── tc_persistence_system.lua
├── logistics/
│   ├── README.md
│   ├── tc_logistics_delivery.lua
│   └── tc_fob_system.lua
├── missions/
│   ├── README.md
│   └── tc_mission_generator.lua
├── ai/
│   ├── README.md
│   └── tc_ai_cap_manager.lua
├── iads/
│   └── README.md
├── ui/
│   ├── README.md
│   └── tc_f10_menu.lua
└── debug/
    └── README.md
```

---

## 5. Aktive Lua-Dateien

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

Wichtige Korrektur gegenüber älteren Dokumentationsständen:

- `src/ui/` ist aktiv.
- `src/ui/tc_f10_menu.lua` ist geladen, sichtbar, navigierbar und getestet.
- `src/campaign/tc_capture_system.lua` ist inzwischen `v0.2.2`.
- `src/missions/tc_mission_generator.lua` ist inzwischen `v0.2.3`.
- `src/ui/tc_f10_menu.lua` ist inzwischen `v0.2.2`.

---

## 6. Aktuelle Ladefolge

Die aktuelle DEV-Mission nutzt weiterhin sichere Einzeldatei-Ladung über `DO SCRIPT FILE`.

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
- Loader-only per `dofile` ist noch nicht praktisch getestet.

---

## 7. Aktueller getesteter Systemstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | Embedded-Scheduler bestanden; Restore deaktiviert |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | historische Pfade bestanden; aktueller Record-Verlust ungelöst |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | 33 Befehle; bestanden |

---

## 8. Core

Pfad:

```text
src/core/
```

Aktive Dateien:

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
- globaler State
- Utility-Funktionen
- Scheduler-Grundfunktionen
- Modulstatus
- Featurestatus
- gemeinsame Konstanten

Regel:

Core stellt Infrastruktur bereit.

Core soll keine fachlichen Kampagnenentscheidungen treffen.

---

## 9. World

Pfad:

```text
src/world/
```

Aktive Dateien:

```text
src/world/tc_airbase_scanner.lua
src/world/tc_zone_factory.lua
```

Aufgaben:

- DCS-Airbase-Daten erfassen
- Airbase-like Objects klassifizieren
- relevante Kampagnenobjekte erkennen
- virtuelle Kampagnenzonen erzeugen
- World-State für andere Module bereitstellen

Aktueller getesteter Stand:

```text
Airbase Scanner: v0.2.2
ZoneFactory: v0.2.0
```

Bestätigte Werte:

```text
Syria airbase-like objects: 225
relevante Kampagnenzonen: 46
captureCandidates: 32
missionCandidates: 32
logisticsCandidates: 46
skipped airbase-like objects: 179
```

Bewertung:

World Layer ist für den aktuellen state-first Stand bestanden.

Die Filterung von 225 Airbase-like Objects auf 46 relevante Kampagnenzonen ist korrekt und gewollt.

---

## 10. Campaign

Pfad:

```text
src/campaign/
```

Aktive Dateien:

```text
src/campaign/tc_capture_system.lua
src/campaign/tc_persistence_system.lua
```

Aufgaben:

- strategischen Kampagnenzustand verwalten
- Ownership verwalten
- Capture-Eligibility verwalten
- Capture-Pressure verwalten
- Capture-Progress verwalten
- Mission Effects verarbeiten
- Capture Ready erzeugen
- Persistenz vorbereiten

Aktueller getesteter Stand:

```text
CaptureSystem: v0.2.2
PersistenceSystem: v0.2.6, dirty-aware Embedded-Scheduler bestanden
```

Bestätigte Capture-Startwerte:

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

Bestätigte Werte nach Mission Completion:

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

Bewertung:

CaptureSystem arbeitet nicht auf allen 225 DCS-Airbase-like Objects.

CaptureSystem arbeitet auf 32 fachlich geeigneten Capture-Zielen.

32 Pressure-Records und 32 Progress-Records werden erzeugt.

Mission Completion kann Capture Pressure erzeugen.

Capture Ready kann dynamisch entstehen.

Capture Ready ist über F10 sichtbar.

PersistenceSystem schreibt und verifiziert Save-Dateien automatisch; unveränderte Ticks werden ohne Schreibzugriff übersprungen. Produktiver Restore bleibt deaktiviert.

---

## 11. Logistics

Pfad:

```text
src/logistics/
```

Aktive Dateien:

```text
src/logistics/tc_logistics_delivery.lua
src/logistics/tc_fob_system.lua
```

Aufgaben:

- Logistics Hubs erzeugen
- Supply-/Fuel-/Ammo-/Engineering-State vorbereiten
- Deliveries vorbereiten
- FOB-Kandidaten ableiten
- Blue-FOBs state-only planen
- spätere CTLD-Integration vorbereiten

Aktueller getesteter Stand:

```text
LogisticsDelivery: v0.2.0
FobSystem: v0.2.0
```

Bestätigte Logistics-Werte:

```text
logistics hubs: 46
blue hubs: 7
red hubs: 24
neutral hubs: 15
active hubs: 31
limited hubs: 15
locked hubs: 0
```

Bestätigte FOB-Werte:

```text
FOB candidates: 6
stored candidates: 6
auto-planned FOBs: 2
skipped candidates: 4
Blue FOBs: 2
```

Erzeugte Blue-FOBs:

```text
FOB Ercan
FOB Gecitkale
```

Status:

```text
UNDER_CONSTRUCTION
```

Bewertung:

Logistics und FOBs sind state-first bestanden.

CTLD ist geladen, aber noch nicht produktiv angebunden.

---

## 12. Missions

Pfad:

```text
src/missions/
```

Aktive Datei:

```text
src/missions/tc_mission_generator.lua
```

Aufgaben:

- Missionen aus Kampagnenzustand erzeugen
- Missionen priorisieren
- Missionen im State speichern
- FOB-Support berücksichtigen
- Mission Records fachlich anreichern
- Mission Activation vorbereiten
- Mission Outcome vorbereiten
- Mission Effects vorbereiten
- MOOSE-/CTLD-/Skynet-Hooks reservieren

Aktueller getesteter Stand:

```text
MissionGenerator: v0.2.3
```

Bestätigte Werte:

```text
mission candidates: 78
fobSupportCandidates: 2
generated missions: 10
reservedCreated: 1
duplicatesSkipped: 1
typeLimitSkipped: 68
```

Aktuelle Mission Records enthalten:

- ID
- Key
- Name
- Type
- Status
- Owner
- Target Zone
- Target Base
- Target FOB
- Priority
- Strategic Relevance
- Objective
- Briefing
- Progress
- Activation Metadata
- Outcome State
- Effect State
- Execution Plan
- Effects
- reserved MOOSE hook
- reserved CTLD hook
- reserved Skynet hook

Bewertung:

MissionGenerator hat historisch bestandene Funktionspfade; der aktuelle Record-Verlust ist ungelöst.

Missionen können über F10 direkt ausgewählt, aktiviert und abgeschlossen werden.

Missionen bleiben state-only.

Spawn-Hooks bleiben reserved.

Der erste bestätigte Mission Effect Empfänger ist CaptureSystem.

---

## 13. AI

Pfad:

```text
src/ai/
```

Aktive Datei:

```text
src/ai/tc_ai_cap_manager.lua
```

Geplante spätere Datei:

```text
src/ai/tc_ai_director.lua
```

Aufgaben aktuell:

- CAP-Zonen aus Kampagnenlage ableiten
- CAP-State vorbereiten
- Blue-/Red-CAP-Bedarf vorbereiten
- spätere MOOSE-Anbindung vorbereiten

Aktueller getesteter Stand:

```text
AICapManager: v0.2.0
```

Bestätigte Werte:

```text
cap zone candidates: 31
auto-registered CAP zones: 12
CAP requests: 12
reactionState: AIR_REACTION_REQUESTED
threatLevel: HIGH
```

Bewertung:

AICapManager ist state-first bestanden.

Es werden noch keine echten MOOSE-CAP-Flüge gespawnt.

`spawn=MOOSE_PENDING` ist erwartetes Verhalten.

---

## 14. IADS

Pfad:

```text
src/iads/
```

Aktueller Stand:

- Ordner vorbereitet.
- README vorhanden.
- eigenes Theater-Command-IADS-Modul noch nicht implementiert.

Vendor:

```text
vendor/skynet-iads/SkynetIADS.lua
```

Geplante Aufgaben:

- Skynet-IADS-Anbindung kapseln
- IADS-Sites erfassen
- IADS-Sektoren modellieren
- SAM-/EWR-/Command-Struktur abbilden
- IADS-State im Theater-Command-State speichern
- MissionGenerator mit IADS-Zielen verbinden
- SEAD-/DEAD-/IADS_SUPPRESSION-Wirkung vorbereiten
- IADS-Zustand persistieren

Aktueller Stand:

- Skynet IADS wird geladen und erkannt.
- MissionGenerator reserviert bereits Skynet-Hooks.
- Es gibt noch keine produktive Theater-Command-IADS-Kampagnenlogik.

---

## 15. UI

Pfad:

```text
src/ui/
```

Aktive Datei:

```text
src/ui/tc_f10_menu.lua
```

Aufgaben:

- F10-Menü bereitstellen
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

Aktueller getesteter Stand:

```text
F10Menu: v0.2.2
```

Bestätigte Werte:

```text
commands: 32
```

Bestätigte Funktionen:

- F10-Menü sichtbar
- F10-Menü navigierbar
- Mission Details Slot 1 bestätigt
- Mission Slot 1 aktiviert
- Active Mission Outcome Status bestätigt
- Complete Active Mission 1 bestätigt
- Capture Status bestätigt
- Capture Ready Zones bestätigt
- Pressure Contested Zones bestätigt
- MissionGenerator setzt aktivierte Missionen auf `ACTIVE`
- MissionGenerator setzt abgeschlossene Missionen auf `COMPLETED`
- CaptureSystem verarbeitet abgeschlossene Mission Effects
- Aktivierung bleibt state-only
- Completion bleibt state-only

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

F10Menu ist bestanden.

Das UI ist die aktuell wichtigste Sichtbarkeits- und Testfläche.

Nächster UI-Schritt:

```text
Apply Capture Ready Zone 1
```

---

## 16. Debug

Pfad:

```text
src/debug/
```

Aktueller Stand:

- Ordner vorbereitet.
- README vorhanden.
- eigenes Debug-System noch nicht implementiert.

Geplante Aufgaben:

- State Dump
- Airbase Report
- Zone Report
- Capture Report
- Logistics Report
- FOB Report
- Mission Report
- AI Report
- IADS Report
- Debug-F10-Menü

Aktuelle Entscheidung:

Debug wird später ausgebaut.

Kurzfristig wird das bestehende F10-Menü um notwendige kontrollierte Capture- und State-Funktionen erweitert.

---

## 17. Main

Datei:

```text
src/main.lua
```

Aufgabe:

- Theater-Command-Runtime initialisieren
- Systemstart koordinieren
- Runtime-Systeme starten
- Core-Prüfungen auslösen
- Startstatus loggen

Aktueller Status:

- lädt
- startet
- initialisiert Runtime-Systeme
- beendet sauber

Wichtige bestätigte Logik:

```text
Main start requested
Core check passed
Runtime systems initialized
Main initialized
Main started
```

---

## 18. Loader

Datei:

```text
src/loader.lua
```

Aufgabe:

- Theater-Command-Startkette abschließen
- Framework-Verfügbarkeit prüfen
- Main-Start auslösen oder bestätigen
- Startstatus loggen
- Fehler sichtbar machen

Aktueller Status:

- lädt als letzte eigene Datei
- erkennt Frameworks
- beendet sauber

Wichtige bestätigte Logik:

```text
Theater Command loader started
Framework available: MIST
Framework available: MOOSE
Framework available: CTLD
Framework available: Skynet IADS
Theater Command loader finished
```

Wichtig:

- Loader-only-`dofile` ist noch nicht getestet.
- Aktuell bleibt sichere Einzeldatei-Ladung Standard.

---

## 19. State-first Runtime

Die aktuelle Runtime ist state-first.

Das bedeutet:

- Systeme erzeugen Daten im State.
- F10 zeigt State-Daten.
- Mission Activation verändert State.
- Mission Completion verändert State.
- Mission Effects werden state-only vorbereitet.
- CaptureSystem verarbeitet Mission Effects state-only.
- Capture Pressure ist State.
- Capture Progress ist State.
- Capture Ready ist State.
- Logistics Hubs sind State.
- FOBs sind State.
- AI CAP ist State.
- Framework-Hooks sind vorbereitet.
- echte Framework-Aktionen bleiben deaktiviert.

Aktuell bestätigt:

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

Nicht aktiv:

- echte MOOSE-Spawns
- echte CTLD-Aktionen
- echte Skynet-Aktionen
- produktive Persistenz
- automatische Missionserfolgsauswertung
- automatischer produktiver Ownership-Wechsel

Grund:

DCS-Fehlerdiagnose ist komplex.

Zuerst muss der Kampagnenzustand korrekt, sichtbar und testbar sein.

Danach können echte Framework-Aktionen kontrolliert aktiviert werden.

---

## 20. Abhängigkeiten zwischen Modulen

Vereinfachter Datenfluss:

```text
AirbaseScanner
-> ZoneFactory
-> CaptureSystem
-> LogisticsDelivery
-> FobSystem
-> MissionGenerator
-> AICapManager
-> F10Menu
```

Main startet die Runtime.

Loader prüft die Umgebung.

Aktuelle wichtigste Integrationen:

- Airbase Scanner liefert klassifizierte Airbase-Daten.
- ZoneFactory erzeugt relevante Kampagnenzonen.
- CaptureSystem erzeugt Eligibility, Pressure und Progress.
- CaptureSystem verarbeitet abgeschlossene Mission Effects.
- LogisticsDelivery erzeugt Logistics Hubs.
- FobSystem erzeugt Blue-FOBs.
- MissionGenerator erzeugt Missionen inklusive FOB-Support.
- MissionGenerator erzeugt Mission Effects.
- AICapManager erzeugt CAP-State.
- F10Menu zeigt Missionen, Campaign, Capture, Logistics, FOB und AI an.
- F10Menu aktiviert Missionen state-only.
- F10Menu schließt Missionen state-only ab.
- F10Menu zeigt Capture Ready Zones.

Noch nicht vollständig integriert:

- Mission Failure zu Capture Effects
- Mission Completion zu Logistics Effects
- Mission Completion zu AI Effects
- Mission Completion zu IADS Effects
- Capture Ready zu kontrolliertem Ownership-Wechsel
- CTLD zu Logistics/FOB
- MOOSE zu Missionen/CAP
- Skynet zu IADS-State
- Persistence zu vollständigem State
- AI Director zu Gesamtstrategie

---

## 21. Erwartete Logmarker

Bei einem erfolgreichen aktuellen Testlauf sollten unter anderem diese Marker erscheinen:

```text
[TC] [AirbaseScanner] Loaded src/world/tc_airbase_scanner.lua v0.2.2
[TC] [ZoneFactory] Loaded src/world/tc_zone_factory.lua v0.2.0
[TC] [CaptureSystem] Loaded src/campaign/tc_capture_system.lua v0.2.2
[TC] [CaptureSystem] Capture progress updated: zones=32, ready=0, contested=0, appliedMissionEffects=0
[TC] [CaptureSystem] Capture pressure summary: pressureRecords=32, progressRecords=32, appliedMissionEffects=0
[TC] [LogisticsDelivery] Loaded src/logistics/tc_logistics_delivery.lua v0.2.0
[TC] [FobSystem] Loaded src/logistics/tc_fob_system.lua v0.2.0
[TC] [MissionGenerator] Loaded src/missions/tc_mission_generator.lua v0.2.3
[TC] [MissionGenerator] Mission candidate summary: candidates=78, fobSupportCandidates=2, availableBefore=0, generationSlots=10
[TC] [MissionGenerator] Mission generation completed: 10 new missions from 78 candidates (fobSupportCandidates=2, reservedCreated=1, duplicatesSkipped=1, typeLimitSkipped=68)
[TC] [MissionGenerator] Mission activation prepared: MISSION_2 stateOnly=true spawnHooks=reserved
[TC] [MissionGenerator] Mission outcome prepared: MISSION_2 [COMPLETED] stateOnly=true effects=prepared
[TC] [CaptureSystem] Capture pressure added: zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE amount=105 progress=100%
[TC] [CaptureSystem] Mission effect applied to capture: mission=MISSION_2 zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE pressure=105
[TC] [CaptureSystem] Completed mission effects processed: applied=1, skipped=0, failed=0, appliedMissionEffects=1
[TC] [CaptureSystem] Capture progress updated: zones=32, ready=1, contested=0, appliedMissionEffects=1
[TC] [AICapManager] Loaded src/ai/tc_ai_cap_manager.lua v0.2.0
[TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.2
[TC] [F10Menu] F10 menu initialized: commands=32
[TC] [F10Menu] Mission details shown through F10: slot=1 key=MISSION_2
[TC] [F10Menu] Mission activated through F10: slot=1 key=MISSION_2
[TC] [F10Menu] Active mission outcome status shown through F10
[TC] [F10Menu] Mission completed through F10: slot=1 key=MISSION_2 stateOnly=true effects=prepared
[TC] [F10Menu] Capture status shown through F10
[TC] [F10Menu] Capture ready zones shown through F10
[TC] [F10Menu] Pressure contested zones shown through F10
[TC] System started: F10 Menu
[TC] Runtime systems initialized
[TC] Main initialized
[TC] Main started
[TC] Theater Command loader finished
```

---

## 22. Nach jeder Lua-Änderung

Wichtig für DCS:

Eine per `DO SCRIPT FILE` geladene Datei wird in die `.miz` eingebettet.

Nach jeder Lua-Änderung:

1. Datei auf GitHub aktualisieren
2. Commit durchführen
3. lokal per GitHub Desktop fetchen/pullen
4. DCS Mission Editor öffnen
5. geänderte Datei in der passenden `DO SCRIPT FILE`-Aktion neu auswählen
6. Mission speichern
7. alte `dcs.log` löschen oder umbenennen
8. DCS starten
9. Mission testen
10. `dcs.log` prüfen

Wenn im Log eine alte Version erscheint, wurde die Datei wahrscheinlich nicht neu in die `.miz` eingebettet.

---

## 23. Nächster sinnvoller Schritt

Empfohlene nächste Datei:

```text
src/ui/tc_f10_menu.lua
```

Ziel:

```text
kontrollierter state-only Ownership-Wechsel aus Capture Ready Zone 1
```

Geplante neue F10-Funktion:

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

## 24. Aktueller Abschlussstatus

Die Source-Struktur ist für den aktuellen Entwicklungsstand sauber angelegt.

Aktuell bestanden:

- Airbase Scanner
- ZoneFactory
- CaptureSystem
- LogisticsDelivery
- FobSystem
- MissionGenerator
- AICapManager
- F10Menu
- Main
- Loader

Aktuelle Fähigkeit:

- DCS lädt Theater Command.
- Airbases werden klassifiziert.
- relevante Kampagnenzonen werden erzeugt.
- Capture-Ziele werden erkannt.
- Capture-Pressure wird vorbereitet.
- Capture-Progress wird vorbereitet.
- Mission Completion erzeugt Capture Pressure.
- Capture Ready entsteht dynamisch.
- Capture Ready Zones sind über F10 sichtbar.
- Logistics Hubs werden erzeugt.
- FOBs werden geplant.
- Missionen werden erzeugt.
- Missionen können über F10 direkt ausgewählt werden.
- Missionen können über F10 direkt aktiviert werden.
- Missionen können über F10 state-only abgeschlossen werden.
- AI-CAP-State wird vorbereitet.
- F10-Menü ist sichtbar und nutzbar.

Nächster Entwicklungsschritt:

```text
src/ui/tc_f10_menu.lua
kontrollierter state-only Ownership-Wechsel aus Capture Ready Zone 1
```
