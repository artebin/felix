#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash
exit_if_has_not_root_privileges

use_network_manager_as_renderer_in_netplan(){
	echo "Use NetworkManager as renderer in NetPlan..."
	
	add_or_update_line_based_on_prefix "  renderer: networkd" "  renderer: NetworkManager" /etc/netplan/01-netcfg.yaml
	netplan generate
	netplan apply
	
	echo
}

cd "${BASEDIR}"
use_network_manager_as_renderer_in_netplan 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi