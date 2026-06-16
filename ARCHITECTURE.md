# Architecture

Diese Datei beschreibt die technische Architektur von **Theater Command DCS**.

Die erste Kampagne trägt den Arbeitstitel:

**Operation Levant Reclamation**

Die Kampagne wird auf der **Syria Map** aufgebaut.

Ausgangslage:

- Blue startet auf **Akrotiri / Zypern**
- Das syrische Festland ist zu Beginn rot kontrolliert
- Blue muss sich vom Brückenkopf Zypern aus auf das syrische Festland vorarbeiten
- Spieler klinken sich mit Client-Flugzeugen in eine laufende Kampagnenlage ein

---

## 1. Architekturprinzip

Das zentrale Architekturprinzip lautet:

- **Mission Editor = Bühne**
- **Lua = Kampagnensystem**
- **GitHub = Projektgedächtnis**

Der DCS Mission Editor stellt die physische Umgebung bereit.

Lua übernimmt die dynamische Kampagnenlogik.

GitHub dokumentiert:

- Struktur
- Entscheidungen
- Versionen
- Aufgabenstand
- Testergebnisse
- bekannte Einschränkungen
- nächste Entwicklungsschritte

---

## 2. Zielbild

Theater Command DCS soll langfristig folgende Systeme verbinden:

- Airbase-Erkennung
- strategische Airbase-Klassifizierung
- virtuelle Kampagnenzonen
- Capture-System
- Logistiksystem
- CTLD-Anbindung
- FOB-Aufbau
- dynamische Missionsgenerierung
- F10-Spielerinteraktion
- AI Director
- CAP- und GCI-Management
- Skynet-IADS-Anbindung
- SEAD-/DEAD-Missionslogik
- Debug-Werkzeuge
- Persistenz
- Kampagnenfortschritt über mehrere Sessions

Das System wird modular aufgebaut.

Jedes Modul hat eine klar begrenzte Aufgabe.

---

## 3. Spielerrolle in der Architektur

Theater Command DCS ist nicht als reine „Rot reagiert auf den Spieler“-Mission gedacht.

Ziel ist eine laufende Blue-vs-Red-Kampagnenlogik.

Das bedeutet:

- Blue kann defensive und offensive Operationen durchführen.
- Red kann defensive und offensive Operationen durchführen.
- Spieler steigen mit Client-Flugzeugen in diese laufende Lage ein.
- Spieler übernehmen Missionen und beeinflussen dadurch den Kampagnenverlauf.
- Die Kampagne soll später auch ohne jede Spieleraktion weiterlaufen können.
- Der Spieler ist Teilnehmer der Kampagne, nicht der einzige Auslöser der Kampagne.

Aktueller Stand:

- erste Blue-/Red-State-Logik ist vorhanden
- Missionen und CAP-Bedarf werden aus Kampagnenlage abgeleitet
- FOBs werden aus Logistics Hubs geplant
- Mission Generator erzeugt Missionen inklusive FOB-Support
- F10-Menü zeigt Missionen und Statusinformationen
- echte KI-Ausführung ist noch nicht implementiert
- ein vollständiger AI Director ist noch offen

---

## 4. Aktueller technischer Stand

Stand: **2026-06-16**

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
- aktive eigene Theater-Command-Lua-Module
- Loader
- Main-Initialisierung
- Core-System
- World-System
- Campaign-System
- Logistics-System
- Missions-System
- AI-CAP-System
- UI/F10-System
- IADS-Bereich dokumentiert
- Debug-Bereich dokumentiert
- minimale Syria-DEV-Mission
- erster blauer F/A-18C-Client-Slot auf Akrotiri
- vollständige Triggerkette für Starttest-Variante A
- mehrere reale DCS-Testläufe
- erfolgreiche `dcs.log`-Auswertungen

Aktuell erfolgreich getestet:

- Starttest-Variante A
- Airbase Scanner `v0.2.2`
- ZoneFactory `v0.2.0`
- CaptureSystem `v0.2.0`
- LogisticsDelivery `v0.2.0`
- FobSystem `v0.2.0`
- MissionGenerator `v0.2.1`
- AICapManager `v0.2.0`
- F10Menu `v0.1.0`

Wichtig:

Die aktuelle Architektur ist weiterhin überwiegend eine **State-first-Architektur**.

Das bedeutet:

- Systeme erzeugen und verwalten Kampagnenzustand.
- Systeme bereiten Missionen, CAPs, Logistics, FOBs und Capture vor.
- echte DCS-Gruppen werden noch nicht durch Theater Command gespawnt.
- MOOSE, CTLD und Skynet IADS sind geladen, aber noch nicht produktiv über eigene Theater-Command-Brücken angebunden.
- Das F10-Menü zeigt und aktiviert aktuell State-Missionen, löst aber noch keine echten Spawns aus.

---

## 5. Hauptstruktur

Aktuelle Hauptstruktur:

```text
docs/
mission_editor/
src/
vendor/
.gitignore
ARCHITECTURE.md
CHANGELOG.md
LUA_STYLEGUIDE.md
MISSION_EDITOR_SETUP.md
NAMING_CONVENTIONS.md
README.md
ROADMAP.md
TASKS.md
```

---

## 6. Externe Frameworks

Externe Frameworks liegen ausschließlich unter:

```text
vendor/
```

Aktuelle Framework-Basis:

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Zusätzlich wird geladen:

```text
vendor/ctld/CTLD-i18n.lua
```

Wichtig:

Framework-Dateien werden nicht verändert.

Eigene Theater-Command-Logik wird nicht in Framework-Dateien geschrieben.

Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket.

Grund:

CTLD benötigt für korrektes dynamisches Spawning eine kompatible MIST-Version.

---

## 7. Eigene Lua-Logik

Eigene Lua-Logik liegt ausschließlich unter:

```text
src/
```

Die eigene Struktur ist nach Aufgaben sortiert, nicht nach Frameworks.

Nicht gewünscht sind Sammeldateien wie:

```text
tc_moose.lua
tc_mist.lua
tc_ctld.lua
tc_all_in_one.lua
```

Stattdessen wird Theater Command fachlich modular aufgebaut.

Aktuelle Source-Struktur:

```text
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
```

---

## 8. Aktive Source-Module

Aktuell vorhandene aktive eigene Lua-Dateien:

```text
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
src/ui/tc_f10_menu.lua
```

Aktuell nur dokumentiert:

```text
src/iads/
src/debug/
```

Diese Bereiche besitzen aktuell README-Dateien, aber noch keine aktiven Lua-Module.

---

## 9. Externe DCS-Lade-Reihenfolge

Die externen Frameworks werden im DCS Mission Editor in dieser Reihenfolge geladen:

1. `vendor/mist/mist.lua`
2. `vendor/moose/Moose.lua`
3. `vendor/ctld/CTLD-i18n.lua`
4. `vendor/ctld/CTLD.lua`
5. `vendor/skynet-iads/SkynetIADS.lua`

Danach folgt die eigene Theater-Command-Logik.

Diese Reihenfolge wurde in realen DCS-Testläufen erfolgreich verwendet.

---

## 10. Aktuelle Source-Lade-Reihenfolge

Aktuell wird Starttest-Variante A genutzt.

Das bedeutet:

- sichere Einzeldatei-Ladung
- jede aktive Datei wird einzeln per `DO SCRIPT FILE` geladen
- `src/main.lua` wird nach den Modulen geladen
- `src/loader.lua` wird zuletzt geladen

Getestete Trigger-Reihenfolge:

```text
TIME MORE 1
DO SCRIPT FILE: vendor/mist/mist.lua

TIME MORE 2
DO SCRIPT FILE: vendor/moose/Moose.lua

TIME MORE 3
DO SCRIPT FILE: vendor/ctld/CTLD-i18n.lua

TIME MORE 4
DO SCRIPT FILE: vendor/ctld/CTLD.lua

TIME MORE 5
DO SCRIPT FILE: vendor/skynet-iads/SkynetIADS.lua

TIME MORE 7
DO SCRIPT FILE: src/core/tc_config.lua

TIME MORE 8
DO SCRIPT FILE: src/core/tc_logger.lua

TIME MORE 9
DO SCRIPT FILE: src/core/tc_state.lua

TIME MORE 10
DO SCRIPT FILE: src/core/tc_utils.lua

TIME MORE 11
DO SCRIPT FILE: src/core/tc_scheduler.lua

TIME MORE 12
DO SCRIPT FILE: src/world/tc_airbase_scanner.lua

TIME MORE 13
DO SCRIPT FILE: src/world/tc_zone_factory.lua

TIME MORE 14
DO SCRIPT FILE: src/campaign/tc_capture_system.lua

TIME MORE 15
DO SCRIPT FILE: src/campaign/tc_persistence_system.lua

TIME MORE 16
DO SCRIPT FILE: src/logistics/tc_logistics_delivery.lua

TIME MORE 17
DO SCRIPT FILE: src/logistics/tc_fob_system.lua

TIME MORE 18
DO SCRIPT FILE: src/missions/tc_mission_generator.lua

TIME MORE 19
DO SCRIPT FILE: src/ai/tc_ai_cap_manager.lua

TIME MORE 20
DO SCRIPT FILE: src/ui/tc_f10_menu.lua

TIME MORE 21
DO SCRIPT FILE: src/main.lua

TIME MORE 23
DO SCRIPT FILE: src/loader.lua
```

Wichtig:

Eine per `DO SCRIPT FILE` geladene Lua-Datei wird in die `.miz` eingebettet.

Nach jeder Änderung einer Lua-Datei muss diese Datei im Mission Editor erneut ausgewählt und die Mission gespeichert werden.

---

## 11. Interne Theater-Command-Lade-Reihenfolge

