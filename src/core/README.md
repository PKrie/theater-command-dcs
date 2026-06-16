# Core

Dieser Ordner enthält die technische Grundschicht von **Theater Command DCS**.

Der Core ist der erste eigene Lua-Bereich des Projekts. Er stellt später die gemeinsame Basis bereit, auf der alle weiteren Theater-Command-Systeme aufbauen.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut. Blau startet auf **Zypern / Akrotiri**. Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Zweck von `src/core/`

`src/core/` enthält keine Kampagnenlogik im engeren Sinn.

Der Core stellt technische Grundfunktionen bereit:

- zentrale Konfiguration
- globale Projektstruktur
- Logging
- Kampagnenzustand
- Hilfsfunktionen
- Scheduler-Grundfunktionen
- einfache Fehler- und Debug-Ausgaben

Andere Systeme dürfen später auf den Core zugreifen.

Der Core soll selbst möglichst wenig von späteren Systemen abhängig sein.

---

## Architekturregel

Theater Command DCS wird modular aufgebaut.

Externe Frameworks liegen unter:

    vendor/

Eigene Theater-Command-Logik liegt unter:

    src/

Der Core gehört zur eigenen Theater-Command-Logik.

Frameworks werden nicht verändert.

Eigene Logik wird nicht nach Frameworks sortiert, sondern nach Aufgaben.

Nicht gewünscht:

    src/tc_moose.lua
    src/tc_mist.lua
    src/tc_ctld.lua
    src/tc_skynet.lua
    src/tc_all_in_one.lua
    src/tc_iads_all_in_one.lua

Der Core ist deshalb kein Wrapper für MOOSE, MIST, CTLD oder Skynet IADS.

Der Core ist die technische Basis von Theater Command DCS.

---

## Aktueller Projektstand

Stand: 2026-06-16

Aktuell vorhanden:

    zentrale Projektdokumentation
    docs-Grundblock
    vendor-Frameworks
    src/README.md

Aktuell hinterlegte Frameworks:

    MIST        vendor/mist/mist.lua                 4.5.128-DYNSLOTS-02
    MOOSE       vendor/moose/Moose.lua               2.9.17
    CTLD        vendor/ctld/CTLD.lua                 1.6.1
    Skynet IADS vendor/skynet-iads/SkynetIADS.lua    3.3.0

Noch nicht vorhanden:

    src/loader.lua
    src/main.lua
    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
    src/core/tc_utils.lua
    src/core/tc_scheduler.lua

Diese Datei beschreibt zunächst nur die geplante Core-Struktur.

---

## Geplante Core-Dateien

Für `src/core/` sind folgende Dateien geplant:

    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
    src/core/tc_utils.lua
    src/core/tc_scheduler.lua

Diese Dateien werden später einzeln erstellt und getestet.

Keine dieser Dateien soll zu einer großen All-in-one-Datei werden.

---

## `tc_config.lua`

`tc_config.lua` enthält später die zentrale Grundkonfiguration von Theater Command DCS.

Geplante Aufgaben:

- Projektname definieren
- Kampagnenname definieren
- Versionsnummer definieren
- Debug-Modus festlegen
- Startregion definieren
- Startbasis definieren
- grundlegende Systemschalter definieren
- Standardwerte für spätere Module bereitstellen

Beispiele für spätere Konfigurationswerte:

    projectName = Theater Command DCS
    campaignName = Operation Levant Reclamation
    map = Syria
    blueStartBase = Akrotiri
    initialRedTerritory = Syrian Mainland
    debugEnabled = true

`tc_config.lua` enthält keine Airbase-Logik, keine Capture-Logik und keine Missionsgenerierung.

---

## `tc_logger.lua`

`tc_logger.lua` enthält später das zentrale Logging-System.

Geplante Aufgaben:

- einheitliche Log-Ausgaben vorbereiten
- Info-Meldungen ausgeben
- Warnungen ausgeben
- Fehler ausgeben
- Debug-Ausgaben abhängig von der Konfiguration schalten
- klare Theater-Command-Präfixe verwenden

