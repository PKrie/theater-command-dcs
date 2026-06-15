# Roadmap

Diese Roadmap beschreibt die geplanten Entwicklungsphasen für **Theater Command DCS** und die erste Kampagne **Operation Levant Reclamation**.

Das Projekt wird schrittweise aufgebaut.

Jede Phase soll einzeln dokumentiert, umgesetzt und getestet werden, bevor die nächste Phase begonnen wird.

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

Stand:

    2026-06-15

Aktuell abgeschlossen:

- Repository erstellt
- zentrale Dokumentationsdateien angelegt
- `docs/`-Grundblock erstellt
- `vendor/`-Grundstruktur erstellt
- MIST importiert
- MOOSE importiert
- CTLD importiert
- Skynet IADS importiert
- `src/README.md` angelegt
- falsch platzierte Root-`Moose.lua` entfernt
- Root-`README.md` auf aktuellen Vendor-Stand gebracht

Aktueller Fokus:

    Dokumentation nach Vendor-Import aktualisieren

Noch nicht begonnen:

- eigene Lua-Core-Dateien
- `src/loader.lua`
- `src/main.lua`
- Airbase-Scanner
- Capture-System
- Logistik-Anbindung
- Missionsgenerator
- AI Director
- Persistenz
- Mission-Editor-DEV-Mission

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

---

## Geplante Lade-Reihenfolge

Die geplante Lade-Reihenfolge im DCS Mission Editor lautet:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua
    6. src/loader.lua

Eigene Theater-Command-Logik startet erst nach den externen Frameworks.

---

## Entwicklungsphasen

Die Roadmap ist in technische Entwicklungsphasen unterteilt.

Die Phasen beschreiben die Zielrichtung.

Die konkrete Umsetzung erfolgt später über `TASKS.md`.

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
- [ ] zentrale Dokumentation nach Vendor-Import aktualisieren
- [ ] `TASKS.md` nach Vendor-Abschluss final aktualisieren
- [ ] `CHANGELOG.md` nach Vendor-Abschluss aktualisieren

### Ergebnis

    Das Projekt ist sauber dokumentiert.
    Die externen Frameworks sind lokal unter vendor/ hinterlegt.
    Die eigene Lua-Struktur kann danach beginnen.

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

### Geplante Dateien

    src/loader.lua
    src/main.lua
    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
    src/core/tc_utils.lua
    src/core/tc_scheduler.lua

### Aufgaben

- `src/`-Unterordner vollständig vorbereiten
- README-Dateien für alle `src/`-Unterordner erstellen
- globale `TC`-Tabelle anlegen
- zentrale Konfiguration vorbereiten
- Logger für `dcs.log` erstellen
- globalen Kampagnen-State vorbereiten
- Lade-Reihenfolge der eigenen Lua-Dateien festlegen
- Framework-Verfügbarkeit prüfen
- erste Debug-Ausgabe im DCS-Log erzeugen
- erstes einfaches F10-Debugmenü vorbereiten

### Ergebnis

    Theater Command startet sichtbar im DCS-Log.
    Die eigene Lua-Struktur ist modular vorbereitet.
    Der Projektstatus kann später über F10 angezeigt werden.

---

## Phase 2 — Airbase- und Zonen-System

### Ziel

Alle relevanten Airbases der Syria Map automatisch erkennen und daraus eigene strategische BaseNodes sowie virtuelle Zonen erzeugen.

### Geplante Dateien

    src/world/tc_airbase_scanner.lua
    src/world/tc_airbase_registry.lua
    src/world/tc_airbase_overrides.lua
    src/world/tc_region_classifier.lua
    src/world/tc_zone_factory.lua
    src/world/tc_zone_registry.lua
    src/debug/tc_debug_airbases.lua
    src/debug/tc_debug_zones.lua

### Aufgaben

- alle DCS-Airbases automatisch scannen
- Name, Position, Koalition und Kategorie erfassen
- Airbases als eigene BaseNodes registrieren
- Akrotiri als blaue HQ-Basis definieren
- syrisches Festland initial als rot kontrolliert definieren
- virtuelle Capture-Zonen erzeugen
- virtuelle Logistik-Zonen erzeugen
- virtuelle Defense-Zonen erzeugen
- problematische Basen über Overrides feinjustieren
- Debug-Ausgabe für erkannte Airbases erstellen
- Debug-Ausgabe für virtuelle Zonen erstellen

### Ergebnis

    Die Map wird automatisch als strategisches Basensystem erkannt.
    Manuelle Triggerzonen pro Airbase sind nicht nötig.

---

## Phase 3 — Besitz- und Capture-System

### Ziel

Basen und Gefechtszonen sollen durch Theater-Command-Logik erobert, verloren und bewertet werden können.

