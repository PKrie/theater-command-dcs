# IADS System

## Verbindlicher Stand — 2026-09-29

Diese Datei beschreibt den geplanten IADS-Bereich von **Theater Command DCS**.

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

Skynet IADS:

    3.3.0
    geladen
    vom Loader erkannt
    Vendor unverändert

Eigenes produktives Theater-Command-IADS-System:

    noch nicht implementiert

---

## 1. Zweck des IADS-Systems

IADS steht für:

    Integrated Air Defense System

Das spätere Theater-Command-IADS-System soll Luftverteidigung nicht nur als statische Sammlung von Mission-Editor-SAM-Gruppen behandeln.

IADS soll langfristig ein dynamischer Kampagnenfaktor werden.

Perspektivische Auswirkungen:

- SEAD
- DEAD
- IADS_SUPPRESSION
- MissionGenerator
- AI Director
- CAP
- Missionsrisiko
- sichere Luftkorridore
- Airbase-Verteidigung
- Capture-Vorbereitung
- Logistics
- Repair
- Red-Verteidigungsfähigkeit
- Persistence

Aktuell ist diese Kampagnenschicht noch nicht produktiv implementiert.

---

## 2. Architekturprinzip

Auch für IADS gilt:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis / Source of Truth
    DCS Runtime = autoritativer Verhaltensbeweis

Zusätzlich:

    Theater Command = Campaign Logic / State Owner
    Skynet IADS = Execution Layer

Skynet soll die technische DCS-IADS-Funktion ausführen.

Theater Command soll später verwalten:

- welche Sites existieren
- welchem Owner sie gehören
- welchen Status sie haben
- welche Zonen sie schützen
- welchen Sektoren sie zugeordnet sind
- wie Mission Effects wirken
- wie Logistics sie beeinflusst
- wie AI auf sie reagiert
- welche Zustände persistiert werden

Framework-Runtime-State soll nicht zum alleinigen Kampagnenstate werden.

---

## 3. Aktueller technischer Stand

Vendor:

    vendor/skynet-iads/SkynetIADS.lua

Version:

    3.3.0

Status:

    geladen
    erkannt
    noch nicht produktiv durch Theater Command gesteuert

Eigener IADS-Bereich:

    src/iads/

Aktuell vorhanden:

    src/iads/README.md

Noch nicht produktiv vorhanden:

    eigenes Theater-Command-IADS-Lua-Modul

Aktuell bestätigt:

- Skynet IADS wird geladen.
- Loader erkennt Skynet IADS.
- kein produktives Theater-Command-Skynet-Netzwerk wird initialisiert.
- keine produktive Site Registry existiert.
- keine Network Registry existiert.
- keine Sector Registry existiert.
- keine Theater-Command-IADS-Mission-Effect-Verarbeitung existiert.
- keine produktive IADS-Capture-Kopplung existiert.
- keine produktive IADS-AI-Kopplung existiert.
- kein IADS-F10-Menü existiert.
- kein produktiver IADS-Restore existiert.

---

## 4. Aktueller Gesamtprojektstand

