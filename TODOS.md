# TODOS

- [ ] Readd mugshot and gftp (instead of bareftp not in debian12).
- [ ] Install simplescreenrecorder.
- [ ] Force NTP server `/etc/systemd/timesyncd.conf` ?
- [ ] Edit bashrc and open bashrc.d in openbox menu.
- [ ] rofi-annuaire should show airport coordinates in DMS too (not only in DD Decimal Degrees).
- [ ] Can we disable font smoothing in effin GNOME? <https://askubuntu.com/questions/1199155/how-do-i-disable-font-antialiasing-in-some-apps-e-g-vlc-telegram-viber>.

- [ ] after installing packages to compile geany-preview <https://github.com/xiota/geany-preview>, the rendering of markdown in geany changed with a bug "extra line break between bullet and todo marker). Also the rendering in emails changed in Evolution. The list of packages is: Upgraded the following packages:
  
  libjavascriptcoregtk-4.0-18 (2.44.2-1~deb12u1) to 2.46.3-1~deb12u1
  libjavascriptcoregtk-4.1-0 (2.44.2-1~deb12u1) to 2.46.3-1~deb12u1
  libnghttp2-14 (1.52.0-1+deb12u1) to 1.52.0-1+deb12u2
  libwebkit2gtk-4.0-37 (2.44.2-1~deb12u1) to 2.46.3-1~deb12u1
  libwebkit2gtk-4.1-0 (2.44.2-1~deb12u1) to 2.46.3-1~deb12u1
  
  Installed the following packages:
  gir1.2-adw-1 (1.2.2-1)
  gir1.2-javascriptcoregtk-4.0 (2.46.3-1~deb12u1)
  gir1.2-javascriptcoregtk-4.1 (2.46.3-1~deb12u1)
  gir1.2-soup-2.4 (2.74.3-1)
  gir1.2-soup-3.0 (3.2.2-2)
  gir1.2-webkit2-4.0 (2.46.3-1~deb12u1)
  gir1.2-webkit2-4.1 (2.46.3-1~deb12u1)
  libadwaita-1-0 (1.2.2-1)
  libadwaita-1-dev (1.2.2-1)
  libjavascriptcoregtk-4.0-dev (2.46.3-1~deb12u1)
  libjavascriptcoregtk-4.1-dev (2.46.3-1~deb12u1)
  libjson-glib-dev (1.6.6-1)
  libnghttp2-dev (1.52.0-1+deb12u2)
  libpolkit-gobject-1-dev (122-3)
  libpsl-dev (0.21.2-1)
  libsoup-3.0-dev (3.2.2-2)
  libsoup-gnome2.4-1 (2.74.3-1)
  libsoup2.4-dev (2.74.3-1)
  libsysprof-4 (3.46.0-4)
  libsysprof-4-dev (3.46.0-4)
  libsysprof-ui-5 (3.46.0-4)
  => libwebkit2gtk-4.0-dev (2.46.3-1~deb12u1)
  => libwebkit2gtk-4.1-dev (2.46.3-1~deb12u1)
  
  => libcmark-gfm-dev (0.29.0.gfm.6-6)
  libcmark-gfm-extensions-dev (0.29.0.gfm.6-6)
  libcmark-gfm-extensions0.29.0.gfm.6 (0.29.0.gfm.6-6)
  libcmark-gfm0.29.0.gfm.6 (0.29.0.gfm.6-6)
  libghc-cmark-gfm-dev (0.2.5+ds1-1+b1)
  
  ghc (9.0.2-4)
  libbsd-dev (0.11.7-2)
  => libcmark-dev (0.30.2-6)
  libghc-cmark-dev (0.6+ds1-4+b2)
  libmd-dev (1.0.4-2)
  libncurses-dev (6.4-4)

- [ ] Hidden gem in Openbox: window selector Win+Tab and Shift+click brings a window from another desktop into the current desktop. Ctrl+click moves to desktop/window but keep the window selector opened.
- [ ] Remove the QT QPA.
- [ ] Adding backports into apt sources and install fasttrack.
- [ ] Geany add header block comment <https://www.geany.org/manual/#sending-text-through-custom-commands>
- [ ] Must install geany from sources else ctrl-shift-v is killing geany.
- [ ] Fix paprefs <https://www.reddit.com/r/Ubuntu/comments/gvtzpb/ubuntu_2004_lts_x86_64_trying_to_use_paprefs_but/>.
- [ ] caja script for file checksum <https://ubuntu-mate.community/t/md5-sha1-and-sha2-for-caja-context-menu/11263>.
- [ ] If ibus is not installed we can see a bug in firefox, it is solved by forcing xim as input method, see <https://forum.manjaro.org/t/whatsapp-web-deleting-letter-that-starts-with-accent/119772>. We can also install ibus btu we miss the config for replacing shortcut W-space used by default as switch input method (i.e. the "ibus input method") while can be an openbox shortcut (usually it is the openbox menu toggle shortcut).
- [ ] Debian 12 is slow and lags with full disk encryption <https://wiki.archlinux.org/title/Dm-crypt/Specialties#Disable_workqueue_for_increased_solid_state_drive_(SSD)_performance>.
- [ ] winlayout should not restore virtual desktop for sticky windows.
- [ ] laptop-mode-tools.
- [ ] Command for setting the font size in openbox current theme.
- [ ] remove Mate completely, check terminator is default.
- [ ] Configure default browser, something still missing, see WebAdmin button in CodeMeterCC.
- [ ] Recipe in extra for installing Teams with deb repository see <https://github.com/IsmaelMartinez/teams-for-linux>.

- [ ] Add an openbox menu entry to indent HTML with "tidy -i" with as copy/in place like the other identation scripts.

- [ ] List version of gtk4 in hw_soft_report.
- [ ] Configure gtk4 system wide.

- [ ] Script for changing system lightdm wallpaper.
- [ ] Disable the queuing in caja <https://github.com/mate-desktop/caja/issues/844>.
- [ ] Update rofi theme for error messages?
- [ ] Custom faenza should be installed in user config.
- [ ] Add a script for checking the RAM usage <https://superuser.com/questions/398862/linux-find-out-what-process-is-using-all-the-ram> might be interesting.
- [ ] Can we use <https://github.com/svenstaro/rofi-calc> and assign it to the "Calc" key?
- [ ] Review bash script for data conversion date2seconds and seconds2date. Also add a 2dates2seconds and 2dates2days for computing durations.
- [ ] Bash script for altitude conversion ft, meters, flight levels.
- [ ] Bash alias for printing "DIR_NAME FILE_COUNT DISK_SIZE", something like printf "%-20s %-20s %-20s\n" "$1" "$(ls -1 "$1"|wc -l)" "$(du -h "$1"|cut -f 1)". and then we can easily use this in a find -exec.
- [ ] Bash alias save+revert eclipse workspace/.metadata/.plugins/org.eclipse.e4.workbench.xmi.
- [ ] Icon for arandr?

- [ ] Make the recipe for having debian testing always installed with the apt pref and install firefox with it (no firefox-esr).
- [ ] background color tint2 considering battery power?
- [ ] Notification icon telling about reduced CPU freq?
- [ ] Add a script for start/stop docker.service docker.socket <https://askubuntu.com/questions/766318/disable-docker-autostart-at-boot>.

- [ ] #DCDCDC colored font for tint2.
- [ ] Script for restart_tint2 is broken.

- [ ] Monitor power consumption and read <https://wiki.archlinux.org/title/Power_management>, there is the logs of the battery in `/var/logs` provided by battery-stats. Also see <https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-class-power> where we can find the document for `/sys/class/power_supply/BAT0/`. Add a script to print the average discharging rate (slope), build a better plot with gnuplot.

- [ ] Add a file ~/.config/felix.conf to be sourced in .xsessionrc, it can contain var for translate-notify etc.
- [ ] Target language for translate-notify in sxhkd.
- [ ] Add a button in notification bubble of translate-notify for opening the translation into a text editor.
- [ ] translate-notify cannot be easily configured.

- [ ] Cannot read /dev/video0 facetimehd in mplayer without specify "-vo gl_nosw" or "-vo x11" ? <https://github.com/patjak/facetimehd/issues/198>.

- [ ] Activate geany git diff by default.

- [ ] respawn=no in pulseaudio conf to allow restart?
- [ ] Improve sw so that we can use it a sleep-timer before starting a command.

- [ ] "gtk-enable-animations=0" see <https://askubuntu.com/questions/903160/turn-off-smooth-scrolling-in-gtk3>
- [ ] Disable alert sound from effing GNOME <https://www.reddit.com/r/gnome/comments/jtfrzp/disabling_beep_on_the_end_of_line/>.

- [ ] Better script folder with helper script "graphics-cards-info.sh", "gtk-version.sh" etc.

- [ ] why xfce4-screenshooter replace by mate-screeshot?

- [ ] openbox dynamic menu for a folder of .md files? todo?

