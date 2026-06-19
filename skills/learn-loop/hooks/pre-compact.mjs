#!/usr/bin/env node
// PreCompact hook: remind to codify before context is summarized away.
// Best-effort — if the harness ignores additionalContext here, the
// SessionEnd→SessionStart path still catches the session next run.
const msg = 'learn-loop: context is about to be compacted. If this session '
  + 'established durable facts, decisions, corrections, or a repeatable '
  + 'procedure, run the /learn-loop codify pass now so they survive the summary.';

process.stdout.write(JSON.stringify({
  hookSpecificOutput: { hookEventName: 'PreCompact', additionalContext: msg },
}));
process.exit(0);
