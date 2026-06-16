# Architecture

Diese Datei beschreibt die technische Grundarchitektur von **Theater Command DCS**.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut.

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## Architekturprinzip

Das zentrale Architekturprinzip lautet:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der DCS Mission Editor stellt die physische Umgebung bereit.

Lua übernimmt die dynamische Kampagnenlogik.

GitHub dokumentiert Struktur, Entscheidungen, Versionen, Aufgabenstand und Testergebnisse.

---

## Zielbild

Theater Command DCS soll langfristig folgende Systeme verbinden:

- Airbase-Erkennung
- strategische Airbase-Klassifizierung
- virtuelle Zonen
- Capture-System
- Logistiksystem
- CTLD-Anbindung
- FOB-Aufbau
- dynamische Missionsgenerierung
- AI Director
- CAP- und GCI-Management
- Skynet-IADS-Anbindung
- SEAD-/DEAD-Missionslogik
- F10-Menüs
- Debug-Werkzeuge
- Persistenz
- Kampagnenfortschritt über mehrere Sessions

Das System soll modular aufgebaut werden.

Jedes Modul soll eine klar begrenzte Aufgabe haben.

---

## Aktueller technischer Stand

Stand: 2026-06-16

Aktuell vorhanden:

- Repository-Grundstruktur
- zentrale Projektdokumentation
- `docs/`-Dokumentation
- `mission_editor/`-Dokumentation
- `vendor/`-Frameworkstruktur
- MIST
- MOOSE
- CTLD
- Skynet IADS
- `src/`-Grundstruktur
- erste eigene Theater-Command-Lua-Module
- Loader
- Main-Initialisierung
- Core-System
- World-System
- Campaign-System
- Logistics-System
- Missions-System
- AI-CAP-System
- IADS-Bereich dokumentiert
- UI-Bereich dokumentiert
- Debug-Bereich dokumentiert
- minimale Syria-DEV-Mission
- erster blauer F/A-18C-Client-Slot auf Akrotiri
- vollständige Triggerkette für Starttest-Variante A
- erster realer DCS-Starttest
- erfolgreiche `dcs.log`-Auswertung

Aktueller Teststatus:

    Starttest-Variante A ist bestanden.

Bestätigt wurde:

- Frameworks werden durch DCS geladen
- Frameworks werden durch Theater Command erkannt
- eigene Source-Dateien werden geladen
- Loader startet
- Main startet
- Runtime-Systeme werden initialisiert
- Airbase-Scanner läuft
- Zone-Factory läuft
- Loader beendet sauber

Wichtiger Befund:

    Airbase-Scanner registrierte 225 Airbase-/Helipad-Objekte.
    Zone-Factory registrierte 225 Zonen.

Bewertung:

    Die technische Startkette funktioniert.
    Die hohe Zahl erkannter Objekte ist kein Startfehler.
    Die Airbase-Erkennung muss als nächster technischer Schwerpunkt fachlich klassifiziert und gefiltert werden.

---

## Hauptstruktur

Aktuelle Hauptstruktur:

    docs/
    mission_editor/
    src/
    vendor/
    README.md
    ROADMAP.md
    TASKS.md
    CHANGELOG.md
    ARCHITECTURE.md
    MISSION_EDITOR_SETUP.md
    NAMING_CONVENTIONS.md
    LUA_STYLEGUIDE.md

---

## Externe Frameworks

Externe Frameworks liegen ausschließlich unter:

    vendor/

Aktuelle Framework-Basis:

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Wichtig:

Framework-Dateien werden nicht verändert.

Eigene Theater-Command-Logik wird nicht in Framework-Dateien geschrieben.

Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket.

Grund:

CTLD weist darauf hin, dass für korrektes dynamisches Spawning die mit CTLD gelieferte MIST-Version verwendet werden soll.

---

## Eigene Lua-Logik

Eigene Lua-Logik liegt ausschließlich unter:

    src/

Die eigene Struktur ist nach Aufgaben sortiert, nicht nach Frameworks.

Nicht gewünscht sind Sammeldateien wie:

    tc_moose.lua
    tc_mist.lua
    tc_ctld.lua
    tc_all_in_one.lua

