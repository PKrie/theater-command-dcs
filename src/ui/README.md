# src/ui/README.md

Diese Datei beschreibt den UI-Bereich von **Theater Command DCS**.

Der UI-Bereich enthält eigene Lua-Logik für Spielerinteraktion, F10-Menüs, Statusanzeigen und spätere Debug-/Kampagnensteuerung.

---

## 1. Zweck des UI-Bereichs

Der UI-Bereich stellt die Schnittstelle zwischen Spieler und Theater-Command-Kampagnenzustand bereit.

Langfristig soll UI ermöglichen:

- Kampagnenstatus anzeigen
- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Missionen auswählen
- Missionen aktivieren
- Missionsdetails anzeigen
- Logistikstatus anzeigen
- FOB-Status anzeigen
- AI-Status anzeigen
- Capture-Status anzeigen
- Debug-Informationen anzeigen
- später Save/Load- oder Admin-Funktionen anbieten

Aktuell ist der UI-Bereich nicht mehr nur geplant.

Das erste F10-Menü ist aktiv und getestet.

---

## 2. Aktueller technischer Stand

Stand:

    2026-06-29

Aktive Datei:

    src/ui/tc_f10_menu.lua

Getestete Version:

    v0.2.0

Status:

    bestanden

Bestätigt durch DCS-Logtests:

- F10Menu lädt.
- F10Menu startet.
- F10Menu erzeugt 26 Commands.
- F10-Menü ist in DCS sichtbar.
- F10-Menü ist navigierbar.
- Missionen können angezeigt werden.
- Missionsdetails können pro Slot angezeigt werden.
- Missionen können direkt aktiviert werden.
- MissionGenerator setzt aktivierte Missionen auf ACTIVE.
- Aktivierung bleibt state-only.
- Es werden keine echten Spawns ausgelöst.
- Es gab keinen Theater-Command-Lua-Fehler.
- Es gab keinen Lua-Stacktrace.

---

## 3. Aktuelle Menüstruktur

Aktuelle F10-Struktur:

    F10
    └── Theater Command
        ├── Missions
        │   ├── Show Available Missions
        │   ├── Show Active Missions
        │   ├── Mission Details
        │   │   ├── Show Mission 1 Details
        │   │   ├── Show Mission 2 Details
        │   │   ├── Show Mission 3 Details
        │   │   ├── Show Mission 4 Details
        │   │   ├── Show Mission 5 Details
        │   │   ├── Show Mission 6 Details
        │   │   ├── Show Mission 7 Details
        │   │   ├── Show Mission 8 Details
        │   │   ├── Show Mission 9 Details
        │   │   └── Show Mission 10 Details
        │   └── Activate Mission
        │       ├── Activate Mission 1
        │       ├── Activate Mission 2
        │       ├── Activate Mission 3
        │       ├── Activate Mission 4
        │       ├── Activate Mission 5
        │       ├── Activate Mission 6
        │       ├── Activate Mission 7
        │       ├── Activate Mission 8
        │       ├── Activate Mission 9
        │       └── Activate Mission 10
        ├── Status
        │   └── Show Campaign Status
        ├── Logistics
        │   ├── Show Logistics Status
        │   └── Show FOB Status
        └── AI
            └── Show AI CAP Status

Bestätigte Commands:

    commands: 26

---

## 4. Aktuelle F10-Funktionen

Aktuell unterstützt F10Menu v0.2.0:

- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Mission 1 Details anzeigen
- Mission 2 Details anzeigen
- Mission 3 Details anzeigen
- Mission 4 Details anzeigen
- Mission 5 Details anzeigen
- Mission 6 Details anzeigen
- Mission 7 Details anzeigen
- Mission 8 Details anzeigen
- Mission 9 Details anzeigen
- Mission 10 Details anzeigen
- Mission 1 aktivieren
- Mission 2 aktivieren
- Mission 3 aktivieren
- Mission 4 aktivieren
- Mission 5 aktivieren
- Mission 6 aktivieren
- Mission 7 aktivieren
- Mission 8 aktivieren
- Mission 9 aktivieren
- Mission 10 aktivieren
- Kampagnenstatus anzeigen
- Logistikstatus anzeigen
- FOB-Status anzeigen
- AI-CAP-Status anzeigen

Bestätigt getestet:

- Mission Details Slot 1
- Mission Details Slot 2
- Mission Details Slot 5
- Mission 1 aktivieren
- Mission 5 aktivieren

