# Testing

Diese Datei beschreibt die verbindliche Teststrategie und den aktuell bestätigten Teststand für **Theater Command DCS**.

Projekt:

- Theater Command DCS

Erste Kampagne:

- Operation Levant Reclamation

Map:

- Syria

Aktueller verbindlicher Stand:

- 2026-09-29

Grundprinzip:

- Mission Editor = Bühne
- Lua = Kampagnensystem
- GitHub = Projektgedächtnis / Source of Truth
- DCS Runtime = autoritativer Verhaltensbeweis

---

## 1. Zweck dieser Datei

Diese Datei dokumentiert:

- wie Theater Command DCS getestet wird
- welche Tests bereits bestanden sind
- welche Ergebnisse als verifiziert gelten
- welche Testgrenzen bestehen
- wie Persistence bei Tests geschützt wird
- wie Mission-Editor-, Runtime- und Source-Prüfungen voneinander getrennt werden
- welche Tests nicht ohne neuen Anlass wiederholt werden müssen

Das Projekt wird bewusst schrittweise getestet.

Grundregel:

    Eine konkrete Aufgabe.
    Eine Datei.
    Ein Test.
    Eine klare Bewertung.

Keine großen parallelen Änderungen.

---

## 2. Testphilosophie

Theater Command DCS folgt weiterhin dem state-first-Prinzip.

Grundreihenfolge:

    Source prüfen
    -> State erzeugen
    -> State sichtbar machen
    -> State-only Verhalten testen
    -> Dirty-/Persistence-Verhalten prüfen
    -> Framework-Fähigkeit isoliert testen
    -> Framework kontrolliert integrieren
    -> Framework-Ergebnis in Theater-Command-State zurückführen
    -> Ergebnis persistieren

Wichtig:

- keine Vendor-Dateien verändern
- keine All-in-one-Dateien erstellen
- keine Framework-Integration nur aufgrund theoretischer Source-Analyse als bestanden bewerten
- keine produktiven State-Änderungen ohne kontrollierten Testpfad
- keine großen Mission-Editor-Umbauten gleichzeitig
- keine bestehenden erfolgreichen Regressionen ohne Anlass erneut vollständig durchführen

---

## 3. Aktueller Gesamtstatus

Stand:

    2026-09-29

Bestanden:

- Starttest Variante A
- Vendor-Ladekette
- Theater-Command-Ladekette
- Airbase Scanner
- ZoneFactory
- CaptureSystem
- LogisticsDelivery
- FobSystem
- MissionGenerator
- AICapManager
- F10Menu
- Mission Activation
- Mission Completion
- Mission Failure
- Mission Effects
- Mission Completion -> Capture Pressure
- Capture Progress
- Capture Ready
- Capture Ready Apply
- Zone Ownership
- linked Airbase Ownership
- Persistence Save
- Persistence Read-back
- Compile
- Evaluate
- Validation
- kontrollierter Import
- Background Autosave
- `SAVED`
- `SKIPPED`
- kontrollierter `FAILED`
- Retry
- Capture Getter Read-Neutrality
- Capture Ownership No-Op
- LogisticsDelivery Read-Neutrality
- FobSystem Read-Neutrality
- AICapManager Read-Neutrality
- MissionGenerator Dirty-Coverage-Audit
- Priority 3 im dokumentierten Umfang
- Embedded Resource Audit
- CTLD Runtime-Zonenregistrierung
- CTLD KI-Transporterregistrierung
- automatischer CTLD-KI-Pickup
- autonomer KI-Transportflug
- Off-Airfield-Landung
- automatischer CTLD-Dropoff
- reale Blue-Bodengruppe nach Dropoff
- Schutz der produktiven Persistence während des CTLD-Tests

Noch nicht produktiv bestätigt:

- produktiver Startup-Restore
- produktive Theater-Command-CTLD-Orchestrierung
- CTLD Crate-/Cargo-Wirtschaft
- reale CTLD-FOBs
- reale MOOSE-CAP-Flüge
- AI Director
- Skynet-IADS-Kampagnenintegration
- Ground Campaign
- CAS-Automatisierung
- Carrier Operations
- Multiplayer

Verbindlich:

    productiveRestore=false

---

## 4. Aktuelle Systemversionen

| System | Datei | Version | Teststatus |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | bestanden, Restore deaktiviert |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.1` | bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.1` | bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | bestanden |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.1` | bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` | KI-Truppentransport-PoC bestanden |

---

## 5. Aktuelle Testmissionen

Technische Hauptmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_DEV.miz

Isolierte erfolgreiche CTLD-Testmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz

SHA-256 der CTLD-Testmission vor dem erfolgreichen Runtime-Test:

    5F0D89DF744A7083401E36713B148BD21813FF187CC36EC1F088507163458C57

Grundregel:

    Testmission != DEV-Mission

Ergebnisse aus einer isolierten Testmission werden nicht automatisch in die DEV-Mission übernommen.

---

## 6. Testumgebung

DCS:

    DCS World

Map:

    Syria

Lokales Repository:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\

DCS-Logs:

    C:\Users\Paul\Saved Games\DCS\Logs\dcs.log

oder:

    C:\Users\Paul\Saved Games\DCS.openbeta\Logs\dcs.log

Persistence-Verzeichnis:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS

Produktive Save-Datei:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

---

## 7. Entwicklungswerkzeuge

