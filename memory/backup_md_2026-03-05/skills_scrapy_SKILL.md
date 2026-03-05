---
name: scrapy
description: Framework completo para web scraping con spiders, pipelines y middleware.
---

# scrapy

Framework de scraping en Python. Spiders, pipelines, middleware y extracción estructurada.

## Qué es Scrapy

Framework completo para scraping:
- Spiders: Crawlers configurables con selectores CSS/XPath
- Items: Extracción estructurada de datos
- Pipelines: Procesamiento y almacenamiento
- Middlewares: Manejo de requests/responses
- Feed exports: JSON, CSV, XML

## Cuándo usarlo

- Grandes proyectos de scraping (100s/1000s de URLs)
- Extracción estructurada con esquemas definidos
- Pipelines de procesamiento de datos
- Crawling recursivo de sitios completos
- Necesitas control total del proceso

## Instalación

```bash
pip install scrapy
# o
~/.openclaw/venv/bin/pip install scrapy
```

## Crear proyecto

```bash
scrapy startproject mi_spider
```

Estructura:
```
mi_spider/
├── scrapy.cfg
├── mi_spider/
│   ├── __init__.py
│   ├── items.py
│   ├── middlewares.py
│   ├── pipelines.py
│   ├── settings.py
│   └── spiders/
│       └── __init__.py
```

## Ejemplo básico

```python
# mi_spider/spiders/ejemplo.py
import scrapy

class EjemploSpider(scrapy.Spider):
    name = "ejemplo"
    allowed_domains = ["example.com"]
    start_urls = ["https://example.com"]
    
    def parse(self, response):
        for item in response.css("div.item"):
            yield {
                'titulo': item.css("h2::text").get(),
                'precio': item.css("span.price::text").get(),
                'link': item.css("a::attr(href)").get()
            }

        # Seguir paginación
        next_page = response.css("a.next::attr(href)").get()
        if next_page:
            yield response.follow(next_page, self.parse)
```

## Ejecutar spider

```bash
# Output a terminal
scrapy crawl ejemplo

# Output a archivo JSON
scrapy crawl ejemplo -o output.json

# Output a CSV
scrapy crawl ejemplo -o output.csv
```

## Configuración avanzada

### settings.py
```python
BOT_NAME = 'mi_spider'

USER_AGENT = 'Mozilla/5.0 (compatible; MiBot/0.1)'

ROBOTSTXT_OBEY = False

DOWNLOAD_DELAY = 3  # Segundos entre requests

CONCURRENT_REQUESTS = 16

FEEDS = {
    'output.json': {
        'format': 'json',
        'overwrite': True
    }
}
```

## Selectores

### CSS Selectors
```python
response.css("div.product")
response.css("h1.title::text").get()
response.css("a.link::attr(href)").getall()
```

### XPath
```python
response.xpath("//div[@class='product']")
response.xpath("//h1/text()").get()
```

## Scrapy Shell (debug)

```bash
scrapy shell "https://example.com"

>>> response.css("title::text").get()
>>> response.xpath("//h1").get()
>>> quit()
```

## Ejemplo completo con Item

```python
# items.py
import scrapy

class ProductoItem(scrapy.Item):
    titulo = scrapy.Field()
    precio = scrapy.Field()
    disponible = scrapy.Field()
    url = scrapy.Field()

# spiders/tienda.py
import scrapy
from mi_spider.items import ProductoItem

class TiendaSpider(scrapy.Spider):
    name = "tienda"
    start_urls = ["https://tienda.com/productos"]
    
    def parse(self, response):
        for producto in response.css("div.product-card"):
            item = ProductoItem()
            item['titulo'] = producto.css("h3::text").get()
            item['precio'] = producto.css(".price::text").get()
            item['disponible'] = producto.css(".stock").get() is not None
            item['url'] = response.urljoin(producto.css("a::attr(href)").get())
            yield item
```

## Pipelines (procesamiento)

```python
# pipelines.py
class PrecioPipeline:
    def process_item(self, item, spider):
        # Limpiar precio
        if item.get('precio'):
            item['precio'] = float(item['precio'].replace('$', '').strip())
        return item
```

## Middlewares

```python
# middlewares.py
class ProxyMiddleware:
    def process_request(self, request, spider):
        request.meta['proxy'] = 'http://proxy.example.com:8080'
        return request
```

## Tips

1. **Siempre respeta robots.txt** o configura `ROBOTSTXT_OBEY = False` con cuidado
2. **Usa DOWNLOAD_DELAY** para no saturar servidores
3. **Usa Scrapy Shell** para probar selectores antes de escribir código
4. **Maneja errores** con `errback` en requests
5. **Cierra spiders limpio** con `Ctrl+C` una vez, dos veces fuerza

## Referencias

- Docs: https://docs.scrapy.org/
- GitHub: https://github.com/scrapy/scrapy
- Tutoriales: https://docs.scrapy.org/en/latest/intro/tutorial.html