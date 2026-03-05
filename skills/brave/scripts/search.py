#!/usr/bin/env python3
"""
Brave Search API - Web Search, News, and Suggestions
"""
import sys
import json
import argparse
import requests

BASE_URL = "https://api.search.brave.com/res/v1"

def web_search(query, count=10, api_key=None):
    """Search web via Brave Search API."""
    if not api_key:
        print("Error: BRAVE_API_KEY not provided. Use -k option.", file=sys.stderr)
        sys.exit(1)
    
    url = f"{BASE_URL}/web/search"
    headers = {
        "X-API-Key": api_key,
        "Accept": "application/json"
    }
    params = {"q": query, "count": count}
    
    r = requests.get(url, headers=headers, params=params)
    r.raise_for_status()
    return r.json()


def news_search(query, count=10, api_key=None):
    """Search news via Brave Search API."""
    if not api_key:
        print("Error: BRAVE_API_KEY not provided. Use -k option.", file=sys.stderr)
        sys.exit(1)
    
    url = f"{BASE_URL}/news/search"
    headers = {
        "X-API-Key": api_key,
        "Accept": "application/json"
    }
    params = {"q": query, "count": count}
    
    r = requests.get(url, headers=headers, params=params)
    r.raise_for_status()
    return r.json()


def suggestions(query, api_key=None):
    """Get search suggestions from Brave."""
    if not api_key:
        print("Error: BRAVE_API_KEY not provided. Use -k option.", file=sys.stderr)
        sys.exit(1)
    
    url = f"{BASE_URL}/suggestions"
    headers = {
        "X-API-Key": api_key,
        "Accept": "application/json"
    }
    params = {"q": query}
    
    r = requests.get(url, headers=headers, params=params)
    r.raise_for_status()
    return r.json()


def main():
    parser = argparse.ArgumentParser(description="Brave Search API")
    parser.add_argument("type", choices=["web", "news", "suggest"], help="Search type")
    parser.add_argument("query", help="Search query")
    parser.add_argument("-n", "--count", type=int, default=10, help="Number of results")
    parser.add_argument("-k", "--api-key", help="Brave API key (or set BRAVE_API_KEY)")
    args = parser.parse_args()
    
    if args.type == "web":
        result = web_search(args.query, args.count, args.api_key)
    elif args.type == "news":
        result = news_search(args.query, args.count, args.api_key)
    else:
        result = suggestions(args.query, args.api_key)
    
    print(json.dumps(result, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
