#!/usr/bin/env node
// SessionStart hook: if sessions are queued un-codified, nudge to run /learn-loop.
import { readFileSync, existsSync } from 'node:fs';
import { homedir } from 'node:os';
import { join } from 'node:path';

const dir = process.env.LEARN_LOOP_DIR || join(homedir(), '.claude', 'learn-loop');
const file = join(dir, 'pending.jsonl');

let n = 0;
try {
  if (existsSync(file)) {
    n = readFileSync(file, 'utf8').split('\n').filter((l) => l.trim()).length;
  }
} catch { /* unreadable queue → no nudge */ }

if (n > 0) {
  const msg = `learn-loop: ${n} prior session(s) not yet codified. Run /learn-loop `
    + `to capture reusable facts and procedures into memory/ and skill drafts; `
    + `the queue clears once the pass completes.`;
  process.stdout.write(JSON.stringify({
    hookSpecificOutput: { hookEventName: 'SessionStart', additionalContext: msg },
  }));
}
process.exit(0);
