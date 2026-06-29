# src/missions/README.md

Diese Datei beschreibt den Missionsbereich von **Theater Command DCS**.

Der Missionsbereich erzeugt dynamische Missionen aus dem aktuellen Kampagnenzustand.

---

## 1. Zweck des Missionsbereichs

`src/missions/` ist für die Erstellung, Verwaltung und spätere Bewertung dynamischer Missionen zuständig.

Missionen sollen nicht als feste lineare Missionsliste entstehen.

Sie sollen aus dem aktuellen Theater-Command-State abgeleitet werden.

Datenquellen sind unter anderem:

- World State
- Airbase Scanner
- ZoneFactory
- CaptureSystem
- LogisticsDelivery
- FobSystem
- AICapManager
- später IADS System
- später AI Director
- später PersistenceSystem

Aktuell ist der Missionsbereich nicht mehr nur geplant.

Der erste Mission Generator ist aktiv und getestet.

---

## 2. Aktueller technischer Stand

Stand:

    2026-06-29

Aktive Datei:

    src/missions/tc_mission_generator.lua

Getestete Version:

    v0.2.2

Status:

    bestanden

Bestätigt durch DCS-Logtests:

- MissionGenerator lädt.
- MissionGenerator startet.
- MissionGenerator erzeugt Missionskandidaten.
- MissionGenerator erzeugt verfügbare Missionen.
- MissionGenerator berücksichtigt FOB-Support.
- MissionGenerator erzeugt Mission Records mit Objectives, Briefings, Progress und Activation Metadata.
- MissionGenerator reserviert MOOSE-, CTLD- und Skynet-Hooks.
- F10Menu kann Missionen anzeigen.
- F10Menu kann Missionsdetails anzeigen.
- F10Menu kann Missionen direkt aktivieren.
- MissionGenerator setzt aktivierte Missionen auf ACTIVE.
- Aktivierung bleibt state-only.
- Es werden keine echten Spawns ausgelöst.
- Es gab keinen Theater-Command-Lua-Fehler.
- Es gab keinen Lua-Stacktrace.

---

## 3. Aktuelle bestätigte Werte

Aktuelle MissionGenerator-Werte:

    mission candidates: 69
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 30

Aktuelle F10-Bestätigung:

    F10 Commands: 26
    Mission Details Slot 1 bestätigt
    Mission Details Slot 2 bestätigt
    Mission Details Slot 5 bestätigt
    Mission Slot 1 aktiviert
    Mission Slot 5 aktiviert

Bestätigte Aktivierungsmarker:

    Mission status changed: MISSION_1 [ACTIVE]
    Mission status changed: MISSION_4 [ACTIVE]
    Mission activation prepared: stateOnly=true spawnHooks=reserved

Bewertung:

    MissionGenerator v0.2.2 ist bestanden.
    Missionen sind sichtbar, auswählbar und aktivierbar.
    Missionen bleiben aktuell state-only.

---

## 4. Architekturregel

Externe Frameworks liegen unter:

    vendor/

Eigene Theater-Command-Logik liegt unter:

    src/

Der Missionsbereich gehört zur eigenen Theater-Command-Logik.

Frameworks werden nicht verändert.

Dateien in `src/missions/` werden nach Theater-Command-Aufgaben benannt, nicht nach Frameworks.

Nicht gewünscht:

    src/missions/tc_moose_missions.lua
    src/missions/tc_mist_missions.lua
    src/missions/tc_mission_all_in_one.lua
    src/missions/tc_dynamic_everything.lua

Gewünscht:

    src/missions/tc_mission_generator.lua

Eine Missionsdatei darf intern Daten aus DCS, MIST, MOOSE, CTLD oder Skynet IADS vorbereiten oder nutzen.

Der Dateiname richtet sich aber immer nach der Theater-Command-Aufgabe.

---

## 5. Aktive Datei

Aktuell aktive Datei:

    src/missions/tc_mission_generator.lua

Aktuelle Version:

    v0.2.2

Aufgaben:

- Kampagnenzustand lesen
- Missionskandidaten erzeugen
- relevante Zielzonen erkennen
- relevante Zielbasen erkennen
- FOB-Support berücksichtigen
- Missionstypen begrenzen
- verfügbare Missionen erzeugen
- Mission Records anlegen
- Objectives erzeugen
- Briefings erzeugen
- Progress-Daten vorbereiten
- Activation Metadata vorbereiten
- Execution Plan vorbereiten
- Effects vorbereiten
- MOOSE-Hooks reservieren
- CTLD-Hooks reservieren
- Skynet-Hooks reservieren
- Mission Activation state-only ausführen

