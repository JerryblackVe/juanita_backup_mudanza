#!/usr/bin/env python3
"""Script de ejemplo para crawl4ai."""
import asyncio
import sys
from crawl4ai import AsyncWebCrawler

async def main(url: str):
    async with AsyncWebCrawler() as crawler:
        result = await crawler.arun(url=url)
        print(result.markdown[:2000] if result.markdown else "Sin contenido")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python crawl.py <url>")
        sys.exit(1)
    asyncio.run(main(sys.argv[1]))