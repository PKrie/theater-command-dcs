# Persistence System

Diese Datei beschreibt das geplante Persistenzsystem von **Theater Command DCS**.

Persistenz bedeutet, dass der Kampagnenzustand über Missions- oder Serverneustarts hinweg erhalten bleibt.

Die erste Kampagne trägt den Arbeitstitel:

**Operation Levant Reclamation**

Die Kampagne wird auf der **Syria Map** aufgebaut.

Blau startet auf **Zypern / Akrotiri**.

Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Grundprinzip

Das Persistenzsystem folgt dem Projektprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Mission Editor stellt den Startzustand bereit.

Lua verwaltet später den dynamischen Kampagnenzustand.

Persistenz speichert diesen Zustand zwischen Sessions.

---

## Ziel des Persistenzsystems

Das Persistenzsystem soll später speichern, was sich in der Kampagne verändert hat.

Mögliche Beispiele:

- welche Basen Blau kontrolliert
- welche Basen Rot kontrolliert
- welche Zonen umkämpft sind
- welche FOBs aktiv sind
- welche IADS-Komponenten zerstört wurden
- welche Logistikhubs aktiv sind
- welche Missionen abgeschlossen wurden
- welche Ziele zerstört wurden
- welche Ressourcen verfügbar sind
- welche Kampagnenphase aktiv ist

Persistenz macht aus einer einzelnen Mission eine fortlaufende Kampagne.

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

- `src/campaign/tc_persistence_system.lua`
- `save/README.md`
- `save/example_state.lua`
- eigenes Airbase-System
- eigenes Capture-System
- eigenes Logistiksystem
- eigenes IADS-State-System
- eigener Missionsgenerator
- echte Speicher- und Ladefunktionen

---

## Warum Persistenz nicht sofort gebaut wird

Persistenz wird bewusst nicht als erstes System gebaut.

Grund:

Es muss zuerst klar sein, welche Daten überhaupt stabil gespeichert werden müssen.

Vorher müssen mindestens folgende Systeme konzeptionell oder technisch stehen:

- Core-System
- Airbase-System
- Zonen-System
- Capture-System
- Logistiksystem
- Missionsgenerator-Grundlage
- IADS-State-System

Erst dann kann entschieden werden, welche Zustände gespeichert werden sollen.

Persistenz zu früh zu bauen würde zu instabilen Speicherstrukturen führen.

---

## Geplante eigene Dateien

Die Persistenzlogik gehört später nach:

    src/campaign/

Geplante Datei:

    src/campaign/tc_persistence_system.lua

Zusätzliche geplante Ordner und Dateien:

    save/README.md
    save/example_state.lua

Der Ordner `save/` existiert aktuell noch nicht vollständig.

Er wird später angelegt, wenn die Speicherstruktur konkret definiert wird.

---

## Nicht gewünschte Dateien

Nicht gewünscht:

    src/tc_save_system.lua
    src/tc_persistence_all_in_one.lua
    src/tc_all_in_one.lua

Die eigene Struktur wird nach Aufgaben sortiert.

Persistenz gehört zur Kampagnenlogik und liegt deshalb unter:

    src/campaign/

---

## Grundidee des Speicherstands

Ein Speicherstand soll später den strategischen Zustand von Theater Command DCS abbilden.

Nicht gespeichert werden sollen komplette Framework-interne Tabellen.

Nicht gespeichert werden sollen temporäre DCS-Objekte.

Gespeichert werden sollen nur stabile Theater-Command-Daten.

Beispiel:

Nicht speichern:

    DCS-Objekt einer aktiven Unit
    MOOSE-Wrapper-Objekt
    komplette CTLD-interne Tabelle
    komplette Skynet-IADS-interne Struktur

Stattdessen speichern:

    Basis-ID
    Besitzer
    Status
    Ressourcenwert
    zerstörte Ziel-ID
    aktiver FOB-Status
    abgeschlossene Missions-ID

---

## Vorläufiges Speicherformat

Ein späterer Beispiel-Speicherstand könnte so aussehen:

    TC_SAVE_STATE = {
      version = "0.1.0",
      campaign = {
        name = "Operation Levant Reclamation",
        phase = 1,
        date = "TBD"
      },
      bases = {},
      zones = {},
      logistics = {},
      iads = {},
      missions = {},
      ai = {}
    }

Diese Struktur ist konzeptionell.

