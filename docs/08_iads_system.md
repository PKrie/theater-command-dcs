# IADS System

Diese Datei beschreibt das geplante IADS-System von Theater Command DCS.

IADS steht für Integrated Air Defense System. In Theater Command DCS soll das IADS nicht nur eine taktische Luftverteidigung sein, sondern Teil des strategischen Kampagnensystems.

---

## Ziel

Das IADS-System soll die gegnerische Luftverteidigung dynamisch und nachvollziehbar machen.

Es soll später beeinflussen:

- welche Regionen gefährlich sind
- welche Strike-Missionen möglich sind
- welche SEAD- und DEAD-Missionen notwendig sind
- wie stark rote GCI-Reaktionen sind
- ob Transportflüge sicher durchgeführt werden können
- ob ein Beachhead aufgebaut werden kann
- ob Rot beschädigte Luftverteidigung wiederherstellen kann

---

## Grundsatz

Skynet IADS übernimmt die taktische IADS-Logik.

Theater Command übernimmt die strategische Einbindung.

Das bedeutet:

Skynet IADS steuert Radar, SAM-Stellungen und deren taktisches Verhalten.

Theater Command bewertet, was der Zustand eines IADS-Sektors für die Kampagne bedeutet.

---

## Geplante Lua-Dateien

Das IADS-System liegt im Bereich:

src/iads/

Geplante Dateien:

- tc_iads_config.lua
- tc_iads_sector_manager.lua
- tc_iads_damage_handler.lua
- tc_iads_rebuild_system.lua

---

## tc_iads_config.lua

Diese Datei enthält die Grundkonfiguration des IADS-Systems.

Aufgaben:

- Skynet IADS initialisieren
- IADS-Netzwerke definieren
- SAM-Gruppen einbinden
- Radar-Gruppen einbinden
- Command-Elemente einbinden
- Debug-Einstellungen vorbereiten
- IADS-Sektoren an Theater Command melden

---

## tc_iads_sector_manager.lua

Diese Datei verwaltet IADS-Sektoren.

Ein IADS-Sektor ist ein geografischer und strategischer Bereich der Luftverteidigung.

Mögliche erste Sektoren:

- syrian_coast
- khmeimim_sector
- latakia_sector
- tartus_sector
- hama_sector
- homs_sector
- damascus_sector

Ein Sektor kann enthalten:

- Early Warning Radar
- SAM-Stellungen
- SHORAD
- Command Post
- Fuel Depot
- Ammo Depot
- Repair-Fähigkeit
- Verbindung zu einer Airbase
- Verbindung zu einer Region

---

## tc_iads_damage_handler.lua

Diese Datei wertet Schäden am IADS aus.

Aufgaben:

- zerstörte Radare erkennen
- zerstörte SAM-Stellungen erkennen
- zerstörte Command Posts erkennen
- zerstörte Depots erkennen
- Sektorstatus aktualisieren
- Missionsgenerator informieren
- KI-Director informieren
- Kampagnenzustand anpassen

Beispiel:

Ein Radar bei Latakia wird zerstört.

Dann soll Theater Command erkennen:

- IADS-Sektor Latakia ist geschwächt
- SEAD-Erfolg wird registriert
- Strike-Missionen in der Region werden wahrscheinlicher
- Transportflüge werden etwas sicherer
- Rot kann später einen Wiederaufbau versuchen

---

## tc_iads_rebuild_system.lua

Diese Datei verwaltet den Wiederaufbau von IADS-Strukturen.

Rot soll beschädigte Luftverteidigung nicht unbegrenzt und sofort wiederherstellen können.

Ein Wiederaufbau soll Ressourcen brauchen.

Mögliche benötigte Ressourcen:

- supply
- ammo
- repair
- command

Mögliche Bedingungen:

- Basis oder Depot ist noch rot kontrolliert
- Supply-Route ist offen
- Command Post ist nicht zerstört
- genügend repair vorhanden
- genügend ammo vorhanden
- Cooldown ist abgelaufen

---

## IADS-Sektoren

Ein IADS-Sektor beschreibt die Luftverteidigung einer Region.

Mögliche Daten eines Sektors:

- Name
- Region
- Besitzer
- Aktivitätsstatus
- Bedrohungsgrad
- Radarstatus
- SAM-Status
- Command-Status
- Repair-Status
- verbundene Airbase
- verbundene Ziele
- Wiederaufbau-Cooldown

Beispielhafte Struktur:

sector = {
  name = "latakia_sector",
  region = "syrian_coast",
  owner = "red",
  active = true,
  threatLevel = 80,
  radarOperational = true,
  samOperational = true,
  commandOperational = true,
  rebuildCooldown = 0
}

Diese Struktur ist nur ein Planungsbeispiel.

---

