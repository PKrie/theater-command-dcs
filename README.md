# Theater Command DCS

**Theater Command DCS** ist ein modulares, dynamisches und später persistentes Kampagnensystem für **DCS World**.

Das Projekt entsteht zunächst für die **Syria Map**.

Erste Kampagne:

**Operation Levant Reclamation**

Ausgangslage:

- Blue startet auf **Akrotiri / Zypern**
- Das syrische Festland ist zu Beginn rot kontrolliert
- Blue soll sich vom Brückenkopf Zypern aus auf das syrische Festland vorarbeiten
- Red hält zu Beginn den Großteil der strategischen Flugplätze
- Spieler sollen sich in eine laufende Kampagne einklinken, nicht jede Aktion allein auslösen

---

## Grundidee

Theater Command DCS folgt drei Grundsätzen:

- **Mission Editor = Bühne**
- **Lua = Kampagnensystem**
- **GitHub = Projektgedächtnis**

Der DCS Mission Editor stellt die Karte, Templates, Trigger, Client-Slots, Zonen und Framework-Dateien bereit.

Die eigene Lua-Logik in `src/` erzeugt daraus eine dynamische Kampagnenlage.

GitHub dokumentiert Projektstand, Architektur, Aufgaben und getestete Versionen.

---

## Zielbild

Langfristig soll Theater Command DCS eine dynamische Kampagne ermöglichen, in der:

- Airbases, Helipads, FOBs und relevante Zonen Teil eines Kampagnenzustands sind
- Blue und Red eigene Operationen durchführen
- Spieler sich mit Client-Flugzeugen in die laufende Lage einklinken
- Missionen lageabhängig erzeugt werden
- CAP, Strike, SEAD, DEAD, CAS, Logistics, FOB Support und spätere CSAR-/Transportaufgaben entstehen
- Logistik und FOBs die Kampagne beeinflussen
- IADS und Luftverteidigung dynamisch eingebunden werden
- Kampagnenfortschritt gespeichert und geladen werden kann
- Missionserfolg und Missionsfehlschlag später aus DCS-Ereignissen ausgewertet werden

Das Projekt ist ausdrücklich nicht als reine „Spieler löst alles aus“-Mission gedacht.

Die KI soll perspektivisch auf beiden Seiten handeln:

- Blue plant Operationen
- Red plant Operationen
- beide Seiten reagieren auf Besitz, Logistik, Verluste, IADS, Missionen und Frontlage

---

## Aktueller Projektstand

Stand: **2026-06-29**

Das Projekt befindet sich in einer frühen, aber inzwischen stabilen Runtime-Aufbauphase.

Aktuell erreicht:

- Vendor-Frameworks laden im DCS Mission Scripting Environment.
- Theater-Command-Source-Dateien laden sauber.
- `src/main.lua` initialisiert die aktiven Runtime-Systeme.
- `src/loader.lua` prüft Framework-Verfügbarkeit und startet Main.
- Airbase Scanner klassifiziert Syria-Airbase-Objekte.
- ZoneFactory erzeugt relevante Kampagnenzonen.
- CaptureSystem erzeugt Capture-Eligibility, Capture-Pressure und Capture-Progress.
- LogisticsDelivery erzeugt Logistics Hubs.
- FobSystem erzeugt FOB-Kandidaten und erste Blue-FOBs.
- MissionGenerator erzeugt verfügbare Missionen inklusive FOB-Support.
- MissionGenerator erzeugt Objectives, Briefings, Progress-Daten und Activation Metadata.
- AICapManager erzeugt Blue-/Red-CAP-State.
- F10Menu ist sichtbar, navigierbar und logbestätigt.
- F10Menu erlaubt direkte Missionsauswahl Mission 1 bis Mission 10.
- F10Menu erlaubt direkte Missionsaktivierung Mission 1 bis Mission 10.
- Main und Loader starten sauber durch.

Noch nicht erreicht:

