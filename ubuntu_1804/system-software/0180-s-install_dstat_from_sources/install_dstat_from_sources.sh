#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash
exit_if_has_not_root_privileges

install_dstat_from_sources(){
	echo "Installing dstat from sources ..."
	
	echo "Cloning git repository <https://github.com/dagwieers/dstat> ..."
	cd "${RECIPE_DIR}"
	git clone https://github.com/dagwieers/dstat
	
	echo "Compiling and installing ..."
	cd "${RECIPE_DIR}"
	cd dstat
	make
	make install
	
	echo "Installing dstat service (but it will not be enabled or started) ..."
	cd "${RECIPE_DIR}"
	cp dstat-start-service.sh /usr/share/dstat
	cp dstat-stop-service.sh /usr/share/dstat
	cp dstat.logrotate /etc/logrotate.d/dstat
	cp dstat.service /etc/systemd/system/dstat.service
	systemctl daemon-reload
	
	echo "Cleaning ..."
	cd "${RECIPE_DIR}"
	rm -fr dstat
	
	echo
}

install_dstat_from_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
