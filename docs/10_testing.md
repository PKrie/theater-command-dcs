# Testing

Diese Datei beschreibt die geplante Teststrategie für **Theater Command DCS**.

Theater Command DCS ist ein modulares, dynamisches und später persistentes DCS-World-Kampagnensystem.

Die erste Kampagne trägt den Arbeitstitel:

**Operation Levant Reclamation**

Die Kampagne wird auf der **Syria Map** aufgebaut.

Blau startet auf **Zypern / Akrotiri**.

Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Grundprinzip

Tests folgen dem Projektprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Mission Editor stellt die Testumgebung bereit.

Lua enthält die zu testende Kampagnenlogik.

GitHub dokumentiert Teststand, offene Fehler und erledigte Schritte.

---

## Ziel der Tests

Tests sollen sicherstellen, dass Theater Command DCS schrittweise stabil aufgebaut wird.

Getestet werden sollen:

- Repository-Struktur
- Dokumentation
- Vendor-Frameworks
- Lade-Reihenfolge
- Lua-Loader
- Core-System
- Airbase-System
- Zonen-System
- Capture-System
- Logistiksystem
- Missionsgenerator
- AI Director
- IADS-System
- Persistenz
- Mission-Editor-DEV-Mission

Jedes System soll einzeln testbar sein, bevor es mit anderen Systemen verbunden wird.

---

## Aktueller Projektstand

Stand:

    2026-06-15

Aktuell vorhanden:

- zentrale Projektdokumentation
- `docs/`-Grundblock
- `vendor/`-Frameworks
- `src/README.md`

Aktuell hinterlegte Frameworks:

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Noch nicht vorhanden:

- `src/loader.lua`
- `src/main.lua`
- eigene Core-Dateien
- eigene Systemmodule
- DEV-Mission
- automatisierte Tests
- Mission-Editor-Testumgebung

---

## Testphilosophie

Theater Command DCS wird schrittweise getestet.

Nicht alles gleichzeitig testen.

Jeder neue Baustein soll mindestens folgende Fragen beantworten:

- Wird die Datei korrekt geladen?
- Gibt es Lua-Fehler?
- Gibt es klare Log-Ausgaben?
- Sind Abhängigkeiten vorhanden?
- Ist das Verhalten nachvollziehbar?
- Kann ein Fehler im `dcs.log` erkannt werden?
- Ist der nächste Schritt sicher möglich?

---

## Testumgebungen

Es wird später mehrere Testebenen geben.

Geplante Ebenen:

    1. Repository-Test
    2. Dokumentations-Test
    3. Vendor-Test
    4. Loader-Test
    5. Core-Test
    6. Modul-Test
    7. Mission-Editor-Test
    8. Integrationstest
    9. Persistenztest
    10. Multiplayer-/Server-Test

Nicht alle Testebenen existieren bereits.

---

## Repository-Test

Ziel:

Prüfen, ob die Projektstruktur sauber ist.

Aktuell zu prüfen:

- zentrale Dateien existieren
- `docs/` existiert
- `vendor/` existiert
- `src/README.md` existiert
- keine Framework-Dateien liegen falsch im Repository-Root
- Frameworks liegen unter `vendor/`
- eigene Logik liegt später unter `src/`

Wichtige Regel:

    Moose.lua darf nicht im Repository-Root liegen.
    CTLD.lua darf nicht im Repository-Root liegen.
    SkynetIADS.lua darf nicht im Repository-Root liegen.

Korrekte Pfade:

    vendor/mist/mist.lua
    vendor/moose/Moose.lua
    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua
    vendor/skynet-iads/SkynetIADS.lua

---

## Dokumentations-Test

Ziel:

Prüfen, ob die Dokumentation den echten Projektstand beschreibt.

Zu prüfen:

- README beschreibt aktuellen Framework-Stand
- ROADMAP beschreibt aktuelle Phasen
- TASKS zeigt erledigte und offene Aufgaben korrekt
- CHANGELOG dokumentiert Vendor-Import
- ARCHITECTURE beschreibt aktuelle Architektur
- MISSION_EDITOR_SETUP beschreibt aktuelle Lade-Reihenfolge
- NAMING_CONVENTIONS enthält aktuelle Pfade und Regeln
- LUA_STYLEGUIDE enthält aktuelle Architekturregeln
- docs-Dateien widersprechen sich nicht
- vendor-README-Dateien zeigen echte Framework-Versionen

Wichtige aktuelle Aussagen:

    Vendor-Frameworks sind hinterlegt.
    Eigene Lua-Logik ist noch nicht begonnen.
    src/README.md existiert.
    src/loader.lua existiert noch nicht.
    DEV-Mission existiert noch nicht.

---

## Vendor-Test

Ziel:

Prüfen, ob alle externen Frameworks vorhanden und korrekt dokumentiert sind.

Zu prüfen:

- MIST-Datei vorhanden
- MOOSE-Datei vorhanden
- CTLD-i18n-Datei vorhanden
- CTLD-Datei vorhanden
- Skynet-IADS-Datei vorhanden
- Framework-Versionen dokumentiert
- Framework-Dateien nicht lokal verändert
- stabile Projektnamen verwendet
- README-Dateien in Vendor-Unterordnern aktualisiert

Aktuelle Framework-Dateien:

    vendor/mist/mist.lua
    vendor/moose/Moose.lua
    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua
    vendor/skynet-iads/SkynetIADS.lua

---

## MIST-Test

Aktiver Stand:

    MIST 4.5.128-DYNSLOTS-02

Projektpfad:

    vendor/mist/mist.lua

Zu prüfen:

- Datei existiert
- Datei wird im Mission Editor geladen
- keine Lua-Fehler beim Laden
- MIST ist nach dem Laden global verfügbar
- MIST lädt vor CTLD
- `dcs.log` enthält keine MIST-Fehler

Wichtig:

Diese MIST-Version stammt bewusst aus dem CTLD-Paket.

Grund:

CTLD weist darauf hin, dass für korrektes dynamisches Spawning die mit CTLD gelieferte MIST-Version verwendet werden soll.

---

## MOOSE-Test

Aktiver Stand:

    MOOSE 2.9.17

Projektpfad:

    vendor/moose/Moose.lua

Zu prüfen:

- Datei existiert
- Datei wird im Mission Editor geladen
- keine Lua-Fehler beim Laden
- MOOSE-Strukturen sind nach dem Laden verfügbar
- MOOSE lädt nach MIST
- MOOSE lädt vor Theater Command
- `dcs.log` enthält keine MOOSE-Fehler

Hinweis:

Die genaue globale MOOSE-Verfügbarkeitsprüfung wird später im Loader getestet.

---

## CTLD-Test

Aktiver Stand:

    CTLD 1.6.1

Projektpfade:

    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua

Zu prüfen:

- `CTLD-i18n.lua` existiert
- `CTLD.lua` existiert
- MIST lädt vor CTLD
- `CTLD-i18n.lua` lädt vor `CTLD.lua`
- CTLD lädt ohne Lua-Fehler
- CTLD-Menüs erscheinen für geeignete Helikopter
- CTLD Dynamic Spawns funktionieren mit aktiver MIST-Version
- `dcs.log` enthält keine CTLD-Fehler

Aktuell nicht getestet:

    beacon.ogg
    beaconsilent.ogg

Diese Dateien sind noch nicht hinterlegt und werden erst benötigt, wenn CTLD-Radio-Beacons aktiv genutzt werden sollen.

---

## Skynet-IADS-Test

Aktiver Stand:

    Skynet IADS 3.3.0

Projektpfad:

    vendor/skynet-iads/SkynetIADS.lua

Zu prüfen:

- Datei existiert
- Datei wird im Mission Editor geladen
- MIST lädt vor Skynet IADS
- Skynet IADS lädt vor Theater Command
- keine Lua-Fehler beim Laden
- einfache IADS-Strukturen können später initialisiert werden
- `dcs.log` enthält keine Skynet-IADS-Fehler

Skynet IADS wird aktuell nur als Framework hinterlegt.