Stattdessen wird Theater Command fachlich modular aufgebaut.

Aktuelle Source-Struktur:

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

---

## Aktive Source-Module

Aktuell vorhandene aktive eigene Lua-Dateien:

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

Aktuell nur dokumentiert:

    src/iads/
    src/ui/
    src/debug/

Diese Bereiche besitzen aktuell README-Dateien, aber noch keine aktiven Lua-Module.

---

## Externe DCS-Lade-Reihenfolge

Die externen Frameworks werden im DCS Mission Editor in dieser Reihenfolge geladen:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua

Danach folgt die eigene Theater-Command-Logik.

Diese Reihenfolge wurde im ersten realen DCS-Starttest erfolgreich verwendet.

---

## Interne Theater-Command-Lade-Reihenfolge

Die interne Theater-Command-Lade-Reihenfolge lautet:

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

Aktuell aktiv geladen:

- Core
- World
- Campaign
- Logistics
- Missions
- AI
- Main

Noch nicht aktiv geladen:

- IADS
- UI
- Debug

Grund:

Diese Bereiche sind vorbereitet, aber noch nicht implementiert.

---

## Starttest-Architektur

Der erste erfolgreiche DCS-Test wurde mit folgender Variante durchgeführt:

    Starttest-Variante A — sichere Einzeldatei-Ladung

Dabei wurden alle aktiven Dateien einzeln per `DO SCRIPT FILE` geladen.

Grund:

- keine harte Abhängigkeit von `dofile`
- klare Fehlereingrenzung
- jede Datei wird direkt im DCS-Kontext getestet
- geeignet für die erste technische Validierung
- `dcs.log` zeigt eindeutig, welche Module starten

Getestete Reihenfolge:

    Frameworks
    Core
    World
    Campaign
    Logistics
    Missions
    AI
    Main
    Loader

Wichtig:

    src/main.lua wurde vor src/loader.lua geladen.
    src/loader.lua wurde als letzte eigene Datei geladen.

Grund:

`main.lua` stellt `TC.Main` bereit.

`loader.lua` prüft anschließend die Frameworks und startet die Main-Initialisierung.

---

## Ergebnis der ersten Startarchitektur

Der erste DCS-Starttest bestätigte:

    MIST erkannt
    MOOSE erkannt
    CTLD erkannt
    Skynet IADS erkannt
    Core geladen
    World geladen
    Campaign geladen
    Logistics geladen
    Missions geladen
    AI geladen
    Main gestartet
    Runtime-Systeme initialisiert
    Loader beendet

Wichtige positive Log-Einträge:

    [TC] Theater Command loader started
    [TC] Framework available: MIST
    [TC] Framework available: MOOSE
    [TC] Framework available: CTLD
    [TC] Framework available: Skynet IADS
    [TC] Main start requested
    [TC] Core check passed
    [TC] Runtime systems initialized
    [TC] Main initialized
    [TC] Main started
    [TC] Theater Command loader finished

World-Ergebnis:

    Airbase scan completed: 225 airbases registered
    Zone factory completed: 225 zones registered

Bewertung:

    Die Startarchitektur funktioniert.
    Die technische Grundlage ist stabil genug für den nächsten Code-Schritt.
    Die Airbase-Klassifizierung ist zwingend vor weiterer Kampagnenlogik notwendig.

---

## Core-Architektur

Der Core-Bereich bildet die technische Grundlage.

Pfad:

    src/core/

Aktuelle Dateien:

    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
    src/core/tc_utils.lua
    src/core/tc_scheduler.lua

Aufgaben:

- zentrale Konfiguration bereitstellen
- Logging bereitstellen
- globalen Theater-Command-State verwalten
- Hilfsfunktionen bereitstellen
- Scheduler-Grundfunktionen bereitstellen
- Start- und Laufzeitstatus unterstützen

Architekturregel:

    Core darf von allen Systemen genutzt werden.
    Core soll keine fachliche Kampagnenentscheidung erzwingen.

---

## World-Architektur

Der World-Bereich verbindet DCS-Weltobjekte mit Theater-Command-Daten.

Pfad:

    src/world/

Aktuelle Dateien:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

Aufgaben:

- DCS-Airbases erfassen
- Airbase-Datensätze erzeugen
- Koalitionsstatus erkennen
- virtuelle Zonen erzeugen
- Airbases und Zonen verbinden
- Daten für Campaign, Logistics, Missions und AI bereitstellen

Aktueller Befund:

    Syria liefert aktuell 225 Airbase-/Helipad-Objekte.

Architekturentscheidung:

    Diese Objekte dürfen nicht ungefiltert als strategische Kampagnenbasen genutzt werden.

Nächster Schritt:

    AirbaseScanner um Klassifizierung und Filterung erweitern.

Zielklassen:

- strategische Airfields
- kleinere Airfields
- Heliports
- Helipads
- Medical Pads
- FARPs
- sonstige taktische Pads
- unbekannte Objekte

Folge:

    ZoneFactory, CaptureSystem und MissionGenerator müssen später auf die gefilterte strategische Basisliste zugreifen.

---

## Campaign-Architektur

Der Campaign-Bereich verwaltet den strategischen Zustand.

Pfad:

    src/campaign/

Aktuelle Dateien:

    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua

Aufgaben:

- Besitzstatus von Basen vorbereiten
- Besitzstatus von Zonen vorbereiten
- Capture-Zustände verwalten
- Capture-Events speichern
- Kampagnenfortschritt vorbereiten
- In-Memory-Persistenz vorbereiten
- State-Snapshots vorbereiten
- später Save-/Load-Logik unterstützen

Architekturregel:

    Campaign entscheidet über strategischen Besitz.
    Campaign soll keine DCS-Objekte direkt spawnen.
    Campaign nutzt Daten aus World, Logistics, Missions, AI und IADS.

Wichtig:

    Capture darf später nur auf strategische Kampagnenbasen angewendet werden.

---

## Logistics-Architektur

Der Logistics-Bereich verwaltet Versorgung, Lieferungen und FOB-Aufbau.

Pfad:

    src/logistics/

Aktuelle Dateien:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

Aufgaben:

- Lieferungen anlegen
- Lieferstatus verwalten
- Versorgungseffekte vorbereiten
- FOBs anlegen
- FOB-Baufortschritt verwalten
- CTLD-Anbindung vorbereiten
- Logistikzustände an Campaign und Missions melden

Architekturregel:

    Logistics entscheidet nicht allein über Besitz.
    Logistics liefert Zustände, die Capture, Missions und AI beeinflussen können.

---

## Missions-Architektur

Der Missions-Bereich erzeugt spielbare Aufträge aus dem Kampagnenzustand.

Pfad:

    src/missions/

Aktuelle Datei:

    src/missions/tc_mission_generator.lua

Aufgaben:

- Missionsarten vorbereiten
- Missionen aus State-Daten erzeugen
- Missionsstatus verwalten
- aktive Missionen verwalten
- abgeschlossene Missionen verwalten
- fehlgeschlagene Missionen verwalten
- Logistikmissionen vorbereiten
- FOB-Support-Missionen vorbereiten
- später SEAD/DEAD, CAP, CAS, Strike und Interdiction ableiten

Architekturregel:

    Missions erzeugt Aufträge aus Kampagnenzustand.
    Missions verändert strategischen Besitz nicht direkt.
    Missionsergebnisse werden an Campaign, Logistics, AI und IADS gemeldet.

Wichtig:

    MissionGenerator darf später nicht ungefiltert alle 225 Airbase-/Helipad-Objekte als Missionsziele verwenden.

---

## AI-Architektur

Der AI-Bereich steuert spätere KI-Reaktionen.

Pfad:

    src/ai/

Aktuelle Datei:

    src/ai/tc_ai_cap_manager.lua

Aufgaben:

- CAP-Zonen verwalten
- CAP-Anforderungen speichern
- aktive CAPs verwalten
- CAP-Abschluss verwalten
- CAP-Fehlschläge verwalten
- Bedrohungsstatus vorbereiten
- spätere MOOSE-Anbindung vorbereiten

Geplante spätere Dateien:

    src/ai/tc_ai_director.lua
    src/ai/tc_ai_gci_manager.lua
    src/ai/tc_ai_counterattack.lua

