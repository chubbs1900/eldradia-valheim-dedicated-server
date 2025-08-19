# Smaller, simpler base
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    STEAMCMDDIR=/opt/steamcmd \
    VALHEIMDIR=/opt/valheim

# 32-bit runtime libs + tools
RUN dpkg --add-architecture i386 \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates locales tzdata curl wget net-tools dumb-init tar \
      lib32gcc-s1 libstdc++6 libstdc++6:i386 libsdl2-2.0-0 \
 && rm -rf /var/lib/apt/lists/*

# Install SteamCMD directly from Valve
RUN mkdir -p ${STEAMCMDDIR} ${VALHEIMDIR} /config \
 && curl -sSL https://steamcdn.cloudflare.steamstatic.com/client/installer/steamcmd_linux.tar.gz \
    | tar -xz -C ${STEAMCMDDIR}

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose UDP ports used by Valheim
EXPOSE 2456/udp 2457/udp 2458/udp

WORKDIR ${VALHEIMDIR}
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/entrypoint.sh"]
