# CHANGELOG.md

Alle relevanten Änderungen am Projekt **Theater Command DCS** werden in dieser Datei dokumentiert.

Das Projekt befindet sich weiterhin in der frühen Aufbauphase.  
Die erste vollständig spielbare dynamische Kampagne ist noch nicht fertig, aber die technische Runtime-Grundlage läuft inzwischen stabil im DCS Mission Scripting Environment.

---

## Unreleased

### Projektstand

Stand: **2026-06-16**

Erste Kampagne:

- **Operation Levant Reclamation**
- Map: **Syria**
- Blue startet auf **Akrotiri / Zypern**
- Das syrische Festland ist zu Beginn rot kontrolliert

Aktueller technischer Stand:

- Vendor-Frameworks werden im DCS Mission Scripting Environment geladen.
- Theater-Command-Source-Dateien werden per sicherer Einzeldatei-Ladung im Mission Editor geladen.
- `src/main.lua` initialisiert die aktiven Runtime-Systeme.
- `src/loader.lua` prüft Framework-Verfügbarkeit und startet Main.
- Die Kernsysteme laufen in DCS ohne Theater-Command-Lua-Abbruch.
- Die Syria-Airbase-Daten werden fachlich klassifiziert.
- ZoneFactory, Capture, Logistics, FOB, Mission Generator, AI CAP Manager und F10 Menu nutzen bzw. zeigen inzwischen den klassifizierten Kampagnenzustand.

Aktuelle Einschränkung:

- Das Projekt ist noch keine fertige spielbare dynamische Kampagne.
- Echte MOOSE-Spawns sind noch nicht aktiv.
- CTLD ist geladen, aber noch nicht produktiv mit Theater Command verbunden.
- Skynet IADS ist geladen, aber noch nicht über ein eigenes Theater-Command-IADS-Modul integriert.
- Persistenz ist vorbereitet, aber noch nicht praktisch im DCS-Dateisystem getestet.
- AI Director für beidseitige Blue-vs-Red-Kampagnenlogik ist noch nicht implementiert.

---

## Aktueller getesteter Systemstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.0` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | Grundstruktur | lädt/startet |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.1` | bestanden |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.1.0` | bestanden |

---

## Added

### F10 Menu

Neue Datei:

- `src/ui/tc_f10_menu.lua`

Version:

- `v0.1.0`

Funktion:

- erstes spielerseitiges Theater-Command-F10-Menü
- Blue-Coalition-Menü
- Missionsübersicht
- Anzeige aktiver Missionen
- Aktivierung der Top-Mission
- Kampagnenstatus
- Logistikstatus
- FOB-Status
- AI-CAP-Status

Bestätigte F10-Menüeinträge:

- `Show Available Missions`
- `Show Active Missions`
- `Activate Top Mission`
- `Show Campaign Status`
- `Show Logistics Status`
- `Show FOB Status`
- `Show AI CAP Status`

Bestätigt:

- F10-Menü ist in der Mission sichtbar.
- F10-Menü ist navigierbar.
- `missionCommands` funktioniert im DCS-Kontext.
- Log bestätigt Initialisierung mit 7 Commands.

Wichtige Logmarker:

- `[TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.1.0`
- `[TC] [F10Menu] F10 menu started`
- `[TC] [F10Menu] F10 menu initialized: commands=7`
- `[TC] System started: F10 Menu`

Aktuelle Einschränkung:

- Es kann aktuell nur die Top-Mission aktiviert werden.
- Einzelne Missionen 1 bis 10 sind noch nicht direkt auswählbar.
- Missionserfolg und Missionsfehlschlag werden noch nicht über F10 oder DCS-Events gesteuert.

---

### FOB-System-Anbindung

Datei:

- `src/logistics/tc_fob_system.lua`

Version:

- `v0.2.0`

Neu:

- FOB-System nutzt die Logistics-Hub-Struktur.
- FOB-Kandidaten werden aus freundlichen oder umkämpften Logistics-Hubs abgeleitet.
- automatisch geplante Blue-FOBs werden als State-only-Objekte erzeugt.
- FOBs werden mit Zonen, Basen und Logistics-Hubs verknüpft.
- FOB-Status, Baufortschritt, Versorgung und Support-Delivery-Vorbereitung sind vorhanden.
- spätere CTLD-FOB-Erstellung ist vorbereitet, aber noch nicht aktiv.

