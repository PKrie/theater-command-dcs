# Persistence

## Verbindliches Update — 2026-08-04

Die frühere Hotload-Testphase bleibt als historische Evidenz erhalten. Die anschließend offene Embedded-Scheduler-Grenze ist inzwischen geschlossen:

- PersistenceSystem `v0.2.6` wurde als `ResKey_advancedFile_56` / `tc_persistence_system_v0_2_6.lua` in die gespeicherte DEV-`.miz` eingebettet.
- Eingebettete Bytes entsprachen exakt `src/campaign/tc_persistence_system.lua`; der alte Trigger-Verweis `ResKey_Action_55` wurde entfernt.
- Normaler Mission-Editor-/Simulator-Start lud `v0.2.6` und startete den `20s`-/`120s`-Scheduler.
- Der reale Dirty-Grund `ai_cap_needs_evaluated` wurde als `SAVED` gesichert; Dirty wurde erst nach Verifikation gelöscht.
- Drei folgende unveränderte Ticks waren `SKIPPED`; Save-Dateigröße, Änderungszeit und SHA-256 blieben unverändert.
- Keine neuen Scripting Errors, `[TC][ERROR]` oder `[TC][WARN]`.

Weiter offen sind nur die derzeit durch den ungelösten Mission-Record-Verlust blockierten Mission Completion-, Mission Failure- und Capture Ready Apply Regressionen sowie der spätere produktive Restore. `productiveRestore=false` bleibt verbindlich.

Diese Datei beschreibt das Persistenzsystem von **Theater Command DCS**.

Projekt:

- Theater Command DCS

Erste Kampagne:

- Operation Levant Reclamation

Map:

- Syria

Grundprinzip:

- Mission Editor = Bühne
- Lua = Kampagnensystem
- GitHub = Projektgedächtnis

---

## 1. Zweck der Persistenz

Persistenz soll ermöglichen, dass der Kampagnenzustand über einzelne DCS-Missionsläufe hinaus erhalten bleibt.

Theater Command DCS soll langfristig nicht bei jedem Missionsstart vollständig neu beginnen.

Gespeichert werden sollen unter anderem:

- Besitzstatus von Airbases
- Besitzstatus von Zonen
- Capture-Pressure
- Capture-Progress
- Capture-Events
- Logistics Hubs
- FOB-Zustände
- verfügbare Missionen
- aktive Missionen
- abgeschlossene Missionen
- fehlgeschlagene Missionen
- AI-State
- IADS-State
- Ressourcen
- Kampagnenphase
- wichtige Kampagnenereignisse

Aktueller Stand:

- technische Dateipersistenz ist bestanden
- PersistenceSystem `v0.2.6` ist implementiert
- periodischer Background-Autosave ist dirty-aware implementiert
- Dirty-Save, unveränderter Skip, kontrollierter Schreibfehler und erfolgreicher Retry sind per DCS-SMS-Hotload getestet
- produktiver automatischer Restore beim Missionsstart ist bewusst noch deaktiviert

Persistence ist kein Spieler-F10-Feature.

Spieler sollen nicht manuell speichern oder laden müssen.

Persistence läuft im Hintergrund als Teil des Kampagnensystems.

---

## 2. Aktueller technischer Stand

Stand:

- 2026-08-04

Aktive Datei:

- `src/campaign/tc_persistence_system.lua`

Aktuelle getestete Version:

- `v0.2.6`

Status:

- bestanden

Architekturrolle:

- internes Hintergrundsystem
- kein Spieler-F10-Menü
- automatischer, dirty-aware Autosave im Hintergrund
- Save/Validate/Load-Funktionen intern vorhanden
- produktiver Restore noch deaktiviert

Aktuell bestätigt:

- PersistenceSystem wird in der Ladefolge eingebunden.
- PersistenceSystem lädt ohne Theater-Command-Lua-Fehler.
- PersistenceSystem startet sauber.
- DCS-Dateisystem-Sandbox wurde geprüft.
- `io` ist lokal verfügbar.
- `lfs` ist lokal verfügbar.
- `load`, `loadstring` und `loadfile` sind verfügbar.
- Campaign-State kann als Datei geschrieben werden.
- Save-Datei kann gelesen werden.
- Save-Datei kann kompiliert werden.
- Save-Datei kann evaluiert werden.
- Save-Datei kann strukturell validiert werden.
- Save-Datei kann kontrolliert in `TC.State` importiert werden.
- Test-Timer-Kaskade wurde entfernt.
- Background-Autosave wurde aktiviert.
- Periodischer Autosave speichert nur bei `dirty=true`.
- Unveränderte periodische Ticks werden ohne Dateischreibvorgang übersprungen.
- Jeder periodische Autosave-Entscheid wird als `SAVED`, `SKIPPED` oder `FAILED` geloggt.
- `SAVED` und `FAILED` enthalten den zugehörigen Dirty Reason.
- Vor dem Löschen des Dirty-State wird die Datei geschrieben, zurückgelesen, kompiliert, evaluiert und validiert.
- Fehlgeschlagene Schreib- oder Verifikationspfade behalten Dirty-State und Dirty Reason bei.
- Autosave läuft ohne Spieleraktion.
- `productiveRestore=false`

Bewertung:

- Die technische Persistenzgrundlage ist bestanden.
- Der Kampagnenzustand kann als Lua-Return-Datei gespeichert werden.
- Der Kampagnenzustand kann technisch wieder importiert werden.
- Produktiver Restore wird bewusst erst später freigeschaltet.
- Die v0.2.6-Autosave-Entscheidungen sind kontrolliert per Hotload getestet.
- Ein frischer vollständiger Missionsstart mit eingebetteter `v0.2.6` und realer 20-/120-Sekunden-Planung ist bestanden.

---

## 3. Lokale DCS-Voraussetzung

Damit DCS-Missionsskripte Dateien schreiben und lesen können, muss die lokale DCS-Sandbox angepasst sein.

Lokale Datei:

    ...\DCS World\Scripts\MissionScripting.lua

Anforderungen des Theater Command PersistenceSystems:

- `io` muss für Dateipersistenz entsperrt sein.
- `lfs` muss für Dateipersistenz entsperrt sein.
- PersistenceSystem benötigt `os` nicht direkt.
- PersistenceSystem benötigt `require` nicht direkt.

Zusätzliche Anforderungen der aktuell installierten DCS-SMS-Runtime-Bridge:

- Die Bridge-Befehle `exec`, `status` und `tail-log` benötigen `os`, `io` und `lfs` unsanitized in `MissionScripting.lua`.
- Solange diese DCS-SMS-Bridge-Funktionalität verwendet wird, dürfen `os`, `io` und `lfs` nicht erneut sanitisiert werden.

Aktuelle tatsächliche Entwicklungsumgebung:

- `os=true`
- `io=true`
- `lfs=true`
- `require=false`

