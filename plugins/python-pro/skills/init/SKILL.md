---
description: Creates a complete Python project in the current empty folder (uv, pytest, Ruff, Git, VS Code Run/Debug, CLAUDE.md rules, two work skills and an automatic Ruff hook). Run only when the user types the command.
disable-model-invocation: true
---

# Python project initializer

Talk to the user in the language they write in. Do the steps in order and do not skip the checks.

## 1. Checks

- The current folder must be empty (a `.git` folder is fine). If it contains anything else, stop and tell the user to open a completely empty folder.
- Run `uv --version`. If `uv` is missing, tell the user to install it (https://docs.astral.sh/uv/getting-started/installation/) and stop.

## 2. Ask the user (before changing anything)

Ask both questions together, with the question tool if you have one, otherwise in plain text. Do not suggest an answer, do not mark any option as recommended, and do not assume anything.

1. **GitHub**: no GitHub / private repository / public repository.
2. **Automatic push**: after each commit Claude makes, should it run `git push` by itself without asking? Yes / No.

The user must answer the push question explicitly. If the answer is missing, unclear or ambiguous, ask again and do not continue until it is clear. If the user chose "no GitHub", the push setting is still recorded (as the user answered), but nothing is pushed.

## 3. Build the project

Run these in the current folder, in this order:

1. `uv init --package` (creates `pyproject.toml`, `src/<package>/`, the Git repository and `.gitignore`).
2. `uv add --dev pytest ruff`
3. `bash "${CLAUDE_SKILL_DIR}/scripts/montar.sh" <auto|manual>`, where `auto` means the user said yes to automatic push and `manual` means no.

The script copies the templates from `${CLAUDE_SKILL_DIR}/plantillas/` into the project and fills them in. It adds:

- `src/<package>/__main__.py` and `tests/test_main.py`, so the first run and the first test work at once.
- A `start` command in `pyproject.toml` (`uv run start`), plus Ruff and pytest settings.
- `.vscode/` with the Run/Debug buttons, Ruff formatting on save and the recommended extensions.
- `CLAUDE.md` (rules Claude follows every session) and `DEVELOPMENT.md` (useful commands).
- `.claude/skills/py-tarea` and `.claude/skills/py-refactor`: the procedures for code changes and refactoring.
- `.claude/hooks/ruff.sh` and `.claude/settings.json`: Ruff runs after every Python edit, and the allowed commands are listed there. `git push` is allowed only if the user chose automatic push.
- `.dev-journal.md` (kept out of Git).

## 4. Verify

Run `uv run pytest`, `uv run ruff check` and `uv run start`. All three must succeed. If one fails, fix the cause before going on.

## 5. First commit and GitHub

- Run `git add -A` and commit with the message `chore: initial project scaffold`.
- If the user chose a GitHub repository and `gh` is installed and logged in, run `gh repo create <folder-name> --private --source=. --remote=origin --push` (use `--public` if the user chose public). If `gh` is missing or not logged in, do not fail: tell the user the exact commands to do it themselves.

## 6. Final report

Tell the user, briefly and in their language: what was created, how to run it (`uv run start`, or F5 in VS Code), that Claude now follows the rules in `CLAUDE.md` by itself, and what they chose for automatic push (and that it can be changed in `CLAUDE.md` and `.claude/settings.json`).
