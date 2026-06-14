# Mission Editor Basics

Diese Datei beschreibt die grundlegenden Mission-Editor-Arbeiten für Theater Command DCS.

Sie ergänzt die Datei MISSION_EDITOR_SETUP.md im Hauptverzeichnis.

---

## Ziel

Der DCS Mission Editor soll nur die technische und physische Grundlage der Mission bereitstellen.

Die dynamische Kampagne selbst wird später durch Lua gesteuert.

Der Mission Editor ist nicht dafür gedacht, die gesamte Kampagnenlogik über Triggerketten abzubilden.

---

## Grundsatz

Mission Editor = Bühne

Lua = Kampagnensystem

GitHub = Projektgedächtnis

Der Mission Editor enthält nur das, was DCS als echte Missionseinheiten, Slots, Zonen, Templates oder Trigger-Dateien braucht.

Alles Dynamische wird später über Lua-Dateien im Ordner src gesteuert.

---

## Was im Mission Editor gebaut wird

Im Mission Editor werden angelegt:

- Syria Map
- Koalitionen
- Startzeit
- Wetter
- Spieler-Slots
- Framework-Lade-Trigger
- Template-Gruppen
- wenige CTLD-Startzonen
- sichtbare statische Ziele
- optionale Carrier-Gruppe
- erste Testeinheiten

---

## Was nicht im Mission Editor gebaut wird

Nicht im Mission Editor bauen:

- keine vollständige Kampagnenlogik
- keine große Triggerkette für jede Basis
- keine Capture-Trigger pro Airbase
- keine manuelle 69-Airbase-Verwaltung
- keine dynamische Missionsauswahl per Trigger
- keine Ressourcenlogik per Trigger
- keine Persistenzlogik per Trigger
- keine komplette Frontlinie als statisches Konstrukt

Diese Dinge werden später durch Lua übernommen.

---

## Erste Grundmission

Die erste Entwicklungsmission soll eine einfache Testumgebung sein.

Name:

Operation Levant Reclamation DEV

Dateiname:

Operation_Levant_Reclamation_DEV.miz

Speicherort im Projekt:

mission/dev/Operation_Levant_Reclamation_DEV.miz

---

## Map

Verwendete Map:

Syria

Die erste aktive Operationsregion umfasst:

- Cyprus
- Eastern Mediterranean
- Syrian Coast

Noch nicht aktiv:

- Central Syria
- Northern Syria
- Damascus Sector
- Lebanon Sector
- Jordan Sector
- Israel Sector
- Turkey Sector

Diese Regionen werden später erweitert.

---

## Startbasis Blau

Die erste blaue Startbasis ist:

Akrotiri

Akrotiri dient am Anfang als:

- Spielerbasis
- Logistikhub
- Startpunkt für CAP
- Startpunkt für SEAD
- Startpunkt für Strike
- Startpunkt für Transportflüge
- technischer Testbereich

---

## Roter Ausgangsraum

Das syrische Festland gilt zu Beginn als vollständig rot kontrolliert.

Wichtige rote Räume für die erste Version:

- Latakia
- Tartus
- Khmeimim
- Syrian Coast

Weitere rote Räume werden später ergänzt.

---

## Koalitionen

### Blau

Empfohlene blaue Länder:

- USA
- UK
- France
- Germany optional
- Canada optional

### Rot

Empfohlene rote Länder:

- Syria
- Russia
- Iran optional
- Insurgent optional

### Neutral oder zunächst nicht aktiv

- Turkey
- Israel
- Jordan
- Lebanon

Diese Länder können später je nach Kampagnendesign eingebunden werden.

---

## Spieler-Slots

Spieler-Slots müssen im Mission Editor angelegt werden.

Für die erste Entwicklungsphase werden nur Slots auf Akrotiri angelegt.

Erste empfohlene Slots:

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

---

## Spätere Spieler-Slots

A-10C II und AH-64D werden später sinnvoll, wenn ein FOB oder eine Festlandbasis aktiv ist.

