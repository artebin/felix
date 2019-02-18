#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

is_bash

configure_gtk(){
	cd ${BASEDIR}
	
	echo "Configuring GTK ..."
	
	# GTK+ 2.0
	if [ ! -f ~/.gtkrc-2.0 ]; then
		cp ./user.gtkrc-2.0 ~/.gtkrc-2.0
	fi
	sed -i "/^gtk-theme-name/s/.*/gtk-theme-name=\"${GTK_THEME_NAME}\"/" ~/.gtkrc-2.0
	sed -i "/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=\"${GTK_ICON_THEME_NAME}\"/" ~/.gtkrc-2.0
	
	# GTK+ 3.0
	if [ ! -d ~/.config/gtk-3.0 ]; then
		mkdir ~/.config/gtk-3.0
	fi
	if [ ! -f ~/.config/gtk-3.0/settings.ini ]; then
		cp ./user.gtkrc-3.0 ~/.config/gtk-3.0/settings.ini
	fi
	sed -i "/^gtk-theme-name/s/.*/gtk-theme-name=${GTK_THEME_NAME}/" ~/.config/gtk-3.0/settings.ini
	sed -i "/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=${GTK_ICON_THEME_NAME}/" ~/.config/gtk-3.0/settings.ini
	
	if [ -f ~/.config/gtk-3.0/gtk.css ]; then
		backup_file rename ~/.config/gtk-3.0/gtk.css
	fi
	cp ./gtk.css ~/.config/gtk-3.0/gtk.css
	
	# Fix the sharing of bookmarks between GTK2 and GTK3
	if [ -f ~/.config/gtk-3.0/bookmarks ]; then
		backup_file rename ~/.config/gtk-3.0/bookmarks
	fi
	touch ~/.gtk-bookmarks
	ln -s ~/.gtk-bookmarks ~/.config/gtk-3.0/bookmarks
	
	echo
}



cd ${BASEDIR}
configure_gtk 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
