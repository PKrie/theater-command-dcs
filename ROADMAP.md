# ROADMAP.md

Diese Roadmap beschreibt den geplanten Entwicklungsweg von **Theater Command DCS**.

Das Projekt ist modular aufgebaut. Jede Stufe soll einzeln testbar sein, bevor die nächste Stufe produktiv angebunden wird.

---

## 1. Zielbild

**Theater Command DCS** soll ein dynamisches und später persistentes Kampagnensystem für DCS World werden.

Erste Kampagne:

- **Operation Levant Reclamation**

Map:

- **Syria**

Ausgangslage:

- Blue startet auf **Akrotiri / Zypern**
- Das syrische Festland ist zu Beginn rot kontrolliert
- Blue soll sich vom Brückenkopf Zypern aus auf das syrische Festland vorarbeiten
- Red hält zu Beginn den Großteil der strategischen Flugplätze
- Spieler sollen sich in eine laufende Kampagne einklinken, nicht jede Aktion allein auslösen

Langfristiges Ziel:

- dynamische Blue-vs-Red-Kampagne
- Airbases und relevante Zonen als Kampagnenobjekte
- FOBs als operative Vorwärtsbasen
- CTLD-Logistik als Kampagnenressource
- MOOSE für AI-Flüge, CAP, Strike, SEAD und spätere Missionspakete
- Skynet IADS für dynamische Luftverteidigung
- F10-Menü als Spieler- und Debug-Interface
- Persistenz für Kampagnenfortschritt
- Spieler als Teilnehmer einer laufenden Kampagne
- AI Director für eigenständige Blue- und Red-Operationen

Grundprinzip:

- **Mission Editor = Bühne**
- **Lua = Kampagnensystem**
- **GitHub = Projektgedächtnis**

---

## 2. Entwicklungsphasen

Die Roadmap ist bewusst in technische Phasen gegliedert.

Jede Phase soll einen klar testbaren Zustand liefern.

---

## Phase 0: Projektgrundlage

Status:

- **abgeschlossen**

Ziele:

- Repository erstellen
- Grunddokumentation anlegen
- Projektregeln definieren
- Vendor-Struktur definieren
- Source-Struktur definieren
- Mission-Editor-Arbeitsweise definieren

Erledigt:

- `README.md`
- `TASKS.md`
- `CHANGELOG.md`
- `ROADMAP.md`
- `ARCHITECTURE.md`
- `MISSION_EDITOR_SETUP.md`
- `NAMING_CONVENTIONS.md`
- `LUA_STYLEGUIDE.md`
- `docs/`
- `mission_editor/`
- `src/`
- `vendor/`

Ergebnis:

- Projekt ist strukturiert.
- GitHub dient als Projektgedächtnis.
- Arbeitsweise ist definiert.
- Framework-Dateien werden als Vendor behandelt und nicht verändert.

---

## Phase 1: Vendor- und Runtime-Grundlage

Status:

- **weitgehend abgeschlossen**

Ziele:

- Vendor-Frameworks einbinden
- sichere Ladefolge im Mission Editor definieren
- eigene Core-Dateien anlegen
- Logger, State, Config, Utils und Scheduler bereitstellen
- Main und Loader bereitstellen
- DCS-Logauswertung etablieren

Aktive Vendor-Dateien:

| Framework | Pfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD-i18n | `vendor/ctld/CTLD-i18n.lua` | geladen |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Aktive Core-Dateien:

- `src/core/tc_config.lua`
- `src/core/tc_logger.lua`
- `src/core/tc_state.lua`
- `src/core/tc_utils.lua`
- `src/core/tc_scheduler.lua`
- `src/main.lua`
- `src/loader.lua`

Erledigt:

- Frameworks laden.
- Core-Dateien laden.
- Main initialisiert Runtime-Systeme.
- Loader prüft Framework-Verfügbarkeit.
- Loader startet Main.
- Theater Command startet ohne Lua-Abbruch.
- sichere Einzeldatei-Ladung über `DO SCRIPT FILE` ist etabliert.

Offen:

- Loader-only-Ladung per `dofile` praktisch testen
- Fehlerisolierung im Loader weiter verbessern
- optionaler Debug-Startreport

