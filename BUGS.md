# BUGS
- AllTray: when using `alltray -a` and if user types ESC then the window popup is still showed but there is nothing we can do with it except closing it.
- Caja: the side panel is not working (and the rendering for painting the focuses/unfocused panel is quite ugly).
- dmenu: for selecting on which monitor to appear, dmenu seems to use the monitor on which the currently focused window is located. It should use the mouse pointer location.
