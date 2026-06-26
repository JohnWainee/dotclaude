# ADR-003: Adopt IBM Documentation Style as the universal standard

| Field   | Value |
|---------|-------|
| Status  | Proposed |
| Date    | 2026-06-26 |
| Owner   | Juan P. |
| Trigger | Ad-hoc documentation across repos; no enforced style standard. |

## Summary

Adopt the IBM Documentation Style Guide as the single standard for all markdown
documentation. Enforce it through a lean CLAUDE.md section (always-on), an
on-demand `/doc-style` audit command, and a documentation agent integrated into
`/review-pr`. Package the tooling as a self-contained, shareable module under
`packages/ibm-doc-style/`.

## Context

Documentation is written inconsistently: passive voice mixed with active, Latin
abbreviations alongside spelled-out equivalents, headings in title case next to
sentence case. No shared reference exists. When Claude generates documentation,
it follows whatever style is present in the surrounding context—or defaults to
its own—producing further drift. The user works solo across Windows
administration, infrastructure, and a side project, and wants a single standard
that applies everywhere without manual enforcement.

The IBM Style Guide is a well-established technical writing standard that
emphasizes clarity, task orientation, and accessibility. It aligns with the
user's preference for decisive, direct prose and their existing conventions
(imperative headings, concise language, no fluff).

## Options considered

### Option A: Embed the full ruleset in CLAUDE.md

- **Pro:** Every session has the complete reference; no file lookup needed.
- **Con:** Adds 200+ lines to every session's context. Significant per-session
  token cost for a rule set that only matters when writing or reviewing docs.

### Option B: CLAUDE.md lean summary + reference file (selected)

- **Pro:** 12 lines in CLAUDE.md set the standard. Full reference loaded only
  when auditing or generating docs. Cost-efficient.
- **Con:** Claude might miss detailed rules during casual doc edits (mitigated
  by the core-principles summary covering the most impactful rules).

### Option C: Style linter (markdownlint, Vale)

- **Pro:** Automated enforcement, CI-integrated.
- **Con:** Requires maintaining a linter configuration, doesn't cover semantic
  rules (task orientation, document structure, terminology consistency). Adds
  tooling complexity. Not portable across the user's heterogeneous repo
  landscape without per-repo CI setup.

## Decision

**Option B.** Three enforcement layers:

1. **CLAUDE.md (always-on):** ~12 lines summarizing core IBM principles. Every
   session sees them. Covers the highest-impact rules (active voice, present
   tense, short sentences, headings, serial comma, no Latin abbreviations).

2. **`/doc-style` command (on-demand):** Loads the full reference and audits
   one or more files. Reports findings with severity (blocking / important /
   nit). Supports `--fix` to propose rewrites.

3. **`/review-pr` Agent #6 (integrated):** When a PR includes markdown changes,
   a dedicated agent audits them against the full reference. Findings go through
   the existing confidence-gating pipeline (>=80 to report).

**Packaging:** All files live in `packages/ibm-doc-style/`—a self-contained
directory with its own install scripts and README. Extractable to a standalone
repo for sharing. The dotclaude bootstrap copies from packages automatically.

**Migration:** Gradual. New docs conform immediately. Existing docs are
retrofitted when edited for other reasons.

## Consequences

**Positive:**
- Single source of truth for documentation style.
- Consistent output regardless of which repo or machine Claude runs on.
- Shareable: others can install the package without adopting the full dotclaude
  config.
- Cost-efficient: lean CLAUDE.md section; full reference loaded only on demand.

**Negative:**
- Claude may miss detailed rules during casual edits (only core principles are
  in CLAUDE.md). Acceptable—the on-demand audit catches the rest.
- Maintaining the reference file requires periodic review if IBM updates the
  guide.

**Neutral:**
- Introduces the `packages/` directory convention to dotclaude. Sets a pattern
  for future shareable modules (for example, `/doc-gen`).

## Open questions

- Should the reference file track the IBM Style Guide edition/version for
  traceability?
- Should `/doc-style --fix` auto-commit the rewrites, or always propose?
  (Current decision: always propose, honoring the code gate.)
- Future: `/doc-gen` (ADR-004) depends on this package. Sequencing is IBM style
  first, doc generation second.
