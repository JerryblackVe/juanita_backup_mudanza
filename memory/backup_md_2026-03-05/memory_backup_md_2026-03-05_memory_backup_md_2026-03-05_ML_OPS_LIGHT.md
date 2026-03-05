# ML_OPS_LIGHT.md - Prácticas de ML Ops Simples para JUANITA

## Introducción

Este sistema implementa prácticas básicas de ML Ops sin base de datos, usando archivos markdown simples para registrar aprendizajes, errores y evaluaciones. Todo está en español y diseñado para ser mínimo y práctico.

## Estructura de carpetas

```
~/.openclaw/workspace/memory/
├── fails/                          # Errores y fallos
│   ├── outreach_fallo.md          # Mensajes de outreach que no funcionaron
│   ├── coding_errores.md          # Código que falló
│   └── respuestas_malas.md        # Respuestas que no gustaron
├── scoring/                       # Evaluación de sesiones
│   ├── sesion_template.md         # Plantilla para sesiones
│   └── sesion_[fecha].md          # Archivos de sesiones específicas
└── learnings/                     # Aprendizajes y mejores prácticas
    ├── prompt_mejoras.md          # Qué funciona mejor en prompts
    └── routing_decisiones.md      # Cuándo usar qué modelo
```

## Cómo usar estas carpetas

### 1. Registrar fallos (carpeta `fails/`)
Cuando algo no funciona, anótalo inmediatamente:

**Para outreach fallido:**
- Abre `memory/fails/outreach_fallo.md`
- Añade una nueva entrada con fecha
- Describe mensaje, contexto, resultado y aprendizaje

**Para errores de código:**
- Abre `memory/fails/coding_errores.md`
- Registra script, error, solución y lección

**Para respuestas malas:**
- Abre `memory/fails/respuestas_malas.md`
- Anota contexto, respuesta, feedback y mejora sugerida

### 2. Evaluar sesiones (carpeta `scoring/`)
Después de conversaciones importantes:

1. Copia `sesion_template.md` a `sesion_[fecha].md`
2. Completa la evaluación (útil sí/no, modelo, tokens, nota)
3. Escribe resumen, aspectos positivos y a mejorar
4. Extrae aprendizajes clave

**Formato mínimo:**
```
Fecha: 2026-03-03
Útil: sí
Modelo: deepseek-v3.2
Tokens: ~1500
Nota: 8/10
```

### 3. Agregar aprendizajes (carpeta `learnings/`)
Cuando descubres algo que funciona mejor:

**Mejoras de prompts (`prompt_mejoras.md`):**
- Registra técnicas de prompts efectivas
- Documenta patrones a evitar
- Comparte plantillas reutilizables

**Decisiones de routing (`routing_decisiones.md`):**
- Anota casos donde un modelo funcionó mejor
- Actualiza reglas de cuándo usar cada modelo
- Documenta ejemplos concretos con resultados

## Cómo consultarlos antes de responder

### Flujo recomendado:

1. **Antes de empezar una tarea:**
   - Revisa `routing_decisiones.md` para elegir modelo adecuado
   - Consulta `prompt_mejoras.md` para técnicas efectivas

2. **Durante desarrollo/programación:**
   - Verifica `coding_errores.md` para no repetir errores
   - Usa plantillas de `prompt_mejoras.md` si aplican

3. **Antes de enviar mensajes/outreach:**
   - Revisa `outreach_fallo.md` para evitar patrones negativos
   - Consulta `respuestas_malas.md` para mejorar comunicación

4. **Después de completar tarea:**
   - Evalúa sesión en `scoring/` si fue importante
   - Actualiza aprendizajes en `learnings/` si descubriste algo nuevo

### Comandos rápidos de consulta:
```bash
# Ver últimos errores de código
tail -20 ~/.openclaw/workspace/memory/fails/coding_errores.md

# Ver técnicas de prompts recientes
tail -30 ~/.openclaw/workspace/memory/learnings/prompt_mejoras.md

# Ver reglas de routing actuales
cat ~/.openclaw/workspace/memory/learnings/routing_decisiones.md | grep -A2 "Usar deepseek"
```

## Principios de mantenimiento

### Simplicidad:
- Todo en markdown plano
- Sin bases de datos complejas
- Sin scripts de automatización pesados
- Formato humano-legible primero

### Actualización constante:
- Agregar entradas inmediatamente después de eventos
- Revisar archivos periódicamente (semanalmente)
- Eliminar información obsoleta si se acumula mucho

### Enfoque práctico:
- Documentar sólo lo útil
- Mantener ejemplos concretos
- Priorizar lecciones aplicables

## Ejemplos de uso

### Caso 1: Error en script Python
1. Script falla → registrar en `coding_errores.md`
2. Encontrar solución → actualizar misma entrada
3. Próximo script similar → consultar entrada antes

### Caso 2: Respuesta mal recibida
1. Usuario no contento → registrar en `respuestas_malas.md`
2. Analizar por qué falló → documentar razón
3. Próxima situación similar → consultar para evitar error

### Caso 3: Descubrir técnica de prompt efectiva
1. Prompt funciona excepcionalmente bien → registrar en `prompt_mejoras.md`
2. Describir técnica y por qué funciona
3. Reutilizar en situaciones similares

## Notas importantes

- **Todo en español:** Mantener coherencia en el idioma
- **Sin duplicación:** Evitar registrar lo mismo en múltiples lugares
- **Fechas claras:** Siempre usar formato YYYY-MM-DD
- **Ejemplos concretos:** Mejor un ejemplo específico que generalidades
- **Acción inmediata:** Registrar cuanto antes, no dejar para después

---

*Este sistema vive en los archivos. Cuanto más lo uses, más valioso será.*