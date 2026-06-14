# Persistence System

Diese Datei beschreibt das geplante Persistenzsystem von Theater Command DCS.

Persistenz bedeutet, dass der Kampagnenzustand zwischen mehreren DCS-Missionsstarts erhalten bleibt.

---

## Ziel

Theater Command DCS soll langfristig keine reine Einmal-Mission sein.

Der Zustand der Kampagne soll gespeichert und später wieder geladen werden können.

Dadurch bleiben wichtige Ereignisse erhalten:

- eroberte Basen
- verlorene Basen
- zerstörte Ziele
- beschädigte IADS-Sektoren
- aufgebaute FOBs
- verbrauchte Ressourcen
- abgeschlossene Missionen
- gescheiterte Missionen
- aktive Kampagnenphase
- Fortschritt der Front

---

## Grundsatz

Persistenz wird nicht am Anfang gebaut.

Erst müssen die Grundsysteme funktionieren:

1. Lua-Core
2. Airbase-System
3. Zonen-System
4. Capture-System
5. Logistiksystem
6. Missionsgenerator
7. AI Director
8. IADS-System

Erst danach ist Persistenz sinnvoll.

Ein fehlerhaftes System zu speichern, macht das Projekt nicht stabiler.

---

## Warum Persistenz wichtig ist

Ohne Persistenz startet jede Mission wieder bei null.

Das würde bedeuten:

- zerstörte Ziele sind wieder da
- eroberte Basen sind wieder rot
- FOBs existieren nicht mehr
- Ressourcen sind zurückgesetzt
- IADS ist wieder vollständig
- Fortschritt geht verloren

Mit Persistenz entsteht eine echte Kampagne.

Spieleraktionen haben dann langfristige Bedeutung.

---

## Geplante Lua-Dateien

Das Persistenzsystem liegt im Bereich:

src/campaign/

Geplante Datei:

- tc_persistence_system.lua

Mögliche spätere Ergänzungen:

- tc_save_writer.lua
- tc_save_loader.lua
- tc_save_validator.lua
- tc_save_migration.lua

---

## Was gespeichert werden soll

Das Persistenzsystem soll nicht jede einzelne DCS-Einheit speichern.

Gespeichert wird nur der strategisch relevante Kampagnenzustand.

---

## Airbase-Daten

Pro Airbase sollen gespeichert werden:

- Name
- Besitzer
- Region
- Aktivitätsstatus
- Ressourcen
- Capture-Status
- Logistikstatus
- Beschädigungsstatus
- strategische Bedeutung

Beispielhafte Daten:

Base Akrotiri:

- owner = blue
- active = true
- supply = 100
- fuel = 100
- ammo = 100

Base Khmeimim:

- owner = red
- active = true
- supply = 80
- fuel = 60
- ammo = 70

---

## FOB-Daten

Pro FOB sollen gespeichert werden:

- Name
- Besitzer
- Position
- Ausbaustufe
- Aktivitätsstatus
- Ressourcen
- Verteidigungsstatus
- letzte Versorgung
- beschädigte Module

Mögliche FOB-Level:

Level 0 = geplant  
Level 1 = einfache Landezone  
Level 2 = Logistikpunkt  
Level 3 = bewaffnete FOB  
Level 4 = voll einsatzfähige vorgeschobene Basis  

---

## Ressourcen

Gespeichert werden sollen einheitliche Ressourcen:

- supply
- fuel
- ammo
- manpower
- repair
- medical
- command

Diese Ressourcen können pro Basis, FOB, Depot oder Lagerpunkt gespeichert werden.

---

## Statische Ziele

Statische Ziele sollen gespeichert werden, wenn sie kampagnenrelevant sind.

Beispiele:

- Radarstellungen
- Fuel Depots
- Ammo Depots
- Command Posts
- Naval Depots
- Repair Facilities
- Warehouses

Mögliche Statuswerte:

- intact
- damaged
- destroyed
- inactive
- rebuilding

---

## IADS-Daten

Das IADS-System soll persistent sein.

Gespeichert werden sollen:

- IADS-Sektoren
- Bedrohungsgrad
- Radarstatus
- SAM-Status
- Command-Status
- zerstörte Komponenten
- Wiederaufbau-Cooldowns
- Ressourcen für Wiederaufbau

Beispiel:

latakia_sector:

- threatLevel = 45
- radarOperational = false
- samOperational = true
- commandOperational = true
- rebuildCooldown = 1800

---

## Missionsdaten

Missionen sollen ebenfalls gespeichert werden.

Gespeichert werden können:

- abgeschlossene Missionen
- fehlgeschlagene Missionen
- aktive Missionen
- abgebrochene Missionen
- zerstörte Missionsziele
- offene Missionsketten

Mögliche Statuswerte:

- available
- selected
- active
- completed
- failed
- expired
- cancelled

---

## Kampagnenphase

Die aktuelle Kampagnenphase soll gespeichert werden.

Mögliche Phasen:

Phase 0 = Setup und Initialisierung  
Phase 1 = Air Superiority Preparation  
Phase 2 = IADS Suppression  
Phase 3 = Coastal Strike Campaign  
Phase 4 = Beachhead Establishment  
Phase 5 = FOB Aufbau  
Phase 6 = Inland Offensive  
Phase 7 = Red Counteroffensive  
Phase 8 = Theater Expansion  

---

## Front- und Regionenstatus

Gespeichert werden sollen:

- aktive Regionen
- gesperrte Regionen
- umkämpfte Regionen
- eroberte Regionen
- bedrohte Regionen

Beispiele:

syrian_coast = active  
central_syria = locked  
cyprus = blue_controlled  
latakia_area = contested  

---

## Logistikdaten

Gespeichert werden sollen:

- aktive Logistikhubs
- Ressourcen pro Hub
- aktive Supply-Routen
- unterbrochene Supply-Routen
- zerstörte Konvois
- erfolgreiche Lieferungen
- offene Lieferbedarfe

Beispiel:

FOB Alpha:

- supply niedrig
- ammo mittel
- fuel niedrig
- repair niedrig
- braucht neue CTLD-Lieferung

---

## KI-Daten

Der AI Director muss nicht jede temporäre KI-Gruppe speichern.

Gespeichert werden sollen eher strategische KI-Zustände.

Beispiele:

- Cooldowns für CAP
- Cooldowns für Gegenangriffe
- letzte rote Offensive
- aktive Bedrohungsstufen
- Eskalationsstufe
- verfügbare rote Ressourcen
- verfügbare blaue Unterstützung

---

## Was nicht gespeichert werden soll

Nicht alles muss persistent sein.

Nicht speichern:

- jede einzelne Kugel
- jede einzelne temporäre Einheit
- jede kurzlebige Spawn-Gruppe
- jede CAP-Patrouille
- jede GCI-Gruppe
- jedes temporäre Menü
- jede Debug-Ausgabe

Diese Dinge können beim nächsten Start neu erzeugt werden.

Gespeichert wird der strategische Zustand, nicht jede taktische Einzelheit.

---

## Speicherformat

DCS Lua kann Kampagnendaten grundsätzlich als Lua-Tabelle speichern.

Geplante Speicheridee:

- Save-Datei als Lua-Datei
- klare Tabellenstruktur
- einfache Lesbarkeit
- manuelle Kontrolle möglich
- später optional JSON-ähnliche Struktur

Beispielhafte Datei:

save/theater_command_state.lua

Diese Datei wird später nicht direkt über GitHub versioniert, wenn sie echte Spielstände enthält.

---

## GitHub und Save-Dateien

Echte Save-Dateien sollen nicht versehentlich ins Repository geladen werden.

Darum ignoriert `.gitignore` spätere Save-Dateien.

Ausnahmen:

- save/README.md
- save/example_state.lua

Echte lokale Kampagnenspeicher bleiben lokal.

Beispiel:

save/current_state.lua wird ignoriert.

save/example_state.lua bleibt erlaubt.

---

## Beispielhafter Kampagnenzustand

Eine spätere Save-Struktur könnte enthalten:

TC_SAVE = {
  campaignName = "Operation Levant Reclamation",
  campaignPhase = 2,
  activeRegion = "syrian_coast",

  bases = {
    Akrotiri = {
      owner = "blue",
      active = true,
      resources = {
        supply = 100,
        fuel = 100,
        ammo = 100
      }
    },

    Khmeimim = {
      owner = "red",
      active = true,
      resources = {
        supply = 80,
        fuel = 60,
        ammo = 70
      }
    }
  },

  fobs = {
    FOB_ALPHA = {
      owner = "blue",
      level = 1,
      active = true,
      resources = {
        supply = 30,
        fuel = 10,
        ammo = 20
      }
    }
  }
}

Dies ist nur ein Planungsbeispiel.

Die genaue technische Umsetzung erfolgt später.

---

## Laden eines Spielstands

Beim Missionsstart soll später folgender Ablauf stattfinden:

1. Frameworks laden
2. Theater Command Loader starten
3. Core initialisieren
4. Airbases scannen
5. virtuelle Zonen erzeugen
6. Save-Datei suchen
7. Save-Datei laden
8. Kampagnenzustand anwenden
9. F10-Menüs aufbauen
10. Missionsgenerator starten
11. AI Director starten

---

## Speichern eines Spielstands

Gespeichert werden kann später:

- regelmäßig nach Zeitintervall
- nach Missionsabschluss
- nach Capture-Ereignis
- nach CTLD-Lieferung
- nach Zerstörung eines strategischen Ziels
- bei manuellem F10-Befehl
- beim Missionsende

Möglicher F10-Befehl:

Theater Command -> Admin -> Save Campaign State

---

## Save-Intervalle

Automatisches Speichern soll vorsichtig genutzt werden.

Zu häufiges Speichern kann unnötig sein.

Mögliche Intervalle:

- alle 5 Minuten für Entwicklung
- alle 15 Minuten für normale Nutzung
- zusätzlich bei wichtigen Ereignissen

Wichtige Ereignisse:

- Basis erobert
- FOB gebaut
- strategisches Ziel zerstört
- Mission abgeschlossen
- IADS-Sektor geschwächt

---

## Fehlerbehandlung

Das Persistenzsystem muss robust sein.

Mögliche Fehler:

- Save-Datei fehlt
- Save-Datei ist beschädigt
- Feld fehlt
- Airbase-Name stimmt nicht mehr
- alte Save-Version passt nicht mehr zur neuen Code-Version

Das System soll dann nicht komplett abstürzen.

Mögliche Reaktionen:

- Warnung ausgeben
- Standardwert nutzen
- Save-Datei ignorieren
- neue Kampagne starten
- Debug-Hinweis erzeugen

---

## Save-Version

Jede Save-Datei soll später eine Versionsnummer besitzen.

Beispiel:

saveVersion = 1

Das ist wichtig, wenn sich die interne Datenstruktur später ändert.

Mögliche spätere Funktion:

TC.Persistence.ValidateSaveVersion()

---

## Save-Migration

Wenn sich die Speicherstruktur ändert, kann eine Migration nötig sein.

Beispiel:

Version 1 speichert nur owner und resources.

Version 2 speichert zusätzlich IADS und FOB-Level.

Dann muss das System alte Saves entweder:

- automatisch ergänzen
- als veraltet markieren
- oder kontrolliert ablehnen

Migration kommt erst später.

---

## Persistenz und Multiplayer

Multiplayer macht Persistenz schwieriger.

Zu beachten:

- mehrere Spieler können gleichzeitig Missionen auslösen
- CTLD-Lieferungen können parallel passieren
- Missionserfolg muss eindeutig bewertet werden
- Speichern darf nicht widersprüchlich sein
- F10-Admin-Befehle müssen kontrolliert werden

Für die erste Entwicklungsphase reicht Singleplayer- oder kleiner Coop-Fokus.

---

## Persistenz und DCS-Einschränkungen

DCS speichert dynamische Lua-Zustände nicht automatisch dauerhaft.

Das Projekt muss selbst speichern und laden.

Je nach DCS-Umgebung können Schreibrechte und Mission-Scripting-Einstellungen eine Rolle spielen.

Das wird später separat getestet.

Für die Planung gilt:

Theater Command braucht ein eigenes Save- und Load-System.

---

## Entwicklungsreihenfolge

Persistenz wird spät umgesetzt.

Empfohlene Reihenfolge:

1. Datenmodell definieren
2. Beispiel-Save-Datei erstellen
3. Airbase-State speichern
4. Airbase-State laden
5. Ressourcen speichern
6. FOB-Status speichern
7. Missionsstatus speichern
8. IADS-Status speichern
9. Save-Version hinzufügen
10. Fehlerbehandlung hinzufügen
11. manuelles F10-Speichern testen
12. automatisches Speichern testen
13. Multiplayer-Verhalten später prüfen

---

## Erste Testversion

Die erste Persistenz-Testversion soll nur wenig speichern.

Testinhalt:

- Kampagnenname
- Kampagnenphase
- Besitzer von Akrotiri
- Besitzer von Khmeimim
- Ressourcen von Akrotiri
- Ressourcen von Khmeimim

Noch nicht speichern:

- komplette Karte
- alle Einheiten
- alle Missionen
- alle IADS-Details
- alle Konvois
- alle Spieleraktionen

---

## Debug-Funktionen

Geplante Debug-Ausgaben:

- Save-Datei gefunden
- Save-Datei geladen
- Save-Datei nicht gefunden
- neuer Kampagnenzustand erstellt
- Airbase-State geladen
- Ressourcen geladen
- Save erfolgreich geschrieben
- Save fehlgeschlagen
- Save-Version erkannt

Mögliche spätere Funktion:

TC.Debug.PrintPersistenceStatus()

---

## Was bewusst nicht sofort gebaut wird

Nicht in der frühen Phase:

- keine komplette Save-Engine
- keine perfekte Multiplayer-Persistenz
- keine vollständige Speicherung jeder Einheit
- keine automatische Migration
- keine komplexe Datenbank
- keine externe App
- keine perfekte Fehlerkorrektur

Zuerst muss der Kampagnenzustand intern sauber funktionieren.

---

## Zielbild

Das Persistenzsystem soll Theater Command DCS zu einer echten Kampagne machen.

Spieler sollen merken:

- zerstörte Ziele bleiben zerstört
- eroberte Basen bleiben erobert
- verlorene FOBs bleiben verloren
- Ressourcenverbrauch hat Bedeutung
- IADS-Schäden wirken langfristig
- Logistik beeinflusst den nächsten Einsatz
- die Kampagne entwickelt sich über mehrere Sessions weiter

Persistenz macht aus einer Mission eine fortlaufende Operation.