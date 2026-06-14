# Project Overview

Diese Datei beschreibt die Grundidee von Theater Command DCS.

Theater Command DCS ist ein modulares Kampagnensystem für DCS World. Ziel ist der Aufbau einer persistenten, dynamischen Kampagne, bei der der Spieler Teil eines größeren Kriegsverlaufs ist.

Die erste Kampagne trägt den Arbeitstitel:

Operation Levant Reclamation

---

## Projektziel

Das Projekt soll eine dynamische DCS-Kampagne auf der Syria Map ermöglichen.

Der Spieler soll nicht nur einzelne isolierte Missionen fliegen, sondern in einem fortlaufenden Kriegsszenario agieren.

Aktionen des Spielers, der KI, der Logistik und der gegnerischen Luftverteidigung sollen Auswirkungen auf den weiteren Verlauf der Kampagne haben.

---

## Grundszenario

Blau startet auf Zypern.

Die wichtigste blaue Startbasis ist:

Akrotiri

Das syrische Festland ist zu Beginn der Kampagne vollständig rot kontrolliert.

Die rote Koalition kontrolliert:

- Küstenregion
- Flugplätze
- IADS-Strukturen
- Nachschubrouten
- Radarstellungen
- Depots
- militärische Infrastruktur

Die blaue Koalition muss schrittweise Einfluss aufbauen.

---

## Strategisches Ziel der blauen Koalition

Die blaue Koalition soll:

- Luftüberlegenheit herstellen
- gegnerische CAP und GCI reduzieren
- das IADS schwächen
- Radarstellungen zerstören
- SAM-Stellungen bekämpfen
- Nachschubwege unterbrechen
- einen Brückenkopf an der Küste bilden
- FOBs aufbauen
- CTLD-Logistik etablieren
- Basen erobern
- Ressourcen sichern
- das syrische Festland schrittweise zurückerobern

---

## Rolle des Spielers

Der Spieler ist nicht der einzige Auslöser der Kampagne.

Der Spieler ist Teil eines größeren Systems.

Das bedeutet:

- KI führt eigene Einsätze durch
- rote Kräfte reagieren auf blaue Aktionen
- Logistik beeinflusst Einsatzmöglichkeiten
- zerstörte Infrastruktur bleibt relevant
- eroberte Basen verändern den Kriegsverlauf
- Missionen entstehen aus dem aktuellen Kampagnenzustand

Der Spieler kann den Verlauf beeinflussen, aber nicht allein kontrollieren.

---

## Technischer Grundsatz

Theater Command DCS trennt klar zwischen:

Mission Editor
Lua-System
GitHub-Dokumentation

Der Mission Editor stellt die Bühne bereit.

Lua steuert die dynamische Kampagne.

GitHub dokumentiert und versioniert das Projekt.

---

## Mission Editor

Der Mission Editor enthält nur das, was physisch in der Mission vorhanden sein muss.

Dazu gehören:

- Map
- Koalitionen
- Spieler-Slots
- Startbasen
- Framework-Lade-Trigger
- Template-Gruppen
- einzelne CTLD-Startzonen
- sichtbare statische Ziele
- optionale Carrier-Gruppe

Der Mission Editor enthält nicht die gesamte Kampagnenlogik.

---

## Lua-System

Das Lua-System übernimmt die dynamische Steuerung.

Dazu gehören später:

- Airbase-Erkennung
- BaseNode-Erzeugung
- virtuelle Zonen
- Capture-System
- Ressourcen-System
- CTLD-Auswertung
- FOB-System
- Missionsgenerator
- KI-Reaktionen
- IADS-Verknüpfung
- Persistenz

---

## GitHub

GitHub dient als Projektgedächtnis.

Dort werden dokumentiert:

- Projektidee
- Architektur
- Roadmap
- Aufgaben
- Namenskonventionen
- Lua-Regeln
- Mission-Editor-Aufbau
- spätere Skripte
- Testpläne
- Änderungen

---

## Frameworks

Theater Command DCS nutzt externe Frameworks als Bibliotheken.

Vorgesehen sind:

- MOOSE
- MIST
- CTLD
- Skynet IADS

Diese Frameworks bilden nicht die Projektstruktur.

Die eigene Projektstruktur richtet sich nach Aufgaben.

---

## Modulare Struktur

Die eigenen Lua-Dateien werden nach Aufgaben sortiert.

Beispiele:

tc_airbase_scanner.lua
tc_zone_factory.lua
tc_capture_system.lua
tc_logistics_delivery.lua
tc_fob_system.lua
tc_mission_generator.lua
tc_ai_cap_manager.lua
tc_persistence_system.lua

Nicht gewünscht sind große Sammeldateien wie:

tc_moose.lua
tc_ctld.lua
tc_all_in_one.lua

---

## Erste Entwicklungsphase

Die erste Entwicklungsphase konzentriert sich auf:

- GitHub-Struktur
- Dokumentation
- Mission-Editor-Grundlage
- Lua-Core
- Airbase-Scanner
- virtuelle Zonen
- Debug-Ausgaben

Erst danach folgen:

- Capture
- CTLD-Anbindung
- Missionsgenerator
- KI-System
- IADS-System
- Persistenz

---

## Langfristiges Ziel

Theater Command DCS soll langfristig ein eigenes dynamisches Kampagnensystem werden.

Es soll ermöglichen:

- persistente Kampagnen
- dynamische Einsätze
- spielerabhängige Missionsangebote
- KI-geführte Operationen
- logistische Abhängigkeiten
- FOB-Aufbau
- IADS-Abnutzung
- Ressourcenmanagement
- nachvollziehbare Frontentwicklung

Das Ziel ist eine moderne, modulare und nachvollziehbare dynamische DCS-Kampagne.
