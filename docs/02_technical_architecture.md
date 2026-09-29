# Technical Architecture

## Verbindlicher Stand — 2026-09-29

Diese Datei beschreibt die technische Architektur von **Theater Command DCS**.

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

- Blue startet auf Akrotiri / Zypern.
- Das syrische Festland ist zu Beginn rot kontrolliert.
- Blue soll sich vom Brückenkopf Zypern aus auf das syrische Festland vorarbeiten.
- Spieler sollen Teil einer laufenden Kampagne sein und nicht jede Operation selbst auslösen müssen.
- Blue und Red sollen perspektivisch zunehmend autonom handeln.

Grundprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis / Source of Truth

Zusätzlich gilt für die Runtime-Bewertung:

    DCS Runtime = autoritativer Verhaltensbeweis

---

## 1. Architekturziel

Theater Command DCS soll langfristig keine Sammlung statischer Missionen sein.

Das Ziel ist eine modulare Kampagnenruntime, die:

- strategischen Kampagnenzustand verwaltet
- Airbases und Zonen bewertet
- Besitzstände verwaltet
- Capture Pressure und Capture Progress verwaltet
- Missionen erzeugt
- Logistik verwaltet
- FOBs verwaltet
- AI-Bedarf ableitet
- reale Operationen über Frameworks ausführen lässt
- Ergebnisse zurück in den Kampagnenstate überführt
- relevanten State persistent speichert
- später Missionsneustarts überstehen kann

Perspektivisch sollen zusammenarbeiten:

- Core Layer
- World Layer
- Campaign Layer
- Capture System
- Logistics System
- FOB System
- Mission Generator
- AI CAP Manager
- AI Director
- IADS System
- UI
- Debug
- Persistence
- CTLD
- MOOSE
- Skynet IADS

---

## 2. Zentrale Architekturtrennung

Die wichtigste Architekturgrenze lautet:

    Theater Command
    =
    Campaign Logic
    Decision Layer
    State Owner

und:

    CTLD / MOOSE / Skynet IADS
    =
    Execution Layer

Das bedeutet:

Theater Command entscheidet beispielsweise:

- welche Zone strategisch relevant ist
- welche Mission benötigt wird
- welcher Hub Versorgung braucht
- welcher FOB gebaut werden soll
- wo CAP benötigt wird
- welche Operation erfolgreich war
- welche Folgen daraus entstehen
- was persistiert werden muss

Frameworks führen reale DCS-Aktionen aus.

Beispiele:

CTLD:

- Truppentransport
- Cargo
- spätere FOB-Logistik

MOOSE:

- CAP
- Strike
- SEAD
- DEAD
- CAS
- weitere reale AI-Air-Operationen

Skynet IADS:

- SAM-/EWR-Netz
- Radarverhalten
- IADS-Ausführung

Theater Command darf seinen langfristigen Kampagnenstate nicht einfach an interne Runtime-Strukturen eines Frameworks delegieren.

---

## 3. State-first-Prinzip

Die aktuelle Entwicklung folgt weiterhin:

    State zuerst.

Reihenfolge:

    State erzeugen
    -> State sichtbar machen
    -> State testen
    -> Dirty-/Persistence-Semantik absichern
    -> Framework-Funktion isoliert beweisen
    -> Framework kontrolliert anbinden
    -> Ergebnis validieren
    -> Ergebnis in Theater-Command-State zurückführen
    -> Dirty markieren
    -> Persistence

Dieses Prinzip hat sich bisher bewährt.

Es trennt:

- Kampagnenlogik
- DCS-Verhalten
- Framework-Verhalten
- Persistence
- Mission-Editor-Struktur

voneinander.

---

## 4. Aktueller technischer Gesamtstand

Stand:

    2026-09-29

Bestätigt:

- Repository-Struktur
- Vendor-Struktur
- Core Layer
- World Layer
- Airbase Scanner
- ZoneFactory
- CaptureSystem
- PersistenceSystem
- LogisticsDelivery
- FobSystem
- MissionGenerator
- AICapManager
- F10Menu
- Mission Activation
- Mission Completion
- Mission Failure
- Mission Effects
- Completion -> Capture Pressure
- Capture Progress
- Capture Ready
- Capture Ready Apply
- Zone Ownership
- linked Airbase Ownership
- dirty-aware Background Persistence
- Capture Getter Read-Neutrality
- Capture Ownership No-Op
- LogisticsDelivery Read-Neutrality
- FobSystem Read-Neutrality
- MissionGenerator Dirty-Coverage-Audit
- AICapManager Read-Neutrality
- Priority 3 abgeschlossen
- CTLD Runtime-Zonenregistrierung
- CTLD KI-Transporterregistrierung
- automatischer CTLD-KI-Pickup
- autonomer KI-Transportflug
- Off-Airfield-Landung
- automatischer CTLD-Dropoff
- reale Blue-Bodengruppe nach Dropoff

Noch nicht produktiv:

- produktive Theater-Command-CTLD-Orchestrierung
- CTLD Crate-/Cargo-Wirtschaft
- reale CTLD-FOBs
- reale MOOSE-CAP-Spawns
- AI Director
- Ground Campaign
- CAS-Automatisierung
- Skynet-IADS-Kampagnenintegration
- produktiver Startup-Restore
- Carrier Operations
- Multiplayer

---

