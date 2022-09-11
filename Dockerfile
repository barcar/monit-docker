FROM debian:bullseye-slim

# monit environment variables
ENV MONIT_VERSION=5.32.0 \
    MONIT_HOME=/opt/monit \
    MONIT_URL=https://mmonit.com/monit/dist \
    PATH=$PATH:/opt/monit/bin

COPY slack /bin/slack
COPY pushover /bin/pushover

# Install monit
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install monit software-properties-common wget curl docker.io -y

EXPOSE 2812

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s /usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat
ENTRYPOINT ["/entrypoint.sh"]

CMD ["monit", "-I", "-B", "-c", "/etc/monitrc_root"]
