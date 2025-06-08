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
exit_if_has_not_root_privileges

function configure_gtk2(){
	printf "Configuring GTK2 ...\n"
	if [[ -f /etc/gtk-2.0/gtkrc ]]; then
		backup_file rename /etc/gtk-2.0/gtkrc
	fi
	
	cp "${FELIX_ROOT}/user-dotfiles/.gtkrc-2.0" /etc/gtk-2.0/gtkrc
	chmod 755 /etc/gtk-2.0/gtkrc
	
	if [[ -z "${GTK_CURSOR_THEME_NAME}" ]]; then
		GTK_CURSOR_THEME_NAME="Adwaita"
	fi
	printf "Setting gtk-cursor-theme-name: ${GTK_CURSOR_THEME_NAME} ...\n"
	sed -i "/^gtk-cursor-theme-name/s/.*/gtk-cursor-theme-name=\"${GTK_CURSOR_THEME_NAME}\"/" /etc/gtk-2.0/gtkrc
	
	if [[ -z "${GTK_THEME_NAME}" ]]; then
		GTK_THEME_NAME="Adwaita"
	fi
	printf "Setting gtk-theme-name: ${GTK_THEME_NAME} ...\n"
	sed -i "/^gtk-theme-name/s/.*/gtk-theme-name=\"${GTK_THEME_NAME}\"/" /etc/gtk-2.0/gtkrc
	
	if [[ -z "${GTK_ICON_THEME_NAME}" ]]; then
		GTK_ICON_THEME_NAME="GTK_ICON_THEME_NAME"
	fi
	printf "Setting gtk-icon-theme-name: ${GTK_ICON_THEME_NAME} ...\n"
	sed -i "/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=\"${GTK_ICON_THEME_NAME}\"/" /etc/gtk-2.0/gtkrc
	
	printf "Fixing theme Adwaita/gtk-2.0: menus have no borders ...\n"
	patch /usr/share/themes/Adwaita/gtk-2.0/main.rc <"${RECIPE_DIRECTORY}/fix_adwaita_gtk2_menu_with_no_border.patch"
	
	printf "\n"
}

function configure_gtk3(){
	printf "Configuring GTK3 ...\n"
	
	if [[ -f /etc/gtk-3.0/settings.ini ]]; then
		backup_file rename /etc/gtk-3.0/settings.ini
	fi
	
	cp "${FELIX_ROOT}/user-dotfiles/.config/gtk-3.0/settings.ini" /etc/gtk-3.0/settings.ini
	chmod 755 /etc/gtk-3.0/settings.ini
	
	if [[ -z "${GTK_CURSOR_THEME_NAME}" ]]; then
		GTK_CURSOR_THEME_NAME="Adwaita"
	fi
	printf "Setting gtk-cursor-theme-name: ${GTK_CURSOR_THEME_NAME} ...\n"
	sed -i "/^gtk-cursor-theme-name/s/.*/gtk-cursor-theme-name=${GTK_CURSOR_THEME_NAME}/" /etc/gtk-3.0/settings.ini
	
	if [[ -z "${GTK_THEME_NAME}" ]]; then
		GTK_THEME_NAME="Adwaita"
	fi
	printf "Setting gtk-theme-name: ${GTK_THEME_NAME} ...\n"
	sed -i "/^gtk-theme-name/s/.*/gtk-theme-name=${GTK_THEME_NAME}/" /etc/gtk-3.0/settings.ini
	
	if [[ -z "${GTK_ICON_THEME_NAME}" ]]; then
		GTK_ICON_THEME_NAME="Adwaita"
	fi
	printf "Setting gtk-icon-theme-name: ${GTK_ICON_THEME_NAME} ...\n"
	sed -i "/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=${GTK_ICON_THEME_NAME}/" /etc/gtk-3.0/settings.ini
	
	printf "Adding gtk.css for root ...\n"
	if [[ -d /root/.config/gtk-3.0 ]]; then
		backup_file rename /root/.config/gtk-3.0
	fi
	mkdir -p /root/.config/gtk-3.0
	cp "${FELIX_ROOT}/user-dotfiles/.config/gtk-3.0/gtk.css" /root/.config/gtk-3.0/gtk.css
	
	printf "\n"
}

function configure_gtk4(){
	printf "Configuring GTK4 ...\n"
	
	if [[ -f /etc/gtk-4.0/settings.ini ]]; then
		backup_file rename /etc/gtk-4.0/settings.ini
	fi
	
	cp "${FELIX_ROOT}/user-dotfiles/.config/gtk-4.0/settings.ini" /etc/gtk-4.0/settings.ini
	chmod 755 /etc/gtk-4.0/settings.ini
	
	if [[ -z "${GTK_CURSOR_THEME_NAME}" ]]; then
		GTK_CURSOR_THEME_NAME="Adwaita"
	fi
	printf "Setting gtk-cursor-theme-name: ${GTK_CURSOR_THEME_NAME} ...\n"
	sed -i "/^gtk-cursor-theme-name/s/.*/gtk-cursor-theme-name=${GTK_CURSOR_THEME_NAME}/" /etc/gtk-4.0/settings.ini
	
	if [[ -z "${GTK_THEME_NAME}" ]]; then
		GTK_THEME_NAME="Adwaita"
	fi
	printf "Setting gtk-theme-name: ${GTK_THEME_NAME} ...\n"
	sed -i "/^gtk-theme-name/s/.*/gtk-theme-name=${GTK_THEME_NAME}/" /etc/gtk-4.0/settings.ini
	
	if [[ -z "${GTK_ICON_THEME_NAME}" ]]; then
		GTK_ICON_THEME_NAME="Adwaita"
	fi
	printf "Setting gtk-icon-theme-name: ${GTK_ICON_THEME_NAME} ...\n"
	sed -i "/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=${GTK_ICON_THEME_NAME}/" /etc/gtk-4.0/settings.ini
	
	printf "Adding gtk.css for root ...\n"
	if [[ -d /root/.config/gtk-4.0 ]]; then
		backup_file rename /root/.config/gtk-4.0
	fi
	mkdir -p /root/.config/gtk-4.0
	cp "${FELIX_ROOT}/user-dotfiles/.config/gtk-4.0/gtk.css" /root/.config/gtk-4.0/gtk.css
	
	printf "\n"
}

function add_gtk_environment_variables(){
	printf "Configuring GTK environment variables ...\n"
	
	printf 'Adding environment variables for configuring GTK ...\n'
	printf "  - Disabling the scrollbar overlays introduced in GTK 3.16\n"
	cp 99gtk.conf /etc/environment.d
	
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

add_gtk_environment_variables 2>&1 | tee -a "${RECIPE_LOG_FILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
