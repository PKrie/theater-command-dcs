# Mission Editor Setup

Diese Datei beschreibt, was im DCS Mission Editor für **Theater Command DCS** angelegt werden muss.

Die erste Kampagne trägt den Arbeitstitel:

**Operation Levant Reclamation**

---

## Grundsatz

Der Mission Editor dient nur als Grundlage der DCS-Mission.

Die dynamische Kampagne wird nicht über große Triggerketten im Mission Editor gebaut, sondern durch Lua gesteuert.

Merksatz:

Mission Editor = Bühne  
Lua = Kampagnensystem  
GitHub = Projektgedächtnis  

---

## Was der Mission Editor bereitstellt

Im Mission Editor werden nur die Dinge angelegt, die DCS physisch in der Mission braucht.

Dazu gehören:

- Syria Map
- Koalitionen
- Startzeit
- Wetter
- Spieler-Client-Slots
- Framework-Lade-Trigger
- Template-Gruppen
- wenige Start-CTLD-Zonen
- sichtbare statische Ziele
- optional Carrier-Gruppe

---

## Was nicht im Mission Editor gebaut wird

Nicht im Mission Editor bauen:

- keine Capture-Logik
- keine Triggerketten pro Basis
- keine Logistiklogik pro Basis
- keine 69 Airbase-Zonen
- keine komplette Frontlinie
- keine dynamischen Missionen per Editor-Trigger
- keine Ressourcenlogik
- keine Persistenzlogik
- keine KI-Gegenoffensiven als feste Triggerketten

Diese Systeme werden später durch Lua-Dateien unter `src/` gesteuert.

---

## Grundmission erstellen

Im DCS Mission Editor:

- Map: Syria
- Missionsname: Operation Levant Reclamation DEV
- Startbasis Blau: Akrotiri
- Rotes Gebiet: syrisches Festland
- Startzeit: 08:00 lokal
- Wetter: zunächst einfach und stabil
- Mission speichern als: `Operation_Levant_Reclamation_DEV.miz`

Ablage im Projekt:

`mission/dev/Operation_Levant_Reclamation_DEV.miz`

---

## Koalitionen

### Blau

Empfohlene blaue Länder:

- USA
- UK
- France
- Germany optional
- Canada optional

Blauer Start:

- Akrotiri
- optional Carrier-Gruppe im östlichen Mittelmeer

### Rot

Empfohlene rote Länder:

- Syria
- Russia
- Iran optional, falls verwendet
- Insurgent/Red Force optional, falls benötigt

Roter Start:

- gesamtes syrisches Festland
- Khmeimim als wichtiges rotes Hauptquartier
- Latakia, Tartus, Hama, Homs und Damascus als Kernräume

### Neutral oder gesperrt

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

- CLIENT_BLUE_FA18C_AKROTIRI_01
- CLIENT_BLUE_FA18C_AKROTIRI_02
- CLIENT_BLUE_F16C_AKROTIRI_01
- CLIENT_BLUE_F16C_AKROTIRI_02
- CLIENT_BLUE_F15E_AKROTIRI_01
- CLIENT_BLUE_F15E_AKROTIRI_02
- CLIENT_BLUE_F14B_AKROTIRI_01
- CLIENT_BLUE_F14B_AKROTIRI_02
- CLIENT_BLUE_UH1H_AKROTIRI_01
- CLIENT_BLUE_MI8_AKROTIRI_01

A-10C II und AH-64D werden erst später sinnvoll, wenn ein FOB oder eine Festlandbasis aktiv ist.

Spätere mögliche Slots:

- CLIENT_BLUE_A10C_FOB_ALPHA_01
- CLIENT_BLUE_AH64D_FOB_ALPHA_01
- CLIENT_BLUE_UH1H_FOB_ALPHA_01
- CLIENT_BLUE_MI8_FOB_ALPHA_01

---

## Framework-Lade-Trigger

Die Frameworks werden über Mission-Editor-Trigger geladen.

Empfohlene Lade-Reihenfolge:

1. TIME MORE 1 -> DO SCRIPT FILE -> vendor/mist/mist.lua
2. TIME MORE 2 -> DO SCRIPT FILE -> vendor/moose/Moose.lua
3. TIME MORE 3 -> DO SCRIPT FILE -> vendor/ctld/CTLD-i18n.lua
4. TIME MORE 4 -> DO SCRIPT FILE -> vendor/ctld/CTLD.lua
5. TIME MORE 5 -> DO SCRIPT FILE -> vendor/skynet-iads/SkynetIADS.lua
6. TIME MORE 7 -> DO SCRIPT FILE -> src/loader.lua

Wichtig:

CTLD wird erst nach MIST geladen.

Der eigene Theater-Command-Loader wird erst geladen, nachdem alle externen Frameworks verfügbar sind.

---

## Template-Gruppen

Template-Gruppen werden im Mission Editor angelegt und später per Lua gespawnt.

Alle Template-Gruppen sollen:

- Late Activation: ON
- Hidden on Map: ON

Sie sind keine aktiven Einheiten zum Missionsstart, sondern nur Vorlagen.

---

## Erste rote Template-Gruppen

Empfohlene erste rote Templates:

