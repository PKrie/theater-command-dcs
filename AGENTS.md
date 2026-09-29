# AGENTS.md

# Theater Command DCS — AI Development Instructions

Diese Datei enthält die verbindlichen Arbeitsregeln für AI-Agenten, die am Projekt **Theater Command DCS** arbeiten.

Sie gilt für:

- ChatGPT
- Claude
- Claude Code
- zukünftige Entwicklungsagenten

Projekt:

    Theater Command DCS

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Aktueller verbindlicher Projektstand:

    2026-09-29

---

# 1. Grundprinzip

Das zentrale Architekturprinzip lautet:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis / Source of Truth
    DCS Runtime = autoritativer Verhaltensbeweis

Der Mission Editor stellt die physische Umgebung bereit.

Lua enthält die dynamische Kampagnenlogik.

GitHub enthält den verbindlichen Projektstand.

DCS selbst entscheidet letztlich, ob ein Simulator- oder Framework-Verhalten tatsächlich funktioniert.

---

# 2. Projektziel

Theater Command DCS soll langfristig eine modulare, dynamische und persistente DCS-World-Kampagne ermöglichen.

Der Spieler soll nur ein Teilnehmer innerhalb eines größeren militärischen Systems sein.

Langfristig vorgesehen sind unter anderem:

- dynamische Missionen
- Capture-System
- Logistics
- FOB-Netz
- AI Commander
- Ground Warfare
- CAS Requests
- CAP
- Strike
- SEAD / DEAD
- IADS
- Supply Chains
- Carrier Operations
- Air Tasking
- Persistent Campaign State
- Multiplayer

Alle Systeme müssen modular bleiben.

---

# 3. Aktueller Projektstand

Aktueller Entwicklungsstand:

    Priority 3 abgeschlossen
    Priority 4 aktiv

Priority 3:

    Dirty-Coverage im dokumentierten Umfang abgeschlossen

Abschluss:

    2026-09-21

Aktueller Entwicklungsbereich:

    Priority 4 – produktive CTLD-Integration vorbereiten

Bestätigter CTLD-Stand:

    CTLD 1.6.1

Framework-Proof-of-Concept bestanden für:

    KI-Truppentransport
    -> automatischer Pickup
    -> Flug
    -> Off-Airfield-Landung
    -> automatischer Dropoff
    -> reale Bodengruppe

Noch nicht produktiv implementiert:

- Theater-Command-CTLD-Orchestrierung
- CTLD-Crate-/Cargo-Wirtschaft
- reale CTLD-FOBs
- reale MOOSE-CAP-Flüge
- AI Director
- Ground Campaign
- produktiver Startup-Restore
- Carrier Operations
- Multiplayer

---

# 4. Pflichtlektüre vor jeder neuen Arbeit

Vor einer Implementierung immer zuerst den aktuellen GitHub-Stand lesen.

Mindestens:

    README.md
    ROADMAP.md
    TASKS.md
    ARCHITECTURE.md
    CHANGELOG.md
    MISSION_EDITOR_SETUP.md
    NAMING_CONVENTIONS.md
    LUA_STYLEGUIDE.md

Zusätzlich:

    relevante Datei unter docs/
    relevante README unter src/
    relevante mission_editor/-Dokumentation

Bei CTLD-/Logistikarbeit insbesondere:

    docs/05_logistics_system.md
    docs/09_persistence.md
    docs/10_testing.md
    mission_editor/ctld_start_zones.md
    src/logistics/README.md

Niemals nur aus Chat-Erinnerung oder einem alten Session-Prompt weiterarbeiten.

GitHub ist autoritativ.

---

# 5. One-Task Rule

Verbindlich:

    eine konkrete Aufgabe
    ein fachlicher Arbeitsschritt
    möglichst eine Datei
    ein Commit

Keine langen parallelen Aufgabenlisten.

Keine gleichzeitige Umgestaltung mehrerer Systeme.

Keine vorsorglichen Refactorings außerhalb der konkreten Aufgabe.

---

# 6. Dateiänderungen

Wenn dem Nutzer eine Datei zur manuellen Änderung auf GitHub gegeben wird:

immer liefern:

1. exakten Dateipfad
2. vollständigen Dateiinhalt
3. genau einen zusammenhängenden Codeblock
4. vollständigen Copy-&-Paste-Inhalt
5. konkreten Commit-Text

