# Lua Styleguide

Diese Datei beschreibt die Lua-Programmierregeln für **Theater Command DCS**.

Ziel ist eine einheitliche, lesbare und wartbare Lua-Struktur für ein dynamisches DCS-Kampagnensystem.

Die erste Kampagne trägt den Arbeitstitel:

**Operation Levant Reclamation**

Die Kampagne wird auf der **Syria Map** aufgebaut.

Blau startet auf **Zypern / Akrotiri**.

Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Grundsatz

Theater Command DCS wird modular entwickelt.

Jede Datei hat eine klare Aufgabe.

Keine All-in-one-Dateien.

Keine großen Framework-Sammeldateien.

Keine unnötig großen globalen Seiteneffekte.

---

## Projektprinzip

Das Projekt folgt dem Prinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Mission Editor lädt später nur die Frameworks und den Theater-Command-Loader.

Die eigene Kampagnenlogik liegt in Lua-Dateien unter:

    src/

Externe Frameworks liegen unter:

    vendor/

---

## Aktueller technischer Stand

Stand:

    2026-06-15

Aktuell vorhanden:

- zentrale Projektdokumentation
- `docs/`-Grundblock
- `vendor/`-Frameworks
- `src/README.md`

Aktuell noch nicht vorhanden:

- `src/loader.lua`
- `src/main.lua`
- eigene Core-Dateien
- eigene World-Dateien
- eigene Campaign-Dateien
- eigene Logistics-Dateien
- eigene Missions-Dateien
- eigene AI-Dateien
- eigene IADS-Dateien
- eigene UI-Dateien
- eigene Debug-Dateien

---

## Externe Frameworks

Aktuell eingebundene Frameworks:

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Diese Dateien werden nicht verändert.

Eigene Theater-Command-Logik wird nicht in Framework-Dateien geschrieben.

---

## Geplante Lade-Reihenfolge

Die geplante Lade-Reihenfolge im DCS Mission Editor lautet:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua
    6. src/loader.lua

Wichtig:

- MIST muss vor CTLD geladen werden.
- `CTLD-i18n.lua` muss vor `CTLD.lua` geladen werden.
- Skynet IADS muss nach MIST geladen werden.
- Eigene Theater-Command-Logik startet erst nach allen externen Frameworks.

---

## Eigene Lua-Struktur

Eigene Lua-Dateien liegen später unter:

    src/

Geplante Struktur:

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

Die Struktur wird nach Aufgaben sortiert.

Sie wird nicht nach Frameworks sortiert.

---

## Nicht gewünschte Dateien

Nicht erstellen:

    src/tc_moose.lua
    src/tc_mist.lua
    src/tc_ctld.lua
    src/tc_skynet.lua
    src/tc_all_in_one.lua
    src/tc_iads_all_in_one.lua

Grund:

MIST, MOOSE, CTLD und Skynet IADS sind Werkzeuge.

Sie bestimmen nicht die eigene Dateistruktur.

---

## Gewünschte Dateiarten

Gewünscht sind aufgabenorientierte Dateien.

Beispiele:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua
    src/campaign/tc_capture_system.lua
    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua
    src/missions/tc_mission_generator.lua
    src/ai/tc_ai_cap_manager.lua
    src/iads/tc_iads_network.lua
    src/campaign/tc_persistence_system.lua

Eine Datei darf intern MIST, MOOSE, CTLD oder Skynet IADS nutzen.

Der Dateiname richtet sich aber immer nach der Aufgabe, nicht nach dem Framework.

---

## Dateinamen

Eigene Lua-Dateien beginnen mit:

    tc_

Schreibweise:

    kleinbuchstaben_mit_unterstrich.lua

Beispiele:

    tc_config.lua
    tc_logger.lua
    tc_state.lua
    tc_airbase_scanner.lua
    tc_capture_system.lua
    tc_logistics_delivery.lua
    tc_mission_generator.lua
    tc_ai_director.lua
    tc_iads_network.lua

---

## Globale Tabelle

Die eigene Projektlogik soll später über eine globale Tabelle erreichbar sein:

    TC

Geplante Grundstruktur:

    TC = {
      version = "...",
      config = {},
      state = {},
      modules = {},
      debug = {}
    }

Nur `TC` soll als globale Projektstruktur genutzt werden.

Nicht verwenden:

    TheaterCommand
    theaterCommand
    tc_global
    _G_TC

---

## Globale Variablen

