#!/usr/bin/env bash
set -euo pipefail

# -------- env defaults --------
TZ="${TZ:-UTC}"
SERVER_NAME="${SERVER_NAME:-My Valheim Server}"
WORLD_NAME="${WORLD_NAME:-Dedicated}"
SERVER_PASS="${SERVER_PASS:-changeme}"
SERVER_PUBLIC="${SERVER_PUBLIC:-0}"   # 0=private, 1=public
SERVER_PORT="${SERVER_PORT:-2456}"
export TZ

VALHEIMDIR="/opt/valheim"
CONFIGDIR="/config"
SAVEDIR="${CONFIGDIR}/saves"
WORLDSDIR="${SAVEDIR}/worlds_local"

mkdir -p "${WORLDSDIR}" "${CONFIGDIR}/backups" "${VALHEIMDIR}"

# -------- find steamcmd (prefer PATH; fallbacks included) --------
STEAMCMD_BIN="$(command -v steamcmd || true)"
if [ -z "${STEAMCMD_BIN}" ]; then
  for p in \
    "/home/steam/steamcmd/steamcmd.sh" \
    "/steamcmd/steamcmd.sh" \
    "/usr/games/steamcmd" \
    "/usr/bin/steamcmd" ; do
    [ -x "$p" ] && STEAMCMD_BIN="$p" && break
  done
fi

if [ -z "${STEAMCMD_BIN}" ]; then
  echo "[entrypoint] ERROR: steamcmd not found. Checked common paths and PATH."
  ls -lah /home/steam || true
  ls -lah /home/steam/steamcmd || true
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
