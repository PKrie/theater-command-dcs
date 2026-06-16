# Architecture

Diese Datei beschreibt die technische Grundarchitektur von **Theater Command DCS**.

Theater Command DCS ist ein modulares, dynamisches und später persistentes DCS-World-Kampagnensystem.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut. Blau startet auf **Zypern / Akrotiri**. Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

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

Stand: 2026-06-16

Aktuell vorhanden:

- zentrale Projektdateien
- `docs/`-Grundblock
- `vendor/`-Ordner
- MIST
- MOOSE
- CTLD
- Skynet IADS
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

Aktuell vorhandene aktive eigene Lua-Module:

- `src/loader.lua`
- `src/main.lua`
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

Aktuell vorhandene Source-Dokumentationen:

- `src/core/README.md`
- `src/world/README.md`
- `src/campaign/README.md`
- `src/logistics/README.md`
- `src/missions/README.md`
- `src/ai/README.md`
- `src/iads/README.md`
- `src/ui/README.md`
- `src/debug/README.md`

Noch nicht aktiv implementiert:

- konkrete IADS-Lua-Module
- konkrete UI-/F10-Lua-Module
- konkrete Debug-Lua-Module
- reale CTLD-Ereignisbrücke
- reale MOOSE-CAP-Spawns
- reale Skynet-IADS-Kampagnenbrücke
- DCS-Dateipersistenz
- DEV-Mission im DCS Mission Editor
- erster realer DCS-Starttest

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

Die Vendor-Dateien sind Projektabhängigkeiten.

Sie werden nicht verändert.

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
    src/ai/tc_moose_ai.lua
    src/world/tc_moose_world.lua

Eigene Dateien dürfen MOOSE intern nutzen, müssen aber nach ihrer Theater-Command-Aufgabe benannt werden.

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

Verwendet wird die kompilierte Skynet-IADS-Datei.

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

## Externe DCS-Lade-Reihenfolge

Die Lade-Reihenfolge im DCS Mission Editor lautet:

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
- `src/loader.lua` ist der Einstiegspunkt für die eigene Projektlogik.

---

## Interne Theater-Command-Lade-Reihenfolge

Die interne Source-Lade-Reihenfolge lautet:

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

Aktuell lädt `src/loader.lua` aktiv:

- Core
- World
- Campaign
- Logistics
- Missions
- AI
- Main

IADS, UI und Debug besitzen aktuell nur README-Dateien und noch keine aktiven Lua-Module.

Deshalb werden diese Bereiche aktuell noch nicht aktiv vom Loader geladen.

---

## Source-Architektur

Der Ordner `src/` enthält die eigene Theater-Command-Lua-Logik.

Aktuelle Struktur:

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

Die Struktur wird nach Aufgaben sortiert.

Sie wird nicht nach Frameworks sortiert.

Nicht gewünscht:

    src/tc_moose.lua
    src/tc_mist.lua
    src/tc_ctld.lua
    src/tc_skynet.lua
    src/tc_all_in_one.lua
    src/tc_iads_all_in_one.lua

Gewünscht:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua
    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua
    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua
    src/missions/tc_mission_generator.lua
    src/ai/tc_ai_cap_manager.lua

---

## Loader-Konzept

Die Datei `src/loader.lua` ist der Einstiegspunkt der eigenen Lua-Logik.

Aufgaben:

- globale `TC`-Tabelle vorbereiten
- Projektversion vorbereiten
- Framework-Verfügbarkeit prüfen
- eigene Lade-Reihenfolge definieren
- Core-Dateien laden
- World-Dateien laden
- Campaign-Dateien laden
- Logistics-Dateien laden
- Missions-Dateien laden
- AI-Dateien laden
- `main.lua` laden
- `main.lua` starten
- Debug-Ausgaben im `dcs.log` erzeugen
- Fehler bei fehlenden Frameworks sichtbar machen

`loader.lua` enthält keine große Kampagnenlogik.

Es lädt nur kontrolliert die eigentlichen Module.

---

## Main-Konzept

Die Datei `src/main.lua` übernimmt die Hauptinitialisierung der Kampagne.