## 5. Aktueller Modulstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | Background Persistence bestanden |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.1` | bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.1` | bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | bestanden |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.1` | bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` | KI-Truppentransport-PoC bestanden |

Verbindlich:

    productiveRestore=false

---

## 6. Repository-Hauptstruktur

Aktuelle fachliche Hauptstruktur:

    theater-command-dcs/
    ├── .agents/
    ├── docs/
    ├── mission_editor/
    ├── src/
    ├── tools/
    ├── vendor/
    ├── AGENTS.md
    ├── ARCHITECTURE.md
    ├── CHANGELOG.md
    ├── LUA_STYLEGUIDE.md
    ├── MISSION_EDITOR_SETUP.md
    ├── NAMING_CONVENTIONS.md
    ├── README.md
    ├── ROADMAP.md
    └── TASKS.md

---

## 7. Source-Struktur

Eigene Theater-Command-Logik liegt unter:

    src/

Aktuelle Struktur:

    src/
    ├── core/
    ├── world/
    ├── campaign/
    ├── logistics/
    ├── missions/
    ├── ai/
    ├── iads/
    ├── ui/
    ├── debug/
    ├── main.lua
    └── loader.lua

Die Source-Struktur ist nach fachlicher Aufgabe organisiert.

Nicht nach Framework.

Nicht gewünscht:

    tc_moose.lua
    tc_mist.lua
    tc_ctld.lua
    tc_ctld_all_in_one.lua
    tc_ctld_bridge.lua
    tc_all_in_one.lua

Ein fachliches Modul darf intern ein Framework verwenden.

Beispiel:

    LogisticsDelivery

darf später CTLD zur Ausführung verwenden.

Dadurch wird LogisticsDelivery nicht zu einem generischen CTLD-Wrapper.

---

## 8. Aktive Source-Dateien

Aktuell aktive eigene Dateien:

    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
    src/core/tc_utils.lua
    src/core/tc_scheduler.lua
    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua
    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua
    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua
    src/missions/tc_mission_generator.lua
    src/ai/tc_ai_cap_manager.lua
    src/ui/tc_f10_menu.lua
    src/main.lua
    src/loader.lua

Vorbereitet, aber noch nicht produktiv aktiv:

    src/iads/
    src/debug/

---

## 9. Vendor-Struktur

Externe Frameworks liegen ausschließlich unter:

    vendor/

Aktuell:

| Framework | Projektpfad | Stand |
|---|---|---:|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD-i18n | `vendor/ctld/CTLD-i18n.lua` | geladen |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Regeln:

- Vendor-Dateien werden nicht verändert.
- Eigene Kampagnenlogik wird nicht in Vendor-Dateien geschrieben.
- Projektfixes werden nicht als lokale Vendor-Patches versteckt.
- Frameworks bleiben austauschbare Ausführungsschichten.

---

## 10. DCS-Ladefolge

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

Die sichere Einzeldatei-Ladung über:

    DO SCRIPT FILE

bleibt aktueller Standard.

---

## 11. Core Layer

Pfad:

    src/core/

Aktive Dateien:

    tc_config.lua
    tc_logger.lua
    tc_state.lua
    tc_utils.lua
    tc_scheduler.lua

Aufgaben:

- zentrale Konfiguration
- Logging
- gemeinsamer State
- Utility-Funktionen
- Scheduler-Grundlage
- Modulstatus
- Featurestatus
- gemeinsame Konstanten

Grundregel:

Core stellt Infrastruktur bereit.

Core soll keine fachlichen Kampagnenentscheidungen erzwingen.

---

## 12. State-Modell

Zentraler State:

    TC.State
    TC.state

Aktuelle Bereiche umfassen unter anderem:

    State.Core
    State.Modules
    State.Features
    State.Bases
    State.Zones
    State.Campaign
    State.Logistics
    State.Missions
    State.AI
    State.UI
    State.Persistence

State-Regeln:

- Fachmodule sind Eigentümer ihres State-Bereichs.
- Andere Systeme lesen Daten über definierte Tabellen oder APIs.
- Framework-Runtime wird nicht zum primären Campaign-State.
- State muss grundsätzlich persistierbar bleiben.
- Runtime-only-Daten und persistierbarer State müssen getrennt bleiben.

---

## 13. Mission-State-Dictionaries

Mission-Collections sind String-keyed Lua-Dictionaries.

Dazu gehören:

    State.Missions.available
    State.Missions.active
    State.Missions.completed
    State.Missions.failed
    State.Missions.expired
    State.Missions.cancelled

Deshalb ist:

    #table

für deren Anzahl nicht autoritativ.

Korrekte Zählung erfolgt über:

    pairs()

beziehungsweise pairs-basierte Hilfsfunktionen.

Der frühere Verdacht eines Mission-Record-Verlusts wurde am 2026-09-12 widerlegt.

Es gingen keine Mission Records verloren.

Der tatsächliche Fehler lag in einer falschen Count-Auswertung in:

    src/core/tc_state.lua

Dieser Fehler wurde behoben und regressionsgetestet.

---

## 14. Dirty-State-Architektur

Persistence-relevanter Dirty-State liegt zentral unter:

    TC.State.Persistence

Relevante Felder:

    dirty
    dirtyReason
    dirtyAt

Fachliche Mutationen verwenden:

    TC.State.markDirty(reason)

Reads und echte No-Ops sollen:

    keinen Dirty-State erzeugen

