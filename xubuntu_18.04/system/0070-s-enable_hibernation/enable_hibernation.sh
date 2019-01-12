#!/usr/bin/env bash

source ../../xubuntu_18.04.sh
is_bash
exit_if_has_not_root_privileges

enable_hibernation(){
	echo "Enable hibernation ..."
	
	# Add polkit authority for upower and logind
	cd ${BASEDIR}
	cp com.ubuntu.enable-hibernate.pkla /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla
	
	echo
}

configure_suspend_then_hibernation(){
	echo "Configuring suspend-then-hibernation ..."
	
	# Add or create file /etc/systemd/sleep.conf
	if [[ ! -f /etc/systemd/sleep.conf ]]; then
		cp sleep.conf /etc/systemd/sleep.conf
	else
		add_or_update_keyvalue /etc/systemd/sleep.conf "HibernateDelaySec" "300"
	fi
	
	# Configure logind
	echo "Set HandleLidSwitch=suspend ..."
	add_or_update_line_based_on_prefix '#*HandleLidSwitch=' 'HandleLidSwitch=suspend-then-hibernate' /etc/systemd/logind.conf
	
	# Restart the service
	systemctl restart systemd-logind.service
	
	echo
}

configure_suspend_sedation(){
	echo "Configuring suspend-sedation ..."
	
	# SystemdSuspendSedation
	# See <https://wiki.debian.org/SystemdSuspendSedation>
	
	# Adding service
	cd ${BASEDIR}
	cp suspend-sedation.service /etc/systemd/system/suspend-sedation.service
	systemctl start suspend-sedation
	systemctl enable suspend-sedation
	systemctl status suspend-sedation
	
	echo
}

cd ${BASEDIR}
enable_hibernation 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi

cd ${BASEDIR}
configure_suspend_then_hibernation 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi

#~ cd ${BASEDIR}
#~ configure_suspend_sedation 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
#~ EXIT_CODE="${PIPESTATUS[0]}"
#~ if [ "${EXIT_CODE}" -ne 0 ]; then
	#~ exit "${EXIT_CODE}"
#~ fi
