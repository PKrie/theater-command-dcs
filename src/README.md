# Source Code

Dieser Ordner enthält die eigene Lua-Logik von **Theater Command DCS**.

Alle Dateien in `src/` gehören zum eigentlichen Kampagnensystem. Externe Frameworks liegen nicht hier, sondern unter `vendor/`.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut. Blau startet auf **Zypern / Akrotiri**. Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Zweck von `src/`

`src/` ist der Arbeitsbereich für die eigene Theater-Command-Logik.

Hier entstehen später:

- Loader
- Hauptinitialisierung
- Core-Systeme
- Airbase-Erkennung
- virtuelle Zonen
- Capture-System
- Logistiksystem
- Missionsgenerator
- AI Director
- IADS-Anbindung
- Persistenz
- F10-Menüs
- Debug-Werkzeuge

`src/` enthält keine externen Frameworks.

---

## Architekturregel

Theater Command DCS wird modular aufgebaut.

Externe Frameworks liegen unter:

    vendor/

Eigene Theater-Command-Logik liegt unter:

    src/

Die eigene Lua-Struktur wird nach Aufgaben sortiert.

Sie wird nicht nach Frameworks sortiert.

Nicht gewünscht:

    src/tc_moose.lua
    src/tc_mist.lua
    src/tc_ctld.lua
    src/tc_skynet.lua
    src/tc_all_in_one.lua
    src/tc_iads_all_in_one.lua

Gewünscht ist eine fachliche und technische Trennung nach Systemaufgaben.

Beispiele:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua
    src/campaign/tc_capture_system.lua
    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua
    src/missions/tc_mission_generator.lua
    src/ai/tc_ai_cap_manager.lua
    src/campaign/tc_persistence_system.lua

Eine Datei darf intern MIST, MOOSE, CTLD oder Skynet IADS nutzen.

Der Dateiname richtet sich aber immer nach der Aufgabe, nicht nach dem Framework.

---

## Aktueller Projektstand

Stand: 2026-06-16

Phase 0 ist fachlich abgeschlossen.

Vorhanden sind:

- zentrale Projektdokumentation
- docs-Grundblock
- vendor-Ordner
- dokumentierte Frameworks
- funktionale Vendor-Struktur
- `src/README.md`

Noch nicht begonnen ist die eigene Lua-Implementierung unter `src/`.

Der nächste Schritt ist der Aufbau der Core-Struktur.

---

## Aktueller Framework-Stand

Die externen Frameworks liegen unter `vendor/`.

Aktuell hinterlegt:

    MIST        vendor/mist/mist.lua                 4.5.128-DYNSLOTS-02
    MOOSE       vendor/moose/Moose.lua               2.9.17
    CTLD        vendor/ctld/CTLD.lua                 1.6.1
    Skynet IADS vendor/skynet-iads/SkynetIADS.lua    3.3.0

Diese Dateien werden nicht verändert.

Eigene Logik greift später auf diese Frameworks zu, ohne sie direkt anzupassen.

---

## DCS-Lade-Reihenfolge

Die externe Lade-Reihenfolge im DCS Mission Editor lautet:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua
    6. src/loader.lua

`src/loader.lua` startet danach die eigene Theater-Command-Struktur.

---

## Geplante Grundstruktur

Die geplante Struktur von `src/` lautet:

    src/
    ├── README.md
    ├── loader.lua
    ├── main.lua
    ├── core/
    │   └── README.md
    ├── world/
    │   └── README.md
    ├── campaign/
    │   └── README.md
    ├── logistics/
    │   └── README.md
    ├── missions/
    │   └── README.md
    ├── ai/
    │   └── README.md
    ├── iads/
    │   └── README.md
    ├── ui/
    │   └── README.md
    └── debug/
        └── README.md

Die Unterordner werden schrittweise angelegt.

Jede Datei wird einzeln erstellt und geprüft.

---

## Geplante Hauptdateien

### `loader.lua`

`loader.lua` wird später die zentrale Einstiegdatei für Theater Command DCS.

Aufgaben:

- globale `TC`-Tabelle vorbereiten
- Lade-Reihenfolge der eigenen Dateien definieren
- Framework-Verfügbarkeit prüfen
- Core-Systeme laden
- weitere Module laden
- `main.lua` starten
- Debug-Ausgaben beim Start ermöglichen

`loader.lua` wird im DCS Mission Editor nach den externen Frameworks geladen.

---

### `main.lua`

`main.lua` wird später die Hauptinitialisierung der Kampagne übernehmen.

Aufgaben:

- Theater Command starten
- Konfiguration laden
- Kampagnenzustand vorbereiten
- Airbase-System starten
- Zonen-System starten
- Capture-System starten
- Logistiksystem starten
- Missionsgenerator starten
- AI Director starten
- IADS-Anbindung starten
- Debugsysteme aktivieren

