# Adversarial Code Review Checklist — Infrastructure as Code

**Posture: guilty until proven innocent.** Same operating rules as
[`adversarial-review-checklist.md`](adversarial-review-checklist.md): default to
refute, confidence-gate every finding (drop <80), one finding = one defensible
claim (location, failing scenario, consequence), only the diff is on trial, skip
formatting/linter style. Severity: 🔴 blocking / 🟠 important / 🟡 nit / 🔵 design.

Covers Terraform, Ansible, and Bicep. The dangerous defects are **state, drift,
blast radius, privilege, and secrets** — not app-style logic bugs. The core
question: **"what does `apply` actually do to live infra, and can I undo it?"**

> Attach for `.tf` / `.yml` (playbooks) / `.bicep` changes: *"apply
> `@adversarial-review-iac.md`."*

---

## 1. Blast radius — read the plan, not the code

- **Destroys.** Any change implying destroy/replace of a **stateful** resource
  (database, volume, bucket with data) is 🔴 until justified. Look for
  force-new arguments (immutable fields being changed: name, AZ, engine).
- **Shared/prod resources touched implicitly** — a change to a module or shared
  data source that fans out to many environments.
- **No `lifecycle` guard** (`prevent_destroy`, `create_before_destroy`,
  `ignore_changes`) on critical resources where churn would cause an outage.

## 2. State & drift

- **State conflicts.** Renamed resources without `moved {}` blocks / `state mv`
  → destroy+recreate instead of rename.
- **Count/for_each index shifts** — removing an element by middle index churns
  every resource after it.
- **Drift assumptions.** Code that assumes a clean state but will collide with
  resources created out-of-band.

## 3. Secrets

- **Hardcoded credentials** — passwords, tokens, keys as literals in `.tf`/vars/
  playbooks. 🔴.
- **Secrets in state.** Any sensitive value lands in state; is state encrypted
  and access-controlled? A `password`/`secret` output **not** marked
  `sensitive = true` prints to logs. 🔴.
- **Unencrypted vars files** committed; Ansible vars not `vault`-encrypted.

## 4. Privilege & exposure

- **Over-broad IAM/roles.** `Action: "*"`, `Resource: "*"`, wildcard principals,
  `Effect: Allow` with `Principal: "*"`. 🔴.
- **Public exposure.** `0.0.0.0/0` ingress (esp. to 22/3389/db ports), public
  S3/storage buckets, `publicly_accessible = true`, unauthenticated endpoints.
  🔴 for admin/db ports.
- **Disabled protections.** Encryption off, logging off, deletion protection off,
  public-access-block removed.

## 5. Idempotency (Ansible especially)

- **`command` / `shell` tasks** without `creates:` / `removes:` / `changed_when:`
  / `when:` guards — run every time, report changed every time, may not be safe to
  re-run.
- **`state: latest`** on packages — non-deterministic; pins drift.
- **Handlers not notified / not idempotent.**

## 6. Pinning & reproducibility

- **Unpinned providers/modules.** No `version`/`required_version`, `latest`,
  mutable git refs (branch instead of tag/SHA) — non-reproducible apply.
- **Provider source unpinned** in `required_providers`.

## 7. Reversibility

- **One-way changes.** Does the change have a safe rollback, or is it
  destroy-only? Data migrations, bucket deletions, DB engine changes — call out
  the recovery path (or its absence) explicitly.

---

## Output shape

```
<severity> <one-line claim> [confidence: N]
  where:  <file:line>
  breaks: <on apply / on re-run / on rollback / who can now reach it>
  cost:   <data loss / outage / exposure / drift>
```

If nothing clears ≥80: "no defensible findings ≥80 confidence." Do not invent
style nits.
