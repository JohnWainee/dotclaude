---
name: doc-gen-package
description: "doc-gen package — pluggable documentation generation with Terraform and Kubernetes template packs."
metadata:
  node_type: memory
  type: project
  originSessionId: session_doc-gen-v1
---

## What shipped

Pluggable documentation generation for Claude Code. Delivered as a self-contained
package under `packages/doc-gen/` — extractable to a standalone repo, depends on
the IBM Documentation Style package (ADR-003).

### Architecture

- **Pluggable template packs.** Each technology stack is a `pack.md` file under
  `templates/doc-gen/<pack-name>/`. New packs are added by dropping a directory.
- **Scan-then-propose.** The command detects project types, discovers modules,
  and presents a documentation plan. Generation happens only after explicit user
  approval.
- **Universal docs/ skeleton.** All packs output to the same directory structure:
  `modules/`, `runbooks/`, `troubleshooting/`, `guides/`, `reference/`.
- **IBM style dependency.** Every generated document conforms to the IBM
  Documentation Style Guide. The reference is loaded before any generation.

### V1 template packs

1. **Terraform** — module references, variable catalogs, output references, state
   management runbook, troubleshooting guide.
2. **Kubernetes** — workload references, Helm values reference, deployment
   runbook, rollback runbook, troubleshooting guide.

### Key files

| File | Purpose |
|------|---------|
| `packages/doc-gen/commands/doc-gen.md` | The `/doc-gen` command |
| `packages/doc-gen/references/doc-gen-template-spec.md` | Template pack format spec |
| `packages/doc-gen/templates/doc-gen/terraform/pack.md` | Terraform template pack |
| `packages/doc-gen/templates/doc-gen/kubernetes/pack.md` | Kubernetes template pack |
| `docs/adr/ADR-004-automated-doc-generation.md` | Decision record |

### Bootstrap change

Added `templates` to the deployment loop in both `bootstrap.sh` and
`bootstrap.ps1`. Template packs now deploy to `~/.claude/templates/` alongside
commands and references.

## Future packs

Planned template packs (not yet built):
- Windows infrastructure (runbooks, troubleshooting, SOPs)
- PowerShell modules (function help, module overview, examples)
- Node.js
- Go
- Terraform (extended — Terragrunt, workspaces)
- Container tools
- General application code (README, contributing, architecture)

## How to apply

When adding a new template pack, read `packages/doc-gen/references/doc-gen-template-spec.md`
for the pack format specification. Follow the pattern established by the Terraform
and Kubernetes packs.
