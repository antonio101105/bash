#!/bin/bash
# Nombre: 02_gestion_usuarios.sh
# Descripción: Busca un usuario en el sistema e imprime sus propiedades.

echo "Introduce el nombre del usuario que deseas consultar:"
read nombre_usuario

# Comprobamos si el usuario existe buscando silenciosamente (-q) en /etc/passwd
if grep -q "^$nombre_usuario:" /etc/passwd; then
    echo ""
    echo "¡El usuario '$nombre_usuario' ha sido encontrado!"
    echo "Extrayendo información..."
    echo "---------------------------------"
    
    # Usamos grep para aislar la línea y cut para separar por columnas (delimitador ':')
    UID_USR=$(grep "^$nombre_usuario:" /etc/passwd | cut -d: -f3)
    GID_USR=$(grep "^$nombre_usuario:" /etc/passwd | cut -d: -f4)
    INFO_USR=$(grep "^$nombre_usuario:" /etc/passwd | cut -d: -f5)
    HOME_USR=$(grep "^$nombre_usuario:" /etc/passwd | cut -d: -f6)
    SHELL_USR=$(grep "^$nombre_usuario:" /etc/passwd | cut -d: -f7)

    echo "- Nombre descriptivo: $INFO_USR"
    echo "- User ID (UID): $UID_USR"
    echo "- Group ID (GID) principal: $GID_USR"
    echo "- Directorio Home: $HOME_USR"
    echo "- Intérprete de comandos (Shell): $SHELL_USR"
    echo "---------------------------------"
else
    echo "Error: El usuario '$nombre_usuario' no existe en este sistema."
fi