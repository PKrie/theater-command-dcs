# Project Overview

Diese Datei gibt eine Gesamtübersicht über das Projekt **Theater Command DCS**.

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## 1. Projektidee

Theater Command DCS soll ein modulares, dynamisches und später persistentes Kampagnensystem für DCS World werden.

Es soll keine einzelne statische Mission entstehen.

Ziel ist ein Kampagnensystem, das aus einem zentralen Zustand heraus folgende Bereiche steuert:

- Airbase-Erkennung
- strategische Airbase-Klassifizierung
- virtuelle Kampagnenzonen
- Capture-System
- Capture-Pressure
- Capture-Progress
- Logistiksystem
- CTLD-Anbindung
- FOB-Aufbau
- dynamische Missionsgenerierung
- Missionsauswahl über F10
- Missionsaktivierung über F10
- AI-Reaktionen
- CAP- und GCI-Management
- spätere AI-Director-Logik
- Skynet-IADS-Anbindung
- F10-Menüs
- Debug-Werkzeuge
- Persistenz

Spieler sollen sich in eine laufende Kampagnenlage einklinken.

Die Kampagne soll langfristig nicht ausschließlich durch Spielerhandlungen angetrieben werden.

Blue und Red sollen perspektivisch eigene Operationen planen und ausführen.

---

## 2. Grundprinzip

Das zentrale Arbeitsprinzip lautet:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der DCS Mission Editor stellt die physische Umgebung bereit.

Lua übernimmt die dynamische Kampagnenlogik.

GitHub dokumentiert Struktur, Entscheidungen, Versionen, Aufgabenstand und Testergebnisse.

---

## 3. Aktueller Projektstand

Stand:

    2026-06-29

Aktueller Gesamtstatus:

    State-first Runtime-Grundlage stabil getestet.

Das Projekt ist noch keine fertige spielbare dynamische Kampagne.

Es besitzt aber inzwischen eine tragfähige Runtime-Grundlage, auf der die nächsten UI-, Debug-, Persistence-, CTLD-, MOOSE- und IADS-Schritte aufbauen können.

Aktuell abgeschlossen oder bestätigt:

- Repository erstellt
- zentrale Projektdokumentation angelegt
- `docs/`-Grundblock erstellt
- `mission_editor/`-Dokumentation angelegt
- `vendor/`-Frameworkstruktur erstellt
- MIST importiert
- MOOSE importiert
- CTLD importiert
- Skynet IADS importiert
- MIST auf CTLD-kompatible Version gesetzt
- Vendor-Dokumentation aktualisiert
- `src/`-Grundstruktur angelegt
- Core-System angelegt
- World-System angelegt
- Campaign-System angelegt
- Logistics-System angelegt
- Missions-System angelegt
- AI-CAP-System angelegt
- UI-System angelegt
- IADS- und Debug-Bereiche vorbereitet
- Loader erstellt
- Main-Initialisierung erstellt
- lokale Repository-Kopie auf dem DCS-PC eingerichtet
- minimale Syria-DEV-Mission im DCS Mission Editor erstellt
- erster blauer F/A-18C-Client-Slot auf Akrotiri angelegt
- Framework-Lade-Trigger im Mission Editor angelegt
- Source-Lade-Trigger für sichere Einzeldatei-Ladung im Mission Editor angelegt
- reale DCS-Starttests durchgeführt
- `dcs.log` mehrfach erfolgreich ausgewertet
- Theater-Command-Startkette in DCS erfolgreich bestätigt
- F10-Menü in DCS sichtbar und navigierbar bestätigt
- direkte Missionsauswahl über F10 bestätigt
- direkte Missionsaktivierung über F10 bestätigt

---

## 4. Aktueller technischer Befund

Der aktuelle DCS-Teststand bestätigt:

- MIST wird geladen
- MOOSE wird geladen
- CTLD-i18n wird geladen
- CTLD wird geladen
- Skynet IADS wird geladen
- Theater Command Loader startet
- Frameworks werden durch den Loader erkannt
- Core wird geladen
- World wird geladen
- Campaign wird geladen
- Logistics wird geladen
- Missions wird geladen
- AI wird geladen
- UI wird geladen
- Main wird gestartet
- Runtime-Systeme werden initialisiert
- Airbase Scanner läuft
- ZoneFactory läuft
- CaptureSystem läuft
- PersistenceSystem lädt/startet als Grundstruktur
- LogisticsDelivery läuft
- FobSystem läuft
- MissionGenerator läuft
- AICapManager läuft
- F10Menu läuft
- Loader beendet sauber