`os=true` wurde durch die Installation der DCS-SMS-Bridge eingeführt, nicht durch den kontrollierten `v0.2.6`-Hotload. `os` könnte erst dann wieder sanitisiert werden, wenn die DCS-SMS-Runtime-Bridge entfernt wurde oder nicht mehr benötigt wird.

Historischer Pre-DCS-SMS-Status der eingebetteten `v0.2.5`:

- `os=false`
- `io=true`
- `lfs=true`
- `require=false`
- `load=true`
- `loadstring=true`
- `loadfile=true`
- `lfsFromRequire=false`
- `fileSystemAvailable=true`

Wichtig:

Nach DCS-Updates kann `MissionScripting.lua` überschrieben werden.

Wenn Persistence plötzlich wieder blockiert wird, zuerst prüfen:

- ist `io` wieder gesperrt?
- ist `lfs` wieder gesperrt?
- wurde `MissionScripting.lua` durch ein DCS-Update zurückgesetzt?

Wenn DCS-SMS `exec`, `status` oder `tail-log` nicht mehr funktionieren, zusätzlich prüfen, ob `os`, `io` oder `lfs` durch ein DCS-Update erneut sanitisiert wurden.

Typische Problem-Marker:

- `io=false`
- `lfs=false`
- `Persistence sandbox blocked`
- `file_system_unavailable`

---

## 4. Speicherort

Bestätigter Speicherordner:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS

Bestätigte Sandbox-Testdatei:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\tc_persistence_sandbox_test.lua

Bestätigte Campaign-Save-Datei:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Aktuell verwendeter Saved-Games-Pfad:

    Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Aktuelles Save-Dateiformat:

- Lua-Return-Datei
- Formatmarker: `TC_LUA_TABLE_V1`
- Save-Marker: `TC_CAMPAIGN_STATE_SAVE`
- Datei gibt eine Lua-Tabelle zurück

Bewertung:

- Der Speicherort liegt bewusst unter `Saved Games`.
- Es wird nicht in das DCS-Installationsverzeichnis geschrieben.
- Die Save-Datei ist lesbar und als Lua-Tabelle interpretierbar.
- Das Format ist aktuell entwicklungsfreundlich und debugbar.

---

## 5. Technische Entwicklungsschritte

### 5.1 PersistenceSystem v0.2.0

Ziel:

- DCS-Dateisystem-Sandbox prüfen
- `os`, `io`, `lfs`, `require` prüfen
- kontrolliert loggen, ob Dateizugriff möglich ist
- bestehende In-Memory-Snapshot-Funktionalität erhalten
- kein produktiver Save/Load-Betrieb

Historischer Pre-DCS-SMS-Erstteststatus:

- `os=false`
- `io=false`
- `lfs=false`
- `require=false`

Bewertung:

- Modul lud und startete.
- DCS blockierte Dateisystemzugriff zunächst vollständig.
- Kein Lua-Fehler.
- Kein Theater-Command-Fehler.
- Lokale Sandbox-Freigabe war notwendig.

---

### 5.2 PersistenceSystem v0.2.1

Ziel:

- Sandbox-Schreibtest korrigieren
- `file:write()` nicht mehr fälschlich wegen nil-Rückgabewert als Fehler werten
- nach Write direkt Read-Test entscheiden lassen

Bestätigter DCS-Logstatus:

- `io=true`
- `lfs=true`
- Sandbox-Datei wurde geschrieben
- Sandbox-Datei wurde gelesen
- Marker wurde gefunden
- `fileSystemAvailable=true`

Bestätigter Pfad:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\tc_persistence_sandbox_test.lua

Bewertung:

- DCS-Dateisystemzugriff ist technisch bestanden.
- Schreib-/Lesetest funktioniert.
- Persistenzgrundlage ist verfügbar.

---

### 5.3 PersistenceSystem v0.2.2

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

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Bestätigte Marker:

- `Persistence file save test scheduled: delay=8s`
- `Campaign state file saved`

Bewertung:

- Erster echter Kampagnenzustand wurde als Lua-Return-Datei gespeichert.
- Save-Datei ist technisch erzeugbar.
- Produktiver Restore blieb deaktiviert.

---

### 5.4 PersistenceSystem v0.2.3

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
- Datei enthielt Save-Marker
- Datei enthielt `return { ... }`
- Datei konnte kompiliert werden
- Datei konnte evaluiert werden
- Snapshot wurde validiert
- `sections=10`
- `imported=false`

Bestätigter Marker:

- `Campaign state file validation passed`

Bewertung:

- Save-Datei ist nicht nur vorhanden, sondern strukturell verwendbar.
- Read/Compile/Evaluate/Validate-Pipeline ist bestanden.
- Noch kein Restore aktiv.

---

### 5.5 PersistenceSystem v0.2.4

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

    State -> Snapshot -> Datei schreiben -> Datei lesen -> Datei validieren -> Lua auswerten -> Snapshot importieren

- Import funktioniert kontrolliert.
- Produktiver Auto-Restore blieb deaktiviert.

---

### 5.6 PersistenceSystem v0.2.5

Ziel:

- Persistence von Test-Timer-Kaskade auf Hintergrunddienst umstellen
- keine Spieler-F10-Bedienung
- keine Save-/Validate-/Load-Testtimer mehr
- interner Background-Autosave nach Missionsstart
- Save-/Validate-/Load-Funktionen intern erhalten
- produktiver Restore weiterhin deaktiviert

Technischer Stand:

- erster Autosave nach 20 Sekunden
- danach Autosave alle 120 Sekunden
- Save-Datei bleibt `operation_levant_reclamation_save.lua`
- kein F10-Persistence-Menü
- kein produktiver Restore

Bestätigter DCS-Logstatus:

- `PersistenceSystem v0.2.5` lädt korrekt
- Sandbox-Test bestanden
- Autosave wurde geplant
- Autosave wurde automatisch ausgeführt
- `autosaveCount=1`
- `productiveRestore=false`

Bestätigte Marker:

- `Loaded src/campaign/tc_persistence_system.lua v0.2.5`
- `Persistence sandbox file test passed`
- `Persistence autosave scheduled: initialDelay=20s interval=120s productiveRestore=false`
- `Persistence system initialized: sandboxStatus=PASSED, fileSystemAvailable=true, autosaveScheduled=true, autosaveInterval=120s, productiveRestore=false`
- `Campaign state autosaved`

Nicht mehr vorhandene alte Testmarker:

- `Persistence file save test scheduled`
- `Persistence file validation test scheduled`
- `Persistence file load test scheduled`
- `Campaign state file load test passed`

Bewertung:

- Persistenz läuft jetzt korrekt als unsichtbares Hintergrundsystem.
- Spieler müssen keine Persistenzaktionen über F10 auslösen.
- Save/Validate/Load-Funktionen bleiben intern vorhanden.
- Autosave ist aktiv.
- Produktiver Restore beim Missionsstart ist bewusst deaktiviert.
- Der damalige nächste Schritt war die später umgesetzte dirty-aware Autosave-Auswertung.

