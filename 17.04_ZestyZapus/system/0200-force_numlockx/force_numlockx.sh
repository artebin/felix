#!/bin/bash

source ../../common.sh
check_shell
get_root_privileges

force_numlockx(){
	cd ${BASEDIR}
	
	echo "Forcing numlockx ..."
	apt-get install -y numlockx
	if [ -f /etc/lightdm/lightdm.conf.d/60-force_numlockx.conf ]; then
		printf "/etc/lightdm/lightdm.conf.d/60-force_num_lockx.conf already exists"
		exit 1
	else
		if [ ! -d /etc/lightdm/lightdm.conf.d ]; then
			mkdir /etc/lightdm/lightdm.conf.d
		fi
		cp ./60-force_numlockx.conf /etc/lightdm/lightdm.conf.d/60-force_numlockx.conf
	fi
}

cd ${BASEDIR}
force_numlockx 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