Wichtige bestätigte Werte:

    Syria airbase-like objects: 225
    relevante Kampagnenzonen: 46
    capture-fähige Ziele: 32
    Logistics Hubs: 46
    FOB-Kandidaten: 6
    geplante Blue-FOBs: 2
    Missionskandidaten: 69
    FOB-Support-Kandidaten: 2
    verfügbare Missionen: 10
    F10 Commands: 26
    Capture-Pressure-Records: 32
    Capture-Progress-Records: 32

Bewertung:

    Die technische Startkette funktioniert.
    Die hohe Zahl erkannter Airbase-like Objects ist kein Startfehler.
    Die aktuelle Filterung ist fachlich deutlich besser als im ersten Starttest.
    ZoneFactory erzeugt nicht mehr 225 ungefilterte Zonen, sondern 46 relevante Kampagnenzonen.
    CaptureSystem arbeitet nicht auf allen Airbase-like Objects, sondern auf 32 sinnvollen Capture-Zielen.
    F10Menu ist der erste bestätigte Spielerzugang zur Kampagne.
    Missionen können state-only aktiviert werden.
    Echte Spawns sind bewusst noch nicht aktiv.

---

## 5. Aktuelle DEV-Mission

Aktuelle technische Entwicklungsmission:

    Operation_Levant_Reclamation_DEV.miz

Aktueller Inhalt:

    Map: Syria
    Koalitionspreset: Modern
    Blue Start: Akrotiri / Zypern
    erster blauer Client-Slot: F/A-18C Lot 20 auf Akrotiri
    Trigger: sichere Einzeldatei-Ladung
    Vendor-Frameworks werden geladen
    Theater-Command-Source-Dateien werden geladen
    F10-Menü ist sichtbar und testbar
    keine produktive rote Frontlinie
    keine produktiven IADS-Stellungen
    keine produktiven CTLD-Zonen
    keine produktiven Template-Gruppen
    keine echten MOOSE-Spawns
    keine echten CTLD-FOBs
    keine produktive Persistenz

Diese Mission ist aktuell ein technischer Testträger.

Sie ist noch keine fertige spielbare Kampagnenmission.

---

## 6. Hauptstruktur

Aktuelle Hauptstruktur:

    docs/
    mission_editor/
    src/
    vendor/
    README.md
    ROADMAP.md
    TASKS.md
    CHANGELOG.md
    ARCHITECTURE.md
    MISSION_EDITOR_SETUP.md
    NAMING_CONVENTIONS.md
    LUA_STYLEGUIDE.md

---

## 7. Dokumentationsstruktur

Der Ordner `docs/` enthält die fachliche und technische Projektdokumentation.

Aktuelle Dateien:

    docs/00_project_overview.md
    docs/01_campaign_design.md
    docs/02_technical_architecture.md
    docs/03_mission_editor_basics.md
    docs/04_airbase_system.md
    docs/05_logistics_system.md
    docs/06_mission_generator.md
    docs/07_ai_director.md
    docs/08_iads_system.md
    docs/09_persistence.md
    docs/10_testing.md

Wichtiger aktueller Hinweis:

    Die Detaildokumente in docs/ waren teilweise noch auf dem Stand 2026-06-16.
    Diese Datei wurde auf den Stand 2026-06-29 aktualisiert.
    Weitere Detaildokumente müssen danach ebenfalls geprüft und bei Bedarf aktualisiert werden.

Besonders zu prüfen und wahrscheinlich zu aktualisieren:

    docs/01_campaign_design.md
    docs/02_technical_architecture.md
    docs/03_mission_editor_basics.md
    docs/04_airbase_system.md
    docs/05_logistics_system.md
    docs/06_mission_generator.md
    docs/10_testing.md

---

## 8. Mission-Editor-Dokumentation

Der Ordner `mission_editor/` dokumentiert Arbeiten, die direkt im DCS Mission Editor vorbereitet werden müssen.

Aktuelle Dateien:

    mission_editor/README.md
    mission_editor/trigger_setup.md

