#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

force_numlock_tty(){
	cd ${BASEDIR}
	
	echo "Forcing numlock in tty ..."
	if [ -f /usr/bin/numlock ]; then
		echo "/usr/bin/numlock already exists"
		return 1
	fi
	cp ./numlock /usr/bin/numlock
	chmod a+x /usr/bin/numlock
	
	if [ -f /etc/systemd/system/numlock_tty.service ]; then
		echo "/etc/systemd/system/numlock_tty.service already exists"
		return 1
	fi
	cp ./numlock_tty.service /etc/systemd/system/numlock_tty.service
	systemctl daemon-reload
	systemctl start numlock_tty.service
	systemctl status numlock_tty.service
	systemctl enable numlock_tty.service
}

force_numlock_xorg(){
	cd ${BASEDIR}
	
	echo "Forcing numlock in X.org ..."
	apt-get install -y numlockx
	if [ -f /etc/lightdm/lightdm.conf.d/60-numlockx.conf ]; then
		echo "/etc/lightdm/lightdm.conf.d/60-numlockx.conf already exists"
		return 1
	else
		if [ ! -d /etc/lightdm/lightdm.conf.d ]; then
			mkdir /etc/lightdm/lightdm.conf.d
		fi
		cp ./60-numlockx.conf /etc/lightdm/lightdm.conf.d/60-numlockx.conf
	fi
}

cd ${BASEDIR}
force_numlock_tty 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
force_numlock_xorg 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
