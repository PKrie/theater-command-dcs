# src/world/README.md

Diese Datei beschreibt den World-Bereich von **Theater Command DCS**.

Der World-Bereich bildet die DCS-Welt in eigene Theater-Command-Strukturen ab.

---

## 1. Zweck des World-Bereichs

`src/world/` ist für Karten-, Airbase- und Zoneninformationen zuständig.

Dieser Bereich liest oder erzeugt keine strategischen Entscheidungen.

Er stellt fest, was in der DCS-Welt vorhanden ist und welche Objekte für Theater Command fachlich relevant sind.

Aufgaben:

- DCS-Airbase-Objekte erfassen
- Airbase-like Objects klassifizieren
- Akrotiri als Blue Start Base erkennen
- relevante Kampagnenobjekte identifizieren
- virtuelle Kampagnenzonen erzeugen
- Airbase-Daten und Zonendaten in Theater-Command-State überführen
- Grundlage für Campaign, Logistics, Missions, AI, IADS und UI schaffen

Der World-Bereich ist die Karten- und Raumgrundlage des Projekts.

---

## 2. Kampagnenkontext

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

Grundannahme:

    Akrotiri ist initial die blaue Startbasis.
    Zypern ist initial blauer Ausgangsraum.
    Syrische Festlandbasen sind initial rot kontrolliert.
    Neutrale oder Sonderfälle werden später ausdrücklich definiert.

---

## 3. Aktueller technischer Stand

Stand:

    2026-06-29

Aktive Dateien:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

Getesteter Stand:

    Airbase Scanner: v0.2.2 bestanden
    ZoneFactory: v0.2.0 bestanden

Bestätigt durch DCS-Logtests:

- Airbase Scanner lädt.
- Airbase Scanner startet.
- Airbase Scanner erkennt Syria-Airbase-like Objects.
- Airbase Scanner klassifiziert Airbase-like Objects.
- Akrotiri wird als Blue Start Base erkannt.
- ZoneFactory lädt.
- ZoneFactory startet.
- ZoneFactory erzeugt relevante Kampagnenzonen.
- ZoneFactory filtert ungeeignete Airbase-like Objects aus.
- nachfolgende Systeme können World-Daten nutzen.
- Es gab keinen Theater-Command-Lua-Fehler.
- Es gab keinen Lua-Stacktrace.

---

## 4. Aktuelle bestätigte Airbase-Werte

Airbase Scanner v0.2.2:

    total: 225
    strategic: 19
    secondary: 13
    heliports: 1
    helipads: 95
    medical: 40
    farps: 0
    tactical: 13
    unknown: 44
    captureCandidates: 32
    missionCandidates: 32
    logisticsCandidates: 46
    blueStartBases: 1
    redStrategicCandidates: 18

Bewertung:

    225 airbase-like objects sind auf der Syria Map erwartbar.
    Das ist kein Fehler.
    Entscheidend ist die fachliche Klassifizierung.
    Nicht alle 225 Objekte sind Kampagnenziele.

---

## 5. Aktuelle bestätigte ZoneFactory-Werte

ZoneFactory v0.2.0:

    total zones: 46
    classified airbase zones: 46
    Mission Editor zones: 0
    skipped airbase-like objects: 179
    strategic zones: 19
    secondary zones: 13
    heliport zones: 1
    farp zones: 0
    tactical zones: 13
    captureZones: 32
    missionZones: 32
    logisticsZones: 46
    startBaseZones: 1

Bewertung:

    ZoneFactory erzeugt nicht 225 ungefilterte Zonen.
    ZoneFactory erzeugt 46 relevante Kampagnenzonen.
    179 Airbase-like Objects werden bewusst übersprungen.
    Das ist korrekt und gewollt.

---

## 6. Architekturregel

Externe Frameworks liegen unter:

    vendor/

Eigene Theater-Command-Logik liegt unter:

    src/

Der World-Bereich gehört zur eigenen Theater-Command-Logik.

Frameworks werden nicht verändert.

Dateien in `src/world/` werden nach Theater-Command-Aufgaben benannt, nicht nach Frameworks.

Nicht gewünscht:

    src/world/tc_moose_world.lua
    src/world/tc_mist_world.lua
    src/world/tc_world_all_in_one.lua
    src/world/tc_airbase_and_zone_everything.lua

Gewünscht:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

Eine World-Datei darf intern DCS-API, MIST oder MOOSE nutzen.

Der Dateiname richtet sich aber immer nach der Theater-Command-Aufgabe.

---

## 7. Aktive Dateien

Aktuell aktive Dateien:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

