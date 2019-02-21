#!/usr/bin/env bash

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${BASEDIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash
exit_if_has_not_root_privileges

copy_themes(){
	cd ${BASEDIR}
	
	echo "Copying themes ..."
	tar xzf Erthe-njames.tar.gz
	cp -R Erthe-njames /usr/share/themes
	cd /usr/share/themes
	chmod -R go+r ./Erthe-njames
	find ./Erthe-njames -type d | xargs chmod go+x
	
	cd ${BASEDIR}
	cp -R njames /usr/share/themes
	chmod -R go+r /usr/share/themes/njames
	
	# Cleanup
	cd ${BASEDIR}
	rm -fr Erthe-njames
	
	echo
}



cd ${BASEDIR}
copy_themes 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
