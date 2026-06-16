# Debug

Dieser Ordner enthält Debug- und Testhilfen für **Theater Command DCS**.

`src/debug/` macht später interne Zustände sichtbar und hilft beim Testen der dynamischen Kampagnensysteme.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut. Blau startet auf **Zypern / Akrotiri**. Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Zweck von `src/debug/`

`src/debug/` ist für technische Kontrolle, Testausgaben und Entwicklungswerkzeuge zuständig.

Geplante Aufgaben:

- Debug-Ausgaben bündeln
- Kampagnenzustand sichtbar machen
- Airbase-Status prüfen
- Zonenstatus prüfen
- Capture-Status prüfen
- Logistikstatus prüfen
- Missionsstatus prüfen
- AI- und CAP-Status prüfen
- IADS-Status prüfen
- optionale Debug-Menüs vorbereiten
- spätere Testfunktionen kapseln

Der Debug-Bereich ist kein Kampagnensystem im engeren Sinn.

Er soll helfen, Fehler zu finden und den Zustand der Systeme nachvollziehbar zu machen.

---

## Architekturregel

Externe Frameworks liegen unter:

    vendor/

Eigene Theater-Command-Logik liegt unter:

    src/

Der Debug-Bereich gehört zur eigenen Theater-Command-Logik.

Frameworks werden nicht verändert.

Die Dateien in `src/debug/` werden nach Aufgaben benannt, nicht nach Frameworks.

Nicht gewünscht:

    src/debug/tc_mist_debug.lua
    src/debug/tc_moose_debug.lua
    src/debug/tc_debug_all_in_one.lua
    src/debug/tc_everything_debug.lua

Spätere mögliche Dateien:

    src/debug/tc_debug_console.lua
    src/debug/tc_debug_state_dump.lua
    src/debug/tc_debug_zone_overlay.lua
    src/debug/tc_debug_airbase_report.lua
    src/debug/tc_debug_mission_report.lua

Diese Dateien werden erst angelegt, wenn sie wirklich benötigt werden.

---

## Geplante Dateien

Für `src/debug/` ist zunächst nur diese Dokumentationsdatei geplant:

    src/debug/README.md

Spätere mögliche Implementierungsdateien:

    src/debug/tc_debug_console.lua
    src/debug/tc_debug_state_dump.lua
    src/debug/tc_debug_zone_overlay.lua
    src/debug/tc_debug_airbase_report.lua
    src/debug/tc_debug_mission_report.lua
    src/debug/tc_debug_logistics_report.lua
    src/debug/tc_debug_ai_report.lua
    src/debug/tc_debug_iads_report.lua

Die konkrete Lua-Implementierung wird später separat begonnen.

---

## Beziehung zum Core

`src/debug/` nutzt den Core.

Erlaubte Core-Abhängigkeiten:

    TC.Config
    TC.Logger
    TC.State
    TC.Utils
    TC.Scheduler

Der Debug-Bereich darf davon ausgehen, dass der Core bereits geladen ist.

Die interne Lade-Reihenfolge sieht vor:

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

Debug-Dateien dürfen deshalb auf Core-Funktionen zugreifen.

---

## Beziehung zum World-Bereich

Der Debug-Bereich nutzt Daten aus:

    src/world/

Besonders wichtig sind:

    TC.World.AirbaseScanner
    TC.World.ZoneFactory
    TC.State.Bases
    TC.State.Zones

Mögliche Debug-Ausgaben:

    Anzahl erkannter Airbases
    Airbase-Namen
    Airbase-Koalitionen
    Airbase-Besitzstatus
    erzeugte virtuelle Zonen
    Mission-Editor-Zonen
    Zonenradius
    Zonenbesitz
    verknüpfte Airbases

Debug soll nicht selbst Airbases scannen.

Debug soll nicht selbst Kampagnenzonen erzeugen.

Debug zeigt nur an, was andere Systeme erzeugt haben.

---

## Beziehung zum Campaign-Bereich

Der Debug-Bereich nutzt Daten aus:

    src/campaign/

Besonders wichtig sind:

    TC.Campaign.CaptureSystem
    TC.Campaign.PersistenceSystem
    TC.State.Campaign
    TC.State.Bases
    TC.State.Zones
    TC.State.Persistence

Mögliche Debug-Ausgaben:

    Kampagnenname
    Kampagnenphase
    Besitzstatus von Basen
    Besitzstatus von Zonen
    Capture-Events
    Dirty-State
    letzter Export
    letzter Import
    Save-Name

