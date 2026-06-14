# Lua Styleguide

Diese Datei beschreibt die Lua-Schreibregeln für Theater Command DCS.

Ziel ist, dass alle selbst geschriebenen Skripte übersichtlich, modular und langfristig wartbar bleiben.

---

## Grundregel

Jede Lua-Datei erfüllt genau eine klare Aufgabe.

Keine Datei wird zur Sammelstelle für mehrere Systeme.

Nicht erwünscht:

tc_moose.lua
tc_mist.lua
tc_ctld.lua
tc_all_in_one.lua
mission_script.lua

Stattdessen:

tc_airbase_scanner.lua
tc_zone_factory.lua
tc_capture_system.lua
tc_logistics_delivery.lua
tc_fob_system.lua
tc_mission_generator.lua
tc_ai_cap_manager.lua
tc_persistence_system.lua

Die Datei wird nach ihrer Aufgabe benannt, nicht nach dem Framework, das sie intern verwendet.

---

## Projekt-Namespace

Alle eigenen Funktionen und Tabellen hängen an der globalen Tabelle TC.

Grundstruktur:

TC = TC or {}

TC.Core = TC.Core or {}
TC.World = TC.World or {}
TC.Campaign = TC.Campaign or {}
TC.Logistics = TC.Logistics or {}
TC.Missions = TC.Missions or {}
TC.AI = TC.AI or {}
TC.IADS = TC.IADS or {}
TC.UI = TC.UI or {}
TC.Debug = TC.Debug or {}

---

## Dateiaufbau

Jede Lua-Datei beginnt mit einem Header.

Beispiel:

-- ============================================================================
-- Theater Command DCS
-- File: tc_airbase_scanner.lua
-- Purpose: Scans all DCS airbases and registers them for the campaign system.
-- ============================================================================

Danach folgt die Initialisierung des passenden Namespace.

Beispiel:

TC = TC or {}
TC.World = TC.World or {}

---

## Funktionsnamen

Funktionen werden eindeutig und lesbar benannt.

Format:

TC.System.FunctionName()

Beispiele:

TC.World.ScanAirbases()
TC.World.CreateAirbaseZones()
TC.Campaign.UpdateCaptureState()
TC.Logistics.RegisterDelivery()
TC.Missions.GenerateForPlayer()
TC.AI.SpawnCAP()
TC.IADS.UpdateSectorStatus()
TC.UI.BuildF10Menu()

---

## Dateigrößen-Regel

Jede Datei soll klein und übersichtlich bleiben.

Richtwerte:

Ideal: 100 bis 250 Zeilen
Noch okay: bis 400 Zeilen
Warnbereich: ab 500 Zeilen
Aufteilen: ab 700 Zeilen

Wenn eine Datei zu groß wird, wird sie in mehrere kleinere Dateien aufgeteilt.

Beispiel:

tc_logistics_system.lua wird aufgeteilt in:

tc_logistics_hubs.lua
tc_logistics_delivery.lua
tc_fob_system.lua
tc_supply_routes.lua
tc_convoy_system.lua

---

## Keine Framework-Sammeldateien

Theater Command nutzt MOOSE, MIST, CTLD und Skynet IADS als Werkzeuge.

Die Projektstruktur richtet sich aber nach Aufgaben.

Schlecht:

tc_moose.lua enthält CAP, GCI, Spawns, Airbases und Scheduler
tc_ctld.lua enthält Kisten, FOBs, Lieferungen und Hubs

Gut:

tc_ai_cap_manager.lua nutzt MOOSE für CAP
tc_ai_gci_manager.lua nutzt MOOSE für GCI
tc_airbase_scanner.lua nutzt DCS API und optional MOOSE
tc_logistics_delivery.lua nutzt CTLD-Ereignisse und eigene State-Logik
tc_fob_system.lua nutzt CTLD und eigene FOB-Regeln

---

## Logging

Debug- und Statusausgaben sollen später zentral über den Logger laufen.

Geplante Logger-Funktionen:

TC.Logger.Info("Text")
TC.Logger.Warn("Text")
TC.Logger.Error("Text")
TC.Logger.Debug("Text")

Keine wilden Ausgaben überall im Code verteilen.

Nur für frühe Tests erlaubt:

env.info("[TC] Test message")

Später soll auch diese Ausgabe über TC.Logger laufen.

---

## Rückgabewerte

Funktionen sollen möglichst klar zurückgeben, ob sie erfolgreich waren.

Beispiel:

return true

oder:

return false, "No airbase found"

Bei komplexeren Funktionen sollen Status und Fehlermeldung getrennt sein.

---

## Kommentare

Kommentare sollen erklären, warum etwas gemacht wird, nicht jede einzelne offensichtliche Zeile beschreiben.

Gut:

-- Disable native DCS auto-capture because Theater Command controls ownership manually.

Schlecht:

-- Set variable x to 1.

---

## Tabellenstruktur

Tabellen sollen lesbar aufgebaut werden.

Beispiel:

TC.Campaign.State = {
  campaignName = "Operation Levant Reclamation",
  campaignPhase = 0,

  resources = {
    blue = {
      supply = 100,
      fuel = 100,
      ammo = 100
    },

    red = {
      supply = 100,
      fuel = 100,
      ammo = 100
    }
  }
}

---

## Besitzerwerte

Einheitliche interne Besitzerwerte:

blue
red
neutral
contested
locked
inactive

Beispiel:

base.owner = "blue"

Nicht verwenden:

base.owner = "Blue"
base.owner = "BLUFOR"
base.owner = "friendly"

---

## Ressourcenwerte

Einheitliche Ressourcennamen:

supply
fuel
ammo
manpower
repair
medical
command

Beispiel:

base.resources = {
  supply = 100,
  fuel = 100,
  ammo = 100,
  manpower = 100,
  repair = 100,
  medical = 50,
  command = 100
}

---

## Module sollen unabhängig testbar sein

Jedes System soll möglichst einzeln testbar sein.

Beispiele:

Airbase-Scanner kann getestet werden, bevor Capture existiert.
Zonen-System kann getestet werden, bevor CTLD existiert.
CTLD-Lieferungen können getestet werden, bevor Persistenz existiert.
Missionsgenerator kann zuerst einfache Testmissionen erzeugen.

---

## Fehlerbehandlung

Wenn ein System eine Voraussetzung nicht findet, soll es nicht still fehlschlagen.

Beispiel:

Wenn CTLD nicht geladen ist:

TC.Logger.Error("CTLD is not available. Logistics system cannot start.")
return false

Wenn keine Airbases gefunden werden:

TC.Logger.Warn("No airbases detected.")
return false

---

## Loader-Prinzip

Die Datei src/loader.lua lädt alle eigenen Projektdateien in definierter Reihenfolge.

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

Keine Datei soll davon ausgehen, dass ein später geladenes System bereits verfügbar ist.

---

## Keine parallelen Großbaustellen

Die Entwicklung erfolgt in klaren Schritten:

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

Erst wenn ein System grundsätzlich funktioniert, wird das nächste System ergänzt.

---

## Ziel

Dieser Styleguide soll verhindern, dass Theater Command DCS zu einer unübersichtlichen Sammlung großer Lua-Dateien wird.

Das Projekt soll modular, lesbar, testbar und langfristig erweiterbar bleiben.
