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

fix_backlight_after_suspend(){
	echo "Fixing backlight after suspend ..."
	
	# Install dependencies
	install_package_if_not_installed "elfutils" "libelf-dev"
	
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/patjak/mba6x_bl
	cd ./mba6x_bl
	make
	make install
	depmod -a
	modprobe mba6x_bl
	
	cd "${RECIPE_DIRECTORY}"
	cp 98-mba6bl.conf /usr/share/X11/xorg.conf.d/98-mba6bl.conf
	if [[ -f "/usr/share/X11/xorg.conf.d/20-intel.conf" ]]; then
		backup_file rename /usr/share/X11/xorg.conf.d/20-intel.conf
	fi
	
	# Cleaning
	cd "${RECIPE_DIRECTORY}"
	rm -rf ./mba6x_bl
	
	echo
}

fix_backlight_after_suspend 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
