# Persistence

## Verbindlicher Stand — 2026-09-29

Diese Datei beschreibt Architektur, aktuellen Teststand und Sicherheitsregeln des Persistenzsystems von **Theater Command DCS**.

Projekt:

- Theater Command DCS

Erste Kampagne:

- Operation Levant Reclamation

Map:

- Syria

Grundprinzip:

- Mission Editor = Bühne
- Lua = Kampagnensystem
- GitHub = Projektgedächtnis / Source of Truth
- Persistence = internes Hintergrundsystem

Aktive Datei:

    src/campaign/tc_persistence_system.lua

Aktuelle Version:

    v0.2.6

Verbindlich:

    productiveRestore=false

---

## 1. Zweck der Persistenz

Persistence soll ermöglichen, dass der Kampagnenzustand über einzelne DCS-Missionsläufe hinweg erhalten bleibt.

Theater Command DCS soll langfristig nicht bei jedem Missionsstart vollständig neu beginnen.

Persistiert werden sollen perspektivisch insbesondere:

- Airbase Ownership
- Zone Ownership
- Capture Pressure
- Capture Progress
- Capture Events
- Logistics State
- Logistics Deliveries
- FOB State
- Mission State
- AI State
- IADS State
- Ressourcen
- Kampagnenphase
- wichtige Kampagnenereignisse

Persistence ist kein Spielerfeature.

Spieler sollen nicht:

- manuell speichern
- manuell laden
- Save-Dateien validieren
- den Persistence-Lifecycle verwalten

Persistence läuft im Hintergrund.

---

## 2. Aktueller Gesamtstatus

Stand:

    2026-09-29

Technische Dateipersistenz:

    BESTANDEN

Dirty-aware Background Autosave:

    BESTANDEN

Kontrollierter Import:

    BESTANDEN

Produktiver Startup-Restore:

    NICHT FREIGEGEBEN

Bestätigt:

- DCS-Dateisystemzugriff
- Save-Datei schreiben
- Save-Datei lesen
- Lua-Inhalt kompilieren
- Lua-Inhalt evaluieren
- Snapshot validieren
- Snapshot kontrolliert importieren
- Background Autosave
- Dirty-State
- `SAVED`
- `SKIPPED`
- kontrollierter `FAILED`
- Retry
- Dirty-Erhalt bei Save-Fehler
- Dirty-Clear erst nach erfolgreicher Verifikation
- Schutz vor dem Löschen eines neueren Dirty-State
- Mission Completion Persistence Regression
- Mission Failure Persistence Regression
- Capture Ready Apply Persistence Regression
- Capture Getter Read-Neutrality
- Capture Ownership No-Op
- LogisticsDelivery Read-Neutrality
- FobSystem Read-Neutrality
- MissionGenerator Dirty-Coverage-Audit
- AICapManager Read-Neutrality
- Priority 3 im dokumentierten Umfang abgeschlossen

---

## 3. Priority 3 ist abgeschlossen

Priority 3 – Dirty-Coverage – wurde am:

    2026-09-21

im dokumentierten Umfang abgeschlossen.

Geprüft wurden:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua
    src/missions/tc_mission_generator.lua
    src/ai/tc_ai_cap_manager.lua

Ergebnis:

### LogisticsDelivery

Version:

    v0.2.1

Read-Neutrality:

    BESTANDEN

Reine Getter verändern keinen persistierten Logistics-State.

Positive Mutation:

    createDelivery()

markiert weiterhin:

    dirtyReason=logistics_delivery_created

### FobSystem

Version:

    v0.2.1

Read-Neutrality:

    BESTANDEN

Reine Getter verändern keinen persistierten FOB-State.

Positive Mutation:

    FobSystem.create()

markiert weiterhin:

    dirtyReason=fob_created

### MissionGenerator

Version:

    v0.2.3

READ-ONLY Dirty-Coverage-Audit:

    BESTANDEN

Kein aktuell aktiver Missing-Dirty-Bug gefunden.

Kein vorsorglicher Code-Fix erforderlich.

### AICapManager

Version:

    v0.2.1

Read-Neutrality:

    BESTANDEN

Reine Getter verändern keinen persistierten AI-State.

Positive Mutation:

    setCapStatus()

markiert weiterhin:

    dirtyReason=ai_cap_record_changed

Priority 3 ist deshalb kein aktueller Restore-Blocker mehr.

---

## 4. Was trotz abgeschlossenem Priority 3 offen bleibt

Priority 3 abgeschlossen bedeutet nicht, dass jeder zukünftige Lifecycle automatisch abgedeckt ist.

Separat relevant bleiben:

- später neu verdrahtete Mutationspfade
- Restore-Lifecycle
- Start-/Initialisierungsreihenfolge
- Framework-Rekonstruktion
- CTLD-Integration
- MOOSE-Integration
- Skynet-Integration
- neue State-Felder
- zukünftige No-Op-Pfade

