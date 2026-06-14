# Naming Conventions

Diese Datei beschreibt die Namenskonventionen für Theater Command DCS.

Einheitliche Namen sind wichtig, damit Mission Editor, Lua-Skripte, Templates, Trigger-Zonen und Debug-Ausgaben sauber zusammenarbeiten.

---

## Grundsatz

Alle Namen sollen eindeutig, lesbar und systematisch sein.

Ein Name soll sofort erkennen lassen:

- zu welcher Seite das Objekt gehört
- welche Aufgabe es hat
- wo es eingesetzt wird
- ob es ein Spieler-Slot, Template, Ziel, Zone oder Script-Objekt ist

---

## Allgemeine Präfixe

TC_       = Theater Command allgemein
BLUE_     = blaue Koalition
RED_      = rote Koalition
NEUTRAL_  = neutral
TPL_      = Template-Gruppe
CLIENT_   = Spieler-Slot
ZONE_     = Trigger-Zone
STATIC_   = statisches Ziel
DEPOT_    = Depot
FOB_      = Forward Operating Base
LOGI_     = Logistik
CAP_      = Combat Air Patrol
CAS_      = Close Air Support
SEAD_     = Suppression of Enemy Air Defense
DEAD_     = Destruction of Enemy Air Defense
CONVOY_   = Konvoi
IADS_     = Integrated Air Defense System

---

## Spieler-Slots

Spieler-Slots werden im Mission Editor angelegt.

Format:

CLIENT_<SIDE>_<AIRCRAFT>_<BASE>_<NUMBER>

Beispiele:

CLIENT_BLUE_FA18C_AKROTIRI_01
CLIENT_BLUE_FA18C_AKROTIRI_02
CLIENT_BLUE_F16C_AKROTIRI_01
CLIENT_BLUE_F15E_AKROTIRI_01
CLIENT_BLUE_F14B_AKROTIRI_01
CLIENT_BLUE_UH1H_AKROTIRI_01
CLIENT_BLUE_MI8_AKROTIRI_01

Spätere FOB-Slots:

CLIENT_BLUE_A10C_FOB_ALPHA_01
CLIENT_BLUE_AH64D_FOB_ALPHA_01
CLIENT_BLUE_UH1H_FOB_ALPHA_01
CLIENT_BLUE_MI8_FOB_ALPHA_01

---

## Flugzeugkürzel

Empfohlene Schreibweise für Slotnamen und interne Logik:

FA18C
F16C
F15E
F14B
A10C
AH64D
UH1H
MI8
CH47

Keine Sonderzeichen, keine Leerzeichen und keine Schrägstriche verwenden.

---

## Template-Gruppen

Template-Gruppen werden im Mission Editor angelegt und später per Lua gespawnt.

Format:

TPL_<SIDE>_<ROLE>_<TYPE>_<NUMBER>

Beispiele Rot:

TPL_RED_CAP_MIG29_PAIR_01
TPL_RED_GCI_MIG29_PAIR_01
TPL_RED_INTERCEPT_MIG29_PAIR_01
TPL_RED_CAS_SU25_PAIR_01
TPL_RED_STRIKE_SU24_PAIR_01
TPL_RED_SAM_SA6_SITE_01
TPL_RED_SHORAD_SA8_01
TPL_RED_GARRISON_INF_LIGHT_01
TPL_RED_GARRISON_INF_HEAVY_01
TPL_RED_ARMOR_PLATOON_T72_01
TPL_RED_SUPPLY_CONVOY_01

Beispiele Blau:

TPL_BLUE_CAP_FA18C_PAIR_01
TPL_BLUE_CAP_F16C_PAIR_01
TPL_BLUE_SEAD_FA18C_PAIR_01
TPL_BLUE_SEAD_F16C_PAIR_01
TPL_BLUE_STRIKE_F15E_PAIR_01
TPL_BLUE_CAS_A10C_PAIR_01
TPL_BLUE_ENGINEER_TEAM_01
TPL_BLUE_INF_SQUAD_01
TPL_BLUE_SUPPLY_CONVOY_01

---

## Trigger-Zonen

Trigger-Zonen werden nur dort manuell im Mission Editor angelegt, wo sie wirklich gebraucht werden.

Format:

ZONE_<SIDE>_<LOCATION>_<PURPOSE>

Beispiele:

ZONE_BLUE_AKROTIRI_CTLD_PICKUP
ZONE_BLUE_AKROTIRI_CTLD_TROOP_PICKUP
ZONE_BLUE_AKROTIRI_CTLD_SUPPLY_PICKUP
ZONE_BLUE_AKROTIRI_CTLD_VEHICLE_PICKUP
ZONE_BLUE_BEACHHEAD_ALPHA_DROP
ZONE_BLUE_FOB_ALPHA_SITE
ZONE_RED_KHMEIMIM_DEFENSE

Wichtig:

Nicht jede Airbase bekommt manuell eigene Trigger-Zonen.

Airbase-Zonen werden später virtuell per Lua erzeugt.

---

## Virtuelle Lua-Zonen

Virtuelle Lua-Zonen werden durch Skripte erzeugt und müssen nicht im Mission Editor existieren.

Format:

TC_<ZONE_TYPE>_<AIRBASE_OR_REGION>

Beispiele:

TC_CAPTURE_AKROTIRI
TC_LOGISTICS_AKROTIRI
TC_DEFENSE_AKROTIRI
TC_CAPTURE_KHMEIMIM
TC_LOGISTICS_KHMEIMIM
TC_DEFENSE_KHMEIMIM
TC_CAPTURE_LATAKIA
TC_LOGISTICS_LATAKIA
TC_DEFENSE_LATAKIA

Geplante Zonentypen:

CAPTURE
LOGISTICS
DEFENSE
REPAIR
SPAWN
WAREHOUSE

---

## Statische Ziele

Statische Ziele werden im Mission Editor angelegt, wenn sie sichtbar, angreifbar und zerstörbar sein sollen.

Format:

STATIC_<SIDE>_<LOCATION>_<TYPE>_<NUMBER>

Beispiele:

STATIC_RED_LATAKIA_RADAR_01
STATIC_RED_LATAKIA_AMMO_DEPOT_01
STATIC_RED_LATAKIA_FUEL_DEPOT_01
STATIC_RED_TARTUS_NAVAL_DEPOT_01
STATIC_RED_TARTUS_RADAR_01
STATIC_RED_KHMEIMIM_COMMAND_POST_01
STATIC_RED_KHMEIMIM_FUEL_DEPOT_01
STATIC_RED_KHMEIMIM_AMMO_DEPOT_01
STATIC_BLUE_AKROTIRI_SUPPLY_DEPOT_01

---

## FOBs

Forward Operating Bases werden als eigene logistische Knoten behandelt.

Format:

FOB_<SIDE>_<NAME>

Beispiele:

FOB_BLUE_ALPHA
FOB_BLUE_BRAVO
FOB_BLUE_CHARLIE
FOB_RED_ALPHA

Zugehörige Zonen:

ZONE_BLUE_FOB_ALPHA_SITE
TC_LOGISTICS_FOB_ALPHA
TC_DEFENSE_FOB_ALPHA
TC_REPAIR_FOB_ALPHA

---

## Konvois

Format:

CONVOY_<SIDE>_<TYPE>_<ROUTE>_<NUMBER>

Beispiele:

CONVOY_BLUE_SUPPLY_AKROTIRI_BEACHHEAD_01
CONVOY_BLUE_SUPPLY_BEACHHEAD_FOB_ALPHA_01
CONVOY_RED_SUPPLY_KHMEIMIM_LATAKIA_01
CONVOY_RED_COUNTERATTACK_LATAKIA_01

---

## Missionen

Interne Missionsnamen sollen lesbar und eindeutig sein.

Format:

MISSION_<SIDE>_<TYPE>_<REGION>_<NUMBER>

Beispiele:

MISSION_BLUE_SEAD_SYRIAN_COAST_01
MISSION_BLUE_STRIKE_LATAKIA_01
MISSION_BLUE_CAP_EASTERN_MED_01
MISSION_BLUE_LOGISTICS_FOB_ALPHA_01
MISSION_RED_COUNTERATTACK_BEACHHEAD_01

---

## Lua-Dateien

Lua-Dateien werden nach Aufgabe benannt, nicht nach Framework.

Format:

tc_<system>_<task>.lua

Beispiele:

tc_airbase_scanner.lua
tc_airbase_registry.lua
tc_zone_factory.lua
tc_capture_system.lua
tc_logistics_delivery.lua
tc_fob_system.lua
tc_mission_generator.lua
tc_ai_cap_manager.lua
tc_persistence_system.lua

Nicht verwenden:

tc_moose.lua
tc_mist.lua
tc_ctld.lua
tc_skynet.lua

Begründung:

Die Datei soll nach ihrer Aufgabe benannt sein. Sie darf intern trotzdem MOOSE, MIST, CTLD oder Skynet IADS verwenden.

---

## Lua-Namespace

Alle eigenen Funktionen hängen an:

TC = TC or {}

Geplante Unterbereiche:

TC.Core = TC.Core or {}
TC.World = TC.World or {}
TC.Campaign = TC.Campaign or {}
TC.Logistics = TC.Logistics or {}
TC.Missions = TC.Missions or {}
TC.AI = TC.AI or {}
TC.IADS = TC.IADS or {}
TC.UI = TC.UI or {}
TC.Debug = TC.Debug or {}

Beispiele für spätere Funktionen:

TC.World.ScanAirbases()
TC.World.CreateAirbaseZones()
TC.Campaign.UpdateCaptureState()
TC.Logistics.RegisterDelivery()
TC.Missions.GenerateForPlayer()
TC.AI.SpawnCAP()
TC.IADS.UpdateSectorStatus()
TC.UI.BuildF10Menu()

---

## Regionen

Regionsnamen werden klein und mit Unterstrich geschrieben.

Beispiele:

cyprus
eastern_med
syrian_coast
central_syria
northern_syria
damascus_sector
lebanon_sector
jordan_sector
israel_sector
turkey_sector

---

## Besitzer / Owner-Werte

Interne Besitzerwerte:

blue
red
neutral
contested
locked
inactive

Beispiele:

owner = "blue"
owner = "red"
owner = "neutral"
owner = "contested"
owner = "locked"
owner = "inactive"

---

## Ressourcen-Namen

Einheitliche Ressourcennamen:

supply
fuel
ammo
manpower
repair
medical
command

Beispiel:

resources = {
  supply = 100,
  fuel = 100,
  ammo = 100,
  manpower = 100,
  repair = 100,
  medical = 50,
  command = 100
}

---

## Schreibregeln

Keine Leerzeichen in technischen Namen.

Keine Umlaute in technischen Namen.

Keine Sonderzeichen außer Unterstrich.

Gut:

CLIENT_BLUE_FA18C_AKROTIRI_01
TC_CAPTURE_KHMEIMIM
STATIC_RED_LATAKIA_RADAR_01

Schlecht:

Client Blue F/A-18 Akrotiri 1
Zone Küste Latakia
Radar Latakia #1

---

## Ziel

Diese Namenskonventionen sollen verhindern, dass das Projekt bei wachsender Größe unübersichtlich wird.

Einheitliche Namen erleichtern:

- Debugging
- Lua-Zugriff
- Mission-Editor-Arbeit
- Dokumentation
- Fehlersuche
- spätere Erweiterung
