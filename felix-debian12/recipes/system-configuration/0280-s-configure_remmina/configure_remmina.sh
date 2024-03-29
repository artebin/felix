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
exit_if_has_not_root_privileges

configure_remmina(){
	printf "Configuring remmina...\n"
	
	REMMINA_EXTERNAL_TOOLS_DIRECTORY="/usr/share/remmina/external_tools"
	REMMINA_CAJA_SFTP_SCRIPT_NAME="remmina_caja_sftp.sh"
	
	printf "Adding external tool: %s\n" "${REMMINA_CAJA_SFTP_SCRIPT_NAME}"
	if [[ ! -d "${REMMINA_EXTERNAL_TOOLS_DIRECTORY}" ]]; then
		mkdir "${REMMINA_EXTERNAL_TOOLS_DIRECTORY}"
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
