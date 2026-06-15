# Tasks

Diese Datei enthält die aktuellen Aufgaben für das Projekt **Theater Command DCS**.

Ziel ist, das Projekt Schritt für Schritt aufzubauen und nicht mehrere große Baustellen gleichzeitig zu beginnen.

---

## Aktueller Projektstand

Projektname:

**Theater Command DCS**

Erste Kampagne:

**Operation Levant Reclamation**

Aktueller Stand:

- GitHub-Repository ist erstellt.
- Grunddokumentation ist erstellt.
- `docs/`-Grundblock ist erstellt.
- `vendor/`-Grundstruktur ist erstellt.
- Vendor-README-Dateien für MIST, MOOSE, CTLD und Skynet IADS sind erstellt.
- MIST wurde als erstes Framework lokal im Repository hinterlegt.
- MIST liegt als stabile Projektdatei unter `vendor/mist/mist.lua`.
- MIST-Handbuch und Beispiel-Datenbanken wurden unter `vendor/mist/` abgelegt.
- Die eigentliche Theater-Command-Lua-Struktur unter `src/` ist noch nicht begonnen.

Aktuelle Phase:

**Phase 0 — Projektgrundlage und Vendor-Vorbereitung**

Nächster Fokus:

1. `TASKS.md` sauber aktualisieren
2. MIST-Ordner auf saubere Struktur prüfen
3. danach entweder weitere Frameworks hinterlegen oder mit `src/README.md` beginnen

---

## Grundregel für die Arbeit

Es wird immer nur ein sinnvoller Schritt nach dem anderen umgesetzt.

Keine parallelen Großbaustellen.

Jede neue Datei wird vollständig vorbereitet.

Eigene Theater-Command-Logik gehört nach `src/`.

Externe Frameworks gehören nach `vendor/` und werden nicht verändert.

---

## Phase 0 — GitHub-Grundstruktur

### Repository-Grunddateien

- [x] GitHub-Repository `theater-command-dcs` erstellen
- [x] `README.md` anlegen
- [x] `ROADMAP.md` anlegen
- [x] `TASKS.md` anlegen
- [x] `CHANGELOG.md` anlegen
- [x] `ARCHITECTURE.md` anlegen
- [x] `MISSION_EDITOR_SETUP.md` anlegen
- [x] `NAMING_CONVENTIONS.md` anlegen
- [x] `LUA_STYLEGUIDE.md` anlegen
- [x] `.gitignore` anlegen

---

## Phase 0 — Dokumentationsordner

### Docs-Grundblock

- [x] `docs/00_project_overview.md`
- [x] `docs/01_campaign_design.md`
- [x] `docs/02_technical_architecture.md`
- [x] `docs/03_mission_editor_basics.md`
- [x] `docs/04_airbase_system.md`
- [x] `docs/05_logistics_system.md`
- [x] `docs/06_mission_generator.md`
- [x] `docs/07_ai_director.md`
- [x] `docs/08_iads_system.md`
- [x] `docs/09_persistence.md`
- [x] `docs/10_testing.md`

---

## Phase 0 — Hauptordner vorbereiten

Folgende Hauptordner sind für das Projekt vorgesehen:

- [x] `docs/`
- [x] `vendor/`
- [ ] `src/`
- [ ] `mission/`
- [ ] `mission_editor/`
- [ ] `assets/`
- [ ] `save/`
- [ ] `tools/`

---

## Phase 0 — Vendor-Grundstruktur

Externe Frameworks werden im Ordner `vendor/` abgelegt.

Sie werden nicht verändert.

Eigene Theater-Command-Logik wird nicht in `vendor/` geschrieben.

### Vendor-Ordner

- [x] `vendor/README.md`
- [x] `vendor/mist/`
- [x] `vendor/moose/`
- [x] `vendor/ctld/`
- [x] `vendor/skynet-iads/`

### Vendor-README-Dateien

- [x] `vendor/mist/README.md`
- [x] `vendor/moose/README.md`
- [x] `vendor/ctld/README.md`
- [x] `vendor/skynet-iads/README.md`

---

## Phase 0 — MIST-Import

MIST ist das erste tatsächlich hinterlegte externe Framework.

### MIST-Dateien

