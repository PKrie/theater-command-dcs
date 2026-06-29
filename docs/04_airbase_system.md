# Airbase System

Diese Datei beschreibt das Airbase-System von **Theater Command DCS**.

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## 1. Zweck des Airbase-Systems

Das Airbase-System bildet die Grundlage für die gesamte Kampagne.

Es erkennt, klassifiziert und bewertet DCS-Airbase-Objekte und bereitet daraus Kampagnendaten für andere Systeme vor.

Das Airbase-System entscheidet nicht allein über den Kampagnenverlauf.

Es liefert die Datenbasis für:

- ZoneFactory
- CaptureSystem
- LogisticsDelivery
- FobSystem
- MissionGenerator
- AICapManager
- spätere IADS-Integration
- spätere AI-Director-Logik
- spätere Persistenz

---

## 2. Grundproblem auf der Syria Map

DCS liefert auf der Syria Map nicht nur klassische Flugplätze.

Die Airbase-API liefert viele unterschiedliche airbase-like objects.

Dazu gehören unter anderem:

- große Flugplätze
- kleinere Airfields
- Heliports
- einfache Helipads
- Medical Pads
- Tactical Pads
- unbekannte Sonderobjekte

Wichtig:

    Nicht jedes DCS-Airbase-Objekt ist ein strategisches Kampagnenziel.

Deshalb darf Theater Command diese Objekte nicht ungefiltert behandeln.

Ein blindes Registrieren aller Objekte als Kampagnenzonen würde zu falscher Kampagnenlogik führen.

---

## 3. Aktueller technischer Stand

Stand:

    2026-06-29

Aktive Airbase-Datei:

    src/world/tc_airbase_scanner.lua

Getestete Version:

    v0.2.2

Status:

    bestanden

Bestätigt durch DCS-Logtests:

    Airbase Scanner lädt.
    Airbase Scanner startet.
    Airbase Scanner klassifiziert Syria-Airbase-Objekte.
    Airbase Scanner erzeugt Kampagnendaten.
    Airbase Scanner liefert Daten an spätere Systeme.
    Es gab keinen Theater-Command-Lua-Fehler.
    Es gab keinen Lua-Stacktrace.

---

## 4. Bestätigte Werte

Aktuell bestätigte Airbase-Werte:

    total: 225
    strategic: 19
    secondary: 13
    heliports: 1
    helipads: 95
    medical: 40
    farps: 0
    tactical: 13
    unknown: 44
    captureCandidates: 32
    missionCandidates: 32
    logisticsCandidates: 46
    blueStartBases: 1
    redStrategicCandidates: 18

Bewertung:

    225 erkannte Airbase-like Objects sind auf der Syria Map erwartbar.
    Die hohe Zahl ist kein Fehler.
    Entscheidend ist die fachliche Klassifizierung.
    Nur ein Teil dieser Objekte ist für Capture, Missionen und Logistik relevant.

---

## 5. Klassifikationsziel

Der Airbase Scanner klassifiziert DCS-Airbase-Objekte in fachliche Kategorien.

Aktuelle Kategorien:

- Strategic Airfield
- Secondary Airfield
- Heliport
- Helipad
- Medical Pad
- Tactical Pad
- FARP
- Unknown

Diese Klassifizierung ist wichtig, weil jedes Objekt später eine andere Kampagnenrolle haben kann.

---

## 6. Strategic Airfields

Strategic Airfields sind zentrale Kampagnenziele.

Sie können später:

- Besitzstatus haben
- Capture-Ziel sein
- Missionsziel sein
- Logistikhub sein
- Startpunkt für AI-Flüge sein
- Ziel von Strike-, SEAD-, DEAD- oder Airbase-Attack-Missionen sein
- Teil der Persistenz sein
- Einfluss auf AI-Director-Entscheidungen haben
- Einfluss auf IADS- und CAP-Logik haben

Aktuell bestätigt:

    strategic: 19

Akrotiri wird als strategischer Flugplatz erkannt.

Akrotiri ist zugleich die bestätigte blaue Startbasis.

---

## 7. Secondary Airfields

Secondary Airfields sind kleinere oder weniger zentrale Flugplätze.

Sie sind dennoch kampagnenrelevant.

