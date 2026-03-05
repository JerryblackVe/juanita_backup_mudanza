---
name: knowledge
description: Base de conocimiento de JUANITA para buscar y recordar información aprendida. Úsalo cuando necesites recordar algo que hemos aprendido, referencias guardadas, o buscar en la memoria.
---

# Knowledge - Base de Conocimiento de JUANITA

## Cuándo usar este skill
- Cuando el usuario pregunta algo que ya hemos visto/aprendido
- Cuando necesitás buscar en referencias guardadas
- Para encontrar skills o casos de uso que instalamos

## Comandos
```bash
python scripts/search.py list  # Listar conocimiento
python scripts/search.py "RAG"  # Buscar
```

## Archivos de conocimiento
- `memory/awesome-llm-apps.md` - 10 proyectos útiles de LLM apps
- `memory/awesome-openclaw-usecases.md` - Casos de uso de OpenClaw
- `memory/2026-02-27.md` - Todo lo hecho hoy
- `memory/MEMORY.md` - Memoria de largo plazo

## Ejemplos
- Usuario: "Ese skill de RAG que mencionamos" → Buscar: RAG
- Usuario: "那次安装的 skills" → Buscar: skills
- Usuario: "El caso de uso de morning brief" → Buscar: morning