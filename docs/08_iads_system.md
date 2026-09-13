# IADS System

## Verbindliches Update — 2026-09-12

Skynet IADS ist geladen und vom Loader erkannt. Theater Command besitzt weiterhin kein produktives eigenes IADS-System: kein Skynet-Netzwerk wird durch Theater Command initialisiert, und kein produktiver IADS-Kampagnen-State wird durch ein eigenes IADS-Modul gepflegt. MissionGenerator `v0.2.3` ist state-first funktionsfähig; 10 Mission Records sind vorhanden, der frühere Record-Loss-Verdacht ist widerlegt. Mission Completion, Mission Failure und Capture Ready Apply sind bestanden. Der Offline Embedded Resource Audit ist abgeschlossen: 13/13 relevante aktive Theater-Command-Ressourcen waren `EXACT_MATCH`, keine aktive Embedded-Runtime-Drift. PersistenceSystem `v0.2.6` ist aktiv; `productiveRestore=false`. Priority 3 bleibt offen; der nächste technische Schritt ist NICHT IADS, sondern der READ-ONLY Dirty-Coverage-Audit von `src/logistics/tc_logistics_delivery.lua`. Nicht mehr aktuell: ein reproduzierbarer Mission-Record-Loss, der Embedded Audit als offener nächster Schritt, sowie Capture-/Pressure-F10-Sichtbarkeit als nächster Schritt — das ist abgeschlossen. Ältere Status- und Versionsangaben sind historische Snapshots.

Diese Datei beschreibt das geplante IADS-System von **Theater Command DCS**.

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## 1. Zweck des IADS-Systems

Das IADS-System soll langfristig die gegnerische Luftverteidigung als dynamischen Kampagnenfaktor abbilden.

IADS steht für:

    Integrated Air Defense System

Im Projekt soll das IADS-System nicht nur eine statische Sammlung von SAM-Stellungen sein.

Es soll später Einfluss haben auf:

- SEAD-Missionen
- DEAD-Missionen
- IADS_SUPPRESSION-Missionen
- CAP-Planung
- AI-Director-Entscheidungen
- Missionsrisiko
- sichere Luftkorridore
- Airbase-Angriffe
- Capture-Vorbereitung
- Persistenz
- Red-Verteidigungsfähigkeit

Dies sind überwiegend Designziele.

Aktuell ist das IADS-System noch nicht produktiv implementiert.

Skynet IADS ist als Vendor geladen, aber noch nicht über eine eigene Theater-Command-IADS-Schicht angebunden.

Aktuell produktiv vorhanden ist nur die technische Grundlage:

- Skynet Vendor geladen
- Core-State-Platzhalter (`State.IADS`)
- MissionGenerator-Vorbereitung/Hooks, soweit Source dies bestätigt
- Persistence-Snapshot-Sektion `IADS`

Keine echte IADS-Kampagnenwirkung.

---

## 2. Aktueller technischer Stand

Stand:

    2026-09-12

Vendor-Datei:

    vendor/skynet-iads/SkynetIADS.lua

Status:

    geladen und vom Loader erkannt

Eigener IADS-Ordner:

    src/iads/

Aktueller Stand:

    Ordner vorbereitet
    README vorhanden
    eigenes Theater-Command-IADS-Modul noch nicht implementiert

Geplante spätere Hauptdatei:

    src/iads/tc_iads_system.lua

Aktuell bestätigt:

- Skynet IADS wird im Mission Editor geladen.
- Loader erkennt Skynet IADS.
- keine Theater-Command-Skynet-Site wird initialisiert.
- kein Theater-Command-IADS-Netzwerk aktiv.
- keine echte IADS-Capture-/AI-/Mission-Wirkung.
- kein IADS-F10-Menü.

Nur soweit aktuelle Source dies bestätigt:

- MissionGenerator reserviert Skynet-Hooks (state-only, keine echte Wirkung).
- MissionGenerator erzeugt Missionstyp `IADS_SUPPRESSION` neben `SEAD`/`DEAD` (state-only).

