# Mission Editor

Dieser Ordner enthält die Mission-Editor-Dokumentation für **Theater Command DCS**.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut.

Blau startet auf:

    Akrotiri / Zypern

Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Zweck dieses Ordners

`mission_editor/` dokumentiert alle Arbeiten, die direkt im DCS Mission Editor vorbereitet werden müssen.

Der Ordner enthält später keine eigentliche Kampagnenlogik.

Die Kampagnenlogik liegt unter:

    src/

Externe Frameworks liegen unter:

    vendor/

Mission-Dateien liegen später unter:

    mission/

---

## Grundprinzip

Das zentrale Projektprinzip bleibt:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Mission Editor stellt die physische Bühne bereit.

Lua steuert die dynamische Kampagne.

GitHub dokumentiert Struktur, Entscheidungen, Versionen und Aufgabenstand.

---

## Was im Mission Editor vorbereitet wird

Der DCS Mission Editor wird für Dinge genutzt, die DCS physisch in der Mission benötigt.

Dazu gehören:

- Karte
- Koalitionen
- Startzeit
- Wetter
- Spieler-Client-Slots
- Lua-Ladetrigger
- Template-Gruppen
- CTLD-Zonen
- statische Ziele
- erste IADS-Gruppen
- erste Testumgebung

---

## Was nicht im Mission Editor gebaut wird

Nicht im Mission Editor bauen:

- keine große Kampagnenlogik
- keine vollständige Frontlinienlogik
- keine Basen-Capture-Triggerketten
- keine dynamische Missionsgenerierung per Editor-Trigger
- keine Ressourcenlogik
- keine Persistenzlogik
- keine KI-Gegenoffensiven als feste Triggerketten
- keine 69 manuell gepflegten Airbase-Zonen
- keine All-in-one-Skriptlogik

Diese Systeme werden später durch Theater-Command-Lua-Dateien unter `src/` gesteuert.

---

## Aktueller Stand

Stand: 2026-06-16

Aktuell vorhanden:

- zentrale Projektdokumentation
- `docs/`-Grundblock
- `vendor/`-Frameworks
- `src/`-Grundstruktur
- Core-Module
- World-Module
- Campaign-Module
- Logistics-Module
- Missionsgenerator
- AI-CAP-Manager
- Loader
- Main-Initialisierung
- Mission-Editor-Setup-Dokumentation

Noch nicht vorhanden:

- DEV-Mission
- Mission-Editor-Triggerstruktur
- Spieler-Slots
- Template-Gruppen
- CTLD-Zonen
- statische Ziele
- Mission-Ordnerstruktur
- konkrete Mission-Datei

---

## Geplante DEV-Mission

Die erste technische Entwicklungsmission heißt:

    Operation_Levant_Reclamation_DEV.miz

Geplanter späterer Ablageort:

    mission/dev/Operation_Levant_Reclamation_DEV.miz

Diese Mission dient nicht als fertige Spielmission.

Sie ist die technische Testbühne für:

- Framework-Ladung
- Source-Ladung
- Loader-Start
- Main-Start
- `dcs.log`-Kontrolle
- Airbase-Erkennung
- erste Zone-Erzeugung
- spätere CTLD-Tests
- spätere F10-Tests
- spätere Debug-Tests

---

## Erste Mission-Editor-Arbeit

Der erste praktische Mission-Editor-Schritt wird nicht sofort die gesamte Kampagne bauen.

Zuerst wird eine minimale DEV-Mission erstellt.

Minimaler Inhalt:

- Syria Map
- Koalitionen
- Akrotiri als blaue Startbasis
- einfache Startzeit
- einfaches Wetter
- ein bis zwei blaue Test-Client-Slots
- Lua-Ladetrigger für Frameworks und Source-Dateien
- keine komplexe rote Kampagne
- keine komplette IADS-Struktur
- keine vollständige Frontlinie

Ziel ist zuerst:

    Lädt Theater Command DCS überhaupt sauber im DCS Mission Scripting Environment?

---

## Aktuelle empfohlene Starttest-Variante

Für den ersten realen DCS-Test wird die sichere Einzeldatei-Ladung genutzt.

Name:

    Starttest-Variante A

Grund:

`src/loader.lua` kann grundsätzlich Dateien per `dofile` nachladen.

Im DCS Mission Scripting Environment muss aber praktisch geprüft werden, ob `dofile` im konkreten Setup zuverlässig funktioniert.

Deshalb wird im ersten Test nicht auf `dofile` vertraut.

Stattdessen werden die aktiven Dateien einzeln per `DO SCRIPT FILE` geladen.

---

## Ladeprinzip für Starttest-Variante A

Zuerst werden die externen Frameworks geladen.

Danach werden alle aktiven Theater-Command-Source-Dateien einzeln geladen.

Danach wird `src/main.lua` geladen.

Zuletzt wird `src/loader.lua` geladen.

Ziel:

    Frameworks verfügbar machen
    Source-Dateien im DCS-Kontext laden
    Main verfügbar machen
    Loader zuletzt starten
    Loader erkennt vorhandene Module
    Loader startet Main
    Main startet Runtime-Systeme

---

