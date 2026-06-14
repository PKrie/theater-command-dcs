# Technical Architecture

Diese Datei beschreibt die technische Architektur von Theater Command DCS im Detail.

Sie ergänzt die Datei ARCHITECTURE.md im Hauptverzeichnis und dient als ausführlichere Dokumentation für die spätere Entwicklung.

---

## Ziel der Architektur

Theater Command DCS soll kein einzelnes Missionsskript werden, sondern ein modulares Kampagnensystem.

Das System soll später mehrere Teilbereiche miteinander verbinden:

- Mission Editor
- Lua-Core
- Airbase-System
- Zonen-System
- Capture-System
- CTLD-Logistik
- Missionsgenerator
- KI-Director
- IADS-System
- Persistenz
- Debug- und Statusmenüs

Jeder Bereich soll einzeln verständlich, testbar und erweiterbar bleiben.

---

## Grundprinzip

Die Architektur folgt diesem Grundsatz:

Mission Editor = Bühne  
Lua = Kampagnenlogik  
GitHub = Projektstruktur und Dokumentation  

Der Mission Editor baut nicht die Kampagne.

Der Mission Editor stellt nur die physische DCS-Grundlage bereit.

Die eigentliche Dynamik entsteht durch Lua.

---

## Externe Frameworks

Theater Command DCS nutzt externe Frameworks, verändert diese aber nicht.

Die Frameworks liegen später im Ordner vendor.

Geplante Frameworks:

- MOOSE
- MIST
- CTLD
- Skynet IADS

Diese Frameworks sind Werkzeuge.

Sie bestimmen nicht die Struktur des Projekts.

---

## Eigene Projektlogik

Die eigene Projektlogik liegt im Ordner src.

Die Struktur richtet sich nach Aufgabenbereichen.

Nicht nach Frameworks.

Schlecht:

tc_moose.lua  
tc_mist.lua  
tc_ctld.lua  
tc_skynet.lua  

Gut:

tc_airbase_scanner.lua  
tc_zone_factory.lua  
tc_capture_system.lua  
tc_logistics_delivery.lua  
tc_fob_system.lua  
tc_mission_generator.lua  
tc_ai_cap_manager.lua  
tc_persistence_system.lua  

---

## Hauptbereiche unter src

Geplante Hauptbereiche:

- src/core
- src/world
- src/campaign
- src/logistics
- src/missions
- src/ai
- src/iads
- src/ui
- src/debug

Jeder Bereich hat eine klar abgegrenzte Aufgabe.

---

## src/core

Der Core enthält die technische Basis des Systems.

Geplante Dateien:

- tc_config.lua
- tc_logger.lua
- tc_state.lua
- tc_utils.lua
- tc_scheduler.lua

Aufgaben:

- zentrale Konfiguration
- globale Projektstruktur
- Logging
- globaler Kampagnenzustand
- allgemeine Hilfsfunktionen
- zentrale Scheduler-Funktionen

Der Core wird als Erstes geladen.

Andere Systeme dürfen den Core verwenden.

Der Core soll aber möglichst wenig Abhängigkeiten zu späteren Systemen haben.

---

## src/world

Der Bereich world beschreibt die DCS-Welt und die Karte.

Geplante Dateien:

- tc_airbase_scanner.lua
- tc_airbase_registry.lua
- tc_airbase_overrides.lua
- tc_region_classifier.lua
- tc_zone_factory.lua
- tc_route_registry.lua
- tc_static_targets.lua

Aufgaben:

- Airbases automatisch erkennen
- Airbases registrieren
- Airbases Regionen zuordnen
- virtuelle Zonen erzeugen
- Routen verwalten
- statische Ziele registrieren
- Karteninformationen für andere Systeme bereitstellen

Dieser Bereich ist wichtig, weil viele spätere Systeme auf Airbases und Regionen zugreifen.

---

## Airbase-System

Das Airbase-System soll später automatisch alle Airbases der Syria Map erkennen.

Mögliche Daten pro Airbase:

- Name
- DCS-Objekt
- Koordinate
- Region
- aktueller Besitzer
- Capture-Zone
- Logistik-Zone
- Defense-Zone
- Ressourcenstatus
- Aktivitätsstatus
- strategische Bedeutung

Beispielhafte interne Struktur:

base = {
  name = "Akrotiri",
  owner = "blue",
  region = "cyprus",
  active = true,
  resources = {
    supply = 100,
    fuel = 100,
    ammo = 100
  }
}

Das Ziel ist, Airbases nicht manuell im Mission Editor zu verwalten.

---

## Virtuelle Zonen

Viele Zonen sollen nicht manuell im Mission Editor angelegt werden.

Stattdessen erzeugt Lua virtuelle Zonen.

Geplante virtuelle Zonentypen:

- Capture-Zone
- Logistics-Zone
- Defense-Zone
- Repair-Zone
- Spawn-Zone
- Warehouse-Zone

Diese Zonen existieren nur im Lua-System.

Sie müssen nicht als Trigger-Zonen im Mission Editor sichtbar sein.

---

## src/campaign

Der Bereich campaign enthält die strategische Kampagnenlogik.

Geplante Dateien:

- tc_base_ownership.lua
- tc_capture_system.lua
- tc_frontline_system.lua
- tc_resource_system.lua
- tc_economy_system.lua
- tc_persistence_system.lua

Aufgaben:

- Besitz von Basen verwalten
- Capture-Zustände berechnen
- Frontlinien ableiten
- Ressourcen verändern
- Economy simulieren
- Kampagnenzustand speichern und laden

Dieser Bereich entscheidet, wie sich die Kampagne entwickelt.

---

## Capture-System

Das Capture-System soll später bestimmen, wann eine Basis oder Region den Besitzer wechselt.

Mögliche Einflussfaktoren:

- Bodentruppen im Bereich
- zerstörte Verteidigung
- vorhandene Logistik
- Luftüberlegenheit
- aktive Gegner
- Missionsfortschritt
- Versorgungslage

Das Capture-System wird nicht durch einfache Mission-Editor-Trigger gebaut.

Es wird durch Lua gesteuert.

---

## Ressourcen-System

Basen und FOBs sollen Ressourcen besitzen.

Geplante Ressourcen:

- supply
- fuel
- ammo
- manpower
- repair
- medical
- command

Diese Ressourcen beeinflussen später:

- verfügbare Missionen
- KI-Aktivität
- Reparaturfähigkeit
- FOB-Ausbau
- CAP-Frequenz
- SAM-Wiederaufbau
- Gegenangriffe

---

## src/logistics

Der Bereich logistics enthält das Logistiksystem.

Geplante Dateien:

- tc_ctld_config.lua
- tc_logistics_hubs.lua
- tc_logistics_delivery.lua
- tc_fob_system.lua
- tc_supply_routes.lua
- tc_convoy_system.lua
- tc_warehouse_system.lua

Aufgaben:

- CTLD konfigurieren
- Logistikhubs verwalten
- Lieferungen auswerten
- FOBs aufbauen
- Konvois steuern
- Supply-Routen verwalten
- Lagerbestände simulieren

CTLD transportiert Kisten und Truppen.

Theater Command entscheidet, was diese Lieferungen strategisch bewirken.

---

## CTLD-Anbindung

CTLD ist für die Spielerinteraktion im Logistiksystem zuständig.

Beispiele:

- Kisten aufnehmen
- Kisten transportieren
- Kisten absetzen
- Truppen transportieren
- FOB-Elemente liefern

Theater Command wertet diese Aktionen aus.

Beispiel:

Ein Spieler liefert eine Supply-Kiste an FOB Alpha.

CTLD verarbeitet den Transport.

Theater Command erkennt die Lieferung.

FOB Alpha erhält supply.

Der Kampagnenzustand wird verändert.

---

## src/missions

Der Bereich missions enthält den dynamischen Missionsgenerator.

Geplante Dateien:

- tc_mission_generator.lua
- tc_mission_filter_by_aircraft.lua
- tc_mission_air_superiority.lua
- tc_mission_sead_dead.lua
- tc_mission_strike.lua
- tc_mission_cas.lua
- tc_mission_logistics.lua
- tc_mission_csar.lua
- tc_mission_recon.lua

Aufgaben:

- Spielerflugzeug erkennen
- passende Missionen auswählen
- Missionen aus dem Kampagnenzustand erzeugen
- Missionsziele definieren
- Erfolg oder Misserfolg auswerten
- Kampagnenzustand anpassen

Nicht jedes Flugzeug soll jede Mission bekommen.

---

## Missionsfilter nach Flugzeugtyp

Beispiele:

F/A-18C:

- CAP
- SEAD
- DEAD
- Strike
- Escort
- Anti-Ship optional

F-16C:

- CAP
- SEAD
- DEAD
- Strike
- Interdiction

F-15E:

- Deep Strike
- Depot Attack
- Runway Attack
- Command Post Strike

A-10C II:

- CAS
- Armed Recon
- Convoy Attack
- FOB Defense

AH-64D:

- Armed Recon
- CAS
- Anti-Armor
- FOB Defense

UH-1H und Mi-8:

- CTLD Transport
- Troop Insertion
- FOB Supply
- Logistics

---

## src/ai

Der Bereich ai steuert dynamische KI-Aktionen.

Geplante Dateien:

- tc_ai_director.lua
- tc_ai_cap_manager.lua
- tc_ai_gci_manager.lua
- tc_ai_strike_manager.lua
- tc_ai_cas_manager.lua
- tc_ai_ground_war.lua
- tc_ai_counterattack.lua

Aufgaben:

- CAP erzeugen
- GCI erzeugen
- Strike-Pakete erzeugen
- Bodenkrieg simulieren
- Gegenangriffe starten
- rote Reaktionen auslösen
- blaue KI-Unterstützung ermöglichen

Die KI soll später nicht statisch sein.

Sie soll auf die Kampagnenlage reagieren.

---

## AI Director

Der AI Director ist die übergeordnete Entscheidungslogik für KI-Aktionen.

Er soll später prüfen:

- Welche Regionen sind aktiv?
- Welche Basen sind bedroht?
- Welche Ressourcen sind verfügbar?
- Wie stark ist Blau?
- Wie stark ist Rot?
- Gibt es offene Missionsziele?
- Muss Rot reagieren?
- Muss Blau unterstützt werden?

Danach entscheidet der AI Director, welche KI-Aktionen sinnvoll sind.

---

## src/iads

Der Bereich iads verbindet Theater Command mit Skynet IADS.

Geplante Dateien:

- tc_iads_config.lua
- tc_iads_sector_manager.lua
- tc_iads_damage_handler.lua
- tc_iads_rebuild_system.lua

Aufgaben:

- IADS-Sektoren definieren
- Radar- und SAM-Strukturen verwalten
- Schäden auswerten
- IADS mit Regionen koppeln
- Wiederaufbau ermöglichen
- SEAD/DEAD-Erfolge in die Kampagne übertragen

---

## IADS-Integration

Skynet IADS übernimmt die taktische Luftverteidigungslogik.

Theater Command übernimmt die strategische Einbindung.

Beispiel:

Ein Radar wird zerstört.

Skynet IADS verliert einen Sensor.

Theater Command registriert den Schaden.

Der betroffene IADS-Sektor wird geschwächt.

Der Missionsgenerator erkennt bessere Chancen für Strike-Missionen.

Rot kann später versuchen, den Sektor wieder aufzubauen.

---

## src/ui

Der Bereich ui enthält Spielerinformationen und F10-Menüs.

Geplante Dateien:

- tc_f10_root_menu.lua
- tc_f10_mission_menu.lua
- tc_f10_status_menu.lua
- tc_f10_logistics_menu.lua
- tc_briefing_system.lua

Aufgaben:

- F10-Hauptmenü erstellen
- Missionen anzeigen
- Kampagnenstatus anzeigen
- Logistikstatus anzeigen
- Debug-Informationen anzeigen
- Briefinginformationen bereitstellen

Das UI soll dem Spieler erklären, was im Krieg gerade passiert.

---

## src/debug

Der Bereich debug enthält Entwicklungsfunktionen.

Geplante Dateien:

- tc_debug_airbases.lua
- tc_debug_zones.lua
- tc_debug_logistics.lua
- tc_debug_missions.lua
- tc_debug_state.lua

Aufgaben:

- erkannte Airbases anzeigen
- erzeugte Zonen anzeigen
- Logistikstatus prüfen
- Missionsgenerator prüfen
- Kampagnenzustand prüfen

Debug-Funktionen sind für die Entwicklung wichtig.

Später können sie im Release deaktiviert oder eingeschränkt werden.

---

## Lade-Reihenfolge

Die Lade-Reihenfolge ist wichtig.

Zuerst werden externe Frameworks geladen.

Danach wird der eigene Loader geladen.

Geplante Reihenfolge im Mission Editor:

1. MIST
2. MOOSE
3. CTLD
4. Skynet IADS
5. src/loader.lua

Danach lädt loader.lua die eigenen Projektdateien.

Geplante interne Reihenfolge:

1. Core
2. World
3. Campaign
4. Logistics
5. Missions
6. AI
7. IADS
8. UI
9. Debug
10. Main

---

## Globale Tabelle TC

Alle eigenen Systeme hängen an der globalen Tabelle TC.

Geplante Struktur:

TC.Core  
TC.World  
TC.Campaign  
TC.Logistics  
TC.Missions  
TC.AI  
TC.IADS  
TC.UI  
TC.Debug  

Dadurch entsteht ein klarer gemeinsamer Namespace.

---

## Datenfluss

Vereinfachter Datenfluss:

1. DCS startet die Mission.
2. Frameworks werden geladen.
3. Theater Command Loader startet.
4. Core wird initialisiert.
5. Airbases werden erkannt.
6. Virtuelle Zonen werden erzeugt.
7. Kampagnenzustand wird aufgebaut oder geladen.
8. F10-Menüs werden erstellt.
9. Missionsgenerator erstellt verfügbare Missionen.
10. KI-System reagiert auf die Lage.
11. CTLD-Lieferungen verändern Ressourcen.
12. Capture-System verändert Besitzstände.
13. Persistenz speichert den Zustand.

---

## Persistenz

Das Persistenzsystem wird erst später gebaut.

Es soll langfristig speichern:

- Basenbesitz
- Ressourcen
- FOB-Status
- zerstörte Ziele
- beschädigte IADS-Sektoren
- Kampagnenphase
- aktive Regionen
- Verluste
- Missionsfortschritt

Persistenz ist wichtig, aber sie wird erst nach Airbase-System, Zonen, Capture und Logistik sinnvoll.

---

## Entwicklungsreihenfolge

Die technische Entwicklung erfolgt in dieser Reihenfolge:

1. GitHub-Struktur
2. Dokumentation
3. Mission-Editor-Grundlage
4. Lua-Core
5. Logger
6. State-System
7. Airbase-Scanner
8. virtuelle Zonen
9. Airbase-Registry
10. F10-Debugmenü
11. Capture-Grundlogik
12. CTLD-Grundlogik
13. Missionsgenerator
14. KI-Director
15. IADS-Verknüpfung
16. Persistenz

---

## Architekturziel

Die Architektur soll verhindern, dass Theater Command DCS zu einer unübersichtlichen Einzelmission wird.

Das Projekt soll:

- modular bleiben
- lesbar bleiben
- testbar bleiben
- dokumentiert bleiben
- erweiterbar bleiben
- versionsfähig bleiben
- langfristig wartbar bleiben

Theater Command DCS soll Schritt für Schritt wachsen, ohne die Kontrolle über Struktur und Logik zu verlieren.
