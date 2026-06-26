#!/usr/bin/env bash
# doc-gen — standalone installer (macOS / Linux).
# Installs the /doc-gen command, template pack spec, and template packs into
# ~/.claude (or $CLAUDE_CONFIG_DIR). Does NOT require the full dotclaude repo.
#
# Prerequisite: the IBM Documentation Style package must be installed separately.
#
# Usage:  ./install.sh
set -euo pipefail

PKG="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
TS="$(date +%Y%m%d-%H%M%S)"

backup() { [ -e "$1" ] && cp -a "$1" "$1.bak-$TS" && echo "  backed up $(basename "$1")" || true; }

echo "Installing doc-gen into: $CLAUDE_DIR"

for d in commands references; do
  mkdir -p "$CLAUDE_DIR/$d"
  for f in "$PKG/$d"/*; do
    [ -f "$f" ] || continue
    backup "$CLAUDE_DIR/$d/$(basename "$f")"
    cp -a "$f" "$CLAUDE_DIR/$d/"
    echo "  installed $d/$(basename "$f")"
  done
done

# --- template packs ---
if [ -d "$PKG/templates" ]; then
  cp -a "$PKG/templates/." "$CLAUDE_DIR/templates/"
  echo "  installed templates/"
fi

echo ""

# --- check for IBM style dependency ---
if [ ! -f "$CLAUDE_DIR/references/ibm-documentation-style.md" ]; then
  echo "WARNING: IBM Documentation Style reference not found."
  echo "  /doc-gen requires the IBM doc style package as a dependency."
  echo "  Install it first from packages/ibm-doc-style/ or"
  echo "  https://github.com/JohnWainee/dotclaude"
  echo ""
fi

echo "Installed. Restart Claude Code to load the new /doc-gen command."