`tc_airbase_scanner.lua`:

    aktives Airbase-Erkennungs- und Klassifikationsmodul
    Version v0.2.2
    bestanden

`tc_zone_factory.lua`:

    aktives Zonen-Erzeugungsmodul
    Version v0.2.0
    bestanden

Mögliche spätere Dateien:

    src/world/tc_airbase_registry.lua
    src/world/tc_zone_registry.lua
    src/world/tc_map_data.lua
    src/world/tc_theater_geometry.lua

Diese Zusatzdateien werden erst angelegt, wenn sie wirklich benötigt werden.

---

## 8. Airbase Scanner

Datei:

    src/world/tc_airbase_scanner.lua

Getestete Version:

    v0.2.2

Status:

    bestanden

Aktuelle Aufgaben:

- DCS-Airbase-like Objects erfassen
- Objekte klassifizieren
- strategische Airfields erkennen
- sekundäre Airfields erkennen
- Heliports erkennen
- Helipads erkennen
- Medical Pads erkennen
- Tactical Pads erkennen
- Unknown Objects konservativ behandeln
- Akrotiri als Blue Start Base erkennen
- Capture Candidates vorbereiten
- Mission Candidates vorbereiten
- Logistics Candidates vorbereiten
- Red Strategic Candidates vorbereiten
- State für spätere Systeme bereitstellen

Wichtig:

    Airbase Scanner erobert keine Basen.
    Airbase Scanner erzeugt keine Missionen.
    Airbase Scanner führt keine CTLD-, MOOSE- oder Skynet-Aktionen aus.

---

## 9. Airbase-Kategorien

Aktuelle Kategorien:

- Strategic Airfield
- Secondary Airfield
- Heliport
- Helipad
- Medical Pad
- Tactical Pad
- FARP
- Unknown

Aktuelle Werte:

    strategic: 19
    secondary: 13
    heliports: 1
    helipads: 95
    medical: 40
    farps: 0
    tactical: 13
    unknown: 44

Bedeutung:

    Strategic und Secondary sind aktuell die wichtigsten Kampagnenziele.
    Helipads und Medical Pads sind nicht automatisch strategische Ziele.
    Unknown Objects werden konservativ behandelt.

---

## 10. Akrotiri

Akrotiri ist die bestätigte Blue Start Base.

Aktuelle Werte:

    blueStartBases: 1

Rolle von Akrotiri:

- Blue Main Operating Base
- sichere Startbasis
- erster Blue Logistics Hub
- Ausgangspunkt für Spieler
- Ausgangspunkt für spätere Blue-Operationen
- Ausgangspunkt für spätere Logistik- und FOB-Unterstützung

Akrotiri ist fachlich der erste blaue Ankerpunkt der Kampagne.

---

## 11. Capture Candidates

Aktuell bestätigt:

    captureCandidates: 32

Capture Candidates sind Objekte, die später eroberbar sein können.

Aktuell capture-fähig:

- Strategic Airfields
- Secondary Airfields
- später ausdrücklich freigegebene Sonderzonen

Nicht automatisch capture-fähig:

- einfache Helipads
- Medical Pads
- Tactical Pads ohne ausdrückliche Freigabe
- Unknown Objects
- technische Sonderobjekte

Diese Filterung verhindert, dass die Kampagne 225 unsinnige Capture-Ziele erzeugt.

---

## 12. Mission Candidates

Aktuell bestätigt:

    missionCandidates: 32

Mission Candidates sind geeignete Ziele für MissionGenerator.

Mögliche spätere Missionstypen gegen diese Ziele:

- RECON
- STRIKE
- SEAD
- DEAD
- CAS
- INTERDICTION
- AIRBASE_ATTACK
- IADS_SUPPRESSION
- CAP im Umfeld
- LOGISTICS im Umfeld
- FOB_SUPPORT im Umfeld

MissionGenerator nutzt diese Daten bereits.

---

## 13. Logistics Candidates

Aktuell bestätigt:

    logisticsCandidates: 46

Logistics Candidates bilden die Grundlage für LogisticsDelivery.

Logistics ist bewusst breiter als Capture.

Grund:

    Ein Ort kann logistischer Knoten sein, ohne ein klassisches Capture-Ziel zu sein.

LogisticsDelivery erzeugt daraus aktuell:

    46 Logistics Hubs

---

## 14. Red Strategic Candidates

Aktuell bestätigt:

    redStrategicCandidates: 18

Diese Objekte bilden die erste strategische Grundlage für rote Festlandziele.

Mögliche spätere Rollen:

- rote Hauptbasen
- rote Logistikhubs
- rote Missionsziele
- rote IADS-nahe Räume
- AI-Director-Schwerpunkte
- Capture-Ziele

