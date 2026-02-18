# 🐧 Proyecto: Scripting Básico en Bash (UNIX/Linux)

Este repositorio contiene una colección de 5 scripts en Bash diseñados para poner en práctica los fundamentos de la administración de sistemas UNIX/Linux. Los scripts abarcan desde la recolección de información del sistema hasta la automatización de copias de seguridad y la creación de menús interactivos.

---

## 🚀 Cómo ejecutar los scripts

Si decides guardar estos scripts en ficheros `.sh` independientes, primero debes darles **permisos de ejecución**. Abre tu terminal, navega hasta la carpeta correspondiente y ejecuta:

```bash
chmod +x *.sh
```

*(El comando `chmod` cambia los permisos de un fichero/directorio. Con `+x` le otorgamos permisos de ejecución a todos los archivos terminados en `.sh`).*

Luego, puedes ejecutar cualquier script llamándolo por su ruta relativa. Por ejemplo:
```bash
./01_info_sistema.sh
```

---

## 📜 Los Scripts del Proyecto

A continuación, se presenta el código de los 5 scripts desarrollados, ordenados por nivel de complejidad.

### 1. Información del Sistema y Variables (`01_info_sistema.sh`)
Genera un reporte básico del estado del sistema, la memoria y los discos.

```bash
#!/bin/bash
# Descripción: Muestra un reporte básico del estado del sistema y del usuario.

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
```

### 2. Gestión de Usuarios y Filtros (`02_gestion_usuarios.sh`)
Busca un usuario en el sistema (`/etc/passwd`) e imprime sus propiedades separando las columnas.

```bash
#!/bin/bash
# Descripción: Busca un usuario en el sistema e imprime sus propiedades.

echo "Introduce el nombre del usuario que deseas consultar:"
read nombre_usuario

if grep -q "^$nombre_usuario:" /etc/passwd; then
    echo ""
    echo "¡El usuario '$nombre_usuario' ha sido encontrado!"
    echo "Extrayendo información..."
    echo "---------------------------------"
    
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
```

### 3. Analizador de Ficheros (`03_analizador_ficheros.sh`)
Recibe parámetros por consola y evalúa si son ficheros, directorios y qué permisos tienen.

```bash
#!/bin/bash
# Descripción: Analiza el tipo y los permisos de los archivos/directorios.

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
```

### 4. Automatización de Copias de Seguridad (`04_backup.sh`)
Crea un directorio de backups y empaqueta/comprime la ruta indicada por el usuario.

```bash
#!/bin/bash
# Descripción: Realiza una copia de seguridad comprimida de un directorio.

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
```

### 5. Menú de Administración Interactivo (`05_menu_admin.sh`)
Menú infinito usando `while` y `case` para lanzar tareas de monitorización.

```bash
#!/bin/bash
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
            echo "--- Usuarios conectados ---"
            w
            ;;
        3)
            echo "Introduce el nombre exacto del fichero a buscar:"
            read nombre_fichero
            echo "Buscando... (Se omitirán los errores de permisos)"
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
            echo "Opción inválida. Selecciona un número del 1 al 5."
            ;;
    esac
    
    if [ "$opcion" != "5" ]; then
        echo ""
        echo "Pulsa [ENTER] para volver al menú principal..."
        read
    fi
done
```

---

## 🔄 Estructuras de Control y Bucles

En este proyecto se aplican los siguientes fundamentos de programación en Bash:

* **`if / then / elif / else / fi`**: Estructura condicional. Evalúa si se cumple una condición (ej. validar si un directorio existe mediante `[ -d directorio ]`).
* **`for ... in ... do ... done`**: Bucle para iterar sobre una lista de elementos. Se usa para procesar múltiples parámetros (`$@`) pasados al ejecutar un script.
* **`while [ condición ] do ... done`**: Bucle que repite un bloque de código **mientras** la condición sea verdadera. Ideal para mantener un menú en pantalla.
* **`case ... in ... esac`**: Condicional múltiple que evalúa el valor de una variable contra varios patrones. Perfecto para gestionar las distintas opciones de un menú interactivo.

---

## 💻 Diccionario de Comandos Utilizados

### 1. Comandos Generales y de Variables
* **`clear`**: Limpia la pantalla.
* **`echo`**: Imprime texto o variables por pantalla.
* **`date`**: Muestra y formatea la fecha/hora del sistema.
* **`read`**: Captura la entrada del usuario y la guarda en una variable.
* **`sleep`**: Pausa la ejecución por un tiempo determinado.

