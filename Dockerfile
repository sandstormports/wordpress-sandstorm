# # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Content: Dockerfile for WordPress on Sandstorm
# Author: Jan Jambor, XWare GmbH
# Author URI: https://xwr.ch
# Project URI: https://github.com/sandstormports/wordpress
# Date: 08.02.2019
#
# # # # # # # # # # # # # # # # # # # # # # # # # # #

FROM xwrch/sandstorm-docker-base-image:latest
ENV DEBIAN_FRONTEND noninteractive

# add app files to container
RUN mkdir /opt/app
RUN mkdir /opt/wordpress_repo
ADD . /opt/app

# run basic setup
RUN chmod +x /opt/app/.sandstorm/setup.sh
RUN /opt/app/.sandstorm/setup.sh

# build the app
RUN chmod +x /opt/app/.sandstorm/build.sh
RUN /opt/app/.sandstorm/build.sh
