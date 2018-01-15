#!/bin/bash

source ../../common.sh
check_shell

configure_firefox_default_profile(){
	cd ${BASEDIR}
	
	echo "Configuring Firefox ..."
	
	# Retrieve path to the Firefox default profile
	PREFS_JS_PATH=""
	FIREFOX_DEFAULT_PROFILE_PATH=$(find ~/.mozilla/firefox -maxdepth 1 -iname "*\.default")
	if [ -f "${FIREFOX_DEFAULT_PROFILE_PATH}/prefs.js" ]; then
		PREFS_JS_PATH="${FIREFOX_DEFAULT_PROFILE_PATH}/prefs.js"
	fi
	
	if [ ! -f "${PREFS_JS_PATH}" ]; then
		echo "Can not find Firefox default profile => creating one ..."
		firefox -CreateProfile "default"
		
		FIREFOX_DEFAULT_PROFILE_PATH=$(find ~/.mozilla/firefox -maxdepth 1 -iname "*\.default")
		if [ -f "${FIREFOX_DEFAULT_PROFILE_PATH}/prefs.js" ]; then
			PREFS_JS_PATH="${FIREFOX_DEFAULT_PROFILE_PATH}/prefs.js"
		fi
	
		if [ ! -f "${PREFS_JS_PATH}" ]; then
			echo "Can not find Firefox default profile"
			exit 1
		fi
	fi
	
	echo "Configuring Firefox default profile ${PREFS_JS_PATH} ..."
	
	echo 'Setting "Show your windows and tabs from last time" ...'
	KEY='browser.startup.page'
	PREFIX_TO_SEARCH='user_pref("browser.startup.page"'
	LINE_REPLACEMENT_VALUE='user_pref("browser.startup.page", 3);'
	if grep -q "${KEY}" "${PREFS_JS_PATH}"; then
		sed -i "/^${PREFIX_TO_SEARCH}/s/.*/${LINE_REPLACEMENT_VALUE}/" "${PREFS_JS_PATH}"
	else
		echo "${LINE_REPLACEMENT_VALUE}" >> "${PREFS_JS_PATH}"
	fi
	
	echo 'Setting "Always ask you where to save files" ...'
	KEY='browser.download.useDownloadDir'
	PREFIX_TO_SEARCH='user_pref("browser.download.useDownloadDir"'
	LINE_REPLACEMENT_VALUE='user_pref("browser.download.useDownloadDir", false);'
	if grep -q "${KEY}" "${PREFS_JS_PATH}"; then
		sed -i "/^${PREFIX_TO_SEARCH}/s/.*/${LINE_REPLACEMENT_VALUE}/" "${PREFS_JS_PATH}"
	else
		echo "${LINE_REPLACEMENT_VALUE}" >> "${PREFS_JS_PATH}"
	fi
	
	echo 'Setting "Do not remember logins and passwords" ...'
	KEY='signon.rememberSignons'
	PREFIX_TO_SEARCH='user_pref("signon.rememberSignons"'
	LINE_REPLACEMENT_VALUE='user_pref("signon.rememberSignons", false);'
	if grep -q "${KEY}" "${PREFS_JS_PATH}"; then
		sed -i "/^${PREFIX_TO_SEARCH}/s/.*/${LINE_REPLACEMENT_VALUE}/" "${PREFS_JS_PATH}"
	else
		echo "${LINE_REPLACEMENT_VALUE}" >> "${PREFS_JS_PATH}"
	fi
}

cd ${BASEDIR}
configure_firefox_default_profile 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
