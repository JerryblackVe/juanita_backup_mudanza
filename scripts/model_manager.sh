#!/bin/bash

# Model Manager para OpenClaw
# Script para gestionar modelos AI desde config/openclaw.json

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_PATH="${SCRIPT_DIR}/../config/openclaw.json"
TEMP_DIR="${SCRIPT_DIR}/../temp"

colorize() {
    local color=$1
    local text=$2
    case $color in
        green) echo -e "\033[32m${text}\033[0m" ;;
        red) echo -e "\033[31m${text}\033[0m" ;;
        yellow) echo -e "\033[33m${text}\033[0m" ;;
        blue) echo -e "\033[34m${text}\033[0m" ;;
        *) echo "$text" ;;
    esac
}

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "${SCRIPT_DIR}/../log_diario/model_manager.log"
}

error() {
    log "ERROR: $1" >&2
    colorize red "✗ $1"
    exit 1
}

show_help() {
    cat << EOF
$(colorize green "OpenClaw Model Manager")
Uso: $0 [comando] [opciones]

Comandos:
  list - Listar todos los modelos disponibles
  status - Ver estado actual de modelos y tokens
  activate <modelo> - Activar un modelo
  deactivate <modelo> - Desactivar un modelo
  swap - Intercambiar modelo primario con fallback
  health - Verificar health de todas las APIs
  test <modelo> - Test de latencia para un modelo específico
  tokens - Mostrar uso de tokens por modelo
  set-primary <modelo> - Establecer modelo como primario
  set-fallback <modelo> - Establecer modelo como fallback

Ejemplos:
  $0 list
  $0 activate m1
  $0 test m2
  $0 swap
  $0 health
  $0 tokens
EOF
}

json_query() {
    local query=$1
    local file=$2
    if command -v jq >/dev/null 2>&1; then
        jq -r "$query" "$file"
    else
        python3 -c "import json; print(json.load(open('$file'))$query)"
    fi
}

json_update() {
    local key=$1
    local value=$2
    local file=$3
    if command -v jq >/dev/null 2>&1; then
        jq "$key = $value" "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
    else
        python3 -c "
import json
with open('$file') as f:
    data = json.load(f)
data$key = $value
with open('$file', 'w') as f:
    json.dump(data, f, indent=2)
"
    fi
}

validate_config() {
    if [[ ! -f "$CONFIG_PATH" ]]; then
        error "Archivo de configuración no encontrado: $CONFIG_PATH"
    fi
}

list_models() {
    validate_config
    echo
    colorize blue "=== Modelos Disponibles ==="
    
    local models=$(json_query '.models.models[] | .name + "|" + (.active | tostring) + "|" + .type' "$CONFIG_PATH")
    
    while IFS='|' read -r name active type; do
        status=$( [[ "$active" == "true" ]] && echo "$(colorize green 'ACTIVO')" || echo "$(colorize red 'INACTIVO')" )
        role=$( [[ "$type" == "primary" ]] && echo "$(colorize blue 'PRIMARIO')" || echo "$(colorize yellow 'FALLBACK')" )
        
        echo "• $name: $status | $role"
    done <<< "$models"
}

show_status() {
    validate_config
    echo
    colorize blue "=== Estado de Modelos ==="
    
    local primary=$(json_query '.models.primary.name' "$CONFIG_PATH")
    local fallback=$(json_query '.models.fallback.name' "$CONFIG_PATH")
    
    colorize green "Modelo primario: $primary"
    colorize yellow "Modelo fallback: $fallback"
    echo
    
    colorize blue "=== Uso de Tokens ==="
    
    for model in m1 m2; do
        local used=$(json_query ".tokens.$model.used" "$CONFIG_PATH")
        local limit=$(json_query ".tokens.$model.limit" "$CONFIG_PATH")
        local reset=$(json_query ".tokens.$model.reset" "$CONFIG_PATH")
        
        if [[ "$used" != "null" ]] && [[ "$limit" != "null" ]]; then
            local usage=$(( used * 100 / limit ))
            echo "• $model: $(colorize green "${used}") / $(colorize blue "${limit}") tokens (${usage}%)"
            echo "  Reset: $reset"
            echo
        fi
    done
}

