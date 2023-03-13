#!/bin/bash
#Se agrega el menu de metodologias
function menu_metodologias() {
  if [ "$1" == "-a" ]; then
    echo "Bienvenido a la guía rápida de Agile, para continuar seleccione un tema:"
    pregunta="Seleccione una opción: "
    opciones=("SCRUM" "X.P." "Kanban" "Crystal")
    select opt in "${opciones[@]}"
    do
      case $opt in
        "SCRUM")
          echo "Ha seleccionado SCRUM"
          ;;
        "X.P.")
          echo "Ha seleccionado X.P."
          ;;
        "Kanban")
          echo "Ha seleccionado Kanban"
          ;;
        "Crystal")
          echo "Ha seleccionado Crystal"
          ;;
        *) echo "Opción inválida $REPLY";;
      esac
    done
  elif [ "$1" == "-t" ]; then
    echo "Bienvenido a la guía rápida de metodologías tradicionales, para continuar seleccione un tema:"
    pregunta="Seleccione una opción: "
    opciones=("Cascada" "Espiral" "Modelo V")
    select opt in "${opciones[@]}"
    do
      case $opt in
        "Cascada")
          echo "Ha seleccionado Cascada"
          ;;
        "Espiral")
          echo "Ha seleccionado Espiral"
          ;;
        "Modelo V")
          echo "Ha seleccionado Modelo V"
          ;;
        *) echo "Opción inválida $REPLY";;
      esac
    done
  else
    echo "Debe especificar una opción válida: -a para metodologías ágiles, -t para metodologías tradicionales."
    exit 1
  fi
}

menu_metodologias "$@"

#Funcion para agregar informacion a un archivo, primero se usa la funcion de buscar para verificar que la llave que se quiere
#ingresar no existe en el archivo, si esta ya existe no te dejara insertarla, en el caso contrario usa el operador de entrada
#">>" para insertar el par llave valor
agregarInformacion () {
    read -p "Ingrese el identificador del concepto: " identificador

    buscar $identificador $1

    if [[ $? -eq 1 ]]; then
        echo "Este concepto ya existe en el archivo, intente con uno diferente"
    else
        read -p "Ingrese el concepto que desea asociar al identificador: " concepto

        #Se guardan los valores de llave-valor en el formato indicado
        valor="[$identificador].- $concepto"

        #Se usa >> para insertar valor dentro del archivo que se indico, se usa -e para usar las secuencias
        #de escape y asi dejar un espacio
        insertar=`echo -e $valor >> ~/INF/$1.inf`

        echo $insertar
    fi
}

#Esta funcion se usa para buscar informacion dentro de un archivo, esta usa el comando "grep" para comprobar que dicha 
#expresion regular existe en el archivo, si es asi retorna un 1 pero si no se encuentra se regresa un 0
buscar () {
    read -p "Ingrese el identificador que desea buscar: " identificador

    buscarIdentificador=`grep $identificador ~/INF/$1.inf`

    if [[ $buscarIdentificador ]]; then
        return 1
        #echo `cat $nombreSeleccion.inf | grep $identificador`
    else
        return 0
        #echo "Este identificador no existe en el archivo"
    fi
}

#Esta funcion se usa para eliminar informacion de un archivo, primero se pide el identificador, luego se llama a la funcion
#buscar para comprobar que el concepto que se quiere eliminar existe, si la funcion buscar retorna un 1 se ejecuta el comando
#guardado dentro de "eliminarIdentificador" y si se retorna un 0 se despliega un mensaje de error
eliminarInformacion () {
    read -p "Ingrese el identificador del concepto que desea eliminar: " identificador

    buscar $identificador $1
    eliminarIdentificador=`sed -i "/$identificador/d" ~/INF/$1.inf`

    if [[ $? -eq 1 ]]; then
        echo $eliminarIdentificador
    else
        echo "El concepto que quiere eliminar no existe en el archivo"
    fi
}

#Esta funcion hace un cat del archivo que le indiquemos
leerInformacion () {
    leer=`cat ~/INF/$1.inf`
    echo $leer
}

#Esta funcion crea un directorio INF en la ruta principal de tu usuario y despues crea un archivo con extension .inf por
#cada una de las metodologias
makeFiles () {
    if [[ -d ~/INF/ ]]; then
        echo "El directiorio ya existe, no se creara uno nuevo"
    else
        makeDirectory=`mkdir ~/INF/`

        echo $makeDirectory

        metodologias=("SCRUM" "X.P" "Kanban" "Crystal" "Cascada" "Espiral" "Modelo V")

        for name in ${metodologias[@]}; do
            echo `touch ~/INF/$name.inf`
        done
    fi
}

#Funcion submenú
submenu () {

seccion="nombre de la sección"

#Imprime la bienvenida y despliega el menú
echo "Usted está en la sección $seccion, seleccione la op>

echo "1. Agregar información"
echo "2. Buscar"
echo "3. Eliminar información"
echo "4. Leer base de información."

#Lee la opción seleccionada
read opcion

#se ejecuta la opción seleccionada
case $opcion in
    1)
        echo "Seleccionó la opción Agregar información"
        ;;
    2)
        echo "Seleccionó la opción Buscar"
        ;;
    3)
        echo "Seleccionó la opción Eliminar información"
        ;;
    4)
        echo "Seleccionó la opción Leer base de información"
        ;;
	*)
        echo "[!]Opción inválida intentelo de nuevo"
        ;;
esac

}

#submenu
