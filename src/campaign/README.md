# Campaign

Dieser Ordner enthält die strategische Kampagnenlogik von **Theater Command DCS**.

`src/campaign/` entscheidet später, wie sich der Kampagnenzustand verändert.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut. Blau startet auf **Zypern / Akrotiri**. Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Zweck von `src/campaign/`

`src/campaign/` ist für den strategischen Zustand der Kampagne zuständig.

Geplante Aufgaben:

- Besitzstatus von Basen verwalten
- Besitzstatus von Zonen verwalten
- Capture-Logik abbilden
- Kampagnenfortschritt bewerten
- Zustandsänderungen an andere Systeme melden
- Persistenz vorbereiten
- spätere Save-/Load-Logik anbinden

Der Campaign-Bereich entscheidet nicht, welche Airbases in der DCS-Welt existieren.

Diese Daten kommen aus:

    src/world/

Der Campaign-Bereich entscheidet, was diese Daten strategisch bedeuten.

---

## Architekturregel

Externe Frameworks liegen unter:

    vendor/

Eigene Theater-Command-Logik liegt unter:

    src/

Der Campaign-Bereich gehört zur eigenen Theater-Command-Logik.

Frameworks werden nicht verändert.

Die Dateien in `src/campaign/` werden nach Aufgaben benannt, nicht nach Frameworks.

Nicht gewünscht:

    src/campaign/tc_moose_campaign.lua
    src/campaign/tc_mist_campaign.lua
    src/campaign/tc_campaign_all_in_one.lua
    src/campaign/tc_capture_and_persistence_all_in_one.lua

Gewünscht:

    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua

Eine Campaign-Datei darf intern DCS-API, MIST, MOOSE, CTLD oder Skynet-IADS-Daten nutzen.

Der Dateiname richtet sich aber immer nach der Theater-Command-Aufgabe.

---

## Geplante Dateien

Für `src/campaign/` sind zunächst folgende Dateien geplant:

    src/campaign/README.md
    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua

Später können bei Bedarf weitere Dateien ergänzt werden, zum Beispiel:

    src/campaign/tc_campaign_events.lua
    src/campaign/tc_campaign_progress.lua
    src/campaign/tc_ownership_rules.lua

Diese Zusatzdateien werden erst angelegt, wenn sie wirklich benötigt werden.

---

## `tc_capture_system.lua`

`tc_capture_system.lua` wird später den Besitzwechsel von Basen und Zonen verwalten.

Geplante Aufgaben:

- Besitzstatus von Zonen lesen
- Besitzstatus von Basen lesen
- Capture-Bedingungen prüfen
- Zonenbesitz ändern
- Basenbesitz ändern
- strategische Folgen auslösen
- veränderte Zustände im `TC.State` speichern
- spätere Verbindung zu Logistik, Missionen und AI Director vorbereiten

Das Capture-System ist ein strategisches System.

Es scannt keine Airbases selbst.

Es erzeugt keine Zonen selbst.

Es arbeitet mit Daten aus:

    TC.State.Bases
    TC.State.Zones
    TC.World.AirbaseScanner
    TC.World.ZoneFactory

---

## `tc_persistence_system.lua`

`tc_persistence_system.lua` wird später den Kampagnenzustand speichern und laden.

Geplante Aufgaben:

- aktuellen Kampagnenzustand exportieren
- gespeicherten Kampagnenzustand importieren
- Besitzstatus von Basen wiederherstellen
- Besitzstatus von Zonen wiederherstellen
- Missionsstatus wiederherstellen
- Logistikstatus wiederherstellen
- IADS-Zustand wiederherstellen
- einfache Save-/Load-Struktur vorbereiten

Persistenz ist ein späterer Projektschritt.

Zu Beginn wird nur die Struktur vorbereitet.

Das System darf später nur eigene Theater-Command-Daten speichern.

Externe Framework-Dateien werden nicht verändert.

---

## Beziehung zum Core

`src/campaign/` nutzt den Core.

Erlaubte Core-Abhängigkeiten:

    TC.Config
    TC.Logger
    TC.State
    TC.Utils
    TC.Scheduler

Der Campaign-Bereich darf davon ausgehen, dass der Core bereits geladen ist.

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

Campaign-Dateien dürfen deshalb auf Core-Funktionen zugreifen.

---

## Beziehung zum World-Bereich

Der Campaign-Bereich nutzt Daten aus:

    src/world/

Besonders wichtig sind:

    TC.World.AirbaseScanner
    TC.World.ZoneFactory
    TC.State.Bases
    TC.State.Zones

World liefert die räumliche Grundlage.

Campaign entscheidet über den strategischen Besitz und Fortschritt.

World soll nicht wissen müssen, wie Capture-Logik funktioniert.

Campaign soll nicht selbst Airbases scannen oder Zonen erzeugen.

---

## Geplanter Namespace

Der Campaign-Bereich wird später unter der zentralen Projekttabelle `TC` abgelegt.

Geplante Struktur:

    TC.Campaign
    ├── CaptureSystem
    ├── PersistenceSystem
    ├── Events
    └── Progress

Die globale Projekttabelle bleibt:

    TC

Nicht verwenden:

    TheaterCommandCampaign
    CampaignTC
    tc_campaign_global
    _G_TC_CAMPAIGN

---

## Geplante State-Bereiche

Der Campaign-Bereich arbeitet später vor allem mit:

    TC.State.Campaign
    TC.State.Bases
    TC.State.Zones
    TC.State.Persistence

Geplante Daten in `TC.State.Campaign`:

    name
    map
    phase
    blueStartRegion
    blueStartBase
    initialBlueTerritory
    initialRedTerritory
    initialFrontlineState
    isRunning
    isPaused
    tick

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