Bewertung:

- Phase 1 ist für die aktuelle Einzeldatei-Ladung ausreichend stabil.
- Variante B mit Loader-only bleibt späterer Komfortschritt.

---

## Phase 2: World Layer

Status:

- **abgeschlossen für aktuellen State-first-Stand**

Ziele:

- Syria-Airbase-Objekte erfassen
- Airbase-like Objects klassifizieren
- relevante Kampagnenziele identifizieren
- Airbases, Helipads, Medical Pads, Tactical Pads und unbekannte Objekte trennen
- Kampagnenzonen aus relevanten Airbase-Objekten erzeugen

Aktive Dateien:

- `src/world/tc_airbase_scanner.lua`
- `src/world/tc_zone_factory.lua`

---

### Phase 2.1 Airbase Scanner

Status:

- **bestanden**

Getestete Version:

- `v0.2.2`

Bestätigte Werte:

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

Ergebnis:

- Syria-Airbase-Daten werden sauber klassifiziert.
- Akrotiri wird als Blue-Startbasis erkannt.
- strategische und sekundäre Airfields werden als Kampagnenziele vorbereitet.
- Medical Pads und einfache Helipads werden nicht als strategische Ziele verwendet.

Offen:

- optionaler Airbase-Debugreport
- spätere manuelle Feinkorrektur einzelner Syria-Objekte, falls nötig

---

### Phase 2.2 Zone Factory

Status:

- **bestanden**

Getestete Version:

- `v0.2.0`

Bestätigte Werte:

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

Ergebnis:

- ZoneFactory erzeugt nur relevante Kampagnenzonen.
- 225 Airbase-like Objects werden nicht blind zu Kampagnenzonen.
- 46 relevante Zonen bilden die Grundlage für Capture, Logistics, Missions, AI und spätere IADS-Anbindung.

Offen:

- Mission-Editor-Zonen später einbinden
- manuelle Zonenpräfixe wie `CAPTURE_` und `TC_ZONE_` praktisch testen
- Zone-Debugreport ergänzen

---

## Phase 3: Campaign State und Capture

Status:

- **State-first-Grundlage bestanden**
- **Mission Effect zu Capture Pressure bestanden**

Aktive Datei:

- `src/campaign/tc_capture_system.lua`

Aktuelle getestete Version:

- `v0.2.2`

Ziele:

- Ownership für Basen und Zonen verwalten
- Capture-Eligibility definieren
- nicht geeignete Objekte ausschließen
- verknüpfte Airbase-/Zone-Ownership synchronisieren
- Capture-Events speichern
- Capture-Pressure verwalten
- Capture-Progress verwalten
- abgeschlossene Mission Effects state-only in Capture Pressure übernehmen
- Capture Ready und Pressure Contested sichtbar machen
- produktive Ownership-Wechsel bewusst getrennt vorbereiten

Bestätigte Startwerte:

- eligibleBases: 32
- eligibleZones: 32
- nonCaptureBases: 193
- nonCaptureZones: 14
- pressureRecords: 32
- progressRecords: 32

Bestätigte Werte nach Mission Completion:

- completed mission: `MISSION_2`
- target zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- capture pressure owner: `BLUE`
- applied pressure: 105
- progress: 100 %
- appliedMissionEffects: 1
- ready: 1
- contested: 0

Erledigt:

- CaptureSystem startet sauber.
- 32 capture-fähige Basen werden erkannt.
- 32 capture-fähige Zonen werden erkannt.
- 193 nicht capture-fähige Basen werden ausgeschlossen.
- 14 nicht capture-fähige Zonen werden ausgeschlossen.
- 32 Capture-Pressure-Records werden erzeugt.
- 32 Capture-Progress-Records werden erzeugt.
- Mission Completion erzeugt vorbereitete Mission Effects.
- CaptureSystem übernimmt abgeschlossene Mission Effects.
- CaptureSystem erhöht Capture Pressure der Zielzone.
- CaptureSystem aktualisiert Capture Progress.
- Capture Ready entsteht dynamisch.
- Capture Ready Zones sind über F10 sichtbar.
- automatische produktive Capture-Folgen bleiben deaktiviert.

Offen:

- kontrollierten Ownership-Wechsel aus Capture Ready vorbereiten
- Failure-Effekte definieren und testen
- Logistikzustand mit Capture-Fähigkeit koppeln
- AI-Operationen mit Capture-Fortschritt koppeln
- Capture-Zustand persistieren

Bewertung:

- Capture ist jetzt nicht mehr nur Ownership.
- Capture besitzt eine funktionierende Druck-/Fortschrittsstruktur.
- Die erste modulübergreifende Kampagnenkette ist bestätigt:
  - Mission aktivieren
  - Mission abschließen
  - Mission Effect vorbereiten
  - Capture Pressure anwenden
  - Capture Progress aktualisieren
  - Capture Ready anzeigen

---

## Phase 4: Logistics und FOBs

Status:

- **State-first-Grundlage bestanden**

Aktive Dateien:

- `src/logistics/tc_logistics_delivery.lua`
- `src/logistics/tc_fob_system.lua`

---

### Phase 4.1 Logistics Delivery

Status:

- **bestanden**

Getestete Version:

- `v0.2.0`

Bestätigte Werte:

- logistics hubs: 46
- blue hubs: 7
- red hubs: 24
- neutral hubs: 15
- active hubs: 31
- limited hubs: 15
- locked hubs: 0

Erledigt:

- Logistics Hubs werden aus ZoneFactory-Daten erzeugt.
- 46 Logistics Hubs sind im State vorhanden.
- Hub-Zustände werden vorbereitet.
- Delivery-Struktur ist state-only vorhanden.

Noch nicht erledigt:

- echte CTLD Pickup-Zonen
- echte CTLD Dropoff-Zonen
- echte Cargo-Flüge
- Cargo-Verbrauch
- Supply-Verbrauch
- Supply-Auswirkung auf Capture und Missionen
- Persistence für Logistics

---

### Phase 4.2 FOB System

Status:

- **bestanden**

Getestete Version:

- `v0.2.0`

Bestätigte Werte:

- FOB candidates: 6
- stored candidates: 6
- auto-planned FOBs: 2
- skipped candidates: 4
- Blue FOBs: 2

Erzeugte FOBs:

- `FOB Ercan`
- `FOB Gecitkale`

Status:

- `UNDER_CONSTRUCTION`

Erledigt:

- FOB-Kandidaten werden aus Logistics-Hubs abgeleitet.
- Blue-FOBs werden automatisch geplant.
- FOBs werden als State-only-Objekte erzeugt.
- FOBs werden mit Zonen, Basen und Logistics-Hubs verknüpft.
- Baufortschritt und Versorgung sind vorbereitet.
- CTLD-Hooks sind vorbereitet, aber nicht aktiv.

Noch nicht erledigt:

- echte CTLD-FOB-Erstellung
- echte CTLD-Crates
- FOB-Baufortschritt durch Cargo
- FOB-Supply-Verbrauch
- FOB-Reparatur
- FOB als Startpunkt für Missionen und AI
- FOB-Persistenz

Bewertung:

- Logistics und FOBs sind als State-Grundlage vorhanden.
- CTLD-Produktivintegration folgt später, wenn Mission-Editor-Zonen und Cargo-Templates sauber definiert sind.

---

## Phase 5: Mission Generator

Status:

- **State-first-Grundlage bestanden**
- **Mission Outcome Completion bestanden**

Aktive Datei:

- `src/missions/tc_mission_generator.lua`

Aktuelle getestete Version:

- `v0.2.3`

Ziele:

- Missionen aus Kampagnenlage erzeugen
- Missionen priorisieren
- FOB-Support berücksichtigen
- Missionspool stabil halten
- Missionen über F10 auswählbar machen
- Objectives, Briefings und Progress vorbereiten
- Activation Metadata vorbereiten
- Outcome State vorbereiten
- Effect State vorbereiten
- Spawn-Hooks für MOOSE, CTLD und Skynet reservieren
- Mission Effects für Capture, Logistics, AI und IADS vorbereiten

Bestätigte Werte:

- mission candidates: 78
- fobSupportCandidates: 2
- generated missions: 10
- reservedCreated: 1
- duplicatesSkipped: 1
- typeLimitSkipped: 68