## Bedrohungsgrad

Jeder IADS-Sektor soll einen Bedrohungsgrad besitzen.

Mögliche Werte:

- 0 = keine Bedrohung
- 25 = gering
- 50 = mittel
- 75 = hoch
- 100 = extrem

Der Bedrohungsgrad beeinflusst:

- Missionsgenerator
- KI-Director
- Transportfähigkeit
- SEAD-Priorität
- Strike-Risiko
- Beachhead-Fähigkeit

---

## Wirkung auf den Missionsgenerator

Der Missionsgenerator nutzt den IADS-Status.

Beispiele:

IADS-Sektor stark:

- SEAD-Missionen priorisieren
- DEAD-Missionen anbieten
- Strike-Missionen begrenzen
- Transportmissionen einschränken
- Beachhead-Missionen verzögern

IADS-Sektor geschwächt:

- Strike-Missionen öffnen
- Logistikmissionen ermöglichen
- Transportkorridor freigeben
- Beachhead-Aufbau wahrscheinlicher machen

IADS-Sektor zerstört:

- Folgeziele anbieten
- Infrastrukturangriffe ermöglichen
- Ground- und Logistics-Missionen wahrscheinlicher machen

---

## Wirkung auf den AI Director

Der AI Director nutzt den IADS-Status für KI-Entscheidungen.

Beispiele:

Aktiver IADS-Sektor:

- rote GCI wahrscheinlicher
- rote CAP effektiver
- blaue Strike-Missionen riskanter

Geschwächter IADS-Sektor:

- Rot kann CAP erhöhen
- Rot kann Repair-Konvoi starten
- Rot kann SAM-Wiederaufbau versuchen

Zerstörter IADS-Sektor:

- Rot verliert Reaktionsfähigkeit
- Rot versucht eventuell Wiederaufbau
- Blau bekommt operativen Vorteil

---

## Wirkung auf Logistik

IADS und Logistik sollen miteinander verbunden werden.

Ein IADS-Sektor kann nur dauerhaft stark bleiben, wenn Versorgung vorhanden ist.

Beispiele:

Ohne ammo:

- SAM-Wiederaufbau eingeschränkt
- Luftverteidigung schwächer

Ohne repair:

- zerstörte Systeme bleiben zerstört

Ohne command:

- Sektor reagiert langsamer
- GCI wird seltener
- Wiederaufbau verzögert sich

Ohne supply:

- langfristige Einsatzfähigkeit sinkt

---

## Wirkung auf Airbase-System

IADS-Sektoren können mit Airbases verbunden sein.

Beispiele:

Khmeimim kann einen starken IADS-Sektor besitzen.

Latakia kann Teil des Küsten-IADS sein.

Tartus kann einen eigenen Teilsektor haben.

Wenn eine Airbase erobert oder stark beschädigt wird, kann der zugehörige IADS-Sektor geschwächt werden.

Wenn ein IADS-Sektor zerstört ist, kann die dazugehörige Basis leichter angreifbar sein.

---

## SEAD und DEAD

SEAD bedeutet Suppression of Enemy Air Defense.

DEAD bedeutet Destruction of Enemy Air Defense.

In Theater Command sollen beide Missionsarten unterschiedliche Wirkung haben.

SEAD:

- temporäre Unterdrückung
- Radar oder SAM reagiert eingeschränkt
- Sektor wird zeitweise schwächer
- Strike-Fenster entsteht

DEAD:

- dauerhafte oder langfristige Zerstörung
- Sektor verliert echte Fähigkeit
- Wiederaufbau nur mit Ressourcen möglich
- strategischer Kampagnenfortschritt entsteht

---

## Radar

Radarstellungen sind zentrale Elemente eines IADS.

Mögliche Wirkung bei Zerstörung:

- geringere Erkennungsreichweite
- weniger GCI-Reaktionen
- schwächere SAM-Koordination
- niedrigere Bedrohungsstufe
- neue Strike-Möglichkeiten

Radarziele eignen sich besonders für:

- SEAD
- DEAD
- Strike
- Recon

---

## SAM-Stellungen

SAM-Stellungen erzeugen die eigentliche Flugabwehrbedrohung.

Mögliche Wirkung bei Zerstörung:

- sicherere Strike-Korridore
- sicherere Transportflüge
- geringeres Risiko für CAS
- bessere Chancen für Beachhead-Aufbau
- weniger Schutz für rote Basen

SAM-Ziele eignen sich für:

- SEAD
- DEAD
- Escort Strike
- DEAD Package

---

## Command Posts

Command Posts bilden die Führungsstruktur des IADS.

Mögliche Wirkung bei Zerstörung:

- langsamere rote Reaktion
- geringere Koordination
- weniger GCI
- langsamerer Wiederaufbau
- schwächere Gegenoffensive

