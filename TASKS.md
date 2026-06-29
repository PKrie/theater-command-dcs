# TASKS.md

Diese Datei ist die operative Aufgabenliste und der wichtigste Übergabepunkt für **Theater Command DCS**.

Neue Sessions sollen zuerst diese Datei lesen und danach den aktuellen GitHub-Stand prüfen, bevor Code geschrieben wird.

---

## 1. Projekt

Projektname:

- **Theater Command DCS**

Erste Kampagne:

- **Operation Levant Reclamation**

Map:

- **Syria**

Ausgangslage:

- Blue startet auf **Akrotiri / Zypern**
- Das syrische Festland ist zu Beginn rot kontrolliert
- Blue soll sich vom Brückenkopf Zypern aus auf das syrische Festland vorarbeiten
- Spieler sollen sich mit Client-Flugzeugen in eine laufende Kampagnenlage einklinken

Grundprinzip:

- **Mission Editor = Bühne**
- **Lua = Kampagnensystem**
- **GitHub = Projektgedächtnis**

Zielbild:

- Blue und Red sollen perspektivisch eigene Operationen durchführen.
- Spieler ist Teilnehmer der Kampagne, nicht alleiniger Motor.
- Kampagnenzustand soll später persistent werden.
- Missionen, Capture, Logistics, FOBs, AI, IADS, UI und Persistence sollen zusammenwirken.

---

## 2. Arbeitsweise

Es wird immer nur **eine konkrete Aufgabe oder eine Datei pro Schritt** bearbeitet.

Bei neuen oder ersetzten Dateien gilt:

- exakten Dateipfad angeben
- vollständigen Dateiinhalt liefern
- genau einen vollständigen Codeblock liefern
- passenden Commit-Text angeben
- keine halben Dateien
- keine parallelen Aufgabenlisten
- keine Framework-Dateien verändern

Der Nutzer arbeitet überwiegend über:

- GitHub-Weboberfläche
- GitHub Desktop
- DCS Mission Editor

Wichtig für DCS:

Eine per `DO SCRIPT FILE` geladene Lua-Datei wird in die `.miz` eingebettet.

Nach jeder Lua-Änderung gilt:

1. Datei auf GitHub aktualisieren
2. lokal per GitHub Desktop fetchen/pullen
3. im Mission Editor die geänderte Datei in der passenden `DO SCRIPT FILE`-Aktion neu auswählen
4. Mission speichern
5. DCS-Testlauf starten
6. frische `dcs.log` auswerten

Für saubere Logtests:

1. DCS beenden
2. `Saved Games\DCS.openbeta\Logs\dcs.log` löschen oder umbenennen
3. DCS neu starten
4. Mission testen
5. DCS beenden
6. frische `dcs.log` hochladen

---

## 3. Vendor-Regeln

Frameworks liegen unter `vendor/` und werden nicht verändert.

Aktive Vendor-Dateien:

| Framework | Pfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD-i18n | `vendor/ctld/CTLD-i18n.lua` | geladen |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Wichtig:

- Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket, weil CTLD eine kompatible MIST-Version benötigt.
- Eigene Lua-Logik gehört nach `src/`.

Nicht erwünscht:

- `tc_moose.lua`
- `tc_mist.lua`
- `tc_ctld.lua`
- `tc_all_in_one.lua`

Eigene Logik wird nach Aufgabenbereichen sortiert, nicht nach Frameworks.

---

## 4. Aktuelle Ladefolge im Mission Editor

Aktuell wird weiter die sichere Einzeldatei-Ladung verwendet.

Vendor-Ladefolge:

1. `vendor/mist/mist.lua`
2. `vendor/moose/Moose.lua`
3. `vendor/ctld/CTLD-i18n.lua`
4. `vendor/ctld/CTLD.lua`
5. `vendor/skynet-iads/SkynetIADS.lua`

Aktive Theater-Command-Ladefolge:

1. `src/core/tc_config.lua`
2. `src/core/tc_logger.lua`
3. `src/core/tc_state.lua`
4. `src/core/tc_utils.lua`
5. `src/core/tc_scheduler.lua`
6. `src/world/tc_airbase_scanner.lua`
7. `src/world/tc_zone_factory.lua`
8. `src/campaign/tc_capture_system.lua`
9. `src/campaign/tc_persistence_system.lua`
10. `src/logistics/tc_logistics_delivery.lua`
11. `src/logistics/tc_fob_system.lua`
12. `src/missions/tc_mission_generator.lua`
13. `src/ai/tc_ai_cap_manager.lua`
14. `src/ui/tc_f10_menu.lua`
15. `src/main.lua`
16. `src/loader.lua`

