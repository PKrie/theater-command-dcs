# Mission Generator

Diese Datei beschreibt den Missionsgenerator von **Theater Command DCS**.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut.

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## Zweck des Missionsgenerators

Der Missionsgenerator soll später aus dem aktuellen Kampagnenzustand dynamische, sinnvolle und spielbare Missionen erzeugen.

Er soll keine feste lineare Missionskette abarbeiten.

Stattdessen soll er auf Basis des aktuellen Zustands entscheiden, welche Missionen sinnvoll verfügbar sind.

Mögliche Einflussfaktoren:

- Besitzstatus von Airbases
- Besitzstatus von Zonen
- Airbase-Klassifizierung
- Logistikstatus
- FOB-Status
- IADS-Zustand
- AI-Aktivität
- Kampagnenphase
- bisherige Missionserfolge
- bisherige Missionsfehlschläge
- verfügbare blaue Basen
- verfügbare rote Ziele
- aktuelle Operationsreichweite

---

## Grundprinzip

Das zentrale Projektprinzip lautet:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Mission Editor stellt nur die Bühne bereit.

Die eigentliche Missionslogik liegt in Lua.

GitHub dokumentiert Struktur, Entscheidungen, Versionen, Aufgabenstand und Testergebnisse.

---

## Aktueller technischer Stand

Stand: 2026-06-16

Aktuelle Missions-Datei:

    src/missions/tc_mission_generator.lua

Der erste reale DCS-Starttest wurde durchgeführt.

Test:

    Starttest-Variante A — sichere Einzeldatei-Ladung

Ergebnis:

    Bestanden

Bestätigt wurde:

- Missions-Bereich wird geladen
- `tc_mission_generator.lua` wird geladen
- keine schweren Lua-Fehler beim Laden
- Missions wird durch Main als Runtime-System berücksichtigt
- Theater-Command-Startkette läuft sauber weiter

Aktueller Stand:

    Missionsgenerator ist technisch ladbar.
    Funktionale Missionsgenerator-Tests wurden noch nicht durchgeführt.
    Es werden noch keine spielbaren dynamischen Missionen erzeugt.

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

Dieser Befund ist für den Missionsgenerator besonders wichtig.

Problem:

    Der Missionsgenerator darf nicht ungefiltert alle 225 Airbase-/Helipad-Objekte als Missionsziele verwenden.

Nicht jedes von DCS erkannte Airbase-Objekt ist ein sinnvolles Missionsziel.

DCS kann unter anderem liefern:

- große Airfields
- kleinere Airfields
- Heliports
- Helipads
- Medical Pads
- FARPs
- taktische Pads
- unbekannte Objekte

Folgerung:

    Der Missionsgenerator darf erst produktiv auf Airbase-Daten zugreifen, wenn der Airbase-Scanner diese Objekte klassifiziert.

---

## Geplante Missionsarten

Der Missionsgenerator soll später verschiedene Missionsarten erzeugen können.

Geplante Typen:

    RECON
    CAP
    SEAD
    DEAD
    STRIKE
    CAS
    INTERDICTION
    ESCORT
    LOGISTICS
    FOB_SUPPORT
    AIRBASE_ATTACK
    AI_SUPPRESSION

Diese Typen sind als fachliche Zielstruktur vorgesehen.

Sie müssen schrittweise einzeln implementiert und getestet werden.

---

## Recon

Recon-Missionen dienen der Aufklärung.

Mögliche Ziele:

- unbekannte Airbases
- verdächtige Zonen
- IADS-Sektoren
- rote Logistikbereiche
- mögliche FOB-Standorte
- Frontbereiche
- strategische Ziele

Recon kann später Voraussetzung sein für:

- Strike-Missionen
- SEAD-Missionen
- Capture-Operationen
- Airbase-Angriffe
- Logistikplanung

---

## CAP

CAP-Missionen dienen der Luftüberlegenheit.

Mögliche Einsatzräume:

- über Akrotiri
- über Seewegen
- über Frontbereichen
- über Logistikkorridoren
- über bedrohten FOBs
- über späteren Capture-Zonen

CAP-Missionen können später mit dem AI-CAP-Manager verbunden werden.

