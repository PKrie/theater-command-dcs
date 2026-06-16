# Theater Command DCS

**Theater Command DCS** ist ein modulares, dynamisches und später persistentes DCS-World-Kampagnensystem.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Das Projekt wird auf der **Syria Map** aufgebaut. Blau startet auf **Zypern / Akrotiri**. Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Grundidee

Theater Command DCS soll keine einzelne statische Mission werden.

Ziel ist ein dynamisches Kampagnensystem, das aus einem zentralen Kampagnenzustand heraus Missionen, Logistik, KI-Reaktionen, Luftverteidigung und Persistenz verwaltet.

Der Mission Editor stellt nur die physische Bühne bereit.

Die eigentliche Kampagnenlogik entsteht durch Lua.

Die Kampagne soll langfristig folgende Systeme verbinden:

- Airbase-Erkennung
- virtuelle Zonen
- Capture-System
- Logistiksystem
- CTLD-Anbindung
- FOB-Aufbau
- dynamische Missionsgenerierung
- AI Director
- CAP- und GCI-Management
- Skynet-IADS-Anbindung
- Persistenz
- F10-Menüs
- Debug- und Testsysteme

Der Spieler ist nicht der alleinige Mittelpunkt der Mission.

Der Spieler ist Teil eines größeren dynamischen Systems.

---

## Leitprinzip

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Mission Editor wird möglichst schlank gehalten.

Alles, was sinnvoll durch Lua erkannt, berechnet oder gesteuert werden kann, soll nicht als große Triggerkette im Mission Editor gebaut werden.

---

## Kampagnenlage

Erste Kampagne:

    Operation Levant Reclamation

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

Erste operative Grundidee:

    Erste aktive Region: syrische Küste
    Erstes operatives Ziel: Küsten-IADS schwächen
    Erstes logistisches Ziel: Brückenkopf / FOB an der Küste aufbauen

Geplante blaue Spielerrollen zu Beginn:

    F/A-18C
    F-16C
    F-14B
    F-15E
    UH-1H
    Mi-8

Spätere Rollen nach Aufbau vorgeschobener Strukturen:

    A-10C II
    AH-64D
    weitere CAS-, Transport- und Unterstützungsrollen

---

## Aktueller Projektstatus

Stand: 2026-06-16

Aktuell erledigt:

- Repository-Grundstruktur erstellt
- zentrale Dokumentationsdateien angelegt
- `docs/`-Grundblock angelegt
- `vendor/`-Grundstruktur angelegt
- MIST hinterlegt
- MOOSE hinterlegt
- CTLD hinterlegt
- Skynet IADS hinterlegt
- CTLD-kompatible MIST-Version hinterlegt
- Vendor-Dokumentation aktualisiert
- zentrale Dokumentation nach Vendor-Abschluss aktualisiert
- `src/README.md` erstellt und nach Source-Ausbau aktualisiert
- `src/loader.lua` erstellt
- `src/main.lua` erstellt
- `src/core/` erstellt
- `src/world/` erstellt
- `src/campaign/` erstellt
- `src/logistics/` erstellt
- `src/missions/` erstellt
- `src/ai/` erstellt
- `src/iads/` erstellt
- `src/ui/` erstellt
- `src/debug/` erstellt
- Core-Module erstellt
- World-Module erstellt
- Campaign-Module erstellt
- Logistics-Module erstellt
- Missionsgenerator erstellt
- AI-CAP-Manager erstellt
- Loader auf Core, World, Campaign, Logistics, Missions und AI erweitert
- `TASKS.md` nach Source-Ausbau aktualisiert
- `CHANGELOG.md` nach Source-Ausbau aktualisiert
- `ROADMAP.md` nach Source-Ausbau aktualisiert
- `ARCHITECTURE.md` nach Source-Ausbau aktualisiert

Aktueller Fokus:

    Dokumentationsabgleich abschließen und danach src/main.lua technisch gegen aktuelle Modulnamen prüfen

