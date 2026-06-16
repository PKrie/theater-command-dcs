# AI

Dieser Ordner enthält die KI-Reaktionslogik von **Theater Command DCS**.

`src/ai/` steuert später dynamische feindliche und freundliche Reaktionen auf den aktuellen Kampagnenzustand.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut. Blau startet auf **Zypern / Akrotiri**. Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Zweck von `src/ai/`

`src/ai/` ist für dynamische KI-Reaktionen zuständig.

Geplante Aufgaben:

- AI Director vorbereiten
- CAP-Manager vorbereiten
- GCI-Logik vorbereiten
- feindliche Reaktionen auf Missionen vorbereiten
- freundliche Unterstützung vorbereiten
- Eskalationslogik vorbereiten
- Verstärkungen vorbereiten
- Luftlage dynamisch anpassen
- spätere Verbindung zu MOOSE-Dispatcher-Systemen herstellen

Der AI-Bereich entscheidet nicht selbst über den strategischen Besitz von Basen oder Zonen.

Diese Daten kommen aus:

    src/campaign/
    src/world/

Der AI-Bereich nutzt diese Daten, um glaubwürdige Reaktionen zu erzeugen.

---

## Architekturregel

Externe Frameworks liegen unter:

    vendor/

Eigene Theater-Command-Logik liegt unter:

    src/

Der AI-Bereich gehört zur eigenen Theater-Command-Logik.

Frameworks werden nicht verändert.

Die Dateien in `src/ai/` werden nach Aufgaben benannt, nicht nach Frameworks.

Nicht gewünscht:

    src/ai/tc_moose.lua
    src/ai/tc_moose_ai.lua
    src/ai/tc_ai_all_in_one.lua
    src/ai/tc_dispatcher_all_in_one.lua

Gewünscht:

    src/ai/tc_ai_cap_manager.lua

Eine AI-Datei darf intern MOOSE, MIST oder DCS-API nutzen.

Der Dateiname richtet sich aber immer nach der Theater-Command-Aufgabe.

---

## Geplante Dateien

Für `src/ai/` sind zunächst folgende Dateien geplant:

    src/ai/README.md
    src/ai/tc_ai_cap_manager.lua

Später können bei Bedarf weitere Dateien ergänzt werden, zum Beispiel:

    src/ai/tc_ai_director.lua
    src/ai/tc_ai_gci_manager.lua
    src/ai/tc_ai_reinforcement_manager.lua
    src/ai/tc_ai_escalation.lua

Diese Zusatzdateien werden erst angelegt, wenn sie wirklich benötigt werden.

---

## `tc_ai_cap_manager.lua`

`tc_ai_cap_manager.lua` wird später Combat Air Patrols verwalten.

Geplante Aufgaben:

- CAP-Zonen bestimmen
- CAP-Bedarf aus Kampagnenzustand ableiten
- rote CAPs über kontrollierten roten Gebieten vorbereiten
- blaue CAPs über kontrollierten blauen Gebieten vorbereiten
- CAP-Status im State speichern
- spätere MOOSE-Anbindung vorbereiten
- spätere Verbindung zum Missionsgenerator herstellen
- spätere Verbindung zu IADS und AI Director herstellen

Der CAP-Manager soll keine Basen scannen.

Der CAP-Manager soll keine Zonen erzeugen.

Der CAP-Manager soll keine Kampagnenbesitzstände direkt ändern.

Er steuert nur KI-Luftreaktionen auf Grundlage vorhandener Daten.

---

## Beziehung zu MOOSE

MOOSE liegt extern unter:

    vendor/moose/Moose.lua

MOOSE wird nicht verändert.

Theater Command DCS nutzt MOOSE später für komplexe KI-Steuerung.

Mögliche spätere MOOSE-Bereiche:

    SET_GROUP
    SET_ZONE
    ZONE
    SPAWN
    AI_A2A_DISPATCHER
    DETECTION_AREAS
    AI_CAP_ZONE

Die genaue MOOSE-Nutzung wird erst in der jeweiligen AI-Datei umgesetzt.

Wichtig ist die Trennung:

    MOOSE stellt technische KI-Funktionen bereit.
    Theater Command entscheidet, wann und warum KI reagieren soll.

---

## Beziehung zum Core

`src/ai/` nutzt den Core.

