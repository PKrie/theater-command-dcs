# Theater Command DCS

**Theater Command DCS** ist ein modulares, dynamisches und später persistentes DCS-World-Kampagnensystem.

Die erste Kampagne trägt den Arbeitstitel:

**Operation Levant Reclamation**

Das Projekt wird auf der **Syria Map** aufgebaut.

Ausgangslage:

- Blue startet auf **Akrotiri / Zypern**
- Das syrische Festland ist zu Beginn rot kontrolliert
- Blue muss sich vom Brückenkopf Zypern aus auf das syrische Festland vorarbeiten
- Spieler sollen sich mit Client-Flugzeugen in eine laufende Kampagnenlage einklinken

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
- Spielerinteraktion über F10-Menüs
- Debug-Werkzeuge
- Persistenz

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
- FOBs werden aus Logistics Hubs geplant
- Missionen inklusive FOB-Support werden erzeugt
- erste F10-Spieleroberfläche ist aktiv
- echte KI-Ausführung ist noch nicht implementiert
- ein vollständiger AI Director für beidseitige Operationen ist noch offen

---

## Aktueller Projektstand

Stand: **2026-06-16**

Aktueller Status:

Die Projektbasis ist angelegt.  
Die Vendor-Frameworks sind eingebunden.  
Die sichere DCS-Ladevariante wurde erfolgreich getestet.  
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
- FOB System
- Mission Generator
- AI CAP Manager
- F10 Menu

Das Projekt ist weiterhin **noch keine fertige spielbare dynamische Kampagne**.

Es fehlen noch:

- echte MOOSE-Spawns
- echte CTLD-Integration
- echte Skynet-IADS-Kampagnenlogik
- Save/Load-Persistenz im DCS-Dateisystem
- AI Director für beidseitige Kampagnenentscheidungen
- direkte Missionsauswahl 1 bis 10 über F10
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
src/ui/tc_f10_menu.lua
```

Aktuell nur dokumentiert, aber noch nicht aktiv implementiert:

```text
src/iads/
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

Für saubere Logtests:

1. DCS beenden
2. `Saved Games\DCS.openbeta\Logs\dcs.log` löschen oder umbenennen
3. DCS neu starten
4. Mission testen
5. DCS beenden
6. frische `dcs.log` hochladen

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
DO SCRIPT FILE: src/ui/tc_f10_menu.lua

TIME MORE 21
DO SCRIPT FILE: src/main.lua

TIME MORE 23
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
- Theater-Command-F10-Menü sichtbar und navigierbar
- keine rote Frontlinie
- keine IADS-Stellungen
- keine CTLD-Zonen
- keine Template-Gruppen

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
- UI wird geladen
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

Die Zone Factory arbeitet auf der Airbase-Klassifizierung und nicht mehr auf ungefilterten DCS-Rohobjekten.

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

### FOB System

Datei:

```text
src/logistics/tc_fob_system.lua
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
| FOB candidates | 6 |
| stored candidates | 6 |
| auto-planned FOBs | 2 |
| skipped candidates | 4 |
| Blue FOBs | 2 |

Erzeugte FOBs:

- `FOB Ercan`
- `FOB Gecitkale`

Status:

- `UNDER_CONSTRUCTION`

Bewertung:

FOB System nutzt jetzt die Logistics-Hub-Struktur.  
Es erzeugt State-only-FOBs, aber noch keine echten CTLD-FOBs.

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

Status:

```text
bestanden
```

Letzter bestätigter Testwert:

| Wert | Anzahl |
|---|---:|
| mission candidates | 69 |
| fobSupportCandidates | 2 |
| generated missions | 10 |
| reservedCreated | 1 |
| duplicatesSkipped | 1 |
| typeLimitSkipped | 30 |

Bestätigte FOB-Support-Missionen:

- `FOB_SUPPORT` für `FOB Ercan`
- `FOB_SUPPORT` für `FOB Gecitkale`

Im Test erzeugte Missionstypen:

- `FOB_SUPPORT`
- `AIRBASE_ATTACK`
- `SEAD`
- `STRIKE`
- `CAP`

Bewertung:

Missionen werden aus strategisch relevanten Kampagnenzonen und aus FOB-Bedarf erzeugt.  
FOB-Support wird nicht mehr aus der Missionsliste verdrängt.

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

### F10 Menu

Datei:

```text
src/ui/tc_f10_menu.lua
```

Aktuelle getestete Version:

```text
v0.1.0
```

Status:

```text
bestanden
```

Bestätigter Testwert:

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

Bestätigte Logmarker:

```text
[TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.1.0
[TC] [F10Menu] F10 menu started
[TC] [F10Menu] F10 menu initialized: commands=7
[TC] System started: F10 Menu
```

Bewertung:

Die erste spielerseitige Bedienoberfläche funktioniert.  
Direkte Missionsauswahl 1 bis 10 ist noch offen.

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
- FOB System erzeugt 6 Kandidaten
- FOB System plant 2 Blue-FOBs
- echte CTLD-FOBs sind noch offen

---

### Missions

Zuständig für:

- Missionsarten
- Missionsstatus
- dynamische Missionsgenerierung
- F10-Missionsanzeige
- spätere Verknüpfung mit Campaign, Logistics, AI und IADS

Aktuelle Datei:

```text
src/missions/tc_mission_generator.lua
```

Aktueller Status:

- Mission Generator erzeugt Missionen aus klassifizierten Kampagnenzonen
- Mission Generator erzeugt FOB-Support-Missionen
- 69 Kandidaten und 10 verfügbare Missionen wurden im letzten Test bestätigt

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

### UI

Zuständig für Spielerinteraktion, Statusanzeigen und F10-Menüs.

Aktuelle Datei:

```text
src/ui/tc_f10_menu.lua
```

Aktueller Status:

- F10 Menu ist sichtbar
- F10 Menu ist navigierbar
- verfügbare Missionen können angezeigt werden
- aktive Missionen können angezeigt werden
- Top-Mission kann aktiviert werden
- Statusseiten für Campaign, Logistics, FOB und AI sind vorhanden

Noch offen:

- direkte Missionsauswahl 1 bis 10
- Missionsdetails pro Mission
- Mission completed/failed über F10 oder Debug
- Debug-Menü getrennt von Spieler-Menü

---

### IADS

Zuständig für spätere Theater-Command-Logik über Skynet IADS.

Aktueller Stand:

- Skynet IADS wird als Vendor geladen
- eigenes Theater-Command-IADS-Modul ist noch nicht aktiv implementiert

---

### Debug

Zuständig für spätere technische Kontrolle, Reports und Entwicklungswerkzeuge.

Aktueller Stand:

- Logging ist vorhanden
- eigenes Debug-System ist noch nicht aktiv implementiert

---

## Aktuelle Prioritäten

### 1. F10-Menü ausbauen

Wahrscheinlicher nächster Code-Schritt:

```text
src/ui/tc_f10_menu.lua
```

Ziel:

- nicht nur Top-Mission aktivieren
- Mission 1 bis Mission 10 direkt auswählbar machen
- Missionsdetails über F10 anzeigen
- verfügbare Missionen stabil sortieren
- weiterhin state-only bleiben
- noch keine echten MOOSE-/CTLD-Spawns auslösen

---

### 2. Missionserfolg und Missionsstatus vorbereiten

Ziel:

- aktive Missionen sinnvoll verwalten
- Missionen abschließen oder fehlschlagen lassen
- erste manuelle Debug-/F10-Funktion für Mission completed/failed vorbereiten
- später DCS-Events und Trigger koppeln

---

### 3. Persistence praktisch testen

Ziel:

- Kampagnenstand speichern
- Kampagnenstand laden
- DCS-Sandbox real prüfen

---

### 4. CTLD-Integration vorbereiten

Ziel:

- CTLD-Pickup-Zonen im Mission Editor anlegen
- Dropoff-/FOB-Zonen definieren
- CTLD-Cargo später mit Logistics Delivery und FobSystem koppeln

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

## Dokumentationsstand

Zentrale Dokumentation wurde am Ende der Session aktualisiert bzw. teilweise aktualisiert:

- `TASKS.md`
- `CHANGELOG.md`
- `README.md`
- `ROADMAP.md`
- `ARCHITECTURE.md`

Wichtig:

Während aktiver Code-Arbeit soll nur die absolut notwendige Dokumentation aktualisiert werden.  
Größere Dokumentationsrunden sollen bevorzugt am Ende einer Session erfolgen.

Noch später nachzuziehen:

- relevante Systemdokumente in `docs/`
- `src/ui/README.md`
- `src/logistics/README.md`
- `src/missions/README.md`
- `src/README.md`

---

## Aktueller nächster Schritt

Empfohlene nächste Datei:

```text
src/ui/tc_f10_menu.lua
```

Empfohlenes Ziel:

- F10-Menü von „Activate Top Mission“ auf direkte Missionsauswahl erweitern
- Mission 1 bis Mission 10 direkt auswählbar machen
- Missionsdetails über F10 anzeigen
- verfügbare Missionen stabil sortieren
- weiter state-only bleiben
- keine echten MOOSE-/CTLD-Spawns auslösen

Danach mögliche Folgeschritte:

1. Mission completed/failed über F10 oder Debug vorbereiten
2. Missionseffekte auf State anwenden
3. Persistence-Sandbox-Test vorbereiten
4. CTLD-Zonen im Mission Editor vorbereiten
5. AI Director state-only beginnen

---

## Aktueller Status

Diese Version ist noch keine spielbare dynamische DCS-Kampagne.

Der technische Grundaufbau ist aber erfolgreich im DCS Mission Scripting Environment gestartet.  
Die wichtigsten ersten State-Systeme arbeiten inzwischen auf gefilterten, klassifizierten Kampagnendaten statt auf ungefilterten DCS-Rohobjekten.

Aktuell funktioniert:

- Airbase-Erkennung
- Airbase-Klassifizierung
- Zonenfilterung
- Capture-Eligibility
- Logistics-Hub-Erzeugung
- FOB-Kandidaten und State-only-FOBs
- Missionsgenerierung inklusive FOB-Support
- AI-CAP-State
- F10-Menü mit Status- und Missionsanzeige

Noch offen:

- echte DCS-KI-Ausführung
- echte CTLD-Logistik
- echte IADS-Kampagnenlogik
- direkte Missionsauswahl über F10
- echte Missionsauswertung
- echte Persistenz
- AI Director
