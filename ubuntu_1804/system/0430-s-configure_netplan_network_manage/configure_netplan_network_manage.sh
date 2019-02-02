#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf
is_bash
exit_if_has_not_root_privileges

configure_netplan_network_manage(){
	echo "Force netplan to use the NetworkManager ..."
	
	add_or_update_line_based_on_prefix "  renderer: networkd" "  renderer: NetworkManager" /etc/netplan/01-netcfg.yaml
	netplan generate
	netplan apply
	
	echo
}

cd ${BASEDIR}
configure_netplan_network_manage 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
