---
name: auto-resolver
description: Skill que detecta y resuelve automáticamente problemas recurrentes, errores de ejecución y bloqueos técnicos. Aprende de errores anteriores y propone soluciones.
metadata:
  openclaw:
    emoji: "🔧"
    os: ["darwin", "linux"]
    requires:
      bins: ["python3"]
---

# Auto-Resolver Skill

Skill para detección y resolución automática de problemas técnicos recurrentes.

## Funcionalidades

- Detectar errores de ejecución recurrentes
- Proponer soluciones basadas en historial de errores
- Auto-resolver problemas conhecidos sin intervención del usuario
- Documentar nuevas soluciones aprendidas

## Comandos

- `auto-resolver check` — Verificar estado general del sistema
- `auto-resolver fix <error>` — Intentar resolver un error específico
- `auto-resolver learn <error> <solución>` — Registrar nueva solución

## Notas

- Complementa el archivo APRENDIZAJE.md
- Requiere permisos de ejecución en scripts/
