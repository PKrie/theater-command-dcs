# Mission Editor Basics

Diese Datei beschreibt die grundlegende Rolle des DCS Mission Editors im Projekt **Theater Command DCS**.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut.

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## Grundprinzip

Das zentrale Arbeitsprinzip lautet:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Mission Editor stellt nur die physische Umgebung bereit.

Die eigentliche Kampagnenlogik liegt in Lua.

GitHub dokumentiert Struktur, Entscheidungen, Aufgabenstand, Testergebnisse und Versionen.

---

## Rolle des Mission Editors

Der Mission Editor ist nicht das eigentliche Kampagnensystem.

Er stellt bereit:

- Karte
- Koalitionen
- Spieler-Slots
- Startpositionen
- statische Objekte
- Template-Gruppen
- einfache Trigger zum Laden von Lua-Dateien
- Zonen, sofern sie nicht sinnvoll durch Lua erzeugt werden können
- technische Testumgebung

Er soll nicht übernehmen:

- dynamische Kampagnenlogik
- Capture-Entscheidungen
- komplexe Missionsgenerierung
- dynamische KI-Entscheidungen
- Persistenz
- strategische Besitzlogik
- große Triggerketten

---

## Aktueller Mission-Editor-Stand

Stand: 2026-06-16

Aktuelle technische Entwicklungsmission:

    Operation_Levant_Reclamation_DEV.miz

Aktueller Inhalt:

    Map: Syria
    Koalitionspreset: Modern
    Blue Start: Akrotiri / Zypern
    erster blauer Client-Slot: F/A-18C Lot 20 auf Akrotiri
    Trigger: Starttest-Variante A vollständig angelegt
    keine rote Frontlinie
    keine IADS-Stellungen
    keine CTLD-Zonen
    keine Template-Gruppen
    keine F10-Menüs

Die Mission ist aktuell nur ein technischer Testträger.

Sie ist noch keine spielbare Kampagnenmission.

---

## Aktueller Teststatus

Der erste reale DCS-Starttest wurde durchgeführt.

Test:

    Starttest-Variante A — sichere Einzeldatei-Ladung

Ergebnis:

    Bestanden

Bestätigt wurde:

- MIST wird geladen
- MOOSE wird geladen
- CTLD-i18n wird geladen
- CTLD wird geladen
- Skynet IADS wird geladen
- eigene Theater-Command-Source-Dateien werden geladen
- `src/main.lua` wird geladen
- `src/loader.lua` wird zuletzt geladen
- Loader startet
- Frameworks werden erkannt
- Main startet
- Runtime-Systeme werden initialisiert
- Airbase-Scanner läuft
- Zone-Factory läuft
- Loader beendet sauber

Wichtiger Befund:

    Airbase-Scanner registrierte 225 Airbase-/Helipad-Objekte.
    Zone-Factory registrierte 225 Zonen.

Bewertung:

    Die Mission-Editor-Ladestruktur funktioniert.
    Die technische Startkette ist lauffähig.
    Die Airbase-Klassifizierung ist der nächste technische Schwerpunkt.

---

## Koalitionsauswahl

Für die aktuelle DEV-Mission wurde das DCS-Koalitionspreset verwendet:

    Modern

Diese Auswahl ist für den aktuellen Entwicklungsstand passend.

Grund:

- moderne Koalitionslogik
- USA als Blue verfügbar
- Syrien als Red verfügbar
- passend für eine moderne Syria-Kampagne
- keine unnötige Sonderkonfiguration in der Frühphase

Aktuelle Vorgabe:

    Blue startet auf Akrotiri / Zypern.
    Red kontrolliert zu Beginn das syrische Festland.

Die Koalitionsstruktur kann später angepasst werden, falls die Kampagnenlogik oder das Szenario es erfordern.

---

## Spieler-Slot

Aktueller erster Spieler-Slot:

    Flugzeug: F/A-18C Lot 20
    Koalition: Blue
    Land: USA
    Startort: Akrotiri
    Starttyp: Start vom Parkplatz
    Skill: Client

Zweck:

- Mission starten können
- Lua-Startkette in echter DCS-Mission prüfen
- `dcs.log` erzeugen
- Airbase-Scanner und Zone-Factory im DCS-Kontext testen

Dieser Slot ist noch kein finaler Kampagnen-Slot.

Später mögliche Client-Slots:

- F/A-18C
- F-14B
- F-15E
- A-10C
- AH-64D
- weitere Module nach Bedarf

---

## Lokale Repository-Kopie

Für die Arbeit mit dem Mission Editor wird eine lokale Repository-Kopie auf dem DCS-PC verwendet.