Aktuelle Missionstypen:

- `RECON`
- `STRIKE`
- `SEAD`
- `DEAD`
- `CAS`
- `INTERDICTION`
- `ESCORT`
- `CAP`
- `LOGISTICS`
- `FOB_SUPPORT`
- `AIRBASE_ATTACK`
- `IADS_SUPPRESSION`

Erledigt:

- Mission Generator erzeugt 10 verfügbare Missionen.
- FOB Support wird nicht verdrängt.
- mindestens eine FOB-Support-Mission wird reserviert.
- Missionen enthalten Objectives.
- Missionen enthalten Briefings.
- Missionen enthalten Progress-Daten.
- Missionen enthalten Activation Metadata.
- Missionen enthalten Outcome State.
- Missionen enthalten Effect State.
- Missionen enthalten Execution Plans.
- MOOSE-/CTLD-/Skynet-Hooks sind reserviert.
- Aktivierte Missionen bleiben `stateOnly=true`.
- Spawn-Hooks bleiben `reserved`.
- Missionen können state-only auf `COMPLETED` gesetzt werden.
- Mission Effects werden state-only vorbereitet.
- vorbereitete Mission Effects können vom CaptureSystem verarbeitet werden.

Bestätigte F10-Interaktion:

- Mission Details Slot 1 funktioniert.
- Mission Slot 1 kann aktiviert werden.
- MissionGenerator setzt aktivierte Missionen auf `ACTIVE`.
- aktive Mission 1 kann über F10 auf `COMPLETED` gesetzt werden.
- MissionGenerator erzeugt `Mission effects prepared state-only`.
- MissionGenerator erzeugt `Mission outcome prepared`.

Noch nicht erledigt:

- Mission `FAILED` praktisch testen
- Mission `CANCELLED` und `EXPIRED` praktisch testbar machen
- automatische Missionserfolgsauswertung
- DCS-Event-Auswertung
- echte MOOSE-Spawns
- echte CTLD-Aktionen
- echte Skynet-IADS-Wirkung
- Missionseffekte produktiv auf Logistics, AI und IADS anwenden

Bewertung:

- Mission Generator ist ausreichend stark, um Missionsergebnisse an Kampagnensysteme weiterzugeben.
- Der erste produktive State-only-Empfänger ist CaptureSystem.
- Logistics, AI und IADS folgen später.

---

## Phase 6: F10 UI

Status:

- **Spieler-UI bestanden**
- **Mission Outcome Controls bestanden**
- **Capture Ready Anzeige bestanden**

Aktive Datei:

- `src/ui/tc_f10_menu.lua`

Aktuelle getestete Version:

- `v0.2.2`

Ziele:

- Spielerinterface über F10 bereitstellen
- Missionen anzeigen
- Missionen direkt auswählen
- Missionen direkt aktivieren
- Mission Outcome Controls bereitstellen
- Capture-/Pressure-Status anzeigen
- Capture Ready Zones anzeigen
- Pressure Contested Zones anzeigen
- State-Status anzeigen
- keine echten Spawns auslösen

Bestätigt:

- F10-Menü sichtbar
- F10-Menü navigierbar
- 32 Commands erzeugt
- Mission Details für Slots 1 bis 10 angelegt
- Activation Commands für Slots 1 bis 10 angelegt
- Mission Outcome Untermenü vorhanden
- `Show Active Mission Outcome Status` funktioniert
- `Complete Active Mission 1` funktioniert
- `Fail Active Mission 1` ist vorhanden, aber noch nicht praktisch bestätigt
- `Show Capture Status` funktioniert
- `Show Capture Ready Zones` funktioniert
- `Show Pressure Contested Zones` funktioniert
- Mission Details Slot 1 getestet
- Mission Slot 1 aktiviert
- Mission 1 auf `COMPLETED` gesetzt
- Capture Ready Zone nach Mission Completion über F10 angezeigt

Aktuelle Menüstruktur:

- `Theater Command`
  - `Missions`
    - `Show Available Missions`
    - `Show Active Missions`
    - `Mission Details`
      - `Show Mission 1 Details` bis `Show Mission 10 Details`
    - `Activate Mission`
      - `Activate Mission 1` bis `Activate Mission 10`
    - `Mission Outcome`
      - `Show Active Mission Outcome Status`
      - `Complete Active Mission 1`
      - `Fail Active Mission 1`
  - `Status`
    - `Show Campaign Status`
    - `Show Capture Status`
    - `Show Capture Ready Zones`
    - `Show Pressure Contested Zones`
  - `Logistics`
    - `Show Logistics Status`
    - `Show FOB Status`
  - `AI`
    - `Show AI CAP Status`

Noch nicht erledigt:

- kontrollierter Capture-Ownership-Wechsel aus Capture Ready
- aktive Mission abbrechen
- Mission expired/cancelled später über Debug oder F10 vorbereiten
- Debug-F10-Menü trennen
- längere Statusanzeigen strukturieren
- Seiten-/Pagination-Logik für große Listen

Nächster empfohlener UI-Schritt:

- `src/ui/tc_f10_menu.lua` erweitern
- `Apply Capture Ready Zone 1` oder `Confirm Capture Ready Zone 1` vorbereiten
- bewusst state-only bleiben
- keinen automatischen Ownership-Wechsel ohne Spieler-/Debug-Bestätigung auslösen

Bewertung:

- F10Menu ist die aktuelle beste Test- und Sichtbarkeitsfläche.
- Der nächste kleine Schritt sollte weiterhin UI/State sein, nicht direkt MOOSE oder CTLD.

---

## Phase 7: AI CAP Manager

Status:

- **State-first-Grundlage bestanden**

Aktive Datei:

- `src/ai/tc_ai_cap_manager.lua`

Aktuelle getestete Version:

- `v0.2.0`

Ziele:

- CAP-Zonen aus Kampagnenlage ableiten
- CAP-Bedarf für Blue und Red vorbereiten
- CAP-State erzeugen
- spätere MOOSE-Anbindung vorbereiten

Bestätigte Werte:

- cap zone candidates: 31
- auto-registered CAP zones: 12
- CAP requests: 12
- reactionState: `AIR_REACTION_REQUESTED`
- threatLevel: `HIGH`

Erledigt:

- CAP-Zonen-Kandidaten werden erkannt.
- CAP-Requests werden erzeugt.
- Blue-/Red-CAP-State ist vorbereitet.
- MOOSE-Hooks sind vorbereitet.
- `spawn=MOOSE_PENDING` ist erwartetes Verhalten.

Noch nicht erledigt:

- MOOSE CAP Templates im Mission Editor anlegen
- echte MOOSE SPAWN-Logik
- AI_A2A_DISPATCHER prüfen
- CAP-Flüge real starten
- CAP-Erfolge und Verluste auswerten
- CAP mit Mission Generator und AI Director verbinden

Bewertung:

- AI CAP Manager ist ein Vorläufer des späteren AI Directors.
- Noch keine echte KI-Kampagnenlogik, sondern vorbereitender CAP-State.

---

## Phase 8: Persistence

Status:

- **Grundstruktur vorhanden, produktiver Test offen**

Aktive Datei:

- `src/campaign/tc_persistence_system.lua`

Ziele:

- Kampagnenzustand speichern
- Kampagnenzustand laden
- State nach Missionsneustart wiederherstellen
- Save-Datei außerhalb der `.miz` nutzen
- DCS-Sandbox-Dateizugriff prüfen

Erledigt:

- Datei existiert.
- Modul lädt.
- Modul startet.
- State-Struktur ist inzwischen ausreichend, um ersten Save/Load-Test vorzubereiten.

Noch nicht erledigt:

- DCS-Dateischreibzugriff praktisch testen
- Save-Dateipfad final definieren
- Save-Format final definieren
- Load-Reihenfolge definieren
- Airbase-/Zone-/Capture-State speichern
- Logistics-/FOB-State speichern
- Mission-State speichern
- AI-State speichern
- UI-State optional speichern
- robuste Fehlerbehandlung bei defekten Save-Dateien

Geplanter Ansatz:

1. State-Dump minimal testen
2. Schreibzugriff im DCS-Sandbox-Kontext prüfen
3. Save-Datei erzeugen
4. Save-Datei wieder einlesen
5. nur danach produktive Persistenz aufbauen

Bewertung:

- Persistence ist wichtig, sollte aber erst praktisch getestet werden, wenn der State und der Capture-Ownership-Wechsel stabil genug sind.
- Dieser Punkt rückt nach kontrolliertem Capture-Ownership-Test näher.

---

## Phase 9: IADS

Status:

- **Vendor geladen, eigenes Modul offen**

Vendor:

- `vendor/skynet-iads/SkynetIADS.lua`

Ziele:

- Skynet IADS als dynamisches Luftverteidigungsframework nutzen
- IADS-Sites mit Kampagnenzonen verbinden
- IADS-Zustand in Missionen, AI und Capture einfließen lassen
- SEAD/DEAD/IADS_SUPPRESSION sinnvoll machen
- IADS-Zustand persistieren

Noch nicht erledigt:

- `src/iads/tc_iads_system.lua` erstellen
- IADS-Sites erfassen
- SAM-/EWR-/Command-Struktur definieren
- Skynet-Instanzen initialisieren
- IADS mit ZoneFactory/Capture verbinden
- IADS-Missionsziele erzeugen
- IADS-Status im F10-Menü anzeigen
- IADS-Zustand persistieren

Bewertung:

- Skynet ist geladen, aber noch nicht produktiv verbunden.
- IADS sollte erst nach weiterem Mission-/Capture-/Debug-Fortschritt produktiv integriert werden.

---

## Phase 10: AI Director

Status:

- **noch nicht implementiert**

Ziel:

Ein eigener AI Director soll später die Kampagnenlogik beider Seiten steuern.

Geplante Datei:

- `src/ai/tc_ai_director.lua`

Zielverhalten:

- Blue plant eigene Operationen.
- Red plant eigene Operationen.
- beide Seiten bewerten Kampagnenlage.
- beide Seiten reagieren auf:
  - Besitzstatus
  - Capture-Progress
  - Missionen
  - Logistics
  - FOBs
  - CAP-Lage
  - IADS
  - Verluste
  - verfügbare Ressourcen
- Spieler kann Missionen auswählen, aber die Kampagne läuft auch ohne Spielerentscheidungen weiter.

Noch nicht erledigt:

- AI Director State definieren
- Entscheidungsmodell definieren
- Blue-Offensive planen
- Red-Defensive planen
- Red-Gegenangriffe planen
- MissionGenerator mit AI Director koppeln
- AICapManager mit AI Director koppeln
- Logistics und FOBs einbeziehen
- IADS einbeziehen
- MOOSE-Spawns später einbinden

Bewertung:

- AI Director ist ein zentrales späteres System.
- Er sollte erst begonnen werden, wenn Missionen, Capture, Logistics, FOB und F10-Debug ausreichend sichtbar sind.

---

## Phase 11: Echte Framework-Ausführung

Status:

- **noch nicht produktiv**

Ziel:

Die vorbereiteten State-Systeme sollen später echte DCS-Aktionen auslösen.

Framework-Zuordnung:

| Bereich | Framework |
|---|---|
| CAP | MOOSE |
| Strike/SEAD/DEAD/CAS | MOOSE |
| Cargo/Transport | CTLD |
| FOBs | CTLD |
| Air Defense | Skynet IADS |
| Utility/DB/Events | MIST nach Bedarf |

Noch nicht erledigt:

- MOOSE Templates im Mission Editor anlegen
- CAP Spawn-Templates definieren
- Strike/SEAD/DEAD Templates definieren
- Transport-/Cargo-Templates definieren
- CTLD Pickup-Zonen definieren
- CTLD Dropoff-/FOB-Zonen definieren
- Skynet Sites definieren
- Eventauswertung implementieren
- Spawn-Limits definieren
- Cleanup-Logik definieren

Bewertung:

- Framework-Ausführung kommt erst nach stabiler State- und Debug-Schicht.
- Keine echten Spawns ohne saubere Mission-Editor-Vorbereitung.

---

## Phase 12: Debug und Testing

Status:

- **teilweise durch Logauswertung und F10 sichtbar**
- **eigenes Debug-System offen**

Ziele:

- Debug-Reports pro System
- F10-Debug-Menü
- State-Dump
- Mission-Dump
- Capture-Dump
- Logistics-Dump
- AI-Dump
- IADS-Dump
- Testchecklisten

