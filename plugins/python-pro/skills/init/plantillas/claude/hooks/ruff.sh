#!/usr/bin/env bash
# Runs after Claude edits a file. Formats and lints Python files with Ruff.
# Exit code 2 sends the problems Ruff could not fix back to Claude.
set -u

input="$(cat)"
file="$(printf '%s' "$input" | python3 -c 'import json, sys; print(json.load(sys.stdin).get("tool_input", {}).get("file_path", ""))' 2>/dev/null || true)"

case "$file" in
  *.py) ;;
  *) exit 0 ;;
esac

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0

uv run ruff format "$file" > /dev/null 2>&1
if ! output="$(uv run ruff check --fix "$file" 2>&1)"; then
  printf '%s\n' "$output" >&2
  exit 2
fi
exit 0
