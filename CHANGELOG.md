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

## 2026-09-29

### CTLD-KI-Truppentransport vollständig praktisch bestätigt

Erstmals wurde ein vollständiger automatischer CTLD-KI-Truppentransport in einer isolierten DCS-Testmission praktisch bestätigt.

Testmission:

`C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz`

SHA-256 vor dem Runtime-Test:

`5F0D89DF744A7083401E36713B148BD21813FF187CC36EC1F088507163458C57`

Testgruppe:

`TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01`

Testunit:

`TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01`

Testfahrzeug:

- Mi-8

Bestätigter Gesamtpfad:

`Pickup -> Taxi -> Takeoff -> Transit -> Off-Airfield-Anflug -> Landung -> automatischer CTLD-Dropoff -> reale Blue-Bodengruppe`

Damit ist erstmals ein realer Vendor-Framework-Pfad außerhalb des rein state-first Theater-Command-Kerns vollständig praktisch durchlaufen worden.

Der Test ist ein **Framework-Proof-of-Concept**.

Er ist noch keine produktive Theater-Command-CTLD-Integration.

---

### CTLD Pickup-/Dropoff-Zonen zur Laufzeit erfolgreich registriert

Verwendeter Pickup:

`CTLD_PICKUP_BLUE_AKROTIRI_01`

Verwendeter Test-Dropoff:

`CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01`

Bestätigt:

- CTLD `1.6.1` war bereits initialisiert.
- Pickup-Zone wurde danach als normalisierter Eintrag in `ctld.pickupZones` ergänzt.
- Dropoff-Zone wurde danach als normalisierter Eintrag in `ctld.dropOffZones` ergänzt.
- die Einträge wurden aus dem CTLD-Live-State zurückgelesen.
- CTLD verwendete beide Einträge anschließend tatsächlich.
- `ctld.initialize()` musste dafür nicht erneut ausgeführt werden.

Temporärer Pickup-Eintrag:

`{ "CTLD_PICKUP_BLUE_AKROTIRI_01", -1, 10000, 1, 2 }`

Temporärer Dropoff-Eintrag:

`{ "CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01", -1, 2, 1 }`

Architekturfolgerung:

Eine spätere Theater-Command-Integration kann CTLD-Zonen idempotent nach der Vendor-Initialisierung registrieren, ohne CTLD selbst zu verändern.

---

### CTLD-KI-Transporter benötigt `transportPilotNames`

Wichtiger Runtime-Befund:

`ctld.checkAIStatus()` verarbeitet den getesteten KI-Transporter nur, wenn dessen exakter Unit-Name im relevanten CTLD-AI-Pfad in:

`ctld.transportPilotNames`

vorhanden ist.

Getestete Unit:

`TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01`

Vor temporärer Registrierung:

- `108` Einträge
- Testunit nicht vorhanden

Nach Registrierung:

- `109` Einträge
- Testunit genau einmal vorhanden

Die Registrierung erfolgte nur, wenn der Name zuvor nicht vorhanden war.

Architekturfolgerung:

Eine produktive Theater-Command-Integration muss vorgesehene KI-Transporter:

- automatisch
- idempotent
- ohne Duplikate
- anhand des exakten Unit-Namens

bei CTLD registrieren.

Keine direkte Manipulation des CTLD-Bordzustands ist dafür erforderlich.

---

### Automatischer CTLD-Pickup bestanden

Nach nativer Aktivierung der KI-Gruppe wurde der Pickup vollständig durch CTLD durchgeführt.

Bestätigt:

- 16 Soldaten wurden automatisch aufgenommen.
- Pickup-Counter wechselte von `10000` auf `9999`.
- der Transporter befand sich innerhalb der Pickup-Zone.
- keine direkte Manipulation von `ctld.inTransitTroops`.
- kein manuelles Laden.
- kein Teleport.
- keine Runtime-Routenänderung.

Damit ist der CTLD-AI-Pickup praktisch bestätigt.

---

### Off-Airfield-Landung über Perform Task `Land` bestanden

Der erfolgreiche Test verwendete einen normalen DCS-Wegpunkt:

`Turning Point`

mit einem nativen:

`Perform Task -> Land`

Zielposition:

- x / North: `-29249.110954281`
- z / East: `-271836.070539260`

Wegpunkthöhe:

- `100 m BARO`

Wegpunktgeschwindigkeit:

- `30 m/s`

Land-Task:

- `duration=300`
- `durationFlag=true`

Die KI führte selbständig aus:

- Taxi
- Takeoff
- Transit
- Descent
- Off-Airfield-Landung

Bestätigte minimale Entfernung zum Dropoff-Zentrum:

- ungefähr `1.06 m`

Die Maschine blieb anschließend am Boden.

Ein Invisible FARP war für diesen Transportpfad nicht erforderlich.

Der frühere ungebundene `Land / Landing`-Waypoint-Ansatz hatte keinen vollständigen erfolgreichen Transportzyklus geliefert.

Der neue Test isoliert die Landemethode als entscheidenden Unterschied, beweist aber nicht mathematisch die genaue Ursache des früheren Turnback-Verhaltens.

---

### Automatischer CTLD-Dropoff bestanden

