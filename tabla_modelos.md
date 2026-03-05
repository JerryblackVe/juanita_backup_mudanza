# Análisis de Modelos - JUANITA 2026-03-04

## 🏆 TOP 3 Modelos Recomendados

| Modelo | Provider | Context Window | Max Output | Rate Limit | Latencia | Útil para |
|--------|----------|----------------|------------|------------|----------|-----------|
| **1. kimk2-instruct** | nvidia/moonshotai | **131k tokens** | 8k tokens | 10 req/min (NVIDIA) | ✅ **~300ms** | **Última versión**, excelente para tareas complejas |
| **2. qwen3-32b** | groq/qwen | **32k tokens** | 4k tokens | 30 req/min (Groq) | ✅ **~200ms** | ✅ **Equilibrio velocidad/inteligencia** (32B) |
| **3. deepseek-v3.2** | nvidia/deepseek | **128k tokens** | 8k tokens | 60 req/min | ⚠️ **~1-2s** | Para código y analysis profundo |

## 📊 Modelos Actuales en Sistema

| Alias | Modelo Real | Estado | Nota |
|-------|-------------|--------|------|
| `minimax` | **minimax-ai/minimax-m2.1** | ✅ Activo | Principal por defecto |
| `fast` | **step-3.5-flash** | ✅ Activo | Rápido para tareas básicas |
| `kimi` | **kimi-k2.5-thinking:free** | ✅ Activo | Para razonamiento profundo |
| `deepseek` | **deepseek-v3.2** | ✅ Activo | Código y maths |
| `glm5` | **glm5** | ✅ Activo | General purpose |
| `qwen3` | **qwen3-32b** | ✅ Activo | 32B balance perfecto |

## ⚠️ Avisos de sistema actual:
- ❌ **gpt-oss-20b** deshabilitado (modelo pequeño, menos recomendado)
- ✅ **NVIDIA NIM** con capacidad para modelos grandes
- 📈 **Recomendación**: Usar moonshotai/kimi-k2-instruct como principal

## 🎯 Recomendación final:
**1. Principal**: `nvidia/moonshotai/kimi-k2-instruct`  
**2. Velocidad**: `groq/qwen3-32b`  
**3. Backup**: `nvidia/deepseek/deepseek-v3.2`