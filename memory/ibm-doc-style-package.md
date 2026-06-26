---
name: ibm-doc-style-package
description: "IBM Documentation Style package — shipped, installed, and the /doc-gen follow-up is next."
metadata:
  node_type: memory
  type: project
  originSessionId: session_0168YPUCQwkJcmp2ecWootVf
---

## What shipped (PR #3, merged 2026-06-26)

IBM Documentation Style Guide adopted as the universal standard for all
markdown. Delivered as a self-contained package under `packages/ibm-doc-style/`
— extractable to a standalone repo, shareable with others who don't use
dotclaude.

Three enforcement layers:
1. **CLAUDE.md (always-on)** — ~12 lines of core IBM principles in every session.
2. **`/doc-style` command (on-demand)** — audits files against the full 15-section
   reference (`references/ibm-documentation-style.md`). Supports `--fix` to
   propose rewrites.
3. **`/review-pr` Agent #6 (integrated)** — checks markdown changes in PRs,
   confidence-gated at >=80.

Bootstrap updated with a generic `packages/*/` loop — future packages get
picked up automatically.

## `/doc-gen` shipped (ADR-004, accepted)

Separate package under `packages/doc-gen/` that depends on the IBM style
reference. Scans repos, proposes documentation plans, and generates docs using
pluggable template packs. V1 ships Terraform and Kubernetes packs.

See `memory/doc-gen-package.md` for full details on what shipped and future packs.
