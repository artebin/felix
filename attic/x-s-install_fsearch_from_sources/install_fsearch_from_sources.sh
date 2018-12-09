#!/usr/bin/env bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

install_fsearch_from_sources(){
	cd ${BASEDIR}
	
	echo "Installing fsearch from <https://github.com/cboxdoerfer/fsearch> ..."
	apt install -y git build-essential automake autoconf libtool pkg-config intltool autoconf-archive libpcre3-dev libglib2.0-dev libgtk-3-dev libxml2-utils
	git clone "https://github.com/cboxdoerfer/fsearch"
	cd fsearch
	./autogen.sh
	./configure
	make
	make install
	
	# Cleanup
	cd ${BASEDIR}
	rm -fr fsearch
	
	echo
}

cd ${BASEDIR}

install_fsearch_from_sources 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
