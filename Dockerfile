FROM steamcmd/steamcmd:latest

# install tiny runtime deps, prep folders, correct ownership
USER root
ENV DEBIAN_FRONTEND=noninteractive VALHEIMDIR=/opt/valheim
RUN apt-get update && apt-get install -y --no-install-recommends \
      dumb-init ca-certificates lib32gcc-s1 libsdl2-2.0-0 \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p ${VALHEIMDIR} /config \
  && chown -R steam:steam ${VALHEIMDIR} /config

# entrypoint
COPY --chown=steam:steam entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# run as 'steam'
USER steam
WORKDIR ${VALHEIMDIR}
EXPOSE 2456/udp 2457/udp 2458/udp
ENTRYPOINT ["/usr/bin/dumb-init","--"]
CMD ["/entrypoint.sh"]
