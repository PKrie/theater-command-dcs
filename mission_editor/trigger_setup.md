# Trigger Setup

Diese Datei dokumentiert die konkrete Trigger-Struktur im DCS Mission Editor für **Theater Command DCS**.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die aktuelle technische Entwicklungsmission heißt:

    Operation_Levant_Reclamation_DEV.miz

---

## Zweck dieser Datei

Diese Datei beschreibt die Trigger, die im DCS Mission Editor für den ersten technischen Starttest verwendet wurden.

Der Fokus liegt nicht auf Kampagnenlogik.

Der Fokus liegt nur auf:

- Framework-Ladung
- Source-Ladung
- Loader-Start
- Main-Start
- Prüfung der `dcs.log`
- technischem Nachweis, dass Theater Command DCS im DCS Mission Scripting Environment startet

---

## Grundsatz

Der Mission Editor bleibt in Theater Command DCS die Bühne.

Die Kampagnenlogik wird nicht über große Triggerketten gebaut.

Grundprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Die Trigger in dieser Datei dienen nur dem technischen Starttest.

Sie sind nicht die finale Kampagnenlogik.

---

## Aktueller Status

Stand: 2026-06-16

Starttest-Variante A wurde im DCS Mission Editor vollständig angelegt und erfolgreich getestet.

Ergebnis:

    Bestanden

Bestätigt wurde:

- MIST wird geladen
- MOOSE wird geladen
- CTLD-i18n wird geladen
- CTLD wird geladen
- Skynet IADS wird geladen
- Theater Command Core wird geladen
- Theater Command World wird geladen
- Theater Command Campaign wird geladen
- Theater Command Logistics wird geladen
- Theater Command Missions wird geladen
- Theater Command AI wird geladen
- `src/main.lua` wird geladen
- `src/loader.lua` wird zuletzt geladen
- Loader startet
- Frameworks werden erkannt
- Main startet
- Runtime-Systeme werden initialisiert
- Airbase-Scanner läuft
- Zone-Factory läuft
- Loader beendet sauber

Wichtiger Befund:

    Airbase-Scanner registrierte 225 Airbase-/Helipad-Objekte.
    Zone-Factory registrierte 225 Zonen.

Bewertung:

    Die Triggerkette für Starttest-Variante A funktioniert.
    Die hohe Zahl erkannter Airbase-/Helipad-Objekte ist kein Triggerfehler.
    Der Airbase-Scanner muss später fachlich filtern und klassifizieren.

---

## Aktuelle DEV-Mission

Dateiname:

    Operation_Levant_Reclamation_DEV.miz

Aktueller Inhalt:

    Map: Syria
    Koalitionspreset: Modern
    Blue Start: Akrotiri / Zypern
    erster blauer Client-Slot: F/A-18C Lot 20 auf Akrotiri
    Trigger: Starttest-Variante A vollständig angelegt
    keine rote Frontlinie
    keine IADS-Stellungen
    keine CTLD-Zonen
    keine Template-Gruppen
    keine F10-Menüs

Diese Mission ist aktuell nur ein technischer Testträger.

---

## Lokaler Repository-Pfad

Die lokale Repository-Kopie auf dem DCS-PC liegt aktuell unter:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\

Alle Script-Dateien werden aus dieser lokalen Repository-Kopie geladen.

---

## Allgemeine Trigger-Einstellungen

Jeder Trigger der Starttest-Variante A verwendet diese Grundstruktur:

    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT
    Bedingung: MEHR ZEIT / TIME MORE
    Aktion: SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Die Trigger werden zeitversetzt geladen, damit die Reihenfolge eindeutig bleibt.

---

## Starttest-Variante A

Status:

    Erfolgreich getestet

Ziel:

    sichere Einzeldatei-Ladung ohne harte dofile-Abhängigkeit

Grund:

- DCS lädt jede Datei direkt über den Mission Editor
- Fehler lassen sich leichter einer Datei zuordnen
- die DCS-Sandbox für `dofile` muss noch nicht funktionieren
- die Source-Dateien werden trotzdem im echten DCS-Kontext getestet
- die `dcs.log` zeigt klar, welche Systeme starten

---

## Vollständige Trigger-Reihenfolge

### 1. MIST laden

Trigger:

    Name: TC_LOAD_MIST
    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT / TIME MORE
    Sekunden: 1

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\vendor\mist\mist.lua

---

### 2. MOOSE laden

Trigger:

    Name: TC_LOAD_MOOSE
    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT / TIME MORE
    Sekunden: 2

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\vendor\moose\Moose.lua

---

### 3. CTLD i18n laden

Trigger:

    Name: TC_LOAD_CTLD_I18N
    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT / TIME MORE
    Sekunden: 3

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\vendor\ctld\CTLD-i18n.lua

---

### 4. CTLD laden

Trigger:

    Name: TC_LOAD_CTLD
    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT / TIME MORE
    Sekunden: 4

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\vendor\ctld\CTLD.lua

---

### 5. Skynet IADS laden

Trigger:

    Name: TC_LOAD_SKYNET_IADS
    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT / TIME MORE
    Sekunden: 5

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\vendor\skynet-iads\SkynetIADS.lua

---

## Theater-Command-Core laden

### 6. TC Config laden

Trigger:

    Name: TC_LOAD_TC_CONFIG
    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT / TIME MORE
    Sekunden: 7

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\core\tc_config.lua

---

### 7. TC Logger laden

Trigger:

    Name: TC_LOAD_TC_LOGGER
    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT / TIME MORE
    Sekunden: 8

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\core\tc_logger.lua

---

### 8. TC State laden

Trigger:

    Name: TC_LOAD_TC_STATE
    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT / TIME MORE
    Sekunden: 9

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\core\tc_state.lua

---

### 9. TC Utils laden

Trigger:

    Name: TC_LOAD_TC_UTILS
    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT / TIME MORE
    Sekunden: 10

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\core\tc_utils.lua

---

### 10. TC Scheduler laden

Trigger:

    Name: TC_LOAD_TC_SCHEDULER
    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT / TIME MORE
    Sekunden: 11

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\core\tc_scheduler.lua

---

## Theater-Command-World laden

### 11. TC Airbase Scanner laden

Trigger:

    Name: TC_LOAD_TC_AIRBASE_SCANNER
    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT / TIME MORE
    Sekunden: 12

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\world\tc_airbase_scanner.lua

---

### 12. TC Zone Factory laden

Trigger:

    Name: TC_LOAD_TC_ZONE_FACTORY
    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT / TIME MORE
    Sekunden: 13

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\world\tc_zone_factory.lua

---

## Theater-Command-Campaign laden

### 13. TC Capture System laden

Trigger:

    Name: TC_LOAD_TC_CAPTURE_SYSTEM
    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT / TIME MORE
    Sekunden: 14

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\campaign\tc_capture_system.lua

---

### 14. TC Persistence System laden

Trigger:

    Name: TC_LOAD_TC_PERSISTENCE_SYSTEM
    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT / TIME MORE
    Sekunden: 15

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\campaign\tc_persistence_system.lua

---

## Theater-Command-Logistics laden

### 15. TC Logistics Delivery laden

Trigger:

    Name: TC_LOAD_TC_LOGISTICS_DELIVERY
    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT / TIME MORE
    Sekunden: 16

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\logistics\tc_logistics_delivery.lua

---

### 16. TC FOB System laden

Trigger:

    Name: TC_LOAD_TC_FOB_SYSTEM
    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT / TIME MORE
    Sekunden: 17

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\logistics\tc_fob_system.lua

---

## Theater-Command-Missions laden

### 17. TC Mission Generator laden

Trigger:

    Name: TC_LOAD_TC_MISSION_GENERATOR
    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT / TIME MORE
    Sekunden: 18

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\missions\tc_mission_generator.lua

