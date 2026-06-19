#!/usr/bin/env node
// SessionEnd hook: append the finished session to the learn-loop pending queue.
// LLM-free and cheap — this is the "Capture" half of the loop.
import { appendFileSync, mkdirSync } from 'node:fs';
import { homedir } from 'node:os';
import { join } from 'node:path';

let raw = '';
process.stdin.setEncoding('utf8');
process.stdin.on('data', (c) => (raw += c));
process.stdin.on('end', () => {
  let d = {};
  try { d = JSON.parse(raw || '{}'); } catch { /* lean: bad/empty stdin → empty record */ }
  const dir = process.env.LEARN_LOOP_DIR || join(homedir(), '.claude', 'learn-loop');
  try {
    mkdirSync(dir, { recursive: true });
    const rec = {
      session_id: d.session_id ?? null,
      cwd: d.cwd ?? null,
      transcript: d.transcript_path ?? null,
      ts: new Date().toISOString(),
    };
    appendFileSync(join(dir, 'pending.jsonl'), JSON.stringify(rec) + '\n');
  } catch { /* never block session teardown on a logging failure */ }
  process.exit(0);
});
