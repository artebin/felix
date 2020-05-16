#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIRECTORY%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_not_root_privileges

process_package_remove_list(){
	cd "${RECIPE_DIRECTORY}"
	
	echo "Remove unwanted packages ..."
	
	PACKAGES_LIST_FILE="./packages.remove.list"
	
	# Build apt input file, one package per line
	APT_INPUT_FILE="./apt.pkg.list"
	if [ -f "${APT_INPUT_FILE}" ]; then
		rm -f "${APT_INPUT_FILE}"
	fi
	while read LINE; do
		INDEX_OF_COMMENT=`expr index "${LINE}" '#'`
		if [[ "${INDEX_OF_COMMENT}" -eq 0 ]]; then
			PACKAGES_LINE=${LINE}
		else
			SUBSTRING_LENGTH=`expr ${INDEX_OF_COMMENT}-1`
			PACKAGES_LINE=${LINE:0:${SUBSTRING_LENGTH}}
		fi
		PACKAGES_LINE=$(echo "${PACKAGES_LINE}"|awk '{$1=$1};1')
		if [[ ! -z "${PACKAGES_LINE}" ]]; then
			echo "${PACKAGES_LINE}"| tr " " "\n" >> "${APT_INPUT_FILE}"
		fi
	done < "${PACKAGES_LIST_FILE}"
	
	xargs apt-get -y --purge remove < "${APT_INPUT_FILE}"
	apt-get -y autoremove
	
	# Cleaning
	cd "${RECIPE_DIRECTORY}"
	rm -f "${APT_INPUT_FILE}"
	
	echo
}



cd "${RECIPE_DIRECTORY}"
process_package_remove_list 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
