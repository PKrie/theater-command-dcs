# Technical Architecture

Diese Datei beschreibt die technische Grundarchitektur von **Theater Command DCS**.

Das Projekt soll eine persistente, dynamische DCS-Kampagne auf der Syria Map ermöglichen. Die erste Kampagne trägt den Arbeitstitel **Operation Levant Reclamation**.

---

## Grundsatz

Theater Command DCS ist ein eigenes modulares Kampagnensystem.

Externe Frameworks werden nur als Bibliotheken genutzt.

Die Frameworks werden nicht verändert.

Struktur:

- `vendor/` enthält externe Bibliotheken
- `src/` enthält eigene Lua-Projektlogik
- `docs/` enthält Dokumentation
- `mission/` enthält DCS-Missionsdateien
- `mission_editor/` enthält Anleitungen für den DCS Mission Editor
- `save/` enthält Beispiele und später Save-State-Dokumentation
- `tools/` enthält Test- und Release-Hilfen

---

## Leitprinzip

Mission Editor = Bühne  
Lua = Kampagnensystem  
GitHub = Projektgedächtnis  

Der Mission Editor stellt nur die physische Grundmission bereit.

Die eigentliche Kampagne entsteht durch Lua-Skripte.

---

## Verwendete Frameworks

### MOOSE

MOOSE wird genutzt für:

- Airbase-Wrapper
- Zonenobjekte
- SETs
- Scheduler
- Spawning
- CAP/GCI
- AI-Management
- dynamische Missionslogik

MOOSE ist nicht die Projektarchitektur, sondern ein Werkzeug innerhalb der Projektarchitektur.

---

### MIST

MIST wird genutzt für:

- DCS-Hilfsfunktionen
- Datenbankfunktionen
- Gruppenlogik
- Koordinatenlogik
- Hilfsfunktionen für dynamische Missionen
- CTLD-Grundvoraussetzung

MIST bleibt eine Utility-Schicht.

---

### CTLD

CTLD wird genutzt für:

- Truppentransport
- Kistenlogistik
- FOB-Aufbau
- Heli-basierte Supply-Operationen
- Spielerinteraktion im Logistiksystem
- Transport von Infanterie, Versorgung, Reparatur und Command-Elementen

CTLD entscheidet nicht über den strategischen Kampagnenzustand.

Theater Command entscheidet, was eine CTLD-Lieferung bewirkt.

Beispiel:

- Kiste abgesetzt
- Theater Command erkennt Lieferung
- Basis oder FOB erhält Supply, Fuel, Ammo oder Repair
- Kampagnenzustand wird aktualisiert

---

### Skynet IADS

Skynet IADS wird genutzt für:

- SAM-Netzwerke
- Radarlogik
- IADS-Sektoren
- Reaktionen auf SEAD/DEAD
- Kopplung von Radar, SAM, Command Post und Infrastruktur

Theater Command koppelt IADS-Sektoren an Regionen, Basen und Infrastrukturzustände.

---

## Systemtrennung

Das Projekt wird nach Aufgaben sortiert, nicht nach Frameworks.

Nicht so:

- `tc_moose.lua`
- `tc_mist.lua`
- `tc_ctld.lua`
- `tc_skynet.lua`

Sondern so:

- `tc_airbase_scanner.lua`
- `tc_zone_factory.lua`
- `tc_capture_system.lua`
- `tc_logistics_delivery.lua`
- `tc_fob_system.lua`
- `tc_mission_generator.lua`
- `tc_ai_cap_manager.lua`
- `tc_persistence_system.lua`

Eine Datei darf intern MOOSE, MIST, CTLD oder Skynet IADS nutzen. Der Dateiname richtet sich aber nach der Aufgabe, nicht nach dem Framework.

---

## Projektbereiche

### `src/core/`

Grundfunktionen des Systems.

Geplante Dateien:

- `tc_config.lua`
- `tc_logger.lua`
- `tc_state.lua`
- `tc_utils.lua`
- `tc_scheduler.lua`

Aufgaben:

- zentrale Konfiguration
- Logging
- globaler Kampagnen-State
- Hilfsfunktionen
- zeitgesteuerte Abläufe

