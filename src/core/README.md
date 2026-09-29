# Core – Theater Command DCS

## Verbindlicher Stand — 2026-09-29

Diese Datei beschreibt den Core-Bereich von **Theater Command DCS**.

Projekt:

    Theater Command DCS

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Aktueller Entwicklungsbereich:

    Priority 4 – produktive CTLD-Integration vorbereiten

Priority 3:

    abgeschlossen im dokumentierten Umfang seit 2026-09-21

Verbindlich:

    productiveRestore=false

---

## 1. Zweck des Core-Bereichs

`src/core/` ist die technische Grundschicht von Theater Command DCS.

Der Core stellt gemeinsame Infrastruktur bereit für:

- Konfiguration
- Logging
- globalen Theater-Command-State
- Utility-Funktionen
- Scheduler-Grundfunktionen
- Modulstatus
- Featurestatus
- Dirty-State
- defensive Initialisierung

Der Core enthält keine eigentliche strategische Kampagnenentscheidung.

Fachlogik liegt in den jeweiligen Fachbereichen unter:

    src/world/
    src/campaign/
    src/logistics/
    src/missions/
    src/ai/
    src/iads/
    src/ui/
    src/debug/

---

## 2. Grundarchitektur

Theater Command DCS folgt:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis / Source of Truth
    DCS Runtime = autoritativer Verhaltensbeweis

Der Core unterstützt diese Architektur technisch.

Er ist nicht:

- MissionGenerator
- CaptureSystem
- Logistics-System
- AI Director
- IADS-System
- UI
- Framework-Wrapper

---

## 3. Aktive Core-Dateien

Aktiv:

    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
    src/core/tc_utils.lua
    src/core/tc_scheduler.lua

Diese Dateien sind Teil der produktiven Theater-Command-Ladekette.

---

## 4. Architekturregel für Dateinamen

Externe Frameworks liegen unter:

    vendor/

Eigene Theater-Command-Logik liegt unter:

    src/

Der Core wird nach Theater-Command-Aufgaben organisiert.

Nicht gewünscht:

    src/core/tc_moose.lua
    src/core/tc_mist.lua
    src/core/tc_ctld.lua
    src/core/tc_ctld_bridge.lua
    src/core/tc_skynet.lua
    src/core/tc_framework_wrapper.lua
    src/core/tc_all_in_one.lua

Korrekte Core-Dateien:

    tc_config.lua
    tc_logger.lua
    tc_state.lua
    tc_utils.lua
    tc_scheduler.lua

Framework-spezifische Ausführung wird nicht als generischer Core-Wrapper gebaut.

---

## 5. `tc_config.lua`

Datei:

    src/core/tc_config.lua

Aufgabe:

    zentrale Theater-Command-Konfiguration

Typische Verantwortlichkeiten:

- Projektname
- Kampagnenname
- Map
- Blue-Startbasis
- Feature-Schalter
- Debug-Schalter
- gemeinsame Standardwerte

Aktueller Kampagnenkontext:

    Project: Theater Command DCS
    Campaign: Operation Levant Reclamation
    Map: Syria
    Blue Start: Akrotiri

Nicht Aufgabe von `tc_config.lua`:

- Airbases scannen
- Zonen erzeugen
- Capture berechnen
- Missionen erzeugen
- AI steuern
- CTLD ausführen

---

## 6. `tc_logger.lua`

Datei:

    src/core/tc_logger.lua

Aufgabe:

    einheitliches Logging

Wichtige Funktionen:

- Info
- Warning
- Error
- Debug
- Modulpräfixe
- Versionsmarker
- Runtime-Diagnose

Projektpräfix:

    [TC]

Logging ist besonders wichtig, weil DCS-Runtime und `dcs.log` zentrale technische Evidenz liefern.

Aktive Lua-Module sollen beim Laden ihre Version eindeutig sichtbar machen.

---

## 7. `tc_state.lua`

Datei:

    src/core/tc_state.lua

Aufgabe:

    zentraler Theater-Command-State

