# AI Director

Diese Datei beschreibt den geplanten AI Director von Theater Command DCS.

Der AI Director ist das System, das die dynamische KI-Aktivität steuert.

Er soll dafür sorgen, dass die Kampagne nicht statisch wirkt, sondern dass rote und blaue KI-Kräfte auf die Lage reagieren.

---

## Ziel

Der AI Director soll aus dem aktuellen Kampagnenzustand sinnvolle KI-Aktionen ableiten.

Er soll später entscheiden:

- wann rote CAP startet
- wann rote GCI startet
- wann rote Strike-Pakete entstehen
- wann rote Konvois fahren
- wann rote Gegenangriffe ausgelöst werden
- wann Blau KI-Unterstützung bekommt
- wann eine Region verstärkt wird
- wann ein IADS-Sektor wieder aufgebaut wird
- wann eine Basis verteidigt oder aufgegeben wird

Der AI Director soll nicht jede einzelne Einheit dauerhaft spawnen.

Er soll lageabhängig entscheiden, welche KI-Aktion gerade sinnvoll ist.

---

## Grundsatz

Die KI soll nicht nur auf den Spieler warten.

Die Welt soll sich selbst bewegen.

Der Spieler ist Teil der Kampagne, aber nicht der einzige Auslöser.

Rote und blaue KI-Aktionen sollen abhängig sein von:

- Basenbesitz
- Ressourcen
- aktiven Regionen
- IADS-Zustand
- Luftüberlegenheit
- Logistikstatus
- Missionsergebnissen
- FOB-Status
- Verlusten
- Kampagnenphase

---

## Geplante Lua-Dateien

Der AI Director liegt im Bereich:

src/ai/

Geplante Dateien:

- tc_ai_director.lua
- tc_ai_cap_manager.lua
- tc_ai_gci_manager.lua
- tc_ai_strike_manager.lua
- tc_ai_cas_manager.lua
- tc_ai_ground_war.lua
- tc_ai_counterattack.lua

---

## tc_ai_director.lua

Diese Datei ist die zentrale Entscheidungslogik.

Aufgaben:

- Kampagnenzustand auswerten
- aktive Regionen prüfen
- Bedrohungslage bewerten
- Ressourcen prüfen
- mögliche KI-Aktionen sammeln
- Prioritäten berechnen
- passende KI-Aktionen auslösen
- Cooldowns verwalten
- Eskalation steuern
- Debug-Ausgaben erzeugen

Mögliche spätere Funktion:

TC.AI.EvaluateSituation()

---

## tc_ai_cap_manager.lua

Diese Datei verwaltet Combat Air Patrols.

Aufgaben:

- CAP-Bedarf erkennen
- geeignete Startbasis wählen
- passende Template-Gruppe auswählen
- CAP-Zone festlegen
- CAP spawnen
- CAP-Lebensdauer verwalten
- CAP-Verluste registrieren
- Ressourcenverbrauch auslösen

Mögliche Auslöser:

- aktive blaue Strike-Mission
- blaue CAP nahe rotem Gebiet
- rote Basis bedroht
- Transportkorridor erkannt
- Kampagnenphase verlangt Luftverteidigung

---

## tc_ai_gci_manager.lua

Diese Datei verwaltet Ground Controlled Intercept.

GCI unterscheidet sich von CAP.

CAP patrouilliert bereits im Gebiet.

GCI startet reaktiv, wenn ein Gegner erkannt wird.

Aufgaben:

- Luftraumverletzung erkennen
- verfügbare rote Basis prüfen
- verfügbares Flugzeugtemplate wählen
- Abfangjäger starten
- Zielgebiet bestimmen
- GCI nach Abschluss entfernen
- Ressourcenverbrauch erfassen

Mögliche Auslöser:

- blauer Spieler nähert sich rotem Gebiet
- blauer Strike fliegt in IADS-Sektor
- Transporthubschrauber wird erkannt
- AWACS meldet Kontakt
- roter IADS-Sektor ist noch aktiv

---

## tc_ai_strike_manager.lua

Diese Datei verwaltet KI-Strike-Aktionen.

Aufgaben:

- lohnende Ziele erkennen
- Strike-Paket zusammenstellen
- Escort-Bedarf prüfen
- Zielregion wählen
- Angriff starten
- Erfolg oder Misserfolg auswerten

Mögliche rote Strike-Ziele:

- Beachhead Alpha
- FOB Alpha
- blaue Konvois
- blaue Logistikhubs
- Akrotiri optional in späterer Eskalation
- Carrier-Gruppe optional

Mögliche blaue KI-Strike-Ziele:

- Radarstellungen
- Depots
- SAM-Stellungen
- rote Konvois
- Kommandoposten

---

## tc_ai_cas_manager.lua

Diese Datei verwaltet KI-CAS-Aktionen.

CAS wird relevant, wenn Bodentruppen aktiv sind oder eine Basis umkämpft ist.

Aufgaben:

- umkämpfte Zone erkennen
- unterstützte Seite bestimmen
- CAS-Paket auswählen
- Zielbereich festlegen
- CAS spawnen
- Einsatzdauer verwalten
- Ergebnis an Kampagnenzustand melden

Mögliche Auslöser:

- Beachhead wird angegriffen
- FOB wird angegriffen
- Basis ist contested
- rote Gegenoffensive läuft
- blaue Bodentruppen greifen an
- Konvoi benötigt Schutz

---

## tc_ai_ground_war.lua

Diese Datei simuliert den Bodenkrieg.

Sie muss nicht jede Bodeneinheit dauerhaft sichtbar darstellen.

Sie kann abstrakt oder teilabstrakt arbeiten.

Aufgaben:

- Bodenlage berechnen
- Frontdruck bestimmen
- Angriffschancen bewerten
- Verteidigungsstärke bewerten
- Capture-System beeinflussen
- CAS-Missionen auslösen
- Gegenangriffe vorbereiten

Mögliche Faktoren:

- manpower
- supply
- ammo
- repair
- lokale Verteidigung
- Luftüberlegenheit
- IADS-Abdeckung
- Logistikroute
- Missionsfortschritt

---

## tc_ai_counterattack.lua

Diese Datei verwaltet Gegenangriffe.

Aufgaben:

- verlorene oder bedrohte Regionen erkennen
- rote Reaktionsfähigkeit prüfen
- Ressourcen prüfen
- Gegenangriff planen
- Bodengruppe oder Konvoi spawnen
- Missionen für Spieler erzeugen
- Erfolg oder Misserfolg auswerten

Mögliche rote Gegenangriffe:

- Angriff auf Beachhead Alpha
- Angriff auf FOB Alpha
- Rückeroberung einer Basis
- Konvoi zur Verstärkung
- Artillerieangriff optional
- Luftangriff auf Logistik

---

## Entscheidungslogik

Der AI Director soll regelmäßig die Lage prüfen.

Möglicher Ablauf:

1. Kampagnenstatus lesen
2. aktive Region bestimmen
3. bedrohte Basen prüfen
4. verfügbare Ressourcen prüfen
5. IADS-Zustand prüfen
6. rote und blaue Luftaktivität prüfen
7. Logistikstatus prüfen
8. mögliche Aktionen sammeln
9. Prioritäten vergeben
10. Cooldowns prüfen
11. Aktion auslösen
12. Ergebnis protokollieren

---

## Prioritäten

Nicht jede KI-Aktion ist gleich wichtig.

Der AI Director soll Prioritäten nutzen.

Mögliche Prioritätsstufen:

- low
- medium
- high
- critical

Beispiele:

FOB Alpha fast ohne Verteidigung:

critical counterattack

Rote Fuel-Ressourcen niedrig:

low CAP frequency

Aktiver blauer Strike gegen Khmeimim:

high GCI response

IADS-Sektor zerstört:

medium rebuild attempt

Beachhead frisch errichtet:

high red counterattack probability

---

## Cooldowns

KI-Aktionen dürfen nicht ununterbrochen gespawnt werden.

Jede Aktion braucht Cooldowns.

Beispiele:

CAP-Cooldown:

- Rot kann nicht alle 2 Minuten neue CAP starten
- Start hängt von fuel, aircraft availability und Basisstatus ab

Counterattack-Cooldown:

- Gegenangriffe brauchen Vorbereitung
- verlorene Angriffe reduzieren Ressourcen

