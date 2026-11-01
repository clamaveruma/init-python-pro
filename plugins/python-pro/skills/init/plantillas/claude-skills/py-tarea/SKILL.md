---
description: Procedure for any code change in this Python project (new feature, fix, behavior change). Use whenever the user asks to write, add, create, change or fix code, in English or Spanish (crear, añadir, modificar, arreglar código).
---

# Code change procedure

Follow these steps for every code change. For trivial edits (typos, comments, renames with no behavior change), keep the design to one line and skip the failing test.

1. **Design in the chat first.** Before writing any code or test, describe the approach in a few lines: modules and functions involved, data flow, edge cases. Check it against two or three realistic scenarios. Ask the user only if something is truly ambiguous.
2. **Write a failing test** in `tests/` that describes the new behavior. Run `uv run pytest` and confirm it fails for the right reason.
3. **Write the minimum code** in `src/` to make it pass. Basic or intermediate Python, short functions, everything in English.
4. **Verify.** Run `uv run pytest` and `uv run ruff check`. Do not call the task done until both pass.
5. **Commit.** Make a Conventional Commit (for example `feat(parser): add date validation`), then follow the push rule in `CLAUDE.md`.
6. **Journal.** Add a short entry to `.claude/dev-journal.md`: date, what was done, decisions, next steps. Do not read the file back unless you lost context.
7. **Report** in the user's language, in one or two lines: what changed, the test result, and that the commit was made.

If the change needs a new dependency, ask first (see `CLAUDE.md`).
