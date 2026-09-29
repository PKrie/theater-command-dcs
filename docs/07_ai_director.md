# AI Director

## Verbindlicher Stand — 2026-09-29

Diese Datei beschreibt den geplanten AI Director von **Theater Command DCS** sowie den aktuell bereits vorhandenen AI-CAP-State.

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue startet auf Akrotiri / Zypern.
    Das syrische Festland ist zu Kampagnenbeginn rot kontrolliert.

Aktueller Entwicklungsbereich:

    Priority 4 – produktive CTLD-Integration vorbereiten

Priority 3:

    abgeschlossen im dokumentierten Umfang seit 2026-09-21

Verbindlich:

    productiveRestore=false

Aktives AI-Fachmodul:

    src/ai/tc_ai_cap_manager.lua
    v0.2.1

Vollständiger AI Director:

    noch nicht implementiert

---

## 1. Zweck des AI Directors

Der AI Director soll langfristig die strategische und operative KI-Entscheidungsebene von Theater Command DCS bilden.

Er soll nicht nur einzelne Gruppen oder Flugzeuge spawnen.

Er soll aus dem aktuellen Kampagnenzustand ableiten:

- welche Operationen erforderlich sind
- welche Seite welchen Schwerpunkt verfolgt
- welche Räume verteidigt werden müssen
- welche Räume angegriffen werden sollen
- welcher Missionsbedarf besteht
- welcher Logistikbedarf besteht
- wo CAP erforderlich ist
- wo SEAD / DEAD erforderlich ist
- wann Ground Operations unterstützt werden müssen
- wann Gegenreaktionen erforderlich sind
- welche Ressourcen verfügbar sind

Langfristiges Ziel:

    Blue und Red führen eigene Operationen durch.
    Spieler sind Teilnehmer einer laufenden Kampagne.
    Die Kampagne hängt nicht ausschließlich von Spieleraktionen ab.

Der vollständige AI Director ist aktuell noch nicht implementiert.

---

## 2. Architekturrolle

Der AI Director folgt dem allgemeinen Theater-Command-Prinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis / Source of Truth
    DCS Runtime = autoritativer Verhaltensbeweis

Zusätzlich gilt:

    Theater Command = Campaign Logic / Decision Layer / State Owner
    Vendor-Frameworks = Execution Layer

Der spätere AI Director soll entscheiden:

    was getan werden soll

Fachmodule und Frameworks sollen ausführen:

    wie die Aktion technisch in DCS durchgeführt wird

Beispiele:

    CAP-Bedarf
    -> AICapManager
    -> spätere MOOSE-Execution

    Logistics-Bedarf
    -> Logistics-/Transportauftrag
    -> spätere CTLD-/DCS-Execution

    IADS-Reaktion
    -> Theater-Command-IADS-State
    -> Skynet-Execution

Der AI Director soll Frameworks nicht selbst zum Eigentümer des Kampagnenzustands machen.

---

## 3. Aktueller AI-Stand

Aktiv ist derzeit ausschließlich das vorbereitende AI-Fachmodul:

    src/ai/tc_ai_cap_manager.lua

Version:

    v0.2.1

Status:

    state-first bestanden
    Read-Neutrality bestanden

Bestätigt:

    CAP-Zonen-Kandidaten: 31
    registrierte CAP-Zonen: 12
    CAP Requests: 12

Aktueller Zustand:

- CAP-State wird erzeugt.
- Blue-/Red-CAP-Bedarf kann state-first dargestellt werden.
- MOOSE-Hooks sind vorbereitet.
- reale MOOSE-CAP-Flüge werden noch nicht erzeugt.
- vollständiger AI Director existiert noch nicht.
- autonome Blue-/Red-Operationsplanung existiert noch nicht.

---

## 4. Was AICapManager ist

AICapManager ist ein fachliches Teilmodul.

Aufgaben:

- geeignete CAP-Zonen bestimmen
- CAP-Zonen registrieren
- CAP-Requests erzeugen
- CAP-State verwalten
- Luftbedrohungs-/Reaktionsstate vorbereiten
- spätere MOOSE-Ausführung vorbereiten
- State für UI und Persistence bereitstellen

AICapManager ist nicht:

- vollständiger AI Director
- strategischer Kampagnenplaner
- MOOSE Dispatcher
- Missionsgenerator
- Ground Commander
- Logistics Director

---

