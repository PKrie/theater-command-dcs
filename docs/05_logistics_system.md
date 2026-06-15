# Logistics System

Diese Datei beschreibt das geplante Logistiksystem von **Theater Command DCS**.

Das Logistiksystem ist ein zentraler Bestandteil der ersten Kampagne **Operation Levant Reclamation**.

Blau startet auf **Zypern / Akrotiri**.

Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

Logistik soll später bestimmen, wie Blau dauerhaft Kräfte an die syrische Küste bringt, vorgeschobene Basen aufbaut und eroberte Gebiete stabilisiert.

---

## Grundprinzip

Das Logistiksystem folgt dem Projektprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Mission Editor stellt nur die notwendigen Startbedingungen bereit.

CTLD übernimmt technische Transportfunktionen.

Theater Command DCS entscheidet über die kampagnenlogische Wirkung.

---

## Rolle von CTLD

CTLD ist das externe Framework für Transport- und Logistikfunktionen.

Aktuelle CTLD-Dateien im Projekt:

    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua

Aktuelle CTLD-Version:

    CTLD 1.6.1

CTLD wird genutzt für:

- Truppentransport
- Kistentransport
- Helikopter-Logistik
- Pickup-Zonen
- Dropoff-Zonen
- FOB-Aufbau
- spätere Logistikaktionen über F10-Menüs

CTLD ist aber nicht das Kampagnensystem.

CTLD führt technische Aktionen aus.

Theater Command DCS bewertet diese Aktionen strategisch.

---

## MIST-Abhängigkeit

CTLD benötigt MIST.

Aktuelle MIST-Datei im Projekt:

    vendor/mist/mist.lua

Aktuelle MIST-Version:

    MIST 4.5.128-DYNSLOTS-02

Diese MIST-Version stammt bewusst aus dem CTLD-Paket.

Grund:

CTLD weist darauf hin, dass für korrektes dynamisches Spawning die mit CTLD gelieferte MIST-Version verwendet werden soll.

Aktive Kombination:

    MIST: 4.5.128-DYNSLOTS-02
    CTLD: 1.6.1

Diese Kombination soll zunächst beibehalten werden.

Bei einem späteren CTLD-Update muss geprüft werden, ob auch MIST aktualisiert werden muss.

---

## Geplante Lade-Reihenfolge

Für Logistik ist die Lade-Reihenfolge besonders wichtig.

Geplante Reihenfolge im DCS Mission Editor:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua
    6. src/loader.lua

Wichtig:

- MIST muss vor CTLD geladen werden.
- `CTLD-i18n.lua` muss vor `CTLD.lua` geladen werden.
- Theater Command DCS startet erst nach CTLD.
- Die eigene Logistiklogik wertet später CTLD-Ereignisse und Zustände aus.

---

## Trennung zwischen CTLD und Theater Command

CTLD macht technische Logistik.

Theater Command DCS macht strategische Logistik.

Beispiel:

CTLD:

    Eine Kiste wurde mit einem Helikopter transportiert und abgesetzt.

Theater Command DCS:

    Diese Kiste zählt als Versorgung für eine Zone.
    Diese Kiste erhöht den Ressourcenstatus einer Basis.
    Diese Kiste ist ein Baustein für einen FOB.
    Diese Kiste beeinflusst eine Capture-Bedingung.
    Diese Kiste schaltet spätere Missionen frei.

Diese Trennung ist verbindlich.

Eigene Theater-Command-Logik wird nicht in `CTLD.lua` geschrieben.

---

## Geplante eigene Dateien

Die eigene Logistiklogik gehört später nach:

    src/logistics/

Geplante Dateien:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua
    src/logistics/tc_logistics_state.lua
    src/logistics/tc_logistics_hubs.lua
    src/logistics/tc_supply_routes.lua

Zusätzliche spätere Dateien:

    src/ui/tc_f10_menu.lua
    src/debug/tc_debug_logistics.lua

---

## Nicht gewünschte Dateien

Nicht gewünscht:

    src/tc_ctld.lua
    src/tc_logistics_all_in_one.lua
    src/tc_all_in_one.lua

Die eigene Struktur wird nach Aufgaben sortiert.

Sie wird nicht nach Frameworks sortiert.

Eine Datei darf CTLD intern nutzen.

Der Dateiname richtet sich aber immer nach der Aufgabe, nicht nach dem Framework.

---

## Geplante Logistikrolle in Operation Levant Reclamation

Zu Beginn startet Blau auf Akrotiri.

Akrotiri ist die erste sichere blaue Basis.

Geplante Rolle von Akrotiri:

- Hauptbasis
- erster Logistikhub
- Startpunkt für Helikopter
- Startpunkt für Transportflüge
- Ausgangspunkt für Versorgungsketten
- Ausgangspunkt für den späteren Küsten-Brückenkopf

Das syrische Festland ist rot kontrolliert.

Deshalb muss Blau später über Logistik:

- Küstenzonen versorgen
- FOBs aufbauen
- eroberte Basen stabilisieren
- Nachschub nachführen
- neue Missionen ermöglichen
- Frontfortschritt absichern

