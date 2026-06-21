# ADR-001: Augment existing code review with an adversarial, language-agnostic checklist

**Status:** Accepted — shipped on branch `feat/adversarial-review-checklist`
**Date:** 2026-06-21
**Owner:** juanp
**Trigger:** Review of `awesome-skills/code-review-skill` for adoption into local tooling.

---

## Summary (TL;DR)

The external repo `awesome-skills/code-review-skill` is a 16k-line, 20-language,
*collaborative* review framework. We already own **stronger, more adversarial**
reviewers (built-in `/code-review`, the marketplace multi-agent PR reviewer,
`/security-review`). The only parts worth taking are the **universal anti-pattern
catalog** and a **severity taxonomy** — and both were rewritten in an
adversarial ("guilty until proven innocent") voice. We did **not** add a
parallel skill and did **not** import any per-language guides (the repo covers
none of our actual stack). Deliverable: one loadable reference file,
`references/adversarial-review-checklist.md`, plus an owned `/review-pr` command
that wires the checklist into the multi-agent reviewer.

---

## Context

- Day-to-day work is **Windows administration & infrastructure** (PowerShell,
  scripts, IaC, config). Cost-sensitive; lean tooling preferred.
- Existing review capability already in place:
  - **Built-in `/code-review`** — diff-focused, effort-tiered (low→max),
    confidence-gated, `--comment` / `--fix`.
  - **Marketplace multi-agent PR reviewer** — 5 parallel Sonnet finders +
    Haiku confidence scoring (0–100), discards anything <80, explicit
    false-positive rubric, posts via `gh`.
  - **`/security-review`**, **`/simplify`**, **`/verify`**.
  - Custom: `workflow-mode` (verify-before-done), `ship-issue` (self-review
    step), `lean-mode`, `trim-mode`.

### Adversarial assessment of the external repo

1. **Wrong philosophy.** Its stated goal is "transform code review *from
   gatekeeping to knowledge sharing*" — soft language, "suggest don't command,"
   mandatory praise, "ask questions instead of stating problems." This is the
   opposite of the requested adversarial posture. The *substance* is mineable;
   the *voice* is not.
2. **Headline value doesn't fit the stack.** Its 20 language guides
   (React/Vue/Angular/Swift/Kotlin/Rust/…) contain **no PowerShell, Bash,
   Terraform/IaC, SQL, Ansible/YAML, or anything Windows.** The biggest thing
   the repo sells is unusable here.
3. **We already out-rigor it.** Our marketplace reviewer's 0–100 confidence
   gate + false-positive rubric is a harder filter than anything in the repo.
4. **Provenance / bloat.** Mixed Chinese/English source, "16,000 lines of
   curated guidelines" is a quantity claim, not a verified-quality one.
   Importing it wholesale = standing context bloat against a cost-sensitive
   setup.

### Transferable residue (what was actually taken)

- **Universal Quality anti-pattern catalog:** reuse audit, parameter sprawl,
  leaky abstractions, nested conditionals, stringly-typed code, TOCTOU, no-op
  updates, redundant state.
- **Severity taxonomy** (blocking / important / nit / design) — praise/learning
  markers dropped as incompatible with adversarial posture.
- **Phased method idea** (context → high-level → line-by-line → decision) —
  compressed into the checklist header; our reviewers already do most of this.

---

## Decision

1. **Augment, did not add a parallel skill.** A single loadable reference,
   `references/adversarial-review-checklist.md`, consumed on demand.
2. **Adversarial voice = guilty until proven innocent.** Every finding is a
   claim the author must defend; default-to-refute; confidence-gated; no praise
   theater; no "have you considered" hedging.
3. **Language-agnostic only.** No per-language guides imported or authored here.
   (PowerShell/IaC checklists tracked in ADR-002.)
4. **Authored original content.** Mined the *idea set* from the repo; wrote the
   text fresh to avoid the repo's tone and mixed-language provenance.

### Install mechanism (options + tradeoffs)

| Option | How it wires in | Cost | Risk | Verdict |
|---|---|---|---|---|
| **A. Manual reference (chosen for `/code-review`)** | File in `dotclaude`; invoke `/code-review` then "apply `@adversarial-review-checklist.md`". | ~0 standing context | Relies on remembering to attach it | **Chosen** |
| B. Global CLAUDE.md pointer | Add a line so every session is reminded | Standing cost on *every* session | Bloats unrelated work | Rejected — anti-lean |
| C. New slash command/skill | Wrap the checklist in a skill | Low | Violates "no parallel skill" | Rejected |
| D. Owned `/review-pr` command (chosen for multi-agent) | Vendor the marketplace reviewer prompt into `dotclaude`, bake in the checklist | Low | Drift from upstream prompt | **Chosen** |

**Resolution of earlier open questions:**
- *Install location* → `references/` (bootstrap extended to deploy it).
- *Reference from the multi-agent reviewer* → done via the owned `/review-pr`
  command; the volatile marketplace plugin is left untouched (a cache edit
  can't be committed or synced).

---

## Consequences

**Positive**
- One small, adversarial, stack-relevant artifact instead of 16k lines of
  off-stack, collaborative prose.
- No new skill surface, no standing context cost, syncs via `dotclaude`.
- Sharpens the *substance* of reviews (anti-pattern coverage) without diluting
  the *posture* we already have.

**Negative / costs**
- `/code-review` attach is manual (Option A) — depends on habit.
- `/review-pr` duplicates the upstream marketplace prompt; if upstream improves,
  re-vendor manually.
- Anti-pattern catalog is generic; real teeth still come from the multi-agent
  reviewer's confidence gate.

**Neutral**
- Per-language and PowerShell/IaC coverage explicitly out of scope here.

---

## Open questions

1. PowerShell + IaC adversarial checklists → tracked in **ADR-002**.
2. Whether to periodically re-vendor `/review-pr` against the upstream
   marketplace prompt (no automation; manual on notice of upstream changes).
