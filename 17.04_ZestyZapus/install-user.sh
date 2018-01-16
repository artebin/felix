#!/bin/bash

if [ ! "${BASH_VERSION}" ] ; then
	echo "This script should run with bash" 1>&2
	exit 1
fi

source './common.sh'

if has_root_privileges; then
	echo 'This script should not be started with the root privileges'
	exit 1
fi

# Build your initial list of scripts with:
# find ./user/ -iname "*.sh" -exec sh -c "echo \'{}\' \\" \;|sort

USER_SCRIPT_PATH_ARRAY=( \
'./user/0000-configure_bash/configure_bash.sh' \
'./user/0010-configure_vim/configure_vim.sh' \
'./user/0011-configure_htop/configure_htop.sh' \
'./user/0020-configure_gtk/configure_gtk.sh' \
'./user/0030-configure_openbox/configure_openbox.sh' \
'./user/0040-configure_tint2/configure_tint2.sh' \
'./user/0050-configure_dmenu/configure_dmenu.sh' \
'./user/0060-configure_xfce4_power_manager/configure_xfce4_power_manager.sh' \
'./user/0070-configure_xfce4_thunar/configure_xfce4_thunar.sh' \
'./user/0080-configure_mate_terminal/configure_mate_terminal.sh' \
'./user/0090-configure_mate_caja/configure_mate_caja.sh' \
'./user/0100-configure_geany/configure_geany.sh' \
'./user/0110-configure_vlc/configure_vlc.sh' \
'./user/0120-configure_default_applications/configure_default_applications.sh' \
'./user/0121-configure_firefox_default_profile/configure_firefox_default_profile.sh' \
'./user/0130-install_dokuwiki_in_userdir/install_dokuwiki_in_userdir.sh' \
)

execute_all_user_scripts(){
	for SCRIPT_PATH in "${USER_SCRIPT_PATH_ARRAY[@]}"; do
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
		bash "./${SCRIPT_NAME}"
	done
}

check_xubuntu_version && (execute_all_system_scripts;execute_all_user_scripts)
