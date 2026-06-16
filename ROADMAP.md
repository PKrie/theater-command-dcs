# Roadmap

Diese Roadmap beschreibt die geplanten Entwicklungsphasen für **Theater Command DCS** und die erste Kampagne **Operation Levant Reclamation**.

Das Projekt wird schrittweise aufgebaut.

Jede Phase soll einzeln dokumentiert, umgesetzt und getestet werden, bevor die nächste große Phase vertieft wird.

---

## Projektziel

**Theater Command DCS** soll ein modulares, dynamisches und später persistentes DCS-World-Kampagnensystem werden.

Die erste Kampagne wird auf der **Syria Map** aufgebaut.

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert
    Erste Kampagne: Operation Levant Reclamation

Grundprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der DCS Mission Editor stellt die physische Umgebung bereit.

Lua übernimmt die eigentliche Kampagnenlogik.

GitHub dokumentiert Struktur, Entscheidungen, Versionen und Aufgabenstand.

---

## Aktueller Stand

Stand: 2026-06-16

Aktuell abgeschlossen:

- Repository erstellt
- zentrale Projektdokumentation angelegt
- `docs/`-Grundblock erstellt
- `vendor/`-Grundstruktur erstellt
- MIST importiert
- MOOSE importiert
- CTLD importiert
- Skynet IADS importiert
- MIST auf CTLD-kompatible Version gesetzt
- Vendor-Dokumentation aktualisiert
- zentrale Dokumentation nach Vendor-Abschluss aktualisiert
- `src/`-Grundstruktur angelegt
- erste eigene Lua-Module erstellt
- Core-System angelegt
- World-System angelegt
- Campaign-System angelegt
- Logistics-System angelegt
- Missions-System angelegt
- AI-CAP-System angelegt
- IADS-, UI- und Debug-Bereiche dokumentiert
- Loader erstellt
- Main-Initialisierung erstellt
- Loader-/Main-Startkette logisch geprüft
- Mission-Editor-Dokumentation für sicheren ersten Source-Test aktualisiert
- lokale Repository-Kopie auf dem DCS-PC eingerichtet
- minimale Syria-DEV-Mission im DCS Mission Editor erstellt
- Akrotiri als blaue Startbasis genutzt
- erster blauer F/A-18C-Client-Slot auf Akrotiri erstellt
- Framework-Lade-Trigger im Mission Editor angelegt
- Source-Lade-Trigger für Starttest-Variante A im Mission Editor angelegt
- erster realer DCS-Starttest durchgeführt
- `dcs.log` ausgewertet
- Theater-Command-Startkette in DCS erfolgreich bestätigt

Aktueller technischer Status:

    Die Theater-Command-Startkette läuft im DCS Mission Scripting Environment.
    Frameworks werden geladen und erkannt.
    Eigene Source-Module werden geladen.
    Main wird gestartet.
    Runtime-Systeme werden initialisiert.
    Loader beendet sauber.
    Airbase-Scanner und Zone-Factory laufen im DCS-Test.

Wichtiges Testergebnis:

    Airbase-Scanner registrierte 225 Airbase-/Helipad-Objekte.
    Zone-Factory registrierte 225 Zonen.

Bewertung:

    Starttest-Variante A ist bestanden.
    Die hohe Zahl erkannter Objekte ist kein Startfehler.
    Das aktuelle Syria-Update liefert sehr viele Airbase-ähnliche Objekte.
    Der nächste technische Schwerpunkt ist die fachliche Filterung und Klassifizierung dieser Objekte.

---

## Aktuelle Framework-Basis

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Wichtig:

Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket.

Grund:

CTLD weist darauf hin, dass für korrektes dynamisches Spawning die mit CTLD gelieferte MIST-Version verwendet werden soll.

---

## Externe DCS-Lade-Reihenfolge

Die Frameworks werden im DCS Mission Editor in dieser Reihenfolge geladen:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua

Danach folgt die eigene Theater-Command-Logik.

Für Starttest-Variante A wurden alle aktiven Source-Dateien einzeln per `DO SCRIPT FILE` geladen.

---

## Interne Theater-Command-Lade-Reihenfolge

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

Aktuell aktiv umgesetzt:

- Core
- World
- Campaign
- Logistics
- Missions
- AI
- Main
- Loader

Aktuell nur dokumentiert:

- IADS
- UI
- Debug

---

