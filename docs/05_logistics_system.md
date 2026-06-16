# Logistics System

Diese Datei beschreibt das Logistiksystem von **Theater Command DCS**.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut.

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## Zweck des Logistiksystems

Das Logistiksystem soll später Versorgung, Nachschub, FOB-Aufbau und operative Reichweite der Kampagne steuern.

Logistik soll nicht nur ein Nebensystem sein.

Sie soll später direkten Einfluss haben auf:

- verfügbare Missionen
- FOB-Aufbau
- Capture-Fähigkeit
- Operationsreichweite
- Nachschubstatus
- Basisversorgung
- Helikopteroperationen
- CTLD-Aufgaben
- AI-Reaktionen
- Kampagnenfortschritt

---

## Grundprinzip

Das zentrale Projektprinzip lautet:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Mission Editor stellt nur die Bühne bereit.

Die eigentliche Logistiklogik liegt in Lua.

GitHub dokumentiert Struktur, Entscheidungen, Versionen, Aufgabenstand und Testergebnisse.

---

## Aktueller technischer Stand

Stand: 2026-06-16

Aktuelle Logistik-Dateien:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

Der erste reale DCS-Starttest wurde durchgeführt.

Test:

    Starttest-Variante A — sichere Einzeldatei-Ladung

Ergebnis:

    Bestanden

Bestätigt wurde:

- Logistics-Bereich wird geladen
- `tc_logistics_delivery.lua` wird geladen
- `tc_fob_system.lua` wird geladen
- keine schweren Lua-Fehler beim Laden
- Logistics wird durch Main als Runtime-System berücksichtigt
- Theater-Command-Startkette läuft sauber weiter

Aktueller Stand:

    Logistikmodule sind technisch ladbar.
    Funktionale Logistiktests wurden noch nicht durchgeführt.
    CTLD ist geladen, aber noch nicht produktiv mit Theater Command verbunden.

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

## Rolle von Akrotiri

Akrotiri ist zu Kampagnenbeginn die wichtigste blaue Logistikbasis.

Fachliche Rolle:

- Blue Main Operating Base
- initialer Nachschubknoten
- Startpunkt für Luftoperationen
- Startpunkt für spätere Logistikflüge
- möglicher CTLD-Pickup-Bereich
- Ausgangspunkt für FOB-Aufbau
- nicht initial capturable
- nicht erstes feindliches Missionsziel

Aktuell ist Akrotiri bereits als blauer Startbereich im Mission Editor vorhanden.

Die konkrete Logistikrolle wird später im Code und durch passende Mission-Editor-Zonen ausgebaut.

---

## Verbindung zum Airbase-System

Der erste DCS-Test ergab:

    Airbase-Scanner registrierte 225 Airbase-/Helipad-Objekte.
    Zone-Factory registrierte 225 Zonen.

Dieser Befund ist für das Logistiksystem wichtig.

Problem:

    Nicht jedes Airbase-Objekt darf automatisch ein Logistikhub werden.

DCS meldet auf der Syria Map offenbar viele Airbase-ähnliche Objekte.

Dazu können gehören:

- große Airfields
- kleinere Airfields
- Heliports
- Helipads
- Medical Pads
- FARPs
- taktische Pads
- unbekannte Objekte

Folgerung:

    Das Logistiksystem darf erst produktiv auf Airbase-Daten zugreifen, wenn der Airbase-Scanner diese Objekte klassifiziert.

---

## Geplante Logistikrollen nach Airbase-Klasse

### Strategische Airfields

Strategische Airfields können später große Logistikhubs sein.

Mögliche Funktionen:

- Supply-Lager
- Fuel-Lager
- Munition
- Ersatzteile
- Engineering-Kapazität
- FOB-Unterstützung
- Startpunkt für Logistikmissionen
- Zielpunkt für Nachschubmissionen

---

### Secondary Airfields

Secondary Airfields können später begrenzte Logistikfunktionen erhalten.

Mögliche Funktionen:

- Forward Supply Point
- begrenzter Fuel-Bestand
- begrenzte Munitionsversorgung
- Zwischenlandeplatz
- temporärer Hub

---

### Heliports

Heliports können später für Hubschrauberlogistik genutzt werden.

Mögliche Funktionen:

- CTLD-Pickup
- CTLD-Dropoff
- CSAR-Unterstützung
- MEDEVAC-Unterstützung
- AH-64D-Operationen
- Transporthubschrauber-Aufträge

---

### Helipads

Helipads sind taktische Landeplätze.

Mögliche Funktionen:

- Dropoff-Punkt
- MEDEVAC-Punkt
- CSAR-Punkt
- taktische Landezone
- temporärer Missionspunkt

Nicht vorgesehen als Standard:

- großer Logistikhub
- strategisches Capture-Ziel
- primärer Missionsgenerator-Airbase-Zielpunkt

---

### Medical Pads

Medical Pads können später für spezielle Szenarien genutzt werden.

Mögliche Funktionen:

- MEDEVAC
- CSAR
- humanitäre Missionen
- zivile Infrastruktur
- medizinische Evakuierung

