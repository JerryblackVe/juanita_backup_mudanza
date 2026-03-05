# MIGRATION_GUIDE.md
# Guía de Migración - JUANITA

Guía para migrar JUANITA de un servidor a otro.

## 📋 Requisitos Previos en Servidor Destino

- **OS:** Ubuntu 22.04+ / Debian 12+
- **Python:** 3.10+
- **Node.js:** 18+
- **Espacio libre:** 5GB mínimo
- **RAM:** 4GB mínimo
- **Conexión:** Internet estable

## 🚀 Paso a Paso

### 1. Crear Backup en Origen

```bash
cd ~/.openclaw/workspace
chmod +x scripts/juanita_backup.sh
./scripts/juanita_backup.sh
```

**Salida:** `juanita_backup_YYYYMMDD_HHMM.tar.gz` (~50-100MB)

### 2. Transferir al Servidor Destino

**Opción A - SCP:**
```bash
scp juanita_backup_*.tar.gz usuario@nuevo-servidor:/home/usuario/
```

**Opción B - Rsync:**
```bash
rsync -avzP juanita_backup_*.tar.gz usuario@nuevo-servidor:/tmp/
```

**Opción C - GitHub (recomendado):**
```bash
# Subir a GitHub si es urgente
git init
git add .
git commit -m "Juanita backup"
git remote add origin https://github.com/user/JUANITA_FINAL
git push origin main
```

### 3. Restaurar en Destino

```bash
cd /home/usuario
chmod +x install_juanita.sh
./install_juanita.sh juanita_backup_*.tar.gz
```

### 4. Configurar API Keys

```bash
nano ~/.openclaw/workspace/.env
```

Añadir (mínimo):
```
SERPER_API_KEY=tu_api_key
BRAVE_API_KEY=tu_api_key
GITHUB_TOKEN=tu_token
```

### 5. Instalar OpenClaw (si aplica)

```bash
# Seguir instrucciones de docs.openclaw.ai
# o usar el script del backup si existe en scripts/
```

### 6. Verificar

```bash
ls -la ~/.openclaw/workspace/
openclaw status
```

## 📦 Qué se incluye en el backup

| Item | Tamaño aprox. |
|------|---------------|
| `docs/` (config) | ~100KB |
| `skills/` (14 activos) | ~500KB |
| `skills_backup/` (896 skills) | ~51MB |
| `scripts/` | ~50KB |
| `memory/` (logs) | ~50KB |
| `data/` | variable |

## 🚫 Qué NO se incluye (excluido)

- `scripts/vosk-model-es/` (2.3GB) → se re-descarga automáticamente
- `.env` (API keys) → NO subir a GitHub
- `audio/`, `media/`, `temp/` (contenido temporal)

## 🔧 Troubleshooting

| Problema | Solución |
|----------|----------|
| "No se encuentra backup" | Verificar ruta del archivo .tar.gz |
| "Backup corrupto" | Re-descargar/retransferir el archivo |
| Vosk no funciona | El modelo se descarga automáticamente en primer uso |
| API keys faltan | Editar `.env` manualmente |

## 📊 Checklist Post-Migración

- [ ] Backup creado correctamente
- [ ] Transferido al servidor nuevo
- [ ] Restauración completada sin errores
- [ ] `.env` configurado con API keys
- [ ] OpenClaw instalado y ejecutando
- [ ] Skills verificados (14 activos)
- [ ] Test: enviar mensaje a JUANITA

## 📞 Notas para Otros Agentes

Para otro agente que necesite restaurar JUANITA:

1. Buscar el archivo `juanita_backup_*.tar.gz` más reciente
2. Ejecutar `./install_juanita.sh [archivo]`
3. Verificar en `data/last_backup.json` el SHA256 del backup
4. Asegurarse de que el usuario configure `.env` antes de iniciar

**Importante:** Si no hay backup disponible, usar el repo GitHub `JUANITA_FINAL` como respaldo.

---

_Última actualización: 2026-03-02_
_Versión: 1.0_
