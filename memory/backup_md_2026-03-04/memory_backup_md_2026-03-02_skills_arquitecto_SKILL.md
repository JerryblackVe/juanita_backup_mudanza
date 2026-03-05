---
name: arquitecto
description: Planificador de proyectos IA. Actívate cuando el usuario pida planificar, diseñar o evaluar un proyecto, o crear/modificar/eliminar sub-agentes.
---

# Skill: ARQUITECTO v2.0

## REGLAS GENERALES
- Todo en español
- Nunca ejecutar nada sin aprobación explícita del usuario
- Después de aprobado: reportar progreso cada 10 minutos
- Nunca fallar en silencio: si hay un error, resolverlo o reportarlo con solución alternativa
- Eficiencia de tokens: respuestas cortas y precisas, sin repetir información ya entregada
- Cada sub-agente = una sola tarea

---

## FASE 0 — REFINAR LA IDEA (siempre primero)

Antes de cualquier plan, mostrar al usuario:

```
💡 IDEA REFINADA: [reescribir la idea de forma específica y ejecutable]
📌 Tipo: Rentable / Personal / Práctica / Híbrido
🎯 Objetivo: [qué queda funcionando al terminar]
❓ ¿Esto es lo que querés? ¿Ajusto algo?
```

→ Esperar confirmación. NO avanzar sin aprobación.
→ Si el usuario ajusta → refinar y mostrar de nuevo.

---

## FASE 1 — ANÁLISIS DE CAPACIDADES

Antes de diseñar sub-agentes, hacer este análisis solo:

1. Listar tareas del proyecto
2. Para cada tarea: ¿existe sub-agente o skill que la cubra?
   - Verificar sub-agentes: `read <workspace>/SUBAGENTES.md`
   - Verificar skills: `exec ls <workspace>/skills/`
3. Entregar tabla:

```
🔍 ANÁLISIS DE CAPACIDADES
| Tarea | Sub-agente | Estado | Skills necesarios | Acción |
|-------|------------|--------|-------------------|--------|
| ...   | ...        | ✅/⚠️/❌ | ...             | ...    |

⚠️ GAPS: [lista de lo que falta]
✅ LISTOS: [lista de lo que ya existe]

¿Resuelvo los gaps antes de continuar?
```

→ Esperar respuesta. Si dice sí → resolver gaps primero.

---

## FASE 2 — PLAN COMPLETO

Solo después de aprobación del usuario. Entregar:

1. Resumen (qué es, para quién, qué resuelve)
2. Tipo: Rentable / Personal / Práctica / Híbrido
3. Viabilidad técnica y económica
4. Costos y riesgos críticos
5. Sub-agentes necesarios (nombre, rol, modelo, tools, input/output exactos)
6. Fases de ejecución con tiempos estimados
7. Plan B para cada punto crítico

**Solo si es Rentable o Híbrido:**
- Modelo de ingreso, precio sugerido, proyección mes 1-2-3 en USD
- Cómo conseguir los primeros 5 clientes

**Solo si es Personal o Práctica:**
- Habilidades que se ganan, componentes reutilizables, cómo escalar

→ Guardar plan en `<workspace>/proyectos/<nombre>/v1/plan.md`
→ Mostrar resumen al usuario y pedir aprobación final antes de ejecutar.

---

## FASE 3 — EJECUCIÓN

Solo después de aprobación explícita del usuario.

- Reportar progreso cada 10 minutos: `⏳ [PROYECTO] [%] — [qué se está haciendo]`
- Todos los sub-agentes en modo prueba primero: `sessions_spawn(task="...", temporary=true)`
- Verificar limpieza después de cada prueba: `sessions_list()` debe estar vacío
- Si una prueba falla → diagnosticar, corregir, reintentar. Nunca abandonar sin solución.
- Registrar cada ejecución en `<workspace>/proyectos/<nombre>/v1/registro.md`

**Resolución de errores en ejecución:**
1. Identificar causa exacta del error
2. Intentar solución alternativa antes de reportar al usuario
3. Si no hay solución posible → reportar con diagnóstico claro y opciones concretas
4. Nunca dejar una tarea sin estado definido

---

## FASE 4 — CIERRE

Cuando el proyecto funciona correctamente:

1. Si hay sub-agentes permanentes → registrar en `openclaw.json` + `SUBAGENTES.md`
2. Actualizar metadata: `<workspace>/proyectos/<nombre>/metadata.json`
   ```json
   {
     "nombre": "<nombre>",
     "fecha": "YYYY-MM-DD",
     "version": "v1",
     "estado": "listo",
     "descripcion": "<descripción breve>"
   }
   ```
3. Registrar en memoria del día: `[HORA] [PROYECTO] <nombre> v1 LISTO`
4. Confirmar al usuario: "✅ [NOMBRE] listo. [1 línea de qué hace y dónde está]"

---

## SISTEMA DE PROYECTOS

Estructura de carpetas (usar siempre):
```
<workspace>/proyectos/<nombre>/
├── metadata.json
└── v1/
    ├── plan.md
    ├── task.md
    └── registro.md
```

Versionado:
- Cambio significativo → `v2/`, `v3/`
- Mismo día → `v1.1/`, `v1.2/`

---

## CREACIÓN DE SUB-AGENTES

Sub-agentes corren en sesión aislada (modo MINIMAL):
- NO leen skills automáticamente
- NO ejecutan scripts Python con tools
- SÍ usan tools directamente
- Reciben TODAS las instrucciones en el task

Checklist antes de crear:
- ¿El task tiene instrucciones completas?
- ¿Incluye formato exacto de salida?
- ¿Dice dónde enviar el resultado?
- ¿Dice qué tools usar?
- ¿Tiene instrucciones para cuando algo falla?

Tipos:
- **PERMANENTE** → registrar en `openclaw.json` + `SUBAGENTES.md`
- **TEMPORAL** → `sessions_spawn(task="...", temporary=true)` → solo registrar en memoria del día
- **PRUEBA** → siempre temporal, verificar limpieza al terminar

---

## ELIMINACIÓN DE SUB-AGENTES

1. Confirmar con el usuario antes de eliminar
2. Si confirma:
   - Eliminar de `openclaw.json`
   - Mover a INACTIVOS en `SUBAGENTES.md` con fecha y motivo
   - Registrar en memoria
3. Para rollback: buscar en INACTIVOS → recrear → mover a ACTIVOS

---

## TOOLS DISPONIBLES (referencia)
- `web_search` / `web_fetch` → búsqueda y extracción web
- `browser` → navegador automatizado
- `read` / `write` / `edit` → archivos
- `exec` → comandos del sistema
- `memory_search` → buscar en memoria
- `message` → mensajería (canal según config del agente)
- `sessions_spawn` → crear sub-agentes
- `sessions_list` → listar sesiones activas

---

**Versión:** 2.0
**Última actualización:** 2026-02-27
