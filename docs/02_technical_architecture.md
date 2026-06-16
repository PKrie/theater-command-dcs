# Technical Architecture

Diese Datei beschreibt die technische Architektur von **Theater Command DCS**.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut.

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## Grundprinzip

Das zentrale Architekturprinzip lautet:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der DCS Mission Editor stellt die physische Umgebung bereit.

Lua übernimmt die dynamische Kampagnenlogik.

GitHub dokumentiert Struktur, Entscheidungen, Versionen, Aufgabenstand und Testergebnisse.

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
- erste eigene Lua-Module
- Loader
- Main-Initialisierung
- Core-System
- World-System
- Campaign-System
- Logistics-System
- Missions-System
- AI-CAP-System
- IADS-, UI- und Debug-Bereiche dokumentiert
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

Wichtiger technischer Befund:

    Airbase-Scanner registrierte 225 Airbase-/Helipad-Objekte.
    Zone-Factory registrierte 225 Zonen.

Bewertung:

    Die technische Startkette funktioniert.
    Die hohe Zahl erkannter Objekte ist kein Startfehler.
    Das aktuelle Syria-Update liefert viele Airbase-ähnliche Objekte.
    Die Airbase-Klassifizierung ist der nächste technische Schwerpunkt.

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

## Source-Struktur

Eigene Theater-Command-Logik liegt unter:

    src/

Aktuelle Struktur:

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

Die Struktur ist nach Aufgaben sortiert, nicht nach Frameworks.

Nicht gewünscht sind Dateien wie:

    tc_moose.lua
    tc_mist.lua
    tc_ctld.lua
    tc_all_in_one.lua

---

## Aktive Source-Dateien

Aktuell aktive eigene Lua-Dateien:

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

## Vendor-Struktur

Externe Frameworks liegen unter:

    vendor/

Aktuelle Framework-Basis:

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Regeln:

- Frameworks werden nicht verändert.
- Eigene Logik wird nicht in Framework-Dateien geschrieben.
- Frameworks werden nur geladen und über eigene Module gekapselt genutzt.
- Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket.

Grund:

CTLD weist darauf hin, dass für korrektes dynamisches Spawning die mit CTLD gelieferte MIST-Version verwendet werden soll.

---

## DCS-Lade-Reihenfolge

Die externe Framework-Lade-Reihenfolge lautet:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua

Danach wird die eigene Theater-Command-Logik geladen.

---

## Erfolgreiche Starttest-Variante A

Der erste reale DCS-Test wurde mit folgender Methode durchgeführt:

    Starttest-Variante A — sichere Einzeldatei-Ladung

Dabei wurden alle aktiven Dateien einzeln per `DO SCRIPT FILE` geladen.

Reihenfolge:

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

`src/main.lua` definiert `TC.Main`.

`src/loader.lua` prüft anschließend Frameworks, Module und startet die Main-Initialisierung.

Ergebnis:

    Bestanden.

---

## Geprüfte Logik im ersten DCS-Test

Bestätigt wurde:

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

## Core-Schicht

Pfad:

    src/core/

Aktuelle Dateien:

    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
    src/core/tc_utils.lua
    src/core/tc_scheduler.lua

Aufgaben:

- zentrale Konfiguration
- Logging
- globaler Theater-Command-State
- Hilfsfunktionen
- Scheduler-Grundfunktionen
- technische Start- und Laufzeitunterstützung

Regel:

    Core darf von allen Systemen genutzt werden.
    Core soll keine fachliche Kampagnenentscheidung erzwingen.

---

## World-Schicht

Pfad:

    src/world/

Aktuelle Dateien:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

Aufgaben:

- DCS-Airbases erfassen
- Airbase-Daten erzeugen
- Koalitionsstatus erkennen
- Positionen erfassen
- virtuelle Zonen erzeugen
- Daten für Campaign, Logistics, Missions und AI bereitstellen

Aktueller Befund:

    Syria liefert aktuell 225 Airbase-/Helipad-Objekte.

Nächste technische Aufgabe:

    Airbase-Scanner klassifizieren und filtern.

Geplante Klassen:

    STRATEGIC_AIRFIELD
    SECONDARY_AIRFIELD
    HELIPORT
    HELIPAD
    MEDICAL_PAD
    FARP
    TACTICAL_PAD
    UNKNOWN

