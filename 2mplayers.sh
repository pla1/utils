#!/bin/bash 
# Watch 2 MythTV recordings with mplayer

mplayer -noborder -vo vdpau:deint=1 -ao null -geometry 640x360+0+0 $1 &
mplayer -noborder -vo vdpau:deint=1 -ao null -geometry 640x360+640+360 $2 & 




