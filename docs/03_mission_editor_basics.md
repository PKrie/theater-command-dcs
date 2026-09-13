# Mission Editor Basics

## Verbindliches Update — 2026-09-12

`Operation_Levant_Reclamation_DEV.miz` enthält PersistenceSystem `v0.2.6` unter Trigger `TC_LOAD_TC_PERSISTENCE_SYSTEM`, `once`, `time-after 15 seconds`, Resource Key `ResKey_advancedFile_56`, Embedded Filename `tc_persistence_system_v0_2_6.lua`. Aktiv geladen wird ausschließlich PersistenceSystem `v0.2.6` über diesen Trigger.

Der alte Trigger-Verweis auf `ResKey_Action_55` wurde entfernt. Die alte Ressource `tc_persistence_system.lua` liegt weiterhin verwaist in der `.miz`, wird von keinem Trigger referenziert, wird nicht geladen und war nicht ursächlich für frühere Runtime-Probleme. Sie bleibt eine spätere Cleanup-Aufgabe.

Der frühere Mission-Record-Verlust ist widerlegt: MissionGenerator `v0.2.3` erzeugt 10 Mission Records in String-keyed Lua-Dictionaries (`available`, `active`, `completed`, `failed`, `expired`, `cancelled`). Live bestätigt: `statistics.available=10`, `pairs()`-Count `available=10`, `#available=0`. Der Lua-Längenoperator `#` ist für diese Dictionaries nicht autoritativ. Der tatsächliche Source-Bug lag in `src/core/tc_state.lua` -> `State.summary()`; der Fix (pairs-basierte `countEntries()`-Funktion) wurde committed, gepusht, neu eingebettet und live getestet. Eine repo-weite READ-ONLY Prüfung fand keine weiteren entsprechenden falschen `#`-Counts auf Mission-State-Dictionaries.

Der Offline Embedded Mission Resource Audit ist abgeschlossen: DEV und MCP_TEST waren beim Audit byte-identisch, 13/13 relevante aktive Theater-Command-Ressourcen waren `EXACT_MATCH` zum Repository, 0 relevante aktive Byte-Mismatches, keine aktive Embedded-Runtime-Drift. Der Audit beweist nur den Stand zum Auditzeitpunkt; nach jeder Source-Änderung muss die betroffene Datei im Mission Editor erneut ausgewählt/eingebettet und die Mission gespeichert werden.

Der Slot `CLIENT_BLUE_FA18C_AKROTIRI_01` ist `CLIENT`: Mission starten, Slot auswählen, bestätigen, im Briefing `Fly` drücken. DCS-SMS (aktuell `v0.27.2`, Hook `me-bridge-0.27.2`) ist reines Entwicklungs-/Mission-Editor-/Diagnose-Tooling, kein Theater-Command-Runtime-Framework. Nach einem DCS-Update musste der MissionScripting-Hook neu installiert/repariert werden (`.\dcs-sms.exe install-hook --dcs-path "C:\Program Files\Eagle Dynamics\DCS World OpenBeta"`); DCS-Updates können `MissionScripting.lua`- bzw. Bridge-Anpassungen überschreiben.

Auto-Routing per `dcs-sms exec --code "..."` (bzw. `.\dcs-sms.exe exec --code "..."`) erreicht automatisch das Mission Environment; `TC` ist dort als Tabelle erreichbar. Bestätigte Sandbox: `os=true`, `io=true`, `lfs=true`, `require=false`. PersistenceSystem benötigt direkt `io`/`lfs`; die aktuelle Bridge benötigt `os`/`io`/`lfs`. DCS-SMS bleibt Entwicklungs-/Mission-Editor-/Diagnose-Tooling und ist kein Theater-Command-Runtime-Framework.

Der aktuelle Projektschwerpunkt liegt nicht mehr im Mission Editor, sondern in Priority 3 Dirty-Coverage (siehe Abschnitt 20). Priority 3 ist **nicht abgeschlossen**. Ältere „aktuelle” Abschnitte, die diesem Update widersprechen, sind historische Snapshots.