Wichtig:

    MissionGenerator scannt keine Airbases selbst.
    MissionGenerator erzeugt keine Zonen selbst.
    MissionGenerator ändert keinen Besitzstatus direkt.
    MissionGenerator führt aktuell keine echten Framework-Aktionen aus.

---

## 6. Mögliche spätere Dateien

Später können bei Bedarf weitere Missionsdateien ergänzt werden.

Mögliche Dateien:

    src/missions/tc_mission_registry.lua
    src/missions/tc_mission_types.lua
    src/missions/tc_mission_evaluator.lua
    src/missions/tc_target_selector.lua
    src/missions/tc_mission_effects.lua

Diese Dateien werden erst angelegt, wenn sie wirklich benötigt werden.

Aktuell reicht:

    src/missions/tc_mission_generator.lua

---

## 7. Aktuelle Missionstypen

Aktuelle Missionstypen:

- `RECON`
- `STRIKE`
- `SEAD`
- `DEAD`
- `CAS`
- `INTERDICTION`
- `ESCORT`
- `CAP`
- `LOGISTICS`
- `FOB_SUPPORT`
- `AIRBASE_ATTACK`
- `IADS_SUPPRESSION`

Diese Liste ist noch nicht final.

Sie dient aktuell dazu, unterschiedliche Kampagnenbedarfe abzubilden.

---

## 8. Mission Record

MissionGenerator v0.2.2 erzeugt erweiterte Mission Records.

Ein Mission Record kann aktuell enthalten:

- ID
- Key
- Name
- Type
- Status
- Owner
- Source Base
- Target Zone
- Target Base
- Target FOB
- Priority
- Strategic Relevance
- Objective
- Briefing
- Recommended Aircraft
- Recommended Payload
- Progress
- Activation Metadata
- Execution Plan
- Effects
- reserved MOOSE Hook
- reserved CTLD Hook
- reserved Skynet Hook

Bedeutung:

    Missionen sind vorbereitete Kampagnenobjekte.
    Sie können später mit Capture, Logistics, AI, IADS und Persistence verbunden werden.

---

## 9. Mission Status

Aktuell bestätigter Statuswechsel:

    AVAILABLE -> ACTIVE

Mögliche oder vorbereitete Mission Status:

- AVAILABLE
- ACTIVE
- COMPLETED
- FAILED
- CANCELLED
- EXPIRED

Noch offen:

- Mission manuell abschließen
- Mission manuell fehlschlagen lassen
- Mission abbrechen
- Mission automatisch durch DCS-Events abschließen
- Missionserfolg auf Capture oder Logistics anwenden

---

## 10. Mission Activation

Missionen können aktuell über F10 aktiviert werden.

F10Menu v0.2.0 bietet:

- Show Available Missions
- Show Active Missions
- Show Mission 1 Details bis Show Mission 10 Details
- Activate Mission 1 bis Activate Mission 10

Bestätigt:

    MissionGenerator setzt aktivierte Missionen auf ACTIVE.
    Aktivierung erzeugt stateOnly=true.
    Aktivierung erzeugt spawnHooks=reserved.

Aktuelle Einschränkung:

    Mission Activation bedeutet noch nicht, dass DCS-Einheiten gespawnt werden.
    Mission Activation ist aktuell eine State-Änderung.

---

## 11. Verhältnis zum Core

`src/missions/` nutzt den Core.

Erlaubte Core-Abhängigkeiten:

- `TC.Config`
- `TC.Logger`
- `TC.State`
- `TC.Utils`
- `TC.Scheduler`

Der Missionsbereich darf davon ausgehen, dass der Core bereits geladen ist.

Aktuelle Ladeposition:

    nach World, Campaign und Logistics
    vor AI, UI, Main und Loader

---

## 12. Verhältnis zum World-Bereich

Der Missionsbereich nutzt Daten aus:

    src/world/

Besonders wichtig:

- `TC.World.AirbaseScanner`
- `TC.World.ZoneFactory`
- `TC.State.Bases`
- `TC.State.Zones`

Aktuelle World-Werte:

    Syria airbase-like objects: 225
    relevante Kampagnenzonen: 46
    missionCandidates: 32
    logisticsCandidates: 46

Missions nutzt diese Daten für:

- Zielauswahl
- Airbase-Bezug
- Zonen-Bezug
- Start- und Zielräume
- strategische Priorität

Missions soll nicht selbst Airbases scannen.

