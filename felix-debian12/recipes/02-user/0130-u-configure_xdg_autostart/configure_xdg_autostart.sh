#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_SH="$(eval find ./$(printf "{$(echo %{1..10}q,)}" | sed 's/ /\.\.\//g')/ -maxdepth 1 -name felix-common.sh)"
if [[ ! -f "${FELIX_SH}" ]]; then
	printf "Cannot find felix-common.sh\n"
	exit 1
fi
FELIX_SH="$(readlink -f "${FELIX_SH}")"
FELIX_ROOT="$(dirname "${FELIX_SH}")"
source "${FELIX_SH}"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_root_privileges

configure_xdg_autostart(){
	printf "Setting desktop files in /etc/xdg/autostart disabled for openbox ...\n"
	cd "${RECIPE_DIRECTORY}"
	
	mkdir -p "${HOME}/.config/autostart"
	
	for XDG_AUTOSTART_FILE in /etc/xdg/autostart/*.desktop; do
		XDG_AUTOSTART_FILE_NAME="$(basename "${XDG_AUTOSTART_FILE}")"
		if [[ "${XDG_AUTOSTART_FILE_NAME}" == "xdg-user-dirs.desktop" ]]; then
			printf "  %-50s : Skipped\n" "${XDG_AUTOSTART_FILE_NAME}"
			continue
		fi
		printf "  %-50s : NotShowIn=Openbox\n" "${XDG_AUTOSTART_FILE_NAME}"
		printf "[Desktop Entry]\nNotShowIn=Openbox\n" >"${HOME}/.config/autostart/${XDG_AUTOSTART_FILE_NAME}"
	done
	
	printf "\n"
}

configure_xdg_autostart 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
