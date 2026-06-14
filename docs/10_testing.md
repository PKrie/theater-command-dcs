# Testing

Diese Datei beschreibt das geplante Testkonzept für Theater Command DCS.

Ziel ist, jedes System einzeln zu testen, bevor mehrere Systeme miteinander verbunden werden.

---

## Grundsatz

Theater Command DCS wird nicht als ein großes Komplettsystem auf einmal gebaut.

Jedes System wird einzeln erstellt, getestet und erst danach mit dem nächsten System verbunden.

Reihenfolge:

1. Mission lädt
2. Frameworks laden
3. Loader startet
4. Core funktioniert
5. Logger funktioniert
6. Airbase-Scanner funktioniert
7. Zonen werden erzeugt
8. F10-Debugmenü funktioniert
9. CTLD funktioniert
10. Missionsgenerator funktioniert
11. AI Director funktioniert
12. IADS funktioniert
13. Persistenz funktioniert

---

## Testziel

Tests sollen beantworten:

- Lädt das System ohne Fehler?
- Gibt es Fehlermeldungen in dcs.log?
- Werden erwartete Daten erkannt?
- Funktionieren Debug-Ausgaben?
- Funktionieren F10-Menüs?
- Werden Missionen korrekt erzeugt?
- Funktioniert CTLD?
- Werden Zustände korrekt gespeichert?
- Können Fehler nachvollzogen werden?

---

## Testumgebung

Die erste Testumgebung ist:

Operation_Levant_Reclamation_DEV.miz

Speicherort:

mission/dev/Operation_Levant_Reclamation_DEV.miz

Map:

Syria

Startbasis:

Akrotiri

Aktive Testregion:

Syrian Coast

---

## Testregel

Immer nur eine neue Funktion pro Test hinzufügen.

Nicht mehrere große Systeme gleichzeitig einbauen.

Falsch:

Airbase-Scanner, CTLD, IADS, Missionsgenerator und Persistenz gleichzeitig testen.

Richtig:

Erst prüfen, ob der Airbase-Scanner Airbases erkennt.

Danach prüfen, ob daraus BaseNodes entstehen.

Danach prüfen, ob virtuelle Zonen erzeugt werden.

Danach erst das nächste System ergänzen.

---

## DCS Log

Die wichtigste technische Prüfstelle ist:

dcs.log

Dort müssen Lua-Fehler, Ladefehler und Debug-Ausgaben geprüft werden.

Wichtige Suchbegriffe:

- ERROR
- SCRIPTING
- Lua
- TC
- Theater Command
- stack traceback
- nil value
- attempt to index
- file not found

---

## Debug-Präfix

Alle eigenen Debug-Ausgaben sollen klar erkennbar sein.

Empfohlenes Präfix:

[TC]

Beispiele:

[TC] Theater Command loader started
[TC] Core initialized
[TC] Airbase scanner started
[TC] Airbase detected: Akrotiri
[TC] CTLD delivery registered
[TC] Mission generated: MISSION_BLUE_SEAD_SYRIAN_COAST_01

---

## Test 1 — Mission startet

Ziel:

Prüfen, ob die DCS-Mission grundsätzlich startet.

Erwartung:

- Mission lädt
- kein Absturz
- Spieler kann Slot auswählen
- Spieler kann auf Akrotiri starten

Noch nicht prüfen:

- Lua-Systeme
- CTLD
- MOOSE
- IADS
- Missionsgenerator

---

## Test 2 — Spieler-Slots

Ziel:

Prüfen, ob alle ersten Spieler-Slots korrekt vorhanden sind.

Zu prüfen:

- CLIENT_BLUE_FA18C_AKROTIRI_01
- CLIENT_BLUE_FA18C_AKROTIRI_02
- CLIENT_BLUE_F16C_AKROTIRI_01
- CLIENT_BLUE_F16C_AKROTIRI_02
- CLIENT_BLUE_F15E_AKROTIRI_01
- CLIENT_BLUE_F15E_AKROTIRI_02
- CLIENT_BLUE_F14B_AKROTIRI_01
- CLIENT_BLUE_F14B_AKROTIRI_02
- CLIENT_BLUE_UH1H_AKROTIRI_01
- CLIENT_BLUE_MI8_AKROTIRI_01

Erwartung:

- Slots erscheinen in der Slotliste
- Jets starten korrekt
- Helis starten korrekt
- keine falsche Koalition
- keine falsche Basis

---

## Test 3 — Template-Gruppen

Ziel:

Prüfen, ob Template-Gruppen korrekt vorbereitet sind.

Erwartung:

- Template-Gruppen existieren
- Late Activation ist aktiviert
- Hidden on Map ist aktiviert
- Gruppen sind beim Missionsstart nicht aktiv
- Gruppen können später per Lua gespawnt werden

Zu prüfen:

- rote CAP-Templates
- rote GCI-Templates
- rote SAM-Templates
- blaue CAP-Templates
- blaue SEAD-Templates
- Logistik-Templates

---

## Test 4 — Frameworks laden

Ziel:

Prüfen, ob externe Frameworks korrekt geladen werden.

Lade-Reihenfolge:

1. MIST
2. MOOSE
3. CTLD
4. Skynet IADS
5. src/loader.lua

Erwartung:

- keine file-not-found-Fehler
- keine Lua-Fehler
- CTLD lädt nach MIST
- Theater Command Loader startet erst nach Frameworks

---

## Test 5 — Loader

Ziel:

Prüfen, ob src/loader.lua geladen wird.

Erwartete Ausgabe:

[TC] Theater Command loader started

Zu prüfen:

- Datei wird gefunden
- Datei wird ausgeführt
- keine Syntaxfehler
- Loader lädt später weitere Dateien in richtiger Reihenfolge

---

## Test 6 — Core

Ziel:

Prüfen, ob der Core initialisiert wird.

Zu prüfen:

- TC-Tabelle existiert
- TC.Core existiert
- TC.World existiert
- TC.Campaign existiert
- TC.Logistics existiert
- TC.Missions existiert
- TC.AI existiert
- TC.IADS existiert
- TC.UI existiert
- TC.Debug existiert

Erwartete Ausgabe:

[TC] Core initialized

---

## Test 7 — Logger

Ziel:

Prüfen, ob zentrale Log-Ausgaben funktionieren.

Geplante Funktionen:

TC.Logger.Info
TC.Logger.Warn
TC.Logger.Error
TC.Logger.Debug

Erwartung:

- Info-Ausgabe erscheint
- Warn-Ausgabe erscheint
- Error-Ausgabe erscheint
- Debug-Ausgabe kann aktiviert oder deaktiviert werden

---

## Test 8 — Airbase-Scanner

Ziel:

Prüfen, ob Airbases der Syria Map erkannt werden.

Zu prüfen:

- Airbase-Scanner startet
- Airbases werden erkannt
- Namen werden ausgegeben
- Akrotiri wird erkannt
- Khmeimim wird erkannt
- Latakia wird erkannt
- Anzahl erkannter Airbases wird ausgegeben

Erwartete Ausgabe:

[TC] Airbase scanner started
[TC] Airbase detected: Akrotiri
[TC] Airbase scan complete

---

## Test 9 — Airbase Registry

Ziel:

Prüfen, ob erkannte Airbases als BaseNodes gespeichert werden.

Zu prüfen:

- BaseNode wird erzeugt
- Name wird gespeichert
- Besitzer wird gesetzt
- Region wird gesetzt
- Ressourcen werden gesetzt
- Zugriff per Name funktioniert

Erwartung:

Akrotiri:

- owner = blue
- region = cyprus
- active = true

Khmeimim:

- owner = red
- region = syrian_coast
- active = true

---

## Test 10 — Virtuelle Zonen

Ziel:

Prüfen, ob Lua virtuelle Zonen erzeugen kann.

Zu prüfen:

- Capture-Zone
- Logistics-Zone
- Defense-Zone
- Repair-Zone
- Spawn-Zone

Erwartung:

- Zonen werden intern erzeugt
- Zonen sind im Debug sichtbar
- Zonen hängen am richtigen BaseNode
- keine Mission-Editor-Zonen pro Airbase nötig

---

## Test 11 — F10-Debugmenü

Ziel:

Prüfen, ob ein erstes F10-Menü funktioniert.

Mögliche Struktur:

Theater Command
- Debug
- Airbases
- Logistics
- Missions
- Campaign Status

Erwartung:

- Menü erscheint
- Menü ist nur für passende Koalition sichtbar
- Debug-Ausgabe funktioniert
- Airbase-Status kann angezeigt werden

---

## Test 12 — CTLD-Grundtest

Ziel:

Prüfen, ob CTLD grundsätzlich funktioniert.

Zu prüfen:

- Heli-Slot starten
- CTLD-Menü erscheint
- Pickup-Zone funktioniert
- Kiste kann erstellt werden
- Kiste kann aufgenommen werden
- Kiste kann transportiert werden
- Kiste kann abgesetzt werden

Erwartung:

- CTLD arbeitet ohne Fehler
- keine Lua-Fehler
- erste Lieferung kann später von Theater Command erkannt werden

---

## Test 13 — Logistik-Lieferung

Ziel:

Prüfen, ob Theater Command eine Lieferung erkennen kann.

Testfall:

Supply-Kiste von Akrotiri zu Beachhead Alpha liefern.

Erwartung:

- Lieferung wird erkannt
- Zielzone wird erkannt
- Ressource supply wird erhöht
- Debug-Ausgabe erscheint

Beispielausgabe:

[TC] Logistics delivery detected
[TC] Target: Beachhead Alpha
[TC] Resource added: supply +10

---

## Test 14 — Missionsgenerator

Ziel:

Prüfen, ob der Missionsgenerator einfache Missionen erzeugt.

Zu prüfen:

- Spielergruppe erkennen
- Flugzeugtyp erkennen
- passende Missionsarten wählen
- F10-Missionsmenü anzeigen
- Mission auswählen
- Mission aktivieren

Erwartung:

F/A-18C sieht zum Beispiel:

- Test CAP Eastern Mediterranean
- Test SEAD Syrian Coast
- Test Strike Latakia Radar

UH-1H sieht zum Beispiel:

- Test Supply Delivery
- Test Troop Transport
- Test FOB Delivery

---

## Test 15 — AI Director

Ziel:

Prüfen, ob der AI Director einfache Entscheidungen treffen kann.

Erster Testfall:

Wenn Syrian Coast aktiv ist und Khmeimim rot ist, kann rote Test-CAP ausgelöst werden.

Zu prüfen:

- AI Director startet
- aktive Region wird erkannt
- rote Basis wird erkannt
- Priorität wird berechnet
- Test-CAP wird gespawnt
- Cooldown funktioniert

---

## Test 16 — IADS

Ziel:

Prüfen, ob ein erster IADS-Testsektor funktioniert.

Testregion:

Syrian Coast

Zu prüfen:

- Skynet IADS lädt
- Testsektor wird erstellt
- Radar wird eingebunden
- SAM wird eingebunden
- Bedrohungsgrad wird berechnet
- Debug-Ausgabe funktioniert

Erwartung:

[TC] IADS sector active: syrian_coast
[TC] IADS threat level: 80

---

## Test 17 — Missionserfolg

Ziel:

Prüfen, ob einfache Missionserfolge erkannt werden.

Beispiele:

- Radar zerstört
- Konvoi zerstört
- Kiste geliefert
- Zone erreicht
- CAP-Zeit gehalten

Erwartung:

- Mission wird completed
- Kampagnenzustand verändert sich
- Debug-Ausgabe erscheint

---

## Test 18 — Misserfolg

Ziel:

Prüfen, ob Missionen auch scheitern können.

Mögliche Gründe:

- Zeitlimit abgelaufen
- Ziel nicht zerstört
- Transport nicht geliefert
- FOB verloren
- Konvoi erreicht Ziel
- Spieler verlässt Gebiet

Erwartung:

- Mission wird failed
- Kampagnenzustand verändert sich
- Folgeeffekte werden erzeugt

---

## Test 19 — Persistenz

Ziel:

Prüfen, ob ein einfacher Kampagnenzustand gespeichert und geladen werden kann.

Erster Testinhalt:

- Kampagnenname
- Kampagnenphase
- Besitzer Akrotiri
- Besitzer Khmeimim
- Ressourcen Akrotiri
- Ressourcen Khmeimim

Erwartung:

- Save-Datei wird geschrieben
- Save-Datei wird beim nächsten Start geladen
- Werte stimmen nach Neustart noch

---

## Test 20 — Regressionstest

Ziel:

Prüfen, ob neue Änderungen alte Funktionen nicht kaputt machen.

Nach jeder größeren Änderung prüfen:

- Mission startet
- Loader startet
- Core lädt
- Airbases werden erkannt
- F10-Menü funktioniert
- keine neuen Lua-Fehler
- CTLD funktioniert weiterhin
- Testmissionen funktionieren weiterhin

---

## Minimaler Testumfang pro Änderung

Nach jeder neuen Lua-Datei mindestens prüfen:

- Mission startet
- dcs.log enthält keine Lua-Fehler
- neue Datei wurde geladen
- erwartete Debug-Ausgabe erscheint
- bestehende Systeme funktionieren weiter

---

## Fehlerdokumentation

Fehler sollen dokumentiert werden.

Wichtige Angaben:

- Datum
- betroffene Datei
- DCS-Version
- Mission-Version
- Fehlermeldung aus dcs.log
- was wurde getestet?
- was wurde erwartet?
- was ist passiert?
- wie wurde der Fehler behoben?

---

## Teststatus

Mögliche Statuswerte:

- not tested
- testing
- passed
- failed
- blocked
- fixed

Diese Werte können später in Testplänen oder Issues genutzt werden.

---

## Entwicklungsregel

Wenn ein Test fehlschlägt:

Nicht direkt das nächste System bauen.

Erst Fehler verstehen.

Dann Fehler beheben.

Dann erneut testen.

Dann erst weitermachen.

---

## Zielbild

Das Testsystem soll verhindern, dass Theater Command DCS unkontrollierbar wächst.

Jede neue Funktion soll nachvollziehbar getestet werden.

So bleibt das Projekt auch bei wachsender Komplexität wartbar, erweiterbar und stabil.