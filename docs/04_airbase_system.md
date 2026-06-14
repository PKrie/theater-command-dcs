# Airbase System

Diese Datei beschreibt das geplante Airbase-System von Theater Command DCS.

Das Airbase-System ist eines der wichtigsten Grundsysteme des Projekts, weil viele spätere Funktionen davon abhängen.

Dazu gehören:

- Capture-System
- Logistiksystem
- Missionsgenerator
- KI-Director
- IADS-Verknüpfung
- Persistenz
- Frontlinienlogik

---

## Ziel

Das Ziel ist, Airbases nicht manuell im Mission Editor verwalten zu müssen.

Theater Command soll Airbases automatisch erkennen, intern registrieren und daraus eigene Kampagnenknoten erzeugen.

Diese Kampagnenknoten werden BaseNodes genannt.

Eine Airbase ist dabei nicht nur ein DCS-Flugplatz, sondern ein strategisches Objekt innerhalb der Kampagne.

---

## Grundsatz

Airbases werden automatisch erkannt.

Trigger-Zonen für jede Airbase werden nicht manuell im Mission Editor angelegt.

Stattdessen erzeugt Lua virtuelle Zonen um die Airbases.

Der Mission Editor stellt nur die Airbases bereit, die auf der Map ohnehin vorhanden sind.

Theater Command übernimmt die strategische Verwaltung.

---

## Warum automatische Airbase-Erkennung?

Die Syria Map enthält viele Flugplätze und Helipads.

Es wäre unübersichtlich und fehleranfällig, für jede Basis manuell Trigger-Zonen, Capture-Zonen, Logistik-Zonen und Defense-Zonen anzulegen.

Deshalb soll das System:

- Airbases automatisch finden
- Airbases eindeutig registrieren
- Koordinaten auslesen
- Besitzer verwalten
- Regionen zuordnen
- virtuelle Zonen erzeugen
- Ressourcen verwalten
- strategische Bedeutung speichern

---

## Mission Editor Rolle

Im Mission Editor müssen keine 69 Airbase-Zonen gebaut werden.

Der Mission Editor muss nur enthalten:

- Syria Map
- Koalitionen
- Spieler-Slots
- Templates
- Framework-Loader
- wenige Start-CTLD-Zonen
- sichtbare statische Ziele

Airbase-Logik wird später in Lua gebaut.

---

## Geplante Lua-Dateien

Das Airbase-System liegt im Bereich:

src/world/

Geplante Dateien:

- tc_airbase_scanner.lua
- tc_airbase_registry.lua
- tc_airbase_overrides.lua
- tc_region_classifier.lua
- tc_zone_factory.lua

---

## tc_airbase_scanner.lua

Diese Datei erkennt alle Airbases der aktuellen DCS-Map.

Aufgaben:

- DCS-Airbases auslesen
- Airbase-Namen erfassen
- Koordinaten erfassen
- Airbase-Typ erkennen
- Airbase an Registry übergeben
- Debug-Ausgabe ermöglichen

Mögliche spätere Funktion:

TC.World.ScanAirbases()

---

## tc_airbase_registry.lua

Diese Datei speichert alle erkannten Airbases als BaseNodes.

Aufgaben:

- Airbases registrieren
- BaseNodes erzeugen
- Airbase-Daten zentral speichern
- Suche nach Name ermöglichen
- Suche nach Region ermöglichen
- Suche nach Besitzer ermöglichen
- Zugriff für andere Systeme bereitstellen

Mögliche spätere Funktionen:

TC.World.RegisterAirbase(baseData)
TC.World.GetAirbaseByName(name)
TC.World.GetAirbasesByOwner(owner)
TC.World.GetAirbasesByRegion(region)

---

## tc_airbase_overrides.lua

Diese Datei enthält manuelle Korrekturen.

Nicht alle Informationen lassen sich perfekt automatisch bestimmen.

Deshalb kann es Overrides geben.

Beispiele:

- Region einer Airbase festlegen
- Startbesitzer überschreiben
- strategische Bedeutung setzen
- bestimmte Airbases sperren
- bestimmte Helipads ignorieren
- spezielle Logistikwerte setzen

Beispielhafte Override-Idee:

Akrotiri:
owner = blue
region = cyprus
importance = high
active = true

Khmeimim:
owner = red
region = syrian_coast
importance = high
active = true

---

## tc_region_classifier.lua

Diese Datei ordnet Airbases Regionen zu.

Geplante Regionen:

- cyprus
- eastern_med
- syrian_coast
- central_syria
- northern_syria
- damascus_sector
- lebanon_sector
- jordan_sector
- israel_sector
- turkey_sector

Die Region ist wichtig für:

- Missionsgenerator
- KI-Reaktionen
- IADS-Sektoren
- Frontlinienlogik
- Logistikrouten
- Kampagnenphasen

---

## tc_zone_factory.lua

Diese Datei erzeugt virtuelle Zonen um Airbases.

Geplante Zonentypen:

- Capture-Zone
- Logistics-Zone
- Defense-Zone
- Repair-Zone
- Spawn-Zone
- Warehouse-Zone

Diese Zonen müssen nicht im Mission Editor existieren.

Sie werden durch Lua erzeugt und intern verwendet.

---

## BaseNode

Ein BaseNode ist die interne Theater-Command-Darstellung einer Airbase.

Ein BaseNode enthält alle Informationen, die für die Kampagne wichtig sind.

Mögliche Daten:

- Name
- DCS-Airbase-Objekt
- Koordinate
- Region
- Besitzer
- Aktivitätsstatus
- strategische Bedeutung
- Ressourcen
- virtuelle Zonen
- verfügbare Rollen
- Capture-Status
- Logistikstatus
- IADS-Verbindung
- Persistenzdaten

---

## Beispielstruktur eines BaseNode

Beispielhafte interne Struktur:

base = {
  name = "Akrotiri",
  owner = "blue",
  region = "cyprus",
  active = true,
  importance = "high",

  resources = {
    supply = 100,
    fuel = 100,
    ammo = 100,
    manpower = 100,
    repair = 100,
    medical = 50,
    command = 100
  },

  zones = {
    capture = nil,
    logistics = nil,
    defense = nil,
    repair = nil,
    spawn = nil,
    warehouse = nil
  }
}

Diese Struktur ist nur ein Planungsbeispiel.

Die genaue Lua-Umsetzung erfolgt später.

---

## Besitzerwerte

Einheitliche Besitzerwerte:

- blue
- red
- neutral
- contested
- locked
- inactive

Bedeutung:

blue = durch Blau kontrolliert  
red = durch Rot kontrolliert  
neutral = keine Seite kontrolliert die Basis aktiv  
contested = umkämpft  
locked = gesperrt und nicht Teil der aktiven Kampagne  
inactive = erkannt, aber aktuell nicht aktiv genutzt  

---

## Startbesitz in Operation Levant Reclamation

Zu Beginn der Kampagne gilt:

Akrotiri = blue

Das syrische Festland = red

Andere Regionen können zunächst neutral, locked oder inactive sein.

Mögliche Anfangslogik:

- Akrotiri ist aktiv und blau
- syrische Küstenbasen sind aktiv und rot
- tiefer liegende syrische Basen sind rot, aber eventuell noch nicht aktiv
- Türkei, Israel, Jordanien und Libanon sind zunächst locked oder inactive

---

## Wichtige erste Airbases

Für die erste Entwicklungsphase sind besonders relevant:

### Blau

- Akrotiri

### Rot

- Khmeimim
- Latakia
- Bassel Al-Assad
- Hama
- Homs
- Damascus
- Mezzeh
- Tiyas
- Palmyra

Die genaue Namensschreibweise muss später durch den Airbase-Scanner aus DCS ausgelesen werden.

---

## Virtuelle Capture-Zone

Die Capture-Zone bestimmt später, ob eine Basis umkämpft oder eroberbar ist.

Mögliche Faktoren:

- blaue Bodentruppen in der Zone
- rote Bodentruppen in der Zone
- zerstörte Verteidigung
- vorhandene Logistik
- Luftüberlegenheit
- Missionsfortschritt

Die Capture-Zone wird nicht als Editor-Triggerzone angelegt.

Sie wird per Lua um die Airbase herum erzeugt.

---

## Virtuelle Logistics-Zone

Die Logistics-Zone bestimmt später, ob eine Lieferung an einer Basis zählt.

Mögliche Nutzung:

- CTLD-Lieferungen auswerten
- Konvois registrieren
- Supply erhöhen
- Fuel erhöhen
- Ammo erhöhen
- Repair erhöhen
- FOB-Aufbau ermöglichen

---

## Virtuelle Defense-Zone

Die Defense-Zone beschreibt den Verteidigungsbereich einer Basis.

Mögliche Nutzung:

- Garnisonen prüfen
- SAM/SHORAD prüfen
- CAP-Abdeckung bewerten
- CAS-Missionen erzeugen
- Angriffe und Gegenangriffe auswerten

---

## Airbase und IADS

Airbases können später mit IADS-Sektoren verbunden werden.

Beispiel:

Khmeimim besitzt einen IADS-Sektor.

Wird ein Radar zerstört, wird der Sektor schwächer.

Wird ein Command Post zerstört, reagiert der Sektor langsamer.

Wird ein Fuel Depot zerstört, kann weniger CAP starten.

Theater Command verbindet diese Ereignisse strategisch.

---

## Airbase und Logistik

Jede aktive Basis kann später Ressourcen besitzen.

Ressourcen:

- supply
- fuel
- ammo
- manpower
- repair
- medical
- command

Diese Ressourcen beeinflussen:

- verfügbare KI-Flüge
- Reparaturfähigkeit
- SAM-Wiederaufbau
- FOB-Betrieb
- Missionsangebote
- Gegenangriffe
- Verteidigungsstärke

---

## Airbase und Missionsgenerator

Der Missionsgenerator nutzt Airbase-Daten, um sinnvolle Missionen zu erzeugen.

Beispiele:

Wenn rote CAP von Khmeimim aktiv ist:

- CAP-Mission
- Fighter Sweep
- Intercept
- Escort

Wenn Khmeimim ein Fuel Depot besitzt:

- Strike Mission
- Depot Attack

Wenn eine Basis geschwächt ist:

- CAS
- Capture Support
- Airbase Assault

Wenn Blau eine FOB nahe der Küste hat:

- A-10C CAS
- AH-64D Armed Recon
- CTLD Supply

---

## Airbase und KI-Director

Der KI-Director nutzt Airbase-Daten, um KI-Aktionen zu planen.

Mögliche Entscheidungen:

- rote CAP von aktiver Basis starten
- GCI bei Luftraumverletzung starten
- Konvoi zu bedrohter Basis schicken
- Gegenangriff auf verlorene Basis auslösen
- beschädigte Basis verstärken
- SAM-Wiederaufbau starten

---

## Airbase und Persistenz

Das Airbase-System muss später persistenzfähig sein.

Gespeichert werden sollen:

- Besitzer
- Ressourcen
- Aktivitätsstatus
- zerstörte Infrastruktur
- FOB-Verbindungen
- IADS-Zustand
- Capture-Fortschritt
- strategische Bedeutung
- letzte bekannte Lage

Persistenz kommt später.

Zuerst müssen Airbase-Erkennung und Registry stabil funktionieren.

---

## Debug-Funktionen

Für die Entwicklung sind Debug-Ausgaben wichtig.

Geplante Debug-Funktionen:

- alle erkannten Airbases anzeigen
- Airbase-Namen ausgeben
- Besitzer anzeigen
- Regionen anzeigen
- Koordinaten anzeigen
- virtuelle Zonen anzeigen
- BaseNode-Daten prüfen

Mögliche spätere Funktion:

TC.Debug.PrintAirbases()

---

## Erste Testziele

Der erste technische Test des Airbase-Systems soll nur prüfen:

- Lua lädt korrekt
- Airbase-Scanner startet
- Airbases werden erkannt
- Airbase-Namen werden ausgegeben
- Akrotiri wird erkannt
- Khmeimim wird erkannt
- BaseNodes werden erzeugt
- Debug-Ausgabe erscheint in dcs.log oder F10-Menü

Noch nicht testen:

- Capture
- CTLD
- Persistenz
- KI-Director
- IADS
- Ressourcenverbrauch

---

## Entwicklungsreihenfolge

Empfohlene Reihenfolge:

1. TC-Grundstruktur erstellen
2. Logger erstellen
3. Airbase-Scanner erstellen
4. Airbase-Namen ausgeben
5. BaseNode-Struktur definieren
6. Registry erstellen
7. Akrotiri als blue setzen
8. syrische Airbases als red setzen
9. Regionen zuweisen
10. virtuelle Zonen erzeugen
11. Debug-Funktion bauen
12. Airbase-Daten für andere Systeme bereitstellen

---

## Was bewusst nicht gemacht wird

Nicht in der ersten Version:

- keine vollständige Capture-Logik
- keine Ressourcenberechnung
- keine Persistenz
- keine automatischen Gegenangriffe
- keine 69 manuell gebauten Triggerzonen
- keine komplette Frontlinie
- keine komplexe IADS-Kopplung

Erst muss das Airbase-System zuverlässig erkennen und registrieren.

---

## Zielbild

Das Airbase-System bildet später das Rückgrat der gesamten Kampagne.

Jede Basis ist ein strategischer Knoten.

Aus diesen Knoten entstehen:

- Frontlinien
- Missionen
- Logistikketten
- KI-Reaktionen
- IADS-Sektoren
- Capture-Ziele
- persistente Kampagnenzustände

Wenn das Airbase-System sauber funktioniert, können alle späteren Systeme darauf aufbauen.
