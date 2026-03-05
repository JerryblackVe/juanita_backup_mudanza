# Routing Decisiones - Cuándo usar qué modelo

Guía de decisiones para seleccionar el modelo adecuado según el tipo de tarea.

## Modelos disponibles
### deepseek-v3.2 (actual)
- **Fortalezas:** [Razonamiento técnico, código, análisis complejo]
- **Debilidades:** [Velocidad, creatividad, conversación casual]
- **Tokens típicos:** [X por respuesta]
- **Costo relativo:** [Bajo/Medio/Alto]

### llama-3.3 (alternativa)
- **Fortalezas:** [Creatividad, conversación, textos largos]
- **Debilidades:** [Precisión técnica, razonamiento complejo]
- **Tokens típicos:** [X por respuesta]
- **Costo relativo:** [Bajo/Medio/Alto]

## Reglas de routing
### Usar deepseek-v3.2 cuando:
1. [Tareas técnicas o de código]
2. [Análisis complejo o razonamiento]
3. [Procesamiento de datos]
4. [Respuestas que requieren precisión]
5. [Tareas que consumen muchos tokens]

### Usar llama-3.3 cuando:
1. [Conversaciones casuales]
2. [Generación creativa]
3. [Redacción de textos largos]
4. [Brainstorming]
5. [Interacciones sociales]

## Ejemplos documentados
### Caso 1: Análisis de código
- **Tarea:** [Analizar función Python compleja]
- **Modelo elegido:** deepseek-v3.2
- **Resultado:** [Excelente, análisis preciso]
- **Razón:** [deepseek es superior en tareas técnicas]

### Caso 2: Redacción creativa
- **Tarea:** [Escribir historia corta]
- **Modelo elegido:** llama-3.3
- **Resultado:** [Creativo, fluido, engaging]
- **Razón:** [llama es mejor para creatividad]

### Caso 3: Conversación técnica
- **Tarea:** [Explicar concepto técnico a principiante]
- **Modelo elegido:** [deepseek-v3.2 o llama-3.3 según complejidad]
- **Resultado:** [Variable - documentar qué funcionó mejor]
- **Razón:** [Depende del balance precisión vs claridad]

## Decisiones por categoría
| Categoría | Modelo recomendado | Notas |
|-----------|-------------------|-------|
| Programación | deepseek-v3.2 | Siempre |
| Análisis de datos | deepseek-v3.2 | Para precisión |
| Redacción técnica | deepseek-v3.2 | Claridad + precisión |
| Conversación casual | llama-3.3 | Más natural |
| Creatividad | llama-3.3 | Mejor fluidez |
| Resúmenes | deepseek-v3.2 | Para precisión |
| Brainstorming | llama-3.3 | Para diversidad de ideas |

## Ajustes basados en experiencia
### [Fecha: YYYY-MM-DD]
- **Nueva regla:** [Descripción]
- **Motivación:** [Por qué se añade]
- **Ejemplo:** [Caso concreto]

---

*Objetivo: Optimizar el uso de recursos eligiendo el modelo más adecuado para cada tarea.*