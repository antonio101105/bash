#!/bin/bash
# Descripción: Realiza una copia de seguridad comprimida de un directorio.
# Autor: Antonio Manuel Núñez Campallo

DIR_DESTINO="./mis_backups"

echo "=== Herramienta de Copias de Seguridad ==="
echo "Introduce la ruta absoluta o relativa del directorio a respaldar:"
read DIR_ORIGEN

if [ ! -d "$DIR_ORIGEN" ]; then
    echo "Error crítico: El directorio origen '$DIR_ORIGEN' no existe."
    exit 1
fi

if [ ! -d "$DIR_DESTINO" ]; then
    mkdir "$DIR_DESTINO"
    echo "Directorio de almacenamiento '$DIR_DESTINO' creado."
fi

FECHA=$(date +"%Y%m%d_%H%M%S")
NOMBRE_ARCHIVO="backup_${FECHA}.tar.gz"
RUTA_FINAL="${DIR_DESTINO}/${NOMBRE_ARCHIVO}"

echo "Iniciando compresión de '$DIR_ORIGEN' con tar y gzip..."
tar -czvf "$RUTA_FINAL" "$DIR_ORIGEN" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "¡Éxito! Copia de seguridad guardada en: $RUTA_FINAL"
    du -h "$RUTA_FINAL"
else
    echo "Ocurrió un error al intentar realizar la copia de seguridad."
fi
