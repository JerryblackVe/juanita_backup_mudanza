---
name: speed
description: Mide la latencia de todos los modelos NVIDIA NIM y Groq configurados en openclaw.json. Ejecuta bajo demanda cuando el usuario escribe /speed o pide medir la velocidad/latencia de los modelos.
---

# Speed - Test de Latencia

Mide la latencia de respuesta de todos los modelos configurados en `openclaw.json`.

## Uso

```bash
python scripts/latency.py
```

O ejecutar con el comando:

```
/speed
```

## Salida

Reporte en formato Telegram con:
- Ranking por latencia (🥇🥈🥉)
- Indicador del proveedor (NVIDIA/Groq)
- Errores si algún modelo falla
- Estadísticas de modelos rápidos (< 2s)

Guarda el último resultado en `memory/speed_last.md`.

## Detalles técnicos

- Lee modelos dinámicamente desde `~/.openclaw/openclaw.json`
- Resuelve variables de entorno (`${NVIDIA_API_KEY}`, `${GROQ_API_KEY}`)
- Timeout: 60s por modelo
- Ejecución en paralelo (asyncio)
- Prompt de test: "Contesta solo con la palabra: OK"
