#!/usr/bin/env bash
# IBM Documentation Style — standalone installer (macOS / Linux).
# Installs the reference file and /doc-style command into ~/.claude
# (or $CLAUDE_CONFIG_DIR). Does NOT require the full dotclaude repo.
#
# Usage:  ./install.sh
set -euo pipefail

PKG="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
TS="$(date +%Y%m%d-%H%M%S)"

backup() { [ -e "$1" ] && cp -a "$1" "$1.bak-$TS" && echo "  backed up $(basename "$1")" || true; }

echo "Installing IBM Documentation Style into: $CLAUDE_DIR"

for d in references commands; do
  mkdir -p "$CLAUDE_DIR/$d"
  for f in "$PKG/$d"/*; do
    [ -f "$f" ] || continue
    backup "$CLAUDE_DIR/$d/$(basename "$f")"
    cp -a "$f" "$CLAUDE_DIR/$d/"
    echo "  installed $d/$(basename "$f")"
  done
done

echo ""
echo "Installed. Two manual steps remain:"
echo ""
echo "1. Add the CLAUDE.md snippet to your global or project CLAUDE.md."
echo "   The snippet is at: $PKG/snippets/claude-md-snippet.md"
echo ""
echo "2. (Optional) Integrate with /review-pr."
echo "   Instructions at: $PKG/snippets/review-pr-agent-snippet.md"
echo ""
echo "Restart Claude Code to load the new command."