---

### `src/world/`

Welt- und Kartenlogik.

Geplante Dateien:

- `tc_airbase_scanner.lua`
- `tc_airbase_registry.lua`
- `tc_airbase_overrides.lua`
- `tc_region_classifier.lua`
- `tc_zone_factory.lua`
- `tc_route_registry.lua`
- `tc_static_targets.lua`

Aufgaben:

- Airbases automatisch erkennen
- Airbases als BaseNodes registrieren
- Regionen definieren
- virtuelle Zonen erzeugen
- Routen verwalten
- statische Ziele registrieren

---

### `src/campaign/`

Strategische Kampagnenlogik.

Geplante Dateien:

- `tc_base_ownership.lua`
- `tc_capture_system.lua`
- `tc_frontline_system.lua`
- `tc_resource_system.lua`
- `tc_economy_system.lua`
- `tc_persistence_system.lua`

Aufgaben:

- Basenbesitz verwalten
- Capture-System berechnen
- Frontlinien abbilden
- Ressourcen verwalten
- Economy simulieren
- Kampagnenzustand speichern und laden

---

### `src/logistics/`

Logistiksystem.

Geplante Dateien:

- `tc_ctld_config.lua`
- `tc_logistics_hubs.lua`
- `tc_logistics_delivery.lua`
- `tc_fob_system.lua`
- `tc_supply_routes.lua`
- `tc_convoy_system.lua`
- `tc_warehouse_system.lua`

Aufgaben:

- CTLD konfigurieren
- Logistikhubs verwalten
- Lieferungen auswerten
- FOBs aufbauen
- Supply-Routen berechnen
- Konvois verwalten
- Lagerbestände simulieren

---

### `src/missions/`

Dynamischer Missionsgenerator.

Geplante Dateien:

- `tc_mission_generator.lua`
- `tc_mission_filter_by_aircraft.lua`
- `tc_mission_air_superiority.lua`
- `tc_mission_sead_dead.lua`
- `tc_mission_strike.lua`
- `tc_mission_cas.lua`
- `tc_mission_logistics.lua`
- `tc_mission_csar.lua`
- `tc_mission_recon.lua`

Aufgaben:

- Spielerflugzeug erkennen
- passende Missionen erzeugen
- Missionen nach Weltzustand filtern
- Missionen über F10 auswählbar machen
- Erfolg und Misserfolg auswerten
- Kampagnenzustand verändern

---

### `src/ai/`

KI-Steuerung.

Geplante Dateien:

- `tc_ai_director.lua`
- `tc_ai_cap_manager.lua`
- `tc_ai_gci_manager.lua`
- `tc_ai_strike_manager.lua`
- `tc_ai_cas_manager.lua`
- `tc_ai_ground_war.lua`
- `tc_ai_counterattack.lua`

Aufgaben:

- KI-Missionen lageabhängig erzeugen
- CAP verwalten
- GCI verwalten
- Strike-Pakete erzeugen
- CAS-Unterstützung steuern
- Bodenkrieg simulieren
- Gegenangriffe auslösen

---

### `src/iads/`

IADS-System.

Geplante Dateien:

- `tc_iads_config.lua`
- `tc_iads_sector_manager.lua`
- `tc_iads_damage_handler.lua`
- `tc_iads_rebuild_system.lua`

Aufgaben:

- Skynet IADS konfigurieren
- IADS-Sektoren verwalten
- SEAD/DEAD-Schäden auswerten
- Radar- und SAM-Strukturen mit Regionen koppeln
- Wiederaufbau über Ressourcen und Logistik ermöglichen

---

### `src/ui/`

Spielerinterface.

Geplante Dateien:

- `tc_f10_root_menu.lua`
- `tc_f10_mission_menu.lua`
- `tc_f10_status_menu.lua`
- `tc_f10_logistics_menu.lua`
- `tc_briefing_system.lua`

Aufgaben:

- F10-Hauptmenü bereitstellen
- Missionsauswahl anzeigen
- Statusberichte anzeigen
- Logistikstatus anzeigen
- Briefinginformationen bereitstellen

---

