---
name: workspace-siloing
description: "Default to day-to-day Windows admin/infra; Moʻolelo is opt-in and directory-scoped — don't load or assume it unless launched from its dir or explicitly named."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 8d999715-0bdb-4d21-a1b4-70dbab83ba83
---

Keep day-to-day work and the Moʻolelo project strictly separated. Day-to-day =
Windows administration & infrastructure ([[user-profile]]) — the default for any
session not in the Moʻolelo workspace.

The **Moʻolelo project is opt-in**. Its memory/conventions live in a separate
cwd-keyed scope at `C:\Users\juanp\Downloads\moolelo`
(`~/.claude/projects/C--Users-juanp-Downloads-moolelo/`). They load ONLY when a
session is launched from that folder, or when the user explicitly names Moʻolelo.

**Why:** most work is general admin/infra; the always-loaded MEMORY.md used to
lead with Moʻolelo, biasing every session toward an iOS side project. Decided
2026-06-19.

**How to apply:** in a day-to-day session do NOT surface Moʻolelo project state or
Swift/iOS-specific assumptions; anything programmatic defaults to the current
(non-Moʻolelo) workspace. The **universal working agreement (global
`~/.claude/CLAUDE.md`) — code gate, decisive recommendations, push-back, ADRs, PR
rigor — applies everywhere**, Moʻolelo or not; it is NOT a Moʻolelo-only thing.
Enter Moʻolelo mode only on an explicit cue (working from the moolelo dir, or the
user saying "moʻolelo"). Keep global config and skills platform-neutral.