Architekturregel:

    AI reagiert auf den Kampagnenzustand.
    AI darf später MOOSE für Spawns nutzen.
    AI soll keine strategischen Besitzentscheidungen alleine treffen.

---

## IADS-Architektur

Der IADS-Bereich wird die Theater-Command-Schicht über Skynet IADS.

Pfad:

    src/iads/

Aktueller Stand:

    Dokumentiert, noch nicht aktiv implementiert.

Geplante Dateien:

    src/iads/tc_iads_network.lua
    src/iads/tc_iads_sector_manager.lua
    src/iads/tc_iads_site_registry.lua
    src/iads/tc_iads_mission_bridge.lua

Aufgaben:

- IADS-Netzwerke vorbereiten
- IADS-Sektoren definieren
- SAM-Standorte verwalten
- Radar-Standorte verwalten
- IADS-Zustand im Kampagnen-State speichern
- IADS-Zustand mit MissionGenerator verbinden
- IADS-Zustand mit AI-Reaktionen verbinden
- SEAD- und DEAD-Ziele vorbereiten
- Skynet-IADS-Anbindung kapseln

Architekturregel:

    Skynet IADS bleibt Framework.
    Theater Command speichert und bewertet den Kampagnenzustand darüber.

---

## UI-Architektur

Der UI-Bereich wird spätere Spielerinteraktion bereitstellen.

Pfad:

    src/ui/

Aktueller Stand:

    Dokumentiert, noch nicht aktiv implementiert.

Geplante Dateien:

    src/ui/tc_f10_menu.lua
    src/ui/tc_status_display.lua
    src/ui/tc_mission_menu.lua
    src/ui/tc_logistics_menu.lua
    src/ui/tc_debug_menu.lua

Aufgaben:

- F10-Menüs vorbereiten
- Kampagnenstatus anzeigen
- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Logistikstatus anzeigen
- FOB-Status anzeigen
- AI-Status anzeigen
- IADS-Status anzeigen
- Debug-Menü optional anzeigen

Architekturregel:

    UI zeigt Daten und nimmt Spielerkommandos entgegen.
    UI entscheidet nicht selbst über Kampagnenlogik.

---

## Debug-Architektur

Der Debug-Bereich wird Entwicklungs- und Prüfhilfen bereitstellen.

Pfad:

    src/debug/

Aktueller Stand:

    Dokumentiert, noch nicht aktiv implementiert.

Geplante Dateien:

    src/debug/tc_debug_console.lua
    src/debug/tc_debug_state_dump.lua
    src/debug/tc_debug_zone_overlay.lua
    src/debug/tc_debug_airbase_report.lua
    src/debug/tc_debug_mission_report.lua
    src/debug/tc_debug_logistics_report.lua
    src/debug/tc_debug_ai_report.lua
    src/debug/tc_debug_iads_report.lua

Aufgaben:

- Debug-State-Dumps erzeugen
- Airbase-Reports erzeugen
- Zonen-Reports erzeugen
- Capture-Reports erzeugen
- Logistics-Reports erzeugen
- Missions-Reports erzeugen
- AI-Reports erzeugen
- IADS-Reports erzeugen
- Debug-Ausgaben abschaltbar machen

Architekturregel:

    Debug darf den Kampagnenzustand sichtbar machen.
    Debug darf produktive Logik nicht ersetzen.

---

## Persistenz-Architektur

Persistenz wird später den Kampagnenzustand über Sessions hinweg erhalten.

Aktuelle Datei:

    src/campaign/tc_persistence_system.lua

Aktueller Stand:

    In-Memory-Persistenz vorbereitet.

Geplante spätere Struktur:

    save/
    save/example_state.lua

Aufgaben:

- State-Snapshot erzeugen
- State exportieren
- State importieren
- später Datei schreiben
- später Datei lesen
- Airbase-Besitz speichern
- Zonenstatus speichern
- Logistikstatus speichern
- Missionsfortschritt speichern
- AI-Zustand speichern
- IADS-Zustand speichern

Wichtig:

    DCS-Dateizugriff und DCS-Sandbox-Verhalten müssen vor echter Dateipersistenz praktisch getestet werden.