Zentrale Projekttabelle:

    TC

State:

    TC.State

beziehungsweise kompatibler Alias:

    TC.state

Fachmodule speichern darin ihren Kampagnenzustand.

Der State soll:

- nachvollziehbar
- modular
- persistierbar
- framework-unabhängig

bleiben.

Kurzlebiger Vendor-Runtime-State soll nicht ohne fachliche Abstraktion zum langfristigen Campaign-State werden.

---

## 8. Wichtige State-Bereiche

Aktuell beziehungsweise vorbereitet sind unter anderem:

    State.Core
    State.Modules
    State.Features
    State.World
    State.Bases
    State.Zones
    State.Campaign
    State.Logistics
    State.Missions
    State.AI
    State.IADS
    State.UI
    State.Persistence
    State.Debug

Nicht jeder Bereich besitzt bereits ein vollständig produktives Fachsystem.

Beispiel:

    State.IADS

ist vorbereitet.

Ein produktives Theater-Command-IADS-System existiert noch nicht.

---

## 9. Mission-State-Dictionaries

Mission-Collections werden nach Mission Key gespeichert.

Relevante Collections:

    State.Missions.available
    State.Missions.active
    State.Missions.completed
    State.Missions.failed
    State.Missions.expired
    State.Missions.cancelled

Diese Tabellen sind:

    String-keyed Lua-Dictionaries

Beispiel:

    MISSION_1
    MISSION_2
    MISSION_3

Deshalb ist:

    #table

für diese Collections keine verlässliche Zählmethode.

Korrekte fachliche Zählung erfolgt über:

    pairs()

oder entsprechende pairs-basierte Hilfsfunktionen.

---

## 10. Auflösung des früheren Mission-Record-Verdachts

Der frühere Verdacht, MissionGenerator würde seine Mission Records verlieren, wurde am:

    2026-09-12

widerlegt.

Live bestätigt:

    statistics.available = 10
    pairs()-Count = 10
    #available = 0

Die Records waren vorhanden.

Der Fehler lag in einer falschen Count-Auswertung in:

    State.summary()

beziehungsweise der Verwendung von:

    #

auf String-keyed Dictionaries.

Ergebnis:

    kein bestätigter Mission-Record-Datenverlust

MissionGenerator benötigte dafür keinen Record-Loss-Fix.

---

## 11. Dirty-State

Persistence-relevanter Dirty-State liegt zentral unter:

    TC.State.Persistence

Relevante Felder:

    dirty
    dirtyReason
    dirtyAt

Fachliche persistierbare Mutationen verwenden:

    TC.State.markDirty(reason)

Dirty-State kann über:

    TC.State.clearDirty()

nach erfolgreicher Persistence-Verifikation gelöscht werden.

---

## 12. Dirty-Semantik

Verbindliche Regel:

    echte persistierbare Mutation
    -> Dirty

    reiner Read
    -> kein Dirty

    echter No-Op
    -> kein Dirty

Diese Regel wurde inzwischen praktisch für mehrere Fachsysteme überprüft.

Priority 3 diente genau dieser Dirty-Coverage.

---

## 13. Priority 3

Priority 3 wurde am:

    2026-09-21

im dokumentierten Umfang abgeschlossen.

Geprüft:

    LogisticsDelivery
    FobSystem
    MissionGenerator
    AICapManager

Ergebnis:

    LogisticsDelivery v0.2.1
    -> Read-Neutrality bestanden

    FobSystem v0.2.1
    -> Read-Neutrality bestanden

    MissionGenerator v0.2.3
    -> kein aktiver Missing-Dirty-Bug gefunden

    AICapManager v0.2.1
    -> Read-Neutrality bestanden

Priority 3 ist nicht mehr der aktuelle Entwicklungsbereich.

Neue Lifecycle-Pfade werden bei ihrer späteren Aktivierung separat geprüft.

---

## 14. `tc_utils.lua`

Datei:

    src/core/tc_utils.lua

Aufgabe:

    allgemeine technische Hilfsfunktionen

