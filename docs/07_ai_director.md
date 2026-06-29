# AI Director

Diese Datei beschreibt den geplanten AI Director von **Theater Command DCS**.

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## 1. Zweck des AI Directors

Der AI Director soll langfristig die strategische und operative KI-Entscheidungsebene von Theater Command DCS werden.

Er soll nicht nur einzelne Flugzeuge oder Gruppen spawnen.

Er soll aus dem Kampagnenzustand ableiten, welche Seite welche Operationen plant, priorisiert und ausführt.

Ziel:

    Blue und Red sollen eigene Operationen durchführen.
    Spieler sollen Teilnehmer einer laufenden Kampagne sein.
    Die Kampagne soll nicht ausschließlich durch Spieleraktionen angetrieben werden.

Der AI Director ist aktuell noch nicht implementiert.

Der vorhandene `AICapManager` ist ein erstes vorbereitendes Teilmodul für CAP-State, aber noch kein vollständiger AI Director.

---

## 2. Aktueller technischer Stand

Stand:

    2026-06-29

Aktive AI-Datei:

    src/ai/tc_ai_cap_manager.lua

Getestete Version:

    v0.2.0

Status:

    bestanden

Geplante spätere Datei:

    src/ai/tc_ai_director.lua

Aktuell vorhanden:

- AI-Ordnerstruktur
- `src/ai/README.md`
- `src/ai/tc_ai_cap_manager.lua`
- CAP-Zonen-Kandidaten
- CAP-Requests
- Blue-/Red-CAP-State
- MOOSE-Hooks vorbereitet
- `spawn=MOOSE_PENDING` als erwarteter Zustand

Noch nicht vorhanden:

- vollständiger AI Director
- strategisches Entscheidungsmodell
- Blue-Offensivplanung
- Red-Verteidigungsplanung
- Red-Gegenangriffe
- dynamische Ressourcenbewertung
- echte MOOSE-Spawns
- echte AI-Flüge
- echte AI-Mission Packages
- echte GCI-Reaktion
- Verlustauswertung
- AI-Persistenz

---

## 3. Aktueller getesteter AI-CAP-Stand

AICapManager:

    Datei: src/ai/tc_ai_cap_manager.lua
    Version: v0.2.0
    Status: bestanden

Bestätigte Werte:

    cap zone candidates: 31
    auto-registered CAP zones: 12
    CAP requests: 12
    reactionState: AIR_REACTION_REQUESTED
    threatLevel: HIGH

Bewertung:

    AICapManager erzeugt einen ersten AI-bezogenen State.
    CAP-Bedarf wird aus Kampagnenzonen abgeleitet.
    Es werden noch keine echten MOOSE-CAP-Flüge gespawnt.
    `spawn=MOOSE_PENDING` ist aktuell korrekt und erwartet.

---

## 4. Verhältnis zwischen AICapManager und AI Director

Der AICapManager ist nicht der vollständige AI Director.

AICapManager:

- bereitet CAP-Zonen vor
- erzeugt CAP-Requests
- bewertet Luftbedrohung state-only
- bereitet spätere MOOSE-CAP-Anbindung vor

AI Director soll später:

- Gesamtstrategie bewerten
- Blue-Operationen planen
- Red-Operationen planen
- Missionsbedarf erzeugen
- CAP-Bedarf priorisieren
- Logistikbedarf bewerten
- FOB-Bedarf bewerten
- IADS-Zustand berücksichtigen
- Capture-Pressure bewerten
- Missionsresultate verarbeiten
- Ressourcen verwalten
- Eskalation und Gegenreaktionen steuern

Kurz:

    AICapManager ist ein Fachmodul.
    AI Director wird die strategische Koordinationsschicht.

---

## 5. State-first-Grundsatz

Auch für den AI Director gilt:

    erst State
    dann Sichtbarkeit
    dann Tests
    dann echte Framework-Aktionen

Der AI Director soll im ersten Schritt keine echten DCS-Gruppen spawnen.

Er soll zunächst nur State erzeugen:

- geplante Operationen
- priorisierte Ziele
- AI-Absichten
- CAP-Bedarf
- Strike-Bedarf
- SEAD-/DEAD-Bedarf
- Logistikbedarf
- FOB-Bedarf
- Verteidigungsbedarf
- Gegenangriffsbedarf
- Reaktionszustände

Echte MOOSE- oder CTLD-Aktionen folgen erst später.

Grund:

    DCS-Framework-Ausführung erzeugt komplexe Nebenwirkungen.
    Vor echten Spawns muss die AI-Entscheidung im State sichtbar und testbar sein.

---

## 6. Datenquellen des späteren AI Directors

Der AI Director soll später Daten aus mehreren Theater-Command-Systemen lesen.

Wichtige Datenquellen:

- Airbase Scanner
- ZoneFactory
- CaptureSystem
- LogisticsDelivery
- FobSystem
- MissionGenerator
- AICapManager
- IADS System
- PersistenceSystem
- F10/UI
- spätere Debug-Reports
- spätere DCS-Event-Auswertung

Aktuelle vorgelagerte bestätigte Werte:

    Syria airbase-like objects: 225
    relevante Kampagnenzonen: 46
    capture-fähige Ziele: 32
    Capture-Pressure-Records: 32
    Capture-Progress-Records: 32
    Logistics Hubs: 46
    FOB-Kandidaten: 6
    Blue FOBs: 2
    Mission candidates: 69
    verfügbare Missionen: 10
    CAP-Zonen-Kandidaten: 31
    CAP Requests: 12

Diese Datenbasis ist inzwischen stabil genug, um den AI Director später sinnvoll aufzubauen.

---

## 7. Verhältnis zu Airbase Scanner

Airbase Scanner liefert die klassifizierte Airbase-Basis.

Aktuelle Werte:

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

AI Director soll später daraus ableiten:

- strategische Schlüsselbasen
- operative Achsen
- rote Schwerpunktbasen
- blaue Ausgangsbasen
- mögliche Angriffsräume
- mögliche Verteidigungsräume
- lohnende Missionsziele
- gefährdete eigene Basen
- Logistikschwerpunkte

Aktuell:

    AI Director nutzt diese Daten noch nicht direkt.
    AICapManager nutzt bereits Zonen-/Airbase-Daten zur CAP-State-Vorbereitung.

---

## 8. Verhältnis zu ZoneFactory

ZoneFactory erzeugt relevante Kampagnenzonen.

Aktuelle Werte:

    total zones: 46
    classified airbase zones: 46
    Mission Editor zones: 0
    skipped airbase-like objects: 179
    strategic zones: 19
    secondary zones: 13
    captureZones: 32
    missionZones: 32
    logisticsZones: 46
    startBaseZones: 1

AI Director soll später Zonen bewerten nach:

- Besitzer
- strategischer Relevanz
- Nähe zu Front oder Operationsachse
- Capture-Status
- Logistics-Status
- IADS-Abdeckung
- CAP-Bedarf
- FOB-Nähe
- Missionslage
- Bedrohung

Wichtig:

    Der AI Director darf nicht auf allen 225 DCS-Airbase-like Objects planen.
    Er soll die gefilterten 46 Kampagnenzonen nutzen.

---

## 9. Verhältnis zu CaptureSystem

CaptureSystem liefert Ownership, Capture-Eligibility, Capture-Pressure und Capture-Progress.

Aktuelle Werte:

    eligibleBases: 32
    eligibleZones: 32
    nonCaptureBases: 193
    nonCaptureZones: 14
    pressureRecords: 32
    progressRecords: 32
    appliedMissionEffects: 0
    ready: 0
    contested: 0

AI Director soll später daraus ableiten:

- welche Zonen angegriffen werden sollen
- welche Zonen verteidigt werden sollen
- welche Zonen kurz vor Capture stehen
- welche Zonen durch Missionen vorbereitet werden müssen
- wo Red Gegenmaßnahmen priorisiert
- wo Blue weiter Druck aufbauen soll
- wo Logistik oder FOBs nötig sind

Aktuell:

    CaptureSystem erzeugt Pressure und Progress.
    AI Director verarbeitet diese Daten noch nicht produktiv.
    Nächster Schritt ist zunächst F10-Sichtbarkeit für Capture-/Pressure-Daten.

