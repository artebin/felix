# Rasberry Raspbian lite headless server

## Documentation
- <https://www.raspberrypi.org/documentation/configuration/security.md>

## Step by step
- copy the image
- add the file `ssh` for enabling SSH
- add the file `wpa_supplicant.conf` for automatic configuration of the WiFi:
```
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=		#ISO 3166
network={
	ssid=""
	psk=""
	key_mgmt=WPA-PSK
}
```
Can not make it work with 5GHz WiFi network (?)
- `sudo passwd`
- configure properly `/etc/default/locale`
- configure properly `/etc/default/keyboard`
- add a user with `adduser` and add it to the `sudo` group
- logout and login with newly created user
- delete pi user with `deluser -remove-home pi`
- delete `/etc/sudoers.d/010_pi-nopasswd`
- `apt-get update`
- `apt-get upgrade`

## XRDP
