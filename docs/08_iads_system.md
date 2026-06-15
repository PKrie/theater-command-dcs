# IADS System

Diese Datei beschreibt das geplante IADS-System von **Theater Command DCS**.

IADS steht für **Integrated Air Defense System**.

In Theater Command DCS wird Skynet IADS als externes Framework genutzt, um taktisches Radar- und SAM-Verhalten abzubilden.

Die strategische Einbindung bleibt Aufgabe von Theater Command DCS.

---

## Grundprinzip

Das IADS-System folgt dem Projektprinzip:

    Mission Editor = Bühne
    Lua = Kampagnensystem
    GitHub = Projektgedächtnis

Skynet IADS steuert taktische Luftverteidigung.

Theater Command DCS bewertet den strategischen Zustand.

Das bedeutet:

    Skynet IADS = taktisches SAM- und Radarverhalten
    Theater Command DCS = Kampagnenzustand, Missionswirkung und Persistenz

---

## Rolle von Skynet IADS

Skynet IADS ist das externe Framework für integrierte Luftverteidigung.

Aktuelle Skynet-IADS-Datei im Projekt:

    vendor/skynet-iads/SkynetIADS.lua

Aktuelle Skynet-IADS-Version:

    Skynet IADS 3.3.0

Verwendet wird die kompilierte Skynet-IADS-Datei aus dem offiziellen Repository.

Die ursprüngliche Quelldatei heißt dort:

    skynet-iads-compiled.lua

Für Theater Command DCS wird sie stabil geführt als:

    SkynetIADS.lua

Dadurch bleibt die spätere Lade-Reihenfolge im Mission Editor stabil.

---

## MIST-Abhängigkeit

Skynet IADS benötigt MIST.

Aktuelle MIST-Datei im Projekt:

    vendor/mist/mist.lua

Aktuelle MIST-Version:

    MIST 4.5.128-DYNSLOTS-02

Diese MIST-Version stammt bewusst aus dem CTLD-Paket.

Grund:

CTLD weist darauf hin, dass für korrektes dynamisches Spawning die mit CTLD gelieferte MIST-Version verwendet werden soll.

Da diese MIST-Version neuer ist als ältere Skynet-IADS-Mindestanforderungen, bleibt sie als gemeinsame MIST-Basis für CTLD und Skynet IADS aktiv.

Aktive Kombination:

    MIST: 4.5.128-DYNSLOTS-02
    Skynet IADS: 3.3.0
    CTLD: 1.6.1

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

- MIST muss vor Skynet IADS geladen werden.
- MIST muss auch vor CTLD geladen werden.
- `CTLD-i18n.lua` muss vor `CTLD.lua` geladen werden.
- Skynet IADS wird vor Theater Command DCS geladen.
- Theater Command DCS startet erst nach allen externen Frameworks.

---

## Trennung zwischen Skynet IADS und Theater Command DCS

Skynet IADS macht taktische Luftverteidigung.

Theater Command DCS macht strategische Kampagnenlogik.

Beispiel:

Skynet IADS:

    Ein Radar wird in ein IADS-Netzwerk eingebunden.
    Eine SAM-Stellung reagiert auf erkannte Luftziele.
    Eine Radarstellung kann emissionskontrolliert arbeiten.
    Ein SAM-System kann sich taktisch verhalten.

Theater Command DCS:

    Dieser IADS-Sektor ist strategisch aktiv.
    Diese Radarstellung ist zerstört.
    Diese SAM-Stellung ist für SEAD/DEAD-Missionen verfügbar.
    Dieser Luftverteidigungssektor beeinflusst Missionsauswahl.
    Dieser IADS-Schaden wird im Kampagnenzustand gespeichert.

Diese Trennung ist verbindlich.

Eigene Theater-Command-IADS-Logik wird nicht in `SkynetIADS.lua` geschrieben.

---

## Geplante eigene Dateien

Die eigene IADS-Kampagnenlogik gehört später nach:

    src/iads/

Geplante Dateien:

    src/iads/tc_iads_network.lua
    src/iads/tc_iads_sites.lua
    src/iads/tc_iads_sectors.lua
    src/iads/tc_iads_state.lua
    src/iads/tc_iads_config.lua
    src/iads/tc_iads_damage_handler.lua
    src/iads/tc_iads_rebuild_system.lua

