# src/campaign/README.md

Diese Datei beschreibt den Campaign-Bereich von **Theater Command DCS**.

Der Campaign-Bereich enthält eigene Lua-Logik für strategischen Kampagnenzustand, Capture-System und Persistenzvorbereitung.

---

## 1. Zweck des Campaign-Bereichs

`src/campaign/` ist für den strategischen Zustand der Kampagne zuständig.

Dieser Bereich entscheidet nicht, welche Airbases in DCS existieren.

Diese Daten kommen aus:

    src/world/

Der Campaign-Bereich entscheidet, was diese Daten strategisch bedeuten.

Langfristig verwaltet `src/campaign/`:

- Besitzstatus von Basen
- Besitzstatus von Zonen
- Capture-Eligibility
- Capture-Pressure
- Capture-Progress
- Mission Effects
- Kampagnenfortschritt
- Kampagnenzustand
- Persistenzvorbereitung
- spätere Save-/Load-Logik

Aktuell ist der Campaign-Bereich nicht mehr nur geplant.

Das CaptureSystem ist aktiv und getestet.

Das PersistenceSystem ist als Grundstruktur aktiv und lädt/startet.

---

## 2. Kampagnenkontext

Erste Kampagne:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

Grundannahme:

    Akrotiri ist initial blau.
    Zypern ist initial blauer Ausgangsraum.
    Syrische Festlandbasen sind initial rot.
    Syrische Festlandzonen sind initial rot.
    Neutrale Sonderfälle werden später ausdrücklich definiert.

---

## 3. Aktueller technischer Stand

Stand:

    2026-06-29

Aktive Dateien:

    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua

Getesteter Stand:

    CaptureSystem: v0.2.1 bestanden
    PersistenceSystem: Grundstruktur lädt/startet

Bestätigt durch DCS-Logtests:

- CaptureSystem lädt.
- CaptureSystem startet.
- CaptureSystem erkennt capture-fähige Basen und Zonen.
- CaptureSystem erzeugt Pressure-Records.
- CaptureSystem erzeugt Progress-Records.
- CaptureSystem bereitet Mission Effects vor.
- PersistenceSystem lädt.
- PersistenceSystem startet als Grundstruktur.
- Es gab keinen Theater-Command-Lua-Fehler.
- Es gab keinen Lua-Stacktrace.

---

## 4. Aktuelle bestätigte Capture-Werte

CaptureSystem v0.2.1:

    eligibleBases: 32
    eligibleZones: 32
    nonCaptureBases: 193
    nonCaptureZones: 14
    pressureRecords: 32
    progressRecords: 32
    appliedMissionEffects: 0
    ready: 0
    contested: 0

Bewertung:

    CaptureSystem arbeitet nicht auf allen 225 DCS-Airbase-like Objects.
    CaptureSystem arbeitet auf 32 fachlich geeigneten Capture-Zielen.
    32 Pressure-Records und 32 Progress-Records werden erzeugt.
    appliedMissionEffects=0 ist aktuell korrekt, weil Mission Effects noch nicht produktiv angewendet werden.
    ready=0 und contested=0 sind im aktuellen Teststand korrekt.

---

## 5. Architekturregel

Externe Frameworks liegen unter:

    vendor/

Eigene Theater-Command-Logik liegt unter:

    src/

Der Campaign-Bereich gehört zur eigenen Theater-Command-Logik.

Frameworks werden nicht verändert.

Dateien in `src/campaign/` werden nach Theater-Command-Aufgaben benannt, nicht nach Frameworks.

Nicht gewünscht:

    src/campaign/tc_moose_campaign.lua
    src/campaign/tc_mist_campaign.lua
    src/campaign/tc_campaign_all_in_one.lua
    src/campaign/tc_capture_and_persistence_all_in_one.lua

Gewünscht:

    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua

Eine Campaign-Datei darf intern DCS-API, MIST, MOOSE, CTLD oder Skynet-IADS-Daten nutzen.

Der Dateiname richtet sich aber immer nach der Theater-Command-Aufgabe.

---

## 6. Aktive Dateien

Aktuell aktive Dateien:

    src/campaign/tc_capture_system.lua
    src/campaign/tc_persistence_system.lua

`tc_capture_system.lua`:

    aktives strategisches Capture-Modul
    Version v0.2.1
    bestanden

`tc_persistence_system.lua`:

    vorbereitete Persistenz-Grundstruktur
    lädt/startet
    produktiver Dateischreibtest offen

