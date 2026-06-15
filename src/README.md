# Source Code

Dieser Ordner enthält die eigene Lua-Logik von **Theater Command DCS**.

Alle Dateien in `src/` gehören zum eigentlichen Kampagnensystem.

Externe Frameworks liegen nicht hier, sondern unter `vendor/`.

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

---

## Architekturregel

Die eigene Lua-Struktur wird nach Aufgaben sortiert.

Sie wird nicht nach Frameworks sortiert.

Nicht gewünscht:

    src/tc_moose.lua
    src/tc_mist.lua
    src/tc_ctld.lua
    src/tc_all_in_one.lua

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

---

## Geplante Hauptdateien

### `loader.lua`

`loader.lua` wird später die zentrale Einstiegdatei für Theater Command DCS.

Aufgaben:

- globale `TC`-Tabelle vorbereiten
- Lade-Reihenfolge der eigenen Dateien definieren
- Framework-Verfügbarkeit prüfen
- Core-Systeme laden
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

---

### `world/`

Abbildung der DCS-Welt in Theater-Command-Strukturen.

Geplante Inhalte:

- Airbase-Scanner
- Airbase-Registry
- Zonen-Factory
- Zonen-Registry
- Karten- und Weltobjektlogik

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

---

### `logistics/`

Logistik und spätere CTLD-Anbindung.

Geplante Inhalte:

- Logistiklieferungen
- FOB-System
- Logistikhubs
- Versorgungslinien
- Verbindung zwischen CTLD und Kampagnenzustand

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

## Lade-Reihenfolge

Die externe Framework-Ladefolge ist:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua
    6. src/loader.lua

`src/loader.lua` startet danach die eigene Theater-Command-Struktur.

---

## Projektregel

`src/` enthält Theater Command DCS.

`vendor/` enthält externe Frameworks.

Frameworks werden nicht verändert.

Eigene Logik wird modular, aufgabenorientiert und schrittweise aufgebaut.
