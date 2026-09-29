# IADS – Theater Command DCS

## Verbindlicher Stand — 2026-09-29

Diese Datei beschreibt den IADS-Bereich von **Theater Command DCS**.

Projekt:

    Theater Command DCS

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Vendor:

    Skynet IADS 3.3.0

Aktueller eigener IADS-Stand:

    noch kein produktives Theater-Command-IADS-Lua-Modul

Aktueller Entwicklungsbereich des Gesamtprojekts:

    Priority 4 – produktive CTLD-Integration vorbereiten

Priority 3:

    abgeschlossen im dokumentierten Umfang seit 2026-09-21

Verbindlich:

    productiveRestore=false

---

## 1. Zweck des IADS-Bereichs

`src/iads/` ist für die spätere Theater-Command-Kampagnenschicht rund um:

    Integrated Air Defense System

vorgesehen.

Langfristig soll Luftverteidigung nicht nur aus statisch platzierten DCS-SAM-Gruppen bestehen.

Theater Command soll später unter anderem verwalten:

- IADS-Netzwerke
- IADS-Sektoren
- SAM-Sites
- EWR-Sites
- Command-Strukturen
- Site-Zustände
- Suppression
- Damage
- Repair
- Missionswirkungen
- strategische Bedeutung
- Persistence

Skynet IADS übernimmt dabei die technische DCS-Ausführung.

---

## 2. Architekturtrennung

Verbindliche Trennung:

    Theater Command
    -> Campaign Logic
    -> State Owner
    -> Mission Effects
    -> Persistence

    Skynet IADS
    -> technische IADS-Execution

Theater Command soll beispielsweise wissen:

- welche Site existiert
- welchem Sektor sie gehört
- welche Zone sie schützt
- wem sie gehört
- welchen Status sie besitzt
- welche Mission sie beeinflusst
- welche Wirkung eine Mission auf sie hatte

Skynet soll später die technische Radar-/SAM-Ausführung übernehmen.

Vendor-Runtime-State wird nicht zum alleinigen Kampagnenstate.

---

## 3. Aktueller Vendor-Stand

Datei:

    vendor/skynet-iads/SkynetIADS.lua

Im Vendor-Source bestätigt:

    SKYNET VERSION: 3.3.0

Status:

    geladen
    vom Loader erkannt
    unverändert

Verbindlich:

    vendor/skynet-iads/SkynetIADS.lua wird nicht verändert.

Aktuell initialisiert Theater Command noch kein produktives Skynet-Netzwerk.

---

## 4. Aktueller eigener Source-Stand

Ordner:

    src/iads/

Aktuell vorhanden:

    src/iads/README.md

Aktuell nicht vorhanden:

    produktives eigenes IADS-Lua-Modul

Insbesondere existiert noch kein produktives:

    tc_iads_system.lua

Keine IADS-Datei wird allein deshalb angelegt, weil sie perspektivisch sinnvoll sein könnte.

Vor einer neuen Source-Datei muss ihre konkrete fachliche Verantwortung feststehen.

---

## 5. Aktueller Gesamtprojektstand

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

Skynet IADS:

    3.3.0

CTLD:

    1.6.1

Priority 3:

    abgeschlossen

Produktiver Restore:

    deaktiviert

---

## 6. Aktuelle Kampagnengrundlage

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

Diese Systeme bilden später die Grundlage für eine IADS-Kampagnenintegration.

Das IADS-System nutzt sie aktuell noch nicht produktiv.

---

## 7. Mission-Record-Diagnose

Der frühere Verdacht eines Mission-Record-Verlusts wurde am:

    2026-09-12

widerlegt.

Mission Collections sind:

    String-keyed Lua-Dictionaries

Deshalb ist:

    #table

für deren Anzahl nicht autoritativ.

Live bestätigt:

    statistics.available = 10
    pairs()-Count = 10
    #available = 0

Die Mission Records waren vorhanden.

Der Fehler lag in einer falschen Count-Auswertung in:

    src/core/tc_state.lua

Es existiert aktuell kein bestätigter Mission-Record-Datenverlust.

Der frühere Record-Loss ist damit kein IADS-Blocker.

---

## 8. State-first-Regel

Auch IADS folgt dem Projektgrundsatz:

    State zuerst.

Spätere Entwicklungsreihenfolge:

    IADS-Domain-State
    -> State sichtbar machen
    -> State testen
    -> Dirty-Semantik
    -> Persistence
    -> isolierte Skynet-Execution
    -> Result Validation
    -> produktive Integration

Nicht:

    sofort komplettes Syria-IADS aktivieren

---

## 9. Vorbereiteter Core-State

Der Core besitzt bereits eine vorbereitete IADS-Struktur.

Konzeptionell vorhanden:

    State.IADS

mit Bereichen für:

    networks
    sectors
    sites

Dieser vorhandene Core-Bereich bedeutet nicht:

- produktive IADS-Netzwerke
- aktive Skynet-Sites
- laufende Radarsteuerung
- funktionierende Mission Effects
- produktiven IADS-Restore

Er ist eine State-Grundlage für spätere Entwicklung.

---

## 10. Möglicher späterer IADS-State

Mögliche fachliche Bereiche:

    State.IADS.networks
    State.IADS.sectors
    State.IADS.sites

Mögliche Site-Daten:

- siteId
- key
- name
- type
- coalition
- owner
- status
- linkedZone
- linkedBase
- network
- sector
- position
- radarState
- ammoState
- suppressionState
- damageState
- repairState
- lastMissionEffect
- lastUpdate

Mögliche Statuswerte:

    ACTIVE
    LIMITED
    SUPPRESSED
    DAMAGED
    DESTROYED
    REPAIRING
    OFFLINE
    UNKNOWN

Diese Felder sind Zukunftsdesign.

Sie sind aktuell nicht als produktiver IADS-State implementiert.

---

## 11. Verhältnis zum World Layer

World:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

Bestätigt:

    225 Airbase-like Objects
    46 relevante Kampagnenzonen
    19 Strategic Airfields
    13 Secondary Airfields
    32 Capture Candidates
    32 Mission Zones
    46 Logistics Zones

Ein späteres IADS-System soll auf fachlich relevanten Theater-Command-Daten aufbauen.

Es soll nicht ungefiltert alle 225 DCS-Airbase-like Objects als IADS-Struktur behandeln.

Mögliche spätere Beziehungen:

    IADS Site
    -> Zone

    IADS Sector
    -> mehrere Zones

    SAM / EWR
    -> Site
    -> Sector
    -> Network

---

## 12. Verhältnis zum CaptureSystem

CaptureSystem:

    src/campaign/tc_capture_system.lua
    v0.2.2

Bestätigt:

- Ownership
- Capture Pressure
- Capture Progress
- Capture Ready
- Capture Apply
- linked Airbase Ownership

Perspektivisch kann IADS Capture beeinflussen.

Beispiele:

- aktive Luftverteidigung erhöht Operationsrisiko
- erfolgreiche SEAD schwächt Verteidigung
- DEAD kann Folgeoperationen erleichtern
- Capture kann Site-Zuordnungen verändern

Aktuell existiert keine produktive:

    IADS
    -> Capture

oder:

    Capture
    -> IADS

Kopplung.

---

## 13. Verhältnis zu LogisticsDelivery

LogisticsDelivery:

    src/logistics/tc_logistics_delivery.lua
    v0.2.1

Bestätigt:

    Logistics Hubs: 46

Priority-3-Ergebnis:

    Read-Neutrality bestanden

Später mögliche Beziehungen:

- SAM-Sites benötigen Nachschub
- Munition beeinflusst Einsatzfähigkeit
- Damage benötigt Repair
- Engineering kann Wiederherstellung beeinflussen
- IADS schützt Logistics Hubs
- zerstörtes IADS öffnet Transportkorridore

Aktuell besteht keine produktive Logistics-/IADS-Kopplung.

---

## 14. Verhältnis zu FobSystem

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

Später können FOBs unter anderem beeinflussen:

- Forward Logistics
- SEAD-Reichweite
- Radarunterstützung
- Operationskorridore

Aktuell besteht keine produktive FOB-/IADS-Kopplung.

---

## 15. Verhältnis zum MissionGenerator

MissionGenerator:

    src/missions/tc_mission_generator.lua
    v0.2.3

Bestätigt:

    Mission Candidates: 78
    Mission Records: 10

IADS-nahe Missionstypen sind bereits fachlich vorbereitet:

    SEAD
    DEAD
    IADS_SUPPRESSION

MissionGenerator besitzt außerdem vorbereitete:

    Framework Hooks

für spätere Execution.

Aktuell gilt:

    Mission Intent vorhanden
    echte IADS-Ausführung nicht vorhanden

MissionGenerator ruft Skynet derzeit nicht produktiv auf.

---

## 16. IADS Mission Effects

Perspektivische IADS-Wirkungen können beispielsweise sein:

    suppressSite
    damageSite
    destroySite
    disableRadar
    degradeNetwork
    reduceSectorReadiness
    revealSite
    repairSite
    restoreSector

Aktuell verändert Mission Completion keinen produktiven Theater-Command-IADS-State.

Es wird aktuell nicht automatisch:

- eine SAM-Site suppressed
- eine Site zerstört
- ein Radar abgeschaltet
- ein Sektor degradiert
- ein Skynet-Netzwerk verändert

Dafür muss zuerst ein eigenes IADS-Domain-Modell existieren.

---

## 17. SEAD

SEAD:

    Suppression of Enemy Air Defenses

Perspektivische Funktion:

- Site temporär unterdrücken
- Radaraktivität reduzieren
- Operationsfenster schaffen
- Folgeoperationen ermöglichen

Aktuell:

    Missionstyp vorbereitet
    keine produktive IADS-Wirkung

---

## 18. DEAD

DEAD:

    Destruction of Enemy Air Defenses

Perspektivische Funktion:

- Sites dauerhaft beschädigen
- Sites zerstören
- Netzwerke schwächen
- Verteidigung reduzieren

Aktuell:

    Missionstyp vorbereitet
    keine produktive IADS-Wirkung

---

## 19. IADS_SUPPRESSION

Missionstyp:

    IADS_SUPPRESSION

Perspektivisch für größere Zusammenhänge denkbar:

- mehrere Sites beeinflussen
- Sektor unterdrücken
- Command Node angreifen
- Netzwerk degradieren
- Operationskorridor öffnen

Aktuell:

    Missionstyp vorbereitet
    keine produktive Skynet-Execution

---

## 20. Verhältnis zum AI-Bereich

AICapManager:

    src/ai/tc_ai_cap_manager.lua
    v0.2.1

Bestätigt:

    CAP Zone Candidates: 31
    CAP Zones: 12
    CAP Requests: 12

Ein vollständiger AI Director existiert noch nicht.

Später soll AI IADS-State unter anderem verwenden für:

- Threat Assessment
- CAP-Priorisierung
- SEAD-/DEAD-Bedarf
- sichere Korridore
- Schutz geschwächter Sektoren
- Gegenreaktionen

Aktuell existiert keine produktive AI-/IADS-Kopplung.

---

## 21. Verhältnis zum UI-Bereich

F10Menu:

    src/ui/tc_f10_menu.lua
    v0.2.3

Bestätigt:

    33 Commands

Aktuell existiert kein IADS-F10-Bereich.

Das ist bewusst.

UI wird nicht vor dem zugrunde liegenden Fachsystem gebaut.

Mögliche spätere Statusanzeigen:

- IADS Status
- IADS Sectors
- Active Sites
- Suppressed Sites
- Damaged Sites
- Destroyed Sites
- Threat Summary

Diese Funktionen sind Zukunftsdesign.

---

## 22. Verhältnis zu Persistence

PersistenceSystem:

    src/campaign/tc_persistence_system.lua
    v0.2.6

Bestätigt:

- dirty-aware Background Autosave
- `SAVED`
- `SKIPPED`
- `FAILED`
- Retry
- kontrollierter Import

Verbindlich:

    productiveRestore=false

Ein späterer IADS-State soll grundsätzlich durch Theater Command persistierbar sein.

Nicht vorgesehen:

    komplette Skynet-Runtime blind serialisieren

Ziel:

    Theater-Command-IADS-State speichern
    -> nach Restore validieren
    -> Skynet-Runtime kontrolliert rekonstruieren

Diese Rekonstruktion ist noch nicht implementiert.

---

## 23. Verhältnis zu CTLD

CTLD:

    1.6.1

Am 2026-09-29 wurde für einen isolierten getesteten Aufbau ein vollständiger KI-Truppentransport bestätigt.

Bestätigter Pfad:

    Runtime-Zonenregistrierung
    -> Transporterregistrierung
    -> Pickup
    -> Flug
    -> Off-Airfield-Landung
    -> Dropoff
    -> reale Blue-Bodengruppe

Dieser Test hat aktuell keine direkte IADS-Funktion.

Er ist für das spätere Gesamtsystem relevant, weil Logistics und Transport perspektivisch auch IADS-Versorgung beeinflussen können.

Aktuell gilt:

    CTLD Framework-PoC
    !=
    IADS-Integration

Der derzeitige Projektfokus liegt deshalb zuerst auf CTLD.

---

## 24. Mission-Editor-Voraussetzungen

Für eine spätere reale IADS-Integration werden Mission-Editor-Objekte benötigt.

Mögliche Elemente:

- SAM-Gruppen
- EWR-Gruppen
- Command Center
- Kommunikationsknoten
- statische Infrastruktur
- klar benannte Gruppen
- definierte Testziele
- geeignete Templates

Aktuell existiert keine vollständige produktive Theater-Command-IADS-Struktur in der DEV-Mission.

Mission-Editor-Struktur wird erst aufgebaut, wenn das IADS-Domain-Modell definiert ist.

---

## 25. Naming

Spätere IADS-Objekte benötigen eindeutige, maschinenlesbare Namen.

Mögliche Beispiele:

    IADS_RED_SECTOR_COAST
    IADS_RED_SECTOR_DAMASCUS
    IADS_RED_SITE_SA2_001
    IADS_RED_SITE_SA6_001
    IADS_RED_EWR_001
    IADS_RED_COMMAND_001

Diese Beispiele sind noch keine verbindliche produktive Namensliste.

Vor Umsetzung müssen sie gegen:

    NAMING_CONVENTIONS.md

geprüft werden.

---

## 26. Mögliche spätere Source-Dateien

Mögliche fachliche Module:

    src/iads/tc_iads_system.lua
    src/iads/tc_iads_site_registry.lua
    src/iads/tc_iads_sector_manager.lua
    src/iads/tc_iads_mission_bridge.lua

Diese Namen sind Designoptionen.

Sie sind kein aktueller Implementierungsauftrag.

Es wird keine Datei vorsorglich angelegt.

---

## 27. Risiken der späteren Integration

Wichtige Risiken:

- falsche SAM-/EWR-Namen
- falsche Site-Zuordnung
- falsche Sector-Zuordnung
- falsche Network-Zuordnung
- unkontrollierte Skynet-Nebenwirkungen
- doppelte Runtime-Erzeugung
- falsche Mission Effects
- falsche SEAD-/DEAD-Erkennung
- inkonsistenter Persistence-State
- Restore mit doppelten Framework-Aktionen
- AI arbeitet mit veraltetem IADS-State

Gegenmaßnahmen:

- state-first
- kleine Teststruktur
- klare Registry
- eindeutiges Naming
- Result Validation
- Dirty-Semantik
- Vendor unverändert
- isolierte Runtime-Tests

---

## 28. Kein aktueller IADS-Code-Schritt

Der aktuelle Projektbereich ist:

    Priority 4 – produktive CTLD-Integration vorbereiten

Deshalb wird aktuell nicht parallel:

- `tc_iads_system.lua` angelegt
- komplette Syria-SAM-Struktur gebaut
- Skynet-Netzwerk produktiv initialisiert
- IADS F10 gebaut
- SEAD-/DEAD-Eventsystem implementiert
- AI Director mit IADS verbunden
- produktiver IADS-Restore gebaut

IADS bleibt ein späterer eigenständiger Integrationsbereich.

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
    SAM-/EWR-Gruppen
    Zonen
    Templates
    Tasks
    gespeicherte Missionsstruktur

### Claude Code + DCS-SMS

Version:

    DCS-SMS 0.27.2

Hook:

    me-bridge-0.27.2

Verifiziertes Installationsverzeichnis:

    C:\Tools\dcs-sms

Rolle:

    lokale DCS-Runtime
    Runtime-Lua
    Theater-Command-State
    spätere Skynet-Live-Diagnose
    Logs
    Runtime-Regressionen

Aus dem bestätigten Stand wird kein exakter DCS-SMS-Executable-Pfad abgeleitet.

### DCS

    autoritativer Runtime-Verhaltensbeweis

### GitHub

    Source of Truth

---

## 30. Aktueller Abschlussstand

Stand:

    2026-09-29

Skynet IADS:

    3.3.0
    Vendor geladen
    Loader erkennt Framework
    Vendor unverändert

Eigener IADS-Bereich:

    vorbereitet
    noch kein produktives Lua-Modul

MissionGenerator:

    v0.2.3
    SEAD vorbereitet
    DEAD vorbereitet
    IADS_SUPPRESSION vorbereitet

Mission-Record-Loss:

    widerlegt

Priority 3:

    abgeschlossen

Produktiver Restore:

    deaktiviert

Aktueller Projektbereich:

    Priority 4 – produktive CTLD-Integration vorbereiten

Aktueller Übergang:

    stabiler state-first Kampagnenkern
    +
    vorbereitete IADS-Mission-Intents
    +
    bestätigter Skynet-Vendor
    +
    abgeschlossene Dirty-Coverage
    ->
    zunächst produktive CTLD-Integration
    ->
    später kontrollierte IADS-Integration