Globale Variablen sollen vermieden werden.

Erlaubt ist später nur die globale Projekttabelle:

    TC

Frameworks bringen eigene globale Strukturen mit.

Beispiele:

    mist
    ctld
    SkynetIADS

Diese werden nicht überschrieben.

Eigene globale Einzelvariablen sind zu vermeiden.

Nicht:

    myAirbases = {}
    campaignState = {}
    debugMode = true

Stattdessen:

    TC.state.airbases = {}
    TC.state.campaign = {}
    TC.debug.enabled = true

---

## Module

Jede eigene Datei soll ein klares Modul zurückgeben oder einen klaren Bereich unter `TC.modules` registrieren.

Beispielstruktur:

    TC.modules.airbaseScanner = {}
    TC.modules.zoneFactory = {}
    TC.modules.captureSystem = {}

Die konkrete Modulstruktur wird später mit `src/loader.lua` und `src/main.lua` festgelegt.

---

## Funktionsnamen

Funktionsnamen sollen klar und sprechend sein.

Empfohlene Schreibweise:

    camelCase

Beispiele:

    scanAirbases()
    createBaseNode()
    registerZone()
    updateCaptureState()
    evaluateLogisticsDelivery()
    generateMissionList()
    initializeIadsNetwork()

Für interne Hilfsfunktionen kann ein führender Unterstrich genutzt werden:

    _isValidAirbase()
    _buildZoneName()
    _logDebugMessage()

---

## Tabellen

Tabellen sollen klar strukturiert werden.

Beispiel:

    local baseNode = {
      id = "AKROTIRI",
      name = "Akrotiri",
      coalition = "BLUE",
      region = "CYPRUS",
      isLogisticsHub = true,
      isCaptured = true
    }

Tabellen sollen keine unklaren Kurzbezeichnungen enthalten.

Nicht:

    local b = {}
    local z = {}
    local x = {}

Besser:

    local baseNode = {}
    local zoneData = {}
    local missionState = {}

---

## Konstanten

Konstanten sollen später zentral definiert werden.

Geplante Datei:

    src/core/tc_config.lua

Mögliche Konstanten:

    TC_SIDE_BLUE = "BLUE"
    TC_SIDE_RED = "RED"
    TC_SIDE_NEUTRAL = "NEUTRAL"

    TC_STATUS_ACTIVE = "ACTIVE"
    TC_STATUS_INACTIVE = "INACTIVE"
    TC_STATUS_DESTROYED = "DESTROYED"

Bis zur konkreten Umsetzung sollen solche Werte einheitlich dokumentiert und nicht wild gemischt werden.

---

## Seiten und Koalitionen

Einheitliche Bezeichnungen:

    BLUE
    RED
    NEUTRAL

Nicht mischen mit:

    blue
    red
    coalitionBlue
    coalitionRed

Wenn DCS- oder Framework-Funktionen andere Werte verlangen, soll die Umwandlung zentral erfolgen.

---

## Logging

Log-Ausgaben sollen später über einen eigenen Logger laufen.

Geplante Datei:

    src/core/tc_logger.lua

Einheitlicher Prefix:

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
    [TC][ERROR] Failed to initialize airbase scanner

Warnungen:

    [TC][WARN] Airbase override missing
    [TC][WARN] CTLD pickup zone not found

Debug:

    [TC][DEBUG] Airbase scanner found 42 airbases

---

## Fehlerbehandlung

Fehler sollen sichtbar und nachvollziehbar sein.

Wichtige Fehler sollen in `dcs.log` erscheinen.

Beispiele:

    MIST nicht geladen
    MOOSE nicht geladen
    CTLD nicht geladen
    Skynet IADS nicht geladen
    benötigte Zone nicht gefunden
    Airbase nicht erkannt
    Modul nicht initialisiert

Ein Fehler soll nicht still ignoriert werden.

---

## Framework-Prüfung

`src/loader.lua` soll später prüfen, ob die externen Frameworks verfügbar sind.

Geplante Prüfungen:

    mist ~= nil
    BASE ~= nil
    ctld ~= nil
    SkynetIADS ~= nil

Hinweis:

Die genaue MOOSE-Prüfung wird später anhand der tatsächlich verfügbaren globalen MOOSE-Strukturen getestet.

Wenn ein Framework fehlt, soll Theater Command DCS eine klare Fehlermeldung ausgeben.

---

## Loader-Regeln

`src/loader.lua` wird später der technische Einstiegspunkt.

