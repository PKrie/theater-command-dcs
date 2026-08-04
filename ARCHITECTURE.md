# ARCHITECTURE.md

Diese Datei beschreibt die technische Architektur von **Theater Command DCS**.

Das Projekt ist ein modulares, dynamisches und später persistentes Kampagnensystem für DCS World.

Erste Kampagne:

- Operation Levant Reclamation

Map:

- Syria

Grundprinzip:

- Mission Editor = Bühne
- Lua = Kampagnensystem
- GitHub = Projektgedächtnis

## Verbindlicher Architekturstand — 2026-08-04

PersistenceSystem `v0.2.6` ist ein dirty-aware Campaign-Layer-Querschnittssystem. Periodische Entscheidungen sind `SAVED`, `SKIPPED` oder `FAILED`; Dirty wird erst nach Write, Read-back, Compile, Evaluate und Validation gelöscht. Ein neuerer Dirty-State wird durch einen älteren Save-Abschluss nicht gelöscht. Produktiver Startup-Restore bleibt deaktiviert.

Mission-Status-Collections sind Dictionaries mit String-Keys wie `MISSION_1`. Autoritative Zählung erfolgt mit `pairs()` beziehungsweise `countTableKeys()`, nicht mit `#` oder `ipairs()`. Historisch wurden zehn Missionen erfolgreich erzeugt und über F10 getestet. Aktuell gehen die sechs Status-Collections später reproduzierbar verloren, während IDs und Statistiken stale bleiben. Ursache und Writer sind unbekannt; die Klassifikation lautet `PROJECT SOURCE HAS NO MATCHING WRITE SITE`.

DCS-SMS ist ausschließlich Entwicklungs- und Mission-Editor-Tooling, kein Runtime-Framework. Die aktive Bridge-Umgebung ist `os=true`, `io=true`, `lfs=true`, `require=false`; Persistence selbst benötigt direkt nur `io` und `lfs`.

Nächster Architekturtest ist der offline/read-only Vergleich der eingebetteten `.miz`-Ressourcen mit den Repository-Quellen. Bis dahin bleiben Mission Completion, Mission Failure und Capture Ready Apply Regressionen blockiert.

---

## 1. Architekturziel

Theater Command DCS soll langfristig eine dynamische Kampagne erzeugen, in der:

- Airbases und relevante Zonen Teil eines Kampagnenzustands sind
- Blue und Red unabhängig vom Spieler handeln können
- Spieler Missionen auswählen und fliegen können
- Missionen aus der Kampagnenlage entstehen
- Capture, Logistics, FOBs, AI, IADS und Persistence zusammenwirken
- Kampagnenfortschritt gespeichert und später automatisch wiederhergestellt werden kann
- Spieler Teilnehmer einer laufenden Kampagne sind und nicht alleiniger Auslöser aller Kampagnenaktionen

Das System ist nicht als lineare Einzelmission gedacht.

Ziel ist eine modulare Kampagnenruntime, die Schritt für Schritt von einer stabilen State-first-Grundlage zu einer echten dynamischen Kampagne ausgebaut wird.

---

## 2. Ausgangslage der ersten Kampagne

Kampagne:

- Operation Levant Reclamation

Map:

- Syria

Startlage:

- Blue startet auf Akrotiri / Zypern.
- Das syrische Festland ist zu Beginn rot kontrolliert.
- Red hält zu Beginn den Großteil der strategischen Flugplätze.
- Blue soll sich vom Brückenkopf Zypern aus auf das syrische Festland vorarbeiten.
- Spieler klinken sich mit Client-Flugzeugen in die laufende Kampagnenlage ein.
- Blue und Red sollen später eigene Operationen durchführen.

---

## 3. Architekturstatus

Historischer Baseline-Stand: 2026-07-06. Der verbindliche aktuelle Stand steht oben.

Aktuelle Architekturklasse:

- State-first Runtime
- Background Autosave vorhanden
- produktiver Restore noch deaktiviert
- Framework-Aktionen noch reserviert

Aktuell bestätigt:

- Vendor-Frameworks laden.
- Core-Systeme laden.
- Main und Loader starten.
- Syria-Airbase-Scan funktioniert.
- relevante Kampagnenzonen werden erzeugt.
- CaptureSystem verwaltet Capture-Eligibility, Capture-Pressure und Capture-Progress.
- CaptureSystem verarbeitet abgeschlossene Mission Effects state-only in Capture Pressure.
- CaptureSystem verarbeitet Failed Missions korrekt ohne Capture Pressure.
- CaptureSystem kann Capture Ready state-only anwenden.
- CaptureSystem kann Zone Ownership und linked Airbase Ownership state-only synchronisieren.
- LogisticsDelivery erzeugt Logistics Hubs.
- FobSystem erzeugt FOB-Kandidaten und erste Blue-FOBs.
- MissionGenerator erzeugt Missionen inklusive FOB-Support.
- MissionGenerator erzeugt Objectives, Briefings, Progress-Daten, Activation Metadata, Outcome State und Effect State.
- MissionGenerator kann Missionen state-only aktivieren.
- MissionGenerator kann Missionen state-only auf `COMPLETED` setzen.
- MissionGenerator kann Missionen state-only auf `FAILED` setzen.
- AICapManager erzeugt Blue-/Red-CAP-State.
- F10Menu ist sichtbar, navigierbar und unterstützt direkte Missionsauswahl.
- F10Menu unterstützt Mission Outcome Controls.
- F10Menu zeigt Capture-/Pressure-Status.
- F10Menu zeigt Capture Ready Zones und Pressure Contested Zones.
- F10Menu kann Capture Ready Zone 1 bewusst state-only anwenden.
- PersistenceSystem kann DCS-Dateien schreiben und lesen.
- PersistenceSystem kann Campaign-State als Lua-Return-Datei speichern.
- PersistenceSystem kann Save-Dateien lesen, kompilieren, evaluieren und validieren.
- PersistenceSystem kann Save-Dateien kontrolliert importieren.
- PersistenceSystem läuft als unsichtbarer Background-Autosave-Service.

Aktuelle bewusste Einschränkungen:

- keine echten MOOSE-Spawns
- keine produktiven CTLD-Aktionen
- keine echte CTLD-FOB-Erstellung
- keine produktive Skynet-IADS-Kampagnenlogik
- kein produktiver automatischer Restore beim Missionsstart
- keine automatische Missionserfolgsauswertung aus DCS-Events
- keine automatische Capture-Auswertung aus realen DCS-Einheiten/Zonen
- kein automatischer produktiver Ownership-Wechsel ohne bewusste Testaktion
- keine automatische `.miz`-Generierung

---

## 4. Schichtenmodell

Die Architektur ist in Schichten aufgebaut.

Reihenfolge von unten nach oben:

1. Vendor Layer
2. Core Layer
3. World Layer
4. Campaign Layer
5. Logistics Layer
6. Mission Layer
7. AI Layer
8. IADS Layer
9. UI Layer
10. Main / Loader Layer
11. Debug / Testing Layer

Grundregel:

- Untere Schichten stellen Zustand und Basisdaten bereit.
- Obere Schichten lesen diesen Zustand und leiten daraus Aufgaben, UI oder spätere Framework-Aktionen ab.
- Echte Framework-Ausführung wird erst aktiviert, wenn der State stabil, sichtbar und testbar ist.
- Persistence läuft als Querschnittssystem im Campaign Layer.
- Spieler sollen Persistence nicht direkt bedienen müssen.

---

## 5. Vendor Layer

Pfad:

- `vendor/`

Aufgabe:

- externe Frameworks bereitstellen
- Framework-Dateien unverändert halten
- Frameworks laden
- Framework-Funktionen später über eigene Theater-Command-Module nutzen

Aktive Vendor-Dateien:

| Framework | Pfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD-i18n | `vendor/ctld/CTLD-i18n.lua` | geladen |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Regeln:

- Vendor-Dateien werden nicht verändert.
- Eigene Logik gehört nicht nach `vendor/`.
- Framework-spezifische Integrationslogik wird in fachliche Module unter `src/` ausgelagert.
- Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket, weil CTLD eine kompatible MIST-Version benötigt.

Nicht erwünscht:

- `tc_moose.lua`
- `tc_mist.lua`
- `tc_ctld.lua`
- `tc_all_in_one.lua`

---

## 6. Core Layer

Pfad:

- `src/core/`

Aktive Dateien:

- `src/core/tc_config.lua`
- `src/core/tc_logger.lua`
- `src/core/tc_state.lua`
- `src/core/tc_utils.lua`
- `src/core/tc_scheduler.lua`

Aufgabe:

- globale Konfiguration bereitstellen
- Logging vereinheitlichen
- globalen Kampagnenzustand bereitstellen
- Hilfsfunktionen bereitstellen
- Scheduler-Grundlage bereitstellen
- modulübergreifende Statusinformationen speichern

