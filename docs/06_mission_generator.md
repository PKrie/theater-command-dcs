# Mission Generator

Diese Datei beschreibt den geplanten dynamischen Missionsgenerator von Theater Command DCS.

Der Missionsgenerator ist das System, das aus dem aktuellen Kampagnenzustand sinnvolle Missionen für den Spieler erzeugt.

---

## Ziel

Der Spieler soll nicht einfach eine feste Liste statischer Missionen bekommen.

Stattdessen soll Theater Command prüfen:

- welches Flugzeug der Spieler nutzt
- welche Region aktiv ist
- welche Basen verfügbar sind
- welche Ziele noch existieren
- wie stark das gegnerische IADS ist
- wie stark rote CAP und GCI sind
- welche Ressourcen fehlen
- welche FOBs aktiv sind
- welche Kampagnenphase läuft
- welche Mission taktisch sinnvoll ist

Aus diesen Informationen sollen passende Missionen angeboten werden.

---

## Grundsatz

Missionen entstehen aus der Lage.

Nicht jede Mission ist immer verfügbar.

Nicht jedes Flugzeug bekommt jede Mission.

Nicht jede Region ist immer aktiv.

Der Missionsgenerator soll den Spieler in eine dynamische Kampagne einbinden.

---

## Geplante Lua-Dateien

Der Missionsgenerator liegt im Bereich:

src/missions/

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

---

## tc_mission_generator.lua

Diese Datei ist die zentrale Steuerdatei für Missionen.

Aufgaben:

- aktuellen Spieler erkennen
- Flugzeugtyp erkennen
- Kampagnenzustand abfragen
- mögliche Missionen sammeln
- Missionen filtern
- Missionen gewichten
- Missionen im F10-Menü anzeigen
- ausgewählte Mission aktivieren
- Erfolg oder Misserfolg auswerten

Mögliche spätere Funktion:

TC.Missions.GenerateForPlayer()

---

## tc_mission_filter_by_aircraft.lua

Diese Datei entscheidet, welche Missionen zu welchem Flugzeug passen.

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
- Escort

F-15E:

- Deep Strike
- Heavy Strike
- Runway Attack
- Depot Attack
- Command Post Strike

F-14B:

- CAP
- Intercept
- Fleet Defense
- Escort
- Long Range Patrol
- Strike optional

A-10C II:

- CAS
- Armed Recon
- Convoy Attack
- FOB Defense
- Ground Support

AH-64D:

- Armed Recon
- CAS
- Anti-Armor
- FOB Defense
- Deep Attack im begrenzten Raum

UH-1H und Mi-8:

- CTLD Transport
- Troop Insertion
- Cargo Delivery
- FOB Aufbau
- Supply Delivery
- Medevac optional
- CSAR optional

---

## Missionskategorien

Geplante Hauptkategorien:

- Air Superiority
- SEAD / DEAD
- Strike
- CAS
- Logistics
- Recon
- CSAR
- Interdiction
- Escort
- FOB Defense
- Airbase Capture Support
- Convoy Attack
- Naval Strike optional

---

## Air Superiority Missionen

Air Superiority Missionen dienen dazu, Lufthoheit herzustellen oder zu erhalten.

Mögliche Missionstypen:

- CAP
- Fighter Sweep
- Intercept
- Escort
- AWACS Protection
- Tanker Protection

Geeignete Flugzeuge:

- F/A-18C
- F-16C
- F-14B
- F-15E eingeschränkt

Mögliche Auslöser:

- rote CAP aktiv
- rote GCI verfügbar
- eigener Strike benötigt Escort
- Transportkorridor bedroht
- Beachhead benötigt Schutz

Mögliche Wirkung:

- rote Luftaktivität sinkt
- Strike-Missionen werden sicherer
- CTLD-Flüge werden sicherer
- blaue Operationsfreiheit steigt

---

## SEAD / DEAD Missionen

