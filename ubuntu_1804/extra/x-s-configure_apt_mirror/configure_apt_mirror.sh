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
exit_if_has_not_root_privileges

APT_MIRROR_BASE_PATH="/media/njames/FONDA-EXT4/UbuntuMirror/Bionic"

configure_apt_mirror(){
	echo "Configuring apt-mirror ..."
	if [[ -f /etc/apt/mirror.list ]]; then
		backup_file rename /etc/apt/mirror.list
	fi
	cp "${RECIPE_DIR}/apt.mirror.list" /etc/apt/mirror.list
	sed -i "s|APT_MIRROR_BASE_PATH|${APT_MIRROR_BASE_PATH}|g" /etc/apt/mirror.list
	
	printf "Once the mirror is complete, start a http server for the repository:\n"
	printf "  - go into APT_MIRROR_BASE_PATH/mirror/archive.ubuntu.com\n"
	printf "  - execute 'python -m SimpleHTTPServer 10001'\n"
	
	echo
}

cd "${RECIPE_DIR}"
configure_apt_mirror 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