Seit 2026-09-29 gilt eine klare Werkzeugtrennung.

Diese Werkzeuge sind Entwicklungs- und Diagnosewerkzeuge.

Sie sind keine Runtime-Abhängigkeiten der fertigen Kampagne.

---

## 8. ChatGPT

ChatGPT übernimmt:

- Projektkoordination
- Architektur
- GitHub-Audit
- Testplanung
- Ergebnisbewertung
- Dokumentationspflege
- Definition der nächsten konkreten Aufgabe
- Vorbereitung präziser Claude-Aufträge

ChatGPT ersetzt keinen realen DCS-Runtime-Test.

---

## 9. Claude + dcs-mcp

Bevorzugtes Werkzeug für:

- `.miz`-Analyse
- Mission-Editor-Struktur
- Gruppen
- Units
- Trigger-Zonen
- Wegpunkte
- Tasks
- Airbase-Zuordnungen
- eingebettete Missionsressourcen
- gezielte `.miz`-Änderungen
- gespeicherten Missionsaudit

Aktuelle Version:

    dcs-mcp 0.9.11

Terrain Store:

    C:\Users\Paul\AppData\Local\dcs-mcp\terrain

Syria:

    installiert

dcs-mcp kann Struktur beweisen.

dcs-mcp beweist nicht allein tatsächliches DCS-AI- oder Framework-Runtime-Verhalten.

---

## 10. Claude Code + DCS-SMS

Bevorzugtes Werkzeug für lokale DCS-Runtime-Diagnose.

DCS-SMS:

    0.27.2

Hook:

    me-bridge-0.27.2

Lokale Installation:

    C:\Tools\dcs-sms

Claude-Code-Skill:

    C:\Users\Paul\.claude\skills\dcs-sms\SKILL.md

Verwendung:

- Mission-Editor-Status
- Mission Environment
- Runtime-Lua
- Theater-Command-State
- CTLD-Live-State
- Gruppen-State
- Unit-State
- Position
- Geschwindigkeit
- Grounded-/Airborne-State
- native Aktivierung
- Logs
- Runtime-Regressionen

---

## 11. Verbindlicher Testworkflow

Für Mission-Editor-/Framework-Tests:

    GitHub prüfen
    -> konkrete Aufgabe definieren
    -> aktuelle .miz mit Claude + dcs-mcp prüfen
    -> nur die konkrete Änderung durchführen
    -> Mission speichern
    -> gespeicherte Mission erneut prüfen
    -> Runtime-Test vorbereiten
    -> Claude Code + DCS-SMS für Live-Diagnose verwenden
    -> DCS-Verhalten praktisch beobachten
    -> Ergebnis bewerten
    -> bestätigten Stand dokumentieren

Für reine Lua-Tests kann der Workflow entsprechend verkürzt werden.

---

## 12. DCS ist der Verhaltensbeweis

Offline sicher prüfbar:

- Source
- Missionsstruktur
- Trigger
- Zonen
- Gruppen
- Units
- Wegpunkte
- gespeicherte Tasks
- eingebettete Ressourcen

Nur durch Runtime-Test sicher beweisbar:

- AI-Taxi
- Takeoff
- Navigation
- Landung
- CTLD-Pickup
- CTLD-Dropoff
- tatsächlicher Spawn
- Scheduler-Verhalten
- DCS-AI-Folgeaktionen

Deshalb gilt:

    gespeicherte Konfiguration
    !=
    automatisch bewiesenes Runtime-Verhalten

---

## 13. `.miz`-Einbettung

Eine über:

    DO SCRIPT FILE

geladene Lua-Datei wird in die `.miz` eingebettet.

Daher gilt:

    Repository geändert
    !=
    Embedded-Ressource automatisch geändert

Nach Source-Änderungen muss geprüft werden, ob die aktuelle Version tatsächlich in der getesteten Mission eingebettet ist.

---

## 14. Embedded Resource Audit

Auditdatum:

    2026-09-12

Ergebnis:

    13/13 relevante aktive Theater-Command-Ressourcen EXACT_MATCH

Zusätzlich bestätigt:

- keine aktiven Byte-Mismatches
- keine fehlenden relevanten aktiven Ressourcen
- keine aktive Embedded-Runtime-Drift

DEV-Mission und damalige MCP_TEST-Kopie waren beim Audit byte-identisch.

Der Audit widerlegte den damaligen Verdacht auf veraltete Embedded-Source als Ursache der Mission-Record-Diagnose.

Der Embedded Resource Audit bleibt ein geeignetes Kontrollinstrument, ist aber nicht der aktuelle offene Arbeitsschritt.

---

## 15. Aktive Ladefolge

Vendor:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua

Theater Command:

    1. src/core/tc_config.lua
    2. src/core/tc_logger.lua
    3. src/core/tc_state.lua
    4. src/core/tc_utils.lua
    5. src/core/tc_scheduler.lua
    6. src/world/tc_airbase_scanner.lua
    7. src/world/tc_zone_factory.lua
    8. src/campaign/tc_capture_system.lua
    9. src/campaign/tc_persistence_system.lua
    10. src/logistics/tc_logistics_delivery.lua
    11. src/logistics/tc_fob_system.lua
    12. src/missions/tc_mission_generator.lua
    13. src/ai/tc_ai_cap_manager.lua
    14. src/ui/tc_f10_menu.lua
    15. src/main.lua
    16. src/loader.lua

