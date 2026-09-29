# CTLD-Startzonen – Operation Levant Reclamation

## 1. Zweck und Status

Stand: 2026-09-29

Dieses Dokument beschreibt die Benennung, Mission-Editor-Grundlage und die praktisch bestätigte CTLD-Konfigurationsstrategie für die erste CTLD-Integration von Theater Command DCS.

Verbindlicher operativer Projektstand: `TASKS.md`.

CTLD 1.6.1 ist als unverändertes Vendor-Framework geladen.

Die Theater-Command-Integration verändert keine Dateien unter `vendor/`.

Bestätigt ist inzwischen:

- CTLD-Pickup-Zonen können nach der automatischen CTLD-Initialisierung durch bereits normalisierte Einträge in der Live-Tabelle `ctld.pickupZones` ergänzt werden.
- CTLD-Dropoff-Zonen können entsprechend über `ctld.dropOffZones` ergänzt werden.
- `ctld.initialize()` muss und darf dafür nicht erneut ausgeführt werden.
- CTLD liest die nachträglich ergänzten Zonen im laufenden Betrieb.
- Ein CTLD-KI-Transporter muss zusätzlich über seinen exakten Unit-Namen in `ctld.transportPilotNames` registriert sein, damit `ctld.checkAIStatus()` ihn verarbeitet.
- Ein kompletter KI-Transportzyklus aus automatischem Pickup, Flug, Off-Airfield-Landung und automatischem Dropoff wurde am 2026-09-29 praktisch bestätigt.
- Ein DCS-native Perform Task `Land` an einem normalen Turning-Point-Wegpunkt funktioniert für die getestete Mi-8 als Off-Airfield-Landeverfahren.
- Der bekannte CTLD-Fehler `RepackCommandsPath` tritt beim Grounded-Übergang eines solchen KI-Transporters auf und muss vor einer produktiven Integration berücksichtigt werden.

Noch nicht vorhanden ist eine produktive Theater-Command-Lua-Brücke, die diese Runtime-Konfiguration automatisch erzeugt.

---

## 2. DEV-Mission und Testableitungen

Produktive Entwicklungsmission:

`C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_DEV.miz`

Die DEV-Mission bleibt der technische Haupt-Testträger des Projekts.

Für die CTLD-KI-Transporttests wurden bewusst separate Testmissionen verwendet, damit die DEV-Mission nicht unnötig verändert wird.

Erfolgreicher Teststand vom 2026-09-29:

`C:\Users\Paul\Saved Games\DCS.openbeta\Missions\Operation_Levant_Reclamation_CTLD_LANDTASK_TEST.miz`

SHA-256 vor dem Runtime-Test:

`5F0D89DF744A7083401E36713B148BD21813FF187CC36EC1F088507163458C57`

Die produktive Persistence wurde während des Tests schreibgeschützt und blieb byte-identisch unverändert.

Bestätigte produktive Save-Datei:

`C:\Users\Paul\Saved Games\DCS.openbeta\TheaterCommandDCS\operation_levant_reclamation_save.lua`

Bestätigter SHA-256 vor und nach dem Test:

`C679B4FFE61A7AB601D50E159A057DCDF540B55C620086402883CA2DA27F2596`

Dateigröße:

`3094967` Bytes

Änderungszeit:

`2026-09-21 15:00:00.5926451`

Nach Abschluss des Tests wurde der temporäre Schreibschutz erst nach beendetem DCS und erfolgreicher Hash-Prüfung wieder aufgehoben.

---

## 3. Verbindliche CTLD-Zonennamen

Für Theater-Command-CTLD-Zonen gilt `NAMING_CONVENTIONS.md`.

Es werden keine abweichenden Namen nur deshalb eingeführt, weil sie in den CTLD-Vendor-Defaults vorkommen.

### Pickup-Zone Akrotiri

Verbindlicher Name:

`CTLD_PICKUP_BLUE_AKROTIRI_01`

