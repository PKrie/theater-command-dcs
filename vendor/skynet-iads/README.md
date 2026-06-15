# Skynet IADS Framework

Dieser Ordner enthält das externe Framework **Skynet IADS** für Theater Command DCS.

Skynet IADS ist eine externe Bibliothek und gehört deshalb in den Ordner `vendor/`.

Theater Command DCS verändert Skynet IADS nicht. Eigene Projektlogik wird nicht in diesem Ordner geschrieben, sondern unter `src/`.

---

## Aktueller Inhalt dieses Ordners

Dieser Ordner enthält aktuell:

    vendor/skynet-iads/README.md
    vendor/skynet-iads/SkynetIADS.lua

Bedeutung:

- `SkynetIADS.lua` ist die aktive Skynet-IADS-Framework-Datei.
- `README.md` dokumentiert die Nutzung von Skynet IADS innerhalb von Theater Command DCS.

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
- spätere Verbindung mit dem Missionsgenerator

Skynet IADS ist nicht die Architektur des Projekts.

Theater Command DCS bleibt das eigentliche Kampagnensystem.

---

## Framework-Datei

Die aktive Skynet-IADS-Hauptdatei liegt unter:

    vendor/skynet-iads/SkynetIADS.lua

Dieser Dateiname bleibt im Projekt bewusst stabil.

Die ursprüngliche Quelldatei heißt im offiziellen Repository:

    skynet-iads-compiled.lua

Für Theater Command DCS wird sie unter folgendem stabilen Projektnamen geführt:

    SkynetIADS.lua

Wenn später eine neue Skynet-IADS-Version eingespielt wird, wird die neue kompilierte Framework-Datei wieder als `SkynetIADS.lua` abgelegt.

Die genaue Version wird in dieser README dokumentiert.

---

## Versionierung

Aktueller Stand:

    Skynet IADS version: 3.3.0
    Build time: 29.12.2023 2311Z
    File used by project: vendor/skynet-iads/SkynetIADS.lua
    Source: walder/Skynet-IADS
    Source file: demo-missions/skynet-iads-compiled.lua
    Date added: 2026-06-15
    Local changes: none

Hinweis:

Skynet IADS wird im Projekt nicht aus einzelnen Source-Dateien zusammengesetzt.

Verwendet wird die fertig kompilierte Datei aus dem offiziellen Skynet-IADS-Repository.

Der Inhalt wird nicht verändert.

Nur der Dateiname wird für Theater Command DCS stabil auf `SkynetIADS.lua` gesetzt.

---

## MIST-Abhängigkeit

Skynet IADS benötigt MIST.

Die offizielle Skynet-IADS-Dokumentation weist darauf hin, dass MIST und die kompilierte Skynet-IADS-Datei in die Mission geladen werden müssen.

Theater Command DCS verwendet aktuell folgende MIST-Datei:

    vendor/mist/mist.lua

Aktive Kombination:

    MIST: 4.5.128-DYNSLOTS-02
    Skynet IADS: 3.3.0

Diese MIST-Version ist neuer als die ältere MIST-Version, die in früheren Skynet-IADS-Beispielen genannt wurde.

Da MIST zusätzlich für CTLD benötigt wird, bleibt aktuell die CTLD-kompatible MIST-Version aktiv.

---

## Wichtige Projektregel

Dateien in `vendor/skynet-iads/` werden grundsätzlich nicht verändert.

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

MIST muss vor Skynet IADS geladen werden.

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

## Test nach Einbindung

Nach dem Einfügen von `SkynetIADS.lua` soll geprüft werden:

- Mission startet ohne Lua-Fehler
- `vendor/skynet-iads/SkynetIADS.lua` wird im Mission Editor gefunden
- MIST lädt vor Skynet IADS
- Skynet IADS lädt vor Theater Command
- einfache IADS-Objekte können initialisiert werden
- Radargruppen können später korrekt an Skynet IADS übergeben werden
- SAM-Gruppen können später korrekt an Skynet IADS übergeben werden
- `dcs.log` enthält keine Skynet-IADS-bezogenen Fehler
- Theater Command Loader startet erst nach den externen Frameworks

---

## Aktualisierung bei neuer Skynet-IADS-Version

Wenn später eine neue Skynet-IADS-Version eingespielt wird:

1. offizielle Skynet-IADS-Quelle prüfen
2. neue kompilierte Datei herunterladen
3. alte Datei `vendor/skynet-iads/SkynetIADS.lua` ersetzen
4. neuen Inhalt unverändert übernehmen
5. Version und Build-Zeit prüfen
6. Version in dieser README aktualisieren
7. `Local changes: none` nur beibehalten, wenn die Datei wirklich unverändert übernommen wurde
8. Missionstest durchführen

Der Dateiname bleibt weiterhin:

    vendor/skynet-iads/SkynetIADS.lua

---

## Projektregel

Skynet IADS ist ein Werkzeug.

Theater Command DCS bleibt das Kampagnensystem.

Die Struktur des Projekts richtet sich nach Aufgaben, nicht nach Frameworks.