Aktuelle AI-Datei:

    src/ai/tc_ai_cap_manager.lua

---

## SEAD

SEAD-Missionen dienen der Unterdrückung feindlicher Luftverteidigung.

Mögliche Ziele:

- aktive Radarstellungen
- SAM-Sites
- IADS-Knoten
- EWR-Standorte
- Verteidigungssektoren

SEAD benötigt später Daten aus:

- IADS-System
- AI-System
- World-System
- Campaign-State

Aktueller Stand:

    Skynet IADS wird geladen.
    Theater-Command-IADS-Schicht ist noch nicht implementiert.

---

## DEAD

DEAD-Missionen dienen der Zerstörung feindlicher Luftverteidigung.

Mögliche Ziele:

- SAM Launcher
- Search Radar
- Track Radar
- Command Nodes
- EWR
- mobile Luftverteidigung

DEAD-Missionen sollen später den IADS-Zustand dauerhaft verändern können.

Dafür wird Persistenz benötigt.

---

## Strike

Strike-Missionen dienen Angriffen auf strategische Ziele.

Mögliche Ziele:

- strategische Airfields
- Munitionslager
- Fuel Depots
- Kommandoposten
- Radarstandorte
- Brücken
- Infrastruktur
- logistische Knoten

Wichtig:

    Strike-Missionen dürfen nicht zufällig Medical Pads oder einzelne Helipads als strategische Ziele auswählen.

---

## CAS

CAS-Missionen unterstützen spätere Bodenkämpfe oder Capture-Operationen.

Mögliche Einsatzräume:

- Nähe strategischer Basen
- Nähe von FOBs
- umkämpfte Zonen
- Frontabschnitte
- rote Gegenangriffsachsen

CAS wird erst relevant, wenn Bodenzustände, Capture-Logik oder Frontlogik weiter ausgebaut sind.

---

## Interdiction

Interdiction-Missionen sollen später feindliche Bewegungen, Verstärkungen und Logistik stören.

Mögliche Ziele:

- Konvois
- Nachschubrouten
- Brücken
- Straßenzüge
- Depots
- mobile Einheiten
- Verstärkungskräfte

Interdiction benötigt später Daten aus:

- AI-System
- Logistics-System
- Campaign-System
- World-System

---

## Escort

Escort-Missionen schützen andere Missionen.

Mögliche Schutzaufgaben:

- Logistikflüge
- Transporthubschrauber
- Strike-Pakete
- SEAD-Pakete
- CSAR-Einsätze
- FOB-Support

Escort-Missionen werden erst sinnvoll, wenn Missionsketten oder Paketlogik eingeführt werden.

---

## Logistics

Logistics-Missionen unterstützen Versorgung und Operationsfähigkeit.

Mögliche Aufgaben:

- Nachschub nach Akrotiri
- Nachschub zu FOBs
- Supply-Flüge
- Transporthubschrauber-Aufgaben
- CTLD-Aufgaben
- Fuel-/Munitionstransport
- Versorgung von Forward Bases

Abhängigkeit:

    Logistics-Missionen benötigen saubere Logistikdaten und CTLD-Anbindung.

Aktuelle Logistik-Dateien:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

---

## FOB Support

FOB-Support-Missionen unterstützen Aufbau und Betrieb von Forward Operating Bases.

Mögliche Aufgaben:

- Material liefern
- Truppen liefern
- Luftsicherung stellen
- Nahbereich sichern
- Reparaturmaterial liefern
- Munition oder Fuel bringen
- FOB reaktivieren

FOB Support wird später eng mit CTLD verbunden.

---

## Airbase Attack

Airbase-Attack-Missionen greifen strategische Flugplätze an.

Mögliche Ziele:

- Runways
- Hangars
- Fuel Depots
- Munitionslager
- abgestellte Flugzeuge
- Radarobjekte
- Verteidigungsanlagen

Wichtig:

    Nur strategische Airfields und ausgewählte Secondary Airfields dürfen Airbase-Attack-Ziele werden.

Nicht geeignet:

- Medical Pads
- einzelne Helipads
- taktische Pads
- Unknown-Objekte

---

## AI Suppression

