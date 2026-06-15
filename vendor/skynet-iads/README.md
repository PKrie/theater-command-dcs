# Skynet IADS Framework

Dieser Ordner ist für das externe Framework Skynet IADS vorgesehen.

Skynet IADS ist eine externe Bibliothek und gehört deshalb in den Ordner `vendor/`.

Theater Command DCS verändert Skynet IADS nicht. Eigene Projektlogik wird nicht in diesem Ordner geschrieben, sondern unter `src/`.

---

## Zweck von Skynet IADS

Skynet IADS wird in Theater Command DCS als Framework für integrierte Luftverteidigung genutzt.

Geplante Nutzung:

- IADS-Netzwerke
- Radarlogik
- SAM-Verhalten
- Luftverteidigungssektoren
- SEAD-Reaktionen
- DEAD-Reaktionen
- Emissionskontrolle
- koordinierte Luftverteidigung
- spätere Verbindung mit dem Theater-Command-AI-Director

Skynet IADS ist nicht die Architektur des Projekts.

Theater Command DCS bleibt das eigentliche Kampagnensystem.

---

## Erwartete Datei

Die spätere Skynet-IADS-Hauptdatei soll hier abgelegt werden:

    vendor/skynet-iads/SkynetIADS.lua

Diese Datei wird später aus der offiziellen Skynet-IADS-Quelle ergänzt.

Aktuell wird in diesem Schritt nur die Ordnerdokumentation vorbereitet.

---

## Wichtige Projektregel

Dateien in `vendor/skynet-iads/` werden nicht verändert.

Wenn Theater Command DCS eigenes Verhalten benötigt, wird dieses Verhalten in eigenen Lua-Dateien unter `src/` programmiert.

Nicht gewünscht:

    src/tc_skynet.lua
    src/tc_iads_all_in_one.lua
    src/tc_all_in_one.lua

Gewünscht ist eine aufgabenorientierte Struktur, zum Beispiel:

    src/iads/tc_iads_network.lua
    src/iads/tc_iads_sites.lua
    src/iads/tc_iads_sectors.lua
    src/iads/tc_iads_state.lua
    src/ai/tc_ai_director.lua
    src/missions/tc_mission_generator.lua
    src/campaign/tc_capture_system.lua
    src/debug/tc_debug_iads.lua

Eine eigene Theater-Command-Datei darf intern Skynet-IADS-Funktionen nutzen.

Der Dateiname richtet sich aber immer nach der Aufgabe, nicht nach dem Framework.

---

## Rolle im Ladeprozess

Skynet IADS wird im DCS Mission Editor nach MIST, MOOSE und CTLD geladen.

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

Skynet IADS stellt technische Funktionen für Luftverteidigungsnetzwerke bereit.

Theater Command DCS entscheidet selbst über:

- strategischen IADS-Status
- aktive Luftverteidigungssektoren
- Besitzstatus von Basen und Zonen
- Freischaltung oder Verlust von SAM-Stellungen
- Verbindung zwischen Capture-System und Luftverteidigung
- Verbindung zwischen Missionsgenerator und IADS-Zielen
- KI-Reaktionen auf SEAD- und DEAD-Erfolge
- Persistenz des IADS-Zustands

Skynet IADS darf das taktische Verhalten von Radaren und SAM-Systemen steuern.

Theater Command DCS entscheidet, wann, wo und warum diese Systeme kampagnenlogisch verfügbar sind.

Skynet IADS speichert keinen strategischen Kampagnenzustand für Theater Command DCS.

---

## Geplante Einsatzbereiche

Skynet IADS kann später unter anderem in folgenden Theater-Command-Systemen genutzt werden:

    src/iads/tc_iads_network.lua
    src/iads/tc_iads_sites.lua
    src/iads/tc_iads_sectors.lua
    src/iads/tc_iads_state.lua
    src/missions/tc_mission_generator.lua
    src/ai/tc_ai_director.lua
    src/campaign/tc_capture_system.lua
    src/debug/tc_debug_iads.lua

Die Nutzung von Skynet IADS bleibt dabei immer innerhalb der jeweiligen Aufgabenlogik gekapselt.

Es wird keine zentrale Sammeldatei nur für Skynet IADS erstellt.

---

## Skynet IADS und Operation Levant Reclamation

In der ersten Kampagne startet Blau auf Zypern bei Akrotiri.

Das syrische Festland ist zu Kampagnenbeginn rot kontrolliert.

Skynet IADS soll später genutzt werden, um die rote Luftverteidigung auf dem syrischen Festland glaubwürdig abzubilden.

Mögliche spätere Aufgaben:

- Aufbau eines roten IADS-Netzwerks auf dem syrischen Festland
- Schutz wichtiger Airbases
- Schutz wichtiger Hafen- und Industrieziele
- SAM-Stellungen als SEAD- und DEAD-Ziele
- Radarstellungen als Aufklärungs- und Angriffsziel
- schrittweise Schwächung der roten Luftverteidigung
- Reaktion der roten Seite auf blaue Luftoperationen
- Verbindung von zerstörten IADS-Komponenten mit dem Kampagnenfortschritt

Die Luftverteidigung soll nicht nur statisch vorhanden sein.

Sie soll Teil des dynamischen Kampagnenzustands werden.

---

## Versionierung

Beim späteren Einfügen von Skynet IADS sollen folgende Informationen ergänzt werden:

    Skynet IADS version: TBD
    Source: TBD
    Date added: TBD
    Local changes: none

Lokale Änderungen an Skynet IADS sind nicht vorgesehen.

Wenn später eine neue Skynet-IADS-Version benötigt wird, wird die Framework-Datei vollständig ersetzt und die Version hier dokumentiert.

---

## Test nach Einbindung

Nach dem Einfügen von `SkynetIADS.lua` soll geprüft werden:

- Mission startet ohne Lua-Fehler
- `vendor/skynet-iads/SkynetIADS.lua` wird im Mission Editor gefunden
- Skynet IADS lädt vor Theater Command
- einfache IADS-Objekte können initialisiert werden
- Radar- und SAM-Gruppen können später korrekt an Skynet IADS übergeben werden
- `dcs.log` enthält keine Skynet-IADS-bezogenen Fehler
- Theater Command Loader startet erst nach den externen Frameworks

---

## Projektregel

Skynet IADS ist ein Werkzeug.

Theater Command DCS bleibt das Kampagnensystem.

Die Struktur des Projekts richtet sich nach Aufgaben, nicht nach Frameworks.