- [ ] openbox dynamic menu for tint2 telling in what screen should appear the systray.

- [ ] How to easily configure closing the lid does not mean suspend/hibernate?
- [ ] Could this <https://askubuntu.com/questions/1355031/when-laptop-lid-is-closed-the-desktop-switches-to-external-monitor-ubuntu-20-0> fix the suspend issue while an external screen is connected?

- [ ] Always active dbus interface in VLC.
- [ ] VLC plugin libnotify and no tray icon notifications.

- [ ] Use "active monitor" in Openbox configuration + disable save window geometry and position in Geany.

- [ ] Create a script for alt+print key shortcut `maim -s "${HOME}/Pictures/Screenshot-$(date +"%y%m%d-%H%M%S-%Z").png`.

- [ ] Start pages <https://www.reddit.com/r/startpages/>.

- [ ] Use Hugo or Jekyll for having a local startpage saved into a git repo.

- [ ] Disable flat volumes in debian <https://www.reddit.com/r/debian/comments/3mzkjz/pulseaudio_flat_volumes_madness/>.

- [ ] Tiling with bash <https://github.com/kstenschke/xmchord/blob/master/bin/actions/utils/splitDesk.sh>.
- [ ] Freeze at lightdm login after hibernate on inspiron 7737 (does not occur with the precision 7530!? ), could be fixed with `init_on_alloc=0` see <https://forums.debian.net/viewtopic.php?t=149965>.
- [ ] Geany markdown is not configured anymore with the github css.
- [ ] `apt-cache policy evolution` to show all version available.

- [ ] Bash alias for printing firefox memory footprint with <https://unix.stackexchange.com/questions/288589/get-chromes-total-memory-usage> and `smem -tkP firefox`.
- [ ] Set virtual desktop name with <https://superuser.com/questions/508128/is-it-possible-to-set-the-name-of-the-current-virtual-desktop-via-commandline>.
- [ ] use github repo xlockscreen in the recipe.
- [ ] Can we show the unicode U+hhhh directly in rofunicode?
- [ ] One virtual desktop for external screen? If we change the virtual desktop in the laptop screen it does not change the "presentation screen".
- [ ] Kind of tiling but with a mode with an area where windows are placed we do not see the frame content but just window name and icon, kind of a dick but inside the screen, when clicking it we could have combination of key modifier telling what to do with the window: (1) selecting it (2) use it as master in the biggest area etc.
- [ ] Prepare an example of lemonbar for demo screen: can we mimick tint2 like |virtual desktop #1|virtual desktop #2...|selected window title|system tray| and it should multi-monitor enabled.
- [ ] There is a continuation of tint2 <https://www.opencode.net/nick87720z/tint2>, maybe we should build from there now.
- [ ] Command to turn off bluetooth at startup.
- [ ] Audacious has audio player instead of VLC, it has much better playlist management and reload.
- [ ] Configure font in terminal for having emojis.
- [ ] Install xinput-gui <https://github.com/IvanFon/xinput-gui>.
- [ ] Openbox pipenu for a folder containing .desktop files (teams).
- [ ] Openbox pipemenu for changing primary monitor of Tint2.
- [ ] Key shortcut to move a window from one screen to another with <https://superuser.com/questions/990454/how-can-i-instantly-move-the-active-window-to-a-secondary-monitor-in-openbox>.
- [ ] Change the acceleration for the mouse wheel.
- [ ] xeventbind should probably be started at xsession but it is not. => why do we need xeventbind again? probably should remove it now.

- [ ] Should add an openbox menu for the TODOs, it would start a geany with AllTray => better than one TODOS file opened with autostart.

- [ ] Refactor the scripts folder into ~/bin? or .local/bin?

- [ ] Volume normalization <https://flaterco.com/kb/audio/pulse/volume.html>.
- [ ] Look again at zentile <https://github.com/blrsn/zentile>.
- [ ] Better tiling in rc.xml <win>- adn <win>+ for (un)maximizing the window, switch current window follow mouse cursor or not.
- [ ] use <https://stackoverflow.com/questions/14848274/git-log-to-get-commits-only-for-a-specific-branch> in a bash alias.

- [ ] pqiv or qview or nsxiv for the image viewer, do they have support webp? => gpicview is discontinued, we should go back to eom, at least this one provide drag'n'drop.
- [ ] Add an minimal image viewer such as "edisplay" (good to have one image viewer with no scale smoothing).
- [ ] Find an image browser which can copy the path of the currently displayed image, or do drag'n'drop.
- [ ] Mirage or GPicView? GPicView is slower at rendering SVG graphics.

- [ ] Add configuration for libinput <https://askubuntu.com/questions/1156192/how-to-enable-tap-to-click-in-libinput-on-ubuntu-19-04-x11-unity>.
- [ ] Should have an ExecutionTimestamp for recipe and use it for InstallSoftware.
- [ ] Bug gtk3.24? Mouse wheel events with modifier are used as regular events and scroll panels.
- [ ] Add a ~/bin folder, and the script creating HW+soft report + some alias like getting gtk versions etc. 
- [ ] GitQlient (fork of qgit).

- [ ] Disabled button in Felix-nord is still using the colors from Erthe.
- [ ] Create a palette from a initial N colors, or from a wallpaper, and use this palette create automatically create a new theme <https://github.com/warpwm/lule_bash>. Similar to this <https://github.com/fikriomar16/obtgen> it mentioned pywal to extract a palette from an image.

- [ ] Check `system_update_check.sh` is still running on debian + might install yad from sources.
- [ ] Change the font for tty <https://askubuntu.com/questions/173220/how-do-i-change-the-font-or-the-font-size-in-the-tty-console>.
- [ ] Finish icon indicator for (security) updates available, user action for updating, script for updating a network of machines.
- [ ] Disable "Recent" category in Caja/Nautilus <https://askubuntu.com/questions/294901/how-to-disable-recent-files-folder-in-nautilus>.
- [ ] Still have logs of the kernel printing in my console.
- [ ] Too many logs for pcp in `/var/logs`.
- [ ] Set the DPI with formula from <https://www.kali.org/docs/general-use/fixing-dpi/>.
- [ ] <https://stackoverflow.com/questions/43607461/google-chrome-disable-window-animations>.
- [ ] Use the patch on openbox to ignore the hints, the bug is into the openbox tiling via rc.xml, we should do the tiling via an external tool.
- [ ] Keyboard shortcut to make all visible window undecorated (or all windows in the current desktop) + inverted action.
- [ ] We miss a keyboard shorcut to make appear the window menu (usefull when the window is undecorated).

- [ ] Install <https://github.com/sharkdp/pastel> for processing colors from the command line.
- [ ] The ordering of the files in caja is wrong.
- [ ] Avahi-discover window centered in the screen.
- [ ] Find a way to iterate over a list of GIT repositories and warn the user that some changes are not pushed yet. Maybe it is good to have a 'git' folder in the home after all.
- [ ] Patch openbox for the hints and also for window title disable center justification when window too much small, we should see the beginning of the window title.
- [ ] Memory, cpu and network logging with a service for activating it, and a rolling logging and a nice GUI app to see historical data like kcollectd. Later on I could add the battery info I wanted to.
- [ ] Would be nice to dock a window i.e. fullscreen on other windows would take it into account. The dock is always visible with fullscreened windows (unless floating window overlap the dock).
- [ ] Script for columnating a file based on a regex providing the prefix, the remaining content of the lines is tab aligned, allow to give a max length for the prefix.
- [ ] Convert any images to a color palette <https://ign.schrodinger-hat.it/color-schemes>.
- [ ] Add caja action "Open in geany new instance", i.e. new window.
- [ ] Openbox pipe menu for disable/enable the touchscreen, see <https://mastizada.com/blog/disable-touchscreen-in-gnulinux/>.

- [ ] gucharmap to install and register in openbox menu.
- [ ] Add Noto Color Emojis or another emojis fonts.

- [ ] dotfiles for meld show line numbers, highlight current line, show whitspaces and use syntax highlighting tango.
- [ ] Something is wrong about the ssh-agent, it shows error messages until I copied .ssh folder.
- [ ] Where can I found the mount point from Caja?
- [ ] Finally understand the problem with xdg-open and xfcepanel <https://qastack.fr/ubuntu/5172/running-a-desktop-file-in-the-terminal>.
- [ ] Clean the package list, planck, graybird theme etc.
- [ ] create_recipe_list_file_from_directory() function does not ignore xxxx recipes, it should also be refactored.
- [ ] Openbox shortcut for increasing/decreasing size of a window (horizontally and vertically), only horizonatally, only vertically.
- [ ] Shortcut for black screen (power down the screen).
- [ ] Shortcut "Show desktop" associated to <WIN><F4> should actually be implemented by "Minize all windows".
- [ ] Rofi/OSD menu for openbox window actions?