AI-Suppression-Missionen sollen später feindliche KI-Aktivität reduzieren.

Mögliche Ziele:

- CAP-Startbasen
- GCI-Knoten
- AI-Verstärkungsrouten
- rote Operationszentren
- Logistikzentren
- taktische Sammelpunkte

Diese Missionsart ist erst sinnvoll, wenn der AI Director weiter ausgebaut ist.

---

## Missionsstatus

Missionen sollen später einen klaren Status besitzen.

Geplante Statuswerte:

    AVAILABLE
    ACTIVE
    COMPLETED
    FAILED
    EXPIRED
    CANCELLED

Bedeutung:

- `AVAILABLE`: Mission ist verfügbar, aber noch nicht aktiv
- `ACTIVE`: Mission wurde angenommen oder ausgelöst
- `COMPLETED`: Mission wurde erfolgreich abgeschlossen
- `FAILED`: Mission wurde nicht erfüllt oder ist gescheitert
- `EXPIRED`: Mission ist zeitlich abgelaufen
- `CANCELLED`: Mission wurde durch System oder Spieler abgebrochen

---

## Missionsprioritäten

Missionen sollen später priorisiert werden können.

Mögliche Prioritäten:

    LOW
    MEDIUM
    HIGH
    CRITICAL

Beispiele:

- Verteidigung Akrotiri: `CRITICAL`
- SEAD vor Strike-Paket: `HIGH`
- optionaler Recon-Auftrag: `LOW`
- FOB-Nachschub unter Bedrohung: `HIGH`
- Routine-CAP: `MEDIUM`

---

## Geplante Missionsdatenstruktur

Eine spätere Mission könnte ungefähr so aussehen:

    {
        id = "MISSION_SEAD_001",
        type = "SEAD",
        status = "AVAILABLE",
        priority = "HIGH",
        origin = "Akrotiri",
        target = "SYRIA_IADS_SITE_001",
        targetType = "IADS_SITE",
        requiredState = {},
        rewards = {},
        penalties = {},
        createdAt = 1200,
        expiresAt = 7200
    }

Diese Struktur ist noch nicht final.

Sie dient als fachliche Orientierung.

---

## Verbindung zum Campaign-System

Der Missionsgenerator soll Missionen aus dem Kampagnenzustand erzeugen.

Campaign liefert später:

- Besitzstatus
- Capture-Zustände
- verfügbare strategische Basen
- umkämpfte Zonen
- Kampagnenphase
- bisherige Ergebnisse

Missions meldet später zurück:

- Mission erfolgreich
- Mission fehlgeschlagen
- Ziel beschädigt
- Ziel zerstört
- Capture vorbereitet
- Logistik unterstützt
- IADS geschwächt
- AI unterdrückt

Wichtig:

    Missions verändert strategischen Besitz nicht direkt.
    Campaign entscheidet über Besitz und Capture.

---

## Verbindung zum Logistics-System

Logistik beeinflusst, welche Missionen möglich sind.

Beispiele:

- Ohne FOB keine FOB-Support-Missionen.
- Ohne Supply keine große Capture-Operation.
- Erfolgreiche Logistik kann neue Missionen freischalten.
- Schlechter Nachschub kann Missionen verhindern.
- CTLD-Aufgaben können Logistikmissionen erzeugen.

Aktueller Stand:

    Logistikmodule laden.
    CTLD ist geladen.
    Theater Command nutzt CTLD noch nicht produktiv.

---

## Verbindung zum AI-System

AI beeinflusst Missionsverfügbarkeit und Missionsrisiko.

Beispiele:

- starke rote CAP erzeugt CAP- oder Escort-Bedarf
- rote Gegenangriffe erzeugen CAS- oder Interdiction-Missionen
- GCI-Aktivität beeinflusst Luftüberlegenheitsmissionen
- AI-Verstärkungen erzeugen Strike- oder Interdiction-Ziele

Aktueller Stand:

    AI-CAP-Manager lädt.
    Reale MOOSE-CAP-Spawns sind noch nicht implementiert.

---

## Verbindung zum IADS-System

IADS beeinflusst SEAD-, DEAD-, Strike- und Logistics-Missionen.

