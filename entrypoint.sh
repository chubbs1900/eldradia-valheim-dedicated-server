#!/usr/bin/env bash
set -euo pipefail

# -------- env with sane defaults --------
TZ="${TZ:-UTC}"
SERVER_NAME="${SERVER_NAME:-My Valheim Server}"
WORLD_NAME="${WORLD_NAME:-Dedicated}"
SERVER_PASS="${SERVER_PASS:-changeme}"
SERVER_PUBLIC="${SERVER_PUBLIC:-0}"      # 0 = private list
SERVER_PORT="${SERVER_PORT:-2456}"

export TZ

VALHEIMDIR="/opt/valheim"
CONFIGDIR="/config"
SAVEDIR="${CONFIGDIR}/saves"
WORLDSDIR="${SAVEDIR}/worlds_local"

mkdir -p "${WORLDSDIR}" "${CONFIGDIR}/backups" "${VALHEIMDIR}"

# -------- robust steamcmd finder --------
find_steamcmd() {
  for p in \
    "/home/steam/steamcmd/steamcmd.sh" \
    "/steamcmd/steamcmd.sh" \
    "/usr/games/steamcmd" \
    "/usr/bin/steamcmd" \
    "/bin/steamcmd"
  do
    if [ -x "$p" ]; then
      echo "$p"
      return 0
    fi
  done
  if command -v steamcmd >/dev/null 2>&1; then
    command -v steamcmd
    return 0
  fi
  return 1
}

STEAMCMD_BIN="$(find_steamcmd || true)"
if [ -z "${STEAMCMD_BIN}" ]; then
  echo "[entrypoint] ERROR: steamcmd not found. Listing likely dirs..."
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
  echo "[entrypoint] Contents of ${VALHEIMDIR}:"
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
