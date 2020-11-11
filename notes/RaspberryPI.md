# Raspberry

## Raspbian

1. Copy the image to the SD card
    
    We can inspect the content of the image with `fdisk -lu 2020-02-13-raspbian-buster-lite.img`

- Enable the SSH server by adding an empty file `ssh` in the boot partition. The default SSH credentials are `login=pi` and `passwd=raspberry`.

- Configure a WiFi network with a file `wpa_supplicant.conf` in `/boot`:
    
    	ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
    	update_config=1
    	country=#ISO 3166
    	network={
    		ssid=""
    		psk=""
    		key_mgmt=WPA-PSK
    	}

- Secure the access:
    * <https://www.raspberrypi.org/documentation/configuration/security.md>
    * delete `/etc/sudoers.d/010_pi-nopasswd`
    * `passwd` and `sudo passwd`
    * `adduser <new_user>`
    * `usermod -a -G sudo <new_user>`
    * `deluser --remove-home pi`

- Locales and keyboard:
    * `sudo dpkg-reconfigure locales` and keep only `en_US.UTF-8`
    * Configure properly `/etc/default/locale`
    * Configure properly `/etc/default/keyboard` (notably `variant="altgr-intl"`)

- `apt-get update` and `apt-get upgrade`

## Ubuntu

- Copy the image in the SD card:
    
    	xzcat ubuntu-18.04.3-preinstalled-server-armhf+raspi2.img.xz | sudo dd bs=4M of=/dev/mmcblk0

## Booting from USB

- <https://jamesachambers.com/raspberry-pi-4-usb-boot-config-guide-for-ssd-flash-drives/>

## Configure WiFi access

1. Edit `/etc/wpa_supplicant/wpa_supplicant.conf` like below:
    
    	network={
    	ssid="ssid_name"
    	psk="password"
    	}

- Run the commands:
    
    	sudo wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant.conf
    	sudo dhclient wlan0

- If the network is blocked "Operation not possible due to RF-Kill":
    * `$sudo rfkill list`
    * `$sudo rfkill unblock wifi`

- If the `wpa_supplicant` returns an error `Could not read interface p2p-dev-wlan0 flags: No such device` then it is most probably because there is already a `wpa_supplicant` running, and they must be killed `killall wpa_supplicant`.

## Web Browser Vivaldi with DRM

Follow <https://help.vivaldi.com/article/raspberry-pi/> and <https://gist.github.com/ruario/19a28d98d29d34ec9b184c42e5f8bf29>.

## Performance monitoring

- `dstat` written on a remote location (NFS) ?

## GPIO
