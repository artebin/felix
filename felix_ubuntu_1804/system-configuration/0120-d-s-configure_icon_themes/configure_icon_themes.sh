#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIRECTORY\%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_not_root_privileges

install_customized_faenza(){
	echo "Installing custom Faenza icon theme ..."
	
	if [[ -d /usr/share/icon/Faenza-njames ]]; then
		echo "Directory /usr/share/icon/Faenza-njames already exists"
		return 1
	fi
	
	echo "Cloning git repository: <http://github.com/Kazhnuz/faenza-vanilla-icon-theme> ..."
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/Kazhnuz/faenza-vanilla-icon-theme
	
	echo "Fixing status icons in dark theme ..."
	cd "${RECIPE_DIRECTORY}"
	rm -fr faenza-vanilla-icon-theme/Faenza/status
	cp -R faenza-vanilla-icon-theme/Faenza-Dark/status faenza-vanilla-icon-theme/Faenza/status
	
	echo "Fixing 'list-remove' icons ..."
	cd "${RECIPE_DIRECTORY}"
	cp -R Faenza-fixed/actions/* faenza-vanilla-icon-theme/Faenza/actions
	
	echo "Fixing for Synaptic which persists to use its 16x16 icon => dirty fix: replace the 16x16 by the 32x32 icon ..."
	cd "${RECIPE_DIRECTORY}"
	backup_file rename faenza-vanilla-icon-theme/Faenza/apps/16/synaptic.png
	cp faenza-vanilla-icon-theme/Faenza/apps/32/synaptic.png ./faenza-vanilla-icon-theme/Faenza/apps/16/synaptic.png
	
	echo "Installing our customized Faenza ..."
	cd "${RECIPE_DIRECTORY}"
	sed -i "/^Name=/s/.*/Name=Faenza-njames/" faenza-vanilla-icon-theme/Faenza/index.theme
	ESCAPED_COMMENT=$(escape_sed_pattern "Comment=Icon theme project downloaded from https://github.com/Kazhnuz/faenza-vanilla-icon-theme and modified by njames")
	sed -i "/^Comment=/s/.*/${ESCAPED_COMMENT}/" faenza-vanilla-icon-theme/Faenza/index.theme
	mv faenza-vanilla-icon-theme/Faenza faenza-vanilla-icon-theme/Faenza-njames
	cp -R faenza-vanilla-icon-theme/Faenza-njames /usr/share/icons
	
	echo "Updating icon caches ..."
	update-icon-caches /usr/share/icons
	
	# Cleanup
	cd "${RECIPE_DIRECTORY}"
	rm -fr faenza-vanilla-icon-theme
	
	echo
}

install_customized_faenza 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