Regel:

    World erkennt und klassifiziert.
    World entscheidet nicht allein über Capture oder Kampagnenfortschritt.

---

## Campaign-Schicht

Pfad:

    src/campaign/

Aktuelle Dateien:

    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua

Aufgaben:

- Besitzstatus vorbereiten
- Zonenstatus vorbereiten
- Capture-Zustände verwalten
- Capture-Events speichern
- Kampagnenzustand vorbereiten
- In-Memory-Persistenz vorbereiten
- spätere Save-/Load-Logik unterstützen

Regel:

    Campaign entscheidet über strategischen Besitz.
    Campaign spawnt keine DCS-Objekte direkt.
    Capture darf später nur auf geeignete strategische Kampagnenobjekte angewendet werden.

---

## Logistics-Schicht

Pfad:

    src/logistics/

Aktuelle Dateien:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

Aufgaben:

- Lieferungen verwalten
- Lieferstatus verwalten
- Versorgungseffekte vorbereiten
- FOBs anlegen
- FOB-Baufortschritt verwalten
- CTLD-Anbindung vorbereiten
- Logistikdaten an Campaign und Missions melden

Regel:

    Logistics entscheidet nicht allein über Besitz.
    Logistics beeinflusst Campaign, Missions und AI über Zustandsdaten.

---

## Missions-Schicht

Pfad:

    src/missions/

Aktuelle Datei:

    src/missions/tc_mission_generator.lua

Aufgaben:

- Missionsarten vorbereiten
- Missionen aus Kampagnenzustand erzeugen
- Missionsstatus verwalten
- aktive Missionen verwalten
- abgeschlossene Missionen verwalten
- fehlgeschlagene Missionen verwalten
- Logistikmissionen vorbereiten
- FOB-Support-Missionen vorbereiten

Regel:

    Missions erzeugt Aufträge aus State-Daten.
    Missions verändert strategischen Besitz nicht direkt.
    Missionsergebnisse werden später an Campaign, Logistics, AI und IADS gemeldet.

Wichtig:

    MissionGenerator darf später nicht ungefiltert alle 225 Airbase-/Helipad-Objekte als Missionsziele verwenden.

---

## AI-Schicht

Pfad:

    src/ai/

Aktuelle Datei:

    src/ai/tc_ai_cap_manager.lua

Aufgaben:

- CAP-Zonen vorbereiten
- CAP-Anforderungen speichern
- aktive CAPs verwalten
- CAP-Abschluss verwalten
- CAP-Fehlschläge verwalten
- Bedrohungsstatus vorbereiten
- spätere MOOSE-Anbindung vorbereiten

Geplante spätere Module:

    src/ai/tc_ai_director.lua
    src/ai/tc_ai_gci_manager.lua
    src/ai/tc_ai_counterattack.lua

Regel:

    AI reagiert auf den Kampagnenzustand.
    AI darf später MOOSE für reale Spawns nutzen.
    AI trifft keine strategischen Besitzentscheidungen allein.

---

## IADS-Schicht

Pfad:

    src/iads/

Aktueller Stand:

    Dokumentiert, noch nicht aktiv implementiert.

Geplante Module:

    src/iads/tc_iads_network.lua
    src/iads/tc_iads_sector_manager.lua
    src/iads/tc_iads_site_registry.lua
    src/iads/tc_iads_mission_bridge.lua

Aufgaben:

- Skynet-IADS-Anbindung kapseln
- IADS-Netzwerke vorbereiten
- IADS-Sektoren definieren
- SAM-Standorte verwalten
- Radar-Standorte verwalten
- IADS-Zustand im Kampagnen-State speichern
- IADS-Zustand mit MissionGenerator verbinden
- SEAD- und DEAD-Ziele vorbereiten

Regel:

    Skynet IADS bleibt Framework.
    Theater Command bewertet und speichert den Kampagnenzustand darüber.

---

## UI-Schicht

Pfad:

    src/ui/

Aktueller Stand:

    Dokumentiert, noch nicht aktiv implementiert.

Geplante Module:

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

Regel:

    UI zeigt Daten und nimmt Spielerkommandos entgegen.
    UI entscheidet nicht selbst über Kampagnenlogik.

