# Persistence

Diese Datei beschreibt das geplante Persistenzsystem von **Theater Command DCS**.

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

---

## 1. Zweck der Persistenz

Persistenz soll langfristig ermöglichen, dass der Kampagnenzustand über einzelne DCS-Missionsläufe hinaus erhalten bleibt.

Theater Command DCS soll nicht bei jedem Missionsstart komplett neu beginnen.

Gespeichert werden sollen später unter anderem:

- Besitzstatus von Airbases
- Besitzstatus von Zonen
- Capture-Pressure
- Capture-Progress
- Capture-Events
- Logistics Hubs
- FOB-Zustände
- verfügbare Missionen
- aktive Missionen
- abgeschlossene Missionen
- fehlgeschlagene Missionen
- AI-State
- IADS-State
- Ressourcen
- Kampagnenphase
- wichtige Ereignisse

Aktuell ist Persistenz noch nicht produktiv aktiv.

Das vorhandene PersistenceSystem ist eine vorbereitete Grundstruktur.

---

## 2. Aktueller technischer Stand

Stand:

    2026-06-29

Aktive Datei:

    src/campaign/tc_persistence_system.lua

Status:

    Grundstruktur vorhanden
    Modul lädt
    Modul startet
    produktiver Dateischreibtest offen

Aktuell bestätigt:

- PersistenceSystem wird in der Ladefolge eingebunden.
- PersistenceSystem lädt ohne Theater-Command-Lua-Fehler.
- PersistenceSystem startet als Grundstruktur.
- Es gibt noch keinen produktiven Save/Load-Test im DCS-Dateisystem.
- Es gibt noch keinen bestätigten DCS-Sandbox-Dateischreibtest.
- Es gibt noch keine vollständige Kampagnenpersistenz.

Wichtig:

    Persistenz darf erst produktiv werden, wenn DCS-Dateizugriff und Save/Load-Verhalten praktisch getestet wurden.

---

## 3. Aktueller getesteter Gesamtstand

Der aktuelle state-first Runtime-Stand ist bestanden.

Bestätigte Systeme:

| System | Datei | Version | Status |
|---|---|---:|---|
| Airbase Scanner | `src/world/tc_airbase_scanner.lua` | `v0.2.2` | bestanden |
| ZoneFactory | `src/world/tc_zone_factory.lua` | `v0.2.0` | bestanden |
| CaptureSystem | `src/campaign/tc_capture_system.lua` | `v0.2.1` | bestanden |
| PersistenceSystem | `src/campaign/tc_persistence_system.lua` | Grundstruktur | lädt/startet |
| LogisticsDelivery | `src/logistics/tc_logistics_delivery.lua` | `v0.2.0` | bestanden |
| FobSystem | `src/logistics/tc_fob_system.lua` | `v0.2.0` | bestanden |
| MissionGenerator | `src/missions/tc_mission_generator.lua` | `v0.2.2` | bestanden |
| AICapManager | `src/ai/tc_ai_cap_manager.lua` | `v0.2.0` | bestanden |
| F10Menu | `src/ui/tc_f10_menu.lua` | `v0.2.0` | bestanden |

Aktuelle bestätigte Werte:

    Syria airbase-like objects: 225
    relevante Kampagnenzonen: 46
    capture-fähige Ziele: 32
    Capture-Pressure-Records: 32
    Capture-Progress-Records: 32
    Logistics Hubs: 46
    FOB-Kandidaten: 6
    Blue FOBs: 2
    Mission candidates: 69
    verfügbare Missionen: 10
    F10 Commands: 26
    CAP Requests: 12

Bewertung:

    Die State-Grundlage ist inzwischen ausreichend stabil, um einen ersten Persistence-Sandbox-Test vorzubereiten.
    Trotzdem ist der nächste unmittelbare Schritt zuerst F10-Sichtbarkeit für Capture-/Pressure-Daten.

---

## 4. Designprinzip