Missions soll nicht selbst Kampagnenzonen erzeugen.

---

## 13. Verhältnis zum Campaign-Bereich

Der Missionsbereich nutzt Daten aus:

    src/campaign/

Besonders wichtig:

- `TC.Campaign.CaptureSystem`
- `TC.Campaign.PersistenceSystem`
- `TC.State.Campaign`
- `TC.State.Bases`
- `TC.State.Zones`

Aktuelle Capture-Werte:

    eligibleBases: 32
    eligibleZones: 32
    pressureRecords: 32
    progressRecords: 32
    appliedMissionEffects: 0
    ready: 0
    contested: 0

Missions nutzt diesen Zustand, um passende Aufträge zu erzeugen.

Beispiele:

- rote Zone wird mögliches Angriffsziel
- capture-fähige Zone wird mögliches Missionsziel
- Zone mit Pressure wird später mögliches Schwerpunktziel
- strategische Airbase wird mögliches Strike- oder SEAD-Ziel
- Mission Effects können später Capture-Pressure oder Capture-Progress beeinflussen

Besitzwechsel bleiben Aufgabe des CaptureSystems.

---

## 14. Verhältnis zum Logistics-Bereich

Der Missionsbereich nutzt Daten aus:

    src/logistics/

Besonders wichtig:

- `TC.Logistics.Delivery`
- `TC.Logistics.FobSystem`
- `TC.State.Logistics`

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

MissionGenerator nutzt FOBs bereits:

    fobSupportCandidates: 2
    reservedCreated: 1

Bedeutung:

    FOB-Support ist bereits Teil der Missionslogik.
    CTLD-Cargo-Aktionen sind noch nicht produktiv angebunden.

---

## 15. Verhältnis zum AI-Bereich

Der Missionsbereich kann später Daten an AI liefern oder AI-Daten berücksichtigen.

Aktuell aktive AI-Datei:

    src/ai/tc_ai_cap_manager.lua

Getestete Version:

    v0.2.0

Aktuelle AI-Werte:

    cap zone candidates: 31
    auto-registered CAP zones: 12
    CAP requests: 12
    reactionState: AIR_REACTION_REQUESTED
    threatLevel: HIGH

Mögliche spätere Kopplungen:

- aktive Strike-Mission erhöht feindliche CAP-Wahrscheinlichkeit
- aktive SEAD-Mission verändert IADS-/AI-Reaktion
- aktive Logistics-Mission erzeugt Intercept-Risiko
- abgeschlossene Missionen beeinflussen AI Director
- CAP-State beeinflusst Missionspriorität

Aktuell:

    AI Director ist noch nicht implementiert.
    MissionGenerator erzeugt Missionen state-only.

---

## 16. Verhältnis zum IADS-Bereich

Der Missionsbereich bereitet IADS-nahe Missionen vor.

Aktuell:

    Skynet IADS wird geladen.
    Theater-Command-IADS-Modul ist noch nicht implementiert.
    MissionGenerator reserviert Skynet-Hooks.

IADS-nahe Missionstypen:

- `SEAD`
- `DEAD`
- `IADS_SUPPRESSION`

Mögliche spätere Kopplung:

- IADS-System liefert SAM-/EWR-Ziele.
- MissionGenerator erzeugt SEAD-/DEAD-Missionen gegen diese Ziele.
- Mission Effects verändern IADS-State.
- Skynet-Hooks werden später produktiv genutzt.

Aktuell:

    keine echte Skynet-Aktion
    keine echte IADS-Wirkung
    keine IADS-Persistenz

---

## 17. Verhältnis zum UI-Bereich

Der Missionsbereich ist bereits mit dem UI-Bereich verbunden.

Aktive UI-Datei:

    src/ui/tc_f10_menu.lua

Getestete Version:

    v0.2.0

F10Menu kann aktuell:

- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Mission Details Slot 1 bis 10 anzeigen
- Mission Slot 1 bis 10 aktivieren

Bestätigt:

    Mission Details Slot 1
    Mission Details Slot 2
    Mission Details Slot 5
    Mission Slot 1 aktiviert
    Mission Slot 5 aktiviert

Bewertung:

    UI und MissionGenerator sind erfolgreich verbunden.
    Mission Activation bleibt state-only.

---

## 18. Verhältnis zu Persistence

PersistenceSystem ist vorbereitet, aber noch nicht produktiv.

Aktuelle Datei:

    src/campaign/tc_persistence_system.lua

Status:

    Grundstruktur lädt/startet
    produktiver Dateischreibtest offen

