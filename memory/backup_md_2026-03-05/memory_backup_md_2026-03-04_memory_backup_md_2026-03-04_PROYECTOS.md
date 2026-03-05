# Proyectos — Portafolio de JUANITA

> Registro de todos los proyectos generados con Autonomous SaaS workflow.
> Referencia centralizada para tracking, versiones y modificaciones.

---

## 📋 Proyectos

### 1. relog_aguja

**Descripción:** Reloj de agujas analógico con fondo negro minimalista.

**Características:**
- Tres agujas (hora, minuto, segundo)
- Fondo negro (#0a0a0a)
- Diseño responsivo
- Animación suave
- Display digital sutil

**Tech Stack:**
- HTML/CSS/JS (Vanilla)
- Deploy: Vercel

**Ubicaciones:**

| Recurso | URL |
|---------|-----|
| **Live** | https://relogaguja.vercel.app |
| **GitHub** | https://github.com/JerryblackVe/relog_aguja |
| **Código local** | `~/.openclaw/workspace/temp/relog_aguja/` |

**Historial:**

| Fecha | Acción | Notes |
|-------|--------|-------|
| 2026-03-03 | Creado | Brief → Código → GitHub → Vercel |
| 2026-03-03 | Deploy inicial |Primera versión productiva |

**Cómo modificar:**

```bash
# 1. Clonar repo
gh repo clone JerryblackVe/relog_aguja
cd relog_aguja

# 2. Hacer cambios en index.html

# 3. Commit y push
git add .
git commit -m "descripción del cambio"
git push

# 4. Vercel deploy automático
```

**Cómo versionar:**

```bash
# Crear release
gh release create v1.0.0 --title "Versión 1.0" --notes "Release inicial"
```

---

## 📌 Workflow para nuevos proyectos

### Generación

1. **Brief del usuario**
   - Nombre del proyecto
   - Descripción
   - Features

2. **Autonomous SaaS Workflow:**
   - Planificar task breakdown
   - Generar SPEC.md
   - Generar código (HTML/CSS/JS o frameworks)
   - Subir a GitHub
   - Deploy a Vercel

3. **Documentación:**
   - Agregar entrada en este archivo
   - Incluir URLs, tech stack, historial
   - Guardar en log_diario/

### Versionado

- Usar Git releases en GitHub
- Mantener changelog en este archivo
- Cada modificación = nueva entrada en historial

---

## 🔧 Templates

### Nueva entrada de proyecto

```markdown
### [NOMBRE PROYECTO]

**Descripción:** [Breve descripción]

**Características:**
- [Feature 1]
- [Feature 2]

**Tech Stack:**
- [Tecnología]
- [Plataforma deploy]

**Ubicaciones:**

| Recurso | URL |
|---------|-----|
| **Live** | [URL] |
| **GitHub** | [URL] |
| **Código local** | `~/.openclaw/workspace/temp/[proyecto]/` |

**Historial:**

| Fecha | Acción | Notes |
|-------|--------|-------|
| YYYY-MM-DD | Creado | Primera versión |

**Cómo modificar:**

```bash
# Comandos para modificar
```

**Cómo versionar:**

```bash
# Comandos para versionar
```
```

---

## 📊 Stats

- **Total proyectos:** 1
- **Último proyecto:** relog_aguja (2026-03-03)
- **Próximo:** [Pendiente]