- [ ] Fix configure_acpi_wakeup.
- [ ] Use t2ec for a better tint2 <https://github.com/nwg-piotr/t2ec>. It would be also good to show the volume as percentage (can be 110%).
- [ ] Can we disable the trash?
- [ ] Disable "Recent Files" in GTK2/3 file chooser and dialogs.
- [ ] Allow sudoers to modify printing configuration (lpadmin).
- [ ] Add a recipe for a git server, access it via http and zeroconf .local ?
- [ ] Auto mount FAT usb stick and all files have execute permissions, remove that.
- [ ] MoveRelative for W-Left|Right|Up|down and MovetoEdge with A-W-Left|Right|Up|Down.

- [ ] VLC plugin shuffle and SongList <https://addons.videolan.org/p/1154018/>.
- [ ] Add a VLC Media Library script manager, can take a list file in argument.
- [ ] VLC song logger <https://askubuntu.com/questions/922418/how-can-i-automatically-log-the-names-of-songs-i-play-in-a-vlc-player-window>.
- [ ] Rule for VLC which save the window dimensions between 2 runs.
- [ ] Bugs in user_playlist.sh: next is not working on macbook air + should not prev/next if only one item in the playlist.
- [ ] UserPlaylist should not use multimedia keys because some applications use PAUSE/PLAY for pausing momentarily the playback, the PLAY will start the playlist. UserPlaylist should be a Rofi plugin.
- [ ] .user_playlist.txt should allow comment with char #
- [ ] Add lua extension for VLC for shuffle playlist <https://addons.videolan.org/p/1154030/>.

- [ ] Documentation and tool to log incoming traffic.

- [ ] Move from Faenza to Obsidian or Delft (they are both based on Faenza).

- [ ] Add a recipe for unified remote for the PI4 <https://www.unifiedremote.com/tutorials/how-to-install-unified-remote-server-deb-via-terminal>.
- [ ] Add a recipe for the PI4 WiFi hotspot <https://www.raspberryconnect.com/projects/65-raspberrypi-hotspot-accesspoints/183-raspberry-pi-automatic-hotspot-and-static-hotspot-installer>.
- [ ] Review bash aliases for time conversion and millis2date should return UTC.
- [ ] Configure firefox with https://support.mozilla.org/gl/questions/1241294 for not allowing website to override Firefox UI shortcuts.
- [ ] Add an action in openbox menu for editing the crontab.
- [ ] Add a .desktop for Impress that can be used directly after making a screenshot for adding annotation.
- [ ] firefox addons for wikipedia CSS <https://addons.mozilla.org/fr/firefox/addon/full-width-wikipedia/>.
- [ ] .desktop with Term=true is not using x-terminal-emulator, could it be it is using $TERM instead?
- [ ] Make sure 'xdg-mime default caja.default inode/directory" is done, it seems it is not.
- [ ] Install todotxt-cli and <https://github.com/hugokernel/todofi.sh>. add the todofi as a mod for the rofi.
- [ ] There is a bug in grub configuration, if no swap partition then the recipe indicates UUID of another partition.
- [ ] Replace apticron by cron-apt which does not install postfix as dependency.
- [ ] Add bash_apt.sh in .bashrc.d with apt functions.
- [ ] tmux instead of screen.
- [ ] Add an action "Edit screenshot with PowerPoint"
- [ ] Add network scan command in bash aliases.
- [ ] Seconde recipe should check depot in sources.list, recipe for installing software may fail if not.
- [ ] Update gtk configuration with the light variant in theme name and add "gtk-application-prefer-dark-theme=false". See <https://unix.stackexchange.com/questions/14129/gtk-enable-set-dark-theme-on-a-per-application-basis>.
- [ ] Add configuration for GIMP to use system instead of the dark theme.
- [ ] re_index_recipe should re-number recipes which are not defaults, keep order but put them after the defaults.
- [ ] On the Dell the switch to headset microphone is not done after pluggin the headset. <https://superuser.com/questions/1312970/headset-microphone-not-detected-by-pulse-und-alsa>
- [ ] Extract archive in terminal shows an error dialog even if unpacking sucessful.
- [ ] Add a convertWebpToPng caja script.
- [ ] Open browser quarter of the screen, lower-right corner of the screen.
- [ ] Add regexer and http://mathew-kurian.github.io/CharacterMap/ in a bookmark tools.

- [ ] Caja script for sorting file, same for removing duplicates.

- [ ] Find the project on github for reminding shortcuts (command line and rofi) <https://gitlab.com/matclab/rofi-i3-shortcut-help>.
- [ ] Would be perfect to be able to choose the mail client: claws-mail, Evolution, Thunderbird. Can suceed in doing that today when Thunderbird and Evolution are installed, the change is not detected.
- [ ] Deactivate Rofi modi ssh and try to add rofi-buku. => don't like buku in the end...
- [ ] Find a good portal for firefox or a Web Bookmarks application.
- [ ] Check good usage of `xdg-settings set default-url-scheme-handler`. See <https://wiki.archlinux.org/index.php/Xdg-utils>.

- [ ] Recipe family conf should contain a variable for the mail client (claws, evolution etc. ), it should be installed by install.sh and set in openbox menu.

- [ ] Key shortcut for applying geometry to a window something line 512x512 on the left-bottom corner of the screen. It would be even better if it could be to3ggable.
- [ ] Create better graphs with gnuplot and battery-stats-collector.
- [ ] tint2 is not listening to changes in monitors: which one is primary? Add detection of primary in starter script and set tint2 configuration file.
- [ ] Update CSS for Geany Markdown plugin + configure properly the plugin during install.
- [ ] Geany Markdown plugin is not resetting the vertical scroll.

- [ ] How to set the primary monitor from the command line and add it in `ob-randr.py`.
- [ ] all calls to rename_for_backup should use a suffix (felix_install_yyMMDD_HHmmss.SSS)
- [ ] add menuitem for showing battery performance (battery-graph or our own gnuplot script). It can happen that the battery level is off the chart with battery-graph.
- [ ] dialog_command v2 and v3 are not used => in the end it will be replaced by yad, delete them?
- [ ] How to get the list of recommended packages for a package to install?
- [ ] Add a note for encrypted USB key.
- [ ] Use autorandr to change lightdm resolution and new screen is detected.
- [ ] Would be useful to have a short program putting a icon in the tray and click-left="show a dialog" and click-right="Contextual menu with one item: Exit". Would be also useful if a notification could be shown when then icon appears. Could be also the dialog to be showed automatically.
- [ ] Recipe for dictionary and spelling (for example: US, FR). For Geany, we need hunspell => have a openbox menu for installing dictionary, use yad for selecting the language. It could be a bash function and one alias.
- [ ] TLP and CpuFreq for lower average temperatgure? Thermald for logging? pcp?
- [ ] Numeric keyboard disabled after wake from hibernation.
- [ ] Change the format of file "Owner" in Caja? We don't want to se extended login "login - Name" but just "login".
- [ ] Action for naming the current desktop with the name of an application + revert to default.
- [ ] pipemenu in openbox for .desktop files in ad-hoc location, something like ~/.config/openbox/menu-apps/
- [ ] Add bash function in .bashrc for downloading a list of URLs from file.
- [ ] Rofi menu for session actions <https://bbs.archlinux.org/viewtopic.php?id=93126&p=2>.
- [ ] Better documentation in openbox rc.xml (with "Window Actions" section) see <https://bbs.archlinux.org/viewtopic.php?id=93126&p=2>.

- [ ] List parameters useful to the user regarding dpms, lightlocker, suspend-then-hibernate => check if there is a yad panel for dpms.
- [ ] Special menu in rofi for the XF86 symbols.
- [ ] Window frame icon for being on top of other windows (pin).
- [ ] Check command to start by fdpowermon when reaching critical level of battery power => should be a script asking the user what do you + a timer "going to hibernate... ".

- [ ] Brillo and Display: keyboard backlight in console (keysym ?).

- [ ] macbook air: analysis of battery consumption and CPU usage.
- [ ] macbook air: acpi_osi in kernel pameters see <https://wiki.archlinux.org/index.php/Mac#Suspend_and_Hibernate>
- [ ] macbook air: kernel parameter for acpi on macbook air (native).
- [ ] macbook air: screenshot key => Rofi menu?
- [ ] macbook air: fix the Xmodmap for +/- and paragraph key.

- [ ] Check what is missing if we do not use a Power manager (multiple displays support in logind?).