Beispiele:

CLIENT_BLUE_A10C_FOB_ALPHA_01
CLIENT_BLUE_AH64D_FOB_ALPHA_01
CLIENT_BLUE_UH1H_FOB_ALPHA_01
CLIENT_BLUE_MI8_FOB_ALPHA_01

---

## Skill-Einstellung

Für Spielerflugzeuge:

Skill = Client

Für KI-Templates:

Skill nach Bedarf

Wichtig:

Template-Gruppen dürfen nicht aktiv zum Missionsstart erscheinen.

---

## Template-Gruppen

Template-Gruppen sind vorbereitete Gruppen, die später per Lua gespawnt werden.

Alle Template-Gruppen sollen:

- Late Activation aktiviert haben
- Hidden on Map aktiviert haben
- klar benannt sein
- nicht direkt in die laufende Mission eingreifen

---

## Erste rote Templates

Empfohlene erste rote Template-Gruppen:

TPL_RED_CAP_MIG29_PAIR_01
TPL_RED_GCI_MIG29_PAIR_01
TPL_RED_INTERCEPT_MIG29_PAIR_01
TPL_RED_CAS_SU25_PAIR_01
TPL_RED_STRIKE_SU24_PAIR_01
TPL_RED_SAM_SA6_SITE_01
TPL_RED_SHORAD_SA8_01
TPL_RED_GARRISON_INF_LIGHT_01
TPL_RED_GARRISON_INF_HEAVY_01
TPL_RED_ARMOR_PLATOON_T72_01
TPL_RED_SUPPLY_CONVOY_01

---

## Erste blaue Templates

Empfohlene erste blaue Template-Gruppen:

TPL_BLUE_CAP_FA18C_PAIR_01
TPL_BLUE_CAP_F16C_PAIR_01
TPL_BLUE_SEAD_FA18C_PAIR_01
TPL_BLUE_SEAD_F16C_PAIR_01
TPL_BLUE_STRIKE_F15E_PAIR_01
TPL_BLUE_CAS_A10C_PAIR_01
TPL_BLUE_ENGINEER_TEAM_01
TPL_BLUE_INF_SQUAD_01
TPL_BLUE_SUPPLY_CONVOY_01

---

## Trigger für Frameworks

Die Frameworks werden im Mission Editor über Trigger geladen.

Empfohlene Reihenfolge:

TIME MORE 1 -> DO SCRIPT FILE -> vendor/mist/mist.lua
TIME MORE 2 -> DO SCRIPT FILE -> vendor/moose/Moose.lua
TIME MORE 3 -> DO SCRIPT FILE -> vendor/ctld/CTLD-i18n.lua
TIME MORE 4 -> DO SCRIPT FILE -> vendor/ctld/CTLD.lua
TIME MORE 5 -> DO SCRIPT FILE -> vendor/skynet-iads/SkynetIADS.lua
TIME MORE 7 -> DO SCRIPT FILE -> src/loader.lua

Wichtig:

MIST wird vor CTLD geladen.

Der eigene Loader wird erst nach den externen Frameworks geladen.

---

## CTLD-Zonen

Für die erste Version werden nur wenige CTLD-Zonen im Mission Editor angelegt.

Startzonen auf Akrotiri:

ZONE_BLUE_AKROTIRI_CTLD_PICKUP
ZONE_BLUE_AKROTIRI_CTLD_TROOP_PICKUP
ZONE_BLUE_AKROTIRI_CTLD_SUPPLY_PICKUP
ZONE_BLUE_AKROTIRI_CTLD_VEHICLE_PICKUP

Erste mögliche Drop-Zonen:

ZONE_BLUE_BEACHHEAD_ALPHA_DROP
ZONE_BLUE_FOB_ALPHA_SITE

Nicht jede Airbase bekommt eine eigene CTLD-Zone.

Später entscheidet Theater Command per Lua, welche Basis als Logistikhub aktiv ist.

---

## Statische Ziele

