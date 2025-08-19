FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    STEAMCMDDIR=/opt/steamcmd \
    VALHEIMDIR=/opt/valheim

# Basic deps + steamcmd (from multiverse) + runtime libs
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates locales tzdata curl wget net-tools dumb-init \
      software-properties-common \
    && dpkg --add-architecture i386 \
    && add-apt-repository multiverse \
    && apt-get update && apt-get install -y --no-install-recommends \
      steamcmd \
      lib32gcc-s1 \
      libstdc++6 \
      libstdc++6:i386 \
      libsdl2-2.0-0 \
    && ln -s /usr/games/steamcmd ${STEAMCMDDIR} \
    && mkdir -p ${VALHEIMDIR} /config \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose UDP for server
EXPOSE 2456/udp 2457/udp 2458/udp

WORKDIR ${VALHEIMDIR}
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/entrypoint.sh"]
