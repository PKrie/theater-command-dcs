# TASKS.md

Diese Datei ist die operative Aufgabenliste und der wichtigste Übergabepunkt für **Theater Command DCS**.

Neue Sessions sollen zuerst diese Datei lesen und danach den aktuellen GitHub-Stand prüfen, bevor Code geschrieben wird.

---

## 1. Projekt

Projektname:

- Theater Command DCS

Erste Kampagne:

- Operation Levant Reclamation

Map:

- Syria

Ausgangslage:

- Blue startet auf Akrotiri / Zypern.
- Das syrische Festland ist zu Beginn rot kontrolliert.
- Red hält zu Beginn den Großteil der strategischen Flugplätze.
- Blue soll sich vom Brückenkopf Zypern aus auf das syrische Festland vorarbeiten.
- Spieler sollen sich mit Client-Flugzeugen in eine laufende Kampagnenlage einklinken.
- Spieler sollen nicht der einzige Motor der Kampagne sein.
- Blue und Red sollen perspektivisch eigene Operationen durchführen.

Grundprinzip:

- Mission Editor = Bühne
- Lua = Kampagnensystem
- GitHub = Projektgedächtnis

Zielbild:

- dynamische Kampagne auf der Syria Map
- state-first Kampagnensystem
- später persistenter Kampagnenzustand
- Missionen, Capture, Logistics, FOBs, AI, IADS, UI und Persistence sollen zusammenwirken
- echte MOOSE-, CTLD- und Skynet-Integration erst nach stabiler State-Grundlage

---

## 2. Arbeitsweise

Es wird immer nur eine konkrete Aufgabe oder eine Datei pro Schritt bearbeitet.

Bei neuen oder ersetzten Dateien gilt:

- exakten Dateipfad angeben
- vollständigen Dateiinhalt liefern
- genau einen vollständigen zusammenhängenden Codeblock liefern
- passenden Commit-Text angeben
- keine halben Dateien
- keine Fortsetzung in mehreren Blöcken
- keine parallelen Aufgabenlisten
- keine Framework-Dateien verändern

Der Nutzer arbeitet überwiegend über:

- GitHub-Weboberfläche
- GitHub Desktop
- DCS Mission Editor

Wichtig für DCS:

Eine per `DO SCRIPT FILE` geladene Lua-Datei wird in die `.miz` eingebettet.

Nach jeder Lua-Änderung gilt:

1. Datei auf GitHub aktualisieren.
2. Lokal per GitHub Desktop fetchen/pullen.
3. DCS Mission Editor öffnen.
4. Die geänderte Datei in der passenden `DO SCRIPT FILE`-Aktion neu auswählen.
5. Mission speichern.
6. Alte `dcs.log` löschen oder umbenennen.
7. DCS starten.
8. Mission testen.
9. Frische `dcs.log` hochladen oder auswerten.

Für saubere Logtests:

1. DCS beenden.
2. `Saved Games\DCS.openbeta\Logs\dcs.log` oder `Saved Games\DCS\Logs\dcs.log` löschen oder umbenennen.
3. DCS neu starten.
4. Mission testen.
5. DCS beenden.
6. Frische `dcs.log` hochladen.

Ein weitergeführter Log kann nur dann für eine Regression genutzt werden, wenn der neue Abschnitt zeitlich eindeutig vom alten Abschnitt getrennt ist.

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
- Vendor-Dateien werden nicht verändert.
- Eigene Integrationslogik gehört in fachliche Module unter `src/`.

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

- `src/campaign/tc_capture_system.lua` ist aktiv.
- `src/campaign/tc_persistence_system.lua` ist aktiv.
- `src/ui/tc_f10_menu.lua` ist aktiv.
- F10Menu muss nach AI CAP Manager und vor Main geladen werden.
- `src/main.lua` bleibt der Runtime-Startpunkt.
- `src/loader.lua` bleibt aktuell die letzte eigene Datei.
- Starttest-Variante B mit Loader-only-`dofile` ist weiterhin offen.