Die interne Theater-Command-Lade-Reihenfolge lautet:

1. Core
2. World
3. Campaign
4. Logistics
5. Missions
6. AI
7. UI
8. IADS
9. Debug
10. Main

Aktuell aktiv geladen:

- Core
- World
- Campaign
- Logistics
- Missions
- AI
- UI
- Main

Noch nicht aktiv geladen:

- IADS
- Debug

Grund:

Diese Bereiche sind vorbereitet, aber noch nicht implementiert.

---

## 12. Starttest-Architektur

Der erste erfolgreiche DCS-Test wurde mit folgender Variante durchgeführt:

**Starttest-Variante A — sichere Einzeldatei-Ladung**

Dabei wurden alle aktiven Dateien einzeln per `DO SCRIPT FILE` geladen.

Gründe:

- keine harte Abhängigkeit von `dofile`
- klare Fehlereingrenzung
- jede Datei wird direkt im DCS-Kontext getestet
- geeignet für die erste technische Validierung
- `dcs.log` zeigt eindeutig, welche Module starten

Wichtig:

`src/main.lua` wird vor `src/loader.lua` geladen.

`src/loader.lua` wird als letzte eigene Datei geladen.

Grund:

- `main.lua` stellt `TC.Main` bereit.
- `loader.lua` prüft anschließend die Frameworks und startet die Main-Initialisierung.

---

## 13. Ergebnis der aktuellen Startarchitektur

Aktuelle DCS-Tests bestätigen:

- MIST erkannt
- MOOSE erkannt
- CTLD erkannt
- Skynet IADS erkannt
- Core geladen
- World geladen
- Campaign geladen
- Logistics geladen
- Missions geladen
- AI geladen
- UI geladen
- Main gestartet
- Runtime-Systeme initialisiert
- Loader beendet

Wichtige positive Logik:

- Frameworks laden
- Loader erkennt Frameworks
- Main startet
- Runtime-Systeme starten
- Runtime-Systeme erzeugen klassifizierten Kampagnenzustand
- F10-Menü wird erzeugt
- Loader beendet sauber

Aktuell erwartete Hauptmarker:

```text
[TC] Theater Command loader started
[TC] Framework available: MIST
[TC] Framework available: MOOSE
[TC] Framework available: CTLD
[TC] Framework available: Skynet IADS
[TC] Main start requested
[TC] Runtime systems initialized
[TC] Main initialized
[TC] Main started
[TC] Theater Command loader finished
```

Zusätzliche aktuelle UI-Marker:

```text
[TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.1.0
[TC] [F10Menu] F10 menu started
[TC] [F10Menu] F10 menu initialized: commands=7
[TC] System started: F10 Menu
```

---

## 14. Getestete Kernwerte

### Airbase Scanner

Datei:

```text
src/world/tc_airbase_scanner.lua
```

Aktuelle getestete Version:

```text
v0.2.2
```

Bestätigte Testwerte:

| Wert | Anzahl |
|---|---:|
| total | 225 |
| strategic | 19 |
| secondary | 13 |
| heliports | 1 |
| helipads | 95 |
| medical | 40 |
| farps | 0 |
| tactical | 13 |
| unknown | 44 |
| captureCandidates | 32 |
| missionCandidates | 32 |
| logisticsCandidates | 46 |
| blueStartBases | 1 |
| redStrategicCandidates | 18 |

Bewertung:

Die Syria-Airbase-Objekte werden nicht mehr nur gezählt, sondern fachlich klassifiziert.

---

### Zone Factory

Datei:

```text
src/world/tc_zone_factory.lua
```

Aktuelle getestete Version:

```text
v0.2.0
```

Bestätigte Testwerte:

| Wert | Anzahl |
|---|---:|
| total zones | 46 |
| classified airbase zones | 46 |
| Mission Editor zones | 0 |
| skipped airbase-like objects | 179 |
| strategic zones | 19 |
| secondary zones | 13 |
| heliport zones | 1 |
| farp zones | 0 |
| tactical zones | 13 |
| captureZones | 32 |
| missionZones | 32 |
| logisticsZones | 46 |
| startBaseZones | 1 |

Bewertung:

Die ZoneFactory erzeugt nicht mehr 225 ungefilterte Zonen, sondern 46 relevante Kampagnenzonen.

---

### Capture System

Datei:

```text
src/campaign/tc_capture_system.lua
```

Aktuelle getestete Version:

```text
v0.2.0
```

Bestätigte Testwerte:

| Wert | Anzahl |
|---|---:|
| eligibleBases | 32 |
| eligibleZones | 32 |
| nonCaptureBases | 193 |
| nonCaptureZones | 14 |

Bewertung:

Capture wirkt nur noch auf strategische und sekundäre Kampagnenziele.

---

### Logistics Delivery

Datei:

```text
src/logistics/tc_logistics_delivery.lua
```

Aktuelle getestete Version:

```text
v0.2.0
```

Bestätigte Testwerte:

| Wert | Anzahl |
|---|---:|
| logistics hubs | 46 |
| blue hubs | 7 |
| red hubs | 24 |
| neutral hubs | 15 |
| active hubs | 31 |
| limited hubs | 15 |
| locked hubs | 0 |

Bewertung:

Logistics Delivery nutzt klassifizierte Kampagnenzonen.

---

### FOB System

Datei:

```text
src/logistics/tc_fob_system.lua
```

Aktuelle getestete Version:

```text
v0.2.0
```

Bestätigte Testwerte:

| Wert | Anzahl |
|---|---:|
| FOB candidates | 6 |
| stored candidates | 6 |
| auto-planned FOBs | 2 |
| skipped candidates | 4 |
| Blue FOBs | 2 |

Bestätigte erzeugte FOBs:

- `FOB Ercan`
- `FOB Gecitkale`

Status:

- `UNDER_CONSTRUCTION`

Bewertung:

FOB System nutzt die Logistics-Hub-Struktur und erzeugt State-only-FOBs.

---

### Mission Generator

Datei:

```text
src/missions/tc_mission_generator.lua
```

Aktuelle getestete Version:

```text
v0.2.1
```

Bestätigte Testwerte:

| Wert | Anzahl |
|---|---:|
| mission candidates | 69 |
| fobSupportCandidates | 2 |
| generated missions | 10 |
| reservedCreated | 1 |
| duplicatesSkipped | 1 |
| typeLimitSkipped | 30 |

Im Test erzeugte Missionstypen:

- `FOB_SUPPORT`
- `AIRBASE_ATTACK`
- `SEAD`
- `STRIKE`
- `CAP`

Bestätigte FOB-Support-Missionen:

- `FOB_SUPPORT` für `FOB Ercan`
- `FOB_SUPPORT` für `FOB Gecitkale`

Bewertung:

Missionen werden aus klassifizierten Kampagnenzonen und aus FOB-Support-Bedarf erzeugt.

---

### AI CAP Manager

Datei:

```text
src/ai/tc_ai_cap_manager.lua
```

Aktuelle getestete Version:

```text
v0.2.0
```

Bestätigte Testwerte:

| Wert | Anzahl |
|---|---:|
| cap zone candidates | 31 |
| auto-registered CAP zones | 12 |
| CAP requests | 12 |

Weitere bestätigte Werte:

- reactionState: `AIR_REACTION_REQUESTED`
- threatLevel: `HIGH`

Bewertung:

Blue- und Red-CAP-Bedarf wird als State vorbereitet.  
Echter MOOSE-Spawn ist noch nicht aktiv.

---

### F10 Menu

Datei:

```text
src/ui/tc_f10_menu.lua
```

Aktuelle getestete Version:

```text
v0.1.0
```

Bestätigte Testwerte:

| Wert | Ergebnis |
|---|---|
| F10 menu visible | ja |
| F10 menu navigable | ja |
| commands | 7 |

Bestätigte Funktionen:

- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Top-Mission aktivieren
- Kampagnenstatus anzeigen
- Logistikstatus anzeigen
- FOB-Status anzeigen
- AI-CAP-Status anzeigen

Bewertung:

Erste spielerseitige Bedienoberfläche funktioniert.  
Direkte Missionsauswahl 1 bis 10 ist noch offen.

---

## 15. Aktueller Datenfluss

Der aktuelle Datenfluss lautet:

```text
DCS world.getAirbases()
        ↓
Airbase Scanner
        ↓
klassifizierte Airbase Records
        ↓
Zone Factory
        ↓
gefilterte Kampagnenzonen
        ↓
Capture System
Logistics Delivery
        ↓
FOB System
        ↓
Mission Generator
AI CAP Manager
        ↓
F10 Menu
        ↓
Spieler sieht Status und aktiviert State-Missionen
```

Im Detail:

1. DCS liefert über `world.getAirbases()` viele Airbase-ähnliche Objekte.
2. Airbase Scanner klassifiziert diese Objekte.
3. ZoneFactory erzeugt daraus relevante Kampagnenzonen.
4. Capture System ermittelt capture-fähige Ziele.
5. Logistics Delivery erzeugt Logistics Hubs.
6. FOB System erzeugt FOB-Kandidaten und State-only-FOBs.
7. Mission Generator erzeugt verfügbare Missionen inklusive FOB-Support.
8. AI CAP Manager erzeugt Blue-/Red-CAP-Anforderungen.
9. F10 Menu zeigt Missionen und Statusinformationen an.
10. Spätere Systeme sollen diese State-Daten nutzen:
    - AI Director
    - MOOSE-Spawns
    - CTLD-Logistik
    - Skynet IADS
    - Persistence
    - Debug

---

## 16. State-first-Architektur

Aktuell folgt Theater Command DCS bewusst einer **State-first-Architektur**.

