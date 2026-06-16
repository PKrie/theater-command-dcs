# Mission Editor

Dieser Ordner dokumentiert alle Arbeiten, die im DCS Mission Editor für **Theater Command DCS** vorbereitet werden.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die aktuelle technische Entwicklungsmission heißt:

    Operation_Levant_Reclamation_DEV.miz

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

Der Mission Editor stellt die physische Umgebung bereit.

Lua übernimmt die eigentliche Kampagnenlogik.

GitHub dokumentiert Struktur, Entscheidungen, Versionen, Aufgabenstand und Testergebnisse.

---

## Zweck dieses Ordners

Der Ordner `mission_editor/` beschreibt nur die Arbeiten, die im DCS Mission Editor vorbereitet oder getestet werden müssen.

Dazu gehören:

- Koalitionen
- Spieler-Slots
- Lua-Ladetrigger
- Template-Gruppen
- CTLD-Zonen
- statische Ziele
- IADS-Gruppen
- Debug-Testaufbauten
- spätere Mission-Editor-Sonderzonen

Nicht hier hinein gehört:

- eigentliche Lua-Kampagnenlogik
- Framework-Code
- Save-Dateien
- Kampagnen-Persistenz
- vollständige dynamische Missionslogik

Eigene Lua-Logik liegt unter:

    src/

Externe Frameworks liegen unter:

    vendor/

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

Diese Mission ist aktuell nur ein technischer Testträger.

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
- eigene Theater-Command-Dateien werden geladen
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

    Die Mission-Editor-Ladekette funktioniert.
    Die technische Startkette ist in DCS lauffähig.
    Der nächste technische Schwerpunkt liegt im Code: Airbase-Klassifizierung.

---

## Lokaler Projektpfad

Die lokale Repository-Kopie auf dem DCS-PC liegt aktuell unter:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\

Aus diesem Pfad werden die Lua-Dateien im Mission Editor per `DO SCRIPT FILE` geladen.

---

## Aktuelle Dateien in diesem Ordner

Aktuell vorhanden:

    mission_editor/README.md
    mission_editor/trigger_setup.md

Noch geplant:

    mission_editor/client_slots.md
    mission_editor/template_groups.md
    mission_editor/ctld_start_zones.md
    mission_editor/static_targets.md

---

## `mission_editor/trigger_setup.md`

Diese Datei dokumentiert die konkrete Trigger-Struktur für den technischen Starttest.

Status:

    erstellt
    im Mission Editor umgesetzt
    in DCS erfolgreich getestet

Sie enthält:

- Framework-Lade-Reihenfolge
- Source-Lade-Reihenfolge
- Triggernamen
- `TIME MORE`-Werte
- `DO SCRIPT FILE`-Dateien
- Ergebnis des ersten Starttests
- geplante Starttest-Variante B

---

## Aktuelle Trigger-Strategie

Die erfolgreiche Trigger-Strategie ist:

    Starttest-Variante A — sichere Einzeldatei-Ladung

Dabei werden alle aktiven Dateien einzeln im Mission Editor geladen.

Reihenfolge:

    Frameworks
    Core
    World
    Campaign
    Logistics
    Missions
    AI
    Main
    Loader

Wichtig:

    src/main.lua wird vor src/loader.lua geladen.
    src/loader.lua wird zuletzt geladen.

Grund:

    main.lua definiert TC.Main.
    loader.lua prüft danach Frameworks und startet Main.

---

## Externe Framework-Ladung

Die getestete externe Framework-Lade-Reihenfolge lautet:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua

Diese Reihenfolge wurde im ersten DCS-Starttest erfolgreich verwendet.

Wichtig:

    MIST muss vor CTLD geladen werden.
    CTLD-i18n.lua muss vor CTLD.lua geladen werden.
    Eigene Theater-Command-Logik startet erst nach den Frameworks.

---

## Eigene Source-Ladung

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

Diese Dateien wurden im ersten DCS-Starttest geladen.

Ergebnis:

    Bestanden.

---

## Aktuelle DEV-Mission

Die aktuelle DEV-Mission ist der technische Testträger.

Sie dient für:

- Framework-Ladetests
- Source-Ladetests
- Loader-Test
- Main-Test
- `dcs.log`-Kontrolle
- Airbase-Scanner-Test
- Zone-Factory-Test
- spätere Airbase-Klassifizierung
- spätere Debug-Reports
- spätere Loader-only-Prüfung

Sie dient aktuell nicht für:

- vollständige Kampagne
- rote Frontlinie
- IADS-Krieg
- CTLD-Logistik
- F10-Missionsauswahl
- Persistenz
- Release-Test

---

## Koalitionsauswahl

Für die DEV-Mission wurde das DCS-Koalitionspreset genutzt:

    Modern

Diese Auswahl ist für den aktuellen Entwicklungsstand passend.

Grund:

- moderne Koalitionslogik
- USA als Blue verfügbar
- Syrien als Red verfügbar
- Russland als Red verfügbar
- passend für einen modernen Syria-Kontext
- keine unnötige Sonderkonfiguration in der Frühphase

---

## Spieler-Slot

