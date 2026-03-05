---
name: voice
description: "Maneja comunicación por voz: voz a texto (entrada) y texto a voz (salida). Activar con /voz on/off/status. La transcripción de entrada es siempre activa."
---

# Voice — Comunicación por Voz

Maneja comunicación por voz en dos direcciones.

## ⚙️ Instalación (una vez)

```bash
# Dependencias Python
pip install vosk wave edge-tts --break-system-packages

# FFmpeg (necesario para conversión de audio)
sudo apt install ffmpeg -y

# Modelo español para Vosk (~500MB)
mkdir -p ~/.openclaw/workspace/scripts/
cd ~/.openclaw/workspace/scripts/
wget https://alphacephei.com/vosk/models/vosk-model-es-0.42.zip
unzip vosk-model-es-0.42.zip
mv vosk-model-es-0.42 vosk-model-es/
rm vosk-model-es-0.42.zip
```

## 🎤 PARTE 1 — VOZ A TEXTO (Entrada)

**SIEMPRE activo** — Juanita siempre entiende audios entrantes.

### Flujo:
1. Recibir audio de Telegram (formatos: ogg, mp3, wav, m4a)
2. Descargar y convertir a WAV usando ffmpeg
3. Transcribir con Vosk (offline, sin API key)
4. Procesar el texto como mensaje normal

### Código:
```python
import subprocess
import json
from vosk import Model, Recognizer

VOSK_MODEL = "~/.openclaw/workspace/scripts/vosk-model-es/"
AUDIO_INPUT = "/path/to/audio.ogg"
AUDIO_WAV = "/tmp/audio_converted.wav"

# 1. Convertir a WAV
subprocess.run([
    "ffmpeg", "-i", AUDIO_INPUT, "-ar", "16000", "-ac", "1", 
    "-c:a", "pcm_s16le", AUDIO_WAV, "-y"
], capture_output=True)

# 2. Transcribir con Vosk
model = Model(VOSK_MODEL)
recognizer = Recognizer(model, 16000)

with open(AUDIO_WAV, "rb") as f:
    data = f.read(1024)
    while data:
        recognizer.AcceptWaveform(data)
        data = f.read(1024)

result = json.loads(recognizer.FinalResult())
texto = result["text"]
```

### Si falla:
- Reportar error al usuario
- Pedir que reenvíen el audio
- No bloquear conversación

## 🔊 PARTE 2 — TEXTO A VOZ (Salida)

**Solo activo con `/voz on`** — desactivado por defecto.

### Control:
- `/voz on` → activar respuestas en audio
- `/voz off` → desactivar (solo texto)
- `/voz status` → mostrar estado actual

### Código:
```python
import asyncio
import edge_tts
import os

VOICE_DEFAULT = "es-ES-ElviraNeural"  # Voz femenina española (más natural)
AUDIO_OUTPUT = "/tmp/voice_response.mp3"
CONFIG_FILE = "~/.openclaw/workspace/scripts/voice_config.json"

async def text_to_speech(texto: str, output_path: str = AUDIO_OUTPUT):
    communicate = edge_tts.Communicate(texto, VOICE_DEFAULT)
    await communicate.save(output_path)
    return output_path

def get_voice_status():
    import json
    import os
    config_path = os.path.expanduser(CONFIG_FILE)
    if os.path.exists(config_path):
        with open(config_path) as f:
            return json.load(f).get("voice_enabled", False)
    return False

def set_voice_status(enabled: bool):
    import json
    import os
    config_path = os.path.expanduser(CONFIG_FILE)
    os.makedirs(os.path.dirname(config_path), exist_ok=True)
    with open(config_path, "w") as f:
        json.dump({"voice_enabled": enabled}, f)
```

### Flujo:
1. Verificar si voz está activada (`/voz on`)
2. Si está activa: generar audio con edge-tts
3. Enviar por Telegram
4. Borrar archivo temporal
5. Si falla: responder en texto + avisar

### Voces disponibles:
- `es-AR-TomasNeural` (argentino) — recomendado
- `es-ES-ElviraNeural` (español)
- `es-MX-DaliaNeural` (méxico)

## 📁 Estructura de archivos

```
~/.openclaw/workspace/scripts/
├── vosk-model-es/          # Modelo Vosk español (~500MB)
├── voice_config.json       # {"voice_enabled": true/false}
├── voice_temp.mp3          # Audio temporal
└── audio_converted.wav     # Audio convertido
```

## ⚠️ REGLAS

1. **Transcripción de entrada** — SIEMPRE activa
2. **Respuestas en voz** — solo con `/voz on`
3. **Borrar archivos temporales** — después de enviar
4. **Si falla Vosk** — reportar error, pedir reenvío
5. **Si falla edge-tts** — responder texto, avisar
6. **Todo en español** — mensajes y comentarios