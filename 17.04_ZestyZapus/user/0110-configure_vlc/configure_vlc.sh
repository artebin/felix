#!/bin/bash

source ../../common.sh
check_shell

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
}

cd ${BASEDIR}
configure_vlc 2>&1 | tee -a ./${SCRIPT_LOG_FILE_NAME}
