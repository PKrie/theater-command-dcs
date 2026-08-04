# Theater Command DCS

Theater Command DCS ist ein modulares, dynamisches und später persistentes Kampagnensystem für DCS World.

Das Projekt entsteht zunächst für die Syria Map.

Erste Kampagne:

- Operation Levant Reclamation

## Verbindlicher Projektstand — 2026-08-04

Theater Command DCS besitzt eine state-first Runtime mit dirty-aware Hintergrundpersistenz. PersistenceSystem `v0.2.6` ist in `Operation_Levant_Reclamation_DEV.miz` eingebettet und hat normale periodische `SAVED`- und `SKIPPED`-Ticks bestanden. Produktiver Startup-Restore bleibt deaktiviert und ungetestet.

DCS-SMS ist ein Entwicklungs- und Mission-Editor-Werkzeug, kein Theater-Command-Runtime-Framework. Installiert und bestätigt sind Mission-Editor- und Runtime-Bridge, externe Ausführung sowie das Codex-`dcs-sms`-Skill. Die aktuelle Bridge-Umgebung ist `os=true`, `io=true`, `lfs=true`, `require=false`. Persistence selbst benötigt direkt nur `io` und `lfs`.

Der Spieler-Slot `CLIENT_BLUE_FA18C_AKROTIRI_01` ist `CLIENT`, nicht `PLAYER`. Ein normaler Teststart erfordert Mission starten, den Client-Slot auswählen und bestätigen und anschließend im Briefing `Fly` drücken.

Aktueller Blocker:

- MissionGenerator `v0.2.3` erzeugt zunächst zehn state-only Missionen.
- Später sind alle sechs Mission-Status-Dictionaries leer, während `lastMissionId=10` und die Statistiken stale bleiben.
- Der Verlust ist reproduzierbar; Ursache und Writer sind nicht identifiziert.
- Statische Klassifikation: `PROJECT SOURCE HAS NO MATCHING WRITE SITE`.
- Mission Completion, Mission Failure und Capture Ready Apply Regressionen sind deshalb derzeit blockiert.

Nächster Schritt ist kein spekulativer Code-Fix, sondern ein read-only Offline-Byte-/SHA-256-Audit aller eingebetteten Theater-Command-Ressourcen in der gespeicherten DEV-`.miz`. Details stehen in `TASKS.md`, `docs/06_mission_generator.md` und `docs/10_testing.md`.

---

## Ausgangslage der Kampagne

Blue startet auf:

- Akrotiri / Zypern

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

- Mission Editor = Bühne
- Lua = Kampagnensystem
- GitHub = Projektgedächtnis

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

Historischer Baseline-Stand: 2026-07-06. Der verbindliche aktuelle Stand steht oben.

Das Projekt befindet sich weiterhin in einer frühen Aufbauphase, besitzt aber inzwischen eine stabil getestete State-first Runtime im DCS Mission Scripting Environment.

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
- MissionGenerator kann Missionen state-only aktivieren.
- MissionGenerator kann Missionen state-only auf `COMPLETED` setzen.
- MissionGenerator kann Missionen state-only auf `FAILED` setzen.
- AICapManager erzeugt Blue-/Red-CAP-State.
- F10Menu ist sichtbar, navigierbar und logbestätigt.
- F10Menu erlaubte in historischen Regressionstests direkte Missionsauswahl und -aktivierung für Mission 1 bis Mission 10.
- F10Menu erlaubte historische Mission Outcome Controls für die erste aktive Mission.
- Aktuell sind wegen des ungeklärten Record-Verlusts keine Missionen auswählbar.
- F10Menu zeigt Capture-/Pressure-Status an.
- F10Menu zeigt Capture Ready Zones und Pressure Contested Zones an.
- F10Menu kann Capture Ready Zone 1 bewusst state-only anwenden.
- PersistenceSystem kann DCS-Dateisystemzugriff prüfen.
- PersistenceSystem kann Campaign-State als Lua-Return-Datei speichern.
- PersistenceSystem kann Save-Dateien lesen, kompilieren, evaluieren und validieren.
- PersistenceSystem kann Save-Dateien kontrolliert importieren.
- PersistenceSystem läuft inzwischen als unsichtbarer Background-Autosave-Service.
- Main und Loader starten sauber durch.