- fertige spielbare dynamische Kampagne
- echte MOOSE-Spawns
- echte CTLD-FOBs
- echte CTLD-Cargo-Flüge
- echte Skynet-IADS-Kampagnenlogik
- produktive Persistenz
- AI Director
- automatische Missionserfolgsauswertung
- automatische Capture-Auswertung aus Missionsresultaten
- automatische `.miz`-Generierung

---

## Aktueller getesteter Systemstand

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

---

## Bestätigte Kernwerte

Aktuell bestätigte Testwerte aus DCS-Logs:

- Syria liefert **225 airbase-like objects**
- Airbase Scanner klassifiziert diese Objekte
- Airbase Scanner erkennt **32 capture-/mission-fähige Airbase-Ziele**
- ZoneFactory erzeugt **46 relevante Kampagnenzonen**
- CaptureSystem arbeitet auf **32 capture-fähigen Zielen**
- CaptureSystem erzeugt **32 Capture-Pressure-Records**
- CaptureSystem erzeugt **32 Capture-Progress-Records**
- LogisticsDelivery erzeugt **46 Logistics Hubs**
- FobSystem erzeugt **6 FOB-Kandidaten**
- FobSystem plant **2 Blue-FOBs**
  - `FOB Ercan`
  - `FOB Gecitkale`
- MissionGenerator erzeugt **69 Missionskandidaten**
- MissionGenerator erkennt **2 FOB-Support-Kandidaten**
- MissionGenerator erzeugt **10 verfügbare Missionen**
- F10Menu erzeugt **26 Commands**
- F10Menu ist sichtbar und navigierbar
- Mission 1 bis Mission 10 sind direkt auswählbar
- Missionen können über F10 aktiviert werden
- aktivierte Missionen bleiben `stateOnly=true`
- Spawn-Hooks bleiben `reserved`
- Main und Loader starten sauber durch

---

## Repository-Struktur

Aktuelle Grundstruktur:

    theater-command-dcs/
    ├── README.md
    ├── ROADMAP.md
    ├── TASKS.md
    ├── CHANGELOG.md
    ├── ARCHITECTURE.md
    ├── MISSION_EDITOR_SETUP.md
    ├── NAMING_CONVENTIONS.md
    ├── LUA_STYLEGUIDE.md
    ├── docs/
    ├── mission_editor/
    ├── src/
    │   ├── README.md
    │   ├── loader.lua
    │   ├── main.lua
    │   ├── core/
    │   ├── world/
    │   ├── campaign/
    │   ├── logistics/
    │   ├── missions/
    │   ├── ai/
    │   ├── iads/
    │   ├── ui/
    │   └── debug/
    └── vendor/
        ├── mist/
        ├── moose/
        ├── ctld/
        └── skynet-iads/

---

## Source-Struktur

Eigene Lua-Logik liegt unter `src/`.

Aktive Source-Dateien:

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

Vorbereitete, aber noch nicht produktiv implementierte Bereiche:

    src/iads/
    src/debug/

---

## Vendor-Frameworks

Vendor-Dateien liegen unter `vendor/` und werden nicht verändert.

Aktive Vendor-Dateien:

| Framework | Pfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD-i18n | `vendor/ctld/CTLD-i18n.lua` | geladen |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Wichtig:

- MIST wird aktuell in der CTLD-kompatiblen Version verwendet.
- MOOSE wird geladen, aber noch nicht produktiv durch eigene Spawn-Logik genutzt.
- CTLD wird geladen, aber noch nicht produktiv mit Logistics/FOB-System verbunden.
- Skynet IADS wird geladen, aber noch nicht durch ein eigenes Theater-Command-IADS-Modul gesteuert.

---

## Nicht erwünschte Architektur

Nicht gewünscht sind Framework-Sammeldateien wie:

- `tc_moose.lua`
- `tc_mist.lua`
- `tc_ctld.lua`
- `tc_all_in_one.lua`

Eigene Logik wird nicht nach Frameworks sortiert, sondern nach Aufgaben:

- `tc_airbase_scanner.lua`
- `tc_zone_factory.lua`
- `tc_capture_system.lua`
- `tc_logistics_delivery.lua`
- `tc_fob_system.lua`
- `tc_mission_generator.lua`
- `tc_ai_cap_manager.lua`
- `tc_persistence_system.lua`
- `tc_f10_menu.lua`

---

## Aktuelle Ladefolge im Mission Editor

Aktuell wird weiterhin die sichere Einzeldatei-Ladung über `DO SCRIPT FILE` genutzt.

Vendor-Ladefolge:

1. `vendor/mist/mist.lua`
2. `vendor/moose/Moose.lua`
3. `vendor/ctld/CTLD-i18n.lua`
4. `vendor/ctld/CTLD.lua`
5. `vendor/skynet-iads/SkynetIADS.lua`

Theater-Command-Ladefolge:

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
- Loader-only-Ladung per `dofile` ist noch nicht praktisch getestet.

---

## DCS Mission Editor Hinweis

Eine per `DO SCRIPT FILE` geladene Lua-Datei wird in die `.miz` eingebettet.

Nach jeder Lua-Änderung muss die Datei im Mission Editor erneut ausgewählt und die Mission gespeichert werden.

Arbeitsablauf nach Lua-Änderung:

1. Datei auf GitHub aktualisieren
2. lokal per GitHub Desktop fetchen/pullen
3. DCS Mission Editor öffnen
4. geänderte Datei in der passenden `DO SCRIPT FILE`-Aktion neu auswählen
5. Mission speichern
6. Mission testen
7. frische `dcs.log` prüfen

Für saubere Tests:

1. DCS beenden
2. alte `dcs.log` löschen oder umbenennen
3. DCS neu starten
4. Mission testen
5. DCS beenden
6. neue `dcs.log` prüfen

---

## Aktuelle F10-Funktionen

Das F10-Menü ist aktuell aktiv und getestet.

Menüstruktur:

    F10
    └── Theater Command
        ├── Missions
        │   ├── Show Available Missions
        │   ├── Show Active Missions
        │   ├── Mission Details
        │   │   ├── Show Mission 1 Details
        │   │   ├── ...
        │   │   └── Show Mission 10 Details
        │   └── Activate Mission
        │       ├── Activate Mission 1
        │       ├── ...
        │       └── Activate Mission 10
        ├── Status
        │   └── Show Campaign Status
        ├── Logistics
        │   ├── Show Logistics Status
        │   └── Show FOB Status
        └── AI
            └── Show AI CAP Status

Bestätigt:

- 26 Commands erzeugt
- Mission Details funktionieren
- Mission Activation funktioniert
- MissionGenerator setzt aktivierte Missionen auf `ACTIVE`
- Aktivierung bleibt state-only
- keine echten Spawns

---

## Aktuelle Mission-Logik

MissionGenerator `v0.2.2` erzeugt aktuell Missionen aus:

- klassifizierten Airbase-/Zone-Daten
- Capture-Zonen
- Logistics-Zonen
- FOB-Kandidaten
- strategischer Relevanz
- Besitzstatus
- Missionstyp-Prioritäten

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

- Key
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
- Recommended Aircraft
- Recommended Payload
- Progress
- Activation Metadata
- Execution Plan
- Effect
- reserved MOOSE Hook
- reserved CTLD Hook
- reserved Skynet Hook

Wichtig:

- Missionen lösen noch keine echten DCS-Aktionen aus.
- Sie erzeugen und verändern aktuell nur Theater-Command-State.

---

## Aktuelle Capture-Logik

CaptureSystem `v0.2.1` arbeitet aktuell state-only.

Bestätigt:

- 32 capture-fähige Basen
- 32 capture-fähige Zonen
- 32 Capture-Pressure-Records
- 32 Capture-Progress-Records

Capture-fähig sind aktuell nur sinnvolle strategische und sekundäre Kampagnenziele.

Ausgeschlossen bleiben:

- einfache Helipads
- Medical Pads
- Tactical Pads
- unbekannte Airbase-like Objects
- rein technische oder nicht strategisch relevante Objekte

Neu vorbereitet:

- Capture Pressure pro Zone
- Capture Progress pro Zone
- Mission Effect zu Capture Pressure
- Capture Ready Status
- Pressure Contested Status
- Completion Hooks

Noch nicht produktiv:

- automatische Capture-Auswertung aus Missionsresultaten
- automatische Ownership-Wechsel durch Missionserfolg
- echte DCS-Event-Auswertung
- persistente Capture-Historie

---

## Aktuelle Logistics-/FOB-Logik

LogisticsDelivery `v0.2.0` erzeugt:

- 46 Logistics Hubs
- Blue Hubs
- Red Hubs
- Neutral Hubs
- Active Hubs
- Limited Hubs

FobSystem `v0.2.0` erzeugt:

- 6 FOB-Kandidaten
- 2 automatisch geplante Blue-FOBs:
  - `FOB Ercan`
  - `FOB Gecitkale`

Aktuell gilt:

- FOBs sind State-only.
- FOBs sind noch keine echten CTLD-FOBs.
- FOB Support Missionen werden im MissionGenerator berücksichtigt.
- CTLD-Cargo ist noch nicht produktiv verbunden.

---

## Aktuelle AI-Logik

AICapManager `v0.2.0` erzeugt aktuell CAP-State.

Bestätigt:

- 31 CAP-Zonen-Kandidaten
- 12 automatisch registrierte CAP-Zonen
- 12 CAP-Requests
- Reaction State: `AIR_REACTION_REQUESTED`
- Threat Level: `HIGH`

Aktuell gilt:

- AI CAP Manager plant CAP-Bedarf als State.
- Es werden noch keine echten MOOSE-CAP-Flüge gespawnt.
- `spawn=MOOSE_PENDING` ist erwartetes Verhalten.

---

## Dokumentation

Wichtige zentrale Dateien:

- `README.md`
- `TASKS.md`
- `CHANGELOG.md`
- `ROADMAP.md`
- `ARCHITECTURE.md`
- `MISSION_EDITOR_SETUP.md`
- `NAMING_CONVENTIONS.md`
- `LUA_STYLEGUIDE.md`

Wichtige Detaildokumente:

- `docs/00_project_overview.md`
- `docs/01_campaign_design.md`
- `docs/02_technical_architecture.md`
- `docs/03_mission_editor_basics.md`
- `docs/04_airbase_system.md`
- `docs/05_logistics_system.md`
- `docs/06_mission_generator.md`
- `docs/07_ai_director.md`
- `docs/08_iads_system.md`
- `docs/09_persistence.md`
- `docs/10_testing.md`

Source-Dokumentation:

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

Während aktiver Code-Arbeit wird nur die notwendige Dokumentation aktualisiert.

Größere Dokumentationsrunden erfolgen bevorzugt am Ende einer Session.

---

## Nächster sinnvoller technischer Schritt

Empfohlene nächste Datei:

- `src/ui/tc_f10_menu.lua`

Empfohlenes Ziel:

- Capture-/Pressure-Status im F10-Menü sichtbar machen
- `Show Capture Status`
- `Show Capture Ready Zones`
- `Show Pressure Contested Zones`
- Capture-Pressure und Capture-Progress lesbar anzeigen
- weiterhin state-only bleiben
- keine echten DCS-Spawns auslösen
- keine echten CTLD-Aktionen auslösen
- keine echten Skynet-Aktionen auslösen

Begründung:

- CaptureSystem `v0.2.1` erzeugt jetzt 32 Pressure-Records und 32 Progress-Records.
- Diese Daten sind im State vorhanden, aber im Spiel noch nicht komfortabel sichtbar.
- F10Menu ist stabil und eignet sich als nächster kleiner UI-Ausbauschritt.

---

## Danach sinnvolle Folgeschritte

Nach dem F10-Capture-Status:

1. Mission completed/failed über F10 oder Debug vorbereiten
2. `MissionGenerator.completeMission()` praktisch testen
3. `CaptureSystem.applyMissionEffect()` praktisch testen
4. Persistence-Sandbox-Test vorbereiten
5. CTLD-Zonen im Mission Editor vorbereiten
6. CTLD-Cargo mit Logistics/FOB-State verbinden
7. AI Director state-only beginnen
8. IADS-Modul vorbereiten
9. MOOSE-Spawns später mit Templates umsetzen

