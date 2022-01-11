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

configure_remmina(){
	printf "Configuring remmina...\n"
	
	REMMINA_EXTERNAL_TOOLS_DIRECTORY="/usr/share/remmina/external_tools"
	REMMINA_CAJA_SFTP_SCRIPT_NAME="remmina_caja_sftp.sh"
	
	printf "Adding external tool: %s\n" "${REMMINA_CAJA_SFTP_SCRIPT_NAME}"
	if [[ ! -d "${REMMINA_EXTERNAL_TOOLS_DIRECTORY}" ]]; then
		printf "Cannot find REMMINA_EXTERNAL_TOOLS_DIRECTORY: %s\n" "${REMMINA_EXTERNAL_TOOLS_DIRECTORY}"
		return
	fi
	if [[ -f "${REMMINA_EXTERNAL_TOOLS_DIRECTORY}/${REMMINA_CAJA_SFTP_SCRIPT_NAME}" ]]; then
		rm -f "${REMMINA_EXTERNAL_TOOLS_DIRECTORY}/${REMMINA_CAJA_SFTP_SCRIPT_NAME}"
	fi
	cp "${REMMINA_CAJA_SFTP_SCRIPT_NAME}" "${REMMINA_EXTERNAL_TOOLS_DIRECTORY}/${REMMINA_CAJA_SFTP_SCRIPT_NAME}"
	chmod +x "${REMMINA_EXTERNAL_TOOLS_DIRECTORY}/${REMMINA_CAJA_SFTP_SCRIPT_NAME}"
	
	printf "\n"
}

configure_remmina 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