Das bedeutet:

Zuerst wird ein sauberer Kampagnenzustand aufgebaut.

Erst danach werden echte DCS-Aktionen gekoppelt.

Vorteil:

- Debugging ist einfacher
- Datenflüsse sind klarer
- Fehler in DCS-Spawns werden von State-Fehlern getrennt
- DCS-Frameworks werden erst angebunden, wenn die fachliche Logik stabil ist
- spätere Persistenz kann auf stabilen Datenstrukturen aufbauen

Aktuell State-only oder primär State-basiert:

- Mission Generator
- AI CAP Manager
- Logistics Delivery
- FOB System
- Capture System
- Persistence System teilweise
- F10 Menu als Anzeige- und Bedienoberfläche für State-Missionen

Noch nicht echte DCS-Ausführung:

- keine echten MOOSE-CAP-Spawns
- keine echten MOOSE-Strike-Spawns
- keine echten CTLD-Cargo-Abläufe
- keine echten CTLD-FOBs
- keine echten Skynet-IADS-Kampagnenbrücken
- keine Dateipersistenz
- keine echte Missionsauswertung über DCS-Events

---

## 17. Core-Architektur

Der Core-Bereich bildet die technische Grundlage.

Pfad:

```text
src/core/
```

Aktuelle Dateien:

```text
src/core/tc_config.lua
src/core/tc_logger.lua
src/core/tc_state.lua
src/core/tc_utils.lua
src/core/tc_scheduler.lua
```

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

## 18. World-Architektur

Der World-Bereich verbindet DCS-Weltobjekte mit Theater-Command-Daten.

Pfad:

```text
src/world/
```

Aktuelle Dateien:

```text
src/world/tc_airbase_scanner.lua
src/world/tc_zone_factory.lua
```

Aufgaben:

- DCS-Airbases erfassen
- Airbase-Datensätze erzeugen
- Airbase-Objekte klassifizieren
- Koalitionsstatus erkennen
- virtuelle Kampagnenzonen erzeugen
- Airbases und Zonen verbinden
- Daten für Campaign, Logistics, Missions und AI bereitstellen

Aktueller Befund:

Syria liefert aktuell 225 Airbase-/Helipad-ähnliche Objekte.

Architekturentscheidung:

Diese Objekte werden nicht ungefiltert verwendet.

Stattdessen erfolgt eine Klassifizierung in:

- `STRATEGIC_AIRFIELD`
- `SECONDARY_AIRFIELD`
- `HELIPORT`
- `HELIPAD`
- `MEDICAL_PAD`
- `FARP`
- `TACTICAL_PAD`
- `UNKNOWN`

Folge:

- nur 46 relevante Kampagnenzonen werden erzeugt
- nur 32 Ziele sind capture-fähig
- 46 Zonen sind logistikrelevant
- medizinische Pads, einzelne Helipads und Unknowns werden nicht als strategische Ziele verwendet

---

## 19. Campaign-Architektur

Der Campaign-Bereich verwaltet den strategischen Zustand.

Pfad:

```text
src/campaign/
```

Aktuelle Dateien:

```text
src/campaign/tc_capture_system.lua
src/campaign/tc_persistence_system.lua
```

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

Campaign nutzt Daten aus:

- World
- Logistics
- Missions
- AI
- IADS

Aktueller Stand:

- Capture System filtert strategisch relevante Ziele
- 32 Bases/Zones sind capture-fähig
- 193 Bases und 14 Zonen werden als nicht capture-fähig behandelt

Offen:

- Capture-Fortschritt
- Capture-Druck
- Garnisonen
- Supply-Einfluss
- Missionseffekte
- AI-Effekte
- echte Persistenz

---

## 20. Logistics-Architektur

Der Logistics-Bereich verwaltet Versorgung, Lieferungen und FOB-Aufbau.

Pfad:

```text
src/logistics/
```

Aktuelle Dateien:

```text
src/logistics/tc_logistics_delivery.lua
src/logistics/tc_fob_system.lua
```

Aufgaben:

- Logistics Hubs erzeugen
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

Aktueller Stand:

- Logistics Delivery erzeugt 46 Hubs
- Blue besitzt 7 Hubs
- Red besitzt 24 Hubs
- Neutral/Limited besitzt 15 Hubs
- CTLD ist noch nicht aktiv angebunden
- FOB System nutzt die Logistics-Hub-Struktur
- FOB System erzeugt 6 Kandidaten
- FOB System plant 2 Blue-FOBs
- FOBs befinden sich aktuell im State-only-Status `UNDER_CONSTRUCTION`

Offen:

- CTLD Pickup-/Dropoff-Zonen definieren
- CTLD-Cargo mit Theater Command verbinden
- echte CTLD-FOB-Erstellung vorbereiten
- Supply-Verbrauch modellieren
- Delivery-Effekte mit Capture koppeln
- Delivery-Effekte mit Mission Generator koppeln
- Delivery-Effekte mit AI koppeln

