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

## Next: `/doc-gen` (ADR-004)

Separate package under `packages/doc-gen/` that **depends on** the IBM style
reference. Generates runbooks, troubleshooting guides, and junior-engineer
how-tos per module using project-type-specific templates.

Open design questions (from ADR-004):
- Template taxonomy: which project types get templates first (recommendation:
  Windows infrastructure, the primary day-to-day context).
- Scope per invocation: single module/directory vs. full repo.
- Output format: flat files vs. directory structure.
- Module boundary discovery: convention-based scanning, explicit argument, or
  both.
- Generated-by marker for traceability.

**How to apply:** When starting the `/doc-gen` work, read `docs/adr/ADR-004-automated-doc-generation.md`
for the full decision record. The IBM style reference at
`packages/ibm-doc-style/references/ibm-documentation-style.md` is the
dependency — `/doc-gen` loads it before generating any documentation.