Rebuild-Cooldown:

- IADS-Wiederaufbau dauert
- Ressourcen müssen vorhanden sein

---

## Ressourcenverbrauch

KI-Aktionen sollen Ressourcen verbrauchen.

Beispiele:

CAP kostet:

- fuel
- ammo
- aircraft availability optional

GCI kostet:

- fuel
- ammo
- command

Counterattack kostet:

- manpower
- supply
- ammo
- fuel

IADS-Rebuild kostet:

- repair
- ammo
- supply
- command

Dadurch soll die KI nicht unendlich stark sein.

---

## Rote KI-Logik

Rot soll defensiv stark starten.

Rot besitzt zu Beginn:

- syrische Flugplätze
- IADS
- CAP/GCI
- Bodentruppen
- Depots
- Nachschubrouten
- Kommandostrukturen

Rot soll reagieren auf:

- blaue SEAD-Missionen
- zerstörte Depots
- blaue CTLD-Transporte
- Beachhead-Aufbau
- FOB-Aufbau
- eroberte Basen
- unterbrochene Nachschubrouten

---

## Blaue KI-Logik

Blau kann später unterstützende KI-Aktionen erhalten.

Beispiele:

- KI-CAP zum Schutz von Transporten
- KI-SEAD als Unterstützung
- KI-Strike gegen bekannte Ziele
- KI-Konvoi zu FOB
- KI-CAS bei Bodenangriff
- AWACS und Tanker als Support

Blau soll aber nicht automatisch alles gewinnen.

Spieleraktionen sollen weiterhin wichtig bleiben.

---

## Eskalation

Der AI Director soll Eskalation ermöglichen.

Beispielhafte Eskalationsstufen:

Stufe 1:

- lokale CAP
- begrenzte GCI
- einzelne SAM-Aktivität

Stufe 2:

- stärkere GCI
- mehr CAP
- Konvois
- erste Gegenangriffe

Stufe 3:

- koordinierte Gegenoffensive
- Strike gegen FOB
- IADS-Wiederaufbau
- verstärkte Bodentruppen

Stufe 4:

- größere Luftoperationen
- strategische Angriffe
- mehrere Regionen aktiv

Eskalation hängt von Kampagnenphase und Spielerfortschritt ab.

---

## AI Director und Airbase-System

Der AI Director nutzt Airbase-Daten.

Beispiele:

Wenn Khmeimim rot, aktiv und versorgt ist:

- rote CAP möglich
- rote GCI möglich
- roter Strike möglich

Wenn Latakia beschädigt und unterversorgt ist:

- weniger rote Aktivität
- Konvoi zur Verstärkung möglich

Wenn Akrotiri aktiv ist:

- blaue Missionen starten dort
- Transportflüge beginnen dort
- blaue KI-Unterstützung möglich

Wenn FOB Alpha aktiv ist:

- CAS-Missionen möglich
- rote Gegenangriffe möglich
- Logistikbedarf steigt

---

## AI Director und Logistik

Logistik beeinflusst KI-Aktionen stark.

Beispiele:

Rote Basis ohne fuel:

- weniger CAP
- weniger GCI
- weniger Strike

Rote Basis ohne ammo:

- schwächere Verteidigung
- weniger SAM-Wiederaufbau

Rote Basis ohne supply:

- geringere Durchhaltefähigkeit
- schlechtere Reparatur

Blaues FOB ohne supply:

- weniger Verteidigung
- weniger CAS-Unterstützung
- höheres Risiko bei Gegenangriff

---

## AI Director und IADS

Der AI Director soll mit dem IADS-System verbunden werden.

Beispiele:

IADS-Sektor aktiv:

- rote GCI wahrscheinlicher
- Strike gegen Blau wahrscheinlicher
- blaue SEAD-Missionen wichtiger

IADS-Sektor beschädigt:

- rote CAP weniger effektiv
- rote Reaktion verzögert
- Strike-Korridor öffnet sich

IADS-Sektor zerstört:

- Rot kann Rebuild versuchen
- Rebuild braucht Ressourcen
- Rebuild kann Ziel für Interdiction werden

---

## AI Director und Missionsgenerator

Der AI Director erzeugt Situationen.