Mögliche Rollen:

- begrenztes Capture-Ziel
- Forward Operating Location
- logistischer Zwischenpunkt
- Missionsziel
- regionaler Stützpunkt
- späterer Ausgangspunkt für kleinere AI-Operationen

Aktuell bestätigt:

    secondary: 13

Secondary Airfields sind aktuell Teil der 32 capture- und mission-fähigen Ziele.

---

## 8. Heliports

Heliports sind wichtiger als einfache Helipads, aber nicht automatisch strategische Hauptbasen.

Mögliche Rollen:

- Helikopterstützpunkt
- CTLD-Unterstützung
- CSAR-/Transportlogik
- späterer Sonderlogistikpunkt
- optionaler FOB- oder Support-Knoten

Aktuell bestätigt:

    heliports: 1

---

## 9. Helipads

Helipads sind auf der Syria Map zahlreich vorhanden.

Aktuell bestätigt:

    helipads: 95

Helipads sind nicht automatisch strategische Kampagnenziele.

Sie können später Spezialrollen erhalten:

- Landezone
- CSAR-Ort
- Medevac-Ort
- CTLD-Ziel
- FOB-Unterstützungspunkt
- taktischer Außenpunkt

Aktuell sollen sie nicht als Standard-Capture-Ziele behandelt werden.

---

## 10. Medical Pads

Medical Pads sind medizinische oder technische Landeplätze.

Aktuell bestätigt:

    medical: 40

Sie sind nicht als strategische Kampagnenziele geeignet.

Mögliche spätere Rollen:

- MEDEVAC-Szenario
- CSAR-Ziel
- humanitäre Aufgabe
- medizinischer Evakuierungspunkt
- Sondermission

Aktuelle Entscheidung:

    Medical Pads werden nicht als reguläre Capture-Ziele verwendet.
    Medical Pads werden nicht als strategische Airfields behandelt.
    Medical Pads werden nicht als Standard-Missionsziele des MissionGenerator genutzt.

---

## 11. Tactical Pads

Tactical Pads sind kleine taktische oder technische Airbase-like Objects.

Aktuell bestätigt:

    tactical: 13

Mögliche spätere Rollen:

- taktische Landezone
- Helikopteroperation
- CTLD-Außenpunkt
- Spezialziel
- Forward Support Area

Aktuelle Entscheidung:

    Tactical Pads sind nicht automatisch strategische Kampagnenziele.
    Sie werden nicht als Standard-Capture-Ziele verwendet.

---

## 12. FARPs

Aktuell bestätigt:

    farps: 0

DCS kann FARPs je nach Mission und Karte anders bereitstellen.

Im aktuellen Teststand wurden keine FARPs als Airbase-Klasse erkannt.

FARPs bleiben aber fachlich wichtig für spätere Kampagnenlogik.

Mögliche spätere Rollen:

- AH-64D-Operationen
- Transporthubschrauber
- CTLD
- Forward Refuel/Rearm
- FOB-Unterstützung
- temporäre Frontpräsenz

---

## 13. Unknown Objects

Aktuell bestätigt:

    unknown: 44

Unknown Objects sind DCS-Airbase-like Objects, die vom Scanner nicht sicher einer bekannten Kampagnenklasse zugeordnet werden.

Aktuelle Entscheidung:

    Unknown Objects werden konservativ behandelt.
    Sie werden nicht automatisch zu strategischen Capture-Zielen.
    Sie werden nicht automatisch zu Standard-Missionszielen.
    Sie können später manuell geprüft und nachklassifiziert werden.

Diese konservative Behandlung verhindert, dass technische oder irrelevante DCS-Objekte die Kampagne verfälschen.

---

## 14. Blue Start Base

Aktuell bestätigt:

    blueStartBases: 1

Bestätigte Blue Start Base:

    Akrotiri

Rolle von Akrotiri:

- Blue Main Operating Base
- sicherer Startpunkt
- erster Logistikhub
- Ausgangspunkt für Luftoperationen
- Ausgangspunkt für spätere See-/Luftbrücke
- Spielerstartpunkt
- kein initiales rotes Missionsziel

Akrotiri wird als Strategic Airfield klassifiziert.

---

## 15. Red Strategic Candidates

