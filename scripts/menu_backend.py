#!/usr/bin/env python3
"""
Backend simple para manejar callbacks de Telegram
Corre en segundo plano y responde a los botones
"""

from flask import Flask, request, jsonify
import os
import json
import subprocess

app = Flask(__name__)

WORKSPACE = os.path.expanduser("~/.openclaw/workspace")
OPENCLAW_JSON = os.path.expanduser("~/.openclaw/openclaw.json")

def get_token():
    try:
        with open(OPENCLAW_JSON) as f:
            config = json.load(f)
        gateway = config.get("gateway", {})
        auth = gateway.get("auth", {})
        return auth.get("token", "")
    except:
        return ""

def get_skills():
    try:
        skills = [d for d in os.listdir(f"{WORKSPACE}/skills") 
                  if os.path.isdir(f"{WORKSPACE}/skills/{d}") and not d.startswith('.')]
        return ", ".join(sorted(skills)[:15])
    except:
        return "Error"

def get_models():
    try:
        with open(OPENCLAW_JSON) as f:
            config = json.load(f)
        models = []
        for prov, data in config.get("models", {}).get("providers", {}).items():
            for m in data.get("models", []):
                models.append(f"{prov}/{m['id']}")
        return "\n".join(models[:10])
    except:
        return "Error"

def get_system():
    try:
        load = subprocess.check_output("cat /proc/loadavg | awk '{print $1}'", shell=True).decode().strip()
        mem = subprocess.check_output("free -h | grep Mem | awk '{print $3}'", shell=True).decode().strip()
        disk = subprocess.check_output("df -h / | tail -1 | awk '{print $3}'", shell=True).decode().strip()
        return f"CPU: {load} | RAM: {mem} | Disco: {disk}"
    except:
        return "Error"

# Webhook para Telegram
@app.route(f"/webhook/{get_token()}", methods=["POST"])
def webhook():
    data = request.json
    if "callback_query" in data:
        callback = data["callback_query"]
        query_id = callback["id"]
        user = callback["from"]["first_name"]
        cb_data = callback["data"]
        
        # Procesar callback
        if cb_data == "menu_skills":
            text = f"📋 *SKILLS*\n\n{get_skills()}"
        elif cb_data == "menu_models":
            text = f"🧠 *MODELOS*\n\n{get_models()}"
        elif cb_data == "menu_system":
            text = f"🔧 *SISTEMA*\n\n{get_system()}"
        elif cb_data == "menu_latency":
            text = "⚡ *LATENCIA*\n\nTesteando..."
        elif cb_data == "menu_tokens":
            text = "📊 *TOKENS*\n\nHoy: ~150K tokens"
        elif cb_data == "menu_help":
            text = "ℹ️ *AYUDA*\n\n• /menu - Abrir menú\n• Click botones para navegar"
        elif cb_data == "menu_close":
            text = "❌ *Menú cerrado*\n\nEscríbe /menu para volver"
        elif cb_data == "menu_main":
            text = "🤖 *JUANITA - Menú Principal*\n\nSelecciona una opción:"
        else:
            text = f"Recibido: {cb_data}"
        
        # Responder al callback
        return jsonify({
            "method": "answerCallbackQuery",
            "callback_query_id": query_id,
            "text": text,
            "show_alert": True
        })
    
    return jsonify({"ok": True})

@app.route("/health")
def health():
    return jsonify({"status": "ok"})

if __name__ == "__main__":
    print(f"🚀 Backend started on port 5000")
    print(f"   Token: {get_token()[:15]}...")
    app.run(host="0.0.0.0", port=5000, debug=False)