Nicht vorgesehen:

- strategischer Logistikhub
- Standard-Capture-Ziel
- Strike-Ziel
- CAP-Zentrum

---

### FARPs

FARPs sind für das Logistiksystem besonders relevant.

Mögliche Funktionen:

- Forward Arming and Refueling
- AH-64D-Versorgung
- Hubschrauberlogistik
- CTLD-Knoten
- temporärer Frontstützpunkt
- FOB-Ausbaustufe

FARPs gehören fachlich eng zum FOB-System.

---

## Aktuelle Logistikmodule

### `src/logistics/tc_logistics_delivery.lua`

Aufgabe:

- Lieferungen vorbereiten
- Lieferstatus verwalten
- Lieferungen registrieren
- Lieferungen abschließen
- Lieferungen fehlschlagen lassen
- spätere CTLD-Anbindung vorbereiten

Aktueller Stand:

    Datei vorhanden.
    Datei wird geladen.
    Noch kein funktionaler DCS-Logistiktest durchgeführt.

---

### `src/logistics/tc_fob_system.lua`

Aufgabe:

- FOB-Daten vorbereiten
- FOB-Aufbau verwalten
- FOB-Status speichern
- spätere Verbindung zu CTLD und Logistics Delivery vorbereiten

Aktueller Stand:

    Datei vorhanden.
    Datei wird geladen.
    Noch kein funktionaler FOB-Test durchgeführt.

---

## Geplante spätere Logistikmodule

Mögliche spätere Dateien:

    src/logistics/tc_supply_manager.lua
    src/logistics/tc_ctld_bridge.lua
    src/logistics/tc_logistics_hub.lua
    src/logistics/tc_farp_manager.lua

Diese Dateien werden noch nicht erstellt.

Grund:

    Zuerst müssen Airbase-Klassifizierung und World-Daten stabil sein.

---

## CTLD-Anbindung

CTLD ist bereits als externes Framework im Projekt vorhanden.

Aktuelle Dateien:

    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua

CTLD wurde im ersten Starttest geladen.

Aktueller Status:

    CTLD wird geladen.
    CTLD wird durch den Loader erkannt.
    Theater Command nutzt CTLD noch nicht produktiv.

Geplante spätere CTLD-Aufgaben:

- Pickup-Zonen
- Dropoff-Zonen
- FOB-Bau
- Transport von Versorgungsgütern
- Transport von Truppen
- Slingload
- Hubschrauberlogistik
- Rückmeldung von CTLD-Ereignissen an Theater Command

---

## Logistikdaten im Kampagnenzustand

Später soll der Kampagnenzustand Logistikdaten enthalten.

Mögliche Daten:

    supply
    fuel
    ammunition
    engineering
    medical
    spareParts
    activeDeliveries
    completedDeliveries
    failedDeliveries
    activeFobs
    fobConstructionProgress
    logisticsHubs
    ctldZones

Diese Daten werden später von mehreren Systemen genutzt:

- Campaign
- Missions
- AI
- UI
- Persistence
- Debug

---

## Beispiel für eine spätere Lieferung

Beispielhafte spätere Datenstruktur:

    {
        id = "DELIVERY_AKROTIRI_FOB_001",
        origin = "Akrotiri",
        destination = "FOB_SITE_01",
        type = "SUPPLY",
        amount = 100,
        status = "ACTIVE",
        createdAt = 1200,
        completedAt = nil
    }

Statuswerte könnten später sein:

    PLANNED
    ACTIVE
    COMPLETED
    FAILED
    CANCELLED

---

## FOB-System

FOBs sollen später durch Logistik aufgebaut werden.

Mögliche FOB-Zustände:

    PLANNED
    UNDER_CONSTRUCTION
    OPERATIONAL
    DAMAGED
    DESTROYED
    ABANDONED

FOBs können später freischalten:

- Helikopterlandeplatz
- CTLD-Dropoff
- Munition
- Fuel
- Reparatur
- Forward Spawn
- CAS-Missionen
- Capture-Unterstützung
- lokale Verteidigung

---

## Verbindung zum Capture-System

Logistik soll später Capture beeinflussen.

Beispiele:

- Ein Angriff auf eine Basis ist nur möglich, wenn ausreichend Versorgung vorhanden ist.
- Ein FOB in der Nähe erleichtert Capture.
- Fehlender Nachschub verzögert Capture.
- Erfolgreiche Logistikmissionen erhöhen Operationsreichweite.
- Zerstörte Logistik senkt Kampagnenfähigkeit.

Wichtig:

    Logistics entscheidet nicht allein über Besitz.
    Campaign entscheidet über Besitz und Capture.
    Logistics liefert dafür relevante Zustandsdaten.

---

## Verbindung zum Missionsgenerator

Der Missionsgenerator soll später Logistikmissionen erzeugen können.

Mögliche Missionstypen:

- Logistics
- FOB Support
- Convoy Escort
- Airlift
- Helicopter Supply
- CSAR Support
- MEDEVAC
- Forward Resupply

