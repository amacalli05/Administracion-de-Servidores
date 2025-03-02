#!/bin/bash
archivo=$1
directorio="/home/amacalli/.local/share/Trash/files"
echo "Hola, este script es para borrar un archivo"
mv "$archivo" "$directorio"
echo "Archivo eliminado"