Architekturregel:

- Core-Dateien sollen keine konkrete Kampagnenlogik enthalten.
- Core-Dateien stellen Basisdienste bereit.
- Fachlogik liegt in World, Campaign, Logistics, Missions, AI, IADS oder UI.

---

## 7. World Layer

Pfad:

- `src/world/`

Aktive Dateien:

- `src/world/tc_airbase_scanner.lua`
- `src/world/tc_zone_factory.lua`

Aufgabe:

- Syria-Airbase-Daten aus DCS erfassen
- Airbase-like Objects klassifizieren
- relevante Kampagnenziele identifizieren
- Kampagnenzonen erzeugen
- Airbases, Helipads, Medical Pads, Tactical Pads und unbekannte Objekte trennen

---

### 7.1 Airbase Scanner

Datei:

- `src/world/tc_airbase_scanner.lua`

Getestete Version:

- `v0.2.2`

Status:

- bestanden

Bestätigte Werte:

| Wert | Anzahl |
|---|---:|
| Syria airbase-like objects | `225` |
| strategic | `19` |
| secondary | `13` |
| heliports | `1` |
| helipads | `95` |
| medical | `40` |
| farps | `0` |
| tactical | `13` |
| unknown | `44` |
| captureCandidates | `32` |
| missionCandidates | `32` |
| logisticsCandidates | `46` |
| blueStartBases | `1` |
| redStrategicCandidates | `18` |

Bewertung:

- Akrotiri wird als Blue-Startbasis erkannt.
- Strategische und sekundäre Flugplätze werden als Kampagnenziele vorbereitet.
- Medical Pads und einfache Helipads werden nicht als strategische Ziele genutzt.

---

### 7.2 Zone Factory

Datei:

- `src/world/tc_zone_factory.lua`

Getestete Version:

- `v0.2.0`

Status:

- bestanden

Bestätigte Werte:

| Wert | Anzahl |
|---|---:|
| relevante Kampagnenzonen | `46` |
| skipped airbase-like objects | `179` |
| captureZones | `32` |
| missionZones | `32` |
| logisticsZones | `46` |
| startBaseZones | `1` |

Bewertung:

- ZoneFactory erzeugt nicht blind 225 Zonen.
- Es entstehen 46 relevante Kampagnenzonen.
- Diese Zonen bilden die Grundlage für Capture, Logistics, Missions, AI und spätere IADS-Anbindung.

---

## 8. Campaign Layer

Pfad:

- `src/campaign/`

Aktive Dateien:

- `src/campaign/tc_capture_system.lua`
- `src/campaign/tc_persistence_system.lua`

Aufgabe:

- Kampagnenzustand verwalten
- Ownership vorbereiten
- Capture-Progress und Capture-Pressure verwalten
- Mission Effects auf Kampagnenzustand anwenden
- Persistenz bereitstellen
- geänderten Kampagnenzustand langfristig speichern

---

### 8.1 CaptureSystem

Datei:

- `src/campaign/tc_capture_system.lua`

Getestete Version:

- `v0.2.2`

Status:

- bestanden

Aufgabe:

- capture-fähige Basen und Zonen erkennen
- nicht capture-fähige Objekte ausschließen
- Capture-Pressure-Records erzeugen
- Capture-Progress-Records erzeugen
- abgeschlossene Mission Effects state-only in Capture Pressure übernehmen
- Failed Mission Effects korrekt ohne Capture Pressure behandeln
- Capture Ready und Pressure Contested verwalten
- Capture Ready bewusst state-only anwenden
- Zone Ownership state-only ändern
- linked Airbase Ownership state-only synchronisieren

Bestätigte Startwerte:

| Wert | Anzahl |
|---|---:|
| eligibleBases | `32` |
| eligibleZones | `32` |
| nonCaptureBases | `193` |
| nonCaptureZones | `14` |
| pressureRecords | `32` |
| progressRecords | `32` |
| appliedMissionEffects | `0` |
| ready | `0` |
| contested | `0` |

Bestätigter Mission-Completion-Fall:

- completed mission: `MISSION_2`
- target zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- owner: `BLUE`
- applied pressure: `105`
- progress: `100 %`
- ready: `1`
- contested: `0`

Bestätigter Capture-Apply-Fall:

- applied zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- applied owner: `BLUE`
- linked airbase: `Abu al-Duhur`
- linked airbase owner: `BLUE`
- ready danach: `0`
- contested danach: `0`

Bestätigter Failure-Fall:

- Mission Outcome: `FAILED`
- CaptureSystem applied effects: `0`
- ready: `0`
- contested: `0`
- appliedMissionEffects: `0`

Bewertung:

- CaptureSystem ist state-first stabil.
- Mission Completion zu Capture Pressure ist bestätigt.
- Mission Failure ohne Capture Pressure ist bestätigt.
- Capture Ready Apply ist bestätigt.
- Produktive automatische Capture-Auswertung über reale DCS-Einheiten ist noch offen.
- Dirty-Markierungen sind vorhanden und werden durch PersistenceSystem `v0.2.6` ausgewertet.

---

### 8.2 PersistenceSystem

Datei:

- `src/campaign/tc_persistence_system.lua`

Getestete Version:

- `v0.2.6`

Status:

- bestanden

Architekturrolle:

- internes Hintergrundsystem
- kein Spieler-F10-Menü
- speichert Kampagnenzustand automatisch
- hält Save/Validate/Load-Funktionen intern bereit
- produktiver Restore beim Missionsstart bleibt bewusst deaktiviert

Lokale Voraussetzung:

- `io` und `lfs` müssen in `...\DCS World\Scripts\MissionScripting.lua` entsperrt sein.
- `os` ist für die aktive DCS-SMS-Runtime-Bridge unsanitized.
- `require` bleibt gesperrt.

Bestätigter Sandbox-Status:

| Modul/Funktion | Status |
|---|---|
| `os` | `true` |
| `io` | `true` |
| `lfs` | `true` |
| `require` | `false` |
| `load` | `true` |
| `loadstring` | `true` |
| `loadfile` | `true` |
| `fileSystemAvailable` | `true` |

Bestätigter Speicherordner:

- `C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS`

Bestätigte Save-Datei:

- `C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua`

Technische Stufen:

| Version | Ziel | Status |
|---:|---|---|
| `v0.2.0` | DCS-Sandbox-Verfügbarkeit prüfen | bestanden, zunächst blockiert |
| `v0.2.1` | Schreib-/Lesetest korrigieren | bestanden |
| `v0.2.2` | Campaign-State-Snapshot speichern | bestanden |
| `v0.2.3` | Save-Datei lesen, kompilieren, evaluieren und validieren | bestanden |
| `v0.2.4` | Save-Datei kontrolliert importieren | bestanden |
| `v0.2.5` | Background-Autosave statt Test-Timer-Kaskade | bestanden |
| `v0.2.6` | Dirty-aware `SAVED`/`SKIPPED`/`FAILED` mit Retry und Embedded-Scheduler | bestanden |

Autosave-Verhalten:

- erster Autosave nach `20s`
- danach alle `120s`
- Autosave läuft ohne Spieleraktion
- letzter bestätigter `autosaveCount=1`
- `productiveRestore=false`

Architekturentscheidung:

- Persistence ist kein Spieler-Feature.
- Spieler müssen nicht manuell speichern oder laden.
- Persistence läuft im Maschinenraum.
- F10-Persistence-Menü ist aktuell nicht vorgesehen.

Noch offen:

- fachliche Dirty-Abdeckung der aktiven State-Systeme weiter validieren
- Save-Dateiformat langfristig versionieren
- Backup-/Rotationsstrategie für Save-Dateien
- produktiven Restore erst nach vollständiger Dirty-Abdeckung, blockierten Regressionen und definierter Restore-Reihenfolge freischalten

---

## 9. Logistics Layer

Pfad:

- `src/logistics/`

Aktive Dateien:

- `src/logistics/tc_logistics_delivery.lua`
- `src/logistics/tc_fob_system.lua`

Aufgabe:

- Logistics Hubs erzeugen
- Supply-Zustände vorbereiten
- FOB-Kandidaten erzeugen
- erste FOBs state-only planen
- spätere CTLD-Anbindung vorbereiten

---

### 9.1 LogisticsDelivery

Datei:

- `src/logistics/tc_logistics_delivery.lua`

Getestete Version:

- `v0.2.0`

Status:

- historisch bestandene Generierungs- und F10-Pipeline
- aktueller Mission-Record-Verlust reproduzierbar und ungelöst

Bestätigte Werte:

| Wert | Anzahl |
|---|---:|
| logistics hubs | `46` |
| blue hubs | `7` |
| red hubs | `24` |
| neutral hubs | `15` |
| active hubs | `31` |
| limited hubs | `15` |
| locked hubs | `0` |

Bewertung:

- LogisticsDelivery nutzt ZoneFactory-Daten.
- CTLD ist geladen, wird aber noch nicht produktiv angesprochen.
- Logistics ist als State-System vorbereitet.

Offen:

- CTLD Pickup-/Dropoff-Zonen
- Supply-Verbrauch
- CTLD-Crate-Auswertung
- vorhandene Dirty-Abdeckung für Logistics weiter fachlich validieren
- Kopplung mit Capture und FOB

---

### 9.2 FobSystem

Datei:

- `src/logistics/tc_fob_system.lua`

Getestete Version:

- `v0.2.0`

Status:

- bestanden

Bestätigte Werte:

| Wert | Anzahl |
|---|---:|
| FOB candidates | `6` |
| stored candidates | `6` |
| auto-planned FOBs | `2` |
| skipped candidates | `4` |

Erzeugte FOBs:

- `FOB Ercan`
- `FOB Gecitkale`

Status:

- `UNDER_CONSTRUCTION`

Bewertung:

- FOB-System ist state-only vorbereitet.
- CTLD-FOB-Erstellung ist noch nicht produktiv aktiv.

Offen:

- echte CTLD-FOB-Erstellung
- CTLD-Crates mit FOB-Baufortschritt koppeln
- FOB-Zustand persistenzrelevant markieren
- FOBs später für Spieler und AI als Forward Operations Bases nutzen

---

## 10. Mission Layer

Pfad:

- `src/missions/`

Aktive Datei:

- `src/missions/tc_mission_generator.lua`

Getestete Version:

- `v0.2.3`

Status:

- bestanden

Aufgabe:

- Mission Candidates aus Kampagnenlage erzeugen
- Missionsliste bereitstellen
- Mission Objectives erzeugen
- Briefings erzeugen
- Mission Progress vorbereiten
- Mission Activation Metadata erzeugen
- Outcome State verwalten
- Effect State vorbereiten
- Framework-Hooks reservieren

Bestätigte Werte:

| Wert | Anzahl |
|---|---:|
| mission candidates | `78` |
| fobSupportCandidates | `2` |
| generated missions | `10` |
| reservedCreated | `1` |
| duplicatesSkipped | `1` |
| typeLimitSkipped | `68` |

Bestätigt:

- Missionen können state-only aktiviert werden.
- Missionen können state-only auf `COMPLETED` gesetzt werden.
- Missionen können state-only auf `FAILED` gesetzt werden.
- Completed Mission Effects können Capture Pressure erzeugen.
- Failed Mission Effects erzeugen aktuell bewusst keinen Capture Pressure.
- MOOSE-/CTLD-/Skynet-Hooks bleiben reserviert.

Aktuelle Einschränkung:

- Alle sechs Mission-Status-Dictionaries wurden nach erfolgreicher Initialgenerierung später leer beobachtet.
- `lastMissionId=10` und Statistikwerte blieben erhalten.
- Weder Ursache noch exakter Writer sind identifiziert; es ist unklar, ob ersetzt, geleert oder fehlerhaft beobachtet wurde.
- Der Projektquellcode enthält keinen automatisch erreichbaren passenden Write-Site.

Offen:

- Mission `CANCELLED` testbar machen
- Mission `EXPIRED` testbar machen
- Missionserfolg aus DCS-Events ableiten
- echte Mission Execution über Frameworks
- Mission State persistenzrelevant markieren

---

## 11. AI Layer

Pfad:

- `src/ai/`

Aktive Datei:

- `src/ai/tc_ai_cap_manager.lua`

Getestete Version:

- `v0.2.0`

Status:

- bestanden

Aufgabe:

- CAP-Zonen aus Kampagnenlage ableiten
- CAP Requests erzeugen
- Blue-/Red-CAP-State vorbereiten
- spätere MOOSE-Anbindung vorbereiten

Bestätigte Werte:

| Wert | Anzahl / Status |
|---|---:|
| cap zone candidates | `31` |
| auto-registered CAP zones | `12` |
| CAP requests | `12` |
| reactionState | `AIR_REACTION_REQUESTED` |
| threatLevel | `HIGH` |

Bewertung:

- AI CAP Manager besitzt eine stabile State-Grundlage.
- Echter MOOSE-Spawn bleibt `MOOSE_PENDING`.

Offen:

- MOOSE CAP Templates im Mission Editor anlegen
- MOOSE SPAWN anbinden
- AI_A2A_DISPATCHER prüfen
- CAP-Verluste und CAP-Erfolge auswerten
- AI-Zustand persistenzrelevant markieren