---

## 3. Aktueller getesteter Gesamtstand

Der aktuelle state-first Runtime-Stand ist bestanden.

Bestätigte Systeme:

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | state-first funktional bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | funktional bestanden; Read-Dirty-/Ownership-No-Op-Regressionen bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | Embedded Start, `SAVED`, `SKIPPED`, `FAILED`, Retry und Campaign-Persistence-Regressionen bestanden; `productiveRestore=false` |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | funktional bestanden; Dirty-Coverage nächster Priority-3-Audit |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | funktional bestanden; Dirty-Coverage offen |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | 10 Mission Records; Activation/Completion/Failure/Effects bestanden; Record-Loss widerlegt; Dirty-Coverage offen |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | state-first bestanden; `reactToActiveMissions()`-Sonderfall bewertet; Dirty-Coverage offen |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden; 33 Commands |

Aktuelle bestätigte Werte:

    Syria airbase-like objects: 225
    relevante Kampagnenzonen: 46
    capture-fähige Ziele: 32
    Capture Pressure Records: 32
    Capture Progress Records: 32
    Logistics Hubs: 46
    FOB candidates: 6
    Blue FOBs: 2
    Mission candidates: 78
    Mission Records: 10
    F10 Commands: 33
    CAP Requests: 12

Priority 3 ist **NICHT abgeschlossen**. Bereits geklärt: Capture Getter-/Derived-Dirty, Capture Ownership No-Op, `reactToActiveMissions()`-Sonderfall. Noch systematisch zu prüfen, jeweils einzeln: `tc_logistics_delivery.lua`, `tc_fob_system.lua`, `tc_mission_generator.lua`, `tc_ai_cap_manager.lua`. IADS ist NICHT Teil dieses unmittelbar nächsten Vier-Dateien-Audits, weil noch kein produktives eigenes IADS-Modul existiert.

Bewertung:

    Die Grundlage für spätere IADS-Integration ist vorhanden.
    Das eigentliche IADS-System ist aber noch nicht implementiert.

---

## 4. Designprinzip

Auch für IADS gilt das Theater-Command-Grundprinzip:

    erst State
    dann Sichtbarkeit
    dann Tests
    dann echte Framework-Aktionen

Skynet IADS wird nicht direkt als Architekturordnung verwendet.

Skynet IADS ist ein Framework.

Theater Command soll darüber eine eigene Kampagnenschicht legen.

Diese Kampagnenschicht soll entscheiden:

- welche IADS-Sites existieren
- welchem Besitzer sie gehören
- welchen Status sie haben
- welche Zonen sie schützen
- wie sie Missionen beeinflussen
- wie sie beschädigt oder unterdrückt werden
- wie ihr Zustand persistiert wird
- wie AI und MissionGenerator auf IADS reagieren

---

## 5. Rolle von Skynet IADS

Skynet IADS ist das geplante Framework für echte DCS-IADS-Funktionalität.

Skynet IADS kann später genutzt werden für:

- SAM-Netzwerke
- EWR-Anbindung
- Command Center
- IADS-Sektoren
- SAM-Aktivierung und Deaktivierung
- Radar-Emission-Management
- Reaktion auf SEAD/DEAD
- dynamische Luftverteidigung

Aktueller Stand:

    Skynet IADS ist geladen.
    Theater Command initialisiert noch kein eigenes Skynet-Netzwerk.
    Es gibt noch keine produktiven SAM-/EWR-/Command-Strukturen.

---

## 6. Warum IADS noch nicht produktiv ist

Das IADS-System wird bewusst noch nicht produktiv aufgebaut.

Die früheren Grundlagen-Blocker (MissionGenerator müsse erst Mission Records können, F10 müsse erst funktionieren, Capture-/Pressure-Sichtbarkeit müsse erst hergestellt werden) sind inzwischen vorhanden und kein offener Blocker mehr.

