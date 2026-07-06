# ARCHITECTURE.md

Diese Datei beschreibt die technische Architektur von **Theater Command DCS**.

Das Projekt ist ein modulares, dynamisches und später persistentes Kampagnensystem für DCS World.

Erste Kampagne:

- **Operation Levant Reclamation**

Map:

- **Syria**

Ausgangslage:

- Blue startet auf **Akrotiri / Zypern**
- Das syrische Festland ist zu Beginn rot kontrolliert
- Blue soll sich vom Brückenkopf Zypern aus auf das syrische Festland vorarbeiten
- Red hält zu Beginn den Großteil der strategischen Flugplätze
- Spieler sollen sich in eine laufende Kampagne einklinken, nicht jede Aktion allein auslösen
- Blue und Red sollen später eigene Operationen durchführen

---

## 1. Grundprinzip

Theater Command DCS folgt drei Grundsätzen:

- **Mission Editor = Bühne**
- **Lua = Kampagnensystem**
- **GitHub = Projektgedächtnis**

Der DCS Mission Editor stellt die Umgebung bereit:

- Karte
- Koalitionen
- Flugplätze
- Einheiten
- Client-Slots
- Trigger
- Zonen
- Templates
- Vendor-Frameworks

Die eigene Lua-Logik in `src/` erzeugt daraus einen Kampagnenzustand.

GitHub dokumentiert:

- Architektur
- Aufgaben
- Roadmap
- Changelog
- Missionsdesign
- aktuelle Teststände
- bekannte Einschränkungen
- nächste Entwicklungsschritte

---

## 2. Architekturziel

Theater Command DCS soll langfristig eine dynamische Kampagne erzeugen, in der:

- Airbases und relevante Zonen Teil eines Kampagnenzustands sind
- Blue und Red unabhängig vom Spieler handeln
- Spieler Missionen auswählen und fliegen können
- Missionen aus der Kampagnenlage entstehen
- Capture, Logistics, FOBs, AI, IADS und Persistence zusammenwirken
- Kampagnenfortschritt gespeichert und geladen werden kann

Das System ist nicht als lineare Einzelmission gedacht.

Ziel ist eine modulare Kampagnenruntime.

Der Spieler soll Teilnehmer einer laufenden Kampagne sein, nicht alleiniger Auslöser aller Kampagnenaktionen.

---

## 3. Architekturstatus

Stand: **2026-07-06**

Aktueller Stand:

- Vendor-Frameworks laden.
- Core-Systeme laden.
- World-Systeme klassifizieren Syria-Airbase-Daten.
- ZoneFactory erzeugt relevante Kampagnenzonen.
- CaptureSystem verwaltet Capture-Eligibility, Capture-Pressure und Capture-Progress.
- CaptureSystem verarbeitet abgeschlossene Mission Effects state-only in Capture Pressure.
- CaptureSystem erzeugt dynamisch Capture Ready.
- LogisticsDelivery erzeugt Logistics Hubs.
- FobSystem erzeugt FOB-Kandidaten und Blue-FOBs.
- MissionGenerator erzeugt Missionen inklusive FOB-Support.
- MissionGenerator erzeugt Objectives, Briefings, Progress-Daten, Activation Metadata, Outcome State und Effect State.
- MissionGenerator kann Missionen state-only aktivieren und abschließen.
- AICapManager erzeugt Blue-/Red-CAP-State.
- F10Menu ist sichtbar, navigierbar und unterstützt direkte Missionsauswahl.
- F10Menu unterstützt Mission Outcome Controls.
- F10Menu zeigt Capture-/Pressure-Status.
- F10Menu zeigt Capture Ready Zones.
- Main und Loader starten sauber durch.

Aktuelle Architekturklasse:

- **State-first Runtime**

Aktuelle bewusste Einschränkungen:

- keine echten Spawns
- keine produktive Persistenz
- keine echte CTLD-FOB-Erstellung
- keine produktive Skynet-IADS-Kampagnenlogik
- keine automatische Missionserfolgsauswertung aus DCS-Events
- kein automatischer produktiver Ownership-Wechsel aus Capture Ready
- keine automatische `.miz`-Generierung

---

## 4. Schichtenmodell

Die Architektur ist in Schichten aufgebaut.

Reihenfolge von unten nach oben:

1. Vendor Layer
2. Core Layer
3. World Layer
4. Campaign Layer
5. Logistics Layer
6. Mission Layer
7. AI Layer
8. IADS Layer
9. UI Layer
10. Main / Loader Layer
11. Debug / Testing Layer

Grundregel:

- Untere Schichten stellen Zustand und Basisdaten bereit.
- Obere Schichten lesen diesen Zustand und leiten daraus Aufgaben, UI oder spätere Framework-Aktionen ab.
- Echte Framework-Ausführung wird erst aktiviert, wenn der State stabil, sichtbar und testbar ist.

---

## 5. Vendor Layer

Pfad:

- `vendor/`

Aufgabe:

- externe Frameworks bereitstellen
- Framework-Dateien unverändert halten
- Frameworks laden
- Framework-Funktionen später über eigene Theater-Command-Module nutzen

Aktive Vendor-Dateien:

| Framework | Pfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD-i18n | `vendor/ctld/CTLD-i18n.lua` | geladen |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Regeln:

- Vendor-Dateien werden nicht verändert.
- Eigene Integrationslogik kommt nach `src/`.
- Es gibt keine eigenen Framework-Sammeldateien wie `tc_moose.lua`, `tc_mist.lua`, `tc_ctld.lua` oder `tc_all_in_one.lua`.

Aktuelle Nutzung:

- MIST wird geladen.
- MOOSE wird geladen.
- CTLD wird geladen.
- Skynet IADS wird geladen.
- Produktive Framework-Ausführung ist noch nicht aktiv.

---

## 6. Core Layer

Pfad:

- `src/core/`

Aktive Dateien:

- `src/core/tc_config.lua`
- `src/core/tc_logger.lua`
- `src/core/tc_state.lua`
- `src/core/tc_utils.lua`
- `src/core/tc_scheduler.lua`

Aufgabe:

- globale Konfiguration
- Logging
- zentraler State
- Hilfsfunktionen
- einfache Scheduler-/Runtime-Hilfen
- gemeinsame Konstanten
- Modulstatus
- Featurestatus

Architekturregel:

- Der Core Layer trifft keine fachlichen Kampagnenentscheidungen.
- Der Core Layer stellt gemeinsame Infrastruktur bereit.
- Fachlogik gehört in World, Campaign, Logistics, Missions, AI, IADS oder UI.

---

## 7. State-Modell

Zentraler Zustand:

- `TC.State`
- `TC.state`

Der State ist die wichtigste Integrationsfläche zwischen allen Modulen.

Aktuelle State-Bereiche:

- `State.Core`
- `State.Modules`
- `State.Features`
- `State.Bases`
- `State.Zones`
- `State.Campaign`
- `State.Logistics`
- `State.Missions`
- `State.AI`
- `State.UI`
- `State.Persistence`

Grundregel:

- Module schreiben ihren eigenen fachlichen Zustand in den State.
- Andere Module lesen diesen Zustand über definierte Tabellen oder Funktionen.
- Framework-Ausführung wird später aus dem State abgeleitet.
- Der State bleibt persistierbar.
- F10-Aktionen ändern aktuell nur State.
- Missionen ändern aktuell nur State.
- Capture Pressure und Capture Progress sind State-Daten.
- Logistics und FOBs sind State-Daten.
- AI CAP ist State-Daten.
- Mission Effects werden aktuell state-only vorbereitet und zuerst durch CaptureSystem verarbeitet.

---

## 8. World Layer

Pfad:

- `src/world/`

Aktive Dateien:

- `src/world/tc_airbase_scanner.lua`
- `src/world/tc_zone_factory.lua`

Aufgabe:

- Syria-Airbase-Daten erfassen
- Airbase-like Objects klassifizieren
- relevante Kampagnenziele identifizieren
- Kampagnenzonen erzeugen
- World-State für spätere Module bereitstellen

---

## 9. Airbase Scanner

Datei:

- `src/world/tc_airbase_scanner.lua`

Getestete Version:

- `v0.2.2`

Aufgabe:

- DCS-Airbase-Objekte erfassen
- Syria-Airbase-like Objects klassifizieren
- strategische Airfields erkennen
- sekundäre Airfields erkennen
- Heliports erkennen
- Helipads erkennen
- Medical Pads erkennen
- Tactical Pads erkennen
- unbekannte Objekte trennen
- Blue-Startbasis erkennen
- Red-Kampagnenziele vorbereiten

Bestätigte Werte:

- total: 225
- strategic: 19
- secondary: 13
- heliports: 1
- helipads: 95
- medical: 40
- farps: 0
- tactical: 13
- unknown: 44
- captureCandidates: 32
- missionCandidates: 32
- logisticsCandidates: 46
- blueStartBases: 1
- redStrategicCandidates: 18

Architekturrolle:

- Grundlage für ZoneFactory
- Grundlage für CaptureSystem
- Grundlage für LogisticsDelivery
- Grundlage für MissionGenerator
- Grundlage für AICapManager

---

## 10. Zone Factory

Datei:

- `src/world/tc_zone_factory.lua`

Getestete Version:

- `v0.2.0`

Aufgabe:

- aus klassifizierten Airbase-Daten Kampagnenzonen erzeugen
- nicht relevante Objekte herausfiltern
- Capture-Zonen markieren
- Mission-Zonen markieren
- Logistics-Zonen markieren
- Startbase-Zone markieren

Bestätigte Werte:

- total zones: 46
- classified airbase zones: 46
- Mission Editor zones: 0
- skipped airbase-like objects: 179
- strategic zones: 19
- secondary zones: 13
- heliport zones: 1
- farp zones: 0
- tactical zones: 13
- captureZones: 32
- missionZones: 32
- logisticsZones: 46
- startBaseZones: 1

Architekturrolle:

- übersetzt Airbase-Klassifizierung in Kampagnenzonen
- erzeugt die zentrale Raumstruktur der Kampagne
- trennt strategisch relevante und nicht relevante Objekte

---

## 11. Campaign Layer

Pfad:

- `src/campaign/`

Aktive Dateien:

- `src/campaign/tc_capture_system.lua`
- `src/campaign/tc_persistence_system.lua`

Aufgabe:

- Kampagnenzustand verwalten
- Ownership verwalten
- Capture-Fähigkeit prüfen
- Capture-Druck und Capture-Fortschritt verwalten
- Persistenz vorbereiten

---

## 12. Capture System

Datei:

- `src/campaign/tc_capture_system.lua`

Getestete Version:

- `v0.2.2`

Aufgabe:

- Ownership von Basen und Zonen verwalten
- Capture-Eligibility bestimmen
- nicht geeignete Objekte ausschließen
- Linked Airbase/Zone Ownership synchronisieren
- Capture Events speichern
- Capture Pressure erzeugen
- Capture Progress erzeugen
- abgeschlossene Mission Effects state-only in Capture Pressure übernehmen
- Capture Ready und Pressure Contested erkennen
- Capture Ready Zones für F10 bereitstellen
- produktiven Ownership-Wechsel bewusst getrennt halten

Bestätigte Startwerte:

- eligibleBases: 32
- eligibleZones: 32
- nonCaptureBases: 193
- nonCaptureZones: 14
- pressureRecords: 32
- progressRecords: 32

Bestätigte Werte nach Mission Completion:

- completed mission: `MISSION_2`
- target zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- capture pressure owner: `BLUE`
- applied pressure: 105
- progress: 100 %
- appliedMissionEffects: 1
- ready: 1
- contested: 0

Capture-fähig:

- strategische Airfields
- sekundäre Airfields
- strategische Airbase-Zonen
- sekundäre Airbase-Zonen
- definierte Mission-Editor-Capture-Zonen

Ausgeschlossen:

- einfache Helipads
- Medical Pads
- Tactical Pads
- FARP-/Sonderobjekte, solange nicht explizit freigegeben
- unbekannte Airbase-like Objects
- rein technische Objekte

Aktuelle Capture-Architektur:

- Capture ist noch nicht automatisch produktiv.
- Capture Pressure wird state-only verarbeitet.
- Capture Progress wird state-only verarbeitet.
- Mission Completion kann Capture Pressure erzeugen.
- Capture Ready kann dynamisch entstehen.
- Capture Ready Zones sind über F10 sichtbar.
- Ownership-Wechsel bleiben kontrolliert.
- Automatische produktive Ownership-Wechsel sind deaktiviert.

---

## 13. Persistence System

Datei:

- `src/campaign/tc_persistence_system.lua`

Status:

- Grundstruktur vorhanden
- lädt/startet
- produktiver Dateitest noch offen

Aufgabe:

