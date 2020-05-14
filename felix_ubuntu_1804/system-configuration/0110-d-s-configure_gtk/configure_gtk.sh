#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
init_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_not_root_privileges

configure_gtk2(){
	echo "Configuring GTK+ 2 ..."
	if [[ -f /etc/gtk-2.0/gtkrc ]]; then
		backup_file rename /etc/gtk-2.0/gtkrc
	fi
	cp "${RECIPE_FAMILY_DIR}/dotfiles/.gtkrc-2.0" /etc/gtk-2.0/gtkrc
	chmod 755 /etc/gtk-2.0/gtkrc
	
	echo "Setting gtk-theme-name: ${GTK_THEME_NAME} ..."
	sed -i "/^gtk-theme-name/s/.*/gtk-theme-name=\"${GTK_THEME_NAME}\"/" /etc/gtk-2.0/gtkrc
	
	echo "Setting gtk-icon-theme-name: ${GTK_ICON_THEME_NAME} ..."
	sed -i "/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=\"${GTK_ICON_THEME_NAME}\"/" /etc/gtk-2.0/gtkrc
	
	echo "Fixing theme Adwaita/gtk-2.0: menus have no borders ..."
	patch /usr/share/themes/Adwaita/gtk-2.0/main.rc <"${RECIPE_DIRECTORY}/fix_adwaita_gtk2_menu_with_no_border.patch"
	
	echo
}

configure_gtk3(){
	echo "Configuring GTK+ 3 ..."
	if [[ -f /etc/gtk-3.0/settings.ini ]]; then
		backup_file rename /etc/gtk-3.0/settings.ini
	fi
	cp "${RECIPE_FAMILY_DIR}/dotfiles/.config/gtk-3.0/settings.ini" /etc/gtk-3.0/settings.ini
	chmod 755 /etc/gtk-3.0/settings.ini
	
	echo "Setting gtk-theme-name: ${GTK_THEME_NAME} ..."
	sed -i "/^gtk-theme-name/s/.*/gtk-theme-name=${GTK_THEME_NAME}/" /etc/gtk-3.0/settings.ini
	
	echo "Setting gtk-icon-theme-name: ${GTK_ICON_THEME_NAME} ..."
	sed -i "/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=${GTK_ICON_THEME_NAME}/" /etc/gtk-3.0/settings.ini
	
	echo "Adding gtk.css for root ..."
	if [[ -d /root/.config/gtk-3.0 ]]; then
		backup_file rename /root/.config/gtk-3.0
	fi
	mkdir -p /root/.config/gtk-3.0
	cp "${RECIPE_FAMILY_DIR}/dotfiles/.config/gtk-3.0/gtk.css" /root/.config/gtk-3.0/gtk.css
	
	echo "Disabling the scrollbar overlay introduced in GTK+ 3.16 ..."
	# It is used for scrollbar undershoot/overshoot and line marker indicating scrollbar value is not 0 or 1 (dashed line)
	# Can not find a property in gtkrc-3.0 for that...
	echo "GTK_OVERLAY_SCROLLING=0" >>/etc/environment
	
	echo "Configuring GTK3 in SWT ..."
	echo "SWT_GTK3=1" >>/etc/environment
	# It would be better to put the 2 env. variables above in Xsession.d as it will be less likely to conflict 
	# with updates made by the packaging system but sudo/root would not have them => cannot use the 2 lines below:
	#echo "export GTK_OVERLAY_SCROLLING=0" >>/etc/X11/Xsession.d/80gtk-overlay-scrolling
	#echo "export SWT_GTK3=0" >>/etc/X11/Xsession.d/80swt-gtk
	
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