Die konkrete Umsetzung erfolgt später.

---

## Versionierung des Speicherstands

Jeder Speicherstand soll eine Versionsnummer enthalten.

Grund:

Wenn sich die Datenstruktur später ändert, muss erkennbar sein, welche Save-Version geladen wird.

Beispiel:

    version = "0.1.0"

Mögliche spätere Nutzung:

- alte Speicherstände erkennen
- inkompatible Speicherstände ablehnen
- Migration vorbereiten
- Debug-Ausgaben verbessern

---

## Kampagnendaten

Der Speicherstand soll später allgemeine Kampagnendaten enthalten.

Mögliche Werte:

    campaign = {
      name = "Operation Levant Reclamation",
      phase = 1,
      blueStart = "AKROTIRI",
      map = "Syria"
    }

Mögliche gespeicherte Informationen:

- Kampagnenname
- Kampagnenphase
- aktive Region
- aktueller Fortschritt
- letzter Speicherzeitpunkt
- aktive Hauptbasis
- globale Eskalationsstufe

---

## Airbase-Persistenz

Airbase-Daten sind ein zentraler Bestandteil der Persistenz.

Mögliche gespeicherte Werte:

- Airbase-ID
- aktueller Besitzer
- initialer Besitzer
- Betriebsstatus
- Logistikhub-Status
- Spielerbasis-Status
- Capture-Ziel-Status
- Schadensstatus
- letzte relevante Änderung

Beispiel:

    bases = {
      AKROTIRI = {
        coalition = "BLUE",
        isOperational = true,
        isLogisticsHub = true,
        isPlayerBase = true
      },
      LATTAKIA = {
        coalition = "RED",
        isOperational = true,
        isLogisticsHub = false,
        isCaptureTarget = true
      }
    }

---

## Zonen-Persistenz

Zonen sollen später ebenfalls gespeichert werden.

Mögliche gespeicherte Werte:

- Zonen-ID
- Besitzer
- Status
- Capture-Fortschritt
- Versorgungsstatus
- Bedrohungswert
- zugehörige Basis
- letzte Änderung

Beispiel:

    zones = {
      CAPTURE_RED_LATTAKIA_01 = {
        coalition = "RED",
        captureProgress = 0,
        supplied = false,
        contested = false
      }
    }

---

## Capture-Persistenz

Das Capture-System soll später speichern:

- welche Basen erobert wurden
- welche Zonen umkämpft sind
- welche Zonen neutralisiert wurden
- welcher Capture-Fortschritt erreicht wurde
- welche Bedingungen erfüllt sind
- welche Garnisonen aktiv sind

Mögliche gespeicherte Werte:

    capture = {
      activeZones = {},
      capturedBases = {},
      contestedZones = {},
      lastCaptureEvent = {}
    }

Capture-Persistenz wird erst sinnvoll, wenn das Capture-System stabil definiert ist.

---

## Logistik-Persistenz

Logistikzustände sollen später gespeichert werden.

Mögliche gespeicherte Werte:

- aktive Logistikhubs
- aktive FOBs
- Ressourcenstatus
- Versorgungsstatus je Basis
- Versorgungsstatus je Zone
- abgeschlossene Lieferungen
- freigeschaltete Pickup-Zonen
- freigeschaltete Dropoff-Zonen

Beispiel:

    logistics = {
      hubs = {
        AKROTIRI = {
          active = true,
          resources = 100
        }
      },
      fobs = {
        FOB_ALPHA = {
          active = true,
          supplied = true,
          location = "SYRIAN_COAST"
        }
      }
    }

CTLD selbst wird nicht vollständig gespeichert.

Theater Command DCS speichert nur die kampagnenlogische Wirkung von CTLD-Aktionen.

---

## IADS-Persistenz

IADS-Zustände sollen später gespeichert werden.

Mögliche gespeicherte Werte:

- aktive IADS-Sektoren
- zerstörte Radarstellungen
- zerstörte SAM-Stellungen
- beschädigte Sektoren
- deaktivierte Netzwerke
- wiederhergestellte Standorte
- Bedrohungswerte pro Region

Beispiel:

    iads = {
      sectors = {
        SYRIAN_COAST = {
          active = true,
          threatLevel = 75,
          damaged = false
        }
      },
      sites = {
        IADS_RED_EWR_LATTAKIA_01 = {
          alive = true,
          damaged = false
        }
      }
    }

