# AI Director

## Verbindliches Update — 2026-09-12

Der vollständige AI Director ist weiterhin **nicht implementiert**. Aktiv ist ausschließlich das vorbereitende AI-Fachmodul `src/ai/tc_ai_cap_manager.lua`, `v0.2.0`, state-first funktional bestanden. Es gibt keine autonome Blue-/Red-Kampagnenplanung und keine echten CAP-, GCI-, Strike-, SEAD-, DEAD-, CAS- oder Transportoperationen durch dieses AI-System. MOOSE-Hooks bleiben vorbereitet (`spawn=MOOSE_PENDING`).

MissionGenerator `v0.2.3` erzeugt 10 Mission Records. Seine Status-Collections sind String-keyed Lua-Dictionaries; live bestätigt sind `statistics.available=10`, `pairs()`-Count `=10` und `#available=0`. Der Längenoperator `#` ist dafür nicht autoritativ. Der Record-Loss-Verdacht ist widerlegt; der tatsächliche Bug lag in `src/core/tc_state.lua` -> `State.summary()`. Der pairs-basierte `countEntries()`-Fix ist live bestanden. MissionGenerator-abhängige Aussagen sind durch diesen früheren Diagnosefehler nicht mehr eingeschränkt.

Der Offline Embedded Mission Resource Audit ist abgeschlossen: DEV und MCP_TEST waren beim Audit byte-identisch, 13/13 relevante aktive Theater-Command-Ressourcen waren `EXACT_MATCH`; keine aktive Embedded-Runtime-Drift.

PersistenceSystem `v0.2.6` ist dirty-aware: Embedded Start, `20s`-/`120s`-Scheduler, `SAVED`, `SKIPPED`, kontrollierter `FAILED`-Pfad und Retry bestanden. Mission Completion, Mission Failure und Capture Ready Apply wurden am 2026-09-12 erneut live bestanden, einschließlich Background Save. `productiveRestore=false`.

AI-State gehört zum Persistence-Snapshot. Der reale Dirty-Grund `ai_cap_needs_evaluated` wurde vom Background-Autosave gespeichert. `reactToActiveMissions()` ist dagegen nicht produktiv verdrahtet; sein latenter Dirty-Randfall ist bewertet (Abschnitt 13). Das ersetzt keine vollständige AICapManager-Dirty-Coverage. Priority 3 bleibt offen; nächster technischer Einzelschritt ist der READ-ONLY Dirty-Coverage-Audit von LogisticsDelivery.

Referenzen: `README.md`, `ROADMAP.md`, `TASKS.md`, `ARCHITECTURE.md`, `CHANGELOG.md`, `MISSION_EDITOR_SETUP.md`, `docs/00_project_overview.md`, `docs/02_technical_architecture.md`, `docs/06_mission_generator.md`, `docs/09_persistence.md` und `docs/10_testing.md`. AI-spezifische Source-Aussagen sind READ ONLY gegen AICapManager, State, PersistenceSystem und die produktiven `src/`-Call-Sites geprüft.

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

    2026-09-12

Aktive AI-Datei:

    src/ai/tc_ai_cap_manager.lua

Getestete Version:

    v0.2.0

Status:

    state-first funktional bestanden

Geplante spätere Datei:

    src/ai/tc_ai_director.lua

Aktuell vorhanden:

- AI-Ordnerstruktur
- `src/ai/README.md`
- `src/ai/tc_ai_cap_manager.lua`
- CAP-Zonen-Kandidaten
- CAP-Requests
- Blue-/Red-CAP-State
- `reactionState` und `threatLevel`
- AI-State im Persistence-Snapshot
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
- produktiver AI-Restore
- vollständig auditierte allgemeine AICapManager-Dirty-Coverage

`src/ai/tc_ai_director.lua` ist geplant, nicht vorhanden oder aktiv. AI-State wird bereits gespeichert; beim Missionsstart wird er noch nicht produktiv restauriert (`productiveRestore=false`).

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

AICapManager ist funktional bestätigt und bereitet CAP-Bedarf state-only vor. Die allgemeine Dirty-Coverage bleibt trotzdem offen; die zwölf Requests sind keine zwölf realen CAP-Flüge.

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
    Mission candidates: 78
    FOB Support candidates: 2
    Mission Records: 10
    CAP-Zonen-Kandidaten: 31
    CAP Requests: 12

Diese Datenbasis ist inzwischen stabil genug, um den AI Director später sinnvoll aufzubauen.

Mission Records liegen in String-keyed Status-Dictionaries. `pairs()` bzw. pairs-basierte Zählhelfer sind autoritativ; eine Record-Loss-Einschränkung besteht nicht mehr.

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

