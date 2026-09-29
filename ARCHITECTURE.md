# ARCHITECTURE – Theater Command DCS

## Verbindlicher Architekturstand — 2026-09-29

Dieses Dokument beschreibt die technische Gesamtarchitektur von **Theater Command DCS**.

Repository:

    https://github.com/PKrie/theater-command-dcs

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Kampagnenausgangslage:

    Blue startet auf Zypern / Akrotiri.
    Das syrische Festland ist zu Beginn rot kontrolliert.

---

# 1. Architekturgrundsatz

Theater Command DCS folgt drei zentralen Grundsätzen:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis / Source of Truth

Der Mission Editor stellt die konkrete DCS-Welt bereit.

Dazu gehören unter anderem:

- Karte
- Koalitionen
- Client-Slots
- KI-Gruppen
- Templates
- Trigger
- Trigger-Zonen
- Wegpunkte
- Tasks
- Statics
- Airbases
- FARPs
- eingebettete Lua-Ressourcen

Die eigene Lua-Logik unter:

    src/

bildet daraus das eigentliche Kampagnensystem.

GitHub hält den bestätigten Entwicklungsstand fest:

- Architektur
- Source
- Versionen
- Tests
- Roadmap
- Tasks
- Naming
- Mission-Editor-Konventionen
- bekannte Grenzen
- historische Entscheidungen

---

# 2. Langfristiges Zielbild

Theater Command DCS soll langfristig eine dynamische und persistente Kampagne ermöglichen.

Der Spieler soll Teil des Systems sein und nicht dessen alleiniger Auslöser.

Blue und Red sollen perspektivisch möglichst autonom:

- Missionen erzeugen
- Luftoperationen durchführen
- CAP bereitstellen
- Strike fliegen
- SEAD / DEAD durchführen
- Bodentruppen bewegen
- CAS anfordern
- Transporte durchführen
- FOBs aufbauen
- Versorgung durchführen
- Nachschubwege schützen
- gegnerische Logistik angreifen
- IADS betreiben
- auf Verluste reagieren
- Gebiete erobern und verlieren

Der Spieler kann:

- Missionen übernehmen
- in laufende Operationen eingreifen
- die Kampagnenlage beeinflussen

Die Kampagne soll aber auch ohne permanente Spielerinteraktion weiter funktionieren.

---

# 3. Modulprinzip

Eigene Logik wird nach **fachlicher Aufgabe** organisiert.

Nicht nach Framework.

Gewünscht sind beispielsweise:

    tc_airbase_scanner.lua
    tc_zone_factory.lua
    tc_capture_system.lua
    tc_logistics_delivery.lua
    tc_fob_system.lua
    tc_mission_generator.lua
    tc_ai_cap_manager.lua
    tc_persistence_system.lua

Nicht gewünscht:

    tc_moose.lua
    tc_mist.lua
    tc_ctld.lua
    tc_ctld_all_in_one.lua
    tc_all_in_one.lua

Ein fachliches Modul darf intern Framework-Funktionen verwenden.

Beispiel:

    tc_logistics_delivery.lua

darf später CTLD verwenden.

Es wird deshalb nicht zu:

    tc_ctld.lua

umbenannt oder in eine generische Framework-Datei ausgelagert.

---

# 4. Vendor-Prinzip

Externe Frameworks liegen unter:

    vendor/

Aktuell:

    vendor/mist/
    vendor/moose/
    vendor/ctld/
    vendor/skynet-iads/

Verbindliche Regel:

    Vendor-Dateien werden für Theater Command nicht verändert.

Aktive Frameworks:

| Framework | Status |
|---|---|
| MIST | geladen |
| MOOSE | geladen |
| CTLD | geladen |
| Skynet IADS | geladen |

CTLD:

    Version 1.6.1

Vendor-Dateien:

    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua

Framework-Anpassungen erfolgen durch eigene Theater-Command-Logik unter `src/`.

---

# 5. State-first-Architektur

Der aktuelle Entwicklungsansatz ist bewusst:

    state-first

Reihenfolge:

    Daten erfassen
    -> Kampagnenstate erzeugen
    -> State sichtbar machen
    -> State testen
    -> Persistence absichern
    -> Framework-Funktion isoliert testen
    -> Framework kontrolliert integrieren

