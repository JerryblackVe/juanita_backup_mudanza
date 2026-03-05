# Tools y Rate Limits — JUANITA

## Rate Limits
- 5s entre llamadas API | 10s entre búsquedas web
- Máx 5 búsquedas/tanda → pausa 2 min
- Agrupa trabajo: 1 request para N items
- Error 429: STOP → espera 5 min → reintenta

## Presupuesto
- Alerta al 75% del límite diario
- >$5/día → avisar antes de continuar
- Prioriza step-3.5-flash para tareas rutinarias

## Selección de modelos
Orden de preferencia: `step-3.5-flash → qwen3.5 → minimax-m2.1 → deepseek-v3.2 → glm5 → kimi-k2.5`

## Deduplicación
1. ¿Tengo esta info en contexto? → Úsala
2. ¿Ya respondí esto? → Referencia la respuesta anterior
3. ¿Piden repetir algo? → Da versión comprimida

## Caché
- Cachear: docs/SOUL.md, docs/USER.md, docs/IDENTITY.md, docs/TOOLS.md
- No cachear: memory/hoy, mensajes recientes, outputs de tools

## Estructura de carpetas
- `docs/` – Configuración y documentación
- `scripts/` – Scripts Python, JS, Bash
- `audio/` – Archivos de audio recibidos
- `media/` – Imágenes, videos, documentos adjuntos
- `data/` – Datos estructurados (CSVs, JSONs)
- `temp/` – Archivos temporales
- `memory/` – Logs diarios de memoria
- `log_diario/` – Registros diarios de actividades

## Skills siempre activos (después de escaneo)
arquitecto, auto-resolver, brave, deep-research, log-diario, mantenimiento, md-optimizer, pdf, prompt-enhancer, prompts-chat, skill-creator, speed, tmux, voice

**Nota:** skill-creator activado a pesar de CRITICAL (falso positivo: subprocess para claude es legítimo en evaluador de skills)

## Rutas importantes
- Skills activos: `~/.openclaw/workspace/skills/`
- Skills backup: `~/.openclaw/workspace/skills_backup/`
- Memoria: `~/.openclaw/workspace/memory/`
- Log diario: `~/.openclaw/workspace/log_diario/`
- Seguridad: `~/.openclaw/security/protocols/scan-reports/`