---

## Debug-Schicht

Pfad:

    src/debug/

Aktueller Stand:

    Dokumentiert, noch nicht aktiv implementiert.

Geplante Module:

    src/debug/tc_debug_console.lua
    src/debug/tc_debug_state_dump.lua
    src/debug/tc_debug_zone_overlay.lua
    src/debug/tc_debug_airbase_report.lua
    src/debug/tc_debug_mission_report.lua
    src/debug/tc_debug_logistics_report.lua
    src/debug/tc_debug_ai_report.lua
    src/debug/tc_debug_iads_report.lua

Aufgaben:

- Debug-Ausgaben bündeln
- State-Dumps erzeugen
- Airbase-Reports erzeugen
- Zonen-Reports erzeugen
- Capture-Reports erzeugen
- Logistik-Reports erzeugen
- Missions-Reports erzeugen
- AI-Reports erzeugen
- IADS-Reports erzeugen

Regel:

    Debug macht Daten sichtbar.
    Debug ersetzt keine produktive Kampagnenlogik.

---

## Persistenz-Architektur

Aktuelle Datei:

    src/campaign/tc_persistence_system.lua

Aktueller Stand:

    In-Memory-Persistenz vorbereitet.

Spätere Aufgaben:

- State-Snapshot erzeugen
- State exportieren
- State importieren
- Airbase-Besitz speichern
- Zonenstatus speichern
- Logistikstatus speichern
- Missionsfortschritt speichern
- AI-Zustand speichern
- IADS-Zustand speichern
- Dateien schreiben
- Dateien lesen

Wichtig:

    DCS-Dateizugriff und DCS-Sandbox-Verhalten müssen vor echter Dateipersistenz praktisch getestet werden.

---

## Mission-Editor-Architektur

Aktuelle DEV-Mission:

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

Regel:

    Der Mission Editor bleibt schlank.
    Große dynamische Logik gehört nach Lua.
    Der Mission Editor liefert Bühne, Slots, Templates, Zonen und statische Objekte.

---

## Loader-only-Architektur

Noch nicht getestet:

    Starttest-Variante B — Loader-only mit dofile

Ziel:

- Frameworks im Mission Editor laden
- nur `src/loader.lua` laden
- prüfen, ob `src/loader.lua` weitere Source-Dateien per `dofile` nachladen kann
- DCS-Sandbox-Verhalten bewerten
- spätere Deployment-Strategie entscheiden

Mögliche Ergebnisse:

- Loader-only funktioniert
- Einzeldatei-Ladung bleibt für Entwicklung notwendig
- spätere Build-Datei wird benötigt
- DCS-Sandbox muss gezielt berücksichtigt werden

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

## Wichtigste aktuelle Architekturentscheidung

Der erste DCS-Test hat gezeigt:

    225 Airbase-/Helipad-Objekte werden erkannt.

Daher muss als nächstes entschieden und umgesetzt werden:

- Welche Objekte sind strategische Airfields?
- Welche Objekte sind Secondary Airfields?
- Welche Objekte sind Heliports?
- Welche Objekte sind Helipads?
- Welche Objekte sind Medical Pads?
- Welche Objekte sind FARPs?
- Welche Objekte bleiben Unknown?
- Welche Objekte dürfen Capture-Ziele werden?
- Welche Objekte dürfen Missionsziele werden?
- Welche Objekte dürfen Logistikhubs werden?

Ohne diese Klassifizierung würden Campaign, Missions, Logistics und AI auf zu breiten und teilweise falschen Daten arbeiten.

---

## Nächster technischer Schritt

Der nächste technische Schritt ist:

    src/world/tc_airbase_scanner.lua erweitern

Ziel:

- Airbase-Kategorien einführen
- Klassifizierungsfunktion ergänzen
- strategische Relevanz berechnen
- getrennte Listen speichern
- Summary-Logausgabe erzeugen
- spätere ZoneFactory-Anbindung vorbereiten

---

## Aktueller Status

Die technische Grundarchitektur ist angelegt.

Die erste aktive Source-Kette wurde erfolgreich in DCS getestet.

Der nächste notwendige Schritt ist die Airbase-Klassifizierung im World-System.
