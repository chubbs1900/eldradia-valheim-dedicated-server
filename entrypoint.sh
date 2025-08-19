#!/usr/bin/env bash
set -euo pipefail

# Env defaults
TZ="${TZ:-UTC}"
SERVER_NAME="${SERVER_NAME:-My Valheim Server}"
WORLD_NAME="${WORLD_NAME:-Dedicated}"
SERVER_PASS="${SERVER_PASS:-changeme}"
SERVER_PUBLIC="${SERVER_PUBLIC:-0}"   # 0 = private, 1 = public
SERVER_PORT="${SERVER_PORT:-2456}"

export TZ

STEAMCMDDIR="/home/steam/steamcmd"
VALHEIMDIR="/opt/valheim"
CONFIGDIR="/config"
SAVEDIR="${CONFIGDIR}/saves"
WORLDSDIR="${SAVEDIR}/worlds_local"

mkdir -p "${WORLDSDIR}" "${CONFIGDIR}/backups"

echo "[entrypoint] Updating Valheim dedicated server via SteamCMD..."
"${STEAMCMDDIR}/steamcmd.sh" +login anonymous \
  +force_install_dir "${VALHEIMDIR}" \
  +app_update 896660 validate \
  +quit

SERVER_BIN="${VALHEIMDIR}/valheim_server.x86_64"
if [ ! -x "${SERVER_BIN}" ]; then
  echo "[entrypoint] ERROR: server binary not found at ${SERVER_BIN}"
  ls -lah "${VALHEIMDIR}" || true
  exit 1
fi

echo "[entrypoint] Starting server '${SERVER_NAME}' world='${WORLD_NAME}' port=${SERVER_PORT} public=${SERVER_PUBLIC}"
cd "${VALHEIMDIR}"

exec "${SERVER_BIN}" \
  -name "${SERVER_NAME}" \
  -port "${SERVER_PORT}" \
  -world "${WORLD_NAME}" \
  -password "${SERVER_PASS}" \
  -public "${SERVER_PUBLIC}" \
  -savedir "${SAVEDIR}"