Aktueller lokaler Pfad:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\

Aus diesem Pfad werden die Lua-Dateien im Mission Editor per `DO SCRIPT FILE` geladen.

---

## Framework-Ladung

Externe Frameworks liegen im Repository unter:

    vendor/

Die Frameworks werden nicht verändert.

Aktuelle Framework-Basis:

    vendor/mist/mist.lua
    vendor/moose/Moose.lua
    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua
    vendor/skynet-iads/SkynetIADS.lua

Die getestete Framework-Lade-Reihenfolge lautet:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua

Wichtig:

    MIST muss vor CTLD geladen werden.
    CTLD-i18n.lua muss vor CTLD.lua geladen werden.
    Eigene Theater-Command-Logik startet erst nach den Frameworks.

---

## Eigene Source-Ladung

Eigene Theater-Command-Logik liegt unter:

    src/

Aktuell aktive eigene Lua-Dateien:

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
    src/main.lua
    src/loader.lua

Aktuell noch nicht aktiv implementiert:

    src/iads/
    src/ui/
    src/debug/

Diese Bereiche besitzen aktuell README-Dateien, aber noch keine aktiven Lua-Module.

---

## Starttest-Variante A

Status:

    Bestanden

Ziel:

    sichere Einzeldatei-Ladung im Mission Editor

Diese Variante lädt jede aktive Datei einzeln per `DO SCRIPT FILE`.

Vorteile:

- keine harte Abhängigkeit von `dofile`
- klare Fehlereingrenzung
- jede Datei wird direkt im DCS-Kontext getestet
- geeignet für erste technische Validierung
- Fehler lassen sich über `dcs.log` nachvollziehen

---

## Getestete Trigger-Grundstruktur

Jeder Trigger der Starttest-Variante A verwendet:

    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT
    Bedingung: MEHR ZEIT / TIME MORE
    Aktion: SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Die Trigger werden zeitversetzt ausgelöst.

Dadurch bleibt die Lade-Reihenfolge eindeutig.

---

## Getestete Trigger-Reihenfolge

Die erfolgreiche Reihenfolge war:

    TIME MORE 1
    DO SCRIPT FILE: vendor/mist/mist.lua

    TIME MORE 2
    DO SCRIPT FILE: vendor/moose/Moose.lua

    TIME MORE 3
    DO SCRIPT FILE: vendor/ctld/CTLD-i18n.lua

    TIME MORE 4
    DO SCRIPT FILE: vendor/ctld/CTLD.lua

    TIME MORE 5
    DO SCRIPT FILE: vendor/skynet-iads/SkynetIADS.lua

    TIME MORE 7
    DO SCRIPT FILE: src/core/tc_config.lua

    TIME MORE 8
    DO SCRIPT FILE: src/core/tc_logger.lua

    TIME MORE 9
    DO SCRIPT FILE: src/core/tc_state.lua

    TIME MORE 10
    DO SCRIPT FILE: src/core/tc_utils.lua

    TIME MORE 11
    DO SCRIPT FILE: src/core/tc_scheduler.lua

    TIME MORE 12
    DO SCRIPT FILE: src/world/tc_airbase_scanner.lua

    TIME MORE 13
    DO SCRIPT FILE: src/world/tc_zone_factory.lua

    TIME MORE 14
    DO SCRIPT FILE: src/campaign/tc_capture_system.lua

    TIME MORE 15
    DO SCRIPT FILE: src/campaign/tc_persistence_system.lua

    TIME MORE 16
    DO SCRIPT FILE: src/logistics/tc_logistics_delivery.lua

    TIME MORE 17
    DO SCRIPT FILE: src/logistics/tc_fob_system.lua

    TIME MORE 18
    DO SCRIPT FILE: src/missions/tc_mission_generator.lua

    TIME MORE 19
    DO SCRIPT FILE: src/ai/tc_ai_cap_manager.lua

    TIME MORE 20
    DO SCRIPT FILE: src/main.lua

    TIME MORE 22
    DO SCRIPT FILE: src/loader.lua

Wichtig:

    src/main.lua wird vor src/loader.lua geladen.
    src/loader.lua wird als letzte eigene Datei geladen.

Grund:

    main.lua definiert TC.Main.
    loader.lua prüft anschließend Frameworks und startet die Main-Initialisierung.

---

## Ergebnis des ersten Mission-Editor-Tests

Der erste Test wurde erfolgreich durchgeführt.

Positive Theater-Command-Logik:

    Theater Command Loader gestartet
    Frameworks erkannt
    Core geladen
    World geladen
    Campaign geladen
    Logistics geladen
    Missions geladen
    AI geladen
    Main gestartet
    Runtime-Systeme initialisiert
    Loader sauber beendet

