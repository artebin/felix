#!/usr/bin/env bash

source ../../Felix_Xubuntu_18.04.sh
check_shell

configure_mate_caja(){
	cd ${BASEDIR}
	
	echo "Configuring mate-caja ..."
	
	echo "Importing caja configuration in dconf ..."
	dconf load /org/mate/caja/ < ./org.mate.caja.dump
	dconf load /org/mate/desktop/ < ./org.mate.desktop.dump
	
	# For an unkown reason caja-open-terminal plugin is not using
	# x-terminal-emulator by default.
	# See <https://github.com/mate-desktop/caja-extensions/blob/master/open-terminal/caja-open-terminal.c>
	echo "Use x-terminal-emulator for \"Open in Terminal\" action ..."
	gsettings set org.mate.applications-terminal exec x-terminal-emulator
	
	echo "Adding caja scripts ..."
	if [ -d ~/.config/caja/scripts ]; then
	backup_file rename ~/.config/caja/scripts
	fi
	mkdir -p ~/.config/caja/scripts
	cp ./compare ~/.config/caja/scripts
	cp ./tail_and_follow ~/.config/caja/scripts
	cp ./tail_entirely_and_follow ~/.config/caja/scripts
	
	echo
}

cd ${BASEDIR}

configure_mate_caja 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
