# Project Overview

Diese Datei gibt eine Gesamtübersicht über das Projekt **Theater Command DCS**.

Theater Command DCS ist ein modulares, dynamisches und später persistentes DCS-World-Kampagnensystem.

Die erste Kampagne trägt den Arbeitstitel:

**Operation Levant Reclamation**

Die Kampagne wird auf der **Syria Map** aufgebaut.

Blau startet auf **Zypern / Akrotiri**.

Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Grundidee

Theater Command DCS soll keine einzelne statische DCS-Mission werden.

Ziel ist ein modulares Kampagnensystem, das später dynamisch auf Spieleraktionen, KI-Ereignisse, Logistik, Basenbesitz, IADS-Zustand und Missionsfortschritt reagieren kann.

Der Spieler soll nicht nur eine einzelne Mission fliegen.

Der Spieler soll Teil eines größeren dynamischen Einsatzraums sein.

---

## Projektprinzip

Das zentrale Projektprinzip lautet:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Mission Editor stellt die physische Umgebung bereit.

Lua übernimmt die dynamische Kampagnenlogik.

GitHub dokumentiert Struktur, Entscheidungen, Versionen, Aufgabenstand und Projektfortschritt.

---

## Erste Kampagne

Name:

    Operation Levant Reclamation

Map:

    Syria

Ausgangslage:

    Blue Start: Akrotiri / Zypern
    Red Start: syrisches Festland vollständig rot kontrolliert

Erste operative Zielrichtung:

    syrische Küste

Erste geplante blaue Hauptbasis:

    Akrotiri

Erstes logistisches Ziel:

    Brückenkopf / FOB an der syrischen Küste vorbereiten

Erstes operatives Ziel:

    rote Luftverteidigung an der syrischen Küste schwächen

---

## Aktueller Projektstand

Stand:

    2026-06-15

Aktuell vorhanden:

- zentrale Projektdateien
- `docs/`-Grundblock
- `vendor/`-Frameworkstruktur
- MIST
- MOOSE
- CTLD
- Skynet IADS
- `src/README.md`

Aktuell abgeschlossen:

- Repository erstellt
- Grunddokumentation angelegt
- Dokumentationsgrundblock erstellt
- Vendor-Ordner vorbereitet
- alle geplanten Frameworks hinterlegt
- Vendor-README-Dateien aktualisiert
- MIST auf CTLD-kompatible Version ersetzt
- falsch platzierte Root-`Moose.lua` entfernt
- zentrale Dokumentation teilweise auf aktuellen Vendor-Stand gebracht

Noch nicht begonnen:

- eigene Lua-Core-Dateien
- `src/loader.lua`
- `src/main.lua`
- eigene Airbase-Erkennung
- eigene Zonenlogik
- eigenes Capture-System
- eigene Logistik-Anbindung
- eigener Missionsgenerator
- eigener AI Director
- eigene IADS-Kampagnenlogik
- Persistenz
- DEV-Mission im DCS Mission Editor

---

## Aktueller Framework-Stand

Externe Frameworks liegen unter:

    vendor/

Aktuell hinterlegte Frameworks:

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Zusätzliche Referenzdateien:

    vendor/mist/Mist guide.pdf
    vendor/mist/Example_DBs/
    vendor/moose/MOOSE_DOCS.md

Wichtig:

Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket.

Grund:

CTLD weist darauf hin, dass für korrektes dynamisches Spawning die mit CTLD gelieferte MIST-Version verwendet werden soll.

---

## Geplante Lade-Reihenfolge

Die geplante Lade-Reihenfolge im DCS Mission Editor lautet:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua
    6. src/loader.lua

Wichtig:

- MIST muss vor CTLD geladen werden.
- `CTLD-i18n.lua` muss vor `CTLD.lua` geladen werden.
- Skynet IADS muss nach MIST geladen werden.
- Eigene Theater-Command-Logik startet erst nach allen externen Frameworks.

---

## Hauptarchitektur

Theater Command DCS trennt klar zwischen externen Frameworks und eigener Logik.

Externe Frameworks:

    vendor/

Eigene Theater-Command-Logik:

    src/

Frameworks werden nicht verändert.

Eigene Projektlogik wird nicht in Framework-Dateien geschrieben.