Die sichere Einzeldatei-Ladung bleibt aktueller Standard.

---

## 16. Starttest Variante A

Status:

    BESTANDEN

Methode:

    sichere Einzeldatei-Ladung per DO SCRIPT FILE

Bestätigt:

- Vendor-Frameworks laden.
- eigene Module laden.
- Main startet.
- Loader beendet sauber.
- Runtime-Systeme initialisieren.
- Persistence plant Background Autosave.
- F10Menu wird initialisiert.

Variante A bleibt aktueller Standard.

---

## 17. Starttest Variante B

Status:

    NICHT AKTUELL PRIORISIERT

Konzept:

    Loader-only mit dofile

Mögliche spätere Fragen:

- funktioniert `dofile` zuverlässig im Mission Scripting Environment?
- soll das Projekt später eine Build-Datei verwenden?
- ist eine reduzierte Triggerkette langfristig sinnvoll?

Dieser Test ist kein aktueller Blocker.

---

## 18. Erwartete Grundmarker

Bei einem normalen Start werden unter anderem erwartet:

    [TC] Theater Command loader started
    [TC] Framework available: MIST
    [TC] Framework available: MOOSE
    [TC] Framework available: CTLD
    [TC] Framework available: Skynet IADS
    [TC] Main start requested
    [TC] Core check passed
    [TC] Runtime systems initialized
    [TC] Main initialized
    [TC] Main started
    [TC] Theater Command loader finished

Zusätzlich relevant:

    [TC] [PersistenceSystem] Persistence autosave scheduled
    [TC] [F10Menu] F10 menu initialized

---

## 19. Erwartete Modulversionen

Aktuell erwartet:

    AirbaseScanner      v0.2.2
    ZoneFactory         v0.2.0
    CaptureSystem       v0.2.2
    PersistenceSystem   v0.2.6
    LogisticsDelivery   v0.2.1
    FobSystem           v0.2.1
    MissionGenerator    v0.2.3
    AICapManager        v0.2.1
    F10Menu             v0.2.3
    CTLD                1.6.1

Wenn eine ältere Version geladen wird:

1. Embedded-Ressource prüfen.
2. Mission-Editor-Ressource aktualisieren.
3. Mission speichern.
4. Missionsdatei erneut auditieren.
5. Runtime-Test wiederholen.

---

## 20. Airbase-Scanner-Test

Status:

    BESTANDEN

Bestätigte Werte:

    total: 225
    strategic: 19
    secondary: 13
    heliports: 1
    helipads: 95
    medical: 40
    farps: 0
    tactical: 13
    unknown: 44
    captureCandidates: 32
    missionCandidates: 32
    logisticsCandidates: 46
    blueStartBases: 1
    redStrategicCandidates: 18

Die hohe Zahl von 225 Airbase-like Objects ist kein Fehler.

---

## 21. ZoneFactory-Test

Status:

    BESTANDEN

Bestätigte Werte:

    total zones: 46
    skipped airbase-like objects: 179
    captureZones: 32
    missionZones: 32
    logisticsZones: 46
    startBaseZones: 1

Die historische frühe Ausgabe mit 225 direkt erzeugten Zonen ist nicht mehr der aktuelle Projektstand.

---

## 22. CaptureSystem-Test

Status:

    BESTANDEN

Bestätigte Startwerte:

    eligibleBases: 32
    eligibleZones: 32
    nonCaptureBases: 193
    nonCaptureZones: 14
    pressureRecords: 32
    progressRecords: 32

Bestätigte Funktionen:

- Capture Pressure
- Capture Progress
- Capture Ready
- Mission Effect Processing
- Ownership Apply
- linked Airbase Sync
- Pressure Reset
- Read-Neutrality
- Owner No-Op

---

## 23. Mission Completion zu Capture Ready

Status:

    BESTANDEN
    2026-09-12 erneut bestätigt

Bestätigter Ablauf:

    Mission Details
    -> Mission Activation
    -> Mission Completion
    -> Mission Effects
    -> Capture Pressure
    -> Capture Progress
    -> Capture Ready

Bestätigter Testfall:

    Mission: MISSION_2
    Zone: ZONE_AIRBASE_ABU_AL_DUHUR
    Owner: BLUE
    Pressure: 105
    Progress: 100 %
    appliedMissionEffects: 1
    ready: 1
    contested: 0

Persistence:

    SAVED
    dirtyReason=f10_active_mission_1_completed
    dirtyCleared=true
    productiveRestore=false

---

## 24. Capture Ready Apply

Status:

    BESTANDEN
    2026-09-12 erneut bestätigt

Testzone:

    ZONE_AIRBASE_ABU_AL_DUHUR

Vor Apply:

    Owner RED
    Progress 100 %

Nach Apply:

    zoneOwner=BLUE
    previousOwner=RED
    baseOwner=BLUE
    progress=0
    status=STABLE
    captureReady=false

Persistence:

    SAVED
    dirtyReason=f10_capture_ready_zone_1_applied
    dirtyCleared=true
    productiveRestore=false

Bekannte kosmetische F10-Auffälligkeit:

Die F10-Ausgabe zeigte zeitweise:

    BLUE -> BLUE

Der Runtime-State bestätigte jedoch korrekt:

    RED -> BLUE

Kein CaptureSystem-Fehler.

---

## 25. Mission Failure