Noch nicht erreicht:

- fertige spielbare dynamische Kampagne
- echte MOOSE-Spawns
- echte CTLD-FOBs
- echte CTLD-Cargo-Flüge
- echte Skynet-IADS-Kampagnenlogik
- produktiver automatischer Restore beim Missionsstart
- AI Director mit echten Entscheidungen
- automatische Missionserfolgsauswertung
- automatische Mission-Outcome-Auswertung aus DCS-Events
- automatische Capture-Auswertung aus realen DCS-Einheiten/Zonen
- produktive automatische Ownership-Wechsel ohne bewusste Bestätigung
- Persistenz-Hooks nach allen relevanten State-Änderungen
- automatische `.miz`-Generierung

---

## Aktueller getesteter Systemstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | Embedded-Start, `SAVED`, `SKIPPED`, `FAILED` und Retry bestanden |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | historische Pfade bestanden; aktueller Record-Verlust ungelöst |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden |

---

## Bestätigte Kernwerte

Aktuell bestätigte Testwerte aus DCS-Logs:

### Airbase Scanner

- Syria airbase-like objects: `225`
- strategic: `19`
- secondary: `13`
- heliports: `1`
- helipads: `95`
- medical: `40`
- farps: `0`
- tactical: `13`
- unknown: `44`
- captureCandidates: `32`
- missionCandidates: `32`
- logisticsCandidates: `46`
- blueStartBases: `1`
- redStrategicCandidates: `18`

### ZoneFactory

- relevante Kampagnenzonen: `46`
- skipped airbase-like objects: `179`
- captureZones: `32`
- missionZones: `32`
- logisticsZones: `46`
- startBaseZones: `1`

### CaptureSystem Startzustand

- eligibleBases: `32`
- eligibleZones: `32`
- nonCaptureBases: `193`
- nonCaptureZones: `14`
- pressureRecords: `32`
- progressRecords: `32`
- appliedMissionEffects: `0`
- ready: `0`
- contested: `0`

### MissionGenerator

- mission candidates: `78`
- fobSupportCandidates: `2`
- generated missions: `10`
- reservedCreated: `1`
- duplicatesSkipped: `1`
- typeLimitSkipped: `68`

### F10Menu

- Version: `v0.2.3`
- Commands: `33`
- F10Menu ist sichtbar und navigierbar.
- Mission 1 bis Mission 10 sind direkt auswählbar.
- Missionen können über F10 aktiviert werden.
- aktive Mission 1 kann über F10 auf `COMPLETED` gesetzt werden.
- aktive Mission 1 kann über F10 auf `FAILED` gesetzt werden.
- Capture Ready Zones sind über F10 anzeigbar.
- Capture Ready Zone 1 kann über F10 bewusst angewendet werden.

### PersistenceSystem

- Version: `v0.2.6`
- `fileSystemAvailable=true`
- `io=true`
- `lfs=true`
- `os=true` in der aktuellen DCS-SMS-Bridge-Umgebung
- `require=false`
- `load=true`
- `loadstring=true`
- `loadfile=true`
- `autosaveScheduled=true`
- Autosave initial nach `20s`
- Autosave-Intervall: `120s`
- letzter bestätigter Autosave Count: `1`
- `productiveRestore=false`

Historischer Pre-DCS-SMS-Teststand war `os=false`. Solange die DCS-SMS-Runtime-Bridge aktiv ist, müssen `os`, `io` und `lfs` unsanitized bleiben. PersistenceSystem selbst benötigt `os` nicht direkt.

Bestätigter Speicherordner:

- `C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS`

Bestätigte Save-Datei:

- `C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua`

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
19. PersistenceSystem speichert den Campaign-State im Hintergrund automatisch.

Bestätigter Testfall:

- completed mission: `MISSION_2`
- target zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- capture pressure owner: `BLUE`
- applied pressure: `105`
- progress vor Apply: `100 %`
- appliedMissionEffects: `1`
- ready vor Apply: `1`
- contested: `0`
- applied zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- applied owner: `BLUE`
- linked airbase: `Abu al-Duhur`
- ready nach Apply: `0`

Diese Kette bleibt vollständig state-only.

Sie löst aktuell nicht aus:

- echte MOOSE-Spawns
- echte CTLD-Aktionen
- echte Skynet-IADS-Aktionen
- produktive automatische Ownership-Wechsel
- produktiven automatischen Restore

