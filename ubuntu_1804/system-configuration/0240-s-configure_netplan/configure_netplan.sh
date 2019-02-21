#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash
exit_if_has_not_root_privileges

configure_netplan(){
	echo "Configuring NetPlan for using the NetworkManager as renderer ..."
	add_or_update_line_based_on_prefix "  renderer: networkd" "  renderer: NetworkManager" /etc/netplan/01-netcfg.yaml
	netplan generate
	netplan apply
	
	echo
}

cd "${RECIPE_DIR}"
configure_netplan 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
