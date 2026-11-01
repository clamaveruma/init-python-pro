#!/usr/bin/env bash
# Usage: montar.sh <auto|manual>
# Run inside a project created with `uv init --package`.
# Copies the templates next to this script into the current folder and fills in the placeholders.
#   auto   = Claude may run `git push` by itself after each commit
#   manual = Claude never pushes unless the user asks
set -euo pipefail

push_mode="${1:-}"
case "$push_mode" in
  auto | manual) ;;
  *)
    echo "usage: montar.sh <auto|manual>" >&2
    exit 1
    ;;
esac

here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tpl="$here/plantillas"

[ -f pyproject.toml ] || { echo "pyproject.toml not found: run 'uv init --package' first" >&2; exit 1; }
pkg_dir="$(find src -mindepth 1 -maxdepth 1 -type d ! -name '__pycache__' | head -n 1)"
[ -n "$pkg_dir" ] || { echo "no package found in src/" >&2; exit 1; }
pkg="$(basename "$pkg_dir")"

# fill <file> <placeholder> <value>: replaces every occurrence of the placeholder
fill() {
  local content
  content="$(cat "$1")"
  content="${content//"$2"/$3}"
  printf '%s\n' "$content" > "$1"
}

mkdir -p .vscode .claude/hooks .claude/skills tests

# Code and tests
cp "$tpl/main.py" "$pkg_dir/__main__.py"
cp "$tpl/test_main.py" tests/test_main.py
fill "$pkg_dir/__main__.py" "{{PKG}}" "$pkg"
fill tests/test_main.py "{{PKG}}" "$pkg"

# VS Code
cp "$tpl/vscode/settings.json" .vscode/settings.json
cp "$tpl/vscode/launch.json" .vscode/launch.json
cp "$tpl/vscode/extensions.json" .vscode/extensions.json
fill .vscode/launch.json "{{PKG}}" "$pkg"

# Claude Code: rules, skills, hook and permissions
cp "$tpl/CLAUDE.md" CLAUDE.md
cp "$tpl/DEVELOPMENT.md" DEVELOPMENT.md
cp -R "$tpl/claude-skills/." .claude/skills/
cp "$tpl/claude/hooks/ruff.sh" .claude/hooks/ruff.sh
chmod +x .claude/hooks/ruff.sh
cp "$tpl/claude/settings.json" .claude/settings.json

if [ "$push_mode" = auto ]; then
  fill CLAUDE.md "{{PUSH_RULE}}" '- After each automatic commit, run `git push` without asking, and tell the user.'
  fill .claude/settings.json "{{PUSH_PERMISSION}}" $',\n      "Bash(git push *)"'
else
  fill CLAUDE.md "{{PUSH_RULE}}" '- Never run `git push` unless the user explicitly asks for it.'
  fill .claude/settings.json "{{PUSH_PERMISSION}}" ""
fi

# pyproject.toml: short command and tool settings
sed -i "/^\[project.scripts\]/a start = \"$pkg:main\"" pyproject.toml
cat >> pyproject.toml <<'EOF'

[tool.ruff]
line-length = 88

[tool.ruff.lint]
select = ["E", "F", "I", "UP", "B"]

[tool.pytest.ini_options]
testpaths = ["tests"]
EOF

# Journal (kept out of Git)
[ -f .dev-journal.md ] || printf '# Project Development Journal\n' > .dev-journal.md
cat >> .gitignore <<'EOF'

# Personal notes and local Claude settings
.dev-journal.md
.claude/settings.local.json
EOF

echo "Project files created for package '$pkg' (push mode: $push_mode)."