## Erfolgreicher Starttest

Der erste reale DCS-Test wurde mit folgender Methode durchgeführt:

    Starttest-Variante A — sichere Einzeldatei-Ladung

Dabei wurden zuerst alle Frameworks per `DO SCRIPT FILE` geladen.

Danach wurden alle aktiven eigenen Source-Dateien einzeln per `DO SCRIPT FILE` geladen.

Danach wurde `src/main.lua` geladen.

Zuletzt wurde `src/loader.lua` geladen.

Ergebnis:

    Bestanden.

Bestätigt wurde:

- MIST geladen
- MOOSE geladen
- CTLD-i18n geladen
- CTLD geladen
- Skynet IADS geladen
- Theater Command Loader gestartet
- Frameworks durch Loader erkannt
- Core geladen
- World geladen
- Campaign geladen
- Logistics geladen
- Missions geladen
- AI geladen
- Main gestartet
- Runtime-Systeme initialisiert
- Airbase-Scanner ausgeführt
- Zone-Factory ausgeführt
- Loader sauber beendet

---

## Phase 0 — Projektbasis

Status:

    Abgeschlossen

Ziele:

- Projektidee dokumentieren
- Repository anlegen
- zentrale Dokumentationsdateien erstellen
- Architekturgrundsätze definieren
- Namenskonventionen definieren
- Lua-Stilregeln definieren
- Mission-Editor-Grundprinzip festlegen
- Docs-Grundblock erstellen
- Vendor-Grundstruktur erstellen

Ergebnis:

    Phase 0 ist fachlich abgeschlossen.

---

## Phase 0.5 — Vendor-Basis

Status:

    Abgeschlossen

Ziele:

- MIST unter `vendor/mist/` hinterlegen
- MOOSE unter `vendor/moose/` hinterlegen
- CTLD unter `vendor/ctld/` hinterlegen
- Skynet IADS unter `vendor/skynet-iads/` hinterlegen
- Framework-Versionen dokumentieren
- Frameworks nicht verändern
- Lade-Reihenfolge dokumentieren
- Vendor-Dokumentation aktualisieren

Ergebnis:

    Vendor ist funktional abgeschlossen.

---

## Phase 1 — Source Foundation

Status:

    Weitgehend abgeschlossen

Ziele:

- `src/`-Grundstruktur anlegen
- eigene Lua-Logik nach Aufgaben sortieren
- keine frameworkorientierten Sammeldateien erstellen
- Core-Bereich erstellen
- Loader erstellen
- Main-Initialisierung erstellen
- erste Modulstruktur vorbereiten
- Framework-Verfügbarkeit prüfen
- Logging vorbereiten
- State-Struktur vorbereiten
- Scheduler vorbereiten
- Startkette im DCS Mission Scripting Environment prüfen

Erledigt:

- `src/README.md`
- `src/core/README.md`
- `src/world/README.md`
- `src/campaign/README.md`
- `src/logistics/README.md`
- `src/missions/README.md`
- `src/ai/README.md`
- `src/iads/README.md`
- `src/ui/README.md`
- `src/debug/README.md`
- `src/loader.lua`
- `src/main.lua`
- `src/core/tc_config.lua`
- `src/core/tc_logger.lua`
- `src/core/tc_state.lua`
- `src/core/tc_utils.lua`
- `src/core/tc_scheduler.lua`

Ergebnis:

    Source Foundation ist technisch angelegt.
    Loader und Main funktionieren im ersten DCS-Starttest.

Offen:

- Loader-only-Variante mit `dofile` praktisch testen
- DCS-Sandbox-Verhalten bewerten

---

## Phase 2 — Airbase- und World-System

Status:

    Begonnen und erster DCS-Test bestanden

Ziele:

- DCS-Airbases erfassen
- Airbases in Theater-Command-State überführen
- Akrotiri als blaue Startbasis erkennen
- syrisches Festland als rote Ausgangslage vorbereiten
- virtuelle Kampagnenzonen erzeugen
- Airbases und Zonen verknüpfen
- Airbase-Daten für Capture, Logistics, Missions und AI vorbereiten

Aktuell vorhanden:

- `src/world/tc_airbase_scanner.lua`
- `src/world/tc_zone_factory.lua`

Testergebnis:

    Airbase-Scanner registrierte 225 Airbase-/Helipad-Objekte.
    Zone-Factory registrierte 225 Zonen.

