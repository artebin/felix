# Felix

## GTK3 and libgtk3-nocsd

GTK3 Client Side Decoration (CSD) is removed with `libgtk3-nocsd`.  
The GTK Header Bar is still visible but the window decoration is rendered by the Window Manager and it can include: the window icon and the buttons for iconify/minimize, maximize, shade/roll up, sticky/omnipresent and close.  

Add the lines below to `xsessionrc`.

    # Force loading of libgtk3-nocsd
    export LD_PRELOAD="libgtk3-nocsd.so.0${LD_PRELOAD:+:$LD_PRELOAD}"

For not having the window title showed twice (i.e. in the window decoration and in the gtk header bar): make invisible the title in `gtk3.css` like below.

    /* CSD: collapse leftover when using gtk3-nocsd */
    headerbar {
    	margin-top: -100px;
    	border-bottom-width: 0;
    }
    /* but not when functional elements are in it */
    headerbar button,
    headerbar spinbutton,
    headerbar entry,
    headerbar separator {
    	margin-top: 103px;
    	margin-bottom: 3px;
    }

__References:__

  - <https://github.com/PCMan/gtk3-nocsd/issues/19>

## Print key does not work with Debian11
It occurs with 2 different Dell laptops (Inspiron 7737 and a Precision 7530).  

