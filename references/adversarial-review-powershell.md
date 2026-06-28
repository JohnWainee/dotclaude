# Adversarial Code Review Checklist — PowerShell

**Posture: guilty until proven innocent.** Same operating rules as
[`adversarial-review-checklist.md`](adversarial-review-checklist.md): default to
refute, confidence-gate every finding (drop <80), one finding = one defensible
claim (location, failing scenario, consequence), only the diff is on trial, skip
formatting/linter style. Severity: 🔴 blocking / 🟠 important / 🟡 nit / 🔵 design.

The infra question is not "what input breaks this?" but **"what state does this
assume, and what happens on the second run / partial failure / wrong target?"**

> Attach for `.ps1` / `.psm1` changes: *"apply
> `@adversarial-review-powershell.md`."*

---

## 1. Error handling — silent failure is the default

- **`$ErrorActionPreference`.** Default is `Continue` — a failing cmdlet keeps
  going. Is it set to `Stop` at script top, or is `-ErrorAction Stop` on every
  operation whose failure must halt? An unset preference around a destructive or
  state-changing sequence is 🔴.
- **`try/catch` placement.** Non-terminating errors are NOT caught by `try/catch`
  unless promoted to terminating (`-ErrorAction Stop` / `$ErrorActionPreference`).
  A `try/catch` that wraps a non-terminating cmdlet catches nothing.
- **`$LASTEXITCODE` / native commands.** Calling `.exe`s? Failures don't throw —
  is the exit code checked?
- **Swallowed errors.** `-ErrorAction SilentlyContinue` / empty `catch {}` hiding
  a failure that leaves inconsistent state.

## 2. Idempotency — what does the second run do?

- **Create-without-check.** `New-Item`, `New-LocalUser`, `Add-Content` on a path/
  object that already exists — errors or duplicates on re-run.
- **Append vs set.** `Add-*` (ACL entries, members, firewall rules) inside a
  re-runnable script accretes duplicates. Should it be `Set-*` / check-then-add?
- **No desired-state guard.** Does the script check current state before acting,
  or blindly apply?

## 3. Privilege & scope

- **Assumed elevation.** Modifies machine-wide state (HKLM, `Program Files`,
  services, scheduled tasks) without verifying admin — fails or partially applies
  for a non-elevated user.
- **Over-broad scope.** Machine-wide change where user-scope (HKCU) would do.
- **Execution policy.** `Set-ExecutionPolicy` (especially `Bypass`/`Unrestricted`
  at `LocalMachine`) inside a script — security downgrade. 🔴 unless scoped to
  `Process` with justification.

## 4. Destructive operations — validate the target

- **`Remove-Item -Recurse -Force`, `Format-*`, `Clear-*`, registry writes.** Is
  the target path/key **validated and non-empty** before deletion? A variable
  that resolves to empty turns `Remove-Item "$base\$sub"` into deleting `$base`
  (or worse, the drive root).
- **`-WhatIf` / `-Confirm` support.** Advanced functions performing destructive
  actions should declare `[CmdletBinding(SupportsShouldProcess)]` and honor it.
- **Blast radius.** Does it act on a list/glob that could match more than
  intended? (`Get-ChildItem | Remove-Item` with a loose filter.)

## 5. Injection & untrusted input

- **`Invoke-Expression` (`iex`)** on any interpolated/external string — arbitrary
  code execution. 🔴.
- **`Start-Process` / `cmd /c` / `& $cmd`** with unquoted or user-supplied
  arguments — argument injection; paths with spaces break or inject.
- **SQL / LDAP / path strings** built by concatenation from input.

## 6. Secrets

- **Plaintext credentials** in the script, or `ConvertTo-SecureString -AsPlainText
  -Force` on a literal — defeats the SecureString purpose. 🔴.
- **Secrets in transcripts/logs.** `Start-Transcript` active while a credential
  or token is echoed; `Write-Host`/`Write-Output` of a secret.
- **Plaintext at rest.** Credentials written to a file unprotected.

## 7. Pipeline & output correctness

- **Accidental output.** A function emitting objects to the pipeline it didn't
  mean to (un-assigned expression, `Write-Output` debris) — pollutes the caller's
  return value. (See "off-contract returns" in the generic checklist.)
- **Pipeline input.** A function that should accept `ValueFromPipeline` but
  processes only the last item, or lacks a `process {}` block.
- **`return` semantics.** `return $x` in PowerShell still emits prior pipeline
  output; the function may return more than the author thinks.

## 8. Remoting

- **`Invoke-Command` / WinRM trust.** Double-hop credential loss; passing
  `-Credential` to an untrusted host; `-Authentication` weakened.

---

## Output shape

```
<severity> <one-line claim> [confidence: N]
  where:  <file:line>
  breaks: <run #2 / partial failure / wrong target / hostile input>
  cost:   <what happens to the machine / data>
```

If nothing clears ≥80: "no defensible findings ≥80 confidence." Do not invent
style nits.
