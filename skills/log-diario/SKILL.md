---
name: log-diario
description: Registra automáticamente todo cambio, instalación o modificación del sistema en un log diario. Ejecuta automáticamente en heartbeat para detectar cambios. También responde a comandos /log y /log-resumen.
metadata:
  author: JEFESITO
  version: 1.1.0
  auto_execute: heartbeat
---

# Log Diario

## Directorio
`~/.openclaw/workspace/log_diario/`

## Formato del archivo
- **Nombre:** `YYYY-MM-DD.md`
- **Ejemplo:** `2026-02-28.md`

## Formato de cada entrada
```
[HH:MM] [TIPO] Descripción breve
```
- **TIPO** puede ser: `SKILL` · `CONFIG` · `ARCHIVO` · `SCRIPT` · `GATEWAY` · `SISTEMA` · `PENDIENTE`

## Reglas de registro
- Registrar **SIEMPRE** al momento de ocurrir, no después
- **NUNCA** registrar: API keys, tokens, contraseñas, credenciales de ningún tipo
- Si hay una credencial en la descripción → reemplazar por `[REDACTED]`
- Registrar: qué se hizo, qué archivo se modificó, qué versión quedó
- Registrar también errores y cómo se resolvieron

## Qué registrar
- Instalación o actualización de skills (nombre, versión)
- Modificación de archivos `.md` del workspace
- Cambios en `openclaw.json` (sin mostrar valores de keys)
- Scripts ejecutados y su resultado
- Reinicios del gateway
- Errores detectados y acciones correctivas
- Comandos `/mantenimiento` ejecutados

## Qué NO registrar
- Conversaciones normales con JEFESITO
- Búsquedas web rutinarias
- Respuestas a preguntas simples
- Cualquier credencial o API key

## Comando /log
Cuando JEFESITO diga `/log`:
1. Leer el archivo de hoy en `log_diario/`
2. Mostrarlo formateado
3. Si no existe el archivo de hoy → responder "No hay actividad registrada hoy"

## Comando /log-resumen
Cuando JEFESITO diga `/log-resumen`:
1. Leer los últimos 7 días de `log_diario/`
2. Mostrar resumen de lo más importante
3. Ideal para dar contexto en un nuevo chat
