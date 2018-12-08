## Shared clipboard between host/guest in Virtualbox
Must install `virtualbox-guest-x11`.

## Xmodmap
List the current configuration of the keyboard with `$xmodmap pke`

## Fix keyboard backlight in mate-power-manager
The problem is that keyboard backlight is set to 100pc when mate-power-manager starts and when some power management is done (leaving idle for example).

First add for debugging messages with `g_debug()...` then re-compile and execute:
```
export G_MESSAGES_DEBUG=all;make clean;make;./src/mate-power-manager
```


## Laptop: use external monitor only (the laptop lid is closed)
First thing to do: disable all events regarding the lid in `/etc/systemd/logind.conf`
```
[Login]
HandleLidSwitch=ignore
HandleLidSwitchDocked=ignore
```

Use `xrandr --query` to see the current state of the system.
We can `export DISPLAY=:0.0` for running xrandr from SSH.

Second thing to do is the setup of the monitors, there are several ways to do it: 
- X.org configuration (in `/usr/share/X11/xorg.conf.d`)
- LightDM configuration and xrandr (in `/etc/lightdm/lightdm.conf.d`)
- window manager autostart and xrandr

Lightdm configuration: create `/etc/lightdm/lightdm.conf.d/10-setup_displays.conf`
```
[Seat:*]
display-setup-script=xrandr --output LVDS-1 --off --output DP-1 --off --output HDMI-1 --primary --mode 1360x768 --pos 0x0 --rotate normal --output VGA-1 --off
```

I have problems with resolution 1360x768 but maybe because of my TV device: some pixels are missing North, West, South, East.
It happens only the first time I switch to this resolution, if I set 1920x1080 and then go back to 1360x768 then it is properly displayed. No problem with other resolutions.
I can fix the problem by setup the monitors via lightdm configuration (with a resolution like 1280x720 - not 1360x768), and then use a second xrandr command executed via openbox autostart which will set wanted the resolution.

## Remote desktops
After some testings: the best is to use vnc4erver (or TigerVNC).

### x11vnc
It is the most simple way to get a vnc, just install it on the server and run  once the session is started. On the client everything vnc client should work.
- `x11vnc -storepasswd` to define a password (in `~/.vnc/passwd`)
- `x11vnc -usepw -noxdamage -forever`: there is an argument `-ncache 10` for improving the rendering on the client side but I have some problems with it, I can see on the bottom of the screen an area which is a copy of the top of the screen.
- I had several crashes with x11vnc, so I would investigate another remote desktop (vnc server or xrdp).

### VNC server
See <https://wiki.archlinux.org/index.php/TigerVNC>

- vnc4server (based on realvnc)
- tigervnc (based on tightvnc which is based on realvnc)

On the server:
- `sudo apt install vnc4server`
- `vncpasswd`
- `x0vncserver -display :0 -passwordfile ~/.vnc/passwd`

The best and simplest thing to do for an automatically available session with VNC: autologin and starting of the `x0vncserver`.
The starting of the vncserver can be done with openbox autostart or `.xsessionrc`.

There is an option autologin-in-background feature in LightDM, see:
- <https://code.launchpad.net/~mterry/lightdm/autologin-in-background/+merge/162670>
- <https://github.com/CanonicalLtd/lightdm/blob/master/data/lightdm.conf>
Unfortunately I have no success in using it (or I have not understood what it should do): the switch to the user session is done but the LightDM documentation says that the contrary should be done.

### XRDP
- on the server: `sudo apt install xrdp xordxrdp`
- on the client: `sudo apt install remmina`
- Remmina may show an error when we want to connect "You requested an H264 GFX mode for server x.x.x.x, but your libfreerdp does not support H264. Please check Color Depth settings". See <https://github.com/FreeRDP/Remmina/issues/1584>. We just need to create a profile because the default connection will use the best screen profile using H264.

## FlightRadar24
- retrieve fr24feed from <https://www.flightradar24.com/share-your-data>
- the binary executable is not perfoming a usable configuration on Ubuntu (at least Ubuntu 18.04). Maybe the install procedure failed, or it expects to find dump1090 in `/usr/lib/fr24`. It is no problem: (1) copy fr24feed in `/usr/bin`, (2) compile dump1090 and then copy dump1090 and gmap.html to `/usr/lib/fr24`. The systemd service file is also missing but it is no difficulty to write one.
- the argument `--interactive` of dump1090 prevent the feeding of FR24 for an unknown reason. Just use `--net` for having the map but remove `--interactive`.

## Disable X.org
- `sudo systemctl set-default multi-user.target`
- `sudo systemctl set-default graphical.target`

## Dump1090
- Dump1090 can not work if there is no udev rule for the DVB-T. Retrieve the VendorID and the ProductID with `lsusb` and create/update `/etc/udev/rules.d/rtl-sdr.rules`:
```
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2832", MODE:="0666" -
```
- make udev reload the rules with:
```
sudo udevadm control --reload-rules
sudo udevadm trigger
```
- start dump1090 with `./dump1090 --interactive --net` and visit `http://localhost:8080`

## Offline repository
- create a mirror of the repository with `apt-mirror` (configure `/etc/apt/mirror.list` and execute `apt-mirror`)
- add a sources list in `/etc/apt/sources.list.d/local_mirror.list` with something like the content below:
```
deb [ arch=amd64 ] http://localhost:10001/ubuntu/ bionic main restricted universe multiverse
# deb-src [ arch=amd64 ] http://localhost:10001/ubuntu/ bionic main restricted universe multiverse

deb [ arch=amd64 ] http://localhost:10001/ubuntu/ bionic-updates main restricted universe multiverse
# deb-src [ arch=amd64 ] http://localhost:10001/ubuntu/ bionic-updates main restricted universe multiverse

# deb [ arch=amd64 ] http://localhost:10001/ubuntu/ bionic-backports main restricted universe multiverse
# deb-src [ arch=amd64 ] http://localhost:10001/ubuntu/ bionic-backports main restricted universe multiverse

deb [ arch=amd64 ] http://localhost:10001/ubuntu bionic-security main restricted universe multiverse
# deb-src [ arch=amd64 ] http://localhost:10001/ubuntu bionic-security main restricted universe multiverse
```
- start a http server for the repository, go into `<mirror directory>/mirror/archive.ubuntu.com` and execute `python -m SimpleHTTPServer 10001`

## MIME types and default application
- retrieve the MIME type: `xdg-mime query filetype <some file>`
- retrieve the current default application: `xdg-mime query default <mime type>`
- search for the desktop file: `locate <desktop file for the application we want as the default>`
- set the default application: `xdg-mime default <desktop file> <mime type>`
- test: `xdg-mime query default <mime type>`
- the MIME database is stored in `~/.local/share/applications/mimeapps.list`

I still do not understand how the MIME is supposed to work with the file managers. First I do not understand how the suggested application are order by the file manager.
Another example: I have an image in `~/Download`, if select the file and click right then it is offered to me to open the file with shotwell.
If I delete the image and then if I go to the Trash folder, select the file and click right, suddently firefox is offered for opening the file.

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

## DisplayLink
Today there is no support of Daisy-Chaining DisplayPort 1.2 monitors in Linux (MST Multi-Stream Transport).

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
- /etc/apt/sources.list.d
- /etc/ld.so.conf.d
- /etc/profile.d
- /usr/share/X11/xorg.conf.d
- /etc/lightdm/lightdm.conf.d
- /etc/logrotate.d

## Change window title or add window decorator
- The tab principle from Fluxbox would be interesting for attaching a name to a window (given by the user, choosen by the user). The idea of grouping by tabs does not interest me and I do not see an interest in that, but the decoration and the ability to give a name to a window would be interesting (as far as I know we can not set the tab title in Fluxbox). However this is an interesting reading about why no tabs in openbox <http://icculus.org/pipermail/openbox/2003-April/000491.html>.

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
- GTK+ Inspector if debug enabled with `gsettings set org.gtk.Settings.Debug enable-inspector-keybinding true` and then using the shortcut `<Ctrl><Shift>d`
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
- "browser.urlbar.oneOffSearches=false" for hiding hide the toolbar for search engines in the drop panel of the URL bar.

## Thunderbird
- Show the menu bar with <F10>
- Stop auto mark as read when a message is selected: "mailnews.mark_message_read.auto=false"
- Stop to wrap the lines in not-HTML composition: "mail.wrap_long_lines=false" and "mailnews.wraplength=0"

## Eclipse
Minimal installation of Eclipse:
- Download the Eclipse platform <http://download.eclipse.org/eclipse/downloads/drops4/R-4.7.2-201711300510/>
- Go to `Help>Install New Software` and install the Eclipse Marketplace
- Install Java Development Tools (JDT) and Subversive using the Eclipse Marketplace
- Add the SVNKit repository <http://community.polarion.com/projects/subversive/download/eclipse/6.0/update-site/> from Polarion (see the Polarion website).
- Go to `Preferences>Java>Compiler>Building` and check `Circular dependencies=Warning`

## Sidebar of GTK3 filechooserdialog is not using the icon from the GTK theme
- <https://forum.xfce.org/viewtopic.php?id=10958>
- <https://github.com/shimmerproject/Greybird/issues/83>
- <https://forums.linuxmint.com/viewtopic.php?t=224506> 

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
