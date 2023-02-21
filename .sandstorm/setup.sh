#!/bin/bash

# When you change this file, you must take manual action. Read this doc:
# - https://docs.sandstorm.io/en/latest/vagrant-spk/customizing/#setupsh

set -euo pipefail
# This is the ideal place to do things like:
#
export DEBIAN_FRONTEND=noninteractive

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
       --expression='s/^listen = \/run\/php\/php7.3-fpm.sock/listen = \/var\/run\/php\/php7.3-fpm.sock/' \
       /etc/php/7.3/fpm/pool.d/www.conf
# patch /etc/php/7.3/fpm/pool.d/www.conf to no clear environment variables
# so we can pass in SANDSTORM=1 to apps
sed --in-place='' \
        --expression='s/^;clear_env = no/clear_env=no/' \
        /etc/php/7.3/fpm/pool.d/www.conf

# The version of golang in the debian repositories tends to be incredibly
# out of date; let's get ourselves a newer version from upstream:
if [ -e /opt/app/.sandstorm/go-version ]; then
    # Get the same version we've used before
    curl -L "https://go.dev/dl/$(cat '/opt/app/.sandstorm/go-version').linux-amd64.tar.gz" -o go.tar.gz
else
    # Get the newest version for a new project
    curl -L "https://go.dev/dl/$(curl 'https://go.dev/VERSION?m=text').linux-amd64.tar.gz" -o go.tar.gz
fi
tar -C /usr/local -xzf go.tar.gz
rm go.tar.gz
echo 'export PATH=/usr/local/go/bin:$PATH' > /etc/profile.d/go.sh

# Get the same version next time
/usr/local/go/bin/go version | cut -d ' ' -f 3 > /opt/app/.sandstorm/go-version

cd /opt && git clone https://github.com/zenhack/powerbox-http-proxy
cd /opt/powerbox-http-proxy && /usr/local/go/bin/go build

exit 0
