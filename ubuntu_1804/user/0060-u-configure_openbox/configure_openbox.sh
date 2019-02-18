#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

is_bash

configure_openbox(){
	echo "Configuring openbox ..."
	
	cd ${BASEDIR}
	if [ -f ~/.config/openbox ]; then
		backup_file rename ~/.config/openbox
	fi
	if [ ! -f ~/.config/openbox ]; then
		mkdir -p ~/.config/openbox
	fi
	cp exit.py ~/.config/openbox
	cp power_button_pressed.py ~/.config/openbox
	cp dialog_command.sh ~/.config/openbox
	cp tint2_restart.sh ~/.config/openbox
	cp clipmenu_run.sh ~/.config/openbox
	cp obapps-0.1.7.tar.gz ~/.config/openbox
	cp brillo_backlight_notify.sh ~/.config/openbox
	cp brillo_keyboard_notify.sh ~/.config/openbox
	cp autostart ~/.config/openbox
	cp rc.xml ~/.config/openbox
	cp menu.xml ~/.config/openbox
	
	echo
}



cd ${BASEDIR}
configure_openbox 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
