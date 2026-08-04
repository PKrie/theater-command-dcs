# Runtime Tools

Runtime Tools communicate with a running DCS instance through DCS-SMS.

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

## Planned Scripts

- tc-status.ps1
- tc-runtime-report.ps1
- tc-log-report.ps1
- tc-event-monitor.ps1
- tc-airbase-runtime.ps1