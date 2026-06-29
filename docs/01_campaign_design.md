# Campaign Design

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
- verfügbare Missionen
- aktive Missionen
- abgeschlossene Missionen
- Logistikstatus
- FOB-Status
- AI-Reaktionen
- CAP-State
- später IADS-Zustand
- später Persistenzdaten

Die Kampagne soll langfristig nicht nur auf Spieleraktionen reagieren.

Blue und Red sollen perspektivisch eigene Operationen planen und durchführen.

Spieler sollen sich in eine laufende Kampagnenlage einklinken.

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

---

## 3. Aktueller Projektstand

Stand:

    2026-06-29

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
    Missionskandidaten: 69
    FOB-Support-Kandidaten: 2
    verfügbare Missionen: 10
    F10 Commands: 26
    Capture-Pressure-Records: 32
    Capture-Progress-Records: 32

Wichtigste Designfolgerung:

    Die Kampagne darf nicht alle von DCS erkannten Airbase-like Objects gleich behandeln.

DCS liefert auf der Syria Map 225 airbase-like objects.

Davon sind aktuell nur 46 für Theater Command als relevante Kampagnenzonen geeignet.

Davon sind aktuell 32 als capture-fähige strategische oder sekundäre Kampagnenziele geeignet.

Helipads, Medical Pads, Tactical Pads und unbekannte Objekte sind nicht automatisch strategische Kampagnenziele.

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
    F10-Menü ist sichtbar und testbar
    keine produktive rote Frontlinie
    keine produktiven IADS-Stellungen
    keine produktiven CTLD-Zonen
    keine produktiven Template-Gruppen
    keine echten MOOSE-Spawns
    keine echten CTLD-FOBs
    keine produktive Persistenz

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

    Die ersten vier Grundlagen sind state-only vorbereitet:
    Airbase-/Zonenverständnis, Capture-Grundlage, Logistics-/FOB-Grundlage und Missionserzeugung.

Noch nicht produktiv:

    echte rote Gegenreaktionen
    echte IADS-Neuordnung
    echte persistente Kampagnenfolgen

---

## 9. Phase 1 — Initiale Lage

Zu Beginn:

- Blau startet auf Akrotiri.
- Rot kontrolliert das syrische Festland.
- Es gibt noch keine blaue Frontlinie auf dem Festland.
- Es gibt noch keine produktiv gebauten CTLD-FOBs.
- Es gibt noch keine produktive automatische Capture-Auswertung.
- Es gibt noch keine produktive Persistenz.

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

Sie können später:

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

Capture soll später abhängig sein von:

- Missionsfortschritt
- Capture-Pressure
- Bodennähe oder Triggerlogik
- Logistikstatus
- FOB-Unterstützung
- AI-Widerstand
- IADS-Zustand
- Kampagnenphase

Aktuelle Einschränkung:

    Automatische produktive Capture-Folgen sind noch deaktiviert.
    Capture-Pressure und Capture-Progress sind vorbereitet, aber noch nicht über echte Missionserfolge produktiv wirksam.

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

    Version: v0.2.2
    mission candidates: 69
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1

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

---

## 17. Spielerinteraktion

Spielerinteraktion erfolgt inzwischen über ein aktives F10-Menü.

Aktuelles F10Menu:

    Datei: src/ui/tc_f10_menu.lua
    Version: v0.2.0
    Status: bestanden
    Commands: 26

Aktuelle F10-Funktionen:

- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Mission 1 bis Mission 10 Details anzeigen
- Mission 1 bis Mission 10 aktivieren
- Kampagnenstatus anzeigen
- Logistikstatus anzeigen
- FOB-Status anzeigen
- AI-CAP-Status anzeigen

Bestätigt:

    F10-Menü ist sichtbar.
    F10-Menü ist navigierbar.
    Mission Details funktionieren.
    direkte Missionsaktivierung funktioniert.
    MissionGenerator setzt aktivierte Missionen auf ACTIVE.
    Aktivierung bleibt state-only.

Nächster UI-Schritt:

    Capture-/Pressure-Status im F10-Menü sichtbar machen.

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

Die Kampagne soll später persistent werden.

Persistenz soll speichern:

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

    PersistenceSystem-Grundstruktur ist vorhanden.
    Modul lädt und startet.
    Datei-Persistenz ist noch nicht produktiv getestet.

Wichtig:

    DCS-Sandbox-Verhalten muss vor echter Dateipersistenz geprüft werden.

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

    Missionen können aktiviert werden.
    Capture-Pressure und Capture-Progress sind vorbereitet.
    Missionserfolge werden noch nicht automatisch ausgewertet.
    Capture-Fortschritt wird noch nicht produktiv durch Missionserfolge verändert.

---

## 25. Nicht-Ziele im aktuellen Stand

Aktuell wird bewusst nicht gebaut:

- keine vollständige Kampagnenstory
- keine komplette rote Frontlinie
- keine komplette Syria-Befüllung
- keine produktive IADS-Struktur
- keine produktive CTLD-Logistik
- keine echten MOOSE-Spawns
- keine produktive Persistenz
- keine automatische `.miz`-Generierung
- keine Multiplayer-Synchronisation
- keine kommerzielle Release-Struktur

Grund:

    Zuerst muss die state-first Runtime-Grundlage stabil bleiben.
    Danach müssen Sichtbarkeit, Debug, Missionserfolg und Persistenz kontrolliert aufgebaut werden.

---

## 26. Nächster Kampagnendesign-Schritt

Der nächste fachliche und technische Schritt ist:

    Capture-/Pressure-Status im F10-Menü sichtbar machen.

Empfohlene Datei:

    src/ui/tc_f10_menu.lua

Warum:

    CaptureSystem v0.2.1 erzeugt jetzt Pressure- und Progress-Daten.
    Diese Daten sind im State vorhanden.
    Ohne F10-/Debug-Sichtbarkeit sind weitere Capture- und Missionseffekt-Tests schwer bewertbar.
    F10Menu ist stabil und bereits getestet.

Ziel:

- Capture Status anzeigen
- Capture Ready Zones anzeigen
- Pressure Contested Zones anzeigen
- Capture-Pressure und Capture-Progress lesbar machen
- weiterhin state-only bleiben
- keine echten Spawns auslösen
- keine CTLD-Aktionen auslösen
- keine Skynet-Aktionen auslösen

---

## 27. Aktueller Status

Das Kampagnendesign ist als dynamisches System angelegt.

Die state-first Runtime-Grundlage ist bestanden.

Die Kampagne ist noch nicht spielbar.

Aktuelle Fähigkeit:

- Airbase-Objekte werden klassifiziert.
- relevante Kampagnenzonen werden erzeugt.
- Capture-Ziele werden erkannt.
- Capture-Pressure und Capture-Progress werden vorbereitet.
- Logistics Hubs werden erzeugt.
- FOB-Kandidaten und erste Blue-FOBs werden erzeugt.
- Missionen inklusive FOB-Support werden erzeugt.
- Missionen können über F10 direkt ausgewählt und aktiviert werden.
- AI-CAP-State wird vorbereitet.
- Main und Loader starten sauber.

Nächster notwendiger Schritt:

    Capture-/Pressure-Sichtbarkeit im F10-Menü.