Aufgaben:

- Theater Command starten
- Konfiguration verwenden
- Kampagnenzustand vorbereiten
- Airbase-System starten
- Zonen-System starten
- Capture-System starten
- Persistenzsystem starten
- Logistiksystem starten
- FOB-System starten
- Missionsgenerator starten
- AI-CAP-Manager starten
- Startstatus im Log ausgeben

`main.lua` verbindet Systeme.

`main.lua` enthält keine großen Einzelsysteme.

Wichtig:

`src/main.lua` muss als nächster technischer Schritt gegen die aktuell vorhandenen Modulnamen geprüft werden.

---

## Core-System

Der Ordner `src/core/` enthält grundlegende Projektfunktionen.

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
- Hilfsfunktionen
- Scheduler
- Fehlerausgabe
- Framework-Prüfung
- globale Konstanten
- Feature-Status
- Modul-Status
- Dirty-State-Vorbereitung

Das Core-System soll möglichst klein und stabil bleiben.

Andere Systeme dürfen auf den Core zugreifen.

Der Core soll selbst möglichst wenig von späteren Systemen abhängig sein.

---

## World-System

Der Ordner `src/world/` bildet die DCS-Welt in Theater-Command-Strukturen ab.

Vorhandene Dateien:

    src/world/README.md
    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

Aufgaben:

- Airbases erkennen
- Airbases registrieren
- Koalitionsstatus erfassen
- Akrotiri als blaue Startbasis vorbereiten
- syrisches Festland initial rot bewerten
- virtuelle Airbase-Zonen erzeugen
- optionale Mission-Editor-Zonen einlesen
- Weltobjekte für andere Systeme bereitstellen

World trifft keine strategischen Kampagnenentscheidungen.

World liefert die räumliche Grundlage.

---

## Campaign-System

Der Ordner `src/campaign/` enthält den strategischen Kampagnenzustand.

Vorhandene Dateien:

    src/campaign/README.md
    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua

Aufgaben:

- Basenbesitz verwalten
- Zonenbesitz verwalten
- Besitzstatus lesen
- Besitzstatus ändern
- Capture-Events speichern
- Kampagnenfortschritt vorbereiten
- Frontlogik später vorbereiten
- State als dirty markieren
- In-Memory-Persistenz vorbereiten
- State-Export vorbereiten
- State-Import vorbereiten
- Lua-String-Export vorbereiten

Besitzwechsel bleiben Aufgabe des Capture-Systems.

Persistenz speichert Theater-Command-State, nicht Vendor-Dateien.

---

## Logistics-System

Der Ordner `src/logistics/` verbindet Logistik, Lieferungen, FOBs und später CTLD mit Theater Command DCS.

Vorhandene Dateien:

    src/logistics/README.md
    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

Aufgaben:

- Lieferungen anlegen
- Lieferstatus verwalten
- Lieferungen als abgeschlossen markieren
- Lieferungen als verloren markieren
- Lieferungen abbrechen
- logistische Effekte auf Zonen vorbereiten
- logistische Effekte auf Basen vorbereiten
- FOBs anlegen
- FOB-Zustände verwalten
- FOB-Versorgung verwalten
- FOB-Baufortschritt verwalten
- spätere CTLD-Brücke vorbereiten

CTLD führt aus.

Theater Command bewertet die strategische Wirkung.

---

## Missions-System

Der Ordner `src/missions/` erzeugt dynamische Missionen.

Vorhandene Dateien:

    src/missions/README.md
    src/missions/tc_mission_generator.lua

Aufgaben:

- Missionsarten vorbereiten
- Missionsstatus vorbereiten
- Missionen aus Kampagnenlage ableiten
- Missionen im State speichern
- verfügbare Missionen verwalten
- aktive Missionen verwalten
- abgeschlossene Missionen verwalten
- fehlgeschlagene Missionen verwalten
- Logistikmissionen mit Logistics verbinden
- FOB-Support-Missionen vorbereiten
- spätere SEAD-/DEAD-Ziele aus IADS-Zustand ableiten
- spätere F10-Missionsauswahl vorbereiten

Der Missionsgenerator erzeugt Aufträge.

