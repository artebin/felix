#!/usr/bin/env bash

source ../../Felix_Xubuntu_18.04.sh
check_shell

configure_default_applications(){
	cd ${BASEDIR}
	
	if [ -f ~/.config/mimeapps.list ]; then
		backup_file rename ~/.config/mimeapps.list
	fi
	
	#
	# We override a few .desktop files:
	#
	#   - Caja: to be started with a script assuring one instance per
	#     workspace.
	#
	#   - GPicView: gpicview.desktop which is installed with the package 
	#     gives "Image Viewer" as application name but we don't want to
	#     see that, it's name is GPicView, point.
	#
	mkdir -p ~/.local/share/applications
	cp *.desktop ~/.local/share/applications
	
	echo "Configuring mate-caja as default file browser ..."
	xdg-mime default caja.desktop inode/directory
	
	echo "Configuring thunderbird as default mail client ..."
	xdg-mime default thunderbird.desktop x-scheme-handler/mailto
	
	# MIME types are defined in /etc/mime.types
	# Set default applications per MIME types:
	#   text/*			Geany
	#   image/* 		GPicView
	#   audio/*			VLC
	#   video/*			VLC
	
	while read LINE ; do
		if [[ ${LINE} =~ ^text/ ]]; then
			MIME_TYPE=$(echo "${LINE}"|awk -F " " '{print $1}')
			echo "${MIME_TYPE}=geany.desktop" >>./mimeapps.list
			continue
		fi
		if [[ ${LINE} =~ ^application/.*\+xml.* ]]; then
			MIME_TYPE=$(echo "${LINE}"|awk -F " " '{print $1}')
			echo "${MIME_TYPE}=geany.desktop" >>./mimeapps.list
			continue
		fi
		if [[ ${LINE} =~ ^application/xml-.* ]]; then
			MIME_TYPE=$(echo "${LINE}"|awk -F " " '{print $1}')
			echo "${MIME_TYPE}=geany.desktop" >>./mimeapps.list
			continue
		fi
		if [[ ${LINE} =~ ^image/ ]]; then
			MIME_TYPE=$(echo "${LINE}"|awk -F " " '{print $1}')
			echo "${MIME_TYPE}=gpicview.desktop" >>./mimeapps.list
			continue
		fi
		if [[ ${LINE} =~ ^audio/ ]]; then
			MIME_TYPE=$(echo "${LINE}"|awk -F " " '{print $1}')
			echo "${MIME_TYPE}=vlc.desktop" >>./mimeapps.list
			continue
		fi
		if [[ ${LINE} =~ ^video/ ]]; then
			MIME_TYPE=$(echo "${LINE}"|awk -F " " '{print $1}')
			echo "${MIME_TYPE}=vlc.desktop" >>./mimeapps.list
			continue
		fi
	done </etc/mime.types
	
	echo "application/xml=geany.desktop" >>./mimeapps.list
	
	DEFAULT_APPLICATIONS_LINE_NUMBER=$(grep -nr -E "^\[Default Applications]" ~/.config/mimeapps.list|awk -F ":" '{print $1}')
	sed -i.bak "/^\[Default Applications\]$/ r ./mimeapps.list"  ~/.config/mimeapps.list
	
	# Here we have not modified the .desktop files in /usr => no need to call 'update-desktop-database'
	# Calling 'update-desktop-database' with no arguments will use $XDG_DATA_DIRS which on Ubuntu18.04 is valued with:
	# /usr/share/openbox:/usr/local/share/:/usr/share/
	#update-desktop-database
	
	# Cleaning
	cd ${BASEDIR}
	rm -f mimeapps.list
	
	echo
}

cd ${BASEDIR}

configure_default_applications 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
