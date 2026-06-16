# World

Dieser Ordner enthält die Abbildung der DCS-Welt in Theater-Command-Strukturen.

`src/world/` ist zuständig für alles, was aus der Mission Editor-Welt ausgelesen, normalisiert oder in eigene Theater-Command-Datenstrukturen überführt wird.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut. Blau startet auf **Zypern / Akrotiri**. Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Zweck von `src/world/`

`src/world/` bildet die DCS-Missionswelt für Theater Command DCS ab.

Geplante Aufgaben:

- Airbases erkennen
- Airbases registrieren
- Airbase-Besitz vorbereiten
- virtuelle Kampagnenzonen erzeugen
- Zonen registrieren
- Kartenlogik vorbereiten
- spätere Verknüpfung zwischen Basen, Zonen, Frontlinie und Missionsgenerator ermöglichen

`src/world/` trifft keine strategischen Kampagnenentscheidungen.

Der Ordner beschreibt, was in der DCS-Welt vorhanden ist.

Was mit diesen Informationen passiert, entscheidet später `src/campaign/`, `src/missions/`, `src/logistics/` oder `src/ai/`.

---

## Architekturregel

Externe Frameworks liegen unter:

    vendor/

Eigene Theater-Command-Logik liegt unter:

    src/

Der World-Bereich gehört zur eigenen Theater-Command-Logik.

Frameworks werden nicht verändert.

Die Dateien in `src/world/` werden nach Aufgaben benannt, nicht nach Frameworks.

Nicht gewünscht:

    src/world/tc_moose_world.lua
    src/world/tc_mist_world.lua
    src/world/tc_world_all_in_one.lua
    src/world/tc_airbase_and_zone_everything.lua

Gewünscht:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

Eine World-Datei darf intern DCS-API, MIST oder MOOSE nutzen.

Der Dateiname richtet sich aber nach der Theater-Command-Aufgabe.

---

## Geplante Dateien

Für `src/world/` sind zunächst folgende Dateien geplant:

    src/world/README.md
    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

Später können bei Bedarf weitere Dateien ergänzt werden, zum Beispiel:

    src/world/tc_airbase_registry.lua
    src/world/tc_zone_registry.lua
    src/world/tc_map_data.lua

Diese Zusatzdateien werden erst angelegt, wenn sie wirklich benötigt werden.

---

## `tc_airbase_scanner.lua`

`tc_airbase_scanner.lua` wird später die vorhandenen DCS-Airbases erfassen.

Geplante Aufgaben:

- Airbases aus der DCS-Welt auslesen
- Namen normalisieren
- Koalitionsstatus erfassen
- Positionen erfassen
- Airbase-Kategorie erfassen
- Startbasis Akrotiri erkennen
- Airbases in `TC.State.Bases.registry` eintragen
- Grundlage für spätere Capture- und Missionslogik schaffen

Der Airbase-Scanner soll keine Basen erobern.

Der Airbase-Scanner soll keine Missionen erzeugen.

Der Airbase-Scanner erkennt nur, welche Basen vorhanden sind und welchen Anfangszustand sie haben.

---

## `tc_zone_factory.lua`

`tc_zone_factory.lua` wird später virtuelle Kampagnenzonen erzeugen.

Geplante Aufgaben:

- Zonen aus Airbases ableiten
- Zonen aus Mission-Editor-Triggerzonen vorbereiten
- Zonen benennen
- Zonen normalisieren
- Zonen in `TC.State.Zones.registry` eintragen
- spätere Frontlinienlogik vorbereiten
- spätere Missionsauswahl vorbereiten

Die Zone Factory soll keine Capture-Entscheidung treffen.

Die Zone Factory soll keine Missionen erzeugen.

Sie stellt nur die räumlichen Strukturen bereit, mit denen andere Systeme arbeiten.

---

## Beziehung zum Core

`src/world/` nutzt den Core.

Erlaubte Core-Abhängigkeiten:

    TC.Config
    TC.Logger
    TC.State
    TC.Utils
    TC.Scheduler

Der World-Bereich darf davon ausgehen, dass der Core bereits geladen ist.

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

World-Dateien dürfen deshalb auf Core-Funktionen zugreifen.

World-Dateien sollen aber nicht direkt von späteren Systemen abhängig sein.

Nicht erlaubt als direkte Pflichtabhängigkeit:

    Campaign
    Logistics
    Missions
    AI
    IADS
    UI
    Debug

Diese Systeme greifen später auf World-Daten zu, nicht umgekehrt.

---

## Geplanter Namespace

Der World-Bereich wird später unter der zentralen Projekttabelle `TC` abgelegt.