toggle_model() {
    local model=$1
    local action=$2
    
    validate_config
    
    local model_exists=false
    local models_count=$(json_query '.models.models | length' "$CONFIG_PATH")
    
    for ((i=0; i<models_count; i++)); do
        local current_name=$(json_query ".models.models[$i].name" "$CONFIG_PATH")
        if [[ "$current_name" == "$model" ]]; then
            model_exists=true
            local new_value
            if [[ "$action" == "activate" ]]; then
                new_value="true"
                update_model_status "$i" "$new_value"
                colorize green "Modelo '$model' activado exitosamente"
            elif [[ "$action" == "deactivate" ]]; then
                new_value="false"
                update_model_status "$i" "$new_value"
                colorize yellow "Modelo '$model' desactivado exitosamente"
            fi
            break
        fi
    done
    
    if [[ "$model_exists" == "false" ]]; then
        error "Modelo '$model' no encontrado"
    fi
}

update_model_status() {
    local index=$1
    local status=$2
    
    json_update ".models.models[$index].active" "$status" "$CONFIG_PATH"
}

swap_models() {
    validate_config
    
    local current_primary=$(json_query '.models.primary' "$CONFIG_PATH")
    local current_fallback=$(json_query '.models.fallback' "$CONFIG_PATH")
    
    json_update '.models.primary' "$current_fallback" "$CONFIG_PATH"
    json_update '.models.fallback' "$current_primary" "$CONFIG_PATH"
    
    colorize green "✓ Modelos intercambiados exitosamente:"
    colorize blue "  Primario ahora: $(json_query '.models.primary.name' "$CONFIG_PATH")"
    colorize yellow "  Fallback ahora: $(json_query '.models.fallback.name' "$CONFIG_PATH")"
}

health_check() {
    validate_config
    echo
    colorize blue "=== Health Check de APIs ==="
    
    local models_count=$(json_query '.models.models | length' "$CONFIG_PATH")
    
    for ((i=0; i<models_count; i++)); do
        local name=$(json_query ".models.models[$i].name" "$CONFIG_PATH")
        local active=$(json_query ".models.models[$i].active" "$CONFIG_PATH")
        local endpoint=""
        
        if [[ "$name" == "$(json_query '.models.primary.name' "$CONFIG_PATH")" ]]; then
            endpoint=$(json_query '.models.primary.endpoint' "$CONFIG_PATH")
        elif [[ "$name" == "$(json_query '.models.fallback.name' "$CONFIG_PATH")" ]]; then
            endpoint=$(json_query '.models.fallback.endpoint' "$CONFIG_PATH")
        fi
        
        local status_color="red"
        local status_text="INACTIVO"
        
        if [[ "$active" == "true" ]]; then
            if curl --connect-timeout 5 --max-time 10 -s "$endpoint" > /dev/null; then
                status_color="green"
                status_text="HEALTHY"
            else
                status_color="red"
                status_text="UNHEALTHY"
            fi
        fi
        
        echo "• $name: $(colorize $status_color $status_text) | $endpoint"
    done
}

latency_test() {
    local model=$1
    validate_config
    
    local model_info=""
    if [[ "$model" == "$(json_query '.models.primary.name' "$CONFIG_PATH")" ]]; then
        model_info=".models.primary"
    elif [[ "$model" == "$(json_query '.models.fallback.name' "$CONFIG_PATH")" ]]; then
        model_info=".models.fallback"
    else
        error "Modelo '$model' no encontrado en la configuración"
    fi
    
    local endpoint=$(json_query "$model_info.endpoint" "$CONFIG_PATH")
    local api_key=$(json_query "$model_info.api_key" "$CONFIG_PATH")
    local model_name=$(json_query "$model_info.model" "$CONFIG_PATH")
    
    echo
    colorize blue "=== Test de Latencia para $model ==="
    echo "Endpoint: $endpoint"
    echo "Modelo: $model_name"
    
    local start_time=$(date +%s%3N)
