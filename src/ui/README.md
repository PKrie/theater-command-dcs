# UI – Theater Command DCS

## Verbindlicher Stand — 2026-09-29

Diese Datei beschreibt den UI-Bereich von **Theater Command DCS**.

Projekt:

    Theater Command DCS

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Aktive Datei:

    src/ui/tc_f10_menu.lua

Version:

    v0.2.3

Bestätigt:

    33 F10 Commands

Aktueller Entwicklungsbereich des Gesamtprojekts:

    Priority 4 – produktive CTLD-Integration vorbereiten

Priority 3:

    abgeschlossen im dokumentierten Umfang seit 2026-09-21

Verbindlich:

    productiveRestore=false

---

## 1. Zweck des UI-Bereichs

`src/ui/` ist die Spieler-, Status- und aktuelle Testoberfläche für Theater Command DCS.

Der UI-Bereich macht Kampagnenstate sichtbar und stellt kontrollierte Interaktionspfade bereit.

Aktuelle Aufgaben:

- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Missionsdetails anzeigen
- Missionen aktivieren
- Mission Outcomes kontrolliert testen
- Campaign Status anzeigen
- Capture Status anzeigen
- Capture Ready Zones anzeigen
- Capture Ready kontrolliert anwenden
- Pressure Contested Zones anzeigen
- Logistics Status anzeigen
- FOB Status anzeigen
- AI CAP Status anzeigen

F10 ist aktuell vor allem:

    Sichtbarkeit
    Debug
    kontrollierter Testzugang

Das F10-Menü ist nicht der eigentliche Kampagnenmotor.

---

## 2. Architekturregel

Das UI folgt der Theater-Command-Grundarchitektur:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis / Source of Truth
    DCS Runtime = autoritativer Verhaltensbeweis

Für UI gilt zusätzlich:

    UI liest State
    -> zeigt State
    -> ruft definierte Theater-Command-Funktionen auf

UI soll nicht:

- eigene Kampagnenlogik duplizieren
- Framework-Orchestrierung übernehmen
- Vendor-State direkt manipulieren
- CTLD direkt produktiv steuern
- MOOSE direkt produktiv steuern
- Skynet direkt produktiv steuern
- Save-Dateien direkt verwalten

---

## 3. Aktive Datei

Datei:

    src/ui/tc_f10_menu.lua

Version:

    v0.2.3

Source-Verantwortlichkeiten:

- Blue Coalition Theater Command F10-Menü erzeugen
- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Mission Details 1–10 anzeigen
- Mission 1–10 aktivieren
- Active Mission Outcome Status anzeigen
- Active Mission 1 state-only abschließen
- Active Mission 1 state-only fehlschlagen lassen
- Campaign Status anzeigen
- Capture Status anzeigen
- Capture Ready Zones anzeigen
- Pressure Contested Zones anzeigen
- Capture Ready Zone 1 kontrolliert anwenden
- Logistics Status anzeigen
- FOB Status anzeigen
- AI CAP Status anzeigen
- alle UI-Funktionen ohne direkte Framework-Execution halten

---

## 4. Aktueller F10-Stand

Version:

    v0.2.3

Commands:

    33

Bestätigt:

- Menü lädt.
- Menü startet.
- Theater Command F10-Menü erscheint.
- Menü ist navigierbar.
- Missionen werden angezeigt.
- Missionsdetails funktionieren.
- Mission Activation funktioniert.
- Mission Completion funktioniert.
- Mission Failure funktioniert.
- Capture Status funktioniert.
- Capture Ready funktioniert.
- Pressure Contested funktioniert.
- Capture Ready Apply funktioniert.
- Logistics Status funktioniert.
- FOB Status funktioniert.
- AI CAP Status funktioniert.

Es werden über diese UI-Pfade keine realen MOOSE-, CTLD- oder Skynet-Operationen ausgelöst.

---

