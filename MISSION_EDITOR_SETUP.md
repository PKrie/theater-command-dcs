# Mission Editor Setup

Diese Datei beschreibt, was im DCS Mission Editor für **Theater Command DCS** vorbereitet werden muss.

Die erste Kampagne trägt den Arbeitstitel:

    Operation Levant Reclamation

Die Kampagne wird auf der **Syria Map** aufgebaut. Blau startet auf **Zypern / Akrotiri**. Das syrische Festland ist zu Kampagnenbeginn vollständig rot kontrolliert.

---

## Grundsatz

Der Mission Editor ist in Theater Command DCS nicht das eigentliche Kampagnensystem.

Der Mission Editor stellt nur die physische Bühne bereit.

Die dynamische Kampagne wird durch Lua gesteuert.

Grundprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Der Mission Editor soll möglichst schlank bleiben.

Alles, was sinnvoll durch Lua erkannt, berechnet oder gesteuert werden kann, soll nicht als große Triggerkette im Mission Editor gebaut werden.

---

## Aktueller Projektstand

Stand: 2026-06-16

Aktuell vorhanden:

- zentrale Projektdokumentation
- `docs/`-Grundblock
- `vendor/`-Frameworks
- `src/README.md`
- `src/loader.lua`
- `src/main.lua`
- `src/core/`
- `src/world/`
- `src/campaign/`
- `src/logistics/`
- `src/missions/`
- `src/ai/`
- `src/iads/`
- `src/ui/`
- `src/debug/`

Aktuell vorhandene aktive eigene Lua-Module:

- `src/core/tc_config.lua`
- `src/core/tc_logger.lua`
- `src/core/tc_state.lua`
- `src/core/tc_utils.lua`
- `src/core/tc_scheduler.lua`
- `src/world/tc_airbase_scanner.lua`
- `src/world/tc_zone_factory.lua`
- `src/campaign/tc_capture_system.lua`
- `src/campaign/tc_persistence_system.lua`
- `src/logistics/tc_logistics_delivery.lua`
- `src/logistics/tc_fob_system.lua`
- `src/missions/tc_mission_generator.lua`
- `src/ai/tc_ai_cap_manager.lua`

Aktuell noch nicht vorhanden:

- DEV-Mission
- Mission-Editor-Triggerstruktur
- Spieler-Slots
- Template-Gruppen
- CTLD-Zonen
- statische Ziele
- Testumgebung
- konkrete IADS-Lua-Implementierung
- konkrete UI-Lua-Implementierung
- konkrete Debug-Lua-Implementierung

Aktueller technischer Prüfpunkt:

    DCS-Sandbox-Verhalten für dofile prüfen

---

## Was der Mission Editor bereitstellt

Im Mission Editor werden nur die Dinge angelegt, die DCS physisch in der Mission braucht.

Dazu gehören später:

- Syria Map
- Koalitionen
- Startzeit
- Wetter
- Spieler-Client-Slots
- Framework-Lade-Trigger
- Theater-Command-Lade-Trigger
- Template-Gruppen mit Late Activation
- CTLD-Startzonen
- sichtbare statische Ziele
- erste IADS-Gruppen
- erste Testumgebung

Optional später:

- Carrier-Gruppe
- Tanker
- AWACS
- Marinegruppen
- zusätzliche Forward Bases

---

## Was nicht im Mission Editor gebaut wird

Nicht im Mission Editor bauen:

- keine große Kampagnenlogik
- keine Triggerketten pro Basis
- keine manuelle Frontlinienlogik
- keine Logistiklogik pro Basis
- keine 69 Airbase-Zonen
- keine dynamischen Missionen per Editor-Trigger
- keine Ressourcenlogik
- keine Persistenzlogik
- keine KI-Gegenoffensiven als feste Triggerketten
- keine manuelle IADS-Kampagnenlogik

Diese Systeme werden durch Lua-Dateien unter `src/` gesteuert.

---

## Grundmission erstellen