Diese Datei beschreibt die grundlegende Rolle des DCS Mission Editors im Projekt **Theater Command DCS**.

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## 1. Grundprinzip

Das zentrale Arbeitsprinzip lautet:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Mission Editor stellt die physische Umgebung bereit.

Die eigentliche Kampagnenlogik liegt in Lua.

GitHub dokumentiert Struktur, Entscheidungen, Aufgabenstand, Testergebnisse und Versionen.

---

## 2. Rolle des Mission Editors

Der Mission Editor ist nicht das eigentliche Kampagnensystem.

Er stellt bereit:

- Karte
- Koalitionen
- Spieler-Slots
- Startpositionen
- statische Objekte
- Template-Gruppen
- einfache Trigger zum Laden von Lua-Dateien
- Zonen, sofern sie nicht sinnvoll durch Lua erzeugt werden können
- technische Testumgebung

Er soll nicht übernehmen:

- dynamische Kampagnenlogik
- Capture-Entscheidungen
- komplexe Missionsgenerierung
- dynamische KI-Entscheidungen
- Persistenz
- strategische Besitzlogik
- große Triggerketten

Aktuelle Entscheidung:

    Der Mission Editor bleibt bewusst schlank.
    Große dynamische Logik gehört nach src/.

---

## 3. Aktueller Mission-Editor-Stand

Historischer Stand 2026-06-29 bleibt als Baseline erhalten.

Verbindlicher aktueller Stand:

    2026-09-12

Aktuelle technische Entwicklungsmission:

    Operation_Levant_Reclamation_DEV.miz

Aktueller Inhalt:

    Map Syria
    Koalitionspreset Modern
    Blue Start Akrotiri / Zypern
    erster F/A-18C Client-Slot
    Starttest-Variante A
    Vendor-Frameworks eingebettet/geladen
    Theater-Command-Source-Dateien eingebettet/geladen
    PersistenceSystem v0.2.6 eingebettet
    F10Menu v0.2.3
    33 F10 Commands
    Mission Details testbar
    Mission Activation testbar
    Mission Completion testbar
    Mission Failure testbar
    Capture Status sichtbar
    Capture Ready Zones sichtbar
    Pressure Contested Zones sichtbar
    Capture Ready Apply testbar
    dirty-aware Background Autosave aktiv

Weiterhin NICHT produktiv:

    rote Frontlinie
    produktive IADS-Kampagnenstruktur
    CTLD-Zonen
    echte CTLD-FOBs
    produktive Template-Gruppen für MOOSE
    echte MOOSE-Spawns
    autonome AI-Operationen
    produktiver Startup-Restore

Nicht mehr korrekt:

    "keine produktive Persistenz"

Richtig:

    Background Save ist aktiv und getestet.
    Produktiver Startup-Restore ist noch deaktiviert.

Die Mission ist aktuell ein technischer Testträger.

Sie ist noch keine spielbare Kampagnenmission.

---

## 4. Aktueller Teststatus

Starttest-Variante A wurde mehrfach erfolgreich durchgeführt.

Test:

    Starttest-Variante A — sichere Einzeldatei-Ladung

Ergebnis:

    Bestanden

Bestätigt wurde:

- MIST wird geladen
- MOOSE wird geladen
- CTLD-i18n wird geladen
- CTLD wird geladen
- Skynet IADS wird geladen
- eigene Theater-Command-Source-Dateien werden geladen
- `src/main.lua` wird geladen
- `src/loader.lua` wird zuletzt geladen
- Loader startet
- Frameworks werden erkannt
- Main startet
- Runtime-Systeme werden initialisiert
- Airbase Scanner läuft
- ZoneFactory läuft
- CaptureSystem läuft
- PersistenceSystem `v0.2.6` lädt/startet als dirty-aware Background-Autosave
- LogisticsDelivery läuft
- FobSystem läuft
- MissionGenerator läuft
- AICapManager läuft
- F10Menu läuft
- F10Menu `v0.2.3` erzeugt 33 Commands
- Missionen können über F10 direkt ausgewählt werden
- Missionen können über F10 direkt aktiviert werden
- Loader beendet sauber

