# Core Python Style & Architecture Guidelines

You must strictly adhere to these development principles during every coding session. These rules govern code generation, architectural phases, refactoring workflows, and autonomous system operations.

## 1. Architectural Design Phase (Mandatory Before Coding)
Before writing any code or tests, you must conduct a high-level architectural design phase. Document choices and test against scenarios in the chat before coding.

## 2. Coding & Quality Standards
- **Language & Simplicity**: Everything in English. Basic/intermediate Python. Short functions.
- **Robustness**: Strict TDD. Run `uv run pytest` and `uv run ruff check` to validate changes before considering a task done.

## 3. Autonomous Git Operations (No-Prompt Commits & Pushes)
- **Criteria**: You have full authorization to perform Git operations autonomously. Do not ask for permission.
- **Trigger**: Whenever a meaningful unit of work is completed, verified, and all tests pass, you must automatically create a Git commit.
- **Pushing**: If a GitHub remote is configured, execute a `git push` immediately after the commit without user intervention.
- **Notification**: Although you do not ask beforehand, you **must notify the user in the chat** immediately after execution by printing a concise message indicating that a commit/push was made.
- **Commit Format**: Follow Conventional Commits (e.g., `feat(auth): add JWT validation`).

## 4. Passive Token-Optimized Development Journal
- **Storage**: Maintain an internal workspace log in a file named **`.dev-journal.md`** at the project root.
- **Token Optimization Rule**: Do NOT read or dump the contents of this journal into the LLM chat window on every turn. Only read it if you lose context.
- **Write Triggers**: At the end of every major implementation, autonomously open `.dev-journal.md` and document the date, achievements, architectural changes, and next steps.

## 5. External Dependencies & Refactoring Workflows
- **Dependencies**: Request explicit permission before installing external packages via `uv add`.
- **Refactoring**: Offer Fully Automated Mode vs Interactive Mode before editing code.