Im DCS Mission Editor:

    Map: Syria
    Missionsname: Operation Levant Reclamation DEV
    Startbasis Blau: Akrotiri
    Rotes Gebiet: syrisches Festland
    Startzeit: 08:00 lokal
    Wetter: zunächst einfach und stabil

Mission speichern als:

    Operation_Levant_Reclamation_DEV.miz

Geplanter Ablageort im Projekt:

    mission/dev/Operation_Levant_Reclamation_DEV.miz

Der Ordner `mission/dev/` existiert aktuell noch nicht.

Er wird erst angelegt, wenn die Mission-Editor-Arbeit beginnt.

---

## Koalitionen

### Blau

Empfohlene blaue Länder:

- USA
- UK
- France
- Germany optional
- Canada optional
- weitere NATO- oder Partnerstaaten optional

Blauer Start:

    Akrotiri

Optional später:

    Carrier-Gruppe im östlichen Mittelmeer

---

### Rot

Empfohlene rote Länder:

- Syria
- Russia
- Iran optional
- Insurgent/Red Force optional

Roter Start:

    gesamtes syrisches Festland

Wichtige rote Kernräume:

- Khmeimim
- Latakia
- Tartus
- Hama
- Homs
- Damascus

---

### Neutral oder zunächst gesperrt

Für die erste Version neutral oder nicht aktiv:

- Turkey
- Israel
- Jordan
- Lebanon
- zivile Bereiche auf Zypern

Diese Regionen können später über Lua oder neue Missionsversionen aktiviert werden.

---

## Spieler-Slots

Spieler-Client-Slots müssen im Mission Editor angelegt werden.

Für die erste Entwicklungsphase werden Spieler-Slots nur auf Akrotiri angelegt.

Empfohlene erste Slots:

    CLIENT_BLUE_FA18C_AKROTIRI_01
    CLIENT_BLUE_FA18C_AKROTIRI_02
    CLIENT_BLUE_F16C_AKROTIRI_01
    CLIENT_BLUE_F16C_AKROTIRI_02
    CLIENT_BLUE_F15E_AKROTIRI_01
    CLIENT_BLUE_F15E_AKROTIRI_02
    CLIENT_BLUE_F14B_AKROTIRI_01
    CLIENT_BLUE_F14B_AKROTIRI_02
    CLIENT_BLUE_UH1H_AKROTIRI_01
    CLIENT_BLUE_MI8_AKROTIRI_01

A-10C II und AH-64D werden erst später sinnvoll, wenn ein FOB oder eine Festlandbasis aktiv ist.

Spätere mögliche Slots:

    CLIENT_BLUE_A10C_FOB_ALPHA_01
    CLIENT_BLUE_AH64D_FOB_ALPHA_01
    CLIENT_BLUE_UH1H_FOB_ALPHA_01
    CLIENT_BLUE_MI8_FOB_ALPHA_01

Die spätere Detaildokumentation erfolgt unter:

    mission_editor/client_slots.md

---

## Externe Frameworks

Externe Frameworks liegen im Projekt unter:

    vendor/

Aktueller Framework-Stand:

| Framework | Projektpfad | Stand |
|---|---|---|
| MIST | `vendor/mist/mist.lua` | `4.5.128-DYNSLOTS-02` |
| MOOSE | `vendor/moose/Moose.lua` | `2.9.17` |
| CTLD | `vendor/ctld/CTLD.lua` | `1.6.1` |
| Skynet IADS | `vendor/skynet-iads/SkynetIADS.lua` | `3.3.0` |

Zusätzliche relevante Dateien:

    vendor/ctld/CTLD-i18n.lua
    vendor/mist/Mist guide.pdf
    vendor/mist/Example_DBs/
    vendor/moose/MOOSE_DOCS.md

Wichtig:

Die aktive MIST-Version stammt bewusst aus dem CTLD-Paket.

Grund:

CTLD weist darauf hin, dass für korrektes dynamisches Spawning die mit CTLD gelieferte MIST-Version verwendet werden soll.

---

## Framework-Lade-Reihenfolge

Die Frameworks werden über Mission-Editor-Trigger geladen.

