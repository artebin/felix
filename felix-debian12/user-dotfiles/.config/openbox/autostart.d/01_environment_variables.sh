#!/usr/bin/env sh

export PATH="${HOME}/.local/bin:${PATH}"

export JDK_HOME=""
export JRE_HOME=""
if [ ! -z "${JDK_HOME}" ]; then
	export PATH="${JDK_HOME}/bin:${PATH}"
fi

export ANT_HOME=""
if [ ! -z "${ANT_HOME}" ]; then
	export PATH="${ANT_HOME}/bin:${PATH}"
fi

export MVN_HOME=""
if [ ! -z "${MVN_HOME}" ]; then
	export PATH="${MVN_HOME}/bin:${PATH}"
fi

export GPODDER_HOME=""
export GPODDER_DOWNLOAD_DIR=""

# Force loading of libgtk3-nocsd if it is installed
LIBGTK3_NOCSD_PATH="/usr/lib/x86_64-linux-gnu/libgtk3-nocsd.so.0"
if [[ -f "${LIBGTK3_NOCSD_PATH}" ]]; then
	export LD_PRELOAD="$(basename "${LIBGTK3_NOCSD_PATH}")${LD_PRELOAD:+:$LD_PRELOAD}"
fi

# Use qt5ct for theming Qt applications
#export QT_QPA_PLATFORMTHEME=qt5ct
