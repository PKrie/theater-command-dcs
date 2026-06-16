# IADS System

Diese Datei beschreibt das geplante IADS-System von **Theater Command DCS**.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut.

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## Zweck des IADS-Systems

Das IADS-System soll später die feindliche integrierte Luftverteidigung als Teil des Kampagnenzustands abbilden.

IADS steht für:

    Integrated Air Defense System

Theater Command DCS nutzt dafür später **Skynet IADS** als externes Framework.

Theater Command selbst soll nicht Skynet IADS ersetzen.

Theater Command soll eine Kampagnenschicht über Skynet IADS legen.

Ziel ist, dass Luftverteidigung nicht nur statisch vorhanden ist, sondern kampagnenlogisch relevant wird.

---

## Grundprinzip

Das zentrale Projektprinzip lautet:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Mission Editor stellt die Bühne bereit.

Skynet IADS stellt die technische IADS-Funktion bereit.

Theater Command verwaltet den Kampagnenzustand darüber.

GitHub dokumentiert Struktur, Entscheidungen, Versionen, Aufgabenstand und Testergebnisse.

---

## Aktueller technischer Stand

Stand: 2026-06-16

Aktueller IADS-Stand:

    Skynet IADS wird als Framework geladen.
    Theater-Command-IADS-Schicht ist noch nicht aktiv implementiert.

Framework-Datei:

    vendor/skynet-iads/SkynetIADS.lua

Der erste reale DCS-Starttest wurde durchgeführt.

Test:

    Starttest-Variante A — sichere Einzeldatei-Ladung

Ergebnis:

    Bestanden

Bestätigt wurde:

- Skynet IADS wird geladen
- Skynet IADS wird durch Theater Command erkannt
- keine schweren Lua-Fehler durch Skynet IADS im Starttest
- eigene Theater-Command-Startkette läuft sauber weiter

Noch nicht vorhanden:

    src/iads/tc_iads_network.lua
    src/iads/tc_iads_sector_manager.lua
    src/iads/tc_iads_site_registry.lua
    src/iads/tc_iads_mission_bridge.lua

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

## Verbindung zum Airbase-System

Der erste reale DCS-Test ergab:

    Airbase-Scanner registrierte 225 Airbase-/Helipad-Objekte.
    Zone-Factory registrierte 225 Zonen.

Dieser Befund ist auch für IADS wichtig.

Problem:

    Nicht jedes Airbase-/Helipad-Objekt darf automatisch als IADS-relevanter Standort behandelt werden.

IADS-Standorte müssen später gezielt definiert werden.

Mögliche IADS-nahe Objekte:

- strategische Airfields
- Radarstellungen
- SAM-Sites
- EWR-Standorte
- Command Nodes
- Air Defense Sectors
- wichtige Logistikhubs
- militärische Basen

Nicht automatisch IADS-relevant:

- Medical Pads
- einzelne Helipads
- unbekannte Airbase-Objekte
- rein zivile oder taktische Pads

Folgerung:

    Auch IADS braucht saubere World-Daten.
    Die Airbase-Klassifizierung ist Voraussetzung für sinnvolle IADS-Sektorlogik.

---

## Rolle von Skynet IADS

Skynet IADS ist das externe Framework für realistische Luftverteidigungslogik.

Skynet IADS kann unter anderem:

- SAM-Systeme vernetzen
- Radarabhängigkeiten abbilden
- IADS-Kommunikation simulieren
- EWR- und SAM-Verhalten koordinieren
- Systeme aktivieren oder deaktivieren
- Luftverteidigung dynamischer wirken lassen

Theater Command soll darüber speichern und bewerten:

- welche IADS-Sektoren existieren
- welche SAM-Sites aktiv sind
- welche Radare zerstört sind
- welche Sektoren geschwächt sind
- welche Ziele für SEAD/DEAD relevant sind
- welche IADS-Schäden persistent bleiben
- wie AI auf IADS-Schäden reagiert
- welche Missionen daraus entstehen

---

## Architekturregel

Skynet IADS bleibt Framework.

Theater Command verändert keine Skynet-IADS-Dateien.

Eigene IADS-Logik gehört später nach:

    src/iads/

Geplante Regel:

    Skynet IADS führt technische IADS-Logik aus.
    Theater Command verwaltet Kampagnenzustand, Missionsbezug und Persistenz.

---

## Geplante IADS-Module

### `src/iads/tc_iads_network.lua`

Geplante Aufgabe:

- IADS-Netzwerke definieren
- Skynet-IADS-Instanzen kapseln
- rote IADS-Netzwerke vorbereiten
- spätere blaue IADS-Netzwerke optional vorbereiten
- Netzwerkstatus an Theater Command melden

---

### `src/iads/tc_iads_sector_manager.lua`

Geplante Aufgabe:

- IADS-Sektoren verwalten
- Sektorstatus speichern
- Sektoren mit Airbases und Zonen verbinden
- Bedrohungsräume definieren
- SEAD-/DEAD-Relevanz vorbereiten

Mögliche Sektorstatus:

    ACTIVE
    DEGRADED
    SUPPRESSED
    DESTROYED
    OFFLINE
    UNKNOWN

