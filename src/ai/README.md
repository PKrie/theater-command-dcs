# AI – Theater Command DCS

## Verbindlicher Stand — 2026-09-29

Diese Datei beschreibt den AI-Bereich von **Theater Command DCS**.

Projekt:

    Theater Command DCS

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Aktiver AI-Baustein:

    src/ai/tc_ai_cap_manager.lua

Version:

    v0.2.1

Status:

    state-first bestanden
    Read-Neutrality bestanden

Vollständiger AI Director:

    noch nicht implementiert

Aktueller Entwicklungsbereich des Gesamtprojekts:

    Priority 4 – produktive CTLD-Integration vorbereiten

Priority 3:

    abgeschlossen im dokumentierten Umfang seit 2026-09-21

Verbindlich:

    productiveRestore=false

---

## 1. Zweck des AI-Bereichs

`src/ai/` enthält Theater-Command-Logik für KI-bezogene Lagebewertung, Entscheidungsstate und spätere autonome Operationen.

Langfristiges Ziel:

    Blue und Red handeln zunehmend selbständig.
    Spieler sind Teilnehmer einer laufenden Kampagne.
    Die Kampagne hängt nicht ausschließlich von Spieleraktionen ab.

Perspektivische Aufgaben:

- CAP
- GCI
- Strike
- SEAD
- DEAD
- CAS
- Escort
- Gegenreaktionen
- Operationsplanung
- Ressourcenbewertung
- Logistics-Bedarf
- Ground-Support
- IADS-Reaktion

Aktuell existiert noch kein vollständiger AI Director.

Der aktive AI-Baustein ist:

    AICapManager

---

## 2. Architekturregel

Externe Frameworks liegen unter:

    vendor/

Eigene Theater-Command-Logik liegt unter:

    src/

Der AI-Bereich wird nach fachlicher Aufgabe strukturiert.

Nicht gewünscht:

    tc_moose_ai.lua
    tc_mist_ai.lua
    tc_ai_all_in_one.lua
    tc_dynamic_ai_everything.lua

Aktuell korrekt:

    tc_ai_cap_manager.lua

Perspektivisch möglich:

    tc_ai_director.lua

Eine AI-Datei darf MOOSE, MIST, CTLD oder Skynet verwenden.

Der Dateiname richtet sich trotzdem nach der Theater-Command-Aufgabe und nicht nach dem Framework.

---

## 3. Aktive Datei

Datei:

    src/ai/tc_ai_cap_manager.lua

Version:

    v0.2.1

Aufgaben:

- CAP-Zonen-Kandidaten ableiten
- CAP-Zonen state-first registrieren
- CAP-Requests verwalten
- CAP-Status verwalten
- Reaktionsstate vorbereiten
- Bedrohungsstate vorbereiten
- spätere MOOSE-CAP-Ausführung vorbereiten
- F10-AI-CAP-Status bereitstellen
- Persistence-relevante AI-Mutationen korrekt markieren

Nicht Aufgabe:

- vollständige strategische AI-Planung
- reale MOOSE-CAP-Flüge
- Logistics-Transporte ausführen
- CTLD direkt orchestrieren
- Skynet-IADS direkt steuern
- MissionGenerator ersetzen

---

## 4. Aktuell bestätigte Werte

Bestätigt:

    CAP zone candidates: 31
    CAP zones: 12
    CAP requests: 12

AICapManager:

    lädt
    startet
    erzeugt CAP-State
    bleibt state-first

Aktuell nicht aktiv:

    reale MOOSE-CAP-Flüge

Die vorhandenen CAP-Requests sind Campaign State und noch keine realen Flugmissionen.

---

## 5. State-first-Grundsatz

Der AI-Bereich folgt weiterhin:

    State zuerst.

Ablauf:

    Kampagnenlage lesen
    -> Bedarf bewerten
    -> AI-State erzeugen
    -> AI-State sichtbar machen
    -> State-/Dirty-Verhalten prüfen
    -> erst danach reale Framework-Execution anbinden