Strategische Besitzänderungen bleiben Aufgabe des Capture-Systems.

---

## AI-System

Der Ordner `src/ai/` enthält KI-Reaktionen und später den AI Director.

Vorhandene Dateien:

    src/ai/README.md
    src/ai/tc_ai_cap_manager.lua

Aufgaben:

- einfache CAP-Logik vorbereiten
- CAP-Zonen registrieren
- CAP-Bedarf aus State-Daten ableiten
- CAP-Anforderungen speichern
- aktive CAPs verwalten
- abgeschlossene CAPs verwalten
- fehlgeschlagene CAPs verwalten
- AI-Reaktionsstatus vorbereiten
- Bedrohungsniveau vorbereiten
- spätere MOOSE-Anbindung für reale CAP-Spawns vorbereiten
- spätere GCI-Logik vorbereiten
- spätere Eskalationslogik vorbereiten

AI verändert keine Besitzstände.

AI reagiert auf vorhandene Kampagnendaten.

---

## IADS-System

Der Ordner `src/iads/` verbindet später Skynet IADS mit Theater Command DCS.

Vorhandene Dateien:

    src/iads/README.md

Geplante Dateien:

    src/iads/tc_iads_network.lua
    src/iads/tc_iads_sector_manager.lua
    src/iads/tc_iads_site_registry.lua
    src/iads/tc_iads_mission_bridge.lua

Geplante Aufgaben:

- IADS-Sektoren definieren
- SAM-Stellungen als Kampagnenobjekte verwalten
- Radarstellungen als Kampagnenobjekte verwalten
- Skynet-IADS-Netzwerke initialisieren
- zerstörte IADS-Komponenten auswerten
- beschädigte Sektoren schwächen
- IADS-Zustand für Persistenz vorbereiten
- IADS-Ziele an Missionsgenerator liefern
- IADS-Zustand an AI Director liefern

Aktueller Status:

    dokumentiert, aber noch nicht aktiv implementiert

---

## UI-System

Der Ordner `src/ui/` enthält später Spielerinteraktion.

Vorhandene Dateien:

    src/ui/README.md

Geplante Dateien:

    src/ui/tc_f10_menu.lua
    src/ui/tc_status_display.lua
    src/ui/tc_mission_menu.lua
    src/ui/tc_logistics_menu.lua
    src/ui/tc_debug_menu.lua

Geplante Aufgaben:

- F10-Menüs erzeugen
- Kampagnenstatus anzeigen
- Missionen auswählbar machen
- Logistikstatus anzeigen
- FOB-Status anzeigen
- AI-Status anzeigen
- IADS-Status anzeigen
- Debugfunktionen getrennt erreichbar machen
- einfache Spielerkommandos ermöglichen

Aktueller Status:

    dokumentiert, aber noch nicht aktiv implementiert

---

## Debug-System

Der Ordner `src/debug/` enthält später Debug- und Testhilfen.

Vorhandene Dateien:

    src/debug/README.md

Geplante Dateien:

    src/debug/tc_debug_console.lua
    src/debug/tc_debug_state_dump.lua
    src/debug/tc_debug_zone_overlay.lua
    src/debug/tc_debug_airbase_report.lua
    src/debug/tc_debug_mission_report.lua
    src/debug/tc_debug_logistics_report.lua
    src/debug/tc_debug_ai_report.lua
    src/debug/tc_debug_iads_report.lua

Geplante Aufgaben:

- Ladezustand prüfen
- State-Dumps vorbereiten
- erkannte Airbases anzeigen
- virtuelle Zonen anzeigen
- Capture-Status ausgeben
- Logistikstatus ausgeben
- Missionsstatus ausgeben
- AI-Status ausgeben
- IADS-Status ausgeben
- Fehleranalyse erleichtern

Aktueller Status:

    dokumentiert, aber noch nicht aktiv implementiert

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

Persistenz ist in erster In-Memory-Version vorbereitet.

Vorhandene Datei:

    src/campaign/tc_persistence_system.lua

Geplante spätere Dateien:

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

Wichtig:

DCS-Dateizugriff und DCS-Sandbox-Verhalten müssen gesondert geprüft werden.

