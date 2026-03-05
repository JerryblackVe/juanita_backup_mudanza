---
name: crawl4ai
description: Web scraping asincrónico con Playwright. Extracción de contenido dinámico.
---

# crawl4ai

Web scraping async con crawl4ai. Extracción inteligente de contenido web con Playwright.

## Cuándo usarlo
- Scraping de páginas dinámicas (JS)
- Extracción de contenido con Selectores CSS/XPath
- Crawling de sitios múltiples
- Extracción de markdown y estructura

## Ejemplo básico
```python
from crawl4ai import AsyncWebCrawler

async def crawl():
    async with AsyncWebCrawler() as crawler:
        result = await crawler.arun(url="https://ejemplo.com")
        print(result.markdown)
```