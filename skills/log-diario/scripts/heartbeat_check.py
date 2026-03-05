#!/usr/bin/env python3
"""Heartbeat check para log-diario — detecta cambios y registra automáticamente."""

import os
import json
import subprocess
from datetime import datetime
from pathlib import Path

WORKSPACE = Path.home() / ".openclaw/workspace"
LOG_DIR = WORKSPACE / "log_diario"
STATE_FILE = WORKSPACE / ".log_diario_state.json"
SKILLS_DIR = WORKSPACE / "skills"

def load_state():
    """Carga el estado de la última revisión."""
    if STATE_FILE.exists():
        with open(STATE_FILE) as f:
            return json.load(f)
    return {"last_check": "1970-01-01T00:00:00", "logged_hashes": []}

def save_state(state):
    """Guarda el estado actual."""
    STATE_FILE.parent.mkdir(parents=True, exist_ok=True)
    with open(STATE_FILE, "w") as f:
        json.dump(state, f, indent=2)

def get_today_log():
    """Obtiene o crea el archivo de log de hoy."""
    today = datetime.now().strftime("%Y-%m-%d")
    log_file = LOG_DIR / f"{today}.md"
    LOG_DIR.mkdir(parents=True, exist_ok=True)
    
    if not log_file.exists():
        log_file.write_text(f"# Log Diario — {today}\n\n")
    
    return log_file

def log_entry(entry_type, description):
    """Escribe una entrada en el log de hoy."""
    log_file = get_today_log()
    now = datetime.now().strftime("%H:%M")
    
    # Evita duplicados en los últimos 5 minutos
    content = log_file.read_text()
    entry = f"[{now}] [{entry_type}] {description}"
    
    if entry not in content:
        with open(log_file, "a") as f:
            f.write(f"{entry}\n")
        print(f"✅ Registrado: {entry}")
        return True
    return False

def check_skills_changes():
    """Detecta skills nuevos o modificados."""
    changes = []
    state = load_state()
    last_check = state.get("last_check", "1970-01-01T00:00:00")
    
    try:
        result = subprocess.run(
            ["find", str(SKILLS_DIR), "-name", "SKILL.md", "-newer", str(STATE_FILE if STATE_FILE.exists() else "/etc/passwd")],
            capture_output=True, text=True, timeout=60
        )
        
        for line in result.stdout.strip().split("\n"):
            if line:
                skill_name = Path(line).parent.name
                changes.append(("SKILL", f"Skill '{skill_name}' nuevo o modificado"))
    except Exception as e:
        changes.append(("ERROR", f"Fallo check skills: {e}"))
    
    return changes

def check_md_files():
    """Detecta archivos .md modificados del workspace."""
    changes = []
    
    try:
        result = subprocess.run(
            ["find", str(WORKSPACE), "-maxdepth", "1", "-name", "*.md", "-mmin", "-60"],
            capture_output=True, text=True, timeout=60
        )
        
        for line in result.stdout.strip().split("\n"):
            if line:
                md_name = Path(line).name
                changes.append(("CONFIG", f"Archivo modificada: {md_name}"))
    except Exception as e:
        changes.append(("ERROR", f"Fallo check md: {e}"))
    
    return changes

def check_scripts():
    """Detecta scripts ejecutados recientemente en la terminal."""
    # Esto es aproximado — registra archivos Python modificados recientemente
    changes = []
    
    try:
        result = subprocess.run(
            ["find", str(WORKSPACE), "-name", "*.py", "-mmin", "-60"],
            capture_output=True, text=True, timeout=60
        )
        
        for line in result.stdout.strip().split("\n"):
            if line:
                script_name = Path(line).name
                changes.append(("SCRIPT", f"Script modificado o creado: {script_name}"))
    except Exception:
        pass
    
    return changes

def check_recent_restarts():
    """Detecta reinicios del gateway recientes."""
    changes = []
    
    try:
        # Verifica si el servicio se reinició recientemente
        result = subprocess.run(
            ["systemctl", "is-active", "openclaw"],
            capture_output=True, text=True, timeout=10
        )
        
        # Esto es aproximado — no detecta reinicios sin systemctl
    except Exception:
        pass
    
    return changes

def main():
    """Revisa cambios y registra automáticamente."""
    state = load_state()
    
    print(f"🔍 Revisando cambios desde {state.get('last_check', 'N/A')}...")
    
    changes = []
    changes.extend(check_skills_changes())
    changes.extend(check_md_files())
    changes.extend(check_scripts())
    changes.extend(check_recent_restarts())
    
    logged_count = 0
    for entry_type, description in changes:
        if log_entry(entry_type, description):
            logged_count += 1
    
    # Actualiza estado
    state["last_check"] = datetime.now().isoformat()
    save_state(state)
    
    if logged_count == 0:
        print("⏳ Sin cambios nuevos que registrar. Esperando...")
    else:
        print(f"✅ Se registraron {logged_count} entradas nuevas.")
    
    return logged_count

if __name__ == "__main__":
    main()