Nicht liefern:

- Teilstücke
- Fortsetzungen
- `...`
- ausgelassene Bereiche
- mehrere Codeblöcke für dieselbe Datei

---

# 7. Repository-Struktur

Vendor-Frameworks:

    vendor/
        mist/
        moose/
        ctld/
        skynet-iads/

Eigene Logik:

    src/

Dokumentation:

    docs/
    mission_editor/

Framework-Code und eigener Projektcode bleiben strikt getrennt.

---

# 8. Vendor-Regel

Vendor-Dateien werden nicht verändert.

Verbindlich:

    vendor/ ist immutable

Erlaubt:

- Vendor-Code lesen
- Vendor-Code analysieren
- Vendor-APIs verwenden
- Vendor-Verhalten testen
- eigene Integrationslogik schreiben

Nicht erlaubt:

- Vendor-Code patchen
- Vendor-Code umbenennen
- Vendor-Code verschieben
- modifizierte Kopien erzeugen
- Projektfixes direkt im Vendor-Code verstecken

Das gilt insbesondere für:

    vendor/ctld/CTLD.lua

Der bekannte CTLD-`RepackCommandsPath`-Fall wird nicht durch einen Vendor-Patch gelöst.

---

# 9. Source-Architektur

Eigene Lua-Logik wird nach fachlicher Aufgabe organisiert.

Aktuelle Struktur:

    src/core/
    src/world/
    src/campaign/
    src/logistics/
    src/missions/
    src/ai/
    src/iads/
    src/ui/
    src/debug/

Nicht nach Framework organisieren.

Verbotene beziehungsweise ausdrücklich unerwünschte Dateien:

    tc_all_in_one.lua
    tc_moose.lua
    tc_mist.lua
    tc_ctld.lua
    tc_ctld_all_in_one.lua
    tc_ctld_bridge.lua
    tc_logistics_all_in_one.lua

Eine fachliche Datei darf intern ein Framework verwenden.

Der Dateiname bleibt trotzdem fachlich.

---

# 10. Aktive Systeme

Aktuelle bestätigte Versionen:

    Airbase Scanner      v0.2.2
    ZoneFactory          v0.2.0
    CaptureSystem        v0.2.2
    PersistenceSystem    v0.2.6
    LogisticsDelivery    v0.2.1
    FobSystem            v0.2.1
    MissionGenerator     v0.2.3
    AICapManager         v0.2.1
    F10Menu              v0.2.3
    CTLD                 1.6.1

Wenn Dokumentation oder eingebettete Mission eine andere Version zeigt:

    nicht raten

sondern:

    aktuellen Source- und Missionsstand prüfen

---

# 11. Architekturgrenze zu Frameworks

Verbindliche Trennung:

    Theater Command
    =
    Campaign Logic
    Decision Layer
    State Owner

Frameworks:

    CTLD
    MOOSE
    Skynet IADS
    MIST

sind:

    Execution Layer / technische Werkzeuge

Beispiele:

Theater Command entscheidet:

- welche Mission benötigt wird
- welche Zone relevant ist
- welcher Hub Versorgung benötigt
- welcher FOB gebaut werden soll
- wo CAP benötigt wird
- welche Operation erfolgreich war
- welche Folgen persistiert werden

Frameworks führen reale DCS-Aktionen aus.

---

# 12. State-first Architecture

Neue Systeme grundsätzlich state-first entwickeln.

Bevor reale Framework-Nebenwirkungen aktiviert werden:

    State definieren
    -> State erzeugen
    -> State sichtbar machen
    -> State testen
    -> Dirty-Semantik prüfen
    -> Framework-Pfad isoliert testen
    -> Framework anbinden
    -> Ergebnis validieren
    -> State aktualisieren
    -> Persistence

Keine reale Spawn-/Cargo-/IADS-Orchestrierung einführen, bevor der betreffende State-Pfad verstanden ist.

---

# 13. State Ownership

Langfristiger Kampagnenstate gehört Theater Command.

Nicht einem Vendor-Framework.

Beispiel CTLD:

Nicht:

    vollständige CTLD-Runtime
    =
    Campaign State

Sondern:

    Auftrag
    -> CTLD-Ausführung
    -> Ergebnisvalidierung
    -> TC.State
    -> Dirty
    -> Persistence

