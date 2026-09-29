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
- GitHub = Projektgedächtnis / Source of Truth
- DCS Runtime = autoritativer Verhaltensbeweis

---

## 2026-09-29

### CTLD-KI-Truppentransport für getesteten Aufbau praktisch bestätigt

In einer isolierten DCS-Testmission wurde für den getesteten Aufbau ein vollständiger automatischer CTLD-KI-Truppentransport praktisch bestätigt.

Testmission:

`C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz`

SHA-256 vor dem Runtime-Test:

`5F0D89DF744A7083401E36713B148BD21813FF187CC36EC1F088507163458C57`

Testgruppe:

`TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01`

Testunit:

`TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01`

Luftfahrzeug:

- Mi-8

Bestätigter Pfad:

`Pickup -> Taxi -> Takeoff -> Transit -> Off-Airfield-Anflug -> Landung -> automatischer CTLD-Dropoff -> reale Blue-Bodengruppe`

Der Test ist ein isolierter **Framework-Proof-of-Concept**.

Er bestätigt die technische CTLD-Fähigkeit für diesen getesteten Aufbau.

Er bestätigt noch keine produktive Theater-Command-CTLD-Orchestrierung.

---

### CTLD Pickup-/Dropoff-Zonen zur Laufzeit registriert

Verwendeter Pickup:

`CTLD_PICKUP_BLUE_AKROTIRI_01`

Verwendeter technischer Test-Dropoff:

`CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01`

Bestätigt:

- CTLD `1.6.1` war bereits initialisiert.
- die Pickup-Zone wurde danach als normalisierter Eintrag in `ctld.pickupZones` ergänzt.
- die Dropoff-Zone wurde danach als normalisierter Eintrag in `ctld.dropOffZones` ergänzt.
- beide Einträge wurden aus dem CTLD-Live-State zurückgelesen.
- CTLD verwendete beide Einträge anschließend tatsächlich.
- eine erneute Ausführung von `ctld.initialize()` war für diesen getesteten Runtime-Pfad nicht erforderlich.

Temporärer Pickup-Eintrag:

`{ "CTLD_PICKUP_BLUE_AKROTIRI_01", -1, 10000, 1, 2 }`

Temporärer Dropoff-Eintrag:

`{ "CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01", -1, 2, 1 }`

Architekturfolgerung:

Eine spätere Theater-Command-Integration kann normalisierte CTLD-Zonen nach der bestehenden Vendor-Initialisierung ergänzen.

Diese Registrierung muss produktiv:

- idempotent
- nachvollziehbar
- lifecycle-sicher

implementiert werden.

Aus dem Test wird nicht abgeleitet, dass `ctld.initialize()` generell niemals erneut aufgerufen werden dürfte.

---

### CTLD-KI-Transporter benötigt Registrierung in `transportPilotNames`

Source- und Runtime-Befund:

`ctld.checkAIStatus()`

verarbeitet den getesteten KI-Transporter im relevanten CTLD-AI-Pfad über:

`ctld.transportPilotNames`

Getestete Unit:

`TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01`

Vor temporärer Registrierung:

- `108` Einträge
- Testunit nicht enthalten

Nach idempotenter temporärer Registrierung:

- `109` Einträge
- Testunit genau einmal enthalten

Architekturfolgerung:

Eine produktive Theater-Command-Integration muss vorgesehene KI-Transporter:

- automatisch
- idempotent
- ohne Duplikate
- anhand des exakten Unit-Namens
- unter Berücksichtigung des Transporter-Lifecycles

bei CTLD registrieren.

Dafür war keine direkte Manipulation des CTLD-Onboard-State erforderlich.

---

### Automatischer CTLD-Pickup bestanden

Nach nativer Aktivierung der KI-Gruppe erfolgte der Pickup automatisch über CTLD.

Bestätigt:

- `16` Soldaten wurden aufgenommen.
- der Pickup-Counter wechselte von `10000` auf `9999`.
- der Transporter befand sich im Pickup-Bereich.
- keine direkte Manipulation von `ctld.inTransitTroops`.
- kein manuelles CTLD-Loading.
- kein Teleport.
- keine Runtime-Routenänderung.

Damit ist der automatische KI-Pickup für den getesteten Aufbau praktisch bestätigt.

---

### Off-Airfield-Landung über Perform Task `Land` bestanden

Der erfolgreiche Missionsaufbau verwendete:

`normaler Turning Point`

plus:

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
- Off-Airfield-Anflug
- Landung

Bestätigte minimale Entfernung zum Dropoff-Zentrum:

- ungefähr `1.06 m`

Für diesen getesteten Truppentransport war kein Invisible FARP erforderlich.

Der frühere ungebundene Wegpunkt vom Typ:

`Land / Landing`

hatte keinen vollständigen erfolgreichen Transportzyklus ergeben.

Der erfolgreiche Test zeigt die Landemethode als wichtigen Unterschied zwischen den beiden Versuchsaufbauten.

Die genaue Ursache des früheren Turnback-Verhaltens ist dadurch nicht abschließend bewiesen.

---