Aktuell:

    Red Strategic Candidates sind State-Daten.
    Es werden noch keine echten roten Operationen gespawnt.

---

## 15. ZoneFactory

Datei:

    src/world/tc_zone_factory.lua

Getestete Version:

    v0.2.0

Status:

    bestanden

Aktuelle Aufgaben:

- Airbase-Daten in Theater-Command-Zonen überführen
- relevante Kampagnenzonen erzeugen
- ungeeignete Airbase-like Objects überspringen
- strategische Zonen markieren
- sekundäre Zonen markieren
- Capture-Zonen markieren
- Mission-Zonen markieren
- Logistics-Zonen markieren
- Startbase-Zonen markieren
- State für spätere Systeme bereitstellen

Wichtig:

    ZoneFactory entscheidet nicht über Capture.
    ZoneFactory erzeugt keine Missionen.
    ZoneFactory führt keine CTLD-, MOOSE- oder Skynet-Aktionen aus.

---

## 16. Warum ZoneFactory nicht 225 Zonen erzeugt

DCS Syria liefert 225 airbase-like objects.

Darin enthalten sind viele Objekte, die keine strategischen Kampagnenzonen sein sollen.

Beispiele:

- einfache Helipads
- Medical Pads
- technische Pads
- unbekannte Sonderobjekte
- nicht relevante DCS-Objekte

ZoneFactory filtert diese Objekte.

Aktuelles Ergebnis:

    225 erkannte Airbase-like Objects
    46 relevante Kampagnenzonen
    179 übersprungene Objekte

Diese Filterung ist korrekt.

Die frühere Aussage, dass ZoneFactory 225 Zonen registriert, ist veraltet.

---

## 17. Mission Editor Zones

Aktueller Stand:

    Mission Editor zones: 0

Das bedeutet:

    Aktuell erzeugt ZoneFactory die relevanten Kampagnenzonen aus klassifizierten Airbase-Daten.
    Es sind noch keine produktiven Mission-Editor-Triggerzonen eingebunden.

Spätere Mission-Editor-Zonen:

- CAPTURE-Zonen
- Frontlinienzonen
- CTLD Pickup Zones
- CTLD Dropoff Zones
- FOB Build Zones
- IADS Sectors
- Debug-Zonen
- Custom Mission Areas

Diese werden später nach klarer Namenskonvention ergänzt.

---

## 18. Verhältnis zum Core

`src/world/` nutzt den Core.

Erlaubte Core-Abhängigkeiten:

- `TC.Config`
- `TC.Logger`
- `TC.State`
- `TC.Utils`
- `TC.Scheduler`

Der World-Bereich darf davon ausgehen, dass der Core bereits geladen ist.

Aktuelle Ladeposition:

    nach Core
    vor Campaign, Logistics, Missions, AI, UI, Main und Loader

World-Dateien dürfen auf Core-Funktionen zugreifen.

World-Dateien sollen aber nicht direkt von späteren Systemen abhängig sein.

Nicht als direkte Pflichtabhängigkeit:

- Campaign
- Logistics
- Missions
- AI
- IADS
- UI
- Debug

Diese Systeme greifen später auf World-Daten zu, nicht umgekehrt.

---

## 19. Verhältnis zu Campaign

Campaign nutzt World-Daten.

Aktive Campaign-Dateien:

    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua

CaptureSystem nutzt:

- Airbase-Klassifikation
- Capture Candidates
- ZoneFactory-Zonen
- Capture-Zonen
- Mission-Zonen
- Logistics-Zonen

Aktuelle Capture-Werte:

    eligibleBases: 32
    eligibleZones: 32
    pressureRecords: 32
    progressRecords: 32
    appliedMissionEffects: 0

World entscheidet nicht über Besitzwechsel.

Campaign entscheidet später über Capture, Pressure, Progress und Persistenz.

---

## 20. Verhältnis zu Logistics

Logistics nutzt World-Daten.

Aktive Logistics-Dateien:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

LogisticsDelivery nutzt:

- Logistics Candidates
- Logistics Zones
- Besitzerstatus
- strategische Zonen
- geeignete FOB-Kandidaten

Aktuelle Logistics-Werte:

    logistics hubs: 46
    blue hubs: 7
    red hubs: 24
    neutral hubs: 15
    active hubs: 31
    limited hubs: 15
    locked hubs: 0

Aktuelle FOB-Werte:

    FOB candidates: 6
    Blue FOBs: 2
    FOB Ercan
    FOB Gecitkale
    Status: UNDER_CONSTRUCTION

