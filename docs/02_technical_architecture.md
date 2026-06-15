# Technical Architecture

Diese Datei beschreibt die technische Architektur von **Theater Command DCS**.

Theater Command DCS ist ein modulares, dynamisches und später persistentes DCS-World-Kampagnensystem für DCS World.

Die erste Kampagne trägt den Arbeitstitel:

**Operation Levant Reclamation**

Die Kampagne wird auf der **Syria Map** aufgebaut.

Blau startet auf **Zypern / Akrotiri**.

Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Grundprinzip

Das technische Grundprinzip lautet:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Mission Editor stellt die physische Spielumgebung bereit.

Lua steuert die dynamische Kampagnenlogik.

GitHub dokumentiert Architektur, Aufgaben, Versionen, Entscheidungen und Fortschritt.

---

## Ziel der technischen Architektur

Theater Command DCS soll später folgende Systeme verbinden:

- Airbase-Erkennung
- virtuelle Zonen
- Capture-System
- Logistiksystem
- CTLD-Anbindung
- FOB-System
- dynamische Missionsgenerierung
- AI Director
- CAP- und GCI-Management
- Skynet-IADS-Anbindung
- Persistenz
- F10-Menüs
- Debug- und Testsysteme

Die technische Architektur soll modular bleiben.

Jedes System soll eine klare Aufgabe haben.

Große All-in-one-Dateien werden vermieden.

---

## Aktueller technischer Stand

Stand:

    2026-06-15

Aktuell vorhanden:

- zentrale Projektdateien
- `docs/`-Grundblock
- `vendor/`-Frameworkstruktur
- MIST
- MOOSE
- CTLD
- Skynet IADS
- `src/README.md`

Noch nicht vorhanden:

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
- DEV-Mission im DCS Mission Editor

---

## Haupttrennung

Die wichtigste technische Trennung lautet:

    vendor/ = externe Frameworks
    src/ = eigene Theater-Command-Logik

Externe Frameworks werden nicht verändert.

Eigene Projektlogik wird nicht in Framework-Dateien geschrieben.

Frameworks stellen technische Funktionen bereit.

Theater Command DCS entscheidet über die Kampagnenlogik.

---

## Vendor-System

Der Ordner `vendor/` enthält die externen Frameworks.

Aktueller Framework-Stand:

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Zusätzliche Referenzdateien:

    vendor/mist/Mist guide.pdf
    vendor/mist/Example_DBs/
    vendor/moose/MOOSE_DOCS.md

---

## MIST

MIST liegt unter:

    vendor/mist/mist.lua

MIST wird als Utility-Schicht genutzt.

Geplante technische Nutzung:

- DCS-Hilfsfunktionen
- Datenbankfunktionen
- Gruppenlogik
- Koordinatenlogik
- Hilfsfunktionen für dynamische Missionen
- Grundlage für CTLD
- Unterstützung bei dynamischem Spawning
- Unterstützung bei Event-Auswertung
- Debug- und Testhilfen

Besonderheit:

Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket.

Grund:

CTLD weist darauf hin, dass für korrektes dynamisches Spawning die mit CTLD gelieferte MIST-Version verwendet werden soll.

Aktive Kombination:

    MIST: 4.5.128-DYNSLOTS-02
    CTLD: 1.6.1

---

## MOOSE

MOOSE liegt unter:

    vendor/moose/Moose.lua

MOOSE wird als objektorientierte DCS-Framework-Schicht genutzt.

Geplante technische Nutzung:

- Wrapper für DCS-Objekte
- Scheduler
- SETs
- Spawning
- Airbase-Wrapper
- Zonenlogik
- Gruppenverwaltung
- CAP-Management
- GCI-Management
- AI-Management
- Debug- und Testfunktionen

MOOSE bleibt ein Werkzeug.

Eigene Theater-Command-Dateien dürfen MOOSE intern nutzen.

Es wird aber keine eigene Framework-Sammeldatei erstellt.

Nicht gewünscht:

    src/tc_moose.lua

---

## CTLD

CTLD liegt unter:

    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua

CTLD wird als Logistik- und Helikopter-Framework genutzt.

Geplante technische Nutzung:

- Truppentransport
- Kistentransport
- Logistikflüge
- Pickup-Zonen
- Dropoff-Zonen
- FOB-Aufbau
- Heli-Interaktion

CTLD führt technische Logistikvorgänge aus.

Theater Command DCS bewertet später die kampagnenlogische Wirkung.

Beispiel:

Eine CTLD-Kiste wird technisch abgesetzt.

Theater Command DCS entscheidet, ob dadurch eine Basis versorgt wird, ein FOB entsteht oder eine Capture-Zone beeinflusst wird.

---

## Skynet IADS

Skynet IADS liegt unter:

    vendor/skynet-iads/SkynetIADS.lua

Skynet IADS wird als Framework für integrierte Luftverteidigung genutzt.

Verwendet wird die kompilierte Skynet-IADS-Datei.

Geplante technische Nutzung:

- IADS-Netzwerke
- Radarlogik
- SAM-Verhalten
- Emissionskontrolle
- SEAD-Reaktionen
- DEAD-Reaktionen
- Luftverteidigungssektoren

Skynet IADS steuert taktisches Verhalten.

Theater Command DCS entscheidet über den strategischen IADS-Zustand.

Beispiel:

Skynet IADS steuert ein SAM-Netzwerk taktisch.

Theater Command DCS entscheidet, ob dieser IADS-Sektor aktiv, beschädigt, zerstört, wiederaufgebaut oder als Missionsziel verfügbar ist.

---

## Geplante Lade-Reihenfolge

Die Frameworks und die spätere eigene Theater-Command-Logik sollen im DCS Mission Editor in dieser Reihenfolge geladen werden:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua
    6. src/loader.lua

Wichtige Regeln:

- MIST wird vor CTLD geladen.
- `CTLD-i18n.lua` wird vor `CTLD.lua` geladen.
- Skynet IADS wird nach MIST geladen.
- Die eigene Theater-Command-Logik startet erst nach allen externen Frameworks.
- `src/loader.lua` wird später der Einstiegspunkt für Theater Command DCS.

---

## Source-System

Der Ordner `src/` enthält die eigene Lua-Logik von Theater Command DCS.

Aktuell vorhanden:

    src/README.md

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

Die Struktur wird nach Aufgaben sortiert, nicht nach Frameworks.

Nicht gewünscht:

    src/tc_moose.lua
    src/tc_mist.lua
    src/tc_ctld.lua
    src/tc_all_in_one.lua

Gewünscht:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua
    src/campaign/tc_capture_system.lua
    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua
    src/missions/tc_mission_generator.lua
    src/ai/tc_ai_cap_manager.lua
    src/campaign/tc_persistence_system.lua

---

## Loader-System

Die Datei `src/loader.lua` wird später der technische Einstiegspunkt für Theater Command DCS.

Geplante Aufgaben:

- globale `TC`-Tabelle erzeugen
- Projektversion setzen
- Framework-Verfügbarkeit prüfen
- Lade-Reihenfolge der eigenen Module definieren
- Core-Dateien laden
- `src/main.lua` starten
- Fehler bei fehlenden Frameworks sichtbar machen
- erste Debug-Ausgabe in `dcs.log` erzeugen

`loader.lua` soll keine große Kampagnenlogik enthalten.

Die Datei lädt und prüft nur die Projektstruktur.

---

## Main-System

Die Datei `src/main.lua` wird später die eigentliche Kampagneninitialisierung starten.

Geplante Aufgaben:

- Theater Command DCS initialisieren
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

`main.lua` verbindet Systeme.

`main.lua` ersetzt keine Einzelsysteme.

---

## Core-System

Der Ordner `src/core/` enthält später die technische Basis des Projekts.

Geplante Dateien:

    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
    src/core/tc_utils.lua
    src/core/tc_scheduler.lua

Geplante Aufgaben:

- zentrale Konfiguration
- Logging
- globale Zustandsverwaltung
- Utility-Funktionen
- Scheduler
- Fehlerausgabe
- Framework-Prüfung
- globale Konstanten

Das Core-System soll klein, stabil und unabhängig bleiben.

---

## World-System

Der Ordner `src/world/` bildet später die DCS-Welt in Theater-Command-Strukturen ab.

Geplante Dateien:

    src/world/tc_airbase_scanner.lua
    src/world/tc_airbase_registry.lua
    src/world/tc_airbase_overrides.lua
    src/world/tc_region_classifier.lua
    src/world/tc_zone_factory.lua
    src/world/tc_zone_registry.lua

Geplante Aufgaben:

- Airbases erkennen
- Airbases registrieren
- Koalitionsstatus erfassen
- Regionen klassifizieren
- virtuelle Capture-Zonen erzeugen
- virtuelle Logistik-Zonen erzeugen
- virtuelle Defense-Zonen erzeugen
- Weltobjekte für andere Systeme bereitstellen

---

## Campaign-System

Der Ordner `src/campaign/` enthält später den strategischen Kampagnenzustand.

Geplante Dateien:

    src/campaign/tc_campaign_state.lua
    src/campaign/tc_base_ownership.lua
    src/campaign/tc_capture_system.lua
    src/campaign/tc_frontline_system.lua
    src/campaign/tc_persistence_system.lua

Geplante Aufgaben:

- Kampagnenzustand verwalten
- Basenbesitz verwalten
- Zonenbesitz verwalten
- Capture-Bedingungen auswerten
- Kampagnenfortschritt bewerten
- Frontlogik vorbereiten
- Persistenz vorbereiten
- strategische Entscheidungen speichern

---

## Logistics-System

Der Ordner `src/logistics/` verbindet CTLD mit Theater Command DCS.

Geplante Dateien:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua
    src/logistics/tc_logistics_state.lua
    src/logistics/tc_logistics_hubs.lua
    src/logistics/tc_supply_routes.lua

Geplante Aufgaben:

- CTLD-Lieferungen auswerten
- FOB-Aufbau bewerten
- Logistikhubs verwalten
- Versorgungslinien vorbereiten
- Ressourcenstatus speichern
- Logistik mit Capture-System verbinden
- Logistik mit Missionsgenerator verbinden

Grundsatz:

    CTLD führt aus.
    Theater Command bewertet.

---

## Missions-System

Der Ordner `src/missions/` erzeugt später dynamische Missionen.

Geplante Dateien:

    src/missions/tc_mission_generator.lua
    src/missions/tc_mission_registry.lua
    src/missions/tc_mission_types.lua
    src/missions/tc_mission_filter_by_aircraft.lua

Geplante Aufgaben:

- Spielerflugzeug erkennen
- Missionen nach Flugzeugtyp filtern
- Missionen aus Kampagnenlage ableiten
- Airbase-Ziele auswählen
- SEAD/DEAD-Ziele auswählen
- Logistikziele auswählen
- Missionen über F10-Menü anbieten
- Missionserfolg auswerten

---

## AI-System

Der Ordner `src/ai/` enthält später KI-Reaktionen und den AI Director.

Geplante Dateien:

    src/ai/tc_ai_director.lua
    src/ai/tc_ai_cap_manager.lua
    src/ai/tc_ai_gci_manager.lua
    src/ai/tc_ai_counterattack.lua

Geplante Aufgaben:

- CAP steuern
- GCI steuern
- KI-Reaktionen auf Spielerfortschritt vorbereiten
- KI-Reaktionen auf Capture-Ereignisse vorbereiten
- KI-Reaktionen auf IADS-Schäden vorbereiten
- Gegenangriffe vorbereiten
- Eskalationslogik vorbereiten

---

## IADS-System

Der Ordner `src/iads/` verbindet Skynet IADS mit Theater Command DCS.

Geplante Dateien:

    src/iads/tc_iads_network.lua
    src/iads/tc_iads_sites.lua
    src/iads/tc_iads_sectors.lua
    src/iads/tc_iads_state.lua
    src/iads/tc_iads_config.lua

Geplante Aufgaben:

- IADS-Sektoren definieren
- SAM-Stellungen als Kampagnenobjekte verwalten
- Radarstellungen als Kampagnenobjekte verwalten
- Skynet-IADS-Netzwerke initialisieren
- zerstörte IADS-Komponenten auswerten
- IADS-Zustand für Persistenz vorbereiten
- IADS-Ziele an Missionsgenerator liefern
- IADS-Zustand an AI Director liefern

---

## UI-System

Der Ordner `src/ui/` enthält später Spielerinteraktion.

Geplante Dateien:

    src/ui/tc_f10_menu.lua
    src/ui/tc_status_menu.lua
    src/ui/tc_mission_menu.lua

Geplante Aufgaben:

- F10-Menüs erzeugen
- Status anzeigen
- Missionen auswählbar machen
- Debugfunktionen erreichbar machen
- einfache Spielerkommandos ermöglichen

---

## Debug-System

Der Ordner `src/debug/` enthält später Debug- und Testhilfen.

Geplante Dateien:

    src/debug/tc_debug_airbases.lua
    src/debug/tc_debug_zones.lua
    src/debug/tc_debug_capture.lua
    src/debug/tc_debug_logistics.lua
    src/debug/tc_debug_iads.lua

Geplante Aufgaben:

- erkannte Airbases anzeigen
- virtuelle Zonen anzeigen
- Capture-Status ausgeben
- Logistikstatus ausgeben
- IADS-Status ausgeben
- Ladezustand prüfen
- Fehleranalyse erleichtern

---

## Mission-Editor-Anbindung

Der DCS Mission Editor soll später nur die physische Bühne bereitstellen.

Geplante DEV-Mission:

    Operation_Levant_Reclamation_DEV.miz

Der Mission Editor enthält später:

- Karte
- Koalitionen
- Spieler-Slots
- notwendige Trigger zum Laden der Lua-Dateien
- Template-Gruppen mit Late Activation
- CTLD-Startzonen
- statische Ziele
- erste Testumgebung

Der Mission Editor soll nicht enthalten:

- große Kampagnenlogik
- komplexe Triggerketten
- manuell gepflegte Basenbesitzlogik
- manuell gepflegte Frontlinienlogik
- manuell gepflegte Missionsgeneratorlogik

Diese Logik gehört nach Lua.

---

## Persistenz

Persistenz wird erst aufgebaut, wenn Airbase-, Capture- und Logistiksystem existieren.

Geplante Dateien:

    src/campaign/tc_persistence_system.lua
    save/README.md
    save/example_state.lua

Später zu speichernde Werte:

- Besitz jeder Basis
- Besitz jeder Zone
- aktive FOBs
- Ressourcenstatus
- Logistikstatus
- IADS-Zustand
- zerstörte strategische Ziele
- Missionshistorie
- Kampagnenphase

Persistenz wird nicht am Anfang gebaut.

Zuerst muss klar sein, welche Daten stabil gespeichert werden müssen.

---

## Datenfluss

Geplanter Datenfluss:

    DCS World
        ↓
    Frameworks
        ↓
    Theater Command Loader
        ↓
    Core-System
        ↓
    World-System
        ↓
    Campaign-System
        ↓
    Logistics / Missions / AI / IADS
        ↓
    UI / Debug / Persistenz

Frameworks liefern technische Funktionen.

Theater Command DCS interpretiert diese Funktionen kampagnenlogisch.

---

## Abhängigkeitsregel

Abhängigkeiten sollen möglichst nur in eine Richtung laufen.

Geplant:

    core
      ↓
    world
      ↓
    campaign
      ↓
    logistics / missions / ai / iads
      ↓
    ui / debug / persistence

Verhindert werden sollen:

- zyklische Abhängigkeiten
- unklare globale Seiteneffekte
- direkte Kopplung aller Module an alle Frameworks
- große All-in-one-Dateien

---

## Globale Tabelle

Die eigene Projektlogik soll später über eine globale Tabelle erreichbar sein:

    TC

Geplante Struktur:

    TC = {
      version = "...",
      config = {},
      state = {},
      modules = {},
      debug = {}
    }

Diese Struktur wird später in `src/loader.lua` und `src/main.lua` konkret umgesetzt.

---

## Namensregeln

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

Framework-Dateien behalten ihre externen Namen oder stabile Projektnamen:

    mist.lua
    Moose.lua
    CTLD-i18n.lua
    CTLD.lua
    SkynetIADS.lua

---

## Aktueller nächster technischer Schritt

Nach Abschluss der aktuellen Dokumentationsaktualisierung beginnt die praktische `src/`-Struktur.

Nächster technischer Fokus:

    src-Unterordner und README-Dateien erstellen

Danach:

    src/loader.lua
    src/main.lua
    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua

---

## Architekturregel

Theater Command DCS bleibt modular.

Frameworks sind Werkzeuge.

Die Kampagne ist die eigene Logik.

Keine All-in-one-Datei.

Keine Framework-Sammeldateien.

Keine unnötig große Mission-Editor-Triggerlogik.
