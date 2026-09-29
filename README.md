# Theater Command DCS

**Theater Command DCS** ist ein modulares, dynamisches und perspektivisch persistentes Kampagnensystem für **DCS World**.

Erste Kampagne:

**Operation Levant Reclamation**

Map:

**Syria**

Aktueller verbindlicher Projektstand:

**29.09.2026**

Repository:

`https://github.com/PKrie/theater-command-dcs`

---

## Kampagnenidee

Blue beginnt auf:

- Zypern
- Akrotiri

Das syrische Festland ist zu Kampagnenbeginn rot kontrolliert.

Blue soll sich vom Brückenkopf Zypern aus auf das syrische Festland vorarbeiten.

Langfristig soll die Kampagne nicht davon abhängen, dass der Spieler jeden Prozess manuell auslöst.

Der Spieler soll vielmehr **Teil eines laufenden Systems** sein.

Perspektivisch sollen Blue und Red möglichst autonom:

- Missionen erzeugen
- CAP bereitstellen
- Strike durchführen
- SEAD / DEAD durchführen
- Bodentruppen bewegen
- CAS anfordern
- Transporte durchführen
- Logistik betreiben
- FOBs aufbauen
- Nachschub transportieren
- IADS betreiben
- auf Verluste reagieren
- Gebiete erobern und verlieren

Der Spieler kann sich mit verfügbaren Client-Flugzeugen in diese laufende Lage einklinken.

---

## Grundarchitektur

Theater Command DCS folgt vier Grundprinzipien:

**Mission Editor = Bühne**

**Lua = Kampagnensystem**

**GitHub = Projektgedächtnis / Source of Truth**

**DCS Runtime = autoritativer Verhaltensbeweis**

Der DCS Mission Editor stellt die konkrete Welt bereit:

- Karte
- Koalitionen
- Client-Slots
- KI-Gruppen
- Templates
- Trigger
- Trigger-Zonen
- Wegpunkte
- Tasks
- Airbases
- Statics
- FARPs
- eingebettete Lua-Ressourcen

Die eigene Theater-Command-Logik liegt unter:

`src/`

GitHub hält den bestätigten Projektstand fest:

- Source
- Architektur
- Tasks
- Roadmap
- Tests
- Naming
- Mission-Editor-Konventionen
- bekannte Einschränkungen
- historische Änderungen

DCS selbst ist die autoritative Instanz für tatsächliches Simulator- und Framework-Verhalten.

---

## Entwicklungsprinzip

Die Entwicklung erfolgt weiterhin:

**state-first**

Das bedeutet:

1. Kampagnenzustand erzeugen.
2. Zustand sichtbar machen.
3. Zustand und Dirty-Semantik testen.
4. Persistence absichern.
5. Framework-Funktion isoliert nachweisen.
6. Framework kontrolliert produktiv anbinden.
7. Framework-Ergebnis validieren.
8. Ergebnis in Theater-Command-State zurückführen.
9. persistierbare Änderungen Dirty markieren.

Dadurch bleiben Fehlerquellen voneinander trennbar.

---

## Vendor-Frameworks

Externe Frameworks liegen ausschließlich unter:

`vendor/`

Aktuell verwendet:

| Framework | Pfad | Stand |
|---|---|---:|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Verbindlich:

**Vendor-Dateien werden für Theater Command nicht verändert.**

Framework-spezifische Integrationslogik gehört in eigene fachliche Module unter `src/`.

Nicht gewünscht sind beispielsweise:

- `tc_moose.lua`
- `tc_mist.lua`
- `tc_ctld.lua`
- `tc_ctld_all_in_one.lua`
- `tc_ctld_bridge.lua`
- `tc_all_in_one.lua`

Ein fachliches Modul darf intern ein Framework verwenden.

Beispiel:

`tc_logistics_delivery.lua`

darf später CTLD verwenden, ohne daraus eine generische Framework-Datei zu machen.

---

## Theater Command ↔ Frameworks

Die verbindliche Aufgabenteilung lautet:

### Theater Command

