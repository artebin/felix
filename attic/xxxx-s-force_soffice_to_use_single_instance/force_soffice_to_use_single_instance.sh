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

force_soffice_to_use_single_instance(){
	printf "Force soffice to use single instance...\n"
	
	cp soffice_single_instance.sh /usr/local/bin
	chmod 755 /usr/local/bin/soffice_single_instance.sh
	update-alternatives --install /usr/bin/soffice soffice /usr/local/bin/soffice_single_instance.sh 10
	
	printf "\n"
}

exit_if_not_bash
exit_if_has_not_root_privileges

force_soffice_to_use_single_instance 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