Zusätzlich bestanden:

- Mission Completion
- Mission Failure
- Capture Ready Apply
- Zone Ownership Update
- linked Airbase Ownership Sync
- Background Autosave
- Capture Getter Dirty-Neutralität
- Capture Ownership No-Op
- Embedded Resource Audit

Wichtiger aktueller Befund (Stand 2026-09-12):

    Airbase Scanner registriert 225 Syria airbase-like objects.
    ZoneFactory erzeugt daraus 46 relevante Kampagnenzonen.
    CaptureSystem arbeitet auf 32 capture-fähigen Zielen.
    CaptureSystem erzeugt 32 Pressure-Records und 32 Progress-Records.
    LogisticsDelivery erzeugt 46 Logistics Hubs.
    FobSystem erzeugt 6 FOB-Kandidaten und 2 Blue-FOBs.
    MissionGenerator erzeugt 78 Missionskandidaten, 2 FOB-Support-Kandidaten und 10 Mission Records.
    AICapManager erzeugt 31 CAP-Zonen-Kandidaten, 12 auto-registrierte CAP-Zonen und 12 CAP Requests.
    F10Menu v0.2.3 erzeugt 33 Commands.

Mission Records sind String-keyed Dictionaries; `pairs()`-basierte Zählung ist autoritativ, `#` ist es nicht (siehe Verbindliches Update oben).

Nicht mehr aktuell:

    "Mission candidates 69"
    "alle sechs Mission-Dictionaries leer"

Bewertung:

    Die Mission-Editor-Ladestruktur funktioniert.
    Die technische Startkette ist lauffähig.
    Die state-first Runtime-Grundlage ist stabil.
    Der nächste technische Schwerpunkt liegt weiterhin nicht im Mission Editor; F10-/State-Sichtbarkeit ist abgeschlossen und nicht mehr der Schwerpunkt.
    Aktueller Projektschwerpunkt ist Priority 3 Dirty-Coverage (siehe Abschnitt 20).

---

## 5. Koalitionsauswahl

Für die aktuelle DEV-Mission wurde das DCS-Koalitionspreset verwendet:

    Modern

Diese Auswahl ist für den aktuellen Entwicklungsstand passend.

Grund:

- moderne Koalitionslogik
- USA als Blue verfügbar
- Syrien als Red verfügbar
- passend für eine moderne Syria-Kampagne
- keine unnötige Sonderkonfiguration in der Frühphase

Aktuelle Vorgabe:

    Blue startet auf Akrotiri / Zypern.
    Red kontrolliert zu Beginn das syrische Festland.

Die Koalitionsstruktur kann später angepasst werden, falls die Kampagnenlogik oder das Szenario es erfordern.

---

## 6. Spieler-Slot

Aktueller erster Spieler-Slot:

    Flugzeug: F/A-18C Lot 20
    Koalition: Blue
    Land: USA
    Startort: Akrotiri
    Starttyp: Start vom Parkplatz
    Skill: Client

Zweck:

- Mission starten können
- Lua-Startkette in echter DCS-Mission prüfen
- `dcs.log` erzeugen
- Airbase Scanner und ZoneFactory im DCS-Kontext testen
- F10-Menü testen
- Mission Details über F10 testen
- Mission Activation über F10 testen
- Mission Completion testen
- Mission Failure testen
- Capture Status prüfen
- Capture Ready prüfen
- Capture Ready Apply testen
- Background Autosave nach fachlicher State-Änderung prüfen

Dieser Slot ist noch kein finaler Kampagnen-Slot. Eine finale Slot-Struktur ist daraus nicht abzuleiten.

Später mögliche Client-Slots:

- F/A-18C
- F-14B
- F-15E
- A-10C
- AH-64D
- weitere Module nach Bedarf

