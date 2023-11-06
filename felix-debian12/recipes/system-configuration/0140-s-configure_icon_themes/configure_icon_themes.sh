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

install_customized_faenza(){
	printf "Installing custom Faenza icon theme...\n"
	
	if [[ -d /usr/share/icon/Faenza-njames ]]; then
		printf "Directory /usr/share/icon/Faenza-njames already exists\n"
		return 1
	fi
	
	printf "Cloning git repository: <http://github.com/Kazhnuz/faenza-vanilla-icon-theme>...\n"
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/Kazhnuz/faenza-vanilla-icon-theme
	
	printf "Fixing status icons in dark theme...\n"
	cd "${RECIPE_DIRECTORY}"
	rm -fr faenza-vanilla-icon-theme/Faenza/status
	cp -R faenza-vanilla-icon-theme/Faenza-Dark/status faenza-vanilla-icon-theme/Faenza/status
	
	printf "Fixing 'list-remove' icons...\n"
	cd "${RECIPE_DIRECTORY}"
	cp -R Faenza-fixed/actions/* faenza-vanilla-icon-theme/Faenza/actions
	
	printf "Fixing for Synaptic which persists to use its 16x16 icon => dirty fix: replace the 16x16 by the 32x32 icon...\n"
	cd "${RECIPE_DIRECTORY}"
	backup_file rename faenza-vanilla-icon-theme/Faenza/apps/16/synaptic.png
	cp faenza-vanilla-icon-theme/Faenza/apps/32/synaptic.png ./faenza-vanilla-icon-theme/Faenza/apps/16/synaptic.png
	
	printf "Installing our customized Faenza...\n"
	cd "${RECIPE_DIRECTORY}"
	sed -i "/^Name=/s/.*/Name=Faenza-njames/" faenza-vanilla-icon-theme/Faenza/index.theme
	ESCAPED_COMMENT=$(escape_sed_pattern "Comment=Icon theme project downloaded from https://github.com/Kazhnuz/faenza-vanilla-icon-theme and modified by njames")
	sed -i "/^Comment=/s/.*/${ESCAPED_COMMENT}/" faenza-vanilla-icon-theme/Faenza/index.theme
	mv faenza-vanilla-icon-theme/Faenza faenza-vanilla-icon-theme/Faenza-njames
	cp -R faenza-vanilla-icon-theme/Faenza-njames /usr/share/icons
	
	printf "Updating icon caches...\n"
	update-icon-caches /usr/share/icons
	
	# Cleanup
	cd "${RECIPE_DIRECTORY}"
	rm -fr faenza-vanilla-icon-theme
	
	printf "\n"
}

install_customized_faenza 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
