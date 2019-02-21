#!/usr/bin/env bash

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${BASEDIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash
exit_if_has_not_root_privileges

configure_gtk2(){
	echo "Configuring GTK+ 2.0 ..."
	cd "${BASEDIR}"
	if [[ ! -f /etc/gtk-2.0/gtkrc ]]; then
		cp system.gtkrc-2.0 /etc/gtk-2.0/gtkrc
		chmod 755 /etc/gtk-2.0/gtkrc
	fi
	
	echo "Setting gtk-theme-name: ${GTK_THEME_NAME} ..."
	sed -i "/^gtk-theme-name/s/.*/gtk-theme-name=\"${GTK_THEME_NAME}\"/" /etc/gtk-2.0/gtkrc
	
	echo "Setting gtk-icon-theme-name: ${GTK_ICON_THEME_NAME} ..."
	sed -i "/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=\"${GTK_ICON_THEME_NAME}\"/" /etc/gtk-2.0/gtkrc
	
	echo "Fixing theme Adwaita/gtk-2.0: menus have no borders ..."
	cd "${BASEDIR}"
	patch /usr/share/themes/Adwaita/gtk-2.0/main.rc < fix_adwaita_gtk2_menu_with_no_border.patch
}

configure_gtk3(){
	echo "Configuring GTK+ 3.0 ..."
	cd "${BASEDIR}"
	if [[ ! -f /etc/gtk-3.0/settings.ini ]]; then
		cp system.gtkrc-3.0 /etc/gtk-3.0/settings.ini
		chmod 755 /etc/gtk-3.0/settings.ini
	fi
	
	echo "Setting gtk-theme-name: ${GTK_THEME_NAME} ..."
	sed -i "/^gtk-theme-name/s/.*/gtk-theme-name=${GTK_THEME_NAME}/" /etc/gtk-3.0/settings.ini
	
	echo "Setting gtk-icon-theme-name: ${GTK_ICON_THEME_NAME} ..."
	sed -i "/^gtk-icon-theme-name/s/.*/gtk-icon-theme-name=${GTK_ICON_THEME_NAME}/" /etc/gtk-3.0/settings.ini
	
	echo "Disabling the scrollbar overlay introduced in GTK+ 3.16 ..."
	# It is used for scrollbar undershoot/overshoot and line marker indicating scrollbar value is not 0 or 1 (dashed line)
	# Can not find a property in gtkrc-3.0 for that...
	echo "GTK_OVERLAY_SCROLLING=0" | sudo tee -a /etc/environment
	
	echo "Configuring GTK3 in SWT ..."
	echo "SWT_GTK3=1" | sudo tee -a /etc/environment
	
	# It would be better to put the 2 env. variables above in Xsession.d as it will be less likely to conflict 
	# with updates made by the packaging system but sudo/root would not have them => can not use the 2 lines below:
	#echo "export GTK_OVERLAY_SCROLLING=0" | sudo tee /etc/X11/Xsession.d/80gtk-overlay-scrolling
	#echo "export SWT_GTK3=0" | sudo tee /etc/X11/Xsession.d/80swt-gtk
	
	echo "Adding gtk.css for root ..."
	cd "${BASEDIR}"
	mkdir -p /root/.config/gtk-3.0
	cp gtk.css /root/.config/gtk-3.0/gtk.css
	
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
