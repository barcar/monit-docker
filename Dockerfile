FROM debian:bullseye-slim

# monit environment variables
ENV MONIT_VERSION=5.32.0 \
    MONIT_ARCH=arm64 \
    MONIT_HOME=/opt/monit \
    MONIT_URL=https://mmonit.com/monit/dist/binary \
    PATH=$PATH:/opt/monit/bin

COPY slack /bin/slack
COPY pushover /bin/pushover

# Install monit
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install wget curl docker.io mosquitto-clients python3 -y

# Compile and install monit
RUN \
    wget ${MONIT_URL}/${MONIT_VERSION}/monit-${MONIT_VERSION}-linux-${MONIT_ARCH}.tar.gz && \
    tar zxvf monit-${MONIT_VERSION}-linux-${MONIT_ARCH}.tar.gz && \
    cd monit-${MONIT_VERSION} && \
    cp bin/monit /usr/local/bin/ && \
    cp conf/monitrc /etc/

EXPOSE 2812

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s /usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat
ENTRYPOINT ["/entrypoint.sh"]

CMD ["monit", "-I", "-B", "-c", "/etc/monitrc_root"]
