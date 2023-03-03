#! /bin/sh

cp -r /wordpress-read-only/wp-content-read-only/* /var/wordpress/wp-content

wait_for() {
    local service=$1
    local file=$2
    while [ ! -e "$file" ] ; do
        echo "waiting for $service to be available at $file."
        sleep .1
    done
}

mkdir -p /var/certificates

# Start our powerbox proxy server, and wait for it to write the cert:
export DB_TYPE=sqlite3
export DB_URI=/var/powerboxproxy.sqlite
export CA_CERT_PATH=/var/certificates/ca-bundle.crt
touch $DB_URI
rm -f $CA_CERT_PATH
/opt/powerbox-http-proxy/powerbox-http-proxy &
wait_for "root cert" "$CA_CERT_PATH"

export http_proxy=http://127.0.0.1:$POWERBOX_PROXY_PORT
export https_proxy=http://127.0.0.1:$POWERBOX_PROXY_PORT

/usr/sbin/php-fpm7.3 --fpm-config /etc/php/7.3/fpm/php-fpm.conf -c /etc/php/7.3/fpm/php.ini
echo "started php-fpm. status code:" $?

CGICONF=/var/fastcgi.conf
rm -f $CGICONF;
fastcgi_param () {
  echo "fastcgi_param $1 `base64 /dev/urandom | head -c 60`;" >> $CGICONF
}

fastcgi_param WORDPRESS_AUTH_KEY;
fastcgi_param WORDPRESS_SECURE_AUTH_KEY;
fastcgi_param WORDPRESS_LOGGED_IN_KEY;
fastcgi_param WORDPRESS_NONCE_KEY;
fastcgi_param WORDPRESS_AUTH_SALT;
fastcgi_param WORDPRESS_SECURE_AUTH_SALT;
fastcgi_param WORDPRESS_LOGGED_IN_SALT;
fastcgi_param WORDPRESS_NONCE_SALT;

/usr/sbin/nginx -g "pid /var/run/nginx.pid;"
echo "started nginx. status code:" $?

sleep infinity
