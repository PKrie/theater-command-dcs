# IADS

Dieser Ordner enthält die eigene Kampagnenlogik rund um Integrated Air Defense Systems für **Theater Command DCS**.

`src/iads/` verbindet später den strategischen Kampagnenzustand mit Skynet IADS.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut. Blau startet auf **Zypern / Akrotiri**. Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Zweck von `src/iads/`

`src/iads/` ist für die Theater-Command-Schicht über Skynet IADS zuständig.

Geplante Aufgaben:

- IADS-Netzwerke vorbereiten
- IADS-Sektoren definieren
- SAM-Standorte verwalten
- Radar-Standorte verwalten
- IADS-Zustand im Kampagnen-State speichern
- IADS-Sektoren mit Zonen verbinden
- IADS-Zustand mit Missionsgenerator verbinden
- IADS-Zustand mit AI-Reaktionen verbinden
- SEAD- und DEAD-Ziele vorbereiten
- spätere Skynet-IADS-Anbindung kapseln

Der IADS-Bereich verändert keine Skynet-Dateien.

Skynet IADS bleibt unter:

    vendor/skynet-iads/

Eigene Theater-Command-Logik liegt unter:

    src/iads/

---

## Architekturregel

Externe Frameworks liegen unter:

    vendor/

Eigene Theater-Command-Logik liegt unter:

    src/

Der IADS-Bereich gehört zur eigenen Theater-Command-Logik.

Frameworks werden nicht verändert.

Die Dateien in `src/iads/` werden nach Aufgaben benannt, nicht nach Frameworks.

Nicht gewünscht:

    src/iads/tc_skynet.lua
    src/iads/tc_skynet_iads.lua
    src/iads/tc_iads_all_in_one.lua
    src/iads/tc_iads_everything.lua

Gewünscht:

    src/iads/README.md

Spätere mögliche Dateien:

    src/iads/tc_iads_network.lua
    src/iads/tc_iads_sector_manager.lua
    src/iads/tc_iads_site_registry.lua
    src/iads/tc_iads_mission_bridge.lua

Diese Dateien werden erst angelegt, wenn sie wirklich benötigt werden.

---

## Beziehung zu Skynet IADS

Skynet IADS liegt extern unter:

    vendor/skynet-iads/SkynetIADS.lua

Skynet IADS wird nicht verändert.

Theater Command DCS nutzt Skynet IADS später als technisches Framework für Luftverteidigungsnetzwerke.

Die Trennung lautet:

    Skynet IADS verwaltet technische IADS-Funktionalität.
    Theater Command verwaltet Kampagnenzustand, Sektoren, Ziele und Folgen.

Beispiele:

    Skynet IADS aktiviert ein Netzwerk.
    Theater Command weiß, welchem Sektor dieses Netzwerk gehört.
    Theater Command weiß, welche Zone durch diesen Sektor geschützt wird.
    Theater Command erzeugt daraus SEAD- oder DEAD-Missionen.
    Theater Command speichert, ob ein Sektor beschädigt oder geschwächt wurde.

---

## Geplante Dateien

Für `src/iads/` ist zunächst nur diese Dokumentationsdatei geplant:

    src/iads/README.md

Spätere mögliche Implementierungsdateien:

    src/iads/tc_iads_network.lua
    src/iads/tc_iads_sector_manager.lua
    src/iads/tc_iads_site_registry.lua
    src/iads/tc_iads_mission_bridge.lua

Die konkrete Lua-Implementierung wird später separat begonnen.

---

## Geplante IADS-Aufgaben

Der spätere IADS-Bereich soll folgende Aufgaben übernehmen:

- IADS-Sektoren aus Kampagnenzonen ableiten
- SAM- und Radarstandorte registrieren
- IADS-Netzwerke initialisieren
- IADS-Sektoren aktivieren oder deaktivieren
- IADS-Status im State speichern
- beschädigte Luftverteidigung abbilden
- SEAD- und DEAD-Ziele für Missionsgenerator bereitstellen
- AI-Reaktionen durch IADS-Zustand beeinflussen
- Persistenzdaten für IADS vorbereiten

Die erste Version darf einfach sein.

Wichtig ist die saubere Trennung zwischen Skynet-Funktionalität und Theater-Command-Kampagnenlogik.

---

## Beziehung zum Core

`src/iads/` nutzt den Core.

Erlaubte Core-Abhängigkeiten:

    TC.Config
    TC.Logger
    TC.State
    TC.Utils
    TC.Scheduler