Architekturregel:

    echte persistierbare Mutation
    -> Dirty

und:

    reiner Read
    -> kein Dirty

sowie:

    echter No-Op
    -> kein Dirty

Priority 3 hat diese Semantik für die relevanten aktiven Systeme überprüft.

---

## 15. Priority 3

Status:

    ABGESCHLOSSEN IM DOKUMENTIERTEN UMFANG

Abschlussdatum:

    2026-09-21

Geprüft:

    LogisticsDelivery
    FobSystem
    MissionGenerator
    AICapManager

Ergebnis:

### LogisticsDelivery

Version:

    v0.2.1

Read-Neutrality:

    bestanden

Positive Mutation:

    createDelivery()
    -> dirtyReason=logistics_delivery_created

### FobSystem

Version:

    v0.2.1

Read-Neutrality:

    bestanden

Positive Mutation:

    FobSystem.create()
    -> dirtyReason=fob_created

### MissionGenerator

Version:

    v0.2.3

Audit:

    kein aktuell aktiver Missing-Dirty-Bug

### AICapManager

Version:

    v0.2.1

Read-Neutrality:

    bestanden

Positive Mutation:

    setCapStatus()
    -> dirtyReason=ai_cap_record_changed

Priority 3 wird ohne neuen technischen Anlass nicht vollständig wiederholt.

---

## 16. World Layer

Pfad:

    src/world/

Aktive Dateien:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

Aufgabe:

- reale DCS-Welt erfassen
- Airbase-like Objects klassifizieren
- relevante Kampagnenobjekte ableiten
- Positionsdaten bereitstellen
- Owner-/Coalition-Daten erfassen
- Campaign-, Logistics-, Missions- und AI-Layer versorgen

World erkennt.

World entscheidet nicht eigenständig über strategische Kampagnenaktionen.

---

## 17. Airbase Scanner

Datei:

    src/world/tc_airbase_scanner.lua

Version:

    v0.2.2

Status:

    bestanden

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

Wichtig:

Nicht alle 225 Airbase-like Objects sind echte strategische Kampagnenobjekte.

Die Klassifikation filtert die Rohdaten.

---

## 18. ZoneFactory

Datei:

    src/world/tc_zone_factory.lua

Version:

    v0.2.0

Status:

    bestanden

Bestätigte Werte:

    relevante Kampagnenzonen: 46
    skipped airbase-like objects: 179
    captureZones: 32
    missionZones: 32
    logisticsZones: 46
    startBaseZones: 1

ZoneFactory erzeugt virtuelle Kampagnenzonen aus klassifizierten World-Daten.

Diese Zonen sind Theater-Command-State.

Sie sind nicht automatisch identisch mit physisch im Mission Editor angelegten Trigger-Zonen.

---

## 19. Campaign Layer

Pfad:

    src/campaign/

Aktive Dateien:

    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua

Campaign verwaltet strategischen Zustand.

Aktuelle Kernbereiche:

- Ownership
- Capture
- Mission Effects
- Persistence

---

## 20. CaptureSystem

Datei:

    src/campaign/tc_capture_system.lua

Version:

    v0.2.2

Status:

    bestanden

Bestätigte Startwerte:

    eligibleBases: 32
    eligibleZones: 32
    nonCaptureBases: 193
    nonCaptureZones: 14
    pressureRecords: 32
    progressRecords: 32

Bestätigte Funktionen:

- Capture Eligibility
- Capture Pressure
- Capture Progress
- Capture Ready
- Mission Effect Processing
- Ownership Apply
- linked Airbase Sync
- Pressure Reset
- Getter Read-Neutrality
- Ownership No-Op

Bestätigter Pfad:

    Mission Completion
    -> Mission Effects
    -> Capture Pressure
    -> Capture Progress
    -> Capture Ready
    -> Apply
    -> Ownership Update
    -> linked Airbase Ownership
    -> Persistence

Mission Failure:

    erzeugt aktuell bewusst keinen Capture Pressure

---

## 21. PersistenceSystem

Datei:

    src/campaign/tc_persistence_system.lua

Version:

    v0.2.6

Status:

    technische Persistence bestanden
    produktiver Restore deaktiviert

Bestätigt:

- Sandbox-Prüfung
- Dateischreiben
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

    erster Lauf nach 20 Sekunden
    danach alle 120 Sekunden

Verbindlich:

    productiveRestore=false

---

## 22. Persistence-Architektur

Persistence ist ein Querschnittssystem.

Es ist keine fachlich höhere Kampagnenschicht.

Grundpfad:

    Fachsystem mutiert State
    -> markDirty()
    -> Persistence erkennt dirty
    -> Snapshot
    -> Write
    -> Read-back
    -> Compile
    -> Evaluate
    -> Validation
    -> Dirty nur bei unverändertem ursprünglichem Dirty-State löschen

Bei:

    dirty=false

wird nicht geschrieben.

Ergebnis:

    SKIPPED

Bei kontrolliertem Fehler:

    FAILED

Dirty bleibt dabei erhalten.

---

## 23. Produktiver Restore

Technische Importfähigkeit:

    bestanden

Produktiver Missionsstart-Restore:

    deaktiviert

Priority 3 ist nicht mehr der offene Blocker.

Vor `productiveRestore=true` sind weiterhin notwendig:

- Restore-/Initialisierungsreihenfolge
- Save-Versionierung
- Save-Kompatibilitätsstrategie
- Framework-Rekonstruktionsregeln
- kontrollierter End-to-End-Restore-Test

Langfristige Zielreihenfolge:

    Mission startet
    -> Save prüfen
    -> Save validieren
    -> State importieren
    -> Fachsysteme auf restored State setzen
    -> Framework-Runtime kontrolliert rekonstruieren
    -> Scheduler starten
    -> Kampagne fortsetzen

---

## 24. Logistics Layer

Pfad:

    src/logistics/

Aktive Dateien:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

Logistics verwaltet strategischen Versorgungsstate.

CTLD wird später reale Ausführung übernehmen.

---

## 25. LogisticsDelivery

Datei:

    src/logistics/tc_logistics_delivery.lua

Version:

    v0.2.1

Status:

    state-first bestanden
    Read-Neutrality bestanden

Bestätigte Werte:

    logistics hubs: 46
    blue hubs: 7
    red hubs: 24
    neutral hubs: 15
    active hubs: 31
    limited hubs: 15
    locked hubs: 0

Architektur:

- LogisticsDelivery hält Theater-Command-Logistics-State.
- CTLD ist nicht Eigentümer dieses langfristigen Campaign-State.
- reale Transporte sind noch nicht produktiv verdrahtet.

---

## 26. FobSystem

Datei:

    src/logistics/tc_fob_system.lua

Version:

    v0.2.1

Status:

    state-first bestanden
    Read-Neutrality bestanden

Bestätigt:

    FOB candidates: 6
    stored candidates: 6
    auto-planned FOBs: 2
    skipped candidates: 4
    Blue FOBs: 2

FOBs:

    FOB Ercan
    FOB Gecitkale

Status:

    UNDER_CONSTRUCTION

Diese FOBs sind aktuell:

    Campaign State

Sie sind noch keine real durch CTLD gebauten FOBs.

---

## 27. Missions Layer

Pfad:

    src/missions/

Aktive Datei:

    src/missions/tc_mission_generator.lua

MissionGenerator erzeugt Kampagnenaufträge aus State-Daten.

MissionGenerator soll nicht selbst alle realen DCS-Ausführungen übernehmen.

Mission Effects werden für Fachsysteme vorbereitet.

---

## 28. MissionGenerator

Datei:

    src/missions/tc_mission_generator.lua

Version:

    v0.2.3

Status:

    bestanden

Bestätigt:

    mission candidates: 78
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 68

Aktuelle Missionstypen umfassen:

- RECON
- STRIKE
- SEAD
- DEAD
- CAS
- INTERDICTION
- ESCORT
- CAP
- LOGISTICS
- FOB_SUPPORT
- AIRBASE_ATTACK
- IADS_SUPPRESSION

Bestätigte Statuswechsel:

    AVAILABLE -> ACTIVE
    ACTIVE -> COMPLETED
    ACTIVE -> FAILED

Bestätigt:

    COMPLETED
    -> Capture Effect

und:

    FAILED
    -> aktuell kein Capture Pressure

Noch offen:

- CANCELLED praktisch testen
- EXPIRED praktisch testen
- automatische DCS-Outcome-Auswertung
- produktive Logistics Effects
- produktive AI Effects
- produktive IADS Effects
- reale Framework-Ausführung

---

## 29. AI Layer

Pfad:

    src/ai/

Aktive Datei:

    src/ai/tc_ai_cap_manager.lua

Perspektivisch können weitere fachliche AI-Module hinzukommen.

Beispielsweise:

    tc_ai_director.lua
    tc_ai_gci_manager.lua
    tc_ai_counterattack.lua

Diese Dateien werden erst angelegt, wenn der konkrete fachliche Bedarf besteht.

---

## 30. AICapManager

Datei:

    src/ai/tc_ai_cap_manager.lua

Version:

    v0.2.1

Status:

    state-first bestanden
    Read-Neutrality bestanden

Bestätigt:

    cap zone candidates: 31
    CAP zones: 12
    CAP requests: 12

Noch keine:

    realen MOOSE-CAP-Flüge

MOOSE wird später Execution Layer.

AICapManager bleibt Intent-/State-Layer.

---

## 31. `reactToActiveMissions()`

Diese Funktion wurde separat auditiert.

Aktuell:

    keine produktive Call-Site

Sie wird derzeit nicht durch:

- `start()`
- Scheduler
- `main.lua`
- `loader.lua`
- F10
- andere aktive produktive Pfade

aufgerufen.

Ein potenzieller Dirty-Randfall wurde für eine spätere Verdrahtung dokumentiert.

Status:

    latent
    aktuell kein Runtime-Persistence-Bug

Erneut prüfen:

    sobald die Funktion produktiv in den Lifecycle eingebunden wird

---

## 32. IADS Layer

Pfad:

    src/iads/

Aktuell:

- Skynet IADS Vendor geladen
- eigenes produktives Theater-Command-IADS-System noch nicht aktiv

Ziel:

Theater Command verwaltet später:

- IADS-State
- Netzwerke
- strategische Relevanz
- Missionsverknüpfung
- Beschädigung
- Reparatur

Skynet führt reale IADS-Funktion aus.

---

## 33. UI Layer

Pfad:

    src/ui/

Aktive Datei:

    src/ui/tc_f10_menu.lua

Version:

    v0.2.3

Status:

    bestanden

Commands:

    33