Auch für Persistenz gilt das Theater-Command-Grundprinzip:

    erst State
    dann Sichtbarkeit
    dann Tests
    dann produktive Persistenz

Persistenz darf nicht frühzeitig unkontrolliert produktiv werden.

Grund:

- DCS-Dateizugriff kann durch Sandbox-Verhalten eingeschränkt sein.
- Save-Dateien können beschädigt oder unvollständig sein.
- Ladefehler dürfen die Kampagne nicht unspielbar machen.
- State-Strukturen ändern sich aktuell noch.
- Persistenz muss mit Modulversionen umgehen können.
- Persistenz muss defensive Fehlerbehandlung besitzen.

Aktuelle Entscheidung:

    Kein produktiver Save/Load ohne vorherigen DCS-Sandbox-Test.

---

## 5. State-first als Voraussetzung

Persistenz speichert nicht direkt DCS-Objekte.

Persistenz speichert Theater-Command-State.

Zentraler Zustand:

    TC.State
    TC.state

Aktuelle State-Bereiche:

    State.Core
    State.Modules
    State.Features
    State.Bases
    State.Zones
    State.Campaign
    State.Logistics
    State.Missions
    State.AI
    State.UI
    State.Persistence

Spätere Persistenz soll diese Bereiche geordnet speichern und wiederherstellen.

Wichtig:

    Framework-Objekte von MOOSE, CTLD oder Skynet sollen nicht direkt gespeichert werden.
    Gespeichert wird nur der eigene Theater-Command-Kampagnenzustand.

---

## 6. Was aktuell noch nicht gespeichert wird

Aktuell wird noch nichts produktiv gespeichert.

Noch nicht aktiv:

- keine produktive Save-Datei
- kein produktiver Load
- kein automatischer Autosave
- kein Save nach Mission Activation
- kein Save nach Mission Completion
- kein Save nach Capture-Event
- kein Save nach FOB-Änderung
- kein Save nach Logistics-Änderung
- kein Save nach AI-Entscheidung
- kein Save nach IADS-Ereignis

Grund:

    DCS-Dateizugriff muss zuerst getestet werden.
    State-Strukturen werden noch erweitert.
    Mission completed/failed und Mission Effects sind noch nicht produktiv getestet.

---

## 7. Geplanter Speicherumfang

Langfristig soll Persistenz mehrere Bereiche speichern.

Geplante Bereiche:

- Metadata
- Campaign
- Bases
- Zones
- Capture
- Logistics
- FOBs
- Missions
- AI
- IADS
- Events
- Versioning

Diese Bereiche sollen möglichst robust, lesbar und erweiterbar sein.

---

## 8. Metadata

Metadata soll Informationen zur Save-Datei enthalten.

Mögliche Felder:

- projectName
- campaignName
- mapName
- saveVersion
- createdAt
- updatedAt
- missionName
- theaterCommandVersion
- schemaVersion
- dcsVersion optional
- notes optional

Beispielinhalt:

    projectName: Theater Command DCS
    campaignName: Operation Levant Reclamation
    mapName: Syria
    saveVersion: 1
    schemaVersion: 1

Zweck:

    Save-Dateien müssen später eindeutig interpretierbar sein.

---

## 9. Campaign State

Campaign State soll den übergeordneten Kampagnenzustand speichern.

Mögliche Felder:

- campaignId
- campaignName
- phase
- day
- turn
- blueProgress
- redProgress
- currentFrontState
- activeObjectives
- completedObjectives
- failedObjectives
- lastUpdate
- eventHistory

Aktueller Stand:

    Campaign State ist in Grundzügen vorhanden.
    Ein produktives Kampagnenphasenmodell ist noch nicht final.

---

## 10. Airbase Persistenz

Airbase State soll speichern:

- airbaseKey
- name
- category
- coalition
- owner
- position
- strategicRelevance
- captureCandidate
- missionCandidate
- logisticsCandidate
- linkedZone
- damageState
- operationalState
- lastOwnerChange
- eventHistory