Aktuell bestätigt:

    redStrategicCandidates: 18

Diese Objekte bilden die erste strategische Grundlage für rote Festlandziele.

Mögliche Rollen:

- rote Hauptbasen
- rote Missionsziele
- spätere Capture-Ziele
- Logistikzentren
- AI-Ausgangspunkte
- IADS-nahe strategische Knoten

Aktuelle Einschränkung:

    Es existiert noch keine produktive rote Frontlinie.
    Es existieren noch keine echten roten MOOSE-Spawns.
    Es existiert noch keine produktive rote AI-Director-Logik.
    Die roten Kandidaten sind aktuell State-Grundlage.

---

## 16. Capture Candidates

Aktuell bestätigt:

    captureCandidates: 32

Capture Candidates sind Airbase-Objekte, die grundsätzlich als strategische oder sekundäre Capture-Ziele geeignet sind.

Aktuell capture-fähig:

- Strategic Airfields
- Secondary Airfields
- später eventuell explizit freigegebene Mission-Editor-Zonen

Nicht automatisch capture-fähig:

- einfache Helipads
- Medical Pads
- Tactical Pads
- Unknown Objects
- rein technische Sonderobjekte

Diese Entscheidung ist zentral.

Ohne diese Filterung würde die Kampagne 225 potenzielle Capture-Objekte erzeugen, was fachlich falsch wäre.

---

## 17. Mission Candidates

Aktuell bestätigt:

    missionCandidates: 32

Mission Candidates sind Airbase-Objekte, die grundsätzlich als Missionsziele geeignet sind.

Mögliche Missionstypen gegen Airbase-Ziele:

- Recon
- Strike
- SEAD
- DEAD
- Airbase Attack
- Interdiction
- CAP im Umfeld
- Logistics Support
- später IADS Suppression

Nicht jedes Mission Candidate wird automatisch in jeder Mission genutzt.

Der MissionGenerator priorisiert und filtert später nach Kampagnenlage.

---

## 18. Logistics Candidates

Aktuell bestätigt:

    logisticsCandidates: 46

Logistics Candidates bilden die Grundlage für LogisticsDelivery.

Sie umfassen mehr Objekte als die reinen Capture Candidates.

Grund:

    Logistik kann auch an nicht vollständig capture-fähigen Orten relevant sein.

Mögliche Rollen:

- Supply Hub
- Fuel Hub
- Ammo Hub
- Engineering Hub
- FOB-Kandidat
- Supportpunkt
- Transportziel

LogisticsDelivery erzeugt daraus aktuell:

    46 Logistics Hubs

---

## 19. Verhältnis Airbase Scanner zu ZoneFactory

Der Airbase Scanner erzeugt klassifizierte Airbase-Daten.

ZoneFactory erzeugt daraus Kampagnenzonen.

Aktuelle ZoneFactory-Werte:

    total zones: 46
    classified airbase zones: 46
    Mission Editor zones: 0
    skipped airbase-like objects: 179
    strategic zones: 19
    secondary zones: 13
    heliport zones: 1
    farp zones: 0
    tactical zones: 13
    captureZones: 32
    missionZones: 32
    logisticsZones: 46
    startBaseZones: 1

Wichtig:

    Der Airbase Scanner erkennt 225 Airbase-like Objects.
    ZoneFactory erzeugt daraus 46 relevante Kampagnenzonen.
    Das ist korrekt und gewollt.

Die alte Annahme, dass ZoneFactory alle 225 Objekte als Zonen registriert, ist veraltet.

---

## 20. Verhältnis Airbase Scanner zu CaptureSystem

CaptureSystem nutzt die vom Airbase Scanner und der ZoneFactory gelieferten Daten.

Aktuelle CaptureSystem-Werte:

    eligibleBases: 32
    eligibleZones: 32
    nonCaptureBases: 193
    nonCaptureZones: 14
    pressureRecords: 32
    progressRecords: 32
    appliedMissionEffects: 0
    ready: 0
    contested: 0

Bedeutung:

    CaptureSystem arbeitet nur auf geeigneten Kampagnenzielen.
    193 Airbase-like Objects werden bewusst nicht als capture-fähige Basen behandelt.
    32 Pressure-Records und 32 Progress-Records werden erzeugt.

