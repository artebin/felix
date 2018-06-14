# BUGS
- AllTray: when using `alltray -a` and if user types ESC then the window popup is still showed but there is nothing we can do with it except closing it.
- Alltray: is not placing the docked window in the current workspace but rather it switches current the current desktop to be the one used when the window has been docked.
- Caja: the side panel is not working (and the rendering for painting the focuses/unfocused panel is quite ugly).
- dmenu: for selecting on which monitor to appear, dmenu seems to use the monitor on which the currently focused window is located. It should use the mouse pointer location.
- Geany: markdown plugin is not using properly the css specified (colors are used and lines starting with the character `#` inside a blockcode is treated as a heading.
