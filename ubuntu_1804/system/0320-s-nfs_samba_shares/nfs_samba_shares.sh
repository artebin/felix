#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf
is_bash
exit_if_has_not_root_privileges

nfs_samba_shares(){
	cd ${BASEDIR}
	
	echo "nfs samba shares ..."
	cat ./fstab_comments >>/etc/fstab
	
	echo
}

BASEDIR="$(dirname ${BASH_SOURCE})"

cd ${BASEDIR}
nfs_samba_shares 2>&1 | tee -a "$(retrieve_log_file_name ${BASH_SOURCE})"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
