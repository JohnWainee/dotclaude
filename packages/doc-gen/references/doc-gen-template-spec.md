# Template pack format specification

This reference defines the contract between the `/doc-gen` command and template
packs. Every template pack is a single `pack.md` file stored under
`~/.claude/templates/doc-gen/<pack-name>/pack.md`.

## File format

Each `pack.md` uses YAML frontmatter for machine-readable metadata and a markdown
body for generation instructions.

## Frontmatter fields

### Required fields

- **`name`** — Human-readable name (for example, "Terraform").
- **`description`** — One-line summary of what this pack covers.
- **`detect`** — List of detection signal objects. Each object has:
  - `pattern` — Glob pattern to match files (for example, `*.tf`).
  - `weight` — Integer from 1 to 3 indicating signal strength.
- **`doc-types`** — List of document type objects. Each object has:
  - `id` — URL-safe slug (for example, `module-readme`).
  - `name` — Human-readable name (for example, "Module reference").
  - `output-path` — Relative path under `docs/`. Use `{module}` or `{workload}`
    as a placeholder for per-module doc types.
  - `scope` — One of `per-repo`, `per-module`, or `per-directory`.

### Optional fields

- **`min-confidence`** — Minimum total detection weight to qualify this pack.
  Default: 3.

## Frontmatter example

```yaml
---
name: Terraform
description: >
  Documentation for Terraform configurations — module references, variable
  catalogs, state management runbooks, and troubleshooting guides.
detect:
  - { pattern: "*.tf", weight: 3 }
  - { pattern: ".terraform.lock.hcl", weight: 3 }
  - { pattern: "terraform.tfvars", weight: 2 }
min-confidence: 3
doc-types:
  - { id: "module-readme", name: "Module reference", output-path: "docs/modules/{module}/README.md", scope: "per-module" }
  - { id: "state-runbook", name: "State management", output-path: "docs/runbooks/state-management.md", scope: "per-repo" }
---
```

## Markdown body sections

### Context gathering

The `## Context gathering` section tells the command what source files to read
before generating each doc type. Organize instructions by doc type ID.

Use this section to specify:
- Which files provide the source data (for example, "read all `*.tf` files in the
  module directory").
- What information to extract (for example, "extract variable name, type, default,
  and description").
- What NOT to read or include (for example, "do not read `.terraform/` cache
  directories").

### Generation instructions

The `## Generation instructions` section tells the command what to generate for
each doc type. Organize instructions by doc type ID.

For each doc type, specify:
- The sections the generated document must contain.
- What information goes in each section.
- The style binding: "Follow the IBM Documentation Style Guide at
  `~/.claude/references/ibm-documentation-style.md`."
- Any pack-specific formatting conventions (for example, table formats for
  variable references).

### Module boundary detection

The `## Module boundary detection` section defines how to identify scope
boundaries for `per-module` doc types. Specify:
- What constitutes a module boundary for this technology (for example, "a
  directory containing `main.tf`").
- How to discover modules in a directory tree.
- Edge cases to handle (for example, "ignore `examples/` directories").

## Detection scoring

During the scan phase, `/doc-gen` checks each detection signal against the target
directory:

1. Run `find` with the glob pattern. Do not read file contents during detection.
2. If at least one file matches the pattern, add the signal's weight to the total.
3. After checking all signals, compare the total to `min-confidence`.
4. If the total meets or exceeds `min-confidence`, the pack qualifies.

Multiple packs can qualify for the same repository. The command proposes all
qualifying packs and lets the user select.

## Generated-by marker

The `/doc-gen` command appends a marker to every generated file. Template packs do
not need to include this marker in their generation instructions. The command
handles it automatically.

Format:
```markdown
---
<!-- doc-gen | pack: <name> | type: <doc-type-id> | date: <YYYY-MM-DD> -->
```

## Adding a new template pack

To create a new template pack:

1. Create a directory under `templates/doc-gen/` with the pack name.
2. Create a `pack.md` file following this specification.
3. Define detection signals that are specific enough to avoid false positives.
   Generic patterns (for example, `*.yaml`) should have low weight.
4. Define doc types with output paths that follow the universal `docs/` skeleton.
5. Write context-gathering and generation instructions that reference the IBM
   Documentation Style Guide.
6. Test detection in repos that match and repos that do not match.