Aktueller Status:

    Die sichere Einzeldatei-Ladung ist dokumentiert und erfolgreich getestet.
    Per DO SCRIPT FILE geladene Lua-Dateien werden in die .miz eingebettet.
    Nach jeder Lua-Änderung muss die jeweilige Datei im Mission Editor erneut ausgewählt und die Mission gespeichert werden.

Wichtig:

    Die aktive Ladefolge ist weiterhin Einzeldatei-Ladung.
    Loader-only per dofile ist noch nicht praktisch getestet.

---

## 9. Source-Struktur

Eigene Theater-Command-Logik liegt unter:

    src/

Aktuelle Source-Struktur:

    src/
    ├── README.md
    ├── loader.lua
    ├── main.lua
    ├── core/
    ├── world/
    ├── campaign/
    ├── logistics/
    ├── missions/
    ├── ai/
    ├── iads/
    ├── ui/
    └── debug/

Aktive eigene Lua-Dateien:

    src/loader.lua
    src/main.lua
    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
    src/core/tc_utils.lua
    src/core/tc_scheduler.lua
    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua
    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua
    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua
    src/missions/tc_mission_generator.lua
    src/ai/tc_ai_cap_manager.lua
    src/ui/tc_f10_menu.lua

Aktuell vorbereitet, aber noch nicht produktiv implementiert:

    src/iads/
    src/debug/

Wichtige Korrektur gegenüber älteren Dokumenten:

    src/ui/ ist nicht mehr nur dokumentiert.
    src/ui/tc_f10_menu.lua ist aktiv und getestet.

---

## 10. Framework-Basis

Externe Frameworks liegen unter:

    vendor/

Aktuelle Framework-Basis:

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD-i18n | `vendor/ctld/CTLD-i18n.lua` | geladen |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Wichtig:

- Frameworks werden nicht verändert.
- Eigene Logik wird nicht in Framework-Dateien geschrieben.
- Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket.
- MOOSE ist geladen, aber noch nicht produktiv angebunden.
- CTLD ist geladen, aber noch nicht produktiv angebunden.
- Skynet IADS ist geladen, aber noch nicht produktiv angebunden.

---

## 11. Externe DCS-Lade-Reihenfolge

Die Frameworks werden im DCS Mission Editor in dieser Reihenfolge geladen:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua

Danach folgt die eigene Theater-Command-Logik.

---

## 12. Aktive Theater-Command-Lade-Reihenfolge

Aktive Ladefolge der eigenen Dateien:

    1. src/core/tc_config.lua
    2. src/core/tc_logger.lua
    3. src/core/tc_state.lua
    4. src/core/tc_utils.lua
    5. src/core/tc_scheduler.lua
    6. src/world/tc_airbase_scanner.lua
    7. src/world/tc_zone_factory.lua
    8. src/campaign/tc_capture_system.lua
    9. src/campaign/tc_persistence_system.lua
    10. src/logistics/tc_logistics_delivery.lua
    11. src/logistics/tc_fob_system.lua
    12. src/missions/tc_mission_generator.lua
    13. src/ai/tc_ai_cap_manager.lua
    14. src/ui/tc_f10_menu.lua
    15. src/main.lua
    16. src/loader.lua

Wichtig:

    src/ui/tc_f10_menu.lua wird nach src/ai/tc_ai_cap_manager.lua und vor src/main.lua geladen.
    src/main.lua initialisiert die Runtime-Systeme.
    src/loader.lua bleibt aktuell die letzte eigene Datei.

---

## 13. Aktueller getesteter Systemstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.1` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | Grundstruktur | lädt/startet |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.2` | bestanden |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.0` | bestanden |

---

## 14. Airbase Scanner

Datei:

    src/world/tc_airbase_scanner.lua

Getestete Version:

    v0.2.2

Status:

    bestanden

Bestätigte Werte:

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

Bewertung:

    Akrotiri wird korrekt als Blue-Startbasis erkannt.
    Akrotiri wird als STRATEGIC_AIRFIELD klassifiziert.
    Syrische Hauptflugplätze werden als Red Strategic Candidates vorbereitet.
    Medical Pads und einfache Helipads werden nicht als strategische Kampagnenziele behandelt.

---

## 15. ZoneFactory

Datei:

    src/world/tc_zone_factory.lua

Getestete Version:

    v0.2.0

Status:

    bestanden