Aktuell erzeugt AICapManager:

    Intent / State

MOOSE soll später übernehmen:

    reale Air-Execution

---

## 6. Verhältnis zum Core

`src/ai/` verwendet die gemeinsame Theater-Command-Infrastruktur.

Relevante Core-Bereiche:

    TC.Config
    TC.Logger
    TC.State
    TC.Utils
    TC.Scheduler

AICapManager wird nach:

    MissionGenerator

und vor:

    F10Menu
    Main
    Loader

geladen.

---

## 7. Verhältnis zum World Layer

Relevante Systeme:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

Aktuelle bestätigte Grundlage:

    Airbase-like Objects: 225
    relevante Kampagnenzonen: 46
    Capture Candidates: 32
    Mission Candidates: 32
    Logistics Candidates: 46

AICapManager verwendet die gefilterte Theater-Command-Welt als Grundlage für CAP-Zonen-Kandidaten.

Bestätigt:

    CAP zone candidates: 31
    CAP zones: 12

Nicht alle DCS-Airbase-like Objects werden automatisch zu CAP-Zonen.

---

## 8. Verhältnis zum CaptureSystem

CaptureSystem:

    src/campaign/tc_capture_system.lua
    v0.2.2

Bestätigte Campaign-Funktionen:

- Ownership
- Capture Pressure
- Capture Progress
- Capture Ready
- Capture Apply
- linked Airbase Ownership

Der spätere AI Director soll diese Daten unter anderem nutzen für:

- Verteidigungsprioritäten
- Angriffsprioritäten
- CAP-Bedarf
- Gegenreaktionen
- Schutz umkämpfter Zonen

Aktuell existiert noch keine vollständige autonome:

    Capture State
    -> AI Director
    -> Operation

Kette.

---

## 9. Verhältnis zu LogisticsDelivery

LogisticsDelivery:

    src/logistics/tc_logistics_delivery.lua
    v0.2.1

Bestätigt:

    Logistics Hubs: 46
    Blue: 7
    Red: 24
    Neutral: 15

Priority-3-Ergebnis:

    Read-Neutrality bestanden

Später soll AI Logistics-Daten verwenden können für:

- Schutz wichtiger Hubs
- Interdiction
- Transportbedarf
- Nachschubprioritäten
- Operationsfähigkeit
- FOB-Support

Aktuell existiert keine produktive:

    AI Director
    -> Logistics Auftrag

Kette.

---

## 10. Verhältnis zu FobSystem

FobSystem:

    src/logistics/tc_fob_system.lua
    v0.2.1

Bestätigt:

    FOB Candidates: 6
    Blue FOBs: 2

Blue FOBs:

    FOB Ercan
    FOB Gecitkale

Status:

    UNDER_CONSTRUCTION

Später kann der AI Director FOB-State nutzen für:

- Schutz
- Versorgung
- Operationsreichweite
- Forward CAP
- Angriffsprioritäten
- Logistics Push

Aktuell sind diese FOBs:

    Theater-Command-State

und keine real durch CTLD gebauten FOBs.

---

## 11. Verhältnis zum MissionGenerator

MissionGenerator:

    src/missions/tc_mission_generator.lua
    v0.2.3

Bestätigt:

    Mission Candidates: 78
    FOB Support Candidates: 2
    Mission Records: 10

Bestätigte Statuswechsel:

    AVAILABLE -> ACTIVE
    ACTIVE -> COMPLETED
    ACTIVE -> FAILED

Der spätere AI Director soll unter anderem:

- Missionsbedarf erzeugen
- Missionen priorisieren
- auf Missionsergebnisse reagieren
- Gegenoperationen vorbereiten

Aktuell besteht keine autonome:

    AI Director
    -> MissionGenerator
    -> Mission Activation

Kette.

---

## 12. Mission-Record-Diagnose

Der frühere Verdacht, MissionGenerator würde seine Mission Records verlieren, wurde am:

    2026-09-12

widerlegt.

Mission Collections sind:

    String-keyed Lua-Dictionaries

