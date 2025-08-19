FROM steamcmd/steamcmd:latest

# Keep it minimal: no apt-get, no extra packages
USER root
ENV VALHEIMDIR=/opt/valheim
RUN mkdir -p ${VALHEIMDIR} /config && chown -R steam:steam ${VALHEIMDIR} /config

# Entrypoint
COPY --chown=steam:steam entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Run as unprivileged user
USER steam
WORKDIR ${VALHEIMDIR}
# Use /bin/sh to avoid needing dumb-init
ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
