#!/bin/bash
# Nombre: 04_backup.sh
# Descripción: Realiza una copia de seguridad comprimida de un directorio.

DIR_DESTINO="./mis_backups"

echo "=== Herramienta de Copias de Seguridad ==="
echo "Introduce la ruta absoluta o relativa del directorio a respaldar:"
read DIR_ORIGEN

# Validamos que el directorio de origen exista y sea un directorio
if [ ! -d "$DIR_ORIGEN" ]; then
    echo "Error crítico: El directorio origen '$DIR_ORIGEN' no existe."
    exit 1
fi

# Creamos el directorio de destino si no existe previamente
if [ ! -d "$DIR_DESTINO" ]; then
    mkdir "$DIR_DESTINO"
    echo "Directorio de almacenamiento '$DIR_DESTINO' creado exitosamente."
fi

# Nombramos el archivo con la fecha para no sobreescribir backups anteriores
FECHA=$(date +"%Y%m%d_%H%M%S")
NOMBRE_ARCHIVO="backup_${FECHA}.tar.gz"
RUTA_FINAL="${DIR_DESTINO}/${NOMBRE_ARCHIVO}"

echo "Iniciando compresión de '$DIR_ORIGEN' con tar y gzip..."

# Usamos tar para crear (c), comprimir (z), mostrar verbose (v) y empaquetar en archivo (f)
tar -czvf "$RUTA_FINAL" "$DIR_ORIGEN" > /dev/null 2>&1

# Comprobamos si el último comando (tar) se ejecutó sin errores (código 0)
if [ $? -eq 0 ]; then
    echo "¡Éxito! Copia de seguridad guardada en: $RUTA_FINAL"
    echo "Tamaño del archivo de backup:"
    du -h "$RUTA_FINAL"
else
    echo "Ocurrió un error al intentar realizar la copia de seguridad."
fi