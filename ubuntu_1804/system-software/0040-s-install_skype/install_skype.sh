#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash
exit_if_has_not_root_privileges

install_skype(){
	echo "Installing Skype from skype.com ..."
	
	# Download the package and install it
	cd ${BASEDIR}
	wget https://go.skype.com/skypeforlinux-64.deb
	dpkg -i skypeforlinux-64.deb
	
	# Cleanup
	cd ${BASEDIR}
	rm -f ./skypeforlinux-64.deb
	rm -fr ~/.rpmdb
	rm -fr ~/.wget-hsts
	
	echo
}

fix_tray_icon(){
	# Fix the tiled tray icon/app indicator see <https://answers.microsoft.com/en-us/skype/forum/skype_linux-skype_startms-skype_installms/system-tray-icon-in-xfce/d3f162bf-0bbf-481b-90a1-f43cae9a86cc?page=5>
	cd ${BASEDIR}
	wget https://drive.google.com/open?id=1jWNVnN0gaaOqghhoa_t0WKPPZka4hAMC >app.asar
	cp app.asar /usr/share/skypeforlinux/resources/app.asar
}



cd ${BASEDIR}
install_skype 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
