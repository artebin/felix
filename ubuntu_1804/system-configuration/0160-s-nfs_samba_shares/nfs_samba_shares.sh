#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash
exit_if_has_not_root_privileges

nfs_samba_shares(){
	cd ${BASEDIR}
	
	echo "nfs samba shares ..."
	cat ./fstab_comments >>/etc/fstab
	
	echo
}



cd ${BASEDIR}
nfs_samba_shares 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
