# Logistics System

Diese Datei beschreibt das geplante Logistiksystem von Theater Command DCS.

Das Logistiksystem ist ein zentrales Element der Kampagne, weil Fortschritt nicht nur durch Luftangriffe entstehen soll, sondern auch durch Versorgung, Transport, FOB-Aufbau und Nachschub.

---

## Ziel

Das Ziel ist ein dynamisches Logistiksystem, das CTLD, Basen, FOBs, Konvois und Ressourcen miteinander verbindet.

Logistik soll später beeinflussen:

- welche Basen einsatzfähig sind
- welche FOBs gebaut werden können
- welche Missionen verfügbar sind
- wie stark KI-Kräfte reagieren können
- ob Basen repariert werden können
- ob SAM-Stellungen wieder aufgebaut werden können
- ob Gegenangriffe möglich sind

---

## Grundsatz

CTLD übernimmt die Spielerinteraktion.

Theater Command übernimmt die strategische Auswertung.

Das bedeutet:

CTLD transportiert Kisten und Truppen.

Theater Command entscheidet, was diese Lieferungen im Kampagnensystem bewirken.

---

## Beispiel

Ein Spieler fliegt mit UH-1H oder Mi-8 eine Supply-Kiste von Akrotiri zu einer FOB-Zone.

CTLD verarbeitet:

- Kiste aufnehmen
- Kiste transportieren
- Kiste absetzen

Theater Command verarbeitet:

- Lieferung erkennen
- Zielzone bestimmen
- Ressourcentyp bestimmen
- FOB oder Basis aktualisieren
- Kampagnenzustand verändern
- Debug- oder F10-Meldung ausgeben

---

## Geplante Lua-Dateien

Das Logistiksystem liegt im Bereich:

src/logistics/

Geplante Dateien:

- tc_ctld_config.lua
- tc_logistics_hubs.lua
- tc_logistics_delivery.lua
- tc_fob_system.lua
- tc_supply_routes.lua
- tc_convoy_system.lua
- tc_warehouse_system.lua

---

## tc_ctld_config.lua

Diese Datei enthält die CTLD-Grundkonfiguration.

Aufgaben:

- CTLD aktivieren
- Pickup-Zonen definieren
- transportierbare Kisten definieren
- Truppentypen definieren
- Heli-Transportregeln definieren
- erste Akrotiri-Logistik vorbereiten

Wichtig:

CTLD wird nicht zur strategischen Kampagnenlogik.

CTLD bleibt das Transportwerkzeug.

---

## tc_logistics_hubs.lua

Diese Datei verwaltet Logistikhubs.

Ein Logistikhub ist ein Ort, von dem Versorgung ausgehen kann.

Mögliche Hub-Typen:

- Airbase
- FOB
- Carrier optional
- Depot
- Beachhead
- Warehouse

Erster blauer Logistikhub:

Akrotiri

Spätere blaue Hubs:

- Beachhead Alpha
- FOB Alpha
- eroberte Flugplätze
- Carrier optional

Rote Hubs:

- Khmeimim
- Latakia
- Tartus
- Hama
- Homs
- Damascus
- Depots und Nachschubpunkte

---

## tc_logistics_delivery.lua

Diese Datei wertet Lieferungen aus.

Aufgaben:

- Lieferung erkennen
- Ziel bestimmen
- Ressource bestimmen
- Menge bestimmen
- Basis oder FOB aktualisieren
- Erfolgsmeldung ausgeben
- Kampagnenstatus verändern

Beispiele für Lieferungen:

- Supply-Kiste
- Fuel-Kiste
- Ammo-Kiste
- Repair-Kiste
- Medical-Kiste
- Command-Kiste
- Engineer-Team
- Infantry-Team

---

## tc_fob_system.lua

Diese Datei verwaltet Forward Operating Bases.

FOBs sind vorgeschobene Stützpunkte.