---

## 7. Lokale Repository-Kopie

Für die Arbeit mit dem Mission Editor wird eine lokale Repository-Kopie auf dem DCS-PC verwendet.

Aktueller lokaler Pfad:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\

Aus diesem Pfad werden die Lua-Dateien im Mission Editor per `DO SCRIPT FILE` geladen.

Wichtig:

    DCS bettet per DO SCRIPT FILE geladene Dateien in die .miz ein.
    Nach jeder Lua-Änderung muss die betroffene Datei im Mission Editor erneut ausgewählt und die Mission gespeichert werden.

Der Audit vom 2026-09-12 bestätigte 13/13 relevante aktive Ressourcen als `EXACT_MATCH`. Der bestandene Audit beweist nur den Stand zum Auditzeitpunkt; er bedeutet nicht, dass spätere Repository-Änderungen automatisch in der `.miz` landen.

---

## 8. Framework-Ladung

Externe Frameworks liegen im Repository unter:

    vendor/

Die Frameworks werden nicht verändert.

Aktuelle Framework-Basis:

    vendor/mist/mist.lua
    vendor/moose/Moose.lua
    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua
    vendor/skynet-iads/SkynetIADS.lua

Die getestete Framework-Lade-Reihenfolge lautet:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua

Wichtig:

    MIST muss vor CTLD geladen werden.
    CTLD-i18n.lua muss vor CTLD.lua geladen werden.
    Eigene Theater-Command-Logik startet erst nach den Frameworks.

Aktueller Stand:

    MIST geladen und erkannt.
    MOOSE geladen und erkannt.
    CTLD geladen und erkannt.
    Skynet IADS geladen und erkannt.
    Produktive Framework-Ausführung ist noch nicht aktiv.

---

## 9. Eigene Source-Ladung

Eigene Theater-Command-Logik liegt unter:

    src/

Aktuell aktive eigene Lua-Dateien:

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

Aktuell noch nicht aktiv implementiert:

    src/iads/
    src/debug/

Wichtige Korrektur gegenüber älteren Ständen:

    src/ui/ besitzt inzwischen ein aktives Lua-Modul.
    src/ui/tc_f10_menu.lua ist geladen, sichtbar, navigierbar und getestet.

---

## 10. Starttest-Variante A

Status:

    Bestanden

Ziel:

    sichere Einzeldatei-Ladung im Mission Editor

Diese Variante lädt jede aktive Datei einzeln per `DO SCRIPT FILE`.

Vorteile:

- keine harte Abhängigkeit von `dofile`
- klare Fehlereingrenzung
- jede Datei wird direkt im DCS-Kontext getestet
- geeignet für technische Validierung
- Fehler lassen sich über `dcs.log` nachvollziehen

Aktuelle Entscheidung:

    Starttest-Variante A bleibt Standard, bis Loader-only praktisch getestet ist.

---

## 11. Getestete Trigger-Grundstruktur

Jeder Trigger der Starttest-Variante A verwendet:

    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT
    Bedingung: MEHR ZEIT / TIME MORE
    Aktion: SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Die Trigger werden zeitversetzt ausgelöst.

Dadurch bleibt die Lade-Reihenfolge eindeutig.

---

## 12. Getestete Trigger-Reihenfolge

Die erfolgreiche Reihenfolge ist:

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
    (Trigger: TC_LOAD_TC_PERSISTENCE_SYSTEM, Resource Key: ResKey_advancedFile_56, Embedded Filename: tc_persistence_system_v0_2_6.lua)

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

    src/ui/tc_f10_menu.lua wird vor src/main.lua geladen.
    src/main.lua wird vor src/loader.lua geladen.
    src/loader.lua wird als letzte eigene Datei geladen.

Grund:

    main.lua definiert TC.Main und startet Runtime-Systeme.
    loader.lua prüft anschließend Frameworks und beendet die Startkette sauber.

---

