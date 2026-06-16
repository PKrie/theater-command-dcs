# Airbase System

Diese Datei beschreibt das Airbase-System von **Theater Command DCS**.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut.

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## Zweck des Airbase-Systems

Das Airbase-System ist einer der zentralen Bausteine von Theater Command DCS.

Es verbindet die DCS-Welt mit dem Kampagnenzustand.

Ziel ist nicht nur, Airbases aus DCS auszulesen, sondern sie für die Kampagne sinnvoll nutzbar zu machen.

Das Airbase-System soll später unter anderem beantworten:

- Welche Basen existieren auf der Karte?
- Welche Basen sind strategisch relevant?
- Welche Basen gehören Blau?
- Welche Basen gehören Rot?
- Welche Basen sind neutral?
- Welche Basen sind umkämpft?
- Welche Basen können erobert werden?
- Welche Basen können als Logistikhubs dienen?
- Welche Basen können als Missionsziele dienen?
- Welche Basen sind nur Helipads, Medical Pads oder taktische Sonderpunkte?

---

## Aktueller technischer Stand

Stand: 2026-06-16

Aktuell vorhanden:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua

Der erste reale DCS-Starttest wurde durchgeführt.

Test:

    Starttest-Variante A — sichere Einzeldatei-Ladung

Ergebnis:

    Bestanden

Bestätigt wurde:

- Airbase-Scanner wird geladen
- Airbase-Scanner wird durch Main gestartet
- Airbase-Scanner läuft im DCS Mission Scripting Environment
- DCS-Airbase-Objekte werden erkannt
- Zone-Factory wird geladen
- Zone-Factory wird durch Main gestartet
- Zone-Factory erzeugt Zonen aus den erkannten Airbase-Daten

Wichtiges Testergebnis:

    Airbase scan completed: 225 airbases registered
    Zone factory completed: 225 zones registered

Bewertung:

    Die technische Airbase-Erfassung funktioniert.
    Die aktuelle Zahl von 225 Objekten ist kein Fehler.
    Die fachliche Klassifizierung fehlt noch.

---

## Wichtiger Befund nach Syria-Update

Das aktuelle DCS-/Syria-Update liefert auf der Syria Map sehr viele Airbase-ähnliche Objekte zurück.

Dazu gehören nicht nur große Flugplätze.

DCS meldet offenbar auch viele kleinere Objekte als Airbase-Objekte.

Mögliche Objektarten:

- große Airfields
- kleinere Airfields
- Heliports
- Helipads
- Medical Pads
- FARPs
- taktische Pads
- sonstige Airbase-ähnliche DCS-Objekte

Problem:

    Nicht jedes von DCS gemeldete Airbase-Objekt darf als strategische Kampagnenbasis behandelt werden.

Wenn Theater Command alle 225 Objekte ungefiltert als strategische Basen nutzt, entstehen falsche Kampagnenentscheidungen.

Beispiele:

- Capture-System würde Helipads wie vollwertige Basen behandeln
- Missionsgenerator würde medizinische Pads als Angriffsziel wählen
- Zone-Factory würde zu viele strategische Zonen erzeugen
- Persistenz würde unnötige oder falsche Objekte speichern
- AI könnte CAP-/GCI-Logik auf irrelevante Pads beziehen
- Logistik könnte falsche Hubs erzeugen

Daher ist die nächste technische Aufgabe:

    Airbase-Scanner fachlich klassifizieren und filtern.

---

## Architekturregel

Das Airbase-System gehört zum World-Bereich.

Pfad:

    src/world/

Der World-Bereich liefert DCS-Weltdaten an andere Systeme.

Er entscheidet aber nicht allein über Kampagnenfortschritt.

Architekturprinzip:

    World erkennt und klassifiziert.
    Campaign entscheidet über Besitz und Capture.
    Logistics entscheidet über Versorgung.
    Missions erzeugt Aufträge.
    AI reagiert auf Lage.
    UI zeigt Daten.
    Debug macht Daten sichtbar.

---

## Aktuelle Dateien

