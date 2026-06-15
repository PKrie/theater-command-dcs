# AI Director

Diese Datei beschreibt den geplanten **AI Director** von **Theater Command DCS**.

Der AI Director soll später dafür sorgen, dass die Kampagne dynamisch auf Spieleraktionen, Kampagnenfortschritt, IADS-Schäden, Capture-Ereignisse und Logistikfortschritt reagiert.

Die erste Kampagne trägt den Arbeitstitel:

**Operation Levant Reclamation**

Die Kampagne wird auf der **Syria Map** aufgebaut.

Blau startet auf **Zypern / Akrotiri**.

Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Grundprinzip

Der AI Director folgt dem Projektprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Mission Editor stellt nur Templates, Gruppen und Startbedingungen bereit.

Die dynamische KI-Logik entsteht später durch Lua.

Der AI Director soll nicht als große Triggerkette im Mission Editor gebaut werden.

---

## Ziel des AI Directors

Der AI Director soll später die Welt reaktiver machen.

Er soll nicht einfach zufällig Einheiten spawnen.

Er soll aus dem Kampagnenzustand sinnvolle Reaktionen ableiten.

Mögliche Reaktionen:

- rote CAP erzeugen
- rote GCI erzeugen
- Gegenangriffe vorbereiten
- Verstärkung gefährdeter Basen
- Reaktion auf Capture-Ereignisse
- Reaktion auf IADS-Schäden
- Reaktion auf Logistikfortschritt
- Eskalation bei blauen Erfolgen
- Schutz strategischer Ziele
- Druck auf blaue FOBs ausüben

Der AI Director soll die Kampagne lebendig machen, ohne unkontrollierbar zu werden.

---

## Aktueller Projektstand

Stand:

    2026-06-15

Aktuell vorhanden:

- zentrale Projektdokumentation
- `docs/`-Grundblock
- `vendor/`-Frameworks
- `src/README.md`

Aktuell hinterlegte Frameworks:

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Noch nicht vorhanden:

- `src/ai/tc_ai_director.lua`
- `src/ai/tc_ai_cap_manager.lua`
- `src/ai/tc_ai_gci_manager.lua`
- `src/ai/tc_ai_counterattack.lua`
- eigene KI-Kampagnenlogik
- eigene Spawnlogik
- eigene Eskalationslogik
- eigene Ressourcenlogik

---

## Geplante eigene Dateien

Die AI-Logik gehört später nach:

    src/ai/

Geplante Dateien:

    src/ai/tc_ai_director.lua
    src/ai/tc_ai_cap_manager.lua
    src/ai/tc_ai_gci_manager.lua
    src/ai/tc_ai_strike_manager.lua
    src/ai/tc_ai_cas_manager.lua
    src/ai/tc_ai_ground_war.lua
    src/ai/tc_ai_counterattack.lua
    src/ai/tc_ai_escalation.lua
    src/ai/tc_ai_resource_manager.lua

Zusätzliche spätere Debug-Datei:

    src/debug/tc_debug_ai.lua

---

## Nicht gewünschte Dateien

Nicht gewünscht:

    src/tc_moose_ai.lua
    src/tc_ai_all_in_one.lua
    src/tc_moose.lua
    src/tc_all_in_one.lua

Die eigene Struktur wird nach Aufgaben sortiert.

Sie wird nicht nach Frameworks sortiert.

Eine Datei darf MOOSE, MIST, CTLD oder Skynet IADS intern nutzen.

Der Dateiname richtet sich aber immer nach der Aufgabe, nicht nach dem Framework.

---

## Rolle von MOOSE

MOOSE kann später für KI-Management genutzt werden.

Mögliche Nutzung:

- Spawning
- Scheduler
- Airbase-Wrapper
- Gruppenverwaltung
- CAP-Logik
- GCI-Logik
- AI-Aufgaben
- Zonenlogik
- Erkennung und Reaktion
- Debug-Ausgaben

