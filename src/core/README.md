# src/core/README.md

Diese Datei beschreibt den Core-Bereich von **Theater Command DCS**.

Der Core ist die technische Grundschicht der eigenen Lua-Runtime.

---

## 1. Zweck des Core-Bereichs

`src/core/` enthält die technische Basis von Theater Command DCS.

Der Core stellt keine fachliche Kampagnenlogik im engeren Sinn bereit.

Der Core stellt gemeinsame Grundlagen bereit für:

- Konfiguration
- Logging
- globalen State
- Utility-Funktionen
- Scheduler-Grundfunktionen
- defensive Initialisierung
- Modulstatus
- Featurestatus
- spätere Debug-Ausgaben

Alle späteren Theater-Command-Systeme dürfen auf den Core zugreifen.

Der Core soll selbst möglichst unabhängig von späteren Fachsystemen bleiben.

---

## 2. Kampagnenkontext

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

Grundprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

---

## 3. Aktueller technischer Stand

Stand:

    2026-06-29

Aktive Core-Dateien:

    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
    src/core/tc_utils.lua
    src/core/tc_scheduler.lua

Status:

    aktiv
    geladen
    im DCS-Test bestanden
    Grundlage für alle weiteren Systeme

Bestätigt durch DCS-Logtests:

- Core-Dateien werden geladen.
- globale Theater-Command-Struktur ist verfügbar.
- Konfiguration ist verfügbar.
- Logger ist verfügbar.
- State ist verfügbar.
- Utils sind verfügbar.
- Scheduler-Grundstruktur ist verfügbar.
- Main kann auf Core zugreifen.
- Loader kann Frameworks und Runtime prüfen.
- Es gab keinen Theater-Command-Lua-Fehler.
- Es gab keinen Lua-Stacktrace.

---

## 4. Architekturregel

Externe Frameworks liegen unter:

    vendor/

Eigene Theater-Command-Logik liegt unter:

    src/

Der Core gehört zur eigenen Theater-Command-Logik.

Frameworks werden nicht verändert.

Dateien in `src/core/` werden nach Theater-Command-Aufgaben benannt, nicht nach Frameworks.

Nicht gewünscht:

    src/core/tc_moose.lua
    src/core/tc_mist.lua
    src/core/tc_ctld.lua
    src/core/tc_skynet.lua
    src/core/tc_all_in_one.lua
    src/core/tc_framework_wrapper.lua

Gewünscht:

    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
    src/core/tc_utils.lua
    src/core/tc_scheduler.lua

Der Core ist kein Wrapper für MOOSE, MIST, CTLD oder Skynet IADS.

Der Core ist die technische Basis von Theater Command DCS.

---

## 5. Aktive Dateien

Aktuell aktive Dateien:

    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
    src/core/tc_utils.lua
    src/core/tc_scheduler.lua

`tc_config.lua`:

    zentrale Projekt- und Kampagnenkonfiguration

`tc_logger.lua`:

    einheitliches Logging für dcs.log

`tc_state.lua`:

    globale Theater-Command-State-Struktur

`tc_utils.lua`:

    allgemeine Hilfsfunktionen

`tc_scheduler.lua`:

    Scheduler- und Timer-Grundstruktur

Diese Dateien sind nicht mehr nur geplant.

Sie sind Teil der aktiven Ladefolge.

---

## 6. tc_config.lua

Datei:

    src/core/tc_config.lua

Aufgabe:

    zentrale Konfiguration für Theater Command DCS

Mögliche Inhalte:

- Projektname
- Kampagnenname
- Map
- Startbasis
- Startkoalition
- Debug-Schalter
- Feature-Schalter
- Standardwerte
- Versionen
- Systemkonfiguration

Typische Werte:

    projectName: Theater Command DCS
    campaignName: Operation Levant Reclamation
    map: Syria
    blueStartBase: Akrotiri
    initialRedTerritory: Syrian Mainland
    debugEnabled: true

Abgrenzung:

    tc_config.lua enthält keine Airbase-Scan-Logik.
    tc_config.lua erzeugt keine Zonen.
    tc_config.lua führt keine Capture-Entscheidungen aus.
    tc_config.lua erzeugt keine Missionen.

---

## 7. tc_logger.lua

Datei:

    src/core/tc_logger.lua

Aufgabe:

    einheitliches Logging für Theater Command DCS

Der Logger ist wichtig, weil `dcs.log` aktuell die wichtigste technische Prüfstelle ist.

Aufgaben:

- einheitliche Log-Ausgaben
- Info-Meldungen
- Warnungen
- Fehler
- Debug-Ausgaben
- klare Theater-Command-Präfixe
- Modulnamen in Logs
- Versionsmarker in Logs
- Testauswertung erleichtern