Aktuell relevante Gründe:

- Priority 3 Dirty-Coverage bestehender State-Module ist noch offen.
- produktiver Restore ist noch deaktiviert.
- eigenes IADS-Domain-Modell ist noch nicht implementiert.
- Site-/Network-/Sector-Registry fehlt.
- echte Skynet-Sites sind noch nicht definiert.
- Mission Effects sind noch nicht an IADS gekoppelt.
- DCS-Event-Auswertung für SEAD/DEAD fehlt.
- Mission-Editor-SAM-/EWR-Struktur fehlt.
- IADS-Debug-/Teststrategie muss vor produktiver Skynet-Wirkung stehen.
- Framework-State darf nicht direkt persistiert werden; Theater-Command-State muss maßgeblich sein.

Aktuelle Entscheidung:

    IADS bleibt bewusst später.
    Der nächste Gesamtprojektschritt ist LogisticsDelivery Dirty-Coverage, nicht IADS.

---

## 7. Geplante IADS-Module

Geplante eigene Module:

    src/iads/tc_iads_system.lua
    src/iads/tc_iads_network.lua
    src/iads/tc_iads_sector_manager.lua
    src/iads/tc_iads_site_registry.lua
    src/iads/tc_iads_mission_bridge.lua

Dies ist ein Konzept: Die Namen sind noch nicht final, und keine dieser Dateien ist aktuell implementiert. Keine dieser Dateien wird jetzt angelegt.

Wahrscheinliche erste Datei:

    src/iads/tc_iads_system.lua

Erster sinnvoller Umfang:

- Modul lädt.
- IADS-State wird initialisiert.
- Skynet-Verfügbarkeit wird geprüft.
- IADS-Systemstatus wird geloggt.
- keine echten SAM-Sites werden initialisiert.
- keine echten Skynet-Aktionen werden ausgelöst.
- IADS-State bleibt state-only.
- spätere Site-Registry wird vorbereitet.

---

## 8. IADS State

Im Core-State existiert bereits `State.IADS` als Platzhalter.

Default-Struktur laut `src/core/tc_state.lua`:

    enabled = false
    networks = {}
    sectors = {}
    sites = {}
    status = UNKNOWN

Das ist ein Core-State-Platzhalter. Es bedeutet NICHT:

- produktives IADS-System
- aktive Site Registry
- aktive Networks
- aktive Sectors
- echte Skynet-Synchronisation

Das spätere IADS-System soll darüber hinaus eigenen erweiterten State erzeugen. Die folgenden State-Bereiche und -Felder sind Designideen und aktuell nicht implementiert:

Mögliche State-Bereiche:

    State.IADS
    State.IADS.Sites
    State.IADS.Networks
    State.IADS.Sectors
    State.IADS.Radars
    State.IADS.SamSites
    State.IADS.CommandCenters
    State.IADS.Effects
    State.IADS.Events
    State.IADS.Persistence

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
- range
- sector
- network
- radarState
- ammoState
- damageState
- suppressionState
- lastAttack
- lastSeen
- persistentState

Mögliche Statuswerte:

- ACTIVE
- LIMITED
- SUPPRESSED
- DAMAGED
- DESTROYED
- REPAIRING
- OFFLINE
- UNKNOWN

Aktuell:

    IADS-State ist noch nicht produktiv implementiert.

---

## 9. Verhältnis zu Airbase Scanner

Airbase Scanner liefert die strategische Raumgrundlage.

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

IADS soll später Airbase-Daten nutzen, um:

- rote strategische Basen zu schützen
- IADS-Sektoren um wichtige Airfields zu legen
- SEAD/DEAD-Ziele mit Airbase-Zielen zu verbinden
- IADS-Verluste auf Airbase-Verteidigung wirken zu lassen
- Capture-Operationen vom IADS-Zustand abhängig zu machen

Aktuell:

    IADS nutzt Airbase-Daten noch nicht produktiv.

---

