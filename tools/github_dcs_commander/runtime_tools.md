# Runtime Tools

## Purpose

Runtime Tools provide controlled access to a running DCS instance through DCS-SMS.

These tools are intended for diagnostics, validation and testing only.

---

## Planned Commands

### runtime_status

Reports:

- DCS running
- mission loaded
- mission name
- hook version
- GUI bridge status
- simulation state

---

### runtime_logs

Reads recent DCS log entries.

Options:

- last 100 lines
- last 500 lines
- filter by ERROR
- filter by WARNING

---

### runtime_screenshot

Captures the current DCS window.

Output:

- PNG image
- Timestamp
- Active mission

---

### runtime_execute

Executes approved Theater Command diagnostic scripts only.

Examples:

- validate_capture_system
- validate_airbases
- validate_logistics
- validate_fobs
- validate_ai_director

No arbitrary Lua execution.

---

### runtime_report

Creates a complete runtime report including:

- mission state
- active coalition data
- runtime errors
- DCS version
- Theater Command version

---

## Safety Rules

Runtime tools must never:

- modify campaign state
- create units
- destroy units
- change ownership
- alter persistence

Runtime tools are read-only unless explicitly approved by the user.