Erlaubte Core-Abhängigkeiten:

    TC.Config
    TC.Logger
    TC.State
    TC.Utils
    TC.Scheduler

Der AI-Bereich darf davon ausgehen, dass der Core bereits geladen ist.

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

AI-Dateien dürfen deshalb auf Core-Funktionen zugreifen.

---

## Beziehung zum World-Bereich

Der AI-Bereich nutzt Daten aus:

    src/world/

Besonders wichtig sind:

    TC.World.AirbaseScanner
    TC.World.ZoneFactory
    TC.State.Bases
    TC.State.Zones

World liefert die räumliche Grundlage.

AI nutzt diese Daten für:

    CAP-Zonen
    Startbasen
    Zielgebiete
    Reaktionsräume
    Frontnähe
    Luftraumprioritäten

AI soll nicht selbst Airbases scannen.

AI soll nicht selbst Kampagnenzonen erzeugen.

---

## Beziehung zum Campaign-Bereich

Der AI-Bereich nutzt Daten aus:

    src/campaign/

Besonders wichtig sind:

    TC.Campaign.CaptureSystem
    TC.State.Campaign
    TC.State.Bases
    TC.State.Zones

Campaign liefert den strategischen Zustand.

AI nutzt diesen Zustand für Reaktionen.

Beispiele:

    rote Zonen erzeugen rote Verteidigungsprioritäten
    blaue Zonen erzeugen blaue Schutzprioritäten
    contested Zonen erzeugen erhöhte Luftaktivität
    neu eroberte Zonen können Gegenangriffe auslösen
    strategisch wichtige Basen erhalten stärkere CAP-Abdeckung

Besitzwechsel bleiben Aufgabe des Capture-Systems.

---

## Beziehung zum Missionsbereich

Der AI-Bereich nutzt Daten aus:

    src/missions/

Besonders wichtig sind:

    TC.Missions.Generator
    TC.State.Missions

Missionen können AI-Reaktionen auslösen.

Beispiele:

    aktive Strike-Mission erhöht feindliche CAP-Wahrscheinlichkeit
    aktive SEAD-Mission kann IADS-Reaktion auslösen
    aktive Logistics-Mission kann Intercept- oder CAP-Druck erzeugen
    abgeschlossene Missionen können Eskalation oder Entlastung bewirken

Der AI-Bereich soll Missionen nicht selbst erzeugen.

Das bleibt Aufgabe des Missionsgenerators.

---

## Beziehung zum IADS-Bereich

Der AI-Bereich wird später eng mit `src/iads/` verbunden.

Beispiele:

    IADS-Sektor aktiv -> höhere CAP-Priorität
    IADS-Sektor geschwächt -> weniger rote Luftdeckung
    SEAD-/DEAD-Druck -> veränderte AI-Reaktion
    Radarstandorte können CAP-Reaktion beeinflussen

Skynet IADS selbst bleibt unter:

    vendor/skynet-iads/

Eigene IADS-Kampagnenlogik liegt später unter:

    src/iads/

---

## Geplanter Namespace

Der AI-Bereich wird später unter der zentralen Projekttabelle `TC` abgelegt.

Geplante Struktur:

    TC.AI
    ├── CapManager
    ├── Director
    ├── GciManager
    ├── ReinforcementManager
    └── Escalation

Die globale Projekttabelle bleibt:

    TC

Nicht verwenden:

    TheaterCommandAI
    AiTC
    tc_ai_global
    _G_TC_AI

---

## Geplante State-Bereiche

Der AI-Bereich arbeitet später vor allem mit:

    TC.State.AI
    TC.State.Campaign
    TC.State.Bases
    TC.State.Zones
    TC.State.Missions
    TC.State.IADS

Geplante Daten in `TC.State.AI`:

    enabled
    directorEnabled
    capManagerEnabled
    lastUpdate
    threatLevel
    capZones
    activeCaps
    reactionState
    escalationLevel

Geplante Daten für CAPs:

    id
    key
    side
    status
    zone
    sourceBase
    priority
    spawnedGroup
    createdAt
    activatedAt
    completedAt

Der genaue Datenaufbau wird mit `tc_ai_cap_manager.lua` festgelegt.

---

## Anfangszustand der Kampagne

Für **Operation Levant Reclamation** gilt als Grundannahme:

    Blau startet auf Zypern / Akrotiri.
    Das syrische Festland ist zu Beginn rot kontrolliert.

