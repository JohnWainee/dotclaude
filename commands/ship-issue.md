---
description: Drive a GitHub issue to a reviewed PR — fetch, branch, plan→gate, implement, verify, PR, self-review.
argument-hint: <issue-number>
---

You are shipping GitHub issue **#$1** end-to-end. Compose with **workflow-mode** (design-first, plan-as-files, verify-before-done) and respect the **code gate**: do not write implementation code until the plan is explicitly approved.

Follow these phases in order. Stop and report if any phase blocks.

## 1. Understand
- Run `gh issue view $1 --json title,body,labels,comments,assignees`.
- Restate the goal in one paragraph and extract explicit **acceptance criteria** as a checklist. If the issue is ambiguous, ask before proceeding.

## 2. Branch
- Derive a type from labels (`feat`/`fix`/`chore`/`docs`) and a short slug from the title.
- `git switch -c <type>/$1-<slug>` off the default branch. Never work on `main` (the block-main-push hook enforces this).

## 3. Plan — STOP at the gate
- Produce a plan as a file (per workflow-mode / the ADR-as-files convention), covering approach, files to touch, test strategy, and any architecture decision worth an ADR.
- **Present the plan and wait for explicit approval. Do not write code yet.**

## 4. Implement
- Only after approval. Make small, focused commits with **conventional-commit** messages (`feat: …`, `fix: …`). Reference the issue where natural.
- Keep changes minimal and idiomatic to the surrounding code; no speculative features.

## 5. Verify
- Build and run the project's test suite (or invoke `/verify`). Run any configured formatters/linters.
- Do **not** proceed while anything is failing — fix or report.

## 6. Open the PR
- `gh pr create` with a body that includes `Closes #$1`, a summary, the change list, and test evidence (commands run + result). Use the repo PR template if present.

## 7. Self-review
- Run `/code-review` on the diff (consider `/security-review` if the change touches auth, data sync, or secrets). Address findings, then push.

## 8. Report
- Output the PR URL and a one-line status. Do **not** merge — leave the merge decision to the human.
