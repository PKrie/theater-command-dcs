# CTLD Framework

Dieser Ordner ist für das externe Framework CTLD vorgesehen.

CTLD ist eine externe Bibliothek und gehört deshalb in den Ordner `vendor/`.

Theater Command DCS verändert CTLD nicht. Eigene Projektlogik wird nicht in diesem Ordner geschrieben, sondern unter `src/`.

---

## Zweck von CTLD

CTLD wird in Theater Command DCS als Logistik- und Helikopter-Framework genutzt.

Geplante Nutzung:

- Truppentransport
- Kistentransport
- Logistikflüge
- FOB-Aufbau
- Heli-Interaktion
- Pickup-Zonen
- Dropoff-Zonen
- Transportaufträge
- spätere Verbindung mit dem Theater-Command-Logistiksystem

CTLD ist nicht die Architektur des Projekts.

Theater Command DCS bleibt das eigentliche Kampagnensystem.

---

## Erwartete Dateien

Die späteren CTLD-Hauptdateien sollen hier abgelegt werden:

    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua

Diese Dateien werden später aus der offiziellen CTLD-Quelle ergänzt.

Aktuell wird in diesem Schritt nur die Ordnerdokumentation vorbereitet.

---

## Wichtige Projektregel

Dateien in `vendor/ctld/` werden nicht verändert.

Wenn Theater Command DCS eigenes Verhalten benötigt, wird dieses Verhalten in eigenen Lua-Dateien unter `src/` programmiert.

Nicht gewünscht:

    src/tc_ctld.lua
    src/tc_all_in_one.lua

Gewünscht ist eine aufgabenorientierte Struktur, zum Beispiel:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua
    src/campaign/tc_capture_system.lua
    src/world/tc_zone_factory.lua
    src/missions/tc_mission_generator.lua
    src/ui/tc_f10_menu.lua

Eine eigene Theater-Command-Datei darf intern CTLD-Funktionen nutzen.

Der Dateiname richtet sich aber immer nach der Aufgabe, nicht nach dem Framework.

---

## Rolle im Ladeprozess

CTLD wird im DCS Mission Editor nach MIST geladen.

Geplante Lade-Reihenfolge:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua
    6. src/loader.lua

Wichtig:

MIST muss vor CTLD geladen werden.

`CTLD-i18n.lua` muss vor `CTLD.lua` geladen werden.

Der eigene Theater-Command-Loader wird erst gestartet, nachdem die externen Frameworks verfügbar sind.

---

## Abgrenzung zu Theater Command DCS

CTLD stellt Transport- und Logistikfunktionen bereit.

Theater Command DCS entscheidet selbst über:

- strategischen Logistikstatus
- verfügbare Ressourcen
- aktive Logistikhubs
- FOB-Status
- Verbindung zwischen Lieferungen und Basenbesitz
- Freischaltung neuer Missionen
- Kampagnenfortschritt
- Persistenz des Logistikzustands

CTLD darf technische Transportvorgänge übernehmen.

Theater Command DCS entscheidet, welche Auswirkungen diese Vorgänge auf die Kampagne haben.

CTLD speichert keinen strategischen Kampagnenzustand für Theater Command DCS.

---

## Geplante Einsatzbereiche

CTLD kann später unter anderem in folgenden Theater-Command-Systemen genutzt werden:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua
    src/campaign/tc_capture_system.lua
    src/world/tc_zone_factory.lua
    src/missions/tc_mission_generator.lua
    src/ui/tc_f10_menu.lua
    src/debug/tc_debug_logistics.lua

Die Nutzung von CTLD bleibt dabei immer innerhalb der jeweiligen Aufgabenlogik gekapselt.

Es wird keine zentrale Sammeldatei nur für CTLD erstellt.

---

## CTLD und Operation Levant Reclamation

In der ersten Kampagne startet Blau auf Zypern bei Akrotiri.

CTLD soll später genutzt werden, um Akrotiri als ersten blauen Logistikhub aufzubauen.

Mögliche spätere Aufgaben:

- Transport von Versorgungskisten ab Akrotiri
- Aufbau vorgeschobener FOBs
- Verstärkung eroberter Basen
- Versorgung von Capture-Zonen
- logistische Voraussetzung für neue Missionen
- Unterstützung der schrittweisen Rückeroberung des syrischen Festlands

Das syrische Festland ist zu Kampagnenbeginn rot kontrolliert.

Logistik soll deshalb ein wichtiger Teil des Fortschritts von Blau werden.

---

## Versionierung

Beim späteren Einfügen von CTLD sollen folgende Informationen ergänzt werden:

    CTLD version: TBD
    Source: TBD
    Date added: TBD
    Local changes: none

Lokale Änderungen an CTLD sind nicht vorgesehen.

Wenn später eine neue CTLD-Version benötigt wird, werden die Framework-Dateien vollständig ersetzt und die Version hier dokumentiert.

---

## Test nach Einbindung

Nach dem Einfügen von `CTLD-i18n.lua` und `CTLD.lua` soll geprüft werden:

- Mission startet ohne Lua-Fehler
- `vendor/ctld/CTLD-i18n.lua` wird im Mission Editor gefunden
- `vendor/ctld/CTLD.lua` wird im Mission Editor gefunden
- MIST lädt vor CTLD
- `CTLD-i18n.lua` lädt vor `CTLD.lua`
- CTLD lädt vor Theater Command
- CTLD-Menüs erscheinen für geeignete Helikopter
- einfache Pickup-Zonen können erkannt werden
- `dcs.log` enthält keine CTLD-bezogenen Fehler
- Theater Command Loader startet erst nach den externen Frameworks

---

## Projektregel

CTLD ist ein Werkzeug.

Theater Command DCS bleibt das Kampagnensystem.

Die Struktur des Projekts richtet sich nach Aufgaben, nicht nach Frameworks.