Noch nicht abgeschlossen:

- `src/main.lua` gegen aktuelle Modulnamen prüfen
- erster echter DCS-Starttest
- DEV-Mission im DCS Mission Editor
- konkrete IADS-Lua-Implementierung
- konkrete UI-/F10-Lua-Implementierung
- konkrete Debug-Lua-Implementierung
- reale CTLD-Ereignisbrücke
- reale MOOSE-CAP-Spawns
- reale Skynet-IADS-Kampagnenbrücke
- DCS-Dateipersistenz
- Mission-Editor-Dokumentation
- Mission-, Save-, Tools- und Assets-Ordnerstruktur

---

## Externe Frameworks

Externe Frameworks liegen ausschließlich unter:

    vendor/

Sie werden nicht verändert.

Aktuell hinterlegte Frameworks:

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Zusätzliche Referenzdateien:

    vendor/mist/Mist guide.pdf
    vendor/mist/Example_DBs/
    vendor/moose/MOOSE_DOCS.md

Wichtig:

Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket, da CTLD für korrektes dynamisches Spawning auf die mitgelieferte MIST-Version verweist.

---

## Lade-Reihenfolge im DCS Mission Editor

Die Frameworks und der Theater-Command-Loader werden in dieser Reihenfolge geladen:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua
    6. src/loader.lua

Wichtig:

- MIST wird vor CTLD geladen.
- `CTLD-i18n.lua` wird vor `CTLD.lua` geladen.
- Skynet IADS wird nach MIST geladen.
- Eigene Theater-Command-Logik startet erst nach den externen Frameworks.
- `src/loader.lua` ist der Einstiegspunkt der eigenen Projektlogik.

---

## Interne Source-Lade-Reihenfolge

Die interne Theater-Command-Lade-Reihenfolge lautet:

    1. Core
    2. World
    3. Campaign
    4. Logistics
    5. Missions
    6. AI
    7. IADS
    8. UI
    9. Debug
    10. Main

Aktuell lädt `src/loader.lua` aktiv:

- Core
- World
- Campaign
- Logistics
- Missions
- AI
- Main

IADS, UI und Debug besitzen aktuell README-Dateien, aber noch keine aktiven Lua-Module.

---

## Architekturregel

Eigene Theater-Command-Logik gehört nach:

    src/

Externe Frameworks gehören nach:

    vendor/

Die eigene Lua-Struktur wird nach Aufgaben sortiert, nicht nach Frameworks.

Frameworks werden nicht verändert.

Nicht gewünscht:

    src/tc_moose.lua
    src/tc_mist.lua
    src/tc_ctld.lua
    src/tc_skynet.lua
    src/tc_all_in_one.lua
    src/tc_iads_all_in_one.lua

Gewünscht ist eine aufgabenorientierte Struktur.

Beispiele:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua
    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua
    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua
    src/missions/tc_mission_generator.lua
    src/ai/tc_ai_cap_manager.lua

Eine eigene Datei darf intern DCS-API, MIST, MOOSE, CTLD oder Skynet IADS nutzen.

Der Dateiname richtet sich aber immer nach der Theater-Command-Aufgabe, nicht nach dem verwendeten Framework.

---

## Aktuelle Repository-Struktur

Aktuell vorhanden:

    theater-command-dcs/
    ├── README.md
    ├── ROADMAP.md
    ├── TASKS.md
    ├── CHANGELOG.md
    ├── ARCHITECTURE.md
    ├── MISSION_EDITOR_SETUP.md
    ├── NAMING_CONVENTIONS.md
    ├── LUA_STYLEGUIDE.md
    ├── .gitignore
    ├── docs/
    ├── src/
    └── vendor/

Aktuell noch nicht vollständig angelegt:

    mission/
    mission_editor/
    assets/
    save/
    tools/

Diese Ordner werden später ergänzt, sobald sie für den nächsten konkreten Projektschritt benötigt werden.

