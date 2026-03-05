# OPENCLAW KNOWLEDGE BASE
Resumen consolidado extraído de la documentación oficial de OpenClaw (17 PDFs)

---
**Fecha de extracción:** 2026-03-03  
**Fuentes:** 17 documentos PDF de documentación OpenClaw  
**Ubicación:** ~/.openclaw/workspace/documentos_pdf/

---

## ÍNDICE
1. [OpenClaw Platform Guide](#openclaw-platform-guide)
2. [Installation Guide](#installation-guide)
3. [Skills Security Guide](#skills-security-guide)
4. [Token Guide](#token-guide)
5. [Token Optimization Guide](#token-optimization-guide)
6. [Prompt Caching Guide](#prompt-caching-guide)
7. [SEO Guide Professional](#seo-guide-professional)
8. [Training Guide](#training-guide)
9. [Cold Outreach Playbook](#cold-outreach-playbook)
10. [UGC Automation Guide](#ugc-automation-guide)
11. [ML Ops Guide](#ml-ops-guide)
12. [Security Hardening Guide](#security-hardening-guide)
13. [Cron Jobs Guide](#cron-jobs-guide)
14. [Building Skill for Claude Guide](#building-skill-for-claude-guide)
15. [Sprint Setup Guide](#sprint-setup-guide)
16. [Autonomous SaaS](#autonomous-saas)
17. [Mission Control Center](#mission-control-center)

---

## RESUMENES POR DOCUMENTO

### 1. OpenClaw Platform Guide
**Conceptos clave:** Comparativa de plataformas (Mac vs PC vs VPS), configuración, casos de uso, troubleshooting
**Comandos principales:**
- Mac: `brew install node git`, `node -v`, `git --version`, `caffeinate -s`, `nvm install 18`
- Windows: WSL2 setup, `node --version`
- VPS: SSH basics, Linux admin
**Configuraciones:**
- API keys en `.env` (Anthropic, OpenAI)
- Model routing: 85% Haiku / 15% Sonnet para optimización de costos
- Port configuration en `.env`
**Problemas comunes:**
- Mac: Sleep/lid close mata procesos (usar `caffeinate` o Amphetamine)
- Port conflicts (usar `lsof -i :[port]`)
- Node version mismatches (usar `nvm`)
- Rosetta issues en Apple Silicon
- File permission errors

### 2. Installation Guide
**Conceptos clave:** Framework open-source de automatización con AI, orquestación de agentes, optimización de costos
**Comandos principales:**
- Instalación one-liner: `curl -fsSL https://openclaw.ai/install.sh | bash`
- Verificar instalación: `openclaw --version`
- Inicializar proyecto: `openclaw init`
- Configurar API keys: `openclaw config set ANTHROPIC_API_KEY sk-ant-your-key-here`
- Configurar OpenAI: `openclaw config set OPENAI_API_KEY sk-your-key-here`
**Requisitos:**
- OS: macOS 12+, Ubuntu 20.04+/Debian 11+, Windows con WSL2
- Node.js: v18+ (recomendado v20 LTS)
- Git: cualquier versión reciente
- RAM: mínimo 4GB (8GB+ recomendado)
- Disk: 2GB libres
**Configuraciones:**
- Archivo: `openclaw.config`
- Model routing 3-tier:
  - Tier 1 (tareas rutinarias): `claude-haiku-4-5`, max_tokens: 1000
  - Tier 2 (ejecución compleja): `claude-sonnet-4-5`, max_tokens: 4000
  - Tier 3 (decisiones estratégicas): `claude-opus-4-6`, max_tokens: 8000
**Proveedores VPS recomendados:**
- DigitalOcean: $6/mo (beginners)
- Hetzner: €4.50/mo (cost efficiency)

### 3. Skills Security Guide
**ADVERTENCIA CRÍTICA:** 341+ skills maliciosos encontrados en ClawHub, 283 skills (7.1%) con exposición de credenciales críticas
**Conceptos clave:** Seguridad de skills, amenazas en el ecosistema, modelos de ataque
**Estadísticas de seguridad (Feb 2026):**
- 341 skills maliciosos (Koi Security) - 335 de campaña coordinada "ClawHavoc"
- 283 skills (7.1%) con fugas de credenciales
- 512 vulnerabilidades en OpenClaw (Kaspersky) - 8 críticas
- 30,000+ instancias expuestas en Censys
- 354 paquetes maliciosos de actor "Hightower6eu"
- Skill #1 más descargado confirmado como malware
**Modelos de ataque:**
- Fake Prerequisites: Instalar "dependencias" que son malware
- Typosquatting: Variantes mal escritas de skills populares
- Silent Data Exfiltration: curl commands que envían datos a servidores atacantes
- Reverse Shell Backdoors: Abrir conexiones remotas
- Credential Harvesting: Leer .env files y enviar a webhooks
- Leaky Instructions: API keys en context window en plaintext
**Categorías más atacadas:**
- Crypto Tools (111 skills) - Solana, Phantom, wallets
- YouTube Utilities (57 skills)
- Polymarket Bots (34 skills)
- ClawHub Typosquats (29 skills)
- Auto-Updaters (28 skills)
**Reglas de seguridad:**
- NO ejecutar OpenClaw en dispositivos corporativos
- Revisar skills antes de instalar de ClawHub
- Rota credenciales inmediatamente si hay exposición
- Skills load precedence: workspace → ~/.openclaw/skills → bundled

### 4. Token Guide (Messenger Session Management)
**Conceptos clave:** Gestión de sesiones en messenger agents para reducir tokens
**Problema:** Los agentes de messenger envían TODO el historial con cada API call, costos crecen exponencialmente (puede significar diferencia de $1,500/mes a $100/mes)
**Comandos de sesión:**
- `/clear`, `/new`, `/reset`, `clearsession`, `newsession`, `startfresh`, `SESSION_CLEARED`
**Prompt: Session Clear Handler:**
```
## SESSION MANAGEMENT
On Session Clear:
1. Discard ALL prior conversation context
2. Do NOT reference/summarize/carry forward anything before
3. Respond: "[SESSION CLEARED] Fresh session started. How can I help?"
4. Begin next interaction as brand new conversation
5. Retain ONLY: system prompt, persistent memory files, project context
```
**Auto-Clear Rules:**
- 30+ mensajes: enviar warning de token usage alto
- 
50+ mensajes: auto-clear y notificar `[AUTO-CLEARED] Session reset`
**Persistent Memory System:**
- `/project/identity.md` (500 tokens max): nombre, rol, personalidad
- `/project/context.md` (800 tokens max): detalles de proyecto actual
- `/project/tasks.md` (600 tokens max): tareas activas, status, deadlines
- `/project/log.md` (400 tokens max, ~20 entries): decisiones clave en formato `[DATE] [ACTION] Descripción`
**Context Compression Rules:**
- Tamaños máximos estrictos para cada archivo
- Usar abreviaciones: usr, proj, msg, req, cfg
- No artículos (a, an, the) ni filler words
- Símbolos: -> (leads to), = (equals/is), + (and), ! (important), ? (pending)
- One concept per line

### 5. OpenClaw Token Optimization Guide
**Conceptos clave:** Optimización extrema de costos, reducción de tokens en 97%, gestión de sesiones, routing inteligente de modelos
**Estrategias principales:**
1. **Session Initialization Rule:** Cargar solo SOUL.md, USER.md, IDENTITY.md, memory/YYYY-MM-DD.md al inicio. No auto-cargar MEMORY.md, historial de sesiones, mensajes previos, outputs de herramientas.
2. **Model Routing:** Configuración recomendada:
   - Haiku: 85%+ de solicitudes (tareas rutinarias, consultas simples)
   - Sonnet: 10-15% (razonamiento complejo, generación de contenido creativo)
   - Opus: <2% (decisiones críticas de negocio)
3. **Heartbeat a Ollama:** Mover chequeos periódicos a LLM local gratuito usando Ollama con modelo llama3.2:3b. Configuración en openclaw.json.
4. **Rate Limits & Budget Controls:** 
   - 5 segundos mínimo entre llamadas API
   - 10 segundos entre búsquedas web
   - Máximo 5 búsquedas por lote, luego pausa de 2 minutos
   - Presupuesto diario: $5 (warning al 75%)
   - Presupuesto mensual: $200 (warning al 75%)
**Configuración modelo:** `~/.openclaw/openclaw.json`
```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "anthropic/claude-haiku-4-5"
      },
      "models": {
        "anthropic/claude-sonnet-4-5": { "alias": "sonnet" },
        "anthropic/claude-haiku-4-5": { "alias": "haiku" }
      }
    }
  }
}
```
**Impacto de costos:** Antes: $1,500+/mes → Después: $30-50/mes

### 6. OpenClaw Prompt Caching Guide
**Conceptos clave:** Cache de prompts de Anthropic, retención configurable, optimización de costos
**Configuración de cache:**
- **none:** Sin caching
- **short:** 5 minutos (default con API key)
- **long:** 1 hora (requiere beta flag)
**Configuración en OpenClaw:**
```json
{
  "agents": {
    "defaults": {
      "models": {
        "anthropic/claude-opus-4-6": {
          "params": { "cacheRetention": "long" }
        }
      }
    }
  }
}
```
**Requisitos:**
- Debe usar API key de Anthropic (no setup-token/subscription)
- Beta flag automático: `extended-cache-ttl-2025-04-11`
**Beneficios:** 50-90% reducción de costos en llamadas API repetitivas
**Migración desde legacy:** `cacheControlTtl: "5m"` → `cacheRetention: "short"`

### 7. OpenClaw SEO Content Automation Guide
**Conceptos clave:** Sistema automatizado de SEO, investigación de keywords, creación de contenido, publicación autónoma
**Workflow completo:**
1. **Cada 6 horas:** Descubrimiento de tendencias (Brave Search, Reddit, NewsAPI)
2. **Diario:** Validación de keywords y competencia
3. **Diario:** Creación de 1-2 artículos optimizados (1500-2000 palabras)
4. **Diario:** Publicación a WordPress/Ghost/Medium
5. **Trackeo de performance** y auto-optimización
**Estructura de carpetas:**
```
seo-automation/
├── trends/           # Tendencias detectadas
├── keywords/         # Keywords investigadas
├── articles/
│   ├── drafts/      # Borradores
│   └── published/   # Publicados
├── config/          # API keys, niches
└── logs/           # Registros del sistema
```
**APIs requeridas:**
- Brave Search API (2000 queries/mes gratis)
- Reddit API (app script)
- WordPress (Application Password)
- NewsAPI (100 requests/día gratis opcional)
**Niches config:**
```json
{
  "primary_niches": ["AI automation", "SaaS tools", "no-code development"],
  "subreddits": ["Entrepreneur", "SaaS", "startups"],
  "target_keywords_per_day": 5,
  "articles_per_day": 2,
  "min_trend_score": 70
}
```
**Costos:** $2-5 por día en llamadas API

### 8. OpenClaw Agent Training Guide
**Conceptos clave:** Organización multi-agente, project folders, task folders, routing de modelos
**Estructura de tres capas:**
1. **Project Folder:** Negocio o cliente (ej: "YesChefOS", "Client: Joe's Pizza")
2. **Task Folder:** Workflow específico dentro del proyecto (ej: "Cold Outreach", "Blog SEO")
3. **Agent/Model:** Modelo AI asignado (Haiku para tareas rápidas, Sonnet para complejas)
**Task Folder Templates:**
- **Cold Email Outreach:** Email personalizado <100 palabras, estructura específica
- **Social Media Content:** Contenido para plataformas específicas con hooks y CTAs
- **SEO Blog Content:** Posts optimizados con keywords, estructura H1>H2>H3
- **Customer Support Responses:** Respuestas <150 palabras, tono cálido pero profesional
- **UGC Script Writing:** Scripts de 30-60 segundos, formato auténtico
**Model Routing Strategy:**
- **Tier 1 (Haiku):** Tareas rápidas, repetitivas, basadas en templates
- **Tier 2 (Sonnet):** Ejecución compleja, escritura creativa, análisis
- **Tier 3 (Opus):** Estrategia, decisiones de alto riesgo, razonamiento matizado
**Universal Task Folder Prompt:** Incluye role, context, output rules, examples buenos/malos

### 9. OpenClaw Cold Outreach Playbook
**Conceptos clave:** Detección de señales, scraping de datos, descubrimiento de emails, validación, infrastructure de cold email
**Fases:**
1. **Signal Detection:** Monitoreo continuo de hiring signals, tech stack changes, funding signals, pain point signals
2. **Data Scraping:** Setup multi-agente para extracción de datos
3. **Finding Decision Makers:** Descubrimiento de emails y contactos
4. **Email Validation:** Limpieza de listas con herramientas como ZeroBounce
5. **Domain Setup:** Compra y configuración de dominios para sending
6. **Cold Email Infrastructure:** Instantly.ai o alternativas
7. **Writing Personalized Cold Emails:** Estructura de email optimizada
8. **Data Management:** CSV & Google Sheets para tracking
9. **Performance Dashboard:** Dashboard de métricas y resultados
**ICP Definition:** JSON estructurado con tamaño de empresa, industria, revenue, títulos de trabajo, pain points
**Signal Types:** Hiring, Tech Stack Changes, Funding, Pain Point, Growth, Compliance, Content, Competitor
**Costos:** Sistema completo desde detección hasta cierre de deals

### 10. OpenClaw UGC Automation Guide
**Conceptos clave:** Automatización de contenido UGC, generación de avatares AI, voiceovers, ensamblaje de video
**Stack tecnológico:**
- **Orchestration:** OpenClaw
- **Script Generation:** Claude Haiku/Sonnet
- **Voice Generation:** ElevenLabs, PlayHT, OpenAI TTS
- **Avatar/Talking Head:** HeyGen, Synthesia, D-ID, Captions AI
- **B-Roll & Images:** Pexels API, Unsplash, Runway ML, Midjourney
- **AI Video Generation:** OpenAI Sora, Google Veo 3.1
- **Video Assembly:** FFmpeg, Remotion, Creatomate API
- **Captions/Subtitles:** Whisper API, AssemblyAI
- **Publishing:** APIs de redes sociales via OpenClaw
**Cost Optimization:** Route 85% de script generation a Haiku ($0.25/1M tokens), reservar Sonnet ($3/1M tokens) para polish final
**Workflow completo:** Script → Voice → Avatar → B-Roll → Assembly → Captions → Publishing
**Training Assets:** Video de avatar (10-20 minutos), audio de voz (5-15 minutos) guardados en `~/content/avatar_training/` y `~/content/voice_training/`
**Costos por video:** $2-10 vs $200-500 tradicional

### 11. OpenClaw ML Ops Guide
**Conceptos clave:** Operaciones de machine learning para agentes autónomos, feedback loops, aprendizaje compuesto
**Arquitectura de cinco capas:**
1. **Data Infrastructure:** Memory Store, Action Logger, Outcome Collector
2. **Intelligence Layer:** Pattern Analyzer, Prompt Optimizer, Loop Orchestrator
3. **Advanced ML Techniques:** Multi-Agent Reinforcement, A/B Testing Automation, Negative Example Injection
4. **Cost-Quality Frontier Optimization:** Balance entre costo y calidad
5. **Cross-Agent Knowledge Transfer:** Compartir aprendizaje entre agentes
**Use Cases:**
- Cold Outreach Engine
- Content Intelligence System
- Lead Qualification Loop
- Customer Support Optimizer
- Token Cost Reduction System
**ML Ops vs Standard Automation:** Memoria persistente, mejora autónoma, performance compuesta, reducción de costos, competitive moat
**Mecanismos de aprendizaje:** In-context learning, automated prompt engineering, systematic feedback loops

### 12. OpenClaw Security Hardening Guide
**Conceptos clave:** Hardening post-deployment, auditorías de seguridad, configuraciones seguras, prompts para agentes
**Proceso de hardening:**
1. **Pre-Hardening Assessment:** Auditoría completa, inventory de API keys, webhooks, integraciones
2. **Threat Model:** API Key Theft (CRITICAL), Prompt Injection (HIGH), Model Abuse (HIGH), Webhook Hijacking
3. **Security Controls:** Configuraciones específicas para cada amenaza
**Agent Prompts:** Prompts listos para copiar y pegar para cada paso de hardening
**Checklists:** Configuración auditada, vulnerabilidades encontradas, prioridades de fix
**Configuraciones críticas:** Rotación de credenciales, rate limiting, autenticación, cifrado

### 13. OpenClaw Cron Jobs Guide
**Conceptos clave:** Scheduling de tareas automáticas, cron jobs en Gateway, delivery a canales
**Tipos de schedule:**
- **at:** One-shot timestamp (ej: "2026-02-01T16:00:00Z")
- **every:** Intervalo en ms (ej: "30m")
- **cron:** Expresión de 5 campos + timezone (ej: "0 7 * * *")
**Sessions:**
- **Main:** Corre en contexto de heartbeat
- **Isolated:** Sesión fresca en cron:<jobId> sin clutter de chat
**Delivery Modes:**
- **announce:** Entrega output a WhatsApp/Telegram/Slack/Discord
- **none:** Corre silenciosamente
**Model Overrides:** `--model opus --thinking high` por job
**Jobs stored at:** `~/.openclaw/cron/jobs.json` - persiste entre restarts
**Ejemplos comunes:**
- `* * * * *` (cada minuto)
- `*/5 * * * *` (cada 5 minutos)
- `0 * * * *` (cada hora)
- `0 0 * * *` (diario a medianoche)
- `0 7 * * *` (diario a 7 AM)
- `0 8 * * 1-5` (weekdays a 8 AM)

### 14. The Complete Guide to Building Skill for Claude
**Conceptos clave:** Creación de skills para Claude, estructura SKILL.md, testing, distribución
**Skill Structure:**
- **SKILL.md (required):** Instrucciones en Markdown con YAML frontmatter
- **scripts/ (optional):** Código ejecutable (Python, Bash, etc.)
- **references/ (optional):** Documentación cargada según necesidad
- **assets/ (optional):** Templates, fonts, icons usados en output
**Core Design Principles:**
- **Progressive Disclosure:** Three-level system (YAML frontmatter → SKILL.md body → Linked files)
- **Portability:** Funciona igual en Claude.ai, Claude Code, y API
- **Composability:** Múltiples skills cargadas simultáneamente
**Skills + MCP:** Skills como capa de conocimiento sobre MCP (connectivity layer)
**Development Process:** Planning → Design → Testing → Iteration → Distribution
**Best Practices:** Clear triggers, focused scope, examples, testing with edge cases

### 15. Sprint Setup Guide (AI Video Automation)
**Conceptos clave:** Pipeline de video automatizado, clonación de voz y rostro, publicación diaria
**System Stack:** OpenClaw + HeyGen + ElevenLabs + Buffer
**Workflow de 12 agentes:** Corre automáticamente cada mañana, genera videos con voz y rostro clonados
**Training Assets Recording:**
- **Avatar Video:** 10-20 minutos continuos, 1080p, lighting apropiado, fondo plano
- **Voice Audio:** 5-15 minutos, mic consistente, cero ruido ambiental, variación emocional
**File Locations:**
```
~/content/avatar_training/avatar_v1.mp4
~/content/voice_training/voice_v1.mp3
```
**API Keys requeridas:** HEYGEN_API_KEY (Studio tier+), ELEVENLABS_API_KEY (Creator tier+), BUFFER_ACCESS_TOKEN
**Costos:** ~$130-165/mes para 30 videos publicados en 3 plataformas
**Output:** Videos diarios en TikTok, Instagram Reels, YouTube Shorts con aprobación humana mínima

### 16. Autonomous SaaS (Local Builder Playbook)
**Conceptos clave:** Stack de construcción local autónomo, OpenClaw + Claude Code Max + Cursor + GitHub + Vercel
**Build Loop:**
1. **You:** Brief OpenClaw en inglés plano
2. **OpenClaw:** Lee contexto del producto, planifica task breakdown, escribe spec técnico
3. **OpenClaw:** Ejecuta `claude "<full task spec>"` en terminal local
4. **Claude Code:** Lee codebase completo, construye feature
5. **Claude Code:** Crea branch git, commits, push a GitHub, abre Pull Request
6. **Cursor:** Review del PR, test local, pequeñas ediciones
7. **You:** Aprobar y mergear PR en GitHub
8. **Vercel:** Detecta merge a main, deploy a producción en 60-90 segundos
9. **OpenClaw:** Detecta task completado, planifica y dispatch siguiente task
**Stack Components:**
- **OpenClaw (local):** Cerebro del proyecto, mantiene brief y sprint goals
- **Claude Code Max:** Constructor, recibe task prompt, escribe código
- **Cursor:** Cockpit para review y control
- **GitHub:** Almacenamiento de código y trigger de deploy
- **Vercel:** Hosting de producción, deploy automático
- **Supabase:** Base de datos del producto (no orchestration plumbing)
**Integración one-line:** `claude "<task prompt>"` en terminal

### 17. Mission Control Center
**Conceptos clave:** Dashboard local de operaciones AI, orchestration layer, management de proyectos estructurados
**Propósito:** Command center para operaciones AI (no reemplaza main OpenClaw Web UI)
**Funcionalidades:**
- **Projects:** Fundación de Mission Control, todo task/agent/schedule tied to project
- **Tasks:** Unidades de trabajo estructuradas (Plan, Build, Ops)
- **Agents and Sub Agents:** Descubiertos automáticamente desde `~/.openclaw/openclaw.json`
- **Scheduler and Cron Jobs:** Automatización recurrente con expresiones cron
**Project Dashboard:** Active tasks, assigned agents, scheduled jobs, recent runs, output artifacts, activity timeline
**Task Status Flow:** Backlog → Planned → In Progress → Blocked → Done
**Running Tasks:** Logs stream en vivo, outputs escritos a project output directory, run history saved
**URL:** `http://localhost:3001/`