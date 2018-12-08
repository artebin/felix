#!/usr/bin/env bash

# NJ: 18-12-002: this recipe has been disabled because we now expect
# apport to be uninstalled.

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

disable_apport(){
	cd ${BASEDIR}
	
	echo "Disabling apport ..."
	sed -i "/^enabled=/s/.*/enabled=0/" /etc/default/apport
}

cd ${BASEDIR}
disable_apport 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
