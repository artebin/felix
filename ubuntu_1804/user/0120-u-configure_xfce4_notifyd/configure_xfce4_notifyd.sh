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

configure_xfce4_notifyd(){
	echo "Configuring xfce4-notifyd ..."
	
	# 
	# Xfce stores its config in ~/.config/xfce4/xfconf/xfce-perchannel-xml/
	# These files should not be changed while logged in xfce (otherwise they 
	# could be overwritten by xfce).
	# 
	# We should use xfconf-query for applying changes during xfce runtime.
	# We can use xfce4-settings-editor to explore the database.
	#
	
	CONFIG_FILE="xfce4-notifyd.xml"
	if [[ -f "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/${CONFIG_FILE}" ]]; then
		backup_file rename "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/${CONFIG_FILE}"
	fi
	if [[ ! -d "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml" ]]; then
		mkdir -p "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml"
	fi
	cp "${RECIPE_FAMILY_DIR}/dotfiles/.config/xfce4/xfconf/xfce-perchannel-xml/${CONFIG_FILE}" "${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/${CONFIG_FILE}"
	echo
}

configure_xfce4_notifyd 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