Beispiel:

    AICapManager.reactToActiveMissions()

besitzt aktuell keine produktive Call-Site.

Ein dort dokumentierter latenter Dirty-Randfall wird erst bei tatsächlicher Verdrahtung erneut geprüft.

Das rechtfertigt keinen erneuten vollständigen Priority-3-Audit.

---

## 5. Aktuelle technische Version

Aktive Datei:

    src/campaign/tc_persistence_system.lua

Version:

    v0.2.6

Architekturrolle:

- internes Hintergrundsystem
- Dirty-aware Autosave
- kein Spieler-F10-Menü
- Save-Funktionen intern
- Load-/Validation-Funktionen intern
- technische Importfähigkeit vorhanden
- produktiver Restore deaktiviert

Autosave:

    initialDelay=20s
    interval=120s

---

## 6. Lokale DCS-Voraussetzung

Damit DCS-Missionsskripte Dateien lesen und schreiben können, muss die lokale DCS-Sandbox entsprechend vorbereitet sein.

Lokale DCS-Datei:

    ...\DCS World\Scripts\MissionScripting.lua

PersistenceSystem benötigt direkt insbesondere:

    io
    lfs

Aktuell dokumentierte Entwicklungsumgebung:

    os=true
    io=true
    lfs=true
    require=false

PersistenceSystem selbst benötigt:

- `io`
- `lfs`

nicht direkt erforderlich:

- `os`
- `require`

Die aktuell verwendete DCS-SMS-Entwicklungsbridge benötigt zusätzlich eine entsprechend unsanitized Umgebung für ihre Runtime-Funktionen.

DCS-SMS-Installationspfad:

    C:\Tools\dcs-sms

DCS-Updates können `MissionScripting.lua` überschreiben.

Wenn Persistence oder DCS-SMS nach einem DCS-Update nicht mehr funktionieren:

1. `MissionScripting.lua` prüfen.
2. `io` prüfen.
3. `lfs` prüfen.
4. für DCS-SMS zusätzlich `os` prüfen.
5. erst danach Theater-Command-Code verdächtigen.

Typische Persistence-Problemmarker:

    io=false
    lfs=false
    Persistence sandbox blocked
    file_system_unavailable

---

## 7. Speicherort

Bestätigter Ordner:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS

Sandbox-Testdatei:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\tc_persistence_sandbox_test.lua

Produktive Campaign-Save-Datei:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Der Speicherort liegt bewusst unter:

    Saved Games

und nicht im DCS-Installationsverzeichnis.

---

## 8. Aktuell bestätigter produktiver Save

Letzter bestätigter Stand nach dem CTLD-Test vom 2026-09-29:

Datei:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Größe:

    3094967 Bytes

Änderungszeit:

    2026-09-21 15:00:00.5926451

SHA-256:

    C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596

Dieser Hash wurde während des isolierten CTLD-Tests als Referenz verwendet.

---

## 9. Save-Dateiformat

Aktuelles Format:

- Lua-Return-Datei
- lesbar
- debugbar
- durch Lua kompilierbar
- strukturell validierbar

Formatmarker:

    TC_LUA_TABLE_V1

Save-Marker:

    TC_CAMPAIGN_STATE_SAVE

Konzeptuell:

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

Die Save-Datei enthält State.

Sie enthält keine eigenständige Kampagnenlogik.

---

## 10. PersistenceSystem v0.2.0

Historisches Ziel:

- Sandbox prüfen
- `os`, `io`, `lfs`, `require` prüfen
- Dateisystemverfügbarkeit feststellen

Erster Zustand:

    os=false
    io=false
    lfs=false
    require=false

Ergebnis:

- Modul startete.
- Dateisystem war zunächst blockiert.
- lokale Sandbox-Anpassung war notwendig.

---

## 11. PersistenceSystem v0.2.1

Ziel:

- Sandbox-Schreibtest korrigieren
- Write-/Read-Pfad verlässlich prüfen

Bestätigt:

    io=true
    lfs=true
    fileSystemAvailable=true

Sandbox-Testdatei konnte:

- geschrieben
- gelesen
- validiert

werden.

---

## 12. PersistenceSystem v0.2.2

Ziel:

- echten Campaign Snapshot schreiben

Bestätigt:

- Snapshot wurde erzeugt.
- Campaign Save-Datei wurde geschrieben.
- Produktiver Restore blieb deaktiviert.

Historische Marker:

    Persistence file save test scheduled: delay=8s
    Campaign state file saved

---

## 13. PersistenceSystem v0.2.3

Ziel:

- Save-Datei lesen
- kompilieren
- evaluieren
- validieren

Bestätigt:

    load=true
    loadstring=true
    loadfile=true

Snapshot:

    sections=10
    imported=false

Ergebnis:

    Read
    -> Compile
    -> Evaluate
    -> Validate

bestanden.

---

## 14. PersistenceSystem v0.2.4

Ziel:

- Snapshot kontrolliert in `TC.State` importieren

Bestätigt:

    sections=10
    imported=true
    productiveRestore=false

Technische Kette:

    State
    -> Snapshot
    -> Datei
    -> Read
    -> Validation
    -> Evaluate
    -> Import

bestanden.

Dieser Import war ein kontrollierter technischer Test.

Er war kein produktiver Missionsstart-Restore.

---

## 15. PersistenceSystem v0.2.5

Ziel:

- Test-Timer-Kaskade entfernen
- Persistence als Hintergrunddienst betreiben

Umgestellt auf:

    erster Autosave nach 20 Sekunden
    danach alle 120 Sekunden

Entfernt wurden die früheren separaten:

- Save-Testtimer
- Validate-Testtimer
- Load-Testtimer

Persistence wurde damit zu einem Hintergrundsystem.

Kein Spieler-F10-Workflow.

---

## 16. PersistenceSystem v0.2.6

Ziel:

- Background Autosave dirty-aware machen
- unveränderte Ticks ohne Schreibzugriff überspringen
- Save vollständig verifizieren
- Dirty nur bei verifiziertem Erfolg löschen
- Fehler und Retry sauber behandeln

Aktueller Ablauf:

    TC.State.markDirty(reason)
    -> Persistence sieht dirty=true
    -> Snapshot erzeugen
    -> Datei schreiben
    -> Datei zurücklesen
    -> Compile
    -> Evaluate
    -> Validation
    -> Dirty-State prüfen
    -> bei unverändertem ursprünglichem Dirty erfolgreich löschen

Bei:

    dirty=false

wird kein Save geschrieben.

Ergebnis:

    SKIPPED

---

## 17. Zentraler Dirty-State

Dirty-State liegt zentral unter:

    TC.State.Persistence

Relevante Felder:

    dirty
    dirtyReason
    dirtyAt

Mutation:

    TC.State.markDirty(reason)

Löschen:

    TC.State.clearDirty()

Es existiert kein paralleler zweiter Dirty-Mechanismus nur im PersistenceSystem.

---

## 18. `SAVED`

Status:

    BESTANDEN

Ein Dirty-State wird gespeichert.

Vor dem Löschen des Dirty-State müssen erfolgreich sein:

    Write
    -> Read-back
    -> Compile
    -> Evaluate
    -> Validation

Erst danach darf der ursprüngliche Dirty-State gelöscht werden.

Bestätigte Entscheidung:

    Periodic autosave decision: SAVED dirtyReason=...

---

## 19. `SKIPPED`

Status:

    BESTANDEN

Wenn:

    dirty=false

wird kein unnötiger Schreibzugriff durchgeführt.

Bestätigte Entscheidung:

    Periodic autosave decision: SKIPPED detail=state_unchanged productiveRestore=false

Bestätigt:

- Save-Datei unverändert
- Größe unverändert
- Änderungszeit unverändert
- SHA-256 unverändert
- Autosave Count steigt nicht durch Skip

---

## 20. `FAILED`

Status:

    BESTANDEN

Ein kontrollierter Schreibfehler wurde getestet.

Bestätigt:

- Entscheidung `FAILED`
- Dirty bleibt erhalten
- Dirty Reason bleibt erhalten
- bestehende Save-Datei bleibt unverändert
- kein falscher Erfolg
- kein Dirty-Clear

Marker:

    Periodic autosave decision: FAILED dirtyReason=...

---

## 21. Retry

Status:

    BESTANDEN

Nach Wiederherstellung des Schreibpfads:

- derselbe Dirty-State konnte erneut gespeichert werden
- Save wurde vollständig verifiziert
- Dirty wurde erst danach gelöscht
- Autosave Count erhöhte sich nur durch den erfolgreichen Save

---

## 22. Schutz vor Race beim Dirty-Clear

Ein wichtiger v0.2.6-Schutz:

Wenn während eines Save-Vorgangs ein neuerer Dirty-State entsteht, darf der Abschluss des älteren Saves diesen neuen Dirty-State nicht löschen.

Dafür werden vor dem Save erfasst:

    dirtyReason
    dirtyAt

Nach erfolgreicher Verifikation wird geprüft, ob derselbe Dirty-State noch aktuell ist.

Nur dann erfolgt:

    clearDirty()

Damit kann ein älterer Save keinen späteren State-Wechsel fälschlich als gespeichert markieren.

---

## 23. Embedded Runtime

Aktiver Mission-Editor-Trigger:

    TC_LOAD_TC_PERSISTENCE_SYSTEM

Typ:

    ONCE

Bedingung:

    TIME MORE 15

Aktive Version:

    v0.2.6

Bestätigte Embedded-Ressource:

    tc_persistence_system_v0_2_6.lua

Historische verwaiste Ressource:

    ResKey_Action_55
    tc_persistence_system.lua

Letzter bestätigter Stand:

- alter Trigger-Verweis entfernt
- Altressource nicht referenziert
- Altressource wird nicht geladen
- kein aktueller Blocker
- späterer Cleanup möglich

---

## 24. Embedded Resource Audit

Auditdatum:

    2026-09-12

Ergebnis:

    13/13 relevante aktive Theater-Command-Ressourcen EXACT_MATCH

Die aktive Persistence-Ressource war byte-identisch zu:

    src/campaign/tc_persistence_system.lua

Keine aktive Embedded-Runtime-Drift.

Damit wurde ein veralteter Embedded-Persistence-Code als Ursache damaliger Probleme ausgeschlossen.

---

## 25. Mission Completion Persistence

Status:

    BESTANDEN
    2026-09-12 erneut live bestätigt

Bestätigt:

    Mission Completion
    -> State-Mutation
    -> Dirty
    -> Autosave
    -> SAVED

Dirty Reason:

    f10_active_mission_1_completed

Ergebnis:

    dirtyCleared=true
    productiveRestore=false

---

## 26. Mission Failure Persistence

Status:

    BESTANDEN
    2026-09-12 erneut live bestätigt

Bestätigt:

    Mission Failure
    -> Failure State
    -> Dirty
    -> Autosave
    -> SAVED

Dirty Reason:

    f10_active_mission_1_failed

Ergebnis:

    dirtyCleared=true
    productiveRestore=false

Mission Failure erzeugt aktuell bewusst keinen Capture Pressure.

---

## 27. Capture Ready Apply Persistence

Status:

    BESTANDEN
    2026-09-12 erneut live bestätigt

Bestätigter Fall:

    Zone: ZONE_AIRBASE_ABU_AL_DUHUR
    previousOwner: RED
    newOwner: BLUE
    linked Airbase: Abu al-Duhur
    baseOwner: BLUE
    progress: 0
    status: STABLE
    captureReady: false

Dirty Reason:

    f10_capture_ready_zone_1_applied

Persistence:

    SAVED
    dirtyCleared=true
    productiveRestore=false

---

## 28. Capture Getter Read-Neutrality

Status:

    BESTANDEN

Vor dem Fix konnte ein reiner Getter Dirty-State erzeugen.

Nach dem Fix getestet:

    getCaptureReadyZones()
    getPressureContestedZones()
    getPressureSummary()
    getCaptureEligibleBases()
    getCaptureEligibleZones()
    getEligibilitySummary()
    getCaptureProgress()

Ergebnis:

    dirty=false
    reason=nil

für alle getesteten Getter.

Positive Gegenprobe:

    echte Capture-Pressure-Mutation
    -> dirty=true
    -> reason=capture_pressure_set

Architekturregel:

    Reads dürfen keinen Save erzwingen,
    wenn kein persistierter fachlicher State geändert wurde.

---

## 29. Capture Ownership No-Op

Status:

    BESTANDEN

Redundante Aufrufe mit identischem Owner verändern inzwischen keinen persistierten State.

Bestätigt:

- kein Timestamp-Update
- kein Progress-Update
- kein Capture-Last-Update
- kein Event
- kein Dirty

Ergebnis:

    dirty=false
    reason=nil

Architekturregel:

    No-Op-Mutationen dürfen keinen Persistence-Write auslösen.

---

## 30. Logistics Persistence

Aktuelle Datei:

    src/logistics/tc_logistics_delivery.lua

Version:

    v0.2.1

Aktuelle State-Basis:

    Hubs: 46
    Blue: 7
    Red: 24
    Neutral: 15
    Active: 31
    Limited: 15
    Locked: 0

Read-Neutrality:

    BESTANDEN

Bestätigte reine Reads:

    getStatistics()
    getHubSummary()
    summary()

Positive Mutation:

    createDelivery()

Dirty Reason:

    logistics_delivery_created

Noch nicht produktiv:

- reale CTLD-Cargo-Delivery
- Supply-Verbrauch
- Cargo-Effekte
- CTLD-Ergebnis-Rückkopplung

---

## 31. FOB Persistence

Aktuelle Datei:

    src/logistics/tc_fob_system.lua

Version:

    v0.2.1

Aktueller State:

    FOB Candidates: 6
    Blue FOBs: 2

FOBs:

    FOB Ercan
    FOB Gecitkale

Status:

    UNDER_CONSTRUCTION

Read-Neutrality:

    BESTANDEN

Positive Mutation:

    FobSystem.create()

Dirty Reason:

    fob_created

Noch nicht produktiv:

- echter CTLD-FOB-Bau
- Cargo -> Build Progress
- reale FOB-Infrastruktur
- CTLD-Ergebnis-Rückkopplung

---

## 32. Mission Persistence

Aktuelle Datei:

    src/missions/tc_mission_generator.lua

Version:

    v0.2.3

Bestätigt:

    Mission Candidates: 78
    Mission Records: 10
    FOB Support Candidates: 2

Funktional bestätigt:

- Activation
- Completion
- Failure
- Effects

Mission Collections sind String-keyed Dictionaries.

Deshalb gilt:

    #table

nicht als autoritativer Count.

Korrekte Zählung:

    pairs()

Der frühere Mission-Record-Loss-Verdacht wurde am 2026-09-12 widerlegt.

Priority-3-Audit:

    abgeschlossen

Kein aktuell aktiver Missing-Dirty-Bug gefunden.

Noch offen:

- produktiver Restore von Mission State
- Cancel-/Expire-Regressionen
- automatische DCS-Outcome-Auswertung

---

## 33. AI Persistence

Aktuelle Datei:

    src/ai/tc_ai_cap_manager.lua

Version:

    v0.2.1

Aktueller State:

    CAP Candidates: 31
    CAP Zones: 12
    CAP Requests: 12

Read-Neutrality:

    BESTANDEN

Positive Mutation:

    setCapStatus()

Dirty Reason:

    ai_cap_record_changed

Noch keine realen MOOSE-CAP-Spawns.

Latenter Sonderfall:

    reactToActiveMissions()

besitzt aktuell keine produktive Call-Site.

Bei späterer Verdrahtung muss dieser Lifecycle separat erneut geprüft werden.

---

## 34. IADS Persistence

Aktuell:

- Skynet IADS als Vendor vorhanden
- noch keine produktive Theater-Command-IADS-Integration

Später persistierbar:

- IADS-Netzwerke
- SAM-Knoten
- EWR-Knoten
- Radarstatus
- Launcherstatus
- Munition
- Beschädigung
- Reparatur
- Unterdrückung
- zerstörte Systeme

Aktuell keine produktiven IADS-Dirty-Hooks.

---

## 35. CTLD und Persistence

CTLD wurde am 2026-09-29 erstmals in einem vollständigen KI-Truppentransport praktisch getestet.

Bestätigt:

    Pickup
    -> Flug
    -> Off-Airfield-Landung
    -> automatischer Dropoff
    -> reale Bodengruppe

Dieser Test war ein Framework-Proof-of-Concept.

Er war noch keine produktive Theater-Command-CTLD-Integration.

Wichtig für Persistence:

Aktuell werden CTLD-interne Runtime-Tabellen nicht als autoritativer langfristiger Kampagnenstate behandelt.

Langfristiges Ziel:

    CTLD Runtime Result
    -> Ergebnis validieren
    -> Theater-Command-State aktualisieren
    -> Dirty markieren
    -> Persistence speichern

Nicht:

    beliebigen vollständigen Vendor-Runtime-State blind serialisieren

Theater Command bleibt Eigentümer des persistierbaren Kampagnenzustands.

CTLD bleibt Execution Layer.

---

## 36. CTLD-Test und produktive Save-Datei

Beim isolierten CTLD-Test vom 2026-09-29 wurde der produktive Save ausdrücklich geschützt.

Produktive Datei:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Backup vor Test:

    C:\Users\Paul\Documents\TC_miz_backups\operation_levant_reclamation_save__pre_landtask_test_2026-09-29_100813.lua

Referenz-SHA-256:

    C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596

Vor Test:

- Backup erstellt
- Hash verglichen
- produktiver Save ReadOnly gesetzt

Nach Test:

- DCS beendet
- Save erneut geprüft
- Größe unverändert
- Änderungszeit unverändert
- SHA-256 unverändert

Danach:

    ReadOnly=False

Finaler Hash weiterhin identisch.

Ergebnis:

    produktiver Campaign-State unverändert

---

## 37. Verbindlicher Schutz bei isolierten Framework-Tests

Wenn ein isolierter Test möglicherweise Persistence beeinflussen kann:

    aktuellen Hash prüfen
    -> Backup erzeugen
    -> Backup-Hash prüfen
    -> produktiven Save ReadOnly setzen
    -> ReadOnly bestätigen
    -> Test durchführen
    -> DCS vollständig beenden
    -> Save erneut hashen
    -> Referenz vergleichen
    -> nur bei Match ReadOnly entfernen
    -> final nochmals Hash prüfen

Wichtig:

Der ReadOnly-Schutz wird nicht entfernt, solange DCS beziehungsweise die Testmission noch läuft.

---

## 38. Warum CTLD-Runtime-State nicht einfach gespeichert wird

Framework-Runtime enthält häufig Daten, die:

- nur für die laufende Mission gültig sind
- DCS-Objektreferenzen enthalten
- Scheduler-Zustände enthalten
- Menüpfade enthalten
- temporäre Unit-Referenzen enthalten
- nach einem Missionsneustart nicht direkt wiederverwendbar sind

Deshalb muss zwischen:

    Kampagnenstate

und:

    Framework-Runtime-State

klar getrennt werden.

Beispiel:

Eine erfolgreiche CTLD-Lieferung soll später möglicherweise speichern:

    Lieferung erfolgreich
    Empfänger
    Cargo-Typ
    Menge
    Zeitpunkt
    FOB-/Hub-Effekt

Nicht zwangsläufig:

    vollständige interne ctld-Tabelle

---

## 39. Produktiver Restore

Produktiver Restore bedeutet langfristig:

1. Mission startet.
2. Persistence prüft Save-Datei.
3. Marker wird geprüft.
4. Format wird geprüft.
5. Save-Version wird geprüft.
6. Snapshot wird validiert.
7. Campaign State wird importiert.
8. Fachsysteme verwenden restored State.
9. Runtime-Frameworks werden kontrolliert aus diesem State rekonstruiert.
10. normale Scheduler werden gestartet.
11. Kampagne läuft weiter.

Aktueller Status:

    technische Importfähigkeit vorhanden
    produktiver Restore deaktiviert

Verbindlich:

    productiveRestore=false

---

## 40. Warum produktiver Restore weiterhin deaktiviert ist

Priority 3 ist inzwischen abgeschlossen.

Das ist kein aktueller Blocker mehr.

Offen bleiben jedoch:

### Restore-Reihenfolge

Es muss eindeutig definiert werden:

    wann State initialisiert wird
    wann Save importiert wird
    wann Module ihren Derived State berechnen
    wann Frameworks gestartet werden
    wann Scheduler beginnen

### Save-Versionierung

Aktuell muss noch eine belastbare Strategie entstehen für:

- Save-Version
- Schema-Version
- Code-Kompatibilität
- alte Saves
- Migration
- Inkompatibilitätsabbruch

### Framework-Rekonstruktion

Später müssen CTLD, MOOSE und Skynet aus restored Theater-Command-State kontrolliert rekonstruiert werden.

Framework-Runtime darf nicht doppelt erzeugt werden.

### Separater Restore-Test

Produktiver Restore wird nicht allein aufgrund der technischen `importSnapshot()`-Fähigkeit freigeschaltet.

Es braucht einen eigenen kontrollierten End-to-End-Restore-Test.

---

## 41. Voraussetzungen vor `productiveRestore=true`

Bereits erfüllt:

- File-System-Zugriff
- Save
- Read-back
- Compile
- Evaluate
- Validation
- kontrollierter Import
- Background Autosave
- `SAVED`
- `SKIPPED`
- `FAILED`
- Retry
- Mission Completion Regression
- Mission Failure Regression
- Capture Ready Apply Regression
- Capture Getter Read-Neutrality
- Capture Ownership No-Op
- Priority 3 Dirty-Coverage

Noch offen:

- Restore-/Initialisierungsreihenfolge definieren
- Save-Versionierung definieren
- Save-Kompatibilitätsstrategie definieren
- Framework-Rekonstruktionsgrenzen definieren
- separaten Restore-Test durchführen
- Ergebnis dokumentieren

Erst danach darf über:

    productiveRestore=true

entschieden werden.

---

## 42. Save/Load-Sicherheitsregeln

Persistence bleibt defensiv.

Regeln:

- Save nur unter kontrolliertem Pfad schreiben.
- Save nur lesen, wenn Datei existiert.
- Marker prüfen.
- Format prüfen.
- Struktur prüfen.
- später Save-Version prüfen.
- Snapshot vor Import validieren.
- beschädigte Saves nicht blind importieren.
- Fehler dürfen die Mission nicht unkontrolliert abbrechen.
- Dirty bei fehlgeschlagenem Save erhalten.
- keinen neueren Dirty-State mit älterem Save-Abschluss löschen.
- produktiven Restore nicht automatisch aktivieren.
- Framework-Runtime nicht blind aus Save serialisieren.

---

## 43. Spätere Save-Versionierung

Noch zu entwickeln:

- Save-Version
- Schema-Version
- Versionskompatibilität
- Migration
- Backup
- Rotation
- Recovery
- Fallback auf neuen Kampagnenstart

Mögliche spätere Metadaten:

    saveVersion
    schemaVersion
    theaterCommandVersion
    campaignVersion
    createdAt
    savedAt

Diese Felder sind Zukunftsarchitektur und nicht als bereits implementiert zu verstehen.

---

## 44. Backup und Rotation

Aktuell existiert kein vollständig produktiver automatischer Save-Rotationsmechanismus.

Später sinnvoll:

    current
    previous
    backup

oder zeitgestempelte Sicherungen.

Ziel:

- defekten neuesten Save erkennen
- letzten gültigen Save behalten
- Kampagnenverlust vermeiden

Der manuelle Hash-/Backup-Schutz aus dem CTLD-Test ist eine Entwicklungs- und Testsicherheitsmaßnahme.

Er ersetzt noch keine spätere automatische Save-Rotation.

---

## 45. Persistence und F10

Aktuelle Entscheidung:

    kein Spieler-Persistence-Menü

Nicht umsetzen:

- `Save Campaign State`
- `Load Campaign State`
- `Validate Save`
- `Restore Campaign`

