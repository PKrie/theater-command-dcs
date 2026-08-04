# Lua Styleguide

Diese Datei beschreibt die Lua-Programmierregeln für **Theater Command DCS**.

Ziel ist eine einheitliche, lesbare und wartbare Lua-Struktur für ein dynamisches DCS-Kampagnensystem.

Erste Kampagne:

- **Operation Levant Reclamation**

Map:

- **Syria**

Ausgangslage:

- Blue startet auf **Akrotiri / Zypern**
- das syrische Festland ist zu Beginn rot kontrolliert
- Red hält zu Beginn den Großteil der strategischen Flugplätze
- Blue soll sich vom Brückenkopf Zypern aus auf das syrische Festland vorarbeiten
- Spieler sollen sich in eine laufende Kampagne einklinken, nicht jede Aktion allein auslösen
- Blue und Red sollen später eigene Operationen durchführen

---

## 1. Grundsatz

Theater Command DCS wird modular entwickelt.

Jede Datei hat eine klare Aufgabe.

Nicht gewünscht:

- All-in-one-Dateien
- große Framework-Sammeldateien
- unnötige globale Variablen
- vermischte Framework- und Kampagnenlogik
- produktive DCS-Aktionen ohne vorher stabilen State-Test
- große parallele Umbauten ohne Einzeltest

Grundprinzip:

- **Mission Editor = Bühne**
- **Lua = Kampagnensystem**
- **GitHub = Projektgedächtnis**

Der Mission Editor lädt die Bühne und die Dateien.

Lua erzeugt den Kampagnenzustand.

GitHub dokumentiert Architektur, Aufgaben, Teststände und Übergaben.

---

## 2. Aktueller technischer Stand

Stand: **2026-08-04**

Aktuell vorhanden und aktiv:

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
- `src/ui/tc_f10_menu.lua`

Vorbereitet, aber noch nicht produktiv implementiert:

- `src/iads/`
- `src/debug/`

Aktuelle getestete Systeme:

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | dirty-aware Embedded-Scheduler bestanden |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | historische Pfade bestanden; aktueller Record-Verlust ungelöst |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden, 33 Commands |

---

## 3. Externe Frameworks

Externe Frameworks liegen unter:

- `vendor/`

Aktive Vendor-Dateien:

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD-i18n | `vendor/ctld/CTLD-i18n.lua` | geladen |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Regeln:

- Vendor-Dateien werden nicht verändert.
- Eigene Theater-Command-Logik wird nicht in Framework-Dateien geschrieben.
- Frameworks sind Werkzeuge.
- Die eigene Dateistruktur richtet sich nach Aufgaben, nicht nach Frameworks.

Nicht erstellen:

- `src/tc_moose.lua`
- `src/tc_mist.lua`
- `src/tc_ctld.lua`
- `src/tc_skynet.lua`
- `src/tc_all_in_one.lua`
- `src/tc_iads_all_in_one.lua`

---

## 4. Aktuelle Lade-Reihenfolge

Aktuell wird die sichere Einzeldatei-Ladung über `DO SCRIPT FILE` verwendet.

Vendor-Ladefolge:

1. `vendor/mist/mist.lua`
2. `vendor/moose/Moose.lua`
3. `vendor/ctld/CTLD-i18n.lua`
4. `vendor/ctld/CTLD.lua`
5. `vendor/skynet-iads/SkynetIADS.lua`

Theater-Command-Ladefolge:

1. `src/core/tc_config.lua`
2. `src/core/tc_logger.lua`
3. `src/core/tc_state.lua`
4. `src/core/tc_utils.lua`
5. `src/core/tc_scheduler.lua`
6. `src/world/tc_airbase_scanner.lua`
7. `src/world/tc_zone_factory.lua`
8. `src/campaign/tc_capture_system.lua`
9. `src/campaign/tc_persistence_system.lua`
10. `src/logistics/tc_logistics_delivery.lua`
11. `src/logistics/tc_fob_system.lua`
12. `src/missions/tc_mission_generator.lua`
13. `src/ai/tc_ai_cap_manager.lua`
14. `src/ui/tc_f10_menu.lua`
15. `src/main.lua`
16. `src/loader.lua`