Aktuelle Grundlage:

    Airbase Scanner v0.2.2 klassifiziert 225 airbase-like objects.
    32 Objekte sind capture-/mission-fähig.
    46 Objekte sind logistics-fähig.
    Akrotiri ist Blue Start Base.

Persistenzziel:

    Airbase-Besitz und wichtige Airbase-Zustände sollen nach Missionsneustart erhalten bleiben.

---

## 11. Zone Persistenz

Zone State soll speichern:

- zoneKey
- name
- type
- owner
- coalition
- linkedBase
- position
- radius
- captureEnabled
- missionEnabled
- logisticsEnabled
- startBase
- status
- lastUpdate

Aktuelle Grundlage:

    ZoneFactory v0.2.0 erzeugt 46 relevante Kampagnenzonen.
    Davon sind 32 Capture-Zonen.
    Davon sind 32 Mission-Zonen.
    Davon sind 46 Logistics-Zonen.

Persistenzziel:

    Zone-Besitz und Zone-Status sollen über Sessions erhalten bleiben.

---

## 12. Capture Persistenz

Capture State soll speichern:

- eligibleBases
- eligibleZones
- captureEvents
- pressureRecords
- progressRecords
- readyZones
- contestedZones
- appliedMissionEffects
- lastCaptureUpdate
- ownershipChanges

Aktuelle Grundlage:

    CaptureSystem v0.2.1 erzeugt 32 Pressure-Records.
    CaptureSystem v0.2.1 erzeugt 32 Progress-Records.
    appliedMissionEffects=0 ist aktuell erwartbar.
    ready=0 ist aktuell erwartbar.
    contested=0 ist aktuell erwartbar.

Persistenzziel:

    Capture-Pressure und Capture-Progress sollen nicht nach jedem Missionsstart verloren gehen.

Wichtig:

    Capture-Pressure muss vor produktiver Persistenz im F10 oder Debug sichtbar sein.
    Deshalb ist F10-Capture-/Pressure-Sichtbarkeit der nächste sinnvolle Zwischenschritt.

---

## 13. Logistics Persistenz

Logistics State soll speichern:

- hubId
- hubName
- owner
- status
- supply
- fuel
- ammo
- engineering
- repairCapacity
- linkedZone
- linkedBase
- cargoRequired
- cargoDelivered
- deliveryHistory
- lastUpdate

Aktuelle Grundlage:

    LogisticsDelivery v0.2.0 erzeugt 46 Logistics Hubs.
    Blue Hubs: 7
    Red Hubs: 24
    Neutral Hubs: 15
    Active Hubs: 31
    Limited Hubs: 15
    Locked Hubs: 0

Persistenzziel:

    Logistics Hubs sollen später ihren Vorrat, Zustand und Verlauf behalten.

Aktuelle Einschränkung:

    Es gibt noch keine echten CTLD-Cargo-Aktionen.
    Es gibt noch keinen produktiven Supply-Verbrauch.

---

## 14. FOB Persistenz

FOB State soll speichern:

- fobId
- name
- owner
- status
- linkedHub
- linkedZone
- linkedBase
- buildProgress
- supply
- fuel
- ammo
- engineering
- repairState
- facilities
- damageState
- cargoDelivered
- cargoRequired
- lastUpdate

Aktuelle Grundlage:

    FobSystem v0.2.0 erzeugt 6 FOB-Kandidaten.
    FobSystem v0.2.0 erzeugt 2 Blue-FOBs.
    FOB Ercan
    FOB Gecitkale
    Status: UNDER_CONSTRUCTION

Persistenzziel:

    FOB-Aufbau und FOB-Versorgung sollen später dauerhaft erhalten bleiben.

Aktuelle Einschränkung:

    Es werden noch keine echten CTLD-FOBs gebaut.
    FOBs sind aktuell State-only.

---

## 15. Mission Persistenz