Geeignete Aufgaben:

- sichere Tabellenzugriffe
- Count-Hilfen
- String-Hilfen
- kleine Validierungen
- Koalitionsumwandlungen
- Positionshilfen
- defensive Kopierfunktionen
- nil-sichere Hilfsfunktionen

Nicht in Utils gehören:

- Capture-Fachlogik
- MissionGenerator
- LogisticsDelivery
- FobSystem
- AI-Entscheidungslogik
- CTLD-Orchestrierung
- IADS-Logik

Utility-Code bleibt allgemein.

---

## 15. `tc_scheduler.lua`

Datei:

    src/core/tc_scheduler.lua

Aufgabe:

    gemeinsame Scheduler-/Timer-Grundlage

Mögliche beziehungsweise aktuelle Nutzung:

- verzögerte Aufrufe
- periodische Prüfungen
- spätere AI-Ticks
- spätere Mission-Updates
- technische Scheduler-Kapselung

Der Core-Scheduler trifft keine fachlichen Kampagnenentscheidungen.

Er führt nur zeitgesteuerte Funktionen aus.

Persistence besitzt aktuell seinen bestätigten Background-Autosave-Lifecycle.

---

## 16. Namespace

Zentrale Projekttabelle:

    TC

Fachbereiche hängen sich strukturiert darunter ein.

Beispiele:

    TC.Config
    TC.Logger
    TC.State
    TC.Utils
    TC.Scheduler
    TC.World
    TC.Campaign
    TC.Logistics
    TC.Missions
    TC.AI
    TC.IADS
    TC.UI
    TC.Debug

Nicht parallel neue globale Projektnamespaces einführen.

Der zentrale Namespace bleibt:

    TC

---

## 17. Ladeposition

Vendor-Frameworks werden zuerst geladen.

Danach Core:

    1. src/core/tc_config.lua
    2. src/core/tc_logger.lua
    3. src/core/tc_state.lua
    4. src/core/tc_utils.lua
    5. src/core/tc_scheduler.lua

Danach Fachmodule:

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

Core muss vor allen Fachsystemen verfügbar sein.

---

## 18. Verhältnis zu Vendor-Frameworks

Vendor-Frameworks:

    MIST
    MOOSE
    CTLD
    Skynet IADS

Der Core kann deren Verfügbarkeit unterstützen beziehungsweise dem Loader technische Grundlage bereitstellen.

Der Core:

- verändert keine Vendor-Dateien
- besitzt keinen generischen Framework-Wrapper
- startet keine fachlichen CTLD-Transporte
- startet keine MOOSE-Missionen
- baut keine Skynet-Netzwerke

Framework-Ausführung gehört in die entsprechenden fachlichen Integrationspfade.

---

## 19. Verhältnis zu World

World:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

Aktuell bestätigt:

    Airbase-like Objects: 225
    relevante Kampagnenzonen: 46
    Capture Candidates: 32
    Mission Candidates: 32
    Logistics Candidates: 46

Core stellt Infrastruktur bereit.

World interpretiert die DCS-Kartenwelt.

---

## 20. Verhältnis zu Campaign

Campaign:

    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua

Aktuelle Versionen:

    CaptureSystem v0.2.2
    PersistenceSystem v0.2.6

Capture bestätigt:

    eligibleBases: 32
    eligibleZones: 32
    pressureRecords: 32
    progressRecords: 32

Persistence bestätigt:

- Save
- Read-back
- Compile
- Evaluate
- Validation
- kontrollierter Import
- Background Autosave
- `SAVED`
- `SKIPPED`
- kontrollierter `FAILED`
- Retry

Verbindlich:

    productiveRestore=false

---

## 21. Verhältnis zu Logistics

Logistics:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

Versionen:

    LogisticsDelivery v0.2.1
    FobSystem v0.2.1

Bestätigt:

    Logistics Hubs: 46
    FOB Candidates: 6
    Blue FOBs: 2

FOBs:

    FOB Ercan
    FOB Gecitkale

