#!/bin/bash
#
# BACKUP-DAEMON.SH - Agente Backup Persistent para JUANITA
# Maneja backups automáticos cada hora y sync a GitHub
#
# Uso: ./scripts/backup-daemon.sh {start|stop|status|restart|cron}
#

set -e

# Configuración
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$HOME/.openclaw/workspace"
PID_FILE="$WORKSPACE/data/backup.pid"
LOG_FILE="$WORKSPACE/log_diario/backup-daemon.log"
PYTHON="$HOME/.openclaw/venv/bin/python"
BACKUP_SCRIPT="$SCRIPT_DIR/backup_auto_md.py"
COMMIT_SCRIPT="$SCRIPT_DIR/auto_commit_github.sh"

# Crear directorios necesarios
mkdir -p "$WORKSPACE/log_diario"
mkdir -p "$WORKSPACE/data"

# Logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Verificar que el script de backup existe
verificar_scripts() {
    if [ ! -f "$BACKUP_SCRIPT" ]; then
        log "❌ ERROR: No existe $BACKUP_SCRIPT"
        exit 1
    fi
    if [ ! -f "$COMMIT_SCRIPT" ]; then
        log "❌ ERROR: No existe $COMMIT_SCRIPT"
        exit 1
    fi
}

# Ejecutar el backup completo
ejecutar_backup() {
    log "========================================"
    log "🔄 INICIANDO CICLO DE BACKUP"
    log "========================================"
    
    verificar_scripts
    
    # 1. Ejecutar backup de MD
    log "📄 Ejecutando backup_auto_md.py..."
    if $PYTHON "$BACKUP_SCRIPT" >> "$LOG_FILE" 2>&1; then
        log "✅ Backup MD completado exitosamente"
    else
        log "⚠️ Backup MD finalizó con advertencias (código $?)"
    fi
    
    # 2. Verificar si hay cambios para GitHub
    log "🔄 Verificando cambios para GitHub..."
    if [ -f "$COMMIT_SCRIPT" ]; then
        bash "$COMMIT_SCRIPT" >> "$LOG_FILE" 2>&1
        EXIT_CODE=$?
        if [ $EXIT_CODE -eq 0 ]; then
            log "✅ Sync GitHub completado"
        else
            log "ℹ️ GitHub sync terminó (código $EXIT_CODE)"
        fi
    fi
    
    log "========================================"
    log "✅ CICLO DE BACKUP COMPLETADO"
    log "========================================"
    log ""
}

# Verificar si el daemon está corriendo
is_running() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE" 2>/dev/null)
        if [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; then
            return 0
        fi
    fi
    return 1
}

# Start - demonizar el proceso
start_daemon() {
    if is_running; then
        log "✅ El demonio ya está corriendo (PID: $(cat "$PID_FILE"))"
        exit 0
    fi
    
    log "🚀 Iniciando backup-daemon..."
    
    # Ejecutar en modo "loop" en background
    (
        echo $$ > "$PID_FILE"
        log "📝 PID guardado: $$"
        
        while true; do
            ejecutar_backup
            # Dormir 1 hora
            log "😴 Durmiendo 1 hora..."
            sleep 3600
        done
    ) &
    
    # Pequeña espera para que el proceso se inicie
    sleep 1
    
    if is_running; then
        log "✅ Daemon iniciado correctamente (PID: $(cat "$PID_FILE"))"
    else
        log "❌ Error iniciando daemon"
        exit 1
    fi
}

# Stop - detener el proceso
stop_daemon() {
    if [ ! -f "$PID_FILE" ]; then
        log "ℹ️ No hay PID file, el demonio no está corriendo"
        exit 0
    fi
    
    PID=$(cat "$PID_FILE" 2>/dev/null)
    if [ -z "$PID" ]; then
        rm -f "$PID_FILE"
        log "ℹ️ PID file vacío eliminado"
        exit 0
    fi
    
    if kill -0 "$PID" 2>/dev/null; then
        log "🛑 Deteniendo daemon (PID: $PID)..."
        kill "$PID" 2>/dev/null || true
        sleep 1
        
        # Verificar si terminó
        if kill -0 "$PID" 2>/dev/null; then
            log "⚠️ Forzando terminación..."
            kill -9 "$PID" 2>/dev/null || true
        fi
        
        rm -f "$PID_FILE"
        log "✅ Daemon detenido"
    else
        rm -f "$PID_FILE"
        log "ℹ️ El proceso ya no existe, PID file eliminado"
    fi
}

# Restart - reiniciar
restart_daemon() {
    log "🔄 Reiniciando daemon..."
    stop_daemon
    sleep 1
    start_daemon
}

# Status - mostrar estado
status_daemon() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE" 2>/dev/null)
        if [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; then
            echo "✅ AGENTE BACKUP está ACTIVO (PID: $PID)"
            echo "   PID file: $PID_FILE"
            echo "   Log file: $LOG_FILE"
            echo ""
            echo "📊 Últimas 10 líneas del log:"
            tail -n 10 "$LOG_FILE" 2>/dev/null || echo "   (log vacío)"
            return 0
        else
            echo "⚠️ AGENTE BACKUP marcado como corriendo pero proceso no existe"
            echo "   PID file: $PID_FILE (PID: $PID)"
            rm -f "$PID_FILE"
            return 1
        fi
    else
        echo "ℹ️ AGENTE BACKUP está INACTIVO"
        echo "   No hay PID file: $PID_FILE"
        return 1
    fi
}

# Cron - ejecutar una vez (para crontab)
cron_run() {
    log "⏰ Ejecutando desde cron..."
    ejecutar_backup
}

# ============================================
# MAIN
# ============================================

case "${1:-}" in
    start)
        start_daemon
        ;;
    stop)
        stop_daemon
        ;;
    restart)
        restart_daemon
        ;;
    status)
        status_daemon
        ;;
    cron)
        cron_run
        ;;
    *)
        echo "Uso: $0 {start|stop|status|restart|cron}"
        echo ""
        echo "Comandos:"
        echo "  start    - Iniciar el daemon en background"
        echo "  stop     - Detener el daemon"
        echo "  restart  - Reiniciar el daemon"
        echo "  status   - Ver estado del daemon"
        echo "  cron     - Ejecutar backup una vez (para crontab)"
        echo ""
        echo "Ejemplo en crontab:"
        echo "  0 * * * * $0 cron"
        exit 1
        ;;
esac

exit 0
