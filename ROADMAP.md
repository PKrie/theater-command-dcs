# ROADMAP.md

Diese Roadmap beschreibt den geplanten Entwicklungsweg von **Theater Command DCS**.

Das Projekt ist modular aufgebaut. Jede Stufe soll einzeln testbar sein, bevor die nächste Stufe produktiv angebunden wird.

---

## 1. Zielbild

**Theater Command DCS** soll ein dynamisches und später persistentes Kampagnensystem für DCS World werden.

Erste Kampagne:

- **Operation Levant Reclamation**
- Map: **Syria**
- Blue startet auf **Akrotiri / Zypern**
- Das syrische Festland ist zu Beginn rot kontrolliert

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

Aktive Datei:

- `src/campaign/tc_capture_system.lua`

Aktuelle getestete Version:

- `v0.2.1`

Ziele:

- Ownership für Basen und Zonen verwalten
- Capture-Eligibility definieren
- nicht geeignete Objekte ausschließen
- verknüpfte Airbase-/Zone-Ownership synchronisieren
- Capture-Events speichern
- Capture-Pressure vorbereiten
- Capture-Progress vorbereiten
- Missionseffekte als Capture-Druck vorbereiten

Bestätigte Werte:

- eligibleBases: 32
- eligibleZones: 32
- nonCaptureBases: 193
- nonCaptureZones: 14
- pressureRecords: 32
- progressRecords: 32
- appliedMissionEffects: 0
- ready: 0
- contested: 0

Erledigt:

- CaptureSystem startet sauber.
- 32 capture-fähige Basen werden erkannt.
- 32 capture-fähige Zonen werden erkannt.
- 193 nicht capture-fähige Basen werden ausgeschlossen.
- 14 nicht capture-fähige Zonen werden ausgeschlossen.
- 32 Capture-Pressure-Records werden erzeugt.
- 32 Capture-Progress-Records werden erzeugt.
- Mission Effect zu Capture Pressure ist vorbereitet.
- Capture Ready ist vorbereitet.
- Pressure Contested ist vorbereitet.
- Completion Hooks sind vorbereitet.
- Automatische produktive Capture-Folgen bleiben deaktiviert.

Offen:

- Capture-/Pressure-Status im F10-Menü sichtbar machen
- Missionserfolg mit Capture-Druck praktisch testen
- `CaptureSystem.applyMissionEffect()` praktisch auslösen
- Capture Ready Zones anzeigen
- Pressure Contested Zones anzeigen
- automatische Capture-Auswertung später entwickeln
- Capture-Zustand persistieren
- AI Director mit Capture-State verbinden

Bewertung:

- Capture ist jetzt nicht mehr nur Ownership, sondern besitzt eine vorbereitete Druck-/Fortschrittsstruktur.
- Das System bleibt State-only und sicher testbar.

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

Aktive Datei:

- `src/missions/tc_mission_generator.lua`

Aktuelle getestete Version:

- `v0.2.2`

Ziele:

- Missionen aus Kampagnenlage erzeugen
- Missionen priorisieren
- FOB-Support berücksichtigen
- Missionspool stabil halten
- Missionen über F10 auswählbar machen
- Objectives, Briefings und Progress vorbereiten
- Spawn-Hooks für MOOSE, CTLD und Skynet vorbereiten

Bestätigte Werte:

- mission candidates: 69
- fobSupportCandidates: 2
- generated missions: 10
- reservedCreated: 1
- duplicatesSkipped: 1
- typeLimitSkipped: 30

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
- Missionen enthalten Execution Plans.
- MOOSE-/CTLD-/Skynet-Hooks sind reserviert.
- Aktivierte Missionen bleiben `stateOnly=true`.
- Spawn-Hooks bleiben `reserved`.

Bestätigte F10-Interaktion:

- Mission Details Slot 1 funktioniert.
- Mission Details Slot 2 funktioniert.
- Mission Details Slot 5 funktioniert.
- Mission Slot 1 kann aktiviert werden.
- Mission Slot 5 kann aktiviert werden.
- MissionGenerator setzt aktivierte Missionen auf `ACTIVE`.

Noch nicht erledigt:

- Mission completed/failed über F10 oder Debug testbar machen
- automatische Missionserfolgsauswertung
- DCS-Event-Auswertung
- echte MOOSE-Spawns
- echte CTLD-Aktionen
- echte Skynet-IADS-Wirkung
- Missionseffekte produktiv auf Capture/Logistics/AI/IADS anwenden

Bewertung:

- Mission Generator ist jetzt ausreichend stark für die nächste UI- und Debug-Stufe.
- Die Missionen sind fachlich deutlich besser modelliert, bleiben aber sicher state-only.

---

## Phase 6: F10 UI

Status:

- **erste Spieler-UI bestanden**

Aktive Datei:

- `src/ui/tc_f10_menu.lua`

Aktuelle getestete Version:

- `v0.2.0`

Ziele:

- Spielerinterface über F10 bereitstellen
- Missionen anzeigen
- Missionen direkt auswählen
- Missionen direkt aktivieren
- State-Status anzeigen
- keine echten Spawns auslösen

Bestätigt:

- F10-Menü sichtbar
- F10-Menü navigierbar
- 26 Commands erzeugt
- Mission Details für Slots 1 bis 10 angelegt
- Activation Commands für Slots 1 bis 10 angelegt
- Mission Details Slot 1 getestet
- Mission Details Slot 2 getestet
- Mission Details Slot 5 getestet
- Mission 1 aktiviert
- Mission 5 aktiviert
- MissionGenerator setzt Missionen auf `ACTIVE`

Aktuelle Menüstruktur:

    F10
    └── Theater Command
        ├── Missions
        │   ├── Show Available Missions
        │   ├── Show Active Missions
        │   ├── Mission Details
        │   │   ├── Show Mission 1 Details
        │   │   ├── ...
        │   │   └── Show Mission 10 Details
        │   └── Activate Mission
        │       ├── Activate Mission 1
        │       ├── ...
        │       └── Activate Mission 10
        ├── Status
        │   └── Show Campaign Status
        ├── Logistics
        │   ├── Show Logistics Status
        │   └── Show FOB Status
        └── AI
            └── Show AI CAP Status

Noch nicht erledigt:

- Capture Status anzeigen
- Capture Ready Zones anzeigen
- Pressure Contested Zones anzeigen
- aktive Mission abbrechen
- Mission completed/failed manuell auslösen
- Debug-F10-Menü trennen
- längere Statusanzeigen strukturieren
- Seiten-/Pagination-Logik für große Listen

Nächster empfohlener Schritt:

- `src/ui/tc_f10_menu.lua` erweitern
- Capture-/Pressure-Status sichtbar machen
- weiterhin state-only bleiben

Bewertung:

- F10Menu ist die aktuelle beste Test- und Sichtbarkeitsfläche.
- Der nächste kleine Schritt sollte wieder UI/State sein, nicht direkt MOOSE oder CTLD.

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

- Persistence ist wichtig, aber sollte erst praktisch getestet werden, wenn der State stabil genug ist.
- Dieser Punkt rückt nach F10-Capture-Sichtbarkeit und Mission-Completion-Test näher.

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

- **teilweise durch Logauswertung, eigenes Debug-System offen**

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

Noch nicht erledigt:

- `src/debug/tc_debug_report.lua`
- Debug-F10-Menü
- State-Dump-Funktion
- kompakte Log-Reports
- Testmission-Checklisten
- automatisierte Smoke-Test-Erwartungen

Bewertung:

- Das Projekt ist jetzt groß genug, dass Debug-Sichtbarkeit wichtig wird.
- Der nächste kleine Schritt bleibt aber sinnvollerweise Capture-/Pressure-Anzeige im bestehenden F10-Menü.

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

