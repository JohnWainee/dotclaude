# Adversarial Code Review Checklist (language-agnostic)

**Posture: guilty until proven innocent.** A diff is a defendant. Your job is to
find the bug, not to bless the change. Every finding is a *claim you can defend*,
not a polite suggestion. No praise. No "have you considered." No hedging. If you
cannot decide whether something is a real defect, say so with a confidence
level — do not soften it into a nicety.

> How to use: run your normal reviewer (`/code-review`, or the `/review-pr`
> multi-agent reviewer), then attach this file: *"apply
> `@adversarial-review-checklist.md`."* `/review-pr` loads it automatically.
> It adds an anti-pattern + correctness pass; it does **not** replace the
> reviewer's confidence gating.

---

## Operating rules

1. **Default to refute.** Assume each new block is wrong until the diff proves
   otherwise. Ask "what input breaks this?" before "does this read nicely?"
2. **Confidence-gate every finding.** Tag each with a 0–100 confidence that it's
   a *real* defect (not a false positive, not pre-existing). Drop anything you
   can't push to ≥80 after a second look. State the number.
3. **Only the diff is on trial.** Don't flag pre-existing issues on unchanged
   lines unless the diff newly *depends* on them.
4. **No linter work.** Skip formatting, imports, type errors, style — CI owns
   those. Spend the budget on logic, security, and design.
5. **One finding = one defensible claim** with: location, the failing scenario,
   and the consequence. If you can't name the scenario, it isn't a finding yet.

---

## Severity (adversarial taxonomy)

- 🔴 **blocking** — will break in production or violates an explicit rule
  (CLAUDE.md, security). Merge is wrong until fixed.
- 🟠 **important** — real defect, lower hit-rate or narrower blast radius.
  Should fix; argue if you disagree.
- 🟡 **nit** — defect-adjacent but minor; non-blocking.
- 🔵 **design** — the approach is structurally weaker than an obvious
  alternative; name the alternative and the concrete cost of not taking it.

*(Dropped from the source framework: "praise" and "learning" markers — they
dilute an adversarial review.)*

---

## 1. Correctness — hunt the failing input

- **Boundaries:** empty collection, single element, zero, negative, max,
  off-by-one. Which one is unhandled?
- **Null / undefined / absent:** every dereference of something that could be
  missing. What's the failure mode when it is?
- **Concurrency:** shared mutable state, check-then-act, missing locks,
  non-atomic read-modify-write. Two callers at once — what corrupts?
- **TOCTOU:** any "check X, then act on X" where X can change between the two.
  (Files, permissions, existence checks, cache lookups.)
- **Error paths:** swallowed exceptions, ignored return codes, `catch` that
  hides the cause, partial failure leaving inconsistent state.
- **Resource lifecycle:** opened-but-not-closed handles/connections/locks;
  cleanup that doesn't run on the error path.
- **No-op updates:** code that *looks* like it mutates but doesn't (writing to a
  copy, assigning a derived value back to itself, a setter with no effect).
- **Off-contract returns:** function can return a shape/value its callers don't
  handle (empty vs null vs throw inconsistency).

## 2. Security — assume hostile input

- **Input validation:** every external input (args, env, network, files) —
  validated before use, or trusted blindly?
- **Injection:** strings concatenated into SQL / shell / paths / templates.
- **Secrets:** credentials/tokens in code, logs, or error messages.
- **Authz vs authn:** is *permission* checked, not just *identity*? Missing
  ownership checks on the modified path.
- **Sensitive data:** logged, cached, or returned where it shouldn't be.

## 3. Anti-patterns — structural defects (mined from the source catalog)

- **Reuse audit (do this first):** before accepting any new helper/util, grep
  adjacent files and shared modules for an existing one. New code that
  duplicates existing capability is a finding.
- **Parameter sprawl:** functions accreting flags/booleans/optionals. A boolean
  param that switches behavior usually wants to be two functions.
- **Leaky abstractions:** caller must know the callee's internals to use it
  correctly (ordering requirements, hidden side effects, "call init first").
- **Nested conditionals:** >2 levels of branching hiding the real logic; ask for
  early-returns / guard clauses, and check each branch is reachable & correct.
- **Stringly-typed code:** state/kind/mode passed as raw strings instead of an
  enum/constant; typo-prone and unchecked.
- **Redundant / derived state:** two fields that must agree, or state that
  duplicates something already derivable. Which one goes stale?
- **Dead / unreachable code** introduced by the change.

## 4. Design & blast radius

- **Does the solution fit the problem,** or is it the first thing that compiled?
  Name the simpler alternative if there is one (🔵).
- **Coupling:** does this change force unrelated callers to change too?
- **Reversibility:** how hard is this to undo if wrong? Migrations, data writes,
  destructive ops — call out the blast radius explicitly.
- **Tests:** is there a test that would *fail* without this change and *pass*
  with it? Absence of a regression test for a bug fix is a 🟠 finding.

## 5. Project rules

- **CLAUDE.md adherence:** does the diff violate a stated rule? Cite the exact
  line. (Don't invent rules that aren't written down.)
- **In-file guidance:** comments/docstrings in the touched files that the change
  contradicts.

---

## Output shape

```
<severity> <one-line claim> [confidence: N]
  where:  <file:line>
  breaks: <the specific scenario / input>
  cost:   <what happens in production>
```

If, after an honest pass, nothing clears the ≥80 bar: say "no defensible
findings ≥80 confidence" — do not manufacture nits to look thorough.