World-Ergebnis:

    Airbase scan completed: 225 airbases registered
    Zone factory completed: 225 zones registered

Bewertung:

    Die Mission-Editor-Ladekette funktioniert.
    Das Projekt kann im DCS Mission Scripting Environment starten.
    Der Mission Editor ist als technische Bühne geeignet.
    Die nächste Arbeit liegt im Code, nicht im weiteren Mission-Editor-Ausbau.

---

## `dcs.log` prüfen

Nach jedem Test wird die `dcs.log` geprüft.

Standardpfad:

    C:\Users\Paul\Saved Games\DCS\Logs\dcs.log

Möglicher älterer Open-Beta-/Standalone-Pfad:

    C:\Users\Paul\Saved Games\DCS.openbeta\Logs\dcs.log

Schneller Zugriff:

    %USERPROFILE%\Saved Games

Wichtige Suchbegriffe:

    TC
    Theater Command
    ERROR
    error
    stack traceback
    attempt to index
    nil value
    cannot open
    MIST
    MOOSE
    CTLD
    Skynet

Ein Test ist nur dann als bestanden zu bewerten, wenn die Theater-Command-Startkette ohne schweren Lua-Abbruch durchläuft.

---

## DCS-/Syria-interne Meldungen

Im Log können DCS- oder Syria-interne Meldungen erscheinen.

Beispiele:

    INVALID ATC HI08
    missing object declaration
    texture not found
    DTC_MANAGER Window pointer is null

Diese Meldungen sind aktuell kein Theater-Command-Blocker, solange:

- kein TC-bezogener Lua-Fehler auftritt
- kein TC-bezogener Stack Traceback erscheint
- Frameworks erkannt werden
- Main startet
- Runtime-Systeme initialisiert werden

---

## Was aktuell nicht im Mission Editor gebaut wird

Aktuell bewusst nicht gebaut:

- keine rote Frontlinie
- keine komplette Syria-Befüllung
- keine IADS-Großstruktur
- keine CTLD-Zonen
- keine FOB-Zonen
- keine Template-Gruppen
- keine F10-Menüs
- keine Debug-Menüs
- keine statischen Missionsziele
- keine großen Triggerketten

Grund:

Die technische Startkette ist gerade erst bestätigt.

Vor weiterem Mission-Editor-Ausbau muss der Airbase-Scanner fachlich sauber klassifizieren.

---

## Spätere Mission-Editor-Elemente

Später werden im Mission Editor voraussichtlich benötigt:

- zusätzliche Client-Slots
- CTLD-Pickup-Zonen
- CTLD-Dropoff-Zonen
- FOB-Bauzonen
- Late-Activation-Template-Gruppen
- rote SAM-Stellungen
- rote Radarstellungen
- statische Missionsziele
- Logistikobjekte
- eventuell manuelle Sonderzonen
- Debug-Testobjekte

Diese Elemente werden erst ergänzt, wenn die jeweilige Lua-Logik bereit ist.

---

## Starttest-Variante B

Status:

    Noch nicht durchgeführt

Ziel:

    Loader-only-Test mit dofile

Idee:

Der Mission Editor lädt nur:

    Frameworks
    src/loader.lua

Der Loader soll dann die übrigen Source-Dateien selbst nachladen.

Prüffragen:

- Funktioniert `dofile` im DCS Mission Scripting Environment?
- Kann `loader.lua` lokale Dateien aus dem Repository nachladen?
- Wird der Script-Root korrekt erkannt?
- Blockiert die DCS-Sandbox?
- Wird später eine Build-Datei benötigt?
- Bleibt Einzeldatei-Ladung für Entwicklung sinnvoller?

Diese Variante wird erst in einer späteren Session getestet.

---

## Nächster sinnvoller Schritt

Der nächste sinnvolle technische Schritt liegt nicht im Mission Editor.

Nächster Schritt:

    Airbase-Scanner nach dem Syria-Update fachlich filtern

Ziel:

- strategische Airfields erkennen
- Heliports erkennen
- Helipads erkennen
- Medical Pads erkennen
- FARPs erkennen
- nicht-strategische Objekte aus Capture- und Missionslogik heraushalten
- Zone-Factory später an die gefilterten Daten koppeln

---

## Aktueller Status

Die Mission-Editor-Grundlage ist für den ersten technischen Test ausreichend.

Starttest-Variante A ist bestanden.

Die DEV-Mission bleibt als technischer Testträger bestehen.

Der nächste Entwicklungsschritt betrifft `src/world/tc_airbase_scanner.lua`.
