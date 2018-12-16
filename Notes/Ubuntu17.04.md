## Xubuntu 17.04: bug with VirtualBox guest additions 5.1.22 
virtualbox-guest-additions 5.1.22 seems to be buggy, unable to start Xorg. Install virtualbox-guest-additions 5.1.24 from <http://download.virtualbox.org/virtualbox> and it is working properly.

## Xubuntu 17.04: bug in Nouveau driver when switching to console if multiple monitors
It seems there is a bug in Nouveau driver with the framebuffer and when using multiple monitors. The boot is successful, X.org seems to start properly, but we can not switch to the console with <Ctrl><Alt>F{x}. If we plug only one monitor then we can switch to the console. With the NVidia driver 384, we can switch to console.
