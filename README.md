# JUANITA - Backup para Migración

## ⚠️ ALERTA: VM EXPIRA EL 6 DE MARZO DE 2026

Esta VM de Azure expira el **6 de marzo de 2026**. Es CRÍTICO migrar todo antes de esa fecha.

---

## Estructura del Workspace

```
~/.openclaw/workspace/
├── 📄 AGENTS.md          ← Guía del workspace (leer al inicio)
├── 📄 README.md          ← Este archivo
├── 📄 BOOTSTRAP.md       ← Secuencia de arranque (inyectado por OpenClaw)
│
├── 📄 Archivos de configuración (raíz):
│   ├── USER.md           ← Perfil de JEFESITO
│   ├── IDENTITY.md       ← Identidad de JUANITA
│   ├── MEMORY.md         ← Memoria de largo plazo
│   ├── SOUL.md           ← Esencia y personalidad
│   ├── TOOLS.md          ← Rate limits y configuración
│   ├── SUBAGENTES.md     ← Registro de sub-agentes
│   ├── SECURITY_PROTOCOL.md ← Protocolos de seguridad
│   ├── APRENDIZAJE.md    ← Patrones aprendidos
│   ├── APRENDIZAJE_ACTIVO.md ← Aprendizaje activo
│   ├── SKILL_INVENTORY.md ← Inventario de 896 skills
│   ├── HEARTBEAT.md      ← Tareas periódicas
│   ├── BACKUP_AUTO.md    ← Protocolo de backup
│   ├── RULES.md          ← Reglas inquebrantables
│   ├── MIGRATION_GUIDE.md ← Guía de migración
│   └── OPENCLAW_KNOWLEDGE.md ← Conocimiento de OpenClaw
│
├── 📁 config/            ← Configuración adicional
│   └── openclaw.json     ← Copia del config de OpenClaw
│
├── 📄 openclaw.json      ← Configuración principal de OpenClaw
│
├── 📁 scripts/           ← Scripts Python, JS, Bash
│   ├── auto_commit_github.sh
│   ├── backup-daemon.sh
│   ├── backup_auto_md.py
│   ├── install_juanita.sh
│   ├── juanita_backup.sh
│   ├── menu_backend.py
│   ├── model_manager.sh
│   └── ...
│
├── 📁 skills/            ← Skills activos (20 actualmente)
│   ├── arquitecto/
│   ├── auto-resolver/
│   ├── brave/
│   ├── context-guard/
│   ├── deep-research/
│   ├── log-diario/
│   ├── mantenimiento/
│   ├── md-optimizer/
│   ├── pdf/
│   ├── prompt-enhancer/
│   ├── prompts-chat/
│   ├── skill-creator/
│   ├── speed/
│   ├── tmux/
│   ├── voice/
│   └── ...
│
├── 📁 skills_backup/     ← Skills en backup (896 total)
│   └── ... (skills no activos)
│
├── 📁 memory/            ← Memoria diaria
│   ├── 2026-03-02.md
│   ├── 2026-03-03.md
│   ├── 2026-03-04.md
│   ├── fails/            ← Correcciones de errores
│   ├── learnings/        ← Aprendizajes
│   └── scoring/          ← Métricas
│
├── 📁 log_diario/        ← Registros diarios de actividades
│
├── 📁 data/              ← Datos estructurados (CSVs, JSONs)
│
├── 📁 docs/              ← Documentación adicional (PDFs)
│
├── 📁 documentos_pdf/    ← PDFs procesados
│
├── 📁 temp/              ← Archivos temporales (no se backup)
│
├── 📁 audio/             ← Archivos de audio (no se backup)
│
├── 📁 media/             ← Imágenes/videos (no se backup)
│
└── 📁 archive/           ← Archivos archivados
```

---

## Contenido del Backup

### Archivos incluidos
- `openclaw.json` — Configuración principal de OpenClaw
- Todos los archivos `.md` de configuración (raíz)
- `skills/` — Skills activos
- `skills_backup/` — Todos los skills disponibles
- `scripts/` — Scripts de utilidad
- `memory/` — Memoria diaria (sin backups duplicados)
- `log_diario/` — Logs de actividades
- `data/` — Datos estructurados
- `documentos_pdf/` — PDFs procesados

### Archivos EXCLUIDOS
- `.env` — API keys (NVIDIA, GitHub, etc.)
- `scripts/vosk-model-es/` — Modelo Vosk (1.2GB)
- `temp/` — Archivos temporales
- `audio/` — Archivos de audio
- `media/` — Imágenes y videos
- `memory/backup_md_*/` — Backups duplicados

---

## Instrucciones de Migración a Nueva VM

### Paso 1: Crear nueva VM
- Proveedor sugerido: Google Cloud (con $300 trial) u otro VPS
- Mínimo: 4GB RAM, 2 vCPU, 50GB disco
- Recomendado: 8GB RAM, 4 vCPU, 100GB disco

### Paso 2: Instalar OpenClaw
```bash
# Instalar Node.js 22
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs

# Instalar OpenClaw
npm install -g openclaw

# Crear directorio de trabajo
mkdir -p ~/.openclaw/workspace
```

### Paso 3: Clonar este repo
```bash
cd ~/.openclaw/workspace
git clone https://github.com/JerryblackVe/JUANITA_FINAL.git .
```

### Paso 4: Restaurar configuración
```bash
# Copiar openclaw.json a su ubicación
cp openclaw.json ~/.openclaw/

# Crear archivo .env con las API keys
nano ~/.openclaw/.env
```

### Paso 5: Configurar API keys
Crear/editar `~/.openclaw/.env`:
```
NVIDIA_API_KEY=tu_key_aqui
GITHUB_TOKEN=tu_token_aqui
BRAVE_API_KEY=tu_key_aqui
SERPER_API_KEY=tu_key_aqui
```

### Paso 6: Iniciar OpenClaw
```bash
# Iniciar gateway
openclaw gateway start

# Verificar estado
openclaw status
```

### Paso 7: Descargar modelo Vosk (opcional, si se usa voice)
```bash
cd ~/.openclaw/workspace/scripts
wget https://alphacephei.com/vosk/models/vosk-model-es-0.42.zip
unzip vosk-model-es-0.42.zip
mv vosk-model-es-0.42 vosk-model-es
rm vosk-model-es-0.42.zip
```

---

## Modelos configurados (NVIDIA NIM)

| Alias | Modelo | Uso |
|-------|--------|-----|
| minimax-nvidia | minimax-m2.5 | Principal |
| kimi-nvidia | kimi-k2-instruct | Thinking profundo |
| qwen | qwen3.5-397b-a17b | Razonamiento |
| glm5 | glm5 | Rápido |

---

## Skills activos (20)

- arquitecto
- auto-resolver
- autonomia_operativa
- autonomous-saas
- brave
- context-guard
- crawl4ai
- deep-research
- firecrawl-scraper
- log-diario
- mantenimiento
- md-optimizer
- pdf
- prompt-enhancer
- prompts-chat
- scrapling
- scrapy
- skill-creator
- speed
- tmux
- voice
- zenrows

---

## Contacto

- Usuario: JEFESITO (Gerardo Gonzalez)
- Telegram: @GerardoNQ
- Repo: https://github.com/JerryblackVe/JUANITA_FINAL

---

*Backup generado: 2026-03-05*
*JUANITA — Asistente personal de JEFESITO*
