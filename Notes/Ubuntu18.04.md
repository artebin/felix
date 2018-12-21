## Ubuntu 18.04: resume from hibernate crashes because of video drivers
- the problem does not appear on MacBook air 7.1 shipped with Intel HD4000.
- the problem occurs on Dell Inspiron 7737 shipped with Intel i915 (Haswell-ULT Integrated Graphics Controller). See:
  - <https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1807264>.
  - <https://unix.stackexchange.com/questions/419456/i915-intel-skylake-system-freeze-after-wake-up-from-hibernate-suspend-to-disk>

## Ubuntu 18.04: hibernate
Allowing hibernate in polkit is not enough in Ubuntu 18.04, we have to update grub by adding kernel parameter below:
```resume=UUID=<UUID_OF_SWAP_PARTITION>```

## Ubuntu 18.04: r8169 ethernet card not working at all or not working after suspend
- <https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1752772>
- <https://forum.manjaro.org/t/linux415-r8168-cant-connect-to-the-network-after-suspend-to-ram/39557/12>
- `apt-get remove --purge r8168-dkms`
- download and install the most recent version of the driver <https://packages.debian.org/sid/all/r8168-dkms/download>
- add a service /etc/systemd/system/r8169_fix_before_suspend.service
```
[Unit]
Description=Remove r8169 module before suspend/hybrid-sleep/hibernate
Before=suspend.target
Before=hybrid-sleep.target
Before=hibernate.target

[Service]
Type=simple
ExecStart=/usr/bin/modprobe -r r8169

[Install]
WantedBy=suspend.target
WantedBy=hybrid-sleep.target
WantedBy=hibernate.target
```
- `sudo systemctl enable r8169_fix_before_suspend.service`
- add a service /etc/systemd/system/r8169_fix_after_suspend.service
```
[Unit]
Description=Insert r8169 module after suspend/hybrid-sleep/hibernate
After=suspend.target
After=hybrid-sleep.target
After=hibernate.target

[Service]
Type=simple
ExecStart=/usr/bin/modprobe r8169

[Install]
WantedBy=suspend.target
WantedBy=hybrid-sleep.target
WantedBy=hibernate.target
```
- `sudo systemctl enable r8169_fix_after_suspend.service`

## Ubuntu 18.04: Geany Markdown plugin is not available in the repository
