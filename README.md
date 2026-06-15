# Theater Command DCS

**Theater Command DCS** ist ein modulares, dynamisches und später persistentes DCS-World-Kampagnensystem.

Die erste Kampagne trägt den Arbeitstitel:

**Operation Levant Reclamation**

Das Projekt wird auf der **Syria Map** aufgebaut.

Blau startet auf **Zypern / Akrotiri**.

Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Grundidee

Theater Command DCS soll keine einzelne statische Mission werden, sondern ein dynamisches Kampagnensystem.

Der Mission Editor stellt nur die physische Bühne bereit.

Die eigentliche Kampagnenlogik entsteht durch Lua.

Die Kampagne soll später folgende Systeme verbinden:

- Airbase-Erkennung
- virtuelle Zonen
- Capture-System
- CTLD-Logistik
- FOB-Aufbau
- dynamische Missionsgenerierung
- AI Director
- CAP- und GCI-Management
- Skynet-IADS-Anbindung
- Persistenz
- F10-Menüs
- Debug- und Testsysteme

Der Spieler ist nicht der alleinige Mittelpunkt der Mission.

Der Spieler ist Teil eines größeren dynamischen Systems.

---

## Leitprinzip

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Mission Editor wird möglichst schlank gehalten.

Alles, was sinnvoll berechnet werden kann, soll später durch Lua gesteuert werden.

---

## Kampagnenlage

Erste Kampagne:

    Operation Levant Reclamation

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert
    Erste aktive Region: syrische Küste
    Erstes operatives Ziel: Küsten-IADS schwächen
    Erstes logistisches Ziel: Brückenkopf / FOB an der Küste aufbauen

Geplante blaue Spielerrollen zu Beginn:

    F/A-18C
    F-16C
    F-14B
    F-15E
    UH-1H
    Mi-8

Spätere Rollen nach Aufbau vorgeschobener Strukturen:

    A-10C II
    AH-64D
    weitere CAS-, Transport- und Unterstützungsrollen

---

## Aktueller Projektstatus

Stand:

    2026-06-15

Aktuell erledigt:

- Repository-Grundstruktur erstellt
- zentrale Dokumentationsdateien angelegt
- `docs/`-Grundblock angelegt
- `vendor/`-Grundstruktur angelegt
- MIST hinterlegt
- MOOSE hinterlegt
- CTLD hinterlegt
- Skynet IADS hinterlegt
- `src/README.md` angelegt
- falsch platzierte Root-`Moose.lua` entfernt

Aktueller Fokus:

    Dokumentation auf aktuellen Vendor-Stand bringen

Noch nicht begonnen:

    eigene Lua-Core-Dateien
    loader.lua
    main.lua
    Airbase-Scanner
    Capture-System
    Logistik-Anbindung
    Missionsgenerator
    AI Director
    Persistenz
    Mission-Editor-DEV-Mission

---

## Externe Frameworks

Externe Frameworks liegen ausschließlich unter:

    vendor/

Sie werden nicht verändert.

Aktuell hinterlegte Frameworks:

    vendor/mist/mist.lua
    vendor/moose/Moose.lua
    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua
    vendor/skynet-iads/SkynetIADS.lua

Zusätzliche Referenzdateien:

    vendor/mist/Mist guide.pdf
    vendor/mist/Example_DBs/
    vendor/moose/MOOSE_DOCS.md

---

## Aktueller Framework-Stand

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Wichtig:

Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket, da CTLD für korrektes dynamisches Spawning auf die mitgelieferte MIST-Version verweist.

---

## Geplante Lade-Reihenfolge im DCS Mission Editor

Die Frameworks und der spätere Theater-Command-Loader sollen in dieser Reihenfolge geladen werden:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua
    6. src/loader.lua

Wichtig:

- MIST wird vor CTLD geladen.
- `CTLD-i18n.lua` wird vor `CTLD.lua` geladen.
- Skynet IADS wird nach MIST geladen.
- Eigene Theater-Command-Logik startet erst nach den externen Frameworks.

---

## Architekturregel

Eigene Theater-Command-Logik gehört nach:

    src/

