---
name: custom-agent-skills
description: "User's home-built Claude Code skills — economy modes, workflow-mode, learn-loop — and how they compose."
metadata: 
  node_type: memory
  type: project
  originSessionId: 3171ece4-aaf2-43fb-9eeb-39e6a4c0da10
---

User has authored custom skills under `~/.claude/skills/`:
- **lean-mode** / **trim-mode** (Anthropic-bundled) — economy: write/read less,
  emit fewer tokens.
- **workflow-mode** — lifecycle discipline (brainstorm → ADR → plan-file → TDD
  → verify). Governs *order*; composes with lean/trim's *volume*. Auto-triggers
  on "build this feature" phrasing.
- **learn-loop** — local Capture→Codify: SessionEnd/SessionStart/PreCompact
  hooks queue sessions and nudge; the skill proposes memory/skill writes for
  approval. The solo, no-cloud answer to a team knowledge layer.

**Why:** Built in place of adopting superpowers (→ workflow-mode) and hivemind
(→ learn-loop). Rationale in [[tooling-adoption-approach]].

**How to apply:** These exist — reuse/extend them, don't re-derive. learn-loop
hooks need `node` (v22 at `~/AppData/Local/hermes/node`). Skill content is
self-documenting; this memo just flags their existence for future sessions.
