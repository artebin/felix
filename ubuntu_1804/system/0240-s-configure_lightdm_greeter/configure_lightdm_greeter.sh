#!/usr/bin/env bash

source ../../ubuntu_1804.conf
is_bash
exit_if_has_not_root_privileges

configure_lightdm_greeter(){
	echo "Configuring LightDM greeter ..."
	
	cd ${BASEDIR}
	
	backup_file rename /etc/lightdm/lightdm-gtk-greeter.conf
	
	# Copy some backgrounds free of use from unsplash <https://unsplash.com> 
	cp ./backgrounds/*.jpg /usr/share/backgrounds
	
	cp ./lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf
	
	echo
}

cd ${BASEDIR}

configure_lightdm_greeter 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
