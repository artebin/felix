#!/usr/bin/env bash

RECIPE_DIRECTORY="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_SH="$(eval find ./$(printf "{$(echo %{1..10}q,)}" | sed 's/ /\.\.\//g')/ -maxdepth 1 -name felix-common.sh)"
if [[ ! -f "${FELIX_SH}" ]]; then
	printf "Cannot find felix-common.sh\n"
	exit 1
fi
FELIX_SH="$(readlink -f "${FELIX_SH}")"
FELIX_ROOT="$(dirname "${FELIX_SH}")"
source "${FELIX_SH}"
initialize_recipe "${RECIPE_DIRECTORY}"

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
		printf "Cannot find FIREFOX_PREFS_JS_FILE: ${FIREFOX_PREFS_JS_FILE} => creating one!\n"
		touch "${FIREFOX_PREFS_JS_FILE}"
	fi
	
	printf "=> Allow legacy user profile customization (userChrome.css) ...\n"
	FIREFOX_PREF_KEY="toolkit.legacyUserProfileCustomizations.stylesheets"
	PREFIX_TO_SEARCH_REGEX="user_pref\(\"${FIREFOX_PREF_KEY}\""
	LINE_REPLACEMENT_VALUE="user_pref(\"${FIREFOX_PREF_KEY}\", true);"
	add_or_update_line_based_on_prefix "${PREFIX_TO_SEARCH_REGEX}" "${LINE_REPLACEMENT_VALUE}" "${FIREFOX_PREFS_JS_FILE}"
	
	printf "=> Copying chrome folder into default profile ...\n"
	cp -R ./chrome "${FIREFOX_DEFAULT_PROFILE_PATH}"
	
	printf "=> Disable GTK overlay scrollbars ...\n"
	FIREFOX_PREF_KEY="widget.gtk.overlay-scrollbars.enabled"
	PREFIX_TO_SEARCH_REGEX="user_pref\(\"${FIREFOX_PREF_KEY}\""
	LINE_REPLACEMENT_VALUE="user_pref(\"${FIREFOX_PREF_KEY}\", false);"
	add_or_update_line_based_on_prefix "${PREFIX_TO_SEARCH_REGEX}" "${LINE_REPLACEMENT_VALUE}" "${FIREFOX_PREFS_JS_FILE}"
	
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
	
	pre_install_extensions_in_firefox_profile "${FIREFOX_DEFAULT_PROFILE_PATH}"
	
	# Since Firefox ESR 60 it is mandatory to force the profile at the first execution of firefox
	# else it will create a new default profile.
	firefox -P "default" "about:profiles" >/dev/null 2>/dev/null &
	
	printf "\n"
}

pre_install_extensions_in_firefox_profile(){
	if [[ $# -ne 1 ]]; then
		printf "install_addons_in_firefox_profile() expects FIREROX_PROFILE_PATH in argument\n"
		exit 1
	fi
	FIREROX_PROFILE_PATH="${1}"
	
	printf "Pre-installing extension: AdBlocker Ultimate ...\n"
	cd "${RECIPE_DIRECTORY}"
	curl -O "https://addons.mozilla.org/firefox/downloads/file/3877418/adblocker_ultimate-3.7.15-an+fx.xpi"
	rename_xpi_file_with_web_extension_with_id adblocker_ultimate-3.7.15-an+fx.xpi
	
	printf "Pre-installing extension: Google Redirect Fixer Tracking Remover ...\n"
	curl -O "https://addons.mozilla.org/firefox/downloads/file/706680/google_redirects_fixer_tracking_remover-3.0.0-an+fx.xpi"
	rename_xpi_file_with_web_extension_with_id google_redirects_fixer_tracking_remover-3.0.0-an+fx.xpi
	
	printf "Pre-installing extension: Google Translator For Firefox ...\n"
	curl -O "https://addons.mozilla.org/firefox/downloads/file/1167275/google_translator_for_firefox-3.0.3.3-fx.xpi"
	rename_xpi_file_with_web_extension_with_id google_translator_for_firefox-3.0.3.3-fx.xpi
	
	printf "Pre-installing extension: RSS Preview ...\n"
	curl -O "https://addons.mozilla.org/firefox/downloads/file/3379752/rsspreview-3.10.1-an+fx.xpi"
	rename_xpi_file_with_web_extension_with_id rsspreview-3.10.1-an+fx.xpi
	
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

configure_firefox_default_profile 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
