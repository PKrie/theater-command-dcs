# CTLD-Startzonen – Operation Levant Reclamation

## 1. Zweck und Status

Stand:

    2026-09-29

Dieses Dokument beschreibt Benennung, Mission-Editor-Grundlage und praktisch bestätigte CTLD-Konfigurationsstrategie für die erste CTLD-Integration von Theater Command DCS.

Verbindlicher operativer Projektstand:

    TASKS.md

CTLD:

    Version 1.6.1

Vendor-Regel:

    vendor/ bleibt unverändert.

Aktueller Entwicklungsbereich:

    Priority 4 – produktive CTLD-Integration vorbereiten

Für den getesteten Aufbau bestätigt:

- CTLD-Pickup-Zonen können nach bestehender CTLD-Initialisierung als normalisierte Einträge in `ctld.pickupZones` ergänzt werden.
- CTLD-Dropoff-Zonen können entsprechend in `ctld.dropOffZones` ergänzt werden.
- eine erneute Ausführung von `ctld.initialize()` war für diesen getesteten Runtime-Pfad nicht erforderlich.
- CTLD verwendete die nachträglich ergänzten Zonen im laufenden Betrieb.
- der getestete KI-Transporter musste über seinen exakten Unit-Namen in `ctld.transportPilotNames` registriert sein, damit der relevante CTLD-AI-Pfad ihn verarbeitet.
- ein vollständiger KI-Truppentransport aus automatischem Pickup, Flug, Off-Airfield-Landung und automatischem Dropoff wurde am 2026-09-29 praktisch bestätigt.
- ein DCS-native `Perform Task -> Land` an einem normalen Turning-Point-Wegpunkt funktionierte für den getesteten Mi-8-Aufbau.
- der CTLD-Fehler `RepackCommandsPath` wurde genau einmal beim Touchdown beobachtet.

Noch nicht vorhanden:

    produktive Theater-Command-CTLD-Orchestrierung

Der erfolgreiche Test ist:

    Framework-Proof-of-Concept für den getesteten Aufbau

und nicht:

    universelle CTLD-Freigabe
    produktive Logistics-Integration
    produktive FOB-Integration

---

## 2. DEV-Mission und Testmission

Produktive Entwicklungsmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_DEV.miz

Die DEV-Mission bleibt der technische Haupt-Testträger des Projekts.

Für den CTLD-KI-Transporttest wurde bewusst eine separate Testmission verwendet.

Erfolgreicher Teststand vom 2026-09-29:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz

SHA-256 vor dem Runtime-Test:

    5F0D89DF744A7083401E36713B148BD21813FF187CC36EC1F088507163458C57

Grundregel:

    Testmission != DEV-Mission

Ein erfolgreicher isolierter Test wird nicht automatisch in die DEV-Mission übernommen.

---

## 3. Schutz der produktiven Persistence

Produktive Save-Datei:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Bestätigter SHA-256 vor und nach dem Test:

    C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596

Dateigröße:

    3094967 Bytes

Änderungszeit:

    2026-09-21 15:00:00.5926451

Backup vor dem Test:

    C:\Users\Paul\Documents\TC_miz_backups\operation_levant_reclamation_save__pre_landtask_test_2026-09-29_100813.lua

Während des Tests:

    produktive Save-Datei ReadOnly

Nach vollständig beendetem DCS bestätigt:

- Größe unverändert
- Änderungszeit unverändert
- SHA-256 unverändert
- Campaign-State unverändert

Anschließend wurde der Schreibschutz wieder entfernt.

Final:

    ReadOnly=False

Verbindlich:

    productiveRestore=false

---

## 4. Verbindliche CTLD-Zonennamen

Für Theater-Command-CTLD-Zonen gilt:

    NAMING_CONVENTIONS.md

Es werden keine abweichenden Projektbezeichnungen eingeführt, nur weil CTLD eigene Vendor-Default-Namen verwendet.

### Pickup-Zone Akrotiri

Verbindlicher Name:

    CTLD_PICKUP_BLUE_AKROTIRI_01

Schema:

    CTLD_PICKUP_SIDE_LOCATION_NUMBER

Bestätigte Eigenschaften:

    Bereich Akrotiri H1-H4
    Radius 250 m
    Blue

Diese Zone wurde praktisch verwendet.

Im erfolgreichen Test nahm der Mi-8 innerhalb dieser Zone automatisch:

    16 CTLD-Soldaten

auf.

Pickup-Zähler:

    10000 -> 9999

Der Transporter befand sich beim erfolgreichen Pickup ungefähr:

    87 m

vom Pickup-Zentrum entfernt.

---

## 5. Technische Test-Dropoff-Zone

Verwendete Testzone:

    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01

Schema:

    CTLD_DROPOFF_SIDE_LOCATION_ROLE_NUMBER

Mittelpunkt:

    x / North = -29249.110954281
    y / East beziehungsweise DCS-z = -271836.070539260

Radius:

    60 m

Koalition:

    Blue

Lage:

    Off-Airfield-Gelände westlich von Akrotiri

Diese Zone ist:

    technische Testzone

und kein:

    produktiver Kampagnen-Dropoff

---

## 6. Reservierter Ercan-Dropoff

Reservierter Name:

    CTLD_DROPOFF_BLUE_ERCAN_FOB_01

Schema:

    CTLD_DROPOFF_SIDE_LOCATION_ROLE_NUMBER

Dieser Name bleibt für eine mögliche spätere Transportoperation im Zusammenhang mit dem FOB-Projekt Ercan reserviert.

Aktueller Status:

    reserviert
    nicht produktiv verwendet

Die Rolle:

    FOB

beschreibt nur den vorgesehenen späteren Kampagnenzweck.

Sie bedeutet nicht, dass Ercan bereits durch CTLD versorgt oder aufgebaut wird.

---

## 7. Ältere Namensvorschläge

Ältere Dokumentationsstände enthielten unter anderem:

    CTLD_PICKUP_BLUE_AKROTIRI
    CTLD_DROPOFF_FOB_ERCAN

Diese Namen sind nicht mehr verbindlich.

Aktuell:

    CTLD_PICKUP_BLUE_AKROTIRI_01

    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01

    CTLD_DROPOFF_BLUE_ERCAN_FOB_01

---

## 8. CTLD-Zonenregistrierung

Die unveränderte Vendor-Datei:

    vendor/ctld/CTLD.lua

enthält eigene Pickup- und Dropoff-Konfiguration.

Theater-Command-Zonen werden dadurch nicht automatisch anhand ihrer Projektbenennung registriert.

### Praktisch bestätigter Runtime-Pfad

CTLD 1.6.1 war bereits initialisiert.

Danach wurden normalisierte Einträge ergänzt in:

    ctld.pickupZones

und:

    ctld.dropOffZones

Eine erneute Ausführung von:

    ctld.initialize()

war für diesen getesteten Runtime-Pfad nicht erforderlich und wurde nicht durchgeführt.

Daraus wird ausdrücklich nicht abgeleitet:

    ctld.initialize() darf grundsätzlich nie erneut aufgerufen werden.

Ebenso wird aus diesem Test keine allgemeine Aussage über sämtliche möglichen Nebenwirkungen einer erneuten Initialisierung abgeleitet.

Für Theater Command gilt zunächst nur:

    Der getestete Integrationspfad benötigt keine erneute Initialisierung.

---

## 9. Erfolgreich getesteter Pickup-Eintrag

Zur Laufzeit ergänzt:

    { "CTLD_PICKUP_BLUE_AKROTIRI_01", -1, 10000, 1, 2 }

Der Eintrag wurde anschließend aus:

    ctld.pickupZones

zurückgelesen und bestätigt.

CTLD verwendete ihn anschließend erfolgreich für den automatischen KI-Pickup.

Damit gilt für den getesteten Aufbau:

    Runtime-Registrierung der Pickup-Zone bestanden

---

## 10. Erfolgreich getesteter Dropoff-Eintrag

Zur Laufzeit ergänzt:

    { "CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01", -1, 2, 1 }

Der Eintrag wurde anschließend aus:

    ctld.dropOffZones

zurückgelesen und bestätigt.

CTLD verwendete ihn anschließend erfolgreich für den automatischen KI-Dropoff.

Damit gilt für den getesteten Aufbau:

    Runtime-Registrierung der Dropoff-Zone bestanden

---

## 11. Regeln für spätere automatische Zonenregistrierung

Eine produktive Theater-Command-Integration muss mindestens:

1. prüfen, ob CTLD verfügbar ist,
2. den vorhandenen Runtime-Zustand prüfen,
3. bestehende Pickup-Einträge erkennen,
4. bestehende Dropoff-Einträge erkennen,
5. fehlende Theater-Command-Zonen idempotent ergänzen,
6. normalisierte CTLD-Einträge verwenden,
7. Duplikate verhindern,
8. die getestete Integration nicht unnötig über eine erneute CTLD-Initialisierung aufbauen,
9. Vendor-Dateien unverändert lassen.

Die konkrete verantwortliche `src/`-Komponente ist noch nicht festgelegt.

Keine generische Framework-Datei wie:

    tc_ctld.lua
    tc_ctld_bridge.lua
    tc_ctld_all_in_one.lua

wird vorschnell angelegt.

---

## 12. KI-Transporterregistrierung

Der Test vom 2026-09-29 bestätigte eine zusätzliche CTLD-Voraussetzung.

Getestete Unit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Gruppe:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01

Luftfahrzeug:

    Mi-8

Der relevante getestete CTLD-AI-Pfad verarbeitete den Transporter erst nach Registrierung seines exakten Unit-Namens in:

    ctld.transportPilotNames

Vor der Registrierung:

    108 Einträge
    Testunit nicht enthalten

Temporär ergänzt wurde:

    table.insert(ctld.transportPilotNames, "TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01")

Nach der Registrierung:

    109 Einträge
    Testunit genau einmal enthalten

Die Registrierung war:

- idempotent vorbereitet
- duplikatfrei
- reine CTLD-Konfiguration

Sie war keine direkte Manipulation des transportierten Truppenstates.

---

## 13. Source-Befund zu `transportPilotNames`

Der CTLD-Source-Audit zeigte für den getesteten AI-Pfad:

    ctld.checkAIStatus()

iteriert über:

    ctld.transportPilotNames

Daraus folgt für die spätere produktive Theater-Command-Integration:

KI-Transporter dürfen nicht davon abhängen, zufällig bereits in der CTLD-Vendor-Default-Liste zu stehen.

Ihre Registrierung muss später:

- automatisch
- idempotent
- duplikatfrei
- lifecycle-sicher

durchgeführt werden.

Zu berücksichtigen sind insbesondere:

- Aktivierung
- möglicher späterer Spawn
- Despawn
- Wiederverwendung
- Missionsneustart
- Restore

---

## 14. Aktivierung des Testtransporters

Die Testgruppe wurde in der Runtime nativ aktiviert über:

    trigger.action.activateGroup()

Aktivierung erfolgte ungefähr:

    t=665 s

Aktiver Zustand bestätigt ungefähr:

    t=677 s

Für den belegten CTLD-Erfolg relevant sind:

- exakte Gruppe
- exakte Unit
- native Aktivierung
- CTLD-Transporterregistrierung
- Pickup-Zone
- gespeicherte Route
- gespeicherter Land-Task

Nicht als verbindliche Voraussetzung des erfolgreichen PoC dokumentiert werden:

- ein bestimmter Parkplatz H4
- ein bestimmter Hot-Start-Modus
- Late Activation als notwendige technische Voraussetzung

Diese Details sind für die bestätigte technische Schlussfolgerung nicht erforderlich belegt.

---

## 15. Bestätigter automatischer Pickup

Nach Aktivierung und CTLD-Registrierung erkannte CTLD den Mi-8 innerhalb der Pickup-Zone.

Bestätigtes Ergebnis:

    16 Soldaten automatisch geladen

Pickup-Zähler:

    10000 -> 9999

Bestätigter Abstand zum Pickup-Zentrum:

    ungefähr 87 m

Nicht verwendet:

- manuelles CTLD-Loading
- direkte Manipulation von `ctld.inTransitTroops`
- direkte Manipulation des Onboard-State
- Teleport
- Runtime-Routenänderung
- Runtime-Taskänderung

Damit ist für den getesteten Aufbau:

    automatischer CTLD-KI-Pickup bestanden

---

## 16. Flugphase

Nach erfolgreichem Pickup führte die DCS-AI die gespeicherte Mission selbständig weiter.

Beobachteter Ablauf:

    Taxi
    -> Takeoff
    -> Transit
    -> Descent
    -> Off-Airfield-Anflug
    -> Landung

Takeoff-Phase:

    ungefähr t=1051.6 bis 1081.7 s

Transit:

    ungefähr 100 m AGL
    ungefähr 30 m/s

Sinkflug:

    ab ungefähr t=1345 s

Keine Runtime-Routenänderung war erforderlich.

Keine Runtime-Taskänderung war erforderlich.

---

## 17. Off-Airfield-Landung

Frühere Tests vom 2026-09-21 mit einem ungebundenen:

    Land / Landing

Waypoint führten nicht zu einem vollständigen erfolgreichen Transportzyklus.

Der erfolgreiche Test vom 2026-09-29 verwendete einen anderen DCS-nativen Missionsaufbau.

Zielwegpunkt:

    normaler Turning Point

Name:

    LAND_OFFAIRFIELD

Position:

    x / North = -29249.110954281
    y / East beziehungsweise DCS-z = -271836.070539260

Höhe:

    100 m BARO

Geschwindigkeit:

    30 m/s

An diesem Wegpunkt war genau ein DCS-native:

    Perform Task -> Land

gespeichert.

Parameter:

    x = -29249.110954281
    y = -271836.070539260
    duration = 300
    durationFlag = true
    enabled = true

Keine Airbase-, FARP- oder Helipad-Bindung war für diesen getesteten Land-Task erforderlich.

---

## 18. Runtime-Ergebnis der Landung

Der Mi-8:

1. nahm automatisch 16 CTLD-Soldaten auf,
2. rollte selbständig,
3. startete,
4. flog die gespeicherte Route,
5. begann den Sinkflug,
6. landete im vorgesehenen Off-Airfield-Bereich,
7. setzte nahezu exakt im Dropoff-Zentrum auf.

Touchdown-Phase:

    ungefähr t=1405.9 bis 1426.0 s

Bestätigte minimale Entfernung zum Dropoff-Zentrum:

    ungefähr 1.06 m

Landeposition ungefähr:

    x = -29248.1
    z = -271836

Geschwindigkeit nach der Landung:

    ungefähr 0.01 m/s

Der Mi-8 blieb anschließend mindestens ungefähr:

    220 Sekunden

am Boden.

Der volle konfigurierte Zeitraum:

    duration=300

musste für den Dropoff-Nachweis nicht abgewartet werden.

Der CTLD-Dropoff war vorher bereits eindeutig erfolgt.

---

## 19. Bewertung des Landeverfahrens

Für den getesteten Mi-8-Aufbau ist praktisch bestätigt:

    Turning Point
    +
    DCS-native Perform Task -> Land
    ->
    erfolgreiche Off-Airfield-Landung

Für diesen getesteten Truppentransport war kein Invisible FARP erforderlich.

Daraus wird nicht abgeleitet:

- dass ein Invisible FARP grundsätzlich unnötig ist
- dass alle Luftfahrzeugtypen identisch reagieren
- dass alle Geländearten identisch funktionieren
- dass Cargo-/Crate-Pfade identische Anforderungen besitzen
- dass reale FOB-Infrastruktur keinen FARP benötigt

Der vorherige ungebundene:

    Land / Landing

Waypoint hatte keinen vollständigen erfolgreichen Transportzyklus ergeben.

Die neue Landemethode ist ein wesentlicher Unterschied zwischen den getesteten Aufbauten.

Nicht bewiesen ist jedoch:

- dass die fehlende Bindung des früheren Waypoints die Ursache des Turnbacks war
- dass die genaue Ursache des früheren Fehlverhaltens abschließend bestimmt wurde

---

## 20. Bestätigter automatischer CTLD-Dropoff

Nach der Landung erkannte CTLD den registrierten Transporter automatisch innerhalb der Dropoff-Zone.

Bestätigt:

- der `troops`-Inhalt verschwand aus dem In-Transit-State der Testunit,
- `ctld.droppedTroopsBLUE` erhielt genau einen neuen Eintrag,
- eine neue Blue-Bodengruppe wurde erzeugt.

Erzeugte Gruppe:

    Dropped Group 2

Group-ID:

    70001

Einheiten:

    16

Typ:

    Soldier M249

Die Bodengruppe bewegte sich anschließend unter normaler DCS-AI weiter.

Nicht verwendet:

- manuelles CTLD-Unload
- direkte Manipulation des Onboard-State
- Teleport
- Runtime-Routenänderung
- Runtime-Taskänderung

Damit ist für den getesteten Aufbau der technische Zyklus bestätigt:

    Pickup
    -> Taxi
    -> Takeoff
    -> Transit
    -> Off-Airfield-Landung
    -> automatischer CTLD-Dropoff
    -> reale Bodengruppe

---

## 21. `RepackCommandsPath`-Fehler

Beim **Touchdown** des registrierten KI-Transporters wurde genau einmal beobachtet:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Stack-Kontext:

    updateRepackMenu
    updateRepackMenuOnlanding

