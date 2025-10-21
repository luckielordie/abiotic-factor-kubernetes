FROM steamcmd/steamcmd:latest AS builder

ARG STEAM_APP_ID
ARG STEAM_DEPOT_ID
ARG STEAM_MANIFEST_ID
ARG STEAM_USER=anonymous
ARG STEAM_PASSWORD=""


WORKDIR /builder

RUN steamcmd +login "$STEAM_USER" "$STEAM_PASSWORD" \
+download_depot "$STEAM_APP_ID" "$STEAM_DEPOT_ID" "$STEAM_MANIFEST_ID" \
+quit


FROM debian:bullseye-slim
ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 && \
    echo "deb http://deb.debian.org/debian/ bullseye main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian/ bullseye-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://security.debian.org/debian-security/ bullseye-security main contrib non-free" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    tini \
    wine \
    wine32 \
    wine64 \
    xvfb \
    xauth \
    winetricks \
    lib32gcc-s1 \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd -m steam
USER steam
WORKDIR /home/steam
RUN xvfb-run -a -- wineboot -i

ARG STEAM_APP_DESIRED_PATH="server"
ARG STEAM_APP_ID
ARG STEAM_DEPOT_ID

COPY --from=builder --chown=steam:steam \
    /root/.local/share/Steam/steamcmd/linux32/steamapps/content/app_${STEAM_APP_ID}/depot_${STEAM_DEPOT_ID} \
    /home/steam/${STEAM_APP_DESIRED_PATH}

ENV SERVER_DIR=/home/steam/${STEAM_APP_DESIRED_PATH}

ENTRYPOINT ["/usr/bin/tini", "--", "/bin/sh", "-c", "xvfb-run -a -- ${SERVER_DIR}/AbioticFactorServer.exe"]
CMD []