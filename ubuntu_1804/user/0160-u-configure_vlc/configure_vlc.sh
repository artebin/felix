#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf
is_bash

configure_vlc(){
	cd ${BASEDIR}
	
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

BASEDIR="$(dirname ${BASH_SOURCE})"

cd ${BASEDIR}
configure_vlc 2>&1 | tee -a "$(retrieve_log_file_name ${BASH_SOURCE})"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
