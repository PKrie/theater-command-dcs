# Theater Command DCS

**Theater Command DCS** ist ein modulares, dynamisches und später persistentes DCS-World-Kampagnensystem.

Die erste Kampagne trägt den Arbeitstitel:

**Operation Levant Reclamation**

Das Projekt wird auf der **Syria Map** aufgebaut.

Ausgangslage:

- Blue startet auf **Akrotiri / Zypern**
- Das syrische Festland ist zu Beginn rot kontrolliert
- Blue muss sich vom Brückenkopf Zypern aus auf das syrische Festland vorarbeiten

---

## Grundidee

Theater Command DCS soll keine einzelne statische Mission werden.

Ziel ist ein dynamisches Kampagnensystem, das aus einem zentralen Kampagnenzustand heraus folgende Bereiche verwaltet:

- Airbases
- Kampagnenzonen
- Capture / Ownership
- Logistik
- FOBs
- Missionen
- KI-Reaktionen
- Luftverteidigung / IADS
- Persistenz
- Spielerinteraktion über F10-Menüs

Grundprinzip:

- **Mission Editor = Bühne**
- **Lua = Kampagnensystem**
- **GitHub = Projektgedächtnis**

Der DCS Mission Editor stellt die physische Bühne bereit.  
Lua übernimmt die eigentliche Kampagnenlogik.  
GitHub dokumentiert Struktur, Entscheidungen, Versionen, Teststände und Aufgabenstand.

---

## Spielerrolle

Der Spieler ist perspektivisch nicht der alleinige Motor der Kampagne.

Ziel ist eine laufende Blue-vs-Red-Kampagnenlogik:

- Blue kann eigene defensive und offensive Operationen durchführen.
- Red kann eigene defensive und offensive Operationen durchführen.
- Spieler können mit Client-Flugzeugen in die laufende Kampagne einsteigen.
- Spieler übernehmen Missionen und beeinflussen dadurch den Kampagnenverlauf.
- Die Kampagne soll später auch weiterlaufen, wenn der Spieler nicht jede Aktion selbst auslöst.

Aktueller Stand:

- erste Blue-/Red-State-Logik ist vorhanden
- Missionen und CAP-Bedarf werden aus der Kampagnenlage abgeleitet
- echte KI-Ausführung ist noch nicht implementiert
- ein vollständiger AI Director für beidseitige Operationen ist noch offen

---

## Aktueller Projektstand

Stand: **2026-06-16**

Aktueller Status:

Die Projektbasis ist angelegt.  
Die Vendor-Frameworks sind eingebunden.  
Die erste sichere DCS-Ladevariante wurde erfolgreich getestet.  
Die Theater-Command-Startkette läuft im DCS Mission Scripting Environment.  
Mehrere Kernsysteme wurden inzwischen von einfachen Platzhaltern zu klassifizierten State-Systemen weiterentwickelt und erfolgreich getestet.

Aktuell erfolgreich getestet:

- Framework-Ladung
- Theater-Command-Loader
- Main-Initialisierung
- Airbase Scanner
- Zone Factory
- Capture System
- Logistics Delivery
- Mission Generator
- AI CAP Manager

Das Projekt ist weiterhin **noch keine fertige spielbare dynamische Kampagne**.

Es fehlen noch:

- echte MOOSE-Spawns
- echte CTLD-Integration
- echte Skynet-IADS-Kampagnenlogik
- F10 UI
- Save/Load-Persistenz im DCS-Dateisystem
- AI Director für beidseitige Kampagnenentscheidungen
- vollständige Missionsauswertung über DCS-Events und Trigger

---

## Aktuelle Projektstruktur

Aktueller Hauptaufbau:

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

## Eigene Lua-Struktur

Eigene Theater-Command-Logik liegt unter:

```text
src/
```

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

