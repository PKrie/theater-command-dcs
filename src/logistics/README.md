# Logistics

Dieser Ordner enthält die Logistiksysteme von **Theater Command DCS**.

`src/logistics/` verbindet später den strategischen Kampagnenzustand mit spielbarer Logistik im Einsatzraum.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut. Blau startet auf **Zypern / Akrotiri**. Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Zweck von `src/logistics/`

`src/logistics/` ist für Versorgung, Lieferungen und FOB-Aufbau zuständig.

Geplante Aufgaben:

- Logistiklieferungen erfassen
- Logistiklieferungen bewerten
- FOB-Aufbau vorbereiten
- Versorgungslinien abbilden
- Logistikhubs verwalten
- CTLD-Ereignisse später in Theater-Command-Zustand übersetzen
- Capture-Fortschritt durch Versorgung ermöglichen
- Missionsgenerator und AI Director mit Logistikdaten versorgen

Der Logistics-Bereich entscheidet nicht eigenständig über den gesamten Kampagnenfortschritt.

Er liefert logistische Ereignisse und Zustände, die später von `src/campaign/`, `src/missions/` und `src/ai/` genutzt werden.

---

## Architekturregel

Externe Frameworks liegen unter:

    vendor/

Eigene Theater-Command-Logik liegt unter:

    src/

Der Logistics-Bereich gehört zur eigenen Theater-Command-Logik.

Frameworks werden nicht verändert.

Die Dateien in `src/logistics/` werden nach Aufgaben benannt, nicht nach Frameworks.

Nicht gewünscht:

    src/logistics/tc_ctld.lua
    src/logistics/tc_moose_logistics.lua
    src/logistics/tc_logistics_all_in_one.lua
    src/logistics/tc_ctld_all_in_one.lua

Gewünscht:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

Eine Logistics-Datei darf intern CTLD, MIST, MOOSE oder DCS-API nutzen.

Der Dateiname richtet sich aber immer nach der Theater-Command-Aufgabe.

---

## Geplante Dateien

Für `src/logistics/` sind zunächst folgende Dateien geplant:

    src/logistics/README.md
    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

Später können bei Bedarf weitere Dateien ergänzt werden, zum Beispiel:

    src/logistics/tc_logistics_hub.lua
    src/logistics/tc_supply_network.lua
    src/logistics/tc_convoy_delivery.lua
    src/logistics/tc_ctld_bridge.lua

Diese Zusatzdateien werden erst angelegt, wenn sie wirklich benötigt werden.

---

## `tc_logistics_delivery.lua`

`tc_logistics_delivery.lua` wird später Logistiklieferungen verwalten.

Geplante Aufgaben:

- Lieferungen annehmen
- Lieferungen prüfen
- Lieferungen bewerten
- Lieferstatus speichern
- Lieferungen mit Zonen verbinden
- Lieferungen mit Basen verbinden
- Lieferungen mit FOBs verbinden
- logistische Effekte an das Campaign-System melden

Mögliche spätere Lieferarten:

    SUPPLY
    FUEL
    AMMUNITION
    ENGINEERS
    AIR_DEFENSE
    FOB_PACKAGE
    REPAIR_PACKAGE

Das System soll später nicht einfach nur CTLD ausführen.

Es soll CTLD-Ereignisse in Theater-Command-Kampagnenlogik übersetzen.

---

## `tc_fob_system.lua`

`tc_fob_system.lua` wird später Forward Operating Bases verwalten.

Geplante Aufgaben:

- FOB-Aufbau vorbereiten
- FOB-Zustand speichern
- FOB-Besitzstatus verwalten
- FOB-Versorgung bewerten
- FOBs mit Zonen verbinden
- FOBs mit Logistiklieferungen verbinden
- FOBs für spätere Missionen nutzbar machen
- FOBs als Ausgangspunkt für Kampagnenfortschritt vorbereiten

Mögliche spätere FOB-Zustände:

    PLANNED
    UNDER_CONSTRUCTION
    ACTIVE
    DAMAGED
    OUT_OF_SUPPLY
    DESTROYED

Ein FOB ist ein strategisches Theater-Command-Objekt.

Es muss nicht zwingend identisch mit einem einzelnen DCS-Objekt sein.