Schema:

`CTLD_PICKUP_SIDE_LOCATION_NUMBER`

Diese Zone wurde inzwischen praktisch verwendet und ist nicht mehr nur ein Planungsname.

Bestätigte Eigenschaften des Teststands:

- Position im Bereich Akrotiri H1–H4
- Radius: `250 m`
- Blue
- erfolgreicher automatischer CTLD-KI-Pickup praktisch bestätigt

Im erfolgreichen Test nahm die Mi-8 innerhalb dieser Zone automatisch 16 CTLD-Soldaten auf.

Der Pickup-Zähler änderte sich dabei von:

`10000`

auf:

`9999`

### Reservierter späterer Ercan-Dropoff

Reservierter Name:

`CTLD_DROPOFF_BLUE_ERCAN_FOB_01`

Schema:

`CTLD_DROPOFF_SIDE_LOCATION_ROLE_NUMBER`

Dieser Name bleibt für eine mögliche spätere KI-Transportoperation im Zusammenhang mit dem FOB-Projekt Ercan reserviert.

Er ist weiterhin nicht als produktive FOB-Versorgung implementiert.

Die Rolle `FOB` beschreibt nur den vorgesehenen Kampagnenzweck.

### Technische Test-Dropoff-Zone

Für den isolierten KI-Transporttest wurde verwendet:

`CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01`

Bestätigte Eigenschaften:

- Mittelpunkt:
  - x/North: `-29249.110954281`
  - y/East bzw. DCS-z: `-271836.070539260`
- Radius: `60 m`
- Blue
- Off-Airfield-Gelände westlich von Akrotiri

Diese Zone ist ausdrücklich eine technische Testzone und kein produktiver Kampagnen-Dropoff.

---

## 4. Verhältnis zu älteren Namensvorschlägen

Ältere Dokumentationsstände enthielten unter anderem:

- `CTLD_PICKUP_BLUE_AKROTIRI`
- `CTLD_DROPOFF_FOB_ERCAN`

Diese Namen sind nicht mehr verbindlich.

Verbindlich beziehungsweise aktuell verwendet sind:

- `CTLD_PICKUP_BLUE_AKROTIRI_01`
- `CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01` für den technischen Test
- `CTLD_DROPOFF_BLUE_ERCAN_FOB_01` als reservierter späterer Ercan-Name

---

## 5. CTLD-Zonenregistrierung

Die unveränderte Vendor-Datei `vendor/ctld/CTLD.lua` enthält eigene Pickup- und Dropoff-Zonenlisten mit Default-Namen wie:

- `pickzone1`
- `dropzone1`

Theater-Command-Zonen werden dadurch nicht automatisch erkannt.

### Bestätigte technische Strategie

CTLD 1.6.1 initialisiert sich beim Laden selbst.

Nach dieser Initialisierung können bereits normalisierte Einträge direkt in die Live-Tabellen ergänzt werden:

`ctld.pickupZones`

und:

`ctld.dropOffZones`

Die frühere, ausschließlich aus dem Quelltext abgeleitete Annahme wurde inzwischen praktisch bestätigt.

Eine erneute Ausführung von:

`ctld.initialize()`

ist dafür weder notwendig noch zulässig.

Eine erneute Initialisierung würde zusätzliche CTLD-interne Zustände verändern beziehungsweise zurücksetzen und ist nicht Teil der Theater-Command-Konfigurationsstrategie.

### Erfolgreich getesteter Pickup-Eintrag

Im Runtime-Test wurde ergänzt:

`{ "CTLD_PICKUP_BLUE_AKROTIRI_01", -1, 10000, 1, 2 }`

Der Eintrag wurde anschließend aus der Live-Tabelle zurückgelesen und exakt bestätigt.

CTLD verwendete die Zone anschließend erfolgreich für den automatischen KI-Pickup.

### Erfolgreich getesteter Dropoff-Eintrag

