# Naming Conventions

Diese Datei beschreibt die Benennungsregeln für **Theater Command DCS**.

Ziel ist eine klare, einheitliche und später scriptfähige Benennung aller Dateien, Gruppen, Zonen, Trigger, Lua-Module und State-Keys.

Erste Kampagne:

- **Operation Levant Reclamation**

Map:

- **Syria**

Ausgangslage:

- Blue startet auf **Akrotiri / Zypern**
- Das syrische Festland ist zu Beginn rot kontrolliert
- Red hält zu Beginn den Großteil der strategischen Flugplätze
- Blue soll sich vom Brückenkopf Zypern aus auf das syrische Festland vorarbeiten
- Spieler sollen sich in eine laufende Kampagne einklinken, nicht jede Aktion allein auslösen
- Blue und Red sollen später eigene Operationen durchführen

---

## 1. Grundregel

Namen sollen eindeutig, lesbar und maschinenfreundlich sein.

Ein Name soll beantworten:

- Was ist es?
- Zu welcher Seite gehört es?
- Welche Aufgabe hat es?
- Wo befindet es sich?
- Welche laufende Nummer hat es?

Grundprinzip für Mission-Editor-Objekte:

```text
TYPE_SIDE_ROLE_LOCATION_NUMBER
```

Beispiel:

```text
CLIENT_BLUE_FA18C_AKROTIRI_01
```

Grundprinzip für eigene Lua-Dateien:

```text
tc_aufgabe_bereich.lua
```

Beispiel:

```text
tc_capture_system.lua
```

---

## 2. Schreibweise

Für Mission-Editor-Objekte wird folgende Schreibweise genutzt:

```text
GROSSBUCHSTABEN_MIT_UNTERSTRICH
```

Beispiele:

```text
CLIENT_BLUE_FA18C_AKROTIRI_01
TPL_RED_CAP_MIG29_PAIR_01
CTLD_PICKUP_BLUE_AKROTIRI_01
IADS_RED_EWR_LATTAKIA_01
TC_LOAD_TC_F10_MENU
```

Für eigene Lua-Dateien wird folgende Schreibweise genutzt:

```text
kleinbuchstaben_mit_unterstrich.lua
```

Beispiele:

```text
tc_airbase_scanner.lua
tc_zone_factory.lua
tc_capture_system.lua
tc_logistics_delivery.lua
tc_fob_system.lua
tc_mission_generator.lua
tc_ai_cap_manager.lua
tc_f10_menu.lua
```

Für Lua-interne Keys wird ebenfalls eine maschinenfreundliche Schreibweise genutzt.

Beispiele:

```text
MISSION_2
ZONE_AIRBASE_ABU_AL_DUHUR
FOB_ERCAN
CAP_ZONE_AKROTIRI
```

---

## 3. Projektordner

Aktuelle Hauptordner:

```text
docs/
mission_editor/
src/
vendor/
```

Aktuelle zentrale Root-Dateien:

```text
README.md
ROADMAP.md
TASKS.md
CHANGELOG.md
ARCHITECTURE.md
MISSION_EDITOR_SETUP.md
NAMING_CONVENTIONS.md
LUA_STYLEGUIDE.md
```

Später mögliche Ordner:

```text
mission/
save/
tools/
assets/
```

Regel:

- externe Frameworks liegen unter `vendor/`
- eigene Theater-Command-Logik liegt unter `src/`
- Mission-Editor-Dokumentation liegt unter `mission_editor/`
- fachliche und technische Detaildokumentation liegt unter `docs/`

---

## 4. Vendor-Dateien

Externe Framework-Dateien behalten ihren externen Namen oder einen stabilen Projektnamen.

Aktive Vendor-Dateien:

```text
vendor/mist/mist.lua
vendor/moose/Moose.lua
vendor/ctld/CTLD-i18n.lua
vendor/ctld/CTLD.lua
vendor/skynet-iads/SkynetIADS.lua
```

Aktive Vendor-Stände:

| Framework | Pfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD-i18n | `vendor/ctld/CTLD-i18n.lua` | geladen |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Wichtig:

- Vendor-Dateien werden nicht umbenannt, sobald sie in der Mission-Editor-Ladefolge verwendet werden.
- Bei einem Framework-Update wird der Inhalt ersetzt, aber der Projektpfad bleibt stabil.
- Vendor-Dateien werden nicht durch eigene Projektlogik verändert.

