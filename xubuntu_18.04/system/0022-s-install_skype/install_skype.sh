#!/usr/bin/env bash

source ../../xubuntu_18.04.sh
is_bash
exit_if_has_not_root_privileges

install_skype(){
	cd ${BASEDIR}
	
	echo "Installing Skype from skype.com ..."
	wget https://go.skype.com/skypeforlinux-64.deb
	dpkg -i skypeforlinux-64.deb
	
	# Cleanup
	cd ${BASEDIR}
	rm -f ./skypeforlinux-64.deb
	rm -fr ~/.rpmdb
	rm -fr ~/.wget-hsts
	
	echo
}

cd ${BASEDIR}
install_skype 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
