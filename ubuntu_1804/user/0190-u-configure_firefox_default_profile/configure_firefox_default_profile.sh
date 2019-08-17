#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
RECIPE_FAMILY_DIR=$(retrieve_recipe_family_dir "${RECIPE_DIR}")
RECIPE_FAMILY_CONF_FILE=$(retrieve_recipe_family_conf_file "${RECIPE_DIR}")
if [[ ! -f "${RECIPE_FAMILY_CONF_FILE}" ]]; then
	printf "Cannot find RECIPE_FAMILY_CONF_FILE: ${RECIPE_FAMILY_CONF_FILE}\n"
	exit 1
fi
source "${RECIPE_FAMILY_CONF_FILE}"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash
exit_if_has_root_privileges
exit_if_no_x_session

configure_firefox_default_profile(){
	printf "Configuring Firefox default profile...\n"
	
	# Retrieve path to the Firefox default profile
	FIREFOX_DEFAULT_PROFILE_PATH=""
	if [[ -d "${HOME}/.mozilla/firefox" ]]; then
		FIREFOX_DEFAULT_PROFILE_PATH=$(find "${HOME}/.mozilla/firefox" -maxdepth 1 -iname "*\.default")
		printf "FIREFOX_DEFAULT_PROFILE_PATH: ${FIREFOX_DEFAULT_PROFILE_PATH}\n"
	fi
	if [[ -z "${FIREFOX_DEFAULT_PROFILE_PATH}" ]]; then
		printf "Cannot find Firefox default profile => creating one!\n"
		firefox -CreateProfile "default"
		FIREFOX_DEFAULT_PROFILE_PATH=$(find "${HOME}/.mozilla/firefox" -maxdepth 1 -iname "*\.default")
		printf "FIREFOX_DEFAULT_PROFILE_PATH: ${FIREFOX_DEFAULT_PROFILE_PATH}\n"
	fi
	
	FIREFOX_PREFS_JS_FILE="${FIREFOX_DEFAULT_PROFILE_PATH}/prefs.js"
	if [[ ! -f "${FIREFOX_PREFS_JS_FILE}" ]]; then
		printf "Cannot find FIREFOX_PREFS_JS_FILE: ${FIREFOX_PREFS_JS_FILE} => creation one!\n"
		touch "${FIREFOX_PREFS_JS_FILE}"
	fi
	
	printf "=> Show your windows and tabs from last time ...\n"
	FIREFOX_PREF_KEY="browser.startup.page"
	PREFIX_TO_SEARCH_REGEX="user_pref\(\"${FIREFOX_PREF_KEY}\""
	LINE_REPLACEMENT_VALUE="user_pref(\"${FIREFOX_PREF_KEY}\", 3);"
	add_or_update_line_based_on_prefix "${PREFIX_TO_SEARCH_REGEX}" "${LINE_REPLACEMENT_VALUE}" "${FIREFOX_PREFS_JS_FILE}"
	
	printf "=> Always ask you where to save files ...\n"
	FIREFOX_PREF_KEY="browser.download.useDownloadDir"
	PREFIX_TO_SEARCH_REGEX="user_pref\(\"${FIREFOX_PREF_KEY}\""
	LINE_REPLACEMENT_VALUE="user_pref(\"${FIREFOX_PREF_KEY}\", false);"
	add_or_update_line_based_on_prefix "${PREFIX_TO_SEARCH_REGEX}" "${LINE_REPLACEMENT_VALUE}" "${FIREFOX_PREFS_JS_FILE}"
	
	printf "=> Do not remember logins and passwords ...\n"
	FIREFOX_PREF_KEY="signon.rememberSignons"
	PREFIX_TO_SEARCH_REGEX="user_pref\(\"${FIREFOX_PREF_KEY}\""
	LINE_REPLACEMENT_VALUE="user_pref(\"${FIREFOX_PREF_KEY}\", false);"
	add_or_update_line_based_on_prefix "${PREFIX_TO_SEARCH_REGEX}" "${LINE_REPLACEMENT_VALUE}" "${FIREFOX_PREFS_JS_FILE}"
	
	printf "=> Do not trim URLs in the URL bar ...\n"
	FIREFOX_PREF_KEY="browser.urlbar.trimURLs"
	PREFIX_TO_SEARCH_REGEX="user_pref\(\"${FIREFOX_PREF_KEY}\""
	LINE_REPLACEMENT_VALUE="user_pref(\"${FIREFOX_PREF_KEY}\", false);"
	add_or_update_line_based_on_prefix "${PREFIX_TO_SEARCH_REGEX}" "${LINE_REPLACEMENT_VALUE}" "${FIREFOX_PREFS_JS_FILE}"
	
	printf "=> Do not show search engines in drop panel of the URL bar ...\n"
	FIREFOX_PREF_KEY="browser.urlbar.oneOffSearches"
	PREFIX_TO_SEARCH_REGEX="user_pref\(\"${FIREFOX_PREF_KEY}\""
	LINE_REPLACEMENT_VALUE="user_pref(\"${FIREFOX_PREF_KEY}\", false);"
	add_or_update_line_based_on_prefix "${PREFIX_TO_SEARCH_REGEX}" "${LINE_REPLACEMENT_VALUE}" "${FIREFOX_PREFS_JS_FILE}"
	
	printf "=> Do not search suggestions in drop panel of the URL bar ...\n"
	FIREFOX_PREF_KEY="browser.urlbar.searchSuggestionsChoice"
	PREFIX_TO_SEARCH_REGEX="user_pref\(\"${FIREFOX_PREF_KEY}\""
	LINE_REPLACEMENT_VALUE="user_pref(\"${FIREFOX_PREF_KEY}\", false);"
	add_or_update_line_based_on_prefix "${PREFIX_TO_SEARCH_REGEX}" "${LINE_REPLACEMENT_VALUE}" "${FIREFOX_PREFS_JS_FILE}"
	
	printf "=> Do not suggest searches in drop panel of the URL bar ...\n"
	FIREFOX_PREF_KEY="browser.urlbar.suggest.searches"
	PREFIX_TO_SEARCH_REGEX="user_pref\(\"${FIREFOX_PREF_KEY}\""
	LINE_REPLACEMENT_VALUE="user_pref(\"${FIREFOX_PREF_KEY}\", false);"
	add_or_update_line_based_on_prefix "${PREFIX_TO_SEARCH_REGEX}" "${LINE_REPLACEMENT_VALUE}" "${FIREFOX_PREFS_JS_FILE}"
	
	printf "=> Hide suggestions hint in drop panel of the URL bar ...\n"
	FIREFOX_PREF_KEY="browser.urlbar.timesBeforeHidingSuggestionsHint"
	PREFIX_TO_SEARCH_REGEX="user_pref\(\"${FIREFOX_PREF_KEY}\""
	LINE_REPLACEMENT_VALUE="user_pref(\"${FIREFOX_PREF_KEY}\", 0);"
	add_or_update_line_based_on_prefix "${PREFIX_TO_SEARCH_REGEX}" "${LINE_REPLACEMENT_VALUE}" "${FIREFOX_PREFS_JS_FILE}"
	
	printf "=> Disable all web push notifications ...\n"
	FIREFOX_PREF_KEY="permissions.default.desktop-notification"
	PREFIX_TO_SEARCH_REGEX="user_pref\(\"${FIREFOX_PREF_KEY}\""
	LINE_REPLACEMENT_VALUE="user_pref(\"${FIREFOX_PREF_KEY}\", 2);"
	add_or_update_line_based_on_prefix "${PREFIX_TO_SEARCH_REGEX}" "${LINE_REPLACEMENT_VALUE}" "${FIREFOX_PREFS_JS_FILE}"
	
	install_addons_in_firefox_profile "${FIREFOX_DEFAULT_PROFILE_PATH}"
	
	# Since Firefox ESR 60 it is mandatory to force the profile at the first execution of firefox
	# else it will create a new default profile.
	firefox -p "default" "about:profiles" >/dev/null 2>/dev/null &
	
	printf "\n"
}

