---
description: Procedure for any code change in this Python project (new feature, fix, behavior change). Use whenever the user asks to write, add, create, change or fix code, in English or Spanish (crear, añadir, modificar, arreglar código).
---

# Code change procedure

Follow these steps for every code change. For trivial edits (typos, comments, renames with no behavior change), keep the design to one line and skip the design file and the failing test.

1. **Design phase, documented, before any code.** Follow the code style in `CLAUDE.md`. Write or update `docs/design.md` (create the `docs/` folder if needed) with a short section for this change:
   - **Specification**: what must be true when the change is done.
   - **Decisions**: the options considered, the choice and why (modules, functions, data flow, design patterns only if they really help). Check whether an external package would really solve part of the problem; if you think so, stop and ask the user for permission, explaining why. Prefer the standard library.
   - **Scenarios**: the use cases, including normal, edge and error cases (at least three, varied).
   - **Validation**: walk the design through every scenario. If one fails, fix the design and walk through all of them again. Do not go on until all pass. This is test-driven development applied to the architecture.
   Tell the user the design in a few lines and ask only if something is truly ambiguous. For trivial edits (a typo, a rename) skip the file and state the design in one line.
2. **Write a failing test** in `tests/` that describes the new behavior. Run `uv run pytest` and confirm it fails for the right reason.
3. **Write the minimum code** in `src/` to make it pass, following the code style in `CLAUDE.md`.
4. **Verify.** Run `uv run pytest` and `uv run ruff check`. Do not call the task done until both pass.
5. **Commit.** Make a Conventional Commit (for example `feat(parser): add date validation`), then follow the push rule in `CLAUDE.md`.
6. **Journal.** Add a short entry to `.claude/dev-journal.md`: date, what was done, decisions, next steps. Do not read the file back unless you lost context.
7. **Report** in the user's language, in one or two lines: what changed, the test result, and that the commit was made.

If the change needs a new dependency, ask first (see `CLAUDE.md`). Commit `docs/design.md` together with the code.
