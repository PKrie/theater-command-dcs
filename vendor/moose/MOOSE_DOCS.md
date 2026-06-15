# MOOSE Documentation Reference

Diese Datei dokumentiert die offizielle MOOSE-Dokumentation, die für Theater Command DCS als Entwicklungsreferenz genutzt wird.

Die eigentliche MOOSE-Dokumentation wird nicht vollständig in dieses Repository kopiert.

Stattdessen wird hier die offizielle Quelle dokumentiert.

---

## Offizielle Dokumentation

Offizielle MOOSE-Dokumentation:

    https://flightcontrol-master.github.io/MOOSE_DOCS/Documentation/index.html

Diese Seite enthält den zentralen MOOSE-API-Index.

Sie wird für Theater Command DCS als technische Referenz genutzt.

---

## Zweck dieser Referenz

Die MOOSE-Dokumentation wird später genutzt für:

- Wrapper-Klassen
- Scheduler
- SETs
- Spawning
- Airbase-Wrapper
- Zonenlogik
- AI-Management
- CAP- und GCI-Logik
- OPS-Klassen
- Debug- und Testfunktionen

Die Dokumentation hilft dabei, eigene Theater-Command-Systeme korrekt gegen MOOSE zu entwickeln.

---

## Wichtige MOOSE-Bereiche für Theater Command DCS

Für Theater Command DCS sind besonders folgende MOOSE-Bereiche relevant:

### Core

Relevante Klassen und Bereiche:

- `Core.Base`
- `Core.Database`
- `Core.Event`
- `Core.Menu`
- `Core.Message`
- `Core.Scheduler`
- `Core.Set`
- `Core.Spawn`
- `Core.Zone`

Diese Bereiche werden später vor allem für Grundlogik, Debug, Scheduling, Spawning und Zonen genutzt.

---

### Wrapper

Relevante Klassen und Bereiche:

- `Wrapper.Airbase`
- `Wrapper.Client`
- `Wrapper.Group`
- `Wrapper.Unit`
- `Wrapper.Object`
- `Wrapper.Marker`

Diese Bereiche werden später genutzt, um DCS-Objekte sauber in Theater-Command-Systeme einzubinden.

---

### Functional

Relevante Klassen und Bereiche:

- `Functional.Detection`
- `Functional.DetectionZones`
- `Functional.Sead`
- `Functional.ZoneCaptureCoalition`
- `Functional.Warehouse`

Diese Bereiche können später für Erkennung, SEAD-Verhalten, Zonenlogik und Logistikbewertung interessant werden.

---

### Ops

Relevante Klassen und Bereiche:

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

Diese Bereiche können später für AI Director, CAP/GCI, dynamische Operationen und Missionsgenerierung relevant werden.

---

## Projektregel

MOOSE bleibt ein externes Framework.

Theater Command DCS nutzt MOOSE nur als Werkzeug.

Eigene Logik wird weiterhin unter `src/` entwickelt.

Nicht gewünscht:

    src/tc_moose.lua
    src/tc_all_in_one.lua

Gewünscht ist aufgabenorientierte eigene Logik, zum Beispiel:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua
    src/ai/tc_ai_cap_manager.lua
    src/ai/tc_ai_director.lua
    src/missions/tc_mission_generator.lua

---

## Umgang mit der Online-Dokumentation

Die Online-Dokumentation ist maßgeblich.

Wenn sich MOOSE ändert, kann sich auch die Dokumentation ändern.

Bei späteren MOOSE-Updates soll geprüft werden:

- ob die verwendete MOOSE-Version zur Dokumentation passt
- ob genutzte Klassen noch verfügbar sind
- ob Beispiele aus der Dokumentation noch aktuell sind
- ob neue Klassen für Theater Command DCS nützlich sind

---

## Lokale Kopie

Es wird bewusst keine vollständige lokale HTML-Kopie der MOOSE-Dokumentation abgelegt.

Gründe:

- die Dokumentation ist umfangreich
- HTML-Kopien veralten schnell
- das Repository soll übersichtlich bleiben
- für die Entwicklung ist der offizielle Online-Index ausreichend
- die aktive Framework-Datei liegt bereits lokal unter `vendor/moose/Moose.lua`

Falls später eine Offline-Dokumentation wirklich benötigt wird, wird sie separat geplant und nicht ungeprüft als Website-Kopie in `vendor/moose/` abgelegt.

---

## Aktueller Stand

Aktuelle lokale MOOSE-Datei:

    vendor/moose/Moose.lua

Aktuelle externe Dokumentationsquelle:

    https://flightcontrol-master.github.io/MOOSE_DOCS/Documentation/index.html

Status:

    Documentation reference added
