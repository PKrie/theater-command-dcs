# src/iads/README.md

Diese Datei beschreibt den IADS-Bereich von **Theater Command DCS**.

Der IADS-Bereich enthält die eigene Theater-Command-Schicht für Integrated Air Defense Systems und die spätere Anbindung an Skynet IADS.

---

## 1. Zweck des IADS-Bereichs

`src/iads/` ist für die Theater-Command-Kampagnenlogik rund um Luftverteidigung zuständig.

IADS steht für:

    Integrated Air Defense System

Langfristig soll dieser Bereich ermöglichen, dass Luftverteidigung nicht nur statisch im Mission Editor vorhanden ist, sondern als dynamischer Kampagnenfaktor wirkt.

IADS soll später Einfluss haben auf:

- SEAD-Missionen
- DEAD-Missionen
- IADS_SUPPRESSION-Missionen
- CAP-Planung
- MissionGenerator
- AI Director
- Capture-Pressure
- Capture-Progress
- sichere Luftkorridore
- Red-Verteidigungsfähigkeit
- Persistenz

Aktuell ist noch kein eigenes Theater-Command-IADS-Lua-Modul implementiert.

Skynet IADS ist aber als Vendor geladen und wird vom Loader erkannt.

MissionGenerator bereitet IADS-nahe Missionen und Skynet-Hooks bereits state-only vor.

---

## 2. Kampagnenkontext

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

Grundannahme:

    Rote IADS-Strukturen schützen später das syrische Festland.
    Blue muss SEAD/DEAD/IADS_SUPPRESSION nutzen, um sichere Operationsräume zu schaffen.
    Akrotiri ist initial blauer Ausgangsraum.
    Das syrische Festland ist initial roter Verteidigungsraum.

---

## 3. Aktueller technischer Stand

Stand:

    2026-06-29

Vendor-Datei:

    vendor/skynet-iads/SkynetIADS.lua

Status:

    geladen
    vom Loader erkannt
    noch nicht produktiv durch Theater Command gesteuert

Eigener IADS-Ordner:

    src/iads/

Aktuell vorhanden:

    src/iads/README.md

Noch nicht vorhanden:

    src/iads/tc_iads_system.lua

Aktuell bestätigt:

- Skynet IADS wird im Mission Editor geladen.
- Loader erkennt Skynet IADS.
- MissionGenerator reserviert Skynet-Hooks.
- MissionGenerator kennt IADS-nahe Missionstypen.
- SEAD, DEAD und IADS_SUPPRESSION sind als Missionstypen vorbereitet.
- Es gibt noch keine produktive Theater-Command-IADS-Kampagnenlogik.
- Es werden noch keine Skynet-Netzwerke durch Theater Command initialisiert.
- Es gibt noch keine IADS-F10-Anzeige.
- Es gibt noch keine IADS-Persistenz.

---

## 4. Architekturregel

Externe Frameworks liegen unter:

    vendor/

Eigene Theater-Command-Logik liegt unter:

    src/

Der IADS-Bereich gehört zur eigenen Theater-Command-Logik.

Frameworks werden nicht verändert.

Skynet IADS bleibt unter:

    vendor/skynet-iads/

Eigene IADS-Logik liegt unter:

    src/iads/

Nicht gewünscht:

    src/iads/tc_skynet.lua
    src/iads/tc_skynet_iads.lua
    src/iads/tc_iads_all_in_one.lua
    src/iads/tc_iads_everything.lua

Gewünscht:

    src/iads/tc_iads_system.lua
    src/iads/tc_iads_site_registry.lua
    src/iads/tc_iads_sector_manager.lua
    src/iads/tc_iads_mission_bridge.lua

Diese Dateien werden erst angelegt, wenn sie wirklich benötigt werden.

---

## 5. Verhältnis zu Skynet IADS

Skynet IADS ist das externe Framework für echte DCS-IADS-Funktionalität.