Empfohlenes Log-Präfix:

    [TC]

Beispiele für spätere Log-Ausgaben:

    [TC] Theater Command loader started
    [TC] Core initialized
    [TC] Config loaded
    [TC] State initialized
    [TC] Airbase scanner started

Der Logger ist wichtig, weil `dcs.log` die wichtigste Prüfstelle für Lua-Fehler und Systemstatus ist.

---

## `tc_state.lua`

`tc_state.lua` enthält später den globalen Theater-Command-Zustand.

Geplante Aufgaben:

- globale State-Struktur vorbereiten
- Kampagnenstatus speichern
- Basenstatus vorbereiten
- Regionenstatus vorbereiten
- Logistikstatus vorbereiten
- Missionsstatus vorbereiten
- IADS-Status vorbereiten
- spätere Persistenz vorbereiten

Der State speichert den strategischen Zustand von Theater Command DCS.

Er speichert nicht jede einzelne temporäre DCS-Einheit.

Beispiele für spätere State-Bereiche:

    TC.State.Campaign
    TC.State.World
    TC.State.Bases
    TC.State.Zones
    TC.State.Logistics
    TC.State.Missions
    TC.State.AI
    TC.State.IADS
    TC.State.Persistence

---

## `tc_utils.lua`

`tc_utils.lua` enthält später allgemeine Hilfsfunktionen.

Geplante Aufgaben:

- sichere Tabellenzugriffe
- String-Hilfsfunktionen
- Namensnormalisierung
- einfache Validierungen
- Koalitionsumwandlungen
- Distanz- oder Positionshilfen
- Standardprüfungen für nil-Werte
- kleine wiederverwendbare technische Funktionen

`tc_utils.lua` darf keine große Sammeldatei für Fachlogik werden.

Nicht in `tc_utils.lua` gehören:

- Airbase-Scanner
- Capture-System
- Missionsgenerator
- Logistiksystem
- AI Director
- IADS-Manager
- Persistenzsystem

Hilfsfunktionen sollen nur dort liegen, wenn sie wirklich allgemein verwendbar sind.

---

## `tc_scheduler.lua`

`tc_scheduler.lua` enthält später zentrale Scheduler-Grundfunktionen.

Geplante Aufgaben:

- wiederholte Prüfungen vorbereiten
- verzögerte Funktionsaufrufe vorbereiten
- einfache Timer-Funktionen kapseln
- Debug-Intervalle ermöglichen
- spätere Systemupdates koordinieren

Mögliche spätere Einsatzbereiche:

- periodischer Kampagnenstatus
- regelmäßige Debug-Ausgabe
- AI-Director-Ticks
- Missionsgenerator-Updates
- Logistikprüfungen
- Persistenzintervalle

Der Scheduler soll keine eigene Kampagnenentscheidung treffen.

Er führt nur zeitgesteuerte Funktionen aus.

---

## Geplanter Namespace

Theater Command DCS nutzt später eine zentrale globale Projekttabelle:

    TC

Nur diese globale Projektstruktur ist für eigene Theater-Command-Logik vorgesehen.

Nicht verwenden:

    TheaterCommand
    theaterCommand
    tc_global
    _G_TC

Geplante Grundstruktur:

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

Die genaue technische Umsetzung erfolgt später in `src/loader.lua`, `src/main.lua` und den einzelnen Core-Dateien.

---

## Ladeposition des Core

Die externe Framework-Ladefolge im DCS Mission Editor lautet:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua
    6. src/loader.lua

`src/loader.lua` lädt danach die eigene Theater-Command-Struktur.

Die geplante interne Reihenfolge beginnt mit dem Core:

    1. Core
    2. World
    3. Campaign
    4. Logistics
    5. Missions
    6. AI
    7. IADS
    8. UI
    9. Debug
    10. Main

