# TASKS – Theater Command DCS

## Verbindlicher Arbeitsstand — 2026-09-29

Dieses Dokument ist der operative Arbeitsstand für **Theater Command DCS**.

Repository:

    https://github.com/PKrie/theater-command-dcs

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue startet auf Zypern / Akrotiri.
    Das syrische Festland ist zu Kampagnenbeginn rot kontrolliert.

Grundarchitektur:

    Mission Editor = Bühne und konkrete DCS-Objekte
    Lua = Kampagnen- und Systemlogik
    GitHub = Source of Truth / Projektgedächtnis

Arbeitsregel:

    immer eine konkrete Aufgabe oder eine Datei pro Schritt

Vendor-Regel:

    vendor/ wird nicht verändert.

Eigene Logik:

    src/

Eigene Lua-Dateien werden nach fachlicher Aufgabe organisiert und nicht nach verwendetem Framework.

Nicht gewünscht:

    tc_moose.lua
    tc_mist.lua
    tc_ctld.lua
    tc_ctld_all_in_one.lua
    tc_all_in_one.lua

---

# 1. Aktueller Gesamtstand

Der state-first Kern der Kampagne ist funktionsfähig.

Bestätigt sind insbesondere:

- Airbase Scanner
- ZoneFactory
- CaptureSystem
- LogisticsDelivery
- FobSystem
- MissionGenerator
- AICapManager
- F10Menu
- dirty-aware Persistence
- Mission Completion
- Mission Failure
- Capture Ready Apply
- Capture Pressure
- Capture Progress
- Ownership Sync
- Logistics-/FOB-State
- AI-CAP-State
- Background Autosave
- Save-/Skip-/Failed-/Retry-Pfade
- CTLD-KI-Truppentransport als isolierter Framework-Proof-of-Concept

Noch nicht produktiv umgesetzt sind insbesondere:

- produktiver Persistence-Restore
- produktive Theater-Command-CTLD-Bridge
- CTLD-Crate-/Cargo-Wirtschaft
- reale CTLD-FOBs
- reale MOOSE-CAP-Flüge
- AI Director
- Skynet-IADS-Integration
- vollständige autonome Kampagnenoperationen
- Multiplayer-Validierung

`productiveRestore=false` bleibt verbindlich.

---

# 2. Aktuelle Systemversionen

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | bestanden |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.1` | bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.1` | bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | bestanden |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.1` | bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | Background Persistence bestanden |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` | Vendor geladen; KI-Truppentransport-PoC bestanden |

---

# 3. Priorität 1 – State-first Kampagnenkern

Status:

    ABGESCHLOSSEN für den aktuellen Entwicklungsstand

Bestätigt:

- Syria-Airbase-Scan
- relevante Kampagnenbasen
- Kampagnenzonen
- Ownership-State
- Capture Pressure
- Capture Progress
- Capture Ready
- Logistics Hubs
- FOB-Kandidaten
- state-only FOBs
- Mission Records
- AI CAP Requests
- F10-Debug-/Statusschicht

Aktuelle bestätigte Werte:

    Airbase-like Objects: 225
    Kampagnenzonen: 46

Logistics:

    Hubs: 46
    Blue: 7
    Red: 24
    Neutral: 15
    Active: 31
    Limited: 15
    Locked: 0

FOB:

    Candidates: 6
    Blue FOBs: 2

FOBs:

    FOB Ercan
    FOB Gecitkale

MissionGenerator:

    Mission Records: 10

AICapManager:

    CAP-Zonen: 12
    Candidates: 31
    Requests: 12

---

# 4. Priorität 2 – Persistence

Status:

    BACKGROUND SAVE BESTANDEN
    PRODUKTIVER RESTORE NOCH DEAKTIVIERT

PersistenceSystem:

    v0.2.6

Bestanden:

- Lua-Save-Datei schreiben
- Save-Datei lesen
- Read-back
- Compile
- Evaluate
- Validation
- Background Autosave
- dirty-aware `SAVED`
- unveränderter `SKIPPED`
- kontrollierter `FAILED`
- Retry
- Dirty erst nach erfolgreichem Save löschen
- Mission Completion persistieren
- Mission Failure persistieren
- Capture Ready Apply persistieren

Verbindlich:

    productiveRestore=false

Produktiver Restore wird erst freigegeben, wenn mindestens folgende Punkte separat geklärt sind:

- Restore-/Initialisierungsreihenfolge
- Save-Kompatibilität und Versionierung
- Lifecycle der State-Systeme beim Restore
- latente Restore-/Init-Punkte aus Priority 3
- Framework-Nebenwirkungen
- kontrollierter Restore-Test

Persistence darf nicht über F10 zu einem normalen Spielerworkflow werden.

Sie ist ein Hintergrundsystem.

---

# 5. Priorität 3 – Dirty-Coverage

Status:

    ABGESCHLOSSEN IM DOKUMENTIERTEN UMFANG
    Abschluss: 2026-09-21

Der projektweite READ-ONLY Dirty-Coverage-Audit der relevanten aktiven State-Systeme wurde durchgeführt.

## CaptureSystem

Behoben und live bestätigt:

- reine Capture-Getter erzeugen kein Dirty mehr
- Derived-Value-Berechnung markiert nur bei echter Änderung dirty
- redundante `setZoneOwner()`-/`setBaseOwner()`-Aufrufe verändern keinen persistierten State
- echte Mutationen markieren weiterhin zuverlässig dirty

## LogisticsDelivery

Version:

    v0.2.1

Read-Neutrality-Fix:

    ABGESCHLOSSEN

Bestätigt:

- `getStatistics()`
- `getHubSummary()`
- `summary()`

verändern keinen persistierten State und erzeugen kein Dirty.

Echte Mutation:

    createDelivery()

markiert weiterhin zuverlässig:

    logistics_delivery_created

Runtime-Regression bestanden.

## FobSystem

Version:

    v0.2.1

Read-Neutrality-Fix:

    ABGESCHLOSSEN

Getter verändern keinen persistierten FOB-State und erzeugen kein Dirty.

Echte Mutation über:

    FobSystem.create()

markiert weiterhin zuverlässig:

    fob_created

Runtime-Regression bestanden.

## MissionGenerator

Version:

    v0.2.3

READ-ONLY Audit abgeschlossen.

Kein aktiver Missing-Dirty-Bug gefunden.

Kein Code-Fix erforderlich.

Der frühere vermeintliche Mission-Record-Verlust war kein Datenverlust.

Ursache der damaligen Fehldiagnose:

    String-keyed Tables
    #table == 0
    obwohl pairs()-Records vorhanden waren

Der Count-/Diagnosefehler wurde bereits korrigiert.

## AICapManager

Version:

    v0.2.1

Read-Neutrality-Fix:

    ABGESCHLOSSEN

Getter verändern keinen persistierten AI-State und erzeugen kein Dirty.

Echte Mutation über:

    setCapStatus()

markiert weiterhin zuverlässig:

    ai_cap_record_changed

Runtime-Regression bestanden.

## Latente Punkte

Nicht automatisch durch Priority 3 behoben:

- `reactToActiveMissions()` bei späterer Verdrahtung
- bestimmte No-Op-Pfade
- Start-/Restore-Lifecycle
- mögliche State-Initialisierung beim Restore
- spätere Framework-Integration

Diese Punkte sind keine Begründung, Priority 3 erneut vollständig zu auditieren.

Sie werden behandelt, wenn der jeweilige Lifecycle beziehungsweise die jeweilige Integration produktiv angebunden wird.

---

# 6. Priorität 4 – CTLD-Integration

Status:

    FRAMEWORK-PROOF-OF-CONCEPT BESTANDEN
    PRODUKTIVE TC-INTEGRATION NOCH OFFEN

CTLD:

    1.6.1

Vendor-Dateien:

    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua

Vendor-Code bleibt unverändert.

---

## 6.1 CTLD-Zonen

Verbindlicher Pickup:

    CTLD_PICKUP_BLUE_AKROTIRI_01

Technische Test-Dropoff-Zone:

    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01

Reservierter späterer Ercan-Dropoff:

    CTLD_DROPOFF_BLUE_ERCAN_FOB_01

Bestätigt:

- normalisierte Pickup-Zonen können nach CTLD-Initialisierung in `ctld.pickupZones` ergänzt werden
- normalisierte Dropoff-Zonen können nach CTLD-Initialisierung in `ctld.dropOffZones` ergänzt werden
- CTLD verwendet diese Einträge tatsächlich
- `ctld.initialize()` muss und darf dafür nicht erneut ausgeführt werden

Details:

    mission_editor/ctld_start_zones.md

---

## 6.2 CTLD-KI-Transporter

Wichtiger Befund vom 2026-09-29:

CTLD verarbeitet einen Theater-Command-KI-Transporter nicht allein aufgrund seiner Position in einer CTLD-Zone.

Der exakte Unit-Name muss im verwendeten AI-Pfad in:

    ctld.transportPilotNames

registriert sein.

Getestete Unit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Test:

    vorher 108 transportPilotNames
    nach Registrierung 109
    Unit genau einmal vorhanden

Eine spätere Theater-Command-Integration muss diese Registrierung:

- automatisch
- idempotent
- ohne Duplikate
- lifecycle-sicher

durchführen.

---

## 6.3 CTLD-KI-Truppentransport

Testdatum:

    2026-09-29

Testmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz

SHA-256 vor Runtime-Test:

    5F0D89DF744A7083401E36713B148BD21813FF187CC36EC1F088507163458C57

Testgruppe:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01

Testunit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Typ:

    Mi-8MT

Ergebnis:

    BESTANDEN

Vollständiger bestätigter Ablauf:

    CTLD-Zonen registrieren
    -> Transporter registrieren
    -> Gruppe aktivieren
    -> automatischer Pickup
    -> Taxi
    -> Takeoff
    -> Transit
    -> Off-Airfield-Anflug
    -> Landung
    -> automatischer CTLD-Dropoff
    -> reale Blue-Bodengruppe

Pickup:

    16 Soldaten

Pickup Counter:

    10000 -> 9999

Keine direkte Manipulation von:

    ctld.inTransitTroops

Kein:

- manuelles Laden
- manuelles Unload
- Teleport
- Runtime-Rerouting
- Runtime-Taskwechsel

---

## 6.4 Off-Airfield-Landung

Erfolgreicher Ansatz:

    normaler Turning Point
    +
    DCS-native Perform Task Land

Dropoff-Zentrum:

    x = -29249.110954281
    z = -271836.070539260

Land-Task:

    duration = 300
    durationFlag = true

Touchdown:

    ungefähr 1.06 m vom Dropoff-Zentrum

Die Mi-8 blieb nach der Landung am Boden.

Ein Invisible FARP war nicht erforderlich.

Damit ist dieser Ansatz für den getesteten Mi-8-Pfad praktisch bestätigt.

Der vorherige ungebundene:

    Land / Landing

Wegpunkt wird nicht als bestätigter Off-Airfield-Ansatz verwendet.

---

## 6.5 CTLD-Dropoff

Ergebnis:

    BESTANDEN

Nach der Landung:

- 16 Soldaten wurden automatisch aus dem CTLD-Bordzustand entfernt
- `ctld.droppedTroopsBLUE` erhielt einen neuen Eintrag
- reale Blue-Bodengruppe wurde erzeugt

Gruppe:

    Dropped Group 2

Group-ID:

    70001

Einheiten:

    16 x Soldier M249

Damit ist der vollständige technische CTLD-KI-Truppentransport bewiesen.

---

## 6.6 CTLD `RepackCommandsPath`-Fehler

Reproduzierter Fehler:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Kontext:

    updateRepackMenu
    updateRepackMenuOnlanding

