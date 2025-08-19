FROM steamcmd/steamcmd:latest

# We need root only to install a couple tiny deps, then run as 'steam'
USER root
ENV DEBIAN_FRONTEND=noninteractive \
    VALHEIMDIR=/opt/valheim

RUN apt-get update && apt-get install -y --no-install-recommends \
      dumb-init ca-certificates libsdl2-2.0-0 lib32gcc-s1 \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p ${VALHEIMDIR} /config \
  && chown -R steam:steam ${VALHEIMDIR} /config

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown steam:steam /entrypoint.sh

# Switch back to the steam user for runtime
USER steam

EXPOSE 2456/udp 2457/udp 2458/udp
WORKDIR ${VALHEIMDIR}
ENTRYPOINT ["/usr/bin/dumb-init","--"]
CMD ["/entrypoint.sh"]