Sie sollen später durch CTLD-Lieferungen aufgebaut werden.

Ein FOB kann abhängig vom Ausbaugrad bieten:

- Heli-Landeplatz
- Supply-Punkt
- Reparaturpunkt
- Munitionspunkt
- Treibstoffpunkt
- Infanterie-Garnison
- später A-10C- oder AH-64D-nahe Einsatzräume
- lokale Verteidigung
- Missionsausgangspunkt

---

## FOB-Aufbau

Ein FOB soll nicht einfach automatisch entstehen.

Es soll durch Lieferungen aufgebaut werden.

Beispiel für FOB Alpha:

Benötigt:

- Engineer-Team
- Command-Kiste
- Supply-Kisten
- Fuel-Kisten
- Ammo-Kisten
- Infantry-Team

Mögliche Ausbaustufen:

Level 0 = geplant, aber nicht aktiv  
Level 1 = einfache Landezone  
Level 2 = Logistikpunkt  
Level 3 = bewaffnete FOB  
Level 4 = voll einsatzfähige vorgeschobene Basis  

---

## tc_supply_routes.lua

Diese Datei verwaltet Nachschubrouten.

Nachschubrouten verbinden:

- Airbase zu Airbase
- Airbase zu FOB
- Depot zu Airbase
- Depot zu Front
- Beachhead zu FOB
- Carrier zu Küste optional

Nachschubrouten können später beeinflusst werden durch:

- feindliche Luftüberlegenheit
- zerstörte Infrastruktur
- Konvoi-Verluste
- IADS-Bedrohung
- Bodenlage
- Missionsfortschritt

---

## tc_convoy_system.lua

Diese Datei verwaltet Konvois.

Konvois können später automatisch oder missionsabhängig erzeugt werden.

Mögliche Konvoi-Typen:

- Supply Convoy
- Fuel Convoy
- Ammo Convoy
- Repair Convoy
- Troop Convoy
- Counterattack Convoy

Konvois können genutzt werden für:

- blaue Versorgung
- rote Versorgung
- rote Gegenangriffe
- dynamische Angriffsziele
- Interdiction-Missionen
- Convoy Escort-Missionen

---

## tc_warehouse_system.lua

Diese Datei verwaltet Lagerbestände.

Ein Warehouse kann Ressourcen speichern.

Mögliche Ressourcen:

- supply
- fuel
- ammo
- manpower
- repair
- medical
- command

Warehouse-Systeme können später an Basen, FOBs oder Depots gebunden werden.

---

## Ressourcen

Einheitliche Ressourcennamen:

- supply
- fuel
- ammo
- manpower
- repair
- medical
- command

Bedeutung:

supply = allgemeine Versorgung  
fuel = Treibstoff  
ammo = Munition  
manpower = Personal und Truppen  
repair = Reparaturfähigkeit  
medical = medizinische Versorgung  
command = Führungsfähigkeit  

---

## Ressourcenwirkung

Ressourcen sollen später direkte Auswirkungen haben.

Beispiele:

Zu wenig fuel:

- weniger CAP
- weniger GCI
- weniger Strike-Flüge
- eingeschränkte Transportflüge

Zu wenig ammo:

- weniger SAM-Wiederaufbau
- weniger Artillerie
- weniger Verteidigungsfähigkeit

Zu wenig supply:

- keine FOB-Erweiterung
- langsamere Reparatur
- schwächere Basisversorgung

Zu wenig command:

- langsamere KI-Reaktion
- schwächere Gegenoffensive
- schlechtere Koordination

Zu wenig repair:

- zerstörte Infrastruktur bleibt länger beschädigt

---

## Akrotiri als erster Logistikhub

Akrotiri ist der erste blaue Logistikhub.

Akrotiri soll zu Beginn haben:

- hohe Versorgung
- Treibstoff
- Munition
- Transportkapazität
- CTLD-Pickup-Zonen
- Spieler-Heli-Slots
- Jet-Slots
- Zugriff auf erste Missionen