---

### 5.7 PersistenceSystem v0.2.6

Ziel:

- periodischen Autosave mit dem vorhandenen `TC.State.Persistence`-Dirty-State verbinden
- unveränderte Ticks ohne Schreibzugriff überspringen
- Dirty-State erst nach vollständig verifiziertem Save löschen
- Fehler- und Retry-Pfade nachvollziehbar halten
- produktiven Restore weiterhin deaktiviert lassen

Implementierter Stand:

- `TC.State.Persistence.dirty`, `dirtyReason` und `dirtyAt` sind die einzige Dirty-State-Quelle.
- `dirty=false` führt zu `SKIPPED`, ohne die Save-Datei zu schreiben.
- `dirty=true` führt einen Save-Versuch aus.
- Die Save-Datei wird geschrieben, zurückgelesen, kompiliert, evaluiert und strukturell validiert.
- Erst nach dieser Verifikation darf der zu Beginn erfasste Dirty-State gelöscht werden.
- Schreib-, Read-back-, Compile-, Evaluate- oder Validation-Fehler führen zu `FAILED` und behalten Dirty-State sowie Dirty Reason bei.
- Ein späterer Retry kann denselben Dirty-State erfolgreich als `SAVED` sichern.
- Ändern sich `dirtyReason` oder `dirtyAt` während des Saves, wird der neuere Dirty-State nicht gelöscht.
- Manuelle `saveToFile()`-Aufrufe löschen Dirty nach verifiziertem Erfolg weiterhin standardmäßig.
- Periodischer Autosave ruft `saveToFile()` mit aufgeschobenem Dirty-Clear auf und entscheidet erst nach der Verifikation über das Löschen.
- Der Initial-Delay bleibt `20s`, das Intervall bleibt `120s`.
- Es existieren keine Persistence-F10-Controls; für diese Entwicklungsstufe sind auch keine vorgesehen.
- Autosave erfordert keine Spielerinteraktion.
- Produktiver Restore bleibt deaktiviert.

Bestätigte DCS-SMS-Hotload-Pfade:

- Dirty Save: `SAVED`; Dirty wurde nach erfolgreicher Verifikation gelöscht.
- Zweiter unveränderter Aufruf: `SKIPPED`; Autosave Count blieb unverändert.
- Kontrolliert injizierter Schreibfehler: `FAILED`; Dirty und Dirty Reason blieben erhalten, die bestehende Save-Datei blieb unverändert.
- Retry nach Wiederherstellung von `io.open`: `SAVED`; Dirty wurde erst nach erfolgreicher Verifikation gelöscht.
- Während dieser Tests traten keine neuen `SCRIPTING ERROR`, `Mission script error` oder `stack traceback` auf.

---

## 6. Aktueller getesteter Gesamtstand

Stand:

- 2026-08-04

Bestätigte Systeme:

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | Hotload- und Embedded-Scheduler bestanden |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | historische Pfade bestanden; aktueller Record-Verlust ungelöst |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden |

Aktuelle bestätigte Werte:

- Syria airbase-like objects: `225`
- relevante Kampagnenzonen: `46`
- capture-fähige Ziele: `32`
- Capture-Pressure-Records: `32`
- Capture-Progress-Records: `32`
- Logistics Hubs: `46`
- FOB-Kandidaten: `6`
- Blue FOBs: `2`
- Mission candidates: `78`
- verfügbare Missionen: `10`
- F10 Commands: `33`
- CAP Requests: `12`
- Persistence fileSystemAvailable: `true`
- eingebettete `v0.2.5`-Runtime während der Hotload-Tests: `autosaveScheduled=true`
- hot-geloadete `v0.2.6`: kein eigener Scheduler gestartet
- `v0.2.6` Autosave Count nach Dirty Save: `1`
- unveränderter Skip und injizierter Fehler erhöhten den `v0.2.6` Autosave Count nicht

Bewertung:

- Die vorhandene State- und Dirty-Grundlage wird von `v0.2.6` verwendet.
- Die synchronen Autosave-Entscheidungspfade sind in einer laufenden DEV-Mission bestätigt.
- `v0.2.6` ist in die gespeicherte Mission eingebettet und durch einen frischen vollständigen Missionsstart getestet.

---

## 7. Designprinzip

Auch für Persistenz gilt das Theater-Command-Grundprinzip:

- erst State
- dann Sichtbarkeit
- dann Tests
- dann Persistenz
- dann produktiver Restore
- dann echte Framework-Aktionen

Persistenz speichert Theater-Command-State.

Persistenz speichert nicht direkt:

- MOOSE-Objekte
- CTLD-Objekte
- Skynet-Objekte
- DCS-Objektreferenzen
- nicht serialisierbare Runtime-Handles

Wichtig:

Framework-Zustände werden später indirekt über eigenen Theater-Command-State rekonstruiert.

Beispiele:

- nicht MOOSE-Gruppe speichern, sondern CAP-Request und Mission-State speichern
- nicht CTLD-Crate-Objekt speichern, sondern gelieferte Supply-Menge speichern
- nicht Skynet-Objekt speichern, sondern IADS-Knotenstatus speichern

---

## 8. State-first als Voraussetzung

Persistenz speichert nicht direkt DCS-Objekte.

Persistenz speichert Theater-Command-State.

Zentraler Zustand:

- `TC.State`
- `TC.state`

Aktuelle relevante State-Bereiche:

- `State.Meta`
- `State.Campaign`
- `State.World`
- `State.Bases`
- `State.Zones`
- `State.Logistics`
- `State.Missions`
- `State.AI`
- `State.IADS`
- `State.Persistence`

PersistenceSystem `v0.2.6` speichert aktuell diese zehn Snapshot-Sektionen.

Bestätigt:

- `sections=10`

Wichtig:

- Framework-Objekte von MOOSE, CTLD oder Skynet werden nicht direkt gespeichert.
- Gespeichert wird der eigene Theater-Command-Kampagnenzustand.
- Runtime-Objekte werden später bei Bedarf aus State neu aufgebaut.

---

## 9. Was aktuell gespeichert wird

Aktuell wird als Snapshot der serialisierbare Theater-Command-State gespeichert.

Gespeichert werden aktuell unter anderem die vorhandenen Strukturen in:

- `Meta`
- `Campaign`
- `World`
- `Bases`
- `Zones`
- `Logistics`
- `Missions`
- `AI`
- `IADS`
- `Persistence`

Bestätigt:

- Campaign-State wird als Datei geschrieben.
- Save-Datei enthält einen Marker.
- Save-Datei enthält eine Lua-Return-Tabelle.
- Save-Datei enthält zehn Snapshot-Sektionen.
- Save-Datei kann gelesen und validiert werden.
- Save-Datei kann kontrolliert importiert werden.
- Dirty-aware Autosave schreibt geänderten State im Hintergrund und überspringt unveränderte Ticks.

Noch nicht abgeschlossen:

- vollständige fachliche Prüfung der vorhandenen Dirty-Markierungen in allen aktiven State-Systemen
- produktiver Auto-Restore beim Missionsstart
- Save-Datei-Rotation
- Save-Datei-Backup
- Migrationslogik zwischen Save-Versionen
- produktiver Umgang mit inkompatiblen Save-Dateien

---

## 10. Was aktuell noch nicht produktiv geladen wird

Obwohl technische Importfähigkeit bestätigt ist, wird der Save-State noch nicht produktiv beim Missionsstart wiederhergestellt.

Nicht aktiv:

- kein automatischer produktiver Load beim Missionsstart
- kein produktiver Restore von Ownership beim Start
- kein produktiver Restore von Mission State beim Start
- kein produktiver Restore von FOBs beim Start
- kein produktiver Restore von Logistics Supply beim Start
- kein produktiver Restore von AI- oder IADS-Zustand
- kein Wiederaufbau realer MOOSE-/CTLD-/Skynet-Objekte aus Save-State

Grund:

- Der frische Embedded-Start und die normale 20-/120-Sekunden-Planung von `v0.2.6` sind bestätigt.
- Die vorhandene Dirty-Abdeckung der Fachsysteme muss vollständig geprüft werden.
- Restore-Reihenfolge muss definiert werden.
- Save-Datei-Kompatibilität muss geprüft werden.
- Framework-Aktionen dürfen nicht zu früh durch Restore ausgelöst werden.

Aktuelle Entscheidung:

- `productiveRestore=false`
- Produktiver Restore wird erst nach vollständigem Embedded-Regressionstest und dokumentierter Restore-Reihenfolge freigeschaltet.

---

## 11. Autosave-Verhalten

Aktuelles Autosave-Verhalten in `v0.2.6`:

- Autosave ist aktiviert und wird beim Start des PersistenceSystems geplant.
- Der Initial-Delay bleibt `20` Sekunden.
- Das periodische Intervall bleibt `120` Sekunden.
- Autosave läuft ohne Spieleraktion.
- Autosave nutzt ausschließlich den vorhandenen Dirty-State unter `TC.State.Persistence`:
  - `dirty`
  - `dirtyReason`
  - `dirtyAt`
- Bei `dirty=false` wird der Tick als `SKIPPED` protokolliert und die Save-Datei nicht geschrieben.
- Bei `dirty=true` werden Dirty Reason und Dirty-Zeitpunkt vor dem Save-Versuch erfasst.
- Die Save-Datei wird geschrieben, zurückgelesen, kompiliert, evaluiert und strukturell validiert.
- Erst nach dieser vollständigen Verifikation darf der erfasste Dirty-State gelöscht werden.
- Ein fehlgeschlagener Write-, Read-back-, Compile-, Evaluate- oder Validation-Pfad wird als `FAILED` protokolliert und behält Dirty-State sowie Dirty Reason bei.
- Nach Behebung der Fehlerursache kann derselbe Dirty-State bei einem späteren Retry als `SAVED` gesichert werden.
- Wenn während eines laufenden Saves ein neuer Dirty-State mit anderem `dirtyReason` oder `dirtyAt` entsteht, löscht der ältere Save diesen neueren State nicht.
- Manuelle `saveToFile()`-Aufrufe löschen Dirty nach verifiziertem Erfolg standardmäßig weiterhin.
- Periodischer Autosave verwendet `clearDirtyOnSuccess=false` und übernimmt das Dirty-Clear erst nach seiner eigenen Verifikations- und Vergleichslogik.
- Produktiver Restore bleibt deaktiviert.

Periodische Entscheidungslogs:

- `Periodic autosave decision: SAVED`
- `Periodic autosave decision: SKIPPED`
- `Periodic autosave decision: FAILED`

Für `SAVED` und `FAILED` enthält das Log den relevanten Dirty Reason. Die letzten Ergebnisse werden außerdem über `lastAutosaveStatus`, `lastAutosaveReason` und `lastAutosaveDirtyReason` im Modul und in `TC.State.Persistence` gehalten.

Wichtig:

- Autosave ist kein Spieler-F10-Menü.
- Für diese Entwicklungsstufe existieren keine Persistence-F10-Controls und es sind keine vorgesehen.
- Autosave ist kein manueller Spielerworkflow.
- Autosave läuft im Maschinenraum.
- Der Spieler muss im Normalbetrieb keine Save-Aktion auslösen.

Aktuell verwendete Save-Datei:

    Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Testabgrenzung:

- Die Entscheidungspfade von `v0.2.6` wurden synchron per kontrolliertem DCS-SMS-Hotload getestet.
- Der echte Scheduler der hot-geloadeten `v0.2.6` wurde bewusst nicht gestartet.
- Ein normaler Missionsstart mit eingebetteter `v0.2.6` und den tatsächlichen 20-/120-Sekunden-Ticks ist bestanden.

---

## 12. Geplanter Speicherumfang

Langfristig soll Persistenz mehrere Bereiche speichern.

Geplante Bereiche:

- Metadata
- Campaign
- Bases
- Zones
- Capture
- Logistics
- FOBs
- Missions
- AI
- IADS
- Events
- Versioning

Diese Bereiche sollen robust, lesbar und erweiterbar bleiben.

Wichtig:

- Der aktuelle Snapshot ist bereits breiter als die späteren Einzelmodelle.
- Langfristig kann das Save-Format stärker strukturiert und versioniert werden.
- Aktuell ist das Ziel noch robuste technische Save-/Load-Grundlage.

---

## 13. Metadata

Metadata enthält Informationen zur Save-Datei.

Aktuelle beziehungsweise geplante Felder:

- marker
- project
- module
- moduleVersion
- version
- campaign
- map
- createdAt
- format
- stateOnly
- autoLoad
- productiveRestore
- productiveRestoreEnabled
- autosave

Aktuelle Marker:

- `TC_CAMPAIGN_STATE_SAVE`
- `TC_LUA_TABLE_V1`

Zweck:

- Save-Dateien müssen eindeutig interpretierbar sein.
- Save-Dateien müssen später auf Kompatibilität geprüft werden.
- Inkompatible Save-Dateien dürfen die Mission nicht zerstören.

---

## 14. Campaign State

Campaign State soll den übergeordneten Kampagnenzustand speichern.

Mögliche beziehungsweise vorhandene Inhalte:

- campaignId
- campaignName
- mapName
- phase
- day
- turn
- blueProgress
- redProgress
- currentFrontState
- activeObjectives
- completedObjectives
- failedObjectives
- lastUpdate
- eventHistory

Aktueller Stand:

- Campaign State ist in Grundzügen vorhanden.
- Ein produktives Kampagnenphasenmodell ist noch nicht final.
- Campaign State wird im Snapshot gespeichert.

Persistenzziel:

- Kampagnenfortschritt soll später über Missionsneustarts erhalten bleiben.

---

## 15. Airbase-Persistenz

Airbase State soll speichern:

- airbaseKey
- name
- category
- coalition
- owner
- position
- strategicRelevance
- captureCandidate
- missionCandidate
- logisticsCandidate
- linkedZone
- damageState
- operationalState
- lastOwnerChange
- eventHistory

Aktuelle Grundlage:

- Airbase Scanner `v0.2.2` klassifiziert 225 airbase-like objects.
- 32 Objekte sind capture-/mission-fähig.
- 46 Objekte sind logistics-fähig.
- Akrotiri ist Blue Start Base.
- linked Airbase Ownership kann durch Capture Ready Apply state-only geändert werden.

Bestätigter Fall:

- linked airbase: `Abu al-Duhur`
- owner nach Capture Apply: `BLUE`

Persistenzziel:

- Airbase-Besitz und wichtige Airbase-Zustände sollen nach Missionsneustart erhalten bleiben.

Noch offen:

- vorhandene Dirty-Markierung bei Airbase-Ownership-Änderungen im vollständigen `v0.2.6`-Regressionstest bestätigen
- produktiver Restore von Airbase Ownership
- Kopplung an Logistics, MissionGenerator und AI

---

## 16. Zone-Persistenz

Zone State soll speichern:

- zoneKey
- name
- type
- owner
- coalition
- linkedBase
- position
- radius
- captureEnabled
- missionEnabled
- logisticsEnabled
- startBase
- status
- lastUpdate

Aktuelle Grundlage:

- ZoneFactory `v0.2.0` erzeugt 46 relevante Kampagnenzonen.
- Davon sind 32 Capture-Zonen.
- Davon sind 32 Mission-Zonen.
- Davon sind 46 Logistics-Zonen.
- Zone Ownership kann durch Capture Ready Apply state-only geändert werden.

Bestätigter Fall:

- zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- owner nach Capture Apply: `BLUE`

Persistenzziel:

- Zone-Besitz und Zone-Status sollen über Missionsneustarts erhalten bleiben.

Noch offen:

- vorhandene Dirty-Markierung bei Zone-Ownership-Änderungen im vollständigen `v0.2.6`-Regressionstest bestätigen
- produktiver Restore von Zone Ownership
- automatische Zone-Auswertung über reale DCS-Einheiten

---

## 17. Capture-Persistenz

Capture State soll speichern:

- eligibleBases
- eligibleZones
- captureEvents
- pressureRecords
- progressRecords
- readyZones
- contestedZones
- appliedMissionEffects
- lastCaptureUpdate
- ownershipChanges

Aktuelle Grundlage:

- CaptureSystem `v0.2.2` erzeugt 32 Pressure-Records.
- CaptureSystem `v0.2.2` erzeugt 32 Progress-Records.
- Mission Completion kann Capture Pressure erzeugen.
- Mission Failure erzeugt aktuell bewusst keinen Capture Pressure.
- Capture Ready kann state-only angewendet werden.
- Zone Ownership kann state-only aktualisiert werden.
- linked Airbase Ownership kann state-only synchronisiert werden.

Bestätigter Mission-Completion-Fall:

- completed mission: `MISSION_2`
- target zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- owner: `BLUE`
- pressure: `105`
- progress: `100 %`
- ready: `1`
- contested: `0`

Bestätigter Capture-Apply-Fall:

- zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- owner: `BLUE`
- linked airbase: `Abu al-Duhur`
- ready danach: `0`

Persistenzziel:

- Capture Pressure und Capture Progress sollen nicht nach jedem Missionsstart verloren gehen.
- Capture Ready und Ownership-Wechsel sollen später über Missionsneustarts erhalten bleiben.

Aktueller Persistenzstand:

- CaptureSystem und weitere aktive State-Systeme enthalten bereits Dirty-Markierungen.
- `v0.2.6` wertet diese Markierungen über `TC.State.Persistence` aus.
- Noch ausstehend ist der vollständige Embedded-Regressionstest von Mission Completion, Mission Failure und Capture Ready Apply mit anschließender geplanter `v0.2.6`-Autosave-Auswertung.

---

## 18. Logistics-Persistenz

Logistics State soll speichern:

- hubId
- hubName
- owner
- status
- supply
- fuel
- ammo
- engineering
- repairCapacity
- linkedZone
- linkedBase
- cargoRequired
- cargoDelivered
- deliveryHistory
- lastUpdate

Aktuelle Grundlage:

- LogisticsDelivery `v0.2.0` erzeugt 46 Logistics Hubs.
- Blue Hubs: `7`
- Red Hubs: `24`
- Neutral Hubs: `15`
- Active Hubs: `31`
- Limited Hubs: `15`
- Locked Hubs: `0`

Persistenzziel:

- Logistics Hubs sollen später ihren Vorrat, Zustand und Verlauf behalten.

Aktuelle Einschränkung:

- Es gibt noch keine echten CTLD-Cargo-Aktionen.
- Es gibt noch keinen produktiven Supply-Verbrauch.
- Die vorhandene Logistics-Dirty-Abdeckung muss vor produktivem Restore vollständig geprüft werden.

---

## 19. FOB-Persistenz

FOB State soll speichern:

- fobId
- name
- owner
- status
- linkedHub
- linkedZone
- linkedBase
- buildProgress
- supply
- fuel
- ammo
- engineering
- repairState
- facilities
- damageState
- cargoDelivered
- cargoRequired
- eventHistory

Aktuelle Grundlage:

- FobSystem `v0.2.0` erzeugt 6 FOB-Kandidaten.
- 2 Blue-FOBs werden automatisch state-only angelegt.
- `FOB Ercan`
- `FOB Gecitkale`
- Status: `UNDER_CONSTRUCTION`

Persistenzziel:

- FOB-Status, Baufortschritt, Versorgung und Schäden sollen erhalten bleiben.

Aktuelle Einschränkung:

- Es gibt noch keine echte CTLD-FOB-Erstellung.
- Es gibt noch keine echten CTLD-Crates.
- Die vorhandene FOB-Dirty-Abdeckung muss vor produktivem Restore vollständig geprüft werden.

---

## 20. Mission-Persistenz

Mission State soll speichern:

- missionId
- missionKey
- title
- type
- owner
- targetZone
- targetBase
- status
- priority
- objectives
- briefing
- progress
- activation
- outcome
- effects
- createdAt
- activatedAt
- completedAt
- failedAt
- expiry
- linkedHooks

Aktuelle Grundlage:

- MissionGenerator `v0.2.3` erzeugt 10 Missionen.
- Mission Candidates: `78`
- FOB-Support-Candidates: `2`
- reservedCreated: `1`
- duplicatesSkipped: `1`
- typeLimitSkipped: `68`

Bestätigt:

- Missionen können state-only aktiviert werden.
- Missionen können state-only auf `COMPLETED` gesetzt werden.
- Missionen können state-only auf `FAILED` gesetzt werden.
- Mission Effects werden state-only vorbereitet.
- Completed Mission Effects können Capture Pressure erzeugen.
- Failed Mission Effects erzeugen aktuell keinen Capture Pressure.