`main.lua` enthält keine großen Einzelsysteme.

Es verbindet nur die vorbereiteten Module.

---

## Geplante Unterordner

### `core/`

Grundfunktionen des Projekts.

Geplante Inhalte:

- Konfiguration
- Logger
- globale Zustandsverwaltung
- Utility-Funktionen
- Scheduler
- einfache Fehlerausgaben

Beispiele:

    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
    src/core/tc_utils.lua
    src/core/tc_scheduler.lua

---

### `world/`

Abbildung der DCS-Welt in Theater-Command-Strukturen.

Geplante Inhalte:

- Airbase-Scanner
- Airbase-Registry
- Zonen-Factory
- Zonen-Registry
- Karten- und Weltobjektlogik

Beispiele:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

---

### `campaign/`

Strategischer Kampagnenzustand.

Geplante Inhalte:

- Capture-System
- Besitzstatus von Basen
- Besitzstatus von Zonen
- Kampagnenfortschritt
- Persistenz-Anbindung
- strategische Zustandsdaten

Beispiele:

    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua

---

### `logistics/`

Logistik und spätere CTLD-Anbindung.

Geplante Inhalte:

- Logistiklieferungen
- FOB-System
- Logistikhubs
- Versorgungslinien
- Verbindung zwischen CTLD und Kampagnenzustand

Beispiele:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

---

### `missions/`

Dynamische Missionsgenerierung.

Geplante Inhalte:

- Missionsgenerator
- Missionsarten
- Missionsliste
- Zielauswahl
- Erfolgsauswertung
- Verbindung zu Airbases, IADS, Capture und Logistik

Beispiel:

    src/missions/tc_mission_generator.lua

---

### `ai/`

KI-Reaktionen und AI Director.

Geplante Inhalte:

- AI Director
- CAP-Manager
- GCI-Manager
- Reaktionslogik
- dynamische Verstärkung
- Eskalationslogik

Beispiel:

    src/ai/tc_ai_cap_manager.lua

---

### `iads/`

Eigene Kampagnenlogik rund um Skynet IADS.

Geplante Inhalte:

- IADS-Netzwerke
- IADS-Sektoren
- SAM-Standorte
- Radar-Standorte
- IADS-Zustand
- Verbindung zwischen IADS und Missionsgenerator

Skynet IADS selbst bleibt unverändert unter `vendor/skynet-iads/`.

---

### `ui/`

Spielerinteraktion.

Geplante Inhalte:

- F10-Menüs
- Statusanzeigen
- Missionsauswahl
- Debug-Menüs
- einfache Spielerkommandos

---

### `debug/`

Debug- und Testhilfen.

Geplante Inhalte:

- Debug-Ausgaben
- Zonendarstellung
- Airbase-Debug
- Capture-Debug
- Logistik-Debug
- IADS-Debug

---

## Geplanter Namespace

Theater Command DCS nutzt später eine zentrale globale Projekttabelle:

    TC

Nur diese globale Projektstruktur ist für eigene Theater-Command-Logik vorgesehen.

Nicht verwenden:

    TheaterCommand
    theaterCommand
    tc_global
    _G_TC

Geplante Grundstruktur:

    TC
    ├── Config
    ├── Logger
    ├── State
    ├── Utils
    ├── Scheduler
    ├── Core
    ├── World
    ├── Campaign
    ├── Logistics
    ├── Missions
    ├── AI
    ├── IADS
    ├── UI
    └── Debug

Die genaue technische Umsetzung erfolgt später in `src/loader.lua`, `src/main.lua` und den einzelnen Moduldateien.

---

## Geplante interne Lade-Reihenfolge

Nach dem Laden von `src/loader.lua` soll die eigene Theater-Command-Struktur später in dieser Reihenfolge geladen werden:

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

Der Core muss vor allen anderen eigenen Systemen verfügbar sein.

---

## Entwicklungsregel

Die Entwicklung erfolgt schrittweise.

Immer nur eine konkrete Datei oder Aufgabe pro Schritt.

Keine parallelen Großbaustellen.

Neue Dateien werden immer vollständig erstellt.

Keine halben Dateien.

Keine All-in-one-Dateien.

Frameworks unter `vendor/` werden nicht verändert.

---

## Zielbild

`src/` wird der zentrale Arbeitsbereich für das eigentliche Theater-Command-Kampagnensystem.

Ziel ist ein modulares, dynamisches und später persistentes DCS-Kampagnensystem.

Die Struktur soll langfristig bleiben:

- modular
- lesbar
- testbar
- erweiterbar
- wartbar

`src/` ist damit der eigentliche technische Kern von **Theater Command DCS**.
