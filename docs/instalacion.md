# Instalación

← [Volver al inicio](../README.md) · [Uso](uso.md)

## Lo que necesitas

Casi nada. Solo estas dos cosas:

| Programa | Para qué | Cómo conseguirlo |
|---|---|---|
| **Claude Code**, en su última versión | Ejecuta el comando de inicio | Extensión de VS Code o terminal ([documentación](https://code.claude.com/docs/en/overview)) |
| **VS Code** con las extensiones *Python* y *Ruff* | Botones de Run/Debug y formato al guardar | VS Code las recomienda al abrir el proyecto |

**`uv`** (gestiona Python, el entorno y las dependencias) no hace falta instalarlo antes: si falta, `/python-pro:init` te pregunta y lo instala con su instalador oficial.

Probado en Linux. Debería funcionar también en macOS y en Windows con WSL; en Windows sin WSL no está probado.

## Instalar el complemento

### En VS Code (lo habitual)

1. En el panel de Claude Code, escribe `/plugins` y elígelo de la lista. No ejecuta nada: solo abre la ventana **Manage plugins** (gestionar complementos).
2. En esa ventana, conecta el repositorio: pestaña **Marketplaces** (catálogos de complementos), añade `clamaveruma/init-python-pro` (es un repositorio de GitHub).
3. Pasa a la pestaña **Plugins**, busca `python-pro` y pulsa **Install** (alcance «Install for you»).
4. Escribe `/` y comprueba que aparece **`/python-pro:init`**.

### En la terminal

Si prefieres la terminal (o el panel no te aparece), estos dos comandos hacen lo mismo:

```bash
claude plugin marketplace add clamaveruma/init-python-pro
claude plugin install python-pro@init-python-pro
```

En una sesión de Claude Code en terminal también vale, en un solo paso: `/plugin install python-pro --marketplace clamaveruma/init-python-pro` (necesita Claude Code 2.1.275 o posterior).

`claude plugin install` lo instala para tu usuario (todos tus proyectos), que es lo habitual.

El comando que tendrás es **`/python-pro:init`**.

## Si el comando te pide Git

El proyecto guarda su historial con **Git**. VS Code **no** lo incluye, aunque sí lo usa si lo encuentra en tu equipo, y sus extensiones no lo instalan. Comprueba si ya lo tienes con `git --version` en una terminal. Si no:

- **Linux** (Mint, Ubuntu…): `sudo apt install git`
- **macOS**: `xcode-select --install`
- **Windows**: con WSL, `sudo apt install git` dentro de WSL; sin WSL, desde <https://git-scm.com/downloads>

Si falta, `/python-pro:init` te lo dice antes de tocar nada. Git necesita también tu nombre y tu correo, una sola vez: `git config --global user.name "Tu Nombre"` y `git config --global user.email "tu@correo"`.

## GitHub (opcional)

**GitHub** es opcional: solo si quieres guardar una copia en internet. Para subir el proyecto desde el comando de inicio necesitas la herramienta `gh` (<https://cli.github.com/>, y después `gh auth login`). Si no la tienes, el proyecto se crea igual y Claude te dice los comandos para subirlo después.

## Actualizar y desinstalar

- **Actualizar:** las actualizaciones automáticas vienen apagadas para catálogos que no son de Anthropic. En la ventana *Manage plugins* (`/plugins`), pestaña *Marketplaces*, elige `init-python-pro` y pulsa *Update marketplace* (también puedes activar ahí la actualización automática). En la terminal: `claude plugin marketplace update init-python-pro` y después `claude plugin update python-pro@init-python-pro`.
- **Desinstalar:** en *Manage plugins*, pestaña *Installed*; o en terminal `claude plugin uninstall python-pro@init-python-pro`.

Los proyectos que ya creaste no cambian: sus reglas viven en el propio proyecto.

## Seguridad

Un complemento puede ejecutar código en tu ordenador. Este repositorio es pequeño y puedes revisarlo entero antes de instalarlo; lo importante está en `plugins/python-pro/skills/init/`.

## Si algo falla

- **No aparece el comando:** ejecuta `/reload-plugins` o reinicia Claude Code.
- **`uv: command not found`:** instala uv y abre una terminal nueva.
- **Los botones de Run no encuentran Python:** en VS Code, elige el intérprete de la carpeta `.venv` (Ctrl+Shift+P → *Python: Select Interpreter*).
