# HEARTBEAT.md - Tareas Periódicas JUANITA

---

## ⚠️ ALERTA MIGRACIÓN VM — 5 de marzo 2026

**CRÍTICO — Un día antes del vencimiento de Azure (6 marzo):**

**Tareas obligatorias:**
- [ ] 1. Ejecutar backup completo: `~/.openclaw/workspace/scripts/juanita_backup.sh`
- [ ] 2. Verificar backup en GitHub (repo: JUANITA_FINAL)
- [ ] 3. Nueva VM con GPU должна estar lista (Google Cloud $300 free)
- [ ] 4. Instalar OpenClaw en nueva VM
- [ ] 5. Restaurar backup desde GitHub
- [ ] 6. Configurar modelos locales (Qwen 7B/Llama 8B)
- [ ] 7. Conectar GPU VM via API al agente principal

**Proveedor GPU:** Google Cloud (Tesla T4)
**Modelos a instalar:** Qwen 2.5 7B, Llama 3 8B
**Vencimiento actual:** 6 de marzo 2026

---

## 🕐 Cada Hora

### Backup Automático
Ver **docs/BACKUP_AUTO.md** para detalles completos.

```bash
# Quick backup
~/.openclaw/venv/bin/python scripts/backup_auto_md.py && ./scripts/auto_commit_github.sh "Backup"
```

## 📊 Documentación

- **Backup:** docs/BACKUP_AUTO.md
- **Migración:** docs/MIGRATION_GUIDE.md
- **Seguridad:** docs/SECURITY_PROTOCOL.md

---

# Instrucciones de uso:
# Este archivo se lee durante cada heartbeat poll.
# Si está vacío o solo comentarios → responder HEARTBEAT_OK
# Si hay tareas pendientes → ejecutarlas antes de responder.
## 🧠 Monitoreo de Tokens (ContextGuard)
**Skill activo:** context-guard
**Frecuencia:** Cada 5 minutos (heartbeat automático)
**Umbral Alerta:** 75% contexto usado
**Umbral Crítico:** 85% contexto usado
**Proceso:** Verificar /session_status → alertar si >75% → guardar si >85% → renew
**Archivos:** skills/context-guard/SKILL.md, skills/context-guard/config.json