- [ ] Use xdg-open from openbox (no panel no desktop). We can use "dex" but would be good to be able to use xdg-open (gtk-open, exo-open etc. ).
- [ ] locate panel-desktop-handler.desktop => this desktop file is called for creating a shortcut for each execution of one desktop file with exo-open, gvfs-open, xdg-open etc.
- [ ] Add traces for monitoring the time taken for the installation.
- [ ] scroll by pixel/pc amount in LibreOffice Calc (rather by number of rows).
- [ ] <https://bugs.launchpad.net/ubuntu/+source/gvfs/+bug/378783>.
- [ ] A script at startup of openbox checking for the default application and notify the user about some changes. Have a look at Xfce4 MIME Type Editor.
- [ ] Need a way to do some settings regarding the sensitiviy of the touchpad/mouse a save these settings. The xfce4-mouse-settings is not saved and even worst it is reset during a session but it probably because I use it in a not-XFCE desktop.
- [ ] Test if caja gets unresponsive when the NFS is mounter via a regular mount command rather via gvfs. Just test it by mount it, access it via caja, unplug the network and access it again via caja.
- [ ] Shortcuts for tiling the windows + boxing all the windows on the screen.
- [ ] Read <https://github.com/capn-damo/Openbox-tiling/blob/master/ob-tile.sh>.
- [ ] Add a note for the static route for accessing trevize.net from the local network.

# ISSUES

- [ ] GPicView: slow at rendering SVG files.
- [ ] Caja: create new directory with name starting with a dot is bugged.
- [ ] Caja: renaming a .desktop file is bugged.
- [ ] Caja: opening 2 window of file Properties is buggy.
- [ ] Caja: always show the file name (extension are hidden for .desktop files for example) See <https://github.com/mate-desktop/caja/issues/727> open ticket.
- [ ] Caja: when opening executable scripts (bash, python) => contextual menu is showing 'open'. Good UX would be 3 menu items: 'Run', 'Run in terminal' and 'Open with X', X being the default application for the mime type. However today there is only 'Open' which will open dialog a popup asking 'Display or run or run in terminal?'. The user does not know what is behind 'Display', display with what??? Even worst: the default application for the mime type is not listed in the 'Open with' maybe because, well... it is the application used for 'Display', erf...
- [ ] Caja: seems to mount ftp without unicode support.
- [ ] Geany/Markdown: plugin is not properly using the css specified (colors are not used and lines starting with the character `#` inside a blockcode are treated as a heading).
- [ ] Geany/Markdown: when all the document are closed, the Markdown Preview still shows the last preview done.
- [ ] Geany/Markdown: the links are clickable in the preview, if we click one link then the page is showed in the sidebar but there is no way to navigate and go back to the preview.

# DONE