Externe Frameworks gehören nach:

    vendor/

Die eigene Lua-Struktur wird nach Aufgaben sortiert, nicht nach Frameworks.

Nicht gewünscht:

    src/tc_moose.lua
    src/tc_mist.lua
    src/tc_ctld.lua
    src/tc_all_in_one.lua

Gewünscht ist eine aufgabenorientierte Struktur, zum Beispiel:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua
    src/campaign/tc_capture_system.lua
    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua
    src/missions/tc_mission_generator.lua
    src/ai/tc_ai_cap_manager.lua
    src/campaign/tc_persistence_system.lua

Eine eigene Datei darf intern MIST, MOOSE, CTLD oder Skynet IADS nutzen.

Der Dateiname richtet sich aber immer nach der Aufgabe, nicht nach dem Framework.

---

## Aktuelle Repository-Struktur

Aktuell vorhanden:

    theater-command-dcs/
    ├── README.md
    ├── ROADMAP.md
    ├── TASKS.md
    ├── CHANGELOG.md
    ├── ARCHITECTURE.md
    ├── MISSION_EDITOR_SETUP.md
    ├── NAMING_CONVENTIONS.md
    ├── LUA_STYLEGUIDE.md
    ├── .gitignore
    ├── docs/
    ├── src/
    └── vendor/

Aktuell noch nicht vollständig angelegt:

    mission/
    mission_editor/
    assets/
    save/
    tools/

Diese Ordner werden später ergänzt, sobald sie für den nächsten konkreten Projektschritt benötigt werden.

---

## Dokumentation

Die zentrale Dokumentation liegt aktuell in:

    README.md
    ROADMAP.md
    TASKS.md
    CHANGELOG.md
    ARCHITECTURE.md
    MISSION_EDITOR_SETUP.md
    NAMING_CONVENTIONS.md
    LUA_STYLEGUIDE.md
    docs/
    vendor/
    src/

Der Ordner `docs/` enthält die fachliche und technische Projektdokumentation.

Der Ordner `vendor/` dokumentiert die eingebundenen externen Frameworks.

Der Ordner `src/` dokumentiert die geplante eigene Lua-Struktur.

---

## Projektphasen

Grobe Entwicklungsphasen:

    Phase 0: Projektgrundlage, Dokumentation und Vendor-Frameworks
    Phase 1: src-Grundstruktur und Lua-Core
    Phase 2: Airbase-System
    Phase 3: virtuelles Zonen-System
    Phase 4: Capture-System
    Phase 5: Logistik und CTLD-Anbindung
    Phase 6: Missionsgenerator
    Phase 7: AI Director
    Phase 8: IADS-Anbindung
    Phase 9: Persistenz
    Phase 10: Mission-Editor-DEV-Mission
    Phase 11: Test, Stabilisierung und Release-Struktur

Aktuell befindet sich das Projekt noch in:

    Phase 0

---

## Erste technische Ziele nach Abschluss der Dokumentation

Nach Abschluss der aktuellen Dokumentationsaktualisierung sollen als nächste technische Schritte folgen:

    src/core/README.md
    src/world/README.md
    src/campaign/README.md
    src/logistics/README.md
    src/missions/README.md
    src/ai/README.md
    src/iads/README.md
    src/ui/README.md
    src/debug/README.md

Danach folgen die ersten echten Lua-Dateien:

    src/loader.lua
    src/main.lua
    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua

---

## Entwicklungsgrundsatz

Jede Datei erfüllt genau eine klare Aufgabe.

Keine All-in-one-Dateien.

Keine Framework-Sammeldateien.

Keine große Mission-Editor-Triggerkette für Dinge, die Lua später berechnen kann.

---

## Zielbild

Theater Command DCS soll langfristig ein eigenes modulares Kampagnensystem werden.

Es soll dynamische Einsätze, persistente Basen, CTLD-Logistik, KI-Gegenreaktionen, IADS-Zustand, Airbase-Besitz und spielerabhängige Missionsangebote miteinander verbinden.

Das Ziel ist ein stabiler, verständlicher und erweiterbarer technischer Unterbau für dynamische DCS-Kampagnen.