Zusätzliche spätere Debug-Datei:

    src/debug/tc_debug_iads.lua

---

## Nicht gewünschte Dateien

Nicht gewünscht:

    src/tc_skynet.lua
    src/tc_iads_all_in_one.lua
    src/tc_all_in_one.lua

Die eigene Struktur wird nach Aufgaben sortiert.

Sie wird nicht nach Frameworks sortiert.

Eine Datei darf Skynet IADS intern nutzen.

Der Dateiname richtet sich aber immer nach der Aufgabe, nicht nach dem Framework.

---

## IADS-Rolle in Operation Levant Reclamation

Zu Beginn der Kampagne startet Blau auf Akrotiri.

Das syrische Festland ist rot kontrolliert.

Die rote Seite soll über ein glaubwürdiges Luftverteidigungsnetz verfügen.

Geplante Rolle des roten IADS:

- Schutz wichtiger Airbases
- Schutz wichtiger Küstenziele
- Schutz von Hafenanlagen
- Schutz von Industrieanlagen
- Schutz von Kommandostrukturen
- Bedrohung für blaue Luftoperationen
- Missionsziel für SEAD und DEAD
- dynamischer Faktor für den Kampagnenfortschritt

Das IADS soll nicht nur statisch vorhanden sein.

Es soll später Teil des Kampagnenzustands werden.

---

## Erste operative IADS-Idee

Die erste Kampagnenphase soll sich auf die syrische Küste konzentrieren.

Mögliche frühe rote IADS-Schwerpunkte:

- Latakia
- Tartus
- Khmeimim
- Küstenradare
- frühe SAM-Stellungen an der Küste
- Schutz wichtiger Hafen- und Luftwaffenstandorte

Blau muss die Luftverteidigung schrittweise schwächen, bevor sichere Folgeoperationen möglich werden.

Mögliche blaue Missionsarten:

- SEAD
- DEAD
- Strike gegen Radarstellungen
- Strike gegen SAM-Komponenten
- Aufklärung
- Escort
- CAP zur Absicherung von Strike-Paketen

---

## IADS-Sektoren

Theater Command DCS soll die rote Luftverteidigung später in Sektoren gliedern.

Mögliche Sektortypen:

- Küstensektor
- Airbase-Sektor
- Hinterland-Sektor
- Hauptstadtsektor
- Industrie-Sektor
- temporärer Frontsektor

Geplante Datei:

    src/iads/tc_iads_sectors.lua

Ein IADS-Sektor soll später enthalten können:

- Name
- Region
- zugehörige Airbases
- zugehörige Radarstellungen
- zugehörige SAM-Stellungen
- strategischer Aktivstatus
- Schadensstatus
- Wiederaufbau-Status
- Bedrohungswert
- Verbindung zum Missionsgenerator

---

## IADS-Netzwerke

Skynet IADS arbeitet mit IADS-Netzwerken.

Theater Command DCS soll später entscheiden, welche Netzwerke aktiv sind.

Geplante Datei:

    src/iads/tc_iads_network.lua

Geplante Aufgaben:

- Skynet-IADS-Netzwerke initialisieren
- Radargruppen hinzufügen
- SAM-Gruppen hinzufügen
- Command-Center-Strukturen vorbereiten
- Sektoren mit Netzwerken verbinden
- Netzwerke aktivieren oder deaktivieren
- Debug-Ausgaben erzeugen

Skynet IADS steuert das Netzwerk taktisch.

Theater Command DCS entscheidet, wann ein Netzwerk strategisch verfügbar ist.

---

## IADS Sites

IADS Sites sind einzelne SAM-, Radar- oder Unterstützungsstellungen.

Geplante Datei:

    src/iads/tc_iads_sites.lua

Mögliche Site-Typen:

- Early Warning Radar
- Search Radar
- Tracking Radar
- SAM Launcher
- SAM Command Unit
- AAA-Stellung
- SHORAD-Stellung
- Command Post
- Power/Support Site

Mögliche gespeicherte Werte:

- Site-ID
- Name
- Typ
- Koalition
- Region
- Sektor
- Aktivstatus
- Schadensstatus
- Wiederaufbau-Status
- Relevanz für Missionen
- Persistenzstatus

---

## IADS State

Der IADS-Zustand soll später Teil des Kampagnenzustands werden.

Geplante Datei:

    src/iads/tc_iads_state.lua

