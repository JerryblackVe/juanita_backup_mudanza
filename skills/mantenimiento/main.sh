#!/bin/bash
# Script de mantenimiento para OpenClaw
# Limpia sesiones acumuladas y reinicia el gateway si es necesario

set -e

LOG_FILE="/tmp/mantenimiento_openclaw.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "🔍 Verificando sesiones de sub-agentes..."

# Contar sesiones activas (excluyendo la sesión actual del agente)
SESSIONS=$(sessions_list 2>/dev/null | grep -c "session" || echo "0")
SESSION_COUNT=${SESSIONS:-0}

log "Sesiones activas: $SESSION_COUNT"

# Umbral para limpiar
THRESHOLD=3

if [ "$SESSION_COUNT" -gt "$THRESHOLD" ]; then
    log "⚠️ Sesiones superiores al umbral ($THRESHOLD). Limpiando..."
    
    # Obtener lista de sesiones y matar las más antiguas
    SESSION_IDS=$(sessions_list 2>/dev/null | grep -oE 'session:[a-f0-9-]+' | tail -n +4 || true)
    
    for SESSION_ID in $SESSION_IDS; do
        log "🧹 Terminando sesión: $SESSION_ID"
        sessions kill --target "$SESSION_ID" 2>/dev/null || true
    done
    
    SESSION_CLEANED=true
    log "✅ Sesiones limpiadas"
else
    log "✅ Sesiones dentro del umbral. No se requiere limpieza."
    SESSION_CLEANED=false
fi

# Reiniciar gateway solo si se limpió
if [ "$SESSION_CLEANED" = true ]; then
    log "🔄 Reiniciando gateway..."
    openclaw gateway restart
    log "✅ Gateway reiniciado"
else
    log "ℹ️ No se reinicia el gateway (no hubo limpieza)"
fi

log "🏁 Mantenimiento completado"