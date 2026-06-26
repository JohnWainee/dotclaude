---
allowed-tools: Read, Bash(find:*), Bash(ls:*), Bash(wc:*)
description: >
  Scan a repository, propose a documentation plan, and generate
  IBM-style-conformant docs from pluggable template packs.
  Scan-then-propose — never auto-writes.
argument-hint: "[directory] [--pack <name>] [--type <doc-type>] [--list-packs] [--dry-run]"
---

Generate documentation for a repository using pluggable template packs.

**Before anything else**, load the two binding references (honor
`$CLAUDE_CONFIG_DIR` if set):

1. Read `~/.claude/references/ibm-documentation-style.md` in full. Every
   generated document must conform to this style guide.
2. Read `~/.claude/references/doc-gen-template-spec.md` in full. This defines
   the template pack format you will parse.

## Parse arguments

- `[directory]` — Target directory to scan. Default: current working directory.
- `--pack <name>` — Force a specific template pack instead of auto-detecting.
- `--type <doc-type>` — Generate only a specific doc type from the matched pack.
- `--list-packs` — List available template packs and exit.
- `--dry-run` — Scan and propose but skip the approval gate (show what would be
  generated without asking).

## Step 1: Discover template packs

Find all template packs by listing directories under
`~/.claude/templates/doc-gen/`. For each directory, read the `pack.md` file and
parse its YAML frontmatter.

Build a registry of available packs with their name, description, detection
signals, and doc types.

If `--list-packs` was specified, display all discovered packs in this format and
stop:

```
Available template packs:

  terraform — Documentation for Terraform configurations — module references,
              variable catalogs, state management runbooks, and troubleshooting
              guides.
              Doc types: project-readme, module-readme, variable-reference,
                         output-reference, state-runbook, troubleshooting

  kubernetes — Documentation for Kubernetes manifests and Helm charts — workload
               references, deployment runbooks, and troubleshooting guides.
               Doc types: project-readme, workload-reference, helm-values,
                          deploy-runbook, rollback-runbook, troubleshooting
```

## Step 2: Scan the target directory

For each discovered template pack, check its detection signals against the target
directory.

For each detection signal:
1. Run `find <target> -name "<pattern>"` (limit depth to 5 levels).
2. If at least one file matches, add the signal's weight to the pack's total score.
3. Record the number of matching files for the proposal.

**Do not read file contents during detection.** Only check file existence.

If `--pack <name>` was specified, skip detection and use that pack directly. Error
if the pack does not exist.

After scoring, a pack qualifies if its total score meets or exceeds its
`min-confidence` threshold.

If no packs qualify, report:

```
No matching template packs found for <target>.

Checked: terraform (score 0/3), kubernetes (score 0/3)

Use --pack <name> to force a specific pack, or --list-packs to see available packs.
```

Then stop.

## Step 3: Discover module boundaries

For each qualifying pack, read its `## Module boundary detection` section and
identify scope boundaries in the target directory.

- For `per-repo` doc types: the entire target directory is the scope.
- For `per-module` doc types: scan the directory structure to identify modules
  using the pack's boundary rules. List each discovered module with its path.
- For `per-directory` doc types: each subdirectory under the target is a scope.

## Step 4: Check for conflicts

Before proposing, check whether the target directory already has a `docs/`
directory or any files at the proposed output paths.

- If `docs/` exists with content, note this in the proposal as a warning.
- If any proposed output path conflicts with an existing file, flag it
  explicitly. Never overwrite an existing file without the user confirming.

## Step 5: Propose the documentation plan

Present a structured proposal listing everything that will be generated.

Format the proposal as a checklist:

```
## Documentation plan for <target>

### Template pack: Terraform (confidence: 8/3)
Detected: *.tf (12 files), terraform.tfvars (1 file), .terraform.lock.hcl (1 file)

Modules discovered:
- . (root module)
- modules/vpc
- modules/ec2

Files to generate:
- [ ] docs/README.md — project documentation overview
- [ ] docs/modules/vpc/README.md — module reference
- [ ] docs/modules/vpc/variables.md — variable reference
- [ ] docs/modules/vpc/outputs.md — output reference
- [ ] docs/modules/ec2/README.md — module reference
- [ ] docs/modules/ec2/variables.md — variable reference
- [ ] docs/modules/ec2/outputs.md — output reference
- [ ] docs/runbooks/state-management.md — state management runbook
- [ ] docs/troubleshooting/terraform.md — troubleshooting guide

Total: 9 files

Approve this plan? You can remove items from the checklist before approving.
```

If `--type <doc-type>` was specified, include only that doc type in the proposal.

If `--dry-run` was specified, display the proposal and stop without asking for
approval.

**STOP here and wait for the user to approve.** Do not generate any files until
the user explicitly approves the plan.

## Step 6: Generate documentation

After the user approves, generate each approved file one at a time.

For each file:

1. **Read the pack's context-gathering instructions** for that doc type.
2. **Read the source files** specified by the context-gathering instructions. This
   is where content reading happens — after approval, not before.
3. **Follow the pack's generation instructions** for that doc type.
4. **Apply IBM Documentation Style Guide rules** throughout:
   - Active voice, present tense, second person.
   - Short sentences (20 words or fewer preferred).
   - Task-oriented headings in sentence case.
   - Parallel structure in lists and headings at the same level.
   - Spell out abbreviations on first use.
   - Serial comma; no exclamation marks.
   - Descriptive link text.
   - Inclusive, jargon-free language.
5. **Create the directory** if it does not exist.
6. **Write the file** to the specified output path.
7. **Append the generated-by marker** as the last lines of the file:
   ```
   ---
   <!-- doc-gen | pack: <pack-name> | type: <doc-type-id> | date: <YYYY-MM-DD> -->
   ```

Generate files sequentially, not in parallel. Report each file as it is written:

```
  wrote docs/modules/vpc/README.md
  wrote docs/modules/vpc/variables.md
  ...
```

## Step 7: Generate the docs index

After all individual files are generated, create or update `docs/README.md` as the
last file. This file serves as the documentation index and must link to every
generated file with a brief description.

If `docs/README.md` was already generated by a pack's `project-readme` doc type,
append links to any files not already referenced.

## Step 8: Post-generation summary

After all files are written, output a summary:

```
## Generation complete

Generated <N> files in docs/:
- docs/README.md
- docs/modules/vpc/README.md
- docs/modules/vpc/variables.md
- ...

Run `/doc-style docs/` to audit the generated documentation against IBM style.
```

Do **not** automatically run `/doc-style`. Only suggest it.
