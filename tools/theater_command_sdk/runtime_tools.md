# Runtime Tools

## Verbindlicher Stand — 2026-09-29

Die Runtime Tools unterstützen die Diagnose einer laufenden DCS-Instanz im Projekt **Theater Command DCS**.

Sie verwenden insbesondere:

    DCS-SMS

DCS-SMS ist:

    Entwicklungs- und Diagnosewerkzeug

und kein:

    Theater-Command-Runtime-Framework

Kampagnenlogik bleibt unter:

    src/

---

## 1. Aktuell implementiertes Script

Aktuell vorhanden:

    scripts/tc-status.ps1

Das Script dient der technischen Status- und Runtime-Diagnose.

Weitere Runtime-Scripts werden erst angelegt, wenn ein konkreter Entwicklungsbedarf besteht.

---

## 2. DCS-SMS

Bestätigte Version:

    DCS-SMS 0.27.2

Bestätigter Mission-Editor-Hook:

    me-bridge-0.27.2

Verifiziertes Installationsverzeichnis:

    C:\Tools\dcs-sms

Aus dem bestätigten Projektstand wird kein exakter Executable-Pfad wie:

    C:\Tools\dcs-sms\dcs-sms.exe

als autoritativ dokumentiert.

Ein konkreter Executable-Pfad darf erst verwendet beziehungsweise dokumentiert werden, wenn er separat verifiziert wurde.

---

## 3. Claude Code

DCS-SMS wird aktuell vor allem zusammen mit:

    Claude Code

für lokale DCS-Runtime-Diagnose verwendet.

Bestätigter Skill:

    C:\Users\Paul\.claude\skills\dcs-sms\SKILL.md

Typische Aufgaben:

- DCS-Status prüfen
- Mission-Editor-Status prüfen
- Runtime-Lua ausführen
- Theater-Command-State lesen
- CTLD-Live-State lesen
- Units prüfen
- Gruppen prüfen
- Positionen prüfen
- Geschwindigkeiten prüfen
- Grounded-/Airborne-State prüfen
- Logs lesen
- Regressionen durchführen

---

## 4. Zweck

Runtime Tools liefern technische Informationen über eine laufende DCS-Instanz.

Typische Anwendungsfälle:

- Runtime Status
- Hook Status
- Mission Environment
- Theater-Command-State
- Unit State
- Group State
- Trigger State
- Airbase Ownership
- CTLD State
- Framework State
- Log Inspection
- Regression Testing

Sie dienen nicht dazu, Kampagnenlogik aus `src/` zu ersetzen.

---

## 5. Bewährte DCS-SMS-Fähigkeiten

Im Projekt erfolgreich verwendet wurden unter anderem:

- Statusabfragen
- Mission-Environment-Lua
- Mission- und GUI-Execution
- Trigger-Inspektion
- gezielte Trigger-Aktionsbearbeitung
- Embedded-Resource-Registrierung
- Embedded-Resource-Read-back
- Mission-Editor-Speicherung
- Log-Lesen
- Runtime-State-Inspektion
- Unit-/Group-State
- gezielte Regressionen

Ein erfolgreich getesteter Workflow beweist nicht automatisch, dass sämtliche DCS-SMS-Funktionen im Projekt validiert sind.

---

## 6. Nicht destruktiv als Standard

Runtime Tools sollen standardmäßig:

    read-only
    beziehungsweise
    nicht destruktiv

arbeiten.

Eine Runtime-Mutation darf nur erfolgen, wenn:

- sie für den konkreten Test erforderlich ist,
- die Änderung bewusst geplant ist,
- der betroffene State bekannt ist,
- Persistence-Risiken berücksichtigt wurden,
- das Ergebnis anschließend geprüft wird.

Nicht beiläufig:

- Campaign State ändern
- Unit-State manipulieren
- Routen überschreiben
- Tasks ersetzen
- Save-Dateien verändern
- Framework-State direkt manipulieren

---

## 7. Runtime-Mutation vs. Beobachtung

Bei Tests müssen Beobachtung und Mutation klar getrennt werden.

Beispiele für reine Beobachtung:

    State lesen
    Position lesen
    Geschwindigkeit lesen
    Log lesen
    CTLD-Tabelle inspizieren

Beispiele für bewusste Testmutation:

    Gruppe nativ aktivieren
    temporäre CTLD-Konfiguration ergänzen
    gezielte Testfunktion ausführen