Im Runtime-Test wurde ergänzt:

`{ "CTLD_DROPOFF_BLUE_AKROTIRIWEST_TEST_01", -1, 2, 1 }`

Auch dieser Eintrag wurde aus der Live-Tabelle zurückgelesen und exakt bestätigt.

CTLD verwendete die Zone anschließend erfolgreich für den automatischen KI-Dropoff.

### Regeln für die spätere Theater-Command-Implementierung

Eine spätere eigene TC-Integration muss mindestens:

1. prüfen, ob `ctld` geladen und initialisiert ist,
2. vorhandene Einträge prüfen,
3. fehlende Theater-Command-Pickup-Zonen idempotent ergänzen,
4. fehlende Theater-Command-Dropoff-Zonen idempotent ergänzen,
5. bereits normalisierte Werte verwenden,
6. Duplikate verhindern,
7. `ctld.initialize()` nicht erneut aufrufen,
8. keine Vendor-Datei verändern.

---

## 6. KI-Transporter-Registrierung

Der Test vom 2026-09-29 hat eine zusätzliche CTLD-Voraussetzung praktisch bestätigt.

`ctld.checkAIStatus()` verarbeitet KI-Transporter nicht allein deshalb, weil sie sich innerhalb einer Pickup- oder Dropoff-Zone befinden.

Die Unit muss über ihren exakten Unit-Namen in:

`ctld.transportPilotNames`

enthalten sein.

Getestete Unit:

`TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01`

Vor der temporären Registrierung:

- `ctld.transportPilotNames`: `108` Einträge
- getestete Mi-8: nicht enthalten

Temporär ergänzt wurde:

`table.insert(ctld.transportPilotNames, "TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01")`

Nach der Registrierung:

- `109` Einträge
- getestete Mi-8 an Index `109`
- genau ein Vorkommen
- kein Duplikat

Vor Aktivierung war die Unit zwar vorhanden, aber nicht aktiv.

Nach Aktivierung wurde das von `ctld.getTransportUnit()` verwendete Active-/Life-Gate erfüllt.

Damit konnte `ctld.checkAIStatus()` die Unit verarbeiten.

### Konsequenz für Theater Command

Eine spätere produktive CTLD-KI-Transportintegration muss ihre vorgesehenen Transport-Units automatisch und idempotent in `ctld.transportPilotNames` registrieren.

Das darf nicht davon abhängen, dass ein Theater-Command-Unit-Name zufällig bereits in der CTLD-Vendor-Default-Liste vorkommt.

Die Registrierung ist Konfiguration des CTLD-KI-Erkennungspfads.

Sie ist keine direkte Manipulation des CTLD-Bordzustands und löst selbst weder Pickup noch Dropoff aus.

---

## 7. Bestätigter KI-Pickup

Am 2026-09-29 wurde der automatische CTLD-Pickup praktisch bestätigt.

Testgruppe:

`TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01`

Testunit:

`TPL_BLUE_TRANSPORT_MI8_AKROTIRI_01_U01`

Typ:

`Mi-8MT`

Start:

- Akrotiri
- Parking H4
- `TakeOffParkingHot`
- Late Activation

Nach Aktivierung erkannte CTLD die Mi-8 innerhalb der Pickup-Zone automatisch.

Bestätigtes Ergebnis:

- 16 Soldaten automatisch geladen
- Coalition Blue
- `onboard.troopUnitCount = 16`
- Pickup-Zähler `10000 -> 9999`
- kein manuelles Laden
- keine direkte Manipulation von `ctld.inTransitTroops`
- kein DCS-native Embarking
- kein Teleport
- keine Runtime-Routenänderung

Damit ist der automatische CTLD-KI-Pickup für diesen Testaufbau bestanden.

---

## 8. Off-Airfield-Landung

Die vorherigen Tests vom 2026-09-21 zeigten, dass ein ungebundener Wegpunkt vom Typ:

`Land / Landing`

problematisch beziehungsweise nicht zuverlässig war.

Im erfolgreichen Test vom 2026-09-29 wurde deshalb ein anderer DCS-nativer Ansatz verwendet.

Der Zielwegpunkt blieb ein normaler:

`Turning Point`

Name:

`LAND_OFFAIRFIELD`

Position:

- x: `-29249.110954281`
- y/z: `-271836.070539260`

Höhe:

`100 m BARO`

Geschwindigkeit:

`30 m/s`

An diesem Wegpunkt war genau ein DCS-native Perform Task vorhanden:

`Land`

Parameter:

- x: `-29249.110954281`
- y: `-271836.070539260`
- `duration = 300`
- `durationFlag = true`
- `enabled = true`

Keine Airbase-, FARP- oder Helipad-Bindung war vorhanden.

### Runtime-Ergebnis

Die Mi-8:

1. nahm automatisch 16 CTLD-Soldaten auf,
2. rollte selbständig,
3. startete,
4. flog die Route,
5. begann den Sinkflug zum Ziel,
6. landete off-airfield,
7. setzte nahezu exakt im Zentrum der Dropoff-Zone auf.

Bestätigte minimale Entfernung zum Dropoff-Zentrum beim Touchdown:

`1.06 m`

Landeposition ungefähr:

- x: `-29248.1`
- z: `-271836`

Geschwindigkeit beim bestätigten Grounded-Zustand:

nahe `0 m/s`

Die Mi-8 blieb nach der Landung mindestens ungefähr `220 s` ununterbrochen am Boden.

Der Test wurde nach bestätigtem CTLD-Dropoff beendet; ein vollständiges Abwarten der konfigurierten 300 Sekunden war nicht erforderlich.

### Technische Schlussfolgerung

Für den getesteten Mi-8-KI-Transport ist:

`Turning Point + DCS-native Perform Task Land`

ein praktisch bestätigter Off-Airfield-Landeansatz.

Ein Invisible FARP war dafür nicht erforderlich.

---

## 9. Bestätigter automatischer CTLD-Dropoff

Nach der Off-Airfield-Landung erkannte CTLD den Transporter automatisch innerhalb der Dropoff-Zone.

Bestätigt:

- die 16 Soldaten wurden automatisch aus dem CTLD-Bordzustand entfernt,
- `ctld.inTransitTroops[unitName]` verlor den `troops`-Eintrag,
- `ctld.droppedTroopsBLUE` erhielt einen neuen Eintrag,
- eine neue Blue-Bodengruppe wurde erzeugt.

Erzeugte Gruppe:

`Dropped Group 2`

Group-ID:

`70001`

Einheiten:

`16`

Typ:

`Soldier M249`

Der Dropoff wurde nicht manuell ausgelöst.

Nicht verwendet wurden:

- manuelles Unload
- direkte Bordzustandsmanipulation
- DCS-native Disembarking
- Teleportation
- Runtime-Routenänderung
- Runtime-Taskänderung

Damit ist für diesen Testaufbau der vollständige automatische CTLD-KI-Zyklus praktisch bestätigt:

`Pickup -> Taxi -> Takeoff -> Transit -> Off-Airfield Land -> CTLD Dropoff -> Ground Group`

---

## 10. RepackCommandsPath-Fehler

Beim Grounded-Übergang der KI-Mi-8 trat der bereits aus einem früheren Test bekannte CTLD-Fehler erneut auf.

Bestätigter Fehler:

`CTLD.lua:6150: attempt to get length of local 'RepackCommandsPath' (a nil value)`

Stack-Kontext:

- `updateRepackMenu`
- `updateRepackMenuOnlanding`

Der Fehler trat zeitlich beim beziehungsweise unmittelbar nach dem Grounded-Übergang auf.

### Technische Einordnung

Der geprüfte CTLD-Code führt `updateRepackMenuOnlanding()` auch über Namen aus `ctld.transportPilotNames`.