---

## Mission Failure Pipeline

Bestätigt ist außerdem der Failure-Pfad:

1. F10Menu zeigt Mission Details.
2. F10Menu aktiviert Mission 1.
3. MissionGenerator setzt Mission 1 auf `ACTIVE`.
4. F10Menu zeigt Active Mission Outcome Status.
5. F10Menu setzt aktive Mission 1 state-only auf `FAILED`.
6. MissionGenerator setzt Mission Outcome auf `FAILED`.
7. MissionGenerator bereitet Failure Effects state-only vor.
8. CaptureSystem verarbeitet abgeschlossene Mission Effects.
9. CaptureSystem wendet bei `FAILED` aktuell keinen Capture Pressure an.

Bestätigt:

- Failed Missions erzeugen aktuell bewusst keinen Capture Pressure.
- `appliedMissionEffects=0`
- `ready=0`
- `contested=0`

Bewertung:

- Failure-Pfad ist bestanden.
- Das Verhalten ist für den aktuellen State-first-Teststand korrekt.

---

## Persistence-Status

Persistence ist aktuell ein internes Hintergrundsystem.

Spieler müssen und sollen Persistenz nicht über F10 auslösen.

Technischer Verlauf:

- `v0.2.0`: DCS-Sandbox-Verfügbarkeit geprüft.
- `v0.2.1`: Schreib-/Lesetest korrigiert und bestanden.
- `v0.2.2`: Campaign-State-Snapshot als Datei geschrieben.
- `v0.2.3`: Save-Datei gelesen, kompiliert, evaluiert und validiert.
- `v0.2.4`: Save-Datei kontrolliert in `TC.State` importiert.
- `v0.2.5`: Test-Timer-Kaskade entfernt und Background-Autosave aktiviert.
- `v0.2.6`: periodischen Autosave dirty-aware gemacht; `SAVED`, `SKIPPED`, `FAILED` und Retry verifiziert.

Aktueller Status:

- Autosave läuft automatisch im Hintergrund.
- Erster Autosave nach 20 Sekunden.
- Danach Autosave alle 120 Sekunden.
- Save/Validate/Load-Funktionen bleiben intern vorhanden.
- Produktiver Restore beim Missionsstart ist bewusst deaktiviert.
- `productiveRestore=false`

Wichtige lokale Voraussetzung:

In der lokalen DCS-Datei:

- `...\DCS World\Scripts\MissionScripting.lua`

müssen für dieses Projekt `io` und `lfs` entsperrt sein.

Aktueller Zustand mit aktiver DCS-SMS-Runtime-Bridge:

- `io=true`
- `lfs=true`
- `os=true`
- `require=false`

PersistenceSystem benötigt direkt `io` und `lfs`, aber nicht `os` oder `require`. DCS-SMS `exec`, `status` und `tail-log` benötigen `os`, `io` und `lfs` unsanitized.

Hinweis:

Nach DCS-Updates kann `MissionScripting.lua` überschrieben werden. Dann muss die lokale Sandbox-Freigabe erneut geprüft werden.

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

- `src/loader.lua`
- `src/main.lua`
- `src/core/tc_config.lua`
- `src/core/tc_logger.lua`
- `src/core/tc_state.lua`
- `src/core/tc_utils.lua`
- `src/core/tc_scheduler.lua`
- `src/world/tc_airbase_scanner.lua`
- `src/world/tc_zone_factory.lua`
- `src/campaign/tc_capture_system.lua`
- `src/campaign/tc_persistence_system.lua`
- `src/logistics/tc_logistics_delivery.lua`
- `src/logistics/tc_fob_system.lua`
- `src/missions/tc_mission_generator.lua`
- `src/ai/tc_ai_cap_manager.lua`
- `src/ui/tc_f10_menu.lua`

Vorbereitet oder dokumentiert:

- `src/iads/`
- `src/debug/`

---

## Aktuelle Ladefolge im Mission Editor

Aktuell wird weiter die sichere Einzeldatei-Ladung verwendet.

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