Wichtig:

- `src/ui/tc_f10_menu.lua` ist aktiv.
- F10Menu muss nach AI CAP Manager und vor Main geladen werden.
- `src/loader.lua` bleibt die letzte eigene Datei.
- Starttest-Variante B mit Loader-only-`dofile` ist weiterhin offen.

Aktuelle Entscheidung:

Bis Variante B praktisch geprüft ist, bleibt die sichere Einzeldatei-Ladung Standard.

---

## 5. Aktiver Source-Stand

Aktive eigene Lua-Dateien:

- `src/loader.lua`
- `src/main.lua`
- `src/core/tc_config.lua`
- `src/core/tc_logger.lua`
- `src/core/tc_state.lua`
- `src/core/tc_utils.lua`
- `src/core/tc_scheduler.lua`
- `src/world/tc_airbase_scanner.lua`
- `src/world/tc_zone_factory.lua`
- `src/campaign/tc_capture_system.lua`
- `src/campaign/tc_persistence_system.lua`
- `src/logistics/tc_logistics_delivery.lua`
- `src/logistics/tc_fob_system.lua`
- `src/missions/tc_mission_generator.lua`
- `src/ai/tc_ai_cap_manager.lua`
- `src/ui/tc_f10_menu.lua`

Aktuell nur vorbereitet oder dokumentiert:

- `src/iads/`
- `src/debug/`

---

## 6. Erfolgreich getestete Systeme

Stand: **2026-06-29**

### 6.1 Starttest Variante A

Status:

- **bestanden**

Bestätigt:

- Vendor-Frameworks laden.
- Theater-Command-Dateien laden.
- Loader erkennt Frameworks.
- Main startet.
- Runtime-Systeme initialisieren.
- Loader beendet sauber.

---

### 6.2 Airbase Scanner

Datei:

- `src/world/tc_airbase_scanner.lua`

Aktuelle getestete Version:

- `v0.2.2`

Status:

- **bestanden**

Letzte bestätigte Werte:

- total: 225
- strategic: 19
- secondary: 13
- heliports: 1
- helipads: 95
- medical: 40
- farps: 0
- tactical: 13
- unknown: 44
- captureCandidates: 32
- missionCandidates: 32
- logisticsCandidates: 46
- blueStartBases: 1
- redStrategicCandidates: 18

Bewertung:

- Akrotiri wird korrekt als Blue-Startbasis erkannt.
- Akrotiri wird als `STRATEGIC_AIRFIELD` klassifiziert.
- syrische Hauptflugplätze werden als Red Strategic Candidates vorbereitet.
- Medical Pads und einfache Helipads werden nicht als strategische Kampagnenziele behandelt.

Offen:

- optionaler Airbase-Debugreport
- Detailausgabe je Airbase-Klasse
- spätere Feinkorrektur einzelner Syria-Namen, falls nötig

---

### 6.3 Zone Factory

Datei:

- `src/world/tc_zone_factory.lua`

Aktuelle getestete Version:

- `v0.2.0`

Status:

- **bestanden**

Letzte bestätigte Werte:

- total zones: 46
- classified airbase zones: 46
- Mission Editor zones: 0
- skipped airbase-like objects: 179
- strategic zones: 19
- secondary zones: 13
- heliport zones: 1
- farp zones: 0
- tactical zones: 13
- captureZones: 32
- missionZones: 32
- logisticsZones: 46
- startBaseZones: 1

Bewertung:

- ZoneFactory erzeugt nicht mehr 225 ungefilterte Zonen, sondern 46 relevante Kampagnenzonen.
- Capture-, Mission- und Logistics-Zonen werden aus der Airbase-Klassifizierung abgeleitet.

Offen:

- Mission-Editor-Zonen später ergänzen
- `CAPTURE_`-Zonen praktisch testen
- `TC_ZONE_`-Zonen praktisch testen
- Debug-Report für Zonen ergänzen

---

### 6.4 Capture System

Datei:

- `src/campaign/tc_capture_system.lua`

Aktuelle getestete Version:

- `v0.2.1`

Status:

- **bestanden**

Letzte bestätigte Werte:

- eligibleBases: 32
- eligibleZones: 32
- nonCaptureBases: 193
- nonCaptureZones: 14
- pressureRecords: 32
- progressRecords: 32
- appliedMissionEffects: 0
- ready: 0
- contested: 0

Bewertung:

- Capture wirkt nur auf strategische und sekundäre Kampagnenziele.
- Nicht geeignete Airbase-like Objects bleiben ausgeschlossen.
- Capture-Pressure-Records werden für 32 capture-fähige Zonen erzeugt.
- Capture-Progress-Records werden für 32 capture-fähige Zonen erzeugt.
- Missionseffekte können state-only als Capture-Druck vorbereitet werden.
- Automatische produktive Capture-Folgen bleiben noch deaktiviert.

Offen:

- Capture-/Pressure-Status im F10-Menü sichtbar machen
- Missionserfolg mit `CaptureSystem.applyMissionEffect()` praktisch testen
- Capture-Ready-Zonen über UI oder Debug anzeigen
- Pressure-Contested-Zonen über UI oder Debug anzeigen
- echte Capture-Bedingungen final definieren
- Logistikzustand mit Capture-Fähigkeit koppeln
- AI-Operationen mit Capture-Fortschritt koppeln
- Capture-Zustand persistieren

---

### 6.5 Logistics Delivery

Datei:

- `src/logistics/tc_logistics_delivery.lua`

Aktuelle getestete Version:

- `v0.2.0`

Status:

- **bestanden**

Letzte bestätigte Werte:

- logistics hubs: 46
- blue hubs: 7
- red hubs: 24
- neutral hubs: 15
- active hubs: 31
- limited hubs: 15
- locked hubs: 0

Bewertung:

- Logistics Delivery nutzt klassifizierte Kampagnenzonen.
- 46 Logistics Hubs werden erzeugt.
- CTLD wird noch nicht aktiv angesprochen.
- Das ist aktuell korrekt, weil noch keine CTLD-Zonen und keine Template-Gruppen in der DEV-Mission definiert sind.

Offen:

- CTLD-Zonen im Mission Editor anlegen
- CTLD Pickup/Dropoff mit Theater Command verbinden
- Supply-Verbrauch modellieren
- Logistics mit Capture-System koppeln
- Logistics-Zustand persistieren

---

### 6.6 FOB System

Datei:

- `src/logistics/tc_fob_system.lua`

Aktuelle getestete Version:

- `v0.2.0`

Status:

- **bestanden**

Letzte bestätigte Werte:

- FOB candidates: 6
- stored candidates: 6
- auto-planned FOBs: 2
- skipped candidates: 4
- erzeugte FOBs:
  - `FOB Ercan`
  - `FOB Gecitkale`
- Status der erzeugten FOBs:
  - `UNDER_CONSTRUCTION`
- Blue FOBs: 2

Bewertung:

- FOB System nutzt die Logistics-Hub-Struktur.
- FOBs werden als State-only-Objekte angelegt.
- `planned=0` ist kein Fehler, weil automatisch geplante FOBs durch initialen Baufortschritt direkt in `UNDER_CONSTRUCTION` wechseln.

Offen:

- echte CTLD-FOB-Erstellung
- CTLD-Cargo mit FOB-Baufortschritt koppeln
- FOB-Supply-Verbrauch modellieren
- FOB-Zustand persistieren
- FOBs später als Forward Operations Bases für AI und Spieler nutzen

---

### 6.7 Mission Generator

Datei:

- `src/missions/tc_mission_generator.lua`

Aktuelle getestete Version:

- `v0.2.2`

Status:

- **bestanden**

Letzte bestätigte Werte:

- mission candidates: 69
- fobSupportCandidates: 2
- generated missions: 10
- reservedCreated: 1
- duplicatesSkipped: 1
- typeLimitSkipped: 30

Bestätigte Missionslogik:

- FOB-Support wird nicht aus der verfügbaren Missionsliste verdrängt.
- mindestens eine FOB-Support-Mission wird reserviert erzeugt.
- Mission Records enthalten Objectives.
- Mission Records enthalten Briefings.
- Mission Records enthalten Progress-Daten.
- Mission Records enthalten Activation Metadata.
- Mission Records enthalten reservierte Execution Hooks für MOOSE, CTLD und Skynet.
- Aktivierte Missionen bleiben `stateOnly=true`.
- Spawn-Hooks bleiben `reserved`.

Bestätigte F10-/MissionGenerator-Interaktion:

- Mission Details Slot 1 bestätigt
- Mission Details Slot 2 bestätigt
- Mission Details Slot 5 bestätigt
- Mission Slot 5 aktiviert
- MissionGenerator setzt Mission Slot 5 auf `ACTIVE`
- Aktivierung erzeugt `stateOnly=true`
- Aktivierung erzeugt `spawnHooks=reserved`

Bewertung:

- Mission Generator erzeugt priorisierte Missionen aus klassifizierten Kampagnenzonen und berücksichtigt FOB-Unterstützung.
- Missionen sind jetzt fachlich besser modelliert.
- Missionen bleiben weiterhin State-only und lösen keine echten DCS-Spawns aus.

Offen:

- Mission completed/failed über F10 oder Debug testbar machen
- Missionseffekte praktisch auf Capture, Logistics, AI und IADS anwenden
- automatische Missionserfolgsauswertung aus DCS-Events/Triggern entwickeln
- Briefingtexte später weiter verfeinern
- weitere Missionstypen ausbauen

---

### 6.8 AI CAP Manager

Datei:

- `src/ai/tc_ai_cap_manager.lua`

Aktuelle getestete Version:

- `v0.2.0`

Status:

- **bestanden**

Letzte bestätigte Werte:

- cap zone candidates: 31
- auto-registered CAP zones: 12
- CAP requests: 12
- reactionState: `AIR_REACTION_REQUESTED`
- threatLevel: `HIGH`

Bewertung:

- AI CAP Manager bereitet Blue- und Red-CAP-Bedarf als State vor.
- echter MOOSE-Spawn ist noch nicht aktiv.
- `spawn=MOOSE_PENDING` ist aktuell erwartetes Verhalten.

Offen:

- MOOSE CAP Templates im Mission Editor anlegen
- MOOSE SPAWN-Anbindung implementieren
- AI_A2A_DISPATCHER prüfen
- Blue und Red CAP real spawnen lassen
- CAP-Zustände durch DCS-Events aktualisieren
- CAP-Verluste und CAP-Erfolge auswerten

---

### 6.9 F10 Menu

Datei:

- `src/ui/tc_f10_menu.lua`

Aktuelle getestete Version:

- `v0.2.0`

Status:

- **bestanden**

Bestätigt:

- F10-Menü ist in der Mission sichtbar.
- F10-Menü ist navigierbar.
- Log bestätigt Start und Initialisierung.
- 26 Commands wurden erzeugt.
- Mission 1 bis Mission 10 sind direkt auswählbar.
- Mission 1 bis Mission 10 sind direkt aktivierbar.
- Missionsdetails sind pro Slot abrufbar.
- Mission Details Slot 1 wurden bestätigt.
- Mission Details Slot 2 wurden bestätigt.
- Mission Details Slot 5 wurden bestätigt.
- Mission Slot 1 wurde aktiviert.
- Mission Slot 5 wurde aktiviert.
- MissionGenerator setzt aktivierte Missionen auf `ACTIVE`.

Bestätigte Logmarker:

- `[TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.0`
- `[TC] [F10Menu] F10 menu started`
- `[TC] [F10Menu] F10 menu initialized: commands=26`
- `[TC] System started: F10 Menu`
- `[TC] [F10Menu] Mission details shown through F10: slot=1 key=MISSION_1`
- `[TC] [F10Menu] Mission activated through F10: slot=1 key=MISSION_1`
- `[TC] [F10Menu] Mission activated through F10: slot=5 key=MISSION_4`

Aktuelle F10-Funktionen:

- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Mission 1 bis Mission 10 Details anzeigen
- Mission 1 bis Mission 10 aktivieren
- Kampagnenstatus anzeigen
- Logistikstatus anzeigen
- FOB-Status anzeigen
- AI-CAP-Status anzeigen

Bewertung:

- Die erste Spieleroberfläche existiert und ist funktionsfähig.
- Die direkte Missionsauswahl funktioniert.
- Die direkte Missionsaktivierung funktioniert.
- Das Menü bleibt State-only.
- Es werden keine echten MOOSE-, CTLD- oder Skynet-Aktionen ausgelöst.

