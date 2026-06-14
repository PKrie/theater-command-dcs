# Theater Command DCS

**Theater Command DCS** ist ein modulares Projekt für eine persistente, dynamische DCS-Kampagne auf der Syria Map.

Der erste Kampagnenentwurf trägt den Arbeitstitel:

**Operation Levant Reclamation**

## Grundidee

Blau startet auf Zypern, primär von **Akrotiri** aus. Das syrische Festland ist zu Kampagnenbeginn vollständig rot besetzt.

Die blaue Koalition muss schrittweise:

- Luftüberlegenheit herstellen
- das gegnerische IADS schwächen
- einen Brückenkopf an der syrischen Küste aufbauen
- Forward Operating Bases errichten
- CTLD-Logistik etablieren
- Basen und Gefechtszonen erobern
- rote Nachschubrouten unterbrechen
- strategische Ziele ausschalten

Der Spieler ist nicht der alleinige Mittelpunkt der Mission, sondern Teil eines größeren dynamischen Systems.

## Leitprinzip

```text
Mission Editor = Bühne
Lua = Kampagnensystem
GitHub = Projektgedächtnis
```

Der Mission Editor stellt nur die physische Grundmission bereit. Die eigentliche Kampagne entsteht durch Lua-Skripte.

## Technisches Zielbild

Das Projekt nutzt externe Frameworks nur als Bibliotheken:

- MOOSE
- MIST
- CTLD
- Skynet IADS

Die eigene Logik wird nicht nach Frameworks sortiert, sondern nach Aufgabenbereichen.

Nicht:

```text
eine große Moose-Datei
eine große Mist-Datei
eine große CTLD-Datei
```

Sondern:

```text
eine Datei für Airbase-Scanning
eine Datei für Zonen-Erzeugung
eine Datei für Capture
eine Datei für CTLD-Lieferungen
eine Datei für FOBs
eine Datei für Missionserzeugung
eine Datei für CAP
eine Datei für SEAD
eine Datei für Persistenz
```

## Kampagnenstart

```text
Blue Start: Akrotiri
Red Start: syrisches Festland vollständig rot
Erste aktive Region: syrische Küste
Erstes operatives Ziel: Küsten-IADS schwächen
Erstes logistisches Ziel: Beachhead/FOB an der Küste aufbauen
Erste Spielerrollen: F/A-18C, F-16C, F-14B, F-15E, UH-1H, Mi-8
Spätere Rollen nach FOB-Aufbau: A-10C II, AH-64D
```

## Projektstatus

Aktueller Stand:

```text
Projektsetup
Architekturdefinition
Mission-Editor-Grundlage
Lua-Modulstruktur vorbereitet
```

## Repository-Struktur

```text
vendor/         externe Frameworks
src/            eigene Lua-Skripte
docs/           Dokumentation
mission/        DCS-Missionsdateien
mission_editor/ Mission-Editor-Aufbau
assets/         Briefing, Kneeboard, Audio, Bilder
save/           Persistenz-Beispiele und Save-Dokumentation
tools/          Test- und Release-Hilfen
```

## Geplante Hauptordner

```text
theater-command-dcs/
│
├── README.md
├── ROADMAP.md
├── TASKS.md
├── CHANGELOG.md
├── ARCHITECTURE.md
├── MISSION_EDITOR_SETUP.md
├── NAMING_CONVENTIONS.md
├── LUA_STYLEGUIDE.md
│
├── docs/
├── vendor/
├── src/
├── mission/
├── mission_editor/
├── assets/
├── save/
└── tools/
```

## Erste Entwicklungsziele

1. Grundmission auf Syria erstellen
2. Akrotiri als blaue Startbasis einrichten
3. Spieler-Slots auf Akrotiri anlegen
4. Frameworks über Mission-Editor-Trigger laden
5. Theater-Command-Loader starten
6. Airbases automatisch scannen
7. Virtuelle Capture-/Logistik-/Defense-Zonen erzeugen
8. Erstes F10-Debugmenü anzeigen
9. CTLD-Grundlogik anbinden
10. Erste dynamische Missionen nach Flugzeugtyp generieren

## Entwicklungsgrundsatz

```text
Alles, was berechnet werden kann, wird nicht manuell im Mission Editor gebaut.
```

Airbases, virtuelle Zonen, Capture-Status, Logistikstatus, Missionsauswahl, KI-Reaktionen und Persistenz werden durch Lua verwaltet.

## Architekturregel

Jede Lua-Datei erfüllt genau eine klare Aufgabe.

Nicht nach Frameworks sortieren:

```text
tc_moose.lua
tc_mist.lua
tc_ctld.lua
```

Sondern nach Aufgaben:

```text
tc_airbase_scanner.lua
tc_zone_factory.lua
tc_capture_system.lua
tc_logistics_delivery.lua
tc_mission_generator.lua
tc_ai_cap_manager.lua
tc_persistence_system.lua
```

## Zielbild

Theater Command DCS soll langfristig ein eigenes modulares Kampagnensystem werden, das dynamische Einsätze, persistente Basen, CTLD-Logistik, KI-Gegenreaktionen und spielerabhängige Missionsangebote miteinander verbindet
