#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash
exit_if_has_not_root_privileges

install_dstat_from_sources(){
	cd ${BASEDIR}
	
	echo "Install dstat from sources ..."
	git clone https://github.com/dagwieers/dstat
	cd dstat
	make
	make install
	
	cd ${BASEDIR}
	cp dstat-start-service.sh /usr/share/dstat
	cp dstat-stop-service.sh /usr/share/dstat
	cp dstat.logrotate /etc/logrotate.d/dstat
	cp dstat.service /etc/systemd/system/dstat.service
	systemctl daemon-reload
	
	# Cleaning
	cd ${BASEDIR}
	rm -fr dstat
	
	echo
}



cd ${BASEDIR}
install_dstat_from_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
