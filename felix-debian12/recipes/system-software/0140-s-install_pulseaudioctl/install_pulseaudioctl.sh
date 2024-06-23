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

function install_pulseaudioctl_from_sources(){
	printf "Build and install pulseaudio-ctl <https://github.com/graysky2/pulseaudio-ctl>...\n"
	git clone https://github.com/graysky2/pulseaudio-ctl
	cd "${RECIPE_DIRECTORY}"
	cd pulseaudio-ctl
	make
	make install
	
	# Cleaning
	cd "${RECIPE_DIRECTORY}"
	rm -fr pulseaudio-ctl
	
	printf "\n"
}

cd "${RECIPE_DIRECTORY}"

# pulseaudio-ctl is not in the Debian repository
install_pulseaudioctl_from_sources 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