Geplante Struktur:

    TC.World
    ├── AirbaseScanner
    ├── ZoneFactory
    ├── Airbases
    └── Zones

Die globale Projekttabelle bleibt:

    TC

Nicht verwenden:

    TheaterCommandWorld
    WorldTC
    tc_world_global
    _G_TC_WORLD

---

## Geplante State-Bereiche

Der World-Bereich schreibt später vor allem in:

    TC.State.World
    TC.State.Bases
    TC.State.Zones

Geplante Daten in `TC.State.World`:

    map
    scanned
    airbaseScanComplete
    zoneFactoryComplete
    status

Geplante Daten in `TC.State.Bases`:

    total
    blue
    red
    neutral
    contested
    registry

Geplante Daten in `TC.State.Zones`:

    total
    blue
    red
    neutral
    contested
    registry

Der genaue Datenaufbau wird mit den jeweiligen Lua-Dateien festgelegt.

---

## Anfangszustand der Kampagne

Für **Operation Levant Reclamation** gilt als Grundannahme:

    Blau startet auf Zypern / Akrotiri.
    Das syrische Festland ist zu Beginn rot kontrolliert.

Daraus folgt für den World-Bereich:

- Akrotiri ist die initiale blaue Startbasis.
- Zypern ist initial blauer Ausgangsraum.
- Syrische Festlandbasen werden initial als rot betrachtet, sofern keine spätere Ausnahme definiert wird.
- Neutrale oder Sonderbasen werden später ausdrücklich behandelt.

Diese Grundannahme dient nur der Initialisierung.

Die spätere Änderung des Besitzstatus gehört in das Capture-System unter `src/campaign/`.

---

## Abgrenzung

Nicht Aufgabe von `src/world/`:

    Basen erobern
    Zonen erobern
    Frontlinien entscheiden
    Logistiklieferungen auswerten
    FOBs bauen
    Missionen erzeugen
    CAPs starten
    IADS aktivieren
    Spielstände speichern
    F10-Menüs erzeugen

Diese Aufgaben gehören in andere Bereiche.

World liefert die Grundlage.

---

## Verbindung zu späteren Systemen

Spätere Systeme nutzen World-Daten.

Beispiele:

    Campaign nutzt Airbase- und Zonenstatus.
    Logistics nutzt Basen und Zonen für Versorgungslinien.
    Missions nutzt Airbases und Zonen für Zielauswahl.
    AI nutzt Airbases und Zonen für Reaktionslogik.
    IADS nutzt Zonen für Sektorlogik.
    UI nutzt World-Daten für Statusanzeigen.
    Debug nutzt World-Daten für Prüfausgaben.

World bleibt dabei die Datenquelle für Karten- und Raumstrukturen.

---

## Testziele

Der World-Bereich gilt später als funktionsfähig, wenn folgende Punkte erfüllt sind:

    TC.World ist vorhanden.
    TC.World.AirbaseScanner ist vorhanden.
    TC.World.ZoneFactory ist vorhanden.
    Airbases können erkannt werden.
    Akrotiri wird als blaue Startbasis erkannt.
    syrische Festlandbasen können initial rot markiert werden.
    Zonen können aus Basen oder Triggerzonen erzeugt werden.
    TC.State.Bases.registry wird gefüllt.
    TC.State.Zones.registry wird gefüllt.
    keine Lua-Fehler beim Missionsstart.
    keine Framework-Dateien werden verändert.

Erwartete spätere Beispielausgaben in `dcs.log`:

    [TC] World loading started
    [TC] Airbase scanner loaded
    [TC] Zone factory loaded
    [TC] Airbase scan completed
    [TC] Zone factory completed
    [TC] World initialized

---

## Entwicklungsregel

Der World-Bereich wird schrittweise aufgebaut.

Empfohlene Reihenfolge:

    1. src/world/README.md
    2. src/world/tc_airbase_scanner.lua
    3. src/world/tc_zone_factory.lua

Jede Datei wird einzeln erstellt und geprüft.

Keine parallelen Großbaustellen.

Keine All-in-one-Dateien.

---

## Zielbild

`src/world/` soll die DCS-Welt so erfassen, dass Theater Command DCS daraus eine dynamische Kampagne aufbauen kann.

Der World-Bereich ist damit die Brücke zwischen:

    Mission Editor
    DCS-Welt
    Theater-Command-Kampagnenzustand

Er sorgt dafür, dass spätere Systeme nicht direkt und unstrukturiert in der DCS-Welt suchen müssen.

Damit bleibt das Projekt:

    modular
    lesbar
    testbar
    erweiterbar
    wartbar

`src/world/` ist die Karten- und Raumgrundlage von **Theater Command DCS**.
