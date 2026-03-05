---
name: prompt-enhancer
description: "Mejora automáticamente cada mensaje del usuario antes de procesarlo. Activación: automático en cada mensaje entrante. Reescribe para ser más claro y específico sin cambiar la intención."
---

# Prompt Enhancer

Mejora automáticamente cada mensaje del usuario antes de procesarlo.

## ⚡ Activación

**Automático** en cada mensaje entrante. No necesita comandos.

## 🔄 Flujo

1. Recibir mensaje original del usuario
2. Analizar si necesita mejora
3. Si está claro → usar directo
4. Si necesita mejora → reescribir internamente
5. Ejecutar el prompt mejorado
6. Responder al usuario (solo видит la respuesta final)

## 📝 Reglas de Mejora

### Agregar cuandofalta:
- Contexto (para qué lo necesita, con quiénlo usa)
- Formato de salida (tabla, lista, texto, código)
- Restricciones (largo, idioma, tono)

### Aclarar:
- Ambiguüedades (qué significa "eso", "eso", etc.)
- Referencias implícitas

### Preservar:
- 100% la intención original
- El objetivo del usuario
- El tono si es explícito

### Si ya es claro:
- NO modificar por modificar
- Usar el mensaje tal cual

### Comandos cortos (pasardirecto):
- `/speed`
- `/clear`
- `/voz on`
- `/voz off`
- `/voz status`
- Cualquier comando que empieze con `/`

## ❌ NUNCA hacer

- Mostrar el prompt mejorado al usuario
- Cambiar la intención del mensaje
- Agregar tareas que no pidió
- Modificar comandos del sistema

## 📋 Registro interno

Guardar en memoria del día:
```
[HORA] [PROMPT-ENHANCER] "mensaje original" → "versión mejorada"
```

Solo para auditoría interna. El usuario NO ve esto.

## Ejemplos

| Original | Mejorado | Por qué |
|----------|----------|---------| 
| "dame info" | " Dame información general sobre [tema] en formato lista" | Falta tema y formato |
| "haz algo" | "Haz algo" | Ya claro, no mejorar |
| "como lo uso?" | "¿Cómo usar [herramienta/contexto del chat]? Dame pasos simples" | Falta contexto |
| "/speed" | "/speed" | Comando directo, no modificar |