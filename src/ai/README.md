# src/ai/README.md

Diese Datei beschreibt den AI-Bereich von **Theater Command DCS**.

Der AI-Bereich enthält eigene Lua-Logik für KI-bezogene Kampagnenentscheidungen, CAP-State und spätere AI-Director-Funktionen.

---

## 1. Zweck des AI-Bereichs

`src/ai/` ist für die KI-bezogene Lagebewertung und spätere KI-Operationsplanung zuständig.

Langfristig soll dieser Bereich ermöglichen, dass Blue und Red eigene dynamische Operationen planen und ausführen.

Ziel:

    Die Kampagne soll nicht ausschließlich durch Spieleraktionen laufen.
    Blue und Red sollen eigene Absichten, Reaktionen und Operationen entwickeln.
    Spieler sollen Teil einer laufenden Kampagne sein.

Aktuell ist noch kein vollständiger AI Director implementiert.

Der erste aktive AI-Baustein ist der AICapManager.

---

## 2. Aktueller technischer Stand

Stand:

    2026-06-29

Aktive Datei:

    src/ai/tc_ai_cap_manager.lua

Getestete Version:

    v0.2.0

Status:

    bestanden

Bestätigt durch DCS-Logtests:

- AICapManager lädt.
- AICapManager startet.
- CAP-Zonen-Kandidaten werden erkannt.
- CAP-Zonen werden state-only registriert.
- CAP-Requests werden erzeugt.
- reactionState wird gesetzt.
- threatLevel wird gesetzt.
- MOOSE-Hooks bleiben vorbereitet.
- Es werden keine echten MOOSE-CAP-Flüge gespawnt.
- Es gab keinen Theater-Command-Lua-Fehler.
- Es gab keinen Lua-Stacktrace.

---

## 3. Aktuelle bestätigte Werte

AICapManager:

    cap zone candidates: 31
    auto-registered CAP zones: 12
    CAP requests: 12
    reactionState: AIR_REACTION_REQUESTED
    threatLevel: HIGH

Bewertung:

    AICapManager ist state-first bestanden.
    CAP-Bedarf wird im Theater-Command-State abgebildet.
    Echte MOOSE-CAP-Spawns sind noch nicht aktiv.
    spawn=MOOSE_PENDING ist aktuell erwartetes Verhalten.

---

## 4. Architekturregel

Externe Frameworks liegen unter:

    vendor/

Eigene Theater-Command-Logik liegt unter:

    src/

Der AI-Bereich gehört zur eigenen Theater-Command-Logik.

Frameworks werden nicht verändert.

Dateien in `src/ai/` werden nach Theater-Command-Aufgaben benannt, nicht nach Frameworks.

Nicht gewünscht:

    src/ai/tc_moose_ai.lua
    src/ai/tc_mist_ai.lua
    src/ai/tc_ai_all_in_one.lua
    src/ai/tc_dynamic_ai_everything.lua

Gewünscht:

    src/ai/tc_ai_cap_manager.lua
    src/ai/tc_ai_director.lua

Eine AI-Datei darf später MOOSE, MIST, CTLD oder Skynet nutzen.

Der Dateiname richtet sich aber nach der Theater-Command-Aufgabe.

---

## 5. Aktive Datei

Aktuell aktive Datei:

    src/ai/tc_ai_cap_manager.lua

Aktuelle Version:

    v0.2.0

Aufgaben:

- CAP-Zonen aus Kampagnenlage ableiten
- CAP-Zonen state-only registrieren
- CAP-Requests erzeugen
- Luftbedrohung vorbereitend bewerten
- reactionState setzen
- threatLevel setzen
- spätere MOOSE-CAP-Anbindung vorbereiten
- F10-AI-CAP-Status ermöglichen

Wichtig:

    AICapManager spawnt aktuell keine Flugzeuge.
    AICapManager startet aktuell keine echten MOOSE-Dispatcher.
    AICapManager erzeugt state-only CAP-Daten.

---

## 6. Geplante spätere Datei

Geplante spätere Datei:

    src/ai/tc_ai_director.lua

Der AI Director soll später die strategische KI-Entscheidungsebene werden.

Mögliche Aufgaben:

- Blue-Absicht berechnen
- Red-Absicht berechnen
- Prioritätszonen berechnen
- Operationsbedarf erzeugen
- Missionsbedarf an MissionGenerator melden
- CAP-Bedarf priorisieren
- Logistikbedarf bewerten
- FOB-Bedarf bewerten
- Capture-Pressure auswerten
- IADS-Bedrohung berücksichtigen
- Missionsergebnisse verarbeiten
- Ressourcen bewerten
- Gegenreaktionen erzeugen
- AI-State persistenzfähig machen

Aktueller Stand:

    AI Director ist noch nicht implementiert.
    AICapManager ist nur ein erstes AI-Fachmodul.

---

## 7. Verhältnis zwischen AICapManager und AI Director

AICapManager:

- arbeitet auf CAP-State
- erzeugt CAP-Requests
- bewertet Luftlage vorbereitend
- bereitet MOOSE-CAP-Hooks vor

AI Director später:

- bewertet Gesamtstrategie
- entscheidet Prioritäten
- steuert oder beeinflusst AICapManager
- fordert Missionen an
- reagiert auf Capture-, Logistics-, FOB- und IADS-Lage
- plant Blue- und Red-Operationen

Kurz:

    AICapManager ist ein spezialisierter Baustein.
    AI Director wird später die übergeordnete Entscheidungsschicht.

---

## 8. Verhältnis zum Core

`src/ai/` nutzt den Core.

Erlaubte Core-Abhängigkeiten:

- `TC.Config`
- `TC.Logger`
- `TC.State`
- `TC.Utils`
- `TC.Scheduler`

Der AI-Bereich darf davon ausgehen, dass der Core bereits geladen ist.

Aktuelle Ladeposition:

    nach Missions
    vor UI, Main und Loader

---

## 9. Verhältnis zum World-Bereich

Der AI-Bereich nutzt Daten aus:

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

AICapManager nutzt diese Daten, um CAP-Zonen-Kandidaten abzuleiten.

Aktuell bestätigt:

    cap zone candidates: 31
    auto-registered CAP zones: 12

---

## 10. Verhältnis zum Campaign-Bereich

Der AI-Bereich soll später Daten aus `src/campaign/` nutzen.

Besonders wichtig:

- Capture-Eligibility
- Capture-Pressure
- Capture-Progress
- Zone Ownership
- Mission Effects
- Persistence State

Aktuelle Capture-Werte:

    eligibleBases: 32
    eligibleZones: 32
    pressureRecords: 32
    progressRecords: 32
    appliedMissionEffects: 0
    ready: 0
    contested: 0

Spätere AI-Nutzung:

- bedrohte Zonen priorisieren
- Capture-Pressure bewerten
- Gegenangriffe planen
- Verteidigung verstärken
- CAP über umkämpften Zonen priorisieren
- Missionen gegen Druckräume anfordern

Aktuell:

    AICapManager nutzt CaptureSystem noch nicht produktiv für strategische Entscheidungen.
    Capture-/Pressure-Daten sollen zuerst im F10 sichtbar werden.

---

## 11. Verhältnis zum Logistics-Bereich

Der AI-Bereich soll später Daten aus `src/logistics/` nutzen.

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

Spätere AI-Nutzung:

- FOBs schützen
- FOBs angreifen
- Logistikhubs priorisieren
- Nachschubbedarf erkennen
- Interdiction planen
- CAP über Logistikrouten anfordern
- Red-Reaktionen auf Blue-FOBs erzeugen

Aktuell:

    Logistics und FOBs existieren state-only.
    AI Director ist noch nicht implementiert.

---

## 12. Verhältnis zum Missionsbereich

Der AI-Bereich soll später eng mit `src/missions/` zusammenarbeiten.

Aktuelle MissionGenerator-Datei:

    src/missions/tc_mission_generator.lua

Getestete Version:

    v0.2.2

Aktuelle MissionGenerator-Werte:

    mission candidates: 69
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 30

Spätere Kopplung:

- AI Director fordert Missionstypen an
- MissionGenerator erzeugt passende Missionen
- AI Director priorisiert Missionen
- Missionsergebnisse beeinflussen AI-State
- AI reagiert auf aktive Missionen
- AI reagiert auf fehlgeschlagene Missionen
- AI erzeugt Red-Gegenmaßnahmen

Aktuell:

    MissionGenerator arbeitet state-only.
    F10Menu kann Missionen aktivieren.
    AI Director nutzt MissionGenerator noch nicht produktiv.

---

## 13. Verhältnis zum IADS-Bereich

Der AI-Bereich soll später IADS-Daten nutzen.

Aktueller IADS-Stand:

    Skynet IADS wird geladen.
    Theater-Command-IADS-Modul ist noch nicht implementiert.
    MissionGenerator reserviert Skynet-Hooks.

Spätere AI-Nutzung:

- IADS-Bedrohung bewerten
- SEAD-/DEAD-Bedarf ableiten
- Red-IADS-Sektoren verteidigen
- Blue-Korridore bewerten
- CAP über IADS-Lücken planen
- Red-CAP bei IADS-Schäden verstärken
- AI-Operationen an SAM-/EWR-Status anpassen

Aktuell:

    IADS-State existiert noch nicht produktiv.
    AI nutzt IADS noch nicht produktiv.

---

## 14. Verhältnis zum UI-Bereich

F10Menu zeigt bereits AI-CAP-Status an.

Aktive UI-Datei:

    src/ui/tc_f10_menu.lua

Getestete Version:

    v0.2.0

Aktuelle F10-Funktion:

    Show AI CAP Status

F10Menu kann außerdem:

- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Missionsdetails anzeigen
- Missionen aktivieren
- Kampagnenstatus anzeigen
- Logistics Status anzeigen
- FOB Status anzeigen

Bewertung:

    AI-CAP-State ist über F10 erreichbar.
    Ein vollständiger AI-Director-Status existiert noch nicht.

Spätere F10-Funktionen:

- Show AI Director Status
- Show Blue AI Intent
- Show Red AI Intent
- Show AI Priority Zones
- Show AI Active Operations
- Show AI Pending Operations
- Show AI Threat Assessment
- Show AI Resource Assessment

---

## 15. State-first-Regel

Der AI-Bereich folgt aktuell strikt der state-first-Architektur.

Das bedeutet:

- AI erzeugt State.
- AI bewertet State.
- AI zeigt Status über F10 oder Log.
- AI löst noch keine echten MOOSE-Spawns aus.
- AI löst keine CTLD-Aktionen aus.
- AI löst keine Skynet-Aktionen aus.
- AI verändert keine Vendor-Dateien.

Nicht aktiv:

- echte CAP-Flüge
- echte GCI
- echte Strike Packages
- echte Red-Operationen
- echte Blue-Operationen
- echte AI-Director-Entscheidungen

Grund:

    KI-Entscheidungen müssen zuerst sichtbar und reproduzierbar sein.
    Echte DCS-Aktionen werden erst später kontrolliert angebunden.

---

## 16. Spätere MOOSE-Rolle

MOOSE ist das geplante Hauptframework für viele AI-Flugoperationen.

Mögliche spätere MOOSE-Nutzung:

- AI_A2A_DISPATCHER
- AI_A2G_DISPATCHER
- CAP
- GCI
- Squadron Management
- Detection Networks
- Tasking
- Mission Packages

Aktuell:

    MOOSE ist geladen.
    AICapManager erzeugt state-only CAP-Requests.
    MOOSE-CAP-Spawns sind noch nicht aktiv.
    spawn=MOOSE_PENDING ist erwartbar.

---

## 17. Blue AI Zielbild

Blue AI soll später eigene Operationen unterstützen.

Mögliche Blue-AI-Aufgaben:

- Akrotiri sichern
- CAP über Zypern und Operationskorridoren anfordern
- SEAD-/DEAD-Vorbereitung priorisieren
- FOB-Aufbau unterstützen
- Logistics Push sichern
- Capture-Pressure gegen rote Airbases aufbauen
- Red-IADS-Schwächen ausnutzen
- Missionen nach Kampagnenphase priorisieren

Aktuell:

    Blue AI ist noch nicht als Director implementiert.
    AICapManager erzeugt nur CAP-State.

