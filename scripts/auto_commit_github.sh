#!/bin/bash
#
# AUTO_COMMIT_GITHUB.SH - Commit automático solo si hay cambios
# Uso: ./scripts/auto_commit_github.sh [mensaje]
# Ejecutar cada hora via cron o heartbeat
#

set -e

WORKSPACE="$HOME/.openclaw/workspace"
REPO_URL="https://github.com/JerryblackVe/JUANITA_FINAL.git"
TEMP_DIR="/tmp/juanita_github_sync"
MESSAGE="${1:-Auto-sync $(date +'%Y-%m-%d %H:%M')}"

echo "🔄 GitHub Auto-Commit - $(date)"
echo "================================"

# Verificar si hay cambios en archivos trackeados
cd "$WORKSPACE"

# Crear lista de archivos modificados desde último backup
MODIFIED_FILES=$(find docs memory skills scripts data -type f -newer "$WORKSPACE/data/.last_sync" 2>/dev/null | head -50)

if [ -z "$MODIFIED_FILES" ] && [ -f "$WORKSPACE/data/.last_sync" ]; then
    echo "✅ No hay cambios desde último sync"
    exit 0
fi

echo "📁 Archivos modificados detectados:"
echo "$MODIFIED_FILES" | head -10
echo ""

# Limpiar y preparar temp
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"

# Clonar repo
if ! git clone --depth 1 "$REPO_URL" "$TEMP_DIR/repo" 2>/dev/null; then
    echo "❌ Error clonando repo. Verificar token."
    exit 1
fi

cd "$TEMP_DIR/repo"

# Copiar archivos modificados
echo "📤 Copiando archivos..."
for file in $MODIFIED_FILES; do
    if [ -f "$WORKSPACE/$file" ]; then
        target_dir=$(dirname "$file")
        mkdir -p "$target_dir"
        cp "$WORKSPACE/$file" "$file"
        git add "$file"
        echo "  ✅ $file"
    fi
done

# Verificar si hay algo para commit
git status --porcelain > /dev/null 2>&1 || true

if git diff --cached --quiet; then
    echo "✅ No hay cambios para commit"
    rm -rf "$TEMP_DIR"
    exit 0
fi

# Commit y push
echo ""
echo "📝 Haciendo commit: $MESSAGE"
git commit -m "$MESSAGE"

if git push origin main; then
    echo "✅ Push exitoso a GitHub"
    # Registrar timestamp
    touch "$WORKSPACE/data/.last_sync"
    echo "{\"last_sync\":\"$(date -Iseconds)\",\"message\":\"$MESSAGE\",\"files\":$(echo \"$MODIFIED_FILES\" | wc -l)}" > "$WORKSPACE/data/last_github_sync.json"
else
    echo "❌ Error en push"
    exit 1
fi

# Limpiar
rm -rf "$TEMP_DIR"

echo ""
echo "✅ Sync completado: $(date)"
