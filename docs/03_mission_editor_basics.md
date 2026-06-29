# Mission Editor Basics

Diese Datei beschreibt die grundlegende Rolle des DCS Mission Editors im Projekt **Theater Command DCS**.

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## 1. Grundprinzip

Das zentrale Arbeitsprinzip lautet:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Mission Editor stellt die physische Umgebung bereit.

Die eigentliche Kampagnenlogik liegt in Lua.

GitHub dokumentiert Struktur, Entscheidungen, Aufgabenstand, Testergebnisse und Versionen.

---

## 2. Rolle des Mission Editors

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

Aktuelle Entscheidung:

    Der Mission Editor bleibt bewusst schlank.
    Große dynamische Logik gehört nach src/.

---

## 3. Aktueller Mission-Editor-Stand

Stand:

    2026-06-29

Aktuelle technische Entwicklungsmission:

    Operation_Levant_Reclamation_DEV.miz

Aktueller Inhalt:

    Map: Syria
    Koalitionspreset: Modern
    Blue Start: Akrotiri / Zypern
    erster blauer Client-Slot: F/A-18C Lot 20 auf Akrotiri
    Trigger: Starttest-Variante A vollständig angelegt
    Vendor-Frameworks werden geladen
    Theater-Command-Source-Dateien werden geladen
    F10-Menü ist sichtbar und testbar
    direkte Missionsauswahl über F10 funktioniert
    direkte Missionsaktivierung über F10 funktioniert
    keine produktive rote Frontlinie
    keine produktiven IADS-Stellungen
    keine produktiven CTLD-Zonen
    keine produktiven Template-Gruppen
    keine echten MOOSE-Spawns
    keine echten CTLD-FOBs
    keine produktive Persistenz

Die Mission ist aktuell ein technischer Testträger.

Sie ist noch keine spielbare Kampagnenmission.

---

## 4. Aktueller Teststatus

Starttest-Variante A wurde mehrfach erfolgreich durchgeführt.

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
- Airbase Scanner läuft
- ZoneFactory läuft
- CaptureSystem läuft
- PersistenceSystem lädt/startet als Grundstruktur
- LogisticsDelivery läuft
- FobSystem läuft
- MissionGenerator läuft
- AICapManager läuft
- F10Menu läuft
- F10Menu erzeugt 26 Commands
- Missionen können über F10 direkt ausgewählt werden
- Missionen können über F10 direkt aktiviert werden
- Loader beendet sauber

Wichtiger aktueller Befund:

    Airbase Scanner registriert 225 Syria airbase-like objects.
    ZoneFactory erzeugt daraus 46 relevante Kampagnenzonen.
    CaptureSystem arbeitet auf 32 capture-fähigen Zielen.
    CaptureSystem erzeugt 32 Pressure-Records und 32 Progress-Records.
    LogisticsDelivery erzeugt 46 Logistics Hubs.
    FobSystem erzeugt 6 FOB-Kandidaten und 2 Blue-FOBs.
    MissionGenerator erzeugt 10 verfügbare Missionen aus 69 Kandidaten.
    F10Menu erzeugt 26 Commands.

Bewertung:

    Die Mission-Editor-Ladestruktur funktioniert.
    Die technische Startkette ist lauffähig.
    Die state-first Runtime-Grundlage ist stabil.
    Der nächste technische Schwerpunkt liegt nicht im Mission Editor, sondern in F10-/State-Sichtbarkeit.

---

## 5. Koalitionsauswahl

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

## 6. Spieler-Slot

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
- Airbase Scanner und ZoneFactory im DCS-Kontext testen
- F10-Menü testen
- Mission Details über F10 testen
- Mission Activation über F10 testen

Dieser Slot ist noch kein finaler Kampagnen-Slot.

Später mögliche Client-Slots:

- F/A-18C
- F-14B
- F-15E
- A-10C
- AH-64D
- weitere Module nach Bedarf

---

## 7. Lokale Repository-Kopie

Für die Arbeit mit dem Mission Editor wird eine lokale Repository-Kopie auf dem DCS-PC verwendet.

Aktueller lokaler Pfad:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\

Aus diesem Pfad werden die Lua-Dateien im Mission Editor per `DO SCRIPT FILE` geladen.

Wichtig:

    DCS bettet per DO SCRIPT FILE geladene Dateien in die .miz ein.
    Nach jeder Lua-Änderung muss die betroffene Datei im Mission Editor erneut ausgewählt und die Mission gespeichert werden.

---

## 8. Framework-Ladung

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

