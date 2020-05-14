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

configure_apticron(){
	printf "Configuring apticron ...\n"
	
	APTICRON_CONF_FILE="/etc/apticron/apticron.conf"
	backup_file copy "${APTICRON_CONF_FILE}"
	update_line_based_on_prefix 'EMAIL=' "EMAIL=\"${USER_EMAIL_ADDRESS}\"" "${APTICRON_CONF_FILE}"
	if [[ $? -ne 0 ]]; then
		printf "Cannot find key 'EMAIL' in APTICRON_CONF_FILE[%s]\n" "${APTICRON_CONF_FILE}"
		return 1
	fi
	
	printf "\n"
}

configure_apticron 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
