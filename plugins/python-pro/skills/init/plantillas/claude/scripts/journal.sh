#!/usr/bin/env bash
# Adds an entry to .claude/dev-journal.md. Each argument becomes one bullet line.
# Usage: .claude/scripts/journal.sh "What was done" "Decision: ..." "Next: ..."
# Claude uses this script (allowed in .claude/settings.json) because files inside
# .claude/ are protected: editing them directly would ask for permission every time.
set -euo pipefail

if [ "$#" -eq 0 ]; then
  echo 'usage: journal.sh "line" ["line" ...]' >&2
  exit 1
fi

journal="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dev-journal.md"
{
  printf '\n## %s\n' "$(date '+%Y-%m-%d %H:%M')"
  for line in "$@"; do
    printf -- '- %s\n' "$line"
  done
} >> "$journal"
