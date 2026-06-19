#!/usr/bin/env node
// PreToolUse(Bash) — block direct commits/pushes to main|master; force feature branches.
// Cross-platform (Node). Reads hook JSON on stdin, exits 2 to block.
import { execSync } from "node:child_process";

let raw = "";
process.stdin.on("data", (d) => (raw += d));
process.stdin.on("end", () => {
  let cmd = "";
  try { cmd = JSON.parse(raw).tool_input?.command ?? ""; } catch {}

  const isPush = /\bgit\s+push\b/.test(cmd);
  const isCommit = /\bgit\s+commit\b/.test(cmd);
  if (!isPush && !isCommit) process.exit(0);

  let branch = "";
  try {
    branch = execSync("git rev-parse --abbrev-ref HEAD", {
      stdio: ["ignore", "pipe", "ignore"],
    }).toString().trim();
  } catch {}

  const targetsProtected =
    /\borigin\s+(main|master)\b/.test(cmd) || /^(main|master)$/.test(branch);

  if (targetsProtected) {
    console.error(
      `Blocked: direct ${isPush ? "push" : "commit"} to ${branch || "main"}. ` +
        `Create a feature branch first (git switch -c feat/...).`
    );
    process.exit(2);
  }
  process.exit(0);
});
