#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIRECTORY%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_not_root_privileges

install_fonts(){
	# Install font JetBrainsMono
	printf "%-30s : %s\n" "Installing font" "Droid"
	cd "${RECIPE_DIRECTORY}"
	cp fonts/Droid/* /usr/local/share/fonts/
	
	# Install font JetBrainsMono
	printf "%-30s : %s\n" "Installing font" "Montserrat"
	cd "${RECIPE_DIRECTORY}"
	cp fonts/Montserrat/* /usr/local/share/fonts/
	
	# Install font JetBrainsMono
	printf "%-30s : %s\n" "Installing font" "Roboto"
	cd "${RECIPE_DIRECTORY}"
	cp fonts/Roboto/* /usr/local/share/fonts/
	
	# Install font JetBrainsMono
	printf "%-30s : %s\n" "Installing font" "JetBrains Mono"
	git clone https://github.com/JetBrains/JetBrainsMono
	cp "${RECIPE_DIRECTORY}"/JetBrainsMono/fonts/otf/*.otf /usr/local/share/fonts
	cp "${RECIPE_DIRECTORY}"/JetBrainsMono/fonts/ttf/*.ttf /usr/local/share/fonts
	cp -r "${RECIPE_DIRECTORY}"/JetBrainsMono/fonts/webfonts/*.woff /usr/local/share/fonts
	cp -r "${RECIPE_DIRECTORY}"/JetBrainsMono/fonts/webfonts/*.woff2 /usr/local/share/fonts
	
	# Update fond cache
	printf "Updating font cache...\n"
	fc-cache -f -v 1>/dev/null
	
	# Clean
	cd "${RECIPE_DIRECTORY}"
	rm -fr JetBrainsMono
	
	printf "\n"
}

install_fonts 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
