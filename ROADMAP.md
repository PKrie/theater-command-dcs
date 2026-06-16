# Roadmap

Diese Roadmap beschreibt die geplanten Entwicklungsphasen für **Theater Command DCS** und die erste Kampagne **Operation Levant Reclamation**.

Das Projekt wird schrittweise aufgebaut.

Jede Phase soll einzeln dokumentiert, umgesetzt und getestet werden, bevor die nächste große Phase vertieft wird.

---

## Projektziel

**Theater Command DCS** soll ein modulares, dynamisches und später persistentes DCS-World-Kampagnensystem werden.

Die erste Kampagne wird auf der **Syria Map** aufgebaut.

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert
    Erste Kampagne: Operation Levant Reclamation

Grundprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

---

## Aktueller Stand

Stand: 2026-06-16

Aktuell abgeschlossen:

- Repository erstellt
- zentrale Dokumentationsdateien angelegt
- `docs/`-Grundblock erstellt
- `vendor/`-Grundstruktur erstellt
- MIST importiert
- MOOSE importiert
- CTLD importiert
- Skynet IADS importiert
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

Aktueller Fokus:

    zentrale Dokumentation nach Source-Ausbau konsistent machen

Noch nicht abgeschlossen:

- `ARCHITECTURE.md` nach Source-Ausbau aktualisieren
- Root-`README.md` nach Source-Ausbau aktualisieren
- `src/main.lua` technisch gegen aktuelle Modulnamen prüfen
- erster echter DCS-Starttest
- DEV-Mission im DCS Mission Editor
- konkrete IADS-Lua-Implementierung
- konkrete UI-/F10-Lua-Implementierung
- konkrete Debug-Lua-Implementierung
- reale CTLD-Ereignisbrücke
- reale MOOSE-CAP-Spawns
- reale Skynet-IADS-Kampagnenbrücke
- Persistenz mit DCS-Dateizugriff

---

## Aktueller Framework-Stand

Externe Frameworks liegen unter:

    vendor/

Aktuell hinterlegte Frameworks:

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Wichtig:

Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket, weil CTLD für korrektes dynamisches Spawning auf die mitgelieferte MIST-Version verweist.

Frameworks unter `vendor/` werden nicht verändert.

---

## DCS-Lade-Reihenfolge

Die Lade-Reihenfolge im DCS Mission Editor lautet:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua
    6. src/loader.lua

Eigene Theater-Command-Logik startet erst nach den externen Frameworks.

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

## Entwicklungsphasen

Die Roadmap ist in technische Entwicklungsphasen unterteilt.

Die Phasen beschreiben die Zielrichtung.

Die konkrete Aufgabenverwaltung erfolgt über:

    TASKS.md

---

## Phase 0 — Projektgrundlage und Vendor-Abschluss

### Ziel

Repository, Dokumentation und externe Frameworks sauber vorbereiten.

### Aufgaben

- [x] GitHub-Repository erstellen
- [x] grundlegende Projektstruktur anlegen
- [x] `README.md` erstellen
- [x] `ROADMAP.md` erstellen
- [x] `TASKS.md` erstellen
- [x] `CHANGELOG.md` erstellen
- [x] `ARCHITECTURE.md` erstellen
- [x] `MISSION_EDITOR_SETUP.md` erstellen
- [x] `NAMING_CONVENTIONS.md` erstellen
- [x] `LUA_STYLEGUIDE.md` erstellen
- [x] `docs/`-Grundblock erstellen
- [x] `vendor/README.md` erstellen
- [x] `vendor/mist/README.md` erstellen
- [x] `vendor/moose/README.md` erstellen
- [x] `vendor/ctld/README.md` erstellen
- [x] `vendor/skynet-iads/README.md` erstellen
- [x] MIST hinterlegen
- [x] MOOSE hinterlegen
- [x] CTLD hinterlegen
- [x] Skynet IADS hinterlegen
- [x] Framework-Versionen dokumentieren
- [x] `src/README.md` erstellen
- [x] falsch platzierte Root-`Moose.lua` entfernen
- [x] zentrale Dokumentation nach Vendor-Import aktualisieren
- [x] `TASKS.md` nach Vendor-Abschluss aktualisieren
- [x] `CHANGELOG.md` nach Vendor-Abschluss aktualisieren

