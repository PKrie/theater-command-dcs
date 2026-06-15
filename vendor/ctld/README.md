# CTLD Framework

Dieser Ordner enthält das externe Framework **CTLD** für Theater Command DCS.

CTLD ist eine externe Bibliothek und gehört deshalb in den Ordner `vendor/`.

Theater Command DCS verändert CTLD nicht. Eigene Projektlogik wird nicht in diesem Ordner geschrieben, sondern unter `src/`.

---

## Aktueller Inhalt dieses Ordners

Dieser Ordner enthält aktuell:

    vendor/ctld/README.md
    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua

Bedeutung:

- `CTLD-i18n.lua` enthält die Internationalisierungs- und Übersetzungsstruktur für CTLD.
- `CTLD.lua` ist die eigentliche CTLD-Framework-Datei.
- `README.md` dokumentiert die Nutzung von CTLD innerhalb von Theater Command DCS.

Nicht hinterlegt sind aktuell:

    vendor/ctld/beacon.ogg
    vendor/ctld/beaconsilent.ogg

Diese Sounddateien werden nur benötigt, wenn CTLD-Radio-Beacons aktiv genutzt werden sollen.

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

## Framework-Dateien

Die aktiven CTLD-Dateien liegen unter:

    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua

Diese Dateinamen bleiben im Projekt bewusst stabil.

Wenn später eine neue CTLD-Version eingespielt wird, werden die Dateien wieder unter denselben Pfaden abgelegt.

Die genaue Version wird in dieser README dokumentiert.

---

## Versionierung

Aktueller Stand:

    CTLD version: 1.6.1
    File used by project: vendor/ctld/CTLD.lua
    I18N file used by project: vendor/ctld/CTLD-i18n.lua
    Source: ciribob/DCS-CTLD
    Source branch/release line: master / v1.6.1
    Date added: 2026-06-15
    Local changes: none

Hinweis:

CTLD wird im Projekt unverändert als externes Framework geführt.

Eigene Theater-Command-Logistiklogik wird nicht in `CTLD.lua` geschrieben.

---

## MIST-Abhängigkeit

CTLD benötigt MIST.

Die offizielle CTLD-Dokumentation weist darauf hin, dass MIST vor CTLD geladen werden muss.

Außerdem weist `CTLD.lua` darauf hin, dass für korrektes dynamisches Spawning die mit CTLD gelieferte MIST-Version verwendet werden soll.

Theater Command DCS verwendet deshalb aktuell bewusst die CTLD-kompatible MIST-Datei unter:

    vendor/mist/mist.lua

Aktive Kombination:

    MIST: 4.5.128-DYNSLOTS-02
    CTLD: 1.6.1

Diese Kombination soll zunächst beibehalten werden.

Bei späteren CTLD-Updates muss geprüft werden, ob auch die zugehörige MIST-Version aktualisiert werden muss.

---

## Wichtige Projektregel

Dateien in `vendor/ctld/` werden grundsätzlich nicht verändert.

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

Das syrische Festland ist zu Kampagnenbeginn rot kontrolliert.

CTLD soll später genutzt werden, um Akrotiri als ersten blauen Logistikhub aufzubauen.

Mögliche spätere Aufgaben:

- Transport von Versorgungskisten ab Akrotiri
- Aufbau vorgeschobener FOBs
- Verstärkung eroberter Basen
- Versorgung von Capture-Zonen
- logistische Voraussetzung für neue Missionen
- Unterstützung der schrittweisen Rückeroberung des syrischen Festlands

Logistik soll ein wichtiger Teil des Fortschritts von Blau werden.

---

## Sounddateien für Radio-Beacons

CTLD kann Radio-Beacons nutzen.

Dafür werden normalerweise folgende Sounddateien benötigt:

    beacon.ogg
    beaconsilent.ogg

Diese Dateien sind aktuell nicht im Projekt hinterlegt.

Das ist für den jetzigen Stand in Ordnung, solange CTLD-Radio-Beacons noch nicht aktiv genutzt werden.

Wenn Radio-Beacons später genutzt werden sollen, müssen die Sounddateien separat ergänzt und im Mission Editor korrekt eingebunden werden.

Geplante Zielpfade wären dann:

    vendor/ctld/beacon.ogg
    vendor/ctld/beaconsilent.ogg

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
- einfache Dropoff-Zonen können erkannt werden
- CTLD Dynamic Spawns funktionieren mit der aktiven MIST-Version
- `dcs.log` enthält keine CTLD-bezogenen Fehler
- Theater Command Loader startet erst nach den externen Frameworks

---

## Aktualisierung bei neuer CTLD-Version

Wenn später eine neue CTLD-Version eingespielt wird:

1. offizielle CTLD-Quelle prüfen
2. `vendor/ctld/CTLD-i18n.lua` ersetzen
3. `vendor/ctld/CTLD.lua` ersetzen
4. prüfen, ob CTLD eine eigene MIST-Version mitliefert
5. prüfen, ob `vendor/mist/mist.lua` ebenfalls aktualisiert werden muss
6. Version in dieser README aktualisieren
7. `Local changes: none` nur beibehalten, wenn die Dateien wirklich unverändert übernommen wurden
8. Missionstest durchführen

Die Dateinamen bleiben weiterhin:

    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua

---

## Projektregel

CTLD ist ein Werkzeug.

Theater Command DCS bleibt das Kampagnensystem.

Die Struktur des Projekts richtet sich nach Aufgaben, nicht nach Frameworks.