## 5. Was der spätere AI Director sein soll

Der spätere AI Director soll mehrere Fachsysteme koordinieren.

Perspektivische Aufgaben:

- Operationslage bewerten
- Blue Intent bestimmen
- Red Intent bestimmen
- Schwerpunktzonen bestimmen
- Missionsbedarf erzeugen
- vorhandene Missionen priorisieren
- CAP-Bedarf priorisieren
- Logistics berücksichtigen
- FOB-State berücksichtigen
- Capture-State berücksichtigen
- Ground Operations berücksichtigen
- IADS berücksichtigen
- verfügbare Assets berücksichtigen
- Verluste berücksichtigen
- Ressourcen berücksichtigen
- Gegenreaktionen erzeugen

Kurz:

    AICapManager = CAP-Fachmodul
    AI Director = spätere strategische Koordinationsschicht

---

## 6. State-first-Grundsatz

Auch der AI Director wird state-first entwickelt.

Reihenfolge:

    Kampagnenstate lesen
    -> Lage bewerten
    -> Intent erzeugen
    -> Intent sichtbar machen
    -> Intent testen
    -> Dirty-/Persistence-Semantik prüfen
    -> erst danach Execution anbinden

Eine spätere erste AI-Director-Version soll deshalb nicht sofort:

- reale MOOSE-Flüge erzeugen
- CTLD-Operationen starten
- Skynet-Gruppen verändern
- Ground Forces autonom bewegen

Zuerst muss die Entscheidungsebene nachvollziehbar sein.

---

## 7. Aktuelle Datenbasis

Viele der später benötigten Eingabedaten existieren bereits.

Bestätigt:

    Syria Airbase-like Objects: 225
    relevante Kampagnenzonen: 46
    Capture Candidates: 32
    Capture Pressure Records: 32
    Capture Progress Records: 32
    Logistics Hubs: 46
    FOB Candidates: 6
    Blue FOBs: 2
    Mission Candidates: 78
    Mission Records: 10
    CAP-Zonen-Kandidaten: 31
    CAP Requests: 12

Diese State-Basis ist bereits erheblich weiter entwickelt als zu Projektbeginn.

Sie wird jedoch noch nicht von einem zentralen AI Director zusammengeführt.

---

## 8. Verhältnis zu Airbase Scanner

Airbase Scanner:

    src/world/tc_airbase_scanner.lua
    v0.2.2

Bestätigt:

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

Der spätere AI Director kann daraus ableiten:

- strategische Schlüsselbasen
- Blue Main Base
- Red Kernbasen
- Operationsachsen
- mögliche Ziele
- gefährdete eigene Infrastruktur
- logistische Schwerpunkte

Der AI Director soll nicht direkt auf allen 225 DCS-Airbase-like Objects planen.

---

## 9. Verhältnis zu ZoneFactory

ZoneFactory:

    src/world/tc_zone_factory.lua
    v0.2.0

Bestätigt:

    relevante Kampagnenzonen: 46
    strategic zones: 19
    secondary zones: 13
    heliport zones: 1
    tactical zones: 13
    captureZones: 32
    missionZones: 32
    logisticsZones: 46
    startBaseZones: 1

Der spätere AI Director soll die gefilterten Kampagnenzonen verwenden.

Mögliche Bewertungen:

- Owner
- Strategic Relevance
- Capture Pressure
- Capture Progress
- Logistics Status
- FOB-Nähe
- CAP-Bedarf
- IADS-Bedrohung
- Operationsentfernung
- aktive Missionen

---

## 10. Verhältnis zu CaptureSystem

CaptureSystem:

    src/campaign/tc_capture_system.lua
    v0.2.2

Bestätigt:

- Ownership
- Capture Eligibility
- Capture Pressure
- Capture Progress
- Capture Ready
- Mission Effects
- Capture Apply
- linked Airbase Sync
- Read-Neutrality
- Ownership No-Op

Der spätere AI Director soll daraus unter anderem ableiten:

- welche Zonen angegriffen werden sollen
- welche Zonen verteidigt werden sollen
- wo Blue Druck aufbauen soll
- wo Red entlasten muss
- wo Logistics benötigt wird
- wo CAP benötigt wird
- wo Gegenangriffe sinnvoll sind

Aktuell:

    kein autonomer AI-Director-Entscheidungspfad