Nach der Landung führte CTLD den Dropoff automatisch aus.

Bestätigt:

- `troops` verschwand aus dem CTLD-In-Transit-Zustand der Unit.
- `ctld.droppedTroopsBLUE` erhielt genau einen neuen Eintrag.
- eine reale Blue-Bodengruppe wurde erzeugt.

Erzeugte Gruppe:

`Dropped Group 2`

Group-ID:

`70001`

Stärke:

`16`

Unit-Typ:

`Soldier M249`

Die Bodengruppe wurde anschließend von der normalen DCS-AI weitergeführt.

Nicht verwendet wurden:

- manuelles CTLD-Unload
- direkte Bordzustandsmanipulation
- Teleport
- Runtime-Rerouting
- Runtime-Taskänderung

Damit ist der vollständige technische CTLD-Zyklus bestätigt:

`Pickup -> Flug -> Off-Airfield-Landung -> Dropoff -> Bodengruppe`

---

### CTLD `RepackCommandsPath`-Fehler reproduziert

Beim Grounded-Übergang des registrierten KI-Transporters trat reproduzierbar auf:

`CTLD.lua:6150: attempt to get length of local 'RepackCommandsPath' (a nil value)`

Stack-Kontext:

- `updateRepackMenu`
- `updateRepackMenuOnlanding`

Source-/Runtime-Einordnung:

- der KI-Transporter ist über `ctld.transportPilotNames` im CTLD-AI-Pfad registriert.
- der Vendor-Landemenüpfad kann deshalb auch diese Unit verarbeiten.
- `ctld.vehicleCommandsPath[_unitName]` existiert typischerweise für Player-/F10-Menüpfade.
- für einen reinen KI-Transporter kann dieser Wert `nil` sein.
- der Vendor-Code behandelt diesen Zustand an dieser Stelle nicht robust.

Der CTLD-Pickup-/Dropoff-Pfad wurde trotzdem erfolgreich abgeschlossen.

Daraus wird ausdrücklich **nicht** abgeleitet, dass der Fehler langfristig harmlos ist.

Insbesondere ist vor produktiver Integration source-backed zu prüfen, ob der unbehandelte Fehler den betreffenden Scheduler beziehungsweise spätere Repack-Menü-Aktualisierungen beendet.

Verbindliche Entscheidung:

- `vendor/ctld/CTLD.lua` wird nicht gepatcht.

Eine Lösung muss durch Theater-Command-seitige Konfiguration beziehungsweise Integrationslogik erfolgen.

---

### CTLD-PoC klar von Cargo-/Crate-Integration abgegrenzt

Der erfolgreiche Test war:

- KI-Truppentransport

Noch nicht getestet wurden:

- Crate Spawn
- Crate Loading
- Sling Load
- Crate Drop
- Supply Crates
- Engineering Crates
- Repair Crates
- Fuel Crates
- Ammo Crates
- FOB Build Crates
- reale CTLD-FOBs

Eine funktionierende Pickup-/Dropoff-Zonenregistrierung bedeutet nicht automatisch, dass die CTLD-Crate-Wirtschaft bereits funktionsfähig ist.

Cargo-/Crate-Integration bleibt ein separater zukünftiger Testbereich.

---

### Produktive Persistence während des CTLD-Tests geschützt

Produktive Save-Datei:

`C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua`

Vor dem Test wurde ein Backup angelegt:

`C:\Users\Paul\Documents\TC_miz_backups\operation_levant_reclamation_save__pre_landtask_test_2026-09-29_100813.lua`

Referenz-SHA-256:

`C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596`

Größe:

`3094967 Bytes`

Änderungszeit:

`2026-09-21 15:00:00.5926451`

Während des Tests wurde die produktive Save-Datei temporär schreibgeschützt.

Nach dem Test wurde der Hash zweimal kontrolliert.

Bestätigt:

- Größe unverändert
- Änderungszeit unverändert
- SHA-256 unverändert
- produktiver Kampagnenstate nicht verändert

Erst nach beendetem DCS wurde der Schreibschutz entfernt.

Final:

- `ReadOnly=False`
- SHA-256 weiterhin identisch

`productiveRestore=false` blieb unverändert.

---

### Priority 4 technisch konkretisiert

Der bisher nur geplante Bereich:

`Priority 4 – CTLD-Integration vorbereiten`

besitzt jetzt einen praktisch bestätigten Framework-Pfad.

Bestanden sind:

- Runtime-Zonenregistrierung
- KI-Transporterregistrierung
- automatischer Pickup
- autonomer Flug
- Off-Airfield-Landung
- automatischer Dropoff
- reale Bodengruppe

Noch offen ist die produktive Theater-Command-Orchestrierung.

Der nächste Entwicklungsschritt ist deshalb nicht ein erneuter identischer Mi-8-Test.

Vor produktivem Code müssen insbesondere geklärt werden:

- fachliche Zuständigkeit unter `src/`
- idempotente Zonenregistrierung
- idempotente Transporterregistrierung
- Transporter-Lifecycle
- Auftragserzeugung
- Ergebnisvalidierung
- Rückkopplung in LogisticsDelivery
- Rückkopplung in FobSystem
- Dirty-/Persistence-Grenze
- Behandlung von `RepackCommandsPath`

