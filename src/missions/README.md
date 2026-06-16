# Missions

Dieser Ordner enthält die dynamische Missionsgenerierung von **Theater Command DCS**.

`src/missions/` erzeugt später spielbare Aufträge aus dem aktuellen Kampagnenzustand.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut. Blau startet auf **Zypern / Akrotiri**. Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Zweck von `src/missions/`

`src/missions/` ist für die Erstellung, Verwaltung und Bewertung dynamischer Missionen zuständig.

Geplante Aufgaben:

- verfügbare Missionsarten verwalten
- Missionen aus Kampagnenzustand erzeugen
- Ziele anhand von Basen, Zonen und Frontlage auswählen
- Missionen aktivieren
- Missionserfolg bewerten
- Missionsfehlschlag bewerten
- Missionsstatus im State speichern
- Folgeeffekte an Campaign, Logistics, AI und IADS melden

Der Missionsbereich entscheidet nicht selbst, wem eine Basis oder Zone gehört.

Diese Daten kommen aus:

    src/campaign/
    src/world/

Der Missionsbereich nutzt diese Daten, um sinnvolle Aufträge zu erzeugen.

---

## Architekturregel

Externe Frameworks liegen unter:

    vendor/

Eigene Theater-Command-Logik liegt unter:

    src/

Der Missionsbereich gehört zur eigenen Theater-Command-Logik.

Frameworks werden nicht verändert.

Die Dateien in `src/missions/` werden nach Aufgaben benannt, nicht nach Frameworks.

Nicht gewünscht:

    src/missions/tc_moose_missions.lua
    src/missions/tc_mist_missions.lua
    src/missions/tc_mission_all_in_one.lua
    src/missions/tc_dynamic_everything.lua

Gewünscht:

    src/missions/tc_mission_generator.lua

Eine Missionsdatei darf intern DCS-API, MIST, MOOSE, CTLD oder Skynet-IADS-Daten nutzen.

Der Dateiname richtet sich aber immer nach der Theater-Command-Aufgabe.

---

## Geplante Dateien

Für `src/missions/` sind zunächst folgende Dateien geplant:

    src/missions/README.md
    src/missions/tc_mission_generator.lua

Später können bei Bedarf weitere Dateien ergänzt werden, zum Beispiel:

    src/missions/tc_mission_registry.lua
    src/missions/tc_mission_types.lua
    src/missions/tc_mission_evaluator.lua
    src/missions/tc_target_selector.lua

Diese Zusatzdateien werden erst angelegt, wenn sie wirklich benötigt werden.

---

## `tc_mission_generator.lua`

`tc_mission_generator.lua` wird später die zentrale Missionsgenerierung übernehmen.

Geplante Aufgaben:

- aktuelle Kampagnenlage lesen
- verfügbare Zielzonen erkennen
- mögliche Missionsarten bestimmen
- Missionen erzeugen
- Missionen in `TC.State.Missions` speichern
- aktive Missionen verwalten
- abgeschlossene Missionen archivieren
- fehlgeschlagene Missionen speichern
- Folgeeffekte vorbereiten

Der Missionsgenerator soll keine Airbases scannen.

Der Missionsgenerator soll keine Zonen erzeugen.

Der Missionsgenerator soll keine Basen direkt erobern.

Er erzeugt und bewertet Missionen.

Strategische Besitzänderungen bleiben Aufgabe des Capture-Systems.

---

## Geplante Missionsarten

Für **Operation Levant Reclamation** sind später unter anderem folgende Missionsarten denkbar:

    RECON
    STRIKE
    SEAD
    DEAD
    CAS
    INTERDICTION
    ESCORT
    CAP
    LOGISTICS
    FOB_SUPPORT
    AIRBASE_ATTACK
    IADS_SUPPRESSION

Diese Liste ist noch nicht endgültig.

Die konkrete Umsetzung erfolgt schrittweise.

---

## Beziehung zum Core

`src/missions/` nutzt den Core.

Erlaubte Core-Abhängigkeiten:

    TC.Config
    TC.Logger
    TC.State
    TC.Utils
    TC.Scheduler

Der Missionsbereich darf davon ausgehen, dass der Core bereits geladen ist.

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

Missionsdateien dürfen deshalb auf Core-Funktionen zugreifen.

