#!/bin/bash

read -p "Enter domain name: " DOMAIN
read -p "Enter subdomain: " SUBDOMAIN

mkdir -p /var/www/html/${SUBDOMAIN}.${DOMAIN}
chmod 755 /var/www/html/${SUBDOMAIN}.${DOMAIN}
touch /var/www/html/${SUBDOMAIN}.${DOMAIN}/index.html
echo "<h1>This is ${SUBDOMAIN}.${DOMAIN}</h1>" > /var/www/html/${SUBDOMAIN}.${DOMAIN}/index.html

touch /etc/apache2/sites-available/${SUBDOMAIN}.${DOMAIN}.conf

cat > /etc/apache2/sites-available/${SUBDOMAIN}.${DOMAIN}.conf <<EOF
<VirtualHost *>
    ServerAdmin admin@${DOMAIN}
    DocumentRoot /var/www/html/${SUBDOMAIN}.${DOMAIN}
    ServerName ${SUBDOMAIN}.${DOMAIN}

<Directory /var/www/html>
    Require all granted
</Directory>

    ErrorLog ${APACHE_LOG_DIR}/error-logfile.log
    # Possible values include: debug, info, notice, warn, error, crit,
    # alert, emerg.
    LogLevel warn
    CustomLog ${APACHE_LOG_DIR}/access-logfile.log combined

</VirtualHost>

EOF

a2ensite ${SUBDOMAIN}.${DOMAIN}
systemctl reload apache2