---

## Geplante Logistikhubs

Ein Logistikhub ist eine Basis oder Zone, von der aus Versorgung bereitgestellt wird.

Erster geplanter Logistikhub:

    Akrotiri

Spätere mögliche Logistikhubs:

- eroberte Airbases
- FOBs
- Küsten-Brückenköpfe
- vorbereitete Forward Operating Areas
- logistisch gesicherte Capture-Zonen

Ein Logistikhub soll später im Kampagnenzustand gespeichert werden.

---

## Geplante Pickup-Zonen

Pickup-Zonen sind Orte, an denen CTLD-Truppen oder Kisten aufgenommen werden können.

Erste geplante Pickup-Zonen:

    CTLD_PICKUP_BLUE_AKROTIRI_01
    CTLD_PICKUP_BLUE_AKROTIRI_02

Diese Zonen werden später im Mission Editor angelegt.

Die genaue Mission-Editor-Dokumentation folgt später unter:

    mission_editor/ctld_start_zones.md

---

## Geplante Dropoff-Zonen

Dropoff-Zonen sind Orte, an denen Versorgung kampagnenlogisch wirksam werden kann.

Mögliche erste Dropoff-Zone:

    CTLD_DROPOFF_BLUE_COASTAL_FOB_01

Dropoff-Zonen können später genutzt werden für:

- FOB-Aufbau
- Versorgung einer Capture-Zone
- Verstärkung einer eroberten Basis
- Aufbau eines neuen Logistikhubs
- Missionsfortschritt

Dropoff-Zonen sollen nicht nur CTLD-Zonen sein.

Theater Command DCS soll später entscheiden, welche Wirkung eine Lieferung dort hat.

---

## FOB-System

FOB steht für Forward Operating Base.

Ein FOB soll später als vorgeschobener blauer Stützpunkt dienen.

Geplante FOB-Funktionen:

- logistische Zwischenbasis
- neuer Dropoff-Punkt
- möglicher Pickup-Punkt
- Verstärkungsstandort
- Voraussetzung für bestimmte Missionen
- Stabilisierung einer eroberten Zone
- möglicher Spawn- oder Supportpunkt für spätere Systeme

Geplante Datei:

    src/logistics/tc_fob_system.lua

Das FOB-System soll CTLD nutzen, aber nicht vollständig CTLD überlassen werden.

CTLD kann den Aufbau technisch ermöglichen.

Theater Command DCS entscheidet, ob ein FOB kampagnenlogisch aktiv ist.

---

## Logistikzustand

Der Logistikzustand soll später Teil des Kampagnenzustands werden.

Geplante Datei:

    src/logistics/tc_logistics_state.lua

Mögliche gespeicherte Werte:

- aktive Logistikhubs
- aktive FOBs
- verfügbare Ressourcen
- Versorgungsstatus von Basen
- Versorgungsstatus von Zonen
- letzte Lieferungen
- gesperrte Logistikrouten
- freigeschaltete Pickup-Zonen
- freigeschaltete Dropoff-Zonen

Dieser Zustand wird später wichtig für Persistenz.

---

## Versorgung und Capture-System

Logistik soll später mit dem Capture-System verbunden werden.

Geplante Verbindung:

Eine Zone kann nur gehalten oder erobert werden, wenn bestimmte Bedingungen erfüllt sind.

Mögliche Bedingungen:

- feindliche Kräfte reduziert
- eigene Kräfte in der Zone
- Versorgung geliefert
- FOB aufgebaut
- Airbase gesichert
- IADS-Bedrohung reduziert

Logistik soll dadurch eine echte kampagnenlogische Bedeutung erhalten.

Helikopterspieler und Transportspieler beeinflussen damit direkt den Frontverlauf.

---

## Versorgung und Missionsgenerator

Der Missionsgenerator soll später Logistikzustände auswerten.

Mögliche Missionen:

- Versorgungslieferung
- FOB-Aufbau
- Truppentransport
- Evakuierung
- CSAR
- Konvoischutz
- Angriff auf feindliche Logistik
- Verteidigung eines FOBs
- Wiederherstellung einer unterbrochenen Versorgungslinie

Geplante Verbindung:

    src/logistics/
        ↓
    src/missions/

Der Missionsgenerator soll nicht statisch arbeiten.

Er soll Missionen aus dem aktuellen Kampagnenzustand ableiten.

---

## Versorgung und AI Director

Der AI Director soll später auf Logistik reagieren können.

Mögliche Reaktionen:

- rote Gegenangriffe auf FOBs
- Angriffe auf Logistikzonen
- CAP über wichtigen Nachschubwegen
- Artillerie- oder Raketenangriffe auf FOBs
- Verstärkung gefährdeter roter Basen
- Verteidigung wichtiger Depots
- neue Bedrohungen für Helikopterrouten

Geplante Verbindung:

    src/logistics/
        ↓
    src/ai/

Logistik soll dadurch nicht folgenlos bleiben.

---

## Versorgung und IADS

