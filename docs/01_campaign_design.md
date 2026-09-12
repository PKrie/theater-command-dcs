# Campaign Design

## Verbindliches Update — 2026-09-12

Das Kampagnendesign bleibt state-first. MissionGenerator `v0.2.3` erzeugt 10 Mission Records in String-keyed Lua-Status-Dictionaries: `pairs()` bestätigt 10, `#available=0` ist dafür nicht autoritativ. Der frühere Record-Loss-Verdacht ist widerlegt. Der tatsächliche Bug lag in `State.summary()`; der pairs-basierte `countEntries()`-Fix ist live bestanden. Die Mission-/Capture-Pfade sind dadurch nicht mehr blockiert.

Der Offline Embedded Resource Audit ist abgeschlossen: DEV und MCP_TEST waren beim Audit byte-identisch, 13/13 relevante aktive Theater-Command-Ressourcen waren `EXACT_MATCH`, keine aktive Embedded-Runtime-Drift. Die Altressource `ResKey_Action_55` / `tc_persistence_system.lua` liegt weiterhin verwaist in der `.miz`: Trigger-Verweis entfernt, nicht referenziert, nicht geladen, nicht ursächlich; separate spätere Cleanup-Aufgabe.

PersistenceSystem `v0.2.6` sichert Kampagnenänderungen durch aktiven dirty-aware Background Autosave. Embedded Start, `20s`-/`120s`-Scheduler, `SAVED`, `SKIPPED`, kontrollierter `FAILED`-Pfad und Retry sind bestanden. `productiveRestore=false`: gespeicherter Fortschritt wird beim Missionsstart noch nicht automatisch fortgesetzt.

Am 2026-09-12 erneut live bestanden: Mission Completion, Mission Failure und Capture Ready Apply einschließlich Background Save. Zusätzlich bestanden: Capture Getter Dirty-Neutralität und Capture Ownership No-Op. Priority 3 bleibt offen; nächster technischer Schritt ist LogisticsDelivery Dirty-Coverage READ ONLY.

Die folgenden Abschnitte unterscheiden bestätigte Kampagnenmechanik von langfristigem Design. Technische Nachweise stehen in `TASKS.md`, `docs/02_technical_architecture.md`, `docs/06_mission_generator.md`, `docs/07_ai_director.md`, `docs/09_persistence.md` und `docs/10_testing.md`.

Diese Datei beschreibt das Kampagnendesign der ersten Theater-Command-DCS-Kampagne.

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## 1. Grundidee der Kampagne

**Operation Levant Reclamation** soll keine lineare Einzelmission werden.

Ziel ist eine dynamische Kampagne, in der Spieler, KI, Missionen, Logistik, Luftüberlegenheit, SEAD/DEAD, Capture-Operationen und Unterstützungseinsätze den Kampagnenzustand verändern.

Die Kampagne soll aus einem zentralen Zustand heraus arbeiten.

Dieser Zustand enthält unter anderem:

- Besitzstatus von Airbases
- Besitzstatus von Zonen
- Capture-Eligibility
- Capture-Pressure
- Capture-Progress
- Capture Ready
- Mission Records in Status-Collections
- Logistics Hubs
- FOB-State
- AI-CAP-State
- Persistence-State
- später eigener IADS-Kampagnen-State

Die Kampagne soll langfristig nicht nur auf Spieleraktionen reagieren.

Blue und Red sollen perspektivisch eigene Operationen planen und durchführen.

Spieler sollen sich in eine laufende Kampagnenlage einklinken.

Background Persistence ist bereits aktiv und technisch bestätigt. Produktiver Restore folgt später; die automatische Fortsetzung einer Kampagne nach Missionsneustart bleibt ein Ziel.

---

## 2. Architekturprinzip

Das zentrale Prinzip lautet:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der DCS Mission Editor stellt die physische Umgebung bereit:

- Karte
- Koalitionen
- Flugplätze
- Client-Slots
- Trigger
- Zonen
- Templates
- Framework-Dateien

Lua übernimmt die eigentliche Kampagnenlogik.

GitHub dokumentiert Entscheidungen, Versionen, Aufgabenstand und Testergebnisse.

Fachliche Verantwortung: MissionGenerator erzeugt Aufträge und Effects, entscheidet aber nicht selbst über Ownership. CaptureSystem entscheidet über Capture-Wirkungen, UI gibt kontrollierten Zugang und Persistence sichert State. AI Director bleibt die spätere strategische Koordination. Vendor-Frameworks sind technische Werkzeuge; State-first kommt vor ihrer produktiven Ausführung.