## 5. Aktuelle Menüstruktur

    F10
    └── Theater Command
        ├── Missions
        │   ├── Show Available Missions
        │   ├── Show Active Missions
        │   ├── Mission Details
        │   │   ├── Show Mission 1 Details
        │   │   ├── ...
        │   │   └── Show Mission 10 Details
        │   ├── Activate Mission
        │   │   ├── Activate Mission 1
        │   │   ├── ...
        │   │   └── Activate Mission 10
        │   └── Mission Outcome
        │       ├── Show Active Mission Outcome Status
        │       ├── Complete Active Mission 1
        │       └── Fail Active Mission 1
        ├── Status
        │   ├── Show Campaign Status
        │   ├── Show Capture Status
        │   ├── Show Capture Ready Zones
        │   ├── Apply Capture Ready Zone 1
        │   └── Show Pressure Contested Zones
        ├── Logistics
        │   ├── Show Logistics Status
        │   └── Show FOB Status
        └── AI
            └── Show AI CAP Status

---

## 6. MissionGenerator-Integration

MissionGenerator:

    src/missions/tc_mission_generator.lua
    v0.2.3

Bestätigt:

    Mission Candidates: 78
    FOB Support Candidates: 2
    Mission Records: 10

F10Menu verwendet MissionGenerator unter anderem für:

- Available Missions
- Active Missions
- Mission Details
- Activation
- Completion
- Failure
- Outcome Status

Bestätigte Statuswechsel:

    AVAILABLE -> ACTIVE
    ACTIVE -> COMPLETED
    ACTIVE -> FAILED

Missionen bleiben aktuell:

    state-only

Die reservierten Framework Hooks lösen noch keine reale Mission Execution aus.

---

## 7. Mission-Record-Diagnose

Der frühere Verdacht eines Mission-Record-Verlusts wurde am:

    2026-09-12

widerlegt.

Mission Collections sind:

    String-keyed Lua-Dictionaries

Daher ist:

    #table

für diese Collections nicht autoritativ.

Live bestätigt:

    statistics.available = 10
    pairs()-Count = 10
    #available = 0

Die Mission Records waren vorhanden.

Der damalige Zählfehler lag in:

    src/core/tc_state.lua

F10Menu war nicht Verursacher eines Mission-Record-Verlusts.

Es existiert aktuell kein bestätigter Mission-Record-Loss.

---

## 8. Mission Activation

Bestätigt:

    F10
    -> Activate Mission
    -> MissionGenerator
    -> AVAILABLE -> ACTIVE

Activation Metadata:

    stateOnly=true
    spawnHooks=reserved

Damit gilt:

    Mission Activation
    !=
    realer Framework-Spawn

Dieser Zustand ist aktuell bewusst.

---

## 9. Mission Completion

Bestätigt:

    F10
    -> Complete Active Mission 1
    -> MissionGenerator
    -> ACTIVE -> COMPLETED
    -> Mission Effects
    -> CaptureSystem

Bestätigter Wirkungspfad:

    Completion
    -> Capture Pressure
    -> Capture Progress
    -> Capture Ready

Persistence wurde dabei ebenfalls erfolgreich ausgelöst.

---

## 10. Mission Failure

Bestätigt:

    F10
    -> Fail Active Mission 1
    -> MissionGenerator
    -> ACTIVE -> FAILED

Aktuelles Capture-Verhalten:

    FAILED
    -> kein Capture Pressure

Persistence:

    bestanden

Damit ist die frühere offene Failure-Regression abgeschlossen.

---

## 11. CaptureSystem-Integration

CaptureSystem:

    src/campaign/tc_capture_system.lua
    v0.2.2

F10Menu zeigt beziehungsweise steuert kontrolliert:

- Capture Status
- Capture Ready Zones
- Pressure Contested Zones
- Apply Capture Ready Zone 1

Bestätigte Capture-Grundwerte:

    eligibleBases: 32
    eligibleZones: 32
    pressureRecords: 32
    progressRecords: 32

---