---

## 5. Vendor-Referenzdateien

Zusätzliche Referenzdateien unter `vendor/` können vorhanden sein.

Beispiele:

```text
vendor/mist/Mist guide.pdf
vendor/mist/Example_DBs/
vendor/moose/MOOSE_DOCS.md
```

Diese Dateien werden nicht durch DCS geladen.

Sie dienen nur als Referenzmaterial.

---

## 6. Eigene Lua-Dateien

Eigene Lua-Dateien beginnen mit:

```text
tc_
```

Aktive eigene Lua-Dateien:

```text
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
```

Vorbereitet, aber noch nicht produktiv implementiert:

```text
src/iads/
src/debug/
```

Regel:

- Datei nach Aufgabe benennen.
- Nicht nach Framework benennen.
- Keine unklare Sammeldatei bauen.
- Jede Datei soll einen klaren fachlichen Zweck haben.

---

## 7. Nicht gewünschte Lua-Dateien

Nicht erstellen:

```text
src/tc_moose.lua
src/tc_mist.lua
src/tc_ctld.lua
src/tc_all_in_one.lua
src/tc_skynet.lua
src/tc_iads_all_in_one.lua
src/tc_frameworks.lua
src/tc_everything.lua
```

Grund:

- Theater Command DCS wird nach Aufgaben strukturiert.
- MIST, MOOSE, CTLD und Skynet IADS sind Werkzeuge.
- Sie bestimmen nicht die eigene Dateistruktur.

---

## 8. Aktuelle Lua-Struktur

Aktuelle eigene Struktur:

```text
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
│   ├── README.md
│   └── tc_f10_menu.lua
└── debug/
    └── README.md
```

---

## 9. Mission-Editor-Trigger

Prefix:

```text
TC_LOAD_
```

Schema:

```text
TC_LOAD_TARGET
```

Aktuelle Triggernamen:

```text
TC_LOAD_MIST
TC_LOAD_MOOSE
TC_LOAD_CTLD_I18N
TC_LOAD_CTLD
TC_LOAD_SKYNET_IADS
TC_LOAD_TC_CONFIG
TC_LOAD_TC_LOGGER
TC_LOAD_TC_STATE
TC_LOAD_TC_UTILS
TC_LOAD_TC_SCHEDULER
TC_LOAD_TC_AIRBASE_SCANNER
TC_LOAD_TC_ZONE_FACTORY
TC_LOAD_TC_CAPTURE_SYSTEM
TC_LOAD_TC_PERSISTENCE_SYSTEM
TC_LOAD_TC_LOGISTICS_DELIVERY
TC_LOAD_TC_FOB_SYSTEM
TC_LOAD_TC_MISSION_GENERATOR
TC_LOAD_TC_AI_CAP_MANAGER
TC_LOAD_TC_F10_MENU
TC_LOAD_TC_MAIN
TC_LOAD_TC_LOADER
```

Regeln:

- Triggernamen bleiben eindeutig.
- Lade-Trigger beginnen mit `TC_LOAD_`.
- Debug-Trigger beginnen später mit `TC_DEBUG_`.
- Produktive Trigger sollen möglichst vermieden werden, wenn Lua den Zustand selbst verwalten kann.

---

## 10. Client-Slots

Prefix:

```text
CLIENT
```

Schema:

```text
CLIENT_SIDE_AIRCRAFT_LOCATION_NUMBER
```

Beispiele:

```text
CLIENT_BLUE_FA18C_AKROTIRI_01
CLIENT_BLUE_FA18C_AKROTIRI_02
CLIENT_BLUE_F16C_AKROTIRI_01
CLIENT_BLUE_F15E_AKROTIRI_01
CLIENT_BLUE_F14B_AKROTIRI_01
CLIENT_BLUE_A10C_AKROTIRI_01
CLIENT_BLUE_AH64D_AKROTIRI_01
CLIENT_BLUE_UH1H_AKROTIRI_01
CLIENT_BLUE_MI8_AKROTIRI_01
```

Regeln:

- keine Sonderzeichen
- keine Leerzeichen
- keine Schrägstriche
- Koalition immer als `BLUE`, `RED` oder `NEUTRAL`
- Flugzeugtyp in vereinfachter Schreibweise

---