Skynet kann später genutzt werden für:

- SAM-Netzwerke
- EWR-Anbindung
- Command Center
- IADS-Sektoren
- Radar-Emission-Management
- Aktivierung und Deaktivierung von SAM-Sites
- Reaktion auf SEAD/DEAD

Theater Command soll darüber eine eigene Kampagnenschicht legen.

Trennung:

    Skynet IADS verwaltet technische IADS-Funktionalität.
    Theater Command verwaltet Kampagnenzustand, Sektoren, Ziele, Missionseffekte und Persistenz.

Beispiele:

    Skynet IADS kann ein Netzwerk technisch aktivieren.
    Theater Command weiß, welchem Sektor dieses Netzwerk gehört.
    Theater Command weiß, welche Zone geschützt wird.
    Theater Command erzeugt daraus SEAD-/DEAD-Missionen.
    Theater Command speichert, ob ein Sektor geschwächt wurde.

Aktuell:

    Skynet IADS ist geladen.
    Theater Command initialisiert noch keine Skynet-Netzwerke.

---

## 6. Aktueller state-first Stand

Der aktuelle Gesamtstand von Theater Command ist state-first.

Das bedeutet:

- Systeme erzeugen State.
- UI zeigt State.
- Mission Activation verändert State.
- Framework-Hooks werden vorbereitet.
- echte Framework-Aktionen bleiben deaktiviert.

Für IADS bedeutet das:

- Skynet ist geladen.
- MissionGenerator reserviert Skynet-Hooks.
- IADS-nahe Missionstypen existieren.
- Es wird aber noch keine echte Skynet-Aktion ausgeführt.
- Es wird kein echtes IADS-Netzwerk gestartet.
- Es wird keine SAM-Site durch Theater Command gesteuert.

---

## 7. Aktueller getesteter Gesamtstand

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

Diese Grundlage ist ausreichend, um später ein IADS-System state-only vorzubereiten.

Der nächste unmittelbare Schritt bleibt aber F10-Capture-/Pressure-Sichtbarkeit.

---

## 8. Geplante Dateien

Mögliche spätere IADS-Dateien:

    src/iads/tc_iads_system.lua
    src/iads/tc_iads_site_registry.lua
    src/iads/tc_iads_sector_manager.lua
    src/iads/tc_iads_mission_bridge.lua

Mögliche Rollen:

`tc_iads_system.lua`:

    Hauptmodul für Theater-Command-IADS-State

`tc_iads_site_registry.lua`:

    Registrierung von SAM-, EWR- und Command-Sites

`tc_iads_sector_manager.lua`:

    Verwaltung von IADS-Sektoren

`tc_iads_mission_bridge.lua`:

    Verbindung zwischen IADS-State und MissionGenerator/Mission Effects

Diese Dateien werden noch nicht sofort angelegt.

---

## 9. Erste sinnvolle IADS-Datei

Wahrscheinlich erste spätere Datei:

    src/iads/tc_iads_system.lua

Erster sinnvoller Umfang:

- Modul lädt.
- Version wird geloggt.
- Skynet-Verfügbarkeit wird geprüft.
- IADS-State wird initialisiert.
- IADS-Systemstatus wird geloggt.
- keine echten Skynet-Netzwerke werden gestartet.
- keine SAM-Sites werden registriert.
- keine DCS-Objekte werden verändert.
- keine Mission Effects werden angewendet.
- keine Persistenz wird geschrieben.

Diese erste Version wäre ebenfalls state-first.

---

## 10. IADS State

Der IADS-Bereich soll später eigenen State erzeugen.

Mögliche State-Bereiche:

    TC.State.IADS
    TC.State.IADS.Networks
    TC.State.IADS.Sectors
    TC.State.IADS.Sites
    TC.State.IADS.Radars
    TC.State.IADS.CommandCenters
    TC.State.IADS.Effects
    TC.State.IADS.Events

