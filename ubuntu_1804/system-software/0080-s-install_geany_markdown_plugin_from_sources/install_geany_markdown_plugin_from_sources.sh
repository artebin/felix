#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash
exit_if_has_not_root_privileges

install_geany_markdown_plugin_from_sources(){
	echo "Install Geany / Markdown plugin from sources ..."
	
	# Install dependencies
	apt-get install -y install intltool
	apt-get install -y libwebkit2gtk-4.0-dev
	
	# Clone git repository
	cd ${BASEDIR}
	git clone http://github.com/geany/geany-plugins
	
	# Compile and install
	cd ${BASEDIR}
	cd geany-plugins
	./autogen.sh
	./configure
	cd markdown
	make
	make install
	
	# Clean
	cd ${BASEDIR}
	rm -fr ./geany-plugins
	
	echo
}



cd ${BASEDIR}
install_geany_markdown_plugin_from_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