Status:

    BESTANDEN
    2026-09-12 erneut bestätigt

Bestätigter Ablauf:

    Mission Activation
    -> Mission Failure
    -> Failure Effects
    -> CaptureSystem verarbeitet Effects
    -> kein Capture Pressure

Bestätigte State Counts nach dem entsprechenden Test:

    available=8
    active=0
    completed=1
    failed=1
    total=10

Persistence:

    SAVED
    dirtyReason=f10_active_mission_1_failed
    dirtyCleared=true
    productiveRestore=false

---

## 26. MissionGenerator-Record-Diagnose

Historischer Verdacht:

    Mission Records könnten verschwinden.

Auflösung am 2026-09-12:

    WIDERLEGT

Ursache der Fehldiagnose:

Mission-Collections sind String-keyed Lua-Dictionaries.

Für sie ist:

    #table

kein autoritativer Count.

Live bestätigt:

    statistics.available=10
    pairs()-Count available=10
    #available=0

Der tatsächliche Source-Bug lag in:

    src/core/tc_state.lua
    State.summary()

Dort wurde ein falscher `#`-Count verwendet.

Nach pairs-basierter Korrektur bestanden die Regressionen.

Es gab keinen Mission-Record-Datenverlust.

---

## 27. Capture Getter Read-Neutrality

Status:

    BESTANDEN
    2026-09-12

Vor dem Fix konnte ein reiner Getter Dirty-State erzeugen.

Nach dem Fix getestet:

    getCaptureReadyZones()
    getPressureContestedZones()
    getPressureSummary()
    getCaptureEligibleBases()
    getCaptureEligibleZones()
    getEligibilitySummary()
    getCaptureProgress()

Ergebnis für alle:

    dirty=false
    reason=nil

Positive Gegenprobe:

    echte Capture-Pressure-Mutation
    -> dirty=true
    -> reason=capture_pressure_set

Rollback:

    finalDirty=false

---

## 28. Capture Ownership No-Op

Status:

    BESTANDEN
    2026-09-12

Testzone:

    ZONE_AIRBASE_ABU_AL_DUHUR

Ein redundanter Owner-Set-Aufruf mit gleichem Owner verändert inzwischen keinen relevanten persistierten State.

Bestätigt:

    dirty=false
    reason=nil

Keine unerwarteten Mutationen an:

- Zone Update Timestamp
- Progress Update Timestamp
- Capture Last Update
- Previous Owner

---

## 29. Priority 3 Dirty-Coverage

Status:

    ABGESCHLOSSEN IM DOKUMENTIERTEN UMFANG

Abschluss:

    2026-09-21

Geprüfte Systeme:

    LogisticsDelivery
    FobSystem
    MissionGenerator
    AICapManager

Ergebnis:

- LogisticsDelivery: aktiver Read-Neutrality-Bug gefunden und behoben.
- FobSystem: aktiver Read-Neutrality-Bug gefunden und behoben.
- MissionGenerator: kein aktiver Missing-Dirty-Bug gefunden.
- AICapManager: aktiver Read-Neutrality-Bug gefunden und behoben.

Priority 3 wird nicht ohne neuen Anlass vollständig neu durchgeführt.

Latente Lifecycle-Punkte bleiben separat relevant.

---

## 30. LogisticsDelivery Read-Neutrality

Version:

    v0.2.1

Status:

    BESTANDEN

Getestete read-neutrale Pfade:

    getStatistics()
    getHubSummary()
    summary()

Ergebnis:

- kein persistierter Logistics-State verändert
- kein Dirty erzeugt

Positive Gegenprobe:

    createDelivery()

Ergebnis:

    dirty=true
    dirtyReason=logistics_delivery_created

Runtime-Regression bestanden.

---

## 31. FobSystem Read-Neutrality

Version:

    v0.2.1

Status:

    BESTANDEN

Unter anderem getestet:

    getStatistics()
    summary()
    get()
    getAll()
    getCandidates()
    getByStatus()
    getByOwner()
    getBlueFobs()

Ergebnis:

- keine persistierte FOB-Mutation
- kein Dirty

Positive Gegenprobe:

    FobSystem.create()

Ergebnis:

    dirty=true
    dirtyReason=fob_created

Runtime-Regression bestanden.

---

## 32. MissionGenerator Dirty-Coverage

Version:

    v0.2.3

Status:

    BESTANDEN

READ-ONLY Audit:

- kein aktuell aktiver Missing-Dirty-Bug gefunden
- kein vorsorglicher Code-Fix vorgenommen

Der frühere Mission-Record-Verlust war keine echte State-Mutation und kein Datenverlust.

---

## 33. AICapManager Read-Neutrality

Version:

    v0.2.1

Status:

    BESTANDEN

Getestete read-neutrale Pfade umfassen:

    getStatistics()
    summary()
    getCap()
    getCapZones()
    getCapZoneCandidates()
    getRequestedCaps()
    getActiveCaps()
    getCompletedCaps()
    getFailedCaps()
    getCancelledCaps()
    getCapsBySide()

Ergebnis:

- keine persistierte AI-State-Mutation
- kein Dirty

Positive Gegenprobe:

    setCapStatus()

Ergebnis:

    dirty=true
    dirtyReason=ai_cap_record_changed

Runtime-Regression bestanden.

---

## 34. Latenter AICapManager-Sonderfall

