#!/bin/bash 
# Watch 4 MythTV recordings with mplayer

mplayer -noborder -vo vdpau:deint=1 -ao null -geometry 640x360+0+0 /mnt/disk0/mythtv/recordings/1241_20101121130000.mpg &
mplayer -noborder -vo vdpau:deint=1 -ao null -geometry 640x360+640+0 /mnt/disk0/mythtv/recordings/1051_20101121130000.mpg & 
mplayer -noborder -vo vdpau:deint=1 -ao null -geometry 640x360+0+360 /mnt/disk0/mythtv/recordings/1021_20101114201500.mpg &
mplayer -noborder -vo vdpau:deint=1 -ao null -geometry 640x360+640+360 /mnt/disk0/mythtv/recordings/1021_20101107201500.mpg & 




