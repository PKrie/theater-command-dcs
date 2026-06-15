# Naming Conventions

Diese Datei beschreibt die Benennungsregeln für **Theater Command DCS**.

Ziel ist eine klare, einheitliche und später scriptfähige Benennung aller Dateien, Gruppen, Zonen, Trigger und Lua-Module.

Die erste Kampagne trägt den Arbeitstitel:

**Operation Levant Reclamation**

Die Kampagne wird auf der **Syria Map** aufgebaut.

Blau startet auf **Zypern / Akrotiri**.

Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Grundregel

Namen sollen eindeutig, lesbar und maschinenfreundlich sein.

Ein Name soll beantworten:

- Was ist es?
- Zu welcher Seite gehört es?
- Welche Aufgabe hat es?
- Wo befindet es sich?
- Welche laufende Nummer hat es?

Grundprinzip:

    TYPE_SIDE_ROLE_LOCATION_NUMBER

Beispiel:

    CLIENT_BLUE_FA18C_AKROTIRI_01

---

## Schreibweise

Für Mission-Editor-Objekte wird folgende Schreibweise genutzt:

    GROSSBUCHSTABEN_MIT_UNTERSTRICH

Beispiele:

    CLIENT_BLUE_FA18C_AKROTIRI_01
    TPL_RED_CAP_MIG29_PAIR_01
    CTLD_PICKUP_BLUE_AKROTIRI_01
    IADS_RED_EWR_LATTAKIA_01

Für eigene Lua-Dateien wird folgende Schreibweise genutzt:

    kleinbuchstaben_mit_unterstrich

Beispiele:

    tc_airbase_scanner.lua
    tc_zone_factory.lua
    tc_capture_system.lua
    tc_logistics_delivery.lua

---

## Projektordner

Externe Frameworks liegen unter:

    vendor/

Eigene Theater-Command-Logik liegt unter:

    src/

Mission-Editor-Dokumentation liegt später unter:

    mission_editor/

Konkrete Missionsdateien liegen später unter:

    mission/

Persistenz liegt später unter:

    save/

Werkzeuge liegen später unter:

    tools/

Assets liegen später unter:

    assets/

---

## Vendor-Dateien

Externe Framework-Dateien behalten entweder ihren externen Namen oder einen stabilen Projektnamen.

Aktuelle Vendor-Dateien:

    vendor/mist/mist.lua
    vendor/moose/Moose.lua
    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua
    vendor/skynet-iads/SkynetIADS.lua

Wichtig:

Diese Dateien werden nicht umbenannt, sobald sie in der Mission-Editor-Ladefolge verwendet werden.

Bei einem Framework-Update wird der Inhalt ersetzt, aber der Projektpfad bleibt stabil.

---

## Vendor-Referenzdateien

Zusätzliche Referenzdateien unter `vendor/`:

    vendor/mist/Mist guide.pdf
    vendor/mist/Example_DBs/
    vendor/moose/MOOSE_DOCS.md

Diese Dateien werden nicht durch DCS geladen.

Sie dienen nur als Referenzmaterial.

---

## Eigene Lua-Dateien

Eigene Lua-Dateien beginnen mit:

    tc_

Beispiele:

    tc_airbase_scanner.lua
    tc_zone_factory.lua
    tc_capture_system.lua
    tc_logistics_delivery.lua
    tc_fob_system.lua
    tc_mission_generator.lua
    tc_ai_cap_manager.lua
    tc_persistence_system.lua

Die Datei wird nach ihrer Aufgabe benannt.

Nicht nach dem verwendeten Framework.

---

## Nicht gewünschte Lua-Dateien

Nicht erstellen:

    src/tc_moose.lua
    src/tc_mist.lua
    src/tc_ctld.lua
    src/tc_all_in_one.lua
    src/tc_skynet.lua
    src/tc_iads_all_in_one.lua

Grund:

Theater Command DCS wird nach Aufgaben strukturiert.

MIST, MOOSE, CTLD und Skynet IADS sind Werkzeuge.

