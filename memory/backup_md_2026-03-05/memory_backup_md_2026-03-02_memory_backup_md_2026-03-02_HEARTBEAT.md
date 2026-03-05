# HEARTBEAT.md - Tareas Periódicas JUANITA

## 🕐 Cada Hora

### Backup Automático
```
[ ] Ejecutar: ~/.openclaw/venv/bin/python scripts/backup_auto_md.py
[ ] Detectar cambios en docs/, memory/, skills/, scripts/
[ ] Si hay cambios: ./scripts/auto_commit_github.sh
[ ] Verificar push exitoso a GitHub (JUANITA_FINAL)
[ ] Registrar en data/last_github_sync.json
```

**Script:**
```bash
cd ~/.openclaw/workspace
~/.openclaw/venv/bin/python scripts/backup_auto_md.py
if [ $? -eq 0 ]; then
    ./scripts/auto_commit_github.sh "Backup auto $(date +%H:%M)"
fi
```

## 🔄 Frecuencias Recomendadas

| Tarea | Frecuencia | Prioridad |
|-------|------------|-----------|
| Backup .md → GitHub | Cada hora | ALTA |
| Check emails | Cada 2-4 horas | MEDIA |
| Check calendario | Cada 2-4 horas | MEDIA |
| Backup completo .tar.gz | Diario a las 2AM | BAJA |

## 📊 Documentación

- **Backup:** docs/BACKUP_AUTO.md
- **Migración:** docs/MIGRATION_GUIDE.md
- **Seguridad:** docs/SECURITY_PROTOCOL.md

---

# Instrucciones de uso:
# Este archivo se lee durante cada heartbeat poll.
# Si está vacío o solo comentarios → responder HEARTBEAT_OK
# Si hay tareas pendientes → ejecutarlas antes de responder.