---

## Beziehung zum World-Bereich

Der Missionsbereich nutzt Daten aus:

    src/world/

Besonders wichtig sind:

    TC.World.AirbaseScanner
    TC.World.ZoneFactory
    TC.State.Bases
    TC.State.Zones

World liefert die räumliche Grundlage.

Missions nutzt diese Daten für:

    Zielauswahl
    Missionsradius
    Start- und Zielgebiete
    Frontnähe
    Airbase-Bezug
    Zonen-Bezug

Missions soll nicht selbst Airbases scannen.

Missions soll nicht selbst Kampagnenzonen erzeugen.

---

## Beziehung zum Campaign-Bereich

Der Missionsbereich nutzt Daten aus:

    src/campaign/

Besonders wichtig sind:

    TC.Campaign.CaptureSystem
    TC.Campaign.PersistenceSystem
    TC.State.Campaign
    TC.State.Bases
    TC.State.Zones

Campaign liefert den strategischen Zustand.

Missions nutzt diesen Zustand, um passende Aufträge zu erzeugen.

Beispiele:

    rote Zone nahe blauer Zone wird mögliches Angriffsziel
    blaue Zone mit schwacher Logistik wird mögliches Versorgungsziel
    contested Zone wird mögliches CAS- oder Interdiction-Ziel
    rote Airbase wird mögliches Strike- oder SEAD-Ziel

Besitzwechsel bleiben Aufgabe des Capture-Systems.

---

## Beziehung zum Logistics-Bereich

Der Missionsbereich nutzt Daten aus:

    src/logistics/

Besonders wichtig sind:

    TC.Logistics.Delivery
    TC.Logistics.FobSystem
    TC.State.Logistics

Logistik kann spätere Missionen beeinflussen.

Beispiele:

    FOB-Aufbau erzeugt Versorgungsmission
    Munitionsmangel erzeugt Nachschubmission
    beschädigte Basis erzeugt Reparaturmission
    aktive FOBs ermöglichen Missionen weiter im Landesinneren

Missions erzeugt Aufträge.

Logistics bewertet logistische Lieferungen.

---

## Beziehung zum AI- und IADS-Bereich

Der Missionsbereich wird später Daten liefern an:

    src/ai/
    src/iads/

Beispiele:

    AI Director reagiert auf aktive Missionen.
    CAP-Manager schützt wichtige Gebiete.
    IADS-System markiert SAM- und Radarziele.
    SEAD- oder DEAD-Missionen nutzen IADS-Zustand.
    feindliche Reaktion kann abhängig vom Missionstyp erfolgen.

Diese Systeme werden später separat aufgebaut.

---

## Geplanter Namespace

Der Missionsbereich wird später unter der zentralen Projekttabelle `TC` abgelegt.

Geplante Struktur:

    TC.Missions
    ├── Generator
    ├── Registry
    ├── Types
    ├── Evaluator
    └── TargetSelector

Die globale Projekttabelle bleibt:

    TC

Nicht verwenden:

    TheaterCommandMissions
    MissionsTC
    tc_missions_global
    _G_TC_MISSIONS

---

## Geplante State-Bereiche

Der Missionsbereich arbeitet später vor allem mit:

    TC.State.Missions
    TC.State.Campaign
    TC.State.Bases
    TC.State.Zones
    TC.State.Logistics
    TC.State.IADS

Geplante Daten in `TC.State.Missions`:

    enabled
    available
    active
    completed
    failed
    lastMissionId

Geplante Daten für einzelne Missionen:

    id
    key
    name
    type
    status
    owner
    targetZone
    targetBase
    targetIadsSite
    sourceBase
    priority
    createdAt
    activatedAt
    completedAt
    failedAt
    effectApplied

Der genaue Datenaufbau wird mit `tc_mission_generator.lua` festgelegt.

---

## Anfangszustand der Kampagne

Für **Operation Levant Reclamation** gilt als Grundannahme:

    Blau startet auf Zypern / Akrotiri.
    Das syrische Festland ist zu Beginn rot kontrolliert.

Daraus folgt für den Missionsbereich:

- erste Missionen starten aus dem blauen Ausgangsraum.
- Akrotiri ist die wichtigste blaue Startbasis.
- frühe Ziele liegen wahrscheinlich an der syrischen Küste oder im westlichen Festlandbereich.
- rote Festlandbasen und rote Zonen werden potenzielle Missionsziele.
- Logistikmissionen unterstützen später den Aufbau von FOBs.
- SEAD-/DEAD-Missionen werden später mit dem IADS-Zustand verbunden.

Die konkrete Missionslogik wird später einzeln implementiert.

---

## Missions-Grundidee

Der Missionsgenerator soll keine feste lineare Missionsliste sein.

Er soll aus dem Kampagnenzustand dynamische Aufträge erzeugen.

Beispiele:

    Wenn eine rote Zone an eine blaue Zone grenzt, kann ein Angriffsziel entstehen.
    Wenn eine Zone erobert wurde, kann eine Logistikmission entstehen.
    Wenn ein FOB im Aufbau ist, kann eine FOB-Support-Mission entstehen.
    Wenn ein IADS-Sektor aktiv ist, kann eine SEAD-Mission entstehen.
    Wenn rote Luftaktivität zunimmt, kann eine CAP-Mission entstehen.

Die erste Version darf einfach sein.

Wichtig ist, dass die Struktur dynamisch und erweiterbar bleibt.

---

## Abgrenzung

Nicht Aufgabe von `src/missions/`:

    Airbases aus DCS auslesen
    Zonen geometrisch erzeugen
    Basenbesitz direkt festlegen
    Zonenbesitz direkt festlegen
    CTLD-Lieferungen auswerten
    FOBs direkt bauen
    CAPs dauerhaft verwalten
    IADS-Netzwerke aufbauen
    F10-Menüs erzeugen
    Debug-Zeichnungen erzeugen
    Framework-Dateien verändern

Diese Aufgaben gehören in andere Bereiche.

Missions erzeugt und bewertet Aufträge.

---

## Verbindung zu späteren Systemen

Spätere Systeme nutzen Missionsdaten.

Beispiele:

    Campaign nutzt Missionsergebnisse für strategische Folgen.
    Logistics nutzt Versorgungsmissionen für Lieferungen.
    AI reagiert auf aktive Missionen.
    IADS liefert Ziele für SEAD und DEAD.
    UI zeigt verfügbare und aktive Missionen an.
    Debug zeigt Missionsstatus an.
    Persistence speichert Missionslisten und Ergebnisse.

Der Missionsbereich ist damit die Auftragsschicht von Theater Command DCS.

---

## Testziele

Der Missionsbereich gilt später als funktionsfähig, wenn folgende Punkte erfüllt sind:

    TC.Missions ist vorhanden.
    TC.Missions.Generator ist vorhanden.
    TC.State.Missions wird korrekt vorbereitet.
    verfügbare Missionen können erzeugt werden.
    Missionen können aktiviert werden.
    Missionen können abgeschlossen werden.
    Missionen können fehlschlagen.
    Missionsergebnisse werden im State gespeichert.
    Missionsergebnisse können andere Systeme informieren.
    keine Lua-Fehler beim Missionsstart.
    keine Framework-Dateien werden verändert.

Erwartete spätere Beispielausgaben in `dcs.log`:

    [TC] Missions loading started
    [TC] Mission generator loaded
    [TC] Missions initialized
    [TC] Mission created: STRIKE
    [TC] Mission activated: STRIKE
    [TC] Mission completed: STRIKE

---

## Entwicklungsregel

Der Missionsbereich wird schrittweise aufgebaut.

Empfohlene Reihenfolge:

    1. src/missions/README.md
    2. src/missions/tc_mission_generator.lua

Jede Datei wird einzeln erstellt und geprüft.

Keine parallelen Großbaustellen.

Keine All-in-one-Dateien.

---

## Zielbild

`src/missions/` soll aus dem strategischen Kampagnenzustand spielbare Aufträge erzeugen.

Der Missionsbereich ist die Verbindung zwischen:

    World-Daten
    Campaign-State
    Logistics
    AI-Reaktion
    IADS-Zielen
    Spielerinteraktion
    Persistenz

Damit bleibt das Projekt:

    modular
    lesbar
    testbar
    erweiterbar
    wartbar

`src/missions/` ist die Auftragsschicht von **Theater Command DCS**.
