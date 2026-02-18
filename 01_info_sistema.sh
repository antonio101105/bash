#!/bin/bash
# Nombre: 01_info_sistema.sh
# Descripción: Muestra un reporte básico del estado del sistema y del usuario.

clear
echo "=================================================="
echo "         REPORTE DE ESTADO DEL SISTEMA            "
echo "=================================================="

# Uso de variables y comandos básicos
FECHA=$(date +"%A, %d de %B de %Y")
HORA=$(date +"%H:%M:%S")
USUARIO=$(whoami)
DIRECTORIO=$(pwd)

echo "-> Fecha actual: $FECHA"
echo "-> Hora actual: $HORA"
echo "-> Ejecutado por el usuario: $USUARIO"
echo "-> Directorio de trabajo: $DIRECTORIO"
echo ""

echo "--- Información del Kernel y Procesador (uname) ---"
uname -a
echo ""

echo "--- Estado de la Memoria (free) ---"
free -h
echo ""

echo "--- Ocupación de los Discos (df) ---"
# Mostramos solo las primeras 6 líneas para no saturar la pantalla
df -h | head -6

echo "=================================================="