Persistenzziel:

- Verfügbare, aktive, abgeschlossene und fehlgeschlagene Missionen sollen über Missionsneustarts erhalten bleiben.

Noch offen:

- vollständige Prüfung der vorhandenen Mission-Dirty-Abdeckung
- produktiver Restore von Mission State
- automatische Missionserfolgsauswertung aus DCS-Events
- Mission Cancel/Expire Tests

---

## 21. AI-Persistenz

AI State soll speichern:

- CAP-Zonen
- CAP Requests
- aktive AI-Aufträge
- abgeschlossene AI-Aufträge
- AI-Verluste
- Bedrohungsbewertung
- Reaktionsstatus
- Blue-/Red-Operationsplanung
- Prioritäten
- verfügbare Ressourcen

Aktuelle Grundlage:

- AICapManager `v0.2.0` erzeugt CAP State.
- cap zone candidates: `31`
- auto-registered CAP zones: `12`
- CAP requests: `12`
- reactionState: `AIR_REACTION_REQUESTED`
- threatLevel: `HIGH`

Persistenzziel:

- AI-Planung, CAP-Bedarf und spätere Operationen sollen über Missionsneustarts erhalten bleiben.

Aktuelle Einschränkung:

- Es gibt noch keine echten MOOSE-Spawns.
- MOOSE-Hooks bleiben reserviert.
- Die vorhandene AI-Dirty-Abdeckung muss vor produktivem Restore vollständig geprüft werden.

---

## 22. IADS-Persistenz

IADS State soll später speichern:

- IADS-Netzwerke
- SAM-Knoten
- EWR-Knoten
- Radarstatus
- Launcherstatus
- Munition
- Reparaturstatus
- Unterdrückung
- zerstörte Systeme
- zuletzt bekannte Bedrohungen
- Verknüpfung mit MissionGenerator

Aktuelle Grundlage:

- Skynet IADS liegt als Vendor unter `vendor/skynet-iads/`.
- IADS ist dokumentiert und vorbereitet.
- Es gibt noch keine produktive Theater-Command-IADS-Kampagnenlogik.

Persistenzziel:

- IADS-Schäden, Ausfälle, Unterdrückung und Reparatur sollen über Missionsneustarts erhalten bleiben.

Aktuelle Einschränkung:

- IADS-Modul ist noch nicht produktiv aktiv.
- IADS Dirty-Hooks sind noch offen.

---

## 23. Save-Datei-Aufbau

Aktuelles Format:

- Lua-Return-Datei
- lesbar
- debugbar
- direkt durch `loadstring`/`load` kompilierbar
- mit Marker und Format versehen

Konzeptueller Aufbau:

    return {
      meta = {
        marker = "TC_CAMPAIGN_STATE_SAVE",
        format = "TC_LUA_TABLE_V1",
        campaign = "Operation Levant Reclamation",
        map = "Syria",
        productiveRestore = false
      },
      data = {
        Campaign = {},
        World = {},
        Bases = {},
        Zones = {},
        Logistics = {},
        Missions = {},
        AI = {},
        IADS = {},
        Persistence = {}
      }
    }

Wichtig:

- Save-Datei enthält kein ausführbares Kampagnenverhalten.
- Save-Datei enthält State.
- Save-Datei wird vor Import validiert.
- Produktiver Restore bleibt deaktiviert.

---

## 24. Save/Load-Sicherheitsregeln

Persistence muss defensiv bleiben.

Regeln:

- Save-Datei nur lesen, wenn Datei vorhanden ist.
- Save-Datei nur nutzen, wenn Marker stimmt.
- Save-Datei nur nutzen, wenn Format stimmt.
- Save-Datei nur nutzen, wenn notwendige Sektionen vorhanden sind.
- Save-Datei nur importieren, wenn Validierung bestanden ist.
- Fehler beim Lesen dürfen die Mission nicht abbrechen.
- Fehler beim Import dürfen die Mission nicht zerstören.
- Produktiver Restore darf nur bewusst aktiviert werden.
- Inkompatible Save-Dateien müssen später sauber abgelehnt werden.

Aktueller Status:

- Markerprüfung vorhanden
- Formatprüfung vorhanden
- Strukturprüfung vorhanden
- kontrollierter Import bestätigt
- produktiver Restore deaktiviert

Später ergänzen:

- Save-Versionierung
- Schema-Versionierung
- Save-Datei-Backup
- Save-Datei-Rotation
- Recovery bei beschädigter Save-Datei
- Fallback auf frischen Kampagnenstart

---

## 25. Dirty-State-Konzept

Der Dirty-State gehört zum zentralen State und wird nicht als zweiter Mechanismus im PersistenceSystem dupliziert.

Verwendete Felder unter `TC.State.Persistence`:

- `dirty`: zeigt an, ob speicherrelevante Änderungen vorliegen
- `dirtyReason`: beschreibt die zuletzt markierte Änderung
- `dirtyAt`: Zeitstempel dieser Markierung

`TC.State.markDirty(reason)` setzt diese drei Werte. `TC.State.clearDirty()` setzt `dirty=false` und entfernt `dirtyReason` sowie `dirtyAt`.

Aktueller `v0.2.6`-Ablauf:

1. Ein Fachsystem markiert eine speicherrelevante State-Änderung über den vorhandenen `TC.State`-Mechanismus.
2. Der periodische Autosave überspringt `dirty=false` ohne Dateischreibvorgang.
3. Bei `dirty=true` erfasst er `dirtyReason` und `dirtyAt` vor dem Save.
4. `saveToFile()` schreibt die Datei und verifiziert sie durch Read-back, Compile, Evaluate und Validation.
5. Bei einem Fehler bleiben `dirty`, `dirtyReason` und `dirtyAt` erhalten.
6. Bei Erfolg vergleicht Autosave den aktuellen Dirty Reason und Zeitstempel mit den erfassten Werten.
7. Nur wenn derselbe Dirty-State noch aktuell ist, wird er gelöscht.
8. Ein während des Saves entstandener neuer Dirty-State bleibt erhalten.

Manuelle `saveToFile()`-Aufrufe löschen Dirty nach verifiziertem Erfolg weiterhin standardmäßig. Nur der periodische Autosave setzt `clearDirtyOnSuccess=false`, damit seine eigene Vergleichslogik das Löschen nach vollständiger Verifikation kontrolliert.

Dirty-Abdeckung, die weiter geprüft oder später erweitert werden muss:

- Mission aktiviert
- Mission abgeschlossen
- Mission fehlgeschlagen
- Capture Pressure geändert
- Zone Ownership geändert
- Airbase Ownership geändert
- Logistics Supply geändert
- FOB-Baufortschritt geändert
- AI-Auftrag geändert
- IADS-Zustand geändert

---

## 26. Produktiver Restore

Produktiver Restore bedeutet:

- Missionsstart prüft vorhandene Save-Datei
- Save-Datei wird validiert
- Save-Datei wird importiert
- Kampagnenzustand wird aus Save-Datei wiederhergestellt
- Runtime-Systeme arbeiten mit restored State weiter

Aktueller Status:

- technische Importfähigkeit bestanden
- produktiver Restore deaktiviert
- `productiveRestore=false`

Warum noch deaktiviert:

- Die ersten v0.2.6-Tests erfolgten historisch als kontrollierter Hotload in eine laufende DEV-Mission, deren normale `DO SCRIPT FILE`-Kopie noch `v0.2.5` enthielt.
- Der anschließende vollständige Missionsstart mit eingebetteter `v0.2.6` und die echte geplante 20-/120-Sekunden-Ausführung sind bestanden.
- Mission Completion, Mission Failure, Capture Ready Apply und allgemeine Regressionen mit eingebetteter `v0.2.6` bleiben ausstehend und sind aktuell durch den ungeklärten Verlust der generierten Missionstabellen blockiert.
- Restore-Reihenfolge muss definiert werden.
- Initialisierung darf nicht überschrieben oder beschädigt werden.
- Framework-Aktionen dürfen nicht versehentlich durch Restore ausgelöst werden.

Voraussetzungen vor Aktivierung:

- frischer vollständiger Missionsstart mit eingebetteter `v0.2.6` bestanden (erfüllt)
- tatsächliche geplante 20-/120-Sekunden-Ausführung bestanden (erfüllt)
- Mission-Completion-, Mission-Failure- und Capture-Ready-Apply-Regressionen bestanden
- vorhandene Dirty-Abdeckung der aktiven State-Systeme vollständig geprüft
- Restore-Reihenfolge dokumentiert
- inkompatible Save-Dateien werden sauber abgelehnt
- produktiver Restore wird eindeutig im Log bestätigt

---

## 27. Persistence und F10

Aktuelle Entscheidung:

- kein Spieler-F10-Menü und keine Persistence-F10-Controls
- für diese Entwicklungsstufe sind keine Persistence-F10-Controls geplant

Begründung:

- Persistence ist ein Hintergrundsystem.
- Spieler sollen Missionen fliegen.
- Spieler sollen Basen erobern.
- Spieler sollen Logistik durchführen.
- Spieler sollen nicht Save/Load verwalten.
- Save/Load ist Systemverhalten, kein Spielerworkflow.

Außerhalb dieser Entwicklungsstufe höchstens als neues, separat zu genehmigendes Konzept denkbar:

- separates Admin-/Debug-Menü
- nur bei Bedarf
- nicht als normales Spielerfeature

Aktuell nicht umsetzen:

- `Save Campaign State` im Spieler-F10
- `Load Campaign State` im Spieler-F10
- `Validate Save File` im Spieler-F10

---

## 28. Integration mit anderen Systemen

### CaptureSystem

Aktueller Stand:

- Dirty-Markierungen sind im CaptureSystem vorhanden.
- Vollständiger Embedded-Regressionstest mit `v0.2.6` steht noch aus.

### MissionGenerator

Aktueller Fokus:

- vorhandene Dirty-Abdeckung für Activation, Completion und Failure prüfen
- Cancel und Expire später persistenzrelevant ergänzen und testen

### LogisticsDelivery

Aktueller Fokus:

- vorhandene Dirty-Abdeckung prüfen und spätere Supply-Änderungen sowie Lieferereignisse vollständig abdecken

### FobSystem

Aktueller Fokus:

- vorhandene Dirty-Abdeckung prüfen und spätere FOB-Baufortschritte sowie Statusänderungen vollständig abdecken

### AICapManager

Aktueller Fokus:

- vorhandene Dirty-Abdeckung prüfen und spätere AI-Aufträge, CAP Requests sowie Reaktionsstatus vollständig abdecken

### IADS

Später.

Ziel:

- IADS-Schäden, Unterdrückung, Reparatur und Netzwerkstatus persistenzrelevant markieren.

---

## 29. Testanforderungen

Für vollständige Persistence-Regressionstests müssen Logs sauber und der getestete Mission-Editor-Dateistand eindeutig sein.

Vor einem vollständigen Embedded-Test:

1. `v0.2.6` in der Mission-Editor-`DO SCRIPT FILE`-Aktion neu auswählen.
2. DEV-Mission speichern.
3. DCS beenden.
4. Alte `dcs.log` löschen oder umbenennen.
5. DCS starten und die Mission frisch laden.
6. Testaktionen und geplante Autosave-Ticks durchführen.
7. DCS beenden und die frische `dcs.log` prüfen.

Bestätigte kontrollierte DCS-SMS-Hotload-Tests für `v0.2.6`:

1. Dirty Save:
   - Entscheidung `SAVED`
   - Dirty wurde erst nach Read-back, Compile, Evaluate und Validation gelöscht.
2. Unveränderter zweiter Aufruf:
   - Entscheidung `SKIPPED`
   - kein zusätzlicher Autosave Count
   - kein Save-Datei-Schreibvorgang
3. Injizierter Schreibfehler:
   - Entscheidung `FAILED`
   - `dirty=true` und `dirtyReason=codex_dirty_autosave_failure_retry_test` blieben erhalten
   - bestehende Save-Datei blieb nach Größe und Prüfsumme unverändert
4. Retry nach Wiederherstellung von `io.open`:
   - Entscheidung `SAVED`
   - derselbe Dirty Reason wurde gespeichert
   - Dirty wurde erst nach erfolgreicher Verifikation gelöscht
   - Autosave Count erhöhte sich nur für den erfolgreichen Retry
5. Logprüfung:
   - keine neuen `SCRIPTING ERROR`
   - keine neuen `Mission script error`
   - kein neuer `stack traceback`

Bestätigte `v0.2.6`-Entscheidungsmarker:

- `Periodic autosave decision: SAVED dirtyReason=...`
- `Periodic autosave decision: SKIPPED detail=state_unchanged`
- `Periodic autosave decision: FAILED dirtyReason=...`
- `productiveRestore=false`

Verbleibende Testgrenzen:

- Die ersten Tests verwendeten historisch einen kontrollierten Hotload von `v0.2.6`; die damalige Mission-Editor-`DO SCRIPT FILE`-Kopie enthielt noch `v0.2.5`.
- Ein vollständiger normaler Missionsstart mit eingebetteter `v0.2.6` ist inzwischen bestanden.
- Das tatsächliche geplante Verhalten nach 20 Sekunden und danach alle 120 Sekunden ist mit eingebetteter `v0.2.6` bestanden: ein realer Dirty-Tick loggte `SAVED`, die folgenden unveränderten Ticks loggten `SKIPPED`, und die Save-Datei blieb bei `SKIPPED` unverändert.
- Mission Completion, Mission Failure, Capture Ready Apply und allgemeine Regressionstests bleiben mit eingebetteter `v0.2.6` ausstehend; sie sind aktuell durch die ungeklärten leeren Missionstabellen blockiert.
- Produktiver Startup-Restore bleibt absichtlich deaktiviert und ungetestet.

