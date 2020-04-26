#!/usr/bin/env bash

declare -g RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
declare -g FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
init_recipe "${RECIPE_DIR}"

exit_if_not_bash
exit_if_has_not_root_privileges

install_fonts(){
	# Install font JetBrainsMono
	printf "%-50s : %s\n" "Installing font" "Droid"
	cd "${RECIPE_DIR}"
	cp fonts/Droid/* /usr/local/share/fonts/
	
	# Install font JetBrainsMono
	printf "%-50s : %s\n" "Installing font" "Montserrat"
	cd "${RECIPE_DIR}"
	cp fonts/Montserrat/* /usr/local/share/fonts/
	
	# Install font JetBrainsMono
	printf "%-50s : %s\n" "Installing font" "Roboto"
	cd "${RECIPE_DIR}"
	cp fonts/Roboto/* /usr/local/share/fonts/
	
	# Install font JetBrainsMono
	printf "%-50s : %s\n" "Installing font" "JetBrains Mono"
	git clone https://github.com/JetBrains/JetBrainsMono
	cp "${RECIPE_DIR}"/JetBrainsMono/ttf/*.ttf /usr/local/share/fonts
	cp -r "${RECIPE_DIR}"/JetBrainsMono/web/eot /usr/local/share/fonts
	cp -r "${RECIPE_DIR}"/JetBrainsMono/web/woff /usr/local/share/fonts
	cp -r "${RECIPE_DIR}"/JetBrainsMono/web/woff2 /usr/local/share/fonts
	
	# Update fond cache
	printf "Updating font cache ...\n"
	fc-cache -f -v 1>/dev/null
	
	# Clean
	cd "${RECIPE_DIR}"
	rm -fr JetBrainsMono
	
	printf "\n"
}

install_fonts 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
