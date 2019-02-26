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
LOCAL_MIRROR_ADDRESS="localhost:10001"

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

add_local_mirror_in_apt_sources(){
	echo "Adding the local mirror in APT sources ..."
	if [[ -f /etc/apt/sources.list.d/local_mirror.list ]]; then
		backup_file rename /etc/apt/sources.list.d/local_mirror.list
	fi
	cp "${RECIPE_DIR}/apt.sources.list" /etc/apt/sources.list.d/local_mirror.list
	sed -i "s|LOCAL_MIRROR_ADDRESS|${LOCAL_MIRROR_ADDRESS}|g" /etc/apt/sources.list.d/local_mirror.list
	echo
}

comment_all_default_apt_sources(){
	printf "Commenting all default sources in /etc/apt/sources.list ...\n"
	sed -i 's|^\([^#]\)|#\1|g' /etc/apt/sources.list
	printf "\n"
}

cd "${RECIPE_DIR}"
configure_apt_mirror 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi

cd "${RECIPE_DIR}"
add_local_mirror_in_apt_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi

cd "${RECIPE_DIR}"
comment_all_default_apt_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