Theater Command ist:

- Campaign Logic
- Decision Layer
- State Owner
- Persistence Owner

Theater Command entscheidet beispielsweise:

- welche Mission benötigt wird
- welche Zone relevant ist
- welcher Hub Versorgung benötigt
- welcher FOB gebaut werden soll
- wo CAP benötigt wird
- welche Operation erfolgreich war
- welche Kampagnenfolgen daraus entstehen
- was langfristig persistiert wird

### CTLD

CTLD ist Execution Layer für reale Transport- und Logistikinteraktion.

Perspektivisch insbesondere:

- Truppentransport
- Cargo
- Supply
- Engineering
- Repair
- FOB-Aufbau

### MOOSE

MOOSE soll später reale AI-Air-Operationen ausführen.

Perspektivisch insbesondere:

- CAP
- Strike
- SEAD
- DEAD
- CAS
- Escort
- Carrier Air Wing

### Skynet IADS

Skynet IADS soll später die reale IADS-Ausführung übernehmen.

Theater Command bleibt Eigentümer des strategischen Kampagnenzustands.

---

## Aktueller Systemstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | Background Persistence bestanden |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.1` | bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.1` | bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | bestanden |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.1` | bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` | KI-Truppentransport-PoC für getesteten Aufbau bestanden |

---

## Bestätigter state-first Kampagnenkern

Aktuell bestätigt:

- Airbase Scanner klassifiziert Syria-Airbase-like Objects.
- ZoneFactory erzeugt relevante Kampagnenzonen.
- CaptureSystem verwaltet Ownership, Capture Pressure und Capture Progress.
- MissionGenerator erzeugt Missionskandidaten und Mission Records.
- Missionen können state-only aktiviert werden.
- Missionen können auf `COMPLETED` gesetzt werden.
- Missionen können auf `FAILED` gesetzt werden.
- Mission Completion kann Capture Pressure erzeugen.
- Mission Failure erzeugt aktuell bewusst keinen Capture Pressure.
- Capture Ready kann state-only angewendet werden.
- linked Airbase Ownership wird synchronisiert.
- LogisticsDelivery erzeugt Logistics Hubs.
- FobSystem erzeugt FOB-Kandidaten und erste Blue-FOBs.
- AICapManager erzeugt CAP-State.
- F10Menu stellt State sichtbar und kontrolliert testbar bereit.
- PersistenceSystem speichert Campaign-State dirty-aware im Hintergrund.

---

## Bestätigte Kernwerte

### Airbase Scanner

Syria airbase-like objects:

`225`

Davon unter anderem:

- strategic: `19`
- secondary: `13`
- heliports: `1`
- helipads: `95`
- medical: `40`
- tactical: `13`
- unknown: `44`

Capture Candidates:

`32`

Logistics Candidates:

`46`

### ZoneFactory

Relevante Kampagnenzonen:

`46`

Davon:

- captureZones: `32`
- missionZones: `32`
- logisticsZones: `46`
- startBaseZones: `1`

### Logistics

Logistics Hubs:

`46`

Davon:

- Blue: `7`
- Red: `24`
- Neutral: `15`
- Active: `31`
- Limited: `15`
- Locked: `0`

### FOB

FOB Candidates:

`6`

Blue FOBs:

`2`

Aktuell:

- FOB Ercan
- FOB Gecitkale

Status:

`UNDER_CONSTRUCTION`

Diese FOBs existieren aktuell als Theater-Command-State.

Sie sind noch keine real durch CTLD aufgebauten FOBs.

### MissionGenerator

Mission Candidates:

`78`

FOB Support Candidates:

`2`

Mission Records:

`10`

Der frühere Verdacht eines Mission-Record-Verlusts wurde widerlegt.

Die Mission-Collections sind String-keyed Lua-Dictionaries.

Deshalb ist:

`#table`

für ihre Anzahl nicht autoritativ.

Gezählt wird über `pairs()` beziehungsweise pairs-basierte Hilfsfunktionen.

### AICapManager

CAP Candidates:

`31`

