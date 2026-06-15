# MOOSE Framework

Dieser Ordner enthält das externe Framework **MOOSE** für Theater Command DCS.

MOOSE ist eine externe Bibliothek und gehört deshalb in den Ordner `vendor/`.

Theater Command DCS verändert MOOSE nicht. Eigene Projektlogik wird nicht in diesem Ordner geschrieben, sondern unter `src/`.

---

## Aktueller Inhalt dieses Ordners

Dieser Ordner enthält aktuell:

    vendor/moose/README.md
    vendor/moose/Moose.lua
    vendor/moose/MOOSE_DOCS.md

Bedeutung:

- `Moose.lua` ist die eigentliche MOOSE-Framework-Datei.
- `MOOSE_DOCS.md` dokumentiert die offizielle MOOSE-Online-Dokumentation als Entwicklungsreferenz.
- `README.md` dokumentiert die Nutzung von MOOSE innerhalb von Theater Command DCS.

---

## Zweck von MOOSE

MOOSE wird in Theater Command DCS als objektorientierte DCS-Framework-Schicht genutzt.

Geplante Nutzung:

- Wrapper für DCS-Objekte
- Scheduler
- SETs
- Spawning
- CAP- und GCI-Management
- AI-Management
- Zonenlogik
- Airbase-Wrapper
- dynamische Missionslogik
- Debug- und Testfunktionen
- spätere Unterstützung für AI Director und Missionsgenerator

MOOSE ist nicht die Architektur des Projekts.

Theater Command DCS bleibt das eigentliche Kampagnensystem.

---

## Framework-Datei

Die MOOSE-Hauptdatei liegt unter:

    vendor/moose/Moose.lua

Dieser Dateiname bleibt im Projekt bewusst stabil.

Wenn später eine neue MOOSE-Version eingespielt wird, wird die neue Framework-Datei wieder als `Moose.lua` abgelegt.

Die genaue Version und Quelle werden in dieser README dokumentiert.

---

## Dokumentationsreferenz

Die MOOSE-Dokumentationsreferenz liegt unter:

    vendor/moose/MOOSE_DOCS.md

Diese Datei verweist auf die offizielle MOOSE-Online-Dokumentation:

    https://flightcontrol-master.github.io/MOOSE_DOCS/Documentation/index.html

Die vollständige HTML-Dokumentation wird bewusst nicht lokal in dieses Repository kopiert.

Gründe:

- die Dokumentation ist sehr umfangreich
- lokale HTML-Kopien veralten schnell
- das Repository soll übersichtlich bleiben
- die offizielle Online-Dokumentation bleibt die maßgebliche Referenz

---

## Versionierung

Aktueller Stand:

    MOOSE version: 2.9.17
    File used by project: vendor/moose/Moose.lua
    Source: FlightControl-Master/MOOSE_INCLUDE
    Source file: Moose_Include_Static/Moose.lua
    Release line: master-ng
    Date added: 2026-06-15
    Local changes: none

Hinweis:

MOOSE wird im Projekt nicht aus dem Quellcode-Repository selbst gebaut.

Verwendet wird die fertige Include-Datei aus dem offiziellen MOOSE-include Repository.

Die Datei wird im Projekt dauerhaft unter folgendem Pfad geführt:

    vendor/moose/Moose.lua

---

## Wichtige Projektregel

Dateien in `vendor/moose/` werden grundsätzlich nicht verändert.

Wenn Theater Command DCS eigenes Verhalten benötigt, wird dieses Verhalten in eigenen Lua-Dateien unter `src/` programmiert.

Nicht gewünscht:

    src/tc_moose.lua
    src/tc_all_in_one.lua

Gewünscht ist eine aufgabenorientierte Struktur, zum Beispiel:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua
    src/campaign/tc_capture_system.lua
    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua
    src/missions/tc_mission_generator.lua
    src/ai/tc_ai_cap_manager.lua
    src/ai/tc_ai_director.lua
    src/campaign/tc_persistence_system.lua

Eine eigene Theater-Command-Datei darf intern MOOSE-Klassen und MOOSE-Funktionen nutzen.

Der Dateiname richtet sich aber immer nach der Aufgabe, nicht nach dem Framework.