---

## 3. Aktueller Projektstand

Stand:

    Historische Baseline: 2026-06-29
    Verbindlicher aktueller Stand: 2026-09-12

Aktueller Gesamtstatus:

    State-first Runtime-Grundlage stabil getestet.

Aktuell vorhanden und getestet:

- Repository-Grundstruktur
- zentrale Projektdokumentation
- `docs/`-Dokumentation
- `mission_editor/`-Dokumentation
- `vendor/`-Frameworkstruktur
- MIST
- MOOSE
- CTLD
- Skynet IADS
- `src/`-Grundstruktur
- Loader
- Main-Initialisierung
- Core-System
- World-System
- Campaign-System
- Logistics-System
- Missions-System
- AI-CAP-System
- UI-System mit F10-Menü
- IADS- und Debug-Bereiche vorbereitet
- minimale Syria-DEV-Mission
- erster blauer F/A-18C-Client-Slot auf Akrotiri
- sichere Einzeldatei-Ladung im Mission Editor
- reale DCS-Starttests
- erfolgreiche `dcs.log`-Auswertungen
- direkte Missionsauswahl über F10
- direkte Missionsaktivierung über F10

Aktueller Teststatus:

    Die state-first Runtime-Grundlage ist bestanden.
    Das Projekt ist noch keine fertige spielbare dynamische Kampagne.

Aktuell außerdem bestanden:

- MissionGenerator state-first funktional; Mission Activation, Completion, Failure und Effects.
- Completion -> Capture Pressure; Failure -> kein Capture Pressure.
- Capture Ready und kontrollierter Capture Ready Apply.
- Zone Ownership Update und linked Airbase Ownership Sync.
- dirty-aware Background Autosave und Embedded Resource Audit.

`productiveRestore=false`; Priority 3 bleibt offen. Produktive Framework-Ausführung und ein produktiver AI Director sind weiterhin nicht vorhanden.

---

## 4. Bestätigte technische Kernwerte

Aktuell bestätigte Werte aus DCS-Logs:

    Syria airbase-like objects: 225
    relevante Kampagnenzonen: 46
    capture-fähige Basen: 32
    capture-fähige Zonen: 32
    Logistics Hubs: 46
    FOB-Kandidaten: 6
    automatisch geplante Blue-FOBs: 2
    Missionskandidaten: 78
    FOB-Support-Kandidaten: 2
    Mission Records: 10
    F10 Commands: 33
    Capture-Pressure-Records: 32
    Capture-Progress-Records: 32
    CAP-Zonen-Kandidaten: 31
    CAP Requests: 12

Wichtigste Designfolgerung:

    Die Kampagne darf nicht alle von DCS erkannten Airbase-like Objects gleich behandeln.

DCS liefert auf der Syria Map 225 airbase-like objects.

Davon sind aktuell nur 46 für Theater Command als relevante Kampagnenzonen geeignet.

Davon sind aktuell 32 als capture-fähige strategische oder sekundäre Kampagnenziele geeignet.

Helipads, Medical Pads, Tactical Pads und unbekannte Objekte sind nicht automatisch strategische Kampagnenziele.

Die 10 Mission Records liegen in String-keyed Status-Dictionaries. Autoritative Counts erfolgen über `pairs()` bzw. pairs-basierte Helfer; `#` ist dafür nicht autoritativ. Statuswechsel verteilen vorhandene Records auf die jeweiligen Collections.

---

## 5. Aktuelle DEV-Mission

Aktuelle technische Entwicklungsmission:

    Operation_Levant_Reclamation_DEV.miz

Aktueller Inhalt:

    Map: Syria
    Koalitionspreset: Modern
    Blue Start: Akrotiri / Zypern
    erster blauer Client-Slot: F/A-18C Lot 20 auf Akrotiri
    Trigger: sichere Einzeldatei-Ladung
    Vendor-Frameworks werden geladen
    Theater-Command-Source-Dateien werden geladen
    F10Menu v0.2.3 mit 33 Commands ist sichtbar und testbar
    Mission Activation/Completion/Failure sind testbar
    Capture Ready Apply ist testbar
    PersistenceSystem v0.2.6 ist eingebettet
    dirty-aware Background Autosave ist aktiv
    keine produktive rote Frontlinie
    keine produktiven IADS-Stellungen
    keine produktiven CTLD-Zonen
    keine produktiven Template-Gruppen
    keine echten MOOSE-Spawns
    keine echten CTLD-FOBs
    kein produktiver Startup-Restore
    keine autonomen AI-Operationen

