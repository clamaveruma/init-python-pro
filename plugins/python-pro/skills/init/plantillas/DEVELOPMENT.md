# Development commands

## Run

- Terminal: `uv run start`
- VS Code: press **F5**, or use the Run and Debug panel.

## Quality

- Tests: `uv run pytest`
- Lint and fix: `uv run ruff check --fix`
- Format: `uv run ruff format`

## Dependencies

- Add a runtime dependency: `uv add <package>`
- Add a development dependency: `uv add --dev <package>`

## Git

- Status: `git status`
- Last commits: `git log --oneline -n 5`
- Sync with the remote: `git pull`

## Notes

- `.claude/dev-journal.md` is a personal log and is not tracked by Git.
- The rules Claude follows are in `CLAUDE.md`; the procedures are in `.claude/skills/`.
