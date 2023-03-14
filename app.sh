#!/bin/bash

#Funcion que muestra el menu para las metodologias agiles
metodologiasAgiles () {
    echo "Bienvenido a la guia rapida de Agile, para continuar seleccione un tema: "
    echo "1. SCRUM"
    echo "2. X.P"
    echo "3. Kanban"
    echo "4. Crystal"
}

#Funcion que muestra el menu para las metodologias tradicionales
metodologiasTradicionales () {
    echo "Bienvenido a la guia rapida de metodologias tradicionales, para continuar seleccione un tema: "
    echo "1. Cascada"
    echo "2. Espiral"
    echo "3. Modelo V"
}

#Funcion con el menu de secciones
menuSeccion () {
    echo "Usted esta en la seccion $1"
    echo "1. Agregar informacion"
    echo "2. Buscar"
    echo "3. Eliminar informacion"
    echo "4. Leer base de informacion"
    read -p "Ingrese el numero de opcion que desea realizar: " opcion

    if [[ opcion -eq 1 || opcion -eq 2 || opcion -eq 3 || opcion -eq 4 ]]; then
        return $opcion
    else
        echo "La opcion que eligio no existe"
    fi
}

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

#Si esta funcion recibe un -a entonces manda a llamar a la funcion de metodologiasAgiles, luego pregunta el nombre de la seccion
#a la que quiere ingresar, llama a la funcion del menuSeccion en la cual se encuentran las opciones para hacer;
#luego se ejecuta una funcion llamada redireccionar en la cual se pregunta cual es el siguiente paso que quiere realizar.
#En cambio si recibe un -t hace lo mismo per ahora con la funcion de metodologias tradicionales, en caso de que no reciba ninguno
#de los dos parametros anteriores muestra un mensaje de error
menuMetodologias () {
    if [[ $1 == "-a" ]]; then
        metodologiasAgiles
        read -p "Ingrese el nombre de la seccion a la que quiere ingresar: " nombreSeccion
        if [[ $nombreSeccion == "SCRUM" || $nombreSeccion == "X.P" || $nombreSeccion == "Kanban" || $nombreSeccion == "Crystal" ]]; then
            menuSeccion $nombreSeccion
            lanzarOpciones $? $nombreSeccion
            redireccionar $nombreSeccion $metodologia
        else
            echo "La opcion que ingreso no existe"
        fi
    elif [[ $1 == "-t" ]]; then
        metodologiasTradicionales
        read -p "Ingrese el nombre de la seccion a la que quiere ingresar: " nombreSeccion
        if [[ $nombreSeccion == "Cascada" || $nombreSeccion == "Espiral" || $nombreSeccion == "Modelo V" ]]; then
            menuSeccion $nombreSeccion
            lanzarOpciones $? $nombreSeccion
        else
            echo "La opcion que ingreso no existe"
        fi
    else
        echo "La seccion a la que quiere ingresar no existe"
        exit 1
    fi
}

#Esta funcion usa dos parametros, el primero es un entero que manda el flujo del programa segun la opcion que se elijio en la
#funcion de menuSeccion, el segundo parametro es el nombre de la seccion el cual se usa para hacer operaciones en el archivo
#de la metodologia que se elijio, en caso de que el primer parametro no caiga dentro de las opciones se muestra en mensaje de
#error
lanzarOpciones () {
    if [[ $1 -eq 1 ]]; then
        agregarInformacion $2
    elif [[ $1 -eq 2 ]]; then
        buscar $2
    elif [[ $1 -eq 3 ]]; then
        eliminarInformacion $2
    elif [[ $1 -eq 4 ]]; then
        leerInformacion $2
    else
        echo "La opcion que ingreso no es valida"
    fi
}

#Esta funcion se usa para saber que proceso se hara despues de ejecutar una accion, primero pregunta el numero de opcion que se
#desea realizar, en caso de que sea la 1 se manda a llamar a menuSeccion, luego menuSeccion retorna su numero de opcion a la
#funcion llamada lanzarOpciones la cual ejecuta el proceso que se escoja, si se elige el dos se llama de nuevo a
#menuMetodologias y se se escoje el tres se sale del bucle, lo que termina la ejecucion del programa
redireccionar () {
    redir=1

    while [[ redir -ge 1 && redir -le 3 ]]; do
        echo "¿Que desea hacer ahora?"
        echo "1. Realizar otra opcion"
        echo "2. Regresar al menu anterior"
        echo "3. Terminar la ejecucion"
        read -p "Ingrese el numero de la opcion que desea realizar: " redir

        if [[ redir -eq 1 ]]; then
            menuSeccion $1
            lanzarOpciones $? $1
        elif [[ redir -eq 2 ]]; then
            menuMetodologias $2
        elif [[ redir -eq 3 ]]; then
            echo "Vuelva pronto :)"
            break
        else
            echo "La opcion que ingreso no existe"
            break
        fi
    done
}

#Funcion principal
makeFiles

metodologia=$1

menuMetodologias $metodologia