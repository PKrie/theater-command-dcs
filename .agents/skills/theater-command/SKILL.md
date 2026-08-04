# Theater Command Skill

This skill contains project-specific knowledge for AI development agents working on Theater Command DCS.

The AGENTS.md file contains the global development rules.

This skill contains Theater Command specific implementation knowledge.

---

# Project Purpose

Theater Command DCS is a modular, dynamic and later persistent campaign framework for DCS World.

Mission Editor is only the stage.

Lua contains the complete campaign logic.

The player is only one participant inside an autonomous military simulation.

---

# Architecture

Always respect this architecture.

Mission Editor

↓

loader.lua

↓

main.lua

↓

Subsystems

Subsystems own their responsibilities.

Avoid tightly coupled systems.

Prefer event-driven communication.

Never introduce hidden dependencies.

---

# Runtime Philosophy

Campaign state is the single source of truth.

Subsystems update the campaign state.

Other subsystems react to campaign state.

Never duplicate state information.

---

# Repository Philosophy

vendor/

contains external frameworks.

Never modify them.

src/

contains all own Lua code.

Documentation belongs inside docs/.

---

# Vendor Frameworks

Current vendor frameworks:

- MIST
- MOOSE
- CTLD
- Skynet IADS

These frameworks are infrastructure.

Theater Command is the orchestration layer above them.

Never replace them.

Never modify them.

---

# DCS-SMS

DCS-SMS is a development tool.

It is never part of campaign runtime.

Allowed:

- Mission inspection
- Runtime inspection
- Mission Editor automation
- Smoke tests
- Lua execution
- Prefab creation

Not allowed:

- Campaign logic
- State management
- Persistence
- Mission generation

Those always belong into Theater Command.

---

# Mission Editor

Mission Editor defines:

- terrain
- client slots
- zones
- statics
- templates
- initial placement

Mission Editor never contains campaign behaviour.

---

# Current Development Priorities

Current priorities are:

1. Stable architecture

2. Campaign state

3. Runtime systems

4. Event pipeline

5. Mission generation

6. AI Director

7. Logistics

8. Persistence

9. Carrier Operations

Never skip directly to advanced features while foundations are incomplete.

---

# Coding Principles

Always prefer:

small modules

clear responsibilities

good naming

low coupling

high readability

Never create monolithic implementations.

---

# Working Method

Before implementing:

Read documentation.

Understand architecture.

Identify affected subsystem.

Implement one file.

Review.

Test.

Wait for user approval.

---

# Documentation

Whenever architecture changes:

Verify whether these documents require updates:

README.md

ROADMAP.md

TASKS.md

ARCHITECTURE.md

docs/

Never let implementation and documentation diverge.

---

# Final Principle

Protect the architecture first.

Everything else is secondary.