- [x] `vendor/mist/mist.lua` hinterlegen
- [x] `vendor/mist/Mist guide.pdf` hinterlegen
- [x] `vendor/mist/Example_DBs/` anlegen
- [x] MIST-Beispiel-Datenbanken unter `vendor/mist/Example_DBs/` hinterlegen
- [x] `vendor/mist/README.md` nach Framework-Import aktualisieren
- [x] stabilen Projektnamen `vendor/mist/mist.lua` festlegen

### MIST-Version

Aktuell dokumentiert:

- [x] MIST-Version intern geprüft
- [x] MIST-Version in `vendor/mist/README.md` dokumentiert

Aktuelle interne MIST-Version:

    4.5.125

Hinweis:

Die ursprünglich genannte Datei war `mist_4_5_126.lua`.

Für das Projekt soll die aktive Framework-Datei dauerhaft so heißen:

    vendor/mist/mist.lua

### MIST-Nachprüfung

- [ ] prüfen, ob im GitHub-Browser wirklich nur eine aktive MIST-Hauptdatei genutzt wird
- [ ] falls zusätzlich noch `vendor/mist/mist_4_5_126.lua` vorhanden ist, diese nach Sichtprüfung entfernen
- [ ] prüfen, ob `vendor/mist/README.md` im GitHub-Browser sauber mehrzeilig formatiert ist
- [ ] prüfen, ob `vendor/mist/README.md` keine veralteten Hinweise mehr enthält

---

## Phase 0 — Weitere Frameworks hinterlegen

Nach MIST sollen die weiteren externen Frameworks ergänzt werden.

Immer nur ein Framework pro Schritt.

### MOOSE

- [ ] offizielle MOOSE-Datei herunterladen
- [ ] MOOSE-Hauptdatei unter `vendor/moose/Moose.lua` hinterlegen
- [ ] `vendor/moose/README.md` mit Version, Quelle und Datum aktualisieren
- [ ] prüfen, ob lokale Änderungen an MOOSE vermieden wurden

### CTLD

- [ ] offizielle CTLD-Dateien herunterladen
- [ ] `vendor/ctld/CTLD-i18n.lua` hinterlegen
- [ ] `vendor/ctld/CTLD.lua` hinterlegen
- [ ] `vendor/ctld/README.md` mit Version, Quelle und Datum aktualisieren
- [ ] prüfen, ob lokale Änderungen an CTLD vermieden wurden

### Skynet IADS

- [ ] offizielle Skynet-IADS-Datei herunterladen
- [ ] `vendor/skynet-iads/SkynetIADS.lua` hinterlegen
- [ ] `vendor/skynet-iads/README.md` mit Version, Quelle und Datum aktualisieren
- [ ] prüfen, ob lokale Änderungen an Skynet IADS vermieden wurden

---

## Phase 0 — Lua-Quellstruktur vorbereiten

Eigene Theater-Command-Logik gehört nach `src/`.

Die Struktur wird nach Aufgaben sortiert, nicht nach Frameworks.

### Src-Grundstruktur

- [ ] `src/README.md`
- [ ] `src/loader.lua`
- [ ] `src/main.lua`
- [ ] `src/core/`
- [ ] `src/world/`
- [ ] `src/campaign/`
- [ ] `src/logistics/`
- [ ] `src/missions/`
- [ ] `src/ai/`
- [ ] `src/iads/`
- [ ] `src/ui/`
- [ ] `src/debug/`

### Src-README-Dateien

- [ ] `src/core/README.md`
- [ ] `src/world/README.md`
- [ ] `src/campaign/README.md`
- [ ] `src/logistics/README.md`
- [ ] `src/missions/README.md`
- [ ] `src/ai/README.md`
- [ ] `src/iads/README.md`
- [ ] `src/ui/README.md`
- [ ] `src/debug/README.md`

---

## Phase 0 — Erste Lua-Basisdateien

Diese Dateien bilden später die technische Grundlage von Theater Command DCS.

### Core

- [ ] `src/core/tc_config.lua`
- [ ] `src/core/tc_logger.lua`
- [ ] `src/core/tc_state.lua`
- [ ] `src/core/tc_utils.lua`
- [ ] `src/core/tc_scheduler.lua`