Bestätigte Startwerte:

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
    Capture Ready und Capture-/Pressure-F10-Sichtbarkeit sind bestanden.
    Capture Ready Apply, Zone Ownership Update und linked Airbase Ownership Sync sind bestanden.
    Mission Completion -> Capture Pressure ist bestätigt.
    Mission Failure -> kein Capture Pressure ist bestätigt.

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

LogisticsDelivery ist funktional bestanden. Die allgemeine Logistics-Dirty-Coverage wurde noch nicht systematisch auditiert; LogisticsDelivery ist der nächste Priority-3-Audit. Eine produktive AI-Logistics-Verknüpfung besteht nicht.

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

Die allgemeine FOB-Dirty-Coverage bleibt offen. Es werden keine echten CTLD-FOBs erzeugt.

---

## 12. Verhältnis zu MissionGenerator

MissionGenerator erzeugt Missionen aus Kampagnenzustand.

Aktuelle Werte:

    mission candidates: 78
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 68

AI Director soll später mit MissionGenerator zusammenarbeiten.

Mögliche Rollenverteilung:

MissionGenerator:

- erzeugt mögliche Missionen
- verwaltet Mission Records
- verwaltet Mission Status
- bereitet Mission Effects vor
- stellt Mission-Daten für die F10-Anzeige bereit

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

Bestätigt sind 10 Mission Records, Activation, Completion, Failure und Effects sowie Completion -> Capture Pressure und Failure -> kein Capture Pressure. MissionGenerator bleibt state-only; ein AI Director ist nicht produktiv mit ihm verdrahtet. Die allgemeine MissionGenerator-Dirty-Coverage bleibt offen.

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

### 13.1 reactToActiveMissions(options) — READ-ONLY Auditbefund

`CapManager.reactToActiveMissions(options)` existiert. Die Funktion liest aktive Missionen und kann über `requestCap()` CAP-Reaktionen für deren Zielzonen anfordern. Danach ruft sie `updateReactionState()` und `updateStatistics()` auf; am Ende steht kein eigener `markDirty()`-Call.

Die repo-weite Prüfung der produktiven Source ergab keine Call-Site: weder aus `CapManager.start()`, Scheduler/Timer, `main.lua`, `loader.lua`, F10 noch anderen produktiven `src/`-Pfaden. Es besteht daher noch keine automatische Mission->AI-CAP-Reaktionskette.

Klassifikation: **B) latenter Missing-Dirty-Randfall in derzeit nicht verdrahtetem Code.**

Bei einem echten neuen CAP-Request greift `addCapToContainer()` mit `markDirty("ai_cap_record_changed")`. Bei späterer Verdrahtung könnten jedoch insbesondere `reactionState`, `threatLevel`, `capStatistics` und `lastUpdate` im `requested==0`-Pfad geändert werden, ohne dass ein sicherer Request-Dirty-Pfad greift.

Aktuell ist dies **kein gegenwärtiger Runtime-Persistence-Bug**. Kein Code-Fix jetzt; bei späterer Verdrahtung erneut prüfen. Die allgemeine AICapManager-Dirty-Coverage bleibt unabhängig von diesem bewerteten Sonderfall in Priority 3 offen.

### 13.2 evaluateCapNeeds() — bestätigter AI-Dirty-/Save-Pfad

`evaluateCapNeeds()` ist ein anderer Pfad und wird von `CapManager.start()` aufgerufen. Nach der Evaluation sowie `updateReactionState()` und `updateStatistics()` setzt er ausdrücklich `markDirty("ai_cap_needs_evaluated")`.

Der normale Background-Scheduler hat diesen realen Dirty-Grund bereits gespeichert:

    Periodic autosave decision: SAVED dirtyReason=ai_cap_needs_evaluated

Danach war `dirty=false`; spätere unveränderte Scheduler-Ticks wurden mit `SKIPPED` ohne Dateischreiben übersprungen. Der Save erforderte keine Spieleraktion. Das bestätigt einen funktionierenden AI-Dirty-/Persistence-Pfad, aber keine vollständige Dirty-Coverage des gesamten AICapManager.

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

Aktuell vorhanden ist AICapManager-bezogener State unter `State.AI`: unter anderem `capZones`, `capZoneCandidates`, `capRequests`, `reactionState`, `threatLevel`, `capStatistics` und `lastUpdate`.

Geplanter Director-State — ausschließlich Zukunftsmodell, nicht produktiv implementiert:

Der spätere AI Director soll eigenen State erzeugen. Mögliche State-Bereiche:

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

