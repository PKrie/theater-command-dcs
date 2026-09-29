# Theater Command SDK

## Verbindlicher Stand — 2026-09-29

Das **Theater Command SDK** ist das projektinterne Entwicklungs- und Diagnosewerkzeug für **Theater Command DCS**.

Es ist ausschließlich:

    Development Tooling

Es ist kein:

    Theater-Command-Runtime-Framework

Kampagnenlogik bleibt unter:

    src/

Vendor-Frameworks bleiben unter:

    vendor/

Das SDK darf die Runtime-Architektur nicht ersetzen.

---

## 1. Zweck

Das SDK unterstützt die Entwicklung von Theater Command DCS bei:

- Mission Inspection
- Mission Validation
- Runtime Diagnostics
- Log Analysis
- Mission Editor Automation
- DCS-SMS-Integration
- Campaign Testing
- Reports
- kontrollierten Entwicklungsoperationen

Es dient dazu, Entwicklungs- und Diagnosearbeit reproduzierbarer zu machen.

---

## 2. Scope

Das SDK wird nur während der Entwicklung verwendet.

Es ist keine Abhängigkeit der fertigen Kampagne.

Es enthält keine:

- Campaign Logic
- Capture Logic
- Logistics Logic
- MissionGenerator-Logik
- AI-Entscheidungslogik
- IADS-Logik
- produktive CTLD-Orchestrierung

Diese Logik bleibt unter:

    src/

---

## 3. Aktuell implementierte Scripts

Aktuell vorhanden:

    scripts/tc-status.ps1
    scripts/tc-mission-report.ps1
    scripts/tc-mission-inspector.ps1

`tc-mission-inspector.ps1` wurde bereits erfolgreich verwendet.

Die vorhandenen Scripts sind Entwicklungshelfer.

Sie sind keine produktiven Runtime-Module.

---

## 4. DCS-SMS

Bestätigte Version:

    DCS-SMS 0.27.2

Bestätigter Mission-Editor-Hook:

    me-bridge-0.27.2

Verifiziertes Installationsverzeichnis:

    C:\Tools\dcs-sms

Aus dem aktuell bestätigten Projektstand wird kein exakter Executable-Pfad wie:

    C:\Tools\dcs-sms\dcs-sms.exe

als autoritativ abgeleitet.

Ein konkreter Executable-Pfad darf erst dokumentiert werden, wenn er separat verifiziert wurde.

---

## 5. Claude Code + DCS-SMS

DCS-SMS wird aktuell vor allem über:

    Claude Code

für lokale DCS- und Mission-Editor-Diagnose verwendet.

Bestätigter Claude-Code-Skill:

    C:\Users\Paul\.claude\skills\dcs-sms\SKILL.md

Aktuelle Einsatzbereiche:

- DCS-Status
- Mission-Editor-Status
- Runtime-Lua
- Mission Environment
- Theater-Command-State
- CTLD-Live-State
- Unit-State
- Group-State
- Position
- Geschwindigkeit
- Grounded-/Airborne-State
- Logauswertung
- Runtime-Regressionen

DCS-SMS bleibt:

    Entwicklungs- und Diagnosewerkzeug

und kein:

    Theater-Command-Framework

---

## 6. Bewährte DCS-SMS-Fähigkeiten

Im Projekt wurden unter anderem erfolgreich verwendet:

- Statusabfragen
- Mission-Environment-Lua
- GUI-/Mission-Execution
- Trigger-Inspektion
- Trigger-Aktionsbearbeitung
- Embedded-Resource-Registrierung
- Embedded-Resource-Read-back
- Mission-Editor-Speicherung
- Log-Lesen
- Runtime-State-Inspektion
- gezielte Regressionstests

Diese Fähigkeiten dürfen nicht automatisch als Beleg dafür verwendet werden, dass jede mögliche DCS-SMS-Funktion im Projekt getestet wurde.

---

## 7. Mission-Editor-Arbeit

Für strukturierte `.miz`- und Mission-Editor-Arbeit wird aktuell bevorzugt verwendet:

    Claude + dcs-mcp

Bestätigte Version:

    dcs-mcp 0.9.11

Terrain Store:

    C:\Users\Paul\AppData\Local\dcs-mcp\terrain

Syria-Terrain:

    installiert

Typische Aufgaben:

- `.miz` lesen
- Gruppen prüfen
- Units prüfen
- Trigger-Zonen prüfen
- Wegpunkte prüfen
- Tasks prüfen
- Ressourcen prüfen
- Mission gezielt ändern
- gespeicherte Mission erneut auditieren

DCS-SMS und dcs-mcp haben damit unterschiedliche Rollen.

---

## 8. Werkzeugtrennung

Aktuelle Rollen:

    ChatGPT
    -> Projektkoordination
    -> Architektur
    -> GitHub-Audit
    -> Testplanung
    -> Ergebnisbewertung
    -> Dokumentation

    Claude + dcs-mcp
    -> .miz
    -> Mission Editor
    -> gespeicherte Missionsstruktur

    Claude Code + DCS-SMS
    -> lokale DCS-Runtime
    -> Runtime-Lua
    -> Live-State
    -> Logs
    -> Regressionen

    DCS
    -> autoritativer Runtime-Verhaltensbeweis

    GitHub
    -> Source of Truth

Diese Rollen sollen nicht unnötig vermischt werden.

---

## 9. Sandbox

Persistence benötigt für den bestätigten Dateisystempfad insbesondere:

    io
    lfs

