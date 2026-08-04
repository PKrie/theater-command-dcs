# src/ui/README.md

## Autoritativer UI-Stand — 2026-08-04

- F10Menu `v0.2.3` erzeugt 33 Befehle.
- Es existieren keine Persistence-F10-Controls und für diese Entwicklungsstufe sind keine geplant; Autosave benötigt keine Spielerinteraktion.
- Missionslisten lesen die Mission-State-Dictionaries. Im aktuellen reproduzierten Defekt sind alle sechs Status-Collections leer, daher sieht das Menü keine auswählbare Mission; die früher bestätigten Auswahl-/Outcome-Flows bleiben historische Regressionsergebnisse.
- Der UI-Code ist nicht als Writer des Record-Verlusts belegt: Für Sortierung werden temporäre Arrays verwendet. Statische Gesamtklassifikation: `PROJECT SOURCE HAS NO MATCHING WRITE SITE`.
- Nächster Schritt ist der Offline/read-only Embedded Mission Resource Audit, nicht eine neue F10-Funktion. Abweichende ältere Angaben unten sind historische Stände.

---

Diese Datei beschreibt den UI-Bereich von **Theater Command DCS**.

Der UI-Bereich enthält eigene Lua-Logik für Spielerinteraktion, F10-Menüs, Statusanzeigen und spätere Debug-/Kampagnensteuerung.

Erste Kampagne:

- **Operation Levant Reclamation**

Map:

- **Syria**

Ausgangslage:

- Blue startet auf **Akrotiri / Zypern**
- das syrische Festland ist zu Beginn rot kontrolliert
- Red hält zu Beginn den Großteil der strategischen Flugplätze
- Blue soll sich vom Brückenkopf Zypern aus auf das syrische Festland vorarbeiten
- Spieler sollen sich in eine laufende Kampagnenlage einklinken, nicht jede Aktion allein auslösen
- Blue und Red sollen später eigene Operationen durchführen

---

## 1. Zweck des UI-Bereichs

`src/ui/` ist die Schnittstelle zwischen Spieler und Theater-Command-Kampagnenzustand.

Langfristig soll UI ermöglichen:

- Kampagnenstatus anzeigen
- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Missionen auswählen
- Missionen aktivieren
- Mission Outcome Controls nutzen
- Missionsdetails anzeigen
- Capture Status anzeigen
- Capture Ready Zones anzeigen
- Pressure Contested Zones anzeigen
- Logistikstatus anzeigen
- FOB-Status anzeigen
- AI-Status anzeigen
- spätere IADS-Informationen anzeigen
- spätere Debug-Informationen anzeigen
- spätere Save/Load- oder Admin-Funktionen anbieten

Aktuell ist der UI-Bereich aktiv und getestet.

Das F10-Menü ist sichtbar, navigierbar und bereits mit MissionGenerator und CaptureSystem verbunden.

---

## 2. Aktueller technischer Stand

Historischer Stand: **2026-07-06**

Aktive Datei:

```text
src/ui/tc_f10_menu.lua
```

Historisch getestete Version in diesem Abschnitt:

```text
v0.2.2
```

Status:

- **bestanden**

Bestätigt durch DCS-Logtests:

- F10Menu lädt.
- F10Menu startet.
- F10Menu erzeugt 32 Commands.
- F10-Menü ist in DCS sichtbar.
- F10-Menü ist navigierbar.
- Missionen können angezeigt werden.
- aktive Missionen können angezeigt werden.
- Missionsdetails können pro Slot angezeigt werden.
- Missionen können direkt aktiviert werden.
- Mission Outcome Controls sind vorhanden.
- Active Mission Outcome Status kann angezeigt werden.
- Active Mission 1 kann auf `COMPLETED` gesetzt werden.
- MissionGenerator setzt aktivierte Missionen auf `ACTIVE`.
- MissionGenerator setzt abgeschlossene Missionen auf `COMPLETED`.
- MissionGenerator bereitet Mission Effects state-only vor.
- CaptureSystem verarbeitet abgeschlossene Mission Effects.
- CaptureSystem erzeugt Capture Pressure.
- CaptureSystem aktualisiert Capture Progress.
- Capture Ready entsteht dynamisch.
- Capture Ready Zones sind über F10 sichtbar.
- Pressure Contested Zones sind über F10 sichtbar.
- Aktivierung bleibt state-only.
- Completion bleibt state-only.
- Es werden keine echten Spawns ausgelöst.
- Es gab keinen Theater-Command-Lua-Fehler.
- Es gab keinen Lua-Stacktrace.

