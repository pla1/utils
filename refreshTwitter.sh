#!/bin/bash
#
# Refresh Google Plus stream via kiosk mode
#
sed -i -e 's/"exit_type": "Crashed",/"exit_type": "Normal",/g' ~/.config/google-chrome/Default/Preferences
google-chrome --kiosk https://twitter.com &
echo "Sleeping for a few seconds."
sleep 5
while :
do
	win=$(xdotool search --onlyvisible --name "Twitter" | head -1)
	echo "Window: $win"
	for i in `seq 1 250`;
        do
		xdotool type --clearmodifiers --window $win "j"
		sleep 5
        done
		xdotool key --clearmodifiers --window $win "ctrl+r"
	sleep 5
done
