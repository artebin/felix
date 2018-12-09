#!/usr/bin/env bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

nfs_samba_shares(){
	cd ${BASEDIR}
	
	echo "nfs samba shares ..."
	cat ./fstab_comments >>/etc/fstab
	
	echo
}

cd ${BASEDIR}

nfs_samba_shares 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi