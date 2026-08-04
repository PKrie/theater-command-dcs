# ROADMAP.md

Diese Roadmap beschreibt den geplanten Entwicklungsweg von **Theater Command DCS**.

Das Projekt ist modular aufgebaut. Jede Stufe soll einzeln testbar sein, bevor die nächste Stufe produktiv angebunden wird.

Projekt:

- Theater Command DCS

Erste Kampagne:

- Operation Levant Reclamation

Map:

- Syria

Grundprinzip:

- Mission Editor = Bühne
- Lua = Kampagnensystem
- GitHub = Projektgedächtnis

## Verbindlicher Stand — 2026-08-04

- Dirty-aware PersistenceSystem `v0.2.6` ist implementiert und mit Hotload-, Fehler-/Retry- und normal eingebetteten Scheduler-Tests bestanden.
- Der reale Scheduler speicherte `ai_cap_needs_evaluated` als `SAVED`; drei unveränderte Folgeticks waren `SKIPPED` ohne Save-Datei-Änderung.
- Produktiver Startup-Restore bleibt deaktiviert und ungetestet.
- MissionGenerator `v0.2.3` erzeugt zunächst zehn Missionen, verliert später jedoch reproduzierbar alle sechs Status-Collections. Ursache und Writer sind unbekannt.
- Statische Klassifikation: `PROJECT SOURCE HAS NO MATCHING WRITE SITE`.
- Vor MissionGenerator-Codeänderungen oder blockierten Mission/Capture-Regressionen muss die gespeicherte `.miz` offline auf eingebettete Source-Drift, stale/duplizierte Ressourcen und Trigger-Mappings auditiert werden.

---

## 1. Zielbild

Theater Command DCS soll ein dynamisches und später persistentes Kampagnensystem für DCS World werden.

Erste Kampagne:

- Operation Levant Reclamation

Map:

- Syria

Ausgangslage:

- Blue startet auf Akrotiri / Zypern.
- Das syrische Festland ist zu Beginn rot kontrolliert.
- Red hält zu Beginn den Großteil der strategischen Flugplätze.
- Blue soll sich vom Brückenkopf Zypern aus auf das syrische Festland vorarbeiten.
- Spieler sollen sich in eine laufende Kampagne einklinken, nicht jede Aktion allein auslösen.
- Blue und Red sollen perspektivisch eigene Operationen durchführen.

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

---

## 2. Aktueller Entwicklungsstand

Historischer Baseline-Stand: 2026-07-06. Der verbindliche aktuelle Stand steht oben.

Theater Command DCS befindet sich weiterhin in einer frühen Aufbauphase, besitzt aber inzwischen eine stabil getestete State-first Runtime mit funktionierender Hintergrundpersistenz.

Aktuell bestätigt:

- Vendor-Frameworks laden.
- Core-Systeme laden.
- Main und Loader starten.
- Syria-Airbase-Scan funktioniert.
- relevante Kampagnenzonen werden erzeugt.
- Capture Pressure und Capture Progress funktionieren state-only.
- MissionGenerator erzeugt verfügbare Missionen.
- Missionen können state-only aktiviert werden.
- Missionen können state-only abgeschlossen werden.
- Missionen können state-only fehlschlagen.
- abgeschlossene Mission Effects können Capture Pressure erzeugen.
- Failed Missions erzeugen aktuell bewusst keinen Capture Pressure.
- Capture Ready kann state-only angewendet werden.
- Zone Ownership und linked Airbase Ownership können state-only synchronisiert werden.
- F10Menu ist als Test- und Bedienoberfläche stabil.
- PersistenceSystem kann DCS-Dateien schreiben, lesen, validieren und kontrolliert importieren.
- PersistenceSystem läuft jetzt als unsichtbarer Background-Autosave-Service.

Noch nicht produktiv:

- echte MOOSE-Spawns
- echte CTLD-FOBs
- echte CTLD-Cargo-Aktionen
- echte Skynet-IADS-Kampagnenlogik
- produktiver automatischer Restore beim Missionsstart
- automatische Missionserfolgserkennung über DCS-Events
- automatische Capture-Auswertung über reale DCS-Einheiten/Zonen
- produktive Blue-/Red-AI-Operationen
- Persistenz-Hooks in allen relevanten State-Systemen

---

## 3. Entwicklungsphasen

Die Roadmap ist bewusst in technische Phasen gegliedert.

Jede Phase soll einen klar testbaren Zustand liefern.

---

## Phase 0: Projektgrundlage

Status:

- abgeschlossen

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

- weitgehend abgeschlossen

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

- abgeschlossen für aktuellen State-first-Stand

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

- bestanden

Getestete Version:

- `v0.2.2`

Bestätigte Werte:

- total: `225`
- strategic: `19`
- secondary: `13`
- heliports: `1`
- helipads: `95`
- medical: `40`
- farps: `0`
- tactical: `13`
- unknown: `44`
- captureCandidates: `32`
- missionCandidates: `32`
- logisticsCandidates: `46`
- blueStartBases: `1`
- redStrategicCandidates: `18`

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

- bestanden

Getestete Version:

- `v0.2.0`

Bestätigte Werte:

- total zones: `46`
- classified airbase zones: `46`
- Mission Editor zones: `0`
- skipped airbase-like objects: `179`
- strategic zones: `19`
- secondary zones: `13`
- heliport zones: `1`
- farp zones: `0`
- tactical zones: `13`
- captureZones: `32`
- missionZones: `32`
- logisticsZones: `46`
- startBaseZones: `1`

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

- historische State-first-Grundlage bestanden
- aktueller reproduzierbarer Mission-Record-Verlust noch ungelöst
- Mission Effect zu Capture Pressure bestanden
- Failure-Pfad bestanden
- kontrollierter Capture Ready Apply bestanden
- Persistenz-Hook noch offen

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
- Failed Mission Effects korrekt ohne Capture Pressure behandeln
- Capture Ready und Pressure Contested sichtbar machen
- Capture Ready bewusst state-only anwenden können
- produktive automatische Ownership-Wechsel bewusst getrennt vorbereiten

Bestätigte Startwerte:

- eligibleBases: `32`
- eligibleZones: `32`
- nonCaptureBases: `193`
- nonCaptureZones: `14`
- pressureRecords: `32`
- progressRecords: `32`
- appliedMissionEffects: `0`
- ready: `0`
- contested: `0`

Bestätigte Werte nach Mission Completion:

- completed mission: `MISSION_2`
- target zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- capture pressure owner: `BLUE`
- applied pressure: `105`
- progress: `100 %`
- appliedMissionEffects: `1`
- ready: `1`
- contested: `0`

Bestätigte Werte nach Capture Ready Apply:

- applied zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- applied owner: `BLUE`
- linked airbase: `Abu al-Duhur`
- linked airbase owner: `BLUE`
- ready nach Apply: `0`
- contested nach Apply: `0`

Bestätigte Failure-Werte:

- Mission Outcome: `FAILED`
- Mission Effects: `prepared`
- CaptureSystem processing: `applied=0`
- ready: `0`
- contested: `0`
- appliedMissionEffects: `0`

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
- Mission Failure wird verarbeitet, ohne Capture Pressure zu erzeugen.
- Capture Ready Zones sind über F10 sichtbar.
- Capture Ready Zone 1 kann bewusst über F10 angewendet werden.
- Zone Ownership wurde state-only aktualisiert.
- Linked Airbase Ownership wurde state-only synchronisiert.
- Capture Pressure wurde nach erfolgreichem Ownership-Wechsel zurückgesetzt.
- automatische produktive Capture-Folgen bleiben deaktiviert.

Offen:

- Dirty-/Persistence-Hook nach erfolgreichem Capture Ready Apply
- Logistikzustand mit Capture-Fähigkeit koppeln
- AI-Operationen mit Capture-Fortschritt koppeln
- Capture-Zustand persistenzrelevant markieren
- später produktive Ownership-Regeln definieren
- automatische Auswertung realer Einheiten in Capture-Zonen

Bewertung:

- Capture ist jetzt nicht mehr nur Ownership.
- Capture besitzt eine funktionierende Druck-/Fortschrittsstruktur.
- Der erste kontrollierte state-only Ownership-Wechsel ist bestätigt.
- Mission Completion und Mission Failure sind bestätigt.
- Nächster Schritt ist nicht weiterer F10-Ausbau, sondern Persistence-Hook bei State-Änderung.

---

## Phase 4: Logistics und FOBs

Status:

- State-first-Grundlage bestanden

Aktive Dateien:

- `src/logistics/tc_logistics_delivery.lua`
- `src/logistics/tc_fob_system.lua`

---

### Phase 4.1 Logistics Delivery

Status:

- bestanden

Getestete Version:

- `v0.2.0`

Bestätigte Werte:

- logistics hubs: `46`
- blue hubs: `7`
- red hubs: `24`
- neutral hubs: `15`
- active hubs: `31`
- limited hubs: `15`
- locked hubs: `0`

Erledigt:

- Logistics Hubs werden aus ZoneFactory-Daten erzeugt.
- Hubs werden nach Owner und Status gruppiert.
- Active/Limited/Locked-Status ist vorbereitet.
- CTLD ist geladen, wird aber noch nicht produktiv angesprochen.

Offen:

- CTLD-Zonen im Mission Editor definieren
- Pickup-/Dropoff-Zonen praktisch testen
- Cargo-/Supply-Werte festlegen
- Supply-Verbrauch modellieren
- Logistics-Zustand persistenzrelevant markieren
- Logistics mit Capture-System koppeln

Bewertung:

- Logistics ist als State-System vorbereitet.
- CTLD-Integration bleibt bewusst späterer Schritt.

---

### Phase 4.2 FOB System

Status:

- bestanden

Getestete Version:

- `v0.2.0`

Bestätigte Werte:

- FOB candidates: `6`
- stored candidates: `6`
- auto-planned FOBs: `2`
- skipped candidates: `4`

Erzeugte FOBs:

- `FOB Ercan`
- `FOB Gecitkale`

Status:

- `UNDER_CONSTRUCTION`

Erledigt:

- FOB-Kandidaten werden aus Logistics-Struktur abgeleitet.
- erste Blue-FOBs werden state-only geplant.
- FOB-Baufortschritt ist vorbereitet.
- CTLD-FOB-Erstellung ist noch nicht produktiv aktiv.

Offen:

- echte CTLD-FOB-Erstellung
- CTLD-Crates mit FOB-Baufortschritt koppeln
- FOB-Supply-Verbrauch modellieren
- FOB-Zustand persistenzrelevant markieren
- FOBs später als Forward Operations Bases für AI und Spieler nutzen

Bewertung:

- FOB-System ist als State-System vorbereitet.
- Echte CTLD-FOBs kommen später.

---

## Phase 5: Mission Generator

Status:

- State-first-Grundlage bestanden
- Mission Activation bestanden
- Mission Completion bestanden
- Mission Failure bestanden
- Mission Effects zu Capture Pressure bestanden

Aktive Datei:

- `src/missions/tc_mission_generator.lua`

Aktuelle getestete Version:

- `v0.2.3`

Bestätigte Werte:

- mission candidates: `78`
- fobSupportCandidates: `2`
- generated missions: `10`
- reservedCreated: `1`
- duplicatesSkipped: `1`
- typeLimitSkipped: `68`

Erledigt:

- Mission Candidates werden aus Kampagnenzonen erzeugt.
- FOB-Support wird reserviert erzeugt.
- Mission Records enthalten Objectives.
- Mission Records enthalten Briefings.
- Mission Records enthalten Progress-Daten.
- Mission Records enthalten Activation Metadata.
- Mission Records enthalten Outcome State.
- Mission Records enthalten Effect State.
- MOOSE-/CTLD-/Skynet-Hooks sind reserviert.
- Missionen können state-only aktiviert werden.
- Missionen können state-only abgeschlossen werden.
- Missionen können state-only fehlschlagen.
- Completed Effects können vom CaptureSystem verarbeitet werden.
- Failed Effects erzeugen aktuell keinen Capture Pressure.

Offen:

- Mission `CANCELLED` praktisch testbar machen
- Mission `EXPIRED` praktisch testbar machen
- Missionseffekte auf Logistics, AI und IADS erweitern
- automatische Missionserfolgsauswertung aus DCS-Events entwickeln
- echte Spawn-/Task-Hooks später anbinden
- Mission Status persistenzrelevant markieren

Bewertung:

- Die früheren Generierungs-, Aktivierungs-, Completion- und Failure-Tests bleiben gültige historische Ergebnisse.
- MissionGenerator darf aktuell weder als generell stabil noch als vollständig defekt bezeichnet werden.
- Die aktuelle Ursache des Mission-Record-Verlusts ist ungelöst; produktive Mission Execution bleibt reserviert.

---

## Phase 6: AI Director und CAP

Status:

- State-first-Grundlage bestanden

Aktive Datei:

- `src/ai/tc_ai_cap_manager.lua`

Aktuelle getestete Version:

- `v0.2.0`

Bestätigte Werte:

- cap zone candidates: `31`
- auto-registered CAP zones: `12`
- CAP requests: `12`
- reactionState: `AIR_REACTION_REQUESTED`
- threatLevel: `HIGH`

Erledigt:

- CAP-Zonen werden aus Kampagnenlage vorbereitet.
- Blue- und Red-CAP-State wird erzeugt.
- CAP Requests werden angelegt.
- MOOSE-Spawn bleibt bewusst `MOOSE_PENDING`.

Offen:

- MOOSE CAP Templates im Mission Editor anlegen
- MOOSE SPAWN-Anbindung implementieren
- AI_A2A_DISPATCHER prüfen
- Blue und Red CAP real spawnen lassen
- CAP-Zustände durch DCS-Events aktualisieren
- CAP-Verluste und CAP-Erfolge auswerten
- AI-Zustand persistenzrelevant markieren

Bewertung:

- AI CAP Manager besitzt die State-Grundlage.
- Echte AI-Spawns sind spätere Integrationsphase.

---

## Phase 7: F10 UI

Status:

- Test- und Bedienoberfläche bestanden

Aktive Datei:

- `src/ui/tc_f10_menu.lua`

Aktuelle getestete Version:

- `v0.2.3`

Bestätigt:

- F10-Menü lädt.
- F10-Menü initialisiert mit `33` Commands.
- Missionen können angezeigt werden.
- Mission 1 bis Mission 10 Details können angezeigt werden.
- Mission 1 bis Mission 10 können aktiviert werden.
- Active Mission Outcome Status kann angezeigt werden.
- aktive Mission 1 kann auf `COMPLETED` gesetzt werden.
- aktive Mission 1 kann auf `FAILED` gesetzt werden.
- Capture Status kann angezeigt werden.
- Capture Ready Zones können angezeigt werden.
- Capture Ready Zone 1 kann bewusst angewendet werden.
- Pressure Contested Zones können angezeigt werden.
- Logistics Status kann angezeigt werden.
- FOB Status kann angezeigt werden.

Nicht vorgesehen:

- Spieler-F10-Menü für Persistence Save/Load

Begründung:

- Persistence ist ein Hintergrundsystem.
- Spieler sollen Kampagnenoperationen fliegen, nicht Savegames manuell verwalten.
- Persistence-Funktionen bleiben intern.