### Ergebnis

Phase 0 ist fachlich abgeschlossen.

Das Projekt ist dokumentiert.

Die externen Frameworks sind lokal unter `vendor/` hinterlegt.

Die eigene Lua-Struktur konnte danach beginnen.

---

## Phase 1 — Source-Grundstruktur und Core-System

### Ziel

Theater Command als eigenes Lua-System initialisieren.

### Geplante Struktur

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

### Vorhandene Dateien

- [x] `src/README.md`
- [x] `src/loader.lua`
- [x] `src/main.lua`
- [x] `src/core/README.md`
- [x] `src/core/tc_config.lua`
- [x] `src/core/tc_logger.lua`
- [x] `src/core/tc_state.lua`
- [x] `src/core/tc_utils.lua`
- [x] `src/core/tc_scheduler.lua`

### Aufgaben

- [x] `src/`-Unterordner vorbereiten
- [x] README-Dateien für alle `src/`-Unterordner erstellen
- [x] globale `TC`-Tabelle anlegen
- [x] zentrale Konfiguration vorbereiten
- [x] Logger für `dcs.log` erstellen
- [x] globalen Kampagnen-State vorbereiten
- [x] Utility-Funktionen vorbereiten
- [x] Scheduler-Grundfunktionen vorbereiten
- [x] Lade-Reihenfolge der eigenen Lua-Dateien festlegen
- [x] Framework-Verfügbarkeit prüfen
- [x] erste Debug-Ausgabe im DCS-Log vorbereiten
- [ ] `src/main.lua` gegen aktuelle Modulnamen prüfen
- [ ] DCS-Sandbox-Verhalten für `dofile` prüfen
- [ ] erster echter DCS-Starttest

### Ergebnis

Die eigene Lua-Grundstruktur ist modular vorbereitet.

Der Core ist in erster Version vorhanden.

Der reale Starttest in DCS steht noch aus.

---

## Phase 2 — Airbase- und Zonen-System

### Ziel

Relevante Airbases der Syria Map automatisch erkennen und daraus eigene strategische BaseNodes sowie virtuelle Zonen erzeugen.

### Vorhandene Dateien

- [x] `src/world/README.md`
- [x] `src/world/tc_airbase_scanner.lua`
- [x] `src/world/tc_zone_factory.lua`

### Geplante spätere Dateien

- [ ] `src/debug/tc_debug_airbase_report.lua`
- [ ] `src/debug/tc_debug_zone_overlay.lua`

### Aufgaben

- [x] Airbase-Scanner bauen
- [x] Airbases über DCS-API erfassbar machen
- [x] Name, Position, Koalition und Kategorie vorbereiten
- [x] Airbases als eigene BaseRecords registrieren
- [x] Akrotiri als blaue Startbasis vorbereiten
- [x] syrisches Festland initial als rot kontrolliert vorbereiten
- [x] virtuelle Airbase-Zonen vorbereiten
- [x] optionale Mission-Editor-Zonen einlesbar machen
- [x] Zonen mit Airbases verknüpfen
- [x] Zonen für spätere Missionen nutzbar machen
- [ ] Debug-Ausgabe für erkannte Airbases erstellen
- [ ] Debug-Ausgabe für virtuelle Zonen erstellen
- [ ] realen Syria-Airbase-Scan in DCS testen

### Ergebnis

Die Map kann als strategisches Basen- und Zonensystem vorbereitet werden.

Manuelle Triggerzonen pro Airbase sollen langfristig nicht nötig sein.

---

## Phase 3 — Besitz- und Capture-System

### Ziel

Basen und Gefechtszonen sollen durch Theater-Command-Logik erobert, verloren und bewertet werden können.

### Vorhandene Dateien

- [x] `src/campaign/README.md`
- [x] `src/campaign/tc_capture_system.lua`
- [x] `src/campaign/tc_persistence_system.lua`

### Geplante spätere Dateien

- [ ] `src/debug/tc_debug_capture_report.lua`

### Aufgaben