Diese Mission ist aktuell ein technischer Testträger.

Sie ist noch keine fertige spielbare Kampagnenmission.

---

## 6. Strategische Ausgangslage

Zu Kampagnenbeginn kontrolliert Blau nur den Startbereich auf Zypern.

Blauer Startpunkt:

    Akrotiri / Zypern

Roter Ausgangsraum:

    syrisches Festland vollständig rot kontrolliert

Die Kampagne beginnt damit aus einer asymmetrischen Ausgangslage:

- Blau besitzt eine sichere Offshore-Startbasis
- Rot hält das syrische Festland
- Blau muss zunächst Aufklärung, Luftüberlegenheit, SEAD/DEAD und logistische Voraussetzungen schaffen
- Rot besitzt zu Beginn die operative Tiefe auf dem Festland
- Fortschritt entsteht durch dynamische Missionen und spätere Capture-/Logistikmechanik

---

## 7. Politische und militärische Grundannahme

Die genaue Story wird später weiter ausgearbeitet.

Aktuelle Grundannahme:

    Eine internationale Koalition startet von Akrotiri aus eine Operation zur Rückgewinnung und Stabilisierung des östlichen Mittelmeerraums und der syrischen Küstenregion.

Das syrische Festland ist zu Kampagnenbeginn unter roter Kontrolle.

Die blaue Koalition muss schrittweise:

- Luftlage aufklären
- feindliche Luftverteidigung schwächen
- Luftüberlegenheit herstellen
- logistische Korridore sichern
- erste Brückenköpfe vorbereiten
- FOBs aufbauen
- strategische Basen angreifen oder erobern
- Missionsdruck auf rote Systeme erhöhen
- den Kampagnenzustand dauerhaft verändern

---

## 8. Geplanter Kampagnenverlauf

Der Kampagnenverlauf soll nicht als feste Missionskette gebaut werden.

Er soll durch den Kampagnenzustand entstehen.

Geplante Eskalationslogik:

1. Aufklärungs- und Orientierungsphase
2. Luftüberlegenheitsphase
3. SEAD-/DEAD-Phase
4. Logistik- und FOB-Aufbau
5. Angriffe auf strategische Ziele
6. Capture-Operationen gegen wichtige Basen
7. Ausweitung der blauen Operationszone
8. rote Gegenreaktionen
9. IADS-Neuordnung und Gegenmaßnahmen
10. persistenter Kampagnenfortschritt

Aktueller technischer Stand:

    Airbase-/Zonenverständnis, Logistics-/FOB-Grundlage, Mission Generation und AI-CAP-State sind bestätigt.
    Capture Pressure/Progress werden durch Mission Completion wirksam.
    Mission Failure erzeugt im getesteten Pfad keinen Capture Pressure.
    Capture Ready, kontrollierter Apply und Zone-/Airbase-Ownership-Sync sind bestanden.
    Background Persistence sichert diese getesteten State-Änderungen.

Noch nicht produktiv:

    autonome Blue-/Red-Gegenreaktionen
    produktive IADS-Neuordnung
    echte CTLD-/MOOSE-Operationen
    produktiver Restore
    vollständige autonome Kampagnenfortschreibung

---

## 9. Phase 1 — Initiale Lage

Zu Beginn:

- Blau startet auf Akrotiri.
- Rot kontrolliert das syrische Festland.
- Es gibt noch keine blaue Frontlinie auf dem Festland.
- Es gibt noch keine produktiv gebauten CTLD-FOBs.
- Es gibt noch keine produktive automatische Capture-Auswertung.
- Background Autosave ist technisch aktiv; produktiver Startup-Restore bleibt deaktiviert.

Ziel dieser Phase:

- technische Startkette stabilisieren
- Airbase- und Zonenlogik sauber aufbauen
- strategische Basen erkennen
- Kampagnenzustand initialisieren
- Missionen aus echten State-Daten ableiten
- erste Spielerinteraktion über F10 ermöglichen

