**** 18-01-11 ****
- virtualbox-guest-additions 5.1.22 seems to be buggy, unable to start Xorg. Install virtualbox-guest-additions 5.1.24 from virtualbox website and it is working properly.
- It seems there is a bug in Nouveau driver with the framebuffer and when using multiple monitors. The boot is successful, xorgs seems to start properly, but we can not switch to the console with CTRL+ALT+F{x}. If we plug only one monitor then we can switch to the console. With the NVidia driver 384, we can also switch to console.
- console framebuffer change resolution in /etc/default/grub with: GRUB_GFXMODE=1024x768x32 and GRUB_GFXPAYLOAD_LINUX=keep (don't forget to call update-grub)

**** 18-01-12 ****
- using 'caja --no-desktop' in the .desktop file for mime type inode/directory seems to not work and don't know why => call directly "caja --no-desktop" from openbox rc.xml and menu.xml rather than 'xdg.open .'