Produktive Datei-Persistenz wird erst gebaut, wenn klar ist, welche Daten stabil gespeichert werden müssen und wie DCS den Dateizugriff im konkreten Server-Setup zulässt.

---

## Datenfluss

Geplanter Datenfluss:

    DCS World
        ↓
    Frameworks
        ↓
    Theater Command Loader
        ↓
    Core
        ↓
    World
        ↓
    Campaign
        ↓
    Logistics / Missions / AI / IADS
        ↓
    UI / Debug / Persistence

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

    Besitzwechsel und Capture-Zustände verwalten.

Nicht Aufgabe:

    CTLD-Menüs bauen
    MOOSE-Spawns verwalten
    IADS-Netzwerke konfigurieren

Beispiel:

    tc_mission_generator.lua

Aufgabe:

    Missionen aus dem Kampagnenzustand erzeugen und verwalten.

Nicht Aufgabe:

    Airbases scannen
    Zonen erzeugen
    CAPs spawnen
    IADS-Netzwerke erstellen

---

## Abhängigkeiten

Geplante Abhängigkeiten:

    core
      ↓
    world
      ↓
    campaign
      ↓
    logistics
      ↓
    missions
      ↓
    ai
      ↓
    iads
      ↓
    ui / debug

Abhängigkeiten sollen möglichst nur in eine Richtung laufen.

Verhindert werden sollen:

- zyklische Abhängigkeiten
- unklare globale Seiteneffekte
- direkte Kopplung aller Module an alle Frameworks
- große All-in-one-Dateien
- versteckte Hauptlogik in Debug- oder UI-Dateien

---

## Globale Tabelle

Die eigene Projektlogik ist über eine globale Tabelle erreichbar:

    TC

Aktuelle und geplante Struktur:

    TC
    ├── version
    ├── modules
    ├── Loader
    ├── Main
    ├── Config
    ├── Logger
    ├── State
    ├── Utils
    ├── Scheduler
    ├── World
    ├── Campaign
    ├── Logistics
    ├── Missions
    ├── AI
    ├── IADS
    ├── UI
    └── Debug

Nicht verwenden:

    TheaterCommand
    theaterCommand
    tc_global
    _G_TC

---

## Namensregeln

Eigene Lua-Dateien beginnen mit:

    tc_

Beispiele:

    tc_config.lua
    tc_logger.lua
    tc_state.lua
    tc_utils.lua
    tc_scheduler.lua
    tc_airbase_scanner.lua
    tc_zone_factory.lua
    tc_capture_system.lua
    tc_persistence_system.lua
    tc_logistics_delivery.lua
    tc_fob_system.lua
    tc_mission_generator.lua
    tc_ai_cap_manager.lua

Framework-Dateien behalten ihre externen Namen oder stabile Projektnamen:

    mist.lua
    Moose.lua
    CTLD-i18n.lua
    CTLD.lua
    SkynetIADS.lua

Dateinamen orientieren sich an der Theater-Command-Aufgabe, nicht am verwendeten Framework.

---

## Aktueller nächster Architektur-Schritt

Die Source-Grundstruktur ist inzwischen deutlich weiter als im alten Architekturstand.

Nach dieser Architekturaktualisierung sollen noch die zentrale Root-`README.md` und danach `src/main.lua` geprüft werden.

Nächste Dokumentationsdatei:

    README.md

Danach technischer Fokus:

    src/main.lua gegen aktuelle Modulnamen prüfen

Grund:

Der Loader lädt inzwischen Core, World, Campaign, Logistics, Missions und AI.

`main.lua` muss deshalb sauber mit den aktuellen Modulen, Namespaces und Startfunktionen übereinstimmen.

---

## Architekturregel

Theater Command DCS bleibt modular.

Frameworks sind Werkzeuge.

Die Kampagne ist die eigene Logik.

Keine All-in-one-Datei.

Keine Framework-Sammeldateien.

Keine unnötig große Mission-Editor-Triggerlogik.

Keine Vendor-Dateien verändern.

Jede neue Datei hat genau eine erkennbare Aufgabe.
