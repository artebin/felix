## Test Ubuntu 17.10
1. BIOS corruption see <https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1734147>
2. The wallpaper used by LightdDM stays displayed after login
3. There is a problem with openbox, when a window is maximized, we cannot resize the window directly, we must change the window state to unmaximized first, however for a reason the unsucessful resizing changed the window size.
4. pasystray has some problem (but maybe it is because I am building pasystray from the source), the sound can be very loud and the volume amount corresponding to a mouse scroll step is very low.
5. There is some problem with the sound: cracking and bad quality audio (noticed with youtube, but it is clearly not about the original sound, the problem is in the local playback).
6. While copying a file on a external drive, the popup showing the file transfer is not shown, we can see the files in the file browser but the copy operation is still running. we tried to umount the external drive and then a popup is showed "operation on-going".
