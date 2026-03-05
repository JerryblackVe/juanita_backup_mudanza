# PATRONES APRENDIDOS

## ✅ Lo que funciona
- **exec simple con timeout funciona** cuando se usa correctamente
- **Sub-agentes** funcionan bien para tareas complejas
- **Proceso background** con `> /dev/null 2>&1 &` para servicios

## ❌ Errores frecuentes y soluciones
- **exec "Validation failed"** → Usar `process` o tmux como alternativa
- **write sin content** → Siempre incluir `path` Y `content`
- **read sin path** → Siempre incluir `path` o `file_path`
- **Subprocess con `&` sin shell** → Necesita `shell=True`

## 🔧 Skills pendientes de crear
- auto-resolver (creado en este session)

## 📊 Estadísticas
- Tareas exitosas: 0
- Tareas fallidas: 0
- Tasa de éxito: 0%