SEAD und DEAD Missionen bekämpfen gegnerische Luftverteidigung.

Mögliche Missionstypen:

- Radar Suppression
- SAM Site Attack
- IADS Node Attack
- Command Post Strike
- DEAD Package
- Escort Jammer optional

Geeignete Flugzeuge:

- F/A-18C
- F-16C
- F-15E eingeschränkt
- F-14B eingeschränkt

Mögliche Auslöser:

- aktiver IADS-Sektor
- hohe SAM-Bedrohung
- Strike-Korridor blockiert
- Transportflüge zu gefährlich
- Beachhead kann nicht aufgebaut werden

Mögliche Wirkung:

- IADS-Sektor wird geschwächt
- Radar-Abdeckung sinkt
- SAM-Reaktionsfähigkeit sinkt
- Strike- und Transportmissionen werden wahrscheinlicher

---

## Strike Missionen

Strike Missionen greifen strategische Ziele an.

Mögliche Zieltypen:

- Fuel Depot
- Ammo Depot
- Command Post
- Radar Site
- Naval Depot
- Runway
- Warehouse
- Bridge optional
- Supply Hub

Geeignete Flugzeuge:

- F/A-18C
- F-16C
- F-15E
- F-14B eingeschränkt

Mögliche Wirkung:

Fuel Depot zerstört:

- weniger rote CAP
- weniger rote GCI
- weniger Strike-Aktivität

Ammo Depot zerstört:

- schwächere SAM-Wiederbewaffnung
- schwächere Bodenverteidigung

Command Post zerstört:

- langsamere rote Reaktion
- schwächere Gegenoffensive

Runway beschädigt:

- weniger Flugaktivität an dieser Basis

---

## CAS Missionen

CAS Missionen unterstützen Bodentruppen oder verteidigen FOBs.

Mögliche Missionstypen:

- Close Air Support
- Armed Recon
- Troops in Contact
- FOB Defense
- Beachhead Defense
- Airbase Capture Support
- Convoy Protection

Geeignete Flugzeuge:

- A-10C II
- AH-64D
- F/A-18C eingeschränkt
- F-16C eingeschränkt
- F-15E eingeschränkt

Mögliche Auslöser:

- FOB bedroht
- Beachhead bedroht
- blaue Bodentruppen greifen an
- rote Gegenoffensive aktiv
- Konvoi benötigt Schutz
- Basis wird umkämpft

Mögliche Wirkung:

- Capture-Fortschritt steigt
- FOB bleibt aktiv
- rote Bodentruppen werden geschwächt
- Logistikroute bleibt offen

---

## Logistics Missionen

Logistikmissionen versorgen Basen, FOBs und Beachheads.

Mögliche Missionstypen:

- CTLD Supply Delivery
- Troop Transport
- Engineer Delivery
- Ammo Delivery
- Fuel Delivery
- Medical Delivery
- Command Delivery
- FOB Construction

Geeignete Flugzeuge:

- UH-1H
- Mi-8
- CH-47 später möglich
- C-130 Mod optional, falls genutzt

Mögliche Auslöser:

- FOB benötigt supply
- FOB benötigt fuel
- FOB benötigt ammo
- Beachhead braucht Truppen
- Basis ist unterversorgt
- Capture benötigt manpower
- beschädigte Basis braucht repair

Mögliche Wirkung:

- Ressourcen steigen
- FOB-Ausbau schreitet voran
- neue Missionen werden freigeschaltet
- CAS-Räume werden näher
- A-10C und AH-64D werden sinnvoll einsetzbar

---

## CSAR Missionen

CSAR Missionen dienen der Rettung abgeschossener Piloten.

CSAR ist optional, kann aber später die Kampagne lebendiger machen.

Mögliche Auslöser:

- Spieler abgeschossen
- KI-Pilot abgeschossen
- wichtiger Pilot muss gerettet werden
- feindliches Gebiet

Geeignete Flugzeuge:

- UH-1H
- Mi-8
- AH-64D als Eskorte optional

Mögliche Wirkung:

- Moral oder manpower steigt
- Verlust wird reduziert
- Zusatzmission entsteht
- Logistik- und Helirollen bekommen mehr Bedeutung

---

## Recon Missionen

Recon Missionen dienen der Aufklärung.

Mögliche Aufgaben:

- Zielgebiet aufklären
- SAM-Standort bestätigen
- Konvoi finden
- FOB-Zone erkunden
- Airbase-Verteidigung prüfen
- IADS-Sektor bewerten

Geeignete Flugzeuge:

- F/A-18C
- F-16C
- F-14B
- AH-64D
- UH-1H eingeschränkt

Mögliche Wirkung:

- Ziele werden im Missionsgenerator freigeschaltet
- Genauigkeit von Strike-Missionen steigt
- IADS-Lage wird klarer
- versteckte Konvois werden sichtbar

---

## Interdiction Missionen

Interdiction Missionen greifen Nachschub und Bewegungen des Gegners an.

Mögliche Ziele:

- Supply Convoy
- Fuel Convoy
- Ammo Convoy
- Reinforcement Convoy
- Counterattack Force
- Bridge optional
- Road Junction optional

Geeignete Flugzeuge:

- F/A-18C
- F-16C
- F-15E
- A-10C II
- AH-64D

Mögliche Wirkung:

- rote Versorgung sinkt
- Gegenangriffe werden schwächer
- Basen können schlechter gehalten werden
- IADS-Wiederaufbau wird erschwert

---

## Dynamische Missionsauswahl

Der Missionsgenerator soll später mehrere Prüfungen durchführen.

Beispiellogik:

1. Spielergruppe erkennen
2. Flugzeugtyp bestimmen
3. aktive Region bestimmen
4. verfügbare Ziele prüfen
5. Bedrohungslage prüfen
6. passende Missionsarten bestimmen
7. unpassende Missionen entfernen
8. Priorität berechnen
9. Mission im F10-Menü anzeigen
10. Mission bei Auswahl aktivieren

---

## Missionspriorität

Missionen sollen eine Priorität erhalten.

Mögliche Prioritätsfaktoren:

- strategische Bedeutung des Ziels
- aktuelle Kampagnenphase
- Bedrohung für eigene Basen
- Ressourcenmangel
- IADS-Stärke
- rote Luftaktivität
- Nähe zu aktiver Front
- Verfügbarkeit passender Flugzeuge
- aktuelle Spielerposition
- offene Logistikanforderungen

Beispiel:

Wenn FOB Alpha kaum ammo hat, erhält eine Ammo-Delivery-Mission hohe Priorität.

Wenn Latakia-Radar noch aktiv ist, erhält SEAD hohe Priorität.

Wenn rote CAP Transportflüge bedroht, erhält CAP hohe Priorität.

---

## F10-Missionsmenü

Missionen sollen später über F10 angeboten werden.

Mögliche Menüstruktur:

Theater Command
- Campaign Status
- Available Missions
- Logistics Status
- Request Mission
- Debug optional

Unter Available Missions:

- Air Superiority
- SEAD / DEAD
- Strike
- CAS
- Logistics
- Recon
- CSAR

Der Spieler soll nur Missionen sehen, die zu seinem Flugzeug und zur Lage passen.

---

## Missionsstatus

Jede Mission braucht einen Status.

Mögliche Statuswerte:

- available
- selected
- active
- completed
- failed
- expired
- cancelled

Bedeutung:

available = Mission wird angeboten  
selected = Spieler hat Mission ausgewählt  
active = Mission läuft  
completed = Mission erfolgreich  
failed = Mission fehlgeschlagen  
expired = Mission zeitlich abgelaufen  
cancelled = Mission wurde abgebrochen  

---

## Missionsdaten

Eine Mission soll später interne Daten besitzen.

Mögliche Struktur:

mission = {
  id = "MISSION_BLUE_SEAD_SYRIAN_COAST_01",
  type = "SEAD",
  region = "syrian_coast",
  target = "STATIC_RED_LATAKIA_RADAR_01",
  requiredAircraft = { "FA18C", "F16C" },
  status = "available",
  priority = 80
}

Diese Struktur ist nur ein Planungsbeispiel.

Die genaue Lua-Umsetzung erfolgt später.

---

## Erfolgsauswertung

Eine Mission muss später auswerten können, ob sie erfolgreich war.

Mögliche Kriterien:

- Ziel zerstört
- Einheit in Zone angekommen
- Kiste geliefert
- Konvoi zerstört
- Zeitlimit eingehalten
- Spieler überlebt optional
- rote Einheit vertrieben
- FOB verteidigt

Beispiele:

SEAD erfolgreich:

- Radar zerstört
- IADS-Sektor geschwächt
- neue Strike-Missionen möglich

Logistik erfolgreich:

- FOB erhält supply
- FOB-Level steigt
- neue CAS-Missionen möglich

CAS erfolgreich:

- rote Bodentruppen reduziert
- Capture-Fortschritt steigt
- FOB bleibt aktiv

---

## Misserfolg

Misserfolg soll ebenfalls Auswirkungen haben.

Beispiele:

Transportmission fehlgeschlagen:

- FOB bleibt unterversorgt
- Gegenangriff wird gefährlicher

SEAD fehlgeschlagen:

- IADS bleibt aktiv
- Strike-Missionen bleiben riskant

CAS fehlgeschlagen:

- Beachhead kann fallen
- rote Bodentruppen gewinnen Einfluss

Strike fehlgeschlagen:

- rote Ressourcen bleiben hoch
- rote CAP bleibt aktiv

---

## Zeitlimits

Einige Missionen können Zeitlimits haben.

Beispiele:

- Konvoi erreicht Ziel in 30 Minuten
- FOB wird in 20 Minuten angegriffen
- Transport muss innerhalb von 45 Minuten liefern
- CAP muss für 25 Minuten gehalten werden

Nicht jede Mission braucht ein Zeitlimit.

Zeitlimits sollen sparsam und sinnvoll genutzt werden.

---

## Missionen und Kampagnenphasen

Missionen hängen von der Kampagnenphase ab.

Phase 1:

- CAP
- Fighter Sweep
- Escort

Phase 2:

- SEAD
- DEAD
- Radar Strike

Phase 3:

- Depot Strike
- Runway Attack
- Infrastructure Strike

Phase 4:

- Beachhead Support
- Transport
- CAS

Phase 5:

- FOB Supply
- FOB Defense
- Engineer Delivery

Phase 6:

- Inland CAS
- Airbase Capture Support
- Interdiction

Phase 7:

- Counteroffensive Defense
- Convoy Attack
- Emergency CAS

---

## Missionen und Airbase-System

Der Missionsgenerator nutzt Airbase-Daten.

Beispiele:

Wenn Khmeimim rot und aktiv ist:

- CAP gegen Khmeimim
- Strike gegen Khmeimim Fuel Depot
- SEAD gegen Khmeimim IADS
- Runway Attack

Wenn Akrotiri blau und aktiv ist:

- Startpunkt für blaue Missionen
- Logistikhub
- CAP-Ausgangspunkt
- CTLD-Ausgangspunkt

Wenn FOB Alpha aktiv ist:

- CAS nahe der Front
- AH-64D-Missionen
- A-10C-Missionen
- FOB Defense

---

## Missionen und Logistik

Der Missionsgenerator nutzt Logistikdaten.

Beispiele:

FOB Alpha supply niedrig:

- Supply Delivery Mission

FOB Alpha ammo niedrig:

- Ammo Delivery Mission

Akrotiri supply hoch:

- Transportmission verfügbar

Rote Nachschubroute aktiv:

- Interdiction Mission