---

## Rolle im Ladeprozess

MOOSE wird im DCS Mission Editor nach MIST und vor Theater Command geladen.

Geplante Lade-Reihenfolge:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua
    6. src/loader.lua

Wichtig:

MIST wird vor MOOSE geladen.

MOOSE wird vor der eigenen Theater-Command-Logik geladen.

Der eigene Theater-Command-Loader wird erst gestartet, nachdem die externen Frameworks verfügbar sind.

---

## Abgrenzung zu Theater Command DCS

MOOSE stellt Framework-Funktionen und DCS-Abstraktionen bereit.

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

MOOSE darf technische Arbeit übernehmen, zum Beispiel:

- Spawning
- Scheduling
- Objektverwaltung
- Gruppenverwaltung
- Zonenprüfung
- Wrapper-Zugriffe
- AI-Steuerung auf technischer Ebene

MOOSE speichert keinen strategischen Kampagnenzustand für Theater Command DCS.

Theater Command DCS entscheidet, welche kampagnenlogische Bedeutung die technischen Ergebnisse haben.

---

## Geplante Einsatzbereiche

MOOSE kann später unter anderem in folgenden Theater-Command-Systemen genutzt werden:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua
    src/missions/tc_mission_generator.lua
    src/ai/tc_ai_cap_manager.lua
    src/ai/tc_ai_gci_manager.lua
    src/ai/tc_ai_director.lua
    src/debug/tc_debug_zones.lua

Die Nutzung von MOOSE bleibt dabei immer innerhalb der jeweiligen Aufgabenlogik gekapselt.

Es wird keine zentrale Sammeldatei nur für MOOSE erstellt.

---

## Wichtige MOOSE-Bereiche für Theater Command DCS

Für Theater Command DCS sind später besonders folgende MOOSE-Bereiche interessant:

### Core

- `Core.Base`
- `Core.Database`
- `Core.Event`
- `Core.Menu`
- `Core.Message`
- `Core.Scheduler`
- `Core.Set`
- `Core.Spawn`
- `Core.Zone`

### Wrapper

- `Wrapper.Airbase`
- `Wrapper.Client`
- `Wrapper.Group`
- `Wrapper.Unit`
- `Wrapper.Object`
- `Wrapper.Marker`

### Functional

- `Functional.Detection`
- `Functional.DetectionZones`
- `Functional.Sead`
- `Functional.ZoneCaptureCoalition`
- `Functional.Warehouse`

### Ops

- `Ops.Airwing`
- `Ops.AWACS`
- `Ops.Chief`
- `Ops.Commander`
- `Ops.EasyGCICAP`
- `Ops.FlightGroup`
- `Ops.Intel`
- `Ops.Operation`
- `Ops.OpsZone`
- `Ops.PlayerTask`
- `Ops.Squadron`

Diese Bereiche werden erst dann konkret genutzt, wenn die passenden Theater-Command-Systeme entstehen.

---

## Test nach Einbindung

Nach dem Einfügen von `Moose.lua` soll geprüft werden:

- Mission startet ohne Lua-Fehler
- `vendor/moose/Moose.lua` wird im Mission Editor gefunden
- MOOSE lädt nach MIST
- MOOSE lädt vor Theater Command
- einfache MOOSE-Klassen sind verfügbar
- `dcs.log` enthält keine MOOSE-bezogenen Fehler
- Theater Command Loader startet erst nach den externen Frameworks

---

## Aktualisierung bei neuer MOOSE-Version

Wenn später eine neue MOOSE-Version eingespielt wird:

1. alte Datei `vendor/moose/Moose.lua` ersetzen
2. neuen Inhalt unverändert übernehmen
3. Quelle und Release-Linie prüfen
4. Version in dieser README aktualisieren
5. `Local changes: none` nur beibehalten, wenn die Datei wirklich unverändert übernommen wurde
6. Missionstest durchführen

Der Dateiname bleibt weiterhin:

    vendor/moose/Moose.lua

---

## Projektregel

MOOSE ist ein Werkzeug.

Theater Command DCS bleibt das Kampagnensystem.

Die Struktur des Projekts richtet sich nach Aufgaben, nicht nach Frameworks.