---

## 10. Verhältnis zu LogisticsDelivery

LogisticsDelivery liefert Logistics Hubs.

Aktuelle Werte:

    logistics hubs: 46
    blue hubs: 7
    red hubs: 24
    neutral hubs: 15
    active hubs: 31
    limited hubs: 15
    locked hubs: 0

AI Director soll später daraus ableiten:

- welche Hubs geschützt werden müssen
- welche Hubs angegriffen werden sollen
- wo Versorgungslücken bestehen
- wo FOB-Aufbau sinnvoll ist
- welche Hubs Missionen erzeugen sollen
- wo Interdiction sinnvoll ist
- wo CAP zur Sicherung nötig ist

Aktuell:

    Logistics Hubs existieren im State.
    AI Director nutzt sie noch nicht produktiv.

---

## 11. Verhältnis zu FobSystem

FobSystem liefert FOB-Kandidaten und state-only Blue-FOBs.

Aktuelle Werte:

    FOB candidates: 6
    stored candidates: 6
    auto-planned FOBs: 2
    skipped candidates: 4
    Blue FOBs: 2

Aktuelle Blue-FOBs:

    FOB Ercan
    FOB Gecitkale

Status:

    UNDER_CONSTRUCTION

AI Director soll später daraus ableiten:

- FOBs schützen
- FOB-Aufbau priorisieren
- FOB-Support-Missionen anfordern
- Red-Angriffe auf FOBs planen
- Blue-Operationen aus FOBs heraus planen
- CAP über FOBs anfordern
- Logistikbedarf erzeugen

Aktuell:

    FOBs sind state-only.
    MissionGenerator nutzt FOBs bereits für FOB-Support.
    AI Director nutzt FOBs noch nicht produktiv.

---

## 12. Verhältnis zu MissionGenerator

MissionGenerator erzeugt Missionen aus Kampagnenzustand.

Aktuelle Werte:

    mission candidates: 69
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 30

AI Director soll später mit MissionGenerator zusammenarbeiten.

Mögliche Rollenverteilung:

MissionGenerator:

- erzeugt mögliche Missionen
- verwaltet Mission Records
- verwaltet Mission Status
- bereitet Mission Effects vor
- stellt Missionen im F10 bereit

AI Director:

- bewertet Prioritäten
- entscheidet, welche Operationen sinnvoll sind
- fordert Missionstypen an
- priorisiert Blue- und Red-Bedarf
- reagiert auf Missionsergebnisse
- steuert Eskalation und Gegenreaktionen

Aktuell:

    MissionGenerator arbeitet state-only.
    F10Menu kann Missionen aktivieren.
    AI Director ist noch nicht angebunden.

---

## 13. Verhältnis zu AICapManager

AICapManager ist aktuell das aktive AI-Teilmodul.

AI Director soll später AICapManager nutzen oder steuern.

Mögliche spätere Aufgabenverteilung:

AICapManager:

- CAP-Zonen verwalten
- CAP-Requests erzeugen
- CAP-State pflegen
- MOOSE-CAP-Hooks vorbereiten oder auslösen

AI Director:

- entscheidet, welche CAP-Requests Priorität haben
- entscheidet Blue-/Red-Schwerpunkt
- entscheidet defensive oder offensive CAP
- bewertet Bedrohung und Ressourcen
- koppelt CAP an Missionen, Capture und IADS

Aktuell:

    AICapManager läuft eigenständig state-only.
    AI Director existiert noch nicht.

---

## 14. Verhältnis zu IADS

IADS ist für die spätere AI-Entscheidung zentral.

Aktueller Stand:

    Skynet IADS wird geladen.
    Theater-Command-IADS-Modul ist noch nicht implementiert.
    MissionGenerator reserviert Skynet-Hooks.
    Keine produktive IADS-Kampagnenlogik aktiv.

AI Director soll später IADS-Daten nutzen:

- SAM-Abdeckung
- Radarstatus
- IADS-Sektoren
- beschädigte SAM-Sites
- zerstörte EWR
- sichere Korridore
- gefährdete Luftkorridore
- SEAD-/DEAD-Bedarf
- Red-Verteidigungsfähigkeit
- Blue-Angriffsrisiko

Aktuell:

    AI Director kann IADS noch nicht bewerten, weil das eigene IADS-System noch fehlt.

---

## 15. Blue AI Design

Blue AI soll später eigene Operationen planen.

Mögliche Blue-Prioritäten:

- Akrotiri sichern
- Luftüberlegenheit aufbauen
- CAP-Korridore etablieren
- SEAD/DEAD gegen rote IADS-Knoten planen
- Recon gegen strategische Ziele durchführen
- FOB-Aufbau unterstützen
- Logistics Hubs sichern
- Capture-Pressure aufbauen
- Missionen gegen rote Airbases priorisieren
- Gegenreaktionen auf rote Operationen einleiten

Blue AI soll nicht den Spieler ersetzen.

Sie soll die Kampagne lebendig halten und sinnvolle Operationen erzeugen.

---

## 16. Red AI Design

Red AI soll später eigene Operationen planen.

Mögliche Red-Prioritäten:

- syrisches Festland halten
- strategische Airbases verteidigen
- IADS-Sektoren schützen
- CAP gegen Blue-Korridore anfordern
- Blue FOBs angreifen
- Blue Logistics stören
- Gegenangriffe auf umkämpfte Zonen planen
- Red Logistics Hubs schützen
- Schwächen im Blue-Fortschritt ausnutzen
- Missionen gegen Blue-Druck auslösen

Red AI soll nicht nur passiv Zielkulisse sein.

Sie soll auf Blue-Fortschritt reagieren und eigene Prioritäten verfolgen.

---

## 17. Operationsarten

Der spätere AI Director soll unterschiedliche Operationstypen planen können.

Mögliche Blue-Operationen:

- Air Superiority Operation
- SEAD Preparation
- DEAD Strike
- Recon Sweep
- Logistics Push
- FOB Support Operation
- Airbase Attack
- Capture Preparation
- CAP Corridor
- Interdiction Package

Mögliche Red-Operationen:

- Defensive CAP
- IADS Reinforcement
- Counter CAP
- FOB Attack
- Logistics Interdiction
- Airbase Defense
- Counterattack Preparation
- Strike Against Blue Hub
- SAM Ambush
- Pressure Relief Operation

Aktuell:

    Diese Operationstypen sind konzeptionell.
    Es gibt noch keinen AI Director, der sie plant.

---

## 18. AI-State-Modell

Der spätere AI Director soll eigenen State erzeugen.

Mögliche State-Bereiche:

    State.AI.Director
    State.AI.Operations
    State.AI.Intentions
    State.AI.Priorities
    State.AI.Requests
    State.AI.ThreatAssessment
    State.AI.ResourceAssessment
    State.AI.Decisions
    State.AI.History

Mögliche Einträge:

- currentPhase
- blueIntent
- redIntent
- priorityZones
- threatenedZones
- targetZones
- defensiveZones
- activeOperations
- pendingOperations
- completedOperations
- failedOperations
- resourcePressure
- airThreat
- iadsThreat
- logisticsPressure
- capturePressure
- decisionTimestamp

Aktuell:

    AICapManager erzeugt bereits AI-CAP-State.
    Ein Director-State ist noch nicht implementiert.

---

## 19. Entscheidungsfaktoren

Der AI Director soll später Entscheidungen anhand mehrerer Faktoren treffen.

Wichtige Faktoren:

- Zone Ownership
- Base Ownership
- Capture-Pressure
- Capture-Progress
- Mission Availability
- Active Missions
- Completed Missions
- Failed Missions
- Logistics Hub Status
- FOB Status
- Supply Levels
- CAP Requests
- Air Threat
- IADS Threat
- Strategic Value
- Distance from Akrotiri
- Distance from Red Core Areas
- Current Campaign Phase
- Losses
- Resources
- Time Since Last Operation

Aktuell:

    Viele dieser Daten existieren bereits state-first.
    Sie sind aber noch nicht in einem AI-Director-Modell zusammengeführt.