---

## 21. Verhältnis Airbase Scanner zu LogisticsDelivery

LogisticsDelivery nutzt Airbase-/Zone-Daten für Logistics Hubs.

Aktuelle LogisticsDelivery-Werte:

    logistics hubs: 46
    blue hubs: 7
    red hubs: 24
    neutral hubs: 15
    active hubs: 31
    limited hubs: 15
    locked hubs: 0

Bedeutung:

    Alle 46 relevanten Kampagnenzonen können eine Logistikrolle erhalten.
    Logistik ist breiter als Capture.
    CTLD ist geladen, aber noch nicht produktiv verbunden.

---

## 22. Verhältnis Airbase Scanner zu FobSystem

FobSystem nutzt Logistics Hubs und Zonen, die ursprünglich aus Airbase-Daten abgeleitet wurden.

Aktuelle FobSystem-Werte:

    FOB candidates: 6
    stored candidates: 6
    auto-planned FOBs: 2
    skipped candidates: 4
    Blue FOBs: 2

Erzeugte FOBs:

    FOB Ercan
    FOB Gecitkale

Bedeutung:

    Airbase- und Logistikdaten ermöglichen erste state-only FOB-Planung.
    Es werden noch keine echten CTLD-FOBs erzeugt.

---

## 23. Verhältnis Airbase Scanner zu MissionGenerator

MissionGenerator nutzt Airbase-, Zone-, Capture-, Logistics- und FOB-Daten.

Aktuelle MissionGenerator-Werte:

    mission candidates: 69
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 30

Bedeutung:

    Der MissionGenerator erzeugt Missionen nicht mehr aus beliebigen DCS-Objekten.
    Er nutzt klassifizierte Kampagnenziele.
    FOB-Support wird berücksichtigt.
    Missionen sind über F10 sichtbar und aktivierbar.

---

## 24. Verhältnis Airbase Scanner zu AICapManager

AICapManager nutzt Airbase- und Zonendaten zur Vorbereitung von CAP-State.

Aktuelle AICapManager-Werte:

    cap zone candidates: 31
    auto-registered CAP zones: 12
    CAP requests: 12
    reactionState: AIR_REACTION_REQUESTED
    threatLevel: HIGH

Bedeutung:

    CAP-Bedarf wird aus dem Kampagnenraum abgeleitet.
    MOOSE-CAP-Spawns sind noch nicht aktiv.
    CAP ist aktuell State-only.

---

## 25. Aktuelle Datenqualität

Die aktuelle Datenqualität ist für die nächste Entwicklungsphase ausreichend.

Bestätigt:

- Akrotiri wird korrekt erkannt.
- strategische Basen werden von einfachen Pads getrennt.
- sekundäre Basen werden erkannt.
- Medical Pads werden nicht strategisch fehlinterpretiert.
- Unknown Objects werden konservativ behandelt.
- Capture Candidates sind sinnvoll reduziert.
- Mission Candidates sind sinnvoll reduziert.
- Logistics Candidates bilden eine breitere, aber kontrollierte Basis.
- ZoneFactory erzeugt 46 relevante Kampagnenzonen.
- nachfolgende Systeme nutzen diese Daten erfolgreich.

Offen:

- einzelne Syria-Namen später manuell prüfen
- Unknown Objects später optional analysieren
- Debug-Report für Airbase-Klassen ergänzen
- Airbase-Liste optional als Log-/Debug-Tabelle ausgeben
- Persistenz der Klassifikation vorbereiten
- manuelle Override-Liste für Sonderfälle vorbereiten

---

## 26. Konservative Klassifikation

Theater Command nutzt eine konservative Klassifikation.

Grund:

    Falsch positive strategische Ziele sind gefährlicher als vorerst ignorierte Sonderobjekte.

Ein Objekt soll nur dann strategisch wirken, wenn es dafür geeignet ist.

Vorteile:

- weniger fehlerhafte Missionen
- weniger unsinnige Capture-Ziele
- stabilerer MissionGenerator
- klarere Logistikstruktur
- bessere spätere Persistenz
- weniger DCS-Sonderfallfehler

---

## 27. Persistenz des Airbase-Systems