Daraus folgt für den AI-Bereich:

- blaue CAPs schützen zunächst Akrotiri und den zyprischen Ausgangsraum.
- rote CAPs schützen zunächst syrische Festlandzonen und wichtige rote Basen.
- feindliche Luftreaktionen sollen zu Beginn stärker vom Festland ausgehen.
- blaue Luftaktivität wird zunächst aus Akrotiri heraus gedacht.
- spätere FOBs und eroberte Basen können neue Reaktionsräume ermöglichen.

Die konkrete CAP-Logik wird später einzeln implementiert.

---

## AI-Grundidee

Die KI soll nicht statisch sein.

Sie soll auf den Kampagnenzustand reagieren.

Beispiele:

    Wenn Blau eine Zone erobert, steigt dort rote Reaktionswahrscheinlichkeit.
    Wenn eine rote Airbase bedroht wird, kann rote CAP verstärkt werden.
    Wenn eine Logistics-Mission aktiv ist, kann feindlicher Luftdruck entstehen.
    Wenn ein IADS-Sektor geschwächt ist, kann die rote Verteidigung abnehmen.
    Wenn Blau Fortschritt macht, kann die Kampagne eskalieren.

Die erste Version darf einfach sein.

Wichtig ist, dass die Struktur dynamisch und erweiterbar bleibt.

---

## Abgrenzung

Nicht Aufgabe von `src/ai/`:

    Airbases aus DCS auslesen
    Zonen geometrisch erzeugen
    Basenbesitz direkt festlegen
    Zonenbesitz direkt festlegen
    CTLD-Lieferungen auswerten
    FOBs bauen
    Missionen generieren
    IADS-Netzwerke aufbauen
    F10-Menüs erzeugen
    Debug-Zeichnungen erzeugen
    Framework-Dateien verändern

Diese Aufgaben gehören in andere Bereiche.

AI reagiert auf vorhandene Kampagnendaten.

---

## Verbindung zu späteren Systemen

Spätere Systeme nutzen AI-Daten.

Beispiele:

    Missions kann AI-Reaktion abhängig vom Auftrag berücksichtigen.
    IADS kann AI-Reaktionsräume beeinflussen.
    UI kann aktive CAPs und Bedrohungsniveau anzeigen.
    Debug kann AI-Zustand sichtbar machen.
    Persistence speichert AI-Zustand und Eskalation.
    Campaign kann Eskalationslevel bewerten.

Der AI-Bereich ist damit die Reaktionsschicht von Theater Command DCS.

---

## Testziele

Der AI-Bereich gilt später als funktionsfähig, wenn folgende Punkte erfüllt sind:

    TC.AI ist vorhanden.
    TC.AI.CapManager ist vorhanden.
    TC.State.AI wird korrekt vorbereitet.
    CAP-Zonen können bestimmt werden.
    CAP-Bedarf kann aus State-Daten abgeleitet werden.
    CAPs können als State-Objekte angelegt werden.
    CAPs können aktiviert werden.
    CAPs können beendet werden.
    keine Lua-Fehler beim Missionsstart.
    keine Framework-Dateien werden verändert.

Erwartete spätere Beispielausgaben in `dcs.log`:

    [TC] AI loading started
    [TC] AI CAP manager loaded
    [TC] AI initialized
    [TC] CAP zone registered
    [TC] CAP requested
    [TC] CAP activated
    [TC] CAP completed

---

## Entwicklungsregel

Der AI-Bereich wird schrittweise aufgebaut.

Empfohlene Reihenfolge:

    1. src/ai/README.md
    2. src/ai/tc_ai_cap_manager.lua

Jede Datei wird einzeln erstellt und geprüft.

Keine parallelen Großbaustellen.

Keine All-in-one-Dateien.

---

## Zielbild

`src/ai/` soll dynamische KI-Reaktionen aus dem strategischen Kampagnenzustand ableiten.

Der AI-Bereich ist die Verbindung zwischen:

    World-Daten
    Campaign-State
    Missions
    IADS
    MOOSE-KI-Steuerung
    Eskalation
    Persistenz

Damit bleibt das Projekt:

    modular
    lesbar
    testbar
    erweiterbar
    wartbar

`src/ai/` ist die Reaktionsschicht von **Theater Command DCS**.