Akrotiri ist der Ausgangspunkt für:

- CTLD-Transporte
- Supply-Flüge
- Troop Insertions
- erste Beachhead-Operationen
- erste FOB-Aufbauphase

---

## CTLD-Startzonen

Im Mission Editor werden nur wenige Startzonen angelegt.

Startzonen auf Akrotiri:

- ZONE_BLUE_AKROTIRI_CTLD_PICKUP
- ZONE_BLUE_AKROTIRI_CTLD_TROOP_PICKUP
- ZONE_BLUE_AKROTIRI_CTLD_SUPPLY_PICKUP
- ZONE_BLUE_AKROTIRI_CTLD_VEHICLE_PICKUP

Erste mögliche Drop-Zonen:

- ZONE_BLUE_BEACHHEAD_ALPHA_DROP
- ZONE_BLUE_FOB_ALPHA_SITE

Nicht für jede Airbase eigene CTLD-Zonen anlegen.

Theater Command entscheidet später dynamisch, welche Basis als Logistikhub aktiv ist.

---

## Beachhead

Ein Beachhead ist der erste Brückenkopf auf dem syrischen Festland.

Der Beachhead ist noch keine vollwertige FOB.

Er ist der Übergang zwischen amphibischer oder luftgestützter Landung und dauerhaftem FOB-Aufbau.

Mögliche Anforderungen:

- reduzierte SAM-Bedrohung
- reduzierte rote CAP
- erfolgreicher Strike gegen Küstenziele
- erste Truppenlieferung
- erste Supply-Lieferung

---

## FOB Alpha

FOB Alpha ist der erste geplante vorgeschobene Stützpunkt.

FOB Alpha soll später entstehen, wenn der Beachhead ausreichend gesichert und versorgt ist.

FOB Alpha kann später ermöglichen:

- nähere Heli-Operationen
- lokale CAS-Missionen
- A-10C-Einsatzräume
- AH-64D-Einsatzräume
- lokale Versorgung
- Verteidigung gegen rote Gegenangriffe
- weitere Inland-Offensive

---

## Rote Logistik

Rot soll ebenfalls Logistik besitzen.

Rot soll nicht nur statisch verteidigen.

Mögliche rote Logistikaktionen:

- Konvoi nach Latakia
- Versorgung von Khmeimim
- Verstärkung von SAM-Stellungen
- Nachschub zu bedrohten Basen
- Gegenangriff gegen Beachhead
- Wiederaufbau beschädigter IADS-Teile

Rote Logistik kann Ziel für Spieler werden.

Missionsarten:

- Convoy Attack
- Interdiction
- Depot Strike
- Bridge Strike optional
- Route Denial

---

## Logistik und Missionsgenerator

Der Missionsgenerator nutzt Logistikdaten.

Beispiele:

Wenn FOB Alpha wenig supply hat:

- CTLD Supply Mission anbieten

Wenn FOB Alpha wenig ammo hat:

- Ammo Delivery Mission anbieten

Wenn roter Konvoi aktiv ist:

- Convoy Attack Mission anbieten

Wenn Akrotiri Supply liefern muss:

- Transport Mission anbieten

Wenn Beachhead bedroht ist:

- CAS oder FOB Defense Mission anbieten

---

## Logistik und Capture

Capture soll später nicht nur davon abhängen, ob Einheiten in einer Zone stehen.

Auch Versorgung soll eine Rolle spielen.

Beispiele:

Eine Basis kann nicht dauerhaft gehalten werden, wenn:

- keine supply vorhanden ist
- keine manpower vorhanden ist
- keine ammo vorhanden ist
- keine Logistikroute aktiv ist

Eine FOB kann nicht ausgebaut werden, wenn:

- Engineer-Team fehlt
- Command fehlt
- Supply fehlt
- Fuel fehlt
- Ammo fehlt

---

## Logistik und IADS

