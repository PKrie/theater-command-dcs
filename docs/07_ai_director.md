# AI Director

Diese Datei beschreibt den geplanten AI Director von **Theater Command DCS**.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut.

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## Zweck des AI Directors

Der AI Director soll später dynamische KI-Reaktionen auf den aktuellen Kampagnenzustand steuern.

Er soll nicht einfach zufällig Einheiten spawnen.

Stattdessen soll er aus dem Zustand der Kampagne ableiten, welche KI-Reaktionen sinnvoll sind.

Mögliche Reaktionen:

- CAP starten
- GCI starten
- Verstärkungen schicken
- Gegenangriffe vorbereiten
- bedrohte Basen verteidigen
- Logistikziele angreifen
- IADS-Sektoren schützen
- rote Luftaktivität anpassen
- Missionsdruck auf Blau erhöhen
- Eskalationslogik auslösen

---

## Grundprinzip

Das zentrale Projektprinzip lautet:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Mission Editor stellt nur die Bühne bereit.

Die eigentliche KI-Logik liegt in Lua.

GitHub dokumentiert Struktur, Entscheidungen, Versionen, Aufgabenstand und Testergebnisse.

---

## Aktueller technischer Stand

Stand: 2026-06-16

Aktuelle AI-Datei:

    src/ai/tc_ai_cap_manager.lua

Der erste reale DCS-Starttest wurde durchgeführt.

Test:

    Starttest-Variante A — sichere Einzeldatei-Ladung

Ergebnis:

    Bestanden

Bestätigt wurde:

- AI-Bereich wird geladen
- `tc_ai_cap_manager.lua` wird geladen
- keine schweren Lua-Fehler beim Laden
- AI wird durch Main als Runtime-System berücksichtigt
- Theater-Command-Startkette läuft sauber weiter

Aktueller Stand:

    AI-CAP-Manager ist technisch ladbar.
    Funktionale AI-Tests wurden noch nicht durchgeführt.
    Es werden noch keine realen MOOSE-CAPs gespawnt.
    Es gibt noch keinen vollständigen AI Director.

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

Dieser Befund ist für den AI Director wichtig.

Problem:

    Die AI darf nicht jedes von DCS erkannte Airbase-/Helipad-Objekt als strategisch relevante Basis behandeln.

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

    AI-Reaktionen dürfen erst produktiv auf Airbase-Daten zugreifen, wenn der Airbase-Scanner diese Objekte klassifiziert.

---

## Geplante Airbase-Relevanz für AI

### Strategische Airfields

Strategische Airfields können später AI-Reaktionen auslösen.

Beispiele:

- CAP zum Schutz wichtiger Basen
- GCI von roten Flugplätzen
- Verstärkung bei Bedrohung
- Gegenangriff bei Capture-Fortschritt
- Verteidigung nach SEAD-/Strike-Erfolg
- Priorisierung wichtiger Sektoren

---

### Secondary Airfields

Secondary Airfields können später begrenzte AI-Reaktionen auslösen.

Beispiele:

- lokale CAP
- Hubschrauberreaktion
- leichte Verstärkung
- begrenzte Verteidigung
- temporäre Nutzung als Forward Base

---

### Heliports und Helipads

Heliports und Helipads können für spezielle KI-Reaktionen relevant sein.

Beispiele:

- Hubschrauberoperationen
- CSAR-Reaktion
- taktische Verstärkung
- lokale Reaktion
- Transporthubschrauber

Sie sollen aber nicht automatisch wie strategische Airfields behandelt werden.

---

### Medical Pads

Medical Pads sollen normalerweise keine militärische AI-Priorität erzeugen.

Mögliche spätere Sonderrollen:

- MEDEVAC-Szenario
- humanitäre Lage
- CSAR-Bezug

Nicht vorgesehen als Standard:

- CAP-Zentrum
- GCI-Basis
- strategischer Gegenangriffspunkt
- Strike-Ziel

---

### FARPs

FARPs können für AI wichtig werden, besonders bei Hubschrauber- und Frontlogik.

Mögliche Rollen:

- rote Forward Helicopter Base
- blaue Forward Base
- AI-Angriffsziel
- logistischer Knoten
- FOB-Verteidigung
- Hubschrauber-CAP oder Escort

FARPs gehören fachlich eng zum Logistics- und FOB-System.

---

## Aktuelles AI-Modul

### `src/ai/tc_ai_cap_manager.lua`

Aufgabe:

- CAP-Anforderungen vorbereiten
- CAP-Zonen verwalten
- aktive CAPs verwalten
- CAP-Status speichern
- spätere MOOSE-Anbindung vorbereiten
- AI-Luftreaktionen vorbereiten

Aktueller Stand:

    Datei vorhanden.
    Datei wird geladen.
    Keine schweren Lua-Fehler beim Starttest.
    Noch keine realen CAP-Spawns.

---

## Geplante spätere AI-Module

Mögliche spätere Dateien:

    src/ai/tc_ai_director.lua
    src/ai/tc_ai_gci_manager.lua
    src/ai/tc_ai_counterattack.lua
    src/ai/tc_ai_reinforcement_manager.lua
    src/ai/tc_ai_threat_evaluator.lua

Diese Dateien werden aktuell noch nicht erstellt.

Grund:

    Zuerst müssen Airbase-Klassifizierung, World-Daten und grundlegender Campaign-State stabil sein.

---

## AI Director

Der AI Director soll später die zentrale Entscheidungslogik für KI-Reaktionen werden.

Aufgaben:

- Kampagnenzustand auswerten
- Bedrohungen bewerten
- rote Reaktionen planen
- blaue Fortschritte berücksichtigen
- Missionsergebnisse auswerten
- Luftlage beeinflussen
- Logistiklage berücksichtigen
- IADS-Zustand berücksichtigen
- Prioritäten setzen
- andere AI-Subsysteme anstoßen

Der AI Director soll nicht jedes Detail selbst ausführen.

Er soll andere Manager ansteuern.

Beispiele:

    AI Director entscheidet: rote CAP erforderlich.
    CAP Manager verwaltet die konkrete CAP-Anforderung.

    AI Director entscheidet: Gegenangriff sinnvoll.
    Counterattack Manager bereitet Gegenangriff vor.

    AI Director entscheidet: IADS-Sektor bedroht.
    IADS Bridge oder Mission Generator erzeugt passende Reaktion.

---

## CAP-Management

CAP steht für Combat Air Patrol.

CAP soll später genutzt werden für:

- Schutz roter Basen
- Schutz blauer Basen
- Schutz von IADS-Sektoren
- Schutz von Logistikkorridoren
- Luftüberlegenheit über Frontbereichen
- Reaktion auf Spieleraktivität

Geplante CAP-Daten:

    id
    coalition
    originBase
    patrolZone
    status
    priority
    requestedBy
    createdAt
    expiresAt

Mögliche Statuswerte:

    REQUESTED
    ACTIVE
    COMPLETED
    FAILED
    CANCELLED

---

## GCI-Management

GCI steht für Ground Controlled Intercept.

GCI soll später genutzt werden für:

- gezielte Abfangreaktionen
- Reaktion auf blaue Eindringlinge
- Schutz strategischer Basen
- Schutz von IADS-Sektoren
- Eskalation bei hoher Bedrohung

GCI benötigt später:

- aktive Radar-/IADS-Daten
- verfügbare rote Flugplätze
- verfügbare rote Flugzeuge
- Bedrohungsbewertung
- MOOSE-Anbindung

Aktueller Stand:

    GCI-Manager ist noch nicht implementiert.

---

## Gegenangriffe

Gegenangriffe sollen später rote Reaktionen auf blauen Fortschritt darstellen.

Mögliche Auslöser:

- Blau erobert strategische Basis
- Blau baut FOB auf
- IADS-Sektor wird zerstört
- rote Logistik wird geschwächt
- wichtige Mission scheitert oder gelingt
- Blau überschreitet Operationsgrenze
- Campaign-State erreicht Eskalationsschwelle

Mögliche Gegenangriffe:

- Luftangriff
- Bodenangriff
- Artillerieangriff
- Angriff auf FOB
- Angriff auf Logistikkorridor
- erhöhte CAP-Aktivität
- IADS-Verstärkung

Aktueller Stand:

    Gegenangriffssystem ist noch nicht implementiert.

---

## Verstärkungen

Verstärkungen sollen später dynamisch auf Lageänderungen reagieren.

Mögliche Verstärkungen:

- zusätzliche CAP-Flüge
- zusätzliche SAM-Systeme
- mobile Luftverteidigung
- Bodeneinheiten
- Logistikfahrzeuge
- Hubschrauber
- Reserveeinheiten

Verstärkungen dürfen nicht zufällig oder beliebig erscheinen.

Sie sollen abhängig sein von:

- Kampagnenphase
- Besitzstatus
- Airbase-Klassifizierung
- Logistiklage
- IADS-Zustand
- Missionsverlauf
- Bedrohungsbewertung

---

## Bedrohungsbewertung

Der AI Director soll später Bedrohungen bewerten.

Mögliche Faktoren:

- Nähe blauer Kräfte zu roter Basis
- aktive blaue Missionen
- IADS-Schäden
- verlorene rote Basen
- aktiver FOB-Aufbau
- zerstörte Logistikhubs
- Luftüberlegenheitslage
- verfügbare rote Flugplätze
- verfügbare rote CAPs
- offene Kampagnenziele

Mögliche Bedrohungsstufen:

    LOW
    MEDIUM
    HIGH
    CRITICAL

Diese Stufen können später Missionen, CAPs, GCI oder Gegenangriffe beeinflussen.

---

## Verbindung zum Campaign-System

Der AI Director soll stark vom Campaign-System abhängen.

Campaign liefert:

- Besitzstatus
- Capture-Zustände
- strategische Basen
- umkämpfte Zonen
- Kampagnenphase
- bisherige Fortschritte
- wichtige Ereignisse

AI liefert zurück:

- Reaktionsereignisse
- aktive CAPs
- aktive Gegenangriffe
- Bedrohungsstatus
- Eskalationsstatus
- mögliche Missionsvorschläge

Wichtig:

    AI entscheidet nicht allein über strategischen Besitz.
    Campaign bleibt führend für Besitz- und Capture-Zustände.

---

## Verbindung zum Mission Generator

AI und Missionsgenerator sollen später zusammenarbeiten.

Beispiele:

- starke rote CAP erzeugt blaue CAP- oder Escort-Mission
- rote Verstärkungen erzeugen Interdiction-Mission
- IADS-Schutz erzeugt SEAD-Mission
- Gegenangriff erzeugt CAS-Mission
- Bedrohter FOB erzeugt FOB-Defense-Mission
- rote Logistikbewegung erzeugt Strike- oder Interdiction-Mission

Der Missionsgenerator erzeugt daraus spielbare Aufträge.

Der AI Director liefert Lageimpulse.

---

## Verbindung zum Logistics-System

Logistik beeinflusst AI-Reaktionen.

Beispiele:

- Blau baut FOB auf → Rot reagiert
- blauer Nachschub läuft → Rot versucht Interdiction
- roter Hub wird zerstört → rote AI-Reaktion sinkt oder verschiebt sich
- Versorgung einer Basis sinkt → Verteidigung wird schwächer
- Logistikkorridor wird wichtig → CAP- oder GCI-Reaktion möglich

Aktueller Stand:

    Logistics-Module laden.
    Keine reale AI-Logistics-Verbindung implementiert.

---

## Verbindung zum IADS-System

IADS beeinflusst AI stark.

Beispiele:

- aktive Radarstellungen ermöglichen GCI
- zerstörte SAM-Sektoren schwächen rote Verteidigung
- SEAD-Erfolge erzwingen AI-Reaktion
- intakte IADS-Sektoren erhöhen Risiko für blaue Missionen
- wichtige SAM-Verluste können Gegenangriffe auslösen

Aktueller Stand:

    Skynet IADS wird geladen.
    Theater-Command-IADS-Schicht ist noch nicht implementiert.

---

## Verbindung zum UI-System

Später sollen AI-Daten über F10- oder Debug-Menüs sichtbar werden.

