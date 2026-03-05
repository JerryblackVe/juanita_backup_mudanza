---
name: autonomous-saas
description: "Autonomous SaaS Generator. Actívate cuando el usuario quiera crear un proyecto SaaS (web app, API, dashboard, landing page). Workflow: 1) Recibir brief → 2) Planificar task breakdown → 3) Generar spec técnico → 4) Generar código con API (Kimi/MiniMax/DeepSeek) → 5) Mostrar código al usuario para review. Úsalo para cualquier solicitud de creación de proyectos web, APIs, o aplicaciones."
risk: safe
requires:
  network: true
  api_keys: ["any_nvidia_nim"]
license: MIT
---

# Autonomous SaaS Generator

Este skill genera proyectos SaaS completos usando APIs de IA (Kimi/MiniMax/DeepSeek) en lugar de GPU local.

## Cuándo usarlo

- Usuario quiere crear un proyecto web (SaaS, API, dashboard, landing)
- Usuario da un brief de proyecto
- Usuario pide "generar código" o "crear proyecto"

## Workflow

### 1. Recibir Brief
Si el usuario no dio suficiente info, pedir:
- Nombre del proyecto
- Qué hace (descripción breve)
- Features principales (lista)
- Tech stack preferido (opcional)

### 2. Planificar Task Breakdown
Para el proyecto recibido:
- Identificar componentes necesarios
- Crear lista de archivos a generar
- Estimar complejidad (simple/medium/complex)

### 3. Generar Spec Técnico
Crear `SPEC.md` con:
- Nombre y descripción
- Funcionalidades
- Estructura de archivos
- Dependencias
- Instrucciones de setup

### 4. Generar Código con API
Usar modelo API disponible (Kimi/MiniMax/DeepSeek) para generar código:

**Prompt para modelo:**
```
Genera un proyecto completo para: [NOMBRE PROYECTO]

Descripción: [DESCRIPCIÓN]
Features: [LISTA]

Tech stack:
- Frontend: [elegir según complejidad]
- Backend: [elegir según complejidad]
- Database: [opcional]

Genera TODOS los archivos necesarios:
- package.json
- Archivos fuente completos
- Archivos de configuración
- README con setup

Incluye código real y funcional, no placeholders.
```

**Modelos disponibles:**
- `nvidia/minimaxai/minimax-m2.1` - Principal
- `nvidia/qwen3-235b-a22b` - Código
- `nvidia/moonshotai/kimi-k2.5` - Pensamiento profundo

### 5. Mostrar resultado al usuario
- Listar archivos generados
- Mostrar código relevante
- Explicar siguiente paso (review en Cursor/GitHub)

## Estructura de output

```
📦 [NOMBRE PROYECTO]
├── SPEC.md                 # Spec técnico
├── package.json            # Dependencias
├── src/
│   ├── index.js            # Entry point
│   ├── ...
├── README.md               # Setup
└── .env.example            # Variables de entorno
```

## Tips

- Si es simple → HTML/CSS/JS estático o Node.js básico
- Si es medium → React/Next.js + API routes
- Si es complex → Next.js + Prisma + Auth + DB
- Siempre incluir README con instrucciones de setup
- Usar APIs públicas gratuitas cuando sea posible (en lugar de APIs propias)