Für die reine KI-Mi-8 existiert jedoch nicht zwangsläufig derselbe F10-/Vehicle-Command-Pfad wie für einen Spielertransport.

Dadurch kann:

`ctld.vehicleCommandsPath[_unitName]`

für die KI-Unit `nil` sein.

Der anschließende Repack-Menüpfad erwartet diesen Zustand nicht korrekt und läuft in den beobachteten Fehler.

### Wichtiges Testergebnis

Trotz dieses Fehlers funktionierten im selben Test:

- automatischer Pickup,
- Transport,
- Landung,
- automatischer Dropoff,
- Erzeugung der Bodengruppe.

Der Fehler hat den getesteten Pickup-/Dropoff-Pfad somit in diesem konkreten Lauf nicht verhindert.

Nicht daraus abgeleitet werden darf, dass der Fehler produktiv ignoriert werden kann.

Insbesondere besteht der Verdacht, dass der Repack-Menü-Scheduler nach dem unbehandelten Fehler nicht erneut geplant wird.

Das ist vor produktiver CTLD-KI-Integration separat zu behandeln.

### Vendor-Regel

`vendor/ctld/CTLD.lua` wird dafür nicht verändert.

Eine spätere Lösung muss TC-seitig erfolgen oder durch eine sauber belegte Konfigurations-/Integrationsstrategie erreicht werden.

---

## 11. Pickup-Zone und Crate-Spawn bleiben getrennt

Eine funktionierende Pickup-Zone bedeutet weiterhin nicht automatisch, dass CTLD-Crates gespawnt werden können.

Für Crate-Spawn verwendet CTLD unter anderem seinen Logistics-Zone-/Logistic-Unit-Pfad.

Ein späterer Spieler- oder KI-Crate-Test ist deshalb ein eigener Integrationsschritt.

Der erfolgreiche Test vom 2026-09-29 war ein:

`KI-Truppentransport`

und kein:

`Crate-/Cargo-Transport`.

Nicht als bestätigt gelten deshalb:

- Crate-Spawn
- Crate-Loading
- Sling Load
- Crate-Drop
- FOB-Bau durch Crates
- Theater-Command-Supply-Effekt aus Crates

---

## 12. Verhältnis zu Theater-Command-State

Der erfolgreiche CTLD-Test war bewusst ein isolierter Framework-Integrationstest.

Noch nicht implementiert ist die Verbindung zwischen dem erfolgreichen CTLD-Runtime-Pfad und dem persistierten Theater-Command-State.

Insbesondere noch nicht produktiv:

- CTLD-Transportauftrag aus MissionGenerator
- automatische Auswahl eines KI-Transporters
- automatische TC-seitige CTLD-Zonenregistrierung
- automatische `transportPilotNames`-Registrierung
- LogisticsDelivery -> CTLD
- CTLD Dropoff -> LogisticsDelivery
- CTLD Dropoff -> FOB Build Progress
- CTLD Dropoff -> Supply
- CTLD Dropoff -> Capture
- CTLD Dropoff -> AI Director
- CTLD-Runtime-State Restore

Diese Verknüpfungen werden nicht aus dem erfolgreichen Proof-of-Concept als bereits implementiert abgeleitet.

---

## 13. Invisible FARP

Ein Invisible FARP wurde als möglicher technischer Ansatz untersucht, aber für den erfolgreichen Test nicht benötigt.

Der Test vom 2026-09-29 bestätigt, dass die getestete Mi-8 mit einem DCS-native Perform Task `Land` direkt auf geeignetem Gelände landen kann.

Deshalb wird für diesen Transportpfad derzeit kein Invisible FARP als technische Voraussetzung angenommen.

Eine spätere Verwendung von Invisible FARPs für echte FOB-Infrastruktur, Rearming, Refueling, Parking oder andere Kampagnenfunktionen bleibt davon unberührt und muss separat entschieden werden.

---

## 14. Werkzeugtrennung

Für die CTLD-Tests hat sich folgende Entwicklungswerkzeug-Trennung bestätigt:

### dcs-mcp

Verwendet für:

- `.miz`-Analyse
- Mission-Editor-Struktur
- Gruppen
- Units
- Zonen
- Wegpunkte
- Tasks
- Terrainprüfung
- gespeicherte Missionsänderungen

Aktuell bestätigte verwendete Version:

`dcs-mcp 0.9.11`

### DCS-SMS

Verwendet für:

- Mission-Editor-Status
- laufende DCS-Runtime
- Runtime-Lua
- CTLD-Live-State
- Unit-Aktivierung
- Positions-/Flugzustandsbeobachtung
- Logauswertung

Aktuell bestätigte Version:

`DCS-SMS 0.27.2`

Hook:

`me-bridge-0.27.2`

DCS-SMS bleibt ausschließlich Entwicklungs- und Diagnosewerkzeug.

Es ist kein Theater-Command-Runtime-Framework.

---

## 15. Aktueller Integrationsstand

Bestanden:

- CTLD 1.6.1 lädt und initialisiert.
- nachträgliche Pickup-Zonenregistrierung funktioniert.
- nachträgliche Dropoff-Zonenregistrierung funktioniert.
- keine erneute CTLD-Initialisierung erforderlich.
- KI-Transporter kann über `ctld.transportPilotNames` registriert werden.
- CTLD erkennt den registrierten KI-Transporter.
- automatischer KI-Truppen-Pickup funktioniert.
- 16 Soldaten werden transportiert.
- DCS-native Off-Airfield-Landung über Perform Task `Land` funktioniert.
- CTLD erkennt den gelandeten KI-Transporter in der Dropoff-Zone.
- automatischer CTLD-Dropoff funktioniert.
- 16-Mann-Bodengruppe wird erzeugt.
- produktive Persistence blieb während des isolierten Tests unverändert.
- Vendor-Dateien blieben unverändert.

Bekannter Fehler:

- `RepackCommandsPath` bei KI-Grounded-Transition.

Noch nicht produktiv:

- eigene TC-CTLD-Bridge unter `src/`
- automatische Zonenregistrierung
- automatische KI-Transporterregistrierung
- Crate-/Cargo-Transport
- LogisticsDelivery-Kopplung
- FOB-Bau durch CTLD
- Supply-Effekt
- Persistenz des CTLD-Runtime-Zustands
- Multiplayer-Test

---

## 16. Nächster technischer Architekturpunkt

Der Proof-of-Concept ist abgeschlossen.

Der nächste produktive CTLD-Schritt darf deshalb nicht einfach ein weiterer manueller Runtime-Test derselben Art sein.

Vor einer produktiven Integration muss festgelegt werden, wie Theater Command die bestätigten CTLD-Voraussetzungen in eigener Logik unter `src/` verwaltet.

Mindestens zu berücksichtigen:

1. idempotente Registrierung von Pickup-Zonen,
2. idempotente Registrierung von Dropoff-Zonen,
3. idempotente Registrierung von KI-Transport-Units in `ctld.transportPilotNames`,
4. Lifecycle bei Spawn/Aktivierung/Despawn,
5. Behandlung des `RepackCommandsPath`-Problems ohne Vendor-Modifikation,
6. Trennung zwischen Truppentransport und Crate-/Cargo-Transport,
7. spätere Kopplung an LogisticsDelivery und FobSystem,
8. klare Persistence-Grenze zwischen Theater-Command-State und CTLD-Runtime-State.

Die konkrete Implementierungsdatei und der genaue erste produktive Code-Schritt werden separat festgelegt.

Es gilt weiterhin:

- eine konkrete Aufgabe,
- eine Datei,
- ein Test,
- eine klare Bewertung.

`productiveRestore=false` bleibt unverändert.
