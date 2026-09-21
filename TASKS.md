# TASKS.md

Diese Datei ist die operative Aufgabenliste und der wichtigste Übergabepunkt für **Theater Command DCS**.

Neue Sessions sollen zuerst diese Datei lesen und danach den aktuellen GitHub-Stand prüfen, bevor Code geschrieben wird.

---

## 0. Verbindlicher Übergabestand — 2026-09-21

### Aktueller Stand — 2026-09-21

LogisticsDelivery Read-Neutrality-Fix: **BEHOBEN / RUNTIME-REGRESSION BESTANDEN**

- Datei: `src/logistics/tc_logistics_delivery.lua`, Version `v0.2.1`.
- Commit: `d4c439dfeb243621e7bc0ca8906f6cb2cf82491d` („Fix logistics read neutrality"), gepusht und reviewed.
- Fix: Statistikberechnung und Read-Zugriffe sind schreibfrei; `updateStatistics()` persistiert weiterhin bei fachlichen Mutationen.
- Embedded Resource Audit: **bestanden**. Aktiver Trigger `TC_LOAD_TC_LOGISTICS_DELIVERY` -> Resource Key `ResKey_Action_60`; eingebettete Datei ist Version `0.2.1` und byte-identisch mit der lokalen Arbeitsdatei; kein zweiter aktiver LogisticsDelivery-Ladetrigger.
- Runtime-Regression in der vom Nutzer bestätigten DEV-Mission: **bestanden** (DCS-SMS, Mission Environment, Version `0.2.1`; Claude Code meldet 70/70 bestandene Prüfungen).
  - Negativtest: `getStatistics()`, `getHubSummary()` und `summary()` verändern weder persistierten State noch Dirty-Status. Statistiken: 46 Hubs (BLUE 7, RED 24, NEUTRAL 15), 0 Deliveries.
  - Positivtest: isoliertes `createDelivery()` erfolgreich, `dirty=true`, `dirtyReason=logistics_delivery_created`, Statistiken korrekt aktualisiert.
  - Rollback im selben synchronen Lua-Aufruf erfolgreich. Separater Nachher-Check: `dirty=false`, 46 Hubs, 0 Deliveries, `lastDeliveryId=0`.
- Offene Beobachtung: `Meta.updatedAt` war unmittelbar nach dem Rollback auf den Originalwert zurückgesetzt, änderte sich aber bei einer späteren, separaten Nachher-Abfrage erneut. Die Ursache ist nicht nachgewiesen; es wird weder als Logistics-Fehler noch als bewiesen harmloser Scheduler-Effekt eingestuft.
- `productiveRestore=false` bleibt unverändert.
- Latente Punkte aus dem Audit vom 2026-09-13 (`setDeliveryStatus()` bei identischem Status, `completeDelivery()` ohne Already-Completed-Guard, Hub-Neuaufbau in `start()`/`buildHubsFromZones()` vor produktivem Restore) sind nicht Teil dieses Fixes und unverändert bewertet.

Priorität 3 bleibt insgesamt **offen**: Aktive Read-Neutrality-Fixes stehen noch für `src/logistics/tc_fob_system.lua` und `src/ai/tc_ai_cap_manager.lua` aus (zwei aktive Fixes). Der separate latente `reactToActiveMissions()`-Fall bleibt unverändert bewertet (Klassifikation B).

Nächster technischer Schritt: Read-Neutrality-Fix **ausschließlich** in `src/logistics/tc_fob_system.lua`; ein System pro Schritt, keine parallelen Fixes. Danach separate Regression, danach `src/ai/tc_ai_cap_manager.lua`. LogisticsDelivery ist nicht erneut zu fixen oder zu testen.

---

### Übergabestand — 2026-09-12 (historisch, bleibt erhalten)

Der am 2026-08-04 vermutete Mission-Record-Verlust ist widerlegt. Es gab zu keinem Zeitpunkt einen tatsächlichen Verlust von Mission Records. Ursache der früheren Fehldiagnose war ein Diagnosefehler: der Lua-Längenoperator `#` liefert auf String-keyed Dictionaries keinen korrekten Count.

DCS-MCP:

- DCS-MCP wurde erfolgreich eingerichtet und für die Syria Map getestet.

Priorität 1 — Offline Embedded Mission Resource Audit: **BESTANDEN**

Ein strikt READ-ONLY Audit der gespeicherten DEV-Mission wurde durchgeführt:

- DEV-Mission und MCP_TEST-Kopie waren beim Audit byte-identisch (identische Größe, identischer SHA-256).
- Die 13 für den vormaligen Blocker relevanten aktiven Theater-Command-Ressourcen waren sämtlich byte-identisch mit dem Repository: `13/13 EXACT_MATCH`, `0` Byte-Mismatches, `0` fehlende oder mapping-fehlerhafte aktive Ressourcen.
- Eine verwaiste alte Persistence-Ressource wurde gefunden: `ResKey_Action_55` (`tc_persistence_system.lua`) — nicht von einem Trigger referenziert, nicht byte-identisch zum aktuellen Repository, wird **nicht** geladen. Siehe „Bekannte Cleanup-Aufgabe" unten.
- Aktiv geladen wird `tc_persistence_system_v0_2_6.lua`; diese aktive Datei war byte-identisch zu `src/campaign/tc_persistence_system.lua`.
- Damit ist Embedded-Runtime-Drift als Ursache des vermeintlichen Mission-Record-Verlusts ausgeschlossen.

Runtime-Diagnose mit DCS-SMS `v0.27.2`:

- `TC.State.Missions.statistics.available = 10`
- `pairs()`-Count von `TC.State.Missions.available` = `10`
- `#TC.State.Missions.available` = `0`

Damit eindeutig bestätigt:

- Die zehn Mission Records waren zu keinem Zeitpunkt verschwunden.
- Die frühere Diagnose eines Mission-Record-Verlusts vom 2026-08-04 war falsch.
- `State.Missions.available/active/completed/failed/expired/cancelled` sind String-keyed Dictionaries (Keys wie `MISSION_1`); der Lua-Längenoperator `#` liefert darauf keinen korrekten Count. Autoritativ ist ausschließlich `pairs()` bzw. eine pairs-basierte Zählfunktion.

Bestätigter Source-Bug und Fix:

- `src/core/tc_state.lua` -> `State.summary()` verwendete `#State.Missions.active` und `#State.Missions.completed`.
- Fix: lokale pairs()-basierte Hilfsfunktion `countEntries()` ergänzt; beide falschen `#`-Counts durch `countEntries(...)` ersetzt.
- Fix wurde committed und gepusht.
- Aktualisierte `tc_state.lua` wurde neu in die DEV-`.miz` eingebettet: neuer Resource Key `ResKey_Action_57`; `TC_LOAD_TC_STATE` referenziert `ResKey_Action_57` -> `tc_state.lua`.
- Eingebettete `tc_state.lua` ist byte-identisch mit dem Repository.

Runtime-Regression des Fixes: **bestanden**

- `State.summary()` mit leerem State: `pairs=0` / `summary=0`.
- Temporärer String-Key in `State.Missions.active` -> `State.summary().activeMissions = 1`.
- Fix damit live bestätigt.
- Temporärer Testeintrag wurde im selben Lua-Aufruf wieder entfernt.

Repository-weite READ-ONLY Prüfung auf verwandte Bugs:

- Keine weiteren fehlerhaften oder wahrscheinlich fehlerhaften `#`-Counts auf Mission-State-Dictionaries gefunden.
- `MissionGenerator` verwendet dort bereits durchgängig pairs-basierte Counts (`countTableKeys()`).
- Andere `#`-Nutzungen im Projekt betreffen echte numerische Arrays und sind unproblematisch.

DCS-SMS:

- Aktualisiert von `0.27.1` auf `0.27.2`.
- Hook `me-bridge-0.27.2`.
- Auto-Routing per `dcs-sms exec --code ...` erreicht korrekt das Mission Environment.
- `TC` ist darüber als Table erreichbar.

Damit entfallen folgende frühere Blockierungen:

- Mission Completion Regression ist nicht mehr wegen eines vermeintlichen Mission-Record-Verlusts blockiert.
- Mission Failure Regression ist nicht mehr wegen eines vermeintlichen Mission-Record-Verlusts blockiert.
- Capture Ready Apply Regression ist nicht mehr wegen eines vermeintlichen Mission-Record-Verlusts blockiert.

Bekannte, derzeit nicht ursächliche Cleanup-Aufgabe:

- Verwaiste alte Persistence-Ressource `ResKey_Action_55` (`tc_persistence_system.lua`) in der DEV-`.miz` ist bekannt, wird nicht geladen und war nicht ursächlich für vergangene Symptome. Bereinigung ist ein separater, unpriorisierter Cleanup-Schritt.

Zusätzlich am 2026-09-12 bestätigt — Mission Completion, Mission Failure und Capture Ready Apply Regressionen: **alle drei BESTANDEN**

- Vollständige Ergebnisse mit Runtime-State und Persistence-Nachweis siehe Abschnitt 7.1–7.3.
- Persistence hat alle drei State-Änderungen als dirty erkannt und per periodischem Autosave `SAVED` gesichert; `dirtyCleared=true` in allen drei Fällen, `productiveRestore=false` weiterhin unverändert.
- Bekannte kosmetische Auffälligkeit: Die F10-Ausgabe beim Capture Apply zeigte „Owner: BLUE -> BLUE" statt des tatsächlichen Wechsels. Der Runtime-State bestätigt eindeutig `previousOwner=RED` und den neuen Owner `BLUE`. Dies ist eine reine Anzeige-/Logging-Auffälligkeit im F10-Menü, kein CaptureSystem-Fehler. Keine Codeänderung abgeleitet.

Priorität 3 — Dirty-Abdeckung, CaptureSystem-Hauptfund: **BEHOBEN / LIVE BESTANDEN am 2026-09-12**

Live reproduzierter Fehler vor dem Fix:

- `TC.State.clearDirty()` gefolgt von `TC.Campaign.CaptureSystem.getCaptureReadyZones()`.
- Ergebnis vor dem Fix: `dirty=true`, `dirtyReason=capture_progress_updated`.
- Ursache: Capture-Status-/Getter-Pfade führten über `updateCaptureProgress()`/Derived-State-Recomputation zu persistierten Schreibvorgängen bzw. pauschaler Dirty-Markierung, obwohl fachlich keine State-Änderung stattgefunden hatte.

Fix:

- Datei: `src/campaign/tc_capture_system.lua`.
- Commit: „Fix capture dirty state tracking".
- Fix wurde committed, gepusht und anschließend in die DEV-`.miz` neu eingebettet.

Offline Embedded-Verifikation:

- Repository-SHA-256: `A9E493C5AF0F052AA56862EB38049CF50DE7954BFEDB1080FCD3AB232C74516A`.
- MIZ-Ressource: `l10n/DEFAULT/tc_capture_system.lua`, `90505` Bytes, SHA-256 `A9E493C5AF0F052AA56862EB38049CF50DE7954BFEDB1080FCD3AB232C74516A`.
- `MATCH=True`.

Live Negativ-Regression nach dem Fix (unveränderter Read erzeugt kein Dirty mehr):

- `getCaptureReadyZones()` -> `dirty=false`, `reason=nil`.
- Alle sieben geprüften Read-APIs — `getCaptureReadyZones`, `getPressureContestedZones`, `getPressureSummary`, `getCaptureEligibleBases`, `getCaptureEligibleZones`, `getEligibilitySummary`, `getCaptureProgress` — liefern übereinstimmend: `ok=true`, `dirty=false`, `reason=nil`.

Live Positiv-Regression nach dem Fix (echte Mutation markiert weiterhin zuverlässig dirty):

- Temporärer BLUE-Capture-Pressure-Test auf `ZONE_AIRBASE_ABU_AL_DUHUR`: `mutationOk=true`, `before=0`, `changed=1`, `dirty=true`, `reason=capture_pressure_set`.
- Rollback: `rollbackOk=true`, `restored=0`, `finalDirty=false`.
- Teständerung wurde unmittelbar vollständig zurückgerollt; kein bleibender Testzustand.

Damit ist bestätigt:

- Ein unveränderter Capture-Read erzeugt keinen Persistence-Dirty-State mehr.
- Eine echte Capture-State-Mutation markiert weiterhin zuverlässig dirty mit korrektem, spezifischem `dirtyReason`.

Beide zunächst offenen kleineren Verdachtsfälle aus dem ursprünglichen READ-ONLY Audit sind inzwischen am selben Tag bewertet bzw. behoben:

**1. `setZoneOwner()`/`setBaseOwner()` No-Op-Fall — BEHOBEN / LIVE BESTANDEN am 2026-09-12**

- Ausgangsbefund: Ein redundanter Ownership-Set-Aufruf mit `newOwner == currentOwner` war kein sauberer No-Op. Der alte Pfad konnte bei `setZoneOwner()` `Zone.lastOwnerCheckAt`, `Zone.updatedAt`, `Progress.previousOwner`, `Progress.owner`, `Progress.status="OWNER_CHANGED"`, `Progress.captureReady=false`, `Progress.updatedAt` sowie über `refreshAllCounters()` `state.Campaign.capture.lastUpdateTime` verändern — besonders kritisch konnte `Progress.previousOwner` historische Owner-Information unwiderruflich überschreiben.
- Der Capture-Dirty-Hauptfund-Fix markierte diesen Pfad zwar indirekt über `capture_progress_recomputed` dirty, das war jedoch nur ein Nebeneffekt; der eigentliche Fehler — die unnötige State-Mutation beim semantischen No-Op — bestand fort.
- Fix: `src/campaign/tc_capture_system.lua`, Commit „Fix ownership no-op state mutations". `setRecordOwner()` schreibt bei `previousOwner == newOwner` keinerlei persistierten State mehr; `setBaseOwner()` und `setZoneOwner()` beenden `changed==false` sofort — kein Registry-Reassign, kein World-Sync, keine Progress-Mutation, kein `refreshAllCounters()`, kein Event, kein `markDirty`. Echte Ownerwechsel bleiben unverändert.
- `lastOwnerCheckAt` wurde repo-weit geprüft: ausschließlich im alten No-Op-Zweig geschrieben, nirgends funktional gelesen — keine funktionale Abhängigkeit.
- Fix wurde committed und gepusht.
- Offline Embedded-Verifikation nach Re-Embed in die DEV-`.miz`: Repository-SHA-256 `06326C028388C6737BDB01C8C29C8F029375D612D72ADC1A02F49BFD9DAE9DCE`; MIZ-Ressource `l10n/DEFAULT/tc_capture_system.lua`, `91160` Bytes, SHA-256 `06326C028388C6737BDB01C8C29C8F029375D612D72ADC1A02F49BFD9DAE9DCE`; `MATCH=True`.
- Live No-Op-Regression auf `ZONE_AIRBASE_ABU_AL_DUHUR`: `ok=true`, `owner=RED`, `zonePrevBefore=nil`, `zonePrevAfter=nil`, `progressPrevBefore=UNKNOWN`, `progressPrevAfter=UNKNOWN`, `zoneUpdatedSame=true`, `lastOwnerCheckSame=true`, `progressUpdatedSame=true`, `captureLastUpdateSame=true`, `dirty=false`, `reason=nil`. Ein No-Op verändert damit keinen persistierten Ownership-/Progress-State mehr, Historie bleibt erhalten, keine Timestamp-Mutation, kein `capture.lastUpdateTime`, kein Dirty-State; Rückgabe bleibt `success=true`.

**2. `src/ai/tc_ai_cap_manager.lua` / `reactToActiveMissions()` — BEWERTET am 2026-09-12, Klassifikation B**

- READ-ONLY geprüft: Definition `CapManager.reactToActiveMissions(options)`; direkte Call-Sites: keine. Geprüft wurden `CapManager.start()`, Scheduler-/Timer-Pfade, `main.lua`, `loader.lua`, `tc_f10_menu.lua` und sonstige `src/`-Referenzen — die Funktion ist aktuell produktiv nicht erreichbar.
- Hypothetischer Call-Flow bei späterer Verdrahtung: `reactToActiveMissions()` -> Mission-State `active` lesen -> `requestCap()` -> `addCapToContainer()` -> `updateReactionState()` -> `updateStatistics()`. Bei echtem neuem CAP-Request markiert `addCapToContainer()` zuverlässig `markDirty("ai_cap_record_changed")`.
- Latenter Randfall: Wenn `requested==0`, können `updateReactionState()`/`updateStatistics()` persistierte AI-Felder (`state.AI.reactionState`, `state.AI.threatLevel`, `state.AI.capStatistics`, `state.AI.lastUpdate`) verändern, ohne dass dieser Pfad selbst zwingend `markDirty()` auslöst.
- Da die Funktion aktuell keine einzige Call-Site hat, ist dies **kein aktueller Runtime-Persistence-Bug**. Finale Klassifikation: **B) latenter Missing-Dirty-Bug in derzeit nicht verdrahtetem Code.**
- Entscheidung: jetzt keine Codeänderung; ein Fix erfolgt erst, wenn `reactToActiveMissions()` tatsächlich in Scheduler/CapManager-Lifecycle bzw. AI-Reaktionslogik verdrahtet wird. Dieser konkrete Sonderfall gilt innerhalb des aktuellen Audits als bewertet/geschlossen.

