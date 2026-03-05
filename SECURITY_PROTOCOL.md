# SECURITY_PROTOCOL.md — Seguridad

## 0. HERRAMIENTA DE ESCANEO

- **Scanner:** **Cisco AI Defense** (`skill-scanner`)
- **Paquete:** `cisco-ai-skill-scanner` (PyPI)
- **Ubicación:** `~/.openclaw/venv/bin/skill-scanner`
- **Comando:** `skill-scanner scan <path> --use-behavioral --format json`

---

## 1. INSTALACIÓN DE SKILLS

**REGLA RC: TODO skill nuevo o del backup debe escanearse.**

1. Clonar en `/tmp/skill_test`
2. Escanear: `skill-scanner scan /tmp/skill_test --use-behavioral --format json`
3. Evaluar resultados:
   - ✅ **SAFE + INFO/LOW** → Aprobar
   - ⚠️ **SAFE + MEDIUM** → Pedir aprobación usuario
   - ❌ **is_safe:false** o **HIGH** → RECHAZAR → NO usar
4. Si aprobado: `cp -r /tmp/skill_test ~/.openclaw/workspace/skills/nombre_skill`
5. Registrar en memory

**NUNCA copiar sin escanear. NUNCA aprobar HIGH.**

---

## 2. SKILLS DEL BACKUP

**REGLA RC: Skills que vienen de skills_backup/ deben escanearse SIEMPRE.**

- Skills en backup no fueron escaneados por JUANITA
- Antes de mover a `/skills/`, siempre escanear
- Mismos criterios: INFO/LOW ✅ | MEDIUM ⚠️ | HIGH ❌

---

## 3. NIVELES DE ESCANEO

- Rápido: `skill-scanner scan /skill`
- Completo: `skill-scanner scan /skill --use-behavioral --use-llm --enable-meta`

**Recomendado:** Usar completo para skills de terceros (community).

---

## 4. PROTOCOLO DE IMPLEMENTACIÓN

1. Planificar (nombre, problema, requisitos)
2. Escanear antes de desarrollar
3. Crear en `~/.openclaw/workspace/skills/`
4. Probar antes de dar por terminado
5. Documentar en MEMORY.md
6. Backup manual a memory/backup_md_[fecha]/

---

## 5. REGLAS DE ORO

- **NUNCA** implementar sin escaneo
- **NUNCA** aprobar riesgos HIGH
- **SIEMPRE** probar antes de terminar
- **SIEMPRE** documentar en MEMORY.md
- Skills backup = siempre escanear

---

## 6. TABLA DE RIESGOS

| Severidad | Acción |
|-----------|--------|
| INFO | ✅ Aprobar |
| LOW | ✅ Aprobar |
| MEDIUM | ⚠️ Pedir aprobación |
| HIGH | ❌ RECHAZAR |
| is_safe:false | ❌ RECHAZAR |

---

## 7. REPORTES DE ESCANEO

- Ubicación: `~/.openclaw/security/protocols/scan-reports/`
- Formato: JSON
- Nombre: `scan_<skill>_YYYY-MM-DD_HH-MM.json`
- Validez: 30 días

✅ Script de backup automático (`scripts/backup_auto_md.py`)