#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

install_mate_power_manager_from_sources(){
	cd ${BASEDIR}
	
	echo "Installing Mate Power Manager from sources ..."
	
	# Dependencies
	apt-get install -y libtool-bin \
					   libmate-panel-applet-dev \
					   libgnome-keyring-dev \
					   libupower-glib-dev \
					   libnotify-dev \
					   libdbus-glib-1-dev \
					   libcanberra-dev \
					   libcanberra-gtk3-dev \
					   yelp-tools \
					   mate-common
	
	git clone https://github.com/mate-desktop/mate-power-manager
	cd ./mate-power-manager
	./autogen.sh
	make
	make install
	
	# Copy polkit policy file
	if [ -f "/usr/share/polkit-1/actions/org.mate.power.policy" ]; then
		backup_file rename /usr/share/polkit-1/actions/org.mate.power.policy
	fi
	cd ${BASEDIR}/mate-power-manager/policy
	REGEXP="@sbindir@/mate-power-backlight-helper"
	SED_ESCAPED_REGEXP=$(escape_sed_pattern "${REGEXP}")
	REPLACEMENT="/usr/local/sbin/mate-power-backlight-helper"
	SED_ESCAPED_REPLACEMENT=$(escape_sed_pattern "${REPLACEMENT}")
	cat ./org.mate.power.policy.in2 | sed "s/${SED_ESCAPED_REGEXP}/${SED_ESCAPED_REPLACEMENT}/g" > ./org.mate.power.policy
	cp ./org.mate.power.policy /usr/share/polkit-1/actions/
	service polkit restart
	
	# Cleaning
	cd ${BASEDIR}
	rm -fr ./mate-power-manager
}

cd ${BASEDIR}
install_mate_power_manager_from_sources 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
