# BACKUP_AUTO.md - Sistema de Backup Automático JUANITA

Sistema de respaldo continuo y versionado.

## 🕐 Frecuencias

| Tarea | Frecuencia | Script | Destino |
|-------|------------|--------|---------|
| Backup .md | **Cada hora** | `backup_auto_md.py` | Local `memory/backup_md_YYYY-MM-DD/` |
| Sync GitHub | **Instantáneo** | `auto_commit_github.sh` | GitHub `JUANITA_FINAL` |
| Backup completo | **Manual/Diario** | `juanita_backup.sh` | Archivo `.tar.gz` |

## ⚡ Flujo Automático

```
Cada hora:
  └─ HEARTBEAT ejecuta → backup_auto_md.py
  └─ Detecta cambios en docs/, memory/, skills/
  └─ Si hay cambios → auto_commit_github.sh
  └─ Push instantáneo a GitHub con timestamp
```

## 🔄 Scripts

### 1. backup_auto_md.py
```bash
# Cada hora automático via HEARTBEAT
~/.openclaw/venv/bin/python ~/.openclaw/workspace/scripts/backup_auto_md.py
```
**Hace:** Backup local de todos los archivos .md

### 2. auto_commit_github.sh
```bash
# Ejecuta solo si hay cambios nuevos
./scripts/auto_commit_github.sh "mensaje personalizado"
```
**Hace:** Detecta cambios → commit → push a GitHub

### 3. juanita_backup.sh (manual)
```bash
# Backup completo del sistema
./scripts/juanita_backup.sh
```
**Hace:** Archivo `.tar.gz` completo para migración

## 📋 Configuración HEARTBEAT

En `docs/HEARTBEAT.md`:
```markdown
## Backup Automático (cada hora)
- [ ] Ejecutar: backup_auto_md.py
- [ ] Verificar cambios en docs/, memory/, skills/, scripts/
- [ ] Detectar nuevos scripts bash/python/js creados
- [ ] Si hay cambios: auto_commit_github.sh
- [ ] Confirmar push exitoso
```

**Directorios monitoreados:** `docs/`, `memory/`, `skills/`, `scripts/`, `data/`

## 🎯 Reglas de Commit Automático

**Se commitea instantáneamente si:**
- ✅ Se modifica cualquier archivo en `docs/`
- ✅ Se modifica cualquier SKILL.md
- ✅ Se actualiza `memory/`
- ✅ Se crea nuevo script

**NO se commitea:**
- ❌ Archivos temporales (`temp/`, `audio/`, `media/`)
- ❌ `.env` (API keys - NUNCA)
- ❌ `vosk-model-es/` (2.3GB - se ignora)

## 📊 Tracking de Cambios

### Archivos de registro:
| Archivo | Contenido |
|---------|-----------|
| `data/last_github_sync.json` | Último sync exitoso |
| `data/.last_sync` | Timestamp touch file |
| `data/last_backup.json` | Info del último backup completo |

### Ver estado:
```bash
# Ver último sync GitHub
cat ~/.openclaw/workspace/data/last_github_sync.json

# Ver último backup local
cat ~/.openclaw/workspace/data/last_backup.json
```

## 🚨 Troubleshooting

| Problema | Solución |
|----------|----------|
| "No hay cambios" | Verificar que el archivo modificado esté bajo docs/, memory/, skills/ |
| "Error de autenticación" | Verificar GITHUB_TOKEN en .env |
| "Push rechazado" | Hacer backup manual con juanita_backup.sh y subir manual |
| Conflicto de merge | Clonar repo fresco, aplicar cambios locales, push forzado |

## 🔧 Configuración Cron (opcional)

Si querés independencia del heartbeat:
```bash
# Editar crontab
crontab -e

# Añadir:
0 * * * * cd ~/.openclaw/workspace && ~/.openclaw/venv/bin/python scripts/backup_auto_md.py && ./scripts/auto_commit_github.sh "Hourly backup"
```

## 📈 Historial de Versiones

Todo cambio queda registrado en GitHub:
- Autor: JUANITA
- Mensaje: Fecha y hora del cambio
- Diff: Ver comparación entre versiones
- Rollback: Posible volver a cualquier punto

---

_Última actualización: 2026-03-02_
_Version: 1.0_
