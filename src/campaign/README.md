# src/campaign/README.md

## Autoritativer Campaign-Stand — 2026-08-04

- CaptureSystem `v0.2.2` markiert aktive State-Änderungen dirty.
- PersistenceSystem `v0.2.6` ist implementiert: dirty-aware periodischer Autosave, `SAVED`/`SKIPPED`/`FAILED`, verifizierter Read-back vor Dirty-Clear, Fehlererhalt und erfolgreicher Retry.
- Normal eingebetteter Start sowie echte 20-/120-Sekunden-Ticks sind bestanden; unveränderte Ticks schreiben die Save-Datei nicht. Produktiver Restore bleibt deaktiviert und es gibt keine F10-Persistence-Controls.
- Die historischen Mission-/Capture-Pipelines sind bestanden, ihre aktuellen Regressionen sind aber durch den ungeklärten MissionGenerator-Record-Verlust blockiert (`PROJECT SOURCE HAS NO MATCHING WRITE SITE`).
- Nächster Schritt ist der Offline/read-only Embedded Mission Resource Audit. Abweichende Aussagen unten sind historische Entwicklungsstände.

---

Diese Datei beschreibt den Campaign-Bereich von **Theater Command DCS**.

Der Campaign-Bereich enthält eigene Lua-Logik für strategischen Kampagnenzustand, Capture-System und Persistenzvorbereitung.

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

## 1. Zweck des Campaign-Bereichs

`src/campaign/` ist für den strategischen Zustand der Kampagne zuständig.

Dieser Bereich entscheidet nicht, welche Airbases in DCS existieren.

Diese Daten kommen aus:

```text
src/world/
```

Der Campaign-Bereich entscheidet, was diese Daten strategisch bedeuten.

Langfristig verwaltet `src/campaign/`:

- Besitzstatus von Basen
- Besitzstatus von Zonen
- Capture-Eligibility
- Capture-Pressure
- Capture-Progress
- Capture Ready
- Pressure Contested
- Mission Effects
- angewendete Mission Effects
- Kampagnenfortschritt
- Kampagnenzustand
- Persistenzvorbereitung
- spätere Save-/Load-Logik

Aktuell ist der Campaign-Bereich nicht mehr nur geplant.

Das CaptureSystem ist aktiv und getestet.

Das PersistenceSystem `v0.2.6` ist als dirty-aware Background-Autosave aktiv; produktiver Restore bleibt deaktiviert.

---

## 2. Kampagnenkontext

Erste Kampagne:

```text
Operation Levant Reclamation
```

Map:

```text
Syria
```

Ausgangslage:

```text
Blue Start: Akrotiri / Zypern
Red Start: syrisches Festland initial rot kontrolliert
```

Grundannahme:

- Akrotiri ist initial blau.
- Zypern ist initial blauer Ausgangsraum.
- syrische Festlandbasen sind initial rot.
- syrische Festlandzonen sind initial rot.
- neutrale Sonderfälle werden später ausdrücklich definiert.

---

## 3. Aktueller technischer Stand

Historischer Stand: **2026-07-06**

Aktive Dateien:

```text
src/campaign/tc_capture_system.lua
src/campaign/tc_persistence_system.lua
```

Getesteter Stand:

```text
CaptureSystem: v0.2.2 bestanden
PersistenceSystem: v0.2.6, Embedded-Scheduler und Save-Verifikation bestanden
```

Bestätigt durch DCS-Logtests:

- CaptureSystem lädt.
- CaptureSystem startet.
- CaptureSystem erkennt capture-fähige Basen und Zonen.
- CaptureSystem erzeugt Pressure-Records.
- CaptureSystem erzeugt Progress-Records.
- CaptureSystem verarbeitet abgeschlossene Mission Effects.
- CaptureSystem erzeugt Capture Pressure aus Mission Completion.
- CaptureSystem aktualisiert Capture Progress aus Mission Completion.
- CaptureSystem erzeugt Capture Ready.
- Capture Ready Zones sind über F10 sichtbar.
- PersistenceSystem lädt.
- PersistenceSystem `v0.2.6` startet als dirty-aware Background-Autosave.
- Es gab keinen Theater-Command-Lua-Fehler.
- Es gab keinen Lua-Stacktrace.

