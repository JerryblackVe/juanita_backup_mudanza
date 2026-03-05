---
name: mantenimiento
description: Mantenimiento automático del sistema. Compacta contexto sin perder memoria. Usar cuando digan /mantenimiento, "limpia sesiones", o en heartbeat automático.
metadata:
  author: JEFESITO
  version: 2.0.0
---

# Mantenimiento del Sistema

## ANTES de limpiar cualquier sesión:
1. Guardar en ~/.openclaw/workspace/memory/YYYY-MM-DD.md:
   - Proyecto activo y fase actual
   - Últimas 5 decisiones importantes
   - Archivos creados o modificados
   - Próximo paso pendiente
2. Solo después de guardar → limpiar

## Comando /mantenimiento
Ejecutar en orden:
1. Guardar contexto en memoria (SIEMPRE primero)
2. Verificar sesiones: openclaw sessions
3. Si alguna sesión supera 15k tokens → limpiar ESA sesión únicamente
4. Si todas están bajo 15k tokens → NO limpiar nada
5. Reiniciar gateway solo si se limpió algo
6. Confirmar: "Contexto guardado en memoria. [X] sesiones limpiadas."

## Heartbeat automático cada hora:
1. Guardar contexto activo en memoria
2. Verificar tokens por sesión
3. Limpiar solo sesiones >15k tokens
4. NO interrumpir tareas en curso
5. Notificar solo si se actuó

## NUNCA:
- Limpiar sesiones sin guardar memoria primero
- Interrumpir una tarea en curso
- Perder el proyecto activo o fase actual