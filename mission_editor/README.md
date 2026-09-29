# Mission Editor

Dieser Ordner dokumentiert alle Arbeiten, Strukturen und Tests, die im DCS Mission Editor für **Theater Command DCS** vorbereitet oder durchgeführt werden.

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Aktueller verbindlicher Stand:

    2026-09-29

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland rot kontrolliert

Technische Hauptmission:

    Operation_Levant_Reclamation_DEV.miz

Isolierte erfolgreiche CTLD-Testmission:

    Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz

---

## 1. Grundprinzip

Das zentrale Arbeitsprinzip lautet:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis / Source of Truth
    DCS Runtime = autoritativer Verhaltensbeweis

Der Mission Editor stellt die physische DCS-Welt bereit.

Dazu gehören insbesondere:

- Karte
- Koalitionen
- Airbases
- Client-Slots
- KI-Gruppen
- Template-Gruppen
- Trigger
- Trigger-Zonen
- Wegpunkte
- DCS-native Tasks
- Statics
- FARPs
- eingebettete Lua-Ressourcen

Die eigentliche Theater-Command-Kampagnenlogik liegt unter:

    src/

Externe Frameworks liegen unter:

    vendor/

Vendor-Dateien werden für Theater Command nicht verändert.

---

## 2. Zweck dieses Ordners

Der Ordner:

    mission_editor/

dokumentiert Mission-Editor-nahe Projektbestandteile.

Dazu gehören:

- Trigger-Setup
- Lua-Ladekette
- CTLD-Zonen
- Mission-Editor-Testobjekte
- Client-Slots
- spätere Template-Gruppen
- spätere IADS-Gruppen
- spätere statische Ziele
- technische Mission-Editor-Testaufbauten

Nicht hier hinein gehört:

- eigentliche Kampagnenlogik
- Framework-Sourcecode
- Persistence-Save-Dateien
- AI-Entscheidungslogik
- vollständige Missionsgenerierung
- eigene fachliche Lua-Module

---

## 3. Aktuelle Dateien

Aktuell vorhanden:

    mission_editor/README.md
    mission_editor/trigger_setup.md
    mission_editor/ctld_start_zones.md

Noch nicht angelegt:

    mission_editor/client_slots.md
    mission_editor/template_groups.md
    mission_editor/static_targets.md

Neue Dateien werden nur erstellt, wenn ein realer Projektbedarf besteht.

Es werden keine leeren Platzhalterdateien nur zur Vervollständigung der Ordnerstruktur angelegt.

---

## 4. Aktueller Mission-Editor-Stand

Bestätigt beziehungsweise vorhanden:

- Syria Map
- Koalitionspreset Modern
- Akrotiri als Blue-Ausgangspunkt
- F/A-18C Blue Client-Slot
- Vendor-Ladekette
- Theater-Command-Ladekette
- F10Menu
- Background Persistence
- CTLD-Pickup-Testzone
- CTLD-Dropoff-Testzone
- Mi-8-Testtransporter im isolierten Testaufbau
- DCS-native Off-Airfield-Landung
- automatischer CTLD-Pickup
- automatischer CTLD-Dropoff

Noch nicht produktiv vollständig vorhanden:

- Frontlinie
- vollständige Red-IADS-Struktur
- MOOSE-CAP-Templates
- Strike-Templates
- SEAD-/DEAD-Templates
- Ground-Operation-Templates
- CTLD-Crate-Infrastruktur
- produktive CTLD-FOBs
- Carrier Task Group
- vollständige Client-Slot-Struktur
- produktiver Startup-Restore
- vollständige Multiplayer-Validierung

---

## 5. DEV-Mission

Aktuelle technische Entwicklungsmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_DEV.miz

Aufgabe dieser Mission:

- Theater-Command-Haupttestträger
- Vendor-Ladetests
- Lua-Ladetests
- state-first Runtime
- Capture-Tests
- MissionGenerator-Tests
- Logistics-/FOB-State
- AI-CAP-State
- F10-Testbed
- Persistence
- spätere kontrollierte Framework-Integration

Die DEV-Mission ist weiterhin keine fertige dynamische Kampagne.

Sie ist der kontrollierte Entwicklungsstand.

---

## 6. Isolierte Testmissionen

Riskante oder klar abgegrenzte Framework-Experimente dürfen in separaten Missionskopien durchgeführt werden.

Aktuell relevant:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz

SHA-256 vor dem erfolgreichen Runtime-Test:

    5F0D89DF744A7083401E36713B148BD21813FF187CC36EC1F088507163458C57

Diese Mission wurde verwendet, um den CTLD-KI-Truppentransport isoliert zu testen.

Verbindlich:

    Testmission != DEV-Mission

Ein erfolgreicher Test in einer Testmission verändert die DEV-Mission nicht automatisch.

Erkenntnisse werden erst nach Bewertung kontrolliert übernommen.

---

## 7. Koalitionsauswahl

Aktuelles Koalitionspreset:

    Modern

Fachliche Vorgabe:

    Blue startet auf Akrotiri / Zypern.
    Red kontrolliert zu Kampagnenbeginn das syrische Festland.

Für den aktuellen Entwicklungsstand ist diese Auswahl ausreichend.

Die Koalitionsstruktur kann später erweitert werden.

---

## 8. Spieler-Slot

Aktueller erster Blue-Client-Slot:

    CLIENT_BLUE_FA18C_AKROTIRI_01

Eigenschaften:

    Flugzeug: F/A-18C Lot 20
    Seite: Blue
    Land: USA
    Startbasis: Akrotiri
    Skill: Client

Da es sich um einen Client-Slot handelt, muss beim manuellen Missionsstart die Slotauswahl berücksichtigt werden.

Normaler Ablauf:

    Mission starten
    -> CLIENT_BLUE_FA18C_AKROTIRI_01 auswählen
    -> Auswahl bestätigen
    -> Briefing öffnen
    -> Fly

Dieser Slot ist noch kein finaler Kampagnenslot.

Perspektivisch vorgesehen sind unter anderem:

- F/A-18C
- F-14
- F-15E
- A-10C II
- AH-64D
- weitere Module nach Bedarf

---

## 9. Vendor-Framework-Ladung

Externe Frameworks:

    vendor/mist/mist.lua
    vendor/moose/Moose.lua
    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua
    vendor/skynet-iads/SkynetIADS.lua

Bestätigte Reihenfolge:

    1. MIST
    2. MOOSE
    3. CTLD-i18n
    4. CTLD
    5. Skynet IADS

Wichtig:

    MIST vor CTLD
    CTLD-i18n vor CTLD
    Theater Command nach den Vendor-Frameworks

Vendor-Dateien werden nicht verändert.

Aktueller CTLD-Stand:

    CTLD 1.6.1

---

## 10. Aktive eigene Source-Dateien

Aktuell aktiv:

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
    src/main.lua
    src/loader.lua

Vorbereitet beziehungsweise dokumentiert:

    src/iads/
    src/debug/

Eigene Source wird nach fachlicher Aufgabe organisiert.

Nicht gewünscht:

    tc_moose.lua
    tc_mist.lua
    tc_ctld.lua
    tc_ctld_all_in_one.lua
    tc_ctld_bridge.lua
    tc_all_in_one.lua

---

## 11. Aktueller Modulstand

| System | Version | Status |
|---|---:|---|
| Airbase Scanner | `v0.2.2` | bestanden |
| ZoneFactory | `v0.2.0` | bestanden |
| CaptureSystem | `v0.2.2` | bestanden |
| PersistenceSystem | `v0.2.6` | Background Persistence bestanden |
| LogisticsDelivery | `v0.2.1` | bestanden |
| FobSystem | `v0.2.1` | bestanden |
| MissionGenerator | `v0.2.3` | bestanden |
| AICapManager | `v0.2.1` | bestanden |
| F10Menu | `v0.2.3` | bestanden |
| CTLD | `1.6.1` | KI-Truppentransport-PoC für getesteten Aufbau bestanden |

Priority 3 – Dirty-Coverage – ist seit:

    2026-09-21

im dokumentierten Umfang abgeschlossen.

Aktueller Projektbereich:

    Priority 4 – produktive CTLD-Integration vorbereiten

---

## 12. Airbase Scanner

Aktueller bestätigter Stand:

    Airbase-like Objects: 225

Davon unter anderem:

    strategic: 19
    secondary: 13
    heliports: 1
    helipads: 95
    medical: 40
    tactical: 13
    unknown: 44

Capture Candidates:

    32

Logistics Candidates:

    46

Nicht alle 225 Airbase-like Objects werden direkt zu Kampagnenzonen.

---

## 13. ZoneFactory

Aktueller bestätigter Stand:

    relevante Kampagnenzonen: 46

Davon:

    strategic zones: 19
    secondary zones: 13
    heliport zones: 1
    tactical zones: 13
    captureZones: 32
    missionZones: 32
    logisticsZones: 46
    startBaseZones: 1

Übersprungene Airbase-like Objects:

    179

Damit ist die World-/Zone-Schicht fachlich gefiltert.

---

## 14. Sichere Trigger-Strategie

Die bestätigte Trigger-Strategie bleibt:

    sichere Einzeldatei-Ladung

Aktive Dateien werden über:

    DO SCRIPT FILE

geladen.

Diese Variante bleibt aktueller Standard.

Vorteile:

- klare Ladefolge
- klare Fehlerzuordnung
- gute Debugbarkeit
- keine zusätzliche `dofile`-Abhängigkeit
- kontrollierbare Embedded-Ressourcen
- real in DCS bestätigt

---

## 15. Trigger-Reihenfolge

Vendor:

    TIME MORE 1
    vendor/mist/mist.lua

    TIME MORE 2
    vendor/moose/Moose.lua

    TIME MORE 3
    vendor/ctld/CTLD-i18n.lua

    TIME MORE 4
    vendor/ctld/CTLD.lua

    TIME MORE 5
    vendor/skynet-iads/SkynetIADS.lua

Theater Command:

    TIME MORE 7
    src/core/tc_config.lua

    TIME MORE 8
    src/core/tc_logger.lua

    TIME MORE 9
    src/core/tc_state.lua

    TIME MORE 10
    src/core/tc_utils.lua

    TIME MORE 11
    src/core/tc_scheduler.lua

    TIME MORE 12
    src/world/tc_airbase_scanner.lua

    TIME MORE 13
    src/world/tc_zone_factory.lua

    TIME MORE 14
    src/campaign/tc_capture_system.lua

    TIME MORE 15
    src/campaign/tc_persistence_system.lua

    TIME MORE 16
    src/logistics/tc_logistics_delivery.lua

    TIME MORE 17
    src/logistics/tc_fob_system.lua

    TIME MORE 18
    src/missions/tc_mission_generator.lua

    TIME MORE 19
    src/ai/tc_ai_cap_manager.lua

    TIME MORE 20
    src/ui/tc_f10_menu.lua

    TIME MORE 21
    src/main.lua

    TIME MORE 22
    src/loader.lua

Details:

    mission_editor/trigger_setup.md

---

## 16. Eingebettete Lua-Ressourcen

Bei:

    DO SCRIPT FILE

wird die ausgewählte Lua-Datei in die `.miz` eingebettet.

Deshalb gilt:

    GitHub aktualisiert
    !=
    .miz automatisch aktualisiert

Nach einer Source-Änderung muss geprüft werden, welche Embedded-Ressource tatsächlich in der Mission gespeichert ist.

Der Embedded Resource Audit vom 2026-09-12 bestätigte für den damaligen Stand:

    13/13 relevante aktive Theater-Command-Ressourcen EXACT_MATCH
    keine aktive Embedded Source Drift
    DEV und damalige Testkopie byte-identisch

Der Audit ist ein zeitpunktbezogener Befund.

Spätere Source-Änderungen müssen bei Bedarf erneut gegen die `.miz` geprüft werden.

---

## 17. Persistence-Ressource

Aktiver Trigger:

    TC_LOAD_TC_PERSISTENCE_SYSTEM

Aktive Persistence-Version:

    v0.2.6

Aktive Embedded-Ressource:

    tc_persistence_system_v0_2_6.lua

Historische Altressource:

    ResKey_Action_55
    tc_persistence_system.lua

Letzter bestätigter Stand:

- alter Trigger-Verweis entfernt
- Ressource selbst weiterhin als verwaister Eintrag vorhanden
- kein aktiver Trigger referenziert sie
- sie wird nicht geladen
- sie ist kein aktueller Blocker

Ein späteres Cleanup ist möglich, aber kein gegenwärtiger Entwicklungsschritt.

---

## 18. F10Menu

Aktueller Stand:

    F10Menu v0.2.3
    33 Commands

Bestätigt sind unter anderem:

- Mission Details
- Mission Activation
- Mission Completion Test
- Mission Failure Test
- Capture Status
- Capture Ready
- Pressure Contested
- Capture Apply
- Logistics Status
- FOB Status
- AI CAP Status

F10 dient aktuell hauptsächlich:

- Status
- Debug
- kontrollierten Testaktionen

F10 soll langfristig nicht alle Kampagnenprozesse manuell steuern.

---

## 19. Aktueller state-first Runtime-Stand

Bestätigt:

    Mission Details
    -> Mission Activation
    -> Mission Completion
    -> Mission Effects
    -> Capture Pressure
    -> Capture Progress
    -> Capture Ready
    -> Capture Apply
    -> Zone Ownership
    -> Linked Airbase Ownership
    -> Background Autosave

Mission Failure:

    Mission Activation
    -> Mission Failure
    -> Failure Effects
    -> kein Capture Pressure
    -> Background Autosave

Persistence:

    dirty-aware
    SAVED
    SKIPPED
    FAILED
    Retry

Produktiver Restore:

    productiveRestore=false

---

## 20. CTLD-Dokumentation

Spezifische CTLD-Zonen und Tests werden dokumentiert in:

    mission_editor/ctld_start_zones.md

Dort dokumentiert sind unter anderem:

- Akrotiri Pickup-Zone
- technischer Dropoff westlich Akrotiri
- reservierter Ercan-Dropoff
- Runtime-Registrierung
- KI-Transporterregistrierung
- erfolgreicher Pickup
- Off-Airfield-Landung
- automatischer Dropoff
- bekannte CTLD-Einschränkung

---

## 21. CTLD-Pickup-Zone Akrotiri

Verbindlicher Name:

    CTLD_PICKUP_BLUE_AKROTIRI_01

Radius:

    250 m

Die Zone liegt im Bereich Akrotiri.

Sie wurde im erfolgreichen isolierten CTLD-KI-Truppentransport praktisch verwendet.

---

## 22. CTLD-Test-Dropoff

Technischer Testname:

    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01

Zentrum:

    x / North = -29249.110954281
    z / East  = -271836.070539260

Radius:

    60 m

Diese Zone ist ausdrücklich:

- technische Testzone
- kein produktiver FOB-Dropoff

---

## 23. Ercan-Dropoff

Reservierter späterer Name:

    CTLD_DROPOFF_BLUE_ERCAN_FOB_01

Dieser Name ist für eine spätere produktive FOB-/Logistiknutzung reserviert.

Der erfolgreiche Test vom 2026-09-29 fand nicht an diesem Ercan-Dropoff statt.

---

## 24. CTLD-Zonenregistrierung

Für den getesteten Runtime-Pfad praktisch bestätigt:

Nach bestehender CTLD-Initialisierung konnten normalisierte Zonen in den Live-Tabellen ergänzt werden:

    ctld.pickupZones
    ctld.dropOffZones

Getesteter Pickup-Eintrag:

    { "CTLD_PICKUP_BLUE_AKROTIRI_01", -1, 10000, 1, 2 }

Getesteter Dropoff-Eintrag:

    { "CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01", -1, 2, 1 }

CTLD verwendete beide Einträge tatsächlich.

Eine erneute Ausführung von:

    ctld.initialize()

war für diesen getesteten Runtime-Pfad nicht erforderlich.

Daraus wird nicht abgeleitet, dass ein erneuter Aufruf von `ctld.initialize()` grundsätzlich verboten wäre.

Produktive Registrierung muss später:

- automatisch
- idempotent
- duplikatfrei
- lifecycle-sicher

erfolgen.

---

## 25. CTLD-KI-Transporter

Erfolgreiche Testgruppe:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01

Erfolgreiche Unit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Luftfahrzeug:

    Mi-8

Wichtiger Runtime- und Source-Befund:

Der exakte Unit-Name musste im relevanten getesteten CTLD-AI-Pfad in:

    ctld.transportPilotNames

registriert sein.

Vor temporärer Registrierung:

    108 Einträge

Danach:

    109 Einträge

Die Testunit war genau einmal enthalten.

Eine produktive Theater-Command-Integration muss diese Registrierung später:

- automatisch
- idempotent
- duplikatfrei
- lifecycle-sicher

durchführen.

---

## 26. Aktivierung

Die Testgruppe wurde über die native DCS-Funktion:

    trigger.action.activateGroup()

aktiviert.

Runtime-Beobachtung:

    Aktivierung ungefähr t=665 s
    Gruppe aktiv ungefähr t=677 s

Es war keine nachträgliche Runtime-Routen- oder Taskmanipulation für den erfolgreichen Transportzyklus erforderlich.

---

## 27. Erfolgreicher CTLD-Pickup

Nach nativer Aktivierung erfolgte der Pickup automatisch.

Bestätigt:

    16 Soldaten aufgenommen
    Pickup-Counter 10000 -> 9999

Der Transporter befand sich beim Pickup ungefähr:

    87 m

vom Pickup-Zentrum entfernt.

Nicht verwendet:

- manuelles CTLD-Loading
- Teleport
- direkte Manipulation des CTLD-Onboard-State
- Runtime-Routenänderung
- Runtime-Taskänderung

Damit ist der automatische CTLD-AI-Pickup für den getesteten Aufbau bestätigt.

---

## 28. Transportflug

Nach dem Pickup führte die DCS-KI den Flug selbständig aus.

Runtime-Verlauf:

    Taxi
    -> Takeoff
    -> Transit
    -> Descent
    -> Off-Airfield-Anflug

Takeoff-Phase:

    ungefähr t=1051.6 bis 1081.7 s

Transit:

    ungefähr 100 m AGL
    ungefähr 30 m/s

Descent:

    ungefähr ab t=1345 s

Der Flug wurde ohne nachträgliche Runtime-Routenänderung durchgeführt.

---

## 29. Off-Airfield-Landung

Der erfolgreiche Missionsaufbau war:

    normaler Turning Point
    +
    DCS-native Perform Task -> Land

Wegpunkt:

    Position: technisches Dropoff-Zentrum
    Höhe: 100 m BARO
    Geschwindigkeit: 30 m/s

Land Task:

    duration=300
    durationFlag=true

Touchdown-Phase:

    ungefähr t=1405.9 bis 1426.0 s

Bestätigte minimale Entfernung zum Dropoff-Zentrum:

    ungefähr 1.06 m

Bodengeschwindigkeit anschließend:

    ungefähr 0.01 m/s

Der Transporter blieb mindestens ungefähr:

    220 s

am Boden.

Der volle `duration=300`-Zeitraum musste für den Nachweis des CTLD-Dropoffs nicht abgewartet werden, da der automatische Dropoff vorher eindeutig erfolgt war.

Für diesen getesteten Truppentransport war kein Invisible FARP erforderlich.

Der zuvor getestete ungebundene:

    Land / Landing

Waypoint führte nicht zu einem vollständigen erfolgreichen Transportzyklus.

Der erfolgreiche neue Aufbau zeigt einen relevanten Unterschied in der Landemethode.

Die genaue Ursache des früheren Turnbacks ist dadurch nicht abschließend bewiesen.

---

## 30. Erfolgreicher CTLD-Dropoff

Nach der Landung entlud CTLD die transportierten Soldaten automatisch.

Bestätigt:

- der `troops`-Inhalt verschwand aus dem In-Transit-State der Testunit
- `ctld.droppedTroopsBLUE` erhielt genau einen neuen Eintrag
- eine reale Blue-Bodengruppe wurde erzeugt

Erzeugte Gruppe:

    Dropped Group 2

Group-ID:

    70001

Stärke:

    16

Unit-Typ:

    Soldier M249

Die Bodengruppe bewegte sich anschließend unter normaler DCS-AI weiter.

Nicht verwendet:

- manuelles CTLD-Unload
- direkte Manipulation des Onboard-State
- Teleport
- Runtime-Routenänderung
- Runtime-Taskänderung

Damit ist für den getesteten Aufbau bestätigt:

    Pickup
    -> Transport
    -> Off-Airfield-Landung
    -> automatischer Dropoff
    -> reale Bodengruppe

---

## 31. Bekannter CTLD-Fehler

Beim Touchdown des registrierten KI-Transporters wurde genau einmal folgender Fehler beobachtet:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Kontext:

    updateRepackMenu
    updateRepackMenuOnlanding

Während der anschließenden ungefähr 220 Sekunden Bodenbeobachtung wurde der Fehler nicht erneut beobachtet.

Source-basierte Einordnung:

- KI-Transporter war in `ctld.transportPilotNames` registriert.
- dadurch erreichte die Unit einen CTLD-Landing-/Menüpfad.
- für reine KI-Units existiert nicht zwangsläufig ein Player-/F10-`vehicleCommandsPath`.
- daraus kann ein `RepackCommandsPath` von `nil` entstehen.
- der Vendor-Code behandelt diesen Fall an der beobachteten Stelle nicht robust.

Der automatische Pickup-/Dropoff-Pfad wurde trotzdem abgeschlossen.

Nicht bewiesen:

- dass der Fehler harmlos ist
- dass spätere Repack-Menü-Aktualisierungen funktionieren
- dass der betreffende Scheduler definitiv weiterlief
- dass der betreffende Scheduler definitiv beendet wurde

Ein mögliches Ende des Scheduler-Pfads nach dem unbehandelten Lua-Fehler ist eine technische Inferenz und kein direkter Runtime-Beweis.

Verbindlich:

    vendor/ctld/CTLD.lua wird nicht gepatcht.

Der Fall muss vor produktiver Integration außerhalb des Vendor-Codes sauber behandelt oder isoliert werden.

---

## 32. CTLD-Truppentransport ist nicht gleich Cargo

Der bestandene Test betrifft:

    KI-Truppentransport

Noch nicht bestätigt:

- Crate Spawn
- Crate Loading
- Sling Load
- Crate Drop
- Supply Cargo
- Engineering Cargo
- Repair Cargo
- Fuel Cargo
- Ammo Cargo
- FOB Core
- produktiver FOB-Bau
- LogisticsDelivery-Rückkopplung
- FobSystem-Rückkopplung
- CTLD-Restore
- Multiplayer

Diese Bereiche benötigen eigene Tests.

---

## 33. Grenze des CTLD-PoC

Für den getesteten Aufbau bestätigt:

- Runtime-Zonenregistrierung
- KI-Transporterregistrierung
- automatischer Pickup
- autonomer Transportflug
- Off-Airfield-Landung
- automatischer Dropoff
- reale Blue-Bodengruppe

Noch nicht bestätigt:

    produktive Theater-Command-CTLD-Orchestrierung

Theater Command erzeugt aktuell noch nicht selbständig einen produktiven CTLD-Transportauftrag und verarbeitet dessen Ergebnis nicht automatisch in LogisticsDelivery oder FobSystem.

---

## 34. Persistence-Schutz bei Tests

Produktive Save-Datei:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Bestätigter SHA-256:

    C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596

Größe:

    3094967 Bytes

Änderungszeit:

    2026-09-21 15:00:00.5926451

Backup vor dem erfolgreichen CTLD-Test:

    C:\Users\Paul\Documents\TC_miz_backups\operation_levant_reclamation_save__pre_landtask_test_2026-09-29_100813.lua

Der CTLD-Test vom 2026-09-29 hat die produktive Save-Datei nicht verändert.

Bestätigt:

- Größe unverändert
- Änderungszeit unverändert
- SHA-256 unverändert
- Campaign-State unverändert

Nach beendetem DCS:

    ReadOnly=False

Verbindlich:

    productiveRestore=false

Bei Tests mit möglicher Persistence-Wirkung:

    aktuellen Hash prüfen
    -> Backup erzeugen
    -> Backup-Hash verifizieren
    -> produktiven Save ReadOnly setzen
    -> ReadOnly bestätigen
    -> Test durchführen
    -> DCS vollständig beenden
    -> Save erneut hashen
    -> Hash vergleichen
    -> nur bei Match ReadOnly entfernen
    -> final erneut prüfen

---

## 35. Entwicklungswerkzeuge

Der Mission-Editor-Workflow verwendet eine klare Werkzeugtrennung.

Diese Werkzeuge sind Entwicklungs- und Diagnosewerkzeuge.

Sie sind keine Runtime-Abhängigkeiten der fertigen Kampagne.

---

## 36. ChatGPT

ChatGPT übernimmt:

- Projektkoordination
- Architektur
- GitHub-Audit
- Dokumentationsführung
- Testplanung
- Bewertung von Ergebnissen
- Festlegung des nächsten Einzelschritts
- Erstellung präziser Arbeitsaufträge

ChatGPT ersetzt keinen realen DCS-Runtime-Test.

---

## 37. Claude + dcs-mcp

Bevorzugter Pfad für:

- `.miz`-Analyse
- Mission-Editor-Strukturanalyse
- Gruppen
- Units
- Trigger-Zonen
- Wegpunkte
- Tasks
- Ressourcen
- Airbase-Zuordnungen
- gezielte `.miz`-Änderungen
- gespeicherten Missionsaudit

Aktuelle Version:

    dcs-mcp 0.9.11

Terrain Store:

    C:\Users\Paul\AppData\Local\dcs-mcp\terrain

Syria-Terrain-Daten:

    installiert

Vor Mission-Editor-Änderungen wird der aktuelle Missionsstand zuerst gelesen.

Es wird keine Mission blind neu aufgebaut.

---

## 38. Claude Code + DCS-SMS

Bevorzugter Pfad für lokale Runtime-Arbeit.

DCS-SMS:

    0.27.2

Hook:

    me-bridge-0.27.2

Verifiziertes Installationsverzeichnis:

    C:\Tools\dcs-sms

Claude-Code-Skill:

    C:\Users\Paul\.claude\skills\dcs-sms\SKILL.md

Einsatz:

- Mission-Editor-Status
- Runtime-Lua
- Theater-Command-State
- CTLD-Live-State
- Gruppen-/Unit-State
- Position
- Geschwindigkeit
- Grounded/Airborne
- native Aktivierung
- Logs
- Runtime-Regressionen

Aus dem aktuell bestätigten Stand wird kein exakter DCS-SMS-Executable-Pfad abgeleitet.

DCS-SMS ist kein Bestandteil der Kampagnen-Runtime.

---

## 39. Verbindlicher Workflow

Für `.miz`-/Mission-Editor-/Framework-Arbeit:

    ChatGPT
    -> Ziel und Testkriterium festlegen

    Claude + dcs-mcp
    -> aktuelle Mission lesen
    -> konkrete Änderung durchführen
    -> gespeicherte Mission erneut auditieren

    Claude Code + DCS-SMS
    -> lokale Runtime prüfen

    DCS
    -> tatsächliches Simulatorverhalten beweisen

    ChatGPT
    -> Ergebnis einordnen

    GitHub
    -> bestätigten Stand dokumentieren

Pro Schritt gilt:

    eine konkrete Aufgabe

Keine großen parallelen Mission-Editor-Umbauten.

---

## 40. DCS ist der Runtime-Beweis

Offline-Analyse kann sicher feststellen:

- gespeicherte Missionsstruktur
- Gruppen
- Zonen
- Tasks
- Trigger
- eingebettete Ressourcen

Offline-Analyse allein beweist jedoch nicht:

- tatsächliches KI-Taxi-Verhalten
- Takeoff
- AI-Navigation
- Landung
- CTLD-Pickup
- CTLD-Dropoff
- Scheduler-Verhalten
- Runtime-Spawn

Solche Punkte werden in DCS selbst getestet.

---

## 41. Evidenzklassen

Ergebnisse werden klar getrennt in:

    Source-Befund
    gespeicherte Missionsstruktur
    Runtime-Beobachtung
    technische Inferenz

