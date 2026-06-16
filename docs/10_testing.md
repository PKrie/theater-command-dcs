# Testing

Diese Datei beschreibt die Teststrategie für **Theater Command DCS**.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut.

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## Grundsatz

Theater Command DCS wird nicht als eine große fertige Mission gebaut und erst am Ende getestet.

Jeder technische Baustein wird einzeln aufgebaut, dokumentiert und in DCS geprüft.

Grundprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Mission Editor stellt nur die Testumgebung bereit.

Lua enthält die eigentliche Kampagnenlogik.

GitHub dokumentiert den getesteten Stand.

---

## Aktueller Teststand

Stand: 2026-06-16

Der erste reale DCS-Starttest wurde durchgeführt.

Test:

    Starttest-Variante A — sichere Einzeldatei-Ladung

Ergebnis:

    Bestanden

Bestätigt wurde:

- MIST wurde geladen
- MOOSE wurde geladen
- CTLD-i18n wurde geladen
- CTLD wurde geladen
- Skynet IADS wurde geladen
- Theater Command Loader wurde gestartet
- Frameworks wurden durch den Loader erkannt
- Core wurde geladen
- World wurde geladen
- Campaign wurde geladen
- Logistics wurde geladen
- Missions wurde geladen
- AI wurde geladen
- Main wurde gestartet
- Runtime-Systeme wurden initialisiert
- Airbase-Scanner wurde ausgeführt
- Zone-Factory wurde ausgeführt
- Loader wurde sauber beendet

Wichtiger Befund:

    Airbase-Scanner registrierte 225 Airbase-/Helipad-Objekte.
    Zone-Factory registrierte 225 Zonen.

Bewertung:

    Die technische Startkette funktioniert.
    Die hohe Zahl erkannter Objekte ist kein Startfehler.
    Das aktuelle Syria-Update liefert sehr viele Airbase-ähnliche Objekte.
    Der nächste technische Schwerpunkt ist die fachliche Klassifizierung und Filterung dieser Objekte.

---

## Aktuelle DEV-Mission

Aktuelle technische Entwicklungsmission:

    Operation_Levant_Reclamation_DEV.miz

Bisheriger Inhalt:

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

Sie ist noch keine spielbare Kampagnenmission.

---

## Testphilosophie

Jeder Test muss eine klare Frage beantworten.

Beispiele:

    Laden die Frameworks korrekt?
    Erkennt der Loader die Frameworks?
    Werden eigene Source-Dateien geladen?
    Startet Main?
    Werden Runtime-Systeme initialisiert?
    Erkennt der Airbase-Scanner DCS-Airbases?
    Klassifiziert der Airbase-Scanner strategische Basen korrekt?
    Erzeugt die Zone-Factory nur geeignete Kampagnenzonen?
    Arbeitet Capture nur auf strategischen Basen?
    Werden Logistikzustände korrekt verändert?
    Werden Missionen korrekt erzeugt?
    Reagiert die AI auf den Kampagnenzustand?
    Funktioniert die IADS-Anbindung?
    Funktionieren F10-Menüs?
    Funktioniert Persistenz?

Nicht getestet wird gleichzeitig:

    vollständige Kampagne
    komplette Frontlinie
    komplette IADS-Struktur
    komplexe KI-Reaktion
    vollständige Persistenz

Diese Bereiche werden erst später kombiniert.

---

## Teststufen

Die Tests werden in mehreren Stufen aufgebaut.

### Stufe 1 — Lade- und Starttests

Ziel:

- Frameworks laden
- eigene Source-Dateien laden
- Loader starten
- Main starten
- Runtime-Systeme initialisieren
- `dcs.log` prüfen

Aktueller Stand:

    Starttest-Variante A bestanden.
    Starttest-Variante B noch offen.

---

### Stufe 2 — World- und Airbase-Tests

Ziel:

- Airbases erfassen
- Airbase-Typen klassifizieren
- strategische Airfields von Helipads trennen
- Akrotiri korrekt erkennen
- syrische Basen korrekt bewerten
- Zone-Factory an gefilterte Basen koppeln

Aktueller Stand:

    Airbase-Scanner läuft.
    Zone-Factory läuft.
    225 Objekte erkannt.
    Klassifizierung fehlt noch.

---

### Stufe 3 — Campaign- und Capture-Tests

Ziel:

- Besitzerstatus prüfen
- Capture-Zustände prüfen
- Capture-Ereignisse speichern
- State als dirty markieren
- nur strategische Basen in Capture-Logik verwenden
- Capture-Debugreport erzeugen

Aktueller Stand:

    Capture-System lädt ohne schweren Lua-Fehler.
    Funktionaler Capture-Test noch offen.

---

### Stufe 4 — Logistics- und CTLD-Tests