Missionsdaten sollen später persistiert werden:

- verfügbare Missionen
- aktive Missionen
- abgeschlossene Missionen
- fehlgeschlagene Missionen
- Missionsstatus
- Mission Progress
- Mission Effects
- Mission History

Aktuell:

    keine produktive Missionspersistenz
    kein Save/Load von Missionen
    keine Autosaves

---

## 19. State-first-Regel

Der Missionsbereich folgt aktuell strikt der state-first-Architektur.

Das bedeutet:

- Missionen entstehen im State.
- Missionen werden über F10 sichtbar.
- Missionen können im State aktiviert werden.
- Mission Effects werden vorbereitet.
- Framework-Hooks werden reserviert.
- echte Framework-Aktionen bleiben deaktiviert.

Nicht aktiv:

- echte MOOSE-Spawns
- echte CTLD-Cargo-Aktionen
- echte Skynet-IADS-Wirkung
- automatische DCS-Event-Auswertung
- automatische Mission Completion

Grund:

    Der Kampagnenzustand muss zuerst korrekt, sichtbar und testbar sein.
    Danach können echte DCS-Aktionen kontrolliert angebunden werden.

---

## 20. Testziele

Der Missionsbereich gilt aktuell für den state-first Stand als bestanden, wenn:

- MissionGenerator lädt.
- MissionGenerator startet.
- Missionskandidaten werden erkannt.
- 10 verfügbare Missionen werden erzeugt.
- FOB-Support wird berücksichtigt.
- mindestens eine FOB-Support-Mission wird reserviert.
- Mission Records enthalten Objectives, Briefings, Progress und Activation Metadata.
- Mission Details sind über F10 abrufbar.
- Missionen können über F10 direkt aktiviert werden.
- MissionGenerator setzt aktivierte Missionen auf ACTIVE.
- Aktivierung bleibt state-only.
- Spawn-Hooks bleiben reserved.
- keine Lua-Fehler auftreten.
- keine Theater-Command-Fehler auftreten.

Noch offen:

- Mission completed/failed
- Mission Effects produktiv anwenden
- automatische DCS-Event-Auswertung
- echte MOOSE-Spawns
- echte CTLD-Aktionen
- echte Skynet-IADS-Wirkung
- Mission-State persistieren

---

## 21. Erwartete Logmarker

Aktuelle erwartete Logmarker:

    [TC] [MissionGenerator] Loaded src/missions/tc_mission_generator.lua v0.2.2
    [TC] [MissionGenerator] Mission candidate summary: candidates=69, fobSupportCandidates=2, availableBefore=0, generationSlots=10
    [TC] [MissionGenerator] Mission generation completed: 10 new missions from 69 candidates (fobSupportCandidates=2, reservedCreated=1, duplicatesSkipped=1, typeLimitSkipped=30)
    [TC] [MissionGenerator] Mission status changed: MISSION_1 [ACTIVE]
    [TC] [MissionGenerator] Mission activation prepared: MISSION_1 stateOnly=true spawnHooks=reserved
    [TC] [F10Menu] Mission details shown through F10: slot=1 key=MISSION_1
    [TC] [F10Menu] Mission activated through F10: slot=1 key=MISSION_1

---

## 22. Abgrenzung

Nicht Aufgabe von `src/missions/`:

- Airbases aus DCS auslesen
- Zonen geometrisch erzeugen
- Basenbesitz direkt festlegen
- Zonenbesitz direkt festlegen
- CTLD-Lieferungen direkt auswerten
- FOBs direkt bauen
- CAPs dauerhaft verwalten
- IADS-Netzwerke aufbauen
- F10-Menüs erzeugen
- Debug-Zeichnungen erzeugen
- Framework-Dateien verändern

Diese Aufgaben gehören in andere Bereiche.

Missions erzeugt und verwaltet Aufträge.

---

## 23. Nächster sinnvoller Schritt

Der nächste sinnvolle Schritt liegt nicht direkt im Missionsbereich.

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

## 24. Zielbild

`src/missions/` ist die Auftragsschicht von Theater Command DCS.

Der Missionsbereich verbindet:

- World-Daten
- Campaign-State
- Capture-Pressure
- Logistics
- FOBs
- AI-Reaktion
- IADS-Ziele
- Spielerinteraktion
- Persistenz

Aktueller Status:

    MissionGenerator v0.2.2 ist state-first bestanden.
    Missionen sind über F10 sichtbar und aktivierbar.
    Echte Framework-Ausführung folgt später.
