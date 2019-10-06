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

copy_themes(){
	echo "Copying themes ..."
	
	cd "${RECIPE_DIR}"
	tar xzf Erthe-njames.tar.gz
	cp -R Erthe-njames /usr/share/themes
	chmod -R go+r /usr/share/themes/Erthe-njames
	find /usr/share/themes/Erthe-njames -type d | xargs chmod go+x
	
	cd "${RECIPE_DIR}"
	cp -R njames /usr/share/themes
	chmod -R go+r /usr/share/themes/njames
	find /usr/share/themes/njames -type d | xargs chmod go+x
	
	# Cleanup
	cd "${RECIPE_DIR}"
	rm -fr Erthe-njames
	
	echo
}

copy_themes 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