Bewertung:

    Die technische Erfassung funktioniert.
    Die fachliche Filterung fehlt noch.

Nächster technischer Schwerpunkt:

- Airbase-Typen klassifizieren
- strategische Airfields erkennen
- Heliports, Helipads, Medical Pads und sonstige Pads separat klassifizieren
- Capture- und Missionslogik nur auf strategisch relevante Basen anwenden
- Airbase-Debugreport vorbereiten

---

## Phase 3 — Campaign State und Capture-System

Status:

    Grundstruktur vorhanden

Ziele:

- Besitzstatus von Basen vorbereiten
- Besitzstatus von Zonen vorbereiten
- Blau/Rot/Neutral/Contested/Unknown-Status verwalten
- Capture-Ereignisse speichern
- State als dirty markieren
- Capture-System mit Airbase- und Zone-System verbinden

Aktuell vorhanden:

- `src/campaign/tc_capture_system.lua`
- `src/campaign/tc_persistence_system.lua`

Erledigt:

- Basisstatus vorbereitet
- Zonenstatus vorbereitet
- Capture-Events vorbereitet
- In-Memory-Persistenz vorbereitet
- State-Snapshot vorbereitet
- State-Export vorbereitet
- State-Import vorbereitet

Offen:

- Capture-Bedingungen fachlich definieren
- Capture nur auf strategische Kampagnenbasen anwenden
- Garnisonen berücksichtigen
- Supply berücksichtigen
- Capture-Debugreport vorbereiten
- Capture-System funktional in DCS testen

---

## Phase 4 — Logistics und FOB-System

Status:

    Grundstruktur vorhanden

Ziele:

- Logistiklieferungen verwalten
- Supply-, Fuel-, Ammunition- und Engineering-Effekte vorbereiten
- FOB-Aufbau vorbereiten
- CTLD später anbinden
- eroberte Basen als neue Logistikhubs nutzbar machen
- Logistikdaten an Campaign, Missions und AI melden

Aktuell vorhanden:

- `src/logistics/tc_logistics_delivery.lua`
- `src/logistics/tc_fob_system.lua`

Erledigt:

- Lieferstatus vorbereitet
- Lieferungen anlegbar
- Lieferungen abschließbar
- Lieferungen verlierbar
- Lieferungen abbrechbar
- FOB-State vorbereitet
- FOBs anlegbar
- FOB-Versorgung vorbereitet
- FOB-Baufortschritt vorbereitet

Offen:

- CTLD-Grundkonfiguration vorbereiten
- Akrotiri als Start-Logistikhub definieren
- Pickup-Zonen auf Akrotiri anlegen
- Dropoff-Zonen vorbereiten
- CTLD-Ereignisse mit Theater Command verbinden
- Logistics-System funktional in DCS testen

---

## Phase 5 — Missionsgenerator

Status:

    Grundstruktur vorhanden

Ziele:

- Missionsarten vorbereiten
- Missionen aus Kampagnenzustand erzeugen
- Missionen nach Ziel, Zone, Basis und Frontlage ableiten
- Missionen im State speichern
- Missionsstatus verwalten
- Missionserfolg auswerten
- Missionen später über F10-Menüs anzeigen

Aktuell vorhanden:

- `src/missions/tc_mission_generator.lua`

Erledigt:

- Missionsarten vorbereitet
- Missionsstatus vorbereitet
- Missionen anlegbar
- Missionen aktivierbar
- Missionen abschließbar
- Missionen fehlgeschlagen markierbar
- Logistikmissionen vorbereitet
- FOB-Support-Missionen vorbereitet

Offen:

- Airbase-Ziele aus gefiltertem Kampagnenzustand ableiten
- Missionen nach Flugzeugtyp filtern
- erste F10-Missionsliste vorbereiten
- Missionserfolg real auswerten
- Missionsgenerator funktional in DCS testen

---

## Phase 6 — AI Director und CAP-Manager

Status:

    CAP-Grundstruktur vorhanden

Ziele:

- CAP-Bedarf aus Kampagnenzustand ableiten
- CAP-Zonen verwalten
- AI-Reaktionen vorbereiten
- MOOSE später für reale Spawns nutzen
- GCI-Logik vorbereiten
- Gegenangriffe vorbereiten
- Luftlage dynamisch an Kampagnenfortschritt koppeln

Aktuell vorhanden:

- `src/ai/tc_ai_cap_manager.lua`

Erledigt:

- CAP-Zonen vorbereitbar
- CAP-Anforderungen speicherbar
- aktive CAPs verwaltbar
- abgeschlossene CAPs verwaltbar
- fehlgeschlagene CAPs verwaltbar
- Prioritäten vorbereitet
- Bedrohungsstatus vorbereitet

Offen:

- MOOSE-Anbindung für reale CAP-Spawns
- AI Director erstellen
- GCI Manager erstellen
- Counterattack-System erstellen
- AI-Reaktionen auf Capture vorbereiten
- AI-Reaktionen auf IADS-Schäden vorbereiten
- AI-System funktional in DCS testen

---

## Phase 7 — IADS-System

Status:

    Dokumentiert, noch nicht implementiert

Ziele:

- rote IADS-Struktur vorbereiten
- SAM-Sites als Kampagnenobjekte verwalten
- Radarstellungen als Kampagnenobjekte verwalten
- IADS-Sektoren definieren
- Skynet IADS kapseln
- Missionsgenerator mit IADS-Zielen verbinden
- AI Director mit IADS-Zustand verbinden
- zerstörte IADS-Komponenten persistieren

Geplante Dateien:

- `src/iads/tc_iads_network.lua`
- `src/iads/tc_iads_sector_manager.lua`
- `src/iads/tc_iads_site_registry.lua`
- `src/iads/tc_iads_mission_bridge.lua`

Offen:

- erste IADS-Implementierung beginnen
- Skynet-IADS-Anbindung testen
- SEAD-/DEAD-Ziele erzeugen
- IADS-Zustand in Campaign State abbilden

---

## Phase 8 — UI und F10-Menüs

Status:

    Dokumentiert, noch nicht implementiert

Ziele:

- F10-Menü-Grundstruktur vorbereiten
- Kampagnenstatus anzeigen
- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Logistikstatus anzeigen
- FOB-Status anzeigen
- AI-Status anzeigen
- IADS-Status anzeigen
- Debug-Menü getrennt vorbereiten

Geplante Dateien:

- `src/ui/tc_f10_menu.lua`
- `src/ui/tc_status_display.lua`
- `src/ui/tc_mission_menu.lua`
- `src/ui/tc_logistics_menu.lua`
- `src/ui/tc_debug_menu.lua`

Offen:

- UI-Implementierung beginnen
- erste F10-Menüstruktur in DCS testen

---

## Phase 9 — Debug-System

Status:

    Dokumentiert, noch nicht implementiert

Ziele:

- Debug-Ausgaben bündeln
- Airbase-Reports erzeugen
- Zonen-Reports erzeugen
- Capture-Reports erzeugen
- Logistik-Reports erzeugen
- Missions-Reports erzeugen
- AI-Reports erzeugen
- IADS-Reports erzeugen
- Debug-State-Dumps vorbereiten
- Debug-Menü später optional aktivieren

Geplante Dateien:

- `src/debug/tc_debug_console.lua`
- `src/debug/tc_debug_state_dump.lua`
- `src/debug/tc_debug_zone_overlay.lua`
- `src/debug/tc_debug_airbase_report.lua`
- `src/debug/tc_debug_mission_report.lua`
- `src/debug/tc_debug_logistics_report.lua`
- `src/debug/tc_debug_ai_report.lua`
- `src/debug/tc_debug_iads_report.lua`

Offen:

- Debug-Grundmodul erstellen
- Airbase-Debugreport als nächstes sinnvolles Debug-Werkzeug vorbereiten

---

## Phase 10 — Persistenz

Status:

    In-Memory-Grundstruktur vorhanden

Ziele:

- Kampagnenzustand speichern
- Kampagnenzustand laden
- Airbase-Besitz speichern
- Zonenstatus speichern
- Logistikstatus speichern
- Missionsfortschritt speichern
- AI-Zustand speichern
- IADS-Zustand speichern
- Save-Dateien später kontrolliert schreiben und lesen

Aktuell vorhanden:

- `src/campaign/tc_persistence_system.lua`

Offen:

- DCS-Sandbox-Dateizugriff prüfen
- `save/README.md` erstellen
- `save/example_state.lua` erstellen
- echte Dateipersistenz erst nach Sandbox-Test umsetzen

---

## Phase 11 — Mission-Editor-Ausbau

