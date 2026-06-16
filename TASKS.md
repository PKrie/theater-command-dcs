# TASKS.md

Diese Datei ist die operative Aufgabenliste für **Theater Command DCS**.

Sie dient nicht nur als To-do-Liste, sondern auch als Übergabepunkt für spätere Sessions.  
Neue Sessions sollen diese Datei zusammen mit `README.md`, `ROADMAP.md`, `ARCHITECTURE.md`, `CHANGELOG.md` und den relevanten Dateien in `docs/` lesen, bevor weitere Aufgaben begonnen werden.

---

## 1. Projektziel

**Theater Command DCS** ist ein modulares, dynamisches und später persistentes DCS-World-Kampagnensystem.

Erste Kampagne:

- Name: **Operation Levant Reclamation**
- Karte: **Syria**
- Startlage:
  - Blue startet auf **Akrotiri / Zypern**
  - Das syrische Festland ist zu Beginn rot kontrolliert
  - Blue muss sich vom Brückenkopf Zypern aus auf das Festland vorarbeiten

Grundprinzip:

- **Mission Editor = Bühne**
- **Lua = Kampagnensystem**
- **GitHub = Projektgedächtnis**

Der Spieler soll später nicht der alleinige Motor der Kampagne sein.  
Ziel ist eine laufende Blue-vs-Red-Kampagnenlogik, in die sich Spieler mit Client-Flugzeugen einklinken können.

Das bedeutet:

- Blue-KI soll eigene Operationen durchführen können
- Red-KI soll eigene Operationen durchführen können
- Spieler können Missionen übernehmen und den Kampagnenverlauf beeinflussen
- die Kampagne soll perspektivisch auch ohne aktive Spielerentscheidung weiterlaufen
- Missionen, Capture, Logistik, AI, IADS und Persistenz sollen zusammenwirken

---

## 2. Arbeitsweise

Es wird immer nur **eine konkrete Aufgabe oder eine Datei pro Schritt** bearbeitet.

Bei neuen oder ersetzten Dateien gilt:

- exakter Dateipfad angeben
- vollständigen Dateiinhalt liefern
- genau einen vollständigen Codeblock liefern
- passenden Commit-Text angeben
- keine halben Dateien
- keine parallelen Aufgabenlisten mit vielen gleichzeitigen Arbeitsschritten

Der Nutzer arbeitet überwiegend über:

- GitHub-Weboberfläche
- GitHub Desktop / lokale Repository-Kopie
- DCS Mission Editor

Wichtig für DCS:

Eine per `DO SCRIPT FILE` geladene Lua-Datei wird in die `.miz` eingebettet.  
Nach einer GitHub-Änderung reicht ein Pull allein nicht aus. Die geänderte Datei muss im Mission Editor erneut in der passenden `DO SCRIPT FILE`-Aktion ausgewählt und die Mission gespeichert werden.

---

## 3. Vendor-Regeln

Frameworks gehören nach `vendor/` und werden nicht verändert.

Aktive Vendor-Frameworks:

| Framework | Pfad | Status |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | geladen |
| MOOSE | `vendor/moose/Moose.lua` | geladen |
| CTLD-i18n | `vendor/ctld/CTLD-i18n.lua` | geladen |
| CTLD | `vendor/ctld/CTLD.lua` | geladen |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | geladen |

Aktuell bestätigt:

- MIST Version `4.5.128-DYNSLOTS-02`
- MOOSE Version `2.9.17`
- CTLD Version `1.6.1`
- Skynet IADS Version `3.3.0`

Wichtig:

Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket, weil CTLD eine kompatible MIST-Version benötigt.

Eigene Lua-Dateien gehören unter `src/`.

Nicht erwünscht:

- `tc_moose.lua`
- `tc_mist.lua`
- `tc_ctld.lua`
- `tc_all_in_one.lua`

Eigene Logik wird nach Aufgabenbereichen sortiert, nicht nach Frameworks.

---

## 4. Aktuelle Lade- und Startstruktur

### 4.1 Vendor-Ladefolge im Mission Editor

Aktuelle Ladefolge im DCS Mission Editor:

1. `vendor/mist/mist.lua`
2. `vendor/moose/Moose.lua`
3. `vendor/ctld/CTLD-i18n.lua`
4. `vendor/ctld/CTLD.lua`
5. `vendor/skynet-iads/SkynetIADS.lua`

### 4.2 Theater-Command-Ladefolge

Aktuell wird noch die sichere Einzeldatei-Ladung verwendet.