Bestätigt ist dagegen bereits die state-first Kampagnenkette:

    Mission Completion
    -> Capture Pressure
    -> Capture Progress
    -> Capture Ready
    -> kontrollierter Apply
    -> Ownership

---

## 11. Verhältnis zu LogisticsDelivery

LogisticsDelivery:

    src/logistics/tc_logistics_delivery.lua
    v0.2.1

Bestätigt:

    Logistics Hubs: 46
    Blue: 7
    Red: 24
    Neutral: 15
    Active: 31
    Limited: 15
    Locked: 0

Priority-3-Ergebnis:

    Read-Neutrality bestanden

Der spätere AI Director soll Logistics unter anderem bewerten für:

- Operationsfähigkeit
- Versorgungsbedarf
- Transportbedarf
- Schutz wichtiger Hubs
- Interdiction
- FOB-Aufbau
- Engineering
- Repair
- Fuel
- Ammo

Aktuell besteht keine produktive:

    AI Director
    -> Logistics Auftrag

Kette.

---

## 12. Verhältnis zu FobSystem

FobSystem:

    src/logistics/tc_fob_system.lua
    v0.2.1

Bestätigt:

    FOB Candidates: 6
    Blue FOBs: 2

State-only FOBs:

    FOB Ercan
    FOB Gecitkale

Status:

    UNDER_CONSTRUCTION

Priority-3-Ergebnis:

    Read-Neutrality bestanden

Der spätere AI Director soll FOBs unter anderem berücksichtigen für:

- Operationsreichweite
- Forward Logistics
- CAP-Bedarf
- Schutzbedarf
- Supply
- Ausbau
- Angriff durch Red
- Support-Missionen

Aktuell sind die FOBs noch keine real durch CTLD gebauten DCS-FOBs.

---

## 13. Verhältnis zu MissionGenerator

MissionGenerator:

    src/missions/tc_mission_generator.lua
    v0.2.3

Bestätigt:

    Mission Candidates: 78
    FOB Support Candidates: 2
    Mission Records: 10

Bestätigte Statuspfade:

    AVAILABLE -> ACTIVE
    ACTIVE -> COMPLETED
    ACTIVE -> FAILED

MissionGenerator kann:

- Mission Records erzeugen
- Objectives erzeugen
- Briefings erzeugen
- Mission Effects vorbereiten
- Status verwalten
- F10-Daten bereitstellen

Der spätere AI Director soll:

- Missionsbedarf bewerten
- Prioritäten setzen
- Missionstypen anfordern
- vorhandene Missionen gewichten
- auf Missionsergebnisse reagieren

Aktuell besteht keine autonome:

    AI Director
    -> MissionGenerator
    -> Mission Activation

Kette.

---

## 14. Mission-Record-Diagnose

Der frühere Verdacht eines Mission-Record-Verlusts wurde am:

    2026-09-12

widerlegt.

Mission-Collections sind String-keyed Lua-Dictionaries.

Deshalb ist:

    #table

nicht autoritativ.

Live bestätigt:

    statistics.available=10
    pairs()-Count=10
    #available=0

Der tatsächliche Zählfehler lag in:

    src/core/tc_state.lua
    State.summary()

MissionGenerator selbst verlor keine Records.

Der AI-Director-Entwurf muss deshalb keine Workarounds für einen nicht existierenden Mission-Record-Loss enthalten.

---

## 15. Verhältnis zu AICapManager

AICapManager ist aktuell das einzige aktive AI-Fachmodul.

Aktuelle Version:

    v0.2.1

Bestätigte Werte:

    cap zone candidates: 31
    auto-registered CAP zones: 12
    CAP requests: 12

Der spätere AI Director soll AICapManager nicht ersetzen.

Mögliche Rollenverteilung:

    AI Director
    -> entscheidet, wo CAP strategisch benötigt wird

    AICapManager
    -> verwaltet CAP-Zonen und CAP-Requests

    MOOSE
    -> führt später reale CAP-Flüge aus

Diese Trennung folgt der fachlichen Architektur.

---

## 16. Priority-3-Ergebnis für AICapManager

Priority 3 wurde am:

    2026-09-21

im dokumentierten Umfang abgeschlossen.

AICapManager wurde dabei auf Read-Neutrality geprüft und angepasst.

Neue Version:

    v0.2.1