Logistik kann später auch mit dem IADS-System verbunden werden.

Mögliche Verbindungen:

- rote SAM-Stellungen schützen wichtige Logistikräume
- zerstörte SAM-Stellungen öffnen sichere Helikopterrouten
- FOB-Aufbau wird erst möglich, wenn IADS-Bedrohung reduziert wurde
- zerstörte Radarstellungen erleichtern Nachschubflüge
- rote IADS-Reparatur benötigt eigene Ressourcen

Geplante Verbindung:

    src/logistics/
        ↓
    src/iads/

Diese Verbindung wird erst später umgesetzt.

---

## CTLD-Sounddateien

CTLD kann Radio-Beacons nutzen.

Dafür werden normalerweise folgende Sounddateien benötigt:

    beacon.ogg
    beaconsilent.ogg

Diese Dateien sind aktuell nicht im Projekt hinterlegt.

Das ist für den jetzigen Stand in Ordnung, solange CTLD-Radio-Beacons noch nicht aktiv genutzt werden.

Geplante spätere Zielpfade:

    vendor/ctld/beacon.ogg
    vendor/ctld/beaconsilent.ogg

Diese Dateien werden erst ergänzt, wenn Beacons tatsächlich genutzt werden sollen.

---

## Mission-Editor-Anforderungen

Für das Logistiksystem werden später im Mission Editor mindestens benötigt:

- CTLD-Pickup-Zonen
- CTLD-Dropoff-Zonen
- Helikopter-Client-Slots
- mögliche Logistikobjekte
- mögliche FOB-Aufbaupunkte
- Template-Gruppen für Truppen oder Kisten
- Framework-Lade-Trigger

Diese Elemente werden später separat dokumentiert.

Geplante Datei:

    mission_editor/ctld_start_zones.md

---

## Erste geplante Helikopter-Slots

Erste geplante Helikopter-Slots auf Akrotiri:

    CLIENT_BLUE_UH1H_AKROTIRI_01
    CLIENT_BLUE_MI8_AKROTIRI_01

Weitere Helikopter können später ergänzt werden.

Die genaue Client-Slot-Dokumentation folgt später unter:

    mission_editor/client_slots.md

---

## Debug für Logistik

Ein eigenes Debugsystem soll später helfen, Logistikzustände sichtbar zu machen.

Geplante Datei:

    src/debug/tc_debug_logistics.lua

Mögliche Debug-Ausgaben:

- aktive Logistikhubs
- aktive FOBs
- erkannte CTLD-Zonen
- letzte Lieferungen
- Ressourcenstatus
- Versorgungsstatus je Zone
- Versorgungsstatus je Basis
- Fehler bei CTLD-Anbindung

Debug darf später über F10-Menüs erreichbar sein.

---

## Persistenz der Logistik

Logistikzustände sollen später persistent gespeichert werden.

Mögliche persistente Werte:

- aktive FOBs
- aktive Logistikhubs
- verfügbare Ressourcen
- abgeschlossene Lieferungen
- freigeschaltete Dropoff-Zonen
- Zustand von Versorgungslinien
- Logistikstatus von Basen
- Logistikstatus von Zonen

Persistenz wird aber erst gebaut, wenn klar ist, welche Logistikdaten stabil gebraucht werden.

Geplante spätere Datei:

    src/campaign/tc_persistence_system.lua

---

## Erste Entwicklungsreihenfolge

Die Logistik selbst wird noch nicht sofort gebaut.

Vorher müssen entstehen:

1. `src/`-Unterordner
2. Core-System
3. Airbase-System
4. Zonen-System
5. Capture-System
6. erste Mission-Editor-Testumgebung
7. CTLD-Grundkonfiguration
8. Logistik-Auswertung

Logistik hängt stark von Airbases, Zonen und Capture ab.

Deshalb wird sie nicht isoliert als erstes System umgesetzt.

---

## Testziele

Wenn die Logistik später erstmals eingebunden wird, sollen folgende Punkte getestet werden:

- MIST lädt korrekt
- CTLD-i18n lädt vor CTLD
- CTLD lädt korrekt
- CTLD-Menüs erscheinen für geeignete Helikopter
- Pickup-Zonen werden erkannt
- Dropoff-Zonen werden erkannt
- Kisten können transportiert werden
- Truppen können transportiert werden
- Dynamic Spawns funktionieren mit aktiver MIST-Version
- Theater Command erkennt relevante Lieferungen
- Logistikstatus wird im Debug ausgegeben
- keine CTLD-Fehler in `dcs.log`

---

## Aktueller Status

Aktuell ist nur das externe CTLD-Framework hinterlegt.

Die eigene Theater-Command-Logistiklogik ist noch nicht begonnen.

Aktueller Stand:

    CTLD vorbereitet
    MIST CTLD-kompatibel
    Theater-Command-Logistik noch nicht implementiert

Nächster technischer Fokus nach Abschluss der Dokumentationsaktualisierung:

    src-Unterordner und README-Dateien erstellen

Danach:

    src/loader.lua
    src/main.lua
    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