### `src/world/tc_airbase_scanner.lua`

Aufgabe:

- DCS-Airbases erfassen
- Airbase-Datensätze erzeugen
- Namen, Koalition und Position vorbereiten
- Airbase-Daten in Theater Command verfügbar machen
- Airbase-Liste für andere Systeme bereitstellen

Aktueller Stand:

    Technisch lauffähig.
    In DCS getestet.
    225 Airbase-/Helipad-Objekte erkannt.
    Klassifizierung noch offen.

---

### `src/world/tc_zone_factory.lua`

Aufgabe:

- aus Airbase-Daten virtuelle Zonen erzeugen
- Zonen für spätere Capture-, Logistics-, Missions- und AI-Systeme vorbereiten
- Airbases und Zonen verbinden

Aktueller Stand:

    Technisch lauffähig.
    In DCS getestet.
    225 Zonen erzeugt.
    Filterung nach strategischer Relevanz noch offen.

---

## Geplante Airbase-Klassifizierung

Das Airbase-System soll künftig jedes erkannte DCS-Airbase-Objekt klassifizieren.

Geplante Klassen:

    STRATEGIC_AIRFIELD
    SECONDARY_AIRFIELD
    HELIPORT
    HELIPAD
    MEDICAL_PAD
    FARP
    TACTICAL_PAD
    UNKNOWN

---

## Strategische Airfields

Strategische Airfields sind vollwertige Kampagnenbasen.

Sie können später:

- Besitzer haben
- erobert werden
- als Logistikhub dienen
- als Missionsziel dienen
- als Spawn-/Startpunkt dienen
- in Persistenz gespeichert werden
- für AI-Planung relevant sein
- für Frontlogik relevant sein

Beispiele für strategische Relevanz:

- große Flugplätze
- militärische Airbases
- Flugplätze mit Startbahn
- Flugplätze mit operativer Bedeutung
- Akrotiri als Blue-Startbasis
- syrische Hauptflugplätze als Red-Basen

---

## Secondary Airfields

Secondary Airfields sind kleinere Flugplätze mit möglicher Kampagnenrelevanz.

Sie können später optional:

- als Nebenbasis dienen
- Logistikfunktion erhalten
- als Zwischenziel dienen
- begrenzt für Missionen verwendet werden

Ob sie wie strategische Basen behandelt werden, wird später entschieden.

---

## Heliports

Heliports sind Hubschrauberstützpunkte oder größere Hubschrauberlandeplätze.

Sie können später relevant sein für:

- Helikoptermissionen
- Logistik
- CSAR
- FOB-Unterstützung
- AH-64D- oder Transportoperationen

Sie sollen aber nicht automatisch wie große Airfields behandelt werden.

---

## Helipads

Helipads sind einzelne Landeplätze.

Sie können später relevant sein für:

- Helikopterlandungen
- CTLD
- CSAR
- Logistikpunkte
- medizinische Evakuierung
- taktische Einsätze

Sie sollen nicht automatisch:

- als strategische Kampagnenbasis zählen
- Capture-Ziel werden
- vollwertiger Logistikhub werden
- CAP-Zentrum werden

---

## Medical Pads

Medical Pads sind medizinische oder hospitalnahe Landeplätze.

Sie können später relevant sein für:

- MEDEVAC
- CSAR
- Szenarioelemente
- zivile Infrastruktur

Sie sollen nicht als strategische Kampagnenbasen gelten.

---

## FARPs

FARPs sind Forward Arming and Refueling Points.

Sie können später sehr wichtig werden für:

- Helikopterlogistik
- FOB-System
- mobile Frontunterstützung
- Nachschub
- CTLD
- AH-64D-Operationen

Aber:

    FARPs sind nicht automatisch Airfields.
    FARPs gehören eher zum Logistics-/FOB-System als zur strategischen Airfield-Liste.

---

## Tactical Pads

Tactical Pads sind sonstige taktische Landeplätze.

Sie können später genutzt werden für:

- Spezialmissionen
- Logistik
- Hubschraubereinsätze
- temporäre Missionsziele