Geplante Lade-Reihenfolge:

    1. vendor/mist/mist.lua
    2. vendor/moose/Moose.lua
    3. vendor/ctld/CTLD-i18n.lua
    4. vendor/ctld/CTLD.lua
    5. vendor/skynet-iads/SkynetIADS.lua

Diese Reihenfolge ist verbindlich.

Wichtig:

- MIST muss vor CTLD geladen werden.
- `CTLD-i18n.lua` muss vor `CTLD.lua` geladen werden.
- Skynet IADS muss nach MIST geladen werden.
- Eigene Theater-Command-Logik startet erst nach allen externen Frameworks.

---

## DCS-Sandbox und `dofile`

`src/loader.lua` ist aktuell so gebaut, dass eigene Module grundsätzlich per `dofile` nachgeladen werden können.

Das ist für ein normales Lua-Projekt sauber.

Im DCS Mission Scripting Environment muss dieses Verhalten aber real getestet werden.

Grund:

DCS-Missionen laufen in einer isolierten Mission-Scripting-Umgebung.

Zusätzlich werden sicherheitsrelevante Module wie `io`, `lfs`, `os`, `require`, `package` oder `loadlib` standardmäßig entfernt oder eingeschränkt.

Deshalb wird für die erste DEV-Prüfung nicht davon ausgegangen, dass `dofile` zuverlässig projektlokale Dateien nachladen kann.

---

## `dofile`-Entscheidung für den ersten Test

Für den ersten realen DCS-Test gilt:

    Nicht auf dofile verlassen.

Stattdessen wird zunächst eine sichere Mission-Editor-Ladevariante genutzt.

Die erste sichere Variante lädt alle aktiven eigenen Lua-Dateien einzeln per `DO SCRIPT FILE`.

Danach wird `src/loader.lua` als letzte eigene Datei geladen.

Vorteil:

    Die Module sind bereits im DCS-Mission-Environment vorhanden.
    loader.lua erkennt die Module als bereits geladen.
    loader.lua muss im ersten Test keine eigenen Dateien per dofile nachladen.
    main.lua wird erst durch loader.lua gestartet.

Diese Variante prüft zuerst, ob die Module grundsätzlich im DCS-Kontext fehlerfrei laufen.

Erst danach wird geprüft, ob der kompakte Loader-only-Ansatz mit `dofile` funktioniert.

---

## Starttest-Variante A — sichere Einzeldatei-Ladung

Diese Variante ist die erste empfohlene DEV-Testvariante.

Sie vermeidet eine harte Abhängigkeit von `dofile`.

### Zweck

Prüfen, ob alle aktuellen Theater-Command-Dateien im DCS Mission Scripting Environment fehlerfrei geladen werden können.

### Reihenfolge

Im Mission Editor werden die Dateien über `DO SCRIPT FILE` geladen:

    TIME MORE 1
    DO SCRIPT FILE: vendor/mist/mist.lua

    TIME MORE 2
    DO SCRIPT FILE: vendor/moose/Moose.lua

    TIME MORE 3
    DO SCRIPT FILE: vendor/ctld/CTLD-i18n.lua

    TIME MORE 4
    DO SCRIPT FILE: vendor/ctld/CTLD.lua

    TIME MORE 5
    DO SCRIPT FILE: vendor/skynet-iads/SkynetIADS.lua

    TIME MORE 7
    DO SCRIPT FILE: src/core/tc_config.lua

    TIME MORE 8
    DO SCRIPT FILE: src/core/tc_logger.lua

    TIME MORE 9
    DO SCRIPT FILE: src/core/tc_state.lua

    TIME MORE 10
    DO SCRIPT FILE: src/core/tc_utils.lua

    TIME MORE 11
    DO SCRIPT FILE: src/core/tc_scheduler.lua

    TIME MORE 12
    DO SCRIPT FILE: src/world/tc_airbase_scanner.lua

    TIME MORE 13
    DO SCRIPT FILE: src/world/tc_zone_factory.lua

    TIME MORE 14
    DO SCRIPT FILE: src/campaign/tc_capture_system.lua

    TIME MORE 15
    DO SCRIPT FILE: src/campaign/tc_persistence_system.lua

    TIME MORE 16
    DO SCRIPT FILE: src/logistics/tc_logistics_delivery.lua

    TIME MORE 17
    DO SCRIPT FILE: src/logistics/tc_fob_system.lua

    TIME MORE 18
    DO SCRIPT FILE: src/missions/tc_mission_generator.lua

    TIME MORE 19
    DO SCRIPT FILE: src/ai/tc_ai_cap_manager.lua

    TIME MORE 20
    DO SCRIPT FILE: src/main.lua

    TIME MORE 22
    DO SCRIPT FILE: src/loader.lua