Beispiel:

    Perform Task -> Land ist gespeichert
    =
    Missionsstruktur

    Mi-8 landet tatsächlich im Ziel
    =
    Runtime-Beobachtung

    unbehandelter Lua-Fehler könnte Scheduler-Pfad beendet haben
    =
    technische Inferenz

Diese Kategorien dürfen nicht miteinander vermischt werden.

---

## 42. DCS-Log

Typische Pfade:

    C:\Users\Paul\Saved Games\DCS\Logs\dcs.log

oder:

    C:\Users\Paul\Saved Games\DCS.openbeta\Logs\dcs.log

Für saubere Regressionstests bevorzugt:

    alten Log sichern oder löschen
    -> DCS neu starten
    -> genau einen Test durchführen
    -> DCS beenden
    -> Log auswerten

Ein fortgeschriebener Log ist möglich, wenn der neue Testabschnitt eindeutig abgegrenzt werden kann.

---

## 43. Relevante Fehlerindikatoren

Besonders relevant:

    [TC][ERROR]
    SCRIPTING ERROR
    Mission script error
    stack traceback
    attempt to index
    attempt to call
    nil value
    protected call failed

Nicht automatisch Theater-Command-Fehler:

- `INVALID ATC`
- `DTC_MANAGER Window pointer is null`
- `LUA-TERRAIN getObjectPosition`
- Terrain-Warnings
- Grafik-Warnings
- Asset-Warnings
- `Destruction shape not found`

Der Zusammenhang mit dem getesteten System entscheidet.

---

## 44. Naming im Mission Editor

Trigger:

    TC_LOAD_

Beispiele:

    TC_LOAD_MIST
    TC_LOAD_MOOSE
    TC_LOAD_CTLD_I18N
    TC_LOAD_CTLD
    TC_LOAD_SKYNET_IADS
    TC_LOAD_TC_CONFIG
    TC_LOAD_TC_LOGGER
    TC_LOAD_TC_STATE
    TC_LOAD_TC_UTILS
    TC_LOAD_TC_SCHEDULER
    TC_LOAD_TC_AIRBASE_SCANNER
    TC_LOAD_TC_ZONE_FACTORY
    TC_LOAD_TC_CAPTURE_SYSTEM
    TC_LOAD_TC_PERSISTENCE_SYSTEM
    TC_LOAD_TC_LOGISTICS_DELIVERY
    TC_LOAD_TC_FOB_SYSTEM
    TC_LOAD_TC_MISSION_GENERATOR
    TC_LOAD_TC_AI_CAP_MANAGER
    TC_LOAD_TC_F10_MENU
    TC_LOAD_TC_MAIN
    TC_LOAD_TC_LOADER

Aktuelle CTLD-Zonen:

    CTLD_PICKUP_BLUE_AKROTIRI_01
    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01
    CTLD_DROPOFF_BLUE_ERCAN_FOB_01

Beispielhafte spätere Templates:

    TC_TEMPLATE_RED_CAP_MIG29_01
    TC_TEMPLATE_BLUE_LOGISTICS_UH60_01
    TC_TEMPLATE_RED_SAM_SA6_01

Vollständige Regeln:

    NAMING_CONVENTIONS.md

---

## 45. Was im Mission Editor vermieden wird

Nicht gewünscht:

- große Kampagnenlogik über Triggerketten
- Capture ausschließlich per Mission-Editor-Trigger
- Missionsgenerator ausschließlich per Trigger
- Logistiklogik ausschließlich per Trigger
- AI-Entscheidungen ausschließlich per Trigger
- Persistence ausschließlich per Trigger
- unstrukturierte Namen
- zufällige lokale Dateiquellen
- direkte Änderungen an Vendor-Dateien
- unkontrollierte Runtime-Manipulation
- mehrere große Änderungen gleichzeitig
- produktive Übernahme eines unbestätigten Testbefundes

Mission Editor bleibt Bühne.

Lua bleibt Kampagnensystem.

---

## 46. Spätere Mission-Editor-Dateien

### `mission_editor/client_slots.md`

Späterer Zweck:

- Client-Slot-Struktur
- Flugzeugtypen
- Rollen
- Startbasen
- Kampagnenslots

Aktuell:

    nicht erstellt

### `mission_editor/template_groups.md`

Späterer Zweck:

- CAP-Templates
- Strike-Templates
- SEAD-/DEAD-Templates
- Logistics-Templates
- Ground-Templates
- IADS-Templates

Aktuell:

    nicht erstellt

### `mission_editor/static_targets.md`

Späterer Zweck:

- Depots
- Infrastruktur
- Radar
- SAM
- Logistikziele
- strategische Strike-Ziele

Aktuell:

    nicht erstellt

---

## 47. Loader-only-Variante