CAP-Zonen:

`12`

CAP Requests:

`12`

Noch nicht aktiv:

**reale MOOSE-CAP-Flüge**

### F10Menu

Version:

`v0.2.3`

Commands:

`33`

Unter anderem vorhanden:

- Mission Details
- Mission Activation
- Mission Completion Test
- Mission Failure Test
- Capture Status
- Capture Ready
- Pressure Contested
- Capture Ready Apply
- Logistics Status
- FOB Status
- AI CAP Status

F10 ist nicht als zentrale manuelle Kampagnensteuerung vorgesehen.

Es dient aktuell vor allem:

- Status
- Debug
- Entwicklung
- kontrollierten Testaktionen

---

## Dirty-Coverage

Priority 3 – Dirty-Coverage – ist im dokumentierten Umfang seit **21.09.2026 abgeschlossen**.

Bestätigt beziehungsweise behoben:

- Capture Read-Neutrality
- Capture Ownership No-Op
- LogisticsDelivery Read-Neutrality
- FobSystem Read-Neutrality
- AICapManager Read-Neutrality
- MissionGenerator Audit ohne aktiven Missing-Dirty-Bug

Aktuelle Versionen der drei dabei angepassten Systeme:

- LogisticsDelivery `v0.2.1`
- FobSystem `v0.2.1`
- AICapManager `v0.2.1`

Latente Lifecycle- und Restore-Punkte bleiben separat dokumentiert.

Priority 3 wird nicht ohne neuen technischen Anlass erneut vollständig durchgeführt.

---

## Persistence

PersistenceSystem:

`v0.2.6`

Bestätigt:

- Campaign-State serialisieren
- Save-Datei schreiben
- Save-Datei lesen
- Compile
- Evaluate
- Validation
- kontrollierter Import
- Background Autosave
- `SAVED`
- `SKIPPED`
- kontrollierter `FAILED`
- Retry

Autosave:

- erster Lauf nach `20 s`
- danach alle `120 s`

Persistence ist ein internes Hintergrundsystem.

Spieler müssen und sollen nicht manuell über F10 speichern.

Verbindlich:

`productiveRestore=false`

Der produktive automatische Restore beim Missionsstart bleibt deaktiviert.

Die technische Importfähigkeit ist vorhanden, stellt aber noch keinen freigegebenen produktiven Restore dar.

---

## Produktive Save-Datei

Aktuell:

`C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua`

Nach dem CTLD-Test vom 29.09.2026 erneut bestätigt:

Größe:

`3094967 Bytes`

Änderungszeit:

`2026-09-21 15:00:00.5926451`

SHA-256:

`C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596`

Der isolierte CTLD-Test hat diesen produktiven Kampagnenstand nicht verändert.

---

## CTLD – aktueller Stand

CTLD:

`1.6.1`

CTLD ist:

- geladen
- initialisiert
- als Vendor unverändert
- technisch mit einem realen KI-Truppentransport getestet

Wichtig:

Der erfolgreiche Test ist ein **Framework-Proof-of-Concept für den getesteten Aufbau**.

Er bedeutet noch nicht, dass Theater Command selbständig produktive CTLD-Operationen plant oder ausführt.

---

## CTLD-Zonen

Bestätigter Pickup:

`CTLD_PICKUP_BLUE_AKROTIRI_01`

Technische Test-Dropoff-Zone:

`CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01`

Reservierter späterer Ercan-Dropoff:

`CTLD_DROPOFF_BLUE_ERCAN_FOB_01`

Für den getesteten Runtime-Pfad wurde bestätigt:

Nach der bestehenden CTLD-Initialisierung können bereits normalisierte Einträge in:

- `ctld.pickupZones`
- `ctld.dropOffZones`

ergänzt werden.

CTLD verwendete diese Einträge im Test tatsächlich.

Für diese getestete Runtime-Ergänzung war keine erneute Ausführung von:

`ctld.initialize()`

erforderlich.

Daraus wird nicht abgeleitet, dass `ctld.initialize()` generell niemals erneut aufgerufen werden dürfte.

