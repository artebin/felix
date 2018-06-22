#!/usr/bin/env bash

source ../../common.sh
check_shell

configure_default_applications(){
	cd ${BASEDIR}
	
	if [ -f ~/.config/mimeapps.list ]; then
		backup_file rename ~/.config/mimeapps.list
	fi
	
	echo "Configuring mate-caja as default file browser ..."
	mkdir -p ~/.local/share/applications
	cp ./caja.desktop ~/.local/share/applications/caja.desktop
	xdg-mime default caja.desktop inode/directory
	
	echo "Configuring thunderbird as default mail client ..."
	xdg-mime default thunderbird.desktop x-scheme-handler/mailto
	
	# MIME types are defined in /etc/mime.types
	# Set default applications per MIME types:
	#	text/*			Geany
	#	image/* 		Eye Of MATE
	#	audio/*			VLC
	#	video/*			VLC
	
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
			echo "${MIME_TYPE}=eom.desktop" >>./mimeapps.list
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
	
	update-desktop-database
}

cd ${BASEDIR}
configure_default_applications 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
