# Architecture

Diese Datei beschreibt die technische Grundarchitektur von **Theater Command DCS**.

Theater Command DCS ist ein modulares, dynamisches und später persistentes DCS-World-Kampagnensystem.

Die erste Kampagne trägt den Arbeitstitel:

**Operation Levant Reclamation**

Die Kampagne wird auf der **Syria Map** aufgebaut.

Blau startet auf **Zypern / Akrotiri**.

Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Architekturprinzip

Das zentrale Architekturprinzip lautet:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der DCS Mission Editor stellt die physische Umgebung bereit.

Lua übernimmt die Kampagnenlogik.

GitHub dokumentiert Struktur, Entscheidungen, Versionen und Aufgabenstand.

---

## Zielbild

Theater Command DCS soll langfristig folgende Systeme verbinden:

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

Der Mission Editor soll möglichst schlank bleiben.

Alles, was sinnvoll durch Lua erkannt, erzeugt oder gesteuert werden kann, soll nicht manuell als große Triggerkette im Mission Editor gebaut werden.

---

## Aktueller technischer Stand

Stand:

    2026-06-15

Aktuell vorhanden:

- zentrale Projektdateien
- `docs/`-Grundblock
- `vendor/`-Ordner
- MIST
- MOOSE
- CTLD
- Skynet IADS
- `src/README.md`

Noch nicht begonnen:

- eigene Lua-Core-Dateien
- `src/loader.lua`
- `src/main.lua`
- eigene Airbase-Erkennung
- eigene Zonenlogik
- eigenes Capture-System
- eigene Logistik-Anbindung
- eigener Missionsgenerator
- eigener AI Director
- eigene IADS-Kampagnenlogik
- Persistenz
- DEV-Mission im DCS Mission Editor

---

## Haupttrennung

Das Projekt trennt klar zwischen externen Frameworks und eigener Kampagnenlogik.

Externe Frameworks liegen unter:

    vendor/

Eigene Theater-Command-Logik liegt unter:

    src/

Diese Trennung ist verbindlich.

Frameworks werden nicht verändert.

Eigene Projektlogik wird nicht in Framework-Dateien geschrieben.

---

## Vendor-Architektur

Der Ordner `vendor/` enthält externe Frameworks.

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

Geplante Nutzung:

- DCS-Hilfsfunktionen
- Datenbankfunktionen
- Gruppenlogik
- Koordinatenlogik
- Hilfsfunktionen für dynamische Missionen
- technische Grundlage für CTLD
- Unterstützung bei dynamischem Spawning
- Unterstützung bei Event-Auswertung
- spätere Debug- und Testhilfen

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

Geplante Nutzung:

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

MOOSE wird im Projekt nicht durch eigene Sammeldateien gekapselt.

Nicht gewünscht:

    src/tc_moose.lua

Eigene Dateien dürfen MOOSE intern nutzen, müssen aber nach ihrer Aufgabe benannt werden.

---

## CTLD

CTLD liegt unter:

    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua

CTLD wird als Logistik- und Helikopter-Framework genutzt.

Geplante Nutzung:

- Truppentransport
- Kistentransport
- Logistikflüge
- FOB-Aufbau
- Pickup-Zonen
- Dropoff-Zonen
- Heli-Interaktion
- spätere Verbindung mit dem Theater-Command-Logistiksystem

CTLD entscheidet nicht über strategischen Kampagnenfortschritt.

CTLD führt technische Transportvorgänge aus.

Theater Command DCS entscheidet, welche kampagnenlogische Wirkung diese Vorgänge haben.

Beispiel:

Eine CTLD-Kistenlieferung kann technisch erfolgreich sein.

Erst Theater Command DCS entscheidet, ob dadurch eine FOB-Struktur entsteht, eine Zone versorgt wird oder eine Basis neue Ressourcen erhält.

---

## Skynet IADS

Skynet IADS liegt unter:

    vendor/skynet-iads/SkynetIADS.lua

Verwendet wird die kompilierte Skynet-IADS-Datei aus dem offiziellen Repository.

Skynet IADS wird für taktisches Radar- und SAM-Verhalten genutzt.

Geplante Nutzung:

- rote IADS-Netzwerke
- Radarlogik
- SAM-Verhalten
- Emissionskontrolle
- SEAD-Reaktionen
- DEAD-Reaktionen
- Luftverteidigungssektoren
- Verbindung mit AI Director
- Verbindung mit Missionsgenerator
- Verbindung mit Persistenz

Skynet IADS steuert taktisches Verhalten.

Theater Command DCS entscheidet über den strategischen Zustand.

Beispiel:

Skynet IADS kann ein SAM-Netzwerk taktisch steuern.

Theater Command DCS entscheidet, ob dieses Netzwerk verfügbar ist, beschädigt wurde, wiederaufgebaut wird oder als strategisches Ziel für Missionen dient.

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
- `src/loader.lua` wird später der Einstiegspunkt für die eigene Projektlogik.

---

## Source-Architektur

Der Ordner `src/` enthält die eigene Theater-Command-Lua-Logik.

Aktuell existiert:

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

Die Struktur wird nach Aufgaben sortiert.

Sie wird nicht nach Frameworks sortiert.

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

## Loader-Konzept

Die Datei `src/loader.lua` wird später der Einstiegspunkt der eigenen Lua-Logik.

Geplante Aufgaben:

- globale `TC`-Tabelle initialisieren
- Projektversion vorbereiten
- Framework-Verfügbarkeit prüfen
- eigene Lade-Reihenfolge definieren
- Core-Dateien laden
- `main.lua` starten
- Debug-Ausgaben im `dcs.log` erzeugen
- Fehler bei fehlenden Frameworks sichtbar machen

`loader.lua` enthält keine große Kampagnenlogik.

Es lädt nur kontrolliert die eigentlichen Module.

---

## Main-Konzept

Die Datei `src/main.lua` wird später die Hauptinitialisierung der Kampagne übernehmen.

Geplante Aufgaben:

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

`main.lua` verbindet Systeme.

`main.lua` enthält keine großen Einzelsysteme.

---

## Core-System

Der Ordner `src/core/` wird später grundlegende Projektfunktionen enthalten.

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
- Hilfsfunktionen
- Scheduler
- Fehlerausgabe
- Framework-Prüfung
- globale Konstanten

Das Core-System soll möglichst klein und stabil bleiben.

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

## Mission-Editor-Architektur

Der Mission Editor soll später nur die physische Bühne bereitstellen.

Geplante Mission:

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

## Persistenz-Architektur

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

Zuerst muss klar sein, welche Daten überhaupt stabil gespeichert werden müssen.

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

## Modulentwurf

Jedes Modul soll eine klare Aufgabe haben.

Ein Modul soll nicht mehrere große Systeme gleichzeitig steuern.

Beispiel:

    tc_airbase_scanner.lua

Aufgabe:

    DCS-Airbases erkennen und Rohdaten liefern.

Nicht Aufgabe:

    Capture steuern
    Logistik berechnen
    Missionen erzeugen
    Persistenz schreiben

Beispiel:

    tc_capture_system.lua

Aufgabe:

    Besitzwechsel und Capture-Bedingungen auswerten.

Nicht Aufgabe:

    CTLD-Menüs bauen
    MOOSE-Spawns verwalten
    IADS-Netzwerke konfigurieren

---

## Abhängigkeiten

Geplante Abhängigkeiten:

    core
      ↓
    world
      ↓
    campaign
      ↓
    logistics / missions / ai / iads
      ↓
    ui / debug / persistence

Abhängigkeiten sollen möglichst nur in eine Richtung laufen.

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

## Aktueller nächster Architektur-Schritt

Nach der Dokumentationsaktualisierung beginnt die praktische Lua-Struktur.

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
