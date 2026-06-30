#!/bin/bash
# Descripción: Muestra un reporte básico del estado del sistema y del usuario.
# Autor: Antonio Manuel Núñez Campallo
clear
echo "=================================================="
echo "         REPORTE DE ESTADO DEL SISTEMA            "
echo "=================================================="

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
df -h | head -6

echo "=================================================="
