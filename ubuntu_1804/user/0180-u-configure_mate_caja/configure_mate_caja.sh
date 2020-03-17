#!/usr/bin/env bash

declare -g RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
declare -g FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
init_recipe "${RECIPE_DIR}"

exit_if_not_bash
exit_if_has_root_privileges

configure_mate_caja(){
	printf "Configuring mate-caja ...\n"
	
	dconf load /org/mate/caja/ <"${RECIPE_DIR}/org.mate.caja.dump"
	dconf load /org/mate/desktop/ <"${RECIPE_DIR}/org.mate.desktop.dump"
	echo
	
	echo "Use x-terminal-emulator for the action 'Open in Terminal' ..."
	# For an unkown reason caja-open-terminal plugin is not using
	# x-terminal-emulator by default.
	# See <https://github.com/mate-desktop/caja-extensions/blob/master/open-terminal/caja-open-terminal.c>
	gsettings set org.mate.applications-terminal exec x-terminal-emulator
	echo
	
	printf "Adding caja scripts ...\n"
	if [[ -d "${HOME}/.config/caja/scripts" ]]; then
		backup_file rename "${HOME}/.config/caja/scripts"
	fi
	mkdir -p "${HOME}/.config/caja/scripts"
	cp -R "${RECIPE_FAMILY_DIR}/dotfiles/.config/caja/scripts" "${HOME}/.config/caja"
	
	printf "\n"
}

configure_mate_caja 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
