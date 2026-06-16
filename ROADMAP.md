# Roadmap

Diese Roadmap beschreibt die geplanten Entwicklungsphasen für **Theater Command DCS** und die erste Kampagne **Operation Levant Reclamation**.

Das Projekt wird schrittweise aufgebaut.  
Jede Phase soll einzeln dokumentiert, umgesetzt und in DCS getestet werden, bevor die nächste große Phase vertieft wird.

---

## 1. Projektziel

**Theater Command DCS** soll ein modulares, dynamisches und später persistentes DCS-World-Kampagnensystem werden.

Erste Kampagne:

- **Operation Levant Reclamation**
- Map: **Syria**
- Blue Start: **Akrotiri / Zypern**
- Red Start: **syrisches Festland vollständig rot kontrolliert**

Grundprinzip:

- **Mission Editor = Bühne**
- **Lua = Kampagnensystem**
- **GitHub = Projektgedächtnis**

Der DCS Mission Editor stellt die physische Umgebung bereit.  
Lua übernimmt die eigentliche Kampagnenlogik.  
GitHub dokumentiert Struktur, Entscheidungen, Versionen, Teststände und Aufgabenstand.

---

## 2. Zielbild der Kampagne

Theater Command DCS soll langfristig keine einzelne lineare Mission sein.

Ziel ist eine laufende Kampagnenmaschine:

- Blue besitzt zu Beginn Akrotiri und ggf. weitere Zypern-nahe Stützpunkte.
- Red kontrolliert zu Beginn das syrische Festland.
- Blue muss schrittweise Kampagnenziele auf dem Festland schwächen, isolieren und erobern.
- Red verteidigt seine strategischen Basen, IADS-Struktur, Logistik und Lufthoheit.
- Spieler steigen mit Client-Flugzeugen in diese laufende Lage ein.
- Spieler sollen Missionen übernehmen können, aber nicht der einzige Auslöser der Kampagne sein.
- Blue-KI und Red-KI sollen später unabhängig voneinander handeln können.
- Missionen, Capture, Logistics, FOBs, IADS, AI, UI und Persistence sollen zusammenwirken.

Langfristiges Ziel:

Der Spieler ist Teilnehmer einer dynamischen Kriegsmaschinerie, nicht alleiniger Motor der Simulation.

---

## 3. Aktueller Projektstand

Stand: **2026-06-16**

Aktueller technischer Status:

Die Theater-Command-Startkette läuft im DCS Mission Scripting Environment.

Bestätigt:

- Vendor-Frameworks werden geladen.
- Eigene Source-Module werden geladen.
- Loader erkennt Frameworks.
- Main wird gestartet.
- Runtime-Systeme werden initialisiert.
- Loader beendet sauber.
- Airbase Scanner läuft.
- Zone Factory läuft.
- Capture System läuft.
- Logistics Delivery läuft.
- FOB System läuft.
- Mission Generator läuft.
- AI CAP Manager läuft.
- F10 Menu läuft.

Wichtig:

Das Projekt ist noch keine fertige spielbare dynamische Kampagne.  
Die aktuell erfolgreich getesteten Systeme sind überwiegend **State-Systeme**.  
Sie bereiten Kampagnenlogik vor, erzeugen aber noch keine echten MOOSE-, CTLD- oder Skynet-IADS-Aktionen im DCS-Raum.

---

## 4. Aktuelle Framework-Basis

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Zusätzlich wird geladen:

- `vendor/ctld/CTLD-i18n.lua`

Wichtig:

Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket, weil CTLD eine kompatible MIST-Version benötigt.

Framework-Regel:

- Vendor-Dateien werden nicht verändert.
- Eigene Theater-Command-Logik liegt unter `src/`.
- Eigene Logik wird nach Aufgabenbereichen sortiert, nicht nach Frameworks.

Nicht erwünscht:

- `tc_moose.lua`
- `tc_mist.lua`
- `tc_ctld.lua`
- `tc_all_in_one.lua`

---

## 5. Aktuelle DCS-Ladevariante

Aktuell wird **Starttest-Variante A** verwendet:

- sichere Einzeldatei-Ladung über `DO SCRIPT FILE`
- alle Vendor-Dateien werden einzeln geladen
- alle aktiven Source-Dateien werden einzeln geladen
- `src/main.lua` wird nach den Modulen geladen
- `src/loader.lua` wird zuletzt geladen

