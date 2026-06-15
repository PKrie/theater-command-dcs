# MIST Framework

Dieser Ordner ist für das externe Framework MIST vorgesehen.

MIST ist eine externe Bibliothek und gehört deshalb in den Ordner `vendor/`.

Theater Command DCS verändert MIST nicht. Eigene Projektlogik wird nicht in diesem Ordner geschrieben, sondern unter `src/`.

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

MIST ist nicht die Architektur des Projekts.

Theater Command DCS bleibt das eigentliche Kampagnensystem.

---

## Erwartete Datei

Die spätere MIST-Hauptdatei soll hier abgelegt werden:

    vendor/mist/mist.lua

Diese Datei wird später aus der offiziellen MIST-Quelle ergänzt.

Aktuell wird in diesem Schritt nur die Ordnerdokumentation vorbereitet.

---

## Wichtige Projektregel

Dateien in `vendor/mist/` werden nicht verändert.

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

---

## Versionierung

Beim späteren Einfügen von MIST sollen folgende Informationen ergänzt werden:

    MIST version: TBD
    Source: TBD
    Date added: TBD
    Local changes: none

Lokale Änderungen an MIST sind nicht vorgesehen.

Wenn später eine neue MIST-Version benötigt wird, wird die Framework-Datei vollständig ersetzt und die Version hier dokumentiert.

---

## Test nach Einbindung

Nach dem Einfügen von `mist.lua` soll geprüft werden:

- Mission startet ohne Lua-Fehler
- `vendor/mist/mist.lua` wird im Mission Editor gefunden
- MIST lädt vor CTLD
- CTLD lädt danach ohne fehlende MIST-Abhängigkeiten
- `dcs.log` enthält keine MIST-bezogenen Fehler
- Theater Command Loader startet erst nach den externen Frameworks

---

## Projektregel

MIST ist ein Werkzeug.

Theater Command DCS bleibt das Kampagnensystem.

Die Struktur des Projekts richtet sich nach Aufgaben, nicht nach Frameworks.
