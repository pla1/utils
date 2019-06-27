#!/bin/bash
#
# Record bottom right hand quad of 4K desktop.
#
ffmpeg -y -video_size 1920x1080 -framerate 25 -f x11grab -i :0.0+1920,1080 desktop.mp4
vlc desktop.mp4

