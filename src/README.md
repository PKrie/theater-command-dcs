# Source Code

Dieser Ordner enthält die eigene Lua-Logik von **Theater Command DCS**.

Alle Dateien in `src/` gehören zum eigentlichen Kampagnensystem.

Externe Frameworks liegen nicht hier, sondern unter:

    vendor/

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut. Blau startet auf **Zypern / Akrotiri**. Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Zweck von `src/`

`src/` ist der Arbeitsbereich für die eigene Theater-Command-Logik.

Hier entstehen:

- Loader
- Hauptinitialisierung
- Core-Systeme
- Airbase-Erkennung
- virtuelle Zonen
- Capture-System
- Persistenzsystem
- Logistiksystem
- FOB-System
- Missionsgenerator
- AI-CAP-Manager
- IADS-Anbindung
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
    src/campaign/tc_persistence_system.lua
    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua
    src/missions/tc_mission_generator.lua
    src/ai/tc_ai_cap_manager.lua

Eine Datei darf intern DCS-API, MIST, MOOSE, CTLD oder Skynet IADS nutzen.

Der Dateiname richtet sich aber immer nach der Theater-Command-Aufgabe, nicht nach dem Framework.

---

## Aktueller Projektstand

Stand: 2026-06-16

Phase 0 ist fachlich abgeschlossen.

Der `src/`-Bereich ist begonnen.

Vorhanden sind:

- `src/README.md`
- `src/loader.lua`
- `src/main.lua`
- `src/core/`
- `src/world/`
- `src/campaign/`
- `src/logistics/`
- `src/missions/`
- `src/ai/`
- `src/iads/`
- `src/ui/`
- `src/debug/`

Die ersten eigenen Lua-Module sind erstellt.

Vorhandene aktive Lua-Module:

- `src/core/tc_config.lua`
- `src/core/tc_logger.lua`
- `src/core/tc_state.lua`
- `src/core/tc_utils.lua`
- `src/core/tc_scheduler.lua`
- `src/world/tc_airbase_scanner.lua`
- `src/world/tc_zone_factory.lua`
- `src/campaign/tc_capture_system.lua`
- `src/campaign/tc_persistence_system.lua`
- `src/logistics/tc_logistics_delivery.lua`
- `src/logistics/tc_fob_system.lua`
- `src/missions/tc_mission_generator.lua`
- `src/ai/tc_ai_cap_manager.lua`

Vorhandene Bereichsdokumentationen:

- `src/core/README.md`
- `src/world/README.md`
- `src/campaign/README.md`
- `src/logistics/README.md`
- `src/missions/README.md`
- `src/ai/README.md`
- `src/iads/README.md`
- `src/ui/README.md`
- `src/debug/README.md`

Noch nicht begonnen sind konkrete Lua-Implementierungen für:

- `src/iads/`
- `src/ui/`
- `src/debug/`

Diese Bereiche sind aktuell dokumentiert und vorbereitet, aber noch nicht aktiv implementiert.

---

## Aktueller Framework-Stand

Die externen Frameworks liegen unter `vendor/`.

Aktuell hinterlegt:

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Diese Dateien werden nicht verändert.

Eigene Theater-Command-Logik greift später auf diese Frameworks zu, ohne sie direkt anzupassen.

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

## Interne Lade-Reihenfolge

Die interne Theater-Command-Lade-Reihenfolge ist:

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

World muss vor Campaign, Logistics, Missions und AI verfügbar sein.

Campaign muss vor Logistics und Missions verfügbar sein.

Logistics muss vor Missions verfügbar sein.

Missions muss vor AI verfügbar sein.

IADS, UI und Debug werden später ergänzt, sobald konkrete Lua-Dateien dafür erstellt werden.

---

## Aktuelle Struktur

Die aktuelle Grundstruktur von `src/` lautet:

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
    │   └── README.md
    └── debug/
        └── README.md

Jede Datei wird einzeln erstellt und geprüft.

Keine parallelen Großbaustellen.

Keine All-in-one-Dateien.

---

## `loader.lua`

`loader.lua` ist die zentrale Einstiegdatei für Theater Command DCS.

Aufgaben:

- globale `TC`-Tabelle vorbereiten
- Framework-Verfügbarkeit prüfen
- eigene Lade-Reihenfolge definieren
- Core-Systeme laden
- World-Systeme laden
- Campaign-Systeme laden
- Logistics-Systeme laden
- Missions-Systeme laden
- AI-Systeme laden
- `main.lua` laden
- `main.lua` starten
- Fehler beim Start sichtbar machen

