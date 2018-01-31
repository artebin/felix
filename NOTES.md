# 18-01-30
Mouse sensitivity:
- `xinput list`
- `xinput --list-props <device id>`
- `xinput --set-prop <devide id> <property> <value>`
Could also use lxinput from lxde desktop.

# 18-01-30
- Setting up Frogstar: should add a static route in the router for re-directing the traffic from the local network (local host to trevize.net).
- When suspended and on a laptop, the wake up is done at mouse move.

# 18-01-29
- IPv6 seems can be preferred over IPv4, use `ping <hostname> -4`
- Library libdvdcss `apt-get install -y libdvd-pkg`

# 18-01-20
- Test Xubuntu 17.10:
	1. BIOS corruption see <https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1734147>
	2. the wallpaper used by LightdDM stays displayed after login
	3. there is a problem with openbox, when a window is maximized, we cannot resize the window directly, we must change the window state to unmaximized first, however for a reason the unsucessful resizing changed the window size.
	4. pasystray has some problem (but maybe it is because I am building pasystray from the source), the sound can be very loud and the volume amount corresponding to a mouse scroll step is very low.
	5. there is some problem with the sound: cracking and bad quality audio (noticed with youtube, but it is clearly not about the original sound, the problem is in the local playback).
	6. while copying a file on a external drive, the popup showing the file transfer is not shown, we can see the files in the file browser but the copy operation is still running. we tried to umount the external drive and then a popup is showed "operation on-going".

# 18-01-12
- using `caja --no-desktop` in the .desktop file for mime type inode/directory seems to not work and don't know why => call directly `caja --no-desktop` from openbox rc.xml and menu.xml rather than `xdg.open .`
- put environment variables in `/etc/profile.d/myenvvars.sh` rather than in `/etc/profile`
- `LD_LIRABRY_PATH` can not be set anymore from `/etc/environment` or `/etc/profile`, should use `/etc/ld.so.conf.d/somefile.conf`
- Java is not using ld.so.conf files we can check default value of java.library.path with: `java -XshowSettings:properties` => best thing is to create a symbolic link `ln -s /usr/lib/x86_64-linux-gnu/jni/libwibucmJNI64.so /usr/lib/libwibucmJNI64.so`

# 18-01-11
- virtualbox-guest-additions 5.1.22 seems to be buggy, unable to start Xorg. Install virtualbox-guest-additions 5.1.24 from <http://download.virtualbox.org/virtualbox> and it is working properly.
- It seems there is a bug in Nouveau driver with the framebuffer and when using multiple monitors. The boot is successful, xorgs seems to start properly, but we can not switch to the console with <Ctrl><Alt>F{x}. If we plug only one monitor then we can switch to the console. With the NVidia driver 384, we can also switch to console.
- console framebuffer change resolution in `/etc/default/grub` with: `GRUB_GFXMODE=1024x768x32` and `GRUB_GFXPAYLOAD_LINUX=keep` (don't forget to call update-grub)

# 16-09-28
Xubuntu 16.04: bug #1568604 "Mouse cursor lost when unlocking with Intel graphics": <https://bugs.launchpad.net/ubuntu/+source/xserver-xorg-video-intel/+bug/1568604>  
Solved by reinstalling intel driver, version 2:2.99.917+git20160706-1ubuntu1:
<https://launchpad.net/ubuntu/yakkety/+package/xserver-xorg-video-intel>