## 12. Capture Ready

Bestätigter Testfall:

    Mission MISSION_2
    -> ZONE_AIRBASE_ABU_AL_DUHUR
    -> BLUE pressure 105
    -> progress 100 %
    -> captureReady=true

F10Menu kann diesen Zustand anzeigen.

Damit ist Capture Ready nicht mehr nur ein interner Log-/State-Befund.

---

## 13. Capture Ready Apply

F10Menu `v0.2.3` ergänzte den kontrollierten Befehl:

    Apply Capture Ready Zone 1

Der Befehl ruft die bestehende CaptureSystem-Logik auf.

Bestätigter Test:

    ZONE_AIRBASE_ABU_AL_DUHUR

Vor Apply:

    owner=RED
    progress=100 %
    captureReady=true

Nach Apply:

    zoneOwner=BLUE
    previousOwner=RED
    baseOwner=BLUE
    progress=0
    status=STABLE
    captureReady=false

Persistence:

    SAVED

Dirty Reason:

    f10_capture_ready_zone_1_applied

Damit ist der frühere UI-Arbeitsschritt:

    kontrollierter Capture Ready Apply

abgeschlossen.

---

## 14. F10-Anzeige des Ownership-Wechsels

Bei einem früheren Test zeigte die F10-Ausgabe kosmetisch:

    BLUE -> BLUE

Der Runtime-State bestätigte tatsächlich:

    RED -> BLUE

Damit war der Ownership-Wechsel korrekt.

Die Anzeigeabweichung war kein CaptureSystem-State-Fehler.

Bei späterer UI-Arbeit können solche Darstellungsdetails separat verbessert werden.

Sie sind aktuell kein Kampagnenblocker.

---

## 15. LogisticsDelivery-Integration

LogisticsDelivery:

    src/logistics/tc_logistics_delivery.lua
    v0.2.1

Bestätigte Werte:

    Logistics Hubs: 46
    Blue: 7
    Red: 24
    Neutral: 15
    Active: 31
    Limited: 15
    Locked: 0

F10-Funktion:

    Show Logistics Status

Priority-3-Ergebnis:

    Read-Neutrality bestanden

F10 liest Logistics-State.

F10 löst aktuell keine reale CTLD-Logistikoperation aus.

---

## 16. FobSystem-Integration

FobSystem:

    src/logistics/tc_fob_system.lua
    v0.2.1

Bestätigt:

    FOB Candidates: 6
    Blue FOBs: 2

FOBs:

    FOB Ercan
    FOB Gecitkale

Status:

    UNDER_CONSTRUCTION

F10-Funktion:

    Show FOB Status

Diese FOBs sind weiterhin:

    Campaign State

und keine real durch CTLD gebauten FOBs.

---

## 17. AICapManager-Integration

AICapManager:

    src/ai/tc_ai_cap_manager.lua
    v0.2.1

Bestätigt:

    CAP Zone Candidates: 31
    CAP Zones: 12
    CAP Requests: 12

F10-Funktion:

    Show AI CAP Status

Priority-3-Ergebnis:

    Read-Neutrality bestanden

Es existieren noch keine realen MOOSE-CAP-Flüge.

---

## 18. Persistence und F10

PersistenceSystem:

    src/campaign/tc_persistence_system.lua
    v0.2.6

Aktuelle Architekturentscheidung:

    kein normales Spieler-Persistence-Menü

Nicht vorhanden:

- Save Campaign State
- Load Campaign State
- Validate Save
- Restore Campaign

als reguläre Spieler-F10-Befehle.

Persistence läuft im Hintergrund.

Bestätigt:

- `SAVED`
- `SKIPPED`
- `FAILED`
- Retry

Verbindlich:

    productiveRestore=false

---

## 19. Warum Persistence nicht über F10 gesteuert wird

Persistence ist:

    Systemverhalten

und kein normaler Spielerauftrag.

Der Spieler soll später:

- Missionen fliegen
- kämpfen
- Gebiete beeinflussen
- Logistik durchführen

und nicht:

- Save-Dateien verwalten
- Restore auslösen
- Persistence validieren

Ein späteres separates Admin-/Debug-Konzept wäre nur bei konkretem Bedarf zu entscheiden.

---

## 20. Verhältnis zu CTLD

CTLD:

    1.6.1

Am 2026-09-29 wurde für einen isolierten getesteten Aufbau ein vollständiger KI-Truppentransport praktisch bestätigt.

Bestätigter Pfad:

    Runtime-Zonenregistrierung
    -> Transporterregistrierung
    -> automatischer Pickup
    -> Flug
    -> Off-Airfield-Landung
    -> automatischer Dropoff
    -> reale Blue-Bodengruppe

F10Menu ist an diesem erfolgreichen Testpfad nicht als produktiver CTLD-Orchestrator beteiligt.

Aktuell existiert kein:

    F10
    -> CTLD Transport starten

Produktiver Transport soll langfristig aus Kampagnenlogik entstehen und nicht von einem manuellen Spieler-Debug-Befehl abhängen.

---

## 21. Verhältnis zu IADS

Skynet IADS:

    3.3.0

ist geladen.

Ein produktiver Theater-Command-IADS-State existiert noch nicht.

Deshalb existiert aktuell auch kein IADS-F10-Bereich.

Mögliche spätere Statusanzeigen werden erst ergänzt, wenn das zugrunde liegende IADS-System existiert.

UI wird nicht vor dem Fachsystem gebaut.

---

## 22. State-first-Regel

F10Menu folgt weiterhin:

    State zuerst.

Das bedeutet:

- F10 liest Theater-Command-State.
- F10 zeigt Theater-Command-State.
- F10 ruft definierte Theater-Command-Funktionen auf.
- F10 Mission Activation bleibt state-only.
- F10 Mission Outcome bleibt state-first.
- Capture Apply verwendet CaptureSystem.
- F10 verändert keine Vendor-Dateien.
- F10 orchestriert keine reale CTLD-Execution.
- F10 orchestriert keine reale MOOSE-Execution.
- F10 orchestriert keine reale Skynet-Execution.

Framework-Execution bleibt außerhalb des UI.

---

## 23. UI-State und interne Laufzeitdaten

F10Menu besitzt eigene Runtime-Felder unter anderem für:

    menuRootCreated
    commandCount
    lastUpdateTime
    lastMessage
    lastSelectedMissionKey
    lastOutcomeMissionKey
    lastOutcomeAction
    lastAppliedCaptureZoneKey
    lastAppliedCaptureZoneName
    lastAppliedCaptureOwner
    lastAppliedCaptureStatus

Diese Werte unterstützen die UI-Runtime.

Sie machen das UI nicht zum Eigentümer des fachlichen Campaign-State.

---

## 24. Priority 3

Priority 3 wurde am:

    2026-09-21

im dokumentierten Umfang abgeschlossen.

Relevante aktuelle Modulstände:

    LogisticsDelivery v0.2.1
    FobSystem v0.2.1
    MissionGenerator v0.2.3
    AICapManager v0.2.1

F10Menu selbst ist aktuell:

    v0.2.3

Der alte Mission-Record-Loss-Verdacht wurde bereits vorher widerlegt.

Priority 3 ist nicht mehr der aktuelle Entwicklungsbereich.

---

## 25. Aktueller Systemstand

    AirbaseScanner      v0.2.2
    ZoneFactory         v0.2.0
    CaptureSystem       v0.2.2
    PersistenceSystem   v0.2.6
    LogisticsDelivery   v0.2.1
    FobSystem           v0.2.1
    MissionGenerator    v0.2.3
    AICapManager        v0.2.1
    F10Menu             v0.2.3

F10 Commands:

    33

Verbindlich:

    productiveRestore=false

---

## 26. Aktuelle UI-Akzeptanzkriterien