Mögliche Site-Daten:

- siteId
- key
- name
- type
- owner
- coalition
- status
- linkedZone
- linkedBase
- linkedSector
- position
- range
- radarState
- ammoState
- suppressionState
- damageState
- skynetName
- lastMissionEffect
- lastUpdate

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

## 11. Verhältnis zum Core

`src/iads/` nutzt den Core.

Erlaubte Core-Abhängigkeiten:

- `TC.Config`
- `TC.Logger`
- `TC.State`
- `TC.Utils`
- `TC.Scheduler`

Der IADS-Bereich darf davon ausgehen, dass der Core geladen ist.

Aktuelle Ladeposition:

    IADS liegt fachlich nach World, Campaign, Logistics, Missions und AI.
    Ein eigenes IADS-Lua-Modul wird aber noch nicht geladen.

Skynet IADS als Vendor wird vor den eigenen Theater-Command-Dateien geladen.

---

## 12. Verhältnis zum World-Bereich

IADS soll später Daten aus `src/world/` nutzen.

Aktuelle World-Werte:

    Syria airbase-like objects: 225
    relevante Kampagnenzonen: 46
    strategic zones: 19
    secondary zones: 13
    captureZones: 32
    missionZones: 32
    logisticsZones: 46

IADS nutzt diese Daten später für:

- Sektorzuordnung
- Schutzräume
- SAM-Site-Bezug
- Radarbereiche
- Mission-Zielräume
- Frontnähe
- Zone-Verknüpfung
- Base-Verknüpfung

Wichtig:

    IADS soll nicht auf allen 225 Airbase-like Objects arbeiten.
    IADS soll die 46 relevanten Kampagnenzonen und später manuelle IADS-Zonen nutzen.

---

## 13. Verhältnis zum Campaign-Bereich

IADS soll später Campaign-Daten nutzen.

Aktuelle Capture-Werte:

    eligibleBases: 32
    eligibleZones: 32
    pressureRecords: 32
    progressRecords: 32
    appliedMissionEffects: 0
    ready: 0
    contested: 0

Mögliche spätere Kopplung:

- aktive IADS-Abdeckung erschwert Capture.
- unterdrücktes IADS erleichtert Folgeoperationen.
- zerstörte SAM-Sites erhöhen Capture-Pressure.
- beschädigte IADS-Sektoren senken Red-Verteidigungsfähigkeit.
- eroberte Zonen verändern IADS-Zugehörigkeit.
- IADS-Zustand wird später persistent.

Aktuell:

    IADS ist noch nicht mit CaptureSystem gekoppelt.

---

## 14. Verhältnis zum Logistics-Bereich

IADS soll später Logistics-Daten nutzen.

Aktuelle Logistics-Werte:

    logistics hubs: 46
    blue hubs: 7
    red hubs: 24
    neutral hubs: 15
    active hubs: 31
    limited hubs: 15
    locked hubs: 0

Mögliche spätere Kopplung:

- SAM-Sites benötigen Supply.
- beschädigte IADS-Sites benötigen Repair.
- Red Logistics beeinflusst IADS-Wiederherstellung.
- Blue FOBs ermöglichen SEAD-/DEAD-Druck.
- zerstörte IADS öffnet Logistics-Korridore.

Aktuell:

    Logistics und IADS sind noch nicht produktiv gekoppelt.

---

## 15. Verhältnis zum Missionsbereich

MissionGenerator bereitet IADS-nahe Missionen bereits vor.

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

IADS-nahe Missionstypen:

- `SEAD`
- `DEAD`
- `IADS_SUPPRESSION`

MissionGenerator v0.2.2 erzeugt Mission Records mit:

- Objective
- Briefing
- Progress
- Activation Metadata
- Execution Plan
- Effects
- reserved Skynet Hook

Bedeutung:

    IADS-bezogene Missionen sind fachlich vorbereitet.
    Skynet-Hooks sind reserviert.
    Es wird aber noch keine echte IADS-Wirkung ausgelöst.

