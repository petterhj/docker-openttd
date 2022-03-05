FROM ubuntu:20.04

# https://cdn.openttd.org/openttd-releases/
# https://cdn.openttd.org/opengfx-releases/

ARG OPENTTD_VERSION="12.1"
ARG OPENGFX_VERSION="7.1"
ARG UBUNTU_CODENAME="focal"

ENV PUID=1000
ENV PGID=1000

ADD install.sh /tmp/install.sh
ADD cleanup.sh /tmp/cleanup.sh
ADD --chown=1000:1000 openttd.sh /openttd.sh
RUN chmod +x /tmp/install.sh /tmp/cleanup.sh /openttd.sh
RUN /tmp/install.sh && /tmp/cleanup.sh

VOLUME /home/openttd/.openttd

EXPOSE 3979/tcp
EXPOSE 3979/udp

STOPSIGNAL 3
ENTRYPOINT [ "/usr/bin/dumb-init", "--rewrite", "15:3", "--rewrite", "9:3", "--" ]
CMD [ "/openttd.sh" ]