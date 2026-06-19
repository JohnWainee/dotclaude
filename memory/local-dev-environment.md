---
name: local-dev-environment
description: "Windows dev box specifics for hooks/scripts — no jq, use Node; Git Bash quirks and how to test hooks."
metadata: 
  node_type: memory
  type: reference
  originSessionId: 2684b3e5-7aef-46b7-ab93-c30586d9d516
---

This machine (Windows 11, `HOME=/c/Users/juanp`) for writing Claude Code hooks/scripts:

- **Toolchain present:** Node v22, Git Bash (bash 5.2 msys), git 2.50. PowerShell is primary; Bash tool runs via Git Bash.
- **`jq` is NOT installed.** Write hooks and JSON tooling in **Node `.mjs`**, not bash+jq — this also matches the existing [[custom-agent-skills]] learn-loop hooks. See [[claude-code-config-setup]].
- **Claude Code runs shell-form hooks via Git Bash on Windows** (per the hooks doc), so a single bash/Node script can serve both Mac and Windows — but **hook command paths in `settings.json` are hardcoded Windows** (`C:\Users\juanp\...`); the Mac copy needs path swaps.

**Gotchas when testing a hook by piping sample JSON to it:**
- Node-on-Windows resolves a POSIX `/tmp/...` path to `C:\tmp\...` → `ENOENT`. Use a real Windows path.
- Use **forward-slash Windows paths** in test JSON (e.g. `C:/Users/juanp/Downloads/x.jsonl`): Node accepts them AND they need no `\\` escaping, sidestepping shell-quoting pain. Backslash paths through a heredoc/quotes get mangled into invalid JSON.
- Standard test: `echo '<sample-hook-json>' | node my-hook.mjs; echo "exit=$?"` — assert exit code (2 = block) and stderr.