Empfohlenes Log-Präfix:

    [TC]

Beispiele:

    [TC] Theater Command loader started
    [TC] Main start requested
    [TC] Runtime systems initialized
    [TC] Theater Command loader finished

Wichtig:

    Jede aktive Lua-Datei soll beim Laden ihre Version loggen.
    Dadurch kann geprüft werden, ob DCS wirklich die aktuelle Datei aus der .miz geladen hat.

---

## 8. tc_state.lua

Datei:

    src/core/tc_state.lua

Aufgabe:

    globaler Theater-Command-State

Der State speichert den strategischen und technischen Zustand von Theater Command DCS.

Er speichert nicht jedes kurzlebige DCS-Objekt.

Wichtige State-Bereiche:

    TC.State.Core
    TC.State.Modules
    TC.State.Features
    TC.State.World
    TC.State.Bases
    TC.State.Zones
    TC.State.Campaign
    TC.State.Capture
    TC.State.Logistics
    TC.State.Missions
    TC.State.AI
    TC.State.IADS
    TC.State.UI
    TC.State.Persistence
    TC.State.Debug

Aktuell nutzen mehrere Systeme den State produktiv state-first:

- Airbase Scanner
- ZoneFactory
- CaptureSystem
- LogisticsDelivery
- FobSystem
- MissionGenerator
- AICapManager
- F10Menu
- PersistenceSystem-Grundstruktur

---

## 9. tc_utils.lua

Datei:

    src/core/tc_utils.lua

Aufgabe:

    allgemeine Hilfsfunktionen

Mögliche Utility-Aufgaben:

- sichere Tabellenzugriffe
- String-Hilfsfunktionen
- Namensnormalisierung
- einfache Validierungen
- Koalitionsumwandlungen
- Positions- und Distanzhilfen
- Standardprüfungen für nil-Werte
- defensive Kopierfunktionen
- kleine wiederverwendbare technische Funktionen

Nicht in `tc_utils.lua` gehören:

- Airbase Scanner
- ZoneFactory
- CaptureSystem
- LogisticsDelivery
- FobSystem
- MissionGenerator
- AICapManager
- IADS-System
- PersistenceSystem
- F10Menu

Utils sollen allgemein bleiben.

Fachlogik gehört in die passenden Fachmodule.

---

## 10. tc_scheduler.lua

Datei:

    src/core/tc_scheduler.lua

Aufgabe:

    Scheduler- und Timer-Grundstruktur

Mögliche Scheduler-Aufgaben:

- verzögerte Funktionsaufrufe
- wiederholte Prüfungen
- periodische Debug-Ausgaben
- spätere AI-Director-Ticks
- spätere MissionGenerator-Updates
- spätere Logistics-Prüfungen
- spätere Persistence-Intervalle
- sichere Kapselung von DCS-Timer-Funktionen

Abgrenzung:

    tc_scheduler.lua trifft keine Kampagnenentscheidungen.
    tc_scheduler.lua erzeugt keine Missionen.
    tc_scheduler.lua führt keine Capture-Logik aus.

Der Scheduler führt nur zeitgesteuerte Funktionen aus.

---

## 11. Namespace

Theater Command DCS nutzt eine zentrale globale Projekttabelle:

    TC

Nicht verwenden:

    TheaterCommand
    theaterCommand
    tc_global
    _G_TC
    TheaterCommandCore

Geplante und aktuelle Struktur:

    TC
    ├── Config
    ├── Logger
    ├── State
    ├── Utils
    ├── Scheduler
    ├── Core
    ├── World
    ├── Campaign
    ├── Logistics
    ├── Missions
    ├── AI
    ├── IADS
    ├── UI
    └── Debug

Wichtig:

    TC ist die einzige zentrale globale Projektstruktur.
    Fachmodule hängen sich sauber unter TC ein.

---

## 12. Aktuelle Ladeposition

Der Core wird nach den Vendor-Frameworks und vor allen eigenen Fachsystemen geladen.

Aktuelle Ladefolge im Mission Editor:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua
    6. src/core/tc_config.lua
    7. src/core/tc_logger.lua
    8. src/core/tc_state.lua
    9. src/core/tc_utils.lua
    10. src/core/tc_scheduler.lua
    11. src/world/tc_airbase_scanner.lua
    12. src/world/tc_zone_factory.lua
    13. src/campaign/tc_capture_system.lua
    14. src/campaign/tc_persistence_system.lua
    15. src/logistics/tc_logistics_delivery.lua
    16. src/logistics/tc_fob_system.lua
    17. src/missions/tc_mission_generator.lua
    18. src/ai/tc_ai_cap_manager.lua
    19. src/ui/tc_f10_menu.lua
    20. src/main.lua
    21. src/loader.lua

Wichtig:

    Core-Dateien müssen vor World, Campaign, Logistics, Missions, AI, UI, Main und Loader verfügbar sein.

---

## 13. Verhältnis zu Vendor-Frameworks

Vendor-Frameworks:

    MIST
    MOOSE
    CTLD
    Skynet IADS

Der Core darf prüfen, ob Frameworks vorhanden sind.

Der Core verändert keine Vendor-Dateien.

Der Core startet keine produktiven Framework-Aktionen.

Aktuelle Framework-Rolle:

- MIST ist geladen.
- MOOSE ist geladen.
- CTLD ist geladen.
- Skynet IADS ist geladen.
- Loader erkennt diese Frameworks.
- echte Framework-Aktionen bleiben state-first deaktiviert.

---

## 14. Verhältnis zu World

World nutzt den Core.

Aktive World-Dateien:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

World nutzt:

- TC.Config
- TC.Logger
- TC.State
- TC.Utils
- TC.Scheduler bei Bedarf

Aktuelle World-Werte:

    Syria airbase-like objects: 225
    relevante Kampagnenzonen: 46
    captureCandidates: 32
    missionCandidates: 32
    logisticsCandidates: 46

Core stellt nur die technische Grundlage bereit.

World liefert die Karten- und Raumdaten.

---

## 15. Verhältnis zu Campaign

Campaign nutzt den Core.

Aktive Campaign-Dateien:

    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua

Campaign nutzt:

- TC.Config
- TC.Logger
- TC.State
- TC.Utils
- TC.Scheduler bei Bedarf

Aktuelle Capture-Werte:

    eligibleBases: 32
    eligibleZones: 32
    pressureRecords: 32
    progressRecords: 32
    appliedMissionEffects: 0

Core führt keine Capture-Logik aus.

Campaign verwaltet strategischen Kampagnenzustand.

---

## 16. Verhältnis zu Logistics

Logistics nutzt den Core.

Aktive Logistics-Dateien:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

Aktuelle Logistics-Werte:

    logistics hubs: 46
    blue hubs: 7
    red hubs: 24
    neutral hubs: 15
    active hubs: 31
    limited hubs: 15
    locked hubs: 0

Aktuelle FOB-Werte:

    FOB candidates: 6
    Blue FOBs: 2
    FOB Ercan
    FOB Gecitkale
    Status: UNDER_CONSTRUCTION

Core führt keine CTLD-Aktionen aus.

Logistics verwaltet Logistics Hubs und FOB-State.

---

## 17. Verhältnis zu Missions

Missions nutzt den Core.

Aktive Missions-Datei:

    src/missions/tc_mission_generator.lua

Aktuelle MissionGenerator-Werte:

    mission candidates: 69
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 30

Core erzeugt keine Missionen.

Missions erzeugt Mission Records und verwaltet Mission Activation state-only.

---

## 18. Verhältnis zu AI

AI nutzt den Core.

Aktive AI-Datei:

    src/ai/tc_ai_cap_manager.lua

Aktuelle AI-Werte:

    cap zone candidates: 31
    auto-registered CAP zones: 12
    CAP requests: 12
    reactionState: AIR_REACTION_REQUESTED
    threatLevel: HIGH

Core trifft keine AI-Entscheidungen.

AI erzeugt state-only CAP-State.

---

## 19. Verhältnis zu UI

UI nutzt den Core.

Aktive UI-Datei:

    src/ui/tc_f10_menu.lua

Aktuelle UI-Werte:

    F10Menu v0.2.0
    commands: 26

Aktuelle UI-Funktionen:

- Missionen anzeigen
- Mission Details anzeigen
- Missionen aktivieren
- Campaign Status anzeigen
- Logistics Status anzeigen
- FOB Status anzeigen
- AI CAP Status anzeigen

Core erzeugt keine F10-Menüs.

UI stellt den State über F10 dar.

---

## 20. Verhältnis zu IADS

IADS ist als eigener Bereich vorbereitet.

Aktueller Stand:

    Skynet IADS wird geladen.
    src/iads/ ist vorbereitet.
    eigenes Theater-Command-IADS-Modul ist noch nicht aktiv.

Core stellt später die technische Grundlage für IADS bereit.

Core initialisiert aber keine Skynet-Netzwerke.

---

## 21. Verhältnis zu Debug

Debug ist als eigener Bereich vorbereitet.

Aktueller Stand:

    src/debug/ ist vorbereitet.
    eigenes Debug-System ist noch nicht aktiv.

Core stellt Logger, State und Config für spätere Debug-Funktionen bereit.

Debug soll später State-Dumps und Reports erzeugen.

---

## 22. State-first-Regel

Auch der Core unterstützt die state-first-Architektur.

Das bedeutet:

- Core stellt State bereit.
- Fachmodule schreiben in State.
- UI zeigt State.
- Framework-Hooks bleiben vorbereitet.
- echte Framework-Aktionen folgen erst später.

Nicht Aufgabe des Core:

- echte MOOSE-Spawns
- echte CTLD-Aktionen
- echte Skynet-Aktionen
- Missionen erzeugen
- Zonen erobern
- FOBs bauen
- IADS-Netzwerke aktivieren

---

## 23. Testziele

Der Core gilt aktuell als bestanden, wenn:

- TC-Tabelle verfügbar ist.
- TC.Config verfügbar ist.
- TC.Logger verfügbar ist.
- TC.State verfügbar ist.
- TC.Utils verfügbar ist.
- TC.Scheduler verfügbar ist.
- Core-Dateien ohne Fehler laden.
- nachfolgende Module auf Core zugreifen können.
- Main startet.
- Loader beendet sauber.
- keine Theater-Command-Lua-Fehler auftreten.
- keine Lua-Stacktraces auftreten.

---

## 24. Erwartete Logmarker

Erwartete Core- und Startmarker:

    [TC] Theater Command loader started
    [TC] Main start requested
    [TC] Core check passed
    [TC] Runtime systems initialized
    [TC] Main initialized
    [TC] Main started
    [TC] Theater Command loader finished

Je nach Implementierung können einzelne Core-Dateien eigene Lade- oder Initialisierungsmarker ausgeben.

Wichtig ist:

    Core verfügbar.
    Main startet.
    Loader beendet sauber.
    keine Fehler.

---

## 25. Abgrenzung

Nicht Aufgabe von `src/core/`:

- Airbases scannen
- Zonen erzeugen
- Basen erobern
- Capture-Pressure berechnen
- Logistics Hubs erzeugen
- FOBs planen
- Missionen generieren
- Missionen aktivieren
- CAP steuern
- IADS-Sektoren verwalten
- Spielstände produktiv speichern
- F10-Menüs erzeugen
- Debug-Menüs erzeugen

Diese Systeme bekommen eigene Dateien in den passenden Unterordnern.

Der Core bleibt technische Basis.

---

## 26. Entwicklungsregel

Der Core ist bereits angelegt und aktiv.

Weitere Änderungen am Core nur dann, wenn sie wirklich nötig sind.

Grund:

    Viele Systeme hängen vom Core ab.
    Core-Änderungen können breite Auswirkungen haben.

Bei Core-Änderungen besonders prüfen:

- startet Main noch?
- beendet Loader sauber?
- laden alle Fachmodule noch?
- sind TC.Config, TC.Logger, TC.State, TC.Utils und TC.Scheduler weiterhin verfügbar?
- bleibt F10Menu funktionsfähig?
- treten nil-Fehler auf?

---

## 27. Nächster sinnvoller Schritt

Der nächste sinnvolle Schritt liegt nicht im Core.

Empfohlene nächste Datei:

    src/ui/tc_f10_menu.lua

Ziel:

    Capture-/Pressure-Status im F10-Menü sichtbar machen.

Geplante neue F10-Funktionen:

    Show Capture Status
    Show Capture Ready Zones
    Show Pressure Contested Zones

Akzeptanzkriterien:

- F10Menu lädt als neue Version.
- bisherige 26 Commands bleiben funktionsfähig.
- neue Capture-Commands werden ergänzt.
- Capture Status zeigt mindestens:
  - eligibleBases
  - eligibleZones
  - pressureRecords
  - progressRecords
  - captureReady
  - pressureContested
  - appliedMissionEffects
- Capture Ready Zones können angezeigt werden.
- Pressure Contested Zones können angezeigt werden.
- keine echten Spawns
- keine CTLD-Aktion
- keine Skynet-Aktion
- keine Lua-Fehler
- keine Theater-Command-Fehler

---

## 28. Zielbild

`src/core/` ist die technische Grundlage von Theater Command DCS.

Der Core sorgt dafür, dass spätere Systeme nicht jeweils ihre eigene Konfiguration, ihre eigenen Logger, eigene State-Strukturen oder eigene Timer-Logik bauen müssen.

Aktueller Status:

    Core ist aktiv.
    Core-Dateien werden geladen.
    Core trägt die state-first Runtime.
    Main und Loader starten sauber.

Damit bleibt das Projekt:

- modular
- lesbar
- testbar
- erweiterbar
- wartbar

Der Core ist stabil genug für den nächsten UI-/Debug-Schritt.