---

## Theater-Command-AI laden

### 18. TC AI CAP Manager laden

Trigger:

    Name: TC_LOAD_TC_AI_CAP_MANAGER
    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT / TIME MORE
    Sekunden: 19

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\ai\tc_ai_cap_manager.lua

---

## Theater-Command-Main laden

### 19. TC Main laden

Trigger:

    Name: TC_LOAD_TC_MAIN
    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT / TIME MORE
    Sekunden: 20

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\main.lua

Wichtig:

    main.lua wird vor loader.lua geladen.

Grund:

    main.lua definiert TC.Main.
    loader.lua startet danach die Main-Initialisierung.

---

## Theater-Command-Loader laden

### 20. TC Loader laden

Trigger:

    Name: TC_LOAD_TC_LOADER
    Typ: EINMALIG / ONCE
    Ereignis: KEIN EVENT / NO EVENT

Bedingung:

    MEHR ZEIT / TIME MORE
    Sekunden: 22

Aktion:

    SKRIPTDATEI AUSFÜHREN / DO SCRIPT FILE

Datei:

    C:\Users\Paul\Documents\GitHub\theater-command-dcs\src\loader.lua

Wichtig:

    loader.lua ist die letzte eigene Datei in Starttest-Variante A.

---

## Kompakte Übersicht

Die getestete Reihenfolge lautet:

    1.  TC_LOAD_MIST                   -> TIME MORE 1  -> vendor/mist/mist.lua
    2.  TC_LOAD_MOOSE                  -> TIME MORE 2  -> vendor/moose/Moose.lua
    3.  TC_LOAD_CTLD_I18N              -> TIME MORE 3  -> vendor/ctld/CTLD-i18n.lua
    4.  TC_LOAD_CTLD                   -> TIME MORE 4  -> vendor/ctld/CTLD.lua
    5.  TC_LOAD_SKYNET_IADS            -> TIME MORE 5  -> vendor/skynet-iads/SkynetIADS.lua
    6.  TC_LOAD_TC_CONFIG              -> TIME MORE 7  -> src/core/tc_config.lua
    7.  TC_LOAD_TC_LOGGER              -> TIME MORE 8  -> src/core/tc_logger.lua
    8.  TC_LOAD_TC_STATE               -> TIME MORE 9  -> src/core/tc_state.lua
    9.  TC_LOAD_TC_UTILS               -> TIME MORE 10 -> src/core/tc_utils.lua
    10. TC_LOAD_TC_SCHEDULER           -> TIME MORE 11 -> src/core/tc_scheduler.lua
    11. TC_LOAD_TC_AIRBASE_SCANNER     -> TIME MORE 12 -> src/world/tc_airbase_scanner.lua
    12. TC_LOAD_TC_ZONE_FACTORY        -> TIME MORE 13 -> src/world/tc_zone_factory.lua
    13. TC_LOAD_TC_CAPTURE_SYSTEM      -> TIME MORE 14 -> src/campaign/tc_capture_system.lua
    14. TC_LOAD_TC_PERSISTENCE_SYSTEM  -> TIME MORE 15 -> src/campaign/tc_persistence_system.lua
    15. TC_LOAD_TC_LOGISTICS_DELIVERY  -> TIME MORE 16 -> src/logistics/tc_logistics_delivery.lua
    16. TC_LOAD_TC_FOB_SYSTEM          -> TIME MORE 17 -> src/logistics/tc_fob_system.lua
    17. TC_LOAD_TC_MISSION_GENERATOR   -> TIME MORE 18 -> src/missions/tc_mission_generator.lua
    18. TC_LOAD_TC_AI_CAP_MANAGER      -> TIME MORE 19 -> src/ai/tc_ai_cap_manager.lua
    19. TC_LOAD_TC_MAIN                -> TIME MORE 20 -> src/main.lua
    20. TC_LOAD_TC_LOADER              -> TIME MORE 22 -> src/loader.lua