Keine generische `tc_ctld.lua`.

---

### Entwicklungswerkzeug-Workflow konkretisiert

Der Entwicklungsworkflow wurde verbindlich präzisiert.

#### ChatGPT

Rolle:

- Projektkoordination
- Architektur
- GitHub-Audit
- Dokumentationspflege
- Testplanung
- Ergebnisbewertung
- Definition des nächsten Einzelschritts
- Vorbereitung präziser Claude-Arbeitsaufträge

#### Claude + dcs-mcp

Verwendete Version:

`dcs-mcp 0.9.11`

Verwendung:

- strukturierte `.miz`-Analyse
- Mission-Editor-Inhalte prüfen
- Mission-Editor-Inhalte gezielt ändern
- Gruppen
- Units
- Trigger Zones
- Wegpunkte
- Tasks
- Airbase-Zuordnungen
- gespeicherte Missionsdateien auditieren

Syria-Terrain-Daten sind lokal installiert.

#### Claude Code + DCS-SMS

DCS-SMS:

`0.27.2`

Hook:

`me-bridge-0.27.2`

Lokale CLI:

`C:\Tools\dcs-sms\dcs-sms.exe`

Lokaler Claude-Code-Skill:

`C:\Users\Paul\.claude\skills\dcs-sms\SKILL.md`

Verwendung:

- Mission-Editor-Status
- laufende DCS-Runtime
- Mission-Environment-Lua
- CTLD-Live-State
- Unit-State
- Position
- Geschwindigkeit
- Grounded-/Airborne-State
- Logs
- Runtime-Regressionen

#### Werkzeuggrenze

Diese Werkzeuge sind Entwicklungs- und Diagnosewerkzeuge.

Sie sind keine Runtime-Abhängigkeiten der späteren Theater-Command-Kampagne.

Verbindlicher Arbeitsfluss für Mission-Editor-/Framework-Arbeit:

`ChatGPT -> Claude + dcs-mcp -> gespeicherte Mission -> Claude Code + DCS-SMS -> DCS Runtime -> Ergebnisbewertung -> GitHub`

DCS selbst bleibt die autoritative Instanz für tatsächliches Simulatorverhalten.

---

## 2026-09-21

### Priority 3 im dokumentierten Umfang abgeschlossen

Der am 2026-09-12 noch offene projektweite Dirty-Coverage-Bereich wurde anschließend vollständig read-only auditiert.

Der Vier-System-Audit wurde am 2026-09-13 abgeschlossen.

Geprüft wurden:

1. `src/logistics/tc_logistics_delivery.lua`
2. `src/logistics/tc_fob_system.lua`
3. `src/missions/tc_mission_generator.lua`
4. `src/ai/tc_ai_cap_manager.lua`

Ergebnis:

- drei aktive Read-Neutrality-Probleme identifiziert
- LogisticsDelivery betroffen
- FobSystem betroffen
- AICapManager betroffen
- MissionGenerator ohne aktiven Missing-Dirty-Bug
- latente Lifecycle-/No-Op-Punkte separat dokumentiert

Die drei aktiven Probleme wurden am 2026-09-21 behoben und regressionsgetestet.

---

### LogisticsDelivery Read-Neutrality behoben

Datei:

`src/logistics/tc_logistics_delivery.lua`

Neue Version:

`v0.2.1`

Commit:

`d4c439dfeb243621e7bc0ca8906f6cb2cf82491d`

Problem:

Lesende Statistik-/Summary-Pfade konnten persistierten Logistics-State beziehungsweise Laufzeitfelder verändern.

Fix:

- reine Statistikberechnung vom persistierenden Update getrennt
- Getter bleiben read-neutral
- echte Mutationspfade behalten ihre Dirty-Semantik

Bestätigt:

- `getStatistics()`
- `getHubSummary()`
- `summary()`

verändern keinen persistierten Logistics-State mehr.

Positivtest:

`createDelivery()`

setzt weiterhin:

`dirtyReason=logistics_delivery_created`

Embedded Resource Audit und Runtime-Regression bestanden.

70/70 dokumentierte Prüfungen bestanden.

Rollback stellte den produktiven Ausgangszustand vollständig wieder her.

---

### FobSystem Read-Neutrality behoben

Datei:

`src/logistics/tc_fob_system.lua`

Neue Version:

`v0.2.1`

Commit:

`c5ea67ae2efbec5c96fd6760b35f28010dc39d9e`

Problem:

Lesende Statistik-/Summary-Pfade konnten persistierten FOB-State und Laufzeitfelder verändern.

Fix:

- reine Statistikberechnung von persistierendem Update getrennt
- Getter bleiben read-neutral
- echte Mutationen behalten Dirty-Semantik

Bestätigte read-neutrale Pfade unter anderem:

- `getStatistics()`
- `summary()`
- `get()`
- `getAll()`
- `getCandidates()`
- `getByStatus()`
- `getByOwner()`
- `getBlueFobs()`

Positivtest:

`FobSystem.create()`

setzt weiterhin:

`dirtyReason=fob_created`

Embedded Resource Audit und Runtime-Regression bestanden.

87/87 dokumentierte Prüfungen bestanden.

