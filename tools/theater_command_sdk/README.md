# Theater Command SDK

The Theater Command SDK is the dedicated development toolkit for Theater Command DCS.

## Current status — 2026-08-04

The SDK is development-only and is not a Theater Command runtime framework. Campaign logic remains under `src/`; DCS-SMS drives inspection, Mission Editor automation, controlled Lua execution and log-based smoke tests only.

Implemented scripts:

- `scripts/tc-status.ps1`
- `scripts/tc-mission-report.ps1`
- `scripts/tc-mission-inspector.ps1`

`tc-mission-inspector.ps1` has been executed successfully. The installed DCS-SMS CLI is `C:\Tools\dcs-sms\dcs-sms.exe`; proven capabilities include status, mission and GUI execution, trigger inspection/action manipulation, embedded-resource registration and read-back, native Mission Editor Save, and log reading.

The current DCS-SMS bridge environment requires `os=true`, `io=true` and `lfs=true`; `require=false`. PersistenceSystem itself directly requires only `io` and `lfs` for file persistence.

The next SDK operation is a strictly offline/read-only audit of the 13 expected Theater Command resources embedded in `Operation_Levant_Reclamation_DEV.miz`. It must report trigger/resource mappings, filenames, byte lengths, SHA-256, exact equality, versions, stale/duplicate/unexpected/missing resources, without running DCS/DCS-SMS or changing the `.miz`.

## Purpose

This toolkit provides AI-assisted development tools for:

- Mission inspection
- Mission validation
- Runtime diagnostics
- Log analysis
- Mission Editor automation
- DCS-SMS integration
- Campaign testing
- Development utilities

## Scope

This toolkit is used during development only.

It is never part of the DCS runtime.

It never contains campaign logic.

Campaign logic always remains inside:

```
src/
```

## Planned Modules

- inspect
- validate
- runtime
- logs
- mission-editor
- testing
- export
- reports
- utilities

## Status

Version 0.1

Initial Theater Command SDK structure with three implemented scripts and proven DCS-SMS-assisted workflows. Remaining module names above are planning categories, not claims of existing implementations.
