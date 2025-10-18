FROM steamcmd/steamcmd:ubuntu

ENV DEBIAN_FRONTEND=noninteractive
ENV RUNSCRIPT_FILE=/install/runscript
ENV INSTALL_DIR=/abiotic-factor

COPY ./runscript ${RUNSCRIPT_FILE}
RUN steamcmd +runscript ${RUNSCRIPT_FILE}
WORKDIR ${INSTALL_DIR}