### 2. Información y Monitorización
* **`whoami`**: Muestra el nombre del usuario actual.
* **`who` / `w`**: Lista los usuarios conectados y su actividad.
* **`uname`**: Muestra información del sistema operativo y kernel.
* **`free`**: Reporta la ocupación de la memoria RAM.
* **`top`**: Monitor de procesos y consumo de recursos en tiempo real.

### 3. Ficheros y Directorios
* **`pwd`**: Imprime la ruta del directorio de trabajo actual.
* **`mkdir`**: Crea nuevos directorios.
* **`find`**: Busca archivos y directorios en el sistema de archivos.
* **`head` / `tail`**: Muestran, respectivamente, las primeras o últimas líneas de un archivo.
* **`du`**: Calcula el espacio en disco que ocupa un archivo o directorio.
* **`df`**: Muestra el espacio libre y ocupado de los discos o particiones montadas.

### 4. Filtros de Texto
* **`grep`**: Busca un patrón de texto específico dentro de un archivo o flujo de datos.
* **`cut`**: Recorta partes de las líneas de un archivo de texto (útil para aislar columnas separadas por delimitadores, como en `/etc/passwd`).

### 5. Empaquetado y Compresión
* **`tar`**: Herramienta principal para empaquetar múltiples archivos en uno solo.
* **`gzip`**: Comprime archivos para reducir su tamaño (usado junto a `tar` con la opción `-z`).

---
## 🔄 Estructuras de Repetición (Bucles) en Bash

Los bucles (o ciclos) son estructuras fundamentales en la programación de scripts. Nos permiten ejecutar un bloque de comandos múltiples veces de forma automática, ahorrando tiempo y líneas de código. 

Según el temario, en Bash destacamos dos tipos principales: el bucle `for` y el bucle `while`.



[Image of flowchart of a loop in programming]


---

### 1. El Bucle `for`

El bucle `for` se utiliza principalmente cuando queremos **recorrer una lista de elementos** (como un grupo de archivos, una serie de palabras, o los parámetros pasados a un script) y ejecutar una acción por cada uno de ellos.

**Sintaxis básica:**
```bash
for variable in [ lista de elementos ]
do
    comandos
done
```

**Ejemplo práctico: Recorrer una lista de palabras**
En este ejemplo, el bucle toma cada nombre de la lista, lo guarda temporalmente en la variable `$nombre` y ejecuta el comando `echo`.

```bash
#!/bin/bash

echo "Iniciando el saludo:"

for nombre in Ana Carlos Elena Roberto
do
    echo "¡Hola, $nombre! Bienvenido al sistema."
done

echo "Saludos finalizados."
```

**Ejemplo práctico: Recorrer los parámetros pasados al script (`$@`)**
```bash
#!/bin/bash

# $@ representa todos los argumentos pasados al ejecutar el script
for archivo in $@
do
    echo "Procesando el archivo: $archivo"
    # Aquí podríamos poner comandos como cp, rm, cat, etc.
done
```

---

### 2. El Bucle `while`

El bucle `while` (que significa "mientras") repite un bloque de comandos continuamente **mientras una condición específica se cumpla** (es decir, sea verdadera). En el momento en que la condición deja de cumplirse, el bucle se detiene. Es ideal para crear menús interactivos o procesos que dependen de un estado variable.

**Sintaxis básica:**
```bash
while [ condición ]
do
    comandos
done
```

**Ejemplo práctico: Un contador simple**
En este ejemplo usamos la condición `-le` (menor o igual) y el comando `let` para realizar la operación aritmética y evitar que el bucle sea infinito.

```bash
#!/bin/bash

contador=1

# Mientras el contador sea menor o igual a 3...
while [ $contador -le 3 ]
do
    echo "El contador va por el número: $contador"
    
    # Incrementamos el valor en 1 en cada vuelta
    let contador=$contador+1
done

echo "¡Bucle terminado!"
```

**Ejemplo práctico: Menú interactivo básico**
El bucle se repetirá hasta que el usuario introduzca el número que cambia la condición.