Aktueller Stand:

    Technische Startkette bestanden.
    Airbase-Erkennung funktioniert.
    Airbase-Klassifizierung funktioniert.
    ZoneFactory funktioniert.
    CaptureSystem funktioniert state-only.
    LogisticsDelivery funktioniert state-only.
    FobSystem funktioniert state-only.
    MissionGenerator funktioniert state-only.
    F10Menu funktioniert.

Mission Completion/Failure funktionieren state-only, Capture Ready Apply funktioniert kontrolliert und Persistence Background Save sichert die Änderungen. Damit ist ein getesteter Fortschrittspfad vorhanden; autonome Kampagnenfortsetzung ist noch nicht aktiv.

---

## 10. Phase 2 — Airbase- und Zonenverständnis

Der reale DCS-Test hat gezeigt:

    225 Airbase-like Objects werden erkannt.

Diese Objekte werden unterschieden in:

- strategische Airfields
- Secondary Airfields
- Heliports
- Helipads
- Medical Pads
- FARPs
- Tactical Pads
- Unknown

Aktueller Airbase-Scanner-Stand:

    strategic: 19
    secondary: 13
    heliports: 1
    helipads: 95
    medical: 40
    farps: 0
    tactical: 13
    unknown: 44

Nur strategische Airfields und ausgewählte Secondary Airfields dienen aktuell als echte Capture- und Missionsziele.

Helipads, Medical Pads und Tactical Pads können später Spezialrollen erhalten, sind aber keine vollwertigen strategischen Basen.

---

## 11. Strategische Airfields

Strategische Airfields sind zentrale Kampagnenobjekte.

Vorgesehene Rollen, teilweise bereits state-first umgesetzt:

- Besitzerstatus haben
- erobert werden
- als Logistikhub dienen
- als Missionsziel dienen
- als Spawn-/Startpunkt dienen
- in Persistenz gespeichert werden
- AI-Reaktionen auslösen
- IADS- und CAP-Logik beeinflussen

Aktueller Stand:

    19 strategische Airfields erkannt.
    Akrotiri ist die erste bestätigte strategische blaue Basis.
    18 rote strategische Kandidaten sind vorbereitet.

Besitzstatus, Missions-/Logistikbezug und Speicherung sind bereits Teil der State-Grundlage. Kontrollierter Capture Apply ist bestätigt; reale Spawn-/Startnutzung und autonome AI-/IADS-Folgen bleiben spätere Integration.

---

## 12. Sekundäre Airfields

Sekundäre Airfields erhalten eine reduzierte, aber reale Kampagnenrolle.

Mögliche Rollen:

- Zwischenziel
- Forward Operating Location
- logistischer Zwischenpunkt
- Helikopterstützpunkt
- begrenztes Missionsziel
- Capture-Ziel

Aktueller Stand:

    13 secondary Airfields erkannt.
    Secondary Airfields sind aktuell Teil der 32 capture-/mission-fähigen Ziele.

---

## 13. Heliports, Helipads und Medical Pads

Diese Objekte werden nicht ignoriert.

Sie sind aber keine vollwertigen strategischen Basen.

Mögliche spätere Rollen:

- CTLD-Zonen
- CSAR-Punkte
- MEDEVAC-Szenarien
- FOB-Unterstützung
- Helikoptermissionen
- taktische Landezonen

Nicht geeignet als Standard:

- strategische Capture-Ziele
- Hauptlogistikhubs
- CAP-Zentren
- zufällige Strike-Ziele des Missionsgenerators

Aktueller Stand:

    Heliports, Helipads, Medical Pads und Tactical Pads werden sauber klassifiziert.
    Sie werden nicht blind als strategische Kampagnenziele verwendet.

---

## 14. FARPs und FOBs

FARPs und FOBs gehören fachlich eng zusammen.

FARPs können später wichtig werden für:

- AH-64D-Operationen
- Transporthubschrauber
- CTLD
- Forward Refuel/Rearm
- logistische Frontunterstützung
- temporäre Kampagnenpräsenz

FOBs sollen durch Logistik aufgebaut und verbessert werden können.

Aktueller FOB-Stand:

    FOB candidates: 6
    auto-planned Blue FOBs: 2
    Blue FOBs: FOB Ercan, FOB Gecitkale
    Status: UNDER_CONSTRUCTION

Wichtig:

    FOBs sind aktuell State-only.
    Es werden noch keine echten CTLD-FOBs erzeugt.
    Der FOB-Aufbau wird später durch Theater-Command-Logik und CTLD-Cargo gesteuert.

---

## 15. Capture-Design