Offen:

- Mission Outcome Controls für Slots 2 bis 10 später ergänzen
- Cancel/Expire testbar machen
- langfristig Spieler-UI und Debug-/Admin-UI trennen
- Spielermenü später vereinfachen

Bewertung:

- F10Menu ist für den aktuellen Teststand stabil.
- Persistence gehört nicht in die Spieleroberfläche.

---

## Phase 8: Persistence

Status:

- technische Dateipersistenz bestanden
- Background-Autosave bestanden
- produktiver Auto-Restore bewusst noch deaktiviert

Aktive Datei:

- `src/campaign/tc_persistence_system.lua`

Aktuelle getestete Version:

- `v0.2.6`

Lokale Voraussetzung:

- `io` und `lfs` müssen in `...\DCS World\Scripts\MissionScripting.lua` für dieses Projekt entsperrt sein.
- `os` ist in der aktiven DCS-SMS-Bridge-Umgebung entsperrt.
- `require` bleibt gesperrt.
- Nach DCS-Updates kann diese lokale Änderung überschrieben werden.

Bestätigter Sandbox-Status:

- `os=true`
- `io=true`
- `lfs=true`
- `require=false`
- `load=true`
- `loadstring=true`
- `loadfile=true`
- `lfsFromRequire=false`
- `fileSystemAvailable=true`

Bestätigter Speicherordner:

- `C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS`

Bestätigte Save-Datei:

- `C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua`

Technische Stufen:

| Version | Ziel | Status |
|---:|---|---|
| `v0.2.0` | DCS-Sandbox-Verfügbarkeit prüfen | bestanden, zunächst blockiert |
| `v0.2.1` | Schreib-/Lesetest korrigieren | bestanden |
| `v0.2.2` | Campaign-State-Snapshot speichern | bestanden |
| `v0.2.3` | Save-Datei lesen, kompilieren, evaluieren und validieren | bestanden |
| `v0.2.4` | Save-Datei kontrolliert importieren | bestanden |
| `v0.2.5` | Background-Autosave statt Test-Timer-Kaskade | bestanden |
| `v0.2.6` | Dirty-aware Autosave mit `SAVED`, `SKIPPED`, `FAILED` und Retry | bestanden, inklusive Embedded-Scheduler |

Aktueller Autosave-Status:

- Autosave initial nach `20s`
- Autosave-Intervall `120s`
- Autosave läuft unsichtbar im Hintergrund.
- letzter bestätigter Autosave Count: `1`
- `productiveRestore=false`

Erledigt:

- DCS-Dateizugriff geprüft.
- Dateischreibzugriff bestätigt.
- Dateilesen bestätigt.
- Save-Datei als Lua-Return-Tabelle erzeugt.
- Save-Datei gelesen.
- Save-Datei kompiliert.
- Save-Datei evaluiert.
- Save-Datei validiert.
- Save-Datei kontrolliert importiert.
- Background-Autosave aktiviert.
- Test-Timer-Kaskade entfernt.
- Persistence nicht als Spieler-F10-Menü umgesetzt.

Offen:

- fachliche Dirty-Abdeckung weiter validieren
- produktiver automatischer Restore beim Missionsstart
- Save-Dateiformat langfristig versionieren
- Save-Datei-Backup/Rotation
- Schutz gegen veraltete oder inkompatible Save-Dateien
- Restore-Reihenfolge in Bezug auf World/Zone/Capture/Mission State definieren

Bewertung:

- Persistence ist jetzt ein funktionierender Hintergrunddienst.
- Der nächste Schritt ist nicht weiterer Persistence-Testcode, sondern die Anbindung echter State-Änderungen an Persistence.
- Produktiver Restore wird erst freigeschaltet, wenn Dirty-/Change-Hooks stabil getestet sind.

---

## Phase 9: IADS

Status:

- dokumentiert / vorbereitet
- noch nicht produktiv angebunden