### Erwartung

`src/main.lua` wird zwar geladen, startet aber nicht selbst.

`src/loader.lua` wird zuletzt geladen.

`src/loader.lua` erkennt die vorher geladenen Module und startet danach `main.lua`.

Erwartete Logik:

    vendor files load first
    src modules load next
    main.lua is available
    loader.lua starts
    loader.lua checks frameworks
    loader.lua detects already loaded modules
    loader.lua starts main.lua
    main.lua starts runtime systems

Diese Variante ist die erste technische Sicherheitsprüfung.

---

## Starttest-Variante B — kompakter Loader-only-Test

Diese Variante wird erst nach erfolgreicher Variante A getestet.

### Zweck

Prüfen, ob `src/loader.lua` eigenständig über `dofile` die restlichen Source-Dateien nachladen kann.

### Reihenfolge

Im Mission Editor werden nur Frameworks und Loader geladen:

    TIME MORE 1
    DO SCRIPT FILE: vendor/mist/mist.lua

    TIME MORE 2
    DO SCRIPT FILE: vendor/moose/Moose.lua

    TIME MORE 3
    DO SCRIPT FILE: vendor/ctld/CTLD-i18n.lua

    TIME MORE 4
    DO SCRIPT FILE: vendor/ctld/CTLD.lua

    TIME MORE 5
    DO SCRIPT FILE: vendor/skynet-iads/SkynetIADS.lua

    TIME MORE 7
    DO SCRIPT FILE: src/loader.lua

### Erwartung

Diese Variante funktioniert nur, wenn `dofile` im konkreten DCS-Kontext die Projektpfade erfolgreich laden kann.

Mögliche Fehler:

    dofile_unavailable
    cannot open src/core/tc_config.lua
    path not found
    file_executed_but_module_not_detected

Wenn diese Variante fehlschlägt, ist das kein Architekturbruch.

Dann bleibt Variante A die sichere DEV-Ladeweise, bis eine bessere Build- oder Loader-Strategie eingeführt wird.

---

## Konsequenz für `src/loader.lua`

`src/loader.lua` bleibt zunächst unverändert.

Grund:

Der Loader unterstützt beide Varianten.

Variante A:

    Module werden vorher per Mission Editor geladen.
    Loader erkennt sie als vorhanden.
    dofile wird für diese Module nicht benötigt.

Variante B:

    Loader lädt Module selbst per dofile.
    Diese Variante wird separat getestet.

Damit kann der aktuelle Loader im ersten DEV-Test weiterverwendet werden.

---

## Empfohlene Trigger-Struktur für den ersten DEV-Test

Für den ersten realen Test wird Variante A empfohlen.

Trigger-Namen:

    TC_LOAD_MIST
    TC_LOAD_MOOSE
    TC_LOAD_CTLD_I18N
    TC_LOAD_CTLD
    TC_LOAD_SKYNET_IADS
    TC_LOAD_TC_CONFIG
    TC_LOAD_TC_LOGGER
    TC_LOAD_TC_STATE
    TC_LOAD_TC_UTILS
    TC_LOAD_TC_SCHEDULER
    TC_LOAD_TC_AIRBASE_SCANNER
    TC_LOAD_TC_ZONE_FACTORY
    TC_LOAD_TC_CAPTURE_SYSTEM
    TC_LOAD_TC_PERSISTENCE_SYSTEM
    TC_LOAD_TC_LOGISTICS_DELIVERY
    TC_LOAD_TC_FOB_SYSTEM
    TC_LOAD_TC_MISSION_GENERATOR
    TC_LOAD_TC_AI_CAP_MANAGER
    TC_LOAD_TC_MAIN
    TC_LOAD_TC_LOADER