MOOSE ist aber nicht der AI Director.

MOOSE stellt technische Funktionen bereit.

Theater Command DCS entscheidet, wann, wo und warum KI-Aktionen ausgelöst werden.

---

## Rolle von MIST

MIST kann später Hilfsfunktionen bereitstellen.

Mögliche Nutzung:

- Gruppeninformationen
- Positionsdaten
- Tabellenfunktionen
- Event-Hilfen
- Koordinatenlogik
- Debug- und Testhilfen

MIST ist eine Utility-Schicht.

Die AI-Entscheidungslogik gehört nach:

    src/ai/

---

## Rolle von Skynet IADS

Skynet IADS steuert taktisches Luftverteidigungsverhalten.

Der AI Director kann später auf IADS-Zustände reagieren.

Beispiele:

- Wenn ein IADS-Sektor beschädigt ist, kann Rot CAP verstärken.
- Wenn eine Radarstellung zerstört wurde, kann Rot mobile SAMs verlegen.
- Wenn Blau wiederholt SEAD fliegt, kann Rot GCI aggressiver einsetzen.
- Wenn eine Küstenluftverteidigung zusammenbricht, kann Rot wichtige Basen stärker schützen.

Skynet IADS trifft taktische Entscheidungen für SAM- und Radarverhalten.

Der AI Director trifft kampagnenlogische Reaktionsentscheidungen.

---

## Rolle von CTLD und Logistik

Der AI Director soll später auf Logistikfortschritt reagieren können.

Beispiele:

- Blau baut einen FOB auf.
- Blau liefert Versorgung an eine Küstenzone.
- Blau stabilisiert eine eroberte Basis.
- Blau öffnet einen neuen Logistikhub.

Mögliche rote Reaktionen:

- Gegenangriff auf FOB
- CAP über Logistikroute
- Angriff auf Dropoff-Zone
- Verlegung von Bodentruppen
- Verstärkung naher roter Basen
- Artillerie- oder Raketenangriff auf Logistikknoten

CTLD führt die technische Logistik aus.

Theater Command DCS bewertet die Wirkung.

Der AI Director reagiert auf diese Wirkung.

---

## AI Director als Entscheidungsschicht

Der AI Director soll später eine Entscheidungsschicht sein.

Er soll verschiedene Zustände auswerten:

- Kampagnenphase
- Basenbesitz
- Zonenstatus
- IADS-Zustand
- Logistikstatus
- aktive Missionen
- abgeschlossene Missionen
- rote Ressourcen
- blaue Fortschritte
- aktuelle Bedrohungslage

Daraus sollen Reaktionen entstehen.

Der AI Director soll nicht jedes Detail selbst ausführen.

Er soll spezialisierte Manager anstoßen.

Beispiel:

    AI Director erkennt:
    Küsten-IADS beschädigt
        ↓
    CAP Manager verstärkt rote CAP
        ↓
    GCI Manager erhöht Alarmbereitschaft
        ↓
    Counterattack Manager plant Bodenreaktion

---

## Geplantes Datenmodell

Ein AI-Director-Zustand könnte später so aussehen:

    aiState = {
      enabled = true,
      threatLevel = "MEDIUM",
      escalationLevel = 2,
      redResources = 100,
      blueProgress = 25,
      activeResponses = {},
      lastReactionTime = 0
    }

Diese Struktur ist konzeptionell.

Die konkrete Umsetzung erfolgt später in Lua.

---

## Eskalationslevel

Der AI Director kann später mit Eskalationsleveln arbeiten.

Mögliche Level:

    0 = keine aktive Reaktion
    1 = leichte Reaktion
    2 = normale Reaktion
    3 = verstärkte Reaktion
    4 = schwere Reaktion
    5 = maximale Reaktion

Beispiel:

Level 1:

- einzelne CAP
- leichte GCI-Bereitschaft

Level 3:

- stärkere CAP
- Gegenangriff auf FOB
- SAM-Verlegung optional

