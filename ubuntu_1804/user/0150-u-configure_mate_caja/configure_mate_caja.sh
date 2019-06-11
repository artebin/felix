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

configure_mate_caja(){
	echo "Configuring mate-caja ..."
	dconf load /org/mate/caja/ <"${RECIPE_DIR}/org.mate.caja.dump"
	dconf load /org/mate/desktop/ <"${RECIPE_DIR}/org.mate.desktop.dump"
	echo
	
	echo "Use x-terminal-emulator for the action 'Open in Terminal' ..."
	# For an unkown reason caja-open-terminal plugin is not using
	# x-terminal-emulator by default.
	# See <https://github.com/mate-desktop/caja-extensions/blob/master/open-terminal/caja-open-terminal.c>
	gsettings set org.mate.applications-terminal exec x-terminal-emulator
	echo
	
	echo "Adding caja scripts ..."
	if [[ -d "${HOME}/.config/caja/scripts" ]]; then
		backup_file rename "${HOME}/.config/caja/scripts"
	fi
	mkdir -p "${HOME}/.config/caja/scripts"
	cp "${RECIPE_FAMILY_DIR}/dotfiles/.config/caja/scripts/execute_in_terminal" "${HOME}/.config/caja/scripts"
	cp "${RECIPE_FAMILY_DIR}/dotfiles/.config/caja/scripts/compare" "${HOME}/.config/caja/scripts"
	cp "${RECIPE_FAMILY_DIR}/dotfiles/.config/caja/scripts/tail_and_follow" "${HOME}/.config/caja/scripts"
	cp "${RECIPE_FAMILY_DIR}/dotfiles/.config/caja/scripts/tail_entirely_and_follow" "${HOME}/.config/caja/scripts"
	cp -R "${RECIPE_FAMILY_DIR}/dotfiles/.config/caja/scripts/indentation" "${HOME}/.config/caja/scripts"
	echo
}

configure_mate_caja 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
