# Persistence

Diese Datei beschreibt das geplante Persistenzsystem von **Theater Command DCS**.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut.

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## Zweck der Persistenz

Theater Command DCS soll später kein rein temporäres Missionssystem sein.

Der Kampagnenzustand soll über mehrere DCS-Sessions hinweg erhalten bleiben.

Persistenz soll speichern, was in der Kampagne passiert ist.

Dazu gehören später unter anderem:

- Besitzstatus von Airbases
- Besitzstatus von Zonen
- Airbase-Klassifizierung
- aktive Missionen
- abgeschlossene Missionen
- fehlgeschlagene Missionen
- Logistikstatus
- FOB-Status
- IADS-Zustand
- AI-Zustand
- wichtige Kampagnenereignisse
- Fortschritt der Operation Levant Reclamation

---

## Grundprinzip

Das zentrale Projektprinzip lautet:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Mission Editor stellt die Bühne bereit.

Lua verwaltet den Kampagnenzustand.

Persistenz soll diesen Zustand später speichern und wieder laden.

GitHub dokumentiert Struktur, Entscheidungen, Versionen, Aufgabenstand und Testergebnisse.

---

## Aktueller technischer Stand

Stand: 2026-06-16

Aktuelle Persistenz-Datei:

    src/campaign/tc_persistence_system.lua

Der erste reale DCS-Starttest wurde durchgeführt.

Test:

    Starttest-Variante A — sichere Einzeldatei-Ladung

Ergebnis:

    Bestanden

Bestätigt wurde:

- Campaign-Bereich wird geladen
- `tc_persistence_system.lua` wird geladen
- keine schweren Lua-Fehler beim Laden
- Persistence wird durch Main als Runtime-System berücksichtigt
- Theater-Command-Startkette läuft sauber weiter

Aktueller Stand:

    In-Memory-Persistenz ist vorbereitet.
    Datei-Persistenz ist noch nicht getestet.
    DCS-Sandbox-Verhalten ist noch offen.

---

## Aktuelle DEV-Mission

Aktuelle technische Entwicklungsmission:

    Operation_Levant_Reclamation_DEV.miz

Aktueller Inhalt:

    Map: Syria
    Koalitionspreset: Modern
    Blue Start: Akrotiri / Zypern
    erster blauer Client-Slot: F/A-18C Lot 20 auf Akrotiri
    Trigger: Starttest-Variante A vollständig angelegt
    keine rote Frontlinie
    keine IADS-Stellungen
    keine CTLD-Zonen
    keine Template-Gruppen
    keine F10-Menüs

Diese Mission ist aktuell nur ein technischer Testträger.

Sie ist noch keine spielbare Kampagnenmission.

---

## Aktueller Teststatus

Der erste DCS-Starttest hat die technische Ladefähigkeit bestätigt.

Noch nicht getestet wurde:

- State in Datei schreiben
- State aus Datei lesen
- Save-Datei erzeugen
- Save-Datei importieren
- DCS-Dateizugriff
- DCS-Sandbox-Anpassung
- Loader-only mit `dofile`
- produktive Save-/Load-Logik

Wichtig:

    Vor echter Dateipersistenz muss das DCS-Sandbox-Verhalten praktisch geprüft werden.

---

## Verbindung zum Airbase-System

Der erste reale DCS-Test ergab:

    Airbase-Scanner registrierte 225 Airbase-/Helipad-Objekte.
    Zone-Factory registrierte 225 Zonen.

Dieser Befund ist für Persistenz wichtig.

Problem:

    Nicht jedes erkannte Airbase-Objekt muss gleichwertig persistent gespeichert werden.

DCS liefert auf der Syria Map offenbar viele Airbase-ähnliche Objekte.

Dazu können gehören:

- strategische Airfields
- Secondary Airfields
- Heliports
- Helipads
- Medical Pads
- FARPs
- taktische Pads
- unbekannte Objekte

Folgerung:

    Die Persistenz darf nicht blind alle 225 Objekte als strategische Kampagnenbasen speichern.

Zuerst muss der Airbase-Scanner klassifizieren.

---

## Geplante Persistenz nach Airbase-Klasse

### Strategische Airfields

Strategische Airfields haben höchste Persistenzpriorität.

Zu speichern:

- Besitzerstatus
- Capture-Status
- Logistikstatus
- Beschädigungsstatus
- Missionshistorie
- Spawnfähigkeit
- IADS-Bezug
- AI-Relevanz

---

### Secondary Airfields

Secondary Airfields können später begrenzt persistent sein.

