# UI

Dieser Ordner enthält die Spielerinteraktion von **Theater Command DCS**.

`src/ui/` verbindet später den Kampagnenzustand mit sichtbaren und bedienbaren Elementen im Spiel.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut. Blau startet auf **Zypern / Akrotiri**. Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Zweck von `src/ui/`

`src/ui/` ist für Spielerinteraktion, Statusanzeigen und spätere F10-Menüs zuständig.

Geplante Aufgaben:

- F10-Menüs vorbereiten
- Kampagnenstatus anzeigen
- verfügbare Missionen anzeigen
- aktive Missionen anzeigen
- Logistikstatus anzeigen
- FOB-Status anzeigen
- AI- und CAP-Status anzeigen
- IADS-Status anzeigen
- einfache Spielerkommandos vorbereiten
- Debug-Menüs später optional anbinden

Der UI-Bereich entscheidet nicht selbst über Kampagnenlogik.

Er zeigt Daten an und nimmt Spieleraktionen entgegen.

Die eigentliche Fachlogik bleibt in den jeweiligen Systemordnern.

---

## Architekturregel

Externe Frameworks liegen unter:

    vendor/

Eigene Theater-Command-Logik liegt unter:

    src/

Der UI-Bereich gehört zur eigenen Theater-Command-Logik.

Frameworks werden nicht verändert.

Die Dateien in `src/ui/` werden nach Aufgaben benannt, nicht nach Frameworks.

Nicht gewünscht:

    src/ui/tc_moose_menu.lua
    src/ui/tc_mist_menu.lua
    src/ui/tc_ui_all_in_one.lua
    src/ui/tc_f10_everything.lua

Spätere mögliche Dateien:

    src/ui/tc_f10_menu.lua
    src/ui/tc_status_display.lua
    src/ui/tc_mission_menu.lua
    src/ui/tc_logistics_menu.lua
    src/ui/tc_debug_menu.lua

Diese Dateien werden erst angelegt, wenn sie wirklich benötigt werden.

---

## Geplante Dateien

Für `src/ui/` ist zunächst nur diese Dokumentationsdatei geplant:

    src/ui/README.md

Spätere mögliche Implementierungsdateien:

    src/ui/tc_f10_menu.lua
    src/ui/tc_status_display.lua
    src/ui/tc_mission_menu.lua
    src/ui/tc_logistics_menu.lua
    src/ui/tc_debug_menu.lua

Die konkrete Lua-Implementierung wird später separat begonnen.

---

## Beziehung zum Core

`src/ui/` nutzt den Core.

Erlaubte Core-Abhängigkeiten:

    TC.Config
    TC.Logger
    TC.State
    TC.Utils
    TC.Scheduler

Der UI-Bereich darf davon ausgehen, dass der Core bereits geladen ist.

Die interne Lade-Reihenfolge sieht vor:

    1. Core
    2. World
    3. Campaign
    4. Logistics
    5. Missions
    6. AI
    7. IADS
    8. UI
    9. Debug
    10. Main

UI-Dateien dürfen deshalb auf Core-Funktionen zugreifen.

---

## Beziehung zum World-Bereich

Der UI-Bereich nutzt Daten aus:

    src/world/

Besonders wichtig sind:

    TC.World.AirbaseScanner
    TC.World.ZoneFactory
    TC.State.Bases
    TC.State.Zones

World liefert die Karten- und Raumdaten.

UI kann diese Daten später anzeigen.

Beispiele:

    Anzahl blauer Basen
    Anzahl roter Basen
    Anzahl kontrollierter Zonen
    Startbasis Akrotiri
    Zonenstatus
    Kartenbereich

UI soll nicht selbst Airbases scannen.

UI soll nicht selbst Kampagnenzonen erzeugen.

---

## Beziehung zum Campaign-Bereich

Der UI-Bereich nutzt Daten aus:

    src/campaign/

Besonders wichtig sind:

    TC.Campaign.CaptureSystem
    TC.Campaign.PersistenceSystem
    TC.State.Campaign
    TC.State.Bases
    TC.State.Zones
    TC.State.Persistence

Campaign liefert den strategischen Zustand.

