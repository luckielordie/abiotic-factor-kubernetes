#!/bin/bash

INSTDIR="/home/steam/project_zomboid"
echo "64-bit java detected"
        export PATH="${INSTDIR}/jre64/bin:$PATH"
        export LD_LIBRARY_PATH="${INSTDIR}/linux64:${INSTDIR}/natives:${INSTDIR}:${INSTDIR}/jre64/lib/amd64:${LD_LIBRARY_PATH}"
        JSIG="libjsig.so"
        LD_PRELOAD="${LD_PRELOAD}:${JSIG}" ./ProjectZomboid64 "$@"