Level 5:

- massive rote Reaktion
- Gegenoffensive
- Verteidigung strategischer Basen
- hohe Luftbedrohung

Die Eskalation soll kontrolliert bleiben.

Sie darf die Mission nicht unspielbar machen.

---

## Ressourcenmodell

Der AI Director soll später nicht unbegrenzt Einheiten erzeugen.

Ein einfaches Ressourcenmodell kann verhindern, dass Rot endlos spawnt.

Mögliche Ressourcen:

- rote Luftressourcen
- rote Bodentruppen
- rote Logistik
- rote IADS-Reparaturfähigkeit
- verfügbare CAP-Pakete
- verfügbare GCI-Pakete
- verfügbare Gegenangriffe

Geplante Datei:

    src/ai/tc_ai_resource_manager.lua

Ressourcenmodell wird erst später umgesetzt.

Zu Beginn reicht eine einfache kontrollierte KI-Reaktion.

---

## CAP Manager

Der CAP Manager soll später Combat Air Patrols steuern.

Geplante Datei:

    src/ai/tc_ai_cap_manager.lua

Mögliche Aufgaben:

- rote CAP über wichtigen Regionen erzeugen
- blaue CAP optional erzeugen
- CAP nach Kampagnenphase steuern
- CAP abhängig von Airbase-Besitz erzeugen
- CAP abhängig von IADS-Zustand verstärken
- CAP abhängig von Spielerfortschritt anpassen

Mögliche CAP-Regionen:

- syrische Küste
- Khmeimim
- Latakia
- Tartus
- Inland-Korridore
- Nähe aktiver FOBs

MOOSE kann für technische CAP-Funktionen genutzt werden.

Theater Command DCS entscheidet über Zweck und Priorität.

---

## GCI Manager

Der GCI Manager soll später Ground Controlled Intercept steuern.

Geplante Datei:

    src/ai/tc_ai_gci_manager.lua

Mögliche Aufgaben:

- rote Abfangjäger starten
- GCI nach Bedrohung auslösen
- GCI abhängig von Airbase-Zustand steuern
- GCI abhängig von IADS-Erkennung steuern
- GCI abhängig von Eskalationslevel steuern
- GCI nicht unbegrenzt spawnen

Beispiele:

- Blau greift Latakia an.
- Rote Radarstellung erkennt Paket.
- GCI wird von nächster aktiver roter Airbase ausgelöst.
- Falls diese Airbase zerstört oder erobert ist, wird keine GCI von dort erzeugt.

---

## Strike Manager

Der Strike Manager kann später KI-Angriffe koordinieren.

Geplante Datei:

    src/ai/tc_ai_strike_manager.lua

Mögliche Aufgaben:

- rote Angriffe auf FOBs
- rote Angriffe auf Logistikhubs
- rote Angriffe auf blaue Schiffe optional
- rote Angriffe auf eroberte Basen
- blaue AI-Unterstützung optional

Dieser Manager kommt erst später.

Zu Beginn sind CAP/GCI wichtiger.

---

## Ground War

Ein späteres Bodenkampfsystem kann einfache Bodenreaktionen erzeugen.

Geplante Datei:

    src/ai/tc_ai_ground_war.lua

Mögliche Aufgaben:

- Konvois erzeugen
- rote Gegenangriffe bewegen
- Garnisonen verstärken
- Frontdruck simulieren
- Capture-Zonen bedrohen
- FOBs angreifen

Dieses System soll nicht zu früh gebaut werden.

Es hängt von Airbase-, Zonen-, Capture- und Logistiksystem ab.

---

## Counterattack Manager

Der Counterattack Manager soll gezielte Gegenangriffe auslösen.

Geplante Datei:

    src/ai/tc_ai_counterattack.lua

Mögliche Auslöser:

- Blau erobert eine Zone.
- Blau baut einen FOB.
- Blau zerstört eine wichtige IADS-Komponente.
- Blau bedroht eine rote Airbase.
- Blau stabilisiert einen Küsten-Brückenkopf.

Mögliche Reaktionen:

- rote Bodentruppen bewegen sich zur Zone
- rote CAP schützt Gegenangriff
- rote GCI wird aggressiver
- rote Artillerie oder Raketenangriffe optional
- neues Missionsziel für Spieler entsteht

---

## Verbindung zum Airbase-System

Der AI Director benötigt Airbase-Daten.

Geplante Verbindung:

    src/world/
        ↓
    src/ai/

Mögliche Nutzung:

- rote Airbases als Startpunkte für CAP/GCI
- blaue Airbases als Schutzobjekte
- umkämpfte Airbases als Reaktionsauslöser
- eroberte Airbases als neue Bedrohung für Rot
- verlorene Airbases als Ressourcennachteil

Ohne Airbase-System kann der AI Director keine sinnvollen strategischen Entscheidungen treffen.

---

## Verbindung zum Capture-System

Capture-Ereignisse sind wichtige Auslöser für KI-Reaktionen.

Geplante Verbindung:

    src/campaign/
        ↓
    src/ai/

Mögliche Auslöser:

- Zone erobert
- Zone verloren
- Basis erobert
- Basis bedroht
- FOB aktiv
- Capture-Fortschritt hoch
- rote Garnison geschwächt

Der AI Director soll auf solche Ereignisse reagieren.

---

## Verbindung zum Logistiksystem

Logistikfortschritt soll KI-Reaktionen auslösen können.

Geplante Verbindung:

    src/logistics/
        ↓
    src/ai/

Mögliche Auslöser:

- FOB aufgebaut
- Logistikhub aktiviert
- wichtige Lieferung abgeschlossen
- Dropoff-Zone versorgt
- blaue Versorgungslinie stabil
- rote Logistik geschwächt

Mögliche Reaktionen:

- Angriff auf FOB
- Angriff auf Logistikroute
- CAP über Route
- Gegenangriff auf Dropoff-Zone
- Verstärkung roter Depots

---

## Verbindung zum IADS-System

IADS-Schäden sollen KI-Reaktionen beeinflussen.

Geplante Verbindung:

    src/iads/
        ↓
    src/ai/

Mögliche Auslöser:

- Radar zerstört
- SAM-Stellung zerstört
- IADS-Sektor beschädigt
- IADS-Sektor deaktiviert
- Küsten-IADS geschwächt
- Luftverteidigungslücke entstanden

Mögliche Reaktionen:

- rote CAP verstärken
- GCI aggressiver einsetzen
- mobile SAMs verlegen
- wichtige Ziele stärker schützen
- Gegenangriff gegen SEAD-Basis vorbereiten

---

## Verbindung zum Missionsgenerator

Der AI Director kann neue Missionslagen erzeugen.

Geplante Verbindung:

    src/ai/
        ↓
    src/missions/

Mögliche Beispiele:

- roter Gegenangriff erzeugt CAS-Mission
- rote CAP erzeugt Air-Superiority-Mission
- bedrohte FOB-Zone erzeugt Defense-Mission
- rote Verstärkung erzeugt Interdiction-Mission
- mobile SAM-Verlegung erzeugt Recon- oder SEAD-Mission

Der Missionsgenerator soll diese Lage aufnehmen und Spielern anbieten.

---

## Verbindung zur Persistenz

AI-Zustand kann später teilweise persistent werden.

Mögliche persistente Werte:

- Eskalationslevel
- rote Ressourcen
- aktive Gegenangriffe
- letzte KI-Reaktionen
- beschädigte KI-Strukturen
- laufende Operationen
- blockierte Reaktionen
- Kampagnenphase

Persistenz wird aber erst gebaut, wenn klar ist, welche AI-Daten stabil gespeichert werden müssen.

---

## KI und Balancing

Der AI Director muss balanciert sein.

