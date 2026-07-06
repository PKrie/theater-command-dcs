# Theater Command DCS

**Theater Command DCS** ist ein modulares, dynamisches und später persistentes Kampagnensystem für **DCS World**.

Das Projekt entsteht zunächst für die **Syria Map**.

Erste Kampagne:

- **Operation Levant Reclamation**

---

## Ausgangslage der Kampagne

Blue startet auf:

- **Akrotiri / Zypern**

Die Ausgangslage:

- Das syrische Festland ist zu Beginn rot kontrolliert.
- Red hält zu Beginn den Großteil der strategischen Flugplätze.
- Blue soll sich vom Brückenkopf Zypern aus auf das syrische Festland vorarbeiten.
- Spieler sollen sich mit Client-Flugzeugen in eine laufende Kampagnenlage einklinken.
- Spieler sollen nicht der einzige Motor der Kampagne sein.
- Blue und Red sollen perspektivisch eigene Operationen durchführen.

---

## Grundprinzip

Theater Command DCS folgt drei Grundsätzen:

- **Mission Editor = Bühne**
- **Lua = Kampagnensystem**
- **GitHub = Projektgedächtnis**

Der DCS Mission Editor stellt bereit:

- Karte
- Koalitionen
- Client-Slots
- Trigger
- Templates
- Zonen
- Vendor-Frameworks

Die eigene Lua-Logik unter `src/` erzeugt daraus eine dynamische Kampagnenlage.

GitHub dokumentiert:

- Projektstand
- Architektur
- Aufgaben
- Changelog
- Roadmap
- getestete Versionen
- bekannte Einschränkungen

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
- Airbase Scanner klassifiziert Syria-Airbase-like Objects.
- ZoneFactory erzeugt relevante Kampagnenzonen.
- CaptureSystem erzeugt Capture-Eligibility, Capture-Pressure und Capture-Progress.
- CaptureSystem verarbeitet abgeschlossene Mission Effects state-only in Capture Pressure.
- CaptureSystem kann Capture Ready state-only anwenden, wenn dies bewusst ausgelöst wird.
- CaptureSystem synchronisiert beim Capture Apply die linked Airbase Ownership.
- CaptureSystem setzt Capture Pressure nach erfolgreichem Ownership-Wechsel zurück.
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
- F10Menu kann Capture Ready Zone 1 bewusst state-only anwenden.
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
- automatische Mission-Outcome-Auswertung aus DCS-Events
- produktive automatische Capture-Auswertung aus Missionsresultaten
- automatische produktive Ownership-Wechsel ohne bewusste Bestätigung
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
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden |

---

## Bestätigte Kernwerte

Aktuell bestätigte Testwerte aus DCS-Logs:

Airbase Scanner:

- Syria airbase-like objects: **225**
- strategic: **19**
- secondary: **13**
- heliports: **1**
- helipads: **95**
- medical: **40**
- farps: **0**
- tactical: **13**
- unknown: **44**
- captureCandidates: **32**
- missionCandidates: **32**
- logisticsCandidates: **46**
- blueStartBases: **1**
- redStrategicCandidates: **18**

ZoneFactory:

- relevante Kampagnenzonen: **46**
- skipped airbase-like objects: **179**
- captureZones: **32**
- missionZones: **32**
- logisticsZones: **46**
- startBaseZones: **1**

CaptureSystem Startzustand:

- eligibleBases: **32**
- eligibleZones: **32**
- nonCaptureBases: **193**
- nonCaptureZones: **14**
- pressureRecords: **32**
- progressRecords: **32**
- appliedMissionEffects: **0**
- ready: **0**
- contested: **0**

MissionGenerator:

- mission candidates: **78**
- fobSupportCandidates: **2**
- generated missions: **10**
- reservedCreated: **1**
- duplicatesSkipped: **1**
- typeLimitSkipped: **68**

F10Menu:

- Version: **v0.2.3**
- Commands: **33**
- F10Menu ist sichtbar und navigierbar.
- Mission 1 bis Mission 10 sind direkt auswählbar.
- Missionen können über F10 aktiviert werden.
- aktive Mission 1 kann über F10 auf `COMPLETED` gesetzt werden.
- Capture Ready Zones sind über F10 anzeigbar.
- Capture Ready Zone 1 kann über F10 bewusst angewendet werden.

---

## Aktuelle bestätigte Kampagnenkette

Bestätigt ist eine modulübergreifende State-Kette:

1. F10Menu zeigt Missionen an.
2. F10Menu zeigt Mission 1 Details an.
3. F10Menu aktiviert Mission 1.
4. MissionGenerator setzt die Mission auf `ACTIVE`.
5. F10Menu zeigt Active Mission Outcome Status an.
6. F10Menu setzt aktive Mission 1 auf `COMPLETED`.
7. MissionGenerator bereitet Mission Effects state-only vor.
8. CaptureSystem übernimmt den abgeschlossenen Mission Effect.
9. CaptureSystem erhöht Capture Pressure der Zielzone.
10. CaptureSystem aktualisiert Capture Progress.
11. Capture Ready entsteht dynamisch.
12. F10Menu zeigt Capture Status an.
13. F10Menu zeigt Capture Ready Zones an.
14. F10Menu wendet Capture Ready Zone 1 bewusst state-only an.
15. CaptureSystem setzt Zone Ownership auf den dominanten Owner.
16. CaptureSystem synchronisiert die linked Airbase Ownership.
17. CaptureSystem setzt Capture Pressure nach erfolgreichem Apply zurück.
18. F10Menu zeigt den aktualisierten Capture Status an.

Bestätigter Testfall:

- completed mission: `MISSION_2`
- target zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- capture pressure owner: `BLUE`
- applied pressure: **105**
- progress vor Apply: **100 %**
- appliedMissionEffects: **1**
- ready vor Apply: **1**
- contested: **0**
- applied zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- applied owner: `BLUE`
- linked airbase: `Abu al-Duhur`
- ready nach Apply: **0**

Diese Kette bleibt vollständig **state-only**.

Sie löst aktuell nicht aus:

- echte MOOSE-Spawns
- echte CTLD-Aktionen
- echte Skynet-IADS-Aktionen
- produktive automatische Ownership-Wechsel
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

1. Datei auf GitHub aktualisieren.
2. Lokal per GitHub Desktop fetchen/pullen.
3. DCS Mission Editor öffnen.
4. Geänderte Datei in der passenden `DO SCRIPT FILE`-Aktion neu auswählen.
5. Mission speichern.
6. Alte `dcs.log` löschen oder umbenennen.
7. DCS starten.
8. Mission testen.
9. Frische `dcs.log` prüfen.

Für saubere Tests:

1. DCS beenden.
2. Alte `dcs.log` löschen oder umbenennen.
3. DCS neu starten.
4. Mission testen.
5. DCS beenden.
6. Neue `dcs.log` auswerten.

Ein weitergeführter Log kann für gezielte Regressionen ausreichen, muss aber zeitlich sauber vom alten Abschnitt getrennt bewertet werden.

---

## Aktuelle bestätigte Logmarker

Wichtige bestätigte Marker aus dem letzten bestandenen Test:

```text
[TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.3
[TC] [F10Menu] F10 menu initialized: commands=33
[TC] [F10Menu] Mission details shown through F10: slot=1 key=MISSION_2
[TC] [F10Menu] Mission activated through F10: slot=1 key=MISSION_2
[TC] [F10Menu] Active mission outcome status shown through F10
[TC] [F10Menu] Mission completed through F10: slot=1 key=MISSION_2 stateOnly=true effects=prepared
[TC] [CaptureSystem] Capture pressure added: zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE amount=105 progress=100%
[TC] [CaptureSystem] Capture progress updated: zones=32, ready=1, contested=0, appliedMissionEffects=1
[TC] [F10Menu] Capture ready zones shown through F10
[TC] [CaptureSystem] Zone captured: ZONE_AIRBASE_ABU_AL_DUHUR [BLUE]
[TC] [CaptureSystem] Base captured: Abu al-Duhur [BLUE]
[TC] [F10Menu] Capture ready zone applied through F10: slot=1 zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE stateOnly=true
[TC] [CaptureSystem] Capture progress updated: zones=32, ready=0, contested=0, appliedMissionEffects=1
[TC] [F10Menu] Capture status shown through F10
```

---

## Aktuelle nächste Schritte

Der aktuelle Abschlussstand soll sauber dokumentiert sein in:

- `TASKS.md`
- `CHANGELOG.md`
- `README.md`

Nächste sinnvolle technische Richtung:

1. `Fail Active Mission 1` praktisch testen.
2. Danach Persistence-Sandbox-Test vorbereiten.
3. Danach kontrollierte Save-/Load-Grundlage testen.
4. Danach CTLD-Zonen und echte CTLD-Logistik vorbereiten.
5. Danach MOOSE-CAP-Templates vorbereiten.
6. Danach AI Director state-only entwerfen.
7. Danach IADS-System mit Skynet vorbereiten.

Wichtig:

- kein automatischer produktiver Ownership-Wechsel ohne bewussten Testpfad
- keine echten MOOSE-Spawns ohne Templates
- keine echte CTLD-Integration ohne Mission-Editor-Zonen
- keine produktive Persistenz ohne vorherigen DCS-Sandbox-Test

---

## Aktueller Merksatz

Theater Command DCS bleibt aktuell bewusst **state-first**.

Erst wenn State, UI, Capture, Mission Outcomes und Persistenz stabil getestet sind, werden echte Framework-Aktionen mit MOOSE, CTLD und Skynet produktiv angebunden.
