#!/usr/bin/env bash
# Builds throwaway projects with the init procedure and checks that they work.
# Needs: uv, python3, git. Run from anywhere: bash scripts/smoke-test.sh
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skill="$repo/plugins/python-pro/skills/init"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

fail() { echo "FAIL: $*" >&2; exit 1; }

echo "== JSON files are valid"
while IFS= read -r f; do
  python3 -m json.tool "$f" > /dev/null || fail "invalid JSON: $f"
done < <(find "$repo/.claude-plugin" "$repo/plugins" -name '*.json' ! -path '*/plantillas/*')

echo "== Shell scripts have valid syntax"
for f in "$skill/scripts/montar.sh" "$skill/plantillas/claude/hooks/ruff.sh" "$repo/install.sh" "$repo/scripts/smoke-test.sh"; do
  bash -n "$f" || fail "syntax error: $f"
done

for mode in manual auto; do
  echo "== Project with push mode: $mode"
  proj="$work/demo-app-$mode"
  mkdir "$proj"
  cd "$proj"
  git config --global --get user.email > /dev/null 2>&1 || git config --global user.email "ci@example.com"
  git config --global --get user.name > /dev/null 2>&1 || git config --global user.name "CI"

  uv init --package > /dev/null 2>&1
  uv add --dev pytest ruff > /dev/null 2>&1
  bash "$skill/scripts/montar.sh" "$mode" > /dev/null

  pkg="demo_app_$mode"
  [ -f "src/$pkg/__main__.py" ] || fail "missing __main__.py"
  [ -f CLAUDE.md ] && [ -f DEVELOPMENT.md ] && [ -f .claude/dev-journal.md ] || fail "missing top-level files"
  [ -f .claude/skills/py-tarea/SKILL.md ] && [ -f .claude/skills/py-refactor/SKILL.md ] || fail "missing skills"
  [ -x .claude/hooks/ruff.sh ] || fail "hook is not executable"

  if grep -R -n '{{' . --include='*' --exclude-dir=.venv --exclude-dir=.git > /dev/null; then
    grep -R -n '{{' . --exclude-dir=.venv --exclude-dir=.git >&2
    fail "unfilled placeholder"
  fi
  python3 -m json.tool .claude/settings.json > /dev/null || fail "invalid .claude/settings.json"
  python3 -m json.tool .vscode/launch.json > /dev/null || fail "invalid launch.json"

  if [ "$mode" = auto ]; then
    grep -q 'git push' .claude/settings.json || fail "auto mode must allow git push"
    grep -q 'run `git push` without asking' CLAUDE.md || fail "auto rule missing"
  else
    grep -q 'git push' .claude/settings.json && fail "manual mode must not allow git push"
    grep -q 'Never run `git push`' CLAUDE.md || fail "manual rule missing"
  fi

  uv run pytest -q > /dev/null || fail "pytest failed"
  uv run ruff check > /dev/null || fail "ruff check failed"
  uv run start | grep -q Hello || fail "uv run start did not print the greeting"
  uv run python -m "$pkg" | grep -q Hello || fail "python -m $pkg failed"

  echo "   hook: formats a file and reports what Ruff cannot fix"
  printf 'import os\nx   =  1\n' > "src/$pkg/messy.py"
  json="{\"tool_input\": {\"file_path\": \"$proj/src/$pkg/messy.py\"}}"
  set +e
  printf '%s' "$json" | CLAUDE_PROJECT_DIR="$proj" .claude/hooks/ruff.sh > /dev/null 2> "$work/hook.err"
  code=$?
  set -e
  [ "$code" -eq 0 ] || fail "hook should fix the unused import and succeed, got exit $code: $(cat "$work/hook.err")"
  grep -q 'x = 1' "src/$pkg/messy.py" || fail "hook did not format the file"
  printf 'def f():\n    return undefined_name\n' > "src/$pkg/broken.py"
  json="{\"tool_input\": {\"file_path\": \"$proj/src/$pkg/broken.py\"}}"
  set +e
  printf '%s' "$json" | CLAUDE_PROJECT_DIR="$proj" .claude/hooks/ruff.sh > /dev/null 2> "$work/hook.err"
  code=$?
  set -e
  [ "$code" -eq 2 ] || fail "hook should exit 2 when Ruff finds a problem, got $code"
  [ -s "$work/hook.err" ] || fail "hook should print the problem on stderr"
  rm "src/$pkg/messy.py" "src/$pkg/broken.py"

  git add -A
  git commit -q -m "chore: initial project scaffold"
  git ls-files | grep -q '^\.claude/dev-journal\.md$' && fail "journal must not be tracked"
  cd "$repo"
done

echo "== install.sh copies the skill"
home="$work/home"
mkdir "$home"
HOME="$home" CLAUDE_CONFIG_DIR="$home/.claude" bash "$repo/install.sh" > /dev/null
[ -f "$home/.claude/skills/python-init/SKILL.md" ] || fail "install.sh did not install the skill"
[ -f "$home/.claude/skills/python-init/scripts/montar.sh" ] || fail "install.sh did not copy scripts"
[ -f "$home/.claude/skills/python-init/plantillas/CLAUDE.md" ] || fail "install.sh did not copy templates"

echo "All checks passed."