Ziel:

- Logistiklieferungen anlegen
- Lieferstatus ändern
- Lieferungen abschließen
- Lieferungen verlieren
- FOBs anlegen
- FOB-Baufortschritt prüfen
- CTLD-Ereignisse später an Theater Command melden

Aktueller Stand:

    Logistics-Module laden ohne schweren Lua-Fehler.
    CTLD-Anbindung noch offen.

---

### Stufe 5 — Mission-Generator-Tests

Ziel:

- Missionen aus Kampagnenzustand erzeugen
- verfügbare Missionen prüfen
- aktive Missionen prüfen
- Missionserfolg prüfen
- Missionen nach geeigneten Zielen filtern
- Missionsgenerator mit Airbase-Klassifizierung verbinden

Aktueller Stand:

    Missionsgenerator lädt ohne schweren Lua-Fehler.
    Funktionaler Missionsgenerator-Test noch offen.

---

### Stufe 6 — AI-Tests

Ziel:

- CAP-Anforderungen erzeugen
- CAP-Zonen registrieren
- CAP-Status verwalten
- MOOSE-Anbindung später testen
- AI-Reaktionen auf Kampagnenfortschritt vorbereiten

Aktueller Stand:

    AI-CAP-Manager lädt ohne schweren Lua-Fehler.
    Reale MOOSE-CAP-Spawns noch offen.

---

### Stufe 7 — IADS-Tests

Ziel:

- Skynet IADS anbinden
- SAM-Sites als Kampagnenobjekte führen
- IADS-Sektoren verwalten
- IADS-Zustand speichern
- SEAD-/DEAD-Ziele erzeugen

Aktueller Stand:

    Skynet IADS wird geladen.
    Theater-Command-IADS-Modul noch nicht implementiert.

---

### Stufe 8 — UI- und F10-Menü-Tests

Ziel:

- F10-Menü-Grundstruktur testen
- Kampagnenstatus anzeigen
- Missionen anzeigen
- Logistikstatus anzeigen
- Debug-Menü optional anzeigen

Aktueller Stand:

    UI-Bereich dokumentiert.
    UI-Lua noch nicht implementiert.

---

### Stufe 9 — Persistenztests

Ziel:

- In-Memory-State exportieren
- State importieren
- DCS-Dateizugriff prüfen
- Save-Dateien schreiben
- Save-Dateien lesen
- Kampagnenfortschritt zwischen Sessions erhalten

Aktueller Stand:

    In-Memory-Persistenz vorbereitet.
    DCS-Dateipersistenz noch nicht getestet.
    DCS-Sandbox-Verhalten noch offen.

---

## Starttest-Variante A

Status:

    Bestanden

Ziel:

    sichere Einzeldatei-Ladung im Mission Editor

Diese Variante lädt alle aktiven Dateien einzeln per `DO SCRIPT FILE`.

Grund:

- keine harte Abhängigkeit von `dofile`
- klare Fehlereingrenzung
- jede Datei wird im DCS-Kontext getestet
- gut geeignet für den ersten technischen Starttest
- Fehler lassen sich über `dcs.log` klar zuordnen

Getestete Reihenfolge:

    TIME MORE 1
    DO SCRIPT FILE: vendor/mist/mist.lua

    TIME MORE 2
    DO SCRIPT FILE: vendor/moose/Moose.lua

    TIME MORE 3
    DO SCRIPT FILE: vendor/ctld/CTLD-i18n.lua

    TIME MORE 4
    DO SCRIPT FILE: vendor/ctld/CTLD.lua

    TIME MORE 5
    DO SCRIPT FILE: vendor/skynet-iads/SkynetIADS.lua

    TIME MORE 7
    DO SCRIPT FILE: src/core/tc_config.lua

    TIME MORE 8
    DO SCRIPT FILE: src/core/tc_logger.lua

    TIME MORE 9
    DO SCRIPT FILE: src/core/tc_state.lua

    TIME MORE 10
    DO SCRIPT FILE: src/core/tc_utils.lua

    TIME MORE 11
    DO SCRIPT FILE: src/core/tc_scheduler.lua

    TIME MORE 12
    DO SCRIPT FILE: src/world/tc_airbase_scanner.lua

    TIME MORE 13
    DO SCRIPT FILE: src/world/tc_zone_factory.lua

    TIME MORE 14
    DO SCRIPT FILE: src/campaign/tc_capture_system.lua

    TIME MORE 15
    DO SCRIPT FILE: src/campaign/tc_persistence_system.lua

    TIME MORE 16
    DO SCRIPT FILE: src/logistics/tc_logistics_delivery.lua

    TIME MORE 17
    DO SCRIPT FILE: src/logistics/tc_fob_system.lua

    TIME MORE 18
    DO SCRIPT FILE: src/missions/tc_mission_generator.lua

    TIME MORE 19
    DO SCRIPT FILE: src/ai/tc_ai_cap_manager.lua

    TIME MORE 20
    DO SCRIPT FILE: src/main.lua

    TIME MORE 22
    DO SCRIPT FILE: src/loader.lua