Wichtige Nicht-mehr-Marker:

- `Persistence file save test scheduled`
- `Persistence file validation test scheduled`
- `Persistence file load test scheduled`
- `Campaign state file load test passed`

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

## 30. Bekannte Risiken

### 30.1 DCS-Update überschreibt MissionScripting.lua

Risiko:

- `os`, `io` und `lfs` werden durch ein DCS-Update erneut sanitisiert.

Folge:

- Bei erneut sanitisiertem `io` oder `lfs` kann Persistence keine Dateien schreiben oder lesen.
- Bei erneut sanitisiertem `os`, `io` oder `lfs` können DCS-SMS `exec`, `status` und `tail-log` ausfallen.

Erkennung:

- `io=false`
- `lfs=false`
- `Persistence sandbox blocked`
- DCS-SMS-Bridge-Befehle schlagen fehl

Gegenmaßnahme:

- lokale `MissionScripting.lua` prüfen
- solange die DCS-SMS-Runtime-Bridge verwendet wird, `os`, `io` und `lfs` unsanitized halten
- `require` kann weiterhin sanitisiert bleiben
- `os` nur dann wieder sanitizen, wenn die DCS-SMS-Runtime-Bridge entfernt wurde oder nicht mehr benötigt wird

---

### 30.2 Save-Datei wird inkompatibel

Risiko:

- State-Strukturen ändern sich.
- alte Save-Datei passt nicht mehr zum aktuellen Code.

Gegenmaßnahme später:

- Save-Versionierung
- Schema-Versionierung
- Kompatibilitätsprüfung
- Fallback auf neuen Kampagnenstart
- Backup-Datei behalten

---

### 30.3 Produktiver Restore zu früh aktiviert

Risiko:

- Restore überschreibt frisch initialisierten State falsch.
- Module starten mit inkonsistentem Zustand.
- Framework-Hooks könnten zu früh ausgelöst werden.

Gegenmaßnahme:

- produktiver Restore bleibt deaktiviert
- zuerst Embedded- und Regressionstests von `v0.2.6` abschließen
- dann Restore-Reihenfolge definieren
- dann kontrolliert produktiven Restore freischalten

---

### 30.4 Autosave speichert unfertigen State

Risiko:

- Autosave speichert einen Zwischenstand, bevor alle Module initialisiert sind.

Aktuelle Gegenmaßnahme:

- erster Autosave erst nach 20 Sekunden
- Persistence startet nach den relevanten State-Grundsystemen
- unveränderte Ticks werden ohne Save-Datei-Schreibvorgang übersprungen
- geänderter State wird geschrieben und vollständig zurückgelesen, kompiliert, evaluiert und validiert
- Dirty-State wird erst nach verifiziertem Erfolg gelöscht
- ein während des Saves neuerer Dirty-State bleibt erhalten

Später ergänzen:

- Autosave nur nach Runtime-Ready
- Save-Datei-Rotation
- letzte gültige Save-Datei behalten

---

## 31. Aktueller Abschlussstand

Bestätigter Stand am 2026-08-04:

- DCS-Dateizugriff mit `io` und `lfs` funktioniert.
- Sandbox-Test ist bestanden.
- Campaign-State kann gespeichert werden.
- Save-Datei kann zurückgelesen, kompiliert, evaluiert und validiert werden.
- Save-Datei kann kontrolliert importiert werden.
- PersistenceSystem `v0.2.6` ist implementiert.
- Periodischer Autosave ist dirty-aware.
- Unveränderte Autosave-Aufrufe werden ohne Dateischreibvorgang übersprungen.
- Fehler behalten Dirty-State und Dirty Reason bei.
- Ein erfolgreicher Retry löscht Dirty erst nach vollständiger Verifikation.
- Ein neuerer Dirty-State wird durch den Abschluss eines älteren Saves nicht gelöscht.
- Dirty Save, Skip, injizierter Schreibfehler und Retry sind per DCS-SMS-Hotload bestätigt.
- Es existieren keine Persistence-F10-Controls und für diese Entwicklungsstufe sind keine geplant.
- Produktiver Restore ist noch deaktiviert.

Implementierte und per Hotload getestete Persistence-Version:

- `src/campaign/tc_persistence_system.lua v0.2.6`

Aktueller wichtigster nächster Verifikationsschritt:

- den gespeicherten `.miz`-Container offline und strikt read-only auf eingebettete Ressourcen, Trigger-Zuordnungen, Hash-/Versionsabweichungen, veraltete Kopien und Duplikate prüfen
- Mission Completion, Mission Failure und Capture Ready Apply erst nach Klärung des MissionGenerator-State-Verlusts regressionsprüfen
- kein produktiver Restore
- kein Persistence-F10-Menü
- keine echten MOOSE-/CTLD-/Skynet-Aktionen

---

## 32. Startpunkt für die nächste Session

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

Nächster technischer Teststand:

- gespeicherte DEV-`.miz` offline und read-only gegen die 13 autoritativen Repository-Quelldateien prüfen
- Trigger, Ressourcen, Dateinamen, Byte-Längen, SHA-256, Versionsmarker, veraltete Kopien und Duplikate berichten
- keine DCS-/DCS-SMS-Runtime-Aktion und keine `.miz`-Änderung durchführen
- bestehende Campaign-Pipelines erst nach Klärung des MissionGenerator-State-Verlusts regressionsprüfen
- kein Persistence-F10-Menü
- kein produktiver Restore
- keine echten MOOSE-/CTLD-/Skynet-Aktionen

Erwarteter Audit-Bericht:

1. Für jede der 13 Quelldateien sind auslösendes Trigger-/Ressourcen-Mapping und eingebetteter Dateiname bekannt.
2. Repository- und `.miz`-Bytes werden per Länge und SHA-256 verglichen.
3. Versionsmarker, veraltete Kopien, fehlende Ressourcen und Duplikate werden eindeutig ausgewiesen.
4. Die Prüfung bleibt strikt offline und verändert weder Repository noch `.miz`.

---

## Footer

Persistence ist jetzt kein theoretisches Konzept mehr.

Bestanden ist:

- Datei schreiben
- Datei lesen
- Datei kompilieren und evaluieren
- Datei validieren
- Snapshot importieren
- dirty-aware Autosave-Entscheidungen `SAVED`, `SKIPPED` und `FAILED`
- Dirty-Erhalt nach Fehler und Dirty-Clear nach erfolgreicher Verifikation
- erfolgreicher Retry desselben Dirty-State

Noch nicht aktiv ist:

- produktiver automatischer Restore beim Missionsstart

Noch ausstehend ist:

- die durch den ungeklärten MissionGenerator-State-Verlust blockierte vollständige Campaign-Regression mit eingebetteter `v0.2.6`
- produktiver Startup-Restore; er bleibt absichtlich deaktiviert und ungetestet