install_addons_in_firefox_profile(){
	if [[ $# -ne 1 ]]; then
		printf "install_addons_in_firefox_profile() expects FIREROX_PROFILE_PATH in argument\n"
		exit 1
	fi
	FIREROX_PROFILE_PATH="${1}"
	
	printf "Pre-installing AdBlock Plus ...\n"
	cd "${RECIPE_DIR}"
	wget --quiet "https://eyeo.to/adblockplus/firefox_install/firefox" -O adblockplus.xpi
	rename_xpi_file_with_web_extension_with_id adblockplus.xpi
	
	printf "Pre-installing Google Search Link Fix ...\n"
	wget --quiet "https://addons.mozilla.org/firefox/downloads/file/3051379/google_search_link_fix-1.6.8-an+fx.xpi?src=dp-btn-primary" -O google_search_link_fix.xpi
	rename_xpi_file_with_web_extension_with_id google_search_link_fix.xpi
	
	printf "Pre-installing Google Translator For Firefox ...\n"
	wget --quiet "https://addons.mozilla.org/firefox/downloads/file/1167275/google_translator_for_firefox-3.0.3.3-fx.xpi?src=dp-btn-primary" -O google_translator_for_firefox.xpi
	rename_xpi_file_with_web_extension_with_id google_translator_for_firefox.xpi
	
	mkdir -p "${FIREROX_PROFILE_PATH}/extensions"
	mv *.xpi "${FIREROX_PROFILE_PATH}/extensions"
}

rename_xpi_file_with_web_extension_with_id(){
	if [[ $# -ne 1 ]]; then
		printf "rename_xpi_file_with_web_extension_with_id() expects XPI_FILE in argument\n"
		exit 1
	fi
	XPI_FILE="${1}"
	TMP_DIR=$(uuidgen)
	unzip -qq "${XPI_FILE}" -d "${TMP_DIR}"
	WEBEXTENSION_ID=$(cat ./${TMP_DIR}/manifest.json | jq '.applications.gecko.id' | sed 's/\"//g')
	mv "${XPI_FILE}" "${WEBEXTENSION_ID}.xpi"
	rm -fr "${TMP_DIR}"
}

configure_firefox_default_profile 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