Eine Loader-only-Variante mit:

    dofile

ist weiterhin nicht der aktuelle Standard.

Sie kann später als Komfort-/Build-Schritt separat getestet werden.

Bis dahin bleibt:

    sichere Einzeldatei-Ladung

die bestätigte Methode.

---

## 48. Aktueller nächster Mission-Editor-Bereich

Der nächste Schritt ist nicht:

- komplette Mission umbauen
- sofort neue IADS-Struktur bauen
- sofort MOOSE-CAP-Templates bauen
- denselben CTLD-PoC erneut durchführen
- Vendor-CTLD patchen
- sofort produktive FOBs bauen
- sofort Crates integrieren

Der nächste technische Bereich ist:

    Priority 4 – produktive Theater-Command-CTLD-Integration vorbereiten

Zuerst muss die Integrationsarchitektur festgelegt werden.

Zu klären:

- welche fachliche `src/`-Komponente einen Transportauftrag besitzt
- welche Komponente CTLD-Zonen registriert
- welche Komponente KI-Transporter registriert
- wie die Registrierung idempotent bleibt
- wie Transporter-Lifecycle behandelt wird
- wie `RepackCommandsPath` ohne Vendor-Patch behandelt wird
- wie Transportaufträge erzeugt werden
- wie Pickup, Erfolg und Fehler erkannt werden
- wie Ergebnisse validiert werden
- wie Ergebnisse in LogisticsDelivery und FobSystem zurückgeführt werden
- welche Resultate Dirty setzen
- was persistiert wird
- was runtime-only bleibt
- was nach einem späteren Restore rekonstruiert werden muss

Erst danach ergibt sich die nächste konkrete Mission-Editor-Aufgabe.

Keine generische Framework-Datei wie:

    tc_ctld.lua
    tc_ctld_bridge.lua

vorschnell anlegen.

---

## 49. Neue Sessions

Eine neue Session beginnt mit dem aktuellen GitHub-Stand.

Mindestens prüfen:

- `README.md`
- `ROADMAP.md`
- `TASKS.md`
- `CHANGELOG.md`
- `ARCHITECTURE.md`

Für Mission-Editor-/CTLD-Arbeit zusätzlich:

- `AGENTS.md`
- `.agents/skills/theater-command/SKILL.md`
- `MISSION_EDITOR_SETUP.md`
- `docs/02_technical_architecture.md`
- `docs/03_mission_editor_basics.md`
- `docs/05_logistics_system.md`
- `docs/09_persistence.md`
- `docs/10_testing.md`
- `mission_editor/README.md`
- `mission_editor/ctld_start_zones.md`
- `mission_editor/trigger_setup.md`
- `src/logistics/README.md`

Danach aktuelle `.miz` prüfen.

Für `.miz`-/Mission-Editor-Arbeit:

    Claude + dcs-mcp

Für lokale DCS-/Runtime-Arbeit:

    Claude Code + DCS-SMS

Für Projektkoordination:

    ChatGPT

---

## 50. Aktueller Status

Stand:

    2026-09-29

Bestätigt:

    Mission-Editor-Ladekette funktioniert.
    Airbase Scanner funktioniert.
    ZoneFactory erzeugt 46 relevante Kampagnenzonen.
    F10Menu funktioniert.
    state-first Kampagnenpipeline funktioniert.
    dirty-aware Persistence funktioniert.
    Priority 3 ist im dokumentierten Umfang abgeschlossen.
    productiveRestore=false.
    CTLD-Zonenregistrierung funktioniert für den getesteten Aufbau.
    CTLD-KI-Transporterregistrierung funktioniert für den getesteten Aufbau.
    automatischer Pickup funktioniert für den getesteten Aufbau.
    autonomer Mi-8-Transportflug funktioniert für den getesteten Aufbau.
    Off-Airfield-Landung über Perform Task Land funktioniert für den getesteten Aufbau.
    automatischer CTLD-Dropoff funktioniert für den getesteten Aufbau.
    reale Blue-Bodengruppe wurde erzeugt.
    kein Invisible FARP war für diesen getesteten Truppentransport erforderlich.
    CTLD RepackCommandsPath bleibt bekannter Integrationspunkt.
    Crate-/Cargo-Pfad ist separat noch offen.
    Claude + dcs-mcp ist der bevorzugte .miz-/Mission-Editor-Pfad.
    Claude Code + DCS-SMS ist der bevorzugte lokale Runtime-Pfad.
    GitHub bleibt Source of Truth.
    DCS bleibt autoritativer Runtime-Beweis.

Aktueller Übergang:

    state-first Kampagnenkern
    +
    dirty-aware Persistence
    +
    abgeschlossene Priority-3-Dirty-Coverage
    +
    bestandener CTLD-KI-Truppentransport-PoC
    ->
    kontrollierte produktive CTLD-Integration