Bestätigte Werte:

    total zones: 46
    classified airbase zones: 46
    Mission Editor zones: 0
    skipped airbase-like objects: 179
    strategic zones: 19
    secondary zones: 13
    heliport zones: 1
    farp zones: 0
    tactical zones: 13
    captureZones: 32
    missionZones: 32
    logisticsZones: 46
    startBaseZones: 1

Bewertung:

    ZoneFactory erzeugt 46 relevante Kampagnenzonen.
    179 nicht relevante Airbase-like Objects werden übersprungen.
    Die frühere Aussage "ZoneFactory registriert 225 Zonen" ist veraltet.

---

## 16. CaptureSystem

Datei:

    src/campaign/tc_capture_system.lua

Getestete Version:

    v0.2.1

Status:

    bestanden

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

Bewertung:

    CaptureSystem ist nicht mehr nur Ownership-Verwaltung.
    CaptureSystem erzeugt inzwischen Capture-Pressure und Capture-Progress.
    Missionseffekte können state-only als Capture-Druck vorbereitet werden.
    Automatische produktive Capture-Folgen bleiben noch deaktiviert.

---

## 17. LogisticsDelivery

Datei:

    src/logistics/tc_logistics_delivery.lua

Getestete Version:

    v0.2.0

Status:

    bestanden

Bestätigte Werte:

    logistics hubs: 46
    blue hubs: 7
    red hubs: 24
    neutral hubs: 15
    active hubs: 31
    limited hubs: 15
    locked hubs: 0

Bewertung:

    LogisticsDelivery erzeugt 46 Logistics Hubs.
    CTLD ist geladen, aber noch nicht produktiv verbunden.
    Logistics ist aktuell State-only.

---

## 18. FobSystem

Datei:

    src/logistics/tc_fob_system.lua

Getestete Version:

    v0.2.0

Status:

    bestanden

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

Bewertung:

    FOBs sind aktuell State-only.
    Es werden noch keine echten CTLD-FOBs erzeugt.
    FOB-Support ist aber bereits Grundlage für MissionGenerator.

---

## 19. MissionGenerator

Datei:

    src/missions/tc_mission_generator.lua

Getestete Version:

    v0.2.2

Status:

    bestanden

Bestätigte Werte:

    mission candidates: 69
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 30

Bestätigt:

    Missionen werden erzeugt.
    FOB-Support wird berücksichtigt.
    Missionen enthalten Objectives.
    Missionen enthalten Briefings.
    Missionen enthalten Progress-Daten.
    Missionen enthalten Activation Metadata.
    MOOSE-, CTLD- und Skynet-Hooks sind reserviert.
    Aktivierte Missionen bleiben stateOnly=true.
    Spawn-Hooks bleiben reserved.

Bewertung:

    MissionGenerator ist jetzt deutlich über "technisch ladbar" hinaus.
    Missionen sind im F10-Menü sichtbar und aktivierbar.
    Echte DCS-Spawns werden weiterhin nicht ausgelöst.

---

## 20. AICapManager

Datei:

    src/ai/tc_ai_cap_manager.lua

Getestete Version:

    v0.2.0

Status:

    bestanden

Bestätigte Werte:

    cap zone candidates: 31
    auto-registered CAP zones: 12
    CAP requests: 12
    reactionState: AIR_REACTION_REQUESTED
    threatLevel: HIGH

Bewertung:

    AI CAP Manager bereitet CAP-State vor.
    MOOSE-CAP-Spawns sind noch nicht aktiv.
    spawn=MOOSE_PENDING ist erwartetes Verhalten.

---

## 21. F10Menu

Datei:

    src/ui/tc_f10_menu.lua

Getestete Version:

    v0.2.0

Status:

    bestanden

Bestätigt:

    F10-Menü ist in DCS sichtbar.
    F10-Menü ist navigierbar.
    26 Commands werden erzeugt.
    Mission 1 bis Mission 10 sind direkt auswählbar.
    Mission 1 bis Mission 10 sind direkt aktivierbar.
    Missionsdetails können pro Slot angezeigt werden.
    MissionGenerator setzt aktivierte Missionen auf ACTIVE.
    Aktivierung bleibt state-only.
    Es werden keine echten Spawns ausgelöst.