### `src/debug/`

Diagnosefunktionen.

Geplante Dateien:

- `tc_debug_airbases.lua`
- `tc_debug_zones.lua`
- `tc_debug_logistics.lua`
- `tc_debug_missions.lua`
- `tc_debug_state.lua`

Aufgaben:

- Airbase-Debug
- Zonen-Debug
- Logistik-Debug
- Missions-Debug
- State-Debug

Debug-Funktionen dienen nur der Entwicklung und sollen später im Release reduziert oder deaktiviert werden.

---

## Mission-Editor-Rolle

Der Mission Editor stellt bereit:

- Syria Map
- Koalitionen
- Spieler-Slots
- Framework-Lade-Trigger
- Template-Gruppen
- wenige Start-CTLD-Zonen
- sichtbare statische Schlüsselziele
- optional Carrier-Gruppe

Der Mission Editor steuert nicht:

- Airbase-Besitz
- Capture
- Logistikstatus
- Ressourcen
- Missionserzeugung
- KI-Reaktionen
- Persistenz
- dynamische Frontlinien

---

## Automatisierung

Alles, was per Script erkennbar oder berechenbar ist, wird nicht manuell im Mission Editor gebaut.

Automatisch per Lua:

- Airbases erkennen
- Airbase-Nodes erzeugen
- virtuelle Capture-Zonen erzeugen
- virtuelle Logistik-Zonen erzeugen
- virtuelle Defense-Zonen erzeugen
- Basenbesitz verwalten
- Missionen erzeugen
- Ressourcen verwalten
- KI-Reaktionen erzeugen
- Persistenz speichern und laden

Manuell im Mission Editor:

- Client-Slots
- Framework-Loader
- Template-Gruppen
- erste CTLD-Startzonen
- sichtbare strategische Ziele
- optional Carrier-Gruppe

---

## Ladeprinzip

Die externen Bibliotheken werden zuerst über Mission-Editor-Trigger geladen.

Danach wird `src/loader.lua` geladen.

`loader.lua` lädt alle eigenen Projektdateien in definierter Reihenfolge.

Geplante Reihenfolge:

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

---

## Globale Lua-Struktur

Alle eigenen Systeme hängen an der globalen Tabelle `TC`.

Geplante Struktur:

- `TC.Core`
- `TC.World`
- `TC.Campaign`
- `TC.Logistics`
- `TC.Missions`
- `TC.AI`
- `TC.IADS`
- `TC.UI`
- `TC.Debug`

Beispiele für spätere Funktionen:

- `TC.World.ScanAirbases()`
- `TC.World.CreateAirbaseZones()`
- `TC.Campaign.UpdateCaptureState()`
- `TC.Logistics.RegisterDelivery()`
- `TC.Missions.GenerateForPlayer()`
- `TC.AI.SpawnCAP()`
- `TC.IADS.UpdateSectorStatus()`
- `TC.UI.BuildF10Menu()`

---

## Dateigrößen-Regel

Jede Lua-Datei soll genau eine klare Aufgabe erfüllen.

Richtwerte:

- Ideal: 100 bis 250 Zeilen
- Noch okay: bis 400 Zeilen
- Warnbereich: ab 500 Zeilen
- Aufteilen: ab 700 Zeilen

Wenn eine Datei zu groß wird, wird sie in mehrere kleinere Dateien aufgeteilt.

---

## Entwicklungsregel

Es wird immer nur ein sinnvoller Schritt nach dem anderen umgesetzt.

Reihenfolge:

1. Dokumentation
2. Grundstruktur
3. Mission-Editor-Basis
4. Lua-Core
5. Airbase-Scanner
6. Zonen-System
7. Capture-System
8. CTLD-Grundlogik
9. Missionsgenerator
10. KI-System
11. IADS-System
12. Persistenz

Keine parallelen Großbaustellen.

---

## Zielbild

Theater Command DCS soll langfristig ein eigenes modulares Kampagnensystem werden, das dynamische Einsätze, persistente Basen, CTLD-Logistik, KI-Gegenreaktionen, IADS-Abnutzung und spielerabhängige Missionsangebote miteinander verbindet.