Mission State soll speichern:

- missionId
- missionKey
- name
- type
- status
- owner
- targetZone
- targetBase
- targetFOB
- priority
- objective
- briefing
- progress
- activationMetadata
- executionPlan
- effects
- createdAt
- activatedAt
- completedAt
- failedAt
- eventHistory

Aktuelle Grundlage:

    MissionGenerator v0.2.2 erzeugt 10 verfügbare Missionen.
    MissionGenerator erzeugt Objectives.
    MissionGenerator erzeugt Briefings.
    MissionGenerator erzeugt Progress-Daten.
    MissionGenerator erzeugt Activation Metadata.
    Missionen können über F10 aktiviert werden.
    Aktivierte Missionen bleiben stateOnly=true.
    Spawn-Hooks bleiben reserved.

Persistenzziel:

    Verfügbare, aktive, abgeschlossene und fehlgeschlagene Missionen sollen später erhalten bleiben.

Aktuelle Einschränkung:

    Mission completed/failed ist noch nicht produktiv testbar.
    Mission Effects sind noch nicht produktiv angewendet.

---

## 16. AI Persistenz

AI State soll später speichern:

- CAP-Zonen
- CAP-Requests
- threatLevel
- reactionState
- activeAIPlans
- completedAIPlans
- blueIntent
- redIntent
- priorityZones
- activeOperations
- pendingOperations
- resourceAssessment
- threatAssessment
- decisionHistory

Aktuelle Grundlage:

    AICapManager v0.2.0 erzeugt CAP-State.
    cap zone candidates: 31
    auto-registered CAP zones: 12
    CAP requests: 12
    reactionState: AIR_REACTION_REQUESTED
    threatLevel: HIGH

Persistenzziel:

    AI-Entscheidungen und AI-Zustand sollen später über Missionsläufe erhalten bleiben.

Aktuelle Einschränkung:

    Vollständiger AI Director ist noch nicht implementiert.
    AI Persistenz ist noch nicht aktiv.

---

## 17. IADS Persistenz

IADS State soll später speichern:

- IADS-Sites
- IADS-Sektoren
- SAM-Status
- EWR-Status
- Command-Status
- Damage State
- Suppression State
- Radar State
- Ammo State
- linkedZones
- linkedBases
- IADS Events
- Repair State

Aktuelle Grundlage:

    Skynet IADS wird geladen.
    MissionGenerator reserviert Skynet-Hooks.
    SEAD/DEAD/IADS_SUPPRESSION sind konzeptionell vorbereitet.
    Eigenes Theater-Command-IADS-Modul ist noch nicht implementiert.

Persistenzziel:

    IADS-Schäden, Unterdrückung und Wiederherstellung sollen später persistent werden.

Aktuelle Einschränkung:

    IADS State existiert noch nicht produktiv.
    IADS-Persistenz ist noch nicht aktiv.

---

## 18. UI Persistenz

UI State muss nicht zwingend vollständig persistent sein.

Mögliche optionale Daten:

- zuletzt angezeigte Mission
- aktive F10-Menüstruktur
- Debug-Flags
- UI-Version
- letzte Statusabfragen

Aktuelle Grundlage:

    F10Menu v0.2.0 ist aktiv.
    F10Menu erzeugt 26 Commands.
    Missionen können angezeigt und aktiviert werden.
    F10Menu speichert UI-State teilweise in TC.State.UI.

Persistenzziel:

    UI-State ist optional.
    Kritischer sind Campaign, Capture, Logistics, FOBs, Missions, AI und IADS.

---

## 19. Save-Dateiformat

Das endgültige Save-Dateiformat ist noch nicht entschieden.

Mögliche Varianten:

- Lua Table
- JSON-artige Struktur
- einfache Key-Value-Struktur
- eigenes serialisiertes Lua-Format

Wahrscheinlich sinnvoll:

    Lua Table oder JSON-ähnliche Struktur, solange sie in DCS robust lesbar und schreibbar ist.