Unter anderem vorhanden:

- Mission Details
- Mission Activation
- Mission Completion
- Mission Failure
- Campaign Status
- Capture Status
- Capture Ready
- Capture Apply
- Pressure Contested
- Logistics Status
- FOB Status
- AI CAP Status

Architekturregel:

UI:

- macht State sichtbar
- ruft definierte State-Funktionen auf
- dient aktuell auch als Testzugang

UI:

- soll keine versteckte Framework-Orchestrierung enthalten
- soll nicht zum Hauptmotor der Kampagne werden

---

## 34. Debug Layer

Pfad:

    src/debug/

Aktuell:

    vorbereitet
    noch nicht produktiv implementiert

Debug soll später unter anderem bereitstellen:

- State Dumps
- Airbase Reports
- Zone Reports
- Capture Reports
- Logistics Reports
- Mission Reports
- AI Reports
- IADS Reports

Regel:

    Debug macht State sichtbar.
    Debug verändert nicht versteckt produktiven State.

---

## 35. Aktuelle modulübergreifende Pipeline

Bestätigter erfolgreicher Pfad:

    Mission Details
    -> Mission Activation
    -> Mission Completion
    -> Mission Effect Preparation
    -> CaptureSystem Effect Processing
    -> Capture Pressure
    -> Capture Progress
    -> Capture Ready
    -> F10 Visibility
    -> Capture Ready Apply
    -> Zone Ownership
    -> linked Airbase Ownership
    -> Background Persistence

Bestätigter Testfall:

    MISSION_2
    -> ZONE_AIRBASE_ABU_AL_DUHUR
    -> BLUE pressure 105
    -> progress 100 %
    -> ready=1

Failure-Pfad:

    Mission Activation
    -> Mission Failure
    -> Failure Effect
    -> CaptureSystem applied=0
    -> kein Capture Pressure
    -> Background Persistence

---

## 36. CTLD-Architektur

CTLD:

    vendor/ctld/CTLD.lua
    Version 1.6.1

Status:

    Vendor geladen
    Framework-PoC für KI-Truppentransport bestanden
    produktive Theater-Command-Integration offen

CTLD ist:

    Execution Layer

Theater Command bleibt:

    Decision Layer
    Campaign State Owner

---

## 37. CTLD Runtime-Zonenregistrierung

Am 2026-09-29 wurde bestätigt:

Nach der CTLD-Initialisierung können normalisierte Einträge ergänzt werden in:

    ctld.pickupZones
    ctld.dropOffZones

Getesteter Pickup:

    CTLD_PICKUP_BLUE_AKROTIRI_01

Getesteter technischer Dropoff:

    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01

Getesteter Pickup-Eintrag:

    { "CTLD_PICKUP_BLUE_AKROTIRI_01", -1, 10000, 1, 2 }

Getesteter Dropoff-Eintrag:

    { "CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01", -1, 2, 1 }

Eine erneute Ausführung von:

    ctld.initialize()

war dafür nicht erforderlich.

---

## 38. CTLD KI-Transporterregistrierung

Testunit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Für den getesteten AI-Pfad musste die Unit in:

    ctld.transportPilotNames

registriert sein.

Vor Registrierung:

    108 Einträge

Nach temporärer idempotenter Registrierung:

    109 Einträge

Testunit:

    genau einmal vorhanden

Source-Audit:

    ctld.checkAIStatus()

iteriert für diesen Pfad über:

    ctld.transportPilotNames

Produktive Architektur muss diese Registrierung später automatisch und idempotent durchführen.

---

## 39. CTLD-KI-Truppentransport-PoC

Testdatum:

    2026-09-29

Testmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz

SHA-256 vor Test:

    5F0D89DF744A7083401E36713B148BD21813FF187CC36EC1F088507163458C57

Gruppe:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01

Unit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Luftfahrzeug:

    Mi-8

Bestätigter Ablauf:

    Aktivierung
    -> automatischer Pickup
    -> Taxi
    -> Takeoff
    -> Transit
    -> Off-Airfield-Landung
    -> automatischer Dropoff
    -> reale Blue-Bodengruppe

Pickup:

    16 Soldaten

Pickup-Counter:

    10000 -> 9999

Dropoff-Gruppe:

    Dropped Group 2

Group-ID:

    70001

Stärke:

    16 x Soldier M249

---

## 40. Off-Airfield-Landung

Erfolgreicher gespeicherter Missionsaufbau:

    normaler Turning Point
    +
    Perform Task -> Land

Dropoff-Zentrum:

    x / North = -29249.110954281
    z / East  = -271836.070539260

Wegpunkt:

    100 m BARO
    30 m/s

Land Task:

    duration=300
    durationFlag=true

Bestätigte minimale Entfernung zum Zentrum:

    ungefähr 1.06 m

Für diesen getesteten Truppentransport war kein FARP erforderlich.

Der zuvor verwendete ungebundene:

    Land / Landing

Waypoint hatte keinen vollständigen erfolgreichen Transportzyklus ergeben.

Der erfolgreiche neue Aufbau isoliert die Landemethode als wichtigen Unterschied.

Die genaue Ursache des vorherigen Turnback-Verhaltens ist dadurch nicht vollständig bewiesen.

---

## 41. CTLD-Ergebnisgrenze

Der PoC beweist für den getesteten Aufbau:

- Runtime-Zonenregistrierung funktioniert.
- KI-Transporterregistrierung funktioniert.
- automatischer Pickup funktioniert.
- DCS-AI führt den Transport durch.
- Off-Airfield-Landung funktioniert.
- automatischer Dropoff funktioniert.
- reale Bodengruppe entsteht.

Der PoC beweist noch nicht:

- produktive Theater-Command-Auftragserzeugung
- LogisticsDelivery-Rückkopplung
- FobSystem-Rückkopplung
- CTLD-Crates
- Sling Load
- Supply Cargo
- Engineering Cargo
- Repair Cargo
- Fuel Cargo
- Ammo Cargo
- FOB-Bau
- Capture-Effekt aus Logistik
- AI-Director-Verknüpfung
- CTLD-Restore
- Multiplayer

---

## 42. CTLD `RepackCommandsPath`

Beim Grounded-Übergang des registrierten KI-Transporters wurde beobachtet:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Kontext:

    updateRepackMenu
    updateRepackMenuOnlanding

Source-Analyse legt nahe:

- der registrierte KI-Transporter erreicht einen CTLD-Landing-/Menüpfad,
- `ctld.vehicleCommandsPath[_unitName]` ist bei einer reinen KI-Unit nicht zwangsläufig vorhanden,
- daraus kann ein nil `RepackCommandsPath` entstehen.

Pickup und Dropoff wurden trotzdem abgeschlossen.

Nicht bewiesen:

    dass der Fehler langfristig harmlos ist

Ebenfalls noch nicht direkt bewiesen:

    ob der unbehandelte Fehler den betreffenden Scheduler dauerhaft beendet

Diese Schedulerwirkung bleibt eine technisch begründete Vermutung.

Verbindlich:

    vendor/ctld/CTLD.lua wird nicht gepatcht.

---

## 43. Zukünftige produktive CTLD-Architektur

Die produktive Integration muss mindestens folgende Verantwortlichkeiten trennen:

    Campaign Decision
    -> Transportauftrag
    -> Transporter auswählen
    -> CTLD-Zonen konfigurieren
    -> Transporter bei CTLD registrieren
    -> DCS Route / Task
    -> Pickup
    -> Transport
    -> Landung
    -> Dropoff
    -> Ergebnis validieren
    -> Theater-Command-State mutieren
    -> Dirty
    -> Persistence

Vor dem ersten produktiven Code-Schritt muss entschieden werden:

- welche fachliche `src/`-Komponente die CTLD-Konfiguration übernimmt
- ob eine bestehende fachliche Datei erweitert wird
- oder ob eine neue task-orientierte Datei nötig ist

Keine generische:

    tc_ctld.lua

oder:

    tc_ctld_bridge.lua

---

## 44. Framework-Integrationsstrategie

Aktuelle Zuordnung:

| Funktion | Execution Layer |
|---|---|
| Utility / DCS-Helfer | MIST nach Bedarf |
| CAP / Strike / SEAD / DEAD / CAS | MOOSE |
| Truppentransport / Cargo / FOB | CTLD |
| SAM / EWR / IADS | Skynet IADS |
| Kampagnenentscheidung | Theater Command |
| State | Theater Command |
| Persistence | Theater Command |
| F10 / UI | eigene Lua-Logik + native DCS-Funktionen |

Frameworks werden nach Bedarf innerhalb fachlicher Module verwendet.

Die Framework-Namen definieren nicht die eigene Source-Struktur.

---

## 45. Mission-Editor-Architektur

Aktuelle DEV-Mission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_DEV.miz

Aktuelle isolierte CTLD-Testmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz

Mission Editor stellt bereit:

- Karte
- Koalitionen
- Client-Slots
- Gruppen
- Templates
- Trigger
- Trigger-Zonen
- Wegpunkte
- native Tasks
- spätere Statics/FARPs
- Embedded Lua Resources

Große Kampagnenlogik bleibt in Lua.

---

## 46. Testmission vs. DEV-Mission

Verbindlich:

    Testmission != DEV-Mission

Isolierte Framework-Experimente werden nicht automatisch in die DEV-Mission übernommen.

Ablauf:

    Testidee
    -> isolierte .miz
    -> strukturierter Audit
    -> DCS Runtime-Test
    -> Ergebnisbewertung
    -> erst danach kontrollierte Übernahme

Diese Trennung schützt:

- DEV-Mission
- produktive Embedded-Ressourcen
- Persistence
- bestehende Regressionen

---

## 47. Persistence-Grenze zu Frameworks

Theater Command soll langfristigen Campaign-State speichern.

Framework-Runtime soll nicht blind serialisiert werden.

Beispiel CTLD:

Nach einer erfolgreichen Lieferung kann Theater Command später speichern:

- Auftrag
- Empfänger
- Cargo-Typ
- Menge
- Erfolg
- Zeitpunkt
- State-Effekt

Nicht zwangsläufig:

- vollständige interne CTLD-Tabellen
- Scheduler
- Menüpfade
- temporäre DCS-Objektreferenzen

Nach Restore muss Framework-Runtime aus Theater-Command-State rekonstruiert werden.

---

## 48. Produktive Save-Datei

Aktuell:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Bestätigter Stand nach CTLD-Test vom 2026-09-29:

    Größe: 3094967 Bytes

SHA-256:

    C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596

Der isolierte CTLD-Test hat diesen produktiven Save nicht verändert.

---

## 49. Tooling-Architektur

