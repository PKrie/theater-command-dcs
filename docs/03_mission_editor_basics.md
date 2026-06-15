# Mission Editor Basics

Diese Datei beschreibt die grundlegende Nutzung des DCS Mission Editors für **Theater Command DCS**.

Der Mission Editor ist in diesem Projekt nicht das eigentliche Kampagnensystem.

Der Mission Editor stellt die Bühne bereit.

Die Kampagnenlogik entsteht später durch Lua.

---

## Grundprinzip

Das Projekt folgt dem Prinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Mission Editor soll möglichst schlank bleiben.

Alles, was sinnvoll durch Lua erkannt, berechnet oder gesteuert werden kann, soll nicht als große Triggerkette im Mission Editor gebaut werden.

---

## Rolle des Mission Editors

Der Mission Editor wird später genutzt für:

- Karte auswählen
- Koalitionen festlegen
- Spieler-Slots anlegen
- Frameworks laden
- Theater-Command-Loader laden
- Template-Gruppen vorbereiten
- CTLD-Startzonen vorbereiten
- statische Ziele setzen
- Testumgebung aufbauen

Der Mission Editor wird nicht genutzt für:

- komplette Kampagnenlogik
- manuelle Frontlinienverwaltung
- große Triggerketten für Basenbesitz
- manuelle Missionsgenerierung
- persistente Zustandsverwaltung
- komplexe AI-Director-Logik

Diese Aufgaben gehören später in die Lua-Struktur unter:

    src/

---

## Erste Kampagne

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

Akrotiri ist die erste blaue Hauptbasis.

Das syrische Festland ist zu Kampagnenbeginn rot kontrolliert.

Die erste operative Zielrichtung ist die syrische Küste.

---

## Geplante DEV-Mission

Die erste Entwicklungsmission soll später heißen:

    Operation_Levant_Reclamation_DEV.miz

Geplanter Ablageort:

    mission/dev/

Dieser Ordner existiert aktuell noch nicht.

Er wird erst angelegt, wenn die Mission-Editor-Arbeit beginnt.

---

## Aktueller technischer Stand

Stand:

    2026-06-15

Aktuell vorhanden:

- Projektgrunddokumentation
- `docs/`-Grundblock
- `vendor/`-Frameworks
- `src/README.md`

Aktuell noch nicht vorhanden:

- DEV-Mission
- `src/loader.lua`
- `src/main.lua`
- Mission-Editor-Triggerstruktur
- Spieler-Slots
- Template-Gruppen
- CTLD-Zonen
- Testmission

---

## Frameworks im Mission Editor laden

Die externen Frameworks liegen im Projekt unter:

    vendor/

Aktuell hinterlegte Frameworks:

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Wichtig:

Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket.

Grund:

CTLD weist darauf hin, dass für korrektes dynamisches Spawning die mit CTLD gelieferte MIST-Version verwendet werden soll.

---

## Geplante Lade-Reihenfolge

Die geplante Lade-Reihenfolge im DCS Mission Editor lautet:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua
    6. src/loader.lua

Diese Reihenfolge ist verbindlich.

Wichtig:

- MIST muss vor CTLD geladen werden.
- `CTLD-i18n.lua` muss vor `CTLD.lua` geladen werden.
- Skynet IADS muss nach MIST geladen werden.
- Eigene Theater-Command-Logik startet erst nach allen externen Frameworks.
- `src/loader.lua` wird später der Einstiegspunkt für das eigene Kampagnensystem.

---

## Trigger-Grundstruktur

Die Frameworks sollen später über Mission-Editor-Trigger geladen werden.

Geplantes Grundschema:

    Trigger 1: Load MIST
    Trigger 2: Load MOOSE
    Trigger 3: Load CTLD-i18n
    Trigger 4: Load CTLD
    Trigger 5: Load Skynet IADS
    Trigger 6: Load Theater Command Loader

Die genaue Triggerumsetzung wird später unter folgendem Pfad dokumentiert:

    mission_editor/trigger_setup.md

Diese Datei existiert aktuell noch nicht.

---

## Empfohlene Trigger-Logik

Für die erste DEV-Mission wird später voraussichtlich eine einfache Starttrigger-Struktur genutzt.

