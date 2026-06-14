# Roadmap

Diese Roadmap beschreibt die geplanten Entwicklungsphasen für **Theater Command DCS** und die erste Kampagne **Operation Levant Reclamation**.

Das Projekt soll schrittweise aufgebaut werden. Jede Phase soll einzeln getestet werden, bevor die nächste Phase ergänzt wird.

---

## Phase 0 — Projektgrundlage

### Ziel

Repository, Dokumentation und Missionsgrundlage sauber aufsetzen.

### Aufgaben

- GitHub-Repository erstellen
- Grundlegende Projektstruktur anlegen
- README.md erstellen
- ROADMAP.md erstellen
- TASKS.md erstellen
- ARCHITECTURE.md erstellen
- MISSION_EDITOR_SETUP.md erstellen
- NAMING_CONVENTIONS.md erstellen
- LUA_STYLEGUIDE.md erstellen
- Syria-DEV-Mission im DCS Mission Editor erstellen
- Akrotiri als blaue Startbasis vorbereiten
- Erste Spieler-Slots auf Akrotiri anlegen
- Framework-Lade-Trigger vorbereiten
- Erste Template-Gruppen anlegen
- Erste CTLD-Pickup-Zonen auf Akrotiri anlegen

### Ergebnis

```text
Das Projekt ist auf GitHub strukturiert.
Die Grundidee ist dokumentiert.
Die erste DCS-Entwicklungsmission kann vorbereitet werden.
```

---

## Phase 1 — Core-System

### Ziel

Theater Command als eigenes Lua-System initialisieren.

### Geplante Dateien

```text
src/loader.lua
src/main.lua
src/core/tc_config.lua
src/core/tc_logger.lua
src/core/tc_state.lua
src/core/tc_utils.lua
src/core/tc_scheduler.lua
```

### Aufgaben

- globale `TC`-Tabelle anlegen
- zentrale Konfiguration vorbereiten
- Logger für `dcs.log` erstellen
- globalen Kampagnen-State vorbereiten
- Lade-Reihenfolge der eigenen Lua-Dateien festlegen
- erste Debug-Ausgabe im DCS-Log erzeugen
- erstes einfaches F10-Debugmenü vorbereiten

### Ergebnis

```text
Theater Command startet sichtbar im DCS-Log.
Der Projektstatus kann später über F10 angezeigt werden.
```

---

## Phase 2 — Airbase- und Zonen-System

### Ziel

Alle Airbases der Syria Map automatisch erkennen und daraus eigene strategische BaseNodes sowie virtuelle Zonen erzeugen.

### Geplante Dateien

```text
src/world/tc_airbase_scanner.lua
src/world/tc_airbase_registry.lua
src/world/tc_airbase_overrides.lua
src/world/tc_region_classifier.lua
src/world/tc_zone_factory.lua
src/debug/tc_debug_airbases.lua
src/debug/tc_debug_zones.lua
```

### Aufgaben

- alle DCS-Airbases automatisch scannen
- Name, Position, Koalition und Kategorie erfassen
- Airbases als eigene BaseNodes registrieren
- Akrotiri als blaue HQ-Basis definieren
- syrisches Festland als rot definieren
- virtuelle Capture-Zonen erzeugen
- virtuelle Logistik-Zonen erzeugen
- virtuelle Defense-Zonen erzeugen
- problematische Basen über Overrides feinjustieren
- Debug-Ausgabe für erkannte Airbases erstellen

### Ergebnis

```text
Die Map wird automatisch als strategisches Basensystem erkannt.
Manuelle Triggerzonen pro Airbase sind nicht nötig.
```

---

## Phase 3 — Besitz- und Capture-System

### Ziel

Basen und Gefechtszonen sollen durch Kampagnenlogik erobert werden können.

### Geplante Dateien

```text
src/campaign/tc_base_ownership.lua
src/campaign/tc_capture_system.lua
src/campaign/tc_frontline_system.lua
```

### Aufgaben

- DCS-AutoCapture deaktivieren
- Besitz durch eigenes System steuern
- Capture-Bedingungen definieren
- Garnisonen auswerten
- Supply-Status auswerten
- Bodentruppen in Capture-Zonen auswerten
- CTLD-Lieferungen in Capture-Logik einbinden
- Basiswechsel per Lua-State speichern
- Airbase-Koalition per Script setzen

### Ergebnis

```text
Basen wechseln nicht zufällig, sondern nur durch Theater-Command-Logik.
```

---

## Phase 4 — CTLD- und Logistiksystem

### Ziel

CTLD soll nicht nur Zusatzfunktion sein, sondern das Rückgrat der Kampagne.

### Geplante Dateien

```text
src/logistics/tc_ctld_config.lua
src/logistics/tc_logistics_hubs.lua
src/logistics/tc_logistics_delivery.lua
src/logistics/tc_fob_system.lua
src/logistics/tc_supply_routes.lua
src/logistics/tc_convoy_system.lua
src/logistics/tc_warehouse_system.lua
```