---

## 21. Missions-Architektur

Der Missions-Bereich erzeugt spielbare Aufträge aus dem Kampagnenzustand.

Pfad:

```text
src/missions/
```

Aktuelle Datei:

```text
src/missions/tc_mission_generator.lua
```

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

Missionsergebnisse werden später an folgende Systeme gemeldet:

- Campaign
- Logistics
- AI
- IADS

Aktueller Stand:

- Mission Generator nutzt klassifizierte Zonen
- Mission Generator berücksichtigt FOBs
- Mission Generator erzeugt FOB-Support-Missionen
- 69 Missionskandidaten wurden im letzten Test erzeugt
- 10 verfügbare Missionen wurden erzeugt
- `FOB_SUPPORT` wird nicht mehr aus der Missionsliste verdrängt
- Medical Pads, einzelne Helipads und Unknowns werden nicht als Strike-Ziele genutzt

Offen:

- direkte F10-Missionsauswahl 1 bis 10
- Missionsaktivierung einzelner Missionen durch Spieler
- Missionsabschluss durch Events oder Trigger
- Missionseffekte auf Capture
- Missionseffekte auf Logistics
- Missionseffekte auf AI/IADS
- bessere Briefingtexte

---

## 22. AI-Architektur

Der AI-Bereich steuert spätere KI-Reaktionen.

Pfad:

```text
src/ai/
```

Aktuelle Datei:

```text
src/ai/tc_ai_cap_manager.lua
```

Aufgaben:

- CAP-Zonen verwalten
- CAP-Anforderungen speichern
- aktive CAPs verwalten
- CAP-Abschluss verwalten
- CAP-Fehlschläge verwalten
- Bedrohungsstatus vorbereiten
- spätere MOOSE-Anbindung vorbereiten

Geplante spätere Dateien:

```text
src/ai/tc_ai_director.lua
src/ai/tc_ai_gci_manager.lua
src/ai/tc_ai_counterattack.lua
```

Architekturregel:

AI reagiert auf den Kampagnenzustand.

AI darf später MOOSE für Spawns nutzen.

AI soll keine strategischen Besitzentscheidungen alleine treffen.

Aktueller Stand:

- AI CAP Manager nutzt klassifizierte Kampagnenzonen
- Blue- und Red-CAP-Bedarf wird vorbereitet
- 31 CAP-Kandidaten wurden erkannt
- 12 CAP-Zonen wurden registriert
- 12 CAP-Requests wurden erzeugt
- `spawn=MOOSE_PENDING` ist erwartetes Verhalten

Offen:

- echte MOOSE-CAP-Spawns
- MOOSE-Templates im Mission Editor
- AI Director
- GCI Manager
- Counterattack-System
- beidseitige Blue-/Red-Operationen unabhängig vom Spieler
- DCS-Eventauswertung für CAP-Verluste und CAP-Erfolge

---

## 23. UI-Architektur

Der UI-Bereich stellt Spielerinteraktion bereit.

Pfad:

```text
src/ui/
```

Aktuelle Datei:

```text
src/ui/tc_f10_menu.lua
```

Aktueller Stand:

- aktiv implementiert
- in DCS sichtbar
- navigierbar
- 7 Commands bestätigt

Aktuelle Funktionen:

- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Top-Mission aktivieren
- Kampagnenstatus anzeigen
- Logistikstatus anzeigen
- FOB-Status anzeigen
- AI-CAP-Status anzeigen

Geplante weitere Dateien:

```text
src/ui/tc_status_display.lua
src/ui/tc_mission_menu.lua
src/ui/tc_logistics_menu.lua
src/ui/tc_debug_menu.lua
```

Aufgaben:

- F10-Menüs bereitstellen
- Kampagnenstatus anzeigen
- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Logistikstatus anzeigen
- FOB-Status anzeigen
- AI-Status anzeigen
- IADS-Status anzeigen
- Debug-Menü optional anzeigen
- Spielerbefehle an State-Systeme weitergeben

Architekturregel:

UI zeigt Daten und nimmt Spielerkommandos entgegen.

UI entscheidet nicht selbst über Kampagnenlogik.

Aktuelle Einschränkung:

- Aktuell kann nur die Top-Mission aktiviert werden.
- Direkte Missionsauswahl 1 bis 10 ist noch offen.
- Mission completed/failed ist noch nicht über UI oder Debug steuerbar.

---

## 24. IADS-Architektur

Der IADS-Bereich wird die Theater-Command-Schicht über Skynet IADS.

Pfad:

```text
src/iads/
```

Aktueller Stand:

- dokumentiert
- noch nicht aktiv implementiert
- Skynet IADS wird als Vendor geladen

Geplante Dateien:

```text
src/iads/tc_iads_network.lua
src/iads/tc_iads_sector_manager.lua
src/iads/tc_iads_site_registry.lua
src/iads/tc_iads_mission_bridge.lua
```

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

