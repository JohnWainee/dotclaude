#!/usr/bin/env node
// statusLine — two lines:
//   1) model · branch · folder
//   2) context-usage bar · cost · duration · lines
// Defensive: unknown fields render blank, never throws. No jq dependency.
import { execSync } from "node:child_process";
import { openSync, fstatSync, readSync, closeSync } from "node:fs";

const CONTEXT_WINDOW = 200000; // approx usable window; adjust if model differs

// ANSI colors (statusline supports them)
const c = (code, s) => `\x1b[${code}m${s}\x1b[0m`;
const GREEN = 32, YELLOW = 33, RED = 31, DIM = 90;

function tailLines(path, maxBytes = 65536) {
  // Read only the last maxBytes of a possibly-huge JSONL transcript.
  let fd;
  try {
    fd = openSync(path, "r");
    const size = fstatSync(fd).size;
    const len = Math.min(size, maxBytes);
    const buf = Buffer.allocUnsafe(len);
    readSync(fd, buf, 0, len, size - len);
    const text = buf.toString("utf8");
    // Drop the first (likely partial) line when we didn't start at byte 0.
    const lines = text.split("\n").filter(Boolean);
    if (size > maxBytes && lines.length) lines.shift();
    return lines;
  } catch {
    return [];
  } finally {
    if (fd !== undefined) try { closeSync(fd); } catch {}
  }
}

function contextUsed(transcriptPath) {
  if (!transcriptPath) return null;
  const lines = tailLines(transcriptPath);
  for (let i = lines.length - 1; i >= 0; i--) {
    let u;
    try { u = JSON.parse(lines[i])?.message?.usage; } catch { continue; }
    if (u && (u.input_tokens != null || u.cache_read_input_tokens != null)) {
      return (
        (u.input_tokens ?? 0) +
        (u.cache_read_input_tokens ?? 0) +
        (u.cache_creation_input_tokens ?? 0)
      );
    }
  }
  return null;
}

function contextBar(used) {
  if (used == null) return "";
  const pct = Math.min(100, Math.round((used / CONTEXT_WINDOW) * 100));
  const filled = Math.round(pct / 10);
  const bar = "▰".repeat(filled) + "▱".repeat(10 - filled);
  const color = pct < 50 ? GREEN : pct < 80 ? YELLOW : RED;
  return c(color, `ctx ${pct}% ${bar}`);
}

let raw = "";
process.stdin.on("data", (d) => (raw += d));
process.stdin.on("end", () => {
  let j = {};
  try { j = JSON.parse(raw); } catch {}

  const model = j.model?.display_name ?? j.model?.id ?? "claude";
  const cwd = j.workspace?.current_dir ?? j.cwd ?? process.cwd();
  const dir = cwd.split(/[\\/]/).filter(Boolean).pop() || "~";

  let branch = "";
  try {
    branch = execSync("git rev-parse --abbrev-ref HEAD", {
      stdio: ["ignore", "pipe", "ignore"],
      cwd,
    }).toString().trim();
  } catch {}

  const cost = j.cost?.total_cost_usd;
  const ms = j.cost?.total_duration_ms;
  const add = j.cost?.total_lines_added;
  const del = j.cost?.total_lines_removed;

  const money = cost != null ? `$${Number(cost).toFixed(3)}` : "";
  const time = ms != null ? `${Math.round(ms / 1000)}s` : "";
  const lines = add != null || del != null ? `+${add ?? 0}/-${del ?? 0}` : "";
  const ctx = contextBar(contextUsed(j.transcript_path));

  console.log(
    [model, branch && c(DIM, `⎇ ${branch}`), c(DIM, dir)].filter(Boolean).join("  ·  ")
  );
  console.log([ctx, money, time, lines].filter(Boolean).join("  ·  "));
});
