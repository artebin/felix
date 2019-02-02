#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf
is_bash

configure_tint2(){
	cd ${BASEDIR}
	
	echo "Configuring tint2 ..."
	if [ -f ~/.config/tint2 ]; then
		backup_file rename ~/.config/tint2
	fi
	mkdir -p ~/.config/tint2
	cp tint2rc ~/.config/tint2/tint2rc
	
	if [ -f ~/.config/gsimplecal/config ]; then
		backup_file rename ~/.config/gsimplecal/config
	fi
	mkdir -p ~/.config/gsimplecal
	
	cp gsimplecal.config.template gsimplecal.config
	SED_PATTERN="LOCAL_TIME_ZONE"
	ESCAPED_SED_PATTERN=$(escape_sed_pattern ${SED_PATTERN})
	REPLACEMENT_STRING="${LOCAL_TIME_ZONE}"
	ESCAPED_REPLACEMENT_STRING=$(escape_sed_pattern ${REPLACEMENT_STRING})
	sed -i "s/${ESCAPED_SED_PATTERN}/${ESCAPED_REPLACEMENT_STRING}/g" ./gsimplecal.config
	cp gsimplecal.config ~/.config/gsimplecal/config
	
	# Cleaning
	cd ${BASEDIR}
	rm -f gsimplecal.config
	
	echo
}

BASEDIR="$(dirname ${BASH_SOURCE})"

cd ${BASEDIR}
configure_tint2 2>&1 | tee -a "$(retrieve_log_file_name ${BASH_SOURCE})"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
