---
name: learn-loop
description: >
  Local Capture→Codify loop. Turns a finished session's reusable knowledge into
  durable memory files and draft skills — no cloud, no team, propose-before-write.
  Triggers on "/learn-loop", "learn from this", "what did we learn", "codify
  this", or the SessionStart / PreCompact nudge raised by the learn-loop hooks.
  Composes with lean-mode, trim-mode, and workflow-mode.
---

# Learn Loop

The solo, local answer to a team knowledge layer: instead of every lesson
staying trapped in one session, this codifies it once — to disk, under your
review. Hooks do the cheap **Capture** (mark a session un-codified); this skill
does the **Codify** when you choose to run it. Nothing leaves the machine.

Run-once procedure, not a persistent mode. Invoke it, work through the pass,
done.

## When it runs

- You type `/learn-loop` or say "learn from this / what did we learn / codify this".
- A SessionStart nudge says N prior sessions are un-codified (from the hook queue).
- A PreCompact nudge fires because context is about to be summarized away.

If invoked off a nudge, also pull the queued sessions
(`~/.claude/learn-loop/pending.jsonl`) and use `search_session_transcripts` /
`list_sessions` to recover what they established before codifying.

## The pass

1. **Harvest.** Scan the session(s) for knowledge that outlives them:
   - durable **facts** about the user, their stack, or environment;
   - **corrections / feedback** on how you should work (capture the *why*);
   - **decisions** and project state not derivable from the code or git;
   - **references** (URLs, dashboards, tickets);
   - a **repeatable procedure** you worked out and would re-use.

2. **Filter — the gate.** Drop anything that:
   - only mattered to this one conversation;
   - the repo / git history / CLAUDE.md already records;
   - is a guess rather than something established.
   One-session trivia is not knowledge. When unsure, leave it out.

3. **Classify.**
   - fact / feedback / project / reference → a **memory file** (existing
     frontmatter convention: `name`, `description`, `metadata.type`; feedback
     and project add **Why:** / **How to apply:**).
   - a repeatable procedure → a **draft skill** (`SKILL.md` with frontmatter),
     written to a review location, never auto-installed.

4. **Dedup before writing.** Check `MEMORY.md` and existing memory files. If one
   already covers it, **update that file** — don't create a near-duplicate.
   Delete a memory that this session proved wrong.

5. **Propose.** List every proposed write — path + content — and stop. Write
   **nothing** until the user approves. (Approval model: propose-for-approval.)

6. **On approval, commit to disk.**
   - memory files into the active project's `memory/` dir; add the one-line
     pointer to `MEMORY.md` (`- [Title](file.md) — hook`).
   - skill drafts into a review dir (e.g. `<cwd>/<name>.DRAFT.md`); tell the
     user the install path, don't move it yourself.
   - convert any relative dates to absolute before writing.

7. **Clear the queue.** Empty `~/.claude/learn-loop/pending.jsonl` (or the file
   named by `LEARN_LOOP_DIR`) so the nudge stops. Only after a real pass.

## Boundaries

Propose-before-write, always — no silent memory edits. Codify knowledge, not
chatter. Respect the existing memory conventions and index; this skill feeds
that system, it does not replace it. It reads sessions and writes files — it
never sends anything off the machine.

## The hooks (Capture side)

Three hooks under `hooks/` feed this skill; wire them in `settings.json` at
install (see the install snippet). They are deliberately dumb and LLM-free:

- `session-end.mjs` — on **SessionEnd**, append the session to the pending
  queue. Cheap, runs always.
- `session-start.mjs` — on **SessionStart**, if the queue is non-empty, inject
  a one-line reminder to run `/learn-loop`.
- `pre-compact.mjs` — on **PreCompact**, inject a "codify now before the summary
  eats it" reminder. Best-effort: if your harness build ignores
  `additionalContext` for PreCompact, it degrades to a transcript notice — the
  SessionEnd→SessionStart path still catches the session next time.

Queue location defaults to `~/.claude/learn-loop/`; override with the
`LEARN_LOOP_DIR` env var (used for testing).