Geplante Daten in `TC.State.Persistence`:

    enabled
    dirty
    lastSaveTime
    lastLoadTime
    saveName

Der genaue Datenaufbau wird mit den jeweiligen Lua-Dateien weiter konkretisiert.

---

## Anfangszustand der Kampagne

Für **Operation Levant Reclamation** gilt als Grundannahme:

    Blau startet auf Zypern / Akrotiri.
    Das syrische Festland ist zu Beginn rot kontrolliert.

Daraus folgt für den Campaign-Bereich:

- Akrotiri ist initial blau.
- Zypern ist initial blauer Ausgangsraum.
- syrische Festlandbasen sind initial rot.
- syrische Festlandzonen sind initial rot.
- neutrale Sonderfälle werden später ausdrücklich definiert.
- Besitzwechsel erfolgen später nur über definierte Capture-Regeln.

Diese Grundannahme darf nicht hart in mehrere Systeme verteilt werden.

Sie soll zentral über State, Config und Campaign-Logik kontrollierbar bleiben.

---

## Capture-Grundidee

Das Capture-System soll später nicht einfach nur DCS-Airbase-Koalitionen übernehmen.

Theater Command DCS braucht einen eigenen strategischen Besitzstatus.

Beispiel:

    DCS-Airbase-Koalition: technisch im Mission Editor gesetzt
    TC-Besitzstatus: strategischer Kampagnenzustand

Diese Trennung ist wichtig, weil die Kampagne später persistent und dynamisch werden soll.

Ein Besitzwechsel kann später ausgelöst werden durch:

    erfolgreiche Missionen
    zerstörte Verteidigung
    Logistiklieferungen
    FOB-Aufbau
    Bodeneinheiten im Gebiet
    Skript-Events
    manuelle Debug-Befehle
    gespeicherte Kampagnenstände

Die konkrete Capture-Regel wird später einzeln implementiert.

---

## Persistenz-Grundidee

Die Persistenz soll später speichern, was Theater Command DCS strategisch verändert hat.

Beispiele:

    welche Basen blau sind
    welche Basen rot sind
    welche Zonen kontrolliert werden
    welche Missionen abgeschlossen sind
    welche FOBs existieren
    welche Logistiklieferungen erfolgt sind
    welcher IADS-Zustand gilt

Nicht gespeichert werden sollen unnötige temporäre DCS-Objekte.

Persistenz speichert den Kampagnenzustand, nicht jeden kurzlebigen Simulationszustand.

---

## Abgrenzung

Nicht Aufgabe von `src/campaign/`:

    Airbases aus DCS auslesen
    Zonen geometrisch erzeugen
    CTLD-Logistik direkt abwickeln
    FOBs physisch spawnen
    Missionen generieren
    CAPs starten
    IADS-Netzwerke aufbauen
    F10-Menüs erzeugen
    Debug-Zeichnungen erzeugen

Diese Aufgaben gehören in andere Bereiche.

Campaign entscheidet über strategischen Besitz, Fortschritt und Speicherzustand.

---

## Verbindung zu späteren Systemen

Spätere Systeme nutzen oder verändern Campaign-Daten.

Beispiele:

    Logistics kann Capture-Fortschritt durch Versorgung ermöglichen.
    Missions kann Missionen abhängig vom Besitzstatus erzeugen.
    AI kann auf Besitzwechsel reagieren.
    IADS kann Sektoren abhängig vom Besitzstatus aktivieren.
    UI kann Kampagnenstatus anzeigen.
    Debug kann Besitzstatus sichtbar machen.
    Persistence kann Campaign-State speichern und laden.

Der Campaign-Bereich ist damit das strategische Zentrum der dynamischen Kampagne.

---

## Testziele

Der Campaign-Bereich gilt später als funktionsfähig, wenn folgende Punkte erfüllt sind:

    TC.Campaign ist vorhanden.
    TC.Campaign.CaptureSystem ist vorhanden.
    TC.Campaign.PersistenceSystem ist vorhanden.
    Besitzstatus von Basen kann gelesen werden.
    Besitzstatus von Zonen kann gelesen werden.
    Besitzstatus von Basen kann geändert werden.
    Besitzstatus von Zonen kann geändert werden.
    Änderungen werden in TC.State gespeichert.
    Persistence kann einen State-Snapshot vorbereiten.
    keine Lua-Fehler beim Missionsstart.
    keine Framework-Dateien werden verändert.

Erwartete spätere Beispielausgaben in `dcs.log`:

    [TC] Campaign loading started
    [TC] Capture system loaded
    [TC] Persistence system loaded
    [TC] Campaign initialized
    [TC] Zone captured: ZONE_AIRBASE_AKROTIRI [BLUE]
    [TC] Base captured: AKROTIRI [BLUE]

---

## Entwicklungsregel

Der Campaign-Bereich wird schrittweise aufgebaut.

Empfohlene Reihenfolge:

    1. src/campaign/README.md
    2. src/campaign/tc_capture_system.lua
    3. src/campaign/tc_persistence_system.lua

Jede Datei wird einzeln erstellt und geprüft.

Keine parallelen Großbaustellen.

Keine All-in-one-Dateien.

---

## Zielbild

`src/campaign/` soll den strategischen Kampagnenzustand von Theater Command DCS verwalten.

Der Campaign-Bereich ist die Verbindung zwischen:

    World-Daten
    Missionsergebnissen
    Logistik
    AI-Reaktionen
    IADS-Zustand
    Persistenz

Damit bleibt das Projekt:

    modular
    lesbar
    testbar
    erweiterbar
    wartbar

`src/campaign/` ist das strategische Herz von **Theater Command DCS**.