Während der anschließenden ungefähr 220 Sekunden Bodenbeobachtung wurde dieser Fehler nicht erneut beobachtet.

### Source-basierte Einordnung

Der untersuchte CTLD-Code führt den Landing-/Menüpfad auch für entsprechend registrierte Transporter aus.

Für eine reine KI-Unit ist:

    ctld.vehicleCommandsPath[_unitName]

nicht zwangsläufig vorhanden.

Ein daraus abgeleiteter:

    RepackCommandsPath

kann dadurch `nil` sein.

Der Vendor-Code behandelt diesen Zustand an der beobachteten Stelle nicht robust.

---

## 22. Bewertung des `RepackCommandsPath`-Fehlers

Trotz dieses Fehlers funktionierten im selben Test:

- automatischer Pickup
- Flug
- Off-Airfield-Landung
- automatischer Dropoff
- Erzeugung der Bodengruppe

Daraus wird nicht abgeleitet:

    der Fehler ist harmlos

Nicht direkt bewiesen ist:

- ob spätere Repack-Menü-Aktualisierungen funktionieren
- ob der betreffende Scheduler-Pfad anschließend weiterlief
- ob der betreffende Scheduler-Pfad anschließend beendet wurde

Dass ein unbehandelter Lua-Fehler den betreffenden Scheduler-Pfad beendet haben könnte, bleibt:

    source-basierte technische Inferenz

und ist kein:

    direkter Runtime-Beweis

Verbindlich:

    vendor/ctld/CTLD.lua wird nicht gepatcht.

Eine spätere produktive Integration muss diesen Punkt außerhalb des Vendor-Codes sauber behandeln oder isolieren.

---

## 23. Pickup-Zone und Cargo bleiben getrennt

Eine funktionierende Pickup-Zone für Truppen bedeutet nicht automatisch, dass CTLD-Cargo oder CTLD-Crates produktiv funktionieren.

Der erfolgreiche Test vom 2026-09-29 war:

    KI-Truppentransport

und kein:

    Cargo-/Crate-Test

Nicht bestätigt:

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
- FOB-Bau durch Crates
- Theater-Command-Supply-Effekt aus Cargo

Diese Funktionen benötigen eigene isolierte Tests.

---

## 24. Verhältnis zu Theater-Command-State

Der erfolgreiche CTLD-Test war bewusst ein isolierter Framework-Fähigkeitsnachweis.

Noch nicht produktiv implementiert:

- Transportauftrag aus Theater-Command-State
- automatische Auswahl eines KI-Transporters
- automatische Theater-Command-Zonenregistrierung
- automatische `transportPilotNames`-Registrierung
- LogisticsDelivery -> CTLD
- CTLD Dropoff -> LogisticsDelivery
- CTLD Dropoff -> FobSystem
- CTLD Dropoff -> Build Progress
- CTLD Dropoff -> Supply
- CTLD Dropoff -> Capture
- CTLD Dropoff -> AI Director
- CTLD-Runtime-State Restore

Diese Verknüpfungen werden nicht aus dem erfolgreichen PoC als vorhanden abgeleitet.

---

## 25. Invisible FARP

Ein Invisible FARP wurde als möglicher technischer Ansatz betrachtet.

Für den erfolgreichen getesteten KI-Truppentransport war er nicht erforderlich.

Bestätigt ist:

    Mi-8
    +
    geeigneter Off-Airfield-Bereich
    +
    Turning Point
    +
    Perform Task -> Land
    ->
    erfolgreiche Landung und CTLD-Dropoff

Eine spätere Verwendung von Invisible FARPs für:

- reale FOB-Infrastruktur
- Rearming
- Refueling
- Parking
- Cargo-/Crate-Prozesse
- andere Luftfahrzeuge
- andere Kampagnenfunktionen

bleibt davon unberührt.

---

## 26. Werkzeugtrennung

Für die CTLD-Tests gilt die aktuelle Entwicklungswerkzeug-Trennung.

### ChatGPT

Rolle:

- Projektkoordination
- Architektur
- Testplanung
- Ergebnisbewertung
- GitHub-Audit
- Dokumentationsführung

### Claude + dcs-mcp

Version:

    dcs-mcp 0.9.11

Verwendet für:

- `.miz`-Analyse
- Mission-Editor-Struktur
- Gruppen
- Units
- Zonen
- Wegpunkte
- Tasks
- Terrainprüfung
- gespeicherte Missionsänderungen
- gespeicherten Missionsaudit

