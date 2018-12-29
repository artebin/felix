#!/usr/bin/env bash

source ../../Felix_Xubuntu_18.04.sh
is_bash

configure_fdpowermon(){
	echo "Configuring fdpowermon ..."
	
	cd ${BASEDIR}
	mkdir -p ~/.config/fdpowermon
	cp faenza_felix.theme.cfg ~/.config/fdpowermon
	
	echo
}

cd ${BASEDIR}

configure_fdpowermon 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
