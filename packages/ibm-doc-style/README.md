# IBM Documentation Style for Claude Code

Comprehensive IBM Documentation Style Guide enforcement for Claude Code.
Includes a style reference, an on-demand audit command (`/doc-style`), and
integration instructions for PR reviews.

## What you get

| Component | Description |
|-----------|-------------|
| `references/ibm-documentation-style.md` | Actionable checklist: 15 sections with rules and correct/incorrect examples. |
| `commands/doc-style.md` | `/doc-style <file-or-dir>` — audit docs against the full reference. Use `--fix` to propose rewrites. |
| `snippets/claude-md-snippet.md` | ~12-line CLAUDE.md section for always-on enforcement (core rules only). |
| `snippets/review-pr-agent-snippet.md` | Agent #6 text for integrating doc-style checks into `/review-pr`. |

## Install (standalone)

You do not need the full [dotclaude](https://github.com/JohnWainee/dotclaude)
repo. Clone or download this directory and run the installer.

**macOS / Linux:**

```bash
cd ibm-doc-style
chmod +x install.sh
./install.sh
```

**Windows (PowerShell):**

```powershell
cd ibm-doc-style
.\install.ps1
```

The installer copies `references/` and `commands/` into `~/.claude/` (or
`$CLAUDE_CONFIG_DIR`). It backs up existing files before overwriting.

After installing, complete two manual steps:

1. **Add the CLAUDE.md snippet.** Open `snippets/claude-md-snippet.md`, copy
   the markdown block, and paste it into your global `~/.claude/CLAUDE.md` or
   your project's `CLAUDE.md`.

2. **(Optional) Integrate with `/review-pr`.** Follow the instructions in
   `snippets/review-pr-agent-snippet.md` to add a documentation style agent to
   your PR review pipeline.

Restart Claude Code to load the new `/doc-style` command.

## Install (via dotclaude)

If you use the full dotclaude repo, the bootstrap script installs this package
automatically. No separate steps are needed.

## Use

### Always-on (CLAUDE.md)

Once the snippet is in your CLAUDE.md, Claude follows IBM style rules whenever
it writes or edits markdown. Core rules enforced:

- Active voice, present tense, second person ("you").
- Short sentences (20 words or fewer), one idea per sentence.
- Task-oriented headings, sentence case, parallel structure.
- Serial comma, no exclamation marks, no Latin abbreviations.
- Descriptive link text, inclusive language.

### On-demand audit

```
/doc-style README.md              # Audit a single file
/doc-style docs/                  # Audit all .md files in a directory
/doc-style docs/ --recursive      # Include subdirectories
/doc-style README.md --fix        # Audit and propose rewrites
```

Findings use a three-level severity:

- **blocking** — Core IBM principle violated (passive voice throughout, wrong
  person, inaccessible content).
- **important** — Clear style violation (heading hierarchy skipped, Latin
  abbreviations, "click here" links).
- **nit** — Minor polish (slightly long sentence, minor formatting).

### PR review integration

When integrated with `/review-pr`, a dedicated agent checks markdown files in
the PR diff against the full reference. Findings go through the same
confidence-gating pipeline as code review findings (>=80 confidence to report).

## Extracting to a standalone repo

This directory is self-contained. To publish it as a separate repository:

```bash
cp -r packages/ibm-doc-style /path/to/new-repo
cd /path/to/new-repo
git init && git add . && git commit -m "Initial commit: IBM doc style package"
```

No edits are needed. The install scripts, reference, command, and snippets work
as-is.