Aktuell aktive Lua-Dateien:

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
```

Aktuell nur dokumentiert, aber noch nicht aktiv implementiert:

```text
src/iads/
src/ui/
src/debug/
```

---

## Externe Frameworks

Externe Frameworks liegen unter:

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

Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket.

Grund:

CTLD weist darauf hin, dass für korrektes dynamisches Spawning die mit CTLD gelieferte MIST-Version verwendet werden soll.

Framework-Regeln:

- Frameworks werden nicht verändert.
- Eigene Logik wird nicht in Framework-Dateien geschrieben.
- Eigene Lua-Logik gehört nach `src/`.
- Externe Frameworks gehören nach `vendor/`.

Nicht erwünscht:

```text
tc_moose.lua
tc_mist.lua
tc_ctld.lua
tc_all_in_one.lua
```

Eigene Logik wird nach Aufgaben sortiert, nicht nach Frameworks.

---

## DCS-Lade-Reihenfolge

Die externe Framework-Lade-Reihenfolge im DCS Mission Editor lautet:

1. `vendor/mist/mist.lua`
2. `vendor/moose/Moose.lua`
3. `vendor/ctld/CTLD-i18n.lua`
4. `vendor/ctld/CTLD.lua`
5. `vendor/skynet-iads/SkynetIADS.lua`

Danach folgt die eigene Theater-Command-Logik.

Aktuell wird noch die sichere Einzeldatei-Ladung verwendet.

Das bedeutet:

- alle aktiven eigenen Source-Dateien werden im Mission Editor einzeln per `DO SCRIPT FILE` geladen
- `src/main.lua` wird nach den Modulen geladen
- `src/loader.lua` wird zuletzt geladen

Diese Variante vermeidet aktuell eine harte Abhängigkeit von `dofile`.

---

## Wichtiger DCS-Hinweis

Eine per `DO SCRIPT FILE` geladene Lua-Datei wird in die `.miz` eingebettet.

Das bedeutet:

- GitHub Pull/Fetch aktualisiert nur die lokale Projektdatei
- die bereits gespeicherte `.miz` verwendet nicht automatisch den neuen Dateiinhalt
- nach einer Lua-Änderung muss die Datei im Mission Editor erneut in der passenden `DO SCRIPT FILE`-Aktion ausgewählt werden
- danach muss die Mission gespeichert werden
- DCS startet aus der `.miz`, nicht direkt aus GitHub

Aktuelle Arbeitsweise nach jeder Lua-Änderung:

1. Datei auf GitHub aktualisieren
2. lokal pullen/fetchen
3. im Mission Editor die geänderte Lua-Datei erneut auswählen
4. Mission speichern
5. Testlauf starten
6. `dcs.log` prüfen

---

## Getestete Source-Ladereihenfolge

Die getestete Trigger-Reihenfolge im DCS Mission Editor ist:

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
DO SCRIPT FILE: src/main.lua

TIME MORE 22
DO SCRIPT FILE: src/loader.lua
```

---

## Interne Theater-Command-Ladereihenfolge

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

Diese Bereiche besitzen aktuell nur README-Dateien und noch keine aktiven Lua-Module.

---

## Aktuelle DEV-Mission

Aktuelle technische Entwicklungsmission:

```text
Operation_Levant_Reclamation_DEV.miz
```

Bisheriger Inhalt:

- Map: Syria
- Koalitionspreset: Modern
- Blue Start: Akrotiri / Zypern
- erster blauer Client-Slot: F/A-18C Lot 20 auf Akrotiri
- Trigger: Starttest-Variante A vollständig angelegt
- keine rote Frontlinie
- keine IADS-Stellungen
- keine CTLD-Zonen
- keine Template-Gruppen
- keine F10-Menüs

Diese Mission dient aktuell als technischer Testträger.

Sie ist noch keine fertige spielbare Kampagnenmission.

---

## Erfolgreiche Tests

### Starttest Variante A

Status:

```text
bestanden
```

Bestätigt wurde:

- MIST wird geladen
- MOOSE wird geladen
- CTLD-i18n wird geladen
- CTLD wird geladen
- Skynet IADS wird geladen
- Theater Command Loader startet
- Frameworks werden durch den Loader erkannt
- Core wird geladen
- World wird geladen
- Campaign wird geladen
- Logistics wird geladen
- Missions wird geladen
- AI wird geladen
- Main wird gestartet
- Runtime-Systeme werden initialisiert
- Loader beendet sauber

---

### Airbase Scanner

Datei:

```text
src/world/tc_airbase_scanner.lua
```

Aktuelle getestete Version:

```text
v0.2.2
```

Status:

```text
bestanden
```

Letzter bestätigter Testwert:

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

- Akrotiri wird korrekt als `STRATEGIC_AIRFIELD` erkannt.
- Akrotiri erhält `strategicRelevance=100`.
- syrische Hauptflugplätze werden als potenzielle strategische Red-Basen vorbereitet.
- Medical Pads und einfache Helipads werden nicht mehr als strategische Kampagnenziele behandelt.

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

Status:

```text
bestanden
```

Letzter bestätigter Testwert:

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

Die Zone Factory arbeitet jetzt auf der Airbase-Klassifizierung und nicht mehr auf ungefilterten DCS-Rohobjekten.

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

Status:

```text
bestanden
```

Letzter bestätigter Testwert:

| Wert | Anzahl |
|---|---:|
| eligibleBases | 32 |
| eligibleZones | 32 |
| nonCaptureBases | 193 |
| nonCaptureZones | 14 |

Bewertung:

Capture wirkt nicht mehr auf 225 Rohobjekte, sondern nur noch auf sinnvolle strategische und sekundäre Kampagnenziele.

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

