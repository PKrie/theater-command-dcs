# Debug – Theater Command DCS

## Verbindlicher Stand — 2026-09-29

Diese Datei beschreibt den Debug-Bereich von **Theater Command DCS**.

Projekt:

    Theater Command DCS

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Aktueller Debug-Stand:

    kein eigenes produktives Debug-Lua-Modul

Aktuelle Hauptwerkzeuge für Diagnose:

    F10Menu
    dcs.log
    Claude + dcs-mcp
    Claude Code + DCS-SMS

Aktueller Entwicklungsbereich:

    Priority 4 – produktive CTLD-Integration vorbereiten

Priority 3:

    abgeschlossen im dokumentierten Umfang seit 2026-09-21

Verbindlich:

    productiveRestore=false

---

## 1. Zweck des Debug-Bereichs

`src/debug/` ist für spätere eigene Diagnose-, Reporting- und Entwicklungsfunktionen vorgesehen.

Debug ist kein Kampagnen-Hauptsystem.

Debug soll insbesondere helfen:

- State sichtbar zu machen
- Systemzustände zusammenzufassen
- Fehler einzugrenzen
- Testpfade kontrolliert auszulösen
- Runtime-Ergebnisse nachvollziehbar zu machen
- Kampagnensysteme voneinander zu unterscheiden

Debug soll fachliche Systeme nicht ersetzen.

---

## 2. Aktueller Stand

Aktuell vorhanden:

    src/debug/README.md

Aktuell nicht vorhanden:

    produktives Debug-Lua-Modul

Das ist bewusst.

Die momentan benötigte Sichtbarkeit wird bereits bereitgestellt durch:

- F10Menu
- DCS-Logs
- Runtime-Diagnose
- Mission-Editor-Audits
- GitHub-Source-Audits

Ein zusätzliches Debug-Modul wird erst gebaut, wenn dafür ein konkreter Bedarf entsteht.

---

## 3. Architekturregel

Externe Frameworks liegen unter:

    vendor/

Eigene Theater-Command-Logik liegt unter:

    src/

Debug-Dateien werden nach Debug-Aufgabe benannt.

Nicht gewünscht:

    tc_mist_debug.lua
    tc_moose_debug.lua
    tc_ctld_debug.lua
    tc_skynet_debug.lua
    tc_debug_all_in_one.lua
    tc_everything_debug.lua

Mögliche spätere fachliche Debug-Dateien:

    tc_debug_state_dump.lua
    tc_debug_airbase_report.lua
    tc_debug_zone_report.lua
    tc_debug_capture_report.lua
    tc_debug_mission_report.lua
    tc_debug_logistics_report.lua
    tc_debug_ai_report.lua
    tc_debug_iads_report.lua

Diese Dateien werden nicht vorsorglich angelegt.

---

## 4. Aktueller Systemstand

Aktuelle relevante Versionen:

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

CTLD:

    1.6.1

Priority 3:

    abgeschlossen

Produktiver Restore:

    deaktiviert

---

## 5. Aktuell bestätigte Kernwerte

World:

    Airbase-like Objects: 225
    relevante Kampagnenzonen: 46

Capture:

    Capture Candidates: 32
    Pressure Records: 32
    Progress Records: 32

Logistics:

    Logistics Hubs: 46

FOB:

    FOB Candidates: 6
    Blue FOBs: 2

MissionGenerator:

    Mission Candidates: 78
    Mission Records: 10

AI:

    CAP Zone Candidates: 31
    CAP Zones: 12
    CAP Requests: 12

F10:

    Commands: 33

---

## 6. Auflösung des früheren Mission-Record-Verdachts

Der frühere Verdacht, dass MissionGenerator seine sechs Mission-Status-Dictionaries verliert, wurde am:

    2026-09-12

widerlegt.

Die Mission Collections sind:

    String-keyed Lua-Dictionaries

Deshalb ist:

    #table

für deren Anzahl nicht autoritativ.

Live bestätigt:

    statistics.available = 10
    pairs()-Count = 10
    #available = 0

Die Mission Records waren vorhanden.

Der damalige Diagnosefehler lag in einer falschen Count-Auswertung in:

    src/core/tc_state.lua

Es existiert aktuell kein bestätigter Mission-Record-Datenverlust.

Der frühere Status:

    PROJECT SOURCE HAS NO MATCHING WRITE SITE

ist deshalb keine aktuelle offene Fehlerklassifikation mehr.

---

## 7. Embedded Resource Audit

Der damals als nächster Schritt geplante Embedded Resource Audit wurde inzwischen durchgeführt.

Auditdatum:

    2026-09-12

