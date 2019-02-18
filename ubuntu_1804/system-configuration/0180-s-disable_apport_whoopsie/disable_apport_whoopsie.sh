#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash
exit_if_has_not_root_privileges

disable_apport(){
	cd ${BASEDIR}
	
	echo "Disabling apport ..."
	APPORT_FILE="/etc/default/apport"
	if [ ! -f "${APPORT_FILE}" ]; then
		echo "Can not find file: ${APPORT_FILE}"
		exit 1
	else
		add_or_update_line_based_on_prefix "enabled=" "enabled=0" "${APPORT_FILE}"
	fi
	
	systemctl stop apport.service
	systemctl disable apport.service
	
	echo
}



disable_whoopsie(){
	cd ${BASEDIR}
	
	echo "Disabling whoopsie ..."
	
	# See <https://askubuntu.com/questions/135540/what-is-the-whoopsie-process-and-how-can-i-remove-it>
	
	WHOOPSIE_FILE="/etc/default/whoopsie"
	if [ ! -f "${WHOOPSIE_FILE}" ]; then
		cp whoopsie.conf "${WHOOPSIE_FILE}"
	else
		add_or_update_line_based_on_prefix "report_crashes=" "report_crashes=false" "${WHOOPSIE_FILE}"
	fi
	
	systemctl stop whoopsie.service
	systemctl disable whoopsie.service
	
	echo
}

cd ${BASEDIR}

disable_apport 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi

disable_whoopsie 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
