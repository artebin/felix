#!/usr/bin/env bash

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${BASEDIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash

configure_fdpowermon(){
	echo "Configuring fdpowermon ..."
	
	cd ${BASEDIR}
	mkdir -p ~/.config/fdpowermon
	cp faenza_felix.theme.cfg ~/.config/fdpowermon/theme.cfg
	
	echo
}



cd ${BASEDIR}
configure_fdpowermon 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
