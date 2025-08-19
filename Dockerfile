FROM debian:bullseye-slim

ENV STEAMCMDDIR=/home/steam/steamcmd \
    VALHEIMDIR=/home/steam/valheim \
    PUID=1000 \
    PGID=1000

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates locales tzdata curl wget net-tools dumb-init \
    lib32gcc-s1 libstdc++6 libsdl2-2.0-0 \
 && rm -rf /var/lib/apt/lists/*

# Create steam user and directories
RUN useradd -m steam && mkdir -p ${STEAMCMDDIR} ${VALHEIMDIR} /config \
 && chown -R steam:steam /home/steam /config

# Install SteamCMD
USER steam
WORKDIR ${STEAMCMDDIR}
RUN curl -sSL https://steamcdn.cloudflare.steamstatic.com/client/installer/steamcmd_linux.tar.gz \
 | tar -xz

COPY --chown=steam:steam entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR ${VALHEIMDIR}
ENTRYPOINT ["/entrypoint.sh"]
