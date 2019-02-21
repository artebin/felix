#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
RECIPE_FAMILY_DIR=$(retrieve_recipe_family_dir "${RECIPE_DIR}")
RECIPE_FAMILY_CONF_FILE=$(retrieve_recipe_family_conf_file "${RECIPE_DIR}")
if [[ ! -f "${RECIPE_FAMILY_CONF_FILE}" ]]; then
	printf "Cannot find RECIPE_FAMILY_CONF_FILE: ${RECIPE_FAMILY_CONF_FILE}\n"
	exit 1
fi
source "${RECIPE_FAMILY_CONF_FILE}"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash

configure_mate_caja(){
	cd ${RECIPE_DIR}
	
	echo "Configuring mate-caja ..."
	
	echo "Importing caja configuration in dconf ..."
	dconf load /org/mate/caja/ < ./org.mate.caja.dump
	dconf load /org/mate/desktop/ < ./org.mate.desktop.dump
	
	# For an unkown reason caja-open-terminal plugin is not using
	# x-terminal-emulator by default.
	# See <https://github.com/mate-desktop/caja-extensions/blob/master/open-terminal/caja-open-terminal.c>
	echo "Use x-terminal-emulator for \"Open in Terminal\" action ..."
	gsettings set org.mate.applications-terminal exec x-terminal-emulator
	
	echo "Adding caja scripts ..."
	if [ -d ~/.config/caja/scripts ]; then
	backup_file rename ~/.config/caja/scripts
	fi
	mkdir -p ~/.config/caja/scripts
	cp ./compare ~/.config/caja/scripts
	cp ./tail_and_follow ~/.config/caja/scripts
	cp ./tail_entirely_and_follow ~/.config/caja/scripts
	cp -R ./indentation ~/.config/caja/scripts
	
	echo
}



cd ${RECIPE_DIR}
configure_mate_caja 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