---

## 16. Verhältnis zum AI-Bereich

AI soll später IADS-Daten nutzen.

Aktuelle AI-Datei:

    src/ai/tc_ai_cap_manager.lua

Getestete Version:

    v0.2.0

Aktuelle AI-Werte:

    cap zone candidates: 31
    auto-registered CAP zones: 12
    CAP requests: 12
    reactionState: AIR_REACTION_REQUESTED
    threatLevel: HIGH

Mögliche spätere Kopplung:

- starke IADS-Sektoren erhöhen Red-Verteidigungspriorität.
- geschwächte IADS-Sektoren erhöhen Red-CAP-Reaktion.
- SEAD-Missionen lösen AI-Reaktionen aus.
- IADS-Lücken ermöglichen Blue-Operationen.
- AI Director priorisiert CAP und Gegenangriffe nach IADS-Zustand.

Aktuell:

    AI nutzt IADS noch nicht produktiv.
    AI Director ist noch nicht implementiert.

---

## 17. Verhältnis zum UI-Bereich

F10Menu ist aktiv.

Aktive UI-Datei:

    src/ui/tc_f10_menu.lua

Getestete Version:

    v0.2.0

F10Menu kann aktuell:

- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Missionsdetails anzeigen
- Missionen aktivieren
- Campaign Status anzeigen
- Logistics Status anzeigen
- FOB Status anzeigen
- AI CAP Status anzeigen

Noch nicht vorhanden:

- IADS Status im F10
- IADS Sector Report
- IADS Site Report
- SEAD Target Report
- DEAD Target Report

Spätere F10-IADS-Funktionen:

- Show IADS Status
- Show IADS Sectors
- Show Active SAM Sites
- Show Suppressed SAM Sites
- Show Destroyed SAM Sites
- Show SEAD Targets
- Show DEAD Targets

Aktuell:

    IADS-F10 ist noch nicht sinnvoll, weil eigener IADS-State fehlt.
    Nächster F10-Schritt bleibt Capture-/Pressure-Sichtbarkeit.

---

## 18. Verhältnis zu Persistence

IADS soll später persistent werden.

Aktuelle Persistence-Datei:

    src/campaign/tc_persistence_system.lua

Status:

    Grundstruktur lädt/startet
    produktiver Dateischreibtest offen

Zu speichernde IADS-Daten:

- IADS-Sites
- IADS-Sektoren
- SAM-Status
- EWR-Status
- Command-Status
- Damage State
- Suppression State
- Radar State
- Ammo State
- linkedZones
- linkedBases
- Mission Effects
- Repair State

Aktuell:

    IADS-State existiert noch nicht produktiv.
    IADS-Persistenz ist noch nicht aktiv.

---

## 19. IADS Mission Effects

Mission Effects sollen später IADS-Zustände verändern.

Mögliche Effekte:

- suppressSite
- damageSite
- destroySite
- revealSite
- reduceSectorReadiness
- degradeNetwork
- disableRadar
- repairSite
- restoreSector
- triggerRedCounteraction

Aktuelle Vorbereitung:

    MissionGenerator erzeugt Effects.
    MissionGenerator reserviert Skynet-Hooks.
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

## 20. Mission Editor Voraussetzungen

Für echte IADS-Integration werden später Mission-Editor-Elemente benötigt.

Mögliche Elemente:

- rote SAM-Gruppen
- rote EWR-Gruppen
- Command Center
- Power Nodes
- Communications Nodes
- Late-Activation-Templates
- statische Objekte
- benannte IADS-Zonen
- Skynet-kompatible Gruppennamen
- Testziele für SEAD/DEAD

Aktuell in der DEV-Mission noch nicht produktiv vorhanden:

- keine produktive IADS-Struktur
- keine aktiven Theater-Command-IADS-Zonen
- keine produktiven SAM-/EWR-Netzwerke
- keine IADS-Templates

