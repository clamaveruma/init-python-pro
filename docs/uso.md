# Uso

← [Volver al inicio](../README.md) · [Instalación](instalacion.md)

## Crear un proyecto nuevo

1. Crea una **carpeta vacía** con el nombre de tu proyecto (mejor en minúsculas, sin espacios y sin empezar por un número; si no vale como nombre de paquete de Python, Claude te pedirá otro). No la crees dentro de otro repositorio Git. Ábrela en VS Code (*Archivo → Abrir carpeta…*).
2. Abre el panel de **Claude Code**.
3. Escribe `/python-pro:init` y pulsa Enter.

Claude te hará unas pocas preguntas antes de tocar nada:

- **GitHub:** sin GitHub, repositorio privado o repositorio público.
- **Cuadernos Jupyter:** si vas a usarlos en este proyecto. Si dices que sí, añade lo necesario (ver más abajo).
- **Subida automática (`git push`)** (solo si eliges GitHub): si Claude puede subir los cambios él solo después de cada commit. Tienes que responder sí o no de forma explícita; no hay respuesta por defecto.
- **Instalar `uv`** (solo si no lo tienes): si quieres que lo instale con su instalador oficial. Si es así, cierra y abre la terminal (o VS Code) una vez al terminar.

Después crea el proyecto, comprueba que las pruebas y el formato pasan, hace el primer commit y, si lo pediste, lo sube a GitHub.

**Al terminar, abre una conversación nueva** en esa carpeta: las reglas, los procedimientos, el gancho de Ruff y los permisos se cargan al empezar cada conversación. Es posible que Claude Code te pregunte una vez si confías en la configuración del proyecto: acepta.

### Qué se crea

```
mi-proyecto/
├── src/mi_proyecto/   código del proyecto
├── tests/             pruebas
├── docs/design.md     diseño documentado (lo crea Claude en la primera función nueva)
├── .vscode/           botones de Run/Debug y formato al guardar
├── .claude/           procedimientos de trabajo, formato automático, permisos
│                      y diario de trabajo (dev-journal.md, no se sube a Git)
├── CLAUDE.md          reglas y comandos útiles que Claude lee en cada sesión
└── pyproject.toml     configuración del proyecto
```

Para ejecutarlo: `uv run start` en la terminal, o **F5** en VS Code.

### Si elegiste cuadernos Jupyter

- Una carpeta `notebooks/` con `exploration.ipynb`, un ejemplo que importa tu paquete. La primera vez que lo abras, elige el núcleo (*kernel*) `.venv` arriba a la derecha.
- La extensión **Jupyter** de VS Code entre las recomendadas, y `ipykernel` instalado en el entorno.
- Ruff revisa también los cuadernos, y el gancho actúa cuando Claude edita uno.
- Los resultados de las celdas (tablas, gráficos) **no se guardan en Git**: `nbstripout` los quita de cada commit y los deja en tu archivo. En otro ordenador, después de clonar, ejecuta una vez `uv run nbstripout --install --attributes .gitattributes`.
- Una regla en `CLAUDE.md`: la lógica reutilizable va en `src/`, con pruebas; los cuadernos son para explorar y probar ideas.

## El día a día

No tienes que recordar ningún comando. Pide las cosas con normalidad y Claude sigue las reglas del proyecto:

- **Si pides código nuevo o un arreglo** («añade una función que calcule el IVA»), sigue el procedimiento `py-tarea`. Para una función nueva, o un cambio que afecta a varias, primero hace una fase de **diseño documentada** en `docs/design.md`: especificación, decisiones y casos de uso, validando el diseño contra cada caso hasta que todos pasen. Para un arreglo pequeño, basta el diseño en una o dos líneas en el chat. Después escribe una prueba que falle y el código, comprueba pruebas y estilo, y hace el commit solo con los archivos de esa tarea.
- **Si pides refactorizar** («refactoriza el módulo de pagos»), sigue `py-refactor`: te explica qué mejoraría según la guía de estilo, comprueba que hay pruebas y te deja elegir entre **modo automático** (lo hace todo sin preguntar y te cuenta al final) o **modo interactivo** (antes de tocar el código te propone cada cambio y espera tu visto bueno).
- **Cada vez que Claude edita un archivo Python**, Ruff lo formatea y lo revisa solo. Si queda algo que Ruff no puede arreglar, se lo devuelve a Claude para que lo corrija. Las importaciones sin usar las deja para la comprobación final, porque quizá las use en la siguiente edición.
- **Antes de instalar una librería externa**, Claude investiga si de verdad resuelve parte del problema y, si cree que sí, te pide permiso explicando por qué.

### La guía de estilo

Está en `CLAUDE.md`, en la sección *Code style*, y Claude la aplica a todo el código que escribe: Zen de Python, todo en inglés (nombres, comentarios, commits), Python básico o intermedio (si hace falta algo avanzado, te lo consulta), funciones que se lean en una pantalla, patrones de diseño solo si mejoran el código de verdad, pruebas primero y una arquitectura fácil de entender. **El código que escribas tú es tuyo**: no le cambia nombres, estructura ni enfoque salvo que le pidas refactorizar. El formato automático de Ruff (al guardar, o cuando Claude edita un archivo) sí se aplica: solo cambia espacios, comillas y saltos de línea.

### Ejemplo

> **Tú:** añade una función que calcule el IVA de un precio
>
> **Claude:** *(diseño en unas líneas con dos o tres casos de uso)* … *(escribe la prueba, la ve fallar, escribe el código, la ve pasar)* Hecho: `calculate_vat` en `src/mi_proyecto/taxes.py`, 3 pruebas en verde. Commit realizado: `feat(taxes): add VAT calculation`.

Fíjate en que el código va en inglés aunque le hables en español: es una de las reglas de la guía de estilo.

## La decisión sobre `git push`

- Si dijiste **no**, o no usas GitHub, Claude nunca sube nada por su cuenta: cuando quieras subir, díselo o hazlo tú con `git push`.
- Si dijiste **sí**, sube tras cada commit y te avisa en el chat.

Puedes cambiarlo cuando quieras editando dos sitios del proyecto: la regla del `git push` en `CLAUDE.md` y la lista `allow` de `.claude/settings.json`. Para quitar la subida automática, borra la línea `"Bash(git push *)"`; para activarla, añádela a esa lista y cambia la regla de `CLAUDE.md`.

## Personalizar las reglas

Las reglas son archivos de texto del propio proyecto, así que puedes cambiarlas:

- `CLAUDE.md`: reglas generales (idioma, estilo, commits).
- `.claude/skills/py-tarea/SKILL.md` y `.claude/skills/py-refactor/SKILL.md`: los pasos de cada procedimiento.
- `.claude/settings.json`: qué comandos puede ejecutar Claude sin preguntar.