Aktueller Stand:

    MIST geladen und erkannt.
    MOOSE geladen und erkannt.
    CTLD geladen und erkannt.
    Skynet IADS geladen und erkannt.
    Produktive Framework-Ausführung ist noch nicht aktiv.

---

## 9. Eigene Source-Ladung

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
    src/ui/tc_f10_menu.lua
    src/main.lua
    src/loader.lua

Aktuell noch nicht aktiv implementiert:

    src/iads/
    src/debug/

Wichtige Korrektur gegenüber älteren Ständen:

    src/ui/ besitzt inzwischen ein aktives Lua-Modul.
    src/ui/tc_f10_menu.lua ist geladen, sichtbar, navigierbar und getestet.

---

## 10. Starttest-Variante A

Status:

    Bestanden

Ziel:

    sichere Einzeldatei-Ladung im Mission Editor

Diese Variante lädt jede aktive Datei einzeln per `DO SCRIPT FILE`.

Vorteile:

- keine harte Abhängigkeit von `dofile`
- klare Fehlereingrenzung
- jede Datei wird direkt im DCS-Kontext getestet
- geeignet für technische Validierung
- Fehler lassen sich über `dcs.log` nachvollziehen

Aktuelle Entscheidung:

    Starttest-Variante A bleibt Standard, bis Loader-only praktisch getestet ist.

---

## 11. Getestete Trigger-Grundstruktur

Jeder Trigger der Starttest-Variante A verwendet:

    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT
    Bedingung: MEHR ZEIT / TIME MORE
    Aktion: SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Die Trigger werden zeitversetzt ausgelöst.

Dadurch bleibt die Lade-Reihenfolge eindeutig.

---

## 12. Getestete Trigger-Reihenfolge

Die erfolgreiche Reihenfolge ist:

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
    DO SCRIPT FILE: src/ui/tc_f10_menu.lua

    TIME MORE 21
    DO SCRIPT FILE: src/main.lua

    TIME MORE 22
    DO SCRIPT FILE: src/loader.lua

Wichtig:

    src/ui/tc_f10_menu.lua wird vor src/main.lua geladen.
    src/main.lua wird vor src/loader.lua geladen.
    src/loader.lua wird als letzte eigene Datei geladen.

Grund:

    main.lua definiert TC.Main und startet Runtime-Systeme.
    loader.lua prüft anschließend Frameworks und beendet die Startkette sauber.

---

## 13. Ergebnis des aktuellen Mission-Editor-Tests

Die Mission-Editor-Ladekette wurde erfolgreich durchgeführt.

Positive Theater-Command-Logik:

    Theater Command Loader gestartet
    Frameworks erkannt
    Core geladen
    World geladen
    Campaign geladen
    Logistics geladen
    Missions geladen
    AI geladen
    UI geladen
    Main gestartet
    Runtime-Systeme initialisiert
    Loader sauber beendet

World-Ergebnis:

    Airbase scan completed: 225 airbase-like objects classified
    Zone factory completed: 46 relevant campaign zones

Campaign-Ergebnis:

    Capture eligibility summary: bases=32, zones=32
    Capture pressure summary: pressureRecords=32, progressRecords=32, appliedMissionEffects=0

Logistics-Ergebnis:

    Logistics hubs: 46
    FOB candidates: 6
    Blue FOBs: 2

Mission-Ergebnis:

    Mission candidates: 69
    FOB support candidates: 2
    Available missions: 10

UI-Ergebnis:

    F10Menu loaded
    F10 menu initialized: commands=26
    Mission Details über F10 bestätigt
    Mission Activation über F10 bestätigt

Bewertung:

    Die Mission-Editor-Ladekette funktioniert.
    Das Projekt kann im DCS Mission Scripting Environment starten.
    Der Mission Editor ist als technische Bühne geeignet.
    Die nächste Arbeit liegt im Code, nicht im weiteren Mission-Editor-Ausbau.

---

## 14. `dcs.log` prüfen

Nach jedem Test wird die `dcs.log` geprüft.

Standardpfad:

    C:\Users\Paul\Saved Games\DCS\Logs\dcs.log

Möglicher Open-Beta-/Standalone-Pfad:

    C:\Users\Paul\Saved Games\DCS.openbeta\Logs\dcs.log

Schneller Zugriff:

    %USERPROFILE%\Saved Games

Wichtige Suchbegriffe:

    TC
    Theater Command
    ERROR
    error
    FAILED
    stack traceback
    attempt to index nil value
    cannot open
    MIST
    MOOSE
    CTLD
    Skynet
    F10Menu
    MissionGenerator
    CaptureSystem

Ein Test ist nur dann als bestanden zu bewerten, wenn die Theater-Command-Startkette ohne schweren Lua-Abbruch durchläuft.

