#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

nfs_samba_shares(){
	cd ${BASEDIR}
	
	echo "nfs samba shares ..."
	cat ./fstab_comments >>/etc/fstab
}

cd ${BASEDIR}
nfs_samba_shares 2>&1 | tee -a ./${SCRIPT_LOG_FILE_NAME}