Aktive eigene Dateien:

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
- `src/main.lua`
- `src/loader.lua`

`src/loader.lua` wird zuletzt geladen.

### 4.3 Noch nicht erledigt

Noch nicht getestet:

- Loader-only-Ladung über `dofile`
- DCS-Sandbox-Verhalten für direkte Dateipfade
- Starttest-Variante B

Aktuelle Entscheidung:

Bis Variante B praktisch geprüft ist, bleibt die sichere Einzeldatei-Ladung Standard.

---

## 5. Erfolgreich getestete Kernbefunde

### 5.1 Starttest Variante A

Status: **bestanden**

Bestätigt:

- Vendor-Frameworks werden geladen
- eigene Lua-Dateien werden geladen
- Loader erkennt Frameworks
- Main startet
- Runtime-Systeme werden initialisiert
- Loader beendet sauber

Wichtiger Erstbefund:

Die Syria Map liefert über `world.getAirbases()` sehr viele airbase-ähnliche Objekte.

Bestätigter Wert:

- 225 airbase-like objects

Diese 225 Objekte sind kein Fehler.  
Sie enthalten aber viele Objekttypen, die nicht als strategische Kampagnenbasen behandelt werden dürfen.

---

## 6. Aktueller Modulstand

### 6.1 Airbase Scanner

Datei:

- `src/world/tc_airbase_scanner.lua`

Aktuelle getestete Version:

- `v0.2.2`

Status:

- **bestanden**

Aufgabe des Moduls:

- alle DCS-Airbase-ähnlichen Objekte scannen
- Objekte klassifizieren
- Akrotiri als Blue-Startbasis erkennen
- syrische Hauptflugplätze als potenzielle Red-Ziele vorbereiten
- Helipads, Medical Pads, Tactical Pads und Unknowns trennen

Letzter bestätigter Testwert:

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

- Akrotiri wird korrekt als `STRATEGIC_AIRFIELD` erkannt
- Akrotiri erhält `strategicRelevance=100`
- syrische Hauptflugplätze werden sinnvoll als Red Strategic Candidates vorbereitet
- Medical Pads und einfache Helipads werden nicht mehr als strategische Kampagnenziele behandelt

Offen:

- Debug-Detailausgabe für einzelne Airbase-Klassen
- optionaler Airbase-Report
- spätere Feinkorrektur einzelner Syria-Namen, falls notwendig

---

### 6.2 Zone Factory

Datei:

- `src/world/tc_zone_factory.lua`

Aktuelle getestete Version:

- `v0.2.0`

Status:

- **bestanden**

Aufgabe des Moduls:

- aus klassifizierten Airbase-Daten Kampagnenzonen erzeugen
- nicht alle 225 Rohobjekte als Zonen verwenden
- Capture-, Mission- und Logistics-Zonen trennen
- Mission-Editor-Zonen optional über MIST einlesen

Letzter bestätigter Testwert:

- total zones: 46
- classified airbase zones: 46
- Mission Editor zones: 0
- skipped airbase-like objects: 179
- strategic zones: 19
- secondary zones: 13
- heliport zones: 1
- tactical zones: 13
- captureZones: 32
- missionZones: 32
- logisticsZones: 46
- startBaseZones: 1

Bewertung:

Die Zone Factory arbeitet jetzt auf der Airbase-Klassifizierung und nicht mehr auf ungefilterten DCS-Rohobjekten.

Offen:

- Mission-Editor-Zonen später ergänzen
- `CAPTURE_`-Zonen später praktisch testen
- `TC_ZONE_`-Zonen später praktisch testen
- Debug-Report für Zonen ergänzen

---

### 6.3 Capture System

Datei:

- `src/campaign/tc_capture_system.lua`

Aktuelle getestete Version:

- `v0.2.0`

Status:

- **bestanden**

Aufgabe des Moduls:

- Ownership für Basen und Zonen verwalten
- Capture nur für strategische und sekundäre Kampagnenziele zulassen
- Helipads, Medical Pads, Tactical Pads und Unknowns von Capture ausschließen
- verknüpfte Airbase-/Zone-Ownership synchronisieren
- Capture Events für Persistence und spätere AI-Reaktionen vorbereiten

Letzter bestätigter Testwert:

- eligibleBases: 32
- eligibleZones: 32
- nonCaptureBases: 193
- nonCaptureZones: 14

Bewertung:

Capture wirkt nicht mehr auf 225 Rohobjekte, sondern nur noch auf sinnvolle strategische Kampagnenziele.

Offen:

- echte Capture-Bedingungen definieren
- Capture-Fortschritt modellieren
- Missionserfolg mit Capture-Druck koppeln
- Logistikzustand mit Capture-Fähigkeit koppeln
- AI-Operationen mit Capture-Fortschritt koppeln
- Capture-Zustand praktisch persistieren

---

### 6.4 Logistics Delivery

Datei:

- `src/logistics/tc_logistics_delivery.lua`

Aktuelle getestete Version:

- `v0.2.0`

Status:

- **bestanden**

Aufgabe des Moduls:

- Logistics Hubs aus klassifizierten Kampagnenzonen erzeugen
- Akrotiri als Blue Main Operating Base vorbereiten
- Red Strategic Airbase Hubs vorbereiten
- neutrale und limitierte Hubs vorbereiten
- state-only Deliveries verwalten
- spätere CTLD-Integration vorbereiten

Letzter bestätigter Testwert:

- logistics hubs: 46
- blue: 7
- red: 24
- neutral: 15
- active: 31
- limited: 15
- locked: 0

Bewertung:

Das Logistiksystem nutzt die gefilterten Kampagnenzonen.  
CTLD wird noch nicht aktiv angesprochen. Das ist aktuell korrekt, weil noch keine CTLD-Zonen und keine Template-Gruppen in der DEV-Mission definiert sind.

Offen:

- CTLD-Zonen im Mission Editor anlegen
- CTLD Pickup/Dropoff mit Theater Command verbinden
- Supply-Verbrauch modellieren
- Logistics mit Mission Generator koppeln
- Logistics mit Capture-System koppeln
- Logistics mit FOB-System koppeln
- Logistics-Zustand persistieren

---

### 6.5 FOB System

Datei:

- `src/logistics/tc_fob_system.lua`

Aktueller Status:

- Modul lädt und startet
- noch nicht an die neue Logistics-Hub-Struktur angepasst
- noch nicht tief getestet

Aufgabe des Moduls:

- FOBs planen, bauen und verwalten
- FOB-Zustand mit Logistik verbinden
- spätere CTLD-Lieferungen und FOB-Aufbau unterstützen
- Forward Operations für Blue ermöglichen

Nächste wahrscheinliche Code-Aufgabe:

- `tc_fob_system.lua` an `tc_logistics_delivery.lua v0.2.0` anbinden

Offen:

- FOBs aus geeigneten Blue-/Contested-Zonen ableiten
- FOB-Kandidaten erzeugen
- FOB-Bauzustand modellieren
- FOB-Supply und Engineering mit Logistics Delivery koppeln
- FOB-Support-Missionen mit Mission Generator verbinden
- FOBs später über CTLD aufbauen
- FOB-Zustand persistieren

---

### 6.6 Mission Generator

Datei:

- `src/missions/tc_mission_generator.lua`

Aktuelle getestete Version:

- `v0.2.0`

Status:

- **bestanden**

Aufgabe des Moduls:

- Missionen aus klassifizierten Kampagnenzonen ableiten
- Missionen priorisieren
- Medical Pads, einfache Helipads und Unknowns nicht als Strike-Ziele verwenden
- Missionen für Spieler und spätere KI-Logik vorbereiten
- Missionseffekte für spätere Capture-/Logistics-/AI-Kopplung vorbereiten

Letzter bestätigter Testwert:

- mission candidates: 74
- generated missions: 10
- erzeugte Missionstypen im Test:
  - `AIRBASE_ATTACK`
  - `SEAD`
  - `STRIKE`
  - `CAP`

Bewertung:

Missionen werden nicht mehr generisch aus Rohobjekten erzeugt, sondern aus strategisch relevanten Kampagnenzonen.

Offen:

- F10-Missionsauswahl
- Missionsaktivierung durch Spieler
- Missionsabschluss durch Trigger/Event
- Missionseffekte auf Capture anwenden
- Missionseffekte auf Logistics anwenden
- Missionseffekte auf AI/IADS anwenden
- bessere Briefingtexte
- weitere Missionstypen ausbauen:
  - `RECON`
  - `DEAD`
  - `CAS`
  - `INTERDICTION`
  - `LOGISTICS`
  - `FOB_SUPPORT`

---

### 6.7 AI CAP Manager

Datei:

- `src/ai/tc_ai_cap_manager.lua`

Aktuelle getestete Version:

- `v0.2.0`

Status:

- **bestanden**

Aufgabe des Moduls:

- CAP-Zonen aus klassifizierten Kampagnenzonen ableiten
- Blue- und Red-CAP-Bedarf vorbereiten
- State-only CAP Requests erzeugen
- später MOOSE-CAP-Spawns vorbereiten

Letzter bestätigter Testwert:

- cap zone candidates: 31
- auto-registered CAP zones: 12
- CAP requests: 12
- reactionState: `AIR_REACTION_REQUESTED`
- threatLevel: `HIGH`

Im Test sichtbar:

- Blue CAP für Akrotiri
- Red CAP für strategische syrische Flugplätze

Bewertung:

Der AI CAP Manager bereitet Blue- und Red-CAP-State vor.  
Er spawnt noch keine echten Flugzeuge. `spawn=MOOSE_PENDING` ist aktuell erwartetes Verhalten.

Offen:

- MOOSE CAP Templates im Mission Editor anlegen
- MOOSE SPAWN-Anbindung implementieren
- AI_A2A_DISPATCHER prüfen
- Blue und Red CAP real spawnen lassen
- CAP-Zustände durch DCS-Events aktualisieren
- CAP-Verluste und CAP-Erfolge auswerten

---

### 6.8 Persistence System

Datei:

- `src/campaign/tc_persistence_system.lua`

Aktueller Status:

- Modul lädt und startet
- Grundstruktur vorhanden
- DCS-Dateischreibzugriff noch nicht praktisch geprüft

Offen:

- Speicherformat final definieren
- Save-Dateipfad definieren
- DCS-Sandbox-Schreibzugriff testen
- Save/Load praktisch testen
- Airbase-/Zone-/Capture-/Logistics-/Mission-/AI-Zustand speichern
- Kampagnenzustand beim Neustart wiederherstellen

---

## 7. Noch nicht aktive Systembereiche

### 7.1 IADS

Aktueller Status:

- Skynet IADS wird als Vendor geladen
- eigenes Theater-Command-IADS-Modul ist noch nicht implementiert

Offen:

- `src/iads/` strukturieren
- eigenes IADS-Modul erstellen
- Skynet-IADS-Sites erfassen
- IADS mit Kampagnenzonen verbinden
- IADS-Status in Mission Generator einbinden
- IADS-Status in AI Director einbinden
- IADS-Status persistieren

---

### 7.2 UI / F10

Aktueller Status:

- kein eigenes UI-System aktiv
- keine F10-Menüs implementiert

Offen:

- `src/ui/` strukturieren
- F10-Hauptmenü erstellen
- Missionsliste anzeigen
- Mission auswählen
- Mission aktivieren
- Kampagnenstatus anzeigen
- Debug-Menü getrennt vom Spieler-Menü vorbereiten

---

### 7.3 Debug

Aktueller Status:

- Logging vorhanden
- noch kein eigenes Debug-System

Offen:

- `src/debug/` strukturieren
- Debug-Reports erstellen:
  - Airbases
  - Zones
  - Capture
  - Logistics
  - Missions
  - AI
- optionales Debug-F10-Menü
- Log-Level-Steuerung verbessern

---

### 7.4 AI Director

Aktueller Status:

- noch nicht implementiert
- AI CAP Manager ist nur ein Teilmodul

Ziel:

Ein späterer AI Director soll beide Koalitionen auf Basis der Kampagnenlage handeln lassen.

Wichtig:

Das Projekt ist nicht als „Rot reagiert auf Spieler“-Mission gedacht.

Zielverhalten:

- Blue plant defensive und offensive Operationen
- Red plant defensive und offensive Operationen
- beide Seiten reagieren auf Zonenbesitz, Missionslage, Logistik, IADS und Verluste
- Spieler können sich in diese laufende Kampagne einklinken
- Spieler sollen nicht der einzige Auslöser der Kampagne sein

Offen:

- `src/ai/tc_ai_director.lua` erstellen
- Blue-Operationen planen
- Red-Operationen planen
- AI-Entscheidungen aus Kampagnenlage ableiten
- Mission Generator, CAP Manager, Capture, Logistics und IADS verbinden
- State-only Director zuerst
- echte Spawn-/Tasking-Integration später

---

## 8. Aktuelle Prioritäten

### Priorität 1: Dokumentation aktualisieren

Grund:

Mehrere zentrale Systeme wurden erfolgreich getestet.  
Die Dokumentation muss diesen Stand abbilden, damit spätere Sessions zuverlässig auf GitHub nachlesen und richtige Entscheidungen treffen können.

Bereits jetzt zu aktualisieren:

1. `TASKS.md`
2. `CHANGELOG.md`
3. `README.md`
4. `ROADMAP.md`
5. `ARCHITECTURE.md`

Danach Systemdokumentation:

6. `docs/04_airbase_system.md`
7. `docs/05_logistics_system.md`
8. `docs/06_mission_generator.md`
9. `docs/07_ai_director.md`
10. `docs/10_testing.md`
11. ggf. `src/README.md`

---

### Priorität 2: FOB System an Logistics anbinden

Wahrscheinliche nächste Code-Datei:

- `src/logistics/tc_fob_system.lua`

Ziel:

- FOB-System soll die neuen Logistics Hubs nutzen
- FOB-Kandidaten sollen aus geeigneten Blue-/Contested-Zonen entstehen
- FOB-Support-Missionen sollen sinnvoller werden
- FOB-Bauzustand soll später mit CTLD gekoppelt werden können

Noch nicht sofort:

- echte CTLD-Spawns
- echte FOB-Objekte im Mission Editor
- echte DCS-Gruppenplatzierung

---

### Priorität 3: F10 UI vorbereiten

Ziel:

- Spieler kann Missionen sehen
- Spieler kann Mission auswählen
- Spieler kann Kampagnenstatus abrufen
- Debug-Menü kann separat vorbereitet werden

Abhängigkeit:

- Mission Generator muss stabile Missionsdaten liefern
- State-Struktur muss stabil sein

---

### Priorität 4: Persistence praktisch testen

Ziel:

- Kampagnenstand speichern
- Kampagnenstand laden
- DCS-Sandbox real prüfen

Abhängigkeit:

- ausreichend stabiler State
- klare Save-Struktur

---

### Priorität 5: AI Director vorbereiten

Ziel:

- beidseitige Kampagnenlogik
- Blue und Red handeln unabhängig vom Spieler
- Spieler ist Teilnehmer, nicht alleiniger Motor

Abhängigkeit:

- stabile Zonen
- stabile Missionen
- stabile Capture-/Logistics-Daten
- erster CAP-State vorhanden

---

### Priorität 6: echte Framework-Integration

Später:

- MOOSE für CAP, Strike, SEAD und AI-Flüge
- CTLD für Cargo, FOB, Logistik
- Skynet IADS für Luftverteidigung
- MIST nur dort nutzen, wo es sinnvoll ist

Noch nicht sofort:

- echte MOOSE-Spawns ohne Mission-Editor-Templates
- echte CTLD-Integration ohne CTLD-Zonen
- IADS-Kampagnenlogik ohne eigene IADS-Struktur

---

## 9. Aktueller nächster Schritt

Nächste konkrete Datei:

- `CHANGELOG.md`

Ziel:

Die erfolgreich getesteten Entwicklungsschritte sauber dokumentieren:

- Starttest Variante A
- Airbase Scanner `v0.2.2`
- ZoneFactory `v0.2.0`
- CaptureSystem `v0.2.0`
- LogisticsDelivery `v0.2.0`
- MissionGenerator `v0.2.0`
- AICapManager `v0.2.0`
- DCS-Testwerte
- bekannte Einschränkungen:
  - `spawn=MOOSE_PENDING`
  - CTLD noch nicht aktiv angebunden
  - AI Director noch nicht implementiert
  - F10 UI noch nicht implementiert
  - Persistence noch nicht praktisch getestet
  - Loader-only-Variante B noch nicht getestet

Danach:

- weitere zentrale Dokumentation aktualisieren
- anschließend mit `src/logistics/tc_fob_system.lua` oder der nächsten laut Dokumentation sinnvollen Datei fortfahren

---

## 10. Nicht vergessen

Bei jedem neuen Testlauf im DCS-Log prüfen:

- lädt die richtige Dateiversion?
- startet jedes Modul?
- gibt es `[TC][ERROR]`?
- stimmen die Summaries?
- bricht Main ab?
- beendet der Loader sauber?

Wichtige erwartete Logmarker aktuell:

- `[TC] [AirbaseScanner] Loaded src/world/tc_airbase_scanner.lua v0.2.2`
- `[TC] [ZoneFactory] Zone factory completed:`
- `[TC] [CaptureSystem] Capture eligibility summary:`
- `[TC] [LogisticsDelivery] Logistics hub summary:`
- `[TC] [MissionGenerator] Mission generation completed:`
- `[TC] [AICapManager] AI CAP manager ready:`
- `[TC] Runtime systems initialized`
- `[TC] Main started`
- `[TC] Theater Command loader finished`
