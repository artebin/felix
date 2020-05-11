# Raspberry

## Documentation

- <https://www.raspberrypi.org/documentation/configuration/security.md>

## Raspbian

1. Copy the image to the SD card
    We can inspect the content of the image with `fdisk -lu 2012-12-16-wheezy-raspbian.img`
    
- Enable the SSH server by adding an empty file `SSH` in the boot partition. The default SSH credentials are `login=pi` and `passwd=raspberry`.
    
- Configure a WiFi network with a file `wpa_supplicant.conf`:
    
    	ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
    	update_config=1
    	country=#ISO 3166
    	network={
    	ssid=""
    	psk=""
    	key_mgmt=WPA-PSK
    	}
    
- Secure the access:
    * delete `/etc/sudoers.d/010_pi-nopasswd`
    * `passwd` and `sudo passwd`
    
- Locales and keyboard:
    * `sudo dpkg-reconfigure locales` and keep only `en_US.UTF-8`
    * Configure properly `/etc/default/locale`
    * Configure properly `/etc/default/keyboard` (notably `variant="altgr-intl"`)
    
- `apt-get update` and `apt-get upgrade`
    
- Add a user with `adduser` and add it to the `sudo` group
    
- Logout and login with newly created user
    
- Delete the user `pi` with `deluser -remove-home pi`

## Configure WiFi access

- Edit `/etc/wpa_supplicant.conf` like below:
    
    	network={
    	ssid="ssid_name"
    	psk="password"
    	}
    
- Run the commands:
    
    	sudo wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant.conf -D wext
    	sudo dhclient wlan0
    
- If the network is blocked "Operation not possible due to RF-Kill":
    * `$sudo rfkill list`
    * `$sudo rfkill unblock wifi`

## Booting from USB

- <https://jamesachambers.com/raspberry-pi-4-usb-boot-config-guide-for-ssd-flash-drives/>

## Ubuntu

1. Copy the image in the SD card:

    	xzcat ubuntu-18.04.3-preinstalled-server-armhf+raspi2.img.xz | sudo dd bs=4M of=/dev/mmcblk0

## Performance monitoring
- `dstat` written on a remote location (NFS)

## GPIO