Bestätigte read-neutrale Pfade umfassen:

    getStatistics()
    summary()
    getCap()
    getCapZones()
    getCapZoneCandidates()
    getRequestedCaps()
    getActiveCaps()
    getCompletedCaps()
    getFailedCaps()
    getCancelledCaps()
    getCapsBySide()

Diese Getter verändern keinen persistierten AI-State mehr.

Echte Mutationen behalten ihre Dirty-Semantik.

Positiv bestätigt:

    setCapStatus()
    -> dirtyReason=ai_cap_record_changed

Priority 3 ist damit für den aktiven AICapManager im dokumentierten Umfang abgeschlossen.

---

## 17. `evaluateCapNeeds()`

`evaluateCapNeeds()` ist ein aktiver AICapManager-Pfad.

Der Pfad kann CAP-Bedarf bewerten und State aktualisieren.

Bestätigter Dirty-Grund:

    ai_cap_needs_evaluated

Der Background Autosave hat diesen Dirty-Grund bereits erfolgreich gespeichert.

Bestätigt:

    SAVED
    dirty=false nach erfolgreichem Save

Nachfolgende unveränderte Autosave-Ticks konnten:

    SKIPPED

bleiben.

Damit ist ein realer AI-State-/Persistence-Pfad praktisch bestätigt.

---

## 18. `reactToActiveMissions()`

Die Funktion:

    CapManager.reactToActiveMissions(options)

existiert weiterhin.

Sie kann aktive Missionen lesen und daraus CAP-Reaktionen ableiten.

Der bisherige Source-Audit ergab:

    keine produktive Call-Site

Insbesondere wurde keine aktive Verdrahtung festgestellt aus:

- `CapManager.start()`
- Scheduler
- Timer
- `main.lua`
- `loader.lua`
- F10
- anderen produktiven `src/`-Pfaden

Deshalb besteht aktuell keine automatische:

    Mission
    -> AI CAP Reaction

Kette.

Der Pfad bleibt ein **latenter Lifecycle-/Dirty-Prüfpunkt für eine spätere Verdrahtung**.

Er ist aktuell kein nachgewiesener Runtime-Persistence-Bug.

Vor einer zukünftigen Aktivierung muss er erneut gegen die dann aktuelle Source und Dirty-Semantik geprüft werden.

Er ist kein Grund, Priority 3 erneut vollständig zu öffnen.

---

## 19. Verhältnis zu CTLD

CTLD:

    1.6.1

ist ein möglicher späterer Execution Layer für Transport- und Logistics-Operationen.

Am:

    2026-09-29

wurde für den getesteten Aufbau ein vollständiger KI-Truppentransport praktisch bestätigt:

    automatischer Pickup
    -> Taxi
    -> Takeoff
    -> Transit
    -> Off-Airfield-Landung
    -> automatischer Dropoff
    -> reale Blue-Bodengruppe

Luftfahrzeug:

    Mi-8

Pickup:

    16 Soldaten

Erzeugte Bodengruppe:

    Dropped Group 2
    16 x Soldier M249

Dieser Test ist für den zukünftigen AI Director relevant, weil er beweist:

    ein realer KI-Transportpfad ist für diesen getesteten Aufbau technisch möglich

Er beweist nicht:

    AI Director kann bereits Transportoperationen planen oder auslösen

---

## 20. AI Director und zukünftige Transportoperationen

Langfristig ist eine Kette denkbar wie:

    AI Director
    -> erkennt Logistics-/Ground-Bedarf
    -> erzeugt Intent
    -> fachliches Logistics-/Transport-System erzeugt Auftrag
    -> CTLD / DCS führt Auftrag aus
    -> Ergebnis wird validiert
    -> Theater-Command-State wird aktualisiert
    -> Dirty
    -> Persistence

Der AI Director soll dabei nicht selbst:

- CTLD-Tabellen direkt verwalten
- Vendor-Code verändern
- Transporter-Onboard-State manipulieren

Die aktuelle Priority-4-Arbeit muss zuerst die fachliche CTLD-Integrationsgrenze definieren.

---

## 21. Verhältnis zu IADS

Skynet IADS:

    3.3.0

ist geladen.

Eine produktive Theater-Command-IADS-Integration existiert noch nicht.

Der spätere AI Director soll IADS-Daten berücksichtigen können:

- SAM-Abdeckung
- EWR-Abdeckung
- beschädigte Sites
- zerstörte Sites
- sichere Korridore
- gefährliche Luftkorridore
- SEAD-Bedarf
- DEAD-Bedarf
- Schutz kritischer Räume