Skynet IADS steuert taktisch.

Theater Command DCS speichert strategisch.

---

## Missions-Persistenz

Der Missionsgenerator soll später teilweise persistent arbeiten.

Mögliche gespeicherte Werte:

- abgeschlossene Missionen
- fehlgeschlagene Missionen
- aktive Missionen
- zerstörte Missionsziele
- freigeschaltete Missionsarten
- blockierte Missionsarten
- Missionshistorie

Beispiel:

    missions = {
      completed = {
        "MISSION_SEAD_LATTAKIA_01"
      },
      failed = {},
      active = {},
      unlockedTypes = {
        "CAP",
        "SEAD",
        "STRIKE"
      }
    }

Missions-Persistenz soll nicht zu früh aufgebaut werden.

Zuerst muss das Missionsdatenmodell stabil sein.

---

## AI-Persistenz

Der AI Director kann später ebenfalls bestimmte Werte speichern.

Mögliche gespeicherte Werte:

- Eskalationslevel
- rote Ressourcen
- aktive Gegenangriffe
- letzte Reaktionen
- blockierte Reaktionen
- aktuelle AI-Phase

Beispiel:

    ai = {
      escalationLevel = 2,
      redResources = 80,
      activeCounterattacks = {},
      lastReaction = "RED_CAP_LATTAKIA"
    }

AI-Persistenz wird erst sinnvoll, wenn der AI Director stabil definiert ist.

---

## Speicherung von zerstörten Zielen

Zerstörte strategische Ziele sollen später gespeichert werden.

Mögliche Zielarten:

- Radarstellungen
- SAM-Komponenten
- Depots
- Kommandoposten
- Brücken
- Hafenanlagen
- Treibstofflager
- Munitionslager

Beispiel:

    destroyedTargets = {
      STATIC_RED_RADAR_LATTAKIA_01 = true,
      STATIC_RED_DEPOT_TARTUS_01 = true
    }

Diese Daten können später Missionen, IADS, Logistik und AI-Reaktionen beeinflussen.

---

## Speicherung von Ressourcen

Ein späteres Ressourcenmodell kann gespeichert werden.

Mögliche Ressourcen:

- blaue Ressourcen je Hub
- rote Ressourcen je Region
- IADS-Reparaturressourcen
- verfügbare CAP-Pakete
- verfügbare Bodentruppen
- verfügbare Logistikpunkte

Ressourcen werden erst eingeführt, wenn die Kampagnenmechanik dafür bereit ist.

---

## Speicherort

Der geplante Projektordner für Beispiel- und Test-Speicherstände ist:

    save/

Geplante Dateien:

    save/README.md
    save/example_state.lua

Wichtig:

DCS selbst hat besondere Einschränkungen beim Schreiben von Dateien.

Die konkrete technische Umsetzung von Save/Load wird später separat geprüft.

Diese Dokumentation beschreibt zunächst die Projektstruktur und die geplanten Daten.

---

## DCS-Einschränkungen

DCS-Missionen können nicht immer ohne Weiteres beliebig Dateien schreiben.

Für Persistenz müssen später geprüft werden:

- DCS-Sanitizing
- Mission Scripting Environment
- Schreibrechte
- Serverumgebung
- Dedicated Server
- Saved Games Pfade
- mögliche Lua-Dateischreibfunktionen
- Sicherheitsrisiken

Diese technische Prüfung erfolgt später.

Persistenz wird nicht blind vorausgesetzt.

---

## Save-Funktion

Eine spätere Save-Funktion könnte konzeptionell folgende Aufgaben haben:

- aktuellen Kampagnenzustand sammeln
- temporäre Daten entfernen
- stabile Daten serialisieren
- Save-Version eintragen
- Speicherdatei schreiben
- Erfolg oder Fehler loggen

Möglicher Funktionsname:

    saveCampaignState()

---

## Load-Funktion

Eine spätere Load-Funktion könnte konzeptionell folgende Aufgaben haben:

- Speicherdatei finden
- Datei laden
- Version prüfen
- Daten validieren
- Standardwerte ergänzen
- Kampagnenzustand wiederherstellen
- Fehler loggen

Möglicher Funktionsname:

    loadCampaignState()

---

## Autosave

Ein späteres Autosave-System kann sinnvoll sein.

Mögliche Auslöser:

- Missionsende
- manuelles F10-Kommando
- regelmäßiger Zeitintervall
- Capture-Ereignis
- wichtiger Missionserfolg
- FOB-Aufbau
- IADS-Ziel zerstört

Autosave wird aber erst später umgesetzt.

Zuerst muss die Save-Struktur stabil sein.

---

## Manuelles Speichern

Ein F10-Menü kann später manuelles Speichern ermöglichen.

Mögliche Menüstruktur:

    Theater Command
        Debug
            Save Campaign State
            Load Campaign State

Für Release-Versionen muss entschieden werden, ob manuelles Speichern für Spieler sichtbar bleibt oder nur als Admin-/Debug-Funktion genutzt wird.

---

## Fehlerbehandlung

Persistenz muss besonders defensiv programmiert werden.

Mögliche Fehler:

- Save-Datei fehlt
- Save-Datei beschädigt
- Save-Version inkompatibel
- Schreibrechte fehlen
- DCS-Sanitizing verhindert Schreiben
- erwartete Tabelle fehlt
- gespeicherte Basis existiert nicht mehr
- gespeicherte Zone ist ungültig

Fehler sollen klar im `dcs.log` sichtbar sein.

Beispiele:

    [TC][ERROR] Save file not found
    [TC][ERROR] Save version incompatible
    [TC][WARN] Saved base not found in current mission: LATTAKIA

---

## Debug für Persistenz

Ein Debugsystem soll später helfen, Persistenz zu prüfen.

Mögliche Debug-Ausgaben:

- Save-Datei geladen
- Save-Datei geschrieben
- Save-Version
- Anzahl gespeicherter Basen
- Anzahl gespeicherter Zonen
- Anzahl aktiver FOBs
- Anzahl zerstörter IADS-Ziele
- Anzahl abgeschlossener Missionen

Beispiel:

    [TC][DEBUG] Campaign state saved
    [TC][DEBUG] Saved bases: 42
    [TC][DEBUG] Saved IADS sites: 12

---

## Was nicht gespeichert werden soll

Nicht speichern:

- MOOSE-Objekte
- CTLD-interne Live-Objekte
- Skynet-IADS-interne Runtime-Objekte
- DCS-Unit-Objekte
- DCS-Group-Objekte
- Funktionen
- Coroutines
- Scheduler-Objekte
- temporäre Debugdaten
- große Framework-Tabellen

Stattdessen stabile IDs und Zustände speichern.

---

## Testziele

Wenn Persistenz später erstmals umgesetzt wird, sollen folgende Punkte getestet werden:

- Save-Datei wird erzeugt
- Save-Datei enthält Version
- Basisbesitz wird gespeichert
- Basisbesitz wird geladen
- FOB-Status wird gespeichert
- IADS-Zustand wird gespeichert
- zerstörte Ziele bleiben zerstört
- ungültige Save-Dateien erzeugen klare Fehler
- fehlende Save-Dateien erzeugen klare Fehler
- Mission startet auch ohne vorhandenen Save-State
- `dcs.log` enthält nachvollziehbare Meldungen

---

## Nicht jetzt umsetzen

Aktuell noch nicht bauen:

- echtes Save/Load-System
- DCS-Dateischreiblogik
- Autosave
- Save-Migration
- Persistenz für alle Systeme
- komplexe Kampagnenwiederherstellung
- Admin-Menüs für Save/Load

Diese Dinge kommen später.

---

## Erste Entwicklungsreihenfolge

Persistenz wird spät umgesetzt.

Vorher müssen entstehen:

1. `src/`-Unterordner
2. Core-System
3. Airbase-System
4. Zonen-System
5. Capture-System
6. Logistiksystem
7. Missionsgenerator-Grundlage
8. IADS-State-System
9. stabile State-Struktur
10. Beispiel-Save-State

Erst dann wird echte Persistenz sinnvoll.

---

## Aktueller Status

Aktuell ist Persistenz nur dokumentiert.

Die eigene Lua-Implementierung ist noch nicht begonnen.

Aktueller Stand:

    Persistenz geplant
    Save-System noch nicht implementiert
    Load-System noch nicht implementiert
    save/ noch nicht vorbereitet
    example_state.lua noch nicht erstellt

Nächster technischer Fokus nach Abschluss der Dokumentationsaktualisierung:

    src-Unterordner und README-Dateien erstellen

Danach:

    src/loader.lua
    src/main.lua
    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