Persistence führt `AI` in `PersistenceSystem.sections` und kopiert diesen Bereich in den serialisierbaren Snapshot. AI-State wird gespeichert, aber beim Missionsstart noch nicht produktiv restauriert (`productiveRestore=false`).

Vor Restore bleiben erforderlich: Priority 3 abschließen, Restore-/Initialisierungsreihenfolge definieren, Save-Kompatibilität/Versionierung festlegen, kontrollierten Restore-Test durchführen und unbeabsichtigte Framework-Hooks beim Restore ausschließen. Daraus entsteht aktuell keine autonome AI aus restauriertem State.

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

Mission Completion/Failure und Capture Ready Apply sind als State-/Outcome-Pfade technisch bestätigt und damit mögliche spätere Inputs. Kein AI Director führt diese Daten aktuell zu autonomen Entscheidungen zusammen.

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
    Mission Completion, Mission Failure und Mission Effects sind funktional bestätigt.
    Capture Pressure, Capture Progress und Capture Ready sind bestätigt.
    Capture Ready Apply, Zone Ownership Update und linked Airbase Ownership Sync sind bestätigt.
    Ereignisbasierte autonome AI-Director-Reaktionen sind weiterhin nicht aktiv.

Getesteter Event-/State-Pfad bedeutet noch keine autonome AI-Reaktion. `reactToActiveMissions()` ist nicht produktiv verdrahtet (Abschnitt 13).

---

## 22. F10 und AI

F10Menu ist aktuell aktiv.

F10Menu `v0.2.3` ist mit 33 Commands bestanden. Aktuell bestätigt:

- Show Available Missions
- Show Active Missions
- Mission Details 1–10
- Mission Activation 1–10
- Active Mission Outcome Status
- Complete Active Mission 1
- Fail Active Mission 1
- Show Campaign Status
- Show Capture Status
- Show Capture Ready Zones
- Apply Capture Ready Zone 1
- Show Pressure Contested Zones
- Show Logistics Status
- Show FOB Status
- Show AI CAP Status

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

Capture-/Pressure-Sichtbarkeit ist abgeschlossen. Es gibt weiterhin kein produktives AI-Director-F10-Menü; die oben genannten Director-/Debug-Befehle sind ausschließlich Zukunftsideen.

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
    CaptureSystem verarbeitet abgeschlossene Capture-relevante Mission Effects state-only.
    AI Director verarbeitet Mission Effects noch nicht.

Mission Failure ist ebenfalls funktional bestätigt; der getestete Capture-Pfad verarbeitet die Failure Effects mit `applied=0` und erzeugt keinen Capture Pressure. Eine autonome AI-Reaktion auf Mission Effects ist nicht aktiv.

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

    Der geplante AI Director soll Entscheidungen treffen.
    Fachmodule oder Bridges lösen später konkrete Framework-Aktionen aus.

Aktuell:

    keine echte Framework-Ausführung durch AI Director.

MOOSE ist geladen, wird aber nicht produktiv für AI-Spawns genutzt. CTLD ist geladen und wird nicht produktiv durch AI genutzt. Skynet ist geladen; ein eigener produktiver AI-/IADS-Director fehlt. MIST bleibt nach Bedarf ein Werkzeug. Frameworks bestimmen nicht die fachliche Architekturordnung.

---

## 25. Geplante Datei

Geplante Datei:

    src/ai/tc_ai_director.lua

Mögliche erste Version (bestehendes Konzept, keine implementierte Version):

    v0.1.0

Möglicher späterer Anfangsumfang (kein aktueller Implementierungsauftrag):

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

    F10-/Capture-Sichtbarkeit ist vorhanden.
    Zuerst Priority 3 abschließen und bestehende State-Module persistence-seitig absichern.
    productiveRestore bleibt false; echte Framework-Ausführung folgt später.
    Keine neuen Großsysteme parallel beginnen.

---

## 26. Warum der AI Director noch nicht der nächste Schritt ist

Capture Pressure, Capture Ready Zones und Pressure Contested Zones sind bereits über F10 sichtbar. Mission Completion/Failure, Mission Effects, Capture Ready Apply und Background Persistence sind getestet. Diese Punkte sind keine offenen Vorbedingungen mehr.

Der aktuelle nächste Meilenstein ist Priority 3: die allgemeine Dirty-Coverage bereits aktiver State-Systeme abschließen. **Priority 3 ist nicht abgeschlossen.**

Bereits geklärt:

- Capture Getter-/Derived-Dirty.
- Capture Ownership No-Op.
- `reactToActiveMissions()`-Sonderfall (latent, nicht verdrahtet).

Noch systematisch zu prüfen, jeweils ein Modul pro Schritt:

1. `src/logistics/tc_logistics_delivery.lua`
2. `src/logistics/tc_fob_system.lua`
3. `src/missions/tc_mission_generator.lua`
4. `src/ai/tc_ai_cap_manager.lua`

Für AICapManager gilt: funktional bestanden ist keine vollständig bestandene Dirty-Coverage. Erst danach wird die nächste Architekturentscheidung getroffen; AI Director wird nicht vorgezogen.

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

Background Persistence funktioniert. Das aktuelle Persistence-Risiko liegt in der noch nicht vollständig auditierten Dirty-Coverage aller AI-Mutationspfade und im späteren Restore.

- Autonome AI darf keine persistierten State-Änderungen ohne Dirty erzeugen.
- Reine AI-Reads und echte No-Ops dürfen kein unnötiges Dirty erzeugen.
- Später verdrahtete Funktionen wie `reactToActiveMissions()` müssen vor Aktivierung Dirty-seitig erneut geprüft werden.
- Produktiver AI-Restore bleibt deaktiviert; Voraussetzungen siehe Abschnitt 18.

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

Zusätzlich bestätigt:

- `evaluateCapNeeds()` setzt den realen Dirty-Grund `ai_cap_needs_evaluated`.
- Background Autosave hat darauf mit `SAVED` reagiert; danach `dirty=false` und unveränderte Ticks `SKIPPED`.
- `reactToActiveMissions()` ist READ-ONLY auditiert und als latent/unwired klassifiziert.

Noch offen:

- echte MOOSE-CAP-Flüge
- AI Director
- GCI-Logik
- Blue-/Red-Operationsplanung
- Ressourcenmodell
- Verlustauswertung
- produktiver AI-Restore
- vollständig auditierte allgemeine AICapManager-Dirty-Coverage

---

## 29. Aktueller getesteter Systemstand

Stand: **2026-09-12**.

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | funktional bestanden; Read-Dirty- und Ownership-No-Op-Regressionen bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | Embedded Start, SAVED, SKIPPED, FAILED, Retry und Campaign-Persistence-Regressionen bestanden; productiveRestore=false |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | funktional bestanden; Dirty-Coverage ist nächster Priority-3-Audit |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | funktional bestanden; allgemeine Dirty-Coverage offen |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | 10 Mission Records; Activation, Completion, Failure und Effects bestanden; Record-Loss widerlegt; allgemeine Dirty-Coverage offen |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | state-first bestanden; reactToActiveMissions()-Sonderfall bewertet; allgemeine Dirty-Coverage offen |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden; 33 Commands |

---

## 30. Nächster sinnvoller Schritt

Nächster technischer Projektschritt: **Priority 3 — READ-ONLY Dirty-Coverage-Audit von `src/logistics/tc_logistics_delivery.lua`**.

Audit-Ziele:

- persistierte Logistics-State-Writes erfassen.
- `markDirty()`-Pfade erfassen.
- Call-Sites prüfen.
- echte Mutationen von Reads/No-Ops unterscheiden und auf Dirty-Coverage prüfen.
- Dirty Reasons bewerten.
- runtime-only und persistierten State unterscheiden.
- keine Codeänderung ohne belegten Befund.

AI Director ist nicht der nächste technische Schritt. FOB, MissionGenerator und AICapManager folgen später einzeln; dieser Dokumentationsschritt führt ihre allgemeinen Audits nicht vorweg.

---

## 31. Aktueller Status

AI-seitig aktiv ist ausschließlich **AICapManager `v0.2.0`**, state-first funktional bestanden.

Bestätigt:

- 31 CAP-Zonen-Kandidaten.
- 12 auto-registrierte CAP-Zonen.
- 12 CAP Requests.
- `reactionState=AIR_REACTION_REQUESTED`.
- `threatLevel=HIGH`.
- state-only, `spawn=MOOSE_PENDING`.
- `evaluateCapNeeds()`-Dirty-Pfad durch Background Autosave gespeichert.
- `reactToActiveMissions()` existiert, ist aber nicht produktiv verdrahtet.
- AI-State gehört zum gespeicherten Snapshot; `productiveRestore=false`.

Nicht implementiert sind der vollständige AI Director, autonome Blue-/Red-Operationen, echte MOOSE CAP, produktive GCI-Logik und ein produktives AI-Ressourcenmodell.

Priority 3 bleibt offen. Nächster technischer Einzelschritt ist der READ-ONLY Dirty-Coverage-Audit von LogisticsDelivery. Danach folgen separat FOB, MissionGenerator und AICapManager. Erst danach steht eine neue AI-Director-Implementierungsentscheidung an.