Aktuell:

    kein produktiver AI-Director-IADS-Pfad

---

## 22. Blue AI Design

Blue AI soll später selbständig Operationen planen können.

Mögliche Blue-Prioritäten:

- Akrotiri sichern
- Luftüberlegenheit aufbauen
- CAP über wichtigen Räumen bereitstellen
- SEAD / DEAD vorbereiten
- strategische Ziele aufklären
- Logistics Push durchführen
- FOB-Aufbau unterstützen
- bedrohte Blue Hubs verteidigen
- Capture Pressure aufbauen
- Airbases angreifen
- Ground Operations unterstützen
- Gegenreaktionen auf Red auslösen

Blue AI soll den Spieler nicht ersetzen.

Sie soll einen glaubwürdigen Operationsrahmen erzeugen, in den der Spieler einsteigen kann.

---

## 23. Red AI Design

Red AI soll später eine eigenständige Operationslogik erhalten.

Mögliche Red-Prioritäten:

- syrisches Festland verteidigen
- strategische Airbases halten
- IADS schützen
- CAP bereitstellen
- Blue Logistics stören
- Blue FOBs angreifen
- umkämpfte Zonen verstärken
- Gegenangriffe planen
- Red Logistics schützen
- Blue Operationsachsen unterbrechen
- Schwächen im Blue-Fortschritt ausnutzen

Red soll nicht nur passive Zielkulisse sein.

---

## 24. Operationsarten

Perspektivische Blue-Operationen:

- Air Superiority
- CAP Corridor
- Recon
- SEAD Preparation
- DEAD
- Strike
- Logistics Push
- FOB Support
- Capture Preparation
- Ground Support
- Interdiction

Perspektivische Red-Operationen:

- Defensive CAP
- Counter CAP
- Airbase Defense
- IADS Reinforcement
- Counterattack
- Logistics Interdiction
- Strike Against Blue Hub
- FOB Attack
- Pressure Relief
- SAM Ambush

Diese Operationstypen sind konzeptionell.

Sie werden aktuell von keinem vollständigen AI Director geplant.

---

## 25. Geplanter Director-State

Ein eigener AI-Director-State existiert noch nicht produktiv.

Mögliche spätere Bereiche:

    State.AI.Director
    State.AI.Operations
    State.AI.Intentions
    State.AI.Priorities
    State.AI.Requests
    State.AI.ThreatAssessment
    State.AI.ResourceAssessment
    State.AI.Decisions
    State.AI.History

Mögliche Felder:

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
- logisticsPressure
- capturePressure
- airThreat
- iadsThreat
- resourcePressure
- decisionTimestamp

Dies ist Zukunftsdesign und noch kein implementierter State.

---

## 26. Aktueller AI-State

Bereits vorhanden ist AICapManager-State unter:

    State.AI

Dazu gehören unter anderem:

- `capZones`
- `capZoneCandidates`
- `capRequests`
- `activeCaps`
- `completedCaps`
- `failedCaps`
- `cancelledCaps`
- `reactionState`
- `threatLevel`
- `capStatistics`
- `lastUpdate`

Dieser State ist bereits Teil der Persistence-Struktur.

Er ist jedoch nicht gleichbedeutend mit einem vollständigen AI-Director-State.

---

## 27. Persistence

PersistenceSystem:

    src/campaign/tc_persistence_system.lua
    v0.2.6

Bestätigt:

- dirty-aware Background Autosave
- `SAVED`
- `SKIPPED`
- kontrollierter `FAILED`
- Retry
- Read-back
- Compile
- Evaluate
- Validation

AI-State kann Bestandteil des serialisierbaren Campaign-State sein.

Verbindlich:

    productiveRestore=false

Das bedeutet:

    AI-State wird noch nicht produktiv beim Missionsstart restauriert und in reale AI-Operationen rekonstruiert.

---

## 28. Produktiver AI-Restore

Priority 3 ist inzwischen abgeschlossen.

Vor produktivem AI-Restore bleiben trotzdem unter anderem offen:

- Restore-/Initialisierungsreihenfolge
- Save-Versionierung
- Save-Kompatibilität
- AI-Lifecycle
- Umgang mit aktiven CAP-Requests
- Rekonstruktion realer MOOSE-Flüge
- Schutz vor doppelten Framework-Aktionen
- kontrollierter End-to-End-Restore-Test