### Geplante Dateien

    src/campaign/tc_base_ownership.lua
    src/campaign/tc_capture_system.lua
    src/campaign/tc_campaign_state.lua
    src/campaign/tc_frontline_system.lua

### Aufgaben

- DCS-AutoCapture deaktivieren oder umgehen
- Besitz durch eigenes System steuern
- Blau/Rot/Neutral-Status definieren
- Capture-Bedingungen definieren
- Garnisonen auswerten
- Supply-Status auswerten
- Bodentruppen in Capture-Zonen auswerten
- CTLD-Lieferungen in Capture-Logik einbinden
- Basiswechsel per Lua-State speichern
- Airbase-Koalition später per Script setzen
- Capture-Debugausgabe vorbereiten

### Ergebnis

    Basen wechseln nicht zufällig, sondern nur durch Theater-Command-Logik.
    Der Kampagnenfortschritt wird strategisch nachvollziehbar.

---

## Phase 4 — CTLD- und Logistiksystem

### Ziel

CTLD soll nicht nur Zusatzfunktion sein, sondern ein wichtiger Teil des Kampagnenfortschritts werden.

### Geplante Dateien

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua
    src/logistics/tc_logistics_state.lua
    src/logistics/tc_logistics_hubs.lua
    src/logistics/tc_supply_routes.lua
    src/ui/tc_f10_menu.lua
    src/debug/tc_debug_logistics.lua

### Aufgaben

- CTLD-Grundkonfiguration vorbereiten
- Akrotiri als Start-Logistikhub definieren
- erste Pickup-Zonen für Akrotiri vorbereiten
- erste Dropoff-Zonen vorbereiten
- eroberte Basen als neue Hubs freischalten
- Kistenlieferungen auswerten
- Truppentransport auswerten
- FOB-Aufbau ermöglichen
- Logistikstatus in den Kampagnen-State schreiben
- Verbindung zwischen CTLD und Capture-System vorbereiten

### Ergebnis

    Heli-Spieler können den Frontverlauf durch Truppen- und Kistenlieferungen real beeinflussen.
    Logistik wird kampagnenrelevant.

---

## Phase 5 — Missionsgenerator

### Ziel

Spieler erhalten abhängig von Flugzeugtyp, Kampagnenzustand und Weltlage sinnvolle Missionen.

### Geplante Dateien

    src/missions/tc_mission_generator.lua
    src/missions/tc_mission_registry.lua
    src/missions/tc_mission_types.lua
    src/missions/tc_mission_filter_by_aircraft.lua
    src/missions/tc_mission_air_superiority.lua
    src/missions/tc_mission_sead_dead.lua
    src/missions/tc_mission_strike.lua
    src/missions/tc_mission_cas.lua
    src/missions/tc_mission_logistics.lua
    src/missions/tc_mission_csar.lua
    src/missions/tc_mission_recon.lua

### Aufgaben

- Spielerflugzeug erkennen
- Missionstypen nach Flugzeug filtern
- lageabhängige Missionen erzeugen
- Missionen über F10-Menü auswählbar machen
- Missionsziele erstellen
- Airbase-Ziele aus Kampagnenzustand ableiten
- SEAD/DEAD-Ziele aus IADS-Zustand ableiten
- Logistikmissionen aus Logistikzustand ableiten
- Missionsabschluss auswerten
- Auswirkungen auf Kampagnenzustand speichern

### Ergebnis

    F/A-18C bekommt SEAD, Strike und CAP.
    A-10C bekommt CAS.
    Helis bekommen CTLD, FOB und CSAR.
    F-14B bekommt Fleet CAP, Intercept und Escort.
    Missionen entstehen aus der aktuellen Kampagnenlage.

---

## Phase 6 — KI-System und AI Director

### Ziel

Die Welt soll auch ohne Spieler aktiv und reaktionsfähig wirken.

### Geplante Dateien

    src/ai/tc_ai_director.lua
    src/ai/tc_ai_cap_manager.lua
    src/ai/tc_ai_gci_manager.lua
    src/ai/tc_ai_strike_manager.lua
    src/ai/tc_ai_cas_manager.lua
    src/ai/tc_ai_ground_war.lua
    src/ai/tc_ai_counterattack.lua

### Aufgaben

- KI-Missionen lageabhängig erzeugen
- CAP/GCI nach Basisstatus steuern
- rote Reaktionen auf blaue Erfolge erzeugen
- Gegenangriffe vorbereiten
- Konvois bewegen
- Ressourcenverbrauch durch KI einbauen
- Frontdruck simulieren
- KI-Reaktionen auf Capture-Ereignisse vorbereiten
- KI-Reaktionen auf IADS-Schäden vorbereiten

