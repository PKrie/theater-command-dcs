# Campaign Design

Diese Datei beschreibt das Kampagnendesign der ersten Theater-Command-DCS-Kampagne.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut.

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## Grundidee der Kampagne

**Operation Levant Reclamation** soll keine lineare Einzelmission werden.

Ziel ist eine dynamische Kampagne, in der der Spieler durch Missionen, Logistik, Luftüberlegenheit, SEAD/DEAD, Capture-Operationen und Unterstützungseinsätze den Kampagnenzustand verändert.

Die Kampagne soll später aus einem zentralen Zustand heraus arbeiten.

Dieser Zustand soll unter anderem enthalten:

- Besitzstatus von Airbases
- Besitzstatus von Zonen
- verfügbare Missionen
- aktive Missionen
- abgeschlossene Missionen
- Logistikstatus
- FOB-Status
- AI-Reaktionen
- IADS-Zustand
- Persistenzdaten

---

## Architekturprinzip

Das zentrale Prinzip lautet:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der DCS Mission Editor stellt die physische Umgebung bereit.

Lua übernimmt die eigentliche Kampagnenlogik.

GitHub dokumentiert Entscheidungen, Versionen, Aufgabenstand und Testergebnisse.

---

## Aktueller Projektstand

Stand: 2026-06-16

Aktuell vorhanden:

- Repository-Grundstruktur
- zentrale Projektdokumentation
- `docs/`-Dokumentation
- `mission_editor/`-Dokumentation
- `vendor/`-Frameworkstruktur
- MIST
- MOOSE
- CTLD
- Skynet IADS
- `src/`-Grundstruktur
- erste eigene Theater-Command-Lua-Module
- Loader
- Main-Initialisierung
- Core-System
- World-System
- Campaign-System
- Logistics-System
- Missions-System
- AI-CAP-System
- IADS-, UI- und Debug-Bereiche dokumentiert
- minimale Syria-DEV-Mission
- erster blauer F/A-18C-Client-Slot auf Akrotiri
- vollständige Triggerkette für Starttest-Variante A
- erster realer DCS-Starttest
- erfolgreiche `dcs.log`-Auswertung

Aktueller Teststatus:

    Starttest-Variante A ist bestanden.

Wichtiges Testergebnis:

    Airbase-Scanner registrierte 225 Airbase-/Helipad-Objekte.
    Zone-Factory registrierte 225 Zonen.

Folgerung für das Kampagnendesign:

    Die Kampagne darf nicht alle von DCS erkannten Airbase-Objekte gleich behandeln.
    Strategische Airfields müssen von Helipads, Medical Pads, FARPs und taktischen Pads getrennt werden.

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

## Strategische Ausgangslage

Zu Kampagnenbeginn kontrolliert Blau nur den Startbereich auf Zypern.

Blauer Startpunkt:

    Akrotiri / Zypern

Roter Ausgangsraum:

    syrisches Festland vollständig rot kontrolliert

Die Kampagne beginnt damit aus einer asymmetrischen Ausgangslage:

- Blau besitzt eine sichere Offshore-Startbasis
- Rot hält das syrische Festland
- Blau muss zunächst Aufklärung, Luftüberlegenheit, SEAD/DEAD und logistische Voraussetzungen schaffen
- Rot besitzt zu Beginn die operative Tiefe auf dem Festland
- Fortschritt entsteht durch dynamische Missionen und spätere Capture-/Logistikmechanik

---

## Politische und militärische Grundannahme

Die genaue Story wird später weiter ausgearbeitet.

Aktuelle Grundannahme:

Eine internationale Koalition startet von Akrotiri aus eine Operation zur Rückgewinnung und Stabilisierung des östlichen Mittelmeerraums und der syrischen Küstenregion.

Das syrische Festland ist zu Kampagnenbeginn unter roter Kontrolle.

Die blaue Koalition muss schrittweise:

- Luftlage aufklären
- feindliche Luftverteidigung schwächen
- Luftüberlegenheit herstellen
- logistische Korridore sichern
- erste Brückenköpfe vorbereiten
- FOBs aufbauen
- strategische Basen angreifen oder erobern
- Missionsdruck auf rote Systeme erhöhen
- den Kampagnenzustand dauerhaft verändern

---

## Geplanter Kampagnenverlauf

Der Kampagnenverlauf soll nicht als feste Missionskette gebaut werden.

Stattdessen soll er durch den Kampagnenzustand entstehen.

Geplante Eskalationslogik:

1. Aufklärungs- und Orientierungsphase
2. Luftüberlegenheitsphase
3. SEAD-/DEAD-Phase
4. Logistik- und FOB-Aufbau
5. Angriffe auf strategische Ziele
6. Capture-Operationen gegen wichtige Basen
7. Ausweitung der blauen Operationszone
8. rote Gegenreaktionen
9. IADS-Neuordnung und Gegenmaßnahmen
10. persistenter Kampagnenfortschritt

---

## Phase 1 — Initiale Lage

Zu Beginn:

    Blau startet auf Akrotiri.
    Rot kontrolliert das syrische Festland.
    Es gibt noch keine blaue Frontlinie auf dem Festland.
    Es gibt noch keine aktiven blauen FOBs.
    Es gibt noch keine produktive Capture-Logik.
    Es gibt noch keine produktive Persistenz.

Ziel dieser Phase:

- technische Startkette stabilisieren
- Airbase- und Zonenlogik sauber aufbauen
- strategische Basen erkennen
- Kampagnenzustand initialisieren
- spätere Missionen aus echten Daten ableiten

Aktueller Stand:

    Technische Startkette bestanden.
    Airbase-Erkennung funktioniert.
    Airbase-Klassifizierung fehlt noch.

---

## Phase 2 — Airbase- und Zonenverständnis

Der erste reale DCS-Test hat gezeigt:

    225 Airbase-/Helipad-Objekte werden erkannt.

Für das Kampagnendesign ist das entscheidend.

Diese Objekte müssen unterschieden werden in:

- strategische Airfields
- Secondary Airfields
- Heliports
- Helipads
- Medical Pads
- FARPs
- Tactical Pads
- Unknown

Nur strategische Airfields und ausgewählte Secondary Airfields sollen später als echte Kampagnenbasen dienen.

Helipads, Medical Pads und taktische Pads können später für Spezialrollen genutzt werden, aber nicht als vollwertige strategische Basen.

---

## Strategische Airfields

Strategische Airfields sind zentrale Kampagnenobjekte.

Sie können später:

- Besitzerstatus haben
- erobert werden
- als Logistikhub dienen
- als Missionsziel dienen
- als Spawn-/Startpunkt dienen
- in Persistenz gespeichert werden
- AI-Reaktionen auslösen
- IADS- und CAP-Logik beeinflussen

Akrotiri ist die erste fest definierte strategische blaue Basis.

Syrische Hauptflugplätze sollen später als rote strategische Basen klassifiziert werden.

---

## Sekundäre Airfields

Sekundäre Airfields können je nach Lage eine reduzierte Kampagnenrolle erhalten.

Mögliche Rollen:

- Zwischenziel
- Forward Operating Location
- logistischer Zwischenpunkt
- Helikopterstützpunkt
- begrenztes Missionsziel

Ob Secondary Airfields capturable werden, wird später entschieden.

---

## Heliports, Helipads und Medical Pads

Diese Objekte sollen nicht ignoriert werden.

Sie sind aber keine vollwertigen strategischen Basen.

Mögliche spätere Rollen:

- CTLD-Zonen
- CSAR-Punkte
- MEDEVAC-Szenarien
- FOB-Unterstützung
- Helikoptermissionen
- taktische Landezonen

Nicht geeignet als Standard:

- strategische Capture-Ziele
- Hauptlogistikhubs
- CAP-Zentren
- zufällige Strike-Ziele des Missionsgenerators

---

## FARPs und FOBs

FARPs und FOBs gehören fachlich eng zusammen.

