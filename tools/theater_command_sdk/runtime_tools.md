# Runtime Tools

Runtime Tools communicate with a running DCS instance through DCS-SMS.

## Current status — 2026-08-04

Implemented script:

- `scripts/tc-status.ps1`

Use the installed executable at `C:\Tools\dcs-sms\dcs-sms.exe`. Proven commands/workflows include fresh-state checks, mission and GUI `exec`, trigger inspection and verified action manipulation, embedded-resource registration/read-back, native Mission Editor Save, and log tailing.

DCS-SMS remains a development bridge. It must not replace Loader/Main/subsystem architecture or move campaign logic outside `src/`. The current bridge needs `os`, `io` and `lfs` unsanitized; `require` remains sanitized. PersistenceSystem directly needs only `io` and `lfs`.

PersistenceSystem `v0.2.6` has passed hotload failure/retry tests and normal embedded scheduler `SAVED`/`SKIPPED` tests. Productive restore remains disabled. Current MissionGenerator diagnosis is read-only: ten records are initially generated, all six status dictionaries later become empty, and the static result is `PROJECT SOURCE HAS NO MATCHING WRITE SITE`.

## Purpose

These tools provide diagnostics and runtime information without modifying campaign logic.

Typical use cases include:

- Runtime status
- Hook status
- Log inspection
- Airbase ownership
- Unit state
- Group state
- Trigger state
- Event monitoring

## Rules

Runtime tools must remain non-destructive.

They should never modify the running simulation unless explicitly requested.

## Additional planned scripts

- tc-runtime-report.ps1
- tc-log-report.ps1
- tc-event-monitor.ps1
- tc-airbase-runtime.ps1
