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

configure_gtk2(){
	echo "Configuring GTK+ 2 ..."
	if [[ -f "${HOME}/.gtkrc-2.0" ]]; then
		backup_file rename "${HOME}/.gtkrc-2.0"
	fi
	cp "${RECIPE_FAMILY_DIR}/dotfiles/.gtkrc-2.0" "${HOME}/.gtkrc-2.0"
	
	echo "Setting gtk-theme-name: ${GTK_THEME_NAME} ..."
	sed -i "/^gtk-theme-name/s/.*/gtk-theme-name=\"${GTK_THEME_NAME}\"/" "${HOME}/.gtkrc-2.0"
	
	echo "Setting gtk-icon-theme-name: ${GTK_ICON_THEME_NAME} ..."
	sed -i "/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=\"${GTK_ICON_THEME_NAME}\"/" "${HOME}/.gtkrc-2.0"
}

configure_gtk3(){
	echo "Configuring GTK+ 3 ..."
	if [[ -d "${HOME}/.config/gtk-3.0" ]]; then
		backup_file rename "${HOME}/.config/gtk-3.0"
	fi
	mkdir -p "${HOME}/.config/gtk-3.0"
	cp "${RECIPE_FAMILY_DIR}/dotfiles/.config/gtk-3.0/settings.ini" "${HOME}/.config/gtk-3.0/settings.ini"
	
	echo "Setting gtk-theme-name ..."
	sed -i "/^gtk-theme-name/s/.*/gtk-theme-name=${GTK_THEME_NAME}/" "${HOME}/.config/gtk-3.0/settings.ini"
	
	echo "Setting gtk-icon-theme-name ..."
	sed -i "/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=${GTK_ICON_THEME_NAME}/" "${HOME}/.config/gtk-3.0/settings.ini"
	
	echo "Adding gtk.css ..."
	cp "${RECIPE_FAMILY_DIR}/dotfiles/.config/gtk-3.0/gtk.css" "${HOME}/.config/gtk-3.0/gtk.css"
	
	echo "Fix the sharing of bookmarks between GTK2 and GTK3 ..."
	touch "${HOME}/.gtk-bookmarks"
	ln -s "${HOME}/.gtk-bookmarks" "${HOME}/.config/gtk-3.0/bookmarks"
	
	echo
}

configure_gtk2 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi

configure_gtk3 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
