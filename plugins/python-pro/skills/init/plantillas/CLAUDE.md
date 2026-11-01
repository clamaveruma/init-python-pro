# Project rules

Python project managed with uv, tested with pytest, formatted and linted with Ruff.
Source code in `src/`, tests in `tests/`.

## Commands

- Run: `uv run start` (or F5 in VS Code)
- Tests: `uv run pytest`
- Lint and fix: `uv run ruff check --fix`
- Format: `uv run ruff format`
- Add a dependency: `uv add <package>` (development only: `uv add --dev <package>`)

## Always

- When asked to write, add, change or fix code, follow the `py-tarea` skill.
- When asked to refactor, follow the `py-refactor` skill. Before touching any code, offer two modes: Fully Automated or Interactive.
- A task is not done until `uv run pytest` and `uv run ruff check` both pass. Ruff formatting also runs by itself after every Python edit.
- Use Conventional Commits (for example `feat(auth): add JWT validation`). When a unit of work is finished and verified, commit without asking and tell the user in one line. Stage only the files you changed for that task (`git add <files>`), never unrelated changes the user may have in progress. Commit with a plain `git commit -m "type(scope): message"` (no heredoc or `$(...)`), so it runs without asking for permission.
{{PUSH_RULE}}

## Code style

These rules apply to all code you write. Code the user writes is theirs: do not restyle it (names, structure, approach) unless the user asks you to refactor, and then follow these rules. Automatic formatting by Ruff (on save in VS Code and after each of your edits) is not restyling.

- Follow the Zen of Python as far as possible.
- Write everything in English: variable and function names, comments, docstrings, commit messages. Talk to the user in the language they write in.
- Use basic or intermediate Python. If something advanced seems necessary, ask the user first.
- Keep functions short enough to read on one screen.
- Use well-known design patterns only when they really improve the code.
- Use test-driven development. The goal is robust code.
- Aim for an architecture that is easy to understand.

## Design first

- Before coding a new feature or a behavior change that affects more than one function, do a documented design phase in `docs/design.md` (see the `py-tarea` skill). The design must be clear and validated against scenarios before any code is written. For small fixes, state the design in one or two lines in the chat.
- Before adding an external package, find out whether it really solves part of the problem. If it may help, ask the user for permission before `uv add` and explain why it seems necessary. Prefer the standard library.

## Journal

- Keep a short log in `.dev-journal.md` (not tracked by Git): date, what was done, decisions, next steps. Add one short entry after each finished task (each commit you make).
- Do not read the journal on every turn. Read it only if you lose context.