Der Abschluss von Priority 3 allein aktiviert keinen produktiven Restore.

---

## 29. Entscheidungsfaktoren des späteren AI Directors

Mögliche Faktoren:

- Zone Ownership
- Base Ownership
- Strategic Relevance
- Capture Pressure
- Capture Progress
- Capture Ready
- Mission Availability
- Active Missions
- Completed Missions
- Failed Missions
- Logistics Hub Status
- FOB Status
- CAP Requests
- Air Threat
- IADS Threat
- Distanz
- aktuelle Kampagnenphase
- verfügbare Assets
- Verluste
- Supply
- Fuel
- Ammo
- Engineering
- Zeit seit letzter Operation

Viele dieser Daten existieren bereits einzeln.

Sie werden aktuell jedoch noch nicht durch eine zentrale Director-Logik zusammengeführt.

---

## 30. Ressourcenmodell

Der spätere AI Director soll nicht unbegrenzt handeln können.

Mögliche Ressourcen:

- Aircraft Availability
- Pilot Availability
- CAP Capacity
- Strike Capacity
- Transport Capacity
- Logistics Capacity
- Fuel
- Ammo
- Supply
- Engineering
- Repair
- IADS Readiness
- FOB Capacity

Ein vollständiges produktives Ressourcenmodell existiert aktuell noch nicht.

LogisticsDelivery und FobSystem liefern dafür erste Grundlagen.

---

## 31. Reaktionsmodell

Der spätere AI Director soll auf Kampagnenereignisse reagieren können.

Mögliche Ereignisse:

- Mission aktiviert
- Mission abgeschlossen
- Mission fehlgeschlagen
- Zone wird contested
- Capture Ready entsteht
- Zone wechselt Owner
- Airbase wechselt Owner
- FOB wird gebaut
- FOB wird beschädigt
- Logistics Hub wird geschwächt
- Transport schlägt fehl
- Transport gelingt
- CAP Request entsteht
- CAP geht verloren
- IADS-Site wird beschädigt
- EWR fällt aus
- Ground Operation benötigt Unterstützung

Aktuell sind verschiedene dieser State-Transitions einzeln bestätigt.

Eine zentrale autonome AI-Reaktion darauf existiert noch nicht.

---

## 32. Mission Effects und AI

MissionGenerator bereitet Mission Effects vor.

Aktuell praktisch bestätigt:

    Mission Completion
    -> Capture Effect
    -> Capture Pressure

Aktuell ebenfalls bestätigt:

    Mission Failure
    -> kein Capture Pressure

Später sollen Mission Effects auch AI-Entscheidungen beeinflussen können.

Beispiele:

- erfolgreiche SEAD-Mission senkt IADS-Bedrohung
- erfolgreiche Interdiction schwächt Logistics
- erfolgreicher FOB-Support erhöht Operationsfähigkeit
- gescheiterter Angriff löst Gegenreaktion aus
- Capture Ready erhöht Verteidigungspriorität
- erfolgreicher Transport stärkt Ground-/FOB-State

Diese AI-Wirkungen sind noch nicht produktiv implementiert.

---

## 33. F10 und AI

F10Menu:

    v0.2.3

Bestätigt:

    33 Commands

Aktuelle AI-bezogene Funktion:

    Show AI CAP Status

Weitere mögliche spätere Debug-/Statusfunktionen:

- Show AI Director Status
- Show Blue Intent
- Show Red Intent
- Show Priority Zones
- Show Active Operations
- Show Pending Operations
- Show Threat Assessment
- Show Resource Assessment

Diese späteren Funktionen sind nicht als bereits implementiert zu verstehen.

Der AI Director soll langfristig nicht durch Spieler-F10-Befehle gesteuert werden müssen.

---

## 34. Framework-Integration

Vorgesehene technische Rollen:

### MOOSE

Perspektivisch:

- CAP
- Strike
- SEAD
- DEAD
- CAS
- Escort
- Mission Packages
- Carrier Air Wing

### CTLD

Perspektivisch:

- Truppentransport
- Logistics
- Cargo
- Engineering
- Supply
- Repair
- FOB-Support

Ein isolierter KI-Truppentransport-PoC ist inzwischen für den getesteten Aufbau bestanden.

### Skynet IADS

Perspektivisch:

- IADS-Ausführung
- EWR-/SAM-Koordination
- dynamische Luftverteidigung

