#!/bin/bash
ffmpeg -y -video_size 1920x1080 -framerate 25 -f x11grab -i :0.0+0,0 desktop.mp4
vlc desktop.mp4

