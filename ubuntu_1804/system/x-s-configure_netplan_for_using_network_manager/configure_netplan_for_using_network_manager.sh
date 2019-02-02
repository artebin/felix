#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf
is_bash
exit_if_has_not_root_privileges

configure_netplan_for_using_network_manager(){
	echo "Configuring netplan for using NetworkManager ..."
	
	# See <https://askubuntu.com/questions/1009988/ubuntu-17-10-server-running-ubuntu-desktop-network-manager-will-not-detect-ethe>
	
	mv /etc/netplan/01-netcfg.yaml /etc/netplan/01-network-manager-all.yaml
	sed -i "/^\s+renderer:.*/  renderer: NetworkManager/" /etc/netplan/01-network-manager-all.yaml
	echo
	
	netplan generate
	netplan apply
	service network-manager restart
	
	echo
}

cd ${BASEDIR}
configure_netplan_for_using_network_manager 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