### Loader

- [ ] `src/loader.lua`
- [ ] `src/main.lua`

### Loader-Aufgaben

- [ ] globale `TC`-Tabelle initialisieren
- [ ] Lade-Reihenfolge definieren
- [ ] Framework-Verfügbarkeit prüfen
- [ ] Core-Dateien laden
- [ ] Debug-Ausgabe beim Start vorbereiten
- [ ] Fehlerausgabe für fehlende Frameworks vorbereiten

---

## Phase 1 — Airbase-System

Das Airbase-System wird die erste große eigene Theater-Command-Funktion.

### Ziel

DCS-Airbases auf der Syria Map automatisch erkennen und in eigene Theater-Command-Strukturen überführen.

### Geplante Dateien

- [ ] `src/world/tc_airbase_scanner.lua`
- [ ] `src/world/tc_airbase_registry.lua`
- [ ] `src/world/tc_airbase_debug.lua`

### Aufgaben

- [ ] Airbase-Scanner bauen
- [ ] Airbase-Debugausgabe bauen
- [ ] Akrotiri erkennen
- [ ] Khmeimim erkennen
- [ ] alle Airbases der Syria Map auflisten
- [ ] BaseNodes erzeugen
- [ ] Airbase-Koalitionsstatus erfassen
- [ ] Airbase-Daten für Capture-System vorbereiten

---

## Phase 1 — Zonen-System

Virtuelle Zonen sollen später aus Basen und Kampagnenlogik erzeugt werden.

### Geplante Dateien

- [ ] `src/world/tc_zone_factory.lua`
- [ ] `src/world/tc_zone_registry.lua`
- [ ] `src/debug/tc_debug_zones.lua`

### Aufgaben

- [ ] virtuelle Capture-Zonen erzeugen
- [ ] virtuelle Logistik-Zonen erzeugen
- [ ] virtuelle Defense-Zonen erzeugen
- [ ] Debug-Anzeige für Zonen vorbereiten
- [ ] Zonen mit Airbases verknüpfen
- [ ] Zonen für spätere Missionen nutzbar machen

---

## Phase 1 — Capture-System

Das Capture-System steuert später den Besitz von Basen und Zonen.

### Geplante Dateien

- [ ] `src/campaign/tc_capture_system.lua`
- [ ] `src/campaign/tc_base_ownership.lua`
- [ ] `src/campaign/tc_campaign_state.lua`

### Aufgaben

- [ ] Besitzerstatus für Basen vorbereiten
- [ ] Besitzerstatus für Zonen vorbereiten
- [ ] Blau/Rot/Neutral-Status definieren
- [ ] Capture-Bedingungen definieren
- [ ] Capture-Debugausgabe vorbereiten
- [ ] Verbindung zum Airbase-System vorbereiten
- [ ] Verbindung zum Logistiksystem vorbereiten

---

## Phase 1 — Logistics und CTLD-Anbindung

CTLD übernimmt technische Transportfunktionen.

Theater Command DCS entscheidet über die kampagnenlogische Wirkung.

### Geplante Dateien

- [ ] `src/logistics/tc_logistics_delivery.lua`
- [ ] `src/logistics/tc_fob_system.lua`
- [ ] `src/logistics/tc_logistics_state.lua`
- [ ] `src/ui/tc_f10_menu.lua`

### Aufgaben

- [ ] CTLD-Grundkonfiguration vorbereiten
- [ ] Akrotiri als Start-Logistikhub definieren
- [ ] erste Pickup-Zonen für Akrotiri vorbereiten
- [ ] erste Dropoff-Zonen vorbereiten
- [ ] Logistiklieferungen kampagnenlogisch auswerten
- [ ] CTLD-Lieferungen mit Theater Command verbinden
- [ ] FOB-System vorbereiten

---

## Phase 1 — Missionsgenerator

Der Missionsgenerator erzeugt später dynamische Aufgaben abhängig vom Kampagnenzustand.

### Geplante Dateien

- [ ] `src/missions/tc_mission_generator.lua`
- [ ] `src/missions/tc_mission_registry.lua`
- [ ] `src/missions/tc_mission_types.lua`

### Aufgaben

