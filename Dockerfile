FROM alpine:3.11.6 AS base

RUN apk add --update-cache unzip

ENV VERSION=1411
ENV DL_LINK=https://www.terraria.org/system/dedicated_servers/archives/000/000/041/original/terraria-server-${VERSION}.zip

ADD $DL_LINK /terraria-server.zip

RUN unzip /terraria-server.zip -d /tmp && \
    mkdir /app && \
    mv /tmp/${VERSION}/Linux/* /app && \
    mv /tmp/${VERSION}/Windows/serverconfig.txt /app/serverconfig-default.txt && \
    chmod +x /app/TerrariaServer*

FROM brutalgg/ubuntu-base
ENV HOME=/home/abc

# Uncomment line below to add local apt cache to the container
# COPY apt-cache-proxy /etc/apt/apt.conf.d/00aptproxy

RUN \
# Update and get dependencies
    apt-get update && \
    apt-get install -y \
    screen \
    cron \
    && \
# Cleanup
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf var/tmp/*

EXPOSE 7777/tcp
VOLUME /config

COPY --from=base /app/ /app/
COPY root/ /

WORKDIR /config