### Ergebnis

    Die Kampagne läuft dynamisch weiter.
    Spieler beeinflussen Teilbereiche, aber die Welt wirkt eigenständig.

---

## Phase 7 — IADS-System

### Ziel

Skynet IADS mit der Theater-Command-Kampagnenlogik verbinden.

### Geplante Dateien

    src/iads/tc_iads_network.lua
    src/iads/tc_iads_sites.lua
    src/iads/tc_iads_sectors.lua
    src/iads/tc_iads_state.lua
    src/iads/tc_iads_config.lua
    src/iads/tc_iads_damage_handler.lua
    src/iads/tc_iads_rebuild_system.lua
    src/debug/tc_debug_iads.lua

### Aufgaben

- rote IADS-Sektoren vorbereiten
- Radar-/SAM-Gruppen mit Regionen koppeln
- SAM-Stellungen als Kampagnenobjekte definieren
- Radarstellungen als Kampagnenobjekte definieren
- zerstörte Radarstellungen auswerten
- beschädigte Sektoren schwächen
- Reparatur über Ressourcen und Logistik ermöglichen
- SEAD/DEAD-Erfolge dauerhaft in den State schreiben
- Missionsgenerator mit IADS-Zielen verbinden
- AI Director mit IADS-Zustand verbinden

### Ergebnis

    SEAD/DEAD-Missionen haben strategische Wirkung.
    Die rote Luftverteidigung ist Teil des dynamischen Kampagnenzustands.

---

## Phase 8 — Persistenz

### Ziel

Der Kampagnenzustand soll über Sessions hinweg erhalten bleiben.

### Geplante Dateien

    src/campaign/tc_persistence_system.lua
    save/README.md
    save/example_state.lua

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

- Speicherstruktur definieren
- Beispiel-Save-State erstellen
- Kampagnenzustand serialisieren
- Kampagnenzustand laden
- Airbase-Besitz speichern
- Logistikstatus speichern
- IADS-Zustand speichern
- Missionsfortschritt speichern

### Ergebnis

    Die Kampagne kann nach einem Serverneustart weitergeführt werden.

---

## Phase 9 — Mission-Editor-DEV-Mission

### Ziel

Eine erste schlanke DCS-Entwicklungsmission als technische Bühne erstellen.

### Geplante Mission

    Operation_Levant_Reclamation_DEV.miz

### Aufgaben

- Syria Map als neue Mission öffnen
- Mission unter `mission/dev/` ablegen
- Koalitionen festlegen
- Akrotiri als blaue Startbasis nutzen
- syrisches Festland initial rot kontrolliert anlegen
- erste Spieler-Slots auf Akrotiri anlegen
- erste CTLD-Pickup-Zonen auf Akrotiri anlegen
- erste Template-Gruppen mit Late Activation anlegen
- erste Framework-Lade-Trigger vorbereiten
- erste Testumgebung für `src/loader.lua` vorbereiten

### Ergebnis

    Die erste DEV-Mission lädt Frameworks und Theater Command in definierter Reihenfolge.
    Danach kann die Lua-Logik im echten DCS-Kontext getestet werden.

---

## Phase 10 — Balancing, Testing und Polishing

### Ziel

Das System spielbar, verständlich und performant machen.

### Aufgaben

- Testplan erstellen
- F10-Menüs aufräumen
- Debug-Funktionen strukturieren
- Performance testen
- Missionen balancen
- Briefings schreiben
- Kneeboard-Seiten erstellen
- Release-Version vorbereiten
- Dokumentation aktualisieren
- Changelog pflegen

### Ergebnis

    Operation Levant Reclamation wird als erste spielbare Kampagne nutzbar.

---

## Phase 11 — Release-Struktur

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

- DEV-Mission getrennt halten
- Test-Missionen getrennt halten
- Release-Missionen getrennt halten
- Build-Notizen anlegen
- Release-Checkliste anlegen
- Assets strukturieren
- Beispiel-Speicherstand bereitstellen

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
    Dann CTLD-Anbindung.
    Dann Missionen.
    Dann KI.
    Dann IADS.
    Dann Persistenz.
    Dann DEV-Mission.
    Dann Testing.
    Dann Release-Struktur.

---

## Aktueller nächster Schritt

Nach dieser Roadmap-Aktualisierung wird die nächste zentrale Dokumentationsdatei aktualisiert.

Empfohlene Reihenfolge:

    1. TASKS.md
    2. CHANGELOG.md
    3. ARCHITECTURE.md
    4. vendor/README.md
    5. docs/02_technical_architecture.md
    6. docs/03_mission_editor_basics.md
    7. docs/05_logistics_system.md
    8. docs/08_iads_system.md

Danach ist die Dokumentation wieder konsistent genug, um in der nächsten Session mit `src/` weiterzumachen.
