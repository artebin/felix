#!/usr/bin/env bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

configure_grub(){
	cd ${BASEDIR}
	
	echo "Configuring grub ..."
	
	# Backup grub configuration
	backup_file copy /etc/default/grub
	
	# Remove hidden timeout 0 => show grub
	echo "Remove hidden timeout 0 => show grub"
	sed -i "/^GRUB_TIMEOUT_STYLE/s/.*/#GRUB_TIMEOUT_STYLE=/" /etc/default/grub
	
	# Remove boot option "quiet" and "splash"
	echo "Remove boot option 'quiet' and 'splash' ..."
	sed -i "/^GRUB_CMDLINE_LINUX_DEFAULT=/s/.*/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/" /etc/default/grub
	
	update-grub
	
	echo
}

cd ${BASEDIR}

configure_grub 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
