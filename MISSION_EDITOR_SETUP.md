# Mission Editor Setup

Diese Datei beschreibt den verbindlichen Mission-Editor-, `.miz`- und DCS-Testworkflow für **Theater Command DCS**.

Erste Kampagne:

- **Operation Levant Reclamation**

Map:

- **Syria**

Aktueller verbindlicher Stand:

- **2026-09-29**

Ausgangslage:

- Blue startet auf Akrotiri / Zypern.
- Das syrische Festland ist zu Beginn rot kontrolliert.
- Blue soll sich vom Brückenkopf Zypern aus auf das syrische Festland vorarbeiten.
- Red hält zu Beginn den Großteil der strategischen Flugplätze.
- Der Spieler soll sich in eine laufende Kampagne einklinken und nicht jede Aktion allein auslösen.

---

## 1. Grundsatz

Der DCS Mission Editor ist in Theater Command DCS nicht das eigentliche Kampagnensystem.

Der Mission Editor stellt die physische Bühne bereit.

Die dynamische Kampagne wird durch Lua gesteuert.

Grundprinzip:

- Mission Editor = Bühne
- Lua = Kampagnensystem
- GitHub = Projektgedächtnis / Source of Truth

Der Mission Editor stellt insbesondere bereit:

- Karte
- Koalitionen
- Airbases
- Client-Slots
- KI-Gruppen
- Template-Gruppen
- Trigger
- Trigger-Zonen
- Wegpunkte
- Tasks
- Statics
- FARPs
- eingebettete Lua-Ressourcen

Die eigentliche Kampagnenlogik liegt unter:

    src/

Große Kampagnenlogik soll nicht als komplexe Mission-Editor-Triggerkette aufgebaut werden.

---

## 2. Aktueller Mission-Editor-Stand

Aktuelle DEV-Mission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_DEV.miz

Aktuelle isolierte erfolgreiche CTLD-Testmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz

SHA-256 dieser Testmission vor dem erfolgreichen Runtime-Test:

    5F0D89DF744A7083401E36713B148BD21813FF187CC36EC1F088507163458C57

Die DEV-Mission bleibt der technische Haupt-Testträger.

Die CTLD-LANDTASK-Testmission ist eine isolierte Testmission.

Verbindlich:

    Testmission != DEV-Mission

Erkenntnisse aus einer Testmission werden nicht automatisch in die DEV-Mission übernommen.

---

## 3. Aktueller technischer Projektstand

Der state-first Kampagnenkern ist für den aktuellen Entwicklungsstand bestätigt.