Später soll der Airbase-Zustand persistent werden.

Zu speichern:

- Airbase-Key
- Name
- Kategorie
- Koalition
- Besitzstatus
- Position
- strategische Relevanz
- Capture-Fähigkeit
- Mission-Fähigkeit
- Logistics-Fähigkeit
- verknüpfte Zone
- Capture-Progress
- eventuelle Schäden
- spätere Nutzbarkeit als Startpunkt

Aktueller Stand:

    Airbase-Daten sind im State vorhanden.
    produktive Persistenz ist noch nicht aktiv.
    PersistenceSystem lädt/startet als Grundstruktur.
    DCS-Dateischreibtest steht noch aus.

---

## 28. Debug des Airbase-Systems

Aktuell erfolgt Debug über `dcs.log`.

Wichtige Suchbegriffe:

    AirbaseScanner
    Airbase scan completed
    classification
    strategic
    secondary
    captureCandidates
    missionCandidates
    logisticsCandidates
    blueStartBases
    redStrategicCandidates

Spätere Debug-Funktionen:

- Airbase Summary Report
- Airbase Detail Report
- Kategorie-Ausgabe
- Liste strategischer Basen
- Liste sekundärer Basen
- Liste ausgeschlossener Objekte
- Liste unbekannter Objekte
- F10-Debug-Anzeige
- optionaler CSV-/Text-Dump

---

## 29. Nicht-Ziele des aktuellen Airbase-Systems

Aktuell nicht vorgesehen:

- alle 225 DCS-Airbase-Objekte als Capture-Ziele behandeln
- alle 225 DCS-Airbase-Objekte als Mission-Ziele behandeln
- Medical Pads als Airbase Attack Ziele verwenden
- einfache Helipads als strategische Flugplätze verwenden
- Unknown Objects automatisch strategisch machen
- MOOSE-Spawns direkt aus dem Airbase Scanner starten
- CTLD-Logik direkt im Airbase Scanner ausführen
- IADS direkt im Airbase Scanner initialisieren

Grund:

    Der Airbase Scanner erkennt und klassifiziert.
    Fachliche Aktionen gehören in die jeweiligen Systeme.

---

## 30. Aktueller getesteter Systemstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.1` | bestanden |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.2` | bestanden |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.0` | bestanden |

---

## 31. Nächster sinnvoller Schritt aus Sicht des Airbase-Systems

Der nächste technische Schritt liegt nicht direkt im Airbase Scanner.

Empfohlene nächste Datei:

    src/ui/tc_f10_menu.lua

Ziel:

    Capture-/Pressure-Status im F10-Menü sichtbar machen.

Warum:

    Airbase Scanner, ZoneFactory und CaptureSystem liefern inzwischen stabile Daten.
    CaptureSystem erzeugt 32 Pressure-Records und 32 Progress-Records.
    Diese Daten müssen im Spiel sichtbar werden, bevor Missionseffekte und Capture-Fortschritt sinnvoll getestet werden können.

Akzeptanzkriterien:

- F10Menu lädt als neue Version.
- bisherige 26 Commands bleiben funktionsfähig.
- neue Capture-Commands werden ergänzt.
- Capture Status zeigt mindestens:
  - eligibleBases
  - eligibleZones
  - pressureRecords
  - progressRecords
  - captureReady
  - pressureContested
  - appliedMissionEffects
- keine echten Spawns
- keine CTLD-Aktion
- keine Skynet-Aktion
- keine Lua-Fehler
- keine Theater-Command-Fehler

---

## 32. Aktueller Status

Das Airbase-System ist für den aktuellen state-first Entwicklungsstand bestanden.

Wichtigster Fortschritt:

    225 DCS-Airbase-like Objects werden erkannt, aber fachlich gefiltert.
    46 relevante Kampagnenzonen werden erzeugt.
    32 Capture-/Mission-Ziele werden vorbereitet.
    46 Logistics-Ziele werden vorbereitet.

Damit ist die Airbase-Grundlage stabil genug für:

- Capture-Sichtbarkeit
- Missionseffekt-Tests
- Logistik-Ausbau
- FOB-Ausbau
- spätere AI-Director-Logik
- spätere IADS-Anbindung
- spätere Persistenz
