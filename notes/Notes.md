## Duplicated X events for hotkeys on Dell laptops (XF86MonBrightnessDown / XF86MonBrightnessUp)
Experienced on Dell Inspiron 7737, I tried different combination of kernel parameters with no results, including:
- `acpi_osi=`
- `acpi_backlight=vendor acpi_osi=linux`

Documentation:
- <https://bugs.launchpad.net/ubuntu/+source/hal/+bug/207473>
- <https://www.reddit.com/r/awesomewm/comments/abo30w/awesomewm_handles_xf86monbrightnessup_and/>
- it can be analyzed with `acpi_listen` and `xev`, on the MacBook Air we can see only one event.

List all keycodes in the console:
`xmodmap -pke | less`

To be noted that `xev` does not show the keysym when the events are captured. When captured, the output is like below:
```
FocusOut event, serial 45, synthetic NO, window 0x3000001,
    mode NotifyGrab, detail NotifyAncestor

FocusOut event, serial 45, synthetic NO, window 0x3000001,
    mode NotifyUngrab, detail NotifyPointer

FocusIn event, serial 45, synthetic NO, window 0x3000001,
    mode NotifyUngrab, detail NotifyAncestor

KeymapNotify event, serial 45, synthetic NO, window 0x0,
    keys:  0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   
           0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0 
```

When not captured, the output is like below:
```
KeyPress event, serial 48, synthetic NO, window 0x3000001,
    root 0x2ff, subw 0x3000002, time 1959596, (62,64), root:(1783,762),
    state 0x10, keycode 232 (keysym 0x1008ff03, XF86MonBrightnessDown), same_screen YES,
    XLookupString gives 0 bytes: 
    XmbLookupString gives 0 bytes: 
    XFilterEvent returns: False

KeyRelease event, serial 48, synthetic NO, window 0x3000001,
    root 0x2ff, subw 0x3000002, time 1959596, (62,64), root:(1783,762),
    state 0x10, keycode 232 (keysym 0x1008ff03, XF86MonBrightnessDown), same_screen YES,
    XLookupString gives 0 bytes: 
    XFilterEvent returns: False

```

## List of XF86 symbols
<https://askubuntu.com/questions/93772/where-do-i-find-a-list-of-all-x-keysyms-these-days>

## Screenshot a specific window from the command line with xwd
```
xwd > screenshot.xwd;convert screenshot.xwd screenshot.png
```

## X11 mouse button numbering
See <http://xahlee.info/linux/linux_x11_mouse_button_number.html>

- 1 = left button
- 2 = middle button (pressing the scroll wheel)
- 3 = right button
- 4 = turn scroll wheel up
- 5 = turn scroll wheel down
- 6 = push scroll wheel left
- 7 = push scroll wheel right
- 8 = 4th button (aka browser backward button)
- 9 = 5th button (aka browser forward button)

## Switch video driver from terminal
```
sudo apt-get autoremove --purge nvidia-*
sudo service lightdm stop
sudo apt-get install xserver-xorg-video-nouveau
```

## Shared clipboard between host/guest in Virtualbox
Must install `virtualbox-guest-x11`.

## Xmodmap
List the current configuration of the keyboard with `xmodmap pke`.

## Fix keyboard backlight in mate-power-manager
The problem is that keyboard backlight is set to 100pc when mate-power-manager starts and when some power management is done (leaving idle for example).

First add for debugging messages with `g_debug()...` then re-compile and execute:
```
export G_MESSAGES_DEBUG=all;make clean;make;./src/mate-power-manager
```
## Firefox Add-ons
- Adblock Plus
- Google search link fix
- Google Translator for Firefox
- RSSPreview <https://addons.mozilla.org/en-US/firefox/addon/rsspreview/?src=search>

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

## Disable X.org
- `sudo systemctl set-default multi-user.target`
- `sudo systemctl set-default graphical.target`

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

## DisplayLink
- Driver available at <https://www.displaylink.com/downloads/ubuntu>
- `xrandr --listproviders`
- `xrandr --current`
- Enabling DVI output on startup <https://wiki.archlinux.org/index.php/DisplayLink#Enabling_DVI_output_on_startup>
- DisplayLink driver does not work with Intel GPUs after recent X upgrades, see <https://wiki.archlinux.org/index.php/DisplayLink#DisplayLink_driver_does_not_work_with_Intel_GPUs_after_recent_X_upgrades>

## DisplayPort
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

## Sidebar of GTK3 filechooserdialog is not using the icon from the GTK theme
- <https://forum.xfce.org/viewtopic.php?id=10958>
- <https://github.com/shimmerproject/Greybird/issues/83>
- <https://forums.linuxmint.com/viewtopic.php?t=224506> 

## Grub
Console framebuffer change resolution in `/etc/default/grub` with: `GRUB_GFXMODE=1024x768x32` and `GRUB_GFXPAYLOAD_LINUX=keep` (do not forget to call update-grub)

## Keyboard configuration lost after suspend/resume
Sometimes the keyboard configuration done with `setxkbmap -rules evdev -model evdev -layout us -variant altgr-intl &` is lost after suspend/resume, but not always.
This answer on unix.stackexchange seems to say it should always be the case <https://unix.stackexchange.com/questions/59623/custom-keyboard-layout-is-reset-to-default-after-standby-or-reboot>.
It also says that Xmodmap configuration is lost after suspend. 
In a way or another, it is better to set the keyboard in `/etc/default/keyboard`