Sie sollen nicht ungeprüft in die strategische Basisliste.

---

## Unknown

Unknown ist eine Sicherheitsklasse.

Objekte mit unbekannter Klassifizierung werden zunächst gespeichert, aber nicht als strategische Basis verwendet.

Ziel:

    Lieber ein Objekt konservativ zurückstellen als es falsch als Kampagnenbasis behandeln.

---

## Geplante Datenstruktur

Jeder Airbase-Datensatz soll perspektivisch mindestens enthalten:

    id
    name
    coalition
    position
    category
    isStrategic
    isCapturable
    isLogisticsHub
    isMissionTarget
    isSpawnBase
    isHelicopterRelevant
    isMedical
    isFarp
    zoneName
    notes

Beispiel:

    {
        id = 1,
        name = "Akrotiri",
        coalition = "blue",
        category = "STRATEGIC_AIRFIELD",
        isStrategic = true,
        isCapturable = false,
        isLogisticsHub = true,
        isMissionTarget = false,
        isSpawnBase = true,
        isHelicopterRelevant = true,
        isMedical = false,
        isFarp = false,
        zoneName = "TC_ZONE_AIRBASE_AKROTIRI",
        notes = "Blue start base"
    }

---

## Strategische Mindestregeln

Für die erste Kampagne gelten zunächst folgende Regeln:

### Akrotiri

Akrotiri ist:

    Blue Start Base
    strategische Airbase
    Logistik-Startpunkt
    nicht zu Beginn eroberbar
    nicht feindliches Missionsziel in der Frühphase

---

### Syrisches Festland

Das syrische Festland ist zu Kampagnenbeginn:

    rot kontrolliert

Syrische strategische Airfields sollen später:

- als Red-Basen gelten
- als potenzielle Missionsziele dienen
- als Capture-Ziele möglich sein
- IADS-, Logistics- und AI-Logik beeinflussen

---

### Helipads und Medical Pads

Helipads und Medical Pads sollen:

- erkannt werden
- separat gespeichert werden
- nicht als strategische Basen zählen
- nicht automatisch Capture-Ziele werden
- nicht automatisch Missionsziele werden

---

## Verbindung zum Capture-System

Das Capture-System darf später nur mit geeigneten strategischen Basen arbeiten.

Nicht geeignet als Standard-Capture-Ziel:

- einzelne Helipads
- Medical Pads
- reine taktische Pads
- unbekannte Objekte

Geeignet als Capture-Ziel:

- strategische Airfields
- ausgewählte Secondary Airfields
- ausgewählte militärische Heliports, falls kampagnenlogisch gewünscht

---

## Verbindung zur Zone-Factory

Die Zone-Factory darf künftig nicht mehr ungefiltert für jedes erkannte Objekt eine strategische Kampagnenzone erzeugen.

Geplantes Verhalten:

- strategische Airfields erhalten strategische Airbase-Zonen
- Secondary Airfields erhalten optionale Airbase-Zonen
- Heliports erhalten Helicopter-Zonen
- Helipads erhalten optionale Hilfszonen
- Medical Pads erhalten keine Capture-Zonen
- Unknown-Objekte erhalten höchstens Debug-Einträge

Ziel:

    Die Zone-Factory erzeugt fachlich sinnvolle Zonen statt 225 ungefilterte strategische Zonen.

---

## Verbindung zum Missionsgenerator

Der Missionsgenerator darf später nur geeignete Ziele verwenden.

Geeignet für strategische Missionen:

- strategische Airfields
- militärische Secondary Airfields
- IADS-relevante Standorte
- Logistikhubs
- definierte Missionsziele

Nicht automatisch geeignet:

- Medical Pads
- einzelne Helipads
- unbekannte Airbase-Objekte

Beispiel:

    Eine Strike-Mission soll nicht zufällig ein Medical Pad als Airbase-Ziel wählen.

---

## Verbindung zur Logistik

Logistik kann verschiedene Airbase-Klassen unterschiedlich nutzen.

Strategische Airfields:

- große Logistikhubs
- Supply-Aufbau
- Fuel
- Ammunition
- Engineering
- FOB-Unterstützung

Heliports:

- Hubschrauberlogistik
- CTLD-Pickup oder Dropoff
- CSAR-Unterstützung

Helipads:

- lokale Dropoff-Punkte
- taktische Landezonen
- MEDEVAC-/CSAR-Punkte

FARPs:

- FOB-System
- Forward Logistics
- Helikopterversorgung

---

## Verbindung zur AI

Die AI darf später nicht jedes Airbase-Objekt gleich behandeln.

Strategische Airfields können relevant sein für:

- CAP-Zonen
- GCI-Verhalten
- Luftverteidigung
- Verstärkungen
- Gegenangriffe

Helipads können relevant sein für:

- Helikopteroperationen
- lokale Reaktionen
- taktische Einsätze

Medical Pads sollen normalerweise keine AI-Kampagnenpriorität erzeugen.

---

## Verbindung zur Persistenz

Persistenz soll später getrennt speichern:

- strategische Basen
- sekundäre Basen
- Heliports
- Helipads
- FARPs
- Medical Pads
- unbekannte Objekte

Wichtig:

    Nicht alle erkannten Objekte müssen gleichwertig persistent behandelt werden.

Strategische Kampagnenbasen haben höchste Priorität.

---

## Debug-Anforderungen

Der nächste sinnvolle Debug-Schritt ist ein Airbase-Debugreport.

Geplante Datei:

    src/debug/tc_debug_airbase_report.lua

Ziel:

- alle erkannten Airbase-Objekte ausgeben
- Klassifizierung anzeigen
- Koalition anzeigen
- Position anzeigen
- strategische Relevanz anzeigen
- Capture-Relevanz anzeigen
- Logistik-Relevanz anzeigen
- Missionsziel-Relevanz anzeigen
- getrennte Zählung nach Klassen ausgeben

Beispielhafte spätere Logausgabe:

    [TC] Airbase classification completed
    [TC] Strategic airfields: 12
    [TC] Secondary airfields: 8
    [TC] Heliports: 15
    [TC] Helipads: 140
    [TC] Medical pads: 35
    [TC] FARPs: 5
    [TC] Unknown: 10

Die Zahlen sind nur Beispielwerte.

---

## Nächster technischer Schritt

Der nächste technische Schritt ist:

    src/world/tc_airbase_scanner.lua erweitern

Ziel:

- Airbase-Kategorien einführen
- Klassifizierungsfunktion ergänzen
- strategische Relevanz berechnen
- getrennte Listen speichern
- Summary-Logausgabe erzeugen
- ZoneFactory später darauf vorbereiten

Der nächste Schritt soll noch keine komplette neue Kampagnenlogik bauen.

---

## Danach geplanter Schritt

Nach der Airbase-Klassifizierung:

    src/world/tc_zone_factory.lua anpassen

Ziel:

- strategische Zonen nur für strategische Airfields erzeugen
- Helipad-/Medical-/FARP-Objekte nicht ungefiltert als Capture-Zonen behandeln
- Debug-Ausgabe vorbereiten

---

## Nicht-Ziele dieses Systems im aktuellen Stand

Aktuell wird bewusst nicht gemacht:

- keine manuelle komplette Airbase-Liste für die gesamte Syria Map
- keine vollständige Frontlinie
- keine automatische Capture-Logik
- keine vollständige Missionslogik
- keine IADS-Verknüpfung
- keine CTLD-Verknüpfung
- keine Persistenz in Datei
- keine finale Airbase-Balance

Zuerst wird die technische Klassifizierung stabil gemacht.

---

## Aktueller Status

Das Airbase-System ist technisch lauffähig und wurde in DCS getestet.

Der erste Test hat 225 Airbase-/Helipad-Objekte erkannt.

Der nächste Schritt ist die fachliche Klassifizierung dieser Objekte, bevor Capture-, Missions-, Logistics- oder AI-Systeme diese Daten produktiv verwenden.
