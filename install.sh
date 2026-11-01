#!/usr/bin/env bash
# Alternative to the Claude Code plugin.
# Copies the init skill to your personal skills folder so you can run /python-init.
# Use it from a clone of this repository:  git clone <repo> && cd init-python-pro && ./install.sh
set -euo pipefail

src="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/plugins/python-pro/skills/init"
config_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
dest="$config_dir/skills/python-init"

[ -f "$src/SKILL.md" ] || { echo "Skill not found at $src" >&2; exit 1; }
[ -n "$config_dir" ] || { echo "Could not work out the Claude config folder" >&2; exit 1; }

mkdir -p "$config_dir/skills"
rm -rf -- "$dest"
cp -R "$src" "$dest"
chmod +x "$dest/scripts/montar.sh" "$dest/plantillas/claude/hooks/ruff.sh"

echo "Installed in: $dest"
echo "Open an empty folder in Claude Code and type: /python-init"
