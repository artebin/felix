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

configure_gtk2(){
	printf "Configuring GTK+ 2 ...\n"
	if [[ -f /etc/gtk-2.0/gtkrc ]]; then
		backup_file rename /etc/gtk-2.0/gtkrc
	fi
	cp "${FELIX_ROOT}/user-dotfiles/.gtkrc-2.0" /etc/gtk-2.0/gtkrc
	chmod 755 /etc/gtk-2.0/gtkrc
	
	printf "Setting gtk-theme-name: ${GTK_THEME_NAME} ...\n"
	sed -i "/^gtk-theme-name/s/.*/gtk-theme-name=\"${GTK_THEME_NAME}\"/" /etc/gtk-2.0/gtkrc
	
	printf "Setting gtk-icon-theme-name: ${GTK_ICON_THEME_NAME} ...\n"
	sed -i "/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=\"${GTK_ICON_THEME_NAME}\"/" /etc/gtk-2.0/gtkrc
	
	printf "Fixing theme Adwaita/gtk-2.0: menus have no borders ...\n"
	patch /usr/share/themes/Adwaita/gtk-2.0/main.rc <"${RECIPE_DIRECTORY}/fix_adwaita_gtk2_menu_with_no_border.patch"
	
	printf "\n"
}

configure_gtk3(){
	printf "Configuring GTK+ 3 ...\n"
	if [[ -f /etc/gtk-3.0/settings.ini ]]; then
		backup_file rename /etc/gtk-3.0/settings.ini
	fi
	cp "${FELIX_ROOT}/user-dotfiles/.config/gtk-3.0/settings.ini" /etc/gtk-3.0/settings.ini
	chmod 755 /etc/gtk-3.0/settings.ini
	
	printf "Setting gtk-theme-name: ${GTK_THEME_NAME} ...\n"
	sed -i "/^gtk-theme-name/s/.*/gtk-theme-name=${GTK_THEME_NAME}/" /etc/gtk-3.0/settings.ini
	
	printf "Setting gtk-icon-theme-name: ${GTK_ICON_THEME_NAME} ...\n"
	sed -i "/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=${GTK_ICON_THEME_NAME}/" /etc/gtk-3.0/settings.ini
	
	printf "Adding gtk.css for root ...\n"
	if [[ -d /root/.config/gtk-3.0 ]]; then
		backup_file rename /root/.config/gtk-3.0
	fi
	mkdir -p /root/.config/gtk-3.0
	cp "${FELIX_ROOT}/user-dotfiles/.config/gtk-3.0/gtk.css" /root/.config/gtk-3.0/gtk.css
	
	printf "Forcing GTK+ to use GDK backend x11 ...\n"
	echo "GDK_BACKEND=x11" >>/etc/environment
	
	printf "Disabling the default use of client-side decorations (CSD) on GTK+ windows ...\n"
	echo "GTK_CSD=0" >>/etc/environment
	
	printf "Disabling the scrollbar overlay introduced in GTK+ 3.16 ...\n"
	# It is used for scrollbar undershoot/overshoot and line marker indicating scrollbar value is not 0 or 1 (dashed line)
	# Can not find a property in gtkrc-3.0 for that...
	echo "GTK_OVERLAY_SCROLLING=0" >>/etc/environment
	
	printf "Configuring GTK3 in SWT ...\n"
	echo "SWT_GTK3=1" >>/etc/environment
	
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
