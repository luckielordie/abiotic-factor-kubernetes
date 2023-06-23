FROM debian:bullseye-slim as steamcmd

ENV STEAM_UID 1000
ENV STEAM_USER steam
ENV STEAM_HOME_DIR "/home/${STEAM_USER}"
ENV STEAM_CMD_DIR "${STEAM_HOME_DIR}/steamcmd"

RUN apt-get update && \
	apt-get install -y --no-install-recommends --no-install-suggests \
		lib32stdc++6 \
		lib32gcc-s1 \
		ca-certificates \
		nano \
		curl \
		locales && \
	sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	useradd -u "${STEAM_UID}" -m "${STEAM_USER}" && \
	su "${STEAM_USER}" -c \
		"mkdir -p \"${STEAM_CMD_DIR}\" \
		&& curl -fsSL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar xvzf - -C \"${STEAM_CMD_DIR}\" \
		&& \"./${STEAM_CMD_DIR}/steamcmd.sh\" +quit \
		&& mkdir -p \"${STEAM_HOME_DIR}/.steam/sdk32\" \
		&& ln -s \"${STEAM_CMD_DIR}/linux32/steamclient.so\" \"${STEAM_HOME_DIR}/.steam/sdk32/steamclient.so\" \
		&& ln -s \"${STEAM_CMD_DIR}/linux32/steamcmd\" \"${STEAM_CMD_DIR}/linux32/steam\" \
		&& ln -s \"${STEAM_CMD_DIR}/steamcmd.sh\" \"${STEAM_CMD_DIR}/steam.sh\"" && \
	ln -s "${STEAM_CMD_DIR}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so" && \
	apt-get remove --purge --auto-remove -y && \
	rm -rf /var/lib/apt/lists/*

WORKDIR ${STEAM_CMD_DIR}
USER ${STEAM_USER}

FROM steamcmd as zomboid_build
COPY ./runscript ${STEAM_HOME_DIR}
RUN ${STEAM_CMD_DIR}/steamcmd.sh +runscript ${STEAM_HOME_DIR}/runscript

ENV ZOMBOID_INSTALL_DIR "${STEAM_HOME_DIR}/project_zomboid"
ENV PATH "${ZOMBOID_INSTALL_DIR}/jre64/bin:${PATH}"
ENV LD_LIBRARY_PATH "${ZOMBOID_INSTALL_DIR}/linux64;${ZOMBOID_INSTALL_DIR}/natives:${ZOMBOID_INSTALL_DIR}:${LD_LIBRARY_PATH}"
ENV JSIG "libjsig.so"
ENV LD_PRELOAD "${LD_PRELOAD}:${JSIG}"

FROM zomboid_build
USER root
WORKDIR ${ZOMBOID_INSTALL_DIR}
CMD [ "sh", "-c", "${ZOMBOID_INSTALL_DIR}/ProjectZomboid64" ]