---

## Vendor

Der Ordner `vendor/` enthält externe Frameworks und Referenzmaterial.

Aktuelle Struktur:

    vendor/
    ├── README.md
    ├── mist/
    ├── moose/
    ├── ctld/
    └── skynet-iads/

Die Frameworks liefern technische Funktionen.

Theater Command DCS entscheidet später über die kampagnenlogische Bedeutung dieser Funktionen.

Beispiel:

CTLD kann eine Kiste transportieren.

Theater Command DCS entscheidet, ob diese Kiste eine Basis versorgt, einen FOB aufbaut oder eine Capture-Zone beeinflusst.

Beispiel:

Skynet IADS kann ein SAM-Netzwerk taktisch steuern.

Theater Command DCS entscheidet, ob dieser IADS-Sektor strategisch aktiv, beschädigt, zerstört oder wiederhergestellt ist.

---

## Source

Der Ordner `src/` enthält später die eigene Lua-Logik.

Aktuell vorhanden:

    src/README.md

Geplante Struktur:

    src/
    ├── README.md
    ├── loader.lua
    ├── main.lua
    ├── core/
    ├── world/
    ├── campaign/
    ├── logistics/
    ├── missions/
    ├── ai/
    ├── iads/
    ├── ui/
    └── debug/

Die Struktur wird nach Aufgaben sortiert.

Sie wird nicht nach Frameworks sortiert.

Nicht gewünscht:

    src/tc_moose.lua
    src/tc_mist.lua
    src/tc_ctld.lua
    src/tc_all_in_one.lua

Gewünscht sind aufgabenorientierte Dateien, zum Beispiel:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua
    src/campaign/tc_capture_system.lua
    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua
    src/missions/tc_mission_generator.lua
    src/ai/tc_ai_cap_manager.lua
    src/campaign/tc_persistence_system.lua

---

## Geplante Hauptsysteme

Theater Command DCS soll später aus mehreren klar getrennten Systemen bestehen.

Geplante Systeme:

- Core-System
- World-System
- Airbase-System
- Zonen-System
- Campaign-System
- Capture-System
- Logistics-System
- Missions-System
- AI-System
- IADS-System
- UI-System
- Debug-System
- Persistenz-System

---

## Core-System

Das Core-System bildet später die technische Basis.

Geplante Aufgaben:

- zentrale Konfiguration
- Logging
- globale Projektstruktur
- globale Zustandsverwaltung
- Utility-Funktionen
- Scheduler
- Framework-Prüfung

Geplante Dateien:

    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
    src/core/tc_utils.lua
    src/core/tc_scheduler.lua

---

## Airbase- und World-System

Das Airbase- und World-System soll später die DCS-Welt in Theater-Command-Strukturen überführen.

Geplante Aufgaben:

- Airbases automatisch erkennen
- Akrotiri als blaue Startbasis erkennen
- syrisches Festland initial rot bewerten
- BaseNodes erzeugen
- Regionen klassifizieren
- virtuelle Zonen vorbereiten
- Airbase-Daten für Capture und Missionen bereitstellen

Geplante Dateien:

    src/world/tc_airbase_scanner.lua
    src/world/tc_airbase_registry.lua
    src/world/tc_airbase_overrides.lua
    src/world/tc_region_classifier.lua
    src/world/tc_zone_factory.lua
    src/world/tc_zone_registry.lua

---

## Capture-System

Das Capture-System steuert später Besitzwechsel und Kampagnenfortschritt.

Geplante Aufgaben:

- Besitzstatus von Basen verwalten
- Besitzstatus von Zonen verwalten
- Capture-Bedingungen auswerten
- Logistikstatus einbeziehen
- Garnisonen einbeziehen
- IADS- und Missionsfortschritt berücksichtigen
- Kampagnenfortschritt speichern

Geplante Dateien:

    src/campaign/tc_capture_system.lua
    src/campaign/tc_base_ownership.lua
    src/campaign/tc_campaign_state.lua
    src/campaign/tc_frontline_system.lua

---

## Logistics-System

Das Logistics-System verbindet CTLD mit Theater Command DCS.

CTLD führt technische Transportvorgänge aus.

Theater Command DCS bewertet die strategische Wirkung.

Geplante Aufgaben:

- CTLD-Lieferungen auswerten
- FOB-Aufbau bewerten
- Logistikhubs verwalten
- Versorgungsstatus speichern
- Logistik mit Capture verbinden
- Logistik mit Missionen verbinden

Geplante Dateien:

    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua
    src/logistics/tc_logistics_state.lua
    src/logistics/tc_logistics_hubs.lua
    src/logistics/tc_supply_routes.lua

---

## Missions-System

Das Missions-System erzeugt später dynamische Aufgaben aus der aktuellen Kampagnenlage.

Geplante Aufgaben:

- Spielerflugzeug erkennen
- Missionen nach Flugzeugtyp filtern
- Missionsziele aus Airbase-, IADS-, Logistik- und Capture-Zustand ableiten
- Missionen über F10-Menü anbieten
- Missionserfolg auswerten
- Missionshistorie speichern

Geplante Dateien:

    src/missions/tc_mission_generator.lua
    src/missions/tc_mission_registry.lua
    src/missions/tc_mission_types.lua
    src/missions/tc_mission_filter_by_aircraft.lua

---

## AI Director

Der AI Director soll später rote und blaue Reaktionen steuern.

Geplante Aufgaben:

- CAP erzeugen
- GCI erzeugen
- KI-Reaktionen auf Capture-Ereignisse
- KI-Reaktionen auf IADS-Schäden
- Gegenangriffe vorbereiten
- Eskalationslogik vorbereiten
- Welt dynamischer wirken lassen

Geplante Dateien:

    src/ai/tc_ai_director.lua
    src/ai/tc_ai_cap_manager.lua
    src/ai/tc_ai_gci_manager.lua
    src/ai/tc_ai_counterattack.lua

---

## IADS-System

Das IADS-System verbindet Skynet IADS mit Theater Command DCS.

Skynet IADS steuert taktisches Radar- und SAM-Verhalten.

Theater Command DCS bewertet den strategischen IADS-Zustand.

Geplante Aufgaben:

- IADS-Sektoren definieren
- SAM-Stellungen verwalten
- Radarstellungen verwalten
- IADS-Zustand speichern
- SEAD-/DEAD-Wirkung auswerten
- IADS-Ziele an Missionsgenerator liefern
- IADS-Zustand an AI Director liefern

Geplante Dateien:

    src/iads/tc_iads_network.lua
    src/iads/tc_iads_sites.lua
    src/iads/tc_iads_sectors.lua
    src/iads/tc_iads_state.lua
    src/iads/tc_iads_config.lua

---

## Persistenz

Persistenz wird später aufgebaut, wenn Airbase-, Capture- und Logistiksystem stabil sind.

Geplante Aufgaben:

- Kampagnenzustand serialisieren
- Kampagnenzustand laden
- Basenbesitz speichern
- Zonenbesitz speichern
- FOBs speichern
- Logistikstatus speichern
- IADS-Zustand speichern
- Missionshistorie speichern

Geplante Dateien:

    src/campaign/tc_persistence_system.lua
    save/README.md
    save/example_state.lua

Persistenz wird nicht vorzeitig gebaut.

Zuerst muss klar sein, welche Daten stabil gespeichert werden müssen.

---

## Mission Editor

Der Mission Editor wird später genutzt für:

- Syria Map
- Koalitionen
- Spieler-Slots
- Lade-Trigger
- Template-Gruppen
- CTLD-Zonen
- statische Ziele
- erste Testumgebung

Geplante DEV-Mission:

    Operation_Levant_Reclamation_DEV.miz

Geplanter späterer Ablageort:

    mission/dev/

Der Mission Editor soll nicht für große Kampagnenlogik genutzt werden.

---

## Aktueller nächster technischer Schritt

Nach Abschluss der aktuellen Dokumentationsaktualisierung:

    src-Unterordner und README-Dateien erstellen

Danach:

    src/loader.lua
    src/main.lua
    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua

---

## Aktueller nächster Dokumentationsschritt

Nach dieser Datei sollte geprüft werden, ob noch weitere Dokumentationsdateien zwingend aktualisiert werden müssen.

Falls keine zwingende Aktualisierung mehr offen ist, kann die Session mit einem sauberen Übergabe-Prompt abgeschlossen werden.