---

## 18. Red AI Zielbild

Red AI soll später eigene Operationen durchführen.

Mögliche Red-AI-Aufgaben:

- syrisches Festland verteidigen
- strategische Airbases schützen
- CAP gegen Blue-Korridore anfordern
- Blue-FOBs angreifen
- Blue-Logistik stören
- IADS-Sektoren verteidigen
- Gegenangriffe auf umkämpfte Zonen planen
- Missionen gegen Blue-Druck erzeugen

Aktuell:

    Red AI ist noch nicht als Director implementiert.
    AICapManager erzeugt nur vorbereitenden CAP-State.

---

## 19. AI-State

Mögliche spätere State-Bereiche:

    State.AI
    State.AI.CAP
    State.AI.Director
    State.AI.Operations
    State.AI.Intentions
    State.AI.Priorities
    State.AI.Requests
    State.AI.ThreatAssessment
    State.AI.ResourceAssessment
    State.AI.DecisionHistory

Aktuell vorhandener Schwerpunkt:

    State.AI.CAP

Aktuelle Werte:

    CAP requests: 12
    reactionState: AIR_REACTION_REQUESTED
    threatLevel: HIGH

---

## 20. Testziele

AICapManager v0.2.0 gilt aktuell als bestanden, wenn:

- Datei lädt.
- Version wird im Log angezeigt.
- AICapManager startet.
- CAP-Zonen-Kandidaten werden erkannt.
- 12 CAP-Zonen werden registriert.
- 12 CAP-Requests werden erzeugt.
- reactionState wird gesetzt.
- threatLevel wird gesetzt.
- keine echten MOOSE-Spawns ausgelöst werden.
- keine CTLD-Aktionen ausgelöst werden.
- keine Skynet-Aktionen ausgelöst werden.
- keine Theater-Command-Lua-Fehler auftreten.
- keine Lua-Stacktraces auftreten.

Noch offen:

- echte MOOSE-CAP-Flüge
- GCI
- AI Director
- Blue-/Red-Operationsplanung
- Ressourcenmodell
- Missionsergebnis-Reaktion
- AI-Persistenz

---

## 21. Erwartete Logmarker

Aktuelle erwartete Logmarker:

    [TC] [AICapManager] Loaded src/ai/tc_ai_cap_manager.lua v0.2.0
    [TC] [AICapManager] CAP zone candidates:
    [TC] [AICapManager] CAP requests:
    [TC] [AICapManager] AI CAP state updated
    [TC] System started: AI CAP Manager

Zusätzlich über F10:

    [TC] [F10Menu] AI CAP status shown through F10

Der genaue Wortlaut einzelner Summary-Logs kann je nach Implementierung variieren.

Wichtig ist:

    Version korrekt.
    CAP-State vorhanden.
    keine echten Spawns.
    keine Fehler.

---

## 22. Abgrenzung

Nicht Aufgabe von `src/ai/`:

- Airbases scannen
- Zonen erzeugen
- Capture direkt durchführen
- FOBs direkt bauen
- CTLD-Cargo direkt ausführen
- Missionen direkt im F10 anzeigen
- IADS-Netzwerke direkt konfigurieren
- Save-Dateien schreiben
- Vendor-Dateien verändern

Diese Aufgaben gehören in andere Bereiche.

AI bewertet, priorisiert und erzeugt später Entscheidungs-State.

---

## 23. Nächster sinnvoller Schritt

Der nächste sinnvolle Schritt liegt nicht direkt im AI-Bereich.

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

`src/ai/` wird langfristig die KI-Entscheidungsschicht von Theater Command DCS.

Aktueller Status:

    AICapManager v0.2.0 ist state-first bestanden.
    Vollständiger AI Director ist noch nicht implementiert.
    Echte MOOSE-AI-Aktionen sind noch nicht aktiv.

Nächster notwendiger Zwischenschritt im Gesamtprojekt:

    F10Menu v0.2.1 mit Capture-/Pressure-Sichtbarkeit.

Danach sinnvoll:

    Mission completed/failed testbar machen.
    Mission Effects kontrolliert testen.
    Danach AI Director state-only beginnen.