Mögliche gespeicherte Werte:

- aktive IADS-Sektoren
- zerstörte Radarstellungen
- zerstörte SAM-Stellungen
- beschädigte Sektoren
- deaktivierte Netzwerke
- wiederhergestellte Stellungen
- erkannte Lücken im Luftverteidigungsnetz
- Bedrohungswerte pro Region
- IADS-Fortschritt der blauen Seite

Dieser Zustand wird später wichtig für Persistenz und Missionsgenerierung.

---

## SEAD und DEAD

SEAD steht für Suppression of Enemy Air Defenses.

DEAD steht für Destruction of Enemy Air Defenses.

Theater Command DCS soll später beide Missionsarten kampagnenlogisch bewerten.

SEAD kann bedeuten:

- Radar zeitweise ausgeschaltet
- SAM-Stellung unterdrückt
- IADS-Sektor kurzfristig geschwächt
- Folgefenster für Strike oder Logistik geöffnet

DEAD kann bedeuten:

- Radar zerstört
- SAM-Komponente zerstört
- IADS-Sektor dauerhaft geschwächt
- Ziel im Kampagnenzustand als zerstört gespeichert

Diese Wirkung soll später nicht nur in der laufenden Mission sichtbar sein.

Sie soll in den Kampagnenzustand einfließen.

---

## Verbindung zum Missionsgenerator

Der Missionsgenerator soll später IADS-Zustände auswerten.

Geplante Verbindung:

    src/iads/
        ↓
    src/missions/

Mögliche Missionen:

- SEAD gegen aktive SAM-Stellung
- DEAD gegen priorisierte SAM-Stellung
- Strike gegen Radar
- Strike gegen Command Post
- Escort für SEAD-Paket
- Recon gegen vermutete IADS-Stellung
- Follow-up Strike nach erfolgreicher SEAD-Mission

Mögliche Filter:

- aktueller IADS-Bedrohungswert
- Entfernung zu Akrotiri
- Nähe zur Front
- Nähe zu geplantem Brückenkopf
- Relevanz für nächste Kampagnenphase
- verfügbare Spielerflugzeuge

---

## Verbindung zum AI Director

Der AI Director soll später auf IADS-Zustände reagieren.

Geplante Verbindung:

    src/iads/
        ↓
    src/ai/

Mögliche Reaktionen:

- rote CAP über geschwächten IADS-Sektoren
- rote GCI-Reaktion auf SEAD-Angriffe
- Verlegung mobiler SAMs
- Verstärkung wichtiger Radarstellungen
- Gegenangriffe gegen blaue FOBs nach IADS-Verlust
- Änderung der roten Luftverteidigungspriorität
- Schutz kritischer Basen

IADS-Schäden sollen damit nicht isoliert bleiben.

Sie sollen die gesamte Kampagnenlage beeinflussen.

---

## Verbindung zur Logistik

Das IADS-System kann später auch Logistik beeinflussen.

Geplante Verbindung:

    src/iads/
        ↓
    src/logistics/

Mögliche Zusammenhänge:

- starke IADS-Bedrohung blockiert sichere Helikopterrouten
- zerstörte Radarstellungen öffnen sichere Korridore
- FOB-Aufbau wird erst nach Reduzierung bestimmter Bedrohungen möglich
- rote IADS-Reparatur benötigt Ressourcen
- blaue Logistik kann Luftverteidigungsfenster ausnutzen

Diese Verbindung wird erst später umgesetzt.

Zunächst müssen IADS, Logistik und Capture einzeln stabil funktionieren.

---

## Verbindung zum Capture-System

IADS kann später Capture-Bedingungen beeinflussen.

Geplante Verbindung:

    src/iads/
        ↓
    src/campaign/

Mögliche Zusammenhänge:

- eine Airbase kann erst sicher erobert werden, wenn nahe SAM-Stellungen ausgeschaltet sind
- ein Küsten-Brückenkopf ist erst möglich, wenn ein IADS-Sektor geschwächt wurde
- rote Verteidigung bleibt stärker, solange IADS intakt ist
- zerstörte Luftverteidigung erleichtert CAS- und Logistikmissionen
- IADS-Zustand beeinflusst Kampagnenphase

---

## IADS und Persistenz

IADS-Zustände sollen später persistent gespeichert werden.

Geplante spätere Datei:

    src/campaign/tc_persistence_system.lua

