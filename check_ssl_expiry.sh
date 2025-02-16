#!/bin/bash

# Archivo con la lista de sitios web
SITES_LIST="ssl_check_list.txt"

# Correo al que enviar las alertas
EMAIL="correo@dominio.com"

# Umbrales de alerta en días
THRESHOLDS=(60 30 15 7)

# Función para obtener los días restantes del certificado SSL
get_ssl_days_remaining() {
    local site=$1
    curl -vI --insecure "https://$site" 2>&1 | grep "expire date" | awk -F': ' '{print $2}' | xargs -I{} date -d "{}" +%s | awk '{print int(($1 - systime()) / 86400)}'
}

# Comprobar cada sitio en la lista
while read -r site; do
    if [[ -n "$site" ]]; then
        days_remaining=$(get_ssl_days_remaining "$site")

        # Si no se pudo obtener el dato, continuar con el siguiente
        if [[ -z "$days_remaining" || "$days_remaining" -lt 0 ]]; then
            echo "Error obteniendo certificado de $site" | mail -s "[SSL Check] Error en $site" "$EMAIL"
            continue
        fi

        # Comparar con los umbrales y enviar alerta si corresponde
        for threshold in "${THRESHOLDS[@]}"; do

            if [[ "$days_remaining" -eq "$threshold" || "$days_remaining" -lt 7 ]]; then
                echo "El certificado SSL de $site expira en $days_remaining días." | mail -s "[SSL Alert] $site expira en $days_remaining días" "$EMAIL"
                break
            fi
        done
    fi
done < "$SITES_LIST"