Deshalb ist:

    #table

für deren Anzahl nicht autoritativ.

Live bestätigt wurde:

    statistics.available = 10
    pairs()-Count = 10
    #available = 0

Die Mission Records waren vorhanden.

Der damalige Zählfehler lag in:

    src/core/tc_state.lua

und nicht in einem tatsächlichen MissionGenerator-Datenverlust.

Der AI-Bereich benötigt deshalb keine Workarounds für einen nicht vorhandenen Mission-Record-Loss.

---

## 13. Verhältnis zum IADS-Bereich

Vendor:

    Skynet IADS 3.3.0

Aktuell:

    geladen
    keine produktive Theater-Command-IADS-Integration

Später soll AI IADS-Daten unter anderem verwenden für:

- Threat Assessment
- SEAD-Bedarf
- DEAD-Bedarf
- sichere Korridore
- CAP-Priorisierung
- Schutz geschwächter IADS-Sektoren
- Gegenreaktionen

Aktuell existiert keine produktive:

    AI
    -> IADS

Kopplung.

---

## 14. Verhältnis zum UI-Bereich

F10Menu:

    src/ui/tc_f10_menu.lua
    v0.2.3

Bestätigt:

    33 Commands

AI-bezogene aktuelle Funktion:

    Show AI CAP Status

F10 dient aktuell als:

- Sichtbarkeit
- Debug
- kontrollierter Testzugang

Der spätere AI Director soll nicht davon abhängen, dass Spieler AI-Prozesse manuell über F10 auslösen.

---

## 15. AICapManager Priority-3-Ergebnis

Priority 3 wurde am:

    2026-09-21

im dokumentierten Umfang abgeschlossen.

AICapManager wurde dabei auf Read-Neutrality geprüft.

Fix-Version:

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

Ergebnis:

    Read
    -> kein persistierter AI-State geändert
    -> kein unnötiger Dirty-State

Positive Gegenprobe:

    setCapStatus()

kann weiterhin setzen:

    dirtyReason=ai_cap_record_changed

Damit ist die Read-Neutrality für den aktiven AICapManager im dokumentierten Umfang bestanden.

---

## 16. `evaluateCapNeeds()`

`evaluateCapNeeds()` ist ein aktiver AI-State-Pfad.

Bestätigter Dirty Reason:

    ai_cap_needs_evaluated

Der Persistence-Scheduler hat diesen realen Dirty-State bereits erfolgreich gespeichert.

Bestätigter Ablauf:

    AI-State-Mutation
    -> Dirty
    -> Background Autosave
    -> SAVED
    -> dirty=false

Nachfolgende unveränderte Ticks konnten:

    SKIPPED

bleiben.

Damit ist ein realer AI-/Persistence-Pfad bestätigt.

---

## 17. `reactToActiveMissions()`

Funktion:

    CapManager.reactToActiveMissions(options)

existiert weiterhin.

Sie kann aktive Missionen lesen und daraus CAP-Reaktionen ableiten.

Der Source-Audit ergab aktuell:

    keine produktive Call-Site

Insbesondere keine aktive Verdrahtung aus:

- `CapManager.start()`
- Scheduler
- Timer
- `main.lua`
- `loader.lua`
- F10
- anderen produktiven Source-Pfaden

Deshalb besteht aktuell keine automatische:

    aktive Mission
    -> AI CAP Reaction

Kette.

Der Pfad bleibt:

    latenter Lifecycle-/Dirty-Prüfpunkt

Er wird erneut geprüft, wenn er tatsächlich produktiv verdrahtet wird.

Er ist aktuell kein nachgewiesener Runtime-Persistence-Bug.

---

## 18. Verhältnis zu MOOSE

MOOSE:

    2.9.17

ist als Vendor-Framework geladen.

Perspektivisch soll MOOSE reale Air-Execution übernehmen, beispielsweise:

- CAP
- GCI
- Strike
- SEAD
- DEAD
- CAS
- Escort
- Squadron Management
- Mission Packages