Debug darf später Testfunktionen für Capture auslösen.

Solche Funktionen müssen klar als Debug-Funktionen gekennzeichnet sein.

Normale Kampagnenlogik bleibt im Campaign-Bereich.

---

## Beziehung zum Logistics-Bereich

Der Debug-Bereich nutzt Daten aus:

    src/logistics/

Besonders wichtig sind:

    TC.Logistics.Delivery
    TC.Logistics.FobSystem
    TC.State.Logistics

Mögliche Debug-Ausgaben:

    Anzahl Lieferungen
    verfügbare Lieferungen
    aktive Lieferungen
    abgeschlossene Lieferungen
    verlorene Lieferungen
    FOB-Anzahl
    FOB-Status
    FOB-Versorgung
    FOB-Baufortschritt

Debug soll keine CTLD-Logik direkt ausführen.

Debug kann später definierte Testlieferungen erzeugen, wenn diese Funktion ausdrücklich als Debug markiert ist.

---

## Beziehung zum Missionsbereich

Der Debug-Bereich nutzt Daten aus:

    src/missions/

Besonders wichtig sind:

    TC.Missions.Generator
    TC.State.Missions

Mögliche Debug-Ausgaben:

    verfügbare Missionen
    aktive Missionen
    abgeschlossene Missionen
    fehlgeschlagene Missionen
    Missionstypen
    Missionsziele
    Missionsprioritäten
    Missionseffekte

Debug darf später Testfunktionen für Missionen bereitstellen.

Beispiele:

    verfügbare Missionen neu generieren
    Mission aktivieren
    Mission als abgeschlossen markieren
    Mission als fehlgeschlagen markieren

Diese Funktionen müssen klar vom normalen Spieler-UI getrennt bleiben.

---

## Beziehung zum AI-Bereich

Der Debug-Bereich nutzt Daten aus:

    src/ai/

Besonders wichtig sind:

    TC.AI.CapManager
    TC.State.AI

Mögliche Debug-Ausgaben:

    registrierte CAP-Zonen
    angeforderte CAPs
    aktive CAPs
    abgeschlossene CAPs
    AI-Reaktionsstatus
    Bedrohungsniveau
    Eskalationslevel

Debug soll keine dauerhafte AI-Logik enthalten.

Debug darf später definierte AI-Testfunktionen auslösen.

---

## Beziehung zum IADS-Bereich

Der Debug-Bereich nutzt später Daten aus:

    src/iads/

Besonders wichtig sind:

    TC.IADS
    TC.State.IADS

Mögliche Debug-Ausgaben:

    IADS-Netzwerke
    IADS-Sektoren
    SAM-Sites
    Radar-Sites
    aktive Sites
    beschädigte Sites
    zerstörte Sites
    SEAD-Ziele
    DEAD-Ziele

Debug soll keine Skynet-IADS-Dateien verändern.

Debug zeigt nur Theater-Command-Status und später optional IADS-Testzustände an.

---

## Beziehung zum UI-Bereich

Der Debug-Bereich kann später über `src/ui/` sichtbar gemacht werden.

Mögliche Verbindung:

    UI erzeugt ein Debug-Menü.
    Debug liefert die eigentlichen Debug-Funktionen.
    UI ruft Debug-Funktionen auf.
    Debug gibt Ergebnisse über Logger, Textausgabe oder F10-Nachrichten zurück.

Wichtig:

    Normale Spieler-UI und Debug-UI bleiben getrennt.

Debug-Funktionen sollen später deaktivierbar sein.

---

## Geplanter Namespace

Der Debug-Bereich wird später unter der zentralen Projekttabelle `TC` abgelegt.

Geplante Struktur:

    TC.Debug
    ├── Console
    ├── StateDump
    ├── ZoneOverlay
    ├── AirbaseReport
    ├── MissionReport
    ├── LogisticsReport
    ├── AIReport
    └── IADSReport

Die globale Projekttabelle bleibt:

    TC

Nicht verwenden:

    TheaterCommandDebug
    DebugTC
    tc_debug_global
    _G_TC_DEBUG

---

## Geplante State-Bereiche

Der Debug-Bereich arbeitet später vor allem mit:

    TC.State.Debug
    TC.State.Campaign
    TC.State.Bases
    TC.State.Zones
    TC.State.Logistics
    TC.State.Missions
    TC.State.AI
    TC.State.IADS
    TC.State.UI
    TC.State.Persistence

