#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIRECTORY%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_root_privileges

configure_xfce4_thunar(){
	printf "Configuring xfce4-thunar ...\n"
	
	# 
	# Xfce stores its config in ~/.config/xfce4/xfconf/xfce-perchannel-xml/
	# These files should not be changed while logged in xfce (otherwise they 
	# could be overwritten by xfce).
	# 
	# We should use xfconf-query for applying changes during xfce runtime.
	# We can use xfce4-settings-editor to explore the database.
	#
	
	CONFIG_FILE="thunar.xml"
	if [[ -f "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/${CONFIG_FILE}" ]]; then
		backup_file rename "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/${CONFIG_FILE}"
	fi
	if [[ ! -d "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml" ]]; then
		mkdir -p "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml"
	fi
	cp "${RECIPE_FAMILY_DIRECTORY}/dotfiles/.config/xfce4/xfconf/xfce-perchannel-xml/${CONFIG_FILE}" "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml"
	
	printf "\n"
}

configure_xfce4_thunar 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
