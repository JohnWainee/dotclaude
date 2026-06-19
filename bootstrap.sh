#!/usr/bin/env bash
# dotclaude bootstrap (macOS / Linux).
# Installs the tracked Claude Code config into ~/.claude (or $CLAUDE_CONFIG_DIR),
# renders settings.json with this machine's absolute path, and files the
# day-to-day memory under this machine's project hash.
#
# Usage:  ./bootstrap.sh [WORKSPACE_DIR]
#   WORKSPACE_DIR = the directory you launch day-to-day Claude sessions from,
#                   used to compute the memory project hash. Default: ~/Downloads
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
WORKSPACE="${1:-$HOME/Downloads}"
TS="$(date +%Y%m%d-%H%M%S)"

backup() { [ -e "$1" ] && cp -a "$1" "$1.bak-$TS" && echo "  backed up $1 -> $(basename "$1").bak-$TS" || true; }

echo "Installing dotclaude into: $CLAUDE_DIR"
mkdir -p "$CLAUDE_DIR"

# --- single files ---
for f in CLAUDE.md statusline.mjs; do
  backup "$CLAUDE_DIR/$f"
  cp -a "$REPO/$f" "$CLAUDE_DIR/$f"
done

# --- directories (merge) ---
for d in skills commands hooks; do
  mkdir -p "$CLAUDE_DIR/$d"
  cp -a "$REPO/$d/." "$CLAUDE_DIR/$d/"
done

# --- render settings.json (forward-slash absolute path; node accepts it on all OSes) ---
backup "$CLAUDE_DIR/settings.json"
sed "s#__CLAUDE_DIR__#${CLAUDE_DIR}#g" "$REPO/settings.template.json" > "$CLAUDE_DIR/settings.json"
echo "  rendered settings.json"

# --- day-to-day memory under this machine's project hash ---
PROJ="$(printf '%s' "$WORKSPACE" | sed 's#[:/\\]#-#g')"
DEST="$CLAUDE_DIR/projects/$PROJ/memory"
mkdir -p "$DEST"
cp -a "$REPO/memory/." "$DEST/"
echo "  memory -> $DEST  (workspace: $WORKSPACE)"

echo "Done. Restart Claude Code to load. (Node v18+ required for hooks.)"