Eigene IADS-Kampagnenlogik ist noch nicht begonnen.

---

## Geplante Lade-Reihenfolge testen

Die spätere Lade-Reihenfolge im DCS Mission Editor lautet:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua
    6. src/loader.lua

Zu prüfen:

- Reihenfolge im Mission Editor korrekt
- keine Datei vergessen
- keine Datei doppelt geladen
- keine falschen Root-Dateien verwendet
- Theater Command Loader startet zuletzt

Noch nicht möglich:

    src/loader.lua existiert aktuell noch nicht.

---

## Loader-Test

Der Loader-Test beginnt erst, wenn folgende Datei existiert:

    src/loader.lua

Geplante Tests:

- `src/loader.lua` wird geladen
- globale `TC`-Tabelle wird erzeugt
- Projektversion wird gesetzt
- Framework-Verfügbarkeit wird geprüft
- fehlende Frameworks erzeugen klare Fehler
- Core-Dateien werden geladen
- `src/main.lua` wird gestartet
- Startmeldung erscheint im `dcs.log`

Erwartete spätere Log-Ausgaben:

    [TC] Loading Theater Command DCS
    [TC] MIST available
    [TC] MOOSE available
    [TC] CTLD available
    [TC] Skynet IADS available
    [TC] Loader finished

---

## Main-Test

Der Main-Test beginnt erst, wenn folgende Datei existiert:

    src/main.lua

Geplante Tests:

- `main.lua` wird durch `loader.lua` gestartet
- Konfiguration wird geladen
- Kampagnenzustand wird vorbereitet
- Systeme werden in definierter Reihenfolge initialisiert
- keine großen Systemlogiken direkt in `main.lua`
- Debug-Ausgabe erscheint im `dcs.log`

Erwartete spätere Log-Ausgabe:

    [TC] Main initialized
    [TC] Theater Command ready

---

## Core-Test

Core-Tests beginnen erst, wenn `src/core/` existiert.

Geplante Dateien:

    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
    src/core/tc_utils.lua
    src/core/tc_scheduler.lua

Geplante Tests:

- Konfiguration wird geladen
- Logger funktioniert
- State-Tabelle wird initialisiert
- Utility-Funktionen werfen keine Fehler
- Scheduler funktioniert kontrolliert
- Core erzeugt keine fachliche Kampagnenlogik
- Core bleibt klein und stabil

---

## Airbase-Test

Airbase-Tests beginnen erst, wenn das Airbase-System implementiert wird.

Geplante Datei:

    src/world/tc_airbase_scanner.lua

Geplante Tests:

- Airbase-Scanner lädt ohne Fehler
- Airbases der Syria Map werden erkannt
- Akrotiri wird erkannt
- Akrotiri wird als BLUE gesetzt
- syrische Airbases werden initial als RED gesetzt
- BaseNodes werden erzeugt
- Airbase-Registry wird befüllt
- Debug-Ausgabe erscheint im `dcs.log`
- Airbase-Overrides funktionieren

Beispielausgabe:

    [TC][DEBUG] Airbase scanner found 42 airbases
    [TC][DEBUG] BaseNode created: AKROTIRI / BLUE / CYPRUS

---

## Zonen-Test

Zonen-Tests beginnen erst, wenn das Zonen-System implementiert wird.

Geplante Datei:

    src/world/tc_zone_factory.lua

Geplante Tests:

- virtuelle Capture-Zonen werden erzeugt
- virtuelle Logistik-Zonen werden erzeugt
- virtuelle Defense-Zonen werden erzeugt
- Zonen werden mit BaseNodes verknüpft
- Zonen werden registriert
- Debug-Ausgabe zeigt erzeugte Zonen
- keine nil-Fehler bei fehlenden Airbase-Daten

---

## Capture-Test

Capture-Tests beginnen erst, wenn das Capture-System implementiert wird.

Geplante Datei:

    src/campaign/tc_capture_system.lua

Geplante Tests:

- Besitzstatus von Basen wird geführt
- Besitzstatus von Zonen wird geführt
- BLUE/RED/NEUTRAL-Status funktioniert
- Capture-Bedingungen werden ausgewertet
- Logistikstatus kann später berücksichtigt werden
- Airbase-Status kann später aktualisiert werden
- Debug-Ausgabe zeigt Capture-Status

---

## Logistics-Test

Logistik-Tests beginnen erst, wenn die eigene Logistiklogik implementiert wird.

Geplante Dateien:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

Geplante Tests:

- CTLD ist geladen
- CTLD-Menüs erscheinen
- Pickup-Zonen funktionieren
- Dropoff-Zonen funktionieren
- Kisten können transportiert werden
- Truppen können transportiert werden
- Theater Command erkennt relevante Lieferungen
- Logistikstatus wird aktualisiert
- FOB-Aufbau kann bewertet werden
- Debug-Ausgabe zeigt Logistikstatus

---

## Mission-Generator-Test

Mission-Generator-Tests beginnen erst, wenn der Missionsgenerator implementiert wird.

Geplante Datei:

    src/missions/tc_mission_generator.lua

Geplante Tests:

- Missionsgenerator lädt ohne Fehler
- einfache Missionsliste wird erzeugt
- Missionen können nach Typ angezeigt werden
- Missionen können später nach Flugzeug gefiltert werden
- blockierte Missionen werden begründet
- Missionen berücksichtigen später Airbase-, Capture-, Logistik- und IADS-Zustand
- Debug-Ausgabe zeigt erzeugte Missionen

---

## AI-Director-Test

AI-Director-Tests beginnen erst, wenn der AI Director implementiert wird.

Geplante Datei:

    src/ai/tc_ai_director.lua

Geplante Tests:

- AI Director lädt ohne Fehler
- AI State wird initialisiert
- Eskalationslevel wird gesetzt
- AI Director bleibt ohne aktive Systeme passiv
- keine unkontrollierten Spawns
- Debug-Ausgabe zeigt aktuellen AI-Status
- spätere Reaktionen sind nachvollziehbar

---

## IADS-Test

IADS-Tests beginnen erst, wenn die eigene IADS-Logik implementiert wird.

Geplante Dateien:

    src/iads/tc_iads_network.lua
    src/iads/tc_iads_sites.lua
    src/iads/tc_iads_sectors.lua
    src/iads/tc_iads_state.lua

Geplante Tests:

- Skynet IADS ist geladen
- IADS-Netzwerk wird initialisiert
- Radargruppen können übergeben werden
- SAM-Gruppen können übergeben werden
- IADS-Sektor wird registriert
- IADS-Zustand wird im Theater-Command-State geführt
- Debug-Ausgabe zeigt IADS-Status

---

## Persistence-Test

Persistenztests beginnen erst, wenn das Persistenzsystem implementiert wird.

Geplante Datei:

    src/campaign/tc_persistence_system.lua

Geplante Tests:

- Save-State wird erzeugt
- Save-State enthält Version
- Basisbesitz wird gespeichert
- Basisbesitz wird geladen
- FOB-Status wird gespeichert
- IADS-Zustand wird gespeichert
- Missionshistorie wird gespeichert
- ungültige Save-Dateien erzeugen klare Fehler
- Mission startet auch ohne vorhandenen Save-State

Wichtig:

DCS-Dateischreibrechte und Mission-Scripting-Einschränkungen müssen später separat geprüft werden.

---

## Mission-Editor-Test

Mission-Editor-Tests beginnen erst, wenn die DEV-Mission existiert.

Geplante Mission:

    Operation_Levant_Reclamation_DEV.miz

Geplanter Pfad:

    mission/dev/Operation_Levant_Reclamation_DEV.miz

Geplante Tests:

- Mission öffnet ohne Fehler
- Koalitionen sind korrekt
- Akrotiri ist blaue Startbasis
- syrisches Festland ist rot vorbereitet
- Spieler-Slots funktionieren
- Framework-Lade-Trigger funktionieren
- Template-Gruppen sind Late Activated
- CTLD-Zonen funktionieren
- `dcs.log` ist sauber

---

## DCS-Log-Prüfung

Das DCS-Log ist die wichtigste Fehlerquelle.

Bei jedem technischen Test prüfen:

    Saved Games/DCS.openbeta/Logs/dcs.log

Oder je nach Installation:

    Saved Games/DCS/Logs/dcs.log

Zu suchen:

- Lua errors
- missing file
- nil value
- failed script load
- framework errors
- Theater Command errors

Theater-Command-Logmeldungen sollen später mit folgendem Prefix beginnen:

    [TC]

Fehler:

    [TC][ERROR]

Warnungen:

    [TC][WARN]

Debug:

    [TC][DEBUG]

---

## Fehlerklassen

Fehler sollen später klar eingeordnet werden.

Mögliche Fehlerklassen:

### Framework Error

Ein externes Framework fehlt oder lädt nicht.

Beispiel:

    MIST not available

### Loader Error

Der Theater-Command-Loader kann eine Datei nicht laden.

Beispiel:

    Failed to load module tc_logger.lua

### Configuration Error

Eine Konfiguration fehlt oder ist ungültig.

Beispiel:

    Akrotiri base config missing

### Mission Editor Error

Ein benötigtes Objekt fehlt in der Mission.

Beispiel:

    CTLD pickup zone not found

### Runtime Error

Ein System erzeugt zur Laufzeit einen Fehler.

Beispiel:

    Attempt to index nil baseNode

---

## Testumfang pro Schritt

Jeder neue technische Schritt soll minimal getestet werden.

Beispiel:

Wenn `src/core/tc_logger.lua` erstellt wird:

- Datei lädt
- Logger-Tabelle existiert
- `info()` gibt eine Meldung aus
- `warn()` gibt eine Warnung aus
- `error()` gibt einen Fehler aus
- keine anderen Systeme werden gleichzeitig gebaut

Beispiel:

Wenn `tc_airbase_scanner.lua` erstellt wird:

- Datei lädt
- Scanner startet
- Airbase-Liste wird ausgegeben
- keine Capture-Logik wird gleichzeitig gebaut

---

## Keine Paralleltests

Nicht gleichzeitig testen:

- Airbase-System
- Capture-System
- Logistiksystem
- Missionsgenerator
- AI Director
- Persistenz

Stattdessen:

    ein Modul erstellen
    ein Modul laden
    ein Modul testen
    Fehler beheben
    dokumentieren
    nächstes Modul

---

## Regressionstest

Nach jedem größeren Schritt soll geprüft werden:

- laden die Frameworks weiterhin?
- startet `src/loader.lua` weiterhin?
- gibt es neue Fehler im `dcs.log`?
- wurden bestehende Pfade verändert?
- wurde die Lade-Reihenfolge beschädigt?
- stimmen README und TASKS noch?

---

## Manuelle Testnotizen

Spätere manuelle Testnotizen können unter `tools/` dokumentiert werden.

Geplante Dateien:

    tools/test_plan.md
    tools/build_notes.md

Diese Dateien existieren aktuell noch nicht.

Sie werden später angelegt, wenn konkrete Lua-Tests beginnen.

---

## Teststatus aktuell

Aktueller Stand:

    Dokumentation teilweise aktualisiert
    Vendor-Frameworks hinterlegt
    eigene Lua-Logik noch nicht begonnen
    DEV-Mission noch nicht erstellt
    Frameworks noch nicht im DCS Mission Editor getestet

Aktuell kann geprüft werden:

- Repository-Struktur
- Dokumentationskonsistenz
- Vendor-Dateien
- Framework-Versionen
- geplante Lade-Reihenfolge

Noch nicht testbar:

- Loader
- Main
- Core-System
- Airbase-System
- Capture-System
- Logistik-Anbindung
- Missionsgenerator
- AI Director
- IADS-Kampagnenlogik
- Persistenz

---

## Aktueller nächster technischer Schritt

Nach Abschluss der aktuellen Dokumentationsaktualisierung:

    src-Unterordner und README-Dateien erstellen

Danach:

    src/loader.lua
    src/main.lua
    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
