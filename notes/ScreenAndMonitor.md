# Screen and Monitor

## Add and use a new resolution

    # Use `cvt` to retrieve the new mode parameters:
    # cvt 1920 1200 60
    #
    # It will returns:
    # Modeline "1920x1200_60.00"  193.25  1920 2056 2256 2592  1200 1203 1209 1245 -hsync +vsync
    
    xrandr --newmode "1920x1200"  193.25  1920 2056 2256 2592  1200 1203 1209 1245 -hsync +vsync
    xrandr --addmode VGA-1 "1920x1200"
    xrandr --output VGA-1 --primary --mode 1920x1200 --pos 0x0 --rotate normal