Bestanden:

- F10Menu `v0.2.3` lädt.
- Menü startet.
- 33 Commands werden erzeugt.
- F10-Menü ist sichtbar.
- F10-Menü ist navigierbar.
- Available Missions funktionieren.
- Active Missions funktionieren.
- Mission Details funktionieren.
- Mission Activation funktioniert.
- Mission Completion funktioniert.
- Mission Failure funktioniert.
- Campaign Status funktioniert.
- Capture Status funktioniert.
- Capture Ready Zones funktionieren.
- Pressure Contested Zones funktionieren.
- Apply Capture Ready Zone 1 funktioniert.
- Logistics Status funktioniert.
- FOB Status funktioniert.
- AI CAP Status funktioniert.
- Capture Apply synchronisiert Zone und linked Airbase im getesteten Pfad.
- getestete State-Mutationen lösen Persistence korrekt aus.
- keine reale CTLD-Execution wird durch F10 ausgelöst.
- keine reale MOOSE-Execution wird durch F10 ausgelöst.
- keine reale Skynet-Execution wird durch F10 ausgelöst.

---

## 27. Noch offene UI-Bereiche

Noch nicht implementiert beziehungsweise nicht aktuell benötigt:

- dynamische statt fester Mission-Slots
- Pagination
- vollständige Spieleroberfläche
- separates Debug-Menü
- separates Admin-Menü
- AI Director Status
- IADS Status
- produktive Logistics-Mission-Control
- produktive CTLD-Control
- Multiplayer-spezifische UI
- finales UX-Design

Diese Bereiche sind keine aktuelle Priority-4-Aufgabe.

---

## 28. Kein aktueller UI-Code-Schritt

Der frühere nächste UI-Schritt:

    Apply Capture Ready Zone 1

ist inzwischen abgeschlossen und getestet.

Der aktuelle Projektbereich ist:

    Priority 4 – produktive CTLD-Integration vorbereiten

Deshalb wird aktuell nicht parallel:

- F10Menu erweitert
- neues Admin-Menü gebaut
- Debug-Menü gebaut
- CTLD-Steuerung in F10 eingebaut
- IADS-Menü gebaut
- AI-Director-Menü gebaut

UI bleibt auf:

    v0.2.3

bis ein neuer fachlicher Bedarf entsteht.

---

## 29. Entwicklungswerkzeuge

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

Rolle:

    .miz
    Mission Editor
    Gruppen
    Zonen
    Trigger
    gespeicherte Missionsstruktur

### Claude Code + DCS-SMS

Version:

    DCS-SMS 0.27.2

Hook:

    me-bridge-0.27.2

Verifiziertes Installationsverzeichnis:

    C:\Tools\dcs-sms

Rolle:

    lokale Runtime
    Runtime-Lua
    Theater-Command-State
    F10-Runtime
    Logs
    Regressionen

Aus dem bestätigten Stand wird kein exakter DCS-SMS-Executable-Pfad abgeleitet.

---

## 30. Aktueller Abschlussstand

Stand:

    2026-09-29

F10Menu:

    v0.2.3

Commands:

    33

Bestätigt:

    Mission Visibility
    Mission Details
    Mission Activation
    Mission Completion
    Mission Failure
    Campaign Status
    Capture Status
    Capture Ready
    Pressure Contested
    Capture Ready Apply
    Logistics Status
    FOB Status
    AI CAP Status

Mission-Record-Loss:

    widerlegt

Persistence:

    Background-System
    kein Spieler-Save-/Load-Menü
    productiveRestore=false

Framework-Execution aus F10:

    nicht produktiv aktiv

Aktueller Projektübergang:

    stabiler state-first Kampagnenkern
    +
    vollständiger aktueller F10-Testzugang
    +
    abgeschlossene Priority-3-Dirty-Coverage
    +
    bestandener CTLD-KI-Truppentransport-PoC
    ->
    kontrollierte produktive CTLD-Integration