Mögliche Anzeigen:

- aktuelle Bedrohungsstufe
- aktive rote CAPs
- aktive GCI-Reaktionen
- bekannte Gegenangriffe
- AI-Prioritäten
- bedrohte Zonen
- gefährdete FOBs
- Debug-Ausgaben

Aktueller Stand:

    UI-Bereich ist dokumentiert.
    F10-Menüs sind noch nicht implementiert.

---

## Verbindung zur Persistenz

AI-Zustände müssen später persistent gespeichert werden.

Mögliche Daten:

- aktive CAP-Anforderungen
- aktive CAPs
- aktive Gegenangriffe
- AI-Bedrohungsstufen
- Eskalationsstatus
- Reaktionscooldowns
- bisherige AI-Aktionen
- gesperrte oder erschöpfte Ressourcen

Aktueller Stand:

    In-Memory-Persistenz ist vorbereitet.
    Datei-Persistenz ist noch nicht getestet.

---

## Verbindung zum Debug-System

Später soll ein AI-Debugreport möglich sein.

Geplante Datei:

    src/debug/tc_debug_ai_report.lua

Mögliche Ausgabe:

- aktive AI-Reaktionen
- CAP-Anforderungen
- CAP-Zonen
- GCI-Status
- Bedrohungsstufe
- AI-Prioritäten
- Gegenangriffsstatus
- Verstärkungsstatus
- Gründe für AI-Entscheidungen

Aktuell wird dieser Debugreport noch nicht erstellt.

---

## MOOSE-Anbindung

MOOSE wird bereits als externes Framework geladen.

Aktueller Framework-Pfad:

    vendor/moose/Moose.lua

MOOSE kann später genutzt werden für:

- CAP-Spawns
- GCI-Spawns
- Dispatcher-Systeme
- Detection
- Spawn-Templates
- AI-Management
- Patrol-Zonen

Aktueller Stand:

    MOOSE wird geladen.
    Theater Command erkennt MOOSE.
    AI-CAP-Manager nutzt MOOSE noch nicht produktiv.

---

## Mission-Editor-Anforderungen für AI

Später werden im Mission Editor wahrscheinlich benötigt:

- Late-Activation-Template-Gruppen
- rote CAP-Templates
- rote GCI-Templates
- blaue AI-Support-Templates
- Patrol-Zonen
- Spawn-Basen
- Triggerzonen für Testzwecke
- statische Ziele
- Debug-Testobjekte

Aktuell noch nicht angelegt:

    keine AI-Templates
    keine CAP-Zonen
    keine GCI-Zonen
    keine Dispatcher-Struktur

Grund:

    Zuerst müssen Airbase-Klassifizierung und World-Daten stabil sein.

---

## Nicht-Ziele im aktuellen Stand

Aktuell wird bewusst nicht umgesetzt:

- kein vollständiger AI Director
- keine realen MOOSE-CAP-Spawns
- keine GCI-Logik
- keine Gegenangriffe
- keine Verstärkungslogik
- keine AI-Persistenz
- keine AI-F10-Menüs
- keine komplexe Bedrohungsberechnung
- keine roten Template-Gruppen

---

## Nächster relevanter Schritt

Der nächste relevante Schritt für den AI Director ist nicht sofort die MOOSE-CAP-Implementierung.

Zuerst erforderlich:

    Airbase-Scanner klassifizieren und filtern.

Warum:

AI braucht saubere World-Daten.

Erst wenn Theater Command unterscheiden kann zwischen:

- strategischen Airfields
- Secondary Airfields
- Heliports
- Helipads
- Medical Pads
- FARPs
- Tactical Pads
- Unknown

kann AI sinnvoll entscheiden, wo CAP, GCI, Verteidigung oder Gegenangriffe entstehen sollen.

---

## Aktueller Status

Der AI-Bereich ist als Grundstruktur vorhanden.

Der AI-CAP-Manager lädt erfolgreich in DCS.

Ein vollständiger AI Director ist noch nicht implementiert.

Der nächste übergeordnete technische Schritt bleibt die Airbase-Klassifizierung im World-System.
