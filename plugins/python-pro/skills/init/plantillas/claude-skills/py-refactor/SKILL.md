---
description: Procedure for refactoring code in this Python project. Use whenever the user asks to refactor, clean up, simplify, reorganize or restructure existing code, in English or Spanish (refactorizar, limpiar, simplificar, reorganizar).
---

# Refactoring procedure

Behavior must not change. The goal is to bring the code in line with the code style in `CLAUDE.md`. If you find a bug along the way, report it and leave it for a separate task.

1. **Understand.** Read the code to refactor and its tests. Tell the user in a few lines what it does and what you would improve against the code style (Zen of Python, long functions, names not in English, advanced constructs, unclear architecture, duplication, mixed responsibilities).
2. **Check the safety net.** Run `uv run pytest`. If the code has no tests, offer to write tests that pin down the current behavior first, and do that before touching the code.
3. **Ask for the mode** and wait for the answer:
   - **Fully Automated**: you do all the steps without asking and report at the end.
   - **Interactive**: before changing the code you propose each suggestion, wait for approval, then apply it.
4. **Work in small steps**, one kind of change per step. After each step run `uv run pytest` and `uv run ruff check`. If either fails, fix or undo that step before going on.
5. **Commit each step**, staging only the files you changed, with a Conventional Commit (`refactor(scope): ...`), then follow the push rule in `CLAUDE.md`.
6. **Journal and report.** Add a short entry with `.claude/scripts/journal.sh` (see `CLAUDE.md`) and tell the user in their language what changed and that the tests still pass.

Do not add dependencies without asking (see `CLAUDE.md`).