Details zu beiden Punkten siehe Abschnitt 9, Priorität 3.

Wichtig — Priorität 3 ist damit weiterhin NICHT insgesamt abgeschlossen: Der READ-ONLY Dirty-Coverage-Audit der vier Systeme `src/logistics/tc_logistics_delivery.lua`, `src/logistics/tc_fob_system.lua`, `src/missions/tc_mission_generator.lua` und `src/ai/tc_ai_cap_manager.lua` ist am 2026-09-13 abgeschlossen. Ergebnis: aktive Dirty-/Read-Neutrality-Bugs in `tc_logistics_delivery.lua`, `tc_fob_system.lua` und `tc_ai_cap_manager.lua` (jeweils schreibt `updateStatistics()`, aufgerufen aus reinen Read-Pfaden wie `getStatistics()`, unbedingt persistierten State bzw. Timestamp); für `tc_mission_generator.lua` ist im aktuellen produktiven Call-Flow kein aktiver Missing-Dirty-Bug nachgewiesen. Priorität 3 bleibt offen, bis die drei aktiven Fixes einzeln umgesetzt und regressionsgetestet sind. Stand 2026-09-21: Der LogisticsDelivery-Fix ist umgesetzt und regressionsgetestet (siehe oben); zwei aktive Fixes (`tc_fob_system.lua`, `tc_ai_cap_manager.lua`) sind noch offen. Details siehe Abschnitt 9, Priorität 3.

Nächster technischer Schritt:

- Stand 2026-09-12/13 (überholt durch den Stand 2026-09-21 oben; jetzt nur noch `tc_fob_system.lua`, danach `tc_ai_cap_manager.lua`): Priorität 3 (Abschnitt 9): Fix der Read-Neutrality zunächst in `src/logistics/tc_logistics_delivery.lua` (am 2026-09-21 erledigt) — jeweils **ein System pro Schritt**, keine parallelen Fixes. Danach separate Regression, danach `src/logistics/tc_fob_system.lua`, danach `src/ai/tc_ai_cap_manager.lua`. Für `src/missions/tc_mission_generator.lua` ist aus dem aktuellen Audit kein aktiver Code-Fix erforderlich. Der CaptureSystem-Getter-Hauptfund und der Ownership-No-Op-Fix sind am 2026-09-12 behoben und live bestanden und sind NICHT erneut zu testen; der `reactToActiveMissions()`-Sonderfall bleibt bewertet und geschlossen (Klassifikation B).

---

### Historischer Zwischenstand — 2026-08-04 (Diagnose durch Audit vom 2026-09-12 widerlegt)

PersistenceSystem `v0.2.6` ist implementiert, in die gespeicherte DEV-Mission eingebettet und mit echten periodischen `SAVED`- und `SKIPPED`-Ticks getestet. Die synchronen `FAILED`- und Retry-Pfade sind ebenfalls bestanden. Produktiver Startup-Restore bleibt deaktiviert und ungetestet.

Damals vermuteter Blocker (widerlegt, siehe oben):

- MissionGenerator `v0.2.3` startet und erzeugt zunächst zehn state-only Missionen.
- Spätere Laufzeitprüfungen fanden alle sechs Status-Collections scheinbar leer, während `lastMissionId=10` und die Statistik `total=10`, `available=10` stehen blieben.
- Der Verlust wurde damals als bestätigt eingestuft und in einem zweiten normalen Missionslauf reproduziert.
- Die genaue Ursache, der genaue Writer und der exakte Zeitpunkt waren nicht identifiziert.
- Unbekannt war, ob die Collections ersetzt, geleert oder durch die Diagnoseumgebung falsch beobachtet wurden.
- Es wurde zu diesem Zeitpunkt kein Code-Fix implementiert.

Damalige statische Audit-Klassifikation:

```text
PROJECT SOURCE HAS NO MATCHING WRITE SITE
```

Damaliger Auftrag (inzwischen als Priorität 1 durchgeführt und bestanden, siehe oben):

Ein strikt read-only Offline-Audit der eingebetteten Theater-Command-Ressourcen in:

```text
C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_DEV.miz
```

Das Audit musste Trigger-Zuordnung, Resource Keys, eingebettete Dateinamen, Byte-Längen, SHA-256, exakte Byte-Gleichheit, Versionen, veraltete oder doppelte Ressourcen, unerwartete Skripte und fehlende erwartete Ressourcen berichten. Es durfte weder DCS noch DCS-SMS-Runtime-Execution verwenden und die `.miz` nicht verändern.

Die damalige Blockierung von Mission Completion, Mission Failure und Capture Ready Apply Regressionen bis zum Audit-Abschluss ist mit dem Ergebnis vom 2026-09-12 aufgehoben (siehe oben).

---

## 1. Projekt

Projektname:

- Theater Command DCS

Erste Kampagne:

- Operation Levant Reclamation

Map:

- Syria

Ausgangslage:

- Blue startet auf Akrotiri / Zypern.
- Das syrische Festland ist zu Beginn rot kontrolliert.
- Red hält zu Beginn den Großteil der strategischen Flugplätze.
- Blue soll sich vom Brückenkopf Zypern aus auf das syrische Festland vorarbeiten.
- Spieler sollen sich mit Client-Flugzeugen in eine laufende Kampagnenlage einklinken.
- Spieler sollen nicht der einzige Motor der Kampagne sein.
- Blue und Red sollen perspektivisch eigene Operationen durchführen.

Grundprinzip:

- Mission Editor = Bühne
- Lua = Kampagnensystem
- GitHub = Projektgedächtnis

Zielbild:

- dynamische Kampagne auf der Syria Map
- state-first Kampagnensystem
- später persistenter Kampagnenzustand
- Missionen, Capture, Logistics, FOBs, AI, IADS, UI und Persistence sollen zusammenwirken
- echte MOOSE-, CTLD- und Skynet-Integration erst nach stabiler State-Grundlage

---