Der Missionsgenerator darf Logistikziele erst dann sinnvoll auswählen, wenn:

- Airbases klassifiziert sind
- FOB-Standorte definiert sind
- CTLD-Zonen vorhanden sind
- Logistikzustand im State gespeichert ist

---

## Verbindung zur AI

Die AI kann später auf Logistik reagieren.

Mögliche Reaktionen:

- rote Angriffe auf blaue FOBs
- Interdiction gegen Nachschub
- CAP über wichtigen Logistikkorridoren
- GCI gegen Transportflüge
- Verteidigung wichtiger roter Hubs
- Gegenangriffe bei schwacher blauer Versorgung

Aktueller Stand:

    AI-CAP-Manager ist geladen.
    Keine reale Logistik-AI-Verbindung implementiert.

---

## Verbindung zur IADS

IADS kann später Logistik beeinflussen.

Beispiele:

- aktive SAM-Sites erschweren Logistikflüge
- SEAD-Erfolge öffnen Korridore
- zerstörte Radare erleichtern Transport
- IADS-Sektoren bestimmen Risiko von Logistikmissionen

Aktueller Stand:

    Skynet IADS ist geladen.
    Theater-Command-IADS-Schicht ist noch nicht implementiert.

---

## Verbindung zur Persistenz

Logistik muss später persistent gespeichert werden.

Zu speichern sind unter anderem:

- aktive Lieferungen
- abgeschlossene Lieferungen
- fehlgeschlagene Lieferungen
- FOB-Status
- FOB-Ausbaustufen
- Supply-Werte
- Fuel-Werte
- Munitionswerte
- Logistikhubs
- CTLD-Zonenstatus

Aktueller Stand:

    In-Memory-Persistenz vorbereitet.
    Datei-Persistenz noch nicht getestet.

Wichtig:

    DCS-Dateizugriff und Sandbox-Verhalten müssen vor echter Dateipersistenz geprüft werden.

---

## Verbindung zum UI-System

Später sollen Logistikdaten über F10-Menüs sichtbar werden.

Mögliche Anzeigen:

- aktuelle Supply-Lage
- verfügbare Logistikmissionen
- aktive Lieferungen
- FOB-Baufortschritt
- verfügbare CTLD-Aufgaben
- gefährdete Logistikkorridore
- abgeschlossene Lieferungen

Aktueller Stand:

    UI-Bereich ist dokumentiert.
    F10-Menüs sind noch nicht implementiert.

---

## Debug-Anforderungen

Später soll ein Logistik-Debugreport möglich sein.

Geplante Datei:

    src/debug/tc_debug_logistics_report.lua

Mögliche Ausgabe:

- Anzahl aktiver Lieferungen
- Anzahl abgeschlossener Lieferungen
- Anzahl fehlgeschlagener Lieferungen
- FOB-Liste
- FOB-Status
- Supply-Werte pro Hub
- CTLD-Zonenstatus
- Logistikfehler
- offene Logistikmissionen

Aktuell wird dieser Debugreport noch nicht erstellt.

---

## Mission-Editor-Anforderungen für spätere Logistik

Später werden im Mission Editor wahrscheinlich benötigt:

- CTLD-Pickup-Zonen
- CTLD-Dropoff-Zonen
- FOB-Bauzonen
- statische Logistikobjekte
- Lagerobjekte
- Transporthubschrauber-Slots
- mögliche Konvoi-Templates
- mögliche Transportflugzeug-Templates

Aktuell noch nicht angelegt:

    keine CTLD-Zonen
    keine FOB-Zonen
    keine Logistik-Templates
    keine Logistikobjekte

Grund:

    Zuerst muss die Airbase-Klassifizierung stabil sein.

---

## Nicht-Ziele im aktuellen Stand

Aktuell wird bewusst nicht umgesetzt:

- keine produktive CTLD-Anbindung
- keine FOB-Baumechanik
- keine komplexen Lieferketten
- keine Konvois
- keine Supply-Berechnung
- keine Fuel-Berechnung
- keine Munitionswirtschaft
- keine UI-Anzeige
- keine Persistenz in Datei
- keine roten Logistikziele
- keine Logistik-AI-Reaktionen

---

## Nächster relevanter Schritt

Der nächste relevante Schritt für das Logistiksystem ist nicht die direkte CTLD-Anbindung.

Zuerst erforderlich:

    Airbase-Scanner klassifizieren und filtern.

Warum:

Logistik braucht saubere World-Daten.

Erst wenn Theater Command unterscheiden kann zwischen:

- strategischen Airfields
- Secondary Airfields
- Heliports
- Helipads
- Medical Pads
- FARPs
- Unknown

kann Logistik sinnvoll entscheiden, welche Orte Hubs, Dropoff-Punkte oder FOB-Kandidaten sind.

---

## Aktueller Status

Das Logistiksystem ist als Grundstruktur vorhanden und lädt erfolgreich in DCS.

Es ist noch nicht funktional mit CTLD verbunden.

Der nächste übergeordnete technische Schritt bleibt die Airbase-Klassifizierung im World-System.
