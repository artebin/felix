#!/usr/bin/env bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

install_pasystray(){
	cd ${BASEDIR}
	
	echo "Installing paman v0.9.1 from sources (retrieved from <http://0pointer.de/lennart/projects/paman/>) ..."
	apt-get install -y libgtkmm-2.4-dev libgtkmm-3.0-dev libglademm-2.4-dev lynx
	tar xzf ./paman-0.9.4.tar.gz
	cd ./paman-0.9.4
	./configure
	make
	make install
	
	# Cleanup
	cd ${BASEDIR}
	rm -fr paman-0.9.4
	
	echo
}

cd ${BASEDIR}

install_pasystray 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