---

## 5. Verhältnis zu MissionGenerator

F10Menu ist aktuell eng mit MissionGenerator verbunden.

Aktive MissionGenerator-Datei:

    src/missions/tc_mission_generator.lua

Getestete Version:

    v0.2.2

MissionGenerator liefert:

- verfügbare Missionen
- aktive Missionen
- Missionsdetails
- Mission Status
- Mission Objectives
- Mission Briefings
- Mission Progress
- Activation Metadata
- reserved Spawn Hooks

F10Menu nutzt diese Daten, um:

- Missionen zu sortieren
- Mission Slots 1 bis 10 darzustellen
- Missionsdetails pro Slot anzuzeigen
- Missionen über F10 zu aktivieren
- Aktivierung an MissionGenerator weiterzugeben

Bestätigte MissionGenerator-Werte:

    mission candidates: 69
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 30

Bestätigte Aktivierung:

    Mission status changed: MISSION_1 [ACTIVE]
    Mission status changed: MISSION_4 [ACTIVE]
    Mission activation prepared: stateOnly=true spawnHooks=reserved

Wichtig:

    F10Menu aktiviert Missionen aktuell nur state-only.
    Es werden keine echten MOOSE-, CTLD- oder Skynet-Aktionen ausgelöst.

---

## 6. Verhältnis zu CaptureSystem

CaptureSystem ist aktuell vorbereitet, aber noch nicht im F10-Menü sichtbar.

Aktive Capture-Datei:

    src/campaign/tc_capture_system.lua

Getestete Version:

    v0.2.1

Bestätigte Werte:

    eligibleBases: 32
    eligibleZones: 32
    nonCaptureBases: 193
    nonCaptureZones: 14
    pressureRecords: 32
    progressRecords: 32
    appliedMissionEffects: 0
    ready: 0
    contested: 0

Nächster UI-Schritt:

    Capture-/Pressure-Status im F10-Menü sichtbar machen.

Geplante neue F10-Funktionen:

    Show Capture Status
    Show Capture Ready Zones
    Show Pressure Contested Zones

Warum:

    CaptureSystem erzeugt inzwischen Pressure- und Progress-Daten.
    Diese Daten sind im State vorhanden.
    Ohne F10-/Debug-Sichtbarkeit sind spätere MissionEffect- und Capture-Tests schwer bewertbar.

---

## 7. Verhältnis zu LogisticsDelivery

F10Menu zeigt bereits Logistikstatus an.

Aktive Logistics-Datei:

    src/logistics/tc_logistics_delivery.lua

Getestete Version:

    v0.2.0

Bestätigte Werte:

    logistics hubs: 46
    blue hubs: 7
    red hubs: 24
    neutral hubs: 15
    active hubs: 31
    limited hubs: 15
    locked hubs: 0

Aktuelle F10-Funktion:

    Show Logistics Status

Bewertung:

    Logistics-Status ist über F10 erreichbar.
    Die Darstellung kann später erweitert werden.
    CTLD-Aktionen sind noch nicht produktiv angebunden.

---

## 8. Verhältnis zu FobSystem

F10Menu zeigt bereits FOB-Status an.

Aktive FOB-Datei:

    src/logistics/tc_fob_system.lua

Getestete Version:

    v0.2.0

Bestätigte Werte:

    FOB candidates: 6
    stored candidates: 6
    auto-planned FOBs: 2
    skipped candidates: 4
    Blue FOBs: 2

Erzeugte FOBs:

    FOB Ercan
    FOB Gecitkale

Status:

    UNDER_CONSTRUCTION

Aktuelle F10-Funktion:

    Show FOB Status

Bewertung:

    FOB-Status ist über F10 erreichbar.
    FOBs sind aktuell state-only.
    Es werden noch keine echten CTLD-FOBs erzeugt.

---

## 9. Verhältnis zu AICapManager

F10Menu zeigt bereits AI-CAP-Status an.

Aktive AI-Datei:

    src/ai/tc_ai_cap_manager.lua

Getestete Version:

    v0.2.0

Bestätigte Werte:

    cap zone candidates: 31
    auto-registered CAP zones: 12
    CAP requests: 12
    reactionState: AIR_REACTION_REQUESTED
    threatLevel: HIGH

Aktuelle F10-Funktion:

    Show AI CAP Status

