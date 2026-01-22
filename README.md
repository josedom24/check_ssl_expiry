# check_ssl_expiry

Script Bash que comprueba los días restantes de los certificados de las páginas web listadas en un archivo y envía un correo si faltan 60, 30, 15 o menos de 7 días para su expiración. Se suponemos que tenemos instalado un servidor de correos en el servidor donde se ejecuta.

Utilización:

1. Guarda las URLs en el archivo `ssl_check_list.txt`.
2. Modifica el script para indicar tu correo electrónnico en la variable `EMAIL`.
3. Configura el script en el cron para que se ejecute automáticamente.

Configuración:

```
sudo cp check_ssl_expiry.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/check_ssl_expiry.sh
sudo crontab -e
```

Ejemplo de configuración cron:

```
0 8 * * * /usr/local/bin/check_ssl_expiry.sh
```

Cómo funciona?

* Usa `curl` para obtener la fecha de expiración del certificado SSL.
* Calcula los días restantes.
* Si faltan exactamente 60, 30, 15 o menos de 7 días, envía un correo de alerta.
* Si hay un error al obtener la fecha, también se envía un aviso.

