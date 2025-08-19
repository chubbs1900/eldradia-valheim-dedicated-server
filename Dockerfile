FROM steamcmd/steamcmd:latest

# Install tiny runtime deps; prep folders; fix permissions
USER root
ENV DEBIAN_FRONTEND=noninteractive \
    VALHEIMDIR=/opt/valheim

RUN apt-get update && apt-get install -y --no-install-recommends \
      dumb-init ca-certificates libsdl2-2.0-0 lib32gcc-s1 \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p ${VALHEIMDIR} /config \
  && chown -R steam:steam ${VALHEIMDIR} /config

# Entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown steam:steam /entrypoint.sh

# Run as the unprivileged 'steam' user
USER steam

EXPOSE 2456/udp 2457/udp 2458/udp
WORKDIR ${VALHEIMDIR}
ENTRYPOINT ["/usr/bin/dumb-init","--"]
CMD ["/entrypoint.sh"]