Terrain Store:

    C:\Users\Paul\AppData\Local\dcs-mcp\terrain

Syria:

    installiert

### Claude Code + DCS-SMS

Version:

    DCS-SMS 0.27.2

Hook:

    me-bridge-0.27.2

Verifiziertes Installationsverzeichnis:

    C:\Tools\dcs-sms

Claude-Code-Skill:

    C:\Users\Paul\.claude\skills\dcs-sms\SKILL.md

Verwendet für:

- Mission-Editor-Status
- laufende DCS-Runtime
- Runtime-Lua
- CTLD-Live-State
- Unit-/Group-State
- Positions-/Flugzustandsbeobachtung
- Logauswertung
- Runtime-Regressionen

Aus dem bestätigten Stand wird kein exakter DCS-SMS-Executable-Pfad abgeleitet.

DCS-SMS ist:

    Entwicklungs- und Diagnosewerkzeug

und kein:

    Theater-Command-Runtime-Framework

---

## 27. Aktueller Integrationsstand

Für den getesteten Aufbau bestanden:

- CTLD 1.6.1 lädt und initialisiert.
- nachträgliche normalisierte Pickup-Zonenregistrierung funktioniert.
- nachträgliche normalisierte Dropoff-Zonenregistrierung funktioniert.
- erneute `ctld.initialize()`-Ausführung war für den getesteten Pfad nicht erforderlich.
- KI-Transporter kann über `ctld.transportPilotNames` registriert werden.
- CTLD erkennt den registrierten KI-Transporter im getesteten AI-Pfad.
- automatischer KI-Truppen-Pickup funktioniert.
- 16 Soldaten werden transportiert.
- DCS-native Off-Airfield-Landung über `Perform Task -> Land` funktioniert für den getesteten Mi-8-Aufbau.
- CTLD erkennt den gelandeten KI-Transporter in der Dropoff-Zone.
- automatischer CTLD-Dropoff funktioniert.
- eine 16-Mann-Bodengruppe wird erzeugt.
- für diesen getesteten Truppentransport war kein Invisible FARP erforderlich.
- produktive Persistence blieb während des isolierten Tests unverändert.
- Vendor-Dateien blieben unverändert.

Bekannter Integrationspunkt:

    RepackCommandsPath
    genau einmal beim Touchdown beobachtet

Noch nicht produktiv:

- automatische Theater-Command-Zonenregistrierung
- automatische KI-Transporterregistrierung
- Transportauftrag aus Campaign-State
- Cargo-/Crate-Transport
- LogisticsDelivery-Kopplung
- FobSystem-Kopplung
- realer FOB-Bau durch CTLD
- Supply-Effekt
- CTLD-Ergebnis-Persistence
- CTLD-Restore
- Multiplayer

---

## 28. Nächster technischer Architekturpunkt

Der isolierte KI-Truppentransport-PoC ist für den getesteten Aufbau abgeschlossen.

Der nächste Schritt ist deshalb nicht:

    denselben manuellen Transport erneut testen

Vor einer produktiven Integration muss festgelegt werden, wie Theater Command die bestätigten CTLD-Voraussetzungen in eigener fachlicher Logik unter:

    src/

verwaltet.

Mindestens zu klären:

1. welche fachliche Komponente den Transportauftrag besitzt,
2. wie Pickup-Zonen idempotent registriert werden,
3. wie Dropoff-Zonen idempotent registriert werden,
4. wie KI-Transporter idempotent in `ctld.transportPilotNames` registriert werden,
5. wie Aktivierung, Spawn, Despawn und Wiederverwendung behandelt werden,
6. wie `RepackCommandsPath` ohne Vendor-Patch behandelt oder isoliert wird,
7. wie Truppentransport und Cargo-/Crate-Transport getrennt bleiben,
8. wie reale Ergebnisse in LogisticsDelivery zurückgeführt werden,
9. wie reale Ergebnisse in FobSystem zurückgeführt werden,
10. welche Mutationen Dirty setzen,
11. welche Ergebnisse persistiert werden,
12. welche CTLD-Daten runtime-only bleiben,
13. was später nach Restore rekonstruiert werden muss.

Die konkrete Implementierungsdatei wird erst nach dieser Architekturentscheidung festgelegt.

Es gilt weiterhin:

    eine konkrete Aufgabe
    eine Datei
    ein Test
    eine klare Bewertung

Verbindlich:

    productiveRestore=false
