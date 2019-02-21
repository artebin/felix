#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash
exit_if_has_not_root_privileges

install_additional_fonts(){
	echo "Installing additional fonts ..."
	
	cd "${RECIPE_DIR}"
	cp fonts/Droid/*.ttf /usr/local/share/fonts/
	cp fonts/Montserrat/*.otf /usr/local/share/fonts/
	cp fonts/Roboto/*.ttf /usr/local/share/fonts/
	
	echo "Updating font cache ..."
	fc-cache -f -v 1>/dev/null
	
	echo
}

install_additional_fonts 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