## 10. Verhältnis zu ZoneFactory

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

IADS soll später an Zonen gekoppelt werden.

Mögliche Kopplung:

- IADS-Site schützt Zone
- IADS-Sektor deckt mehrere Zonen ab
- Zone enthält SAM-Site
- Zone enthält EWR
- Zone enthält Command Center
- MissionGenerator erzeugt IADS-Missionen aus Zone-Daten
- CaptureSystem berücksichtigt IADS-Abdeckung

Wichtig:

    IADS soll nicht auf allen 225 DCS-Airbase-like Objects arbeiten.
    IADS soll die 46 relevanten Kampagnenzonen und später manuelle IADS-Zonen nutzen.

---

## 11. Verhältnis zu CaptureSystem

CaptureSystem verwaltet Capture-Eligibility, Capture-Pressure und Capture-Progress.

Aktuelle Werte:

    eligibleBases: 32
    eligibleZones: 32
    pressureRecords: 32
    progressRecords: 32

Initial-/Baseline-Werte (nicht der heutige Gesamtzustand):

    appliedMissionEffects: 0
    ready: 0
    contested: 0

Aktuell bestätigter Capture-Pfad:

    Mission Completion -> Capture Pressure -> Capture Progress -> Capture Ready
    Mission Failure -> kein Capture Pressure
    Capture Ready Apply -> Zone Ownership -> linked Airbase Ownership Sync -> Background Save

IADS ist weiterhin NICHT mit Capture gekoppelt. Keine IADS-Wirkung auf Capture wird behauptet.

IADS soll später Capture beeinflussen.

Mögliche Auswirkungen:

- aktive IADS-Abdeckung erschwert Capture.
- unterdrücktes IADS erleichtert Folgeoperationen.
- zerstörte SAM-Sites erhöhen Capture-Pressure.
- beschädigte IADS-Sektoren senken Red-Verteidigungsfähigkeit.
- SEAD/DEAD-Erfolg kann Capture-Vorbereitung verbessern.
- Red kann bei drohendem Capture IADS verstärken oder verlegen.

Aktuell:

    CaptureSystem erzeugt Pressure und Progress.
    IADS ist noch nicht mit CaptureSystem gekoppelt.
    Mission Effects auf IADS sind noch nicht produktiv.

---

## 12. Verhältnis zu MissionGenerator

MissionGenerator erzeugt Missionen aus dem Kampagnenzustand.

Aktuelle MissionGenerator-Werte:

    mission candidates: 78
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 68

MissionGenerator `v0.2.3`, 10 Mission Records.

Bestätigt:

- Mission Details
- Mission Activation
- Mission Completion
- Mission Failure
- Mission Effects
- Mission Completion -> Capture Pressure
- Mission Failure -> kein Capture Pressure

MissionGenerator bleibt state-first. Keine echten DCS-/Skynet-Spawns.

Aktuelle relevante Missionstypen:

- `SEAD`
- `DEAD`
- `IADS_SUPPRESSION`
- `STRIKE`
- `AIRBASE_ATTACK`
- `RECON`

MissionGenerator `v0.2.3` erzeugt Mission Records mit:

- Objective
- Briefing
- Progress
- Activation Metadata
- Execution Plan
- Effects
- reserved MOOSE Hook
- reserved CTLD Hook
- reserved Skynet Hook

Diese Missionstypen und der reservierte Skynet Hook sind im aktuellen Source bestätigt (`src/missions/tc_mission_generator.lua`).

Bedeutung:

    IADS-bezogene Missionen sind fachlich vorbereitet.
    Skynet-Hooks sind reserviert.
    Diese Hook-/Effect-Vorbereitung bedeutet KEINE echte Skynet-Wirkung. Es wird noch keine echte IADS-Wirkung ausgelöst.
    MissionGenerator entscheidet NICHT direkt über IADS-State, solange kein IADS-System existiert.

Spätere Kopplung:

- MissionGenerator wählt IADS-Sites als Ziele.
- SEAD-Missionen setzen Site auf SUPPRESSED.
- DEAD-Missionen setzen Site auf DAMAGED oder DESTROYED.
- IADS_SUPPRESSION verändert Sektorstatus.
- Mission Effects werden an IADS-System gemeldet.
- IADS-System meldet Auswirkungen an Capture und AI.

---

## 13. Verhältnis zu AICapManager

AICapManager erzeugt CAP-State.

Aktuelle Werte:

    cap zone candidates: 31
    auto-registered CAP zones: 12
    CAP requests: 12
    reactionState: AIR_REACTION_REQUESTED
    threatLevel: HIGH

IADS soll später CAP-Entscheidungen beeinflussen.

Mögliche Zusammenhänge:

- aktive IADS-Sektoren reduzieren Blue-CAP-Freiheit
- geschwächte IADS-Sektoren erhöhen Blue-Operationsmöglichkeiten
- Red-CAP kann IADS-Lücken kompensieren
- Blue-SEAD kann CAP-Korridore öffnen
- CAP-Priorität hängt von IADS-Abdeckung ab
- AI Director priorisiert CAP über gefährdeten IADS-Sektoren

Aktuell:

    AICapManager v0.2.0, state-first, state-only.
    Keine echten CAP-Spawns.
    IADS beeinflusst CAP noch nicht.
    `reactToActiveMissions()` ist nicht produktiv verdrahtet; Sonderfall bewertet; allgemeine Dirty-Coverage bleibt offen.

---

## 14. Verhältnis zu AI Director

Der spätere AI Director soll IADS als wichtigen Faktor nutzen.

AI Director soll später bewerten:

- welche IADS-Sektoren kritisch sind
- welche SAM-Sites verteidigt werden müssen
- wo SEAD-/DEAD-Bedarf besteht
- wo Blue sichere Korridore hat
- wo Red CAP zur IADS-Unterstützung braucht
- wo IADS-Schäden rote Verteidigung schwächen
- wie IADS-Verluste Kampagnenphase und Prioritäten verändern

Aktuell:

    AI Director ist noch nicht implementiert.
    IADS-System ist noch nicht implementiert.
    Beide Systeme werden später gekoppelt.

---

## 15. Verhältnis zu Logistics und FOBs

LogisticsDelivery und FobSystem liefern logistische und operative Vorwärtsstruktur.

Aktuelle Werte:

    Logistics Hubs: 46
    Blue FOBs: 2
    FOB Ercan
    FOB Gecitkale

IADS soll später mit Logistik zusammenhängen.

Mögliche Kopplung:

- SAM-Sites benötigen Supply oder Repair.
- beschädigte IADS-Sites brauchen Logistik zur Wiederherstellung.
- Red Logistics beeinflusst IADS-Reparaturfähigkeit.
- Blue FOBs ermöglichen SEAD/DEAD-Operationen näher am Festland.
- IADS bedroht Logistics- und FOB-Support-Missionen.
- zerstörte IADS öffnet Logistics-Korridore.

Aktuell:

    Logistik ist state-only.
    FOBs sind state-only.
    Logistics beeinflusst IADS nicht produktiv.
    IADS Repair/Supply ist Zukunftsdesign.
    Keine echte IADS-Logistics-Verknüpfung.

---

## 16. IADS und F10

F10Menu ist aktuell aktiv.

F10Menu `v0.2.3` erzeugt 33 Commands und bietet aktuell unter anderem:

- Mission-Status/Details/Activation
- Mission Outcome Controls (Complete/Fail)
- Campaign Status
- Capture Status
- Capture Ready Zones
- Pressure Contested Zones
- Logistics Status
- FOB Status
- AI CAP Status

Aktuell noch nicht vorhanden:

- IADS Status im F10
- IADS Site Report
- IADS Sector Report
- SAM Status
- EWR Status
- IADS Debug View

Spätere F10-IADS-Funktionen:

- Show IADS Status
- Show IADS Sectors
- Show Active SAM Sites
- Show Suppressed SAM Sites
- Show Destroyed SAM Sites
- Show IADS Threat Map
- Show SEAD Targets
- Debug Suppress IADS Site
- Debug Destroy IADS Site

Nicht mehr aktuell: Capture-/Pressure-Status als nächster UI-Schritt — das ist abgeschlossen.

Der nächste technische Schritt ist KEIN UI-Schritt und KEIN IADS-Schritt (siehe Abschnitt 26).

---

## 17. IADS Mission Effects

Mission Effects sollen später IADS-Zustände verändern.

Mögliche Effekte:

- suppressSite
- damageSite
- destroySite
- reduceSectorReadiness
- disableRadar
- degradeNetwork
- revealSite
- repairSite
- restoreSector
- increaseRedAlert
- triggerRedCounteraction

Aktuelle Vorbereitung:

    MissionGenerator v0.2.3 enthält Effects und reserved Skynet Hooks.
    Generische Mission Effects sind state-first praktisch bestätigt; Capture-relevante Effects funktionieren.
    IADS-relevante Effects sind weiterhin NICHT produktiv umgesetzt.
    Mission Completion verändert heute weder Site- noch Radar- noch Network-Status; sie suppresst keine Site, deaktiviert kein Radar, degradiert kein Network und verändert keinen IADS-State.

Späterer Ablauf:

1. Mission wird aktiviert.
2. Mission wird abgeschlossen oder schlägt fehl.
3. MissionGenerator meldet Ergebnis.
4. IADS-System verarbeitet IADS-relevanten Effekt.
5. IADS-State wird aktualisiert.
6. CaptureSystem, AI Director und MissionGenerator nutzen neuen IADS-State.
7. Zustand wird später persistiert.

---

## 18. IADS und Persistenz

`TC.State` enthält bereits eine IADS-Sektion als Core-State-Platzhalter.

PersistenceSystem `v0.2.6` speichert aktuell zehn Snapshot-Sektionen:

    Meta
    Campaign
    World
    Bases
    Zones
    Logistics
    Missions
    AI
    IADS
    Persistence

Damit wird auch `State.IADS` serialisiert.

Aber: `State.IADS` enthält aktuell nur den nicht produktiven/default IADS-State. Es existiert noch kein eigenes IADS-Modul mit produktiver Site-/Network-/Sector-Logik.

Daher wird NICHT behauptet: "produktive IADS-Persistenz ist vollständig implementiert."

Korrekte Abgrenzung:

- Snapshot-Sektion IADS vorhanden und gespeichert
- kein produktiver IADS-Domain-State
- kein produktiver IADS-Restore
- keine Rekonstruktion von Skynet-Objekten
- `productiveRestore=false`

PersistenceSystem `v0.2.6`:

- `SAVED`
- `SKIPPED`
- kontrollierter `FAILED`-Pfad
- Retry
- Read-back
- Compile
- Evaluate
- Validation

Framework-Objekte werden NICHT direkt gespeichert. Später soll eigener Theater-Command-IADS-State rekonstruiert werden — nicht Skynet-Objekte serialisieren.

Zu speichern (spätere, erweiterte IADS-Domain-Daten, Designidee):

- Site-ID
- Site-Name
- Site-Typ
- Besitzer
- Status
- Damage State
- Suppression State
- Radar State
- Ammo State
- Network State
- Sector State
- Linked Zone
- Linked Base
- Last Mission Effect
- Repair Progress
- Event History

Diese erweiterten Felder sind noch nicht implementiert; aktuell existiert nur der `State.IADS`-Platzhalter (siehe oben).

---

## 19. Mission Editor Voraussetzungen

Für echte IADS-Integration werden später Mission-Editor-Elemente benötigt.

Mögliche Elemente:

- rote SAM-Gruppen
- rote EWR-Gruppen
- Command Center
- Power Nodes
- Communications Nodes
- Late-Activation-Templates
- statische Objekte
- benannte Zonen
- Skynet-kompatible Gruppennamen
- Testziele für SEAD/DEAD

Aktuell in der DEV-Mission noch nicht produktiv vorhanden:

- keine produktive IADS-Struktur
- keine aktiven Theater-Command-IADS-Zonen
- keine produktiven SAM-/EWR-Netzwerke
- keine IADS-Templates

Grund:

    IADS-Integration wird erst aufgebaut, wenn State, Missionen, F10 und Debug ausreichend stabil sind.

---

## 20. Naming-Konzept

Spätere IADS-Namen müssen klar und maschinenlesbar sein.

Mögliche Namenskonventionen:

    IADS_RED_SECTOR_COAST
    IADS_RED_SECTOR_DAMASCUS
    IADS_RED_SITE_SA2_001
    IADS_RED_SITE_SA6_001
    IADS_RED_EWR_001
    IADS_RED_COMMAND_001

Diese Namen sind noch nicht final.

Sie müssen später mit `NAMING_CONVENTIONS.md` abgestimmt werden.

---

## 21. SEAD/DEAD Design

SEAD und DEAD sind zentrale Missionstypen für IADS.

SEAD:

    Suppression of Enemy Air Defenses

Ziel:

- Luftverteidigung unterdrücken
- Risiko für Folgeoperationen senken
- Radar- und SAM-Aktivität reduzieren
- temporäre Korridore öffnen

DEAD:

    Destruction of Enemy Air Defenses

Ziel:

- Luftverteidigung dauerhaft zerstören oder schwer beschädigen
- IADS-Sektoren nachhaltig schwächen
- Red-Verteidigungsfähigkeit reduzieren

Aktueller Stand:

    SEAD und DEAD sind als Missionstypen vorhanden.
    echte Skynet-/DCS-Wirkung ist noch nicht aktiv.

---

## 22. IADS_SUPPRESSION Design

`IADS_SUPPRESSION` ist ein übergeordneter Missionstyp.

Mögliche Bedeutung:

- nicht nur einzelne SAM-Site unterdrücken
- ganzen IADS-Sektor schwächen
- Radarverbund stören
- Command-Knoten beeinträchtigen
- Luftkorridor vorbereiten

Aktueller Stand:

    Missionstyp vorhanden.
    MissionGenerator reserviert Skynet-Hooks.
    keine echte IADS-Wirkung.

---

## 23. Risiken

Risiken bei IADS-Integration:

- Skynet-Konfiguration ist empfindlich gegenüber Gruppennamen.
- SAM-/EWR-Struktur kann DCS-Startfehler erzeugen.
- IADS-Wirkung ist schwer zu debuggen.
- SEAD/DEAD-Erfolge müssen sauber aus DCS-Events abgeleitet werden.
- Mission Effects können falsche Sektoren beeinflussen.
- Persistenz kann beschädigte IADS-Zustände falsch laden.
- AI Director kann IADS-Bedrohung falsch gewichten.
- echte IADS-Aktivität kann Missionen zu früh zu schwer machen.
- eigener IADS-State muss sauber von Skynet-Runtime-Objekten getrennt bleiben.
- produktive IADS-Mutationen müssen später Dirty markieren.
- Reads/No-Ops dürfen später keinen unnötigen Dirty erzeugen.
- Restore darf keine Skynet-Hooks verfrüht auslösen.
- Site-/Network-/Sector-Rekonstruktion braucht eine definierte Restore-Reihenfolge.
- DCS-Events für SEAD/DEAD müssen zuverlässig zugeordnet werden.

Da noch kein produktives IADS-Modul existiert, wird derzeit keine konkrete IADS-Dirty-Bugbehauptung aufgestellt.

Gegenmaßnahmen:

- IADS zuerst state-only modellieren.
- keine echten Skynet-Aktionen in erster Theater-Command-IADS-Version.
- klare Logmarker.
- F10-/Debug-Sichtbarkeit.
- kleine Teststruktur statt komplette Syria-IADS.
- einzelne Site testen.
- danach erst Sektoren und Netzwerke ausbauen.

