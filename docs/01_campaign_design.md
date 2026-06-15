# Campaign Design

Diese Datei beschreibt das Kampagnendesign der ersten Theater-Command-DCS-Kampagne.

Die erste Kampagne trägt den Arbeitstitel:

**Operation Levant Reclamation**

Die Kampagne wird auf der **Syria Map** aufgebaut.

Blau startet auf **Zypern / Akrotiri**.

Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Grundidee der Kampagne

Operation Levant Reclamation soll keine lineare Einzelmission werden.

Ziel ist eine dynamische Kampagne, in der sich der Zustand des Einsatzraums schrittweise verändert.

Spieleraktionen sollen später Auswirkungen haben auf:

- Basenbesitz
- Luftverteidigung
- Logistik
- Missionsangebot
- KI-Reaktionen
- Frontentwicklung
- Persistenz
- strategische Kontrolle

Die Kampagne soll nicht nur aus einzelnen vordefinierten Missionen bestehen.

Sie soll aus einem Kampagnenzustand heraus Missionen erzeugen.

---

## Ausgangslage

Blau startet auf:

    Akrotiri / Zypern

Rot kontrolliert zu Beginn:

    syrisches Festland vollständig

Die erste operative Richtung ist:

    syrische Küste

Die erste strategische Herausforderung für Blau ist der Aufbau eines sicheren Zugangs zum syrischen Festland.

Dafür müssen mehrere Dinge zusammenspielen:

- Luftüberlegenheit
- Schwächung der roten Luftverteidigung
- Aufbau einer Logistikverbindung
- Sicherung eines Küsten-Brückenkopfes
- spätere Eroberung und Stabilisierung von Basen

---

## Projektprinzip

Das Kampagnendesign folgt dem technischen Projektprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Mission Editor stellt die Karte, Slots, Templates und Startbedingungen bereit.

Lua steuert später den dynamischen Kampagnenverlauf.

GitHub hält fest, welche Regeln, Systeme und Entscheidungen gelten.

---

## Aktueller Projektstand

Stand:

    2026-06-15

Aktuell vorhanden:

- zentrale Projektdateien
- `docs/`-Grundblock
- `vendor/`-Frameworks
- `src/README.md`

Aktuell hinterlegte Frameworks:

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Noch nicht vorhanden:

- eigene Lua-Core-Dateien
- `src/loader.lua`
- `src/main.lua`
- Airbase-System
- Capture-System
- Logistiksystem
- Missionsgenerator
- AI Director
- IADS-Kampagnenlogik
- Persistenz
- DEV-Mission im DCS Mission Editor

---

## Strategische Ausgangssituation

Die blaue Seite verfügt zu Beginn über eine sichere Basis auf Zypern.

Diese Basis ist:

    Akrotiri

Akrotiri dient zunächst als:

- Hauptbasis
- Luftoperationsbasis
- erster Logistikhub
- Ausgangspunkt für CTLD-Logistik
- sicherer Rückzugsraum
- späterer HQ-Knoten im Kampagnenzustand

Die rote Seite kontrolliert zu Beginn das syrische Festland.

Rot verfügt perspektivisch über:

- Airbases
- IADS
- SAM-Stellungen
- Radarstellungen
- Bodentruppen
- Logistikknoten
- statische Ziele
- mögliche Gegenangriffskräfte

---

## Kampagnenziel

Langfristiges Ziel von Blau:

    schrittweise Rückeroberung und Stabilisierung relevanter Bereiche des syrischen Festlands

Erstes operatives Ziel:

    rote Luftverteidigung an der Küste schwächen

Erstes logistisches Ziel:

    Brückenkopf oder FOB an der syrischen Küste aufbauen

Erstes strategisches Ziel:

    sichere Grundlage für weitere Operationen auf dem Festland schaffen

---

## Kampagnenphasen

Die Kampagne soll später in dynamische Phasen gegliedert werden.

Diese Phasen sind zunächst konzeptionell.

Die konkrete Umsetzung erfolgt später über Lua.

---

### Phase 1 — Initial Air Operations

Blau startet ausschließlich von Akrotiri.

Schwerpunkte:

- Aufklärung
- CAP
- Escort
- erste SEAD-/DEAD-Missionen
- Angriffe auf Radarstellungen
- Schwächung der Küsten-IADS
- Vorbereitung eines späteren Brückenkopfes

Mögliche Spielerrollen:

- F/A-18C
- F-16C
- F-14B
- F-15E

Ziel:

    sichere Luftoperationsfenster über der syrischen Küste schaffen

---

### Phase 2 — Coastal Suppression

Die rote Küstenverteidigung wird gezielt geschwächt.

Schwerpunkte:

- SEAD
- DEAD
- Strike gegen SAM-Komponenten
- Strike gegen Radarstellungen
- CAP zur Absicherung von Strike-Paketen
- erste Logistikvorbereitung

Ziel:

    rote Luftverteidigung soweit schwächen, dass Helikopter- und Logistikoperationen möglich werden

