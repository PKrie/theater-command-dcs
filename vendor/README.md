# Vendor

Dieser Ordner enthält externe Frameworks für **Theater Command DCS**.

Externe Frameworks werden in diesem Projekt unter `vendor/` abgelegt und nicht verändert.

Eigene Theater-Command-Logik gehört nicht in diesen Ordner, sondern nach `src/`.

---

## Zweck von `vendor/`

`vendor/` ist der Sammelordner für externe Lua-Frameworks und externe Referenzdateien.

Diese Frameworks stellen technische Funktionen bereit.

Die eigentliche Kampagnenlogik bleibt Teil von Theater Command DCS und wird später unter `src/` entwickelt.

Grundregel:

    vendor/ = externe Frameworks
    src/ = eigene Theater-Command-Logik

---

## Aktueller Stand

Stand:

    2026-06-15

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

---

## Aktuelle Ordnerstruktur

Aktuelle Vendor-Struktur:

    vendor/
    ├── README.md
    ├── mist/
    │   ├── README.md
    │   ├── mist.lua
    │   ├── Mist guide.pdf
    │   └── Example_DBs/
    ├── moose/
    │   ├── README.md
    │   ├── Moose.lua
    │   └── MOOSE_DOCS.md
    ├── ctld/
    │   ├── README.md
    │   ├── CTLD-i18n.lua
    │   └── CTLD.lua
    └── skynet-iads/
        ├── README.md
        └── SkynetIADS.lua

Nicht hinterlegt sind aktuell:

    vendor/ctld/beacon.ogg
    vendor/ctld/beaconsilent.ogg

Diese CTLD-Sounddateien werden erst ergänzt, wenn CTLD-Radio-Beacons aktiv genutzt werden sollen.

---

## Framework-Rollen

### MIST

Pfad:

    vendor/mist/mist.lua

Rolle:

- DCS-Hilfsfunktionen
- Datenbankfunktionen
- Gruppenlogik
- Koordinatenlogik
- Grundlage für CTLD
- Unterstützung bei dynamischem Spawning
- Unterstützung bei Event-Auswertung

Besonderheit:

Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket.

Grund:

CTLD weist darauf hin, dass für korrektes dynamisches Spawning die mit CTLD gelieferte MIST-Version verwendet werden soll.

Aktive Kombination:

    MIST: 4.5.128-DYNSLOTS-02
    CTLD: 1.6.1

---

### MOOSE

Pfad:

    vendor/moose/Moose.lua

Rolle:

- objektorientierte DCS-Framework-Schicht
- Wrapper für DCS-Objekte
- Scheduler
- SETs
- Spawning
- Airbase-Wrapper
- Zonenlogik
- CAP- und GCI-Management
- AI-Management
- Debug- und Testfunktionen

Zusätzliche Referenz:

    vendor/moose/MOOSE_DOCS.md

Diese Datei verweist auf die offizielle MOOSE-Online-Dokumentation.

Die vollständige HTML-Dokumentation wird nicht lokal kopiert.

---

### CTLD

Pfade:

    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua

Rolle:

- Truppentransport
- Kistentransport
- Logistikflüge
- FOB-Aufbau
- Pickup-Zonen
- Dropoff-Zonen
- Heli-Interaktion

Wichtig:

MIST muss vor CTLD geladen werden.

`CTLD-i18n.lua` muss vor `CTLD.lua` geladen werden.

CTLD führt technische Logistikvorgänge aus.

Theater Command DCS entscheidet später, welche kampagnenlogische Bedeutung diese Vorgänge haben.

---

### Skynet IADS

Pfad:

    vendor/skynet-iads/SkynetIADS.lua

Rolle:

- IADS-Netzwerke
- Radarlogik
- SAM-Verhalten
- Emissionskontrolle
- SEAD-Reaktionen
- DEAD-Reaktionen
- Luftverteidigungssektoren

Wichtig:

Verwendet wird die kompilierte Skynet-IADS-Datei.

Die ursprüngliche Quelldatei heißt im offiziellen Repository:

    skynet-iads-compiled.lua

Für Theater Command DCS wird sie stabil geführt als:

    SkynetIADS.lua

Skynet IADS steuert später taktisches Luftverteidigungsverhalten.

Theater Command DCS entscheidet über den strategischen IADS-Zustand.

---

## Geplante Lade-Reihenfolge

Die Frameworks sollen später im DCS Mission Editor in dieser Reihenfolge geladen werden:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua
    6. src/loader.lua

Wichtig:

- MIST wird vor CTLD geladen.
- `CTLD-i18n.lua` wird vor `CTLD.lua` geladen.
- Skynet IADS wird nach MIST geladen.
- Eigene Theater-Command-Logik startet erst nach allen externen Frameworks.

---

## Was in `vendor/` nicht gemacht wird

