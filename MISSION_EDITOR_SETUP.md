# Mission Editor Setup

Diese Datei beschreibt, was im DCS Mission Editor für **Theater Command DCS** vorbereitet werden muss.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut.

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## Grundsatz

Der DCS Mission Editor ist in **Theater Command DCS** nicht das eigentliche Kampagnensystem.

Der Mission Editor stellt nur die physische Bühne bereit.

Die dynamische Kampagne wird später durch Lua gesteuert.

Grundprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Mission Editor soll möglichst schlank bleiben.

Alles, was sinnvoll durch Lua erkannt, berechnet oder gesteuert werden kann, soll nicht als große Triggerkette im Mission Editor gebaut werden.

---

## Aktueller Projektstand

Stand: 2026-06-16

Aktuell vorhanden:

- Repository-Grundstruktur
- zentrale Projektdokumentation
- `docs/`-Dokumentation
- `vendor/`-Frameworkstruktur
- MIST
- MOOSE
- CTLD
- Skynet IADS
- `src/`-Grundstruktur
- erste eigene Lua-Module
- Loader
- Main-Initialisierung
- Core-System
- World-System
- Campaign-System
- Logistics-System
- Missions-System
- AI-CAP-System
- Mission-Editor-Dokumentation
- minimale Syria-DEV-Mission
- erster blauer F/A-18C-Client-Slot auf Akrotiri
- vollständige Triggerkette für Starttest-Variante A
- erster realer DCS-Starttest
- erfolgreiche `dcs.log`-Auswertung

Aktueller technischer Status:

    Starttest-Variante A ist bestanden.

Bestätigt wurde:

- MIST wurde geladen
- MOOSE wurde geladen
- CTLD-i18n wurde geladen
- CTLD wurde geladen
- Skynet IADS wurde geladen
- Theater Command Loader wurde gestartet
- Frameworks wurden durch den Loader erkannt
- Core wurde geladen
- World wurde geladen
- Campaign wurde geladen
- Logistics wurde geladen
- Missions wurde geladen
- AI wurde geladen
- Main wurde gestartet
- Runtime-Systeme wurden initialisiert
- Airbase-Scanner wurde ausgeführt
- Zone-Factory wurde ausgeführt
- Loader wurde sauber beendet

Wichtiger Befund:

    Airbase-Scanner registrierte 225 Airbase-/Helipad-Objekte.
    Zone-Factory registrierte 225 Zonen.

Bewertung:

    Die technische Startkette funktioniert.
    Die Zahl von 225 Objekten ist kein Startfehler.
    Das aktuelle Syria-Update liefert sehr viele Airbase-ähnliche Objekte.
    Diese müssen später fachlich klassifiziert und gefiltert werden.

---

## Aktuelle DEV-Mission

Dateiname:

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

## Koalitionen

Für die DEV-Mission wurde das DCS-Koalitionspreset verwendet:

    Modern

Diese Entscheidung ist für den aktuellen Entwicklungsstand passend.

Grund:

- moderne Koalitionslogik
- USA als Blue verfügbar
- Syrien als Red verfügbar
- passend für einen modernen Syria-Kontext
- keine unnötige Sonderkonfiguration zu Beginn

Aktuelle fachliche Vorgabe:

    Blue startet auf Akrotiri / Zypern.
    Red kontrolliert zu Beginn das syrische Festland.

Die Koalitionsauswahl kann später bei Bedarf angepasst werden.

Für den aktuellen technischen Test ist sie ausreichend.

---

## Spieler-Slot

Aktueller erster Client-Slot:

    Flugzeug: F/A-18C Lot 20
    Koalition: Blue
    Land: USA
    Startort: Akrotiri
    Starttyp: Start vom Parkplatz
    Skill: Client

Dieser Slot dient aktuell nur dazu, die Mission starten und in der Simulation laufen lassen zu können.

Er ist noch kein finaler Kampagnenslot.

Später geplante Client-Slots:

- F/A-18C
- F-14B
- F-15E
- A-10C
- AH-64D
- weitere Module nach Bedarf

---

## Externe Framework-Ladung

Die externen Frameworks liegen unter:

    vendor/

Frameworks werden nicht verändert.

Die externe DCS-Lade-Reihenfolge lautet:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua

Diese Reihenfolge wurde im ersten realen DCS-Starttest erfolgreich verwendet.

Wichtig:

    MIST muss vor CTLD geladen werden.
    CTLD-i18n.lua muss vor CTLD.lua geladen werden.
    Skynet IADS wird nach MIST geladen.
    Eigene Theater-Command-Logik startet erst nach den externen Frameworks.

---

## Aktive eigene Source-Dateien

Eigene Lua-Dateien liegen unter:

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

Noch nicht aktiv implementiert:

    src/iads/
    src/ui/
    src/debug/

Diese Bereiche besitzen aktuell nur README-Dateien.

---

## Starttest-Variante A

Status:

    Bestanden

Ziel:

    sichere Einzeldatei-Ladung im DCS Mission Editor

