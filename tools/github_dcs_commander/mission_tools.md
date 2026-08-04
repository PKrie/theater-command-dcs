# Mission Tools

## Purpose

Mission Tools provide safe inspection capabilities for DCS mission files.

These tools are read-only unless explicitly stated otherwise.

---

## Planned Commands

### inspect_mission

Reads mission metadata and reports:

- map
- coalitions
- countries
- player slots
- mission date
- weather
- bullseye
- briefing

---

### inspect_airbases

Reports:

- all airbases
- owner
- coalition
- parking count
- TACAN
- ILS
- runway

---

### inspect_zones

Reports:

- trigger zones
- capture zones
- FOB zones
- logistics zones
- duplicate names
- invalid names
- missing prefixes

---

### inspect_groups

Reports:

- aircraft groups
- helicopter groups
- ship groups
- ground groups
- static objects

---

### validate_mission

Checks:

- naming conventions
- missing templates
- missing trigger zones
- duplicate IDs
- broken references

---

## Output

Every tool must generate a structured report.

No automatic modifications are allowed.

Inspection always comes before implementation.