---

## 3. Historische Menüstruktur vor v0.2.3

Aktuelle F10-Struktur:

```text
F10
└── Theater Command
    ├── Missions
    │   ├── Show Available Missions
    │   ├── Show Active Missions
    │   ├── Mission Details
    │   │   ├── Show Mission 1 Details
    │   │   ├── Show Mission 2 Details
    │   │   ├── Show Mission 3 Details
    │   │   ├── Show Mission 4 Details
    │   │   ├── Show Mission 5 Details
    │   │   ├── Show Mission 6 Details
    │   │   ├── Show Mission 7 Details
    │   │   ├── Show Mission 8 Details
    │   │   ├── Show Mission 9 Details
    │   │   └── Show Mission 10 Details
    │   ├── Activate Mission
    │   │   ├── Activate Mission 1
    │   │   ├── Activate Mission 2
    │   │   ├── Activate Mission 3
    │   │   ├── Activate Mission 4
    │   │   ├── Activate Mission 5
    │   │   ├── Activate Mission 6
    │   │   ├── Activate Mission 7
    │   │   ├── Activate Mission 8
    │   │   ├── Activate Mission 9
    │   │   └── Activate Mission 10
    │   └── Mission Outcome
    │       ├── Show Active Mission Outcome Status
    │       ├── Complete Active Mission 1
    │       └── Fail Active Mission 1
    ├── Status
    │   ├── Show Campaign Status
    │   ├── Show Capture Status
    │   ├── Show Capture Ready Zones
    │   └── Show Pressure Contested Zones
    ├── Logistics
    │   ├── Show Logistics Status
    │   └── Show FOB Status
    └── AI
        └── Show AI CAP Status
```

Historisch bestätigte Commands:

```text
commands: 32
```

---

## 4. Historische F10-Funktionen vor v0.2.3

Historisch unterstützte F10Menu `v0.2.2`:

- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Mission 1 Details anzeigen
- Mission 2 Details anzeigen
- Mission 3 Details anzeigen
- Mission 4 Details anzeigen
- Mission 5 Details anzeigen
- Mission 6 Details anzeigen
- Mission 7 Details anzeigen
- Mission 8 Details anzeigen
- Mission 9 Details anzeigen
- Mission 10 Details anzeigen
- Mission 1 aktivieren
- Mission 2 aktivieren
- Mission 3 aktivieren
- Mission 4 aktivieren
- Mission 5 aktivieren
- Mission 6 aktivieren
- Mission 7 aktivieren
- Mission 8 aktivieren
- Mission 9 aktivieren
- Mission 10 aktivieren
- Active Mission Outcome Status anzeigen
- Active Mission 1 auf `COMPLETED` setzen
- Active Mission 1 auf `FAILED` setzen
- Kampagnenstatus anzeigen
- Capture Status anzeigen
- Capture Ready Zones anzeigen
- Pressure Contested Zones anzeigen
- Logistikstatus anzeigen
- FOB-Status anzeigen
- AI-CAP-Status anzeigen

Bestätigt getestet:

- Mission Details Slot 1
- Mission Slot 1 aktivieren
- Active Mission Outcome Status anzeigen
- Active Mission 1 auf `COMPLETED` setzen
- Capture Status anzeigen
- Capture Ready Zones anzeigen
- Pressure Contested Zones anzeigen
- Logistics Status anzeigen
- FOB Status anzeigen
- AI CAP Status anzeigen

Noch nicht praktisch bestätigt:

- `Fail Active Mission 1`

---

## 5. Verhältnis zu MissionGenerator

F10Menu ist aktuell eng mit MissionGenerator verbunden.

Aktive MissionGenerator-Datei:

```text
src/missions/tc_mission_generator.lua
```

Getestete Version:

```text
v0.2.3
```

MissionGenerator liefert:

- verfügbare Missionen
- aktive Missionen
- Missionsdetails
- Mission Status
- Mission Objectives
- Mission Briefings
- Mission Progress
- Activation Metadata
- Outcome State
- Effect State
- reserved Spawn Hooks

F10Menu nutzt diese Daten, um:

- Missionen zu sortieren
- Mission Slots 1 bis 10 darzustellen
- Missionsdetails pro Slot anzuzeigen
- Missionen über F10 zu aktivieren
- Active Mission Outcome Status anzuzeigen
- aktive Mission 1 state-only abzuschließen
- Aktivierung an MissionGenerator weiterzugeben
- Completion an MissionGenerator weiterzugeben