Bewertung:

    AI-CAP-State ist über F10 erreichbar.
    Echte MOOSE-CAP-Spawns sind noch nicht aktiv.
    spawn=MOOSE_PENDING ist erwartetes Verhalten.

---

## 10. Verhältnis zu Campaign State

F10Menu zeigt aktuell einen einfachen Kampagnenstatus.

Aktuelle F10-Funktion:

    Show Campaign Status

Campaign State enthält oder soll enthalten:

- Airbase-/Zone-Ownership
- Capture-Eligibility
- Capture-Pressure
- Capture-Progress
- Mission State
- Logistics State
- FOB State
- AI State
- später IADS State
- später Persistence State

Aktueller Stand:

    F10Menu zeigt grundlegende Campaign-Informationen.
    Capture-/Pressure-Details fehlen noch und sind der nächste geplante UI-Ausbauschritt.

---

## 11. Verhältnis zu Persistence

F10Menu enthält aktuell keine Save-/Load-Funktionen.

PersistenceSystem:

    src/campaign/tc_persistence_system.lua

Status:

    Grundstruktur vorhanden
    lädt/startet
    produktiver Dateischreibtest offen

Spätere mögliche F10-Funktionen:

- Save Campaign
- Load Campaign
- Show Save Status
- Debug Save Test
- Debug Load Test

Aktuell nicht vorgesehen:

    Persistence-F10-Funktionen sind noch nicht der nächste Schritt.

Grund:

    Zuerst müssen Capture-/Pressure-Daten sichtbar werden.
    Danach Mission completed/failed.
    Danach Mission Effects.
    Danach Persistence-Sandbox-Test.

---

## 12. Verhältnis zu IADS

F10Menu enthält aktuell keine IADS-Anzeige.

IADS-Stand:

    Skynet IADS wird geladen.
    Theater-Command-IADS-Modul ist noch nicht implementiert.
    MissionGenerator reserviert Skynet-Hooks.

Spätere mögliche F10-Funktionen:

- Show IADS Status
- Show IADS Sectors
- Show Active SAM Sites
- Show Suppressed SAM Sites
- Show Destroyed SAM Sites
- Show SEAD Targets

Aktuell nicht vorgesehen:

    IADS-F10-Funktionen werden erst nach eigenem IADS-State sinnvoll.

---

## 13. UI-State

F10Menu schreibt oder nutzt UI-bezogenen State.

Mögliche UI-State-Daten:

- Menüstatus
- registrierte Commands
- letzte angezeigte Mission
- Anzahl verfügbarer Missionen
- Anzahl aktiver Missionen
- letzte Aktivierung
- letzte Statusabfrage
- UI-Version

Aktuell bestätigt:

    F10Menu initialisiert 26 Commands.
    F10Menu kann Mission Details anzeigen.
    F10Menu kann Mission Activation auslösen.
    UI bleibt state-only.

---

## 14. State-only-Regel

F10Menu folgt aktuell strikt der state-first-Architektur.

Das bedeutet:

- F10 liest State.
- F10 zeigt State an.
- F10 ruft sichere Theater-Command-Funktionen auf.
- F10 aktiviert Missionen state-only.
- F10 löst keine echten DCS-Spawns aus.
- F10 ruft CTLD nicht produktiv auf.
- F10 ruft Skynet nicht produktiv auf.
- F10 verändert keine Vendor-Dateien.

Diese Regel bleibt auch für die nächste Version wichtig.

---

## 15. Warum F10Menu aktuell wichtig ist

F10Menu ist aktuell die wichtigste Sichtbarkeitsfläche.

Grund:

- DCS-Logauswertung allein reicht nicht für spätere Kampagnensteuerung.
- Spieler brauchen Zugriff auf Missionen.
- Entwickler brauchen Zugriff auf State-Zusammenfassungen.
- Mission Activation ist über F10 bereits bestätigt.
- Capture-Pressure und Capture-Progress müssen sichtbar werden.
- Spätere MissionEffects brauchen UI-/Debug-Kontrolle.

F10Menu ist damit aktuell die Brücke zwischen State-Systemen und praktischer DCS-Bewertung.

---

## 16. Versionen und erwartete Logmarker

Aktuelle Version:

    F10Menu v0.2.0