Status:

    DEV-Mission begonnen

Aktuelle DEV-Mission:

    Operation_Levant_Reclamation_DEV.miz

Bisheriger Inhalt:

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

Ziele:

- DEV-Mission im Repository dokumentieren
- erste CTLD-Pickup-Zonen anlegen
- erste Dropoff-Zonen anlegen
- erste Template-Gruppen vorbereiten
- erste rote IADS-Struktur anlegen
- erste Debug-Trigger oder Debug-Menüs vorbereiten
- Mission-Editor-Aufbau bewusst schlank halten

Offen:

- `mission/`-Ordnerstruktur anlegen
- `mission/dev/` dokumentieren
- DEV-Mission sauber versionieren oder zumindest dokumentieren
- Mission-Editor-Zonen später mit Lua-System verbinden

---

## Phase 12 — Teststrategie

Status:

    Erster DCS-Starttest bestanden

Bisher bestanden:

    Starttest-Variante A — sichere Einzeldatei-Ladung

Noch offen:

    Starttest-Variante B — Loader-only mit dofile

Ziel Variante B:

- Frameworks per `DO SCRIPT FILE` laden
- nur `src/loader.lua` per `DO SCRIPT FILE` laden
- prüfen, ob der Loader weitere Source-Dateien per `dofile` nachladen kann
- DCS-Sandbox-Verhalten bewerten
- entscheiden, ob spätere Entwicklung mit Loader-only möglich ist oder Einzeldatei-Ladung nötig bleibt

Weitere geplante Tests:

- Airbase-Klassifizierung testen
- Debug-Airbase-Report testen
- Zone-Factory mit gefilterten Basen testen
- Capture-System funktional testen
- CTLD-Verbindung testen
- Mission Generator testen
- AI CAP Manager mit MOOSE testen
- IADS-Verbindung mit Skynet testen
- F10-Menüs testen
- Persistenz testen

---

## Nächster technischer Schwerpunkt

Der nächste technische Schwerpunkt ist:

    Airbase-Scanner nach dem Syria-Update fachlich filtern

Warum:

Der erste reale DCS-Test hat gezeigt, dass DCS auf der Syria Map aktuell 225 Airbase-/Helipad-Objekte zurückliefert.

Diese Objekte dürfen nicht ungefiltert als strategische Kampagnenbasen verwendet werden.

Ziel:

- strategische Airfields identifizieren
- Heliports erkennen
- Helipads erkennen
- Medical Pads erkennen
- sonstige taktische Pads erkennen
- `AirbaseScanner` um Klassifizierung erweitern
- `ZoneFactory` an diese Klassifizierung koppeln
- Capture-System nur auf geeignete strategische Basen anwenden
- Missionsgenerator nur geeignete Ziele verwenden lassen
- Debugreport für erkannte Airbase-Typen vorbereiten

---

## Danach geplanter Schritt

Nach der Airbase-Klassifizierung:

    Starttest-Variante B vorbereiten und testen

Ziel:

- prüfen, ob `src/loader.lua` die übrigen Source-Dateien im DCS-Kontext eigenständig nachladen kann
- `dofile`-Verhalten im Mission Scripting Environment bewerten
- spätere Lade- und Deployment-Strategie festlegen

---

## Langfristiges Zielbild

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

---

## Nicht-Ziele für die aktuelle Phase

Aktuell wird bewusst nicht gemacht:

- keine vollständige Frontlinie bauen
- keine komplette Syria Map manuell mit Einheiten füllen
- keine komplette IADS-Großstruktur bauen
- keine komplexe KI-Kampagne bauen
- keine automatische perfekte `.miz`-Generierung bauen
- keine Multiplayer-Synchronisation lösen
- keine kommerzielle Release-Struktur vorbereiten
- keine produktive Persistenz bauen
- keine All-in-one-Datei erstellen
- keine Framework-Dateien verändern

---

## Arbeitsregel

Es wird immer nur eine konkrete Aufgabe oder eine Datei pro Schritt umgesetzt.

Keine langen parallelen Aufgabenlisten.

Neue Dateien werden immer mit vollständigem Inhalt vorbereitet.

Eigene Theater-Command-Logik gehört nach:

    src/

Externe Frameworks gehören nach:

    vendor/

Frameworks werden nicht verändert.

Die eigene Lua-Struktur wird nach Aufgaben sortiert, nicht nach Frameworks.