FARPs können später wichtig werden für:

- AH-64D-Operationen
- Transporthubschrauber
- CTLD
- Forward Refuel/Rearm
- logistische Frontunterstützung
- temporäre Kampagnenpräsenz

FOBs sollen später durch Logistik aufgebaut und verbessert werden können.

Der FOB-Aufbau wird nicht rein im Mission Editor entschieden, sondern durch Theater-Command-Logik gesteuert.

---

## Capture-Design

Das Capture-System soll später den strategischen Besitz von Basen und Zonen verwalten.

Grundregel:

    Capture darf nur auf geeignete strategische Kampagnenobjekte angewendet werden.

Nicht standardmäßig capturable:

- Medical Pads
- einzelne Helipads
- unbekannte Objekte
- rein taktische Pads

Potentiell capturable:

- strategische Airfields
- ausgewählte Secondary Airfields
- ausgewählte militärische Heliports
- definierte FOB-Standorte

Capture soll später abhängig sein von:

- Missionsfortschritt
- Bodennähe oder Triggerlogik
- Logistikstatus
- FOB-Unterstützung
- AI-Widerstand
- IADS-Zustand
- Kampagnenphase

---

## Missionsdesign

Missionen sollen später dynamisch aus dem Kampagnenzustand entstehen.

Mögliche Missionstypen:

- Recon
- CAP
- SEAD
- DEAD
- Strike
- CAS
- Interdiction
- Escort
- Logistics
- FOB Support
- Airbase Attack
- AI Suppression

Missionen sollen nicht zufällig aus allen DCS-Objekten erzeugt werden.

Der Missionsgenerator muss geeignete Ziele wählen.

Beispiele:

- SEAD/DEAD gegen IADS-Ziele
- Strike gegen strategische Infrastruktur
- CAP über Front- oder Bedrohungsräumen
- Logistics zu FOBs oder Basen
- Airbase Attack nur gegen relevante Airfields
- FOB Support für definierte Forward Sites

---

## Logistikdesign

Logistik soll später ein Kernbestandteil der Kampagne werden.

Logistik beeinflusst:

- FOB-Aufbau
- Versorgung von Basen
- Operationsreichweite
- Missionsverfügbarkeit
- Capture-Fähigkeit
- Verteidigungsfähigkeit
- AI-Reaktionen

Aktuelle Logistik-Module:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua

Aktuell ist nur die Grundstruktur vorhanden.

Die CTLD-Anbindung folgt später.

---

## AI-Design

Die AI soll später auf den Kampagnenzustand reagieren.

Aktuelles AI-Modul:

    src/ai/tc_ai_cap_manager.lua

Geplante AI-Rollen:

- CAP-Verwaltung
- GCI-Reaktionen
- Verstärkungen
- Gegenangriffe
- Luftlageanpassung
- Reaktion auf Capture
- Reaktion auf IADS-Schäden
- Reaktion auf Logistikfortschritt

Die AI soll nicht isoliert arbeiten.

Sie soll Daten aus Campaign, World, Missions, Logistics und IADS nutzen.

---

## IADS-Design

Skynet IADS wird als externes Framework genutzt.

Theater Command soll später eine eigene Kampagnenschicht darüber legen.

Geplante IADS-Funktionen:

- IADS-Sektoren
- SAM-Site-Status
- Radarstatus
- beschädigte oder zerstörte Systeme
- SEAD-/DEAD-Missionsziele
- IADS-Wiederaufbau oder Reaktion
- Persistenz des IADS-Zustands

Aktueller Stand:

    Skynet IADS wird geladen.
    Theater-Command-IADS-Modul ist noch nicht implementiert.

---

## Spielerinteraktion

Spielerinteraktion soll später über F10-Menüs erfolgen.

Geplante Inhalte:

- Kampagnenstatus anzeigen
- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Mission annehmen
- Logistikstatus anzeigen
- FOB-Status anzeigen
- AI-/CAP-Status anzeigen
- IADS-Status anzeigen
- Debug-Menüs optional aktivieren

