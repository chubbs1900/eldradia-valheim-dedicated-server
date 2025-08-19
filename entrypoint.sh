#!/usr/bin/env sh
set -eu

# Defaults
: "${TZ:=UTC}"
: "${SERVER_NAME:=My Valheim Server}"
: "${WORLD_NAME:=Dedicated}"
: "${SERVER_PASS:=changeme}"
: "${SERVER_PUBLIC:=0}"
: "${SERVER_PORT:=2456}"

VALHEIMDIR="/opt/valheim"
CONFIGDIR="/config"
SAVEDIR="${CONFIGDIR}/saves"
WORLDSDIR="${SAVEDIR}/worlds_local"

mkdir -p "${WORLDSDIR}" "${CONFIGDIR}/backups" "${VALHEIMDIR}"

# Find steamcmd on PATH (provided by base image)
if command -v steamcmd >/dev/null 2>&1; then
  STEAMCMD_BIN="$(command -v steamcmd)"
else
  echo "[entrypoint] ERROR: steamcmd not found on PATH."
  exit 1
fi

echo "[entrypoint] Using steamcmd at: ${STEAMCMD_BIN}"
echo "[entrypoint] Updating Valheim dedicated server via SteamCMD..."
"${STEAMCMD_BIN}" +login anonymous \
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