Diese Variante lädt alle aktiven Dateien einzeln per `DO SCRIPT FILE`.

Grund:

- keine harte Abhängigkeit von `dofile`
- klare Fehlereingrenzung
- jede Datei wird im DCS-Kontext getestet
- gut geeignet für den ersten technischen Starttest
- Fehler lassen sich über `dcs.log` klar zuordnen

Die Variante wurde erfolgreich getestet.

---

## Trigger-Reihenfolge für Starttest-Variante A

Im DCS Mission Editor wurden folgende Trigger angelegt.

Jeder Trigger ist:

    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT
    Bedingung: MEHR ZEIT / TIME MORE
    Aktion: SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Die getestete Reihenfolge war:

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

`main.lua` stellt die Main-Tabelle und die Runtime-Systemlogik bereit.

`loader.lua` prüft anschließend Frameworks, Module und startet die Main-Initialisierung.

---

## Getesteter lokaler Dateipfad

Die lokale Repository-Kopie auf dem DCS-PC liegt aktuell unter:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\

Beispielhafte Source-Pfade:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\core\tc_config.lua
    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\core\tc_logger.lua
    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\core\tc_state.lua
    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\core\tc_utils.lua
    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\core\tc_scheduler.lua
    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\world\tc_airbase_scanner.lua
    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\world\tc_zone_factory.lua
    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\campaign\tc_capture_system.lua
    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\campaign\tc_persistence_system.lua
    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\logistics\tc_logistics_delivery.lua
    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\logistics\tc_fob_system.lua
    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\missions\tc_mission_generator.lua
    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\ai\tc_ai_cap_manager.lua
    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\main.lua
    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\loader.lua

---

## Ergebnis Starttest-Variante A

Der erste Starttest wurde in DCS durchgeführt.

Testablauf:

    Mission im DCS Mission Editor gestartet.
    Spieler-/Client-Slot oder Spectator genutzt.
    Mission mindestens 35 Sekunden laufen gelassen.
    Danach dcs.log geprüft.

Ergebnis:

    Bestanden.

Bestätigte Logik:

    MIST erkannt
    MOOSE erkannt
    CTLD erkannt
    Skynet IADS erkannt
    Core geladen
    World geladen
    Campaign geladen
    Logistics geladen
    Missions geladen
    AI geladen
    Main gestartet
    Loader beendet

Wichtige positive Log-Einträge:

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

World-Test:

    Airbase scan completed: 225 airbases registered
    Zone factory completed: 225 zones registered

Bewertung:

    Theater Command startet technisch korrekt.
    Die aktive Source-Grundstruktur ist im DCS Mission Scripting Environment lauffähig.
    Die hohe Airbase-Zahl ist kein Ladefehler.
    Die Airbase-Klassifizierung ist der nächste technische Schwerpunkt.

---

## Bekannte DCS-/Syria-Logmeldungen

Im DCS-Log können zusätzliche Meldungen auftauchen, die nicht durch Theater Command verursacht werden.

Beispiele:

    INVALID ATC HI08
    missing object declaration
    texture not found
    DTC_MANAGER Window pointer is null

Bewertung:

    Diese Meldungen stammen aus DCS, der Syria Map, Assets oder DCS-internen Systemen.
    Sie sind für den Theater-Command-Starttest aktuell kein Blocker.
    Entscheidend sind Theater-Command-Fehler, Lua-Abbrüche oder stack tracebacks mit TC-Bezug.

---

## `dcs.log` prüfen

Die Log-Datei liegt normalerweise hier:

    C:\Users\Paul\Saved Games\DCS\Logs\dcs.log

Oder bei älterer Open-Beta-/Standalone-Struktur:

    C:\Users\Paul\Saved Games\DCS.openbeta\Logs\dcs.log

Schneller Explorer-Pfad:

    %USERPROFILE%\Saved Games

Danach prüfen:

    DCS\Logs\dcs.log

oder:

    DCS.openbeta\Logs\dcs.log

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

## Starttest-Variante B

Status:

    Noch nicht durchgeführt

Ziel:

    Loader-only-Test mit dofile

Idee:

Im Mission Editor werden nur die Frameworks und danach `src/loader.lua` geladen.

Der Loader soll dann prüfen, ob er die restlichen eigenen Source-Dateien über `dofile` nachladen kann.

Geplante Reihenfolge:

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
    DO SCRIPT FILE: src/loader.lua

Prüffokus:

- Funktioniert `dofile` im DCS Mission Scripting Environment?
- Kennt `loader.lua` seinen Script-Root?
- Können lokale Dateien aus dem Repository-Pfad nachgeladen werden?
- Blockiert die DCS-Sandbox den Zugriff?
- Muss später weiter mit Einzeldatei-Ladung gearbeitet werden?
- Brauchen wir eine Build-Datei für den Mission Editor?

Wichtig:

    Variante B wird erst nach der Dokumentationspause und nach sauberer Aufgabenaufnahme in der nächsten Session vorbereitet.

---

