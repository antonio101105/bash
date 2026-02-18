#!/bin/bash
# Nombre: 05_menu_admin.sh
# Descripción: Menú interactivo continuo para tareas frecuentes de administración.

opcion=0

while [ "$opcion" != "5" ]; do
    clear
    echo "=============================================="
    echo "          MENÚ DEL ADMINISTRADOR              "
    echo "=============================================="
    echo "1) Mostrar procesos en tiempo real (top)"
    echo "2) Ver usuarios conectados al sistema (who / w)"
    echo "3) Buscar un fichero desde la raíz (find)"
    echo "4) Ver historial de comandos de la sesión (history)"
    echo "5) Salir"
    echo "=============================================="
    echo -n "Selecciona una opción [1-5]: "
    read opcion

    case $opcion in
        1)
            echo "Lanzando top... (Pulsa 'q' para salir)"
            sleep 2
            top
            ;;
        2)
            echo "--- Usuarios actualmente conectados ---"
            w
            ;;
        3)
            echo "Introduce el nombre exacto del fichero a buscar:"
            read nombre_fichero
            echo "Buscando... (Se omitirán los errores de permisos)"
            # Redireccionamos los errores estándar (2) a /dev/null para una salida más limpia
            find / -name "$nombre_fichero" 2>/dev/null
            ;;
        4)
            echo "--- Últimos 15 comandos introducidos ---"
            tail -15 ~/.bash_history
            ;;
        5)
            echo "Cerrando el menú. ¡Buen trabajo!"
            ;;
        *)
            echo "Opción inválida. Por favor, selecciona un número del 1 al 5."
            ;;
    esac
    
    # Pausa antes de limpiar la pantalla y volver a mostrar el menú
    if [ "$opcion" != "5" ]; then
        echo ""
        echo "Pulsa [ENTER] para volver al menú principal..."
        read
    fi
done