Diese Variante ist in DCS erfolgreich getestet.

Wichtig:

Eine per `DO SCRIPT FILE` geladene Lua-Datei wird in die `.miz` eingebettet.  
Nach einer GitHub-Änderung muss die geänderte Lua-Datei im Mission Editor erneut ausgewählt und die Mission gespeichert werden.

Aktuelle aktive Source-Ladefolge nach den Vendor-Dateien:

1. `src/core/tc_config.lua`
2. `src/core/tc_logger.lua`
3. `src/core/tc_state.lua`
4. `src/core/tc_utils.lua`
5. `src/core/tc_scheduler.lua`
6. `src/world/tc_airbase_scanner.lua`
7. `src/world/tc_zone_factory.lua`
8. `src/campaign/tc_capture_system.lua`
9. `src/campaign/tc_persistence_system.lua`
10. `src/logistics/tc_logistics_delivery.lua`
11. `src/logistics/tc_fob_system.lua`
12. `src/missions/tc_mission_generator.lua`
13. `src/ai/tc_ai_cap_manager.lua`
14. `src/ui/tc_f10_menu.lua`
15. `src/main.lua`
16. `src/loader.lua`

Noch offen:

- Starttest-Variante B
- Loader-only-Test mit `dofile`
- Bewertung des DCS-Sandbox-Verhaltens
- Entscheidung, ob spätere Entwicklung per Loader-only möglich ist

---

## 6. Erfolgreiche Tests

### 6.1 Starttest Variante A

Status:

- **bestanden**

Bestätigt:

- MIST geladen
- MOOSE geladen
- CTLD-i18n geladen
- CTLD geladen
- Skynet IADS geladen
- Theater Command Loader gestartet
- Frameworks durch Loader erkannt
- Core geladen
- World geladen
- Campaign geladen
- Logistics geladen
- Missions geladen
- AI geladen
- UI geladen
- Main gestartet
- Runtime-Systeme initialisiert
- Loader sauber beendet

---

### 6.2 Airbase Scanner

Datei:

- `src/world/tc_airbase_scanner.lua`

Aktuelle getestete Version:

- `v0.2.2`

Status:

- **bestanden**

Bestätigte Testwerte:

| Wert | Anzahl |
|---|---:|
| total | 225 |
| strategic | 19 |
| secondary | 13 |
| heliports | 1 |
| helipads | 95 |
| medical | 40 |
| farps | 0 |
| tactical | 13 |
| unknown | 44 |
| captureCandidates | 32 |
| missionCandidates | 32 |
| logisticsCandidates | 46 |
| blueStartBases | 1 |
| redStrategicCandidates | 18 |

Bewertung:

- Airbase-Erkennung funktioniert.
- Syria liefert 225 airbase-like objects.
- Akrotiri wird korrekt als `STRATEGIC_AIRFIELD` erkannt.
- Akrotiri erhält `strategicRelevance=100`.
- strategische syrische Hauptflugplätze werden als Red Strategic Candidates vorbereitet.
- Medical Pads und einfache Helipads werden nicht mehr als strategische Kampagnenziele behandelt.

---

### 6.3 Zone Factory

Datei:

- `src/world/tc_zone_factory.lua`

Aktuelle getestete Version:

- `v0.2.0`

Status:

- **bestanden**

Bestätigte Testwerte:

| Wert | Anzahl |
|---|---:|
| total zones | 46 |
| classified airbase zones | 46 |
| Mission Editor zones | 0 |
| skipped airbase-like objects | 179 |
| strategic zones | 19 |
| secondary zones | 13 |
| heliport zones | 1 |
| farp zones | 0 |
| tactical zones | 13 |
| captureZones | 32 |
| missionZones | 32 |
| logisticsZones | 46 |
| startBaseZones | 1 |

Bewertung:

- ZoneFactory nutzt die Airbase-Klassifizierung.
- Es werden nicht mehr 225 ungefilterte Zonen erzeugt.
- Es entstehen 46 sinnvolle Kampagnenzonen.

---

### 6.4 Capture System

Datei:

- `src/campaign/tc_capture_system.lua`

Aktuelle getestete Version:

- `v0.2.0`

Status:

- **bestanden**

Bestätigte Testwerte:

| Wert | Anzahl |
|---|---:|
| eligibleBases | 32 |
| eligibleZones | 32 |
| nonCaptureBases | 193 |
| nonCaptureZones | 14 |

Bewertung:

- Capture wirkt nur noch auf strategische und sekundäre Kampagnenziele.
- Helipads, Medical Pads, Tactical Pads und Unknowns werden von strategischer Capture-Logik ausgeschlossen.

---

### 6.5 Logistics Delivery

Datei:

- `src/logistics/tc_logistics_delivery.lua`

Aktuelle getestete Version:

- `v0.2.0`

Status:

- **bestanden**

Bestätigte Testwerte:

| Wert | Anzahl |
|---|---:|
| logistics hubs | 46 |
| blue hubs | 7 |
| red hubs | 24 |
| neutral hubs | 15 |
| active hubs | 31 |
| limited hubs | 15 |
| locked hubs | 0 |

Bewertung:

- Logistics Delivery nutzt die klassifizierten Kampagnenzonen.
- Akrotiri wird als Blue Main Operating Base vorbereitet.
- Red Strategic Airbase Hubs werden vorbereitet.
- CTLD wird noch nicht aktiv angesprochen.

---

### 6.6 FOB System

Datei:

- `src/logistics/tc_fob_system.lua`

Aktuelle getestete Version:

- `v0.2.0`

Status:

- **bestanden**

Bestätigte Testwerte:

| Wert | Anzahl |
|---|---:|
| FOB candidates | 6 |
| stored candidates | 6 |
| auto-planned FOBs | 2 |
| skipped candidates | 4 |
| Blue FOBs | 2 |

Bestätigte erzeugte FOBs:

- `FOB Ercan`
- `FOB Gecitkale`

Status:

- `UNDER_CONSTRUCTION`

Bewertung:

- FOB-System nutzt die Logistics-Hub-Struktur.
- FOBs werden als State-only-Objekte erzeugt.
- Es werden noch keine echten CTLD-FOBs gespawnt.

---

### 6.7 Mission Generator

Datei:

- `src/missions/tc_mission_generator.lua`

Aktuelle getestete Version:

- `v0.2.1`

Status:

- **bestanden**

Bestätigte Testwerte:

| Wert | Anzahl |
|---|---:|
| mission candidates | 69 |
| fobSupportCandidates | 2 |
| generated missions | 10 |
| reservedCreated | 1 |
| duplicatesSkipped | 1 |
| typeLimitSkipped | 30 |

Im Test erzeugte Missionstypen:

- `FOB_SUPPORT`
- `AIRBASE_ATTACK`
- `SEAD`
- `STRIKE`
- `CAP`

Bestätigte FOB-Support-Missionen:

- `FOB_SUPPORT` für `FOB Ercan`
- `FOB_SUPPORT` für `FOB Gecitkale`

Bewertung:

- Missionen werden aus klassifizierten Kampagnenzonen erzeugt.
- Missionen werden priorisiert.
- Medical Pads, einfache Helipads und Unknowns werden nicht als Strike-Ziele verwendet.
- FOB-Support wird nicht mehr durch Airbase-Attack-, SEAD-, Strike- oder CAP-Missionen verdrängt.
- Missionen bleiben State-only.

---

### 6.8 AI CAP Manager

Datei:

- `src/ai/tc_ai_cap_manager.lua`

Aktuelle getestete Version:

- `v0.2.0`

Status:

- **bestanden**

Bestätigte Testwerte:

| Wert | Anzahl |
|---|---:|
| cap zone candidates | 31 |
| auto-registered CAP zones | 12 |
| CAP requests | 12 |

Weitere bestätigte Werte:

- reactionState: `AIR_REACTION_REQUESTED`
- threatLevel: `HIGH`

Bewertung:

- Blue- und Red-CAP-Bedarf wird als State vorbereitet.
- Blue CAP für Akrotiri wird vorbereitet.
- Red CAPs für strategische syrische Flugplätze werden vorbereitet.
- Echter MOOSE-Spawn ist noch nicht aktiv.
- `spawn=MOOSE_PENDING` ist aktuell erwartetes Verhalten.

---

### 6.9 F10 Menu

Datei:

- `src/ui/tc_f10_menu.lua`

Aktuelle getestete Version:

- `v0.1.0`

Status:

- **bestanden**

Bestätigte Testwerte:

| Wert | Ergebnis |
|---|---|
| F10 menu visible | ja |
| F10 menu navigable | ja |
| commands | 7 |

Bestätigte Funktionen:

- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Top-Mission aktivieren
- Kampagnenstatus anzeigen
- Logistikstatus anzeigen
- FOB-Status anzeigen
- AI-CAP-Status anzeigen

Bewertung:

- Erste spielerseitige Bedienoberfläche funktioniert.
- F10 Menu ist sichtbar, navigierbar und im Log bestätigt.
- Direkte Missionsauswahl 1 bis 10 ist noch offen.

---

## 7. Phasenübersicht

### Phase 0 — Projektbasis

Status:

- **abgeschlossen**

Ziele:

- Projektidee dokumentieren
- Repository anlegen
- zentrale Dokumentationsdateien erstellen
- Architekturgrundsätze definieren
- Namenskonventionen definieren
- Lua-Stilregeln definieren
- Mission-Editor-Grundprinzip festlegen
- Docs-Grundblock erstellen
- Vendor-Grundstruktur erstellen

Ergebnis:

Phase 0 ist abgeschlossen.

---

### Phase 0.5 — Vendor-Basis

Status:

- **abgeschlossen**

Ziele:

- MIST unter `vendor/mist/` hinterlegen
- MOOSE unter `vendor/moose/` hinterlegen
- CTLD unter `vendor/ctld/` hinterlegen
- Skynet IADS unter `vendor/skynet-iads/` hinterlegen
- Framework-Versionen dokumentieren
- Frameworks nicht verändern
- Lade-Reihenfolge dokumentieren
- Vendor-Dokumentation aktualisieren

Ergebnis:

Vendor-Basis ist abgeschlossen und in DCS erfolgreich geladen.

---

### Phase 1 — Source Foundation

Status:

- **weitgehend abgeschlossen**

Ziele:

- `src/`-Grundstruktur anlegen
- eigene Lua-Logik nach Aufgaben sortieren
- keine frameworkorientierten Sammeldateien erstellen
- Core-Bereich erstellen
- Loader erstellen
- Main-Initialisierung erstellen
- Framework-Verfügbarkeit prüfen
- Logging vorbereiten
- State-Struktur vorbereiten
- Scheduler vorbereiten
- Startkette im DCS Mission Scripting Environment prüfen

Erledigt:

- `src/README.md`
- `src/core/README.md`
- `src/world/README.md`
- `src/campaign/README.md`
- `src/logistics/README.md`
- `src/missions/README.md`
- `src/ai/README.md`
- `src/iads/README.md`
- `src/ui/README.md`
- `src/debug/README.md`
- `src/loader.lua`
- `src/main.lua`
- `src/core/tc_config.lua`
- `src/core/tc_logger.lua`
- `src/core/tc_state.lua`
- `src/core/tc_utils.lua`
- `src/core/tc_scheduler.lua`

Ergebnis:

Source Foundation ist technisch angelegt und in DCS lauffähig.

Offen:

- Loader-only-Variante mit `dofile` praktisch testen
- DCS-Sandbox-Verhalten bewerten
- spätere Lade-Strategie festlegen

---

### Phase 2 — Airbase- und World-System

Status:

- **technisch bestanden**

Aktuell vorhanden:

- `src/world/tc_airbase_scanner.lua`
- `src/world/tc_zone_factory.lua`

Erledigt:

- 225 Syria-Airbase-Objekte erkannt
- Airbase-Objekte klassifiziert
- strategische Airfields erkannt
- Secondary Airfields erkannt
- Helipads erkannt
- Medical Pads erkannt
- Tactical Pads erkannt
- Akrotiri als Blue Startbase erkannt
- 46 relevante Kampagnenzonen erzeugt
- 179 nicht relevante Objekte übersprungen

Ergebnis:

Phase 2 ist für den aktuellen Entwicklungsstand bestanden.

Offen:

- Debug-Report für Airbases
- Debug-Report für Zonen
- Mission-Editor-Zonen später praktisch testen
- optionale Feinkorrektur einzelner Syria-Namen

---

### Phase 3 — Campaign State und Capture-System

Status:

- **technisch bestanden**

Aktuell vorhanden:

- `src/campaign/tc_capture_system.lua`
- `src/campaign/tc_persistence_system.lua`

Erledigt:

- Basisstatus vorbereitet
- Zonenstatus vorbereitet
- Capture-Events vorbereitet
- In-Memory-Persistenz vorbereitet
- State-Snapshot vorbereitet
- State-Export vorbereitet
- State-Import vorbereitet
- Capture-Eligibility auf 32 relevante Ziele begrenzt
- nicht relevante Rohobjekte von Capture ausgeschlossen

Ergebnis:

Capture-System arbeitet auf gefilterten Kampagnenzielen.

Offen:

- echte Capture-Bedingungen fachlich definieren
- Capture-Fortschritt modellieren
- Garnisonen berücksichtigen
- Supply berücksichtigen
- Missionserfolge auf Capture-Druck anwenden
- AI-Operationen auf Capture-Druck anwenden
- Capture-Debugreport vorbereiten
- Capture-Zustand praktisch persistieren

---

### Phase 4 — Logistics und FOB-System

Status:

- **technisch bestanden für State-Grundlogik**

Aktuell vorhanden:

- `src/logistics/tc_logistics_delivery.lua`
- `src/logistics/tc_fob_system.lua`

Erledigt:

- Logistics Delivery nutzt klassifizierte Kampagnenzonen
- 46 Logistics Hubs werden erzeugt
- Blue Main Operating Base wird vorbereitet
- Red Strategic Hubs werden vorbereitet
- Lieferstatus vorbereitet
- Lieferungen anlegbar
- Lieferungen abschließbar
- Lieferungen verlierbar
- Lieferungen abbrechbar
- FOB-System nutzt die Logistics-Hub-Struktur
- 6 FOB-Kandidaten werden erzeugt
- 2 Blue-FOBs werden automatisch geplant
- FOBs werden mit Zonen, Basen und Logistics Hubs verbunden
- FOB-Support-Missionen werden durch den Mission Generator berücksichtigt

Ergebnis:

Logistics Delivery und FOB System sind im State-first-Ansatz getestet.

Offen:

- CTLD-Grundkonfiguration vorbereiten
- Akrotiri-CTLD-Pickup-Zonen anlegen
- Dropoff-Zonen vorbereiten
- CTLD-Ereignisse mit Theater Command verbinden
- Supply-Verbrauch modellieren
- Logistics-Zustand praktisch persistieren
- echte CTLD-FOBs erst nach Mission-Editor-Zonen und CTLD-Test

---

### Phase 5 — Missionsgenerator

Status:

- **technisch bestanden**

Aktuell vorhanden:

- `src/missions/tc_mission_generator.lua`

Erledigt:

- Missionsarten vorbereitet
- Missionsstatus vorbereitet
- Missionen anlegbar
- Missionen aktivierbar
- Missionen abschließbar
- Missionen fehlgeschlagen markierbar
- Logistikmissionen vorbereitet
- FOB-Support-Missionen vorbereitet
- Airbase-Ziele aus gefiltertem Kampagnenzustand abgeleitet
- Missionen aus klassifizierten Zonen erzeugt
- FOB-Support wird reserviert in verfügbare Missionen aufgenommen
- 69 Kandidaten und 10 Missionen im letzten Test erzeugt

Ergebnis:

Mission Generator erzeugt priorisierte State-Missionen aus gefilterten Kampagnenzonen und berücksichtigt FOB-Support.

Offen:

- Missionen nach Flugzeugtyp filtern
- direkte Missionsauswahl über F10
- Missionserfolg real auswerten
- Missionseffekte auf Capture anwenden
- Missionseffekte auf Logistics anwenden
- Missionseffekte auf AI und IADS anwenden
- Briefingtexte verbessern

---

### Phase 6 — AI Director und CAP-Manager

Status:

- **CAP-State technisch bestanden**
- **AI Director noch nicht implementiert**

Aktuell vorhanden:

- `src/ai/tc_ai_cap_manager.lua`

Erledigt:

- CAP-Zonen aus klassifizierten Kampagnenzonen ableitbar
- CAP-Anforderungen speicherbar
- aktive CAPs verwaltbar
- abgeschlossene CAPs verwaltbar
- fehlgeschlagene CAPs verwaltbar
- Prioritäten vorbereitet
- Bedrohungsstatus vorbereitet
- 31 CAP-Kandidaten erkannt
- 12 CAP-Zonen auto-registriert
- 12 CAP Requests erzeugt
- Blue CAP für Akrotiri vorbereitet
- Red CAPs für strategische syrische Flugplätze vorbereitet

Ergebnis:

CAP Manager arbeitet aktuell als State-System.  
Echte MOOSE-Spawns sind noch offen.

Offen:

- MOOSE-Anbindung für reale CAP-Spawns
- MOOSE-Templates im Mission Editor anlegen
- AI Director erstellen
- GCI Manager erstellen
- Counterattack-System erstellen
- AI-Reaktionen auf Capture vorbereiten
- AI-Reaktionen auf IADS-Schäden vorbereiten
- Blue- und Red-Operationen unabhängig vom Spieler planen lassen
- AI-System funktional mit echten DCS-Gruppen testen

---

### Phase 7 — UI und F10-Menüs

Status:

- **erste Version technisch bestanden**

Aktuell vorhanden:

- `src/ui/tc_f10_menu.lua`

Erledigt:

- erstes Theater-Command-F10-Menü erstellt
- Blue-Coalition-Menü erstellt
- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Top-Mission aktivieren
- Kampagnenstatus anzeigen
- Logistikstatus anzeigen
- FOB-Status anzeigen
- AI-CAP-Status anzeigen
- F10-Menü in DCS sichtbar
- F10-Menü navigierbar
- 7 Commands im Log bestätigt

Ergebnis:

Die erste spielerseitige UI existiert und ist getestet.

Offen:

- direkte Missionsauswahl 1 bis 10
- Missionsdetails pro Mission
- aktive Mission abbrechen
- Mission completed/failed über F10 oder Debug
- Debug-Menü getrennt von Spieler-Menü
- spätere Statusseiten verbessern

---

### Phase 8 — IADS-System

Status:

- **dokumentiert, noch nicht implementiert**

Ziele:

- rote IADS-Struktur vorbereiten
- SAM-Sites als Kampagnenobjekte verwalten
- Radarstellungen als Kampagnenobjekte verwalten
- IADS-Sektoren definieren
- Skynet IADS kapseln
- Missionsgenerator mit IADS-Zielen verbinden
- AI Director mit IADS-Zustand verbinden
- zerstörte IADS-Komponenten persistieren

Geplante Dateien:

- `src/iads/tc_iads_network.lua`
- `src/iads/tc_iads_sector_manager.lua`
- `src/iads/tc_iads_site_registry.lua`
- `src/iads/tc_iads_mission_bridge.lua`

Offen:

- erste IADS-Implementierung beginnen
- Skynet-IADS-Anbindung testen
- SEAD-/DEAD-Ziele erzeugen
- IADS-Zustand in Campaign State abbilden

---

### Phase 9 — Debug-System

Status:

- **dokumentiert, noch nicht implementiert**

Ziele:

- Debug-Ausgaben bündeln
- Airbase-Reports erzeugen
- Zonen-Reports erzeugen
- Capture-Reports erzeugen
- Logistik-Reports erzeugen
- FOB-Reports erzeugen
- Missions-Reports erzeugen
- AI-Reports erzeugen
- UI-Reports erzeugen
- IADS-Reports erzeugen
- Debug-State-Dumps vorbereiten
- Debug-Menü später optional aktivieren

Geplante Dateien:

- `src/debug/tc_debug_console.lua`
- `src/debug/tc_debug_state_dump.lua`
- `src/debug/tc_debug_zone_overlay.lua`
- `src/debug/tc_debug_airbase_report.lua`
- `src/debug/tc_debug_mission_report.lua`
- `src/debug/tc_debug_logistics_report.lua`
- `src/debug/tc_debug_ai_report.lua`
- `src/debug/tc_debug_iads_report.lua`

Offen:

- Debug-Grundmodul erstellen
- Airbase-Debugreport vorbereiten
- Zone-Debugreport vorbereiten
- Missions-Debugreport vorbereiten

---

### Phase 10 — Persistenz

Status:

- **In-Memory-Grundstruktur vorhanden**
- **DCS-Dateischreibtest offen**

Aktuell vorhanden:

- `src/campaign/tc_persistence_system.lua`

Ziele:

- Kampagnenzustand speichern
- Kampagnenzustand laden
- Airbase-Besitz speichern
- Zonenstatus speichern
- Capture-Zustand speichern
- Logistikstatus speichern
- FOB-Zustand speichern
- Missionsfortschritt speichern
- AI-Zustand speichern
- UI-Zustand speichern
- IADS-Zustand speichern
- Save-Dateien kontrolliert schreiben und lesen