Anforderungen:

- menschenlesbar
- robust
- versionierbar
- fehlertolerant
- erweiterbar
- keine direkte Speicherung von komplexen DCS-Objekten
- keine direkte Speicherung von Framework-Objekten

---

## 20. Save-Dateipfad

Der endgültige Save-Dateipfad ist noch offen.

Mögliche Orte:

- Saved Games
- DCS Missions Script Folder
- eigener Theater-Command-Save-Ordner
- lfs.writedir-basierter Pfad

Bevorzugt zu prüfen:

    lfs.writedir()

Warum:

    DCS-Saved-Games-Strukturen sind für nutzerbezogene Daten grundsätzlich plausibel.
    Der genaue Zugriff muss aber praktisch getestet werden.

Aktueller Stand:

    Noch kein produktiver Dateischreibtest.
    Save-Pfad noch nicht final.

---

## 21. DCS-Sandbox

DCS kann Dateizugriffe einschränken.

Wichtige Fragen:

- Ist `io.open` verfügbar?
- Ist `lfs` verfügbar?
- Wo darf geschrieben werden?
- Darf im Missionskontext geschrieben werden?
- Sind zusätzliche DCS-Sanitizer-Anpassungen nötig?
- Wird Multiplayer anders behandelt?
- Bleibt Dateizugriff nach DCS-Updates stabil?

Aktuelle Entscheidung:

    Kein produktiver Persistenzbau ohne vorherigen Sandbox-Test.

Erster Test soll nur prüfen:

- Datei schreiben
- Datei lesen
- Datei löschen oder überschreiben
- Fehler sauber loggen
- keinen Kampagnenzustand riskieren

---

## 22. Minimaler erster Persistenztest

Ein sinnvoller erster Test wäre ein reiner Sandbox-Test.

Mögliche Datei:

    src/campaign/tc_persistence_system.lua

Ziel:

- PersistenceSystem-Version erhöhen
- Save-Testfunktion vorbereiten
- kleinen Test-State schreiben
- Datei wieder lesen
- Ergebnis loggen
- keine produktive Kampagnenpersistenz
- keine automatischen Saves
- keine Änderung an anderen Systemen

Mögliche Testdaten:

    project = Theater Command DCS
    campaign = Operation Levant Reclamation
    timestamp = timer.getTime()
    test = true

Akzeptanzkriterien:

- PersistenceSystem lädt.
- Testfunktion läuft.
- Datei wird erzeugt oder Fehler wird sauber geloggt.
- Datei kann gelesen werden oder Fehler wird sauber geloggt.
- DCS stürzt nicht ab.
- Main und Loader bleiben sauber.
- keine anderen Systeme regressieren.

Aber:

    Dieser Persistenztest ist nicht der direkte nächste Schritt.
    Zuerst soll Capture-/Pressure-Status im F10 sichtbar werden.

---

## 23. Save/Load-Reihenfolge

Später muss die Load-Reihenfolge sauber definiert werden.

Wahrscheinliche Reihenfolge:

1. Frameworks laden
2. Core laden
3. State initialisieren
4. World-Daten erzeugen
5. ZoneFactory erzeugen
6. Save-Datei laden
7. gespeicherten State gegen aktuelle World-Daten validieren
8. Campaign State anwenden
9. Logistics State anwenden
10. FOB State anwenden
11. Mission State anwenden
12. AI State anwenden
13. IADS State anwenden
14. UI initialisieren
15. Debug/Reports erzeugen

Wichtig:

    Save-Datei darf nicht blind den aktuellen DCS-Weltzustand überschreiben.
    Gespeicherte Daten müssen gegen aktuelle World- und Zone-Daten validiert werden.

---

## 24. Versionierung

Persistenz braucht Versionierung.

Mögliche Felder:

- schemaVersion
- saveVersion
- theaterCommandVersion
- campaignVersion
- moduleVersions
- createdAt
- updatedAt

