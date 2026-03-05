#!/usr/bin/env python3
"""Mide la latencia de todos los modelos configurados en openclaw.json."""

import json
import time
import asyncio
import os
from datetime import datetime
from pathlib import Path
from openai import AsyncOpenAI

CONFIG_PATH = Path.home() / ".openclaw/openclaw.json"
OUTPUT_PATH = Path.home() / ".openclaw/workspace/memory/speed_last.md"


def resolve_api_key(key_ref: str) -> str:
    """Resuelve referencias a variables de entorno."""
    if key_ref.startswith("${") and key_ref.endswith("}"):
        var_name = key_ref[2:-1]
        return os.environ.get(var_name, key_ref)
    return key_ref


def load_models():
    """Carga modelos desde openclaw.json."""
    with open(CONFIG_PATH) as f:
        config = json.load(f)
    
    models = []
    providers = config.get("models", {}).get("providers", {})
    
    for prov_name, provider in providers.items():
        base_url = provider.get("baseUrl", "")
        api_key_ref = provider.get("apiKey")
        
        if not base_url or not api_key_ref:
            continue
            
        api_key = resolve_api_key(api_key_ref)
        
        for m in provider.get("models", []):
            model_id = m.get("id", "")
            alias = config.get("agents", {}).get("defaults", {}).get("models", {}).get(
                f"{prov_name}/{model_id}", {}
            ).get("alias", model_id.split("/")[-1])
            
            models.append({
                "id": model_id,
                "alias": alias,
                "full_id": f"{prov_name}/{model_id}",
                "baseUrl": base_url,
                "apiKey": api_key,
                "provider": prov_name
            })
    
    return models


async def test_model(model):
    """Prueba un modelo y mide su latencia."""
    try:
        client = AsyncOpenAI(
            base_url=model["baseUrl"],
            api_key=model["apiKey"],
            timeout=60.0
        )
        
        start = time.time()
        response = await client.chat.completions.create(
            model=model["id"],
            messages=[{"role": "user", "content": "Contesta solo con la palabra: OK"}],
            max_tokens=10
        )
        elapsed = (time.time() - start) * 1000
        
        return {
            "alias": model["alias"],
            "full_id": model.get("full_id", model["id"]),
            "latency": round(elapsed, 1),
            "status": "OK",
            "provider": model["provider"]
        }
    except Exception as e:
        return {
            "alias": model["alias"],
            "full_id": model.get("full_id", model["id"]),
            "latency": 0,
            "status": f"Error: {str(e)[:50]}",
            "provider": model["provider"]
        }


async def run_all():
    """Ejecuta tests en paralelo para todos los modelos."""
    models = load_models()
    
    if not models:
        print("❌ No se encontraron modelos configurados")
        return
    
    tasks = [test_model(m) for m in models]
    results = await asyncio.gather(*tasks)
    
    # Separa resultados exitosos y errores
    results_ok = sorted([r for r in results if r["latency"] > 0], key=lambda x: x["latency"])
    errors = [r for r in results if r["latency"] == 0]
    
    # Genera reporte
    now = datetime.now().strftime("%Y-%m-%d %H:%M")
    lines = [
        f"⚡️ Latencia — {now}",
        "─────────────",
        "#  | Alias      | Modelo completo              | Proveedor | Estado",
        "───┼────────────┼────────────────────────────┼───────────┼───────"
    ]
    
    emojis = ["🥇", "🥈", "🥉"]
    for i, r in enumerate(results_ok):
        pos = emojis[i] if i < 3 else f"{i+1}."
        lat = f"{r['latency']/1000:.2f}s" if r['latency'] > 1000 else f"{r['latency']:.1f}ms"
        provider = "NVIDIA" if r['provider'] == 'nvidia' else "Groq"
        full_id = r.get('full_id', r['alias'])
        lines.append(f"{pos:2} | {r['alias']:10} | {full_id:28} | {provider:9} | ✅ {lat}")
    
    rank = len(results_ok) + 1
    for e in errors:
        provider = "NVIDIA" if e['provider'] == 'nvidia' else "Groq"
        lines.append(f"{rank:2}. | {e['alias']:10} | {e.get('full_id', e['alias']):28} | {provider:9} | ❌ {e['status']}")
        rank += 1
    
    lines.append("─────────────")
    
    fast = len([r for r in results_ok if r['latency'] < 2000])
    lines.append(f"✅ Rápidos (<2s): {fast}/{len(results_ok)}")
    
    report = "\n".join(lines)
    print(report)
    
    # Guarda resultado
    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT_PATH.write_text(report + "\n")
    
    return report


if __name__ == "__main__":
    asyncio.run(run_all())