- [ ] Spielerflugzeug erkennen
- [ ] Missionen nach Flugzeugtyp filtern
- [ ] erste einfache Missionsliste über F10 anzeigen
- [ ] Airbase-Ziele aus Kampagnenzustand ableiten
- [ ] SEAD/DEAD-Ziele aus IADS-Zustand ableiten
- [ ] Logistikmissionen aus Logistikzustand ableiten
- [ ] Missionserfolg später auswertbar machen

---

## Phase 1 — AI Director

Der AI Director soll später rote und blaue Reaktionen steuern.

### Geplante Dateien

- [ ] `src/ai/tc_ai_director.lua`
- [ ] `src/ai/tc_ai_cap_manager.lua`
- [ ] `src/ai/tc_ai_gci_manager.lua`

### Aufgaben

- [ ] einfache CAP-Logik vorbereiten
- [ ] einfache GCI-Logik vorbereiten
- [ ] KI-Reaktionen auf Spielerfortschritt vorbereiten
- [ ] KI-Reaktionen auf Capture-Ereignisse vorbereiten
- [ ] KI-Reaktionen auf IADS-Schäden vorbereiten

---

## Phase 1 — IADS-System

Skynet IADS übernimmt später taktisches Radar- und SAM-Verhalten.

Theater Command DCS entscheidet über die kampagnenlogische Einbindung.

### Geplante Dateien

- [ ] `src/iads/tc_iads_network.lua`
- [ ] `src/iads/tc_iads_sites.lua`
- [ ] `src/iads/tc_iads_sectors.lua`
- [ ] `src/iads/tc_iads_state.lua`
- [ ] `src/debug/tc_debug_iads.lua`

### Aufgaben

- [ ] rote IADS-Sektoren vorbereiten
- [ ] SAM-Stellungen als Kampagnenobjekte definieren
- [ ] Radarstellungen als Kampagnenobjekte definieren
- [ ] zerstörte IADS-Objekte kampagnenlogisch speichern
- [ ] Missionsgenerator mit IADS-Zielen verbinden
- [ ] AI Director mit IADS-Zustand verbinden

---

## Phase 1 — Persistenz

Persistenz wird erst gebaut, wenn Airbase-, Capture- und erste Logistiklogik existieren.

### Geplante Dateien

- [ ] `src/campaign/tc_persistence_system.lua`
- [ ] `save/README.md`
- [ ] `save/example_state.lua`

### Aufgaben

- [ ] Speicherstruktur definieren
- [ ] Beispiel-Save-State erstellen
- [ ] Kampagnenzustand serialisieren
- [ ] Kampagnenzustand laden
- [ ] Airbase-Besitz speichern
- [ ] Logistikstatus speichern
- [ ] IADS-Zustand speichern
- [ ] Missionsfortschritt speichern

---

## Mission-Editor-Grundlage

Diese Aufgaben werden später im DCS Mission Editor erledigt.

### DEV-Mission

- [ ] Syria Map als neue Mission öffnen
- [ ] Mission speichern als `Operation_Levant_Reclamation_DEV.miz`
- [ ] Mission unter `mission/dev/` ablegen
- [ ] Koalitionen festlegen
- [ ] Akrotiri als blaue Startbasis nutzen
- [ ] syrisches Festland initial rot kontrolliert anlegen
- [ ] erste Spieler-Slots auf Akrotiri anlegen
- [ ] erste CTLD-Pickup-Zonen auf Akrotiri anlegen
- [ ] erste Template-Gruppen mit Late Activation anlegen
- [ ] erste Framework-Lade-Trigger vorbereiten

### Erste empfohlene Client-Slots

Diese Slots sollen in der ersten DEV-Mission auf Akrotiri angelegt werden:

    CLIENT_BLUE_FA18C_AKROTIRI_01
    CLIENT_BLUE_FA18C_AKROTIRI_02
    CLIENT_BLUE_F16C_AKROTIRI_01
    CLIENT_BLUE_F16C_AKROTIRI_02
    CLIENT_BLUE_F15E_AKROTIRI_01
    CLIENT_BLUE_F15E_AKROTIRI_02
    CLIENT_BLUE_F14B_AKROTIRI_01
    CLIENT_BLUE_F14B_AKROTIRI_02
    CLIENT_BLUE_UH1H_AKROTIRI_01
    CLIENT_BLUE_MI8_AKROTIRI_01

---

## Mission-Editor-Dokumentation

Diese Dateien werden später unter `mission_editor/` angelegt.

- [ ] `mission_editor/README.md`
- [ ] `mission_editor/client_slots.md`
- [ ] `mission_editor/template_groups.md`
- [ ] `mission_editor/trigger_setup.md`
- [ ] `mission_editor/ctld_start_zones.md`
- [ ] `mission_editor/static_targets.md`

---

## Mission-Ordner

Diese Ordner werden später für konkrete Missionsdateien genutzt.

- [ ] `mission/README.md`
- [ ] `mission/dev/README.md`
- [ ] `mission/test/README.md`
- [ ] `mission/release/README.md`

---

## Assets

Dieser Ordner wird später für nicht-Lua-Projektmaterial genutzt.

- [ ] `assets/README.md`

Mögliche spätere Inhalte:

- Briefing-Bilder
- Kartenbilder
- Logos
- Funktexte
- Audio-Dateien
- PDF-Briefings

---

## Tools

Dieser Ordner wird später für Entwicklungs- und Release-Hilfen genutzt.

- [ ] `tools/README.md`
- [ ] `tools/build_notes.md`
- [ ] `tools/test_plan.md`
- [ ] `tools/release_checklist.md`

---

## Was aktuell bewusst nicht gemacht wird

Diese Punkte werden noch nicht begonnen:

- [ ] keine vollständige Frontlinie bauen
- [ ] keine komplette Syria Map manuell mit Einheiten füllen
- [ ] keine 69 Airbase-Zonen im Mission Editor anlegen
- [ ] keine riesigen Triggerketten im Mission Editor bauen
- [ ] keine große Sammeldatei für MOOSE erstellen
- [ ] keine große Sammeldatei für MIST erstellen
- [ ] keine große Sammeldatei für CTLD erstellen
- [ ] keine All-in-one-Lua-Datei erstellen
- [ ] keine Persistenz vor dem Airbase- und Capture-System bauen
- [ ] keine dynamische Großkampagne bauen, bevor die Core-Struktur steht

---

## Nicht gewünschte eigene Lua-Dateien

Diese Dateien sollen nicht erstellt werden:

- [ ] `src/tc_moose.lua`
- [ ] `src/tc_mist.lua`
- [ ] `src/tc_ctld.lua`
- [ ] `src/tc_all_in_one.lua`

---

## Gewünschte aufgabenorientierte Lua-Dateien

Diese Dateien sind perspektivisch erwünscht:

- [ ] `src/world/tc_airbase_scanner.lua`
- [ ] `src/world/tc_zone_factory.lua`
- [ ] `src/campaign/tc_capture_system.lua`
- [ ] `src/logistics/tc_logistics_delivery.lua`
- [ ] `src/logistics/tc_fob_system.lua`
- [ ] `src/missions/tc_mission_generator.lua`
- [ ] `src/ai/tc_ai_cap_manager.lua`
- [ ] `src/campaign/tc_persistence_system.lua`

---

## Aktuell nächster sinnvoller Einzelschritt

Nach dieser Aktualisierung von `TASKS.md`:

- [ ] MIST-Ordner abschließend prüfen
- [ ] falls nötig doppelte MIST-Versionierungsdatei entfernen
- [ ] danach nächsten Einzelschritt festlegen

Empfohlener nächster technischer Schritt nach der MIST-Prüfung:

    src/README.md

Alternativer nächster Vendor-Schritt:

    vendor/moose/Moose.lua

Die Entscheidung erfolgt erst nach Abschluss des aktuellen Einzelschritts.

---

## Arbeitsreihenfolge

Grundsatz:

Erst Dokumentation.

Dann Grundstruktur.

Dann Vendor-Frameworks.

Dann `src/`-Struktur.

Dann Mission-Editor-Basis.

Dann Lua-Core.

Dann Airbase-Scanner.

Dann Zonen.

Dann Capture.

Dann CTLD-Anbindung.

Dann Missionsgenerator.

Dann AI Director.

Dann IADS.

Dann Persistenz.
