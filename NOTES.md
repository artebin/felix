## DisplayLink
Today there is no support of Daisy-Chain DisplayPort 1.2 monitors in Linux (MST Multi-Stream Transport).

## Modal dialog and grab X events
I would like to be able to show a modal dialog, gray out the display and grab all the events (no keyboard shortcut <Alt><Tab> etc.). Exactly like `gksu` and `gksudo` are doing. The ideal thing would be a patch to zenity.

- grab the events like in <https://stackoverflow.com/questions/31892015/how-to-disable-window-controls-when-a-modal-dialog-box-is-active-in-tkinter>
- can use `wmctrl` for having zenity always on top <https://unix.stackexchange.com/questions/152294/keep-a-zenity-dialog-box-always-on-top-in-foreground>

## Window management
- Retrieve ID of the current desktop/workspace: `xprop -root _NET_CURRENT_DESKTOP`
- wmctrl: interact with a EWMH/NetWM compatible X Window Manager.
- Retrieve the list of current windows: `wmctrl -lx`
- <https://www.linux.com/news/take-charge-your-window-manager-wmctrl-and-devils-pie>

## .d files
- /etc/apt/sources.list.d/
- /etc/ld.so.conf.d/
- /etc/profile.d/

## Screenshot utility with edition capabilities, screenshot annotation
- shutter: total bloatware and the tray icon is very much irritating.
- flameshot: irritating tray icon, impossible to find where is located the configuration files (even found a `Dharkael` folder in `.config` whatever is this folder it should be named `flameshot`), impossible to launch it after set "no tray icon".

The best tool will stay xfce4-screenshooter and LibreOffice Draw for a long time...

## GtkTreeView zebra stripping
My GTK+ version is 3.22.11. GtkTreeview and background color for odd rows (aka "gtktreeview zebra striping"), see:

- <https://www.reddit.com/r/mate/comments/6xxtwb/caja_gtk3_alternating_row_colors_in_list_view/>
- <https://stackoverflow.com/questions/36002296/how-to-alternate-light-dark-rows-in-gtktreeview>
- set_rules_hint? deprecated since v3.14 see <https://stackoverflow.com/questions/19449748/how-to-add-different-color-to-odd-and-even-rows-in-a-pygtk-treeview>
- <https://www.bountysource.com/issues/30469360-gtktreeview-odd-even-row-styling-no-longer-works>
- see <https://stackoverflow.com/questions/45546717/gtk-treeview-styling>
- GTK+ Inspector if debug enabled with `gsettings set org.gtk.Settings.Debug enable-inspector-keybinding true` and then using the shortcut `<Ctrl>d`
- GTK+ Inspector <https://blog.gtk.org/2017/04/05/the-gtk-inspector/>
- Use gtk-widget-factory which is actually gtk-demo (install it from the repository)

## Mouse sensitivity
- `xinput list`
- `xinput --list-props <device id>`
- `xinput --set-prop <devide id> <property> <value>`

Could also use lxinput from lxde desktop.

## trevize.net
Setting up Frogstar: should add a static route in the router for re-directing the traffic from the local network (local host to trevize.net).

IPv6 seems can be preferred over IPv4, use `ping <hostname> -4`

## DVD playback
Ubuntu repositories offer the package libdvd-pkg for installing the library libdvdcss.

## Test Ubuntu 17.10
1. BIOS corruption see <https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1734147>
2. The wallpaper used by LightdDM stays displayed after login
3. There is a problem with openbox, when a window is maximized, we cannot resize the window directly, we must change the indow state to unmaximized first, however for a reason the unsucessful resizing changed the window size.
4. pasystray has some problem (but maybe it is because I am building pasystray from the source), the sound can be very loud and the volume amount corresponding to a mouse scroll step is very low.
5. There is some problem with the sound: cracking and bad quality audio (noticed with youtube, but it is clearly not about the original sound, the problem is in the local playback).
6. While copying a file on a external drive, the popup showing the file transfer is not shown, we can see the files in the file browser but the copy operation is still running. we tried to umount the external drive and then a popup is showed "operation on-going".

## Openbox Menu
Using `caja --no-desktop` in the .desktop file for mime type inode/directory seems to not work and don't know why => call directly `caja --no-desktop` from openbox rc.xml and menu.xml rather than `xdg.open .`

## Java
Put environment variables in `/etc/profile.d/myenvvars.sh` rather than in `/etc/profile`

Java is not using ld.so.conf files we can check default value of java.library.path with: `java -XshowSettings:properties` => best thing is to create a symbolic link `ln -s /usr/lib/x86_64-linux-gnu/jni/libwibucmJNI64.so /usr/lib/libwibucmJNI64.so`

`LD_LIRABRY_PATH` can not be set anymore from `/etc/environment` or `/etc/profile`, should use `/etc/ld.so.conf.d/somefile.conf`

## Firefox
- Better usage of the URL bar/Search bar: "keyword.enable=false" will allow to use machine name in the URL bar. Use the addon "Custom New Tab" for giving the focus to the page when the New Tab action is performed. Use <F6> for focusing the URL bar and <CTRL+k> for focusing the Search bar.
- use "about:newtab" as home page

## Thunderbird
- Show the menu bar with <F10>
- Stop to wrap the lines in not-HTML composition: "mail.wrap_long_lines=false" and "mailnews.wraplength=0"

## Xubuntu 17.04: bug with VirtualBox guest additions 5.1.22 
virtualbox-guest-additions 5.1.22 seems to be buggy, unable to start Xorg. Install virtualbox-guest-additions 5.1.24 from <http://download.virtualbox.org/virtualbox> and it is working properly.

## Xubuntu 17.04: bug in Nouveau driver when switching to console if multiple monitors
It seems there is a bug in Nouveau driver with the framebuffer and when using multiple monitors. The boot is successful, X.org seems to start properly, but we can not switch to the console with <Ctrl><Alt>F{x}. If we plug only one monitor then we can switch to the console. With the NVidia driver 384, we can switch to console.

## Grub
Console framebuffer change resolution in `/etc/default/grub` with: `GRUB_GFXMODE=1024x768x32` and `GRUB_GFXPAYLOAD_LINUX=keep` (do not forget to call update-grub)

## Xubuntu 16.04: bug mouse cursor lost after unlocking with Intel Graphics
<https://bugs.launchpad.net/ubuntu/+source/xserver-xorg-video-intel/+bug/1568604>

Fixed by reinstalling intel driver, version 2:2.99.917+git20160706-1ubuntu1:
<https://launchpad.net/ubuntu/yakkety/+package/xserver-xorg-video-intel>

## Keyboard configuration lost after suspend/resume
Sometimes the keyboard configuration done with `setxkbmap -rules evdev -model evdev -layout us -variant altgr-intl &` is lost after suspend/resume, but not always.
This answer on unix.stackexchange seems to say it should always be the case <https://unix.stackexchange.com/questions/59623/custom-keyboard-layout-is-reset-to-default-after-standby-or-reboot>.
It also says that Xmodmap configuration is lost after suspend. 
In a way or another, it is better to set the keyboard in `/etc/default/keyboard`