Roter Konvoi unterwegs:

- Convoy Attack Mission

---

## Missionen und IADS

Der Missionsgenerator nutzt IADS-Daten.

Beispiele:

IADS stark:

- SEAD priorisieren
- Strike-Missionen einschränken
- Transportflüge gefährlicher machen

IADS geschwächt:

- Strike-Missionen öffnen
- Transportflüge ermöglichen
- Beachhead-Aufbau wahrscheinlicher machen

Radar zerstört:

- betroffener Sektor weniger gefährlich

SAM wieder aufgebaut:

- neue SEAD-Mission anbieten

---

## Missionen und KI-Director

Der Missionsgenerator und der KI-Director müssen zusammenarbeiten.

Beispiele:

KI-Director erkennt rote Gegenoffensive.

Missionsgenerator bietet an:

- CAS
- Interdiction
- FOB Defense
- Convoy Attack

KI-Director erkennt rote CAP-Aktivität.

Missionsgenerator bietet an:

- CAP
- Fighter Sweep
- Escort

KI-Director erkennt Logistikbedarf.

Missionsgenerator bietet an:

- CTLD Supply
- Convoy Escort
- Transport

---

## Erste Testversion

Die erste technische Version des Missionsgenerators soll sehr einfach sein.

Testziel:

- Spielerflugzeug erkennen
- Flugzeugtyp ausgeben
- drei passende Testmissionen anzeigen
- F10-Menü erzeugen
- Auswahl ermöglichen
- Debug-Ausgabe erzeugen

Noch nicht nötig:

- echte Zielzerstörung
- komplexe Priorisierung
- Persistenz
- vollständiger Kampagnenzustand
- KI-Reaktion

---

## Erste Testmissionen

Für den ersten Test reichen einfache Missionen.

Beispiele:

Für F/A-18C:

- Test CAP Eastern Mediterranean
- Test SEAD Syrian Coast
- Test Strike Latakia Radar

Für UH-1H oder Mi-8:

- Test Supply Delivery Akrotiri to Beachhead
- Test Troop Transport
- Test FOB Alpha Delivery

Für A-10C später:

- Test CAS Beachhead
- Test Convoy Attack
- Test FOB Defense

---

## Debug-Funktionen

Geplante Debug-Ausgaben:

- erkannter Spielername
- erkannte Gruppe
- erkanntes Flugzeug
- verfügbare Missionsarten
- generierte Missionen
- gewählte Mission
- Missionsstatus
- Erfolg oder Misserfolg

Mögliche spätere Funktion:

TC.Debug.PrintAvailableMissions()

---

## Entwicklungsreihenfolge

Empfohlene Reihenfolge:

1. Spielergruppe erkennen
2. Flugzeugtyp erkennen
3. einfache Flugzeugfilter bauen
4. erste statische Testmissionen definieren
5. F10-Missionsmenü bauen
6. Mission auswählen lassen
7. Mission als aktiv markieren
8. einfache Erfolgsauswertung bauen
9. Missionsergebnis im Log ausgeben
10. Missionsergebnis später mit Kampagnenzustand verbinden

---

## Was bewusst nicht sofort gebaut wird

Nicht in der ersten Version:

- keine perfekte KI-Kampagnenlogik
- keine vollständige Missionsdatenbank
- keine komplette Zielauswertung
- keine Persistenz
- keine dynamische Frontlinie
- keine komplexe Priorisierung
- keine automatische Balance

Erst muss der Missionsgenerator einfach und zuverlässig funktionieren.

---

## Zielbild

Der Missionsgenerator soll später das zentrale Bindeglied zwischen Spieler, Kampagnenzustand und dynamischer Welt werden.

Er soll dafür sorgen, dass der Spieler nicht zufällige Aufgaben bekommt, sondern sinnvolle Missionen aus der aktuellen Lage.

Die Kampagne soll dadurch reaktiv, lebendig und nachvollziehbar wirken.