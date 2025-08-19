# Valheim Dedicated Server — Eldradia (Docker)

- Minimal Ubuntu + SteamCMD
- Downloads/updates the server on **container start** (no game files baked in)
- **All data lives in one host folder** (`/config`)

## Quick start (Docker Desktop on Windows)
1. Create `C:\Valheim` (or your preferred folder).
2. Edit `.env` with your server name/world/pass.
3. Build once or pull from your registry (see “Build & Publish”).
4. `docker compose up -d`
5. Open UDP ports `2456-2458` on your firewall/router as needed.

## Volumes
- `/config` → persistent saves & backups (`C:\Valheim` on Windows example)

## Environment
- `SERVER_NAME` (string)
- `WORLD_NAME` (string)
- `SERVER_PASS` (>=5 chars)
- `SERVER_PUBLIC` (0/1)
- `SERVER_PORT` (default 2456)
- `TZ` (IANA timezone)

## Upgrading
- Recreate the container (or restart). EntryPoint runs SteamCMD update each start.