Aktuelle Menüstruktur:

    F10
    └── Theater Command
        ├── Missions
        │   ├── Show Available Missions
        │   ├── Show Active Missions
        │   ├── Mission Details
        │   │   ├── Show Mission 1 Details
        │   │   ├── ...
        │   │   └── Show Mission 10 Details
        │   └── Activate Mission
        │       ├── Activate Mission 1
        │       ├── ...
        │       └── Activate Mission 10
        ├── Status
        │   └── Show Campaign Status
        ├── Logistics
        │   ├── Show Logistics Status
        │   └── Show FOB Status
        └── AI
            └── Show AI CAP Status

Bewertung:

    F10Menu ist die erste bestätigte Spieleroberfläche.
    Der nächste sinnvolle Schritt ist Capture-/Pressure-Sichtbarkeit im F10-Menü.

---

## 22. PersistenceSystem

Datei:

    src/campaign/tc_persistence_system.lua

Status:

    Grundstruktur vorhanden
    lädt/startet
    produktiver Dateischreibtest offen

Bewertung:

    Persistenz ist vorbereitet.
    Save/Load ist noch nicht produktiv im DCS-Dateisystem getestet.
    DCS-Sandbox-Dateizugriff muss vor produktiver Persistenz geprüft werden.

---

## 23. Noch nicht produktiv

Noch nicht produktiv implementiert:

- echte MOOSE-Spawns
- echte MOOSE-CAP-Flüge
- echte Strike-/SEAD-/DEAD-Spawns
- echte CTLD-Cargo-Flüge
- echte CTLD-FOBs
- echte Skynet-IADS-Kampagnenlogik
- produktive Persistenz
- AI Director
- automatische Missionserfolgsauswertung
- automatische Capture-Auswertung aus Missionsresultaten
- automatische `.miz`-Generierung

---

## 24. Architekturregeln

Eigene Lua-Logik wird nach Aufgaben sortiert, nicht nach Frameworks.

Nicht gewünscht:

    tc_moose.lua
    tc_mist.lua
    tc_ctld.lua
    tc_all_in_one.lua

Gewünscht:

    tc_airbase_scanner.lua
    tc_zone_factory.lua
    tc_capture_system.lua
    tc_logistics_delivery.lua
    tc_fob_system.lua
    tc_mission_generator.lua
    tc_ai_cap_manager.lua
    tc_persistence_system.lua
    tc_f10_menu.lua

Vendor-Dateien werden nicht verändert.

Eigene Integrationslogik gehört nach `src/`.

---

## 25. Aktuelle Arbeitsweise

Es wird immer nur eine konkrete Aufgabe oder eine Datei pro Schritt bearbeitet.

Bei neuen oder ersetzten Dateien gilt:

- exakten Dateipfad angeben
- vollständigen Dateiinhalt liefern
- einen einzigen vollständigen Codeblock liefern
- passenden Commit-Text angeben
- keine halben Dateien
- keine parallelen Aufgabenlisten
- keine Vendor-Dateien verändern

Wichtig für DCS:

    Eine per DO SCRIPT FILE geladene Lua-Datei wird in die .miz eingebettet.
    Nach jeder Lua-Änderung muss die Datei im Mission Editor erneut ausgewählt und die Mission gespeichert werden.

---

## 26. Nächster sinnvoller technischer Schritt

Empfohlene nächste Code-Datei:

    src/ui/tc_f10_menu.lua

Empfohlenes Ziel:

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
- keine echten Spawns
- keine CTLD-Aktion
- keine Skynet-Aktion
- keine Lua-Fehler
- keine Theater-Command-Fehler

---

## 27. Noch zu aktualisierende Detaildokumentation

Nach dieser Datei sollten noch folgende Detaildokumente geprüft und wahrscheinlich aktualisiert werden:

    docs/01_campaign_design.md
    docs/02_technical_architecture.md
    docs/03_mission_editor_basics.md
    docs/04_airbase_system.md
    docs/05_logistics_system.md
    docs/06_mission_generator.md
    docs/10_testing.md
    src/README.md

Optional später:

    src/campaign/README.md
    src/logistics/README.md
    src/missions/README.md
    src/ai/README.md
    src/ui/README.md

Ziel:

    Der Abschluss-Prompt für die nächste Session soll erst erstellt werden, wenn die zentrale Dokumentation und die wichtigsten Detaildokumente den heutigen Stand widerspiegeln.
