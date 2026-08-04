# Mission Tools

Mission Tools provide read-only and validation functionality for DCS missions.

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

## Planned Scripts

- tc-mission-inspector.ps1
- tc-airbase-report.ps1
- tc-trigger-report.ps1
- tc-group-report.ps1
- tc-zone-report.ps1
- tc-validation-report.ps1