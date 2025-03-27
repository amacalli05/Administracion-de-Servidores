#!/bin/bash

# Función para validar la contraseña
validar_contrasena() {
    local contrasena="$1"
    local length=${#contrasena}
    local MIN_LENGHT=8
    
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

# Solicitar datos del usuario
echo "Creación de usuario"
read -p "Nombre de usuario: " usuario
read -p "Nombre completo: " nombre
read -p "Ingresa el directorio (/home): " directorio
read -p "Ingresa el tipo de shell que usará el usuario: " shell

# Solicitar y validar contraseña
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

# Crear usuario
useradd -c "$nombre" -d "$directorio" -m -s "$shell" "$usuario"
echo "$usuario:$contrasena" | chpasswd
passwd -e "$usuario"

echo "Usuario $usuario creado exitosamente."

