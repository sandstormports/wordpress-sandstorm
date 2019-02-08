#!/bin/bash

# When you change this file, you must take manual action. Read this doc:
# - https://docs.sandstorm.io/en/latest/vagrant-spk/customizing/#setupsh

set -euo pipefail
# This is the ideal place to do things like:
#
export DEBIAN_FRONTEND=noninteractive

# switch to debian testing
cat <<EOF > /etc/apt/sources.list
#------------------------------------------------------------------------------#
#                   OFFICIAL DEBIAN REPOS
#------------------------------------------------------------------------------#

###### Debian Main Repos
deb http://deb.debian.org/debian/ testing main contrib non-free
deb-src http://deb.debian.org/debian/ testing main contrib non-free

deb http://deb.debian.org/debian/ testing-updates main contrib non-free
deb-src http://deb.debian.org/debian/ testing-updates main contrib non-free

deb http://deb.debian.org/debian-security testing/updates main
deb-src http://deb.debian.org/debian-security testing/updates main
EOF

apt-get update
apt-get install -y git g++ automake libtool pkg-config
apt-get install -y nginx php-fpm php-sqlite3 php-cli php-curl git php-dev php-gd sqlite3
service nginx stop
service php7.3-fpm stop

# temporary uncommeted, maybe it will stay this way ...
#systemctl disable nginx
#systemctl disable php7.3-fpm

# patch /etc/php/7.3/fpm/pool.d/www.conf to not change uid/gid to www-data
sed --in-place='' \
        --expression='s/^listen.owner = www-data/;listen.owner = www-data/' \
        --expression='s/^listen.group = www-data/;listen.group = www-data/' \
        --expression='s/^user = www-data/;user = www-data/' \
        --expression='s/^group = www-data/;group = www-data/' \
        /etc/php/7.3/fpm/pool.d/www.conf
# patch /etc/php/7.3/fpm/php-fpm.conf to not have a pidfile
sed --in-place='' \
        --expression='s/^pid =/;pid =/' \
        /etc/php/7.3/fpm/php-fpm.conf
# patch /etc/php/7.3/fpm/php-fpm.conf to place the sock file in /var
sed --in-place='' \
       --expression='s/^listen = \/run\/php\/php7.2-fpm.sock/listen = \/var\/run\/php\/php7.2-fpm.sock/' \
       /etc/php/7.3/fpm/pool.d/www.conf
# patch /etc/php/7.3/fpm/pool.d/www.conf to no clear environment variables
# so we can pass in SANDSTORM=1 to apps
sed --in-place='' \
        --expression='s/^;clear_env = no/clear_env=no/' \
        /etc/php/7.3/fpm/pool.d/www.conf

exit 0
