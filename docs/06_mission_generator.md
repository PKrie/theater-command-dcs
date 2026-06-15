# Mission Generator

Diese Datei beschreibt den geplanten Missionsgenerator von **Theater Command DCS**.

Der Missionsgenerator soll später aus dem aktuellen Kampagnenzustand dynamische Aufgaben erzeugen.

Die erste Kampagne trägt den Arbeitstitel:

**Operation Levant Reclamation**

Die Kampagne wird auf der **Syria Map** aufgebaut.

Blau startet auf **Zypern / Akrotiri**.

Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Grundprinzip

Der Missionsgenerator folgt dem Projektprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Missionen sollen später nicht primär als feste Triggerketten im Mission Editor gebaut werden.

Stattdessen soll Theater Command DCS Missionen aus dem aktuellen Kampagnenzustand ableiten.

---

## Ziel des Missionsgenerators

Der Missionsgenerator soll später passende Aufgaben erzeugen abhängig von:

- Spielerflugzeug
- Kampagnenphase
- Basenbesitz
- Zonenstatus
- Logistikstatus
- IADS-Zustand
- AI-Director-Lage
- verfügbaren Zielen
- Entfernung zu Spielerbasis
- strategischer Priorität

Der Spieler soll nicht einfach eine starre Missionsliste erhalten.

Der Spieler soll Aufgaben erhalten, die zur aktuellen Lage passen.

---

## Aktueller Projektstand

Stand:

    2026-06-15

Aktuell vorhanden:

- zentrale Projektdokumentation
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

- `src/missions/tc_mission_generator.lua`
- `src/missions/tc_mission_registry.lua`
- `src/missions/tc_mission_types.lua`
- `src/missions/tc_mission_filter_by_aircraft.lua`
- eigene F10-Missionsmenüs
- eigene Missionsauswertung
- eigene Missionspersistenz

---

## Geplante eigene Dateien

Die Missionslogik gehört später nach:

    src/missions/

Geplante Dateien:

    src/missions/tc_mission_generator.lua
    src/missions/tc_mission_registry.lua
    src/missions/tc_mission_types.lua
    src/missions/tc_mission_filter_by_aircraft.lua
    src/missions/tc_mission_air_superiority.lua
    src/missions/tc_mission_sead_dead.lua
    src/missions/tc_mission_strike.lua
    src/missions/tc_mission_cas.lua
    src/missions/tc_mission_logistics.lua
    src/missions/tc_mission_csar.lua
    src/missions/tc_mission_recon.lua

Zusätzliche spätere Dateien:

    src/ui/tc_mission_menu.lua
    src/ui/tc_f10_menu.lua
    src/debug/tc_debug_missions.lua

---

## Nicht gewünschte Dateien

Nicht gewünscht:

    src/tc_mission_generator_all_in_one.lua
    src/tc_moose_missions.lua
    src/tc_mist_missions.lua
    src/tc_all_in_one.lua

Die eigene Struktur wird nach Aufgaben sortiert.

Sie wird nicht nach Frameworks sortiert.

Eine Datei darf MIST, MOOSE, CTLD oder Skynet IADS intern nutzen.

Der Dateiname richtet sich aber immer nach der Aufgabe, nicht nach dem Framework.

---

## Missionen aus Kampagnenzustand

Missionen sollen später aus dem Theater-Command-State entstehen.

Mögliche Eingangsdaten:

- aktive blaue Basen
- aktive rote Basen
- neutrale oder umkämpfte Zonen
- verfügbare Logistikhubs
- aktive FOBs
- bekannte IADS-Stellungen
- zerstörte IADS-Stellungen
- aktive rote CAP/GCI-Bedrohung
- verfügbare Spielerflugzeuge
- Kampagnenphase
- bisherige Missionshistorie

Der Missionsgenerator soll daraus geeignete Aufgaben ableiten.

---

## Spielerflugzeug erkennen

Der Missionsgenerator soll später erkennen, welches Flugzeug der Spieler nutzt.

Daraus ergibt sich, welche Missionen sinnvoll sind.

Beispiele:

### F/A-18C

Mögliche Missionen:

- CAP
- Escort
- SEAD
- DEAD
- Strike
- CAS
- Anti-Ship optional
- Recon optional

---

### F-16C

Mögliche Missionen:

- CAP
- Escort
- SEAD
- DEAD
- Strike
- Interdiction
- CAS light

---

### F-15E

Mögliche Missionen:

- Strike
- Deep Strike
- Interdiction
- DEAD
- Escort optional
- CAS optional

---

### F-14B