Rollback stellte den produktiven Ausgangszustand vollständig wieder her.

---

### AICapManager Read-Neutrality behoben

Datei:

`src/ai/tc_ai_cap_manager.lua`

Neue Version:

`v0.2.1`

Commit:

`88d7f74237cbd24921b8d224fad0474615258342`

Problem:

`updateStatistics()` beziehungsweise davon abhängige Getter konnten bei reinen Reads persistierten AI-State beziehungsweise Laufzeitfelder verändern.

Fix:

- neue reine Statistikberechnung
- `getStatistics()` und `summary()` verändern keinen State
- weitere Getter initialisieren keinen AI-State mehr
- `updateStatistics()` bleibt als bewusster persistierender Mutationshelfer erhalten

Bestätigt:

- `getStatistics()`
- `summary()`
- `getCap()`
- `getCapZones()`
- `getCapZoneCandidates()`
- `getRequestedCaps()`
- `getActiveCaps()`
- `getCompletedCaps()`
- `getFailedCaps()`
- `getCancelledCaps()`
- `getCapsBySide()`

bleiben read-neutral.

Positivtest:

`setCapStatus()`

markiert bei echter Mutation weiterhin:

`dirtyReason=ai_cap_record_changed`

Embedded Resource Audit und Runtime-Regression bestanden.

99/99 dokumentierte Prüfungen bestanden.

Rollback stellte den produktiven Ausgangszustand vollständig wieder her.

---

### MissionGenerator Dirty-Coverage ohne aktiven Code-Fix abgeschlossen

Datei:

`src/missions/tc_mission_generator.lua`

Version:

`v0.2.3`

Der read-only Audit fand keinen aktuell aktiven Missing-Dirty-Bug, der einen Code-Fix erfordert.

Kein Fix wurde allein aus Vorsicht eingeführt.

Der frühere Mission-Record-Verlust bleibt als widerlegte Diagnose dokumentiert.

---

### Priority 3 abgeschlossen, latente Punkte bleiben erhalten

Priority 3 ist damit seit dem 2026-09-21 im Umfang des dokumentierten Audits und der daraus abgeleiteten aktiven Fixes abgeschlossen.

Dies ist keine pauschale Aussage, dass zukünftige oder derzeit unverdrahtete Lifecycle-Pfade automatisch fehlerfrei sind.

Weiter separat relevant bleiben unter anderem:

- `reactToActiveMissions()` bei späterer Verdrahtung
- No-Op-Fälle einzelner Mutations-APIs
- Start-/Restore-Lifecycle
- State-Initialisierung
- produktiver Persistence-Restore
- spätere Framework-Rückkopplung

Diese Punkte rechtfertigen keinen erneuten vollständigen Priority-3-Audit ohne neuen Anlass.

Nächster Projektbereich wurde danach:

`Priority 4 – CTLD-Integration vorbereiten`

---

## 2026-09-12

Diese Session hat die am 2026-08-04 offen gebliebene Mission-Record-Diagnose aufgelöst, die daraus resultierenden Regressionen erneut bestanden, zwei CaptureSystem-Dirty-Bugs behoben und den verbleibenden Priority-3-Dirty-Coverage-Bedarf dokumentiert.

### Mission-Record-Diagnose korrigiert

- Der am 2026-08-04 angenommene Mission-Record-Verlust ist widerlegt. Es gingen zu keinem Zeitpunkt Mission Records verloren.
- `State.Missions.available`, `.active`, `.completed`, `.failed`, `.expired` und `.cancelled` sind String-keyed Lua-Dictionaries. Der Lua-Längenoperator `#` ist dafür nicht autoritativ.
- Live nachgewiesen: `TC.State.Missions.statistics.available = 10`, `pairs()`-Count `= 10`, `#TC.State.Missions.available = 0`.
- Tatsächlicher Source-Bug: `src/core/tc_state.lua` -> `State.summary()` verwendete `#` für Mission-Dictionaries.
- Fix: pairs-basierte Hilfsfunktion `countEntries()`.
- Commit: `7d22eb4 Fix mission dictionary counts in state summary`.
- Der Fix wurde committed, gepusht, in der DEV-`.miz` neu eingebettet und live regressionsgetestet.
- Temporärer String-Key-Test: `State.summary().activeMissions = 1` bei einem eingefügten String-keyed Active-Mission-Eintrag; der Testeintrag wurde anschließend wieder entfernt.
- Eine repo-weite READ-ONLY Prüfung fand keine weiteren entsprechenden falschen `#`-Counts auf Mission-State-Dictionaries. `MissionGenerator` verwendet dort bereits pairs-basierte Zählung.
- Der Eintrag `## 2026-08-04` unten bleibt unverändert; die dortige Diagnose ("MissionGenerator-Record-Verlust untersucht", Klassifikation `PROJECT SOURCE HAS NO MATCHING WRITE SITE`) ist der damalige Wissensstand und gilt mit dem heutigen Befund als historisch widerlegt.

### Offline Embedded Mission Resource Audit bestanden