## 2. Arbeitsweise

Es wird immer nur eine konkrete Aufgabe oder eine Datei pro Schritt bearbeitet.

Bei neuen oder ersetzten Dateien gilt:

- exakten Dateipfad angeben
- vollständigen Dateiinhalt liefern
- genau einen vollständigen zusammenhängenden Codeblock liefern
- passenden Commit-Text angeben
- keine halben Dateien
- keine Fortsetzung in mehreren Blöcken
- keine parallelen Aufgabenlisten
- keine Framework-Dateien verändern

Der Nutzer arbeitet überwiegend über:

- GitHub-Weboberfläche
- GitHub Desktop
- DCS Mission Editor

Wichtig für DCS:

Eine per `DO SCRIPT FILE` geladene Lua-Datei wird in die `.miz` eingebettet.

Nach jeder Lua-Änderung gilt:

1. Datei auf GitHub aktualisieren.
2. Lokal per GitHub Desktop fetchen/pullen.
3. DCS Mission Editor öffnen.
4. Die geänderte Datei in der passenden `DO SCRIPT FILE`-Aktion neu auswählen.
5. Mission speichern.
6. Alte `dcs.log` löschen oder umbenennen.
7. DCS starten.
8. Mission testen.
9. Frische `dcs.log` hochladen oder auswerten.

Für saubere Logtests:

1. DCS beenden.
2. `Saved Games\DCS.openbeta\Logs\dcs.log` oder `Saved Games\DCS\Logs\dcs.log` löschen oder umbenennen.
3. DCS neu starten.
4. Mission testen.
5. DCS beenden.
6. Frische `dcs.log` hochladen.

Ein weitergeführter Log kann nur dann für eine Regression genutzt werden, wenn der neue Abschnitt zeitlich eindeutig vom alten Abschnitt getrennt ist.

---

## 3. Vendor-Regeln

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
- Eigene Integrationslogik gehört in fachliche Module unter `src/`.

Nicht erwünscht:

- `tc_moose.lua`
- `tc_mist.lua`
- `tc_ctld.lua`
- `tc_all_in_one.lua`

Eigene Logik wird nach Aufgabenbereichen sortiert, nicht nach Frameworks.

---

## 4. Aktuelle Ladefolge im Mission Editor

Aktuell wird weiter die sichere Einzeldatei-Ladung verwendet.

Vendor-Ladefolge:

1. `vendor/mist/mist.lua`
2. `vendor/moose/Moose.lua`
3. `vendor/ctld/CTLD-i18n.lua`
4. `vendor/ctld/CTLD.lua`
5. `vendor/skynet-iads/SkynetIADS.lua`

Aktive Theater-Command-Ladefolge:

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

- `src/campaign/tc_capture_system.lua` ist aktiv.
- `src/campaign/tc_persistence_system.lua` ist aktiv.
- `src/ui/tc_f10_menu.lua` ist aktiv.
- F10Menu muss nach AI CAP Manager und vor Main geladen werden.
- `src/main.lua` bleibt der Runtime-Startpunkt.
- `src/loader.lua` bleibt aktuell die letzte eigene Datei.
- Starttest-Variante B mit Loader-only-`dofile` ist weiterhin offen.

Aktuelle Entscheidung:

- Bis Variante B praktisch geprüft ist, bleibt die sichere Einzeldatei-Ladung Standard.

---

## 5. Aktiver Source-Stand

Aktive eigene Lua-Dateien:

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

Aktuell nur vorbereitet oder dokumentiert:

- `src/iads/`
- `src/debug/`

---

## 6. Erfolgreich getestete Systeme

Historischer Baseline-Stand: 2026-07-06. Der verbindliche aktuelle Stand steht in Abschnitt 0.

---

### 6.1 Starttest Variante A

Status:

- bestanden

Bestätigt:

- Vendor-Frameworks laden.
- Theater-Command-Dateien laden.
- Loader erkennt Frameworks.
- Main startet.
- Runtime-Systeme initialisieren.
- Loader beendet sauber.

Offen:

- Starttest Variante B mit Loader-only-`dofile` später prüfen.

---

### 6.2 Airbase Scanner

Datei:

- `src/world/tc_airbase_scanner.lua`

Aktuelle getestete Version:

- `v0.2.2`

Status:

- bestanden

Letzte bestätigte Werte:

- total: `225`
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

Bewertung:

- Akrotiri wird korrekt als Blue-Startbasis erkannt.
- Akrotiri wird als `STRATEGIC_AIRFIELD` klassifiziert.
- Syrische Hauptflugplätze werden als Red Strategic Candidates vorbereitet.
- Medical Pads und einfache Helipads werden nicht als strategische Kampagnenziele behandelt.

Offen:

- optionaler Airbase-Debugreport
- Detailausgabe je Airbase-Klasse
- spätere Feinkorrektur einzelner Syria-Namen, falls nötig

---

### 6.3 Zone Factory

Datei:

- `src/world/tc_zone_factory.lua`

Aktuelle getestete Version:

- `v0.2.0`

Status:

- bestanden

Letzte bestätigte Werte:

- total zones: `46`
- classified airbase zones: `46`
- Mission Editor zones: `0`
- skipped airbase-like objects: `179`
- strategic zones: `19`
- secondary zones: `13`
- heliport zones: `1`
- farp zones: `0`
- tactical zones: `13`
- captureZones: `32`
- missionZones: `32`
- logisticsZones: `46`
- startBaseZones: `1`

Bewertung:

- ZoneFactory erzeugt nicht mehr 225 ungefilterte Zonen, sondern 46 relevante Kampagnenzonen.
- Capture-, Mission- und Logistics-Zonen werden aus der Airbase-Klassifizierung abgeleitet.

Offen:

- Mission-Editor-Zonen später ergänzen
- `CAPTURE_`-Zonen praktisch testen
- `TC_ZONE_`-Zonen praktisch testen
- Debug-Report für Zonen ergänzen

---

### 6.4 Capture System

Datei:

- `src/campaign/tc_capture_system.lua`

Aktuelle getestete Version:

- `v0.2.2`

Status:

- bestanden

Letzte bestätigte Startwerte:

- eligibleBases: `32`
- eligibleZones: `32`
- nonCaptureBases: `193`
- nonCaptureZones: `14`
- pressureRecords: `32`
- progressRecords: `32`
- appliedMissionEffects: `0`
- ready: `0`
- contested: `0`

Letzte bestätigte Werte nach Mission Completion:

- completed mission: `MISSION_2`
- target zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- capture pressure owner: `BLUE`
- applied pressure: `105`
- progress: `100%`
- appliedMissionEffects: `1`
- ready: `1`
- contested: `0`

Letzte bestätigte Werte nach Capture Ready Apply:

- captured zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- captured zone owner: `BLUE`
- linked airbase: `Abu al-Duhur`
- linked airbase owner: `BLUE`
- ready danach: `0`
- contested: `0`

Bestätigte Logmarker:

- `[TC] [CaptureSystem] Loaded src/campaign/tc_capture_system.lua v0.2.2`
- `[TC] [CaptureSystem] Capture pressure added: zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE amount=105 progress=100%`
- `[TC] [CaptureSystem] Mission effect applied to capture: mission=MISSION_2 zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE pressure=105`
- `[TC] [CaptureSystem] Completed mission effects processed: applied=1, skipped=0, failed=0, appliedMissionEffects=1`
- `[TC] [CaptureSystem] Zone captured: ZONE_AIRBASE_ABU_AL_DUHUR [BLUE]`
- `[TC] [CaptureSystem] Base captured: Abu al-Duhur [BLUE]`

Bewertung:

