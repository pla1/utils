#!/bin/bash
#
# Refresh Google Plus stream via kiosk mode
#
while :
do
	win=$(xdotool search --onlyvisible "Google+" | head -1)
	echo "Window: $win"
	for i in `seq 1 100`;
        do
		xdotool type --clearmodifiers --window $win "j"
		sleep 3s
        done
	xdotool key --clearmodifiers --window $win "ctrl+r"
	sleep 3s
done