Bestätigte Testwerte:

- FOB candidates: 6
- stored candidates: 6
- auto-planned FOBs: 2
- skipped candidates: 4
- erzeugte FOBs:
  - `FOB Ercan`
  - `FOB Gecitkale`
- Status:
  - `UNDER_CONSTRUCTION`
- Blue FOBs: 2

Bewertung:

- FOB-System ist erfolgreich an die Logistics-Hubs angebunden.
- `planned=0` im Summary ist kein Fehler, weil automatisch geplante FOBs durch initialen Baufortschritt direkt in `UNDER_CONSTRUCTION` wechseln.
- Es werden noch keine echten CTLD-FOBs gespawnt.

---

### FOB-Support-Missionen

Datei:

- `src/missions/tc_mission_generator.lua`

Version:

- `v0.2.1`

Neu:

- Mission Generator erkennt FOBs aus dem Logistics-State.
- Mission Generator erzeugt FOB-Support-Kandidaten für geplante oder im Bau befindliche FOBs.
- mindestens eine FOB-Support-Mission wird im verfügbaren Missionspool reserviert.
- FOB-Support wird nicht mehr durch Airbase-Attack-, SEAD-, Strike- oder CAP-Missionen verdrängt.
- Mission Generator unterscheidet weiterhin State-Missionen von echter DCS-Ausführung.

Bestätigte Testwerte:

- mission candidates: 69
- fobSupportCandidates: 2
- generated missions: 10
- reservedCreated: 1
- duplicatesSkipped: 1
- typeLimitSkipped: 30

Bestätigte Missionen:

- `FOB_SUPPORT` für `FOB Ercan`
- `FOB_SUPPORT` für `FOB Gecitkale`

Bewertung:

- FOB-Support ist jetzt im Missionssystem sichtbar und priorisiert.
- Mission Generator liefert eine stabilere Grundlage für F10-Missionsauswahl.
- Missionen sind weiterhin State-only und lösen noch keine echten Spawns aus.

---

### Source-Grundstruktur

Erstellt wurden im bisherigen Projektverlauf:

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

Dokumentierte, aber noch nicht aktiv implementierte Bereiche:

- `src/iads/`
- `src/debug/`

---

### Source-Dokumentation

Erstellt wurden im bisherigen Projektverlauf:

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

---

### Mission-Editor-Dokumentation

Erstellt wurden:

- `mission_editor/README.md`
- `mission_editor/trigger_setup.md`

Dokumentiert wurde:

- sichere Starttest-Variante A
- spätere Loader-only-Variante B
- DCS-`DO SCRIPT FILE`-Verhalten
- manuelles Neuauswählen geänderter Lua-Dateien im Mission Editor
- Framework-Ladefolge
- Source-Ladefolge für den ersten sicheren Test

---

## Changed

### Aktive Mission-Editor-Ladefolge

Die aktive Ladefolge wurde erweitert.

Aktive Theater-Command-Source-Ladefolge nach Vendor-Dateien:

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

Neu:

- `src/ui/tc_f10_menu.lua` wird jetzt aktiv vor `src/main.lua` geladen.

Wichtig:

- `src/loader.lua` bleibt letzte eigene Datei.
- Geänderte Lua-Dateien müssen im Mission Editor erneut ausgewählt und die Mission gespeichert werden.

---

### Main und Runtime-Systeme

`src/main.lua` initialisiert inzwischen aktive Runtime-Systeme und berücksichtigt optionale Zukunftssysteme.

Aktive bzw. getestete Runtime-Systeme:

- Airbase Scanner
- Zone Factory
- Capture System
- Persistence System
- Logistics Delivery
- FOB System
- Mission Generator
- AI CAP Manager
- F10 Menu

Optionale bzw. spätere Zukunftssysteme:

- IADS
- Debug
- AI Director
- weitere UI-Module

---

### Airbase Scanner

Datei:

- `src/world/tc_airbase_scanner.lua`

Aktuelle getestete Version:

- `v0.2.2`

Wesentliche Änderungen:

- Airbase-ähnliche DCS-Objekte werden klassifiziert.
- Akrotiri wird als Blue-Startbasis erkannt.
- syrische Hauptflugplätze werden als potenzielle Red Strategic Bases vorbereitet.
- Medical Pads, einfache Helipads, Tactical Pads und Unknowns werden von strategischen Airfields getrennt.
- Airbase-Klassifizierung erfolgt primär über normalisierte Namen und nachrangig über DCS-Kategorieinformationen.
- Konflikt zwischen Owner-Counter `unknown` und Unknown-Klassifizierung wurde behoben.
- Logger-Ausgaben wurden an die tatsächliche `TC.Logger`-Signatur angepasst.

Klassifizierungen:

- `STRATEGIC_AIRFIELD`
- `SECONDARY_AIRFIELD`
- `HELIPORT`
- `HELIPAD`
- `MEDICAL_PAD`
- `FARP`
- `TACTICAL_PAD`
- `UNKNOWN`

---

### Zone Factory

Datei:

- `src/world/tc_zone_factory.lua`

Aktuelle getestete Version:

- `v0.2.0`

Wesentliche Änderungen:

- nutzt die Klassifizierung des Airbase Scanners
- erzeugt nicht mehr für alle 225 Airbase-Rohobjekte Kampagnenzonen
- erzeugt nur noch relevante klassifizierte Kampagnenzonen
- trennt Capture-Zonen, Mission-Zonen und Logistics-Zonen
- überspringt medizinische Pads, einzelne Helipads und Unknowns als Kampagnenzonen
- unterstützt weiterhin optionale Mission-Editor-Zonen über MIST

---

### Capture System

Datei:

- `src/campaign/tc_capture_system.lua`

Aktuelle getestete Version:

- `v0.2.0`

Wesentliche Änderungen:

- Capture-Eligibility wird aus klassifizierten Bases und Zones abgeleitet.
- Capture wirkt nur noch auf strategische und sekundäre Kampagnenziele.
- Helipads, Medical Pads, Tactical Pads, FARPs und Unknowns werden als strategische Capture-Ziele ausgeschlossen.
- Ownership von verknüpften Airbase-/Zone-Records kann synchronisiert werden.
- Capture Events werden für spätere Persistence-, Debug- und AI-Reaktionen vorbereitet.

---

### Logistics Delivery

Datei:

- `src/logistics/tc_logistics_delivery.lua`

Aktuelle getestete Version:

- `v0.2.0`

Wesentliche Änderungen:

- Logistics Hubs werden aus klassifizierten Kampagnenzonen erzeugt.
- Akrotiri wird als Blue Main Operating Base vorbereitet.
- Red Strategic Airbase Hubs werden vorbereitet.
- neutrale/limitierte Hubs werden als State vorbereitet.
- Logistics-Ressourcen werden als State modelliert:
  - supply
  - fuel
  - ammunition
  - engineering
- Delivery Records werden vorbereitet.
- CTLD wird noch nicht direkt angesprochen, aber spätere CTLD-Anbindung ist vorbereitet.

---

### FOB System

Datei:

- `src/logistics/tc_fob_system.lua`

Aktuelle getestete Version:

- `v0.2.0`

Wesentliche Änderungen:

- nutzt Logistics Hubs aus `tc_logistics_delivery.lua`
- erzeugt FOB-Kandidaten aus geeigneten Blue-/Contested-Logistics-Zonen
- plant erste Blue-FOBs automatisch als State-only-Objekte
- verbindet FOBs mit Zonen, Basen und Logistics Hubs
- unterstützt FOB-Zustände:
  - `PLANNED`
  - `UNDER_CONSTRUCTION`
  - `ACTIVE`
  - `DAMAGED`
  - `OUT_OF_SUPPLY`
  - `DESTROYED`
- unterstützt Supply-, Fuel-, Ammunition-, Engineering-, AirDefense- und Repair-Level
- bereitet Support-Delivery-Kopplung vor
- bereitet CTLD-Kopplung vor, ohne CTLD bereits produktiv zu nutzen

---

### Mission Generator