### Automatischer CTLD-Dropoff bestanden

Nach der Landung führte CTLD den Dropoff automatisch aus.

Bestätigt:

- der `troops`-Inhalt verschwand aus dem CTLD-In-Transit-State der Testunit.
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
- Runtime-Routenänderung
- Runtime-Taskänderung

Damit ist für den getesteten Aufbau praktisch bestätigt:

`Pickup -> Transport -> Off-Airfield-Landung -> automatischer Dropoff -> Bodengruppe`

---

### CTLD `RepackCommandsPath`-Fehler genau einmal beim Touchdown beobachtet

Beim Touchdown des registrierten KI-Transporters trat im erfolgreichen Test genau einmal auf:

`CTLD.lua:6150: attempt to get length of local 'RepackCommandsPath' (a nil value)`

Stack-Kontext:

- `updateRepackMenu`
- `updateRepackMenuOnlanding`

Source-/Runtime-Einordnung:

- der KI-Transporter war in `ctld.transportPilotNames` registriert.
- damit erreichte die Unit auch einen CTLD-Landing-/Menüpfad.
- `ctld.vehicleCommandsPath[_unitName]` ist für reine KI-Units nicht zwangsläufig vorhanden.
- ein daraus abgeleiteter `RepackCommandsPath` kann deshalb `nil` sein.
- der Vendor-Code behandelt diesen Zustand an der beobachteten Stelle nicht robust.

Der Fehler wurde in diesem Test genau einmal beobachtet.

Er wiederholte sich während der anschließenden Bodenphase nicht.

Der automatische Pickup-/Dropoff-Pfad wurde trotzdem erfolgreich abgeschlossen.

Daraus wird ausdrücklich nicht abgeleitet:

- dass der Fehler harmlos ist
- dass spätere Repack-Menü-Aktualisierungen sicher funktionieren
- dass der betreffende Scheduler definitiv weiterläuft
- dass der betreffende Scheduler definitiv beendet wurde

Dass ein unbehandelter Lua-Fehler den betreffenden Scheduler-Pfad beendet haben könnte, bleibt eine source-basierte technische Inferenz und ist kein direkter Runtime-Beweis.

Verbindlich:

`vendor/ctld/CTLD.lua`

wird dafür nicht gepatcht.

Eine spätere Lösung muss Theater-Command-seitig beziehungsweise über eine saubere Konfigurations-/Integrationsstrategie erfolgen.

---

### CTLD-PoC klar von Cargo-/Crate-Integration abgegrenzt

Der erfolgreiche Test war:

- KI-Truppentransport

Nicht getestet wurden:

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

Eine funktionierende Pickup-/Dropoff-Zonenregistrierung und ein erfolgreicher Truppentransport bedeuten nicht automatisch, dass die CTLD-Crate-/Cargo-Wirtschaft bereits funktioniert.

Cargo-/Crate-Integration bleibt ein separater Entwicklungsbereich.

---

### Produktive Persistence während des CTLD-Tests geschützt

Produktive Save-Datei:

`C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua`

Vor dem Test angelegtes Backup:

`C:\Users\Paul\Documents\TC_miz_backups\operation_levant_reclamation_save__pre_landtask_test_2026-09-29_100813.lua`

Referenz-SHA-256:

`C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596`

Größe:

`3094967 Bytes`

Änderungszeit:

`2026-09-21 15:00:00.5926451`

Während des Tests wurde die produktive Save-Datei temporär schreibgeschützt.

Nach dem Test wurde bestätigt:

- Größe unverändert
- Änderungszeit unverändert
- SHA-256 unverändert
- produktiver Kampagnenstate nicht verändert

Erst nach vollständig beendetem DCS wurde der Schreibschutz entfernt.

Final:

- `ReadOnly=False`
- SHA-256 weiterhin identisch

`productiveRestore=false`

blieb unverändert.

---

### Priority 4 technisch konkretisiert

Der Bereich:

`Priority 4 – produktive CTLD-Integration vorbereiten`

besitzt seit dem Test einen praktisch bestätigten Framework-Pfad.

Für den getesteten Aufbau bestanden:

- Runtime-Zonenregistrierung
- KI-Transporterregistrierung
- automatischer Pickup
- autonomer Flug
- Off-Airfield-Landung
- automatischer Dropoff
- reale Bodengruppe

Noch offen:

- produktive Theater-Command-Orchestrierung
- automatische TC-Zonenregistrierung
- automatische TC-Transporterregistrierung
- Transporter-Lifecycle
- Auftragserzeugung
- Ergebnisvalidierung
- LogisticsDelivery-Rückkopplung
- FobSystem-Rückkopplung
- Dirty-/Persistence-Grenze
- Behandlung von `RepackCommandsPath`
- Crate-/Cargo-Pfad

Der nächste Schritt ist deshalb kein erneuter identischer Mi-8-PoC.

Vor produktivem Code muss die Integrationsgrenze source-backed festgelegt werden.

Keine generische:

`tc_ctld.lua`

oder:

`tc_ctld_bridge.lua`

wird vorschnell eingeführt.

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
- Vorbereitung präziser Arbeitsaufträge

#### Claude + dcs-mcp

Verwendete Version:

`dcs-mcp 0.9.11`

Terrain Store:

`C:\Users\Paul\AppData\Local\dcs-mcp\terrain`

Syria-Terrain:

- installiert

Verwendung:

- strukturierte `.miz`-Analyse
- Mission-Editor-Inhalte prüfen
- Mission-Editor-Inhalte gezielt ändern
- Gruppen
- Units
- Trigger-Zonen
- Wegpunkte
- Tasks
- Airbase-Zuordnungen
- gespeicherte Missionsdateien auditieren

#### Claude Code + DCS-SMS

DCS-SMS:

`0.27.2`

Hook:

`me-bridge-0.27.2`

Verifiziertes Installationsverzeichnis:

`C:\Tools\dcs-sms`

Lokaler Claude-Code-Skill:

`C:\Users\Paul\.claude\skills\dcs-sms\SKILL.md`

Verwendung:

- Mission-Editor-Status
- laufende DCS-Runtime
- Runtime-Lua
- Theater-Command-Live-State
- CTLD-Live-State
- Unit-/Group-State
- Position
- Geschwindigkeit
- Grounded-/Airborne-State
- Logs
- Runtime-Regressionen

Aus dem aktuell bestätigten Stand wird kein exakter Executable-Pfad abgeleitet.

#### Werkzeuggrenze

Diese Werkzeuge sind Entwicklungs- und Diagnosewerkzeuge.

Sie sind keine Runtime-Abhängigkeiten der späteren Theater-Command-Kampagne.

Verbindlicher Arbeitsfluss für Mission-Editor-/Framework-Arbeit:

`ChatGPT -> Claude + dcs-mcp -> gespeicherte Mission -> Claude Code + DCS-SMS -> DCS Runtime -> Ergebnisbewertung -> GitHub`

DCS selbst bleibt die autoritative Instanz für tatsächliches Simulatorverhalten.

---

## 2026-09-21

### Priority 3 im dokumentierten Umfang abgeschlossen

Der am 2026-09-12 noch offene Dirty-Coverage-Bereich wurde anschließend systematisch auditiert.

Geprüft wurden:

1. `src/logistics/tc_logistics_delivery.lua`
2. `src/logistics/tc_fob_system.lua`
3. `src/missions/tc_mission_generator.lua`
4. `src/ai/tc_ai_cap_manager.lua`

Die daraus resultierenden aktiven Fixes und Runtime-Regressionen wurden bis zum:

`2026-09-21`

abgeschlossen.

Ergebnis:

- drei aktive Read-Neutrality-Probleme identifiziert
- LogisticsDelivery betroffen
- FobSystem betroffen
- AICapManager betroffen
- MissionGenerator ohne aktiven Missing-Dirty-Bug
- latente Lifecycle-/No-Op-Punkte separat dokumentiert

Die drei aktiven Probleme wurden behoben und regressionsgetestet.

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

Runtime-Regression:

- bestanden

Dokumentierte Prüfungen:

- `70/70`

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

- reine Statistikberechnung vom persistierenden Update getrennt
- Getter bleiben read-neutral
- echte Mutationspfade behalten ihre Dirty-Semantik

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

Runtime-Regression:

- bestanden

Dokumentierte Prüfungen:

- `87/87`

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

- reine Statistikberechnung eingeführt
- `getStatistics()` und `summary()` verändern keinen State
- weitere Getter initialisieren keinen AI-State mehr
- `updateStatistics()` bleibt als bewusster persistierender Mutationshelfer erhalten

Bestätigte read-neutrale Pfade:

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

Positivtest:

`setCapStatus()`

markiert bei echter Mutation weiterhin:

`dirtyReason=ai_cap_record_changed`

Runtime-Regression:

- bestanden

Dokumentierte Prüfungen:

- `99/99`

Rollback stellte den produktiven Ausgangszustand vollständig wieder her.

---

### MissionGenerator Dirty-Coverage ohne aktiven Code-Fix abgeschlossen

Datei:

`src/missions/tc_mission_generator.lua`

Version:

`v0.2.3`

Der read-only Audit fand keinen aktuell aktiven Missing-Dirty-Bug, der einen Code-Fix erfordert.

Kein Fix wurde allein aus Vorsicht eingeführt.

Der frühere vermeintliche Mission-Record-Verlust bleibt als widerlegte Diagnose dokumentiert.

---

### Priority 3 abgeschlossen, latente Punkte bleiben erhalten

Priority 3 ist seit dem 2026-09-21 im Umfang des dokumentierten Audits und der daraus abgeleiteten aktiven Fixes abgeschlossen.

Dies ist keine pauschale Aussage, dass zukünftige oder derzeit unverdrahtete Lifecycle-Pfade automatisch fehlerfrei sind.

Weiter separat relevant bleiben unter anderem:

- `reactToActiveMissions()` bei späterer Verdrahtung
- No-Op-Fälle einzelner Mutations-APIs
- Start-/Restore-Lifecycle
- State-Initialisierung
- produktiver Persistence-Restore
- spätere Framework-Rückkopplung

Diese Punkte rechtfertigen keinen erneuten vollständigen Priority-3-Audit ohne neuen technischen Anlass.

Nächster Projektbereich wurde danach:

`Priority 4 – CTLD-Integration vorbereiten`

---

## 2026-09-12

### Mission-Record-Diagnose korrigiert

Der am 2026-08-04 angenommene Mission-Record-Verlust wurde widerlegt.

Es gingen zu keinem Zeitpunkt Mission Records verloren.

Betroffene Collections:

- `State.Missions.available`
- `State.Missions.active`
- `State.Missions.completed`
- `State.Missions.failed`
- `State.Missions.expired`
- `State.Missions.cancelled`

Diese Collections sind String-keyed Lua-Dictionaries.

Der Lua-Längenoperator:

`#`

ist dafür nicht autoritativ.

Live nachgewiesen:

- `TC.State.Missions.statistics.available = 10`
- `pairs()`-Count `= 10`
- `#TC.State.Missions.available = 0`

Tatsächlicher Source-Bug:

`src/core/tc_state.lua`

in:

`State.summary()`

Dort wurde `#` für Mission-Dictionaries verwendet.

Fix:

- pairs-basierte Hilfsfunktion `countEntries()`

Commit:

`7d22eb4 Fix mission dictionary counts in state summary`

Der Fix wurde:

- committed
- gepusht
- in der DEV-`.miz` neu eingebettet
- live regressionsgetestet

Temporärer String-Key-Test:

`State.summary().activeMissions = 1`

bei einem eingefügten String-keyed Active-Mission-Eintrag.

Der Testeintrag wurde anschließend wieder entfernt.

Eine repo-weite READ-ONLY-Prüfung fand keine weiteren entsprechenden falschen `#`-Counts auf Mission-State-Dictionaries.

MissionGenerator verwendet dort bereits pairs-basierte Zählung.

Der historische Eintrag vom 2026-08-04 bleibt als damaliger Diagnosezustand dokumentiert.

---

### Offline Embedded Mission Resource Audit bestanden

Das Audit war strikt:

- READ-ONLY
- offline

DEV-Mission und MCP_TEST-Kopie waren beim Audit byte-identisch.

Ergebnis:

- `13/13` für den damaligen Blocker relevante aktive Theater-Command-Ressourcen `EXACT_MATCH`
- `0` aktive Byte-Mismatches
- `0` fehlende beziehungsweise Mapping-fehlerhafte aktive Ressourcen
- keine aktive Embedded-Runtime-Drift

Bekannte Cleanup-Altlast:

`ResKey_Action_55`

beziehungsweise:

`tc_persistence_system.lua`

Status:

- als Ressource weiterhin in der `.miz` vorhanden
- nicht von einem aktiven Trigger referenziert
- nicht geladen
- nicht byte-identisch zur damals aktuellen Persistence-Quelle
- nicht ursächlich für die damaligen Symptome
- separate spätere Cleanup-Aufgabe

Aktiv geladen:

`tc_persistence_system_v0_2_6.lua`

Diese Ressource war beim Audit byte-identisch zu:

`src/campaign/tc_persistence_system.lua`

Embedded Runtime Drift wurde damit als Ursache der früheren Fehldiagnose ausgeschlossen.

---

### DCS-SMS auf v0.27.2 bestätigt

Bestätigt:

- DCS-SMS `v0.27.2`
- Hook `me-bridge-0.27.2`
- nach DCS-Update wurde der MissionScripting-Hook erneut installiert beziehungsweise repariert
- Runtime-Zugriff auf das Mission Environment funktionierte
- `TC` war als Table erreichbar

DCS-SMS bleibt:

- Entwicklungswerkzeug
- Diagnosewerkzeug

und ist kein:

- Theater-Command-Runtime-Framework

---

### Mission Completion, Mission Failure und Capture Ready Apply erneut bestanden

#### Mission Completion

Nach Activation + Completion:

- `available=9`
- `active=0`
- `completed=1`
- `failed=0`
- `statistics.available=9`
- `statistics.active=0`
- `statistics.completed=1`
- `total=10`

Persistence:

- `Periodic autosave decision: SAVED`
- `dirtyReason=f10_active_mission_1_completed`
- `dirtyCleared=true`
- `productiveRestore=false`

#### Mission Failure

Danach:

- `available=8`
- `active=0`
- `completed=1`
- `failed=1`
- `statistics.available=8`
- `statistics.active=0`
- `statistics.completed=1`
- `statistics.failed=1`
- `total=10`

Persistence:

- `SAVED`
- `dirtyReason=f10_active_mission_1_failed`
- `dirtyCleared=true`
- `productiveRestore=false`

#### Capture Ready Apply

Zone:

`ZONE_AIRBASE_ABU_AL_DUHUR`

Vor Apply:

- tatsächlicher Owner-Wechsel `RED -> BLUE`
- Progress `100 %`

Danach:

- `zoneOwner=BLUE`
- `previousOwner=RED`
- `baseOwner=BLUE`
- `progress=0`
- `status=STABLE`
- `captureReady=false`

Persistence:

- `SAVED`
- `dirtyReason=f10_capture_ready_zone_1_applied`
- `dirtyCleared=true`
- `productiveRestore=false`

Kosmetische Auffälligkeit:

Die F10-Ausgabe zeigte beim Apply zeitweise:

`BLUE -> BLUE`

Der Runtime-State bestätigte korrekt:

- `previousOwner=RED`
- neuer Owner `BLUE`

Das war eine Anzeige-/Logging-Auffälligkeit und kein CaptureSystem-Fehler.

Commit:

`9396c28 Document completed mission and capture regressions`

---

### CaptureSystem Dirty-Tracking korrigiert

Vor dem Fix live reproduziert:

`TC.State.clearDirty()`

gefolgt von:

`TC.Campaign.CaptureSystem.getCaptureReadyZones()`

ergab:

- `dirty=true`
- `dirtyReason=capture_progress_updated`

Problem:

Ein Read-/Statuspfad konnte persistenzrelevanten Dirty-State auslösen, obwohl sich fachlich nichts geändert hatte.

Fix:

`src/campaign/tc_capture_system.lua`

Commit:

`16bbcc6 Fix capture dirty state tracking`

Zusätzliche Dokumentation:

`2e94b3d Document capture dirty tracking regression`

Technisches Ergebnis:

- Derived-/Eligibility-State wird nur bei tatsächlicher Änderung persistiert.
- pauschales Dirty-Setzen im reinen Recompute-/Read-Pfad wurde entfernt.
- Failure-/Applied-Diagnostik wird nur bei tatsächlicher Änderung persistiert.

Live Negativ-Regression:

Nach `State.clearDirty()` wurden getestet:

- `getCaptureReadyZones`
- `getPressureContestedZones`
- `getPressureSummary`
- `getCaptureEligibleBases`
- `getCaptureEligibleZones`
- `getEligibilitySummary`
- `getCaptureProgress`

Alle:

- `ok=true`
- `dirty=false`
- `reason=nil`

Live Positiv-Regression:

Temporäre Capture-Pressure-Mutation auf:

`ZONE_AIRBASE_ABU_AL_DUHUR`

Ergebnis:

- `before=0`
- `changed=1`
- `dirty=true`
- `reason=capture_pressure_set`

Rollback:

- `rollbackOk=true`
- `restored=0`
- `finalDirty=false`

Kein bleibender Testzustand.

---

### Capture Ownership No-Op korrigiert

Audit-Befund:

Ein Aufruf von:

`setZoneOwner(zone, currentOwner, ...)`

war vorher kein echter No-Op.

Mögliche unnötige Mutationen:

- Zone-Timestamps
- Progress-Timestamps
- Progress Owner/Status
- `captureReady`
- `state.Campaign.capture.lastUpdateTime`

Besonders relevant:

`progressRecord.previousOwner`

konnte durch einen redundanten Owner-Set-Aufruf überschrieben werden und historische Owner-Information verlieren.

Fix:

`src/campaign/tc_capture_system.lua`

Commit:

`3451082 Fix ownership no-op state mutations`

Neues Verhalten:

- `setRecordOwner()` schreibt bei identischem Owner nichts.
- `setBaseOwner()` und `setZoneOwner()` machen einen Early Return bei `changed ~= true`.
- kein Registry-Reassign.
- kein World-Sync.
- keine Progress-Mutation.
- kein `refreshAllCounters()`.
- kein Event.
- kein Dirty.

Echte Ownerwechsel behalten den bisherigen Codepfad.

Status:

`BEHOBEN / LIVE BESTANDEN`

---

### `reactToActiveMissions()` als latenter, nicht aktiver Dirty-Fall bewertet

Datei:

`src/ai/tc_ai_cap_manager.lua`

Funktion:

`CapManager.reactToActiveMissions(options)`

READ-ONLY geprüft.

Ergebnis:

- keine produktive Call-Site
- nicht aufgerufen durch `CapManager.start()`
- nicht durch Scheduler/Timer
- nicht durch `main.lua`
- nicht durch `loader.lua`
- nicht durch F10
- nicht durch andere aktive `src/`-Pfade

Hypothetischer zukünftiger Pfad:

`reactToActiveMissions() -> requestCap() -> addCapToContainer() -> updateReactionState() -> updateStatistics()`

Bei einem echten CAP Request setzt:

`addCapToContainer()`

bereits:

`markDirty("ai_cap_record_changed")`

Latenter Randfall bei:

`requested==0`

Potentiell veränderte persistierte Felder:

- `state.AI.reactionState`
- `state.AI.threatLevel`
- `state.AI.capStatistics`
- `state.AI.lastUpdate`

ohne zwingenden eigenen Dirty-Call.

Klassifikation:

- latenter Missing-Dirty-Fall
- derzeit nicht verdrahtet
- aktuell kein Runtime-Persistence-Bug

Entscheidung:

Keine Codeänderung zu diesem Zeitpunkt.

Erst bei tatsächlicher Verdrahtung in den AI-Lifecycle erneut prüfen und testen.

---

### Priority 3 war zu diesem Zeitpunkt noch offen

Stand am 2026-09-12:

Noch systematisch zu prüfen:

1. `src/logistics/tc_logistics_delivery.lua`
2. `src/logistics/tc_fob_system.lua`
3. `src/missions/tc_mission_generator.lua`
4. `src/ai/tc_ai_cap_manager.lua`

Der nächste technische Schritt war damals der READ-ONLY Dirty-Coverage-Audit von:

`src/logistics/tc_logistics_delivery.lua`

Dieser historische offene Punkt wurde anschließend bis zum 2026-09-21 im dokumentierten Umfang abgeschlossen.

Commit des damaligen Dokumentationsstands:

`1023d1f Document remaining Priority 3 dirty coverage status`

---

### Persistence blieb stabil, produktiver Restore weiter deaktiviert

PersistenceSystem:

`v0.2.6`

Bestätigt:

- Embedded Startup
- `SAVED`
- `SKIPPED`
- kontrollierter `FAILED`
- Retry
- Dirty bleibt bei Fehler erhalten
- Dirty wird erst nach vollständiger Write-/Read-back-/Compile-/Evaluate-/Validation-Kette gelöscht
- ein älterer Save-Abschluss löscht keinen neueren Dirty-State
- `productiveRestore=false`

Zum damaligen Zeitpunkt war allgemeine Priority-3-Dirty-Coverage noch eine Voraussetzung vor produktivem Restore.

Dieser Punkt wurde am 2026-09-21 im dokumentierten Umfang abgeschlossen.

Weiterhin offen:

- Restore-/Initialisierungsreihenfolge
- Save-Kompatibilitäts-/Versionsstrategie
- kontrollierter Restore-Test
- spätere Framework-Nebenwirkungen beim Restore

---

## 2026-08-04

### PersistenceSystem v0.2.6 und Dirty-aware Autosave

Periodischer Autosave verwendet:

`TC.State.Persistence`

Dirty-State.

Bestätigt:

- unveränderte Ticks werden als `SKIPPED` ohne Dateischreibzugriff protokolliert.
- Dirty-Ticks werden als `SAVED` oder `FAILED` protokolliert.
- relevante Pfade enthalten den Dirty Reason.
- Write, Read-back, Compile, Evaluate und Validation müssen erfolgreich sein, bevor Dirty gelöscht wird.
- Fehler behalten `dirty`, `dirtyReason` und `dirtyAt`.
- erfolgreicher Retry ist bestätigt.
- neuerer Dirty-State wird nicht durch den Abschluss eines älteren Saves gelöscht.
- `20s` Initial Delay.
- `120s` Intervall.
- `productiveRestore=false`.
- keine Persistence-Spieler-F10-Controls.

---

### Hotload- und Fehlerpfadtests

Bestätigt:

- `SAVED`
- anschließendes `SKIPPED`
- kontrolliert injizierter Schreibfehler erzeugte `FAILED`
- Dirty-State blieb beim Fehler erhalten
- Dirty Reason blieb erhalten
- bestehende Save-Datei blieb beim injizierten Fehler unverändert
- Retry nach Wiederherstellung von `io.open` erzeugte `SAVED`
- Dirty wurde erst nach erfolgreicher Verifikation gelöscht
- keine neuen Scripting Errors oder Stack Tracebacks

---

### Persistence-Ressource in DEV-Mission ersetzt

Trigger:

`TC_LOAD_TC_PERSISTENCE_SYSTEM`

Typ:

`once`

Bedingung:

`time-after 15 seconds`

Resource Key:

`ResKey_advancedFile_56`

Embedded Filename:

`tc_persistence_system_v0_2_6.lua`

Bestätigt:

- Embedded Bytes entsprachen `src/campaign/tc_persistence_system.lua`.
- gespeicherte `.miz` enthält den neuen Key und die neue Ressource.
- alter Trigger-Verweis `ResKey_Action_55` wurde entfernt.
- native Mission-Editor-Save-Aktion wurde über den DCS-SMS-GUI-Bridge-Pfad verifiziert.

---

### Normaler Embedded-Scheduler-Test

PersistenceSystem:

`v0.2.6`

lud über den normalen Mission-Editor-/Simulator-Workflow.

Der Client-Slot:

`CLIENT_BLUE_FA18C_AKROTIRI_01`

wurde ausgewählt und bestätigt.

Danach:

`Fly`

Bestätigt:

- realer Dirty-Grund `ai_cap_needs_evaluated` wurde selbständig als `SAVED` gespeichert.
- `autosaveCount` wechselte von `0` auf `1`.
- Dirty wurde nach Verifikation gelöscht.
- drei folgende unveränderte Scheduler-Ticks waren `SKIPPED`.
- Dateigröße, Änderungszeit und SHA-256 der Save-Datei blieben bei `SKIPPED` unverändert.
- keine neuen `[TC][ERROR]`.
- keine neuen `[TC][WARN]`.
- keine neuen Scripting Errors.
- keine neuen Stack Tracebacks.