- TPL_RED_CAP_MIG29_PAIR_01
- TPL_RED_GCI_MIG29_PAIR_01
- TPL_RED_INTERCEPT_MIG29_PAIR_01
- TPL_RED_CAS_SU25_PAIR_01
- TPL_RED_STRIKE_SU24_PAIR_01
- TPL_RED_SAM_SA6_SITE_01
- TPL_RED_SHORAD_SA8_01
- TPL_RED_GARRISON_INF_LIGHT_01
- TPL_RED_GARRISON_INF_HEAVY_01
- TPL_RED_ARMOR_PLATOON_T72_01
- TPL_RED_SUPPLY_CONVOY_01

---

## Erste blaue Template-Gruppen

Empfohlene erste blaue Templates:

- TPL_BLUE_CAP_FA18C_PAIR_01
- TPL_BLUE_CAP_F16C_PAIR_01
- TPL_BLUE_SEAD_FA18C_PAIR_01
- TPL_BLUE_SEAD_F16C_PAIR_01
- TPL_BLUE_STRIKE_F15E_PAIR_01
- TPL_BLUE_CAS_A10C_PAIR_01
- TPL_BLUE_ENGINEER_TEAM_01
- TPL_BLUE_INF_SQUAD_01
- TPL_BLUE_SUPPLY_CONVOY_01

---

## CTLD-Startzonen

Für die erste Version werden nur wenige CTLD-Zonen im Mission Editor angelegt.

Startzonen auf Akrotiri:

- ZONE_BLUE_AKROTIRI_CTLD_PICKUP
- ZONE_BLUE_AKROTIRI_CTLD_TROOP_PICKUP
- ZONE_BLUE_AKROTIRI_CTLD_SUPPLY_PICKUP
- ZONE_BLUE_AKROTIRI_CTLD_VEHICLE_PICKUP

Erste Drop-Zonen:

- ZONE_BLUE_BEACHHEAD_ALPHA_DROP
- ZONE_BLUE_FOB_ALPHA_SITE

Nicht für jede Airbase eigene CTLD-Zonen anlegen.

Später entscheidet das Lua-System, welche eroberte Basis als Logistikhub aktiv ist.

---

## Erste statische Ziele

Statische Ziele werden im Mission Editor angelegt, wenn sie sichtbar, angreifbar und zerstörbar sein sollen.

Erste rote Ziele an der syrischen Küste:

- STATIC_RED_LATAKIA_RADAR_01
- STATIC_RED_LATAKIA_AMMO_DEPOT_01
- STATIC_RED_LATAKIA_FUEL_DEPOT_01
- STATIC_RED_TARTUS_NAVAL_DEPOT_01
- STATIC_RED_TARTUS_RADAR_01
- STATIC_RED_KHMEIMIM_COMMAND_POST_01
- STATIC_RED_KHMEIMIM_FUEL_DEPOT_01
- STATIC_RED_KHMEIMIM_AMMO_DEPOT_01

Mögliche Wirkung im späteren Kampagnensystem:

- Radar zerstört -> IADS schwächer
- Fuel Depot zerstört -> weniger CAP/GCI
- Ammo Depot zerstört -> weniger SAM-Rearm oder Artillerie
- Command Post zerstört -> langsamere Gegenoffensive

---

## Airbases

Airbases werden nicht manuell als einzelne Triggerzonen angelegt.

Das Lua-System soll später:

- alle Airbases automatisch erkennen
- BaseNodes erzeugen
- virtuelle Capture-Zonen erzeugen
- virtuelle Logistik-Zonen erzeugen
- virtuelle Defense-Zonen erzeugen
- Besitzer verwalten
- Ressourcen verwalten

Der Mission Editor muss dafür keine 69 Airbase-Zonen enthalten.

---

## Erste aktive Region

Für die erste Entwicklungsphase werden nur wenige Regionen aktiv bespielt:

- Cyprus Rear Area
- Eastern Mediterranean
- Syrian Coast

Noch nicht aktiv:

- Central Syria
- Northern Syria
- Damascus Sector
- Jordanien
- Israel
- Türkei
- Libanon

Diese Bereiche können später erweitert werden.

---

## Optional: Carrier-Gruppe

Wenn Carrier-Operationen genutzt werden sollen, wird die Carrier-Gruppe im Mission Editor angelegt.

Mögliche Einheiten:

- CVN
- Destroyer Escort
- Cruiser Escort
- Supply Ship optional

Carrier-Spieler-Slots müssen ebenfalls im Mission Editor angelegt werden.

Mögliche Slots:

- CLIENT_BLUE_FA18C_CARRIER_01
- CLIENT_BLUE_FA18C_CARRIER_02
- CLIENT_BLUE_F14B_CARRIER_01
- CLIENT_BLUE_F14B_CARRIER_02

Für die erste Version ist Carrier optional.

---

## Test nach Mission-Editor-Grundlage

Nach dem ersten Mission-Editor-Aufbau prüfen:

- Mission startet
- Spieler kann auf Akrotiri spawnen
- Framework-Trigger werden ausgelöst
- MIST lädt
- MOOSE lädt
- CTLD lädt
- Skynet IADS lädt, falls eingebunden
- src/loader.lua wird geladen
- keine Lua-Fehler in dcs.log
- CTLD-Menü erscheint in Heli-Slots
- Template-Gruppen sind nicht aktiv zum Missionsstart

---

## Arbeitsregel

Im Mission Editor nur das bauen, was physisch vorhanden sein muss.

Alles Dynamische wird später in Lua gebaut.

Keine großen Triggerketten.

Keine manuelle 69-Airbase-Verwaltung.

Keine vollständige Frontlinie im Editor.

Theater Command soll die dynamische Kampagne steuern.