Aktuell:

    AICapManager erzeugt CAP-State
    MOOSE erzeugt noch keine realen Theater-Command-CAP-Flüge

Architektur:

    Theater Command
    -> entscheidet / hält State

    MOOSE
    -> führt später aus

---

## 19. Verhältnis zu CTLD

CTLD:

    1.6.1

ist primär für Transport- und Logistics-Execution relevant.

Am:

    2026-09-29

wurde für einen isolierten getesteten Aufbau ein vollständiger KI-Truppentransport praktisch bestätigt.

Bestätigter Pfad:

    Runtime-Zonenregistrierung
    -> KI-Transporterregistrierung
    -> automatischer Pickup
    -> autonomer Flug
    -> Off-Airfield-Landung
    -> automatischer Dropoff
    -> reale Blue-Bodengruppe

Luftfahrzeug:

    Mi-8

Pickup:

    16 Soldaten

Dieser Test ist für spätere AI-Entwicklung relevant, weil damit ein realer KI-Transportpfad für den getesteten Aufbau technisch bestätigt ist.

Er beweist nicht:

    AI Director kann bereits Transportoperationen planen oder auslösen.

---

## 20. Zukünftige AI-/Transport-Kette

Langfristig denkbar:

    AI Director
    -> erkennt Logistics-/Ground-Bedarf
    -> erzeugt Intent
    -> fachliches Logistics-/Transport-System erzeugt Auftrag
    -> CTLD / DCS führt Auftrag aus
    -> Ergebnis wird validiert
    -> Theater-Command-State wird mutiert
    -> Dirty
    -> Persistence

Der AI Director soll nicht:

- CTLD-Vendor-Tabellen zum Kampagnenstate machen
- Transport-Onboard-State direkt manipulieren
- Vendor-Code verändern

Die fachliche CTLD-Integrationsgrenze wird in Priority 4 zuerst separat definiert.

---

## 21. AI-State

Vorhandener State liegt unter:

    State.AI

Aktuelle Bereiche umfassen unter anderem:

    capZones
    capZoneCandidates
    capRequests
    activeCaps
    completedCaps
    failedCaps
    cancelledCaps
    reactionState
    threatLevel
    capStatistics
    lastUpdate

Dieser State ist nicht gleichbedeutend mit einem vollständigen AI Director.

Mögliche spätere zusätzliche Bereiche:

    State.AI.Director
    State.AI.Operations
    State.AI.Intentions
    State.AI.Priorities
    State.AI.ThreatAssessment
    State.AI.ResourceAssessment

Diese Bereiche sind Zukunftsdesign und noch nicht produktiv implementiert.

---

## 22. Blue AI Zielbild

Blue AI soll später unter anderem:

- Akrotiri sichern
- CAP bereitstellen
- Operationskorridore schützen
- SEAD-/DEAD-Bedarf erkennen
- Logistics Push unterstützen
- FOBs schützen
- Capture-Operationen unterstützen
- Ground Operations unterstützen
- auf Red reagieren

Der Spieler soll Teil dieser Struktur sein.

Blue AI soll den Spieler nicht vollständig ersetzen.

---

## 23. Red AI Zielbild

Red AI soll später unter anderem:

- syrisches Festland verteidigen
- strategische Airbases schützen
- CAP bereitstellen
- IADS schützen
- Blue Logistics stören
- FOBs angreifen
- umkämpfte Zonen verstärken
- Gegenangriffe erzeugen
- Red Logistics schützen

Red soll langfristig nicht nur passive Zielkulisse sein.

---

## 24. Persistence

PersistenceSystem:

    src/campaign/tc_persistence_system.lua
    v0.2.6

AI-State ist Teil des Theater-Command-Campaign-State.

Bestätigt:

- dirty-aware Background Autosave
- `SAVED`
- `SKIPPED`
- `FAILED`
- Retry

Verbindlich:

    productiveRestore=false

Produktiver Restore realer AI-Operationen ist noch nicht freigegeben.