---

## 4. Aktuelle bestätigte Capture-Werte

CaptureSystem `v0.2.2` im Startzustand:

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

CaptureSystem `v0.2.2` nach Mission Completion:

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

Bewertung:

- CaptureSystem arbeitet nicht auf allen 225 DCS-Airbase-like Objects.
- CaptureSystem arbeitet auf 32 fachlich geeigneten Capture-Zielen.
- 32 Pressure-Records und 32 Progress-Records werden erzeugt.
- Mission Completion kann Capture Pressure erzeugen.
- Capture Progress kann durch Mission Completion auf 100 % steigen.
- Capture Ready kann dynamisch entstehen.
- Capture Ready ist über F10 sichtbar.
- automatische produktive Besitzwechsel sind weiterhin deaktiviert.

---

## 5. Architekturregel

Externe Frameworks liegen unter:

```text
vendor/
```

Eigene Theater-Command-Logik liegt unter:

```text
src/
```

Der Campaign-Bereich gehört zur eigenen Theater-Command-Logik.

Frameworks werden nicht verändert.

Dateien in `src/campaign/` werden nach Theater-Command-Aufgaben benannt, nicht nach Frameworks.

Nicht gewünscht:

```text
src/campaign/tc_moose_campaign.lua
src/campaign/tc_mist_campaign.lua
src/campaign/tc_campaign_all_in_one.lua
src/campaign/tc_capture_and_persistence_all_in_one.lua
```

Gewünscht:

```text
src/campaign/tc_capture_system.lua
src/campaign/tc_persistence_system.lua
```

Eine Campaign-Datei darf intern DCS-API, MIST, MOOSE, CTLD oder Skynet-IADS-Daten nutzen.

Der Dateiname richtet sich aber immer nach der Theater-Command-Aufgabe.

---

## 6. Aktive Dateien

Aktuell aktive Dateien:

```text
src/campaign/tc_capture_system.lua
src/campaign/tc_persistence_system.lua
```

`tc_capture_system.lua`:

- aktives strategisches Capture-Modul
- Version `v0.2.2`
- bestanden
- verarbeitet Capture-Eligibility
- verarbeitet Capture-Pressure
- verarbeitet Capture-Progress
- verarbeitet abgeschlossene Mission Effects
- erzeugt Capture Ready
- stellt Capture-Daten für F10 bereit

`tc_persistence_system.lua`:

- vorbereitete Persistenz-Grundstruktur
- lädt/startet
- Datei-Write und Read-back-Verifikation bestanden; produktiver Restore deaktiviert
- Save/Autosave aktiv; produktiver Startup-Restore deaktiviert

Mögliche spätere Dateien:

```text
src/campaign/tc_campaign_events.lua
src/campaign/tc_campaign_progress.lua
src/campaign/tc_ownership_rules.lua
src/campaign/tc_mission_effects.lua
```

Diese Zusatzdateien werden erst angelegt, wenn sie wirklich benötigt werden.

---

## 7. CaptureSystem

Datei:

```text
src/campaign/tc_capture_system.lua
```

Getestete Version:

```text
v0.2.2
```

Status:

- bestanden

Aktuelle Aufgaben:

- Capture-Eligibility ableiten
- capture-fähige Basen erkennen
- capture-fähige Zonen erkennen
- nicht capture-fähige Objekte ausschließen
- Capture-Pressure vorbereiten
- Capture-Progress vorbereiten
- abgeschlossene Mission Effects verarbeiten
- Mission Effects state-only auf Capture Pressure anwenden
- Capture Ready erkennen
- Pressure Contested erkennen
- Capture-State aktualisieren
- Capture-Summary loggen
- State für F10-/Debug-Anzeige bereitstellen

Wichtig:

- CaptureSystem scannt keine Airbases selbst.
- CaptureSystem erzeugt keine Zonen selbst.
- CaptureSystem arbeitet mit Daten aus World und ZoneFactory.
- CaptureSystem führt aktuell noch keinen automatischen produktiven Besitzwechsel durch.

---