Logistik kann später das IADS beeinflussen.

Beispiele:

Rot kann SAM-Stellungen nur wieder aufbauen, wenn:

- ammo vorhanden ist
- repair vorhanden ist
- command vorhanden ist
- Supply-Route offen ist

Blau kann IADS-Schäden dauerhaft machen, wenn:

- Depots zerstört werden
- Konvois abgefangen werden
- Command Posts zerstört werden
- Nachschubrouten unterbrochen werden

---

## Logistik und KI-Director

Der KI-Director nutzt Logistikdaten für Entscheidungen.

Beispiele:

Wenn Rot zu wenig fuel in Khmeimim hat:

- weniger CAP starten

Wenn Rot Latakia verstärken will:

- Supply-Konvoi starten

Wenn Blau FOB Alpha aufbaut:

- roter Gegenangriff planen

Wenn Beachhead ungeschützt ist:

- rote CAS oder Artillerie simulieren

---

## F10-Logistikmenü

Später soll ein F10-Menü Logistikstatus anzeigen.

Mögliche Einträge:

- Akrotiri Supply Status
- Beachhead Status
- FOB Alpha Status
- aktive Logistikmissionen
- benötigte Ressourcen
- aktive Konvois
- offene Lieferungen

Das Menü soll dem Spieler erklären, warum Logistik wichtig ist.

---

## Persistenz

Das Logistiksystem muss später persistenzfähig sein.

Gespeichert werden sollen:

- Ressourcen pro Basis
- Ressourcen pro FOB
- aktive Logistikhubs
- zerstörte Depots
- aktive Nachschubrouten
- verlorene Konvois
- gelieferte CTLD-Ressourcen
- FOB-Ausbaustufen

Persistenz wird erst später gebaut.

Zuerst müssen CTLD-Grundlogik und Ressourcensystem funktionieren.

---

## Erste Testziele

Der erste technische Test des Logistiksystems soll nur prüfen:

- CTLD lädt korrekt
- Heli-Slot hat CTLD-Menü
- Akrotiri-Pickup-Zone funktioniert
- Kiste kann gespawnt werden
- Kiste kann transportiert werden
- Kiste kann abgesetzt werden
- Theater Command erkennt Lieferung später
- Debug-Ausgabe funktioniert

Noch nicht testen:

- vollständige FOB-Logik
- komplexe Konvois
- Persistenz
- KI-Gegenangriffe
- Warehouse-System
- IADS-Wiederaufbau

---

## Entwicklungsreihenfolge

Empfohlene Reihenfolge:

1. CTLD sauber laden
2. Akrotiri-Pickup-Zonen testen
3. erste Kistentypen definieren
4. erste Drop-Zone definieren
5. Lieferung erkennen
6. Ressource erhöhen
7. Debug-Ausgabe anzeigen
8. FOB Alpha als einfachen Status anlegen
9. FOB-Ausbaustufen vorbereiten
10. Logistikstatus im F10-Menü anzeigen
11. Routenlogik vorbereiten
12. Konvoi-System später ergänzen
13. Persistenz später ergänzen

---

## Was bewusst nicht sofort gebaut wird

Nicht in der ersten Version:

- keine komplexe Economy
- keine automatische Weltlogistik
- keine vollständige Konvoisimulation
- keine perfekte Warehouse-Simulation
- keine vollständige FOB-Baumechanik
- keine Persistenz vor funktionierender Grundlogik
- keine CTLD-Zonen für jede Airbase

---

## Zielbild

Das Logistiksystem soll die Kampagne lebendiger machen.

Erfolge sollen nicht nur durch Bomben entstehen.

Versorgung, Transport, FOB-Aufbau, Nachschub und Ressourcen sollen den Verlauf der Kampagne beeinflussen.

Dadurch bekommt jede Transportmission, jeder Konvoi und jede zerstörte Versorgungsstruktur strategische Bedeutung.
