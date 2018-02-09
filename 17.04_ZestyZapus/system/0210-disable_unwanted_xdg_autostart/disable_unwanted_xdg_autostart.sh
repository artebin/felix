#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

force_numlockx(){
	cd ${BASEDIR}
	
	echo "Disabling unwanted xdg autostart ..."
	
	XDG_AUTOSTART_DESKTOP_FILE_ARRAY=(
		#at-spi-dbus-bus.desktop
		#blueman.desktop
		#gnome-keyring-pkcs11.desktop
		#gnome-keyring-secrets.desktop
		#gnome-keyring-ssh.desktop
		#gnome-software-service.desktop
		#gnome-user-share-obexpush.desktop
		#gnome-user-share-webdav.desktop
		#gsettings-data-convert.desktop
		#indicator-application.desktop
		#indicator-messages.desktop
		#light-locker.desktop
		#nm-applet.desktop
		#onboard-autostart.desktop
		#polkit-gnome-authentication-agent-1.desktop
		#print-applet.desktop
		#pulseaudio.desktop
		#unity-fallback-mount-helper.desktop
		#unity-settings-daemon.desktop
		#update-notifier.desktop
		#user-dirs-update-gtk.desktop
		#xfce4-clipman-plugin-autostart.desktop
		#xfce4-notes-autostart.desktop
		#xfce4-power-manager.desktop
		#xfce4-volumed.desktop
		#xfsettingsd.desktop
		#xscreensaver.desktop
		#zeitgeist-datahub.desktop
	)
	
	for XDG_AUTOSTART_FILE_NAME in "${XDG_AUTOSTART_DESKTOP_FILE_ARRAY[@]}"; do
		echo "Disabling autostart for ${XDG_AUTOSTART_FILE_NAME} ..."
		#backup_file rename /etc/xdg/autostart/${XDG_AUTOSTART_FILE_NAME}
	done
}

cd ${BASEDIR}
force_numlockx 2>&1 | tee -a ./${SCRIPT_LOG_FILE_NAME}
