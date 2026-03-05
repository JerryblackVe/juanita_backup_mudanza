---
name: scrapling
description: Scraping rápido con múltiples backends (curl_cffi, Playwright, HTTPX).
---

# scrapling

Web scraping con scrapling. Fetching rápido con múltiples backends (curl_cffi, Playwright, HTTPX).

## Cuándo usarlo
- Scraping rápido con curl_cffi (más ligero que Playwright)
- Páginas dinámicas con Playwright
- Extracción con selectores CSS
- Manejo de anti-bot

## Ejemplo básico
```python
from scrapling.fetchers import Fetcher

fetcher = Fetcher()
response = fetcher.get("https://ejemplo.com")
print(response.text)
# Extraer con CSS
print(response.css("title::text"))
```