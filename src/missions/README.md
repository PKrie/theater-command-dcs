# src/missions/README.md

## Autoritativer MissionGenerator-Stand — 2026-08-04

- MissionGenerator `v0.2.3` lädt, startet und erzeugt im initialen Pool zehn Missionen; `lastMissionId` und die Statistik erreichen `10`.
- In zwei normalen Läufen waren später `available`, `active`, `completed`, `failed`, `expired` und `cancelled` vollständig leer. Diese Collections sind Dictionaries nach Mission Key und werden korrekt mit `pairs()` gezählt.
- F10 und die öffentliche Available-Abfrage fanden deshalb keine auswählbare Mission. Eine Diagnose meldete zusätzlich widersprüchlich History `pairs=0` bei `#=1`; dieser Befund beweist keinen bestimmten Mutationsmechanismus.
- Der vollständige statische Write-Site-Audit lautet exakt `PROJECT SOURCE HAS NO MATCHING WRITE SITE`. Ursache, Writer und Mechanismus bleiben unbekannt; weder Persistence noch der beobachtete 600-Sekunden-Zeitpunkt sind als Ursache belegt.
- Es gibt keinen freigegebenen Code-Fix. Mission Completion, Mission Failure, Capture Ready Apply und allgemeine Regressionen sind blockiert.
- Nächster Schritt ist der Offline/read-only Audit der 13 erwarteten eingebetteten `.miz`-Ressourcen. Ältere Erfolgsaussagen unten dokumentieren historische Funktionspfade, nicht die aktuelle Verfügbarkeit von Mission Records.

---

Diese Datei beschreibt den Missionsbereich von **Theater Command DCS**.

Der Missionsbereich erzeugt dynamische Missionen aus dem aktuellen Kampagnenzustand.

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

## 1. Zweck des Missionsbereichs

`src/missions/` ist für die Erstellung, Verwaltung und spätere Bewertung dynamischer Missionen zuständig.

Missionen sollen nicht als feste lineare Missionsliste entstehen.

Sie sollen aus dem aktuellen Theater-Command-State abgeleitet werden.

Datenquellen sind unter anderem:

- World State
- Airbase Scanner
- ZoneFactory
- CaptureSystem
- LogisticsDelivery
- FobSystem
- AICapManager
- später IADS System
- später AI Director
- später PersistenceSystem

Aktuell ist der Missionsbereich nicht mehr nur geplant.

Der Mission Generator ist aktiv, getestet und bereits mit F10Menu und CaptureSystem verbunden.

---

## 2. Aktueller technischer Stand

Historischer Stand: **2026-07-06**

Aktive Datei:

```text
src/missions/tc_mission_generator.lua
```

Getestete Version:

```text
v0.2.3
```

Status:

- **bestanden**

Bestätigt durch DCS-Logtests:

- MissionGenerator lädt.
- MissionGenerator startet.
- MissionGenerator erzeugt Missionskandidaten.
- MissionGenerator erzeugt verfügbare Missionen.
- MissionGenerator berücksichtigt FOB-Support.
- MissionGenerator reserviert mindestens eine FOB-Support-Mission.
- MissionGenerator erzeugt Mission Records mit Objectives, Briefings, Progress und Activation Metadata.
- MissionGenerator erzeugt Outcome State.
- MissionGenerator erzeugt Effect State.
- MissionGenerator reserviert MOOSE-, CTLD- und Skynet-Hooks.
- F10Menu kann Missionen anzeigen.
- F10Menu kann Missionsdetails anzeigen.
- F10Menu kann Missionen direkt aktivieren.
- F10Menu kann Active Mission Outcome Status anzeigen.
- F10Menu kann aktive Mission 1 auf `COMPLETED` setzen.
- MissionGenerator setzt aktivierte Missionen auf `ACTIVE`.
- MissionGenerator setzt abgeschlossene Missionen auf `COMPLETED`.
- MissionGenerator bereitet Mission Effects state-only vor.
- CaptureSystem verarbeitet abgeschlossene Mission Effects state-only in Capture Pressure.
- Aktivierung bleibt state-only.
- Completion bleibt state-only.
- Es werden keine echten Spawns ausgelöst.
- Es gab keinen Theater-Command-Lua-Fehler.
- Es gab keinen Lua-Stacktrace.