Datei:

- `src/missions/tc_mission_generator.lua`

Aktuelle getestete Version:

- `v0.2.1`

Wesentliche Änderungen:

- Missionen werden aus klassifizierten Kampagnenzonen erzeugt.
- Missionen werden priorisiert.
- Medical Pads, einfache Helipads und Unknowns werden nicht als Strike-Ziele verwendet.
- FOBs werden als Missionsziele berücksichtigt.
- FOB-Support-Missionen werden reserviert.
- Missionen enthalten Zielzone, Zielbasis, Ziel-FOB, Priorität, strategische Relevanz und spätere Effektdaten.
- Missionseffekte für spätere Capture-/Logistics-/AI-Kopplung sind vorbereitet.

Aktuell erzeugte Missionstypen im Test:

- `FOB_SUPPORT`
- `AIRBASE_ATTACK`
- `SEAD`
- `STRIKE`
- `CAP`

Weitere Missionstypen sind vorbereitet, aber noch nicht vollständig funktional gekoppelt:

- `RECON`
- `DEAD`
- `CAS`
- `INTERDICTION`
- `LOGISTICS`
- `IADS_SUPPRESSION`

---

### AI CAP Manager

Datei:

- `src/ai/tc_ai_cap_manager.lua`

Aktuelle getestete Version:

- `v0.2.0`

Wesentliche Änderungen:

- CAP-Zonen werden aus klassifizierten Kampagnenzonen abgeleitet.
- Blue- und Red-CAP-Bedarf wird vorbereitet.
- Blue CAP für Akrotiri wird als State erzeugt.
- Red CAPs für strategische syrische Flugplätze werden als State erzeugt.
- CAP Requests werden deterministisch priorisiert.
- echter MOOSE-Spawn ist noch nicht aktiv.
- `spawn=MOOSE_PENDING` ist aktuell erwartetes Verhalten.

---

## Fixed

### Airbase Scanner Unknown-State-Konflikt

Behoben wurde ein Fehler im Airbase Scanner:

- `state.Bases.unknown` wurde gleichzeitig als Owner-Counter und als Klassifizierungs-Liste verwendet.
- Dadurch entstand ein Lua-Fehler beim Indexieren eines Zahlenwerts.
- Die Unknown-Klassifizierung wird jetzt getrennt geführt.

Vorheriger Fehler:

- `attempt to index local 'list' (a number value)`

Ergebnis:

- Airbase Scanner startet sauber.
- Runtime-Systeme werden nicht mehr durch diesen Fehler gestoppt.

---

### Logger-Aufrufsignaturen

Mehrere Module wurden so angepasst, dass sie mit dem vorhandenen `TC.Logger` kompatibel sind.

Statt mehrerer Parameter wird jetzt ein einzelner formatierter String übergeben.

Beispiel:

- vorher sinngemäß: `logger.info(moduleName, message)`
- jetzt sinngemäß: `logger.info("[ModuleName] " .. message)`

---

### ZoneFactory-Rohobjektproblem

Vorher:

- ZoneFactory erzeugte 225 Zonen aus allen Airbase-ähnlichen Objekten.

Nachher:

- ZoneFactory erzeugt 46 relevante Kampagnenzonen.
- 179 nicht relevante Airbase-ähnliche Objekte werden übersprungen.

---

### Capture-Zielproblem

Vorher:

- Capture konnte konzeptionell auf zu viele Rohobjekte wirken.

Nachher:

- Capture ist auf 32 relevante Bases/Zones beschränkt.

---

### FOB-Missionsverdrängung

Vorher:

- FOBs wurden zwar vom Mission Generator wahrgenommen, aber FOB-Support wurde durch höher priorisierte Airbase-/SEAD-/Strike-/CAP-Missionen aus den 10 verfügbaren Missionen verdrängt.

Nachher:

- Mission Generator `v0.2.1` reserviert mindestens einen FOB-Support-Slot.
- FOB-Support erscheint zuverlässig im verfügbaren Missionspool.

---

## Tested

### Starttest Variante A

Status:

- **bestanden**

Bestätigt wurde:

- MIST lädt
- MOOSE lädt
- CTLD-i18n lädt
- CTLD lädt
- Skynet IADS lädt
- Theater-Command-Source-Dateien laden
- Loader startet
- Frameworks werden erkannt
- Main startet
- Runtime-Systeme werden initialisiert
- Loader beendet sauber

---

### Framework-Versionen

Bestätigte Framework-Stände:

| Framework | Pfad | bestätigter Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

---

### Airbase Scanner v0.2.2

Status:

- **bestanden**

Bestätigte Testwerte:

- total: 225
- strategic: 19
- secondary: 13
- heliports: 1
- helipads: 95
- medical: 40
- farps: 0
- tactical: 13
- unknown: 44
- captureCandidates: 32
- missionCandidates: 32
- logisticsCandidates: 46
- blueStartBases: 1
- redStrategicCandidates: 18

Bestätigt:

- Akrotiri wird als Blue-Startbasis erkannt.
- Akrotiri wird als `STRATEGIC_AIRFIELD` klassifiziert.
- Akrotiri erhält `strategicRelevance=100`.

---

### Zone Factory v0.2.0

Status:

- **bestanden**

Bestätigte Testwerte:

- total zones: 46
- classified airbase zones: 46
- Mission Editor zones: 0
- skipped airbase-like objects: 179
- strategic zones: 19
- secondary zones: 13
- heliport zones: 1
- farp zones: 0
- tactical zones: 13
- captureZones: 32
- missionZones: 32
- logisticsZones: 46
- startBaseZones: 1

Bewertung:

- ZoneFactory nutzt die Airbase-Klassifizierung korrekt.
- Es werden nicht mehr 225 ungefilterte Zonen erzeugt.

---

### Capture System v0.2.0

Status:

- **bestanden**

Bestätigte Testwerte:

- eligibleBases: 32
- eligibleZones: 32
- nonCaptureBases: 193
- nonCaptureZones: 14

Bewertung:

- Capture arbeitet nur noch auf strategisch relevanten Kampagnenzielen.

---

### Logistics Delivery v0.2.0

Status:

- **bestanden**

Bestätigte Testwerte:

- logistics hubs: 46
- blue hubs: 7
- red hubs: 24
- neutral hubs: 15
- active hubs: 31
- limited hubs: 15
- locked hubs: 0

Bewertung:

- Logistics Delivery nutzt die klassifizierten Kampagnenzonen.
- CTLD ist noch nicht produktiv angebunden.

---

### FOB System v0.2.0

Status:

- **bestanden**

Bestätigte Testwerte:

- FOB candidates: 6
- stored candidates: 6
- auto-planned FOBs: 2
- skipped candidates: 4
- Blue FOBs: 2

Bestätigte erzeugte FOBs:

- `FOB Ercan`
- `FOB Gecitkale`

Status der erzeugten FOBs:

- `UNDER_CONSTRUCTION`

Bewertung:

- FOB-System nutzt die Logistics-Hub-Struktur.
- FOBs werden als State-only-Objekte erzeugt.
- Keine echten CTLD-FOBs werden gespawnt.

---

### Mission Generator v0.2.1

Status:

- **bestanden**

Bestätigte Testwerte:

- mission candidates: 69
- fobSupportCandidates: 2
- generated missions: 10
- reservedCreated: 1
- duplicatesSkipped: 1
- typeLimitSkipped: 30

Bestätigte Missionen:

- `FOB_SUPPORT` für `FOB Ercan`
- `FOB_SUPPORT` für `FOB Gecitkale`

Bewertung:

- Mission Generator nutzt klassifizierte Zonen.
- FOB-Support wird sicher in die verfügbare Missionsliste aufgenommen.
- Missionen bleiben State-only.

---

### AI CAP Manager v0.2.0

Status:

- **bestanden**

Bestätigte Testwerte:

- cap zone candidates: 31
- auto-registered CAP zones: 12
- CAP requests: 12
- reactionState: `AIR_REACTION_REQUESTED`
- threatLevel: `HIGH`

Bewertung:

- Blue- und Red-CAP-Bedarf wird als State vorbereitet.
- Echter MOOSE-Spawn ist noch nicht aktiv.

---

### F10 Menu v0.1.0

Status:

- **bestanden**

Bestätigte Testwerte:

- F10 menu visible: ja
- F10 menu navigable: ja
- commands: 7

Bestätigte Logmarker:

- `[TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.1.0`
- `[TC] [F10Menu] F10 menu started`
- `[TC] [F10Menu] F10 menu initialized: commands=7`
- `[TC] System started: F10 Menu`

Bewertung:

- Erste spielerseitige Bedienoberfläche funktioniert.
- F10-Menü kann aktuelle Missionen und Statusinformationen anzeigen.
- Top-Mission kann aktiviert werden.
- Direkte Auswahl einzelner Missionen ist noch offen.

---

## Known Limitations

Aktuell noch nicht umgesetzt:

- echte MOOSE-CAP-Spawns
- echte MOOSE-Strike-/SEAD-/CAS-Spawns
- echte CTLD-Pickup-/Dropoff-Integration
- echte CTLD-FOB-Integration
- echte Skynet-IADS-Kampagnenbrücke
- eigenes IADS-Modul unter `src/iads/`
- eigenes Debug-System unter `src/debug/`
- AI Director für beidseitige Kampagnenlogik
- echte Blue-vs-Red-Operationen unabhängig vom Spieler
- direkte Missionsauswahl 1 bis 10 über F10
- Missionsabschluss über DCS-Events/Trigger
- Missionserfolg oder Missionsfehlschlag über F10/Debug
- Capture-Fortschritt durch Missionserfolge
- Logistics-Verbrauch
- produktive Persistence-Save/Load-Funktion im DCS-Dateisystem
- DCS-Sandbox-Schreibtest
- Loader-only-Variante B über `dofile`

Aktuelle technische Einschränkung:

- Die sichere Einzeldatei-Ladung per `DO SCRIPT FILE` bleibt Standard, bis die Loader-only-Variante praktisch geprüft wurde.

---

## Current Recommended Next Steps

Empfohlener nächster technischer Schritt:

- `src/ui/tc_f10_menu.lua`

Ziel:

- F10-Menü von „Activate Top Mission“ auf direkte Missionsauswahl erweitern
- Mission 1 bis Mission 10 direkt auswählbar machen
- Missionsdetails über F10 anzeigen
- verfügbare Missionen stabil sortieren
- weiterhin state-only bleiben
- noch keine echten MOOSE-/CTLD-Spawns auslösen

Danach mögliche Folgeschritte:

1. Mission completed/failed über F10 oder Debug vorbereiten
2. Missionseffekte auf State anwenden
3. Persistence-Sandbox-Test vorbereiten
4. CTLD-Zonen im Mission Editor vorbereiten
5. AI Director state-only beginnen

---

## Version 0.1.0 — Source Foundation Baseline

### Added

- Source-Grundstruktur begonnen
- `src/loader.lua` als zentrale Einstiegdatei erstellt
- `src/main.lua` als Hauptinitialisierung erstellt
- Core-Bereich erstellt
- World-Bereich erstellt
- Campaign-Bereich erstellt
- Logistics-Bereich erstellt
- Missions-Bereich erstellt
- AI-Bereich erstellt
- IADS-Bereich dokumentiert
- UI-Bereich dokumentiert
- Debug-Bereich dokumentiert
- erste Core-Module erstellt
- erste World-Module erstellt
- erste Campaign-Module erstellt
- erste Logistics-Module erstellt
- erster Missionsgenerator erstellt
- erster AI-CAP-Manager erstellt

### Changed

- Projektstatus von reiner Dokumentations- und Vendor-Basis auf begonnene Source-Implementierung erweitert
- Loader auf modulare Source-Struktur ausgerichtet
- Source-Dokumentation an die tatsächliche Ordnerstruktur angepasst
- Tasks an den aktuellen Implementierungsstand angepasst
- Main-Initialisierung an aktuelle Runtime-Module angepasst
- Mission-Editor-Setup an die Source-Ladeteststrategie angepasst

### Status

Diese Version ist noch keine spielbare DCS-Mission.

Sie stellt die erste eigene Lua-Grundstruktur für Theater Command DCS bereit.

---

## Version 0.0.2 — Vendor Framework Baseline

