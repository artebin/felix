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
exit_if_has_not_root_privileges

configure_keyboard(){
	echo "Configuring keyboard ..."
	
	if [[ ! -f /etc/default/keyboard ]]; then
		echo "Cannot find /etc/default/keyboard"
		exit 1
	fi
	
	backup_file copy /etc/default/keyboard
	
	echo "XKBMODEL=\"${XKBMODEL}\""
	add_or_update_line_based_on_prefix "XKBMODEL=" "XKBMODEL=\"${XKBMODEL}\"" /etc/default/keyboard
	
	echo "XKBLAYOUT=\"${XKBLAYOUT}\""
	add_or_update_line_based_on_prefix "XKBLAYOUT=" "XKBLAYOUT=\"${XKBLAYOUT}\"" /etc/default/keyboard
	
	echo "XKBVARIANT=\"${XKBVARIANT}\""
	add_or_update_line_based_on_prefix "XKBVARIANT=" "XKBVARIANT=\"${XKBVARIANT}\"" /etc/default/keyboard
	
	echo "XKBOPTIONS=\"${XKBOPTIONS}\""
	add_or_update_line_based_on_prefix "XKBOPTIONS=" "XKBOPTIONS=\"${XKBOPTIONS}\"" /etc/default/keyboard
	
	echo
}

cd "${RECIPE_DIRECTORY}"
configure_keyboard 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
