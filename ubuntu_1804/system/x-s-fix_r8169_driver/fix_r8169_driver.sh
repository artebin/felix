#!/usr/bin/env bash

source ../../ubuntu_1804.conf
is_bash
exit_if_has_not_root_privileges

fix_r8169_driver(){
	echo "Fixing driver r8169 ..."
	
	# Blacklist r8169
	#echo "\nblacklist r8169\n\n" >/etc/modprobe.d/blacklist.conf
	#add_or_update_line_based_on_prefix "^blacklist r8169$" "\n\nblacklist r8169\n\n" /etc/modprobe.d/blacklist.conf
	
	# Install r8168-dkms
	install_package_if_not_installed "r8168-dkms"
	
	# Add service for unloading the driver before suspend
	systemctl enable r8169_fix_before_suspend.service
	
	# Add sevice for loading the driver after suspend
	systemctl enable r8169_fix_after_suspend.service
	
	echo
}

cd ${BASEDIR}
fix_r8169_driver 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
