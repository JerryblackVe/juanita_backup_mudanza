---
name: context-guard
description: Monitor token usage and session lifecycle. Use this skill whenever the user mentions "token limit", "context full", "session expired", "renew session", "compact memory", or when working with long conversations that might hit model limits. Also trigger when the user wants automatic monitoring, session cleanup, or memory preservation before /new.
---

# ContextGuard - Session & Token Monitor

Skill para monitorear límites de tokens en tiempo real, preservar memoria antes de renovar sesión, y gestionar el ciclo de vida de conversaciones largas sin perder contexto.

## ⚠️ REGLA RC: Check Obligatorio ANTES de Operaciones Pesadas

**ANTES de ejecutar cualquier tool call que consuma muchos tokens (read >50 líneas, exec, web_fetch, browser, scanner), verificar estado:**

```python
# Pseudo-código para implementar:
if (operación == "exec" or "read" > 50 líneas or "scanner" or "web"):
    token_usage = get_session_status()
    if token_usage > 75%:
        alert_user("⚠️ Contexto alto ({}%), continuar?".format(token_usage))
        # O hacer auto-checkpoint si es crítico
```

**Esto evita errores 400 por context length exceeded.**

## When to Activate

- **SIEMPRE** antes de operaciones pesadas (exec, scanner, read >50 líneas)
- Usuario menciona error de "max_tokens" o "context length exceeded"
- Usuario dice "renovar sesión", "/new", "compactar", "limpiar contexto"
- Conversación es muy larga (muchos mensajes)
- Usuario quiere monitoreo automático de tokens
- Antes de que el contexto se agote completamente

## Configuración por Modelo

Los límites de contexto varían según el modelo:

| Modelo | Context Window | Umbral Alerta | Umbral Crítico |
|--------|---------------|---------------|----------------|
| minimax-m2.5 | 196k | 75% (147k) | 85% (167k) |
| deepseek-v3.2 | 64k | 70% (45k) | 80% (51k) |
| kimi-k2.5 | 200k | 75% (150k) | 85% (170k) |
| step-3.5-flash | 128k | 70% (90k) | 80% (102k) |
| llama-3.3-70b | 128k | 70% (90k) | 80% (102k) |
| gpt-oss-120b | 128k | 75% (96k) | 85% (109k) |

## Funciones Principales

### 1. Check Pre-Operación (OBLIGATORIO)

**Antes de cualquier operación pesada, siempre verificar:**

```python
# Ejecutar session_status antes de:
# - exec con timeout > 30s
# - read de archivos > 50 líneas
# - skill-scanner
# - web_fetch con maxChars > 5000
# - browser automation

if tokens > 75%:
    print("⚠️ Contexto alto, considerar /new")
elif tokens > 85%:
    print("🚨 CRÍTICO - Context almost full")
```

**Comando rápido:**
```bash
# Ver tokens sin narrar
source ~/.openclaw/venv/bin/activate && python -c "
import json
with open('/home/azureuser/.openclaw/agents/main/sessions/f712e926-af8c-461a-b584-d17a91420fe7.jsonl') as f:
    lines = f.readlines()
    # Contar tokens estimados
"
```

### 2. Ver Estado Actual

```
/session_status
```

Muestra tokens usados, disponibles y porcentaje actual.

### 2. Guardar Memoria Pre-Renew

Ejecutar ANTES de `/new` para no perder contexto:

```markdown
## Pre-compaction Memory Save

1. Guardar resumen en `memory/YYYY-MM-DD.md` (APPEND, no overwrite)
2. Guardar log detallado en `log_diario/YYYY-MM-DD.md` (APPEND)
3. Guardar archivos modificados en `docs/MEMORY.md` (sección relevante)
4. Actualizar `data/session-state.json` con estado actual

Template para resumen:
```
## [HH:MM] Session Activity Summary
**Tokens usados:** X de Y (Z%)
**Modelo:** [nombre]
**Actividades principales:**
- [Actividad 1]
- [Actividad 2]
**Archivos modificados:** [lista]
**Pendientes:** [si hay]
**Decisiones importantes:** [si hay]
```
```

### 3. Renovar Sesión (Flujo Completo)

```
1. Ejecutar "Guardar Memoria Pre-Renew" ↑
2. Informar usuario: "Guardado completado en [archivos]"
3. Decir: "Escribe /new para renovar la sesión"
4. Esperar confirmación del usuario
5. Post-renew: Leer memory/ y docs/MEMORY.md para contexto
```

### 4. Monitoreo Silencioso (30 min)

Para activar monitoreo automático cada 30 minutos silenciosamente:

1. Crear archivo `docs/HEARTBEAT.md` con:
```markdown
## Token Monitor (Silent)
- Cada 30 min: Verificar /session_status
- Si >75%: Avisar usuario suavemente
- Si >85%: Alerta crítica, ofrecer renew
- Guardar checkpoint en memory/
```

2. El heartbeat se ejecuta cada 5 min automáticamente
3. Solo responder cuando el umbral se cruza

### 5. Respuesta a Pre-compaction Flush

Cuando el sistema dice "Pre-compaction memory flush", ejecutar automáticamente:

```markdown
### Compaction Memory Flush | [hora]
**Tokens:** [X/Y Z%]
**Resumen de actividad reciente:**
- [Puntos clave de la última hora]
**Archivos modificados:** [lista]
**Pendientes:** [si hay]

---
EOF
```

Guardar en `memory/YYYY-MM-DD.md` (APPEND).

## Archivos de Estado

| Archivo | Propósito |
|---------|-----------|
| `data/session-state.json` | Estado actual, tokens, modelo |
| `memory/YYYY-MM-DD.md` | Resúmenes diarios (APPEND) |
| `log_diario/YYYY-MM-DD.md` | Logs detallados (APPEND) |
| `docs/MEMORY.md` | Memoria curada largo plazo |
| `docs/HEARTBEAT.md` | Tareas periódicas incl. token monitor |

## Comandos del Usuario

| Comando | Acción |
|---------|--------|
| "checkpoint" | Guardar estado actual en memory/ |
| "renovar sesión" | Flujo completo pre-renew |
| "status tokens" | Mostrar uso actual |
| "monitorear silencio" | Activar check cada 30 min |
| "compactar" | Forzar guardado de memoria |

## Manejo de Errores

**Error 400 - Context Length Excedido:**
1. Inmediatamente guardar memory/
2. Avisar: "Contexto excedido, iniciando /new..."
3. Instrucciones para renovar
4. Post-renew, resumir contexto perdido desde memory/

**Modelo cambiado:**
- Re-leer límites de tabla según modelo nuevo
- Ajustar umbrales dinámicamente

## Ejemplo de Uso

**Usuario:** "Me está dando error de contexto"

**JUANITA:**
```
⚠️ Contexto al 87% - Necesitamos renovar

Guardando memoria antes de /new...
✅ Guardado en:
- memory/2026-03-03.md
- log_diario/2026-03-03.md

Ahora escribí: /new
Y después te resumo lo que hicimos.
```

**Post-renew:**
```
✅ Sesión renovada
📋 Contexto anterior:
- Estabamos haciendo X
- Archivos modificados: Y, Z
- Pendiente: continuar con W
```