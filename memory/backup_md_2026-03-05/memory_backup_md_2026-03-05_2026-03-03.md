# 2026-03-03 — Memoria del día

## [10:07] PLANIFICACIÓN — Migración de VM

**CRÍTICO — Alerta de vencimiento:**
- VM actual (JUANITA3) en Azure vence: **6 de marzo de 2026**
- Nueva VM con GPU debe estar lista **ANTES del 6 de marzo**
- Un día antes (5 de marzo) → recordar hacer backup + migración

**Tareas pendientes antes del vencimiento:**
- [ ] Hacer backup completo del sistema
- [ ] Crear cuenta en Google Cloud (u otro proveedor con GPU)
- [ ] Instalar OpenClaw en nueva VM
- [ ] Restaurar backup
- [ ] Configurar modelos locales (Qwen/Llama) en VM con GPU
- [ ] Conectar via API al OpenClaw principal

**Proveedor GPU objetivo:** Google Cloud (Tesla T4, $300free/90 días)
**Modelos objetivo para GPU local:** Qwen 2.5 7B, Llama 3 8B

**Estado actual del sistema:**
- JUANITA3 corriendo en Azure VM (Ubuntu 24)
- Skills activos: 14+
- Memoria y configuraciones guardadas
---

## [16:58] CHECKPOINT — Pre-session close by user

### ContextGuard Skill (COMPLETADO)
- **Creado:** skills/context-guard/SKILL.md
- **Propósito:** Monitoreo de tokens, alertas, pre-renew save
- **Config:** skills/context-guard/config.json (límites por modelo)
- **Límites:** Alerta 75%, Crítico 85%
- **Integración:** HEARTBEAT.md actualizado con monitoreo silencioso

### Autonomous SaaS Workflow (EN PROCESO)
- **Concepto:** Usar APIs (Kimi/MiniMax/DeepSeek) en lugar de Claude Code local
- **Ventaja:** No requiere GPU (las APIs ya tienen la compute)
- **Workflow:** Brief → Plan → Código via API → Review en Cursor → Deploy Vercel
- **Documentación leída:** Autonomous SaaS.docx.pdf, Mission Control Center.pdf
- **Pendiente:** Armar workflow sistematizado con subagente

### PDFs Revisados Hoy
1. Autonomous SaaS.docx.pdf ✓
2. Mission Control Center.pdf ✓

### Estado Actual
- Contexto: ~70%+ (por eso el error anterior)
- Sesión requiere /new
- Skills activos: 20+
- Pendiente: Migración VM (6 марта)

### Acciones Recomendadas para el Usuario
1. Escribir /new para renovar sesión
2. O cerrar y JUANITA continuará desde memory/

---

---

## [14:07-16:55] Sesión ContextGuard & Documentos

### 📄 Revisión de PDFs
- #1 Autonomous SaaS (Local Builder Playbook)
- Workflow: Brief → OpenClaw → Claude Code → GitHub → Vercel
- Discusión: Se puede implementar con APIs (Kimi/MiniMax) sin GPU

### 🎯 Skill ContextGuard Creado
**Archivos:**
- skills/context-guard/SKILL.md (4762 bytes)
- skills/context-guard/config.json (límites por modelo)
- docs/HEARTBEAT.md actualizado

**Funcionalidades:**
- Monitorea tokens según modelo activo
- Alertas: 75% suave, 85% crítica
- Guardado automático en memory/ + log_diario/
- Flujo completo pre-renew para no perder contexto

### ⚠️ Estado Contexto
- MiniMax M2.5: ~137k/196k tokens (70%)
- Error 400 por context length exceeded durante creación
- Skill listo para prevenir esto en el futuro

### 📋 Pendiente Post-Migración
- Probar ContextGuard en nueva sesión
- Configurar Google Cloud VM con GPU
- Instalar Qwen/Llama locales

---

## [17:14] Skill + Subagente Autonomous SaaS creado

**Skill creado:** `skills/autonomous-saas/`
- SKILL.md: Workflow completo de generación SaaS
- AGENT.md: Config del subagente  
- config.json: Metadata

**Funcionalidad:**
- Recibe brief de proyecto
- Genera SPEC.md
- Genera código con APIs (Kimi/MiniMax/DeepSeek)
- Muestra resultado para review

**Subagente:** Se ejecutará cuando usuario pida crear proyecto

---

## [19:00] Proyecto relog_aguja desplegado ✅

**Workflow completado automático:**
1. Skill autonomous-saas creado
2. Brief: reloj aguja analógico, fondo negro, UX moderno
3. Código generado (index.html completo)
4. GitHub: https://github.com/JerryblackVe/relog_aguja
5. Vercel: https://relogaguja.vercel.app

**Feedback usuario:** "se ve re bien" ✅

---

## [19:21] Actualización SECURITY_PROTOCOL.md

**Cambios:**
- Agregada sección 0: Herramienta (Cisco AI Defense skill-scanner)
- Agregada REGLA RC: Todo skill nuevo o del backup debe escanearse
- Agregada sección 2: Skills del backup (siempre escanear)
- Agregada sección 6: Tabla de riesgos clara
- Reglas de oro actualizadas

**Criterios:**
- INFO/LOW → ✅ Aprobar
- MEDIUM → ⚠️ Pedir aprobación
- HIGH/is_safe:false → ❌ RECHAZAR

---

## [19:27] Proyectos.md Creado

**Archivo:** docs/PROYECTOS.md

**Contenido:**
- Portfolio centralizado de proyectos
- Registro de relog_aguja con URLs, tech stack, historial
- Template para nuevos proyectos
- Workflow para generación y versionado
- Comandos para modificar y versionar

**Stats:**
- Total proyectos: 1
- Último: relog_aguja