- [x] Blau/Rot/Neutral/Contested/Unknown-Status vorbereiten
- [x] Besitzstatus für Basen vorbereiten
- [x] Besitzstatus für Zonen vorbereiten
- [x] Besitzstatus lesen
- [x] Besitzstatus ändern
- [x] Capture-Events speichern
- [x] State als dirty markieren
- [x] Verbindung zum Airbase-System vorbereiten
- [x] Verbindung zum Zonen-System vorbereiten
- [x] In-Memory-Persistenz vorbereiten
- [x] State-Export vorbereiten
- [x] State-Import vorbereiten
- [ ] DCS-AutoCapture deaktivieren oder umgehen
- [ ] Capture-Bedingungen fachlich definieren
- [ ] Garnisonen auswerten
- [ ] Supply-Status auswerten
- [ ] CTLD-Lieferungen in Capture-Logik einbinden
- [ ] Basiswechsel später per DCS-Mechanik oder State-Brücke abbilden
- [ ] Capture-Debugausgabe vorbereiten
- [ ] Capture-System in DCS testen

### Ergebnis

Basen und Zonen sollen nicht zufällig, sondern nur durch Theater-Command-Logik ihren strategischen Besitzstatus ändern.

Der Kampagnenfortschritt wird strategisch nachvollziehbar.

---

## Phase 4 — CTLD- und Logistiksystem

### Ziel

CTLD soll nicht nur Zusatzfunktion sein, sondern ein wichtiger Teil des Kampagnenfortschritts werden.

### Vorhandene Dateien

- [x] `src/logistics/README.md`
- [x] `src/logistics/tc_logistics_delivery.lua`
- [x] `src/logistics/tc_fob_system.lua`

### Geplante spätere Dateien

- [ ] `src/ui/tc_logistics_menu.lua`
- [ ] `src/debug/tc_debug_logistics_report.lua`
- [ ] `src/logistics/tc_logistics_hub.lua`
- [ ] `src/logistics/tc_supply_network.lua`
- [ ] `src/logistics/tc_ctld_bridge.lua`

### Aufgaben

- [x] Logistik-State vorbereiten
- [x] Lieferungen anlegen
- [x] Lieferstatus verwalten
- [x] Lieferungen als abgeschlossen markieren
- [x] Lieferungen als verloren markieren
- [x] logistische Effekte auf Zonen vorbereiten
- [x] logistische Effekte auf Basen vorbereiten
- [x] FOB-System vorbereiten
- [x] FOBs anlegen
- [x] FOB-Zustände verwalten
- [x] FOB-Versorgung verwalten
- [x] FOB-Baufortschritt verwalten
- [ ] CTLD-Grundkonfiguration vorbereiten
- [ ] Akrotiri als Start-Logistikhub definieren
- [ ] erste Pickup-Zonen für Akrotiri vorbereiten
- [ ] erste Dropoff-Zonen vorbereiten
- [ ] eroberte Basen als neue Hubs freischalten
- [ ] Kistenlieferungen auswerten
- [ ] Truppentransport auswerten
- [ ] FOB-Aufbau mit CTLD-Ereignissen verbinden
- [ ] Logistikstatus in den Kampagnen-State schreiben
- [ ] Verbindung zwischen CTLD und Capture-System vertiefen
- [ ] Logistiksystem in DCS testen

### Ergebnis

Heli-Spieler können den Frontverlauf später durch Truppen- und Kistenlieferungen real beeinflussen.

Logistik wird kampagnenrelevant.

---

## Phase 5 — Missionsgenerator

### Ziel

Spieler erhalten abhängig von Flugzeugtyp, Kampagnenzustand und Weltlage sinnvolle Missionen.

### Vorhandene Dateien

- [x] `src/missions/README.md`
- [x] `src/missions/tc_mission_generator.lua`

### Geplante spätere Dateien

- [ ] `src/ui/tc_mission_menu.lua`
- [ ] `src/debug/tc_debug_mission_report.lua`
- [ ] `src/missions/tc_mission_registry.lua`
- [ ] `src/missions/tc_mission_types.lua`
- [ ] `src/missions/tc_target_selector.lua`

### Aufgaben