Seit 2026-09-29 ist die Entwicklung klar nach Werkzeugrollen getrennt.

Diese Werkzeuge sind:

    Entwicklungs- und Diagnosewerkzeuge

Sie sind nicht:

    Runtime-Abhängigkeiten der fertigen Kampagne

---

## 50. ChatGPT

Rolle:

- Projektkoordination
- Architektur
- GitHub-Audit
- Dokumentationsführung
- Testplanung
- Ergebnisbewertung
- Definition des nächsten Einzelschritts
- Vorbereitung präziser Arbeitsaufträge

ChatGPT ist nicht die Instanz, die tatsächliches DCS-Runtime-Verhalten allein beweist.

---

## 51. Claude + dcs-mcp

Version:

    dcs-mcp 0.9.11

Terrain Store:

    C:\Users\Paul\AppData\Local\dcs-mcp\terrain

Syria-Terrain:

    installiert

Rolle:

- `.miz` strukturiert analysieren
- Mission-Editor-Inhalte prüfen
- Gruppen prüfen
- Units prüfen
- Trigger-Zonen prüfen
- Wegpunkte prüfen
- Tasks prüfen
- Airbase-Zuordnungen prüfen
- Mission gezielt bearbeiten
- gespeicherte `.miz` erneut auditieren

dcs-mcp ist für Mission-Editor-/`.miz`-Arbeit aktuell das bevorzugte Werkzeug.

Es ersetzt keinen DCS-Runtime-Test.

---

## 52. Claude Code + DCS-SMS

DCS-SMS:

    0.27.2

Hook:

    me-bridge-0.27.2

Verifiziertes Installationsverzeichnis:

    C:\Tools\dcs-sms

Claude-Code-Skill:

    C:\Users\Paul\.claude\skills\dcs-sms\SKILL.md

Rolle:

- Mission-Editor-Status
- laufende DCS-Runtime
- Runtime-Lua
- Theater-Command-Live-State
- CTLD-Live-State
- Unit-State
- Position
- Geschwindigkeit
- Grounded-/Airborne-State
- Logs
- Runtime-Regressionen

DCS-SMS ist kein Theater-Command-Framework.

---

## 53. GitHub

GitHub ist:

    Source of Truth

GitHub hält:

- eigene Lua-Source
- Dokumentation
- Architektur
- Roadmap
- Tasks
- Changelog
- Naming
- Styleguide
- Vendor-Versionen
- bestätigte Testergebnisse

Ein Chatstand ist nicht autoritativer als ein neuerer GitHub-Stand.

---

## 54. DCS

DCS selbst ist die autoritative Instanz für reales Simulatorverhalten.

Nur DCS kann praktisch beweisen:

- AI-Taxi
- Takeoff
- Navigation
- Landung
- Spawn
- CTLD-Pickup
- CTLD-Dropoff
- Scheduler-Verhalten
- tatsächliche AI-Reaktion

Offline-Strukturprüfung und Runtime-Beweis sind unterschiedliche Evidenzarten.

---

## 55. Verbindlicher Entwicklungsworkflow

Für Mission-Editor-/Framework-Arbeit:

    ChatGPT
    -> Ziel und Architekturgrenze definieren

    Claude + dcs-mcp
    -> aktuelle .miz lesen
    -> konkrete Missionsänderung durchführen
    -> gespeicherte Mission auditieren

    Claude Code + DCS-SMS
    -> lokale Runtime diagnostizieren

    DCS
    -> tatsächliches Verhalten beweisen

    ChatGPT
    -> Ergebnis in Projektarchitektur einordnen

    GitHub
    -> bestätigten Stand speichern

Pro Schritt:

    eine konkrete Aufgabe

---

## 56. Embedded-Resource-Architektur

Bei:

    DO SCRIPT FILE

wird die Lua-Datei in die `.miz` eingebettet.

Deshalb:

    GitHub Source geändert
    !=
    .miz automatisch aktualisiert

Embedded Resource Audit vom 2026-09-12:

    13/13 relevante aktive Theater-Command-Ressourcen EXACT_MATCH

Keine aktive Embedded-Runtime-Drift.

Historische verwaiste Persistence-Ressource:

    ResKey_Action_55
    tc_persistence_system.lua

Status:

- nicht referenziert
- nicht geladen
- kein aktueller Blocker
- spätere Cleanup-Aufgabe

---

## 57. DCS-Sandbox

Persistence benötigt direkt:

    io
    lfs

Aktuelle lokale Entwicklungsumgebung:

    os=true
    io=true
    lfs=true
    require=false

DCS-SMS benötigt für die aktuelle Bridge ebenfalls entsprechende lokale Freigaben.

DCS-Updates können:

    MissionScripting.lua

überschreiben.

Danach müssen lokale Sandbox- und Bridge-Voraussetzungen erneut geprüft werden.

---

## 58. Sicherheitsprinzipien

Aktuell verbindlich:

- Vendor-Code bleibt unverändert.
- Keine All-in-one-Dateien.
- Keine versteckte Framework-Ausführung in UI oder Debug.
- Keine produktive Restore-Aktivierung ohne eigenen Test.
- Keine große Paralleländerung mehrerer Systeme.
- State und Framework-Runtime klar trennen.
- Reads dürfen nicht persistierten State verändern.
- No-Ops dürfen keinen Dirty-State erzeugen.
- Framework-Ergebnis vor State-Mutation validieren.
- Persistierbaren State nur über definierte Theater-Command-Schnittstellen verändern.
- Riskante Tests isolieren.
- Produktiven Save bei Bedarf schützen.
- GitHub nur mit bestätigtem Projektstand aktualisieren.