Details:

`mission_editor/ctld_start_zones.md`

---

## CTLD-KI-Transporter

Der Test vom 29.09.2026 hat eine wichtige Voraussetzung bestätigt.

Ein KI-Transporter muss im relevanten getesteten CTLD-AI-Pfad über seinen exakten Unit-Namen in:

`ctld.transportPilotNames`

registriert sein.

Getestete Unit:

`TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01`

Vor Registrierung:

`108` Einträge

Nach temporärer idempotenter Registrierung:

`109` Einträge

Die Unit war genau einmal enthalten.

Eine spätere produktive Theater-Command-Integration muss diese Registrierung automatisch, idempotent und lifecycle-sicher durchführen.

---

## Erfolgreicher CTLD-KI-Truppentransport

Testdatum:

**29.09.2026**

Testmission:

`Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz`

SHA-256 vor dem Runtime-Test:

`5F0D89DF744A7083401E36713B148BD21813FF187CC36EC1F088507163458C57`

Gruppe:

`TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01`

Unit:

`TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01`

Typ:

`Mi-8`

Für den getesteten Aufbau bestätigter Ablauf:

`Pickup -> Taxi -> Takeoff -> Transit -> Off-Airfield-Landung -> Dropoff -> Bodengruppe`

Pickup:

`16` CTLD-Soldaten

Pickup Counter:

`10000 -> 9999`

Der Transport erfolgte ohne:

- manuelles CTLD-Loading
- manuelles CTLD-Unload
- direkte Manipulation von `ctld.inTransitTroops`
- Teleport
- Runtime-Routenänderung
- Runtime-Taskänderung

Der Test bestätigt diesen konkreten KI-Truppentransportpfad.

Er ist kein Nachweis einer bereits produktiven Theater-Command-CTLD-Orchestrierung.

---

## Off-Airfield-Landung

Der erfolgreiche Ansatz war:

**normaler Turning Point + DCS-native Perform Task `Land`**

Ziel:

- x / North: `-29249.110954281`
- z / East: `-271836.070539260`

Wegpunkt:

- Höhe: `100 m BARO`
- Geschwindigkeit: `30 m/s`

Land Task:

- `duration=300`
- `durationFlag=true`

Der Touchdown erfolgte ungefähr:

`1.06 m`

vom vorgesehenen Dropoff-Zentrum entfernt.

Für diesen getesteten Truppentransport war kein Invisible FARP erforderlich.

Der zuvor getestete ungebundene Wegpunkt vom Typ:

`Land / Landing`

führte nicht zu einem vollständigen erfolgreichen Transportzyklus.

Die genaue Ursache des früheren Turnback-Verhaltens ist dadurch nicht abschließend bewiesen.

---

## Automatischer CTLD-Dropoff

Nach der Landung entlud CTLD die transportierten Soldaten automatisch.

Bestätigt:

- der transportierte `troops`-Inhalt verschwand aus dem In-Transit-State der Testunit
- `ctld.droppedTroopsBLUE` erhielt genau einen neuen Eintrag
- eine reale Blue-Bodengruppe wurde erzeugt

Erzeugte Gruppe:

`Dropped Group 2`

Group-ID:

`70001`

Stärke:

`16`

Typ:

`Soldier M249`

Damit ist für den getesteten Aufbau der technische CTLD-KI-Truppentransport bestätigt:

`Pickup -> Transport -> Off-Airfield-Landung -> automatischer Dropoff -> Bodengruppe`

---

## Bekannter CTLD-Fehler

Beim Grounded-Übergang der KI-Mi-8 wurde im erfolgreichen Test **genau einmal** beobachtet:

`CTLD.lua:6150: attempt to get length of local 'RepackCommandsPath' (a nil value)`

Kontext:

- `updateRepackMenu`
- `updateRepackMenuOnlanding`

Der Pickup-/Dropoff-Pfad wurde im erfolgreichen Test trotzdem abgeschlossen.

Daraus wird jedoch **nicht** abgeleitet, dass der Fehler langfristig harmlos ist.

