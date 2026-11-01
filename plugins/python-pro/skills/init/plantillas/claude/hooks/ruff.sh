#!/usr/bin/env bash
# Runs after Claude edits a file. Formats and lints Python files with Ruff.
# Exit code 2 sends the problems Ruff could not fix back to Claude.
set -u

# uv installs here by default; the editor may not have it in its PATH yet
export PATH="$HOME/.local/bin:$PATH"

input="$(cat)"
file="$(printf '%s' "$input" | python3 -c 'import json, sys; print(json.load(sys.stdin).get("tool_input", {}).get("file_path", ""))' 2>/dev/null || true)"

case "$file" in
  *.py) ;;
  *) exit 0 ;;
esac

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0

if ! command -v uv > /dev/null 2>&1; then
  echo "ruff hook: uv not found, skipping format and lint" >&2
  exit 0
fi

uv run ruff format "$file" > /dev/null 2>&1
# Unused imports and variables are ignored here (they may be used in the next edit);
# the final `uv run ruff check` of each task still reports them.
if ! output="$(uv run ruff check --fix --ignore F401,F841 "$file" 2>&1)"; then
  printf '%s\n' "$output" >&2
  exit 2
fi
exit 0
