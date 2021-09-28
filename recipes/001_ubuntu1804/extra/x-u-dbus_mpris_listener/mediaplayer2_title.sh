#!/usr/bin/env bash

show_mediaplayer2_metadata(){	
qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Metadata
}

mediaplayer2_title=$(qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Metadata \
| grep -F "vlc:nowplaying")

show_mediaplayer2_metadata

#title=$(echo ${mediaplayer2_title} | sed s/^vlc:nowplaying:\ //)
#echo -n ${title}
