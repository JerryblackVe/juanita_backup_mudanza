# JUANITA - Backup para Migración

## ⚠️ ALERTA: VM EXPIRA EL 6 DE MARZO DE 2026

Esta VM de Azure expira el **6 de marzo de 2026**. Es CRÍTICO migrar todo antes de esa fecha.

---

## 📋 Índice

1. [Qué es JUANITA](#qué-es-juanita)
2. [Estructura del Backup](#estructura-del-backup)
3. [Instrucciones de Instalación](#instrucciones-de-instalación)
4. [Configuración Post-Instalación](#configuración-post-instalación)
5. [API Keys Necesarias](#api-keys-necesarias)
6. [Modelos Disponibles](#modelos-disponibles)
7. [Skills Activos](#skills-activos)
8. [Solución de Problemas](#solución-de-problemas)

---

## 🤖 Qué es JUANITA

JUANITA es un asistente personal basado en OpenClaw que corre en una VM. Está configurada para:

- Responder mensajes por Telegram
- Ejecutar tareas automatizadas
- Gestionar backups automáticos
- Coordinar sub-agentes para tareas complejas

---

## 📁 Estructura del Backup

```
~/.openclaw/workspace/
│
├── 📄 Archivos de configuración (raíz):
│   ├── AGENTS.md          ← Guía del workspace (leer al inicio)
│   ├── USER.md            ← Perfil de JEFESITO
│   ├── IDENTITY.md        ← Identidad de JUANITA
│   ├── MEMORY.md          ← Memoria de largo plazo
│   ├── SOUL.md            ← Esencia y personalidad
│   ├── TOOLS.md           ← Rate limits y modelos
│   ├── HEARTBEAT.md       ← Tareas periódicas
│   ├── BACKUP_AUTO.md     ← Protocolo de backup
│   ├── APRENDIZAJE_ACTIVO.md ← Sistema de aprendizaje
│   └── BOOTSTRAP.md       ← Secuencia de arranque
│
├── 📄 openclaw.json       ← Configuración principal de OpenClaw
├── 📄 README.md           ← Este archivo
│
├── 📁 skills/             ← Skills activos (20)
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
├── 📁 skills_backup/      ← Skills adicionales (896 total)
│
├── 📁 scripts/            ← Scripts de utilidad
│   ├── auto_commit_github.sh
│   ├── backup_auto_md.py
│   ├── juanita_backup.sh
│   └── ...
│
├── 📁 memory/             ← Memoria diaria
│   ├── 2026-03-04.md
│   ├── 2026-03-05.md
│   └── ...
│
├── 📁 log_diario/         ← Logs de actividades
│
├── 📁 data/               ← Datos estructurados
│
├── 📁 docs/               ← Documentación adicional
│
└── 📁 temp/               ← Archivos temporales (no se backup)
```

---

## 🚀 Instrucciones de Instalación

### Paso 1: Crear VM

**Requisitos mínimos:**
- Ubuntu 22.04 o 24.04
- 4GB RAM mínimo (recomendado 8GB)
- 50GB disco mínimo (recomendado 100GB)
- Acceso SSH

**Proveedores sugeridos:**
- Google Cloud ($300 trial)
- DigitalOcean ($200 credit)
- Azure (student account)
- AWS (free tier)

### Paso 2: Instalar dependencias

```bash
# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar Node.js 22
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs

# Verificar instalación
node --version  # debe mostrar v22.x.x
npm --version

# Instalar Python y venv
sudo apt install -y python3 python3-pip python3-venv git curl wget

# Instalar herramientas adicionales
sudo apt install -y jq unzip
```

### Paso 3: Instalar OpenClaw

```bash
# Instalar OpenClaw globalmente
npm install -g openclaw

# Verificar instalación
openclaw --version
```

### Paso 4: Clonar este backup

```bash
# Crear directorio de trabajo
mkdir -p ~/.openclaw/workspace

# Clonar el repo
cd ~/.openclaw/workspace
git clone https://github.com/JerryblackVe/juanita_backup_mudanza.git .

# Copiar openclaw.json a su ubicación
cp openclaw.json ~/.openclaw/
```

### Paso 5: Crear entorno virtual

```bash
# Crear venv
python3 -m venv ~/.openclaw/venv

# Activar y instalar dependencias
source ~/.openclaw/venv/bin/activate
pip install --upgrade pip
pip install requests python-dotenv openai
```

### Paso 6: Configurar API Keys

```bash
# Crear archivo .env
nano ~/.openclaw/.env
```

Agregar las siguientes keys (ver sección [API Keys](#api-keys-necesarias)):
```
NVIDIA_API_KEY=tu_key_aqui
GITHUB_TOKEN=tu_token_aqui
BRAVE_API_KEY=tu_key_aqui
SERPER_API_KEY=tu_key_aqui
```

### Paso 7: Iniciar OpenClaw

```bash
# Iniciar el gateway
openclaw gateway start

# Verificar estado
openclaw status
```

### Paso 8: Configurar Telegram (si es necesario)

Si necesitás reconectar el bot de Telegram:

1. Ir a @BotFather en Telegram
2. Usar `/newbot` o `/mybots`
3. Obtener el token del bot
4. Agregar a `openclaw.json` en la sección `providers.telegram`

---

## ⚙️ Configuración Post-Instalación

### Verificar que todo funciona

```bash
# Verificar gateway
openclaw gateway status

# Verificar que el bot responde
# Enviar mensaje "hola" por Telegram

# Verificar modelos
openclaw models list
```

### Configurar backup automático

```bash
# El script de backup ya está en scripts/
# Para ejecutar manualmente:
cd ~/.openclaw/workspace
python3 scripts/backup_auto_md.py

# Para configurar cron (opcional):
crontab -e
# Agregar: 0 * * * * cd ~/.openclaw/workspace && python3 scripts/backup_auto_md.py
```

---

## 🔑 API Keys Necesarias

| Key | Para qué | Cómo obtenerla |
|-----|----------|----------------|
| **NVIDIA_API_KEY** | Modelos de IA (MiniMax, Qwen, Kimi) | https://build.nvidia.com/ |
| **GITHUB_TOKEN** | Backups automáticos | https://github.com/settings/tokens |
| **BRAVE_API_KEY** | Búsquedas web | https://brave.com/search/api/ |
| **SERPER_API_KEY** | Búsquedas alternativas | https://serper.dev/ |

### Cómo obtener cada key:

#### NVIDIA API Key
1. Ir a https://build.nvidia.com/
2. Crear cuenta / Log in
3. Ir a "API Keys" en el dashboard
4. Crear nueva key
5. Copiar y guardar en `.env`

#### GitHub Token
1. Ir a https://github.com/settings/tokens
2. "Generate new token (classic)"
3. Seleccionar permisos: `repo`, `workflow`
4. Generar y copiar

#### Brave API Key
1. Ir a https://brave.com/search/api/
2. Sign up para API gratuita
3. Copiar la key del dashboard

---

## 🤖 Modelos Disponibles

JUANITA usa NVIDIA NIM para acceder a modelos de IA:

| Alias | Modelo | Uso principal | Latencia |
|-------|--------|---------------|----------|
| `minimax-nvidia` | MiniMax M2.5 | Principal | ~600ms |
| `kimi-nvidia` | Kimi K2 Instruct | Thinking profundo | ~27s |
| `qwen` | Qwen 3.5 397B | Razonamiento | ~48s |
| `glm5` | GLM 5 | Rápido | ~400ms |
| `step-flash` | Step 3.5 Flash | Tareas rápidas | ~400ms |

### Cambiar modelo

```bash
# Cambiar a modelo específico
openclaw model set nvidia/minimaxai/minimax-m2.5

# O usar alias en el chat
# JEFESITO puede pedir cambiar modelo
```

---

## 🧩 Skills Activos

JUANITA tiene 20+ skills activos:

| Skill | Función |
|-------|---------|
| `arquitecto` | Planificación de proyectos |
| `auto-resolver` | Resolución de problemas |
| `brave` | Búsquedas web |
| `context-guard` | Monitoreo de tokens |
| `deep-research` | Investigación profunda |
| `log-diario` | Registro de actividades |
| `mantenimiento` | Mantenimiento del sistema |
| `md-optimizer` | Optimización de archivos .md |
| `pdf` | Manejo de PDFs |
| `prompt-enhancer` | Mejora de prompts |
| `skill-creator` | Creación de skills |
| `speed` | Test de latencia de modelos |
| `tmux` | Control de sesiones tmux |
| `voice` | Comunicación por voz |

### Agregar más skills

Los skills adicionales están en `skills_backup/`. Para activar:

```bash
# Mover skill de backup a activos
mv ~/.openclaw/workspace/skills_backup/nombre-skill ~/.openclaw/workspace/skills/

# Reiniciar OpenClaw para que detecte el nuevo skill
openclaw gateway restart
```

---

## 🔧 Solución de Problemas

### El bot no responde en Telegram

```bash
# Verificar que el gateway está corriendo
openclaw gateway status

# Si no está corriendo
openclaw gateway start

# Verificar logs
tail -f ~/.openclaw/logs/gateway.log
```

### Error: "API key not found"

```bash
# Verificar que .env existe
cat ~/.openclaw/.env

# Verificar formato correcto (sin espacios extra)
# Debe ser: KEY=valor (no KEY = valor)
```

### Error: "Model not available"

```bash
# Verificar modelos disponibles
openclaw models list

# Verificar que la API key de NVIDIA está configurada
echo $NVIDIA_API_KEY
```

### Git push falla

```bash
# Verificar que el token tiene permisos correctos
# Necesita permiso 'repo' y 'workflow'

# Reconfigurar remote con token
cd ~/.openclaw/workspace
git remote set-url origin https://TOKEN@github.com/JerryblackVe/juanita_backup_mudanza.git
```

### Backup automático no funciona

```bash
# Verificar que el script existe
ls -la ~/.openclaw/workspace/scripts/backup_auto_md.py

# Probar manualmente
cd ~/.openclaw/workspace
python3 scripts/backup_auto_md.py

# Verificar permisos
chmod +x ~/.openclaw/workspace/scripts/*.sh
```

---

## 📞 Contacto

- **Usuario:** JEFESITO (Gerardo Gonzalez)
- **Telegram:** @GerardoNQ
- **Repo:** https://github.com/JerryblackVe/juanita_backup_mudanza

---

## 📝 Notas de Versión

- **Fecha de backup:** 2026-03-05
- **Origen:** Azure VM (JUNITA)
- **OpenClaw versión:** v2026.2.26
- **Estado:** Listo para migración

---

*JUANITA — Asistente personal de JEFESITO*
*Argentina | Español*