---

## 24. Nicht-Ziele im aktuellen Stand

Aktuell nicht vorgesehen:

- komplette Syria-IADS-Struktur bauen
- echte Skynet-Netzwerke initialisieren
- SAM-Gruppen automatisch spawnen
- SEAD/DEAD-Erfolg automatisch auswerten
- Red-IADS-Reparatur modellieren
- AI Director mit IADS koppeln
- F10-IADS-Menü sofort bauen

Nicht mehr korrekt: "IADS-Zustand persistieren" als komplett fehlend. Die IADS-Snapshot-Sektion wird bereits gespeichert, aber es gibt noch keinen produktiven IADS-Domain-State. Richtig:

- noch keine produktive IADS-Domain-State-Persistenz/Restore-Logik
- kein Wiederaufbau realer Skynet-Strukturen aus Save-State

Grund:

    Zuerst muss die bestehende state-first Runtime sichtbar und testbar bleiben.
    Der nächste Schritt ist Priority-3-Dirty-Coverage (LogisticsDelivery), nicht IADS.

---

## 25. Aktuelle Akzeptanzkriterien für IADS-Basis

Aktuell bestanden:

- Skynet IADS wird geladen.
- Loader erkennt Skynet IADS.
- kein Skynet-bezogener Theater-Command-Startabbruch.
- MissionGenerator kennt IADS-nahe Missionstypen (soweit Source bestätigt).
- MissionGenerator reserviert Skynet Hooks (soweit Source bestätigt).
- keine echten Skynet-Aktionen werden ausgelöst.

Zusätzlich als Projektkontext:

- Mission Completion/Failure/Effects sind state-first bestätigt.
- die Capture-Pipeline ist bestätigt.
- F10 Capture-/Pressure-Sichtbarkeit ist bestätigt.
- der Persistence Snapshot enthält die IADS-Sektion.

Noch offen:

- eigenes IADS-System
- produktiver IADS-State
- Site Registry
- Network-/Sector-Registry
- IADS-F10-Status
- IADS-Debug-Report
- IADS-Mission Effects
- Skynet-Produktivanbindung
- produktiver IADS-Restore/Rebuild

---

## 26. Nächster sinnvoller Schritt

Nicht mehr aktuell: `src/ui/tc_f10_menu.lua` / Capture-/Pressure-Sichtbarkeit als nächster Schritt — das ist abgeschlossen.

Neuer nächster technischer Schritt:

    Priority 3
    READ-ONLY Dirty-Coverage-Audit von src/logistics/tc_logistics_delivery.lua

Keine IADS-Codeänderung. Kein `tc_iads_system.lua` wird jetzt angelegt.

---

## 27. Aktueller Status

IADS ist aktuell vorbereitet, aber noch nicht produktiv implementiert.

Korrekte Zusammenfassung:

- Skynet geladen/erkannt.
- `State.IADS` Core-Platzhalter vorhanden.
- IADS-Snapshot-Sektion wird gespeichert.
- MissionGenerator besitzt IADS-nahe Vorbereitung, nur soweit aktuell bestätigt.
- SEAD/DEAD/IADS_SUPPRESSION sind vorbereitete Missionstypen, keine echte IADS-Wirkung.
- kein eigenes produktives IADS-System.
- keine Site-/Network-/Sector-Registry.
- keine echten Skynet-Sites.
- kein IADS-F10.
- keine IADS-Capture-/AI-/Logistics-Kopplung.
- kein produktiver IADS-Restore.

Mission Completion und Mission Failure sind bereits bestätigt — nicht mehr "erst später testbar".

Nächster Projektschritt:

    LogisticsDelivery Dirty-Coverage READ ONLY.

IADS folgt später, nach stabiler bestehender State-/Persistence-Grundlage (Priority 3).
