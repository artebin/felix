#!/usr/bin/env bash

source ../../common.sh
check_shell
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

copy_themes 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
