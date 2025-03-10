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

function install_fonts(){
	# Install font Droid
	printf "%-30s : %s\n" "Installing font" "Droid"
	cd "${RECIPE_DIRECTORY}"
	cp fonts/Droid/* /usr/local/share/fonts/
	
	# Install font Montserrat
	printf "%-30s : %s\n" "Installing font" "Montserrat"
	cd "${RECIPE_DIRECTORY}"
	cp fonts/Montserrat/* /usr/local/share/fonts/
	
	# Install font Roboto
	printf "%-30s : %s\n" "Installing font" "Roboto"
	cd "${RECIPE_DIRECTORY}"
	cp fonts/Roboto/* /usr/local/share/fonts/
	
	# Install font JetBrainsMono
	printf "%-30s : %s\n" "Installing font" "JetBrains Mono"
	git clone https://github.com/JetBrains/JetBrainsMono
	cp "${RECIPE_DIRECTORY}"/JetBrainsMono/fonts/otf/*.otf /usr/local/share/fonts
	cp "${RECIPE_DIRECTORY}"/JetBrainsMono/fonts/ttf/*.ttf /usr/local/share/fonts
	cp -r "${RECIPE_DIRECTORY}"/JetBrainsMono/fonts/webfonts/*.woff2 /usr/local/share/fonts
	
	# Update fond cache
	printf "Updating font cache...\n"
	fc-cache -f -v 1>/dev/null
	
	# Clean
	cd "${RECIPE_DIRECTORY}"
	rm -fr JetBrainsMono
	
	# Fix blurry text on dark background
	cp 99fix-blurry-text-on-dark-background.conf /etc/environment.d
	
	printf "\n"
}

install_fonts 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