## Framework-Ladereihenfolge

Die Frameworks werden im DCS Mission Editor in dieser Reihenfolge geladen:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua

Diese Reihenfolge ist verbindlich.

Wichtig:

- MIST muss vor CTLD geladen werden.
- `CTLD-i18n.lua` muss vor `CTLD.lua` geladen werden.
- Skynet IADS wird nach MIST geladen.
- Eigene Theater-Command-Logik startet erst nach den Frameworks.

---

## Source-Ladereihenfolge für den ersten Test

Für Starttest-Variante A werden anschließend diese Dateien geladen:

    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
    src/core/tc_utils.lua
    src/core/tc_scheduler.lua

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

    src/missions/tc_mission_generator.lua

    src/ai/tc_ai_cap_manager.lua

    src/main.lua
    src/loader.lua

`src/loader.lua` wird in Variante A bewusst zuletzt geladen.

---

## Warum `src/loader.lua` zuletzt geladen wird

In einem normalen Lua-Projekt wäre `loader.lua` die erste eigene Datei.

Im ersten DCS-Test wird aber bewusst anders vorgegangen.

Grund:

Die aktiven Module sollen zuerst einzeln vom Mission Editor geladen werden.

Danach soll der Loader prüfen, ob diese Module vorhanden sind, und anschließend `main.lua` starten.

Dadurch wird der erste Test nicht davon abhängig, ob `dofile` schon funktioniert.

---

## Erwartetes Verhalten im ersten erfolgreichen Test

Ein erfolgreicher erster Starttest bedeutet:

- Mission startet ohne Lua-Fehler
- MIST lädt
- MOOSE lädt
- CTLD-i18n lädt
- CTLD lädt
- Skynet IADS lädt
- alle aktiven Source-Dateien laden
- `src/main.lua` lädt
- `src/loader.lua` lädt
- Loader erkennt die Frameworks
- Loader erkennt die aktiven Module
- Main wird gestartet
- Runtime-Systeme starten
- `dcs.log` enthält keine schwerwiegenden Theater-Command-Fehler

---

## Erwartete Log-Kontrolle

Nach dem ersten Test muss `dcs.log` geprüft werden.

Gesucht wird nach:

    TC
    Theater Command
    error
    ERROR
    stack traceback
    attempt to index
    nil value
    cannot open
    dofile
    MIST
    MOOSE
    CTLD
    Skynet

Wichtig ist nicht, dass schon Kampagnenspiellogik funktioniert.

Wichtig ist nur:

    Die Startkette lädt sauber.

---

## Wenn Starttest-Variante A funktioniert

Wenn Variante A funktioniert, ist der nächste technische Test:

    Starttest-Variante B

Variante B lädt nur:

    vendor/mist/mist.lua
    vendor/moose/Moose.lua
    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua
    vendor/skynet-iads/SkynetIADS.lua
    src/loader.lua

Dabei wird geprüft, ob `src/loader.lua` die restlichen Source-Dateien selbst per `dofile` nachladen kann.

---

## Wenn Starttest-Variante A nicht funktioniert

Wenn Variante A nicht funktioniert, wird nicht direkt weitergebaut.

Dann wird zuerst die Fehlermeldung aus `dcs.log` ausgewertet.

Mögliche Fehlerquellen:

- falsche Lade-Reihenfolge
- falscher Dateiname
- falscher Pfad
- Lua-Syntaxfehler
- fehlendes Framework
- fehlerhafte globale Tabelle
- Modulname stimmt nicht
- Startfunktion fehlt
- DCS-Mission-Scripting-Einschränkung

Erst wenn die Startkette sauber ist, wird die DEV-Mission erweitert.

---

## Geplante Dokumentationsdateien in diesem Ordner

Dieser Ordner soll später folgende Dateien enthalten:

    mission_editor/README.md
    mission_editor/client_slots.md
    mission_editor/template_groups.md
    mission_editor/trigger_setup.md
    mission_editor/ctld_start_zones.md
    mission_editor/static_targets.md

Status:

- [x] `mission_editor/README.md`
- [ ] `mission_editor/client_slots.md`
- [ ] `mission_editor/template_groups.md`
- [ ] `mission_editor/trigger_setup.md`
- [ ] `mission_editor/ctld_start_zones.md`
- [ ] `mission_editor/static_targets.md`

---

## Nächste sinnvolle Datei

Als nächstes sollte die konkrete Trigger-Struktur dokumentiert werden.

Nächste Datei:

    mission_editor/trigger_setup.md

Zweck:

- Triggernamen festlegen
- Reihenfolge für Starttest-Variante A festlegen
- `TIME MORE`-Werte dokumentieren
- `DO SCRIPT FILE`-Aktionen dokumentieren
- erwartete Prüfpunkte im `dcs.log` festlegen

---

## Arbeitsregel

Auch im Mission Editor gilt:

    immer nur ein konkreter Schritt

Nicht gleichzeitig:

- komplette Slots bauen
- komplette IADS bauen
- komplette CTLD-Struktur bauen
- komplette Frontlinie bauen
- komplette Template-Bibliothek bauen

Zuerst wird die Startkette getestet.

Danach wird erweitert.