Ziel:

- Skynet IADS als dynamische Luftverteidigungsschicht integrieren
- SAM- und EWR-Gruppen sauber benennen
- IADS-Zustand mit Kampagnenlage koppeln
- Missionen gegen IADS-Ziele erzeugen
- zerstörte oder unterdrückte Luftverteidigung in State/Persistence abbilden

Offen:

- Mission-Editor-Gruppen definieren
- Naming-Konventionen finalisieren
- Skynet-IADS-Initialisierung in eigenes Modul auslagern
- IADS-Ziele in MissionGenerator einbinden
- IADS-Zustand persistenzrelevant markieren

Bewertung:

- Noch keine aktive IADS-Kampagnenlogik.
- Skynet bleibt Vendor und wird nicht verändert.

---

## Phase 10: Produktive Framework-Integration

Status:

- noch nicht begonnen

Ziel:

- State-first-Systeme mit realen DCS-/Framework-Aktionen verbinden

Teilziele:

- MOOSE-Spawns für CAP, Strike, SEAD, DEAD und weitere Pakete
- CTLD für Cargo, Crates, FOBs und Logistics Delivery
- Skynet IADS für dynamische Luftverteidigung
- DCS-Events für Missionserfolg, Verluste, Treffer und Capture-Auswertung
- realer AI-Director für Blue und Red

Voraussetzungen:

- State-Systeme stabil
- Persistence Dirty-Hooks implementiert; fachliche Abdeckung weiter validieren
- produktiver Restore sauber definiert
- Mission-Editor-Templates vorhanden
- Naming-Konventionen praktisch geprüft

Bewertung:

- Diese Phase darf erst beginnen, wenn die State-Schicht zuverlässig ist.
- Aktuell bleibt das Projekt bewusst state-first.

---

## Phase 11: Produktiver Restore

Status:

- bewusst noch nicht aktiv

Ziel:

- gespeicherten Kampagnenstand beim Missionsstart automatisch wiederherstellen

Voraussetzungen:

- Capture-, Logistics-, Mission- und AI-Dirty-Markierungen implementiert und fachlich vollständig geprüft
- Save-Datei nach realer State-Änderung geprüft
- Restore-Reihenfolge definiert
- Schutz gegen inkompatible Save-Dateien vorhanden
- produktiver Restore kann eindeutig im Log nachvollzogen werden

Geplanter Ablauf später:

1. Mission startet.
2. PersistenceSystem prüft Sandbox.
3. Save-Datei wird gesucht.
4. Save-Datei wird gelesen.
5. Save-Datei wird validiert.
6. Version und Format werden geprüft.
7. Snapshot wird nur bei kompatiblem Stand importiert.
8. Restore wird eindeutig geloggt.
9. Runtime-Systeme übernehmen restored State.

Noch nicht aktiv:

- automatischer Restore beim Missionsstart
- Restore von realen DCS-Objekten
- Restore von CTLD-FOBs
- Restore von MOOSE-Gruppen
- Restore von Skynet-IADS-Zustand

Bewertung:

- Die technische Importfähigkeit ist bestätigt.
- Produktiver Restore bleibt bewusst gesperrt, bis die blockierten Regressionen bestanden, die Dirty-Abdeckung vollständig geprüft und Restore-Reihenfolge sowie Kompatibilitätsschutz definiert sind.

---

## Phase 12: Dynamische Kampagne

Status:

- Zielphase
- noch nicht erreicht

Ziel:

- Blue und Red agieren eigenständig.
- Spieler nehmen als Teil der laufenden Kampagne teil.
- Kampagnenlage verändert sich durch Missionen, AI, Capture, Logistics, FOBs und IADS.
- Fortschritt bleibt über Missionsstarts hinweg erhalten.

Benötigte Bausteine:

- stabile State-Schicht
- Background-Persistence
- produktiver Restore
- Capture-Hooks
- Logistics-Hooks
- Mission-Hooks
- AI-Hooks
- IADS-Hooks
- DCS-Event-Auswertung
- echte Framework-Aktionen
- Mission-Editor-Templates
- Fehler- und Debugsystem

Bewertung:

- Das Zielbild ist klar.
- Die Grundlage wächst kontrolliert.
- Die aktuelle Arbeit befindet sich noch vor der produktiven Kampagnenphase.

---

## 4. Aktuelle Meilensteine

### Erreicht

- Repository und Dokumentation aufgebaut
- Vendor-Struktur etabliert
- Source-Struktur etabliert
- sichere DCS-Ladefolge etabliert
- Core-Systeme angelegt
- Airbase Scanner bestanden
- ZoneFactory bestanden
- CaptureSystem bestanden
- LogisticsDelivery bestanden
- FobSystem bestanden
- MissionGenerator-Funktionspfade historisch bestanden; aktueller Record-Verlust ungelöst
- AICapManager bestanden
- F10Menu bestanden
- Mission Completion Pipeline bestanden
- Mission Failure Pipeline bestanden
- Capture Ready Apply bestanden
- Persistence File-System-Test bestanden
- Persistence Save-Test bestanden
- Persistence Validation-Test bestanden
- Persistence kontrollierter Import bestanden
- Persistence Background-Autosave bestanden

### Aktueller Meilenstein

- Ursache des reproduzierbaren Mission-Record-Verlusts eingrenzen

### Nächster technischer Meilenstein

- Offline Embedded Mission Resource Audit
- Byte-Längen, SHA-256, Versionen und exakte Gleichheit aller erwarteten eingebetteten Theater-Command-Skripte prüfen
- stale, doppelte, unerwartete oder fehlende Ressourcen melden

---

## 5. Nächster konkreter Schritt

Die gespeicherte DEV-`.miz` offline und read-only auditieren. Vor einem MissionGenerator-Code-Fix muss feststehen, ob die eingebetteten Quellen byte-identisch zum Repository waren.

Akzeptanzkriterien:

- jeder erwartete Trigger und jede Script-Aktion ist mit Resource Key und eingebettetem Dateinamen erfasst
- alle 13 erwarteten Repository-Quellen sind per Byte-Länge, SHA-256, exakter Gleichheit und Version mit der `.miz` verglichen
- veraltete, doppelte, unerwartete und fehlende Ressourcen sind eindeutig ausgewiesen
- die Prüfung bleibt offline und read-only, ohne DCS-/DCS-SMS-Runtime und ohne `.miz`-Änderung
- aus Abweichungen wird keine Ursache ohne Beleg abgeleitet

Erwarteter nächster Test:

1. Gespeicherte DEV-`.miz` offline als Container öffnen.
2. Trigger-zu-Ressource-Mappings inventarisieren.
3. Eingebettete Skripte gegen die 13 Repository-Quellen vergleichen.
4. Hashes, Versionen und stale/duplizierte/unerwartete/fehlende Ressourcen berichten.
5. Erst danach den nächsten Source- oder Mission-Editor-Schritt festlegen.

---

## 6. Was ausdrücklich noch nicht gemacht werden soll

Noch nicht als nächster Schritt:

- Persistence-F10-Menü bauen
- produktiven Restore aktivieren
- echte MOOSE-Spawns einbauen
- echte CTLD-FOBs bauen
- CTLD-Crates produktiv verarbeiten
- Skynet-IADS produktiv anbinden
- AI Director produktiv starten
- automatische Capture-Auswertung mit echten Einheiten erzwingen
- Missionserfolg automatisch aus DCS-Events ableiten
- Loader-only-Variante erzwingen

Begründung:

- Die State-Schicht muss weiter stabilisiert werden.
- Dirty-aware Persistence ist getestet; aktuell muss zuerst der MissionGenerator-Record-Verlust eingegrenzt werden.
- Danach kann produktiver Restore kontrolliert vorbereitet werden.
- Framework-Aktionen kommen erst nach stabiler State- und Persistence-Grundlage.

