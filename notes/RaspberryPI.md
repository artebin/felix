# Raspberry

## Documentation
- <https://www.raspberrypi.org/documentation/configuration/security.md>

## Raspbian
1. Copy the image to the SD card

2. Enable the SSH server by adding an empty file `SSH` in the boot partition. The default SSH credentials are `login=pi` and `passwd=raspberry`.
    
3. Configure a WiFi network with a file `wpa_supplicant.conf`:
    
    	ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
    	update_config=1
    	country=#ISO 3166
    	network={
    	ssid=""
    	psk=""
    	key_mgmt=WPA-PSK
    	}
    
    Remark: I cannot make it work with 5GHz WiFi network, no idea of why.
    
4. A bit of security:
    * delete `/etc/sudoers.d/010_pi-nopasswd`
    * `passwd` and `sudo passwd`

5. Locales and keyboard:
    * `sudo dpkg-reconfigure locales` and keep only `en_US.UTF-8`
    * Configure properly `/etc/default/locale`
    * Configure properly `/etc/default/keyboard` (notably `variant="altgr-intl"`)
    
6. `apt-get update` and `apt-get upgrade`

7. Add a user with `adduser` and add it to the `sudo` group

8. Logout and login with newly created user

9. Delete the user `pi` with `deluser -remove-home pi`

## Ubuntu

1. Copy the image in the SD card:

    	xzcat ubuntu-18.04.3-preinstalled-server-armhf+raspi2.img.xz | sudo dd bs=4M of=/dev/mmcblk0

## Performance monitoring
- `dstat` written on a remote location (NFS)

## GPIO
