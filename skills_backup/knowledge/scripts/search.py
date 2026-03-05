#!/usr/bin/env python3
"""Knowledge Base Search - Busca en la base de conocimiento de JUANITA"""
import os
import sys
import json
from pathlib import Path

MEMORY_DIR = Path.home() / ".openclaw/workspace/memory"
SKILLS_DIR = Path.home() / ".openclaw/workspace/skills"

# Archivos de conocimiento
KNOWLEDGE_FILES = [
    MEMORY_DIR / "awesome-llm-apps.md",
    MEMORY_DIR / "awesome-openclaw-usecases.md",
    MEMORY_DIR / "2026-02-27.md",
    MEMORY_DIR / "MEMORY.md",
]

def search_knowledge(query, verbose=False):
    """Busca en todos los archivos de conocimiento."""
    results = []
    query_lower = query.lower()
    
    for kb_file in KNOWLEDGE_FILES:
        if not kb_file.exists():
            continue
        
        content = kb_file.read_text(errors='ignore')
        lines = content.split('\n')
        
        file_results = []
        for i, line in enumerate(lines, 1):
            if query_lower in line.lower():
                # Get context (3 lines before and after)
                start = max(0, i - 4)
                end = min(len(lines), i + 2)
                context = '\n'.join(lines[start:end])
                file_results.append({
                    'line': i,
                    'text': line.strip(),
                    'context': context
                })
        
        if file_results:
            results.append({
                'file': str(kb_file.relative_to(Path.home())),
                'matches': file_results
            })
    
    return results

def list_knowledge():
    """Lista todo el conocimiento disponible."""
    info = []
    for kb_file in KNOWLEDGE_FILES:
        if kb_file.exists():
            lines = len(kb_file.read_text().split('\n'))
            info.append(f"📄 {kb_file.name} ({lines} líneas)")
    return info

def main():
    if len(sys.argv) < 2:
        print("Uso: python search.py <query>")
        print("\nComandos:")
        print("  list - Listar conocimiento disponible")
        print("  <query> - Buscar en conocimiento")
        sys.exit(1)
    
    if sys.argv[1] == "list":
        info = list_knowledge()
        print("📚 Base de Conocimiento JUANITA\n")
        for i in info:
            print(i)
        return
    
    query = " ".join(sys.argv[1:])
    results = search_knowledge(query)
    
    if not results:
        print(f"❌ No encontré nada sobre: {query}")
        print("\n尝试a buscar en:")
        for i in list_knowledge():
            print(i)
        return
    
    print(f"🔍 Resultados para: {query}\n")
    for r in results:
        print(f"📁 {r['file']}")
        for m in r['matches'][:3]:  # Max 3 por archivo
            print(f"  📍 Línea {m['line']}: {m['text'][:80]}")
        print()

if __name__ == "__main__":
    main()