Core besitzt weder Logistics- noch CTLD-Fachlogik.

---

## 22. Verhältnis zu Missions

MissionGenerator:

    src/missions/tc_mission_generator.lua
    v0.2.3

Bestätigt:

    Mission Candidates: 78
    FOB Support Candidates: 2
    Mission Records: 10

Bestätigte Statuswechsel:

    AVAILABLE -> ACTIVE
    ACTIVE -> COMPLETED
    ACTIVE -> FAILED

Core erzeugt keine Missionen.

Core stellt State- und Utility-Grundlagen bereit.

---

## 23. Verhältnis zu AI

AICapManager:

    src/ai/tc_ai_cap_manager.lua
    v0.2.1

Bestätigt:

    CAP Zone Candidates: 31
    CAP Zones: 12
    CAP Requests: 12

Status:

    state-first bestanden
    Read-Neutrality bestanden

Noch nicht vorhanden:

    reale MOOSE-CAP-Flüge
    vollständiger AI Director

Core trifft keine AI-Entscheidungen.

---

## 24. Verhältnis zu UI

F10Menu:

    src/ui/tc_f10_menu.lua
    v0.2.3

Bestätigt:

    33 Commands

Aktuell bestätigt:

- Mission Visibility
- Mission Details
- Mission Activation
- Mission Completion
- Mission Failure
- Campaign Status
- Capture Status
- Capture Ready
- Pressure Contested
- Capture Ready Apply
- Logistics Status
- FOB Status
- AI CAP Status

Core erzeugt keine F10-Menüs.

UI nutzt Core und Fachsysteme.

---

## 25. Verhältnis zu IADS

Vendor:

    Skynet IADS 3.3.0

Aktuell:

    geladen

Eigener Bereich:

    src/iads/

Produktives eigenes Theater-Command-IADS-Modul:

    noch nicht implementiert

Core stellt dafür später technische Grundlage bereit.

Core initialisiert selbst keine Skynet-IADS-Netzwerke.

---

## 26. Verhältnis zu Debug

Bereich:

    src/debug/

Aktuell:

    vorbereitet
    noch kein produktives eigenes Debug-Modul

Core stellt Logger, State und Utilities für spätere Debug-Funktionen bereit.

Debug soll State sichtbar machen und nicht versteckt verändern.

---

## 27. CTLD im aktuellen Projektstand

CTLD:

    1.6.1

Am 2026-09-29 wurde für einen isolierten getesteten Aufbau ein KI-Truppentransport praktisch vollständig bestätigt.

Bestätigter Pfad:

    Runtime-Zonenregistrierung
    -> Transporterregistrierung
    -> Pickup
    -> Flug
    -> Off-Airfield-Landung
    -> Dropoff
    -> reale Blue-Bodengruppe

Dieser PoC verändert die Core-Verantwortung nicht.

Core wird nicht zum:

    CTLD-Wrapper

Die produktive CTLD-Integration wird fachlich unter geeigneten `src/`-Modulen aufgebaut.

---

## 28. `RepackCommandsPath`

Beim erfolgreichen CTLD-Test wurde genau einmal beim Touchdown beobachtet:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Dieser Fehler liegt im Vendor-Runtime-Kontext.

Verbindlich:

    vendor/ctld/CTLD.lua wird nicht gepatcht.

Eine mögliche Lösung gehört nicht als generischer Fix in:

    src/core/

Die Behandlung beziehungsweise Isolation muss an der fachlich richtigen Integrationsgrenze erfolgen.

---

## 29. State-first-Regel

Der Core unterstützt die state-first-Architektur.

Grundfluss:

    State
    -> Intent
    -> Execution
    -> Result Validation
    -> State Mutation
    -> Dirty
    -> Persistence

Der Core stellt dafür:

- State
- Logging
- Utilities
- Scheduler
- Konfiguration

bereit.

Die Fachsysteme besitzen die fachlichen Entscheidungen.

---

