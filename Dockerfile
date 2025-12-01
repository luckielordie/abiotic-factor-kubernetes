FROM steamcmd/steamcmd:latest AS builder

ARG STEAM_APP_ID
ARG STEAM_DEPOT_ID
ARG STEAM_MANIFEST_ID
ARG STEAM_USER=anonymous
ARG STEAM_PASSWORD=""

WORKDIR /builder

RUN steamcmd \
    +login anonymous \
    +@sSteamCmdForcePlatformType windows \
    +app_update "$STEAM_APP_ID" validate \
    +quit \
    && mkdir -p /builder/server \
    && ls -la /root/.local/share/Steam/steamapps/common/ \
    && mv /root/.local/share/Steam/steamapps/common/*/* /builder/server/


FROM debian:bullseye
ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 && \
    echo "deb http://deb.debian.org/debian/ bullseye main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian/ bullseye-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://security.debian.org/debian-security/ bullseye-security main contrib non-free" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    cabextract \
    winbind \
    wine \
    wine32 \
    wine64 \
    xvfb \
    xauth \
    winetricks \
    lib32gcc-s1 \
    ca-certificates \
    wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks -O /usr/bin/winetricks && \
    chmod +x /usr/bin/winetricks

RUN useradd -m steam
USER steam
WORKDIR /home/steam
RUN xvfb-run -a -- winetricks -q vcrun2019

ARG STEAM_APP_DESIRED_PATH="server"
ARG STEAM_APP_ID

COPY --from=builder --chown=steam:steam \
    /builder/server \
    /home/steam/${STEAM_APP_DESIRED_PATH}

ENV SERVER_DIR=/home/steam/${STEAM_APP_DESIRED_PATH}
ENV SERVER_NAME="My Abiotic Factor Server"
ENV SERVER_PASSWORD="ChangeMe"
ENV MAX_PLAYERS=6
ENV PORT=7777
ENV QUERY_PORT=27015
ENV WORLD_NAME="Cascade"
ENV WINEDEBUG=-all

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["wine64 \
${SERVER_DIR}/AbioticFactor/Binaries/Win64/AbioticFactorServer-Win64-Shipping.exe \
-useperfthreads \
-NoAsyncLoadingThread \
-SteamServerName=\"${SERVER_NAME}\" \
-ServerPassword=\"${SERVER_PASSWORD}\" \
-MaxServerPlayers=${MAX_PLAYERS} \
-PORT=${PORT} \
-QUERYPORT=${QUERY_PORT} \
-WorldSaveName=\"${WORLD_NAME}\" \
"]