- Kampagnenzustand speichern
- Kampagnenzustand laden
- DCS-Sandbox-Dateizugriff prüfen
- Save-Datei definieren
- Load-Reihenfolge definieren

Zukünftig zu speichern:

- Basen
- Zonen
- Ownership
- Capture Pressure
- Capture Progress
- Capture Events
- Logistics Hubs
- Deliveries
- FOBs
- Missionen
- AI State
- IADS State
- optionale UI-Daten

Aktuelle Architekturentscheidung:

- keine produktive Persistenz ohne vorherigen DCS-Sandbox-Test
- Persistence wird erst produktiv ausgebaut, wenn State-Änderungen und kontrollierter Ownership-Wechsel stabil getestet sind

---

## 14. Logistics Layer

Pfad:

- `src/logistics/`

Aktive Dateien:

- `src/logistics/tc_logistics_delivery.lua`
- `src/logistics/tc_fob_system.lua`

Aufgabe:

- Logistics Hubs aus Kampagnenzonen erzeugen
- Supply-/Fuel-/Ammo-/Engineering-Zustände vorbereiten
- Deliveries vorbereiten
- FOB-Kandidaten erzeugen
- FOBs state-only planen
- spätere CTLD-Anbindung vorbereiten

---

## 15. Logistics Delivery

Datei:

- `src/logistics/tc_logistics_delivery.lua`

Getestete Version:

- `v0.2.0`

Aufgabe:

- Logistics Hubs erzeugen
- Hub-Zustände verwalten
- Delivery-Struktur vorbereiten
- spätere CTLD-Cargo-Integration vorbereiten

Bestätigte Werte:

- logistics hubs: 46
- blue hubs: 7
- red hubs: 24
- neutral hubs: 15
- active hubs: 31
- limited hubs: 15
- locked hubs: 0

Aktuelle Architektur:

- Logistics Hubs sind State-only.
- CTLD wird noch nicht aktiv aufgerufen.
- Keine echten Cargo-Flüge.
- Keine echten Dropoffs.
- Keine echten Supply-Verbräuche.
- Logistics Effects aus Missionen sind noch nicht produktiv angewendet.

---

## 16. FOB System

Datei:

- `src/logistics/tc_fob_system.lua`

Getestete Version:

- `v0.2.0`

Aufgabe:

- FOB-Kandidaten aus Logistics Hubs ableiten
- Blue-FOBs automatisch planen
- FOB-State verwalten
- Baufortschritt vorbereiten
- Supply und Engineering vorbereiten
- CTLD-FOB-Hooks vorbereiten

Bestätigte Werte:

- FOB candidates: 6
- stored candidates: 6
- auto-planned FOBs: 2
- skipped candidates: 4
- Blue FOBs: 2

Erzeugte FOBs:

- `FOB Ercan`
- `FOB Gecitkale`

Status:

- `UNDER_CONSTRUCTION`

Aktuelle Architektur:

- FOBs sind State-only.
- Es werden noch keine CTLD-FOBs erzeugt.
- Baufortschritt wird noch nicht durch echte Cargo-Lieferungen beeinflusst.
- FOBs können bereits vom MissionGenerator für FOB-Support genutzt werden.

---

## 17. Mission Layer

Pfad:

- `src/missions/`

Aktive Datei:

- `src/missions/tc_mission_generator.lua`

Getestete Version:

- `v0.2.3`

Aufgabe:

- Missionen aus Kampagnenlage erzeugen
- Missionspool verwalten
- Missionen priorisieren
- FOB-Support berücksichtigen
- Missionen über F10 aktivierbar machen
- Mission Records fachlich anreichern
- Mission Outcomes vorbereiten
- Mission Effects vorbereiten
- spätere Spawn-Hooks reservieren

Bestätigte Werte:

- mission candidates: 78
- fobSupportCandidates: 2
- generated missions: 10
- reservedCreated: 1
- duplicatesSkipped: 1
- typeLimitSkipped: 68

Aktuelle Missionstypen:

- `RECON`
- `STRIKE`
- `SEAD`
- `DEAD`
- `CAS`
- `INTERDICTION`
- `ESCORT`
- `CAP`
- `LOGISTICS`
- `FOB_SUPPORT`
- `AIRBASE_ATTACK`
- `IADS_SUPPRESSION`

Aktuelle Mission Records enthalten:

- ID
- Key
- Name
- Type
- Status
- Owner
- Source Base
- Target Zone
- Target Base
- Target FOB
- Priority
- Strategic Relevance
- Objective
- Briefing
- Recommended Aircraft
- Recommended Payload
- Progress
- Activation Metadata
- Outcome State
- Effect State
- Execution Plan
- Effects
- reserved MOOSE hook
- reserved CTLD hook
- reserved Skynet hook

Aktuelle Architektur:

- Missionen sind State-only.
- Aktivierung setzt Missionen auf `ACTIVE`.
- Aktivierung triggert keine echten Spawns.
- Spawn-Hooks bleiben reserviert.
- Completion setzt Missionen auf `COMPLETED`.
- Mission Completion bereitet Effects vor.
- CaptureSystem kann abgeschlossene Mission Effects verarbeiten.
- Failure, Cancelled und Expired sind vorbereitet, aber noch nicht praktisch getestet.

---

## 18. AI Layer

Pfad:

- `src/ai/`

Aktive Datei:

- `src/ai/tc_ai_cap_manager.lua`

Geplante spätere Datei:

- `src/ai/tc_ai_director.lua`

---

## 19. AI CAP Manager

Datei:

- `src/ai/tc_ai_cap_manager.lua`

Getestete Version:

- `v0.2.0`

Aufgabe:

- CAP-Zonen aus Kampagnenlage ableiten
- CAP-Anforderungen erzeugen
- Blue-/Red-CAP-State vorbereiten
- spätere MOOSE-CAP-Anbindung vorbereiten

Bestätigte Werte:

- cap zone candidates: 31
- auto-registered CAP zones: 12
- CAP requests: 12
- reactionState: `AIR_REACTION_REQUESTED`
- threatLevel: `HIGH`

Aktuelle Architektur:

- CAP ist State-only.
- MOOSE wird noch nicht produktiv genutzt.
- `spawn=MOOSE_PENDING` ist erwartetes Verhalten.

---

## 20. AI Director

Status:

- noch nicht implementiert

Geplante Datei:

- `src/ai/tc_ai_director.lua`

Ziel:

- Blue und Red sollen eigenständig Kampagnenentscheidungen treffen.

Der AI Director soll später bewerten:

- Besitzstatus
- Capture Progress
- Capture Ready
- aktive Missionen
- verfügbare Missionen
- Logistics
- FOBs
- CAP-Lage
- IADS
- Verluste
- Ressourcen
- Frontlage

Zielverhalten:

- Blue plant offensive und defensive Operationen.
- Red plant offensive und defensive Operationen.
- beide Seiten erzeugen Bedarf für Missionen.
- beide Seiten reagieren auf Kampagnenzustand.
- Spieler ist Teilnehmer einer laufenden Lage.

Aktuelle Architekturentscheidung:

- AI Director kommt erst nach besserer F10-/Debug-Sichtbarkeit.
- AI Director startet später state-only und ohne echte Spawns.

---

## 21. IADS Layer

Pfad:

- `src/iads/`

Vendor:

- `vendor/skynet-iads/SkynetIADS.lua`

Status:

- Vendor geladen
- eigenes Modul noch nicht implementiert

Geplante Datei:

- `src/iads/tc_iads_system.lua`

Ziel:

- Skynet IADS in die Kampagne einbinden
- IADS-Sites mit Zonen verbinden
- SEAD/DEAD/IADS_SUPPRESSION-Missionen fachlich wirksam machen
- IADS-Status für AI und Mission Generator nutzbar machen
- IADS-Zustand persistieren

Aktuelle Architektur:

- Skynet IADS wird geladen.
- Es gibt noch keine Theater-Command-IADS-Brücke.
- MissionGenerator reserviert bereits Skynet-Hooks.
- Keine echte IADS-Kampagnenlogik aktiv.

---

## 22. UI Layer

Pfad:

- `src/ui/`

Aktive Datei:

- `src/ui/tc_f10_menu.lua`

Getestete Version:

- `v0.2.2`

Aufgabe:

- F10-Spielerinterface bereitstellen
- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Missionen direkt auswählen
- Missionen direkt aktivieren
- Mission Outcome Controls bereitstellen
- Kampagnenstatus anzeigen
- Capture-/Pressure-Status anzeigen
- Capture Ready Zones anzeigen
- Pressure Contested Zones anzeigen
- Logistikstatus anzeigen
- FOB-Status anzeigen
- AI-CAP-Status anzeigen

Bestätigt:

- F10-Menü sichtbar
- F10-Menü navigierbar
- 32 Commands erzeugt
- Mission Details Slot 1 bestätigt
- Mission Slot 1 aktiviert
- Active Mission Outcome Status bestätigt
- Complete Active Mission 1 bestätigt
- Capture Status bestätigt
- Capture Ready Zones nach Mission Completion bestätigt
- Pressure Contested Zones bestätigt
- MissionGenerator setzt aktivierte Missionen auf `ACTIVE`
- MissionGenerator setzt abgeschlossene Missionen auf `COMPLETED`
- CaptureSystem verarbeitet abgeschlossene Mission Effects

Aktuelle Menüstruktur:

- `Theater Command`
  - `Missions`
    - `Show Available Missions`
    - `Show Active Missions`
    - `Mission Details`
      - `Show Mission 1 Details` bis `Show Mission 10 Details`
    - `Activate Mission`
      - `Activate Mission 1` bis `Activate Mission 10`
    - `Mission Outcome`
      - `Show Active Mission Outcome Status`
      - `Complete Active Mission 1`
      - `Fail Active Mission 1`
  - `Status`
    - `Show Campaign Status`
    - `Show Capture Status`
    - `Show Capture Ready Zones`
    - `Show Pressure Contested Zones`
  - `Logistics`
    - `Show Logistics Status`
    - `Show FOB Status`
  - `AI`
    - `Show AI CAP Status`

Aktuelle Architektur:

- UI liest State.
- UI ruft sichere State-Funktionen auf.
- UI triggert keine echten Spawns.
- UI triggert keine CTLD-Aktionen.
- UI triggert keine Skynet-Aktionen.
- UI ist aktuell das wichtigste Test- und Sichtbarkeitsinstrument.

Nächster UI-Schritt:

- kontrollierten state-only Ownership-Wechsel aus Capture Ready Zone 1 vorbereiten
- kein automatischer Besitzwechsel ohne F10-/Debug-Bestätigung

---

## 23. Main / Loader Layer

Aktive Dateien:

- `src/main.lua`
- `src/loader.lua`

Aufgabe:

- Systeme initialisieren
- Ladezustand prüfen
- Framework-Verfügbarkeit prüfen
- Runtime-Systeme starten
- Fehler sichtbar machen

Aktuelle Architektur:

- Einzeldateien werden im Mission Editor geladen.
- `main.lua` startet die Runtime-Systeme.
- `loader.lua` prüft danach die Umgebung und beendet sauber.
- Loader-only-Ladung ist noch nicht aktiv.

Aktuelle Ladefolge:

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

---

## 24. Debug / Testing Layer

Pfad:

- `src/debug/`

Status:

- Ordner vorgesehen
- eigenes Debug-System noch nicht implementiert

Aktuelle Testmethode:

- DCS-Logauswertung
- `[TC]`-Logmarker
- manuelle F10-Tests
- Modulversionen im Log
- Testwerte aus Runtime-Zusammenfassungen
- weitergeführte Logs mit sauberer zeitlicher Trennung, falls DCS nicht neu gestartet wurde

Geplante Debug-Funktionen:

- State Dump
- Airbase Report
- Zone Report
- Capture Report
- Logistics Report
- FOB Report
- Mission Report
- AI Report
- IADS Report
- UI Report
- Debug-F10-Menü

Aktuelle Architekturentscheidung:

- Debug-Funktionen kommen später.
- Kurzfristig wird das bestehende F10-Menü um notwendige Status- und Kontrollfunktionen erweitert.

---

## 25. Aktuelle State-Integrationen

Aktueller Datenfluss:

1. Airbase Scanner erzeugt klassifizierte Airbase-Daten.
2. ZoneFactory erzeugt relevante Kampagnenzonen.
3. CaptureSystem nutzt Basen und Zonen für Capture-Eligibility, Pressure und Progress.
4. LogisticsDelivery nutzt Logistics-Zonen für Logistics Hubs.
5. FobSystem nutzt Logistics Hubs für FOB-Kandidaten und Blue-FOBs.
6. MissionGenerator nutzt Zonen, Capture, Logistics und FOBs für Missionen.
7. MissionGenerator erzeugt Mission Effects nach Mission Completion.
8. CaptureSystem verarbeitet abgeschlossene Mission Effects.
9. CaptureSystem erzeugt Capture Pressure, Capture Progress und Capture Ready.
10. AICapManager nutzt Zonen und Ownership für CAP-State.
11. F10Menu zeigt Missionen, Campaign, Capture, Logistics, FOB und AI State an.
12. F10Menu erlaubt state-only Mission Activation und Mission Completion.
13. Main startet die Runtime.
14. Loader prüft die Umgebung.

Aktuell vollständig bestätigt:

- Mission Completion zu Capture Effect
- Mission Effect zu Capture Pressure
- Capture Pressure zu Capture Progress
- Capture Progress zu Capture Ready
- Capture Ready zu F10-Anzeige

Aktuell noch nicht vollständig verbunden:

- Mission Failure zu Capture/Logistics/AI/IADS Effect
- Mission Completion zu Logistics Effect
- Mission Completion zu AI Effect
- Mission Completion zu IADS Effect
- CTLD zu Logistics/FOB
- MOOSE zu CAP/Mission Packages
- Skynet zu IADS-State
- Persistence zu vollständigem State
- AI Director zu Gesamtstrategie
- Capture Ready zu kontrolliertem Ownership-Wechsel

---

## 26. Framework-Integrationsstrategie

Theater Command nutzt Frameworks nicht direkt als Architekturordnung.

Frameworks sind Werkzeuge.

Eigene Logik bleibt fachlich sortiert.

Geplante Zuordnung:

| Funktion | Framework |
|---|---|
| Airbase/Utility/DB/Events | MIST nach Bedarf |
| CAP/Strike/SEAD/DEAD/CAS | MOOSE |
| Cargo/Transport/FOB | CTLD |
| IADS/SAM/EWR | Skynet IADS |
| Kampagnenlogik | eigene Lua-Module |
| State/Persistence | eigene Lua-Module |
| F10/UI | native DCS-Funktionen und eigene Lua-Module |

Aktueller Stand:

- Frameworks sind geladen.
- Produktive Ausführung folgt später.
- State-Systeme werden zuerst stabilisiert.
- Keine echten Framework-Aktionen ohne vorherige Templates, Zonen und Testpfade.

---

## 27. Sicherheitsprinzip der aktuellen Runtime

Aktuell gilt:

- kein echter Spawn
- keine echte CTLD-Aktion
- keine echte Skynet-Aktion
- keine produktive Persistenz
- keine automatischen Kampagnenfolgen ohne Test
- keine Änderung an Vendor-Dateien
- kein automatischer Ownership-Wechsel ohne bewussten F10-/Debug-Pfad

Grund:

- DCS-Missionen sind schwer zu debuggen.
- Jede Schicht muss einzeln stabil sein.
- State muss sichtbar und testbar sein.
- Framework-Ausführung wird erst später aktiviert.
- Ownership-Wechsel müssen vor Persistenz und AI Director sauber kontrolliert sein.

---

## 28. Mission Editor Architektur

Aktuell:

- sichere Einzeldatei-Ladung über `DO SCRIPT FILE`

Grund:

- DCS bettet per `DO SCRIPT FILE` Dateien in die `.miz` ein.
- Jede geänderte Datei muss im Mission Editor erneut ausgewählt und gespeichert werden.
- Einzeldatei-Ladung macht Fehlerquellen besser sichtbar.

Langfristig möglich:

- Loader-only-Ladung
- ein einzelner Trigger lädt `src/loader.lua`
- Loader lädt weitere Dateien per `dofile`
- dafür muss der DCS-Sandbox-Dateizugriff sicher funktionieren

Aktuelle Entscheidung:

- Einzeldatei-Ladung bleibt Standard, bis Loader-only praktisch getestet ist.

---

## 29. Akzeptierte technische Einschränkungen

Aktuell akzeptiert:

- mehr manuelle Arbeit im Mission Editor
- keine echten Spawns
- keine echte Persistenz
- keine echte CTLD-Verbindung
- keine echte Skynet-Verbindung
- keine automatische Missionserfolgsauswertung
- keine automatische `.miz`-Generierung
- keine automatische produktive Capture-Auswertung

Nicht akzeptiert:

- unstrukturierte All-in-one-Dateien
- Vendor-Dateien ändern
- Frameworklogik mit Kampagnenlogik vermischen
- neue große Systeme ohne vorherige Sichtbarkeit im State
- mehrere große Aufgaben parallel bearbeiten
- automatischer Ownership-Wechsel ohne kontrollierten Testpfad

---

## 30. Aktuelle modulübergreifende Pipeline

Aktuell bestätigte Pipeline:

1. F10Menu zeigt Missionen an.
2. F10Menu aktiviert Mission 1.
3. MissionGenerator setzt `MISSION_2` auf `ACTIVE`.
4. F10Menu setzt aktive Mission 1 auf `COMPLETED`.
5. MissionGenerator bereitet Mission Effects vor.
6. CaptureSystem verarbeitet den abgeschlossenen Mission Effect.
7. CaptureSystem erhöht Capture Pressure auf `ZONE_AIRBASE_ABU_AL_DUHUR`.
8. CaptureSystem aktualisiert Capture Progress auf 100 %.
9. CaptureSystem setzt `ready=1`.
10. F10Menu zeigt Capture Status.
11. F10Menu zeigt Capture Ready Zones.

Bestätigte Werte:

- mission: `MISSION_2`
- zone: `ZONE_AIRBASE_ABU_AL_DUHUR`
- owner: `BLUE`
- pressure: 105
- progress: 100 %
- appliedMissionEffects: 1
- ready: 1
- contested: 0

Architekturbedeutung:

- Das ist der erste vollständig bestätigte Kampagnenzusammenhang über mehrere Module hinweg.
- Die Pipeline bleibt state-only.
- Sie löst keine echten Framework-Aktionen aus.

---

## 31. Nächster architektonischer Schritt

Empfohlene nächste Datei:

- `src/ui/tc_f10_menu.lua`

Ziel:

- kontrollierten state-only Ownership-Wechsel aus Capture Ready Zone 1 vorbereiten

Neue mögliche UI-Funktion:

- `Apply Capture Ready Zone 1`
- oder `Confirm Capture Ready Zone 1`

Warum UI zuerst:

- CaptureSystem erzeugt Capture Ready.
- F10Menu kann Capture Ready Zones anzeigen.
- Ein Ownership-Wechsel darf nicht automatisch und unsichtbar passieren.
- Ein bewusster F10-/Debug-Pfad ist sicherer.
- Der Schritt bleibt state-only.
- Die bestehende UI ist bereits stabil.
- Danach kann Persistence sinnvoller getestet werden.

Akzeptanzkriterien:

- F10Menu lädt als neue Version.
- bisherige 32 Commands bleiben erhalten.
- neuer Capture-Apply-Command wird ergänzt.
- Capture Ready Zone 1 kann bewusst angewendet werden.
- Zone Ownership wird state-only aktualisiert.
- Linked Airbase Ownership wird kontrolliert über bestehende CaptureSystem-Funktion synchronisiert.
- Capture Pressure wird nach erfolgreichem Ownership-Wechsel zurückgesetzt oder sauber markiert.
- Logmarker zeigen eindeutig den Ownership-Wechsel.
- keine echten Spawns
- keine CTLD-Aktion
- keine Skynet-Aktion
- keine Lua-Fehler
- keine Theater-Command-Fehler

---

## 32. Architekturabschlussstand

Bestandene Systeme:

| System | Version | Status |
|---|---:|---|
| Airbase Scanner | `v0.2.2` | bestanden |
| ZoneFactory | `v0.2.0` | bestanden |
| CaptureSystem | `v0.2.2` | bestanden |
| LogisticsDelivery | `v0.2.0` | bestanden |
| FobSystem | `v0.2.0` | bestanden |
| MissionGenerator | `v0.2.3` | bestanden |
| AICapManager | `v0.2.0` | bestanden |
| F10Menu | `v0.2.2` | bestanden |

Aktuelle Architektur ist stabil genug für den nächsten kontrollierten Capture-Ownership-Test.

Der empfohlene nächste Schritt bleibt bewusst klein:

- nicht MOOSE
- nicht CTLD
- nicht Skynet
- nicht AI Director
- nicht Persistenz als Erstes

Sondern:

- Capture Ready bewusst anwenden
- state-only Ownership-Wechsel prüfen
- danach Persistenz- und Failure-Pfade vorbereiten