---

### Phase 3 — Logistics Entry

Blau beginnt mit Logistikoperationen Richtung syrischer Küste.

Schwerpunkte:

- CTLD-Kistenflüge
- Truppentransport
- Versorgung vorbereiteter Dropoff-Zonen
- Aufbau eines ersten FOB
- Sicherung von Helikopterrouten
- Schutz durch CAP und SEAD

Mögliche Spielerrollen:

- UH-1H
- Mi-8
- F/A-18C
- F-16C
- F-14B
- F-15E

Ziel:

    ersten blauen Brückenkopf auf dem Festland kampagnenlogisch vorbereiten

---

### Phase 4 — First Capture Operations

Blau beginnt mit ersten Capture-Operationen.

Schwerpunkte:

- Sicherung von Capture-Zonen
- Unterstützung durch CAS
- Luftnahunterstützung für Bodentruppen
- Logistiklieferungen
- Eroberung oder Neutralisierung erster Schlüsselräume
- Stabilisierung des Brückenkopfes

Mögliche spätere Spielerrollen:

- A-10C II
- AH-64D
- UH-1H
- Mi-8
- F/A-18C
- F-16C

Ziel:

    dauerhafte blaue Präsenz auf dem syrischen Festland herstellen

---

### Phase 5 — Expansion Inland

Nach erfolgreichem Brückenkopf kann Blau weiter ins Landesinnere vorstoßen.

Schwerpunkte:

- weitere Airbases bedrohen oder erobern
- rote Logistik schwächen
- IADS-Lücken ausnutzen
- FOBs ausbauen
- neue Logistikhubs freischalten
- KI-Gegenangriffe abwehren

Ziel:

    Kampagnenraum dynamisch erweitern

---

## Spielerrollen

Die Kampagne soll mehrere Spielerrollen sinnvoll einbinden.

### Fighter / Air Superiority

Mögliche Aufgaben:

- CAP
- Intercept
- Escort
- Fleet Defense
- Schutz von Strike-Paketen
- Schutz von Logistikrouten

Mögliche Module:

- F-14B
- F/A-18C
- F-16C
- F-15E

---

### Strike / SEAD / DEAD

Mögliche Aufgaben:

- Angriff auf Radarstellungen
- Angriff auf SAM-Stellungen
- Angriff auf Kommandoposten
- Angriff auf Depots
- Schwächung der roten Luftverteidigung

Mögliche Module:

- F/A-18C
- F-16C
- F-15E

---

### CAS

Mögliche Aufgaben:

- Unterstützung von Capture-Zonen
- Bekämpfung roter Bodentruppen
- Verteidigung eigener FOBs
- Unterstützung eigener Gegenangriffe

Mögliche Module:

- A-10C II
- AH-64D
- F/A-18C
- F-16C

A-10C II und AH-64D werden erst sinnvoll, wenn Blau auf dem Festland eine nutzbare Struktur aufgebaut hat.

---

### Logistics / Helicopter

Mögliche Aufgaben:

- CTLD-Kistentransport
- Truppentransport
- FOB-Aufbau
- Versorgung von Capture-Zonen
- CSAR
- Verlegung von Material

Mögliche Module:

- UH-1H
- Mi-8

---

## Airbase-Design

Airbases sollen später nicht komplett manuell im Mission Editor verwaltet werden.

Geplantes Prinzip:

1. Airbases per Lua erkennen
2. Airbases als Theater-Command-BaseNodes registrieren
3. Besitzstatus verwalten
4. virtuelle Zonen erzeugen
5. Airbases mit Logistik, Missionen und Capture verbinden

Akrotiri ist der erste fest definierte blaue Ausgangspunkt.

Syrische Airbases sind zu Beginn rot.

Spätere Airbase-Logik entsteht unter:

    src/world/
    src/campaign/

---

## Zonen-Design

Zonen sollen später soweit möglich virtuell durch Lua erzeugt werden.

Geplante Zonentypen:

- Capture-Zonen
- Logistik-Zonen
- Defense-Zonen
- IADS-Sektoren
- Missions-Zielräume
- FOB-Zonen

Nicht jede Zone soll manuell im Mission Editor angelegt werden.

Manuelle Zonen werden nur genutzt, wenn CTLD oder DCS sie technisch benötigt.

---

## Capture-Design

Das Capture-System soll später entscheiden, wann eine Zone oder Basis den Besitzer wechselt.

Mögliche Capture-Faktoren:

- eigene Kräfte in der Zone
- feindliche Kräfte reduziert
- Logistikversorgung vorhanden
- FOB aufgebaut
- IADS-Bedrohung reduziert
- Airbase gesichert
- Missionserfolge erreicht

Capture soll nicht durch einfache DCS-AutoCapture-Logik bestimmt werden.

Theater Command DCS soll den Besitz kampagnenlogisch verwalten.

---

## Logistik-Design