```bash
#!/bin/bash

opcion=0

# Mientras la opción NO sea igual (-ne) a 2...
while [ $opcion -ne 2 ]
do
    echo "1. Saludar"
    echo "2. Salir"
    read -p "Elige una opción: " opcion
    
    if [ $opcion -eq 1 ]; then
        echo "¡Hola! ¿Qué tal?"
    fi
done

echo "Has salido del programa."
```
## 🚦 Estructuras de Control Condicionales en Bash

Las estructuras condicionales permiten que un script tome decisiones. En lugar de ejecutar todas las líneas de código de arriba a abajo, el script evalúa una condición (por ejemplo, el valor de una variable o la existencia de un archivo) y decide qué camino tomar.

En Bash, las dos estructuras condicionales principales son `if` y `case`.

---

### 1. La Estructura `if` / `then` / `elif` / `else` / `fi`

La estructura `if` (que significa "si" condicional) es la forma más directa de evaluar una condición lógica. Se puede usar en su forma más simple (solo `if/then`) o añadirle alternativas (`elif` para otra condición, `else` como acción por defecto si ninguna se cumple).



[Image of if else statement flowchart]


**Sintaxis básica (múltiples condiciones):**
```bash
if [ condición1 ]
then
    # comandos si la condición1 se cumple
elif [ condición2 ]
then
    # comandos si la condición2 se cumple
else
    # comandos si NO se cumple ni la condición1 ni la condición2
fi
```
*Nota: Es imprescindible cerrar la estructura con `fi` (if al revés).*

**Ejemplo práctico: Evaluación de números**
En este ejemplo utilizamos los operadores lógicos para enteros (`-gt` para mayor que, `-lt` para menor que, `-eq` para igual).

```bash
#!/bin/bash

echo "Introduce un número:"
read numero

if [ "$numero" -gt 10 ]
then
    echo "El número introducido es MAYOR que 10."
elif [ "$numero" -eq 10 ]
then
    echo "El número introducido es EXACTAMENTE 10."
else
    echo "El número introducido es MENOR que 10."
fi

echo "Evaluación finalizada."
```

**Ejemplo práctico: Comprobación de archivos**
Muy útil en administración de sistemas para verificar estados antes de actuar, usando los operadores de archivos (`-f` para archivo ordinario, `-d` para directorio).

```bash
#!/bin/bash

archivo="/etc/passwd"

# Si el archivo existe y es un fichero ordinario (-f)
if [ -f "$archivo" ]
then
    echo "El archivo $archivo existe."
    
    # Podemos anidar ifs. Si existe, comprobamos si tenemos permiso de lectura (-r)
    if [ -r "$archivo" ]
    then
        echo "Y tienes permisos para leerlo."
    else
        echo "Pero NO tienes permisos para leerlo."
    fi
else
    echo "El archivo $archivo no se encuentra."
fi
```

---

### 2. La Estructura `case`

La estructura `case` (que significa "en caso de") es una alternativa mucho más limpia y legible que anidar múltiples `elif` cuando queremos evaluar **el valor de una única variable frente a múltiples opciones específicas**. Es la estructura ideal para construir menús interactivos.



**Sintaxis básica:**
```bash
case $variable in
    patrón1)
        comandos ;;
    patrón2)
        comandos ;;
    *)
        comandos por defecto ;;
esac
```
*Notas importantes:*
* Cada bloque de opciones se cierra con doble punto y coma `;;`.
* El asterisco `*)` actúa como un "comodín" que atrapa cualquier valor que no coincida con los patrones anteriores (similar al `else`).
* La estructura se cierra con `esac` (case al revés).

**Ejemplo práctico: Un menú de opciones**
El usuario introduce un valor, y el `case` decide qué comando ejecutar en función de esa entrada.

```bash
#!/bin/bash

echo "=== MENÚ PRINCIPAL ==="
echo "A) Ver la fecha y hora"
echo "B) Ver el directorio actual"
echo "C) Salir"
echo "======================"
read -p "Elige una opción (A/B/C): " opcion

case $opcion in
    "A" | "a") # Podemos usar el pipe (|) para evaluar múltiples patrones (mayúsculas o minúsculas)
        echo "La fecha es:"
        date
        ;;
    "B" | "b")
        echo "Estás en el directorio:"
        pwd
        ;;
    "C" | "c")
        echo "Saliendo del programa..."
        exit 0
        ;;
    *)
        echo "Error: Opción incorrecta. Debes elegir A, B o C."
        ;;
esac
```