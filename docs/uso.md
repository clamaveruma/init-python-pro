# Uso

← [Volver al inicio](../README.md) · [Instalación](instalacion.md)

## Crear un proyecto nuevo

1. Crea una **carpeta vacía** con el nombre de tu proyecto y ábrela en VS Code (*Archivo → Abrir carpeta…*).
2. Abre el panel de **Claude Code**.
3. Escribe `/python-pro:init` y pulsa Enter.

Claude te hará unas pocas preguntas antes de tocar nada:

- **GitHub:** sin GitHub, repositorio privado o repositorio público.
- **Subida automática (`git push`)** (solo si eliges GitHub): si Claude puede subir los cambios él solo después de cada commit. Tienes que responder sí o no de forma explícita; no hay respuesta por defecto.
- **Instalar `uv`** (solo si no lo tienes): si quieres que lo instale con su instalador oficial. Si es así, cierra y abre la terminal (o VS Code) una vez al terminar.

Después crea el proyecto, comprueba que las pruebas y el formato pasan, hace el primer commit y, si lo pediste, lo sube a GitHub.

### Qué se crea

```
mi-proyecto/
├── src/mi_proyecto/   código del proyecto
├── tests/             pruebas
├── docs/design.md     diseño documentado (lo crea Claude al diseñar)
├── .vscode/           botones de Run/Debug y formato al guardar
├── .claude/           procedimientos de trabajo, formato automático, permisos
│                      y diario de trabajo (dev-journal.md, no se sube a Git)
├── CLAUDE.md          reglas y comandos útiles que Claude lee en cada sesión
└── pyproject.toml     configuración del proyecto
```

Para ejecutarlo: `uv run start` en la terminal, o **F5** en VS Code.

## El día a día

No tienes que recordar ningún comando. Pide las cosas con normalidad y Claude sigue las reglas del proyecto:

- **Si pides código nuevo o un arreglo** («añade una función que calcule el IVA»), sigue el procedimiento `py-tarea`: primero una fase de **diseño documentada** en `docs/design.md` (especificación, decisiones y casos de uso, validando el diseño contra cada caso hasta que todos pasen), después una prueba que falle, el código, la comprobación de pruebas y estilo, y el commit.
- **Si pides refactorizar** («refactoriza el módulo de pagos»), sigue `py-refactor`: te explica qué mejoraría según la guía de estilo, comprueba que hay pruebas y te deja elegir entre **modo automático** (lo hace todo y te cuenta al final) o **modo interactivo** (te propone cada paso y espera tu visto bueno).
- **Cada vez que Claude edita un archivo Python**, Ruff lo formatea y lo revisa solo. Si queda algo que Ruff no puede arreglar, se lo devuelve a Claude para que lo corrija.
- **Antes de instalar una librería externa**, Claude investiga si de verdad resuelve parte del problema y, si cree que sí, te pide permiso explicando por qué.

### La guía de estilo

Está en `CLAUDE.md`, en la sección *Code style*, y Claude la aplica a todo el código que escribe: Zen de Python, todo en inglés (nombres, comentarios, commits), Python básico o intermedio (si hace falta algo avanzado, te lo consulta), funciones que se lean en una pantalla, patrones de diseño solo si mejoran el código de verdad, pruebas primero y una arquitectura fácil de entender. **El código que escribas tú es tuyo**: no lo toca para cambiarle el estilo salvo que le pidas refactorizar.

### Ejemplo

> **Tú:** añade una función que calcule el IVA de un precio
>
> **Claude:** *(diseño en unas líneas con dos o tres casos de uso)* … *(escribe la prueba, la ve fallar, escribe el código, la ve pasar)* Hecho: `calcular_iva` en `src/mi_proyecto/impuestos.py`, 3 pruebas en verde. Commit realizado: `feat(impuestos): add VAT calculation`.

## La decisión sobre `git push`

- Si dijiste **no**, o no usas GitHub, Claude nunca sube nada por su cuenta: cuando quieras subir, díselo o hazlo tú con `git push`.
- Si dijiste **sí**, sube tras cada commit y te avisa en el chat.

Puedes cambiarlo cuando quieras editando dos sitios del proyecto: la regla del `git push` en `CLAUDE.md` y la línea `"Bash(git push *)"` de `.claude/settings.json` (quítala si no quieres subida automática).

## Personalizar las reglas

Las reglas son archivos de texto del propio proyecto, así que puedes cambiarlas:

- `CLAUDE.md`: reglas generales (idioma, estilo, commits).
- `.claude/skills/py-tarea/SKILL.md` y `.claude/skills/py-refactor/SKILL.md`: los pasos de cada procedimiento.
- `.claude/settings.json`: qué comandos puede ejecutar Claude sin preguntar.