Zu speichern:

- Besitzerstatus, falls kampagnenrelevant
- Logistikrolle, falls vorhanden
- Missionsrelevanz
- Capture-Fähigkeit, falls aktiviert

---

### Heliports

Heliports können später persistent relevant sein.

Zu speichern:

- Besitzerstatus, falls relevant
- CTLD-Rolle
- CSAR-Rolle
- Logistikrolle
- FOB-Bezug
- Helikopteroperationsstatus

---

### Helipads

Helipads sollen nicht automatisch wie strategische Basen gespeichert werden.

Mögliche Persistenz nur bei:

- aktiver CTLD-Nutzung
- MEDEVAC-/CSAR-Rolle
- FOB-Bezug
- spezieller Missionsrolle
- expliziter Kampagnenrelevanz

---

### Medical Pads

Medical Pads sollen nur dann persistent werden, wenn sie eine definierte Rolle bekommen.

Mögliche Rollen:

- MEDEVAC
- CSAR
- humanitäre Mission
- zivile Infrastruktur
- Sondermission

---

### FARPs

FARPs sind für Persistenz wichtig, wenn sie mit FOB oder Logistik verbunden sind.

Zu speichern:

- Besitzerstatus
- Betriebsstatus
- Fuel
- Munition
- Supply
- Beschädigung
- CTLD-Funktion
- FOB-Ausbaustufe

---

### Unknown

Unknown-Objekte sollen zunächst konservativ behandelt werden.

Zu speichern höchstens:

- Name
- Position
- DCS-ID
- erkannte Rohdaten
- Debug-Status

Unknown-Objekte sollen nicht als strategische Kampagnenbasen gespeichert werden.

---

## Geplante State-Struktur

Der globale Theater-Command-State soll später mehrere Bereiche enthalten.

Mögliche Struktur:

    TC.state = {
        campaign = {},
        world = {},
        airbases = {},
        zones = {},
        logistics = {},
        fobs = {},
        missions = {},
        ai = {},
        iads = {},
        events = {},
        metadata = {}
    }

Diese Struktur ist noch nicht final.

Sie dient als fachliche Orientierung.

---

## Metadata

Metadata beschreibt den Save selbst.

Mögliche Inhalte:

    metadata = {
        project = "Theater Command DCS",
        campaign = "Operation Levant Reclamation",
        map = "Syria",
        version = "0.1.0",
        saveVersion = 1,
        createdAt = 0,
        updatedAt = 0
    }

Zweck:

- Save-Datei identifizieren
- Kampagne prüfen
- Version prüfen
- spätere Migration vorbereiten
- falsche Save-Dateien vermeiden

---

## Campaign-State

Der Campaign-State enthält strategische Grunddaten.

Mögliche Inhalte:

    campaign = {
        name = "Operation Levant Reclamation",
        phase = "INITIAL",
        blueStart = "Akrotiri",
        redStart = "Syrian mainland",
        currentTurn = 0,
        status = "ACTIVE"
    }

Mögliche Phasen:

    INITIAL
    RECON
    AIR_SUPERIORITY
    SEAD
    LOGISTICS_BUILDUP
    CAPTURE
    EXPANSION
    ESCALATION
    END_STATE

Diese Phasen sind noch nicht final.

---

## Airbase-State

Der Airbase-State speichert Airbase-Daten.

Mögliche Inhalte:

    airbases = {
        strategic = {},
        secondary = {},
        heliports = {},
        helipads = {},
        medicalPads = {},
        farps = {},
        unknown = {}
    }

Jeder Datensatz kann später enthalten:

    id
    name
    category
    coalition
    owner
    position
    isStrategic
    isCapturable
    isLogisticsHub
    isMissionTarget
    isSpawnBase
    status
    lastUpdated

Wichtig:

    Airbase-Klassifizierung muss vor produktiver Airbase-Persistenz erfolgen.

---

## Zone-State

Der Zone-State speichert virtuelle Kampagnenzonen.

Mögliche Inhalte:

    zones = {
        strategicZones = {},
        logisticsZones = {},
        captureZones = {},
        aiZones = {},
        debugZones = {}
    }

Zu speichern:

- Zonenname
- Typ
- Besitzer
- Radius
- Position
- verbundene Airbase
- Status
- Kampagnenrelevanz

Wichtig:

    ZoneFactory darf später nicht ungefiltert 225 strategische Zonen speichern.

---

## Logistics-State

Der Logistics-State speichert Versorgung und Lieferungen.

