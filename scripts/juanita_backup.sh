#!/bin/bash
#
# JUANITA_BACKUP.SH - Backup completo del sistema JUANITA
# Uso: ./scripts/juanita_backup.sh [destino]
#

set -e

WORKSPACE="$HOME/.openclaw/workspace"
DESTINO="${1:-$WORKSPACE/../juanita_backup_$(date +%Y%m%d_%H%M).tar.gz}"
TEMP_DIR=$(mktemp -d)

echo "📦 JUANITA BACKUP - $(date)"
echo "Origen: $WORKSPACE"
echo "Destino: $DESTINO"
echo ""

# Crear estructura temporal
mkdir -p "$TEMP_DIR/juanita_restore"

# 1. Copiar archivos de configuración (docs/, AGENTS.md, README.md)
echo "📄 Copiando configuración..."
cp -r "$WORKSPACE/docs" "$TEMP_DIR/juanita_restore/"
cp "$WORKSPACE/AGENTS.md" "$TEMP_DIR/juanita_restore/" 2>/dev/null || true
cp "$WORKSPACE/README.md" "$TEMP_DIR/juanita_restore/" 2>/dev/null || true

# 2. Copiar skills activos y backup
echo "🧠 Copiando skills..."
cp -r "$WORKSPACE/skills" "$TEMP_DIR/juanita_restore/"
echo "   └─ skills/ activos"

if [ -d "$WORKSPACE/skills_backup" ]; then
    cp -r "$WORKSPACE/skills_backup" "$TEMP_DIR/juanita_restore/"
    echo "   └─ skills_backup/ ($(find "$WORKSPACE/skills_backup" -type d | wc -l) skills)"
fi

# 3. Copiar scripts (SIN vosk-model-es/ que es 2.3GB y re-descargable)
echo "⚙️ Copiando scripts..."
mkdir -p "$TEMP_DIR/juanita_restore/scripts"
for file in "$WORKSPACE/scripts"/*; do
    if [ -f "$file" ] || ([ -d "$file" ] && [[ "$(basename "$file")" != "vosk-model-es" ]]); then
        cp -r "$file" "$TEMP_DIR/juanita_restore/scripts/" 2>/dev/null || true
    fi
done
echo "   └─ scripts/ (excluyendo vosk-model-es/ de 2.3GB)"

# 4. Copiar memory/ logs
echo "📝 Copiando memory..."
cp -r "$WORKSPACE/memory" "$TEMP_DIR/juanita_restore/"

# 5. Copiar data/ si existe
if [ -d "$WORKSPACE/data" ]; then
    cp -r "$WORKSPACE/data" "$TEMP_DIR/juanita_restore/"
    echo "📊 Copiando data/"
fi

# 6. Crear archivo de metadatos
cat > "$TEMP_DIR/juanita_restore/RESTORE_INFO.json" << 'EOF'
{
  "name": "JUANITA",
  "version": "1.0",
  "description": "Asistente personal IA",
  "created_at": "EOF
date -Iseconds >> "$TEMP_DIR/juanita_restore/RESTORE_INFO.json"
cat >> "$TEMP_DIR/juanita_restore/RESTORE_INFO.json" << 'EOF'
",
  "items": [
    "docs/ - Configuración completa",
    "skills/ - 14 skills activos",
    "skills_backup/ - Skills de respaldo",
    "scripts/ - Scripts de soporte (sin modelo Vosk)",
    "memory/ - Logs diarios",
    "data/ - Datos estructurados"
  ],
  "install_script": "./install_juanita.sh",
  "restore_notes": "Ver docs/MIGRATION_GUIDE.md"
}
EOF

# 7. Crear tarball
echo ""
echo "🗜️ Comprimiendo..."
tar -czf "$DESTINO" -C "$TEMP_DIR" juanita_restore/

# 8. Calcular hash
HASH=$(sha256sum "$DESTINO" | cut -d' ' -f1)
SIZE=$(du -h "$DESTINO" | cut -f1)

# 9. Guardar registro
echo "{\"backup_date\":\"$(date -Iseconds)\",\"file\":\"$DESTINO\",\"size\":\"$SIZE\",\"sha256\":\"$HASH\",\"contents\":$(find "$TEMP_DIR/juanita_restore" -type f | wc -l)}" > "$WORKSPACE/data/last_backup.json"

# Limpiar temp
rm -rf "$TEMP_DIR"

echo ""
echo "✅ BACKUP COMPLETADO"
echo "─────────────────────"
echo "Archivo: $DESTINO"
echo "Tamaño:  $SIZE"
echo "SHA256:  $HASH"
echo ""
echo "📋 Para restaurar en otro sistema:"
echo "   1. Copiar $DESTINO al nuevo server"
echo "   2. Ejecutar: ./install_juanita.sh"
echo ""
echo "⚠️  IMPORTANTE: Ver docs/MIGRATION_GUIDE.md antes de migrar"
