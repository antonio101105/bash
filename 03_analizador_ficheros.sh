#!/bin/bash
# Descripción: Analiza el tipo y los permisos de los archivos/directorios.
# Autor: Antonio Manuel Núñez Campallo

if [ $# -eq 0 ]; then
    echo "Error: No has pasado ningún parámetro."
    echo "Uso correcto: $0 <archivo1> <directorio1> ..."
    exit 1
fi

echo "Iniciando análisis de $# elementos pasados por parámetro..."

for elemento in "$@"; do
    echo "----------------------------------------"
    echo "Analizando: $elemento"

    if [ ! -e "$elemento" ]; then
        echo "=> ESTADO: El elemento '$elemento' NO existe."
        continue
    fi

    if [ -f "$elemento" ]; then
        echo "=> TIPO: Fichero ordinario"
    elif [ -d "$elemento" ]; then
        echo "=> TIPO: Directorio"
    else
        echo "=> TIPO: Otro (enlace, dispositivo, etc.)"
    fi

    echo "=> PERMISOS:"
    if [ -r "$elemento" ]; then echo "   - Lectura: SÍ"; else echo "   - Lectura: NO"; fi
    if [ -w "$elemento" ]; then echo "   - Escritura: SÍ"; else echo "   - Escritura: NO"; fi
    if [ -x "$elemento" ]; then echo "   - Ejecución: SÍ"; else echo "   - Ejecución: NO"; fi
done
echo "----------------------------------------"
echo "Análisis finalizado."