Nicht direkt bewiesen ist außerdem, ob der unbehandelte Fehler den betreffenden Scheduler beziehungsweise spätere Repack-Menü-Aktualisierungen dauerhaft beendet.

Dass ein unbehandelter Fehler den betreffenden Scheduler-Pfad beendet haben könnte, bleibt eine source-basierte technische Inferenz.

Verbindlich:

**`vendor/ctld/CTLD.lua` wird dafür nicht gepatcht.**

Die Lösung muss über eine Theater-Command-seitige Integrationsstrategie erfolgen oder der problematische Menüpfad muss außerhalb des Vendor-Codes sauber isoliert werden.

---

## Was der CTLD-Test noch nicht beweist

Noch nicht praktisch bestätigt sind:

- CTLD Crate Spawn
- Crate Loading
- Sling Load
- Crate Drop
- Supply Crates
- Engineering Crates
- Repair Crates
- Fuel Crates
- Ammo Crates
- FOB Build über CTLD
- LogisticsDelivery-Rückkopplung
- FobSystem-Rückkopplung
- Capture-Rückkopplung
- AI-Director-Rückkopplung
- CTLD-Runtime-Restore
- Multiplayer

Der erfolgreiche Test war ein:

**KI-Truppentransport**

und kein:

**Crate-/Cargo-Test**

---

## Produktive CTLD-Zielarchitektur

Die spätere produktive Integration muss mindestens folgende Kette abbilden:

`Kampagnenentscheidung -> Transportauftrag -> Transporter auswählen -> CTLD-Konfiguration -> DCS-Route / Task -> Pickup -> Transport -> Landung -> Dropoff -> Ergebnis validieren -> TC.State aktualisieren -> Dirty -> Persistence`

Noch zu entscheiden beziehungsweise source-backed zu untersuchen:

- welche fachliche `src/`-Komponente den Transportauftrag besitzt
- welche Komponente Pickup-/Dropoff-Zonen registriert
- welche Komponente KI-Transporter registriert
- wann diese Registrierung erfolgt
- wie die Registrierung idempotent bleibt
- wie der Transporter-Lifecycle behandelt wird
- wie Pickup, Erfolg und Fehler erkannt werden
- wie `RepackCommandsPath` ohne Vendor-Patch behandelt wird
- welche Resultate in `TC.State` geschrieben werden
- welche Änderungen Dirty setzen
- welche CTLD-Daten runtime-only bleiben
- was später nach Restore rekonstruiert werden muss

Eine generische Integrationsdatei wie:

`tc_ctld.lua`

oder:

`tc_ctld_bridge.lua`

wird nicht vorschnell angelegt.

---

## Entwicklungswerkzeuge

Seit dem 29.09.2026 ist der Entwicklungsworkflow verbindlich getrennt.

Diese Werkzeuge sind ausschließlich Entwicklungs- und Diagnosewerkzeuge.

Sie sind **keine Runtime-Abhängigkeiten** der fertigen Kampagne.

### ChatGPT

Rolle:

- Projektkoordination
- Architektur
- GitHub-Audit
- Dokumentationspflege
- Testplanung
- Ergebnisbewertung
- Definition des nächsten Einzelschritts
- Vorbereitung präziser Arbeitsaufträge für Claude

### Claude + dcs-mcp

Aktuell verwendete Version:

`dcs-mcp 0.9.11`

Terrain Store:

`C:\Users\Paul\AppData\Local\dcs-mcp\terrain`

Syria-Terrain:

`installiert`

Verwendung:

- `.miz` strukturiert analysieren
- Mission-Editor-Inhalte prüfen
- Mission-Editor-Inhalte gezielt ändern
- Gruppen prüfen
- Units prüfen
- Trigger-Zonen prüfen
- Wegpunkte prüfen
- Tasks prüfen
- Airbase-Zuordnungen prüfen
- gespeicherte Missionsdateien auditieren

Für Mission-Editor-/`.miz`-Arbeit ist Claude mit dcs-mcp aktuell das bevorzugte Werkzeug.

