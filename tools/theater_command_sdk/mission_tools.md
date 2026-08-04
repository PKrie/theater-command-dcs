# Mission Tools

Mission Tools provide read-only and validation functionality for DCS missions.

## Current status — 2026-08-04

Existing scripts:

- `scripts/tc-mission-report.ps1`
- `scripts/tc-mission-inspector.ps1`

`tc-mission-inspector.ps1` has been tested successfully. DCS-SMS has also proven Mission Editor trigger inspection, action add/remove with verification, embedded-resource registration/read-back and native Save. These are development operations, not campaign runtime architecture.

Current priority is an offline/read-only audit of the saved DEV `.miz`: compare the 13 source files listed in `TASKS.md` with their embedded script resources and report trigger mapping, resource key, embedded filename, byte length, SHA-256, exact equality, version marker, stale copies, duplicates, unexpected scripts and missing resources. Do not invoke DCS/DCS-SMS and do not modify the `.miz` during that audit.

## Purpose

Mission Tools are intended to inspect and validate mission content before campaign development continues.

Typical tasks include:

- Mission summary
- Airbase inspection
- Group inspection
- Unit inspection
- Trigger inspection
- Trigger zone inspection
- Static object inspection
- Coalition overview

## Rules

Mission Tools should never modify a mission unless explicitly requested.

Validation is always preferred over modification.

## Additional planned scripts

- tc-airbase-report.ps1
- tc-trigger-report.ps1
- tc-group-report.ps1
- tc-zone-report.ps1
- tc-validation-report.ps1