---

## Erwartete Logmarker

Bei einem vollständigen aktuellen Testlauf sollten unter anderem diese Marker erscheinen:

    [TC] [AirbaseScanner] Loaded src/world/tc_airbase_scanner.lua v0.2.2
    [TC] [ZoneFactory] Loaded src/world/tc_zone_factory.lua v0.2.0
    [TC] [CaptureSystem] Loaded src/campaign/tc_capture_system.lua v0.2.1
    [TC] [CaptureSystem] Capture progress updated: zones=32, ready=0, contested=0
    [TC] [CaptureSystem] Capture pressure summary: pressureRecords=32, progressRecords=32, appliedMissionEffects=0
    [TC] [LogisticsDelivery] Loaded src/logistics/tc_logistics_delivery.lua v0.2.0
    [TC] [FobSystem] Loaded src/logistics/tc_fob_system.lua v0.2.0
    [TC] [MissionGenerator] Loaded src/missions/tc_mission_generator.lua v0.2.2
    [TC] [MissionGenerator] Mission candidate summary: candidates=69, fobSupportCandidates=2, availableBefore=0, generationSlots=10
    [TC] [MissionGenerator] Mission generation completed: 10 new missions from 69 candidates (fobSupportCandidates=2, reservedCreated=1, duplicatesSkipped=1, typeLimitSkipped=30)
    [TC] [MissionGenerator] Mission activation prepared: MISSION_4 stateOnly=true spawnHooks=reserved
    [TC] [AICapManager] Loaded src/ai/tc_ai_cap_manager.lua v0.2.0
    [TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.0
    [TC] [F10Menu] F10 menu initialized: commands=26
    [TC] [F10Menu] Mission details shown through F10: slot=1 key=MISSION_1
    [TC] [F10Menu] Mission activated through F10: slot=1 key=MISSION_1
    [TC] System started: F10 Menu
    [TC] Runtime systems initialized
    [TC] Main initialized
    [TC] Main started
    [TC] Theater Command loader finished

Bei Logauswertungen beachten:

- DCS-/Rendering-/Terrain-Meldungen sind nicht automatisch Theater-Command-Fehler.
- Entscheidend sind `[TC]`-Zeilen.
- Besonders relevant sind `[TC][ERROR]`, `FAILED`, Lua-Stacktraces und Abbrüche in Theater-Command-Modulen.
- Alte Logs vor Tests löschen oder umbenennen.

---

## Aktueller Abschlussstand

Bestandene Systeme:

| System | Version | Status |
|---|---:|---|
| Airbase Scanner | `v0.2.2` | bestanden |
| ZoneFactory | `v0.2.0` | bestanden |
| CaptureSystem | `v0.2.1` | bestanden |
| LogisticsDelivery | `v0.2.0` | bestanden |
| FobSystem | `v0.2.0` | bestanden |
| MissionGenerator | `v0.2.2` | bestanden |
| AICapManager | `v0.2.0` | bestanden |
| F10Menu | `v0.2.0` | bestanden |

Aktuelle Fähigkeit:

- Theater Command startet in DCS.
- Airbases werden klassifiziert.
- Kampagnenzonen werden erzeugt.
- Capture-Ziele werden erkannt.
- Capture Pressure und Capture Progress werden vorbereitet.
- Logistics Hubs werden erzeugt.
- FOB-Kandidaten und erste FOBs werden erzeugt.
- Missionen inklusive FOB-Support werden erzeugt.
- Missionen können über F10 direkt ausgewählt und aktiviert werden.
- AI CAP State wird vorbereitet.
- Main und Loader starten sauber.

Das Projekt ist damit noch nicht spielerisch fertig, aber die state-first Runtime-Grundlage ist deutlich stabiler und bereit für den nächsten UI-/Debug-Schritt.