Jede Mutation muss im Testkontext ausdrücklich dokumentiert werden.

---

## 8. Aktueller Persistence-Stand

PersistenceSystem:

    v0.2.6

Bestätigt:

- dirty-aware Background Autosave
- Initial Delay 20 Sekunden
- Intervall 120 Sekunden
- `SAVED`
- `SKIPPED`
- kontrollierter `FAILED`
- Retry
- Read-back
- Compile
- Evaluate
- Validation
- kontrollierter Import

Verbindlich:

    productiveRestore=false

Produktiver Startup-Restore ist noch nicht freigegeben.

---

## 9. Sandbox

Persistence benötigt für den bestätigten Dateisystempfad insbesondere:

    io
    lfs

Die erfolgreichen Persistence-Tests belegen, dass die dafür erforderlichen Voraussetzungen in der getesteten Entwicklungsumgebung vorhanden waren.

Frühere dokumentierte Werte wie:

    os=true
    io=true
    lfs=true
    require=false

werden nicht als dauerhafter aktueller Systemzustand behandelt.

DCS-Updates können:

    MissionScripting.lua

verändern beziehungsweise lokale Anpassungen überschreiben.

Nach relevanten Updates müssen bei Bedarf erneut geprüft werden:

- Persistence-Dateizugriff
- DCS-SMS-Bridge
- Mission-Environment-Zugriff
- tatsächlich benötigte Sandbox-Freigaben

---

## 10. Mission-Record-Diagnose

Der frühere Verdacht:

    10 Mission Records werden erzeugt
    -> später werden alle sechs Status-Dictionaries leer

wurde am:

    2026-09-12

widerlegt.

Die Mission-Collections sind:

    String-keyed Lua-Dictionaries

Deshalb ist:

    #table

für deren Anzahl nicht autoritativ.

Live bestätigt:

    statistics.available = 10
    pairs()-Count = 10
    #available = 0

Die Mission Records waren vorhanden.

Der frühere Befund:

    PROJECT SOURCE HAS NO MATCHING WRITE SITE

ist keine aktuelle offene Fehlerklassifikation mehr.

Der tatsächliche Fehler lag in einer falschen Count-Auswertung in:

    src/core/tc_state.lua

---

## 11. Embedded Resource Audit

Der früher geplante Offline-Audit der eingebetteten Theater-Command-Ressourcen wurde abgeschlossen.

Auditdatum:

    2026-09-12

Ergebnis:

    13/13 relevante aktive Theater-Command-Ressourcen EXACT_MATCH

Damit war im geprüften Stand keine relevante aktive Embedded-Runtime-Drift vorhanden.

Dieser Audit ist nicht mehr der nächste Runtime-Tool-Schritt.

---

## 12. CTLD-Runtime-Test

Am:

    2026-09-29

wurden DCS-SMS und weitere Entwicklungswerkzeuge für einen isolierten CTLD-KI-Truppentransport verwendet.

Für den getesteten Aufbau bestätigt:

    Runtime-Zonenregistrierung
    -> Transporterregistrierung
    -> automatischer Pickup
    -> Taxi
    -> Takeoff
    -> Transit
    -> Off-Airfield-Landung
    -> automatischer Dropoff
    -> reale Blue-Bodengruppe

Luftfahrzeug:

    Mi-8

Pickup:

    16 Soldaten

CTLD:

    1.6.1

---

## 13. CTLD Runtime-Konfiguration

Für den getesteten Runtime-Pfad konnten nach bestehender CTLD-Initialisierung normalisierte Einträge ergänzt werden in:

    ctld.pickupZones
    ctld.dropOffZones

Eine erneute Ausführung von:

    ctld.initialize()

war für diesen getesteten Pfad nicht erforderlich.

Der getestete KI-Transporter musste zusätzlich in:

    ctld.transportPilotNames

registriert sein.

Diese Befunde gelten für den getesteten Aufbau.

Sie sind keine allgemeine Freigabe sämtlicher CTLD-Funktionsbereiche.

---

## 14. CTLD `RepackCommandsPath`

Beim Touchdown des registrierten KI-Transporters wurde genau einmal beobachtet:

    CTLD.lua:6150:
    attempt to get length of local 'RepackCommandsPath' (a nil value)

Kontext:

    updateRepackMenu
    updateRepackMenuOnlanding

