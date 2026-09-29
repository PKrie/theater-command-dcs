# Mission Editor Setup

Diese Datei beschreibt den verbindlichen Mission-Editor-, `.miz`- und DCS-Testworkflow für **Theater Command DCS**.

Erste Kampagne:

**Operation Levant Reclamation**

Map:

**Syria**

Aktueller verbindlicher Stand:

**2026-09-29**

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

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis / Source of Truth
    DCS Runtime = autoritativer Verhaltensbeweis

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
- native DCS-Tasks
- Statics
- FARPs
- eingebettete Lua-Ressourcen

Die eigentliche Kampagnenlogik liegt unter:

    src/

Große Kampagnenlogik wird nicht als komplexe Mission-Editor-Triggerkette aufgebaut.

---

## 2. Aktueller Mission-Editor-Stand

Aktuelle DEV-Mission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_DEV.miz

Isolierte erfolgreiche CTLD-Testmission:

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
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` | KI-Truppentransport-PoC für getesteten Aufbau bestanden |

Priority 3 – Dirty-Coverage – ist seit:

    2026-09-21

im dokumentierten Umfang abgeschlossen.

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

    Modern

Fachliche Ausgangsvorgabe:

    Blue startet auf Akrotiri / Zypern.
    Red kontrolliert zu Kampagnenbeginn das syrische Festland.

Diese Konfiguration ist für den aktuellen Entwicklungsstand ausreichend.

Sie kann später bei Bedarf erweitert werden.

---

## 6. Spieler-Slot

Aktueller erster Blue-Client-Slot:

    CLIENT_BLUE_FA18C_AKROTIRI_01

Eigenschaften:

    Flugzeug: F/A-18C Lot 20
    Koalition: Blue
    Land: USA
    Startbasis: Akrotiri
    Skill: Client

Da es sich um einen Client-Slot handelt, muss beim normalen manuellen Runtime-Test die Client-Slotauswahl berücksichtigt werden.

Normaler Teststart:

    Mission starten
    -> CLIENT_BLUE_FA18C_AKROTIRI_01 auswählen
    -> Slot bestätigen
    -> Briefing
    -> Fly

Der Slot ist noch kein finaler Kampagnen-Slot.

Perspektivisch können weitere Module hinzukommen, darunter:

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

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua

Wichtig:

    MIST vor CTLD
    CTLD-i18n vor CTLD.lua
    Theater Command nach den Vendor-Frameworks

Framework-Code unter `vendor/` bleibt unverändert.

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
    tc_ctld_bridge.lua
    tc_all_in_one.lua

Eine neue Integrationsdatei wird erst festgelegt, wenn ihre fachliche Verantwortung eindeutig definiert ist.

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
- kontrollierbare Embedded-Ressourcen
- gut für den aktuellen Entwicklungsstand

Eine Loader-only-Variante ist kein aktueller Entwicklungsschritt.

---

## 10. Aktuelle Trigger-Reihenfolge

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

Details:

    mission_editor/trigger_setup.md

---

## 11. Persistence-Trigger

Aktiver Persistence-Trigger:

    TC_LOAD_TC_PERSISTENCE_SYSTEM

Typ:

    ONCE

Bedingung:

    TIME MORE 15

Aktive Ressource:

    tc_persistence_system_v0_2_6.lua

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
- nicht Ursache der damals untersuchten Probleme

Die verwaiste Ressource ist ein separater Cleanup-Punkt und kein aktueller Entwicklungsblocker.

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

GitHub bleibt Source of Truth.

---

## 13. `.miz`-Einbettungsverhalten

Eine über:

    DO SCRIPT FILE

eingebettete Lua-Datei wird Bestandteil der `.miz`.

Deshalb gilt:

    Änderung im GitHub-Repository
    !=
    automatisch aktualisierte Embedded-Ressource in der .miz

Nach einer Source-Änderung muss die betroffene Missionsressource gezielt aktualisiert werden.

Danach muss die gespeicherte `.miz` erneut geprüft werden.

Ein Embedded Resource Audit ist das geeignete Verfahren, um Drift zwischen Repository-Source und Missionsressource auszuschließen.

---

## 14. Entwicklungswerkzeug-Workflow

Seit 2026-09-29 ist die Werkzeugtrennung für Mission-Editor- und Runtime-Arbeit verbindlich dokumentiert.

Diese Werkzeuge sind Entwicklungs- und Diagnosewerkzeuge.

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
- Vorbereitung präziser Arbeitsaufträge
- Einordnung von dcs-mcp- und DCS-SMS-Ergebnissen

ChatGPT ersetzt keinen realen DCS-Runtime-Test.

---

## 16. Claude + dcs-mcp

Für strukturierte `.miz`- und Mission-Editor-Arbeit wird aktuell bevorzugt Claude mit dcs-mcp verwendet.

Aktuelle Version:

    dcs-mcp 0.9.11

Terrain Store:

    C:\Users\Paul\AppData\Local\dcs-mcp\terrain

Syria-Terrain:

    installiert

Typische Aufgaben:

- `.miz` öffnen und analysieren
- Gruppen auflisten
- Units prüfen
- Trigger-Zonen prüfen
- Waypoints prüfen
- Tasks prüfen
- eingebettete Ressourcen prüfen
- Mission-Editor-Inhalte gezielt ändern
- native DCS-Tasks setzen
- Airbase-Zuordnungen prüfen
- gespeicherte Mission auditieren
- Änderungen vor dem Runtime-Test kontrollieren

Vor jeder Änderung wird zuerst der aktuelle Missionsstand gelesen.

Die Mission wird nicht blind neu aufgebaut.

---

## 17. Claude Code + DCS-SMS

Für lokale Mission-Editor- und DCS-Runtime-Arbeit wird Claude Code mit DCS-SMS verwendet.

DCS-SMS-Version:

    0.27.2

Hook:

    me-bridge-0.27.2

Verifiziertes Installationsverzeichnis:

    C:\Tools\dcs-sms

Claude-Code-Skill:

    C:\Users\Paul\.claude\skills\dcs-sms\SKILL.md

DCS-SMS wird verwendet für:

- Mission-Editor-Status
- laufende Mission
- Mission-Environment-Lua
- Runtime-Lua
- Theater-Command-State
- CTLD-Live-State
- Unit-State
- Gruppen-State
- Position
- Geschwindigkeit
- Grounded-/Airborne-State
- kontrollierte Aktivierung
- Log-Auswertung
- Runtime-Regressionen

Aus dem bestätigten Stand wird kein exakter Executable-Pfad abgeleitet.

DCS-SMS ist kein Bestandteil der späteren Kampagnen-Runtime.

Es ist Entwicklungs- und Diagnoseinfrastruktur.

---

## 18. Verbindliche Werkzeugtrennung

Für Mission-Editor-/Framework-Arbeit gilt:

    ChatGPT
    -> Ziel, Architekturgrenze und Testkriterium

    Claude + dcs-mcp
    -> .miz- und Mission-Editor-Struktur

    gespeicherte .miz
    -> strukturelle Nachprüfung

    Claude Code + DCS-SMS
    -> lokale Mission-Editor-/DCS-Runtime

    DCS
    -> tatsächlicher Verhaltensbeweis

    ChatGPT
    -> Ergebnisbewertung im Projektkontext

    GitHub
    -> bestätigte Source und Dokumentation

Für reine Lua-Arbeit kann dieser Ablauf entsprechend verkürzt werden.

Bei tatsächlichem DCS-Verhalten ersetzt jedoch keine Offline-Analyse den Runtime-Test.

---

## 19. Evidenzarten

Bei Mission-Editor- und Framework-Arbeit werden vier Evidenzarten getrennt:

    Source-Befund
    gespeicherte Missionsstruktur
    Runtime-Beobachtung
    technische Inferenz

Beispiele:

    Perform Task -> Land ist in der .miz gespeichert
    =
    gespeicherte Missionsstruktur

    Mi-8 landet tatsächlich im Zielbereich
    =
    Runtime-Beobachtung

    unbehandelter Lua-Fehler könnte einen Scheduler-Pfad beendet haben
    =
    technische Inferenz

Inferenz darf nicht als direkt beobachteter Fakt dokumentiert werden.

---

## 20. Mission-Editor-Änderungen mit Claude

Bei einer neuen Mission-Editor-Aufgabe gilt:

    GitHub prüfen
    -> relevante Dokumentation lesen
    -> aktuelle .miz mit dcs-mcp öffnen
    -> konkreten Bereich auditieren
    -> genau eine freigegebene Änderung durchführen
    -> Mission speichern
    -> gespeicherte Mission erneut prüfen
    -> Runtime-Test vorbereiten
    -> DCS-Runtime testen
    -> Ergebnis bewerten
    -> bestätigten Stand dokumentieren

Keine parallelen großen Mission-Editor-Umbauten.

Pro Schritt:

    eine konkrete Aufgabe

---

## 21. Aktueller CTLD-Mission-Editor-Stand

Der isolierte CTLD-KI-Truppentransport-PoC wurde am 2026-09-29 für den getesteten Aufbau erfolgreich abgeschlossen.

Verbindlicher Pickup:

    CTLD_PICKUP_BLUE_AKROTIRI_01

Radius:

    250 m

Der Pickup befindet sich im Bereich Akrotiri.

Technische Test-Dropoff-Zone:

    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01

Zentrum:

    x / North = -29249.110954281
    z / East  = -271836.070539260

Radius:

    60 m

Reservierter späterer Ercan-Dropoff:

    CTLD_DROPOFF_BLUE_ERCAN_FOB_01

Die technische Test-Dropoff-Zone ist kein produktiver FOB-Dropoff.

Details:

    mission_editor/ctld_start_zones.md

---

## 22. CTLD-Zonenregistrierung

CTLD:

    1.6.1

Für den getesteten Runtime-Pfad bestätigt:

Nach der bestehenden CTLD-Initialisierung konnten normalisierte Einträge in die Live-Tabellen ergänzt werden:

    ctld.pickupZones
    ctld.dropOffZones

Getesteter Pickup-Eintrag:

    { "CTLD_PICKUP_BLUE_AKROTIRI_01", -1, 10000, 1, 2 }

Getesteter Dropoff-Eintrag:

    { "CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01", -1, 2, 1 }

CTLD verwendete diese Einträge anschließend tatsächlich.

Eine erneute Ausführung von:

    ctld.initialize()

war für diesen getesteten Runtime-Pfad nicht erforderlich.

Daraus wird nicht abgeleitet, dass ein erneuter Aufruf von `ctld.initialize()` grundsätzlich verboten wäre.

Produktive Registrierung muss später insbesondere:

- idempotent
- duplikatfrei
- lifecycle-sicher

erfolgen.

---

## 23. CTLD-KI-Transporter

Erfolgreiche Testgruppe:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01

Erfolgreiche Testunit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Luftfahrzeug:

    Mi-8

Wichtiger CTLD-Befund:

Der exakte Unit-Name musste im relevanten getesteten AI-Pfad in:

    ctld.transportPilotNames

registriert sein.

Vor temporärer Registrierung:

    108 Einträge

Nach idempotent geprüfter temporärer Registrierung:

    109 Einträge

Die Testunit war genau einmal vorhanden.

Eine produktive Theater-Command-Lösung muss diese Registrierung später:

- automatisch
- idempotent
- duplikatfrei
- lifecycle-sicher

durchführen.

---

## 24. Aktivierung des Testtransporters

Die Testgruppe wurde in der Runtime über die native DCS-Funktion:

    trigger.action.activateGroup()

aktiviert.

Bestätigter Runtime-Verlauf:

    Aktivierung ungefähr t=665 s
    Gruppe aktiv ungefähr t=677 s

Der erfolgreiche Test benötigt keine nachträgliche Runtime-Manipulation der Route oder des CTLD-Onboard-State.

---

## 25. Erfolgreicher CTLD-Pickup

Nach Aktivierung der Gruppe erfolgte der Pickup automatisch durch CTLD.

Bestätigt:

    16 Soldaten aufgenommen
    Pickup-Counter 10000 -> 9999

Der Transporter befand sich dabei ungefähr:

    87 m

vom Pickup-Zentrum entfernt.

Nicht verwendet:

- direkte Manipulation von `ctld.inTransitTroops`
- manuelles CTLD-Loading
- Teleport
- Runtime-Routenänderung
- Runtime-Taskänderung

Damit ist der automatische CTLD-AI-Pickup für den getesteten Aufbau praktisch bestätigt.

---

## 26. Erfolgreicher Transportflug

Nach dem Pickup führte die DCS-KI den Flug selbständig durch.

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

Für den Transport waren keine Runtime-Routenänderung und kein Runtime-Taskwechsel erforderlich.

---

## 27. Erfolgreicher Off-Airfield-Landepfad

Der erfolgreiche Missionsaufbau verwendete:

    normaler Turning Point
    +
    DCS-native Perform Task -> Land

Der Wegpunkt lag am technischen Dropoff-Zentrum:

    x / North = -29249.110954281
    z / East  = -271836.070539260

Wegpunkt:

    Höhe: 100 m BARO
    Geschwindigkeit: 30 m/s

Land-Task:

    duration=300
    durationFlag=true

Touchdown-Phase:

    ungefähr t=1405.9 bis 1426.0 s

Bestätigte minimale Entfernung zum Dropoff-Zentrum:

    ungefähr 1.06 m

Die Geschwindigkeit am Boden lag anschließend ungefähr bei:

    0.01 m/s

Der Transporter blieb danach für mindestens ungefähr:

    220 s

am Boden.

Der volle 300-Sekunden-Wert musste nicht abgewartet werden, weil der automatische CTLD-Dropoff vorher bereits eindeutig bestätigt war.

Für diesen getesteten Truppentransport war kein Invisible FARP erforderlich.

Der zuvor verwendete ungebundene:

    Land / Landing

Waypoint hatte keinen vollständigen erfolgreichen Transportzyklus ergeben.

Der erfolgreiche neue Aufbau zeigt einen relevanten Unterschied in der Landemethode.

Die genaue Ursache des früheren Turnbacks ist damit nicht abschließend bewiesen.

---

## 28. Erfolgreicher CTLD-Dropoff

Nach der Landung erfolgte der CTLD-Dropoff automatisch.

Bestätigt:

- `ctld.inTransitTroops[unitname]` verlor den transportierten `troops`-Inhalt.
- `ctld.droppedTroopsBLUE` erhielt genau einen neuen Eintrag.
- eine reale Blue-Bodengruppe wurde erzeugt.

Erzeugte Gruppe:

    Dropped Group 2

Group-ID:

    70001

Einheiten:

    16 x Soldier M249

Die erzeugte Bodengruppe bewegte sich anschließend unter normaler DCS-AI weiter.

Nicht verwendet:

- manuelles CTLD-Unload
- direkte Bordzustandsmanipulation
- Teleport
- Runtime-Routenänderung
- Runtime-Taskänderung

Damit ist für den getesteten Aufbau bestätigt:

    Pickup
    -> Flug
    -> Off-Airfield-Landung
    -> automatischer Dropoff
    -> reale Bodengruppe

---

## 29. Bekannter CTLD-Fehler

Beim Touchdown des registrierten KI-Transporters wurde genau einmal folgender Fehler beobachtet:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Stack-Kontext:

    updateRepackMenu
    updateRepackMenuOnlanding

Der Fehler wiederholte sich während der anschließenden ungefähr 220 Sekunden langen Bodenbeobachtung nicht.

Source-basierte Einordnung:

- der KI-Transporter war in `ctld.transportPilotNames` registriert.
- dadurch konnte die Unit einen CTLD-Landing-/Menüpfad erreichen.
- `ctld.vehicleCommandsPath[_unitName]` ist für reine KI-Units nicht zwangsläufig vorhanden.
- der daraus abgeleitete `RepackCommandsPath` kann deshalb `nil` sein.
- der Vendor-Code behandelt diesen Fall an der beobachteten Stelle nicht robust.

Der automatische Pickup-/Dropoff-Pfad wurde trotzdem erfolgreich abgeschlossen.

Nicht bewiesen:

- dass der Fehler harmlos ist
- dass spätere Repack-Menü-Aktualisierungen funktionieren
- dass der betreffende Scheduler definitiv weiterlief
- dass der betreffende Scheduler definitiv beendet wurde

Dass der unbehandelte Lua-Fehler den betreffenden Scheduler-Pfad beendet haben könnte, ist eine technische Inferenz und kein direkter Runtime-Beweis.

Verbindlich:

    vendor/ctld/CTLD.lua wird nicht gepatcht.

Der Fall muss vor produktiver Integration außerhalb des Vendor-Codes sauber behandelt oder isoliert werden.

---

## 30. Grenze des CTLD-Proof-of-Concept

Der erfolgreiche Test war:

    KI-Truppentransport

Er bestätigt für den getesteten Aufbau:

- Runtime-Zonenregistrierung
- Transporterregistrierung
- automatischen Pickup
- Transportflug
- Off-Airfield-Landung
- automatischen Dropoff
- reale Bodengruppe

Er bestätigt noch nicht:

- produktive Theater-Command-CTLD-Orchestrierung
- automatische Auftragserzeugung
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
- realen CTLD-FOB-Bau
- LogisticsDelivery-Rückkopplung
- FobSystem-Rückkopplung
- Capture-Rückkopplung
- CTLD-Restore
- Multiplayer

Framework-Proof-of-Concept und produktive Theater-Command-Integration bleiben klar getrennt.

---

## 31. Persistence-Schutz bei Mission-Editor- und Framework-Tests

Produktive Save-Datei:

    C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua

Bestätigter SHA-256:

    C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596

Größe:

    3094967 Bytes

Änderungszeit:

    2026-09-21 15:00:00.5926451

Backup vor dem CTLD-LANDTASK-Test:

    C:\Users\Paul\Documents\TC_miz_backups\operation_levant_reclamation_save__pre_landtask_test_2026-09-29_100813.lua

Der CTLD-Test vom 2026-09-29 hat die produktive Save-Datei nicht verändert.

Bestätigt:

- Größe unverändert
- Änderungszeit unverändert
- SHA-256 unverändert
- produktiver Campaign-State unverändert

Nach beendetem DCS wurde der Schreibschutz wieder entfernt.

Final:

    ReadOnly=False

Verbindlich:

    productiveRestore=false

Bei zukünftigen isolierten Tests mit möglicher Persistence-Wirkung gilt:

    aktuellen Save-Hash prüfen
    -> Backup erzeugen
    -> Backup-Hash prüfen
    -> produktiven Save ReadOnly setzen
    -> ReadOnly bestätigen
    -> Test durchführen
    -> DCS vollständig beenden
    -> Save erneut hashen
    -> Referenz vergleichen
    -> nur bei identischem Hash ReadOnly entfernen
    -> final erneut prüfen

---

## 32. MissionScripting.lua

Persistence und DCS-SMS benötigen eine geeignete lokale Mission-Scripting-Umgebung.

Für Persistence ist Dateisystemzugriff insbesondere über:

    io
    lfs

relevant.

Die aktuelle Entwicklungsumgebung wurde im Projekt bereits für Persistence und DCS-SMS verwendet.

DCS-Updates können lokale Änderungen an:

    MissionScripting.lua

überschreiben.

Nach DCS-Updates müssen deshalb die lokalen Voraussetzungen erneut geprüft werden.

Konkrete Sandbox-Werte dürfen nur dann als aktueller Stand dokumentiert werden, wenn sie für die jeweilige lokale Umgebung erneut verifiziert wurden.

---

## 33. Embedded Resource Audit

Ein Embedded Resource Audit bleibt wichtig, weil Repository-Datei und `.miz`-Ressource auseinanderlaufen können.

Am 2026-09-12 wurde bestätigt:

    DEV und damalige MCP_TEST-Kopie byte-identisch
    13/13 relevante aktive Theater-Command-Ressourcen EXACT_MATCH
    keine aktive Embedded Source Drift

Dieser Befund gilt für den damals auditierten Stand.

Bei späteren Source-Änderungen muss erneut geprüft werden, ob die erwartete Source-Version tatsächlich in der `.miz` eingebettet ist.

---

## 34. Aktueller state-first Runtime-Stand

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

    Mission Activation
    -> Mission Failure
    -> Failure Effects
    -> kein Capture Pressure
    -> Background Autosave

Priority 3 ist im dokumentierten Umfang abgeschlossen.

---

## 35. DCS-Logs

Typische Logpfade:

    C:\Users\Paul\Saved Games\DCS\Logs\dcs.log

oder:

    C:\Users\Paul\Saved Games\DCS.openbeta\Logs\dcs.log

Für saubere Tests bevorzugt:

    alten Log sichern oder löschen
    -> DCS neu starten
    -> exakt den vorgesehenen Test durchführen
    -> DCS beenden
    -> neuen Log analysieren

Ein fortgeschriebener Log kann für gezielte Regressionen verwendet werden, wenn der relevante Testzeitpunkt eindeutig bestimmbar ist.

---

## 36. Wichtige Fehlerindikatoren

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

## 37. Mission-Editor-Namensregeln

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

CTLD-Zonen:

    CTLD_PICKUP_BLUE_AKROTIRI_01
    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01
    CTLD_DROPOFF_BLUE_ERCAN_FOB_01

Template-Gruppen sollen klar nach Seite, Rolle, Typ und Index benannt werden.

Beispiele:

    TC_TEMPLATE_RED_CAP_MIG29_01
    TC_TEMPLATE_BLUE_LOGISTICS_UH60_01
    TC_TEMPLATE_RED_SAM_SA6_01

Spezifische aktive Namen sind vor Verwendung immer gegen:

    NAMING_CONVENTIONS.md

und den aktuellen Missionsstand zu prüfen.

---

## 38. Was im Mission Editor vermieden wird

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
- produktive Änderungen aufgrund eines einzelnen unbestätigten Offline-Befundes

Der Mission Editor bleibt Bühne.

Lua bleibt Kampagnensystem.

---

## 39. Aktuell vorhandene beziehungsweise bestätigte Mission-Editor-Bausteine

Bestätigt beziehungsweise vorhanden:

- Syria Map
- Modern Coalition Setup
- Akrotiri als Blue-Ausgangspunkt
- F/A-18C Client-Slot
- Vendor-Ladetrigger
- Theater-Command-Ladetrigger
- state-first F10Menu
- CTLD-Pickup-Testzone
- CTLD-Test-Dropoff westlich Akrotiri
- Mi-8-Testtransporter im isolierten Testaufbau
- gespeicherter Turning Point + Perform Task `Land`
- erfolgreicher automatischer CTLD-Pickup
- erfolgreiche Off-Airfield-Landung
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

## 40. Aktueller nächster Mission-Editor-Schritt

Es ist derzeit keine pauschale große Mission-Editor-Bauphase freigegeben.

Der CTLD-KI-Truppentransport-PoC ist für den getesteten Aufbau abgeschlossen.

Der nächste technische Schritt ist zunächst:

    Architektur der produktiven Theater-Command-CTLD-Integration festlegen

Dabei muss insbesondere geklärt werden:

- welche eigene fachliche `src/`-Komponente einen Transportauftrag besitzt
- welche Komponente CTLD-Zonen registriert
- welche Komponente KI-Transporter registriert
- wann die Registrierung erfolgt
- wie die Registrierung idempotent bleibt
- wie Transporter-Lifecycle behandelt wird
- wie `RepackCommandsPath` ohne Vendor-Patch behandelt wird
- wie Transportaufträge aus dem Kampagnenstate entstehen
- wie Pickup, Erfolg und Fehler erkannt werden
- wie Resultate zurück in LogisticsDelivery und FobSystem gelangen
- welche Resultate Dirty setzen
- welche Daten persistiert werden
- welche CTLD-Daten runtime-only bleiben
- was später nach Restore rekonstruiert werden muss

Erst aus dieser Architekturentscheidung ergibt sich die nächste konkrete Mission-Editor-Aufgabe.

Keine generische Datei wie:

    tc_ctld.lua
    tc_ctld_bridge.lua

vorschnell anlegen.

---

## 41. Nächste Session

Eine neue Session beginnt nicht aus Chat-Erinnerung.

Zuerst wird der aktuelle GitHub-Stand geprüft.

Mindestens:

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

Danach wird vor jeder `.miz`-Änderung die aktuelle Mission geprüft.

Für `.miz`-/Mission-Editor-Arbeit:

    Claude + dcs-mcp

Für lokale DCS-/Runtime-Arbeit:

    Claude Code + DCS-SMS

Für Projektkoordination:

    ChatGPT

---

## 42. Aktueller Abschlussstand

Stand:

    2026-09-29

Bestätigt:

    DEV-Mission bleibt technischer Hauptträger.
    sichere Einzeldatei-Ladung bleibt Standard.
    state-first Kampagnenkern funktioniert.
    Priority 3 ist im dokumentierten Umfang abgeschlossen.
    dirty-aware Persistence funktioniert.
    productiveRestore=false.
    CTLD Runtime-Zonenregistrierung funktioniert für den getesteten Aufbau.
    CTLD-KI-Transporterregistrierung funktioniert für den getesteten Aufbau.
    automatischer CTLD-Pickup funktioniert für den getesteten Aufbau.
    autonomer Mi-8-Transportflug funktioniert für den getesteten Aufbau.
    Off-Airfield-Landung über Perform Task Land funktioniert für den getesteten Aufbau.
    automatischer CTLD-Dropoff funktioniert für den getesteten Aufbau.
    reale Blue-Bodengruppe wurde erzeugt.
    kein Invisible FARP war für diesen getesteten Truppentransport erforderlich.
    RepackCommandsPath bleibt bekannter Integrationspunkt.
    Crate-/Cargo-Pfad bleibt separat ungetestet.
    Claude + dcs-mcp ist der bevorzugte .miz-/Mission-Editor-Pfad.
    Claude Code + DCS-SMS ist der bevorzugte lokale Runtime-/Diagnosepfad.
    DCS selbst bleibt der autoritative Runtime-Beweis.
    GitHub bleibt Source of Truth.

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
