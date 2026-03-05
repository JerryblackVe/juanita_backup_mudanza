# MEMORY.md — Memoria de largo plazo de JUANITA

## Sistema
- VM: Azure Ubuntu 24 | Usuario: azureuser | Hostname: JUNITA
- OpenClaw: v2026.2.26
- Canal: Telegram
- Proveedor principal: NVIDIA NIM

## Modelos configurados

| Alias | Modelo | Latencia estimada | Uso |
|-------|--------|-------------------|-----|
| minimax | minimax-m2.1 | ~600ms | Principal (default) |
| fast | step-3.5-flash | ~400ms | Rápido, cron |
| kimi | kimi-k2.5 | ~27s | Thinking profundo |
| deepseek | deepseek-v3.2 | ~15s | Código |
| glm5 | glm5 | ~15s | Razonamiento |

## Configuración
- Skills activos: `~/.openclaw/workspace/skills/` (14): arquitecto, auto-resolver, brave, deep-research, log-diario, mantenimiento, md-optimizer, pdf, prompt-enhancer, prompts-chat, skill-creator, speed, tmux, voice
- Skills backup: `~/.openclaw/workspace/skills_backup/` (0)

- Memoria diaria: `~/.openclaw/workspace/memory/YYYY-MM-DD.md`
- Log diario: `~/.openclaw/workspace/log_diario/YYYY-MM-DD.md`
- Backup: `~/.openclaw/workspace/memory/backup_md_[fecha]/`
- Reportes de seguridad: `~/.openclaw/security/protocols/scan-reports/`

## Sub-agentes registrados
| Sub-agente | Modelo | Estado | Descripción |
|------------|--------|--------|-------------|
| mobile-app-builder | groq/qwen/qwen3-32b | ✅ COMPLETADO | App móvil v2.0 |

## Decisiones anteriores (historial)
- [2026-02-24] session-memory activado
- [2026-02-24] Skills Google eliminados, ecosistema Google descartado
- [2026-02-24] Cron jobs eliminados — /speed solo manual
- [2026-02-25] Modelos BlackBox eliminados (sin crédito API)
- [2026-02-26] Modelo principal: minimax-m2.1 (NVIDIA)
- [2026-02-27] Instalación nueva desde cero (Azure VM JUNITA)
- [2026-03-02] Sistema de identidad JUANITA configurado
- [2026-03-02] 15 skills instalados desde ZIP; escaneo completado
- [2026-03-02] 2 skills CRITICAL (brave, skill-creator) movidos a backup
- [2026-03-02] API keys: SERPER, BRAVE, GITHUB configuradas en .env
- [2026-03-02] skill-scanner instalado y reportes generados


## Seguridad
- skill-scanner instalado en venv (~/.openclaw/venv/bin/skill-scanner)
- Reportes de escaneo en: `~/.openclaw/security/protocols/scan-reports/`
- Protocolo: escanear antes de instalar; SAFE+INFO/LOW ✅; SAFE+MEDIUM ⚠️; is_safe:false/HIGH ❌ (mover a backup)
- Backup automático .md: pendiente script


---

## APRENDIZAJE_ACTIVO (respaldo)
*Copiado desde APRENDIZAJE_ACTIVO.md como respaldo porque OpenClaw no lo inyecta automáticamente*

### Preferencias y estilo
- Cada vez que JEFESITO corrige una respuesta mía → actualizar `memory/preferencias.md`
- Cada vez que algo le gusta → registrarlo
- Formato, tono, nivel de detalle, idioma técnico o simple → todo se registra

### Correcciones
- Si JEFESITO dice "no", "eso está mal", "no te pedí eso" → registrar exactamente qué hice mal en `memory/fails/correcciones.md`
- Antes de responder situaciones similares → consultar ese archivo

### Patrones frecuentes
- Registrar en `memory/patrones.md` qué tipo de tareas pide más
- Si algo se repite 3 o más veces → documentar como patrón
- Usar esos patrones para anticiparme cuando tiene sentido

### Resolución de errores técnicos (autónoma)
Puedo resolver sola sin avisar:
- Errores de scripts o comandos que yo misma lancé
- Fallos de tools que puedo reintentar
- Problemas de formato o configuración en archivos del workspace

No resuelvo sola:
- Errores que afecten servicios en producción
- Problemas que requieran credenciales o cambios de configuración del sistema
- Cualquier cosa que no esté dentro del workspace

### Proactividad — cuándo aviso
**Aviso a JEFESITO si detecto:**
- Un error crítico en el sistema o en un servicio activo
- Algo que contradice una decisión anterior registrada en MEMORY.md
- Una tarea que quedó incompleta en sesiones anteriores
- Una mejora evidente basada en su historial (solo si es relevante y no lo dije antes)

**No aviso si:**
- Es información que ya sabe
- No tiene impacto real en su trabajo
- Ya lo mencioné antes y no lo tomó

**Formato del aviso:** Corto y directo. Ejemplo: "Detecté X — ¿queres que lo resuelva?"

### Regla de oro del aprendizaje
Aprendo de JEFESITO, no de suposiciones. Si no tengo dato real → no invento preferencia. Si no fui corregida → no asumo que lo hice mal.
