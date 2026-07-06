# Persistence

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
- Background-Autosave ist bestanden
- produktiver automatischer Restore beim Missionsstart ist bewusst noch deaktiviert

Persistence ist kein Spieler-F10-Feature.

Spieler sollen nicht manuell speichern oder laden müssen.

Persistence läuft im Hintergrund als Teil des Kampagnensystems.

---

## 2. Aktueller technischer Stand

Stand:

- 2026-07-06

Aktive Datei:

- `src/campaign/tc_persistence_system.lua`

Aktuelle getestete Version:

- `v0.2.5`

Status:

- bestanden

Architekturrolle:

- internes Hintergrundsystem
- kein Spieler-F10-Menü
- automatischer Autosave im Hintergrund
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
- Autosave läuft ohne Spieleraktion.
- `productiveRestore=false`

Bewertung:

- Die technische Persistenzgrundlage ist bestanden.
- Der Kampagnenzustand kann als Lua-Return-Datei gespeichert werden.
- Der Kampagnenzustand kann technisch wieder importiert werden.
- Produktiver Restore wird bewusst erst später freigeschaltet.
- Nächster Schritt ist die Anbindung echter State-Änderungen an Persistence, beginnend mit CaptureSystem.

---

## 3. Lokale DCS-Voraussetzung

Damit DCS-Missionsskripte Dateien schreiben und lesen können, muss die lokale DCS-Sandbox angepasst sein.

Lokale Datei:

    ...\DCS World\Scripts\MissionScripting.lua

Für Theater Command DCS aktuell notwendige lokale Freigabe:

- `io` entsperrt
- `lfs` entsperrt
- `os` weiterhin gesperrt
- `require` weiterhin gesperrt

Bewusste Entscheidung:

- `io` wird benötigt, um Save-Dateien zu schreiben und zu lesen.
- `lfs` wird benötigt, um den Saved-Games-Schreibpfad zu finden und den Projektordner anzulegen.
- `os` bleibt gesperrt.
- `require` bleibt gesperrt.

Bestätigter Sandbox-Status im DCS-Log:

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

Erster Teststatus:

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
- Nächster sinnvoller Schritt ist ein Dirty-/Autosave-Hook in `tc_capture_system.lua`.

---

## 6. Aktueller getesteter Gesamtstand

Stand:

- 2026-07-06

Bestätigte Systeme:

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
- Persistence autosaveScheduled: `true`
- letzter bestätigter Persistence autosaveCount: `1`

Bewertung:

- Die State-Grundlage ist stabil genug, um Persistenz-Hooks an echte State-Änderungen anzubinden.
- Nächster Schritt ist nicht weiterer allgemeiner Persistence-Testcode.
- Nächster Schritt ist der Dirty-/Autosave-Hook im CaptureSystem.

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

PersistenceSystem `v0.2.5` speichert aktuell diese zehn Snapshot-Sektionen.

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
- Autosave schreibt den State im Hintergrund.

Noch nicht vorhanden:

- gezielte Dirty-Hooks in allen Fachsystemen
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

- State-Änderungen müssen zuerst sauber persistenzrelevant markiert werden.
- Restore-Reihenfolge muss definiert werden.
- Save-Datei-Kompatibilität muss geprüft werden.
- Framework-Aktionen dürfen nicht zu früh durch Restore ausgelöst werden.

Aktuelle Entscheidung:

- `productiveRestore=false`
- Produktiver Restore wird erst nach Dirty-/Change-Hook-Tests freigeschaltet.

---

## 11. Autosave-Verhalten

Aktuelles Autosave-Verhalten in `v0.2.5`:

- Autosave ist aktiviert.
- Autosave wird beim Start des PersistenceSystems geplant.
- erster Autosave nach 20 Sekunden
- danach Autosave alle 120 Sekunden
- Autosave läuft ohne Spieleraktion
- Autosave schreibt die Campaign-Save-Datei
- Autosave loggt eindeutig
- produktiver Restore bleibt deaktiviert

Bestätigter Logmarker:

- `Persistence autosave scheduled: initialDelay=20s interval=120s productiveRestore=false`
- `Campaign state autosaved`