---

## 12. IADS Layer

Pfad:

- `src/iads/`

Status:

- dokumentiert / vorbereitet
- noch nicht produktiv angebunden

Vendor:

- `vendor/skynet-iads/SkynetIADS.lua`

Aufgabe später:

- SAM-/EWR-Struktur in Kampagnenzustand überführen
- Skynet IADS initialisieren
- IADS-Ziele für MissionGenerator bereitstellen
- IADS-Zustand durch Missionen beeinflussen
- IADS-Zustand persistieren

Offen:

- Mission-Editor-Gruppen definieren
- Naming-Konventionen prüfen
- eigenes IADS-Modul erstellen
- Skynet-Anbindung state-first vorbereiten
- IADS Dirty-Hooks für Persistence

---

## 13. UI Layer

Pfad:

- `src/ui/`

Aktive Datei:

- `src/ui/tc_f10_menu.lua`

Getestete Version:

- `v0.2.3`

Status:

- bestanden

Aufgabe:

- Kampagnenstatus anzeigen
- Missionen anzeigen
- Mission Details anzeigen
- Missionen aktivieren
- Mission Outcome testbar machen
- Capture-/Pressure-Status anzeigen
- Capture Ready Zones anzeigen
- Capture Ready Zone 1 bewusst state-only anwenden
- Logistics- und FOB-Status anzeigen

Bestätigt:

- F10Menu initialisiert mit `33` Commands.
- Mission 1 bis Mission 10 Details sind direkt abrufbar.
- Mission 1 bis Mission 10 können direkt aktiviert werden.
- aktive Mission 1 kann auf `COMPLETED` gesetzt werden.
- aktive Mission 1 kann auf `FAILED` gesetzt werden.
- Capture Status kann angezeigt werden.
- Capture Ready Zones können angezeigt werden.
- Capture Ready Zone 1 kann angewendet werden.
- Pressure Contested Zones können angezeigt werden.

Architekturentscheidung:

- Persistence bekommt aktuell kein Spieler-F10-Menü.
- Persistence läuft im Hintergrund.
- Save/Load ist kein Spielerworkflow.

Offen:

- Mission Outcome Controls für Slots 2 bis 10
- Cancel/Expire Controls
- langfristige Trennung zwischen Spieler-UI und Debug-/Admin-UI
- spätere Vereinfachung des Spieler-F10-Menüs

---

## 14. Main / Loader Layer

Aktive Dateien:

- `src/main.lua`
- `src/loader.lua`

Aufgabe:

- Framework-Verfügbarkeit prüfen
- Module in definierter Reihenfolge starten
- Runtime-Status loggen
- Startfehler sichtbar machen

Aktueller Status:

- Main startet.
- Loader startet.
- aktive Module werden initialisiert.
- F10Menu wird registriert.
- PersistenceSystem startet und plant Autosave.
- keine Startabbrüche im aktuellen Teststand.

Aktuelle Ladefolge im Mission Editor:

Vendor:

1. `vendor/mist/mist.lua`
2. `vendor/moose/Moose.lua`
3. `vendor/ctld/CTLD-i18n.lua`
4. `vendor/ctld/CTLD.lua`
5. `vendor/skynet-iads/SkynetIADS.lua`

Theater Command:

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

Entscheidung:

- Die sichere Einzeldatei-Ladung bleibt Standard.
- Loader-only-`dofile` bleibt späterer Test.

---

## 15. Datenfluss aktuell

Aktueller bestätigter State-first-Datenfluss:

1. AirbaseScanner liest Syria-Airbase-Daten.
2. ZoneFactory erzeugt Kampagnenzonen.
3. CaptureSystem erzeugt Capture-Eligibility, Pressure und Progress.
4. LogisticsDelivery erzeugt Logistics Hubs.
5. FobSystem erzeugt FOB-Kandidaten und erste Blue-FOBs.
6. MissionGenerator erzeugt Mission Candidates und Missionsliste.
7. AICapManager erzeugt CAP State.
8. F10Menu zeigt State und erlaubt kontrollierte Testaktionen.
9. Mission Completion erzeugt Mission Effects.
10. CaptureSystem verarbeitet Mission Effects zu Capture Pressure.
11. Capture Ready kann bewusst angewendet werden.
12. PersistenceSystem speichert Campaign-State im Hintergrund.

Bestätigte End-to-End-Kette:

- Mission Details
- Mission Activation
- Mission Completion
- Mission Effects
- Capture Pressure
- Capture Ready
- Capture Ready Apply
- Zone Ownership Update
- Airbase Ownership Sync
- Background Autosave

---

## 16. Persistence-Architektur

Persistence ist ein Campaign-Layer-Querschnittssystem.

Ziele:

- Kampagnenzustand serialisieren
- Save-Datei schreiben
- Save-Datei lesen
- Save-Datei validieren
- Save-Datei kontrolliert importieren
- Autosave im Hintergrund ausführen
- später produktiven Restore ermöglichen

Aktueller Status:

- dirty-aware Background Autosave aktiv
- normal eingebettete `20s`-/`120s`-Scheduler-Ausführung bestanden
- produktiver Restore deaktiviert

Save-Dateiformat:

- Lua-Return-Datei
- Format: `TC_LUA_TABLE_V1`
- Marker: `TC_CAMPAIGN_STATE_SAVE`

Save-Datei:

- `operation_levant_reclamation_save.lua`

Speicherordner:

- `Saved Games\DCS.openbeta\TheaterCommandDCS`

Aktuelle lokale DCS-SMS-Bridge-Umgebung:

- `io=true`
- `lfs=true`
- `os=true`
- `require=false`

Autosave:

- erster Autosave nach 20 Sekunden
- danach alle 120 Sekunden

Produktiver Restore:

- nicht aktiv
- darf erst nach vollständiger Dirty-Abdeckung, den blockierten Regressionen und definierter Restore-Reihenfolge aktiviert werden

Architekturentscheidung:

- Persistence ist kein Spieler-F10-Menü.
- Spieler sollen nicht speichern/laden müssen.
- Persistence soll automatisch auf relevante State-Änderungen reagieren.

Nächster Schritt:

- Offline Embedded Mission Resource Audit; kein Persistence- oder MissionGenerator-Code-Fix ohne neue Evidenz.

---

## 17. State-first-Regel

Theater Command DCS arbeitet aktuell bewusst state-first.

Das bedeutet:

- Lua-Systeme erzeugen zunächst nur Kampagnenzustand.
- F10Menu macht diesen Zustand sichtbar und testbar.
- Framework-Aktionen bleiben reserviert.
- MOOSE-, CTLD- und Skynet-Funktionen werden erst produktiv genutzt, wenn der State stabil ist.
- Persistence speichert zunächst diesen State.

Vorteil:

- Fehler bleiben isolierbar.
- DCS-Logs bleiben auswertbar.
- Module können einzeln getestet werden.
- Framework-Komplexität wird nicht zu früh eingebracht.

---

## 18. Was aktuell bewusst nicht passiert

Aktuell nicht aktiv:

- echte MOOSE-Spawns
- echte CTLD-Cargo-Aktionen
- echte CTLD-FOB-Erstellung
- echte Skynet-IADS-Aktionen
- produktiver automatischer Restore
- automatische Missionserfolgserkennung
- automatische Capture-Auswertung realer Einheiten
- automatische `.miz`-Generierung

Begründung:

- Die State-Schicht muss zuerst stabil bleiben.
- Dirty-aware Persistence ist an echten State-Änderungen getestet; der aktuelle MissionGenerator-State-Verlust muss vor weiteren Regressionen geklärt werden.
- Produktiver Restore darf Initialisierungsreihenfolge nicht beschädigen.
- Framework-Aktionen werden später einzeln angebunden.

---

## 19. Testing-Architektur

Testprinzip:

- eine Datei oder eine konkrete Aufgabe pro Schritt
- DCS-Log nach jedem Lua-Schritt prüfen
- keine parallelen Änderungen
- keine Framework-Dateien verändern
- keine All-in-one-Lua-Dateien

Wichtige Fehlerindikatoren:

- `[TC][ERROR]`
- `SCRIPTING ERROR`
- `Mission script error`
- `stack traceback`
- `attempt to index`
- `attempt to call`
- `nil value`
- `protected call failed`

Nicht automatisch Theater-Command-Fehler:

- `DTC_MANAGER Window pointer is null`
- `LUA-TERRAIN getObjectPosition`
- `DX11BACKEND ... render target ... not found`
- `INVALID ATC`
- `ModelTimeQuantizer`
- `Destruction shape not found`
- negative drag / weapon drag warnings

---

## 20. Aktuelle Risiken

### 20.1 MissionScripting.lua

Für Persistence müssen lokal `io` und `lfs` entsperrt sein.

Risiko:

- DCS-Updates können `MissionScripting.lua` überschreiben.