- [x] Missionsarten vorbereiten
- [x] Missionsstatus vorbereiten
- [x] Missionen aus Kampagnenzustand erzeugen
- [x] Missionen im State speichern
- [x] verfügbare Missionen verwalten
- [x] aktive Missionen verwalten
- [x] abgeschlossene Missionen verwalten
- [x] fehlgeschlagene Missionen verwalten
- [x] Logistikmissionen mit Logistics verbinden
- [x] FOB-Support-Missionen vorbereiten
- [ ] Spielerflugzeug erkennen
- [ ] Missionstypen nach Flugzeug filtern
- [ ] Missionen über F10-Menü auswählbar machen
- [ ] Missionsziele aus DCS-Objekten erstellen
- [ ] Airbase-Ziele aus Kampagnenzustand verfeinern
- [ ] SEAD/DEAD-Ziele aus IADS-Zustand ableiten
- [ ] Logistikmissionen aus Logistikzustand vertiefen
- [ ] Missionsabschluss real auswerten
- [ ] Auswirkungen auf Kampagnenzustand speichern
- [ ] Missionsgenerator in DCS testen

### Ergebnis

Missionen entstehen aus der aktuellen Kampagnenlage.

F/A-18C, F-14B, F-15C/E, A-10C, AH-64D und Helis sollen später unterschiedliche, sinnvolle Aufgaben erhalten.

---

## Phase 6 — KI-System und AI Director

### Ziel

Die Welt soll auch ohne Spieler aktiv und reaktionsfähig wirken.

### Vorhandene Dateien

- [x] `src/ai/README.md`
- [x] `src/ai/tc_ai_cap_manager.lua`

### Geplante spätere Dateien

- [ ] `src/ai/tc_ai_director.lua`
- [ ] `src/ai/tc_ai_gci_manager.lua`
- [ ] `src/ai/tc_ai_reinforcement_manager.lua`
- [ ] `src/ai/tc_ai_counterattack.lua`
- [ ] `src/debug/tc_debug_ai_report.lua`

### Aufgaben

- [x] einfache CAP-Logik vorbereiten
- [x] CAP-Zonen registrieren
- [x] CAP-Bedarf aus State-Daten ableiten
- [x] CAP-Anforderungen speichern
- [x] aktive CAPs verwalten
- [x] abgeschlossene CAPs verwalten
- [x] fehlgeschlagene CAPs verwalten
- [x] AI-Reaktionsstatus vorbereiten
- [x] Bedrohungsniveau vorbereiten
- [ ] MOOSE-Anbindung für reale CAP-Spawns vorbereiten
- [ ] AI Director vorbereiten
- [ ] einfache GCI-Logik vorbereiten
- [ ] KI-Missionen lageabhängig erzeugen
- [ ] rote Reaktionen auf blaue Erfolge erzeugen
- [ ] Gegenangriffe vorbereiten
- [ ] Konvois bewegen
- [ ] Ressourcenverbrauch durch KI einbauen
- [ ] Frontdruck simulieren
- [ ] KI-Reaktionen auf Capture-Ereignisse vorbereiten
- [ ] KI-Reaktionen auf IADS-Schäden vorbereiten
- [ ] AI-System in DCS testen

### Ergebnis

Die Kampagne soll dynamisch weiterlaufen.

Spieler beeinflussen Teilbereiche, aber die Welt wirkt eigenständig.

---

## Phase 7 — IADS-System

### Ziel

Skynet IADS mit der Theater-Command-Kampagnenlogik verbinden.

### Vorhandene Dateien

- [x] `src/iads/README.md`

### Geplante Dateien

- [ ] `src/iads/tc_iads_network.lua`
- [ ] `src/iads/tc_iads_sector_manager.lua`
- [ ] `src/iads/tc_iads_site_registry.lua`
- [ ] `src/iads/tc_iads_mission_bridge.lua`
- [ ] `src/debug/tc_debug_iads_report.lua`

### Aufgaben

- [x] IADS-Bereich dokumentieren
- [ ] rote IADS-Sektoren vorbereiten
- [ ] Radar-/SAM-Gruppen mit Regionen koppeln
- [ ] SAM-Stellungen als Kampagnenobjekte definieren
- [ ] Radarstellungen als Kampagnenobjekte definieren
- [ ] zerstörte Radarstellungen auswerten
- [ ] beschädigte Sektoren schwächen
- [ ] Reparatur über Ressourcen und Logistik ermöglichen
- [ ] SEAD/DEAD-Erfolge dauerhaft in den State schreiben
- [ ] Missionsgenerator mit IADS-Zielen verbinden
- [ ] AI Director mit IADS-Zustand verbinden
- [ ] Skynet-IADS-Anbindung kapseln
- [ ] IADS-System in DCS testen