Wichtig:

- Autosave ist kein Spieler-F10-Menü.
- Autosave ist kein manueller Spielerworkflow.
- Autosave läuft im Maschinenraum.
- Der Spieler soll davon im Normalbetrieb nichts bedienen müssen.

Aktueller Entwicklungsstand:

- Autosave schreibt auch dann regelmäßig, wenn noch keine Dirty-Hooks vorhanden sind.
- Nächster Schritt ist, relevante State-Änderungen explizit als dirty zu markieren.
- Später kann Autosave optional nur bei Dirty-State schreiben oder Dirty-State priorisiert behandeln.

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

- Airbase-Änderungen gezielt dirty markieren
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

- Zone-Änderungen gezielt dirty markieren
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

Nächster konkreter Schritt:

- CaptureSystem soll bei erfolgreichem Capture Ready Apply den State als persistenzrelevant markieren.
- Autosave soll diesen geänderten Zustand anschließend automatisch sichern.

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
- Logistics Dirty-Hooks sind noch offen.

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
- FOB Dirty-Hooks sind noch offen.

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

- Mission Dirty-Hooks
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
- AI Dirty-Hooks sind noch offen.

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

Ziel:

State-Änderungen sollen Persistence mitteilen, dass der Kampagnenzustand speicherrelevant verändert wurde.

Aktueller Stand:

- PersistenceSystem besitzt Dirty-Grundfunktionen.
- Autosave läuft bereits.
- Fachsysteme markieren Änderungen noch nicht konsequent dirty.

Nächster Schritt:

- CaptureSystem soll bei erfolgreichem Capture Ready Apply den State als dirty markieren.

Erwarteter späterer Ablauf:

1. Capture Ready Apply ändert Zone Ownership.
2. Capture Ready Apply ändert linked Airbase Ownership.
3. CaptureSystem markiert State als dirty.
4. PersistenceSystem registriert persistenzrelevante Änderung.
5. Autosave schreibt den geänderten State.
6. Save-Datei enthält aktualisierte Ownership.

Spätere Dirty-Hooks:

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

- Dirty-Hooks müssen zuerst funktionieren.
- Save-Datei muss nach echten State-Änderungen geprüft werden.
- Restore-Reihenfolge muss definiert werden.
- Initialisierung darf nicht überschrieben oder beschädigt werden.
- Framework-Aktionen dürfen nicht versehentlich durch Restore ausgelöst werden.

Voraussetzungen vor Aktivierung:

- Capture Dirty-Hook bestanden
- Logistics Dirty-Hooks vorbereitet
- Mission Dirty-Hooks vorbereitet
- Save-Datei nach State-Änderung geprüft
- Restore-Reihenfolge dokumentiert
- inkompatible Save-Dateien werden sauber abgelehnt
- produktiver Restore wird eindeutig im Log bestätigt

---

## 27. Persistence und F10

Aktuelle Entscheidung:

- kein Spieler-F10-Menü für Persistence

Begründung:

- Persistence ist ein Hintergrundsystem.
- Spieler sollen Missionen fliegen.
- Spieler sollen Basen erobern.
- Spieler sollen Logistik durchführen.
- Spieler sollen nicht Save/Load verwalten.
- Save/Load ist Systemverhalten, kein Spielerworkflow.

Möglich später:

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

Nächster Schritt.

Ziel:

- Capture Ready Apply markiert State dirty.
- Autosave sichert Ownership-Änderung.

### MissionGenerator

Später.

Ziel:

- Mission Activation, Completion, Failure, Cancel und Expire persistenzrelevant markieren.

### LogisticsDelivery

Später.

Ziel:

- Supply-Änderungen und Lieferereignisse persistenzrelevant markieren.

### FobSystem

Später.

Ziel:

- FOB-Baufortschritt und FOB-Status persistenzrelevant markieren.

### AICapManager

Später.

Ziel:

- AI-Aufträge, CAP Requests und AI-Reaktionsstatus persistenzrelevant markieren.

### IADS

Später.

Ziel:

- IADS-Schäden, Unterdrückung, Reparatur und Netzwerkstatus persistenzrelevant markieren.

---

## 29. Testanforderungen

Für Persistence-Tests müssen Logs sauber sein.

Vor jedem Test:

1. DCS beenden.
2. Alte `dcs.log` löschen oder umbenennen.
3. DCS starten.
4. Mission starten.
5. Testaktion durchführen.
6. DCS beenden.
7. Frische `dcs.log` prüfen.

Wichtige Erfolgsmarker für `v0.2.5`:

- `Loaded src/campaign/tc_persistence_system.lua v0.2.5`
- `Persistence sandbox availability: os=false, io=true, lfs=true`
- `Persistence sandbox file test passed`
- `Persistence autosave scheduled`
- `Persistence system initialized`
- `Campaign state autosaved`
- `productiveRestore=false`

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

- `io` und `lfs` werden wieder gesperrt.

Folge:

- Persistence kann keine Dateien schreiben oder lesen.

Erkennung:

- `io=false`
- `lfs=false`
- `Persistence sandbox blocked`

Gegenmaßnahme:

- lokale `MissionScripting.lua` prüfen
- `io` und `lfs` erneut freigeben
- `os` weiterhin gesperrt lassen
- `require` weiterhin gesperrt lassen

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
- erst Dirty-Hooks testen
- dann Restore-Reihenfolge definieren
- dann kontrolliert produktiven Restore freischalten

---

### 30.4 Autosave speichert unfertigen State

Risiko:

- Autosave speichert einen Zwischenstand, bevor alle Module initialisiert sind.

Aktuelle Gegenmaßnahme:

- erster Autosave erst nach 20 Sekunden
- Persistence startet nach den relevanten State-Grundsystemen
- Save-Datei wird validiert

Später ergänzen:

- Autosave nur nach Runtime-Ready
- Dirty-State-Auswertung
- Save-Datei-Rotation
- letzte gültige Save-Datei behalten

---

## 31. Aktueller Abschlussstand

Bestätigter Stand am 2026-07-06:

- DCS-Dateizugriff mit `io` und `lfs` funktioniert.
- Sandbox-Test ist bestanden.
- Campaign-State kann gespeichert werden.
- Save-Datei kann gelesen werden.
- Save-Datei kann validiert werden.
- Save-Datei kann kontrolliert importiert werden.
- Background-Autosave läuft.
- Spieler-F10-Persistence ist nicht vorgesehen.
- Produktiver Restore ist noch deaktiviert.

Bestandene Persistence-Version:

- `src/campaign/tc_persistence_system.lua v0.2.5`

Aktueller wichtigster nächster Schritt:

- `src/campaign/tc_capture_system.lua v0.2.3`
- Dirty-/Persistence-Hook bei erfolgreichem Capture Ready Apply
- Autosave soll geänderten Capture-State automatisch sichern
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

Nächster technischer Startpunkt:

- `src/campaign/tc_capture_system.lua`

Konkretes Ziel:

- `CaptureSystem v0.2.3`
- Dirty-/Persistence-Hook bei erfolgreichem Capture Ready Apply
- Background Autosave soll geänderten State sichern
- kein Persistence-F10-Menü
- kein produktiver Restore
- keine echten MOOSE-/CTLD-/Skynet-Aktionen

Erwarteter Test:

1. Mission starten.
2. Mission über F10 aktivieren.
3. Mission über F10 abschließen.
4. Capture Ready Zone 1 über F10 anwenden.
5. CaptureSystem markiert State als persistenzrelevant.
6. Persistence autosaved automatisch.
7. DCS-Log bestätigt Dirty-/Autosave-Zusammenhang.

---

## Footer

Persistence ist jetzt kein theoretisches Konzept mehr.

Bestanden ist:

- Datei schreiben
- Datei lesen
- Datei validieren
- Snapshot importieren
- Background Autosave

Noch nicht aktiv ist:

- produktiver automatischer Restore beim Missionsstart

Der nächste sinnvolle Schritt ist:

- echte State-Änderungen persistenzrelevant markieren, beginnend mit CaptureSystem.