Der Fehler tritt beim Grounded-Übergang des KI-Transporters auf.

Aktuelle technische Einordnung:

- AI-Transporter befindet sich in `ctld.transportPilotNames`
- für AI existiert nicht zwangsläufig ein Player-/F10-`vehicleCommandsPath`
- Repack-Menü-Code erwartet diesen Pfad dennoch

Pickup und Dropoff wurden im Test trotzdem erfolgreich abgeschlossen.

Nicht bewiesen:

    dass der Fehler langfristig harmlos ist

Insbesondere muss geprüft werden, ob der unbehandelte Fehler den betreffenden Scheduler beendet.

Verbindlich:

    Kein Patch in vendor/ctld/CTLD.lua

Die Lösung muss TC-seitig beziehungsweise über eine saubere Integrationsstrategie erfolgen.

---

## 6.7 Was Priority 4 bereits beweist

Bestanden:

- CTLD geladen
- CTLD initialisiert
- Vendor unverändert
- Runtime-Pickup-Zonenregistrierung
- Runtime-Dropoff-Zonenregistrierung
- Transporterregistrierung
- automatischer KI-Pickup
- 16 Soldaten transportiert
- autonomer Flug
- Off-Airfield-Landung
- automatischer Dropoff
- reale 16-Mann-Bodengruppe
- produktive Persistence während isoliertem Test unverändert

Noch nicht produktiv:

- Theater-Command-CTLD-Bridge
- automatische TC-Zonenregistrierung
- automatische TC-Transporterregistrierung
- Transportauftrag aus MissionGenerator
- Crate-Spawn
- Crate-Loading
- Sling Load
- Crate-Drop
- FOB-Bau
- Supply-Effekt
- LogisticsDelivery-Rückkopplung
- FobSystem-Rückkopplung
- Capture-Rückkopplung
- AI-Director-Rückkopplung
- CTLD-Runtime-Persistence
- Multiplayer

---

# 7. Persistence-Schutz bei Framework-Tests

Produktive Save-Datei:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Nach dem CTLD-LANDTASK-Test bestätigt:

    Größe: 3094967 Bytes

SHA-256:

    C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596

Änderungszeit:

    2026-09-21 15:00:00.5926451

Der Hash war vor und nach dem Test identisch.

Damit wurde der produktive Kampagnenstand nicht verändert.

Verbindlicher Ablauf für isolierte Tests mit möglicher Persistence-Wirkung:

    aktuellen Hash prüfen
    -> Backup erzeugen
    -> Backup-Hash prüfen
    -> produktive Save-Datei ReadOnly setzen
    -> ReadOnly bestätigen
    -> Test durchführen
    -> DCS vollständig beenden
    -> Save-Datei erneut hashen
    -> Referenz vergleichen
    -> erst bei Hash-Match ReadOnly entfernen
    -> Hash nochmals bestätigen

Der Schreibschutz darf niemals während einer laufenden Testmission aufgehoben werden.

---

# 8. Entwicklungswerkzeuge

Der Entwicklungsworkflow wurde 2026-09-29 konkretisiert.

## 8.1 ChatGPT

Rolle:

- Projektkoordination
- Architektur
- Testplanung
- Ergebnisbewertung
- GitHub-Audit
- Dokumentationspflege
- Definition des nächsten Einzelschritts
- Claude-Prompts vorbereiten
- Ergebnisse aus Claude/dcs-mcp/DCS-SMS in den Projektstand einordnen

ChatGPT ist nicht die lokale DCS-Runtime.

---

## 8.2 Claude + dcs-mcp

Aktuelle Version:

    dcs-mcp 0.9.11

Verwendung:

- `.miz` strukturiert analysieren
- Mission-Editor-Inhalte prüfen
- Gruppen prüfen
- Units prüfen
- Trigger Zones prüfen
- Wegpunkte prüfen
- Tasks prüfen
- gespeicherte Missionsänderungen durchführen
- Missionsdatei vor Runtime-Test auditieren

