# Abiotic Factor Kubernetes / Docker

## Project Overview
This project provides a Dockerized setup for running an **Abiotic Factor Dedicated Server**. It utilizes a multi-stage `Dockerfile` to download the game server files via SteamCMD and run them in a Debian environment with Wine (since the server is a Windows executable).

While the repository name suggests Kubernetes, the core component is a generic Docker image that can be deployed on any container runtime.

## Key Components

- **`Dockerfile`**: Defines the build process.
    - **Stage 1 (Builder):** Uses `steamcmd/steamcmd` to download the server files via `app_update` (anonymous login).
    - **Stage 2 (Runtime):** Uses `debian:bullseye` with Wine installed to execute the server.
- **`docs/manifest-id.md`**: a guide on how to find the required Steam IDs (only needed if you want to modify the build to target a specific older version).
- **`.github/workflows`**: CI/CD configuration.

## Building the Image

To build the image, you only need to provide the Steam App ID.

**Required Build Arguments:**
*   `STEAM_APP_ID`: `2857200` (Abiotic Factor Dedicated Server)

**Build Command:**
```bash
docker build \
  --build-arg STEAM_APP_ID=2857200 \
  -t abiotic-factor-server .
```

## Running the Container

The server is configured via environment variables.

**Key Environment Variables:**

| Variable | Default | Description |
| :--- | :--- | :--- |
| `SERVER_NAME` | "My Abiotic Factor Server" | The name visible in the server browser. |
| `SERVER_PASSWORD` | "ChangeMe" | Password required to join. |
| `MAX_PLAYERS` | 6 | Maximum concurrent players. |
| `PORT` | 7777 | Game port (UDP). |
| `QUERY_PORT` | 27015 | Steam query port (UDP). |
| `WORLD_NAME` | "Cascade" | Name of the save file/world. |

**Run Command:**
```bash
docker run -d \
  --name abiotic-factor \
  -p 7777:7777/udp \
  -p 27015:27015/udp \
  -e SERVER_NAME="My Cool Server" \
  -e SERVER_PASSWORD="securepassword" \
  abiotic-factor-server
```

## Development & Maintenance

*   **Updates:** To update the server, simply rebuild the Docker image. The build process automatically fetches the latest version of the server from Steam.
*   **Persistence:** The `Dockerfile` does not explicitly define a volume for the save data in the `CMD` or `VOLUME` instruction, but the server directory is at `/home/steam/server`. To persist saves, you should likely mount a volume to the save location (likely inside `/home/steam/server/AbioticFactor/Saved`).