---

## 59. Aktuell verbundene Systeme

Produktiv beziehungsweise state-first miteinander verbunden:

    Airbase Scanner
    -> ZoneFactory

    ZoneFactory
    -> CaptureSystem

    ZoneFactory
    -> LogisticsDelivery

    LogisticsDelivery
    -> FobSystem

    Logistics / FOB
    -> MissionGenerator Candidate State

    MissionGenerator Completion
    -> CaptureSystem

    CaptureSystem
    -> Ownership State

    Fachliche Mutationen
    -> Persistence Dirty State

    F10Menu
    -> kontrollierte State-Funktionen

---

## 60. Noch nicht produktiv verbundene Systeme

Noch offen:

    CTLD
    -> LogisticsDelivery

    CTLD
    -> FobSystem

    MissionGenerator
    -> reale CTLD-Operation

    MissionGenerator
    -> reale MOOSE-Operation

    MissionGenerator
    -> produktive Skynet-Wirkung

    AICapManager
    -> reale MOOSE CAP

    AI Director
    -> Gesamtstrategie

    Logistics
    -> Capture

    Ground Campaign
    -> CAS

    Persistence Restore
    -> Framework-Rekonstruktion

---

## 61. Aktueller nächster Architekturabschnitt

Priority 3 ist abgeschlossen.

Der CTLD-KI-Truppentransport-PoC ist bestanden.

Der nächste Architekturabschnitt ist:

    Priority 4 – produktive CTLD-Integration vorbereiten

Nicht sofort:

- neue generische CTLD-Datei anlegen
- CTLD-Vendor patchen
- Crates implementieren
- produktiven Restore aktivieren
- MOOSE CAP parallel integrieren

Zuerst muss die Integrationsgrenze source-backed festgelegt werden.

---

## 62. Fragen vor dem ersten produktiven CTLD-Code

Zu beantworten:

1. Welche fachliche Theater-Command-Komponente besitzt den Transportauftrag?
2. Welche Komponente registriert Pickup-/Dropoff-Zonen?
3. Welche Komponente registriert KI-Transporter?
4. Wann erfolgt diese Registrierung?
5. Wie bleibt sie idempotent?
6. Wie wird der Transporter-Lifecycle behandelt?
7. Wie wird ein Transportauftrag repräsentiert?
8. Wie wird Pickup erkannt?
9. Wie wird Erfolg des Dropoffs erkannt?
10. Wie werden Fehler erkannt?
11. Wie wird `RepackCommandsPath` ohne Vendor-Patch behandelt?
12. Welche CTLD-Daten bleiben runtime-only?
13. Welche Ergebnisse werden in `TC.State` geschrieben?
14. Welche Mutationen setzen Dirty?
15. Was muss später nach Restore rekonstruiert werden?

Erst danach wird die nächste konkrete Source-Datei festgelegt.

---

## 63. Perspektivische Carrier-Architektur

Später vorgesehen:

- Supercarrier
- Carrier Task Group
- Carrier Air Wing
- F/A-18C
- F-14
- weitere Carrier-fähige Flugzeuge
- Carrier CAP
- Fleet Defense
- Strike
- Escort
- Carrier Logistics

Der Carrier soll später Teil der operativen Kampagne sein.

Nicht nur statische Kulisse.

Diese Architektur ist Zukunftsplanung und noch nicht produktiv implementiert.

---

## 64. Perspektivische Ground-/CAS-Architektur

Später vorgesehen:

    Ground Operation
    -> Enemy Contact
    -> CAS Need
    -> AI Director / MissionGenerator
    -> verfügbares Air Asset
    -> CAS Mission
    -> Ergebnis
    -> Ground State

Bodentruppen sollen später nicht nur statisch existieren.

Sie sollen Bestandteil der Kampagnenlogik werden.

---

## 65. Architekturabschlussstand

Stand:

    2026-09-29

State-first Kern:

    tragfähig und praktisch bestätigt

Priority 3:

    abgeschlossen im dokumentierten Umfang

Persistence:

    v0.2.6
    dirty-aware
    produktiver Restore deaktiviert

Logistics:

    LogisticsDelivery v0.2.1
    FobSystem v0.2.1

Missions:

    MissionGenerator v0.2.3
    10 Mission Records

AI:

    AICapManager v0.2.1
    12 CAP Requests
    noch keine realen MOOSE-CAP-Flüge

CTLD:

    1.6.1
    KI-Truppentransport-PoC bestanden
    produktive TC-Integration offen

Tooling:

    ChatGPT
    -> Projektkoordination / Architektur

    Claude + dcs-mcp
    -> .miz / Mission Editor

    Claude Code + DCS-SMS
    -> lokale Runtime-Diagnose

    DCS
    -> autoritativer Runtime-Beweis

    GitHub
    -> Source of Truth

Aktueller Architekturübergang:

    state-first Kampagnenkern
    +
    stabile dirty-aware Persistence
    +
    abgeschlossene Priority-3-Dirty-Coverage
    +
    bestandener CTLD-KI-Transport-PoC
    ->
    kontrollierte produktive CTLD-Integration
