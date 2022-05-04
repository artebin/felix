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
exit_if_has_not_root_privileges

update_xdg_user_dirs_default(){
	printf "Remove Templates as a XDG user directory...\n"
	
	XDG_USER_DIRS_DEFAULT_FILE="/etc/xdg/user-dirs.defaults"
	if [[ ! -f "${XDG_USER_DIRS_DEFAULT_FILE}" ]]; then
		echo "Cannot find file: ${XDG_USER_DIRS_DEFAULT_FILE}"
	else
		sed -i.bak "s/^TEMPLATES=/#TEMPLATES=/g" "${XDG_USER_DIRS_DEFAULT_FILE}"
	fi
	
	printf "\n"
}

list_xdg_autostart_desktop_files(){
	DESKTOP_FILE_NO_ONLYSHOWIN_ARRAY=()
	declare -A DESKTOP_ONLYSHOWIN_MAP
	
	for DESKTOP_FILE in /etc/xdg/autostart/*.desktop; do
		ONLYSHOWIN_LINE=$(cat ${DESKTOP_FILE}|grep "^OnlyShowIn=")
		if [[ -z "${ONLYSHOWIN_LINE}" ]]; then
			DESKTOP_FILE_NO_ONLYSHOWIN_ARRAY+=( "${DESKTOP_FILE}" )
		else
			ONLYSHOWIN_LINE=$(echo "${ONLYSHOWIN_LINE}"|sed 's/^OnlyShowIn=//g')
			DESKTOP_ARRAY=( $(echo "${ONLYSHOWIN_LINE}"|sed 's/;/ /g') )
			for DESKTOP_NAME in "${DESKTOP_ARRAY[@]}"; do
				DESKTOP_ONLYSHOWIN_MAP["${DESKTOP_NAME}"]+=" ${DESKTOP_FILE}"
			done
		fi
	done
	
	printf "Desktop files for all desktops:\n"
	for DESKTOP_FILE in "${DESKTOP_FILE_NO_ONLYSHOWIN_ARRAY[@]}"; do
		printf "  ${DESKTOP_FILE}\n"
	done
	
	printf "\n"
	
	for DESKTOP_NAME in "${!DESKTOP_ONLYSHOWIN_MAP[@]}"; do
		printf "Desktop files for ${DESKTOP_NAME}:\n"
		DESKTOP_FILE_ARRAY=( ${DESKTOP_ONLYSHOWIN_MAP[${DESKTOP_NAME}]} )
		for DESKTOP_FILE in "${DESKTOP_FILE_ARRAY[@]}"; do
			printf "  ${DESKTOP_FILE}\n"
		done
		printf "\n"
	done
	
	printf "\n"
}

disable_unwanted_xdg_autostart(){
	printf "Disabling unwanted xdg autostart...\n"
	
	XDG_AUTOSTART_DESKTOP_FILE_ARRAY=(
		"nm-applet"
		"blueman.desktop"
		"xfce4-power-manager.desktop"
	)
	
	for XDG_AUTOSTART_FILE_NAME in "${XDG_AUTOSTART_DESKTOP_FILE_ARRAY[@]}"; do
		if [[ ! -f "/etc/xdg/autostart/${XDG_AUTOSTART_FILE_NAME}" ]]; then
			printf "Cannot find file: ${XDG_AUTOSTART_FILE_NAME}\n"
		else
			printf "Disabling autostart for ${XDG_AUTOSTART_FILE_NAME}...\n"
			backup_file rename "/etc/xdg/autostart/${XDG_AUTOSTART_FILE_NAME}"
		fi
	done
	
	printf "\n"
}

update_xdg_user_dirs_default 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi

list_xdg_autostart_desktop_files 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi

disable_unwanted_xdg_autostart 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
