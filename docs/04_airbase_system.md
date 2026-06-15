# Airbase System

Diese Datei beschreibt das geplante Airbase-System von **Theater Command DCS**.

Das Airbase-System ist eines der ersten großen eigenen Lua-Systeme des Projekts.

Ziel ist, DCS-Airbases auf der Syria Map automatisch zu erkennen, in eigene Theater-Command-Strukturen zu überführen und später mit Capture, Logistik, Missionen, IADS und Persistenz zu verbinden.

Die erste Kampagne trägt den Arbeitstitel:

**Operation Levant Reclamation**

Blau startet auf **Zypern / Akrotiri**.

Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Grundprinzip

Das Airbase-System folgt dem Projektprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Mission Editor soll nicht für jede Airbase manuelle Triggerzonen und Besitzlogik enthalten.

Stattdessen soll Lua später:

- Airbases erkennen
- Airbases registrieren
- Airbases klassifizieren
- Besitzstatus verwalten
- virtuelle Zonen erzeugen
- Airbases mit Kampagnenlogik verbinden

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

- `src/world/tc_airbase_scanner.lua`
- `src/world/tc_airbase_registry.lua`
- `src/world/tc_airbase_overrides.lua`
- `src/world/tc_region_classifier.lua`
- `src/world/tc_zone_factory.lua`
- eigenes Capture-System
- eigene Persistenz
- DEV-Mission im DCS Mission Editor

---

## Rolle des Airbase-Systems

Das Airbase-System soll später die Grundlage für mehrere andere Systeme bilden.

Es liefert Daten für:

- Capture-System
- Zonen-System
- Logistiksystem
- Missionsgenerator
- AI Director
- IADS-System
- Persistenz
- Debug-System

Ohne stabiles Airbase-System kann die Kampagne später keinen zuverlässigen strategischen Zustand führen.

---

## Warum Airbases automatisch erkennen?

DCS-Karten enthalten viele Airbases, FARP-Strukturen und Flugplätze.

Diese alle manuell im Mission Editor zu verwalten wäre fehleranfällig.

Ziel ist deshalb:

    DCS-Airbases automatisch erkennen
    Daten in Theater-Command-Strukturen überführen
    Sonderfälle über Overrides korrigieren
    strategischen Zustand selbst verwalten

Dadurch bleibt der Mission Editor schlank.

---

## Geplante eigene Dateien

Die Airbase-Logik gehört später nach:

    src/world/

Geplante Dateien:

    src/world/tc_airbase_scanner.lua
    src/world/tc_airbase_registry.lua
    src/world/tc_airbase_overrides.lua
    src/world/tc_region_classifier.lua
    src/world/tc_zone_factory.lua
    src/world/tc_zone_registry.lua

Zusätzliche Debug-Dateien:

    src/debug/tc_debug_airbases.lua
    src/debug/tc_debug_zones.lua

---

## Nicht gewünschte Dateien

Nicht gewünscht:

    src/tc_airbases_all_in_one.lua
    src/tc_moose_airbases.lua
    src/tc_mist_airbases.lua
    src/tc_all_in_one.lua

Die eigene Struktur wird nach Aufgaben sortiert.

Sie wird nicht nach Frameworks sortiert.

Eine Datei darf MIST oder MOOSE intern nutzen.

Der Dateiname richtet sich aber immer nach der Aufgabe, nicht nach dem Framework.

---

## Geplantes Datenmodell: BaseNode

Eine erkannte Airbase soll später als eigener Theater-Command-BaseNode geführt werden.

Vorläufige Struktur:

    baseNode = {
      id = "AKROTIRI",
      name = "Akrotiri",
      displayName = "Akrotiri",
      map = "Syria",
      region = "CYPRUS",
      coalition = "BLUE",
      initialCoalition = "BLUE",
      category = "AIRBASE",
      isOperational = true,
      isLogisticsHub = true,
      isCaptureTarget = false,
      isPlayerBase = true,
      position = {
        x = 0,
        y = 0,
        z = 0
      }
    }

Diese Struktur ist konzeptionell.

Die genaue technische Umsetzung erfolgt später in Lua.

---

## Wichtige BaseNode-Felder

### id

Eindeutige Theater-Command-ID.

Beispiel:

    AKROTIRI
    KHMEIMIM
    LATTAKIA
    TARTUS

Die ID soll stabil bleiben und später für Persistenz genutzt werden.

---

### name

Name der Airbase aus DCS oder aus einem Override.

