# Uso

← [Volver al inicio](../README.md) · [Instalación](instalacion.md)

## Crear un proyecto nuevo

1. Crea una **carpeta vacía** con el nombre de tu proyecto y ábrela en VS Code (*Archivo → Abrir carpeta…*).
2. Abre el panel de **Claude Code**.
3. Escribe el comando (`/python-pro:init`, o `/python-init` si instalaste sin complemento) y pulsa Enter.

Claude te hará **dos preguntas** antes de tocar nada:

- **GitHub:** sin GitHub, repositorio privado o repositorio público.
- **Subida automática (`git push`):** si Claude puede subir los cambios él solo después de cada commit. Tienes que responder sí o no de forma explícita; no hay respuesta por defecto.

Después crea el proyecto, comprueba que las pruebas y el formato pasan, hace el primer commit y, si lo pediste, lo sube a GitHub.

### Qué se crea

```
mi-proyecto/
├── src/mi_proyecto/   código del proyecto
├── tests/             pruebas
├── .vscode/           botones de Run/Debug y formato al guardar
├── .claude/           procedimientos de trabajo, formato automático, permisos
│                      y diario de trabajo (dev-journal.md, no se sube a Git)
├── CLAUDE.md          reglas y comandos útiles que Claude lee en cada sesión
└── pyproject.toml     configuración del proyecto
```

Para ejecutarlo: `uv run start` en la terminal, o **F5** en VS Code.

## El día a día

No tienes que recordar ningún comando. Pide las cosas con normalidad y Claude sigue las reglas del proyecto:

- **Si pides código nuevo o un arreglo** («añade una función que calcule el IVA»), sigue el procedimiento `py-tarea`: diseña primero en el chat, escribe una prueba que falle, escribe el código, comprueba pruebas y estilo, y hace el commit.
- **Si pides refactorizar** («refactoriza el módulo de pagos»), sigue `py-refactor`: te explica qué mejoraría, comprueba que hay pruebas y te deja elegir entre **modo automático** (lo hace todo y te cuenta al final) o **modo interactivo** (te propone cada paso y espera tu visto bueno).
- **Cada vez que Claude edita un archivo Python**, Ruff lo formatea y lo revisa solo. Si queda algo que Ruff no puede arreglar, se lo devuelve a Claude para que lo corrija.
- **Antes de instalar una dependencia nueva**, Claude te pregunta.

### Ejemplo

> **Tú:** añade una función que calcule el IVA de un precio
>
> **Claude:** *(diseño en unas líneas con dos o tres casos de uso)* … *(escribe la prueba, la ve fallar, escribe el código, la ve pasar)* Hecho: `calcular_iva` en `src/mi_proyecto/impuestos.py`, 3 pruebas en verde. Commit realizado: `feat(impuestos): add VAT calculation`.

## La decisión sobre `git push`

- Si dijiste **no**, Claude nunca sube nada por su cuenta: cuando quieras subir, díselo o hazlo tú con `git push`.
- Si dijiste **sí**, sube tras cada commit y te avisa en el chat.

Puedes cambiarlo cuando quieras editando dos sitios del proyecto: la regla del `git push` en `CLAUDE.md` y la línea `"Bash(git push *)"` de `.claude/settings.json` (quítala si no quieres subida automática).

## Personalizar las reglas

Las reglas son archivos de texto del propio proyecto, así que puedes cambiarlas:

- `CLAUDE.md`: reglas generales (idioma, estilo, commits).
- `.claude/skills/py-tarea/SKILL.md` y `.claude/skills/py-refactor/SKILL.md`: los pasos de cada procedimiento.
- `.claude/settings.json`: qué comandos puede ejecutar Claude sin preguntar.
