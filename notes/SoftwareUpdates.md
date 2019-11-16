# Software updates

## Automatic & periodic update of the package list
Activate and start `apt-daily service`:
	systemctl start apt-daily.timer
	systemctl enable apt-daily.timer
	systemctl enable apt-daily.service

The execution period can be configured via `sudo systemctl edit apt-daily.timer`:
	# apt-daily timer configuration override
	[Timer]
	OnBootSec=15min
	OnUnitActiveSec=1d
	AccuracySec=1h
	RandomizedDelaySec=30min

## Print the availability of updates with `motd`
Check the configuration is `/etc/update-motd.d`

## Disable automatic upgrade
This is wanted on a server, the admin wants to be notified of the avaibility of updates but no automatic installation:

- Re-configure `unattended-upgrades` with `sudo dpkg-reconfigure unattended-upgrades`
- Disactivate and stop apt-daily-upgrade:
```
systemctl stop apt-daily-upgrade.timer
systemctl disable apt-daily-upgrade.timer
systemctl disable apt-daily-upgrade.service
```

## Send email to admin when updates are available
Install `apticron` which requires `apt-daily.service` to be activated and started.
Email address to be configure in `/etc/apticron/apticron.conf`

## Show notification in desktop when updates are available
Several solutions:

- install `update-notifier` from GNOME desktop but this one is very annoying and aggressive
- `https://github.com/zcalusic/update-notifier` is written in GO. There is a little bug: the tray show an empty space at the location of the icon during some time, an only after the icon is showed and a notification is showed too. It would be desirable to specify what type of updates trigger the icon and also to be able to specify a command to run when the user click the icon.