---

## Ergebnis des ersten Tests

Starttest-Variante A wurde erfolgreich durchgeführt.

`dcs.log` bestätigte:

    [TC] Theater Command loader started
    [TC] Framework available: MIST
    [TC] Framework available: MOOSE
    [TC] Framework available: CTLD
    [TC] Framework available: Skynet IADS
    [TC] Main start requested
    [TC] Core check passed
    [TC] Runtime systems initialized
    [TC] Main initialized
    [TC] Main started
    [TC] Theater Command loader finished

Zusätzlich:

    Airbase scan completed: 225 airbases registered
    Zone factory completed: 225 zones registered

Bewertung:

    Starttest-Variante A bestanden.

---

## Starttest-Variante B

Status:

    Noch nicht durchgeführt

Ziel:

    Loader-only-Test mit dofile

Geplante Idee:

Der Mission Editor lädt nur:

- Frameworks
- `src/loader.lua`

Danach soll `loader.lua` die restlichen Source-Dateien per `dofile` nachladen.

Geplante Trigger-Reihenfolge:

    1. TC_LOAD_MIST         -> TIME MORE 1 -> vendor/mist/mist.lua
    2. TC_LOAD_MOOSE        -> TIME MORE 2 -> vendor/moose/Moose.lua
    3. TC_LOAD_CTLD_I18N    -> TIME MORE 3 -> vendor/ctld/CTLD-i18n.lua
    4. TC_LOAD_CTLD         -> TIME MORE 4 -> vendor/ctld/CTLD.lua
    5. TC_LOAD_SKYNET_IADS  -> TIME MORE 5 -> vendor/skynet-iads/SkynetIADS.lua
    6. TC_LOAD_TC_LOADER    -> TIME MORE 7 -> src/loader.lua

Prüffragen:

- Funktioniert `dofile` im DCS Mission Scripting Environment?
- Kann `loader.lua` lokale Source-Dateien aus dem Repository nachladen?
- Wird der Script-Root korrekt erkannt?
- Blockiert die DCS-Sandbox?
- Braucht das Projekt später eine Build-Datei?
- Bleibt Einzeldatei-Ladung für Entwicklung sinnvoller?

Variante B wird erst in einer späteren Session vorbereitet.

---

## Bekannte DCS-/Syria-Meldungen

Während des ersten Tests traten auch DCS-/Syria-interne Meldungen auf.

Beispiele:

    INVALID ATC HI08
    missing object declaration
    texture not found
    DTC_MANAGER Window pointer is null

Bewertung:

    Diese Meldungen sind aktuell kein Theater-Command-Blocker.
    Entscheidend sind Lua-Fehler mit TC-Bezug, stack tracebacks oder fehlgeschlagene Framework-/Source-Ladung.

---

## Nächster technischer Schritt

Der nächste technische Schritt ist nicht ein weiterer Trigger.

Der nächste technische Schritt ist:

    Airbase-Scanner nach dem Syria-Update fachlich filtern

Grund:

DCS liefert aktuell 225 Airbase-/Helipad-Objekte auf der Syria Map.

Diese Objekte dürfen nicht alle als strategische Kampagnenbasen behandelt werden.

Ziel:

- strategische Airfields erkennen
- Heliports erkennen
- Helipads erkennen
- Medical Pads erkennen
- FARPs erkennen
- sonstige Pads trennen
- Capture-System nur auf strategische Basen anwenden
- Missionsgenerator nur geeignete Ziele verwenden lassen
- Zone-Factory an gefilterte Daten koppeln

---

## Aktueller Status

Die Trigger-Struktur für Starttest-Variante A ist vollständig dokumentiert und praktisch getestet.

Die DEV-Mission kann als technischer Testträger weiterverwendet werden.

Der nächste relevante Entwicklungsschritt liegt im Code, nicht im Mission Editor.