Aktive Systeme:

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
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` | KI-Truppentransport-PoC bestanden |

Priority 3 – Dirty-Coverage – ist seit 2026-09-21 im dokumentierten Umfang abgeschlossen.

Aktueller Entwicklungsbereich:

    Priority 4 – produktive CTLD-Integration vorbereiten

---

## 4. Aktuelle DEV-Mission

Dateiname:

    Operation_Levant_Reclamation_DEV.miz

Aktuell bestätigt beziehungsweise vorgesehen:

- Map: Syria
- Koalitionspreset: Modern
- Blue Start: Akrotiri / Zypern
- F/A-18C Client-Slot auf Akrotiri
- Vendor-Framework-Ladung
- Theater-Command-Lua-Ladung
- F10Menu
- state-first Campaign Runtime
- Background Persistence

Die DEV-Mission ist weiterhin ein Entwicklungs- und Testträger.

Sie ist noch keine fertige dynamische Kampagnenmission.

Noch nicht produktiv vollständig umgesetzt:

- Frontlinie
- operative Red-IADS-Struktur
- produktive CTLD-Transportaufträge
- CTLD-Crate-Wirtschaft
- reale CTLD-FOBs
- reale MOOSE-CAP-Flüge
- AI Director
- Ground Campaign
- CAS-Automatisierung
- Carrier Operations
- produktiver Startup-Restore
- vollständige Multiplayer-Validierung

---

## 5. Koalitionen

Aktuelles DCS-Koalitionspreset:

- Modern

Fachliche Ausgangsvorgabe:

- Blue startet auf Akrotiri / Zypern.
- Red kontrolliert zu Kampagnenbeginn das syrische Festland.

Diese Konfiguration ist für den aktuellen Entwicklungsstand ausreichend.

Sie kann später bei Bedarf erweitert werden.

---

## 6. Spieler-Slot

Aktueller erster Blue-Client-Slot:

- Flugzeug: F/A-18C Lot 20
- Koalition: Blue
- Land: USA
- Startort: Akrotiri
- Starttyp: Parkplatz
- Skill: Client
- Name: `CLIENT_BLUE_FA18C_AKROTIRI_01`

Da der Slot ein `CLIENT` und kein `PLAYER` ist, muss beim normalen Runtime-Test die Client-Slotauswahl berücksichtigt werden.

Normaler manueller Teststart:

1. Mission starten.
2. `CLIENT_BLUE_FA18C_AKROTIRI_01` auswählen.
3. Slot bestätigen.
4. Briefing öffnen.
5. `Fly` drücken.

Der Slot ist noch kein finaler Kampagnen-Slot.

Perspektivisch vorgesehen sind unter anderem:

- F/A-18C
- F-14
- F-15E
- A-10C II
- AH-64D
- weitere Module nach Bedarf

---

## 7. Vendor-Frameworks

Externe Frameworks liegen unter:

    vendor/

Vendor-Dateien werden nicht verändert.

Aktive Frameworks:

| Framework | Pfad | Stand |
|---|---|---:|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD-i18n | `vendor/ctld/CTLD-i18n.lua` | geladen |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Vendor-Ladefolge:

1. `vendor/mist/mist.lua`
2. `vendor/moose/Moose.lua`
3. `vendor/ctld/CTLD-i18n.lua`
4. `vendor/ctld/CTLD.lua`
5. `vendor/skynet-iads/SkynetIADS.lua`

Wichtig:

- MIST wird vor CTLD geladen.
- CTLD-i18n wird vor CTLD.lua geladen.
- eigene Theater-Command-Logik startet nach den Vendor-Frameworks.
- Framework-Code unter `vendor/` bleibt unverändert.

---

## 8. Aktive eigene Source-Dateien

Eigene Logik liegt unter:

    src/

Aktuell aktive Dateien:

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

Eigene Logik wird nach fachlicher Aufgabe organisiert.

Nicht erwünscht sind insbesondere:

    tc_moose.lua
    tc_mist.lua
    tc_ctld.lua
    tc_ctld_all_in_one.lua
    tc_all_in_one.lua

---

## 9. Aktuelle sichere Ladevariante

Die sichere Einzeldatei-Ladung über:

    DO SCRIPT FILE

bleibt aktuell Standard.

Diese Variante ist praktisch bestätigt.

Vorteile:

- eindeutige Ladefolge
- gute Fehlerisolierung
- keine zusätzliche `dofile`-Abhängigkeit
- klare Zuordnung im DCS-Log
- gut für den aktuellen Entwicklungsstand

Eine Loader-only-Variante ist kein aktueller Entwicklungsschritt.

---

## 10. Aktuelle Trigger-Reihenfolge

Die aktuelle technische Ladefolge bleibt:

Vendor:

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

Theater Command:

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

    TIME MORE 22
    DO SCRIPT FILE: src/loader.lua

Wichtig:

- PersistenceSystem muss vor Main geladen sein.
- F10Menu muss vor Main geladen sein.
- Main bleibt Runtime-Einstieg.
- Loader bleibt aktuell die letzte eigene Datei.

---

## 11. Persistence-Trigger

Aktiver Persistence-Trigger:

- Name: `TC_LOAD_TC_PERSISTENCE_SYSTEM`
- Typ: `once`
- Bedingung: `time-after 15 seconds`
- aktive Ressource: `tc_persistence_system_v0_2_6.lua`

Beim Embedded Resource Audit vom 2026-09-12 war der aktive Embedded-Inhalt byte-identisch zu:

    src/campaign/tc_persistence_system.lua

Historische Altressource:

    ResKey_Action_55
    tc_persistence_system.lua

Stand des letzten Audits:

- alter Trigger-Verweis entfernt
- Ressource selbst noch verwaist in der `.miz`
- von keinem aktiven Trigger referenziert
- nicht geladen
- nicht Ursache der früheren Probleme

Die verwaiste Ressource ist ein separater Cleanup-Punkt und kein aktueller Blocker.

---

## 12. Lokales Repository

Lokaler Repository-Pfad auf dem DCS-PC:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\

Beispiele:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\campaign\tc_capture_system.lua
    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\campaign\tc_persistence_system.lua
    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\logistics\tc_logistics_delivery.lua
    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\logistics\tc_fob_system.lua
    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\missions\tc_mission_generator.lua
    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\ai\tc_ai_cap_manager.lua

GitHub bleibt Source of Truth für diese Dateien.

---

## 13. `.miz`-Einbettungsverhalten

Eine über `DO SCRIPT FILE` eingebettete Lua-Datei wird Bestandteil der `.miz`.

Deshalb gilt:

    Änderung im GitHub-Repository
    !=
    automatisch aktualisierte Embedded-Ressource in der .miz

Nach einer Source-Änderung muss die Missionsdatei gezielt aktualisiert werden.

Das kann je nach Aufgabe erfolgen über:

- DCS Mission Editor
- Claude + dcs-mcp

Danach muss die gespeicherte `.miz` geprüft werden.

Ein Embedded Resource Audit ist weiterhin ein geeignetes Mittel, um Source-Drift zwischen Repository und `.miz` auszuschließen.

---

## 14. Neuer Entwicklungswerkzeug-Workflow

Seit 2026-09-29 ist die Werkzeugtrennung für Mission-Editor- und Runtime-Arbeit verbindlich.

Die Werkzeuge sind Entwicklungswerkzeuge.

Sie sind keine Runtime-Abhängigkeiten der fertigen Kampagne.

---

## 15. ChatGPT

ChatGPT übernimmt primär:

- Projektkoordination
- Architektur
- GitHub-Audit
- Dokumentationspflege
- Testplanung
- Ergebnisbewertung
- Definition der nächsten konkreten Aufgabe
- Vorbereitung präziser Claude-Prompts
- Einordnung von dcs-mcp- und DCS-SMS-Ergebnissen

ChatGPT entscheidet nicht anhand bloßer Annahmen, ob ein DCS-Runtime-Verhalten funktioniert.

Reales DCS-Verhalten muss praktisch bestätigt werden.

---

## 16. Claude + dcs-mcp

Für strukturierte `.miz`- und Mission-Editor-Arbeit wird aktuell bevorzugt **Claude mit dcs-mcp** verwendet.

Aktuelle dcs-mcp-Version:

    0.9.11

Terrain Store:

    C:\Users\Paul\AppData\Local\dcs-mcp\terrain

Syria-Terrain-Daten sind installiert.

Typische Aufgaben:

- `.miz` öffnen
- Mission strukturieren
- Gruppen auflisten
- Units prüfen
- Trigger-Zonen prüfen
- Waypoints prüfen
- Tasks prüfen
- Mission-Editor-Inhalte ändern
- Native DCS-Tasks setzen
- Gruppen aktiv/inaktiv vorbereiten
- Late Activation prüfen
- Airbase-Zuordnungen prüfen
- gespeicherte Mission auditieren
- Änderungen vor dem Runtime-Test kontrollieren

Für Mission-Editor-Aufgaben soll Claude nicht blind eine neue Mission erstellen.

Vor Änderungen wird zuerst der aktuelle Missionsstand gelesen und geprüft.

---

## 17. Claude Code + DCS-SMS

Für lokale Mission-Editor- und DCS-Runtime-Arbeit wird **Claude Code mit DCS-SMS** verwendet.

DCS-SMS-Version:

    0.27.2

Hook:

    me-bridge-0.27.2

CLI:

    C:\Tools\dcs-sms\dcs-sms.exe

Claude-Code-Skill:

    C:\Users\Paul\.claude\skills\dcs-sms\SKILL.md

DCS-SMS wird verwendet für:

- Mission-Editor-Status
- laufende Mission
- Mission-Environment-Lua
- Runtime-Lua
- TC-State
- CTLD-Live-State
- Unit-State
- Gruppen-State
- Position
- Geschwindigkeit
- Grounded-/Airborne-State
- native Aktivierung
- Log-Auswertung
- Runtime-Regressionen

DCS-SMS ist kein Bestandteil der späteren Kampagnen-Runtime.

Es ist Entwicklungs- und Diagnoseinfrastruktur.

---

## 18. Verbindliche Werkzeugtrennung

Für Mission-Editor-/Framework-Arbeit gilt:

    ChatGPT
    -> definiert Ziel, Architekturgrenze und Testkriterium

    Claude + dcs-mcp
    -> analysiert und bearbeitet die .miz / Mission-Editor-Struktur

    gespeicherte .miz
    -> wird vor dem Runtime-Test geprüft

    Claude Code + DCS-SMS
    -> prüft lokale DCS-/Mission-Editor-Runtime

    DCS
    -> liefert den tatsächlichen Verhaltensbeweis

    ChatGPT
    -> bewertet das Ergebnis im Projektkontext

    GitHub
    -> erhält bestätigte Source- und Dokumentationsänderungen

Dieser Ablauf kann für reine Lua-Arbeit verkürzt werden.

Für DCS-Verhaltensfragen ersetzt jedoch keine Offline-Analyse den realen Runtime-Test.

---

## 19. Was dcs-mcp und DCS-SMS nicht sind

dcs-mcp ist nicht:

- Campaign Runtime
- CTLD-Ersatz
- MOOSE-Ersatz
- Skynet-Ersatz
- DCS-Runtime-Beweis

DCS-SMS ist nicht:

- Campaign Framework
- produktive Theater-Command-Abhängigkeit
- Teil eines späteren Spieler-Setups

Beide Werkzeuge existieren nur für Entwicklung, Diagnose und Tests.

---

## 20. Mission-Editor-Änderungen mit Claude

Bei einer neuen Mission-Editor-Aufgabe gilt:

1. aktuellen GitHub-Stand prüfen
2. relevante Mission-Editor-Dokumentation lesen
3. aktuelle `.miz` über dcs-mcp öffnen
4. Mission vollständig genug auditieren, um die konkrete Änderung sicher durchführen zu können
5. nur die freigegebene konkrete Aufgabe ändern
6. keine Nebenänderungen
7. Mission speichern
8. geänderten Missionsstand erneut mit dcs-mcp prüfen
9. erst danach Runtime-Test vorbereiten

Keine parallele große Liste von Mission-Editor-Änderungen.

Pro Schritt:

    eine konkrete Aufgabe

---

## 21. Aktueller CTLD-Mission-Editor-Stand

Der CTLD-Framework-Proof-of-Concept wurde am 2026-09-29 erfolgreich abgeschlossen.

Verbindlicher Pickup:

    CTLD_PICKUP_BLUE_AKROTIRI_01

Radius:

    250 m

Bereich:

- Akrotiri
- Nähe H1-H4

Technische Test-Dropoff-Zone:

    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01

Zentrum:

    x / North = -29249.110954281
    z / East  = -271836.070539260

Radius:

    60 m

Reservierter späterer produktiver Ercan-Dropoff:

    CTLD_DROPOFF_BLUE_ERCAN_FOB_01

Die technische Test-Dropoff-Zone ist kein produktiver FOB-Dropoff.

Details:

    mission_editor/ctld_start_zones.md

---

## 22. CTLD-Zonenregistrierung

CTLD 1.6.1 initialisiert seine Zonenlisten beim Laden.

Praktisch bestätigt:

Nach der Initialisierung können normalisierte Theater-Command-Zonen in die Live-Tabellen ergänzt werden:

    ctld.pickupZones
    ctld.dropOffZones

Erfolgreich getesteter Pickup-Eintrag:

    { "CTLD_PICKUP_BLUE_AKROTIRI_01", -1, 10000, 1, 2 }

Erfolgreich getesteter Dropoff-Eintrag:

    { "CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01", -1, 2, 1 }

Verbindlich:

    ctld.initialize()

wird dafür nicht erneut ausgeführt.

---

## 23. CTLD-KI-Transporter

Erfolgreiche Testgruppe:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01

Erfolgreiche Testunit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Start:

- Akrotiri
- Parking H4
- Hot Start
- Late Activation

Wichtige CTLD-Voraussetzung:

Der exakte Unit-Name muss im relevanten AI-Pfad in:

    ctld.transportPilotNames

registriert sein.

Vor Test:

    108 Einträge

Nach temporärer idempotenter Registrierung:

    109 Einträge

Die Testunit war genau einmal vorhanden.

Eine produktive Theater-Command-Lösung muss diese Registrierung später automatisch und lifecycle-sicher durchführen.

---

## 24. Erfolgreicher CTLD-Pickup

Nach nativer Aktivierung der Gruppe erfolgte der Pickup automatisch durch CTLD.

Bestätigt:

- 16 Soldaten aufgenommen
- Pickup-Counter `10000 -> 9999`
- keine direkte Manipulation von `ctld.inTransitTroops`
- kein manuelles CTLD-Loading
- kein Teleport
- keine Runtime-Routenänderung
- keine Runtime-Taskänderung

Damit ist der CTLD-AI-Pickup praktisch bestätigt.

---

## 25. Erfolgreicher Off-Airfield-Landepfad

Der erfolgreiche Ansatz verwendet:

    normaler Turning Point
    +
    Perform Task Land

Wegpunkt:

- Position exakt am Dropoff-Zentrum
- Höhe `100 m BARO`
- Geschwindigkeit `30 m/s`

Land-Task:

    duration=300
    durationFlag=true

Die KI führte selbständig aus:

- Taxi
- Takeoff
- Transit
- Descent
- Landung

Touchdown:

- ungefähr `1.06 m` vom Dropoff-Zentrum entfernt

Ein Invisible FARP war dafür nicht erforderlich.

Der zuvor getestete ungebundene Wegpunkt:

    Land / Landing

wird nicht als bestätigter Off-Airfield-Ansatz verwendet.

---

## 26. Erfolgreicher CTLD-Dropoff

Nach der Landung erfolgte der CTLD-Dropoff automatisch.

Bestätigt:

- CTLD-Bordzustand verlor die transportierten Truppen
- `ctld.droppedTroopsBLUE` erhielt einen neuen Eintrag
- reale Blue-Bodengruppe wurde erzeugt

Erzeugte Gruppe:

    Dropped Group 2

Group-ID:

    70001

Einheiten:

    16 x Soldier M249

Damit ist technisch bestätigt:

    Pickup
    -> Flug
    -> Off-Airfield-Landung
    -> Dropoff
    -> Bodengruppe

---

## 27. Bekannter CTLD-Fehler

Beim Grounded-Übergang des KI-Transporters trat reproduzierbar auf:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Stack-Kontext:

    updateRepackMenu
    updateRepackMenuOnlanding

Technische Einordnung:

- KI-Transporter ist in `ctld.transportPilotNames`.
- Repack-/Landing-Menülogik kann dadurch auch für diese Unit laufen.
- ein reiner KI-Transporter besitzt nicht zwingend einen Player-/F10-Command-Pfad.
- `ctld.vehicleCommandsPath[_unitName]` kann deshalb `nil` sein.

Der automatische CTLD-Dropoff wurde trotzdem abgeschlossen.

Nicht bewiesen:

- dass der Fehler dauerhaft harmlos ist
- dass der betroffene Scheduler danach normal weiterläuft

Verbindlich:

    vendor/ctld/CTLD.lua wird nicht gepatcht.

Der Fall muss vor produktiver CTLD-Integration außerhalb des Vendor-Codes behandelt werden.

---

## 28. CTLD-PoC ist kein Cargo-PoC

Der erfolgreiche Test war:

    KI-Truppentransport

Nicht getestet wurden:

- Crate Spawn
- Crate Loading
- Sling Load
- Crate Drop
- Engineering Cargo
- Repair Cargo
- Supply Cargo
- Fuel Cargo
- Ammo Cargo
- FOB Core
- realer CTLD-FOB-Bau

Diese Funktionen bilden einen eigenen späteren Testbereich.

---

## 29. Persistence-Schutz bei Mission-Editor- und Framework-Tests

Produktive Save-Datei:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Letzter bestätigter Hash:

    C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596

Größe:

    3094967 Bytes

Der CTLD-Test vom 2026-09-29 hat diese Datei nicht verändert.

Bei isolierten Tests, die Persistence beeinflussen könnten:

1. aktuellen Hash prüfen
2. Backup erzeugen
3. Backup prüfen
4. produktive Save-Datei ReadOnly setzen
5. ReadOnly bestätigen
6. Test durchführen
7. DCS vollständig beenden
8. produktiven Save erneut hashen
9. Hash vergleichen
10. erst bei identischem Hash ReadOnly entfernen
11. final erneut prüfen

ReadOnly wird nicht entfernt, solange DCS beziehungsweise die Testmission noch läuft.

---

## 30. MissionScripting.lua

Persistence und DCS-SMS benötigen lokale Sandbox-Freigaben.

Aktuelle DCS-SMS-Bridge-Umgebung:

- `os=true`
- `io=true`
- `lfs=true`
- `require=false`

PersistenceSystem benötigt direkt insbesondere:

- `io`
- `lfs`

DCS-SMS benötigt für seinen aktuellen lokalen Betrieb zusätzlich die entsprechende unsanitized Umgebung.

DCS-Updates können Änderungen an:

    MissionScripting.lua

überschreiben.

Nach DCS-Updates muss die lokale Entwicklungsumgebung deshalb erneut geprüft werden.

---

## 31. Embedded Resource Audit

Ein Embedded Resource Audit bleibt wichtig, weil Repository-Datei und `.miz`-Ressource auseinanderlaufen können.

Am 2026-09-12 wurde bestätigt:

- DEV und damalige MCP_TEST-Kopie byte-identisch
- 13/13 relevante aktive Theater-Command-Ressourcen `EXACT_MATCH`
- keine aktive Embedded Source Drift

Bei späteren Source-Änderungen soll vor einem kritischen Runtime-Test geprüft werden, ob die erwartete Source-Version tatsächlich in der `.miz` liegt.

Claude + dcs-mcp kann dafür die Missionsstruktur auditieren.

Bei Bedarf können zusätzlich Hash-/Byte-Prüfungen verwendet werden.

---

## 32. Aktueller erfolgreicher state-first Runtime-Stand

Bestätigt:

- Vendor-Frameworks erkannt
- Core geladen
- Airbase Scanner geladen
- ZoneFactory geladen
- CaptureSystem geladen
- PersistenceSystem geladen
- LogisticsDelivery geladen
- FobSystem geladen
- MissionGenerator geladen
- AICapManager geladen
- F10Menu geladen
- Main gestartet
- Loader beendet

Bestätigte Kampagnenkette:

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

Separat bestätigt:

    Mission Failure
    -> Failure Effects
    -> kein Capture Pressure

Priority 3 ist abgeschlossen.

---

## 33. DCS-Logs

Typische Logpfade:

    C:\Users\Paul\Saved Games\DCS\Logs\dcs.log

oder:

    C:\Users\Paul\Saved Games\DCS.openbeta\Logs\dcs.log

Für saubere Tests bevorzugt:

1. alten Log sichern oder löschen
2. DCS neu starten
3. exakt den vorgesehenen Test durchführen
4. DCS beenden
5. neuen Log analysieren

Ein fortgeschriebener Log kann für gezielte Regressionen verwendet werden, wenn der relevante Testzeitpunkt eindeutig bestimmbar ist.

---

## 34. Wichtige Fehlerindikatoren

Für Theater Command besonders relevant:

    [TC][ERROR]
    SCRIPTING ERROR
    Mission script error
    stack traceback
    attempt to index
    attempt to call
    nil value
    protected call failed

Nicht automatisch Theater-Command-Fehler:

- `DTC_MANAGER Window pointer is null`
- `LUA-TERRAIN getObjectPosition`
- `INVALID ATC`
- Render-/Terrain-Meldungen
- Asset-Warnings
- `Destruction shape not found`
- einzelne DCS-interne Warnungen

Der Zusammenhang mit dem gerade getesteten System entscheidet.

---

## 35. Mission-Editor-Namensregeln

Trigger-Präfix:

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

CTLD-Zonen verwenden die inzwischen verbindlichen fachlichen Namen.

Beispiele:

    CTLD_PICKUP_BLUE_AKROTIRI_01
    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01
    CTLD_DROPOFF_BLUE_ERCAN_FOB_01

Allgemeine Theater-Command-Zonen können weiterhin entsprechend der Naming-Dokumentation benannt werden.

Template-Gruppen sollen klar nach Seite, Rolle, Typ und Index benannt werden.

Beispiele:

    TC_TEMPLATE_RED_CAP_MIG29_01
    TC_TEMPLATE_BLUE_LOGISTICS_UH60_01
    TC_TEMPLATE_RED_SAM_SA6_01

Spezifische aktive Namen sind vor Verwendung immer gegen `NAMING_CONVENTIONS.md` und den aktuellen Missionsstand zu prüfen.

---

## 36. Was im Mission Editor vermieden wird

Nicht gewünscht:

- große Kampagnenlogik über Triggerketten
- Capture-System ausschließlich im Mission Editor
- Missionsgenerator ausschließlich im Mission Editor
- Logistiklogik ausschließlich im Mission Editor
- AI-Entscheidungslogik ausschließlich im Mission Editor
- Persistence ausschließlich im Mission Editor
- unstrukturierte Triggernamen
- zufällige lokale Dateiquellen
- direkte Vendor-Modifikationen
- parallele ungetestete Mission-Editor-Umbauten
- unkontrollierte Runtime-Manipulation als Ersatz für einen echten Funktionspfad
- produktive Änderungen aufgrund eines einzigen unbestätigten Offline-Befundes

Der Mission Editor bleibt Bühne.

Lua bleibt Kampagnensystem.

---

## 37. Aktuell vorhandene beziehungsweise bestätigte Mission-Editor-Bausteine

Bestätigt beziehungsweise vorhanden:

- Syria Map
- Modern Coalition Setup
- Akrotiri als Blue-Ausgangspunkt
- F/A-18C Client-Slot
- Vendor-Ladetrigger
- Theater-Command-Ladetrigger
- state-first F10Menu
- CTLD-Pickup-Zone für Akrotiri im Testkontext
- CTLD-Test-Dropoff westlich Akrotiri
- KI-Mi-8-Testtransporter
- Late Activation des Testtransporters
- erfolgreicher Turning Point + Perform Task `Land`
- erfolgreicher automatischer CTLD-Pickup
- erfolgreicher automatischer CTLD-Dropoff

Noch nicht produktiv vollständig gebaut:

- reale FOB-Struktur
- CTLD-Crate-Infrastruktur
- produktive Transportmissionen
- MOOSE-CAP-Templates
- Strike-Templates
- SEAD-/DEAD-Templates
- Ground-Operation-Templates
- IADS-Netz
- Carrier Task Group
- vollständige Client-Slot-Struktur

---

## 38. Aktueller nächster Mission-Editor-Schritt

Es ist derzeit **keine pauschale große Mission-Editor-Bauphase** freigegeben.

Der CTLD-Truppentransport-PoC ist abgeschlossen.

Der nächste technische Schritt ist zuerst:

    Architektur der produktiven Theater-Command-CTLD-Integration festlegen

Dabei müssen insbesondere geklärt werden:

- welche eigene fachliche `src/`-Komponente die CTLD-Konfiguration übernimmt
- wie Zonen idempotent registriert werden
- wie KI-Transporter idempotent registriert werden
- wie Transporter-Lifecycle behandelt wird
- wie `RepackCommandsPath` ohne Vendor-Patch behandelt wird
- wie Transportaufträge aus dem Kampagnenstate entstehen
- wie Ergebnisse validiert werden
- wie Ergebnisse zurück in LogisticsDelivery und FobSystem gelangen
- welche Resultate persistiert werden

Erst aus dieser Architekturentscheidung ergibt sich die nächste konkrete Mission-Editor-Aufgabe.

Wenn danach eine `.miz`-Änderung erforderlich ist, wird sie bevorzugt über:

    Claude + dcs-mcp

vorbereitet und geprüft.

Der anschließende Runtime-Test erfolgt über:

    Claude Code + DCS-SMS
    +
    reale DCS-Runtime

---

## 39. Nächste Session

Eine neue Session beginnt nicht aus Chat-Erinnerung.

Zuerst GitHub prüfen.

Mindestens:

- `README.md`
- `ROADMAP.md`
- `TASKS.md`
- `CHANGELOG.md`
- `ARCHITECTURE.md`

Für Mission-Editor-/CTLD-Arbeit zusätzlich:

- `MISSION_EDITOR_SETUP.md`
- `docs/02_technical_architecture.md`
- `docs/03_mission_editor_basics.md`
- `docs/05_logistics_system.md`
- `docs/10_testing.md`
- `mission_editor/README.md`
- `mission_editor/ctld_start_zones.md`
- `mission_editor/trigger_setup.md`

Danach aktuelle `.miz` prüfen.

Für `.miz`-/Mission-Editor-Arbeit:

    Claude + dcs-mcp

Für lokale DCS-/Runtime-Arbeit:

    Claude Code + DCS-SMS

Für Projektkoordination:

    ChatGPT

---

## 40. Aktueller Abschlussstand

Stand:

    2026-09-29

Bestätigt:

- DEV-Mission bleibt technischer Hauptträger.
- sichere Einzeldatei-Ladung bleibt Standard.
- state-first Kampagnenkern funktioniert.
- Priority 3 ist abgeschlossen.
- dirty-aware Persistence funktioniert.
- `productiveRestore=false`.
- CTLD Runtime-Zonenregistrierung funktioniert.
- CTLD-KI-Transporterregistrierung funktioniert.
- automatischer CTLD-Pickup funktioniert.
- autonomer Mi-8-Flug funktioniert.
- Off-Airfield-Landung über Perform Task `Land` funktioniert.
- automatischer CTLD-Dropoff funktioniert.
- reale Blue-Bodengruppe wird erzeugt.
- kein Invisible FARP war für diesen PoC erforderlich.
- `RepackCommandsPath` bleibt bekannter Integrationspunkt.
- Crate-/Cargo-Pfad bleibt separat ungetestet.
- Claude + dcs-mcp ist der bevorzugte `.miz`-/Mission-Editor-Pfad.
- Claude Code + DCS-SMS ist der bevorzugte lokale Runtime-/Diagnosepfad.
- DCS selbst bleibt der autoritative Runtime-Beweis.
- GitHub bleibt Source of Truth.

Aktueller Übergang:

    state-first Kampagnenkern
    +
    bestandener CTLD-KI-Transport-PoC
    ->
    kontrollierte produktive CTLD-Integration
