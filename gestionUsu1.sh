#!/usr/bin/env bash

validar_contrasena() {
    local contrasena="$1"
    local length=${#contrasena}
    local MIN_LENGTH=8
    
    if (( length < MIN_LENGTH )); then
        echo "La contraseña debe tener al menos $MIN_LENGTH caracteres."
        return 1
    fi
    if [[ "$contrasena" != *[A-Z]* ]]; then
        echo "La contraseña debe contener al menos una letra mayúscula."
        return 1
    fi
    if [[ "$contrasena" != *[a-z]* ]]; then
        echo "La contraseña debe contener al menos una letra minúscula."
        return 1
    fi
    if [[ "$contrasena" != *[0-9]* ]]; then
        echo "La contraseña debe contener al menos un número."
        return 1
    fi
    if [[ "$contrasena" != *[!@#\$%\^\&\*]* ]]; then
        echo "La contraseña debe contener al menos un carácter especial (!@#$%^&*)."
        return 1
    fi
    
    return 0
}

crear_cuota() {
	local usuario="$1"
	read -p "Ingresa el 'Soft limit'(en KB): " soft_limit
	read -p "Ingresa el 'Hard limit': " hard_limit
	read -p "Ingresa el 'Soft limit' de inodos: " soft_inodo
	read -p	"Ingresa el 'Hard limit' de inodos: " hard_inodo
	read -p "Ingresa el directorio al que se aplicará la cuota: " dir
	
	particion=$(df --output=source "$dir" | tail -n 1)
    	if [[ -z "$particion" ]]; then
        	echo "Error: No se pudo determinar la partición del directorio."
        	return 1
    	fi

	setquota -u "$usuario" $soft_limit $hard_limit $soft_inodo $hard_inodo $particion
	echo "Se ha creado la cuota para $usuario"
}

echo "Creación de usuario"
read -p "Nombre de usuario: " usuario
read -p "Nombre completo: " nombre
read -p "Ingresa el directorio (/home): " directorio
read -p "Ingresa el tipo de shell que usará el usuario: " shell

while true; do
    read -s -p "Contraseña: " contrasena
    echo
    read -s -p "Confirmar contraseña: " contrasena_confirm
    echo
    
    if [[ "$contrasena" != "$contrasena_confirm" ]]; then
        echo "Las contraseñas no coinciden. Inténtalo de nuevo."
        continue
    fi
    
    validar_contrasena "$contrasena"
    if [[ $? -eq 0 ]]; then
        break
    fi
    echo "Inténtalo de nuevo."
done

useradd -c "$nombre" -d "$directorio" -m -s "$shell" "$usuario"
echo "$usuario:$contrasena" | chpasswd
passwd -e "$usuario"

echo "Usuario $usuario creado exitosamente."

read -p "Quiere que el usuario tenga cuotas: " s_n
if [[ "$s_n" == "Si" || "$s_n" == "si" ]]; then
	crear_cuota "$usuario"
fi
