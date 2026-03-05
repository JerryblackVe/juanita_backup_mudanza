---
name: brave
description: Realiza búsquedas web usando la Brave Search API.
risk: safe
compatibility:
  network: true
license: MIT
---

# Brave Search

Búsquedas via Brave Search API (`https://api.search.brave.com/res/v1`).

## Requisitos

```bash
pip install requests
export BRAVE_API_KEY="tu-api-key"
```

## Uso

```bash
# Búsqueda web
python scripts/search.py web "query" -n 10

# Noticias
python scripts/search.py news "query" -n 10

# Sugerencias
python scripts/search.py suggest "query"
```

También podés pasar la API key directamente con `-k`:

```bash
python scripts/search.py web "Python" -k "tu-api-key"
```

## Scripts disponibles

- `scripts/search.py` — CLI para web, news y suggest
