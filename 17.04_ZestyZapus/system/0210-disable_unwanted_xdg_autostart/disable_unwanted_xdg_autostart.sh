#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

force_numlockx(){
	cd ${BASEDIR}
	
	echo 'Disabling unwanted xdg autostart ...'
	
	#at-spi-dbus-bus.desktop
	#blueman.desktop
	backup_file rename /etc/xdg/autostart/gnome-keyring-pkcs11.desktop
	backup_file rename /etc/xdg/autostart/gnome-keyring-secrets.desktop
	backup_file rename /etc/xdg/autostart/gnome-keyring-ssh.desktop
	backup_file rename /etc/xdg/autostart/gnome-software-service.desktop
	backup_file rename /etc/xdg/autostart/gnome-user-share-obexpush.desktop
	backup_file rename /etc/xdg/autostart/gnome-user-share-webdav.desktop
	backup_file rename /etc/xdg/autostart/gsettings-data-convert.desktop
	backup_file rename /etc/xdg/autostart/indicator-application.desktop
	backup_file rename /etc/xdg/autostart/indicator-messages.desktop
	#/etc/xdg/autostart/light-locker.desktop
	#/etc/xdg/autostart/nm-applet.desktop
	#/etc/xdg/autostart/onboard-autostart.desktop
	#/etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop
	#/etc/xdg/autostart/print-applet.desktop
	#/etc/xdg/autostart/pulseaudio.desktop
	backup_file rename /etc/xdg/autostart/unity-fallback-mount-helper.desktop
	backup_file rename /etc/xdg/autostart/unity-settings-daemon.desktop
	backup_file rename /etc/xdg/autostart/update-notifier.desktop
	#/etc/xdg/autostart/user-dirs-update-gtk.desktop
	backup_file rename /etc/xdg/autostart/xfce4-clipman-plugin-autostart.desktop
	backup_file rename /etc/xdg/autostart/xfce4-notes-autostart.desktop
	#/etc/xdg/autostart/xfce4-power-manager.desktop
	#/etc/xdg/autostart/xfce4-volumed.desktop
	#/etc/xdg/autostart/xfsettingsd.desktop
	backup_file rename /etc/xdg/autostart/xscreensaver.desktop
	backup_file rename /etc/xdg/autostart/zeitgeist-datahub.desktop
}

cd ${BASEDIR}
force_numlockx 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