Bestätigte MissionGenerator-Werte:

```text
mission candidates: 78
fobSupportCandidates: 2
generated missions: 10
reservedCreated: 1
duplicatesSkipped: 1
typeLimitSkipped: 68
```

Bestätigte Aktivierung:

```text
[TC] [F10Menu] Mission activated through F10: slot=1 key=MISSION_2
[TC] [MissionGenerator] Mission status changed: MISSION_2 [ACTIVE]
[TC] [MissionGenerator] Mission activation prepared: MISSION_2 stateOnly=true spawnHooks=reserved
```

Bestätigte Completion:

```text
[TC] [F10Menu] Mission completed through F10: slot=1 key=MISSION_2 stateOnly=true effects=prepared
[TC] [MissionGenerator] Mission effects prepared state-only: MISSION_2 status=COMPLETED
[TC] [MissionGenerator] Mission outcome prepared: MISSION_2 [COMPLETED] stateOnly=true effects=prepared
```

Wichtig:

- F10Menu aktiviert Missionen aktuell nur state-only.
- F10Menu schließt Missionen aktuell nur state-only ab.
- Es werden keine echten MOOSE-, CTLD- oder Skynet-Aktionen ausgelöst.

---

## 6. Verhältnis zu CaptureSystem

CaptureSystem ist inzwischen im F10-Menü sichtbar und praktisch mit Mission Outcome verbunden.

Aktive Capture-Datei:

```text
src/campaign/tc_capture_system.lua
```

Getestete Version:

```text
v0.2.2
```

Bestätigte Startwerte:

```text
eligibleBases: 32
eligibleZones: 32
nonCaptureBases: 193
nonCaptureZones: 14
pressureRecords: 32
progressRecords: 32
appliedMissionEffects: 0
ready: 0
contested: 0
```

Bestätigte Werte nach Mission Completion:

```text
completed mission: MISSION_2
target zone: ZONE_AIRBASE_ABU_AL_DUHUR
capture pressure owner: BLUE
applied pressure: 105
progress: 100 %
appliedMissionEffects: 1
ready: 1
contested: 0
```

Aktive F10-Funktionen:

```text
Show Capture Status
Show Capture Ready Zones
Show Pressure Contested Zones
```

Bestätigte Capture-Folge:

```text
[TC] [CaptureSystem] Capture pressure added: zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE amount=105 progress=100%
[TC] [CaptureSystem] Mission effect applied to capture: mission=MISSION_2 zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE pressure=105
[TC] [CaptureSystem] Completed mission effects processed: applied=1, skipped=0, failed=0, appliedMissionEffects=1
[TC] [CaptureSystem] Capture progress updated: zones=32, ready=1, contested=0, appliedMissionEffects=1
[TC] [F10Menu] Capture ready zones shown through F10
```

Bewertung:

- Capture-/Pressure-Sichtbarkeit ist bestanden.
- Capture Ready Zones sind über F10 sichtbar.
- Pressure Contested Zones sind über F10 sichtbar.
- Der frühere nächste UI-Schritt „Capture-/Pressure-Status sichtbar machen“ ist erledigt.

Nächster UI-Schritt:

```text
Apply Capture Ready Zone 1
```

Ziel:

- kontrollierter state-only Ownership-Wechsel aus Capture Ready Zone 1
- kein automatischer Besitzwechsel ohne Spieler-/Debug-Bestätigung

---

## 7. Verhältnis zu LogisticsDelivery

F10Menu zeigt Logistikstatus an.

Aktive Logistics-Datei:

```text
src/logistics/tc_logistics_delivery.lua
```

Getestete Version:

```text
v0.2.0
```

Bestätigte Werte:

```text
logistics hubs: 46
blue hubs: 7
red hubs: 24
neutral hubs: 15
active hubs: 31
limited hubs: 15
locked hubs: 0
```

Aktuelle F10-Funktion:

```text
Show Logistics Status
```

Bewertung:

- Logistics-Status ist über F10 erreichbar.
- Die Darstellung kann später erweitert werden.
- CTLD-Aktionen sind noch nicht produktiv angebunden.

---

## 8. Verhältnis zu FobSystem

F10Menu zeigt FOB-Status an.

Aktive FOB-Datei:

```text
src/logistics/tc_fob_system.lua
```

Getestete Version:

```text
v0.2.0
```

Bestätigte Werte:

```text
FOB candidates: 6
stored candidates: 6
auto-planned FOBs: 2
skipped candidates: 4
Blue FOBs: 2
```

