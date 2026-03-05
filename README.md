# JUANITA - Backup para Migración

## ⚠️ ALERTA: VM EXPIRA EL 6 DE MARZO DE 2026

Esta VM de Azure expira el **6 de marzo de 2026**. Es CRÍTICO migrar todo antes de esa fecha.

---

## Contenido del Backup

### Archivos incluidos
- `openclaw.json` — Configuración principal de OpenClaw
- `AGENTS.md` — Guía del workspace
- `SOUL.md` — Personalidad de JUANITA
- `USER.md` — Perfil de JEFESITO
- `IDENTITY.md` — Identidad
- `MEMORY.md` — Memoria de largo plazo
- `TOOLS.md` — Modelos y rate limits
- `HEARTBEAT.md` — Tareas periódicas
- `BOOTSTRAP.md` — Secuencia de arranque
- `APRENDIZAJE_ACTIVO.md` — Preferencias y patrones
- `skills/` — Todos los skills instalados
- `scripts/` — Scripts de utilidad
- `docs/` — Documentación
- `memory/` — Memoria diaria
- `data/` — Datos estructurados

### Archivos EXCLUIDOS (no se suben)
- `.env` — API keys (NVIDIA, GitHub, etc.)
- `scripts/vosk-model-es/` — Modelo Vosk (1.2GB, muy grande)
- `temp/` — Archivos temporales
- `audio/` — Archivos de audio
- `media/` — Imágenes y videos

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

### Paso 7: Descargar modelo Vosk (si se usa voice)
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

---

## Skills activos

- arquitecto
- auto-resolver
- brave
- deep-research
- log-diario
- mantenimiento
- md-optimizer
- pdf
- prompt-enhancer
- prompts-chat
- skill-creator
- speed
- tmux
- voice

---

## Contacto

- Usuario: JEFESITO (Gerardo Gonzalez)
- Telegram: @GerardoNQ
- Repo: https://github.com/JerryblackVe/JUANITA_FINAL

---

*Backup generado: 2026-03-05*
*JUANITA — Asistente personal de JEFESITO*