Status:

```text
bestanden
```

Letzter bestätigter Testwert:

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

Das Logistiksystem nutzt die gefilterten Kampagnenzonen.  
CTLD wird noch nicht aktiv angesprochen. Das ist aktuell korrekt, weil noch keine CTLD-Zonen und keine Template-Gruppen in der DEV-Mission definiert sind.

---

### Mission Generator

Datei:

```text
src/missions/tc_mission_generator.lua
```

Aktuelle getestete Version:

```text
v0.2.0
```

Status:

```text
bestanden
```

Letzter bestätigter Testwert:

| Wert | Anzahl |
|---|---:|
| mission candidates | 74 |
| generated missions | 10 |

Im Test erzeugte Missionstypen:

- `AIRBASE_ATTACK`
- `SEAD`
- `STRIKE`
- `CAP`

Bewertung:

Missionen werden nicht mehr generisch aus Rohobjekten erzeugt, sondern aus strategisch relevanten Kampagnenzonen.

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

Status:

```text
bestanden
```

Letzter bestätigter Testwert:

| Wert | Anzahl |
|---|---:|
| cap zone candidates | 31 |
| auto-registered CAP zones | 12 |
| CAP requests | 12 |

Weitere bestätigte Werte:

- reactionState: `AIR_REACTION_REQUESTED`
- threatLevel: `HIGH`

Im Test sichtbar:

- Blue CAP für Akrotiri
- Red CAP für strategische syrische Flugplätze

Bewertung:

Der AI CAP Manager bereitet Blue- und Red-CAP-State vor.  
Er spawnt noch keine echten Flugzeuge.  
`spawn=MOOSE_PENDING` ist aktuell erwartetes Verhalten.

---

## Aktuelle Kernsysteme

### Core

Zuständig für:

- zentrale Konfiguration
- Logging
- globalen State
- Hilfsfunktionen
- Scheduler-Grundfunktionen
- Start- und Systeminitialisierung

Aktuelle Dateien:

```text
src/core/tc_config.lua
src/core/tc_logger.lua
src/core/tc_state.lua
src/core/tc_utils.lua
src/core/tc_scheduler.lua
```

---

### World

Zuständig für:

- DCS-Airbase-Erfassung
- Airbase-Klassifizierung
- Airbase-Registrierung
- virtuelle Kampagnenzonen
- Verknüpfung von Basen, Zonen und späteren Missionszielen

Aktuelle Dateien:

```text
src/world/tc_airbase_scanner.lua
src/world/tc_zone_factory.lua
```

Aktueller Status:

- Airbase Scanner klassifiziert 225 Syria-Airbase-Objekte
- ZoneFactory erzeugt daraus 46 Kampagnenzonen

---

### Campaign

Zuständig für:

- Besitzstatus
- Capture-Zustände
- Kampagnenfortschritt
- In-Memory-Persistenz
- State-Snapshots
- spätere Save-/Load-Logik

Aktuelle Dateien:

```text
src/campaign/tc_capture_system.lua
src/campaign/tc_persistence_system.lua
```

Aktueller Status:

- Capture-System arbeitet auf 32 capture-fähigen Basen/Zonen
- Persistence-System lädt und startet
- praktischer DCS-Dateischreibtest ist noch offen

---

### Logistics

Zuständig für:

- Logistics Hubs
- Lieferungen
- Versorgungsstatus
- FOB-Aufbau
- spätere CTLD-Anbindung
- spätere logistische Auswirkungen auf Basen und Zonen

Aktuelle Dateien:

```text
src/logistics/tc_logistics_delivery.lua
src/logistics/tc_fob_system.lua
```

Aktueller Status:

- Logistics Delivery erzeugt 46 Hubs aus klassifizierten Zonen
- FOB System lädt und startet
- FOB System ist noch nicht an die neue Logistics-Hub-Struktur angepasst

---

### Missions

Zuständig für:

- Missionsarten
- Missionsstatus
- dynamische Missionsgenerierung
- spätere F10-Missionsauswahl
- spätere Verknüpfung mit Campaign, Logistics, AI und IADS

Aktuelle Datei:

```text
src/missions/tc_mission_generator.lua
```

Aktueller Status:

- Mission Generator erzeugt Missionen aus klassifizierten Kampagnenzonen
- 74 Kandidaten und 10 verfügbare Missionen wurden im Test bestätigt

---

### AI

Zuständig für:

- CAP-Anforderungen
- CAP-Status
- spätere MOOSE-Anbindung
- spätere GCI- und Counterattack-Logik
- späterer AI Director für beidseitige Operationen

Aktuelle Datei:

```text
src/ai/tc_ai_cap_manager.lua
```

Aktueller Status:

- CAP Manager erzeugt Blue- und Red-CAP-Anforderungen als State
- echte MOOSE-Spawns sind noch nicht aktiv

---

### IADS

Zuständig für spätere Theater-Command-Logik über Skynet IADS.

Aktueller Stand:

- Skynet IADS wird als Vendor geladen
- eigenes Theater-Command-IADS-Modul ist noch nicht aktiv implementiert

---

### UI

Zuständig für spätere Spielerinteraktion, Statusanzeigen und F10-Menüs.

Aktueller Stand:

- dokumentiert
- noch nicht aktiv implementiert

---

### Debug

Zuständig für spätere technische Kontrolle, Reports und Entwicklungswerkzeuge.

Aktueller Stand:

- Logging ist vorhanden
- eigenes Debug-System ist noch nicht aktiv implementiert

---

## Aktuelle Prioritäten

### 1. Dokumentation aktualisieren

Mehrere zentrale Systeme wurden erfolgreich getestet.  
Die Dokumentation muss diesen Stand vollständig abbilden, damit spätere Sessions zuverlässig auf GitHub nachlesen und richtige Entscheidungen treffen können.

Bereits aktualisiert:

- `TASKS.md`
- `CHANGELOG.md`

Jetzt zu aktualisieren:

- `README.md`
- `ROADMAP.md`
- `ARCHITECTURE.md`

Danach:

- `docs/04_airbase_system.md`
- `docs/05_logistics_system.md`
- `docs/06_mission_generator.md`
- `docs/07_ai_director.md`
- `docs/10_testing.md`
- ggf. `src/README.md`

---

### 2. FOB System an Logistics anbinden

Wahrscheinlicher nächster Code-Schritt:

```text
src/logistics/tc_fob_system.lua
```

Ziel:

- FOB-System soll die neuen Logistics Hubs nutzen
- FOB-Kandidaten sollen aus geeigneten Blue-/Contested-Zonen entstehen
- FOB-Support-Missionen sollen sinnvoller werden
- FOB-Bauzustand soll später mit CTLD gekoppelt werden können

---

### 3. F10 UI vorbereiten

Ziel:

- Spieler kann Missionen sehen
- Spieler kann Mission auswählen
- Spieler kann Kampagnenstatus abrufen
- Debug-Menü kann separat vorbereitet werden

---

### 4. Persistence praktisch testen

Ziel:

- Kampagnenstand speichern
- Kampagnenstand laden
- DCS-Sandbox real prüfen

---

### 5. AI Director vorbereiten

Ziel:

- beidseitige Kampagnenlogik
- Blue und Red handeln unabhängig vom Spieler
- Spieler ist Teilnehmer, nicht alleiniger Motor

---

### 6. Echte Framework-Integration

Später:

- MOOSE für CAP, Strike, SEAD und AI-Flüge
- CTLD für Cargo, FOB und Logistik
- Skynet IADS für Luftverteidigung
- MIST nur dort nutzen, wo es sinnvoll ist

Noch nicht sofort:

- echte MOOSE-Spawns ohne Mission-Editor-Templates
- echte CTLD-Integration ohne CTLD-Zonen
- IADS-Kampagnenlogik ohne eigene IADS-Struktur

---

## Aktueller nächster Schritt

Nächste konkrete Datei nach dieser README:

```text
ROADMAP.md
```

Ziel:

Die Roadmap muss den aktuellen Stand abbilden:

- Airbase-Klassifizierung erledigt
- ZoneFactory-Filterung erledigt
- Capture-Filterung erledigt
- Logistics Hubs erledigt
- Mission Generator v0.2.0 getestet
- AI CAP Manager v0.2.0 getestet
- offene nächste Entwicklungsphasen neu sortieren

Danach:

- `ARCHITECTURE.md`
- relevante Systemdokumente in `docs/`
- anschließend nächster Code-Schritt, voraussichtlich `src/logistics/tc_fob_system.lua`

---

## Aktueller Status

Diese Version ist noch keine spielbare dynamische DCS-Kampagne.

Der technische Grundaufbau ist aber erfolgreich im DCS Mission Scripting Environment gestartet.  
Die wichtigsten ersten State-Systeme arbeiten inzwischen auf gefilterten, klassifizierten Kampagnendaten statt auf ungefilterten DCS-Rohobjekten.

Aktuell gilt:

- Airbase-Erkennung funktioniert
- Zonenfilterung funktioniert
- Capture-Eligibility funktioniert
- Logistics-Hub-Erzeugung funktioniert
- Missionsgenerierung funktioniert
- AI-CAP-State funktioniert
- echte DCS-KI-Ausführung ist noch offen
- echte Spielerinteraktion über F10 ist noch offen
- echte Persistenz ist noch offen
