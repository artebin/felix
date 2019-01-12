#!/usr/bin/env bash

source ../../xubuntu_18.04.sh
is_bash
exit_if_has_not_root_privileges

install_xfce4_power_manager_from_sources(){
	cd ${BASEDIR}
	
	echo "Installing Xfce4 Power Manager from sources ..."
	
	# Dependencies
	apt-get install -y xfce4-dev-tools \
					   libxfconf-0-dev \
					   libxfce4ui-2-dev \
					   libnotify-dev \
					   libupower-glib-dev
	
	# Clone git repository, compile and install
	git clone http://github.com/xfce-mirror/xfce4-power-manager
	cd xfce4-power-manager
	./autogen.sh
	make
	make install
	
	# Copy polkit policy file
	XFCE_POWER_POLICY_FILE="/usr/share/polkit-1/actions/org.xfce.power.policy"
	if [ -f "${XFCE_POWER_POLICY_FILE}" ]; then
		backup_file rename "${XFCE_POWER_POLICY_FILE}"
	fi
	cd ${BASEDIR}
	cd xfce4-power-manager/src
	cp org.xfce.power.policy "${XFCE_POWER_POLICY_FILE}"
	
	# Cleaning
	cd ${BASEDIR}
	rm -fr ./xfce4-power-manager
	
	echo
}

cd ${BASEDIR}

install_xfce4_power_manager_from_sources 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