Die frühere Hotload-only-Scheduler-Einschränkung war damit behoben.

---

### DCS-SMS-Entwicklungsumgebung

Für diesen Entwicklungsstand war DCS-SMS als lokale Mission-Editor-/Runtime-Bridge operational.

Aktuell verifiziertes Installationsverzeichnis:

`C:\Tools\dcs-sms`

Spätere Verifikation bestätigte:

- DCS-SMS `0.27.2`
- Hook `me-bridge-0.27.2`

Ein exakter Executable-Pfad wird im aktuellen verbindlichen Dokumentationsstand nicht als separat verifiziert behandelt.

DCS-Updates können lokale Änderungen an:

`MissionScripting.lua`

überschreiben.

---

### MissionGenerator-Record-Verlust untersucht

Dieser Eintrag dokumentiert ausdrücklich den damaligen Wissensstand.

MissionGenerator:

`v0.2.3`

erzeugte zehn state-only Missionen.

Damals wurde ein möglicher Verlust der Mission-Collections vermutet.

Der erste Persistence-Snapshot enthielt:

- zehn verfügbare Missionen
- eine `generationHistory`-Entry
- `lastMissionId=10`
- `lastGenerationTime=22.801`

Später wurden die Collections in einer Diagnose fälschlich als leer interpretiert.

Statische damalige Klassifikation:

`PROJECT SOURCE HAS NO MATCHING WRITE SITE`

Es wurde kein Code-Fix implementiert.

Dieser Verdacht wurde am:

`2026-09-12`

widerlegt.

Tatsächliche Ursache:

- Mission-Collections sind String-keyed Dictionaries.
- `#table` war für ihre Anzahl nicht autoritativ.

Es gab keinen bestätigten Mission-Record-Datenverlust.

---

## 2026-07-06

Die folgenden Einträge beschreiben den historischen Entwicklungsstand dieser Session.

Persistence-Versionen bis:

`v0.2.5`

und damalige nächste Schritte sind keine aktuellen Anweisungen.

---

### Session-Schwerpunkt

Die Mission-Outcome-/Capture-Pipeline wurde abgeschlossen und die technische Persistence-Grundlage bis zum Background-Autosave-Service aufgebaut.

Der Fokus lag weiterhin auf einer state-first Grundlage.

Damals noch nicht aktiv:

- reale MOOSE-Spawns
- reale CTLD-Aktionen
- reale CTLD-FOBs
- produktive Skynet-IADS-Kampagnenlogik
- produktiver automatischer Startup-Restore
- automatische DCS-Event-Auswertung für Missionserfolg
- produktiver Ownership-Wechsel durch DCS-Ereignisse

---

### F10Menu auf v0.2.3 erweitert

Datei:

`src/ui/tc_f10_menu.lua`

Ziele:

- Mission Details für Mission 1 bis 10
- Missionen über F10 aktivieren
- Active Mission Outcome Status
- Active Mission 1 state-only auf `COMPLETED`
- Active Mission 1 state-only auf `FAILED`
- Capture Ready Zones
- Pressure Contested Zones
- Capture Ready Zone 1 state-only anwenden

Bestätigt:

- `F10Menu v0.2.3` lud korrekt.
- F10-Menü initialisierte mit `commands=33`.
- Mission Details Slot 1 funktionierte.
- Mission Activation Slot 1 funktionierte.
- Active Mission Outcome Status funktionierte.
- Complete Active Mission 1 funktionierte.
- Fail Active Mission 1 funktionierte.
- Capture Ready Zones funktionierten.
- Apply Capture Ready Zone 1 funktionierte.

Bewertung:

- Spieleroberfläche weiterhin state-only.
- keine realen MOOSE-, CTLD- oder Skynet-Aktionen.
- kontrollierter Runtime-Testzugang.
- Persistence bewusst nicht als Spieler-F10-Menü umgesetzt.

---

### Mission Completion Pipeline bestätigt

Bestätigter Ablauf:

1. F10Menu zeigt Mission Details.
2. F10Menu aktiviert Mission.
3. MissionGenerator setzt Mission auf `ACTIVE`.
4. F10Menu setzt aktive Mission state-only auf `COMPLETED`.
5. MissionGenerator bereitet Mission Effects vor.
6. CaptureSystem verarbeitet Mission Effects.
7. CaptureSystem erzeugt Capture Pressure.
8. CaptureSystem setzt Capture Progress auf `100 %`.
9. CaptureSystem erzeugt Capture Ready.
10. F10Menu zeigt Capture Ready Zones.
11. F10Menu wendet Capture Ready Zone state-only an.
12. CaptureSystem setzt Zone Ownership auf `BLUE`.
13. CaptureSystem synchronisiert linked Airbase Ownership auf `BLUE`.
14. Capture Pressure wird zurückgesetzt.
15. Capture Ready geht auf `0`.

Bestätigter Testfall:

- completed mission: `MISSION_2`
- target zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- pressure owner: `BLUE`
- applied pressure: `105`
- progress: `100 %`
- ready vorher: `1`
- ready nach Apply: `0`
- captured zone owner: `BLUE`
- linked airbase owner: `BLUE`

Bewertung:

- Mission-Outcome-to-Capture-Pipeline bestanden.
- Capture Ready Apply bestanden.
- produktiver automatischer Capture-Workflow noch nicht aktiv.

---

### Mission Failure Pipeline bestätigt

Bestätigter Ablauf:

1. Mission aktiviert.
2. Mission state-only auf `FAILED` gesetzt.
3. MissionGenerator setzt Outcome auf `FAILED`.
4. Failure Effects werden state-only vorbereitet.
5. CaptureSystem verarbeitet die Effects.
6. bei `FAILED` wird aktuell kein Capture Pressure angewendet.

Bewertung:

- Failure-Pfad bestanden.
- Failed Missions erzeugen aktuell bewusst keinen Capture Pressure.

---

### PersistenceSystem v0.2.0

Ziel:

- Sandbox-Zugriff prüfen
- `os`
- `io`
- `lfs`
- `require`

Erster damaliger Teststatus:

- `os=false`
- `io=false`
- `lfs=false`
- `require=false`

Bewertung:

- Modul lud.
- kein Lua-Abbruch.
- Dateisystemzugriff zunächst blockiert.
- lokale MissionScripting-Konfiguration erforderlich.

---

### Lokale DCS-Sandbox für Persistence vorbereitet

Lokale Änderung an:

`MissionScripting.lua`

Damals entsperrt:

- `io`
- `lfs`

Damals weiter gesperrt:

- `os`
- `require`

Bestätigter damaliger Status:

- `os=false`
- `io=true`
- `lfs=true`
- `require=false`

Bewertung:

- Dateizugriff für Persistence funktionierte.
- DCS-Updates können diese lokale Änderung überschreiben.

---

### PersistenceSystem v0.2.1

Ziel:

- Sandbox-Schreibtest korrigieren
- `file:write()` nicht wegen eines nil-Rückgabewerts fälschlich als Fehler behandeln
- Read-Test nach Write verwenden

Bestätigt:

- `io=true`
- `lfs=true`
- Sandbox-Datei geschrieben
- Sandbox-Datei gelesen
- Marker gefunden
- `fileSystemAvailable=true`

Testdatei:

`C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\tc_persistence_sandbox_test.lua`

---

### PersistenceSystem v0.2.2

Ziel:

- Campaign-State-Snapshot als Datei schreiben
- kein automatisches Laden
- kein produktiver Restore

Bestätigter Save-Pfad:

`C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua`

Ergebnis:

- erster echter Campaign-State-Snapshot als Lua-Return-Datei geschrieben
- produktiver Restore weiterhin deaktiviert

---

### PersistenceSystem v0.2.3

Ziel:

- Save-Datei lesen
- Inhalt prüfen
- Lua-Return-Tabelle kompilieren
- evaluieren
- Snapshot validieren
- noch nicht produktiv importieren

Bestätigt:

- Datei gelesen
- Save-Marker vorhanden
- Lua-Return-Struktur vorhanden
- Compile bestanden
- Evaluate bestanden
- Validation bestanden
- `sections=10`
- `imported=false`

---

### PersistenceSystem v0.2.4

Ziel:

- gespeicherte Datei lesen
- Snapshot validieren
- Snapshot kontrolliert in `TC.State` importieren
- weiterhin kein produktiver Startup-Restore

Bestätigt:

- Save-Datei geschrieben
- Save-Datei validiert
- Snapshot kontrolliert importiert
- `sections=10`
- `imported=true`
- `productiveRestore=false`

Technische Kette bestanden:

`State -> Snapshot -> Datei schreiben -> Datei lesen -> Datei validieren -> Lua auswerten -> Snapshot importieren`

Produktiver Auto-Restore blieb deaktiviert.

---

### PersistenceSystem v0.2.5

Ziel:

- Persistence vom Test-Timer-Pfad zum Background-Service entwickeln
- keine Spieler-F10-Bedienung
- interner Autosave
- produktiver Restore weiterhin deaktiviert

Technischer Stand:

- Autosave initial nach `20 s`
- Autosave-Intervall `120 s`

Bestätigt:

- `PersistenceSystem v0.2.5` lud korrekt.
- Sandbox-Test bestanden.
- Autosave geplant.
- Autosave automatisch ausgeführt.
- `autosaveCount=1`.
- `productiveRestore=false`.

Bewertung:

- Persistence lief als Hintergrundsystem.
- Spieler mussten keine Save-Aktion über F10 auslösen.
- produktiver Startup-Restore blieb deaktiviert.

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
| CTLD | `1.6.1` | KI-Truppentransport-PoC für getesteten Aufbau bestanden |

Aktueller Entwicklungsbereich:

`Priority 4 – produktive CTLD-Integration vorbereiten`

Noch nicht produktiv umgesetzt:

- Theater-Command-CTLD-Orchestrierung
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

Verbindlich:

`productiveRestore=false`