Warum:

    Die State-Struktur wird sich ändern.
    Alte Saves müssen erkannt werden.
    Inkompatible Saves dürfen nicht unkontrolliert geladen werden.
    Migrationslogik kann später nötig werden.

Aktuelle Entscheidung:

    Versionierung muss von Anfang an mitgedacht werden, auch wenn produktive Persistenz noch offen ist.

---

## 25. Fehlerbehandlung

Persistenz muss defensive Fehlerbehandlung besitzen.

Mögliche Fehler:

- Datei existiert nicht
- Datei ist leer
- Datei ist beschädigt
- Datei hat falsche Version
- Datei enthält unvollständige Daten
- Datei enthält ungültige Keys
- DCS-Dateizugriff verboten
- Schreibpfad nicht verfügbar
- Lesepfad nicht verfügbar
- Save während Mission unterbrochen

Erwartetes Verhalten:

- Fehler loggen
- Kampagne nicht abbrechen
- Fallback auf neuen State
- klare Warnung ausgeben
- keine nil-Index-Fehler
- keine Lua-Stacktraces

---

## 26. Autosave

Autosave ist ein späteres Ziel.

Mögliche Autosave-Auslöser:

- Mission aktiviert
- Mission abgeschlossen
- Mission fehlgeschlagen
- Capture-Progress verändert
- Zone erobert
- FOB-Status verändert
- Logistics Hub verändert
- AI Operation abgeschlossen
- IADS Site beschädigt
- Mission endet
- periodischer Timer

Aktueller Stand:

    Kein Autosave aktiv.
    Kein produktives Save aktiv.

Grund:

    Zuerst müssen Dateizugriff, Save-Format und State-Stabilität geprüft werden.

---

## 27. Manuelles Save/Load über F10

Später möglich:

- Save Campaign
- Load Campaign
- Show Save Status
- Show Last Save
- Debug Save Test
- Debug Load Test

Aktuell:

    F10Menu v0.2.0 ist aktiv.
    F10Menu enthält noch keine Persistenzbefehle.
    Nächster F10-Schritt ist Capture-/Pressure-Sichtbarkeit, nicht Persistence.

---

## 28. Persistenz und Mission Editor

Persistenz soll langfristig möglichst wenig Mission-Editor-Arbeit benötigen.

Mission Editor stellt bereit:

- Karte
- Koalitionen
- Slots
- Trigger
- Templates
- Zonen
- Frameworks

Persistenz speichert:

- Kampagnenzustand
- dynamische Entwicklungen
- Fortschritt
- Besitz
- Missionen
- Logistik
- AI
- IADS

Wichtig:

    Per DO SCRIPT FILE geladene Lua-Dateien werden in die .miz eingebettet.
    Save-Dateien sollen nicht in der .miz liegen, sondern außerhalb im Dateisystem.

---

## 29. Persistenz und Multiplayer

Multiplayer-Persistenz ist ein späteres Thema.

Mögliche Fragen:

- Wer schreibt die Save-Datei?
- Nur Host oder Server?
- Wann wird gespeichert?
- Was passiert bei Disconnect?
- Was passiert bei Serverrestart?
- Wie wird Race Condition verhindert?
- Wie wird Save-Konsistenz gesichert?

Aktueller Stand:

    Multiplayer-Persistenz wird noch nicht bearbeitet.
    Erste Persistenztests erfolgen im einfachen DEV-Testkontext.

---

## 30. Risiken

Wichtige Risiken:

- DCS-Sandbox blockiert Dateizugriff.
- Save-Datei wird beschädigt.
- Save-Datei passt nicht mehr zur aktuellen Mission.
- Save-Datei enthält alte Zonen oder alte Airbase-Keys.
- DCS-Update verändert Daten.
- Lua-Serialisierung ist fehleranfällig.
- Mission Effects werden vor Persistenz falsch angewendet.
- Autosave speichert inkonsistenten Zwischenzustand.
- Multiplayer erzeugt konkurrierende Schreibzugriffe.