Vendor-Runtime kann temporäre Daten enthalten, die nicht persistiert werden dürfen.

---

# 14. Dirty-State-Regel

Persistenzrelevante fachliche Mutationen müssen Dirty markieren.

Zentral:

    TC.State.Persistence.dirty
    TC.State.Persistence.dirtyReason
    TC.State.Persistence.dirtyAt

Grundregeln:

    echte Mutation
    -> Dirty

    reiner Read
    -> kein Dirty

    echter No-Op
    -> kein Dirty

Priority 3 hat diese Semantik für die aktuell relevanten Systeme abgesichert.

---

# 15. Priority 3

Priority 3 ist abgeschlossen.

Nicht erneut vollständig auditieren, solange kein neuer technischer Anlass besteht.

Bestätigt:

    Capture Getter Read-Neutrality
    Capture Ownership No-Op
    LogisticsDelivery Read-Neutrality
    FobSystem Read-Neutrality
    MissionGenerator Dirty-Coverage-Audit
    AICapManager Read-Neutrality

Später neu verdrahtete Lifecycle-Pfade müssen trotzdem gezielt getestet werden.

Beispiel:

    AICapManager.reactToActiveMissions()

ist aktuell nicht produktiv verdrahtet und muss bei späterer Aktivierung erneut geprüft werden.

---

# 16. Persistence

Persistence ist ein internes Hintergrundsystem.

Aktuelle Version:

    v0.2.6

Bestätigt:

- Save
- Read-back
- Compile
- Evaluate
- Validation
- kontrollierter Import
- dirty-aware Background Autosave
- `SAVED`
- `SKIPPED`
- kontrollierter `FAILED`
- Retry

Verbindlich:

    productiveRestore=false

Produktiver Startup-Restore ist noch nicht freigegeben.

Nicht behaupten, dass die Kampagne bereits automatisch über Missionsneustarts fortgesetzt wird.

---

# 17. Restore

Technische Importfähigkeit ist nicht dasselbe wie produktiver Restore.

Vor:

    productiveRestore=true

müssen mindestens geklärt werden:

- Restore-/Initialisierungsreihenfolge
- Save-Versionierung
- Save-Kompatibilität
- Framework-Rekonstruktion
- End-to-End-Restore-Test

Kein AI-Agent aktiviert produktiven Restore ohne einen expliziten, getesteten Entwicklungsschritt.

---

# 18. Mission Editor

Der Mission Editor ist Bühne.

Er enthält beziehungsweise stellt bereit:

- Karte
- Koalitionen
- Client-Slots
- Gruppen
- Templates
- Trigger
- Trigger-Zonen
- Wegpunkte
- native Tasks
- Statics
- FARPs
- Embedded Lua Resources

Nicht in große Triggerketten verlagern:

- Campaign Logic
- Capture Logic
- AI Commander
- Persistence
- Mission Generator
- Logistics Decision Logic

---

# 19. Aktuelle Mission

Technische Hauptmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_DEV.miz

Isolierte erfolgreiche CTLD-Testmission:

    C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz

Testmission und DEV-Mission sind nicht gleichzusetzen.

Erkenntnisse werden erst nach Test und Bewertung kontrolliert übernommen.

---

# 20. Embedded Resource Rule

`DO SCRIPT FILE` bettet Lua-Dateien in die `.miz` ein.

Daher gilt:

    Repository geändert
    !=
    Embedded Mission Resource automatisch geändert

Nach Source-Änderungen:

- relevante Embedded-Ressource aktualisieren
- Mission speichern
- Missionsstand erneut prüfen
- bei kritischen Änderungen Source-/Embedded-Match verifizieren

Der erfolgreiche Embedded Resource Audit vom 2026-09-12 gilt nur für den damals geprüften Stand.

---

# 21. CTLD aktueller Stand

CTLD:

    Version 1.6.1

Am 2026-09-29 praktisch bestätigt:

    Runtime-Zonenregistrierung
    KI-Transporterregistrierung
    automatischer Pickup
    Flug
    Off-Airfield-Landung
    automatischer Dropoff
    reale Blue-Bodengruppe

Getesteter Transporter:

    Mi-8

Getestete Unit:

    TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01

Bestandener Pfad gilt für den getesteten Aufbau.

Nicht pauschal auf alle Transporter oder Missionskonfigurationen verallgemeinern.