Geplantes Muster:

    ONCE - TC_LOAD_MIST
        DO SCRIPT FILE: vendor/mist/mist.lua

    ONCE - TC_LOAD_MOOSE
        DO SCRIPT FILE: vendor/moose/Moose.lua

    ONCE - TC_LOAD_CTLD_I18N
        DO SCRIPT FILE: vendor/ctld/CTLD-i18n.lua

    ONCE - TC_LOAD_CTLD
        DO SCRIPT FILE: vendor/ctld/CTLD.lua

    ONCE - TC_LOAD_SKYNET_IADS
        DO SCRIPT FILE: vendor/skynet-iads/SkynetIADS.lua

    ONCE - TC_LOAD_THEATER_COMMAND
        DO SCRIPT FILE: src/loader.lua

Die endgültige Umsetzung wird erst getestet, wenn `src/loader.lua` existiert.

---

## Warum die Reihenfolge wichtig ist

MIST muss zuerst geladen werden, weil CTLD MIST benötigt.

CTLD-i18n muss vor CTLD geladen werden, weil CTLD die Übersetzungsstruktur erwartet.

Skynet IADS benötigt ebenfalls MIST-Funktionalität und wird daher nach MIST geladen.

Theater Command DCS wird zuletzt geladen, damit die eigene Logik auf die bereits vorhandenen Frameworks zugreifen kann.

---

## Spieler-Slots

Spieler-Slots werden später auf Akrotiri angelegt.

Erste geplante Client-Slots:

    CLIENT_BLUE_FA18C_AKROTIRI_01
    CLIENT_BLUE_FA18C_AKROTIRI_02
    CLIENT_BLUE_F16C_AKROTIRI_01
    CLIENT_BLUE_F16C_AKROTIRI_02
    CLIENT_BLUE_F15E_AKROTIRI_01
    CLIENT_BLUE_F15E_AKROTIRI_02
    CLIENT_BLUE_F14B_AKROTIRI_01
    CLIENT_BLUE_F14B_AKROTIRI_02
    CLIENT_BLUE_UH1H_AKROTIRI_01
    CLIENT_BLUE_MI8_AKROTIRI_01

Die genaue Client-Slot-Dokumentation wird später unter folgendem Pfad angelegt:

    mission_editor/client_slots.md

---

## Koalitionen

Die erste Kampagne nutzt folgende Grundlogik:

Blau:

- USA
- Großbritannien
- mögliche NATO-/Partnerstaaten
- Start auf Zypern / Akrotiri

Rot:

- Syrien
- Russland
- mögliche verbündete rote Kräfte
- Startkontrolle über das syrische Festland

Die genaue Koalitionsverteilung wird später in der DEV-Mission festgelegt und dokumentiert.

---

## Akrotiri

Akrotiri ist die erste blaue Hauptbasis.

Geplante Rolle:

- Startbasis für Spieler
- erster Logistikhub
- Ausgangspunkt für Luftoperationen
- Ausgangspunkt für CTLD-Logistik
- sichere blaue Rückfallbasis
- späterer HQ-Knoten im Kampagnenzustand

Akrotiri soll im Mission Editor sauber vorbereitet werden.

Die strategische Auswertung erfolgt später durch Lua.

---

## Syrisches Festland

Das syrische Festland ist zu Kampagnenbeginn rot kontrolliert.

Im Mission Editor soll diese Ausgangslage sichtbar vorbereitet werden.

Die eigentliche strategische Kontrolle wird später durch Theater Command DCS verwaltet.

Ziel:

Nicht jede Basis manuell mit komplexen Triggern verwalten.

Stattdessen:

- Basen automatisch erkennen
- Besitzstatus per Lua führen
- Capture-Zonen virtuell erzeugen
- Kampagnenfortschritt dynamisch bewerten

---

## Template-Gruppen

Template-Gruppen werden später im Mission Editor mit Late Activation angelegt.

Geplante Nutzung:

- CAP-Templates
- GCI-Templates
- SEAD-/DEAD-Zielgruppen
- Bodentruppen
- Logistikobjekte
- IADS-Komponenten
- statische Ziele
- Testgruppen

Wichtig:

Template-Gruppen sind nur Vorlagen.

