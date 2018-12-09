#!/usr/bin/env bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

process_package_install_list(){
	cd ${BASEDIR}
	
	echo "Installing packages ..."
	
	PACKAGES_LIST_FILE="./packages.install.minimal.list"
	
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
		PACKAGES_LINE=$(echo "${PACKAGES_LINE}"|awk '{$1=$1};1')
		if [ ! -z "${PACKAGES_LINE}" ]; then
			echo "${PACKAGES_LINE}"| tr " " "\n" >> "${APT_INPUT_FILE}"
		fi
	done < "${PACKAGES_LIST_FILE}"
	
	# Check package availability
	# Currently using `aptitude search` which is very slow. 
	# Furthermore it expects an argument which can follow a query language, i.e. `g++` will not work => for now only escaping '+'
	# See <https://wiki.debian.org/Aptitude#Advanced_search_patterns>
	# TODO: code should be improved later.
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
			ESCAPED_LINE=$(echo "${LINE}" | sed 's/\+/\\\+/g')
			PACKAGE_AVAILABILITY=`aptitude search "^${ESCAPED_LINE}\$"`
			if [ $? -eq 0 ]; then
				printf "     [\e[92m%s\e[0m] %s\n" "OK" "${LINE}"
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
	xargs apt -y install < "${APT_INPUT_FILE}"
	
	# Cleaning
	rm -f "${APT_INPUT_FILE}"
	
	echo
}

cd ${BASEDIR}

process_package_install_list 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