## 8. Capture-Eligibility

Capture-Eligibility entscheidet, welche Objekte strategisch eroberbar sind.

Aktuell capture-fähig:

```text
32 Basen/Zonen
```

Aktuell nicht capture-fähig:

```text
193 Airbase-like Objects
14 relevante, aber nicht capture-fähige Zonen
```

Grund:

DCS Syria liefert 225 airbase-like objects.

Nicht jedes dieser Objekte ist ein strategisches Kampagnenziel.

Nicht automatisch capture-fähig:

- einfache Helipads
- Medical Pads
- Tactical Pads ohne explizite Freigabe
- Unknown Objects
- rein technische DCS-Sonderobjekte

Diese Filterung ist wichtig, damit die Kampagne keine unsinnigen Capture-Ziele erzeugt.

---

## 9. Capture-Pressure

Capture-Pressure beschreibt den militärischen Druck auf eine Zone.

Aktueller Startstand:

```text
pressureRecords: 32
```

Bestätigter Pressure-Test nach Mission Completion:

```text
zone: ZONE_AIRBASE_ABU_AL_DUHUR
owner: BLUE
amount: 105
progress: 100 %
```

Bestätigter Logmarker:

```text
[TC] [CaptureSystem] Capture pressure added: zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE amount=105 progress=100%
```

Aktuelle Einflussfaktoren:

- abgeschlossene Mission Effects
- Mission Completion
- Zielzone
- Besitzerseite
- vorbereitete Mission Effect-Daten

Mögliche spätere Einflussfaktoren:

- CAS
- Strike
- SEAD/DEAD
- Logistics Support
- FOB Support
- AI-Operationen
- IADS-Zustand
- gegnerische Verteidigung
- Ressourcenlage
- Bodentruppenpräsenz

Aktueller Stand:

- Capture-Pressure wird erzeugt.
- Capture-Pressure kann durch Mission Completion steigen.
- Capture-Pressure ist über Capture Status indirekt sichtbar.
- Capture Ready Zones sind über F10 sichtbar.
- produktive Besitzwechsel folgen erst nach kontrolliertem Testpfad.

---

## 10. Capture-Progress

Capture-Progress beschreibt den Fortschritt Richtung Besitzwechsel.

Aktueller Startstand:

```text
progressRecords: 32
ready: 0
contested: 0
```

Bestätigter Progress-Test nach Mission Completion:

```text
progress: 100 %
ready: 1
contested: 0
```

Bestätigter Logmarker:

```text
[TC] [CaptureSystem] Capture progress updated: zones=32, ready=1, contested=0, appliedMissionEffects=1
```

Mögliche spätere Zustände:

- `STABLE`
- `PRESSURED`
- `CONTESTED`
- `READY_FOR_CAPTURE`
- `CAPTURED`
- `LOCKED`
- `BLOCKED`

Aktueller Stand:

- Capture-Progress wird vorbereitet und aktualisiert.
- Capture Ready kann durch Mission Completion entstehen.
- Pressure Contested ist vorbereitet.
- Besitzwechsel sind noch nicht produktiv aktiv.

---

## 11. Mission Effects

Mission Effects beeinflussen den Campaign State.

Aktueller bestätigter Stand:

```text
appliedMissionEffects: 1
```

Bestätigte Pipeline:

```text
Mission Completion
-> Mission Effects prepared
-> CaptureSystem processes completed mission effects
-> Capture Pressure added
-> Capture Progress updated
-> Capture Ready detected
-> Capture Ready shown through F10
```

Bestätigter Testfall:

```text
MISSION_2 -> ZONE_AIRBASE_ABU_AL_DUHUR -> BLUE pressure 105 -> progress 100% -> ready=1
```

Bestätigte Logmarker:

```text
[TC] [MissionGenerator] Mission outcome prepared: MISSION_2 [COMPLETED] stateOnly=true effects=prepared
[TC] [CaptureSystem] Mission effect applied to capture: mission=MISSION_2 zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE pressure=105
[TC] [CaptureSystem] Completed mission effects processed: applied=1, skipped=0, failed=0, appliedMissionEffects=1
```

Wichtig:

- Mission Effects werden nicht mehrfach angewendet.
- Bei erneutem Statusaufruf ist `skipped=1` für bereits angewendete Effects korrekt.
- Mission Effects bleiben state-only.
- Der erste bestätigte Empfänger ist CaptureSystem.
- Logistics, AI und IADS verarbeiten Mission Effects noch nicht produktiv.

Spätere mögliche Mission Effects:

- Capture-Pressure erhöhen
- Capture-Progress erhöhen
- Verteidigungswert senken
- Zone contested setzen
- Zone ready for capture setzen
- Besitzwechsel vorbereiten
- Logistikstatus beeinflussen
- AI-Reaktion auslösen
- IADS-Zustand beeinflussen

---

## 12. PersistenceSystem

Datei:

```text
src/campaign/tc_persistence_system.lua
```

Status:

- `v0.2.6` implementiert und normal eingebettet gestartet
- dirty-aware periodischer Autosave mit `SAVED`, `SKIPPED` und `FAILED`
- produktiver Startup-Restore deaktiviert

Aufgaben aktuell:

- vorhandenen `TC.State.Persistence`-Dirty-State verwenden
- geänderten State schreiben, zurücklesen, kompilieren, evaluieren und validieren
- Dirty erst nach verifiziertem Erfolg löschen und neuere Dirty-Zustände schützen
- unveränderte periodische Ticks ohne Dateischreiben überspringen

Noch nicht aktiv:

- produktiver automatischer Restore beim Missionsstart
- Persistence-F10-Controls

Wichtig:

Dateischreiben, Read-back-Verifikation, kontrollierter Fehler/Retry und der normal eingebettete 20-/120-Sekunden-Scheduler sind bestanden. Restore benötigt eine separate spätere Freigabe.

---

## 13. Verhältnis zum Core

`src/campaign/` nutzt den Core.

Erlaubte Core-Abhängigkeiten:

- `TC.Config`
- `TC.Logger`
- `TC.State`
- `TC.Utils`
- `TC.Scheduler`

Der Campaign-Bereich darf davon ausgehen, dass der Core bereits geladen ist.

Aktuelle Ladeposition:

```text
nach Core und World
vor Logistics, Missions, AI, UI, Main und Loader
```

---

## 14. Verhältnis zum World-Bereich

Der Campaign-Bereich nutzt Daten aus:

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

Campaign nutzt diese Daten für:

- Capture-Eligibility
- strategischen Besitzstatus
- Capture-Pressure
- Capture-Progress
- spätere Besitzwechsel

Campaign soll nicht selbst Airbases scannen.

Campaign soll nicht selbst Zonen erzeugen.

---

## 15. Verhältnis zum Logistics-Bereich

Der Logistics-Bereich nutzt Campaign-Daten und liefert später selbst Einflussfaktoren zurück.

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

Spätere Kopplung:

- FOB Support erhöht Capture-Pressure.
- Logistics Support erhöht Capture-Progress.
- Supply-Mangel erschwert Verteidigung.
- beschädigte Logistics Hubs reduzieren Operationsfähigkeit.
- FOBs ermöglichen Capture-Vorbereitung.

Aktuell:

- Logistics und FOBs sind state-only.
- CaptureSystem ist noch nicht produktiv mit Logistik gekoppelt.
- Mission Effects auf Logistics sind noch nicht aktiv.

---

## 16. Verhältnis zum Missionsbereich

Der Missionsbereich nutzt Campaign-Daten.

Aktuelle MissionGenerator-Datei:

```text
src/missions/tc_mission_generator.lua
```

Getestete Version:

```text
v0.2.3
```

Aktuelle MissionGenerator-Werte:

```text
mission candidates: 78
fobSupportCandidates: 2
generated missions: 10
reservedCreated: 1
duplicatesSkipped: 1
typeLimitSkipped: 68
```

MissionGenerator nutzt Campaign-Daten für:

- Zielauswahl
- Missionstypen
- Priorität
- FOB-Support
- Capture-relevante Missionen
- Mission Effects

Bestätigte Rückwirkung:

- Mission Completion erzeugt Mission Effects.
- Mission Effects erhöhen Capture-Pressure.
- Mission Effects erhöhen Capture-Progress.
- Mission Effects können Capture Ready erzeugen.

Aktuell bestätigt:

- Missionen können über F10 angezeigt werden.
- Missionen können über F10 aktiviert werden.
- Mission Activation bleibt state-only.
- Missionen können über F10 auf `COMPLETED` gesetzt werden.
- Mission Completion bleibt state-only.
- Mission Effects werden durch CaptureSystem verarbeitet.

Noch offen:

- `Fail Active Mission 1` praktisch testen
- Failure Effects definieren
- Mission Effects auf Logistics, AI und IADS anwenden

---

## 17. Verhältnis zum AI-Bereich

AI soll später Campaign-Daten nutzen.

Aktuelle AI-Datei:

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

Spätere AI-Nutzung:

- Zonen unter Druck bewerten
- Capture Ready bewerten
- Gegenangriffe planen
- CAP über kritischen Zonen priorisieren
- Blue-/Red-Operationen planen
- Capture-Erfolge oder Fehlschläge verarbeiten
- Missionsergebnisse gewichten

Aktuell:

- AICapManager ist state-only.
- AI Director ist noch nicht implementiert.
- AI nutzt Capture-Pressure noch nicht produktiv.

---

## 18. Verhältnis zum IADS-Bereich

IADS soll später Campaign-Daten beeinflussen und selbst von Campaign-Daten abhängen.

Aktueller IADS-Stand:

- Skynet IADS wird geladen.
- eigenes Theater-Command-IADS-Modul ist noch nicht implementiert.
- MissionGenerator reserviert Skynet-Hooks.

Spätere Kopplung:

- aktive IADS-Abdeckung erschwert Capture.
- zerstörte SAM-Sites erleichtern Capture.
- SEAD/DEAD-Missionen erzeugen Capture-Vorteile.
- IADS-Zustand beeinflusst MissionGenerator und AI Director.
- IADS-Schäden werden persistent.

Aktuell:

- IADS ist noch nicht mit CaptureSystem gekoppelt.
- Mission Effects auf IADS sind noch nicht aktiv.

---

## 19. Verhältnis zum UI-Bereich

F10Menu ist aktiv und zeigt mehrere Campaign- und Capture-Bereiche.

Aktive UI-Datei:

```text
src/ui/tc_f10_menu.lua
```

Getestete Version:

```text
v0.2.2
```

Aktuelle F10-Funktionen:

- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Missionsdetails anzeigen
- Missionen aktivieren
- Active Mission Outcome Status anzeigen
- aktive Mission 1 auf `COMPLETED` setzen
- Kampagnenstatus anzeigen
- Capture Status anzeigen
- Capture Ready Zones anzeigen
- Pressure Contested Zones anzeigen
- Logistikstatus anzeigen
- FOB-Status anzeigen
- AI-CAP-Status anzeigen

Aktueller bestätigter F10-Wert:

```text
commands: 32
```

Aktueller Stand:

- Capture Status ist sichtbar.
- Capture Ready Zones sind sichtbar.
- Pressure Contested Zones sind sichtbar.
- Mission Completion ist über F10 möglich.
- Capture Ready kann nach Mission Completion über F10 geprüft werden.

Nächster UI-Schritt:

```text
Apply Capture Ready Zone 1
```

Ziel:

- kontrollierter state-only Ownership-Wechsel aus Capture Ready Zone 1
- kein automatischer Besitzwechsel ohne Spieler-/Debug-Bestätigung

---

## 20. Campaign State

Der Campaign-Bereich arbeitet mit State-Daten.

Wichtige State-Bereiche:

```text
TC.State.Campaign
TC.State.Bases
TC.State.Zones
TC.State.Capture
TC.State.Persistence
```

Mögliche Campaign-Daten:

- name
- map
- phase
- blueStartRegion
- blueStartBase
- initialBlueTerritory
- initialRedTerritory
- currentFrontState
- isRunning
- isPaused
- tick
- lastUpdate

Aktuelle Capture-Daten:

- eligibleBases
- eligibleZones
- pressureRecords
- progressRecords
- readyZones
- contestedZones
- appliedMissionEffects
- ownershipChanges
- captureEvents