Besonders relevant:

    [TC][ERROR]
    FAILED in einem Theater-Command-Modul
    stack traceback in Theater-Command-Dateien
    fehlende Frameworks
    fehlgeschlagener Main-Start
    fehlgeschlagener Loader-Abschluss

---

## 15. DCS-/Syria-interne Meldungen

Im Log können DCS- oder Syria-interne Meldungen erscheinen.

Beispiele:

    INVALID ATC HI08
    missing object declaration
    texture not found
    DTC_MANAGER
    Window pointer is null
    getObjectPosition: object is not exists
    Destruction shape not found
    render target not found

Diese Meldungen sind aktuell kein Theater-Command-Blocker, solange:

- kein TC-bezogener Lua-Fehler auftritt
- kein TC-bezogener Stack Traceback erscheint
- Frameworks erkannt werden
- Main startet
- Runtime-Systeme initialisiert werden
- F10Menu startet
- Loader sauber beendet

---

## 16. Was aktuell nicht im Mission Editor gebaut wird

Aktuell bewusst nicht produktiv gebaut:

- keine rote Frontlinie
- keine komplette Syria-Befüllung
- keine produktive IADS-Großstruktur
- keine CTLD-Zonen
- keine FOB-Zonen
- keine Template-Gruppen
- keine statischen Missionsziele
- keine großen Triggerketten
- keine MOOSE-Spawn-Templates als produktive Kampagnenlogik
- keine CTLD-Crate-Wirtschaft
- keine produktive Persistenz

Wichtig:

    F10-Menü ist inzwischen vorhanden.
    Dieser ältere Punkt "keine F10-Menüs" ist nicht mehr korrekt.

Grund für Zurückhaltung:

    Die state-first Runtime wird zuerst stabilisiert.
    Erst danach werden echte Framework-Aktionen eingebunden.

---

## 17. Spätere Mission-Editor-Elemente

Später werden im Mission Editor voraussichtlich benötigt:

- zusätzliche Client-Slots
- CTLD-Pickup-Zonen
- CTLD-Dropoff-Zonen
- FOB-Bauzonen
- Late-Activation-Template-Gruppen
- MOOSE-Template-Gruppen
- rote SAM-Stellungen
- rote Radarstellungen
- Skynet-IADS-Sites
- statische Missionsziele
- Logistikobjekte
- eventuell manuelle Sonderzonen
- Debug-Testobjekte

Diese Elemente werden erst ergänzt, wenn die jeweilige Lua-Logik bereit ist.

---

## 18. Starttest-Variante B

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

Aktuelle Entscheidung:

    Starttest-Variante A bleibt bis dahin Standard.

---

## 19. Aktueller getesteter Systemstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.1` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | Grundstruktur | lädt/startet |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.2` | bestanden |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.0` | bestanden |

---

## 20. Nächster sinnvoller Schritt

Der nächste sinnvolle technische Schritt liegt nicht im Mission Editor.

Nächster Schritt:

    F10-Menü um Capture-/Pressure-Sichtbarkeit erweitern.

Empfohlene Datei:

    src/ui/tc_f10_menu.lua

Ziel:

- Capture Status anzeigen
- Capture Ready Zones anzeigen
- Pressure Contested Zones anzeigen
- Capture-Pressure und Capture-Progress lesbar machen
- weiterhin state-only bleiben
- keine echten Spawns auslösen
- keine CTLD-Aktionen auslösen
- keine Skynet-Aktionen auslösen

Begründung:

    CaptureSystem v0.2.1 erzeugt jetzt Pressure- und Progress-Daten.
    Diese Daten sind im State vorhanden.
    F10Menu ist stabil und bereits getestet.
    Ohne UI-/Debug-Sichtbarkeit sind Missionseffekt- und Capture-Tests schwer bewertbar.

---

## 21. Aktueller Status

Die Mission-Editor-Grundlage ist für die aktuelle Entwicklungsphase ausreichend.

Starttest-Variante A ist bestanden.

Die DEV-Mission bleibt als technischer Testträger bestehen.

Aktuelle Fähigkeit:

- Frameworks laden.
- Theater Command lädt.
- Main und Loader starten.
- Runtime-Systeme initialisieren.
- F10-Menü ist sichtbar.
- Missionen können über F10 angezeigt werden.
- Missionen können über F10 aktiviert werden.
- State-first-Kampagnenlogik funktioniert.

Nächster Entwicklungsschritt:

    src/ui/tc_f10_menu.lua
    Capture-/Pressure-Status im F10-Menü sichtbar machen.