Die erfolgreichen Persistence-Tests bestätigen, dass die dafür notwendigen Voraussetzungen in der getesteten Entwicklungsumgebung verfügbar waren.

Konkrete Werte wie:

    os=true
    io=true
    lfs=true
    require=false

werden nicht mehr als dauerhafter aktueller Systemzustand festgeschrieben.

Historische Sandbox-Befunde dürfen nicht ungeprüft als aktuelle lokale DCS-Konfiguration behandelt werden.

DCS-Updates können:

    MissionScripting.lua

verändern beziehungsweise lokale Anpassungen überschreiben.

Nach relevanten DCS-Updates müssen bei Bedarf erneut geprüft werden:

- Persistence-Dateizugriff
- DCS-SMS-Bridge
- Mission-Environment-Zugriff
- tatsächlich benötigte Sandbox-Freigaben

---

## 10. Embedded Resource Audit

Der früher als nächster SDK-Schritt geplante Offline-Audit der eingebetteten Theater-Command-Ressourcen wurde inzwischen durchgeführt.

Auditdatum:

    2026-09-12

Ergebnis:

    13/13 relevante aktive Theater-Command-Ressourcen EXACT_MATCH

Bestätigt:

- keine relevante aktive Embedded-Runtime-Drift
- keine fehlende aktive Theater-Command-Ressource
- Trigger-/Ressourcenpfad im geprüften Stand konsistent

Der Embedded Resource Audit ist damit:

    abgeschlossen

Er ist nicht mehr der nächste SDK-Arbeitsschritt.

---

## 11. Historische verwaiste Ressource

Beim Embedded Resource Audit wurde eine historische verwaiste Persistence-Ressource dokumentiert:

    ResKey_Action_55
    tc_persistence_system.lua

Status:

- nicht aktiv referenziert
- nicht geladen
- kein aktueller Runtime-Blocker

Sie bleibt ein späterer Cleanup-Punkt.

---

## 12. Runtime-Evidenz

Das SDK dient zur Sammlung technischer Evidenz.

Dabei müssen verschiedene Evidenzarten unterschieden werden.

### Source-Befund

Beweist:

- vorhandene Logik
- Call-Sites
- Datenpfade

### `.miz`-Audit

Beweist:

- gespeicherte Missionsstruktur
- Gruppen
- Zonen
- Tasks
- Trigger
- Embedded Resources

### Runtime-Beobachtung

Beweist:

- tatsächliches DCS-Verhalten
- AI-Verhalten
- State-Verhalten
- CTLD-Verhalten
- tatsächliche Spawns

### Technische Inferenz

Ist eine begründete Schlussfolgerung.

Sie ist kein direkter Runtime-Beweis.

---

## 13. CTLD-Testunterstützung

Das Tooling wurde am 2026-09-29 erfolgreich für den isolierten CTLD-KI-Truppentransport-PoC verwendet.

Bestätigter getesteter Pfad:

    Runtime-Zonenregistrierung
    -> KI-Transporterregistrierung
    -> automatischer Pickup
    -> Flug
    -> Off-Airfield-Landung
    -> automatischer Dropoff
    -> reale Blue-Bodengruppe

Luftfahrzeug:

    Mi-8

CTLD:

    1.6.1

Dieser PoC gilt:

    für den getesteten Aufbau

Er ist keine allgemeine Freigabe aller CTLD-Funktionen.

---

## 14. Aktueller Projektbereich

Priority 3 ist abgeschlossen.

Aktueller Entwicklungsbereich:

    Priority 4 – produktive CTLD-Integration vorbereiten

Der nächste Tooling-Einsatz soll diesen Projektbereich unterstützen.

Typische Aufgaben können sein:

- Source-Audit
- CTLD-Lifecycle-Diagnose
- Runtime-State-Inspektion
- Result Validation
- gezielte Regressionen
- Mission-Editor-Audit

Das SDK definiert nicht selbst die Kampagnenarchitektur.

---

## 15. Geplante Tooling-Bereiche

Mögliche langfristige Kategorien:

    inspect
    validate
    runtime
    logs
    mission-editor
    testing
    export
    reports
    utilities

Diese Namen sind Planungsbereiche.

Sie sind keine Behauptung, dass für jeden Bereich bereits ein fertiges Modul existiert.

Neue Tools werden nur bei konkretem Bedarf angelegt.

---

## 16. Sicherheitsregeln

Für SDK- und Entwicklungswerkzeuge gilt:

- keine Vendor-Dateien verändern
- keine produktive Campaign Logic in `tools/` verschieben
- keine verdeckten Mission-Änderungen
- vor `.miz`-Änderungen aktuellen Missionsstand lesen
- nach `.miz`-Änderungen gespeicherte Mission erneut prüfen
- Runtime-Tests von Offline-Audits unterscheiden
- produktiven Save bei riskanten Tests schützen
- keine nicht verifizierten lokalen Pfade als autoritativ dokumentieren
- keine historischen Sandbox-Werte als dauerhafte aktuelle Konfiguration behandeln

---

## 17. Status

SDK-Version:

    0.1

Implementiert:

    tc-status.ps1
    tc-mission-report.ps1
    tc-mission-inspector.ps1

Bewährte Tooling-Kombination:

    ChatGPT
    +
    Claude + dcs-mcp
    +
    Claude Code + DCS-SMS
    +
    DCS
    +
    GitHub

Aktueller Projektübergang:

    stabiler state-first Kampagnenkern
    +
    abgeschlossene Priority-3-Dirty-Coverage
    +
    bestandener CTLD-KI-Truppentransport-PoC
    ->
    kontrollierte produktive CTLD-Integration