Geplante Daten in `TC.State.Debug`:

    enabled
    verbose
    showZones
    showAirbases
    showCapture
    showLogistics
    showMissions
    showAI
    showIADS
    lastReportTime
    lastCommand
    lastResult

Der genaue Datenaufbau wird mit späteren Lua-Dateien festgelegt.

---

## Debug-Grundidee

Debug soll die Entwicklung schneller und sicherer machen.

Theater Command DCS wird modular aufgebaut.

Dadurch entstehen viele interne Zustände.

Debug soll später nachvollziehbar machen:

    Wurde der Core geladen?
    Wurde World korrekt aufgebaut?
    Wurden Airbases erkannt?
    Wurden Zonen erzeugt?
    Sind Besitzer korrekt gesetzt?
    Wurden Lieferungen gespeichert?
    Wurden Missionen erzeugt?
    Hat AI CAPs angefordert?
    Ist Persistence dirty?
    Sind IADS-Daten vorhanden?

Die erste Version darf einfach sein.

Wichtig ist, dass Debug keine versteckte Hauptlogik enthält.

---

## Abgrenzung

Nicht Aufgabe von `src/debug/`:

    Airbases aus DCS auslesen
    Zonen geometrisch erzeugen
    Basenbesitz regulär festlegen
    Zonenbesitz regulär festlegen
    CTLD-Lieferungen regulär auswerten
    FOBs regulär bauen
    Missionen regulär generieren
    CAPs dauerhaft verwalten
    IADS-Netzwerke regulär aufbauen
    normale Spieler-UI ersetzen
    Framework-Dateien verändern

Diese Aufgaben gehören in andere Bereiche.

Debug prüft, zeigt an und testet gezielt.

---

## Sicherheitsregel

Debug-Funktionen können später starken Einfluss auf die Kampagne haben.

Deshalb gilt:

    Debug-Funktionen müssen klar gekennzeichnet sein.
    Debug-Funktionen sollen abschaltbar sein.
    Debug-Funktionen sollen nicht automatisch produktive Kampagnenlogik ersetzen.
    Debug-Funktionen dürfen keine Vendor-Dateien verändern.
    Debug-Funktionen dürfen keine All-in-one-Logik enthalten.

Später kann über `TC.Config` gesteuert werden, ob Debug aktiv ist.

---

## Testziele

Der Debug-Bereich gilt später als funktionsfähig, wenn folgende Punkte erfüllt sind:

    TC.Debug ist vorhanden.
    TC.State.Debug wird korrekt vorbereitet.
    Debug-Ausgaben können erzeugt werden.
    Airbase-Status kann ausgegeben werden.
    Zonenstatus kann ausgegeben werden.
    Capture-Status kann ausgegeben werden.
    Logistikstatus kann ausgegeben werden.
    Missionsstatus kann ausgegeben werden.
    AI-Status kann ausgegeben werden.
    IADS-Status kann später ausgegeben werden.
    Debug kann deaktiviert werden.
    keine Lua-Fehler beim Missionsstart.
    keine Framework-Dateien werden verändert.

Erwartete spätere Beispielausgaben in `dcs.log`:

    [TC] Debug loading started
    [TC] Debug console loaded
    [TC] Debug initialized
    [TC] Debug state dump requested
    [TC] Debug airbase report generated
    [TC] Debug zone report generated
    [TC] Debug mission report generated

---

## Entwicklungsregel

Der Debug-Bereich wird schrittweise aufgebaut.

Empfohlene Reihenfolge:

    1. src/debug/README.md
    2. spätere konkrete Debug-Implementierungsdatei nach Bedarf

Jede Datei wird einzeln erstellt und geprüft.

Keine parallelen Großbaustellen.

Keine All-in-one-Dateien.

---

## Zielbild

`src/debug/` soll die Entwicklung und Fehlersuche von Theater Command DCS unterstützen.

Der Debug-Bereich ist die Kontrollschicht für:

    Core
    World
    Campaign
    Logistics
    Missions
    AI
    IADS
    UI
    Persistence

Damit bleibt das Projekt:

    modular
    lesbar
    testbar
    erweiterbar
    wartbar

`src/debug/` ist die Test- und Diagnoseschicht von **Theater Command DCS**.