Erwartete aktuelle Logmarker:

    [TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.0
    [TC] [F10Menu] F10 menu started
    [TC] [F10Menu] F10 menu initialized: commands=26
    [TC] System started: F10 Menu
    [TC] [F10Menu] Mission details shown through F10: slot=1 key=MISSION_1
    [TC] [F10Menu] Mission activated through F10: slot=1 key=MISSION_1
    [TC] [F10Menu] Mission activated through F10: slot=5 key=MISSION_4

Erwartete nächste Version:

    F10Menu v0.2.1

Erwartete neue Logmarker nach nächstem Schritt:

    [TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.1
    [TC] [F10Menu] F10 menu initialized:
    [TC] [F10Menu] Capture status shown through F10
    [TC] [F10Menu] Capture ready zones shown through F10
    [TC] [F10Menu] Pressure contested zones shown through F10

---

## 17. Aktuelle Akzeptanzkriterien

F10Menu v0.2.0 gilt als bestanden, weil:

- Datei lädt.
- Version wird im Log angezeigt.
- Menü startet.
- 26 Commands werden erzeugt.
- F10-Menü ist sichtbar.
- F10-Menü ist navigierbar.
- Mission Details sind abrufbar.
- Mission Activation funktioniert.
- MissionGenerator setzt Missionen auf ACTIVE.
- Aktivierung bleibt state-only.
- keine echten Spawns.
- keine CTLD-Aktionen.
- keine Skynet-Aktionen.
- keine Theater-Command-Lua-Fehler.
- keine Lua-Stacktraces.

---

## 18. Nächster UI-Schritt

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

## 19. Spätere UI-Schritte

Nach Capture-/Pressure-Sichtbarkeit:

1. Mission completed/failed manuell über F10 oder Debug testbar machen
2. Mission Effects kontrolliert testen
3. CaptureSystem.applyMissionEffect praktisch testen
4. Persistence-Sandbox-Test optional über Debug-F10 vorbereiten
5. AI Director Status später anzeigen
6. IADS Status später anzeigen
7. Debug-Menü getrennt aufbauen

Mögliche spätere Menüs:

    Theater Command
    Theater Command Debug
    Theater Command Admin
    Theater Command Persistence

Diese Struktur ist noch nicht final.

---

## 20. Risiken

Risiken im UI-Bereich:

- zu viele F10-Commands werden unübersichtlich
- Mission Slots können veralten, wenn Missionen dynamisch wechseln
- F10-Auswahl kann falsche Mission aktivieren, wenn Sortierung instabil ist
- Statusanzeigen können zu lang für DCS-Textausgabe werden
- F10-Funktionen können zu früh echte Framework-Aktionen auslösen
- UI kann Kampagnenlogik versehentlich selbst übernehmen
- Debug- und Spielerfunktionen können vermischt werden

Aktuelle Gegenmaßnahmen:

- stabile Missionssortierung
- feste Slots 1 bis 10
- state-only Aktivierung
- keine echten Framework-Aktionen
- klare Logmarker
- kleine UI-Schritte
- Debug später getrennt behandeln

---

## 21. Nicht-Ziele im aktuellen UI-Stand

Aktuell nicht vorgesehen:

- vollständige Spieleroberfläche
- komplexe Pagination
- vollständiger Debug-Viewer
- IADS-Menü
- Persistence-Menü
- AI Director-Menü
- CTLD-Cargo-Menü
- echte Spawn-Auslösung über F10
- Admin-Kommandos für produktive Kampagnenänderungen

Grund:

    Zuerst muss die State-Sichtbarkeit stabil wachsen.
    Der nächste kleine Schritt ist Capture-/Pressure-Status.

---

## 22. Aktueller getesteter Systemstand

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

---

## 23. Aktueller Status

Der UI-Bereich ist aktiv.

F10Menu v0.2.0 ist bestanden.

Aktuelle Fähigkeit:

- F10-Menü erscheint in DCS.
- Theater Command-Menü ist navigierbar.
- verfügbare Missionen können angezeigt werden.
- aktive Missionen können angezeigt werden.
- Missionsdetails können angezeigt werden.
- Missionen können direkt aktiviert werden.
- Kampagnenstatus kann angezeigt werden.
- Logistikstatus kann angezeigt werden.
- FOB-Status kann angezeigt werden.
- AI-CAP-Status kann angezeigt werden.
- Mission Activation bleibt state-only.

Nächster notwendiger Schritt:

    F10Menu v0.2.1
    Capture-/Pressure-Status im F10-Menü sichtbar machen.