Aktuelle Terrain-Daten umfassen:

    Syria

dcs-mcp wird für strukturierte `.miz`-/Mission-Editor-Arbeit verwendet.

Es ist kein Runtime-Framework von Theater Command.

---

## 8.3 Claude Code + DCS-SMS

DCS-SMS-Version:

    0.27.2

Hook:

    me-bridge-0.27.2

Lokaler Pfad:

    C:\Tools\dcs-sms\dcs-sms.exe

Claude-Code-Skill:

    C:\Users\Paul\.claude\skills\dcs-sms\SKILL.md

Verwendung:

- Mission-Editor-Status
- laufende DCS-Mission
- Runtime-Lua
- CTLD-Live-State
- Unit-State
- Position
- Geschwindigkeit
- Ground-/Airborne-State
- Logs
- kontrollierte Aktivierung
- Runtime-Regressionen

DCS-SMS ist Entwicklungs- und Diagnosewerkzeug.

DCS-SMS ist keine Runtime-Abhängigkeit der fertigen Kampagne.

---

## 8.4 Werkzeugtrennung

Verbindlicher Workflow:

    ChatGPT
    -> koordiniert Projekt, Architektur und Testziel

    Claude + dcs-mcp
    -> bearbeitet beziehungsweise prüft .miz / Mission Editor

    Claude Code + DCS-SMS
    -> prüft lokale Mission-Editor-/DCS-Runtime

    DCS
    -> liefert den realen Runtime-Beweis

    GitHub
    -> hält den bestätigten Projektstand fest

Keine Aussage aus einem Offline-Tool ersetzt einen tatsächlichen DCS-Runtime-Test, wenn die Funktion DCS-Laufzeitverhalten betrifft.

---

# 9. Mission-Editor-Teststand

Produktive Entwicklungsmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_DEV.miz

CTLD-Testmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz

Die Testmission ist kein Ersatz für die DEV-Mission.

Riskante Framework-Experimente werden weiterhin isoliert durchgeführt.

Die DEV-Mission wird nicht blind durch Testmissionen ersetzt.

---

# 10. Priorität 5 – MOOSE AI-Spawns

Status:

    NOCH NICHT NÄCHSTER SCHRITT

Ziele:

- MOOSE-CAP-Templates
- Blue-/Red-CAP-Templates
- Spawn-Zonen
- AICapManager mit realen MOOSE-Spawns verbinden
- CAP-Lifecycle
- Mission-/Threat-Reaktion
- Persistence-Grenze definieren

Aktuell:

    AICapManager erzeugt State
    keine realen CAP-Flüge

---

# 11. Priorität 6 – Skynet IADS

Status:

    NOCH NICHT NÄCHSTER SCHRITT

Ziele:

- SAM-/EWR-Struktur
- klare Gruppennamen
- IADS-Aktivierung
- IADS-State
- Missionsziele
- Persistence-Grenze
- Wiederherstellung
- SEAD-/DEAD-Integration

Vendor:

    Skynet IADS bleibt unverändert unter vendor/

---

# 12. Spätere operative Architektur

Langfristiges Ziel:

Der Spieler soll Teil des Kampagnensystems sein und nicht dessen alleiniger Auslöser.

Perspektivisch sollen Blue und Red möglichst autonom:

- Missionen erzeugen
- CAP fliegen
- Bodentruppen bewegen
- Logistik durchführen
- FOBs aufbauen
- Nachschub transportieren
- CAS anfordern
- Bedrohungen reagieren
- IADS betreiben
- Carrier Operations durchführen
- Gebiete erobern und verlieren

Der Spieler kann dabei Missionen übernehmen beziehungsweise in laufende Operationen eingreifen.

F10 bleibt vor allem:

- Status
- Debug
- kontrollierte Tests
- ausgewählte Spielerinteraktionen

und soll nicht zur manuellen Steuerzentrale aller Hintergrundprozesse werden.

---

# 13. Perspektivische Systeme

