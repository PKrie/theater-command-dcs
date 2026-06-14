# Vendor Frameworks

Dieser Ordner ist für externe Frameworks vorgesehen, die Theater Command DCS nutzt.

Die Frameworks werden nicht selbst entwickelt und nicht verändert.

Sie dienen nur als Bibliotheken für die eigene Theater-Command-Logik.

---

## Geplante Frameworks

Theater Command DCS soll folgende Frameworks nutzen:

- MOOSE
- MIST
- CTLD
- Skynet IADS

---

## Grundsatz

Die Frameworks liegen unter `vendor/`.

Die eigene Projektlogik liegt unter `src/`.

Nicht die Frameworks bilden die Architektur.

Die eigene Theater-Command-Struktur bildet die Architektur.

---

## Ordnerstruktur

Geplante Struktur:

vendor/mist/
vendor/moose/
vendor/ctld/
vendor/skynet-iads/

---

## MIST

MIST wird genutzt für:

- Hilfsfunktionen
- DCS-Datenbankfunktionen
- Gruppenlogik
- Koordinatenlogik
- CTLD-Grundvoraussetzung

Geplanter Pfad:

vendor/mist/mist.lua

---

## MOOSE

MOOSE wird genutzt für:

- Wrapper
- Scheduler
- SETs
- Spawning
- CAP/GCI
- AI-Management
- Zonenlogik

Geplanter Pfad:

vendor/moose/Moose.lua

---

## CTLD

CTLD wird genutzt für:

- Truppentransport
- Kistentransport
- Logistik
- FOB-Aufbau
- Heli-Interaktion

Geplante Pfade:

vendor/ctld/CTLD.lua
vendor/ctld/CTLD-i18n.lua

---

## Skynet IADS

Skynet IADS wird genutzt für:

- IADS-Netzwerke
- Radarlogik
- SAM-Verhalten
- Luftverteidigungssektoren
- SEAD/DEAD-Reaktionen

Geplanter Pfad:

vendor/skynet-iads/SkynetIADS.lua

---

## Wichtige Regel

Dateien in `vendor/` werden grundsätzlich nicht verändert.

Wenn Theater Command eigenes Verhalten braucht, wird dieses Verhalten unter `src/` programmiert.

Beispiel:

Nicht CTLD verändern.

Stattdessen eigene Datei verwenden:

src/logistics/tc_logistics_delivery.lua

---

## Lade-Reihenfolge

Die externen Frameworks werden im Mission Editor vor Theater Command geladen.

Geplante Reihenfolge:

1. MIST
2. MOOSE
3. CTLD-i18n
4. CTLD
5. Skynet IADS
6. src/loader.lua

---

## Hinweis

Die Framework-Dateien selbst werden später manuell ergänzt.

Diese README dient zunächst nur dazu, den Zweck des Ordners zu dokumentieren.