### Ergebnis

SEAD/DEAD-Missionen haben strategische Wirkung.

Die rote Luftverteidigung ist Teil des dynamischen Kampagnenzustands.

---

## Phase 8 — UI und F10-Menüs

### Ziel

Spieler sollen Theater Command DCS im Spiel verstehen und bedienen können.

### Vorhandene Dateien

- [x] `src/ui/README.md`

### Geplante Dateien

- [ ] `src/ui/tc_f10_menu.lua`
- [ ] `src/ui/tc_status_display.lua`
- [ ] `src/ui/tc_mission_menu.lua`
- [ ] `src/ui/tc_logistics_menu.lua`
- [ ] `src/ui/tc_debug_menu.lua`

### Aufgaben

- [x] UI-Bereich dokumentieren
- [ ] F10-Menü-Grundstruktur vorbereiten
- [ ] Kampagnenstatus anzeigen
- [ ] verfügbare Missionen anzeigen
- [ ] aktive Missionen anzeigen
- [ ] Logistikstatus anzeigen
- [ ] FOB-Status anzeigen
- [ ] AI-Status anzeigen
- [ ] IADS-Status anzeigen
- [ ] Spielerkommandos vorbereiten
- [ ] Debug-Menü klar getrennt vorbereiten
- [ ] UI in DCS testen

### Ergebnis

Spieler können Missionen, Status und einfache Kommandos später über F10-Menüs erreichen.

---

## Phase 9 — Debug-System

### Ziel

Interne Zustände sollen sichtbar und testbar werden.

### Vorhandene Dateien

- [x] `src/debug/README.md`

### Geplante Dateien

- [ ] `src/debug/tc_debug_console.lua`
- [ ] `src/debug/tc_debug_state_dump.lua`
- [ ] `src/debug/tc_debug_zone_overlay.lua`
- [ ] `src/debug/tc_debug_airbase_report.lua`
- [ ] `src/debug/tc_debug_mission_report.lua`
- [ ] `src/debug/tc_debug_logistics_report.lua`
- [ ] `src/debug/tc_debug_ai_report.lua`
- [ ] `src/debug/tc_debug_iads_report.lua`

### Aufgaben

- [x] Debug-Bereich dokumentieren
- [ ] Debug-State vorbereiten
- [ ] State-Dumps vorbereiten
- [ ] Airbase-Reports vorbereiten
- [ ] Zonen-Reports vorbereiten
- [ ] Capture-Reports vorbereiten
- [ ] Logistik-Reports vorbereiten
- [ ] Missions-Reports vorbereiten
- [ ] AI-Reports vorbereiten
- [ ] IADS-Reports vorbereiten
- [ ] Debug deaktivierbar machen
- [ ] Debug in DCS testen

### Ergebnis

Entwicklung und Fehlersuche werden kontrollierbar.

Debug bleibt klar von produktiver Kampagnenlogik getrennt.

---

## Phase 10 — Persistenz

### Ziel

Der Kampagnenzustand soll über Sessions hinweg erhalten bleiben.

### Vorhandene Dateien

- [x] `src/campaign/tc_persistence_system.lua`

### Geplante Dateien

- [ ] `save/README.md`
- [ ] `save/example_state.lua`

### Zu speichernde Werte

- Besitzer jeder Basis
- Besitzer jeder Gefechtszone
- Ressourcen je Basis
- Garnison je Basis
- Runway-Zustand
- Radarstatus
- IADS-Sektoren
- aktive FOBs
- zerstörte strategische Ziele
- Kampagnenphase
- KI-Verluste
- Spieler-Erfolge
- aktive Missionshistorie

### Aufgaben

