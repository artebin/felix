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

configure_netplan(){
	printf "Configuring NetPlan for using the NetworkManager as renderer...\n"
	NETPLAN_INSTALL_CONFIG_FILE="/etc/netplan/01-installer-config.yaml"
	NETPLAN_FELIX_CONFIG_FILE="/etc/netplan/01-network.yaml"
	if [[ ! -f "${NETPLAN_INSTALL_CONFIG_FILE}" ]]; then
		printf "Cannot find NETPLAN_INSTALL_CONFIG_FILE[%s]\n" "${NETPLAN_INSTALL_CONFIG_FILE}"
		return 1
	fi
	cp "${NETPLAN_INSTALL_CONFIG_FILE}" "${NETPLAN_FELIX_CONFIG_FILE}"
	mv "${NETPLAN_INSTALL_CONFIG_FILE}" "${NETPLAN_INSTALL_CONFIG_FILE}.bak" 
	add_or_update_line_based_on_prefix "  renderer: networkd" "  renderer: NetworkManager" "${NETPLAN_FELIX_CONFIG_FILE}"
	netplan generate
	netplan apply
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"
configure_netplan 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