Aktuell:

- CaptureSystem erzeugt Pressure- und Progress-Records.
- CaptureSystem verarbeitet abgeschlossene Mission Effects.
- Capture Ready kann entstehen.
- produktive Besitzwechsel sind noch nicht aktiv.

---

## 21. State-first-Regel

Der Campaign-Bereich folgt aktuell strikt der state-first-Architektur.

Das bedeutet:

- Campaign erzeugt State.
- CaptureSystem aktualisiert State.
- CaptureSystem verarbeitet Mission Effects state-only.
- CaptureSystem erzeugt Capture Pressure.
- CaptureSystem erzeugt Capture Progress.
- CaptureSystem erzeugt Capture Ready.
- PersistenceSystem bereitet State-Speicherung vor.
- UI macht State sichtbar.
- echte Besitzwechsel folgen kontrolliert.
- dirty-aware Background-Persistence ist aktiv; produktiver Restore folgt erst nach separater Freigabe.

Aktuell nicht aktiv:

- automatische Zone-Capture
- automatische Base-Capture
- produktive Save-/Load-Logik
- Autosave
- DCS-Event-basierter Besitzwechsel
- echte Framework-Aktionen

Grund:

Strategischer Kampagnenzustand muss zuerst sichtbar, reproduzierbar und testbar sein.

---

## 22. Capture-Grundidee

Theater Command unterscheidet zwischen DCS-Koalition und strategischem Besitzstatus.

Beispiel:

```text
DCS-Airbase-Koalition: technischer Zustand im Mission Editor
Theater-Command-Besitzstatus: strategischer Kampagnenzustand
```

Diese Trennung ist notwendig, weil die Kampagne später persistent und dynamisch werden soll.

Ein Besitzwechsel kann später ausgelöst werden durch:

- erfolgreiche Missionen
- zerstörte Verteidigung
- Logistiklieferungen
- FOB-Aufbau
- Bodeneinheiten im Gebiet
- Skript-Events
- manuelle Debug-Befehle
- gespeicherte Kampagnenstände

Aktuell:

- CaptureSystem bereitet diese Logik vor.
- Capture Ready kann entstehen.
- Capture Ready kann über F10 angezeigt werden.
- Es gibt noch keinen produktiven automatischen Besitzwechsel.

---

## 23. Persistenz-Grundidee

PersistenceSystem `v0.2.6` speichert den strategischen Campaign-Snapshot automatisch; produktiver Restore bleibt deaktiviert.

Beispiele:

- welche Basen blau sind
- welche Basen rot sind
- welche Zonen kontrolliert werden
- welcher Capture-Pressure existiert
- welcher Capture-Progress existiert
- welche Mission Effects bereits angewendet wurden
- welche Missionen verfügbar sind
- welche Missionen aktiv sind
- welche Missionen abgeschlossen sind
- welche FOBs existieren
- welcher Logistikstatus gilt
- welcher AI-State gilt
- welcher IADS-Zustand gilt

Nicht gespeichert werden sollen unnötige temporäre DCS-Objekte.

Persistenz speichert den Kampagnenzustand, nicht jeden kurzlebigen Simulationszustand.

---

## 24. Testziele

CaptureSystem `v0.2.2` gilt aktuell als bestanden, wenn:

- Datei lädt.
- Version wird im Log angezeigt.
- CaptureSystem startet.
- 32 eligibleBases erkannt werden.
- 32 eligibleZones erkannt werden.
- 32 pressureRecords erzeugt werden.
- 32 progressRecords erzeugt werden.
- Mission Completion kann Capture Pressure erzeugen.
- Mission Completion kann Capture Progress aktualisieren.
- Mission Completion kann Capture Ready erzeugen.
- `appliedMissionEffects=1` nach Completion-Test ist.
- `ready=1` nach Completion-Test ist.
- `contested=0` nach Completion-Test ist.
- Capture Ready Zones über F10 sichtbar sind.
- Mission Effects nicht doppelt angewendet werden.
- keine Theater-Command-Lua-Fehler auftreten.
- keine Lua-Stacktraces auftreten.