Aufgaben:

- `TC` initialisieren
- Projektversion setzen
- Frameworks prüfen
- Core-Dateien laden
- weitere Module laden
- `src/main.lua` starten
- Startstatus ausgeben

`loader.lua` soll keine große Kampagnenlogik enthalten.

Nicht in `loader.lua`:

- Airbase-Capture berechnen
- Missionen erzeugen
- CTLD-Lieferungen bewerten
- IADS-Netzwerke taktisch steuern
- Persistenz vollständig umsetzen

---

## Main-Regeln

`src/main.lua` startet später die Kampagne.

Aufgaben:

- Konfiguration laden
- Kampagnenzustand vorbereiten
- Systeme initialisieren
- Debug aktivieren
- Startmeldung ausgeben

`main.lua` verbindet Systeme.

`main.lua` ersetzt keine Einzelsysteme.

---

## Core-Regeln

Der Ordner `src/core/` enthält nur Grundfunktionen.

Geplante Dateien:

    tc_config.lua
    tc_logger.lua
    tc_state.lua
    tc_utils.lua
    tc_scheduler.lua

Core soll möglichst stabil und klein bleiben.

Core soll keine fachliche Kampagnenlogik enthalten.

Nicht in Core:

- Capture-Logik
- Missionsgenerator
- IADS-Sektorlogik
- FOB-System
- spezifische Airbase-Listen

---

## World-Regeln

Der Ordner `src/world/` enthält Welt- und Kartenlogik.

Geplante Dateien:

    tc_airbase_scanner.lua
    tc_airbase_registry.lua
    tc_airbase_overrides.lua
    tc_region_classifier.lua
    tc_zone_factory.lua
    tc_zone_registry.lua

World erkennt und strukturiert die DCS-Welt.

World entscheidet nicht allein über Kampagnenfortschritt.

---

## Campaign-Regeln

Der Ordner `src/campaign/` enthält strategischen Kampagnenzustand.

Geplante Dateien:

    tc_campaign_state.lua
    tc_base_ownership.lua
    tc_capture_system.lua
    tc_frontline_system.lua
    tc_persistence_system.lua

Campaign entscheidet über:

- Besitzstatus
- Capture-Status
- Kampagnenfortschritt
- strategische Zustände
- später Persistenz

---

## Logistics-Regeln

Der Ordner `src/logistics/` verbindet CTLD mit Theater Command DCS.

Geplante Dateien:

    tc_logistics_delivery.lua
    tc_fob_system.lua
    tc_logistics_state.lua
    tc_logistics_hubs.lua
    tc_supply_routes.lua

Grundsatz:

    CTLD führt aus.
    Theater Command bewertet.

Nicht in `CTLD.lua` ändern.

Eigene Logistiklogik gehört nach `src/logistics/`.

---

## Missions-Regeln

Der Ordner `src/missions/` erzeugt später dynamische Missionen.

Geplante Dateien:

    tc_mission_generator.lua
    tc_mission_registry.lua
    tc_mission_types.lua
    tc_mission_filter_by_aircraft.lua

Missionen sollen aus dem Kampagnenzustand entstehen.

Nicht als feste Mission-Editor-Triggerketten.

---

## AI-Regeln

Der Ordner `src/ai/` enthält später KI-Reaktionen.

Geplante Dateien:

    tc_ai_director.lua
    tc_ai_cap_manager.lua
    tc_ai_gci_manager.lua
    tc_ai_counterattack.lua

AI Director entscheidet über Reaktionen.

MOOSE kann technische AI-Funktionen bereitstellen.

Theater Command DCS entscheidet kampagnenlogisch.

---

## IADS-Regeln

Der Ordner `src/iads/` verbindet Skynet IADS mit Theater Command DCS.

Geplante Dateien:

    tc_iads_network.lua
    tc_iads_sites.lua
    tc_iads_sectors.lua
    tc_iads_state.lua
    tc_iads_config.lua

Grundsatz:

    Skynet IADS steuert taktisch.
    Theater Command bewertet strategisch.

Nicht in `SkynetIADS.lua` ändern.

Eigene IADS-Kampagnenlogik gehört nach `src/iads/`.

---

## UI-Regeln

Der Ordner `src/ui/` enthält später Spielerinteraktion.

Geplante Dateien:

    tc_f10_menu.lua
    tc_status_menu.lua
    tc_mission_menu.lua

F10-Menüs sollen klar strukturiert sein.

Keine unübersichtlichen Menüketten.

Mögliche Hauptmenüs:

    Theater Command
    Theater Command > Status
    Theater Command > Missions
    Theater Command > Logistics
    Theater Command > Debug

---

## Debug-Regeln

Der Ordner `src/debug/` enthält Debug- und Testhilfen.

Geplante Dateien:

    tc_debug_airbases.lua
    tc_debug_zones.lua
    tc_debug_capture.lua
    tc_debug_logistics.lua
    tc_debug_iads.lua

Debug soll abschaltbar sein.

Debug soll den normalen Missionsbetrieb nicht unnötig stören.

---

## Kommentare

Kommentare sollen erklären, warum etwas passiert.

Nicht jede offensichtliche Zeile kommentieren.

Gut:

    -- CTLD requires MIST to be loaded before CTLD.lua.

Schlecht:

    -- Set x to 1.
    local x = 1

Kommentare sollen besonders bei DCS- oder Framework-Besonderheiten genutzt werden.

---

## Sprache

Code und Dateinamen werden Englisch gehalten.

Dokumentation bleibt aktuell überwiegend Deutsch.

Log-Ausgaben können Englisch sein.

Beispiele:

    [TC] Airbase scanner initialized
    [TC][ERROR] MIST not available

---

## Formatierung

Einrückung:

    Zwei Leerzeichen oder zwei Spaces pro Ebene

Keine Tabs.

Beispiel:

    local function createBaseNode(airbase)
      local baseNode = {
        name = airbase:getName(),
        coalition = "UNKNOWN"
      }

      return baseNode
    end

Leerzeilen sollen logisch eingesetzt werden.

Keine unnötig langen Codeblöcke ohne Struktur.

---

## Lokale Variablen

Lokale Variablen bevorzugen.

Gut:

    local airbaseList = {}
    local zoneName = "CAPTURE_RED_LATTAKIA_01"

Schlecht:

    airbaseList = {}
    zoneName = "CAPTURE_RED_LATTAKIA_01"

Globale Variablen nur über `TC`.

---

## Rückgabewerte

Funktionen sollen nachvollziehbare Rückgabewerte haben.

Beispiele:

    return true
    return false, "Airbase not found"
    return baseNode
    return nil, "Invalid zone"

Fehler sollen nicht unklar bleiben.

---

## Defensive Programmierung

DCS-Missionen können unvollständig, falsch benannt oder fehlerhaft geladen sein.

Deshalb:

- Eingaben prüfen
- nil-Werte prüfen
- fehlende Gruppen prüfen
- fehlende Zonen prüfen
- fehlende Frameworks prüfen
- Fehlermeldung ausgeben
- nicht still abbrechen

Beispiel:

    if not mist then
      TC.logger.error("MIST not available")
      return false
    end

---

## Keine stillen Framework-Annahmen

Nicht annehmen, dass ein Framework geladen ist.

Vor Nutzung prüfen.

Beispiele:

    if not mist then
      TC.logger.error("MIST not loaded")
      return false
    end

    if not ctld then
      TC.logger.error("CTLD not loaded")
      return false
    end

---

## Persistenz-Regeln

Persistenz wird später erst gebaut, wenn Airbase-, Capture- und Logistiksystem stabil sind.

Geplante Datei:

    src/campaign/tc_persistence_system.lua

Nicht vorzeitig speichern:

- unklare Zwischenzustände
- Framework-interne Tabellen
- temporäre DCS-Objekte
- nicht serialisierbare Objekte

Speichern sollen später nur stabile Theater-Command-Daten.

---

## Testbarkeit

Jedes Modul soll später einzeln testbar sein.

Beispiel:

    tc_airbase_scanner.lua

Soll testbar ausgeben können:

- Anzahl erkannter Airbases
- erkannte Namen
- erkannte Koalitionen
- problematische Basen

Beispiel:

    tc_logistics_delivery.lua

Soll testbar ausgeben können:

- letzte Lieferung
- Zielzone
- Ressourceneffekt
- FOB-Fortschritt

---

## DCS-Log

Das DCS-Log ist später die wichtigste technische Fehlerquelle.

Wichtige Startmeldungen:

    [TC] Loading Theater Command DCS
    [TC] MIST available
    [TC] MOOSE available
    [TC] CTLD available
    [TC] Skynet IADS available
    [TC] Core initialized
    [TC] Theater Command ready

Fehler müssen dort sichtbar sein.

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