Folge:

- Persistence kann wieder blockiert werden.

Erwartete Logmarker bei Problem:

- `io=false`
- `lfs=false`
- `Persistence sandbox blocked`

---

### 20.2 Save-Datei-Kompatibilität

Die Save-Datei ist aktuell eine Lua-Return-Datei.

Risiko:

- spätere Strukturänderungen können alte Save-Dateien inkompatibel machen.

Gegenmaßnahme später:

- Save-Versionierung
- Formatprüfung
- Backup/Rotation
- Fallback auf neuen Kampagnenstart

---

### 20.3 Produktiver Restore

Die technische Importfähigkeit ist bestätigt.

Risiko:

- produktiver Restore kann Initialisierungsreihenfolge stören, wenn er zu früh aktiviert wird.

Gegenmaßnahme:

- Restore bleibt deaktiviert.
- Dirty-Abdeckung vollständig auditieren und blockierte Regressionen nach Klärung des MissionGenerator-State-Verlusts durchführen.
- Dann Restore-Reihenfolge definieren.
- Dann produktiven Restore kontrolliert freischalten.

---

### 20.4 Framework-Integration

MOOSE, CTLD und Skynet können starke Nebenwirkungen erzeugen.

Risiko:

- zu frühe echte Framework-Aktionen erschweren Debugging.

Gegenmaßnahme:

- Framework-Hooks bleiben reserviert.
- State zuerst stabilisieren.
- Framework-Aktionen später einzeln produktiv aktivieren.

---

## 21. Nächster technischer Schritt

Read-only Offline-Audit der in `Operation_Levant_Reclamation_DEV.miz` eingebetteten Theater-Command-Ressourcen. Der Audit verifiziert Trigger-Mappings, Byte-Längen, SHA-256, exakte Byte-Gleichheit, Versionen sowie stale, doppelte, unerwartete oder fehlende Skripte.

Akzeptanzkriterien:

- CaptureSystem lädt sauber.
- Mission Completion Pipeline bleibt stabil.
- Mission Failure Pipeline bleibt stabil.
- Capture Ready Apply bleibt stabil.
- Nach Capture Apply wird eine persistenzrelevante State-Änderung geloggt.
- Persistence Autosave läuft weiterhin automatisch.
- Keine Lua-Fehler.
- Keine echten Framework-Aktionen.

Erwarteter Test:

1. Mission starten.
2. Mission über F10 aktivieren.
3. Mission über F10 abschließen.
4. Capture Ready Zone 1 über F10 anwenden.
5. CaptureSystem markiert State als persistenzrelevant.
6. Persistence autosaved automatisch.
7. DCS-Log bestätigt Dirty-/Autosave-Zusammenhang.

---

## 22. Aktueller Abschlussstand

Bestandene Systeme:

| System | Version | Status |
|---|---:|---|
| Airbase Scanner | `v0.2.2` | bestanden |
| ZoneFactory | `v0.2.0` | bestanden |
| CaptureSystem | `v0.2.2` | bestanden |
| LogisticsDelivery | `v0.2.0` | bestanden |
| FobSystem | `v0.2.0` | bestanden |
| MissionGenerator | `v0.2.3` | historische Pfade bestanden; aktueller Record-Verlust ungelöst |
| AICapManager | `v0.2.0` | bestanden |
| F10Menu | `v0.2.3` | bestanden |
| PersistenceSystem | `v0.2.6` | Embedded-Start und dirty-aware Scheduler bestanden |

Aktuelle Meilensteine:

- World State steht.
- Zone State steht.
- Capture State steht.
- Logistics State steht.
- FOB State steht.
- Mission State steht.
- AI CAP State steht.
- F10-Testbed steht.
- Persistence Background Autosave steht.

Nächster Meilenstein:

- Embedded-Source-Drift als möglichen Faktor des Mission-Record-Verlusts prüfen.

---

## 23. Einstieg für neue Sessions

Neue Sessions sollen zuerst den aktuellen GitHub-Stand prüfen.

Besonders prüfen:

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

Danach nicht aus Erinnerung arbeiten.

Nächster technischer Startpunkt:

- `TASKS.md`: Offline Embedded Mission Resource Audit

---

## Footer

Die Architektur folgt aktuell diesem Leitsatz:

- Erst State stabilisieren.
- Dann State persistent machen.
- Dann State-Änderungen persistenzrelevant markieren.
- Dann produktiven Restore kontrolliert freischalten.
- Dann Framework-Aktionen produktiv anbinden.