---

## Aktuelle Source-Struktur

Die aktuelle Source-Struktur lautet:

    src/
    ├── README.md
    ├── loader.lua
    ├── main.lua
    ├── core/
    │   ├── README.md
    │   ├── tc_config.lua
    │   ├── tc_logger.lua
    │   ├── tc_state.lua
    │   ├── tc_utils.lua
    │   └── tc_scheduler.lua
    ├── world/
    │   ├── README.md
    │   ├── tc_airbase_scanner.lua
    │   └── tc_zone_factory.lua
    ├── campaign/
    │   ├── README.md
    │   ├── tc_capture_system.lua
    │   └── tc_persistence_system.lua
    ├── logistics/
    │   ├── README.md
    │   ├── tc_logistics_delivery.lua
    │   └── tc_fob_system.lua
    ├── missions/
    │   ├── README.md
    │   └── tc_mission_generator.lua
    ├── ai/
    │   ├── README.md
    │   └── tc_ai_cap_manager.lua
    ├── iads/
    │   └── README.md
    ├── ui/
    │   └── README.md
    └── debug/
        └── README.md

---

## Aktive eigene Lua-Module

Aktuell vorhandene aktive eigene Lua-Module:

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

---

## Systembereiche

### Core

`src/core/` enthält die technische Grundschicht.

Vorhanden:

    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
    src/core/tc_utils.lua
    src/core/tc_scheduler.lua

Aufgaben:

- zentrale Konfiguration
- Logging
- State-Verwaltung
- Utility-Funktionen
- Scheduler-Grundfunktionen
- Modulstatus
- Featurestatus
- Dirty-State-Vorbereitung

---

### World

`src/world/` bildet die DCS-Welt in Theater-Command-Strukturen ab.

Vorhanden:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

Aufgaben:

- Airbases erkennen
- Airbases normalisieren
- Airbases im State registrieren
- Akrotiri als blaue Startbasis vorbereiten
- syrisches Festland initial rot bewerten
- virtuelle Airbase-Zonen erzeugen
- optionale Mission-Editor-Zonen einlesen
- Weltobjekte für andere Systeme bereitstellen

---

### Campaign

`src/campaign/` enthält strategischen Kampagnenzustand, Besitzlogik und Persistenzvorbereitung.

Vorhanden:

    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua

Aufgaben:

- Basenbesitz verwalten
- Zonenbesitz verwalten
- Capture-Events speichern
- State als dirty markieren
- In-Memory-Persistenz vorbereiten
- State-Export vorbereiten
- State-Import vorbereiten

---

### Logistics

`src/logistics/` enthält Versorgung, Lieferungen und FOB-Aufbau.

Vorhanden:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

Aufgaben:

- Lieferungen anlegen
- Lieferstatus verwalten
- logistische Effekte auf Zonen und Basen vorbereiten
- FOBs anlegen
- FOB-Zustände verwalten
- FOB-Versorgung verwalten
- FOB-Baufortschritt verwalten
- spätere CTLD-Anbindung vorbereiten

---

### Missions

`src/missions/` enthält die dynamische Missionsgenerierung.

Vorhanden:

    src/missions/tc_mission_generator.lua

Aufgaben:

- Missionsarten vorbereiten
- Missionen aus Kampagnenzustand erzeugen
- Missionen im State speichern
- verfügbare Missionen verwalten
- aktive Missionen verwalten
- abgeschlossene und fehlgeschlagene Missionen verwalten
- Logistikmissionen und FOB-Support-Missionen vorbereiten

---

### AI

`src/ai/` enthält KI-Reaktionslogik.

Vorhanden:

    src/ai/tc_ai_cap_manager.lua

Aufgaben:

- CAP-Zonen registrieren
- CAP-Bedarf aus dem State ableiten
- CAP-Anforderungen speichern
- aktive CAPs verwalten
- abgeschlossene und fehlgeschlagene CAPs verwalten
- Reaktionsstatus vorbereiten
- Bedrohungsniveau vorbereiten
- spätere MOOSE-Anbindung vorbereiten

---

### IADS

`src/iads/` enthält später die eigene Kampagnenlogik rund um Skynet IADS.

Aktuell vorhanden:

    src/iads/README.md

Status:

    dokumentiert, aber noch nicht aktiv implementiert

---

### UI

`src/ui/` enthält später Spielerinteraktion und F10-Menüs.

Aktuell vorhanden:

    src/ui/README.md

Status:

    dokumentiert, aber noch nicht aktiv implementiert

---

### Debug

`src/debug/` enthält später Debug- und Testhilfen.

Aktuell vorhanden:

    src/debug/README.md

Status:

    dokumentiert, aber noch nicht aktiv implementiert

---

## Dokumentation

Die zentrale Dokumentation liegt aktuell in:

    README.md
    ROADMAP.md
    TASKS.md
    CHANGELOG.md
    ARCHITECTURE.md
    MISSION_EDITOR_SETUP.md
    NAMING_CONVENTIONS.md
    LUA_STYLEGUIDE.md
    docs/
    vendor/
    src/

Der Ordner `docs/` enthält die fachliche und technische Projektdokumentation.

Der Ordner `vendor/` dokumentiert die eingebundenen externen Frameworks.

Der Ordner `src/` dokumentiert und enthält die eigene Lua-Struktur.

---

## Projektphasen

Grobe Entwicklungsphasen:

    Phase 0: Projektgrundlage, Dokumentation und Vendor-Frameworks
    Phase 1: src-Grundstruktur und Lua-Core
    Phase 2: Airbase- und Zonen-System
    Phase 3: Capture-System und Persistenzgrundlage
    Phase 4: Logistik und CTLD-Anbindung
    Phase 5: Missionsgenerator
    Phase 6: AI Director und CAP-Manager
    Phase 7: IADS-Anbindung
    Phase 8: UI und F10-Menüs
    Phase 9: Debug-System
    Phase 10: Persistenz vertiefen
    Phase 11: Mission-Editor-DEV-Mission
    Phase 12: Test, Stabilisierung und Release-Struktur

Aktuell befindet sich das Projekt in:

    Source-Grundstruktur vorhanden, Dokumentationsabgleich und technischer Starttest offen

---

## Erste technische Ziele nach Abschluss des Dokumentationsabgleichs

Nach Abschluss der aktuellen Dokumentationsaktualisierung sollen als nächste technische Schritte folgen:

    1. src/main.lua gegen aktuelle Modulnamen prüfen
    2. Loader- und Main-Startkette logisch prüfen
    3. DCS-Sandbox-Verhalten für dofile prüfen
    4. erste DEV-Mission im DCS Mission Editor vorbereiten
    5. Frameworks und src/loader.lua in definierter Reihenfolge laden
    6. erster Starttest mit dcs.log-Kontrolle durchführen

---

## Entwicklungsgrundsatz

Jede Datei erfüllt genau eine klare Aufgabe.

Keine All-in-one-Dateien.

Keine Framework-Sammeldateien.

Keine große Mission-Editor-Triggerkette für Dinge, die Lua später berechnen kann.

Frameworks unter `vendor/` werden nicht verändert.

Eigene Theater-Command-Logik gehört nach `src/`.

Die Struktur wird nach Aufgaben sortiert.

---

## Zielbild

Theater Command DCS soll langfristig ein eigenes modulares Kampagnensystem werden.

Es soll dynamische Einsätze, persistente Basen, CTLD-Logistik, KI-Gegenreaktionen, IADS-Zustand, Airbase-Besitz und spielerabhängige Missionsangebote miteinander verbinden.

Das Ziel ist ein stabiler, verständlicher und erweiterbarer technischer Unterbau für dynamische DCS-Kampagnen.
