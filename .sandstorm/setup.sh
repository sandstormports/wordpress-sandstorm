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
apt-get install -y nginx sqlite3 php-fpm php-mysql php-sqlite3 php-curl php-gd

exit 0
