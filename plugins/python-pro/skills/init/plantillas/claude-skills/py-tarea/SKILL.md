---
description: Procedure for any code change in this Python project (new feature, fix, behavior change). Use whenever the user asks to write, add, create, change or fix code, in English or Spanish (crear, añadir, modificar, arreglar código).
---

# Code change procedure

Follow these steps for every code change. Size the design to the change:

- **New feature, or a behavior change that affects more than one function**: full design phase in `docs/design.md` (step 1).
- **Small fix or change inside one function**: state the design in one or two lines in the chat; no design file.
- **Trivial edit** (typo, comment, rename with no behavior change): one line in the chat, no design file and no failing test.

1. **Design phase, documented, before any code** (only for the first kind of change above). Follow the code style in `CLAUDE.md`. In `docs/design.md` (create the `docs/` folder if needed), add a short section for the feature, or update its existing section instead of appending a new one:
   - **Specification**: what must be true when the change is done.
   - **Decisions**: the options considered, the choice and why (modules, functions, data flow, design patterns only if they really help). Check whether an external package would really solve part of the problem; if you think so, stop and ask the user for permission, explaining why. Prefer the standard library.
   - **Scenarios**: the use cases, including normal, edge and error cases (at least three, varied).
   - **Validation**: walk the design through every scenario. If one fails, fix the design and walk through all of them again. Do not go on until all pass. This is test-driven development applied to the architecture.
   Tell the user the design in a few lines and ask only if something is truly ambiguous.
2. **Write a failing test** in `tests/` that describes the new behavior. Run `uv run pytest` and confirm it fails for the right reason.
3. **Write the minimum code** in `src/` to make it pass, following the code style in `CLAUDE.md`.
4. **Verify.** Run `uv run pytest` and `uv run ruff check`. Do not call the task done until both pass.
5. **Commit.** Stage only the files you changed for this task (including `docs/design.md` if you updated it) and make a Conventional Commit (for example `feat(parser): add date validation`), then follow the push rule in `CLAUDE.md`.
6. **Journal.** Add a short entry with `.claude/scripts/journal.sh` (see `CLAUDE.md`): what was done, decisions, next steps. Do not read the file back unless you lost context.
7. **Report** in the user's language, in one or two lines: what changed, the test result, and that the commit was made.

If the change needs a new dependency, ask first (see `CLAUDE.md`).
