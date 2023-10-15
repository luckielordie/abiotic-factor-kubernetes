FROM steamcmd/steamcmd:ubuntu
COPY ./runscript ${WORKDIR}/runscript
RUN steamcmd +runscript ${WORKDIR}/runscript
ENV ZOMBOID_INSTALL_DIR "/root/project_zomboid"
ENV PATH "${ZOMBOID_INSTALL_DIR}:${ZOMBOID_INSTALL_DIR}/jre64/bin:${PATH}"
ENV LD_LIBRARY_PATH "${ZOMBOID_INSTALL_DIR}/linux64;${ZOMBOID_INSTALL_DIR}/natives:${ZOMBOID_INSTALL_DIR}:${LD_LIBRARY_PATH}"
ENV JSIG "libjsig.so"
ENV LD_PRELOAD "${LD_PRELOAD}:${JSIG}"
WORKDIR ${ZOMBOID_INSTALL_DIR}
ENTRYPOINT [ "ProjectZomboid64" ]
