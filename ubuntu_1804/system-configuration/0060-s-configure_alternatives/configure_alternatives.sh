#!/usr/bin/env bash

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${BASEDIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash
exit_if_has_not_root_privileges

configure_alternatives(){
	echo "Configuring alternatives ..."
	
	echo "Setting mate-terminal as x-terminal-emulator ..."
	update-alternatives --set x-terminal-emulator /usr/bin/mate-terminal.wrapper
	echo
	
	echo "Setting firefox as x-www-browser ..."
	update-alternatives --set x-www-browser /usr/bin/firefox
	echo
}

configure_alternatives 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