Der Missionsgenerator macht daraus Spieleraufgaben.

Beispiele:

AI Director plant rote Gegenoffensive.

Missionsgenerator bietet an:

- CAS
- Convoy Attack
- FOB Defense
- Interdiction

AI Director erkennt rote CAP-Aktivität.

Missionsgenerator bietet an:

- CAP
- Fighter Sweep
- Escort

AI Director erkennt Logistikmangel.

Missionsgenerator bietet an:

- Supply Delivery
- Convoy Escort
- CTLD Transport

---

## Spawn-Prinzip

KI-Gruppen sollen nicht dauerhaft überall stehen.

Stattdessen:

- Templates im Mission Editor vorbereiten
- Late Activation nutzen
- Gruppen per Lua spawnen
- nach Einsatz entfernen oder deaktivieren
- Ergebnis in Kampagnenzustand übernehmen

Das spart Performance und hält die Mission übersichtlich.

---

## Performance

Der AI Director muss performancebewusst arbeiten.

Nicht sinnvoll:

- hunderte aktive Gruppen dauerhaft
- ständige globale Scans jede Sekunde
- zu viele parallele CAPs
- zu viele aktive Konvois
- zu viele Triggerketten

Besser:

- regelmäßige Lagebewertung in Intervallen
- aktive Regionen begrenzen
- Gruppen nur bei Bedarf spawnen
- Cooldowns nutzen
- Debug-System gezielt einsetzen

---

## Erste Testversion

Die erste technische Version des AI Director soll sehr einfach sein.

Testziel:

- AI Director lädt
- Kampagnenstatus wird gelesen
- aktive Region wird erkannt
- einfache Priorität wird berechnet
- eine Test-CAP kann ausgelöst werden
- Debug-Ausgabe erscheint

Noch nicht nötig:

- komplexe Ressourcenlogik
- vollständiger Bodenkrieg
- echte Gegenoffensive
- IADS-Rebuild
- Persistenz
- perfekte Balance

---

## Erste Testaktion

Eine mögliche erste Testaktion:

Wenn Syrian Coast aktiv ist und Rot Khmeimim kontrolliert:

- rote Test-CAP starten
- CAP-Zone vor der syrischen Küste setzen
- Debug-Ausgabe erzeugen
- CAP nach Zeit entfernen

Ziel:

Prüfen, ob AI Director, Template, Spawn und Debug grundsätzlich funktionieren.

---

## Debug-Funktionen

Geplante Debug-Ausgaben:

- aktive Region
- erkannte Bedrohung
- gewählte KI-Aktion
- Priorität
- Cooldown-Status
- Ressourcenprüfung
- gespawnte Gruppe
- Ergebnis der Aktion

Mögliche spätere Funktion:

TC.Debug.PrintAIDirectorStatus()

---

## Entwicklungsreihenfolge

Empfohlene Reihenfolge:

1. AI Director Grunddatei erstellen
2. einfache Evaluate-Funktion bauen
3. aktive Region ausgeben
4. erste Test-Priorität berechnen
5. CAP-Manager vorbereiten
6. erste rote Test-CAP spawnen
7. Cooldown hinzufügen
8. Ressourcenprüfung ergänzen
9. GCI ergänzen
10. Counterattack-System vorbereiten
11. Logistikdaten einbinden
12. IADS-Daten einbinden
13. Missionsgenerator anbinden
14. Persistenz später ergänzen

---

## Was bewusst nicht sofort gebaut wird

Nicht in der ersten Version:

- keine vollständige Kriegs-KI
- keine perfekte Echtzeitstrategie
- keine globale Simulation jeder Einheit
- keine komplette dynamische Front
- keine automatische Balance
- keine endlosen Spawns
- keine Persistenz vor stabiler Grundlogik

Erst muss der AI Director einfache, kontrollierbare Entscheidungen treffen.

---

## Zielbild

Der AI Director soll die Kampagne lebendig machen.

Er soll dafür sorgen, dass Rot und Blau nicht statisch bleiben.

Die Welt soll reagieren, eskalieren, sich anpassen und Druck erzeugen.

Der Spieler soll das Gefühl bekommen, Teil eines größeren dynamischen Krieges zu sein.