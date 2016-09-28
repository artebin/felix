1. Log in into Xubuntu
2. Open a Terminal
3. xfce4-settings-manager
4. Choose AdditionalDrivers 
=> install any missing drivers
5. Choose LanguageSupport 
=> install missing language support
=> choose RegionalFormats: default configuration is base on current location at time of install but it should be asked during installation (for instance if you are located in a country for which you do not speak the official language, or in a country with several official languages and you do not speak the "default" official language). Another weird thing is the default currency based on the country, i.e. currency cannot be set.
6. Choose Notifications: select theme "Numix"
7. sudo apt-get install git
8. execute in a terminal:
	git clone http://github.com/artebin/felix
	cd felix
	sh InstallPackages.sh
	sh SystemSettings.sh
	sh UserSettings.sh
9. If you are using a MacBookAir:
	cd MacBookAir
	sh MacBookAir.sh
10. If you are using a laptop: xfce4-power-manager-settings
=> Laptop Lid: OnBattery[Suspend] and PluggedIn[Suspend]
=> Preferences > Security: uncheck "Remember logins for sites"
=> Preferences > Advanced: uncheck "Use smooth scrolling"
11. If you are using Xubuntu 16.04 then you maybe experience the bug #1568604 "Mouse cursor lost when unlocking with Intel graphics".
https://bugs.launchpad.net/ubuntu/+source/xserver-xorg-video-intel/+bug/1568604
You can reinstall the intel driver, version 2:2.99.917+git20160706-1ubuntu1
https://launchpad.net/ubuntu/yakkety/+package/xserver-xorg-video-intel
12. Java => change PATH in /etc/profile
13. Eclipse => force usage of GTK+ 2.0 with export SWT_GTK3=0