---

## Mission-Editor-Architektur

Die aktuelle DEV-Mission ist nur ein technischer Testträger.

Dateiname:

    Operation_Levant_Reclamation_DEV.miz

Aktueller Inhalt:

    Map: Syria
    Koalitionspreset: Modern
    Blue Start: Akrotiri / Zypern
    erster blauer Client-Slot: F/A-18C Lot 20 auf Akrotiri
    Trigger: Starttest-Variante A vollständig angelegt
    keine rote Frontlinie
    keine IADS-Stellungen
    keine CTLD-Zonen
    keine Template-Gruppen
    keine F10-Menüs

Architekturregel:

    Der Mission Editor soll möglichst schlank bleiben.
    Große dynamische Logik gehört nach Lua.
    Der Mission Editor liefert Startpositionen, Slots, Templates, Zonen und statische Objekte.

---

## DCS-Sandbox und Loader-only-Architektur

Die aktuelle erfolgreiche Testarchitektur nutzt Einzeldatei-Ladung.

Noch nicht getestet:

    Starttest-Variante B — Loader-only mit dofile

Ziel Variante B:

- Frameworks per Mission Editor laden
- nur `src/loader.lua` laden
- prüfen, ob `loader.lua` weitere Dateien per `dofile` nachladen kann
- DCS-Sandbox-Verhalten bewerten
- spätere Deployment-Strategie entscheiden

Mögliche Ergebnisse:

    Loader-only funktioniert.
    Einzeldatei-Ladung bleibt für Entwicklung notwendig.
    Es wird später eine Build-Datei benötigt.
    DCS-Sandbox muss gezielt angepasst oder umgangen werden.

Diese Entscheidung wird erst nach einem praktischen Test getroffen.

---

## Abhängigkeitsregeln

Grundregel:

    Niedrige Schichten dürfen nicht von höheren Schichten abhängen.

Vereinfachte Richtung:

    Core
      -> World
      -> Campaign
      -> Logistics
      -> Missions
      -> AI
      -> IADS
      -> UI
      -> Debug

Praktische Regeln:

- Core darf von allen genutzt werden.
- World liefert DCS-Weltdaten.
- Campaign verwaltet strategischen Zustand.
- Logistics liefert Versorgungszustände.
- Missions erzeugt Aufträge aus State-Daten.
- AI reagiert auf State-Daten.
- IADS liefert Luftverteidigungszustände.
- UI zeigt Daten und nimmt Spielerbefehle an.
- Debug liest Daten und erzeugt Prüfberichte.

Keine Datei soll heimlich große Nebenlogik aus fremden Bereichen übernehmen.

---

## Nicht-Ziele der aktuellen Architekturphase

Aktuell wird bewusst nicht gebaut:

- keine vollständige Frontlinie
- keine komplette Syria-Befüllung
- keine komplette IADS-Großstruktur
- keine komplexe KI-Kampagne
- keine automatische `.miz`-Generierung
- keine Multiplayer-Synchronisation
- keine produktive Persistenz
- keine kommerzielle Release-Struktur
- keine All-in-one-Datei
- keine Framework-Änderungen

---

## Nächste Architekturentscheidung

Die nächste wichtige Architekturentscheidung betrifft den World-Bereich:

    Wie trennt Theater Command strategische Kampagnenbasen von Helipads, Heliports, Medical Pads und sonstigen Airbase-Objekten?

Der erste DCS-Test hat gezeigt:

    225 Airbase-/Helipad-Objekte werden erkannt.

Daher muss als nächstes festgelegt und implementiert werden:

- Airbase-Klassifizierung
- strategische Basisliste
- nicht-strategische Pad-Liste
- Debug-Ausgabe zur Klassifizierung
- Anbindung der gefilterten Daten an ZoneFactory, CaptureSystem und MissionGenerator

Erst danach sollte weitere Kampagnenlogik vertieft werden.

---

## Aktueller Status

Die Grundarchitektur ist angelegt.

Die erste aktive Source-Kette wurde erfolgreich im DCS Mission Scripting Environment getestet.

Der nächste technische Schritt ist die Airbase-Klassifizierung im World-System.