## 30. Aktueller Systemstand

    AirbaseScanner      v0.2.2
    ZoneFactory         v0.2.0
    CaptureSystem       v0.2.2
    PersistenceSystem   v0.2.6
    LogisticsDelivery   v0.2.1
    FobSystem           v0.2.1
    MissionGenerator    v0.2.3
    AICapManager        v0.2.1
    F10Menu             v0.2.3

F10 Commands:

    33

Priority 3:

    abgeschlossen

Produktiver Restore:

    deaktiviert

---

## 31. Core-Testkriterien

Der Core gilt aktuell als bestanden, weil:

- `TC` verfügbar ist.
- `TC.Config` verfügbar ist.
- `TC.Logger` verfügbar ist.
- `TC.State` verfügbar ist.
- `TC.Utils` verfügbar ist.
- `TC.Scheduler` verfügbar ist.
- nachfolgende Fachmodule auf den Core zugreifen können.
- Main startet.
- Loader beendet sauber.
- aktuelle Runtime-Systeme arbeiten auf der Core-Grundlage.
- zentrale Dirty-Semantik funktioniert.

Bei späteren Core-Änderungen müssen die betroffenen abhängigen Systeme erneut geprüft werden.

---

## 32. Entwicklungsregel

Core-Änderungen werden konservativ behandelt.

Grund:

    viele Fachsysteme hängen vom Core ab

Deshalb:

1. nur konkreten Bedarf ändern,
2. Auswirkungen auf abhängige Systeme prüfen,
3. State-Struktur nicht beiläufig verändern,
4. Dirty-Semantik erhalten,
5. keine Framework-spezifische Fachlogik in Core verschieben,
6. Regressionen gezielt durchführen.

---

## 33. Kein aktueller Core-Code-Schritt

Der Core benötigt aktuell keinen neuen allgemeinen Entwicklungsschritt.

Der aktuelle Projektbereich ist:

    Priority 4 – produktive CTLD-Integration vorbereiten

Vor produktivem CTLD-Code muss die fachliche Integrationsgrenze festgelegt werden.

Der Core wird nur geändert, wenn diese Architektur tatsächlich eine neue allgemeine Infrastruktur benötigt.

Keine vorsorgliche Core-Erweiterung.

---

## 34. Entwicklungswerkzeuge

Aktuelle Rollen:

### ChatGPT

    Projektkoordination
    Architektur
    GitHub-Audit
    Testplanung
    Bewertung
    Dokumentation

### Claude + dcs-mcp

Version:

    dcs-mcp 0.9.11

Rolle:

    .miz
    Mission Editor
    Gruppen
    Zonen
    Wegpunkte
    Tasks
    gespeicherte Missionsstruktur

### Claude Code + DCS-SMS

Version:

    DCS-SMS 0.27.2

Hook:

    me-bridge-0.27.2

Verifiziertes Installationsverzeichnis:

    C:\Tools\dcs-sms

Rolle:

    lokale Runtime
    Runtime-Lua
    Theater-Command-State
    Logs
    Runtime-Regressionen

Aus dem bestätigten Stand wird kein exakter DCS-SMS-Executable-Pfad abgeleitet.

### GitHub

    Source of Truth

### DCS

    autoritativer Runtime-Verhaltensbeweis

---

## 35. Aktueller Abschlussstand

Stand:

    2026-09-29

Core:

    aktiv
    stabil
    Grundlage aller aktuellen Fachsysteme

Mission-Record-Loss:

    widerlegt

Dirty-State:

    zentral
    produktiv verwendet
    Priority-3-Regressionen abgeschlossen

Persistence:

    v0.2.6
    productiveRestore=false

Aktueller Projektbereich:

    Priority 4 – produktive CTLD-Integration vorbereiten

Der Core benötigt aktuell keinen parallelen Ausbau.

Aktueller Übergang:

    stabiler Core
    +
    stabiler state-first Kampagnenstate
    +
    abgeschlossene Dirty-Coverage
    +
    bestandener CTLD-KI-Truppentransport-PoC
    ->
    kontrollierte produktive CTLD-Integration
