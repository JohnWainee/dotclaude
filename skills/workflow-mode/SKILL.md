---
name: workflow-mode
description: >
  Lifecycle discipline for building a feature: design-first, plan-as-files,
  test-driven, verify-before-done. Auto-triggers on feature-build phrasing —
  "build this feature", "build/add/implement X", "let's design Y", "ship a Z"
  — when the change is non-trivial, and on explicit "workflow mode". Composes
  with lean-mode and trim-mode. NOT for one-line edits, quick questions, or
  pure refactors — those skip straight to the work.
---

# Workflow Mode

A solo developer's build discipline. Borrows the useful half of heavyweight
agent frameworks — design-first, plans on disk, TDD, a real verification gate
— and drops the expensive half (subagent fan-out, per-task worktrees,
dual-stage review). One developer, one branch, one review gate.

Two rules govern everything: **decide on disk before you build**, and
**nothing is done until something runnable proves it.**

## Persistence

ACTIVE EVERY RESPONSE once triggered, through to the verification gate. No
drift back to code-first. Off on "stop workflow mode" / "normal mode", or
when the feature ships. Composes with lean-mode (write/read less) and
trim-mode (emit less) — run all three together; this one governs *order*,
they govern *volume*.

## When NOT to use it

Skip straight to the work for: one-line edits, typo/rename/format, answering
a question, a refactor with no behavior change, anything the user calls
"quick". Workflow mode is for net-new behavior with more than one moving
part. Ladder check (lean-mode rung 1) still runs first: if the feature
shouldn't exist, say so before planning it.

---

# The pipeline

Five stages. Stop at the gate between each — don't run ahead.

## 1. Brainstorm (design-first)

Before any code, refine the request into a design.

- Ask only the questions whose answers change the design. One batch, not a
  drip. Default the rest and say what you defaulted.
- Present the design in digestible pieces, not a wall. Recommend a direction
  — decisively — and give the reason. Push back on the request if a simpler
  or sounder shape exists (lean-mode ladder applies to architecture too).
- Surface the one or two decisions that are expensive to reverse. Those are
  the ADR candidates.

Gate: user agrees on the shape, or picks among the options you posed.

## 2. Record the decision (ADR on disk)

If the design locked a non-obvious, hard-to-reverse choice → write an ADR
file before building, matching the project's existing ADR style and
location. One file, one decision, the alternatives considered, and why.
Trivial choices need no ADR — YAGNI applies to documentation too.

Gate: the decision is on disk, not just in chat.

## 3. Write the plan (as a file, small tasks)

Break the work into a plan file of 2–5 minute tasks. Each task names:

- the file(s) it touches,
- the observable outcome (what passes that didn't before),
- its test.

Plan lives on disk next to the ADRs, not in the conversation — it survives a
context reset and is the source of truth for "what's left". Keep it flat:
one developer, one branch. No worktrees, no parallel-agent dispatch — that
machinery costs more tokens than it saves at solo scale.

Gate: plan file exists and the user has seen the task list.

## 4. Build test-first (RED → GREEN → REFACTOR)

Per task, in order:

1. **RED** — write the smallest failing test for the task's outcome. Run it,
   see it fail for the right reason.
2. **GREEN** — minimum code to pass (lean-mode's ladder governs *what* you
   write). Run it, see it pass.
3. **REFACTOR** — only if there's real duplication or a named smell. Tests
   stay green. Skip if nothing's wrong.

Stuck on a failure? Switch to systematic debugging: reproduce minimally,
form one hypothesis, test that hypothesis, fix root cause — not symptoms. No
shotgun edits.

Trivial one-liners need no test (lean-mode rule). Everything with a branch, a
loop, a parser, or a money/security path leaves one runnable check behind.

**Spike escape hatch.** Exploratory work — "I don't know if this is even
possible", "let me try X", a throwaway proof-of-concept — suspends TDD. Build
fast and messy to learn the answer, no tests, no plan tasks. The moment the
spike answers its question, it is **thrown away, not promoted**: re-enter at
stage 1 (or 3 if the design already holds) and rebuild test-first. Mark spike
code as such so it never ships by accident (`spike:` comment, scratch file, or
a branch you delete). A spike that quietly becomes the implementation is the
failure this hatch exists to prevent.

## 5. Verify before done (the gate)

Nothing ships until you've *run the real thing* and observed it — not just
the unit tests. Launch the app / hit the endpoint / exercise the flow and
confirm the outcome the plan promised. If the project has a `/run` or `verify`
skill, that's the harness; use it.

Then a single review pass over the diff: correctness, security, and the
over-engineering hunt (hand that one to lean-mode's review mode). One gate,
not two stages — you're the only reviewer.

Gate: real-thing verified + diff reviewed. Only now is the feature done.
State it plainly, with what you ran. If a stage was skipped, say which.

---

## Respect the project's gate

If the project has a human code-review / merge gate, workflow mode stops at
"ready for review" — it does not merge, push, or close the branch on its own
unless told to. Surface the diff and the verification evidence; let the gate
do its job.

## Boundaries

Workflow mode governs *order of operations*, not tone or token volume — those
are trim-mode and lean-mode. "stop workflow mode" / "normal mode": revert to
ad-hoc. The pipeline is a reflex for non-trivial features, not a ceremony to
perform on every edit.

Design on disk, prove it runs, then it's done.
