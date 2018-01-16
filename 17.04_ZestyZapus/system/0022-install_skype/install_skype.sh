#!/bin/bash

source '../../common.sh'
check_shell
exit_if_has_not_root_privileges

install_skype(){
	cd "${BASEDIR}"
	
	echo 'Installing Skype from skype.com ...'
	wget 'https://go.skype.com/skypeforlinux-64.deb'
	dpkg -i 'skypeforlinux-64.deb'
	
	# Cleanup
	rm -f './skypeforlinux-64.deb'
}

cd "${BASEDIR}"
install_skype 2>&1 | tee -a "./${SCRIPT_LOG_NAME}"