- [x] fix toogle tint2.
- [x] fix_debian recipe name contains a typo.
- [x] Replace autorandr with saved screen layout with arandr and a rofi menu?
- [x] rofi for airport code, country code, phone prefix => could use <https://github.com/ip2location/ip2location-iata-icao>.
- [x] add a script for adding a start/end element to an XML file and indent it.
- [x] Caja scripts should starts command in background else it might freeze the GUI (like indenting more than 1GB large XML file).
- [x] osd-warning and herbe.
- [x] Debian12: minimal felix? => install from debian repository by default, build from source is optional.
- [x] Install of gtk3-nocsd should be a recipe and disable by default. Bash environement should adding the lib nocsd only if it is installed.
- [x] Install autorandr and configure restore script <https://bbs.archlinux.org/viewtopic.php?id=248757>. => winlayout.
- [x] Install and configure autorandr <https://stackoverflow.com/questions/73671674/how-to-auto-run-script-after-applying-arandr-setting>.
- [x] Install sw in user home.
- [x] Use tidy in XML indentation because we found some XML xmlstartlet could not indent while tidy could.
- [x] Make indentation script for caja able to process multiple selection.
- [x] Install curl by default.
- [x] <https://github.com/jalopezg-git/openbox/tree/enable-full-GTK-CSD>.
- [x] Modify most of the recipes installing software from sources for installing from repository and only optionally from sources.
- [x] Should not use .xsessionrc because WM name is not known at the time of execution and also it is debian specific. We should use openbox autostart instead.
- [x] 99_start_vnc_server is broken because still copied into .xsessionrc.
- [x] Remmina do not show icon tray by default.
- [x] Debian12: cannot build arandr but we do not need to, now 0.1.11 is in the debian depo.
- [x] Two ways to fix polkit: (1) mate-polkit or (2) policykit-1-gnome.
- [x] gtk3.css hide the headerbar.title was for Remmina but cannot use it anymore because of Firefox using the headerbar for tabs.
- [x] User Background in lightdm does not work => maybe it was running as root before but not anymore? Solution is to g+x on the home folder and add lightdm to the user group.
- [x] Install members by default.
- [x] Debian12: fix install rofimoji with python venv.
- [x] Debian12: "error: externally-managed-environment" when using pip3, see <https://www.jeffgeerling.com/blog/2023/how-solve-error-externally-managed-environment-when-installing-pip3>. => use python venv is better anyway.
- [x] Debian12: Cannot build pamixer, the recipe should be removed, I guess it wasn't working in Debian11 either.
- [x] Execute xsession files only if openbox.
- [x] Google maps search in firefox. => gmaps links fixed in more recent firefox, we should install firefox from unstable instead of firefox-esr. 
- [x] Debian12: Fn keys make firefox headerbar blink, quite weird behavior. => it not doing it with recent firefox 121.
- [x] Firefox no gtk scrollbar overlay by default.
- [x] Debian12: use DejaVu for monospace font instead of Noto <https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1028643#26>.
- [x] Install nomacs.
- [x] Replace youtube-dl by yt-dlp => just remove the recipe for youtube-db, yt-dlp is easy to install in ~/.local/bin it is just a script to download.
- [x] `xdg-settings set default-web-browser firefox-esr.desktop` and <https://askubuntu.com/questions/16621/how-to-set-the-default-browser-from-the-command-line>.
- [x] Default web browser not correct (see meld or Formiko) can see that in firefox too.
- [x] Use update-alternatives for gnome-www-browser <https://askubuntu.com/questions/191696/whats-the-difference-between-x-www-browser-and-gnome-www-browser>.
- [x] We can certainly delete 0080-u-configure_xfce4_thunar.
- [x] Add mugshot to the openbox menu.
- [x] Add command for xml-unindent.
- [x] Rename maim_screeshot.sh in .local/bin.
- [x] Rename seconds2date and date2seconds and move them to .local/bin.
- [x] Geany is quitting with shortcut CTRL+SHIFT+V which is boring because we can type that by mistake when copy/paste from terminal => this is because of a known and fixed bug <https://github.com/geany/geany/issues/2813> but we should fix the install_geany_from_sources recipe.
- [x] Hide gtk3 duplicated window title because of nocsd <https://github.com/PCMan/gtk3-nocsd/issues/19>.
- [x] Add pandoc (markdown to html).
- [x] Add csstidy => the tool seems to change the css, do not use it.
- [x] Installing Evolution from testing removes xorg (xorg after an upgrade to testing) if done with apt, but aptitude can resolve better the dependencies conflict.
- [x] Install git_sup.
- [x] Check the /etc/xdg/autostart again, we should override the desktop files in user home.
- [x] Add a recipe for install <https://github.com/MunifTanjim/rofunicode>.
- [x] recipe for rofimoji should copy configuration file.
- [x] Add recipe for apt preferences bullseye, testing and unstable (firefox).
- [X] Install `xorg-xinput` for libinput (replacing synaptics), or use mtrack => removed configuration envvar XORG_INPUT_DRIVER, libinput is the default in debian11.
- [x] Remove the setting for mtrack in felix.conf.
- [x] Rework the script for nitrogen and setting background in LightDM and retrieve the first occurrence of "file=" because it does not work as-is with a multiple display setup.
- [x] .local/bin is not added to the PATH? The override of Nitrogen to update user wallpaper is not used.
- [x] Cannot detect the colors which are not taken from the palette in update_theme.sh.
- [x] Configuration libinput <https://unix.stackexchange.com/questions/337008/activate-tap-to-click-on-touchpad> it replaces synaptics.
- [x] mtrack configuration should check if there is already a \d+_mtrack.conf file in /usr/share/X11/xorg.conf.d/ => mtrack is not used anymore
- [x] Install rofimoji <https://github.com/fdw/rofimoji>.
- [x] Is it possible to make work the TRRS on Linux? => YAGNI.
- [x] Immediate wake up after suspend/hivernate if LID not closed. It happens because of ACPI LID events enabled (if disabled then I do not see the problem). There is something to fix here, the problem does not occur on Dell Inspiron. => disabling the trigger for the LID on macbook air seems to not work with udev, must do it with a systemd service.
- [x] Install dlna support => No needed right now.
- [x] Check if sshfs and fuse are installed.
- [x] Toggle shortcut to show/hide tint2.
- [x] fix toggle_tint2.sh and merge into the same script the restart_tint2.sh.
- [x] We can certainly use only sh in xsession.d scripts.
- [x] create github repo for xlockscreen and add a parameter for switching the virtual desktop with `wmctrl -s VIRTUAL_DESKTOP_ID`.
- [x] Disable pcp zeroconf? => this was because of pmproxy which is not installed anymore.
- [x] lsb_release does not give the id of the distrib on debian => use `lsb_release -a`.
- [x] glogg --multi.
- [x] Shortcut in geany comment lines => <CTRL>+E
- [x] Caja action execute in Terminal is not loading bashrc or PATH is not correcly set => cannot reproduce it.
- [x] cron task "gpo update && gpo download" + manage cron list with cockpit?
- [x] Bash coloring for ls etc. see <https://wiki.debian.org/BashColors> => this was a bug due to an override of the alias for ls.
- [x] Move the xset setting from .xsessionrc to a script in scripts, can be set at startup via an autostart => script in .xsessionrc.d
- [x] Install cockpit and add a menu item in openbox for locahost:9090.
- [x] Openbox menu to open autostart folder => YAGNI.
- [x] Activate autosave in geany => don't want it.
- [x] Write a script rendering the openbox theme in HTML with colored blocks.
- [x] Errors while installing pcp => we do not install it from the sources.
- [x] Move LightLocker configuration in openbox menu, it is not only about the Display => renamed the menu entry "DPMS"
- [x] Can I replace clipmenu by <https://github.com/mrichar1/clipster>? => replaced by parcelitte
- [x] Font size seems different with the resolution => missing .Xresources
- [x] Reworked remote desktop software and use tiger VNC.
- [x] Something is installing PackageKit, what? check with clean install if PackageKit is installed. => Cockpit is installing packagekit.
- [x] Copy start_http_server_for_apt_mirrors.sh in the scripts folder => copied it with empty repo folders in felix.
- [x] Fix path for debian.
- [x] Desktop font should be configurable via recipe family .conf file => YAGNI.
- [x] Add a recipe for SetWorkspaceLayout => it is obsetlayout and we do not need this for now.
- [x] Check the DPI see <https://wiki.archlinux.org/title/HiDPI#X_Resources> => fixed with .Xresources.
- [x] Install pass from the sources, not from a release.
- [x] remove clipd and use parcellite.
- [x] Clean openbox menu (glances etc. ).
- [x] Add menu item for editing xsessrionrc.
- [x] remove gromit and gkxset and xfce4-mouse and keyboard.
- [x] Add action for updating the openbox theme or at least open a file manager with current folder being the theme folder.
- [x] Missing packages should kill the installation but it is not, maybe we should check the repository sections available.
- [x] We can set the size of the mouse cursor with an entry in .Xresources.
- [x] Replace xfce-screenshooter with "mate-screnshot -i".
- [x] Sync nitrogen wallpaper and lightdm <https://forum.maboxlinux.org/t/sync-nitrogen-wallpaper-with-lightdm-background/674>.
- [x] Build eom from the sources <https://github.com/mate-desktop/eom> and set default mime type for eom.
- [x] Introduce .xsessionrc.d
- [x] Bluetooth on debian is a bit unstable it seems, check if it is using bluez-firmware see <https://wiki.debian.org/BluetoothUser/a2dp> and <https://wiki.debian.org/BluetoothUser>.
- [x] Should not start the VNC server via .desktop file => now done with .xsessionrc.d
- [x] .desktop file for starting the VNC server should not call the screenlayout script.
- [x] Compile Remina from the sources? => heavy task, it is better to install it from testing.
- [x] Glances seems to be automatically started, disable the service. => removed from list of packages to install.
- [x] kcolorchooser instead of gpick. => kcolorchooser is very basic, to pick a color we can use geany.
- [x] Rofi mode for remmina files and use a icon per type of connections SSH, VNC, RDP etc. the modi can used an index which could be rebuilt by quick-checking the files. => done with rififi.
- [x] Remove XDG desktop folder and check on /etc/xdg/user-dirs.conf => if Desktop does not exist then Caja recreated it.
- [x] <https://wiki.debian.org/NetworkManager> and let NetworkManager to manage the interfaces.
- [x] Recent version of xfce notifyd => in debian11 we already have a recent version, not the last one but just before. We can configure where to show the bubbles.
- [x] Command and key shortcut to extract text from an image, write the text in a temp file and open a text editor (think about these websites where you cannot select the text, like in office365).
- [x] It seems `xss-lock` does not work with `dm-tool lock` or `dm-tool switch-to-greeter`. Use `i3lock` instead <https://gist.github.com/victorhaggqvist/603125bbc0f61a787d89>. => did it but switched back to dm-tool, we prefer.
- [x] Install `i3lock-color` from the sources, and update the rofi power-menu for calling the proper lock command, and also re-order the menu entries => added the recipes in extra but not using it, we prefer light-locker in the end.
- [x] Can we use xeventd to detect that the primary monitor changed and then update tint2 conf + restart it. At least we could retrieve the primary monitor when starting tint2. => not really useful, we can just edit tint2rc.
- [x] Hibernate in a file <https://forums.debian.net/viewtopic.php?t=150284> => only disadvantage with it. Not doing it.
- [x] Add nitrogen which is handy for multihead setups and restore the wallpaper in `.xsessionrc`.
- [x] Always execute MyScreenLayout.sh if the script exists.
- [x] Fix key shortcut for translate-notify via screenshot.
- [x] Install translate-notify via the github project.
- [x] Create github repositories for Openbox theme and for translate-notify.
- [x] Desktop files are using $TERM for the "Terminal=true" property, we should set "TERM=x-terminal-emulator" somewhere. => this seems to be fixed in Debian11.
- [x] Fix ob-randr.sh <https://raw.githubusercontent.com/owl4ce/dotfiles/main/.config/openbox/pipe-menu/ob-randr.py> and openbox menu.
- [x] Openbox theme should be installed in user space.
- [X] Do not really need the install_themes recipe, but just copy .themes in dotfiles.
- [x] Relocate restart_tint2.sh into tint2 config folder, check other scripts too.
- [x] Edit and restart sxhkd from Openbox menu.
- [x] Bash script for re-formatting openbox theme file. => no just use a sort command and remove all extra lines.
- [x] Replace compton by picom (if fixes the bug with Java).
- [x] Script for setting the wallpaper + use xeventbind <https://github.com/ritave/xeventbind> for re-executing the script.
- [x] MyScreenLayout conflict with the wallpaper set with hsetroot => register an action executed at resolution change.
- [x] Translate-notify does not work => the new version of the script still is MyMurtaugh.
- [x] Replace light-locker with xss-lock.
- [x] Install rofi menus <https://github.com/adi1090x/rofi> or rofi-power-menu <https://github.com/jluttine/rofi-power-menu> and update sxhkd for power button.
- [x] Add uniutils.
- [x] bash alias "ls --time-style=long-iso".
- [x] Rofi configuration is not complete, fullscreen.rasi is missing and the config file is not updated.
- [x] Script and openbox menu action to open the theme folder.
- [x] Xfce Mouse and Keyboard configuration do not work for Openbox, should be removed.
- [x] Remove cheese, it is replaced by guvcview => already removed but show guvcview in openbox menu.
- [x] <https://www.reddit.com/r/linuxquestions/comments/pmodjk/cant_change_text_color_in_rofi_theme_file/>.
- [x] Stop the kernel flooding the console <https://superuser.com/questions/351387/how-to-stop-kernel-messages-from-flooding-my-console>.
- [x] Cannot add command in rc.local because the file ends with 'exit 0'. => where? Cannot reproduce.
- [x] Improve Remmina recipe: notification icon, tree view => added the configuration in dotfiles directory, should not do a recipe for that.
- [x] Add kdesvn in tools.
- [x] Pasystray: middle click on the tray icon is not muting the sound anymore => fixed in recent version of pasystray.
- [x] Caja: copying files is very slow compared to the command line (local or remote) => it can be because of GVFS => nothing to fix.
- [x] dmenu: dmenu appears on the monitor on which the currently focused window is located. It should use the mouse pointer location to determine the monitor. => we use rofi now.
- [x] At reboot & shutdown it can still be waiting for the nfs mount points to be unmounted. => it can be because of GVFS, using AutoFS could also be an improvement. => we are using autofs now.
- [x] Add ssh-agent.sh in .bashrc.d.
- [x] Disable the autostart of the ssh-agent with <https://unix.stackexchange.com/a/79861/169557> and start it from .xsessionrc and .bashrc.
- [x] Replace the code for finding felix.sh by the oneline in <https://unix.stackexchange.com/questions/6463/find-searching-in-parent-directories-instead-of-subdirectories>, and remove the extra "felix" directory.
- [x] Replace locate by plocate.
- [x] Fixed pre-installation of firefox addons.
- [x] Firefox is asking to save the passwords => it was because "firefox -p" does not exist anymore, correct argument is "-P".
- [x] Remove cheese, it i replaced by guvcview.
- [x] Evolution processes keeps running after executing Evolution => evolution --force-shutdown.
- [x] Should install rofi from sources.
- [x] Configure_apticron#ubuntu_bionic should be moved to xtra.
- [x] Use clearine for openbox exit dialog, we need to because python2 is removed from Debian11 <https://github.com/okitavera/clearine>. => will use rofi instead.
- [x] Use hsetroot instead of xsetroot which is not compatible with xcompmgr/compton.
- [x] Add bash library scripts via the .bashrc.d
- [x] Create recipe for patching apt-mirror <https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=932379>.
- [x] change pidgin icon for using the stock icon. => do not use pidgin it's even better.
- [x] kpie does not listen to window title change. => we use devilspie2 now.
- [x] Rofi menu <https://gitlab.com/vahnrr/rofi-menus>. => use <https://github.com/adi1090x/rofi> instead.
- [x] XF86 keys for audio should be managed by sxhkd if pasystray.
- [x] Do the settings for the firefox megabar off <https://support.mozilla.org/en-US/questions/1274579>. => not relevant for recent version of firefox.
- [x] install engrampa from the sources allows the 'Extract here/Compress' menu in Caja.
- [x] Activate geany plugin addons and mark words. 
- [x] Fix MyBashAliases.sh because hyphens are not allowed in valid names in bash see <https://unix.stackexchange.com/questions/168221/are-there-problems-with-hyphens-in-functions-aliases-and-executables>.
- [x] Should not use the `git config --global` but rather have a bash function for easily write the .gitconfig in the repository.
- [x] Add recipe for installing vivaldi + update libwidevine amd and arm. => we forget about raspberry for now.
- [x] Fix ssh welcome for Raspbian. => we forget about raspberry for now.
- [x] Show delete in Caja configuration.
- [x] Add a recipe to build caja from the sources.
- [x] Install compton and start it with openbox, many app needs it nowadays like Teams showing a red border around the screen telling the screen is shared.
- [x] Resume from hibernate works after installing the NVidia drivers, problem seems similar to <https://forums.linuxmint.com/viewtopic.php?f=46&t=346628&sid=03c9ee952fdb05f83abbd3fae9de1f71&start=20>.
- [x] Firefox window is not repaint properly when resized if hardware acceleration enabled.
- [x] Backlight level is not restored after reboot => because of "acpi" when configuring grub, I should remove that, it was for the macbook air.
- [x] If we build the geany-addons then we should probably build geanny from the sources.
- [x] Install nocsd, it's not only for the header bar but also for the window frame and resizing handles + active it via .xsessionrc.
- [x] Force_soffice_to_use_single_instance should be move to attic.
- [x] Add pdfgrep, ttyclock and webp to list of packages.
- [x] Activate by default "Addons" plugin in Geany.
- [x] Add in VLC config "one-instance-when-started-from-file=0".
- [x] Add create_dependencies_file_from_package_list_file() bash function using 'apt-cache depends package-name' and/or 'apt-rdepends'.
- [x] Add recipe for configuring Atril => added the configuration in dotfiles directory, should not do a recipe for that.
- [x] Bash script with respawn for VNC server.
- [x] Rework gandi-dyndns, the project is obsolete and does not work anymore. => replaced by gandi-automatic-dns.
- [x] Use autofs for preventing caja to freeze when NFS/Samba is down or network problems. See <https://unix.stackexchange.com/questions/267138/preventing-broken-nfs-connection-from-freezing-the-client-system> and <https://help.ubuntu.com/community/Autofs>.
- [x] Remove PulseAudio for Raspbian.
- [x] Key binding for XF86 mute, lower and raise volume should be managed by pasystray if pulseaudio, or volumeicon if alsa.
- [x] Key binding for pulseaudio in sxhkd should be disabled for raspbian.
- [x] Add the env. var for disabling CSD, and check over variables too <https://developer.gnome.org/gtk3/stable/gtk-running.html>.
- [x] Add a recipe to fix timezone.
- [x] Alias `ls -lh` for `ll`.
- [x] First recipe in system-software should be re-generating the locales. See <https://www.thomas-krenn.com/en/wiki/Perl_warning_Setting_locale_failed_in_Debian>.
- [x] install.sh should use `lsb_release -d` instead of `cat /etc/lsb-release`.
- [x] Additional fields in recipe ID for stated install by default => RECIPE_CATEGORY
- [x] locate and sshpass not installed by default
- [x] Caja script "Execute script" but not with a terminal (double-click the file in caja does not work if the file is not set as executable).
- [x] Default configuration in Geany: symbol view should be ordered by appearance, not lexicographic order.
- [x] Add a "File processing" menu in openbox and shortcut to trash-empty directly in the openbox menu => "File Utils"
- [x] WWw Browser in incognito mode in the openbox menu, use a font with icons to add sunglasses icons.
- [x] backlight value at boot time can be too low (20 on the macbook) => fixed by using acpi_backlight=native
- [x] kernel acpi_backlight=native for macbook air (and don't need the fix for backlight after suspend).
- [x] Recipe for configuring apticron (setting the email).
- [x] Should keep apt.daily actived.
- [x] Make avahi workstation published (publish-workstation=yes in /etc/avahi/avahi-daemon.conf)
- [x] It should be a choice to use mtrack or libinput, and put the default on libinput.
- [x] Caja script compare should support one file compare with meld => revisioned file.
- [x] Add a doc for managing security updates: server => email with apticron, or automatic install (with unattended-update https://www.cyberciti.biz/faq/how-to-keep-debian-linux-patched-with-latest-security-updates-automatically/), desktop => icon in the window manager and SSH motd (this is done in motd configuration already).
- [x] Do not add alias and function to .bashrc but source .bashrc.d files
- [x] Update openbox menu.xml for pidgin.
- [x] move geany_one_instance_per_workspace to /usr/local/bin
- [x] Title for terminal for htop started from the menu or from <WIN>h should be "htop".
- [x] Add avahi-discover in openbox menu.
- [x] Missing polkit rules for cups see <https://wiki.archlinux.org/index.php/CUPS#Allowing_admin_authentication_through_PolicyKit>.
- [x] Do not show resolution below SVGA in openbox pipemenu randr
- [x] Add a openbox menuitem for light-locker-settings.
- [x] Rework openbox menu.
- [x] Add recipe for gtkxset and add openbox menuitem for it.
- [x] Add a Caja script for unpacking archive with unp (because unpacking big archives with the Caja/Engrampa plugin makes Caja lagging a lot).
- [x] Open GoogleDrive should pop up a new Forefox window.
- [x] git preferences are not applied.
- [x] Remove Thunderbird from openbox menu.xml.
- [x] Add randr pipemenu <https://github.com/whiteinge/ob-randr>.
- [x] recipe for configuring firefox seems to don't work anymore.
- [x] Add nbtscan.
- [X] set the LC_COLLATING for a proper sorting in caja <https://askubuntu.com/questions/10896/nautilus-sorts-the-name-column-mysteriously-how-can-i-change-the-collating-se>
- [x] Command line git-flavored markdown-2-html? with pandoc or <http://daringfireball.net/projects/downloads/Markdown_1.0.1.zip>. => use mmark.
- [x] Extract localisation FR from minimal.packages.list, it should only contains US locales.
- [X] It seems thunderbird is not using x-www-browser (chromium is used), "network.protocol-handler.warn-external.http" should be true for all. gnome-www-browser should be set too (not only x-www-browser). => stopped to use thunderbird.
- [x] Rofi for clipmenu.
- [x] Set "mailto" for thunderbird or claws-mail.
- [x] Compile from source <https://github.com/freedesktop/xdg-desktop-file-utils> because command "update-desktop-database" is bugged in Ubuntu 18.04 => it is not a bug.
- [x] Configure default difftool for git, editor etc.
- [x] "enter your password to unlock your login keyring". => it happens when the keyring is not named "Login". See <https://wiki.archlinux.org/index.php/GNOME/Keyring>.
- [x] For GDM and LightDM, the keyring must be named login to be automatically unlocked <https://wiki.archlinux.org/index.php/GNOME/Keyring>.
- [x] Add a Felix rofi theme inspired by the dmenu theme we already have.
- [x] Check the configuration of DokuWiki (entities etc.).
- [x] Doing the autostart with the openbox autostart is much faster than with .xsessionrc
- [x] Add recipe for building tint2 from sources.
- [x] Jar should not be associated to Java.
- [x] pdf are opened with gimp.
- [x] Add a Caja script for executing a script into a terminal and "press a key" before exit the terminal.
- [x] Get a useful logging of all the paclages installed in the system (think about the version of the GTK libs for example, pasystray middle click on tray icon for mute is not working anymore).
- [x] virtual keyboard: onboard or florence. => onboard
- [x] Add an alias in bachrc or a menuitem in openbox menu for doing a screenshot of a window with 'xwd'.
- [x] Cannot install ubuntu_1804/user from a tty. We should test is $DISPLAY is defined. Should be done via a function in common.sh exit_if_not_x_session() => only do that for the recipe that need x session
- [x] Make changes allowing to run 'info.sh' without 'common.sh'.
- [x] "tint2rc": caja will open the file with "Tint2 Settings", how does it works?
- [x] Add recipe for suspend-then-hibernate, see <https://askubuntu.com/questions/12383/how-to-go-automatically-from-suspend-into-hibernate>
- [x] Bit of tiling: grow up window, i.e. increase width/height until reaching another window or screen edges or panels.
- [x] Only clipboard and not primary in clipmenu?
- [x] Replace pasystray by pnmixer + call paprefs
- [x] Cups server is not installed.
- [x] Add missing pulseaudio packages.
- [x] Recipe for configuring grub with hibernate actived is buggy, if no swap partition when the startup hangs up for 30seconds, See <https://askubuntu.com/questions/1034359/boot-hangs-for-30-seconds-at-begin-running-scripts-local-premount>.
- [x] Use ncurse for showing a dialog and allow to select some recipes to install.
- [x] Remove aspell-fr from minimal.install.list
- [x] Use whiptail to create a recipe selector.
- [x] Clean recipe openbox clipmenud_run.sh should be removed? Check about that. => yes. Removed.
- [x] Add caja script for indenting XML file
- [x] Add recipe for updating the XDG default directory (remove "Templates" and "Music" should be default). => done as recipe in system-configuration.
- [x] Add function exit_is_has_root_privileges and use it in user family recipes.
- [x] Read doc about the DPMS <https://wiki.archlinux.org/index.php/Display_Power_Management_Signaling> and add doc in openbox autostart.
- [x] Move hotkeys from openbox rc.xml to sxhkd.
- [x] Copy the felix banner in a file. => no but put it in felix.sh
- [x] Add a recipe for installing claws-mail from sources + plugins (fancy, vcalendar etc. ).
- [x] alias github-clone should use https
- [x] Do not start fdpowermon if no battery, test in openbox autostart.
- [x] Move the scripts (including the openbox scripts) in a script folder in the $HOME.
- [x] Improve recipe for configuring apt-mirror and adding local repository in apt sources.
- [x] Add a recipe (disabled by default, in extra) for installing virtualbox guest packages.
- [X] Add a 'dotfiles' folder in the RECIPE_FAMILY_DIR.
- [x] BASEDIR in the recipes is actually RECIPE_DIR. Add RECIPE_FAMILY_DIR.
- [x] Retrieve FELIX_ROOT with the pwd.
- [x] Indent JSON command.
- [x] Rename ubuntu_18.04.sh to ubuntu_18.04.conf.
- [x] Replace dmenu by rofi? => not by default but it is installed now.
- [x] Skype: tray icon/app-indicator is buggy. It happens with skype and possibly others, the problem is in libappindicator and/or Electron <https://github.com/mate-desktop/mate-panel/issues/793> <https://answers.microsoft.com/en-us/skype/forum/skype_linux-skype_startms-skype_installms/system-tray-icon-in-xfce/d3f162bf-0bbf-481b-90a1-f43cae9a86cc?page=5> <https://github.com/electron/electron/issues/12791>.
- [x] Set lightdm settings.
- [x] Set cursor themes.
- [x] Install xterm (not installed by default with ubuntu miniso).
- [x] On the Dell the fn key for keyboard backlight is not working properly because there is only one key => it is managed by the hardware, no known X86 symbols for this key.
- [x] On the Dell I can see 2 notifiations when I change the backlight => use xshkd and lock the notification_id file.
- [x] Improve recipe for ACPI events (notably USB etc. expect LID) with a script to be called by the service. Could be the script will be used not only for ACPI wakeup but also for others ACPI event groups.
- [x] Disable bluetooh module better than current recipe see <https://askubuntu.com/questions/67758/how-can-i-deactivate-bluetooth-on-system-startup> + action in openbox menu for re-activating it.
- [x] Hibernate is not working anymore => should add a kernel parameter, see <https://soulkiln.blog/2018/08/14/ubuntu-18-04-hibernate-and-suspend-fix/>.
- [x] Fix the icons for xfce4-power-manager. See <https://bbs.archlinux.org/viewtopic.php?id=216495>. => use fdpowermon now.
- [x] Install xdg-utils from sources. => complicated, xdg-utils is a dependency for many packages.
- [x] Add recipe for fdpowermon + specifies icons from Faenza for the battery indicator.
- [x] Scrolling with mtrack is too much sensitive.
- [x] Geany: key shortcut for "Line wrapping".
- [x] Install dex: "DesktopEntry eXecution implements the Freedesktop.org autostart specification, independent of any desktop or window manager environment.". Why xdg-open is not implemented the same way? See <https://github.com/jceb/dex>.
- [x] Add a recipe for disabling the Mac startup chime.
- [x] Patch EOM for not showing "set background" is window manager is not Metacity (the WM which should be used with EOM). Use $XDG_SESSION_DESKTOP. => EOM replaced by GPicView.
- [x] Still a problem with mtrack we do not have right click with the 2-fingers tap.
- [x] Refactor "common.sh" to "felix_xubuntu18.04.sh" and extract functions in a common.sh located at the root of the project.
- [x] Add a recipe for "brillo" <https://www.reddit.com/r/archlinux/comments/9mr58u/my_brightness_control_tool_brillo_has_a_new/>.
- [x] Brillo + notification if X.
- [x] Prevent notify-send from stacking <https://unix.stackexchange.com/questions/376071/prevent-notify-send-from-stacking>
- [x] Add recipe for notify-send.sh <https://github.com/vlevit/notify-send.sh>
- [x] gpicview should replace EOM (replace the text in the .desktop file)
- [x] Remove alltray.
- [x] Make the DisplayLink works.
- [x] Search for "apt" in the project and avoid to use apt, use apt-get instead when possible.
- [x] Remove blueman-applet from Openbox autostart and add a menu entry for starting it. 
- [x] Should revert to xfce4-power-manager.
- [x] Openbox add keybinds in openbox rc.xml for mouse clicks.
- [x] Add shortcuts from openbox in shortcuts.md.
- [x] Add pigz
- [x] Execute the dstat recipe by default but do not start the service.
- [x] Install dstat from source.
- [x] Disable the automatic update in ubuntu <https://askubuntu.com/questions/1059971/disable-updates-from-command-line-in-ubuntu-16-04>.
- [x] Pulse audio does not restart properly after logout/login. Fixed with <https://wiki.archlinux.org/index.php/PulseAudio/Troubleshooting#ALSA_channels_mute_when_headphones_are_plugged/unplugged_improperly>.
- [x] Recipe for removing packages is not working properly (too many packages removed).
- [x] Add guvcview in package to install (good replacement for cheese which is deadly GNOME refactored)
- [x] Restart X with <Ctrl><Alt>Backspace
- [x] XDG user dirs Templates, remove it.
- [x] mtrack does not seem to work with Ubuntu18.04. => apparrently it is fixed now 18-12-08
- [x] Caja: the side panel is not working correctly (and the rendering for painting the focuses/unfocused panel is a little ugly). => fixed in Caja v1.20.2
- [x] Geany redo should be <ctrl><shift>z
- [x] Geany tab at right opening of the tab will give 70% of the width to the tab rather than the editor. Save width of the tab? => just revert to sidebar at left
- [x] Add tree in default package to install.
- [x] Disable autostart of blueman-applet
- [x] It seems bluman is using 50MB in RAM and I never use the bluetooth. Would it be possible to disable it? => yes just rename the .desktop file in /etc/xdg/autostart
- [x] Completely remove references to termite
- [x] add mercurial
- [x] Should use `/usr/share/backgrounds` rather than `/usr/share/wallpapers`.
- [x] Do not show by default menubar in mate-terminal.
- [x] Switch back to MATE-Terminal (and archive the installation script for Termite)
- [x] Add install for 'psmisc' (not installed by default on Debian)
- [x] SSH Welcome message should not include Ubuntu message.
- [x] Path to JDK should to specified in .xsessionrc (will works on everything Linux distributions).
- [x] Geany default configuration should indent with "tab and space"
- [x] Fix indentation in TODOS.md
- [x] Open "Google Drive" from the menu should create a new Web Browser window, else Drive can be opened in the Web Browser in Desktop#1 but current desktop is Desktop#4.
- [x] Read <https://wiki.archlinux.org/index.php/File_manager_functionality>
- [x] Read <https://help.gnome.org/admin/system-admin-guide/stable/mime-types-custom.html.en>
- [x] Work with `/etc/mime.types` for setting all text with Geany, all audio/video with VLC.
- [x] Set MIME types using ~/.config/mimeapps.list.
- [x] The fix for the menu border adwaita gtk2 seems to not work anymore.
- [x] mate-power-manager always set to 100pc the keyboard backlight when it starts => did not find the problem, made a quickfix.
- [x] It seems config for geany is missing: side bar, message bar, toolbar only image.
- [x] Clean Openbox rc.xml and add openbox rc.xml v3.4 original for comparison.
- [x] XF86 keys (Explorer, Mail, WWW, Music, Messenger etc.). See <http://wiki.linuxquestions.org/wiki/XF86_keyboard_symbols>.
- [x] After some time of inactivity the displays are closed even if VLC is runnning fullscreen => can not replicate it.
- [x] Add a caja script compare which allow 1 or 2 arguments.
- [x] Width of the error zenity popup window => use option `--no-wrap`
- [x] Missing icon for the GUI component "spinner"-like, the '-' icon is an 'x' => use gtk inspector to find the missing icon. It can see the prorblem with obconf. See <http://linux-buddy.blogspot.com/2014/01/gtk-example-spinbutton.html>. See <https://github.com/GNOME/gtk/blob/master/demos/gtk-demo/spinbutton.c>. The problem is `list-remove.png` from Faenza. It could be fixed for all action icon by re-using/modifying the add icon.
- [x] re-add backup alias in bashrc.
- [x] Border for menus in GTK2 with Adwaita, it is quite important because we still have GTK2 application running: Thunar, GVim etc. See <http://www.techytalk.info/fix-clearlooks-gtk-2-theme-missing-menu-borders-on-java-applications/> and <https://azizsaboor.wordpress.com/2015/03/17/fixing-netbeans-menu-display-on-linux-missing-menu-borders-white-on-white-invisible-menu-items/>.
- [x] Add geany shorcut for moving line up/down.
- [x] Invert ctrl+k and ctrl+d? The shortcuts from Eclipse are quite well designed...
- [x] Add some bash function for working with time durations (or use some bc functions).
- [x] Quick tool for rendering chart? => gnu plot and plotdrop GTK GUI.
- [x] VNC with 2 screens => not possible, it is no has no concept of separate monitor, we should set the geometry to support the size of the 2 screens combined.
- [x] Find a search tool with GUI => FSearch seems interesting...
- [x] System monitor: CPU, Memory, I/O, network + add it to openbox menu. => use glances (don't like much mate-system-monitor but keep it installed)
- [x] Use dunst notification (for Translate-Notify especially) => missing dependencies `libxss-dev` and `libxdg-basedir1`
- [x] Caja seems to open MATE terminal (instead of x-terminal-emulator) => property to set in dconf
- [x] Add a `tail and follow` caja script.
- [x] No PulseAudio paman in Xubuntu 18.04 but do I really need it? => I can compile it from the sources, do not know why it is missing in Ubuntu 18.04 repository.
- [x] Use a Caja script for diff file/directory with meld, see <https://ubuntu-mate.community/t/copy-to-move-to-in-caja/15156/5>
- [x] install.sh should have a log indicating which recipe failed.
- [x] Disable gnome keyring.
- [x] Use `[Seat:*]` instead of `[Seat:defaults]`
- [x] No Geany Markdown plugin in Xubuntu 18.04 => `libwebkit2gtk-4.0-dev` need to be installed for compiling it and maybe it is not the case when Ubuntu build the geany-plugins package. Fix is: clone the geany-plugin git repo and make/make install the markdown plugin. 
- [x] XDMCP, xrdp and FreeRDP
- [x] Can I set the font size by default in the geany config files?
- [x] Openbox shortcut for minimizing the active window
- [x] Latex install (just install texlive)
- [x] Still some colors are not correct with Termite (htop) => openbox `rc.xml` was not correct and was starting htop with mate-terminal instead of termite (but no idea why the colors are not correct with mate-terminal).
- [x] Translate-notify should indicate when the clipboard is empty.
- [x] Rework a little bit the shortcuts `<win>c` should be clip menu, `<win>r` should be dmenu, `<win>z` should be translate notify
- [x] Should I use `--no-install-recommends` with apt? => yes, try with it for next install.
- [x] add CSVKit.
- [x] Add gnumeric, can be useful when LibreOffice crashes (and it happens quite often... ).
- [x] Waiting for window when launching command from dmenu? (and spinning cursor?) => StartNofity was `true` in openbox rc/xml
- [x] Translate feature should allow to type the text, use a dialog for that => use dmenu
- [x] Move translate-notify.sh in /usr/bin for being able to start it from dmenu, or add a folder of executables in dmenu.
- [x] Add `traceroute`.
- [x] Should use `#!/usr/bin/env bash` in particular for geany_one_instance_per_workspace.sh
- [x] How to disable the touch screen on the Dell Inspiron 7000?
- [x] Add configuration file for gsimplecal.
- [x] Switch to Adwaita: (1) Eclipse GUI looks better with Adwaita, (2) bug with Termite scrollbar seems to be fixed with Adwaita, (3) Gsimplecal is better rendered.
- [x] Disable recipe for mtrack because it is not working with Ubuntu18.04 (cursor jumps random and no right click).
- [x] How to improve Eclipse UI? It is ugly with Ubuntu 18.04. I was quite happy with Ubuntu 17.04/SWT_GTK3 => it is far better with Adwaita.
- [x] There is a problem with user recipe configure_gtk, the file `.gtk-bookmarks` does not exists.
- [x] Geany toolbar icon size => better with Adwaita.
- [x] install.sh should stop as soon as a recipe returns an error code.
- [x] Test for package availability in install_packages.sh should be optional.
- [x] Add the preferences for mate-power-manager.
- [x] Offline repository (from external USB disk) <https://askubuntu.com/questions/882255/i-do-not-fully-understand-wiki-aptget-offline>
- [x] Replace ClipIt by clipmenu <https://github.com/cdown/clipmenu/> or clipster <https://github.com/mrichar1/clipster>
- [x] Do not browse media when inserted.
- [x] Should invert F6 and F7 in geany shortcuts.
- [x] Compile alltray from source and use this fork of alltray <https://github.com/bill-auger/alltray>
- [x] If keyboard is properly configured via /etc/default/keyboard then no need to configure it via openbox autostart.
- [x] Clipboard persistence? It is sometimes annoying to see the clipboard is empty after exiting geany but we expected to do a paste somewhere. => install clipit and start it via openbox autostart.
- [x] polkit policy file for mate-power-manager and backlight helper is missing.
- [x] Path in Geany desktop file is using "~" which is not supported here.
- [x] Add a function check_package_availability using dpkg/apt => current implementation is using `aptitude search` because can not find relevent return code for `apt` and `dpkg`.
- [x] Is xfce4-volumed really is started via /etc/xdg/autostart/xfce4-volumed.desktop? If yes then we should not start it also from openbox autostart file.
- [x] Add xfce4-mime-settings in openbox menu
- [x] Example for NFS export => already in the `exports` file installed with the package manager
- [x] Add nfs-kernel-server to the install package list
- [x] Should remove apt.input file
- [x] .rpmdb and .wget-hsts are owned by root in the user home => they are created when installing Skype.
- [x] Should be able to categorize the packages in packages.list
- [x] Remove package whoopsie
- [x] Remove packages for Ubuntu update notifications "update-manager, update-manager-core, update-notifier, update-notifier-common, xubuntu-desktop, flashplugin-installer, ubuntu-release-upgrader-gtk"
- [x] Allow wake up with lid only
- [x] Macbook wakes up with usb mouse, remove this.
- [x] Each time a process is killed, the mouse cursor is "busy" why? Ubuntu error reporting? => it is Ubuntu whoopsie... Remove it.
- [x] Categorize the packages in packages.install.list + add lshw?
- [x] It can occurs that login after suspend/hibernate, the keyboard configuration is lost. 
- [x] Disable bluetooth at startup
- [x] One instance of Geany per workspace
- [x] Add an install bash function (to be used by system, user and specifics, just wait in argument the directory containing the recipes)
- [x] Add should not be run with admin rights (xmodmap in specifics macbook)
- [x] Install other HID implementation allowing the horizontal scroll from the trackpad
- [x] Touchpad is still too much sensitive in macbook air => use mtrack
- [x] Add geany markdown template
- [x] common.sh backup function is not checking directory or file
- [x] Patch line height for dmenu
- [x] Support NFS/samba + comments in /etc/fstab for how to mount the file systems
- [x] Force num lock at boot time (console and X)
- [x] Dialogs for suspend and hibernate not working from openbox menu?
- [x] Default for laptops in xfce4-power-manager settings
- [x] When suspended, the laptop is waked up by mouse move
- [x] Update or remove Install.md
- [x] VirtualBox Frogstar install should not be a script but rather a documentation
- [x] Auto_login and gandy_dns should not be in the list of the default recipes
- [x] Add kodos regular expression tester => No, can not compile, too old stuff
- [x] When config Geany, also put the .desktop file for forcing one instance per file opening (the one instance per workspace does not seem to work)
- [x] Geany shortcut for show/hide the sidebar?
- [x] Remove shotwell from packages.install.list => No shotwell should be installed by default
- [x] Try DockBarX
- [x] Put the trace files in a dedicated directory => NO, it is better like it is today
- [x] Clean: remove install_mate_1.17, ampache and deluge_deamon (keep it in the attic)
- [x] LightDM config
- [x] User recipe for Geany config should check geany version number + should compare original file with my dot file
- [x] Use Geany Markdown plugin