Mögliche Inhalte:

    logistics = {
        hubs = {},
        activeDeliveries = {},
        completedDeliveries = {},
        failedDeliveries = {},
        supply = {},
        fuel = {},
        ammunition = {},
        engineering = {}
    }

Zu speichern:

- aktive Lieferungen
- abgeschlossene Lieferungen
- fehlgeschlagene Lieferungen
- Supply-Werte
- Fuel-Werte
- Munitionswerte
- Engineering-Werte
- Hub-Status

---

## FOB-State

Der FOB-State speichert Forward Operating Bases.

Mögliche Inhalte:

    fobs = {
        active = {},
        planned = {},
        damaged = {},
        destroyed = {}
    }

Zu speichern:

- FOB-ID
- Name
- Position
- Besitzer
- Baufortschritt
- Status
- Supply
- Fuel
- Munition
- CTLD-Rolle
- verfügbare Funktionen

Mögliche Statuswerte:

    PLANNED
    UNDER_CONSTRUCTION
    OPERATIONAL
    DAMAGED
    DESTROYED
    ABANDONED

---

## Mission-State

Der Mission-State speichert dynamische Missionen.

Mögliche Inhalte:

    missions = {
        available = {},
        active = {},
        completed = {},
        failed = {},
        expired = {},
        cancelled = {}
    }

Zu speichern:

- Missions-ID
- Typ
- Status
- Priorität
- Ursprung
- Ziel
- Zieltyp
- Erstellungszeit
- Ablaufzeit
- Ergebnis
- Kampagneneffekt

Mögliche Statuswerte:

    AVAILABLE
    ACTIVE
    COMPLETED
    FAILED
    EXPIRED
    CANCELLED

---

## AI-State

Der AI-State speichert KI-Reaktionen.

Mögliche Inhalte:

    ai = {
        capRequests = {},
        activeCaps = {},
        gciRequests = {},
        counterattacks = {},
        threatLevels = {},
        cooldowns = {}
    }

Zu speichern:

- aktive CAP-Anforderungen
- aktive CAPs
- GCI-Status
- Gegenangriffe
- Bedrohungsstufen
- Reaktionscooldowns
- AI-Aktionshistorie

Aktueller Stand:

    AI-CAP-Manager lädt.
    Vollständiger AI Director ist noch nicht implementiert.

---

## IADS-State

Der IADS-State speichert Luftverteidigungszustände.

Mögliche Inhalte:

    iads = {
        sectors = {},
        sites = {},
        radars = {},
        ewr = {},
        commandNodes = {},
        knownTargets = {}
    }

Zu speichern:

- IADS-Sektoren
- SAM-Sites
- Radarstatus
- EWR-Status
- zerstörte Systeme
- unterdrückte Systeme
- Bedrohungsstufen
- SEAD-/DEAD-Relevanz

Aktueller Stand:

    Skynet IADS wird geladen.
    Theater-Command-IADS-Schicht ist noch nicht implementiert.

---

## Event-State

Der Event-State speichert wichtige Kampagnenereignisse.

Mögliche Ereignisse:

- Mission abgeschlossen
- Mission fehlgeschlagen
- Airbase erobert
- Zone erobert
- FOB gebaut
- FOB beschädigt
- Lieferung abgeschlossen
- Lieferung verloren
- SAM-Site zerstört
- Radar zerstört
- AI-Gegenangriff ausgelöst
- Kampagnenphase geändert

Mögliche Struktur:

    events = {
        {
            id = "EVENT_001",
            type = "MISSION_COMPLETED",
            time = 1200,
            data = {}
        }
    }

---

## Save-Dateien

Geplanter späterer Ordner:

    save/

Mögliche Dateien:

    save/operation_levant_reclamation_state.lua
    save/operation_levant_reclamation_backup.lua
    save/example_state.lua

Aktueller Stand:

    Save-Ordner ist noch nicht produktiv.
    Datei-Persistenz wurde noch nicht getestet.

---

## DCS-Sandbox

DCS schützt die Mission-Scripting-Umgebung.

Dateizugriff kann eingeschränkt sein.

Vor echter Datei-Persistenz muss geprüft werden:

- ist `io.open` verfügbar?
- darf in `Saved Games` geschrieben werden?
- darf aus Projektordner gelesen werden?
- muss `MissionScripting.lua` angepasst werden?
- ist das für spätere Nutzer zumutbar?
- brauchen wir einen alternativen Exportweg?
- brauchen wir eine Build-/Save-Strategie außerhalb von DCS?

Wichtig:

    Am DCS-Sandbox-Verhalten wird erst gearbeitet, wenn die Grundsysteme stabil sind.

---

## Loader-only-Test und Persistenz

Noch nicht getestet:

    Starttest-Variante B — Loader-only mit dofile

Dieser Test ist indirekt relevant für Persistenz.

Prüffragen:

- Kann `loader.lua` lokale Dateien nachladen?
- Ist der Script-Root bekannt?
- Funktioniert Dateizugriff im DCS-Kontext?
- Gibt es Sandbox-Grenzen?
- Wird später eine Build-Datei benötigt?

Dieser Test ersetzt keinen Save-/Load-Test, hilft aber beim Verständnis der DCS-Dateiumgebung.

---

## Save/Load-Grundidee

Später soll Theater Command ungefähr so arbeiten:

1. Mission startet
2. Frameworks werden geladen
3. Theater Command wird geladen
4. Persistence prüft, ob ein Save existiert
5. Save wird geladen
6. State wird initialisiert
7. Campaign, World, Logistics, Missions, AI und IADS erhalten Daten
8. Mission läuft
9. wichtige Ereignisse verändern den State
10. State wird gespeichert
11. nächste Session lädt diesen State wieder

Diese Logik ist noch nicht implementiert.

---

## Manuelle Sicherung

In der frühen Entwicklungsphase bleibt GitHub das wichtigste Projektgedächtnis.

Das bedeutet:

- Code wird in GitHub versioniert
- Dokumentation wird in GitHub aktualisiert
- Testergebnisse werden dokumentiert
- Entscheidungen werden in Markdown-Dateien festgehalten

Die spätere Ingame-Persistenz ersetzt GitHub nicht.

Sie speichert nur den Kampagnenfortschritt.

---

## Verbindung zum UI-System

Später kann Persistenz über F10-Menüs oder Debug-Menüs sichtbar werden.

Mögliche Funktionen:

- Kampagnenstatus anzeigen
- Save-Status anzeigen
- letzter Save-Zeitpunkt
- manuelles Speichern
- Debug-State anzeigen
- Save-Fehler anzeigen

Aktueller Stand:

    UI-Bereich ist dokumentiert.
    F10-Menüs sind noch nicht implementiert.

---

## Verbindung zum Debug-System

Später soll ein State-Debug-Dump möglich sein.

Geplante Datei:

    src/debug/tc_debug_state_dump.lua

Mögliche Ausgabe:

- Campaign-State
- Airbase-State
- Zone-State
- Logistics-State
- FOB-State
- Mission-State
- AI-State
- IADS-State
- Event-State
- Save-Metadata

Aktuell wird dieser Debug-Dump noch nicht erstellt.

---

## Testanforderungen für Persistenz

Persistenz darf erst als funktional gelten, wenn folgende Tests bestanden sind:

- State kann in Memory erzeugt werden
- State kann serialisiert werden
- State kann wieder importiert werden
- Save-Datei kann geschrieben werden
- Save-Datei kann gelesen werden
- beschädigte Save-Datei wird erkannt
- fehlende Save-Datei wird sauber behandelt
- Versionsunterschied wird erkannt
- falsche Kampagne wird erkannt
- DCS startet auch ohne Save-Datei sauber
- Fehler werden sauber ins `dcs.log` geschrieben

---

## Nicht-Ziele im aktuellen Stand

Aktuell wird bewusst nicht umgesetzt:

- keine echte Datei-Persistenz
- kein Save-Ordner als produktives System
- kein automatisches Speichern
- kein manuelles F10-Speichern
- kein Save-Import
- kein Save-Export
- keine Save-Migration
- keine Multiplayer-Persistenz
- keine Datenbank
- keine externe App-Anbindung

---

## Nächster relevanter Schritt

Der nächste relevante Schritt für Persistenz ist nicht sofort Datei-Speichern.

Zuerst erforderlich:

    Airbase-Scanner klassifizieren und filtern.

Warum:

Persistenz braucht saubere Daten.

Erst wenn Theater Command unterscheiden kann zwischen:

- strategischen Airfields
- Secondary Airfields
- Heliports
- Helipads
- Medical Pads
- FARPs
- Tactical Pads
- Unknown

kann entschieden werden, welche Objekte dauerhaft im Kampagnenzustand gespeichert werden sollen.

---

## Aktueller Status

Das Persistenzsystem ist als Grundstruktur vorhanden und lädt erfolgreich in DCS.

Es ist noch nicht als echte Datei-Persistenz aktiv.

Der nächste übergeordnete technische Schritt bleibt die Airbase-Klassifizierung im World-System.
