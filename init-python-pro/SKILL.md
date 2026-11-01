---
name: init-python-pro
description: Scaffolds a complete Python workspace with uv, Ruff, automated Git/GitHub, short commands via pyproject.toml scripts, and native VS Code Run/Debug integration.
disable-model-invocation: true
---

# Enterprise Python Workspace & Tooling Initializer

This skill automates the creation of a Python project, initializes Git/GitHub, configures VS Code with Ruff and Run/Debug profiles, and provisions local workspace guidelines for Claude Code.

## When to Use
Execute ONLY when explicitly requested via the `/init-python-pro` command.

## Step-by-Step Execution Plan

### 1. Project Scaffolding & Git Initialization
- Run `uv init --src` to create the layout.
- Initialize a local git repository immediately: `git init`.
- Create a comprehensive `.gitignore` targeting Python, `.venv`, `.vscode/`, and OS-specific files.

### 2. Dependency & Tools Setup (with Ruff & Project Scripts)
- Create the virtual environment: `uv venv`.
- Install development and quality tooling: `uv add --dev pytest ruff`.
- **Short Command Injection**: Modify the auto-generated `pyproject.toml`. Under the `[project]` or tool section, append the `uv` script definition so the user can execute `uv run start` instead of full paths.
  ```toml
  [tool.uv.scripts]
  start = "python src/<project_name>/main.py"
  ```

### 3. VS Code Workspace Alignment (Run & Debug Integration)
Create `.vscode/settings.json` with native Ruff and interpreter mappings:
```json
{
  "python.defaultInterpreterPath": "${workspaceFolder}/.venv/bin/python",
  "python.terminal.activateEnvironment": true,
  "[python]": {
    "editor.defaultFormatter": "charliermarsh.ruff",
    "editor.formatOnSave": true
  }
}
```

Create `.vscode/launch.json` to configure the **Run** and **Debug** buttons natively with `uv`:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Python: Current Project (uv)",
      "type": "python",
      "request": "launch",
      "program": "${workspaceFolder}/src/<project_name>/main.py",
      "console": "integratedTerminal",
      "python": "${workspaceFolder}/.venv/bin/python"
    }
  ]
}
```

### 4. Interactive GitHub Setup
- Ask the user explicitly if they wish to link to GitHub using the `gh` CLI.

### 5. Persistent Grounding (Token Optimization)
- Read the content of `style-guide.md` and write it as `CLAUDE.md` in the project root.
- Read the content of `developer-utilities.md` and write it as `DEVELOPMENT.md` in the project root.
- Create an empty hidden file named `.dev-journal.md` initialized with a header: `# Project Development Journal`.