Statische Ziele werden nur dann im Mission Editor angelegt, wenn sie sichtbar, angreifbar und zerstörbar sein sollen.

Erste mögliche Ziele:

STATIC_RED_LATAKIA_RADAR_01
STATIC_RED_LATAKIA_AMMO_DEPOT_01
STATIC_RED_LATAKIA_FUEL_DEPOT_01
STATIC_RED_TARTUS_NAVAL_DEPOT_01
STATIC_RED_TARTUS_RADAR_01
STATIC_RED_KHMEIMIM_COMMAND_POST_01
STATIC_RED_KHMEIMIM_FUEL_DEPOT_01
STATIC_RED_KHMEIMIM_AMMO_DEPOT_01

Diese Ziele können später durch Lua mit strategischer Bedeutung versehen werden.

---

## Airbases

Airbases werden nicht manuell als Triggerzonen angelegt.

Das spätere Lua-System soll:

- Airbases automatisch erkennen
- Airbases registrieren
- virtuelle Capture-Zonen erzeugen
- virtuelle Logistik-Zonen erzeugen
- virtuelle Defense-Zonen erzeugen
- Besitzstände verwalten
- Ressourcen verwalten

---

## Native DCS Auto Capture

Die native DCS-Airbase-Auto-Capture-Logik soll später möglichst deaktiviert oder kontrolliert werden.

Theater Command soll selbst entscheiden, wann eine Basis den Besitzer wechselt.

Ziel:

DCS stellt die Airbase bereit.

Theater Command verwaltet den strategischen Besitz.

---

## Wetter

Für die erste Entwicklungsphase soll das Wetter einfach bleiben.

Empfehlung:

- klare Sicht
- wenig Wind
- keine schweren Wolken
- keine starken Turbulenzen
- keine komplexen Nachtbedingungen

Komplexes Wetter kommt erst später.

---

## Startzeit

Empfohlene Startzeit:

08:00 lokal

Grund:

- gute Sicht
- einfache Tests
- keine Nachtflugprobleme
- gute Debug-Bedingungen

---

## Carrier optional

Eine Carrier-Gruppe ist für die erste Version optional.

Wenn sie eingebaut wird, sollten mögliche Slots sein:

CLIENT_BLUE_FA18C_CARRIER_01
CLIENT_BLUE_FA18C_CARRIER_02
CLIENT_BLUE_F14B_CARRIER_01
CLIENT_BLUE_F14B_CARRIER_02

Für die erste Entwicklungsphase reicht Akrotiri als Startbasis aus.

---

## Erste Testziele

Für frühe Tests reichen wenige Ziele.

Beispiele:

- eine rote CAP-Template-Gruppe
- eine rote SAM-Template-Gruppe
- ein statisches Radar
- ein statisches Fuel Depot
- eine CTLD-Pickup-Zone
- ein Heli-Client-Slot
- ein Jet-Client-Slot

Nicht direkt die ganze Map füllen.

---

## Test nach dem Aufbau

Nach dem ersten Mission-Editor-Aufbau prüfen:

- Mission startet ohne Fehler
- Spieler kann auf Akrotiri spawnen
- Slots sind sichtbar
- Template-Gruppen sind nicht aktiv
- Trigger werden ausgelöst
- Frameworks laden
- CTLD-Menü erscheint bei Heli-Slots
- loader.lua wird geladen
- keine Fehlermeldungen in dcs.log

---

## Entwicklungsregel

Immer nur so viel im Mission Editor bauen, wie für den nächsten Test notwendig ist.

Nicht die ganze Kampagne im Editor vorbereiten.

Erst eine kleine stabile Testbasis.

Dann Schritt für Schritt erweitern.

---

## Ziel

Der Mission Editor soll sauber, übersichtlich und wartbar bleiben.

Die eigentliche Stärke von Theater Command DCS entsteht später durch die Lua-Systeme.

Der Mission Editor bleibt die Bühne.

Lua führt die Kampagne.
