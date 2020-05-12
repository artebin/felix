#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
init_recipe "${RECIPE_DIR}"

exit_if_not_bash
exit_if_has_not_root_privileges

LOCAL_MIRROR_ADDRESS="localhost:10001"

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