Mögliche Missionen:

- CAP
- Intercept
- Fleet Defense
- Escort
- Strike optional
- TARPS-Recon optional, wenn später gewünscht

---

### A-10C II

Mögliche Missionen:

- CAS
- Armed Recon
- FOB Defense
- Convoy Attack
- Capture Support

A-10C II wird erst sinnvoll, wenn Blau auf dem Festland oder von einem vorgeschobenen Standort aus operieren kann.

---

### AH-64D

Mögliche Missionen:

- CAS
- Armed Recon
- FOB Defense
- Anti-Armor
- Capture Support

AH-64D wird erst sinnvoll, wenn ein FOB oder eine Festlandbasis aktiv ist.

---

### UH-1H und Mi-8

Mögliche Missionen:

- CTLD-Logistik
- Truppentransport
- Kistentransport
- FOB-Aufbau
- CSAR
- Versorgung von Capture-Zonen

---

## Missionsarten

Der Missionsgenerator soll später verschiedene Missionsarten erzeugen können.

Geplante Missionsarten:

    CAP
    INTERCEPT
    ESCORT
    SEAD
    DEAD
    STRIKE
    CAS
    LOGISTICS
    FOB_SUPPLY
    CSAR
    RECON
    CONVOY_ATTACK
    BASE_DEFENSE
    IADS_ATTACK

Diese Missionsarten werden später schrittweise umgesetzt.

Nicht alle Missionsarten werden sofort gebaut.

---

## Missionsdatenmodell

Eine Mission soll später als eigene Theater-Command-Struktur geführt werden.

Vorläufiges Datenmodell:

    mission = {
      id = "MISSION_SEAD_LATTAKIA_01",
      type = "SEAD",
      title = "Suppress coastal SAM site near Latakia",
      status = "AVAILABLE",
      priority = 80,
      targetId = "IADS_RED_SAM_SA6_LATTAKIA_01",
      targetRegion = "SYRIAN_COAST",
      requiredAircraft = {
        "FA18C",
        "F16C"
      },
      originBase = "AKROTIRI",
      campaignEffect = {
        iadsSuppression = true,
        unlockLogisticsRoute = false
      }
    }

Diese Struktur ist konzeptionell.

Die genaue technische Umsetzung erfolgt später in Lua.

---

## Missionsstatus

Mögliche Missionsstatus:

    AVAILABLE
    ACTIVE
    COMPLETED
    FAILED
    EXPIRED
    BLOCKED

Bedeutung:

### AVAILABLE

Mission kann angeboten werden.

### ACTIVE

Mission wurde durch Spieler gewählt oder ist aktiv.

### COMPLETED

Mission wurde erfolgreich abgeschlossen.

### FAILED

Mission wurde nicht erfolgreich abgeschlossen.

### EXPIRED

Mission ist nicht mehr relevant, weil sich die Kampagnenlage verändert hat.

### BLOCKED

Mission ist grundsätzlich möglich, aber aktuell durch Bedingungen blockiert.

---

## Missionspriorität

Jede Mission soll später eine Priorität erhalten.

Mögliche Faktoren:

- strategische Bedeutung
- Nähe zur aktuellen Kampagnenphase
- Bedrohungswert
- Auswirkungen auf Logistik
- Auswirkungen auf Capture
- Auswirkungen auf IADS
- verfügbare Spielerflugzeuge
- Entfernung zu aktiven blauen Basen

Beispiel:

Eine SEAD-Mission gegen ein Küsten-SAM-System kann hohe Priorität haben, wenn dadurch ein Logistikkorridor geöffnet wird.

Eine Strike-Mission gegen ein Depot kann mittlere Priorität haben, wenn sie rote Ressourcen reduziert.

---

## Verbindung zum Airbase-System

Der Missionsgenerator benötigt Airbase-Daten.

Geplante Verbindung:

    src/world/
        ↓
    src/missions/

Mögliche Nutzung:

- aktive blaue Startbasen bestimmen
- rote Airbases als Ziele erkennen
- umkämpfte Airbases priorisieren
- Missionen nach Reichweite filtern
- Missionen nach Kampagnenphase filtern
- Airbase-Defense-Missionen erzeugen

Beispiel:

Wenn Akrotiri die einzige blaue Basis ist, werden Missionen zunächst von Akrotiri aus geplant.

Wenn später eine Festlandbasis erobert wird, können neue Missionsarten freigeschaltet werden.

---

## Verbindung zum Capture-System

Das Capture-System liefert Informationen über Besitz und umkämpfte Räume.

Geplante Verbindung:

    src/campaign/
        ↓
    src/missions/