Logistik soll ein zentraler Fortschrittsfaktor sein.

CTLD übernimmt technische Transportfunktionen.

Theater Command DCS bewertet die Wirkung.

Beispiele:

Eine gelieferte Kiste kann später:

- Ressourcen erhöhen
- einen FOB-Aufbau unterstützen
- eine Zone versorgen
- eine Basis stabilisieren
- neue Missionen freischalten
- Capture-Bedingungen erfüllen

Erster Logistikhub:

    Akrotiri

Mögliche erste CTLD-Zonen:

    CTLD_PICKUP_BLUE_AKROTIRI_01
    CTLD_PICKUP_BLUE_AKROTIRI_02
    CTLD_DROPOFF_BLUE_COASTAL_FOB_01

---

## IADS-Design

Die rote Luftverteidigung soll ein wichtiger Kampagnenfaktor sein.

Skynet IADS steuert taktisches Verhalten.

Theater Command DCS bewertet den strategischen IADS-Zustand.

Mögliche IADS-Auswirkungen:

- SEAD/DEAD-Missionen werden sinnvoll
- Helikopterrouten werden gefährlicher oder sicherer
- Strike-Fenster entstehen
- Capture wird durch Luftverteidigung erschwert
- zerstörte Radarstellungen beeinflussen Folgeoperationen
- IADS-Schäden werden später persistent gespeichert

Mögliche erste IADS-Region:

    syrische Küste

---

## Missionsdesign

Missionen sollen später aus dem Kampagnenzustand entstehen.

Missionen werden nicht einfach als feste Triggerliste gebaut.

Der Missionsgenerator soll berücksichtigen:

- Spielerflugzeug
- aktuelle Frontlage
- Basenbesitz
- Logistikstatus
- IADS-Zustand
- verfügbare Ziele
- Kampagnenphase

Mögliche Missionstypen:

- CAP
- Escort
- Intercept
- SEAD
- DEAD
- Strike
- CAS
- Logistics
- FOB Supply
- CSAR
- Recon

---

## AI Director

Der AI Director soll die Welt reaktiver machen.

Mögliche Aufgaben:

- rote CAP erzeugen
- rote GCI erzeugen
- Gegenangriffe vorbereiten
- Reaktion auf Capture-Ereignisse
- Reaktion auf IADS-Schäden
- Reaktion auf Logistikfortschritt
- Eskalation je nach Kampagnenphase

Der AI Director soll nicht alles zufällig machen.

Er soll aus dem Kampagnenzustand sinnvolle Reaktionen ableiten.

---

## Persistenz-Design

Persistenz wird erst später gebaut.

Vorher müssen Airbase-, Capture- und Logistiksystem stabil sein.

Mögliche persistente Werte:

- Basenbesitz
- Zonenbesitz
- aktive FOBs
- Ressourcen
- Logistikstatus
- IADS-Zustand
- zerstörte Ziele
- Missionshistorie
- Kampagnenphase

Persistenz wird nicht am Anfang umgesetzt.

Zuerst muss klar sein, welche Daten stabil gespeichert werden müssen.

---

## Mission-Editor-Design

Der Mission Editor stellt später nur die Bühne bereit.

Geplante Mission:

    Operation_Levant_Reclamation_DEV.miz

Der Mission Editor enthält später:

- Syria Map
- Koalitionen
- Spieler-Slots
- Lade-Trigger
- Template-Gruppen
- CTLD-Zonen
- statische Ziele
- erste Testumgebung

Der Mission Editor enthält nicht:

- große Kampagnenlogik
- große Basen-Triggerketten
- manuelle Frontlinienlogik
- manuelle Missionsgeneratorlogik
- Persistenzlogik

---

## Erster spielbarer Zielzustand

Ein erster spielbarer Zielzustand könnte sein:

- Mission lädt alle Frameworks korrekt
- Theater Command Loader startet
- Akrotiri wird als blaue Startbasis erkannt
- erste Spieler-Slots funktionieren
- erste CTLD-Pickup-Zone funktioniert
- einfache Statusausgabe über F10 funktioniert
- erste Airbase-Liste wird erkannt
- erste Debug-Ausgabe erscheint im `dcs.log`

Dieser Zustand ist noch keine vollständige Kampagne.

Er ist der erste technische Meilenstein.

---

## Nicht jetzt umsetzen

Aktuell noch nicht bauen:

- komplette rote Großkampagne
- komplette Frontlinie
- alle syrischen Airbases manuell konfigurieren
- vollständiges IADS-Netz
- vollständige Persistenz
- große Mission-Editor-Triggerketten
- komplette dynamische Missionslogik
- vollständige KI-Gegenoffensive

Diese Systeme werden schrittweise aufgebaut.

---

## Aktueller nächster technischer Schritt

Nach Abschluss der aktuellen Dokumentationsaktualisierung:

    src-Unterordner und README-Dateien erstellen

Danach:

    src/loader.lua
    src/main.lua
    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