Der IADS-Bereich darf davon ausgehen, dass der Core bereits geladen ist.

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

IADS-Dateien dürfen deshalb auf Core-Funktionen zugreifen.

---

## Beziehung zum World-Bereich

Der IADS-Bereich nutzt Daten aus:

    src/world/

Besonders wichtig sind:

    TC.World.AirbaseScanner
    TC.World.ZoneFactory
    TC.State.Bases
    TC.State.Zones

World liefert die räumliche Grundlage.

IADS nutzt diese Daten für:

    Sektorzuordnung
    Schutzräume
    Radarbereiche
    SAM-Site-Bezug
    Zielräume
    Zonenstatus
    Frontnähe

IADS soll nicht selbst Airbases scannen.

IADS soll nicht selbst Kampagnenzonen erzeugen.

---

## Beziehung zum Campaign-Bereich

Der IADS-Bereich nutzt Daten aus:

    src/campaign/

Besonders wichtig sind:

    TC.Campaign.CaptureSystem
    TC.State.Campaign
    TC.State.Bases
    TC.State.Zones
    TC.State.Persistence

Campaign liefert den strategischen Besitzstatus.

IADS nutzt diesen Zustand für Sektorlogik.

Beispiele:

    rote Zonen können aktive rote IADS-Sektoren enthalten.
    blaue Zonen können später eigene Luftverteidigung erhalten.
    contested Zonen können geschwächte oder umkämpfte IADS-Strukturen enthalten.
    eroberte Zonen können IADS-Sektoren verlieren, deaktivieren oder umbauen.
    gespeicherte Kampagnenstände müssen IADS-Zustände wiederherstellen können.

Besitzwechsel bleiben Aufgabe des Capture-Systems.

---

## Beziehung zum Missionsbereich

Der IADS-Bereich liefert später Ziele und Zustände an:

    src/missions/

Besonders wichtig sind:

    TC.Missions.Generator
    TC.State.Missions
    TC.State.IADS

Mögliche Verbindungen:

    aktiver IADS-Sektor -> SEAD-Mission möglich
    aktives SAM-Ziel -> DEAD-Mission möglich
    Radarstandort aktiv -> IADS-Suppression möglich
    geschwächter Sektor -> Folgeangriff möglich
    zerstörter Standort -> Missionserfolg oder Kampagnenfortschritt möglich

Der Missionsgenerator erzeugt die Mission.

Der IADS-Bereich liefert den relevanten IADS-Zustand.

---

## Beziehung zum AI-Bereich

Der IADS-Bereich wird später Daten mit `src/ai/` austauschen.

Beispiele:

    starker IADS-Sektor erhöht rote Verteidigungspriorität.
    geschwächter IADS-Sektor kann rote CAP-Reaktion erhöhen.
    aktive SEAD-Mission kann AI-Reaktion auslösen.
    verlorene Radarabdeckung kann Luftlage und CAP-Bedarf verändern.
    IADS-Sektoren können AI-Reaktionsräume beeinflussen.

AI steuert Luftreaktionen.

IADS beschreibt die Luftverteidigungsstruktur.

---

## Geplanter Namespace

Der IADS-Bereich wird später unter der zentralen Projekttabelle `TC` abgelegt.

Geplante Struktur:

    TC.IADS
    ├── Network
    ├── Sectors
    ├── Sites
    ├── Radars
    └── MissionBridge

Die globale Projekttabelle bleibt:

    TC

Nicht verwenden:

    TheaterCommandIADS
    SkynetTC
    IadsTC
    tc_iads_global
    _G_TC_IADS

---

## Geplante State-Bereiche

Der IADS-Bereich arbeitet später vor allem mit:

    TC.State.IADS
    TC.State.Campaign
    TC.State.Bases
    TC.State.Zones
    TC.State.Missions
    TC.State.AI
    TC.State.Persistence

Geplante Daten in `TC.State.IADS`:

    enabled
    networks
    sectors
    sites
    radars
    lastUpdate
    activeSites
    damagedSites
    destroyedSites

Geplante Daten für IADS-Sektoren:

    id
    key
    name
    owner
    status
    linkedZone
    linkedBase
    network
    sites
    radars
    priority
    createdAt
    updatedAt

Geplante Daten für IADS-Sites:

    id
    key
    name
    type
    status
    owner
    linkedSector
    linkedZone
    position
    skynetName
    createdAt
    updatedAt

Der genaue Datenaufbau wird mit den späteren Lua-Dateien festgelegt.

---

## Anfangszustand der Kampagne

Für **Operation Levant Reclamation** gilt als Grundannahme:

    Blau startet auf Zypern / Akrotiri.
    Das syrische Festland ist zu Beginn rot kontrolliert.

Daraus folgt für den IADS-Bereich:

- syrische Festlandzonen können initial rote IADS-Sektoren enthalten.
- rote Luftverteidigung schützt zu Beginn das syrische Festland.
- Akrotiri und Zypern sind initial der blaue Ausgangsraum.
- blaue IADS-Strukturen werden später gesondert definiert.
- frühe SEAD- und DEAD-Missionen richten sich wahrscheinlich gegen rote Festland-IADS-Strukturen.

Die konkrete IADS-Konfiguration wird später einzeln implementiert.

---

## IADS-Grundidee

Theater Command DCS soll IADS nicht nur als statisches Missionsobjekt behandeln.

IADS soll später Teil des dynamischen Kampagnenzustands werden.

Beispiele:

    Ein aktiver IADS-Sektor erschwert Angriffe.
    Eine erfolgreiche SEAD-Mission schwächt einen Sektor.
    Eine erfolgreiche DEAD-Mission zerstört eine Site.
    Ein beschädigter Radarstandort reduziert Reaktionsfähigkeit.
    Eine eroberte Zone verändert die IADS-Zugehörigkeit.
    Ein gespeicherter Kampagnenstand stellt den IADS-Zustand wieder her.

Damit wird Luftverteidigung zu einem strategischen Faktor.

---

## Abgrenzung

Nicht Aufgabe von `src/iads/`:

    Airbases aus DCS auslesen
    Zonen geometrisch erzeugen
    Basenbesitz direkt festlegen
    Zonenbesitz direkt festlegen
    CTLD-Lieferungen auswerten
    FOBs bauen
    Missionen generieren
    CAPs dauerhaft verwalten
    F10-Menüs erzeugen
    Debug-Zeichnungen erzeugen
    Framework-Dateien verändern

Diese Aufgaben gehören in andere Bereiche.

IADS verwaltet die Theater-Command-Schicht rund um Luftverteidigung.

---

## Verbindung zu späteren Systemen

Spätere Systeme nutzen IADS-Daten.

Beispiele:

    Missions nutzt IADS-Ziele für SEAD und DEAD.
    AI nutzt IADS-Zustand für Reaktionen.
    Campaign nutzt IADS-Zustand für strategische Folgen.
    Logistics kann später Luftverteidigung verstärken.
    UI zeigt IADS-Sektoren und Bedrohungen an.
    Debug visualisiert IADS-Sektoren und Site-Zustände.
    Persistence speichert IADS-Zustände.

Der IADS-Bereich ist damit die Luftverteidigungsschicht von Theater Command DCS.

---

## Testziele

Der IADS-Bereich gilt später als funktionsfähig, wenn folgende Punkte erfüllt sind:

    TC.IADS ist vorhanden.
    TC.State.IADS wird korrekt vorbereitet.
    IADS-Sektoren können registriert werden.
    IADS-Sites können registriert werden.
    IADS-Zustände können gelesen werden.
    IADS-Zustände können verändert werden.
    SEAD- und DEAD-Ziele können vorbereitet werden.
    IADS-Änderungen markieren den State als dirty.
    keine Lua-Fehler beim Missionsstart.
    keine Framework-Dateien werden verändert.

Erwartete spätere Beispielausgaben in `dcs.log`:

    [TC] IADS loading started
    [TC] IADS network loaded
    [TC] IADS initialized
    [TC] IADS sector registered
    [TC] IADS site registered
    [TC] IADS sector weakened
    [TC] IADS site destroyed

---

## Entwicklungsregel

Der IADS-Bereich wird schrittweise aufgebaut.

Empfohlene Reihenfolge:

    1. src/iads/README.md
    2. spätere konkrete IADS-Implementierungsdatei nach Bedarf

Jede Datei wird einzeln erstellt und geprüft.

Keine parallelen Großbaustellen.

Keine All-in-one-Dateien.

---

## Zielbild

`src/iads/` soll die Luftverteidigungsschicht von Theater Command DCS abbilden.

Der IADS-Bereich ist die Verbindung zwischen:

    Skynet IADS
    World-Daten
    Campaign-State
    Missions
    AI-Reaktion
    Persistenz

Damit bleibt das Projekt:

    modular
    lesbar
    testbar
    erweiterbar
    wartbar

`src/iads/` ist die Luftverteidigungsschicht von **Theater Command DCS**.