World erzeugt keine Logistics Hubs selbst.

World liefert die Raumdaten für Logistics.

---

## 21. Verhältnis zu Missions

MissionGenerator nutzt World-Daten.

Aktive Missions-Datei:

    src/missions/tc_mission_generator.lua

Getestete Version:

    v0.2.2

MissionGenerator nutzt:

- Mission Candidates
- Capture Zones
- Logistics Zones
- strategische Zonen
- sekundäre Zonen
- FOB-bezogene Zonen
- Startbase-Zonen

Aktuelle MissionGenerator-Werte:

    mission candidates: 69
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 30

World erzeugt keine Missionen.

World liefert geeignete Ziele und Räume.

---

## 22. Verhältnis zu AI

AI nutzt World-Daten.

Aktive AI-Datei:

    src/ai/tc_ai_cap_manager.lua

Getestete Version:

    v0.2.0

AICapManager nutzt:

- Zonen
- CAP-Zonen-Kandidaten
- strategische Räume
- Airbase-/Zone-Informationen

Aktuelle AI-Werte:

    cap zone candidates: 31
    auto-registered CAP zones: 12
    CAP requests: 12
    reactionState: AIR_REACTION_REQUESTED
    threatLevel: HIGH

World erzeugt keine AI-Entscheidungen.

World liefert Räume für AI-Bewertung.

---

## 23. Verhältnis zu UI

F10Menu zeigt World-abgeleitete Daten indirekt an.

Aktive UI-Datei:

    src/ui/tc_f10_menu.lua

Getestete Version:

    v0.2.0

F10Menu zeigt aktuell:

- Missionen
- Missionsdetails
- Campaign Status
- Logistics Status
- FOB Status
- AI CAP Status

Nächster UI-Schritt:

    Capture-/Pressure-Status anzeigen.

Diese Daten basieren indirekt auf World-Daten, weil CaptureSystem aus World-/ZoneFactory-Daten arbeitet.

---

## 24. Verhältnis zu IADS

IADS soll später World-Daten nutzen.

Aktueller IADS-Stand:

    Skynet IADS wird geladen.
    eigenes Theater-Command-IADS-Modul ist noch nicht implementiert.
    MissionGenerator reserviert Skynet-Hooks.

Spätere IADS-Nutzung:

- IADS-Sektoren an Zonen koppeln
- SAM-Sites an Zonen koppeln
- EWR-Standorte an Zonen koppeln
- IADS-Ziele mit Airbase- und Mission-Zonen verbinden
- IADS-Zustand für MissionGenerator und AI bereitstellen

Aktuell:

    IADS nutzt World-Daten noch nicht produktiv.

---

## 25. Verhältnis zu Persistence

Persistence soll später World-Daten speichern oder validieren.

Aktuelle Persistence-Datei:

    src/campaign/tc_persistence_system.lua

Status:

    Grundstruktur lädt/startet
    produktiver Dateischreibtest offen

Persistenz soll später speichern:

- Airbase Keys
- Zone Keys
- Besitzstatus
- Capture-Progress
- Capture-Pressure
- Logistics Status
- Mission State
- AI State
- IADS State

Wichtig:

    Save-Dateien müssen gegen aktuelle World-Daten validiert werden.
    Gespeicherte Zonen oder Airbase-Keys dürfen nicht blind geladen werden, wenn die Mission geändert wurde.

---

## 26. Namespace

Der World-Bereich nutzt die zentrale Projekttabelle:

    TC

Geplante und aktuelle Struktur:

    TC.World
    ├── AirbaseScanner
    ├── ZoneFactory
    ├── Airbases
    └── Zones

State-Bereiche:

    TC.State.World
    TC.State.Bases
    TC.State.Zones

Nicht verwenden:

    TheaterCommandWorld
    WorldTC
    tc_world_global
    _G_TC_WORLD

---

## 27. State-first-Regel

Der World-Bereich folgt aktuell strikt der state-first-Architektur.

Das bedeutet:

- Airbase Scanner erzeugt State.
- ZoneFactory erzeugt State.
- nachfolgende Systeme lesen State.
- World löst keine echten Framework-Aktionen aus.
- World verändert keine Vendor-Dateien.
- World spawnt keine Einheiten.
- World erzeugt keine Missionen.

Nicht aktiv:

- echte Frontlinien
- echte Capture-Änderung
- echte CTLD-Zonen
- echte IADS-Sektoren
- echte MOOSE-Spawns
- produktive Persistenz

---

## 28. Testziele

Airbase Scanner v0.2.2 gilt aktuell als bestanden, wenn:

- Datei lädt.
- Version wird im Log angezeigt.
- Airbase Scanner startet.
- 225 airbase-like objects erkannt werden.
- 19 strategic Objekte erkannt werden.
- 13 secondary Objekte erkannt werden.
- Akrotiri als Blue Start Base erkannt wird.
- 32 captureCandidates erzeugt werden.
- 32 missionCandidates erzeugt werden.
- 46 logisticsCandidates erzeugt werden.
- 18 redStrategicCandidates erzeugt werden.
- keine Theater-Command-Lua-Fehler auftreten.
- keine Lua-Stacktraces auftreten.

ZoneFactory v0.2.0 gilt aktuell als bestanden, wenn:

- Datei lädt.
- Version wird im Log angezeigt.
- ZoneFactory startet.
- 46 relevante Kampagnenzonen erzeugt werden.
- 179 ungeeignete Airbase-like Objects übersprungen werden.
- 32 captureZones erzeugt werden.
- 32 missionZones erzeugt werden.
- 46 logisticsZones erzeugt werden.
- 1 startBaseZone erzeugt wird.
- keine Theater-Command-Lua-Fehler auftreten.
- keine Lua-Stacktraces auftreten.

---

## 29. Erwartete Logmarker

Aktuelle erwartete Airbase-Logmarker:

    [TC] [AirbaseScanner] Loaded src/world/tc_airbase_scanner.lua v0.2.2
    [TC] [AirbaseScanner] Airbase scan completed:
    [TC] [AirbaseScanner] Airbase classification summary:
    [TC] [AirbaseScanner] Campaign candidates summary:

Aktuelle erwartete ZoneFactory-Logmarker:

    [TC] [ZoneFactory] Loaded src/world/tc_zone_factory.lua v0.2.0
    [TC] [ZoneFactory] Zone factory completed:
    [TC] [ZoneFactory] Zone classification summary:
    [TC] [ZoneFactory] Zone capability summary:

Der genaue Wortlaut einzelner Summary-Logs kann je nach Implementierung variieren.

Wichtig ist:

    Version korrekt.
    Werte korrekt.
    46 relevante Kampagnenzonen.
    keine 225 ungefilterten Kampagnenzonen.
    keine Fehler.

---

## 30. Abgrenzung

Nicht Aufgabe von `src/world/`:

- Basen erobern
- Zonen erobern
- Capture-Pressure berechnen
- Capture-Progress berechnen
- Missionen erzeugen
- Missionen aktivieren
- Logistiklieferungen auswerten
- FOBs bauen
- CAPs starten
- IADS aktivieren
- Spielstände speichern
- F10-Menüs erzeugen
- Vendor-Dateien verändern

Diese Aufgaben gehören in andere Bereiche.

World liefert die Grundlage.

---

## 31. Nächster sinnvoller Schritt

Der nächste sinnvolle Schritt liegt nicht direkt im World-Bereich.

Empfohlene nächste Datei:

    src/ui/tc_f10_menu.lua

Ziel:

    Capture-/Pressure-Status im F10-Menü sichtbar machen.

Geplante neue F10-Funktionen:

    Show Capture Status
    Show Capture Ready Zones
    Show Pressure Contested Zones

Akzeptanzkriterien:

- F10Menu lädt als neue Version.
- bisherige 26 Commands bleiben funktionsfähig.
- neue Capture-Commands werden ergänzt.
- Capture Status zeigt mindestens:
  - eligibleBases
  - eligibleZones
  - pressureRecords
  - progressRecords
  - captureReady
  - pressureContested
  - appliedMissionEffects
- Capture Ready Zones können angezeigt werden.
- Pressure Contested Zones können angezeigt werden.
- keine echten Spawns
- keine CTLD-Aktion
- keine Skynet-Aktion
- keine Lua-Fehler
- keine Theater-Command-Fehler

---

## 32. Zielbild

`src/world/` ist die Karten- und Raumgrundlage von Theater Command DCS.

Der World-Bereich verbindet:

- DCS-Welt
- Mission Editor
- Airbase-Daten
- Kampagnenzonen
- Theater-Command-State
- Campaign
- Logistics
- Missions
- AI
- IADS
- UI
- Persistence

Aktueller Status:

    Airbase Scanner v0.2.2 ist state-first bestanden.
    ZoneFactory v0.2.0 ist state-first bestanden.
    225 DCS-Airbase-like Objects werden erkannt.
    46 relevante Kampagnenzonen werden erzeugt.
    32 Capture-/Mission-Ziele werden vorbereitet.
    46 Logistics-Ziele werden vorbereitet.

Damit ist der World-Bereich stabil genug für den nächsten UI-/Debug-Schritt.