## Airbase-Klassifizierung als nächster Schwerpunkt

Das aktuelle Syria-Update liefert viele Airbase-ähnliche Objekte.

Der erste Scanner-Test ergab:

    225 Airbase-/Helipad-Objekte

Das ist technisch wertvoll, aber kampagnenlogisch noch nicht sauber.

Problem:

Nicht jedes DCS-Airbase-Objekt ist eine strategische Kampagnenbasis.

Mögliche Objektarten:

- große Airfields
- kleinere Airfields
- Heliports
- Helipads
- Medical Pads
- FARPs
- sonstige taktische Pads

Nächster technischer Schritt:

    Airbase-Scanner klassifizieren und filtern.

Ziel:

- strategische Airfields erkennen
- Akrotiri korrekt als strategische Blue-Startbasis markieren
- syrische Airfields als potenzielle strategische Red-Basen erkennen
- Helipads separat führen
- Medical Pads separat führen
- FARPs separat führen
- Capture-System nur mit strategischen Kampagnenbasen arbeiten lassen
- Missionsgenerator nur geeignete Ziele verwenden lassen
- Zone-Factory nicht ungefiltert 225 strategische Zonen erzeugen lassen

---

## Mission-Editor-Elemente, die aktuell noch fehlen

Noch nicht angelegt:

- rote Frontlinie
- rote IADS-Stellungen
- rote SAM-Sites
- rote EWR-/Radarstellungen
- CTLD-Pickup-Zonen
- CTLD-Dropoff-Zonen
- FOB-Bauzonen
- Template-Gruppen
- Late-Activation-Gruppen
- F10-Menüs
- Debug-Menüs
- Missionsziele
- statische Zielobjekte
- Logistikobjekte

Diese Elemente werden bewusst noch nicht gebaut.

Grund:

Zuerst muss die technische Startkette stabil bleiben und der Airbase-Scanner fachlich gefiltert werden.

---

## Mission-Editor-Namensregeln

Für Trigger:

    TC_LOAD_<BEREICH_ODER_DATEI>

Beispiele:

    TC_LOAD_MIST
    TC_LOAD_MOOSE
    TC_LOAD_CTLD_I18N
    TC_LOAD_CTLD
    TC_LOAD_SKYNET_IADS
    TC_LOAD_TC_CONFIG
    TC_LOAD_TC_LOGGER
    TC_LOAD_TC_STATE
    TC_LOAD_TC_UTILS
    TC_LOAD_TC_SCHEDULER
    TC_LOAD_TC_AIRBASE_SCANNER
    TC_LOAD_TC_ZONE_FACTORY
    TC_LOAD_TC_CAPTURE_SYSTEM
    TC_LOAD_TC_PERSISTENCE_SYSTEM
    TC_LOAD_TC_LOGISTICS_DELIVERY
    TC_LOAD_TC_FOB_SYSTEM
    TC_LOAD_TC_MISSION_GENERATOR
    TC_LOAD_TC_AI_CAP_MANAGER
    TC_LOAD_TC_MAIN
    TC_LOAD_TC_LOADER

Für Zonen später:

    TC_ZONE_<FUNKTION>_<ORT>

Beispiele:

    TC_ZONE_PICKUP_AKROTIRI_01
    TC_ZONE_DROPOFF_AKROTIRI_01
    TC_ZONE_FOB_SITE_01

Für Template-Gruppen später:

    TC_TEMPLATE_<ROLLE>_<TYP>_<NUMMER>

Beispiele:

    TC_TEMPLATE_RED_CAP_MIG29_01
    TC_TEMPLATE_BLUE_LOGISTICS_UH60_01
    TC_TEMPLATE_RED_SAM_SA6_01

---

## Was im Mission Editor vermieden wird

Nicht gewünscht:

- große Kampagnenlogik über Triggerketten
- Capture-Logik rein im Mission Editor
- Missionsgenerator rein im Mission Editor
- Logistiklogik rein im Mission Editor
- KI-Reaktionslogik rein im Mission Editor
- Persistenzlogik rein im Mission Editor
- unstrukturierte Triggernamen
- Dateien aus zufälligen lokalen Ordnern
- direkte Änderungen an Framework-Dateien

Der Mission Editor bleibt Bühne.

Die Kampagnenlogik bleibt Lua.

---

## Aktueller nächster Mission-Editor-Schritt

Aktuell wird keine neue Mission-Editor-Struktur gebaut.

Nächster technischer Schwerpunkt liegt im Code:

    Airbase-Scanner klassifizieren und filtern

Danach wird im Mission Editor getestet:

    ob die neue Airbase-Klassifizierung sauber in dcs.log ausgegeben wird

Erst danach werden weitere Mission-Editor-Elemente ergänzt.

---

## Aktueller Status

Die DEV-Mission ist als technischer Testträger funktionsfähig.

Starttest-Variante A ist bestanden.

Die nächste Entwicklungsentscheidung betrifft nicht den Mission Editor, sondern die Airbase-Logik in `src/world/tc_airbase_scanner.lua`.
