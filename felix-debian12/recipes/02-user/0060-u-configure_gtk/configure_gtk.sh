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

exit_if_not_bash
exit_if_has_root_privileges

function configure_gtk2(){
	printf "Configuring GTK2 ...\n"
	
	backup_by_rename_if_exists_and_copy_replacement "${HOME}/.gtkrc-2.0" "${FELIX_ROOT}/user-dotfiles/.gtkrc-2.0"
	
	if [[ -z "${GTK_CURSOR_THEME_NAME}" ]]; then
		GTK_CURSOR_THEME_NAME="adwaita"
	fi
	printf "Setting gtk-cursor-theme-name: ${GTK_CURSOR_THEME_NAME} ...\n"
	sed -i "/^gtk-cursor-theme-name/s/.*/gtk-cursor-theme-name=\"${GTK_CURSOR_THEME_NAME}\"/" "${HOME}/.gtkrc-2.0"
	
	if [[ -z "${GTK_THEME_NAME}" ]]; then
		GTK_THEME_NAME="adwaita"
	fi
	printf "Setting gtk-theme-name: ${GTK_THEME_NAME} ...\n"
	sed -i "/^gtk-theme-name/s/.*/gtk-theme-name=\"${GTK_THEME_NAME}\"/" "${HOME}/.gtkrc-2.0"
	
	if [[ -z "${GTK_ICON_THEME_NAME}" ]]; then
		GTK_ICON_THEME_NAME="adwaita"
	fi
	printf "Setting gtk-icon-theme-name: ${GTK_ICON_THEME_NAME} ...\n"
	sed -i "/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=\"${GTK_ICON_THEME_NAME}\"/" "${HOME}/.gtkrc-2.0"
	
	printf "\n"
}

function configure_gtk3(){
	printf "Configuring GTK3 ...\n"
	
	if [[ ! -d "${HOME}/.config/gtk-3.0" ]]; then
		mkdir -p "${HOME}/.config/gtk-3.0"
	fi
	backup_by_rename_if_exists_and_copy_replacement "${HOME}/.config/gtk-3.0/settings.ini" "${FELIX_ROOT}/user-dotfiles/.config/gtk-3.0/settings.ini"
	
	if [[ -z "${GTK_CURSOR_THEME_NAME}" ]]; then
		GTK_CURSOR_THEME_NAME="Adwaita"
	fi
	printf "Setting gtk-cursor-theme-name ...\n"
	sed -i "/^gtk-cursor-theme-name/s/.*/gtk-cursor-theme-name=${GTK_CURSOR_THEME_NAME}/" "${HOME}/.config/gtk-3.0/settings.ini"
	
	if [[ -z "${GTK_THEME_NAME}" ]]; then
		GTK_THEME_NAME="Adwaita"
	fi
	printf "Setting gtk-theme-name ...\n"
	sed -i "/^gtk-theme-name/s/.*/gtk-theme-name=${GTK_THEME_NAME}/" "${HOME}/.config/gtk-3.0/settings.ini"
	
	if [[ -z "${GTK_ICON_THEME_NAME}" ]]; then
		GTK_ICON_THEME_NAME="adwaita"
	fi
	printf "Setting gtk-icon-theme-name ...\n"
	sed -i "/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=${GTK_ICON_THEME_NAME}/" "${HOME}/.config/gtk-3.0/settings.ini"
	
	printf "Adding gtk.css ...\n"
	cp "${FELIX_ROOT}/user-dotfiles/.config/gtk-3.0/gtk.css" "${HOME}/.config/gtk-3.0/gtk.css"
	
	printf "Fix the sharing of bookmarks between GTK2 and GTK3 ...\n"
	touch "${HOME}/.gtk-bookmarks"
	if [[ -e "${HOME}/.config/gtk-3.0/bookmarks" ]]; then
		rm -f "${HOME}/.config/gtk-3.0/bookmarks"
	fi
	ln -s "${HOME}/.gtk-bookmarks" "${HOME}/.config/gtk-3.0/bookmarks"
	
	printf "\n"
}

function configure_gtk4(){
	printf "Configuring GTK4 ...\n"
	
	if [[ ! -d "${HOME}/.config/gtk-4.0" ]]; then
		mkdir -p "${HOME}/.config/gtk-4.0"
	fi
	backup_by_rename_if_exists_and_copy_replacement "${HOME}/.config/gtk-4.0/settings.ini" "${FELIX_ROOT}/user-dotfiles/.config/gtk-4.0/settings.ini"
	
	if [[ -z "${GTK_CURSOR_THEME_NAME}" ]]; then
		GTK_CURSOR_THEME_NAME="Adwaita"
	fi
	printf "Setting gtk-cursor-theme-name ...\n"
	sed -i "/^gtk-cursor-theme-name/s/.*/gtk-cursor-theme-name=${GTK_CURSOR_THEME_NAME}/" "${HOME}/.config/gtk-4.0/settings.ini"
	
	if [[ -z "${GTK_THEME_NAME}" ]]; then
		GTK_THEME_NAME="Adwaita"
	fi
	printf "Setting gtk-theme-name ...\n"
	sed -i "/^gtk-theme-name/s/.*/gtk-theme-name=${GTK_THEME_NAME}/" "${HOME}/.config/gtk-4.0/settings.ini"
	
	if [[ -z "${GTK_ICON_THEME_NAME}" ]]; then
		GTK_ICON_THEME_NAME="adwaita"
	fi
	printf "Setting gtk-icon-theme-name ...\n"
	sed -i "/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=${GTK_ICON_THEME_NAME}/" "${HOME}/.config/gtk-4.0/settings.ini"
	
	printf "Adding gtk.css ...\n"
	cp "${FELIX_ROOT}/user-dotfiles/.config/gtk-4.0/gtk.css" "${HOME}/.config/gtk-4.0/gtk.css"
	
	printf "Fix the sharing of bookmarks between GTK2 and GTK4 ...\n"
	touch "${HOME}/.gtk-bookmarks"
	if [[ -e "${HOME}/.config/gtk-4.0/bookmarks" ]]; then
		rm -f "${HOME}/.config/gtk-4.0/bookmarks"
	fi
	ln -s "${HOME}/.gtk-bookmarks" "${HOME}/.config/gtk-4.0/bookmarks"
	
	printf "\n"
}

configure_gtk2 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi

configure_gtk3 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi

configure_gtk4 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
