# Theater Command DCS

**Theater Command DCS** ist ein modulares, dynamisches und später persistentes Kampagnensystem für **DCS World**.

Das Projekt entsteht zunächst für die **Syria Map**.

Erste Kampagne:

- **Operation Levant Reclamation**

Ausgangslage:

- Blue startet auf **Akrotiri / Zypern**
- Das syrische Festland ist zu Beginn rot kontrolliert
- Blue soll sich vom Brückenkopf Zypern aus auf das syrische Festland vorarbeiten
- Red hält zu Beginn den Großteil der strategischen Flugplätze
- Spieler sollen sich in eine laufende Kampagne einklinken, nicht jede Aktion allein auslösen
- Perspektivisch sollen Blue und Red eigene Operationen durchführen

---

## Grundidee

Theater Command DCS folgt drei Grundsätzen:

- **Mission Editor = Bühne**
- **Lua = Kampagnensystem**
- **GitHub = Projektgedächtnis**

Der DCS Mission Editor stellt die Karte, Koalitionen, Client-Slots, Trigger, Templates, Zonen und Vendor-Frameworks bereit.

Die eigene Lua-Logik in `src/` erzeugt daraus eine dynamische Kampagnenlage.

GitHub dokumentiert Projektstand, Architektur, Aufgaben, Changelog, Roadmap und getestete Versionen.

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

Stand: **2026-07-06**

Das Projekt befindet sich weiterhin in einer frühen Aufbauphase, besitzt aber inzwischen eine stabil getestete **State-first Runtime** im DCS Mission Scripting Environment.

Aktuell erreicht:

- Vendor-Frameworks laden im DCS Mission Scripting Environment.
- Theater-Command-Source-Dateien laden sauber.
- `src/main.lua` initialisiert die aktiven Runtime-Systeme.
- `src/loader.lua` prüft Framework-Verfügbarkeit und startet Main.
- Airbase Scanner klassifiziert Syria-Airbase-Objekte.
- ZoneFactory erzeugt relevante Kampagnenzonen.
- CaptureSystem erzeugt Capture-Eligibility, Capture-Pressure und Capture-Progress.
- CaptureSystem verarbeitet abgeschlossene Mission Effects state-only in Capture Pressure.
- LogisticsDelivery erzeugt Logistics Hubs.
- FobSystem erzeugt FOB-Kandidaten und erste Blue-FOBs.
- MissionGenerator erzeugt verfügbare Missionen inklusive FOB-Support.
- MissionGenerator erzeugt Objectives, Briefings, Progress-Daten, Activation Metadata, Outcome State und Effect State.
- MissionGenerator kann Missionen state-only aktivieren und abschließen.
- AICapManager erzeugt Blue-/Red-CAP-State.
- F10Menu ist sichtbar, navigierbar und logbestätigt.
- F10Menu erlaubt direkte Missionsauswahl Mission 1 bis Mission 10.
- F10Menu erlaubt direkte Missionsaktivierung Mission 1 bis Mission 10.
- F10Menu erlaubt Mission Outcome Controls für die erste aktive Mission.
- F10Menu zeigt Capture-/Pressure-Status an.
- F10Menu zeigt Capture Ready Zones und Pressure Contested Zones an.
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
- produktive automatische Capture-Auswertung aus Missionsresultaten
- kontrollierter Ownership-Wechsel aus Capture Ready
- automatische `.miz`-Generierung

---

## Aktueller getesteter Systemstand

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

---

## Bestätigte Kernwerte

Aktuell bestätigte Testwerte aus DCS-Logs:

- Syria liefert **225 airbase-like objects**
- Airbase Scanner klassifiziert diese Objekte
- Airbase Scanner erkennt **32 capture-/mission-fähige Airbase-Ziele**
- ZoneFactory erzeugt **46 relevante Kampagnenzonen**
- ZoneFactory überspringt **179 nicht geeignete airbase-like objects**
- CaptureSystem arbeitet auf **32 capture-fähigen Zielen**
- CaptureSystem erzeugt **32 Capture-Pressure-Records**
- CaptureSystem erzeugt **32 Capture-Progress-Records**
- LogisticsDelivery erzeugt **46 Logistics Hubs**
- FobSystem erzeugt **6 FOB-Kandidaten**
- FobSystem plant **2 Blue-FOBs**
  - `FOB Ercan`
  - `FOB Gecitkale`