Aktueller erster Spieler-Slot:

    Flugzeug: F/A-18C Lot 20
    Koalition: Blue
    Land: USA
    Startort: Akrotiri
    Starttyp: Start vom Parkplatz
    Skill: Client

Dieser Slot ist noch kein finaler Kampagnenslot.

Er dient aktuell nur dazu, die Mission starten und die technische Lua-Kette in DCS testen zu können.

---

## `dcs.log`-Prüfung

Nach jedem technischen Test wird die `dcs.log` geprüft.

Standardpfad:

    C:\Users\Paul\Saved Games\DCS\Logs\dcs.log

Möglicher älterer Open-Beta-/Standalone-Pfad:

    C:\Users\Paul\Saved Games\DCS.openbeta\Logs\dcs.log

Schneller Explorer-Pfad:

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

---

## Bestätigte Logik aus Starttest-Variante A

Wichtige positive Logausgaben:

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

World-Ergebnis:

    Airbase scan completed: 225 airbases registered
    Zone factory completed: 225 zones registered

Bewertung:

    Theater Command startet technisch korrekt.
    Die aktive Source-Grundstruktur ist im DCS Mission Scripting Environment lauffähig.
    Die hohe Airbase-Zahl ist kein Ladefehler.
    Die Airbase-Klassifizierung ist der nächste technische Schwerpunkt.

---

## Bekannte DCS-/Syria-Meldungen

Im ersten Test traten auch DCS-/Syria-interne Meldungen auf.

Beispiele:

    INVALID ATC HI08
    missing object declaration
    texture not found
    DTC_MANAGER Window pointer is null

Bewertung:

    Diese Meldungen sind aktuell kein Theater-Command-Blocker.

Entscheidend sind:

- TC-bezogene Lua-Fehler
- TC-bezogene Stack Tracebacks
- fehlgeschlagene Framework-Erkennung
- fehlgeschlagener Main-Start
- fehlgeschlagene Runtime-Initialisierung

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

    Die technische Startkette ist gerade bestätigt.
    Vor weiterem Mission-Editor-Ausbau muss der Airbase-Scanner fachlich sauber klassifizieren.

---

## Spätere Mission-Editor-Dateien

### `mission_editor/client_slots.md`

Geplanter Zweck:

- finale Client-Slot-Struktur dokumentieren
- Slot-Namen definieren
- Flugzeugtypen festlegen
- Startbasen festlegen
- Rollen und Module festlegen

Aktueller Stand:

    noch nicht erstellt

---

### `mission_editor/template_groups.md`

Geplanter Zweck:

- Late-Activation-Templates dokumentieren
- rote CAP-Templates vorbereiten
- rote GCI-Templates vorbereiten
- SAM-/IADS-Templates vorbereiten
- Logistik-Templates vorbereiten
- AI-Templates vorbereiten

Aktueller Stand:

    noch nicht erstellt

---

### `mission_editor/ctld_start_zones.md`

Geplanter Zweck:

- CTLD-Pickup-Zonen dokumentieren
- CTLD-Dropoff-Zonen dokumentieren
- FOB-Zonen dokumentieren
- Akrotiri als initialen CTLD-Hub vorbereiten

Aktueller Stand:

    noch nicht erstellt

---

### `mission_editor/static_targets.md`

Geplanter Zweck:

- statische Missionsziele dokumentieren
- Depots dokumentieren
- Radar-/SAM-Objekte dokumentieren
- Infrastrukturziele dokumentieren
- spätere Strike-Ziele vorbereiten

Aktueller Stand:

    noch nicht erstellt

---

## Starttest-Variante B

Status:

    Noch nicht durchgeführt

Ziel:

    Loader-only-Test mit dofile

Geplante Idee:

Der Mission Editor lädt nur:

    vendor/mist/mist.lua
    vendor/moose/Moose.lua
    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua
    vendor/skynet-iads/SkynetIADS.lua
    src/loader.lua

Der Loader soll dann selbst versuchen, die übrigen Theater-Command-Dateien nachzuladen.

Prüffragen:

- funktioniert `dofile` im DCS Mission Scripting Environment?
- kennt `loader.lua` den lokalen Script-Root?
- kann aus dem Repository-Pfad gelesen werden?
- blockiert die DCS-Sandbox?
- bleibt Einzeldatei-Ladung für Entwicklung sinnvoller?
- wird später eine Build-Datei benötigt?

Diese Variante wird erst später als eigener Test vorbereitet.

---

## Nächster technischer Schritt

Der nächste technische Schritt ist nicht im Mission Editor.

Nächster Schritt:

    src/world/tc_airbase_scanner.lua erweitern

Ziel:

- Airbase-Kategorien einführen
- Airbase-Klassifizierung ergänzen
- strategische Relevanz berechnen
- getrennte Listen speichern
- Summary-Logausgabe erzeugen
- ZoneFactory später darauf vorbereiten

---

## Aktueller Status

Die Mission-Editor-Dokumentation ist auf den erfolgreichen ersten DCS-Starttest aktualisiert.

Die DEV-Mission bleibt als technischer Testträger bestehen.

Der nächste Entwicklungsschritt liegt im World-Code.
