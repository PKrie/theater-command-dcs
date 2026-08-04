# Theater Command SDK Workflows

Current workflow rules as of 2026-08-04:

- Read `AGENTS.md` and current project documentation before acting.
- Distinguish repository source, embedded `.miz` resources, in-memory Mission Editor state and running mission state.
- Prefer read-only evidence; verify every mutation before removing or replacing prior state.
- DCS-SMS is a development tool only. Runtime campaign logic stays in `src/`.
- Modify only the explicitly approved scope. Commit and push require separate user approval unless the request explicitly authorizes them.
- Productive restore remains disabled; persistence has no F10 controls.

## Workflow 01 — Repository Analysis

Purpose:

Analyze the current Theater Command repository before implementing changes.

Steps:

1. Read AGENTS.md
2. Read project documentation
3. Identify the affected subsystem
4. Review existing implementation
5. Report findings
6. Wait for user approval

---

## Workflow 02 — Mission Inspection

Purpose:

Inspect a mission loaded in the DCS Mission Editor.

Checks:

- Airbases
- Trigger zones
- Groups
- Units
- Triggers
- Mission metadata

For offline embedded-resource audits, do not start DCS or DCS-SMS. Read the saved `.miz` as a container, map triggers to Resource Keys, compare embedded bytes to repository sources, and report hashes, versions, stale/duplicate/unexpected/missing resources without modifying the mission.

---

## Workflow 03 — Runtime Diagnostics

Purpose:

Inspect a running DCS instance.

Checks:

- Runtime status
- DCS-SMS hook
- DCS log
- Runtime errors

---

## Workflow 04 — Development

Purpose:

Safely implement a single change.

Steps:

1. Analyze
2. Plan
3. Modify one file
4. Test locally
5. Review
6. Request or confirm approval to commit
7. Commit only the approved files
8. Request or confirm separate approval to push
9. Push only after approval

---

## Workflow 05 — Release

Purpose:

Prepare a stable project state.

Steps:

1. Validate
2. Test
3. Review documentation
4. Obtain commit approval
5. Commit the approved scope
6. Obtain push approval
7. Push