Erwartetes Ergebnis:

    Mission läuft mindestens 35 Sekunden ohne schweren Theater-Command-Lua-Abbruch.
    dcs.log enthält erfolgreiche TC-Startausgaben.
    Frameworks werden erkannt.
    Main startet.
    Runtime-Systeme werden initialisiert.

Tatsächliches Ergebnis:

    Bestanden.

---

## Ergebnis Starttest-Variante A

Wichtige bestätigte Logik:

    MIST erkannt
    MOOSE erkannt
    CTLD erkannt
    Skynet IADS erkannt
    Core geladen
    World geladen
    Campaign geladen
    Logistics geladen
    Missions geladen
    AI geladen
    Main gestartet
    Loader beendet

Wichtige positive Log-Einträge:

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

World-Test:

    Airbase scan completed: 225 airbases registered
    Zone factory completed: 225 zones registered

Bewertung:

    Theater Command startet technisch korrekt.
    Die aktive Source-Grundstruktur ist im DCS Mission Scripting Environment lauffähig.
    Die hohe Airbase-Zahl ist kein Ladefehler.
    Die Airbase-Klassifizierung ist der nächste technische Schwerpunkt.

---

## Starttest-Variante B

Status:

    Noch nicht durchgeführt

Ziel:

    Loader-only-Test mit dofile

Idee:

Im Mission Editor werden nur die Frameworks und danach `src/loader.lua` geladen.

Der Loader soll dann prüfen, ob er die restlichen eigenen Source-Dateien über `dofile` nachladen kann.

Geplante Reihenfolge:

    TIME MORE 1
    DO SCRIPT FILE: vendor/mist/mist.lua

    TIME MORE 2
    DO SCRIPT FILE: vendor/moose/Moose.lua

    TIME MORE 3
    DO SCRIPT FILE: vendor/ctld/CTLD-i18n.lua

    TIME MORE 4
    DO SCRIPT FILE: vendor/ctld/CTLD.lua

    TIME MORE 5
    DO SCRIPT FILE: vendor/skynet-iads/SkynetIADS.lua

    TIME MORE 7
    DO SCRIPT FILE: src/loader.lua

Prüffokus:

- Funktioniert `dofile` im DCS Mission Scripting Environment?
- Kennt `loader.lua` seinen Script-Root?
- Können lokale Dateien aus dem Repository-Pfad nachgeladen werden?
- Blockiert die DCS-Sandbox den Zugriff?
- Muss später weiter mit Einzeldatei-Ladung gearbeitet werden?
- Brauchen wir eine Build-Datei für den Mission Editor?

Wichtig:

    Variante B wird erst nach sauberer Aufgabenaufnahme in einer späteren Session vorbereitet.

---

## `dcs.log` prüfen

Die Log-Datei liegt normalerweise hier:

    C:\Users\Paul\Saved Games\DCS\Logs\dcs.log

Oder bei älterer Open-Beta-/Standalone-Struktur:

    C:\Users\Paul\Saved Games\DCS.openbeta\Logs\dcs.log

Schneller Explorer-Pfad:

    %USERPROFILE%\Saved Games

Danach prüfen:

    DCS\Logs\dcs.log

oder:

    DCS.openbeta\Logs\dcs.log

Wichtige Suchbegriffe:

    TC
    Theater Command
    ERROR
    error
    stack traceback
    attempt to index
    nil value
    cannot open
    MIST
    MOOSE
    CTLD
    Skynet

---

## Testbewertung

Ein Test gilt als bestanden, wenn:

- kein schwerer Lua-Abbruch mit Theater-Command-Bezug auftritt
- die erwarteten TC-Logeinträge erscheinen
- die getesteten Module geladen werden
- die Testfrage beantwortet ist
- das Ergebnis in GitHub dokumentiert ist

Ein Test gilt als nicht bestanden, wenn:

- ein Lua-Fehlerfenster erscheint
- `dcs.log` einen `stack traceback` mit TC-Bezug enthält
- eine Pflichtdatei nicht geladen wird
- ein Framework nicht erkannt wird
- `Main` nicht startet
- Runtime-Systeme nicht initialisiert werden
- ein Modul einen kritischen `nil value`-Fehler verursacht

Ein Test kann trotzdem als technisch bestanden gelten, wenn:

- DCS/Syria interne Warnungen auftreten
- Texturen fehlen
- DCS interne ATC-Fehler auftreten
- ein nicht genutztes DCS-System Warnungen erzeugt
- diese Meldungen keinen TC-Bezug haben und die Theater-Command-Startkette sauber durchläuft

---

## Bekannte DCS-/Syria-Meldungen

Im ersten Test traten auch DCS-/Syria-interne Meldungen auf.

Beispiele:

    INVALID ATC HI08
    missing object declaration
    texture not found
    DTC_MANAGER Window pointer is null

Bewertung:

    Diese Meldungen sind aktuell kein Theater-Command-Blocker.
    Entscheidend sind Lua-Fehler mit TC-Bezug, stack tracebacks oder fehlgeschlagene Framework-/Source-Ladung.

---

## Airbase-Testbefund nach Syria-Update

Der erste Airbase-Test ergab:

    225 Airbase-/Helipad-Objekte

Das ist ein wichtiger Befund.

Problem:

Nicht jedes DCS-Airbase-Objekt ist eine strategische Kampagnenbasis.

Mögliche Objektarten:

- große Airfields
- kleinere Airfields
- Heliports
- Helipads
- Medical Pads
- FARPs
- sonstige taktische Pads

Folgerung:

    Der Airbase-Scanner muss erweitert werden.
    Die Zone-Factory darf nicht ungefiltert 225 strategische Kampagnenzonen erzeugen.
    Capture-System und Missionsgenerator dürfen nicht ungefiltert auf alle Airbase-Objekte zugreifen.

Nächster Testfokus:

- Airbase-Klassifizierung
- Airbase-Debugreport
- getrennte Zählung nach Objektart
- strategische Basenliste
- nicht-strategische Pads separat speichern

---

## Geplante nächste Tests

### Airbase-Klassifizierungstest

Ziel:

- alle erkannten Objekte klassifizieren
- strategische Basen zählen
- Helipads zählen
- Medical Pads zählen
- Heliports zählen
- sonstige Objekte zählen
- Akrotiri korrekt als strategische Blue-Startbasis markieren

Erwartetes Ergebnis:

    dcs.log zeigt getrennte Zählung nach Klassen.
    Strategische Basen werden separat geführt.
    Helipads und Medical Pads werden nicht als strategische Kampagnenbasen verwendet.

---

### Zone-Factory-Filtertest

Ziel:

- Zone-Factory an Airbase-Klassifizierung koppeln
- strategische Zonen separat erzeugen
- Hilfszonen für Helipads separat erzeugen oder zurückstellen
- Capture-Zonen nicht für jedes Pad erzeugen

Erwartetes Ergebnis:

    Zone-Factory erzeugt nicht mehr ungefiltert 225 strategische Zonen.

---

### Capture-Grundtest

Ziel:

- Capture-System nur mit strategischen Basen testen
- Besitzerstatus lesen
- Besitzerstatus setzen
- State dirty setzen
- Capture-Event protokollieren

Erwartetes Ergebnis:

    Capture-System verändert Testbasis kontrolliert und schreibt saubere Logausgaben.

---

### Loader-only-Test

Ziel:

- Starttest-Variante B durchführen
- `dofile` praktisch prüfen
- spätere Ladevariante entscheiden

Erwartetes Ergebnis:

    Entweder Loader-only funktioniert oder DCS-Sandbox-Grenzen werden sauber dokumentiert.

---

## Noch nicht getestete Systeme

Noch nicht funktional getestet:

- Airbase-Klassifizierung
- Debug-Airbase-Report
- Capture-Funktionslogik
- Logistics-Funktionslogik
- CTLD-Anbindung
- FOB-Funktionslogik
- Missionsgenerator-Funktionslogik
- AI-CAP-Spawns mit MOOSE
- IADS-Kampagnenbrücke
- UI/F10-Menüs
- Persistenz in Datei
- Loader-only mit `dofile`
- Save-/Load-System
- Multiplayer-Verhalten

---

## Aktuelle Testentscheidung

Der aktuelle technische Stand ist ausreichend stabil, um mit dem nächsten Code-Schritt fortzufahren.

Nächster technischer Schritt:

    Airbase-Scanner nach dem Syria-Update fachlich filtern

Nicht als nächstes:

    keine neue große Mission-Editor-Struktur
    keine rote Frontlinie
    keine IADS-Großstruktur
    keine CTLD-Zonen
    keine F10-Menüs

Grund:

Zuerst muss geklärt werden, welche der 225 erkannten Objekte strategische Kampagnenbasen sind.

---

## Aktueller Status

Starttest-Variante A ist bestanden.

Die Theater-Command-Startkette läuft in DCS.

Die nächste Testphase betrifft die Airbase-Klassifizierung und nicht die Erweiterung der Mission-Editor-Bühne.