Das reduziert die Zahl gleichzeitig bewegter Teile.

Beispiel:

Der MissionGenerator erzeugt zuerst einen Mission Record.

Er startet nicht sofort:

- MOOSE-Flugzeuge
- CTLD-Transporte
- Skynet-Aktionen

Er erzeugt zunächst einen kontrollierbaren Kampagnenzustand.

---

# 6. Aktive Systemarchitektur

Aktueller Stand der eigenen Module:

| Layer | System | Datei | Version |
|---|---|---|---:|
| Core | Config | `src/core/tc_config.lua` | aktiv |
| Core | Logger | `src/core/tc_logger.lua` | aktiv |
| Core | State | `src/core/tc_state.lua` | aktiv |
| Core | Utils | `src/core/tc_utils.lua` | aktiv |
| Core | Scheduler | `src/core/tc_scheduler.lua` | aktiv |
| World | Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` |
| World | ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` |
| Campaign | CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` |
| Campaign | PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` |
| Logistics | LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.1` |
| Logistics | FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.1` |
| Missions | MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` |
| AI | AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.1` |
| UI | F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` |

Zusätzlich:

    src/main.lua
    src/loader.lua

---

# 7. Core Layer

Pfad:

    src/core/

Aufgabe:

- gemeinsame Konfiguration
- Logging
- globaler Theater-Command-State
- Hilfsfunktionen
- Scheduling
- modulübergreifende Infrastruktur

Der Core soll keine fachliche Logik von Logistics, Capture oder AI übernehmen.

---

## 7.1 State

Zentrale Runtime-Struktur:

    TC.State

Der State ist die autoritative Kampagnenrepräsentation innerhalb einer laufenden Mission.

Er enthält unter anderem:

- World
- Campaign
- Missions
- Logistics
- AI
- Persistence
- Meta

Wichtig:

String-keyed Lua-Dictionaries dürfen nicht mit dem Längenoperator:

    #

gezählt werden.

Für diese Tabellen wird:

    pairs()

beziehungsweise eine pairs-basierte Count-Funktion verwendet.

Der frühere vermeintliche Mission-Record-Verlust war genau eine solche Fehldiagnose und kein realer Datenverlust.

---

# 8. World Layer

Pfad:

    src/world/

Aktive Systeme:

    tc_airbase_scanner.lua
    tc_zone_factory.lua

---

## 8.1 Airbase Scanner

Version:

    0.2.2

Aufgabe:

- DCS-Airbase-like Objects der Syria Map erfassen
- klassifizieren
- für Kampagnensysteme vorbereiten

Bestätigter Stand:

    Airbase-like Objects: 225

Klassifikation unterscheidet unter anderem:

- strategic
- secondary
- heliport
- helipad
- medical
- tactical
- unknown

Nicht jedes DCS-Airbase-like Object ist ein strategischer Kampagnenflugplatz.

---

## 8.2 ZoneFactory

Version:

    0.2.0

Aufgabe:

- relevante Kampagnenzonen erzeugen
- Airbase-Daten in Theater-Command-Zonen überführen
- Mission-Editor-Zonen selektiv integrieren

Bestätigter Stand:

    relevante Kampagnenzonen: 46

Die ZoneFactory ist die fachliche Grenze zwischen:

    rohe DCS-Weltobjekte

und:

    relevante Kampagnenzonen

---

# 9. Campaign Layer

Pfad:

    src/campaign/

Aktive Systeme:

    tc_capture_system.lua
    tc_persistence_system.lua

---

# 10. CaptureSystem

Version:

    0.2.2

Aufgaben:

- Zone Ownership
- Base Ownership
- Capture Eligibility
- Capture Pressure
- Capture Progress
- Capture Ready
- Mission Effects übernehmen
- Ownership-Wechsel anwenden
- linked Airbase synchronisieren

Bestätigter Pfad:

    Mission Completion
    -> Mission Effects
    -> Capture Pressure
    -> Capture Progress
    -> Capture Ready
    -> Capture Apply
    -> Zone Ownership
    -> Airbase Ownership
    -> Persistence

Mission Failure erzeugt aktuell bewusst keinen Capture Pressure.

---

## 10.1 Capture Dirty-Semantik

Bestätigt:

Reine Capture-Reads erzeugen kein Persistence Dirty.

Unter anderem getestet:

    getCaptureReadyZones()
    getPressureContestedZones()
    getPressureSummary()
    getCaptureEligibleBases()
    getCaptureEligibleZones()
    getEligibilitySummary()
    getCaptureProgress()

Echte Capture-Mutationen setzen weiterhin Dirty.

Redundante Ownership-Aufrufe mit gleichem Owner sind echte No-Ops.

Sie verändern keinen persistierten State mehr.

---

# 11. PersistenceSystem

Version:

    0.2.6

Persistence ist ein internes Hintergrundsystem.

Sie ist kein normaler Spieler-F10-Workflow.

Bestätigt:

- Campaign State serialisieren
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

Scheduler:

    erster Autosave nach 20 s
    danach alle 120 s

Verbindlich:

    productiveRestore=false

---

## 11.1 Save-Datei

Produktive Datei:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Letzter bestätigter Stand nach CTLD-Test vom 2026-09-29:

    Größe: 3094967 Bytes

SHA-256:

    C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596

Änderungszeit:

    2026-09-21 15:00:00.5926451

Der CTLD-Test hat die produktive Save-Datei nicht verändert.

---

## 11.2 Produktiver Restore

Technische Importfähigkeit ist vorhanden.

Produktiver Restore bleibt trotzdem deaktiviert.

Vor Aktivierung sind mindestens separat zu klären:

- Restore-/Initialisierungsreihenfolge
- Save-Versionierung
- Kompatibilitätsstrategie
- Modul-Lifecycle
- Framework-Nebenwirkungen
- latente Init-/No-Op-Punkte
- kontrollierter Restore-Test

---

# 12. Dirty-State-Architektur

Persistence speichert nicht blind jeden Scheduler-Tick.

Prinzip:

    State-Mutation
    -> markDirty(reason)
    -> Autosave
    -> Write
    -> Read-back
    -> Compile
    -> Evaluate
    -> Validation
    -> Dirty löschen

Ein fehlgeschlagener Save darf Dirty nicht löschen.

Reine Getter dürfen keinen Dirty-State erzeugen.

No-Ops sollen keinen Dirty-State erzeugen.

---

## 12.1 Priority 3

Priority 3 – Dirty-Coverage – ist im dokumentierten Umfang seit:

    2026-09-21

abgeschlossen.

Bestätigt beziehungsweise behoben:

- Capture Read-Neutrality
- Capture Ownership No-Op
- LogisticsDelivery Read-Neutrality
- FobSystem Read-Neutrality
- AICapManager Read-Neutrality
- MissionGenerator Audit ohne aktiven Missing-Dirty-Fund

Latente Lifecycle-Punkte bleiben erhalten und werden bei tatsächlicher Verdrahtung geprüft.

---

# 13. Logistics Layer

Pfad:

    src/logistics/

Aktive Systeme:

    tc_logistics_delivery.lua
    tc_fob_system.lua

---

## 13.1 LogisticsDelivery

Version:

    0.2.1

Bestätigte Werte:

    Hubs: 46
    Blue: 7
    Red: 24
    Neutral: 15
    Active: 31
    Limited: 15
    Locked: 0

Aufgaben:

- Logistics Hubs
- Delivery State
- spätere Supply-Logik
- spätere CTLD-Anbindung
- Daten für FOB
- Daten für Missionsgenerator
- Daten für AI
- Persistence

Read-Neutrality:

    bestanden

Echte Mutation:

    createDelivery()

setzt weiterhin spezifischen Dirty-State.

---

## 13.2 FobSystem

Version:

    0.2.1

Bestätigt:

    FOB Candidates: 6
    Blue FOBs: 2

FOBs:

    FOB Ercan
    FOB Gecitkale

Status:

    UNDER_CONSTRUCTION

Die FOBs sind aktuell Theater-Command-State.

Sie sind noch keine durch CTLD gebauten DCS-FOBs.

Read-Neutrality:

    bestanden

---

# 14. Mission Layer

Pfad:

    src/missions/

Aktives System:

    tc_mission_generator.lua

Version:

    0.2.3

Bestätigt:

    Mission Records: 10

Aufgaben:

- Mission Candidates erzeugen
- Mission Records erzeugen
- Objectives
- Briefings
- Activation
- Completion
- Failure
- Cancellation
- Expiry
- Effect State
- Framework-Hooks vorbereiten

Aktiv getestet:

- Activation
- Completion
- Failure
- Effects

Noch nicht produktiv:

- reale Missionsausführung über Frameworks
- automatische Outcome-Erkennung über DCS Events

---

# 15. AI Layer

Pfad:

    src/ai/

Aktives System:

    tc_ai_cap_manager.lua

Version:

    0.2.1

Bestätigt:

    CAP Candidates: 31
    CAP-Zonen: 12
    CAP Requests: 12

Aktuell:

    state-first

Noch nicht aktiv:

    reale MOOSE CAP-Spawns

`reactToActiveMissions()` besitzt aktuell keine produktive Call-Site.

Der bekannte Dirty-Sonderfall dort bleibt deshalb latent und wird bei tatsächlicher Verdrahtung erneut geprüft.

---

# 16. UI Layer

Pfad:

    src/ui/

Aktives System:

    tc_f10_menu.lua

Version:

    0.2.3

Bestätigt:

    33 Commands

Funktionen unter anderem:

- Missionen anzeigen
- Mission Details
- Mission Activation
- Completion-Test
- Failure-Test
- Capture Status
- Capture Ready
- Pressure Contested
- Capture Apply
- Logistics Status
- FOB Status
- AI CAP Status

Architekturziel:

F10 ist nicht die zentrale Steuerung der Kampagne.

F10 dient hauptsächlich:

- Spielerinformation
- Debug
- Entwicklung
- kontrollierten Testaktionen

Automatische Hintergrundprozesse sollen später ohne F10 funktionieren.

---

# 17. Main und Loader

Aktive Dateien:

    src/main.lua
    src/loader.lua

Aufgaben:

- Framework-Verfügbarkeit prüfen
- Theater-Command-Module starten
- Fehler sichtbar machen
- Runtime-Status registrieren

Aktuelle Mission-Editor-Ladekette:

## Vendor

1. `vendor/mist/mist.lua`
2. `vendor/moose/Moose.lua`
3. `vendor/ctld/CTLD-i18n.lua`
4. `vendor/ctld/CTLD.lua`
5. `vendor/skynet-iads/SkynetIADS.lua`

## Theater Command

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

Die sichere Einzeldatei-Ladekette bleibt aktuell der Standard.

---

# 18. CTLD-Integrationsarchitektur

CTLD ist der erste Vendor-Bereich, bei dem ein realer Framework-Pfad inzwischen praktisch erfolgreich getestet wurde.

Status:

    Framework-Proof-of-Concept bestanden
    produktive Theater-Command-Integration noch nicht vorhanden

---

## 18.1 CTLD-Zonen

Bestätigter Pickup:

    CTLD_PICKUP_BLUE_AKROTIRI_01

Technische Test-Dropoff-Zone:

    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01

Reservierter späterer FOB-Dropoff:

    CTLD_DROPOFF_BLUE_ERCAN_FOB_01

CTLD initialisiert seine Zonenlisten selbst.

Nach der Initialisierung können bereits normalisierte Einträge ergänzt werden in:

    ctld.pickupZones
    ctld.dropOffZones

Dieser Ansatz wurde am 2026-09-29 praktisch bestätigt.

Verbindlich:

    ctld.initialize()

wird dafür nicht erneut aufgerufen.

---

## 18.2 KI-Transporterregistrierung

Wichtiger Architekturfund:

Ein KI-Transporter muss im relevanten CTLD-AI-Pfad unter:

    ctld.transportPilotNames

registriert sein.

Getestete Unit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Vor Test:

    108 Einträge

Nach idempotent geprüfter temporärer Registrierung:

    109 Einträge

Die Unit war genau einmal vorhanden.

Eine produktive TC-Integration muss diese Registrierung automatisch durchführen.

---

# 19. Bestätigter CTLD-KI-Transport-PoC

Test:

    2026-09-29

Mission:

    Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz

Mission-SHA-256 vor Test:

    5F0D89DF744A7083401E36713B148BD21813FF187CC36EC1F088507163458C57

Transporter:

    Mi-8MT

Gruppe:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01

Unit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Vollständig bestätigt:

    Pickup
    -> Taxi
    -> Takeoff
    -> Transit
    -> Off-Airfield-Anflug
    -> Landung
    -> automatischer CTLD-Dropoff
    -> reale Bodengruppe

Pickup:

    16 x Soldier M249

Pickup Counter:

    10000 -> 9999

Dropoff erzeugte:

    Dropped Group 2
    Group-ID 70001
    16 x Soldier M249

---

# 20. Off-Airfield-Landearchitektur

Der erfolgreiche Ansatz war nicht ein spezieller ungebundener Wegpunkt vom Typ:

    Land / Landing

Sondern:

    Turning Point
    +
    DCS-native Perform Task Land

Ziel:

    x = -29249.110954281
    z = -271836.070539260

Land-Task:

    duration = 300
    durationFlag = true

Touchdown:

    ungefähr 1.06 m vom Dropoff-Zentrum

Ein Invisible FARP war dafür nicht notwendig.

Architekturfolgerung:

Für geeignete Helikopter und Gelände kann ein normaler Route-Wegpunkt mit Perform Task `Land` als Off-Airfield-Transportziel dienen.

Dies ist für den getesteten Mi-8-Pfad bestätigt.

Es ist keine pauschale Garantie für jeden Luftfahrzeugtyp.

---

# 21. CTLD `RepackCommandsPath`

Bekannter reproduzierter Vendor-Runtime-Fehler:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Stack:

    updateRepackMenu
    updateRepackMenuOnlanding

Technische Einordnung:

- der KI-Transporter befindet sich in `ctld.transportPilotNames`
- der Repack-Menüpfad kann dadurch auch für diesen Transporter laufen
- reine KI-Units besitzen nicht zwingend einen Player-/F10-`vehicleCommandsPath`
- der Vendor-Code behandelt diesen Fall nicht robust

Trotz des Fehlers wurde der automatische Dropoff im Test abgeschlossen.

Nicht bewiesen:

    dass der Fehler langfristig harmlos ist

Insbesondere ist zu prüfen, ob der Scheduler nach diesem unbehandelten Fehler weiterläuft.

Verbindlich:

    vendor/ctld/CTLD.lua wird nicht gepatcht.

Die Integrationsstrategie muss den Fall außerhalb des Vendor-Codes behandeln.

---

# 22. Theater Command ↔ CTLD Grenze

Der erfolgreiche Test beweist eine Framework-Fähigkeit.

Er beweist noch keine produktive Theater-Command-Funktion.

Aktuell:

    Theater Command State

und:

    CTLD Runtime

sind noch nicht produktiv gekoppelt.

Die spätere Architektur muss mindestens diese Schritte abbilden:

    Kampagnenentscheidung
    -> Mission-/Transportauftrag
    -> Transporter auswählen
    -> CTLD-Zonen bereitstellen
    -> Transporter registrieren
    -> DCS-Route / Task
    -> Pickup
    -> Transport
    -> Landung
    -> Dropoff
    -> Ergebnis validieren
    -> Theater-Command-State aktualisieren
    -> Dirty markieren
    -> Persistence

CTLD ist dabei:

    Execution Framework

Theater Command ist:

    Campaign Logic / Decision Layer

---

# 23. Crate-/Cargo-Grenze

Der erfolgreiche CTLD-Test war:

    Truppentransport

Nicht getestet wurden:

- Crate Spawn
- Crate Loading
- Sling Load
- Crate Drop
- Supply Crates
- Engineering Crates
- Repair Crates
- Fuel Crates
- Ammo Crates
- FOB Build Crates

Pickup-Zonen und Crate-Logistik sind deshalb architektonisch getrennt zu behandeln.

---

# 24. Framework-Abstraktion

Frameworks sollen fachliche Systeme unterstützen und nicht die gesamte Projektstruktur bestimmen.

Beispiele:

    MissionGenerator
    -> erzeugt Mission Intent

    AICapManager
    -> erzeugt CAP Intent

    LogisticsDelivery
    -> erzeugt Logistics Intent / State

    CTLD
    -> führt später reale Transportinteraktion aus

    MOOSE
    -> erzeugt später reale Air Assets

    Skynet
    -> betreibt später reale IADS

Damit bleibt das Theater-Command-State-Modell unabhängig genug, um Framework-Aktionen kontrolliert auszutauschen oder zu erweitern.

---

# 25. Entwicklungswerkzeug-Architektur

Seit 2026-09-29 ist die Werkzeugtrennung verbindlich dokumentiert.

Diese Werkzeuge sind **Entwicklungswerkzeuge**.

Sie sind keine Runtime-Abhängigkeiten der fertigen Kampagne.

---

## 25.1 ChatGPT

Rolle:

- Projektkoordination
- Architektur
- GitHub-Audit
- Dokumentationspflege
- Testplanung
- Ergebnisbewertung
- Bestimmung des nächsten Einzelschritts
- Erstellen präziser Claude-Arbeitsaufträge

ChatGPT bildet den koordinierenden Projektkontext ab.

ChatGPT besitzt nicht automatisch Zugriff auf die lokale DCS-Runtime.

---

## 25.2 Claude + dcs-mcp

Aktuelle Version:

    dcs-mcp 0.9.11

Verwendung:

- `.miz` strukturiert analysieren
- Mission-Editor-Inhalte prüfen
- Mission-Editor-Inhalte gezielt ändern
- Gruppen
- Units
- Trigger Zones
- Wegpunkte
- Tasks
- Airbase-Zuordnungen
- Terrainbezug
- gespeicherte Mission auditieren

Terrain Store:

    C:\Users\Paul\AppData\Local\dcs-mcp\terrain

Installiert unter anderem:

    Syria

dcs-mcp eignet sich für:

    gespeicherte Mission / Mission Editor Struktur

Es ersetzt nicht den realen Runtime-Test.

---

## 25.3 Claude Code + DCS-SMS

DCS-SMS:

    Version 0.27.2

Hook:

    me-bridge-0.27.2

CLI:

    C:\Tools\dcs-sms\dcs-sms.exe

Claude-Code-Skill:

    C:\Users\Paul\.claude\skills\dcs-sms\SKILL.md

Verwendung:

- DCS-/ME-Status
- Mission Environment
- Runtime-Lua
- CTLD-Live-State
- Unit-State
- Aktivierung
- Position
- Geschwindigkeit
- Airborne/Grounded
- Logs
- kontrollierte Runtime-Regression

Claude Code kann damit direkt mit der lokalen DCS-Installation arbeiten.

---

## 25.4 GitHub

GitHub bleibt das Projektgedächtnis.

Neue Sessions dürfen nicht nur aus Chat-Erinnerung weiterarbeiten.

Vor neuer Arbeit wird der aktuelle Repository-Stand geprüft.

---

## 25.5 DCS

DCS selbst ist die autoritative Runtime für Verhalten im Simulator.

Eine Offline-Analyse kann beweisen:

- Struktur
- gespeicherte Werte
- Konfiguration
- Source

Sie kann nicht allein beweisen:

- AI-Verhalten
- echte Landung
- CTLD-Runtime-Reaktion
- Scheduler-Verhalten
- reale Spawn-/Dropoff-Effekte

Solche Punkte benötigen einen tatsächlichen DCS-Runtime-Test.

---

# 26. Verbindlicher Entwicklungsworkflow

Für Änderungen an Missionsinhalten:

    ChatGPT
    -> definiert Ziel und Architekturgrenze

    Claude + dcs-mcp
    -> analysiert / bearbeitet .miz und Mission Editor

    gespeicherte Mission
    -> wird verifiziert

    Claude Code + DCS-SMS
    -> prüft lokale ME-/DCS-Runtime

    DCS
    -> liefert Runtime-Beweis

    ChatGPT
    -> bewertet Ergebnis

    GitHub
    -> Dokumentation und Source of Truth aktualisieren

Für reine Lua-Codeänderungen kann dieser Ablauf entsprechend reduziert werden.

---

# 27. Missionsdatei-Trennung

Produktive Entwicklungsmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_DEV.miz

Riskante oder isolierte Tests dürfen eigene Missionskopien verwenden.

Aktuelle erfolgreiche CTLD-Testmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz

Grundsatz:

    Testmission != DEV-Mission

Erkenntnisse aus Testmissionen werden erst kontrolliert in die produktive Architektur übernommen.

---

# 28. Persistence-Schutz bei isolierten Tests

Wenn ein Test den produktiven Save potentiell beeinflussen könnte:

    Hash prüfen
    -> Backup erzeugen
    -> Backup verifizieren
    -> Save ReadOnly setzen
    -> ReadOnly verifizieren
    -> Test
    -> DCS vollständig beenden
    -> Hash erneut prüfen
    -> nur bei Match ReadOnly entfernen
    -> Hash nochmals bestätigen

Der ReadOnly-Schutz wird niemals während einer laufenden Testmission entfernt.

---

# 29. Testarchitektur

Grundregel:

    eine Aufgabe
    eine Datei
    ein Test
    eine klare Bewertung

Keine parallelen großen Änderungen.

Nach relevanten Lua-/Runtime-Änderungen prüfen:

- erwartete Modulversion
- erwartete Startmarker
- State Counts
- Dirty State
- Lua Errors
- DCS Scripting Errors
- Framework Errors
- Persistenz
- Nebenwirkungen

Kritische Marker:

    [TC][ERROR]
    SCRIPTING ERROR
    Mission script error
    stack traceback
    attempt to index
    attempt to call
    nil value
    protected call failed

---

# 30. Bekannte DCS-Meldungen

Nicht automatisch Theater-Command-Fehler:

- `DTC_MANAGER Window pointer is null`
- `LUA-TERRAIN getObjectPosition`
- `DX11BACKEND ... render target ... not found`
- `INVALID ATC`
- `ModelTimeQuantizer`
- `Destruction shape not found`
- einzelne Grafik-/Terrain-/ATC-Warnings

Sie werden nur dann relevant, wenn ein direkter Zusammenhang zum getesteten System besteht.

---

# 31. Zukünftige MOOSE-Architektur

MOOSE soll später insbesondere reale AI-Air-Assets bereitstellen.

Beispiele:

- CAP
- Strike
- SEAD
- DEAD
- CAS
- Escorts
- Carrier Air Wing

AICapManager bleibt dabei der Theater-Command-State-/Decision-Layer.

MOOSE wird Execution Layer.

Noch nicht produktiv:

    MOOSE CAP spawning

---

# 32. Zukünftige IADS-Architektur

Skynet IADS soll später:

- SAM-Systeme
- EWR
- Netzwerkzustand
- Abschaltlogik
- Reaktion auf Bedrohung

steuern.

Theater Command soll zusätzlich:

- Besitz
- Beschädigung
- Missionswirkungen
- Persistence
- AI-Entscheidungen

darüber verwalten.

Noch nicht produktiv angebunden.

---

# 33. Bodentruppen und CAS

Langfristig sollen Bodentruppen ein echter Teil des Kampagnensystems sein.

Perspektivischer Datenfluss:

    Ground Operation
    -> Gegnerkontakt
    -> Unterstützungsbedarf
    -> CAS Request
    -> MissionGenerator / AI Director
    -> verfügbare Luftfahrzeuge
    -> reale Mission
    -> Ergebnis
    -> Ground State

Dabei können unter anderem:

- A-10C II
- F/A-18C
- andere CAS-fähige Assets

verwendet werden.

Dieses System ist noch Zukunftsarchitektur.

---

# 34. Carrier Operations

Perspektivisch ist ein Carrier Task Group Bestandteil der Kampagne.

Vorgesehen:

- Supercarrier
- F/A-18C
- F-14
- spätere Carrier-fähige Module
- Carrier CAP
- Strike
- Escort
- Fleet Defense
- Carrier Logistics

Der Carrier soll operativ Teil der Kampagne sein und nicht lediglich statische Kulisse.

Noch nicht implementiert.

---

# 35. AI Director

Ein umfassender AI Director existiert noch nicht.

Später soll er unter anderem berücksichtigen:

- Ownership
- Capture Pressure
- Logistics
- FOBs
- Mission State
- CAP State
- Verluste
- IADS
- Bedrohungsniveau
- Frontlage
- verfügbare Ressourcen

Er erzeugt dann operative Entscheidungen.

Die aktuellen State-Systeme bilden die dafür notwendige Grundlage.

---

# 36. Aktuelle Datenflussarchitektur

Aktuell bestätigt:

    DCS World
    -> AirbaseScanner
    -> ZoneFactory
    -> Capture / Logistics
    -> FOB
    -> MissionGenerator
    -> AICapManager
    -> F10 / Persistence

Zusätzlich für Mission Outcomes:

    MissionGenerator
    -> Mission Effect
    -> CaptureSystem
    -> Capture Pressure
    -> Capture Ready
    -> Ownership
    -> Persistence

Neu technisch bestätigt:

    CTLD Runtime Configuration
    -> AI Transporter
    -> Pickup
    -> Flight
    -> Land
    -> Dropoff
    -> Ground Group

Noch fehlend:

    Theater Command Mission/Logistics State
    -> CTLD Transport Intent
    -> reale CTLD Operation
    -> Ergebnis
    -> Theater Command State

Diese fehlende Rückkopplung ist der zentrale Architekturpunkt von Priority 4.

---

# 37. Was aktuell bewusst nicht produktiv ist

Noch nicht aktiv:

- produktiver Startup Restore
- echte MOOSE-Spawns
- produktive TC-CTLD-Orchestrierung
- CTLD Crate Economy
- CTLD FOB Build
- Skynet-Kampagnenintegration
- AI Director
- automatische Missionserfolgsauswertung
- automatische Ground Campaign
- CAS-Automatisierung
- Carrier Operations
- Multiplayer-Validierung

Diese Punkte dürfen in Dokumentation nicht als bereits implementiert beschrieben werden.

---

# 38. Aktueller nächster Architekturbereich

Priority 3:

    abgeschlossen im dokumentierten Umfang

CTLD-KI-Truppentransport-PoC:

    bestanden

Nächster Bereich:

    Priority 4 – produktive CTLD-Integration

Vor dem ersten produktiven Code-Schritt ist zu entscheiden:

- welche fachliche `src/`-Komponente die Runtime-Konfiguration übernimmt
- wie CTLD-Zonen idempotent registriert werden
- wie Transporter idempotent registriert werden
- wie Transporter-Lifecycle behandelt wird
- wie `RepackCommandsPath` ohne Vendor-Patch behandelt wird
- wie Transportaufträge repräsentiert werden
- wie MissionGenerator und LogisticsDelivery angebunden werden
- wie CTLD-Ergebnisse validiert werden
- wie Erfolgsdaten in Theater Command zurückfließen
- welche Daten persistiert werden
- welche CTLD-Daten runtime-only bleiben

Keine generische `tc_ctld.lua`.

---

# 39. Start neuer Sessions

Neue Sessions beginnen mit einem GitHub-Audit.

Mindestens:

    README.md
    ROADMAP.md
    TASKS.md
    CHANGELOG.md
    ARCHITECTURE.md

Zusätzlich je nach Thema:

    AGENTS.md
    .agents/skills/theater-command/SKILL.md
    MISSION_EDITOR_SETUP.md
    docs/
    mission_editor/
    src/*/README.md

Nicht aus älterem Chatstand weiterarbeiten, wenn GitHub einen neueren Stand enthält.

---

# 40. Architekturleitsatz

Theater Command DCS folgt weiterhin:

    State zuerst.
    Frameworks als Execution Layer.
    Vendor unverändert.
    Kleine isolierte Schritte.
    Reale DCS-Runtime entscheidet über tatsächliches Simulatorverhalten.
    GitHub hält nur bestätigten Projektstand fest.

Aktueller Übergang:

    state-first Kampagnenkern
    +
    getesteter CTLD Framework-PoC
    ->
    kontrollierte produktive Framework-Integration
