# Review-checklist fixtures

Deliberately-flawed samples for exercising the adversarial review checklists in
[`../references/`](../references/). These are **not** deployed by bootstrap (only
`references/` is) — they live here for verification only.

## How to exercise

Attach the matching checklist and review the fixture:

```
/code-review   # then: "apply @adversarial-review-powershell.md to tests/fixtures/sample-flawed.ps1"
```

or pass both to a finder agent. A working checklist should catch the planted
defects below at ≥80 confidence and **not** manufacture out-of-scope nits.

## Planted defects — answer key

### `sample-flawed.ps1`
| # | Defect | Checklist § |
|---|---|---|
| P1 | No `$ErrorActionPreference = 'Stop'`; non-terminating failures continue silently | §1 |
| P2 | `Remove-Item -Recurse -Force "$Root\$Name"` with unvalidated/possibly-empty params → can delete the wrong (or root) path | §4 |
| P3 | Hardcoded plaintext password literal + `ConvertTo-SecureString -AsPlainText -Force` on it | §6 |
| P4 | `Invoke-Expression $Command` on caller-supplied string — arbitrary code execution | §5 (🔴) |
| P5 | `catch { Write-Host "continuing despite error" }` swallows failure, leaves partial state | §1 |
| P6 | `try/catch` wraps non-terminating cmdlets (`Copy-Item`, `New-Item`) that won't throw without `-ErrorAction Stop` — catch never fires | §1 |
| P7 (minor) | `New-Item` not idempotent on its own (relies on prior `Remove-Item` succeeding) | §2 |

### `sample-flawed.tf`
| # | Defect | Checklist § |
|---|---|---|
| T1 | `aws` provider unpinned (no `version`) — non-reproducible | §6 |
| T2 | Hardcoded DB `password` literal | §3 (🔴) |
| T3 | `publicly_accessible = true` on RDS | §4 (🔴) |
| T4 | Security group `0.0.0.0/0` ingress to 22 and 5432 | §4 (🔴) |
| T5 | IAM policy `Action = "*"`, `Resource = "*"` | §4 (🔴) |
| T6 | `output "db_password"` without `sensitive = true` — leaks to logs | §3 (🔴) |
| T7 | Stateful DB with `skip_final_snapshot = true` and no `prevent_destroy` lifecycle | §1/§7 |