PersistenceSystem `v0.2.6` gilt als bestanden, wenn:

- Datei lädt.
- Modul startet.
- keine Theater-Command-Lua-Fehler auftreten.
- keine Lua-Stacktraces auftreten.

Noch offen:

- kontrollierter state-only Ownership-Wechsel aus Capture Ready
- `Fail Active Mission 1` praktisch testen
- Mission Effects auf Logistics anwenden
- Mission Effects auf AI anwenden
- Mission Effects auf IADS anwenden
- produktive Besitzwechsel
- Persistence-Sandbox-Dateischreibtest
- Save/Load
- Autosave

---

## 25. Erwartete Logmarker

Aktuelle erwartete Capture-Logmarker:

```text
[TC] [CaptureSystem] Loaded src/campaign/tc_capture_system.lua v0.2.2
[TC] [CaptureSystem] Capture progress updated: zones=32, ready=0, contested=0, appliedMissionEffects=0
[TC] [CaptureSystem] Capture eligibility summary: bases=32, zones=32, nonCaptureBases=193, nonCaptureZones=14
[TC] [CaptureSystem] Capture pressure summary: pressureRecords=32, progressRecords=32, appliedMissionEffects=0
```

Erwartete Logmarker nach Mission Completion:

```text
[TC] [MissionGenerator] Mission outcome prepared: MISSION_2 [COMPLETED] stateOnly=true effects=prepared
[TC] [CaptureSystem] Capture pressure added: zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE amount=105 progress=100%
[TC] [CaptureSystem] Mission effect applied to capture: mission=MISSION_2 zone=ZONE_AIRBASE_ABU_AL_DUHUR owner=BLUE pressure=105
[TC] [CaptureSystem] Completed mission effects processed: applied=1, skipped=0, failed=0, appliedMissionEffects=1
[TC] [CaptureSystem] Capture progress updated: zones=32, ready=1, contested=0, appliedMissionEffects=1
[TC] [F10Menu] Capture ready zones shown through F10
```

Aktuelle Persistence-Erwartung:

- PersistenceSystem lädt.
- PersistenceSystem startet.
- kein produktiver Save/Load.

Der genaue Wortlaut einzelner Persistence-Logs kann je nach Implementierung variieren.

Wichtig ist:

- keine Fehler
- kein Stacktrace
- Main und Loader bleiben sauber

---

## 26. Abgrenzung

Nicht Aufgabe von `src/campaign/`:

- Airbases aus DCS auslesen
- Zonen geometrisch erzeugen
- CTLD-Logistik direkt abwickeln
- FOBs physisch spawnen
- Missionen generieren
- CAPs starten
- IADS-Netzwerke aufbauen
- F10-Menüs erzeugen
- Debug-Zeichnungen erzeugen
- Vendor-Dateien verändern

Diese Aufgaben gehören in andere Bereiche.

Campaign entscheidet über strategischen Besitz, Fortschritt und Speicherzustand.

---

## 27. Nächster sinnvoller Schritt

Der nächste sinnvolle Schritt liegt technisch im UI-Bereich, betrifft aber direkt Campaign/Capture.

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

## 28. Zielbild

`src/campaign/` ist das strategische Herz von Theater Command DCS.

Der Campaign-Bereich verbindet:

- World-Daten
- Capture-Zustand
- Missionsergebnisse
- Logistik
- FOBs
- AI-Reaktionen
- IADS-Zustand
- Persistenz

Aktueller Status:

- CaptureSystem `v0.2.2` ist state-first bestanden.
- Mission Completion zu Capture Pressure ist bestätigt.
- Mission Completion zu Capture Progress ist bestätigt.
- Capture Ready ist bestätigt.
- Capture Ready ist über F10 sichtbar.
- PersistenceSystem `v0.2.6` lädt/startet dirty-aware; Embedded-Scheduler und Fehler/Retry sind bestanden.
- produktive Besitzwechsel und Startup-Restore folgen später.

Nächster notwendiger Zwischenschritt im Gesamtprojekt:

```text
F10Menu v0.2.3 mit kontrolliertem state-only Capture Ready Apply
```
