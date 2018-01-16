#!/bin/bash

if [ ! "${BASH_VERSION}" ] ; then
	echo "This script should run with bash" 1>&2
	exit 1
fi

source './common.sh'

# Build your initial list of scripts with:
# find ./system/ -iname "*.sh" -exec sh -c "echo \'{}\' \\" \;|sort

SYSTEM_SCRIPT_PATH_ARRAY=( \
'./system/0000-language_support/language_support.sh' \
'./system/0001-regional_formats/regional_formats.sh' \
'./system/0010-upgrade_system/upgrade_system.sh' \
'./system/0020-install_packages/install_packages.sh' \
'./system/0021-install_google_chome/install_google_chrome.sh' \
'./system/0022-install_skype/install_skype.sh' \
'./system/0023-install_dockbarx/install_dockbarx.sh' \
'./system/0024-configure_php_in_userdir/configure_php_in_userdir.sh' \
'./system/0025-install_sqlitebrowser/install_sqlitebrowser.sh' \
'./system/0030-remove_unwanted_packages/remove_unwanted_packages.sh' \
'./system/0040-configure_grub/configure_grub.sh' \
'./system/0050-disable_apport/disable_apport.sh' \
'./system/0060-configure_bash_for_root/configure_bash_for_root.sh' \
'./system/0070-enable_hibernation/enable_hibernation.sh' \
'./system/0080-configure_alternatives/configure_alternatives.sh' \
'./system/0090-add_lightdm_greeter_badges/add_lightdm_greeter_badges.sh' \
'./system/0100-install_gtk_themes/install_gtk_themes.sh' \
'./system/0110-configure_gtk/configure_gtk.sh' \
'./system/0120-configure_icon_themes/configure_icon_themes.sh' \
'./system/0121-install_fonts/install_fonts.sh' \
'./system/0122-configure_lightdm_greeter/configure_lightdm_greeter.sh' \
'./system/0130-install_pasystray_from_sources/install_pasystray_from_sources.sh' \
'./system/0170-configure_ssh_welcome_text/configure_ssh_welcome_text.sh' \
'./system/0200-force_numlockx/force_numlockx.sh' \
)

execute_all_system_scripts(){
	for SCRIPT_PATH in "${SYSTEM_SCRIPT_PATH_ARRAY[@]}"; do
		cd "${BASEDIR}"
		SCRIPT_NAME=$(basename "${SCRIPT_PATH}")
		echo "SCRIPT_NAME=${SCRIPT_NAME}"
		
		SCRIPT_PATH=$(readlink -f "${SCRIPT_PATH}")
		echo "SCRIPT_PATH=${SCRIPT_PATH}"
		
		SCRIPT_BASE_DIRECTORY=$(dirname "${SCRIPT_PATH}")
		echo "SCRIPT_BASE_DIRECTORY=${SCRIPT_BASE_DIRECTORY}"
		
		SCRIPT_LOG_NAME="${SCRIPT_NAME%.*}.log.$(date +'%y%m%d-%H%M%S')"
		echo "SCRIPT_LOG_NAME=${SCRIPT_LOG_NAME}"
		
		cd "${SCRIPT_BASE_DIRECTORY}"
		sudo bash "./${SCRIPT_NAME}"
	done
}

check_xubuntu_version && execute_all_system_scripts
