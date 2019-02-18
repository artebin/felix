#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf


LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE})"

exit_if_not_bash
exit_if_has_not_root_privileges

install_claws_mail_from_sources(){
	echo "Install Claws Mail from sources ..."
	
	# Install dependencies
	echo "Install dependencies for compilation ..."
	DEPENDENCIES=(  "libetpan-dev" \
					"libenchant-dev" \
					"libgdata-dev" \
					"libwebkitgtk-3.0-dev" \
					"libwebkitgtk-dev" )
	install_package_if_not_installed "${DEPENDENCIES[@]}"
	
	# Download and unpack the sources
	cd "${BASEDIR}"
	SOURCES_URL="https://www.claws-mail.org/download.php?file=releases/claws-mail-3.17.3.tar.bz2"
	SOURCES_PKG_FILE="claws-mail-3.17.3.tar.bz2"
	SOURCES_DIR="claws-mail-3.17.3"
	wget --content-disposition "${SOURCES_URL}"
	tar xjf "${SOURCES_PKG_FILE}"
	
	# Compile and install
	cd "${BASEDIR}/${SOURCES_DIR}"
	./configure
	make
	make install
	
	# Cleaning
	cd "${BASEDIR}"
	rm -fr "${SOURCES_DIR}"
	rm -fr "${SOURCES_PKG_FILE}"
	
	echo
}


cd "${BASEDIR}"
install_claws_mail_from_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
