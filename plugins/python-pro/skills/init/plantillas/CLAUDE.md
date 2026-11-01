# Project rules

Python project managed with uv, tested with pytest, formatted and linted with Ruff.
Source code in `src/`, tests in `tests/`. Useful commands are in `DEVELOPMENT.md`.

## Always

- Write all code, comments, docstrings and commit messages in English. Talk to the user in the language they write in.
- Keep Python basic or intermediate and functions short.
- When asked to write, add, change or fix code, follow the `py-tarea` skill.
- When asked to refactor, follow the `py-refactor` skill. Before touching any code, offer two modes: Fully Automated or Interactive.
- A task is not done until `uv run pytest` and `uv run ruff check` both pass. Ruff formatting also runs by itself after every Python edit.
- Ask permission before installing a new dependency with `uv add`.
- Use Conventional Commits (for example `feat(auth): add JWT validation`). When a unit of work is finished and verified, commit without asking and tell the user in one line.
{{PUSH_RULE}}

## Journal

- Keep a short log in `.dev-journal.md` (not tracked by Git): date, what was done, decisions, next steps. Write to it after every major piece of work.
- Do not read the journal on every turn. Read it only if you lose context.
