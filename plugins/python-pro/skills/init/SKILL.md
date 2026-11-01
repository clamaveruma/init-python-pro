---
description: Creates a complete Python project in the current empty folder (uv, pytest, Ruff, Git, VS Code Run/Debug, CLAUDE.md rules, two work skills and an automatic Ruff hook). Run only when the user types the command.
disable-model-invocation: true
---

# Python project initializer

Talk to the user in the language they write in. Do the steps in order and do not skip the checks.

## 1. Checks

- The current folder must be empty (a `.git` folder is fine). If it contains anything else, stop and tell the user to open a completely empty folder.
- Run `git --version`. If it fails, or if `git config user.name` or `git config user.email` is empty, stop before changing anything and tell the user exactly what is missing and how to fix it, in one message: install Git (Linux and WSL: `sudo apt install git`; macOS: `xcode-select --install`; Windows: https://git-scm.com/downloads) and/or set the name and email once with `git config --global user.name "Name"` and `git config --global user.email "mail"`. Then ask them to run the command again. Do not install Git or change their Git settings yourself.
- If `git rev-parse --show-toplevel` succeeds and prints a folder other than the current one, the folder is inside another Git repository: stop and tell the user to choose a folder outside it (otherwise the first commit would go to that other repository).
- The package name is the folder name in lowercase with `-` and spaces turned into `_`. It must be a valid Python name (letters, digits and `_`, not starting with a digit) and must not be `start`, `pytest`, `ruff`, `test` or `tests`. If it is not valid, ask the user for a project name in step 2 and pass it later with `uv init --package --name <name>`.
- Run `uv --version`. If it fails, also try `"$HOME/.local/bin/uv" --version`: uv may be installed but missing from the PATH of this session. If found there, add `$HOME/.local/bin` to the PATH of every command in this procedure (for example `PATH="$HOME/.local/bin:$PATH" uv init --package`). If uv is not found anywhere, remember it: you will offer to install it in step 2.

## 2. Ask the user (before changing anything)

Ask the questions together, with the question tool if you have one, otherwise in plain text. Do not suggest an answer, do not mark any option as recommended, and do not assume anything.

1. **GitHub**: no GitHub / private repository / public repository.
2. **Automatic push, only if the user chose a GitHub repository**: after each commit Claude makes, should it run `git push` by itself without asking? Yes / No. (Without GitHub there is nowhere to push, so do not ask.)
3. **Only if uv is missing**: "uv is not installed. Do you want me to install it with its official installer?" Yes / No.
4. **Only if the folder name is not a valid package name**: the project name to use (lowercase letters, digits and `_` or `-`).

When the push question is asked, the user must answer it explicitly. If the answer is missing, unclear or ambiguous, ask again and do not continue until it is clear. If the user chose "no GitHub", use the safe setting (`manual`: Claude never pushes unless asked) without asking.

If the user does not want uv installed, tell them where to install it themselves (https://docs.astral.sh/uv/getting-started/installation/) and stop.

If the user said yes, install it before step 3:

1. Run `curl -LsSf https://astral.sh/uv/install.sh | sh` (the official installer; Claude Code will also ask for confirmation).
2. Find where it was installed (the installer prints it; normally `$HOME/.local/bin`). Check with `"$HOME/.local/bin/uv" --version`.
3. The PATH of this session does not include that folder yet, so add it to the PATH of every command in the rest of this procedure, and tell the user in the final report to close and reopen the terminal (or VS Code) once.
4. If the installation fails, show the error, give the manual link above and stop.

## 3. Build the project

Run these in the current folder, in this order:

1. `uv init --package` (add `--name <name>` if you asked for a name). It creates `pyproject.toml`, `src/<package>/` and, if there is no `.git` yet, the Git repository and `.gitignore`.
2. `uv add --dev pytest ruff`
3. `bash "${CLAUDE_SKILL_DIR}/scripts/montar.sh" <auto|manual>`, where `auto` means the user said yes to automatic push, and `manual` means they said no or chose no GitHub.

The script copies the templates from `${CLAUDE_SKILL_DIR}/plantillas/` into the project and fills them in. It adds:

- `src/<package>/__main__.py` and `tests/test_main.py`, so the first run and the first test work at once.
- A `start` command in `pyproject.toml` (`uv run start`), plus Ruff and pytest settings.
- `.vscode/` with the Run/Debug buttons, Ruff formatting on save and the recommended extensions.
- `CLAUDE.md`: the rules Claude follows every session, plus the useful commands.
- `.claude/skills/py-tarea` and `.claude/skills/py-refactor`: the procedures for code changes and refactoring.
- `.claude/hooks/ruff.sh` and `.claude/settings.json`: Ruff runs after every Python edit, and the allowed commands are listed there. `git push` is allowed only if the user chose automatic push.
- `.claude/dev-journal.md` (kept out of Git).

## 4. Verify

Run `uv run pytest`, `uv run ruff check` and `uv run start`. All three must succeed. If one fails, fix the cause before going on.

## 5. First commit and GitHub

- Run `git add -A` (the folder only contains what this procedure created) and commit with the message `chore: initial project scaffold`.
- If the user chose a GitHub repository and `gh` is installed and logged in, run `gh repo create <name> --private --source=. --remote=origin --push`, where `<name>` is the `name` in `pyproject.toml` (use `--public` if the user chose public). If `gh` is missing or not logged in, do not fail: tell the user the exact commands to do it themselves.

## 6. Final report

Tell the user, briefly and in their language: what was created, how to run it (`uv run start`, or F5 in VS Code), that Claude now follows the rules in `CLAUDE.md` by itself, and what they chose for automatic push (and that it can be changed in `CLAUDE.md` and `.claude/settings.json`). If you installed uv in this run, remind them to close and reopen the terminal (or VS Code) once so that `uv` is found everywhere. Also tell them that the project rules, skills, hook and permissions take effect in a **new conversation** opened in this folder, and that Claude Code may ask them once to trust the project settings: they should accept.