Die Trigger sollen einfach und zeitversetzt bleiben.

Keine komplexe Bedingungslogik.

---

## Warum die Lade-Reihenfolge wichtig ist

MIST muss zuerst geladen werden, weil CTLD MIST benötigt.

CTLD-i18n muss vor CTLD geladen werden, weil CTLD die Übersetzungsstruktur erwartet.

Skynet IADS benötigt ebenfalls MIST-Funktionalität und wird daher nach MIST geladen.

MOOSE wird früh geladen, damit spätere Theater-Command-Module MOOSE-Klassen nutzen können.

Theater Command DCS wird zuletzt initialisiert, damit die eigene Logik auf die bereits vorhandenen Frameworks zugreifen kann.

Innerhalb von Theater Command gilt:

    Core vor allen anderen eigenen Systemen.
    World vor Campaign.
    Campaign vor Logistics und Missions.
    Logistics vor Missions.
    Missions vor AI.
    Main nach allen aktuell aktiven Modulen.
    Loader zuletzt, wenn Variante A genutzt wird.

---

## Erwartete erste Log-Ausgaben

Im ersten erfolgreichen Starttest sollen in `dcs.log` sinngemäß Meldungen erscheinen wie:

    [TC] Theater Command loader started
    [TC] Framework available: MIST
    [TC] Framework available: MOOSE
    [TC] Framework available: CTLD
    [TC] Framework available: Skynet IADS
    [TC] Core loading started
    [TC] World loading started
    [TC] Campaign loading started
    [TC] Logistics loading started
    [TC] Missions loading started
    [TC] AI loading started
    [TC] Main start requested
    [TC] Runtime systems initialized
    [TC] Main initialized
    [TC] Theater Command loader finished

Die genaue Schreibweise hängt vom Logger und den Modulmeldungen ab.

Wichtig ist:

    keine Lua-Fehler
    keine fehlenden Frameworks
    keine fehlenden Pflichtmodule
    main.lua startet
    loader.lua beendet erfolgreich

---

## Template-Gruppen

Template-Gruppen werden im Mission Editor angelegt und später per Lua gespawnt oder ausgewertet.

Alle Template-Gruppen sollen:

- Late Activation: ON
- Hidden on Map: ON
- sauber benannt
- eindeutig einer Aufgabe zugeordnet
- nicht aktiv zum Missionsstart

Template-Gruppen sind nur Vorlagen.

Die dynamische Logik entscheidet später, wann und warum sie genutzt werden.

Die spätere Dokumentation erfolgt unter:

    mission_editor/template_groups.md

---

## Erste rote Template-Gruppen

Empfohlene erste rote Templates:

    TPL_RED_CAP_MIG29_PAIR_01
    TPL_RED_GCI_MIG29_PAIR_01
    TPL_RED_SAM_SA6_SITE_01
    TPL_RED_SAM_SA10_SITE_01
    TPL_RED_EWR_COASTAL_01
    TPL_RED_GROUND_INF_SECTION_01
    TPL_RED_GROUND_ARMOR_PLATOON_01
    TPL_RED_LOGISTICS_CONVOY_01

Diese Namen sind vorläufige Beispiele.

Die endgültige Benennung muss später mit `NAMING_CONVENTIONS.md` abgestimmt werden.

---

## Erste blaue Template-Gruppen

Empfohlene erste blaue Templates:

    TPL_BLUE_CAP_FA18C_PAIR_01
    TPL_BLUE_SEAD_FA18C_PAIR_01
    TPL_BLUE_CAS_A10C_PAIR_01
    TPL_BLUE_TRANSPORT_UH1H_01
    TPL_BLUE_TRANSPORT_MI8_01
    TPL_BLUE_GROUND_INF_SECTION_01
    TPL_BLUE_LOGISTICS_CONVOY_01

Diese Templates werden erst benötigt, wenn reale Spawns getestet werden.

