#!/usr/bin/env python3
"""
backup_auto_md.py - Backup automático de archivos Markdown

Copia todos los archivos .md del workspace a memory/backup_md_YYYY-MM-DD/
Ejecutar: python3 scripts/backup_auto_md.py [--fecha YYYY-MM-DD] [--destino DIR]

Uso en cron:
0 2 * * * ~/.openclaw/venv/bin/python ~/.openclaw/workspace/scripts/backup_auto_md.py
"""

import os
import shutil
import sys
from datetime import datetime
from pathlib import Path

# Configuración
WORKSPACE = Path.home() / ".openclaw" / "workspace"
DIRS_A_COPIAR = [
    "docs/",
    "memory/",
    "skills/",
]
EXCLUIR = [
    "__pycache__",
    ".git",
    "node_modules",
    ".pyc"
]


def log(msg):
    """Imprime con timestamp."""
    print(f"[{datetime.now().strftime('%H:%M:%S')}] {msg}")


def listar_md(directorio: Path, exclude: list = None) -> list:
    """Lista todos los archivos .md recursivamente."""
    exclude = exclude or []
    encontrados = []
    for item in directorio.rglob("*.md"):
        if any(e in str(item) for e in exclude):
            continue
        encontrados.append(item)
    return encontrados


def backup_md(fecha: str = None, destino: Path = None) -> dict:
    """
    Ejecuta el backup de archivos Markdown.

    Returns:
        dict: Estadísticas del backup
    """
    if fecha is None:
        fecha = datetime.now().strftime("%Y-%m-%d")

    if destino is None:
        destino = WORKSPACE / "memory" / f"backup_md_{fecha}"

    log(f"Iniciando backup a: {destino}")

    # Crear directorio de destino
    destino.mkdir(parents=True, exist_ok=True)

    stats = {"copiados": 0, "errores": 0, "duplicados": 0}
    copiados_nombres = set()

    for dir_relativo in DIRS_A_COPIAR:
        dir_origen = WORKSPACE / dir_relativo
        if not dir_origen.exists():
            log(f"⚠️ No existe: {dir_relativo}")
            continue

        archivos_md = listar_md(dir_origen, EXCLUIR)

        for ruta_origen in archivos_md:
            nombre_archivo = ruta_origen.name

            # Si ya existe con ese nombre, agregar el directorio padre
            if nombre_archivo in copiados_nombres:
                rel_path = ruta_origen.relative_to(WORKSPACE)
                nombre_archivo = f"{rel_path.parent}/{rel_path.name}".replace("/", "_")
                stats["duplicados"] += 1

            ruta_destino = destino / nombre_archivo
            ruta_destino.parent.mkdir(parents=True, exist_ok=True)

            try:
                shutil.copy2(ruta_origen, ruta_destino)
                copiados_nombres.add(nombre_archivo)
                stats["copiados"] += 1
            except Exception as e:
                log(f"❌ Error copiando {ruta_origen}: {e}")
                stats["errores"] += 1

    # Guardar registro
    registro = destino / f"registro_{fecha}.txt"
    with open(registro, "w") as f:
        f.write(f"Backup MD - {fecha}\n")
        f.write(f"Archivos copiados: {stats['copiados']}\n")
        f.write(f"Duplicados renombrados: {stats['duplicados']}\n")
        f.write(f"Errores: {stats['errores']}\n")
        f.write(f"\nArchivos:\n")
        for nombre in sorted(copiados_nombres):
            f.write(f"  - {nombre}\n")

    return stats


def main():
    import argparse
    parser = argparse.ArgumentParser(description="Backup automático de archivos Markdown")
    parser.add_argument("--fecha", help="Fecha del backup (YYYY-MM-DD)")
    parser.add_argument("--destino", help="Directorio de destino")
    args = parser.parse_args()

    dest = Path(args.destino) if args.destino else None
    stats = backup_md(args.fecha, dest)

    log(f"\n✅ Backup completado:")
    log(f"   Archivos copiados: {stats['copiados']}")
    log(f"   Duplicados renombrados: {stats['duplicados']}")
    log(f"   Errores: {stats['errores']}")

    sys.exit(0 if stats["errores"] == 0 else 1)


if __name__ == "__main__":
    main()
