#!/usr/bin/env bash

source ../../xubuntu_18.04.sh
is_bash
exit_if_has_not_root_privileges

set_locale(){
	cd ${BASEDIR}
	
	echo "Generating locales ..."
	locale-gen ${LOCALES_TO_GENERATE}
	
	echo "Setting locales ..."
	update-locale LANG=${LOCALE_TO_USE_LANG}
	update-locale LC_NUMERIC=${LOCALE_TO_USE_LC_NUMERIC}
	update-locale LC_TIME=${LOCALE_TO_USE_LC_TIME}
	update-locale LC_MONETARY=${LOCALE_TO_USE_LC_MONETARY}
	update-locale LC_PAPER=${LOCALE_TO_USE_LC_PAPER}
	update-locale LC_NAME=${LOCALE_TO_USE_LC_NAME}
	update-locale LC_ADDRESS=${LOCALE_TO_USE_LC_ADDRESS}
	update-locale LC_TELEPHONE=${LOCALE_TO_USE_LC_TELEPHONE}
	update-locale LC_MEASUREMENT=${LOCALE_TO_USE_LC_MEASUREMENT}
	update-locale LC_IDENTIFICATION=${LOCALE_TO_USE_LC_IDENTIFICATION}
	
	echo
}

cd ${BASEDIR}

set_locale 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
