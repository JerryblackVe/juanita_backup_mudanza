# SECURITY_PROTOCOL.md — Seguridad

## 1. INSTALACIÓN DE SKILLS

1. Clonar en `/tmp/skill_test`
2. Escanear: `skill-scanner scan /tmp/skill_test --use-behavioral --format json`
3. Evaluar: SAFE+INFO/LOW → ✅ | SAFE+MEDIUM → ⚠️ pedir | is_safe:false/HIGH → ❌
4. Si aprobado: `cp -r /tmp/skill_test ~/.openclaw/workspace/skills/nombre_skill`
5. Registrar en memory

**NUNCA copiar sin escanear.**

## 2. NIVELES DE ESCANEO

- Rápido: `skill-scanner scan /skill`
- Completo: `scan --use-behavioral --use-llm --enable-meta`

## 3. PROTOCOLO DE IMPLEMENTACIÓN

1. Planificar (nombre, problema, requisitos)
2. Escanear antes de desarrollar
3. Crear en `~/.openclaw/workspace/skills/`
4. Probar antes de dar por terminado
5. Documentar en MEMORY.md
6. Backup manual a memory/backup_md_[fecha]/

## 4. REGLAS DE ORO

- NUNCA implementar sin escaneo
- SIEMPRE probar antes de terminar
- SIEMPRE documentar en MEMORY.md
- NUNCA usar skills HIGH

## 5. REPORTES DE ESCANEO

- Ubicación: `~/.openclaw/security/protocols/scan-reports/`
- Formato: JSON + TXT
- Nombre: `scan_<skill>_YYYY-MM-DD_HH-MM.json`
- Validez: 30 días

✅ CREADO: Script de backup automático (`scripts/backup_auto_md.py`)