## 13. Ergebnis des aktuellen Mission-Editor-Tests

Die Mission-Editor-Ladekette wurde erfolgreich durchgeführt.

Positive Theater-Command-Logik:

    Theater Command Loader gestartet
    Frameworks erkannt
    Core geladen
    World geladen
    Campaign geladen
    Logistics geladen
    Missions geladen
    AI geladen
    UI geladen
    Main gestartet
    Runtime-Systeme initialisiert
    Loader sauber beendet

World-Ergebnis:

    Airbase scan completed: 225 airbase-like objects classified
    Zone factory completed: 46 relevant campaign zones

Campaign-Ergebnis:

    Capture eligibility summary: bases=32, zones=32
    Capture pressure summary: pressureRecords=32, progressRecords=32

Logistics-Ergebnis:

    Logistics hubs: 46
    FOB candidates: 6
    Blue FOBs: 2

Mission-Ergebnis:

    Mission candidates: 78
    FOB support candidates: 2
    Mission Records: 10

UI-Ergebnis:

    F10Menu v0.2.3
    F10 menu initialized: commands=33
    Mission Details über F10 bestätigt
    Mission Activation über F10 bestätigt

Bestätigte F10-/Runtime-Pfade:

    Show Available Missions
    Show Active Missions
    Mission Details 1–10
    Mission Activation 1–10
    Active Mission Outcome Status
    Complete Active Mission 1
    Fail Active Mission 1
    Show Campaign Status
    Show Capture Status
    Show Capture Ready Zones
    Apply Capture Ready Zone 1
    Show Pressure Contested Zones
    Show Logistics Status
    Show FOB Status
    Show AI CAP Status

Bestätigte Mission-/Capture-Pipeline:

    Mission Details -> Mission Activation -> Mission Completion -> Mission Effects
    -> Capture Pressure -> Capture Progress -> Capture Ready -> Capture Ready Apply
    -> Zone Ownership Update -> linked Airbase Ownership Sync -> Background Autosave

Failure-Pfad:

    Mission Activation -> Mission Failure -> Failure Effects prepared
    -> CaptureSystem applied=0 -> kein Capture Pressure -> Background Autosave

PersistenceSystem-Teststand:

    Version: v0.2.6
    Embedded Start bestätigt
    initialDelay=20s
    interval=120s
    SAVED
    SKIPPED
    kontrollierter FAILED-Pfad
    Retry
    Save
    Read-back
    Compile
    Evaluate
    Validation

Bestätigte Campaign-Regressionen:

    Mission Completion: SAVED, dirtyReason=f10_active_mission_1_completed, dirtyCleared=true
    Mission Failure: SAVED, dirtyReason=f10_active_mission_1_failed, dirtyCleared=true
    Capture Ready Apply: SAVED, dirtyReason=f10_capture_ready_zone_1_applied, dirtyCleared=true

`productiveRestore=false`. Der Mission Editor lädt PersistenceSystem nur als eingebettete Lua-Ressource; danach arbeitet PersistenceSystem intern als Hintergrundsystem. Keine Persistence-F10-Player-Controls. Kein automatischer Restore-Trigger im Mission Editor.

Bewertung:

    Die Mission-Editor-Ladekette funktioniert.
    Das Projekt kann im DCS Mission Scripting Environment starten.
    Der Mission Editor ist als technische Bühne geeignet.
    Die nächste Arbeit liegt im Code, nicht im weiteren Mission-Editor-Ausbau.

---

## 14. `dcs.log` prüfen

Nach jedem Test wird die `dcs.log` geprüft.

Aktuell relevanter Pfad:

    C:\Users\Paul\Saved Games\DCS.openbeta\Logs\dcs.log

Normaler DCS-Pfad als Alternative:

    C:\Users\Paul\Saved Games\DCS\Logs\dcs.log

Schneller Zugriff:

    %USERPROFILE%\Saved Games

