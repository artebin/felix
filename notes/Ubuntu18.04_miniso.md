## miniso
- `apt-get install lightdm-gtk-greeter lightdm-gtk-greeter-settings openbox`
- `lightdm` is configured with the unity greeter by default.
```
rm /usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf
touch /usr/share/lightdm/lightdm.conf.d/50-gtk-greeter.conf
```
- put the content below in `/usr/share/lightdm/lightdm.conf.d/50-gtk-greeter.conf`:
```
[SeatDefaults]
greeter-session=gtk-greeter
user-session=openbox
```
