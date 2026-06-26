# ADR-004: Automated documentation generation as a separate package

| Field   | Value |
|---------|-------|
| Status  | Accepted |
| Date    | 2026-06-26 |
| Owner   | Juan P. |
| Trigger | Decision to adopt IBM style (ADR-003) raised the question of bundling doc generation into the same package. |

## Summary

Build `/doc-gen` as a separate, standalone package that depends on the IBM
documentation style reference (ADR-003). It scans a repository, proposes a
documentation plan, and generates IBM-style-conformant docs after user approval
using pluggable template packs.

## Context

With IBM style adopted as the universal standard (ADR-003), the next question is
whether to automate documentation creation—runbooks, troubleshooting guides,
module references—alongside style enforcement or as a distinct capability.

Style enforcement (audit what exists) and documentation generation (create what
is missing) are different operations with different invocation patterns,
different per-project customization needs, and different compute costs.

## Options considered

### Option A: Bundle generation into the IBM style package

- **Pro:** Single install, guaranteed style conformance.
- **Con:** Bloats a focused style-enforcement package. Generation templates vary
  by project type (Terraform, Kubernetes, Windows infra, PowerShell, and others);
  cramming them into a style package forces every consumer to carry templates
  they do not need. Higher compute cost per invocation.

### Option B: Separate package with a dependency (selected)

- **Pro:** IBM style stays focused (enforce). `/doc-gen` stays focused (create).
  Each is independently shareable and installable. Generation templates are
  scoped to project type via pluggable packs. Cost-efficient: generate only when
  needed, audit only when needed.
- **Con:** Two packages to install instead of one. Acceptable given the package
  install pattern from ADR-003.

## Decision

**Option B.** `/doc-gen` is a separate package under `packages/doc-gen/`. It
loads `ibm-documentation-style.md` as a dependency when generating
documentation, ensuring every generated document conforms automatically.

**Architecture:** Pluggable template packs. Each technology stack is a
self-contained `pack.md` file with detection signals, doc type definitions, and
generation instructions. New packs are added by dropping a directory under
`templates/doc-gen/`.

**V1 template packs:**
- Terraform (module references, variable catalogs, state management runbooks,
  troubleshooting guides)
- Kubernetes (workload references, Helm values references, deployment and
  rollback runbooks, troubleshooting guides)

**Future packs:** Windows infrastructure, PowerShell modules, Node.js, Go,
general application code, container tools.

**Discovery:** Scan-then-propose. The command scans the target directory, detects
qualifying template packs using weighted file-pattern signals, discovers module
boundaries, and presents a checklist-style proposal. Generation happens only
after explicit user approval.

**Output format:** Structured `docs/` skeleton with standard subdirectories
(`modules/`, `runbooks/`, `troubleshooting/`, `guides/`, `reference/`). Universal
layout across all template packs. Only directories containing generated files are
created.

**Generated-by marker:** Yes. HTML comment at the end of each file:
`<!-- doc-gen | pack: <name> | type: <id> | date: <date> -->`. Machine-parseable,
invisible in rendered output.

**Integration with `/doc-style`:** `/doc-gen` does not auto-invoke `/doc-style`
after generation. It suggests the user run `/doc-style docs/` to audit. This
keeps compute under user control and maintains the create/enforce separation
established in ADR-003.

## Consequences

**Positive:**
- IBM style ships first and independently. No coupling.
- Templates can evolve per project type without affecting style enforcement.
- Both packages are shareable as standalone repos.
- Pluggable architecture makes adding new technology stacks trivial.

**Negative:**
- Two installs for users who want both. Mitigated by the bootstrap's automatic
  package discovery.

## Resolved questions

- **Which project types get templates first?** Terraform + Kubernetes (IaC focus).
  Windows infrastructure is deferred to v2.
- **Skeleton or individual documents?** Full `docs/` skeleton with a universal
  directory structure. Individual doc generation is supported through the
  `--type` flag.
- **How does `/doc-gen` discover module boundaries?** Convention-based scanning
  defined per template pack in the `pack.md` detection and context-gathering
  sections. Module boundary rules are pack-specific. An explicit `[directory]`
  argument scopes the scan.
- **Generated-by marker?** Yes. See the decision section above.
