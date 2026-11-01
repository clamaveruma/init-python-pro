# Instalación

← [Volver al inicio](../README.md) · [Uso](uso.md)

## Lo que necesitas

| Programa | Para qué | Cómo conseguirlo |
|---|---|---|
| **Claude Code**, en su última versión | Ejecuta el comando de inicio | Extensión de VS Code o terminal ([documentación](https://code.claude.com/docs/en/overview)) |
| **uv** | Gestiona Python, el entorno y las dependencias | <https://docs.astral.sh/uv/getting-started/installation/> |
| **Git** | Guarda el historial del proyecto | <https://git-scm.com/downloads> |
| **GitHub CLI (`gh`)** | Solo si quieres subir el proyecto a GitHub | <https://cli.github.com/> (después: `gh auth login`) |
| **VS Code** con las extensiones *Python* y *Ruff* | Botones de Run/Debug y formato al guardar | VS Code las recomienda al abrir el proyecto |

Funciona en Linux, macOS y Windows con WSL. En Windows sin WSL no está probado.

## Opción A: complemento de Claude Code (recomendada)

En una sesión de Claude Code, escribe:

```
/plugin install python-pro --marketplace clamaveruma/init-python-pro
```

Si el panel `/plugin` no está disponible en tu entorno, usa estos comandos en una terminal:

```bash
claude plugin marketplace add clamaveruma/init-python-pro
claude plugin install python-pro@init-python-pro
```

Al instalar, Claude Code te pide el alcance: *usuario* (todos tus proyectos) es lo habitual.

El comando que tendrás es **`/python-pro:init`**.

## Opción B: sin complemento

```bash
git clone https://github.com/clamaveruma/init-python-pro.git
cd init-python-pro
./install.sh
```

El script copia la habilidad a `~/.claude/skills/python-init`. El comando que tendrás es **`/python-init`**.

## Actualizar y desinstalar

- **Complemento:** `/plugin marketplace update init-python-pro` para actualizar, y `/plugin uninstall python-pro@init-python-pro` para quitarlo.
- **Sin complemento:** vuelve a ejecutar `./install.sh` para actualizar, o borra la carpeta `~/.claude/skills/python-init`.

Los proyectos que ya creaste no cambian: sus reglas viven en el propio proyecto.

## Seguridad

Un complemento puede ejecutar código en tu ordenador. Este repositorio es pequeño y puedes revisarlo entero antes de instalarlo; lo importante está en `plugins/python-pro/skills/init/`.

## Si algo falla

- **No aparece el comando:** ejecuta `/reload-plugins` o reinicia Claude Code.
- **`uv: command not found`:** instala uv y abre una terminal nueva.
- **Los botones de Run no encuentran Python:** en VS Code, elige el intérprete de la carpeta `.venv` (Ctrl+Shift+P → *Python: Select Interpreter*).
