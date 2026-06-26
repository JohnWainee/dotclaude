# dotclaude

Portable Claude Code configuration — synced across machines (Windows + macOS).
Clone, run the bootstrap, restart Claude Code.

## What's here

| Path | What it is |
|------|------------|
| `CLAUDE.md` | Universal working agreement — code gate + working style, loaded in every session, every directory. |
| `skills/` | Home-built skills: `learn-loop` (local capture→codify), `workflow-mode` (lifecycle discipline). |
| `commands/ship-issue.md` | `/ship-issue <n>` — drive a GitHub issue to a reviewed PR. Platform-neutral. |
| `commands/review-pr.md` | `/review-pr <pr>` — adversarial multi-agent PR review (guilty-until-proven-innocent, confidence-gated ≥80), wired to the adversarial checklist. |
| `references/` | Loadable review references: `adversarial-review-checklist.md` (language-agnostic, attach to `/code-review` or auto-loaded by `/review-pr`). |
| `packages/ibm-doc-style/` | IBM Documentation Style — comprehensive reference, `/doc-style` audit command, and `/review-pr` integration. Self-contained; extractable as a standalone repo. |
| `hooks/block-main-push.mjs` | PreToolUse(Bash) guard — blocks direct commit/push to `main`/`master`. |
| `statusline.mjs` | Status line (model · branch · folder / cost · duration · context bar). |
| `settings.template.json` | Settings with a `__CLAUDE_DIR__` placeholder; bootstrap renders it per machine. |
| `memory/` | Day-to-day knowledge layer (general profile, config notes, dev-env, siloing rule). |
| `docs/adr/` | Architecture decision records (e.g. ADR-001 code-review augmentation, ADR-002 PowerShell/IaC checklists). |

**Deliberately excluded:** credentials, caches, `settings.local.json` (per-machine
overrides), session transcripts, and the Moʻolelo project memory scope (kept off GitHub).

## Install

**macOS / Linux**
```bash
git clone git@github.com:JohnWainee/dotclaude.git
cd dotclaude
./bootstrap.sh            # or: ./bootstrap.sh ~/code   (your day-to-day workspace dir)
```

**Windows (PowerShell)**
```powershell
git clone https://github.com/JohnWainee/dotclaude.git
cd dotclaude
.\bootstrap.ps1          # or: .\bootstrap.ps1 -Workspace C:\Users\you\Downloads
```

The bootstrap **backs up** any existing file (`*.bak-<timestamp>`) before overwriting.

## How portability works

- **`settings.json` is rendered, not symlinked.** The committed template carries a
  `__CLAUDE_DIR__` token; bootstrap substitutes this machine's config dir as a
  forward-slash absolute path (e.g. `C:/Users/you/.claude` or `/Users/you/.claude`).
  `node` accepts forward-slash paths on every OS, so hooks and the status line work
  regardless of whether they run via cmd.exe, Git Bash, or zsh.
- **Memory is cwd-scoped.** Claude stores per-project memory under a directory named
  after the *working directory* (`C:\Users\you\Downloads` → `C--Users-you-Downloads`).
  Because that path differs per machine, bootstrap recomputes the hash from your
  `WORKSPACE` arg and files `memory/` there. Pass the workspace dir if it isn't
  `~/Downloads`.
- **Hooks need Node** (v18+) on `PATH` as `node`.

## Updating

Pull and re-run bootstrap (it's idempotent and backs up first):
```bash
git pull && ./bootstrap.sh
```
To push changes *back*: edit files in `~/.claude`, copy the changed ones into this
repo, commit on a feature branch, and open a PR (the `main` guard is intentional).
