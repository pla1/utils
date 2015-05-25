#!/bin/bash
#
# Refresh Google Plus stream via kiosk mode
#
/bin/sed -i -e 's/"exit_type": "Crashed",/"exit_type": "Normal",/g' ~/.config/google-chrome/Default/Preferences
logger "$0 Sleeping for a few seconds before starting Chrome."
sleep 2
/usr/bin/google-chrome --kiosk https://plus.google.com &
logger "$0 Sleeping for a few seconds before starting xdotool."
sleep 5
while :
do
	win=$(/usr/bin/xdotool search --onlyvisible --name "Google+" | head -1)
	echo "Window: $win"
	for i in `seq 1 250`;
        do
		/usr/bin/xdotool type --clearmodifiers --window $win "j"
		sleep 5
        done
	/usr/bin/xdotool key --clearmodifiers --window $win "ctrl+r"
	sleep 5
done