In `vendor/` wird keine eigene Theater-Command-Logik geschrieben.

Nicht gewünscht:

    vendor/tc_moose.lua
    vendor/tc_mist.lua
    vendor/tc_ctld.lua
    vendor/tc_all_in_one.lua

Auch unter `src/` sind frameworkorientierte Sammeldateien nicht gewünscht.

Nicht gewünscht:

    src/tc_moose.lua
    src/tc_mist.lua
    src/tc_ctld.lua
    src/tc_all_in_one.lua

Gewünscht ist eine aufgabenorientierte Struktur unter `src/`.

Beispiele:

    src/world/tc_airbase_scanner.lua
    src/world/tc_zone_factory.lua
    src/campaign/tc_capture_system.lua
    src/logistics/tc_logistics_delivery.lua
    src/logistics/tc_fob_system.lua
    src/missions/tc_mission_generator.lua
    src/ai/tc_ai_cap_manager.lua
    src/campaign/tc_persistence_system.lua

Eine eigene Datei darf intern MIST, MOOSE, CTLD oder Skynet IADS nutzen.

Der Dateiname richtet sich aber immer nach der Aufgabe, nicht nach dem Framework.

---

## Umgang mit Framework-Dateien

Framework-Dateien werden grundsätzlich unverändert übernommen.

Regeln:

1. offizielle Quelle prüfen
2. Datei unverändert übernehmen
3. stabilen Projektnamen verwenden
4. Version dokumentieren
5. README des jeweiligen Framework-Ordners aktualisieren
6. keine lokalen Änderungen in Framework-Dateien vornehmen
7. bei neuer Version die Datei vollständig ersetzen
8. Missionstest durchführen

Stabile Projektnamen:

    vendor/mist/mist.lua
    vendor/moose/Moose.lua
    vendor/ctld/CTLD-i18n.lua
    vendor/ctld/CTLD.lua
    vendor/skynet-iads/SkynetIADS.lua

Diese stabilen Namen verhindern, dass die Mission-Editor-Ladefolge bei jedem Framework-Update angepasst werden muss.

---

## Referenzdateien

### MIST-Handbuch

Pfad:

    vendor/mist/Mist guide.pdf

Zweck:

- lokale Referenz
- Nachschlagen von MIST-Funktionen
- Entwicklungshilfe

Das Handbuch wird nicht durch DCS geladen.

---

### MIST Example_DBs

Pfad:

    vendor/mist/Example_DBs/

Zweck:

- Referenzmaterial
- Beispielstrukturen für MIST-Datenbanken
- Verständnis von MIST-internen Datenstrukturen

Diese Dateien werden nicht automatisch durch Theater Command DCS geladen.

---

### MOOSE_DOCS.md

Pfad:

    vendor/moose/MOOSE_DOCS.md

Zweck:

- Verweis auf die offizielle MOOSE-Dokumentation
- Orientierung für spätere MOOSE-Nutzung
- Vermeidung einer vollständigen lokalen HTML-Kopie

---

## Zusammenhang mit Theater Command DCS

Die externen Frameworks stellen nur technische Werkzeuge bereit.

Theater Command DCS entscheidet selbst über:

- Kampagnenzustand
- Basenbesitz
- Zonenbesitz
- Logistikstatus
- Missionsauswahl
- AI-Reaktionen
- IADS-Status
- Persistenz

Beispiel:

CTLD kann eine Kiste transportieren.

Theater Command DCS entscheidet, ob diese Kiste eine Basis versorgt, einen FOB aufbaut oder eine Capture-Zone beeinflusst.

Beispiel:

Skynet IADS kann SAM-Systeme taktisch steuern.

Theater Command DCS entscheidet, ob dieser IADS-Sektor strategisch aktiv, beschädigt, zerstört oder wiederaufgebaut ist.

---

## Test nach Vendor-Abschluss

Nach dem vollständigen Vendor-Import sollen später im DCS Mission Editor folgende Punkte geprüft werden:

- MIST lädt ohne Lua-Fehler
- MOOSE lädt ohne Lua-Fehler
- CTLD-i18n lädt vor CTLD
- CTLD lädt ohne fehlende MIST-Abhängigkeiten
- Skynet IADS lädt ohne Lua-Fehler
- `dcs.log` enthält keine Framework-Fehler
- Theater Command Loader startet erst nach den Frameworks
- einfache Framework-Funktionen sind verfügbar

---

## Aktueller Status

Der Vendor-Ordner ist funktional vorbereitet.

Alle geplanten externen Frameworks sind lokal hinterlegt.

Als nächster technischer Projektschritt folgt nach Abschluss der Dokumentationsaktualisierung die weitere Vorbereitung von `src/`.

Nächster technischer Fokus:

    src-Unterordner und README-Dateien erstellen

Danach:

    src/loader.lua
    src/main.lua
    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