Erzeugte FOBs:

```text
FOB Ercan
FOB Gecitkale
```

Status:

```text
UNDER_CONSTRUCTION
```

Aktuelle F10-Funktion:

```text
Show FOB Status
```

Bewertung:

- FOB-Status ist über F10 erreichbar.
- FOBs sind aktuell state-only.
- Es werden noch keine echten CTLD-FOBs erzeugt.

---

## 9. Verhältnis zu AICapManager

F10Menu zeigt AI-CAP-Status an.

Aktive AI-Datei:

```text
src/ai/tc_ai_cap_manager.lua
```

Getestete Version:

```text
v0.2.0
```

Bestätigte Werte:

```text
cap zone candidates: 31
auto-registered CAP zones: 12
CAP requests: 12
reactionState: AIR_REACTION_REQUESTED
threatLevel: HIGH
```

Aktuelle F10-Funktion:

```text
Show AI CAP Status
```

Bewertung:

- AI-CAP-State ist über F10 erreichbar.
- Echte MOOSE-CAP-Spawns sind noch nicht aktiv.
- `spawn=MOOSE_PENDING` ist erwartetes Verhalten.

---

## 10. Verhältnis zu Campaign State

F10Menu zeigt inzwischen mehrere Campaign- und Capture-Bereiche.

Aktuelle F10-Funktionen:

```text
Show Campaign Status
Show Capture Status
Show Capture Ready Zones
Show Pressure Contested Zones
```

Campaign State enthält oder soll enthalten:

- Airbase-/Zone-Ownership
- Capture-Eligibility
- Capture-Pressure
- Capture-Progress
- Capture Ready
- Pressure Contested
- Mission State
- Mission Effects
- Logistics State
- FOB State
- AI State
- später IADS State
- später Persistence State

Aktueller Stand:

- F10Menu zeigt grundlegende Campaign-Informationen.
- F10Menu zeigt Capture-/Pressure-Informationen.
- Capture Ready Zones sind sichtbar.
- Pressure Contested Zones sind sichtbar.
- nächster sinnvoller UI-Schritt ist kontrollierter Capture Ready Apply.

---

## 11. Verhältnis zu Persistence

F10Menu enthält aktuell keine Save-/Load-Funktionen.

PersistenceSystem:

```text
src/campaign/tc_persistence_system.lua
```

Status:

```text
v0.2.6 implementiert
Embedded-Scheduler SAVED und SKIPPED bestanden
produktiver Restore deaktiviert
```

Es existieren keine Persistence-F10-Funktionen und für diese Entwicklungsstufe sind keine geplant. Autosave läuft ohne Spielerinteraktion.

---

## 12. Verhältnis zu IADS

F10Menu enthält aktuell keine IADS-Anzeige.

IADS-Stand:

- Skynet IADS wird geladen.
- Theater-Command-IADS-Modul ist noch nicht implementiert.
- MissionGenerator reserviert Skynet-Hooks.

Spätere mögliche F10-Funktionen:

- Show IADS Status
- Show IADS Sectors
- Show Active SAM Sites
- Show Suppressed SAM Sites
- Show Destroyed SAM Sites
- Show SEAD Targets

Aktuell nicht vorgesehen:

- IADS-F10-Funktionen als nächster Schritt

Grund:

- IADS-F10-Funktionen werden erst nach eigenem IADS-State sinnvoll.

---

## 13. UI-State

F10Menu schreibt oder nutzt UI-bezogenen State.

Mögliche UI-State-Daten:

- Menüstatus
- registrierte Commands
- letzte angezeigte Mission
- Anzahl verfügbarer Missionen
- Anzahl aktiver Missionen
- letzte Aktivierung
- letzter Mission Outcome
- letzte Statusabfrage
- letzte Capture-Anzeige
- UI-Version

Aktuell bestätigt:

```text
F10Menu initialized: commands=32
```

F10Menu kann:

- Mission Details anzeigen
- Mission Activation auslösen
- Mission Completion auslösen
- Capture Status anzeigen
- Capture Ready Zones anzeigen
- Pressure Contested Zones anzeigen

UI bleibt state-only.

---

## 14. State-only-Regel

F10Menu folgt aktuell strikt der state-first-Architektur.

Das bedeutet:

- F10 liest State.
- F10 zeigt State an.
- F10 ruft sichere Theater-Command-Funktionen auf.
- F10 aktiviert Missionen state-only.
- F10 schließt Missionen state-only ab.
- F10 zeigt Capture State.
- F10 löst keine echten DCS-Spawns aus.
- F10 ruft CTLD nicht produktiv auf.
- F10 ruft Skynet nicht produktiv auf.
- F10 verändert keine Vendor-Dateien.
- F10 löst keinen automatischen produktiven Ownership-Wechsel aus.

Diese Regel bleibt auch für die nächste Version wichtig.

---

## 15. Warum F10Menu aktuell wichtig ist

F10Menu ist aktuell die wichtigste Sichtbarkeits- und Kontrollfläche.

Grund:

- DCS-Logauswertung allein reicht nicht für spätere Kampagnensteuerung.
- Spieler brauchen Zugriff auf Missionen.
- Entwickler brauchen Zugriff auf State-Zusammenfassungen.
- Mission Activation ist über F10 bestätigt.
- Mission Completion ist über F10 bestätigt.
- Capture-Pressure und Capture-Progress sind über F10 sichtbar.
- Capture Ready ist über F10 sichtbar.
- spätere Mission Effects brauchen UI-/Debug-Kontrolle.
- Ownership-Wechsel müssen bewusst und sichtbar getestet werden.

F10Menu ist damit aktuell die Brücke zwischen State-Systemen und praktischer DCS-Bewertung.

---

## 16. Versionen und erwartete Logmarker

Aktuelle Version:

```text
F10Menu v0.2.2
```

Erwartete aktuelle Logmarker:

```text
[TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.2
[TC] [F10Menu] F10 menu started
[TC] [F10Menu] F10 menu initialized: commands=32
[TC] System started: F10 Menu
[TC] [F10Menu] Mission details shown through F10: slot=1 key=MISSION_2
[TC] [F10Menu] Mission activated through F10: slot=1 key=MISSION_2
[TC] [F10Menu] Active mission outcome status shown through F10
[TC] [F10Menu] Mission completed through F10: slot=1 key=MISSION_2 stateOnly=true effects=prepared
[TC] [F10Menu] Capture status shown through F10
[TC] [F10Menu] Capture ready zones shown through F10
[TC] [F10Menu] Pressure contested zones shown through F10
```

Erwartete nächste Version:

```text
F10Menu v0.2.3
```

Erwartete neue Logmarker nach nächstem Schritt:

```text
[TC] [F10Menu] Loaded src/ui/tc_f10_menu.lua v0.2.3
[TC] [F10Menu] F10 menu initialized:
[TC] [F10Menu] Capture ready zones shown through F10
[TC] [F10Menu] Capture ready zone applied through F10:
[TC] [CaptureSystem] Zone captured:
```

---

## 17. Aktuelle Akzeptanzkriterien

F10Menu `v0.2.2` gilt als bestanden, weil:

- Datei lädt.
- Version wird im Log angezeigt.
- Menü startet.
- 32 Commands werden erzeugt.
- F10-Menü ist sichtbar.
- F10-Menü ist navigierbar.
- Mission Details sind abrufbar.
- Mission Activation funktioniert.
- MissionGenerator setzt Missionen auf `ACTIVE`.
- Mission Completion funktioniert.
- MissionGenerator setzt Missionen auf `COMPLETED`.
- Mission Effects werden vorbereitet.
- CaptureSystem verarbeitet abgeschlossene Mission Effects.
- Capture Status ist sichtbar.
- Capture Ready Zones sind sichtbar.
- Pressure Contested Zones sind sichtbar.
- Aktivierung bleibt state-only.
- Completion bleibt state-only.
- keine echten Spawns.
- keine CTLD-Aktionen.
- keine Skynet-Aktionen.
- keine Theater-Command-Lua-Fehler.
- keine Lua-Stacktraces.

Noch offen:

- `Fail Active Mission 1` praktisch testen
- kontrollierten Capture Ready Apply implementieren und testen

---

## 18. Nächster UI-Schritt

Empfohlene nächste Datei:

```text
src/ui/tc_f10_menu.lua
```

Ziel:

```text
kontrollierter state-only Ownership-Wechsel aus Capture Ready Zone 1
```

Geplante neue F10-Funktion:

```text
Apply Capture Ready Zone 1
```

Akzeptanzkriterien:

- F10Menu lädt als neue Version.
- bisherige 32 Commands bleiben funktionsfähig.
- neuer Capture-Apply-Command wird ergänzt.
- Capture Ready Zone 1 kann bewusst angewendet werden.
- Zone Ownership wird state-only aktualisiert.
- linked Airbase Ownership wird kontrolliert über bestehende CaptureSystem-Funktion synchronisiert.
- Capture Pressure wird nach erfolgreichem Ownership-Wechsel zurückgesetzt oder sauber markiert.
- Logmarker zeigen eindeutig den Ownership-Wechsel.
- keine echten Spawns
- keine CTLD-Aktion
- keine Skynet-Aktion
- keine Lua-Fehler
- keine Theater-Command-Fehler

---

## 19. Spätere UI-Schritte

Nach kontrolliertem Capture Ready Apply:

1. `Fail Active Mission 1` praktisch testen
2. Persistence weiterhin ohne F10-Steuerung als Hintergrundsystem behandeln
3. Mission Effects auf Logistics später sichtbar machen
4. Mission Effects auf AI später sichtbar machen
5. Mission Effects auf IADS später sichtbar machen
6. AI Director Status später anzeigen
7. IADS Status später anzeigen
8. Debug-Menü getrennt aufbauen
9. Persistence-Menü in dieser Entwicklungsstufe nicht planen; jede spätere Admin-/Debug-Idee benötigt eine separate Freigabe

Mögliche spätere Menüs:

```text
Theater Command
Theater Command Debug
Theater Command Admin
Theater Command Persistence (historische Idee, aktuell nicht geplant)
```

Diese Struktur ist noch nicht final.

---

## 20. Risiken

Risiken im UI-Bereich:

- zu viele F10-Commands werden unübersichtlich
- Mission Slots können veralten, wenn Missionen dynamisch wechseln
- F10-Auswahl kann falsche Mission aktivieren, wenn Sortierung instabil ist
- Statusanzeigen können zu lang für DCS-Textausgabe werden
- F10-Funktionen können zu früh echte Framework-Aktionen auslösen
- UI kann Kampagnenlogik versehentlich selbst übernehmen
- Debug- und Spielerfunktionen können vermischt werden
- Capture Ready Apply kann Ownership unkontrolliert ändern
- Capture Pressure kann nach Ownership-Wechsel inkonsistent bleiben

Aktuelle Gegenmaßnahmen:

- stabile Missionssortierung
- feste Slots 1 bis 10
- state-only Aktivierung
- state-only Completion
- keine echten Framework-Aktionen
- klare Logmarker
- kleine UI-Schritte
- Debug später getrennt behandeln
- Ownership-Wechsel nur bewusst über F10-/Debug-Pfad

---

## 21. Nicht-Ziele im aktuellen UI-Stand

Aktuell nicht vorgesehen:

- vollständige Spieleroberfläche
- komplexe Pagination
- vollständiger Debug-Viewer
- IADS-Menü
- Persistence-Menü
- AI Director-Menü
- CTLD-Cargo-Menü
- echte Spawn-Auslösung über F10
- Admin-Kommandos für produktive Kampagnenänderungen
- automatischer Ownership-Wechsel ohne Bestätigung
- echte CTLD-Aktion über F10
- echte Skynet-Aktion über F10

Grund:

Zuerst muss die State-Sichtbarkeit stabil bleiben und der nächste Ownership-Schritt kontrolliert getestet werden.

---

## 22. Aktueller getesteter Systemstand

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.2` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | `v0.2.6` | Embedded-Scheduler bestanden; Restore deaktiviert |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.3` | historische Pfade bestanden; aktueller Record-Verlust ungelöst |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.2` | bestanden |

---

## 23. Aktueller Status

Der UI-Bereich ist aktiv und bestanden.

Aktuelle Fähigkeit:

- F10-Menü erscheint in DCS.
- Theater Command-Menü ist navigierbar.
- verfügbare Missionen können angezeigt werden.
- aktive Missionen können angezeigt werden.
- Missionsdetails können angezeigt werden.
- Missionen können direkt aktiviert werden.
- Mission Completion kann direkt über F10 getestet werden.
- Kampagnenstatus kann angezeigt werden.
- Capture Status kann angezeigt werden.
- Capture Ready Zones können angezeigt werden.
- Pressure Contested Zones können angezeigt werden.
- Logistikstatus kann angezeigt werden.
- FOB-Status kann angezeigt werden.
- AI-CAP-Status kann angezeigt werden.
- Mission Activation bleibt state-only.
- Mission Completion bleibt state-only.
- Capture Ready bleibt state-only sichtbar.
- keine echten Framework-Aktionen werden ausgelöst.

Nächster notwendiger Schritt:

```text
F10Menu v0.2.3
kontrollierter state-only Ownership-Wechsel aus Capture Ready Zone 1
```