Funktion:

    reactToActiveMissions()

Aktuell:

- keine produktive Call-Site
- nicht Bestandteil des laufenden produktiven AI-Lifecycle

Daher aktuell:

    kein Runtime-Persistence-Bug

Bei späterer Verdrahtung muss der Pfad erneut gezielt geprüft werden.

Dies ist kein Grund, Priority 3 erneut vollständig durchzuführen.

---

## 35. PersistenceSystem v0.2.6

Status:

    BESTANDEN

Bestätigt:

- File-System-Erkennung
- Write
- Read-back
- Compile
- Evaluate
- Validation
- kontrollierter Import
- Background Autosave
- Dirty Awareness
- `SAVED`
- `SKIPPED`
- kontrollierter `FAILED`
- Retry

Autosave:

    initialDelay=20s
    interval=120s

Produktiver Restore:

    false

---

## 36. Persistence `SAVED`

Status:

    BESTANDEN

Bestätigt:

- realer Dirty-State wird vom Scheduler erkannt
- Save-Datei wird geschrieben
- Read-back erfolgt
- Snapshot wird kompiliert
- Snapshot wird evaluiert
- Snapshot wird validiert
- Dirty wird erst danach gelöscht

Ein erfolgreicher Save darf keinen neueren Dirty-State fälschlich löschen.

Dieser Schutz ist ebenfalls bestätigt.

---

## 37. Persistence `SKIPPED`

Status:

    BESTANDEN

Bei unverändertem State:

    lastAutosaveStatus=SKIPPED
    lastAutosaveReason=state_unchanged

Bestätigt:

- AutosaveCount steigt nicht durch Skip.
- Save-Datei wird nicht neu geschrieben.
- Größe bleibt gleich.
- Änderungszeit bleibt gleich.
- SHA-256 bleibt gleich.

---

## 38. Persistence `FAILED` und Retry

Status:

    BESTANDEN

Kontrollierter Schreibfehler:

    FAILED

Bestätigt:

- Dirty bleibt erhalten.
- Dirty Reason bleibt erhalten.
- bestehende Save-Datei wird nicht beschädigt.
- nach Wiederherstellung des Schreibpfads funktioniert Retry.
- Dirty wird erst nach erfolgreichem Retry gelöscht.

---

## 39. Produktiver Restore

Status:

    NICHT FREIGEGEBEN

Verbindlich:

    productiveRestore=false

Priority 3 ist inzwischen abgeschlossen.

Vor Aktivierung des produktiven Restores bleiben trotzdem separat zu klären:

- Restore-/Initialisierungsreihenfolge
- Save-Versionierung
- Save-Kompatibilität
- State-Lifecycle
- Framework-Rekonstruktion
- CTLD-/MOOSE-/Skynet-Nebenwirkungen
- kontrollierter Restore-Test

---

## 40. Produktive Save-Datei

Pfad:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Letzter bestätigter Stand nach dem CTLD-Test vom 2026-09-29:

    Größe: 3094967 Bytes

SHA-256:

    C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596

Änderungszeit:

    2026-09-21 15:00:00.5926451

---

## 41. Persistence-Schutz bei isolierten Tests

Wenn ein Test möglicherweise den produktiven Save verändern könnte:

    1. aktuellen Save-Hash prüfen
    2. Backup erzeugen
    3. Backup-Hash prüfen
    4. produktive Save-Datei ReadOnly setzen
    5. ReadOnly bestätigen
    6. Test durchführen
    7. DCS vollständig beenden
    8. produktiven Save erneut prüfen
    9. Hash mit Referenz vergleichen
    10. nur bei Hash-Match ReadOnly entfernen
    11. final nochmals Hash prüfen

Verbindlich:

Der ReadOnly-Schutz wird nicht entfernt, solange DCS beziehungsweise die Testmission noch läuft.

---

## 42. CTLD Framework-Test

Testdatum:

    2026-09-29

Status:

    KI-TRUPPENTRANSPORT-PoC BESTANDEN

CTLD-Version:

    1.6.1

Testmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz

SHA-256 vor dem Test:

    5F0D89DF744A7083401E36713B148BD21813FF187CC36EC1F088507163458C57

---

## 43. CTLD-Testaufbau

Pickup-Zone:

    CTLD_PICKUP_BLUE_AKROTIRI_01

Radius:

    250 m

Technische Dropoff-Zone:

    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01

Zentrum:

    x / North = -29249.110954281
    z / East  = -271836.070539260

Radius:

    60 m

Testgruppe:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01

Testunit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Transporter:

    Mi-8

---

## 44. CTLD-Zonenregistrierung

Status:

    BESTANDEN

Nach CTLD-Initialisierung wurden normalisierte Zonen zur Laufzeit ergänzt.

Pickup:

    ctld.pickupZones

Getesteter Eintrag:

    { "CTLD_PICKUP_BLUE_AKROTIRI_01", -1, 10000, 1, 2 }

Dropoff:

    ctld.dropOffZones

Getesteter Eintrag:

    { "CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01", -1, 2, 1 }

Bestätigt:

- beide Einträge wurden live erkannt
- CTLD nutzte sie tatsächlich
- `ctld.initialize()` musste nicht erneut ausgeführt werden

---

## 45. CTLD `transportPilotNames`

Status:

    BESTANDEN

Wichtiger Source-/Runtime-Befund:

    ctld.checkAIStatus()