Wichtig:

- MIST muss vor CTLD geladen werden.
- `CTLD-i18n.lua` muss vor `CTLD.lua` geladen werden.
- eigene Theater-Command-Dateien starten erst nach den Vendor-Dateien.
- `tc_f10_menu.lua` wird vor `main.lua` geladen.
- `loader.lua` bleibt aktuell die letzte eigene Datei.
- Loader-only per `dofile` ist noch nicht produktiv getestet.

---

## 5. Eigene Lua-Struktur

Eigene Lua-Dateien liegen unter:

- `src/`

Aktuelle Struktur:

```text
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
│   ├── README.md
│   └── tc_f10_menu.lua
└── debug/
    └── README.md
```

Regel:

- Struktur nach Aufgaben.
- Nicht nach Frameworks.
- Ein Modul soll genau einen fachlichen Bereich verantworten.

---

## 6. Dateinamen

Eigene Lua-Dateien beginnen mit:

```text
tc_
```

Schreibweise:

```text
kleinbuchstaben_mit_unterstrich.lua
```

Beispiele:

```text
tc_config.lua
tc_logger.lua
tc_state.lua
tc_airbase_scanner.lua
tc_zone_factory.lua
tc_capture_system.lua
tc_logistics_delivery.lua
tc_fob_system.lua
tc_mission_generator.lua
tc_ai_cap_manager.lua
tc_persistence_system.lua
tc_f10_menu.lua
```

Dateinamen richten sich nach der Aufgabe.

Nicht nach dem verwendeten Framework.

Beispiel:

- richtig: `tc_ai_cap_manager.lua`
- falsch: `tc_moose_cap.lua`

---

## 7. Globale Projekttabelle

Die eigene Projektlogik nutzt die globale Projekttabelle:

```lua
TC
```

Nicht verwenden:

```lua
TheaterCommand
theaterCommand
tc_global
_G_TC
```

Aktuelle Grundidee:

```lua
TC = TC or {}
TC.modules = TC.modules or {}
TC.State = TC.State or {}
TC.state = TC.state or TC.State
```

Regeln:

- Nur `TC` ist als eigene globale Projektstruktur vorgesehen.
- Eigene Einzel-Globals sind zu vermeiden.
- Framework-Globals wie `mist`, `ctld`, `BASE` oder `SkynetIADS` werden nicht überschrieben.
- Neue Module registrieren sich unter einer fachlich passenden `TC`-Struktur.

Beispiele:

```lua
TC.Campaign = TC.Campaign or {}
TC.Campaign.CaptureSystem = CaptureSystem

TC.Missions = TC.Missions or {}
TC.Missions.Generator = MissionGenerator

TC.UI = TC.UI or {}
TC.UI.F10Menu = F10Menu
```

---

## 8. Globale Variablen

Globale Einzelvariablen sollen vermieden werden.

Nicht:

```lua
campaignState = {}
debugMode = true
airbaseList = {}
```

Stattdessen:

```lua
TC.State.Campaign = TC.State.Campaign or {}
TC.State.Debug = TC.State.Debug or {}
TC.State.Bases = TC.State.Bases or {}
```

Lokale Hilfsfunktionen sollen lokal bleiben:

```lua
local function getState()
  return TC.State or TC.state
end
```

Lokale Konstanten oder Tabellen sind erlaubt, wenn sie zur Datei gehören:

```lua
local CaptureSystem = {}
local DEFAULT_CAPTURE_THRESHOLD = 100
```

---

## 9. Modulstruktur

Jede eigene Datei soll eine klare Modulstruktur besitzen.

Empfohlene Grundform:

```lua
TC = TC or {}
TC.modules = TC.modules or {}

local ModuleName = {}

ModuleName.name = "tc_module_name"
ModuleName.version = "0.1.0"
ModuleName.loaded = true
ModuleName.started = false
ModuleName.failed = false

function ModuleName.start()
  return true
end

function ModuleName.summary()
  return {
    name = ModuleName.name,
    version = ModuleName.version,
    loaded = ModuleName.loaded,
    started = ModuleName.started,
    failed = ModuleName.failed
  }
end

TC.modules.moduleName = {
  name = ModuleName.name,
  loaded = true,
  version = ModuleName.version
}

return ModuleName
```

Regeln:

- Modulname und Dateiname müssen fachlich zusammenpassen.
- Version in der Datei aktualisieren, wenn Verhalten geändert wird.
- `loaded`, `started`, `finished` und `failed` nach Möglichkeit konsistent führen.
- `summary()` soll für Debug und F10 nutzbar sein.
- Module sollen keine stillen Seiteneffekte außerhalb ihrer Aufgabe erzeugen.

---

## 10. Startfunktionen

Module, die zur Runtime gehören, sollen eine `start()`-Funktion besitzen.

Beispiel:

```lua
function CaptureSystem.start()
  CaptureSystem.started = true
  CaptureSystem.failed = false

  local state = ensureCampaignTables()
  if state == nil then
    CaptureSystem.failed = true
    return false
  end

  return true
end
```

Regeln:

- `start()` soll mehrfach aufrufbar sein, ohne den State unkontrolliert zu zerstören.
- `start()` soll klare Fehler zurückgeben.
- `start()` soll nicht unnötig echte DCS-Aktionen auslösen.
- produktive Framework-Aktionen erst nach klarer Aktivierung.

---

## 11. Summary-Funktionen

Jedes größere Modul soll eine `summary()`-Funktion bereitstellen.

Ziel:

- Debug
- F10-Status
- Logauswertung
- spätere Persistenzprüfung
- Session-Übergabe

Beispiel:

```lua
function MissionGenerator.summary()
  return {
    name = MissionGenerator.name,
    version = MissionGenerator.version,
    missionCount = countTableKeys(MissionGenerator.availableMissions),
    activeCount = countTableKeys(MissionGenerator.activeMissions)
  }
end
```

Regeln:

- keine riesigen Tabellen ungefiltert ausgeben, wenn es nicht nötig ist
- wichtige Zähler immer aufnehmen
- Version aufnehmen
- Fehlerstatus aufnehmen
- State-only-Kennzeichnung aufnehmen, wenn relevant

---

## 12. Funktionsnamen

Funktionsnamen sollen klar und sprechend sein.

Empfohlene Schreibweise:

```text
camelCase
```

Beispiele:

```lua
scanAirbases()
createZones()
updateCaptureProgress()
applyMissionEffect()
generateMissions()
activateMission()
completeMission()
showCaptureStatus()
```

Interne Hilfsfunktionen können lokal sein:

```lua
local function getState()
end

local function normalizeName(value)
end

local function countTableKeys(targetTable)
end
```

Nicht verwenden:

```lua
doStuff()
handleIt()
runAll()
process()
```

Außer der fachliche Kontext macht die Kurzform eindeutig.

---

## 13. Tabellen und Records

Tabellen sollen klar strukturiert und fachlich benannt sein.

Gut:

```lua
local missionRecord = {
  key = "MISSION_2",
  type = "AIRBASE_ATTACK",
  status = "ACTIVE",
  targetZoneKey = "ZONE_AIRBASE_ABU_AL_DUHUR",
  stateOnly = true
}
```

Schlecht:

```lua
local m = {
  k = "MISSION_2",
  t = "AIRBASE_ATTACK"
}
```

Regeln:

- keine unnötigen Kurzbezeichnungen
- Felder sprechend benennen
- wichtige Keys stabil halten
- Tabellen so bauen, dass sie später persistierbar sind
- keine Funktionen in Persistenzdaten speichern
- keine Userdata in Persistenzdaten speichern

---

## 14. State-first-Regel

Aktuell ist Theater Command DCS bewusst eine **State-first Runtime**.

Das bedeutet:

- Module erzeugen zuerst State.
- State wird über Logs und F10 sichtbar gemacht.
- produktive DCS-Aktionen kommen später.
- Framework-Hooks werden vorbereitet, aber nicht automatisch ausgeführt.
- jede neue Kampagnenfolge muss zuerst state-only testbar sein.

Aktuell bestätigte Pipeline:

```text
F10 Mission Selection
Mission Activation
Mission Completion
Mission Effect Preparation
CaptureSystem Effect Processing
Capture Pressure Update
Capture Progress Update
Capture Ready Detection
F10 Capture Ready Visibility
```

Regel:

Ein neues System soll zuerst:

1. State erzeugen
2. State loggen
3. State über F10 oder Debug sichtbar machen
4. State im DCS-Test bestätigen
5. erst danach echte Framework-Aktionen auslösen

---

## 15. Ownership und Capture

CaptureSystem ist aktuell state-only.

Regeln:

- Capture Pressure darf erzeugt werden.
- Capture Progress darf aktualisiert werden.
- Capture Ready darf entstehen.
- Capture Ready darf über F10 angezeigt werden.
- produktiver Ownership-Wechsel darf nicht automatisch ohne kontrollierten Testpfad erfolgen.
- Ownership-Wechsel müssen eindeutig geloggt werden.
- Linked Airbase/Zone Ownership muss bewusst synchronisiert werden.
- Capture Pressure muss nach Ownership-Wechsel sauber zurückgesetzt oder markiert werden.

Aktueller bestätigter Wert:

```text
MISSION_2 -> ZONE_AIRBASE_ABU_AL_DUHUR -> BLUE pressure 105 -> progress 100% -> ready=1
```

Nächster empfohlener Capture-Schritt:

```text
Apply Capture Ready Zone 1
```

Dieser Schritt soll weiterhin state-only bleiben.

---

## 16. Missionen

MissionGenerator ist aktuell state-only.

Mission-Status-Collections sind Dictionaries mit String-Keys wie `MISSION_1`:

```lua
TC.State.Missions.available[missionKey] = missionRecord
```

Verbindliche Zählregel:

- `pairs()` oder eine Hilfsfunktion wie `countTableKeys()` für `available`, `active`, `completed`, `failed`, `expired` und `cancelled`
- `#` und `ipairs()` dürfen nicht als autoritative Counts für diese Dictionaries verwendet werden
- `#` und `ipairs()` bleiben korrekt für echte Arrays, zum Beispiel Histories und sortierte temporäre UI-Listen

Ein Runtime-Report muss Dictionary- und Array-Semantik explizit unterscheiden. Die aktuelle `State.summary()`-Ausgabe verwendet für aktive und abgeschlossene Mission-Dictionaries noch `#` und ist deshalb für diese Counts nicht autoritativ; diese Dokumentationsfeststellung autorisiert keinen Code-Fix.

Regeln:

- Missionen werden aus Kampagnenlage erzeugt.
- Missionen haben stabile Keys.
- Missionen enthalten Objectives.
- Missionen enthalten Briefings.
- Missionen enthalten Progress-Daten.
- Missionen enthalten Activation Metadata.
- Missionen enthalten Outcome State.
- Missionen enthalten Effect State.
- Missionen enthalten reservierte Execution Hooks.
- Aktivierung löst noch keine echten Spawns aus.
- Completion bereitet Effects vor.
- Effects werden erst durch Empfängersysteme verarbeitet.

Aktuelle getestete Version:

```text
src/missions/tc_mission_generator.lua v0.2.3
```

Bestätigte Werte:

```text
mission candidates = 78
generated missions = 10
fobSupportCandidates = 2
reservedCreated = 1
duplicatesSkipped = 1
typeLimitSkipped = 68
```

---

## 17. F10-Menü

F10Menu ist aktuell das wichtigste Test- und Sichtbarkeitsinstrument.

Regeln:

- F10 liest State.
- F10 ruft sichere State-Funktionen auf.
- F10 triggert keine echten MOOSE-Spawns.
- F10 triggert keine echten CTLD-Aktionen.
- F10 triggert keine echten Skynet-Aktionen.
- F10-Commands müssen geloggt werden.
- Neue F10-Funktionen sollen klein und testbar bleiben.

Aktuelle getestete Version:

```text
src/ui/tc_f10_menu.lua v0.2.2
```

Bestätigte Werte:

```text
commands = 32
```

Aktuell bestätigt:

- Missionen anzeigen
- Mission Details anzeigen
- Missionen aktivieren
- Active Mission Outcome Status anzeigen
- Active Mission 1 auf `COMPLETED` setzen
- Capture Status anzeigen
- Capture Ready Zones anzeigen
- Pressure Contested Zones anzeigen
- Logistics Status anzeigen
- FOB Status anzeigen
- AI CAP Status anzeigen

---

## 18. Logging

Log-Ausgaben laufen möglichst über den eigenen Logger.

Einheitlicher Prefix:

```text
[TC]
```

Beispiele:

```text
[TC] [CaptureSystem] Loaded src/campaign/tc_capture_system.lua v0.2.2
[TC] [MissionGenerator] Mission outcome prepared: MISSION_2 [COMPLETED] stateOnly=true effects=prepared
[TC] [F10Menu] F10 menu initialized: commands=32
```

Fehler:

```text
[TC][ERROR]
[TC] [ERROR]
```

Warnungen:

```text
[TC][WARN]
[TC] [WARN]
```

Regeln:

- wichtige Versionsmarker loggen
- wichtige State-Übergänge loggen
- Mission Activation loggen
- Mission Outcome loggen
- Capture Pressure Updates loggen
- F10-Aktionen loggen
- echte Framework-Aktionen später besonders klar loggen

---

## 19. Fehlerbehandlung

Fehler sollen sichtbar und nachvollziehbar sein.

Wichtige Suchbegriffe im `dcs.log`:

```text
SCRIPTING ERROR
Mission script error
stack traceback
attempt to
nil value
[TC][ERROR]
[TC] [ERROR]
cannot open
```

Regeln:

- Fehler nicht still ignorieren.
- Wenn ein Modul nicht starten kann, muss es `failed=true` setzen.
- Fehlergrund soll im Log stehen.
- Rückgabewerte sollen `true/false` plus Grund liefern, wenn sinnvoll.
- Runtime darf bei nichtkritischen State-Problemen möglichst weiterlaufen, aber klar warnen.
- produktive Aktionen dürfen bei unsicherem State nicht ausgeführt werden.

Beispiel:

```lua
if state == nil then
  CaptureSystem.failed = true
  logError("Capture system failed: state_unavailable")
  return false, "state_unavailable"
end
```

---

## 20. Framework-Prüfung

Frameworks werden durch Main/Loader geprüft.

Wichtige Globals:

```lua
mist
BASE
ctld
SkynetIADS
```

Regeln:

- Framework-Verfügbarkeit prüfen.
- fehlende Frameworks klar loggen.
- keine Vendor-Dateien patchen.
- keine eigenen Globals mit Framework-Namen überschreiben.
- Framework-Ausführung nur über eigene Fachmodule vorbereiten.

---

## 21. Loader-Regeln

`src/loader.lua` ist aktuell die letzte eigene Datei in der Einzeldatei-Ladefolge.

Aufgaben:

- Framework-Verfügbarkeit prüfen
- Theater-Command-Umgebung prüfen
- Main-Status prüfen
- Startstatus ausgeben
- sauberes Ende loggen

Nicht in `loader.lua`:

- Airbase-Capture berechnen
- Missionen erzeugen
- CTLD-Lieferungen bewerten
- IADS-Netzwerke taktisch steuern
- Persistenz vollständig umsetzen
- F10-Menü bauen

Loader-only per `dofile` ist später möglich, aber noch nicht praktisch getestet.

---

## 22. Main-Regeln

`src/main.lua` ist der Runtime-Startpunkt.

Aufgaben:

- Runtime-Systeme initialisieren
- Systemstart koordinieren
- Modulstatus prüfen
- zentrale Startlogs erzeugen
- F10Menu starten

Nicht in `main.lua`:

- detaillierte Capture-Logik
- detaillierte Mission-Generierung
- detaillierte CTLD-Logik
- detaillierte IADS-Logik
- große Debugreports

`main.lua` verbindet Systeme.

`main.lua` ersetzt keine Einzelsysteme.

---

## 23. Core-Regeln

Der Ordner `src/core/` enthält nur Grundfunktionen.

Aktive Dateien:

- `tc_config.lua`
- `tc_logger.lua`
- `tc_state.lua`
- `tc_utils.lua`
- `tc_scheduler.lua`

Core soll möglichst stabil und klein bleiben.

Nicht in Core:

- Capture-Logik
- Missionsgenerator
- IADS-Sektorlogik
- FOB-System
- spezifische Airbase-Listen
- konkrete F10-Menüs
- CTLD-Produktivlogik

---

## 24. World-Regeln

Der Ordner `src/world/` enthält Welt- und Kartenlogik.

Aktive Dateien:

- `tc_airbase_scanner.lua`
- `tc_zone_factory.lua`

World erkennt und strukturiert die DCS-Welt.

World entscheidet nicht allein über Kampagnenfortschritt.

World soll liefern:

- klassifizierte Airbase-Daten
- Kampagnenzonen
- Kandidaten für Capture, Missions, Logistics und AI

---

## 25. Campaign-Regeln

Der Ordner `src/campaign/` enthält strategischen Kampagnenzustand.

Aktive Dateien:

- `tc_capture_system.lua`
- `tc_persistence_system.lua`

Campaign entscheidet über:

- Besitzstatus
- Capture-Status
- Capture Pressure
- Capture Progress
- Kampagnenfortschritt
- später Persistenz

Regel:

- Capture Ready erzeugt nicht automatisch einen produktiven Besitzwechsel.
- Ownership-Wechsel brauchen einen bewussten Testpfad.

---

## 26. Logistics-Regeln

Der Ordner `src/logistics/` verbindet später CTLD mit Theater Command DCS.

Aktive Dateien:

- `tc_logistics_delivery.lua`
- `tc_fob_system.lua`

Grundsatz:

- CTLD führt später aus.
- Theater Command bewertet.
- `CTLD.lua` wird nicht geändert.
- Eigene Logistiklogik gehört nach `src/logistics/`.

Aktuell:

- Logistics ist state-only.
- FOBs sind state-only.
- CTLD-Hooks sind vorbereitet, aber nicht aktiv.

---

## 27. Missions-Regeln

Der Ordner `src/missions/` erzeugt dynamische Missionen.

Aktive Datei:

- `tc_mission_generator.lua`

Regeln:

- Missionen entstehen aus Kampagnenzustand.
- Missionen werden nicht als feste Triggerketten gebaut.
- Mission Activation bleibt aktuell state-only.
- Mission Completion bereitet Effects vor.
- Mission Effects werden an Fachsysteme übergeben.
- echte Spawns kommen später.

---

## 28. AI-Regeln

Der Ordner `src/ai/` enthält KI-bezogene Kampagnenlogik.

Aktive Datei:

- `tc_ai_cap_manager.lua`

Geplante Datei:

- `tc_ai_director.lua`

Aktuell:

- AI CAP Manager erzeugt State.
- MOOSE CAP ist noch nicht aktiv.
- `spawn=MOOSE_PENDING` ist erwartetes Verhalten.

Später:

- AI Director entscheidet kampagnenlogisch.
- MOOSE stellt technische AI-Funktionen bereit.
- Theater Command entscheidet strategisch.

---

## 29. IADS-Regeln

Der Ordner `src/iads/` verbindet später Skynet IADS mit Theater Command DCS.

Geplante Datei:

- `tc_iads_system.lua`

Grundsatz:

- Skynet IADS steuert taktisch.
- Theater Command bewertet strategisch.
- `SkynetIADS.lua` wird nicht geändert.
- eigene IADS-Kampagnenlogik gehört nach `src/iads/`.

Aktuell:

- Skynet IADS wird geladen.
- MissionGenerator reserviert Skynet-Hooks.
- eigene IADS-Brücke ist noch offen.

---

## 30. UI-Regeln

Der Ordner `src/ui/` enthält Spieler- und Testinteraktion.

Aktive Datei:

- `tc_f10_menu.lua`

Regeln:

- UI liest State.
- UI schreibt nur klar definierte UI-/Action-State-Daten.
- UI ruft sichere Modul-Funktionen auf.
- UI löst keine echten Framework-Aktionen aus.
- UI-Aktionen müssen im Log nachvollziehbar sein.

Nächster sinnvoller UI-Schritt:

```text
Apply Capture Ready Zone 1
```

---

## 31. Debug-Regeln

Der Ordner `src/debug/` ist vorbereitet.

Geplante Funktionen:

- Airbase Report
- Zone Report
- Capture Report
- Logistics Report
- FOB Report
- Mission Report
- AI Report
- IADS Report
- UI Report
- State Dump

Regeln:

- Debug darf State sichtbar machen.
- Debug darf Testfunktionen bereitstellen.
- Debug darf keine produktiven Aktionen versteckt auslösen.
- Debug-Funktionen müssen eindeutig als Debug erkennbar sein.

---

## 32. Persistenz-Regeln

PersistenceSystem `v0.2.6` ist dirty-aware implementiert und mit Hotload- sowie normal eingebetteten Scheduler-Tests bestanden. Produktiver Startup-Restore bleibt deaktiviert und ungetestet.

Regeln:

- keine produktive Persistenz ohne DCS-Sandbox-Test
- keine Userdata speichern
- keine Funktionen speichern
- keine zyklischen Tabellen speichern
- State muss serialisierbar bleiben
- Save/Load muss fehlertolerant sein
- defekte Save-Dateien dürfen die Mission nicht hart zerstören

Vor produktivem Restore weiterhin testen:

```text
minimaler State Dump
Dateischreibzugriff
Dateilesen
Fehlerfall
```

---

## 33. Versionierung

Jede aktive Lua-Datei soll eine Version führen.

Beispiel:

```lua
CaptureSystem.version = "0.2.2"
```

Regeln:

- bei fachlicher Änderung Version erhöhen
- Logmarker mit Version ausgeben
- Dokumentation nach bestandenem Test aktualisieren
- Version in `TASKS.md` und `CHANGELOG.md` nachziehen
- bei Sessionabschluss zentrale Dokumente aktualisieren

---

## 34. Commit- und Testregel

Nach jeder Lua-Änderung:

1. Datei auf GitHub aktualisieren
2. Commit erstellen
3. GitHub Desktop fetchen/pullen
4. Datei im Mission Editor bei `DO SCRIPT FILE` neu auswählen
5. Mission speichern
6. alte `dcs.log` löschen oder umbenennen
7. DCS starten
8. Test durchführen
9. DCS beenden
10. frische `dcs.log` prüfen

Ein weitergeführter Log kann für gezielte Regressionen genutzt werden, wenn der neue Abschnitt eindeutig zeitlich abgegrenzt ist.

---

## 35. Aktuelle nächste technische Leitlinie

Kein spekulativer Code-Schritt ist freigegeben. Zuerst wird die gespeicherte DEV-`.miz` offline und read-only auf eingebettete Source-Drift geprüft. Erst nach Trigger-/Resource-Mapping, Byte-Längen-, SHA-256-, Versions- und Gleichheitsvergleich darf über einen MissionGenerator-Code-Fix entschieden werden.

Nicht als nächstes:

- keine echte MOOSE-Integration
- keine echte CTLD-Integration
- kein produktiver Restore
- kein großer AI Director
- kein IADS-System

Begründung:

- State zuerst sichtbar machen
- State dann kontrolliert ändern
- State dann speichern
- erst danach echte DCS-Aktionen auslösen
