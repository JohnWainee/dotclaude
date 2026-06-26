# doc-gen for Claude Code

Scan a repository, propose a documentation plan, and generate
IBM-style-conformant docs from pluggable template packs.

## What you get

| Component | Description |
|-----------|-------------|
| `commands/doc-gen.md` | `/doc-gen` command — scan, propose, and generate documentation. |
| `references/doc-gen-template-spec.md` | Template pack format specification. |
| `templates/doc-gen/terraform/pack.md` | Terraform template pack (modules, variables, runbooks, troubleshooting). |
| `templates/doc-gen/kubernetes/pack.md` | Kubernetes template pack (workloads, Helm values, runbooks, troubleshooting). |

## Prerequisites

This package depends on the
[IBM Documentation Style](../ibm-doc-style/README.md) package. Install it first.
The `/doc-gen` command loads `ibm-documentation-style.md` before generating any
output.

## Install (standalone)

You do not need the full [dotclaude](https://github.com/JohnWainee/dotclaude)
repo. Clone or download this directory and run the installer.

**macOS / Linux:**

```bash
cd doc-gen
chmod +x install.sh
./install.sh
```

**Windows (PowerShell):**

```powershell
cd doc-gen
.\install.ps1
```

The installer copies `commands/`, `references/`, and `templates/` into
`~/.claude/` (or `$CLAUDE_CONFIG_DIR`). It backs up existing files before
overwriting and warns if the IBM style dependency is missing.

Restart Claude Code to load the new `/doc-gen` command.

## Install (via dotclaude)

If you use the full dotclaude repo, the bootstrap script installs this package
automatically. No separate steps are needed.

## Use

### Scan and generate

```
/doc-gen                          # Scan current directory, auto-detect packs
/doc-gen ./my-terraform-repo      # Scan a specific directory
/doc-gen --pack terraform         # Skip detection, use a specific pack
/doc-gen --type module-readme     # Generate only one doc type
/doc-gen --dry-run                # Show proposal without generating
/doc-gen --list-packs             # List available template packs
```

### Workflow

1. `/doc-gen` scans the target directory for file patterns that match installed
   template packs.
2. It discovers module boundaries (Terraform modules, Helm charts, Kustomize
   bases).
3. It presents a checklist of files to generate. You can remove items before
   approving.
4. After you approve, it reads source files and generates documentation one file
   at a time.
5. Every generated file conforms to the IBM Documentation Style Guide.

### Output structure

Generated docs follow a universal `docs/` skeleton:

```
docs/
  README.md                    # Index and overview
  modules/                     # Per-module reference docs
    {module-name}/
      README.md
      variables.md             # Terraform
      outputs.md               # Terraform
  runbooks/                    # Operational procedures
  troubleshooting/             # Symptom-based troubleshooting
  guides/                      # How-to guides
  reference/                   # Reference material (Helm values, etc.)
```

### Post-generation

After generating, run `/doc-style docs/` to audit the output against the IBM
Documentation Style Guide. The `/doc-gen` command suggests this but does not run
it automatically, keeping compute under your control.

## Template packs

### Terraform

Generates documentation for Terraform configurations:
- Project overview
- Module references (per module)
- Variable references (per module)
- Output references (per module)
- State management runbook
- Troubleshooting guide

### Kubernetes

Generates documentation for Kubernetes manifests and Helm charts:
- Project overview
- Workload references (per workload)
- Helm values reference
- Deployment runbook
- Rollback runbook
- Troubleshooting guide

### Adding custom packs

Create a directory under `~/.claude/templates/doc-gen/` with a `pack.md` file
following the specification in `references/doc-gen-template-spec.md`. The
`/doc-gen` command discovers new packs automatically.

## Extracting to a standalone repo

This directory is self-contained. To publish it as a separate repository:

```bash
cp -r packages/doc-gen /path/to/new-repo
cd /path/to/new-repo
git init && git add . && git commit -m "Initial commit: doc-gen package"
```

No edits are needed. The install scripts, command, reference, and templates work
as-is. Users must install the IBM doc style package separately.