## 11. Flugzeugbezeichnungen

Empfohlene Schreibweise:

```text
FA18C
F16C
F15E
F14B
A10C
AH64D
UH1H
MI8
```

Beispiele:

```text
CLIENT_BLUE_FA18C_AKROTIRI_01
CLIENT_BLUE_F14B_AKROTIRI_01
CLIENT_BLUE_AH64D_FOB_ALPHA_01
```

Nicht verwenden:

```text
F/A-18C
F-16C
A-10C II
AH-64D
```

Grund:

- Sonderzeichen erschweren spätere Scriptverarbeitung.
- Einheitliche IDs sind robuster.

---

## 12. Template-Gruppen

Prefix:

```text
TPL
```

Schema:

```text
TPL_SIDE_ROLE_UNIT_LOCATION_NUMBER
```

Beispiele:

```text
TPL_RED_CAP_MIG29_PAIR_01
TPL_RED_GCI_MIG29_PAIR_01
TPL_RED_SAM_SA6_SITE_01
TPL_RED_SAM_SA10_SITE_01
TPL_RED_EWR_COASTAL_01
TPL_BLUE_CAP_FA18C_PAIR_01
TPL_BLUE_SEAD_FA18C_PAIR_01
TPL_BLUE_TRANSPORT_UH1H_01
```

Regeln:

- Template-Gruppen im Mission Editor immer mit Late Activation anlegen.
- Templates sollen nicht zufällig umbenannt werden.
- MOOSE-/Spawn-Logik darf sich später auf stabile Template-Namen verlassen.
- Template-Namen sollen Rolle, Seite, Einheit, Ort und Nummer enthalten.

---

## 13. Gruppenstärken

Mögliche Bezeichnungen:

```text
SINGLE
PAIR
FLIGHT
SECTION
PLATOON
COMPANY
CONVOY
SITE
```

Beispiele:

```text
TPL_RED_CAP_MIG29_PAIR_01
TPL_RED_GROUND_ARMOR_PLATOON_01
TPL_RED_LOGISTICS_CONVOY_01
TPL_RED_SAM_SA6_SITE_01
```

---

## 14. Rollenbezeichnungen

Mögliche Rollen:

```text
CAP
GCI
SEAD
DEAD
STRIKE
CAS
TRANSPORT
LOGISTICS
RECON
ESCORT
AWACS
TANKER
CSAR
FOB_SUPPORT
AIRBASE_ATTACK
IADS_SUPPRESSION
```

Beispiele:

```text
TPL_BLUE_SEAD_FA18C_PAIR_01
TPL_RED_GCI_MIG29_PAIR_01
TPL_BLUE_TRANSPORT_UH1H_01
```

---

## 15. CTLD-Zonen

Prefix:

```text
CTLD
```

Schema für Pickup-Zonen:

```text
CTLD_PICKUP_SIDE_LOCATION_NUMBER
```

Beispiele:

```text
CTLD_PICKUP_BLUE_AKROTIRI_01
CTLD_PICKUP_BLUE_AKROTIRI_02
```

Schema für Dropoff-Zonen:

```text
CTLD_DROPOFF_SIDE_LOCATION_ROLE_NUMBER
```

Beispiele:

```text
CTLD_DROPOFF_BLUE_COASTAL_FOB_01
CTLD_DROPOFF_BLUE_COASTAL_SUPPLY_01
```

Schema für FOB-Zonen:

```text
CTLD_FOB_SIDE_LOCATION_NUMBER
```

Beispiele:

```text
CTLD_FOB_BLUE_COASTAL_01
CTLD_FOB_BLUE_LATTAKIA_01
```

Regeln:

- CTLD-Zonen werden erst produktiv genutzt, wenn sie sauber im Mission Editor angelegt sind.
- CTLD-Dateien werden nicht verändert.
- Theater Command wertet Logistics/FOB-State aus.
- CTLD führt später Cargo-/FOB-Aktionen technisch aus.

---

## 16. IADS-Gruppen

Prefix:

```text
IADS
```

Schema:

```text
IADS_SIDE_TYPE_LOCATION_NUMBER
```

Beispiele:

```text
IADS_RED_EWR_LATTAKIA_01
IADS_RED_SAM_SA10_KHMEIMIM_01
IADS_RED_SAM_SA6_TARTUS_01
IADS_RED_CP_COASTAL_01
```

Mögliche Typen:

```text
EWR
SAM
AAA
SHORAD
CP
RADAR
LAUNCHER
SUPPORT
```

Regeln:

- Skynet IADS wird als Vendor geladen.
- Eigene IADS-Kampagnenlogik kommt später nach `src/iads/`.
- IADS-Gruppen sollen stabil benannt werden, damit sie später scriptfähig sind.

---

## 17. Capture-Zonen

Prefix für manuelle Mission-Editor-Zonen:

```text
CAPTURE
```

Schema:

```text
CAPTURE_SIDE_OR_STATE_LOCATION_NUMBER
```

Beispiele:

```text
CAPTURE_RED_LATTAKIA_01
CAPTURE_RED_TARTUS_01
CAPTURE_NEUTRAL_COASTAL_01
CAPTURE_BLUE_FOB_ALPHA_01
```

Hinweis:

- Viele Capture-Zonen werden aktuell virtuell durch Lua erzeugt.
- ZoneFactory erzeugt derzeit 46 relevante Kampagnenzonen.
- CaptureSystem nutzt 32 capture-fähige Ziele.
- Manuelle Mission-Editor-Zonen sollen nur genutzt werden, wenn sie wirklich nötig sind.

Lua-interne Capture-Zonen können so aussehen:

```text
ZONE_AIRBASE_ABU_AL_DUHUR
ZONE_AIRBASE_AKROTIRI
ZONE_AIRBASE_LATTAKIA
```

Regeln:

- virtuelle Zonen dürfen von Lua erzeugt werden.
- manuelle Zonen sollen eindeutige Prefixe haben.
- Capture Ready erzeugt keinen automatischen produktiven Ownership-Wechsel ohne kontrollierten Testpfad.

---

## 18. Logistik-Zonen

Prefix:

```text
LOGI
```

Schema:

```text
LOGI_SIDE_ROLE_LOCATION_NUMBER
```

Beispiele:

```text
LOGI_BLUE_HUB_AKROTIRI_01
LOGI_BLUE_SUPPLY_COASTAL_01
LOGI_RED_DEPOT_LATTAKIA_01
```

Aktueller Stand:

- LogisticsDelivery erzeugt 46 Logistics Hubs state-only.
- CTLD-Zonen sind noch nicht produktiv angebunden.

---

## 19. FOB-Namen

Prefix:

```text
FOB
```

Schema für Mission-Editor-Objekte:

```text
FOB_SIDE_LOCATION_NUMBER
```

Beispiele:

```text
FOB_BLUE_ERCAN_01
FOB_BLUE_GECITKALE_01
FOB_BLUE_COASTAL_01
```

Lua-interne Anzeigenamen können lesbarer sein:

```text
FOB Ercan
FOB Gecitkale
```

Aktuell bestätigte Blue-FOBs:

```text
FOB Ercan
FOB Gecitkale
```

Regeln:

- technische IDs maschinenfreundlich halten
- Anzeigenamen dürfen lesbar sein
- CTLD-FOBs später eindeutig mit Logistics-Hubs koppeln

---

## 20. Statische Ziele

Prefix:

```text
STATIC
```

Schema:

```text
STATIC_SIDE_TYPE_LOCATION_NUMBER
```

Beispiele:

```text
STATIC_RED_DEPOT_LATTAKIA_01
STATIC_RED_FUEL_TARTUS_01
STATIC_RED_CP_COASTAL_01
STATIC_RED_RADAR_LATTAKIA_01
```

Mögliche Typen:

```text
DEPOT
FUEL
AMMO
CP
RADAR
COMMS
BRIDGE
PORT
FACTORY
```

---

## 21. F10-Menüs

Prefix für dokumentierte F10-Funktionen:

```text
F10
```

Schema:

```text
F10_CATEGORY_ACTION
```

Beispiele:

```text
F10_STATUS_SHOW
F10_MISSION_LIST
F10_MISSION_ACTIVATE
F10_MISSION_COMPLETE
F10_CAPTURE_STATUS
F10_CAPTURE_READY_SHOW
F10_LOGISTICS_STATUS
F10_DEBUG_AIRBASES
F10_DEBUG_IADS
```

Aktive Lua-Datei:

```text
src/ui/tc_f10_menu.lua
```

Aktueller getesteter Stand:

```text
F10Menu v0.2.2
commands=32
```

Aktuelle F10-Bereiche:

```text
Theater Command
Theater Command > Missions
Theater Command > Missions > Mission Details
Theater Command > Missions > Activate Mission
Theater Command > Missions > Mission Outcome
Theater Command > Status
Theater Command > Logistics
Theater Command > AI
```

Aktuelle bestätigte Funktionen:

```text
Show Available Missions
Show Active Missions
Show Mission 1 Details
Activate Mission 1
Show Active Mission Outcome Status
Complete Active Mission 1
Show Campaign Status
Show Capture Status
Show Capture Ready Zones
Show Pressure Contested Zones
Show Logistics Status
Show FOB Status
Show AI CAP Status
```

Nächster möglicher F10-Befehl:

```text
Apply Capture Ready Zone 1
```

---

## 22. Seitenbezeichnungen

Für Koalitionen werden folgende Begriffe genutzt:

```text
BLUE
RED
NEUTRAL
CONTESTED
UNKNOWN
```

Nicht mischen mit:

```text
blue
red
coalitionBlue
coalitionRed
```

Regeln:

- In Mission-Editor-Namen immer Großbuchstaben verwenden.
- In Lua sollen zentrale Konstanten oder Config-Werte genutzt werden.
- State soll stabile Owner-Werte verwenden.

---

## 23. Ortsnamen

Ortsnamen sollen eindeutig und möglichst kurz sein.

Beispiele:

```text
AKROTIRI
LATTAKIA
TARTUS
KHMEIMIM
HAMA
HOMS
DAMASCUS
ABU_AL_DUHUR
ERCAN
GECITKALE
COASTAL
```

Für Mission-Editor-Objekte:

```text
AKROTIRI
LATTAKIA
TARTUS
```

Für Lua-interne IDs:

```text
ZONE_AIRBASE_ABU_AL_DUHUR
FOB_ERCAN
```

Regeln:

- keine Leerzeichen
- keine Sonderzeichen
- Umlaute vermeiden
- transliterierte Ortsnamen stabil halten
- einmal verwendete Namen nicht ohne Grund ändern

---

## 24. Nummerierung

Nummern werden immer zweistellig geschrieben:

```text
01
02
03
```

Nicht:

```text
1
2
3
```

Beispiele:

```text
CLIENT_BLUE_FA18C_AKROTIRI_01
TPL_RED_CAP_MIG29_PAIR_01
IADS_RED_EWR_LATTAKIA_01
CTLD_PICKUP_BLUE_AKROTIRI_01
```

---

## 25. Lua-Konstanten

Häufig genutzte Begriffe sollen zentral über Config, Constants oder State-Helfer definiert werden.

Aktive Datei:

```text
src/core/tc_config.lua
```

Beispiele für fachliche Werte:

```text
BLUE
RED
NEUTRAL
CONTESTED
UNKNOWN
ACTIVE
AVAILABLE
COMPLETED
FAILED
CANCELLED
EXPIRED
CAPTURE_READY
```

Regeln:

- keine frei erfundenen Statuswerte in Einzelfunktionen
- Statuswerte stabil halten
- neue Statuswerte dokumentieren
- State-kompatibel benennen

---

## 26. Globale Tabelle

Die globale Tabelle für Theater Command DCS heißt:

```lua
TC
```

Nicht verwenden:

```lua
TheaterCommand
theaterCommand
tc_global
_G_TC
```

Grundstruktur:

```lua
TC = TC or {}
TC.modules = TC.modules or {}
TC.State = TC.State or {}
TC.state = TC.state or TC.State
```

Beispiele:

```lua
TC.Campaign = TC.Campaign or {}
TC.Campaign.CaptureSystem = CaptureSystem

TC.Missions = TC.Missions or {}
TC.Missions.Generator = MissionGenerator

TC.UI = TC.UI or {}
TC.UI.F10Menu = F10Menu
```

Regeln:

- `TC` ist die einzige eigene globale Projektstruktur.
- Einzelne neue Projekt-Globals vermeiden.
- Framework-Globals nicht überschreiben.

---

## 27. Debug-Namen

Debug-Dateien beginnen später mit:

```text
tc_debug_
```

Beispiele:

```text
tc_debug_airbases.lua
tc_debug_zones.lua
tc_debug_capture.lua
tc_debug_logistics.lua
tc_debug_iads.lua
```

Debug-Menüs oder Debug-Ausgaben müssen eindeutig erkennbar sein.

Beispiele:

```text
TC DEBUG: Airbase scanner initialized
TC DEBUG: Zone factory created 46 zones
TC ERROR: MIST not loaded
```

Geplanter Ordner:

```text
src/debug/
```

---

## 28. Log-Ausgaben

Log-Ausgaben beginnen einheitlich mit:

```text
[TC]
```

Beispiele:

```text
[TC] Theater Command DCS loading
[TC] [CaptureSystem] Loaded src/campaign/tc_capture_system.lua v0.2.2
[TC] [MissionGenerator] Mission outcome prepared: MISSION_2 [COMPLETED] stateOnly=true effects=prepared
[TC] [F10Menu] F10 menu initialized: commands=32
```

Fehler:

```text
[TC][ERROR]
[TC] [ERROR]
```

Warnungen:

```text
[TC][WARN]
[TC] [WARN]
```

Wichtige Suchbegriffe im `dcs.log`:

```text
[TC]
[TC][ERROR]
[TC] [ERROR]
SCRIPTING ERROR
Mission script error
stack traceback
attempt to
nil value
cannot open
```

---

## 29. Dateipfade in Dokumentation

Dateipfade werden relativ zum Repository-Root angegeben.

Beispiele:

```text
vendor/mist/mist.lua
vendor/moose/Moose.lua
src/loader.lua
src/ui/tc_f10_menu.lua
docs/02_technical_architecture.md
```

Nicht für normale Projektdokumentation:

```text
C:\Users\...
Saved Games\DCS\...
/home/user/...
```

Ausnahme:

- lokale Installation
- Mission-Editor-Arbeit
- DCS-Logpfade
- konkrete Testanleitung

---

## 30. Mission-Dateien

Spätere Mission-Dateien sollen nach folgendem Schema benannt werden:

```text
Operation_Levant_Reclamation_DEV.miz
Operation_Levant_Reclamation_TEST.miz
Operation_Levant_Reclamation_RELEASE.miz
```

Geplante spätere Ordner:

```text
mission/dev/
mission/test/
mission/release/
```

Aktueller Stand:

- Die DEV-Mission dient als technischer Testträger.
- Sie ist noch keine fertige spielbare Kampagnenmission.

---

## 31. Dokumentationsdateien

Markdown-Dateien werden klein geschrieben, wenn sie in Unterordnern liegen.

Beispiele:

```text
docs/00_project_overview.md
docs/01_campaign_design.md
docs/02_technical_architecture.md
```

Root-Dokumente bleiben in Großbuchstaben, wenn sie zentrale Projektdateien sind.

Beispiele:

```text
README.md
ROADMAP.md
TASKS.md
CHANGELOG.md
ARCHITECTURE.md
MISSION_EDITOR_SETUP.md
NAMING_CONVENTIONS.md
LUA_STYLEGUIDE.md
```

---

## 32. Verbotene Muster

Nicht verwenden:

```text
tc_all_in_one.lua
tc_moose.lua
tc_mist.lua
tc_ctld.lua
tc_skynet.lua
tc_frameworks.lua
Moose.lua im Repository-Root
CTLD.lua im Repository-Root
SkynetIADS.lua im Repository-Root
```

Framework-Dateien gehören nur nach:

```text
vendor/
```

Eigene Logik gehört nur nach:

```text
src/
```

---

## 33. Aktueller nächster technischer Schritt

Nächster sinnvoller technischer Schritt:

```text
src/ui/tc_f10_menu.lua
```

Ziel:

```text
kontrollierter state-only Ownership-Wechsel aus Capture Ready Zone 1
```

Möglicher neuer F10-Befehl:

```text
Apply Capture Ready Zone 1
```

Akzeptanzkriterien:

- bestehende 32 F10-Commands bleiben funktionsfähig
- neuer Befehl wird ergänzt
- Capture Ready Zone 1 kann bewusst angewendet werden
- Ownership-Wechsel bleibt state-only
- linked Airbase wird kontrolliert synchronisiert
- Capture Pressure wird sauber zurückgesetzt oder markiert
- klare Logmarker entstehen
- keine echten MOOSE-Spawns
- keine CTLD-Aktion
- keine Skynet-Aktion
- keine Lua-Fehler
