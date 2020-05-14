#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_not_root_privileges

disable_apport(){
	echo "Disabling apport ..."
	APPORT_FILE="/etc/default/apport"
	if [[ ! -f "${APPORT_FILE}" ]]; then
		echo "Can not find file: ${APPORT_FILE}"
		exit 1
	else
		add_or_update_line_based_on_prefix "enabled=" "enabled=0" "${APPORT_FILE}"
	fi
	
	systemctl stop apport.service
	systemctl disable apport.service
	
	echo
}

disable_whoopsie(){
	echo "Disabling whoopsie ..."
	
	# See <https://askubuntu.com/questions/135540/what-is-the-whoopsie-process-and-how-can-i-remove-it>
	
	WHOOPSIE_FILE="/etc/default/whoopsie"
	if [[ ! -f "${WHOOPSIE_FILE}" ]]; then
		cp whoopsie.conf "${WHOOPSIE_FILE}"
	else
		add_or_update_line_based_on_prefix "report_crashes=" "report_crashes=false" "${WHOOPSIE_FILE}"
	fi
	
	systemctl stop whoopsie.service
	systemctl disable whoopsie.service
	
	echo
}

disable_apport 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi

disable_whoopsie 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
