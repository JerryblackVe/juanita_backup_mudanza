#!/usr/bin/env python3
"""Script de ejemplo para scrapling."""
import sys
from scrapling.fetchers import Fetcher

def main(url: str):
    fetcher = Fetcher()
    response = fetcher.get(url)
    print(f"Status: {response.status_code}")
    print(f"Titulo: {response.css('title::text')}")
    print(f"Content (primeros 1000 chars): {response.text[:1000]}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python scrape.py <url>")
        sys.exit(1)
    main(sys.argv[1])