Geplant beziehungsweise architektonisch vorgesehen:

- Supercarrier
- Carrier Task Group
- F/A-18C
- F-14
- spätere Carrier-Flugzeuge
- Carrier CAP
- Carrier Strike
- Carrier Logistics
- A-10C II
- CAS
- Bodentruppen
- Bodentruppen-CAS-Anforderungen
- Transporthelikopter
- FOB-System
- Convoys
- AI Director
- Red AI Operations
- Blue AI Operations
- IADS
- dynamische Missionsgenerierung
- langfristige Persistence

Diese Punkte sind Perspektive und nicht als bereits implementiert zu dokumentieren.

---

# 14. Aktuelle technische Grenzen

Noch nicht als fertig betrachten:

- echter Cargo-Fluss
- Crate-Wirtschaft
- echte FOB-Infrastruktur
- echte CAP-Spawns
- CAS-Automatisierung
- AI Director
- IADS
- Carrier Operations
- produktiver Restore
- Kampagnenfortsetzung über Neustarts
- Multiplayer
- vollständige Blue-/Red-Autonomie

---

# 15. Nächster technischer Entwicklungsbereich

Priority 3 ist abgeschlossen.

Der CTLD-KI-Truppentransport-Proof-of-Concept ist ebenfalls abgeschlossen.

Der nächste technische Schritt ist deshalb **nicht**:

- erneut LogisticsDelivery auditieren
- erneut FobSystem auditieren
- erneut AICapManager auditieren
- denselben Mi-8-Transport erneut manuell testen
- Vendor-CTLD verändern
- sofort einen Invisible FARP bauen

Der nächste Entwicklungsbereich bleibt:

    Priority 4 – produktive CTLD-Integration vorbereiten

Vor dem ersten produktiven Code-Schritt muss die Integrationsgrenze festgelegt werden.

Zu entscheiden beziehungsweise zu untersuchen:

- welche eigene `src/`-Komponente die CTLD-Konfiguration übernimmt
- wie Pickup-/Dropoff-Zonen idempotent registriert werden
- wie KI-Transporter idempotent registriert werden
- wie Transporter-Lifecycle behandelt wird
- wie `RepackCommandsPath` ohne Vendor-Modifikation behandelt wird
- wie MissionGenerator einen Transportauftrag erzeugt
- wie DCS-/CTLD-Erfolg zurück in Theater-Command-State gelangt
- wie LogisticsDelivery und FobSystem darauf reagieren
- welche Daten runtime-only bleiben
- welche Resultate persistiert werden

Die konkrete Datei wird erst nach Architekturprüfung festgelegt.

Keine generische Framework-Datei nur mit dem Namen:

    tc_ctld.lua

---

# 16. Startpunkt für die nächste Session

Die nächste Session beginnt immer mit einem aktuellen GitHub-Audit.

Mindestens prüfen:

- `README.md`
- `ROADMAP.md`
- `TASKS.md`
- `CHANGELOG.md`
- `ARCHITECTURE.md`
- `AGENTS.md`
- `.agents/skills/theater-command/SKILL.md`
- `MISSION_EDITOR_SETUP.md`
- `docs/00_project_overview.md`
- `docs/02_technical_architecture.md`
- `docs/03_mission_editor_basics.md`
- `docs/05_logistics_system.md`
- `docs/09_persistence.md`
- `docs/10_testing.md`
- `mission_editor/README.md`
- `mission_editor/ctld_start_zones.md`
- `mission_editor/trigger_setup.md`

Danach den aktuellen Missionsstand prüfen, bevor `.miz` verändert wird.

Für Mission-Editor-/`.miz`-Arbeit bevorzugt:

    Claude + dcs-mcp

Für lokale DCS-/Mission-Editor-Runtime:

    Claude Code + DCS-SMS

Für Projektkoordination:

    ChatGPT

Nächster fachlicher Ausgangspunkt:

    Priority 4
    produktive CTLD-Integration aus dem bestandenen Proof-of-Concept ableiten

