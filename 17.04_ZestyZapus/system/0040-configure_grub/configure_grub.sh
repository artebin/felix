#!/bin/bash

source ../../common.sh
check_shell
get_root_privileges

configure_grub(){
	cd ${BASEDIR}
	
	echo "Configuring grub ..."
	
	# Create a backup file
	GRUB_BACKUP_FILE_NAME=$(getFileNameForBackup '/etc/default/grub')
	echo "GRUB_BACKUP_FILE_NAME=${GRUB_BACKUP_FILE_NAME}"
	cp '/etc/default/grub' "${GRUB_BACKUP_FILE_NAME}"
	
	# Remove hidden timeout 0 => show grub
	echo 'Remove hidden timeout 0 => show grub'
	sed -i '/^GRUB_HIDDEN_TIMEOUT/s/.*/#GRUB_HIDDEN_TIMEOUT=0/' '/etc/default/grub'
	
	# Remove boot option "quiet" and "splash"
	echo 'Remove boot option "quiet" and "splash" ...'
	sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT=/s/.*/GRUB_CMDLINE_LINUX_DEFAULT=""/' '/etc/default/grub'
	
	# Force grub in console mode
	add_or_update_line_based_on_prefix '#GRUB_TERMINAL=' 'GRUB_TERMINAL=console' '/etc/default/grub'
	
	update-grub
}

cd ${BASEDIR}
configure_grub 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
