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
for f in "$skill/scripts/montar.sh" "$skill/plantillas/claude/hooks/ruff.sh" "$skill/plantillas/claude/scripts/journal.sh" "$repo/scripts/smoke-test.sh"; do
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
  # The auto project is also built with Jupyter notebooks
  if [ "$mode" = auto ]; then extra=jupyter; else extra=""; fi
  if [ -n "$extra" ]; then
    uv add --dev pytest ruff ipykernel nbstripout > /dev/null 2>&1
  else
    uv add --dev pytest ruff > /dev/null 2>&1
  fi
  bash "$skill/scripts/montar.sh" "$mode" $extra > /dev/null

  pkg="demo_app_$mode"
  [ -f "src/$pkg/__main__.py" ] || fail "missing __main__.py"
  [ -f CLAUDE.md ] && [ -f .claude/dev-journal.md ] || fail "missing top-level files"
  [ -f .claude/skills/py-tarea/SKILL.md ] && [ -f .claude/skills/py-refactor/SKILL.md ] || fail "missing skills"
  [ -x .claude/hooks/ruff.sh ] || fail "hook is not executable"

  if grep -R -n '{{' . --include='*' --exclude-dir=.venv --exclude-dir=.git > /dev/null; then
    grep -R -n '{{' . --exclude-dir=.venv --exclude-dir=.git >&2
    fail "unfilled placeholder"
  fi
  python3 -m json.tool .claude/settings.json > /dev/null || fail "invalid .claude/settings.json"
  python3 -m json.tool .vscode/launch.json > /dev/null || fail "invalid launch.json"

  grep -q "## Code style" CLAUDE.md && grep -q "docs/design.md" .claude/skills/py-tarea/SKILL.md || fail "style guide or design phase missing"

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
  printf 'import sys\nimport os\n\nx   =  1\n' > "src/$pkg/messy.py"
  json="{\"tool_input\": {\"file_path\": \"$proj/src/$pkg/messy.py\"}}"
  set +e
  printf '%s' "$json" | CLAUDE_PROJECT_DIR="$proj" .claude/hooks/ruff.sh > /dev/null 2> "$work/hook.err"
  code=$?
  set -e
  [ "$code" -eq 0 ] || fail "hook should sort imports, keep unused ones and succeed, got exit $code: $(cat "$work/hook.err")"
  grep -q 'x = 1' "src/$pkg/messy.py" || fail "hook did not format the file"
  [ "$(head -n 1 "src/$pkg/messy.py")" = "import os" ] || fail "hook did not sort the imports"
  grep -q '^import sys' "src/$pkg/messy.py" || fail "hook must not remove an unused import"
  printf 'def f():\n    return undefined_name\n' > "src/$pkg/broken.py"
  json="{\"tool_input\": {\"file_path\": \"$proj/src/$pkg/broken.py\"}}"
  set +e
  printf '%s' "$json" | CLAUDE_PROJECT_DIR="$proj" .claude/hooks/ruff.sh > /dev/null 2> "$work/hook.err"
  code=$?
  set -e
  [ "$code" -eq 2 ] || fail "hook should exit 2 when Ruff finds a problem, got $code"
  [ -s "$work/hook.err" ] || fail "hook should print the problem on stderr"
  rm "src/$pkg/messy.py" "src/$pkg/broken.py"

  grep -qxF '__pycache__/' .gitignore && grep -qxF '.venv' .gitignore || fail ".gitignore misses the basics"
  grep -q '{{' CLAUDE.md .vscode/extensions.json && fail "placeholder left"
  if [ -n "$extra" ]; then
    echo "   jupyter: notebook, extension, rules, nbstripout"
    [ -f notebooks/exploration.ipynb ] || fail "missing example notebook"
    python3 -m json.tool notebooks/exploration.ipynb > /dev/null || fail "invalid notebook"
    grep -q 'ms-toolsai.jupyter' .vscode/extensions.json || fail "jupyter extension not recommended"
    grep -q '## Jupyter notebooks' CLAUDE.md || fail "jupyter rules missing"
    grep -q 'nbstripout' .gitattributes || fail "nbstripout not in .gitattributes"
    uv run python -c "import json; exec(''.join(json.load(open('notebooks/exploration.ipynb'))['cells'][1]['source']))" | grep -q Hello || fail "notebook code does not run"
    uv run python -c "import ipykernel" || fail "ipykernel not installed"
    # notebook hook: NotebookEdit sends notebook_path
    printf '%s' "{\"tool_input\": {\"notebook_path\": \"$proj/notebooks/exploration.ipynb\"}}" | CLAUDE_PROJECT_DIR="$proj" .claude/hooks/ruff.sh || fail "hook failed on the notebook"
  else
    grep -q 'ms-toolsai.jupyter' .vscode/extensions.json && fail "jupyter extension must not be added"
    grep -q '## Jupyter notebooks' CLAUDE.md && fail "jupyter rules must not be added"
  fi
  if bash "$skill/scripts/montar.sh" "$mode" $extra > /dev/null 2>&1; then fail "a second run of montar.sh must be refused"; fi

  git add -A
  git commit -q -m "chore: initial project scaffold"
  git ls-files | grep -q '^\.claude/dev-journal\.md$' && fail "journal must not be tracked"
  if [ -n "$extra" ]; then
    # outputs added locally must not reach the commit
    python3 - <<'PY'
import json
p = "notebooks/exploration.ipynb"
nb = json.load(open(p))
nb["cells"][1]["outputs"] = [{"name": "stdout", "output_type": "stream", "text": ["SECRET OUTPUT\n"]}]
nb["cells"][1]["execution_count"] = 1
nb["cells"][0]["source"].append("\n\nEdited.")
json.dump(nb, open(p, "w"), indent=1)
PY
    git add notebooks/exploration.ipynb
    git commit -q -m "test: notebook with output"
    git show HEAD:notebooks/exploration.ipynb | grep -q 'SECRET OUTPUT' && fail "nbstripout did not strip the outputs"
    grep -q 'SECRET OUTPUT' notebooks/exploration.ipynb || fail "local outputs must be kept"
  fi
  .claude/scripts/journal.sh "Smoke test entry" "Next: nothing" || fail "journal script failed"
  grep -q '^- Smoke test entry$' .claude/dev-journal.md || fail "journal script did not write the entry"
  cd "$repo"
done


echo "All checks passed."