---

## 3. Aktuelle bestätigte Werte

Aktuelle MissionGenerator-Werte:

```text
mission candidates: 78
fobSupportCandidates: 2
generated missions: 10
reservedCreated: 1
duplicatesSkipped: 1
typeLimitSkipped: 68
```

Aktuelle F10-Bestätigung:

```text
F10 Commands: 32
Mission Details Slot 1 bestätigt
Mission Slot 1 aktiviert
Active Mission Outcome Status bestätigt
Complete Active Mission 1 bestätigt
Capture Status bestätigt
Capture Ready Zones bestätigt
Pressure Contested Zones bestätigt
```

Bestätigte Aktivierungs- und Outcome-Marker:

```text
[TC] [MissionGenerator] Loaded src/missions/tc_mission_generator.lua v0.2.3
[TC] [MissionGenerator] Mission candidate summary: candidates=78, fobSupportCandidates=2, availableBefore=0, generationSlots=10
[TC] [MissionGenerator] Mission generation completed: 10 new missions from 78 candidates (fobSupportCandidates=2, reservedCreated=1, duplicatesSkipped=1, typeLimitSkipped=68)
[TC] [MissionGenerator] Mission status changed: MISSION_2 [ACTIVE]
[TC] [MissionGenerator] Mission activation prepared: MISSION_2 stateOnly=true spawnHooks=reserved
[TC] [MissionGenerator] Mission effects prepared state-only: MISSION_2 status=COMPLETED
[TC] [MissionGenerator] Mission outcome prepared: MISSION_2 [COMPLETED] stateOnly=true effects=prepared
```

Bestätigte Capture-Rückwirkung:

```text
[TC] [CaptureSystem] Capture pressure added: zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE amount=105 progress=100%
[TC] [CaptureSystem] Mission effect applied to capture: mission=MISSION_2 zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE pressure=105
[TC] [CaptureSystem] Completed mission effects processed: applied=1, skipped=0, failed=0, appliedMissionEffects=1
[TC] [CaptureSystem] Capture progress updated: zones=32, ready=1, contested=0, appliedMissionEffects=1
[TC] [F10Menu] Capture ready zones shown through F10
```

Bewertung:

- MissionGenerator `v0.2.3` hat historisch bestandene Funktionspfade; der aktuelle Record-Verlust ist ungelöst.
- Missionen sind sichtbar, auswählbar, aktivierbar und state-only abschließbar.
- Mission Completion erzeugt vorbereitete Mission Effects.
- Der erste bestätigte Empfänger von Mission Effects ist CaptureSystem.
- Mission Effects können Capture Pressure und Capture Progress erzeugen.
- Capture Ready kann durch Mission Completion entstehen.
- Missionen lösen weiterhin keine echten Spawns aus.

---

## 4. Architekturregel

Externe Frameworks liegen unter:

```text
vendor/
```

Eigene Theater-Command-Logik liegt unter:

```text
src/
```

Der Missionsbereich gehört zur eigenen Theater-Command-Logik.

Frameworks werden nicht verändert.

Dateien in `src/missions/` werden nach Theater-Command-Aufgaben benannt, nicht nach Frameworks.

Nicht gewünscht:

```text
src/missions/tc_moose_missions.lua
src/missions/tc_mist_missions.lua
src/missions/tc_mission_all_in_one.lua
src/missions/tc_dynamic_everything.lua
```

Gewünscht:

```text
src/missions/tc_mission_generator.lua
```

Eine Missionsdatei darf intern Daten aus DCS, MIST, MOOSE, CTLD oder Skynet IADS vorbereiten oder nutzen.

Der Dateiname richtet sich aber immer nach der Theater-Command-Aufgabe.

---

## 5. Aktive Datei

Aktuell aktive Datei:

```text
src/missions/tc_mission_generator.lua
```

Aktuelle Version:

```text
v0.2.3
```

Aufgaben:

- Kampagnenzustand lesen
- Missionskandidaten erzeugen
- relevante Zielzonen erkennen
- relevante Zielbasen erkennen
- FOB-Support berücksichtigen
- Missionstypen begrenzen
- verfügbare Missionen erzeugen
- Mission Records anlegen
- Objectives erzeugen
- Briefings erzeugen
- Progress-Daten vorbereiten
- Activation Metadata vorbereiten
- Outcome State vorbereiten
- Effect State vorbereiten
- Execution Plan vorbereiten
- Effects vorbereiten
- MOOSE-Hooks reservieren
- CTLD-Hooks reservieren
- Skynet-Hooks reservieren
- Mission Activation state-only ausführen
- Mission Completion state-only ausführen
- Mission Effects für Empfängersysteme vorbereiten

Wichtig:

- MissionGenerator scannt keine Airbases selbst.
- MissionGenerator erzeugt keine Zonen selbst.
- MissionGenerator ändert keinen Besitzstatus direkt.
- MissionGenerator führt aktuell keine echten Framework-Aktionen aus.
- Besitzwechsel bleiben Aufgabe des CaptureSystems.
- Mission Effects werden durch Fachsysteme verarbeitet.

---

## 6. Mögliche spätere Dateien

Später können bei Bedarf weitere Missionsdateien ergänzt werden.

Mögliche Dateien:

```text
src/missions/tc_mission_registry.lua
src/missions/tc_mission_types.lua
src/missions/tc_mission_evaluator.lua
src/missions/tc_target_selector.lua
src/missions/tc_mission_effects.lua
```

Diese Dateien werden erst angelegt, wenn sie wirklich benötigt werden.

Aktuell reicht:

```text
src/missions/tc_mission_generator.lua
```

---

## 7. Aktuelle Missionstypen

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

Diese Liste ist noch nicht final.

Sie dient aktuell dazu, unterschiedliche Kampagnenbedarfe abzubilden.

Spätere mögliche Erweiterungen:

- `CSAR`
- `MEDEVAC`
- `TRANSPORT`
- `CONVOY_ESCORT`
- `BASE_REPAIR`
- `RUNWAY_ATTACK`
- `ANTI_SHIP`
- `TARCAP`
- `BARCAP`
- `FIGHTER_SWEEP`
- `OCA`
- `DCA`

---

## 8. Mission Record

MissionGenerator `v0.2.3` erzeugt erweiterte Mission Records.

Ein Mission Record kann aktuell enthalten:

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
- reserved MOOSE Hook
- reserved CTLD Hook
- reserved Skynet Hook

Bedeutung:

- Missionen sind vorbereitete Kampagnenobjekte.
- Missionen können mit Capture, Logistics, AI, IADS und Persistence verbunden werden.
- Missionen können state-only aktiviert werden.
- Missionen können state-only abgeschlossen werden.
- Missionen können Effects vorbereiten.
- Der erste bestätigte praktische Effect-Empfänger ist CaptureSystem.

---

## 9. Mission Status

Mögliche oder vorbereitete Mission Status:

- `AVAILABLE`
- `ACTIVE`
- `COMPLETED`
- `FAILED`
- `CANCELLED`
- `EXPIRED`

Aktuell bestätigte Statuswechsel:

```text
AVAILABLE -> ACTIVE
ACTIVE -> COMPLETED
```

Bestätigt über F10:

- Mission Slot 1 aktiviert
- Active Mission 1 abgeschlossen

Noch offen:

- Mission manuell fehlschlagen lassen
- Mission abbrechen
- Mission ablaufen lassen
- Mission automatisch durch DCS-Events abschließen
- Missionserfolg auf Logistics anwenden
- Missionserfolg auf AI anwenden
- Missionserfolg auf IADS anwenden

---

## 10. Mission Activation

Missionen können aktuell über F10 aktiviert werden.

F10Menu `v0.2.2` bietet:

- `Show Available Missions`
- `Show Active Missions`
- `Show Mission 1 Details` bis `Show Mission 10 Details`
- `Activate Mission 1` bis `Activate Mission 10`

Bestätigt:

- MissionGenerator setzt aktivierte Missionen auf `ACTIVE`.
- Aktivierung erzeugt `stateOnly=true`.
- Aktivierung erzeugt `spawnHooks=reserved`.

Aktuelle Einschränkung:

- Mission Activation bedeutet noch nicht, dass DCS-Einheiten gespawnt werden.
- Mission Activation ist aktuell eine State-Änderung.
- MOOSE-, CTLD- und Skynet-Hooks bleiben reserviert.

---

## 11. Mission Outcome

Mission Outcome Controls sind aktiv.

F10Menu `v0.2.2` bietet:

- `Show Active Mission Outcome Status`
- `Complete Active Mission 1`
- `Fail Active Mission 1`

Bestätigt:

- Active Mission Outcome Status kann angezeigt werden.
- Active Mission 1 kann auf `COMPLETED` gesetzt werden.
- MissionGenerator setzt die Mission auf `COMPLETED`.
- MissionGenerator bereitet Effects state-only vor.
- CaptureSystem verarbeitet abgeschlossene Mission Effects.

Noch offen:

- `Fail Active Mission 1` praktisch testen
- Failure Effects definieren
- `CANCELLED` und `EXPIRED` später testbar machen
- automatische DCS-Event-Auswertung vorbereiten

---

## 12. Verhältnis zum Core

`src/missions/` nutzt den Core.

Erlaubte Core-Abhängigkeiten:

- `TC.Config`
- `TC.Logger`
- `TC.State`
- `TC.Utils`
- `TC.Scheduler`

Der Missionsbereich darf davon ausgehen, dass der Core bereits geladen ist.

Aktuelle Ladeposition:

```text
nach World, Campaign und Logistics
vor AI, UI, Main und Loader
```

---

## 13. Verhältnis zum World-Bereich

Der Missionsbereich nutzt Daten aus:

```text
src/world/
```

Besonders wichtig:

- `TC.World.AirbaseScanner`
- `TC.World.ZoneFactory`
- `TC.State.Bases`
- `TC.State.Zones`

Aktuelle World-Werte:

```text
Syria airbase-like objects: 225
relevante Kampagnenzonen: 46
captureCandidates: 32
missionCandidates: 32
logisticsCandidates: 46
```

Missions nutzt diese Daten für:

- Zielauswahl
- Airbase-Bezug
- Zonen-Bezug
- Start- und Zielräume
- strategische Priorität

Missions soll nicht selbst Airbases scannen.

Missions soll nicht selbst Kampagnenzonen erzeugen.

---

## 14. Verhältnis zum Campaign-Bereich

Der Missionsbereich nutzt Daten aus:

```text
src/campaign/
```

Besonders wichtig:

- `TC.Campaign.CaptureSystem`
- `TC.Campaign.PersistenceSystem`
- `TC.State.Campaign`
- `TC.State.Bases`
- `TC.State.Zones`

Aktuelle Capture-Startwerte:

```text
eligibleBases: 32
eligibleZones: 32
pressureRecords: 32
progressRecords: 32
appliedMissionEffects: 0
ready: 0
contested: 0
```

Bestätigte Capture-Werte nach Mission Completion:

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

Missions nutzt diesen Zustand, um passende Aufträge zu erzeugen.

Beispiele:

- rote Zone wird mögliches Angriffsziel
- capture-fähige Zone wird mögliches Missionsziel
- Zone mit Pressure wird später mögliches Schwerpunktziel
- strategische Airbase wird mögliches Strike- oder SEAD-Ziel
- Mission Effects können Capture-Pressure oder Capture-Progress beeinflussen

Bestätigte Rückwirkung:

- Mission Completion erzeugt Mission Effects.
- CaptureSystem verarbeitet Mission Effects.
- Capture Pressure wird erzeugt.
- Capture Progress wird aktualisiert.
- Capture Ready kann entstehen.

Besitzwechsel bleiben Aufgabe des CaptureSystems.

---

## 15. Verhältnis zum Logistics-Bereich

Der Missionsbereich nutzt Daten aus:

```text
src/logistics/
```

Besonders wichtig:

- `TC.Logistics.Delivery`
- `TC.Logistics.FobSystem`
- `TC.State.Logistics`

Aktuelle Logistics-Werte:

```text
logistics hubs: 46
blue hubs: 7
red hubs: 24
neutral hubs: 15
active hubs: 31
limited hubs: 15
locked hubs: 0
```

Aktuelle FOB-Werte:

```text
FOB candidates: 6
Blue FOBs: 2
FOB Ercan
FOB Gecitkale
Status: UNDER_CONSTRUCTION
```

MissionGenerator nutzt FOBs bereits:

```text
fobSupportCandidates: 2
reservedCreated: 1
```

Bedeutung:

- FOB-Support ist bereits Teil der Missionslogik.
- Mindestens eine FOB-Support-Mission wird reserviert.
- FOB-Support wird nicht durch andere Missionstypen verdrängt.

Aktuell:

- CTLD-Cargo-Aktionen sind noch nicht produktiv angebunden.
- Mission Effects wirken noch nicht produktiv auf Logistics.
- FOB-Baufortschritt wird noch nicht durch Mission Effects verändert.

---

## 16. Verhältnis zum AI-Bereich

Der Missionsbereich kann später Daten an AI liefern oder AI-Daten berücksichtigen.

Aktuell aktive AI-Datei:

```text
src/ai/tc_ai_cap_manager.lua
```

Getestete Version:

```text
v0.2.0
```

Aktuelle AI-Werte:

```text
cap zone candidates: 31
auto-registered CAP zones: 12
CAP requests: 12
reactionState: AIR_REACTION_REQUESTED
threatLevel: HIGH
```

Mögliche spätere Kopplungen:

- aktive Strike-Mission erhöht feindliche CAP-Wahrscheinlichkeit
- aktive SEAD-Mission verändert IADS-/AI-Reaktion
- aktive Logistics-Mission erzeugt Intercept-Risiko
- abgeschlossene Missionen beeinflussen AI Director
- CAP-State beeinflusst Missionspriorität
- Mission Effects lösen AI-Reaktionen aus

Aktuell:

- AI Director ist noch nicht implementiert.
- MissionGenerator erzeugt Missionen state-only.
- Mission Effects auf AI sind noch nicht produktiv aktiv.

---

## 17. Verhältnis zum IADS-Bereich

Der Missionsbereich bereitet IADS-nahe Missionen vor.

Aktuell:

- Skynet IADS wird geladen.
- Theater-Command-IADS-Modul ist noch nicht implementiert.
- MissionGenerator reserviert Skynet-Hooks.

IADS-nahe Missionstypen:

- `SEAD`
- `DEAD`
- `IADS_SUPPRESSION`

Mögliche spätere Kopplung:

- IADS-System liefert SAM-/EWR-Ziele.
- MissionGenerator erzeugt SEAD-/DEAD-Missionen gegen diese Ziele.
- Mission Effects verändern IADS-State.
- Skynet-Hooks werden später produktiv genutzt.

Aktuell:

- keine echte Skynet-Aktion
- keine echte IADS-Wirkung
- keine IADS-Persistenz

---

## 18. Verhältnis zum UI-Bereich

Der Missionsbereich ist bereits mit dem UI-Bereich verbunden.

Aktive UI-Datei:

```text
src/ui/tc_f10_menu.lua
```

Getestete Version:

```text
v0.2.2
```

F10Menu kann aktuell:

- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Mission Details Slot 1 bis 10 anzeigen
- Mission Slot 1 bis 10 aktivieren
- Active Mission Outcome Status anzeigen
- Active Mission 1 auf `COMPLETED` setzen
- Capture Status anzeigen
- Capture Ready Zones anzeigen
- Pressure Contested Zones anzeigen

Bestätigt:

- Mission Details Slot 1
- Mission Slot 1 aktiviert
- Active Mission Outcome Status angezeigt
- Active Mission 1 abgeschlossen
- Capture Status angezeigt
- Capture Ready Zones angezeigt
- Pressure Contested Zones angezeigt

Bewertung:

- UI und MissionGenerator sind erfolgreich verbunden.
- UI, MissionGenerator und CaptureSystem sind über Mission Outcome und Mission Effects verbunden.
- Mission Activation bleibt state-only.
- Mission Completion bleibt state-only.

---

## 19. Verhältnis zu Persistence

PersistenceSystem `v0.2.6` speichert Campaign-State dirty-aware; produktiver Restore bleibt deaktiviert. Der aktuelle Mission-Record-Verlust ist nicht als Persistence-Ursache belegt.

Aktuelle Datei:

```text
src/campaign/tc_persistence_system.lua
```

Status:

```text
PersistenceSystem v0.2.6 lädt/startet dirty-aware
Datei-Write und Read-back-Verifikation bestanden
```

Missionsdaten sollen später persistiert werden:

- verfügbare Missionen
- aktive Missionen
- abgeschlossene Missionen
- fehlgeschlagene Missionen
- Missionsstatus
- Mission Progress
- Mission Effects
- angewendete Mission Effects
- Mission History

Aktuell:

- keine produktive Missionspersistenz
- kein Save/Load von Missionen
- keine Autosaves

Persistence wird sinnvoller, sobald kontrollierte Ownership-Wechsel bestätigt sind.

---

## 20. State-first-Regel

Der Missionsbereich folgt aktuell strikt der state-first-Architektur.

Das bedeutet:

- Missionen entstehen im State.
- Missionen werden über F10 sichtbar.
- Missionen können im State aktiviert werden.
- Missionen können im State abgeschlossen werden.
- Mission Effects werden vorbereitet.
- Mission Effects werden durch Fachsysteme verarbeitet.
- Framework-Hooks werden reserviert.
- echte Framework-Aktionen bleiben deaktiviert.

Nicht aktiv:

- echte MOOSE-Spawns
- echte CTLD-Cargo-Aktionen
- echte Skynet-IADS-Wirkung
- automatische DCS-Event-Auswertung
- automatische Mission Completion
- automatische produktive Besitzwechsel

Grund:

Der Kampagnenzustand muss zuerst korrekt, sichtbar und testbar sein.

Danach können echte DCS-Aktionen kontrolliert angebunden werden.

---

## 21. Testziele

Der Missionsbereich gilt aktuell für den state-first Stand als bestanden, wenn:

- MissionGenerator lädt.
- MissionGenerator startet.
- 78 Missionskandidaten werden erkannt.
- 2 FOB-Support-Kandidaten werden erkannt.
- 10 verfügbare Missionen werden erzeugt.
- FOB-Support wird berücksichtigt.
- mindestens eine FOB-Support-Mission wird reserviert.
- Mission Records enthalten Objectives, Briefings, Progress und Activation Metadata.
- Mission Records enthalten Outcome State.
- Mission Records enthalten Effect State.
- Mission Details sind über F10 abrufbar.
- Missionen können über F10 direkt aktiviert werden.
- MissionGenerator setzt aktivierte Missionen auf `ACTIVE`.
- Aktivierung bleibt state-only.
- Spawn-Hooks bleiben reserved.
- aktive Mission 1 kann über F10 auf `COMPLETED` gesetzt werden.
- MissionGenerator bereitet Mission Effects vor.
- CaptureSystem verarbeitet abgeschlossene Mission Effects.
- Capture Pressure wird erhöht.
- Capture Progress wird aktualisiert.
- Capture Ready entsteht.
- Capture Ready Zones sind über F10 sichtbar.
- keine Lua-Fehler auftreten.
- keine Theater-Command-Fehler auftreten.

Noch offen:

- `Fail Active Mission 1` praktisch testen
- Mission Effects auf Logistics anwenden
- Mission Effects auf AI anwenden
- Mission Effects auf IADS anwenden
- automatische DCS-Event-Auswertung
- echte MOOSE-Spawns
- echte CTLD-Aktionen
- echte Skynet-IADS-Wirkung
- Mission-State persistieren

---

## 22. Erwartete Logmarker

Aktuelle erwartete MissionGenerator-Logmarker:

```text
[TC] [MissionGenerator] Loaded src/missions/tc_mission_generator.lua v0.2.3
[TC] [MissionGenerator] Mission candidate summary: candidates=78, fobSupportCandidates=2, availableBefore=0, generationSlots=10
[TC] [MissionGenerator] Mission generation completed: 10 new missions from 78 candidates (fobSupportCandidates=2, reservedCreated=1, duplicatesSkipped=1, typeLimitSkipped=68)
[TC] [MissionGenerator] Mission status changed: MISSION_2 [ACTIVE]
[TC] [MissionGenerator] Mission activation prepared: MISSION_2 stateOnly=true spawnHooks=reserved
[TC] [MissionGenerator] Mission effects prepared state-only: MISSION_2 status=COMPLETED
[TC] [MissionGenerator] Mission outcome prepared: MISSION_2 [COMPLETED] stateOnly=true effects=prepared
```

Aktuelle erwartete F10-Logmarker:

```text
[TC] [F10Menu] Mission details shown through F10: slot=1 key=MISSION_2
[TC] [F10Menu] Mission activated through F10: slot=1 key=MISSION_2
[TC] [F10Menu] Active mission outcome status shown through F10
[TC] [F10Menu] Mission completed through F10: slot=1 key=MISSION_2 stateOnly=true effects=prepared
```

Aktuelle erwartete Capture-Folge nach Mission Completion:

```text
[TC] [CaptureSystem] Capture pressure added: zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE amount=105 progress=100%
[TC] [CaptureSystem] Mission effect applied to capture: mission=MISSION_2 zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE pressure=105
[TC] [CaptureSystem] Completed mission effects processed: applied=1, skipped=0, failed=0, appliedMissionEffects=1
[TC] [CaptureSystem] Capture progress updated: zones=32, ready=1, contested=0, appliedMissionEffects=1
[TC] [F10Menu] Capture ready zones shown through F10
```

---

## 23. Abgrenzung

Nicht Aufgabe von `src/missions/`:

- Airbases aus DCS auslesen
- Zonen geometrisch erzeugen
- Basenbesitz direkt festlegen
- Zonenbesitz direkt festlegen
- CTLD-Lieferungen direkt auswerten
- FOBs direkt bauen
- CAPs dauerhaft verwalten
- IADS-Netzwerke aufbauen
- F10-Menüs erzeugen
- Debug-Zeichnungen erzeugen
- Framework-Dateien verändern

Diese Aufgaben gehören in andere Bereiche.

Missions erzeugt und verwaltet Aufträge.

---

## 24. Nächster sinnvoller Schritt

Der nächste sinnvolle Schritt liegt nicht direkt im Missionsbereich.

Empfohlene nächste Datei:

```text
src/ui/tc_f10_menu.lua
```

Ziel:

```text
kontrollierter state-only Ownership-Wechsel aus Capture Ready Zone 1
```

Geplanter neuer F10-Befehl:

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

## 25. Zielbild

`src/missions/` ist die Auftragsschicht von Theater Command DCS.

Der Missionsbereich verbindet:

- World-Daten
- Campaign-State
- Capture-Pressure
- Capture-Progress
- Logistics
- FOBs
- AI-Reaktion
- IADS-Ziele
- Spielerinteraktion
- Persistenz

Aktueller Status:

- MissionGenerator `v0.2.3` hat historisch bestandene state-first Pfade; der aktuelle Record-Verlust ist ungelöst.
- Missionen waren in historischen Regressionstests über F10 sichtbar; aktuell sind die sechs Status-Dictionaries leer.
- Missionen sind über F10 aktivierbar.
- Missionen können über F10 state-only abgeschlossen werden.
- Mission Effects werden vorbereitet.
- CaptureSystem verarbeitet abgeschlossene Mission Effects.
- Capture Pressure und Capture Progress können durch Mission Completion entstehen.
- Capture Ready kann durch Mission Completion entstehen.
- Capture Ready ist über F10 sichtbar.
- Echte Framework-Ausführung folgt später.

Nächster notwendiger Zwischenschritt im Gesamtprojekt:

```text
F10Menu v0.2.3 mit kontrolliertem state-only Capture Ready Apply
```
