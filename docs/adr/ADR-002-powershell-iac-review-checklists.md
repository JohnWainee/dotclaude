# ADR-002: Adversarial review checklists for PowerShell and IaC

**Status:** Accepted — implemented on branch `feat/powershell-iac-checklists`
**Date:** 2026-06-21
**Owner:** juanp
**Trigger:** ADR-001 deferred per-domain coverage; the external repo had zero
coverage of the actual day-to-day stack (Windows admin & infrastructure).

---

## Summary (TL;DR)

ADR-001 shipped a language-agnostic adversarial checklist. The one gap it
intentionally left — and the one that matters most here — is **PowerShell** and
**Infrastructure-as-Code (Terraform / Ansible / Bicep)**. These are the bulk of
day-to-day work, carry the **highest blast radius** (live infra, privileged
scripts), and are exactly where the surveyed external repo offered nothing.
Propose two new `references/` checklists that extend the adversarial posture
into these domains.

---

## Context

- Day-to-day work is Windows administration & infrastructure. Most changes that
  warrant review are PowerShell scripts and IaC, not application code.
- These domains fail differently from app code: the dangerous defects are
  **idempotency, state, drift, privilege, and blast radius** — not the
  app-centric null/concurrency bugs ADR-001's checklist centers on.
- The generic checklist (ADR-001) catches some of this (TOCTOU, error paths,
  injection) but misses the domain-specific landmines below.

### Why not just rely on the generic checklist

The generic checklist asks "what input breaks this?" The infra question is
"**what state does this assume, and what happens on the second run / partial
failure / wrong target?**" Different failure model → needs its own catalog.

---

## Decision (proposed — needs approval before authoring)

Author two new adversarial reference checklists, same voice and confidence-gate
as ADR-001, deployed via the existing `references/` mechanism:

### `references/adversarial-review-powershell.md` (candidate catalog)

- **Error handling:** `$ErrorActionPreference` default is `Continue` — silent
  failure. Is it set to `Stop` (or `-ErrorAction Stop` on risky cmdlets)? Are
  `try/catch` blocks present where a failure must halt?
- **Idempotency:** does re-running the script duplicate work or error on
  already-existing resources? (`New-Item` on an existing path, re-adding ACLs.)
- **Privilege & scope:** does it assume elevation without checking? Does it
  modify machine-wide state when user-scope would do?
- **Destructive ops:** `Remove-Item -Recurse -Force`, `Format-*`, registry
  writes, `Set-ExecutionPolicy` — is the target validated? Is `-WhatIf`/
  `-Confirm` supported on advanced functions?
- **Injection:** `Invoke-Expression` on interpolated strings; unquoted paths
  with spaces; passing user input to `Start-Process`/`cmd /c`.
- **Pipeline correctness:** functions that should accept pipeline input but
  don't; `return` inside a pipeline emitting unintended objects.
- **Secrets:** plaintext credentials, `ConvertTo-SecureString -AsPlainText`,
  secrets in transcript logs.
- **Remoting:** `Invoke-Command` trust boundaries, double-hop, blind `-Credential`.

### `references/adversarial-review-iac.md` (candidate catalog)

- **State & drift:** changes that will conflict with existing state; resources
  recreated (force-new) where the diff implies an update; missing `lifecycle`
  guards on critical resources.
- **Idempotency (Ansible):** non-idempotent `command`/`shell` tasks without
  `creates`/`changed_when`/`when` guards.
- **Blast radius:** does the plan touch shared/production resources implicitly?
  Count adds/changes/**destroys** — any destroy of stateful infra is 🔴 until
  justified.
- **Secrets:** hardcoded credentials, secrets in state, unencrypted vars, plain
  outputs marked non-sensitive.
- **Provider/module pinning:** unpinned versions, `latest`, mutable refs.
- **Privilege:** over-broad IAM/role grants, wildcards, public exposure
  (`0.0.0.0/0`, public buckets/storage).
- **Reversibility:** is the change safely `apply`-then-rollback, or one-way?

---

## Options + tradeoffs

| Option | Tradeoff |
|---|---|
| **A. Two separate checklists (recommended)** | Cleanest; attach only the relevant one. Slightly more files. |
| B. One combined "infra" checklist | Fewer files; mixes two failure models, longer to load. |
| C. Fold into the generic checklist | No new files; bloats the generic one and dilutes its app-code focus. Rejected. |

**Recommended: A.** Mirrors ADR-001's "attach the relevant reference" model;
`/review-pr` can load whichever matches the changed file types.

---

## Consequences

**Positive**
- Review coverage finally matches the actual stack and its real failure modes.
- Highest-blast-radius changes (live infra, privileged scripts) get the
  adversarial treatment first.

**Negative / costs**
- Two more references to maintain; infra tooling evolves (Terraform/PowerShell
  versions) so the catalogs will need periodic refresh.
- Domain catalogs risk becoming linters-in-prose; keep them to *defects a senior
  infra engineer would actually flag*, not style.

---

## Open questions

1. Terraform-first, or include Ansible + Bicep from the start? (Recommend
   Terraform + Ansible first; Bicep on demand.)
2. Should `/review-pr` auto-select the checklist by changed-file extension
   (`.ps1` → PowerShell, `.tf`/`.yml` → IaC), or stay manual-attach?
3. ~~Verification: no live PR test bed yet~~ — **Resolved.** Deliberately-flawed
   fixtures live in `tests/fixtures/` (`sample-flawed.ps1`, `sample-flawed.tf`)
   with a blind answer key in `tests/README.md`. A blind adversarial pass caught
   every planted defect at ≥80 (7/7 IaC, 6/7 PowerShell) plus two real bonus
   findings, with no manufactured nits.

## Verification result (2026-06-21)

A finder agent reviewed both fixtures with the new checklists, blind to the
answer key:
- **IaC:** 7/7 planted defects flagged ≥80 (hardcoded password, public DB, open
  SG, `*:*` IAM, non-sensitive output, unpinned provider, unrecoverable destroy)
  + bonus: storage-encryption-off; correctly gated an IAM-reference design note
  at 70 (<80).
- **PowerShell:** caught `Invoke-Expression` injection, unvalidated recursive
  delete, plaintext-secret chain, error-swallowing `catch`, and unset
  `$ErrorActionPreference` (all ≥80) + bonus: pipeline-output pollution. The
  one "minor" planted item (non-idempotent `New-Item`) was folded into the
  error-handling finding rather than called out separately.
