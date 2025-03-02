#!/bin/bash
archivorec=$1
directorio=$2
echo "Este script es para recuperar un archivo que ha sido borrado"
mv "$archivorec" "$directorio" 
echo "Archivo recuperado"
