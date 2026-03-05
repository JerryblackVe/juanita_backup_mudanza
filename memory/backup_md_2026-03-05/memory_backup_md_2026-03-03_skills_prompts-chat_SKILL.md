---
name: prompts-chat
description: "Biblioteca de prompts desde prompts.chat. Usar /prompt buscar [tema] o /prompt random"
---

# Prompts Chat — Biblioteca de Prompts

Accede a la biblioteca de prompts de prompts.chat (143k+ estrellas en GitHub).

## Comandos

- `/prompt buscar [tema]` — Buscar prompts por palabra clave
- `/prompt random` — Obtener un prompt al azar
- `/prompt categoria [nombre]` — Buscar por categoría (writing, coding, etc.)

## Cómo funciona

Usa la API de prompts.chat para buscar y obtener prompts.

### Buscar por tema
```bash
curl "https://prompts.chat/api/prompts?search=TEMA&limit=5"
```

### Prompt random
```bash
curl "https://prompts.chat/api/prompts?limit=1&sort=random"
```

### Por categoría
```bash
curl "https://prompts.chat/api/prompts?category=CATEGORIA&limit=5"
```

## Uso

1. El usuario pide: `/prompt buscar email`
2. Buscar en la API
3. Devolver el prompt encontrado con título y descripción
4. Si el usuario quiere usarlo, aplicar el prompt a su solicitud

## Notas

- La API es pública y gratuita
- Prompts en inglés pero funcionan con cualquier modelo
- Hay miles de prompts para: writing, coding, image generation, video, etc.