### MIST

Utility und Datenzugriff nach Bedarf.

Frameworks bleiben Execution Layer.

---

## 35. Geplante AI-Director-Datei

Perspektivisch vorgesehener fachlicher Dateiname:

    src/ai/tc_ai_director.lua

Diese Datei existiert aktuell noch nicht als produktives Modul.

Eine mögliche spätere erste Version könnte state-first beginnen mit:

- Director-State initialisieren
- Blue Intent berechnen
- Red Intent berechnen
- Priority Zones ermitteln
- Threat Assessment erzeugen
- Resource Assessment vorbereiten
- Operations-Intent erzeugen
- Logsummary bereitstellen

Noch nicht in einer ersten state-first Version:

- reale MOOSE-Spawns
- direkte CTLD-Ausführung
- direkte Skynet-Manipulation
- automatische Großoperationen ohne vorherige Sichtbarkeit

Es besteht aktuell kein Auftrag, diese Datei jetzt anzulegen.

---

## 36. Warum der AI Director aktuell nicht der nächste Schritt ist

Die aktuelle Projektpriorität ist:

    Priority 4 – produktive CTLD-Integration vorbereiten

Der isolierte CTLD-KI-Truppentransport-PoC wurde am 2026-09-29 für den getesteten Aufbau bestanden.

Jetzt muss zunächst geklärt werden:

- welche fachliche Komponente Transportaufträge besitzt
- wie CTLD-Zonen registriert werden
- wie KI-Transporter registriert werden
- wie Transporter-Lifecycle behandelt wird
- wie Erfolg und Fehler erkannt werden
- wie Ergebnisse in LogisticsDelivery und FobSystem zurückgeführt werden
- welche Mutationen Dirty setzen
- welche Daten persistiert werden
- welche CTLD-Daten runtime-only bleiben

Diese Integrationsgrenze ist eine notwendige Grundlage für eine spätere AI-Logistics-Entscheidung.

Der AI Director wird deshalb nicht parallel als neues Großsystem begonnen.

---

## 37. `RepackCommandsPath` und AI-Integration

Beim erfolgreichen CTLD-KI-Truppentransport wurde beim Touchdown genau einmal beobachtet:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Der Transport-Pickup-/Dropoff-Pfad wurde trotzdem erfolgreich abgeschlossen.

Nicht direkt bewiesen ist:

- ob spätere Repack-Menü-Aktualisierungen funktionieren
- ob der betreffende Scheduler-Pfad weiterlief
- ob er beendet wurde

Ein mögliches Ende des Scheduler-Pfads bleibt eine technische Inferenz.

Verbindlich:

    vendor/ctld/CTLD.lua wird nicht gepatcht.

Für einen späteren AI Director bedeutet das:

    Transportoperationen dürfen erst automatisiert werden,
    wenn die produktive CTLD-Integrationsstrategie diesen Caveat sauber behandelt.

---

## 38. Risiken bei zu frühem AI-Director-Bau

Wichtige Risiken:

- Entscheidungen basieren auf unvollständiger Execution-Architektur.
- Missionen werden unkontrolliert aktiviert.
- Frameworks erzeugen reale Nebenwirkungen ohne Result Validation.
- Logistics- und AI-State laufen auseinander.
- CAP Requests und reale CAP-Flüge laufen auseinander.
- Mission Effects werden doppelt angewendet.
- Restore erzeugt doppelte AI-Operationen.
- Blue-/Red-Entscheidungen werden schwer reproduzierbar.
- Debug-Sichtbarkeit reicht nicht aus.
- zu viele Großsysteme werden gleichzeitig verändert.

Gegenmaßnahmen:

- State-first
- kleine Integrationsschritte
- fachliche Modulgrenzen
- idempotente Operationen
- Result Validation
- dirty-aware Persistence
- keine Vendor-Patches
- reale DCS-Runtime-Tests
- eine konkrete Aufgabe pro Schritt

---

## 39. Aktuelle Akzeptanzkriterien für AICapManager

Bestanden:

- AICapManager lädt.
- AICapManager startet.
- Version `v0.2.1`.
- 31 CAP-Zonen-Kandidaten.
- 12 CAP-Zonen.
- 12 CAP Requests.
- CAP-State wird erzeugt.
- keine realen MOOSE-Spawns.
- Read-Neutrality der relevanten Getter bestanden.
- echte Mutation behält Dirty-Semantik.
- `setCapStatus()` kann `ai_cap_record_changed` setzen.
- `evaluateCapNeeds()`-Dirty-/Autosave-Pfad wurde bestätigt.
- `reactToActiveMissions()` ist als derzeit nicht produktiv verdrahteter Lifecycle-Punkt identifiziert.

Noch offen:

- reale MOOSE-CAP-Flüge
- CAP-Flight-Lifecycle
- Loss-Auswertung
- GCI
- vollständiger AI Director
- Blue-/Red-Operationsplanung
- Ressourcenmodell
- produktiver AI-Restore
- Multiplayer

---

## 40. Aktueller Systemstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | Background Persistence bestanden; `productiveRestore=false` |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.1` | Read-Neutrality bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.1` | Read-Neutrality bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | Priority-3-Audit ohne erforderlichen Code-Fix abgeschlossen |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.1` | Read-Neutrality und Runtime-Regression bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden; 33 Commands |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` | KI-Truppentransport-PoC für getesteten Aufbau bestanden |

Priority 3:

    abgeschlossen im dokumentierten Umfang seit 2026-09-21

---

## 41. Entwicklungswerkzeuge

Die aktuelle Werkzeugtrennung gilt auch für spätere AI-Entwicklung.

### ChatGPT

Rolle:

- Projektkoordination
- Architektur
- Testplanung
- GitHub-Audit
- Dokumentation
- Ergebnisbewertung

### Claude + dcs-mcp

Version:

    dcs-mcp 0.9.11

Bevorzugt für:

- `.miz`-Analyse
- Templates
- Gruppen
- Zonen
- Wegpunkte
- Tasks
- spätere AI-Mission-Editor-Strukturen

### Claude Code + DCS-SMS

DCS-SMS:

    0.27.2

Hook:

    me-bridge-0.27.2

Verifiziertes Installationsverzeichnis:

    C:\Tools\dcs-sms

Bevorzugt für:

- Runtime-Lua
- AI-State
- Unit-/Group-State
- MOOSE-Live-State
- CTLD-Live-State
- Logs
- Runtime-Regressionen

Diese Werkzeuge sind Entwicklungsinfrastruktur und keine spätere Kampagnen-Runtime-Abhängigkeit.

---

## 42. Nächster AI-spezifischer Schritt

Aktuell:

    kein AI-Director-Code-Schritt

Der nächste Gesamtprojektschritt liegt in Priority 4.

AI-seitig bleibt AICapManager:

    v0.2.1
    state-first aktiv
    Read-Neutrality bestanden

Eine neue AI-Director-Implementierung wird erst begonnen, wenn sie im Projektablauf tatsächlich der nächste fachliche Schritt ist.

Vorher werden keine parallelen Großsysteme geöffnet.

---

## 43. Aktueller Abschluss

Stand:

    2026-09-29

AI-seitig bestätigt:

    AICapManager v0.2.1
    31 CAP-Zonen-Kandidaten
    12 CAP-Zonen
    12 CAP Requests
    state-first CAP-State
    relevante Getter read-neutral
    echte Mutationen behalten Dirty-Semantik
    evaluateCapNeeds Dirty-/Persistence-Pfad bestätigt
    reactToActiveMissions nicht produktiv verdrahtet
    keine realen MOOSE-CAP-Flüge
    kein vollständiger AI Director

Projektweit relevant:

    Priority 3 abgeschlossen
    MissionGenerator Record-Loss widerlegt
    Persistence dirty-aware
    productiveRestore=false
    CTLD-KI-Truppentransport-PoC für getesteten Aufbau bestanden
    Priority 4 ist aktueller Entwicklungsbereich

Noch nicht implementiert:

- vollständiger AI Director
- autonome Blue Operations
- autonome Red Operations
- reale MOOSE CAP
- reale Strike-/SEAD-/DEAD-/CAS-Packages
- produktive AI-Logistics-Koordination
- produktive Ground Operations
- produktive AI-IADS-Koordination
- produktiver AI-Restore
- Multiplayer-AI-Validierung

Aktueller Übergang:

    stabiler state-first Kampagnenstate
    +
    abgeschlossene Priority-3-Dirty-Coverage
    +
    AICapManager v0.2.1
    +
    bestandener isolierter CTLD-Transport-PoC
    ->
    kontrollierte produktive Framework-Integration
