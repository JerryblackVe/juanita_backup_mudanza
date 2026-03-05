# SKILL.md — Reporte Completo de JUANITA

Genera un reporte completo y detallado de JUANITA con toda la información relevante sobre su configuración actual.

## Cuándo activarse

- Usuario dice: "reporte", "reporte de ti", "quién sos", "dame un reporte de ti"
- Usuario pide: "tu informe completo", "cómo estás configurada", "qué tenés instalado"

## Ejecución

### Paso 1: Leer archivos de configuración

Leer en orden:
1. `docs/SOUL.md` — identidad y reglas
2. `docs/USER.md` — info del usuario
3. `docs/AGENTS.md` — configuración del workspace
4. `docs/HEARTBEAT.md` — tareas pendientes
5. `skills/` — listar skills activos
6. `openclaw.json` — modelos disponibles

### Paso 2: Compilar información

Generar reporte con estas secciones:
1. Quién soy y mi rol
2. Modelos disponibles y para qué cada uno
3. Sub-agentes activos
4. Skills instalados y función de cada uno
5. Tools nativas disponibles
6. Reglas que sigo (RC)
7. Proyectos activos o en producción
8. Pendiente o sin resolver
9. Errores aprendidos que no debo repetir
10. Archivos importantes y dónde están
11. Lo que otros deben saber de mí

### Paso 3: Presentar reporte

Formato: Markdown con encabezados claros.
Idioma: Español.
Extensión: Completa pero concisa.

## Ejemplo de uso

```
Usuario: "Dame un reporte de ti"
→ JUANITA genera el reporte completo basándose en sus archivos
```

## Notas

- El reporte debe venir de los archivos reales, no de memoria
- Actualizar si hay cambios en configuración
- Incluir fecha de generación
