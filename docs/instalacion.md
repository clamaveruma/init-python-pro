# Instalación

← [Volver al inicio](../README.md) · [Uso](uso.md)

## En resumen

Solo necesitas **VS Code** con la extensión **Claude Code**. Después:

1. **Una sola vez:** en el panel de Claude Code, escribe `/plugins`, añade el catálogo **`clamaveruma/init-python-pro`** e instala **`python-pro`**.
2. **Cada proyecto nuevo:** abre una carpeta vacía en VS Code y escribe en el chat de Claude Code:

   ```
   /python-pro:init
   ```

Claude te hace un par de preguntas, crea el proyecto, comprueba que todo funciona y hace el primer commit. Al terminar, abre una conversación nueva de Claude Code en esa carpeta y listo.

Todo lo demás de esta página son detalles, por si los necesitas.

---

## Lo que necesitas

| Programa | Para qué | Cómo conseguirlo |
|---|---|---|
| **VS Code** | El editor donde trabajarás | <https://code.visualstudio.com/> |
| **Claude Code**, en su última versión | Ejecuta el comando de inicio | Extensión de VS Code ([documentación](https://code.claude.com/docs/en/overview)) |

Además, al abrir el proyecto, VS Code te propone instalar las extensiones *Python* y *Ruff* (y *Jupyter*, si pediste cuadernos). Acepta.

No hace falta instalar nada más antes:

- **`uv`** (gestiona Python, el entorno y las librerías): si falta, `/python-pro:init` te pregunta y lo instala con su instalador oficial.
- **Git**: casi siempre ya está. Si falta, el comando te lo dice antes de tocar nada (más abajo, [cómo instalarlo](#si-el-comando-te-pide-git)).

Probado en Linux y en GitHub Codespaces. Debería funcionar también en macOS y en Windows con WSL; en Windows sin WSL no está probado.

## Instalar el complemento, paso a paso

### En VS Code (lo habitual)

1. En el panel de Claude Code, escribe `/plugins` y elígelo de la lista. No ejecuta nada: solo abre la ventana **Manage plugins** (gestionar complementos).
2. Pestaña **Marketplaces** (catálogos de complementos): añade `clamaveruma/init-python-pro`. Es el nombre del repositorio en GitHub.
3. Pestaña **Plugins**: busca `python-pro` y pulsa **Install**. Elige «Install for you», para tenerlo en todos tus proyectos.
4. Escribe `/` en el chat y comprueba que aparece **`/python-pro:init`**.

### En la terminal

Si prefieres la terminal (o la ventana no te aparece), estos dos comandos hacen lo mismo:

```bash
claude plugin marketplace add clamaveruma/init-python-pro
claude plugin install python-pro@init-python-pro
```

Dentro de una sesión de Claude Code en terminal también vale, en un solo paso: `/plugin install python-pro --marketplace clamaveruma/init-python-pro` (necesita Claude Code 2.1.275 o posterior).

## Crear el primer proyecto

1. Crea una **carpeta vacía** con el nombre del proyecto: mejor en minúsculas, sin espacios y sin empezar por un número. No la crees dentro de otro repositorio Git.
2. Ábrela en VS Code (*Archivo → Abrir carpeta…*).
3. En el chat de Claude Code, escribe `/python-pro:init`.
4. Responde a las preguntas: GitHub (sin GitHub, privado o público), si usarás cuadernos Jupyter y, solo si eliges GitHub, si Claude puede subir los cambios él solo.
5. Cuando termine, **abre una conversación nueva**. Si Claude Code te pregunta si confías en la configuración del proyecto, acepta: es lo que activa las reglas y los permisos.

Qué se crea y cómo se trabaja después: [Uso](uso.md).

## Si el comando te pide Git

El proyecto guarda su historial con **Git**. VS Code **no** lo incluye: lo usa si lo encuentra en tu equipo, y sus extensiones no lo instalan. Comprueba si ya lo tienes con `git --version` en una terminal. Si no:

- **Linux** (Mint, Ubuntu…): `sudo apt install git`
- **macOS**: `xcode-select --install`
- **Windows**: con WSL, `sudo apt install git` dentro de WSL; sin WSL, desde <https://git-scm.com/downloads>

Git necesita también tu nombre y tu correo, una sola vez:

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu@correo"
```

## GitHub (opcional)

Solo si quieres guardar una copia del proyecto en internet. Para que el comando lo suba por ti necesitas la herramienta `gh` (<https://cli.github.com/>) y haber iniciado sesión una vez con `gh auth login`. Si no la tienes, el proyecto se crea igual y Claude te dice los comandos para subirlo después.

## Actualizar y desinstalar

- **Actualizar:** las actualizaciones automáticas vienen apagadas para catálogos que no son de Anthropic. En *Manage plugins* (`/plugins`), pestaña *Marketplaces*, elige `init-python-pro` y pulsa *Update marketplace*; ahí también puedes activar la actualización automática. En la terminal: `claude plugin marketplace update init-python-pro` y después `claude plugin update python-pro@init-python-pro`.
- **Desinstalar:** en *Manage plugins*, pestaña *Installed*; o en la terminal, `claude plugin uninstall python-pro@init-python-pro`.

Los proyectos que ya creaste no cambian: sus reglas viven en el propio proyecto.

## Si algo falla

- **No aparece `/python-pro:init`:** ejecuta `/reload-plugins` o reinicia Claude Code. Comprueba en *Manage plugins → Installed* que `python-pro` está instalado y activado.
- **El comando dice que la carpeta no está vacía o que está dentro de otro repositorio:** crea una carpeta nueva, vacía y fuera de cualquier otro proyecto con Git.
- **El comando te pide otro nombre de proyecto:** el nombre de la carpeta no vale como nombre de paquete de Python (por ejemplo, empieza por un número). Escribe uno en minúsculas, como `mi_proyecto`.
- **`uv: command not found` en la terminal:** cierra y abre la terminal (o VS Code) una vez después de instalar `uv`.
- **Claude pide permiso para cosas que deberían ir solas (commits, el diario):** abre una conversación nueva y acepta el aviso de confianza del proyecto.
- **Los botones de ejecutar no encuentran Python:** elige el intérprete de la carpeta `.venv` en la barra de estado, abajo a la derecha (o *Ctrl+Mayús+P → Python: Select Interpreter*).
- **Un cuaderno no encuentra el núcleo:** arriba a la derecha del cuaderno, elige el núcleo `.venv`.

## Seguridad

Un complemento puede ejecutar código en tu ordenador. Este repositorio es pequeño y puedes revisarlo entero antes de instalarlo; lo importante está en `plugins/python-pro/skills/init/`.