---

### `src/iads/tc_iads_site_registry.lua`

Geplante Aufgabe:

- SAM-Sites registrieren
- Radarstandorte registrieren
- EWR-Standorte registrieren
- Command Nodes registrieren
- Status einzelner IADS-Elemente speichern
- spätere Persistenz vorbereiten

Mögliche Site-Typen:

    SAM_SITE
    SEARCH_RADAR
    TRACK_RADAR
    EWR
    COMMAND_NODE
    AAA_SITE
    SHORAD_SITE
    UNKNOWN

---

### `src/iads/tc_iads_mission_bridge.lua`

Geplante Aufgabe:

- IADS-Zustand an Missionsgenerator melden
- SEAD-Ziele vorbereiten
- DEAD-Ziele vorbereiten
- Strike-Ziele vorbereiten
- Missionswirkungen auf IADS-Zustand zurückmelden
- IADS-Schäden an Campaign und Persistence weitergeben

---

## Geplante IADS-Datenstruktur

Ein späterer IADS-Sektor könnte ungefähr so aussehen:

    {
        id = "IADS_SECTOR_COAST_01",
        name = "Syrian Coast North",
        coalition = "red",
        status = "ACTIVE",
        sites = {
            "SAM_SITE_001",
            "EWR_001",
            "COMMAND_NODE_001"
        },
        protectedBases = {
            "Latakia",
            "Bassel Al-Assad"
        },
        threatLevel = "HIGH",
        lastUpdated = 1200
    }

Diese Struktur ist noch nicht final.

Sie dient als fachliche Orientierung.

---

## Geplante SAM-Site-Datenstruktur

Eine spätere SAM-Site könnte ungefähr so aussehen:

    {
        id = "SAM_SITE_001",
        name = "SA-10 Coastal Battery",
        type = "SAM_SITE",
        coalition = "red",
        sector = "IADS_SECTOR_COAST_01",
        status = "ACTIVE",
        position = {},
        skynetName = "RED_SAM_SA10_001",
        isMissionTarget = true,
        isPersistent = true
    }

Diese Struktur ist noch nicht final.

---

## IADS-Statuswerte

Geplante Statuswerte:

    ACTIVE
    DEGRADED
    SUPPRESSED
    DESTROYED
    OFFLINE
    UNKNOWN

Bedeutung:

- `ACTIVE`: System ist kampagnenlogisch aktiv
- `DEGRADED`: System ist geschwächt, aber nicht ausgeschaltet
- `SUPPRESSED`: System ist vorübergehend unterdrückt
- `DESTROYED`: System ist zerstört
- `OFFLINE`: System ist nicht aktiv oder nicht verfügbar
- `UNKNOWN`: Status ist noch nicht bekannt

---

## Bedrohungsstufen

IADS-Sektoren können später Bedrohungsstufen erhalten.

Geplante Werte:

    LOW
    MEDIUM
    HIGH
    CRITICAL

Diese Werte können beeinflussen:

- Missionsauswahl
- SEAD-Priorität
- DEAD-Priorität
- Strike-Routen
- Logistikrisiko
- AI-Reaktionen
- Spielerbriefing
- F10-Statusanzeigen

---

## Verbindung zum Missionsgenerator

IADS ist besonders wichtig für folgende Missionsarten:

- SEAD
- DEAD
- STRIKE
- ESCORT
- LOGISTICS
- RECON
- AI_SUPPRESSION

Beispiele:

- Aktiver IADS-Sektor erzeugt SEAD-Mission.
- Zerstörtes Radar reduziert Bedrohung.
- Geschwächte SAM-Site wird DEAD-Ziel.
- Intakter IADS-Sektor erschwert Logistikmissionen.
- Recon-Mission kann unbekannte IADS-Sites aufdecken.

Aktueller Stand:

    Missionsgenerator lädt.
    IADS-Mission-Bridge ist noch nicht implementiert.

---

## Verbindung zum AI Director

IADS soll später AI-Reaktionen beeinflussen.

Beispiele:

- zerstörte SAM-Site löst rote CAP-Reaktion aus
- verlorener Radarstandort verschiebt GCI-Verhalten
- kritischer IADS-Sektor wird verstärkt
- SEAD-Erfolg öffnet Korridor für blaue Missionen
- IADS-Schäden erhöhen rote Eskalation
- intakter IADS-Sektor schützt wichtige Basen

Aktueller Stand:

    AI-CAP-Manager lädt.
    Vollständiger AI Director ist noch nicht implementiert.

---

## Verbindung zum Campaign-System

IADS soll Teil des Kampagnenzustands werden.

Campaign kann später speichern:

- welcher IADS-Sektor aktiv ist
- welche SAM-Sites zerstört sind
- welche Radare noch funktionieren
- welche IADS-Zonen unterdrückt sind
- welche Basen dadurch verwundbarer werden
- welche Capture-Operationen dadurch möglich werden

Wichtig:

    IADS entscheidet nicht über Besitz.
    Campaign entscheidet über Besitz und Capture.
    IADS liefert Bedrohungs- und Verteidigungszustände.

---

## Verbindung zum Logistics-System

IADS beeinflusst Logistik erheblich.

Beispiele:

- aktive SAM-Sektoren blockieren Logistikrouten
- SEAD-Erfolg ermöglicht Luftbrücken
- zerstörte Radare erleichtern Hubschrauberlogistik
- starke IADS-Bedrohung erzwingt Escort
- FOB-Aufbau kann erst nach IADS-Schwächung sicher sein

Aktueller Stand:

    Logistics-Module laden.
    Keine produktive IADS-Logistics-Verbindung implementiert.

---

## Verbindung zum Airbase-System

Strategische Airfields können später durch IADS geschützt werden.

Beispiele:

- rote Airbase besitzt zugehörigen IADS-Sektor
- Airbase-Angriff benötigt vorher SEAD/DEAD
- Capture einer Airbase wird durch aktive IADS erschwert
- zerstörte IADS macht Airbase verwundbarer
- AI priorisiert Schutz wichtiger Airfields

Dafür muss das Airbase-System zuerst klassifizieren:

- strategische Airfields
- Secondary Airfields
- Heliports
- Helipads
- Medical Pads
- FARPs
- Tactical Pads
- Unknown

---

## Verbindung zum UI-System

Später sollen IADS-Daten im F10-Menü oder Debug-Menü sichtbar werden.

Mögliche Anzeigen:

- bekannte IADS-Sektoren
- Bedrohungsstufe
- aktive SAM-Sites
- zerstörte SAM-Sites
- erkannte Radare
- SEAD-Ziele
- DEAD-Ziele
- IADS-Status pro Region

Aktueller Stand:

    UI-Bereich ist dokumentiert.
    F10-Menüs sind noch nicht implementiert.

---

## Verbindung zur Persistenz

IADS-Zustand muss später persistent gespeichert werden.

Zu speichern sind:

- aktive IADS-Sektoren
- zerstörte SAM-Sites
- beschädigte Radare
- unterdrückte Systeme
- erkannte Ziele
- unbekannte Ziele
- Sektorstatus
- Bedrohungsstufen
- Missionseffekte

Aktueller Stand:

    In-Memory-Persistenz ist vorbereitet.
    Datei-Persistenz ist noch nicht getestet.

Wichtig:

    DCS-Dateizugriff und DCS-Sandbox-Verhalten müssen vor echter Dateipersistenz praktisch geprüft werden.

---

## Verbindung zum Debug-System

Später soll ein IADS-Debugreport möglich sein.

Geplante Datei:

    src/debug/tc_debug_iads_report.lua

Mögliche Ausgabe:

- Anzahl IADS-Sektoren
- Status je Sektor
- Anzahl SAM-Sites
- Anzahl aktiver SAM-Sites
- Anzahl zerstörter SAM-Sites
- erkannte Radare
- Bedrohungsstufen
- SEAD-Ziele
- DEAD-Ziele
- Verknüpfung zu Airbases
- Verknüpfung zu Missionen

Aktuell wird dieser Debugreport noch nicht erstellt.

---

## Mission-Editor-Anforderungen für IADS

Später werden im Mission Editor voraussichtlich benötigt:

- rote SAM-Gruppen
- Radargruppen
- EWR-Gruppen
- Command Nodes
- Strom-/Kommunikationsobjekte optional
- IADS-Testzonen
- Late-Activation-Gruppen
- statische Schutzobjekte
- Debug-Testziele

Aktuell noch nicht angelegt:

    keine roten IADS-Stellungen
    keine SAM-Templates
    keine Radar-Templates
    keine EWR-Struktur
    keine IADS-Sektoren

Grund:

    Zuerst müssen Airbase-Klassifizierung und grundlegende World-Daten stabil sein.

---

## Nicht-Ziele im aktuellen Stand

Aktuell wird bewusst nicht umgesetzt:

- keine vollständige IADS-Struktur
- keine SAM-Site-Platzierung
- keine IADS-Sektoren
- keine SEAD-/DEAD-Missionen
- keine Skynet-IADS-Netzwerklogik
- keine IADS-Persistenz
- keine IADS-F10-Menüs
- keine IADS-Debugreports
- keine roten Template-Gruppen

---

## Nächster relevanter Schritt

Der nächste relevante Schritt für das IADS-System ist nicht die sofortige Platzierung roter SAM-Stellungen.

Zuerst erforderlich:

    Airbase-Scanner klassifizieren und filtern.

Warum:

IADS braucht saubere World-Daten.

Erst wenn Theater Command strategische Airfields, Secondary Airfields, Heliports, Helipads, Medical Pads, FARPs und Unknown-Objekte unterscheiden kann, kann entschieden werden, welche Orte durch IADS geschützt oder bedroht werden sollen.

---

## Aktueller Status

Skynet IADS ist im Projekt vorhanden und wurde im ersten DCS-Starttest erfolgreich geladen.

Die Theater-Command-IADS-Schicht ist noch nicht implementiert.

Der nächste übergeordnete technische Schritt bleibt die Airbase-Klassifizierung im World-System.
