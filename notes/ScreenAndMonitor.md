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

## Configure the DPMS

See <http://www.shallowsky.com/linux/x-screen-blanking.html> and its content below:

X offers two modes of screen blanking: BlankTime and DPMS. Settings for both can be queried via `xset -q`.

### Screen Saver

  * timeout

  * cycle

### DPMS is display power management.
It only works with displays that support that sort of power management (though I suspect most modern displays probably do). DPMS includes three settings:

  * Standby Time: In a CRT, this turns off the electron gun, but leaves everything else powered on so that the screen can recover quickly. The timeout defaults to 20 minutes.

  * Suspend Time: This turns off the monitor power supply in addition to the electron gun. By default this timeout is set to 30 minutes.

  * Off Time: This turns off all power to the monitor and is the most power conservative state. By default this happens after 40 minutes.