Der Core muss deshalb vor allen anderen eigenen Systemen verfügbar sein.

---

## Abhängigkeiten

Der Core darf wissen, dass externe Frameworks existieren.

Der Core soll aber nicht von konkreter Missionslogik abhängig sein.

Erlaubte spätere Prüfungen:

    Ist MIST geladen?
    Ist MOOSE geladen?
    Ist CTLD geladen?
    Ist Skynet IADS geladen?
    Ist TC vorhanden?
    Ist Debug aktiviert?

Nicht Aufgabe des Core:

    Airbases scannen
    Zonen erzeugen
    Basen erobern
    CTLD-Lieferungen bewerten
    Missionen generieren
    CAP steuern
    IADS-Sektoren verwalten
    Spielstände speichern

Diese Aufgaben gehören in eigene Bereiche unter `src/`.

---

## Verbindung zu anderen Bereichen

Der Core stellt die technische Grundlage bereit für:

    src/world/
    src/campaign/
    src/logistics/
    src/missions/
    src/ai/
    src/iads/
    src/ui/
    src/debug/

Die späteren Systeme greifen auf den Core zu, nicht umgekehrt.

Beispiel:

    World nutzt Logger.
    Campaign nutzt State.
    Logistics nutzt Config und State.
    Missions nutzt State und Utils.
    AI nutzt Scheduler und State.
    IADS nutzt Logger und State.
    Debug nutzt Logger, State und Config.

Dadurch bleibt der Core stabil und übersichtlich.

---

## Testziele für den Core

Der Core gilt später als funktionsfähig, wenn folgende Punkte erfüllt sind:

    TC-Tabelle wird angelegt
    TC.Config ist verfügbar
    TC.Logger ist verfügbar
    TC.State ist verfügbar
    TC.Utils ist verfügbar
    TC.Scheduler ist verfügbar
    Debug-Ausgaben erscheinen in dcs.log
    keine Lua-Fehler beim Missionsstart
    keine fehlenden Core-Dateien
    keine Framework-Dateien werden verändert

Erwartete spätere Beispielausgabe in `dcs.log`:

    [TC] Theater Command loader started
    [TC] Core loading started
    [TC] Config loaded
    [TC] Logger initialized
    [TC] State initialized
    [TC] Utils loaded
    [TC] Scheduler initialized
    [TC] Core initialized

---

## Entwicklungsregel

Der Core wird schrittweise aufgebaut.

Empfohlene Reihenfolge:

    1. src/core/README.md
    2. src/core/tc_config.lua
    3. src/core/tc_logger.lua
    4. src/core/tc_state.lua
    5. src/core/tc_utils.lua
    6. src/core/tc_scheduler.lua
    7. src/loader.lua
    8. src/main.lua

Jede Datei wird einzeln erstellt und geprüft.

Keine parallelen Großbaustellen.

---

## Was bewusst nicht in den Core gehört

Nicht in `src/core/` umsetzen:

    Airbase-Scanner
    Airbase-Registry
    Zone Factory
    Capture-System
    Base Ownership
    Logistiklieferungen
    FOB-System
    Missionsgenerator
    AI Director
    CAP Manager
    IADS-Sektorlogik
    Persistenzsystem
    F10-Menüs
    Debug-Menüs

Diese Systeme bekommen eigene Dateien in den passenden Unterordnern.

Der Core bleibt die technische Basis.

---

## Zielbild

`src/core/` soll Theater Command DCS zuverlässig starten und eine klare technische Grundlage bereitstellen.

Der Core sorgt dafür, dass spätere Systeme nicht jeweils ihre eigene Konfiguration, eigene Logger, eigene State-Strukturen oder eigene Timer-Logik bauen müssen.

Damit bleibt das Projekt:

    modular
    lesbar
    testbar
    erweiterbar
    wartbar

Der Core ist der Startpunkt der eigenen Lua-Implementierung von Theater Command DCS.