---

# 22. CTLD-Zonen

Bestätigter Pickup:

    CTLD_PICKUP_BLUE_AKROTIRI_01

Technischer Test-Dropoff:

    CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01

Reservierter späterer produktiver FOB-Dropoff:

    CTLD_DROPOFF_BLUE_ERCAN_FOB_01

Normalisierte Runtime-Einträge können nach der initialen CTLD-Initialisierung ergänzt werden.

Eine erneute Ausführung von:

    ctld.initialize()

war für den getesteten Pfad nicht erforderlich.

Nicht daraus ableiten, dass `ctld.initialize()` generell verboten wäre.

---

# 23. CTLD transportPilotNames

Für den getesteten KI-Transportpfad musste der exakte Unit-Name in:

    ctld.transportPilotNames

registriert sein.

Die spätere Theater-Command-Integration muss diese Registrierung:

- automatisch
- idempotent
- ohne Duplikate
- lifecycle-sicher

durchführen.

Keine direkte Manipulation des CTLD-Onboard-State als Ersatz für einen echten Transportpfad.

---

# 24. CTLD Landing

Erfolgreich getestet:

    normaler Turning Point
    +
    Perform Task -> Land

Land Task:

    duration=300
    durationFlag=true

Für den getesteten Truppentransport war kein FARP erforderlich.

Der vorherige ungebundene:

    Land / Landing

Waypoint führte nicht zu einem vollständigen erfolgreichen Transportzyklus.

Die genaue Ursache dieses früheren Verhaltens ist nicht abschließend bewiesen.

Keine stärkere Kausalbehauptung daraus ableiten.

---

# 25. CTLD RepackCommandsPath

Beim Grounded-Übergang trat genau einmal auf:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Kontext:

    updateRepackMenu
    updateRepackMenuOnlanding

Pickup und Dropoff wurden trotzdem erfolgreich abgeschlossen.

Nicht als bewiesen behandeln:

- dass der Fehler harmlos ist
- dass der betreffende Scheduler danach normal weiterläuft
- dass der Scheduler definitiv beendet wurde

Letzteres ist nur eine mögliche Source-basierte Folgerung und kein direkter Runtime-Beweis.

Vendor-Code wird nicht gepatcht.

---

# 26. CTLD-Testgrenze

Der erfolgreiche Test war:

    KI-Truppentransport

Nicht damit bewiesen:

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
- realer FOB-Bau
- LogisticsDelivery-Rückkopplung
- FobSystem-Rückkopplung
- CTLD-Restore
- Multiplayer

Framework-PoC und produktive Integration müssen sprachlich klar getrennt bleiben.

---

# 27. Aktuelle Priority 4

Aktueller Entwicklungsbereich:

    produktive CTLD-Integration vorbereiten

Vor neuem produktiven Code klären:

1. Welche fachliche Komponente besitzt einen Transportauftrag?
2. Welche Komponente registriert CTLD-Zonen?
3. Welche Komponente registriert KI-Transporter?
4. Wann erfolgt die Registrierung?
5. Wie bleibt sie idempotent?
6. Wie wird der Transporter-Lifecycle behandelt?
7. Wie wird Erfolg erkannt?
8. Wie wird Fehler erkannt?
9. Wie wird `RepackCommandsPath` behandelt?
10. Welche Ergebnisse werden in `TC.State` geschrieben?
11. Welche Mutationen setzen Dirty?
12. Welche Daten bleiben runtime-only?
13. Was muss später nach Restore rekonstruiert werden?

Erst danach eine konkrete Source-Datei festlegen.

---

# 28. Keine voreilige neue CTLD-Datei

Es existiert aktuell keine verbindlich beschlossene neue Integrationsdatei für CTLD.

Nicht eigenmächtig anlegen:

    tc_ctld.lua
    tc_ctld_bridge.lua

oder ähnliche generische Framework-Dateien.

Zuerst Verantwortung und fachliche Aufgabe definieren.

Dann Dateiname nach Aufgabe wählen.

---

# 29. Tool-Rollen

Die Entwicklungswerkzeuge haben klar getrennte Rollen.

Sie sind keine Runtime-Abhängigkeiten der späteren Kampagne.

---

# 30. ChatGPT

Rolle:

- Projektkoordination
- Architektur
- GitHub-Audit
- Testplanung
- Ergebnisbewertung
- Dokumentationsführung
- Definition des nächsten Einzelschritts
- Vorbereitung präziser Arbeitsaufträge

ChatGPT soll projektweite Entscheidungen gegen den aktuellen GitHub-Stand prüfen.

---

# 31. Claude + dcs-mcp

Bevorzugter Pfad für:

- `.miz`-Analyse
- Mission-Editor-Strukturanalyse
- Gruppen
- Units
- Zonen
- Wegpunkte
- Tasks
- Ressourcen
- gezielte Missionsänderungen
- gespeicherten `.miz`-Audit

Aktuelle Version:

    dcs-mcp 0.9.11

Terrain Store:

    C:\Users\Paul\AppData\Local\dcs-mcp\terrain

Syria-Terrain:

    installiert

Vor Änderungen:

    aktuelle Mission zuerst lesen

Keine Mission blind neu aufbauen.

---

# 32. Claude Code + DCS-SMS

Bevorzugter Pfad für lokale Runtime-Diagnose.

DCS-SMS:

    0.27.2

Hook:

    me-bridge-0.27.2

Verifiziertes Installationsverzeichnis:

    C:\Tools\dcs-sms

Claude-Code-Skill:

    C:\Users\Paul\.claude\skills\dcs-sms\SKILL.md

Verwendung:

- Mission-Editor-Status
- Runtime-Lua
- Theater-Command-Live-State
- CTLD-Live-State
- Unit-/Group-State
- Position
- Geschwindigkeit
- Grounded-/Airborne-State
- Logs
- Runtime-Regressionen

Nicht behaupten, dass ein bestimmter Executable-Pfad verifiziert ist, wenn nur das Installationsverzeichnis bestätigt wurde.

---

# 33. DCS

DCS selbst bleibt der autoritative Runtime-Beweis.

Nur die reale Runtime kann zuverlässig beweisen:

- Taxi
- Takeoff
- Navigation
- Landung
- Pickup
- Dropoff
- Spawn
- Scheduler-Verhalten
- tatsächliche AI-Reaktion

Offline-Analyse und Runtime-Beweis nicht vermischen.

---

# 34. Verbindlicher Mission-Editor-/Framework-Workflow

Für `.miz`- oder Framework-Arbeit:

    GitHub prüfen
    -> Ziel definieren
    -> Testkriterium definieren
    -> aktuelle .miz mit Claude + dcs-mcp lesen
    -> nur konkrete Änderung durchführen
    -> Mission speichern
    -> gespeicherte Mission erneut auditieren
    -> Runtime-Test vorbereiten
    -> Claude Code + DCS-SMS verwenden
    -> reales DCS-Verhalten prüfen
    -> Ergebnis bewerten
    -> GitHub aktualisieren

Keine Paralleländerungen ohne Notwendigkeit.

---

# 35. Testevidenz

Unterscheide immer:

    Source-Befund
    gespeicherte Missionsstruktur
    Runtime-Beobachtung
    Inferenz

Beispiele:

Gespeicherter `Perform Task -> Land`:

    Missionsstruktur

Tatsächliche Off-Airfield-Landung:

    Runtime-Beweis

Vermutung, dass ein Scheduler nach unbehandeltem Lua-Fehler endet:

    Inferenz

Diese Kategorien nicht sprachlich vermischen.

---

# 36. Persistence-Schutz bei isolierten Tests

Wenn ein Framework-Test produktiven Campaign-State beeinflussen könnte:

    aktuellen Save-Hash prüfen
    -> Backup
    -> Backup-Hash prüfen
    -> produktiven Save ReadOnly setzen
    -> ReadOnly bestätigen
    -> Test durchführen
    -> DCS vollständig beenden
    -> Save erneut hashen
    -> Hash vergleichen
    -> nur bei Match ReadOnly entfernen
    -> final erneut prüfen

Der CTLD-Test vom 2026-09-29 wurde auf diese Weise abgesichert.

---

# 37. Git-Regeln

Vor einer Änderung:

- aktuellen GitHub-Stand prüfen
- betroffene Dokumentation lesen
- tatsächliche Datei prüfen

Nach einer Änderung:

- Inhalt kontrollieren
- genau einen passenden Commit-Text vorbereiten
- Nutzer die Änderung durchführen lassen, wenn im GitHub-Web-Workflow gearbeitet wird