Offen:

- Capture-/Pressure-Status über F10 anzeigen
- Capture Ready Zones über F10 anzeigen
- Pressure Contested Zones über F10 anzeigen
- aktive Mission abbrechen
- Mission completed/failed manuell über F10 oder Debug vorbereiten
- Debug-Menü getrennt aufbauen
- spätere Statusseiten verbessern

---

### 6.10 Persistence System

Datei:

- `src/campaign/tc_persistence_system.lua`

Aktueller Status:

- Modul lädt und startet.
- Grundstruktur vorhanden.
- DCS-Dateischreibzugriff noch nicht praktisch geprüft.

Offen:

- Speicherformat final definieren
- Save-Dateipfad definieren
- DCS-Sandbox-Schreibzugriff testen
- Save/Load praktisch testen
- Airbase-/Zone-/Capture-/Logistics-/FOB-/Mission-/AI-/UI-Zustand speichern
- Kampagnenzustand beim Neustart wiederherstellen

---

## 7. Noch nicht aktive oder noch nicht produktiv integrierte Bereiche

### 7.1 IADS

Status:

- Skynet IADS wird als Vendor geladen.
- eigenes Theater-Command-IADS-Modul ist noch nicht implementiert.

Offen:

- `src/iads/` strukturieren
- eigenes IADS-Modul erstellen
- Skynet-IADS-Sites erfassen
- IADS mit Kampagnenzonen verbinden
- IADS-Status in Mission Generator einbinden
- IADS-Status in AI Director einbinden
- IADS-Status persistieren

---

### 7.2 Debug

Status:

- Logging ist vorhanden.
- eigenes Debug-System ist noch nicht aktiv implementiert.

Offen:

- `src/debug/` strukturieren
- Debug-Reports erstellen:
  - Airbases
  - Zones
  - Capture
  - Logistics
  - FOBs
  - Missions
  - AI
  - UI
  - IADS
- optionales Debug-F10-Menü
- Log-Level-Steuerung verbessern

---

### 7.3 AI Director

Status:

- noch nicht implementiert
- AI CAP Manager ist nur ein Teilmodul

Ziel:

Ein späterer AI Director soll beide Koalitionen auf Basis der Kampagnenlage handeln lassen.

Wichtig:

- Das Projekt ist nicht als „Rot reagiert auf Spieler“-Mission gedacht.

Zielverhalten:

- Blue plant defensive und offensive Operationen.
- Red plant defensive und offensive Operationen.
- beide Seiten reagieren auf Zonenbesitz, Missionslage, Logistik, IADS und Verluste.
- Spieler können sich in diese laufende Kampagne einklinken.
- Spieler sollen nicht der einzige Auslöser der Kampagne sein.

Offen:

- `src/ai/tc_ai_director.lua` erstellen
- Blue-Operationen planen
- Red-Operationen planen
- AI-Entscheidungen aus Kampagnenlage ableiten
- Mission Generator, CAP Manager, Capture, Logistics, FOBs und IADS verbinden
- State-only Director zuerst
- echte Spawn-/Tasking-Integration später

---

## 8. Aktuelle Prioritäten nach dieser Session

### Priorität 1: Capture-/Pressure-Status im F10-Menü sichtbar machen

Nächste wahrscheinliche Code-Datei:

- `src/ui/tc_f10_menu.lua`

Ziel:

- Capture-Status anzeigen
- Capture Ready Zones anzeigen
- Pressure Contested Zones anzeigen
- Capture Pressure Records anzeigen
- Capture Progress Records anzeigen
- weiterhin State-only bleiben
- keine echten DCS-Spawns auslösen
- keine echten CTLD-Aktionen auslösen
- keine echten Skynet-Aktionen auslösen

Begründung:

- CaptureSystem `v0.2.1` erzeugt jetzt 32 Pressure-Records und 32 Progress-Records.
- Diese Daten sind im State vorhanden, aber im Spiel noch nicht bequem sichtbar.
- F10Menu ist bereits stabil und eignet sich für den nächsten kleinen UI-Ausbauschritt.

---

### Priorität 2: Mission completed/failed vorbereiten

Ziel:

- aktive Missionen sinnvoll verwalten
- Missionen manuell abschließen oder fehlschlagen lassen
- erste manuelle Debug-/F10-Funktion für Mission completed/failed vorbereiten
- `MissionGenerator.completeMission()` praktisch testen
- `CaptureSystem.applyMissionEffect()` gezielt testen
- später DCS-Events und Trigger koppeln

Abhängigkeit:

- F10-Auswahl stabil
- Mission Generator State stabil
- Capture Pressure State stabil

---

### Priorität 3: Persistence praktisch testen

Ziel:

- DCS-Sandbox-Dateizugriff prüfen
- Save/Load praktisch bewerten
- keine produktive Persistenz bauen, bevor der Sandbox-Test klar ist

Abhängigkeit:

- State-Struktur ist jetzt ausreichend stabil für ersten Test
- vorher ggf. Debug-/State-Dump vorbereiten

---

### Priorität 4: CTLD-Integration vorbereiten

Ziel:

- CTLD-Pickup-Zonen im Mission Editor anlegen
- Dropoff-/FOB-Zonen definieren
- CTLD-Cargo später mit Logistics Delivery und FobSystem koppeln

Noch nicht sofort:

- echte CTLD-FOBs ohne saubere Mission-Editor-Zonen
- komplexe Cargo-Wirtschaft

---

### Priorität 5: AI Director vorbereiten

Ziel:

- beidseitige Kampagnenlogik
- Blue und Red handeln unabhängig vom Spieler
- Spieler bleibt Teilnehmer, nicht alleiniger Motor

Abhängigkeit:

- Missionen, Capture, Logistics, FOB und CAP-State sind jetzt als Grundlage vorhanden
- IADS ist noch offen

---

### Priorität 6: echte Framework-Ausführung

Später:

- MOOSE für CAP, Strike, SEAD und AI-Flüge
- CTLD für Cargo, FOB und Logistik
- Skynet IADS für Luftverteidigung
- MIST dort nutzen, wo es sinnvoll ist

Noch nicht sofort:

- echte MOOSE-Spawns ohne Templates
- echte CTLD-Integration ohne Mission-Editor-Zonen
- IADS-Kampagnenlogik ohne eigene IADS-Struktur

---

## 9. Dokumentationsstand

Am Ende dieser Session werden zentrale Dokumentationsdateien auf den aktuellen Teststand gebracht:

- `CHANGELOG.md`
- `TASKS.md`
- `README.md`
- `ROADMAP.md`
- `ARCHITECTURE.md`

Wichtig für zukünftige Arbeit:

Während aktiver Code-Arbeit soll nur die absolut notwendige Dokumentation aktualisiert werden, damit GitHub als zuverlässige Referenzebene funktioniert.

Eine größere Dokumentationsrunde soll bevorzugt am Ende einer Session erfolgen.

Noch später nachzuziehen:

- relevante Systemdokumente in `docs/`
- `src/ui/README.md`
- `src/campaign/README.md`
- `src/missions/README.md`
- `src/logistics/README.md`
- `src/README.md`

Diese vollständige Dokumentationsrunde muss nicht zwischen jedem Code-Schritt erfolgen.

---

## 10. Erwartete Logmarker für den aktuellen Stand

Bei einem vollständigen aktuellen Testlauf sollten unter anderem diese Marker erscheinen:

- `[TC] [AirbaseScanner] Loaded src/world/tc_airbase_scanner.lua v0.2.2`
- `[TC] [ZoneFactory] Loaded src/world/tc_zone_factory.lua v0.2.0`
- `[TC] [CaptureSystem] Loaded src/campaign/tc_capture_system.lua v0.2.1`
- `[TC] [CaptureSystem] Capture progress updated: zones=32, ready=0, contested=0`
- `[TC] [CaptureSystem] Capture pressure summary: pressureRecords=32, progressRecords=32, appliedMissionEffects=0`
- `[TC] [LogisticsDelivery] Loaded src/logistics/tc_logistics_delivery.lua v0.2.0`
- `[TC] [FobSystem] Loaded src/logistics/tc_fob_system.lua v0.2.0`
- `[TC] [MissionGenerator] Loaded src/missions/tc_mission_generator.lua v0.2.2`
- `[TC] [MissionGenerator] Mission candidate summary: candidates=69, fobSupportCandidates=2, availableBefore=0, generationSlots=10`
- `[TC] [MissionGenerator] Mission generation completed: 10 new missions from 69 candidates (fobSupportCandidates=2, reservedCreated=1, duplicatesSkipped=1, typeLimitSkipped=30)`
- `[TC] [MissionGenerator] Mission activation prepared: MISSION_4 stateOnly=true spawnHooks=reserved`
- `[TC] [AICapManager] Loaded src/ai/tc_ai_cap_manager.lua v0.2.0`
- `[TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.0`
- `[TC] [F10Menu] F10 menu initialized: commands=26`
- `[TC] [F10Menu] Mission details shown through F10: slot=1 key=MISSION_1`
- `[TC] [F10Menu] Mission activated through F10: slot=1 key=MISSION_1`
- `[TC] System started: F10 Menu`
- `[TC] Runtime systems initialized`
- `[TC] Main initialized`
- `[TC] Main started`
- `[TC] Theater Command loader finished`