Ergebnis:

    13/13 relevante aktive Theater-Command-Ressourcen EXACT_MATCH

Bestätigt:

- keine relevante aktive Embedded-Source-Drift
- keine fehlende aktive Theater-Command-Ressource
- damalige DEV- und Testmission waren im geprüften Stand byte-identisch

Dieser Arbeitsschritt ist abgeschlossen.

Er ist kein aktueller nächster Debug-Schritt.

---

## 8. Verhältnis zu F10Menu

F10Menu:

    src/ui/tc_f10_menu.lua
    v0.2.3

Bestätigt:

    33 Commands

F10 übernimmt aktuell einen erheblichen Teil der benötigten State-Sichtbarkeit.

Unter anderem verfügbar:

- Available Missions
- Active Missions
- Mission Details
- Mission Activation
- Mission Completion
- Mission Failure
- Campaign Status
- Capture Status
- Capture Ready
- Pressure Contested
- Capture Ready Apply
- Logistics Status
- FOB Status
- AI CAP Status

Der frühere geplante UI-Schritt:

    Capture-/Pressure-Status sichtbar machen

ist abgeschlossen.

Auch:

    Apply Capture Ready Zone 1

ist inzwischen implementiert und getestet.

---

## 9. Verhältnis zum Core

Debug darf später auf Core-Infrastruktur zugreifen.

Relevante Bereiche:

    TC.Config
    TC.Logger
    TC.State
    TC.Utils
    TC.Scheduler

Debug soll:

- State lesen
- State darstellen
- technische Reports erzeugen

Debug soll nicht:

- Core-Logik ersetzen
- Dirty-State beiläufig verändern
- neue globale Projektstrukturen erzeugen

---

## 10. Verhältnis zu World

World-Dateien:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

Mögliche spätere Debug-Reports:

- Airbase Summary
- Airbase Classification
- Strategic Airbases
- Secondary Airfields
- Unknown Objects
- Zone Summary
- Capture Zones
- Mission Zones
- Logistics Zones
- Startbase Zones

Debug führt selbst keinen Airbase-Scan durch.

Debug erzeugt selbst keine Kampagnenzonen.

---

## 11. Verhältnis zu CaptureSystem

CaptureSystem:

    src/campaign/tc_capture_system.lua
    v0.2.2

Bestätigt:

- Capture Eligibility
- Capture Pressure
- Capture Progress
- Capture Ready
- Mission Effects
- Capture Apply
- linked Airbase Ownership
- Getter Read-Neutrality
- same-owner No-Op

Mögliche spätere Debug-Ausgaben:

- Capture Summary
- Pressure Records
- Progress Records
- Ready Zones
- Contested Zones
- Ownership Changes
- Mission Effects

Ein großer Teil dieser Informationen ist aktuell bereits über F10 sichtbar.

---

## 12. Verhältnis zu Persistence

PersistenceSystem:

    src/campaign/tc_persistence_system.lua
    v0.2.6

Bestätigt:

- Background Autosave
- Dirty Awareness
- `SAVED`
- `SKIPPED`
- kontrollierter `FAILED`
- Retry
- Save-Verifikation
- kontrollierter Import

Verbindlich:

    productiveRestore=false

Mögliche spätere Debug-Ausgaben:

- Persistence Status
- Dirty State
- Dirty Reason
- Save Path
- Last Save
- Autosave Status
- Restore Status

Aktuell existiert bewusst kein normales Spieler-Persistence-F10-Menü.

---

## 13. Verhältnis zu Logistics

LogisticsDelivery:

    v0.2.1

FobSystem:

    v0.2.1

Bestätigt:

    Logistics Hubs: 46
    FOB Candidates: 6
    Blue FOBs: 2

Priority-3-Ergebnis:

    Read-Neutrality bestanden

Mögliche spätere Debug-Reports:

- Logistics Hub Summary
- Hub State
- Delivery State
- FOB Candidates
- FOB State
- Build Progress
- spätere CTLD-Auftragsdaten

Debug führt selbst keine produktiven CTLD-Lieferungen aus.

---

## 14. Verhältnis zu MissionGenerator

MissionGenerator:

    src/missions/tc_mission_generator.lua
    v0.2.3

Bestätigt:

    Mission Candidates: 78
    Mission Records: 10

Bestätigte Lifecycle-Pfade:

    AVAILABLE -> ACTIVE
    ACTIVE -> COMPLETED
    ACTIVE -> FAILED

Mögliche spätere Debug-Reports:

- verfügbare Missionen
- aktive Missionen
- abgeschlossene Missionen
- fehlgeschlagene Missionen
- Mission Effects
- Activation Metadata
- Framework Hooks