- [x] In-Memory-Persistenz vorbereiten
- [x] State-Snapshot vorbereiten
- [x] State-Export vorbereiten
- [x] State-Import vorbereiten
- [x] Lua-String-Export vorbereiten
- [ ] Speicherstruktur definieren
- [ ] Beispiel-Save-State erstellen
- [ ] DCS-Dateizugriff gesondert prüfen
- [ ] Kampagnenzustand serialisieren
- [ ] Kampagnenzustand laden
- [ ] Airbase-Besitz speichern
- [ ] Logistikstatus speichern
- [ ] IADS-Zustand speichern
- [ ] Missionsfortschritt speichern

### Ergebnis

Die Kampagne kann nach einem Serverneustart weitergeführt werden.

---

## Phase 11 — Mission-Editor-DEV-Mission

### Ziel

Eine erste schlanke DCS-Entwicklungsmission als technische Bühne erstellen.

### Geplante Mission

    Operation_Levant_Reclamation_DEV.miz

### Aufgaben

- [ ] Syria Map als neue Mission öffnen
- [ ] Mission unter `mission/dev/` ablegen
- [ ] Koalitionen festlegen
- [ ] Akrotiri als blaue Startbasis nutzen
- [ ] syrisches Festland initial rot kontrolliert anlegen
- [ ] erste Spieler-Slots auf Akrotiri anlegen
- [ ] erste CTLD-Pickup-Zonen auf Akrotiri anlegen
- [ ] erste Template-Gruppen mit Late Activation anlegen
- [ ] erste Framework-Lade-Trigger vorbereiten
- [ ] `src/loader.lua` als letzte eigene Datei laden
- [ ] erster Starttest mit `dcs.log`-Kontrolle durchführen

### Ergebnis

Die erste DEV-Mission lädt Frameworks und Theater Command in definierter Reihenfolge.

Danach kann die Lua-Logik im echten DCS-Kontext getestet werden.

---

## Phase 12 — Balancing, Testing und Polishing

### Ziel

Das System spielbar, verständlich und performant machen.

### Aufgaben

- [ ] Testplan erstellen
- [ ] F10-Menüs aufräumen
- [ ] Debug-Funktionen strukturieren
- [ ] Performance testen
- [ ] Missionen balancen
- [ ] Briefings schreiben
- [ ] Kneeboard-Seiten erstellen
- [ ] Release-Version vorbereiten
- [ ] Dokumentation aktualisieren
- [ ] Changelog pflegen

### Ergebnis

Operation Levant Reclamation wird als erste spielbare Kampagne nutzbar.

---

## Phase 13 — Release-Struktur

### Ziel

Eine saubere Struktur für Entwicklungs-, Test- und Release-Versionen schaffen.

### Geplante Ordner

    mission/dev/
    mission/test/
    mission/release/
    tools/
    assets/
    save/

### Aufgaben

- [ ] DEV-Mission getrennt halten
- [ ] Test-Missionen getrennt halten
- [ ] Release-Missionen getrennt halten
- [ ] Build-Notizen anlegen
- [ ] Release-Checkliste anlegen
- [ ] Assets strukturieren
- [ ] Beispiel-Speicherstand bereitstellen

### Ergebnis

Das Projekt kann kontrolliert weiterentwickelt, getestet und später veröffentlicht werden.

---

## Entwicklungsregel

Jede Phase wird einzeln gebaut und getestet.

Es wird nicht alles gleichzeitig umgesetzt.

Arbeitsreihenfolge:

    Erst Dokumentation.
    Dann Vendor abschließen.
    Dann src-Struktur.
    Dann Core.
    Dann Airbases.
    Dann Zonen.
    Dann Capture.
    Dann Logistik.
    Dann Missionen.
    Dann KI.
    Dann IADS.
    Dann UI.
    Dann Debug.
    Dann Persistenz vertiefen.
    Dann DEV-Mission.
    Dann Testing.
    Dann Release-Struktur.

---

## Aktueller nächster Schritt

Nach dieser Roadmap-Aktualisierung wird die nächste zentrale Dokumentationsdatei aktualisiert.

Nächste Datei:

    ARCHITECTURE.md

Danach:

    README.md

Anschließender technischer Fokus:

    src/main.lua gegen aktuelle Modulnamen prüfen

Grund:

Die Source-Struktur ist inzwischen deutlich weiter als die alte zentrale Dokumentation. Erst nach dem Dokumentationsabgleich sollte der technische Startpfad geprüft und dann in DCS getestet werden.