dcs-mcp ersetzt keinen realen DCS-Runtime-Test.

### Claude Code + DCS-SMS

DCS-SMS:

`0.27.2`

Hook:

`me-bridge-0.27.2`

Verifiziertes Installationsverzeichnis:

`C:\Tools\dcs-sms`

Claude-Code-Skill:

`C:\Users\Paul\.claude\skills\dcs-sms\SKILL.md`

Claude Code verwendet DCS-SMS unter anderem für:

- Mission-Editor-Status
- laufende DCS-Mission
- Runtime-Lua
- Theater-Command-Live-State
- CTLD-Live-State
- Unit-State
- Group-State
- Position
- Geschwindigkeit
- Airborne-/Grounded-State
- Logs
- kontrollierte Aktivierung
- Runtime-Regressionen

DCS-SMS ist kein Theater-Command-Framework.

Aus dem aktuell bestätigten Stand wird kein exakter Executable-Pfad abgeleitet.

---

## Verbindlicher Entwicklungsworkflow

Für Mission-Editor-/Framework-Arbeit:

`ChatGPT -> Claude + dcs-mcp -> gespeicherte Mission -> Claude Code + DCS-SMS -> DCS Runtime -> Auswertung -> GitHub`

Dabei gilt:

**ChatGPT**

koordiniert Ziel, Architektur und Dokumentation.

**Claude + dcs-mcp**

bearbeitet beziehungsweise auditiert `.miz`- und Mission-Editor-Struktur.

**Claude Code + DCS-SMS**

arbeitet mit dem lokalen Mission Editor und der laufenden DCS-Runtime.

**DCS**

liefert den tatsächlichen Runtime-Beweis.

**GitHub**

speichert den bestätigten Projektstand.

---

## Missionsdateien

Produktive Entwicklungsmission:

`C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_DEV.miz`

Erfolgreiche isolierte CTLD-Testmission:

`C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz`

Grundsatz:

**Testmission != DEV-Mission**

Riskante Framework-Experimente werden weiterhin isoliert durchgeführt.

Erkenntnisse werden erst kontrolliert in die produktive Architektur übernommen.

---

## Persistence-Schutz bei isolierten Framework-Tests

Wenn ein isolierter Test den produktiven Kampagnenstate beeinflussen könnte:

`aktuellen Hash prüfen -> Backup -> Backup-Hash prüfen -> Save ReadOnly setzen -> ReadOnly bestätigen -> Test -> DCS vollständig beenden -> Save erneut hashen -> Hash vergleichen -> nur bei Match ReadOnly entfernen -> final erneut prüfen`

Der CTLD-Test vom 29.09.2026 wurde auf diese Weise abgesichert.

Der produktive Save blieb unverändert.

---

## Aktuelle Projektgrenzen

Noch nicht produktiv umgesetzt:

- produktiver automatischer Restore
- vollständige Campaign-Fortsetzung über Neustarts
- produktive Theater-Command-CTLD-Orchestrierung
- CTLD Crate Economy
- reale CTLD-FOBs
- reale MOOSE CAP-Spawns
- AI Director
- Skynet-IADS-Kampagnenintegration
- automatische Missionserfolgsauswertung aus DCS Events
- automatische Ground Campaign
- CAS-Automatisierung
- Carrier Operations
- Multiplayer-Validierung
- vollständige Blue-/Red-Autonomie

---

## Perspektivische Systeme

Langfristig vorgesehen sind unter anderem:

- Supercarrier
- Carrier Task Group
- F/A-18C
- F-14
- weitere Carrier-fähige Flugzeuge
- Carrier CAP
- Carrier Strike
- Carrier Logistics
- A-10C II
- Bodentruppen
- autonome Ground Operations
- CAS Requests
- Transporthelikopter
- FOBs
- Convoys
- AI Director
- Blue AI Operations
- Red AI Operations
- dynamisches IADS
- langfristige Persistence

Diese Punkte sind Architekturziele und nicht als bereits implementiert zu verstehen.

---

