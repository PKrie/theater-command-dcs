# AGENTS.md

# Theater Command DCS - AI Development Instructions

This document is the primary instruction set for AI development agents (Codex, ChatGPT, Claude Code and future agents).

If this file conflicts with older documentation, always follow the project documentation referenced below. Never invent architecture.

---

# 1. Project Goal

Theater Command DCS is a modular, dynamic and later persistent campaign framework for DCS World.

Mission Editor is only used to create the stage.

Lua contains the campaign logic.

GitHub is the project memory.

The long-term objective is a living battlefield where the player is only one participant inside a much larger autonomous military system.

---

# 2. Development Philosophy

Always prefer:

Correct architecture

over

Fast implementation.

Every implementation must fit into the long-term architecture.

Never implement shortcuts that create technical debt.

---

# 3. Required Reading

Before making any implementation, always read the current project documentation.

Minimum required:

README.md

ROADMAP.md

TASKS.md

ARCHITECTURE.md

MISSION_EDITOR_SETUP.md

NAMING_CONVENTIONS.md

LUA_STYLEGUIDE.md

Relevant documentation inside docs/

Relevant README inside src/

Never assume documentation from memory.

---

# 4. Repository Structure

Vendor frameworks remain completely untouched.

```
vendor/
    mist/
    moose/
    ctld/
    skynet-iads/
```

Own logic belongs into:

```
src/
```

Never modify vendor code.

Never copy vendor code.

Never fork vendor code.

---

# 5. Lua Architecture

Mission Editor

↓

Loader

↓

Main

↓

Subsystems

Subsystems communicate through shared campaign state.

Subsystems should not directly manipulate each other whenever possible.

Prefer event driven architecture.

---

# 6. One Task Rule

One task.

One file.

One commit.

Never redesign multiple systems simultaneously.

---

# 7. File Creation Rules

Whenever creating a file:

Provide

Exact path

Complete file

No partial snippets

No "... continue ..."

No missing sections

Ready for copy & paste.

---

# 8. Vendor Rules

Allowed:

Using MOOSE

Using MIST

Using CTLD

Using Skynet

Reading vendor documentation

Forbidden:

Editing vendor framework

Renaming vendor framework

Moving vendor framework

Creating wrapper copies

---

# 9. Naming Rules

Follow:

MISSION_EDITOR_SETUP.md

NAMING_CONVENTIONS.md

Never invent new naming schemes.

---

# 10. Mission Editor Philosophy

Mission Editor is NOT campaign logic.

Mission Editor defines:

terrain

zones

airbases

statics

templates

clients

initial placement

Campaign logic belongs into Lua.

---

# 11. DCS-SMS

DCS-SMS is a development tool.

It is NOT part of runtime architecture.

Allowed:

Mission inspection

Mission Editor automation

Lua execution

Smoke testing

Reading logs

Prefab management

Not allowed:

Replacing campaign architecture

Replacing vendor frameworks

Moving campaign logic into DCS-SMS

---

# 12. Codex Behaviour

Always:

Analyse first

Explain reasoning

Modify one file

Show result

Wait for confirmation

Never silently modify multiple files.

---

# 13. Git Rules

Before modifications:

Check project state.

After modifications:

Review changes.

Never commit automatically.

Never push automatically.

Wait for user approval.

---

# 14. Documentation Rules

Architecture changes require documentation updates.

Feature changes require ROADMAP/TASKS verification.

Never allow documentation to drift away from implementation.

---

# 15. Testing Rules

After implementation verify:

Lua syntax

Initialization

Runtime

Mission loading

Log output

Never assume code works.

---

# 16. Logging

Prefer structured logging.

Meaningful prefixes.

Useful diagnostics.

Avoid spam.

---

# 17. Performance

Avoid:

Long polling

Large loops

Repeated expensive searches

Prefer:

Cached data

Incremental updates

Events

---

# 18. Persistence

Persistence runs automatically.

Never require player interaction.

Persistence must survive mission restart.

---

# 19. Future Architecture

Long-term systems include:

Dynamic AI Commander

Strategic AI

Mission Generator

Carrier Operations

Ground Warfare

Persistent Logistics

FOB Network

IADS

Supply Chains

CAS Requests

Air Tasking Orders

Player Mission Assignment

Everything must remain modular.

---

# 20. AI Behaviour Expectations

The AI agent is a software engineer.

Not merely a code generator.

Responsibilities:

Understand architecture.

Protect architecture.

Reject bad shortcuts.

Keep documentation synchronized.

Prefer maintainability.

---

# 21. Forbidden Actions

Never modify vendor framework.

Never invent undocumented architecture.

Never merge unrelated changes.

Never remove documentation.

Never replace modular systems with monolithic files.

Never create:

tc_all_in_one.lua

tc_moose.lua

tc_mist.lua

tc_ctld.lua

---

# 22. Preferred Development Flow

Read documentation

↓

Understand architecture

↓

Implement one change

↓

Review

↓

Test

↓

Update documentation

↓

Commit

↓

Continue

---

# 23. Definition of Done

A task is complete when:

Implementation finished

Architecture respected

Documentation updated

Testing completed

Logs verified

User approved

Commit prepared

---

# 24. Final Principle

Protect the long-term architecture.

Every decision should improve maintainability.

Every implementation should move Theater Command closer to becoming a complete autonomous campaign engine rather than solving only today's task.