Aktuell werden die wichtigsten Mission-Funktionen bereits über F10 sichtbar gemacht.

---

## 15. Verhältnis zu AI

AICapManager:

    src/ai/tc_ai_cap_manager.lua
    v0.2.1

Bestätigt:

    CAP Zone Candidates: 31
    CAP Zones: 12
    CAP Requests: 12

Priority-3-Ergebnis:

    Read-Neutrality bestanden

Mögliche spätere Debug-Ausgaben:

- CAP Zones
- CAP Requests
- Active CAP State
- Threat State
- Reaction State
- AI Director State

Ein vollständiger AI Director existiert noch nicht.

---

## 16. Verhältnis zu IADS

Skynet IADS:

    3.3.0

Status:

    geladen

Eigenes produktives Theater-Command-IADS-System:

    noch nicht implementiert

Mögliche spätere Debug-Ausgaben:

- IADS Networks
- IADS Sectors
- Sites
- EWR
- SAMs
- Suppression State
- Damage State
- Mission Effects

Debug wird keine Vendor-IADS-Dateien verändern.

---

## 17. Verhältnis zu CTLD

CTLD:

    1.6.1

Am 2026-09-29 wurde für einen isolierten getesteten Aufbau ein vollständiger KI-Truppentransport praktisch bestätigt.

Bestätigter Pfad:

    Runtime-Zonenregistrierung
    -> KI-Transporterregistrierung
    -> automatischer Pickup
    -> Flug
    -> Off-Airfield-Landung
    -> automatischer Dropoff
    -> reale Blue-Bodengruppe

Dieser Test ist:

    Framework-PoC für den getesteten Aufbau

Noch nicht vorhanden:

    produktive Theater-Command-CTLD-Orchestrierung

Spätere Debug-Funktionen können CTLD-Integrationsstate sichtbar machen.

Sie sollen CTLD jedoch nicht zum Eigentümer des Campaign-State machen.

---

## 18. CTLD `RepackCommandsPath`

Beim erfolgreichen CTLD-Test wurde genau einmal beim Touchdown beobachtet:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Pickup und Dropoff wurden trotzdem abgeschlossen.

Nicht direkt bewiesen ist:

- ob spätere Repack-Menü-Aktualisierungen funktionieren
- ob der betreffende Scheduler-Pfad weiterlief
- ob der betreffende Scheduler-Pfad beendet wurde

Ein möglicher Scheduler-Abbruch bleibt technische Inferenz.

Verbindlich:

    vendor/ctld/CTLD.lua wird nicht gepatcht.

Ein späteres Debug-System kann helfen, diesen Lifecycle sichtbar zu machen.

Die eigentliche Behandlung gehört jedoch an die fachliche CTLD-Integrationsgrenze.

---

## 19. DCS-Log als Debug-Werkzeug

`dcs.log` bleibt eine zentrale technische Evidenzquelle.

Typische Pfade:

    C:\Users\Paul\Saved Games\DCS.openbeta\Logs\dcs.log

oder:

    C:\Users\Paul\Saved Games\DCS\Logs\dcs.log

Wichtige Marker:

    [TC]
    [TC][ERROR]
    SCRIPTING ERROR
    Mission script error
    stack traceback
    nil value
    PersistenceSystem
    CaptureSystem
    MissionGenerator
    AICapManager
    F10Menu
    CTLD

Debug-Auswertung muss zwischen:

- Theater-Command-Fehler
- Vendor-Fehler
- DCS-interner Warnung
- erwarteter Testmeldung

unterscheiden.

---

## 20. Entwicklungswerkzeuge

Die aktuelle Werkzeugtrennung ist selbst Teil der Debug-Strategie.

### ChatGPT

Rolle:

    Projektkoordination
    Architektur
    Testplanung
    Ergebnisbewertung
    GitHub-Audit
    Dokumentation

### Claude + dcs-mcp

Version:

    dcs-mcp 0.9.11

Rolle:

- `.miz`-Analyse
- Mission-Editor-Struktur
- Gruppen
- Units
- Trigger-Zonen
- Wegpunkte
- Tasks
- Embedded Resources
- gespeicherter Missionsaudit

Terrain Store:

    C:\Users\Paul\AppData\Local\dcs-mcp\terrain

Syria:

    installiert

### Claude Code + DCS-SMS

DCS-SMS:

    0.27.2

Hook:

    me-bridge-0.27.2

Verifiziertes Installationsverzeichnis:

    C:\Tools\dcs-sms

Claude-Code-Skill:

    C:\Users\Paul\.claude\skills\dcs-sms\SKILL.md

Rolle:

- lokale DCS-Runtime
- Runtime-Lua
- Theater-Command-State
- CTLD-Live-State
- Unit-/Group-State
- Logs
- Runtime-Regressionen

Aus dem bestätigten Stand wird kein exakter DCS-SMS-Executable-Pfad abgeleitet.

Diese Werkzeuge sind Entwicklungs- und Diagnosewerkzeuge.

Sie sind keine Runtime-Abhängigkeit der fertigen Kampagne.

---

## 21. State-first-Regel für Debug

Debug folgt derselben Architektur wie das Gesamtprojekt.

Grundregel:

    Debug liest State.
    Debug macht State sichtbar.

Debug darf nicht beiläufig:

- Campaign-State mutieren
- Dirty erzeugen
- Framework-Aktionen auslösen
- Vendor-Dateien verändern

Wenn später eine Debug-Funktion bewusst State mutiert, muss sie:

- eindeutig als Debug gekennzeichnet sein
- gezielt getestet werden
- klare Logmarker besitzen
- Dirty-Semantik respektieren
- von normaler Spielerlogik getrennt bleiben

---

## 22. Geplanter Namespace

Wenn später ein eigenes Debug-Modul entsteht:

    TC.Debug

Möglicher State:

    TC.State.Debug

Keine zusätzlichen globalen Projektnamespaces einführen.

Nicht verwenden:

    TheaterCommandDebug
    DebugTC
    _G_TC_DEBUG

---

## 23. Mögliche spätere Debug-Funktionen

Mögliche Reports:

- State Summary
- Airbase Report
- Zone Report
- Capture Report
- Logistics Report
- FOB Report
- Mission Report
- AI Report
- IADS Report
- Persistence Report
- CTLD Integration Report

Mögliche spätere separate Entwicklerfunktionen:

- State Dump
- gezielte Regressionstrigger
- definierte Lifecycle-Tests

Diese Funktionen sind Zukunftsdesign.

Sie sind aktuell nicht implementiert.

---

## 24. Sicherheitsregeln

Für spätere Debug-Module gilt:

- klar als Debug kennzeichnen
- abschaltbar halten
- keine Vendor-Dateien verändern
- keine All-in-one-Datei
- keine versteckten Campaign-Mutationen
- keine echte Framework-Execution ohne ausdrücklichen Testzweck
- keine Save-Manipulation ohne Schutzmaßnahmen
- klare Logmarker
- UI und Debug möglichst getrennt halten
- normale Kampagnenlogik nicht duplizieren

---

## 25. Warum aktuell kein Debug-Modul gebaut wird

Der aktuelle Projektbereich ist:

    Priority 4 – produktive CTLD-Integration vorbereiten

Für den nächsten Schritt werden zuerst benötigt:

- Source-Audit
- klare fachliche Integrationsgrenze
- CTLD-Lifecycle-Entscheidung
- Result Validation
- Dirty-/Persistence-Grenze

Ein neues Debug-Modul würde diesen Architekturpunkt aktuell nicht lösen.

Deshalb:

    kein paralleler Debug-Ausbau

---

## 26. Aktueller nächster Projektschritt

Der nächste Schritt liegt nicht in:

    src/debug/

Aktuell:

    Priority 4 – produktive CTLD-Integration vorbereiten

Zu klären sind insbesondere:

- Besitzer des Transportauftrags
- Zonenregistrierung
- Transporterregistrierung
- Transporter-Lifecycle
- `RepackCommandsPath`
- Result Validation
- LogisticsDelivery-Rückkopplung
- FobSystem-Rückkopplung
- Dirty-Semantik
- Persistence-Grenze

Erst wenn daraus ein konkreter Diagnosebedarf entsteht, wird entschieden, ob ein eigenes Debug-Modul erforderlich ist.

---

## 27. Aktueller Abschlussstand

Stand:

    2026-09-29

Debug-Bereich:

    vorbereitet
    kein eigenes produktives Lua-Modul

Aktuelle Sichtbarkeit:

    F10Menu v0.2.3
    33 Commands
    dcs.log
    dcs-mcp
    DCS-SMS

Mission-Record-Loss:

    widerlegt

Embedded Resource Audit:

    abgeschlossen
    13/13 relevante aktive Ressourcen EXACT_MATCH

Priority 3:

    abgeschlossen

CTLD:

    KI-Truppentransport-PoC für den getesteten Aufbau bestanden

Verbindlich:

    productiveRestore=false

Aktueller Übergang:

    stabiler state-first Kampagnenkern
    +
    belastbare Runtime-/Debug-Werkzeuge
    +
    abgeschlossene Dirty-Coverage
    +
    bestandener CTLD-Transport-PoC
    ->
    kontrollierte produktive CTLD-Integration