Aktuelle Entscheidung:

- Bis Variante B praktisch geprüft ist, bleibt die sichere Einzeldatei-Ladung Standard.

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

Stand: 2026-07-06

---

### 6.1 Starttest Variante A

Status:

- bestanden

Bestätigt:

- Vendor-Frameworks laden.
- Theater-Command-Dateien laden.
- Loader erkennt Frameworks.
- Main startet.
- Runtime-Systeme initialisieren.
- Loader beendet sauber.

Offen:

- Starttest Variante B mit Loader-only-`dofile` später prüfen.

---

### 6.2 Airbase Scanner

Datei:

- `src/world/tc_airbase_scanner.lua`

Aktuelle getestete Version:

- `v0.2.2`

Status:

- bestanden

Letzte bestätigte Werte:

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

Bewertung:

- Akrotiri wird korrekt als Blue-Startbasis erkannt.
- Akrotiri wird als `STRATEGIC_AIRFIELD` klassifiziert.
- Syrische Hauptflugplätze werden als Red Strategic Candidates vorbereitet.
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

- bestanden

Letzte bestätigte Werte:

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

- `v0.2.2`

Status:

- bestanden

Letzte bestätigte Startwerte:

- eligibleBases: `32`
- eligibleZones: `32`
- nonCaptureBases: `193`
- nonCaptureZones: `14`
- pressureRecords: `32`
- progressRecords: `32`
- appliedMissionEffects: `0`
- ready: `0`
- contested: `0`

Letzte bestätigte Werte nach Mission Completion:

- completed mission: `MISSION_2`
- target zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- capture pressure owner: `BLUE`
- applied pressure: `105`
- progress: `100%`
- appliedMissionEffects: `1`
- ready: `1`
- contested: `0`

Letzte bestätigte Werte nach Capture Ready Apply:

- captured zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- captured zone owner: `BLUE`
- linked airbase: `Abu al-Duhur`
- linked airbase owner: `BLUE`
- ready danach: `0`
- contested: `0`

Bestätigte Logmarker:

- `[TC] [CaptureSystem] Loaded src/campaign/tc_capture_system.lua v0.2.2`
- `[TC] [CaptureSystem] Capture pressure added: zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE amount=105 progress=100%`
- `[TC] [CaptureSystem] Mission effect applied to capture: mission=MISSION_2 zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE pressure=105`
- `[TC] [CaptureSystem] Completed mission effects processed: applied=1, skipped=0, failed=0, appliedMissionEffects=1`
- `[TC] [CaptureSystem] Zone captured: ZONE_AIRBASE_ABU_AL_DUHUR [BLUE]`
- `[TC] [CaptureSystem] Base captured: Abu al-Duhur [BLUE]`

Bewertung:

- CaptureSystem ist state-first stabil.
- Mission Effects können Capture Pressure erzeugen.
- Capture Ready kann state-only angewendet werden.
- Zone Ownership und Airbase Ownership können state-only synchronisiert werden.
- Produktive automatische Capture-Auswertung über reale DCS-Zonen ist noch offen.

Offen:

- Dirty-Markierungen nach Capture-Änderungen sind im Code bereits vorhanden; die dirty-aware Autosave-Auswertung ist noch offen
- automatische Auswertung realer Einheiten in Capture-Zonen
- Ownership-Wechsel später an Logistics, AI, Mission Generator und IADS koppeln
- Capture-Progress langfristig über echte DCS-Ereignisse beeinflussen

---

### 6.5 Logistics Delivery

Datei:

- `src/logistics/tc_logistics_delivery.lua`

Aktuelle getestete Version:

- `v0.2.0`

Status:

- bestanden

Letzte bestätigte Werte:

- logistics hubs: `46`
- blue hubs: `7`
- red hubs: `24`
- neutral hubs: `15`
- active hubs: `31`
- limited hubs: `15`
- locked hubs: `0`

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

- bestanden

Letzte bestätigte Werte:

- FOB candidates: `6`
- stored candidates: `6`
- auto-planned FOBs: `2`
- skipped candidates: `4`

Erzeugte FOBs:

- `FOB Ercan`
- `FOB Gecitkale`

Status der erzeugten FOBs:

- `UNDER_CONSTRUCTION`

Weitere Werte:

- Blue FOBs: `2`

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

- `v0.2.3`

Status:

- bestanden

Letzte bestätigte Werte:

- mission candidates: `78`
- fobSupportCandidates: `2`
- generated missions: `10`
- reservedCreated: `1`
- duplicatesSkipped: `1`
- typeLimitSkipped: `68`

Bestätigte Missionslogik:

- FOB-Support wird nicht aus der verfügbaren Missionsliste verdrängt.
- Mindestens eine FOB-Support-Mission wird reserviert erzeugt.
- Mission Records enthalten Objectives.
- Mission Records enthalten Briefings.
- Mission Records enthalten Progress-Daten.
- Mission Records enthalten Activation Metadata.
- Mission Records enthalten Outcome-Daten.
- Mission Records enthalten Effect-State-Daten.
- Mission Records enthalten reservierte Execution Hooks für MOOSE, CTLD und Skynet.
- Aktivierte Missionen bleiben `stateOnly=true`.
- Spawn-Hooks bleiben `reserved`.
- Missionen können state-only auf `COMPLETED` gesetzt werden.
- Missionen können state-only auf `FAILED` gesetzt werden.
- Missionseffekte werden state-only vorbereitet.
- vorbereitete Mission Effects können von `CaptureSystem v0.2.2` verarbeitet werden.

Bestätigte F10-/MissionGenerator-Interaktion:

- Mission Details Slot 1 bestätigt.
- Mission Slot 1 aktiviert.
- MissionGenerator setzt Mission Slot 1 auf `ACTIVE`.
- Aktivierung erzeugt `stateOnly=true`.
- Aktivierung erzeugt `spawnHooks=reserved`.
- aktive Mission 1 wurde über F10 auf `COMPLETED` gesetzt.
- aktive Mission 1 wurde über F10 auf `FAILED` gesetzt.
- MissionGenerator erzeugt `Mission effects prepared state-only`.
- MissionGenerator erzeugt `Mission outcome prepared`.
- Outcome bleibt `stateOnly=true`.
- Effects bleiben zunächst `prepared`, werden danach vom CaptureSystem state-only übernommen.

Bewertung:

- MissionGenerator `v0.2.3` ist bestanden.
- Missionsaktivierung ist stabil.
- Mission Completion ist state-only praktisch getestet.
- Mission Failure ist state-only praktisch getestet.
- Mission Effects werden vorbereitet und können vom CaptureSystem verarbeitet werden.
- Failed Missions erzeugen aktuell bewusst keinen Capture Pressure.
- Es werden weiterhin keine echten DCS-Spawns ausgelöst.

Offen:

- Mission `CANCELLED` und `EXPIRED` später testbar machen
- Missionseffekte praktisch auf Logistics, AI und IADS anwenden
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

- bestanden

Letzte bestätigte Werte:

- cap zone candidates: `31`
- auto-registered CAP zones: `12`
- CAP requests: `12`
- reactionState: `AIR_REACTION_REQUESTED`
- threatLevel: `HIGH`

Bewertung:

- AI CAP Manager bereitet Blue- und Red-CAP-Bedarf als State vor.
- Echter MOOSE-Spawn ist noch nicht aktiv.
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

- `v0.2.3`

Status:

- bestanden

Bestätigt im Test vom 2026-07-06:

- F10Menu lädt als `v0.2.3`.
- F10-Menü initialisiert sauber.
- `33` Commands wurden erzeugt.
- `Show Available Missions` funktioniert.
- `Show Mission 1 Details` funktioniert.
- `Activate Mission 1` funktioniert.
- `Show Active Missions` funktioniert.
- `Show Active Mission Outcome Status` funktioniert.
- `Complete Active Mission 1` funktioniert.
- `Fail Active Mission 1` funktioniert.
- `Show Capture Status` funktioniert.
- `Show Capture Ready Zones` funktioniert.
- `Apply Capture Ready Zone 1` funktioniert.
- `Show Pressure Contested Zones` funktioniert.
- Mission Outcome wird auf `COMPLETED` gesetzt.
- Mission Outcome wird auf `FAILED` gesetzt.
- Mission Effects werden state-only vorbereitet.
- Mission Effects werden durch CaptureSystem v0.2.2 state-only in Capture Pressure übernommen.
- Capture Ready wird über F10 sichtbar.
- Capture Ready Zone 1 wird bewusst über F10 angewendet.
- Zone Ownership wird state-only aktualisiert.
- Linked Airbase Ownership wird state-only synchronisiert.
- Capture Pressure wird nach erfolgreichem Capture Apply zurückgesetzt.
- Mission Activation bleibt `stateOnly=true`.
- Spawn-Hooks bleiben `reserved`.
- Keine Lua-Scripting-Fehler.
- Keine Theater-Command-Fehler.
- Keine echten MOOSE-Spawns.
- Keine echten CTLD-Aktionen.
- Keine echten Skynet-Aktionen.
- Keine Persistence-F10-Aktionen, weil Persistenz im Hintergrund laufen soll.

Aktuelle F10-Funktionen:

- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Mission 1 bis Mission 10 Details anzeigen
- Mission 1 bis Mission 10 aktivieren
- Mission Outcome Status anzeigen
- aktive Mission 1 auf `COMPLETED` setzen
- aktive Mission 1 auf `FAILED` setzen
- Kampagnenstatus anzeigen
- Capture-/Pressure-Status anzeigen
- Capture Ready Zones anzeigen
- Capture Ready Zone 1 bewusst anwenden
- Pressure Contested Zones anzeigen
- Logistikstatus anzeigen
- FOB-Status anzeigen

Bewertung:

- F10Menu ist als Test- und Bedienoberfläche für Kampagnenfunktionen stabil.
- Persistence gehört nicht ins Spieler-F10-Menü.
- Persistence läuft im Hintergrund.

Offen:

- Mission Outcome für Slots 2 bis 10 später ergänzen
- Cancel/Expire testbar machen
- F10-Menü später zwischen Spieler-UI und Admin-/Debug-UI trennen
- Spielerseitige Menüs später vereinfachen

---

### 6.10 Persistence System

Datei:

- `src/campaign/tc_persistence_system.lua`

Aktuelle getestete Version:

- `v0.2.5`

Status:

- bestanden

Lokale Voraussetzung:

- In `...\DCS World\Scripts\MissionScripting.lua` müssen `io` und `lfs` für dieses Projekt entsperrt sein.
- `os` bleibt bewusst gesperrt.
- `require` bleibt bewusst gesperrt.
- Nach DCS-Updates kann diese lokale Änderung überschrieben werden.

Aktueller bestätigter Sandbox-Status:

- `os=false`
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

Bestätigter technischer Verlauf:

- `v0.2.0`: Sandbox-Verfügbarkeit geprüft, zunächst blockiert.
- `v0.2.1`: Schreib-/Lesetest korrigiert und bestanden.
- `v0.2.2`: Campaign-State-Snapshot als Datei geschrieben.
- `v0.2.3`: Save-Datei gelesen, kompiliert, evaluiert und validiert.
- `v0.2.4`: Save-Datei kontrolliert in `TC.State` importiert.
- `v0.2.5`: Test-Timer-Kaskade entfernt und Background-Autosave aktiviert.

Bestätigte Logmarker aus `v0.2.5`:

- `Loaded src/campaign/tc_persistence_system.lua v0.2.5`
- `Persistence sandbox file test passed`
- `Persistence autosave scheduled: initialDelay=20s interval=120s productiveRestore=false`
- `Persistence system initialized: sandboxStatus=PASSED, fileSystemAvailable=true, autosaveScheduled=true, autosaveInterval=120s, productiveRestore=false`
- `Campaign state autosaved`
- `autosaveCount=1`

Nicht mehr vorhandene alte Testmarker:

- `Persistence file save test scheduled`
- `Persistence file validation test scheduled`
- `Persistence file load test scheduled`
- `Campaign state file load test passed`

Bewertung:

- Persistence ist jetzt ein internes Hintergrundsystem.
- Spieler müssen Persistenz nicht über F10 bedienen.
- Autosave startet automatisch nach Missionsstart.
- Autosave-Intervall beträgt aktuell 120 Sekunden.
- Save/Validate/Load-Funktionen bleiben intern vorhanden.
- Produktiver automatischer Restore beim Missionsstart ist noch deaktiviert.
- Dirty-Markierungen sind in CaptureSystem und weiteren aktiven State-Systemen bereits vorhanden.
- Periodischer Autosave wertet den Dirty-State aktuell noch nicht aus und schreibt deshalb auch unveränderte Zustände.

Offen:

- periodischen Autosave in `tc_persistence_system.lua` dirty-aware machen
- Dirty-State nach fehlgeschlagenem Save beibehalten
- Dirty-State erst nach verifiziert erfolgreichem Save löschen
- Saved-/Skipped-/Failed-Ergebnisse inklusive Dirty Reason eindeutig loggen
- produktiven Restore bewusst erst nach dirty-aware Autosave-Tests aktivieren
- Save-Dateiformat langfristig versionieren
- Backup-/Rotationsstrategie für Save-Dateien definieren
- Schutz gegen veraltete oder inkompatible Save-Dateien ergänzen

---

## 7. Aktuell bestätigte End-to-End-Fähigkeiten

### 7.1 Mission Completion zu Capture Pressure

Bestanden:

1. Mission Details über F10 anzeigen.
2. Mission 1 über F10 aktivieren.
3. Active Mission 1 über F10 auf `COMPLETED` setzen.
4. MissionGenerator bereitet Effects state-only vor.
5. CaptureSystem verarbeitet Mission Effects.
6. CaptureSystem erzeugt Capture Pressure.
7. Capture Progress erreicht 100 %.
8. Capture Ready wird erzeugt.
9. Capture Ready Zones werden über F10 angezeigt.

Status:

- bestanden
- state-only
- keine echten DCS-Spawns
- keine echten CTLD-Aktionen
- keine echten Skynet-Aktionen

---

### 7.2 Capture Ready Apply

Bestanden:

1. Capture Ready Zone 1 über F10 anwenden.
2. Zone Ownership state-only auf `BLUE` setzen.
3. Linked Airbase Ownership state-only auf `BLUE` setzen.
4. Capture Pressure zurücksetzen.
5. Capture Ready auf 0 zurücksetzen.

Status:

- bestanden
- state-only
- noch nicht automatisch
- Dirty-Markierungen im CaptureSystem vorhanden
- dirty-aware Autosave-Auswertung noch nicht getestet

---

### 7.3 Mission Failure

Bestanden:

1. Mission Details über F10 anzeigen.
2. Mission 1 über F10 aktivieren.
3. Active Mission 1 über F10 auf `FAILED` setzen.
4. MissionGenerator setzt Outcome auf `FAILED`.
5. MissionGenerator bereitet Failure Effects state-only vor.
6. CaptureSystem verarbeitet abgeschlossene Mission Effects.
7. CaptureSystem erzeugt bei `FAILED` aktuell keinen Capture Pressure.

Status:

- bestanden
- state-only
- erwartetes Verhalten

---

### 7.4 Persistence Background Autosave

Bestanden:

1. PersistenceSystem startet.
2. Sandbox-Test prüft `io/lfs/load`.
3. File-System wird als verfügbar bestätigt.
4. Autosave wird automatisch geplant.
5. Campaign-State wird nach 20 Sekunden automatisch gespeichert.
6. Autosave läuft ohne Spieler-F10-Aktion.
7. Produktiver Restore bleibt deaktiviert.

Status:

- bestanden
- Hintergrundsystem
- keine Spieleraktion nötig
- `productiveRestore=false`

---

## 8. Aktuelle Einschränkungen

Das Projekt ist weiterhin keine fertige spielbare dynamische Kampagne.

Noch nicht produktiv umgesetzt:

- echte MOOSE-Spawns
- echte CTLD-Logistikaktionen
- echte CTLD-FOBs
- echte CTLD-Crates
- echte Skynet-IADS-Kampagnenlogik
- produktive AI-Director-Entscheidungen
- automatische Missionserfolgserkennung über DCS-Events
- automatische Capture-Auswertung über reale Einheiten/Zonen
- produktiver automatischer Restore beim Missionsstart
- dirty-aware Autosave-Auswertung und eindeutige Saved-/Skipped-/Failed-Diagnostik
- echte Blue-/Red-KI-Kampagnenoperationen

---

## 9. Wichtigste offene Aufgaben

### Priorität 1: Periodischen Autosave dirty-aware machen

Datei:

- `src/campaign/tc_persistence_system.lua`

Aktueller Befund:

- `TC.State.markDirty()` verwaltet bereits `dirty`, `dirtyReason` und `dirtyAt`.
- CaptureSystem und weitere aktive State-Systeme markieren relevante Änderungen bereits dirty.
- Der periodische Autosave prüft den Dirty-State aktuell nicht und schreibt bei jedem Tick.

Ziel:

- Periodischer Autosave speichert nur, wenn der Kampagnenzustand dirty ist.
- Unveränderte periodische Autosave-Ticks werden ohne Dateischreibvorgang übersprungen.
- Nach einem fehlgeschlagenen Save bleibt der Kampagnenzustand dirty.
- Dirty-State wird erst nach einem verifiziert erfolgreichen Save gelöscht.
- Der beim Autosave vorliegende Dirty Reason wird eindeutig geloggt.
- Jeder periodische Autosave-Tick loggt klar, ob er gespeichert, übersprungen oder fehlgeschlagen ist.
- Kein F10-Persistence-Menü.
- Keine Spieleraktion für Save/Load.
- Kein produktiver Restore.
- Keine echten MOOSE-, CTLD- oder Skynet-Runtime-Aktionen.
- Weiterhin state-first und als interner Hintergrunddienst.

Akzeptanzkriterien:

- `PersistenceSystem` lädt und startet sauber.
- Die bestehende Autosave-Planung mit initialem Delay und periodischem Intervall bleibt funktionsfähig.
- Mission Completion Pipeline bleibt stabil.
- Mission Failure Pipeline bleibt stabil.
- Capture Ready Apply bleibt stabil.
- Ein periodischer Tick mit `dirty=true` schreibt und verifiziert die Campaign-Save-Datei.
- Das Save-Log enthält den Dirty Reason und kennzeichnet das Ergebnis eindeutig als gespeichert.
- Nach dem verifiziert erfolgreichen Save ist `dirty=false`.
- Ein nachfolgender Tick ohne State-Änderung schreibt keine Datei und wird eindeutig als übersprungen geloggt.
- Ein absichtlich herbeigeführter Save-Fehler wird eindeutig als fehlgeschlagen geloggt.
- Nach einem fehlgeschlagenen Save bleiben `dirty=true`, `dirtyReason` und die zu sichernde State-Änderung erhalten.
- Nach Wiederherstellung des Dateizugriffs kann ein späterer Tick denselben Dirty-State erfolgreich speichern und erst dann löschen.
- `productiveRestore=false` bleibt unverändert.
- Es werden keine Persistence-F10-Controls hinzugefügt.
- Kein `SCRIPTING ERROR`.
- Kein `Mission script error`.
- Kein `stack traceback`.
- Kein `[TC][ERROR]`.
- Keine echten MOOSE-Spawns.
- Keine CTLD-Aktion.
- Keine Skynet-Aktion.

Erwarteter Testablauf:

1. Mission starten.
2. Mission über F10 aktivieren.
3. Mission über F10 abschließen.
4. Capture Ready Zone 1 über F10 anwenden.
5. Vor dem nächsten Autosave-Tick `dirty=true` und den gesetzten `dirtyReason` bestätigen.
6. Nächsten periodischen Autosave-Tick abwarten.
7. Log bestätigt einen gespeicherten Autosave inklusive Dirty Reason.
8. Save-Datei prüfen und `dirty=false` nach erfolgreicher Schreib-/Leseverifikation bestätigen.
9. Ohne weitere State-Änderung den folgenden periodischen Tick abwarten.
10. Log bestätigt einen übersprungenen Autosave; die Save-Datei wird nicht erneut geschrieben.
11. State kontrolliert erneut dirty markieren und für den Test einen kontrollierten Dateischreibfehler herstellen.
12. Nächsten periodischen Autosave-Tick abwarten.
13. Log bestätigt einen fehlgeschlagenen Autosave inklusive Dirty Reason und Fehlergrund.
14. Bestätigen, dass `dirty=true` und `dirtyReason` nach dem Fehler erhalten bleiben.
15. Dateizugriff wiederherstellen und den nächsten periodischen Tick abwarten.
16. Log und Save-Datei bestätigen den erfolgreichen Retry; erst danach ist `dirty=false`.
17. Gesamten neuen `dcs.log` auf Theater-Command- und Lua-Fehler prüfen.

---

### Priorität 2: Persistence Restore später produktiv vorbereiten

Datei:

- `src/campaign/tc_persistence_system.lua`

Status:

- noch nicht freischalten

Voraussetzungen:

- dirty-aware Autosave mit Saved-/Skipped-/Failed-Pfaden erfolgreich getestet
- Save-Datei nach echter State-Änderung geprüft
- keine Regression beim Autosave
- klares Restore-Verhalten bei veralteten Save-Dateien definiert

Ziel später:

- beim Missionsstart vorhandene Save-Datei prüfen
- Save-Datei validieren
- Save-Datei nur bei kompatibler Version importieren
- produktiven Restore eindeutig loggen
- Restore darf keine Initialisierung zerstören

Noch nicht jetzt aktivieren.

---

### Priorität 3: Dirty-Abdeckung der aktiven State-Systeme validieren

Dateien später:

- `src/logistics/tc_logistics_delivery.lua`
- `src/logistics/tc_fob_system.lua`
- `src/missions/tc_mission_generator.lua`
- `src/ai/tc_ai_cap_manager.lua`

Ziele:

- vorhandene Dirty-Markierungen auf fachlich relevante State-Änderungen prüfen
- fehlende oder zu häufige Dirty-Markierungen gezielt korrigieren
- Dirty Reasons pro Fachsystem eindeutig und stabil halten
- spätere echte Supply-, Missions- und AI-Änderungen persistenzrelevant behandeln

Voraussetzung:

- dirty-aware Autosave in `tc_persistence_system.lua` bestanden

---

### Priorität 4: CTLD-Integration vorbereiten

Ziele:

- CTLD-Zonen im Mission Editor anlegen
- Pickup-/Dropoff-Zonen definieren
- Cargo-/Crate-Typen für Theater Command festlegen
- CTLD-Events später in Logistics und FOB-System überführen

Noch nicht direkt als nächster Schritt.

---

### Priorität 5: MOOSE AI-Spawns vorbereiten

Ziele:

- MOOSE CAP Templates im Mission Editor anlegen
- Blue/Red CAP Templates benennen
- Spawn-Zonen prüfen
- AICapManager mit echten MOOSE-Spawns verbinden

Noch nicht direkt als nächster Schritt.

---

### Priorität 6: IADS vorbereiten

Ziele:

- Skynet-IADS-Struktur einführen
- SAM-/EWR-Gruppen im Mission Editor sauber benennen
- IADS-Zustand später persistieren
- Missionen gegen IADS-Ziele erzeugen

Noch nicht direkt als nächster Schritt.

---

## 10. Bekannte DCS-/Log-Hinweise

Folgende Meldungen sind aktuell nicht als Theater-Command-Fehler zu werten, solange keine `[TC][ERROR]`, kein `SCRIPTING ERROR`, kein `Mission script error`, kein `stack traceback` und kein `attempt to` im Theater-Command-Kontext auftreten:

- `DTC_MANAGER Window pointer is null`
- `LUA-TERRAIN getObjectPosition`
- `DX11BACKEND ... render target ... not found`
- `INVALID ATC`
- `ModelTimeQuantizer`
- `Destruction shape not found`
- negative drag / weapon drag warnings

Wichtige Fehlerindikatoren:

- `[TC][ERROR]`
- `SCRIPTING ERROR`
- `Mission script error`
- `stack traceback`
- `attempt to index`
- `attempt to call`
- `nil value`
- `protected call failed`

---

## 11. Aktueller Abschlussstand

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
| PersistenceSystem | `v0.2.5` | bestanden |

Aktuelle bestätigte Fähigkeiten:

- Syria-Airbase-Scan funktioniert.
- Kampagnenzonen werden korrekt state-only erzeugt.
- Capture-System erzeugt Druck und Ready-Status.
- Mission Generator erzeugt 10 Missionen mit reservierten Hooks.
- F10Menu erlaubt Mission Details, Activation, Completion, Failure und Capture Ready Apply.
- Mission Completion kann Capture Pressure erzeugen.
- Mission Failure bleibt ohne Capture Pressure.
- Capture Ready Apply kann Zone und Airbase state-only auf Blue setzen.
- Persistence kann DCS-Dateien schreiben und lesen.
- Persistence speichert Campaign-State als Lua-Return-Datei.
- Persistence validiert Save-Dateien.
- Persistence kann Save-Dateien kontrolliert importieren.
- Persistence läuft jetzt als Background-Autosave-Service.
- Spieler müssen Persistence nicht über F10 bedienen.

Aktuelle wichtigste offene Fähigkeit:

- Periodischer Autosave muss vorhandene Dirty-Markierungen auswerten, unveränderte Ticks überspringen und Dirty-State erst nach verifiziert erfolgreichem Save löschen.

---

## 12. Startpunkt für die nächste Session

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

Danach nicht mit F10-Persistence weitermachen.

Nächster technischer Schritt:

- `src/campaign/tc_persistence_system.lua`

Konkretes Ziel:

- periodischen Autosave dirty-aware machen
- bei `dirty=true` speichern und Dirty Reason loggen
- bei unverändertem State den Autosave-Tick klar geloggt überspringen
- bei Save-Fehler Dirty-State und Dirty Reason beibehalten
- Dirty-State erst nach verifiziert erfolgreichem Save löschen
- kein produktiver Restore
- kein Persistence-F10-Menü
- keine echten MOOSE-/CTLD-/Skynet-Aktionen

Nächster erwarteter Test:

1. Mission über F10 aktivieren.
2. Mission über F10 abschließen.
3. Capture Ready Zone 1 über F10 anwenden.
4. Dirty-State und Dirty Reason vor dem Autosave bestätigen.
5. Periodischer Autosave speichert und verifiziert den geänderten State.
6. Folgender unveränderter Tick wird ohne Dateischreibvorgang übersprungen.
7. Kontrollierter Save-Fehler behält Dirty-State und Dirty Reason bei.
8. Erfolgreicher Retry speichert den State und löscht Dirty erst danach.
9. DCS-Log wird auf Saved-/Skipped-/Failed-Marker und Fehler geprüft.

---

## Footer

Diese Datei ist der operative Übergabepunkt.

Bei Unsicherheit gilt:

1. Erst GitHub lesen.
2. Dann den letzten bestätigten DCS-Logstand beachten.
3. Dann nur eine Datei oder eine konkrete Aufgabe bearbeiten.
4. Keine Framework-Dateien verändern.
5. Keine All-in-one-Lua-Dateien erstellen.