Pickup und Dropoff wurden trotzdem erfolgreich abgeschlossen.

Nicht direkt bewiesen:

- dass der Fehler harmlos ist
- dass der betreffende Scheduler weiterlief
- dass der betreffende Scheduler beendet wurde

Ein möglicher Scheduler-Abbruch bleibt:

    source-basierte technische Inferenz

und kein:

    direkter Runtime-Beweis

Vendor-Code wird nicht gepatcht.

---

## 15. Evidenzarten

Runtime Tools müssen zwischen unterschiedlichen Evidenzarten unterscheiden.

### Source-Befund

Beweist:

- vorhandene Logik
- Call-Sites
- Datenpfade

### `.miz`-Audit

Beweist:

- gespeicherte Gruppen
- Units
- Trigger
- Zonen
- Wegpunkte
- Tasks
- Ressourcen

### Runtime-Beobachtung

Beweist:

- tatsächliches DCS-Verhalten
- Unit-Bewegung
- AI-Reaktion
- Pickup
- Takeoff
- Landung
- Dropoff
- tatsächliche Spawns
- Live-State

### Technische Inferenz

Ist eine begründete Schlussfolgerung.

Sie darf nicht als direkter Runtime-Beweis formuliert werden.

---

## 16. Verhältnis zu dcs-mcp

Für strukturierte `.miz`- und Mission-Editor-Arbeit wird aktuell bevorzugt verwendet:

    Claude + dcs-mcp

Version:

    dcs-mcp 0.9.11

Terrain Store:

    C:\Users\Paul\AppData\Local\dcs-mcp\terrain

Syria-Terrain:

    installiert

Rollenverteilung:

    dcs-mcp
    -> gespeicherte Missionsstruktur

    DCS-SMS
    -> lokale Live-Runtime

Die Werkzeuge ergänzen sich.

Sie ersetzen einander nicht vollständig.

---

## 17. Aktueller Entwicklungsbereich

Priority 3 ist abgeschlossen.

Aktueller Projektbereich:

    Priority 4 – produktive CTLD-Integration vorbereiten

Runtime Tools sollen diesen Bereich insbesondere unterstützen bei:

- CTLD-Lifecycle-Diagnose
- Runtime-State-Inspektion
- Result Validation
- Transporter-State
- Pickup-/Dropoff-Nachweis
- Fehleranalyse
- gezielten Regressionen

Runtime Tools definieren dabei nicht selbst die fachliche Kampagnenarchitektur.

---

## 18. Regeln

Runtime Tools müssen:

- Entwicklungswerkzeuge bleiben
- Campaign Logic unter `src/` belassen
- Vendor-Dateien unverändert lassen
- standardmäßig nicht destruktiv arbeiten
- bewusste Mutationen klar dokumentieren
- Runtime und Offline-Audit unterscheiden
- Source-Befund und Runtime-Beweis unterscheiden
- produktiven Save bei riskanten Tests schützen
- keine nicht verifizierten lokalen Pfade als autoritativ dokumentieren
- keine historischen Sandbox-Werte als aktuellen Dauerzustand behandeln

---

## 19. Weitere mögliche Scripts

Mögliche spätere Scripts:

    tc-runtime-report.ps1
    tc-log-report.ps1
    tc-event-monitor.ps1
    tc-airbase-runtime.ps1

Diese Namen sind Planung.

Sie bedeuten nicht, dass die Scripts aktuell implementiert sind.

Neue Scripts werden nur bei konkretem Bedarf angelegt.

---

## 20. Aktueller Abschlussstand

Stand:

    2026-09-29

Implementiert:

    scripts/tc-status.ps1

DCS-SMS:

    0.27.2

Mission-Editor-Hook:

    me-bridge-0.27.2

Verifiziertes Installationsverzeichnis:

    C:\Tools\dcs-sms

Mission-Record-Loss:

    widerlegt

Embedded Resource Audit:

    abgeschlossen

Persistence:

    v0.2.6
    productiveRestore=false

CTLD:

    KI-Truppentransport-PoC für den getesteten Aufbau bestanden

Aktueller Übergang:

    belastbare Runtime-Diagnose
    +
    abgeschlossene Priority-3-Dirty-Coverage
    +
    bestandener CTLD-KI-Truppentransport-PoC
    ->
    kontrollierte produktive CTLD-Integration
