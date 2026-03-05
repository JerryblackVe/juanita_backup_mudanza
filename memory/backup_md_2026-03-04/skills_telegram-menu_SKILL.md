---
name: telegram-menu
description: Menú interactivo Telegram con botones inline. Responde instantáneamente a /menu y callbacks.
---

# Telegram Menu - Menú Interactivo

## Activación Instantánea

**Cuando usuario escribe:** `/menu`
**Acción inmediata:** Enviar menú con botones inline usando tool `message`

## Menú Principal

```json
{
  "action": "send",
  "message": "🤖 **JUANITA - Menú Principal**\n\nSelecciona una opción:",
  "buttons": [
    [{"text": "📋 Skills", "callback_data": "menu_skills", "style": "primary"}, {"text": "🧠 Modelos", "callback_data": "menu_models", "style": "primary"}],
    [{"text": "🔧 System", "callback_data": "menu_system", "style": "success"}, {"text": "⚡ Latencia", "callback_data": "menu_latency", "style": "success"}],
    [{"text": "📊 Tokens", "callback_data": "menu_tokens", "style": "primary"}, {"text": "ℹ️ Ayuda", "callback_data": "menu_help", "style": "primary"}],
    [{"text": "❌ Cerrar Menú", "callback_data": "menu_close", "style": "danger"}]
  ]
}
```

## Manejo de Callbacks

Cuando llega callback (ej: `menu_skills`):

1. Ejecutar función correspondiente
2. Responder con información + botón volver
3. NO usar subagentes - respuesta directa

### Respuestas Callback

**menu_skills:**
```json
{
  "action": "send",
  "message": "📋 Skills activos...",
  "buttons": [[{"text": "◀️ Volver", "callback_data": "menu_main", "style": "primary"}]]
}
```

**menu_models:**
Ejecutar session_status, mostrar modelo actual

**menu_system:**
Ejecutar exec openclaw status

**menu_latency:**
Test curl endpoints APIs

**menu_tokens:**
Mostrar uso de tokens actual

**menu_help:**
Instrucciones de uso

**menu_close:**
"Menú cerrado. Escribe /menu para volver"

**menu_main:**
Volver a menú principal

## Reglas Críticas

1. **SIN SUBAGENTES** - Respuesta inmediata
2. **PRE-CARGADO** - Menú listo para enviar
3. **SIN DELAY** - Tool message ejecuta directo

## Ejemplo de Uso

Usuario: `/menu`
→ Ejecutar: tool message con menú principal (instantáneo)

Usuario: Clic en [📋 Skills]
→ Callback: menu_skills
→ Ejecutar: ls skills/ + message con lista + botón volver

Usuario: Clic en [◀️ Volver]
→ Callback: menu_main
→ Ejecutar: message con menú principal