Die dynamische Logik entscheidet später, wann und warum sie genutzt werden.

Die Dokumentation erfolgt später unter:

    mission_editor/template_groups.md

---

## CTLD-Zonen

Für CTLD werden später erste Pickup- und Dropoff-Zonen benötigt.

Geplanter Start:

    Akrotiri

Mögliche erste Zonen:

    CTLD_PICKUP_BLUE_AKROTIRI_01
    CTLD_PICKUP_BLUE_AKROTIRI_02
    CTLD_DROPOFF_BLUE_COASTAL_FOB_01

Die genaue Benennung muss mit `NAMING_CONVENTIONS.md` abgestimmt werden.

Die spätere Dokumentation erfolgt unter:

    mission_editor/ctld_start_zones.md

---

## Statische Ziele

Statische Ziele werden später als Kampagnenobjekte vorbereitet.

Mögliche Zielarten:

- Radarstellungen
- SAM-Stellungen
- Depots
- Munitionslager
- Treibstofflager
- Hafenanlagen
- Kommandoposten
- Kommunikationsanlagen

Diese Ziele sollen möglichst sinnvoll benannt werden.

Später kann Theater Command DCS diese Ziele kampagnenlogisch auswerten.

Die Dokumentation erfolgt später unter:

    mission_editor/static_targets.md

---

## Mission Editor und Airbases

Airbases sollen später möglichst automatisch durch Lua erkannt werden.

Der Mission Editor soll nicht für jede Airbase manuelle Triggerzonen enthalten.

Geplantes Vorgehen:

1. DCS-Airbases über Lua erkennen
2. Airbase-Daten in Theater-Command-Struktur überführen
3. wichtige Sonderfälle per Override behandeln
4. virtuelle Zonen erzeugen
5. Besitzstatus durch Theater Command verwalten

Dadurch bleibt der Mission Editor schlanker.

---

## Mission Editor und Persistenz

Persistenz wird nicht im Mission Editor gelöst.

Persistenz wird später unter `src/campaign/` und `save/` vorbereitet.

Geplante Dateien:

    src/campaign/tc_persistence_system.lua
    save/README.md
    save/example_state.lua

Der Mission Editor liefert nur den Startzustand.

Theater Command DCS verwaltet später den gespeicherten Zustand.

---

## Mission Editor und Debug

Debug-Funktionen sollen später über Lua und F10-Menüs erreichbar sein.

Mögliche Debug-Funktionen:

- erkannte Airbases anzeigen
- virtuelle Zonen anzeigen
- Kampagnenstatus anzeigen
- Logistikstatus anzeigen
- IADS-Status anzeigen
- aktive Missionen anzeigen
- Framework-Ladestatus anzeigen

Der Mission Editor selbst soll nicht mit Debug-Triggern überladen werden.

---

## Test nach Framework-Ladung

Nach dem ersten Mission-Editor-Aufbau müssen folgende Punkte geprüft werden:

- Mission startet ohne Lua-Fehler
- MIST lädt korrekt
- MOOSE lädt korrekt
- CTLD-i18n lädt korrekt
- CTLD lädt korrekt
- Skynet IADS lädt korrekt
- Lade-Reihenfolge stimmt
- `dcs.log` enthält keine Framework-Fehler
- spätere Datei `src/loader.lua` wird korrekt geladen
- erste Theater-Command-Debugausgabe erscheint im Log

---

## Nicht jetzt umsetzen

Aktuell noch nicht im Mission Editor bauen:

- komplette Frontlinie
- alle syrischen Airbases manuell als Triggerzonen
- komplexe Basen-Capture-Trigger
- komplette IADS-Struktur
- vollständige rote Großkampagne
- komplette KI-Logik
- Persistenz
- Release-Mission

Diese Dinge werden schrittweise vorbereitet.

---

## Aktueller nächster Schritt

Nach Abschluss der aktuellen Dokumentationsaktualisierung folgt zunächst die weitere `src/`-Grundstruktur.

Nächster technischer Fokus:

    src-Unterordner und README-Dateien erstellen

Danach:

    src/loader.lua
    src/main.lua
    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua

Die eigentliche Mission-Editor-DEV-Mission wird erst begonnen, wenn die erste minimale Lua-Struktur vorhanden ist.