Wichtige Suchbegriffe:

    TC
    Theater Command
    ERROR
    error
    FAILED
    stack traceback
    attempt to index nil value
    cannot open
    MIST
    MOOSE
    CTLD
    Skynet
    F10Menu
    MissionGenerator
    CaptureSystem
    PersistenceSystem
    Periodic autosave
    dirtyReason
    SAVED
    SKIPPED
    FAILED

Ein Test ist nur dann als bestanden zu bewerten, wenn die Theater-Command-Startkette ohne schweren Lua-Abbruch durchläuft.

Besonders relevant:

    [TC][ERROR]
    FAILED in einem Theater-Command-Modul
    stack traceback in Theater-Command-Dateien
    fehlende Frameworks
    fehlgeschlagener Main-Start
    fehlgeschlagener Loader-Abschluss

---

## 15. DCS-/Syria-interne Meldungen

Im Log können DCS- oder Syria-interne Meldungen erscheinen.

Beispiele:

    INVALID ATC HI08
    missing object declaration
    texture not found
    DTC_MANAGER
    Window pointer is null
    getObjectPosition: object is not exists
    Destruction shape not found
    render target not found

Diese Meldungen sind aktuell kein Theater-Command-Blocker, solange:

- kein TC-bezogener Lua-Fehler auftritt
- kein TC-bezogener Stack Traceback erscheint
- Frameworks erkannt werden
- Main startet
- Runtime-Systeme initialisiert werden
- F10Menu startet
- Loader sauber beendet

---

## 16. Was aktuell nicht im Mission Editor gebaut wird

Aktuell bewusst nicht produktiv gebaut:

- keine rote Frontlinie
- keine komplette Syria-Befüllung
- keine produktive IADS-Großstruktur
- keine CTLD-Zonen
- keine FOB-Zonen
- keine Template-Gruppen
- keine statischen Missionsziele
- keine großen Triggerketten
- keine MOOSE-Spawn-Templates als produktive Kampagnenlogik
- keine CTLD-Crate-Wirtschaft
- kein automatischer Startup-Restore

Wichtig:

    F10-Menü ist inzwischen vorhanden.
    Dieser ältere Punkt "keine F10-Menüs" ist nicht mehr korrekt.

    Nicht mehr korrekt: "keine produktive Persistenz" (pauschal).
    Richtig: Background Save ist aktiv und getestet. Keine automatische Kampagnenfortsetzung aus Save beim Missionsstart.

Grund für Zurückhaltung:

    Die state-first Runtime wird zuerst stabilisiert.
    Erst danach werden echte Framework-Aktionen eingebunden.

---

## 17. Spätere Mission-Editor-Elemente

Später werden im Mission Editor voraussichtlich benötigt:

- zusätzliche Client-Slots
- CTLD-Pickup-Zonen
- CTLD-Dropoff-Zonen
- FOB-Bauzonen
- Late-Activation-Template-Gruppen
- MOOSE-Template-Gruppen
- rote SAM-Stellungen
- rote Radarstellungen
- Skynet-IADS-Sites
- statische Missionsziele
- Logistikobjekte
- eventuell manuelle Sonderzonen
- Debug-Testobjekte

Diese Elemente werden erst ergänzt, wenn die jeweilige Lua-Logik fachlich bereit ist und der konkrete Entwicklungsschritt dies verlangt. Sie werden jetzt nicht vorgezogen.

---

## 18. Starttest-Variante B

Status:

    Noch nicht durchgeführt

Ziel:

    Loader-only-Test mit dofile

Idee:

    Der Mission Editor lädt nur:
    Frameworks
    src/loader.lua

Der Loader soll dann die übrigen Source-Dateien selbst nachladen.

Prüffragen:

- Funktioniert `dofile` im DCS Mission Scripting Environment?
- Kann `loader.lua` lokale Dateien aus dem Repository nachladen?
- Wird der Script-Root korrekt erkannt?
- Blockiert die DCS-Sandbox?
- Wird später eine Build-Datei benötigt?
- Bleibt Einzeldatei-Ladung für Entwicklung sinnvoller?

Diese Variante wird erst in einer späteren Session getestet.

Aktuelle Entscheidung:

    Starttest-Variante A bleibt bis dahin Standard.

---

## 19. Aktueller getesteter Systemstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | funktional bestanden; Read-Dirty- und Ownership-No-Op-Regressionen bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | Embedded Start, `SAVED`, `SKIPPED`, `FAILED`, Retry und Campaign-Persistence-Regressionen bestanden; `productiveRestore=false` |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | funktional bestanden; Dirty-Coverage ist nächster Priority-3-Audit |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | funktional bestanden; allgemeine Dirty-Coverage offen |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | 10 Mission Records; Activation, Completion, Failure und Effects bestanden; Record-Loss widerlegt; allgemeine Dirty-Coverage offen |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | state-first bestanden; `reactToActiveMissions()`-Sonderfall bewertet; allgemeine Dirty-Coverage offen |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.3` | bestanden; 33 Commands |

Priority 3 ist **nicht abgeschlossen**. Bereits geklärt: Capture Getter-/Derived-Dirty, Capture Ownership No-Op, `reactToActiveMissions()`-Sonderfall. Noch systematisch zu prüfen, jeweils einzeln: `tc_logistics_delivery.lua`, `tc_fob_system.lua`, `tc_mission_generator.lua`, `tc_ai_cap_manager.lua`. Nächster technischer Einzelschritt: READ-ONLY Dirty-Coverage-Audit von `src/logistics/tc_logistics_delivery.lua`; dafür ist keine Mission-Editor-Änderung notwendig.

---

## 20. Nächster sinnvoller Schritt

Der nächste sinnvolle technische Schritt liegt weiterhin nicht im Mission Editor.

F10-Menü um Capture-/Pressure-Sichtbarkeit zu erweitern ist abgeschlossen und nicht mehr der nächste Schritt.

Neuer nächster technischer Schritt:

    Priority 3
    READ-ONLY Dirty-Coverage-Audit von src/logistics/tc_logistics_delivery.lua

Audit-Ziele:

- persistierte Logistics-State-Writes identifizieren
- `markDirty()`-Pfade erfassen
- Call-Sites erfassen
- echte Mutationen prüfen
- Reads/No-Ops prüfen
- Dirty Reasons prüfen
- runtime-only vs. persistierten State unterscheiden
- keine Codeänderung ohne belegten Befund

Für diesen Schritt ist zunächst keine Mission-Editor-Änderung notwendig.

Begründung:

    CaptureSystem v0.2.2 hat die Capture-Getter- und Ownership-No-Op-Regressionen bereits bestanden.
    F10Menu v0.2.3 mit Capture-/Pressure-Sichtbarkeit ist stabil und bestätigt getestet.
    Priority 3 ist insgesamt noch nicht abgeschlossen.
    LogisticsDelivery, FobSystem, MissionGenerator und AICapManager werden einzeln auf Dirty-Coverage geprüft, beginnend mit LogisticsDelivery.

---

## 21. Aktueller Status

Die Mission-Editor-Grundlage ist für die aktuelle Entwicklungsphase ausreichend und bestanden.

Starttest-Variante A ist bestanden.

Die DEV-Mission bleibt als technischer Testträger bestehen; sie ist keine fertige Kampagnenmission.

Aktuell bestätigt:

- Framework-Ladung
- TC Source-Ladung
- Main/Loader
- Runtime-Initialisierung
- F10Menu v0.2.3 / 33 Commands
- Mission Details
- Mission Activation
- Mission Completion
- Mission Failure
- Capture Status
- Capture Ready Zones
- Capture Ready Apply
- Pressure Contested Zones
- Zone/Airbase Ownership Sync
- Background Persistence
- Embedded Resource Audit 13/13 EXACT_MATCH

Nächster Entwicklungsschritt:

    src/logistics/tc_logistics_delivery.lua
    READ-ONLY Dirty-Coverage-Audit (Priority 3).