Das Capture-System verwaltet den strategischen Besitz von Basen und Zonen.

Grundregel:

    Capture darf nur auf geeignete strategische Kampagnenobjekte angewendet werden.

Nicht standardmäßig capturable:

- Medical Pads
- einzelne Helipads
- unbekannte Objekte
- rein taktische Pads

Aktuell capturable:

- strategische Airfields
- sekundäre Airfields
- strategische Airbase-Zonen
- sekundäre Airbase-Zonen
- definierte Mission-Editor-Capture-Zonen

Aktueller bestätigter Stand:

    eligibleBases: 32
    eligibleZones: 32
    pressureRecords: 32
    progressRecords: 32

Capture nutzt bereits Mission Effects, Pressure und Progress. Später soll das Design weitere Faktoren zusammenführen:

- Missionsfortschritt
- Capture-Pressure
- Bodennähe oder Triggerlogik
- Logistikstatus
- FOB-Unterstützung
- AI-Widerstand
- IADS-Zustand
- Kampagnenphase

Bestätigter Wirkungspfad:

    Mission Completion -> Capture Pressure -> Capture Progress -> Capture Ready
    Mission Failure -> Effects processed -> applied=0 -> kein Capture Pressure

Kontrollierter Capture Ready Apply wurde für `ZONE_AIRBASE_ABU_AL_DUHUR` bestätigt: vor Apply `RED -> BLUE` bei `100 %`; danach `zoneOwner=BLUE`, `previousOwner=RED`, `baseOwner=BLUE`, `progress=0`, `status=STABLE`, `captureReady=false`. Damit verändert der getestete Mission-Completion-Pfad tatsächlich Capture-Fortschritt; Apply überführt Bereitschaft kontrolliert in Besitz und synchronisiert die linked Airbase.

Weiterhin fehlen automatische DCS-Bodenlage-Capture-Auswertung und autonome Capture-Entscheidungen. Unkontrollierte automatische Ownership-Wechsel sind nicht aktiv.

Designregel: Unveränderte Reads und echte No-Ops dürfen keinen Dirty-State erzeugen. Die Capture-Getter- und Ownership-No-Op-Regressionen sind bestanden.

---

## 16. Missionsdesign

Missionen entstehen dynamisch aus dem Kampagnenzustand.

Aktuelle Missionstypen:

- Recon
- CAP
- SEAD
- DEAD
- Strike
- CAS
- Interdiction
- Escort
- Logistics
- FOB Support
- Airbase Attack
- IADS Suppression

Missionen werden nicht zufällig aus allen DCS-Objekten erzeugt.

Der Missionsgenerator wählt geeignete Ziele aus:

- strategische Airfields
- secondary Airfields
- relevante Capture-Zonen
- Logistics-Zonen
- FOBs mit Supportbedarf
- später IADS-Ziele

Aktueller MissionGenerator-Stand:

    Version: v0.2.3
    mission candidates: 78
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 68

Aktuelle Mission Records enthalten:

- Objective
- Briefing
- Progress
- Activation Metadata
- Execution Plan
- Effect
- reserved MOOSE Hook
- reserved CTLD Hook
- reserved Skynet Hook

Aktuelle Einschränkung:

    Missionen sind state-only.
    Es werden noch keine echten DCS-Spawns ausgelöst.

Mission Details sowie die Statuswechsel `AVAILABLE -> ACTIVE`, `ACTIVE -> COMPLETED` und `ACTIVE -> FAILED` sind bestätigt. MissionGenerator bereitet Effects vor; Completion -> Capture Pressure und Failure -> kein Capture Pressure sind getestet. Die fachliche Ausführung bleibt state-only ohne echte Framework-Spawns.

Noch offen: `CANCELLED`, `EXPIRED`, automatische DCS-Event-Auswertung, Effects auf Logistics/AI/IADS und allgemeine MissionGenerator-Dirty-Coverage.

---

## 17. Spielerinteraktion

Spielerinteraktion erfolgt inzwischen über ein aktives F10-Menü.

Aktuelles F10Menu:

    Datei: src/ui/tc_f10_menu.lua
    Version: v0.2.3
    Status: bestanden
    Commands: 33

Aktuelle F10-Funktionen:

- Show Available Missions
- Show Active Missions
- Mission Details 1–10
- Mission Activation 1–10
- Active Mission Outcome Status
- Complete Active Mission 1
- Fail Active Mission 1
- Show Campaign Status
- Show Capture Status
- Show Capture Ready Zones
- Apply Capture Ready Zone 1
- Show Pressure Contested Zones
- Show Logistics Status
- Show FOB Status
- Show AI CAP Status

Bestätigt:

    F10-Menü ist sichtbar.
    F10-Menü ist navigierbar.
    Mission Details funktionieren.
    direkte Missionsaktivierung funktioniert.
    MissionGenerator setzt aktivierte Missionen auf ACTIVE.
    Aktivierung bleibt state-only.

Capture-/Pressure-Sichtbarkeit ist abgeschlossen. F10 bietet kontrollierten Spielerzugang zum State und führt keine direkten MOOSE-/CTLD-/Skynet-Aktionen aus.

---

## 18. Logistikdesign

Logistik soll ein Kernbestandteil der Kampagne werden.

Logistik beeinflusst später:

- FOB-Aufbau
- Versorgung von Basen
- Operationsreichweite
- Missionsverfügbarkeit
- Capture-Fähigkeit
- Verteidigungsfähigkeit
- AI-Reaktionen

Aktuelle Logistik-Module:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

Aktueller LogisticsDelivery-Stand:

    Version: v0.2.0
    Logistics Hubs: 46
    Blue Hubs: 7
    Red Hubs: 24
    Neutral Hubs: 15
    Active Hubs: 31
    Limited Hubs: 15

Aktueller FobSystem-Stand:

    Version: v0.2.0
    FOB candidates: 6
    Blue FOBs: 2
    FOB Ercan
    FOB Gecitkale

Aktuelle Einschränkung:

    Die CTLD-Anbindung folgt später.
    Noch keine echten CTLD-Pickup-Zonen.
    Noch keine echten CTLD-Dropoff-Zonen.
    Noch keine echten CTLD-FOBs.

LogisticsDelivery ist funktional bestätigt; seine allgemeine Dirty-Coverage ist noch nicht systematisch auditiert und der nächste Priority-3-Schritt, zunächst READ ONLY. Ein konkreter Bug wird damit nicht vorweggenommen. Auch FOB-Dirty-Coverage bleibt offen. Echte Cargo-/Dropoff-/FOB-Aktionen sind weiterhin nicht produktiv verbunden.

---

## 19. AI-Design

Die AI soll später auf den Kampagnenzustand reagieren.

Aktuelles AI-Modul:

    src/ai/tc_ai_cap_manager.lua

Aktueller Stand:

    Version: v0.2.0
    cap zone candidates: 31
    auto-registered CAP zones: 12
    CAP requests: 12
    reactionState: AIR_REACTION_REQUESTED
    threatLevel: HIGH

Geplante AI-Rollen:

- CAP-Verwaltung
- GCI-Reaktionen
- Verstärkungen
- Gegenangriffe
- Luftlageanpassung
- Reaktion auf Capture
- Reaktion auf IADS-Schäden
- Reaktion auf Logistikfortschritt

Die AI soll nicht isoliert arbeiten.

Sie soll Daten aus Campaign, World, Missions, Logistics und IADS nutzen.

Noch offen:

    echter AI Director
    echte MOOSE-CAP-Spawns
    echte Blue-vs-Red-Kampagnenentscheidungen

AICapManager bleibt state-only mit `MOOSE_PENDING`. Der vollständige AI Director und ein autonomes Blue-/Red-Operationsmodell sind nicht implementiert.

`reactToActiveMissions()` existiert, ist aber nicht produktiv verdrahtet: latenter Missing-Dirty-Randfall bei späterer Verdrahtung, aktuell kein Runtime-Persistence-Bug. `evaluateCapNeeds()` besitzt dagegen den bestätigten Dirty-Pfad `ai_cap_needs_evaluated -> Background Autosave SAVED`. Allgemeine AICapManager-Dirty-Coverage bleibt offen (Details in `docs/07_ai_director.md`).

---

## 20. IADS-Design

Skynet IADS wird als externes Framework genutzt.

Theater Command soll später eine eigene Kampagnenschicht darüber legen.

Geplante IADS-Funktionen:

- IADS-Sektoren
- SAM-Site-Status
- Radarstatus
- beschädigte oder zerstörte Systeme
- SEAD-/DEAD-Missionsziele
- IADS-Wiederaufbau oder Reaktion
- Persistenz des IADS-Zustands

Aktueller Stand:

    Skynet IADS wird geladen.
    Theater-Command-IADS-Modul ist noch nicht implementiert.
    MissionGenerator reserviert bereits Skynet-Hooks.
    Keine echte IADS-Kampagnenlogik aktiv.

---

## 21. Persistenzdesign

Background Persistence speichert bereits Kampagnen-State. Langfristiges Ziel bleibt eine automatisch fortgesetzte Kampagne über Missionsneustarts hinweg.

Fachlicher Speicherumfang für vorhandenen und später ergänzten State:

- Besitzstatus von Basen
- Besitzstatus von Zonen
- Capture-Pressure
- Capture-Progress
- Capture-Events
- Airbase-Klassifizierung
- aktive Missionen
- abgeschlossene Missionen
- Logistikstatus
- FOB-Status
- AI-Zustand
- IADS-Zustand
- wichtige Kampagnenereignisse

Aktueller Stand:

    PersistenceSystem v0.2.6 läuft dirty-aware im Hintergrund.
    Datei-Write und vollständige Read-back-Verifikation sind bestanden.
    Unveränderte Ticks werden ohne Dateischreiben übersprungen.
    Produktiver Startup-Restore bleibt deaktiviert.

PersistenceSystem `v0.2.6` ist mit Embedded Start, `20s` Initial Delay und `120s` Intervall bestätigt. Save, Read-back, Compile, Evaluate, Validation und kontrollierter Import sind technisch möglich bzw. bestanden; `SAVED`, `SKIPPED`, kontrollierter `FAILED`-Pfad und Retry sind getestet.

Bestätigte Kampagnenänderungen werden automatisch gesichert:

| Pfad | Ergebnis | dirtyReason |
|---|---|---|
| Mission Completion | `SAVED` | `f10_active_mission_1_completed` |
| Mission Failure | `SAVED` | `f10_active_mission_1_failed` |
| Capture Ready Apply | `SAVED` | `f10_capture_ready_zone_1_applied` |

Jeweils `dirtyCleared=true` nach erfolgreicher Save-Verifikation. Save-Sicherheitsprinzip: Dirty erst nach Write -> Read-back -> Compile -> Evaluate -> Validation löschen; bei Fehler erhalten. Ein neuerer Dirty-State darf nicht durch Abschluss eines älteren Saves gelöscht werden. So bleibt fachlicher Fortschritt bei einem fehlgeschlagenen Save weiterhin zur Sicherung vorgemerkt.

`productiveRestore=false`. Vor produktivem Restore sind Priority 3 abzuschließen, Restore-/Initialisierungsreihenfolge und Save-Kompatibilität/Versionierung zu definieren sowie ein kontrollierter Restore-Test durchzuführen. Unbeabsichtigte Framework-Hooks beim Restore müssen ausgeschlossen sein. Technische Details stehen in `docs/09_persistence.md`.

---

## 22. Kampagnenstart auf Akrotiri

Akrotiri ist der zentrale blaue Startpunkt.

Fachliche Rolle:

- Blue Main Operating Base
- sicherer Startpunkt
- erster Logistikhub
- Ausgangspunkt für Luftoperationen
- Ausgangspunkt für spätere See-/Luftbrücke
- nicht initiales rotes Missionsziel

Aktuell bestätigt:

    Akrotiri wird als Blue-Startbasis erkannt.
    Akrotiri wird als STRATEGIC_AIRFIELD klassifiziert.
    erster F/A-18C Lot 20 Client-Slot ist im Mission Editor vorhanden.

---

## 23. Roter Ausgangsraum

Der rote Ausgangsraum umfasst zu Beginn das syrische Festland.

Fachliche Rolle:

- rote strategische Tiefe
- rote Airbases
- rote IADS
- rote Logistik
- rote AI-Reaktionen
- rote Missionsziele
- spätere Capture-Ziele

Aktuell bestätigt:

    18 rote strategische Airbase-Kandidaten sind vorbereitet.
    24 rote Logistics Hubs sind vorbereitet.
    MissionGenerator erzeugt rote Zielmissionen state-only.

Noch nicht gebaut:

- produktive rote Frontlinie
- produktive rote IADS-Struktur
- rote Template-Gruppen
- echte rote AI-Flüge
- echte rote Gegenoffensive

---

## 24. Kampagnenfortschritt

Kampagnenfortschritt soll später nicht nur über zerstörte Einheiten entstehen.

Mögliche Fortschrittsfaktoren:

- Airbase-Zustand
- Zone-Zustand
- Missionserfolg
- Capture-Pressure
- Capture-Progress
- Logistiklieferungen
- FOB-Aufbau
- IADS-Schäden
- AI-Verluste
- Capture-Ereignisse
- persistente Zustandsänderungen

Aktueller Stand:

    Mission Completion -> Mission Effect -> Capture Pressure -> Capture Progress -> Capture Ready
    Kontrollierter Apply -> Ownership Update -> linked Airbase Sync -> Background Save
    Mission Failure -> kein Capture Pressure

Dieser Fortschrittspfad ist state-first praktisch bestätigt. Die automatische Erfolgsauswertung aus DCS-Events fehlt weiterhin; ebenso Logistics-/AI-/IADS-Folgen aus Mission Effects. Ein getesteter State-Fortschritt ist noch keine autonome Kampagnenfortschreibung.

---

## 25. Nicht-Ziele im aktuellen Stand

Aktuell wird bewusst nicht gebaut:

- keine vollständige Kampagnenstory
- keine komplette rote Frontlinie
- keine komplette Syria-Befüllung
- keine produktive IADS-Struktur
- keine produktive CTLD-Logistik
- keine echten MOOSE-Spawns
- kein autonomer AI Director
- kein produktiver Startup-Restore
- keine automatische `.miz`-Generierung
- keine Multiplayer-Synchronisation
- keine kommerzielle Release-Struktur

Grund:

    Zuerst muss die state-first Runtime-Grundlage stabil bleiben.
    Sichtbarkeit, Mission Outcomes und Background Save sind bestätigt.
    Jetzt muss die allgemeine Dirty-Coverage bestehender State-Module abgesichert werden.

---

## 26. Nächster Kampagnendesign-Schritt

Nächster technischer Projektschritt: **Priority 3 — READ-ONLY Dirty-Coverage-Audit von `src/logistics/tc_logistics_delivery.lua`**. Vorher wird kein neues Kampagnenfeature implementiert.

Priority 3 ist **nicht abgeschlossen**. Bereits geklärt sind Capture Getter-/Derived-Dirty, Capture Ownership No-Op und der `reactToActiveMissions()`-Sonderfall.

Noch systematisch zu prüfen, jeweils einzeln:

1. `src/logistics/tc_logistics_delivery.lua`
2. `src/logistics/tc_fob_system.lua`
3. `src/missions/tc_mission_generator.lua`
4. `src/ai/tc_ai_cap_manager.lua`

Designinvariante: Jede persistierte fachliche Mutation muss Dirty markieren. Unveränderte Reads und echte No-Ops sollen keinen unnötigen Dirty-State erzeugen.

Der nächste Logistics-Audit erfasst persistierte State-Writes, `markDirty()`-Pfade und Call-Sites; er unterscheidet echte Mutationen von Reads/No-Ops sowie runtime-only von persistiertem State und bewertet Dirty Reasons. Keine Codeänderung ohne belegten Befund. FOB, MissionGenerator und AI werden nicht parallel auditiert.

---

## 27. Aktueller Status

Das Kampagnendesign bleibt auf ein dynamisches System ausgerichtet, in dem Spieler Teilnehmer sind und Blue-/Red-Autonomie ein langfristiges Ziel bleibt. Die State-first-Grundlage und die folgenden Kernpfade sind bestätigt:

- Airbases klassifiziert, relevante Zonen erzeugt und Capture Targets erkannt.
- Capture Pressure/Progress aktiv state-first.
- Mission Completion -> Capture Pressure; Mission Failure -> kein Capture Pressure.
- Capture Ready und kontrollierter Capture Ready Apply.
- Zone Ownership Update und linked Airbase Ownership Sync.
- Logistics Hubs und FOB-State.
- 10 Mission Records mit Activation, Completion, Failure und Mission Effects.
- F10Menu `v0.2.3` mit 33 Commands.
- AI-CAP-State.
- dirty-aware Background Persistence.
- Embedded Resource Audit bestanden.

Weiterhin fehlen eine fertige spielbare Kampagne, autonome Blue-/Red-Operationen, produktive CTLD-/MOOSE-/Skynet-Kampagnenausführung und produktiver Startup-Restore (`productiveRestore=false`).

Priority 3 bleibt offen. Nächster technischer Einzelschritt: LogisticsDelivery Dirty-Coverage READ ONLY.