---

## 20. Ressourcenmodell

Der AI Director soll später nicht unbegrenzt handeln.

Mögliche Ressourcen:

- Aircraft Availability
- Pilot Availability
- Fuel
- Ammo
- Supply
- Engineering
- IADS Readiness
- CAP Capacity
- Strike Capacity
- Logistics Capacity
- FOB Construction Capacity

Aktueller Stand:

    Es gibt noch kein produktives Ressourcenmodell.
    Logistics Hubs und FOBs liefern aber eine Grundlage.
    MissionGenerator und AICapManager liefern Missions- und CAP-State.

---

## 21. Reaktionsmodell

Der AI Director soll später auf Ereignisse reagieren.

Mögliche Ereignisse:

- Mission aktiviert
- Mission abgeschlossen
- Mission fehlgeschlagen
- Zone unter Druck
- Capture Ready
- Zone erobert
- FOB gebaut
- FOB beschädigt
- Logistics Hub geschwächt
- IADS-Site zerstört
- CAP Request offen
- CAP verloren
- Airbase beschädigt
- Red Hub bedroht
- Blue Hub bedroht

Aktueller Stand:

    Mission Activation ist bestätigt.
    Mission completed/failed ist noch nicht produktiv.
    CaptureSystem erzeugt Pressure/Progress.
    Ereignisbasierte AI-Reaktionen sind noch nicht aktiv.

---

## 22. F10 und AI

F10Menu ist aktuell aktiv.

F10Menu v0.2.0 kann anzeigen:

- verfügbare Missionen
- aktive Missionen
- Missionsdetails
- Kampagnenstatus
- Logistics Status
- FOB Status
- AI CAP Status

F10Menu kann aktuell:

- Mission 1 bis Mission 10 aktivieren

AI-bezogene aktuelle F10-Funktion:

    Show AI CAP Status

Spätere AI-F10-Funktionen:

- Show AI Director Status
- Show Blue AI Intent
- Show Red AI Intent
- Show AI Priority Zones
- Show AI Active Operations
- Show AI Pending Operations
- Show AI Threat Assessment
- Show AI Resource Assessment
- Debug Force AI Tick
- Debug Pause AI Director
- Debug Resume AI Director

Aktuell nächster UI-Schritt:

    Capture-/Pressure-Status anzeigen, nicht AI Director.

Grund:

    AI Director braucht sichtbare Capture-/Pressure-Daten als spätere Entscheidungsgrundlage.

---

## 23. Mission Effects und AI

Mission Effects sollen später AI-Entscheidungen beeinflussen.

Beispiele:

- erfolgreiche SEAD-Mission senkt IADS Threat
- erfolgreiche FOB-Support-Mission erhöht Blue Operations Capability
- gescheiterte Strike-Mission erhöht Red Confidence
- erfolgreiche Interdiction senkt Red Logistics
- erfolgreiche CAP-Mission senkt Air Threat
- Capture-Progress löst Red Counteraction aus
- FOB-Bau löst Red Attack Plan aus

Aktueller Stand:

    Mission Effects sind im MissionGenerator vorbereitet.
    CaptureSystem kann Mission Effects state-only vorbereiten.
    AI Director verarbeitet Mission Effects noch nicht.

---

## 24. Framework-Integration

Der AI Director soll später Frameworks nicht direkt als Architekturordnung verwenden.

Frameworks bleiben Werkzeuge.

Geplante Zuordnung:

- MOOSE für CAP, Strike, SEAD, DEAD, CAS und Mission Packages
- CTLD für Cargo, Transport und FOB-Support
- Skynet IADS für Luftverteidigung
- MIST nach Bedarf für Utility, Events oder Datenzugriff

Regel:

    AI Director trifft Entscheidungen.
    Fachmodule oder Bridges lösen später konkrete Framework-Aktionen aus.

Aktuell:

    keine echte Framework-Ausführung durch AI Director.

---

## 25. Geplante Datei

Geplante Datei:

    src/ai/tc_ai_director.lua

Mögliche erste Version:

    v0.1.0

Erster sinnvoller Umfang:

- Modul lädt
- State initialisiert
- AI Director Status erzeugt
- Blue Intent berechnet
- Red Intent berechnet
- Priority Zones aus bestehendem State ableitet
- keine echten Spawns
- keine Missionen automatisch aktiviert
- keine CTLD-Aktionen
- keine Skynet-Aktionen
- Logsummary erzeugt
- F10-/Debug-Anzeige später möglich

Noch nicht jetzt:

    Der AI Director sollte erst nach besserer F10-/Debug-Sichtbarkeit begonnen werden.

---

## 26. Warum der AI Director noch nicht der nächste Schritt ist

Der AI Director ist ein zentrales System, aber aktuell noch nicht der nächste sinnvolle Schritt.

Gründe:

- Capture-Pressure ist zwar vorhanden, aber im Spiel noch nicht sichtbar.
- Capture Ready Zones sind noch nicht über F10 sichtbar.
- Pressure Contested Zones sind noch nicht über F10 sichtbar.
- Mission completed/failed ist noch nicht testbar.
- Mission Effects sind noch nicht praktisch geprüft.
- Persistence ist noch nicht getestet.
- IADS-System ist noch nicht angebunden.
- echte Framework-Aktionen sind noch deaktiviert.

Deshalb gilt:

    Erst Capture-/Pressure-Sichtbarkeit.
    Dann Mission completed/failed.
    Dann Mission Effects testen.
    Danach AI Director state-only beginnen.

---

## 27. Risiken

Risiken bei zu frühem AI-Director-Bau:

- AI trifft Entscheidungen auf unsichtbaren State-Daten
- falsche Prioritäten bleiben unbemerkt
- Missionen werden unkontrolliert erzeugt oder aktiviert
- Capture-Druck wird falsch interpretiert
- Logistikzustand wird falsch gewichtet
- F10/Debug zeigt nicht genug zur Fehlersuche
- MOOSE-Spawns werden zu früh ausgelöst
- Red und Blue Verhalten wird schwer reproduzierbar
- Persistenz speichert inkonsistente AI-Entscheidungen

Gegenmaßnahmen:

- AI Director zunächst state-only
- keine echten Spawns in v0.1.0
- klare Logmarker
- F10-/Debug-Sichtbarkeit
- kleine Entscheidungsmodelle
- keine parallelen Großsysteme
- Tests mit frischer dcs.log

---

## 28. Aktuelle Akzeptanzkriterien für AICapManager

Aktuell bestanden:

- AICapManager lädt.
- AICapManager startet.
- CAP-Zonen-Kandidaten werden erkannt.
- 12 CAP-Zonen werden registriert.
- 12 CAP Requests werden erzeugt.
- reactionState wird gesetzt.
- threatLevel wird gesetzt.
- keine MOOSE-Spawns.
- keine Lua-Fehler.
- keine Theater-Command-Fehler.

Noch offen:

- echte MOOSE-CAP-Flüge
- AI Director
- GCI-Logik
- Blue-/Red-Operationsplanung
- Ressourcenmodell
- Verlustauswertung
- AI-Persistenz

---

## 29. Aktueller getesteter Systemstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.1` | bestanden |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.2` | bestanden |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.0` | bestanden |

---

## 30. Nächster sinnvoller Schritt

Der nächste sinnvolle Schritt liegt nicht direkt beim AI Director.

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

## 31. Aktueller Status

AI-seitig ist aktuell nur der AICapManager aktiv und bestanden.

Der vollständige AI Director ist noch nicht implementiert.

Aktuelle Fähigkeit:

- CAP-Zonen-Kandidaten werden erkannt.
- CAP-Requests werden erzeugt.
- AI-CAP-State ist vorhanden.
- F10Menu kann AI CAP Status anzeigen.
- MOOSE-CAP-Spawns sind vorbereitet, aber nicht aktiv.

Nächster notwendiger Zwischenschritt:

    Capture-/Pressure-Sichtbarkeit im F10-Menü.

Danach sinnvoll:

    Mission completed/failed testbar machen.
    Mission Effects kontrolliert testen.
    Erst danach AI Director state-only beginnen.
