# Base that already includes SteamCMD
FROM steamcmd/steamcmd:latest

USER root
ENV DEBIAN_FRONTEND=noninteractive \
    STEAMCMDDIR=/home/steam/steamcmd \
    VALHEIMDIR=/opt/valheim
# ...rest unchanged...

# Minimal runtime deps
RUN apt-get update && apt-get install -y --no-install-recommends \
      dumb-init ca-certificates libsdl2-2.0-0 lib32gcc-s1 \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p ${VALHEIMDIR} /config

# Entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 2456/udp 2457/udp 2458/udp
WORKDIR ${VALHEIMDIR}
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/entrypoint.sh"]