Gegenmaßnahmen:

- erster Test nur Sandbox-Schreibtest
- Save-Versionierung
- defensive Load-Funktion
- Validierung gegen aktuelle World-Daten
- keine produktive Persistenz ohne Fallback
- keine automatischen Saves in erster Version
- klare Logmarker
- keine parallelen Großänderungen

---

## 31. Aktuelle Akzeptanzkriterien für PersistenceSystem

Aktuell bestanden:

- PersistenceSystem-Datei existiert.
- PersistenceSystem wird geladen.
- PersistenceSystem startet als Grundstruktur.
- keine Theater-Command-Lua-Fehler.
- keine Lua-Stacktraces.
- Main und Loader bleiben sauber.

Noch offen:

- DCS-Sandbox-Dateischreibtest
- Save-Datei erzeugen
- Save-Datei lesen
- Save-Format definieren
- Load-Reihenfolge definieren
- State-Validierung
- vollständige Kampagnenpersistenz
- Autosave
- F10-Save-/Load-Befehle

---

## 32. Warum Persistenz noch nicht der nächste Schritt ist

Persistenz ist wichtig, aber aktuell nicht der nächste konkrete Schritt.

Gründe:

- Capture-Pressure und Capture-Progress sind vorhanden, aber im Spiel noch nicht sichtbar.
- Mission Effects sind noch nicht praktisch getestet.
- Mission completed/failed ist noch nicht testbar.
- Save/Load sollte erst erfolgen, wenn State-Daten besser sichtbar und interpretierbar sind.
- Bei Persistenzfehlern muss klar erkennbar sein, welche State-Daten betroffen sind.

Deshalb:

    Erst Capture-/Pressure-Sichtbarkeit im F10-Menü.
    Danach Mission completed/failed.
    Danach Mission Effects testen.
    Danach Persistence-Sandbox-Test.

---

## 33. Nächster sinnvoller Schritt

Der nächste sinnvolle Schritt liegt nicht direkt bei PersistenceSystem.

Empfohlene nächste Datei:

    src/ui/tc_f10_menu.lua

Ziel:

    Capture-/Pressure-Status im F10-Menü sichtbar machen.

Geplante neue F10-Funktionen:

    Show Capture Status
    Show Capture Ready Zones
    Show Pressure Contested Zones

Akzeptanzkriterien:

- F10Menu lädt als neue Version.
- bisherige 26 Commands bleiben funktionsfähig.
- neue Capture-Commands werden ergänzt.
- Capture Status zeigt mindestens:
  - eligibleBases
  - eligibleZones
  - pressureRecords
  - progressRecords
  - captureReady
  - pressureContested
  - appliedMissionEffects
- Capture Ready Zones können angezeigt werden.
- Pressure Contested Zones können angezeigt werden.
- keine echten Spawns
- keine CTLD-Aktion
- keine Skynet-Aktion
- keine Lua-Fehler
- keine Theater-Command-Fehler

---

## 34. Aktueller Status

PersistenceSystem ist vorbereitet, aber noch nicht produktiv.

Aktuelle Fähigkeit:

- PersistenceSystem lädt.
- PersistenceSystem startet.
- State-Struktur ist inzwischen umfangreich genug für spätere Save/Load-Tests.
- Es gibt aber noch keinen bestätigten Dateischreibtest.

Noch nicht vorhanden:

- produktiver Save
- produktiver Load
- Save-Dateiformat
- Save-Dateipfad
- Autosave
- Save/Load über F10
- Kampagnenzustand nach Neustart wiederherstellen

Nächster notwendiger Zwischenschritt im Gesamtprojekt:

    Capture-/Pressure-Sichtbarkeit im F10-Menü.

Danach sinnvoll:

    Mission completed/failed testbar machen.
    Mission Effects kontrolliert testen.
    Persistence-Sandbox-Test vorbereiten.