Mögliche Nutzung:

- Missionen zur Vorbereitung eines Capture erzeugen
- Missionen zur Verteidigung einer eroberten Zone erzeugen
- CAS für umkämpfte Zonen anbieten
- Logistikmissionen für gefährdete Zonen erzeugen
- Missionen nach Capture-Fortschritt priorisieren

Beispiel:

Eine Zone kann erst erobert werden, wenn feindliche Kräfte reduziert und Logistik geliefert wurde.

Der Missionsgenerator kann dafür Strike-, CAS- und Logistics-Missionen anbieten.

---

## Verbindung zum Logistiksystem

Das Logistiksystem liefert Informationen über Versorgung und FOBs.

Geplante Verbindung:

    src/logistics/
        ↓
    src/missions/

Mögliche Nutzung:

- Logistikmissionen erzeugen
- FOB-Aufbau als Mission anbieten
- Versorgung gefährdeter Basen anbieten
- Helikopterrouten bewerten
- neue Missionen nach FOB-Aktivierung freischalten

Beispiel:

Wenn eine Dropoff-Zone vorbereitet, aber noch nicht versorgt ist, kann der Missionsgenerator eine CTLD-Supply-Mission erzeugen.

---

## Verbindung zum IADS-System

Das IADS-System liefert Luftverteidigungsziele und Bedrohungswerte.

Geplante Verbindung:

    src/iads/
        ↓
    src/missions/

Mögliche Nutzung:

- SEAD-Missionen erzeugen
- DEAD-Missionen erzeugen
- Strike gegen Radarstellungen erzeugen
- IADS-Bedrohung für andere Missionen bewerten
- Logistikrouten blockieren oder freigeben
- Missionspriorität aus Bedrohungswert ableiten

Beispiel:

Ein aktiver IADS-Sektor an der Küste kann Logistikmissionen blockieren, bis SEAD/DEAD-Erfolge erzielt wurden.

---

## Verbindung zum AI Director

Der AI Director und der Missionsgenerator sollen später zusammenarbeiten.

Geplante Verbindung:

    src/ai/
        ↓
    src/missions/

Mögliche Nutzung:

- rote CAP-Bedrohung in Missionsplanung einbeziehen
- GCI-Reaktionen berücksichtigen
- Gegenangriffe als neue Missionen erzeugen
- Verteidigungsmissionen anbieten
- Eskalation aus Spielererfolgen ableiten

Beispiel:

Wenn Blau einen FOB aufbaut, kann der AI Director einen roten Gegenangriff planen.

Der Missionsgenerator kann daraus eine Base-Defense- oder CAS-Mission erzeugen.

---

## Verbindung zur Persistenz

Missionen sollen später zumindest teilweise persistent werden.

Mögliche persistente Werte:

- abgeschlossene Missionen
- fehlgeschlagene Missionen
- zerstörte Ziele
- aktive Missionshistorie
- freigeschaltete Missionsarten
- blockierte Missionsarten
- Kampagnenphase

Geplante Datei:

    src/campaign/tc_persistence_system.lua

Persistenz wird aber erst gebaut, wenn Missionsdaten stabil definiert sind.

---

## F10-Missionsmenü

Missionen sollen später über F10-Menüs auswählbar oder sichtbar sein.

Geplante Datei:

    src/ui/tc_mission_menu.lua

Mögliche Struktur:

    Theater Command
        Missions
            Air Superiority
            Strike
            SEAD / DEAD
            CAS
            Logistics
            Recon
            Status

Die erste Version soll einfach bleiben.

Zu Beginn reicht eine einfache Missionsliste oder Statusausgabe.

---

## Missionsausgabe

Eine Mission soll später klar beschrieben werden.

Mögliche Informationen:

- Missionstyp
- Ziel
- Region
- empfohlene Flugzeuge
- Bedrohung
- erwarteter Effekt
- Status
- Priorität

Beispiel:

    Mission: SEAD Latakia Coast
    Type: SEAD
    Target: SA-6 site near Latakia
    Aircraft: F/A-18C, F-16C
    Effect: Reduces coastal IADS threat
    Priority: High

---

## Erfolgsbewertung

Missionserfolg soll später nicht nur durch DCS-Trigger bestimmt werden.

Theater Command DCS soll eigene Bedingungen auswerten.

Mögliche Erfolgsbedingungen:

- Ziel zerstört
- Ziel beschädigt
- Radar deaktiviert
- SAM-Stellung unterdrückt
- Kiste geliefert
- Truppen abgesetzt
- Zone gesichert
- Spieler zurückgekehrt optional
- Missionszeit nicht überschritten optional

