#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
RECIPE_FAMILY_DIR=$(retrieve_recipe_family_dir "${RECIPE_DIR}")
RECIPE_FAMILY_CONF_FILE=$(retrieve_recipe_family_conf_file "${RECIPE_DIR}")
if [[ ! -f "${RECIPE_FAMILY_CONF_FILE}" ]]; then
	printf "Cannot find RECIPE_FAMILY_CONF_FILE: ${RECIPE_FAMILY_CONF_FILE}\n"
	exit 1
fi
source "${RECIPE_FAMILY_CONF_FILE}"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash
exit_if_has_root_privileges

configure_default_applications(){
	cd ${RECIPE_DIR}
	
	if [[ -f mimeapps.list ]]; then
		rm -f mimeapps.list
	fi
	
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
		MIME_TYPE=""
		if [[ "${LINE}" =~ ^#.* ]]; then
			continue
		fi
		if [[ "${LINE}" =~ .*[0-9a-zA-Z].* ]]; then
			MIME_TYPE=$(echo "${LINE}"|awk -F " " '{print $1}')
		fi
		if [[ -z "${MIME_TYPE}" ]]; then
			continue
		fi
		if [[ "${MIME_TYPE}" =~ ^text/ ]]; then
			echo "${MIME_TYPE}=geany.desktop" >>./mimeapps.list
			continue
		fi
		if [[ "${MIME_TYPE}" =~ ^application/.*\+xml.* ]]; then
			echo "${MIME_TYPE}=geany.desktop" >>./mimeapps.list
			continue
		fi
		if [[ "${MIME_TYPE}" =~ ^application/xml-.* ]]; then
			echo "${MIME_TYPE}=geany.desktop" >>./mimeapps.list
			continue
		fi
		if [[ "${MIME_TYPE}" =~ ^image/ ]]; then
			echo "${MIME_TYPE}=gpicview.desktop" >>./mimeapps.list
			continue
		fi
		if [[ "${MIME_TYPE}" =~ ^audio/ ]]; then
			echo "${MIME_TYPE}=vlc.desktop" >>./mimeapps.list
			continue
		fi
		if [[ "${MIME_TYPE}" =~ ^video/ ]]; then
			echo "${MIME_TYPE}=vlc.desktop" >>./mimeapps.list
			continue
		fi
		if [[ "${MIME_TYPE}" == 'application/pdf' ]]; then
			echo "${MIME_TYPE}=atril.desktop" >>./mimeapps.list
			continue
		fi
		echo "${MIME_TYPE}=" >>./mimeapps.list
	done < /etc/mime.types
	
	echo "application/xml=geany.desktop" >>./mimeapps.list
	
	DEFAULT_APPLICATIONS_LINE_NUMBER=$(grep -nr -E "^\[Default Applications]" ~/.config/mimeapps.list|awk -F ":" '{print $1}')
	sed -i.bak "/^\[Default Applications\]$/ r ./mimeapps.list"  ~/.config/mimeapps.list
	
	# Here we have not modified the .desktop files in /usr => no need to call 'update-desktop-database'
	# Calling 'update-desktop-database' with no arguments will use $XDG_DATA_DIRS which on Ubuntu18.04 is valued with:
	# /usr/share/openbox:/usr/local/share/:/usr/share/
	#update-desktop-database
	
	# Cleaning
	cd ${RECIPE_DIR}
	rm -f mimeapps.list
	
	echo
}

configure_default_applications 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