Mögliche persistente Werte:

- aktive IADS-Sektoren
- zerstörte Radare
- zerstörte SAM-Stellungen
- beschädigte Standorte
- wiederhergestellte Standorte
- verbleibende Bedrohungswerte
- SEAD-/DEAD-Erfolge
- Missionshistorie gegen IADS-Ziele

Persistenz wird aber erst gebaut, wenn das IADS-System stabil definiert ist.

---

## Mission-Editor-Anforderungen

Für Skynet IADS werden später Gruppen im Mission Editor benötigt.

Mögliche Gruppen:

- Radargruppen
- SAM-Gruppen
- AAA-Gruppen
- Command-Post-Gruppen
- EWR-Gruppen
- mobile SAM-Gruppen
- statische Ziele

Diese Gruppen sollten sauber benannt werden.

Die spätere Naming-Logik muss mit `NAMING_CONVENTIONS.md` abgestimmt werden.

Mögliche Beispiele:

    IADS_RED_EWR_LATTAKIA_01
    IADS_RED_SAM_SA10_KHMEIMIM_01
    IADS_RED_SAM_SA6_TARTUS_01
    IADS_RED_CP_COASTAL_01

Diese Namen sind vorläufige Beispiele.

Die endgültige Benennung wird später festgelegt.

---

## Debug für IADS

Ein eigenes Debugsystem soll später helfen, den IADS-Zustand sichtbar zu machen.

Geplante Datei:

    src/debug/tc_debug_iads.lua

Mögliche Debug-Ausgaben:

- aktive IADS-Sektoren
- aktive Radarstellungen
- aktive SAM-Stellungen
- zerstörte IADS-Komponenten
- Bedrohungswert je Sektor
- Missionsziele aus IADS-Zustand
- Verbindung zu Skynet IADS
- Fehler beim Initialisieren

Debug darf später über F10-Menüs erreichbar sein.

---

## Testziele

Wenn das IADS-System später erstmals eingebunden wird, sollen folgende Punkte getestet werden:

- MIST lädt korrekt
- Skynet IADS lädt korrekt
- Skynet IADS lädt nach MIST
- `vendor/skynet-iads/SkynetIADS.lua` wird im Mission Editor gefunden
- einfache Skynet-IADS-Objekte können initialisiert werden
- Radargruppen können übergeben werden
- SAM-Gruppen können übergeben werden
- ein einfacher IADS-Sektor kann aktiviert werden
- ein einfacher IADS-Sektor kann deaktiviert werden
- Theater Command erkennt den IADS-Status
- Debug-Ausgabe funktioniert
- `dcs.log` enthält keine Skynet-IADS-Fehler

---

## Nicht jetzt umsetzen

Aktuell noch nicht bauen:

- komplettes syrisches IADS-Netz
- alle SAM-Stellungen der Karte
- vollständige SEAD/DEAD-Kampagnenlogik
- IADS-Persistenz
- automatische IADS-Reparatur
- mobile SAM-Verlegung
- komplexe AI-Director-Reaktionen
- vollständige IADS-Missionsgenerierung

Diese Dinge kommen später schrittweise.

---

## Erste Entwicklungsreihenfolge

Das IADS-System wird nicht als erstes eigenes System gebaut.

Vorher müssen entstehen:

1. `src/`-Unterordner
2. Core-System
3. Airbase-System
4. Zonen-System
5. Capture-System
6. erste Mission-Editor-Testumgebung
7. erste Missionsgenerator-Grundlage
8. IADS-Grundkonfiguration

Grund:

Das IADS-System braucht Airbase-, Zonen-, Missions- und Kampagnenstatus, um strategisch sinnvoll eingebunden zu werden.

---

## Aktueller Status

Aktuell ist nur das externe Skynet-IADS-Framework hinterlegt.

Die eigene Theater-Command-IADS-Logik ist noch nicht begonnen.

Aktueller Stand:

    Skynet IADS vorbereitet
    MIST vorhanden
    Theater-Command-IADS-Logik noch nicht implementiert

Nächster technischer Fokus nach Abschluss der Dokumentationsaktualisierung:

    src-Unterordner und README-Dateien erstellen

Danach:

    src/loader.lua
    src/main.lua
    src/core/tc_config.lua
    src/core/tc_logger.lua
    src/core/tc_state.lua