Aktuelle Versionen:

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | Background Persistence bestanden; `productiveRestore=false` |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.1` | Read-Neutrality bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.1` | Read-Neutrality bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | bestanden |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.1` | Read-Neutrality bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` | geladen; keine produktive TC-IADS-Integration |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` | KI-Truppentransport-PoC für getesteten Aufbau bestanden |

Priority 3 wurde am:

    2026-09-21

im dokumentierten Umfang abgeschlossen.

Aktueller Projektbereich:

    Priority 4 – produktive CTLD-Integration vorbereiten

IADS ist aktuell nicht der nächste Entwicklungsbereich.

---

## 5. Bestätigte Kampagnengrundlage

Aktuell bestätigt:

    Syria airbase-like objects: 225
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
    F10 Commands: 33

Diese Grundlage kann später vom IADS-System verwendet werden.

Das IADS-System selbst nutzt diese Daten aktuell noch nicht produktiv.

---

## 6. Warum IADS noch nicht produktiv ist

Die frühere state-first Grundlage ist inzwischen weitgehend vorhanden.

Nicht mehr offene Grundblocker sind:

- Mission Records
- Mission Activation
- Mission Completion
- Mission Failure
- Capture Pressure
- Capture Progress
- Capture Ready
- Capture Apply
- F10 Capture-/Pressure-Sichtbarkeit
- Background Persistence
- Priority-3-Dirty-Coverage im dokumentierten Umfang

IADS bleibt dennoch bewusst eine spätere Phase.

Noch erforderlich sind insbesondere:

- eigenes IADS-Domain-Modell
- Site Registry
- Network Registry
- Sector Registry
- Mission-Editor-SAM-/EWR-Struktur
- klarer Skynet-Lifecycle
- Mission Effects für IADS
- Event-Auswertung für SEAD/DEAD
- Debug-/Teststrategie
- Persistence-/Restore-Grenze
- Result Validation
- spätere AI-Director-Kopplung

Aktuelle Entscheidung:

    IADS wird nicht parallel zur laufenden Priority-4-CTLD-Integration begonnen.

---

## 7. Rolle von Skynet IADS

Skynet IADS ist das externe Vendor-Framework für reale DCS-IADS-Funktionalität.

Perspektivische technische Aufgaben:

- SAM-Netzwerke
- EWR-Anbindung
- Command Center
- Radar-Emission-Management
- SAM-Aktivierung
- SAM-Deaktivierung
- Netzwerkkoordination
- Reaktion auf Bedrohungen
- Unterstützung dynamischer SEAD-/DEAD-Szenarien

Theater Command soll darüber eine eigene Kampagnenschicht legen.

Trennung:

    Skynet
    -> technische DCS-IADS-Ausführung

    Theater Command
    -> fachlicher IADS-State
    -> Campaign Effects
    -> Persistence
    -> Mission-/AI-Kopplung

Vendor-Regel:

    vendor/skynet-iads/SkynetIADS.lua wird nicht verändert.

---

## 8. Core-IADS-State

`src/core/tc_state.lua` enthält bereits einen IADS-Platzhalter.

Aktuelle Default-Struktur:

    IADS = {
        enabled = false,
        networks = {},
        sectors = {},
        sites = {},
        status = unknownStatus
    }

Dieser State bedeutet noch nicht:

- produktives IADS
- aktive Skynet-Netzwerke
- aktive Sites
- aktive Sektoren
- laufende Radarlogik
- funktionierende SEAD-/DEAD-Wirkungen

Er ist lediglich die vorhandene Core-Struktur für eine spätere IADS-Domain.

---

## 9. Späteres IADS-Domain-Modell

Perspektivisch können unter anderem benötigt werden:

    State.IADS.networks
    State.IADS.sectors
    State.IADS.sites

Mögliche Site-Daten:

- siteId
- name
- type
- coalition
- owner
- status
- linkedZone
- linkedBase
- position
- sector
- network
- radarState
- ammoState
- damageState
- suppressionState
- repairState
- lastAttack
- lastEffect

Mögliche Status:

- ACTIVE
- LIMITED
- SUPPRESSED
- DAMAGED
- DESTROYED
- REPAIRING
- OFFLINE
- UNKNOWN

Diese Felder sind Zukunftsdesign.

Sie sind nicht als bereits implementierter IADS-State zu verstehen.

---

## 10. Verhältnis zu Airbase Scanner

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

IADS soll später Airbase-Daten verwenden können, um unter anderem:

- strategische Basen zu schützen
- SAM-Schwerpunkte zu bestimmen
- EWR-Abdeckung aufzubauen
- SEAD-/DEAD-Ziele mit strategischen Räumen zu verbinden
- Airbase-Verteidigung dynamisch zu bewerten

Aktuell besteht keine produktive AirbaseScanner-IADS-Kopplung.

---

## 11. Verhältnis zu ZoneFactory

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

Das spätere IADS-System soll bevorzugt auf der Theater-Command-Zonenstruktur arbeiten.

Mögliche Beziehungen:

    IADS Site
    -> Zone

    IADS Sector
    -> mehrere Zonen

    EWR
    -> Network / Sector

    SAM
    -> Site / Network / Zone

IADS soll nicht ungefiltert auf allen 225 Airbase-like Objects aufbauen.

---

## 12. Verhältnis zu CaptureSystem

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

Aktuelle bestätigte Kette:

    Mission Completion
    -> Capture Pressure
    -> Capture Progress
    -> Capture Ready
    -> Capture Apply
    -> Ownership

Mission Failure:

    kein Capture Pressure

IADS ist aktuell nicht mit Capture gekoppelt.

Perspektivische Wirkungen könnten sein:

- aktive IADS-Abdeckung erhöht Operationsrisiko.
- erfolgreiche SEAD bereitet Folgeoperationen vor.
- DEAD schwächt Red-Verteidigung.
- IADS-Verlust kann Capture-Vorbereitung beeinflussen.
- Capture einer Zone kann IADS-Zuordnung verändern.

Diese Wirkungen sind noch nicht implementiert.

---

## 13. Verhältnis zu MissionGenerator

MissionGenerator:

    src/missions/tc_mission_generator.lua
    v0.2.3

Bestätigt:

    Mission Candidates: 78
    Mission Records: 10

Relevante Missionstypen im Source:

    SEAD
    DEAD
    IADS_SUPPRESSION
    STRIKE
    AIRBASE_ATTACK
    RECON

MissionGenerator bereitet unter anderem vor:

- Objectives
- Briefings
- Progress
- Activation Metadata
- Execution Plan
- Mission Effects
- reservierte Framework Hooks

Der Source beschreibt ausdrücklich:

    prepare mission outcome effects for Capture, Logistics, AI and IADS
    keep all execution hooks reserved until real framework integration exists

Damit gilt:

    IADS-nahe Mission Intent ist vorbereitet.

Nicht bestätigt ist:

    reale Skynet-IADS-Wirkung

MissionGenerator ruft Skynet aktuell nicht produktiv auf.

---

## 14. Mission-Record-Diagnose

Der frühere Verdacht eines Mission-Record-Verlusts wurde am:

    2026-09-12

widerlegt.

Mission Collections sind String-keyed Lua-Dictionaries.

Deshalb ist:

    #table

kein autoritativer Count.

Korrekt:

    pairs()

beziehungsweise pairs-basierte Zählung.

MissionGenerator verliert keine bestätigten Mission Records.

Diese frühere Fehldiagnose ist kein IADS-Blocker mehr.

---

## 15. Verhältnis zu AICapManager

AICapManager:

    src/ai/tc_ai_cap_manager.lua
    v0.2.1

Bestätigt:

    CAP-Zonen-Kandidaten: 31
    CAP-Zonen: 12
    CAP Requests: 12

Priority-3-Ergebnis:

    Read-Neutrality bestanden

Aktuell:

- CAP-State vorhanden.
- keine realen MOOSE-CAP-Flüge.
- keine IADS-CAP-Kopplung.

Perspektivisch könnte IADS CAP beeinflussen durch:

- Bedrohungsbewertung
- sichere Korridore
- Red Defensive CAP
- Schutz geschwächter IADS-Sektoren
- Blue CAP nach erfolgreichem SEAD
- Escort-/TARCAP-Bedarf

Diese Verknüpfung existiert noch nicht.

---

## 16. Verhältnis zum AI Director

Der vollständige AI Director ist noch nicht implementiert.

Perspektivisch soll er IADS berücksichtigen für:

- Threat Assessment
- Operationsplanung
- SEAD-/DEAD-Priorisierung
- CAP-Priorisierung
- Schutz kritischer Sites
- Gegenreaktionen
- Missionspakete
- Logistics
- Ground Operations

Aktuell existiert keine:

    AI Director
    -> IADS

Kette.

Der AI Director ist ebenfalls nicht der aktuelle nächste Projektbereich.

---

## 17. Verhältnis zu LogisticsDelivery

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

Perspektivische IADS-/Logistics-Beziehungen:

- SAM-Sites benötigen Ammo.
- Sites benötigen Repair.
- beschädigte Radare benötigen Engineering.
- Logistics beeinflusst IADS-Wiederherstellung.
- IADS schützt Logistics Hubs.
- IADS bedroht gegnerische Transportkorridore.

Aktuell besteht keine produktive IADS-/Logistics-Kopplung.

---

## 18. Verhältnis zu FobSystem

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

Perspektivisch können FOBs Einfluss haben auf:

- SEAD-Reichweite
- Helikopteroperationen
- Forward Logistics
- Radar-/IADS-Unterstützung
- Operationskorridore

Aktuell sind die FOBs state-only.

Keine reale IADS-FOB-Kopplung existiert.

---

## 19. Verhältnis zu CTLD

CTLD:

    1.6.1

ist ein späterer Execution Layer für Transport und Logistics.

Am:

    2026-09-29

wurde für den getesteten Aufbau ein isolierter vollständiger KI-Truppentransport praktisch bestätigt:

    automatischer Pickup
    -> Transport
    -> Off-Airfield-Landung
    -> automatischer Dropoff
    -> reale Blue-Bodengruppe

Dieser Test hat aktuell keine direkte IADS-Funktion.

Er ist für das spätere Gesamtsystem dennoch relevant, weil Logistics und AI später auch IADS-Sites beziehungsweise deren Versorgung beeinflussen können.

Wichtig:

    CTLD-Framework-PoC
    !=
    produktive IADS-Integration

Aktuell ist Priority 4 auf die produktive CTLD-Integrationsarchitektur ausgerichtet.

---

## 20. IADS Mission Effects

Perspektivische IADS-Effects können unter anderem sein:

- suppressSite
- damageSite
- destroySite
- disableRadar
- reduceSectorReadiness
- degradeNetwork
- revealSite
- repairSite
- restoreSector
- increaseAlert

MissionGenerator besitzt bereits vorbereitete Mission-Effect-Strukturen.

Aktuell gilt jedoch:

    Mission Completion verändert keinen produktiven IADS-State.

Insbesondere wird aktuell nicht automatisch:

- eine Site suppressed
- ein Radar deaktiviert
- ein Network degradiert
- ein Sektor verändert
- eine Skynet-Site umkonfiguriert

Die reale IADS-Effect-Verarbeitung benötigt zuerst ein eigenes IADS-Domain-Modul.

---

## 21. SEAD

SEAD bedeutet:

    Suppression of Enemy Air Defenses

Perspektivisches Ziel:

- SAM-/Radaraktivität temporär reduzieren
- sichere Zeitfenster erzeugen
- Folgeoperationen vorbereiten
- Korridore öffnen

Aktuell:

    Missionstyp vorhanden
    keine produktive IADS-Wirkung

---

## 22. DEAD

DEAD bedeutet:

    Destruction of Enemy Air Defenses

Perspektivisches Ziel:

- SAM-Sites dauerhaft beschädigen oder zerstören
- Radarverbünde schwächen
- IADS-Sektoren nachhaltig degradieren

Aktuell:

    Missionstyp vorhanden
    keine produktive IADS-Wirkung

---

## 23. IADS_SUPPRESSION

`IADS_SUPPRESSION` ist als Missionstyp im MissionGenerator vorhanden.

Perspektivisch könnte er einen größeren IADS-Zusammenhang betreffen als eine einzelne Site.

Beispiele:

- Sektor unterdrücken
- Radarverbund schwächen
- Command Node angreifen
- mehrere Sites beeinflussen
- Operationskorridor öffnen

Aktuell:

    Missionstyp vorhanden
    keine produktive Skynet-/IADS-Ausführung

---

## 24. F10 und IADS

F10Menu:

    v0.2.3

Bestätigt:

    33 Commands

Aktuell existiert kein IADS-spezifisches F10-Menü.

Später mögliche Funktionen:

- Show IADS Status
- Show IADS Sectors
- Show Active Sites
- Show Suppressed Sites
- Show Damaged Sites
- Show Destroyed Sites
- Show Threat Summary
- Show SEAD Targets

Debug-Funktionen könnten später gezielt ergänzt werden.

Sie werden nicht vorgezogen, solange noch kein produktiver IADS-Domain-State existiert.

---

## 25. IADS und Persistence

PersistenceSystem:

    src/campaign/tc_persistence_system.lua
    v0.2.6

Der Campaign-State enthält bereits eine IADS-Sektion.

`State.IADS` wird deshalb grundsätzlich im Snapshot berücksichtigt.

Das bedeutet aktuell jedoch nur:

    Core-IADS-Platzhalter kann serialisiert werden.

Es bedeutet nicht:

    produktive IADS-Persistence ist vollständig implementiert.

Noch nicht vorhanden:

- produktiver Site-State
- produktiver Sector-State
- produktiver Network-State
- IADS-Event-State
- Skynet-Rekonstruktion
- produktiver IADS-Restore

Verbindlich:

    productiveRestore=false

---

## 26. Persistence-Grenze

Für das spätere IADS-System soll gelten:

    Theater-Command-IADS-State wird persistiert.

Nicht vorgesehen ist:

    komplette Skynet-Runtime-Objekte blind serialisieren.

Späterer Restore soll vielmehr:

    gespeicherten TC-IADS-State lesen
    -> validieren
    -> Theater-Command-State restaurieren
    -> Skynet-Runtime kontrolliert rekonstruieren

Dafür müssen Lifecycle und Reihenfolge noch definiert werden.

---

## 27. Mission-Editor-Voraussetzungen

Für echte IADS-Integration werden später reale DCS-Elemente benötigt.

Mögliche Elemente:

- SAM-Gruppen
- EWR-Gruppen
- Command Center
- Kommunikationsknoten
- statische Infrastruktur
- geeignete Templates
- benannte Gruppen
- benannte Zonen
- SEAD-/DEAD-Testziele

Aktuell existiert in der DEV-Mission keine vollständige produktive Theater-Command-IADS-Struktur.

Vor ihrer Anlage muss zuerst klar sein, welches eigene IADS-Domain-Modell diese Elemente verwaltet.

---

## 28. Naming

Spätere IADS-Namen müssen eindeutig und maschinenlesbar sein.

Beispielhafte, noch nicht verbindliche Konzepte:

    IADS_RED_SECTOR_COAST
    IADS_RED_SECTOR_DAMASCUS
    IADS_RED_SITE_SA2_001
    IADS_RED_SITE_SA6_001
    IADS_RED_EWR_001
    IADS_RED_COMMAND_001

Diese Namen sind keine bereits festgelegte produktive Namensliste.

Vor Umsetzung müssen sie gegen:

    NAMING_CONVENTIONS.md

geprüft und verbindlich definiert werden.

---

## 29. Geplante eigene IADS-Module

Mögliche fachliche Module könnten später sein:

    src/iads/tc_iads_system.lua
    src/iads/tc_iads_site_registry.lua
    src/iads/tc_iads_sector_manager.lua
    src/iads/tc_iads_mission_bridge.lua

Diese Namen sind derzeit Designideen.

Sie sind kein aktueller Implementierungsauftrag.

Keine dieser Dateien wird allein wegen dieser Dokumentation angelegt.

Vor jeder neuen Datei muss ihre fachliche Verantwortung eindeutig definiert werden.

---

## 30. Erste mögliche IADS-Entwicklungsphase

Wenn IADS später tatsächlich der nächste Projektbereich wird, ist ein state-first Einstieg sinnvoll.

Möglicher erster Umfang:

- eigenes IADS-Modul lädt
- `State.IADS` wird fachlich initialisiert
- Skynet-Verfügbarkeit wird geprüft
- Site-/Network-/Sector-State vorbereitet
- Status wird geloggt
- keine realen Skynet-Aktionen
- keine automatischen SAM-Umschaltungen
- keine echte SEAD-/DEAD-Wirkung

Danach:

    Sichtbarkeit
    -> Tests
    -> Dirty-Semantik
    -> Persistence
    -> isolierte Skynet-Integration

Nicht:

    sofort komplettes Syria-IADS aufbauen

---

## 31. Risiken

Wichtige spätere IADS-Risiken:

- fehlerhafte Gruppennamen
- falsche Skynet-Konfiguration
- falsche Site-Zuordnung
- falsche Network-Zuordnung
- falsche Sector-Zuordnung
- unkontrollierte Framework-Nebenwirkungen
- unklare Mission-Effect-Zuordnung
- fehlerhafte SEAD-/DEAD-Event-Erkennung
- doppelte State-Anwendung
- inkonsistente Persistence
- Restore mit doppelten Skynet-Aktionen
- AI trifft Entscheidungen auf veraltetem IADS-State
- Logistics und IADS laufen auseinander

Gegenmaßnahmen:

- state-first
- fachliche Registry
- eindeutiges Naming
- kleine Testnetze
- eine Site pro erstem Runtime-Test
- klare Result Validation
- Dirty-Semantik prüfen
- Vendor unverändert lassen
- reale DCS-Runtime als Verhaltensbeweis

---

## 32. Entwicklungswerkzeuge

Für spätere IADS-Arbeit gilt die aktuelle Werkzeugtrennung.

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
- SAM-/EWR-Gruppen
- Zonen
- Templates
- Tasks
- Mission-Editor-Struktur
- gespeicherten Missionsaudit

### Claude Code + DCS-SMS

DCS-SMS:

    0.27.2

Hook:

    me-bridge-0.27.2

Verifiziertes Installationsverzeichnis:

    C:\Tools\dcs-sms

Bevorzugt für:

- Runtime-Lua
- Skynet-Live-State
- Theater-Command-IADS-State
- Gruppen-/Unit-State
- Logs
- Runtime-Regressionen

Diese Werkzeuge sind Entwicklungsinfrastruktur.

Sie sind keine Runtime-Abhängigkeit der späteren Kampagne.

---

## 33. Aktuelle Akzeptanzkriterien der IADS-Basis

Bestanden:

- Skynet IADS `3.3.0` wird geladen.
- Loader erkennt Skynet.
- Vendor bleibt unverändert.
- `State.IADS` Core-Platzhalter existiert.
- IADS-State ist Teil der Campaign-State-Struktur.
- MissionGenerator kennt `SEAD`.
- MissionGenerator kennt `DEAD`.
- MissionGenerator kennt `IADS_SUPPRESSION`.
- MissionGenerator bereitet Framework Hooks state-only vor.
- keine ungewollte produktive Skynet-Ausführung findet statt.

Noch offen:

- eigenes IADS-Domain-Modul
- Site Registry
- Network Registry
- Sector Registry
- Mission-Editor-IADS-Struktur
- IADS F10
- IADS Debug
- reale Skynet-Anbindung
- SEAD Effect
- DEAD Effect
- IADS_SUPPRESSION Effect
- Logistics-IADS-Kopplung
- AI-IADS-Kopplung
- Capture-IADS-Kopplung
- produktiver IADS-Restore
- Multiplayer

---

## 34. Was aktuell nicht begonnen wird

Aktuell wird nicht:

- `tc_iads_system.lua` angelegt
- komplette Syria-SAM-Struktur gebaut
- Skynet-Netzwerk produktiv initialisiert
- AI Director mit IADS gekoppelt
- IADS F10 gebaut
- SEAD-/DEAD-Events automatisiert
- IADS Restore aktiviert

Grund:

    Der aktuelle Projektbereich ist Priority 4 – produktive CTLD-Integration vorbereiten.

IADS bleibt eine spätere, eigenständige Integrationsphase.

---

## 35. Aktueller nächster Projektschritt

Der nächste Projektbereich ist nicht IADS.

Aktuell:

    Priority 4 – produktive CTLD-Integration vorbereiten

Dafür wird zuerst die Theater-Command-CTLD-Integrationsgrenze festgelegt.

Zu klären sind unter anderem:

- fachliche Zuständigkeit
- Zonenregistrierung
- Transporterregistrierung
- Transporter-Lifecycle
- Auftragserzeugung
- Result Validation
- LogisticsDelivery-Rückkopplung
- FobSystem-Rückkopplung
- Dirty-Semantik
- Persistence-Grenze
- `RepackCommandsPath`

IADS wird nicht parallel als neues Großsystem geöffnet.

---

## 36. Aktueller Status

Stand:

    2026-09-29

IADS:

    vorbereitet
    noch nicht produktiv implementiert

Bestätigt:

    Skynet IADS 3.3.0 geladen.
    Loader erkennt Skynet.
    Vendor bleibt unverändert.
    State.IADS Core-Platzhalter vorhanden.
    IADS-Sektion ist Teil des Campaign-State.
    MissionGenerator v0.2.3 kennt IADS-nahe Missionstypen.
    MissionGenerator besitzt state-only Framework-Vorbereitung.
    Mission-Record-Loss-Verdacht ist widerlegt.
    Priority 3 ist abgeschlossen.
    LogisticsDelivery steht auf v0.2.1.
    FobSystem steht auf v0.2.1.
    AICapManager steht auf v0.2.1.
    PersistenceSystem steht auf v0.2.6.
    productiveRestore=false.
    CTLD-KI-Truppentransport-PoC ist für den getesteten Aufbau bestanden.

Noch nicht vorhanden:

    produktives Theater-Command-IADS-System
    produktive Skynet-Netzwerke
    Site Registry
    Network Registry
    Sector Registry
    reale IADS Mission Effects
    IADS F10
    IADS Debug
    AI-IADS-Kopplung
    Logistics-IADS-Kopplung
    Capture-IADS-Kopplung
    produktiver IADS-Restore

Aktueller Übergang:

    stabiler state-first Kampagnenkern
    +
    abgeschlossene Priority-3-Dirty-Coverage
    +
    Framework-Grundlagen
    ->
    kontrollierte Framework-Integration

Aktuell zuerst:

    CTLD

IADS folgt später als eigener Integrationsbereich.
