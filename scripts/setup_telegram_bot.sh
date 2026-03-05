#!/bin/bash
# Setup script for Telegram Menu Bot

echo "🤖 Configurando JUANITA Telegram Bot"
echo "======================================"
echo ""

# Check for TELEGRAM_BOT_TOKEN
if [ -z "$TELEGRAM_BOT_TOKEN" ]; then
    # Try to load from .env
    if [ -f "$HOME/.openclaw/workspace/.env" ]; then
        export $(cat $HOME/.openclaw/workspace/.env | grep -v '^#' | xargs) 2>/dev/null
    fi
fi

if [ -z "$TELEGRAM_BOT_TOKEN" ]; then
    echo "❌ Error: TELEGRAM_BOT_TOKEN no encontrado"
    echo ""
    echo "Opciones:"
    echo "1. Exportar variable: export TELEGRAM_BOT_TOKEN='your_token'"
    echo "2. Agregar a ~/.openclaw/workspace/.env"
    echo ""
    exit 1
fi

echo "✅ Token encontrado"
echo ""

# Check python-telegram-bot
if python3 -c "import telegram" 2>/dev/null; then
    echo "✅ python-telegram-bot instalado"
else
    echo "📦 Instalando python-telegram-bot..."
    pip install python-telegram-bot --quiet
fi

# Check python-dotenv
if python3 -c "from dotenv import load_dotenv" 2>/dev/null; then
    echo "✅ python-dotenv instalado"
else
    echo "📦 Instalando python-dotenv..."
    pip install python-dotenv --quiet
fi

echo ""
echo "🚀 Iniciando bot..."
cd "$HOME/.openclaw/workspace"
python3 scripts/telegram_bot_menu.py