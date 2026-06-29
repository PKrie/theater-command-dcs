# IADS System

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

Aktuell ist das IADS-System noch nicht produktiv implementiert.

Skynet IADS ist als Vendor geladen, aber noch nicht über eine eigene Theater-Command-IADS-Schicht angebunden.

---

## 2. Aktueller technischer Stand

Stand:

    2026-06-29

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
- MissionGenerator reserviert Skynet-Hooks.
- MissionGenerator erzeugt Missionstyp `IADS_SUPPRESSION`.
- SEAD/DEAD/IADS_SUPPRESSION sind als Missionstypen vorbereitet.
- Es gibt noch keine produktive Theater-Command-IADS-Kampagnenlogik.
- Es werden noch keine Skynet-IADS-Sites durch Theater Command initialisiert.
- Es gibt noch keine IADS-Persistenz.
- Es gibt noch keine IADS-F10-Anzeige.

---

## 3. Aktueller getesteter Gesamtstand

Der aktuelle state-first Runtime-Stand ist bestanden.

Bestätigte Systeme:

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

Aktuelle bestätigte Werte:

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
    F10 Commands: 26
    CAP Requests: 12

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

Gründe:

- Airbase-/Zonen-State musste zuerst stabil sein.
- Capture-Pressure und Capture-Progress mussten zuerst vorbereitet werden.
- MissionGenerator musste zuerst Mission Records und Hooks vorbereiten.
- F10Menu musste zuerst als Spieler-/Testoberfläche funktionieren.
- IADS erzeugt komplexe Nebenwirkungen im DCS-Luftraum.
- SEAD/DEAD-Wirkung muss später sauber messbar sein.
- IADS-State muss vor echter Wirkung sichtbar und debugbar sein.
- Missionseffekte sind noch nicht produktiv an IADS gekoppelt.
- Persistenz ist noch nicht produktiv getestet.

Aktuelle Entscheidung:

    Skynet bleibt geladen und vorbereitet.
    Theater-Command-IADS wird erst nach weiterer UI-/Debug- und MissionEffect-Grundlage produktiv begonnen.

---

## 7. Geplante IADS-Module

Geplante eigene Module:

    src/iads/tc_iads_system.lua
    src/iads/tc_iads_network.lua
    src/iads/tc_iads_sector_manager.lua
    src/iads/tc_iads_site_registry.lua
    src/iads/tc_iads_mission_bridge.lua

Diese Namen sind noch nicht final.

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

Das spätere IADS-System soll eigenen State erzeugen.

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
    appliedMissionEffects: 0
    ready: 0
    contested: 0

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

    mission candidates: 69
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 30

Aktuelle relevante Missionstypen:

- `SEAD`
- `DEAD`
- `IADS_SUPPRESSION`
- `STRIKE`
- `AIRBASE_ATTACK`
- `RECON`

MissionGenerator v0.2.2 erzeugt Mission Records mit:

- Objective
- Briefing
- Progress
- Activation Metadata
- Execution Plan
- Effects
- reserved MOOSE Hook
- reserved CTLD Hook
- reserved Skynet Hook

Bedeutung:

    IADS-bezogene Missionen sind fachlich vorbereitet.
    Skynet-Hooks sind reserviert.
    Es wird aber noch keine echte IADS-Wirkung ausgelöst.

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

    AICapManager ist state-only.
    IADS beeinflusst CAP noch nicht.

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
    IADS ist noch nicht angebunden.

---

## 16. IADS und F10

F10Menu ist aktuell aktiv.

F10Menu v0.2.0 kann aktuell:

- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Mission Details anzeigen
- Missionen aktivieren
- Kampagnenstatus anzeigen
- Logistics Status anzeigen
- FOB Status anzeigen
- AI CAP Status anzeigen

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

Aktuell nächster UI-Schritt:

    Capture-/Pressure-Status anzeigen.

Grund:

    Capture-Pressure und Capture-Progress sind bereits vorhanden.
    Sie müssen sichtbar werden, bevor IADS sinnvoll in Mission Effects und AI eingebunden wird.

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

    MissionGenerator v0.2.2 enthält Effects und reserved Skynet Hooks.
    Mission Effects werden noch nicht produktiv auf IADS angewendet.

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

IADS-Zustand muss später persistent werden.

Zu speichern:

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

Aktueller Stand:

    PersistenceSystem-Grundstruktur existiert.
    Produktiver DCS-Dateischreibtest ist noch offen.
    IADS-State ist noch nicht implementiert.

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
- IADS-Zustand persistieren
- Red-IADS-Reparatur modellieren
- AI Director mit IADS koppeln
- F10-IADS-Menü sofort bauen

Grund:

    Zuerst muss die bestehende state-first Runtime sichtbar und testbar bleiben.
    Der nächste kleine Schritt liegt bei Capture-/Pressure-Sichtbarkeit, nicht bei IADS.

---

## 25. Aktuelle Akzeptanzkriterien für IADS-Basis

Aktuell bestanden:

- Skynet IADS wird geladen.
- Loader erkennt Skynet IADS.
- kein Skynet-bezogener Theater-Command-Startabbruch.
- MissionGenerator kennt IADS-nahe Missionstypen.
- MissionGenerator reserviert Skynet Hooks.
- keine echten Skynet-Aktionen werden ausgelöst.

Noch offen:

- eigenes `tc_iads_system.lua`
- IADS-State
- IADS-Site-Registry
- IADS-Sector-Registry
- IADS-F10-Status
- IADS-Debug-Report
- IADS-Mission Effects
- Skynet-Produktivanbindung
- IADS-Persistenz

---

## 26. Nächster sinnvoller Schritt

Der nächste sinnvolle Schritt liegt nicht direkt beim IADS-System.

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

## 27. Aktueller Status

IADS ist aktuell vorbereitet, aber noch nicht produktiv implementiert.

Aktuelle Fähigkeit:

- Skynet IADS wird geladen.
- Loader erkennt Skynet IADS.
- MissionGenerator reserviert Skynet Hooks.
- SEAD/DEAD/IADS_SUPPRESSION sind konzeptionell und im MissionGenerator vorbereitet.
- Es gibt noch keine echte IADS-Kampagnenlogik.

Nächster notwendiger Zwischenschritt im Gesamtprojekt:

    Capture-/Pressure-Sichtbarkeit im F10-Menü.

Danach sinnvoll:

    Mission completed/failed testbar machen.
    Mission Effects kontrolliert testen.
    Erst später IADS-System state-only beginnen.