Mögliche spätere Dateien:

    src/campaign/tc_campaign_events.lua
    src/campaign/tc_campaign_progress.lua
    src/campaign/tc_ownership_rules.lua
    src/campaign/tc_mission_effects.lua

Diese Zusatzdateien werden erst angelegt, wenn sie wirklich benötigt werden.

---

## 7. CaptureSystem

Datei:

    src/campaign/tc_capture_system.lua

Getestete Version:

    v0.2.1

Status:

    bestanden

Aktuelle Aufgaben:

- Capture-Eligibility ableiten
- capture-fähige Basen erkennen
- capture-fähige Zonen erkennen
- nicht capture-fähige Objekte ausschließen
- Capture-Pressure vorbereiten
- Capture-Progress vorbereiten
- Mission Effects vorbereiten
- Capture-State aktualisieren
- Capture-Summary loggen
- State für spätere F10-/Debug-Anzeige bereitstellen

Wichtig:

    CaptureSystem scannt keine Airbases selbst.
    CaptureSystem erzeugt keine Zonen selbst.
    CaptureSystem arbeitet mit Daten aus World und ZoneFactory.
    CaptureSystem führt aktuell noch keine echten Besitzwechsel durch.

---

## 8. Capture-Eligibility

Capture-Eligibility entscheidet, welche Objekte strategisch eroberbar sind.

Aktuell capture-fähig:

    32 Basen/Zonen

Aktuell nicht capture-fähig:

    193 Airbase-like Objects
    14 relevante, aber nicht capture-fähige Zonen

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

Capture-Pressure beschreibt später den militärischen Druck auf eine Zone.

Aktueller Stand:

    pressureRecords: 32

Mögliche spätere Einflussfaktoren:

- erfolgreiche Missionen
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

Aktuell:

    Capture-Pressure wird vorbereitet.
    Mission Effects werden noch nicht produktiv angewendet.
    Capture-Pressure ist noch nicht über F10 sichtbar.

Nächster Schritt:

    Capture-/Pressure-Status im F10-Menü sichtbar machen.

---

## 10. Capture-Progress

Capture-Progress beschreibt später den tatsächlichen Fortschritt Richtung Besitzwechsel.

Aktueller Stand:

    progressRecords: 32
    ready: 0
    contested: 0

Mögliche spätere Zustände:

- STABLE
- PRESSURED
- CONTESTED
- READY_FOR_CAPTURE
- CAPTURED
- LOCKED
- BLOCKED

Aktuell:

    Capture-Progress wird vorbereitet.
    Es gibt noch keine Zone mit ready=1.
    Es gibt noch keine contested Zone.
    Besitzwechsel sind noch nicht produktiv aktiv.

---

## 11. Mission Effects

Mission Effects sollen später CaptureSystem beeinflussen.

Aktueller Stand:

    appliedMissionEffects: 0

Das ist erwartbar.

MissionGenerator v0.2.2 erzeugt Mission Records mit Effects.

Diese Effects werden aber noch nicht produktiv auf CaptureSystem angewendet.

Spätere mögliche Mission Effects:

- Capture-Pressure erhöhen
- Capture-Progress erhöhen
- Verteidigungswert senken
- Zone contested setzen
- Zone ready for capture setzen
- Besitzwechsel vorbereiten
- Logistikstatus beeinflussen
- AI-Reaktion auslösen

Nächste Voraussetzung:

    Capture-/Pressure-Daten müssen im F10-Menü sichtbar sein.

---

## 12. PersistenceSystem

Datei:

    src/campaign/tc_persistence_system.lua

Status:

    Grundstruktur vorhanden
    lädt/startet
    produktiver Dateischreibtest offen

Aufgaben aktuell:

- PersistenceSystem als Modul bereitstellen
- State-Struktur vorbereiten
- Save-/Load-Konzept vorbereiten
- defensive Grundstruktur bereitstellen
- späteren DCS-Dateischreibtest ermöglichen

Noch nicht aktiv:

- produktiver Save
- produktiver Load
- Autosave
- Save-Datei
- Save-Pfad
- Kampagnenzustand wiederherstellen
- Missionen speichern
- Capture-State speichern
- Logistics-State speichern
- FOB-State speichern
- AI-State speichern
- IADS-State speichern

Wichtig:

    PersistenceSystem darf erst produktiv werden, wenn DCS-Dateizugriff sauber getestet wurde.

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

    nach Core und World
    vor Logistics, Missions, AI, UI, Main und Loader

---

## 14. Verhältnis zum World-Bereich

Der Campaign-Bereich nutzt Daten aus:

    src/world/