### Aufgaben

- CTLD-Grundkonfiguration erstellen
- Akrotiri als Start-Logistikhub definieren
- eroberte Basen als neue Hubs freischalten
- Kistenlieferungen auswerten
- Truppentransport auswerten
- FOB-Aufbau ermöglichen
- Ressourcenmodell für Supply, Fuel, Ammo, Repair und Manpower aufbauen
- Konvoirouten vorbereiten
- Logistikstatus in den Kampagnen-State schreiben

### Ergebnis

```text
Heli-Spieler können den Frontverlauf durch Truppen- und Kistenlieferungen real beeinflussen.
```

---

## Phase 5 — Missionsgenerator

### Ziel

Spieler erhalten abhängig von Flugzeugtyp und Weltzustand sinnvolle Missionen.

### Geplante Dateien

```text
src/missions/tc_mission_generator.lua
src/missions/tc_mission_filter_by_aircraft.lua
src/missions/tc_mission_air_superiority.lua
src/missions/tc_mission_sead_dead.lua
src/missions/tc_mission_strike.lua
src/missions/tc_mission_cas.lua
src/missions/tc_mission_logistics.lua
src/missions/tc_mission_csar.lua
src/missions/tc_mission_recon.lua
```

### Aufgaben

- Spielerflugzeug erkennen
- Missionstypen nach Flugzeug filtern
- lageabhängige Missionen erzeugen
- Missionen über F10-Menü auswählbar machen
- Missionsziele erstellen
- Missionsabschluss auswerten
- Auswirkungen auf Kampagnenzustand speichern

### Ergebnis

```text
F/A-18C bekommt SEAD/Strike/CAP.
A-10C bekommt CAS.
Helis bekommen CTLD/CSAR.
F-14B bekommt Fleet CAP, Intercept und Escort.
```

---

## Phase 6 — KI-System und AI Director

### Ziel

Die Welt soll auch ohne Spieler aktiv wirken.

### Geplante Dateien

```text
src/ai/tc_ai_director.lua
src/ai/tc_ai_cap_manager.lua
src/ai/tc_ai_gci_manager.lua
src/ai/tc_ai_strike_manager.lua
src/ai/tc_ai_cas_manager.lua
src/ai/tc_ai_ground_war.lua
src/ai/tc_ai_counterattack.lua
```

### Aufgaben

- KI-Missionen lageabhängig erzeugen
- CAP/GCI nach Basisstatus steuern
- Gegenangriffe starten
- Konvois bewegen
- rote Reaktionen auf blaue Erfolge erzeugen
- Ressourcenverbrauch durch KI einbauen
- Frontdruck simulieren

### Ergebnis

```text
Die Kampagne läuft dynamisch weiter, auch wenn Spieler nur Teilbereiche beeinflussen.
```

---

## Phase 7 — IADS-System

### Ziel

Skynet IADS mit Kampagnenlogik verbinden.

### Geplante Dateien

```text
src/iads/tc_iads_config.lua
src/iads/tc_iads_sector_manager.lua
src/iads/tc_iads_damage_handler.lua
src/iads/tc_iads_rebuild_system.lua
```

### Aufgaben

- IADS-Sektoren definieren
- Radar-/SAM-Gruppen mit Regionen koppeln
- zerstörte Radarstellungen auswerten
- beschädigte Sektoren schwächen
- Reparatur über Ressourcen/Logistik ermöglichen
- SEAD/DEAD-Erfolge dauerhaft in den State schreiben

### Ergebnis

```text
SEAD/DEAD-Missionen haben strategische Wirkung.
```

---

## Phase 8 — Persistenz

### Ziel

Der Kampagnenzustand soll über Sessions hinweg erhalten bleiben.

### Geplante Dateien

```text
src/campaign/tc_persistence_system.lua
save/example_state.lua
```

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

### Ergebnis

```text
Die Kampagne kann nach einem Serverneustart weitergeführt werden.
```

---

## Phase 9 — Balancing und Polishing

### Ziel

Das System spielbar, verständlich und performant machen.

### Aufgaben

- F10-Menüs aufräumen
- Briefings schreiben
- Kneeboard-Seiten erstellen
- Performance testen
- Missionen balancen
- Debug-Funktionen reduzieren
- Release-Version vorbereiten
- Dokumentation aktualisieren

### Ergebnis

```text
Operation Levant Reclamation ist als erste spielbare Kampagne nutzbar.
```

---

## Entwicklungsregel

Jede Phase wird einzeln gebaut und getestet.

Es wird nicht alles gleichzeitig umgesetzt.

```text
Erst Grundsystem.
Dann Airbases.
Dann Zonen.
Dann Capture.
Dann CTLD.
Dann Missionen.
Dann KI.
Dann IADS.
Dann Persistenz.
``