Offen:

- DCS-Sandbox-Dateizugriff prüfen
- `save/README.md` erstellen
- `save/example_state.lua` erstellen
- echtes Save/Load praktisch testen
- Dateipersistenz erst nach Sandbox-Test produktiv umsetzen

---

### Phase 11 — Mission-Editor-Ausbau

Status:

- **DEV-Mission begonnen**

Aktuelle DEV-Mission:

- `Operation_Levant_Reclamation_DEV.miz`

Bisheriger Inhalt:

- Map: Syria
- Koalitionspreset: Modern
- Blue Start: Akrotiri / Zypern
- erster blauer Client-Slot: F/A-18C Lot 20 auf Akrotiri
- Trigger: Starttest-Variante A vollständig angelegt
- Theater-Command-F10-Menü sichtbar und navigierbar
- keine rote Frontlinie
- keine IADS-Stellungen
- keine CTLD-Zonen
- keine Template-Gruppen

Ziele:

- DEV-Mission im Repository dokumentieren
- erste CTLD-Pickup-Zonen anlegen
- erste Dropoff-Zonen anlegen
- erste Template-Gruppen vorbereiten
- erste rote IADS-Struktur anlegen
- erste Debug-Trigger oder Debug-Menüs vorbereiten
- Mission-Editor-Aufbau bewusst schlank halten

Offen:

- `mission/`-Ordnerstruktur anlegen
- `mission/dev/` dokumentieren
- DEV-Mission sauber versionieren oder zumindest dokumentieren
- Mission-Editor-Zonen später mit Lua-System verbinden

---

### Phase 12 — Teststrategie

Status:

- **mehrere State-Systeme erfolgreich in DCS getestet**

Bisher bestanden:

- Starttest-Variante A
- Airbase Scanner `v0.2.2`
- ZoneFactory `v0.2.0`
- CaptureSystem `v0.2.0`
- LogisticsDelivery `v0.2.0`
- FobSystem `v0.2.0`
- MissionGenerator `v0.2.1`
- AICapManager `v0.2.0`
- F10Menu `v0.1.0`

Noch offen:

- Starttest-Variante B
- Loader-only mit `dofile`
- DCS-Sandbox-Dateizugriff
- CTLD-Verbindung
- MOOSE-CAP-Spawn
- Skynet-IADS-Verbindung
- direkte F10-Missionsauswahl
- echte Missionserfolgsauswertung
- echte Persistenz

Ziel Variante B:

- Frameworks per `DO SCRIPT FILE` laden
- nur `src/loader.lua` per `DO SCRIPT FILE` laden
- prüfen, ob der Loader weitere Source-Dateien per `dofile` nachladen kann
- DCS-Sandbox-Verhalten bewerten
- entscheiden, ob spätere Entwicklung mit Loader-only möglich ist oder Einzeldatei-Ladung nötig bleibt

---

## 8. Aktuelle Prioritäten

### Priorität 1 — F10-Menü ausbauen

Status:

- **nächster empfohlener technischer Schritt**

Wahrscheinliche nächste Datei:

- `src/ui/tc_f10_menu.lua`

Ziel:

- nicht nur Top-Mission aktivieren
- Mission 1 bis Mission 10 direkt auswählbar machen
- Missionsdetails über F10 anzeigen
- verfügbare Missionen stabil sortieren
- weiter state-only bleiben
- keine echten MOOSE-/CTLD-Spawns auslösen

Begründung:

Mission Generator `v0.2.1` liefert stabile Missionsdaten inklusive FOB-Support.  
F10Menu `v0.1.0` ist sichtbar, navigierbar und logbestätigt.  
Der nächste sinnvolle Schritt ist direkte Missionsauswahl über F10.

---

### Priorität 2 — Missionserfolg und Missionsstatus vorbereiten

Ziel:

- aktive Missionen sinnvoll verwalten
- Missionen abschließen oder fehlschlagen lassen
- erste manuelle Debug-/F10-Funktion für Mission completed/failed vorbereiten
- später DCS-Events und Trigger koppeln

Abhängigkeit:

- F10-Auswahl stabil
- Mission Generator State stabil

---

### Priorität 3 — Persistence praktisch testen

Ziel:

- Kampagnenstand speichern
- Kampagnenstand laden
- DCS-Sandbox real prüfen

Abhängigkeit:

- ausreichend stabiler State
- klare Save-Struktur
- ggf. Debug-/State-Dump vorbereiten

---

### Priorität 4 — CTLD-Integration vorbereiten

Ziel:

- CTLD-Pickup-Zonen im Mission Editor anlegen
- Dropoff-/FOB-Zonen definieren
- CTLD-Cargo später mit Logistics Delivery und FobSystem koppeln

Noch nicht sofort:

- echte CTLD-FOBs ohne saubere Mission-Editor-Zonen
- komplexe Cargo-Wirtschaft

---

### Priorität 5 — AI Director vorbereiten

Ziel:

- beidseitige Kampagnenlogik
- Blue und Red handeln unabhängig vom Spieler
- Spieler ist Teilnehmer, nicht alleiniger Motor

Abhängigkeit:

- stabile Zonen
- stabile Missionen
- stabile Capture-/Logistics-/FOB-Daten
- erster CAP-State vorhanden
- IADS noch offen

---

### Priorität 6 — echte Framework-Integration

Später:

- MOOSE für CAP, Strike, SEAD und AI-Flüge
- CTLD für Cargo, FOB und Logistik
- Skynet IADS für Luftverteidigung
- MIST nur dort nutzen, wo es sinnvoll ist

Noch nicht sofort:

- echte MOOSE-Spawns ohne Mission-Editor-Templates
- echte CTLD-Integration ohne CTLD-Zonen
- IADS-Kampagnenlogik ohne eigene IADS-Struktur

---

## 9. Nächster technischer Schwerpunkt

Aktueller nächster Schwerpunkt:

- **F10-Menü gezielt ausbauen**

Direkt empfohlene nächste Datei:

- `src/ui/tc_f10_menu.lua`

Ziel:

- direkte Missionsauswahl 1 bis 10
- stabile Anzeige der Missionsliste
- Aktivierung einzelner Missionen
- optional Missionsdetails für ausgewählte Missionen
- weiterhin state-only
- keine echten Spawns

Danach:

- Mission completed/failed über F10 oder Debug vorbereiten
- Missionseffekte auf State anwenden
- Persistence-Sandbox-Test vorbereiten
- CTLD-Zonen im Mission Editor vorbereiten
- AI Director state-only beginnen

---

## 10. Langfristiges Zielbild

Theater Command DCS soll langfristig folgende Systeme verbinden:

- Airbase-Erkennung
- strategische Airbase-Klassifizierung
- virtuelle Kampagnenzonen
- Capture-System
- Logistiksystem
- CTLD-Anbindung
- FOB-Aufbau
- dynamische Missionsgenerierung
- F10-Spielerinteraktion
- AI Director
- CAP- und GCI-Management
- Skynet-IADS-Anbindung
- SEAD-/DEAD-Missionslogik
- Debug-Werkzeuge
- Persistenz
- Kampagnenfortschritt über mehrere Sessions

---

## 11. Nicht-Ziele für die aktuelle Phase

Aktuell wird bewusst nicht gemacht:

- keine vollständige Frontlinie bauen
- keine komplette Syria Map manuell mit Einheiten füllen
- keine komplette IADS-Großstruktur bauen
- keine komplexe KI-Kampagne mit echten Spawns bauen
- keine automatische perfekte `.miz`-Generierung bauen
- keine Multiplayer-Synchronisation lösen
- keine kommerzielle Release-Struktur vorbereiten
- keine produktive Persistenz ohne Sandbox-Test bauen
- keine All-in-one-Datei erstellen
- keine Framework-Dateien verändern

---

## 12. Arbeitsregel

Es wird immer nur **eine konkrete Aufgabe oder eine Datei pro Schritt** umgesetzt.

Neue oder ersetzte Dateien werden immer mit vollständigem Inhalt vorbereitet.

Eigene Theater-Command-Logik gehört nach:

- `src/`

Externe Frameworks gehören nach:

- `vendor/`

Frameworks werden nicht verändert.

Die eigene Lua-Struktur wird nach Aufgaben sortiert, nicht nach Frameworks.

Während aktiver Code-Arbeit soll nur die absolut notwendige Dokumentation aktualisiert werden.  
Größere Dokumentationsrunden erfolgen bevorzugt am Ende einer Session.