Beispiel:

    Akrotiri

---

### displayName

Anzeigename für Debug, F10-Menüs oder spätere Briefings.

Beispiel:

    Akrotiri Airbase

---

### region

Strategische Region.

Mögliche Werte:

    CYPRUS
    SYRIAN_COAST
    SYRIAN_INLAND
    DAMASCUS_REGION
    NORTHERN_SYRIA
    UNKNOWN

Die Region hilft später bei Missionsgenerierung, AI Director und IADS-Sektoren.

---

### coalition

Aktueller Theater-Command-Besitzstatus.

Mögliche Werte:

    BLUE
    RED
    NEUTRAL

Dieser Wert muss nicht dauerhaft identisch mit dem DCS-internen Airbase-Status sein.

Theater Command DCS soll langfristig den strategischen Besitz selbst verwalten.

---

### initialCoalition

Startbesitz bei Kampagnenbeginn.

Für Operation Levant Reclamation gilt:

    Akrotiri = BLUE
    syrisches Festland = RED

---

### category

Mögliche Kategorien:

    AIRBASE
    HELIPAD
    FARP
    CARRIER
    UNKNOWN

Die genaue Kategorisierung wird später getestet.

---

### isOperational

Gibt an, ob die Basis aktuell nutzbar ist.

Mögliche spätere Einflüsse:

- Runway beschädigt
- Basis erobert
- Basis gesperrt
- IADS-Bedrohung zu hoch
- Logistik fehlt
- Mission Editor Status

---

### isLogisticsHub

Gibt an, ob die Basis als Logistikhub genutzt werden kann.

Zu Beginn:

    Akrotiri = true

Später können eroberte Basen oder FOBs neue Logistikhubs werden.

---

### isCaptureTarget

Gibt an, ob eine Basis später erobert werden kann.

Beispiele:

    Akrotiri = false zu Kampagnenbeginn
    syrische Airbases = true

---

### isPlayerBase

Gibt an, ob Spieler dort starten können.

Zu Beginn:

    Akrotiri = true

Später:

    eroberte Festlandbasen optional true
    FOBs optional true

---

## Akrotiri

Akrotiri ist die wichtigste Startbasis der ersten Kampagne.

Geplante Rolle:

- blaue Hauptbasis
- Spielerstart
- erster Logistikhub
- Startpunkt für Luftoperationen
- Startpunkt für CTLD-Logistik
- sicherer Rückzugsraum
- HQ-Knoten im Kampagnenzustand

Akrotiri soll im Airbase-System eindeutig erkannt und als BLUE initialisiert werden.

Vorläufige ID:

    AKROTIRI

Vorläufige Region:

    CYPRUS

Vorläufiger Status:

    BLUE
    isPlayerBase = true
    isLogisticsHub = true
    isCaptureTarget = false

---

## Syrisches Festland

Das syrische Festland ist zu Kampagnenbeginn rot kontrolliert.

Alle relevanten syrischen Airbases sollen initial als RED bewertet werden.

Beispiele für spätere wichtige Airbases:

- Khmeimim
- Latakia
- Tartus
- Hama
- Homs
- Damascus
- weitere Airbases der Syria Map

Die genaue Liste wird später durch den Airbase-Scanner ermittelt.

---

## Umgang mit DCS-Airbase-Daten

DCS liefert Airbase-Daten über Lua-Funktionen und Framework-Wrapper.

Mögliche Quellen:

- DCS-eigene Airbase-Funktionen
- MOOSE Airbase Wrapper
- MIST-Hilfsfunktionen
- eigene Overrides

Die genaue technische Umsetzung wird später getestet.

Möglicher Ansatz:

1. Airbases über DCS/MOOSE auslesen
2. Rohdaten erfassen
3. Namen normalisieren
4. Region zuweisen
5. Initialbesitz bestimmen
6. BaseNode erzeugen
7. BaseNode registrieren
8. Debug-Ausgabe erzeugen

---

## MOOSE-Nutzung

MOOSE kann später beim Airbase-System helfen.

Mögliche Nutzung:

- Airbase-Wrapper
- Koordinatenfunktionen
- SETs
- Zonenlogik
- Debug-Ausgaben
- Objektverwaltung

MOOSE ist aber nicht die Architektur des Airbase-Systems.

Theater Command DCS entscheidet selbst, welche Daten gespeichert und wie sie kampagnenlogisch bewertet werden.

---

## MIST-Nutzung

MIST kann später Hilfsfunktionen bereitstellen.

