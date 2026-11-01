# init-python-pro
### 🚀 Enterprise Python Workspace Initializer for Claude Code

Este repositorio contiene una habilidad (*Skill*) avanzada y optimizada para **Claude Code** (y su extensión oficial de VS Code) que automatiza la creación de proyectos profesionales de Python utilizando uv, Ruff y Git. 

### 📦 Características principales

* **Sin desperdicio de tokens:** La habilidad permanece inactiva en el sistema y solo consume contexto cuando tú la invocas manualmente con /init-python-pro.
* **Automatización total:** Crea la estructura de carpetas (src/, tests/), inicializa el entorno virtual (.venv), configura los botones visuales de **Run** y **Debug** en VS Code, y enlaza Git/GitHub de forma interactiva.
* **Directrices persistentes:** Inyecta automáticamente guías de estilo (CLAUDE.md) y herramientas de desarrollo (DEVELOPMENT.md) locales en tu proyecto para que Claude las recuerde en cada sesión diaria sin saturar el chat.

### 🛠️ Guía de Instalación Rápida (Desde Cero)

Sigue estos 3 sencillos pasos para activar el asistente en tu ordenador: 

### Paso 1: Instalar la extensión en VS Code

1. Abre **VS Code**.
2. Ve al icono de **Extensiones** en la barra lateral izquierda (el icono de los cuatro bloques).
3. Busca **Claude Code** (la extensión oficial de Anthropic) e instálala.

### Paso 2: Descargar la Habilidad automáticamente

No necesitas mover carpetas ocultas a mano. Simplemente copia el siguiente comando, abre una terminal en tu Linux (puede ser la terminal integrada de VS Code en **Terminal > Nueva terminal**) y pégalo: 

bash

curl -fsSL https://raw.githubusercontent.com/tu-usuario/mi-claude-skill/main/install.sh | bash

Usa el código con precaución.

*(Nota: Asegúrate de reemplazar tu-usuario y mi-claude-skill por el nombre real de tu cuenta y repositorio de GitHub).* 

### 🚀 Cómo usarlo en tu día a día

Cada vez que quieras empezar un proyecto nuevo y perfecto de Python desde cero: 

1. Abre **VS Code**.
2. Ve al menú superior y selecciona **Archivo > Abrir carpeta...**. Crea una carpeta completamente vacía en tu ordenador y ábrela.
3. Abre el panel lateral de la extensión de **Claude Code** en VS Code.
4. En la caja de chat de Claude, escribe el comando mágico y pulsa Enter: 

text

/init-python-pro

Usa el código con precaución.

El asistente configurará absolutamente todo por ti en 10 segundos. A partir de ese momento, programará siguiendo tus reglas estrictas de arquitectura en inglés, hará commits y pushes automáticos de forma autónoma cuando tus tests pasen, y llevará un diario oculto de actividad para ahorrar memoria.