UI zeigt diesen Zustand später für den Spieler an.

Beispiele:

    Kampagnenname
    aktuelle Phase
    kontrollierte Basen
    kontrollierte Zonen
    contested Zonen
    Save-/Load-Status
    Persistenzstatus

Besitzwechsel bleiben Aufgabe des Capture-Systems.

---

## Beziehung zum Logistics-Bereich

Der UI-Bereich nutzt Daten aus:

    src/logistics/

Besonders wichtig sind:

    TC.Logistics.Delivery
    TC.Logistics.FobSystem
    TC.State.Logistics

Logistics liefert den Versorgungszustand.

UI kann diese Daten später anzeigen.

Beispiele:

    verfügbare Lieferungen
    aktive Lieferungen
    abgeschlossene Lieferungen
    FOBs im Aufbau
    aktive FOBs
    FOBs ohne Versorgung
    Logistikhubs

UI soll keine CTLD-Logik ausführen.

UI zeigt Logistikdaten an oder löst definierte Logistikaktionen aus.

---

## Beziehung zum Missionsbereich

Der UI-Bereich nutzt Daten aus:

    src/missions/

Besonders wichtig sind:

    TC.Missions.Generator
    TC.State.Missions

Missions liefert verfügbare und aktive Aufträge.

UI kann diese Daten später über F10-Menüs verfügbar machen.

Beispiele:

    verfügbare Missionen anzeigen
    aktive Missionen anzeigen
    Mission aktivieren
    Missionsstatus abfragen
    Missionsdetails anzeigen
    Missionsabschluss später debuggen oder testen

Die Missionserzeugung bleibt Aufgabe des Missionsgenerators.

---

## Beziehung zum AI-Bereich

Der UI-Bereich nutzt Daten aus:

    src/ai/

Besonders wichtig sind:

    TC.AI.CapManager
    TC.State.AI

AI liefert Reaktions- und CAP-Zustände.

UI kann diese Daten später anzeigen.

Beispiele:

    aktive CAPs
    angeforderte CAPs
    Bedrohungsniveau
    Reaktionsstatus
    Eskalationslevel
    CAP-Zonen

AI-Entscheidungen bleiben Aufgabe des AI-Bereichs.

---

## Beziehung zum IADS-Bereich

Der UI-Bereich nutzt später Daten aus:

    src/iads/

Besonders wichtig sind:

    TC.State.IADS
    TC.IADS

IADS liefert Luftverteidigungszustände.

UI kann diese Daten später anzeigen.

Beispiele:

    aktive IADS-Sektoren
    beschädigte IADS-Sites
    zerstörte SAM-Stellungen
    SEAD-relevante Ziele
    DEAD-relevante Ziele
    Bedrohungsstatus

Die IADS-Logik bleibt Aufgabe des IADS-Bereichs.

---

## Geplanter Namespace

Der UI-Bereich wird später unter der zentralen Projekttabelle `TC` abgelegt.

Geplante Struktur:

    TC.UI
    ├── F10Menu
    ├── StatusDisplay
    ├── MissionMenu
    ├── LogisticsMenu
    └── DebugMenu

Die globale Projekttabelle bleibt:

    TC

Nicht verwenden:

    TheaterCommandUI
    UiTC
    tc_ui_global
    _G_TC_UI

---

## Geplante State-Bereiche

Der UI-Bereich arbeitet später vor allem mit:

    TC.State.UI
    TC.State.Campaign
    TC.State.Bases
    TC.State.Zones
    TC.State.Logistics
    TC.State.Missions
    TC.State.AI
    TC.State.IADS
    TC.State.Debug

Geplante Daten in `TC.State.UI`:

    enabled
    f10Enabled
    statusDisplayEnabled
    lastUpdate
    menuRootCreated
    menuItems
    playerCommands
    lastMessage

Der genaue Datenaufbau wird mit späteren Lua-Dateien festgelegt.

---

## Anfangszustand der Kampagne

Für **Operation Levant Reclamation** gilt als Grundannahme:

    Blau startet auf Zypern / Akrotiri.
    Das syrische Festland ist zu Beginn rot kontrolliert.

Daraus folgt für den UI-Bereich:

- Akrotiri soll später als blaue Startbasis angezeigt werden können.
- rote Festlandzonen sollen später als feindlich angezeigt werden können.
- verfügbare Missionen sollen aus dem Missionsgenerator kommen.
- Logistikstatus soll aus dem Logistics-Bereich kommen.
- AI- und IADS-Zustand sollen später optional angezeigt werden.
- Debug-Funktionen sollen klar von normalen Spielerfunktionen getrennt bleiben.

Die konkrete F10-Menüstruktur wird später einzeln implementiert.

---

## UI-Grundidee

Die UI soll den Spieler nicht mit Rohdaten überladen.

Sie soll den Kampagnenzustand verständlich machen.

Beispiele:

    Welche Missionen sind verfügbar?
    Welche Mission ist aktiv?
    Welche Zone ist bedroht?
    Welche Basis gehört wem?
    Wo wird Nachschub benötigt?
    Welche FOBs sind aktiv?
    Wie stark ist die feindliche Luftreaktion?
    Gibt es relevante IADS-Ziele?

Die erste Version darf einfach sein.

Wichtig ist, dass UI nicht zur All-in-one-Schaltzentrale für Fachlogik wird.

---

## Abgrenzung

Nicht Aufgabe von `src/ui/`:

    Airbases aus DCS auslesen
    Zonen geometrisch erzeugen
    Basenbesitz direkt festlegen
    Zonenbesitz direkt festlegen
    CTLD-Lieferungen direkt auswerten
    FOBs direkt bauen
    Missionen selbst generieren
    CAPs dauerhaft verwalten
    IADS-Netzwerke aufbauen
    Framework-Dateien verändern

Diese Aufgaben gehören in andere Bereiche.

UI zeigt an, bündelt Spielerinteraktion und ruft definierte Funktionen anderer Systeme auf.

---

## Verbindung zu späteren Systemen

Spätere Systeme liefern Daten an UI oder werden über UI ausgelöst.

Beispiele:

    Missions liefert verfügbare Missionen.
    Logistics liefert Liefer- und FOB-Status.
    Campaign liefert Kampagnenfortschritt.
    AI liefert Reaktionsstatus.
    IADS liefert Luftverteidigungsstatus.
    Debug liefert Testfunktionen.
    Persistence liefert Save-/Load-Status.

Der UI-Bereich ist damit die Bedien- und Anzeigeschicht von Theater Command DCS.

---

## Testziele

Der UI-Bereich gilt später als funktionsfähig, wenn folgende Punkte erfüllt sind:

    TC.UI ist vorhanden.
    TC.State.UI wird korrekt vorbereitet.
    F10-Menü kann erzeugt werden.
    Kampagnenstatus kann angezeigt werden.
    Missionsliste kann angezeigt werden.
    Logistikstatus kann angezeigt werden.
    Spielerkommandos können definierte Systemfunktionen auslösen.
    Debug-Funktionen bleiben getrennt.
    keine Lua-Fehler beim Missionsstart.
    keine Framework-Dateien werden verändert.

Erwartete spätere Beispielausgaben in `dcs.log`:

    [TC] UI loading started
    [TC] F10 menu loaded
    [TC] UI initialized
    [TC] Campaign status menu created
    [TC] Mission menu created
    [TC] Logistics menu created

---

## Entwicklungsregel

Der UI-Bereich wird schrittweise aufgebaut.

Empfohlene Reihenfolge:

    1. src/ui/README.md
    2. spätere konkrete UI-Implementierungsdatei nach Bedarf

Jede Datei wird einzeln erstellt und geprüft.

Keine parallelen Großbaustellen.

Keine All-in-one-Dateien.

---

## Zielbild

`src/ui/` soll Theater Command DCS für Spieler bedienbar und verständlich machen.

Der UI-Bereich ist die Verbindung zwischen:

    Kampagnenzustand
    Missionen
    Logistik
    AI-Reaktion
    IADS-Zustand
    Spielerkommandos
    Debugfunktionen

Damit bleibt das Projekt:

    modular
    lesbar
    testbar
    erweiterbar
    wartbar

`src/ui/` ist die Bedien- und Anzeigeschicht von **Theater Command DCS**.
