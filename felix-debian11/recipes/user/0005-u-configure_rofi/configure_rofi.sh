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
exit_if_has_root_privileges

install_rofi_menus(){
	printf "Install rofi-menus from <https://github.com/adi1090x/rofi> under ${HOME}/config/rofi/rofi-menus\n"
	
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/adi1090x/rofi
	cd rofi
	FONT_DIRECTORY="${HOME}/.local/share/fonts"
	if [[ ! -d "${FONT_DIRECTORY}" ]]; then
		mkdir -p "${FONT_DIRECTORY}"
	fi
	cp -r ./fonts/* "${FONT_DIRECTORY}"
	ROFI_MENUS_DIRECTORY="${HOME}/.config/rofi/rofi-menus"
	if [[ -d "${ROFI_MENUS_DIRECTORY}" ]]; then
		mkdir -p "${ROFI_MENUS_DIRECTORY}.old"
	fi
	if [[ ! -d "${ROFI_MENUS_DIRECTORY}" ]]; then
		mkdir -p "${ROFI_MENUS_DIRECTORY}"
	fi
	cp -r 720p "${ROFI_MENUS_DIRECTORY}"
	cp -r 1080p "${ROFI_MENUS_DIRECTORY}"
	
	# Fix path in rofi-menus/720p
	cd "${ROFI_MENUS_DIRECTORY}"/720p
	find . -type f | xargs sed -i 's|$HOME/.config/rofi|$HOME/.config/rofi/rofi-menus/720p|g'
	
	# Fix path in rofi-menus/1080p
	cd "${ROFI_MENUS_DIRECTORY}"/1080p
	find . -type f | xargs sed -i 's|$HOME/.config/rofi|$HOME/.config/rofi/rofi-menus/1080p|g'
	
	# Cleanup
	cd "${RECIPE_DIRECTORY}"
	rm -fr rofi
	
	printf "\n"
}

install_rififi(){
	printf "Configure rififi ...\n"
	
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/artebin/rififi
	cp ./rififi/*.sh "${HOME}/.config/rofi"
	cp ./rififi/*.conf "${HOME}/.config/rofi"
	
	# Cleanup
	cd "${RECIPE_DIRECTORY}"
	rm -fr rififi
	
	printf "\n"
}

#install_rofi_menus 2>&1 | tee -a "${RECIPE_LOG_FILE}"
#EXIT_CODE="${PIPESTATUS[0]}"
#if [[ "${EXIT_CODE}" -ne 0 ]]; then
#	exit "${EXIT_CODE}"
#fi

install_rififi 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