---

## Beziehung zu CTLD

CTLD liegt extern unter:

    vendor/ctld/

CTLD wird nicht verändert.

Theater Command DCS nutzt CTLD später als Transport- und Logistikframework.

Die eigene Logik liegt aber unter:

    src/logistics/

Die geplante Trennung lautet:

    CTLD bewegt und spawnt logistische Objekte.
    Theater Command bewertet die logistische Bedeutung.

Beispiele:

    CTLD meldet eine abgesetzte Kiste.
    Theater Command prüft, in welcher Zone sie liegt.
    Theater Command prüft, ob sie zu einer Lieferung gehört.
    Theater Command aktualisiert den Logistikstatus.
    Theater Command meldet einen Effekt an Campaign, Missions oder AI.

---

## Beziehung zum Core

`src/logistics/` nutzt den Core.

Erlaubte Core-Abhängigkeiten:

    TC.Config
    TC.Logger
    TC.State
    TC.Utils
    TC.Scheduler

Der Logistics-Bereich darf davon ausgehen, dass der Core bereits geladen ist.

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

Logistics-Dateien dürfen deshalb auf Core-Funktionen zugreifen.

---

## Beziehung zum World-Bereich

Der Logistics-Bereich nutzt Daten aus:

    src/world/

Besonders wichtig sind:

    TC.World.AirbaseScanner
    TC.World.ZoneFactory
    TC.State.Bases
    TC.State.Zones

World liefert die räumliche Grundlage.

Logistics prüft später, wo Lieferungen stattfinden und welche Basen oder Zonen betroffen sind.

Logistics soll nicht selbst Airbases scannen.

Logistics soll nicht selbst Kampagnenzonen erzeugen.

---

## Beziehung zum Campaign-Bereich

Der Logistics-Bereich meldet logistische Auswirkungen an:

    src/campaign/

Besonders wichtig sind:

    TC.Campaign.CaptureSystem
    TC.Campaign.PersistenceSystem
    TC.State.Campaign
    TC.State.Logistics
    TC.State.Persistence

Mögliche spätere Effekte:

    Zone wird durch Versorgung stabilisiert.
    FOB wird aktiv.
    Basis erhält Nachschub.
    Capture-Bedingung wird erfüllt.
    Missionserfolg erzeugt logistische Lieferung.
    Lieferung verändert Kampagnenzustand.

Logistics löst nicht unkontrolliert Besitzwechsel aus.

Besitzwechsel bleiben Aufgabe des Capture-Systems.

---

## Geplanter Namespace

Der Logistics-Bereich wird später unter der zentralen Projekttabelle `TC` abgelegt.

Geplante Struktur:

    TC.Logistics
    ├── Delivery
    ├── FobSystem
    ├── Hubs
    ├── Deliveries
    └── SupplyNetwork

Die globale Projekttabelle bleibt:

    TC

Nicht verwenden:

    TheaterCommandLogistics
    LogisticsTC
    tc_logistics_global
    _G_TC_LOGISTICS

---

## Geplante State-Bereiche

Der Logistics-Bereich arbeitet später vor allem mit:

    TC.State.Logistics
    TC.State.Bases
    TC.State.Zones
    TC.State.Campaign
    TC.State.Persistence

Geplante Daten in `TC.State.Logistics`:

    enabled
    hubs
    deliveries
    fobs
    lastDeliveryId

Geplante Daten für Lieferungen:

    id
    type
    status
    owner
    sourceBase
    targetZone
    targetBase
    targetFob
    position
    createdAt
    deliveredAt
    effectApplied

Geplante Daten für FOBs:

    id
    name
    status
    owner
    linkedZone
    position
    supplyLevel
    createdAt
    activatedAt

Der genaue Datenaufbau wird mit den jeweiligen Lua-Dateien festgelegt.

---

## Anfangszustand der Kampagne

Für **Operation Levant Reclamation** gilt als Grundannahme:

    Blau startet auf Zypern / Akrotiri.
    Das syrische Festland ist zu Beginn rot kontrolliert.

Daraus folgt für den Logistics-Bereich:

- Akrotiri ist initial der wichtigste blaue Logistikhub.
- Zypern ist initial sicherer Ausgangsraum.
- syrische Festlandzonen benötigen später Versorgung, um dauerhaft nutzbar zu werden.
- FOBs auf dem Festland müssen später durch Lieferung, Mission oder Skriptlogik aufgebaut werden.
- Logistik soll den Vormarsch auf dem syrischen Festland unterstützen.

Die konkrete Logistikregel wird später einzeln implementiert.

---

## Logistik-Grundidee

Theater Command DCS soll Logistik nicht nur als Dekoration behandeln.

Logistik soll später strategische Bedeutung haben.

Beispiele:

    Eine Zone kann militärisch erobert sein, aber noch nicht versorgt.
    Ein FOB kann geplant sein, aber noch nicht aktiv.
    Eine Basis kann blau sein, aber ohne Nachschub eingeschränkt bleiben.
    Eine Mission kann neue Logistikoptionen freischalten.
    Ein verlorener Konvoi kann den Kampagnenfortschritt verzögern.

Damit wird Logistik ein eigener Kampagnenfaktor.

---

## Abgrenzung

Nicht Aufgabe von `src/logistics/`:

    Airbases aus DCS auslesen
    Zonen geometrisch erzeugen
    strategischen Besitz direkt festlegen
    Missionen generieren
    CAPs starten
    IADS-Netzwerke aufbauen
    F10-Menüs erzeugen
    Debug-Zeichnungen erzeugen
    Framework-Dateien verändern

Diese Aufgaben gehören in andere Bereiche.

Logistics verwaltet Versorgung, Lieferungen, FOBs und logistische Zustände.

---

## Verbindung zu späteren Systemen

Spätere Systeme nutzen Logistics-Daten.

Beispiele:

    Campaign nutzt Logistik als Capture-Bedingung.
    Missions erzeugt Versorgungsmissionen.
    AI reagiert auf wichtige Logistikbewegungen.
    IADS kann durch gelieferte Systeme verstärkt werden.
    UI zeigt Lieferstatus und FOB-Status an.
    Debug zeigt Logistikzustand und Lieferzonen an.
    Persistence speichert Lieferungen und FOBs.

Der Logistics-Bereich ist damit ein zentraler Baustein für dynamische Kampagnenentwicklung.

---

## Testziele

Der Logistics-Bereich gilt später als funktionsfähig, wenn folgende Punkte erfüllt sind:

    TC.Logistics ist vorhanden.
    TC.Logistics.Delivery ist vorhanden.
    TC.Logistics.FobSystem ist vorhanden.
    TC.State.Logistics wird korrekt vorbereitet.
    Lieferungen können angelegt werden.
    Lieferungen können bewertet werden.
    Lieferungen können als abgeschlossen markiert werden.
    FOBs können angelegt werden.
    FOBs können aktiviert werden.
    Logistikänderungen markieren den State als dirty.
    keine Lua-Fehler beim Missionsstart.
    keine Framework-Dateien werden verändert.

Erwartete spätere Beispielausgaben in `dcs.log`:

    [TC] Logistics loading started
    [TC] Logistics delivery loaded
    [TC] FOB system loaded
    [TC] Logistics initialized
    [TC] Delivery created: SUPPLY
    [TC] Delivery completed: SUPPLY
    [TC] FOB activated

---

## Entwicklungsregel

Der Logistics-Bereich wird schrittweise aufgebaut.

Empfohlene Reihenfolge:

    1. src/logistics/README.md
    2. src/logistics/tc_logistics_delivery.lua
    3. src/logistics/tc_fob_system.lua

Jede Datei wird einzeln erstellt und geprüft.

Keine parallelen Großbaustellen.

Keine All-in-one-Dateien.

---

## Zielbild

`src/logistics/` soll die Versorgungsebene von Theater Command DCS abbilden.

Der Logistics-Bereich ist die Verbindung zwischen:

    CTLD
    World-Daten
    Campaign-State
    Missionsergebnissen
    FOB-Aufbau
    Persistenz

Damit bleibt das Projekt:

    modular
    lesbar
    testbar
    erweiterbar
    wartbar

`src/logistics/` ist die Versorgungsschicht von **Theater Command DCS**.