Die genaue Logik wird pro Missionstyp definiert.

---

## Missionswirkung

Missionen sollen später kampagnenlogische Effekte haben.

Mögliche Effekte:

- IADS-Sektor geschwächt
- Ziel zerstört
- Logistikroute geöffnet
- Capture-Fortschritt erhöht
- rote Ressourcen reduziert
- blauer Logistikhub gestärkt
- neue Missionen freigeschaltet
- KI-Reaktion ausgelöst

Missionen sollen nicht folgenlos bleiben.

---

## Missionen in der ersten Kampagnenphase

Zu Beginn startet Blau auf Akrotiri.

Sinnvolle erste Missionsarten:

- CAP über östlichem Mittelmeer
- Escort für Strike-Pakete
- SEAD gegen Küsten-SAMs
- DEAD gegen Radar-/SAM-Komponenten
- Strike gegen Radarstellungen
- Recon entlang der Küste
- spätere Logistikvorbereitung

Noch nicht sinnvoll zu Beginn:

- A-10C-CAS tief im Inland
- AH-64D-Einsätze ohne FOB
- große Inland-Capture-Missionen
- vollständige Frontlinienmissionen

---

## Erste technische Minimalversion

Die erste technische Minimalversion des Missionsgenerators soll sehr klein sein.

Mögliches erstes Ziel:

- Missionsgenerator startet ohne Fehler
- erkennt Projektstatus
- gibt eine statische Test-Missionsliste aus
- zeigt Missionen über Debug oder F10 an
- filtert noch nicht komplex
- verändert noch keinen Kampagnenzustand

Erst danach werden echte Kampagnenbedingungen ergänzt.

---

## Debug für Missionen

Ein Debugsystem soll später helfen, Missionen zu prüfen.

Geplante Datei:

    src/debug/tc_debug_missions.lua

Mögliche Debug-Ausgaben:

- Anzahl verfügbarer Missionen
- Missionen nach Typ
- Missionen nach Priorität
- blockierte Missionen
- Grund für blockierte Missionen
- aktive Missionsziele
- abgeschlossene Missionen

Beispiel:

    [TC][DEBUG] Mission generator created 4 missions
    [TC][DEBUG] Mission available: SEAD_LATTAKIA_01
    [TC][DEBUG] Mission blocked: LOGISTICS_COASTAL_FOB_01 because IADS threat too high

---

## Testziele

Wenn der Missionsgenerator später erstmals eingebunden wird, sollen folgende Punkte getestet werden:

- Mission startet ohne Lua-Fehler
- Frameworks laden korrekt
- `src/loader.lua` startet
- `src/main.lua` startet
- Missionsgenerator wird geladen
- einfache Missionsliste wird erzeugt
- F10-Ausgabe funktioniert
- Missionen können nach Typ angezeigt werden
- keine nil-Fehler bei fehlenden Airbase-Daten
- blockierte Missionen werden nachvollziehbar begründet
- Debug-Ausgabe erscheint im `dcs.log`

---

## Nicht jetzt umsetzen

Aktuell noch nicht bauen:

- vollständiger dynamischer Missionsgenerator
- komplexes Missionsscoring
- komplette Flugzeugfilterung
- vollständige Missionsauswertung
- persistente Missionshistorie
- vollständige F10-Menüstruktur
- automatische KI-Reaktionen auf jede Mission
- vollständige SEAD/DEAD-Kampagnenlogik

Diese Punkte folgen später.

---

## Erste Entwicklungsreihenfolge

Der Missionsgenerator wird erst nach den Grundsystemen sinnvoll.

Vorher müssen entstehen:

1. `src/`-Unterordner
2. Core-System
3. Airbase-System
4. Zonen-System
5. Capture-System
6. Logistikgrundlage
7. IADS-Grundlage
8. erste UI-/F10-Struktur

Danach kann der Missionsgenerator sinnvoll aus dem Kampagnenzustand arbeiten.

---

## Aktueller Status

Aktuell ist der Missionsgenerator nur dokumentiert.

Die eigene Lua-Implementierung ist noch nicht begonnen.

Aktueller Stand:

    Missionsgenerator geplant
    Missionsregistry noch nicht implementiert
    Missionsfilter noch nicht implementiert
    F10-Missionsmenü noch nicht implementiert

Nächster technischer Fokus nach Abschluss der Dokumentationsaktualisierung:

    src-Unterordner und README-Dateien erstellen

Danach:

    src/loader.lua
    src/main.lua
    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
