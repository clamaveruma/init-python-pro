# Project Development Tools & Helper Commands

This document contains the standard operational procedures, shortcuts, and diagnostic commands for developing in this project.

## 1. Quality Control & Linting (Ruff)
- **Check and Autofix issues**: `uv run ruff check --fix`
- **Format codebase**: `uv run ruff format`

## 2. Test Execution (Pytest)
- **Run full test suite**: `uv run pytest`

## 3. Project Execution (Short Commands & IDE)
- **Run via Terminal (Short Command)**: `uv run start`
- **Run/Debug via VS Code UI**: Press **F5** or click the "Play" button in the Run & Debug side panel.

## 4. Automated Git Operations
- **Force manual sync**: `git status && git pull origin main`
- **Check recent automated commits**: `git log --oneline -n 5`

## 5. Internal Development Journal (.dev-journal.md)
- Maintain the reverse-chronological log following the token-optimized passive storage guidelines.