`loader.lua` wird im DCS Mission Editor nach den externen Frameworks geladen.

---

## `main.lua`

`main.lua` ist die Hauptinitialisierung der Kampagne.

Aufgaben:

- Theater Command starten
- Systembereiche initialisieren
- Core-Systeme verwenden
- World-Systeme starten
- Campaign-Systeme starten
- Logistics-Systeme starten
- Missionsgenerator starten
- AI-CAP-Manager starten
- spätere IADS-, UI- und Debugsysteme vorbereiten
- Startstatus im Log ausgeben

`main.lua` enthält keine großen Einzelsysteme.

Es verbindet nur die vorbereiteten Module.

---

## `core/`

`core/` enthält die technische Grundschicht.

Vorhandene Dateien:

    src/core/README.md
    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
    src/core/tc_utils.lua
    src/core/tc_scheduler.lua

Aufgaben:

- zentrale Konfiguration
- Logging
- globale Zustandsverwaltung
- Utility-Funktionen
- Scheduler-Grundfunktionen
- einfache Fehler- und Debug-Ausgaben

Der Core soll möglichst wenig von späteren Systemen abhängig sein.

Andere Systeme dürfen auf den Core zugreifen.

---

## `world/`

`world/` bildet die DCS-Welt in Theater-Command-Strukturen ab.

Vorhandene Dateien:

    src/world/README.md
    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

Aufgaben:

- Airbases aus DCS lesen
- Airbases normalisieren
- Airbases im State registrieren
- initialen Besitzstatus vorbereiten
- virtuelle Airbase-Zonen erzeugen
- optionale Mission-Editor-Zonen einlesen
- Zonen im State registrieren

World trifft keine strategischen Kampagnenentscheidungen.

World liefert die räumliche Grundlage.

---

## `campaign/`

`campaign/` enthält die strategische Kampagnenlogik.

Vorhandene Dateien:

    src/campaign/README.md
    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua

Aufgaben:

- Besitzstatus von Basen lesen
- Besitzstatus von Zonen lesen
- Besitzstatus ändern
- Capture-Ereignisse speichern
- Campaign-State aktualisieren
- State als dirty markieren
- In-Memory-Persistenz vorbereiten
- State-Export und State-Import vorbereiten

Besitzwechsel bleiben Aufgabe des Capture-Systems.

Persistenz speichert Theater-Command-State, nicht Vendor-Dateien.

---

## `logistics/`

`logistics/` enthält Versorgung, Lieferungen und FOB-Aufbau.

Vorhandene Dateien:

    src/logistics/README.md
    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

Aufgaben:

- Logistiklieferungen anlegen
- Lieferstatus verwalten
- Lieferungen als abgeschlossen, verloren oder abgebrochen markieren
- logistische Effekte auf Zonen und Basen anwenden
- FOBs anlegen
- FOB-Zustand verwalten
- FOB-Versorgung verwalten
- FOB-Baufortschritt verwalten
- spätere CTLD-Anbindung vorbereiten

CTLD wird nicht verändert.

Theater Command bewertet später die strategische Bedeutung von CTLD-Ereignissen.

---

## `missions/`

`missions/` enthält die dynamische Missionsgenerierung.

Vorhandene Dateien:

    src/missions/README.md
    src/missions/tc_mission_generator.lua

Aufgaben:

- Missionsarten verwalten
- Missionen aus Kampagnenzustand erzeugen
- Missionen im State speichern
- verfügbare Missionen verwalten
- aktive Missionen verwalten
- abgeschlossene Missionen verwalten
- fehlgeschlagene Missionen verwalten
- einfache Folgeeffekte vorbereiten
- Logistikmissionen mit Logistics verbinden
- FOB-Support-Missionen vorbereiten

Der Missionsgenerator erzeugt Aufträge.

Strategische Besitzänderungen bleiben Aufgabe des Capture-Systems.

---

## `ai/`

`ai/` enthält die KI-Reaktionslogik.

Vorhandene Dateien:

    src/ai/README.md
    src/ai/tc_ai_cap_manager.lua

Aufgaben:

- CAP-Zonen registrieren
- CAP-Bedarf aus dem State ableiten
- CAP-Anforderungen im State speichern
- aktive CAPs verwalten
- abgeschlossene CAPs verwalten
- fehlgeschlagene CAPs verwalten
- Reaktionsstatus vorbereiten
- Bedrohungsniveau vorbereiten
- spätere MOOSE-Anbindung vorbereiten

Der AI-Bereich verändert keine Besitzstände.

AI reagiert auf vorhandene Kampagnendaten.

---

## `iads/`

`iads/` enthält die spätere Theater-Command-Schicht rund um Skynet IADS.

Vorhandene Dateien:

    src/iads/README.md

Geplante Aufgaben:

- IADS-Netzwerke vorbereiten
- IADS-Sektoren verwalten
- SAM-Standorte verwalten
- Radar-Standorte verwalten
- IADS-Zustand im State speichern
- SEAD- und DEAD-Ziele vorbereiten
- Verbindung zu Missionsgenerator und AI vorbereiten

Konkrete Lua-Implementierungen sind hier noch nicht begonnen.

Skynet IADS bleibt unverändert unter:

    vendor/skynet-iads/

---

## `ui/`

`ui/` enthält die spätere Spielerinteraktion.

Vorhandene Dateien:

    src/ui/README.md

Geplante Aufgaben:

- F10-Menüs vorbereiten
- Kampagnenstatus anzeigen
- Missionsliste anzeigen
- aktive Missionen anzeigen
- Logistikstatus anzeigen
- FOB-Status anzeigen
- AI-Status anzeigen
- IADS-Status anzeigen
- Spielerkommandos vorbereiten

Konkrete Lua-Implementierungen sind hier noch nicht begonnen.

UI zeigt Daten an und ruft definierte Funktionen anderer Systeme auf.

---

## `debug/`

`debug/` enthält spätere Debug- und Testhilfen.

Vorhandene Dateien:

    src/debug/README.md

Geplante Aufgaben:

- State-Dumps vorbereiten
- Airbase-Reports vorbereiten
- Zonen-Reports vorbereiten
- Capture-Reports vorbereiten
- Logistik-Reports vorbereiten
- Missions-Reports vorbereiten
- AI-Reports vorbereiten
- IADS-Reports vorbereiten
- optionale Debug-Menüs vorbereiten

Konkrete Lua-Implementierungen sind hier noch nicht begonnen.

Debug darf keine versteckte Kampagnenhauptlogik enthalten.

---

## Geplanter Namespace

Theater Command DCS nutzt eine zentrale globale Projekttabelle:

    TC

Nur diese globale Projektstruktur ist für eigene Theater-Command-Logik vorgesehen.

Nicht verwenden:

    TheaterCommand
    theaterCommand
    tc_global
    _G_TC

Aktuelle und geplante Struktur:

    TC
    ├── Config
    ├── Logger
    ├── State
    ├── Utils
    ├── Scheduler
    ├── Loader
    ├── Main
    ├── World
    ├── Campaign
    ├── Logistics
    ├── Missions
    ├── AI
    ├── IADS
    ├── UI
    └── Debug

Die genaue technische Umsetzung erfolgt in:

    src/loader.lua
    src/main.lua
    src/core/
    src/world/
    src/campaign/
    src/logistics/
    src/missions/
    src/ai/

IADS, UI und Debug werden später konkret implementiert.

---

## Entwicklungsregel

Die Entwicklung erfolgt schrittweise.

Immer nur eine konkrete Datei oder Aufgabe pro Schritt.

Keine parallelen Großbaustellen.

Neue Dateien werden immer vollständig erstellt.

Keine halben Dateien.

Keine All-in-one-Dateien.

Frameworks unter `vendor/` werden nicht verändert.

Eigene Theater-Command-Logik gehört nach `src/`.

Die eigene Lua-Struktur wird nach Aufgaben sortiert, nicht nach Frameworks.

---

## Nächster sinnvoller Fokus

Der technische Grundaufbau unter `src/` ist weitgehend angelegt.

Der nächste sinnvolle Fokus ist die Aktualisierung der zentralen Projektdateien, damit sie den neuen Source-Stand korrekt abbilden.

Besonders zu prüfen sind:

    TASKS.md
    CHANGELOG.md
    ROADMAP.md
    ARCHITECTURE.md
    README.md

Diese Aktualisierung soll ebenfalls einzeln pro Datei erfolgen.

---

## Zielbild

`src/` ist der zentrale Arbeitsbereich für das eigentliche Theater-Command-Kampagnensystem.

Ziel ist ein modulares, dynamisches und später persistentes DCS-Kampagnensystem.

Die Struktur soll langfristig bleiben:

- modular
- lesbar
- testbar
- erweiterbar
- wartbar

`src/` ist damit der technische Kern von **Theater Command DCS**.