Vorher müssen unter anderem geklärt werden:

- Restore-Reihenfolge
- AI-Lifecycle
- CAP-Request-Rekonstruktion
- spätere MOOSE-Rekonstruktion
- Schutz vor doppelten Framework-Aktionen

---

## 25. Aktuelle Testkriterien

AICapManager `v0.2.1` gilt im aktuellen Umfang als bestanden, weil:

- Datei lädt.
- Modul startet.
- 31 CAP-Zonen-Kandidaten erkannt werden.
- 12 CAP-Zonen vorhanden sind.
- 12 CAP-Requests vorhanden sind.
- CAP-State erzeugt wird.
- relevante Getter read-neutral sind.
- echte AI-State-Mutationen Dirty markieren können.
- keine realen MOOSE-CAP-Spawns ausgelöst werden.
- Priority-3-Regression bestanden ist.

Noch offen:

- reale MOOSE-CAP-Flüge
- GCI
- CAP-Flight-Lifecycle
- Loss-Auswertung
- AI Director
- autonome Blue Operations
- autonome Red Operations
- Ressourcenmodell
- Ground-/CAS-Verknüpfung
- produktiver AI-Restore
- Multiplayer

---

## 26. Kein aktueller AI-Code-Schritt

Der aktuelle Projektbereich ist:

    Priority 4 – produktive CTLD-Integration vorbereiten

Deshalb wird aktuell nicht parallel:

- `tc_ai_director.lua` angelegt
- reale MOOSE-CAP-Execution eingebaut
- GCI implementiert
- autonome Blue-/Red-Operationsplanung begonnen

AICapManager bleibt:

    v0.2.1
    state-first aktiv
    Read-Neutrality bestanden

Der AI-Bereich wird wieder erweitert, wenn er tatsächlich der nächste fachliche Projektschritt ist.

---

## 27. Entwicklungswerkzeuge

Aktuelle Rollen:

### ChatGPT

    Projektkoordination
    Architektur
    GitHub-Audit
    Testplanung
    Bewertung
    Dokumentation

### Claude + dcs-mcp

Version:

    dcs-mcp 0.9.11

Geeignet für:

    .miz
    Gruppen
    Units
    Zonen
    Wegpunkte
    Tasks
    spätere AI-Templates

### Claude Code + DCS-SMS

Version:

    DCS-SMS 0.27.2

Hook:

    me-bridge-0.27.2

Verifiziertes Installationsverzeichnis:

    C:\Tools\dcs-sms

Geeignet für:

    AI-Live-State
    Runtime-Lua
    Unit-/Group-State
    MOOSE-Live-State
    CTLD-Live-State
    Logs
    Runtime-Regressionen

Aus dem bestätigten Stand wird kein exakter DCS-SMS-Executable-Pfad abgeleitet.

---

## 28. Aktueller Abschlussstand

Stand:

    2026-09-29

Aktiver AI-Baustein:

    AICapManager v0.2.1

Bestätigt:

    31 CAP zone candidates
    12 CAP zones
    12 CAP requests
    state-first CAP-State
    relevante Getter read-neutral
    echte Mutationen behalten Dirty-Semantik
    evaluateCapNeeds Persistence-Pfad bestätigt
    reactToActiveMissions aktuell nicht produktiv verdrahtet

Nicht vorhanden:

    reale MOOSE-CAP-Flüge
    vollständiger AI Director
    autonome Blue Operations
    autonome Red Operations
    Ground-/CAS-Automatisierung
    produktiver AI-Restore

Projektweit:

    Priority 3 abgeschlossen
    Mission-Record-Loss widerlegt
    productiveRestore=false
    CTLD-KI-Truppentransport-PoC für den getesteten Aufbau bestanden
    Priority 4 aktiv

Aktueller Übergang:

    stabiler state-first Kampagnenkern
    +
    AICapManager v0.2.1
    +
    abgeschlossene Dirty-Coverage
    +
    bestandener CTLD-Transport-PoC
    ->
    kontrollierte produktive Framework-Integration
