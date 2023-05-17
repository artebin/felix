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

configure_xdg_autostart(){
	printf "Configuring xdg autostart ...\n"
	
	printf "Disable all desktop files from \`/etc/xdg/autostart\` ...\n"
	cd "${RECIPE_DIRECTORY}"
	
	mkdir -p "${HOME}/.config/autostart"
	
	for XDG_AUTOSTART_FILE in /etc/xdg/autostart/*.desktop; do
		printf "${XDG_AUTOSTART_FILE_NAME}\n"
		if [[ "${XDG_AUTOSTART_FILE_NAME}" == "xdg-users-dirs.desktop" ]]; then
			printf "  File skipped\n\n"
			continue
		fi
		printf "  Disabling ${XDG_AUTOSTART_FILE}\n\n"
		XDG_AUTOSTART_FILE_NAME="$(basename "${XDG_AUTOSTART_FILE}")"
		printf "[Desktop Entry]\nNotShowIn=Openbox\n" >"${HOME}/.config/autostart/${XDG_AUTOSTART_FILE_NAME}"
	done
	
	printf "\n"
}

configure_xdg_autostart 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