## Repository-Struktur

    theater-command-dcs/
    ├── .agents/
    ├── AGENTS.md
    ├── README.md
    ├── ROADMAP.md
    ├── TASKS.md
    ├── CHANGELOG.md
    ├── ARCHITECTURE.md
    ├── MISSION_EDITOR_SETUP.md
    ├── NAMING_CONVENTIONS.md
    ├── LUA_STYLEGUIDE.md
    ├── docs/
    ├── mission_editor/
    ├── src/
    │   ├── core/
    │   ├── world/
    │   ├── campaign/
    │   ├── logistics/
    │   ├── missions/
    │   ├── ai/
    │   ├── iads/
    │   ├── ui/
    │   ├── debug/
    │   ├── main.lua
    │   └── loader.lua
    ├── tools/
    └── vendor/
        ├── mist/
        ├── moose/
        ├── ctld/
        └── skynet-iads/

---

## Aktuelle Mission-Editor-Ladefolge

Vendor:

1. `vendor/mist/mist.lua`
2. `vendor/moose/Moose.lua`
3. `vendor/ctld/CTLD-i18n.lua`
4. `vendor/ctld/CTLD.lua`
5. `vendor/skynet-iads/SkynetIADS.lua`

Theater Command:

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

Die sichere Einzeldatei-Ladung bleibt aktuell Standard.

---

## Nächster Entwicklungsbereich

Priority 3 ist abgeschlossen.

Der CTLD-KI-Truppentransport-Proof-of-Concept ist für den getesteten Aufbau bestanden.

Der nächste Entwicklungsbereich ist:

**Priority 4 – produktive CTLD-Integration vorbereiten**

Der nächste Schritt ist nicht:

- Priority 3 erneut vollständig auditieren
- denselben Mi-8-PoC ohne neuen Anlass wiederholen
- Vendor-CTLD patchen
- sofort Crates implementieren
- parallel MOOSE CAP integrieren
- produktiven Restore aktivieren

Zuerst wird die Integrationsgrenze fachlich und source-backed festgelegt.

---

## Einstieg für neue Sessions

Neue Sessions beginnen mit dem aktuellen GitHub-Stand.

Mindestens prüfen:

- `README.md`
- `ROADMAP.md`
- `TASKS.md`
- `CHANGELOG.md`
- `ARCHITECTURE.md`

Je nach Thema zusätzlich:

- `AGENTS.md`
- `.agents/skills/theater-command/SKILL.md`
- `MISSION_EDITOR_SETUP.md`
- `docs/`
- `mission_editor/`
- relevante `src/*/README.md`

Nicht aus einem älteren Chatstand weiterarbeiten, wenn GitHub bereits einen neueren Projektstand enthält.

---

## Dokumentation

Wichtigste Dokumente:

**Operativer Stand**

`TASKS.md`

**Architektur**

`ARCHITECTURE.md`

`docs/02_technical_architecture.md`

**Roadmap**

`ROADMAP.md`

**Änderungshistorie**

`CHANGELOG.md`

**Mission Editor**

`MISSION_EDITOR_SETUP.md`

`mission_editor/`

**Logistik / CTLD**

`docs/05_logistics_system.md`

`mission_editor/ctld_start_zones.md`

**Persistence**

`docs/09_persistence.md`

**Tests**

`docs/10_testing.md`

**Agenten-Arbeitsregeln**

`AGENTS.md`

`.agents/skills/theater-command/SKILL.md`

---

## Aktueller Leitsatz

**State zuerst.**

**Frameworks als Execution Layer.**

**Vendor unverändert.**

**Eine konkrete Aufgabe pro Schritt.**

**Reale DCS-Runtime entscheidet über tatsächliches Simulatorverhalten.**

**GitHub hält den bestätigten Projektstand fest.**

Aktueller Übergang:

**state-first Kampagnenkern + dirty-aware Persistence + abgeschlossene Priority-3-Dirty-Coverage + bestandener CTLD-KI-Truppentransport-PoC -> kontrollierte produktive CTLD-Integration**
