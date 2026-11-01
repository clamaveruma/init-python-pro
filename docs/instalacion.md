# Instalación

← [Volver al inicio](../README.md) · [Uso](uso.md)

## Lo que necesitas

| Programa | Para qué | Cómo conseguirlo |
|---|---|---|
| **Claude Code**, en su última versión | Ejecuta el comando de inicio | Extensión de VS Code o terminal ([documentación](https://code.claude.com/docs/en/overview)) |
| **uv** | Gestiona Python, el entorno y las dependencias | No hace falta instalarlo antes: si falta, `/python-pro:init` te pregunta y lo instala con su instalador oficial. También puedes hacerlo tú: <https://docs.astral.sh/uv/getting-started/installation/> |
| **Git** | Guarda el historial del proyecto | <https://git-scm.com/downloads> |
| **GitHub CLI (`gh`)** | Solo si quieres subir el proyecto a GitHub | <https://cli.github.com/> (después: `gh auth login`) |
| **VS Code** con las extensiones *Python* y *Ruff* | Botones de Run/Debug y formato al guardar | VS Code las recomienda al abrir el proyecto |

Funciona en Linux, macOS y Windows con WSL. En Windows sin WSL no está probado.

## Instalar el complemento

### En VS Code (lo habitual)

1. En el panel de Claude Code, escribe `/plugins` y pulsa Enter. Se abre **Manage plugins** (gestionar complementos).
2. Abre la pestaña **Marketplaces** y añade `clamaveruma/init-python-pro`.
3. Vuelve a la pestaña **Plugins**, busca `python-pro` y pulsa **Install**.

### En la terminal

Si prefieres la terminal (o el panel no te aparece), estos dos comandos hacen lo mismo:

```bash
claude plugin marketplace add clamaveruma/init-python-pro
claude plugin install python-pro@init-python-pro
```

En una sesión de Claude Code en terminal también vale, en un solo paso: `/plugin install python-pro --marketplace clamaveruma/init-python-pro` (necesita Claude Code 2.1.275 o posterior). En la extensión de VS Code el comando se llama `/plugins`, con «s».

Al instalar, Claude Code te pide el alcance: *usuario* (todos tus proyectos) es lo habitual.

El comando que tendrás es **`/python-pro:init`**.

## Actualizar y desinstalar

- **Actualizar:** en `/plugins` (VS Code), pestaña *Marketplaces* → elige el marketplace → *Update marketplace*; o en terminal `claude plugin marketplace update init-python-pro`.
- **Desinstalar:** en `/plugins`, pestaña *Installed*; o en terminal `claude plugin uninstall python-pro@init-python-pro`.

Los proyectos que ya creaste no cambian: sus reglas viven en el propio proyecto.

## Seguridad

Un complemento puede ejecutar código en tu ordenador. Este repositorio es pequeño y puedes revisarlo entero antes de instalarlo; lo importante está en `plugins/python-pro/skills/init/`.

## Si algo falla

- **No aparece el comando:** ejecuta `/reload-plugins` o reinicia Claude Code.
- **`uv: command not found`:** instala uv y abre una terminal nueva.
- **Los botones de Run no encuentran Python:** en VS Code, elige el intérprete de la carpeta `.venv` (Ctrl+Shift+P → *Python: Select Interpreter*).