- MissionGenerator erzeugt **78 Missionskandidaten**
- MissionGenerator erkennt **2 FOB-Support-Kandidaten**
- MissionGenerator erzeugt **10 verfügbare Missionen**
- F10Menu erzeugt **32 Commands**
- F10Menu ist sichtbar und navigierbar
- Mission 1 bis Mission 10 sind direkt auswählbar
- Missionen können über F10 aktiviert werden
- aktive Mission 1 kann über F10 auf `COMPLETED` gesetzt werden
- aktivierte Missionen bleiben `stateOnly=true`
- Spawn-Hooks bleiben `reserved`
- abgeschlossene Mission Effects werden state-only in Capture Pressure übernommen
- `MISSION_2` erzeugte im Test Capture Pressure auf `ZONE_AIRBASE_ABU_AL_DUHUR`
- angewendeter Capture Pressure im Test: **105**
- Capture Progress im Test: **100 %**
- `appliedMissionEffects`: **1**
- `ready`: **1**
- `contested`: **0**
- Capture Ready Zones sind über F10 anzeigbar
- Main und Loader starten sauber durch

---

## Aktuelle bestätigte Kampagnenkette

Erstmals bestätigt ist eine modulübergreifende State-Kette:

1. F10Menu zeigt Missionen an.
2. F10Menu aktiviert eine Mission.
3. MissionGenerator setzt die Mission auf `ACTIVE`.
4. F10Menu setzt aktive Mission 1 auf `COMPLETED`.
5. MissionGenerator bereitet Mission Effects state-only vor.
6. CaptureSystem übernimmt den abgeschlossenen Mission Effect.
7. CaptureSystem erhöht Capture Pressure der Zielzone.
8. CaptureSystem aktualisiert Capture Progress.
9. Capture Ready entsteht dynamisch.
10. F10Menu zeigt Capture Status und Capture Ready Zones an.

Diese Kette bleibt vollständig **state-only**.

Sie löst aktuell nicht aus:

- echte MOOSE-Spawns
- echte CTLD-Aktionen
- echte Skynet-IADS-Aktionen
- produktive Ownership-Wechsel
- automatische Persistenz

---

## Repository-Struktur

Aktuelle Grundstruktur:

```text
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
```

---

## Source-Struktur

Eigene Lua-Logik liegt unter `src/`.

Aktive Source-Dateien:

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

Vorbereitete, aber noch nicht produktiv implementierte Bereiche:

```text
src/iads/
src/debug/
```

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

- `src/campaign/tc_capture_system.lua` wird vor MissionGenerator, AI CAP Manager, F10Menu und Main geladen.
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
6. neue `dcs.log` auswerten

Ein weitergeführter Log kann für gezielte Regressionen ausreichen, muss aber zeitlich sauber vom alten Abschnitt getrennt bewertet werden.

---

## Aktuelle nächste Schritte

Der aktuelle Abschlussstand ist sauber dokumentiert in:

- `TASKS.md`
- `CHANGELOG.md`

Nächste sinnvolle technische Richtung:

1. kontrollierten state-only Ownership-Wechsel aus `Capture Ready Zone 1` vorbereiten
2. vorher oder danach `Fail Active Mission 1` praktisch testen
3. später Persistence-Sandbox-Test vorbereiten
4. später CTLD-Zonen und echte CTLD-Logistik vorbereiten
5. später AI Director und echte Framework-Ausführung entwickeln

Wichtig:

- kein automatischer produktiver Ownership-Wechsel ohne bewussten Testpfad
- keine echten MOOSE-Spawns ohne Templates
- keine echte CTLD-Integration ohne Mission-Editor-Zonen
- keine produktive Persistenz ohne vorherigen DCS-Sandbox-Test
