---
name: claude-code-config-setup
description: "Global ~/.claude config hardening adapted from Trail of Bits — Node hooks, deny-rules, statusline, Stop-gate; the non-obvious why."
metadata: 
  node_type: memory
  type: project
  originSessionId: 2684b3e5-7aef-46b7-ab93-c30586d9d516
---

On 2026-06-18, cherry-picked the Trail of Bits `claude-code-config` repo into slim local pieces in global `~/.claude` (`C:\Users\juanp\.claude`). Adapted per [[tooling-adoption-approach]] and [[user-profile]] (cost-sensitive, cross-platform Mac+Windows).

**Installed (global scope):**
- `settings.json` — privacy env (`DISABLE_TELEMETRY`/`DISABLE_ERROR_REPORTING`/`CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY`), `enableAllProjectMcpServers:false`, credential `permissions.deny` (ssh/gpg/aws/azure/kube/gh/npmrc/git-credentials/shell-rc/`**/.env`/pem/keychain), `statusLine`, plus new `PreToolUse`(git) and `Stop` hooks. Existing learn-loop SessionStart/SessionEnd/PreCompact hooks were preserved by merge.
- `hooks/block-main-push.mjs` — blocks direct commit/push to main|master.
- `statusline.mjs` — model · branch · folder / cost · duration · lines.
- `CLAUDE.md` (global, added 2026-06-19) — the **universal working agreement**: code gate (no non-trivial code/script/config/infra change until the plan is approved), working style (decisive, push-back, ADRs-as-files, audit-shop/PR rigor), and default context (day-to-day = Windows admin/infra; Moʻolelo is siloed/opt-in). Loads in every session regardless of cwd — this is the home for behavior that must be universal, since per-project memory is cwd-scoped. See [[workspace-siloing]].

**Non-obvious decisions (not visible in the files):**
- **Hooks are Node `.mjs`, not ToB's bash+jq** — because `jq` is NOT installed but Node is, and learn-loop hooks already use `.mjs`. Matched that pattern; no new tooling needed.
- **Hook paths are hardcoded Windows** (`C:\Users\juanp\...`), matching the existing learn-loop convention. **On Mac these need path swaps** — settings.json is effectively the Windows copy, not synced verbatim.
- **Stop-gate is a global prompt hook** (fires a Haiku call every turn, all projects). I recommended scoping it to Moʻolelo for cost; user chose global anyway. If cost drips, this is the first knob to revisit.
- **`.env.example` deliberately left OUT of deny-rules** (deny can't be per-prompt overridden; would block harmless reads).

**Added 2026-06-19 (PR-heavy adoption — user wants audit-shop practices even solo):**
- `statusline.mjs` — context-usage bar built (tail-reads `transcript_path`, sums input+cache tokens / 200k window, ANSI green/yellow/red). Validated end-to-end with a synthetic transcript.
- `~/.claude/commands/ship-issue.md` — global, **platform-neutral** `/ship-issue <n>` command: issue → branch → plan→**gate** → implement → verify → PR → `/code-review`. Composes with workflow-mode; never auto-merges; respects the **universal code gate** (no implementation code until the plan is approved — see `~/.claude/CLAUDE.md`).
- Did NOT rebuild ToB's `/review-pr` — `/code-review ultra` already covers multi-agent review natively.

**Open follow-ups:**
- Statusline `cost`/`workspace`/`model`/`transcript_path` field names assumed from docs; confirm against a live invocation after a session restart and patch if blank.

**Moʻolelo-specific CI/PR artifacts** (moolelo-pr-kit staging bundle, Swift/Xcode `ci.yml`, branch-protection order-of-ops, Swift CLAUDE.md follow-up) were moved to the Moʻolelo memory scope — see `moolelo-ci-pr-kit` there, per [[workspace-siloing]].