Besonders wichtig:

- `TC.World.AirbaseScanner`
- `TC.World.ZoneFactory`
- `TC.State.Bases`
- `TC.State.Zones`

Aktuelle World-Werte:

    Syria airbase-like objects: 225
    relevante Kampagnenzonen: 46
    captureCandidates: 32
    missionCandidates: 32
    logisticsCandidates: 46

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

    logistics hubs: 46
    blue hubs: 7
    red hubs: 24
    neutral hubs: 15
    active hubs: 31
    limited hubs: 15
    locked hubs: 0

Aktuelle FOB-Werte:

    FOB candidates: 6
    Blue FOBs: 2
    FOB Ercan
    FOB Gecitkale
    Status: UNDER_CONSTRUCTION

Spätere Kopplung:

- FOB Support erhöht Capture-Pressure.
- Logistics Support erhöht Capture-Progress.
- Supply-Mangel erschwert Verteidigung.
- beschädigte Logistics Hubs reduzieren Operationsfähigkeit.
- FOBs ermöglichen Capture-Vorbereitung.

Aktuell:

    Logistics und FOBs sind state-only.
    CaptureSystem ist noch nicht produktiv mit Logistik gekoppelt.

---

## 16. Verhältnis zum Missionsbereich

Der Missionsbereich nutzt Campaign-Daten.

Aktuelle MissionGenerator-Datei:

    src/missions/tc_mission_generator.lua

Getestete Version:

    v0.2.2

Aktuelle MissionGenerator-Werte:

    mission candidates: 69
    fobSupportCandidates: 2
    generated missions: 10
    reservedCreated: 1
    duplicatesSkipped: 1
    typeLimitSkipped: 30

MissionGenerator nutzt Campaign-Daten für:

- Zielauswahl
- Missionstypen
- Priorität
- FOB-Support
- Capture-relevante Missionen
- Mission Effects

Spätere Rückwirkung:

- Mission completed erhöht Capture-Pressure.
- Mission failed erzeugt keine oder negative Wirkung.
- Mission Effects verändern CaptureSystem.
- Missionen können Besitzwechsel vorbereiten.

Aktuell:

    Missionen können über F10 aktiviert werden.
    Mission Activation bleibt state-only.
    Mission Effects werden noch nicht produktiv angewendet.

---

## 17. Verhältnis zum AI-Bereich

AI soll später Campaign-Daten nutzen.

Aktuelle AI-Datei:

    src/ai/tc_ai_cap_manager.lua

Getestete Version:

    v0.2.0

Aktuelle AI-Werte:

    cap zone candidates: 31
    auto-registered CAP zones: 12
    CAP requests: 12
    reactionState: AIR_REACTION_REQUESTED
    threatLevel: HIGH

Spätere AI-Nutzung:

- Zonen unter Druck bewerten
- Gegenangriffe planen
- CAP über kritischen Zonen priorisieren
- Blue-/Red-Operationen planen
- Capture-Erfolge oder Fehlschläge verarbeiten
- Missionsergebnisse gewichten

Aktuell:

    AICapManager ist state-only.
    AI Director ist noch nicht implementiert.
    AI nutzt Capture-Pressure noch nicht produktiv.

---

## 18. Verhältnis zum IADS-Bereich

IADS soll später Campaign-Daten beeinflussen und selbst von Campaign-Daten abhängen.

Aktueller IADS-Stand:

    Skynet IADS wird geladen.
    eigenes Theater-Command-IADS-Modul ist noch nicht implementiert.
    MissionGenerator reserviert Skynet-Hooks.

Spätere Kopplung:

- aktive IADS-Abdeckung erschwert Capture.
- zerstörte SAM-Sites erleichtern Capture.
- SEAD/DEAD-Missionen erzeugen Capture-Vorteile.
- IADS-Zustand beeinflusst MissionGenerator und AI Director.
- IADS-Schäden werden persistent.

Aktuell:

    IADS ist noch nicht mit CaptureSystem gekoppelt.

---

## 19. Verhältnis zum UI-Bereich

F10Menu ist aktiv und zeigt bereits mehrere Statusbereiche.

Aktive UI-Datei:

    src/ui/tc_f10_menu.lua

Getestete Version:

    v0.2.0

Aktuelle F10-Funktionen:

- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Missionsdetails anzeigen
- Missionen aktivieren
- Kampagnenstatus anzeigen
- Logistikstatus anzeigen
- FOB-Status anzeigen
- AI-CAP-Status anzeigen

Aktuell noch nicht sichtbar:

- Capture Status
- Capture Ready Zones
- Pressure Contested Zones

Nächster UI-Schritt:

    Capture-/Pressure-Status im F10-Menü sichtbar machen.

---

## 20. Campaign State

Der Campaign-Bereich arbeitet mit State-Daten.

Wichtige State-Bereiche:

    TC.State.Campaign
    TC.State.Bases
    TC.State.Zones
    TC.State.Capture
    TC.State.Persistence

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

Mögliche Capture-Daten:

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

    CaptureSystem erzeugt bereits Pressure- und Progress-Records.
    produktive Besitzwechsel sind noch nicht aktiv.

---

## 21. State-first-Regel

Der Campaign-Bereich folgt aktuell strikt der state-first-Architektur.

Das bedeutet:

- Campaign erzeugt State.
- CaptureSystem aktualisiert State.
- PersistenceSystem bereitet State-Speicherung vor.
- Mission Effects werden vorbereitet.
- UI soll State sichtbar machen.
- echte Besitzwechsel folgen später.
- produktive Persistenz folgt später.

Nicht aktiv:

- automatische Zone-Capture
- automatische Base-Capture
- produktive Save-/Load-Logik
- Autosave
- MissionEffect-Anwendung
- DCS-Event-basierter Besitzwechsel

Grund:

    Strategischer Kampagnenzustand muss zuerst sichtbar, reproduzierbar und testbar sein.

---

## 22. Capture-Grundidee

Theater Command unterscheidet zwischen DCS-Koalition und strategischem Besitzstatus.

Beispiel:

    DCS-Airbase-Koalition:
    technischer Zustand im Mission Editor

    Theater-Command-Besitzstatus:
    strategischer Kampagnenzustand

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

    CaptureSystem bereitet diese Logik vor.
    Es gibt noch keinen produktiven Besitzwechsel.

---

## 23. Persistenz-Grundidee

Persistenz soll später speichern, was Theater Command strategisch verändert hat.

Beispiele:

- welche Basen blau sind
- welche Basen rot sind
- welche Zonen kontrolliert werden
- welcher Capture-Pressure existiert
- welcher Capture-Progress existiert
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

CaptureSystem v0.2.1 gilt aktuell als bestanden, wenn:

- Datei lädt.
- Version wird im Log angezeigt.
- CaptureSystem startet.
- 32 eligibleBases erkannt werden.
- 32 eligibleZones erkannt werden.
- 32 pressureRecords erzeugt werden.
- 32 progressRecords erzeugt werden.
- appliedMissionEffects=0 ist.
- ready=0 ist.
- contested=0 ist.
- keine Theater-Command-Lua-Fehler auftreten.
- keine Lua-Stacktraces auftreten.

PersistenceSystem gilt aktuell als Grundstruktur bestanden, wenn:

- Datei lädt.
- Modul startet.
- keine Theater-Command-Lua-Fehler auftreten.
- keine Lua-Stacktraces auftreten.

Noch offen:

- Capture-/Pressure-Anzeige im F10
- Mission Effects praktisch anwenden
- Mission completed/failed
- produktive Besitzwechsel
- Persistence-Sandbox-Dateischreibtest
- Save/Load
- Autosave

---

## 25. Erwartete Logmarker

Aktuelle erwartete Capture-Logmarker:

    [TC] [CaptureSystem] Loaded src/campaign/tc_capture_system.lua v0.2.1
    [TC] [CaptureSystem] Capture progress updated: zones=32, ready=0, contested=0
    [TC] [CaptureSystem] Capture eligibility summary: bases=32, zones=32, nonCaptureBases=193, nonCaptureZones=14
    [TC] [CaptureSystem] Capture pressure summary: pressureRecords=32, progressRecords=32, appliedMissionEffects=0

Aktuelle Persistence-Erwartung:

    PersistenceSystem lädt.
    PersistenceSystem startet.
    kein produktiver Save/Load.

Der genaue Wortlaut einzelner Persistence-Logs kann je nach Implementierung variieren.

Wichtig ist:

    keine Fehler
    kein Stacktrace
    Main und Loader bleiben sauber

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

Der nächste sinnvolle Schritt liegt nicht direkt im Campaign-Bereich.

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

    CaptureSystem v0.2.1 ist state-first bestanden.
    PersistenceSystem lädt/startet als Grundstruktur.
    produktive Besitzwechsel und Save/Load folgen später.

Nächster notwendiger Zwischenschritt im Gesamtprojekt:

    F10Menu v0.2.1 mit Capture-/Pressure-Sichtbarkeit.
