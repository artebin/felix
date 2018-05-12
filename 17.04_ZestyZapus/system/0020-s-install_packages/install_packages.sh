#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

process_package_install_list(){
	cd ${BASEDIR}
	
	echo "Installing packages ..."
	
	PACKAGES_INSTALL_LIST_FILE="./packages.install.list"
	
	# Build apt input file, one package per line
	APT_INPUT_FILE="./apt.pkg.list"
	if [ -f "${APT_INPUT_FILE}" ]; then
		rm -f "${APT_INPUT_FILE}"
	fi
	while read LINE; do
		INDEX_OF_COMMENT=`expr index "${LINE}" '#'`
		if [ "${INDEX_OF_COMMENT}" -eq 0 ]; then
			PACKAGES_LINE=${LINE}
		else
			SUBSTRING_LENGTH=`expr ${INDEX_OF_COMMENT}-1`
			PACKAGES_LINE=${LINE:0:${SUBSTRING_LENGTH}}
		fi
		if [ ! -z "${PACKAGES_LINE}" ]; then
			echo "${PACKAGES_LINE}"| tr " " "\n" >> "${APT_INPUT_FILE}"
		fi
	done < "${PACKAGES_INSTALL_LIST_FILE}"
	
	# Check package availability
	# Currently using `aptitude search` which is very slow. Code should be improved later.
	if [ "${TEST_PACKAGE_AVAILABILITY}" == "true" ]; then
		apt-get install -y aptitude
		PACKAGE_MISSING_LIST_FILE="./packages.missing.list"
		if [ -f "${PACKAGE_MISSING_LIST_FILE}" ]; then
			rm -f "${PACKAGE_MISSING_LIST_FILE}"
		fi
		while read LINE; do
			if [ -z "${LINE}" ]; then
				continue;
			fi
			PACKAGE_AVAILABILITY=`aptitude search "^${LINE}\$"`
			if [ $? -eq 0 ]; then
				printf "[\e[92m%s\e[0m] %s\n" "OK" "${LINE}"
			else
				printf "[\e[91m%s\e[0m] %s\n" "MISSING" "${LINE}"
				echo "${LINE}" >> "${PACKAGE_MISSING_LIST_FILE}"
			fi
		done < "${APT_INPUT_FILE}"
		if [ -s "${PACKAGE_MISSING_LIST_FILE}" ]; then
			echo "Some packages are missing."
			echo "See ${PACKAGE_MISSING_LIST_FILE}"
			exit 1
		 fi
	fi
	
	# Proceed install
	xargs apt-get -y install < "${APT_INPUT_FILE}"
	
	# Cleaning
	rm -f "${APT_INPUT_FILE}"
}

cd ${BASEDIR}
process_package_install_list 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
exit "${PIPESTATUS[0]}"