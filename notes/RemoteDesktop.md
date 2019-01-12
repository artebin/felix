## Remote desktop
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