Er darf nicht:

- unendlich Einheiten erzeugen
- Spieler permanent überfordern
- Missionen unspielbar machen
- Server-Performance zerstören
- unrealistische Spawns direkt vor Spielern erzeugen
- Erfolge der Spieler bedeutungslos machen

Er soll:

- nachvollziehbar reagieren
- Ressourcen berücksichtigen
- Kampagnenfortschritt respektieren
- Bedrohung erzeugen
- Erfolge und Fehler spürbar machen
- dynamische Missionen ermöglichen

---

## Erste technische Minimalversion

Die erste Version des AI Directors soll klein sein.

Mögliches erstes Ziel:

- AI Director startet ohne Fehler.
- Debug-Ausgabe erscheint im `dcs.log`.
- einfacher Status wird gesetzt.
- keine echten Spawns.
- keine komplexen Reaktionen.
- nur Grundstruktur und Debug.

Beispielausgabe:

    [TC][DEBUG] AI Director initialized
    [TC][DEBUG] AI Director state: enabled
    [TC][DEBUG] AI Director escalation level: 0

Erst danach folgen CAP/GCI-Manager.

---

## Debug für AI Director

Ein Debugsystem soll später helfen, KI-Entscheidungen sichtbar zu machen.

Geplante Datei:

    src/debug/tc_debug_ai.lua

Mögliche Debug-Ausgaben:

- aktuelles Eskalationslevel
- aktive Reaktionen
- rote Ressourcen
- geplante CAP
- geplante GCI
- aktive Gegenangriffe
- blockierte Reaktionen
- Gründe für Entscheidungen

Beispiel:

    [TC][DEBUG] AI Director escalation increased to 2
    [TC][DEBUG] Red CAP requested over Latakia
    [TC][DEBUG] Counterattack blocked: insufficient red resources

---

## Testziele

Wenn der AI Director später erstmals eingebunden wird, sollen folgende Punkte getestet werden:

- Mission startet ohne Lua-Fehler
- Frameworks laden korrekt
- `src/loader.lua` startet
- `src/main.lua` startet
- AI Director wird geladen
- AI Director gibt Debug-Status aus
- keine nil-Fehler bei fehlenden Kampagnendaten
- Eskalationslevel wird korrekt initialisiert
- AI Director bleibt ohne aktive Systeme passiv
- keine unkontrollierten Spawns
- `dcs.log` enthält nachvollziehbare Meldungen

---

## Nicht jetzt umsetzen

Aktuell noch nicht bauen:

- vollständige CAP/GCI-Automation
- komplexer AI Director
- vollständiges Ressourcenmodell
- komplette rote Gegenoffensive
- automatische mobile SAM-Verlegung
- dynamischer Bodenkampf
- persistente AI-Kampagnenlogik
- komplexe Eskalationsmechanik

Diese Dinge werden später schrittweise aufgebaut.

---

## Erste Entwicklungsreihenfolge

Der AI Director wird erst nach mehreren Grundsystemen sinnvoll.

Vorher müssen entstehen:

1. `src/`-Unterordner
2. Core-System
3. Airbase-System
4. Zonen-System
5. Capture-System
6. Missionsgenerator-Grundlage
7. Logistikgrundlage
8. IADS-Grundlage

Erst dann kann der AI Director sinnvoll aus dem Kampagnenzustand reagieren.

---

## Aktueller Status

Aktuell ist der AI Director nur dokumentiert.

Die eigene Lua-Implementierung ist noch nicht begonnen.

Aktueller Stand:

    AI Director geplant
    CAP Manager noch nicht implementiert
    GCI Manager noch nicht implementiert
    Counterattack Manager noch nicht implementiert
    AI-Ressourcenmodell noch nicht implementiert

Nächster technischer Fokus nach Abschluss der Dokumentationsaktualisierung:

    src-Unterordner und README-Dateien erstellen

Danach:

    src/loader.lua
    src/main.lua
    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