Command Posts eignen sich für:

- Precision Strike
- Deep Strike
- F-15E Missionen
- F/A-18C oder F-16C Strike

---

## Depots

Depots versorgen das IADS indirekt.

Mögliche Depot-Typen:

- Fuel Depot
- Ammo Depot
- Repair Depot
- Command Facility
- Warehouse

Wirkung:

Fuel Depot zerstört:

- weniger CAP
- weniger GCI
- weniger Strike

Ammo Depot zerstört:

- weniger SAM-Rearm
- schwächere Verteidigung
- weniger Artillerie optional

Repair Depot zerstört:

- langsamerer Wiederaufbau
- beschädigte Systeme bleiben länger aus

---

## IADS und Kampagnenphasen

Das IADS spielt besonders in den frühen Phasen eine große Rolle.

Phase 1:

- Luftraum erkunden
- CAP und GCI bekämpfen
- IADS-Lage verstehen

Phase 2:

- SEAD
- DEAD
- Radarbekämpfung
- SAM-Schwächung

Phase 3:

- Strike gegen Depots und Command Posts
- IADS weiter schwächen

Phase 4:

- Beachhead erst möglich, wenn IADS ausreichend geschwächt ist

Phase 5 und später:

- IADS-Wiederaufbau verhindern
- neue Sektoren bekämpfen
- Logistik gegen IADS-Rebuild unterbrechen

---

## IADS und Persistenz

Der IADS-Zustand muss später persistent gespeichert werden.

Gespeichert werden sollen:

- aktive Sektoren
- zerstörte Radare
- zerstörte SAM-Stellungen
- zerstörte Command Posts
- zerstörte Depots
- Bedrohungsgrad
- Wiederaufbau-Cooldowns
- Ressourcenstatus
- letzte bekannte Angriffe

Persistenz kommt später.

Zuerst muss das IADS einfach und stabil mit Theater Command verbunden werden.

---

## Erste Testversion

Die erste technische Testversion soll einfach bleiben.

Testziele:

- Skynet IADS lädt
- ein Test-IADS wird erstellt
- eine Radargruppe wird eingebunden
- eine SAM-Gruppe wird eingebunden
- Debug-Ausgabe funktioniert
- Theater Command erkennt den Sektor
- Sektorstatus kann angezeigt werden

Noch nicht nötig:

- vollständige Syria-IADS-Struktur
- komplexer Wiederaufbau
- Persistenz
- perfekte SEAD-Auswertung
- vollständige KI-Verknüpfung

---

## Erste Testregion

Für den ersten Test eignet sich:

Syrian Coast

Mögliche erste Testobjekte:

- ein Radar bei Latakia
- eine SAM-Stellung nahe Latakia
- ein Command Post
- ein Fuel Depot
- ein Ammo Depot

Ziel ist nicht Realismus, sondern technische Funktion.

---

## Debug-Funktionen

Geplante Debug-Ausgaben:

- aktive IADS-Sektoren
- Bedrohungsgrad pro Sektor
- Radarstatus
- SAM-Status
- Command-Status
- beschädigte Objekte
- Wiederaufbau-Cooldown
- Verknüpfung zur Region
- Verknüpfung zur Airbase

Mögliche spätere Funktion:

TC.Debug.PrintIADSStatus()

---

## Entwicklungsreihenfolge

Empfohlene Reihenfolge:

1. Skynet IADS sauber laden
2. tc_iads_config.lua vorbereiten
3. ersten Testsektor definieren
4. Radar und SAM einbinden
5. Theater-Command-Sektorobjekt anlegen
6. Bedrohungsgrad berechnen
7. Debug-Ausgabe bauen
8. Missionsgenerator mit IADS-Status verbinden
9. Damage Handler vorbereiten
10. Rebuild-System später ergänzen
11. Persistenz später ergänzen

---

## Was bewusst nicht sofort gebaut wird

Nicht in der ersten Version:

- keine vollständige realistische Syria-IADS
- keine perfekte SAM-Doctrine
- keine komplette SEAD-KI
- kein sofortiger Wiederaufbau
- keine vollständige Persistenz
- keine komplette Kopplung an alle Basen
- keine komplexe Ressourcenberechnung

Erst muss ein kleiner IADS-Sektor sauber funktionieren.

---

## Zielbild

Das IADS-System soll die Kampagne taktisch und strategisch anspruchsvoller machen.

Luftverteidigung soll nicht nur ein einzelnes Ziel sein.

Sie soll ein System sein, das aufgeklärt, unterdrückt, zerstört, umgangen und dauerhaft geschwächt werden kann.

Erst wenn das IADS ausreichend geschwächt ist, kann Blau sicher tiefer in den Kampagnenraum eindringen.