Mögliche Nutzung:

- Datenbankfunktionen
- Koordinatenfunktionen
- Gruppen- und Objektinformationen
- Debug- und Testhilfen

MIST bleibt eine Utility-Schicht.

Die Airbase-Logik selbst gehört nach:

    src/world/

---

## Airbase Registry

Die Datei `tc_airbase_registry.lua` soll später alle erkannten BaseNodes verwalten.

Geplante Aufgaben:

- BaseNodes speichern
- BaseNodes nach ID suchen
- BaseNodes nach Region filtern
- BaseNodes nach Koalition filtern
- BaseNodes als Missionsziele bereitstellen
- BaseNodes für Capture-System bereitstellen
- BaseNodes für Logistiksystem bereitstellen
- BaseNodes für Persistenz vorbereiten

Mögliche Funktionsnamen:

    registerBaseNode()
    getBaseById()
    getBasesByCoalition()
    getBasesByRegion()
    getLogisticsHubs()
    getCaptureTargets()

---

## Airbase Overrides

Nicht alle automatisch erkannten Daten werden perfekt sein.

Deshalb wird eine Override-Datei geplant:

    src/world/tc_airbase_overrides.lua

Mögliche Override-Aufgaben:

- Namen korrigieren
- Regionen manuell setzen
- Airbase-Kategorie überschreiben
- Initialbesitz definieren
- Spielerbasis markieren
- Logistikhub markieren
- problematische DCS-Namen normalisieren

Beispiel:

    AKROTIRI = {
      coalition = "BLUE",
      region = "CYPRUS",
      isPlayerBase = true,
      isLogisticsHub = true
    }

Overrides sollen gezielt und sparsam genutzt werden.

Automatische Erkennung bleibt der Standard.

---

## Region Classifier

Die Datei `tc_region_classifier.lua` soll später Airbases strategischen Regionen zuweisen.

Mögliche Regionen:

    CYPRUS
    SYRIAN_COAST
    SYRIAN_NORTH
    SYRIAN_CENTRAL
    SYRIAN_SOUTH
    DAMASCUS_REGION
    UNKNOWN

Diese Regionen werden später wichtig für:

- Missionsgenerator
- AI Director
- IADS-Sektoren
- Logistikrouten
- Capture-Prioritäten
- Kampagnenphasen

---

## Verbindung zum Zonen-System

Das Airbase-System liefert später die Grundlage für virtuelle Zonen.

Geplante Verbindung:

    src/world/tc_airbase_scanner.lua
        ↓
    src/world/tc_zone_factory.lua

Aus einer Airbase können später entstehen:

- Capture-Zone
- Defense-Zone
- Logistics-Zone
- Mission-Target-Zone
- IADS-Sector-Anker

Beispiel:

    BaseNode: LATTAKIA
        ↓
    CAPTURE_RED_LATTAKIA_01
    LOGI_RED_DEPOT_LATTAKIA_01
    IADS_RED_SECTOR_LATTAKIA_01

---

## Verbindung zum Capture-System

Das Capture-System benötigt Airbase-Daten.

Geplante Verbindung:

    src/world/
        ↓
    src/campaign/

Das Capture-System soll später wissen:

- welche Airbases existieren
- wem sie gehören
- welche Basen eroberbar sind
- welche Basen Spielerbasen sind
- welche Basen Logistikhubs sind
- welche Basen strategisch relevant sind

Airbase-Besitz soll nicht nur DCS-intern, sondern im Theater-Command-Kampagnenzustand geführt werden.

---

## Verbindung zum Logistiksystem

Das Logistiksystem benötigt Airbases als Hubs.

Geplante Verbindung:

    src/world/
        ↓
    src/logistics/

Akrotiri ist der erste Logistikhub.

Später können weitere Hubs entstehen durch:

- Capture
- FOB-Aufbau
- Versorgung
- Missionsfortschritt
- Kampagnenphase

Mögliche Logistikhub-Daten:

- Basis-ID
- verfügbare Ressourcen
- aktive CTLD-Pickup-Zonen
- aktive Dropoff-Zonen
- Versorgungsstatus
- verfügbare Transportoptionen

---

## Verbindung zum Missionsgenerator

Der Missionsgenerator benötigt Airbases als Quelle für Ziele und Ausgangspunkte.

Geplante Verbindung:

    src/world/
        ↓
    src/missions/

Mögliche Nutzung:

- Missionen gegen rote Airbases
- Verteidigung blauer Airbases
- Logistikmissionen zu eroberten Basen
- SEAD/DEAD in der Nähe relevanter Basen
- CAP um strategische Basen
- CAS bei bedrohten Capture-Zonen

---

## Verbindung zum AI Director

Der AI Director benötigt Airbase-Daten für KI-Reaktionen.

Geplante Verbindung:

    src/world/
        ↓
    src/ai/

Mögliche Nutzung:

- rote CAP von aktiven roten Basen
- GCI-Reaktionen abhängig von Airbase-Besitz
- Gegenangriffe gegen eroberte Basen
- Verstärkung gefährdeter Basen
- Eskalation bei Verlust wichtiger Basen

---

## Verbindung zum IADS-System

IADS-Sektoren können an Airbases gekoppelt werden.

Geplante Verbindung:

    src/world/
        ↓
    src/iads/

Mögliche Nutzung:

- Airbase-SAM-Schutz
- Küsten-IADS um wichtige Basen
- Radarstellungen als Airbase-Verteidigung
- SEAD/DEAD-Ziele aus Airbase-Nähe
- IADS-Zustand beeinflusst Airbase-Capture

---

## Verbindung zur Persistenz

Airbase-Daten werden später persistent gespeichert.

Geplante persistente Werte:

- Airbase-ID
- aktueller Besitzer
- initialer Besitzer
- Betriebsstatus
- Logistikhub-Status
- Capture-Status
- Schadensstatus
- letzte relevante Ereignisse

Geplante spätere Datei:

    src/campaign/tc_persistence_system.lua

Persistenz wird erst umgesetzt, wenn Airbase-, Capture- und Logistiksystem stabil sind.

---

## Debug-Ausgabe

Das Airbase-System soll früh debugfähig sein.

Geplante Debug-Datei:

    src/debug/tc_debug_airbases.lua

Mögliche Debug-Ausgaben:

- Anzahl erkannter Airbases
- Name jeder Airbase
- erkannte Koalition
- zugewiesene Region
- erkannte Kategorie
- erkannter Logistikhub-Status
- erkannter Capture-Status
- Warnungen bei unbekannten Basen

Beispielausgabe:

    [TC][DEBUG] Airbase scanner found 42 airbases
    [TC][DEBUG] BaseNode created: AKROTIRI / BLUE / CYPRUS
    [TC][WARN] Airbase region unknown: Example Airbase

---

## Erste Testziele

Wenn das Airbase-System später umgesetzt wird, sollen folgende Punkte getestet werden:

- Mission startet ohne Lua-Fehler
- Frameworks werden geladen
- `src/loader.lua` startet
- Airbase-Scanner wird geladen
- Airbases der Syria Map werden erkannt
- Akrotiri wird erkannt
- Akrotiri wird als BLUE gesetzt
- syrische Airbases werden initial als RED gesetzt
- BaseNodes werden erzeugt
- Debug-Ausgabe erscheint im `dcs.log`
- keine nil-Fehler bei Airbase-Daten
- problematische Airbases können per Override korrigiert werden

---

## Nicht jetzt umsetzen

Aktuell noch nicht bauen:

- vollständiger Airbase-Scanner
- automatische Capture-Logik
- vollständiges Zonen-System
- Persistenz
- Mission-Editor-Testmission
- automatische Airbase-Koalitionsänderung
- komplexe Regionserkennung
- vollständige Airbase-Balancinglogik

Diese Punkte folgen später.

---

## Erste Entwicklungsreihenfolge

Das Airbase-System wird erst nach der `src/`-Grundstruktur begonnen.

Vorher müssen entstehen:

1. `src/`-Unterordner
2. `src/core/`
3. `src/world/`
4. `src/debug/`
5. `src/loader.lua`
6. `src/main.lua`
7. `src/core/tc_config.lua`
8. `src/core/tc_logger.lua`
9. `src/core/tc_state.lua`

Danach kann der erste Airbase-Scanner gebaut werden.

---

## Aktueller Status

Aktuell ist das Airbase-System nur dokumentiert.

Die eigene Lua-Implementierung ist noch nicht begonnen.

Aktueller Stand:

    Airbase-System geplant
    Airbase-Scanner noch nicht implementiert
    Airbase-Registry noch nicht implementiert
    Overrides noch nicht implementiert

Nächster technischer Fokus nach Abschluss der Dokumentationsaktualisierung:

    src-Unterordner und README-Dateien erstellen

Danach:

    src/loader.lua
    src/main.lua
    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