- CaptureSystem ist state-first stabil.
- Mission Effects können Capture Pressure erzeugen.
- Capture Ready kann state-only angewendet werden.
- Zone Ownership und Airbase Ownership können state-only synchronisiert werden.
- Produktive automatische Capture-Auswertung über reale DCS-Zonen ist noch offen.
- Capture-Dirty-Tracking-Hauptfund (reine Status-Reads wie `getCaptureReadyZones()` markierten fälschlich `dirty=true`) am 2026-09-12 in `src/campaign/tc_capture_system.lua` behoben und live bestätigt; Details siehe Abschnitt 0 und Abschnitt 9, Priorität 3.
- Ownership-No-Op-Fund (`setZoneOwner()`/`setBaseOwner()` bei `newOwner == currentOwner` veränderten unnötig Progress-/Timestamp-Felder, insbesondere `Progress.previousOwner`) am 2026-09-12 ebenfalls in `src/campaign/tc_capture_system.lua` behoben, committed, gepusht und live bestätigt (Commit „Fix ownership no-op state mutations"); Details siehe Abschnitt 0 und Abschnitt 9, Priorität 3. Beide CaptureSystem-Verdachtsfälle aus dem ursprünglichen Audit sind damit abgedeckt; `tc_ai_cap_manager.lua` `reactToActiveMissions()` ist separat bewertet (siehe Abschnitt 6.8).

Offen:

- Dirty-Markierungen nach Capture-Änderungen und die dirty-aware Autosave-Auswertung sind implementiert und getestet
- automatische Auswertung realer Einheiten in Capture-Zonen
- Ownership-Wechsel später an Logistics, AI, Mission Generator und IADS koppeln
- Capture-Progress langfristig über echte DCS-Ereignisse beeinflussen

---

### 6.5 Logistics Delivery

Datei:

- `src/logistics/tc_logistics_delivery.lua`

Aktuelle getestete Version:

- `v0.2.1`

Status:

- bestanden
- Read-Neutrality-Fix (2026-09-21): Fix / Runtime-Regression bestanden

Letzte bestätigte Werte:

- logistics hubs: `46`
- blue hubs: `7`
- red hubs: `24`
- neutral hubs: `15`
- active hubs: `31`
- limited hubs: `15`
- locked hubs: `0`

Bewertung:

- Logistics Delivery nutzt klassifizierte Kampagnenzonen.
- 46 Logistics Hubs werden erzeugt.
- CTLD wird noch nicht aktiv angesprochen.
- Das ist aktuell korrekt, weil noch keine CTLD-Zonen und keine Template-Gruppen in der DEV-Mission definiert sind.

Read-Neutrality-Fix und Runtime-Regression (2026-09-21):

- `v0.2.1`, Commit `d4c439dfeb243621e7bc0ca8906f6cb2cf82491d` („Fix logistics read neutrality"): Statistikberechnung und Read-Zugriffe sind schreibfrei; `updateStatistics()` persistiert weiterhin bei Mutationen.
- Embedded Resource Audit bestanden (Trigger `TC_LOAD_TC_LOGISTICS_DELIVERY`, `ResKey_Action_60`, byte-identisch mit der lokalen Datei).
- Runtime-Regression bestanden (DEV-Mission, DCS-SMS Mission Environment, Version `0.2.1`, 70/70 Prüfungen laut Claude Code):
  - `getStatistics()`, `getHubSummary()` und `summary()` verändern weder persistierten Logistics-State noch Dirty-Status; Counts korrekt (46 Hubs, BLUE 7 / RED 24 / NEUTRAL 15, 0 Deliveries).
  - Isoliertes `createDelivery()`: erfolgreich, `dirty=true`, `dirtyReason=logistics_delivery_created`, Statistiken korrekt aktualisiert; vollständiger Rollback im selben synchronen Lua-Aufruf, Nachher-Check `dirty=false`, 46 Hubs, 0 Deliveries, `lastDeliveryId=0`.
- Offene Beobachtung: `Meta.updatedAt` änderte sich bei einer späteren Nachher-Abfrage erneut; Ursache nicht nachgewiesen (weder als Logistics-Fehler noch als bewiesen harmlos eingestuft). Details siehe Abschnitt 0.
- `productiveRestore=false` unverändert.

Offen:

- CTLD-Zonen im Mission Editor anlegen
- CTLD Pickup/Dropoff mit Theater Command verbinden
- Supply-Verbrauch modellieren
- Logistics mit Capture-System koppeln
- Logistics-Zustand persistieren

---

### 6.6 FOB System

Datei:

- `src/logistics/tc_fob_system.lua`

Aktuelle getestete Version:

- `v0.2.0`

Status:

- bestanden

Letzte bestätigte Werte:

- FOB candidates: `6`
- stored candidates: `6`
- auto-planned FOBs: `2`
- skipped candidates: `4`

Erzeugte FOBs:

- `FOB Ercan`
- `FOB Gecitkale`

Status der erzeugten FOBs:

- `UNDER_CONSTRUCTION`

Weitere Werte:

- Blue FOBs: `2`

Bewertung:

- FOB System nutzt die Logistics-Hub-Struktur.
- FOBs werden als State-only-Objekte angelegt.
- `planned=0` ist kein Fehler, weil automatisch geplante FOBs durch initialen Baufortschritt direkt in `UNDER_CONSTRUCTION` wechseln.

Offen:

- echte CTLD-FOB-Erstellung
- CTLD-Cargo mit FOB-Baufortschritt koppeln
- FOB-Supply-Verbrauch modellieren
- FOB-Zustand persistieren
- FOBs später als Forward Operations Bases für AI und Spieler nutzen

---

### 6.7 Mission Generator

Datei:

- `src/missions/tc_mission_generator.lua`

Aktuelle getestete Version:

- `v0.2.3`

Status:

- bestanden

Letzte bestätigte Werte:

- mission candidates: `78`
- fobSupportCandidates: `2`
- generated missions: `10`
- reservedCreated: `1`
- duplicatesSkipped: `1`
- typeLimitSkipped: `68`

Bestätigte Missionslogik:

- FOB-Support wird nicht aus der verfügbaren Missionsliste verdrängt.
- Mindestens eine FOB-Support-Mission wird reserviert erzeugt.
- Mission Records enthalten Objectives.
- Mission Records enthalten Briefings.
- Mission Records enthalten Progress-Daten.
- Mission Records enthalten Activation Metadata.
- Mission Records enthalten Outcome-Daten.
- Mission Records enthalten Effect-State-Daten.
- Mission Records enthalten reservierte Execution Hooks für MOOSE, CTLD und Skynet.
- Aktivierte Missionen bleiben `stateOnly=true`.
- Spawn-Hooks bleiben `reserved`.
- Missionen können state-only auf `COMPLETED` gesetzt werden.
- Missionen können state-only auf `FAILED` gesetzt werden.
- Missionseffekte werden state-only vorbereitet.
- vorbereitete Mission Effects können von `CaptureSystem v0.2.2` verarbeitet werden.

Bestätigte F10-/MissionGenerator-Interaktion:

- Mission Details Slot 1 bestätigt.
- Mission Slot 1 aktiviert.
- MissionGenerator setzt Mission Slot 1 auf `ACTIVE`.
- Aktivierung erzeugt `stateOnly=true`.
- Aktivierung erzeugt `spawnHooks=reserved`.
- aktive Mission 1 wurde über F10 auf `COMPLETED` gesetzt.
- aktive Mission 1 wurde über F10 auf `FAILED` gesetzt.
- MissionGenerator erzeugt `Mission effects prepared state-only`.
- MissionGenerator erzeugt `Mission outcome prepared`.
- Outcome bleibt `stateOnly=true`.
- Effects bleiben zunächst `prepared`, werden danach vom CaptureSystem state-only übernommen.

Bewertung:

- MissionGenerator `v0.2.3` hat bestandene Funktionspfade; der am 2026-08-04 vermutete Record-Verlust wurde am 2026-09-12 widerlegt — es ging nie ein Mission Record verloren. Behoben wurde ausschließlich der ursächliche Count-/Diagnosefehler in `src/core/tc_state.lua` -> `State.summary()`, wo die String-keyed Mission-Dictionaries mit `#` statt `pairs()` gezählt wurden.
- Missionsaktivierung ist stabil.
- Mission Completion ist state-only praktisch getestet.
- Mission Failure ist state-only praktisch getestet.
- Mission Effects werden vorbereitet und können vom CaptureSystem verarbeitet werden.
- Failed Missions erzeugen aktuell bewusst keinen Capture Pressure.
- Es werden weiterhin keine echten DCS-Spawns ausgelöst.

Offen:

- Mission `CANCELLED` und `EXPIRED` später testbar machen
- Missionseffekte praktisch auf Logistics, AI und IADS anwenden
- automatische Missionserfolgsauswertung aus DCS-Events/Triggern entwickeln
- Briefingtexte später weiter verfeinern
- weitere Missionstypen ausbauen

---

### 6.8 AI CAP Manager

Datei:

- `src/ai/tc_ai_cap_manager.lua`

Aktuelle getestete Version:

- `v0.2.0`

Status:

- bestanden

Letzte bestätigte Werte:

- cap zone candidates: `31`
- auto-registered CAP zones: `12`
- CAP requests: `12`
- reactionState: `AIR_REACTION_REQUESTED`
- threatLevel: `HIGH`

Bewertung:

- AI CAP Manager bereitet Blue- und Red-CAP-Bedarf als State vor.
- Echter MOOSE-Spawn ist noch nicht aktiv.
- `spawn=MOOSE_PENDING` ist aktuell erwartetes Verhalten.
- `reactToActiveMissions()` wurde am 2026-09-12 im Rahmen von Priorität 3 READ-ONLY bewertet: keine einzige Call-Site (weder `CapManager.start()`, noch Scheduler/Timer, `main.lua`, `loader.lua`, `tc_f10_menu.lua` oder sonstige `src/`-Referenzen) — aktuell produktiv nicht erreichbar. Klassifikation B: latenter Missing-Dirty-Bug in derzeit nicht verdrahtetem Code (bei `requested==0` könnten `updateReactionState()`/`updateStatistics()` `state.AI.reactionState`/`.threatLevel`/`.capStatistics`/`.lastUpdate` ohne eigenes `markDirty()` verändern), aber kein aktueller Runtime-Bug. Fix erst bei tatsächlicher Verdrahtung. Details siehe Abschnitt 0 und Abschnitt 9, Priorität 3.
- Die allgemeine Dirty-Abdeckung des AI CAP Managers wurde am 2026-09-13 zusätzlich zum `reactToActiveMissions()`-Sonderfall geprüft: `updateStatistics()` schreibt bei jedem Aufruf `state.AI.capStatistics` und `state.AI.lastUpdate`; `getStatistics()` ruft `updateStatistics()` auf und wird vom aktuellen F10 AI/CAP-Status produktiv aufgerufen. Ein reiner Status-Read verändert damit persistierten AI-State ohne fachliche Mutation — aktiver Dirty-/Read-Neutrality-Bug, Fix noch offen (siehe Abschnitt 9, Priorität 3).

Offen:

- MOOSE CAP Templates im Mission Editor anlegen
- MOOSE SPAWN-Anbindung implementieren
- AI_A2A_DISPATCHER prüfen
- Blue und Red CAP real spawnen lassen
- CAP-Zustände durch DCS-Events aktualisieren
- CAP-Verluste und CAP-Erfolge auswerten
- Read-Neutrality-Fix für `updateStatistics()`/`getStatistics()` in `tc_ai_cap_manager.lua` umsetzen (Priorität 3, Abschnitt 9)

---

### 6.9 F10 Menu

Datei:

- `src/ui/tc_f10_menu.lua`

Aktuelle getestete Version:

- `v0.2.3`

Status:

- bestanden

Bestätigt im Test vom 2026-07-06:

- F10Menu lädt als `v0.2.3`.
- F10-Menü initialisiert sauber.
- `33` Commands wurden erzeugt.
- `Show Available Missions` funktioniert.
- `Show Mission 1 Details` funktioniert.
- `Activate Mission 1` funktioniert.
- `Show Active Missions` funktioniert.
- `Show Active Mission Outcome Status` funktioniert.
- `Complete Active Mission 1` funktioniert.
- `Fail Active Mission 1` funktioniert.
- `Show Capture Status` funktioniert.
- `Show Capture Ready Zones` funktioniert.
- `Apply Capture Ready Zone 1` funktioniert.
- `Show Pressure Contested Zones` funktioniert.
- Mission Outcome wird auf `COMPLETED` gesetzt.
- Mission Outcome wird auf `FAILED` gesetzt.
- Mission Effects werden state-only vorbereitet.
- Mission Effects werden durch CaptureSystem v0.2.2 state-only in Capture Pressure übernommen.
- Capture Ready wird über F10 sichtbar.
- Capture Ready Zone 1 wird bewusst über F10 angewendet.
- Zone Ownership wird state-only aktualisiert.
- Linked Airbase Ownership wird state-only synchronisiert.
- Capture Pressure wird nach erfolgreichem Capture Apply zurückgesetzt.
- Mission Activation bleibt `stateOnly=true`.
- Spawn-Hooks bleiben `reserved`.
- Keine Lua-Scripting-Fehler.
- Keine Theater-Command-Fehler.
- Keine echten MOOSE-Spawns.
- Keine echten CTLD-Aktionen.
- Keine echten Skynet-Aktionen.
- Keine Persistence-F10-Aktionen, weil Persistenz im Hintergrund laufen soll.

Aktuelle F10-Funktionen:

- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Mission 1 bis Mission 10 Details anzeigen
- Mission 1 bis Mission 10 aktivieren
- Mission Outcome Status anzeigen
- aktive Mission 1 auf `COMPLETED` setzen
- aktive Mission 1 auf `FAILED` setzen
- Kampagnenstatus anzeigen
- Capture-/Pressure-Status anzeigen
- Capture Ready Zones anzeigen
- Capture Ready Zone 1 bewusst anwenden
- Pressure Contested Zones anzeigen
- Logistikstatus anzeigen
- FOB-Status anzeigen

Bewertung:

- F10Menu ist als Test- und Bedienoberfläche für Kampagnenfunktionen stabil.
- Persistence gehört nicht ins Spieler-F10-Menü.
- Persistence läuft im Hintergrund.

Offen:

- Mission Outcome für Slots 2 bis 10 später ergänzen
- Cancel/Expire testbar machen
- F10-Menü später zwischen Spieler-UI und Admin-/Debug-UI trennen
- Spielerseitige Menüs später vereinfachen

---

### 6.10 Persistence System

Datei:

- `src/campaign/tc_persistence_system.lua`

Aktuelle getestete Version:

- `v0.2.6`

Status:

- bestanden

Lokale Voraussetzung:

- In `...\DCS World\Scripts\MissionScripting.lua` müssen `io` und `lfs` für dieses Projekt entsperrt sein.
- Solange die installierte DCS-SMS-Runtime-Bridge verwendet wird, müssen zusätzlich `os`, `io` und `lfs` entsperrt bleiben.
- `require` bleibt bewusst gesperrt.
- Nach DCS-Updates kann diese lokale Änderung überschrieben werden.

Aktueller bestätigter Sandbox-Status:

- `os=true`
- `io=true`
- `lfs=true`
- `require=false`
- `load=true`
- `loadstring=true`
- `loadfile=true`
- `lfsFromRequire=false`
- `fileSystemAvailable=true`

Bestätigter Speicherordner:

- `C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS`

Bestätigte Save-Datei:

- `C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua`

Bestätigter technischer Verlauf:

- `v0.2.0`: Sandbox-Verfügbarkeit geprüft, zunächst blockiert.
- `v0.2.1`: Schreib-/Lesetest korrigiert und bestanden.
- `v0.2.2`: Campaign-State-Snapshot als Datei geschrieben.
- `v0.2.3`: Save-Datei gelesen, kompiliert, evaluiert und validiert.
- `v0.2.4`: Save-Datei kontrolliert in `TC.State` importiert.
- `v0.2.5`: Test-Timer-Kaskade entfernt und Background-Autosave aktiviert.
- `v0.2.6`: Periodischer Autosave dirty-aware; `SAVED`, `SKIPPED`, `FAILED`, Fehlererhalt, Retry und Schutz neuerer Dirty-Zustände bestanden.

Historische Logmarker aus `v0.2.5`:

- `Loaded src/campaign/tc_persistence_system.lua v0.2.5`
- `Persistence sandbox file test passed`
- `Persistence autosave scheduled: initialDelay=20s interval=120s productiveRestore=false`
- `Persistence system initialized: sandboxStatus=PASSED, fileSystemAvailable=true, autosaveScheduled=true, autosaveInterval=120s, productiveRestore=false`
- `Campaign state autosaved`
- `autosaveCount=1`

Nicht mehr vorhandene alte Testmarker:

- `Persistence file save test scheduled`
- `Persistence file validation test scheduled`
- `Persistence file load test scheduled`
- `Campaign state file load test passed`

Bewertung:

- Persistence ist jetzt ein internes Hintergrundsystem.
- Spieler müssen Persistenz nicht über F10 bedienen.
- Autosave startet automatisch nach Missionsstart.
- Autosave-Intervall beträgt aktuell 120 Sekunden.
- Save/Validate/Load-Funktionen bleiben intern vorhanden.
- Produktiver automatischer Restore beim Missionsstart ist noch deaktiviert.
- Dirty-Markierungen sind in CaptureSystem und weiteren aktiven State-Systemen bereits vorhanden.
- Periodischer Autosave wertet den Dirty-State aus und überspringt unveränderte Ticks ohne Dateischreibzugriff.
- Dirty wird erst nach vollständigem Write-/Read-back-/Compile-/Evaluate-/Validation-Erfolg gelöscht.
- Fehler behalten Dirty und Dirty Reason; ein späterer Retry kann denselben Zustand erfolgreich speichern.

Offen:

- produktiven Startup-Restore weiterhin deaktiviert lassen
- fachliche Dirty-Abdeckung der aktiven State-Systeme weiter validieren (Priorität 3, Abschnitt 9) — Mission-/Capture-Regressionen sind am 2026-09-12 bereits erneut bestanden (siehe Abschnitt 7.1–7.3)
- produktiven Restore erst nach vollständiger Dirty-Abdeckung und definierter Restore-Reihenfolge separat freigeben
- Save-Dateiformat langfristig versionieren
- Backup-/Rotationsstrategie für Save-Dateien definieren
- Schutz gegen veraltete oder inkompatible Save-Dateien ergänzen

---

## 7. Aktuell bestätigte End-to-End-Fähigkeiten

### 7.1 Mission Completion zu Capture Pressure

Bestanden:

1. Mission Details über F10 anzeigen.
2. Mission 1 über F10 aktivieren.
3. Active Mission 1 über F10 auf `COMPLETED` setzen.
4. MissionGenerator bereitet Effects state-only vor.
5. CaptureSystem verarbeitet Mission Effects.
6. CaptureSystem erzeugt Capture Pressure.
7. Capture Progress erreicht 100 %.
8. Capture Ready wird erzeugt.
9. Capture Ready Zones werden über F10 angezeigt.

Status:

- bestanden
- state-only
- keine echten DCS-Spawns
- keine echten CTLD-Aktionen
- keine echten Skynet-Aktionen

Erneut bestätigt am 2026-09-12 (nach dem `tc_state.lua`-Fix aus Abschnitt 0):

Ablauf:

- verfügbare Mission über F10 aktiviert
- Mission anschließend über F10 abgeschlossen

Runtime-State über DCS-SMS:

- `available=9`
- `active=0`
- `completed=1`
- `failed=0`
- `statistics.available=9`
- `statistics.active=0`
- `statistics.completed=1`
- `total=10`

Log:

- `Mission status changed -> ACTIVE`
- `Mission outcome -> COMPLETED`
- `stateOnly=true`
- `effects=prepared`

Persistence:

- Periodic autosave decision: `SAVED`
- `dirtyReason=f10_active_mission_1_completed`
- `dirtyCleared=true`
- `productiveRestore=false`

Status am 2026-09-12: **BESTANDEN**

---

### 7.2 Capture Ready Apply

Bestanden:

1. Capture Ready Zone 1 über F10 anwenden.
2. Zone Ownership state-only auf `BLUE` setzen.
3. Linked Airbase Ownership state-only auf `BLUE` setzen.
4. Capture Pressure zurücksetzen.
5. Capture Ready auf 0 zurücksetzen.

Status:

- bestanden
- state-only
- noch nicht automatisch
- Dirty-Markierungen im CaptureSystem vorhanden
- dirty-aware Autosave-Auswertung einschließlich Fehler/Retry und Embedded-Scheduler getestet

Erneut bestätigt am 2026-09-12 (nach dem `tc_state.lua`-Fix aus Abschnitt 0):

Capture Ready vor Apply:

- Zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- Owner-Wechsel: `RED -> BLUE`
- Progress: `100%`

Apply-Ergebnis:

- `Zone captured: ZONE_AIRBASE_ABU_AL_DUHUR [BLUE]`
- `Base captured: Abu al-Duhur [BLUE]`
- F10 Apply erfolgreich
- `stateOnly=true`

Runtime-State über DCS-SMS danach:

- `zoneOwner=BLUE`
- `previousOwner=RED`
- `baseOwner=BLUE`
- `progress=0`
- `status=STABLE`
- `captureReady=false`

Persistence:

- Periodic autosave decision: `SAVED`
- `dirtyReason=f10_capture_ready_zone_1_applied`
- `dirtyCleared=true`
- `productiveRestore=false`

Bekannte kosmetische Auffälligkeit (kein CaptureSystem-Fehler):

- Die F10-Ausgabe zeigte beim Apply „Owner: BLUE -> BLUE" statt des tatsächlichen Wechsels. Der Runtime-State bestätigt eindeutig `previousOwner=RED` und den neuen Owner `BLUE`. Dies ist eine reine Anzeige-/Logging-Auffälligkeit im F10-Menü und wird nicht als CaptureSystem-Fehler gewertet. Keine Codeänderung abgeleitet.

Status am 2026-09-12: **BESTANDEN**

---

### 7.3 Mission Failure

Bestanden:

1. Mission Details über F10 anzeigen.
2. Mission 1 über F10 aktivieren.
3. Active Mission 1 über F10 auf `FAILED` setzen.
4. MissionGenerator setzt Outcome auf `FAILED`.
5. MissionGenerator bereitet Failure Effects state-only vor.
6. CaptureSystem verarbeitet abgeschlossene Mission Effects.
7. CaptureSystem erzeugt bei `FAILED` aktuell keinen Capture Pressure.

Status:

- bestanden
- state-only
- erwartetes Verhalten

Erneut bestätigt am 2026-09-12 (im Anschluss an die erneut bestandene Completion-Regression, nach dem `tc_state.lua`-Fix aus Abschnitt 0):

Runtime-State über DCS-SMS:

- `available=8`
- `active=0`
- `completed=1`
- `failed=1`
- `statistics.available=8`
- `statistics.active=0`
- `statistics.completed=1`
- `statistics.failed=1`
- `total=10`

Log:

- `Mission status changed -> ACTIVE`
- `Mission outcome -> FAILED`
- `stateOnly=true`
- `effects=prepared`

Persistence:

- Periodic autosave decision: `SAVED`
- `dirtyReason=f10_active_mission_1_failed`
- `dirtyCleared=true`
- `productiveRestore=false`

Status am 2026-09-12: **BESTANDEN**

---

### 7.4 Persistence Background Autosave

Bestanden:

1. PersistenceSystem startet.
2. Sandbox-Test prüft `io/lfs/load`.
3. File-System wird als verfügbar bestätigt.
4. Autosave wird automatisch geplant.
5. Campaign-State wird nach 20 Sekunden automatisch gespeichert.
6. Autosave läuft ohne Spieler-F10-Aktion.
7. Produktiver Restore bleibt deaktiviert.

Status:

- bestanden
- Hintergrundsystem
- keine Spieleraktion nötig
- `productiveRestore=false`

---

## 8. Aktuelle Einschränkungen

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
- dirty-aware Autosave-Auswertung und eindeutige Saved-/Skipped-/Failed-Diagnostik
- echte Blue-/Red-KI-Kampagnenoperationen

---

## 9. Wichtigste offene Aufgaben

### Abgeschlossen: Periodischen Autosave dirty-aware machen

Datei:

- `src/campaign/tc_persistence_system.lua`

Aktueller Befund:

- `TC.State.markDirty()` verwaltet bereits `dirty`, `dirtyReason` und `dirtyAt`.
- CaptureSystem und weitere aktive State-Systeme markieren relevante Änderungen bereits dirty.
- Der periodische Autosave prüft den Dirty-State aktuell nicht und schreibt bei jedem Tick.

Ziel:

- Periodischer Autosave speichert nur, wenn der Kampagnenzustand dirty ist.
- Unveränderte periodische Autosave-Ticks werden ohne Dateischreibvorgang übersprungen.
- Nach einem fehlgeschlagenen Save bleibt der Kampagnenzustand dirty.
- Dirty-State wird erst nach einem verifiziert erfolgreichen Save gelöscht.
- Der beim Autosave vorliegende Dirty Reason wird eindeutig geloggt.
- Jeder periodische Autosave-Tick loggt klar, ob er gespeichert, übersprungen oder fehlgeschlagen ist.
- Kein F10-Persistence-Menü.
- Keine Spieleraktion für Save/Load.
- Kein produktiver Restore.
- Keine echten MOOSE-, CTLD- oder Skynet-Runtime-Aktionen.
- Weiterhin state-first und als interner Hintergrunddienst.

Akzeptanzkriterien:

- `PersistenceSystem` lädt und startet sauber.
- Die bestehende Autosave-Planung mit initialem Delay und periodischem Intervall bleibt funktionsfähig.
- Mission Completion Pipeline bleibt stabil.
- Mission Failure Pipeline bleibt stabil.
- Capture Ready Apply bleibt stabil.
- Ein periodischer Tick mit `dirty=true` schreibt und verifiziert die Campaign-Save-Datei.
- Das Save-Log enthält den Dirty Reason und kennzeichnet das Ergebnis eindeutig als gespeichert.
- Nach dem verifiziert erfolgreichen Save ist `dirty=false`.
- Ein nachfolgender Tick ohne State-Änderung schreibt keine Datei und wird eindeutig als übersprungen geloggt.
- Ein absichtlich herbeigeführter Save-Fehler wird eindeutig als fehlgeschlagen geloggt.
- Nach einem fehlgeschlagenen Save bleiben `dirty=true`, `dirtyReason` und die zu sichernde State-Änderung erhalten.
- Nach Wiederherstellung des Dateizugriffs kann ein späterer Tick denselben Dirty-State erfolgreich speichern und erst dann löschen.
- `productiveRestore=false` bleibt unverändert.
- Es werden keine Persistence-F10-Controls hinzugefügt.
- Kein `SCRIPTING ERROR`.
- Kein `Mission script error`.
- Kein `stack traceback`.
- Kein `[TC][ERROR]`.
- Keine echten MOOSE-Spawns.
- Keine CTLD-Aktion.
- Keine Skynet-Aktion.

Erwarteter Testablauf:

1. Mission starten.
2. Mission über F10 aktivieren.
3. Mission über F10 abschließen.
4. Capture Ready Zone 1 über F10 anwenden.
5. Vor dem nächsten Autosave-Tick `dirty=true` und den gesetzten `dirtyReason` bestätigen.
6. Nächsten periodischen Autosave-Tick abwarten.
7. Log bestätigt einen gespeicherten Autosave inklusive Dirty Reason.
8. Save-Datei prüfen und `dirty=false` nach erfolgreicher Schreib-/Leseverifikation bestätigen.
9. Ohne weitere State-Änderung den folgenden periodischen Tick abwarten.
10. Log bestätigt einen übersprungenen Autosave; die Save-Datei wird nicht erneut geschrieben.
11. State kontrolliert erneut dirty markieren und für den Test einen kontrollierten Dateischreibfehler herstellen.
12. Nächsten periodischen Autosave-Tick abwarten.
13. Log bestätigt einen fehlgeschlagenen Autosave inklusive Dirty Reason und Fehlergrund.
14. Bestätigen, dass `dirty=true` und `dirtyReason` nach dem Fehler erhalten bleiben.
15. Dateizugriff wiederherstellen und den nächsten periodischen Tick abwarten.
16. Log und Save-Datei bestätigen den erfolgreichen Retry; erst danach ist `dirty=false`.
17. Gesamten neuen `dcs.log` auf Theater-Command- und Lua-Fehler prüfen.

Ergebnis vom 2026-08-04:

- Implementierung als PersistenceSystem `v0.2.6` abgeschlossen.
- Hotload: `SAVED`, `SKIPPED`, kontrolliertes `FAILED` und erfolgreicher Retry bestanden.
- Normal eingebetteter Start: Scheduler mit `20s` Initial Delay und `120s` Intervall bestanden.
- Realer Dirty-Grund `ai_cap_needs_evaluated` wurde als `SAVED` gesichert.
- Drei folgende unveränderte Ticks wurden als `SKIPPED` protokolliert, ohne die Save-Datei zu verändern.

---

### Abgeschlossen: Offline Embedded Mission Resource Audit (vormals Priorität 1) — BESTANDEN am 2026-09-12

Ziel:

- feststellen, ob die auditierten Repository-Quellen byte-identisch zu den tatsächlich eingebetteten und ausgeführten Ressourcen sind
- veraltete, doppelte, unerwartete oder fehlende Theater-Command-Ressourcen erkennen
- Trigger-zu-Ressource-Zuordnungen verifizieren
- Source-Verhalten von Embedded-Runtime-Drift unterscheiden

Besonders zu vergleichen:

- `src/core/tc_state.lua`
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
- `src/main.lua`
- `src/loader.lua`

Sicherheitsgrenzen:

- offline und read-only
- keine DCS-Runtime-Interaktion
- kein DCS-SMS Runtime Exec
- keine `.miz`-Änderung
- kein spekulativer Code-Fix
- kein produktiver Restore

Akzeptanzkriterien:

- jeder erwartete Trigger und jede Script-Aktion ist mit Resource Key und eingebettetem Dateinamen erfasst
- eingebettete und Repository-Byte-Längen sowie SHA-256 sind dokumentiert
- exakte Byte-Gleichheit ist je Ressource ausgewiesen
- eingebettete und erwartete Versionen sind verglichen
- veraltete, doppelte, unerwartete und fehlende Ressourcen sind eindeutig aufgelistet
- das Ergebnis erklärt keine Ursache ohne Beleg
- der MissionGenerator-Defekt bleibt bis zu einem Beweis ungelöst *(damalige Audit-Vorgabe vom 2026-08-04, keine aktuelle Statusaussage — durch das Ergebnis vom 2026-09-12 historisch überholt: ein MissionGenerator-Defekt hat nie existiert)*

Ergebnis vom 2026-09-12:

- Audit strikt read-only durchgeführt; keine DCS- oder DCS-SMS-Runtime-Execution verwendet, `.miz` nicht verändert.
- DEV-Mission und MCP_TEST-Kopie byte-identisch (Größe und SHA-256 identisch).
- Alle 13 für den damaligen Blocker relevanten aktiven Theater-Command-Ressourcen byte-identisch mit dem Repository: `13/13 EXACT_MATCH`, `0` Mismatches, `0` fehlende/mapping-fehlerhafte aktive Ressourcen.
- Eine verwaiste, nicht referenzierte alte Persistence-Ressource (`ResKey_Action_55`, `tc_persistence_system.lua`) gefunden; sie wird nicht geladen und ist nicht ursächlich (bekannte Cleanup-Aufgabe, siehe Abschnitt 0).
- Embedded-Runtime-Drift damit als Ursache des vermeintlichen Mission-Record-Verlusts ausgeschlossen.
- Anschließende Live-Runtime-Diagnose mit DCS-SMS `v0.27.2` zeigte den tatsächlichen Fehler: `#TC.State.Missions.available = 0`, während `pairs()`-Count und Statistik jeweils `10` waren. Ein MissionGenerator-Defekt existierte nicht; der Fehler lag in `State.summary()` in `src/core/tc_state.lua` (`#` statt `pairs()`).
- Fix in `tc_state.lua` (`countEntries()`) implementiert, committed, gepusht und live per Runtime-Regression bestätigt.

---

### Priorität 2: Persistence Restore später produktiv vorbereiten

Datei:

- `src/campaign/tc_persistence_system.lua`

Status:

- noch nicht freischalten

Voraussetzungen:

- dirty-aware Autosave mit Saved-/Skipped-/Failed-Pfaden erfolgreich getestet
- Save-Datei nach echter State-Änderung geprüft
- keine Regression beim Autosave
- klares Restore-Verhalten bei veralteten Save-Dateien definiert

Ziel später:

- beim Missionsstart vorhandene Save-Datei prüfen
- Save-Datei validieren
- Save-Datei nur bei kompatibler Version importieren
- produktiven Restore eindeutig loggen
- Restore darf keine Initialisierung zerstören

Noch nicht jetzt aktivieren.

---

### Priorität 3: Dirty-Abdeckung der aktiven State-Systeme validieren — IN ARBEIT (CaptureSystem-Hauptfund, Ownership-No-Op-Fund und `reactToActiveMissions()` abgeschlossen; READ-ONLY Vier-Dateien-Audit am 2026-09-13 abgeschlossen; LogisticsDelivery-Fix am 2026-09-21 umgesetzt und Runtime-Regression bestanden, aktive Fixes für zwei Systeme — FobSystem und AICapManager — noch offen)

Dateien später:

- `src/logistics/tc_logistics_delivery.lua`
- `src/logistics/tc_fob_system.lua`
- `src/missions/tc_mission_generator.lua`
- `src/ai/tc_ai_cap_manager.lua`

Ziele:

- vorhandene Dirty-Markierungen auf fachlich relevante State-Änderungen prüfen
- fehlende oder zu häufige Dirty-Markierungen gezielt korrigieren
- Dirty Reasons pro Fachsystem eindeutig und stabil halten
- spätere echte Supply-, Missions- und AI-Änderungen persistenzrelevant behandeln

Voraussetzung:

- dirty-aware Autosave in `tc_persistence_system.lua` bestanden
- Mission Completion, Mission Failure und Capture Ready Apply Regressionen bestanden — erfüllt am 2026-09-12 (siehe Abschnitt 7.1–7.3)

Zwischenergebnis vom 2026-09-12 — CaptureSystem-Hauptfund: **BEHOBEN / LIVE BESTANDEN**

- Live reproduzierter Fehler: `TC.State.clearDirty()` + `TC.Campaign.CaptureSystem.getCaptureReadyZones()` ergab vor dem Fix `dirty=true`, `dirtyReason=capture_progress_updated` — ein reiner Read markierte den Campaign-State fälschlich dirty.
- Fix in `src/campaign/tc_capture_system.lua`, Commit „Fix capture dirty state tracking", committed, gepusht und in die DEV-`.miz` neu eingebettet.
- Offline Embedded-Verifikation: `l10n/DEFAULT/tc_capture_system.lua`, `90505` Bytes, SHA-256 `A9E493C5AF0F052AA56862EB38049CF50DE7954BFEDB1080FCD3AB232C74516A`, identisch zum Repository (`MATCH=True`).
- Live Negativ-Regression: alle sieben geprüften Read-APIs (`getCaptureReadyZones`, `getPressureContestedZones`, `getPressureSummary`, `getCaptureEligibleBases`, `getCaptureEligibleZones`, `getEligibilitySummary`, `getCaptureProgress`) liefern `ok=true`, `dirty=false`, `reason=nil`.
- Live Positiv-Regression: temporärer BLUE-Capture-Pressure-Test auf `ZONE_AIRBASE_ABU_AL_DUHUR` — `dirty=true`, `reason=capture_pressure_set`; vollständig zurückgerollt (`rollbackOk=true`, `finalDirty=false`), kein bleibender Testzustand.
- Vollständige Details siehe Abschnitt 0.

Zwischenergebnis vom 2026-09-12 — Ownership-No-Op-Fund (`setZoneOwner()`/`setBaseOwner()`): **BEHOBEN / LIVE BESTANDEN**

- Ausgangsbefund: Ein redundanter Ownership-Set-Aufruf mit `newOwner == currentOwner` war kein sauberer No-Op und veränderte unnötig `Zone.lastOwnerCheckAt`, `Zone.updatedAt`, `Progress.previousOwner`, `Progress.owner`, `Progress.status="OWNER_CHANGED"`, `Progress.captureReady=false`, `Progress.updatedAt` sowie über `refreshAllCounters()` `state.Campaign.capture.lastUpdateTime`. Besonders kritisch: `Progress.previousOwner` konnte historische Owner-Information unwiderruflich überschreiben. Der Capture-Dirty-Hauptfund-Fix markierte diesen Pfad nur als Nebeneffekt über `capture_progress_recomputed` dirty — der eigentliche Fehler (unnötige State-Mutation) blieb bestehen.
- Fix in `src/campaign/tc_capture_system.lua`, Commit „Fix ownership no-op state mutations": `setRecordOwner()` schreibt bei `previousOwner == newOwner` keinerlei persistierten State mehr; `setBaseOwner()`/`setZoneOwner()` beenden `changed==false` sofort, ohne Registry-Reassign, World-Sync, Progress-Mutation, `refreshAllCounters()`, Event oder `markDirty`. Echte Ownerwechsel unverändert. `lastOwnerCheckAt` repo-weit geprüft: nirgends funktional gelesen, keine Abhängigkeit.
- Committed und gepusht. Offline Embedded-Verifikation: `l10n/DEFAULT/tc_capture_system.lua`, `91160` Bytes, SHA-256 `06326C028388C6737BDB01C8C29C8F029375D612D72ADC1A02F49BFD9DAE9DCE`, identisch zum Repository (`MATCH=True`).
- Live No-Op-Regression auf `ZONE_AIRBASE_ABU_AL_DUHUR`: `ok=true`, `owner=RED`, `zonePrevBefore/After=nil`, `progressPrevBefore/After=UNKNOWN` (Historie erhalten), `zoneUpdatedSame=true`, `lastOwnerCheckSame=true`, `progressUpdatedSame=true`, `captureLastUpdateSame=true`, `dirty=false`, `reason=nil`, `success=true`.

Zwischenergebnis vom 2026-09-12 — `src/ai/tc_ai_cap_manager.lua` / `reactToActiveMissions()`: **BEWERTET, Klassifikation B**

- READ-ONLY vollständig geprüft: Definition `CapManager.reactToActiveMissions(options)`; keine direkten Call-Sites. Geprüft: `CapManager.start()`, Scheduler-/Timer-Pfade, `main.lua`, `loader.lua`, `tc_f10_menu.lua`, sonstige `src/`-Referenzen — aktuell produktiv nicht erreichbar.
- Hypothetischer Call-Flow bei Verdrahtung: `reactToActiveMissions()` -> Mission-State `active` lesen -> `requestCap()` -> `addCapToContainer()` -> `updateReactionState()` -> `updateStatistics()`. Bei echtem neuem CAP-Request markiert `addCapToContainer()` zuverlässig `markDirty("ai_cap_record_changed")`.
- Latenter Randfall bei `requested==0`: `updateReactionState()`/`updateStatistics()` könnten `state.AI.reactionState`, `.threatLevel`, `.capStatistics`, `.lastUpdate` ohne eigenes `markDirty()` verändern.
- Da keine Call-Site existiert, aktuell **kein Runtime-Persistence-Bug**. Finale Klassifikation: **B) latenter Missing-Dirty-Bug in derzeit nicht verdrahtetem Code.**
- Entscheidung: keine Codeänderung jetzt; Fix erst bei tatsächlicher Verdrahtung in Scheduler/CapManager-Lifecycle bzw. AI-Reaktionslogik. Dieser Sonderfall gilt als bewertet/geschlossen.

Zwischenergebnis vom 2026-09-13 — READ-ONLY Dirty-Coverage-Audit `src/logistics/tc_logistics_delivery.lua`: **AKTIVER Dirty-/Read-Neutrality-Bug** — **HISTORISCHER AUSGANGSBEFUND, am 2026-09-21 behoben (siehe unmittelbar folgendes Ergebnis)**

- Befund: `updateStatistics()` schreibt bei jedem Aufruf persistierten State (`state.Logistics.statistics = statistics`, `state.Logistics.lastUpdateTime = getCurrentTime()`) — auch wenn es von reinen Read-Pfaden aufgerufen wird: `getStatistics()`, `getHubSummary()`, `summary()`.
- Der aktuelle F10-Logistikstatus ruft `getStatistics()` produktiv auf. Folge: Ein reiner Status-Read kann persistierten Logistics-State verändern, ohne dass eine fachliche Mutation stattgefunden hat.
- Nicht einfach `markDirty()` in den Getter einbauen. Geplanter Fix: Read-/Summary-Pfade persistence-neutral machen; Statistics nur bei tatsächlicher fachlicher Änderung persistieren bzw. Timestamp nicht aufgrund eines Reads verändern.
- Weitere latente Punkte (aktuell keine belegten produktiven Runtime-Blocker): `setDeliveryStatus()` ist bei identischem Status kein echter No-Op; `completeDelivery()` besitzt keinen expliziten Already-Completed-Guard; `LogisticsDelivery.start()`/`buildHubsFromZones()` baut die Hub-Tabelle vollständig neu — vor produktivem Restore muss die Init-/Restore-Reihenfolge berücksichtigt werden.

Ergebnis vom 2026-09-21 — `src/logistics/tc_logistics_delivery.lua` `v0.2.1`: **BEHOBEN / RUNTIME-REGRESSION BESTANDEN**

- Commit `d4c439dfeb243621e7bc0ca8906f6cb2cf82491d` („Fix logistics read neutrality"), gepusht und reviewed. Fix: schreibfreie Statistikberechnung und Read-Zugriffe; `updateStatistics()` persistiert weiterhin bei Mutationen.
- Embedded Resource Audit bestanden: aktiver Trigger `TC_LOAD_TC_LOGISTICS_DELIVERY`, Resource Key `ResKey_Action_60`, eingebettete Datei und lokale Arbeitsdatei byte-identisch, Version `0.2.1`.
- Runtime-Regression in der vom Nutzer bestätigten DEV-Mission (DCS-SMS, Mission Environment, Version `0.2.1`), 70/70 bestandene Prüfungen laut Claude Code:
  - Negativtest: `getStatistics()`, `getHubSummary()` und `summary()` verändern weder persistierten State noch Dirty-Status. Statistiken: 46 Hubs (BLUE 7, RED 24, NEUTRAL 15), 0 Deliveries.
  - Positivtest: isoliertes `createDelivery()` erfolgreich, `dirty=true`, `dirtyReason=logistics_delivery_created`, Statistiken korrekt aktualisiert.
  - Rollback im selben synchronen Lua-Aufruf erfolgreich. Separater Nachher-Check: `dirty=false`, 46 Hubs, 0 Deliveries, `lastDeliveryId=0`.
- Offene Beobachtung: `Meta.updatedAt` war unmittelbar nach dem Rollback auf den Originalwert zurückgesetzt, änderte sich aber bei einer späteren Nachher-Abfrage erneut. Ursache nicht nachgewiesen; weder als Logistics-Fehler noch als bewiesen harmloser Scheduler-Effekt deklariert.
- `productiveRestore=false` unverändert. Die oben genannten latenten Logistics-Punkte (`setDeliveryStatus()`, `completeDelivery()`, Hub-Neuaufbau vor Restore) sind nicht Teil dieses Fixes.
- LogisticsDelivery ist nicht erneut zu fixen oder zu testen.

Zwischenergebnis vom 2026-09-13 — READ-ONLY Dirty-Coverage-Audit `src/logistics/tc_fob_system.lua`: **AKTIVER Dirty-/Read-Neutrality-Bug**

- Befund: `updateStatistics()` schreibt bei jedem Aufruf persistierten State (`state.Logistics.fobStatistics = statistics`, `state.Logistics.lastFobUpdateTime = getCurrentTime()`) — auch von reinen Read-Pfaden: `getStatistics()`, `summary()`.
- Der aktuelle F10-FOB-Status ruft `getStatistics()` produktiv auf. Folge: Ein reiner FOB-Status-Read verändert persistierten State ohne fachliche Mutation.
- Geplanter Fix: Read-/Summary-Pfade persistence-neutral machen; kein Timestamp-/Statistics-Rewrite nur aufgrund eines Reads.
- Weitere latente No-Op-Fälle (aktuell keine produktive F10-Mutation dieser Funktionen nachgewiesen): `setStatus()` bei gleichem Status, `setOwner()` bei gleichem Owner (kann `previousOwner` und Timestamps unnötig überschreiben), `addSupply(..., 0)`, `addConstructionProgress(..., 0)`, `applyPayload()` mit fachlich leerem Payload.
- `FobSystem.start()` baut Candidates neu, erhält bestehende FOB-Records aber grundsätzlich; vor produktivem Restore muss der Start-/Restore-Ablauf trotzdem separat bewertet werden.

Zwischenergebnis vom 2026-09-13 — READ-ONLY Dirty-Coverage-Audit `src/missions/tc_mission_generator.lua`: **KEIN aktiver Missing-Dirty-Bug im aktuellen produktiven Call-Flow nachgewiesen**

- Aktuelle echte Mutationspfade besitzen Dirty-Coverage: Mission Generation (`dirtyReason=mission_generation`), Mission Activation (`mission_activated`), Mission Progress (`mission_progress_updated`), Mission Outcome (`mission_outcome_<STATUS>`), Effect Preparation (`mission_effects_prepared`), Completion Effect Preparation (`mission_completion_effect_prepared`).
- `updateStatistics()` aktualisiert deterministische Count-/Statuswerte, setzt aber keinen neuen `lastUpdate`-Timestamp und ersetzt nicht den gesamten Mission-State. `getStatistics()`/`summary()` zeigen deshalb aktuell nicht denselben aktiven Read-Timestamp-Bug wie Logistics/FOB/AI.
- Latente Punkte: `updateMissionProgress()` ist bei identischem Progress/Stage kein echter No-Op und schreibt `updatedAt` + Dirty; wiederholte Effect-Preparation kann History/Counter erneut erhöhen; `start()`/`generateMissions()` schreibt Generation-History und Dirty auch bei erneutem Generation-Lauf — für späteren produktiven Restore muss dieser Lifecycle berücksichtigt werden.
- Aktuell kein Code-Fix für MissionGenerator aus diesem Audit abgeleitet.

Zwischenergebnis vom 2026-09-13 — READ-ONLY Dirty-Coverage-Audit `src/ai/tc_ai_cap_manager.lua` (allgemeine Dirty-Abdeckung über den `reactToActiveMissions()`-Sonderfall hinaus): **AKTIVER Dirty-/Read-Neutrality-Bug**

- Technischer Hauptbefund: `updateStatistics()` schreibt bei jedem Aufruf `state.AI.capStatistics = { ... }` und `state.AI.lastUpdate = getCurrentTime()`. `getStatistics()` ruft `updateStatistics()` auf. Der aktuelle F10 AI/CAP-Status ruft `getStatistics()` produktiv auf. Folge: Ein reiner AI/CAP-Status-Read verändert persistierten AI-State ohne fachliche Mutation.
- Geplanter Fix: `getStatistics()`/Read-Pfade persistence-neutral machen; kein `capStatistics`-/`lastUpdate`-Rewrite nur aufgrund eines Reads.
- Weitere latente Punkte: `setCapStatus()` bei identischem Status ist kein sauberer No-Op; `clearRequestedCaps()`/`clearCapZones()` markieren auch bei bereits leerem State dirty; `CapManager.start()` setzt aktuell `capZones={}` und `capRequests={}` — vor produktivem Restore ist das ein wichtiger Restore-/Init-Lifecycle-Punkt, weil geladener State sonst überschrieben werden könnte.
- Der bereits bewertete Sonderfall `reactToActiveMissions()` (Klassifikation B, latent, kein Runtime-Bug, siehe oben) bleibt davon unberührt zusätzlich bestehen.

Noch offen — Priorität 3 bleibt deshalb insgesamt **offen**:

- Der READ-ONLY Dirty-Coverage-Audit der vier Systeme ist abgeschlossen. Der aktive Fix für `src/logistics/tc_logistics_delivery.lua` ist seit 2026-09-21 umgesetzt und regressionsgetestet (siehe oben). Aktive Fixes sind noch erforderlich für `src/logistics/tc_fob_system.lua` und `src/ai/tc_ai_cap_manager.lua` (jeweils Read-Neutrality-Bug in `updateStatistics()`/`getStatistics()`) — zwei aktive Fixes offen. Für `src/missions/tc_mission_generator.lua` ist kein aktiver Code-Fix erforderlich.
- Nächster Schritt: Fix ausschließlich in `src/logistics/tc_fob_system.lua`, ein System pro Schritt, keine parallelen Fixes. Danach separate Regression, danach `tc_ai_cap_manager.lua`.

Status: CaptureSystem-Hauptfund behoben, Ownership-No-Op-Fund behoben, `reactToActiveMissions()` bewertet (Klassifikation B) — alle drei live bestanden bzw. abgeschlossen bewertet. Der READ-ONLY Dirty-Coverage-Audit der vier verbleibenden Systeme ist am 2026-09-13 abgeschlossen. Der LogisticsDelivery-Fix (`v0.2.1`) ist seit 2026-09-21 umgesetzt und Runtime-Regression bestanden. Priorität 3 als Ganzes bleibt **offen**, bis die aktiven Fixes in `tc_fob_system.lua` und `tc_ai_cap_manager.lua` einzeln umgesetzt und regressionsgetestet sind. Der separate latente `reactToActiveMissions()`-Fall bleibt unverändert bewertet (Klassifikation B).

---

### Priorität 4: CTLD-Integration vorbereiten

Ziele:

- CTLD-Zonen im Mission Editor anlegen
- Pickup-/Dropoff-Zonen definieren
- Cargo-/Crate-Typen für Theater Command festlegen
- CTLD-Events später in Logistics und FOB-System überführen

Noch nicht direkt als nächster Schritt.

---

### Priorität 5: MOOSE AI-Spawns vorbereiten

Ziele:

- MOOSE CAP Templates im Mission Editor anlegen
- Blue/Red CAP Templates benennen
- Spawn-Zonen prüfen
- AICapManager mit echten MOOSE-Spawns verbinden

Noch nicht direkt als nächster Schritt.

---

### Priorität 6: IADS vorbereiten

Ziele:

- Skynet-IADS-Struktur einführen
- SAM-/EWR-Gruppen im Mission Editor sauber benennen
- IADS-Zustand später persistieren
- Missionen gegen IADS-Ziele erzeugen

Noch nicht direkt als nächster Schritt.

---

## 10. Bekannte DCS-/Log-Hinweise

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

## 11. Aktueller Abschlussstand

Bestandene Systeme:

| System | Version | Status |
|---|---:|---|
| Airbase Scanner | `v0.2.2` | bestanden |
| ZoneFactory | `v0.2.0` | bestanden |
| CaptureSystem | `v0.2.2` | bestanden; Capture-Dirty-Tracking-Hauptfund und Ownership-No-Op-Fund am 2026-09-12 behoben und live bestätigt (siehe Abschnitt 9, Priorität 3) |
| LogisticsDelivery | `v0.2.1` | Fix / Runtime-Regression bestanden; Read-Neutrality-Bug in `updateStatistics()`/`getStatistics()` (Befund vom 2026-09-13) am 2026-09-21 behoben, Embedded Resource Audit und Runtime-Regression bestanden (siehe Abschnitt 9, Priorität 3) |
| FobSystem | `v0.2.0` | bestanden; aktiver Dirty-/Read-Neutrality-Bug in `updateStatistics()`/`getStatistics()` am 2026-09-13 identifiziert, Fix noch offen (siehe Abschnitt 9, Priorität 3) |
| MissionGenerator | `v0.2.3` | bestanden; vermeintlicher Record-Verlust am 2026-09-12 widerlegt (kein Datenverlust); behoben wurde der ursächliche Count-/Diagnosefehler in `tc_state.lua` (`#` statt `pairs()`); Priorität-3-Audit vom 2026-09-13 fand keinen aktiven Missing-Dirty-Bug |
| AICapManager | `v0.2.0` | bestanden; aktiver Dirty-/Read-Neutrality-Bug in `updateStatistics()`/`getStatistics()` am 2026-09-13 identifiziert, Fix noch offen; `reactToActiveMissions()` bewertet (Klassifikation B) (siehe Abschnitt 9, Priorität 3) |
| F10Menu | `v0.2.3` | bestanden |
| PersistenceSystem | `v0.2.6` | Embedded-Scheduler, Save/Skip und Fehler/Retry bestanden |

Aktuelle bestätigte Fähigkeiten:

- Syria-Airbase-Scan funktioniert.
- Kampagnenzonen werden korrekt state-only erzeugt.
- Capture-System erzeugt Druck und Ready-Status.
- Mission Generator erzeugt beim Start 10 Missionen mit reservierten Hooks; die sechs Status-Dictionaries bleiben korrekt befüllt. Der frühere Eindruck einer späteren Leerung war ein `#`-vs-`pairs()`-Diagnosefehler in `tc_state.lua`, seit 2026-09-12 behoben.
- F10Menu-Funktionspfade für Mission Details, Activation, Completion, Failure und Capture Ready Apply sind bestanden; auswählbare Mission Records sind vorhanden und fehlten nie tatsächlich.
- Mission Completion kann Capture Pressure erzeugen.
- Mission Failure bleibt ohne Capture Pressure.
- Capture Ready Apply kann Zone und Airbase state-only auf Blue setzen.
- Mission Completion, Mission Failure und Capture Ready Apply sind am 2026-09-12 mit echtem Runtime-State und dirty-aware Autosave-Nachweis erneut bestanden (siehe Abschnitt 7.1–7.3).
- Capture-Status-Reads (`getCaptureReadyZones`, `getPressureContestedZones`, `getPressureSummary`, `getCaptureEligibleBases`, `getCaptureEligibleZones`, `getEligibilitySummary`, `getCaptureProgress`) erzeugen seit dem Fix vom 2026-09-12 keinen Persistence-Dirty-State mehr, während echte Capture-Mutationen weiterhin zuverlässig dirty markieren (live verifiziert, siehe Abschnitt 9, Priorität 3).
- Redundante Ownership-Set-Aufrufe (`setZoneOwner()`/`setBaseOwner()` mit `newOwner == currentOwner`) verändern seit dem Fix vom 2026-09-12 keinen persistierten State mehr (kein Registry-/Progress-/Timestamp-Schreiben, kein Dirty); echte Ownerwechsel funktionieren unverändert (live verifiziert, siehe Abschnitt 9, Priorität 3).
- LogisticsDelivery-Reads (`getStatistics()`, `getHubSummary()`, `summary()`) verändern seit dem Fix vom 2026-09-21 (`v0.2.1`) weder persistierten Logistics-State noch Dirty-Status; echte Mutationen (`createDelivery()`) markieren weiterhin zuverlässig dirty (`logistics_delivery_created`). Live verifiziert per isolierter Runtime-Regression mit Rollback (siehe Abschnitt 9, Priorität 3).
- `tc_ai_cap_manager.lua` `reactToActiveMissions()` ist am 2026-09-12 READ-ONLY bewertet: aktuell ohne Call-Site, damit kein Runtime-Persistence-Bug (Klassifikation B, latent); Fix erst bei künftiger Verdrahtung (siehe Abschnitt 9, Priorität 3).
- Persistence kann DCS-Dateien schreiben und lesen.
- Persistence speichert Campaign-State als Lua-Return-Datei.
- Persistence validiert Save-Dateien.
- Persistence kann Save-Dateien kontrolliert importieren.
- Persistence läuft jetzt als Background-Autosave-Service.
- Spieler müssen Persistence nicht über F10 bedienen.

Aktuelle wichtigste offene Fähigkeit:

- Aktive Read-Neutrality-Fixes in `tc_fob_system.lua` und `tc_ai_cap_manager.lua` umsetzen (zwei aktive Fixes offen), ein System pro Schritt, beginnend mit `tc_fob_system.lua` (Priorität 3, Abschnitt 9). Der READ-ONLY Vier-Dateien-Audit ist am 2026-09-13 abgeschlossen; für `tc_mission_generator.lua` ist kein aktiver Code-Fix erforderlich. Der LogisticsDelivery-Fix (`v0.2.1`, 2026-09-21), der CaptureSystem-Getter-Hauptfund, der Ownership-No-Op-Fund und die Bewertung von `reactToActiveMissions()` sind bereits behoben bzw. abgeschlossen bewertet (siehe Abschnitt 9, Priorität 3) und sind nicht Teil dieses offenen Punkts.

---

## 12. Startpunkt für die nächste Session

Die nächste Session soll zuerst den aktuellen GitHub-Stand prüfen.

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

Danach nicht mit F10-Persistence weitermachen.

Nächster technischer Schritt:

- Priorität 3 (Abschnitt 9): Fix der Read-Neutrality ausschließlich in `src/logistics/tc_fob_system.lua` umsetzen. Immer nur **ein System pro Schritt**, keine parallelen Fixes. Der LogisticsDelivery-Fix (`v0.2.1`, 2026-09-21) sowie der CaptureSystem-Getter-Hauptfund und der Ownership-No-Op-Fund (2026-09-12) sind bereits behoben und live bestanden und dürfen nicht erneut getestet werden; `tc_ai_cap_manager.lua` `reactToActiveMissions()` ist bewertet (Klassifikation B) und geschlossen. Der READ-ONLY Vier-Dateien-Audit selbst ist am 2026-09-13 abgeschlossen (siehe unten).

Nächster erwarteter Test:

1. Fix der Read-Neutrality ausschließlich in `src/logistics/tc_fob_system.lua` umsetzen: Read-/Summary-Pfade (`getStatistics()`, `summary()`) persistence-neutral machen, kein `fobStatistics`-/`lastFobUpdateTime`-Rewrite nur aufgrund eines Reads.
2. Danach separate Regression: echte fachliche Mutationen markieren weiterhin zuverlässig dirty, reine Reads erzeugen keinen Dirty mehr.
3. Dirty Reasons eindeutig und stabil halten.
4. Ergebnis in Abschnitt 9 (Priorität 3) mit Datum dokumentieren.
5. Danach denselben Fix für `tc_ai_cap_manager.lua` einzeln umsetzen und regressionstesten. Für `tc_mission_generator.lua` ist kein aktiver Code-Fix erforderlich.
6. Frische `dcs.log` auf Theater-Command- und Lua-Fehler prüfen.

Bestanden bzw. abgeschlossen bewertet am 2026-09-12 (nicht erneut zu wiederholen):

- Mission Completion Regression (siehe Abschnitt 7.1)
- Mission Failure Regression (siehe Abschnitt 7.3)
- Capture Ready Apply Regression (siehe Abschnitt 7.2)
- CaptureSystem-Dirty-Tracking-Hauptfund: reine Capture-Status-Reads erzeugen kein Dirty mehr, echte Mutationen weiterhin zuverlässig (siehe Abschnitt 9, Priorität 3)
- Ownership-No-Op-Fund (`setZoneOwner()`/`setBaseOwner()`): redundante Ownership-Set-Aufrufe verändern keinen persistierten State mehr, echte Ownerwechsel unverändert funktionsfähig (siehe Abschnitt 9, Priorität 3)
- `tc_ai_cap_manager.lua` `reactToActiveMissions()`: READ-ONLY bewertet, keine Call-Site, Klassifikation B (latent, kein aktueller Bug) — Fix erst bei künftiger Verdrahtung (siehe Abschnitt 9, Priorität 3)

Zusätzlich abgeschlossen am 2026-09-13 (nicht erneut zu wiederholen):

- READ-ONLY Dirty-Coverage-Audit von `tc_logistics_delivery.lua`, `tc_fob_system.lua`, `tc_mission_generator.lua` und `tc_ai_cap_manager.lua`: am 2026-09-13 abgeschlossen; Befunde (drei aktive Read-Neutrality-Bugs, kein aktiver Bug in MissionGenerator) siehe Abschnitt 9, Priorität 3 — nicht erneut zu auditieren; vom Fix-Ergebnis stehen nur noch `tc_fob_system.lua` und `tc_ai_cap_manager.lua` aus (LogisticsDelivery am 2026-09-21 erledigt)

Zusätzlich abgeschlossen am 2026-09-21 (nicht erneut zu wiederholen):

- LogisticsDelivery Read-Neutrality-Fix (`tc_logistics_delivery.lua` `v0.2.1`, Commit `d4c439dfeb243621e7bc0ca8906f6cb2cf82491d`): Embedded Resource Audit (`ResKey_Action_60`, byte-identisch) und Runtime-Regression (Negativtest, isolierter Positivtest, Rollback; 70/70 Prüfungen) bestanden — siehe Abschnitt 0 und Abschnitt 9, Priorität 3

---

## Footer

Diese Datei ist der operative Übergabepunkt.

Bei Unsicherheit gilt:

1. Erst GitHub lesen.
2. Dann den letzten bestätigten DCS-Logstand beachten.
3. Dann nur eine Datei oder eine konkrete Aufgabe bearbeiten.
4. Keine Framework-Dateien verändern.
5. Keine All-in-one-Lua-Dateien erstellen.
