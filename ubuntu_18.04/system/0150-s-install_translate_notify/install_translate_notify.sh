#!/usr/bin/env bash

source ../../ubuntu_18.04.sh
is_bash
exit_if_has_not_root_privileges

install_translate_notify(){
	cd ${BASEDIR}
	
	echo "Install Translate-Notify ..."
	cp ./translate-notify.sh /usr/bin/translate-notify
	chmod a+x /usr/bin/translate-notify
	
	echo
}

cd ${BASEDIR}
install_translate_notify 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
