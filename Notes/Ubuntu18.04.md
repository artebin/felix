## Ubuntu 18.04: resume from hibernate crashes because of video drivers
- the problem does not appear on MacBook air 7.1 shipped with Intel HD4000.
- the problem occurs on Dell Inspiron 7737 shipped with Intel i915 (Haswell-ULT Integrated Graphics Controller). See:
-- <https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1807264>.
-- <https://unix.stackexchange.com/questions/419456/i915-intel-skylake-system-freeze-after-wake-up-from-hibernate-suspend-to-disk>

## Ubuntu 18.04: hibernate
Allowing hibernate in polkit is not enough in Ubuntu 18.04, we have to update grub by adding kernel parameter below:
```resume=UUID=<UUID_OF_SWAP_PARTITION>```

## Ubuntu 18.04: r8169 ethernet card not working at all or not working after suspend
See <https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1752772>
- it seems `r8168-dkms` is not installed by default in Xubuntu 18.04
- `apt-get remove --purge r8168-dkms`
- download and install the most recent version of the driver <https://packages.debian.org/sid/all/r8168-dkms/download>
- add a service /etc/systemd/system/r8169_fix.service
```
[Unit]
Description=Local system resume actions
After=suspend.target
After=hybrid-sleep.target
After=hibernate.target

[Service]
Type=simple
ExecStartPre=/usr/bin/modprobe -r r8169
ExecStart=/usr/bin/modprobe r8169

[Install]
WantedBy=suspend.target
WantedBy=hybrid-sleep.target
WantedBy=hibernate.target
```
- `sudo systemctl enable r8169_fix.service`

## Xubuntu 18.04
- obmenu is not working:
>Traceback (most recent call last):
>  File "/usr/bin/obmenu", line 617, in <module>
>    app.init()
>  File "/usr/bin/obmenu", line 521, in init
>    self.menu.loadMenu(self.menu_path)
>  File "/usr/lib/python2.7/dist-packages/obxml.py", line 153, in loadMenu
>    self.dom = xml.dom.minidom.parseString(fil.read())
>  File "/usr/lib/python2.7/xml/dom/minidom.py", line 1928, in parseString
>    return expatbuilder.parseString(string)
>  File "/usr/lib/python2.7/xml/dom/expatbuilder.py", line 940, in parseString
>    return builder.parseString(string)
>  File "/usr/lib/python2.7/xml/dom/expatbuilder.py", line 223, in parseString
>    parser.Parse(string, True)
>xml.parsers.expat.ExpatError: not well-formed (invalid token): line 16, column 22
- Icon tray of xfce4-power-manager is not displayed properly? Does it not use the user-selected icon theme stock anymore? Furthermore the new version is not nice, the choice of the color for the dialog appearing when the user clicks the tray icon is very bad => move to mate-power-manager which is far better, simpler. However I see a problem with permission for starting `/usr/local/sbin/mate-power-backlight-helper`, I suppose I should add a polkit configuration for it in `/usr/share/polkit-1/actions`. 
- Geany Markdown is not available in the repository.