Sie bestimmen nicht die eigene Dateistruktur.

---

## Gewünschte Lua-Struktur

Geplante eigene Struktur:

    src/
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

Beispiele:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua
    src/campaign/tc_capture_system.lua
    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua
    src/missions/tc_mission_generator.lua
    src/ai/tc_ai_cap_manager.lua
    src/iads/tc_iads_network.lua
    src/debug/tc_debug_iads.lua

---

## Prefixe für Mission-Editor-Objekte

### Client-Slots

Prefix:

    CLIENT

Schema:

    CLIENT_SIDE_AIRCRAFT_LOCATION_NUMBER

Beispiele:

    CLIENT_BLUE_FA18C_AKROTIRI_01
    CLIENT_BLUE_FA18C_AKROTIRI_02
    CLIENT_BLUE_F16C_AKROTIRI_01
    CLIENT_BLUE_F15E_AKROTIRI_01
    CLIENT_BLUE_F14B_AKROTIRI_01
    CLIENT_BLUE_UH1H_AKROTIRI_01
    CLIENT_BLUE_MI8_AKROTIRI_01

---

### Template-Gruppen

Prefix:

    TPL

Schema:

    TPL_SIDE_ROLE_UNIT_LOCATION_NUMBER

Beispiele:

    TPL_RED_CAP_MIG29_PAIR_01
    TPL_RED_GCI_MIG29_PAIR_01
    TPL_RED_SAM_SA6_SITE_01
    TPL_RED_SAM_SA10_SITE_01
    TPL_RED_EWR_COASTAL_01
    TPL_BLUE_CAP_FA18C_PAIR_01
    TPL_BLUE_SEAD_FA18C_PAIR_01
    TPL_BLUE_TRANSPORT_UH1H_01

Template-Gruppen sollen im Mission Editor immer mit Late Activation angelegt werden.

---

### CTLD-Zonen

Prefix:

    CTLD

Schema für Pickup-Zonen:

    CTLD_PICKUP_SIDE_LOCATION_NUMBER

Beispiele:

    CTLD_PICKUP_BLUE_AKROTIRI_01
    CTLD_PICKUP_BLUE_AKROTIRI_02

Schema für Dropoff-Zonen:

    CTLD_DROPOFF_SIDE_LOCATION_ROLE_NUMBER

Beispiele:

    CTLD_DROPOFF_BLUE_COASTAL_FOB_01
    CTLD_DROPOFF_BLUE_COASTAL_SUPPLY_01

Schema für FOB-Zonen:

    CTLD_FOB_SIDE_LOCATION_NUMBER

Beispiele:

    CTLD_FOB_BLUE_COASTAL_01
    CTLD_FOB_BLUE_LATTAKIA_01

---

### IADS-Gruppen

Prefix:

    IADS

Schema:

    IADS_SIDE_TYPE_LOCATION_NUMBER

Beispiele:

    IADS_RED_EWR_LATTAKIA_01
    IADS_RED_SAM_SA10_KHMEIMIM_01
    IADS_RED_SAM_SA6_TARTUS_01
    IADS_RED_CP_COASTAL_01

Mögliche Typen:

    EWR
    SAM
    AAA
    SHORAD
    CP
    RADAR
    LAUNCHER
    SUPPORT

---

### Capture-Zonen

Prefix:

    CAPTURE

Schema:

    CAPTURE_SIDE_OR_STATE_LOCATION_NUMBER

Beispiele:

    CAPTURE_RED_LATTAKIA_01
    CAPTURE_RED_TARTUS_01
    CAPTURE_NEUTRAL_COASTAL_01
    CAPTURE_BLUE_FOB_ALPHA_01

Hinweis:

Viele Capture-Zonen sollen später virtuell durch Lua erzeugt werden.

Manuelle Mission-Editor-Zonen sollen nur genutzt werden, wenn sie wirklich nötig sind.

---

### Logistik-Zonen

Prefix:

    LOGI

Schema:

    LOGI_SIDE_ROLE_LOCATION_NUMBER

Beispiele:

    LOGI_BLUE_HUB_AKROTIRI_01
    LOGI_BLUE_SUPPLY_COASTAL_01
    LOGI_RED_DEPOT_LATTAKIA_01

---

### Statische Ziele

Prefix:

    STATIC

Schema:

    STATIC_SIDE_TYPE_LOCATION_NUMBER

Beispiele:

    STATIC_RED_DEPOT_LATTAKIA_01
    STATIC_RED_FUEL_TARTUS_01
    STATIC_RED_CP_COASTAL_01
    STATIC_RED_RADAR_LATTAKIA_01

Mögliche Typen:

    DEPOT
    FUEL
    AMMO
    CP
    RADAR
    COMMS
    BRIDGE
    PORT
    FACTORY

---

### Trigger

Prefix:

    TC

Schema:

    TC_ACTION_TARGET

Beispiele:

    TC_LOAD_MIST
    TC_LOAD_MOOSE
    TC_LOAD_CTLD_I18N
    TC_LOAD_CTLD
    TC_LOAD_SKYNET_IADS
    TC_LOAD_THEATER_COMMAND
    TC_DEBUG_STARTUP

---

### F10-Menüs

Prefix:

    F10

Schema:

    F10_CATEGORY_ACTION

Beispiele:

    F10_STATUS_SHOW
    F10_MISSION_LIST
    F10_LOGISTICS_STATUS
    F10_DEBUG_AIRBASES
    F10_DEBUG_IADS

Die konkrete Lua-Umsetzung erfolgt später unter:

    src/ui/

---

## Seitenbezeichnungen

Für Koalitionen werden folgende Begriffe genutzt:

    BLUE
    RED
    NEUTRAL

Nicht mischen mit:

    blue
    red
    coalitionBlue
    coalitionRed

In Mission-Editor-Namen immer Großbuchstaben verwenden.

In Lua können Konstanten später definiert werden.

---

## Ortsnamen

Ortsnamen sollen eindeutig und möglichst kurz sein.

Beispiele:

    AKROTIRI
    LATTAKIA
    TARTUS
    KHMEIMIM
    HAMA
    HOMS
    DAMASCUS
    COASTAL
    FobAlpha

Für Mission-Editor-Objekte:

    AKROTIRI
    LATTAKIA
    TARTUS

Für Lua-interne IDs kann später eine eigene ID-Schreibweise genutzt werden.

---

## Nummerierung

Nummern werden immer zweistellig geschrieben:

    01
    02
    03

Nicht:

    1
    2
    3

Beispiele:

    CLIENT_BLUE_FA18C_AKROTIRI_01
    TPL_RED_CAP_MIG29_PAIR_01
    IADS_RED_EWR_LATTAKIA_01

---

## Rollenbezeichnungen

Mögliche Rollen:

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

Beispiele:

    TPL_BLUE_SEAD_FA18C_PAIR_01
    TPL_RED_GCI_MIG29_PAIR_01
    TPL_BLUE_TRANSPORT_UH1H_01

---

## Flugzeugbezeichnungen

Empfohlene Schreibweise:

    FA18C
    F16C
    F15E
    F14B
    A10C
    AH64D
    UH1H
    MI8

Beispiele:

    CLIENT_BLUE_FA18C_AKROTIRI_01
    CLIENT_BLUE_F14B_AKROTIRI_01
    CLIENT_BLUE_AH64D_FOB_ALPHA_01

Keine Sonderzeichen in Mission-Editor-Namen verwenden.

Nicht:

    F/A-18C
    F-16C
    A-10C II

---

## Gruppenstärken

Mögliche Bezeichnungen:

    SINGLE
    PAIR
    FLIGHT
    SECTION
    PLATOON
    COMPANY
    CONVOY
    SITE

Beispiele:

    TPL_RED_CAP_MIG29_PAIR_01
    TPL_RED_GROUND_ARMOR_PLATOON_01
    TPL_RED_LOGISTICS_CONVOY_01
    TPL_RED_SAM_SA6_SITE_01

---

## Lua-Konstanten

Später sollen häufig genutzte Begriffe als Konstanten definiert werden.

Geplante Datei:

    src/core/tc_config.lua

Mögliche Konstanten:

    TC_SIDE_BLUE
    TC_SIDE_RED
    TC_SIDE_NEUTRAL
    TC_STATUS_ACTIVE
    TC_STATUS_INACTIVE
    TC_STATUS_DESTROYED

Die genaue Umsetzung erfolgt später.

---

## Globale Tabelle

Die globale Tabelle für Theater Command DCS soll später heißen:

    TC

Nicht verwenden:

    TheaterCommand
    theaterCommand
    tc_global
    _G_TC

Geplante Grundstruktur:

    TC = {
      version = "...",
      config = {},
      state = {},
      modules = {},
      debug = {}
    }

---

## Debug-Namen

Debug-Dateien beginnen mit:

    tc_debug_

Beispiele:

    tc_debug_airbases.lua
    tc_debug_zones.lua
    tc_debug_capture.lua
    tc_debug_logistics.lua
    tc_debug_iads.lua

Debug-Menüs oder Debug-Ausgaben sollen eindeutig erkennbar sein.

Beispiele:

    TC DEBUG: Airbase scanner initialized
    TC DEBUG: Zone factory created 12 zones
    TC ERROR: MIST not loaded

---

## Log-Ausgaben

Log-Ausgaben sollen später einheitlich beginnen mit:

    [TC]

Beispiele:

    [TC] Theater Command DCS loading
    [TC] MIST available
    [TC] MOOSE available
    [TC] CTLD available
    [TC] Skynet IADS available
    [TC] Loader finished

Fehler:

    [TC][ERROR] MIST not available
    [TC][ERROR] Failed to load module tc_airbase_scanner

Warnungen:

    [TC][WARN] Airbase override missing for unknown base

---

## Dateipfade in Dokumentation

Dateipfade werden immer relativ zum Repository-Root angegeben.

Beispiele:

    vendor/mist/mist.lua
    vendor/moose/Moose.lua
    src/loader.lua
    docs/02_technical_architecture.md

Nicht:

    C:\Users\...
    Saved Games\DCS\...
    /home/user/...

Lokale Windows- oder DCS-Pfade werden nur dann dokumentiert, wenn es um konkrete Installation oder Mission-Editor-Arbeit geht.

---

## Mission-Dateien

Spätere Mission-Dateien sollen nach folgendem Schema benannt werden:

    Operation_Levant_Reclamation_DEV.miz
    Operation_Levant_Reclamation_TEST.miz
    Operation_Levant_Reclamation_RELEASE.miz

Geplante Ordner:

    mission/dev/
    mission/test/
    mission/release/

Diese Ordner existieren aktuell noch nicht vollständig.

Sie werden später angelegt.

---

## Dokumentationsdateien

Markdown-Dateien werden klein geschrieben, wenn sie in Unterordnern liegen.

Beispiele:

    docs/00_project_overview.md
    docs/01_campaign_design.md
    docs/02_technical_architecture.md

Root-Dokumente bleiben in Großbuchstaben, wenn sie zentrale Projektdateien sind.

Beispiele:

    README.md
    ROADMAP.md
    TASKS.md
    CHANGELOG.md
    ARCHITECTURE.md
    MISSION_EDITOR_SETUP.md
    NAMING_CONVENTIONS.md
    LUA_STYLEGUIDE.md

---

## Verbotene Muster

Nicht verwenden:

    tc_all_in_one.lua
    tc_moose.lua
    tc_mist.lua
    tc_ctld.lua
    Moose.lua im Repository-Root
    CTLD.lua im Repository-Root
    SkynetIADS.lua im Repository-Root

Framework-Dateien gehören nur nach:

    vendor/

Eigene Logik gehört nur nach:

    src/

---

## Aktueller nächster technischer Schritt

Nach Abschluss der aktuellen Dokumentationsaktualisierung:

    src-Unterordner und README-Dateien erstellen

Danach:

    src/loader.lua
    src/main.lua
    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