Erledigt:

- Logmarker pro System sind vorhanden.
- F10Menu zeigt Missionen, Mission Outcome, Capture, Logistics, FOB und AI CAP Status.
- Capture Ready kann über F10 sichtbar gemacht werden.
- Mission Completion kann über F10 getestet werden.

Noch nicht erledigt:

- `src/debug/tc_debug_report.lua`
- separates Debug-F10-Menü
- State-Dump-Funktion
- kompakte Log-Reports
- Testmission-Checklisten
- automatisierte Smoke-Test-Erwartungen

Bewertung:

- Das Projekt ist jetzt groß genug, dass Debug-Sichtbarkeit wichtiger wird.
- Der nächste kleine Schritt bleibt aber sinnvollerweise kontrollierter Capture-Ownership-Test im bestehenden F10-Menü.

---

## Phase 13: `.miz`-Generierung

Status:

- **nicht begonnen**

Langfristiges Ziel:

- automatische oder halbautomatische `.miz`-Erzeugung
- Szenario-Generierung
- Template-Platzierung
- Trigger-Erzeugung
- Campaign-State-Vorbelegung

Noch nicht erledigt:

- `.miz`-Struktur untersuchen
- Zip-/Lua-Struktur automatisieren
- Mission-Datei generieren
- Unit-/Group-Templates schreiben
- Trigger automatisch erzeugen
- externe App oder Tooling prüfen

Bewertung:

- `.miz`-Generierung ist ein späteres Langfristziel.
- Aktuell wird bewusst manuell im Mission Editor gearbeitet.

---

## 3. Aktuelle Prioritäten

Stand: **2026-07-06**

### Priorität 1: Kontrollierten Capture-Ownership-Wechsel vorbereiten

Mögliche Datei:

- `src/ui/tc_f10_menu.lua`

Ziel:

- eine Capture Ready Zone bewusst übernehmen können
- kein automatischer Besitzwechsel ohne Spieler-/Debug-Bestätigung
- möglicher F10-Befehl:
  - `Apply Capture Ready Zone 1`
  - oder `Confirm Capture Ready Zone 1`
- State-only bleiben
- keine echten Spawns
- keine CTLD-Aktion
- keine Skynet-Aktion
- keine automatische produktive Kampagnenauswertung ohne Testpfad

Begründung:

- Mission Completion erzeugt inzwischen Capture Pressure.
- Capture Ready entsteht dynamisch.
- Capture Ready Zones sind über F10 sichtbar.
- Der nächste logische Schritt ist ein bewusster, kontrollierter Ownership-Wechsel.

---

### Priorität 2: Mission Failed praktisch testen

Ziel:

- `Fail Active Mission 1` über F10 praktisch testen
- `MissionGenerator.failMission()` bestätigen
- Failure-Outcome und vorbereitete Failure-Effects prüfen
- festlegen, ob Failure-Effekte neutral, negativ oder gegnerisch wirken sollen
- keine echten Framework-Aktionen auslösen

Begründung:

- Completion-Pfad ist bestanden.
- Failure-Pfad ist im Code vorbereitet, aber noch nicht logbestätigt.

---

### Priorität 3: Persistence-Sandbox-Test

Ziel:

- prüfen, ob DCS in der aktuellen Umgebung Save-Dateien schreiben darf
- minimalen State-Dump speichern
- minimalen State-Dump laden
- keine produktive Persistenz ohne erfolgreichen Sandbox-Test

Mögliche Datei:

- `src/campaign/tc_persistence_system.lua`

Begründung:

- State-Struktur ist inzwischen ausreichend stabil für einen ersten technischen Persistenztest.
- Vor produktiver Persistenz muss aber zuerst der DCS-Sandbox-Zugriff klar sein.

---

### Priorität 4: CTLD-Vorbereitung im Mission Editor

Ziel:

- CTLD Pickup-Zonen definieren
- CTLD Dropoff-Zonen definieren
- FOB-Bauzonen definieren
- Transporthelikopter vorbereiten
- CTLD mit Logistics/FOB-State verbinden

Mögliche Bereiche:

- Mission Editor
- `src/logistics/tc_logistics_delivery.lua`
- `src/logistics/tc_fob_system.lua`

Begründung:

- CTLD sollte erst produktiv angebunden werden, wenn die Mission-Editor-Zonen und Cargo-Templates sauber angelegt sind.

---

### Priorität 5: AI Director state-only beginnen

Ziel:

- Blue und Red mit strategischer Entscheidungsebene ausstatten
- keine echten Spawns im ersten Schritt
- Operationen nur als State planen
- MissionGenerator, Capture, Logistics, FOBs, CAP und später IADS einbeziehen

Mögliche Datei:

- `src/ai/tc_ai_director.lua`

Begründung:

- Das Projektziel ist eine Blue-vs-Red-Kampagne.
- Der Spieler soll Teilnehmer sein, nicht alleiniger Motor.
- AI Director sollte aber erst nach weiterem State-/Debug-Fortschritt begonnen werden.

---

## 4. Nächster konkreter Schritt

Empfohlene nächste Code-Datei:

- `src/ui/tc_f10_menu.lua`

Empfohlenes Ziel:

- kontrollierten state-only Capture-Ownership-Wechsel für Capture Ready Zone 1 vorbereiten

Möglicher neuer F10-Pfad:

- `Theater Command > Status > Show Capture Ready Zones`
- `Theater Command > Status > Apply Capture Ready Zone 1`

Akzeptanzkriterien:

- F10Menu lädt als neue Version.
- bisherige 32 Commands bleiben funktionsfähig.
- neuer Capture-Apply-Command wird ergänzt.
- Capture Ready Zone 1 kann über F10 bewusst angewendet werden.
- Zone Ownership wird state-only aktualisiert.
- linked Airbase Ownership wird nur kontrolliert über bestehende CaptureSystem-Funktion synchronisiert.
- Capture Pressure wird nach erfolgreichem Ownership-Wechsel zurückgesetzt oder sauber markiert.
- Logmarker zeigen eindeutig den Ownership-Wechsel.
- keine echten Spawns
- keine CTLD-Aktion
- keine Skynet-Aktion
- keine Lua-Fehler
- keine Theater-Command-Fehler

Erwartete neue Testmarker nach Umsetzung:

- `[TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.3`
- `[TC] [F10Menu] F10 menu initialized:`
- `[TC] [F10Menu] Capture ready zones shown through F10`
- `[TC] [F10Menu] Capture ready zone applied through F10:`
- `[TC] [CaptureSystem] Zone captured:`
- `[TC] [CaptureSystem] Capture pressure cleared:`
- weiterhin keine echten MOOSE-/CTLD-/Skynet-Aktionen

---

## 5. Strategische Reihenfolge

Empfohlene Reihenfolge der nächsten Entwicklung:

1. kontrollierter Capture-Ownership-Wechsel state-only
2. Failure-Pfad praktisch testen
3. Persistence-Sandbox-Test
4. Debug-/State-Dump verbessern
5. CTLD-Zonen im Mission Editor vorbereiten
6. echte Logistics-/FOB-Anbindung beginnen
7. AI Director state-only vorbereiten
8. MOOSE-Spawns erst mit klaren Templates
9. Skynet-IADS-Brücke erst nach stabiler Mission-/Capture-/AI-Grundlage
10. `.miz`-Generierung als späteres Langfristziel

Leitlinie:

- erst State sichtbar und testbar machen
- dann State kontrolliert verändern
- dann State speichern
- erst danach echte DCS-Aktionen auslösen

---

## 6. Aktueller Meilenstein

Aktueller Meilenstein erreicht:

- **Mission Outcome to Capture Pressure Pipeline**

Bestätigte Pipeline:

- F10 Mission Selection
- Mission Activation
- Mission Completion
- Mission Effect Preparation
- CaptureSystem Effect Processing
- Capture Pressure Update
- Capture Progress Update
- Capture Ready Detection
- F10 Capture Ready Visibility

Diese Pipeline ist der erste echte modulübergreifende Kampagnenzusammenhang im Projekt.

Sie bleibt aktuell bewusst:

- state-only
- testbar
- ohne echte Framework-Ausführung
- ohne automatische produktive Besitzwechsel
