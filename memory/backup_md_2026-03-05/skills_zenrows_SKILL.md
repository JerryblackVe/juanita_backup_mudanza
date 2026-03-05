---
name: zenrows
description: Web scraping con ZenRows API - anti-bot, JS rendering, proxies rotativas.
---

# zenrows

Web scraping con ZenRows API. Servicio anti-bot con JS rendering, proxies rotativas y CAPTCHA bypass.

## Qué es ZenRows

API de scraping que maneja:
- Anti-bot detection
- JavaScript rendering
- Rotación de proxies
- CAPTCHA solving
- Geolocalización de IPs
- Custom headers

## Cuándo usarlo

- Páginas con protección anti-bot (Cloudflare, DataDome)
- Necesitas proxies residenciales rotativos
- JavaScript rendering en el servidor
- CAPTCHA bypass automático
- Rate limiting avanzado

## Instalación

```bash
pip install requests python-dotenv
```

## Configuración

Añadir a `.env`:
```
ZENROWS_API_KEY=304873217184ee65200804582989ee07b8f0da02
```

## Ejemplo básico

```python
import os
import requests
from dotenv import load_dotenv

load_dotenv()
API_KEY = os.getenv("ZENROWS_API_KEY")

def scrape_zenrows(url):
    params = {
        'url': url,
        'apikey': API_KEY,
        'js_render': 'true',
        'premium_proxy': 'true',
    }
    response = requests.get('https://api.zenrows.com/v1/', params=params)
    return response.text if response.status_code == 200 else None
```

## Parámetros clave

| Parámetro | Descripción | Ejemplo |
|-----------|-------------|---------|
| `js_render` | Renderiza JavaScript | `true` |
| `premium_proxy` | Usa proxies residenciales | `true` |
| `proxy_country` | Geolocalización de proxy | `us`, `gb`, `de` |
| `wait` | Espera X ms después de render | `5000` |
| `wait_for` | Espera selector CSS | `#content` |
| `block_resources` | Bloquea imágenes/CSS | `image,media` |
| `antibot` | Modo anti-bot avanzado | `true` |

## Uso avanzado

```python
import requests
import os

API_KEY = os.getenv("ZENROWS_API_KEY")

def scrape_protected(url):
    params = {
        'url': url,
        'apikey': API_KEY,
        'js_render': 'true',
        'premium_proxy': 'true',
        'antibot': 'true',
        'block_resources': 'image,media,font',
        'wait': '3000',
    }
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
    }
    response = requests.get(
        'https://api.zenrows.com/v1/',
        params=params,
        headers=headers,
        timeout=30
    )
    return {
        'status': response.status_code,
        'content': response.text,
        'url': response.url
    }
```

## Rate limits

- 1000 requests/mes (free trial)
- Chequear dashboard para límites actuales

## Errores comunes

| Código | Significado | Solución |
|--------|-------------|----------|
| 400 | URL inválida | Verificar formato URL |
| 401 | API key inválida | Revisar `.env` |
| 429 | Rate limit excedido | Esperar o upgrade plan |
| 500 | Error del servidor | Reintentar con backoff |

## Referencias

- Dashboard: https://app.zenrows.com/
- Docs: https://www.zenrows.com/documentation
- API Playground: https://app.zenrows.com/playground