arbeitet für den getesteten AI-Pfad mit:

    ctld.transportPilotNames

Die Testunit war dort zunächst nicht registriert.

Vor Registrierung:

    108 Einträge

Nach temporärer idempotenter Registrierung:

    109 Einträge

Die Testunit war genau einmal vorhanden.

Produktive Architekturfolgerung:

KI-Transporter müssen später durch Theater Command automatisch und idempotent registriert werden.

---

## 46. CTLD automatischer Pickup

Status:

    BESTANDEN

Nach nativer Aktivierung der Gruppe:

- CTLD nahm automatisch 16 Soldaten auf.
- Pickup-Counter wechselte `10000 -> 9999`.
- Transporter befand sich innerhalb der Pickup-Zone.

Nicht verwendet:

- manuelles CTLD-Loading
- direkte Manipulation von `ctld.inTransitTroops`
- Teleport
- Runtime-Routenänderung

---

## 47. CTLD Flugphase

Status:

    BESTANDEN

Bestätigt:

- Taxi
- Takeoff
- Transit
- Descent
- Anflug zum vorgesehenen Dropoff

Die Bewegung erfolgte durch normale DCS-AI auf Grundlage der gespeicherten Mission.

Keine Runtime-Routenänderung war erforderlich.

---

## 48. CTLD Off-Airfield-Landung

Status:

    BESTANDEN

Erfolgreiche Mission-Editor-Konfiguration:

    normaler Turning Point
    +
    Perform Task Land

Wegpunkt:

    Höhe: 100 m BARO
    Geschwindigkeit: 30 m/s

Land Task:

    duration=300
    durationFlag=true

Touchdown:

    ungefähr 1.06 m vom Dropoff-Zentrum entfernt

Der Transporter blieb nach der Landung am Boden.

Ein Invisible FARP war für diesen Test nicht erforderlich.

---

## 49. Vergleich mit vorherigem Landetest

Ein früherer Test mit einem ungebundenen:

    Land / Landing

Waypoint führte nicht zum vollständigen gewünschten Transportzyklus.

Der erfolgreiche Test mit:

    Turning Point + Perform Task Land

isoliert die Landemethode als wesentlichen Unterschied.

Nicht behauptet wird:

- dass damit die genaue Ursache des früheren Turnbacks mathematisch bewiesen wurde
- dass jeder Helikoptertyp identisch reagiert

Bestätigt ist nur der tatsächlich getestete Pfad.

---

## 50. CTLD automatischer Dropoff

Status:

    BESTANDEN

Nach der Off-Airfield-Landung:

- der CTLD-Bordzustand verlor die transportierten Truppen
- `ctld.droppedTroopsBLUE` erhielt einen neuen Eintrag
- eine reale Blue-Bodengruppe wurde erzeugt

Erzeugte Gruppe:

    Dropped Group 2

Group-ID:

    70001

Stärke:

    16

Einheiten:

    Soldier M249

Die DCS-AI führte die Bodengruppe anschließend weiter.

---

## 51. CTLD-Testgrenzen

Der erfolgreiche Test war:

    KI-Truppentransport

Er beweist nicht automatisch:

- Crate Spawn
- Crate Loading
- Sling Load
- Crate Drop
- Supply Cargo
- Engineering Cargo
- Repair Cargo
- Fuel Cargo
- Ammo Cargo
- FOB Core
- realen FOB-Bau
- produktive LogisticsDelivery-Rückkopplung
- produktive FobSystem-Rückkopplung
- produktive Capture-Rückkopplung
- CTLD-Restore
- Multiplayer

Diese Bereiche bleiben separat zu testen.

---

## 52. CTLD `RepackCommandsPath`-Fehler

Beim Grounded-Übergang trat genau ein bekannter CTLD-Fehler auf:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Kontext:

    updateRepackMenu
    updateRepackMenuOnlanding

Technische Einordnung:

- AI-Transporter war in `ctld.transportPilotNames` registriert.
- CTLD-Landemenülogik wurde dadurch für diese Unit relevant.
- für reine KI-Units existiert nicht zwingend ein Player-/F10-Command-Pfad.
- der erwartete `vehicleCommandsPath` kann deshalb fehlen.

Der automatische Dropoff wurde trotzdem erfolgreich abgeschlossen.

Nicht bewiesen:

- dass der Fehler langfristig harmlos ist
- dass der betroffene Scheduler danach vollständig normal weiterläuft

Verbindlich:

    vendor/ctld/CTLD.lua wird nicht gepatcht.

Die spätere Lösung muss außerhalb des Vendor-Codes liegen.

---

## 53. Persistence-Schutz beim CTLD-Test

Vor dem CTLD-Test wurde der produktive Save geschützt.

Backup:

    C:\Users\Paul\Documents\TC_miz_backups\operation_levant_reclamation_save__pre_landtask_test_2026-09-29_100813.lua

Referenz-SHA-256:

    C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596

Während des Tests:

    produktiver Save ReadOnly

Nach beendetem Test:

- Größe unverändert
- Änderungszeit unverändert
- SHA-256 unverändert
- produktiver Kampagnenstate unverändert

Danach wurde der Schreibschutz wieder entfernt.

Final:

    ReadOnly=False

SHA-256 blieb unverändert.

---

## 54. Bewertung des CTLD-PoC

