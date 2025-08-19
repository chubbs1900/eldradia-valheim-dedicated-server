#!/bin/bash
set -e

STEAMCMDDIR=/home/steam/steamcmd
VALHEIMDIR=/home/steam/valheim

echo "[entrypoint] Updating Valheim dedicated server via SteamCMD..."
${STEAMCMDDIR}/steamcmd.sh +login anonymous \
    +force_install_dir ${VALHEIMDIR} \
    +app_update 896660 validate \
    +quit

echo "[entrypoint] Starting Valheim server..."
exec ${VALHEIMDIR}/valheim_server.x86_64 \
    -name "${SERVER_NAME}" \
    -port 2456 \
    -world "${WORLD_NAME}" \
    -password "${SERVER_PASS}" \
    -public ${SERVER_PUBLIC:-0}