Stand: **2026-06-29**

### Priorität 1: Capture-/Pressure-Status im F10-Menü sichtbar machen

Datei:

- `src/ui/tc_f10_menu.lua`

Ziel:

- `Show Capture Status`
- `Show Capture Ready Zones`
- `Show Pressure Contested Zones`
- Capture-Pressure anzeigen
- Capture-Progress anzeigen
- State-only bleiben
- keine Spawns
- keine CTLD-Aktionen
- keine Skynet-Aktionen

Begründung:

- CaptureSystem `v0.2.1` erzeugt jetzt sinnvolle Pressure- und Progress-Daten.
- Diese Daten müssen im Spiel sichtbar werden.
- F10Menu ist stabil und eignet sich als nächste Oberfläche.

---

### Priorität 2: Mission completed/failed testbar machen

Ziel:

- aktive Mission abschließen
- aktive Mission fehlschlagen lassen
- Mission Completion State testen
- Mission Effects praktisch testen
- CaptureSystem.applyMissionEffect praktisch testen

Mögliche Datei:

- zuerst wahrscheinlich `src/ui/tc_f10_menu.lua`
- alternativ später `src/debug/`

---

### Priorität 3: Persistence-Sandbox-Test

Ziel:

- prüfen, ob DCS in der aktuellen Umgebung Save-Dateien schreiben darf
- minimalen State-Dump speichern
- minimalen State-Dump laden
- keine produktive Persistenz ohne erfolgreichen Sandbox-Test

Mögliche Datei:

- `src/campaign/tc_persistence_system.lua`

---

### Priorität 4: CTLD-Vorbereitung im Mission Editor

Ziel:

- CTLD Pickup-Zonen definieren
- CTLD Dropoff-Zonen definieren
- FOB-Bauzonen definieren
- Transporthelikopter vorbereiten
- CTLD mit Logistics/FOB-State verbinden

Mögliche Dateien:

- Mission Editor
- `src/logistics/tc_logistics_delivery.lua`
- `src/logistics/tc_fob_system.lua`

---

### Priorität 5: AI Director state-only beginnen

Ziel:

- Blue und Red mit strategischer Entscheidungsebene ausstatten
- keine echten Spawns im ersten Schritt
- Operationen nur als State planen

Mögliche Datei:

- `src/ai/tc_ai_director.lua`

---

## 4. Nächster konkreter Schritt

Empfohlene nächste Datei:

- `src/ui/tc_f10_menu.lua`

Empfohlenes Ziel:

- Capture-/Pressure-Status in F10 anzeigen

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
- Capture Ready Zones können angezeigt werden.
- Pressure Contested Zones können angezeigt werden.
- keine echten Spawns
- keine CTLD-Aktion
- keine Skynet-Aktion
- keine Lua-Fehler
- keine Theater-Command-Fehler

Erwartete neue Testmarker nach Umsetzung:

    [TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.1
    [TC] [F10Menu] F10 menu initialized:
    [TC] [F10Menu] Capture status shown through F10
    [TC] [F10Menu] Capture ready zones shown through F10
    [TC] [F10Menu] Pressure contested zones shown through F10

---

## 5. Abschlussstand dieser Session

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

Aktuell ist das Projekt noch keine fertige dynamische Kampagne.

Es besitzt aber jetzt eine stabile state-first Runtime-Grundlage mit:

- Airbase-Klassifizierung
- Kampagnenzonen
- Capture-Eligibility
- Capture-Pressure
- Capture-Progress
- Logistics Hubs
- FOB-Kandidaten
- geplanten FOBs
- Missionen inklusive FOB-Support
- direkter F10-Missionsauswahl
- direkter F10-Missionsaktivierung
- AI-CAP-State
- sauberem Main-/Loader-Start

Nächster sinnvoller Schritt bleibt:

- Capture-/Pressure-Status im F10-Menü sichtbar machen.
