#!/bin/bash

source ../../../common.sh
check_shell
exit_if_has_not_root_privileges

tune_power_save_functions(){
	cd ${BASEDIR}
	
	echo "Tuning power save functions ..."
	apt-get install -y powertop
	apt-get install -y tlp tlp-rdw
}

cd ${BASEDIR}
tune_power_save_functions 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
