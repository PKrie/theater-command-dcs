# MIST Framework

Dieser Ordner enthält das externe Framework **MIST** für Theater Command DCS.

MIST ist eine externe Bibliothek und gehört deshalb in den Ordner `vendor/`.

Theater Command DCS verändert MIST nicht. Eigene Projektlogik wird nicht in diesem Ordner geschrieben, sondern unter `src/`.

---

## Aktueller Inhalt dieses Ordners

Dieser Ordner enthält aktuell:

    vendor/mist/README.md
    vendor/mist/mist.lua
    vendor/mist/Mist guide.pdf
    vendor/mist/Example_DBs/

Bedeutung:

- `mist.lua` ist die aktive MIST-Framework-Datei.
- `Mist guide.pdf` ist das zugehörige MIST-Handbuch.
- `Example_DBs/` enthält Beispiel- und Referenzdateien zu MIST-Datenbanken.
- `README.md` dokumentiert die Nutzung von MIST innerhalb von Theater Command DCS.

Die Dateien in `Example_DBs/` sind Referenzmaterial.

Sie werden nicht automatisch durch Theater Command DCS geladen.

---

## Zweck von MIST

MIST wird in Theater Command DCS als Utility-Schicht genutzt.

Geplante Nutzung:

- DCS-Hilfsfunktionen
- Datenbankfunktionen
- Gruppenlogik
- Koordinatenlogik
- Hilfsfunktionen für dynamische Missionen
- technische Grundlage für CTLD
- Unterstützung bei dynamischem Spawning und Event-Auswertung
- Hilfsfunktionen für spätere Test- und Debugsysteme

MIST ist nicht die Architektur des Projekts.

Theater Command DCS bleibt das eigentliche Kampagnensystem.

---

## Framework-Datei

Die MIST-Hauptdatei liegt unter:

    vendor/mist/mist.lua

Dieser Dateiname bleibt im Projekt bewusst stabil.

Wenn später eine neue MIST-Version eingespielt wird, wird die neue Framework-Datei wieder als `mist.lua` abgelegt.

Die genaue Version wird in dieser README dokumentiert.

---

## Versionierung

Aktueller Stand:

    MIST version: 4.5.128-DYNSLOTS-02
    File used by project: vendor/mist/mist.lua
    Source: ciribob/DCS-CTLD
    Source file: mist.lua from CTLD package
    Date added: 2026-06-15
    Local changes: none

Hinweis:

Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket.

Grund dafür ist der Hinweis in `vendor/ctld/CTLD.lua`, dass für korrektes dynamisches Spawning die mit CTLD gelieferte MIST-Version verwendet werden soll.

Die interne Versionsdefinition der aktiven Datei meldet:

    mist.majorVersion = 4
    mist.minorVersion = 5
    mist.build = "128-DYNSLOTS-02"

Vorher war im Projekt eine andere MIST-Datei mit internem Build `4.5.125` hinterlegt.

Diese wurde ersetzt, damit MIST und CTLD zusammenpassen.

---

## Wichtige Projektregel

Dateien in `vendor/mist/` werden grundsätzlich nicht verändert.

Wenn Theater Command DCS eigenes Verhalten benötigt, wird dieses Verhalten in eigenen Lua-Dateien unter `src/` programmiert.

Nicht gewünscht:

    src/tc_mist.lua
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

Eine eigene Theater-Command-Datei darf intern MIST-Funktionen nutzen.

Der Dateiname richtet sich aber immer nach der Aufgabe, nicht nach dem Framework.

---

## Rolle im Ladeprozess

MIST wird im DCS Mission Editor vor CTLD und vor Theater Command geladen.

Geplante Lade-Reihenfolge:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua
    6. src/loader.lua

Wichtig:

CTLD wird erst nach MIST geladen.

`CTLD-i18n.lua` wird vor `CTLD.lua` geladen.

Der eigene Theater-Command-Loader wird erst gestartet, nachdem die externen Frameworks verfügbar sind.

---

## Abgrenzung zu Theater Command DCS

MIST stellt Hilfsfunktionen bereit.

Theater Command DCS entscheidet selbst über:

- Kampagnenzustand
- Basenbesitz
- virtuelle Zonen
- Capture-Logik
- Logistikstatus
- Missionsgenerator
- KI-Reaktionen
- IADS-Verknüpfung
- Persistenz

MIST speichert keinen strategischen Kampagnenzustand für Theater Command DCS.

MIST darf technische Hilfsarbeit leisten.

Theater Command DCS entscheidet, welche kampagnenlogische Bedeutung diese technischen Ergebnisse haben.

---

## Umgang mit dem MIST-Handbuch

Das Handbuch liegt unter:

    vendor/mist/Mist guide.pdf

Es dient als lokale Projektreferenz.

Das Handbuch wird nicht durch DCS geladen.

Es ist nur für Entwicklung, Nachschlagen und spätere Dokumentation gedacht.

---

## Umgang mit Example_DBs

Die Beispiel-Datenbanken liegen unter:

    vendor/mist/Example_DBs/

Diese Dateien dienen nur als Referenz.

Sie sind hilfreich, um die Struktur von MIST-Datenbanken besser zu verstehen.

Sie werden nicht automatisch geladen.

Sie sind kein aktiver Bestandteil des Theater-Command-Kampagnensystems.

---

## CTLD-Kompatibilität

CTLD nutzt MIST als technische Grundlage.

Da `vendor/ctld/CTLD.lua` ausdrücklich auf die mit CTLD gelieferte MIST-Version verweist, verwendet Theater Command DCS aktuell bewusst die MIST-Datei aus dem CTLD-Paket.

Aktive Kombination:

    MIST: 4.5.128-DYNSLOTS-02
    CTLD: 1.6.1

Diese Kombination soll zunächst beibehalten werden.

Bei späteren CTLD-Updates muss geprüft werden, ob auch die zugehörige MIST-Version aktualisiert werden muss.

---

## Test nach Einbindung

Nach dem Einfügen von `mist.lua` soll geprüft werden:

- Mission startet ohne Lua-Fehler
- `vendor/mist/mist.lua` wird im Mission Editor gefunden
- MIST lädt vor CTLD
- CTLD lädt danach ohne fehlende MIST-Abhängigkeiten
- `dcs.log` enthält keine MIST-bezogenen Fehler
- Theater Command Loader startet erst nach den externen Frameworks
- einfache MIST-Funktionen sind nach dem Laden verfügbar
- CTLD Dynamic Spawns funktionieren mit der aktiven MIST-Version

---

## Aktualisierung bei neuer MIST-Version

Wenn später eine neue MIST-Version eingespielt wird:

1. prüfen, ob CTLD eine eigene MIST-Version mitliefert
2. prüfen, ob CTLD diese Version ausdrücklich benötigt
3. alte Datei `vendor/mist/mist.lua` ersetzen
4. neuen Inhalt unverändert übernehmen
5. interne Versionsnummer prüfen
6. Version in dieser README aktualisieren
7. `Local changes: none` nur beibehalten, wenn die Datei wirklich unverändert übernommen wurde
8. Missionstest durchführen

Der Dateiname bleibt weiterhin:

    vendor/mist/mist.lua

---

## Projektregel

MIST ist ein Werkzeug.

Theater Command DCS bleibt das Kampagnensystem.

Die Struktur des Projekts richtet sich nach Aufgaben, nicht nach Frameworks.
