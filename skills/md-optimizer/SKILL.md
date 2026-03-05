---
name: md-optimizer
description: "Organiza y optimiza archivos .md del workspace. Activar con /optimize-md o cuando el usuario pida optimizar, analizar o mejorar archivos markdown del proyecto."
---

# MD-Optimizer

Skill para analizar y optimizar archivos .md del workspace OpenClaw.

## 📋 FASE 1 — ANÁLISIS (sin tocar nada)

### Paso 1.1: Identificar archivos .md
Leer todos los .md del workspace en docs/:
- docs/SOUL.md
- docs/USER.md
- docs/IDENTITY.md
- docs/MEMORY.md
- docs/TOOLS.md
- docs/SUBAGENTES.md
- docs/SECURITY_PROTOCOL.md
- docs/HEARTBEAT.md
- docs/MIGRATION_GUIDE.md
- docs/BACKUP_AUTO.md
- Cualquier otro .md en docs/

**RUTA CORRECTA:** ~/.openclaw/workspace/docs/

### Paso 1.2: Contar tokens
Para cada archivo, contar tokens actuales (usar método simple: palabras + estimación basedo en longitud).

### Paso 1.3: Detectar problemas

**🔴 Duplicados:** Misma regla exacta en dos o más archivos
- Buscar文本 identical entre archivos

**⚠️ Solapamientos:** Misma idea expresada diferente
- Ejemplo: "responder corto" en SOUL.md y "máx 3 frases" en TOOLS.md

**❌ Contradicciones:** Una regla dice A y otra dice lo opuesto
- Ejemplo: "siempre en español" vs "english allowed"

**🔗 Referencias rotas:**
- Rutas que no existen
- Scripts que no existen
- Sub-agentes mencionados que no están registrados
- Skills referenciados que no están instalados

**📏 Exceso de tokens:** Archivos muy largos que podrían comprimirse

### Paso 1.4: Generar reporte

```
📋 REPORTE MD-OPTIMIZER
──────────────────────
📊 Tokens actuales: [total]
🔴 Duplicados encontrados: [N]
⚠️ Solapamientos: [N]
❌ Contradicciones: [N]
🔗 Referencias rotas: [N]

Detalle:
- [archivo] → [problema encontrado]
- ...

💡 Ahorro estimado: ~[N] tokens (-[%])
──────────────────────
```

**ANTES de tocar nada, esperar aprobación explícita del usuario con "sí" o "sí, optimiza".**

## ✅ FASE 2 — OPTIMIZACIÓN (solo con aprobación)

### Paso 2.1: Backup
```bash
mkdir -p ~/.openclaw/workspace/memory/backup_md_$(date +%Y-%m-%d)/
cp ~/.openclaw/workspace/docs/*.md ~/.openclaw/workspace/memory/backup_md_$(date +%Y-%m-%d)/
```

### Paso 2.2: Eliminar duplicados
- Dejar la versión más completa
- Eliminar la otra instancia

### Paso 2.3: Resolver solapamientos
Consolidar según esta jerarquía:
- **Personalidad y tono** → SOUL.md
- **Reglas operativas** → AGENTS.md
- **Info del usuario** → USER.md
- **Identidad del agente** → IDENTITY.md
- **Memoria largo plazo** → MEMORY.md
- **Tools y rate limits** → TOOLS.md
- **Sub-agentes** → SUBAGENTES.md
- **Seguridad e instalación** → SECURITY_PROTOCOL.md

### Paso 2.4: Manejar referencias rotas
- NO borrar
- Marcar con ⚠️ PENDIENTE al final del archivo
- Lista de lo que necesita resolverse

### Paso 2.5: Comprimir sin perder significado
- Reescribir secciones largas en versión compacta
- Mantener la esencia y utilidad
- Eliminar redundancia obvia

## 📊 FASE 3 — REPORTE FINAL

```
✅ MD-OPTIMIZER COMPLETADO
──────────────────────
Tokens antes: [N]
Tokens después: [N]
Ahorro: [N] (-[%])

Archivos modificados: [lista]
Backup en: memory/backup_md_[FECHA]/
──────────────────────
```

## ⚠️ REGLAS IMPOSTERGABLES

1. **NUNCA modificar sin aprobación** — esperar "sí" explícito
2. **NUNCA borrar información** — moverla al archivo correcto
3. **NUNCA tocar archivos en memory/ ni proyectos/**
4. **SIEMPRE hacer backup** antes de cualquier cambio
5. **Todo en español** —输出的 mensajes y comentarios

## 🔧 Herramientas necesarias
- exec: para mkdir, cp, contar archivos
- read: para analizar contenido
- edit: para optimizar archivos
- write: para crear backup si es necesario