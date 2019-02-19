#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash
exit_if_has_not_root_privileges

install_pasystray(){
	echo "Installing pasystray from sources ..."
	
	# Install dependencies
	DEPENDENCIES=(  "libavahi-client-dev"
					"libavahi-common-dev"
					"libavahi-compat-libdnssd-dev"
					"libavahi-core-dev"
					"libavahi-glib-dev"
					"libavahi-gobject-dev"
					"libavahi-ui-gtk3-dev"
					"libappindicator-dev"
					"libappindicator3-dev" )
	install_package_if_not_installed "${DEPENDENCIES[@]}"
	
	# Clone git repository <https://github.com/christophgysin/pasystray>
	cd "${BASEDIR}"
	git clone https://github.com/christophgysin/pasystray
	
	# Compile and install
	cd "${BASEDIR}"
	cd pasystray
	./bootstrap.sh
	./configure
	make
	make install
	
	# Cleanup
	cd "${BASEDIR}"
	rm -fr pasystray
	
	echo
}

cd "${BASEDIR}"
install_pasystray 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