Aktueller Stand:

    UI-Bereich ist dokumentiert.
    F10-Menüs sind noch nicht implementiert.

---

## Persistenzdesign

Die Kampagne soll später persistent werden.

Persistenz soll speichern:

- Besitzstatus von Basen
- Besitzstatus von Zonen
- Airbase-Klassifizierung
- aktive Missionen
- abgeschlossene Missionen
- Logistikstatus
- FOB-Status
- AI-Zustand
- IADS-Zustand
- wichtige Kampagnenereignisse

Aktueller Stand:

    In-Memory-Persistenz ist vorbereitet.
    Datei-Persistenz ist noch nicht getestet.

Wichtig:

    DCS-Sandbox-Verhalten muss vor echter Dateipersistenz geprüft werden.

---

## Kampagnenstart auf Akrotiri

Akrotiri ist der zentrale blaue Startpunkt.

Fachliche Rolle:

- Blue Main Operating Base
- sicherer Startpunkt
- erster Logistikhub
- Ausgangspunkt für Luftoperationen
- Ausgangspunkt für spätere See-/Luftbrücke
- nicht initial capturable
- nicht erstes feindliches Missionsziel

Aktuell im Mission Editor vorhanden:

    erster F/A-18C Lot 20 Client-Slot auf Akrotiri

---

## Roter Ausgangsraum

Der rote Ausgangsraum umfasst zu Beginn das syrische Festland.

Fachliche Rolle:

- rote strategische Tiefe
- rote Airbases
- rote IADS
- rote Logistik
- rote AI-Reaktionen
- rote Missionsziele
- spätere Capture-Ziele

Aktuell noch nicht gebaut:

- keine rote Frontlinie
- keine rote IADS-Struktur
- keine roten Template-Gruppen
- keine roten Logistikobjekte
- keine roten Mission Targets

Diese Elemente werden erst ergänzt, wenn die Airbase- und State-Grundlage stabil ist.

---

## Kampagnenfortschritt

Kampagnenfortschritt soll später nicht nur über zerstörte Einheiten entstehen.

Mögliche Fortschrittsfaktoren:

- Airbase-Zustand
- Zone-Zustand
- Missionserfolg
- Logistiklieferungen
- FOB-Aufbau
- IADS-Schäden
- AI-Verluste
- Capture-Ereignisse
- persistente Zustandsänderungen

---

## Nicht-Ziele im aktuellen Stand

Aktuell wird bewusst nicht gebaut:

- keine vollständige Kampagnenstory
- keine komplette rote Frontlinie
- keine komplette Syria-Befüllung
- keine komplette IADS-Struktur
- keine vollständige CTLD-Logistik
- keine F10-Menüs
- keine produktive Persistenz
- keine automatische `.miz`-Generierung
- keine Multiplayer-Synchronisation
- keine kommerzielle Release-Struktur

Grund:

    Zuerst muss die technische Grundlage stabil bleiben.
    Danach muss die Airbase-Klassifizierung gelöst werden.

---

## Nächster Kampagnendesign-Schritt

Der nächste fachliche und technische Schritt ist:

    Airbase-Klassifizierung

Warum:

Der Kampagnenzustand hängt davon ab, welche DCS-Airbase-Objekte echte strategische Kampagnenbasen sind.

Ohne diese Klassifizierung wären Capture, Missionen, Logistik und AI fehleranfällig.

Ziel:

- strategische Airfields identifizieren
- Secondary Airfields erkennen
- Heliports erkennen
- Helipads erkennen
- Medical Pads erkennen
- FARPs erkennen
- Unknown-Objekte zurückstellen
- Akrotiri korrekt als Blue Start Base markieren
- rote strategische Basen für spätere Kampagnenlogik vorbereiten

---

## Aktueller Status

Das Kampagnendesign ist als dynamisches System angelegt.

Die erste technische DCS-Prüfung ist bestanden.

Die Kampagne ist noch nicht spielbar.

Der nächste notwendige Schritt ist die Airbase-Klassifizierung im World-System.