## 25. Debug-Architektur

Der Debug-Bereich wird Entwicklungs- und Prüfhilfen bereitstellen.

Pfad:

```text
src/debug/
```

Aktueller Stand:

- dokumentiert
- noch nicht aktiv implementiert
- Logging ist bereits vorhanden

Geplante Dateien:

```text
src/debug/tc_debug_console.lua
src/debug/tc_debug_state_dump.lua
src/debug/tc_debug_zone_overlay.lua
src/debug/tc_debug_airbase_report.lua
src/debug/tc_debug_mission_report.lua
src/debug/tc_debug_logistics_report.lua
src/debug/tc_debug_fob_report.lua
src/debug/tc_debug_ai_report.lua
src/debug/tc_debug_iads_report.lua
```

Aufgaben:

- Debug-State-Dumps erzeugen
- Airbase-Reports erzeugen
- Zonen-Reports erzeugen
- Capture-Reports erzeugen
- Logistics-Reports erzeugen
- FOB-Reports erzeugen
- Missions-Reports erzeugen
- AI-Reports erzeugen
- UI-Reports erzeugen
- IADS-Reports erzeugen
- Debug-Ausgaben abschaltbar machen

Architekturregel:

Debug darf den Kampagnenzustand sichtbar machen.

Debug darf produktive Logik nicht ersetzen.

---

## 26. Persistenz-Architektur

Persistenz wird später den Kampagnenzustand über Sessions hinweg erhalten.

Aktuelle Datei:

```text
src/campaign/tc_persistence_system.lua
```

Aktueller Stand:

- In-Memory-Persistenz vorbereitet
- State-Snapshots vorbereitet
- DCS-Dateizugriff noch nicht praktisch getestet

Geplante spätere Struktur:

```text
save/
save/example_state.lua
```

Aufgaben:

- State-Snapshot erzeugen
- State exportieren
- State importieren
- später Datei schreiben
- später Datei lesen
- Airbase-Besitz speichern
- Zonenstatus speichern
- Capture-Zustand speichern
- Logistikstatus speichern
- FOB-Zustand speichern
- Missionsfortschritt speichern
- AI-Zustand speichern
- UI-Zustand speichern
- IADS-Zustand speichern

Wichtig:

DCS-Dateizugriff und DCS-Sandbox-Verhalten müssen vor echter Dateipersistenz praktisch getestet werden.

---

## 27. Mission-Editor-Architektur

Die aktuelle DEV-Mission ist nur ein technischer Testträger.

Dateiname:

```text
Operation_Levant_Reclamation_DEV.miz
```

Aktueller Inhalt:

- Map: Syria
- Koalitionspreset: Modern
- Blue Start: Akrotiri / Zypern
- erster blauer Client-Slot: F/A-18C Lot 20 auf Akrotiri
- Trigger: Starttest-Variante A vollständig angelegt
- Theater-Command-F10-Menü sichtbar und navigierbar
- keine rote Frontlinie
- keine IADS-Stellungen
- keine CTLD-Zonen
- keine Template-Gruppen

Architekturregel:

Der Mission Editor soll möglichst schlank bleiben.

Große dynamische Logik gehört nach Lua.

Der Mission Editor liefert:

- Startpositionen
- Client-Slots
- Template-Gruppen
- Trigger zum Laden
- Mission-Editor-Zonen
- statische Objekte
- IADS-/SAM-Objekte, sofern sie nicht dynamisch gespawnt werden

---

## 28. DCS-Sandbox und Loader-only-Architektur

Die aktuelle erfolgreiche Testarchitektur nutzt Einzeldatei-Ladung.

Noch nicht getestet:

**Starttest-Variante B — Loader-only mit `dofile`**

Ziel Variante B:

- Frameworks per Mission Editor laden
- nur `src/loader.lua` laden
- prüfen, ob `loader.lua` weitere Dateien per `dofile` nachladen kann
- DCS-Sandbox-Verhalten bewerten
- spätere Deployment-Strategie entscheiden

Mögliche Ergebnisse:

1. Loader-only funktioniert.
2. Einzeldatei-Ladung bleibt für Entwicklung notwendig.
3. Es wird später eine Build-Datei benötigt.
4. DCS-Sandbox muss gezielt angepasst oder umgangen werden.

Diese Entscheidung wird erst nach einem praktischen Test getroffen.

---

## 29. Abhängigkeitsregeln

Grundregel:

Niedrige Schichten dürfen nicht von höheren Schichten abhängen.

Vereinfachte Richtung:

```text
Core
  ↓
World
  ↓
Campaign
  ↓
Logistics
  ↓
Missions
  ↓
AI
  ↓
UI
  ↓
IADS
  ↓
Debug
```

Praktische Regeln:

- Core darf von allen genutzt werden.
- World liefert DCS-Weltdaten.
- Campaign verwaltet strategischen Zustand.
- Logistics liefert Versorgungszustände.
- Missions erzeugt Aufträge aus State-Daten.
- AI reagiert auf State-Daten.
- UI zeigt Daten und nimmt Spielerbefehle an.
- IADS liefert Luftverteidigungszustände.
- Debug liest Daten und erzeugt Prüfberichte.

Keine Datei soll heimlich große Nebenlogik aus fremden Bereichen übernehmen.

---

## 30. Framework-Brücken

Aktuell gilt:

Frameworks sind geladen, aber eigene Theater-Command-Brücken sind noch nicht produktiv umgesetzt.

### MIST

Aktuelle Nutzung:

- optional für Mission-Editor-Zonen über ZoneFactory

Spätere Nutzung:

- Hilfsfunktionen
- Event-/Datenbankzugriff, falls sinnvoll
- keine direkte zentrale Kampagnenlogik

### MOOSE

Aktuelle Nutzung:

- geladen
- noch keine echten MOOSE-Spawns durch Theater Command

Spätere Nutzung:

- CAP-Spawns
- GCI
- Strike-/SEAD-/CAS-Gruppen
- Dispatcher-Logik
- AI-Flüge

### CTLD

Aktuelle Nutzung:

- geladen
- noch keine aktive Theater-Command-CTLD-Kopplung

Spätere Nutzung:

- Cargo
- Pickup-Zonen
- Dropoff-Zonen
- FOB-Aufbau
- Logistiklieferungen

### Skynet IADS

Aktuelle Nutzung:

- geladen
- noch keine eigene IADS-Kampagnenbrücke

Spätere Nutzung:

- rote Luftverteidigung
- IADS-Sektoren
- IADS-Zustand
- SEAD-/DEAD-Missionsziele
- persistente IADS-Schäden

---

## 31. Nicht-Ziele der aktuellen Architekturphase

Aktuell wird bewusst nicht gebaut:

- keine vollständige Frontlinie
- keine komplette Syria-Befüllung
- keine komplette IADS-Großstruktur
- keine komplexe KI-Kampagne mit echten Spawns
- keine automatische `.miz`-Generierung
- keine Multiplayer-Synchronisation
- keine produktive Persistenz
- keine kommerzielle Release-Struktur
- keine All-in-one-Datei
- keine Framework-Änderungen

---

## 32. Nächste Architekturentscheidungen

Die Airbase-Klassifizierung ist erledigt und getestet.

Die ZoneFactory-Filterung ist erledigt und getestet.

Die FOB-Anbindung an Logistics Hubs ist erledigt und getestet.

FOB-Support im Mission Generator ist erledigt und getestet.

Das erste F10-Menü ist erledigt und getestet.

Aktuelle nächste Entscheidungen:

1. Wie wird direkte Missionsauswahl 1 bis 10 im F10-Menü stabil umgesetzt?
2. Wann werden Mission completed/failed Funktionen vorbereitet?
3. Wann wird Persistence praktisch im DCS-Sandbox-Kontext getestet?
4. Wann wird Starttest-Variante B mit Loader-only geprüft?
5. Wann beginnt die echte MOOSE-CAP-Anbindung?
6. Wann beginnt die CTLD-Integration mit echten Pickup-/Dropoff-Zonen?
7. Wann wird der AI Director als beidseitige Kampagnenlogik eingeführt?

Aktuelle Empfehlung:

Nach dem Session-Abschluss als nächster Code-Schritt:

```text
src/ui/tc_f10_menu.lua
```

Ziel:

- F10-Menü von „Activate Top Mission“ auf direkte Missionsauswahl erweitern
- Mission 1 bis Mission 10 direkt auswählbar machen
- Missionsdetails über F10 anzeigen
- weiterhin state-only bleiben
- keine echten MOOSE-/CTLD-Spawns auslösen

---

## 33. Aktueller Status

Die Grundarchitektur ist angelegt.

Die aktive Source-Kette wurde erfolgreich im DCS Mission Scripting Environment getestet.

Mehrere zentrale State-Systeme arbeiten inzwischen auf gefilterten, klassifizierten Kampagnendaten.

Aktuell funktioniert:

- Airbase-Erkennung
- Airbase-Klassifizierung
- Zonenfilterung
- Capture-Eligibility
- Logistics-Hub-Erzeugung
- FOB-Kandidaten
- State-only-FOBs
- Missionsgenerierung inklusive FOB-Support
- AI-CAP-State
- F10-Menü mit Status- und Missionsanzeige
- F10-Aktivierung der Top-Mission

Noch offen:

- direkte Missionsauswahl 1 bis 10 über F10
- echte MOOSE-Spawns
- echte CTLD-Integration
- echte IADS-Kampagnenlogik
- echte Persistenz
- AI Director
- echte DCS-Missionsauswertung

Der nächste technische Schritt nach dieser Dokumentationsrunde ist voraussichtlich die Anpassung von:

```text
src/ui/tc_f10_menu.lua
```