Beispiele:

- aktive SAM-Sektoren erzeugen SEAD-Missionen
- zerstörte Radare öffnen Strike-Korridore
- gefährliche IADS-Zonen verhindern Logistikmissionen
- DEAD-Erfolge verändern spätere Missionsauswahl

Aktueller Stand:

    Skynet IADS wird geladen.
    Theater-Command-IADS-Schicht ist noch nicht implementiert.

---

## Verbindung zum UI-System

Missionen sollen später über F10-Menüs sichtbar und nutzbar werden.

Geplante Anzeigen:

- verfügbare Missionen
- aktive Missionen
- Missionsdetails
- Missionsstatus
- Priorität
- Zielgebiet
- Belohnung oder Kampagneneffekt
- Missionsabbruch
- Debuginformationen

Aktueller Stand:

    UI-Bereich ist dokumentiert.
    F10-Menüs sind noch nicht implementiert.

---

## Verbindung zur Persistenz

Missionen müssen später persistent gespeichert werden.

Zu speichern sind unter anderem:

- verfügbare Missionen
- aktive Missionen
- abgeschlossene Missionen
- fehlgeschlagene Missionen
- Missionsziele
- Missionswirkungen
- erzeugte Missionshistorie
- Kampagneneffekte

Aktueller Stand:

    In-Memory-Persistenz ist vorbereitet.
    Datei-Persistenz ist noch nicht getestet.

---

## Verbindung zum Debug-System

Später soll ein Missions-Debugreport möglich sein.

Geplante Datei:

    src/debug/tc_debug_mission_report.lua

Mögliche Ausgabe:

- Anzahl verfügbarer Missionen
- Anzahl aktiver Missionen
- Anzahl abgeschlossener Missionen
- Anzahl fehlgeschlagener Missionen
- Missionsarten nach Typ
- Missionsziele
- Missionsprioritäten
- Gründe für Missionserzeugung
- Gründe für nicht erzeugte Missionen

Aktuell wird dieser Debugreport noch nicht erstellt.

---

## Mission-Editor-Anforderungen

Später benötigt der Missionsgenerator Mission-Editor-Elemente.

Mögliche Elemente:

- Template-Gruppen
- Late-Activation-Gruppen
- statische Zielobjekte
- manuelle Sonderzonen
- rote SAM-Stellungen
- rote Radarstellungen
- Logistikobjekte
- FOB-Zonen
- CTLD-Zonen

Aktuell noch nicht angelegt:

    keine roten Template-Gruppen
    keine roten IADS-Stellungen
    keine Missionsziele
    keine CTLD-Zonen
    keine FOB-Zonen

Grund:

    Zuerst muss die Airbase-Klassifizierung stabil sein.

---

## Nicht-Ziele im aktuellen Stand

Aktuell wird bewusst nicht umgesetzt:

- keine vollständige dynamische Missionsgenerierung
- keine F10-Missionsauswahl
- keine Missionserfolgserkennung
- keine komplexe Zielauswahl
- keine SEAD-/DEAD-Logik
- keine Strike-Pakete
- keine Escort-Pakete
- keine Capture-Missionen
- keine Missionspersistenz in Datei
- keine automatische `.miz`-Erzeugung

---

## Nächster relevanter Schritt

Der nächste relevante Schritt für den Missionsgenerator ist nicht sofort die Erzeugung spielbarer Missionen.

Zuerst erforderlich:

    Airbase-Scanner klassifizieren und filtern.

Warum:

Der Missionsgenerator braucht saubere Ziele.

Erst wenn Theater Command unterscheiden kann zwischen:

- strategischen Airfields
- Secondary Airfields
- Heliports
- Helipads
- Medical Pads
- FARPs
- Tactical Pads
- Unknown

kann der Missionsgenerator zuverlässig entscheiden, welche Objekte als Missionsziele geeignet sind.

---

## Aktueller Status

Der Missionsgenerator ist als Grundstruktur vorhanden und lädt erfolgreich in DCS.

Er erzeugt noch keine produktiven spielbaren Missionen.

Der nächste übergeordnete technische Schritt bleibt die Airbase-Klassifizierung im World-System.