---

## CTLD-Zonen

Für CTLD werden später erste Pickup- und Dropoff-Zonen benötigt.

Erster geplanter Logistikhub:

    Akrotiri

Mögliche erste Pickup-Zonen:

    CTLD_PICKUP_BLUE_AKROTIRI_01
    CTLD_PICKUP_BLUE_AKROTIRI_02

Mögliche erste Dropoff-Zone:

    CTLD_DROPOFF_BLUE_COASTAL_FOB_01

Die genaue Benennung muss mit `NAMING_CONVENTIONS.md` abgestimmt werden.

Die spätere Dokumentation erfolgt unter:

    mission_editor/ctld_start_zones.md

---

## CTLD-Sounddateien

CTLD kann Radio-Beacons nutzen.

Dafür werden normalerweise folgende Sounddateien benötigt:

    beacon.ogg
    beaconsilent.ogg

Diese Dateien sind aktuell nicht im Projekt hinterlegt.

Das ist für den jetzigen Stand in Ordnung, solange CTLD-Radio-Beacons noch nicht aktiv genutzt werden.

Geplante spätere Zielpfade:

    vendor/ctld/beacon.ogg
    vendor/ctld/beaconsilent.ogg

Diese Dateien werden erst ergänzt, wenn Beacons tatsächlich genutzt werden sollen.

---

## Statische Ziele

Statische Ziele werden später als Kampagnenobjekte vorbereitet.

Mögliche Zielarten:

- Radarstellungen
- SAM-Stellungen
- Depots
- Munitionslager
- Treibstofflager
- Hafenanlagen
- Kommandoposten
- Kommunikationsanlagen
- Brücken
- Konvoisammelpunkte
- Energie- oder Versorgungseinrichtungen

Diese Ziele sollen sinnvoll benannt werden.

Später kann Theater Command DCS diese Ziele kampagnenlogisch auswerten.

Die spätere Dokumentation erfolgt unter:

    mission_editor/static_targets.md

---

## IADS-Gruppen

Für Skynet IADS werden später Gruppen im Mission Editor benötigt.

Mögliche Gruppen:

    IADS_RED_EWR_LATTAKIA_01
    IADS_RED_SAM_SA10_KHMEIMIM_01
    IADS_RED_SAM_SA6_TARTUS_01
    IADS_RED_CP_COASTAL_01

Diese Namen sind vorläufige Beispiele.

Die endgültige Benennung muss später mit `NAMING_CONVENTIONS.md` abgestimmt werden.

Wichtig:

Skynet IADS steuert später das taktische Verhalten.

Theater Command DCS entscheidet, ob ein IADS-Sektor strategisch aktiv, beschädigt, zerstört oder wiederhergestellt ist.

---

## Airbases im Mission Editor

Airbases sollen möglichst automatisch durch Lua erkannt werden.

Der Mission Editor soll nicht für jede Airbase manuelle Triggerzonen enthalten.

Geplantes Vorgehen:

    1. DCS-Airbases über Lua erkennen
    2. Airbase-Daten in Theater-Command-Struktur überführen
    3. wichtige Sonderfälle per Override behandeln
    4. virtuelle Zonen erzeugen
    5. Besitzstatus durch Theater Command verwalten

Dadurch bleibt der Mission Editor schlanker.

---

## Akrotiri

Akrotiri ist die erste blaue Hauptbasis.

Geplante Rolle:

- Startbasis für Spieler
- erster Logistikhub
- Ausgangspunkt für Luftoperationen
- Ausgangspunkt für CTLD-Logistik
- sichere blaue Rückfallbasis
- späterer HQ-Knoten im Kampagnenzustand

Akrotiri soll im Mission Editor sauber vorbereitet werden.

Die strategische Auswertung erfolgt später durch Lua.

---

## Syrisches Festland

Das syrische Festland ist zu Kampagnenbeginn rot kontrolliert.

Im Mission Editor soll diese Ausgangslage sichtbar vorbereitet werden.

Die eigentliche strategische Kontrolle wird später durch Theater Command DCS verwaltet.

Ziel:

Nicht jede Basis manuell mit komplexen Triggern verwalten.

Stattdessen:

- Basen automatisch erkennen
- Besitzstatus per Lua führen
- Capture-Zonen virtuell erzeugen
- Kampagnenfortschritt dynamisch bewerten

---

## Mission Editor und Persistenz

Persistenz wird nicht im Mission Editor gelöst.

Persistenz wird unter `src/campaign/` und später unter `save/` vorbereitet.

Vorhanden:

    src/campaign/tc_persistence_system.lua

Geplante Dateien:

    save/README.md
    save/example_state.lua

Der Mission Editor liefert nur den Startzustand.

Theater Command DCS verwaltet später den gespeicherten Zustand.

DCS-Dateizugriff wird erst nach dem ersten Starttest gesondert geprüft.

---

## Mission Editor und Debug

Debug-Funktionen sollen später über Lua und F10-Menüs erreichbar sein.

Mögliche Debug-Funktionen:

- erkannte Airbases anzeigen
- virtuelle Zonen anzeigen
- Kampagnenstatus anzeigen
- Logistikstatus anzeigen
- IADS-Status anzeigen
- aktive Missionen anzeigen
- Framework-Ladestatus anzeigen
- Runtime-Systemstatus anzeigen

Der Mission Editor selbst soll nicht mit Debug-Triggern überladen werden.

---

## Test nach Framework- und Source-Ladung

Nach dem ersten Mission-Editor-Aufbau müssen folgende Punkte geprüft werden:

- Mission startet ohne Lua-Fehler
- MIST lädt korrekt
- MOOSE lädt korrekt
- CTLD-i18n lädt korrekt
- CTLD lädt korrekt
- Skynet IADS lädt korrekt
- Lade-Reihenfolge stimmt
- aktive Theater-Command-Module laden korrekt
- `src/main.lua` wird geladen
- `src/loader.lua` wird geladen
- `src/loader.lua` erkennt Frameworks
- `src/loader.lua` erkennt bereits geladene Module
- `src/main.lua` startet Runtime-Systeme
- `dcs.log` enthält keine Framework-Fehler
- `dcs.log` enthält keine Theater-Command-Fehler

---

## `dofile`-Prüfpunkte

Für die spätere Loader-only-Variante müssen folgende Punkte geprüft werden:

- Ist `dofile` im Mission Scripting Environment verfügbar?
- Kann `dofile` relative Pfade wie `src/core/tc_config.lua` öffnen?
- Welches Arbeitsverzeichnis nutzt DCS dabei?
- Werden Dateien aus der `.miz` heraus oder aus dem Dateisystem gesucht?
- Muss ein absoluter Pfad gesetzt werden?
- Ist ein absoluter Pfad für Multiplayer/Dedicated Server überhaupt sinnvoll?
- Funktioniert das Verhalten auch auf einem Dedicated Server?
- Funktioniert das Verhalten nach DCS-Updates stabil?
- Ist diese Variante für spätere Releases vertretbar?

Bis diese Fragen beantwortet sind, bleibt Variante A die sichere erste Testvariante.

---

## Nicht jetzt umsetzen

Aktuell noch nicht im Mission Editor bauen:

- komplette Frontlinie
- alle syrischen Airbases manuell als Triggerzonen
- komplexe Basen-Capture-Trigger
- komplette IADS-Struktur
- vollständige rote Großkampagne
- komplette KI-Logik
- produktive Persistenz
- Release-Mission

Diese Dinge werden schrittweise vorbereitet.

---

## Aktueller nächster Schritt

Nach dieser Aktualisierung wird `TASKS.md` auf den neuen Mission-Editor- und `dofile`-Prüfstand gebracht.

Nächster Dokumentationsschritt:

    TASKS.md

Danach technischer Fokus:

    erste DEV-Testvariante im DCS Mission Editor vorbereiten

Empfohlene erste Testvariante:

    Starttest-Variante A — sichere Einzeldatei-Ladung

Grund:

Diese Variante prüft zuerst die aktuelle Source-Struktur ohne harte Abhängigkeit von `dofile`.
