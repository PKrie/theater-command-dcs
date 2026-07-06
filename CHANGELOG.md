# Changelog

Diese Datei dokumentiert die wichtigsten technischen Änderungen, getesteten Zwischenstände und Architekturentscheidungen für **Theater Command DCS**.

Projekt:
**Theater Command DCS**

Erste Kampagne:
**Operation Levant Reclamation**

Map:
**Syria**

Grundprinzip:

- Mission Editor = Bühne
- Lua = Kampagnensystem
- GitHub = Projektgedächtnis

---

## 2026-07-06

### Session-Schwerpunkt

Diese Session hat die Mission-Outcome-/Capture-Pipeline abgeschlossen und anschließend die technische Persistenzgrundlage bis zum Hintergrund-Autosave-Service aufgebaut.

Der Fokus lag bewusst weiterhin auf einer stabilen State-first-Grundlage:

- keine echten MOOSE-Spawns
- keine echten CTLD-Aktionen
- keine echten CTLD-FOBs
- keine echte Skynet-IADS-Kampagnenlogik
- keine produktive automatische Savegame-Wiederherstellung beim Missionsstart
- keine automatische DCS-Event-Auswertung für Missionserfolg
- kein produktiver Ownership-Wechsel durch DCS-Ereignisse

---

## F10Menu von v0.2.2 auf v0.2.3 erweitert

Datei:

- `src/ui/tc_f10_menu.lua`

Ziel:

- Mission Details direkt für Mission 1 bis 10 anzeigen
- Missionen direkt über F10 aktivieren
- Active Mission Outcome Status anzeigen
- Active Mission 1 state-only auf `COMPLETED` setzen
- Active Mission 1 state-only auf `FAILED` setzen
- Capture Ready Zones anzeigen
- Pressure Contested Zones anzeigen
- Capture Ready Zone 1 state-only anwenden

Bestätigter DCS-Logstatus:

- `F10Menu v0.2.3` lädt korrekt
- F10-Menü initialisiert stabil mit `commands=33`
- Mission Details Slot 1 funktioniert
- Mission Activation Slot 1 funktioniert
- Active Mission Outcome Status funktioniert
- Complete Active Mission 1 funktioniert
- Fail Active Mission 1 funktioniert
- Capture Ready Zones anzeigen funktioniert
- Apply Capture Ready Zone 1 funktioniert

Wichtige bestätigte Marker:

- `Mission details shown through F10`
- `Mission activated through F10`
- `Mission completed through F10`
- `Mission failed through F10`
- `Capture ready zones shown through F10`
- `Capture ready zone applied through F10`

Bewertung:

- Die Spieleroberfläche ist weiterhin state-only.
- Sie löst keine echten MOOSE-, CTLD- oder Skynet-Aktionen aus.
- Sie dient aktuell als kontrollierter Runtime-Testzugang.
- Persistence wurde bewusst nicht als Spieler-F10-Menü umgesetzt, weil Persistenz als Hintergrundsystem laufen soll.

---

## Mission Completion Pipeline bestätigt

Bestätigter Ablauf:

1. F10Menu zeigt Mission Details.
2. F10Menu aktiviert Mission 1.
3. MissionGenerator setzt Mission auf `ACTIVE`.
4. F10Menu setzt aktive Mission state-only auf `COMPLETED`.
5. MissionGenerator bereitet Mission Effects state-only vor.
6. CaptureSystem verarbeitet abgeschlossene Mission Effects.
7. CaptureSystem erzeugt Capture Pressure.
8. CaptureSystem setzt Capture Progress auf 100 %.
9. CaptureSystem erzeugt Capture Ready.
10. F10Menu zeigt Capture Ready Zones.
11. F10Menu wendet Capture Ready Zone 1 state-only an.
12. CaptureSystem setzt Zone Ownership state-only auf `BLUE`.
13. CaptureSystem synchronisiert die verknüpfte Airbase Ownership state-only auf `BLUE`.
14. Capture pressure wird zurückgesetzt.
15. Capture Ready geht zurück auf 0.

Bestätigter Testfall:

- completed mission: `MISSION_2`
- target zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- capture pressure owner: `BLUE`
- applied pressure: `105`
- progress: `100 %`
- appliedMissionEffects: `1`
- ready vorher: `1`
- ready nach Apply: `0`
- contested: `0`
- captured zone owner: `BLUE`
- linked airbase owner: `BLUE`

Bewertung:

- Die Mission-Outcome-to-Capture-Pipeline ist bestanden.
- Capture Ready Apply ist bestanden.
- Zone- und Airbase-Ownership können state-only verändert werden.
- Ein produktiver automatischer Capture-Workflow ist noch nicht aktiv.
- Persistenz-Hooks nach Ownership-Änderungen sind noch offen.

---

## Mission Failure Pipeline bestätigt

Bestätigter Ablauf:

1. F10Menu zeigt Mission Details.
2. F10Menu aktiviert Mission 1.
3. MissionGenerator setzt Mission auf `ACTIVE`.
4. F10Menu zeigt Active Mission Outcome Status.
5. F10Menu setzt aktive Mission state-only auf `FAILED`.
6. MissionGenerator setzt den Outcome auf `FAILED`.
7. MissionGenerator bereitet Failure Effects state-only vor.
8. CaptureSystem verarbeitet abgeschlossene Mission Effects.
9. CaptureSystem wendet bei `FAILED` aktuell keinen Capture Pressure an.

Bestätigter technischer Status:

- `Mission effects prepared state-only: status=FAILED`
- `Mission outcome prepared: [FAILED]`
- `Mission failed through F10`
- `Completed mission effects processed: applied=0, skipped=0, failed=0`
- `Capture progress updated: ready=0, contested=0, appliedMissionEffects=0`

Bewertung:

- Failure-Pfad ist bestanden.
- Failed Missions erzeugen aktuell bewusst keinen Capture Pressure.
- Das Verhalten ist für den aktuellen State-first-Teststand korrekt.

---

## PersistenceSystem v0.2.0 eingeführt

Datei:

- `src/campaign/tc_persistence_system.lua`

Ziel:

- DCS-Dateisystem-Sandbox prüfen
- `os`, `io`, `lfs`, `require` prüfen
- kontrolliert loggen, ob Dateizugriff möglich ist
- bestehende In-Memory-Snapshot-Funktionalität erhalten
- kein produktiver Save/Load-Betrieb

Erster Teststatus:

- `os=false`
- `io=false`
- `lfs=false`
- `require=false`

Bewertung:

- Modul lädt und startet.
- DCS blockiert Dateisystemzugriff zunächst vollständig.
- Kein Lua-Fehler.
- Kein Theater-Command-Fehler.
- Für Persistenz ist lokale Freigabe in `MissionScripting.lua` notwendig.

---

## Lokale DCS-Sandbox für Persistenz vorbereitet

Lokale DCS-Datei:

- `...\DCS World\Scripts\MissionScripting.lua`

Lokale Änderung:

- `io` entsperrt
- `lfs` entsperrt
- `os` weiterhin gesperrt
- `require` weiterhin gesperrt

Ziel:

- Dateioperationen im DCS Mission Scripting Environment ermöglichen
- Persistenzdateien unter `Saved Games\DCS.openbeta\TheaterCommandDCS` schreiben und lesen können

Bestätigter Status nach lokaler Änderung:

- `os=false`
- `io=true`
- `lfs=true`
- `require=false`

Bewertung:

- Lokale Sandbox-Freigabe funktioniert.
- Für Projektpersistenz reichen `io` und `lfs` aktuell aus.
- `os` bleibt bewusst deaktiviert.
- Bei DCS-Updates kann diese lokale Änderung überschrieben werden und muss dann erneut geprüft werden.

---

## PersistenceSystem v0.2.1

Ziel:

- Sandbox-Schreibtest korrigieren
- `file:write()` nicht mehr fälschlich wegen nil-Rückgabewert als Fehler werten
- nach Write direkt Read-Test entscheiden lassen

Bestätigter DCS-Logstatus:

- `io=true`
- `lfs=true`
- Sandbox-Datei wird geschrieben
- Sandbox-Datei wird gelesen
- Marker wird gefunden
- `fileSystemAvailable=true`

Bestätigter Pfad:

- `C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\tc_persistence_sandbox_test.lua`

Bewertung:

- DCS-Dateisystemzugriff ist technisch bestanden.
- Schreib-/Lesetest funktioniert.
- Persistenzgrundlage ist verfügbar.

---

## PersistenceSystem v0.2.2

Ziel:

- echten Campaign-State-Snapshot als Datei schreiben
- kein automatisches Laden
- kein produktiver Restore
- Save-Test einmalig nach Missionsstart

Bestätigter DCS-Logstatus:

- Sandbox-Test bestanden
- File Save Test geplant
- Campaign-State-Snapshot geschrieben

Bestätigter Save-Pfad:

- `C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua`

Bestätigte Marker:

- `Persistence file save test scheduled: delay=8s`
- `Campaign state file saved`

Bewertung:

- Erster echter Kampagnenzustand wurde als Lua-Return-Datei gespeichert.
- Save-Datei ist technisch erzeugbar.
- Produktiver Restore bleibt deaktiviert.

---

## PersistenceSystem v0.2.3

Ziel:

- gespeicherte Campaign-State-Datei lesen
- Dateiinhalt prüfen
- Lua-Return-Tabelle kompilieren
- Lua-Return-Tabelle evaluieren
- Snapshot-Struktur validieren
- noch keinen Import in `TC.State` durchführen

Bestätigter DCS-Logstatus:

- `load=true`
- `loadstring=true`
- `loadfile=true`
- Datei wurde gelesen
- Datei enthält Save-Marker
- Datei enthält `return { ... }`
- Datei konnte kompiliert werden
- Datei konnte evaluiert werden
- Snapshot wurde validiert
- `sections=10`
- `imported=false`

Bestätigter Marker:

- `Campaign state file validation passed`

Bewertung:

- Save-Datei ist nicht nur vorhanden, sondern auch strukturell verwendbar.
- Read/Compile/Evaluate/Validate-Pipeline ist bestanden.
- Noch kein Restore aktiv.

