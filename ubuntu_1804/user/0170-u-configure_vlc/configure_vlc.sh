#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash

configure_vlc(){
	cd ${RECIPE_DIR}
	
	echo "Configuring vlc ..."
	if [ -f ~/.config/vlc ]; then
		backup_file rename ~/.config/vlc
	fi
	if [ ! -f ~/.config/vlc ]; then
		mkdir -p ~/.config/vlc
	fi
	cp ./vlcrc ~/.config/vlc/vlcrc
	
	if [ -f ~/.local/share/vlc ]; then
		backup_file rename ~/.local/share/vlc
	fi
	if [ ! -f ~/.local/share/vlc ]; then
		mkdir -p ~/.local/share/vlc
	fi
	cp ./ml.xspf ~/.local/share/vlc/ml.xspf
	
	echo
}



cd ${RECIPE_DIR}
configure_vlc 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