Nicht automatisch:

- committen
- pushen
- mehrere Dateien verändern

außer der Nutzer hat dies ausdrücklich beauftragt.

---

# 38. Dokumentationsregeln

Dokumentation ist Teil der Architektur.

Nach einem bestätigten technischen Meilenstein prüfen:

- README
- ROADMAP
- TASKS
- ARCHITECTURE
- CHANGELOG
- betroffene `docs/`
- betroffene `src/.../README.md`
- betroffene `mission_editor/`-Dokumentation

Nicht jede kleine Codeänderung erfordert sofort einen kompletten Dokumentationsdurchlauf.

Am Ende einer Entwicklungsphase muss der Projektstand jedoch konsistent sein.

---

# 39. Keine unbelegten Aussagen

Nicht aus Vermutungen Fakten machen.

Beispiele:

Nicht schreiben:

    der Scheduler ist definitiv beendet

wenn nur ein unbehandelter Fehler beobachtet wurde.

Nicht schreiben:

    CTLD Cargo funktioniert

wenn nur Truppentransport getestet wurde.

Nicht schreiben:

    Mi-8MT

wenn nur:

    Mi-8

belegt ist.

Nicht schreiben:

    vollständige produktive CTLD-Integration

wenn nur ein isolierter Framework-PoC bestanden ist.

---

# 40. Naming

Naming-Regeln stehen in:

    NAMING_CONVENTIONS.md

Mission-Editor-spezifische Regeln stehen zusätzlich in:

    MISSION_EDITOR_SETUP.md
    mission_editor/

Keine neuen Namensschemata erfinden.

Bestehende Namespaces und Präfixe beibehalten.

---

# 41. Lua-Stil

Lua-Code muss:

- modular
- lesbar
- defensiv
- nachvollziehbar
- logbar
- state-aware
- persistence-aware

sein.

Styleguide:

    LUA_STYLEGUIDE.md

Keine großen monolithischen Dateien ohne belegten fachlichen Bedarf.

---

# 42. Logging

Logging soll:

- relevante Zustände sichtbar machen
- Debugging ermöglichen
- Fehlerursachen eingrenzen
- keine unnötige Spam-Flut erzeugen

Bevorzugt:

    strukturierte Präfixe
    klare Module
    relevante IDs
    aussagekräftige Reasons

---

# 43. Performance

Vermeiden:

- unnötiges Polling
- große wiederholte Vollsuchen
- teure Schleifen ohne Bedarf
- permanente Framework-Abfragen ohne Zustandsänderung

Bevorzugen:

- Events
- Caches
- inkrementelle Updates
- gezielte Scheduler
- idempotente Operationen

---

# 44. Definition of Done

Eine technische Aufgabe ist erst abgeschlossen, wenn die für den Schritt relevanten Punkte erfüllt sind.

Je nach Aufgabe:

- Architektur verstanden
- eine konkrete Änderung durchgeführt
- Syntax geprüft
- Missionsstruktur geprüft
- Runtime getestet
- Logs geprüft
- State geprüft
- Dirty-Semantik geprüft
- Persistence-Auswirkung geprüft
- Cleanup durchgeführt
- Dokumentation synchronisiert
- Nutzer hat Ergebnis bestätigt
- Commit vorbereitet beziehungsweise durchgeführt

Nicht jeder Schritt benötigt alle Punkte.

Die relevanten Punkte dürfen aber nicht übersprungen werden.

---

# 45. Aktueller nächster Architekturübergang

Aktueller bestätigter Stand:

    stabiler state-first Kampagnenkern
    +
    dirty-aware Persistence
    +
    abgeschlossene Priority-3-Dirty-Coverage
    +
    bestandener CTLD-KI-Truppentransport-PoC

Nächster Übergang:

    kontrollierte produktive CTLD-Integration

Dabei bleibt verbindlich:

    Theater Command = Decision / State Layer
    CTLD = Execution Layer

---

# 46. Final Principle

Langfristige Architektur hat Vorrang vor einem schnellen lokalen Workaround.

Jede Änderung soll Theater Command näher an ein autonomes Kampagnensystem bringen.

Nicht nur an eine funktionierende Einzelmission.

Verbindlich:

    modular
    state-first
    testbar
    persistierbar
    framework-unabhängig strukturiert
    vendor-safe
    dokumentiert