---

## PersistenceSystem v0.2.4

Ziel:

- gespeicherte Datei lesen
- Snapshot validieren
- Snapshot kontrolliert in `TC.State` importieren
- nur als verzögerter technischer Test
- kein produktiver automatischer Missionsstart-Restore

Bestätigter DCS-Logstatus:

- Save-Datei wurde geschrieben
- Save-Datei wurde validiert
- Snapshot wurde kontrolliert importiert
- `sections=10`
- `imported=true`
- `productiveRestore=false`

Bestätigte Marker:

- `Campaign state imported`
- `Campaign state file load test passed`
- `productiveRestore=false`

Bewertung:

- Vollständige technische Kette bestanden:

```text
State -> Snapshot -> Datei schreiben -> Datei lesen -> Datei validieren -> Lua auswerten -> Snapshot importieren
```

- Import funktioniert kontrolliert.
- Produktiver Auto-Restore bleibt deaktiviert.

---

## PersistenceSystem v0.2.5

Ziel:

- Persistence von Test-Timer-Kaskade auf Hintergrunddienst umstellen
- keine Spieler-F10-Bedienung
- keine Save-/Validate-/Load-Testtimer mehr
- interner Background-Autosave nach Missionsstart
- Save-/Validate-/Load-Funktionen intern erhalten
- produktiver Restore weiterhin deaktiviert

Technischer Stand:

- Autosave initial nach 20 Sekunden
- Autosave-Intervall: 120 Sekunden
- Save-Datei bleibt:

```text
C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua
```

Bestätigter DCS-Logstatus:

- `PersistenceSystem v0.2.5` lädt korrekt
- Sandbox-Test bestanden
- Autosave wurde geplant
- Autosave wurde automatisch ausgeführt
- `autosaveCount=1`
- `productiveRestore=false`

Bestätigte Marker:

- `Persistence autosave scheduled: initialDelay=20s interval=120s productiveRestore=false`
- `Persistence system initialized: sandboxStatus=PASSED, fileSystemAvailable=true, autosaveScheduled=true, autosaveInterval=120s, productiveRestore=false`
- `Campaign state autosaved`

Nicht mehr vorhandene Marker:

- `Persistence file save test scheduled`
- `Persistence file validation test scheduled`
- `Persistence file load test scheduled`
- `Campaign state file load test passed`

Bewertung:

- Persistenz läuft jetzt korrekt als unsichtbares Hintergrundsystem.
- Spieler müssen keine Persistenzaktionen über F10 auslösen.
- Save/Load-Funktionen bleiben intern vorhanden.
- Autosave ist aktiv.
- Produktiver Restore beim Missionsstart ist noch bewusst deaktiviert.
- Nächster sinnvoller Schritt ist ein Dirty-/Autosave-Hook in `tc_capture_system.lua`, damit relevante State-Änderungen gezielt persistenzrelevant markiert werden.

---

## Aktueller getesteter Modulstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.5` | bestanden |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | bestanden |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden |

---

## Aktuell bestätigte Kernwerte

Airbase Scanner:

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

ZoneFactory:

- relevant campaign zones: `46`
- skipped airbase-like objects: `179`
- captureZones: `32`
- missionZones: `32`
- logisticsZones: `46`
- startBaseZones: `1`

CaptureSystem:

- eligibleBases: `32`
- eligibleZones: `32`
- nonCaptureBases: `193`
- nonCaptureZones: `14`
- pressureRecords: `32`
- progressRecords: `32`

MissionGenerator:

- mission candidates: `78`
- fobSupportCandidates: `2`
- generated missions: `10`
- reservedCreated: `1`
- duplicatesSkipped: `1`
- typeLimitSkipped: `68`

F10Menu:

- commands: `33`

PersistenceSystem:

- fileSystemAvailable: `true`
- io: `true`
- lfs: `true`
- os: `false`
- require: `false`
- load: `true`
- loadstring: `true`
- loadfile: `true`
- autosaveScheduled: `true`
- autosaveInterval: `120s`
- autosaveCount im letzten Test: `1`
- productiveRestore: `false`

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

## Nächster sinnvoller technischer Schritt

Nächste Datei:

- `src/campaign/tc_capture_system.lua`

Ziel:

- CaptureSystem soll bei relevanten State-Änderungen Persistence informieren.
- Besonders bei erfolgreichem Capture Ready Apply soll der Kampagnenzustand als dirty markiert werden.
- Autosave soll diesen geänderten Zustand anschließend automatisch sichern.
- Kein F10-Persistence-Menü.
- Keine Spieleraktion für Save/Load.
- Kein produktiver Restore.
- Weiterhin state-first.

Erwarteter nächster Test:

1. Mission starten.
2. Mission über F10 aktivieren.
3. Mission über F10 abschließen.
4. Capture Ready Zone 1 über F10 anwenden.
5. CaptureSystem markiert State als persistenzrelevant.
6. Persistence autosaved automatisch.
7. Log bestätigt Dirty-/Autosave-Zusammenhang.