---

## 21. Naming-Konzept

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

## 22. State-first-Regel

Der IADS-Bereich folgt der state-first-Architektur.

Das bedeutet:

- IADS-State wird zuerst modelliert.
- F10/Debug zeigt später IADS-State.
- MissionGenerator nutzt später IADS-State.
- Mission Effects verändern später IADS-State.
- Skynet-Aktionen folgen erst danach.
- echte SAM-/EWR-Netzwerke werden nicht in der ersten IADS-Version gestartet.

Nicht aktiv:

- echte Skynet-Netzwerke
- echte Theater-Command-SAM-Steuerung
- IADS-Sektoren
- IADS-Site-Registry
- IADS-F10-Menü
- IADS-Persistenz
- automatische SEAD-/DEAD-Auswertung

---

## 23. Testziele für spätere erste IADS-Version

Eine spätere erste IADS-Version gilt als bestanden, wenn:

- Datei lädt.
- Version wird im Log angezeigt.
- Skynet-Verfügbarkeit wird geprüft.
- IADS-State wird initialisiert.
- IADS-Systemstatus wird geloggt.
- keine echten Skynet-Aktionen ausgelöst werden.
- keine SAM-Sites produktiv registriert werden.
- keine DCS-Objekte verändert werden.
- keine Theater-Command-Lua-Fehler auftreten.
- keine Lua-Stacktraces auftreten.
- Main und Loader bleiben sauber.

---

## 24. Erwartete spätere Logmarker

Mögliche spätere Logmarker:

    [TC] [IADSSystem] Loaded src/iads/tc_iads_system.lua v0.1.0
    [TC] [IADSSystem] Skynet IADS available
    [TC] [IADSSystem] IADS state initialized
    [TC] [IADSSystem] IADS system started stateOnly=true
    [TC] System started: IADS System

Diese Marker sind noch nicht aktiv.

Sie beschreiben nur den erwarteten Umfang einer späteren ersten IADS-Datei.

---

## 25. Risiken

Risiken bei IADS-Integration:

- Skynet-Konfiguration ist empfindlich gegenüber Gruppennamen.
- SAM-/EWR-Strukturen können DCS-Startfehler erzeugen.
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

## 26. Abgrenzung

Nicht Aufgabe von `src/iads/`:

- Airbases aus DCS auslesen
- Zonen geometrisch erzeugen
- Basenbesitz direkt festlegen
- Zonenbesitz direkt festlegen
- CTLD-Lieferungen auswerten
- FOBs bauen
- Missionen generieren
- Missionen im F10 anzeigen
- CAPs dauerhaft verwalten
- Save-Dateien schreiben
- Debug-Zeichnungen erzeugen
- Framework-Dateien verändern

Diese Aufgaben gehören in andere Bereiche.

IADS verwaltet die Theater-Command-Schicht rund um Luftverteidigung.

---

## 27. Nächster sinnvoller Schritt

Der nächste sinnvolle Schritt liegt nicht direkt im IADS-Bereich.

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

## 28. Zielbild

`src/iads/` wird die Luftverteidigungsschicht von Theater Command DCS.

Der IADS-Bereich verbindet später:

- Skynet IADS
- World-Daten
- Campaign-State
- MissionGenerator
- Mission Effects
- AI Director
- Logistics
- UI
- Debug
- Persistence

Aktueller Status:

    Skynet IADS ist geladen.
    Loader erkennt Skynet IADS.
    MissionGenerator reserviert Skynet-Hooks.
    SEAD, DEAD und IADS_SUPPRESSION sind vorbereitet.
    eigenes Theater-Command-IADS-Modul ist noch nicht implementiert.

Nächster notwendiger Zwischenschritt im Gesamtprojekt:

    F10Menu v0.2.1 mit Capture-/Pressure-Sichtbarkeit.