Erster Schritt:

    Architektur und aktuellen Code prüfen,
    dann genau eine konkrete Integrationsaufgabe beziehungsweise Datei bestimmen.

Nicht erneut ohne neuen Anlass testen:

- Mission Completion
- Mission Failure
- Capture Ready Apply
- Capture Getter Read-Neutrality
- Capture Ownership No-Op
- LogisticsDelivery Read-Neutrality
- FobSystem Read-Neutrality
- AICapManager Read-Neutrality
- identischen CTLD-LANDTASK-PoC

---

# 17. Bekannte CTLD-Sonderpunkte für die nächste Session

Nicht vergessen:

1. `ctld.initialize()` nicht erneut ausführen.
2. Pickup-/Dropoff-Zonen können nach Init in die normalisierten Live-Tabellen ergänzt werden.
3. KI-Transporter benötigen Registrierung in `ctld.transportPilotNames`.
4. `Turning Point + Perform Task Land` ist für den getesteten Mi-8-Off-Airfield-Pfad bestätigt.
5. Invisible FARP war dafür nicht erforderlich.
6. `RepackCommandsPath` ist ein realer reproduzierter Fehler.
7. Vendor-CTLD wird nicht gepatcht.
8. Truppentransport-PoC ist nicht gleich Crate-/Cargo-PoC.
9. CTLD-PoC ist nicht gleich produktive Theater-Command-Integration.
10. Persistence bei isolierten Tests weiterhin schützen.

---

# 18. Bekannte Persistence-Sonderpunkte

Nicht vergessen:

- `productiveRestore=false`
- Save-Datei ist produktiver Kampagnenstate
- isolierte Tests dürfen diesen State nicht unkontrolliert verändern
- vor riskanten Tests Hash + Backup + ReadOnly
- ReadOnly erst nach beendetem DCS und erfolgreicher Nachprüfung entfernen
- Restore-Lifecycle ist weiterhin ein eigener zukünftiger Arbeitsschritt

---

# 19. Dokumentationsregel

Nach relevanten technischen Meilensteinen wird GitHub synchronisiert.

Während aktiver Entwicklung:

    nur notwendige Dokumentation aktualisieren

Am Sessionende:

    vollständigen Dokumentationsabgleich durchführen

Historische Testdetails gehören primär in:

    CHANGELOG.md
    docs/10_testing.md

Aktueller operativer Arbeitsstand gehört primär in:

    TASKS.md

Architekturentscheidungen gehören primär in:

    ARCHITECTURE.md
    docs/02_technical_architecture.md

Mission-Editor-/CTLD-Details gehören primär in:

    MISSION_EDITOR_SETUP.md
    mission_editor/
    docs/03_mission_editor_basics.md
    docs/05_logistics_system.md

---

# 20. Aktueller Abschluss

Stand:

    2026-09-29

Abgeschlossen:

    state-first Kern
    Priority 3 Dirty-Coverage im dokumentierten Umfang
    LogisticsDelivery Read-Neutrality
    FobSystem Read-Neutrality
    AICapManager Read-Neutrality
    Capture Dirty-/No-Op-Fixes
    dirty-aware Background Persistence
    CTLD-KI-Truppentransport Proof-of-Concept

Aktuell nächste Entwicklungsphase:

    Priority 4 – produktive CTLD-Integration vorbereiten

Noch nicht freigegeben:

    productiveRestore

Noch nicht implementiert:

    produktive TC-CTLD-Bridge

Wichtigster neuer technischer Befund:

    Ein registrierter CTLD-KI-Transporter kann mit einem
    DCS-native Perform Task Land einen vollständigen automatischen
    Pickup -> Flug -> Off-Airfield-Landung -> Dropoff-Zyklus durchführen.

Bekannter Blocker beziehungsweise Integrationspunkt:

    CTLD RepackCommandsPath bei AI-Grounded-Transition

Arbeitsweise bleibt:

    eine Aufgabe
    eine Datei
    ein Test
    eine klare Bewertung
