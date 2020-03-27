# Evolution

## How to reset all Evolution settings
This is quite a GNOME nightmare again.  
See <https://askubuntu.com/questions/179340/how-to-reset-evolution-settings-to-defaults>

The commands below will also delete downloaded emails.

    evolution --force-shutdown
    rm -rf ~/.local/share/evolution
    rm -rf ~/.gconf/apps/evolution
    rm -rf ~/.cache/evolution
    rm -rf ~/.config/evolution
    dconf reset -f /org/gnome/evolution/