---

## 7. Bekannte Risiken

### DCS MissionScripting.lua

Für Persistence müssen `io` und `lfs` lokal entsperrt sein.

Risiko:

- DCS-Updates können `MissionScripting.lua` überschreiben.

Folge:

- Persistence kann wieder blockiert werden.

Erwarteter Logmarker bei Problem:

- `io=false`
- `lfs=false`
- `Persistence sandbox blocked`

### Save-Datei-Kompatibilität

Die Save-Datei ist aktuell eine Lua-Return-Datei.

Risiko:

- spätere Strukturänderungen können alte Save-Dateien inkompatibel machen.

Gegenmaßnahme später:

- Save-Versionierung
- Formatprüfung
- Backup/Rotation
- Fallback auf neuen Kampagnenstart

### State-Import-Reihenfolge

Die technische Importfähigkeit ist bestätigt.

Risiko:

- produktiver Restore kann Initialisierungsreihenfolge stören, wenn er zu früh aktiviert wird.

Gegenmaßnahme:

- produktiver Restore bleibt deaktiviert, bis blockierte Regressionen, vollständige Dirty-Abdeckung und Restore-Reihenfolge geklärt sind.

### Framework-Integration

MOOSE, CTLD und Skynet können starke Nebenwirkungen erzeugen, wenn sie zu früh produktiv angebunden werden.

Gegenmaßnahme:

- Framework-Hooks bleiben reserviert.
- Erst State testen.
- Dann Framework-Aktion einzeln anbinden.

---

## 8. Historischer Abschlussstand 2026-07-06

Bestandene Systeme:

| System | Version | Status |
|---|---:|---|
| Airbase Scanner | `v0.2.2` | bestanden |
| ZoneFactory | `v0.2.0` | bestanden |
| CaptureSystem | `v0.2.2` | bestanden |
| LogisticsDelivery | `v0.2.0` | bestanden |
| FobSystem | `v0.2.0` | bestanden |
| MissionGenerator | `v0.2.3` | bestanden |
| AICapManager | `v0.2.0` | bestanden |
| F10Menu | `v0.2.3` | bestanden |
| PersistenceSystem | `v0.2.5` | damaliger Background-Autosave bestanden |

Damals bestätigte Fähigkeiten:

- World State steht.
- Zone State steht.
- Capture State steht.
- Logistics State steht.
- FOB State steht.
- Mission State steht.
- AI CAP State steht.
- F10-Testbed steht.
- Persistence Background Autosave steht.

Damals nächster Meilenstein:

- CaptureSystem Dirty-/Persistence-Hook; inzwischen implementiert und durch PersistenceSystem `v0.2.6` ausgewertet

---

## 9. Startpunkt für die nächste Session

Die nächste Session soll zuerst den aktuellen GitHub-Stand prüfen.

Besonders prüfen:

- `README.md`
- `ROADMAP.md`
- `TASKS.md`
- `CHANGELOG.md`
- `ARCHITECTURE.md`
- `docs/09_persistence.md`
- `docs/10_testing.md`
- `src/campaign/tc_capture_system.lua`
- `src/campaign/tc_persistence_system.lua`
- `src/ui/tc_f10_menu.lua`

Danach nicht aus Erinnerung arbeiten.

Nächster technischer Startpunkt:

- Offline Embedded Mission Resource Audit gemäß `TASKS.md`

---

## Footer

Diese Roadmap ist kein starres Releaseversprechen.

Sie beschreibt die technische Reihenfolge, in der Theater Command DCS stabil wachsen soll.

Aktueller Leitsatz:

- Erst State stabilisieren.
- Dann State persistent machen.
- Dann Restore kontrolliert freischalten.
- Dann Framework-Aktionen produktiv anbinden.
