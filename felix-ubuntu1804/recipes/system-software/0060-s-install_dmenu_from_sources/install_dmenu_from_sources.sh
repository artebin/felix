#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_SH="$(eval find ./$(printf "{$(echo %{1..10}q,)}" | sed 's/ /\.\.\//g')/ -maxdepth 1 -name felix.sh)"
if [[ ! -f "${FELIX_SH}" ]]; then
	printf "Cannot find felix.sh\n"
	exit 1
fi
FELIX_SH="$(readlink -f "${FELIX_SH}")"
FELIX_ROOT="$(dirname "${FELIX_SH}")"
source "${FELIX_SH}"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_not_root_privileges

install_dmenu_from_sources(){
	cd "${RECIPE_DIRECTORY}"
	
	echo "Installing dmenu from sources ..."
	tar xzf dmenu-4.7.tar.gz
	cp ./dmenu-lineheight-4.7.diff ./dmenu-4.7/
	cp ./dmenu-xyw-4.7.diff ./dmenu-4.7/
	
	cd ./dmenu-4.7
	patch < dmenu-lineheight-4.7.diff
	patch < dmenu-xyw-4.7.diff
	make
	make install
	
	# Cleanup
	cd "${RECIPE_DIRECTORY}"
	rm -fr ./dmenu-4.7/
	
	echo
}



cd "${RECIPE_DIRECTORY}"
install_dmenu_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