Technisch bewiesen:

    CTLD Runtime-Zonenregistrierung
    -> KI-Transporterregistrierung
    -> Pickup
    -> Flug
    -> Off-Airfield-Landung
    -> automatischer Dropoff
    -> reale Bodengruppe

Noch nicht bewiesen:

    Theater Command plant und orchestriert diesen Ablauf selbständig.

Daher lautet der Status:

    Framework-PoC bestanden
    produktive Integration offen

---

## 55. Aktuelle bestätigte Kernwerte

Airbase Scanner:

    total: 225
    strategic: 19
    secondary: 13
    heliports: 1
    helipads: 95
    medical: 40
    tactical: 13
    unknown: 44
    captureCandidates: 32
    missionCandidates: 32
    logisticsCandidates: 46
    blueStartBases: 1
    redStrategicCandidates: 18

ZoneFactory:

    total zones: 46
    skipped airbase-like objects: 179
    captureZones: 32
    missionZones: 32
    logisticsZones: 46
    startBaseZones: 1

CaptureSystem:

    eligibleBases: 32
    eligibleZones: 32
    nonCaptureBases: 193
    nonCaptureZones: 14
    pressureRecords: 32
    progressRecords: 32

LogisticsDelivery:

    logistics hubs: 46
    blue hubs: 7
    red hubs: 24
    neutral hubs: 15
    active hubs: 31
    limited hubs: 15
    locked hubs: 0

FobSystem:

    FOB candidates: 6
    stored candidates: 6
    auto-planned FOBs: 2
    skipped candidates: 4

MissionGenerator:

    mission candidates: 78
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 68
    lastMissionId: 10

AICapManager:

    cap zone candidates: 31
    CAP zones: 12
    CAP requests: 12

F10Menu:

    commands: 33

PersistenceSystem:

    version: v0.2.6
    fileSystemAvailable: true
    autosaveEnabled: true
    autosaveScheduled: true
    autosaveRunning: true
    autosaveInitialDelay: 20s
    autosaveInterval: 120s
    productiveRestore: false

---

## 56. DCS-Sandbox und MissionScripting.lua

Persistence benötigt mindestens die notwendigen Dateioperationen.

DCS-SMS benötigt für die aktuelle lokale Bridge zusätzliche Sandbox-Freigaben.

Aktuell dokumentierte Entwicklungsumgebung:

    os=true
    io=true
    lfs=true
    require=false

DCS-Updates können:

    MissionScripting.lua

überschreiben.

Nach DCS-Updates müssen deshalb erneut geprüft werden:

- Persistence-Dateizugriff
- DCS-SMS-Bridge
- Mission-Environment-Zugriff

---

## 57. Sauberer Logtest

Bevorzugter Ablauf:

1. DCS beenden.
2. Alte `dcs.log` sichern oder löschen.
3. DCS neu starten.
4. exakt die vorgesehene Mission starten.
5. genau den vorgesehenen Test durchführen.
6. DCS beenden.
7. neue Logzeilen analysieren.

Ein fortgeschriebener Log ist zulässig, wenn:

- Beginn des neuen Testabschnitts eindeutig bekannt ist
- alte Marker klar ausgeschlossen werden können

---

## 58. Kritische Fehlerindikatoren

Besonders relevant:

    [TC][ERROR]
    SCRIPTING ERROR
    Mission script error
    stack traceback
    attempt to index
    attempt to call
    nil value
    protected call failed

Bei Auftreten:

1. betroffene Datei identifizieren
2. geladene Version prüfen
3. Stacktrace prüfen
4. letzte Änderung isolieren
5. keine weitere fachliche Änderung beginnen, bevor der Fehler bewertet ist

---

## 59. Nicht automatisch Theater-Command-Fehler

Nicht jede DCS-Warnung ist ein Projektfehler.

Beispiele:

- `DTC_MANAGER Window pointer is null`
- `LUA-TERRAIN getObjectPosition`
- `DX11BACKEND ... render target ... not found`
- `INVALID ATC`
- `ModelTimeQuantizer`
- `Destruction shape not found`
- Terrain-Warnings
- Grafik-Warnings
- Asset-Warnings

Relevant werden solche Meldungen erst bei einem belegbaren Zusammenhang zum getesteten System.

---

## 60. Testauswertung

Bei jeder Regression prüfen:

1. Welche Mission wurde tatsächlich getestet?
2. Welche Modulversionen wurden tatsächlich geladen?
3. Ist die erwartete Source-Version in der `.miz`?
4. Sind alle Startmarker vorhanden?
5. Sind die relevanten Runtime-Marker vorhanden?
6. Gibt es Lua-/Scripting-Fehler?
7. Stimmen die erwarteten Counts?
8. Wurde echter State verändert?
9. Wurde Dirty korrekt gesetzt oder bewusst nicht gesetzt?
10. Wurde Persistence korrekt ausgelöst?
11. Wurde der produktive Save unbeabsichtigt verändert?
12. War das Ergebnis state-only oder Framework-Runtime?
13. Ist das Ergebnis tatsächlich durch DCS bewiesen oder nur offline konfiguriert?

---

## 61. Testprotokoll-Vorlage

Für neue Tests:

    Datum:
    Mission:
    Mission-SHA-256:
    getestetes System:
    getestete Datei:
    erwartete Version:
    tatsächliche Version:
    Testziel:
    Ausgangszustand:
    Testablauf:
    erwartete Marker:
    beobachtete Marker:
    relevante Runtime-Werte:
    Fehlerindikatoren:
    Persistence vor Test:
    Persistence nach Test:
    Rollback/Cleanup:
    Ergebnis:
    offene Punkte:
    nächster Schritt:

---

## 62. Testklassifikationen

Für künftige Tests bevorzugte Bewertungen:

    BESTANDEN

Die getestete Funktion hat unter den dokumentierten Bedingungen vollständig funktioniert.

    TEILWEISE BESTANDEN

Ein Teilpfad funktioniert, aber relevante Bedingungen oder Folgefunktionen bleiben offen.

    NICHT BESTANDEN

Das erwartete Verhalten trat nicht ein.

    NICHT GETESTET

Es gibt keinen ausreichenden Runtime-Beweis.

    HISTORISCH WIDERLEGT

Ein früherer Befund wurde später durch bessere Evidenz widerlegt.

Diese Begriffe sollen präziser sein als pauschale Aussagen wie:

    funktioniert irgendwie
    vermutlich okay
    scheint gut

---

## 63. Was nicht erneut getestet werden muss

Ohne neuen Anlass nicht erneut vollständig durchführen:

- Mission Completion Regression
- Mission Failure Regression
- Capture Ready Apply Regression
- Capture Getter Read-Neutrality
- Capture Ownership No-Op
- LogisticsDelivery Read-Neutrality
- FobSystem Read-Neutrality
- AICapManager Read-Neutrality
- identischen CTLD-LANDTASK-PoC

Ein neuer Test ist sinnvoll, wenn:

- betreffende Source geändert wurde
- relevante Mission-Editor-Struktur geändert wurde
- Framework-Version geändert wurde
- DCS-Version relevantes Verhalten verändert haben könnte
- ein neuer Integration Layer hinzukommt
- ein bisher nicht getesteter Lifecycle aktiviert wird

---

## 64. Aktuelle offene Testbereiche

Noch separat zu testen:

- produktive CTLD-Integration
- CTLD Crates
- Cargo Loading
- Sling Load
- Cargo Drop
- FOB Build
- LogisticsDelivery-Rückkopplung aus realem CTLD-Ergebnis
- FobSystem-Rückkopplung
- CTLD-Ergebnis-Persistence
- MOOSE-CAP-Spawns
- AI-Mission-Lifecycle
- Ground Operations
- CAS
- IADS
- Carrier Operations
- produktiver Restore
- Multiplayer

---

## 65. Nächster Testbereich

Der nächste Test ist noch nicht als konkrete Runtime-Regression festgelegt.

Zuerst muss die Architektur der produktiven CTLD-Integration definiert werden.

Zu klären:

- fachliche Zuständigkeit unter `src/`
- idempotente Zonenregistrierung
- idempotente Transporterregistrierung
- Transporter-Lifecycle
- Behandlung von `RepackCommandsPath`
- Transportauftrag
- Erfolgserkennung
- Fehlererkennung
- Result Validation
- Rückkopplung in `TC.State`
- Dirty-Semantik
- Persistence-Grenze

Erst danach wird genau ein neuer Integrationstest definiert.

---

## 66. Aktueller Abschlussstand

Stand:

    2026-09-29

Bestanden:

- state-first Kampagnenkern
- Mission-/Capture-Pipelines
- dirty-aware Background Persistence
- Priority 3 im dokumentierten Umfang
- Embedded Resource Audit
- CTLD KI-Truppentransport-PoC

Bewusste Grenzen:

    productiveRestore=false

und:

    CTLD-PoC != produktive Theater-Command-CTLD-Integration

und:

    CTLD-Truppentransport-PoC != Cargo-/Crate-PoC

Bekannter CTLD-Integrationspunkt:

    RepackCommandsPath

Aktueller Entwicklungsübergang:

    state-first Kampagnenkern
    +
    bestandener CTLD Framework-PoC
    ->
    kontrollierte produktive CTLD-Integration

---

## 67. Startpunkt für die nächste Session

Vor neuen Tests zuerst GitHub prüfen.

Mindestens:

- `README.md`
- `ROADMAP.md`
- `TASKS.md`
- `CHANGELOG.md`
- `ARCHITECTURE.md`
- `MISSION_EDITOR_SETUP.md`
- `docs/05_logistics_system.md`
- `docs/09_persistence.md`
- `docs/10_testing.md`
- `mission_editor/README.md`
- `mission_editor/ctld_start_zones.md`
- `mission_editor/trigger_setup.md`

Für CTLD-Integration zusätzlich den aktuellen Source prüfen:

- `src/logistics/tc_logistics_delivery.lua`
- `src/logistics/tc_fob_system.lua`
- `src/missions/tc_mission_generator.lua`
- relevante Core-/State-Schnittstellen
- `vendor/ctld/CTLD.lua` ausschließlich read-only

Danach genau eine konkrete Architektur- oder Integrationsaufgabe festlegen.

---

## Footer

Testing bleibt der Sicherheitsrahmen von Theater Command DCS.

Verbindlicher Leitsatz:

    Eine Aufgabe.
    Eine Datei.
    Ein Test.
    Eine klare Bewertung.

Aktueller Stand:

    Priority 3 abgeschlossen.
    CTLD-KI-Truppentransport-PoC bestanden.
    Produktive CTLD-Integration noch offen.