### Added

- MIST als externes Framework unter `vendor/mist/` hinterlegt
- MOOSE als externes Framework unter `vendor/moose/` hinterlegt
- CTLD als externes Framework unter `vendor/ctld/` hinterlegt
- Skynet IADS als externes Framework unter `vendor/skynet-iads/` hinterlegt
- MIST-Handbuch als lokale Referenz hinterlegt
- MIST Example-DBs als Referenzmaterial hinterlegt
- MOOSE-Dokumentationsreferenz als Markdown-Datei hinterlegt
- Vendor-README-Dateien an den tatsächlichen Framework-Import angepasst
- `src/README.md` als Einstieg in die spätere eigene Lua-Struktur erstellt

### Changed

- MIST-Version auf die mit CTLD gelieferte Variante ersetzt
- MIST-Version in `vendor/mist/README.md` dokumentiert
- CTLD-Version in `vendor/ctld/README.md` dokumentiert
- MOOSE-Version in `vendor/moose/README.md` dokumentiert
- Skynet-IADS-Version in `vendor/skynet-iads/README.md` dokumentiert
- Root-`README.md` auf den aktuellen Vendor-Stand gebracht
- `ROADMAP.md` auf den aktuellen Vendor-Stand gebracht
- `TASKS.md` auf den aktuellen Vendor-Stand gebracht
- zentrale Lade-Reihenfolge dokumentiert

Aktive MIST-Version:

- MIST `4.5.128-DYNSLOTS-02`

Grund:

- CTLD weist darauf hin, dass für korrektes dynamisches Spawning die mit CTLD gelieferte MIST-Version verwendet werden soll.

### Removed

- falsch platzierte Root-`Moose.lua` entfernt

### Status

Diese Version ist noch keine spielbare DCS-Mission.

Sie stellt die lokale Framework-Basis für die weitere Entwicklung bereit.

---

## Version 0.0.1 — Initial Project Setup

### Added

- erste Projektidee dokumentiert
- GitHub-Grundstruktur begonnen
- Projektname **Theater Command DCS** festgelegt
- erste Kampagne als **Operation Levant Reclamation** definiert
- Syria Map als primärer Kampagnenraum festgelegt
- Akrotiri als blaue Startbasis definiert
- syrisches Festland als vollständig rot kontrollierter Ausgangszustand definiert
- Grundidee einer persistenten dynamischen DCS-Kampagne dokumentiert
- Leitprinzip festgelegt:
  - Mission Editor = Bühne
  - Lua = Kampagnensystem
  - GitHub = Projektgedächtnis
- erste zentrale Projektdateien angelegt:
  - `README.md`
  - `ROADMAP.md`
  - `TASKS.md`
  - `CHANGELOG.md`
  - `ARCHITECTURE.md`
  - `MISSION_EDITOR_SETUP.md`
  - `NAMING_CONVENTIONS.md`
  - `LUA_STYLEGUIDE.md`
  - `.gitignore`
- Dokumentationsordner `docs/` angelegt
- Docs-Grundblock erstellt:
  - `docs/00_project_overview.md`
  - `docs/01_campaign_design.md`
  - `docs/02_technical_architecture.md`
  - `docs/03_mission_editor_basics.md`
  - `docs/04_airbase_system.md`
  - `docs/05_logistics_system.md`
  - `docs/06_mission_generator.md`
  - `docs/07_ai_director.md`
  - `docs/08_iads_system.md`
  - `docs/09_persistence.md`
  - `docs/10_testing.md`
- Vendor-Grundstruktur angelegt
- `vendor/README.md` erstellt
- MIST-Vendor-Ordner erstellt
- MOOSE-Vendor-Ordner erstellt
- CTLD-Vendor-Ordner erstellt
- Skynet-IADS-Vendor-Ordner erstellt
- Vendor-README-Dateien erstellt:
  - `vendor/mist/README.md`
  - `vendor/moose/README.md`
  - `vendor/ctld/README.md`
  - `vendor/skynet-iads/README.md`

### Status

Diese Version ist noch keine spielbare DCS-Mission.

Sie dient ausschließlich der Projektanlage, Dokumentation und Architekturplanung.
