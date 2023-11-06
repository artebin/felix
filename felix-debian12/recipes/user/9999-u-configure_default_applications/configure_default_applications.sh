#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_SH="$(eval find ./$(printf "{$(echo %{1..10}q,)}" | sed 's/ /\.\.\//g')/ -maxdepth 1 -name felix.sh)"
if [[ ! -f "${FELIX_SH}" ]]; then
	printf "Cannot find felix.sh\n"
	exit 1
fi
FELIX_SH="$(readlink -f "${FELIX_SH}")"
FELIX_ROOT="$(dirname "${FELIX_SH}")"
source "${FELIX_SH}"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_root_privileges

# Should use xdg-settings instead below:
#configure_default_applications_with_xdg_mime(){
#	printf "Configuring default applications with xdg-mime ...\n"
#	
#	printf "  - Caja should be default file browser\n"
#	xdg-mime default caja.desktop inode/directory
#	
#	printf "  - Claws Mail should be default mail client\n"
#	xdg-mime default sylpheed-claws.desktop x-scheme-handler/mailto
#	
#	printf "\n"
#}

configure_default_applications_with_desktop_file_overridings(){
	printf "Configuring default applications with desktop files overridings ...\n"
	
	mkdir -p "${HOME}/.local/share/applications"
	
	printf "  - Caja: should to be started with a script assuring one instance per workspace\n"
	cp "${RECIPE_DIRECTORY}/caja.desktop" "${HOME}/.local/share/applications"
	
	printf "\n"
}

configure_default_applications_with_mime_apps_list(){
	printf "Configuring default applications with mimeapp.list ...\n"
	
	# We will work on a temporary file
	TEMP_MIME_APPS_LIST_FILE="${RECIPE_DIRECTORY}/mymimeapps.list"
	if [[ -f "${TEMP_MIME_APPS_LIST_FILE}" ]]; then
		rm -f "${TEMP_MIME_APPS_LIST_FILE}"
	fi
	
	# MIME types are defined in /etc/mime.types
	# Set default applications per MIME types:
	#  text/*		Geany
	#  application/.*-xml	Geany
	#  application/.*+xml	Geany
	#  application/.*_xml	Geany
	#  application/.*pdf.*	Atril
	#  image/* 		Eye of MATE
	#  audio/*		VLC
	#  video/*		VLC
	
	while read LINE; do
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
			echo "${MIME_TYPE}=geany.desktop;" >>"${TEMP_MIME_APPS_LIST_FILE}"
			continue
		fi
		if [[ "${MIME_TYPE}" =~ ^application/.*\-xml ]]; then
			echo "${MIME_TYPE}=geany.desktop;" >>"${TEMP_MIME_APPS_LIST_FILE}"
			continue
		fi
		if [[ "${MIME_TYPE}" =~ ^application/.*\+xml ]]; then
			echo "${MIME_TYPE}=geany.desktop;" >>"${TEMP_MIME_APPS_LIST_FILE}"
			continue
		fi
		if [[ "${MIME_TYPE}" =~ ^application/.*_xml ]]; then
			echo "${MIME_TYPE}=geany.desktop;" >>"${TEMP_MIME_APPS_LIST_FILE}"
			continue
		fi
		if [[ "${MIME_TYPE}" =~ ^application/.*pdf.* ]]; then
			echo "${MIME_TYPE}=atril.desktop;" >>"${TEMP_MIME_APPS_LIST_FILE}"
			continue
		fi
		if [[ "${MIME_TYPE}" =~ ^image/ ]]; then
			echo "${MIME_TYPE}=eom.desktop;" >>"${TEMP_MIME_APPS_LIST_FILE}"
			continue
		fi
		if [[ "${MIME_TYPE}" =~ ^audio/ ]]; then
			echo "${MIME_TYPE}=vlc.desktop;" >>"${TEMP_MIME_APPS_LIST_FILE}"
			continue
		fi
		if [[ "${MIME_TYPE}" =~ ^video/ ]]; then
			echo "${MIME_TYPE}=vlc.desktop;" >>"${TEMP_MIME_APPS_LIST_FILE}"
			continue
		fi
		if [[ "${MIME_TYPE}" == 'application/pdf' ]]; then
			echo "${MIME_TYPE}=atril.desktop;" >>"${TEMP_MIME_APPS_LIST_FILE}"
			continue
		fi
		#echo "${MIME_TYPE}=" >>"${TEMP_MIME_APPS_LIST_FILE}"
	done < /etc/mime.types
	
	printf "application/x-shellscript=geany.desktop;\n" >>"${TEMP_MIME_APPS_LIST_FILE}"
	printf "application/xml=geany.desktop;\n" >>"${TEMP_MIME_APPS_LIST_FILE}"
	printf "application/x-jar=engrampa.desktop;\n" >>"${TEMP_MIME_APPS_LIST_FILE}"
	printf "inode/directory=caja.desktop;\n" >>"${TEMP_MIME_APPS_LIST_FILE}"
	
	# See <https://wiki.archlinux.org/index.php/XDG_MIME_Applications>
	# ${HOME}/.local/share/applications/mimeapps.list is deprecated
	if [[ -f "${HOME}/.config/mimeapps.list" ]]; then
		backup_file rename "${HOME}/.config/mimeapps.list"
	fi
	printf '[Default Applications]\n' >"${HOME}/.config/mimeapps.list"
	cat "${TEMP_MIME_APPS_LIST_FILE}" >>"${HOME}/.config/mimeapps.list"
	
	# We have not modified the .desktop files in /usr => no need to call 'update-desktop-database'
	# Calling 'update-desktop-database' with no arguments will use $XDG_DATA_DIRS which on Ubuntu18.04 is valued with:
	# /usr/share/openbox:/usr/local/share/:/usr/share/
	#update-desktop-database
	
	# Cleaning
	rm -f "${TEMP_MIME_APPS_LIST_FILE}"
	
	printf "\n"
}

#configure_default_applications_with_xdg_mime 2>&1 | tee -a "${RECIPE_LOG_FILE}"
#EXIT_CODE="${PIPESTATUS[0]}"
#if [[ "${EXIT_CODE}" -ne 0 ]]; then
#	exit "${EXIT_CODE}"
#fi

configure_default_applications_with_desktop_file_overridings 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi

configure_default_applications_with_mime_apps_list 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
