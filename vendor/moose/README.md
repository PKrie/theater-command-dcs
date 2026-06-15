# MOOSE Framework

Dieser Ordner ist für das externe Framework MOOSE vorgesehen.

MOOSE ist eine externe Bibliothek und gehört deshalb in den Ordner `vendor/`.

Theater Command DCS verändert MOOSE nicht. Eigene Projektlogik wird nicht in diesem Ordner geschrieben, sondern unter `src/`.

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

MOOSE ist nicht die Architektur des Projekts.

Theater Command DCS bleibt das eigentliche Kampagnensystem.

---

## Erwartete Datei

Die spätere MOOSE-Hauptdatei soll hier abgelegt werden:

    vendor/moose/Moose.lua

Diese Datei wird später aus der offiziellen MOOSE-Quelle ergänzt.

Aktuell wird in diesem Schritt nur die Ordnerdokumentation vorbereitet.

---

## Wichtige Projektregel

Dateien in `vendor/moose/` werden nicht verändert.

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

MOOSE darf technische Arbeit übernehmen, zum Beispiel Spawning, Scheduling oder Objektverwaltung.

MOOSE speichert keinen strategischen Kampagnenzustand für Theater Command DCS.

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

## Versionierung

Beim späteren Einfügen von MOOSE sollen folgende Informationen ergänzt werden:

    MOOSE version: TBD
    Source: TBD
    Date added: TBD
    Local changes: none

Lokale Änderungen an MOOSE sind nicht vorgesehen.

Wenn später eine neue MOOSE-Version benötigt wird, wird die Framework-Datei vollständig ersetzt und die Version hier dokumentiert.

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

## Projektregel

MOOSE ist ein Werkzeug.

Theater Command DCS bleibt das Kampagnensystem.

Die Struktur des Projekts richtet sich nach Aufgaben, nicht nach Frameworks.
