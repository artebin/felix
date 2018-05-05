#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

process_package_install_list(){
	cd ${BASEDIR}
	
	echo "Installing packages ..."
	
	APT_INPUT_FILE="./apt.pkg.list"
	
	if [ -f "${APT_INPUT_FILE}" ]; then
		rm -f "${APT_INPUT_FILE}"
	fi
	while read LINE; do
		INDEX_OF_COMMENT=`expr index "${LINE}" '#'`
		if [ "${INDEX_OF_COMMENT}" -eq 0 ]; then
			PACKAGE_LINE_LIST=${LINE}
		else
			SUBSTRING_LENGTH=`expr ${INDEX_OF_COMMENT}-1`
			PACKAGE_LINE_LIST=${LINE:0:${SUBSTRING_LENGTH}}
		fi
		if [ ! -z "${PACKAGE_LINE_LIST}" ]; then
			echo ${PACKAGE_LINE_LIST} >>"${APT_INPUT_FILE}"
		fi
	done < ./packages.install.list
	
	xargs apt-get -y install < "${APT_INPUT_FILE}"
	
	# Cleaning
	rm -f "${APT_INPUT_FILE}"
}

cd ${BASEDIR}
process_package_install_list 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