Bei Logauswertungen beachten:

- DCS-/Rendering-/Terrain-Fehler sind nicht automatisch Theater-Command-Fehler.
- Entscheidend sind `[TC]` und `[TC][ERROR]`.
- Alte Logs vorher löschen oder umbenennen, damit keine veralteten Testläufe bewertet werden.

---

## 11. Nächster konkreter Schritt für die nächste Session

Empfohlene nächste Datei:

- `src/ui/tc_f10_menu.lua`

Empfohlenes Ziel:

- Capture-/Pressure-Status im F10-Menü sichtbar machen
- `Show Capture Status`
- `Show Capture Ready Zones`
- `Show Pressure Contested Zones`
- Capture-Pressure und Capture-Progress lesbar anzeigen
- weiter State-only bleiben
- keine echten DCS-Spawns auslösen

Danach mögliche Folgeschritte:

1. Mission completed/failed über F10 oder Debug vorbereiten
2. Missionseffekte auf Capture-State anwenden
3. Persistence-Sandbox-Test vorbereiten
4. CTLD-Zonen im Mission Editor vorbereiten
5. AI Director state-only beginnen

---

## 12. Aktueller Abschlussstand dieser Session

Bestandene Systeme:

| System | Version | Status |
|---|---:|---|
| Airbase Scanner | `v0.2.2` | bestanden |
| ZoneFactory | `v0.2.0` | bestanden |
| CaptureSystem | `v0.2.1` | bestanden |
| LogisticsDelivery | `v0.2.0` | bestanden |
| FobSystem | `v0.2.0` | bestanden |
| MissionGenerator | `v0.2.2` | bestanden |
| AICapManager | `v0.2.0` | bestanden |
| F10Menu | `v0.2.0` | bestanden |

Aktuelle bestätigte Fähigkeit:

- DCS lädt Vendor-Frameworks.
- Theater Command startet.
- Airbases werden klassifiziert.
- 225 Syria airbase-like objects werden verarbeitet.
- 46 relevante Kampagnenzonen werden erzeugt.
- 32 Capture-Ziele werden erkannt.
- 46 Logistics Hubs werden erzeugt.
- 6 FOB-Kandidaten werden erzeugt.
- 2 Blue-FOBs werden geplant:
  - `FOB Ercan`
  - `FOB Gecitkale`
- Mission Generator erzeugt 10 Missionen inklusive FOB-Support.
- Missionen enthalten Objectives, Briefings, Progress und Activation Metadata.
- F10-Menü ist sichtbar, navigierbar und logbestätigt.
- F10-Menü erzeugt 26 Commands.
- Mission 1 bis Mission 10 sind direkt über F10 auswählbar.
- Missionen können über F10 aktiviert werden.
- CaptureSystem erzeugt 32 Pressure-Records.
- CaptureSystem erzeugt 32 Progress-Records.
- AI CAP Manager erzeugt Blue-/Red-CAP-State.
- Main und Loader beenden sauber.

Noch nicht implementiert:

- echte MOOSE-Spawns
- echte CTLD-Integration
- echte CTLD-FOBs
- echte Skynet-IADS-Kampagnenbrücke
- echte Persistenz
- AI Director
- echte Missionserfolgsauswertung
- automatische Capture-Auswertung aus Missionsergebnissen
- Capture-/Pressure-Status im F10-Menü
