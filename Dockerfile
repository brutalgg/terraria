FROM debian:10
ENV DEBIAN_FRONTEND="noninteractive"
ENV TERM="xterm"
ENV HOME=/home/abc

ADD ["https://github.com/just-containers/s6-overlay/releases/download/v1.17.2.0/s6-overlay-amd64.tar.gz", "/tmp"]

ENTRYPOINT ["/init"]

RUN \
# Extract S6 overlay
    tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && \
# Update and get dependencies
    apt-get update && \
    apt-get install -y \
    screen \
    && \
# Add user
    useradd -U -d ${HOME} -s /bin/false abc && \
    usermod -G users abc && \
# Setup directories
    mkdir -p \
      /data \
    && \
# Cleanup
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf var/tmp/*

EXPOSE 7777/tcp
VOLUME /config

COPY root/ /
