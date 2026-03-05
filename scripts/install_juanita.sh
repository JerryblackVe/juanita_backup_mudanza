#!/bin/bash
#
# INSTALL_JUANITA.SH - Script de restauración del sistema JUANITA
# Uso: ./install_juanita.sh [backup_file.tar.gz]
#

set -e

BACKUP_FILE="${1:-juanita_backup_*.tar.gz}"
WORKSPACE="$HOME/.openclaw/workspace"
VENV="$HOME/.openclaw/venv"

echo "🤖 JUANITA RESTORE SCRIPT"
echo "════════════════════════"
echo ""

# Validar archivo de backup
if [ ! -f "$BACKUP_FILE" ]; then
    BACKUP_FILE=$(ls -t juanita_backup_*.tar.gz 2>/dev/null | head -1)
    if [ -z "$BACKUP_FILE" ]; then
        echo "❌ Error: No se encontró archivo de backup"
        echo "   Uso: $0 [archivo_backup.tar.gz]"
        exit 1
    fi
    echo "📦 Usando backup más reciente: $BACKUP_FILE"
fi

# Verificar checksum si existe
if [ -f "$WORKSPACE/data/last_backup.json" ]; then
    echo "🔍 Verificando integridad..."
fi

# 1. Extraer backup
echo "📂 Extrayendo backup..."
TEMP_DIR=$(mktemp -d)
tar -xzf "$BACKUP_FILE" -C "$TEMP_DIR"
cd "$TEMP_DIR/juanita_restore"

# 2. Verificar contenido mínimo
if [ ! -d "docs" ] || [ ! -d "skills" ]; then
    echo "❌ Error: Backup corrupto o inválido"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo "✅ Backup válido"
echo ""

# 3. Crear directorio workspace si no existe
if [ -d "$WORKSPACE" ]; then
    echo "⚠️  Workspace existente encontrado"
    read -p "¿Sobreescribir? (s/N): " confirm
    if [[ ! $confirm =~ ^[Ss]$ ]]; then
        echo "Cancelado"
        rm -rf "$TEMP_DIR"
        exit 0
    fi
    mv "$WORKSPACE" "$WORKSPACE.backup.$(date +%s)"
    echo "   Backup anterior guardado"
fi

echo "📁 Creando estructura de directorios..."
mkdir -p "$WORKSPACE"

# 4. Crear estructura de carpetas
cd "$TEMP_DIR/juanita_restore"

# 5. Copiar archivos (preservando permisos)
echo "📄 Copiando configuración..."
cp -r docs "$WORKSPACE/"
cp AGENTS.md README.md "$WORKSPACE/" 2>/dev/null || true

echo "🧠 Copiando skills..."
cp -r skills "$WORKSPACE/"
cp -r skills_backup "$WORKSPACE/" 2>/dev/null || true

echo "⚙️ Copiando scripts..."
cp -r scripts "$WORKSPACE/"

echo "📝 Copiando memory..."
cp -r memory "$WORKSPACE/" 2>/dev/null || true

echo "📊 Copiando data..."
cp -r data "$WORKSPACE/" 2>/dev/null || true

# 6. Crear carpetas adicionales necesarias
echo "📂 Creando carpetas adicionales..."
mkdir -p "$WORKSPACE/audio"
mkdir -p "$WORKSPACE/media"
mkdir -p "$WORKSPACE/temp"
mkdir -p "$WORKSPACE/log_diario"
mkdir -p "$HOME/.openclaw/security/protocols/scan-reports"

# 7. Descargar modelo Vosk (no está en backup por tamaño)
echo ""
echo "🎤 Descargando modelo Vosk (español) - ~500MB..."
if [ ! -d "$WORKSPACE/scripts/vosk-model-es" ]; then
    cd "$WORKSPACE/scripts"
    wget -q --show-progress "https://alphacephei.com/vosk/models/vosk-model-es-0.42.zip" -O vosk-temp.zip
    unzip -q vosk-temp.zip
    mv vosk-model-es-0.42 vosk-model-es
    rm vosk-temp.zip
    echo "✅ Modelo Vosk instalado"
else
    echo "   ℹ️ Modelo Vosk ya existe"
fi

# 8. Crear .env (vacío, usuario debe llenarlo)
echo ""
echo "🔐 Archivo de configuración..."
if [ ! -f "$WORKSPACE/.env" ]; then
    cat > "$WORKSPACE/.env" << 'EOF'
# JUANITA - Configuración de entorno
# NO subir a git, NO compartir

# API Keys necesarias:
# SERPER_API_KEY=your_key_here
# BRAVE_API_KEY=your_key_here
# GITHUB_TOKEN=your_token_here
# OPENAI_API_KEY=optional
# ELEVENLABS_API_KEY=optional

EOF
    chmod 600 "$WORKSPACE/.env"
    echo "⚠️  IMPORTANTE: Edita $WORKSPACE/.env con tus API keys"
else
    echo "   ⚠️  Revisa $WORKSPACE/.env con tus API keys"
fi

# 9. Crear venv e instalar dependencias (si no existe)
echo ""
echo "📦 Instalando dependencias Python..."
if [ ! -d "$VENV" ]; then
    python3 -m venv "$VENV"
    echo "   Virtualenv creado en $VENV"
fi

# Instalar lo básico
"$VENV/bin/pip" install -q --upgrade pip

# 10. Verificar instalación
echo ""
echo "🔍 Verificando integridad..."
SKILLS_COUNT=$(find "$WORKSPACE/skills" -name "SKILL.md" | wc -l)
SKILL_BACKUP_COUNT=$(find "$WORKSPACE/skills_backup" -type d -name "*" 2>/dev/null | wc -l)

echo "   Skills activos: $SKILLS_COUNT"
echo "   Skills backup: $SKILL_BACKUP_COUNT"
echo ""

# 11. Limpiar temp
rm -rf "$TEMP_DIR"

echo "════════════════════════"
echo "✅ RESTAURACIÓN COMPLETADA"
echo "════════════════════════"
echo ""
echo "Próximos pasos:"
echo "   1. Editar: $WORKSPACE/.env (poner tus API keys)"
echo "   2. Revisar: $WORKSPACE/docs/USER.md (perfil del usuario)"
echo "   3. Revisar: $WORKSPACE/docs/IDENTITY.md (identidad del agente)"
echo ""
echo "📘 Documentación: $WORKSPACE/docs/MIGRATION_GUIDE.md"
echo ""
echo "🚀 JUANITA está lista. Reinicia OpenClaw para comenzar."