- `src/campaign/tc_persistence_system.lua` muss vor `src/main.lua` geladen werden.
- `src/ui/tc_f10_menu.lua` muss vor `src/main.lua` geladen werden.
- `src/main.lua` bleibt der Runtime-Startpunkt.
- `src/loader.lua` bleibt aktuell die letzte eigene Datei.
- Starttest Variante B mit Loader-only-`dofile` ist weiterhin offen.

Aktuelle Entscheidung:

- Bis Variante B praktisch geprüft ist, bleibt die sichere Einzeldatei-Ladung Standard.

---

## Vendor-Frameworks

Frameworks liegen unter `vendor/` und werden nicht verändert.

Aktive Vendor-Dateien:

| Framework | Pfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD-i18n | `vendor/ctld/CTLD-i18n.lua` | geladen |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Wichtig:

- Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket, weil CTLD eine kompatible MIST-Version benötigt.
- Eigene Lua-Logik gehört nach `src/`.
- Vendor-Dateien werden nicht verändert.
- Integrationslogik gehört in eigene fachliche Module.

Nicht erwünscht:

- `tc_moose.lua`
- `tc_mist.lua`
- `tc_ctld.lua`
- `tc_all_in_one.lua`

---

## Aktuelle Einschränkungen

Das Projekt ist weiterhin keine fertige spielbare dynamische Kampagne.

Noch nicht produktiv umgesetzt:

- echte MOOSE-Spawns
- echte CTLD-Logistikaktionen
- echte CTLD-FOBs
- echte CTLD-Crates
- echte Skynet-IADS-Kampagnenlogik
- produktive AI-Director-Entscheidungen
- automatische Missionserfolgserkennung über DCS-Events
- automatische Capture-Auswertung über reale Einheiten/Zonen
- produktiver automatischer Restore beim Missionsstart
- Persistenz-Hooks nach relevanten State-Änderungen
- echte Blue-/Red-KI-Kampagnenoperationen

---

## Bekannte DCS-/Log-Hinweise

Folgende Meldungen sind aktuell nicht als Theater-Command-Fehler zu werten, solange keine `[TC][ERROR]`, kein `SCRIPTING ERROR`, kein `Mission script error`, kein `stack traceback` und kein `attempt to` im Theater-Command-Kontext auftreten:

- `DTC_MANAGER Window pointer is null`
- `LUA-TERRAIN getObjectPosition`
- `DX11BACKEND ... render target ... not found`
- `INVALID ATC`
- `ModelTimeQuantizer`
- `Destruction shape not found`
- negative drag / weapon drag warnings

Wichtige Fehlerindikatoren:

- `[TC][ERROR]`
- `SCRIPTING ERROR`
- `Mission script error`
- `stack traceback`
- `attempt to index`
- `attempt to call`
- `nil value`
- `protected call failed`

---

## Nächster sinnvoller technischer Schritt

Offline Embedded Mission Resource Audit:

- gespeicherte DEV-`.miz` ausschließlich read-only untersuchen
- Trigger-zu-Ressource-Mappings prüfen
- eingebettete und Repository-Dateien per Byte-Länge und SHA-256 vergleichen
- stale, doppelte, unerwartete oder fehlende Theater-Command-Ressourcen melden
- keine `.miz`-Änderung, kein DCS-SMS Runtime Exec und kein spekulativer Code-Fix

---

## Einstieg für neue Sessions

Neue Sessions sollen nicht aus Erinnerung arbeiten.

Zuerst prüfen:

- `README.md`
- `ROADMAP.md`
- `TASKS.md`
- `CHANGELOG.md`
- `ARCHITECTURE.md`
- `docs/09_persistence.md`
- `docs/10_testing.md`
- `src/campaign/tc_capture_system.lua`
- `src/campaign/tc_persistence_system.lua`
- `src/ui/tc_f10_menu.lua`

Danach dort weitermachen, wo der aktuelle GitHub-Stand endet.

Nächster technischer Startpunkt:

- `TASKS.md` und der dort definierte Offline Embedded Mission Resource Audit

---

## Footer

Theater Command DCS ist aktuell ein wachsendes State-first-Kampagnensystem.

Die aktuellen Meilensteine sind:

- World State steht.
- Capture State steht.
- Mission State steht.
- F10-Testbed steht.
- Persistence Background Autosave steht.

Der nächste Meilenstein ist:

- Embedded-Runtime-Drift als mögliche Ursache des reproduzierbaren Mission-Record-Verlusts read-only prüfen.