- Das Audit war strikt READ-ONLY und offline.
- DEV-Mission und MCP_TEST-Kopie waren beim Audit byte-identisch.
- 13/13 für den damaligen Blocker relevante aktive Theater-Command-Ressourcen: `EXACT_MATCH` zum Repository.
- 0 aktive Byte-Mismatches, 0 fehlende bzw. Mapping-fehlerhafte aktive Ressourcen, keine aktive Embedded-Runtime-Drift.
- Bekannte Cleanup-Altlast: `ResKey_Action_55` / `tc_persistence_system.lua` — als Ressource weiterhin in der `.miz` vorhanden, nicht von einem Trigger referenziert, nicht geladen, nicht byte-identisch zur aktuellen Persistence-Quelle, nicht ursächlich für die damaligen Symptome; separate spätere Cleanup-Aufgabe.
- Aktiv geladen ist `tc_persistence_system_v0_2_6.lua`; diese war beim Audit byte-identisch zu `src/campaign/tc_persistence_system.lua`.
- Damit ist Embedded Runtime Drift als Ursache der früheren Fehldiagnose ausgeschlossen.

### DCS-SMS auf v0.27.2 bestätigt

- DCS-SMS `v0.27.2`, Hook `me-bridge-0.27.2`.
- Nach einem DCS-Update wurde der MissionScripting-Hook erneut installiert/repariert.
- Auto-Routing per `dcs-sms exec --code "..."` erreicht korrekt das Mission Environment; `TC` ist als Table erreichbar.
- DCS-SMS bleibt Entwicklungs-/Diagnosewerkzeug, kein Theater-Command-Runtime-Framework.

### Mission Completion, Mission Failure und Capture Ready Apply erneut bestanden

#### Mission Completion

Nach Activation + Completion: `available=9`, `active=0`, `completed=1`, `failed=0`, `statistics.available=9`, `statistics.active=0`, `statistics.completed=1`, `total=10`.

Persistence: `Periodic autosave decision: SAVED`, `dirtyReason=f10_active_mission_1_completed`, `dirtyCleared=true`, `productiveRestore=false`.

#### Mission Failure

Danach: `available=8`, `active=0`, `completed=1`, `failed=1`, `statistics.available=8`, `statistics.active=0`, `statistics.completed=1`, `statistics.failed=1`, `total=10`.

Persistence: `SAVED`, `dirtyReason=f10_active_mission_1_failed`, `dirtyCleared=true`, `productiveRestore=false`.

#### Capture Ready Apply

Zone `ZONE_AIRBASE_ABU_AL_DUHUR`. Vor Apply: tatsächlicher Owner-Wechsel `RED -> BLUE`, Progress `100 %`. Danach: `zoneOwner=BLUE`, `previousOwner=RED`, `baseOwner=BLUE`, `progress=0`, `status=STABLE`, `captureReady=false`.

Persistence: `SAVED`, `dirtyReason=f10_capture_ready_zone_1_applied`, `dirtyCleared=true`, `productiveRestore=false`.

Kosmetische Auffälligkeit: Die F10-Ausgabe zeigte beim Apply zeitweise `BLUE -> BLUE`; der Runtime-State bestätigte korrekt `previousOwner=RED` und den neuen Owner `BLUE`. Das ist eine reine Anzeige-/Logging-Auffälligkeit, kein CaptureSystem-Fehler; es wurde keine Codeänderung daraus abgeleitet.

Commit: `9396c28 Document completed mission and capture regressions`.

### CaptureSystem Dirty-Tracking korrigiert

Vor dem Fix live reproduziert: `TC.State.clearDirty()` gefolgt von `TC.Campaign.CaptureSystem.getCaptureReadyZones()` ergab `dirty=true`, `dirtyReason=capture_progress_updated`. Problem: Ein Read-/Statuspfad konnte persistenzrelevanten Dirty-State auslösen, obwohl sich fachlich nichts geändert hatte.

Fix in `src/campaign/tc_capture_system.lua`. Commit: `16bbcc6 Fix capture dirty state tracking` (dokumentiert zusätzlich in `2e94b3d Document capture dirty tracking regression`).

Technisches Ergebnis:

- Derived-/Eligibility-State wird nur bei tatsächlicher Änderung persistiert.
- Pauschales Dirty-Setzen im reinen Recompute-/Read-Pfad wurde entfernt.
- Failure-/Applied-Diagnostik wird nur noch bei tatsächlicher Änderung persistiert.

Embedded-Verifikation nach diesem Fix: MIZ Entry `l10n/DEFAULT/tc_capture_system.lua`, `90505` Bytes, SHA-256 `A9E493C5AF0F052AA56862EB38049CF50DE7954BFEDB1080FCD3AB232C74516A`, Repository-SHA-256 identisch, `MATCH=True`.

Live Negativ-Regression: folgende sieben Read-APIs jeweils nach `State.clearDirty()` getestet — `getCaptureReadyZones`, `getPressureContestedZones`, `getPressureSummary`, `getCaptureEligibleBases`, `getCaptureEligibleZones`, `getEligibilitySummary`, `getCaptureProgress`. Alle: `ok=true`, `dirty=false`, `reason=nil`.

Live Positiv-Regression: temporäre Capture-Pressure-Mutation auf `ZONE_AIRBASE_ABU_AL_DUHUR` — `before=0`, `changed=1`, `dirty=true`, `reason=capture_pressure_set`. Rollback: `rollbackOk=true`, `restored=0`, `finalDirty=false`. Kein bleibender Testzustand.

### Capture Ownership No-Op korrigiert

Audit-Befund: Ein Aufruf von `setZoneOwner(zone, currentOwner, ...)` war vorher kein echter No-Op. Mögliche unnötige Mutationen: Zone-Timestamps, Progress-Timestamps, Progress Owner/Status, `captureReady`, `state.Campaign.capture.lastUpdateTime`. Besonders relevant: `progressRecord.previousOwner` konnte durch einen redundanten Owner-Set-Aufruf überschrieben werden und damit historische Owner-Information verlieren.

Zusätzlich geprüft: `lastOwnerCheckAt` wurde nur im alten No-Op-Pfad geschrieben, ist repo-weit nirgends funktional gelesen und hat keine funktionale Abhängigkeit.

Fix in `src/campaign/tc_capture_system.lua`. Commit: `3451082 Fix ownership no-op state mutations`.

Neues Verhalten:

- `setRecordOwner()` schreibt bei identischem Owner nichts.
- `setBaseOwner()` und `setZoneOwner()` machen einen Early Return bei `changed ~= true`.
- Kein Registry-Reassign, kein World-Sync, keine Progress-Mutation, kein `refreshAllCounters()`, kein Event, kein Dirty.
- Echte Ownerwechsel behalten den bisherigen Codepfad.

Finale Embedded-Verifikation nach Re-Embed: Repository-SHA-256 `06326C028388C6737BDB01C8C29C8F029375D612D72ADC1A02F49BFD9DAE9DCE`; MIZ `l10n/DEFAULT/tc_capture_system.lua`, `91160` Bytes, gleiche SHA-256, `MATCH=True`.

Live No-Op-Regression auf Zone `ZONE_AIRBASE_ABU_AL_DUHUR`: `ok=true`, `owner=RED`, `zonePrevBefore=nil`, `zonePrevAfter=nil`, `progressPrevBefore=UNKNOWN`, `progressPrevAfter=UNKNOWN`, `zoneUpdatedSame=true`, `lastOwnerCheckSame=true`, `progressUpdatedSame=true`, `captureLastUpdateSame=true`, `dirty=false`, `reason=nil`.

Status: BEHOBEN / LIVE BESTANDEN.

### reactToActiveMissions() als latenter, nicht aktiver Dirty-Fall bewertet

Datei `src/ai/tc_ai_cap_manager.lua`, Funktion `CapManager.reactToActiveMissions(options)`, READ-ONLY geprüft.

Ergebnis: keine produktive Call-Site. Nicht aufgerufen durch `CapManager.start()`, Scheduler/Timer, `main.lua`, `loader.lua`, F10 oder andere `src/`-Pfade.

Hypothetischer zukünftiger Pfad: `reactToActiveMissions()` -> `requestCap()` -> `addCapToContainer()` -> `updateReactionState()` -> `updateStatistics()`. Bei einem echten CAP Request setzt `addCapToContainer()` bereits `markDirty("ai_cap_record_changed")`.

Latenter Randfall bei `requested==0`: potenziell veränderte persistierte Felder (`state.AI.reactionState`, `state.AI.threatLevel`, `state.AI.capStatistics`, `state.AI.lastUpdate`) ohne zwingenden eigenen Dirty-Call.

Klassifikation: latenter Missing-Dirty-Bug in derzeit nicht verdrahtetem Code. Aktuell KEIN Runtime-Persistence-Bug. Entscheidung: jetzt keine Codeänderung; erst bei tatsächlicher Verdrahtung in den AI-Lifecycle beheben/testen.

### Priority 3 Dirty-Coverage bleibt offen

Bereits geklärt: Capture Getter/Derived Dirty, Capture Ownership No-Op, `reactToActiveMissions()`-Sonderfall.

Noch systematisch zu prüfen, ein System pro Arbeitsschritt:

1. `src/logistics/tc_logistics_delivery.lua`
2. `src/logistics/tc_fob_system.lua`
3. `src/missions/tc_mission_generator.lua`
4. `src/ai/tc_ai_cap_manager.lua`

Nächster technischer Schritt: READ-ONLY Dirty-Coverage-Audit von `src/logistics/tc_logistics_delivery.lua`. Priority 3 ist NICHT abgeschlossen; genau ein System pro Schritt, kein Code-Fix vor dem Audit. Danach folgen separat `src/logistics/tc_fob_system.lua`, `src/missions/tc_mission_generator.lua` und `src/ai/tc_ai_cap_manager.lua`.

Audit-Ziele später: persistierte Writes erfassen, `markDirty()`-Pfade erfassen, echte Mutationen vs. Reads/No-Ops prüfen, Dirty Reasons bewerten, erst bei belegtem Befund Code ändern.

Commit: `1023d1f Document remaining Priority 3 dirty coverage status`.

### Persistence bleibt stabil, produktiver Restore weiter deaktiviert

PersistenceSystem `v0.2.6` bestanden: Embedded Startup, `SAVED`, `SKIPPED`, kontrollierter `FAILED`, Retry, Dirty bleibt bei Fehler erhalten, Dirty wird erst nach vollständiger Write / Read-back / Compile / Evaluate / Validation gelöscht, ein älterer Save-Abschluss löscht keinen neueren Dirty-State, `productiveRestore=false`.

Produktiver Restore wird NICHT aktiviert.

Zu diesem Zeitpunkt gültige Voraussetzungen:

1. Priority 3 allgemeine Dirty-Coverage vollständig abschließen.
2. Restore-/Initialisierungsreihenfolge definieren.
3. Save-Kompatibilitäts-/Versionsstrategie berücksichtigen.
4. Separaten kontrollierten Restore-Test durchführen.

Der erste Punkt wurde am 2026-09-21 im dokumentierten Umfang abgeschlossen.

Weiterhin offen bleiben:

- Restore-/Initialisierungsreihenfolge
- Save-Kompatibilitäts-/Versionsstrategie
- kontrollierter Restore-Test
- spätere Framework-Nebenwirkungen beim Restore

Nicht mehr als Voraussetzungen gültig: "MissionGenerator-State-Verlust klären" und "blockierte Mission/Capture Regressionen durchführen" — beide Punkte sind widerlegt beziehungsweise erledigt.

### Projektdokumentation auf den verifizierten Stand synchronisiert

Die Dokumentationssynchronisierung zum verifizierten Stand 2026-09-12 wurde abgeschlossen.

Synchronisiert wurden damals insbesondere:

- `README.md`
- `ROADMAP.md`
- `TASKS.md`
- `ARCHITECTURE.md`
- `CHANGELOG.md`
- `MISSION_EDITOR_SETUP.md`
- `LUA_STYLEGUIDE.md`
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

Der dort beschriebene technische Stand ist historisch.

Priority 3 wurde anschließend am 2026-09-21 abgeschlossen.

---

## 2026-08-04

### PersistenceSystem v0.2.6 und Dirty-aware Autosave

- Periodischer Autosave verwendet den vorhandenen `TC.State.Persistence`-Dirty-State.
- Unveränderte Ticks werden als `SKIPPED` ohne Dateischreibzugriff protokolliert.
- Dirty Ticks werden als `SAVED` oder `FAILED` protokolliert; beide relevanten Pfade enthalten den Dirty Reason.
- Write, Read-back, Compile, Evaluate und Validation müssen erfolgreich sein, bevor Dirty gelöscht wird.
- Fehler behalten `dirty`, `dirtyReason` und `dirtyAt`; ein erfolgreicher Retry ist bestätigt.
- Ein neuerer Dirty-State wird nicht durch den Abschluss eines älteren Saves gelöscht.
- `20s` Initial Delay, `120s` Intervall und `productiveRestore=false` bleiben erhalten.
- Es gibt keine Persistence-Spieler-F10-Controls und für diese Entwicklungsstufe sind keine geplant.

### Hotload- und Fehlerpfadtests

- `SAVED` und anschließendes `SKIPPED` bestanden.
- Kontrolliert injizierter Schreibfehler erzeugte `FAILED` und behielt Dirty-State sowie Dirty Reason.
- Die bestehende Save-Datei blieb beim injizierten Fehler unverändert.
- Retry nach Wiederherstellung von `io.open` erzeugte `SAVED` und löschte Dirty erst nach erfolgreicher Verifikation.
- Keine neuen Scripting Errors oder Stack Tracebacks.

### Persistence-Ressource in DEV-Mission ersetzt und gespeichert

- Trigger: `TC_LOAD_TC_PERSISTENCE_SYSTEM`
- Typ: `once`
- Bedingung: `time-after 15 seconds`
- Resource Key: `ResKey_advancedFile_56`
- Embedded Filename: `tc_persistence_system_v0_2_6.lua`
- Embedded Bytes entsprachen exakt `src/campaign/tc_persistence_system.lua`.
- Die gespeicherte `.miz` enthält den neuen Key und die neue Ressource.
- Der alte Trigger-Verweis `ResKey_Action_55` wurde entfernt.
- Die native Mission-Editor-Save-Aktion wurde über den DCS-SMS-GUI-Bridge-Pfad verifiziert.

### Normaler Embedded-Scheduler-Test

- PersistenceSystem `v0.2.6` lud über den normalen Mission-Editor-/Simulator-Workflow.
- Der Client-Slot `CLIENT_BLUE_FA18C_AKROTIRI_01` musste ausgewählt und bestätigt werden; danach wurde im Briefing `Fly` gedrückt.
- Der reale Dirty-Grund `ai_cap_needs_evaluated` wurde selbständig als `SAVED` gespeichert.
- `autosaveCount` wechselte von `0` auf `1`; Dirty wurde nach Verifikation gelöscht.
- Drei folgende unveränderte Scheduler-Ticks waren `SKIPPED`.
- Dateigröße, Änderungszeit und SHA-256 der Save-Datei blieben bei `SKIPPED` unverändert.
- Keine neuen `[TC][ERROR]`, `[TC][WARN]`, Scripting Errors oder Stack Tracebacks.
- Die frühere Hotload-only-Scheduler-Einschränkung ist damit behoben.

### DCS-SMS-Entwicklungsumgebung

- Installierte CLI: `C:\Tools\dcs-sms\dcs-sms.exe`
- Mission-Editor- und Runtime-Bridge sowie externe Ausführung sind operational.
- Aktuelle Bridge-Umgebung: `os=true`, `io=true`, `lfs=true`, `require=false`.
- PersistenceSystem selbst benötigt direkt `io` und `lfs`, nicht `os` oder `require`.
- DCS-SMS `exec`, `status` und `tail-log` benötigen `os`, `io` und `lfs` unsanitized.
- DCS-Updates können `MissionScripting.lua` überschreiben.

### MissionGenerator-Record-Verlust untersucht

- MissionGenerator `v0.2.3` startete und erzeugte zehn state-only Missionen.
- Der erste Persistence-Snapshot enthielt zehn verfügbare Missionen, eine `generationHistory`-Entry, `lastMissionId=10` und `lastGenerationTime=22.801`.
- Später wurden alle sechs Status-Collections leer beobachtet, während `lastMissionId=10` und Statistiken `total=10`, `available=10` stehen blieben.
- Der Verlust wurde in einem zweiten normalen Missionslauf reproduziert.
- Mission-Collections sind Dictionaries und müssen mit `pairs()` beziehungsweise `countTableKeys()` gezählt werden; `#` und `ipairs()` sind nicht autoritativ.
- Die widersprüchliche Messung `generationHistory pairs=0`, `#=1` ist kein normales Lua-Verhalten und bleibt ungeklärt.
- Weder exakter Zeitpunkt noch Writer oder Mechanismus sind identifiziert; es ist unbekannt, ob die Collections ersetzt, geleert oder falsch beobachtet wurden.
- PersistenceSystem und Main-Heartbeat sind nicht als Ursache belegt.
- Es wurde kein Code-Fix implementiert.

Statische Klassifikation:

    PROJECT SOURCE HAS NO MATCHING WRITE SITE

Nächste Untersuchung:

- offline/read-only Audit der eingebetteten Theater-Command-Ressourcen in `Operation_Levant_Reclamation_DEV.miz`
- Trigger- und Resource-Mappings sowie Byte-Längen, SHA-256, Versionen, stale/duplizierte/unerwartete/fehlende Skripte prüfen
- Mission Completion, Mission Failure und Capture Ready Apply Regressionen bleiben bis zur Eingrenzung blockiert
- produktiver Restore bleibt deaktiviert und ungetestet

Der Eintrag ist historisch.

Der vermeintliche Record-Verlust wurde am 2026-09-12 als Diagnosefehler widerlegt.

---

## 2026-07-06

Die folgenden Einträge sind der historische Stand dieser Session.

Insbesondere `os=false`, Persistence-Versionen bis `v0.2.5` und damalige nächste Schritte sind keine aktuellen Anweisungen.

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

### F10Menu von v0.2.2 auf v0.2.3 erweitert

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

### Mission Completion Pipeline bestätigt

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

---

### Mission Failure Pipeline bestätigt

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

### PersistenceSystem v0.2.0 eingeführt

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

### Lokale DCS-Sandbox für Persistenz vorbereitet

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

### PersistenceSystem v0.2.1

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

### PersistenceSystem v0.2.2

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

### PersistenceSystem v0.2.3

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

### PersistenceSystem v0.2.4

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
- Produktiver Auto-Restore bleibt deaktiviert.

---

### PersistenceSystem v0.2.5

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

`C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua`

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

---

### Historischer getesteter Modulstand vom 2026-07-06

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.5` | damaliger Stand |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | damaliger Stand |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | damaliger Stand |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | bestanden |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | damaliger Stand |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden |

Die aktuell verbindlichen Versionen stehen in:

- `README.md`
- `TASKS.md`
- `ARCHITECTURE.md`

---

## Aktueller Stand nach 2026-09-29

Aktuell bestätigte Versionen:

| System | Version | Status |
|---|---:|---|
| Airbase Scanner | `v0.2.2` | bestanden |
| ZoneFactory | `v0.2.0` | bestanden |
| CaptureSystem | `v0.2.2` | bestanden |
| PersistenceSystem | `v0.2.6` | Background Persistence bestanden |
| LogisticsDelivery | `v0.2.1` | Read-Neutrality und Runtime-Regression bestanden |
| FobSystem | `v0.2.1` | Read-Neutrality und Runtime-Regression bestanden |
| MissionGenerator | `v0.2.3` | bestanden |
| AICapManager | `v0.2.1` | Read-Neutrality und Runtime-Regression bestanden |
| F10Menu | `v0.2.3` | bestanden |
| CTLD | `1.6.1` | KI-Truppentransport-PoC bestanden |

Aktueller nächster Entwicklungsbereich:

`Priority 4 – produktive CTLD-Integration vorbereiten`

Noch nicht produktiv umgesetzt:

- produktive Theater-Command-CTLD-Bridge
- CTLD-Crate-/Cargo-Wirtschaft
- reale CTLD-FOBs
- echte MOOSE-Spawns
- Skynet-IADS-Kampagnenlogik
- AI Director
- Ground Campaign
- CAS Automation
- Carrier Operations
- produktiver Restore
- Multiplayer

`productiveRestore=false` bleibt unverändert.