als normale Spieler-F10-Funktionen.

Begründung:

Persistence ist Systemverhalten.

Spieler sollen:

- fliegen
- kämpfen
- Missionen übernehmen
- Gebiete beeinflussen
- Logistik durchführen

nicht Savegames verwalten.

Ein späteres separates Admin-/Debug-Menü wäre nur als neue, bewusst freigegebene Funktion denkbar.

---

## 46. Integration mit CaptureSystem

Status:

    BESTANDEN für die getesteten Persistence-Pfade

Bestätigt:

- Completion
- Failure
- Capture Ready Apply
- Getter Read-Neutrality
- Ownership No-Op
- echte Capture-Pressure-Mutation

Noch offen:

- produktiver Restore der Capture-Strukturen
- automatische reale Zone-Auswertung
- zukünftige neue Capture-Lifecycle-Pfade

---

## 47. Integration mit LogisticsDelivery

Status:

    Dirty-Coverage BESTANDEN

Version:

    v0.2.1

Bestätigt:

- Getter read-neutral
- echte Delivery-Mutation setzt Dirty

Noch offen:

- reale CTLD-Lieferungen
- Supply-Verbrauch
- produktive Logistikfolgen
- Restore realer Logistics-Lifecycle-Effekte

---

## 48. Integration mit FobSystem

Status:

    Dirty-Coverage BESTANDEN

Version:

    v0.2.1

Bestätigt:

- Getter read-neutral
- echte FOB-Mutation setzt Dirty

Noch offen:

- realer FOB-Bau
- CTLD-Cargo-Rückkopplung
- FOB-Infrastruktur
- produktiver Restore

---

## 49. Integration mit MissionGenerator

Status:

    Priority-3-Audit abgeschlossen

Version:

    v0.2.3

Bestätigt:

- Mission Records vorhanden
- Completion Persistence
- Failure Persistence
- kein aktiver Missing-Dirty-Bug im Audit

Noch offen:

- Cancel
- Expire
- automatische DCS-Outcome-Erkennung
- produktiver Restore

---

## 50. Integration mit AICapManager

Status:

    Dirty-Coverage BESTANDEN

Version:

    v0.2.1

Bestätigt:

- Getter read-neutral
- echte Statusmutation setzt Dirty

Noch offen:

- reale MOOSE-CAP-Spawns
- Lifecycle nach echter Spawn-Integration
- `reactToActiveMissions()` bei späterer Verdrahtung
- produktiver Restore

---

## 51. Integration mit CTLD

Status:

    Framework-PoC bestanden
    produktive Persistence-Integration offen

Bestätigt:

- Runtime-Zonenregistrierung
- Transporterregistrierung
- Pickup
- Flug
- Landung
- Dropoff
- Bodengruppe

Noch nicht definiert:

- welche CTLD-Ergebnisse in TC.State geschrieben werden
- welche Dirty Reasons verwendet werden
- wann ein Transportauftrag als erfolgreich gilt
- wie Fehlschläge abgebildet werden
- wie laufende Aufträge beim Missionsende behandelt werden
- was nach Restore neu erzeugt werden muss

Diese Punkte gehören in die kommende produktive CTLD-Integrationsarchitektur.

---

## 52. Bekannter CTLD-Integrationspunkt

Beim CTLD-Test wurde beobachtet:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Dieser Fehler ist kein PersistenceSystem-Fehler.

Er ist aber für den späteren Runtime-Lifecycle relevant.

Warum:

Wenn ein Vendor-Scheduler oder Menüpfad durch einen Fehler endet, kann daraus später ein Unterschied zwischen:

    Theater-Command-State

und:

    tatsächlicher Framework-Runtime

entstehen.

Deshalb muss dieser Punkt vor produktiver Integration geklärt werden.

Vendor-Regel:

    vendor/ctld/CTLD.lua wird nicht gepatcht.

---

## 53. Entwicklungswerkzeuge

Persistence-Arbeit nutzt dieselbe Werkzeugtrennung wie das Gesamtprojekt.

### ChatGPT

- Architektur
- Testplanung
- Bewertung
- Dokumentation
- GitHub-Audit

### Claude + dcs-mcp

- `.miz`-Struktur
- Embedded-Ressourcen
- Trigger
- Missionsdatei
- gespeicherte Mission

### Claude Code + DCS-SMS

- lokale Runtime
- `TC.State`
- Persistence Runtime-State
- CTLD-Live-State
- Logs
- kontrollierte Regressionen

DCS selbst bleibt der Verhaltensbeweis.

---

## 54. Testregeln für Persistence

Bei Persistence-Tests immer prüfen:

1. Welche Mission läuft?
2. Welche Persistence-Version ist eingebettet?
3. Welcher Save-Pfad ist aktiv?
4. Wie lautet der aktuelle Save-Hash?
5. Ist `productiveRestore=false`?
6. Ist vor dem Test Dirty gesetzt?
7. Welcher Dirty Reason liegt vor?
8. Wird `SAVED`, `SKIPPED` oder `FAILED` erwartet?
9. Wird die Save-Datei tatsächlich verändert?
10. Wird Dirty nur bei Erfolg gelöscht?
11. Entsteht während des Saves ein neuer Dirty-State?
12. Bleibt dieser erhalten?
13. Gibt es Lua-Fehler?
14. Gibt es Framework-Nebenwirkungen?
15. Wurde der produktive Save nach Test korrekt geschützt beziehungsweise wieder freigegeben?

---

## 55. Kritische Fehlerindikatoren

Besonders relevant:

    [TC][ERROR]
    SCRIPTING ERROR
    Mission script error
    stack traceback
    attempt to index
    attempt to call
    nil value
    protected call failed

Persistence-spezifisch zusätzlich:

    Persistence sandbox blocked
    file_system_unavailable
    Periodic autosave decision: FAILED

Ein `FAILED` ist im kontrollierten Fehlerpfad nicht automatisch ein Softwarefehler.

Entscheidend ist, ob:

- Dirty erhalten bleibt
- Save-Datei unbeschädigt bleibt
- Retry funktioniert

---

## 56. Aktuell bestätigte Systemwerte

Persistence:

    version: v0.2.6
    fileSystemAvailable: true
    autosaveEnabled: true
    autosaveScheduled: true
    autosaveRunning: true
    autosaveInitialDelay: 20s
    autosaveInterval: 120s
    productiveRestore: false

Capture:

    pressureRecords: 32
    progressRecords: 32

Logistics:

    Hubs: 46

FOB:

    Candidates: 6
    Blue FOBs: 2

MissionGenerator:

    Mission Records: 10

AI:

    CAP Zones: 12
    CAP Requests: 12

---

## 57. Aktuelle Persistence-Grenzen

Noch nicht produktiv:

- Startup Restore
- Save-Versionierung
- Schema-Migration
- automatische Save-Rotation
- Recovery-System
- Restore von realen CTLD-Operationen
- Restore realer MOOSE-Gruppen
- Restore realer Skynet-Zustände
- Restore laufender Ground Operations
- Multiplayer-Persistence

Diese Punkte dürfen nicht als bereits implementiert dokumentiert werden.

---

## 58. Nächster Persistence-Schritt

PersistenceSystem selbst benötigt aktuell keinen neuen allgemeinen Dirty-Coverage-Audit.

Priority 3 ist abgeschlossen.

Der nächste Projektbereich ist:

    Priority 4 – produktive CTLD-Integration

Für Persistence bedeutet das zunächst:

- definieren, welche CTLD-Ergebnisse Theater-Command-State werden
- definieren, wann diese Ergebnisse Dirty setzen
- definieren, welche CTLD-Runtime-Daten nicht persistiert werden
- laufende Transportaufträge von abgeschlossenen Ergebnissen trennen
- Restore-Grenze für spätere CTLD-Integration vorbereiten

Produktiver Restore wird dadurch noch nicht aktiviert.

---

## 59. Startpunkt für die nächste Session

Vor neuer Persistence-Arbeit zuerst aktuellen GitHub-Stand prüfen.

Mindestens:

    README.md
    ROADMAP.md
    TASKS.md
    CHANGELOG.md
    ARCHITECTURE.md
    docs/09_persistence.md
    docs/10_testing.md

Für CTLD-/Persistence-Grenzen zusätzlich:

    docs/05_logistics_system.md
    mission_editor/ctld_start_zones.md
    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua
    src/missions/tc_mission_generator.lua
    src/campaign/tc_persistence_system.lua

Vendor CTLD nur read-only analysieren.

---

## 60. Abschluss

Stand:

    2026-09-29

PersistenceSystem:

    v0.2.6

Bestanden:

    Save
    Read-back
    Compile
    Evaluate
    Validation
    kontrollierter Import
    Background Autosave
    SAVED
    SKIPPED
    FAILED
    Retry
    Mission Completion Persistence
    Mission Failure Persistence
    Capture Ready Apply Persistence
    Capture Getter Read-Neutrality
    Capture Ownership No-Op
    LogisticsDelivery Read-Neutrality
    FobSystem Read-Neutrality
    MissionGenerator Dirty-Coverage-Audit
    AICapManager Read-Neutrality

Priority 3:

    abgeschlossen im dokumentierten Umfang

Produktiver Restore:

    deaktiviert

Verbindlich:

    productiveRestore=false

Produktive Save-Datei nach dem CTLD-Test vom 2026-09-29:

    unverändert
    SHA-256 C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596

Aktueller Übergang:

    stabile dirty-aware Persistence
    +
    abgeschlossene Dirty-Coverage
    +
    bestandener CTLD-Framework-PoC
    ->
    klare Persistence-Grenze für die produktive CTLD-Integration
